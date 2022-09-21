--- Nameplate and animation options
-- @module Musician.NamePlates.Options

Musician.NamePlates.Options = {}

local MODULE_NAME = "NamePlates.Options"
Musician.AddModule(MODULE_NAME)

-- WoW Classic polyfills
local C_CVar = _G["C_CVar"] or {
	GetCVarBool = GetCVarBool
}

-- Previous settings to be restored restore when Cancel is pressed
local oldSettings = {}

-- True when a CVar is being set by SetCVarSafe
local isSettingCVar = false

-- Disable the SetCVar hook when true
-- This is needed when setting several CVars within the same action
local disableSetCVarHook = false

--- Set a CVar (can be safely used in combat and doesn't refresh checkboxes)
-- @param name (string)
-- @param value (string)
local function SetCVarSafe(name, value)
	if InCombatLockdown() then
		C_Timer.After(1, function() SetCVarSafe(name, value) end)
		return
	end
	isSettingCVar = true
	SetCVar(name, value)
	isSettingCVar = false
end

--- Options panel initialization
--
function Musician.NamePlates.Options.Init()
	-- Refresh relevant panel elements when a CVar was changed externally
	hooksecurefunc(C_CVar, "SetCVar", function(name)
		if disableSetCVarHook or isSettingCVar then
			return
		end
		if name == "nameplateShowAll" or name == "nameplateShowFriends" then
			MusicianOptionsPanelUnitNamePlatesEnable:SetChecked(C_CVar.GetCVarBool("nameplateShowAll") and
				C_CVar.GetCVarBool("nameplateShowFriends"))
			if MusicianOptionsPanelUnitNamePlatesEnable:IsVisible() then
				ExecuteFrameScript(MusicianOptionsPanelUnitNamePlatesEnable, "OnClick", "LeftButton")
			end
		elseif name == "nameplateShowFriendlyNPCs" then
			MusicianOptionsPanelUnitNamePlatesHideNPCs:SetChecked(not C_CVar.GetCVarBool("nameplateShowFriendlyNPCs"))
		end
	end)

	-- Section title and text
	MusicianOptionsPanelUnitNamePlatesTitle:SetText(Musician.Msg.OPTIONS_CATEGORY_NAMEPLATES)
	MusicianOptionsPanelUnitNamePlatesSubText:SetText(Musician.Msg.OPTIONS_CATEGORY_NAMEPLATES_SUB_TEXT)

	-- Animated demo image
	MusicianOptionsPanelUnitNamePlatesImage.fps = 30
	MusicianOptionsPanelUnitNamePlatesImage.width = 1024
	MusicianOptionsPanelUnitNamePlatesImage.height = 1024
	MusicianOptionsPanelUnitNamePlatesImage.tileWidth = 128
	MusicianOptionsPanelUnitNamePlatesImage.tileHeight = 256
	MusicianOptionsPanelUnitNamePlatesImage.textureFile = "Interface\\AddOns\\Musician\\ui\\textures\\nameplates-demo.blp"

	-- Enable checkbox
	Musician.Options.SetupCheckbox(
		MusicianOptionsPanelUnitNamePlatesEnable,
		Musician.Msg.OPTIONS_ENABLE_NAMEPLATES)
	MusicianOptionsPanelUnitNamePlatesEnable:HookScript("OnClick", function(self)
		-- Enable nameplates
		disableSetCVarHook = true
		SetCVarSafe("nameplateShowAll", self:GetChecked())
		if InterfaceOptionsNamesPanelUnitNameplatesShowAll then
			InterfaceOptionsNamesPanelUnitNameplatesShowAll:SetChecked(self:GetChecked())
			ExecuteFrameScript(InterfaceOptionsNamesPanelUnitNameplatesShowAll, "OnClick", "LeftButton")
		end

		-- Enable more settings when nameplates are enabled to make sure they are always visible
		if self:GetChecked() then
			-- Enable nameplates for friends and enemies and disable nameplate motion.
			SetCVarSafe("nameplateShowFriends", true)
			SetCVarSafe("nameplateShowEnemies", true)
			SetCVarSafe("nameplateMotion", 0)
			if InterfaceOptionsNamesPanelUnitNameplatesFriends then
				InterfaceOptionsNamesPanelUnitNameplatesFriends:SetChecked(true)
				ExecuteFrameScript(InterfaceOptionsNamesPanelUnitNameplatesFriends, "OnClick", "LeftButton")
			end
			if InterfaceOptionsNamesPanelUnitNameplatesEnemies then
				InterfaceOptionsNamesPanelUnitNameplatesEnemies:SetChecked(true)
				ExecuteFrameScript(InterfaceOptionsNamesPanelUnitNameplatesEnemies, "OnClick", "LeftButton")
			end
			if InterfaceOptionsNamesPanelUnitNameplatesMotionDropDown then
				InterfaceOptionsNamesPanelUnitNameplatesMotionDropDown:SetValue(0)
			end
		end
		disableSetCVarHook = false
	end)

	-- Show icon checkbox
	Musician.Options.SetupCheckbox(
		MusicianOptionsPanelUnitNamePlatesShowIcon,
		string.gsub(Musician.Msg.OPTIONS_SHOW_NAMEPLATE_ICON, '{icon}', Musician.Utils.GetChatIcon(Musician.IconImages.Note)),
		MusicianOptionsPanelUnitNamePlatesEnable)
	MusicianOptionsPanelUnitNamePlatesShowIcon:HookScript("OnClick", function()
		Musician.NamePlates.Options.Save(true)
	end)

	-- Hide nameplate bars checkbox
	Musician.Options.SetupCheckbox(
		MusicianOptionsPanelUnitNamePlatesHideNamePlateBars,
		Musician.Msg.OPTIONS_HIDE_HEALTH_BARS,
		MusicianOptionsPanelUnitNamePlatesEnable)
	MusicianOptionsPanelUnitNamePlatesHideNamePlateBars:HookScript("OnClick", function()
		Musician.NamePlates.Options.Save(true)
	end)

	-- Hide NPCs checkbox
	Musician.Options.SetupCheckbox(
		MusicianOptionsPanelUnitNamePlatesHideNPCs,
		Musician.Msg.OPTIONS_HIDE_NPC_NAMEPLATES,
		MusicianOptionsPanelUnitNamePlatesEnable)
	MusicianOptionsPanelUnitNamePlatesHideNPCs:HookScript("OnClick", function()
		Musician.NamePlates.Options.Save(true)
	end)

	-- Cinematic mode checkbox
	Musician.Options.SetupCheckbox(
		MusicianOptionsPanelUnitNamePlatesCinematicMode,
		Musician.NamePlates.Options.GetCinematicModeLabel(),
		MusicianOptionsPanelUnitNamePlatesEnable)
	MusicianOptionsPanelUnitNamePlatesCinematicMode:HookScript("OnClick", function()
		Musician.NamePlates.Options.Save(true)
	end)
	MusicianOptionsPanelUnitNamePlatesCinematicMode:HookScript("OnShow", function(self)
		self.Text:SetText(Musician.NamePlates.Options.GetCinematicModeLabel())
		self:SetHitRectInsets(0, -self.Text:GetWidth(), 0, 0)
	end)

	-- Cinematic mode nameplates checkbox
	Musician.Options.SetupCheckbox(
		MusicianOptionsPanelUnitNamePlatesCinematicModeNamePlates,
		Musician.Msg.OPTIONS_NAMEPLATES_CINEMATIC_MODE,
		MusicianOptionsPanelUnitNamePlatesEnable,
		MusicianOptionsPanelUnitNamePlatesCinematicMode)
	MusicianOptionsPanelUnitNamePlatesCinematicModeNamePlates:HookScript("OnClick", function()
		Musician.NamePlates.Options.Save(true)
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
	SetCVarSafe("nameplateShowFriendlyNPCs", false)
	Musician_Settings = Mixin(Musician_Settings, Musician.NamePlates.Options.GetDefaults())
end

hooksecurefunc(Musician.Options, "Defaults", Musician.NamePlates.Options.Defaults)

--- Refresh checkboxes based on actual values
--
function Musician.NamePlates.Options.RefreshCheckboxes()
	MusicianOptionsPanelUnitNamePlatesEnable:SetChecked(C_CVar.GetCVarBool("nameplateShowAll") and
		C_CVar.GetCVarBool("nameplateShowFriends"))
	MusicianOptionsPanelUnitNamePlatesShowIcon:SetChecked(Musician_Settings.showNamePlateIcon)
	MusicianOptionsPanelUnitNamePlatesHideNamePlateBars:SetChecked(Musician_Settings.hideNamePlateBars)
	MusicianOptionsPanelUnitNamePlatesHideNPCs:SetChecked(not C_CVar.GetCVarBool("nameplateShowFriendlyNPCs"))
	MusicianOptionsPanelUnitNamePlatesCinematicMode:SetChecked(Musician_Settings.cinematicMode)
	MusicianOptionsPanelUnitNamePlatesCinematicModeNamePlates:SetChecked(Musician_Settings.cinematicModeNamePlates)
end

--- Get text label for cinematic mode
-- @return label (string)
function Musician.NamePlates.Options.GetCinematicModeLabel()
	local binding = GetBindingKey("TOGGLEUI")
	if binding then
		local label = string.gsub(Musician.Msg.OPTIONS_CINEMATIC_MODE, '{binding}', binding)
		return label
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
function Musician.NamePlates.Options.Cancel()
	SetCVarSafe("nameplateShowFriendlyNPCs", oldSettings.nameplateShowFriendlyNPCs)
	Musician_Settings.showNamePlateIcon = oldSettings.showNamePlateIcon
	Musician_Settings.hideNamePlateBars = oldSettings.hideNamePlateBars
	Musician_Settings.cinematicMode = oldSettings.cinematicMode
	Musician_Settings.cinematicModeNamePlates = oldSettings.cinematicModeNamePlates
	Musician.NamePlates.UpdateAll()
	MusicianOptionsPanelUnitNamePlatesImage:Hide()
end

hooksecurefunc(Musician.Options, "Cancel", Musician.NamePlates.Options.Cancel)

--- Save values
--
function Musician.NamePlates.Options.Save(fromButton)
	SetCVarSafe("nameplateShowFriendlyNPCs", not MusicianOptionsPanelUnitNamePlatesHideNPCs:GetChecked())
	Musician_Settings.showNamePlateIcon = MusicianOptionsPanelUnitNamePlatesShowIcon:GetChecked()
	Musician_Settings.hideNamePlateBars = MusicianOptionsPanelUnitNamePlatesHideNamePlateBars:GetChecked()
	Musician_Settings.cinematicMode = MusicianOptionsPanelUnitNamePlatesCinematicMode:GetChecked()
	Musician_Settings.cinematicModeNamePlates = MusicianOptionsPanelUnitNamePlatesCinematicModeNamePlates:GetChecked()
	Musician.NamePlates.UpdateAll()
	if not fromButton then
		MusicianOptionsPanelUnitNamePlatesImage:Hide()
	end
end

hooksecurefunc(Musician.Options, "Save", Musician.NamePlates.Options.Save)