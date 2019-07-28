Musician.Comm = LibStub("AceAddon-3.0"):NewAddon("Musician.Comm", "AceComm-3.0", "AceEvent-3.0")

local MODULE_NAME = "Comm"
Musician.AddModule(MODULE_NAME)

local LibDeflate = LibStub:GetLibrary("LibDeflate")

Musician.Comm.event = {}
Musician.Comm.event.stop = "MusicianStop"
Musician.Comm.event.stream = "MusicianStreamD"
Musician.Comm.event.streamGroup = "MusicianGStreamD"
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

Musician.Comm.isPlaySent = false
Musician.Comm.isStopSent = false
Musician.Comm.isBandActionSent = false

local canJoinChannel = true
local channelIsJoined = false
local channelWasAlreadyJoined = false
local joinChannelAfter
local isBandPlayReady = false
local readyBandPlayers = {}
local currentSongCrc32

--- Prints debug message
-- @param out (boolean) Outgoing message
-- @param event (string)
-- @param source (string)
-- @param ... (string)
local function debug(out, event, source, message, ...)
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
Musician.Comm.Debug = debug

--- Initialize communication
--
function Musician.Comm.Init()

	local initialized = false

	-- Register prefixes
	Musician.Comm:RegisterEvent("PLAYER_ENTERING_WORLD", function()
		C_Timer.After(1, function() Musician.Utils.MuteGameMusic(true) end)

		if initialized then return end

		initialized = true

		Musician.Comm.JoinChannel()
		Musician.Comm.OnGroupJoined()
	end)

	Musician.Comm:RegisterMessage(Musician.Events.SourceSongLoaded, Musician.Comm.OnSongLoaded)
	Musician.Comm:RegisterMessage(Musician.Events.SongStop, Musician.Comm.OnSongStop)
	Musician.Comm:RegisterEvent("GROUP_JOINED", Musician.Comm.OnGroupJoined)
	Musician.Comm:RegisterEvent("GROUP_LEFT", Musician.Comm.OnGroupLeft)
	Musician.Comm:RegisterEvent("GROUP_ROSTER_UPDATE", Musician.Comm.OnRosterUpdate)
end

--- Join the communication channel and keep it joined
--
function Musician.Comm.JoinChannel()
	-- Channel joiner already active
	if Musician.Comm.channelJoiner ~= nil then return end

	--- Function executed when the channel has been successfullly joined
	local function OnChannelJoined(reason)
		channelIsJoined = true
		channelWasAlreadyJoined = true
		canJoinChannel = true
		Musician.Registry.playersFetched = false
		Musician.Registry.SendHello()
		Musician.Registry.FetchPlayers()
		Musician.Comm:SendMessage(Musician.Events.CommChannelUpdate, true)
	end

	--- Function executed when failed to join the channel
	local function OnChannelFailed(reason)
		canJoinChannel = false
		channelIsJoined = false
		Musician.Comm:SendMessage(Musician.Events.CommChannelUpdate, false)
		if reason == WRONG_PASSWORD then
			joinChannelAfter = GetTime() + 300 -- Try again in 5 minutes
		else
			joinChannelAfter = GetTime() + 10 -- Try again in 10 seconds
		end
	end

	--- Function executed when leaving the channel
	local function OnChannelLeft(reason)
		canJoinChannel = true
		channelIsJoined = false
		Musician.Comm:SendMessage(Musician.Events.CommChannelUpdate, false)
		joinChannelAfter = GetTime() -- Rejoin ASAP
	end

	-- Channel status changed
	Musician.Comm:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE", function(event, text, _, _, _, _, _, _, _, channelName)
		if channelName == Musician.CHANNEL then
			-- Successfully joined channed
			if text == 'YOU_CHANGED' or text == 'YOU_JOINED' then
				OnChannelJoined(text)
			-- Something went wrong
			elseif text == 'WRONG_PASSWORD' or text == 'BANNED' then
				OnChannelFailed(text)
			-- Left channel
			elseif text == 'YOU_LEFT' then
				OnChannelLeft(text)
			end
		end
	end)

	-- Channel is already joined
	if Musician.Comm.getChannel() ~= nil then
		OnChannelJoined()
	end

	-- Join channel with keepalive
	local joinedChannelCount
	Musician.Comm.channelJoiner = C_Timer.NewTicker(1, function()
		if not(channelIsJoined) then
			local newJoinedChannelCount = #{GetChannelList()}

			-- Channel has not been joined yet and the number of joined channels is still changing
			if not(channelWasAlreadyJoined) and newJoinedChannelCount ~= joinedChannelCount then
				joinedChannelCount = newJoinedChannelCount
				joinChannelAfter = GetTime() + 4 -- Wait 4 seconds
			end

			if joinChannelAfter and joinChannelAfter < GetTime() then
				joinChannelAfter = nil
				JoinTemporaryChannel(Musician.CHANNEL, Musician.PASSWORD)
			end
		end
	end)
