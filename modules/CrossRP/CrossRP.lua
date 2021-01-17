--- Enables cross realm and cross faction communication through the CrossRP add-on.
-- @module Musician.CrossRP

Musician.CrossRP = LibStub("AceAddon-3.0"):NewAddon("Musician.CrossRP", "AceEvent-3.0")

local MODULE_NAME = "CrossRP"
Musician.AddModule(MODULE_NAME)

local LibDeflate = LibStub:GetLibrary("LibDeflate")

Musician.CrossRP.isReady = false

local streamingSongId
local chunkId
local receivedChunkIds = {}
local foreigners = {} -- All players having Musician + CrossRP found on other bands
local queriedPlayers = {}
local pendingPlayerQueries = {} -- CrossRP Query messages queue
local foreignPromoEmotes = {} -- Received foreign promo emotes that didn't make it because the song was not loaded yet

local activeBands = {} -- All bands having in-range and visible foreigners
local foreignerScanActiveBands = {}
local foreignerScanIndex
local foreignerScanLastDuration -- Last time spent scanning for foreigners during 1 frame (ms)
local foreignerScanLastAmount -- Last amount of foreigners scanned during 1 frame

local QUERY_RATE = .5
local QUERY_MAX_TRIES = 2
local QUERY_RETRY_AFTER = 5

local FOREIGNERS_SCAN_MAX_TIME = .5 -- Max time allowed per frame for foreigners scan (ms)

Musician.CrossRP.event = {}
Musician.CrossRP.event.stop = "MusicianS"
Musician.CrossRP.event.chunk = "MusicianC6"

--- Print debug message
-- @param out (boolean) Outgoing message
-- @param event (string)
-- @param source (string)
-- @param ... (string)
local function debug(out, event, source, ...)
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

	Musician.Utils.Debug("CrossRP", prefix, event, source, ...)
end

--- OnEnable
--
function Musician.CrossRP:OnEnable()
	if CrossRP then
		Musician.CrossRP.Init()
	end
	Musician.CrossRP.InitTipsAndTricks()
end

