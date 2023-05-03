--- Total RP 3 integration including RP player names, nameplates, tooltips and map scan.
-- @module Musician.TRP3

Musician.TRP3E = LibStub("AceAddon-3.0"):NewAddon("Musician.TRP3E", "AceEvent-3.0")

local MODULE_NAME = "TRP3E"
Musician.AddModule(MODULE_NAME)

local LibBase64 = LibStub:GetLibrary("LibBase64")

Musician.TRP3E.ID_PREFIX = 'Musician_'
Musician.TRP3E.WORKFLOW_NAME = 'ImportIntoMusician'
Musician.TRP3E.VARIABLE_NAME = 'SongData'
Musician.TRP3E.ITEM_PICKUP_SOUND = 1192 -- Paper
Musician.TRP3E.ITEM_DROP_SOUND = 1209 -- Paper
Musician.TRP3E.ITEM_QUALITY = 1 -- Common
Musician.TRP3E.ITEM_MAX_STACK = 20
Musician.TRP3E.ITEM_ICON = '70_professions_scroll_01' -- Sheet music on a scroll
Musician.TRP3E.ITEM_ERROR_SOUND = 847 -- igQuestFailed

Musician.TRP3E.Event = {}
Musician.TRP3E.Event.CreateStart = 'MusicianTRPECreateStart'
Musician.TRP3E.Event.CreateProgress = 'MusicianTRPECreateProgress'
Musician.TRP3E.Event.CreateComplete = 'MusicianTRPECreateComplete'
Musician.TRP3E.Event.LoadStart = 'MusicianTRPELoadStart'
Musician.TRP3E.Event.LoadProgress = 'MusicianTRPELoadProgress'
Musician.TRP3E.Event.LoadComplete = 'MusicianTRPELoadComplete'

local BASE64ENCODE_PROGRESSION_RATIO = .5
local BASE64DECODE_PROGRESSION_RATIO = .33
local BASE64_CONVERT_RATE = 72 -- Number of base64 chunks to be encoded or decoded in 1 ms Must be a multiple of 4

local exporting = false

local importingIDs = {}
local importingSlotButtons = {}

local containerFrames = {}

--- OnEnable
--
function Musician.TRP3E:OnEnable()
	if TRP3_API and TRP3_API.extended then
		Musician.Utils.Debug(MODULE_NAME, "Total RP3 Extended module started.")

		-- Insert default inventory page to container frames
		table.insert(containerFrames, TRP3_InventoryPage.Main)

		Musician.TRP3E.RegisterHooks()
		Musician.TRP3E.InitUI()
	end
end

local function initLocaleDropdown()
	local dropdown = MusicianTRPEExportFrame.locale

	local localeValues = {}
	for locale, msg in pairs(Musician.Locale) do
		table.insert(localeValues, { locale, msg.LOCALE_NAME or locale })
	end

	table.sort(localeValues, function(a, b)
		return a[2] < b[2]
	end)

	local localeIndexes = {}
	for index, value in pairs(localeValues) do
		localeIndexes[value[1]] = index
	end

	dropdown.SetValue = function(value)
		local index = localeIndexes[value]
		if index == nil then
			dropdown.SetValue('en')
			return
		end
		dropdown.value = value
		MSA_DropDownMenu_SetText(dropdown, localeValues[index][2])
	end

	dropdown.OnClick = function(self, arg1)
		dropdown.SetValue(arg1)
	end

	dropdown.GetItems = function(frame)
		local info = MSA_DropDownMenu_CreateInfo()
		info.func = dropdown.OnClick
		for _, value in pairs(localeValues) do
			info.arg1 = value[1]
			info.text = value[2]
			info.checked = dropdown.value == value[1]
			MSA_DropDownMenu_AddButton(info)
		end
	end

	MSA_DropDownMenu_Initialize(dropdown, dropdown.GetItems)
end

