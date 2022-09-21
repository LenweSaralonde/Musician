--- Options for Maps integration
-- @module Musician.Map.Options

Musician.Map.Options = {}

local MODULE_NAME = "Map.Options"
Musician.AddModule(MODULE_NAME)

local oldSettings = {}

--- Return default options
-- @return (table)
function Musician.Map.Options.GetDefaults()
	return {
		worldMap = true,
		miniMap = true,
	}
end

--- Set default options
--
function Musician.Map.Options.Defaults()
	local defaults = Musician.Map.Options.GetDefaults()
	Musician.Map.SetWorldMapTracking(defaults.worldMap)
	Musician.Map.SetMiniMapTracking(defaults.miniMap)
	Musician.Map.Options.RefreshCheckboxes()
end

hooksecurefunc(Musician.Options, "Defaults", Musician.Map.Options.Defaults)

--- Refresh checkboxes based on actual values
--
function Musician.Map.Options.RefreshCheckboxes()
	MusicianOptionsPanelMapWorldMap:SetChecked(Musician.Map.GetWorldMapTracking())
	MusicianOptionsPanelMapMiniMap:SetChecked(Musician.Map.GetMiniMapTracking())
end

--- Refresh panel and store old values
--
function Musician.Map.Options.Refresh()
	oldSettings = {
		worldMap = Musician.Map.GetWorldMapTracking(),
		miniMap = Musician.Map.GetMiniMapTracking(),
	}
	Musician.Map.Options.RefreshCheckboxes()
end

hooksecurefunc(Musician.Options, "Refresh", Musician.Map.Options.Refresh)

-- Restore previous values on cancel
--
hooksecurefunc(Musician.Options, "Cancel", function()
	Musician.Map.SetWorldMapTracking(oldSettings.worldMap)
	Musician.Map.SetMiniMapTracking(oldSettings.miniMap)
end)

--- Save values
--
function Musician.Map.Options.Save()
	Musician.Map.SetWorldMapTracking(MusicianOptionsPanelMapWorldMap:GetChecked())
	Musician.Map.SetMiniMapTracking(MusicianOptionsPanelMapMiniMap:GetChecked())
end

hooksecurefunc(Musician.Options, "Save", Musician.Map.Options.Save)

--- OnLoad
--
function MusicianOptionsPanelMap_OnLoad()
	MusicianOptionsPanelMapTitle:SetText(Musician.Msg.MAP_OPTIONS_TITLE)
	MusicianOptionsPanelMapSubText:SetText(Musician.Msg.MAP_OPTIONS_SUB_TEXT)

	Musician.Options.SetupCheckbox(MusicianOptionsPanelMapMiniMap, Musician.Msg.MAP_OPTIONS_MINI_MAP)
	MusicianOptionsPanelMapMiniMap:HookScript("OnClick", function()
		Musician.Map.Options.Save(true)
	end)

	Musician.Options.SetupCheckbox(MusicianOptionsPanelMapWorldMap, Musician.Msg.MAP_OPTIONS_WORLD_MAP)
	MusicianOptionsPanelMapWorldMap:HookScript("OnClick", function()
		Musician.Map.Options.Save(true)
	end)
end