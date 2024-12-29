--- ElvUI integration
-- @module Musician.ElvUI

Musician.ElvUI = LibStub("AceAddon-3.0"):NewAddon("Musician.ElvUI", "AceEvent-3.0")

local MODULE_NAME = "ElvUI"
Musician.AddModule(MODULE_NAME)

local function updateEvlUI_Nameplate(self, ElvNamePlate)
	C_Timer.After(0, function()
		if ElvNamePlate and ElvNamePlate.Name then
			local namePlate = ElvNamePlate:GetParent()
			Musician.NamePlates.AddNoteIcon(namePlate, ElvNamePlate.Name)
		end
	end)
end

--- OnEnable
--
function Musician.ElvUI:OnEnable()
	if ElvUI then
		Musician.Utils.Debug(MODULE_NAME, "ElvUI detected.")

		-- Disable incompatible features
		Musician.NamePlates.ForbidHideHealthBars()

		local E, _, _, _, _ = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
		local NP = E:GetModule("NamePlates")

		if NP.Update_Tags == nil or NP.SetupTarget == nil or NP.StyleFilterUpdate == nil then
			Musician.Utils.Debug(MODULE_NAME, "Could not hook ElvUI functions.")
			return
		end

		-- Add musical note icon next to player name
		hooksecurefunc(NP, "Update_Tags", updateEvlUI_Nameplate)
		hooksecurefunc(NP, "SetupTarget", updateEvlUI_Nameplate)
		hooksecurefunc(NP, "StyleFilterUpdate", updateEvlUI_Nameplate)

		-- Update the note icon when the nameplate gets updated by MusicianNamePlates
		hooksecurefunc(Musician.NamePlates, "UpdateNoteIcon", function(namePlate)
			updateEvlUI_Nameplate(self, namePlate.unitFrame) -- ElvUI's custom frame is actually "unitFrame"
		end)

		Musician.Utils.Debug(MODULE_NAME, "ElvUI module initialized.")
	end
end