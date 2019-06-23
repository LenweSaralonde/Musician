Musician.Plater = LibStub("AceAddon-3.0"):NewAddon("Musician.Plater", "AceEvent-3.0")

--- OnEnable
--
function Musician.Plater:OnEnable()
	hooksecurefunc(Musician.NamePlates, "updateNamePlateIcons", function(namePlate)
		if namePlate.ActorNameSpecial then
			Musician.NamePlates.updateNoteIcon(namePlate, namePlate, namePlate.ActorNameSpecial)
		end
	end)
end