local function setCooldown(infoId, progress)
	-- Get button slots for the current item info ID
	importingSlotButtons[infoId] = Musician.TRP3E.GetSlotButtons(infoId)

	-- Update cooldown effect to reflect the progress
	for _, slot in pairs(importingSlotButtons[infoId]) do
		-- Create cooldown frame
		if slot.MusicianCooldown == nil then
			slot.MusicianCooldown = CreateFrame('Cooldown', nil, slot, 'CooldownFrameTemplate')
			slot.MusicianCooldown:SetAllPoints()
		end

		if progress ~= nil then
			-- Set progress as cooldown
			slot.MusicianCooldown:Pause()
			slot.MusicianCooldown:SetCooldown(GetTime() - progress, 1, 0)
		else
			-- No more progress, do the blingy thingy
			slot.MusicianCooldown:SetCooldown(0, 0)
			slot.MusicianCooldown:Resume()

			-- Sometimes a glitch appears after the bling animation so clear the cooldown to avoid it
			C_Timer.After(1, function()
				if slot.info and slot.info.id == infoId then
					slot.MusicianCooldown:Clear()
				end
			end)
		end
	end

	-- Cleanup unused cooldowns
	for _, containerFrame in pairs(containerFrames) do
		for _, slot in pairs(containerFrame.slots) do
			if slot.MusicianCooldown and
				(not slot.info or importingSlotButtons[slot.info.id] == nil) and
				slot.MusicianCooldown:IsPaused()
			then
				slot.MusicianCooldown:Clear()
			end
		end
	end

	-- Remove completed slot buttons
	if progress == nil then
		importingSlotButtons[infoId] = nil
	end
end

--- Init the UI elements
--
function Musician.TRP3E.InitUI()
	-- Change Link button label to "Export" in main window
	--

	local linkButton = MusicianFrameLinkButton
	linkButton:SetText(Musician.Msg.TRPE_EXPORT_BUTTON)

	-- Replace link button action by a menu in main window
	--

	local linkButtonDefaultAction = linkButton:GetScript('OnClick')
	linkButton:SetScript('OnClick', function()
		local menu = {
			{
				notCheckable = true,
				text = Musician.Msg.LINK_EXPORT_WINDOW_TITLE,
				func = linkButtonDefaultAction
			},
			{
				notCheckable = true,
				text = Musician.Msg.TRPE_EXPORT_WINDOW_TITLE,
				func = Musician.TRP3E.ShowExportFrame
			},
		}
		local menuFrame = CreateFrame("Frame", "MusicianTRPE_ExportMenu", UIParent, "MusicianDropDownMenuTooltipTemplate")
		Musician.Utils.EasyMenu(menu, menuFrame, "cursor", 0, 0, "MENU")
	end)

	-- Initialize item export frame
	--

	Musician.TRP3E.InitExportFrame()

	-- Init item locale dropdown
	--

	initLocaleDropdown()

	-- Item song loading progression
	--

	Musician.TRP3E:RegisterMessage(Musician.TRP3E.Event.LoadProgress, function(event, infoId, progress)
		setCooldown(infoId, progress)
	end)

	-- Item song loading complete
	--

	Musician.TRP3E:RegisterMessage(Musician.TRP3E.Event.LoadComplete, function(event, infoId, song, success)
		setCooldown(infoId, nil)

		if not success then return end

		-- Stop previous source song being played
		if Musician.sourceSong and Musician.sourceSong:IsPlaying() then
			Musician.sourceSong:Stop()
		end

		Musician.sourceSong = song
		collectgarbage()

		Musician.TRP3E:SendMessage(Musician.Events.SourceSongLoaded, song)
		MusicianFrame:Show()
	end)
end

--- Get the UI slot buttons corresponding to the provided item infoId
-- @param infoId (string)
-- @return slotButtons (table)
function Musician.TRP3E.GetSlotButtons(infoId)
	local slotButtons = {}
	for _, containerFrame in pairs(containerFrames) do
		for _, slotButton in pairs(containerFrame.slots) do
			if slotButton.info and slotButton.info.id == infoId then
				table.insert(slotButtons, slotButton)
			end
		end
	end
	return slotButtons
end

