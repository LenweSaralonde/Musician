--- Options for Total RP 3 integration
-- @module Musician.TRP3.Options

Musician.TRP3.Options = {}

local MODULE_NAME = "TRP3.Options"
Musician.AddModule(MODULE_NAME)

local oldSettings = {}

--- Return default options
-- @return (table)
Musician.TRP3.Options.GetDefaults = function()
	return {
		trp3MapScan = true,
	}
end

--- Set default options
--
Musician.TRP3.Options.Defaults = function()
	Musician_Settings = Mixin(Musician_Settings, Musician.TRP3.Options.GetDefaults())
	Musician.TRP3.Options.RefreshCheckboxes()
end
hooksecurefunc(Musician.Options, "Defaults", Musician.TRP3.Options.Defaults)

--- Refresh checkboxes based on actual values
--
Musician.TRP3.Options.RefreshCheckboxes = function()
	MusicianOptionsPanelTRP3MapScan:SetChecked(Musician_Settings.trp3MapScan)
end

--- Refresh panel and store old values
--
Musician.TRP3.Options.Refresh = function()
	oldSettings = {
		trp3MapScan = Musician_Settings.trp3MapScan,
	}
	Musician.TRP3.Options.RefreshCheckboxes()

	-- Hide block if TRP3 is not enabled
	if not(TRP3_API) then
		MusicianOptionsPanelTRP3:Hide()
		Musician.Options.UpdateSize()
	end
end
hooksecurefunc(Musician.Options, "Refresh", Musician.TRP3.Options.Refresh)

-- Restore previous values on cancel
--
hooksecurefunc(Musician.Options, "Cancel", function()
	Musician_Settings.trp3MapScan = oldSettings.trp3MapScan
end)

--- Save values
--
Musician.TRP3.Options.Save = function(fromButton)
	Musician_Settings.trp3MapScan = MusicianOptionsPanelTRP3MapScan:GetChecked()
end
hooksecurefunc(Musician.Options, "Save", Musician.TRP3.Options.Save)