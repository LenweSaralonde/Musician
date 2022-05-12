--- TidyPlates integration
-- @module Musician.TidyPlates

Musician.TidyPlates = LibStub("AceAddon-3.0"):NewAddon("Musician.TidyPlates", "AceEvent-3.0")

local MODULE_NAME = "TidyPlates"
Musician.AddModule(MODULE_NAME)

--- OnEnable
--
function Musician.TidyPlates:OnEnable()

	if TidyPlates then
		Musician.Utils.Debug(MODULE_NAME, "TidyPlates detected.")

		-- Add note icon
		hooksecurefunc(Musician.NamePlates, "UpdateNoteIcon", function(namePlate, player)
			if namePlate.extended and namePlate.extended.visual and namePlate.extended.visual.name then
				Musician.NamePlates.AddNoteIcon(namePlate, namePlate.extended.visual.name)
			end
		end)

		-- Handle cinematic mode
		hooksecurefunc(Musician.NamePlates, "UpdateNamePlateCinematicMode", function(namePlate)
			if namePlate.extended then
				Musician.NamePlates.UpdateNamePlateCinematicMode(namePlate.extended)
			end
			if namePlate.carrier then
				Musician.NamePlates.UpdateNamePlateCinematicMode(namePlate.carrier)
			end
		end)
	end
end

