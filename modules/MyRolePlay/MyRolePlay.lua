--- MyRolePlay integration, including RP player names and tooltips.
-- @module Musician.MyRolePlay

Musician.MyRolePlay = LibStub("AceAddon-3.0"):NewAddon("Musician.MyRolePlay", "AceEvent-3.0")

local MODULE_NAME = "MyRolePlay"
Musician.AddModule(MODULE_NAME)

function Musician.MyRolePlay:OnEnable()
	if mrp then
		Musician.MyRolePlay.HookPlayerNames()
		Musician.MyRolePlay.HookTooltip()
	end
end

--- Return RP display name for player
-- @param player (string)
-- @return (string)
function Musician.MyRolePlay.GetRpName(player)
	player = Musician.Utils.GetFullPlayerName(player)
	if msp and msp.char and msp.char[player] and msp.char[player].field and msp.char[player].field.NA then
		if msp.char[player].field.NA ~= "" then
			return msp.char[player].field.NA
		end
	end
	return Musician.Utils.SimplePlayerName(player)
end

--- Hook player name formatting
--
function Musician.MyRolePlay.HookPlayerNames()
	Musician.Utils.FormatPlayerName = Musician.MyRolePlay.GetRpName
end

--- Hook MyRolePlay player tooltip
--
function Musician.MyRolePlay.HookTooltip()
	hooksecurefunc(mrp, "UpdateTooltip", function(self, player)
		player = Musician.Utils.NormalizePlayerName(player)
		Musician.Registry.UpdateTooltipInfo(GameTooltip, player, 10)
	end)
end
