Musician.Keyboard = LibStub("AceAddon-3.0"):NewAddon("Musician.Keyboard", "AceEvent-3.0")

Musician.Keyboard.Layer = {
	["UPPER"] = 0,
	["LOWER"] = 1,
	["DRUMS"] = 2,
}
local LAYER = Musician.Keyboard.Layer

Musician.Keyboard.InstrumentKeys = {
	["L"] = "lute",
	["R"] = "recorder",
	["H"] = "harp",
	["D"] = "dulcimer",
	["B"] = "bagpipe",
	["F"] = "fiddle",
	["C"] = "cello",
	["A"] = "female-voice",
	["O"] = "male-voice",
	["T"] = "trumpet",
	["U"] = "trombone",
	["W"] = "clarinet",
	["Z"] = "bassoon",
	["M"] = "distorsion-guitar",
	["G"] = "clean-guitar",
	["X"] = "bass-guitar",

	["0"] = "percussions",
	["1"] = "drumkit",

	["NUMPAD0"] = "NUMPAD-percussions",
	["NUMPAD1"] = "NUMPAD-drumkit",
}

Musician.Keyboard.DrumKeys = {
	["NUMPAD0"] = 35, -- [35] = "bodhran-bassdrum-low", -- Acoustic Bass Drum
	["NUMPADDECIMAL"] = 38, -- [38] = "bodhran-snare-long-low", -- Acoustic Snare
	["NUMPAD1"] = 42, -- [42] = "tambourine-hit1", -- Closed Hi Hat
	["NUMPAD2"] = 44, -- [44] = "tambourine-shake-short", -- Pedal Hi-Hat
	["NUMPAD3"] = 46, -- [46] = "tambourine-shake-long", -- Open Hi-Hat
	["NUMPAD4"] = 41, -- [41] = "bodhran-tom-long-low", -- Low Floor Tom
	["NUMPAD5"] = 43, -- [43] = "bodhran-tom-long-med", -- High Floor Tom
	["NUMPAD6"] = 45, -- [45] = "bodhran-tom-long-hi", -- Low Tom
	["NUMPAD7"] = 47, -- [47] = "bodhran-tom-short-low", -- Low-Mid Tom
	["NUMPAD8"] = 48, -- [48] = "bodhran-tom-short-med", -- Hi-Mid Tom
	["NUMPAD9"] = 50, -- [50] = "bodhran-tom-short-hi", -- High Tom
	["NUMPADDIVIDE"] = 51, -- [51] = "tambourine-hit1", -- Ride Cymbal 1
	["NUMPADMULTIPLY"] = 59, -- [59] = "tambourine-hit2", -- Ride Cymbal 2
	["NUMPADPLUS"] = 49, -- [49] = "tambourine-crash-long1", -- Crash Cymbal 1
	["NUMPADMINUS"] = 57, -- [57] = "tambourine-crash-long2", -- Crash Cymbal 2
}

local KEY = Musician.KEYBOARD_KEY

local KEY_SIZE = 50

Musician.Keyboard.NotesOn = {}

local lCtrlDown = false
local rCtrlDown = false

local keyButtons = {}
local keyValueButtons = {}

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

			if Musician.Keyboard.mapping[key] ~= nil or keyValueName then
				-- Ket key and note names
				local noteName = ""

				if keyValue then
					keyValueName = Musician.KeyboardUtils.GetKeyValueName(keyValue)
				end

				if Musician.Keyboard.mapping[key] ~= nil then
					noteName = Musician.Utils.NoteName(Musician.Keyboard.mapping[key][2])

					-- Black or white key
					if string.match(noteName, "%#") then
						button.background:SetColorTexture(.33, .22, .11, 1)
					else
						button.background:SetColorTexture(1, .88, .75, 1)
					end
					button:Enable()
					button:SetAlpha(1)
				else
					-- keyValueName = ""
					button.background:SetColorTexture(0, 0, 0, 0)
					button:Disable()
					button:SetAlpha(.5)
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
				elseif key == KEY.IntlBackslash and keyValue == "LSHIFT" then
					keyWidth = keyWidth + Musician.KEYBOARD_KEY_SIZE[row][col - 1]
					keyX = keyX - Musician.KEYBOARD_KEY_SIZE[row][col - 1]
				elseif key == KEY.IntlRo and keyValue == "RSHIFT" then
					keyWidth = keyWidth + Musician.KEYBOARD_KEY_SIZE[row][col + 1]
				elseif key == KEY.ShiftRight and Musician.KeyboardUtils.GetKeyValue(KEY.IntlRo) == "RSHIFT" then
					keyVisible = false
				end

				-- Set size and position
				button:SetWidth(keyWidth * KEY_SIZE)
				button:SetHeight(keyHeight * KEY_SIZE)
				button:SetPoint("TOPLEFT", MusicianKeyboardKeys, "TOPLEFT", keyX * KEY_SIZE, keyY * KEY_SIZE)

				-- Set text
				button:SetText(keyValueName)
				button.subText:SetText(noteName)
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

