Musician.Keyboard = LibStub("AceAddon-3.0"):NewAddon("Musician.Keyboard", "AceEvent-3.0")

local LAYER = Musician.KEYBOARD_LAYER
local KEY = Musician.KEYBOARD_KEY

local KEY_SIZE = 50

local lCtrlDown = false
local rCtrlDown = false
local writeProgramDown = false
local savingProgram = false
local savingProgramTime = 0
local loadedProgram = nil

local keyButtons = {}
local keyValueButtons = {}

local ICON = {
	["SOLO_MODE"] = Musician.Icons.Headphones,
	["LIVE_MODE"] = Musician.Icons.Speaker
}

local PERCUSSION_ICON = Musician.PercussionIcons
local Percussion = Musician.MIDI_PERCUSSIONS

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

Musician.Keyboard.NotesOn = {}

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
-- @param [blinkTime] (number)
local function updateFunctionKeysLEDs(blinkTime)
	local key
	for _, key in pairs(FunctionKeys) do
		local program = ProgramKeys[key]
		local button = getFunctionKeyButton(key)

		if blinkTime ~= nil then
			button.led:SetAlpha(abs(1 - 2 * (4 * blinkTime % 1)))
		else
			if MusicianKeyboard.HasSavedProgram(program) then
				if MusicianKeyboard.IsCurrentProgram(program) then
					button.led:SetAlpha(1)
				else
					button.led:SetAlpha(.33)
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
	local label
	if MusicianKeyboard.IsSavingProgram() then
		label = Musician.Msg.SAVE_PROGRAM_NUM
	else
		label = Musician.Msg.LOAD_PROGRAM_NUM
	end

	local key
	for _, key in pairs(FunctionKeys) do
		local programKeyLabel = string.gsub(label, "{num}", ProgramKeys[key])
		getFunctionKeyButton(key).tooltipText = string.gsub(programKeyLabel, "{key}", key)
	end

	updateFunctionKeysLEDs()
end

--- Create the keyboard keys.
--
local function generateKeys()

	-- Size container
	MusicianKeyboardKeys:SetHeight(4 * KEY_SIZE)
	MusicianKeyboardKeys:SetWidth(15 * KEY_SIZE)

	-- Create keys
	local row, col, rowKeys, key
	for row, rowKeys in pairs(Musician.KEYBOARD) do
		for col, key in pairs(rowKeys) do
			local button = CreateFrame("Button", "$parent" .. key .. "Button", MusicianKeyboardKeys, "MusicianKeyboardKeyTemplate")

			table.insert(keyButtons, button)

			button.key = key
			button.row = row
			button.col = col
			button.index = #keyButtons
		end
	end

	-- Create function keys
	local keyX = 0
	for col, key in pairs(FunctionKeys) do
		local button = CreateFrame("Button", "$parent" .. key .. "Button", MusicianKeyboardProgramKeys, "MusicianProgramKeyTemplate")
		table.insert(keyButtons, button)
		button.key = key
		button.col = col
		button.index = #keyButtons
	end
end

