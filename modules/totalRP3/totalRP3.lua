Musician.TRP3 = LibStub("AceAddon-3.0"):NewAddon("Musician.TRP3", "AceEvent-3.0")

local MODULE_NAME = "TRP3"
Musician.AddModule(MODULE_NAME)

function Musician.TRP3:OnEnable()
	if TRP3_API then
		Musician.Utils.Debug(MODULE_NAME, "Total RP3 module started.")
		Musician.TRP3.HookNamePlates()
		TRP3_API.Events.registerCallback("WORKFLOW_ON_FINISH", function()
			Musician.TRP3.HookTooltip()
		end)
	end
end

--- Hook TRP player tooltip
--
function Musician.TRP3.HookTooltip()
	Musician.Utils.Debug(MODULE_NAME, "Adding tooltip support.")

	-- Add Musician version to Total RP player tooltip
	TRP3_CharacterTooltip:HookScript("OnShow", function(t)
		Musician.Registry.UpdateTooltipInfo(TRP3_CharacterTooltip, t.target, TRP3_API.ui.tooltip.getSmallLineFontSize())
	end)

	--- Update Total RP player tooltip to add missing Musician client version, if applicable.
	hooksecurefunc(Musician.Registry, "UpdatePlayerTooltip", function(player)
		if TRP3_CharacterTooltip ~= nil and TRP3_CharacterTooltip.target == player then
			Musician.Registry.UpdateTooltipInfo(TRP3_CharacterTooltip, player, TRP3_API.ui.tooltip.getSmallLineFontSize())
		end
	end)
end

--- Hook TRP player nameplates (standard)
--
function Musician.TRP3.HookNamePlates()
	if AddOn_TotalRP3 and AddOn_TotalRP3.NamePlates and AddOn_TotalRP3.NamePlates.BlizzardDecoratorMixin then
		Musician.Utils.Debug(MODULE_NAME, "Adding nameplate support.")
		hooksecurefunc(AddOn_TotalRP3.NamePlates.BlizzardDecoratorMixin, "UpdateNamePlateName", function(self, namePlate)
			Musician.NamePlates.UpdateNoteIcon(namePlate)
		end)
	end
end