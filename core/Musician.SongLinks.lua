--- Song links module
-- @module Musician.SongLinks

Musician.SongLinks = LibStub("AceAddon-3.0"):NewAddon("Musician.SongLinks", "AceComm-3.0", "AceComm-3.0-Extended", "AceEvent-3.0")

local MODULE_NAME = "SongLinks"
Musician.AddModule(MODULE_NAME)

local LibDeflate = LibStub:GetLibrary("LibDeflate")

Musician.SongLinks.event = {}
Musician.SongLinks.event.song = "MusicianSong"
Musician.SongLinks.event.requestSong = "MusicianSongReq"
Musician.SongLinks.event.songError = "MusicianSongErr"

Musician.SongLinks.errors = {}
Musician.SongLinks.errors.notFound = 'notFound'
Musician.SongLinks.errors.alreadySending = 'alreadySending'
Musician.SongLinks.errors.alreadyRequested = 'alreadyRequested'
Musician.SongLinks.errors.timeout = 'timeout'
Musician.SongLinks.errors.offline = 'offline'
Musician.SongLinks.errors.importingFailed = 'importingFailed'

Musician.SongLinks.status = {}
Musician.SongLinks.status.requested = 'requested'
Musician.SongLinks.status.downloading = 'downloading'
Musician.SongLinks.status.importing = 'importing'

local sharedSongs = {}
local sendingSongs = {}
local requestedSongs = {}

local RECEIVING_PROGRESSION_RATIO = .9
local REQUEST_TIMEOUT = 30
local MAX_TITLE_LENGTH = 48

local HYPERLINK_PREFIX = 'musicianSong'
local CHAT_LINK_PREFIX = 'Musician'
local LINK_COLOR = '00FFFF'
local CHAT_MSG_EVENTS = {
	"CHAT_MSG_CHANNEL",
	"CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_EMOTE", "CHAT_MSG_TEXT_EMOTE",
	"CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_GUILD", "CHAT_MSG_OFFICER",
	"CHAT_MSG_WHISPER", "CHAT_MSG_WHISPER_INFORM",
	"CHAT_MSG_BN_WHISPER", "CHAT_MSG_BN_WHISPER_INFORM"
}
local BUBBLE_CHAT_MSG_EVENTS = {
	"CHAT_MSG_SAY", "CHAT_MSG_YELL",
	"CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER"
}

local MSG_MULTI_FIRST = "\001"
local MSG_MULTI_NEXT  = "\002"
local MSG_MULTI_LAST  = "\003"

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

--- Send communication message.
-- Same parameters as AceComm:SendCommMessage but will use Battle.net if the provided target is a game account ID.
local function SendCommMessage(prefix, text, kind, target, priority, callback, callbackArg)
	if kind == 'WHISPER' and Musician.Utils.IsBattleNetID(target) then
		if Musician.Utils.IsBattleNetGameAccountOnline(target) then
			Musician.SongLinks:SendBNetCommMessage(prefix, text, target, priority, callback, callbackArg)
		end
	else
		Musician.SongLinks:SendCommMessage(prefix, text, kind, target, priority, callback, callbackArg)
	end
end

