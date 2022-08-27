--- Live keyboard window
-- @module Musician.Keyboard

Musician.Keyboard = LibStub("AceAddon-3.0"):NewAddon("Musician.Keyboard", "AceEvent-3.0")

local MODULE_NAME = "Keyboard"
Musician.AddModule(MODULE_NAME)

local LAYER = Musician.KEYBOARD_LAYER
local KEY = Musician.KEYBOARD_KEY

local KEY_SIZE = 50

local programLedBlinkTime = 0
local isSavingProgram = false
local isDeletingProgram = false
local loadedProgram = nil
local modifiedLayers = {}
local currentMouseButton

local keyButtons = {}
local keyValueButtons = {}
local layouts
local noteButtons

local ICON = {
	["SOLO_MODE"] = Musician.Icons.Headphones,
	["LIVE_MODE"] = Musician.Icons.Speaker
}

local PERCUSSION_ICON = Musician.PercussionIcons
local Percussion = Musician.MIDI_PERCUSSIONS

local LayerNames = {
	[LAYER.UPPER] = "Upper",
	[LAYER.LOWER] = "Lower",
}

local PercussionIconMapping = {
	[Percussion.AcousticBassDrum] = { PERCUSSION_ICON.BassDrum, "1"},
	[Percussion.BassDrum1] = { PERCUSSION_ICON.BassDrum, "2"},
	[Percussion.AcousticSnare] = { PERCUSSION_ICON.Snare, "1"},
	[Percussion.ElectricSnare] = { PERCUSSION_ICON.Snare, "2"},
	[Percussion.SideStick] = { PERCUSSION_ICON.SideStick, ""},
	[Percussion.LowFloorTom] = { PERCUSSION_ICON.FloorTom, "1"},
	[Percussion.HighFloorTom] = { PERCUSSION_ICON.FloorTom, "2"},
	[Percussion.LowTom] = { PERCUSSION_ICON.MidTom, "1"},
	[Percussion.LowMidTom] = { PERCUSSION_ICON.MidTom, "2"},
	[Percussion.HiMidTom] = { PERCUSSION_ICON.HighTom, "1"},
	[Percussion.HighTom] = { PERCUSSION_ICON.HighTom, "2"},
	[Percussion.ClosedHiHat] = { PERCUSSION_ICON.ClosedHiHat, ""},
	[Percussion.PedalHiHat] = { PERCUSSION_ICON.PedalHiHat, ""},
	[Percussion.OpenHiHat] = { PERCUSSION_ICON.OpenHiHat, ""},
	[Percussion.CrashCymbal1] = { PERCUSSION_ICON.CrashCymbal, "1"},
	[Percussion.CrashCymbal2] = { PERCUSSION_ICON.CrashCymbal, "2"},
	[Percussion.RideCymbal1] = { PERCUSSION_ICON.RideCymbal, "1"},
	[Percussion.RideCymbal2] = { PERCUSSION_ICON.RideCymbal, "2"},
	[Percussion.RideBell] = { PERCUSSION_ICON.RideBell, ""},
	[Percussion.Tambourine] = { PERCUSSION_ICON.Tambourine, ""},
	[Percussion.Maracas] = { PERCUSSION_ICON.Maracas, ""},
	[Percussion.HandClap] = { PERCUSSION_ICON.HandClap, ""},
}

local FunctionKeys = {
	KEY.F1,
	KEY.F2,
	KEY.F3,
	KEY.F4,
	KEY.F5,
	KEY.F6,
	KEY.F7,
	KEY.F8,
	KEY.F9,
	KEY.F10,
	KEY.F11,
	KEY.F12,
}

local ProgramKeys = {
	[KEY.F1] = 1,
	[KEY.F2] = 2,
	[KEY.F3] = 3,
	[KEY.F4] = 4,
	[KEY.F5] = 5,
	[KEY.F6] = 6,
	[KEY.F7] = 7,
	[KEY.F8] = 8,
	[KEY.F9] = 9,
	[KEY.F10] = 10,
	[KEY.F11] = 11,
	[KEY.F12] = 12,
}

--- Return the binding button for the given physical key.
-- @param key (string)
-- @return (Button)
local getKeyButton = function(key)
	return _G["MusicianKeyboardKeys" .. key .. "Button"]
end

--- Return the binding button for the given physical function key.
-- @param key (string)
-- @return (Button)
local getFunctionKeyButton = function(key)
	return _G["MusicianKeyboardProgramKeys" .. key .. "Button"]
end

--- Update function key button LEDs
-- @param[opt] blinkTime (number)
-- @param[opt=false] isDeleting (boolean) True when deleting the program
local function updateFunctionKeysLEDs(blinkTime, isDeleting)
	for _, key in pairs(FunctionKeys) do
		local program = ProgramKeys[key]
		local button = getFunctionKeyButton(key)

		if isDeleting then
			button.led:SetVertexColor(1, .15, 0, 1)
		else
			button.led:SetVertexColor(.33, 1, 0, 1)
		end

		if blinkTime ~= nil and (not(isDeleting) or Musician.Keyboard.HasSavedProgram(program)) then
			button.led:SetAlpha(abs(1 - 2 * (4 * blinkTime % 1)))
		else
			if Musician.Keyboard.HasSavedProgram(program) then
				if Musician.Keyboard.IsCurrentProgram(program) then
					button.led:SetAlpha(1)
				else
					button.led:SetAlpha(.25)
				end
			else
				button.led:SetAlpha(0)
			end
		end
	end
end

--- Update function key buttons
--
local function updateFunctionKeys()
	for _, key in pairs(FunctionKeys) do
		local label
		if Musician.Keyboard.IsSavingProgram() then
			label = Musician.Msg.SAVE_PROGRAM_NUM
		elseif Musician_Settings.keyboardPrograms and Musician_Settings.keyboardPrograms[ProgramKeys[key]] then
			if Musician.Keyboard.IsDeletingProgram() then
				label = Musician.Msg.DELETE_PROGRAM_NUM
			else
				label = Musician.Msg.LOAD_PROGRAM_NUM
			end
		else
			label = Musician.Msg.EMPTY_PROGRAM
		end

		label = string.gsub(label, "{num}", ProgramKeys[key])
		label = string.gsub(label, "{key}", key)
		getFunctionKeyButton(key).tooltipText = label
	end

	updateFunctionKeysLEDs()
end

--- Apply widget scripts to virtual keyboard buttons
--
local function extendButton(button)
	button.SuperOnMouseDown = button:GetScript('OnMouseDown')
	button.SuperOnMouseUp = button:GetScript('OnMouseUp')
	button:SetScript("OnMouseDown", Musician.Keyboard.OnVirtualKeyMouseDown)
	button:SetScript("OnMouseUp", Musician.Keyboard.OnVirtualKeyMouseUp)
	button:HookScript("OnEnter", Musician.Keyboard.OnVirtualKeyEnter)
	button:HookScript("OnLeave", Musician.Keyboard.OnVirtualKeyLeave)
end

--- Create the keyboard keys.
--
local function generateKeys()

	-- Size container
	MusicianKeyboardKeys:SetHeight(4.5 * KEY_SIZE)
	MusicianKeyboardKeys:SetWidth(15 * KEY_SIZE)

	-- Create keys
	for row, rowKeys in pairs(Musician.KEYBOARD) do
		for col, key in pairs(rowKeys) do
			local button = CreateFrame("Button", "$parent" .. key .. "Button", MusicianKeyboardKeys, "MusicianKeyboardKeyTemplate")
			extendButton(button)
			table.insert(keyButtons, button)
			button.key = key
			button.row = row
			button.col = col
			button.index = #keyButtons
			button.volumeMeter = Musician.VolumeMeter.create()
		end
	end

	-- Create function keys
	for col, key in pairs(FunctionKeys) do
		local button = CreateFrame("Button", "$parent" .. key .. "Button", MusicianKeyboardProgramKeys, "MusicianProgramKeyTemplate")
		extendButton(button)
		table.insert(keyButtons, button)
		button.key = key
		button.col = col
		button.index = #keyButtons
	end

	-- Init Program write key
	local writeProgramButton = MusicianKeyboardProgramKeysWriteProgram
	writeProgramButton.SuperOnMouseDown = writeProgramButton:GetScript('OnMouseDown')
	writeProgramButton.SuperOnMouseUp = writeProgramButton:GetScript('OnMouseUp')

	-- Init Program delete  key
	local deleteProgramButton = MusicianKeyboardProgramKeysDeleteProgram
	deleteProgramButton.SuperOnMouseDown = deleteProgramButton:GetScript('OnMouseDown')
	deleteProgramButton.SuperOnMouseUp = deleteProgramButton:GetScript('OnMouseUp')
