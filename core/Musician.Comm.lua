Musician.Comm = LibStub("AceAddon-3.0"):NewAddon("Musician.Comm", "AceComm-3.0", "AceEvent-3.0")

local LibCompress = LibStub:GetLibrary("LibCompress")
local LibCompressEncodeTable = LibCompress:GetAddonEncodeTable()

Musician.Comm.event = {}
Musician.Comm.event.song   = "MusicianSong"
Musician.Comm.event.play   = "MusicianPlay"
Musician.Comm.event.stop   = "MusicianStop"
Musician.Comm.event.stream = "MusicianStream"
Musician.Comm.event.update = "MusicianUpdate"

Musician.Comm.isSending = false
Musician.Comm.isPlaySent = false
Musician.Comm.isStopSent = false

Musician.Comm.updateTicker = nil

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

--- Return true if the song has been successfully loaded
function Musician.Comm.SongIsLoaded()
	local player = Musician.Utils.NormalizePlayerName(UnitName("player"))
	return Musician.songs[player] ~= nil and  Musician.songs[player].received ~= nil
end

--- Send the song to other players
-- @param song (table)
-- @return (boolean)
function Musician.Comm.BroadcastSong(song)

	-- Protocol not ready or already sending a song
	if not(Musician.Comm.isReady()) or Musician.Comm.isSending then return false end

	Musician.Comm.isSending = true
	Musician.Comm:SendMessage(Musician.Events.RefreshFrame)

	local packedSongData = song:Pack()
	local compressedPackedSongData = LibCompressEncodeTable:Encode(LibCompress:CompressHuffman(packedSongData))

	Musician.Comm:SendCommMessage(Musician.Comm.event.song, compressedPackedSongData, 'CHANNEL', Musician.Comm.getChannel(), "BULK")

	return true
end

--- Receive a song from a player
--
Musician.Comm:RegisterComm(Musician.Comm.event.song, function(prefix, message, distribution, sender)

	sender = Musician.Utils.NormalizePlayerName(sender)

	local finalSongData

	local success = pcall(function()
		local uncompressedPackedSongData = LibCompress:Decompress(LibCompressEncodeTable:Decode(message))
		finalSongData = Musician.Song.create(uncompressedPackedSongData)
	end)

	-- An error occurred while decoding the received song
	if not(success) then
		return
	end

	finalSongData.player = sender

	if Musician.songs[sender] == nil then
		Musician.songs[sender] = {}
	end

	Musician.songs[sender].received = finalSongData

	if sender == Musician.Utils.NormalizePlayerName(UnitName('player')) then
		Musician.Comm.isSending = false
		Musician.Comm:SendMessage(Musician.Events.RefreshFrame)
	end
end)

--- Play uploaded song
-- @return (boolean)
function Musician.Comm.PlaySong()
	if not(Musician.Comm.isReady()) or not(Musician.Comm.SongIsLoaded()) then return false end
	Musician.Comm.isPlaySent = true
	Musician.songIsPlaying = true
	Musician.Comm:SendMessage(Musician.Events.RefreshFrame)
	Musician.Comm:SendCommMessage(Musician.Comm.event.play,  Musician.Utils.PackPosition(), 'CHANNEL', Musician.Comm.getChannel(), "ALERT")
	Musician.Comm.StartPositionUpdate()
	return true
end