--- Initialize keyboard
--
function Musician.Keyboard.Init()

	-- Base parameters
	Musician.Keyboard.config = {
		["layout"] = "Piano",
		["upperInstrument"] = 24, -- lute
		["lowerInstrument"] = 24, -- lute
		["drumsInstrument"] = 128,
		["upperShift"] = 0,
		["lowerShift"] = 0,
		["transpose"] = 0,
	}

	-- Set scripts
	MusicianKeyboard:SetScript("OnKeyDown", Musician.Keyboard.OnKeyDown)
	MusicianKeyboard:SetScript("OnKeyUp", Musician.Keyboard.OnKeyUp)

	-- Generate keyboard keys
	generateKeys()
end

--- OnKeyDown
-- @param self (Frame)
-- @param keyValue (string)
Musician.Keyboard.OnKeyDown = function(self, keyValue)
	local button = keyValueButtons[keyValue]
	if button then
		if button.down then
			return
		end
		button.down = true
		button.animateOnMouseDown(button, "LeftButton")
		local point, relativeTo, relativePoint, xOfs, yOfs = button:GetFontString():GetPoint()
		button:GetFontString():SetPoint(point, relativeTo, relativePoint, xOfs + button.pushedTextOffset[1], yOfs + button.pushedTextOffset[2])
		point, relativeTo, relativePoint, xOfs, yOfs = button.subText:GetPoint()
		button.subText:SetPoint(point, relativeTo, relativePoint, xOfs + button.pushedTextOffset[1], yOfs + button.pushedTextOffset[2])
	end

	if keyValue == "LCTRL"  then
		lCtrlDown = true
	elseif keyValue == "RCTRL" then
		rCtrlDown = true
	elseif not(lCtrlDown) and not(rCtrlDown) then
		MusicianKeyboard.NoteKey(true, keyValue)
	else
		MusicianKeyboard.ShiftKeyDown(keyValue)
		MusicianKeyboard.InstrumentChangeKeyDown(keyValue)
	end

end

--- OnKeyUp
-- @param self (Frame)
-- @param keyValue (string)
Musician.Keyboard.OnKeyUp = function(self, keyValue)

	local button = keyValueButtons[keyValue]
	if button then
		if not(button.down) then
			return
		end
		button.animateOnMouseUp(button, "LeftButton")
		local point, relativeTo, relativePoint, xOfs, yOfs = button:GetFontString():GetPoint()
		button:GetFontString():SetPoint(point, relativeTo, relativePoint, xOfs - button.pushedTextOffset[1], yOfs - button.pushedTextOffset[2])
		local point, relativeTo, relativePoint, xOfs, yOfs = button.subText:GetPoint()
		button.subText:SetPoint(point, relativeTo, relativePoint, xOfs - button.pushedTextOffset[1], yOfs - button.pushedTextOffset[2])
		button.down = false
	end

	if keyValue == "LCTRL"  then
		lCtrlDown = false
	elseif keyValue == "RCTRL" then
		rCtrlDown = false
	elseif not(lCtrlDown) and not(rCtrlDown) then
		MusicianKeyboard.NoteKey(false, keyValue)
	else

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
				local note = scaleNote + baseKey + 12 * octave + Musician.Keyboard.config.transpose
				Musician.Keyboard.mapping[key] = { layer, note }
			end
			scaleIndex = scaleIndex + 1
		end
	end

	local layout = Musician.Layouts[Musician.Keyboard.config.layout]
	local config = Musician.Keyboard.config
	mapKeys(LAYER.UPPER, layout.scale, layout.upper.keyboardMapping, Musician.Utils.NoteKey(layout.upper.baseKey), layout.upper.baseKeyIndex + config.upperShift)
	mapKeys(LAYER.LOWER, layout.scale, layout.lower.keyboardMapping, Musician.Utils.NoteKey(layout.lower.baseKey), layout.lower.baseKeyIndex + config.lowerShift)

	setKeys()
