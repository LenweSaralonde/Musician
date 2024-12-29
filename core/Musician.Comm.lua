--- Communication module
-- @module Musician.Comm

Musician.Comm = LibStub("AceAddon-3.0"):NewAddon("Musician.Comm", "AceComm-3.0", "AceEvent-3.0")

local MODULE_NAME = "Comm"
Musician.AddModule(MODULE_NAME)

local LibDeflate = LibStub:GetLibrary("LibDeflate")
local LibBase64 = LibStub:GetLibrary("LibBase64")

Musician.Comm.event = {}
Musician.Comm.event.stop = "MusicianStop"
Musician.Comm.event.stream = "MusicianStream8"
Musician.Comm.event.streamAlt = "MusicianStream8a"
Musician.Comm.event.streamGroup = "MusicianGStream8"
Musician.Comm.event.bandPlay = "MusicianBPlay"
Musician.Comm.event.bandStop = "MusicianBStop"
Musician.Comm.event.bandReady = "MusicianBOK"
Musician.Comm.event.bandNotReady = "MusicianBNotOK"
Musician.Comm.event.bandReadyQuery = "MusicianBQuery"

Musician.Comm.action = {}
Musician.Comm.action.play = "play"
Musician.Comm.action.stop = "stop"
Musician.Comm.action.bandPlay = "bandPlay"
Musician.Comm.action.bandStop = "bandStop"
Musician.Comm.action.bandReady = "bandReady"
Musician.Comm.action.bandNotReady = "bandNotReady"

local isSongPlaying = false

local isPlayPending = false
local isStopPending = false
local isBandActionPending = false

local joinChannelAfter
local joinWithoutPassword = false
local chatChannelPasswordStaticPopupDialog = StaticPopupDialogs["CHAT_CHANNEL_PASSWORD"]

local isBandPlayReady = false
local readyBandPlayers = {}
local currentSongCrc32

local lastSentChannelStreamMessage = 0
local useAlternateChannelStreamPrefix = false

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

	if event == Musician.Comm.event.stream or
		event == Musician.Comm.event.streamAlt or
		event == Musician.Comm.event.streamGroup
	then
		message = "Song data (" .. #message .. ")"
	end

	event = "|cFFFF8000" .. event .. "|r"
	source = "|cFF00FFFF" .. source .. "|r"

	Musician.Utils.Debug(MODULE_NAME, prefix, event, source, message, ...)
end

--- Indicates whenever the communication channel should be used.
-- @return (boolean)
local function useCommChannel()
	return WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
end

--- Set the delay before joining the communication channel.
-- @param duration (number) in seconds
-- @param[opt] withoutPassword (boolean) join without using password
local function delayCommChannelJoin(duration, withoutPassword)
	Musician.Utils.Debug(MODULE_NAME, "Will join the communication channel again in", duration, "second(s).",
		withoutPassword and "(no password)" or "")
	joinWithoutPassword = withoutPassword or false
	joinChannelAfter = GetTime() + duration
end

--- Disable the chat channel password popup
-- @param isJoining (boolean)
local function disableChannelPasswordPopup(isJoining)
	if isJoining and not StaticPopup_Visible("CHAT_CHANNEL_PASSWORD") then
		StaticPopupDialogs["CHAT_CHANNEL_PASSWORD"] = nil
	else
		StaticPopupDialogs["CHAT_CHANNEL_PASSWORD"] = chatChannelPasswordStaticPopupDialog
	end
end

--- Return true if the channel list is ready for the communication channel to join.
-- @return isReady (boolean)
local function isChannelListReady()
	-- The channel list is empty
	if select('#', GetChannelList()) == 0 then
		return false
	end

	-- Find gaps in the channel list
	local hasGaps = false
	local previousIndex = 0
	for index = 1, MAX_WOW_CHAT_CHANNELS do
		if (C_ChatInfo.GetChannelShortcut(index) or "") ~= "" then
			if index ~= previousIndex + 1 then
				hasGaps = true
				break
			end
			previousIndex = index
		end
	end

	-- Consider the channel list is ready if there is no gap
	return not hasGaps
end