end

--- Return communication chat type for group
-- @return (string)
function Musician.Comm.GetGroupChatType()
	local inInstance, instanceType = IsInInstance()
	local isF2P = IsTrialAccount()
	local inGroup = IsInGroup()
	local inRaid = IsInRaid()
	local inLFG = IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
	local inLFR = IsInRaid(LE_PARTY_CATEGORY_INSTANCE)
	local chatType
	local channel

	if isF2P and inRaid then
		return nil -- Disable raid broadcasting for trial accounts
	elseif inRaid and inInstance and instanceType == "pvp" then
		return "BATTLEGROUND"
	elseif inLFG or inLFR then
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
-- @param [groupType (string)]
function Musician.Comm.BroadcastCommMessage(message, type, groupType)
	if groupType == nil then
		groupType = type
	end

	local groupChatType = Musician.Comm.GetGroupChatType()
	if groupChatType then
		debug(true, groupType, groupChatType, message)
		Musician.Comm:SendCommMessage(groupType, message, groupChatType, nil, "ALERT")
	end
	if Musician.Comm.ChannelIsReady() then
		debug(true, type, "CHANNEL " .. Musician.Comm.getChannel(), message)
		Musician.Comm:SendCommMessage(type, message, "CHANNEL", Musician.Comm.getChannel(), "ALERT")
	end
end

--- Return the communication channel ID
-- @return (string)
function Musician.Comm.getChannel()
	local channelId, _ = GetChannelName(Musician.CHANNEL)

	if channelId ~= 0 then
		return channelId
	else
		return nil
	end
end

--- Return true if the communication channel is ready
-- @return (boolean)
function Musician.Comm.ChannelIsReady()
	return channelIsJoined
end

--- Return true if the player can broadcast via the channel or the group chat
-- @return (boolean)
function Musician.Comm.CanBroadcast()
	return Musician.Comm.ChannelIsReady() or Musician.Comm.GetGroupChatType() ~= nil
end

--- Play song
-- @return (boolean)
function Musician.Comm.PlaySong()
	if Musician.Comm.isStopSent or Musician.Comm.isPlaySent then return false end
	if not(Musician.Comm.CanBroadcast()) or not(Musician.sourceSong) then return false end

	Musician.Comm.isPlaySent = true
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
	if Musician.streamingSong and Musician.streamingSong.streaming then
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
	if not(Musician.Comm.CanBroadcast()) then return false end
	Musician.Comm.StreamCompressedSongChunk(LibDeflate:CompressDeflate(packedChunk, { level = 9 }))
end