--- Play a received song
--
Musician.Comm:RegisterComm(Musician.Comm.event.play, function(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	Musician.Comm.UpdatePlayerPosition(sender, message)
	Musician.PlayLoadedSong(sender)
	if sender == Musician.Utils.NormalizePlayerName(UnitName("player")) then
		Musician.Comm.isPlaySent = false
		Musician.Comm:SendMessage(Musician.Events.RefreshFrame)
		SendChatMessage(Musician.Utils.GetPromoEmote(), "EMOTE")
	end
end)

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
	local posY, posX, posZ, instanceID, guid = unpack(position)

	-- Update player position
	if Musician.songs[sender] == nil then
		Musician.songs[sender] = {}
	end

	Musician.songs[sender].position = {posY, posX, posZ, instanceID}
	Musician.songs[sender].guid = guid

	-- Create playing song, if missing
	if Musician.songs[sender].playing == nil then
		Musician.songs[sender].playing = Musician.Song.create()
		Musician.songs[sender].playing.songId = songId
		Musician.songs[sender].playing.player = sender
	elseif not(Musician.songs[sender].playing.isStreamed) or (Musician.songs[sender].playing.songId ~= songId) then
		Musician.songs[sender].playing:Stop()
		Musician.songs[sender].playing = Musician.Song.create()
		Musician.songs[sender].playing.songId = songId
		Musician.songs[sender].playing.player = sender
	end

	-- Append chunk data
	Musician.songs[sender].playing.isStreamed = true
	Musician.songs[sender].playing:AppendChunk(chunk)

	-- Play song if not already started
	if not(Musician.songs[sender].playing.willPlay) then
		Musician.songs[sender].playing.willPlay = true
		C_Timer.After(chunkDuration / 2, function()
			Musician.songs[sender].playing:Play()
		end)
	end
end)

--- Stop uploaded song
-- @return (boolean)
function Musician.Comm.StopSong()
	if not(Musician.Comm.isReady()) then return false end
	Musician.Comm.isStopSent = true
	Musician.songIsPlaying = false
	Musician.Comm:SendMessage(Musician.Events.RefreshFrame)
	Musician.Comm:SendCommMessage(Musician.Comm.event.stop, Musician.Utils.PackPosition(), 'CHANNEL', Musician.Comm.getChannel(), "ALERT")
	Musician.Comm.StopPositionUpdate()
	return true
end

--- Stop a received song
--
Musician.Comm:RegisterComm(Musician.Comm.event.stop, function(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	Musician.StopLoadedSong(sender)
	if sender == Musician.Utils.NormalizePlayerName(UnitName("player")) then
		Musician.Comm.isStopSent = false
		Musician.Comm:SendMessage(Musician.Events.RefreshFrame)
	end
end)

--- Broadcast player position
-- @return (boolean)
function Musician.Comm.SendPositionUpdate()
	if not(Musician.Comm.isReady()) then return false end
	Musician.Comm:SendCommMessage(Musician.Comm.event.update, Musician.Utils.PackPosition(), 'CHANNEL', Musician.Comm.getChannel(), "ALERT")
	return true
end

--- Process a received player position
-- @param player (string)
-- @param packedPosition (string)
function Musician.Comm.UpdatePlayerPosition(player, packedPosition)
	player = Musician.Utils.NormalizePlayerName(player)
	local posY, posX, posZ, instanceID, guid = Musician.Utils.UnpackPosition(packedPosition)

	if Musician.songs[player] == nil then
		Musician.songs[player] = {}
	end

	Musician.songs[player].position = {posY, posX, posZ, instanceID}
	Musician.songs[player].guid = guid
end

--- Update a received player position
--
Musician.Comm:RegisterComm(Musician.Comm.event.update, function(prefix, message, distribution, sender)
	Musician.Comm.UpdatePlayerPosition(Musician.Utils.NormalizePlayerName(sender), message)
end)

--- Start updating the player position periodically
--
function Musician.Comm.StartPositionUpdate()
	Musician.Comm.SendPositionUpdate()
	Musician.Comm.updateTicker = C_Timer.NewTicker(Musician.POSITION_UPDATE_PERIOD, function()
		Musician.Comm.SendPositionUpdate()
	end)
end

--- Stop updating the player position periodically
--
function Musician.Comm.StopPositionUpdate()
	if Musician.Comm.updateTicker ~= nil then
		Musician.Comm.updateTicker:Cancel()
	end
end
