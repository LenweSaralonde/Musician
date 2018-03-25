Musician.Comm = {}

local LibCompress = LibStub:GetLibrary("LibCompress")
local LibCompressEncodeTable = LibCompress:GetAddonEncodeTable()

Musician.Comm.event = {}
Musician.Comm.event.song   = "MusicianSong"
Musician.Comm.event.play   = "MusicianPlay"
Musician.Comm.event.stop   = "MusicianStop"
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
	Musician:RegisterEvent("PLAYER_ENTERING_WORLD", function()

			if initialized then return end

			initialized = true

			RegisterAddonMessagePrefix(Musician.Comm.event.song)
			RegisterAddonMessagePrefix(Musician.Comm.event.play)
			RegisterAddonMessagePrefix(Musician.Comm.event.stop)
			RegisterAddonMessagePrefix(Musician.Comm.event.update)

			Musician.Comm.JoinChannel()
	end)
end

--- Join the communication channel and keep it joined
--
function Musician.Comm.JoinChannel()
	if Musician.Comm.channelJoiner ~= nil then return end

	local joinedChannelCount = table.getn( { GetChannelList() } )

	Musician.Comm.channelJoiner = C_Timer.NewTicker(4, function()
		local channelId, _ = GetChannelName(Musician.CHANNEL)

		if channelId == 0 then
			local newJoinedChannelCount = table.getn( { GetChannelList() } )

			if newJoinedChannelCount > 0 and newJoinedChannelCount == joinedChannelCount then
				local type, name = JoinTemporaryChannel(Musician.CHANNEL, Musician.PASSWORD)
			end

			joinedChannelCount = newJoinedChannelCount
		end
	end)
end

--- Return the communication channel ID
-- @return (string)
function Musician.Comm.getChannel()
	local channelId, _ = GetChannelName(Musician.CHANNEL)

	if channelId ~= 0 then
		return channelId .. ''
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
	local player = UnitName("player")
	return Musician.songs[player] ~= nil and  Musician.songs[player].received ~= nil
end

--- Send the song to other players
-- @param song (table)
-- @return (boolean)
function Musician.Comm.BroadcastSong(song)

	-- Protocol not ready or already sending a song
	if not(Musician.Comm.isReady()) or Musician.Comm.isSending then return false end

	Musician.Comm.isSending = true
	Musician:SendMessage(Musician.Events.RefreshFrame)

	local packedSongData = Musician.Utils.PackSong(song)
	local compressedPackedSongData = LibCompressEncodeTable:Encode(LibCompress:CompressHuffman(packedSongData))

	Musician:SendCommMessage(Musician.Comm.event.song, compressedPackedSongData, 'CHANNEL', Musician.Comm.getChannel(), "BULK")

	return true
end

--- Receive a song from a player
--
Musician:RegisterComm(Musician.Comm.event.song, function(prefix, message, distribution, sender)

		local finalSongData

		local success = pcall(function()
			local uncompressedPackedSongData = LibCompress:Decompress(LibCompressEncodeTable:Decode(message))
			finalSongData = Musician.Utils.UnpackSong(uncompressedPackedSongData)
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

		if sender == UnitName('player') then
			Musician.Comm.isSending = false
			Musician:SendMessage(Musician.Events.RefreshFrame)
		end
end)

--- Play uploaded song
-- @return (boolean)
function Musician.Comm.PlaySong()
	if not(Musician.Comm.isReady()) or not(Musician.Comm.SongIsLoaded()) then return false end
	Musician.Comm.isPlaySent = true
	Musician.songIsPlaying = true
	Musician:SendMessage(Musician.Events.RefreshFrame)
	Musician:SendCommMessage(Musician.Comm.event.play,  Musician.Utils.PackPosition(), 'CHANNEL', Musician.Comm.getChannel(), "ALERT")
	Musician.Comm.StartPositionUpdate()
	return true
end

--- Play a received song
--
Musician:RegisterComm(Musician.Comm.event.play, function(prefix, message, distribution, sender)
	Musician.Comm.UpdatePlayerPosition(sender, message)
	Musician.PlayLoadedSong(sender)
	if sender == UnitName("player") then
		Musician.Comm.isPlaySent = false
		Musician:SendMessage(Musician.Events.RefreshFrame)
		SendChatMessage(Musician.Msg.EMOTE_PLAYING_MUSIC, "EMOTE")
	end
end)

--- Stop uploaded song
-- @return (boolean)
function Musician.Comm.StopSong()
	if not(Musician.Comm.isReady()) then return false end
	Musician.Comm.isStopSent = true
	Musician.songIsPlaying = false
	Musician:SendMessage(Musician.Events.RefreshFrame)
	Musician:SendCommMessage(Musician.Comm.event.stop,  Musician.Utils.PackPosition(), 'CHANNEL', Musician.Comm.getChannel(), "ALERT")
	Musician.Comm.StopPositionUpdate()
	return true
end

--- Stop a received song
--
Musician:RegisterComm(Musician.Comm.event.stop, function(prefix, message, distribution, sender)
	Musician.StopLoadedSong(sender)
	if sender == UnitName("player") then
		Musician.Comm.isStopSent = false
		Musician:SendMessage(Musician.Events.RefreshFrame)
	end
end)

--- Broadcast player position
-- @return (boolean)
function Musician.Comm.SendPositionUpdate()
	if not(Musician.Comm.isReady()) then return false end
	Musician:SendCommMessage(Musician.Comm.event.update,  Musician.Utils.PackPosition(), 'CHANNEL', Musician.Comm.getChannel(), "ALERT")
	return true
end

--- Process a received player position
-- @param player (string)
-- @param packedPosition (string)
function Musician.Comm.UpdatePlayerPosition(player, packedPosition)
	local posY, posX, posZ, instanceID = Musician.Utils.UnpackPosition(packedPosition)

	if Musician.songs[player] == nil then
		Musician.songs[player] = {}
	end

	Musician.songs[player].position = {posY, posX, posZ, instanceID}
end

--- Update a received player position
--
Musician:RegisterComm(Musician.Comm.event.update, function(prefix, message, distribution, sender)
	Musician.Comm.UpdatePlayerPosition(sender, message)
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



























































































































