--- TidyPlates_ThreatPlates integration
-- @module Musician.TidyPlates_ThreatPlates

Musician.TidyPlates_ThreatPlates = LibStub("AceAddon-3.0"):NewAddon("Musician.TidyPlates_ThreatPlates", "AceEvent-3.0")

local MODULE_NAME = "TidyPlates_ThreatPlates"
Musician.AddModule(MODULE_NAME)

--- OnEnable
--
function Musician.TidyPlates_ThreatPlates:OnEnable()
	if TidyPlatesThreat then
		Musician.Utils.Debug(MODULE_NAME, "TidyPlates ThreatPlates detected.")

		-- Disable incompatible features
		Musician.NamePlates.ForbidHideHealthBars()
		Musician.NamePlates.ForbidShowNamesCinematicMode()

		hooksecurefunc(Musician.NamePlates, "UpdateNoteIcon", function(namePlate)
			if namePlate.TPFrame and namePlate.TPFrame.visual and namePlate.TPFrame.visual.name then
				Musician.NamePlates.AddNoteIcon(namePlate, namePlate.TPFrame.visual.name)
			end
		end)
	end
end