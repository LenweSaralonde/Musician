--- Total RP 3 integration including RP player names, nameplates, tooltips and map scan.
-- @module Musician.TRP3

Musician.TRP3E = LibStub("AceAddon-3.0"):NewAddon("Musician.TRP3E", "AceEvent-3.0")

local MODULE_NAME = "TRP3E"
Musician.AddModule(MODULE_NAME)

local LibDeflate = LibStub:GetLibrary("LibDeflate")

Musician.TRP3E.ID_PREFIX = 'Musician_'
Musician.TRP3E.WORKFLOW_NAME = 'ImportIntoMusician'
Musician.TRP3E.VARIABLE_NAME = 'SongData'
Musician.TRP3E.ITEM_PICKUP_SOUND = 1192 -- Paper
Musician.TRP3E.ITEM_DROP_SOUND = 1209 -- Paper
Musician.TRP3E.ITEM_QUALITY = 1 -- Common
Musician.TRP3E.ITEM_MAX_STACK = 20
Musician.TRP3E.ITEM_ICON = '70_professions_scroll_01' -- Sheet music on a scroll
Musician.TRP3E.ITEM_ERROR_SOUND = 847 -- igQuestFailed

local exporting = false

--- OnEnable
--
function Musician.TRP3E:OnEnable()
	if TRP3_API and TRP3_API.extended then
		Musician.Utils.Debug(MODULE_NAME, "Total RP3 Extended module started.")
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

	table.sort(localeValues, function (a, b)
		return a[2] < b[2]
	end)

	local localeIndexes = {}
	for index, value in pairs(localeValues) do
		localeIndexes[value[1]] = index
	end

	dropdown.SetValue = function(value)
		dropdown.value = value
		local index = localeIndexes[value]
		MSA_DropDownMenu_SetText(dropdown, localeValues[index][2])
	end

	dropdown.OnClick = function(self, arg1, arg2, checked)
		dropdown.SetValue(arg1)
	end

	dropdown.GetItems = function(frame, level, menuList)
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
		Musician.Utils.EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU")
	end)

	-- Create preview widget in item export window
	--

	local frame = MusicianTRPEExportFrame
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

	-- Init item locale dropdown
	--

	initLocaleDropdown()
end

local function createItem(sharedSong)
	local frame = MusicianTRPEExportFrame
	local title = Musician.Utils.NormalizeSongName(frame.songTitle:GetText())
	local locale = frame.locale.value
	local icon = frame.preview.selectedIcon
	local quantity = frame.addToBag:GetChecked() and tonumber(frame.quantity:GetText())
	local addToDB = frame.addToDB:GetChecked()

	sharedSong.name = title
	if sharedSong == Musician.sourceSong then
		MusicianFrame.Clear()
	end

	sharedSong:ExportCompressed(function(songData)
		frame:Hide()
		local ID = Musician.TRP3E.AddSheetMusicItem(title, songData, locale, icon, quantity, addToDB)
		-- Open TRP editor if add to DB was chosen
		if addToDB then
			TRP3_API.extended.tools.goToPage(ID, true)
			TRP3_ToolFrame:Show()
		end
	end)
end

local function injectUIData()
	local frame = MusicianTRPEExportFrame
	local locale = frame.locale.value
	local ID, object = Musician.TRP3E.CreateSheetMusicItem(frame.songTitle:GetText(), frame.preview.selectedIcon, locale)
	Musician.TRP3E.UpdateSheetMusicItem(object, '', locale)
	return object
end

local function onIconSelected(icon)
	local frame = MusicianTRPEExportFrame
	frame.preview.Icon:SetTexture("Interface\\ICONS\\" .. (icon or "TEMP"))
	frame.preview.selectedIcon = icon
end

