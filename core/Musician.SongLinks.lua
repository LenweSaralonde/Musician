--- Song links module
-- @module Musician.SongLinks

Musician.SongLinks = LibStub("AceAddon-3.0"):NewAddon("Musician.SongLinks", "AceComm-3.0", "AceEvent-3.0")

local MODULE_NAME = "SongLinks"
Musician.AddModule(MODULE_NAME)

local ChatEdit_LinkItem                    = ChatFrameUtil and ChatFrameUtil.LinkItem or ChatEdit_LinkItem
local ChatFrame_AddMessageEventFilter      = ChatFrameUtil and ChatFrameUtil.AddMessageEventFilter or
	ChatFrame_AddMessageEventFilter

local LibDeflate                           = LibStub:GetLibrary("LibDeflate")
local LibBase64                            = LibStub:GetLibrary("LibBase64")
local LibCRC32                             = LibStub:GetLibrary("LibCRC32")

Musician.SongLinks.event                   = {}
Musician.SongLinks.event.song              = "MusicianSongSnd"
Musician.SongLinks.event.requestSong       = "MusicianSongRqt"
Musician.SongLinks.event.songError         = "MusicianSongErr"

Musician.SongLinks.errors                  = {}
Musician.SongLinks.errors.notFound         = 'notFound'
Musician.SongLinks.errors.alreadySending   = 'alreadySending'
Musician.SongLinks.errors.alreadyRequested = 'alreadyRequested'
Musician.SongLinks.errors.timeout          = 'timeout'
Musician.SongLinks.errors.offline          = 'offline'
Musician.SongLinks.errors.importingFailed  = 'importingFailed'

Musician.SongLinks.status                  = {}
Musician.SongLinks.status.requested        = 'requested'
Musician.SongLinks.status.downloading      = 'downloading'
Musician.SongLinks.status.importing        = 'importing'

Musician.SongLinks.supportsContext         = true

local sharedSongs                          = {}
local sendingSongs                         = {}
local requestedSongs                       = {}

local BNetCommHandlers                     = {}

local RECEIVING_PROGRESSION_RATIO          = .9
local REQUEST_TIMEOUT                      = 30
local MAX_TITLE_LENGTH                     = 48

local HYPERLINK_PREFIX                     = 'musicianSong'
local CHAT_LINK_PREFIX                     = 'Musician'
local LINK_COLOR                           = '00FFFF'
local CHAT_MSG_EVENTS                      = {
	"CHAT_MSG_CHANNEL",
	"CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_EMOTE", "CHAT_MSG_TEXT_EMOTE",
	"CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_INSTANCE_CHAT", "CHAT_MSG_INSTANCE_CHAT_LEADER",
	"CHAT_MSG_GUILD", "CHAT_MSG_OFFICER",
	"CHAT_MSG_WHISPER", "CHAT_MSG_WHISPER_INFORM",
	"CHAT_MSG_BN_WHISPER", "CHAT_MSG_BN_WHISPER_INFORM"
}
local BUBBLE_CHAT_MSG_EVENTS               = {
	"CHAT_MSG_SAY", "CHAT_MSG_YELL",
	"CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_INSTANCE_CHAT", "CHAT_MSG_INSTANCE_CHAT_LEADER",
}

--- Print communication debug message
-- @param out (boolean) Outgoing message
-- @param event (string)
-- @param source (string)
-- @param message (string)
-- @param ... (string)
local function debugComm(out, event, source, message, ...)
	local prefix
	if out then
		prefix = "|cFFFF0000>>>>>|r"
	else
		prefix = "|cFF00FF00<<<<<|r"
	end

	if type(source) == "table" then
		source = table.concat(source, ":")
	end

	event = "|cFFFF8000" .. event .. "|r"
	source = "|cFF00FFFF" .. source .. "|r"

	Musician.Utils.Debug(MODULE_NAME, prefix, event, source, message, ...)
end

--- Print debug message
-- @param message (string)
-- @param ... (string)
local function debug(message, ...)
	Musician.Utils.Debug(MODULE_NAME, message, ...)
end

