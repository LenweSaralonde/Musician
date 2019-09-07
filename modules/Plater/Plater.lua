Musician.Plater = LibStub("AceAddon-3.0"):NewAddon("Musician.Plater", "AceEvent-3.0")

local MODULE_NAME = "Plater"
Musician.AddModule(MODULE_NAME)

--- OnEnable
--
function Musician.Plater:OnEnable()
	-- Add musical note icon next to player name
	if Plater and Plater.UpdatePlateText then

		Musician.Utils.Debug(MODULE_NAME, "Plater nameplates detected.")

		hooksecurefunc(Musician.NamePlates, "UpdateNoteIcon", function(namePlate, player)
			Musician.NamePlates.AddNoteIcon(namePlate, namePlate.CurrentUnitNameString)
		end)
	end
end