end

--- Note key pressed
-- @param down (boolean)
-- @param keyValue (string)
-- @return (boolean)
MusicianKeyboard.NoteKey = function(down, keyValue)
	local key = Musician.KeyboardUtils.GetKey(keyValue)

	if key == nil then
		local drumNote = Musician.Keyboard.DrumKeys[keyValue]
		if drumNote == nil then
			return false
		end

		if down then
			Musician.Live.NoteOn(drumNote, Musician.Keyboard.config.drumsInstrument)
		else
			Musician.Live.NoteOff(drumNote, Musician.Keyboard.config.drumsInstrument)
		end

		return true
	end

	local note = Musician.Keyboard.mapping[key]

	if note == nil then
		return false
	end

	local layer = note[1]
	local noteKey = note[2]
	local instrument

	if layer == LAYER.UPPER then
		instrument = Musician.Keyboard.config.upperInstrument
	elseif layer == LAYER.LOWER then
		instrument = Musician.Keyboard.config.lowerInstrument
	end

	if down then
		Musician.Live.NoteOn(noteKey, instrument)
	else
		Musician.Live.NoteOff(noteKey, instrument)
	end

	return true
end

--- Shift keyboard layout using ctrl + directional keys
-- @param keyValue (string)
MusicianKeyboard.ShiftKeyDown = function(keyValue)

	if not(lCtrlDown) and not(rCtrlDown) then
		return false
	end

	local layout = Musician.Layouts[Musician.Keyboard.config.layout]

	local value = 0

	if keyValue == "UP" then value = -#layout.scale
	elseif keyValue == "DOWN" then value = #layout.scale
	elseif keyValue == "LEFT" then value = -layout.shift
	elseif keyValue == "RIGHT" then value = layout.shift
	end

	if value == 0 then
		return true
	end

	-- TODO: rewrite as separate function
	if lCtrlDown then
		Musician.Keyboard.config.lowerShift = Musician.Keyboard.config.lowerShift + value
		Musician.Utils.Print("Lower shift" .. " " .. Musician.Utils.Highlight(Musician.Keyboard.config.lowerShift))
	end

	if rCtrlDown then
		Musician.Keyboard.config.upperShift = Musician.Keyboard.config.upperShift + value
		Musician.Utils.Print("Upper shift" .. " " .. Musician.Utils.Highlight(Musician.Keyboard.config.upperShift))
	end

	Musician.Keyboard.BuildMapping()

	return true
end

--- Change instrument using Ctrl + letter key
-- @param keyValue (string)
MusicianKeyboard.InstrumentChangeKeyDown = function(keyValue)

	if not(lCtrlDown) and not(rCtrlDown) then
		return false
	end

	local changeDrumsInstrument = false
	if Musician.Keyboard.InstrumentKeys[keyValue] then
		local instrumentName = Musician.Keyboard.InstrumentKeys[keyValue]
		local replaceDrums = false
		if string.match(instrumentName, 'NUMPAD-') then
			instrumentName = string.gsub(instrumentName, 'NUMPAD%-', '')
			changeDrumsInstrument = true
		end

		-- TODO: rewrite as separate function
		local instrument = Musician.INSTRUMENTS[instrumentName]

		if changeDrumsInstrument then
			Musician.Keyboard.config.drumsInstrument = instrument.midi
			Musician.Utils.Print(Musician.Msg.CHANGE_TRACK_INSTRUMENT .. " (drums) " .. Musician.Utils.Highlight(Musician.Msg.INSTRUMENT_NAMES[instrumentName]))
		else
			if lCtrlDown then
				Musician.Keyboard.config.lowerInstrument = instrument.midi
				Musician.Utils.Print(Musician.Msg.CHANGE_TRACK_INSTRUMENT .. " (lower) " .. Musician.Utils.Highlight(Musician.Msg.INSTRUMENT_NAMES[instrumentName]))
			end

			if rCtrlDown then
				Musician.Keyboard.config.upperInstrument = instrument.midi
				Musician.Utils.Print(Musician.Msg.CHANGE_TRACK_INSTRUMENT .. " (upper) " .. Musician.Utils.Highlight(Musician.Msg.INSTRUMENT_NAMES[instrumentName]))
			end
		end

		return true
	end

	return false
end
