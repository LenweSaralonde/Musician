--- FlareUI integration
-- @module Musician.FlareUI

Musician.FlareUI = LibStub("AceAddon-3.0"):NewAddon("Musician.FlareUI", "AceEvent-3.0")

local MODULE_NAME = "FlareUI"
Musician.AddModule(MODULE_NAME)

-- Game nameplate -> FlareUI plate
local flarePlates = setmetatable({}, { __mode = "k" })

--- Return a stable proxy nameplate for the FlareUI plate.
-- FlareUI plates are pooled and move from one game nameplate to another, so the unit token
-- has to be resolved dynamically when Musician.NamePlates.AddNoteIcon is called from the SetText hook.
-- @param fuiPlate (table) FlareUI plate
-- @return namePlate (table)
local function getNamePlateProxy(fuiPlate)
	if not fuiPlate.musicianNamePlate then
		fuiPlate.musicianNamePlate = setmetatable({}, {
			__index = function(_, key)
				if key == "unitToken" then
					return fuiPlate.unit
				end
			end
		})
	end
	return fuiPlate.musicianNamePlate
end

--- Add the note icon to the FlareUI plate name
-- @param fuiPlate (table) FlareUI plate
local function updateFlarePlate(fuiPlate)
	if not fuiPlate or not fuiPlate.unit or not fuiPlate.gamePlate then return end
	flarePlates[fuiPlate.gamePlate] = fuiPlate
	local namePlate = getNamePlateProxy(fuiPlate)
	if fuiPlate.name then
		Musician.NamePlates.AddNoteIcon(namePlate, fuiPlate.name)
	end
	if fuiPlate.aboveName then
		Musician.NamePlates.AddNoteIcon(namePlate, fuiPlate.aboveName)
	end
end

--- OnEnable
--
function Musician.FlareUI:OnEnable()
	if FlareUI and FlareUI.Nameplates and FlareUI.Nameplates.UpdateBarName and FlareUI.Nameplates.UpdateNameAbove then
		Musician.Utils.Debug(MODULE_NAME, "FlareUI nameplates detected.")

		-- Disable incompatible features
		Musician.NamePlates.ForbidHideHealthBars()

		-- Add musical note icon next to player name when FlareUI updates it
		hooksecurefunc(FlareUI.Nameplates, "UpdateBarName", updateFlarePlate)
		hooksecurefunc(FlareUI.Nameplates, "UpdateNameAbove", updateFlarePlate)

		-- Update the note icon when the nameplate gets updated by MusicianNamePlates
		hooksecurefunc(Musician.NamePlates, "UpdateNoteIcon", function(namePlate)
			local fuiPlate = flarePlates[namePlate]
			if fuiPlate and fuiPlate.gamePlate == namePlate then
				updateFlarePlate(fuiPlate)
			end
		end)

		Musician.Utils.Debug(MODULE_NAME, "FlareUI module initialized.")
	end
end