end

--- Set keyboard keys (notes, color etc)
--
local function setKeys()
	local config = Musician.Keyboard.config

	keyValueButtons = {}
	noteButtons	= {
		[LAYER.LOWER] = {},
		[LAYER.UPPER] = {}
	}

	-- Set keyboard keys
	for row, rowKeys in pairs(Musician.KEYBOARD) do
		local cursorX = 0
		for col, key in pairs(rowKeys) do
			local size = Musician.KEYBOARD_KEY_SIZE[row][col]
			local keyHeight = 1
			local keyWidth = size
			local keyX = cursorX
			local keyY = -(row - 1)
			local keyVisible = true
			local keyValueName = Musician.KeyboardUtils.GetKeyName(key)
			local keyValue = Musician.KeyboardUtils.GetKeyValue(key)

			local button = getKeyButton(key)
			button.keyValue = keyValue

			if keyValue then
				keyValueButtons[keyValue] = button
			end

			local keyData = Musician.Keyboard.mapping[key]

			if keyData ~= nil or keyValueName then
				-- Ket key and note names
				local noteName = ""
				local percussionIcon = ""
				local percussionIconNumber = ""

				if keyValue then
					keyValueName = Musician.KeyboardUtils.GetKeyValueName(keyValue)
				end

				if keyData ~= nil and keyData[2] >= Musician.MIN_KEY and keyData[2] <= Musician.MAX_KEY and not(Musician.DISABLED_KEYS[key]) and Musician.KeyboardUtils.GetKeyValue(key) then
					local instrumentName = Musician.Sampler.GetInstrumentName(config.instrument[keyData[1]])
					local r, g, b = unpack(Musician.INSTRUMENTS[instrumentName].color)
					local isPercussion = config.instrument[keyData[1]] >= 128

					if not(isPercussion) then
						noteName = Musician.Sampler.NoteName(keyData[2])

						-- Black or white key
						if string.match(noteName, "[%#b]") then
							r = r / 4
							g = g / 4
							b = b / 4
						end
					else
						percussionIcon = PercussionIconMapping[keyData[2]][1]
						percussionIconNumber = PercussionIconMapping[keyData[2]][2]
					end

					button.background:SetColorTexture(r, g, b, 1)
					button:Enable()
					button:SetAlpha(1)

					if isPercussion then
						button.tooltipText = Musician.Msg.MIDI_PERCUSSION_NAMES[keyData[2]]
					else
						button.tooltipText = nil
					end

					noteButtons[keyData[1]][keyData[2]] = button
				else
					button.background:SetColorTexture(0, 0, 0, 0)
					button:Disable()
					button:SetAlpha(.25)
					button.tooltipText = nil
				end

				-- Set specific key sizes and positions
				if key == KEY.IntlYen and keyValue == "BACKSPACE" then
					keyWidth = keyWidth + Musician.KEYBOARD_KEY_SIZE[row][col + 1]
				elseif key == KEY.Backspace and Musician.KeyboardUtils.GetKeyValue(KEY.IntlYen) == "BACKSPACE" then
					keyVisible = false
				elseif key == KEY.Backslash1 and keyValue == "ENTER" then
					keyWidth = Musician.KEYBOARD_KEY_SIZE[row + 1][col]
					keyX = keyX + Musician.KEYBOARD_KEY_SIZE[row][col] - keyWidth
					keyHeight = 2
				elseif key == KEY.Enter and Musician.KeyboardUtils.GetKeyValue(KEY.Backslash1) == "ENTER" then
					keyVisible = false
				elseif key == KEY.Backslash2 and keyValue == "ENTER" then
					keyWidth = keyWidth + Musician.KEYBOARD_KEY_SIZE[row][col + 1]
				elseif key == KEY.Enter and Musician.KeyboardUtils.GetKeyValue(KEY.Backslash2) == "ENTER" then
					keyVisible = false
				elseif key == KEY.ShiftLeft and Musician.KeyboardUtils.GetKeyValue(KEY.IntlBackslash) == "LSHIFT" then
					keyVisible = false
				elseif key == KEY.ShiftLeft and not(Musician.KeyboardUtils.GetKeyValue(KEY.IntlBackslash)) then
					keyWidth = keyWidth + Musician.KEYBOARD_KEY_SIZE[row][col + 1]
				elseif key == KEY.IntlBackslash and not(keyValue) then
					keyX = keyX - keyWidth
					keyVisible = false
				elseif key == KEY.IntlBackslash and keyValue == "LSHIFT" then
					keyWidth = keyWidth + Musician.KEYBOARD_KEY_SIZE[row][col - 1]
					keyX = keyX - Musician.KEYBOARD_KEY_SIZE[row][col - 1]
				elseif key == KEY.IntlRo and keyValue == "RSHIFT" then
					keyWidth = keyWidth + Musician.KEYBOARD_KEY_SIZE[row][col + 1]
				elseif key == KEY.IntlRo and not(keyValue) then
					keyVisible = false
				elseif key == KEY.ShiftRight and Musician.KeyboardUtils.GetKeyValue(KEY.IntlRo) == "RSHIFT" then
					keyVisible = false
				elseif key == KEY.ShiftRight and not(Musician.KeyboardUtils.GetKeyValue(KEY.IntlRo)) then
					keyWidth = keyWidth + Musician.KEYBOARD_KEY_SIZE[row][col - 1]
					keyX = keyX - Musician.KEYBOARD_KEY_SIZE[row][col - 1]
				end

				-- Set size and position
				button:SetWidth(keyWidth * KEY_SIZE)
				button:SetHeight(keyHeight * KEY_SIZE)
				button:SetPoint("TOPLEFT", MusicianKeyboardKeys, "TOPLEFT", keyX * KEY_SIZE, keyY * KEY_SIZE)

				-- Set text
				button:SetText(noteName)
				button.percussionIcon:SetText(percussionIcon)
				button.percussionIconNumber:SetText(percussionIconNumber)
				button.subText:SetText(keyValueName)
			else
				keyVisible = false
			end

			-- Handle last row and spacebar for sustain
			if row == #Musician.KEYBOARD then
				button:SetHeight(KEY_SIZE / 2)
				if keyValue == 'SPACE' then
					keyVisible = true
					button.tooltipText = nil
					button.subText:SetText('')
					button.Text:SetAllPoints(button)
					button:SetText(string.gsub(Musician.Msg.SUSTAIN_KEY, '{key}', keyValueName))
					button:SetNormalFontObject(GameFontNormal)
					button:SetDisabledFontObject(GameFontDisable)
					button:SetHighlightFontObject(GameFontHighlight)
					button.background:SetColorTexture(.8, 0, 0, 1)
					button:SetAlpha(1)
					button:Enable()
				else
					keyVisible = false
				end
			end

			if keyVisible then
				button:Show()
			else
				button:Hide()
			end

			cursorX = keyX + keyWidth
		end
	end

	-- Set function keys
	local functionKeyWidth = (MusicianKeyboardProgramKeys:GetWidth() - MusicianKeyboardProgramKeysWriteProgram:GetWidth() - MusicianKeyboardProgramKeysDeleteProgram:GetWidth()) / 12
	local keyX = 0
	for _, key in pairs(FunctionKeys) do
		local button = getFunctionKeyButton(key)
		local keyValue = Musician.KeyboardUtils.GetKeyValue(key)

		button.keyValue = keyValue
		if keyValue then
			keyValueButtons[keyValue] = button
		end

		button:Enable()
		button:SetAlpha(1)
		button:SetWidth(functionKeyWidth)
		button:SetHeight(MusicianKeyboardProgramKeysWriteProgram:GetHeight())
		button:SetPoint("TOPLEFT", MusicianKeyboardProgramKeys, "TOPLEFT", keyX, 0)
		button:SetText(string.gsub(Musician.Msg.PROGRAM_BUTTON, "{num}", ProgramKeys[key]))

		keyX = keyX + button:GetWidth()
	end
	updateFunctionKeys()

	-- Set Write program button
	keyValueButtons[KEY.WriteProgram] = MusicianKeyboardProgramKeysWriteProgram
	MusicianKeyboardProgramKeysWriteProgram.keyValue = KEY.WriteProgram

	-- Set Delete program button
	keyValueButtons[KEY.Delete] = MusicianKeyboardProgramKeysDeleteProgram
	MusicianKeyboardProgramKeysDeleteProgram.keyValue = KEY.Delete
