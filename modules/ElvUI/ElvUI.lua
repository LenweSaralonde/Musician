Musician.ElvUI = LibStub("AceAddon-3.0"):NewAddon("Musician.ElvUI", "AceEvent-3.0")

local MODULE_NAME = "ElvUI"
Musician.AddModule(MODULE_NAME)

local function updateEvlUI_Nameplate(self, ElvNamePlate)
	if ElvNamePlate then
		local namePlate = ElvNamePlate:GetParent()
		C_Timer.After(0, function() Musician.NamePlates.AddNoteIcon(namePlate, ElvNamePlate.Name) end)
	end
end

--- OnEnable
--
function Musician.ElvUI:OnEnable()
	if ElvUI then

		Musician.Utils.Debug(MODULE_NAME, "ElvUI detected.")

		local E, L, V, P, G = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
		local NP = E:GetModule("NamePlates")

		-- Add musical note icon next to player name
		hooksecurefunc(NP, "Update_Name", updateEvlUI_Nameplate)
		hooksecurefunc(NP, "SetupTarget", updateEvlUI_Nameplate)

		-- Update nameplate when player is registered
		Musician.ElvUI:RegisterMessage(Musician.Registry.event.playerRegistered, function(event, player)
			local player = Musician.Utils.NormalizePlayerName(player)
			local namePlate = Musician.NamePlates.playerNamePlates[player]
			if not(namePlate) then return end
			local namePlateName = namePlate:GetName()
			local ElvNamePlate = _G["ElvNP_" .. namePlateName]
			if not(ElvNamePlate) then return end
			Musician.NamePlates.AddNoteIcon(namePlate, ElvNamePlate.Name)
		end)
	end
end

