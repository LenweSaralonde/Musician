--- Player registry
-- @module Musician.Registry

Musician.Registry = LibStub("AceAddon-3.0"):NewAddon("Musician.Registry", "AceEvent-3.0", "AceComm-3.0")

local MODULE_NAME = "Registry"
Musician.AddModule(MODULE_NAME)

Musician.Registry.players = {}
Musician.Registry.playersFetched = false
Musician.Registry.queriedPlayers = {}

Musician.Registry.event = {}
Musician.Registry.event.hello = "MusicianHello" -- Send my version number to a player or a group of players
Musician.Registry.event.query = "MusicianQuery" -- Query hello from a player to retreive its version
Musician.Registry.event.playerRegistered = "MusicianPlayerRegistered" -- A player has been registered
Musician.Registry.event.playerUnregistered = "MusicianPlayerUnregistered" -- A player has been unregistered

local QUERY_RATE = .1
local QUERY_MAX_TRIES = 3
local QUERY_RETRY_AFTER = 3

local newVersionNotified = false
local newProtocolNotified = false

local pendingPlayerQueries = {} -- Query messages queue

--- Print communication debug message
-- @param out (boolean) Outgoing message
-- @param event (string)
-- @param source (string)
-- @param ... (string)
local function debugComm(out, event, source, ...)
	local prefix
	if out then
		prefix = "|cFFFF0000>>>>>|r"
	else
		prefix = "|cFF00FF00<<<<<|r"
	end

	event = "|cFFFF8000" .. event .. "|r"
	source = "|cFF00FFFF" .. source .. "|r"

	Musician.Utils.Debug("Registry", prefix, event, source, ...)
end

