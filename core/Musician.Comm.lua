Musician.Comm = LibStub("AceAddon-3.0"):NewAddon("Musician.Comm", "AceComm-3.0", "AceEvent-3.0")

local LibCompress = LibStub:GetLibrary("LibCompress")
local LibCompressEncodeTable = LibCompress:GetAddonEncodeTable()

Musician.Comm.event = {}
Musician.Comm.event.stop   = "MusicianStop"
Musician.Comm.event.stream = "MusicianStream"
Musician.Comm.event.update = "MusicianUpdate"

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
				local type, name = JoinTemporaryChannel(Musician.CHANNEL, Musician.PASSWORD)
			end

			joinedChannelCount = newJoinedChannelCount
		end

		Musician.Registry.FetchPlayers()
	end)
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
	Musician.streamingSong:Stream()
	return true
end

--- Stream a packed song chunk
-- @param packedChunk (string)
-- @return (boolean)
function Musician.Comm.StreamSongChunk(packedChunk)
	if not(Musician.Comm.isReady()) then return false end
	local compressedchunk = LibCompressEncodeTable:Encode(LibCompress:CompressHuffman(packedChunk))
	Musician.Comm:SendCommMessage(Musician.Comm.event.stream, compressedchunk, 'CHANNEL', Musician.Comm.getChannel(), "ALERT")
	return true
end

--- Play a received song chunk
--
Musician.Comm:RegisterComm(Musician.Comm.event.stream, function(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)

	local packedChunk = LibCompress:Decompress(LibCompressEncodeTable:Decode(message))
	local chunk, songId, chunkDuration, position = Musician.Song.UnpackChunk(packedChunk)

	-- Update player position
	Musician.Registry.UpdatePlayerPositionAndGUID(sender, unpack(position))

	-- Not in loading range
	if not(Musician.Registry.PlayerIsInRange(sender, Musician.LOADING_RADIUS)) then
		if Musician.songs[sender] ~= nil then
			Musician.songs[sender]:Stop()
			Musician.songs[sender] = nil
		end
		return
	end

	-- Create playing song, if missing
	if Musician.songs[sender] == nil then
		Musician.songs[sender] = Musician.Song.create()
		Musician.songs[sender].songId = songId
		Musician.songs[sender].player = sender
	elseif not(Musician.songs[sender].isStreamed) or (Musician.songs[sender].songId ~= songId) then
		Musician.songs[sender]:Stop()
		Musician.songs[sender] = Musician.Song.create()
		Musician.songs[sender].songId = songId
		Musician.songs[sender].player = sender
	end

	-- Append chunk data
	Musician.songs[sender].isStreamed = true
	Musician.songs[sender]:AppendChunk(chunk)

	-- Play song if not already started
	if not(Musician.songs[sender]:IsPlaying()) and not(Musician.songs[sender].willPlay) then
		Musician.songs[sender].willPlay = true
		Musician.songs[sender]:Play(chunkDuration / 2)
	end
end)

--- Stop song
-- @return (boolean)
function Musician.Comm.StopSong()
	if not(Musician.Comm.isReady()) then return false end
	if Musician.streamingSong and Musician.streamingSong.streaming then
		Musician.streamingSong:StopStreaming()
	end	
	Musician.Comm.isStopSent = true
	Musician.Comm:SendMessage(Musician.Events.RefreshFrame)
	Musician.Comm:SendCommMessage(Musician.Comm.event.stop, Musician.Comm.event.stop, 'CHANNEL', Musician.Comm.getChannel(), "ALERT")
	return true
end

--- Stop a song
--
Musician.Comm:RegisterComm(Musician.Comm.event.stop, function(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	Musician.StopPlayerSong(sender)
	if sender == Musician.Utils.NormalizePlayerName(UnitName("player")) then
		Musician.Comm.isStopSent = false
		Musician.Comm:SendMessage(Musician.Events.RefreshFrame)
	end
end)