--- Initialize communication
--
function Musician.Comm.Init()
	Musician.Comm:RegisterMessage(Musician.Events.SourceSongLoaded, Musician.Comm.OnSongLoaded)
	Musician.Comm:RegisterMessage(Musician.Events.SongPlay, Musician.Comm.OnSongPlay)
	Musician.Comm:RegisterMessage(Musician.Events.SongStop, Musician.Comm.OnSongStop)
	Musician.Comm:RegisterEvent("GROUP_JOINED", Musician.Comm.OnGroupJoined)
	Musician.Comm:RegisterEvent("GROUP_LEFT", Musician.Comm.OnGroupLeft)
	Musician.Comm:RegisterEvent("GROUP_ROSTER_UPDATE", Musician.Comm.OnRosterUpdate)
	Musician.Comm:RegisterComm(Musician.Comm.event.stream, Musician.Comm.OnChunk)
	Musician.Comm:RegisterComm(Musician.Comm.event.streamAlt, Musician.Comm.OnChunk)
	Musician.Comm:RegisterComm(Musician.Comm.event.streamGroup, Musician.Comm.OnChunk)
	Musician.Comm:RegisterComm(Musician.Comm.event.stop, Musician.Comm.OnStopSong)
	Musician.Comm:RegisterComm(Musician.Comm.event.bandReadyQuery, Musician.Comm.OnBandReadyQuery)
	Musician.Comm:RegisterComm(Musician.Comm.event.bandReady, Musician.Comm.OnBandPlayReady)
	Musician.Comm:RegisterComm(Musician.Comm.event.bandNotReady, Musician.Comm.OnBandPlayReady)
	Musician.Comm:RegisterComm(Musician.Comm.event.bandPlay, Musician.Comm.OnBandPlay)
	Musician.Comm:RegisterComm(Musician.Comm.event.bandStop, Musician.Comm.OnBandStop)
	Musician.Comm:RegisterEvent("PLAYER_DEAD", Musician.Comm.OnDead)

	local function finishInit()
		Musician.Comm.JoinChannel()
		Musician.Comm.OnGroupJoined()
	end

	if not IsLoggedIn() then
		Musician.Comm:RegisterEvent("PLAYER_LOGIN", finishInit)
	else
		finishInit()
	end

	-- Determine if should be using the alternate prefix for streaming in the channel
	-- to mitigate the aggressive throttling for add-on messages added in 10.2.7
	hooksecurefunc(_G.C_ChatInfo, "SendAddonMessage", function(prefix)
		if prefix == Musician.Comm.event.stream then
			local now = debugprofilestop()
			-- A previous channel stream message was broadcasted very recently,
			-- better use the alternate channel next time to avoid throttling.
			if now - lastSentChannelStreamMessage < 1000 and
				Musician.streamingSong and
				Musician.streamingSong.mode == Musician.Song.MODE_DURATION
			then
				useAlternateChannelStreamPrefix = true
			end
			lastSentChannelStreamMessage = now
		end
	end)
end

--- Function executed when the communication channel has been successfully joined
--
local function onChannelJoined()
	Musician.Utils.Debug(MODULE_NAME, "Communication channel successfully joined.")
	Musician.Registry.playersFetched = false
	Musician.Registry.SendHello()
	Musician.Registry.FetchPlayers()
	Musician.Comm:SendMessage(Musician.Events.CommChannelUpdate, true)
	disableChannelPasswordPopup(false)
end

--- Function executed when failed to join the channel
-- @param reason (string)
local function onChannelFailed(reason)
	Musician.Utils.Debug(MODULE_NAME, "Failed to join the communication channel:", reason)
	Musician.Comm:SendMessage(Musician.Events.CommChannelUpdate, false)
	if reason == 'WRONG_PASSWORD' then
		if not joinWithoutPassword then
			delayCommChannelJoin(0, true) -- Try again now without password, since it could have been accidentally unset
		else
			delayCommChannelJoin(300) -- Try again in 5 minutes
		end
	else
		delayCommChannelJoin(10) -- Try again in 10 seconds
	end
	disableChannelPasswordPopup(false)
end

--- Function executed when leaving the channel
--
local function onChannelLeft()
	Musician.Utils.Debug(MODULE_NAME, "Communication channel left.")
	Musician.Comm:SendMessage(Musician.Events.CommChannelUpdate, false)
	delayCommChannelJoin(0) -- Rejoin ASAP
end

--- Swap channels by index, without losing the color association on Retail.
local swapChannelsByIndex = ChatConfigChannelSettings_SwapChannelsByIndex or C_ChatInfo.SwapChatChannelsByChannelIndex