--- Stream a compressed song chunk
-- @param packedChunk (string)
-- @return (boolean)
function Musician.Comm.StreamCompressedSongChunk(compressedChunk)
	if not(Musician.Comm.CanBroadcast()) then return false end
	local serializedChunk = LibDeflate:EncodeForWoWAddonChannel(compressedChunk)

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
-- @param [forcePlay (boolean)] Force the chunk to be played, even if the player is not in range (groups)
function Musician.Comm.ProcessChunk(packedChunk, sender, forcePlay)

	-- Decode chunk header
	local mode, songId, chunkDuration, playtimeLeft, position = Musician.Song.UnpackChunkHeader(packedChunk)

	-- Invalid chunk
	if mode == nil then
		return
	end

	sender = Musician.Utils.NormalizePlayerName(sender)

	-- Update player position
	Musician.Registry.UpdatePlayerPositionAndGUID(sender, unpack(position))

	-- No longer in loading range
	if not(Musician.Registry.PlayerIsInLoadingRange(sender)) then
		-- Stop currently playing music
		if Musician.songs[sender] ~= nil then
			Musician.songs[sender]:Stop()
			Musician.songs[sender] = nil
			collectgarbage()
		end
		return
	end

	-- Create playing song, if missing
	if Musician.songs[sender] == nil then
		Musician.songs[sender] = Musician.Song.create()
	elseif not(Musician.songs[sender].isStreamed) or (Musician.songs[sender].songId ~= songId) then
		Musician.songs[sender]:Stop()
		Musician.songs[sender] = Musician.Song.create()
		collectgarbage()
	end

	-- Decode chunk data
	local chunk = Musician.Song.UnpackChunkData(packedChunk)
	if chunk == nil then
		return
	end

	-- Append chunk data
	Musician.songs[sender]:AppendChunk(chunk, mode, songId, chunkDuration, playtimeLeft, sender)

	-- Play song if not already started
	if not(Musician.songs[sender]:IsPlaying()) and not(Musician.songs[sender].willPlay) then
		Musician.songs[sender].willPlay = true
		Musician.songs[sender]:Play(chunkDuration / 2)
		if Musician.Utils.PlayerIsMyself(sender) then
			Musician.Comm.isPlaySent = false
			Musician.Comm:SendMessage(Musician.Events.CommSendActionComplete, Musician.Comm.action.play)
		end
	end
end

--- Receive compressed chunk
--
local function OnChunk(prefix, message, distribution, sender)
	debug(false, prefix, sender .. "(" .. distribution .. ")", message)

	Musician.Registry.RegisterPlayer(sender)

	-- Rejecting channel chunks if the sender is also sending group chunks
	local isGroup = distribution ~= 'CHANNEL'
	local senderIsInGroup = Musician.Utils.PlayerIsInGroup(sender)
	if not(isGroup) and senderIsInGroup then
		return
	end

	local packedChunk = LibDeflate:DecompressDeflate(LibDeflate:DecodeForWoWAddonChannel(message))
	Musician.Comm.ProcessChunk(packedChunk, sender, isGroup)
end

Musician.Comm:RegisterComm(Musician.Comm.event.stream, OnChunk)
Musician.Comm:RegisterComm(Musician.Comm.event.streamGroup, OnChunk)

--- Stop song
-- @return (boolean)
function Musician.Comm.StopSong()
	if Musician.Comm.isStopSent or Musician.Comm.isPlaySent then return false end
	if not(Musician.Comm.CanBroadcast()) then return false end
	if Musician.streamingSong and Musician.streamingSong.streaming then
		Musician.streamingSong:StopStreaming()
		Musician.streamingSong = nil
		collectgarbage()
	end
	Musician.Comm.isStopSent = true
	Musician.Comm:SendMessage(Musician.Events.CommSendAction, Musician.Comm.action.stop)
	Musician.Comm.BroadcastCommMessage(Musician.Comm.event.stop, Musician.Comm.event.stop)
	return true
end

