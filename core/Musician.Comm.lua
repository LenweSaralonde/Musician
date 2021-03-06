--- Communication module
-- @module Musician.Comm

Musician.Comm = LibStub("AceAddon-3.0"):NewAddon("Musician.Comm", "AceComm-3.0", "AceEvent-3.0")

local MODULE_NAME = "Comm"
Musician.AddModule(MODULE_NAME)

local LibDeflate = LibStub:GetLibrary("LibDeflate")

Musician.Comm.event = {}
Musician.Comm.event.stop = "MusicianStop"
Musician.Comm.event.stream = "MusicianStream6"
Musician.Comm.event.streamGroup = "MusicianGStream6"
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

local isBandPlayReady = false
local readyBandPlayers = {}
local currentSongCrc32

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

	if (event == Musician.Comm.event.stream) or (event == Musician.Comm.event.streamGroup) then
		message = "Song data (" .. #message .. ")"
	end

	event = "|cFFFF8000" .. event .. "|r"
	source = "|cFF00FFFF" .. source .. "|r"

	Musician.Utils.Debug(MODULE_NAME, prefix, event, source, message, ...)
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

	if not(IsLoggedIn()) then
		Musician.Comm:RegisterEvent("PLAYER_LOGIN", finishInit)
	else
		finishInit()
	end
end

--- Function executed when the communication channel has been successfullly joined
--
local function onChannelJoined()
	Musician.Registry.playersFetched = false
	Musician.Registry.SendHello()
	Musician.Registry.FetchPlayers()
	Musician.Comm:SendMessage(Musician.Events.CommChannelUpdate, true)
end

--- Function executed when failed to join the channel
-- @param reason (string)
local function onChannelFailed(reason)
	Musician.Comm:SendMessage(Musician.Events.CommChannelUpdate, false)
	if reason == WRONG_PASSWORD then
		joinChannelAfter = GetTime() + 300 -- Try again in 5 minutes
	else
		joinChannelAfter = GetTime() + 10 -- Try again in 10 seconds
	end
end

--- Function executed when leaving the channel
--
local function onChannelLeft()
	Musician.Comm:SendMessage(Musician.Events.CommChannelUpdate, false)
	joinChannelAfter = nil -- Rejoin ASAP
end

--- Reorder channels the keep the communication channel at the end of the list
--
local function reorderChannels()
	local index
	for index = 1, MAX_WOW_CHAT_CHANNELS - 1 do
		local _, channelName = GetChannelName(index)
		if channelName == Musician.CHANNEL then
			(SwapChatChannelByLocalID or C_ChatInfo.SwapChatChannelsByChannelIndex)(index, index + 1)
		end
	end
end

--- Join the communication channel and keep it joined
--
function Musician.Comm.JoinChannel()
	-- Channel joiner already active
	if Musician.Comm.channelJoiner ~= nil then return end

	-- Keep communication channel on top every time a channel is joined or left
	Musician.Comm:RegisterEvent("CHANNEL_UI_UPDATE", reorderChannels)

	-- Channel status changed
	Musician.Comm:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE", function(event, ...)
		local text, _, _, _, _, _, _, _, channelName = ...
		if channelName == Musician.CHANNEL then
			-- Successfully joined channed
			if text == 'YOU_CHANGED' or text == 'YOU_JOINED' then
				onChannelJoined(text)
			-- Something went wrong
			elseif text == 'WRONG_PASSWORD' or text == 'BANNED' then
				onChannelFailed(text)
			-- Left channel
			elseif text == 'YOU_LEFT' then
				onChannelLeft(text)
			end
		end

		-- Reorder channels when a new channel has been joined
		if text == 'YOU_CHANGED' or text == 'YOU_JOINED' then
			reorderChannels()
		end
	end)

	-- Channel is already joined
	if Musician.Comm.GetChannel() ~= nil then
		onChannelJoined()
		reorderChannels()
	else
		JoinTemporaryChannel(Musician.CHANNEL, Musician.PASSWORD)
	end

	-- Keep the channel joined
	Musician.Comm.channelJoiner = C_Timer.NewTicker(1, function()
		if Musician.Comm.GetChannel() == nil then
			if joinChannelAfter == nil or joinChannelAfter <= GetTime() then
				joinChannelAfter = nil
				JoinTemporaryChannel(Musician.CHANNEL, Musician.PASSWORD)
			end
		end
	end)
end

--- Return communication chat type for group
-- @return chatType (string)
function Musician.Comm.GetGroupChatType()
	local inInstance, instanceType = IsInInstance()
	local isF2P = IsTrialAccount()
	local inGroup = IsInGroup()
	local inRaid = IsInRaid()
	local inLFG = IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
	local inLFR = IsInRaid(LE_PARTY_CATEGORY_INSTANCE)
	local inBattleground = inRaid and inInstance and instanceType == "pvp"
	local chatType
	local channel

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

	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
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
	return WOW_PROJECT_ID == WOW_PROJECT_MAINLINE and Musician.Comm.GetChannel() ~= nil
end