local function createItem(song, locale, icon, quantity)
	Musician.TRP3E:RegisterMessage(Musician.Events.SongExportStart, function(event, exportedSong)
		if exportedSong ~= song then return end
		Musician.TRP3E:SendMessage(Musician.TRP3E.Event.CreateStart, exportedSong)
	end)

	Musician.TRP3E:RegisterMessage(Musician.Events.SongExportProgress, function(event, exportedSong, progress)
		if exportedSong ~= song then return end
		Musician.TRP3E:SendMessage(Musician.TRP3E.Event.CreateProgress, exportedSong,
			progress * (1 - BASE64ENCODE_PROGRESSION_RATIO))
	end)

	song:ExportCompressed(function(songData)
		-- Total RP Extended only allows printable characters in its data
		-- Encode song data in base 64 to avoid issues exporting the item
		local cursor = 1
		local encodedSongData = ''
		local base64EncodeWorker
		base64EncodeWorker = function()
			local progression = min(1, cursor / #songData)
			Musician.TRP3E:SendMessage(Musician.TRP3E.Event.CreateProgress, song,
				(1 - BASE64ENCODE_PROGRESSION_RATIO) + progression * BASE64ENCODE_PROGRESSION_RATIO)

			local cursorTo = min(#songData, cursor + BASE64_CONVERT_RATE - 1)
			encodedSongData = encodedSongData .. LibBase64:enc(string.sub(songData, cursor, cursorTo))
			cursor = cursorTo + 1

			if cursorTo == #songData then
				Musician.Worker.Remove(base64EncodeWorker)
				Musician.TRP3E.AddSheetMusicItem(song.name, encodedSongData, locale, icon, quantity)
				Musician.TRP3E:SendMessage(Musician.TRP3E.Event.CreateProgress, song, 1)
				Musician.TRP3E:SendMessage(Musician.TRP3E.Event.CreateComplete, song)
				song = nil
				Musician.TRP3E:UnregisterMessage(Musician.Events.SongExportStart)
				Musician.TRP3E:UnregisterMessage(Musician.Events.SongExportProgress)
				collectgarbage()
				return
			end
		end
		Musician.Worker.Set(base64EncodeWorker)
	end)
end

local function injectUIData()
	local frame = MusicianTRPEExportFrame
	local title = frame.songTitle:GetText()
	local locale = frame.locale.value
	local icon = frame.preview.selectedIcon
	local _, object, isExisting = Musician.TRP3E.GetSheetMusicItem(title, locale, icon)
	if isExisting then -- Return a copy in case the item already exists to avoid updating it
		object = Musician.Utils.DeepCopy(object)
	end
	Musician.TRP3E.UpdateSheetMusicItem(object, title, '', locale, icon)
	return object
end

local function onIconSelected(icon)
	local frame = MusicianTRPEExportFrame
	frame.preview.Icon:SetTexture("Interface\\ICONS\\" .. (icon or "TEMP"))
	frame.preview.selectedIcon = icon
end

local function updateHint()
	local frame = MusicianTRPEExportFrame
	local _, _, isExisting = Musician.TRP3E.GetSheetMusicItem(frame.songTitle:GetText())

	if isExisting then
		frame.hint:SetText(Musician.Msg.TRPE_EXPORT_WINDOW_HINT_EXISTING)
	else
		frame.hint:SetText(Musician.Msg.TRPE_EXPORT_WINDOW_HINT_NEW)
	end
end

--- Initialize the TRP item export frame
--
function Musician.TRP3E.InitExportFrame()
	local frame = MusicianTRPEExportFrame

	-- Main title
	frame.title:SetText(Musician.Msg.TRPE_EXPORT_WINDOW_TITLE)

	-- Song title
	frame.songTitleLabel:SetText(Musician.Msg.LINK_EXPORT_WINDOW_SONG_TITLE_LABEL)
	frame.songTitle:SetScript("OnEnterPressed", function()
		frame.createItem()
	end)
	frame.songTitle:SetScript("OnEscapePressed", function()
		frame:Hide()
	end)

	-- Locale
	frame.localeLabel:SetText(Musician.Msg.TRPE_EXPORT_WINDOW_LOCALE)
	MSA_DropDownMenu_SetWidth(frame.locale, 80)

	-- Add to bag checkbox
	Musician.Options.SetupCheckbox(frame.addToBag, Musician.Msg.TRPE_EXPORT_WINDOW_ADD_TO_BAG)
	local addToBagOnChange = function()
		if frame.addToBag:GetChecked() then
			frame.quantity:Enable()
		else
			frame.quantity:Disable()
		end
	end
	hooksecurefunc(frame.addToBag, 'SetChecked', addToBagOnChange)
	frame.addToBag:HookScript("OnClick", addToBagOnChange)

	-- Quantity edit box
	frame.quantityLabel:SetText(Musician.Msg.TRPE_EXPORT_WINDOW_QUANTITY)
	frame.quantity:SetScript("OnEditFocusGained", function(self)
		self:HighlightText(0)
	end)
	frame.quantity:SetScript("OnEnterPressed", function()
		frame.createItem()
	end)
	frame.quantity:SetScript("OnEscapePressed", function()
		frame:Hide()
	end)

	-- Export item button
	frame.exportItemButton:HookScript("OnClick", function()
		frame.createItem()
	end)

	-- Preview widget
	frame.preview = CreateFrame('Button', frame:GetName() .. 'Preview', frame.previewContainer, 'TRP3_QuestButtonTemplate')
	frame.preview:SetAllPoints(frame.previewContainer)
	frame.preview.Disable = function(self)
		getmetatable(self).__index.Disable(self)
		self.Name:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
		self.InfoText:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
	end
	frame.preview.Enable = function(self)
		getmetatable(self).__index.Enable(self)
		local nameFontObject = self.Name:GetFontObject()
		self.Name:SetTextColor(nameFontObject:GetTextColor())
		local infoTextFontObject = self.InfoText:GetFontObject()
		self.InfoText:SetTextColor(infoTextFontObject:GetTextColor())
	end
end

--- Show the TRP item export frame
--
function Musician.TRP3E.ShowExportFrame()
	if not Musician.sourceSong then return end

	local frame = MusicianTRPEExportFrame

	if not exporting then
		local sharedSong = Musician.sourceSong

		frame.createItem = function()
			local title = Musician.Utils.NormalizeSongName(frame.songTitle:GetText())
			local locale = frame.locale.value
			local icon = frame.preview.selectedIcon
			local quantity = frame.addToBag:GetChecked() and tonumber(frame.quantity:GetText())

			sharedSong.name = title
			if sharedSong == Musician.sourceSong then
				Musician.Frame.Clear()
			end

			createItem(sharedSong, locale, icon, quantity)
		end

		-- Retrieve existing item data
		local _, object = Musician.TRP3E.GetSheetMusicItem(sharedSong.name)

		-- Song title

		frame.songTitle:SetMaxBytes(Musician.Song.MAX_NAME_LENGTH)
		frame.songTitle:SetText(sharedSong.name)
		frame.songTitle:HighlightText(0)
		frame.songTitle:SetFocus()
		frame.songTitle:Enable()
		frame.songTitle:SetScript('OnKeyDown', updateHint)
		frame.songTitle:SetScript('OnTextChanged', updateHint)

		-- Locale

		MSA_DropDownMenu_EnableDropDown(frame.locale)
		frame.locale.SetValue(object.MD.LO or Musician.Utils.GetRealmLocale())

		-- Preview (icon select)

		frame.preview:Enable()
		onIconSelected(object.BA.IC)
		frame.preview.Name:SetText(TRP3_API.loc.EDITOR_PREVIEW)
		frame.preview.InfoText:SetText(TRP3_API.loc.EDITOR_ICON_SELECT)
		frame.preview:SetScript('OnEnter', function(self)
			TRP3_API.inventory.showItemTooltip(self, TRP3_API.globals.empty, injectUIData(), true)
		end)
		frame.preview:SetScript('OnLeave', function(self)
			TRP3_ItemTooltip:Hide()
		end)
		frame.preview:SetScript('OnClick', function(self)
			TRP3_API.popup.showPopup(TRP3_API.popup.ICONS, { parent = frame, point = "LEFT", parentPoint = "RIGHT" },
				{ onIconSelected })
		end)

		-- Add to bag and quantity

		frame.addToBag:Enable()
		frame.addToBag:SetChecked(true)
		frame.quantity:SetText(1)

		-- Hint

		updateHint()
		frame.hint:Show()

		-- Progress bar

		frame.progressText:SetText(Musician.Msg.TRPE_EXPORT_WINDOW_PROGRESS)
		frame.progressText:Hide()
		frame.progressBar:Hide()

		-- Export button

		frame.exportItemButton:SetText(Musician.Msg.TRPE_EXPORT_WINDOW_CREATE_ITEM_BUTTON)
		frame.exportItemButton:Enable()

		-- Set events

		Musician.TRP3E:RegisterMessage(Musician.TRP3E.Event.CreateStart, function(event)
			exporting = true
			frame.exportItemButton:Disable()
			frame.songTitle:Disable()
			MSA_DropDownMenu_DisableDropDown(frame.locale)
			frame.preview:Disable()
			frame.addToBag:Disable()
			frame.quantity:Disable()
			frame.progressBar:Show()
			frame.progressText:Show()
			frame.hint:Hide()
		end)

		Musician.TRP3E:RegisterMessage(Musician.TRP3E.Event.CreateProgress, function(event, _, progress)
			frame.progressBar:SetProgress(progress)
			local percentageText = floor(progress * 100)
			local progressText = string.gsub(Musician.Msg.TRPE_EXPORT_WINDOW_PROGRESS, '{progress}', percentageText)
			frame.progressText:SetText(progressText)
		end)

		Musician.TRP3E:RegisterMessage(Musician.TRP3E.Event.CreateComplete, function(event, _)
			frame.progressBar:Hide()
			frame.progressText:Hide()
			frame.hint:Show()
			frame:Hide()
			exporting = false
			Musician.TRP3E:UnregisterMessage(Musician.TRP3E.Event.CreateStart)
			Musician.TRP3E:UnregisterMessage(Musician.TRP3E.Event.CreateProgress)
			Musician.TRP3E:UnregisterMessage(Musician.TRP3E.Event.CreateComplete)
			sharedSong = nil
			collectgarbage()
		end)
	end

	frame:Show()
end

--- Enable or disable a TRP3 checkbox
-- @param checkbox (CheckButton) inherits TRP3_CheckBox
-- @param enabled (boolean)
function Musician.TRP3E.SetCheckboxEnabled(checkbox, enabled)
	if enabled then
		checkbox:Enable()
		checkbox.Text:SetFontObject(GameFontNormalSmall)
	else
		checkbox:Disable()
		checkbox.Text:SetFontObject(GameFontDisableSmall)
	end
end

--- Enable or disable a TRP3 edit box
-- @param editBox (EditBox) inherits TRP3_TitledEditBox
-- @param enabled (boolean)
function Musician.TRP3E.SetEditBoxEnabled(editBox, enabled)
	if enabled then
		editBox:Enable()
		editBox.title:SetTextColor(0.95, 0.75, 0.21)
	else
		editBox:Disable()
		editBox.title:SetTextColor(0.5, 0.5, 0.5)
	end
end

--- Remove the "Require Musician" message from item tooltip
-- @param tooltip (Frame)
function Musician.TRP3E.FilterTooltip(tooltip)
	for i = 1, 2 do
		local textRight = _G[tooltip:GetName() .. 'TextRight' .. i]
		if textRight and textRight:GetText() then
			for _, msg in pairs(Musician.Locale) do
				if msg.TRPE_ITEM_TOOLTIP_REQUIRES_MUSICIAN ~= nil and
					string.find(textRight:GetText(), msg.TRPE_ITEM_TOOLTIP_REQUIRES_MUSICIAN, 1, true) ~= nil
				then
					textRight:SetText('')
					return
				end
			end
		end
	end
end

--- Update the container frames table
--
local function updateContainerFrames()
	-- Add existing container frames
	for _, frameName in pairs(UISpecialFrames) do
		if string.sub(frameName, 1, 14) == 'TRP3_Container' and not tContains(containerFrames, _G[frameName]) then
			table.insert(containerFrames, _G[frameName])
		end
	end
end

--- Import song
-- @param encodedSongData (string) Base64-encoded compressed song data
-- @param infoId (string)
local function importSong(encodedSongData, infoId)
	-- Song is already importing
	if importingIDs[infoId] ~= nil then return end
	importingIDs[infoId] = true

	updateContainerFrames()

	Musician.TRP3E:SendMessage(Musician.TRP3E.Event.LoadStart, infoId)

	-- Decode compressed song data
	local cursor = 1
	local songData = ''
	local base64DecodeWorker
	base64DecodeWorker = function()
		local progression = min(1, cursor / #encodedSongData)
		Musician.TRP3E:SendMessage(Musician.TRP3E.Event.LoadProgress, infoId, progression * BASE64DECODE_PROGRESSION_RATIO)

		local cursorTo = min(#encodedSongData, cursor + BASE64_CONVERT_RATE * 4 - 1)
		songData = songData .. LibBase64:dec(string.sub(encodedSongData, cursor, cursorTo))
		cursor = cursorTo + 1

		if cursorTo >= #encodedSongData then
			Musician.Worker.Remove(base64DecodeWorker)

			-- Import song
			local song = Musician.Song.create()
			song.TRP3ItemID = infoId

			song:ImportCompressed(songData, false, function(success)
				song.TRP3ItemID = nil
				importingIDs[infoId] = nil
				Musician.TRP3E:SendMessage(Musician.TRP3E.Event.LoadComplete, infoId, song, success)
				song = nil
				collectgarbage()
			end)

			return
		end
	end
	Musician.Worker.Set(base64DecodeWorker, function()
		Musician.Worker.Remove(base64DecodeWorker)
		Musician.TRP3E:SendMessage(Musician.TRP3E.Event.LoadComplete, infoId, nil, false)
		Musician.Utils.Error(Musician.Msg.INVALID_MUSIC_CODE)
	end)
end

--- Indicates whenever the provided item class ID is for a musician object
-- @param classId (string)
-- @return isMusicianId (boolean)
function Musician.TRP3E.IsMusicianId(classId)
	return string.sub(classId, 1, #Musician.TRP3E.ID_PREFIX) == Musician.TRP3E.ID_PREFIX
end

--- Register TRP3 Extended hooks
--
function Musician.TRP3E.RegisterHooks()

	-- Item tooltips
	--

	hooksecurefunc(TRP3_ItemTooltip, 'Show', Musician.TRP3E.FilterTooltip)
	hooksecurefunc(TRP3_RefTooltip, 'Show', Musician.TRP3E.FilterTooltip)

	-- Item OnUse script
	--

	local executeClassScript = TRP3_API.script.executeClassScript
	TRP3_API.script.executeClassScript = function(useWorkflow, classSC, args, infoId)

		-- Musician import workflow is invoked and present
		if useWorkflow == Musician.TRP3E.WORKFLOW_NAME and classSC[Musician.TRP3E.WORKFLOW_NAME] ~= nil then
			local ST = classSC[Musician.TRP3E.WORKFLOW_NAME].ST

			-- Grab the song data inside the workflow
			if type(ST) == 'table' then
				for _, STrow in pairs(ST) do
					if type(STrow.e) == 'table' then
						for _, eRow in pairs(STrow.e) do
							-- Song data variable has been found
							if eRow.id == 'var_object' and
								eRow.args[1] == 'w' and
								eRow.args[2] == '[=]' and
								eRow.args[3] == Musician.TRP3E.VARIABLE_NAME
							then
								-- Launch import
								importSong(eRow.args[4], infoId)
								return 0 -- success
							end
						end
					end
				end
			end
		end

		return executeClassScript(useWorkflow, classSC, args, infoId)
	end

	-- Notify loading progression for song import
	--

	Musician.TRP3E:RegisterMessage(Musician.Events.SongImportProgress, function(event, song, progress)
		if song.TRP3ItemID == nil then return end
		Musician.TRP3E:SendMessage(Musician.TRP3E.Event.LoadProgress, song.TRP3ItemID,
			BASE64DECODE_PROGRESSION_RATIO + progress * (1 - BASE64DECODE_PROGRESSION_RATIO))
	end)

	-- Disable specific item editor elements for Musician sheet music items
	--

	local toolFrame = TRP3_ToolFrame
	local gameplay = toolFrame.item.normal.gameplay
	local display = toolFrame.item.normal.display

	local function refreshCheck()
		if toolFrame.fullClassID ~= nil and Musician.TRP3E.IsMusicianItem(TRP3_DB.global[toolFrame.fullClassID]) then

			-- Hide all tabs except the first one
			local tabIndex = 0
			for _, frame in pairs({ TRP3_ToolFrameItemNormalTabPanel:GetChildren() }) do
				if string.sub(frame:GetName(), 1, 16) == 'TRP3_TabBar_Tab_' then
					tabIndex = tabIndex + 1
					if tabIndex >= 2 then
						frame:Hide()
					end
				end
			end

			Musician.TRP3E.SetCheckboxEnabled(gameplay.unique, false)
			Musician.TRP3E.SetCheckboxEnabled(gameplay.stack, false)
			Musician.TRP3E.SetCheckboxEnabled(gameplay.use, false)
			Musician.TRP3E.SetCheckboxEnabled(gameplay.container, false)
			Musician.TRP3E.SetCheckboxEnabled(display.quest, false)
			Musician.TRP3E.SetEditBoxEnabled(display.right, false)
		else
			Musician.TRP3E.SetCheckboxEnabled(gameplay.unique, true)
			Musician.TRP3E.SetCheckboxEnabled(gameplay.stack, true)
			Musician.TRP3E.SetCheckboxEnabled(gameplay.use, true)
			Musician.TRP3E.SetCheckboxEnabled(gameplay.container, true)
			Musician.TRP3E.SetCheckboxEnabled(display.quest, true)
			Musician.TRP3E.SetEditBoxEnabled(display.right, true)
		end
	end

	gameplay.unique:HookScript('OnClick', refreshCheck)
	gameplay.stack:HookScript('OnClick', refreshCheck)
	gameplay.use:HookScript('OnClick', refreshCheck)
	gameplay.container:HookScript('OnClick', refreshCheck)
	display.quest:HookScript('OnClick', refreshCheck)
	toolFrame:HookScript('OnShow', refreshCheck)
	hooksecurefunc(toolFrame.item.normal, 'loadItem', refreshCheck)
end

--- Add or update existing sheet music item into TRP3 items
-- @param title (string) Song title
-- @param encodedSongData (string) Base64-encoded song data
-- @param[opt] locale (string) Item locale. By default, the current realm locale is used.
-- @param[opt=Musician.TRP3E.ITEM_ICON] icon (string) Item icon
-- @param[opt=1] quantity (int) Item quantity to be added in the main inventory
-- @return objectID (string)
function Musician.TRP3E.AddSheetMusicItem(title, encodedSongData, locale, icon, quantity)
	title = Musician.TRP3E.NormalizeTitle(title)

	if icon == nil then icon = Musician.TRP3E.ITEM_ICON end
	if locale == nil then locale = Musician.Utils.GetRealmLocale() end
	if quantity == nil then quantity = 1 end

	local objectID, object = Musician.TRP3E.GetSheetMusicItem(title, locale, icon)
	Musician.TRP3E.UpdateSheetMusicItem(object, title, encodedSongData, locale, icon)

	-- Register object then refresh UI
	TRP3_DB.my[objectID] = object
	TRP3_API.security.computeSecurity(objectID, object)
	TRP3_API.extended.unregisterObject(objectID)
	TRP3_API.extended.registerObject(objectID, object, 0)
	TRP3_API.script.clearRootCompilation(objectID)
	if TRP3_API.events and TRP3_API.events.fireEvent then
		TRP3_API.events.fireEvent(TRP3_API.inventory.EVENT_REFRESH_BAG)
		TRP3_API.events.fireEvent(TRP3_API.quest.EVENT_REFRESH_CAMPAIGN)
		TRP3_API.events.fireEvent(TRP3_API.events.ON_OBJECT_UPDATED)
	end

	-- Add to the bag
	if quantity and quantity > 0 then
		TRP3_API.inventory.addItem(nil, objectID, { count = quantity })
	end

	return objectID
end

--- Get new or existing sheet music item for the provided song title
-- @param title (string) Song title
-- @param[opt] locale (string) Item locale. By default, the current realm locale is used.
-- @param[opt=Musician.TRP3E.ITEM_ICON] icon (string) Item icon
-- @return ID (string)
-- @return object (table)
-- @return isExisting (boolean)
function Musician.TRP3E.GetSheetMusicItem(title, locale, icon)
	title = Musician.TRP3E.NormalizeTitle(title)

	-- Find existing sheet music item by title
	for ID, object in pairs(TRP3_DB.global) do
		for aLocale, _ in pairs(Musician.Locale) do
			local itemName = string.gsub(Musician.Utils.GetMsg('TRPE_ITEM_NAME', aLocale), '{title}', title)
			if Musician.TRP3E.IsMusicianId(ID) and object.BA.NA == itemName then
				return ID, object, true
			end
		end
	end

	-- Create new object
	local ID, object = Musician.TRP3E.CreateSheetMusicItem(title, locale, icon)
	return ID, object, false
end

--- Update localized strings within the TRP item object
-- @param object (table)
-- @param title (string) Song title
-- @param locale (string) Item locale
local function updateItemStrings(object, title, locale)
	object.BA.NA = string.gsub(Musician.Utils.GetMsg('TRPE_ITEM_NAME', locale), '{title}', title)
	object.BA.LE = Musician.Utils.GetMsg('TRPE_ITEM_TOOLTIP_SHEET_MUSIC', locale)
	object.NT = string.gsub(Musician.Utils.GetMsg('TRPE_ITEM_NOTES', locale), '{url}', Musician.URL)
	if object.US ~= nil then
		object.US.AC = Musician.Utils.GetMsg('TRPE_ITEM_USE_HINT', locale)
	end
end

--- Create a new sheet music item for the provided song title
-- @param title (string) Song title
-- @param[opt] locale (string) Item locale. By default, the current realm locale is used.
-- @param[opt=Musician.TRP3E.ITEM_ICON] icon (string) Item icon
-- @return ID (string)
-- @return object (table)
function Musician.TRP3E.CreateSheetMusicItem(title, locale, icon)
	title = Musician.TRP3E.NormalizeTitle(title)
	if icon == nil then icon = Musician.TRP3E.ITEM_ICON end
	if locale == nil then locale = Musician.Utils.GetRealmLocale() end

	-- Generate ID
	local ID = Musician.TRP3E.ID_PREFIX .. TRP3_API.utils.str.id()

	-- Create base item
	local object = TRP3_API.extended.tools.getBlankItemData(TRP3_DB.modes.EXPERT)

	-- Set version
	object.MD.V = 0 -- Will be increased to 1 on the first call to UpdateSheetMusicItem()

	-- Set up item defaults. These can be customized by the user
	if object.BA == nil then object.BA = {} end
	object.BA.IC = icon
	object.BA.ST = Musician.TRP3E.ITEM_MAX_STACK
	object.BA.QA = Musician.TRP3E.ITEM_QUALITY
	object.BA.PS = Musician.TRP3E.ITEM_PICKUP_SOUND
	object.BA.DS = Musician.TRP3E.ITEM_DROP_SOUND

	-- Set item localized strings
	updateItemStrings(object, title, locale)

	return ID, object
end

--- Update an existing sheet music item to set the song data
-- @param object (table)
-- @param title (string) Song title
-- @param encodedSongData (string) Base64-encoded song data
-- @param locale (string)
-- @param icon (string)
function Musician.TRP3E.UpdateSheetMusicItem(object, title, encodedSongData, locale, icon)
	title = Musician.TRP3E.NormalizeTitle(title)

	-- Update version
	object.MD.V = object.MD.V + 1
	object.MD.SD = date("%d/%m/%y %H:%M:%S")
	object.MD.SB = TRP3_API.globals.player_id
	object.MD.tV = TRP3_API.globals.extended_version
	object.MD.dV = TRP3_API.globals.extended_display_version

	-- Update name
	object.BA.NA = string.gsub(Musician.Utils.GetMsg('TRPE_ITEM_NAME', locale), '{title}', title)

	-- Update icon
	object.BA.IC = icon

	-- Update locale and strings
	if object.MD.LO ~= locale then
		-- Refresh localized strings if the locale was changed
		updateItemStrings(object, title, locale)
	end
	object.MD.LO = locale

	-- Set right tooltip text. Hidden when Musician is installed
	object.BA.RI = Musician.Utils.Highlight(Musician.Utils.GetMsg('TRPE_ITEM_TOOLTIP_REQUIRES_MUSICIAN', locale), 'FF0000')

	-- Set item as usable
	object.BA.US = true
	if object.US == nil then object.US = {} end
	if object.US.AC == nil then object.US.AC = Musician.Utils.GetMsg('TRPE_ITEM_USE_HINT', locale) end
	object.US.SC = 'OnUse'

	-- Set OnUse workflow
	if object.LI == nil then object.LI = {} end
	object.LI.OU = Musician.TRP3E.WORKFLOW_NAME
	if object.SC == nil then object.SC = {} end
	object.SC[Musician.TRP3E.WORKFLOW_NAME] = Musician.TRP3E.GetWorkflow(encodedSongData, locale)
end

--- Returns the internal item workflow for provided song data
-- @param encodedSongData (string) Base64-encoded song data
-- @param locale (string)
-- @return workflow (table)
function Musician.TRP3E.GetWorkflow(encodedSongData, locale)
	return {
		ST = {
			-- Set the variable containing the song data
			['1'] = {
				e = {
					{
						id = 'var_object',
						args = { 'w', '[=]', Musician.TRP3E.VARIABLE_NAME, encodedSongData },
					},
				},
				t = 'list',
				n = '2',
			},
			-- Display an error message if Musician is not installed
			['2'] = {
				e = {
					{
						id = 'text',
						args = {
							string.gsub(Musician.Utils.GetMsg('TRPE_ITEM_MUSICIAN_NOT_FOUND', locale), '{url}',
								Musician.Utils.Highlight(Musician.URL, '00FFFF')),
							1,
						},
					},
				},
				t = 'list',
				n = '3',
			},
			-- Play error sound
			['3'] = {
				e = {
					{
						id = 'sound_id_self',
						args = { 'SFX', Musician.TRP3E.ITEM_ERROR_SOUND },
					},
				},
				t = 'list',
			},
		},
	}
end

--- Indicates whenever the provided TRP3 item object is a Musician sheet music
-- @param object (table)
-- @return isMusicianItem (boolean)
function Musician.TRP3E.IsMusicianItem(object)
	return object and
		object.TY == TRP3_DB.types.ITEM and
		object.SC ~= nil and
		object.SC[Musician.TRP3E.WORKFLOW_NAME] ~= nil
end

--- Normalize song title for TRP item names
-- @param title (string)
-- @return normalizedTitle (string)
function Musician.TRP3E.NormalizeTitle(title)
	-- Replace special characters to avoid breaking the TRP chat links
	title = string.gsub(title, '[%(%)%[%]|]+', ' – ')
	title = string.gsub(title, ' *– *$', '')
	title = string.gsub(title, '^ *– *', '')

	-- Remove duplicate spaces
	title = string.gsub(title, ' +', ' ')
	title = strtrim(title)

	return title
end