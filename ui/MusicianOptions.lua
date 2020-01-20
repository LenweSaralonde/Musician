--- Musician options panel
-- @module Musician.Options

Musician.Options = {}

local MODULE_NAME = "Options"
Musician.AddModule(MODULE_NAME)

--- Options panel initialization
--
function Musician.Options.Init()
	local panel = MusicianOptionsPanelContainer
	panel.name = Musician.Msg.OPTIONS_TITLE
	panel.refresh = Musician.Options.Refresh
	panel.okay = Musician.Options.Save
	panel.cancel = Musician.Options.Cancel
	panel.default = Musician.Options.Defaults
	MusicianOptionsPanelContainer:SetScript("OnShow", Musician.Options.UpdateSize)
	InterfaceOptions_AddCategory(MusicianOptionsPanelContainer)
end

--- Show Musician's option panel
--
function Musician.Options.Show()
	InterfaceOptionsFrame_Show() -- This one has to be opened first
	InterfaceOptionsFrame_OpenToCategory(MusicianOptionsPanelContainer)
end

function Musician.Options.Refresh()
	MusicianOptionsPanelUnitEmoteEnable:SetChecked(Musician_Settings.enableEmote)
	MusicianOptionsPanelUnitEmoteEnablePromo:SetChecked(Musician_Settings.enableEmotePromo)
	if Musician_Settings.enableEmote then -- SetEnabled() can't be used here since Enable and Disable are extended
		MusicianOptionsPanelUnitEmoteEnablePromo:Enable()
	else
		MusicianOptionsPanelUnitEmoteEnablePromo:Disable()
	end
end

function Musician.Options.Defaults()
	Musician_Settings.enableEmote = true
	Musician_Settings.enableEmotePromo = true
end

function Musician.Options.Cancel()

end

function Musician.Options.Save()
	Musician_Settings.enableEmote = MusicianOptionsPanelUnitEmoteEnable:GetChecked()
	Musician_Settings.enableEmotePromo = MusicianOptionsPanelUnitEmoteEnablePromo:GetChecked()
	Musician_Settings.emoteHintShown = true
end

--- Update the size of the Musician option panel
--
function Musician.Options.UpdateSize()
	local panel = MusicianOptionsPanel
	panel:SetWidth(panel:GetParent():GetWidth())

	local relativeFrame = MusicianOptionsPanelSubText
	local height = 0
	local child
	for _, child in ipairs({ panel:GetChildren() }) do
		if child:IsVisible() then
			child:ClearAllPoints()
			child:SetPoint("TOPLEFT", relativeFrame, "BOTTOMLEFT", 0, -10)
			height = height + child:GetHeight()
			relativeFrame = child
		end
	end

	panel:SetHeight(height)
end