Musician.Options = {}

--- Options panel initialization
--
function Musician.Options.Init()
	local panel = MusicianOptionsPanel
	panel.name = Musician.Msg.OPTIONS_TITLE
	panel.refresh = Musician.Options.Refresh
	panel.okay = Musician.Options.Save
	panel.cancel = Musician.Options.Cancel
	panel.default = Musician.Options.Defaults
	InterfaceOptions_AddCategory(panel)
end

--- Show Musician's option panel
--
function Musician.Options.Show()
	InterfaceOptionsFrame_Show() -- This one has to be opened first
	InterfaceOptionsFrame_OpenToCategory(MusicianOptionsPanel)
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
