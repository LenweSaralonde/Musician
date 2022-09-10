--- Options for Total RP 3 integration
-- @module Musician.TRP3.Options

Musician.TRP3.Options = {}

local MODULE_NAME = "TRP3.Options"
Musician.AddModule(MODULE_NAME)

local oldSettings = {}

--- Return default options
-- @return (table)
function Musician.TRP3.Options.GetDefaults()
	return {
		trp3MapScan = true,
	}
end

--- Set default options
--
function Musician.TRP3.Options.Defaults()
	Musician_Settings = Mixin(Musician_Settings, Musician.TRP3.Options.GetDefaults())
	Musician.TRP3.Options.RefreshCheckboxes()
end
hooksecurefunc(Musician.Options, "Defaults", Musician.TRP3.Options.Defaults)

--- Refresh checkboxes based on actual values
--
function Musician.TRP3.Options.RefreshCheckboxes()
	MusicianOptionsPanelTRP3MapScan:SetChecked(Musician_Settings.trp3MapScan)
end

--- Refresh panel and store old values
--
function Musician.TRP3.Options.Refresh()
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
function Musician.TRP3.Options.Save()
	Musician_Settings.trp3MapScan = MusicianOptionsPanelTRP3MapScan:GetChecked()
end
hooksecurefunc(Musician.Options, "Save", Musician.TRP3.Options.Save)

--- OnLoad
--
function MusicianOptionsPanelTRP3_OnLoad()
	MusicianOptionsPanelTRP3Title:SetText(Musician.Msg.OPTIONS_TRP3)

	-- Map scan checkbox
	Musician.Options.SetupCheckbox(
		MusicianOptionsPanelTRP3MapScan,
		string.gsub(Musician.Msg.OPTIONS_TRP3_MAP_SCAN, "{icon}", Musician.Utils.GetChatIcon(Musician.IconImages.Note)),
		nil)
	MusicianOptionsPanelTRP3MapScan:HookScript("OnClick", function()
		Musician.TRP3.Options.Save(true)
	end)
end