--- Show the TRP item export frame
--
function Musician.TRP3E.ShowExportFrame()
	if not(Musician.sourceSong) then return end

	local frame = MusicianTRPEExportFrame

	if not(exporting) then
		local sharedSong = Musician.sourceSong

		frame.createItem = function()
			createItem(sharedSong)
		end

		-- Song title

		frame.songTitle:SetMaxBytes(Musician.Song.MAX_NAME_LENGTH)
		frame.songTitle:SetText(sharedSong.name)
		frame.songTitle:HighlightText(0)
		frame.songTitle:SetFocus()
		frame.songTitle:Enable()

		-- Locale

		MSA_DropDownMenu_EnableDropDown(frame.locale)
		frame.locale.SetValue(Musician.Utils.GetRealmLocale())

		-- Preview (icon select)

		frame.preview:Enable()
		onIconSelected(Musician.TRP3E.ITEM_ICON)
		frame.preview.Name:SetText(TRP3_API.loc.EDITOR_PREVIEW)
		frame.preview.InfoText:SetText(TRP3_API.loc.EDITOR_ICON_SELECT)
		frame.preview:SetScript('OnEnter', function(self)
			TRP3_API.inventory.showItemTooltip(self, TRP3_API.globals.empty, injectUIData(), true)
		end)
		frame.preview:SetScript('OnLeave', function(self)
			TRP3_ItemTooltip:Hide()
		end)
		frame.preview:SetScript('OnClick', function(self)
			TRP3_API.popup.showPopup(TRP3_API.popup.ICONS, { parent = frame, point = "LEFT", parentPoint = "RIGHT" }, { onIconSelected })
		end)

		-- Add to bag and quantity

		frame.addToBag:Enable()
		frame.addToBag:SetChecked(true)
		frame.quantity:SetText(1)

		-- Add to the database

		frame.addToDB:Enable()
		frame.addToDB:SetChecked(false)

		-- Hint and progress bar

		frame.hint:SetText(Musician.Msg.TRPE_EXPORT_WINDOW_HINT)
		frame.hint:Show()

		frame.progressText:SetText(Musician.Msg.TRPE_EXPORT_WINDOW_PROGRESS)
		frame.progressText:Hide()
		frame.progressBar:Hide()

		-- Export button

		frame.exportItemButton:SetText(Musician.Msg.TRPE_EXPORT_WINDOW_CREATE_ITEM_BUTTON)
		frame.exportItemButton:Enable()

		-- Set events

		Musician.SongLinkExportFrame:RegisterMessage(Musician.Events.SongExportStart, function(event, song)
			if song ~= sharedSong then return end
			exporting = true
			frame.exportItemButton:Disable()
			frame.songTitle:Disable()
			MSA_DropDownMenu_DisableDropDown(frame.locale)
			frame.preview:Disable()
			frame.addToBag:Disable()
			frame.quantity:Disable()
			frame.addToDB:Disable()
			frame.progressBar:Show()
			frame.progressText:Show()
			frame.hint:Hide()
		end)

		Musician.SongLinkExportFrame:RegisterMessage(Musician.Events.SongExportProgress, function(event, song, progress)
			if song ~= sharedSong then return end
			frame.progressBar:SetProgress(progress)
			local percentageText = floor(progress * 100)
			local progressText = string.gsub(Musician.Msg.TRPE_EXPORT_WINDOW_PROGRESS, '{progress}', percentageText)
			frame.progressText:SetText(progressText)
		end)

		Musician.SongLinkExportFrame:RegisterMessage(Musician.Events.SongExportComplete, function(event, song)
			if song ~= sharedSong then return end
			frame.progressBar:Hide()
			frame.progressText:Hide()
			frame.hint:Show()
			exporting = false
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
				if msg.TRPE_ITEM_TOOLTIP_REQUIRES_MUSICIAN ~= nil and string.find(textRight:GetText(), msg.TRPE_ITEM_TOOLTIP_REQUIRES_MUSICIAN, 1, true) ~= nil then
					textRight:SetText('')
					return
				end
			end
		end
	end
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
							if eRow.id == 'var_object' and eRow.args[1] == 'w' and eRow.args[2] == '[=]' and eRow.args[3] == Musician.TRP3E.VARIABLE_NAME then
								-- Decode song data
								local songData = LibDeflate:DecodeForWoWChatChannel(eRow.args[4])

								-- Show main frame
								MusicianFrame:Show()

								-- Remove previously importing song
								if Musician.importingSong ~= nil then
									Musician.importingSong:CancelImport()
									Musician.importingSong = nil
								end

								-- Import song
								Musician.importingSong = Musician.Song.create()
								collectgarbage()
								Musician.importingSong:ImportCompressed(songData, false)

								return 0 -- success
							end
						end
					end
				end
			end
		end

		return executeClassScript(useWorkflow, classSC, args, infoId)
	end


	-- Add a reference to the TRP3 tab panel for tab container frames
	-- Needed by the editor hook below

	local createTabPanel = TRP3_API.ui.frame.createTabPanel
	TRP3_API.ui.frame.createTabPanel = function(tabBar, data, callback, confirmCallback)
		local tabGroup = createTabPanel(tabBar, data, callback, confirmCallback)
		tabBar.tabGroup = tabGroup
		return tabGroup
	end

	-- Disable specific item editor elements for Musician sheet music items
	--

	hooksecurefunc(TRP3_API.extended.tools, 'initItemEditorNormal', function(toolFrame)
		local tabGroup = TRP3_ToolFrameItemNormalTabPanel.tabGroup
		local gameplay = toolFrame.item.normal.gameplay
		local display = toolFrame.item.normal.display

		local function refreshCheck()
			if toolFrame.fullClassID ~= nil and string.sub(toolFrame.fullClassID, 1, #Musician.TRP3E.ID_PREFIX) == Musician.TRP3E.ID_PREFIX then
				tabGroup:SetTabVisible(2, false)
				tabGroup:SetTabVisible(3, false)
				tabGroup:SetTabVisible(4, false)
				tabGroup:SetTabVisible(5, false)

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
	end)
end

--- Add or update existing sheet music item into TRP3 items
-- @param title (string) Song title
-- @param songData (string) Song data
-- @param[opt] locale (string) Item locale. By default, the current realm locale is used.
-- @param[opt=Musician.TRP3E.ITEM_ICON] icon (string) Item icon
-- @param[opt=1] quantity (int) Item quantity to be added in the main inventory
-- @param[opt=false] addToDB (boolean) Add item to the main DB
-- @return objectID (string)
function Musician.TRP3E.AddSheetMusicItem(title, songData, locale, icon, quantity, addToDB)

	title = Musician.TRP3E.NormalizeTitle(title)

	if icon == nil then icon = Musician.TRP3E.ITEM_ICON end
	if locale == nil then locale = Musician.Utils.GetRealmLocale() end
	if quantity == nil then quantity = 1 end
	if addToDB == nil then addToDB = false end

	local objectID, object = Musician.TRP3E.GetSheetMusicItem(title, icon, locale)

	Musician.TRP3E.UpdateSheetMusicItem(object, songData, locale)

	-- Add to the DB
	if addToDB and TRP3_DB.my[objectID] == nil then
		TRP3_DB.my[objectID] = object
	end

	-- Register object then refresh UI
	TRP3_API.security.computeSecurity(objectID, object)
	TRP3_API.extended.unregisterObject(objectID)
	TRP3_API.extended.registerObject(objectID, object, 0)
	TRP3_API.script.clearRootCompilation(objectID)
	TRP3_API.events.fireEvent(TRP3_API.inventory.EVENT_REFRESH_BAG)
	TRP3_API.events.fireEvent(TRP3_API.quest.EVENT_REFRESH_CAMPAIGN)
	TRP3_API.events.fireEvent(TRP3_API.events.ON_OBJECT_UPDATED)

	-- Add to the bag
	if quantity and quantity > 0 then
		TRP3_API.inventory.addItem(nil, objectID, { count = quantity })
	end

	return objectID
end

--- Get new or existing sheet music item for the provided song title
-- @param title (string) Song title
-- @param icon (string) Item icon
-- @param locale (string) Item locale
-- @return ID (string)
-- @return object (table)
function Musician.TRP3E.GetSheetMusicItem(title, icon, locale)
	-- Find existing sheet music item by title
	for ID, object in pairs(TRP3_DB.global) do
		if string.sub(ID, 1, #Musician.TRP3E.ID_PREFIX) == Musician.TRP3E.ID_PREFIX and string.find(object.BA.NA, title, 1, true) ~= nil then
			return ID, object
		end
	end

	-- Create new object
	return Musician.TRP3E.CreateSheetMusicItem(title, icon, locale)
end

--- Create a new sheet music item for the provided song title
-- @param title (string) Song title
-- @param icon (string) Item icon
-- @param locale (string) Item locale
-- @return ID (string)
-- @return object (table)
function Musician.TRP3E.CreateSheetMusicItem(title, icon, locale)
	-- Generate ID
	local ID = Musician.TRP3E.ID_PREFIX .. TRP3_API.utils.str.id()

	-- Create base item
	local object = TRP3_API.extended.tools.getBlankItemData(TRP3_DB.modes.NORMAL)

	-- Set version
	object.MD.V = 0 -- Will be increased to 1 on the first call to UpdateSheetMusicItem()

	-- Set up item defaults. These can be customized by the user
	if object.BA == nil then object.BA = {} end
	object.BA.NA = string.gsub(Musician.Utils.GetMsg('TRPE_ITEM_NAME', locale), '{title}', Musician.TRP3E.NormalizeTitle(title))
	object.BA.IC = icon
	object.BA.ST = Musician.TRP3E.ITEM_MAX_STACK
	object.BA.QA = Musician.TRP3E.ITEM_QUALITY
	object.BA.LE = Musician.Utils.GetMsg('TRPE_ITEM_TOOLTIP_SHEET_MUSIC', locale)
	object.BA.PS = Musician.TRP3E.ITEM_PICKUP_SOUND
	object.BA.DS = Musician.TRP3E.ITEM_DROP_SOUND
	object.NT = string.gsub(Musician.Utils.GetMsg('TRPE_ITEM_NOTES', locale), '{url}', Musician.URL)

	return ID, object
end

--- Update an existing sheet music item to set the song data
-- @param object (table)
-- @param songData (string)
-- @param locale (string)
function Musician.TRP3E.UpdateSheetMusicItem(object, songData, locale)
	-- Update version
	object.MD.V = object.MD.V + 1
	object.MD.SD = date("%d/%m/%y %H:%M:%S")
	object.MD.SB = TRP3_API.globals.player_id
	object.MD.tV = TRP3_API.globals.extended_version
	object.MD.dV = TRP3_API.globals.extended_display_version

	-- Update locale
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
	object.SC[Musician.TRP3E.WORKFLOW_NAME] = Musician.TRP3E.GetWorkflow(songData, locale)
end

--- Returns the internal item workflow for provided song data
-- @param songData (string)
-- @param locale (string)
-- @return workflow (table)
function Musician.TRP3E.GetWorkflow(songData, locale)
	return {
		ST = {
			-- Set the variable containing the song data
			['1'] = {
				e = {
					{
						id = 'var_object',
						-- Song data needs to be encoded for chat channels to avoid breaking transfer and export in TRP
						args = { 'w', '[=]', Musician.TRP3E.VARIABLE_NAME, LibDeflate:EncodeForWoWChatChannel(songData) },
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
							string.gsub(Musician.Utils.GetMsg('TRPE_ITEM_MUSICIAN_NOT_FOUND', locale), '{url}', Musician.Utils.Highlight(Musician.URL, '00FFFF')),
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
						args = { 'SFX',	Musician.TRP3E.ITEM_ERROR_SOUND },
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
	return object.TY == TRP3_DB.types.ITEM and object.SC ~= nil and object.SC[Musician.TRP3E.WORKFLOW_NAME] ~= nil
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