--- Initialize registry
--
function Musician.Registry.Init()
	-- Finish initialization when player is logged in
	local function finishInit()
		-- Standard player tooltip hook
		GameTooltip:HookScript("OnTooltipSetUnit", function()
			local _, unitType = GameTooltip:GetUnit()
			if UnitIsPlayer(unitType) then
				local player = Musician.Utils.NormalizePlayerName(GetUnitName(unitType, true))
				Musician.Registry.UpdateTooltipInfo(GameTooltip, player)
			end
		end)

		-- Send Query message to group
		if Musician.Comm.GetGroupChatType() then
			debugComm(true, Musician.Registry.event.query, Musician.Comm.GetGroupChatType())
			Musician.Registry:SendCommMessage(Musician.Registry.event.query, Musician.Registry.GetVersionString(), Musician.Comm.GetGroupChatType(), nil, "ALERT")
		end
	end

	-- Init communication messages
	Musician.Registry:RegisterComm(Musician.Registry.event.query, Musician.Registry.OnQuery)
	Musician.Registry:RegisterComm(Musician.Registry.event.hello, Musician.Registry.OnHello)

	-- Send Query message to group when joining
	Musician.Registry:RegisterEvent("GROUP_JOINED", function()
		if Musician.Comm.GetGroupChatType() then
			debugComm(true, Musician.Registry.event.query, Musician.Comm.GetGroupChatType())
			Musician.Registry:SendCommMessage(Musician.Registry.event.query, Musician.Registry.GetVersionString(), Musician.Comm.GetGroupChatType(), nil, "ALERT")
		end
	end)

	-- Enqueue Query message for hovered player
	Musician.Registry:RegisterEvent("UPDATE_MOUSEOVER_UNIT", function()
		if not(UnitIsPlayer("mouseover")) then
			return
		end

		local player = Musician.Utils.NormalizePlayerName(GetUnitName("mouseover", true))
		if Musician.Utils.PlayerIsMyself(player) then
			return
		end

		if Musician.Registry.PlayerIsRegisteredWithNoVersion(player) then
			local query = Musician.Registry.queriedPlayers[player]
			local queryCount = query and query[1] or 0
			local queryTime = query and query[2] or 0

			if ((queryTime + QUERY_RETRY_AFTER) <= GetTime()) and (queryCount < QUERY_MAX_TRIES) then
				Musician.Registry.queriedPlayers[player] = { queryCount + 1, GetTime() }
				table.insert(pendingPlayerQueries, player)
			end
		end
	end)

	-- Periodically send enqueued Query message
	C_Timer.NewTicker(QUERY_RATE, function()
		local player = table.remove(pendingPlayerQueries, 1)

		while player and not(Musician.Registry.PlayerIsRegisteredWithNoVersion(player)) do
			player = table.remove(pendingPlayerQueries, 1)
		end

		if player and Musician.Registry.PlayerIsRegisteredWithNoVersion(player) then
			debugComm(true, Musician.Registry.event.query, player)
			Musician.Registry:SendCommMessage(Musician.Registry.event.query, Musician.Registry.GetVersionString(), 'WHISPER', player, "ALERT")
		end
	end)

	-- Update connected players
	Musician.Registry:RegisterEvent("CHAT_MSG_CHANNEL_LIST", function(event, players, _, _, _, _, _, _, _, channelName)

		-- Not the Musician channel
		if channelName ~= Musician.CHANNEL or not(Musician.Registry.fetchingPlayers) then
			return
		end

		-- No more need to retry
		Musician.Registry.listChannelsRetryTimer:Cancel()

		-- Get connected players
		for player in string.gmatch(players, "([^, *]+)") do
			player = Musician.Utils.NormalizePlayerName(player)
			Musician.Registry.RegisterPlayer(player)
		end

		-- Finalize when all CHAT_MSG_CHANNEL_LIST pages are received (no new page received after 1 second)

		if Musician.Registry.fetchingPlayersTimer ~= nil then
			Musician.Registry.fetchingPlayersTimer:Cancel()
			Musician.Registry.fetchingPlayersTimer = nil
		end

		Musician.Registry.fetchingPlayersTimer = C_Timer.NewTimer(1, function()

			-- Display the number of players online
			local playerCount = 0
			for _, _ in pairs(Musician.Registry.players) do
				playerCount = playerCount + 1
			end

			if playerCount > 2 then
				Musician.Utils.Print(string.gsub(Musician.Msg.PLAYER_COUNT_ONLINE, '{count}', Musician.Utils.Highlight(playerCount - 1)))
			elseif playerCount == 2 then
				Musician.Utils.Print(Musician.Msg.PLAYER_COUNT_ONLINE_ONE)
			elseif playerCount < 2 then
				Musician.Utils.Print(Musician.Msg.PLAYER_COUNT_ONLINE_NONE)
			end

			-- We're done!
			Musician.Registry.playersFetched = true
			Musician.Registry.fetchingPlayers = false
			Musician.Registry.fetchingPlayersTimer = nil
			Musician.Registry:SendMessage(Musician.Events.RegistryReady)
		end)
	end)

	-- Hide CHAT_MSG_CHANNEL_LIST when fetching players
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LIST", function(self, event, ...)
		local _, _, _, _, _, _, _, _, channelName = ...
		if channelName == Musician.CHANNEL and Musician.Registry.fetchingPlayers then
			return true
		end
		return false, ...
	end)

	-- A player joins: add to the registry
	Musician.Registry:RegisterEvent("CHAT_MSG_CHANNEL_JOIN", function(event, _, player, _, _, _, _, _, _, channelName)

		-- Not the Musician channel
		if channelName ~= Musician.CHANNEL then
			return
		end

		Musician.Registry.RegisterPlayer(player)
	end)

	-- A player leaves: remove from registry
	Musician.Registry:RegisterEvent("CHAT_MSG_CHANNEL_LEAVE", function(event, _, player, _, _, _, _, _, _, channelName)

		-- Not the Musician channel
		if channelName ~= Musician.CHANNEL then
			return
		end

		Musician.Registry.UnregisterPlayer(player)
	end)

	-- Send "Hello" every 5 minutes
	C_Timer.NewTicker(300, function()
		if not(Musician.streamingSong) or not(Musician.streamingSong.streaming) then
			Musician.Registry.SendHello()
		end
	end)

	-- Finish initialization on login
	if not(IsLoggedIn()) then
		Musician.Registry:RegisterEvent("PLAYER_LOGIN", finishInit)
	else
		finishInit()
	end
end

--- Fetch the connected players
--
function Musician.Registry.FetchPlayers()
	-- Already fetching or fetched
	if Musician.Registry.playersFetched and not(Musician.Registry.fetchingPlayers) then
		return
	end

	-- Send fetch players request to the server
	if Musician.Comm.GetChannel() ~= nil then
		Musician.Registry.fetchingPlayers = true
		ListChannelByName(Musician.CHANNEL)

		-- The request may not work on the first attempt so try again every second until it succeeds
		Musician.Registry.listChannelsRetryTimer = C_Timer.NewTicker(1, function()
			ListChannelByName(Musician.CHANNEL)
		end)
	end
end