--- Set keyboard keys (notes, color etc)
--
local function setKeys()
	local config = Musician.Keyboard.config

	keyValueButtons = {}

	-- Set keyboard keys
	local row, col, rowKeys, key
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
				local isPercussion = false

				if keyValue then
					keyValueName = Musician.KeyboardUtils.GetKeyValueName(keyValue)
				end

				if keyData ~= nil and keyData[2] >= Musician.MIN_KEY and keyData[2] <= Musician.MAX_KEY and not(Musician.DISABLED_KEYS[key]) and Musician.KeyboardUtils.GetKeyValue(key) then
					local instrumentName = Musician.MIDI_INSTRUMENT_MAPPING[config.instrument[keyData[1]]]
					local r, g, b = unpack(Musician.INSTRUMENTS[instrumentName].color)
					isPercussion = config.instrument[keyData[1]] >= 128

					if not(isPercussion) then
						noteName = Musician.Utils.NoteName(keyData[2])

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
				else
					button.background:SetColorTexture(0, 0, 0, 0)
					button:Disable()
					button:SetAlpha(.5)
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

			if keyVisible and row ~= #Musician.KEYBOARD then -- Do not display the last row
				button:Show()
			else
				button:Hide()
			end

			cursorX = keyX + keyWidth
		end
	end

	-- Set function keys
	local keyX = 0
	for col, key in pairs(FunctionKeys) do
		local button = getFunctionKeyButton(key)
		local keyValueName = Musician.KeyboardUtils.GetKeyName(key)
		local keyValue = Musician.KeyboardUtils.GetKeyValue(key)

		button.keyValue = keyValue
		if keyValue then
			keyValueButtons[keyValue] = button
		end

		button:Enable()
		button:SetAlpha(1)

		button:SetWidth(58.5)
		button:SetHeight(24)
		button:SetPoint("TOPLEFT", MusicianKeyboardProgramKeys, "TOPLEFT", keyX, 0)
		button:SetText(string.gsub(Musician.Msg.PROGRAM_BUTTON, "{num}", ProgramKeys[key]))

		keyX = keyX + button:GetWidth()
	end
	updateFunctionKeys()

	-- Set Write program button
	keyValueButtons[KEY.WriteProgram] = MusicianKeyboardProgramKeysWriteProgram
	MusicianKeyboardProgramKeysWriteProgram.keyValue = KEY.WriteProgram
end

--- Initialize a dropdown
-- @param dropdown (UIDropDownMenu)
-- @param values (table)
-- @param labels (table)
-- @param initialValue (string)
-- @param onChange (function)
-- @param tooltipText (string)
local function initDropdown(dropdown, values, labels, initialValue, onChange, tooltipText)
	local initialIndex

	dropdown.value = nil
	dropdown.index = nil
	dropdown.tooltipText = tooltipText

	dropdown.UpdateIndex = function(index)
		dropdown.value = values[index]
		dropdown.index = index
		UIDropDownMenu_SetText(dropdown, labels[index])
	end

	dropdown.SetIndex = function(index)
		dropdown.UpdateIndex(index)
		onChange(dropdown.value)
	end

	dropdown.OnClick = function(self, arg1, arg2, checked)
		dropdown.SetIndex(arg1)
	end

	dropdown.GetItems = function(frame, level, menuList)
		local index, value
		for index, value in pairs(values) do
			local info = UIDropDownMenu_CreateInfo()
			info.func = dropdown.OnClick
			info.text = labels[index]
			if value ~= "" then
				info.arg1 = index
				info.checked = dropdown.value == value
			else
				info.isTitle = true
				info.notCheckable = true
			end
			if value == initialValue then
				initialIndex = index
			end
			UIDropDownMenu_AddButton(info)
		end
	end

	UIDropDownMenu_Initialize(dropdown, dropdown.GetItems)
	dropdown.UpdateIndex(initialIndex)
end

--- Initialize layout dropdown
--
local function initLayoutDropdown()
	local values = {}
	local labels = {}
	local index, layout
	for index, layout in pairs(Musician.Layouts) do
		if layout.scale ~= nil then
			table.insert(values, index)
		else
			table.insert(values, "")
		end
		table.insert(labels, Musician.Msg.KEYBOARD_LAYOUTS[layout.name] or layout.name)
	end

	initDropdown(MusicianKeyboardControlsMainLayoutDropdown, values, labels, Musician.Keyboard.config.layout, Musician.Keyboard.SetLayout, Musician.Msg.CHANGE_KEYBOARD_LAYOUT)
end

--- Initialize base key dropdown
--
local function initBaseKeyDropdown()

	local values = {}
	local labels = {}
	local key
	for key = 0, 11 do
		table.insert(values, key)
		table.insert(labels, Musician.NOTE_NAMES[key])
	end

	initDropdown(MusicianKeyboardControlsMainBaseKeyDropdown, values, labels, Musician.Keyboard.config.baseKey, Musician.Keyboard.SetBaseKey, Musician.Msg.CHANGE_BASE_KEY)
