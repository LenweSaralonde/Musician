--- KuiNamePlates integration
-- @module Musician.KuiNamePlates

Musician.KuiNamePlates = LibStub("AceAddon-3.0"):NewAddon("Musician.KuiNamePlates", "AceEvent-3.0")

local MODULE_NAME = "KuiNamePlates"
Musician.AddModule(MODULE_NAME)

--- OnEnable
--
function Musician.KuiNamePlates:OnEnable()

	if Musician.NamePlates and KuiNameplates then

		Musician.Utils.Debug(MODULE_NAME, "Kui Nameplates detected.")

		hooksecurefunc(Musician.NamePlates, "UpdateNoteIcon", function(namePlate)
			if namePlate.kui and namePlate.kui.NameText then
				Musician.NamePlates.AddNoteIcon(namePlate, namePlate.kui.NameText)
			end
		end)

		-- Handle cinematic mode
		hooksecurefunc(Musician.NamePlates, "UpdateNamePlateCinematicMode", function(namePlate)
			if namePlate.kui then
				Musician.NamePlates.UpdateNamePlateCinematicMode(namePlate.kui)
				-- Refresh parent to fix layer ordering issues
				local parent = namePlate.kui:GetParent()
				namePlate.kui:SetParent(WorldFrame)
				namePlate.kui:SetParent(parent)
			end
		end)
	end
end