--- Update player's position and GUID
-- @param player (string)
-- @param posY (number)
-- @param posX (number)
-- @param posZ (number)
-- @param instanceID (string)
-- @param guid (string)
function Musician.Registry.UpdatePlayerPositionAndGUID(player, posY, posX, posZ, instanceID, guid)
	player = Musician.Utils.NormalizePlayerName(player)
	Musician.Registry.RegisterPlayer(player)
	Musician.Registry.players[player].posY = posY
	Musician.Registry.players[player].posX = posX
	Musician.Registry.players[player].posZ = posZ
	Musician.Registry.players[player].instanceID = instanceID
	Musician.Registry.players[player].location = { guid = guid } -- Do not create an actual PlayerLocation to save memory
end

--- Return true if the player is in loading range
-- @param player (string)
-- @return isInLoadingRange (boolean)
function Musician.Registry.PlayerIsInLoadingRange(player)
	player = Musician.Utils.NormalizePlayerName(player)

	-- Player is always in range with itself
	if Musician.Utils.PlayerIsMyself(player) then
		return true
	end

	-- Player is not in the registry
	if not(Musician.Registry.PlayerIsRegistered(player)) then
		return false
	end

	-- Player is not "connected" (in the same shard and phase and close enough to interact with the character)
	if not(C_PlayerInfo.IsConnected(Musician.Registry.players[player].location)) then
		return false
	end

	return true
end

--- Return true if the player is in listening range
-- @param player (string)
-- @return isInRange (boolean)
function Musician.Registry.PlayerIsInRange(player)
	-- Already checks if the player is close enough to load the data and in the same phase/instance
	if not(Musician.Registry.PlayerIsInLoadingRange(player)) then
		return false
	end

	-- Only works when the player is in our group but more precise
	local inRange, checkedRange = UnitInRange(Musician.Utils.SimplePlayerName(player))
	if checkedRange then
		return inRange
	end

	-- Range check
	player = Musician.Utils.NormalizePlayerName(player)
	local posY, posX, posZ, _ = Musician.Utils.GetPlayerPosition()
	local pp = Musician.Registry.players[player]
	return Musician.LISTENING_RADIUS ^ 2 > (pp.posY - posY) ^ 2 + (pp.posX - posX) ^ 2 + (pp.posZ - posZ) ^ 2
end

--- Return player GUID
-- @param player (string)
-- @return guid (string)
function Musician.Registry.GetPlayerGUID(player)
	local playerData = Musician.Registry.players[player]
	if playerData ~= nil and playerData.location then
		return playerData.location.guid
	end

	return nil
end

--- Return player tooltip text
-- @param player (string)
-- @return infoText (string)
function Musician.Registry.GetPlayerTooltipText(player)
	player = Musician.Utils.NormalizePlayerName(player)

	if not(Musician.Registry.PlayerIsRegistered(player)) then
		return nil
	end

	local infoText = Musician.Msg.PLAYER_TOOLTIP

	local playerVersion, playerProtocol = Musician.Registry.GetPlayerVersion(player)
	if playerVersion then
		infoText = string.gsub(Musician.Msg.PLAYER_TOOLTIP_VERSION, '{version}', playerVersion)

		if playerProtocol < Musician.PROTOCOL_VERSION then
			infoText = infoText .. " " .. Musician.Utils.Highlight(Musician.Msg.PLAYER_TOOLTIP_VERSION_OUTDATED, DIM_RED_FONT_COLOR)
		elseif playerProtocol > Musician.PROTOCOL_VERSION then
			infoText = infoText .. " " ..  Musician.Utils.Highlight(Musician.Msg.PLAYER_TOOLTIP_VERSION_INCOMPATIBLE, RED_FONT_COLOR)
		end
	end

	return infoText
end

--- Update missing Musician client version in tooltip, if applicable.
-- @param tooltip (table)
-- @param player (string)
-- @param[opt=nil] fontSize (int)
function Musician.Registry.UpdateTooltipInfo(tooltip, player, fontSize)

	-- Reposition line if it's not in the last position
	local repositionLine = function(line, i)
		if i ~= tooltip:NumLines() then
			line:SetText("")
			Musician.Registry.UpdateTooltipInfo(tooltip, player, fontSize)
		end
	end

	local infoText = Musician.Registry.GetPlayerTooltipText(player)

	if infoText == nil then
		return
	end

	local tooltipName = tooltip:GetName()
	local i = 1
	while _G[tooltipName .. 'TextRight' .. i] do
		local line = _G[tooltipName .. 'TextRight' .. i]

		-- Info text is already present: no update needed
		if line:GetText() == infoText then
			repositionLine(line, i)
			return
		end

		-- Default is already present: update it by the detailed info text
		if line:GetText() == Musician.Msg.PLAYER_TOOLTIP then
			line:SetText(infoText)
			repositionLine(line, i)
			return
		end

		i = i + 1
	end

	-- No existing text was not found: add it
	tooltip:AddDoubleLine(" ", infoText, 1, 1, 1, 1, 1, 1)
	if fontSize ~= nil then
		local line = _G[strconcat(tooltip:GetName(), "TextRight", tooltip:NumLines())]
		local font, _ , flag = line:GetFont()
		line:SetFont(font, fontSize, flag)
	end
	tooltip:Show()
	tooltip:GetTop()