--- Stop a song
--
Musician.Comm:RegisterComm(Musician.Comm.event.stop, function(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	debug(false, prefix, sender .. "(" .. distribution .. ")", message)
	Musician.StopPlayerSong(sender, true)
	if Musician.Utils.PlayerIsMyself(sender) then
		Musician.Comm.isStopSent = false
		Musician.Comm:SendMessage(Musician.Events.CommSendActionComplete, Musician.Comm.action.stop)
	end
end)

--- Return the list of ready band players for the current source song
-- @return (table)
function Musician.Comm.GetReadyBandPlayers()
	if not(Musician.sourceSong) then return {} end
	local songCrc32 = Musician.sourceSong.crc32
	local readyPlayers = {}
	local player, playerData

	for player, playerData in pairs(readyBandPlayers) do
		if playerData[1] == songCrc32 then
			table.insert(readyPlayers, player)
		end
	end

	return readyPlayers
end

--- Return the band latency (ms)
-- @return (number)
function Musician.Comm.GetBandLatency()
	if not(Musician.sourceSong) then return nil end
	local songCrc32 = Musician.sourceSong.crc32
	local latency = 0
	local player, playerData

	for player, playerData in pairs(readyBandPlayers) do
		if playerData[1] == songCrc32 then
			latency = max(latency, playerData[2])
		end
	end

	return latency
end

--- Return "band ready" message contents
-- @param isReady (boolean)
-- @return (string)
function Musician.Comm.GetBandReadyMessage(isReady)
	if not(Musician.sourceSong) or not(Musician.sourceSong.crc32) then return end

	if isReady then
		local latency = select(4, GetNetStats())
		return Musician.sourceSong.crc32 .. " " .. latency
	else
		return tostring(Musician.sourceSong.crc32)
	end
end

--- OnGroupJoined
--
function Musician.Comm.OnGroupJoined()
	readyBandPlayers = {}
	isBandPlayReady = false
	local groupChatType = Musician.Comm.GetGroupChatType()
	if groupChatType then
		local message = Musician.Comm.event.bandReadyQuery
		debug(true, Musician.Comm.event.bandReadyQuery, groupChatType, message)
		Musician.Comm:SendCommMessage(Musician.Comm.event.bandReadyQuery, message, groupChatType, nil, "ALERT")
	end
end

--- OnBandReadyQuery
--
function Musician.Comm.OnBandReadyQuery(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	debug(false, prefix, sender .. "(" .. distribution .. ")", message)

	if not(Musician.Utils.PlayerIsInGroup(sender)) then return end

	-- Send ready query to the player
	local groupChatType = Musician.Comm.GetGroupChatType()
	if isBandPlayReady and groupChatType then
		local message = Musician.Comm.GetBandReadyMessage(true)
		local groupChatType = Musician.Comm.GetGroupChatType()
		debug(true, Musician.Comm.event.bandReady, groupChatType, message)
		Musician.Comm:SendCommMessage(Musician.Comm.event.bandReady, message, groupChatType, nil, "ALERT")
	end

	-- If the player was ready before, it's obvious that it's no longer the case so remove it
	if readyBandPlayers[sender] then
		local songCrc32 = readyBandPlayers[sender][1]
		readyBandPlayers[sender] = nil
		Musician.Comm:SendMessage(Musician.Events.BandPlayReady, sender, songCrc32, false, prefix)
	end
end
Musician.Comm:RegisterComm(Musician.Comm.event.bandReadyQuery, Musician.Comm.OnBandReadyQuery)

--- OnGroupLeft
--
function Musician.Comm.OnGroupLeft()
	readyBandPlayers = {}
	isBandPlayReady = false
end

--- OnRosterUpdate
--
function Musician.Comm.OnRosterUpdate(event)
	-- Remove players from readyBandPlayers who are no longer in the group
	local player
	for player, _ in pairs(readyBandPlayers) do
		if not(Musician.Utils.PlayerIsInGroup(player)) then
			local songCrc32 = readyBandPlayers[player][1]
			readyBandPlayers[player] = nil
			Musician.Comm:SendMessage(Musician.Events.BandPlayReady, player, songCrc32, false, event)
		end
	end
end

--- OnSongLoaded
--
function Musician.Comm.OnSongLoaded(event)

	-- Send a "not ready" message for the previous song
	local groupChatType = Musician.Comm.GetGroupChatType()
	if isBandPlayReady and groupChatType ~= nil and currentSongCrc32 ~= nil then
		local message = tostring(currentSongCrc32)
		Musician.Comm.isBandActionSent = true
		isBandPlayReady = false
		Musician.Comm:SendMessage(Musician.Events.CommSendAction, Musician.Comm.action.bandNotReady)
		debug(true, Musician.Comm.event.bandNotReady, groupChatType, message)
		Musician.Comm:SendCommMessage(Musician.Comm.event.bandNotReady, message, groupChatType, nil, "ALERT")
	end

	-- Band play is no longer ready
	local wasReady = isBandPlayReady
	isBandPlayReady = false

	local player = Musician.Utils.NormalizePlayerName(UnitName("player"))

	-- Send local event
	if wasReady then
		Musician.Comm:SendMessage(Musician.Events.BandPlayReady, player, currentSongCrc32, false, event)
	end

	-- Remove myself from readyBandPlayers
	readyBandPlayers[player] = nil

	-- Update current song CRC32
	currentSongCrc32 = Musician.sourceSong and Musician.sourceSong.crc32
end

--- Indicates if the player is ready for band play
-- @return (boolean)
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
-- @return (boolean)
function Musician.Comm.SetBandPlayReady(isReady)
	if Musician.Comm.isBandActionSent then return false end
	if not(Musician.Comm.CanBroadcast()) then return false end
	if not(Musician.sourceSong) or not(Musician.sourceSong.crc32) then return false end

	local groupChatType = Musician.Comm.GetGroupChatType()
	if groupChatType == nil then return false end

	Musician.Comm.isBandActionSent = true

	local type = isReady and Musician.Comm.event.bandReady or Musician.Comm.event.bandNotReady
	local action = isReady and Musician.Comm.action.bandReady or Musician.Comm.action.bandNotReady
	local message = Musician.Comm.GetBandReadyMessage(isReady)
	Musician.Comm:SendMessage(Musician.Events.CommSendAction, action)
	debug(true, type, groupChatType, message)
	Musician.Comm:SendCommMessage(type, message, groupChatType, nil, "ALERT")

	return true
end

--- Receive band ready or not ready message
--
function Musician.Comm.OnBandPlayReady(prefix, message, distribution, sender)

	sender = Musician.Utils.NormalizePlayerName(sender)
	debug(false, prefix, sender .. "(" .. distribution .. ")", message)

	if not(Musician.Utils.PlayerIsInGroup(sender)) then return end

	local isReady = prefix == Musician.Comm.event.bandReady
	local songCrc32, latency = strsplit(" ", message)
	songCrc32 = tonumber(songCrc32)
	latency = tonumber(latency)

	if Musician.Utils.PlayerIsMyself(sender) then
		isBandPlayReady = isReady
		local action = isReady and Musician.Comm.action.bandReady or Musician.Comm.action.bandNotReady
		Musician.Comm.isBandActionSent = false
		Musician.Comm:SendMessage(Musician.Events.CommSendActionComplete, action)
	end

	-- Add/remove player in ready band members
	local wasReady = not(not(readyBandPlayers[sender]))
	readyBandPlayers[sender] = isReady and { songCrc32, latency } or nil

	-- Trigger local event if ready status have changed
	if wasReady ~= isReady then
		Musician.Comm:SendMessage(Musician.Events.BandPlayReady, sender, songCrc32, isReady, prefix)
	end
end

Musician.Comm:RegisterComm(Musician.Comm.event.bandReady, Musician.Comm.OnBandPlayReady)
Musician.Comm:RegisterComm(Musician.Comm.event.bandNotReady, Musician.Comm.OnBandPlayReady)

--- Play song as a band
-- @return (boolean)
function Musician.Comm.PlaySongBand()
	if Musician.Comm.isBandActionSent then return false end
	if not(Musician.Comm.CanBroadcast()) then return false end
	if not(Musician.sourceSong) or not(Musician.sourceSong.crc32) then return false end

	local groupChatType = Musician.Comm.GetGroupChatType()
	if groupChatType == nil then return false end

	Musician.Comm.isBandActionSent = true

	local message = Musician.sourceSong.crc32 .. " " .. Musician.Comm.GetBandLatency()
	Musician.Comm:SendMessage(Musician.Events.CommSendAction, Musician.Comm.action.bandPlay)
	debug(true, Musician.Comm.event.bandPlay, groupChatType, message)
	Musician.Comm:SendCommMessage(Musician.Comm.event.bandPlay, message, groupChatType, nil, "ALERT")

	return true
end

--- OnBandPlay
--
function Musician.Comm.OnBandPlay(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	debug(false, prefix, sender .. "(" .. distribution .. ")", message)

	if not(Musician.Utils.PlayerIsInGroup(sender)) then return end

	local songCrc32, bandLatency = strsplit(" ", message)
	songCrc32 = tonumber(songCrc32)
	bandLatency = tonumber(bandLatency)

	if not(isBandPlayReady) then return end
	if not(Musician.sourceSong) or Musician.sourceSong.crc32 ~= songCrc32 then return end

	if Musician.Utils.PlayerIsMyself(sender) then
		Musician.Comm.isBandActionSent = false
		Musician.Comm:SendMessage(Musician.Events.CommSendActionComplete, Musician.Comm.action.bandPlay)
	end

	local myLatency = select(4, GetNetStats())
	local delay = max(0, bandLatency - myLatency) / 1000

	C_Timer.After(delay, Musician.Comm.PlaySong)

	Musician.Comm:SendMessage(Musician.Events.BandPlay, sender, songCrc32)
end
Musician.Comm:RegisterComm(Musician.Comm.event.bandPlay, Musician.Comm.OnBandPlay)

--- Stop song as a band
-- @return (boolean)
function Musician.Comm.StopSongBand()
	if Musician.Comm.isBandActionSent then return false end
	if not(Musician.Comm.CanBroadcast()) then return false end
	if not(Musician.sourceSong) or not(Musician.sourceSong.crc32) then return false end

	local groupChatType = Musician.Comm.GetGroupChatType()
	if groupChatType == nil then return false end

	Musician.Comm.isBandActionSent = true

	local message = tostring(Musician.sourceSong.crc32)
	Musician.Comm:SendMessage(Musician.Events.CommSendAction, Musician.Comm.action.bandStop)
	debug(true, Musician.Comm.event.bandStop, groupChatType, message)
	Musician.Comm:SendCommMessage(Musician.Comm.event.bandStop, message, groupChatType, nil, "ALERT")

	return true
end

--- OnBandStop
--
function Musician.Comm.OnBandStop(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	debug(false, prefix, sender .. "(" .. distribution .. ")", message)

	if not(Musician.Utils.PlayerIsInGroup(sender)) then return end

	songCrc32 = tonumber(message)

	if not(isBandPlayReady) then return end
	if not(Musician.sourceSong) or Musician.sourceSong.crc32 ~= songCrc32 then return end

	if Musician.Utils.PlayerIsMyself(sender) then
		Musician.Comm.isBandActionSent = false
		Musician.Comm:SendMessage(Musician.Events.CommSendActionComplete, Musician.Comm.action.bandStop)
	end

	Musician.Comm.StopSong()

	Musician.Comm:SendMessage(Musician.Events.BandStop, sender, songCrc32)
end
Musician.Comm:RegisterComm(Musician.Comm.event.bandStop, Musician.Comm.OnBandStop)

--- OnSongStop
--
function Musician.Comm.OnSongStop(event, song)
	if not(song.player) then return end
	local player = song.player

	-- I am no longer ready
	if Musician.Utils.PlayerIsMyself(player) then
		isBandPlayReady = false
	end

	-- Add/remove player in ready band members
	local wasReady = not(not(readyBandPlayers[player]))
	readyBandPlayers[player] = isReady and { songCrc32, latency } or nil

	-- Trigger local event if ready status have changed
	if wasReady ~= isReady then
		Musician.Comm:SendMessage(Musician.Events.BandPlayReady, player, songCrc32, isReady, event)
	end
end