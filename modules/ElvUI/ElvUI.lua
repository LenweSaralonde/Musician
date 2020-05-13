--- Simulates a volume meter for visual feedback
--- ElvUI integration
-- @module Musician.ElvUI

Musician.ElvUI = LibStub("AceAddon-3.0"):NewAddon("Musician.ElvUI", "AceEvent-3.0")

local MODULE_NAME = "ElvUI"
Musician.AddModule(MODULE_NAME)

local function updateEvlUI_Nameplate(self, ElvNamePlate)
	C_Timer.After(0, function()
		if ElvNamePlate then
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

		local E, L, V, P, G = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
		local NP = E:GetModule("NamePlates")

		if NP.StyleFilterUpdate == nil or NP.SetupTarget == ni then
			Musician.Utils.Debug(MODULE_NAME, "Could not hook ElvUI functions.")
			return
		end

		-- Add musical note icon next to player name
		hooksecurefunc(NP, "Update_Name", updateEvlUI_Nameplate)
		hooksecurefunc(NP, "SetupTarget", updateEvlUI_Nameplate)

		-- Add musical note icon next to player name
		hooksecurefunc(NP, "StyleFilterUpdate", function(_, ElvNamePlate, event)
			C_Timer.After(0, function()
				local namePlate = ElvNamePlate:GetParent()
				Musician.NamePlates.AddNoteIcon(namePlate, ElvNamePlate.Name)
			end)
		end)

		-- Update nameplate when player is registered
		Musician.ElvUI:RegisterMessage(Musician.Registry.event.playerRegistered, function(event, player)
			local player = Musician.Utils.NormalizePlayerName(player)
			local namePlate = Musician.NamePlates.playerNamePlates[player]
			if not(namePlate) then return end
			local namePlateName = namePlate:GetName()
			local ElvNamePlate = _G["ElvNP_" .. namePlateName]

print("NAMEPLATE", "ElvNP_" .. namePlateName)

			if not(ElvNamePlate) then return end
			Musician.NamePlates.AddNoteIcon(namePlate, ElvNamePlate.Name)
		end)
	end
end

