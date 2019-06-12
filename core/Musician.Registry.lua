Musician.Registry = LibStub("AceAddon-3.0"):NewAddon("Musician.Registry", "AceEvent-3.0", "AceComm-3.0")

Musician.Registry.players = {}
Musician.Registry.playersFetched = false
Musician.Registry.playersQueried = {}

Musician.Registry.event = {}
Musician.Registry.event.hello = "MusicianHello"
Musician.Registry.event.query = "MusicianQuery"

local newVersionNotified = false
local newProtocolNotified = false

local tooltipPlayerName

--- Initialize registry
--
function Musician.Registry.Init()

	local initialized = false

	-- Finish initialization when player enters world
	Musician.Registry:RegisterEvent("PLAYER_ENTERING_WORLD", function()

		if initialized then return end

		initialized = true

		-- Standard player tooltip hook
		GameTooltip:HookScript("OnTooltipSetUnit", function()
			local _, unitType = GameTooltip:GetUnit()
			if UnitIsPlayer(unitType) then
				local player = Musician.Utils.NormalizePlayerName(GetUnitName(unitType, true))
				tooltipPlayerName = player
				Musician.Registry.UpdateTooltipInfo(GameTooltip, player, 10)
			else
				tooltipPlayerName = nil
			end
		end)

		-- Send query to group
		if Musician.Comm.GetGroupChatType() then
			Musician.Registry:SendCommMessage(Musician.Registry.event.query, Musician.Registry.GetVersionString(), Musician.Comm.GetGroupChatType(), nil, "ALERT")
		end
	end)

	-- Send query to group when joining
	Musician.Registry:RegisterEvent("GROUP_JOINED", function()
		if Musician.Comm.GetGroupChatType() then
			Musician.Registry:SendCommMessage(Musician.Registry.event.query, Musician.Registry.GetVersionString(), Musician.Comm.GetGroupChatType(), nil, "ALERT")
		end
	end)

	-- Query hello to hovered player
	Musician.Registry:RegisterEvent("UPDATE_MOUSEOVER_UNIT", function()
		if not(UnitIsPlayer("mouseover")) then
			return
		end

		local player = Musician.Utils.NormalizePlayerName(GetUnitName("mouseover", true))
		if Musician.Utils.PlayerIsMyself(player) then
			return
		end

		local queryTime = Musician.Registry.playersQueried[player]
		local isQueried = queryTime and ((queryTime + 3) > GetTime()) -- Retry after 3 seconds
		local isRegistered = Musician.Registry.PlayerIsRegistered(player)
		local hasNoVersion = isRegistered and Musician.Registry.players[player].version == nil

		-- No version information available but player is registered: do query
		if hasNoVersion and isRegistered and not(isQueried) then
			Musician.Registry.playersQueried[player] = GetTime()
			Musician.Registry:SendCommMessage(Musician.Registry.event.query, Musician.Registry.GetVersionString(), 'WHISPER', player, "ALERT")
		end
	end)

	-- Update connected players
	Musician.Registry:RegisterEvent("CHAT_MSG_CHANNEL_LIST", function(event, players, _, _, _, _, _, _, _, channelName)

		-- Not the Musician channel
		if channelName ~= Musician.CHANNEL or not(Musician.Registry.fetchingPlayers) then
			return
		end

		-- Get connected players
		for player in string.gmatch(players, "([^, *]+)") do
			player = Musician.Utils.NormalizePlayerName(player)

			Musician.Registry.EnablePlayerDistribution(player, "CHANNEL")
		end

		-- Finalize when all CHAT_MSG_CHANNEL_LIST pages are received (no new page received after 1 second)

		if Musician.Registry.fetchingPlayersTimer ~= nil then
			Musician.Registry.fetchingPlayersTimer:Cancel()
			Musician.Registry.fetchingPlayersTimer = nil
		end

		Musician.Registry.fetchingPlayersTimer = C_Timer.NewTimer(1, function()

			-- Display the number of players online
			local playerCount = 0
			for player, _ in pairs(Musician.Registry.players) do
				if Musician.Registry.PlayerIsInChannel(player) then
					playerCount = playerCount + 1
				end
			end

			if playerCount > 2 then
				Musician.Utils.Print(string.gsub(Musician.Msg.PLAYER_COUNT_ONLINE, '{count}', Musician.Utils.Highlight(playerCount - 1)))
			elseif playerCount == 2 then
				Musician.Utils.Print(Musician.Msg.PLAYER_COUNT_ONLINE_ONE)
			elseif playerCount < 2 then
				Musician.Utils.Print(Musician.Msg.PLAYER_COUNT_ONLINE_NONE)
			end

			-- Say hello to them
			Musician.Registry.SendHello()

			-- We're done!
			Musician.Registry.playersFetched = true
			Musician.Registry.fetchingPlayers = false
			Musician.Registry.fetchingPlayersTimer = nil
			Musician.Comm:SendMessage(Musician.Events.CommReady)
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

		player = Musician.Utils.NormalizePlayerName(player)

		Musician.Registry.EnablePlayerDistribution(player, "CHANNEL")
	end)

	-- A player leaves: remove from registry
	Musician.Registry:RegisterEvent("CHAT_MSG_CHANNEL_LEAVE", function(event, _, player, _, _, _, _, _, _, channelName)

		-- Not the Musician channel
		if channelName ~= Musician.CHANNEL then
			return
		end

		player = Musician.Utils.NormalizePlayerName(player)

		Musician.Registry.players[player] = nil
	end)

	-- Send "Hello" every 5 minutes
	C_Timer.NewTicker(300, function()
		if not(Musician.streamingSong) or not(Musician.streamingSong.streaming) then
			Musician.Registry.SendHello()
		end
	end)

end

--- Fetch the connected players
--
function Musician.Registry.FetchPlayers()
	-- Already fetched
	if Musician.Registry.playersFetched then return end

	-- Send fetch players request to the server
	if Musician.Comm.getChannel() ~= nil then
		Musician.Registry.fetchingPlayers = true
		ListChannelByName(Musician.Comm.getChannel())
	end
end

--- Update player's position and GUID
-- @param player (string)
-- @param posY (number)
-- @param posX (string)
-- @param posZ (string)
-- @param instanceID (string)
-- @param guid (string)
function Musician.Registry.UpdatePlayerPositionAndGUID(player, posY, posX, posZ, instanceID, guid)
	if Musician.Registry.players[player] == nil then
		Musician.Registry.players[player] = {}
	end

	Musician.Registry.players[player].posY = posY
	Musician.Registry.players[player].posX = posX
	Musician.Registry.players[player].posZ = posZ
	Musician.Registry.players[player].instanceID = instanceID
	Musician.Registry.players[player].guid = guid
end

--- Returns true if the player is in loading range
-- @param player (string)
-- @return (boolean)
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
	local guid = Musician.Registry.players[player].guid
	local isVisible = guid and C_PlayerInfo.IsConnected(PlayerLocation:CreateFromGUID(guid))
	if not(isVisible) then
		return false
	end

	return true
end

--- Returns true if the player is in listening range
-- @param player (string)
-- @return (boolean)
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
	local posY, posX, posZ, instanceID = UnitPosition("player")
	local pp = Musician.Registry.players[player]
	return Musician.LISTENING_RADIUS ^ 2 > (pp.posY - (posY or 0)) ^ 2 + (pp.posX - (posX or 0)) ^ 2 + (pp.posZ - (posZ or 0)) ^ 2
end

--- Return player GUID
-- @param player (string)
-- @return (string)
function Musician.Registry.GetPlayerGUID(player)
	if Musician.Registry.players[player] ~= nil then
		return Musician.Registry.players[player].guid
	end

	return nil
end

--- Return player tooltip text
-- @param player (string)
-- @return (string)
local function getPlayerTooltipText(player)
	player = Musician.Utils.NormalizePlayerName(player)

	if not(Musician.Registry.PlayerIsRegistered(player)) or not(Musician.Utils.PlayerIsOnSameRealm(player)) and not(Musician.Utils.PlayerIsInGroup(player)) then
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
-- @param fontSize (int)
function Musician.Registry.UpdateTooltipInfo(tooltip, player, fontSize)
	local infoText = getPlayerTooltipText(player)

	if infoText == nil then
		return
	end

	local tooltipName = tooltip:GetName()
	local line
	local i = 1
	while _G[tooltipName .. 'TextRight' .. i] do
		local line = _G[tooltipName .. 'TextRight' .. i]

		-- Info text is already present: no update needed
		if line:GetText() == infoText then
			return
		end

		-- Default is already present: update it by the detailed info text
		if line:GetText() == Musician.Msg.PLAYER_TOOLTIP then
			line:SetText(infoText)
			return
		end

		i = i + 1
	end

	-- No existing text was not found: add it
	tooltip:AddDoubleLine(" ", infoText, 1, 1, 1, 1, 1, 1)
	local line = _G[strconcat(tooltip:GetName(), "TextRight", tooltip:NumLines())]
	local font, _ , flag = line:GetFont()
	line:SetFont(font, fontSize, flag)
	tooltip:Show()
	tooltip:GetTop()
end

--- Update player tooltip to add missing Musician client version, if applicable.
-- @param player (string)
function Musician.Registry.UpdatePlayerTooltip(player)
	if tooltipPlayerName == player then
		Musician.Registry.UpdateTooltipInfo(GameTooltip, player, 10)
	end
end

--- Send a hello to the channel
--
function Musician.Registry.SendHello()
	if Musician.Comm.getChannel() ~= nil then
		Musician.Registry:SendCommMessage(Musician.Registry.event.hello, Musician.Registry.GetVersionString(), 'CHANNEL', Musician.Comm.getChannel(), "ALERT")
	end
end

--- Handle incoming version message
--
local function handleVersionMessage(prefix, version, distribution, player)
	player = Musician.Utils.NormalizePlayerName(player)

	Musician.Registry.EnablePlayerDistribution(player, distribution)

	Musician.Registry.players[player].version = version
	Musician.Registry.playersQueried[player] = nil

	Musician.Registry.UpdatePlayerTooltip(player)
	Musician.Registry.NotifyNewVersion(version)
end

--- Receive hello message
--
Musician.Registry:RegisterComm(Musician.Registry.event.hello, handleVersionMessage)

--- Receive query message
--
Musician.Registry:RegisterComm(Musician.Registry.event.query, function(prefix, message, distribution, player)
	player = Musician.Utils.NormalizePlayerName(player)
	local version = message

	if Musician.Utils.PlayerIsMyself(player) then
		return
	end

	handleVersionMessage(prefix, message, distribution, player)

	if distribution == 'WHISPER' then
		Musician.Registry:SendCommMessage(Musician.Registry.event.hello, Musician.Registry.GetVersionString(), 'WHISPER', player, "ALERT")
	elseif Musician.Comm.GetGroupChatType() then
		Musician.Registry:SendCommMessage(Musician.Registry.event.hello, Musician.Registry.GetVersionString(), Musician.Comm.GetGroupChatType(), nil, "ALERT")
	end
end)

--- Add an available distribution channel to player
-- @param player (string)
-- @param distribution (string) (CHANNEL, WHISPER, PARTY etc)
function Musician.Registry.EnablePlayerDistribution(player, distribution)
	player = Musician.Utils.NormalizePlayerName(player)

	if Musician.Registry.players[player] == nil then
		Musician.Registry.players[player] = {}
	end

	if distribution == "CHANNEL" then
		Musician.Registry.players[player].isInChannel = true
	elseif distribution ~= "WHISPER" then
		Musician.Registry.players[player].groupSupport = true
	end
end

--- Return true if this player has Musician
-- @param player (string)
-- @return (boolean)
function Musician.Registry.PlayerIsRegistered(player)
	return Musician.Registry.players[player] ~= nil
end

--- Return true if this player has Musician and is in the channel
-- @param player (string)
-- @return (boolean)
function Musician.Registry.PlayerIsInChannel(player)
	return Musician.Registry.players[player] and Musician.Registry.players[player].isInChannel
end

--- Return true if the player supports group communication
-- @param name (string)
-- @return (boolean)
function Musician.Registry.PlayerHasGroupSupport(name)
	if not(Musician.Registry.players[name]) then
		return false
	end
	local player = Musician.Registry.players[name]
	return player.groupSupport or player.version and (Musician.Utils.VersionCompare(player.version, '1.4.1.0') >= 0)
end

--- Get full version string
-- Version string contains actual addon version and protocol version
-- @return (string)
function Musician.Registry.GetVersionString()
	local versionParts = { string.split('.', GetAddOnMetadata("Musician", "Version")) }
	local protocolParts = { 0, 0, 0, 0 } -- Add Musician.PROTOCOL_VERSION at 5th position when a new version of the protocol is available
	return table.concat(Musician.Utils.DeepMerge(protocolParts, versionParts), '.')
end

--- Extract version and protocol from received version string
-- @param version (string)
-- @return (string), (number)
function Musician.Registry.ExtractVersionAndProtocol(version)
	local versionParts = { string.split('.', version) }
	local protocol = Musician.PROTOCOL_VERSION

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
-- @return (string), (number)
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

	-- Compare versions
	if not(newVersionNotified) and Musician.Utils.VersionCompare(theirVersion, myVersion) == 1 then
		newVersionNotified = true

		local msg = Musician.Msg.NEW_VERSION
		msg = string.gsub(msg, '{url}', Musician.Utils.Highlight(Musician.URL, '00FFFF'))
		msg = string.gsub(msg, '{version}', Musician.Utils.Highlight(theirVersion))

		-- Display message with fanfare sound
		local _, handle = PlaySound(67788, 'Master')
		Musician.Utils.Print(msg)
	end

	-- Compare protocol versions
	if not(newProtocolNotified) and theirProtocol > myProtocol then
		newProtocolNotified = true

		local msg = Musician.Msg.NEW_PROTOCOL_VERSION
		msg = string.gsub(msg, '{url}', Musician.Utils.Highlight(Musician.URL, '00FFFF'))
		msg = string.gsub(msg, '{version}', Musician.Utils.Highlight(theirVersion))
		msg = string.gsub(msg, '{protocol}', Musician.Utils.Highlight(theirProtocol))

		C_Timer.After(3, function() Musician.Utils.Popup(msg) end)
	end
end