--- Init
--
function Musician.CrossRP.Init()

	-- CrossRP is ready!
	Musician.CrossRP:RegisterMessage("CROSSRP_PROTO_START3", function()
		Musician.CrossRP.isReady = true
	end)

	-- Send Hello
	-- A CrossRP Hello is sent to everyone every time a standard Hello is sent to the MusicianComm channel
	hooksecurefunc(Musician.Registry, "SendHello", Musician.CrossRP.SendHello)

	-- Receive CrossRP Hello
	--
	CrossRP.Proto.SetMessageHandler(Musician.Registry.event.hello, Musician.CrossRP.OnHelloOrQuery)

	-- Send CrossRP Query to hovered player
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
		local isInMyBand = CrossRP.Proto.IsDestLinked(myBand, destination)
		local isPlayerBandReachable = CrossRP.Proto.SelectBridge(destination, false)
		local playerHasNoVersion = not(Musician.Registry.PlayerIsRegistered(player)) or Musician.Registry.PlayerIsRegisteredWithNoVersion(player)

		-- Player is not in my band and is not registered: send Query message via CrossRP if possible
		if not(isInMyBand) and isPlayerBandReachable and playerHasNoVersion then
			local query = queriedPlayers[player]
			local queryCount = query and query[1] or 0
			local queryTime = query and query[2] or 0

			if ((queryTime + QUERY_RETRY_AFTER) <= GetTime()) and (queryCount < QUERY_MAX_TRIES) then
				queriedPlayers[player] = { queryCount + 1, GetTime(), destination }
				table.insert(pendingPlayerQueries, player)
			end
		end
	end)

	-- Periodically send enqueued Query message
	C_Timer.NewTicker(QUERY_RATE, function()

		-- Take first player of the list
		local player = table.remove(pendingPlayerQueries, 1)

		-- Keep removing players from list if they are already registered with a version number
		while player and Musician.Registry.PlayerIsRegisteredWithVersion(player) do
			player = table.remove(pendingPlayerQueries, 1)
		end

		-- No more player in the list
		if not(player) then return end

		-- Player still not registered or without version
		local playerHasNoVersion = not(Musician.Registry.PlayerIsRegistered(player)) or Musician.Registry.PlayerIsRegisteredWithNoVersion(player)

		-- Send Query message
		if playerHasNoVersion then
			local destination = queriedPlayers[player][3]

			debug(true, Musician.Registry.event.query, destination, player, unpack(queriedPlayers[player]))

			CrossRP.Proto.Send(
				destination,
				{ Musician.Registry.event.query, player, Musician.CrossRP.GetHelloString() },
				{ guarantee = true, priority = "URGENT" }
			)
		end
	end)

	-- Receive CrossRP Query message
	--
	CrossRP.Proto.SetMessageHandler(Musician.Registry.event.query, Musician.CrossRP.OnHelloOrQuery)

	-- Send compressed chunk
	--
	hooksecurefunc(Musician.Comm, "StreamCompressedSongChunk", Musician.CrossRP.StreamCompressedSongChunk)

	-- Receive compressed chunk
	--
	CrossRP.Proto.SetMessageHandler(Musician.CrossRP.event.chunk, Musician.CrossRP.OnSongChunk)

	-- Stop song
	--
	hooksecurefunc(Musician.Comm, "StopSong", Musician.CrossRP.StopSong)

	-- Receive song stop
	--
	CrossRP.Proto.SetMessageHandler(Musician.CrossRP.event.stop, Musician.CrossRP.OnSongStop)

	-- A player has been registered
	--
	Musician.CrossRP:RegisterMessage(Musician.Registry.event.playerRegistered, function(event, player)
		-- Add CrossRP player attributes if in my group
		if Musician.Utils.PlayerIsInGroup(player) then
			local simplePlayerName = Musician.Utils.SimplePlayerName(player)
			local faction = Musician.CrossRP.GetFactionId(UnitFactionGroup(simplePlayerName))
			if not(faction) then return end
			local source = CrossRP.Proto.DestFromFullname(player, faction)
			local guid = UnitGUID(simplePlayerName)
			Musician.CrossRP.RegisterPlayerFromSource(source, guid)
		end
	end)

	-- Handle cross realm promo emotes
	--
	Musician.CrossRP:RegisterMessage(Musician.Events.PromoEmote, function(event, isPromoEmoteSuccessful, msg, fullPlayerName, ...)
		local languageName, channelName, playerName2, pflag, zoneChannelID, channelIndex, channelBaseName, unused, lineID = ...

		if not(Musician.Utils.PlayerIsOnSameRealm(fullPlayerName)) and not(Musician.Utils.PlayerIsInGroup(fullPlayerName)) then
			if not(isPromoEmoteSuccessful) then
				foreignPromoEmotes[fullPlayerName] = lineID
			elseif isPromoEmoteSuccessful and foreignPromoEmotes[fullPlayerName] ~= nil then
				Musician.Utils.RemoveChatMessage(foreignPromoEmotes[fullPlayerName])
				foreignPromoEmotes[fullPlayerName] = nil
			end
		end
	end)

	-- Scan nearby foreingers on each frame
	--
	Musician.CrossRP:RegisterMessage(Musician.Events.Frame, function(event, elapsed)

		-- foreigners list is empty
		if #foreigners == 0 then
			activeBands = {}
			return
		end

		-- Default values
		if foreignerScanLastDuration == nil or foreignerScanLastDuration == 0 or foreignerScanLastAmount == nil or foreignerScanLastAmount == 0 then
			foreignerScanLastDuration = 1
			foreignerScanLastAmount = 100
		end

		-- Number of scans last performed during 1ms
		local scansPerMs = foreignerScanLastDuration / foreignerScanLastAmount
		local scansToDo = math.ceil(FOREIGNERS_SCAN_MAX_TIME / scansPerMs)

		-- Perform scan
		local myBand = CrossRP.Proto.GetBandFromUnit("player")
		if foreignerScanIndex == nil then foreignerScanIndex = 1 end
		local scans = 0
		local startTime = debugprofilestop()
		while (scans < #foreigners) and (scans < scansToDo) do
			local player = foreigners[foreignerScanIndex]
			local playerData = Musician.Registry.players[player]
			local guid = playerData.guid
			local band = playerData.crossRpBand

			-- Player has CrossRP attributes, is not in my group and is visible (connected)
			if guid and not(Musician.Utils.PlayerIsInGroup(player)) and Musician.Utils.PlayerGuidIsVisible(guid) then
				foreignerScanActiveBands[band] = true
			end

			-- Scan is complete
			if foreignerScanIndex == #foreigners then
				foreignerScanIndex = 1
				activeBands = foreignerScanActiveBands
				foreignerScanActiveBands = {}
			else
				foreignerScanIndex = foreignerScanIndex + 1
			end
			scans = scans + 1
		end

		foreignerScanLastDuration = debugprofilestop() - startTime
		foreignerScanLastAmount = scans
	end)

	-- Filter out "is playing music" emotes that come from the other faction is there is a valid link
	--
	ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", function(self, event, msg, player, languageName, channelName, playerName2, pflag, ...)
		local isPromoEmote, _ = Musician.Utils.HasPromoEmote(msg)
		-- Promo emote has been found
		if isPromoEmote then
			local fullPlayerName = Musician.Utils.NormalizePlayerName(player)
			-- Music is not loaded or is not actually playing
			if Musician.songs[fullPlayerName] == nil or not(Musician.songs[fullPlayerName]:IsPlaying()) then
				-- Determine if it's a language I'm supposed to understand
				local isUnderstoodLanguage = false
				for l = 1, GetNumLanguages() do
					local myLanguageName, _ = GetLanguageByIndex(l)
					if languageName == myLanguageName then
						isUnderstoodLanguage = true
						break
					end
				end

				-- Player does not speak a language I should understand: player is from the other faction and I'm using an Elixir of Tongues
				if not(isUnderstoodLanguage) and Musician.Utils.PlayerIsOnSameRealm(player) and not(Musician.Utils.PlayerIsInGroup(player)) then
					-- Check if there is an active link to the other player faction
					local playerBand = CrossRP.Proto.DestFromFullname(player, Musician.CrossRP.GetAdverseFaction())

					-- Dismiss emote if link is active
					if CrossRP.Proto.SelectBridge(playerBand) then
						return true
					end
				end
			end
		end

		return false, msg, player, languageName, channelName, playerName2, pflag, ...
	end)

	-- Init options
	Musician.CrossRP.Options.Init()
