--- Plater integration
-- @module Musician.Plater

Musician.Plater = LibStub("AceAddon-3.0"):NewAddon("Musician.Plater", "AceEvent-3.0")

local MODULE_NAME = "Plater"
Musician.AddModule(MODULE_NAME)

--- OnEnable
--
function Musician.Plater:OnEnable()
	-- Add musical note icon next to player name
	if Plater and Plater.UpdatePlateText then
		Musician.Utils.Debug(MODULE_NAME, "Plater nameplates detected.")

		-- Disable incompatible features
		Musician.NamePlates.ForbidHideHealthBars()
		Musician.NamePlates.ForbidShowNamesCinematicMode()

		Musician.NamePlates.UpdateNoteIcon = Musician.Plater.UpdateNoteIcon
		hooksecurefunc(Plater, 'UpdatePlateText', Musician.Plater.UpdateNoteIcon)
	end
end

--- Update note icon next to player name
-- @param namePlate (Frame)
function Musician.Plater.UpdateNoteIcon(namePlate)
	local currentUnitNameString = namePlate.CurrentUnitNameString
	local otherUnitNameString = namePlate.CurrentUnitNameString == namePlate.unitName and namePlate.ActorNameSpecial or
		namePlate.unitName
	Musician.NamePlates.AddNoteIcon(namePlate, currentUnitNameString)
	if otherUnitNameString and otherUnitNameString.noteIcon then
		otherUnitNameString.noteIcon:Hide()
	end
end