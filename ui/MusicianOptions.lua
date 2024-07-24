--- Musician options panel
-- @module Musician.Options

Musician.Options = {}

local MODULE_NAME = "Options"
Musician.AddModule(MODULE_NAME)

local currentShortcutMinimapHide
local currentShortcutMenuHide
local currentMuteGameMusic
local currentMuteInstrumentToys
local currentAudioConfiguration
local currentAutoAdjustAudioConfig
local currentEnableQuickPreloading

--- Options panel initialization
--
function Musician.Options.Init()
	-- Register panel
	local panel = MusicianOptionsPanelContainer
	panel.name = Musician.Msg.OPTIONS_TITLE

	panel:SetScript("OnShow", Musician.Options.UpdateSize)

	if InterfaceOptions_AddCategory then
		-- Old school way
		panel.refresh = Musician.Options.Refresh
		panel.okay = Musician.Options.Save
		panel.cancel = Musician.Options.Cancel
		panel.default = Musician.Options.Defaults

		InterfaceOptions_AddCategory(panel)
	else
		panel.OnRefresh = Musician.Options.Refresh
		panel.OnCommit = Musician.Options.Save
		panel.OnCancel = Musician.Options.Cancel
		panel.OnDefault = Musician.Options.Defaults

		local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
		Settings.RegisterAddOnCategory(category)
		Musician.Options.category = category
	end

	-- Enable hyperlinks
	Musician.EnableHyperlinks(MusicianOptionsPanel)

	-- Set title and link to the Discord server
	MusicianOptionsPanelTitle:SetText(Musician.Msg.OPTIONS_TITLE)
	local discordText = string.gsub(Musician.Msg.OPTIONS_SUB_TEXT, "{url}",
		Musician.Utils.GetUrlLink(Musician.DISCORD_URL))
	MusicianOptionsPanelSubText:SetText(discordText)

	-- Emote
	MusicianOptionsPanelUnitEmoteTitle:SetText(Musician.Msg.OPTIONS_CATEGORY_EMOTE)
	Musician.Options.SetupCheckbox(MusicianOptionsPanelUnitEmoteEnable, Musician.Msg.OPTIONS_ENABLE_EMOTE_LABEL)
	Musician.Options.SetupCheckbox(MusicianOptionsPanelUnitEmoteEnablePromo,
		Musician.Msg.OPTIONS_ENABLE_EMOTE_PROMO_LABEL,
		MusicianOptionsPanelUnitEmoteEnable)

	-- Integration options
	MusicianOptionsPanelIntegrationTitle:SetText(Musician.Msg.OPTIONS_INTEGRATION_OPTIONS_TITLE)
	Musician.Options.SetupCheckbox(MusicianOptionsPanelIntegrationMuteGameMusic,
		Musician.Msg.OPTIONS_AUTO_MUTE_GAME_MUSIC_LABEL)
	MusicianOptionsPanelIntegrationMuteGameMusic:HookScript("OnClick", function(self)
		Musician_Settings.muteGameMusic = self:GetChecked()
		Musician.Utils.MuteGameMusic(true)
	end)
	Musician.Options.SetupMuteInstrumentToysCheckbox()
	Musician.Utils.SetInstrumentToysMuted(Musician_Settings.muteInstrumentToys)

	-- Audio channels
	MusicianOptionsPanelAudioChannelsTitle:SetText(Musician.Msg.OPTIONS_AUDIO_CHANNELS_TITLE)
	MusicianOptionsPanelAudioChannelsSubText:SetText(Musician.Msg.OPTIONS_AUDIO_CHANNELS_HINT)
	Musician.Options.SetupSoundChannelCheckbox(MusicianOptionsPanelAudioChannelsMaster, MASTER_VOLUME, 'Master', 30)
	Musician.Options.SetupSoundChannelCheckbox(MusicianOptionsPanelAudioChannelsSFX, FX_VOLUME or SOUND_VOLUME, 'SFX', 15)
	Musician.Options.SetupSoundChannelCheckbox(MusicianOptionsPanelAudioChannelsDialog, DIALOG_VOLUME, 'Dialog', 20)
	Musician.Options.SetupCheckbox(MusicianOptionsPanelAudioChannelsAutoAdjust,
		Musician.Msg.OPTIONS_AUDIO_CHANNELS_AUTO_ADJUST_CONFIG)
	MusicianOptionsPanelAudioChannelsAutoAdjust:HookScript("OnClick", function(self)
		Musician_Settings.autoAdjustAudioSettings = self:GetChecked()
		Musician.Options.RefreshAudioSettings()
	end)

	-- Shortcuts
	MusicianOptionsPanelShortcutTitle:SetText(Musician.Msg.OPTIONS_CATEGORY_SHORTCUTS)
	Musician.Options.SetupCheckbox(MusicianOptionsPanelShortcutMinimap, Musician.Msg.OPTIONS_SHORTCUT_MINIMAP)
	Musician.Options.SetupCheckbox(MusicianOptionsPanelShortcutMenu, Musician.Msg.OPTIONS_SHORTCUT_ADDON_MENU)
	MusicianOptionsPanelShortcutMinimap:HookScript("OnClick", function(self)
		Musician_CharacterSettings.minimap.hide = not self:GetChecked()
		MusicianButton.Refresh()
	end)
	MusicianOptionsPanelShortcutMenu:HookScript("OnClick", function(self)
		Musician_CharacterSettings.addonCompartment.hide = not self:GetChecked()
		MusicianButton.Refresh()
	end)
	-- Hide add-on menu option if the component is not available on the current WoW version
	if not AddonCompartmentFrame then
		MusicianOptionsPanelShortcutMenu:Hide()
	end

	-- Quick preloading
	MusicianOptionsPanelQuickPreloadingTitle:SetText(Musician.Msg.OPTIONS_QUICK_PRELOADING_TITLE)
	Musician.Options.SetupCheckbox(MusicianOptionsPanelQuickPreloadingEnable,
		Musician.Msg.OPTIONS_QUICK_PRELOADING_TEXT)
	MusicianOptionsPanelQuickPreloadingEnable:HookScript("OnClick", function(self)
		Musician_Settings.enableQuickPreloading = self:GetChecked()
	end)
