Musician.Registry = LibStub("AceAddon-3.0"):NewAddon("Musician.Registry", "AceEvent-3.0", "AceComm-3.0")

Musician.Registry.players = {}
Musician.Registry.playersFetched = false

Musician.Registry.event = {}
Musician.Registry.event.hello = "MusicianHello"
Musician.Registry.event.query = "MusicianQuery"

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
				Musician.Registry.AddTooltipInfo(GameTooltip, GetUnitName(unitType, true), 10)
			end
		end)

		-- Total RP player tooltip hook
		if TRP3_CharacterTooltip ~= nil then
			TRP3_CharacterTooltip:HookScript("OnShow", function(t)
				Musician.Registry.AddTooltipInfo(TRP3_CharacterTooltip, t.target, TRP3_API.ui.tooltip.getSmallLineFontSize())
			end)
		end

		-- Send query to group
		if Musician.Comm.GetGroupChatType() then
			Musician.Registry:SendCommMessage(Musician.Registry.event.query, GetAddOnMetadata("Musician", "Version"), Musician.Comm.GetGroupChatType(), nil, "ALERT")
		end
	end)

	-- Send query to group when joining
	Musician.Registry:RegisterEvent("GROUP_JOINED", function()
		Musician.Registry:SendCommMessage(Musician.Registry.event.query, GetAddOnMetadata("Musician", "Version"), Musician.Comm.GetGroupChatType(), nil, "ALERT")
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

		-- Player is in group but not (yet) in registry
		local isNewlyGroupedPlayer = (Musician.Registry.players[player] == nil) and Musician.Utils.PlayerIsInGroup(player)

		if isNewlyGroupedPlayer or Musician.Registry.players[player] ~= nil then
			if Musician.Registry.players[player] == nil then
				Musician.Registry.players[player] = {}
			end

			local playerData = Musician.Registry.players[player]
			if playerData.version == nil and not(playerData.query) then
				playerData.query = true
				if not(isNewlyGroupedPlayer) then -- If the player is in the group and has Musician, the version will be retrieved when joining.
					Musician.Registry:SendCommMessage(Musician.Registry.event.query, GetAddOnMetadata("Musician", "Version"), 'WHISPER', player, "ALERT")
				end
			end
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

			if Musician.Registry.players[player] == nil then
				Musician.Registry.players[player] = {}
			end

			Musician.Registry.players[player].online = true
		end

		-- Finalize when all CHAT_MSG_CHANNEL_LIST pages are received (no new page received after 1 second)

		if Musician.Registry.fetchingPlayersTimer ~= nil then
			Musician.Registry.fetchingPlayersTimer:Cancel()
			Musician.Registry.fetchingPlayersTimer = nil
		end

		Musician.Registry.fetchingPlayersTimer = C_Timer.NewTimer(1, function()

			-- Display the number of players online
			local playerCount = 0
			for _, player in pairs(Musician.Registry.players) do
				if player.online then
					playerCount = playerCount + 1
				end
			end

			if playerCount > 2 then
				Musician.Utils.Print(string.gsub(Musician.Msg.PLAYER_COUNT_ONLINE, '{count}', Musician.Utils.Highlight(playerCount - 1)))
			elseif playerCount == 2 then
				Musician.Utils.Print(Musician.Msg.PLAYER_COUNT_ONLINE_ONE)
			end

			-- Say hello to them
			Musician.Registry.SendHello()

			-- We're done!
			Musician.Registry.playersFetched = true
			Musician.Registry.fetchingPlayers = false
			Musician.Registry.fetchingPlayersTimer = nil
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

		if Musician.Registry.players[player] == nil then
			Musician.Registry.players[player] = {}
		end

		Musician.Registry.players[player].online = true
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
		Musician.Registry.players[player].online = true
	end

	Musician.Registry.players[player].posY = posY
	Musician.Registry.players[player].posX = posX
	Musician.Registry.players[player].posZ = posZ
	Musician.Registry.players[player].instanceID = instanceID
	Musician.Registry.players[player].guid = guid
end

--- Returns true if the player is in range
-- @param player (string)
-- @param radius (number) Distance in yards
-- @return (boolean)
function Musician.Registry.PlayerIsInRange(player, radius)
	player = Musician.Utils.NormalizePlayerName(player)

	-- Player is always in range with itself
	if Musician.Utils.PlayerIsMyself(player) then
		return true
	end

	-- Player not in registry
	if not(Musician.Registry.PlayerIsOnline(player)) or Musician.Registry.players[player].guid == nil then
		return false
	end

	local posY, posX, posZ, instanceID = UnitPosition("player")
	local pp = Musician.Registry.players[player]

	-- Not the same instance
	if pp.instanceID ~= instanceID then
		return false
	end

	-- Current player is in an instance
	if IsInInstance() then
		return UnitInRange(Musician.Utils.SimplePlayerName(player)) -- Only works when the player is in our group
	end

	-- Range check
	return radius ^ 2 > (pp.posY - (posY or 0)) ^ 2 + (pp.posX - (posX or 0)) ^ 2 + (pp.posZ - (posZ or 0)) ^ 2
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

--- Append Musician client version to player tooltip, if applicable.
-- @param tooltip (table)
-- @param player (string)
-- @param fontSize (int)
function Musician.Registry.AddTooltipInfo(tooltip, player, fontSize)
	player = Musician.Utils.NormalizePlayerName(player)

	if not(Musician.Registry.PlayerIsOnline(player)) then return end

	local localPlayerData = Musician.Registry.players[player]

	local infoText = Musician.Msg.PLAYER_TOOLTIP

	if localPlayerData.version then
		infoText = string.gsub(Musician.Msg.PLAYER_TOOLTIP_VERSION, '{version}', localPlayerData.version)
	end

	tooltip:AddDoubleLine(" ", infoText, 1, 1, 1, 1, 1, 1)
	local line = _G[strconcat(tooltip:GetName(), "TextRight", tooltip:NumLines())]
	local font, _ , flag = line:GetFont()
	line:SetFont(font, fontSize, flag)
	tooltip:Show()
	tooltip:GetTop()
end

--- Send a hello to the channel
--
function Musician.Registry.SendHello()
	if Musician.Comm.getChannel() ~= nil then
		Musician.Registry:SendCommMessage(Musician.Registry.event.hello, GetAddOnMetadata("Musician", "Version"), 'CHANNEL', Musician.Comm.getChannel(), "ALERT")
	end
end

--- Receive hello message
--
Musician.Registry:RegisterComm(Musician.Registry.event.hello, function(prefix, message, distribution, player)
	player = Musician.Utils.NormalizePlayerName(player)

	if Musician.Registry.players[player] == nil then
		Musician.Registry.players[player] = {}
	end

	Musician.Registry.players[player].online = true
	Musician.Registry.players[player].query = true
	Musician.Registry.players[player].version = message

	Musician.Registry.NotifyNewVersion(message)
end)

--- Receive query message
--
Musician.Registry:RegisterComm(Musician.Registry.event.query, function(prefix, message, distribution, player)
	player = Musician.Utils.NormalizePlayerName(player)
	local version = message

	if Musician.Utils.PlayerIsMyself(player) then
		return
	end

	if Musician.Registry.players[player] == nil then
		Musician.Registry.players[player] = {}
	end

	Musician.Registry.players[player].online = true
	Musician.Registry.players[player].version = version
	Musician.Registry.players[player].query = true

	Musician.Registry.NotifyNewVersion(version)

	if distribution == 'WHISPER' then
		Musician.Registry:SendCommMessage(Musician.Registry.event.hello, GetAddOnMetadata("Musician", "Version"), 'WHISPER', player, "ALERT")
	elseif Musician.Comm.GetGroupChatType() then
		Musician.Registry:SendCommMessage(Musician.Registry.event.hello, GetAddOnMetadata("Musician", "Version"), Musician.Comm.GetGroupChatType(), nil, "ALERT")
	end
end)

--- Return true if this player is online and has Musician
-- @param player (string)
-- @return (boolean)
function Musician.Registry.PlayerIsOnline(player)
	return Musician.Registry.players[player] and Musician.Registry.players[player].online
end

--- Display a message if a new version of the addon is available
-- @param otherVersion (string)
function Musician.Registry.NotifyNewVersion(otherVersion)

	local myVersion = GetAddOnMetadata("Musician", "Version")
	local myVersionParts = { string.split('.', myVersion) }
	local otherVersionParts = { string.split('.', otherVersion) }
	local myMajorVersion = myVersionParts[1] .. '.' .. myVersionParts[2]
	local otherMajorVersion = otherVersionParts[1] .. '.' .. otherVersionParts[2]

	-- Compare minor version
	if not(Musician.Registry.newVersionNotified) and Musician.Utils.VersionCompare(otherVersion, myVersion) == 1 then
		Musician.Registry.newVersionNotified = true

		local msg = Musician.Msg.NEW_VERSION
		msg = string.gsub(msg, '{url}', Musician.Utils.Highlight(Musician.URL, '00FFFF'))
		msg = string.gsub(msg, '{version}', Musician.Utils.Highlight(otherVersion))

		-- Display message with fanfare sound
		local _, handle = PlaySound(67788, 'Master')
		Musician.Utils.Print(msg)
	end

	-- Compare major version
	if not(Musician.Registry.newMajorVersionNotified) and Musician.Utils.VersionCompare(otherMajorVersion, myMajorVersion) == 1 then
		Musician.Registry.newMajorVersionNotified = true
		Musician.Registry.newVersionNotified = true

		local msg = Musician.Msg.NEW_MAJOR_VERSION
		msg = string.gsub(msg, '{url}', Musician.Utils.Highlight(Musician.URL, '00FFFF'))
		msg = string.gsub(msg, '{version}', Musician.Utils.Highlight(otherVersion))

		C_Timer.After(3, function() Musician.Utils.Popup(msg) end)
	end
end