end

--- Update player tooltip to add missing Musician client version, if applicable.
-- @param player (string)
function Musician.Registry.UpdatePlayerTooltip(player)
	local _, unitType = GameTooltip:GetUnit()
	if not(UnitIsPlayer(unitType)) then return end
	local tooltipPlayer = Musician.Utils.NormalizePlayerName(GetUnitName(unitType, true))
	if tooltipPlayer == player then
		Musician.Registry.UpdateTooltipInfo(GameTooltip, player)
	end
end

--- Send a Hello to the channel
--
function Musician.Registry.SendHello()
	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
		if Musician.Comm.GetChannel() ~= nil then
			debugComm(true, Musician.Registry.event.hello, Musician.Comm.GetChannel())
			Musician.Registry:SendCommMessage(Musician.Registry.event.hello, Musician.Registry.GetVersionString(), 'CHANNEL', Musician.Comm.GetChannel(), "ALERT")
		end
	else
		debugComm(true, Musician.Registry.event.hello, 'YELL')
		Musician.Registry:SendCommMessage(Musician.Registry.event.hello, Musician.Registry.GetVersionString(), 'YELL', nil, "ALERT")
	end
end

--- Set player version
-- @param player (string)
-- @param version (string)
function Musician.Registry.SetPlayerVersion(player, version)
	player = Musician.Utils.NormalizePlayerName(player)
	Musician.Registry.RegisterPlayer(player)
	Musician.Registry.players[player].version = version
	Musician.Registry.queriedPlayers[player] = nil

	Musician.Registry.UpdatePlayerTooltip(player)
	Musician.Registry.NotifyNewVersion(version)
end

--- Receive Hello message
--
function Musician.Registry.OnHello(prefix, version, distribution, player)
	debugComm(false, prefix, player, distribution, version)
	Musician.Registry.SetPlayerVersion(player, version)
end

--- Receive Query message
--
function Musician.Registry.OnQuery(prefix, version, distribution, player)
	debugComm(false, prefix, player, distribution, version)
	player = Musician.Utils.NormalizePlayerName(player)

	if Musician.Utils.PlayerIsMyself(player) then
		return
	end

	Musician.Registry.SetPlayerVersion(player, version)

	if distribution == 'WHISPER' then
		debugComm(true, Musician.Registry.event.hello, player)
		Musician.Registry:SendCommMessage(Musician.Registry.event.hello, Musician.Registry.GetVersionString(), 'WHISPER', player, "ALERT")
	elseif Musician.Comm.GetGroupChatType() then
		debugComm(true, Musician.Registry.event.hello, Musician.Comm.GetGroupChatType())
		Musician.Registry:SendCommMessage(Musician.Registry.event.hello, Musician.Registry.GetVersionString(), Musician.Comm.GetGroupChatType(), nil, "ALERT")
	end
end

--- Add player to registry
-- @param player (string)
function Musician.Registry.RegisterPlayer(player)
	player = Musician.Utils.NormalizePlayerName(player)

	if Musician.Registry.players[player] == nil then
		Musician.Registry.players[player] = {}
		Musician.Registry:SendMessage(Musician.Registry.event.playerRegistered, player)
		Musician.Registry.UpdatePlayerTooltip(player)
	end
end

--- Remove player from registry
-- @param player (string)
function Musician.Registry.UnregisterPlayer(player)
	player = Musician.Utils.NormalizePlayerName(player)
	if Musician.Registry.players[player] then
		wipe(Musician.Registry.players[player])
		Musician.Registry.players[player] = nil
		Musician.Registry:SendMessage(Musician.Registry.event.playerUnregistered, player)
	end
end

--- Return true if this player has Musician
-- @param player (string)
-- @return isRegistered (boolean)
function Musician.Registry.PlayerIsRegistered(player)
	return Musician.Registry.players[player] ~= nil
