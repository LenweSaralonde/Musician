Musician.Comm = LibStub("AceAddon-3.0"):NewAddon("Musician.Comm", "AceComm-3.0", "AceEvent-3.0")

local LibCompress = LibStub:GetLibrary("LibCompress")
local LibCompressEncodeTable = LibCompress:GetAddonEncodeTable()

Musician.Comm.event = {}
Musician.Comm.event.stop   = "MusicianStop"
Musician.Comm.event.stream = "MusicianStream"
Musician.Comm.event.streamGroup = "MusicianGStream"

Musician.Comm.isPlaySent = false
Musician.Comm.isStopSent = false

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
	if Musician.Comm.channelJoiner ~= nil then return end

	local joinedChannelCount = #{GetChannelList()}

	Musician.Comm.channelJoiner = C_Timer.NewTicker(4, function()
		local channelId, _ = GetChannelName(Musician.CHANNEL)

		if channelId == 0 then
			Musician.Registry.playersFetched = false
			local newJoinedChannelCount = #{GetChannelList()}

			if newJoinedChannelCount > 0 and newJoinedChannelCount == joinedChannelCount then
				JoinTemporaryChannel(Musician.CHANNEL, Musician.PASSWORD)
			end

			joinedChannelCount = newJoinedChannelCount
		end

		Musician.Registry.FetchPlayers()
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
	if not(IsInInstance()) or groupChatType == nil then
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

--- Return true if the communication prototcol is ready
-- @return (boolean)
function Musician.Comm.isReady()
	return Musician.Comm.getChannel() ~= nil
end

--- Return true if the player supports group communication
-- @param name (string)
-- @return (boolean)
function Musician.Comm.PlayerHasGroupSupport(name)
	if not(Musician.Registry.players[name]) then
		return false
	end
	local player = Musician.Registry.players[name]
	return player.groupSupport or player.version and (Musician.Utils.VersionCompare(player.version, '1.4.1.0') >= 0)
end

--- Play song
-- @return (boolean)
function Musician.Comm.PlaySong()
	if not(Musician.Comm.isReady()) or not(Musician.sourceSong) then return false end

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

--- Stream a packed song chunk
-- @param packedChunk (string)
-- @return (boolean)
function Musician.Comm.StreamSongChunk(packedChunk)
	if not(Musician.Comm.isReady()) then return false end
	local compressedchunk = LibCompressEncodeTable:Encode(LibCompress:CompressHuffman(packedChunk))

	local bwMin = Musician.BANDWIDTH_LIMIT_MIN
	local bwMax = Musician.BANDWIDTH_LIMIT_MAX + 1
	local bandwidth = (max(bwMin, min(bwMax, #compressedchunk)) - bwMin) / (bwMax - bwMin)
	Musician.Comm:SendMessage(Musician.Events.Bandwidth, bandwidth)
	Musician.Comm.BroadcastCommMessage(compressedchunk, Musician.Comm.event.stream, Musician.Comm.event.streamGroup)
	return true
end

--- Play a received song chunk
--
local function OnChunk(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	local isGroup = distribution ~= 'CHANNEL'
	local senderIsInGroup = Musician.Utils.PlayerIsInGroup(sender)

	-- Consider the sender has group support since the message was received via group chat
	if isGroup then
		if Musician.Registry.players[sender] == nil then
			Musician.Registry.players[sender] = {}
		end

		Musician.Registry.players[sender].groupSupport = true
	end

	-- Rejecting channel chunks if the sender is also sending group chunks
	if not(isGroup) and senderIsInGroup and Musician.Comm.PlayerHasGroupSupport(sender) then
		return
	end

	local packedChunk = LibCompress:Decompress(LibCompressEncodeTable:Decode(message))
	local chunk, mode, songId, chunkDuration, playtimeLeft, position = Musician.Song.UnpackChunk(packedChunk)

	-- Invalid chunk
	if chunk == nil then
		return
	end

	-- Update player position
	Musician.Registry.UpdatePlayerPositionAndGUID(sender, unpack(position))

	-- Not in loading range
	if not(isGroup) and not(Musician.Registry.PlayerIsInRange(sender, Musician.LOADING_RADIUS)) then
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

	-- Append chunk data
	Musician.songs[sender]:AppendChunk(chunk, mode, songId, chunkDuration, playtimeLeft, sender)

	-- Play song if not already started
	if not(Musician.songs[sender]:IsPlaying()) and not(Musician.songs[sender].willPlay) then
		Musician.songs[sender].willPlay = true
		Musician.songs[sender]:Play(chunkDuration / 2)
	end
end

Musician.Comm:RegisterComm(Musician.Comm.event.stream, OnChunk)
Musician.Comm:RegisterComm(Musician.Comm.event.streamGroup, OnChunk)

--- Stop song
-- @return (boolean)
function Musician.Comm.StopSong()
	if not(Musician.Comm.isReady()) then return false end
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