end

--- Initialize layout list
--
local function initLayouts()
	local layoutCollections = {
		{ Musician.PianoLayout },
		Musician.HorizontalLayouts,
		Musician.VerticalLayouts
	}

	layouts = {}
	for _, collection in pairs(layoutCollections) do
		for _, layout in pairs(collection) do
			table.insert(layouts, layout)
			layout.index = #layouts
		end
	end
end

--- Initialize layout dropdown
--
local function initLayoutDropdown()
	local menu = {}
	table.insert(menu, {
		text = Musician.Msg.KEYBOARD_LAYOUTS[Musician.PianoLayout.name] or Musician.PianoLayout.name,
		value = Musician.PianoLayout
	})

	local horizontalMenu = {
		text = Musician.Msg.HORIZONTAL_LAYOUT,
		menuList = {}
	}
	table.insert(menu, horizontalMenu)

	local verticalMenu = {
		text = Musician.Msg.VERTICAL_LAYOUT,
		menuList = {}
	}
	table.insert(menu, verticalMenu)

	for _, layout in pairs(Musician.HorizontalLayouts) do
		table.insert(horizontalMenu.menuList, {
			text = Musician.Msg.KEYBOARD_LAYOUTS[layout.name] or layout.name,
			value = layout
		})
	end
	for _, layout in pairs(Musician.VerticalLayouts) do
		table.insert(verticalMenu.menuList, {
			text = Musician.Msg.KEYBOARD_LAYOUTS[layout.name] or layout.name,
			value = layout
		})
	end

	local dropdown = MusicianKeyboardControlsMainLayoutDropdown

	MSA_DropDownMenu_Initialize(dropdown, function(self, level, menuList)
		local info = MSA_DropDownMenu_CreateInfo()
		if (level or 1) == 1 then
			for _, row in pairs(menu) do
				info.text = row.text
				info.isTitle = row.value and row.value.scale == nil
				info.notCheckable = false
				info.hasArrow = row.menuList ~= nil
				info.arg1 = row.value and row.value.index
				info.func = row.value and self.SetValue
				info.menuList = row.menuList
				info.checked = row.value and row.value.index == Musician.Keyboard.config.layout
				MSA_DropDownMenu_AddButton(info)
			end
		else
			info.func = self.SetValue
			for _, row in pairs(menuList) do
				info.text = row.text
				info.isTitle = row.value.scale == nil
				info.notCheckable = info.isTitle
				info.disabled = info.isTitle
				info.hasArrow = false
				info.arg1 = row.value and row.value.index
				info.checked = row.value and row.value.index == Musician.Keyboard.config.layout
				MSA_DropDownMenu_AddButton(info, level)
			end
		end
	end)

	function dropdown:SetValue(layoutIndex)
		Musician.Keyboard.SetLayout(layoutIndex)
		MSA_CloseDropDownMenus()
	end

	MSA_DropDownList1:SetClampedToScreen(true)
	MSA_DropDownList2:SetClampedToScreen(true)

	local layout = layouts[Musician.Keyboard.config.layout]
	MSA_DropDownMenu_SetText(dropdown, Musician.Msg.KEYBOARD_LAYOUTS[layout.name] or layout.name)
end

--- Initialize base key dropdown
--
local function initBaseKeyDropdown()
	local dropdown = MusicianKeyboardControlsMainBaseKeyDropdown

	MSA_DropDownMenu_Initialize(dropdown, function(self)
		local info = MSA_DropDownMenu_CreateInfo()
		info.func = self.SetValue

		for key = 0, 11, 1 do
			local name = Musician.NOTE_NAMES[key]
			info.text = name
			info.arg1 = key
			info.checked = key == Musician.Keyboard.config.baseKey
			MSA_DropDownMenu_AddButton(info)
		end
	end)

	function dropdown:SetValue(key)
		Musician.Keyboard.SetBaseKey(key)
		MSA_CloseDropDownMenus()
	end

	MSA_DropDownList1:SetClampedToScreen(true)
	MSA_DropDownMenu_SetText(dropdown, Musician.NOTE_NAMES[Musician.Keyboard.config.baseKey])
end

