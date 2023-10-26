--- Simulates a volume meter for visual feedback
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

		-- Update nameplate when player is registered
		Musician.ElvUI:RegisterMessage(Musician.Registry.event.playerRegistered, function(event, player)
			local fullPlayerName = Musician.Utils.NormalizePlayerName(player)
			local namePlate = Musician.NamePlates.playerNamePlates[fullPlayerName]
			if not namePlate then return end
			local namePlateName = namePlate:GetName()
			local ElvNamePlate = _G["ElvNP_" .. namePlateName]
			if not ElvNamePlate or not ElvNamePlate.Name then return end
			Musician.NamePlates.AddNoteIcon(namePlate, ElvNamePlate.Name)
		end)

		Musician.Utils.Debug(MODULE_NAME, "ElvUI module initialized.")
	end
end