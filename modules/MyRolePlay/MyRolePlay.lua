Musician.MyRolePlay = LibStub("AceAddon-3.0"):NewAddon("Musician.MyRolePlay", "AceEvent-3.0")

local MODULE_NAME = "MyRolePlay"
Musician.AddModule(MODULE_NAME)

function Musician.MyRolePlay:OnEnable()
	if mrp then
		Musician.MyRolePlay.HookTooltip()
	end
end

--- Hook MyRolePlay player tooltip
--
function Musician.MyRolePlay.HookTooltip()
	hooksecurefunc(mrp, "UpdateTooltip", function(self, player, unit, context)
		player = Musician.Utils.NormalizePlayerName(player)
		Musician.Registry.UpdateTooltipInfo(GameTooltip, player, 10)
	end)
end
