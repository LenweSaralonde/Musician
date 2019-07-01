Musician.CrossRP = LibStub("AceAddon-3.0"):NewAddon("Musician.CrossRP", "AceEvent-3.0")

local LibDeflate = LibStub:GetLibrary("LibDeflate")

Musician.CrossRP.isReady = false

local streamingSongId
local chunkId
local receivedChunkIds = {}
local foreigners = {}

--- OnEnable
--
function Musician.CrossRP:OnEnable()
	if CrossRP then
		Musician.CrossRP.Init()
	end
end

--- Init
--
function Musician.CrossRP.Init()

	-- CrossRP is ready!
	Musician.CrossRP:RegisterMessage("CROSSRP_PROTO_START3", function()
		Musician.CrossRP.isReady = true
	end)

	--- Send Hello
	-- A CrossRP Hello is sent to everyone every time a standard Hello is sent to the MusicianComm channel
	hooksecurefunc(Musician.Registry, "SendHello", Musician.CrossRP.SendHello)

	--- Receive CrossRP Hello
	--
	CrossRP.Proto.SetMessageHandler(Musician.Registry.event.hello, Musician.CrossRP.OnHelloOrQuery)

	--- Send CrossRP Query to hovered player
	--
	Musician.CrossRP:RegisterEvent("UPDATE_MOUSEOVER_UNIT", function()
		local destination = Musician.CrossRP.GetUnitDestination("mouseover")
		if not(destination) then
			return
		end

		local player = Musician.Utils.NormalizePlayerName(GetUnitName("mouseover", true))
		if Musician.Utils.PlayerIsMyself(player) then
			return
		end

		local myBand = CrossRP.Proto.GetBandFromUnit("player")
		local queryTime = Musician.Registry.playersQueried[player]
		local isQueried = queryTime and ((queryTime + 5) > GetTime()) -- Retry after 5 seconds
		local isInMyBand = CrossRP.Proto.IsDestLinked(myBand, destination)
		local isPlayerBandReachable = CrossRP.Proto.SelectBridge(destination, false)
		local hasVersion = Musician.Registry.GetPlayerVersion(player)

		-- Player is not in my band and has no version information: send Query via CrossRP if possible
		if isPlayerBandReachable and not(hasVersion) and not(isInMyBand) and not(isQueried) and Musician.CrossRP.isReady then
			Musician.Registry.playersQueried[player] = GetTime()
			CrossRP.Proto.Send(
				destination,
				{ Musician.Registry.event.query, Musician.CrossRP.GetHelloString() },
				{ guarantee = true, priority = "URGENT" }
			)
		end
	end)

	--- Receive CrossRP Query
	--
	CrossRP.Proto.SetMessageHandler(Musician.Registry.event.query, function(source, message, complete)
		Musician.CrossRP.OnHelloOrQuery(source, message, complete)
		Musician.CrossRP.SendHello(source)
	end)

	--- Send compressed chunk
	--
	hooksecurefunc(Musician.Comm, "StreamCompressedSongChunk", Musician.CrossRP.StreamCompressedSongChunk)

	--- Receive compressed chunk
	--
	CrossRP.Proto.SetMessageHandler(Musician.Comm.event.stream, Musician.CrossRP.OnSongChunk)

	--- A player has been registered
	--
	Musician.CrossRP:RegisterMessage(Musician.Registry.event.playerRegistered, function(event, player)
		-- Add CrossRP player attributes if in my group
		if Musician.Utils.PlayerIsInGroup(player) then
			local simplePlayerName = Musician.Utils.SimplePlayerName(player)
			local faction = Musician.CrossRP.GetFactionId(UnitFactionGroup(simplePlayerName))
			local source = CrossRP.Proto.DestFromFullname(player, faction)
			local guid = UnitGUID(simplePlayerName)
			Musician.CrossRP.RegisterPlayerFromSource(source, guid)
		end
	end)
end

--- Return data string for CrossRP Hello/Query messages
-- @return (string)
function Musician.CrossRP.GetHelloString()
	return Musician.Registry.GetVersionString() .. " " .. UnitGUID("player")
end

--- Return faction ID from faction name
-- @param faction (string) (Horde, Alliance or Neutral)
-- @return (string) (H, A or N)
function Musician.CrossRP.GetFactionId(faction)
	return string.sub(faction, 1, 1)
end

--- Return player's adverse band (ie 537H for EU-KirinTor Alliance)
-- @return (string)
function Musician.CrossRP.GetAdverseBand()
	local playerBand = CrossRP.Proto.GetBandFromUnit("player")
	local bandNumber, faction = string.match(playerBand, "(%d+)([AHN])")

	if faction == "A" then
		return bandNumber .. "H"
	elseif faction == "H" then
		return bandNumber .. "A"
	else
		return nil
	end
end

--- Return destination string for targetted unit
-- @param unit (string)
-- @return (string)
function Musician.CrossRP.GetUnitDestination(unit)
	if not(UnitIsPlayer(unit)) then
		return nil
	end

	local player = GetUnitName(unit, true)
	local faction = Musician.CrossRP.GetFactionId(UnitFactionGroup(unit))
	return CrossRP.Proto.DestFromFullname(player, faction)
end

