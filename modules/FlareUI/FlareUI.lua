--- Add note icons to FlareUI nameplates (7.0.1+ handles name visibility).
-- @module Musician.FlareUI

Musician.FlareUI = LibStub("AceAddon-3.0"):NewAddon("Musician.FlareUI", "AceEvent-3.0")
Musician.AddModule("FlareUI")

function Musician.FlareUI:OnEnable()
	local plates = FlareUI and FlareUI.Nameplates
	if not (plates and plates.UpdateName and plates.PartsFor) then return end

	local names = Musician.NamePlates
	local redrawing
	local function update(parts)
		local plate = parts.gamePlate
		if not plate or plate:IsForbidden() or plates.PartsFor(plate) ~= parts then return end
		if parts.nameSlot then
			-- A pooled label can stay secret after FlareUI writes a readable name.
			-- Let the owner restore the exact text (including its formatted level).
			if not canaccessvalue(parts.name:GetText()) then
				local name = UnitName(parts.unit)
				if not canaccessvalue(name) or not name then return end
				parts.name:ClearText()
				redrawing = parts
				local ok, err = pcall(plates.UpdateName, parts)
				redrawing = nil
				if not ok then error(err) end
			end
			names.AddNoteIcon(plate, parts.name, false, true)
		end
	end

	local function refresh(plate)
		local parts = plates.PartsFor(plate)
		if parts then update(parts) end
	end

	local function onNameUpdated(parts)
		local plate = parts.gamePlate
		if redrawing == parts or not plate or plate:IsForbidden() or plates.PartsFor(plate) ~= parts then return end
		-- The add event may predate Musician, and FlareUI can claim the plate after
		-- our startup scan (for example, after a combat reload).
		local isPlayer = UnitIsPlayer(parts.unit)
		if canaccessvalue(isPlayer) and isPlayer then
			local player = Musician.Utils.GetUnitName(parts.unit)
			if player and player ~= UNKNOWN and names.playerNamePlates[Musician.Utils.NormalizePlayerName(player)] ~= plate
				and C_NamePlate.GetNamePlateForUnit(parts.unit) == plate then
				names.OnNamePlateAdded("NAME_PLATE_UNIT_ADDED", parts.unit)
			end
		end
		update(parts)
	end

	hooksecurefunc(plates, "UpdateName", onNameUpdated)
	hooksecurefunc(names, "UpdateNoteIcon", refresh)
	self:RegisterMessage(Musician.Registry.event.playerUnregistered, function(_, player)
		local plate = names.playerNamePlates[player]
		if plate then refresh(plate) end
	end)

	for _, plate in pairs(C_NamePlate.GetNamePlates()) do
		local parts = plates.PartsFor(plate)
		if parts then onNameUpdated(parts) end
	end
end
