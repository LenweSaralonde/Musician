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
	InterfaceOptions_AddCategory(MusicianOptionsPanelContainer)
end

--- Show Musician's option panel
--
function Musician.Options.Show()
	InterfaceOptionsFrame_Show() -- This one has to be opened first
	InterfaceOptionsFrame_OpenToCategory(MusicianOptionsPanelContainer)
	C_Timer.After(.0001, Musician.Options.UpdateSize)
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
	local height = 0
	local child
	for _, child in ipairs({ panel:GetChildren() }) do
		height = height + child:GetHeight()
	end

	panel:SetHeight(height)
end

--- Append options frame to the Musician option panel
-- @param frame (Frame)
function Musician.Options.Append(frame)
	local panel = MusicianOptionsPanel
	local lastChild = select(-2, panel:GetChildren())
	frame:ClearAllPoints()
	frame:SetPoint("TOPLEFT", lastChild, "BOTTOMLEFT", 0, -10)
	Musician.Options.UpdateSize()
end