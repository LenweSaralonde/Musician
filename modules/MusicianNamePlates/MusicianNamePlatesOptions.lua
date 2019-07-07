Musician.NamePlates.Options = {}

local MODULE_NAME = "NamePlates.Options"
Musician.AddModule(MODULE_NAME)

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

--- Set default options
--
Musician.NamePlates.Options.Defaults = function()
	Musician_Settings.hideHealthBars = false
end
hooksecurefunc(Musician.Options, "Defaults", Musician.NamePlates.Options.Defaults)

--- Refresh checkboxes based on actual values
--
Musician.NamePlates.Options.RefreshCheckboxes = function()
	local enable = C_CVar.GetCVarBool("nameplateShowAll") and C_CVar.GetCVarBool("nameplateShowFriends")
	local hideNamePlateBars = Musician_Settings.hideNamePlateBars
	local hideNPCs = not(C_CVar.GetCVarBool("nameplateShowFriendlyNPCs"))

	MusicianOptionsPanelUnitNamePlatesEnable:SetChecked(enable)
	MusicianOptionsPanelUnitNamePlatesHideNamePlateBars:SetChecked(hideNamePlateBars)
	MusicianOptionsPanelUnitNamePlatesHideNPCs:SetChecked(hideNPCs)

	if enable then -- SetEnabled() can't be used here since Enable and Disable are extended
		MusicianOptionsPanelUnitNamePlatesHideNamePlateBars:Enable()
		MusicianOptionsPanelUnitNamePlatesHideNPCs:Enable()
	else
		MusicianOptionsPanelUnitNamePlatesHideNamePlateBars:Disable()
		MusicianOptionsPanelUnitNamePlatesHideNPCs:Disable()
	end
end

--- Refresh panel and store old values
--
Musician.NamePlates.Options.Refresh = function()
	oldSettings = {
		nameplateShowFriendlyNPCs = C_CVar.GetCVarBool("nameplateShowFriendlyNPCs"),
		hideNamePlateBars = Musician_Settings.hideNamePlateBars,
	}
	Musician.NamePlates.Options.RefreshCheckboxes()
end
hooksecurefunc(Musician.Options, "Refresh", Musician.NamePlates.Options.Refresh)

MusicianOptionsPanelUnitNamePlates:RegisterEvent("CVAR_UPDATE")
MusicianOptionsPanelUnitNamePlates:SetScript("OnEvent", function(event, ...)
	Musician.NamePlates.Options.RefreshCheckboxes()
end)

--- Restore previous values on cancel
--
hooksecurefunc(Musician.Options, "Cancel", function()
	setCVarBool("nameplateShowFriendlyNPCs", oldSettings.nameplateShowFriendlyNPCs)
	Musician_Settings.hideNamePlateBars = oldSettings.hideNamePlateBars
end)

--- Save values
--
Musician.NamePlates.Options.Save = function()
	setCVarBool("nameplateShowFriendlyNPCs", not(MusicianOptionsPanelUnitNamePlatesHideNPCs:GetChecked()))
	Musician_Settings.hideNamePlateBars = MusicianOptionsPanelUnitNamePlatesHideNamePlateBars:GetChecked()
end
hooksecurefunc(Musician.Options, "Save", Musician.NamePlates.Options.Save)