Musician.KuiNamePlates = LibStub("AceAddon-3.0"):NewAddon("Musician.KuiNamePlates", "AceEvent-3.0")

local MODULE_NAME = "KuiNamePlates"
Musician.AddModule(MODULE_NAME)

--- OnEnable
--
function Musician.KuiNamePlates:OnEnable()
	hooksecurefunc(Musician.NamePlates, "updateNamePlateIcons", function(namePlate)
		if namePlate.kui and namePlate.kui.NameText then
			Musician.NamePlates.updateNoteIcon(namePlate, namePlate.kui, namePlate.kui.NameText)
		end
	end)

	hooksecurefunc(Musician.NamePlates, "AttachNamePlate", function(namePlate, player)
		if namePlate.kui and namePlate.musicianAnimatedNotesFrame then
			namePlate.kui:SetFrameLevel(100)
			namePlate.musicianAnimatedNotesFrame:SetParent(namePlate.kui)
			namePlate.musicianAnimatedNotesFrame:SetFrameLevel(0)
		end
	end)
end