end

--- Return data string for CrossRP Hello/Query messages
-- @return (string)
function Musician.CrossRP.GetHelloString()
	return UnitGUID("player") .. " " .. Musician.Registry.GetVersionString()
end

--- Return faction ID from faction name
-- @param faction (string) (Horde, Alliance or Neutral)
-- @return (string) (H, A or N)
function Musician.CrossRP.GetFactionId(faction)
	if not(faction) then return nil end
	return string.sub(faction, 1, 1)
end

--- Return player's adverse faction ID (ie H for Alliance)
-- @return (string)
function Musician.CrossRP.GetAdverseFaction()
	local faction = UnitFactionGroup('player')

	if faction == 'Alliance' then
		return 'H'
	elseif faction == 'Horde' then
		return 'A'
	else
		return ''
	end
end

--- Return destination string for targetted unit
-- @param unit (string)
-- @return (string)
function Musician.CrossRP.GetUnitDestination(unit)
	if not(UnitIsPlayer(unit)) then return nil end
	local player = GetUnitName(unit, true)
	local faction = Musician.CrossRP.GetFactionId(UnitFactionGroup(unit))
	if not(faction) then return nil end
	return CrossRP.Proto.DestFromFullname(player, faction)
end

--- Return CrossRP destination for broadcast, based on the presence of nearby foreign players
-- @return (array)
function Musician.CrossRP.GetBroadcastDestination()

	local myBand = CrossRP.Proto.GetBandFromUnit("player")
	local destination = {}
	local band
	for band, _ in pairs(activeBands) do
		if not(CrossRP.Proto.IsDestLinked(band, myBand)) then
			table.insert(destination, band)
		end
	end

	if #destination > 0 then
		return destination
	else
		return nil
	end