--- Simplified version of AceComm's SendCommMessage that only supports short (not multipart) communication messages but supports Battle.net.
-- @param prefix (string) A printable character (\032-\255) classification of the message (typically AddonName or AddonNameEvent)
-- @param text (string) Data to send, nils (\000) not allowed. Any length.
-- @param distribution (string) Addon channel, e.g. "RAID", "GUILD", etc; see SendAddonMessage API
-- @param target (string) Destination for some distributions; see SendAddonMessage API or valid Battle.net game account ID
-- @param [prio] (string) OPTIONAL: ChatThrottleLib priority, "BULK", "NORMAL" or "ALERT". Defaults to "NORMAL".
-- @param [callbackFn] (function) OPTIONAL: callback function to be called as each chunk is sent. receives 3 args: the user supplied arg (see next), the number of bytes sent so far, and the number of bytes total to send.
-- @param [callbackArg] (any): OPTIONAL: first arg to the callback function. nil will be passed if not specified.
function Musician.SongLinks:SendCommMessage(prefix, text, distribution, target, prio, callbackFn, callbackArg)
	-- Injecting target in the queue name to evenly share the bandwidth among them
	local queueName = prefix .. " " .. distribution .. " " .. target
	local ctlCallback
	if callbackFn then
		ctlCallback = function(_, sendResult)
			return callbackFn(callbackArg, #text, #text, sendResult)
		end
	end
	if distribution == 'WHISPER' and Musician.Utils.IsBattleNetID(target) then
		if Musician.Utils.IsBattleNetGameAccountOnline(target) then
			ChatThrottleLib:BNSendGameData(prio, prefix, text, distribution, target, queueName, ctlCallback)
		end
	else
		ChatThrottleLib:SendAddonMessage(prio, prefix, text, distribution, target, queueName, ctlCallback)
	end
end

--- Alternative to AceComm's SendCommMessage() to support Battle.net and avoid problems when the chunks are received in the wrong order.
-- @param prefix (string) A printable character (\032-\255) classification of the message (typically AddonName or AddonNameEvent)
-- @param text (string) Data to send, nils (\000) not allowed. Any length.
-- @param distribution (string) Addon channel, e.g. "RAID", "GUILD", etc; see SendAddonMessage API
-- @param target (string) Destination for some distributions; see SendAddonMessage API or valid Battle.net game account ID
-- @param [prio] (string) OPTIONAL: ChatThrottleLib priority, "BULK", "NORMAL" or "ALERT". Defaults to "NORMAL".
-- @param [callbackFn] (function) OPTIONAL: callback function to be called as each chunk is sent. receives 3 args: the user supplied arg (see next), the number of bytes sent so far, and the number of bytes total to send.
-- @param [callbackArg] (any): OPTIONAL: first arg to the callback function. nil will be passed if not specified.
function Musician.SongLinks:SendIndexedCommMessage(prefix, text, distribution, target, prio, callbackFn, callbackArg)
	local isBnet = distribution == 'WHISPER' and Musician.Utils.IsBattleNetID(target)
	local queueName = prefix .. " " .. distribution .. " " .. target
	local chunkSize = 255 - 10 -- Base64-serialized header is 10 bytes long
	local textlen = #text
	local chunkCount = math.ceil(textlen / chunkSize)
	local crc32 = LibCRC32:hash(text)
	local packedCrc32 = Musician.Utils.PackNumber(crc32, 4)
	local cursor = 1
	local totalSent = 0
	for index = 1, chunkCount do
		-- Encode chunk count and indexes on 3 bytes. This allows message length up to ~2 GB, which should be enough.
		-- Resulting base64-encoded index is 4 bytes long.
		local controlBytes
		if index == 1 then
			-- The first controlBytes contains the total number of chunks, with the first bit set to 1
			controlBytes = bit.bor(chunkCount, 0x800000)
		else
			-- The other controlBytes contains the index number, with the first bit set to 0
			controlBytes = bit.band(index, 0x7FFFFF)
		end
		local packedControlBytes = Musician.Utils.PackNumber(controlBytes, 3)
		local serializedHeader = string.sub(LibBase64:enc(packedCrc32 .. packedControlBytes), 1, 10) -- Strip the 2 padding characters
		local chunk = string.sub(text, cursor, cursor + chunkSize - 1)
		local indexedChunk = serializedHeader .. chunk

		-- Send chunk
		local currentIndex = index
		local function ctlCallback(_, sendResult)
			if sendResult then
				totalSent = totalSent + #chunk
			end
			-- Run callback for the last sent chunk
			if currentIndex == chunkCount then
				return callbackFn(callbackArg, totalSent, textlen, sendResult)
			end
		end
		if isBnet then
			ChatThrottleLib:BNSendGameData(prio, prefix, indexedChunk, distribution, target, queueName, ctlCallback)
		else
			ChatThrottleLib:SendAddonMessage(prio, prefix, indexedChunk, distribution, target, queueName, ctlCallback)
		end

		-- Ready for the next round!
		cursor = cursor + chunkSize
	end
end

--- Handler for short (not multipart) Battle.net messages, similar to AceComm's RegisterComm().
-- @param prefix (string) A printable character (\032-\255) classification of the message (typically AddonName or AddonNameEvent), max 16 characters
-- @param method (function) Callback to call on message reception: Function reference, or method name (string) to call on self. Defaults to "OnCommReceived"
function Musician.SongLinks:RegisterBNetComm(prefix, method)
	BNetCommHandlers[prefix] = method
end

--- Same as AceComm's RegisterComm but for multipart communication message with indexed chunks. Supports Battle.net messages.
-- @param prefix (string) A printable character (\032-\255) classification of the message (typically AddonName or AddonNameEvent), max 16 characters
-- @param method (function) Callback to call on message reception: Function reference, or method name (string) to call on self. Defaults to "OnCommReceived"
-- @param [isBnet] (boolean) Register Battle.net messages when true
function Musician.SongLinks:RegisterIndexedComm(prefix, method, isBnet)
	local messages = {}

	local function onIndexedChunk(_, messageWithIndex, distribution, sender)
		-- Get message ID, control bytes and CRC32 from message header
		local header = LibBase64:dec(string.sub(messageWithIndex, 1, 10))
		local crc32 = Musician.Utils.UnpackNumber(string.sub(header, 1, 4))
		local controlBytes = Musician.Utils.UnpackNumber(string.sub(header, 5, 7))
		local messageId = prefix .. ' ' .. sender .. ' ' .. crc32

		-- Create new message object
		if messages[messageId] == nil then
			messages[messageId] = {
				chunks = {},
				count = 0,
				downloaded = 0,
				wipe = function()
					messages[messageId].timeout:Cancel()
					wipe(messages[messageId].chunks)
					wipe(messages[messageId])
					messages[messageId] = nil
				end
			}
		end
		local message = messages[messageId]

		-- Add chunk
		local index = 1
		if bit.band(controlBytes, 0x800000) == 0x800000 then
			-- First chunk: get number of chunks
			local chunkCount = bit.band(controlBytes, 0x7FFFFF)
			message.count = chunkCount
		else
			-- Get chunk index
			index = bit.band(controlBytes, 0x7FFFFF)
		end
		message.downloaded = message.downloaded + 1
		message.chunks[index] = string.sub(messageWithIndex, 11)

		-- Handle timeout
		if message.timeout then
			message.timeout:Cancel()
		end
		message.timeout = C_Timer.NewTimer(REQUEST_TIMEOUT, message.wipe)

		-- Download complete
		if message.downloaded == message.count then
			local text = ''
			for i = 1, message.count do
				text = text .. message.chunks[i]
				message.chunks[i] = nil
			end
			message.wipe()
			method(prefix, text, distribution, sender)
		end
	end

	if isBnet then
		Musician.SongLinks:RegisterBNetComm(prefix, onIndexedChunk)
	else
		Musician.SongLinks:RegisterComm(prefix, onIndexedChunk)
	end
end

--- Same as RegisterIndexedComm but for Battle.net messages only.
-- @param prefix (string) A printable character (\032-\255) classification of the message (typically AddonName or AddonNameEvent), max 16 characters
-- @param method (function) Callback to call on message reception: Function reference, or method name (string) to call on self. Defaults to "OnCommReceived"
function Musician.SongLinks:RegisterIndexedBNetComm(prefix, method)
	Musician.SongLinks:RegisterIndexedComm(prefix, method, true)
end

--- Initialize song links
--
function Musician.SongLinks.Init()
	-- Track song import progression
	Musician.SongLinks:RegisterMessage(Musician.Events.SongImportProgress, Musician.SongLinks.OnSongImportProgress)

	-- Register communication for game chat
	Musician.SongLinks:RegisterIndexedComm(Musician.SongLinks.event.song, Musician.SongLinks.OnSongReceived)
	Musician.SongLinks:RegisterComm(Musician.SongLinks.event.requestSong, Musician.SongLinks.OnRequestSong)
	Musician.SongLinks:RegisterComm(Musician.SongLinks.event.songError, Musician.SongLinks.OnSongError)
	Musician.SongLinks:RegisterEvent("CHAT_MSG_ADDON", Musician.SongLinks.OnSongData)

	-- Register communication for Battle.net chat
	Musician.SongLinks:RegisterIndexedBNetComm(Musician.SongLinks.event.song, Musician.SongLinks.OnSongReceived)
	Musician.SongLinks:RegisterBNetComm(Musician.SongLinks.event.requestSong, Musician.SongLinks.OnRequestSong)
	Musician.SongLinks:RegisterBNetComm(Musician.SongLinks.event.songError, Musician.SongLinks.OnSongError)
	Musician.SongLinks:RegisterEvent("BN_CHAT_MSG_ADDON", function(event, prefix, ...)
		-- Call handlers registered using RegisterBNetComm()
		if BNetCommHandlers[prefix] then
			BNetCommHandlers[prefix](prefix, ...)
		end
		-- Also call the low level handler OnSongData to update the progression
		Musician.SongLinks.OnSongData(event, prefix, ...)
	end)

	-- Replace song links in chat bubbles
	for _, event in pairs(BUBBLE_CHAT_MSG_EVENTS) do
		Musician.SongLinks:RegisterEvent(event, Musician.SongLinks.OnChatBubbleMsg)
	end

	-- Convert hyperlinks to plain text chat links before sending messages
	local function getSubstituteChatMessageBeforeSendHook(originalFunction)
		return function(msg)
			msg = originalFunction(msg)
			msg = Musician.SongLinks.HyperlinksToChatLinks(msg)
			return msg
		end
	end
	if ChatFrameUtil and ChatFrameUtil.SubstituteChatMessageBeforeSend then
		ChatFrameUtil.SubstituteChatMessageBeforeSend =
			getSubstituteChatMessageBeforeSendHook(ChatFrameUtil.SubstituteChatMessageBeforeSend)
	else
		SubstituteChatMessageBeforeSend =
			getSubstituteChatMessageBeforeSendHook(SubstituteChatMessageBeforeSend)
	end

	-- Convert received plain text chat links into hyperlinks
	local messageEventFilter = function(self, event, msg, sender, ...)
		local player = sender
		if event == 'CHAT_MSG_WHISPER_INFORM' or event == 'CHAT_MSG_BN_WHISPER_INFORM' then
			player = UnitName('player')
		elseif event == 'CHAT_MSG_BN_WHISPER' then
			local _, _, _, _, _, _, _, _, _, _, bnSenderID = ...
			player = tonumber(bnSenderID)
		end
		msg = Musician.SongLinks.ChatLinksToHyperlinks(msg, player)
		return false, msg, sender, ...
	end
	for _, event in pairs(CHAT_MSG_EVENTS) do
		ChatFrame_AddMessageEventFilter(event, messageEventFilter)
	end

	-- Hyperlink hooks
	LinkUtil.RegisterLinkHandler(HYPERLINK_PREFIX, function(link, text)
		local args = { strsplit(':', link) }
		if not IsModifiedClick("CHATLINK") then
			-- Extract player name
			local player = args[2] or UnitName('player')

			-- Extract title
			local title = string.match(text, '%[[^:]+: *([^%]]+)%]')

			-- Trigger SongLink event
			Musician.SongLinks:SendMessage(Musician.Events.SongLink, title, player)
		else
			-- Send back the link to the chat if modified click
			ChatEdit_LinkItem(nil, text)
		end
	end)
end

--- Normalize song title for links
-- @param title (string)
-- @return normalizedTitle (string)
function Musician.SongLinks.NormalizeTitleForLinks(title)
	local normalizedTitle = title

	-- Escape special characters
	normalizedTitle = string.gsub(normalizedTitle, '|+', ' – ')
	normalizedTitle = string.gsub(normalizedTitle, '%[', '(')
	normalizedTitle = string.gsub(normalizedTitle, '%]', ')')

	-- Remove duplicate spaces
	normalizedTitle = string.gsub(normalizedTitle, ' +', ' ')
	normalizedTitle = strtrim(normalizedTitle)

	-- Shorten title if it exceeds the max length
	normalizedTitle = Musician.Utils.Ellipsis(normalizedTitle, MAX_TITLE_LENGTH)

	return normalizedTitle
end

--- Format song hyperlink
-- @param title (string)
-- @param[opt] playerName (string)
-- @return link (string)
function Musician.SongLinks.GetHyperlink(title, playerName)
	local prefix = Musician.Utils.GetMsg('LINKS_PREFIX')
	local format = Musician.Utils.GetMsg('LINKS_FORMAT')

	local linkText = '[' .. format .. ']'
	linkText = string.gsub(linkText, '{prefix}', prefix)
	linkText = string.gsub(linkText, '{title}', Musician.SongLinks.NormalizeTitleForLinks(title))
	linkText = Musician.Utils.Highlight(linkText, LINK_COLOR)

	if playerName == nil or playerName == '' or Musician.Utils.PlayerIsMyself(playerName) then
		return Musician.Utils.GetLink(HYPERLINK_PREFIX, linkText)
	else
		return Musician.Utils.GetLink(HYPERLINK_PREFIX, linkText, Musician.Utils.NormalizePlayerName(playerName))
	end
end

--- Format song link for chat
-- @param title (string)
-- @param[opt] playerName (string)
-- @return link (string)
function Musician.SongLinks.GetChatLink(title, playerName)
	local normalizedTitle = Musician.SongLinks.NormalizeTitleForLinks(title)
	if playerName == nil or playerName == '' or Musician.Utils.PlayerIsMyself(playerName) then
		return '[' .. CHAT_LINK_PREFIX .. ': ' .. normalizedTitle .. ']'
	else
		return '[' .. CHAT_LINK_PREFIX ..
			'<' .. Musician.Utils.NormalizePlayerName(playerName) .. '>: ' ..
			normalizedTitle .. ']'
	end
end

--- Convert hyperlinks into text links for sending in the chat
-- @param text (string)
-- @return msg (string)
function Musician.SongLinks.HyperlinksToChatLinks(text)
	local capturePattern = '|H' .. HYPERLINK_PREFIX .. ':?([^|]*)|h[^%[]*%[[^:]+: ([^%]]+)%]|r|h'
	text = string.gsub(text, capturePattern, function(playerArg, titleArg)
		return Musician.SongLinks.GetChatLink(titleArg, playerArg)
	end)
	-- Add spaces between links to prevent the message from failing through Battle.net messaging
	text = string.gsub(text, '%]%[' .. CHAT_LINK_PREFIX, '] [' .. CHAT_LINK_PREFIX)
	return text
end

--- Convert chat text links into hyperlinks
-- @param msg (string)
-- @param[opt] playerName (string)
-- @return text (string)
function Musician.SongLinks.ChatLinksToHyperlinks(msg, playerName)
	local capturePattern = '%[' .. CHAT_LINK_PREFIX .. '<?([^>:]*)>?: ([^%]]*)%]'
	return (string.gsub(msg, capturePattern, function(playerArg, titleArg)
		local title = Musician.Utils.RemoveHighlight(titleArg) -- Remove text coloring added by other addons such as Total RP
		local player = playerArg ~= '' and playerArg or playerName or ''
		return Musician.SongLinks.GetHyperlink(title, player)
	end))
end

--- Convert chat links for chat bubbles
-- @param msg (string)
-- @return text (string)
function Musician.SongLinks.ChatLinksToChatBubble(msg)
	local capturePattern = '%[' .. CHAT_LINK_PREFIX .. '<?([^>:]*)>?: ([^%]]*)%]'
	return (string.gsub(msg, capturePattern, function(_, titleArg)
		local text = Musician.Msg.LINKS_CHAT_BUBBLE
		text = string.gsub(text, '{note}', Musician.Utils.GetChatIcon(Musician.IconImages.Note))
		text = string.gsub(text, '{title}', Musician.Utils.RemoveHighlight(titleArg)) -- Remove text coloring added by other addons such as Total RP
		return text
	end))
end

--- OnChatBubbleMsg
-- Replace chat links in chat bubbles
function Musician.SongLinks.OnChatBubbleMsg(event)
	C_Timer.After(0, function()
		local bubbles = C_ChatBubbles.GetAllChatBubbles()
		for _, bubble in pairs(bubbles) do
			local text = bubble:GetChildren().String:GetText()
			if bubble.MusicianReplacedText ~= text then
				bubble.MusicianReplacedText = Musician.SongLinks.ChatLinksToChatBubble(text)
				bubble:GetChildren().String:SetText(bubble.MusicianReplacedText)
			end
		end
	end)
end

--- Export and add song for sharing
-- @param song (Musician.Song)
-- @param[opt] title (string)
-- @param[opt] onComplete (function)
function Musician.SongLinks.AddSong(song, title, onComplete)
	if title == nil then
		title = song.name
	end

	local normalizedTitle = Musician.SongLinks.NormalizeTitleForLinks(title)
	song:ExportCompressed(function(songData)
		Musician.SongLinks.AddSongData(songData, normalizedTitle)
		if onComplete then
			onComplete(normalizedTitle)
		end
	end)
end

--- Add song data for sharing
-- @param songData (string)
-- @param title (string)
function Musician.SongLinks.AddSongData(songData, title)
	local normalizedTitle = Musician.SongLinks.NormalizeTitleForLinks(title)
	sharedSongs[normalizedTitle] = songData
	debug("Added song for sharing", normalizedTitle)
end

--- Returns requestedSong data for the player
-- @param playerName (string)
-- @return requestedSong (table)
function Musician.SongLinks.GetRequestingSong(playerName)
	playerName = Musician.Utils.NormalizePlayerName(playerName)
	return requestedSongs[playerName]
end

--- Request a song for download to a player
-- @param title (string)
-- @param playerName (string)
-- @param[opt=false] dataOnly (boolean)
-- @param[opt] context (table) Reference to the module that initiated the song request.
function Musician.SongLinks.RequestSong(title, playerName, dataOnly, context)
	playerName = Musician.Utils.NormalizePlayerName(playerName)

	-- Song is already being requested
	if requestedSongs[playerName] ~= nil then
		Musician.SongLinks:SendMessage(Musician.Events.SongReceiveFailed, playerName,
			Musician.SongLinks.errors.alreadyRequested, title, context)
		return
	end

	-- Timeout function
	local onTimeout = function()
		if requestedSongs[playerName] == nil then return end
		debug("Timed out after", REQUEST_TIMEOUT, playerName, title)
		Musician.SongLinks.RemoveRequest(playerName)
		Musician.SongLinks:SendMessage(Musician.Events.SongReceiveComplete, playerName, context)
		Musician.SongLinks:SendMessage(Musician.Events.SongReceiveFailed, playerName, Musician.SongLinks.errors.timeout,
			title
			, context)
	end

	-- Add song request
	requestedSongs[playerName] = {
		title = title,
		context = context,
		status = Musician.SongLinks.status.requested,
		total = 0,
		downloaded = 0,
		progress = nil,
		song = nil,
		dataOnly = dataOnly,
		onTimeout = onTimeout,
		timeoutTimer = C_Timer.NewTimer(REQUEST_TIMEOUT, onTimeout)
	}

	Musician.SongLinks:SendMessage(Musician.Events.SongReceiveStart, playerName, context)

	-- Send song request to player
	debugComm(true, Musician.SongLinks.event.requestSong, playerName, title)
	Musician.SongLinks:SendCommMessage(Musician.SongLinks.event.requestSong, title, 'WHISPER', playerName, 'ALERT')
end

--- Remove a song download request
-- @param playerName (string)
function Musician.SongLinks.RemoveRequest(playerName)
	playerName = Musician.Utils.NormalizePlayerName(playerName)

	local requestedSong = requestedSongs[playerName]

	if requestedSong == nil then return end

	requestedSongs[playerName] = nil

	if requestedSong.timeoutTimer then
		requestedSong.timeoutTimer:Cancel()
	end

	if requestedSong.status == Musician.SongLinks.status.importing then
		requestedSong.song:CancelImport()
	end

	wipe(requestedSong)
end

--- Cancel a song download request
-- @param playerName (string)
function Musician.SongLinks.CancelRequest(playerName)
	playerName = Musician.Utils.NormalizePlayerName(playerName)
	local context = requestedSongs[playerName] and requestedSongs[playerName].context or nil
	Musician.SongLinks.RemoveRequest(playerName)
	Musician.SongLinks:SendMessage(Musician.Events.SongReceiveComplete, playerName, context)
	Musician.SongLinks:SendMessage(Musician.Events.SongReceiveCanceled, playerName, context)
end

--- OnRequestSong
--
function Musician.SongLinks.OnRequestSong(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	debugComm(false, Musician.SongLinks.event.requestSong, sender, message)
	Musician.SongLinks.SendSong(message, sender)
end

--- OnSongError
--
function Musician.SongLinks.OnSongError(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	local errorCode, title = string.match(message, "^([^ ]+) (.*)")
	debugComm(false, Musician.SongLinks.event.songError, sender, errorCode, title)
	local context = requestedSongs[sender] and requestedSongs[sender].context or nil
	Musician.SongLinks.RemoveRequest(sender)
	Musician.SongLinks:SendMessage(Musician.Events.SongReceiveComplete, sender, context)
	Musician.SongLinks:SendMessage(Musician.Events.SongReceiveFailed, sender, errorCode, title, context)
end

--- Send song to another player by title
-- @param title (string)
-- @param playerName (string)
function Musician.SongLinks.SendSong(title, playerName)
	playerName = Musician.Utils.NormalizePlayerName(playerName)

	-- Song not available in shared songs list
	if sharedSongs[title] == nil then
		debug("Song not found")
		local message = Musician.SongLinks.errors.notFound .. ' ' .. title
		debugComm(true, Musician.SongLinks.event.songError, playerName, message)
		Musician.SongLinks:SendCommMessage(Musician.SongLinks.event.songError, message, 'WHISPER', playerName, 'ALERT')
		return
	end

	-- Send song data
	Musician.SongLinks.SendSongData(title, playerName, sharedSongs[title])
end

--- Send song data to another player
-- @param title (string)
-- @param playerName (string)
-- @param songData (string)
function Musician.SongLinks.SendSongData(title, playerName, songData)
	playerName = Musician.Utils.NormalizePlayerName(playerName)

	debug("Sending song", playerName, title)

	-- Already sending a song to the player
	if sendingSongs[playerName] then
		debug("Song already sending")
		local message = Musician.SongLinks.errors.alreadySending .. ' ' .. title
		debugComm(true, Musician.SongLinks.event.songError, playerName, message)
		Musician.SongLinks:SendCommMessage(Musician.SongLinks.event.songError, message, 'WHISPER', playerName, 'ALERT')
		return
	end

	sendingSongs[playerName] = title

	local encodedData
	if Musician.Utils.IsBattleNetID(playerName) then
		-- Encode in base 64 for sending through Battle.net
		-- Base64 encoding overhead is less important than EncodeForWoWChatChannel()
		encodedData = LibBase64:enc(songData)
	else
		encodedData = LibDeflate:EncodeForWoWAddonChannel(songData)
	end

	-- Send song
	debugComm(true, Musician.SongLinks.event.song, playerName, title, #encodedData)
	Musician.SongLinks:SendIndexedCommMessage(Musician.SongLinks.event.song, encodedData, 'WHISPER', playerName, 'NORMAL',
		function(_, sent, total)
			-- Song upload complete
			if sent == total then
				sendingSongs[playerName] = nil
			end
		end)
end

--- OnSongData
-- Notify download progression
function Musician.SongLinks.OnSongData(event, prefix, message, distribution, sender)
	if prefix ~= Musician.SongLinks.event.song then return end

	sender = Musician.Utils.NormalizePlayerName(sender)

	local requestedSong = requestedSongs[sender]

	if requestedSong == nil then return end

	-- Reset timeout timer
	if requestedSong.timeoutTimer then
		requestedSong.timeoutTimer:Cancel()
		requestedSong.timeoutTimer = C_Timer.NewTimer(REQUEST_TIMEOUT, requestedSong.onTimeout)
	end

	-- Determine progression from chunk control bytes
	local header = LibBase64:dec(string.sub(message, 1, 10))
	local controlBytes = Musician.Utils.UnpackNumber(string.sub(header, 5, 7))

	-- This is the first index with the number of chunks
	if bit.band(0x800000, controlBytes) == 0x800000 then
		local chunkCount = bit.band(0x7FFFFF, controlBytes)
		requestedSong.status = Musician.SongLinks.status.downloading
		requestedSong.total = chunkCount
	end

	-- Update received data length
	requestedSong.downloaded = requestedSong.downloaded + 1

	-- Lost chunk (may happen after a /reload while receiving a song)
	if requestedSong.total == 0 then return end

	local receivingProgressionRatio = requestedSong.dataOnly and 1 or RECEIVING_PROGRESSION_RATIO
	local progress = receivingProgressionRatio * requestedSong.downloaded / requestedSong.total
	requestedSong.progress = progress
	Musician.SongLinks:SendMessage(Musician.Events.SongReceiveProgress, sender, progress, requestedSong.context)
end

--- OnSongImportProgress
-- Notify import progression
function Musician.SongLinks.OnSongImportProgress(event, song, importProgress)
	if song.sender then
		local totalProgress = RECEIVING_PROGRESSION_RATIO + (1 - RECEIVING_PROGRESSION_RATIO) * importProgress
		local context
		if requestedSongs[song.sender] then
			requestedSongs[song.sender].progress = totalProgress
			context = requestedSongs[song.sender].context
		end
		Musician.SongLinks:SendMessage(Musician.Events.SongReceiveProgress, song.sender, totalProgress, context)
	end
end

--- OnSongReceived
-- Song data has been received
function Musician.SongLinks.OnSongReceived(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	debugComm(false, Musician.SongLinks.event.song, sender, #message)
	local requestedSong = requestedSongs[sender]

	if requestedSong == nil then return end

	local context = requestedSongs[sender].context
	local songData
	if Musician.Utils.IsBattleNetID(sender) then
		songData = LibBase64:dec(message)
	else
		songData = LibDeflate:DecodeForWoWAddonChannel(message)
	end

	-- Data only
	if requestedSong.dataOnly then
		Musician.SongLinks.RemoveRequest(sender)
		Musician.SongLinks:SendMessage(Musician.Events.SongReceiveComplete, sender, context)
		debug("Song downloading complete (data only)", requestedSong.title)
		Musician.SongLinks:SendMessage(Musician.Events.SongReceiveSuccessful, sender, songData, nil, context)
		return
	end

	local song = Musician.Song.create()
	song.sender = sender

	requestedSong.song = song
	requestedSong.status = Musician.SongLinks.status.importing
	requestedSong.timeoutTimer:Cancel()
	requestedSong.timeoutTimer = nil
	local title = requestedSong.title
	song:ImportCompressed(songData, false, function(success)
		Musician.SongLinks.RemoveRequest(sender)
		Musician.SongLinks:SendMessage(Musician.Events.SongReceiveComplete, sender, context)
		if success then
			debug("Song downloading complete", song.name)
			Musician.SongLinks:SendMessage(Musician.Events.SongReceiveSuccessful, sender, songData, song, context)
		else
			debug("Song downloading failed")
			Musician.SongLinks:SendMessage(Musician.Events.SongReceiveFailed, sender,
				Musician.SongLinks.errors.importingFailed,
				title, context)
		end
	end)
end

--- Prevent the chat edit box from closing when the button is clicked.
-- @param button (Button)
function Musician.SongLinks.PreventChatCloseOnFocus(button)
	button:HookScript("OnEnter", function()
		local activeChatWindow = ChatFrameUtil and ChatFrameUtil.GetActiveWindow and ChatFrameUtil.GetActiveWindow() or
			ACTIVE_CHAT_EDIT_BOX
		if activeChatWindow then
			if ChatFrameEditBoxMixin and ChatFrameEditBoxMixin.ShouldDeactivateChatOnEditFocusLost then
				local shouldDeactivateChatOnEditFocusLost = activeChatWindow.ShouldDeactivateChatOnEditFocusLost
				button.restoreEditFocusLost = function()
					activeChatWindow.ShouldDeactivateChatOnEditFocusLost = shouldDeactivateChatOnEditFocusLost
				end
				activeChatWindow.ShouldDeactivateChatOnEditFocusLost = function() return false end
			else
				local chatEditOnFocusLost = activeChatWindow:GetScript('OnEditFocusLost')
				button.restoreEditFocusLost = function()
					activeChatWindow:SetScript('OnEditFocusLost', chatEditOnFocusLost)
				end
				activeChatWindow:SetScript('OnEditFocusLost', function() end)
			end
		end
	end)
	button:HookScript("OnLeave", function()
		if button.restoreEditFocusLost then
			button.restoreEditFocusLost()
			button.restoreEditFocusLost = nil
		end
	end)
end
