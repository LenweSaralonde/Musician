--- NeatPlates integration
-- @module Musician.NeatPlates

Musician.NeatPlates = LibStub("AceAddon-3.0"):NewAddon("Musician.NeatPlates", "AceEvent-3.0")

local MODULE_NAME = "NeatPlates"
Musician.AddModule(MODULE_NAME)

--- OnEnable
--
function Musician.NeatPlates:OnEnable()

	if Musician.NamePlates and NeatPlates then
		Musician.Utils.Debug(MODULE_NAME, "NeatPlates detected.")

		-- Always render the note icon
		Musician.NamePlates.ShouldRenderNoteIcon = function()
			return true
		end

		-- Add note icon
		hooksecurefunc(Musician.NamePlates, "UpdateNoteIcon", function(namePlate)
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