--- Return CrossRP destination for broadcast, based on the presence of nearby foreign players
-- @return (string)
function Musician.CrossRP.GetBroadcastDestination()
	local myBand = CrossRP.Proto.GetBandFromUnit("player")
	local adverseBand = Musician.CrossRP.GetAdverseBand()
	local destination = nil
	local player, playerData
	for _, player in ipairs(foreigners) do
		-- Player has CrossRP attributes, is not in my group and is visible (connected)
		local playerData = Musician.Registry.players[player]
		if playerData.guid and not(Musician.Utils.PlayerIsInGroup(player)) and Musician.Utils.PlayerGuidIsVisible(playerData.guid) then
			-- Adverse band
			if CrossRP.Proto.IsDestLinked(playerData.crossRpBand, adverseBand) then
				destination = adverseBand
			-- Foreign player
			elseif not(CrossRP.Proto.IsDestLinked(playerData.crossRpBand, myBand)) then
				return "all"
			end
		end
	end
	return destination
end

--- Register player from its source string
-- @param source (string)
-- @param [guid] (string)
function Musician.CrossRP.RegisterPlayerFromSource(source, guid)
	local player = CrossRP.Proto.DestToFullname(source)
	if player then
		Musician.Registry.RegisterPlayer(player)

		local myBand = CrossRP.Proto.GetBandFromUnit("player")
		local isInMyBand = CrossRP.Proto.IsDestLinked(myBand, source)
		local playerData = Musician.Registry.players[player]

		if not(isInMyBand) and not(playerData.crossRpSource) then
			playerData.crossRpSource = source
			playerData.crossRpBand = CrossRP.Proto.GetBandFromDest(source)
			table.insert(foreigners, player)
		end

		if guid then
			playerData.guid = guid
		end
	end
end

--- Send a Hello message
-- @param [destination (string)] By default, "all"
function Musician.CrossRP.SendHello(destination)
	local options
	if destination == nil then
		destination = "all"
		options = {}
	else
		options = { guarantee = true, priority = "URGENT" }
	end

	if destination then
		CrossRP.Proto.Send(
			destination,
			{ Musician.Registry.event.hello, Musician.CrossRP.GetHelloString() },
			options
		)
	end
end

--- Process a received version number from a Hello or a Query message
-- @param source (string)
-- @param message (string)
-- @param complete (boolean)
function Musician.CrossRP.OnHelloOrQuery(source, message, complete)
	local player = CrossRP.Proto.DestToFullname(source)
	local type, version, guid = message:match("^(%S+) (%S+) (%S+)")

	if player then
		Musician.CrossRP.RegisterPlayerFromSource(source, guid)
		Musician.Registry.SetPlayerVersion(player, version)
	end
end

--- Send a compressed chunk
-- @param compressedChunk (string)
function Musician.CrossRP.StreamCompressedSongChunk(compressedChunk)
	local destination = Musician.CrossRP.GetBroadcastDestination()

	-- No broadcast destination: no need to send the chunk over CrossRP
	if not(destination) then return end

	-- Get chunk ID
	if streamingSongId ~= Musician.streamingSong:GetId() then
		streamingSongId = Musician.streamingSong:GetId()
		chunkId = 0
	else
		chunkId = chunkId + 1
	end

	-- Pack chunk ID (2)
	local packedChunkId = Musician.Utils.PackNumber(chunkId, 2)

	-- Serialize data
	local serializedData = LibDeflate:EncodeForWoWChatChannel(packedChunkId .. compressedChunk)

	-- Send chunk
	CrossRP.Proto.Send(
		destination,
		{ Musician.Comm.event.stream, serializedData },
		{ guarantee = false, priority = "FAST" }
	)
end

--- Process a received music chunk
-- @param source (string)
-- @param message (string)
-- @param complete (boolean)
function Musician.CrossRP.OnSongChunk(source, message, complete)
	local myBand = CrossRP.Proto.GetBandFromUnit("player")
	local player = CrossRP.Proto.DestToFullname(source)

	-- Do not process if receiving a chunk from my own band or from someone in my group
	if CrossRP.Proto.IsDestLinked(myBand, source) or not(player) or Musician.Utils.PlayerIsInGroup(player) then
		return
	end

	if complete then
		local type, serializedData = message:match("^(%S+) (.*)")

		local data = LibDeflate:DecodeForWoWChatChannel(serializedData)
		local chunkId = Musician.Utils.UnpackNumber(string.sub(data, 1, 2))
		local packedChunk = LibDeflate:DecompressDeflate(string.sub(data, 3))
		local mode, songId = Musician.Song.UnpackChunkHeader(packedChunk)

		-- Invalid chunk
		if mode == nil then
			return
		end

		-- Deal with chunks received in the wrong order
		--   Key: source
		--   values : song ID, chunk ID
		if receivedChunkIds[source] == nil then
			receivedChunkIds[source] = {}
		end

		-- New song ID
		if receivedChunkIds[source][1] ~= songId then
			receivedChunkIds[source][1] = songId
			receivedChunkIds[source][2] = chunkId
		-- Chunk ID arrived too late: ignore it
		elseif chunkId <= receivedChunkIds[source][2] then
			return
		-- Chunk ID received in the correct order
		else
			receivedChunkIds[source][2] = chunkId
		end

		Musician.CrossRP.RegisterPlayerFromSource(source)
		Musician.Comm.ProcessChunk(packedChunk, player)
	end
end
