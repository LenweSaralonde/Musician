--- Tips and tricks and easter eggs
-- @module Musician.Extras

Musician.Extras = LibStub("AceAddon-3.0"):NewAddon("Musician.Extras", "AceEvent-3.0")

local MODULE_NAME = "Extras"
Musician.AddModule(MODULE_NAME)

--- OnEnable
--
function Musician.Extras:OnEnable()
	-- Show tips and tricks when quick preloading is complete
	if Musician.Preloader.QuickPreloadingIsComplete() then
		Musician.ShowTipsAndTricks()
	else
		Musician.Extras:RegisterMessage(Musician.Events.QuickPreloadingComplete, Musician.ShowTipsAndTricks)
	end
end