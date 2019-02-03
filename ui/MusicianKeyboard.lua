Musician.Keyboard = LibStub("AceAddon-3.0"):NewAddon("Musician.Keyboard", "AceEvent-3.0")

local LAYER = Musician.KEYBOARD_LAYER
local KEY = Musician.KEYBOARD_KEY

local KEY_SIZE = 50

local lCtrlDown = false
local rCtrlDown = false

local keyButtons = {}
local keyValueButtons = {}

local ICON = {
	["SOLO_MODE"] = "H", -- headphones
	["LIVE_MODE"] = "+", -- speaker
}

Musician.Keyboard.NotesOn = {}

--- Return the binding button for the given physical key.
-- @param key (string)
-- @return (Button)
local getKeyButton = function(key)
	return _G["MusicianKeyboardKeys" .. key .. "Button"]
end

--- Create the keyboard keys.
--
local function generateKeys()

	-- Size container
	MusicianKeyboardKeys:SetHeight(5 * KEY_SIZE)
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
end

--- Set keyboard keys (notes, color etc)
--
local function setKeys()
	local config = Musician.Keyboard.config

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

				if keyValue then
					keyValueName = Musician.KeyboardUtils.GetKeyValueName(keyValue)
				end

				if keyData ~= nil and keyData[2] >= Musician.MIN_KEY and keyData[2] <= Musician.MAX_KEY and not(Musician.DISABLED_KEYS[key]) and Musician.KeyboardUtils.GetKeyValue(key) then
					noteName = Musician.Utils.NoteName(keyData[2])
					local instrumentName = Musician.MIDI_INSTRUMENT_MAPPING[config.instrument[keyData[1]]]
					local r, g, b = unpack(Musician.INSTRUMENTS[instrumentName].color)

					-- Black or white key
					if string.match(noteName, "[%#b]") then
						r = r / 4
						g = g / 4
						b = b / 4
					end
					button.background:SetColorTexture(r, g, b, 1)
					button:Enable()
					button:SetAlpha(1)

					if config.instrument[keyData[1]] >= 128 then
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
				button.subText:SetText(keyValueName)
			else
				keyVisible = false
			end

			if keyVisible then
				button:Show()
			else
				button:Hide()
			end

			cursorX = keyX + keyWidth
		end
	end
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

	dropdown.SetIndex = function(index)
		dropdown.value = values[index]
		dropdown.index = index
		UIDropDownMenu_SetText(dropdown, labels[index])
		onChange(values[index])
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
	dropdown.SetIndex(initialIndex)
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
	MusicianKeyboard:SetScript("OnKeyDown", Musician.Keyboard.OnKeyDown)
	MusicianKeyboard:SetScript("OnKeyUp", Musician.Keyboard.OnKeyUp)

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

--- OnKeyDown
-- @param self (Frame)
-- @param keyValue (string)
Musician.Keyboard.OnKeyDown = function(self, keyValue)
	local button = keyValueButtons[keyValue]
	if button then
		button:SetButtonState("PUSHED")
		button:GetScript("OnMouseDown")(button, "LeftButton")
	else
		Musician.Keyboard.KeyDown(keyValue)
	end
end

--- OnKeyUp
-- @param self (Frame)
-- @param keyValue (string)
Musician.Keyboard.OnKeyUp = function(self, keyValue)
	local button = keyValueButtons[keyValue]
	if button then
		button:SetButtonState("NORMAL")
		button:GetScript("OnMouseUp")(button, "LeftButton")
	else
		Musician.Keyboard.KeyUp(keyValue)
	end
end

--- KeyDown
-- @param keyValue (string)
Musician.Keyboard.KeyDown = function(keyValue)
	if keyValue == "ESCAPE" then
		MusicianKeyboard:Hide()
		return
	end

	if keyValue == "LCTRL"  then
		lCtrlDown = true
	elseif keyValue == "RCTRL" then
		rCtrlDown = true
	elseif not(lCtrlDown) and not(rCtrlDown) then
		MusicianKeyboard.NoteKey(true, keyValue)
	end
end

--- KeyUp
-- @param keyValue (string)
Musician.Keyboard.KeyUp = function(keyValue)
	if keyValue == "LCTRL"  then
		lCtrlDown = false
	elseif keyValue == "RCTRL" then
		rCtrlDown = false
	elseif not(lCtrlDown) and not(rCtrlDown) then
		MusicianKeyboard.NoteKey(false, keyValue)
	end
end

--- Change keyboard layout
-- @param layout (string)
Musician.Keyboard.SetLayout = function(layout)
	local config = Musician.Keyboard.config
	config.layout = layout
	config.shift[LAYER.UPPER] = 0
	config.shift[LAYER.LOWER] = 0
	Musician.Live.AllNotesOff()
	Musician.Keyboard.BuildMapping()
end

--- Change base key
-- @param key (number)
Musician.Keyboard.SetBaseKey = function(key)
	Musician.Keyboard.config.baseKey = key
	Musician.Live.AllNotesOff()
	Musician.Keyboard.BuildMapping()
end

--- Change Instrument
-- @param layer (number)
-- @param instrument (number)
Musician.Keyboard.SetInstrument = function(layer, instrument)
	Musician.Keyboard.config.instrument[layer] = instrument
	Musician.Live.AllNotesOff(layer)
	enableLayerControls(layer, instrument < 128) -- Enable controls if not percussion
	Musician.Keyboard.BuildMapping()
end

--- Shift keys
-- @param layer (number)
-- @param amount (number) If nil, shift value is reset
Musician.Keyboard.ShiftKeys = function(layer, amount)
	local config = Musician.Keyboard.config

	if amount ~= nil then
		config.shift[layer] = config.shift[layer] + amount
	else
		config.shift[layer] = 0
	end

	Musician.Live.AllNotesOff(layer)
	Musician.Keyboard.BuildMapping()
end

--- Set power chords \m/
-- @param layer (number)
-- @param enable (boolean)
Musician.Keyboard.SetPowerChords = function(layer, enable)
	Musician.Keyboard.config.powerChords[layer] = enable
	Musician.Live.AllNotesOff(layer)
	Musician.Keyboard.BuildMapping()
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
