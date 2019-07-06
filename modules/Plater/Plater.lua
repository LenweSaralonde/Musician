Musician.Plater = LibStub("AceAddon-3.0"):NewAddon("Musician.Plater", "AceEvent-3.0")

local MODULE_NAME = "Plater"
Musician.AddModule(MODULE_NAME)

--- OnEnable
--
function Musician.Plater:OnEnable()
	-- Add musical note icon next to player name
	if Plater and Plater.UpdatePlateText then
		hooksecurefunc(Plater, "UpdatePlateText", function(plateFrame, plateConfigs, needReset)
			Musician.NamePlates.updateNoteIcon(plateFrame, plateFrame.unitFrame, plateFrame.CurrentUnitNameString)
		end)
	end

	-- Fix player name layer ordering
	if Plater and Plater.CheckRange then
		hooksecurefunc(Plater, "CheckRange", function(plateFrame, onAdded)
			plateFrame.CurrentUnitNameString:SetParent(plateFrame.unitFrame)
		end)
	end
end