end

--- Init controls for a layer
-- @param layer (int)
local function initLayerControls(layer)
	local varNamePrefix = "MusicianKeyboardControls"
	local config = Musician.Keyboard.config
	local instrument = config.instrument[layer]
	local dropdownTooltipText
	local layout = Musician.Layouts[config.layout]

	if layer == LAYER.LOWER then
		varNamePrefix = varNamePrefix .. "Lower"
		dropdownTooltipText = Musician.Msg.CHANGE_LOWER_INSTRUMENT
	elseif layer == LAYER.UPPER then
		varNamePrefix = varNamePrefix .. "Upper"
		dropdownTooltipText = Musician.Msg.CHANGE_UPPER_INSTRUMENT
	end

	-- Instrument selector
	_G[varNamePrefix .. "Instrument"].OnChange = function(instrument)
		Musician.Keyboard.SetInstrument(layer, instrument)
	end
	_G[varNamePrefix .. "Instrument"].SetValue(instrument)
	_G[varNamePrefix .. "Instrument"].tooltipText = dropdownTooltipText

	-- Keys shift buttons
	_G[varNamePrefix .. "ShiftLeft"]:SetScript("OnClick", function()
		Musician.Keyboard.ShiftKeys(layer, -Musician.Layouts[config.layout].shift)
	end)
	_G[varNamePrefix .. "ShiftRight"]:SetScript("OnClick", function()
		Musician.Keyboard.ShiftKeys(layer, Musician.Layouts[config.layout].shift)
	end)
	_G[varNamePrefix .. "ShiftDown"]:SetScript("OnClick", function()
		Musician.Keyboard.ShiftKeys(layer, #Musician.Layouts[config.layout].scale)
	end)
	_G[varNamePrefix .. "ShiftUp"]:SetScript("OnClick", function()
		Musician.Keyboard.ShiftKeys(layer, -#Musician.Layouts[config.layout].scale)
	end)
	_G[varNamePrefix .. "ShiftReset"]:SetScript("OnClick", function()
		Musician.Keyboard.ShiftKeys(layer)
	end)

	-- Power chords
	_G[varNamePrefix .. "PowerChords"].SetValue = function(self, value)
		Musician.Keyboard.SetPowerChords(layer, value == "1")
	end
	_G[varNamePrefix .. "PowerChords"].SetValue(Musician.Keyboard.config.powerChords[layer])
end

--- Update texts and icons for live and solo modes
--
local function updateLiveModeButton()
	local button = MusicianKeyboardLiveModeButton

	if Musician.Live.IsEnabled() then
		button.icon:SetText(ICON.SOLO_MODE)
		button:SetText(Musician.Msg.SOLO_MODE)
		button.tooltipText = Musician.Msg.ENABLE_SOLO_MODE
	else
		button.icon:SetText(ICON.LIVE_MODE)
		button:SetText(Musician.Msg.LIVE_MODE)
		button.tooltipText = Musician.Msg.ENABLE_LIVE_MODE
	end

	if Musician.Live.IsEnabled() and Musician.Live.CanStream() then
		MusicianKeyboardTitle:SetText(Musician.Msg.PLAY_LIVE)
		MusicianKeyboardTitleIcon:SetText(ICON.LIVE_MODE)
	else
		MusicianKeyboardTitle:SetText(Musician.Msg.PLAY_SOLO)
		MusicianKeyboardTitleIcon:SetText(ICON.SOLO_MODE)
	end

	if not(Musician.Live.IsEnabled()) and not(Musician.Live.CanStream()) then
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
		Musician.Live.Enable(not(Musician.Live.IsEnabled()))
		updateLiveModeButton()
		PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
	end)

	updateLiveModeButton()

	Musician.Keyboard:RegisterMessage(Musician.Events.CommReady, updateLiveModeButton)
	Musician.Keyboard:RegisterMessage(Musician.Events.StreamStart, updateLiveModeButton)
	Musician.Keyboard:RegisterMessage(Musician.Events.StreamStop, updateLiveModeButton)
end

--- Enable or disable layer controls
-- @param layer (number)
-- @param enable (boolean)
local function enableLayerControls(layer, enable)
	local controlNames = { "ShiftRight", "ShiftLeft", "ShiftUp", "ShiftDown", "ShiftReset", "PowerChords" }
	local layerVarName = "MusicianKeyboardControls"

	if layer == LAYER.UPPER then
		layerVarName = layerVarName .. "Upper"
	else
		layerVarName = layerVarName .. "Lower"
	end

	local controlName
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
		layout = 2, -- Piano
		instrument = {
			[LAYER.UPPER] = 24, -- lute
			[LAYER.LOWER] = 24, -- lute
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
	}

	-- Set scripts
	MusicianKeyboard:SetScript("OnKeyDown", Musician.Keyboard.OnPhysicalKeyDown)
	MusicianKeyboard:SetScript("OnKeyUp", Musician.Keyboard.OnPhysicalKeyUp)
	Musician.Keyboard:RegisterMessage(Musician.Events.Frame, Musician.Keyboard.OnFrame)

	-- Generate keyboard keys
	generateKeys()

	-- Generate dropdowns
	initLayoutDropdown()
	initBaseKeyDropdown()

	-- Init controls
	initLayerControls(LAYER.LOWER)
	initLayerControls(LAYER.UPPER)
	initLiveModeButton()

	-- Show or hide keyboard according to last settings
	MusicianKeyboard.showKeyboard(Musician_Settings.keyboardVisible)
end

--- Show
--
Musician.Keyboard.Show = function()
	if not(Musician_Settings.keyboardIsConfigured) then
		Musician.Utils.Popup(Musician.Msg.SHOULD_CONFIGURE_KEYBOARD, function() MusicianKeyboardConfig:Show() end)
		Musician.KeyboardConfig.showKeyboardOnComplete = true
	else
		Musician.KeyboardConfig.showKeyboardOnComplete = false
		MusicianKeyboard:Show()
	end
end

--- OnFrame
--
Musician.Keyboard.OnFrame = function(event, elapsed)
	if MusicianKeyboard.IsSavingProgram() then
		savingProgramTime = savingProgramTime + elapsed
		updateFunctionKeysLEDs(savingProgramTime)
	end
end

--- OnPhysicalKeyDown
-- @param event (string)
-- @param keyValue (string)
Musician.Keyboard.OnPhysicalKeyDown = function(event, keyValue)
	Musician.Keyboard.OnPhysicalKey(keyValue, true)
end

--- OnPhysicalKeyUp
-- @param event (string)
-- @param keyValue (string)
Musician.Keyboard.OnPhysicalKeyUp = function(event, keyValue)
	Musician.Keyboard.OnPhysicalKey(keyValue, false)
end

--- Key up/down handler, from physical keyboard
-- @param keyValue (string)
-- @param down (boolean)
Musician.Keyboard.OnPhysicalKey = function(keyValue, down)
	if Musician.Keyboard.SetButtonState(keyValueButtons[keyValue], down) then
		Musician.Keyboard.OnKey(keyValue, down)
	end
end

--- Set logical keyboard button up/down state, without triggering its action
-- Returns true if the button state was successfully changed.
-- @param button (Button)
-- @param down (boolean)
-- @return (boolean)
Musician.Keyboard.SetButtonState = function(button, down)
	local changed = false
	if button then
		button.keyPressed = true
		if down and button:GetButtonState() ~= "PUSHED" then
			button:SetButtonState("PUSHED")
			button:GetScript("OnMouseDown")(button, "LeftButton")
			changed = true
		elseif not(down) and button:GetButtonState() ~= "NORMAL" then
			button:SetButtonState("NORMAL")
			button:GetScript("OnMouseUp")(button, "LeftButton")
			changed = true
		end
		button.keyPressed = false
	end
	return not(button) or changed and not(button.clicked)
end

--- Key up/down handler, from physical or logical keyboard
-- @param keyValue (string)
-- @param down (boolean)
Musician.Keyboard.OnKey = function(keyValue, down)
	if down and keyValue == "ESCAPE" then
		MusicianKeyboard:Hide()
		return
	end

	MusicianKeyboard.NoteKey(down, keyValue)
	MusicianKeyboard.FunctionKey(down, keyValue)
	MusicianKeyboard.ControlKey(down, keyValue)
end

--- Change keyboard layout
-- @param layout (string)
-- @param [rebuildMapping (boolean)] Rebuild keys mapping when true (default)
Musician.Keyboard.SetLayout = function(layout, rebuildMapping)
	Musician.Keyboard.config.layout = layout
	Musician.Keyboard.ShiftKeys(LAYER.UPPER, nil, false)
	Musician.Keyboard.ShiftKeys(LAYER.LOWER, nil, false)

	MusicianKeyboardControlsMainLayoutDropdown.UpdateIndex(layout)

	if rebuildMapping == nil or rebuildMapping then
		Musician.Live.AllNotesOff()
		Musician.Keyboard.BuildMapping()
	end
end

--- Change base key
-- @param key (number)
-- @param [rebuildMapping (boolean)] Rebuild keys mapping when true (default)
Musician.Keyboard.SetBaseKey = function(key, rebuildMapping)
	Musician.Keyboard.config.baseKey = key

	MusicianKeyboardControlsMainBaseKeyDropdown.UpdateIndex(key + 1)

	if rebuildMapping == nil or rebuildMapping then
		Musician.Live.AllNotesOff()
		Musician.Keyboard.BuildMapping()
	end
end

--- Change Instrument
-- @param layer (number)
-- @param instrument (number)
-- @param [rebuildMapping (boolean)] Rebuild keys mapping when true (default)
Musician.Keyboard.SetInstrument = function(layer, instrument, rebuildMapping)
	Musician.Keyboard.config.instrument[layer] = instrument

	local uiElementName = "MusicianKeyboardControls"
	if layer == LAYER.LOWER then
		uiElementName = uiElementName .. "LowerInstrument"
	elseif layer == LAYER.UPPER then
		uiElementName = uiElementName .. "UpperInstrument"
	end
	_G[uiElementName].UpdateValue(instrument)
	enableLayerControls(layer, instrument < 128) -- Enable controls if not percussion

	if rebuildMapping == nil or rebuildMapping then
		Musician.Live.AllNotesOff(layer)
		Musician.Keyboard.BuildMapping()
	end
end

--- Shift keys
-- @param layer (number)
-- @param amount (number) If nil, shift value is reset
-- @param [rebuildMapping (boolean)] Rebuild keys mapping when true (default)
Musician.Keyboard.ShiftKeys = function(layer, amount, rebuildMapping)
	local config = Musician.Keyboard.config

	if amount ~= nil then
		config.shift[layer] = config.shift[layer] + amount
	else
		config.shift[layer] = 0
	end

	if rebuildMapping == nil or rebuildMapping then
		Musician.Live.AllNotesOff(layer)
		Musician.Keyboard.BuildMapping()
	end
end

--- Set power chords \m/
-- @param layer (number)
-- @param enable (boolean)
-- @param [rebuildMapping (boolean)] Rebuild keys mapping when true (default)
Musician.Keyboard.SetPowerChords = function(layer, enable, rebuildMapping)
	Musician.Keyboard.config.powerChords[layer] = enable

	local uiElementName = "MusicianKeyboardControls"
	if layer == LAYER.LOWER then
		uiElementName = uiElementName .. "LowerPowerChords"
	elseif layer == LAYER.UPPER then
		uiElementName = uiElementName .. "UpperPowerChords"
	end
	_G[uiElementName]:SetChecked(enable)

	if rebuildMapping == nil or rebuildMapping then
		Musician.Live.AllNotesOff(layer)
		Musician.Keyboard.BuildMapping()
	end
end

--- Build keyboard mapping from actual configuration
--
Musician.Keyboard.BuildMapping = function()

	Musician.Keyboard.mapping = {}

	-- Invalid layout
	if Musician.Layouts[Musician.Keyboard.config.layout] == nil then
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
		local scaleIndex = -baseKeyIndex
		for index, key in pairs(keyboardMapping) do
			local scaleNote = scale[scaleIndex % #scale + 1]
			if scaleNote ~= -1 then
				local octave = floor(scaleIndex / #scale)
				local note = scaleNote + baseKey + 12 * octave + Musician.Keyboard.config.baseKey
				if not(Musician.DISABLED_KEYS[key]) then
					Musician.Keyboard.mapping[key] = { layer, note }
				end
			end
			scaleIndex = scaleIndex + 1
		end
	end

	local layout = Musician.Layouts[Musician.Keyboard.config.layout]
	local config = Musician.Keyboard.config

	if config.instrument[LAYER.UPPER] >= 128 then
		mapKeys(
			LAYER.UPPER,
			Musician.PercussionLayout.scale,
			Musician.PercussionLayout.upper.keyboardMapping,
			Musician.Utils.NoteKey(Musician.PercussionLayout.upper.baseKey),
			Musician.PercussionLayout.upper.baseKeyIndex
		)
	elseif config.instrument[LAYER.UPPER] >= 0 then
		mapKeys(
			LAYER.UPPER,
			layout.scale,
			layout.upper.keyboardMapping,
			Musician.Utils.NoteKey(layout.upper.baseKey),
			layout.upper.baseKeyIndex + config.shift[LAYER.UPPER]
		)
	end

	if config.instrument[LAYER.LOWER] >= 128 then
		mapKeys(
			LAYER.LOWER,
			Musician.PercussionLayout.scale,
			Musician.PercussionLayout.lower.keyboardMapping,
			Musician.Utils.NoteKey(Musician.PercussionLayout.lower.baseKey),
			Musician.PercussionLayout.lower.baseKeyIndex
		)
	elseif config.instrument[LAYER.LOWER] >= 0 then
		mapKeys(
			LAYER.LOWER,
			layout.scale,
			layout.lower.keyboardMapping,
			Musician.Utils.NoteKey(layout.lower.baseKey),
			layout.lower.baseKeyIndex + config.shift[LAYER.LOWER]
		)
	end

	setKeys()
end

--- Note key pressed
-- @param down (boolean)
-- @param keyValue (string)
-- @return (boolean)
MusicianKeyboard.NoteKey = function(down, keyValue)
	local key = Musician.KeyboardUtils.GetKey(keyValue)

	if key == nil then
		return false
	end

	local note = Musician.Keyboard.mapping[key]

	if note == nil then
		return false
	end

	local layer = note[1]
	local noteKey = note[2]
	local instrument = Musician.Keyboard.config.instrument[layer]
	local powerChords = Musician.Keyboard.config.powerChords[layer] and instrument < 128 -- No power chords for percussions

	if noteKey < Musician.MIN_KEY or noteKey > Musician.MAX_KEY or instrument < 0 then
		return false
	end

	if powerChords then
		Musician.Live.NoteOff(noteKey - 12, layer, instrument)
		Musician.Live.NoteOff(noteKey - 5, layer, instrument)
	end
	Musician.Live.NoteOff(noteKey, layer, instrument)

	if down then
		if powerChords then
			Musician.Live.NoteOn(noteKey - 12, layer, instrument)
			Musician.Live.NoteOn(noteKey - 5, layer, instrument)
		end
		Musician.Live.NoteOn(noteKey, layer, instrument)
	end

	return true
end

--- Control key pressed
-- @param down (boolean)
-- @param keyValue (string)
-- @return (boolean)
MusicianKeyboard.ControlKey = function(down, keyValue)
	local key = Musician.KeyboardUtils.GetKey(keyValue)

	if key == KEY.ControlLeft or key == KEY.ControlRight or key == KEY.WriteProgram then
		MusicianKeyboard.SetSavingProgram(down)
	end
end

--- Function key pressed
-- @param down (boolean)
-- @param keyValue (string)
-- @return (boolean)
MusicianKeyboard.FunctionKey = function(down, keyValue)
	local key = Musician.KeyboardUtils.GetKey(keyValue)

	if key == nil or ProgramKeys[key] == nil then
		return false
	end

	local program = ProgramKeys[key]
	if down then
		if MusicianKeyboard.IsSavingProgram() then
			MusicianKeyboard.SaveProgram(program)
			MusicianKeyboard.SetSavingProgram(false)
		else
			MusicianKeyboard.LoadProgram(program)
		end
		updateFunctionKeys()
	end
end

--- Set program saving mode
-- @param value (boolean)
MusicianKeyboard.SetSavingProgram = function(value)
	if savingProgram ~= value then
		savingProgramTime = 0
		savingProgram = value
		Musician.Keyboard.SetButtonState(keyValueButtons[KEY.WriteProgram], value)
		if value then
			keyValueButtons[KEY.WriteProgram].hiddenButton:SetAlpha(0)
		else
			keyValueButtons[KEY.WriteProgram].hiddenButton:SetAlpha(1)
		end
		PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
		updateFunctionKeys()
	end
end

--- Get program saving mode
-- @return (boolean)
MusicianKeyboard.IsSavingProgram = function()
	return savingProgram
end

--- Load configuration
-- @param config (table)
MusicianKeyboard.LoadConfig = function(config)
	Musician.Keyboard.SetLayout(config.layout, false)
	Musician.Keyboard.SetBaseKey(config.baseKey, false)
	Musician.Keyboard.SetInstrument(LAYER.UPPER, config.instrument[LAYER.UPPER], false)
	Musician.Keyboard.SetInstrument(LAYER.LOWER, config.instrument[LAYER.LOWER], false)
	Musician.Keyboard.ShiftKeys(LAYER.UPPER, config.shift[LAYER.UPPER], false)
	Musician.Keyboard.ShiftKeys(LAYER.LOWER, config.shift[LAYER.LOWER], false)
	Musician.Keyboard.SetPowerChords(LAYER.UPPER, config.powerChords[LAYER.UPPER], false)
	Musician.Keyboard.SetPowerChords(LAYER.LOWER, config.powerChords[LAYER.LOWER], false)

	Musician.Live.AllNotesOff()
	Musician.Keyboard.BuildMapping()
end

--- Has saved program
-- @param program (number)
-- @return (boolean)
MusicianKeyboard.HasSavedProgram = function(program)
	return Musician_Settings.keyboardPrograms and Musician_Settings.keyboardPrograms[program]
end

--- Indicates if the provided program is the current one that has been loaded
-- @param program (number)
-- @return (boolean)
MusicianKeyboard.IsCurrentProgram = function(program)
	return program == loadedProgram
end

--- Load saved program
-- @param program (number)
-- @return (boolean)
MusicianKeyboard.LoadProgram = function(program)
	if MusicianKeyboard.HasSavedProgram(program) then
		MusicianKeyboard.LoadConfig(Musician_Settings.keyboardPrograms[program])
		loadedProgram = program
		return true
	end

	return false
end

--- Save program
-- @param program (number)
MusicianKeyboard.SaveProgram = function(program)
	if Musician_Settings.keyboardPrograms == nil then
		Musician_Settings.keyboardPrograms = {}
	end

	Musician_Settings.keyboardPrograms[program] = Musician.Utils.DeepCopy(Musician.Keyboard.config)
	loadedProgram = program
end