--- Return true if the player can broadcast via the channel or the group chat
-- @return canBroadcast (boolean)
function Musician.Comm.CanBroadcast()
	return WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE or Musician.Comm.ChannelIsReady() or Musician.Comm.GetGroupChatType() ~= nil
end

--- Return true if the player can play music
-- @return canPlay (boolean)
function Musician.Comm.CanPlay()
	local playerIsAliveOrGhost = not(UnitIsDead("player")) or UnitIsGhost("player")
	return Musician.Comm.CanBroadcast() and playerIsAliveOrGhost
end

--- Play song
-- @return success (boolean)
function Musician.Comm.PlaySong()
	if isStopPending or isPlayPending then return false end
	if not(Musician.Comm.CanPlay()) or not(Musician.sourceSong) then return false end

	Musician.Utils.Debug(MODULE_NAME, "PlaySong")

	isPlayPending = true
	Musician.Comm:SendMessage(Musician.Events.CommSendAction, Musician.Comm.action.play)

	if Musician.streamingSong and Musician.streamingSong.streaming then
		Musician.streamingSong:StopStreaming()
	end

	Musician.streamingSong = Musician.sourceSong:Clone()
	collectgarbage()
	Musician.streamingSong:Stream()
	return true
end

--- Toggle play song
--
function Musician.Comm.TogglePlaySong()
	if Musician.streamingSong and Musician.streamingSong.streaming and not(Musician.streamingSong.isLiveStreamingSong) then
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
	if not(Musician.Comm.CanPlay()) then return false end
	Musician.Comm.StreamCompressedSongChunk(LibDeflate:CompressDeflate(packedChunk, { level = 9 }))
end