end

--- Enable or disable the checkbox based on the dependant controls status
-- @param checkbox (CheckButton)
local function computeDependantControls(checkbox)
	local isEnabled = true
	for _, dependantControl in pairs(checkbox.dependantControls) do
		if not dependantControl:GetChecked() then
			isEnabled = false
		end
	end

	if isEnabled then
		checkbox:Enable()
	else
		checkbox:Disable()
	end
end

--- Set up an option checkbox
-- @param checkbox (CheckButton)
-- @param labelText (string)
-- @param[opt] dependantControl (CheckButton)
-- @param[opt] dependantControl2 (CheckButton)
-- @param[opt] dependantControln... (CheckButton)
function Musician.Options.SetupCheckbox(checkbox, labelText, ...)
	local labelElement = checkbox.Text
	labelElement:SetText(labelText)
	checkbox:SetHitRectInsets(0, -labelElement:GetWidth(), 0, 0)

	checkbox.dependantControls = { ... }
	for _, dependantControl in pairs(checkbox.dependantControls) do
		dependantControl:HookScript("OnClick", function()
			computeDependantControls(checkbox)
		end)
		hooksecurefunc(dependantControl, "SetChecked", function()
			computeDependantControls(checkbox)
		end)
	end
end

--- Show Musician's option panel
--
function Musician.Options.Show()
	if InterfaceOptionsFrame_Show then
		InterfaceOptionsFrame_Show() -- This one has to be opened first
	end
	if InterfaceOptionsFrame_OpenToCategory then
		-- Old school way
		InterfaceOptionsFrame_OpenToCategory(Musician.Msg.OPTIONS_TITLE)
	else
		Settings.OpenToCategory(Musician.Options.category.ID)
	end
end

function Musician.Options.Refresh()
	MusicianOptionsPanelShortcutMinimap:SetChecked(not Musician_CharacterSettings.minimap.hide)
	MusicianOptionsPanelShortcutMenu:SetChecked(not Musician_CharacterSettings.addonCompartment.hide)
	MusicianOptionsPanelUnitEmoteEnable:SetChecked(Musician_Settings.enableEmote)
	MusicianOptionsPanelUnitEmoteEnablePromo:SetChecked(Musician_Settings.enableEmotePromo)
	MusicianOptionsPanelUnitEmoteEnablePromo:SetEnabled(Musician_Settings.enableEmote)
	MusicianOptionsPanelIntegrationMuteGameMusic:SetChecked(Musician_Settings.muteGameMusic)
	MusicianOptionsPanelIntegrationMuteInstrumentToys:SetChecked(Musician_Settings.muteInstrumentToys)
	MusicianOptionsPanelQuickPreloadingEnable:SetChecked(Musician_Settings.enableQuickPreloading)
	currentShortcutMinimapHide = Musician_CharacterSettings.minimap.hide
	currentShortcutMenuHide = Musician_CharacterSettings.addonCompartment.hide
	currentMuteGameMusic = Musician_Settings.muteGameMusic
	currentMuteInstrumentToys = Musician_Settings.muteInstrumentToys
	currentAudioConfiguration = Musician.Utils.GetCurrentAudioSettings()
	currentAutoAdjustAudioConfig = Musician_Settings.autoAdjustAudioSettings
	currentEnableQuickPreloading = Musician_Settings.enableQuickPreloading
	Musician.Options.RefreshAudioSettings()
end

