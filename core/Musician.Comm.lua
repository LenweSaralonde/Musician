Musician.Comm = LibStub("AceAddon-3.0"):NewAddon("Musician.Comm", "AceComm-3.0", "AceEvent-3.0")

local LibDeflate = LibStub:GetLibrary("LibDeflate")

Musician.Comm.event = {}
Musician.Comm.event.stop   = "MusicianStop"
Musician.Comm.event.stream = "MusicianStreamD"
Musician.Comm.event.streamGroup = "MusicianGStreamD"

Musician.Comm.isPlaySent = false
Musician.Comm.isStopSent = false

local canJoinChannel = true
local channelIsJoined = false
local channelWasAlreadyJoined = false
local joinChannelAfter

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
	end)
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
		Musician.Comm:SendMessage(Musician.Events.RefreshFrame)
	end

	--- Function executed when failed to join the channel
	local function OnChannelFailed(reason)
		canJoinChannel = false
		channelIsJoined = false
		Musician.Comm:SendMessage(Musician.Events.RefreshFrame)
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
		Musician.Comm:SendMessage(Musician.Events.RefreshFrame)
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
		Musician.Comm:SendCommMessage(groupType, message, groupChatType, nil, "ALERT")
	end
	if Musician.Comm.ChannelIsReady() then
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
	if not(Musician.Comm.CanBroadcast()) or not(Musician.sourceSong) then return false end

	Musician.Comm.isPlaySent = true
	Musician.Comm:SendMessage(Musician.Events.RefreshFrame)

	if Musician.streamingSong and Musician.streamingSong.streaming then
		Musician.streamingSong:StopStreaming()
	end

	Musician.streamingSong = Musician.sourceSong:Clone()
	collectgarbage()
	Musician.streamingSong:Stream()
	return true
end

--- Toggle play song
-- @return (boolean)
function Musician.Comm.TogglePlaySong()
	if Musician.Comm.isStopSent or Musician.Comm.isPlaySent then return end
	if Musician.streamingSong and Musician.streamingSong.streaming then
		Musician.Comm.StopSong()
	else
		Musician.Comm.PlaySong()
	end
end

--- Stream a packed song chunk
-- @param packedChunk (string)
-- @return (boolean)
function Musician.Comm.StreamSongChunk(packedChunk)
	if not(Musician.Comm.CanBroadcast()) then return false end
	Musician.Comm.StreamCompressedSongChunk(LibDeflate:CompressDeflate(packedChunk))
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
	end
end

--- Receive compressed chunk
--
local function OnChunk(prefix, message, distribution, sender)
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
	if not(Musician.Comm.CanBroadcast()) then return false end
	if Musician.streamingSong and Musician.streamingSong.streaming then
		Musician.streamingSong:StopStreaming()
		Musician.streamingSong = nil
		collectgarbage()
	end
	Musician.Comm.isStopSent = true
	Musician.Comm:SendMessage(Musician.Events.RefreshFrame)
	Musician.Comm.BroadcastCommMessage(Musician.Comm.event.stop, Musician.Comm.event.stop)
	return true
end

--- Stop a song
--
Musician.Comm:RegisterComm(Musician.Comm.event.stop, function(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	Musician.StopPlayerSong(sender, true)
	if sender == Musician.Utils.NormalizePlayerName(UnitName("player")) then
		Musician.Comm.isStopSent = false
		Musician.Comm:SendMessage(Musician.Events.RefreshFrame)
	end
end)