--- Stream a compressed song chunk
-- @param compressedChunk (string)
-- @return success (boolean)
function Musician.Comm.StreamCompressedSongChunk(compressedChunk)
	if not(Musician.Comm.CanPlay()) then return false end

	local serializedChunk
	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
		serializedChunk = LibDeflate:EncodeForWoWAddonChannel(compressedChunk)
	else
		serializedChunk = Musician.Utils.Base64Encode(compressedChunk) -- LibDeflate:EncodeForWoWAddonChannel fails over YELL
	end

	-- Calculate used bandwidth
	local bwMin = Musician.BANDWIDTH_LIMIT_MIN
	local bwMax = Musician.BANDWIDTH_LIMIT_MAX + 1
	local bandwidth = (max(bwMin, min(bwMax, #serializedChunk)) - bwMin) / (bwMax - bwMin)
	Musician.Comm:SendMessage(Musician.Events.Bandwidth, bandwidth)

	Musician.Comm.BroadcastCommMessage(serializedChunk, Musician.Comm.event.stream, Musician.Comm.event.streamGroup)
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
	Musician.Comm:SendMessage(Musician.Events.SongChunk, sender, mode, songId, chunkDuration, playtimeLeft, unpack(position))

	-- No longer in loading range
	if not(Musician.Registry.PlayerIsInLoadingRange(sender)) then
		-- Stop and clear existing song
		if Musician.songs[sender] then
			Musician.songs[sender]:Stop()
			Musician.songs[sender] = nil
			collectgarbage()
		end
		return
	end

	-- Starting a new song over an existing one
	if Musician.songs[sender] and Musician.songs[sender].songId ~= songId then
		-- Clear existing song
		Musician.songs[sender]:Stop()
		Musician.songs[sender] = nil
		collectgarbage()
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
	if not(receivingSong:IsPlaying()) and not(receivingSong.willPlay) then

		-- Play song with delay to anticipate lag
		local playDelay = chunkDuration / 2
		receivingSong.willPlay = true
		receivingSong:Play(playDelay)
		receivingSong.playStartTime = debugprofilestop() / 1000

		-- Catch up out-of-sync songs in band play mode due to server lag
		if mode == Musician.Song.MODE_DURATION then
			local delayMin = 1 / 60
			local delayMax = playDelay
			for _, song in pairs(Musician.songs) do
				if receivingSong ~= song and song:IsPlaying() and song.playStartTime then
					-- Consider the songs belong to the same band if they have the same playtime left
					local songPlaytimeLeft = song.cropTo - song.chunkTime

					-- Calculate synchronization delay
					local syncDelay = (receivingSong.playStartTime - receivingSong.cursor - song.playStartTime) % chunkDuration

					-- The newly receiving song has same playing time left as the already playing one and is slightly late with it
					if playtimeLeft == songPlaytimeLeft + song.chunkDuration and syncDelay > delayMin and syncDelay < delayMax then
						-- Catch up sync delay for the receiving song
						receivingSong:Seek(syncDelay)
					-- The newly receiving song has same playing time left as the already playing one and is slightly early with it
					elseif playtimeLeft == songPlaytimeLeft and syncDelay > delayMax and syncDelay < chunkDuration - delayMin then
						-- Catch up sync delay for the already playing song
						song:Seek(song.cursor + chunkDuration - syncDelay)
						song.playStartTime = song.playStartTime - chunkDuration + syncDelay
					end
				end
			end
		end

		if Musician.Utils.PlayerIsMyself(sender) then
			isPlayPending = false
			Musician.Comm:SendMessage(Musician.Events.CommSendActionComplete, Musician.Comm.action.play)
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
	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
		isGroup = distribution ~= 'CHANNEL'
	else
		isGroup = distribution == 'PARTY' or distribution == 'RAID' or distribution == 'INSTANCE_CHAT'
	end

	local senderIsInGroup = Musician.Utils.PlayerIsInGroup(sender)
	if not(isGroup) and senderIsInGroup then
		return
	end

	local packedChunk
	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
		packedChunk = LibDeflate:DecompressDeflate(LibDeflate:DecodeForWoWAddonChannel(message))
	else
		packedChunk = LibDeflate:DecompressDeflate(Musician.Utils.Base64Decode(message)) -- LibDeflate:DecodeForWoWAddonChannel fails over YELL
	end

	Musician.Comm.ProcessChunk(packedChunk, sender, isGroup)
end

--- Stop song
-- @return success (boolean)
function Musician.Comm.StopSong()
	if isStopPending or isPlayPending then return false end
	if not(Musician.Comm.CanBroadcast()) then return false end
	if Musician.streamingSong and Musician.streamingSong.streaming then
		Musician.Utils.Debug(MODULE_NAME, "StopSong")
		Musician.streamingSong:StopStreaming()
		Musician.streamingSong = nil
		collectgarbage()
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
	if not(Musician.sourceSong) then return {} end
	local readyPlayers = {}
	local player, playerCrc32

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

	if not(Musician.Utils.PlayerIsInGroup(sender)) then return end
	if not(currentSongCrc32) then return end

	-- Send ready message in return
	local groupChatType = Musician.Comm.GetGroupChatType()
	if isBandPlayReady and groupChatType then
		local message = tostring(currentSongCrc32)
		debugComm(true, Musician.Comm.event.bandReady, groupChatType, message)
		Musician.Comm:SendCommMessage(Musician.Comm.event.bandReady, message, groupChatType, nil, "ALERT")
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
	local player, songCrc32
	local isUpdated = false
	for player, songCrc32 in pairs(readyBandPlayers) do
		if not(Musician.Utils.PlayerIsInGroup(player)) then
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
	Musician.Comm.SetBandPlayReady(not(isBandPlayReady))
end

--- Set band play ready
-- @param isReady (boolean)
-- @return success (boolean)
function Musician.Comm.SetBandPlayReady(isReady)
	if isBandActionPending then return false end
	if not(Musician.Comm.CanBroadcast()) then return false end
	if not(currentSongCrc32) then return false end

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

	if not(Musician.Utils.PlayerIsInGroup(sender)) then return end

	local isReady = prefix == Musician.Comm.event.bandReady
	local songCrc32 = tonumber(message)

	if Musician.Utils.PlayerIsMyself(sender) then
		isBandPlayReady = isReady
		local action = isReady and Musician.Comm.action.bandReady or Musician.Comm.action.bandNotReady
		isBandActionPending = false
		Musician.Comm:SendMessage(Musician.Events.CommSendActionComplete, action)
	end

	-- Add/remove player in ready band members
	local wasReady = not(not(readyBandPlayers[sender]))
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
	if not(Musician.Comm.CanPlay()) then return false end
	if not(currentSongCrc32) then return false end

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

	if not(Musician.Utils.PlayerIsInGroup(sender)) then return end
	if not(isBandPlayReady) then return end
	if Musician.Comm.IsSongPlaying() then return false end
	if Musician.Comm.GetGroupChatType() == nil then return end

	local songCrc32 = tonumber(message)
	if currentSongCrc32 ~= songCrc32 then return end

	-- Override next full promo emote if I'm not the initiator of band play to avoid spamming it
	if not(Musician.Utils.PlayerIsMyself(sender)) then
		Musician.Utils.OverrideNextFullPromoEmote()
	end

	Musician.Comm.PlaySong()

	Musician.Comm:SendMessage(Musician.Events.BandPlay, sender, songCrc32)
end

--- Stop song as a band
-- @return success (boolean)
function Musician.Comm.StopSongBand()
	if isBandActionPending then return false end
	if not(Musician.Comm.CanBroadcast()) then return false end
	if not(currentSongCrc32) then return false end

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

	if not(Musician.Utils.PlayerIsInGroup(sender)) then return end

	songCrc32 = tonumber(message)

	if not(isBandPlayReady) then return end
	if not(Musician.Comm.IsSongPlaying()) then return false end
	if currentSongCrc32 ~= songCrc32 then return end
	if Musician.Comm.GetGroupChatType() == nil then return end

	Musician.Comm.StopSong()

	Musician.Comm:SendMessage(Musician.Events.BandStop, sender, songCrc32)
end

--- OnSongPlay
--
function Musician.Comm.OnSongPlay(event, song)
	if not(song.player) then return end
	local player = song.player

	-- This is my song
	if Musician.Utils.PlayerIsMyself(player) and Musician.songs[player] ~= nil then
		isSongPlaying = true
	end
end

--- OnSongStop
--
function Musician.Comm.OnSongStop(event, song)
	if not(song.player) then return end
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
	local wasReady = not(not(readyBandPlayers[player]))
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