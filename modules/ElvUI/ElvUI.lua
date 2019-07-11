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
		local E, L, V, P, G = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
		local NP = E:GetModule("NamePlates")

		-- Add musical note icon next to player name
		hooksecurefunc(NP, "StyleFilterNameChanged", function(self)
			local namePlate = self:GetParent():GetParent()
			addNote(namePlate)
		end)

		-- Update nameplate when player is registered
		Musician.ElvUI:RegisterMessage(Musician.Registry.event.playerRegistered, function(event, player)
			local player = Musician.Utils.NormalizePlayerName(player)
			if not(Musician.NamePlates.playerNamePlates[player]) then return end
			local namePlateName = Musician.NamePlates.playerNamePlates[player]:GetName()
			local namePlate = _G["ElvNP_" .. namePlateName]
			if not(namePlate) then return end
			addNote(namePlate)
		end)
	end
end

