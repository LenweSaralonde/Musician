Musician.ElvUI = LibStub("AceAddon-3.0"):NewAddon("Musician.ElvUI", "AceEvent-3.0")

local MODULE_NAME = "ElvUI"
Musician.AddModule(MODULE_NAME)

--- Add note icon to the ElvUI nameplate
-- @param namePlate (Frame)
local function addNote(namePlate)
	if namePlate.isPlayer then
		local player = Musician.Utils.NormalizePlayerName(namePlate.unitName)
		local nameText = namePlate.Name:GetText()
		if player and nameText and not(Musician.Utils.PlayerIsMyself(player)) and Musician.Registry.PlayerIsRegistered(player) then
			if string.find(nameText, Musician.IconImages.Note) == nil then
				namePlate.Name:SetText(Musician.Utils.GetChatIcon(Musician.IconImages.Note) .. " " .. nameText)
			end
		end
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
		hooksecurefunc(NP, "StyleFilterNameChanged", function(self)
			local ElvNamePlate = self:GetParent():GetParent()
			local namePlate = ElvNamePlate:GetParent()
			Musician.NamePlates.AddNoteIcon(namePlate, ElvNamePlate.Name)
		end)

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