--- Init controls for a layer
-- @param layer (int)
local function initLayerControls(layer)
	local varNamePrefix = "MusicianKeyboardControls" .. LayerNames[layer]
	local config = Musician.Keyboard.config
	local instrument = config.instrument[layer]
	local dropdownTooltipText

	if layer == LAYER.LOWER then
		dropdownTooltipText = Musician.Msg.CHANGE_LOWER_INSTRUMENT
	elseif layer == LAYER.UPPER then
		dropdownTooltipText = Musician.Msg.CHANGE_UPPER_INSTRUMENT
	end

	-- Instrument selector
	_G[varNamePrefix .. "Instrument"].OnChange = function(newInstrument)
		Musician.Keyboard.SetInstrument(layer, newInstrument)
	end
	_G[varNamePrefix .. "Instrument"].SetValue(instrument)
	_G[varNamePrefix .. "Instrument"].tooltipText = dropdownTooltipText

	-- Keys shift buttons
	_G[varNamePrefix .. "ShiftLeft"]:SetScript("OnClick", function()
		Musician.Keyboard.ShiftKeys(layer, -layouts[config.layout].shift)
	end)
	_G[varNamePrefix .. "ShiftRight"]:SetScript("OnClick", function()
		Musician.Keyboard.ShiftKeys(layer, layouts[config.layout].shift)
	end)
	_G[varNamePrefix .. "ShiftDown"]:SetScript("OnClick", function()
		Musician.Keyboard.ShiftKeys(layer, #layouts[config.layout].scale)
	end)
	_G[varNamePrefix .. "ShiftUp"]:SetScript("OnClick", function()
		Musician.Keyboard.ShiftKeys(layer, -#layouts[config.layout].scale)
	end)
	_G[varNamePrefix .. "ShiftReset"]:SetScript("OnClick", function()
		Musician.Keyboard.SetKeyShift(layer, 0)
	end)

	-- Power chords
	_G[varNamePrefix .. "PowerChords"]:HookScript('OnClick', function(checkButton)
		Musician.Keyboard.SetPowerChords(layer, checkButton:GetChecked())
	end)
	_G[varNamePrefix .. "PowerChords"]:SetChecked(Musician.Keyboard.config.powerChords[layer])
end

--- Update texts and icons for live and solo modes
--
local function updateLiveModeButton()
	local button = MusicianKeyboardLiveModeButton

	if Musician.Live.IsLiveEnabled() and Musician.Live.CanStream() then
		button.led:SetAlpha(1)
		button.tooltipText = Musician.Msg.ENABLE_SOLO_MODE
	else
		button.led:SetAlpha(0)
		button.tooltipText = Musician.Msg.ENABLE_LIVE_MODE
	end

	if Musician.Live.IsLiveEnabled() and Musician.Live.CanStream() then
		MusicianKeyboardTitle:SetText(Musician.Msg.PLAY_LIVE)
		MusicianKeyboardTitleIcon:SetText(ICON.LIVE_MODE)
	else
		MusicianKeyboardTitle:SetText(Musician.Msg.PLAY_SOLO)
		MusicianKeyboardTitleIcon:SetText(ICON.SOLO_MODE)
	end

	if not(Musician.Live.CanStream()) then
		button:Disable()
		button.tooltipText = Musician.Msg.LIVE_MODE_DISABLED
	else
		button:Enable()
	end
end

--- Init live mode button
--
local function initLiveModeButton()
	local button = MusicianKeyboardLiveModeButton

	button:SetScript("OnClick", function()
		Musician.Live.EnableLive(not(Musician.Live.IsLiveEnabled()))
		PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
	end)

	updateLiveModeButton()

	Musician.Keyboard:RegisterMessage(Musician.Events.LiveModeChange, updateLiveModeButton)
end

--- Enable or disable layer controls
-- @param layer (number)
-- @param enable (boolean)
local function enableLayerControls(layer, enable)
	local controlNames = { "ShiftRight", "ShiftLeft", "ShiftUp", "ShiftDown", "ShiftReset", "PowerChords" }
	local layerVarName = "MusicianKeyboardControls" .. LayerNames[layer]

	for _, controlName in pairs(controlNames) do
		if enable then
			_G[layerVarName .. controlName]:Enable()
		else
			_G[layerVarName .. controlName]:Disable()
		end
	end
end

--- Initialize keyboard
--
function Musician.Keyboard.Init()

	-- Base parameters
	Musician.Keyboard.config = {
		layout = Musician.DEFAULT_LAYOUT,
		instrument = {
			[LAYER.UPPER] = Musician.MIDI_INSTRUMENTS.AcousticGuitarNylon,
			[LAYER.LOWER] = Musician.MIDI_INSTRUMENTS.AcousticGuitarNylon,
		},
		shift = {
			[LAYER.UPPER] = 0,
			[LAYER.LOWER] = 0,
		},
		baseKey = 0,
		powerChords = {
			[LAYER.UPPER] = false,
			[LAYER.LOWER] = false,
		},
		demoTrackMapping = nil,
	}

	-- Set scripts
	MusicianKeyboard:SetScript("OnKeyDown", Musician.Keyboard.OnPhysicalKeyDown)
	MusicianKeyboard:SetScript("OnKeyUp", Musician.Keyboard.OnPhysicalKeyUp)
	Musician.Keyboard:RegisterMessage(Musician.Events.Frame, Musician.Keyboard.OnFrame)
	Musician.Keyboard:RegisterMessage(Musician.Events.LiveNoteOn, Musician.Keyboard.OnLiveNoteOn)
	Musician.Keyboard:RegisterMessage(Musician.Events.LiveNoteOff, Musician.Keyboard.OnLiveNoteOff)
	Musician.Keyboard:RegisterMessage(Musician.Events.NoteOn, Musician.Keyboard.OnNoteOn)
	Musician.Keyboard:RegisterMessage(Musician.Events.NoteOff, Musician.Keyboard.OnNoteOff)
	Musician.Keyboard:RegisterMessage(Musician.Events.SongPlay, Musician.Keyboard.OnSongPlay)
	Musician.Keyboard:RegisterMessage(Musician.Events.SongInstrumentChange, Musician.Keyboard.OnSongPlay)
	Musician.Keyboard:RegisterMessage(Musician.Events.LiveBandSync, Musician.Keyboard.OnLiveBandSync)
	Musician.Keyboard:RegisterEvent("GROUP_ROSTER_UPDATE", Musician.Keyboard.UpdateBandSyncButton)

	-- Init layouts
	initLayouts()

	-- Generate keyboard keys
	generateKeys()

	-- Generate dropdowns
	initLayoutDropdown()
	initBaseKeyDropdown()

	-- Init controls
	initLayerControls(LAYER.LOWER)
	initLayerControls(LAYER.UPPER)
	initLiveModeButton()

	Musician.Keyboard.BuildMapping()
	updateFunctionKeys()

	-- Show or hide keyboard according to last settings
	MusicianKeyboard.showKeyboard(Musician_Settings.keyboardVisible)

	-- Update band sync button
	Musician.Keyboard.UpdateBandSyncButton()
end

--- Show
--
function Musician.Keyboard.Show()
	if not(Musician.KeyboardUtils.KeyboardIsConfigured()) then
		Musician.Utils.Popup(Musician.Msg.SHOULD_CONFIGURE_KEYBOARD, function() MusicianKeyboardConfig:Show() end)
		Musician.KeyboardConfig.showKeyboardOnComplete = true
	else
		Musician.KeyboardConfig.showKeyboardOnComplete = false
		MusicianKeyboard:Show()
	end
end

--- OnFrame
-- @param event (string)
-- @param elapsed (boolean)
function Musician.Keyboard.OnFrame(event, elapsed)
	-- Make program key LEDs blink when saving or deleting a program
	if Musician.Keyboard.IsSavingProgram() or Musician.Keyboard.IsDeletingProgram() then
		programLedBlinkTime = programLedBlinkTime + elapsed
		updateFunctionKeysLEDs(programLedBlinkTime, Musician.Keyboard.IsDeletingProgram())
	end

	-- Key glow
	for _, buttons in pairs(noteButtons) do
		for _, button in pairs(buttons) do
			button.volumeMeter:AddElapsed(elapsed)
			button.glowColor:SetAlpha(button.volumeMeter:GetLevel() * 1)
		end
	end
end

--- OnLiveNoteOn
-- @param event (string)
-- @param key (number)
-- @param layer (number)
-- @param instrumentData (table)
-- @param isChordNote (boolean)
-- @param source (table)
function Musician.Keyboard.OnLiveNoteOn(event, key, layer, instrumentData, isChordNote, source)
	if source ~= MusicianKeyboard then return end

	local button = noteButtons[layer] and noteButtons[layer][key]

	if not(button) then
		return
	end

	-- Set glow color
	local r, g, b = unpack(Musician.INSTRUMENTS[Musician.Sampler.GetInstrumentName(instrumentData.midi)].color)
	local addedLuminance = .5
	r = min(1, r + addedLuminance)
	g = min(1, g + addedLuminance)
	b = min(1, b + addedLuminance)
	button.glowColor:SetColorTexture(r, g, b, 1)

	button.volumeMeter:NoteOn(instrumentData, key)
	button.volumeMeter.gain = isChordNote and .5 or 1 -- Make auto-chord notes dimmer
	button.volumeMeter.entropy = button.volumeMeter.entropy / 2
end

--- OnLiveNoteOff
-- @param event (string)
-- @param key (number)
-- @param layer (number)
-- @param isChordNote (boolean)
-- @param source (table)
function Musician.Keyboard.OnLiveNoteOff(event, key, layer, isChordNote, source)
	if source ~= MusicianKeyboard then return end

	local button = noteButtons[layer] and noteButtons[layer][key]

	if not(button) then
		return
	end

	button.volumeMeter:NoteOff()
end

--- OnPhysicalKeyDown
-- @param event (string)
-- @param keyValue (string)
function Musician.Keyboard.OnPhysicalKeyDown(event, keyValue)
	Musician.Keyboard.OnPhysicalKey(keyValue, true)
end

--- OnPhysicalKeyUp
-- @param event (string)
-- @param keyValue (string)
function Musician.Keyboard.OnPhysicalKeyUp(event, keyValue)
	Musician.Keyboard.OnPhysicalKey(keyValue, false)
end

--- Key up/down handler, from physical keyboard
-- @param keyValue (string)
-- @param down (boolean)
function Musician.Keyboard.OnPhysicalKey(keyValue, down)

	if Musician.Keyboard.SpecialActionKey(down, keyValue) then
		MusicianKeyboard:SetPropagateKeyboardInput(false)
		return
	end

	MusicianKeyboard:SetPropagateKeyboardInput(true)

	-- Grab virtual keyboard key button
	local button = keyValueButtons[keyValue]
	if not(button) then	return end

	-- Call handler if up/down status changes
	local wasDown = button.keyDown and not(button.mouseDown)
	local wasUp = not(button.keyDown) and not(button.mouseDown)
	button.keyDown = down
	if not(down) and wasDown or down and wasUp then
		if Musician.Keyboard.OnKey(keyValue, down) then
			Musician.Keyboard.SetButtonState(button, down)
			MusicianKeyboard:SetPropagateKeyboardInput(false)
		end
	else
		MusicianKeyboard:SetPropagateKeyboardInput(false)
	end
end

--- Virtual keyboard button mouse down handler
--
function Musician.Keyboard.OnVirtualKeyMouseDown()
	if currentMouseButton and IsMouseButtonDown() then
		Musician.Keyboard.OnVirtualKey(currentMouseButton, true)
	end
end

--- Virtual keyboard button mouse up handler
--
function Musician.Keyboard.OnVirtualKeyMouseUp()
	if currentMouseButton and not(IsMouseButtonDown()) then
		Musician.Keyboard.OnVirtualKey(currentMouseButton, false)
	end
end

--- Virtual keyboard button mouse enter handler
-- @param button (Button)
function Musician.Keyboard.OnVirtualKeyEnter(button)
	currentMouseButton = button
	if IsMouseButtonDown() then
		Musician.Keyboard.OnVirtualKey(button, true)
	end
end

--- Virtual keyboard button mouse leave handler
-- @param button (Button)
function Musician.Keyboard.OnVirtualKeyLeave(button)
	if currentMouseButton and IsMouseButtonDown() then
		Musician.Keyboard.OnVirtualKey(button, false)
	end
	currentMouseButton = nil
end

--- Key up/down handler, from virtual keyboard
-- @param button (Button)
-- @param down (boolean)
function Musician.Keyboard.OnVirtualKey(button, down)
	local wasDown = not(button.keyDown) and button.mouseDown
	local wasUp = not(button.keyDown) and not(button.mouseDown)
	button.mouseDown = down
	if not(down) and wasDown or down and wasUp then
		Musician.Keyboard.OnKey(button.keyValue, down)
		Musician.Keyboard.SetButtonState(button, down)
	end
end

--- Set on-screen keyboard button up/down state, without triggering its action.
-- @param button (Button)
-- @param down (boolean)
function Musician.Keyboard.SetButtonState(button, down)
	if not(button) then return end
	button.down = down
	if down then
		if button.SuperOnMouseDown then
			button:SuperOnMouseDown()
		end
		if button.subText and button.subTextPoint then
			local point, relativeTo, relativePoint, xOfs, yOfs = unpack(button.subTextPoint)
			local x, y = button:GetPushedTextOffset()
			button.subText:SetPoint(point, relativeTo, relativePoint, xOfs + x, yOfs + y)
		end
		button:SetButtonState("PUSHED", true)
	else
		if button.SuperOnMouseUp then
			button:SuperOnMouseUp()
		end
		if button.subText and button.subTextPoint then
			button.subText:SetPoint(unpack(button.subTextPoint))
		end
		button:SetButtonState("NORMAL", true)
	end
end

--- Refresh keyboard layers after some settings have been modified, if needed
--
local function refreshKeyboard()

	for layer, refresh in pairs(modifiedLayers) do
		if refresh then
			Musician.Keyboard.ResetButtons(layer)
			Musician.Live.SetSustain(false, layer)
			Musician.Live.AllNotesOff(layer)
		end
	end

	Musician.Keyboard.BuildMapping()
	updateFunctionKeys()

	-- Refresh instrument dropdown tooltips in demo mode
	local config = Musician.Keyboard.config
	if config.demoTrackMapping then
		if config.demoTrackMapping[LAYER.LOWER] then
			MusicianKeyboardControlsLowerInstrument.tooltipText = string.gsub(Musician.Msg.LOWER_INSTRUMENT_MAPPED_TO_CHANNEL, "{track}", config.demoTrackMapping[LAYER.LOWER])
		else
			MusicianKeyboardControlsLowerInstrument.tooltipText = Musician.Msg.CHANGE_LOWER_INSTRUMENT
		end

		if config.demoTrackMapping[LAYER.UPPER] then
			MusicianKeyboardControlsUpperInstrument.tooltipText = string.gsub(Musician.Msg.UPPER_INSTRUMENT_MAPPED_TO_CHANNEL, "{track}", config.demoTrackMapping[LAYER.UPPER])
		else
			MusicianKeyboardControlsUpperInstrument.tooltipText = Musician.Msg.CHANGE_UPPER_INSTRUMENT
		end
	end

	modifiedLayers = {}
end

--- Reset buttons volume meters
-- @param[opt] onlyForLayer (number)
function Musician.Keyboard.ResetButtons(onlyForLayer)
	local layers = (onlyForLayer ~= nil) and { onlyForLayer } or { LAYER.LOWER, LAYER.UPPER }

	if noteButtons then
		for _, layer in pairs(layers) do
			for _, button in pairs(noteButtons[layer]) do
				Musician.Keyboard.SetButtonState(button, button.mouseDown or button.keyDown)
				button.volumeMeter:Reset()
				button.glowColor:SetAlpha(0)
			end
		end
	end
end

--- Key up/down handler, from physical or on-screen keyboard
-- @param keyValue (string)
-- @param down (boolean)
-- @return (boolean) True if the keypress was consumed
function Musician.Keyboard.OnKey(keyValue, down)
	-- Set sustain
	if keyValue == "SPACE" then
		Musician.Keyboard.SetSustain(down)
		return true
	end

	return Musician.Keyboard.NoteKey(down, keyValue) or Musician.Keyboard.FunctionKey(down, keyValue)
end

--- Change keyboard layout
-- @param layoutIndex (number)
-- @param[opt=true] doKeyboardRefresh (boolean) Rebuild key mapping when true
function Musician.Keyboard.SetLayout(layoutIndex, doKeyboardRefresh)
	if Musician.Keyboard.config.layout == layoutIndex then
		return
	end

	local layout = layouts[layoutIndex]

	Musician.Keyboard.config.layout = layoutIndex
	Musician.Keyboard.SetKeyShift(LAYER.UPPER, 0, false)
	Musician.Keyboard.SetKeyShift(LAYER.LOWER, 0, false)
	loadedProgram = nil

	MSA_DropDownMenu_SetText(MusicianKeyboardControlsMainLayoutDropdown, Musician.Msg.KEYBOARD_LAYOUTS[layout.name] or layout.name)

	modifiedLayers = {
		[LAYER.UPPER] = true,
		[LAYER.LOWER] = true
	}

	if doKeyboardRefresh == nil or doKeyboardRefresh then
		refreshKeyboard()
	end
end

--- Change base key
-- @param key (number)
-- @param[opt=true] doKeyboardRefresh (boolean) Rebuild key mapping when true
function Musician.Keyboard.SetBaseKey(key, doKeyboardRefresh)
	if Musician.Keyboard.config.baseKey == key then
		return
	end

	Musician.Keyboard.config.baseKey = key
	loadedProgram = nil

	MSA_DropDownMenu_SetText(MusicianKeyboardControlsMainBaseKeyDropdown, Musician.NOTE_NAMES[key])

	modifiedLayers = {
		[LAYER.UPPER] = true,
		[LAYER.LOWER] = true
	}

	if doKeyboardRefresh == nil or doKeyboardRefresh then
		refreshKeyboard()
	end
end

--- Change Instrument
-- @param layer (number)
-- @param instrument (number)
-- @param[opt=true] doKeyboardRefresh (boolean) Rebuild key mapping when true
function Musician.Keyboard.SetInstrument(layer, instrument, doKeyboardRefresh)
	if Musician.Keyboard.config.instrument[layer] == instrument then
		return
	end

	Musician.Keyboard.config.instrument[layer] = instrument
	loadedProgram = nil

	local uiElementName = "MusicianKeyboardControls"
	if layer == LAYER.LOWER then
		uiElementName = uiElementName .. "LowerInstrument"
	elseif layer == LAYER.UPPER then
		uiElementName = uiElementName .. "UpperInstrument"
	end
	_G[uiElementName].UpdateValue(instrument)
	enableLayerControls(layer, instrument < 128) -- Enable controls if not percussion

	modifiedLayers[layer] = true

	if doKeyboardRefresh == nil or doKeyboardRefresh then
		refreshKeyboard()
	end
end

--- Shift keys
-- @param layer (number)
-- @param amount (number)
-- @param[opt=true] doKeyboardRefresh (boolean) Rebuild key mapping when true
function Musician.Keyboard.ShiftKeys(layer, amount, doKeyboardRefresh)
	local shift = Musician.Keyboard.config.shift[layer] + amount
	Musician.Keyboard.SetKeyShift(layer, shift, doKeyboardRefresh)
end

--- Set key shift amount
-- @param layer (number)
-- @param shift (number) Shift amount
-- @param[opt=true] doKeyboardRefresh (boolean) Rebuild key mapping when true
function Musician.Keyboard.SetKeyShift(layer, shift, doKeyboardRefresh)
	if Musician.Keyboard.config.shift[layer] == shift then
		return
	end

	Musician.Keyboard.config.shift[layer] = shift

	modifiedLayers[layer] = true

	if doKeyboardRefresh == nil or doKeyboardRefresh then
		refreshKeyboard()
	end
end

--- Set power chords \m/
-- @param layer (number)
-- @param enable (boolean)
-- @param[opt=true] doKeyboardRefresh (boolean) Rebuild key mapping when true
function Musician.Keyboard.SetPowerChords(layer, enable, doKeyboardRefresh)
	if Musician.Keyboard.config.powerChords[layer] == enable then
		return
	end

	Musician.Keyboard.config.powerChords[layer] = enable
	loadedProgram = nil

	local uiElementName = "MusicianKeyboardControls"
	if layer == LAYER.LOWER then
		uiElementName = uiElementName .. "LowerPowerChords"
	elseif layer == LAYER.UPPER then
		uiElementName = uiElementName .. "UpperPowerChords"
	end
	_G[uiElementName]:SetChecked(enable)

	modifiedLayers[layer] = true

	if doKeyboardRefresh == nil or doKeyboardRefresh then
		refreshKeyboard()
	end
end

--- Build keyboard mapping from actual configuration
--
function Musician.Keyboard.BuildMapping()

	Musician.Keyboard.mapping = {}

	-- Invalid layout
	if layouts[Musician.Keyboard.config.layout] == nil then
		setKeys()
		return
	end

	--- Map keys for given parameters
	-- @param layer (int) Target layer (lower or upper)
	-- @param scale (table) Notes of the scale to use (0 is the base key)
	-- @param keyboardMapping (table) Table of keyboard keys to use
	-- @param baseKey (int) Base key
	-- @param baseKeyIndex (int) Position of the base key (0 is the first one)
	local function mapKeys(layer, scale, keyboardMapping, baseKey, baseKeyIndex)
		local config = Musician.Keyboard.config
		local scaleIndex = -baseKeyIndex
		local isPercussion = config.instrument[layer] >= 128
		local transpose = not(isPercussion) and config.baseKey or 0

		for _, key in pairs(keyboardMapping) do
			local scaleNote = scale[scaleIndex % #scale + 1]
			if scaleNote ~= -1 then
				local octave = floor(scaleIndex / #scale)
				local note = scaleNote + baseKey + 12 * octave + transpose
				if not(Musician.DISABLED_KEYS[key]) then
					Musician.Keyboard.mapping[key] = { layer, note }
				end
			end
			scaleIndex = scaleIndex + 1
		end
	end

	local layout = layouts[Musician.Keyboard.config.layout]
	local config = Musician.Keyboard.config
	local percussionLayout

	if layout.orientation == Musician.LAYOUT_ORIENTATION.HORIZONTAL then
		percussionLayout = Musician.PercussionHorizontalLayout
	else
		percussionLayout = Musician.PercussionVerticalLayout
	end

	if config.instrument[LAYER.UPPER] >= 128 then
		mapKeys(
			LAYER.UPPER,
			percussionLayout.scale,
			percussionLayout.upper.keyboardMapping,
			Musician.Sampler.NoteKey(percussionLayout.upper.baseKey),
			percussionLayout.upper.baseKeyIndex
		)
	elseif config.instrument[LAYER.UPPER] >= 0 then
		mapKeys(
			LAYER.UPPER,
			layout.scale,
			layout.upper.keyboardMapping,
			Musician.Sampler.NoteKey(layout.upper.baseKey),
			layout.upper.baseKeyIndex + config.shift[LAYER.UPPER]
		)
	end

	if config.instrument[LAYER.LOWER] >= 128 then
		mapKeys(
			LAYER.LOWER,
			percussionLayout.scale,
			percussionLayout.lower.keyboardMapping,
			Musician.Sampler.NoteKey(percussionLayout.lower.baseKey),
			percussionLayout.lower.baseKeyIndex
		)
	elseif config.instrument[LAYER.LOWER] >= 0 then
		mapKeys(
			LAYER.LOWER,
			layout.scale,
			layout.lower.keyboardMapping,
			Musician.Sampler.NoteKey(layout.lower.baseKey),
			layout.lower.baseKeyIndex + config.shift[LAYER.LOWER]
		)
	end

	setKeys()
end

--- Note key pressed
-- @param down (boolean)
-- @param keyValue (string)
-- @return (boolean) True if the keypress was consumed
function Musician.Keyboard.NoteKey(down, keyValue)
	local key = Musician.KeyboardUtils.GetKey(keyValue)

	if key == nil then
		return false
	end

	local button = keyValueButtons[keyValue]
	if not(button.row) or button.row >= 5 then
		return false
	end

	-- Ignore when any modifier key is in action
	if
		IsMacClient() and (IsShiftKeyDown() or keyValue == "LSHIFT" or keyValue == "RSHIFT") or
		IsControlKeyDown() or keyValue == "LCTRL" or keyValue == "RCTRL" or
		IsAltKeyDown() or keyValue == "LALT" or keyValue == "RALT"
	then
		return false
	end

	local note = Musician.Keyboard.mapping[key]

	if note == nil then
		return true
	end

	local layer = note[1]
	local noteKey = note[2]
	local instrument = Musician.Keyboard.config.instrument[layer]
	local powerChords = Musician.Keyboard.config.powerChords[layer] and instrument < 128 -- No power chords for percussions

	if noteKey < Musician.MIN_KEY or noteKey > Musician.MAX_KEY or instrument < 0 then
		return true
	end

	if powerChords then
		Musician.Live.NoteOff(noteKey - 12, layer, instrument, true)
		Musician.Live.NoteOff(noteKey - 5, layer, instrument, true)
	end
	Musician.Live.NoteOff(noteKey, layer, instrument)

	if down then
		if powerChords then
			Musician.Live.NoteOn(noteKey - 12, layer, instrument, true, MusicianKeyboard)
			Musician.Live.NoteOn(noteKey - 5, layer, instrument, true, MusicianKeyboard)
		end
		Musician.Live.NoteOn(noteKey, layer, instrument, false, MusicianKeyboard)
	end

	return true
end

--- Special action key pressed. Physical keyboard only.
-- @param down (boolean)
-- @param keyValue (string)
-- @return (boolean) True if the keypress was consumed
function Musician.Keyboard.SpecialActionKey(down, keyValue)

	-- Override standard Toggle UI to keep the keyboard visible on screen
	if down and GetBindingFromClick(keyValue) == "TOGGLEUI" and not(InCombatLockdown()) then
		Musician.Keyboard.ToggleUI()
		return true
	end

	-- Escape key
	if down and keyValue == "ESCAPE" then
		if Musician.Keyboard.IsSavingProgram() then
			-- Leave saving program mode
			Musician.Keyboard.SetSavingProgram(false)
		elseif Musician.Keyboard.IsDeletingProgram() then
			-- Leave deleting program mode
			Musician.Keyboard.SetDeletingProgram(false)
		else
			-- Hide main window
			MusicianKeyboard:Hide()
		end

		return true
	end

	-- Set deleting program
	if keyValue == "DELETE" then
		Musician.Keyboard.SetSavingProgram(false)
		Musician.Keyboard.SetDeletingProgram(down)
		return true
	end

	-- Set writing program
	local key = Musician.KeyboardUtils.GetKey(keyValue)
	local isControlDown =
		(key == KEY.ControlLeft or key == KEY.ControlRight) and not(IsMacClient()) or
		(key == KEY.ShiftLeft or key == KEY.ShiftRight) and IsMacClient() -- Use Shift instead of Ctrl on MacOS

	if isControlDown or key == KEY.WriteProgram then
		Musician.Keyboard.SetDeletingProgram(false)
		Musician.Keyboard.SetSavingProgram(down)
		return true
	end

	return false
end

--- Function key pressed
-- @param down (boolean)
-- @param keyValue (string)
-- @return (boolean) True if the keypress was consumed
function Musician.Keyboard.FunctionKey(down, keyValue)
	local key = Musician.KeyboardUtils.GetKey(keyValue)

	if key == nil or ProgramKeys[key] == nil then
		return false
	end

	local program = ProgramKeys[key]
	if down then
		if Musician.Keyboard.IsSavingProgram() then
			Musician.Keyboard.SaveProgram(program)
			Musician.Keyboard.SetSavingProgram(false)
		elseif Musician.Keyboard.IsDeletingProgram() then
			Musician.Keyboard.DeleteProgram(program)
			Musician.Keyboard.SetDeletingProgram(false)
		else
			Musician.Keyboard.LoadProgram(program)
		end
	end

	return true
end

--- Set program saving mode
-- @param value (boolean)
function Musician.Keyboard.SetSavingProgram(value)
	if isSavingProgram ~= value then
		programLedBlinkTime = 0
		isSavingProgram = value
		local button = keyValueButtons[KEY.WriteProgram]
		button.keyDown = value
		Musician.Keyboard.SetButtonState(button, value)
		PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
		updateFunctionKeys()
	end
end

--- Set program deleting mode
-- @param value (boolean)
function Musician.Keyboard.SetDeletingProgram(value)
	if isDeletingProgram ~= value then
		programLedBlinkTime = 0
		isDeletingProgram = value
		local button = keyValueButtons[KEY.Delete]
		button.keyDown = value
		Musician.Keyboard.SetButtonState(button, value)
		PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
		updateFunctionKeys()
	end
end

--- Get program saving mode
-- @return (boolean)
function Musician.Keyboard.IsSavingProgram()
	return isSavingProgram
end

--- Get program deleting mode
-- @return (boolean)
function Musician.Keyboard.IsDeletingProgram()
	return isDeletingProgram
end

--- Load configuration
-- @param config (table)
function Musician.Keyboard.LoadConfig(config)
	Musician.Keyboard.SetLayout(config.layout, false)
	Musician.Keyboard.SetBaseKey(config.baseKey, false)
	Musician.Keyboard.SetInstrument(LAYER.UPPER, config.instrument[LAYER.UPPER], false)
	Musician.Keyboard.SetInstrument(LAYER.LOWER, config.instrument[LAYER.LOWER], false)
	Musician.Keyboard.SetKeyShift(LAYER.UPPER, config.shift[LAYER.UPPER], false)
	Musician.Keyboard.SetKeyShift(LAYER.LOWER, config.shift[LAYER.LOWER], false)
	Musician.Keyboard.SetPowerChords(LAYER.UPPER, config.powerChords[LAYER.UPPER], false)
	Musician.Keyboard.SetPowerChords(LAYER.LOWER, config.powerChords[LAYER.LOWER], false)
	Musician.Keyboard.EnableDemoMode(
		config.demoTrackMapping and config.demoTrackMapping[LAYER.UPPER],
		config.demoTrackMapping and config.demoTrackMapping[LAYER.LOWER],
		false
	)
	refreshKeyboard()
end

--- Has saved program
-- @param program (number)
-- @return (boolean)
function Musician.Keyboard.HasSavedProgram(program)
	return Musician_Settings.keyboardPrograms and Musician_Settings.keyboardPrograms[program]
end

--- Indicate if the provided program is the current one that has been loaded
-- @param program (number)
-- @return (boolean)
function Musician.Keyboard.IsCurrentProgram(program)
	return program == loadedProgram
end

--- Return true if a demo song is playing
-- @return (boolean)
local function demoSongIsPlaying()
	local song = Musician.sourceSong
	local config = Musician.Keyboard.config
	return config.demoTrackMapping and song and song:IsPlaying()
end

--- Load saved program
-- @param program (number)
-- @return (boolean)
function Musician.Keyboard.LoadProgram(program)
	if Musician.Keyboard.HasSavedProgram(program) then
		Musician.Keyboard.LoadConfig(Musician_Settings.keyboardPrograms[program])
		loadedProgram = program
		updateFunctionKeys()

		if demoSongIsPlaying() then
			Musician.Keyboard.ConfigureDemo()
		end

		return true
	end

	return false
end

--- Save program
-- @param program (number)
function Musician.Keyboard.SaveProgram(program)
	if Musician_Settings.keyboardPrograms == nil then
		Musician_Settings.keyboardPrograms = {}
	end

	Musician_Settings.keyboardPrograms[program] = Musician.Utils.DeepCopy(Musician.Keyboard.config)
	loadedProgram = program
	Musician.Utils.Print(string.gsub(Musician.Msg.PROGRAM_SAVED, '{num}', Musician.Utils.Highlight(program)))
end

--- Delete a program
-- @param program (number)
function Musician.Keyboard.DeleteProgram(program)
	if Musician_Settings.keyboardPrograms == nil or Musician_Settings.keyboardPrograms[program] == nil then
		return
	end

	wipe(Musician_Settings.keyboardPrograms[program])
	Musician_Settings.keyboardPrograms[program] = nil
	loadedProgram = program
	Musician.Utils.Print(string.gsub(Musician.Msg.PROGRAM_DELETED, '{num}', Musician.Utils.Highlight(program)))
end

--- Toggle UI, keeping the keyboard visible
--
function Musician.Keyboard.ToggleUI()
	ToggleFrame(UIParent)

	-- Update keyboard parent frame to make it visible when the main UI is hidden
	local expectedParent
	if UIParent:IsVisible() then
		expectedParent = UIParent
	else
		expectedParent = WorldFrame
	end

	if MusicianKeyboard:GetParent() ~= expectedParent then
		MusicianKeyboard:SetParent(expectedParent)
		if expectedParent == WorldFrame then
			MusicianKeyboard:SetScale(UIParent:GetScale())
		else
			MusicianKeyboard:SetScale(1)
			MusicianKeyboard:SetFrameStrata("DIALOG")
		end
	end
end

--- Enable demo mode with provided track indexes
-- @param upperTrackIndex (number)
-- @param lowerTrackIndex (number)
-- @param[opt=true] doKeyboardRefresh (boolean) Rebuild key mapping when true
function Musician.Keyboard.EnableDemoMode(upperTrackIndex, lowerTrackIndex, doKeyboardRefresh)
	local config = Musician.Keyboard.config

	local currentUpperTrackIndex = config.demoTrackMapping and config.demoTrackMapping[LAYER.UPPER]
	if currentUpperTrackIndex ~= upperTrackIndex then
		loadedProgram = nil
		if demoSongIsPlaying() then
			modifiedLayers[LAYER.UPPER] = true
		end
	end

	local currentLowerTrackIndex = config.demoTrackMapping and config.demoTrackMapping[LAYER.LOWER]
	if currentLowerTrackIndex ~= lowerTrackIndex then
		loadedProgram = nil
		if demoSongIsPlaying() then
			modifiedLayers[LAYER.LOWER] = true
		end
	end

	if upperTrackIndex == nil and lowerTrackIndex == nil then
		config.demoTrackMapping = nil
	else
		config.demoTrackMapping = {
			[LAYER.UPPER] = upperTrackIndex,
			[LAYER.LOWER] = lowerTrackIndex
		}
	end

	Musician.Keyboard.ConfigureDemo(doKeyboardRefresh)

	if doKeyboardRefresh == nil or doKeyboardRefresh then
		refreshKeyboard()
		if config.demoTrackMapping then
			local mappings = {}
			for layer, trackIndex in pairs(config.demoTrackMapping) do
				local mapping = Musician.Msg.DEMO_MODE_MAPPING
				mapping = string.gsub(mapping, "{layer}", Musician.Utils.Highlight(Musician.Msg.LAYERS[layer]))
				mapping = string.gsub(mapping, "{track}", Musician.Utils.Highlight(trackIndex))
				table.insert(mappings, mapping)
			end
			Musician.Utils.Print(string.gsub(Musician.Msg.DEMO_MODE_ENABLED, "{mapping}", table.concat(mappings, "\n")))
		else
			Musician.Utils.Print(Musician.Msg.DEMO_MODE_DISABLED)
		end
	end
end

--- Disable demo mode
-- @param[opt=true] doKeyboardRefresh (boolean) Rebuild key mapping when true
function Musician.Keyboard.DisableDemoMode(doKeyboardRefresh)
	Musician.Keyboard.EnableDemoMode(nil, nil, doKeyboardRefresh)
end

--- Demo mode OnSongPlay
-- @param event (string)
-- @param song (Musician.Song)
function Musician.Keyboard.OnSongPlay(event, song)
	if song ~= Musician.sourceSong then
		return
	end

	Musician.Keyboard.ConfigureDemo()
end

--- Configure demo mode relatively to the source song
-- @param[opt=true] doKeyboardRefresh (boolean) Rebuild key mapping when true
function Musician.Keyboard.ConfigureDemo(doKeyboardRefresh)
	local song = Musician.sourceSong
	local config = Musician.Keyboard.config

	-- Set instrument and power chords
	if config.demoTrackMapping and song then
		for layer, trackIndex in pairs(config.demoTrackMapping) do
			local track = song.tracks[trackIndex]
			if track ~= nil then
				Musician.Keyboard.SetInstrument(layer, track.instrument, doKeyboardRefresh)
			end
		end
	end

	-- Enable or disable instrument and power chords controls
	for layer, layerName in pairs(LayerNames) do
		local layerVarName = "MusicianKeyboardControls" .. layerName
		if config.demoTrackMapping and config.demoTrackMapping[layer] then
			MSA_DropDownMenu_DisableDropDown(_G[layerVarName .. "Instrument"])
			_G[layerVarName .. "PowerChords"]:Disable()
			Musician.Keyboard.SetPowerChords(layer, false, doKeyboardRefresh)
		else
			MSA_DropDownMenu_EnableDropDown(_G[layerVarName .. "Instrument"])
			_G[layerVarName .. "PowerChords"]:Enable()
		end
	end
end

--- Demo mode OnNoteOn
-- @param event (string)
-- @param song (Musician.Song)
-- @param track (table)
-- @param key (number)
function Musician.Keyboard.OnNoteOn(event, song, track, key)
	local config = Musician.Keyboard.config
	if config.demoTrackMapping == nil or not(Musician.sourceSong) or song ~= Musician.sourceSong then
		return
	end
	Musician.Keyboard.ConfigureDemo()

	local _, instrument = Musician.Sampler.GetSoundFile(track.instrument, key)
	for layer, trackIndex in pairs(config.demoTrackMapping) do
		if trackIndex == track.index then
			local button = noteButtons[layer] and noteButtons[layer][key]
			if button then
				Musician.Keyboard.SetButtonState(button, true)
				Musician.Keyboard.OnLiveNoteOn(event, key, layer, instrument, false, MusicianKeyboard)
			end
		end
	end
end

--- Demo mode OnNoteOff
-- @param event (string)
-- @param song (Musician.Song)
-- @param track (number)
-- @param key (number)
function Musician.Keyboard.OnNoteOff(event, song, track, key)
	local config = Musician.Keyboard.config
	if config.demoTrackMapping == nil or not(Musician.sourceSong) or song ~= Musician.sourceSong then
		return
	end

	for layer, trackIndex in pairs(config.demoTrackMapping) do
		if trackIndex == track.index then
			local button = noteButtons[layer] and noteButtons[layer][key]
			if button then
				Musician.Keyboard.SetButtonState(button, false)
				Musician.Keyboard.OnLiveNoteOff(event, key, layer, false, MusicianKeyboard)
			end
		end
	end
end

--- Update band sync button
--
function Musician.Keyboard.UpdateBandSyncButton()

	-- Update button visibility

	local isVisible = IsInGroup()
	local isEnabled = Musician.Comm.GetGroupChatType() ~= nil

	local button = MusicianKeyboardBandSyncButton
	button:SetShown(isVisible)
	button:SetEnabled(isEnabled)

	-- Update button LED

	MusicianKeyboardBandSyncButton:SetChecked(Musician.Live.IsBandSyncMode())

	-- Update tooltip and the number of ready players

	local players = Musician.Live.GetSyncedBandPlayers()
	local tooltipText = Musician.Msg.LIVE_SYNC

	if not(Musician.Live.IsBandSyncMode()) then
		tooltipText = tooltipText .. "\n" .. Musician.Utils.Highlight(Musician.Msg.LIVE_SYNC_HINT, "00FFFF")
	end

	if #players > 0 then
		button.count.text:SetText(#players)
		button.count:Show()

		local playerNames = {}
		for _, playerName in ipairs(players) do
			table.insert(playerNames, "– " .. Musician.Utils.FormatPlayerName(playerName))
		end

		tooltipText = tooltipText .. "\n" .. Musician.Msg.SYNCED_PLAYERS
		tooltipText = tooltipText .. "\n" .. strjoin("\n", unpack(playerNames))
	else
		button.count:Hide()
	end
	button:SetTooltipText(tooltipText)
end

--- OnLiveBandSync
--
function Musician.Keyboard.OnLiveBandSync(event, player, isSynced)
	-- Display "Is synced" emote in the chat
	if not(Musician.Utils.PlayerIsMyself(player)) then
		local emote = isSynced and Musician.Msg.EMOTE_PLAYER_LIVE_SYNC_ENABLED or Musician.Msg.EMOTE_PLAYER_LIVE_SYNC_DISABLED
		Musician.Utils.DisplayEmote(player, UnitGUID(Musician.Utils.SimplePlayerName(player)), emote)
	end

	-- Update button
	Musician.Keyboard.UpdateBandSyncButton()
end

--- Set sustain
-- @param value (boolean)
function Musician.Keyboard.SetSustain(value)
	local config = Musician.Keyboard.config

	-- Determine if lower and upper instruments are "plucked" like piano, guitar etc.
	local upperIsPlucked = Musician.Sampler.IsInstrumentPlucked(config.instrument[LAYER.UPPER])
	local lowerIsPlucked = Musician.Sampler.IsInstrumentPlucked(config.instrument[LAYER.LOWER])

	-- Do not sustain the non-plucked instrument if the other one is plucked
	if upperIsPlucked ~= lowerIsPlucked then
		Musician.Live.SetSustain(value and upperIsPlucked, LAYER.UPPER)
		Musician.Live.SetSustain(value and lowerIsPlucked, LAYER.LOWER)
	else
		-- Both instruments are either plucked or not: sustain both
		Musician.Live.SetSustain(value, LAYER.UPPER)
		Musician.Live.SetSustain(value, LAYER.LOWER)
	end
end