end

--- Register player from its source string
-- @param source (string)
-- @param[opt] guid (string)
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
-- @param[opt="all"] destination (string)
function Musician.CrossRP.SendHello(destination)
	local options
	if destination == nil then
		destination = "all"
		options = {}
	else
		options = { guarantee = true, priority = "URGENT" }
	end

	if destination then
		debug(true, Musician.Registry.event.hello, destination)
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
	local type, rawData = message:match("^(%S+) (.*)")
	local destination, version, guid

	if player then
		if type == Musician.Registry.event.query then
			destination, guid, version = rawData:match("^(%S+) (%S+) (.*)")
			debug(false, type, source, destination, guid, version, Musician.CrossRP.GetUnitDestination("player"))
			-- This query is not for me
			if not(Musician.Utils.PlayerIsMyself(destination)) then
				return
			-- Reply with a Hello
			else
				Musician.CrossRP.SendHello(source)
			end
		else
			guid, version = rawData:match("^(%S+) (.*)")
			debug(false, type, source, guid, version)
		end

		Musician.CrossRP.RegisterPlayerFromSource(source, guid)
		Musician.Registry.SetPlayerVersion(player, version)
		queriedPlayers[player] = nil
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
	debug(true, Musician.CrossRP.event.chunk, destination, streamingSongId, chunkId, #(Musician.CrossRP.event.chunk .. " " .. serializedData))
	CrossRP.Proto.Send(
		destination,
		{ Musician.CrossRP.event.chunk, serializedData },
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

		debug(false, type, source, songId, chunkId, #(type .. " " .. serializedData))

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

--- Stop song
--
function Musician.CrossRP.StopSong()

	local destination = Musician.CrossRP.GetBroadcastDestination()

	-- No broadcast destination: no need to send the chunk over CrossRP
	if not(destination) then return end

	debug(true, Musician.CrossRP.event.stop, destination)
	CrossRP.Proto.Send(
		destination,
		{ Musician.CrossRP.event.stop },
		{ guarantee = true, priority = "FAST" }
	)
end

--- Process a received music stop
-- @param source (string)
-- @param message (string)
-- @param complete (boolean)
function Musician.CrossRP.OnSongStop(source, message, complete)

	local myBand = CrossRP.Proto.GetBandFromUnit("player")
	local player = CrossRP.Proto.DestToFullname(source)

	-- Do not process if receiving a stop from my own band or from someone in my group
	if CrossRP.Proto.IsDestLinked(myBand, source) or not(player) or Musician.Utils.PlayerIsInGroup(player) then
		return
	end

	local type = message:match("^(%S+)")
	debug(false, type, source)

	Musician.StopPlayerSong(player, true)
end

--- Initialize tips and tricks
--
function Musician.CrossRP.InitTipsAndTricks()
	-- Already shown
	if Musician_Settings.crossRP_HintShown then return end

	-- Already enabled
	if CrossRP then
		Musician_Settings.crossRP_HintShown = true
		return
	end

	-- Add tip
	Musician.AddTipsAndTricks(function()
		MusicianCrossRP_TipsAndTricks:Show()
	end, false)
end