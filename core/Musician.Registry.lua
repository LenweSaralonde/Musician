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

	-- Setup tooltip hooks
	Musician.Registry:RegisterEvent("PLAYER_ENTERING_WORLD", function()

		if initialized then return end

		initialized = true

		-- Standard player tooltip
		GameTooltip:HookScript("OnTooltipSetUnit", function()
			local unitName, unitType = GameTooltip:GetUnit()
			if UnitIsPlayer(unitType) then
				Musician.Registry.AddTooltipInfo(GameTooltip, unitName, 10)
			end
		end)

		-- Total RP player tooltip
		if TRP3_CharacterTooltip ~= nil then
			TRP3_CharacterTooltip:HookScript("OnShow", function(t)
				Musician.Registry.AddTooltipInfo(TRP3_CharacterTooltip, t.target, TRP3_API.ui.tooltip.getSmallLineFontSize())
			end)
		end
	end)

	-- Query hello to hovered player
	Musician.Registry:RegisterEvent("UPDATE_MOUSEOVER_UNIT", function()
		local unitName = UnitName("mouseover")
		if UnitIsPlayer("mouseover") then
			local player = Musician.Utils.NormalizePlayerName(unitName)

			if Musician.Registry.players[player] ~= nil then
				local playerData = Musician.Registry.players[player]
				if playerData.version == nil and not(playerData.query) then
					playerData.query = true
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

--- Append Musician client version to player tooltip, if applicable.
-- @param tooltip (table)
-- @param player (string)
-- @param fontSize (int)
function Musician.Registry.AddTooltipInfo(tooltip, player, fontSize)
	player = Musician.Utils.NormalizePlayerName(player)

	if Musician.Registry.players[player] == nil then return end

	local localPlayerData = Musician.Registry.players[player]

	if localPlayerData.online then

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

	if Musician.Registry.players[player] == nil then
		Musician.Registry.players[player] = {}
	end

	Musician.Registry.players[player].online = true
	Musician.Registry.players[player].version = message

	Musician.Registry.NotifyNewVersion(message)

	Musician.Registry:SendCommMessage(Musician.Registry.event.hello, GetAddOnMetadata("Musician", "Version"), 'WHISPER', player, "ALERT")
end)


--- Display a message if a new version of the addon is available
-- @param version (string)
function Musician.Registry.NotifyNewVersion(version)
	if Musician.Registry.newVersionNotified then return end

	if Musician.Utils.VersionCompare(version, GetAddOnMetadata("Musician", "Version")) == 1 then
		local msg = Musician.Msg.NEW_VERSION
		msg = string.gsub(msg, '{url}', Musician.Utils.Highlight(Musician.URL, '00FFFF'))
		msg = string.gsub(msg, '{version}', Musician.Utils.Highlight(version))
		Musician.Utils.Print(msg)
		PlaySound(67788, 'Master')
		Musician.Registry.newVersionNotified = true
	end
end