end

--- Return true if this player has Musician but with unknown version number
-- @param player (string)
-- @return isRegisteredWithNoVersion (boolean)
function Musician.Registry.PlayerIsRegisteredWithNoVersion(player)
	return Musician.Registry.PlayerIsRegistered(player) and Musician.Registry.players[player].version == nil
end

--- Return true if this player has Musician with version number
-- @param player (string)
-- @return isRegisteredWithVersion (boolean)
function Musician.Registry.PlayerIsRegisteredWithVersion(player)
	return Musician.Registry.PlayerIsRegistered(player) and Musician.Registry.players[player].version ~= nil
end

--- Get full version string
-- Version string contains actual addon version and protocol version
-- @return versionAndProtocol (string)
function Musician.Registry.GetVersionString()
	local versionParts = { string.split('.', GetAddOnMetadata("Musician", "Version")) }
	local protocolParts = { 0, 0, 0, 0, Musician.PROTOCOL_VERSION }
	return table.concat(Musician.Utils.DeepMerge(protocolParts, versionParts), '.')
end

--- Extract version and protocol from received version string
-- @param versionAndProtocol (string)
-- @return version (string)
-- @return protocol (number)
function Musician.Registry.ExtractVersionAndProtocol(versionAndProtocol)
	versionAndProtocol = string.gsub(versionAndProtocol, "%s.+", "")
	local versionParts = { string.split('.', versionAndProtocol) }
	local protocol
	local majorVersion = tonumber(versionParts[1]) or 0
	local minorVersion = tonumber(versionParts[2]) or 0

	-- Version string contains protocol version as 5th number
	if #versionParts == 5 then
		protocol = tonumber(table.remove(versionParts, 5)) or 0
	elseif majorVersion == 1 and minorVersion >= 5 then -- 1.5.xx -> MUS4
		protocol = 4
	elseif majorVersion == 1 and minorVersion >= 4 then -- 1.4.xx -> MUS3
		protocol = 3
	elseif majorVersion == 1 and minorVersion >= 1 then -- 1.1.xx -> MUS2
		protocol = 2
	else -- 1.0.xx -> MUS1
		protocol = 1
	end

	return table.concat(versionParts, '.'), protocol
end

--- Return version and protocol for player
-- @param player (string)
-- @return version (string)
-- @return protocol (number)
function Musician.Registry.GetPlayerVersion(player)
	player = Musician.Utils.NormalizePlayerName(player)
	local entry = Musician.Registry.players[player]

	if not(entry) or not (entry.version) then
		return nil, nil
	end

	return Musician.Registry.ExtractVersionAndProtocol(entry.version)
end

--- Display a message if a new version of the addon is available
-- @param otherVersion (string)
function Musician.Registry.NotifyNewVersion(otherVersion)

	local myVersion, myProtocol = Musician.Registry.ExtractVersionAndProtocol(Musician.Registry.GetVersionString())
	local theirVersion, theirProtocol = Musician.Registry.ExtractVersionAndProtocol(otherVersion)

	-- Do not notify new version if version number contains non numeric characters
	if theirVersion:match("[^0-9\\.]") then return end

	-- Compare versions
	if not(newVersionNotified) and Musician.Utils.VersionCompare(theirVersion, myVersion) == 1 then
		newVersionNotified = true

		local msg = Musician.Msg.NEW_VERSION
		msg = string.gsub(msg, '{url}', Musician.Utils.GetUrlLink(Musician.URL))
		msg = string.gsub(msg, '{version}', Musician.Utils.Highlight(theirVersion))

		-- Display message with fanfare sound
		if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
			PlaySound(67788, 'Master')
		else
			PlaySoundFile("Interface\\AddOns\\Musician\\ui\\sound\\fx_flute_mylunesmelody_short.ogg")
		end

		Musician.Utils.Print(msg)
	end

	-- Compare protocol versions
	if not(newProtocolNotified) and theirProtocol > myProtocol then
		newProtocolNotified = true

		local msg = Musician.Msg.NEW_PROTOCOL_VERSION
		msg = string.gsub(msg, '{url}', Musician.Utils.GetUrlLink(Musician.URL))
		msg = string.gsub(msg, '{version}', Musician.Utils.Highlight(theirVersion))
		msg = string.gsub(msg, '{protocol}', Musician.Utils.Highlight(theirProtocol))

		C_Timer.After(3, function() Musician.Utils.Popup(msg) end)
	end
end