function Musician.Options.Defaults()
	Musician_CharacterSettings.minimap.hide = false
	Musician_CharacterSettings.addonCompartment.hide = true
	MusicianButton.Refresh()
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
	Musician_Settings.enableQuickPreloading = true
	Musician.Options.RefreshAudioSettings()
end

function Musician.Options.RefreshAudioSettings()
	local newAudioConfig = Musician.Utils.GetNewAudioSettings(currentAudioConfiguration)
	if Musician_Settings.autoAdjustAudioSettings then
		Musician.Utils.UpdateAudioSettings(newAudioConfig)
	end

	local audioChannels = Musician_Settings.audioChannels

	local checked = (audioChannels.SFX and 1 or 0) + (audioChannels.Master and 1 or 0) +
	(audioChannels.Dialog and 1 or 0)

	-- Make sure at least one channel is checked
	if checked == 0 then
		-- Check SFX if none
		audioChannels.SFX = true
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
	Musician_CharacterSettings.minimap.hide = currentShortcutMinimapHide
	Musician_CharacterSettings.addonCompartment.hide = currentShortcutMenuHide
	MusicianButton.Refresh()
	Musician_Settings.muteGameMusic = currentMuteGameMusic
	Musician_Settings.muteInstrumentToys = currentMuteInstrumentToys
	Musician.Utils.MuteGameMusic(true)
	Musician.Utils.SetInstrumentToysMuted(Musician_Settings.muteInstrumentToys)
	Musician.Utils.UpdateAudioSettings(currentAudioConfiguration)
	Musician_Settings.autoAdjustAudioSettings = currentAutoAdjustAudioConfig
	Musician_Settings.enableQuickPreloading = currentEnableQuickPreloading
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

--- Setup the mute instrument toys checkbox
--
function Musician.Options.SetupMuteInstrumentToysCheckbox()
	local checkButton = MusicianOptionsPanelIntegrationMuteInstrumentToys
	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
		local label = string.gsub(Musician.Msg.OPTIONS_MUTE_INSTRUMENT_TOYS_LABEL, '{icons}', '')
		Musician.Options.SetupCheckbox(checkButton, label)

		local itemIcons = {}
		for _, _ in pairs(Musician.InstrumentToys) do
			table.insert(itemIcons, '')
		end

		local loadedItems = 0
		for itemIndex, itemRow in pairs(Musician.InstrumentToys) do
			local item = Item:CreateFromItemID(itemRow.itemId)
			item:ContinueOnItemLoad(function()
				local fontHeight = checkButton.Text:GetLineHeight() * 1.5
				local itemString = string.match(item:GetItemLink(), "item[%-?%d:]+")
				local itemIcon = item:GetItemIcon()
				local textureString = '|T' .. itemIcon .. ':' .. fontHeight .. '|t'
				local itemLink = '|H' .. itemString .. '|h' .. textureString .. '|h'

				loadedItems = loadedItems + 1
				itemIcons[itemIndex] = itemLink
				if loadedItems == #Musician.InstrumentToys then
					local strIcons = strjoin(" ", unpack(itemIcons))
					label = string.gsub(Musician.Msg.OPTIONS_MUTE_INSTRUMENT_TOYS_LABEL, '{icons}', strIcons)
					checkButton.Text:SetText(label)
					checkButton:SetHyperlinksEnabled(true)
					checkButton.tooltipFrame = GameTooltip
					checkButton:SetScript("OnHyperlinkEnter", InlineHyperlinkFrame_OnEnter)
					checkButton:SetScript("OnHyperlinkLeave", InlineHyperlinkFrame_OnLeave)
					checkButton:SetScript("OnHyperlinkClick", InlineHyperlinkFrame_OnClick)
				end
			end)
		end

		checkButton:HookScript("OnClick", function(self)
			Musician_Settings.muteInstrumentToys = self:GetChecked()
			Musician.Utils.SetInstrumentToysMuted(Musician_Settings.muteInstrumentToys)
		end)
	else
		checkButton:Hide()
		MusicianOptionsPanelIntegration:SetHeight(50)
	end
end

--- Setup a sound channel checkbox
-- @param checkButton (CheckButton)
-- @param label (string)
-- @param channel (string)
-- @param polyphony (int)
function Musician.Options.SetupSoundChannelCheckbox(checkButton, label, channel, polyphony)
	local labelText = string.gsub(Musician.Msg.OPTIONS_AUDIO_CHANNELS_CHANNEL_POLYPHONY, '{channel}', label)
	labelText = string.gsub(labelText, '{polyphony}', polyphony)
	Musician.Options.SetupCheckbox(checkButton, labelText)
	checkButton:HookScript("OnClick", function(self)
		Musician_Settings.audioChannels[channel] = self:GetChecked()
		Musician.Options.RefreshAudioSettings()
	end)
end