--- Reorder channels the keep the communication channel at the end of the list
--
local function reorderChannels()
	local commChannelIndex = Musician.Comm.GetChannel()
	if commChannelIndex == nil then return end

	-- Get the index of the last channel
	local lastChannelIndex = 0
	for index = MAX_WOW_CHAT_CHANNELS, commChannelIndex, -1 do
		if (C_ChatInfo.GetChannelShortcut(index) or "") ~= "" then
			lastChannelIndex = index
			break
		end
	end

	-- No need to reorder, the communication channel is already the last one
	if commChannelIndex == lastChannelIndex then
		Musician.Utils.Debug(MODULE_NAME, "reorderChannels", "Communication channel already in last position.")
		return
	end

	-- Bubble the communication channel up to the last position
	for index = commChannelIndex, lastChannelIndex - 1 do
		swapChannelsByIndex(index, index + 1)
	end
	Musician.Utils.Debug(MODULE_NAME, "reorderChannels", "Changed communication channel position from", commChannelIndex,
		"to", lastChannelIndex)
end

--- Join the communication channel and keep it joined
--
function Musician.Comm.JoinChannel()
	-- Channel joiner already active
	if Musician.Comm.channelJoiner ~= nil then return end

	Musician.Utils.Debug(MODULE_NAME, "JoinChannel")

	-- Channel status changed
	Musician.Comm:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE", function(event, ...)
		local text, _, _, _, _, _, _, _, channelName = ...

		-- Make sure the communication channel remains on top when a new channel has been joined.
		if text == 'YOU_CHANGED' or text == 'YOU_JOINED' then
			reorderChannels()
		end

		-- Something interesting happened for the communication channel
		if channelName == Musician.CHANNEL then
			if text == 'YOU_CHANGED' or text == 'YOU_JOINED' then
				-- Successfully joined channel
				onChannelJoined()
			elseif text == 'WRONG_PASSWORD' or text == 'BANNED' then
				-- Something went wrong
				onChannelFailed(text)
			elseif text == 'YOU_LEFT' then
				-- Left channel
				onChannelLeft()
			end
		end
	end)

	local canJoinWhenNotReady = false

	-- Channel is already joined
	if Musician.Comm.GetChannel() ~= nil then
		Musician.Utils.Debug(MODULE_NAME, "Communication channel already joined.")
		reorderChannels()
		onChannelJoined()
	end

	-- Allow to join the communication channel even if the channel list is not ready
	-- after 10 seconds.
	C_Timer.After(10, function()
		canJoinWhenNotReady = true
		if Musician.Comm.GetChannel() == nil then
			Musician.Utils.Debug(MODULE_NAME, "Allowing to join communication channel with incomplete channel list.")
		end
	end)

	-- Join the channel and keep it joined
	Musician.Comm.channelJoiner = C_Timer.NewTicker(1, function()
		-- Channel is already joined
		if Musician.Comm.GetChannel() ~= nil then return end

		-- The joining process has been delayed
		if joinChannelAfter ~= nil and joinChannelAfter > GetTime() then return end

		-- Attempt to join if the channel list is ready (has channels and no gap)
		-- or if allowed to join despite the channel list not being ready
		if canJoinWhenNotReady or isChannelListReady() then
			-- Don't join if currently showing the password popup for the channel
			local _, passwordPopup = StaticPopup_Visible("CHAT_CHANNEL_PASSWORD")
			if passwordPopup and passwordPopup.text and passwordPopup.text.text_arg1 == Musician.CHANNEL then
				return
			end

			-- Join channel

			joinChannelAfter = nil
			Musician.Utils.Debug(MODULE_NAME, "Joining the communication channel:", Musician.CHANNEL)
			disableChannelPasswordPopup(true)
			JoinTemporaryChannel(Musician.CHANNEL, not joinWithoutPassword and Musician.PASSWORD or nil)
		end
	end)
end

--- Return communication chat type for group
-- @return chatType (string)
function Musician.Comm.GetGroupChatType()
	local inInstance, instanceType = IsInInstance()
	local isF2P = IsTrialAccount() or IsVeteranTrialAccount()
	local inGroup = IsInGroup()
	local inRaid = IsInRaid()
	local inLFG = IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
	local inLFR = IsInRaid(LE_PARTY_CATEGORY_INSTANCE)
	local inBattleground = inRaid and inInstance and instanceType == "pvp"

	if isF2P and inRaid then
		return nil -- Disable raid broadcasting for trial accounts
	elseif inLFG or inLFR or inBattleground then
		return "INSTANCE_CHAT"
	elseif inRaid then
		return "RAID"
	elseif inGroup then
		return "PARTY"
	else
		return nil
	end
end

