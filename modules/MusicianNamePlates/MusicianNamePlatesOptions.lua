--- Nameplate and animation options
-- @module Musician.NamePlates.Options

Musician.NamePlates.Options = {}

local MODULE_NAME = "NamePlates.Options"
Musician.AddModule(MODULE_NAME)

-- WoW Classic polyfills
local C_CVar = _G["C_CVar"] or {
	GetCVarBool = GetCVarBool
}

local oldSettings = {}

--- Set a boolean CVar
-- @param name (string)
-- @param value (string)
local function setCVarBool(name, value)
	if InCombatLockdown() then
		C_Timer.After(1, function() setCVarBool(name, value) end)
		return
	end

	SetCVar(name, value and "1" or "0")
end

Musician.NamePlates.Options.SetCVarBool = setCVarBool

--- Options panel initialization
--
function Musician.NamePlates.Options.Init()
	-- Refresh panel when CVar changed
	MusicianOptionsPanelUnitNamePlates:RegisterEvent("CVAR_UPDATE")
	MusicianOptionsPanelUnitNamePlates:SetScript("OnEvent", function(event, ...)
		Musician.NamePlates.Options.RefreshCheckboxes()
	end)
end
hooksecurefunc(Musician.Options, "Init", Musician.NamePlates.Options.Init)

--- Return default options
-- @return (table)
function Musician.NamePlates.Options.GetDefaults()
	return {
		showNamePlateIcon = true,
		hideNamePlateBars = true,
		cinematicMode = true,
		cinematicModeNamePlates = false,
	}
end

--- Set default options
--
function Musician.NamePlates.Options.Defaults()
	MusicianOptionsPanelUnitNamePlatesEnable:SetChecked(true)
	ExecuteFrameScript(MusicianOptionsPanelUnitNamePlatesEnable, "OnClick", "LeftButton")
	setCVarBool("nameplateShowFriendlyNPCs", false)
	Musician_Settings = Mixin(Musician_Settings, Musician.NamePlates.Options.GetDefaults())
end
hooksecurefunc(Musician.Options, "Defaults", Musician.NamePlates.Options.Defaults)

--- Refresh checkboxes based on actual values
--
function Musician.NamePlates.Options.RefreshCheckboxes()
	local enable = C_CVar.GetCVarBool("nameplateShowAll") and C_CVar.GetCVarBool("nameplateShowFriends")
	local showIcon = Musician_Settings.showNamePlateIcon
	local hideNamePlateBars = Musician_Settings.hideNamePlateBars
	local hideNPCs = not(C_CVar.GetCVarBool("nameplateShowFriendlyNPCs"))

	MusicianOptionsPanelUnitNamePlatesEnable:SetChecked(enable)
	MusicianOptionsPanelUnitNamePlatesShowIcon:SetChecked(showIcon)
	MusicianOptionsPanelUnitNamePlatesHideNamePlateBars:SetChecked(hideNamePlateBars)
	MusicianOptionsPanelUnitNamePlatesHideNPCs:SetChecked(hideNPCs)

	if enable then -- SetEnabled() can't be used here since Enable and Disable are extended
		MusicianOptionsPanelUnitNamePlatesShowIcon:Enable()
		MusicianOptionsPanelUnitNamePlatesHideNamePlateBars:Enable()
		MusicianOptionsPanelUnitNamePlatesHideNPCs:Enable()
		MusicianOptionsPanelUnitNamePlatesCinematicMode:Enable()
	else
		MusicianOptionsPanelUnitNamePlatesShowIcon:Disable()
		MusicianOptionsPanelUnitNamePlatesHideNamePlateBars:Disable()
		MusicianOptionsPanelUnitNamePlatesHideNPCs:Disable()
		MusicianOptionsPanelUnitNamePlatesCinematicMode:Disable()
	end

	MusicianOptionsPanelUnitNamePlatesCinematicMode:SetChecked(Musician_Settings.cinematicMode)
	MusicianOptionsPanelUnitNamePlatesCinematicModeNamePlates:SetChecked(Musician_Settings.cinematicModeNamePlates)

	if Musician_Settings.cinematicMode and enable then
		MusicianOptionsPanelUnitNamePlatesCinematicModeNamePlates:Enable()
	else
		MusicianOptionsPanelUnitNamePlatesCinematicModeNamePlates:Disable()
	end
end

--- Get text label for cinematic mode
-- @return label (string)
function Musician.NamePlates.Options.GetCinematicModeLabel()
	local binding = GetBindingKey("TOGGLEUI")
	if binding then
		return string.gsub(Musician.Msg.OPTIONS_CINEMATIC_MODE, '{binding}', binding)
	else
		return Musician.Msg.OPTIONS_CINEMATIC_MODE_NO_BINDING
	end
end

--- Refresh panel and store old values
--
function Musician.NamePlates.Options.Refresh()

	local binding = GetBindingKey("TOGGLEUI")
	if binding then
		MusicianOptionsPanelUnitNamePlatesCinematicModeText:SetText(Musician.NamePlates.Options.GetCinematicModeLabel())
	end

	oldSettings = {
		nameplateShowFriendlyNPCs = C_CVar.GetCVarBool("nameplateShowFriendlyNPCs"),
		showNamePlateIcon = Musician_Settings.showNamePlateIcon,
		hideNamePlateBars = Musician_Settings.hideNamePlateBars,
		cinematicMode = Musician_Settings.cinematicMode,
		cinematicModeNamePlates = Musician_Settings.cinematicModeNamePlates,
	}
	Musician.NamePlates.Options.RefreshCheckboxes()
	MusicianOptionsPanelUnitNamePlatesImage:Show()
end
hooksecurefunc(Musician.Options, "Refresh", Musician.NamePlates.Options.Refresh)

-- Restore previous values on cancel
--
hooksecurefunc(Musician.Options, "Cancel", function()
	setCVarBool("nameplateShowFriendlyNPCs", oldSettings.nameplateShowFriendlyNPCs)
	Musician_Settings.showNamePlateIcon = oldSettings.showNamePlateIcon
	Musician_Settings.hideNamePlateBars = oldSettings.hideNamePlateBars
	Musician_Settings.cinematicMode = oldSettings.cinematicMode
	Musician_Settings.cinematicModeNamePlates = oldSettings.cinematicModeNamePlates
	Musician.NamePlates.UpdateAll()
	MusicianOptionsPanelUnitNamePlatesImage:Hide()
end)

--- Save values
--
function Musician.NamePlates.Options.Save(fromButton)
	setCVarBool("nameplateShowFriendlyNPCs", not(MusicianOptionsPanelUnitNamePlatesHideNPCs:GetChecked()))
	Musician_Settings.showNamePlateIcon = MusicianOptionsPanelUnitNamePlatesShowIcon:GetChecked()
	Musician_Settings.hideNamePlateBars = MusicianOptionsPanelUnitNamePlatesHideNamePlateBars:GetChecked()
	Musician_Settings.cinematicMode = MusicianOptionsPanelUnitNamePlatesCinematicMode:GetChecked()
	Musician_Settings.cinematicModeNamePlates = MusicianOptionsPanelUnitNamePlatesCinematicModeNamePlates:GetChecked()
	Musician.NamePlates.UpdateAll()
	if not(fromButton) then
		MusicianOptionsPanelUnitNamePlatesImage:Hide()
	end
end
hooksecurefunc(Musician.Options, "Save", Musician.NamePlates.Options.Save)