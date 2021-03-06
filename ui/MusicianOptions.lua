--- Musician options panel
-- @module Musician.Options

Musician.Options = {}

local MODULE_NAME = "Options"
Musician.AddModule(MODULE_NAME)

local currentMuteGameMusic
local currentMuteInstrumentToys
local currentAudioConfiguration
local currentAutoAdjustAudioConfig

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
	Musician.Utils.SetInstrumentToysMuted(Musician_Settings.muteInstrumentToys)
end

--- Set up an option checkbox
-- @param checkbox (CheckButton)
-- @param labelText (string)
-- @param[opt] dependantControl (CheckButton)
-- @param[opt] dependantControl2 (CheckButton)
function Musician.Options.SetupCheckbox(checkbox, labelText, dependantControl, dependantControl2)
	local labelElement = _G[checkbox:GetName().."Text"]
	labelElement:SetText(labelText)
	checkbox:SetHitRectInsets(0, -labelElement:GetWidth(), 0, 0)
	checkbox.type = CONTROLTYPE_CHECKBOX
	checkbox.SetValue = function(checkbox, value) checkbox.newValue = value end
	checkbox.Disable = function (self)
		getmetatable(self).__index.Disable(self)
		_G[self:GetName().."Text"]:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
	end
	checkbox.Enable = function (self)
		getmetatable(self).__index.Enable(self)
		local text = _G[self:GetName().."Text"]
		local fontObject = text:GetFontObject()
		text:SetTextColor(fontObject:GetTextColor())
	end

	BlizzardOptionsPanel_RegisterControl(checkbox, checkbox:GetParent():GetParent())

	if dependantControl then
		BlizzardOptionsPanel_SetupDependentControl(dependantControl, checkbox)
		if dependantControl2 then
			BlizzardOptionsPanel_SetupDependentControl(dependantControl2, checkbox)
		end
	end
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
	MusicianOptionsPanelIntegrationMuteGameMusic:SetChecked(Musician_Settings.muteGameMusic)
	MusicianOptionsPanelIntegrationMuteInstrumentToys:SetChecked(Musician_Settings.muteInstrumentToys)
	currentMuteGameMusic = Musician_Settings.muteGameMusic
	currentMuteInstrumentToys = Musician_Settings.muteInstrumentToys
	currentAudioConfiguration = Musician.Utils.GetCurrentAudioSettings()
	currentAutoAdjustAudioConfig = Musician_Settings.autoAdjustAudioSettings
	Musician.Options.RefreshAudioSettings()
end

function Musician.Options.Defaults()
	Musician_Settings.enableEmote = true
	Musician_Settings.enableEmotePromo = true
	Musician_Settings.muteGameMusic = true
	Musician_Settings.muteInstrumentToys = true
	Musician.Utils.MuteGameMusic(true)
	Musician.Utils.SetInstrumentToysMuted(Musician_Settings.muteInstrumentToys)
	Musician_Settings.audioChannels.SFX = true
	Musician_Settings.audioChannels.Master = true
	Musician_Settings.audioChannels.Dialog = true
	Musician_Settings.autoAdjustAudioSettings = true
	Musician.Options.RefreshAudioSettings()
end

function Musician.Options.RefreshAudioSettings()
	local newAudioConfig = Musician.Utils.GetNewAudioSettings(currentAudioConfiguration)
	if Musician_Settings.autoAdjustAudioSettings then
		Musician.Utils.UpdateAudioSettings(newAudioConfig)
	end

	local audioChannels = Musician_Settings.audioChannels

	local checked = (audioChannels.SFX and 1 or 0) + (audioChannels.Master and 1 or 0) + (audioChannels.Dialog and 1 or 0)

	-- Make sure at least one channel is checked
	if checked == 0 then
		-- Check SFX if none
		audioChannels.SFX = true
		checked = 1
	end

	-- Set checkboxes
	MusicianOptionsPanelAudioChannelsSFX:SetChecked(audioChannels.SFX)
	MusicianOptionsPanelAudioChannelsMaster:SetChecked(audioChannels.Master)
	MusicianOptionsPanelAudioChannelsDialog:SetChecked(audioChannels.Dialog)
	MusicianOptionsPanelAudioChannelsAutoAdjust:SetChecked(Musician_Settings.autoAdjustAudioSettings)

	-- Calculate polyphony
	local polyphony = Musician.Msg.OPTIONS_AUDIO_CHANNELS_TOTAL_POLYPHONY
	polyphony = string.gsub(polyphony, '{polyphony}', Musician.Utils.Highlight(Musician.Utils.GetMaxPolyphony()))
	MusicianOptionsPanelAudioChannelsPolyphony:SetText(polyphony)
end

function Musician.Options.Cancel()
	Musician_Settings.muteGameMusic = currentMuteGameMusic
	Musician_Settings.muteInstrumentToys = currentMuteInstrumentToys
	Musician.Utils.MuteGameMusic(true)
	Musician.Utils.SetInstrumentToysMuted(Musician_Settings.muteInstrumentToys)
	Musician.Utils.UpdateAudioSettings(currentAudioConfiguration)
	Musician_Settings.autoAdjustAudioSettings = currentAutoAdjustAudioConfig
end

function Musician.Options.Save()
	Musician_Settings.enableEmote = MusicianOptionsPanelUnitEmoteEnable:GetChecked()
	Musician_Settings.enableEmotePromo = MusicianOptionsPanelUnitEmoteEnablePromo:GetChecked()
	Musician_Settings.emoteHintShown = true
	Musician_Settings.muteGameMusic = MusicianOptionsPanelIntegrationMuteGameMusic:GetChecked()
	Musician_Settings.muteInstrumentToys = MusicianOptionsPanelIntegrationMuteInstrumentToys:GetChecked()
	Musician.Utils.MuteGameMusic(true)
	Musician.Utils.SetInstrumentToysMuted(Musician_Settings.muteInstrumentToys)
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