--- Broadcast communication message using appropriate channels
-- @param message (string)
-- @param type (string)
-- @param[opt] groupType (string)
function Musician.Comm.BroadcastCommMessage(message, type, groupType)
	if groupType == nil then
		groupType = type
	end

	local groupChatType = Musician.Comm.GetGroupChatType()
	if groupChatType then
		debugComm(true, groupType, groupChatType, message)
		Musician.Comm:SendCommMessage(groupType, message, groupChatType, nil, "ALERT")
	end

	if useCommChannel() then
		if Musician.Comm.ChannelIsReady() then
			debugComm(true, type, "CHANNEL " .. Musician.Comm.GetChannel(), message)
			Musician.Comm:SendCommMessage(type, message, "CHANNEL", Musician.Comm.GetChannel(), "ALERT")
		end
	else
		debugComm(true, type, "YELL", message)
		Musician.Comm:SendCommMessage(type, message, "YELL", nil, "ALERT")
	end
end

--- Return the communication channel ID
-- @return channelId (string)
function Musician.Comm.GetChannel()
	local channelId = GetChannelName(Musician.CHANNEL)

	if channelId ~= 0 then
		return channelId
	else
		return nil
	end
end

--- Return true if the communication channel is ready
-- @return isReady (boolean)
function Musician.Comm.ChannelIsReady()
	return useCommChannel() and Musician.Comm.GetChannel() ~= nil
end

--- Return true if the player can broadcast via the channel or the group chat
-- @return canBroadcast (boolean)
function Musician.Comm.CanBroadcast()
	return not useCommChannel() or Musician.Comm.ChannelIsReady() or Musician.Comm.GetGroupChatType() ~= nil
end

--- Return true if the player can play music
-- @return canPlay (boolean)
function Musician.Comm.CanPlay()
	local playerIsAliveOrGhost = not UnitIsDead("player") or UnitIsGhost("player")
	return Musician.Comm.CanBroadcast() and playerIsAliveOrGhost
end

--- Play song
-- @return success (boolean)
function Musician.Comm.PlaySong()
	if isStopPending or isPlayPending then return false end
	if not Musician.Comm.CanPlay() or not Musician.sourceSong then return false end

	Musician.Utils.Debug(MODULE_NAME, "PlaySong")

	isPlayPending = true
	Musician.Comm:SendMessage(Musician.Events.CommSendAction, Musician.Comm.action.play)

	if Musician.streamingSong then
		if Musician.streamingSong.streaming then
			Musician.streamingSong:StopStreaming()
		end
		Musician.streamingSong:Wipe()
	end
	Musician.streamingSong = Musician.sourceSong:Clone()
	Musician.streamingSong:Stream()
	return true
end

--- Toggle play song
--
function Musician.Comm.TogglePlaySong()
	local songIsStreaming = Musician.streamingSong and Musician.streamingSong.streaming and
		not Musician.streamingSong.isLiveStreamingSong
	if songIsStreaming or isSongPlaying then
		-- Playing as band
		if isBandPlayReady then
			Musician.Comm.StopSongBand()
		else
			Musician.Comm.StopSong()
		end
	else
		-- Play as band
		if isBandPlayReady then
			Musician.Comm.PlaySongBand()
		else
			Musician.Comm.PlaySong()
		end
	end
end

--- Stream a packed song chunk
-- @param packedChunk (string)
function Musician.Comm.StreamSongChunk(packedChunk)
	if not Musician.Comm.CanPlay() then return false end
	Musician.Comm.StreamCompressedSongChunk(LibDeflate:CompressDeflate(packedChunk, { level = 9 }))
end

