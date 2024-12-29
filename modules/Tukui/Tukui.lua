--- Tukui integration
-- @module Musician.Tukui

Musician.Tukui = LibStub("AceAddon-3.0"):NewAddon("Musician.Tukui", "AceEvent-3.0")

local MODULE_NAME = "Tukui"
Musician.AddModule(MODULE_NAME)

local function updateTukuiNameplate(namePlate)
	-- Tukui's custom frame is actually "unitFrame"
	if namePlate and namePlate.unitFrame and namePlate.unitFrame.Name and namePlate.unitFrame.isNamePlate then
		Musician.NamePlates.AddNoteIcon(namePlate, namePlate.unitFrame.Name, true)
	end
end

local function hookOUF_NamePlateDriver()
	if oUF_NamePlateDriver and not oUF_NamePlateDriver.isHookedByMusician then
		oUF_NamePlateDriver.isHookedByMusician = true
		_G.oUF_NamePlateDriver:HookScript('OnEvent', function(_, event, unit)
			if(event == 'NAME_PLATE_UNIT_ADDED' and unit) then
				updateTukuiNameplate(C_NamePlate.GetNamePlateForUnit(unit))
			end
		end)
	end
end

--- OnEnable
--
function Musician.Tukui:OnEnable()
	if Tukui then
		Musician.Utils.Debug(MODULE_NAME, "Tukui detected.")

		-- Disable incompatible features
		Musician.NamePlates.ForbidHideHealthBars()

		local T = unpack(Tukui)

		-- Check Tukui prerequisites
		if T.UnitFrames == nil or T.UnitFrames.Highlight == nil or T.UnitFrames.CreateUnits == nil then
			Musician.Utils.Debug(MODULE_NAME, "Could not hook Tukui functions.")
			return
		end

		-- Add musical note icon next to player name when the nameplate gets initialized by Tukui
		hooksecurefunc(T.UnitFrames, 'CreateUnits', hookOUF_NamePlateDriver)
		hookOUF_NamePlateDriver()
		-- Add musical note icon next to player name when the nameplate gets updated by Tukui
		hooksecurefunc(T.UnitFrames, 'Highlight', function(frame)
			updateTukuiNameplate(frame:GetParent())
		end)

		-- Update the note icon when the nameplate gets updated by MusicianNamePlates
		hooksecurefunc(Musician.NamePlates, "UpdateNoteIcon", updateTukuiNameplate)

		Musician.Utils.Debug(MODULE_NAME, "Tukui module initialized.")
	end
end