--- Initialize song links
--
function Musician.SongLinks.Init()
	-- Track song import progression
	Musician.SongLinks:RegisterMessage(Musician.Events.SongImportProgress, Musician.SongLinks.OnSongImportProgress)

	-- Register communication for game chat
	Musician.SongLinks:RegisterComm(Musician.SongLinks.event.song, Musician.SongLinks.OnSongReceived)
	Musician.SongLinks:RegisterComm(Musician.SongLinks.event.requestSong, Musician.SongLinks.OnRequestSong)
	Musician.SongLinks:RegisterComm(Musician.SongLinks.event.songError, Musician.SongLinks.OnSongError)
	Musician.SongLinks:RegisterEvent("CHAT_MSG_ADDON", Musician.SongLinks.OnSongData)

	-- Register communication for Battle.net chat
	Musician.SongLinks:RegisterBNetComm(Musician.SongLinks.event.song, Musician.SongLinks.OnSongReceived)
	Musician.SongLinks:RegisterBNetComm(Musician.SongLinks.event.requestSong, Musician.SongLinks.OnRequestSong)
	Musician.SongLinks:RegisterBNetComm(Musician.SongLinks.event.songError, Musician.SongLinks.OnSongError)
	Musician.SongLinks:RegisterEvent("BN_CHAT_MSG_ADDON", Musician.SongLinks.OnSongData)

	-- Replace song links in chat bubbles
	for _, event in pairs(BUBBLE_CHAT_MSG_EVENTS) do
		Musician.SongLinks:RegisterEvent(event, Musician.SongLinks.OnChatBubbleMsg)
	end

	-- Convert hyperlinks to plain text chat links before sending messages
	local HookedSubstituteChatMessageBeforeSend = SubstituteChatMessageBeforeSend
	SubstituteChatMessageBeforeSend = function(msg)
		msg = HookedSubstituteChatMessageBeforeSend(msg)
		msg = Musician.SongLinks.HyperlinksToChatLinks(msg)
		return msg
	end

	-- Convert received plain text chat links into hyperlinks
	local messageEventFilter = function(self, event, msg, sender, ...)
		local player = sender
		if event == 'CHAT_MSG_WHISPER_INFORM' or event == 'CHAT_MSG_BN_WHISPER_INFORM' then
			player = UnitName('player')
		elseif event == 'CHAT_MSG_BN_WHISPER' then
			local _, _, playerName2, _, _, _, _, _, _, _, bnSenderID = ...
			player = tonumber(bnSenderID)
		end
		msg = Musician.SongLinks.ChatLinksToHyperlinks(msg, player)
		return false, msg, sender, ...
	end
	for _, event in pairs(CHAT_MSG_EVENTS) do
		ChatFrame_AddMessageEventFilter(event, messageEventFilter)
	end

	-- Hyperlink hooks
	hooksecurefunc("ChatFrame_OnHyperlinkShow", function(self, link, text, button)
		local args = { strsplit(':', link) }
		if args[1] == HYPERLINK_PREFIX and not(IsModifiedClick("CHATLINK")) then
			-- Extract player name
			local player = args[2] or UnitName('player')

			-- Extract title
			local title = string.match(text, '%[[^:]+: *([^%]]+)%]')

			-- Trigger SongLink event
			Musician.SongLinks:SendMessage(Musician.Events.SongLink, title, player)
		end
	end)
	local HookedSetHyperlink = ItemRefTooltip.SetHyperlink
	function ItemRefTooltip:SetHyperlink(link, ...)
		if (link and link:sub(0, #HYPERLINK_PREFIX) == HYPERLINK_PREFIX) then
			return
		end
		return HookedSetHyperlink(self, link, ...)
	end
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
		return '[' .. CHAT_LINK_PREFIX .. '<' .. Musician.Utils.NormalizePlayerName(playerName) .. '>: ' .. normalizedTitle .. ']'
	end
end

--- Convert hyperlinks into text links for sending in the chat
-- @param text (string)
-- @return msg (string)
function Musician.SongLinks.HyperlinksToChatLinks(text)
	local capturePattern = '|H' .. HYPERLINK_PREFIX .. ':?([^|]*)|h[^%[]*%[[^:]+: ([^%]]+)%]|r|h'
	return string.gsub(text, capturePattern, function(playerArg, titleArg)
		return Musician.SongLinks.GetChatLink(titleArg, playerArg)
	end)
end

--- Convert chat text links into hyperlinks
-- @param msg (string)
-- @param[opt] playerName (string)
-- @return text (string)
function Musician.SongLinks.ChatLinksToHyperlinks(msg, playerName)
	local capturePattern = '%[' .. CHAT_LINK_PREFIX .. '<?([^>:]*)>?: ([^%]]*)%]'
	return string.gsub(msg, capturePattern, function(playerArg, titleArg)
		local title = Musician.Utils.RemoveHighlight(titleArg) -- Remove text coloring added by other addons such as Total RP
		local player = playerArg ~= '' and playerArg or playerName or ''
		return Musician.SongLinks.GetHyperlink(title, player)
	end)
end

--- Convert chat links for chat bubbles
-- @param msg (string)
-- @return text (string)
function Musician.SongLinks.ChatLinksToChatBubble(msg)
	local capturePattern = '%[' .. CHAT_LINK_PREFIX .. '<?([^>:]*)>?: ([^%]]*)%]'
	return string.gsub(msg, capturePattern, function(playerArg, titleArg)
		local text = Musician.Msg.LINKS_CHAT_BUBBLE
		text = string.gsub(text, '{note}', Musician.Utils.GetChatIcon(Musician.IconImages.Note))
		text = string.gsub(text, '{title}', Musician.Utils.RemoveHighlight(titleArg)) -- Remove text coloring added by other addons such as Total RP
		return text
	end)
end

--- OnChatBubbleMsg
-- Replace chat links in chat bubbles
function Musician.SongLinks.OnChatBubbleMsg(event, msg, player)
	C_Timer.After(0, function()
		local bubbles = C_ChatBubbles.GetAllChatBubbles()
		for _, bubble in pairs(bubbles) do
			if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
				local text = bubble:GetChildren().String:GetText()
				if bubble.MusicianReplacedText ~= text then
					bubble.MusicianReplacedText = Musician.SongLinks.ChatLinksToChatBubble(text)
					bubble:GetChildren().String:SetText(bubble.MusicianReplacedText)
				end
			else
				-- Find the FontString element in the bubble structure
				for _, region in pairs({ bubble:GetRegions() }) do
					if region:GetObjectType() == 'FontString' then
						-- Replace text in found region
						local text = region:GetText()
						if bubble.MusicianReplacedText ~= text then
							bubble.MusicianReplacedText = Musician.SongLinks.ChatLinksToChatBubble(text)
							region:SetText(bubble.MusicianReplacedText)
						end
						return
					end
				end
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
function Musician.SongLinks.RequestSong(title, playerName, dataOnly)
	playerName = Musician.Utils.NormalizePlayerName(playerName)

	-- Song is already being requested
	if requestedSongs[playerName] ~= nil then
		Musician.SongLinks:SendMessage(Musician.Events.SongReceiveFailed, playerName, Musician.SongLinks.errors.alreadyRequested, title)
		return
	end

	-- Timeout function
	local onTimeout = function()
		if requestedSongs[playerName] == nil then return end
		debug("Timed out after", REQUEST_TIMEOUT, playerName, title)
		Musician.SongLinks.RemoveRequest(playerName)
		Musician.SongLinks:SendMessage(Musician.Events.SongReceiveComplete, playerName)
		Musician.SongLinks:SendMessage(Musician.Events.SongReceiveFailed, playerName, Musician.SongLinks.errors.timeout, title)
	end

	-- Add song request
	requestedSongs[playerName] = {
		title = title,
		status = Musician.SongLinks.status.requested,
		total = nil,
		downloaded = 0,
		progress = nil,
		song = nil,
		dataOnly = dataOnly,
		onTimeout = onTimeout,
		timeoutTimer = C_Timer.NewTimer(REQUEST_TIMEOUT, onTimeout)
	}

	Musician.SongLinks:SendMessage(Musician.Events.SongReceiveStart, playerName)

	-- Send song request to player
	debugComm(true, Musician.SongLinks.event.requestSong, playerName, title)
	SendCommMessage(Musician.SongLinks.event.requestSong, title, 'WHISPER', playerName, 'ALERT')
end

--- Remove a song download request
-- @param playerName (string)
function Musician.SongLinks.RemoveRequest(playerName)
	playerName = Musician.Utils.NormalizePlayerName(playerName)

	local requestedSong = requestedSongs[playerName]

	if requestedSong == nil then return end

	wipe(requestedSongs[playerName])
	requestedSongs[playerName] = nil

	if requestedSong.timeoutTimer then
		requestedSong.timeoutTimer:Cancel()
	end

	if requestedSong.status == Musician.SongLinks.status.importing then
		requestedSong.song:CancelImport()
	end
end

--- Cancel a song download request
-- @param playerName (string)
function Musician.SongLinks.CancelRequest(playerName)
	playerName = Musician.Utils.NormalizePlayerName(playerName)
	Musician.SongLinks.RemoveRequest(playerName)
	Musician.SongLinks:SendMessage(Musician.Events.SongReceiveComplete, playerName)
	Musician.SongLinks:SendMessage(Musician.Events.SongReceiveCanceled, playerName)
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
	Musician.SongLinks.RemoveRequest(sender)
	Musician.SongLinks:SendMessage(Musician.Events.SongReceiveComplete, sender)
	Musician.SongLinks:SendMessage(Musician.Events.SongReceiveFailed, sender, errorCode, title)
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
		SendCommMessage(Musician.SongLinks.event.songError, message, 'WHISPER', playerName, 'ALERT')
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
		SendCommMessage(Musician.SongLinks.event.songError, message, 'WHISPER', playerName, 'ALERT')
		return
	end

	sendingSongs[playerName] = title

	local encodedData
	if Musician.Utils.IsBattleNetID(playerName) then
		-- Encode in base 64 for sending through Battle.net
		-- Base64 encoding overhead is less important than EncodeForWoWChatChannel()
		encodedData = Musician.Utils.Base64Encode(songData)
	else
		encodedData = LibDeflate:EncodeForWoWAddonChannel(songData)
	end

	-- Prepend data length to the message so the recipient can determine the progression
	local msg = #encodedData .. " " .. encodedData

	-- Send song
	debugComm(true, Musician.SongLinks.event.song, playerName, title, #msg)
	SendCommMessage(Musician.SongLinks.event.song, msg, 'WHISPER', playerName, 'BULK', function(_, sent, total)
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

	-- Get progression from chunks
	local control, data = string.match(message, "^([\001-\009])(.*)")
	local receivingProgressionRatio = requestedSong.dataOnly and 1 or RECEIVING_PROGRESSION_RATIO
	local progression
	if control then
		if control == MSG_MULTI_FIRST then
			requestedSong.status = Musician.SongLinks.status.downloading
			-- Extract total data length to determine the progression
			requestedSong.total, data = string.match(data, "^([0-9]+) (.*)")
			requestedSong.downloaded = #data
		elseif control == MSG_MULTI_NEXT or control == MSG_MULTI_LAST then
			-- Lost chunk (may happen after a /reload while receiving a song)
			if requestedSong.total == nil then return end

			-- Update received data length
			requestedSong.downloaded = requestedSong.downloaded + #data
		end
		progress = receivingProgressionRatio * requestedSong.downloaded / requestedSong.total
	else
		-- The whole song fits in a single message
		progress = receivingProgressionRatio
	end
	requestedSong.progress = progress
	Musician.SongLinks:SendMessage(Musician.Events.SongReceiveProgress, sender, progress)
end

--- OnSongImportProgress
-- Notify import progression
function Musician.SongLinks.OnSongImportProgress(event, song, importProgress)
	if song.sender then
		local totalProgress = RECEIVING_PROGRESSION_RATIO + (1 - RECEIVING_PROGRESSION_RATIO) * importProgress
		if requestedSongs[sender] then
			requestedSongs[sender].progress = totalProgress
		end
		Musician.SongLinks:SendMessage(Musician.Events.SongReceiveProgress, song.sender, totalProgress)
	end
end

--- OnSongReceived
-- Song data has been received
function Musician.SongLinks.OnSongReceived(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	debugComm(false, Musician.SongLinks.event.song, sender, #message)
	local requestedSong = requestedSongs[sender]

	if requestedSong == nil then return end

	local dataLength, encodedData = string.match(message, "^([0-9]+) (.*)")
	local songData
	if Musician.Utils.IsBattleNetID(sender) then
		songData = Musician.Utils.Base64Decode(encodedData)
	else
		songData = LibDeflate:DecodeForWoWAddonChannel(encodedData)
	end

	-- Data only
	if requestedSong.dataOnly then
		Musician.SongLinks.RemoveRequest(sender)
		Musician.SongLinks:SendMessage(Musician.Events.SongReceiveComplete, sender)
		debug("Song downloading complete (data only)", requestedSong.title)
		Musician.SongLinks:SendMessage(Musician.Events.SongReceiveSucessful, sender, songData)
		return
	end

	local song = Musician.Song.create()
	song.sender = sender
	collectgarbage()

	requestedSong.song = song
	requestedSong.status = Musician.SongLinks.status.importing
	requestedSong.timeoutTimer:Cancel()
	requestedSong.timeoutTimer = nil
	local title = requestedSong.title
	song:ImportCompressed(songData, false, function(success)
		Musician.SongLinks.RemoveRequest(sender)
		Musician.SongLinks:SendMessage(Musician.Events.SongReceiveComplete, sender)

		-- Import failed
		if not(success) then
			debug("Song downloading failed")
			Musician.SongLinks:SendMessage(Musician.Events.SongReceiveFailed, sender, Musician.SongLinks.errors.importingFailed, title)
			return
		end

		-- Stop previous source song being played
		if Musician.sourceSong and Musician.sourceSong:IsPlaying() then
			Musician.sourceSong:Stop()
		end

		Musician.sourceSong = song

		debug("Song downloading complete", song.name)
		Musician.SongLinks:SendMessage(Musician.Events.SongReceiveSucessful, sender, songData, song)
		Musician.SongLinks:SendMessage(Musician.Events.SourceSongLoaded, song, songData)

		song = nil
		collectgarbage()
	end)
end