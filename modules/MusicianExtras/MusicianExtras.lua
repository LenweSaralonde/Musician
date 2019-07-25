Musician.Extras = LibStub("AceAddon-3.0"):NewAddon("Musician.Extras")

local MODULE_NAME = "Extras"
Musician.AddModule(MODULE_NAME)

--- OnEnable
--
function Musician.Extras:OnEnable()
	Musician.ShowTipsAndTricks()
end