--- Stream a compressed song chunk
-- @param compressedChunk (string)
-- @return success (boolean)
function Musician.Comm.StreamCompressedSongChunk(compressedChunk)
	if not Musician.Comm.CanPlay() then return false end

	local serializedChunk
	if useCommChannel() then
		serializedChunk = LibDeflate:EncodeForWoWAddonChannel(compressedChunk)
	else
		serializedChunk = LibBase64:enc(compressedChunk) -- LibDeflate:EncodeForWoWAddonChannel fails over YELL
	end

	-- Calculate used bandwidth
	local bwMin = Musician.BANDWIDTH_LIMIT_MIN
	local bwMax = Musician.BANDWIDTH_LIMIT_MAX + 1
	local bandwidth = (max(bwMin, min(bwMax, #serializedChunk)) - bwMin) / (bwMax - bwMin)
	Musician.Comm:SendMessage(Musician.Events.Bandwidth, bandwidth)

	-- Determine if we should use the alternate prefix for channel streaming
	local channelBroadcastPrefix = Musician.Comm.event.stream
	if useAlternateChannelStreamPrefix then
		channelBroadcastPrefix = Musician.Comm.event.streamAlt
		useAlternateChannelStreamPrefix = false
	end

	-- Stream chunk
	Musician.Comm.BroadcastCommMessage(serializedChunk, channelBroadcastPrefix, Musician.Comm.event.streamGroup)

	-- Use alternate channel stream prefix next time if the song is live
	if Musician.streamingSong.mode == Musician.Song.MODE_LIVE and channelBroadcastPrefix == Musician.Comm.event.stream then
		useAlternateChannelStreamPrefix = true
	end

	return true
end

--- Process a packed chunk
-- @param packedChunk (string)
-- @param sender (string)
function Musician.Comm.ProcessChunk(packedChunk, sender)
	-- Decode chunk header
	local mode, songId, chunkDuration, playtimeLeft, position = Musician.Song.UnpackChunkHeader(packedChunk)

	-- Invalid chunk
	if mode == nil then
		return
	end

	sender = Musician.Utils.NormalizePlayerName(sender)

	-- Update player position
	Musician.Registry.UpdatePlayerPositionAndGUID(sender, unpack(position))
	Musician.Comm:SendMessage(Musician.Events.SongChunk, sender, mode, songId, chunkDuration, playtimeLeft,
		unpack(position))

	-- No longer in loading range
	if not Musician.Registry.PlayerIsInLoadingRange(sender) then
		-- Stop and clear existing song
		if Musician.songs[sender] then
			Musician.songs[sender]:Stop()
			Musician.songs[sender]:Wipe()
			Musician.songs[sender] = nil
		end
		return
	end

	-- Starting a new song over an existing one
	if Musician.songs[sender] and Musician.songs[sender].songId ~= songId then
		-- Clear existing song
		Musician.songs[sender]:Stop()
		Musician.songs[sender]:Wipe()
		Musician.songs[sender] = nil
	end

	-- Create playing song, if missing
	if Musician.songs[sender] == nil then
		Musician.songs[sender] = Musician.Song.create()

		-- Receiving my own live streaming song: set live streaming song flag
		if Musician.Utils.PlayerIsMyself(sender) and mode == Musician.Song.MODE_LIVE and Musician.Live.IsStreaming() then
			Musician.songs[sender].isLiveStreamingSong = true
		end
	end

	-- Decode chunk data
	local chunk = Musician.Song.UnpackChunkData(packedChunk)
	if chunk == nil then
		return
	end

	-- Append chunk data
	local receivingSong = Musician.songs[sender]
	receivingSong:AppendChunk(chunk, mode, songId, chunkDuration, playtimeLeft, sender)

	-- Play song if not already started
	if not receivingSong:IsPlaying() and receivingSong.cursor == 0 then
		-- Play song with delay to anticipate lag
		local playDelay = chunkDuration / 2
		receivingSong:Play(playDelay)

		-- Send event to activate the play button
		if Musician.Utils.PlayerIsMyself(sender) then
			isPlayPending = false
			Musician.Comm:SendMessage(Musician.Events.CommSendActionComplete, Musician.Comm.action.play)
		end

		-- Resynchronize out-of-sync songs being played in band play mode due to server lag
		local syncRange = chunkDuration / 2
		if mode == Musician.Song.MODE_DURATION then
			for _, song in pairs(Musician.songs) do
				-- Only compare with currently playing songs other than the one being received
				if receivingSong ~= song and song:IsPlaying() and song.mode == Musician.Song.MODE_DURATION then
					-- Get play time left for both songs
					local receivingSongPlayTimeLeft = receivingSong.cropTo - receivingSong.cursor
					local songPlayTimeLeft = song.cropTo - song.cursor
					-- Synchronize songs if their play time left are close, which is the case for songs played in band play mode.
					if abs(receivingSongPlayTimeLeft - songPlayTimeLeft) < syncRange then
						-- Calculate delay
						local delay = (chunkDuration / 2 + receivingSong.cursor - song.cursor) % chunkDuration -
							chunkDuration / 2
						-- Adjust playing position to catch up the delay if within the sync range.
						if -syncRange < delay and delay < 0 then
							-- delay is negative: receiving song is late
							receivingSong:Seek(receivingSong.cursor - delay)
						elseif 0 < delay and delay < syncRange then
							-- delay is negative: current song is late
							song:Seek(song.cursor + delay)
						end
					end
				end
			end
		end
	end
end

--- Receive compressed chunk
--
function Musician.Comm.OnChunk(prefix, message, distribution, sender)
	debugComm(false, prefix, sender .. "(" .. distribution .. ")", message)

	Musician.Registry.RegisterPlayer(sender)

	-- Rejecting channel chunks if the sender is also sending group chunks
	local isGroup
	if useCommChannel() then
		isGroup = distribution ~= 'CHANNEL'
	else
		isGroup = distribution == 'PARTY' or distribution == 'RAID' or distribution == 'INSTANCE_CHAT'
	end

	local senderIsInGroup = Musician.Utils.PlayerIsInGroup(sender)
	if not isGroup and senderIsInGroup then
		return
	end

	local packedChunk
	if useCommChannel() then
		packedChunk = LibDeflate:DecompressDeflate(LibDeflate:DecodeForWoWAddonChannel(message))
	else
		packedChunk = LibDeflate:DecompressDeflate(LibBase64:dec(message)) -- LibDeflate:DecodeForWoWAddonChannel fails over YELL
	end

	Musician.Comm.ProcessChunk(packedChunk, sender)
end

--- Stop song
-- @return success (boolean)
function Musician.Comm.StopSong()
	if isStopPending or isPlayPending then return false end
	if not Musician.Comm.CanBroadcast() then return false end
	if Musician.streamingSong and Musician.streamingSong.streaming or isSongPlaying then
		Musician.Utils.Debug(MODULE_NAME, "StopSong")
		if Musician.streamingSong ~= nil then
			Musician.streamingSong:StopStreaming()
			Musician.streamingSong:Wipe()
			Musician.streamingSong = nil
		end
		isStopPending = true
		Musician.Comm:SendMessage(Musician.Events.CommSendAction, Musician.Comm.action.stop)
		Musician.Comm.BroadcastCommMessage(Musician.Comm.event.stop, Musician.Comm.event.stop)
		return true
	end
	return false
end

--- Indicate if the player song is playing
-- @return isSongPlaying (boolean)
function Musician.Comm.IsSongPlaying()
	return isSongPlaying
end

--- Stop a song
--
function Musician.Comm.OnStopSong(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	debugComm(false, prefix, sender .. "(" .. distribution .. ")", message)
	Musician.StopPlayerSong(sender, true)
	if Musician.Utils.PlayerIsMyself(sender) then
		isStopPending = false
		Musician.Comm:SendMessage(Musician.Events.CommSendActionComplete, Musician.Comm.action.stop)
	end
end

--- Return the list of ready band players for the current source song
-- @return readyPlayers (table)
function Musician.Comm.GetReadyBandPlayers()
	if not Musician.sourceSong then return {} end
	local readyPlayers = {}
	for player, playerCrc32 in pairs(readyBandPlayers) do
		if playerCrc32 == currentSongCrc32 then
			table.insert(readyPlayers, player)
		end
	end
	return readyPlayers
end

--- OnGroupJoined
--
function Musician.Comm.OnGroupJoined()
	readyBandPlayers = {}
	isBandPlayReady = false
	Musician.Comm.QueryBandReady()
	Musician.Comm:SendMessage(Musician.Events.BandReadyPlayersUpdated)
end

--- QueryBandReady
--
function Musician.Comm.QueryBandReady()
	local groupChatType = Musician.Comm.GetGroupChatType()
	if groupChatType then
		local message = Musician.Comm.event.bandReadyQuery
		debugComm(true, Musician.Comm.event.bandReadyQuery, groupChatType, message)
		Musician.Comm:SendCommMessage(Musician.Comm.event.bandReadyQuery, message, groupChatType, nil, "ALERT")
	end
end

--- OnBandReadyQuery
--
function Musician.Comm.OnBandReadyQuery(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	debugComm(false, prefix, sender .. "(" .. distribution .. ")", message)

	if not Musician.Utils.PlayerIsInGroup(sender) then return end
	if not currentSongCrc32 then return end

	-- Send ready message in return
	local groupChatType = Musician.Comm.GetGroupChatType()
	if isBandPlayReady and groupChatType then
		local readyMessage = tostring(currentSongCrc32)
		debugComm(true, Musician.Comm.event.bandReady, groupChatType, readyMessage)
		Musician.Comm:SendCommMessage(Musician.Comm.event.bandReady, readyMessage, groupChatType, nil, "ALERT")
	end

	-- If the player was ready before, it's obvious that it's no longer the case so remove it
	if readyBandPlayers[sender] then
		local songCrc32 = readyBandPlayers[sender]
		readyBandPlayers[sender] = nil
		Musician.Comm:SendMessage(Musician.Events.BandPlayReady, sender, songCrc32, false, prefix)
		Musician.Comm:SendMessage(Musician.Events.BandReadyPlayersUpdated)
	end
end

--- OnGroupLeft
--
function Musician.Comm.OnGroupLeft()
	readyBandPlayers = {}
	isBandPlayReady = false
	Musician.Comm:SendMessage(Musician.Events.BandReadyPlayersUpdated)
end

--- OnRosterUpdate
--
function Musician.Comm.OnRosterUpdate(event)
	-- Remove players from readyBandPlayers who are no longer in the group
	local isUpdated = false
	for player, songCrc32 in pairs(readyBandPlayers) do
		if not Musician.Utils.PlayerIsInGroup(player) then
			readyBandPlayers[player] = nil
			Musician.Comm:SendMessage(Musician.Events.BandPlayReady, player, songCrc32, false, event)
			isUpdated = true
		end
	end

	if isUpdated then
		Musician.Comm:SendMessage(Musician.Events.BandReadyPlayersUpdated)
	end
end

--- Return current song CRC32
-- @return songCrc32 (number)
function Musician.Comm.GetCurrentSongCrc32()
	return currentSongCrc32
end

--- Update current song CRC32
-- @param songCrc32 (number)
function Musician.Comm.UpdateCurrentSongCrc32(songCrc32)
	-- Not changed
	if songCrc32 == currentSongCrc32 then return end

	-- Set new CRC32
	local previousSongcrc32 = currentSongCrc32
	currentSongCrc32 = songCrc32

	-- Send a "not ready" message for the previous song
	local groupChatType = Musician.Comm.GetGroupChatType()
	if isBandPlayReady and groupChatType ~= nil and previousSongcrc32 ~= nil then
		local message = tostring(previousSongcrc32)
		isBandActionPending = true
		Musician.Comm:SendMessage(Musician.Events.CommSendAction, Musician.Comm.action.bandNotReady)
		debugComm(true, Musician.Comm.event.bandNotReady, groupChatType, message)
		Musician.Comm:SendCommMessage(Musician.Comm.event.bandNotReady, message, groupChatType, nil, "ALERT")
	end

	-- Band play is no longer ready
	isBandPlayReady = false
	local player = Musician.Utils.NormalizePlayerName(UnitName("player"))
	readyBandPlayers[player] = nil

	Musician.Comm:SendMessage(Musician.Events.BandReadyPlayersUpdated)
end

--- OnSongLoaded
--
function Musician.Comm.OnSongLoaded()
	-- A song is already playing: keep the references to the song currently streaming
	if Musician.Comm.IsSongPlaying() then return end

	-- Update song CRC32 by the one from the loaded song
	Musician.Comm.UpdateCurrentSongCrc32(Musician.sourceSong and Musician.sourceSong.crc32)
end

--- Indicate if the player is ready for band play
-- @return isBandPlayReady (boolean)
function Musician.Comm.IsBandPlayReady()
	return isBandPlayReady
end

--- Toggle band play ready
--
function Musician.Comm.ToggleBandPlayReady()
	Musician.Comm.SetBandPlayReady(not isBandPlayReady)
end

--- Set band play ready
-- @param isReady (boolean)
-- @return success (boolean)
function Musician.Comm.SetBandPlayReady(isReady)
	if isBandActionPending then return false end
	if not Musician.Comm.CanBroadcast() then return false end
	if not currentSongCrc32 then return false end

	local groupChatType = Musician.Comm.GetGroupChatType()
	if groupChatType == nil then return false end

	isBandActionPending = true

	local type = isReady and Musician.Comm.event.bandReady or Musician.Comm.event.bandNotReady
	local action = isReady and Musician.Comm.action.bandReady or Musician.Comm.action.bandNotReady
	local message = tostring(currentSongCrc32)
	Musician.Comm:SendMessage(Musician.Events.CommSendAction, action)
	debugComm(true, type, groupChatType, message)
	Musician.Comm:SendCommMessage(type, message, groupChatType, nil, "ALERT")

	return true
end

--- Receive band ready or not ready message
--
function Musician.Comm.OnBandPlayReady(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	debugComm(false, prefix, sender .. "(" .. distribution .. ")", message)

	if not Musician.Utils.PlayerIsInGroup(sender) then return end

	local isReady = prefix == Musician.Comm.event.bandReady
	local songCrc32 = tonumber(message)

	if Musician.Utils.PlayerIsMyself(sender) then
		isBandPlayReady = isReady
		local action = isReady and Musician.Comm.action.bandReady or Musician.Comm.action.bandNotReady
		isBandActionPending = false
		Musician.Comm:SendMessage(Musician.Events.CommSendActionComplete, action)
	end

	-- Add/remove player in ready band members
	local wasReady = not not readyBandPlayers[sender]
	readyBandPlayers[sender] = isReady and songCrc32 or nil

	-- Trigger local events if ready status have changed
	if wasReady ~= isReady then
		Musician.Comm:SendMessage(Musician.Events.BandPlayReady, sender, songCrc32, isReady, prefix)
		Musician.Comm:SendMessage(Musician.Events.BandReadyPlayersUpdated)
	end
end

--- Play song as a band
-- @return success (boolean)
function Musician.Comm.PlaySongBand()
	if isBandActionPending then return false end
	if not Musician.Comm.CanPlay() then return false end
	if not currentSongCrc32 then return false end

	local groupChatType = Musician.Comm.GetGroupChatType()
	if groupChatType == nil then return false end

	isBandActionPending = true

	local message = tostring(currentSongCrc32)
	Musician.Comm:SendMessage(Musician.Events.CommSendAction, Musician.Comm.action.bandPlay)
	debugComm(true, Musician.Comm.event.bandPlay, groupChatType, message)
	Musician.Comm:SendCommMessage(Musician.Comm.event.bandPlay, message, groupChatType, nil, "ALERT")

	return true
end

--- OnBandPlay
--
function Musician.Comm.OnBandPlay(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	debugComm(false, prefix, sender .. "(" .. distribution .. ")", message)

	if Musician.Utils.PlayerIsMyself(sender) then
		isBandActionPending = false
		Musician.Comm:SendMessage(Musician.Events.CommSendActionComplete, Musician.Comm.action.bandPlay)
	end

	if not Musician.Utils.PlayerIsInGroup(sender) then return end
	if not isBandPlayReady then return end
	if Musician.Comm.IsSongPlaying() then return false end
	if Musician.Comm.GetGroupChatType() == nil then return end

	local songCrc32 = tonumber(message)
	if currentSongCrc32 ~= songCrc32 then return end

	-- Override next full promo emote if I'm not the initiator of band play to avoid spamming it
	if not Musician.Utils.PlayerIsMyself(sender) then
		Musician.Utils.OverrideNextFullPromoEmote()
	end

	Musician.Comm.PlaySong()

	Musician.Comm:SendMessage(Musician.Events.BandPlay, sender, songCrc32)
end

--- Stop song as a band
-- @return success (boolean)
function Musician.Comm.StopSongBand()
	if isBandActionPending then return false end
	if not Musician.Comm.CanBroadcast() then return false end
	if not currentSongCrc32 then return false end

	local groupChatType = Musician.Comm.GetGroupChatType()
	if groupChatType == nil then return false end

	isBandActionPending = true

	local message = tostring(currentSongCrc32)
	Musician.Comm:SendMessage(Musician.Events.CommSendAction, Musician.Comm.action.bandStop)
	debugComm(true, Musician.Comm.event.bandStop, groupChatType, message)
	Musician.Comm:SendCommMessage(Musician.Comm.event.bandStop, message, groupChatType, nil, "ALERT")

	return true
end

--- OnBandStop
--
function Musician.Comm.OnBandStop(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	debugComm(false, prefix, sender .. "(" .. distribution .. ")", message)

	if Musician.Utils.PlayerIsMyself(sender) then
		isBandActionPending = false
		Musician.Comm:SendMessage(Musician.Events.CommSendActionComplete, Musician.Comm.action.bandStop)
	end

	if not Musician.Utils.PlayerIsInGroup(sender) then return end

	local songCrc32 = tonumber(message)

	if not isBandPlayReady then return end
	if not Musician.Comm.IsSongPlaying() then return false end
	if currentSongCrc32 ~= songCrc32 then return end
	if Musician.Comm.GetGroupChatType() == nil then return end

	Musician.Comm.StopSong()

	Musician.Comm:SendMessage(Musician.Events.BandStop, sender, songCrc32)
end

--- OnSongPlay
--
function Musician.Comm.OnSongPlay(event, song)
	if not song.player then return end
	local player = song.player

	-- This is my song
	if Musician.Utils.PlayerIsMyself(player) and Musician.songs[player] ~= nil then
		isSongPlaying = true
	end
end

--- OnSongStop
--
function Musician.Comm.OnSongStop(event, song)
	if not song.player then return end
	local player = song.player

	-- This is my song
	if Musician.Utils.PlayerIsMyself(player) and Musician.songs[player] ~= nil then
		isSongPlaying = false
		isBandPlayReady = false -- I am no longer ready
		isStopPending = false
		-- Update song CRC32 by the one from the loaded song
		Musician.Comm.UpdateCurrentSongCrc32(Musician.sourceSong and Musician.sourceSong.crc32)
	end

	-- Remove player from ready band members
	readyBandPlayers[player] = nil

	Musician.Comm:SendMessage(Musician.Events.BandReadyPlayersUpdated)
end

--- OnDead
-- Stop music when dead
function Musician.Comm.OnDead()
	isStopPending = false
	isPlayPending = false
	Musician.Comm.StopSong()
end
