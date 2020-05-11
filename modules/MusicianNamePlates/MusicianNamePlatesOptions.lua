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

--- Return default options
-- @return (table)
Musician.NamePlates.Options.GetDefaults = function()
	return {
		showNamePlateIcon = true,
		hideNamePlateBars = true,
		cinematicMode = true,
		cinematicModeNamePlates = false,
	}
end

--- Set default options
--
Musician.NamePlates.Options.Defaults = function()
	MusicianOptionsPanelUnitNamePlatesEnable:SetChecked(true)
	ExecuteFrameScript(MusicianOptionsPanelUnitNamePlatesEnable, "OnClick", "LeftButton")
	setCVarBool("nameplateShowFriendlyNPCs", false)
	Musician_Settings = Mixin(Musician_Settings, Musician.NamePlates.Options.GetDefaults())
end
hooksecurefunc(Musician.Options, "Defaults", Musician.NamePlates.Options.Defaults)

--- Refresh checkboxes based on actual values
--
Musician.NamePlates.Options.RefreshCheckboxes = function()
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

--- Refresh panel and store old values
--
Musician.NamePlates.Options.Refresh = function()

	local binding = GetBindingKey("TOGGLEUI")
	if binding then
		MusicianOptionsPanelUnitNamePlatesCinematicModeText:SetText(string.gsub(Musician.Msg.OPTIONS_CINEMATIC_MODE, '{binding}', binding))
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

-- Refresh panel when CVar changed
--
MusicianOptionsPanelUnitNamePlates:RegisterEvent("CVAR_UPDATE")
MusicianOptionsPanelUnitNamePlates:SetScript("OnEvent", function(event, ...)
	Musician.NamePlates.Options.RefreshCheckboxes()
end)

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
Musician.NamePlates.Options.Save = function(fromButton)
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