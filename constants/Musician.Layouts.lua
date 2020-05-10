-- Define constants

local KEY = Musician.KEYBOARD_KEY
local Percussion = Musician.MIDI_PERCUSSIONS

Musician.LAYOUT_ORIENTATION = {
	HORIZONTAL = 0,
	VERTICAL = 1,
}
local ORIENTATION = Musician.LAYOUT_ORIENTATION

Musician.DEFAULT_LAYOUT = 1 -- Piano

local MODES = {
	{ "Modes" },
	{ "Chromatic", { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 } },
	{ "Ionian", { 0, 2, 4, 5, 7, 9, 11 } },
	{ "Dorian", { 0, 2, 3, 5, 7, 9, 10 } },
	{ "Phrygian", { 0, 1, 3, 5, 7, 8, 10 } },
	{ "Lydian", { 0, 2, 4, 6, 7, 9, 11 } },
	{ "Mixolydian", { 0, 2, 4, 5, 7, 9, 10 } },
	{ "Aeolian", { 0, 2, 3, 5, 7, 8, 10 } },
	{ "Locrian", { 0, 1, 3, 5, 6, 8, 10 } },
	{ "minor Harmonic", { 0, 2, 3, 5, 7, 8, 11 } },
	{ "minor Melodic", { 0, 2, 3, 5, 7, 9, 11 } },

	{ "Blues scales" },
	{ "Major Blues", { 0, 2, 3, 4, 7, 9 } },
	{ "minor Blues", { 0, 3, 5, 6, 7, 10 } },

	{ "Diminished scales" },
	{ "Diminished", { 0, 2, 3, 5, 6, 8, 9, 11 } },
	{ "Complement Diminished", { 0, 1, 3, 4, 6, 7, 9, 10 } },

	{ "Pentatonic scales" },
	{ "Major Pentatonic", { 0, 2, 4, 7, 9 } },
	{ "minor Pentatonic", { 0, 3, 5, 7, 10 } },

	{ "World scales" },
	{ "Raga 1", { 0, 1, 4, 5, 7, 8, 11 } },
	{ "Raga 2", { 0, 1, 4, 6, 7, 9, 11 } },
	{ "Raga 3", { 0, 1, 3, 6, 7, 8, 11 } },
	{ "Arabic", { 0, 2, 4, 5, 6, 8, 10 } },
	{ "Spanish", { 0, 1, 3, 4, 5, 7, 8, 10 } },
	{ "Gypsy", { 0, 2, 3, 6, 7, 8, 11 } },
	{ "Egyptian", { 0, 2, 5, 7, 10 } },
	{ "Hawaiian", { 0, 2, 3, 7, 9 } },
	{ "Bali Pelog", { 0, 1, 3, 7, 8 } },
	{ "Japanese", { 0, 1, 5, 7, 8 } },
	{ "Ryukyu", { 0, 4, 5, 7, 11 } },
	{ "Chinese", { 0, 4, 6, 7, 11 } },

	{ "Miscellaneous scales" },
	{ "Bass Line", { 0, 7, 10 }, 'C3', 'C1' },
	{ "Wholetone", { 0, 2, 4, 6, 8, 10 } },
	{ "minor 3rd", { 0, 3, 6, 9 }, 'C0', 'C0' },
	{ "Major 3rd", { 0, 4, 8 } },
	{ "4th", { 0, 5, 10 } },
	{ "5th", { 0, 7 } },
	{ "Octave", { 0 }, 'C0', 'C0', 2, 1 },
}

-- Functions

local function getHorizontalScale(name, notes, upperBaseKey, lowerBaseKey, upperBaseKeyIndex, lowerBaseKeyIndex)
	return {
		name = name,
		orientation = ORIENTATION.HORIZONTAL,
		scale = notes,
		shift = 1,
		upper = {
			keyboardMapping = {
				KEY.KeyW, KEY.KeyE, KEY.KeyR, KEY.KeyT, KEY.KeyY, KEY.KeyU, KEY.KeyI, KEY.KeyO, KEY.KeyP, KEY.BracketLeft, KEY.BracketRight,
				KEY.Digit3, KEY.Digit4, KEY.Digit5, KEY.Digit6, KEY.Digit7, KEY.Digit8, KEY.Digit9, KEY.Digit0, KEY.Minus, KEY.Equal, KEY.IntlYen
			},
			baseKey = upperBaseKey or 'C4',
			baseKeyIndex = upperBaseKeyIndex or 3,
		},
		lower = {
			keyboardMapping = {
				KEY.IntlBackslash, KEY.KeyZ, KEY.KeyX, KEY.KeyC, KEY.KeyV, KEY.KeyB, KEY.KeyN, KEY.KeyM, KEY.Comma, KEY.Period, KEY.Slash,
				KEY.KeyA, KEY.KeyS, KEY.KeyD, KEY.KeyF, KEY.KeyG, KEY.KeyH, KEY.KeyJ, KEY.KeyK, KEY.KeyL, KEY.Semicolon, KEY.Quote
			},
			baseKey = lowerBaseKey or 'C3',
			baseKeyIndex = lowerBaseKeyIndex or 2,
		},
	}
end

local function getVerticalScale(name, notes, upperBaseKey, lowerBaseKey, upperBaseKeyIndex, lowerBaseKeyIndex)
	return {
		name = name,
		orientation = ORIENTATION.VERTICAL,
		scale = notes,
		shift = 1,
		upper = {
			keyboardMapping = {
				KEY.KeyN, KEY.KeyM, KEY.Comma, KEY.Period, KEY.Slash,
				KEY.KeyJ, KEY.KeyK, KEY.KeyL, KEY.Semicolon, KEY.Quote,
				KEY.KeyI, KEY.KeyO, KEY.KeyP, KEY.BracketLeft, KEY.BracketRight,
				KEY.Digit9, KEY.Digit0, KEY.Minus, KEY.Equal, KEY.IntlYen,
			},
			baseKey = upperBaseKey or 'C4',
			baseKeyIndex = upperBaseKeyIndex or 5,
		},
		lower = {
			keyboardMapping = {
				KEY.KeyZ, KEY.KeyX, KEY.KeyC, KEY.KeyV, KEY.KeyB,
				KEY.KeyA, KEY.KeyS, KEY.KeyD, KEY.KeyF, KEY.KeyG,
				KEY.KeyQ, KEY.KeyW, KEY.KeyE, KEY.KeyR, KEY.KeyT,
				KEY.Digit1, KEY.Digit2, KEY.Digit3, KEY.Digit4, KEY.Digit5,
			},
			baseKey = lowerBaseKey or 'C3',
			baseKeyIndex = lowerBaseKeyIndex or 5,
		},
	}
end

local function getSeparator(label)
	return {
		name = label
	}
end

local function getPercussionScale(scale)
	local shiftedScale = {}
	local k, v
	for k, v in pairs(scale) do
		table.insert(shiftedScale, v - 15)
	end
	return shiftedScale
end


-- Build layouts

Musician.PianoLayout = {
	name = "Piano",
	scale = { 0, 1, 2, 3, 4, -1, 5, 6, 7, 8, 9, 10, 11, -1 },
	shift = 2,
	orientation = ORIENTATION.HORIZONTAL,
	upper = {
		keyboardMapping = {
			KEY.Backquote, KEY.Tab, KEY.Digit1,
			KEY.KeyQ, KEY.Digit2, KEY.KeyW, KEY.Digit3, KEY.KeyE, KEY.Digit4, KEY.KeyR, KEY.Digit5, KEY.KeyT, KEY.Digit6, KEY.KeyY, KEY.Digit7, KEY.KeyU, KEY.Digit8,
			KEY.KeyI, KEY.Digit9, KEY.KeyO, KEY.Digit0, KEY.KeyP, KEY.Minus, KEY.BracketLeft, KEY.Equal, KEY.BracketRight, KEY.IntlYen, KEY.Backslash1, KEY.Backspace
		},
		baseKey = 'C4',
		baseKeyIndex = 3,
	},
	lower = {
		keyboardMapping = {
			KEY.ShiftLeft, KEY.CapsLock, KEY.IntlBackslash, KEY.KeyA,
			KEY.KeyZ, KEY.KeyS, KEY.KeyX, KEY.KeyD, KEY.KeyC, KEY.KeyF, KEY.KeyV, KEY.KeyG, KEY.KeyB, KEY.KeyH, KEY.KeyN, KEY.KeyJ, KEY.KeyM, KEY.KeyK,
			KEY.Comma, KEY.KeyL, KEY.Period, KEY.Semicolon, KEY.Slash, KEY.Quote, KEY.IntlRo, KEY.Backslash2, KEY.ShiftRight
		},
		baseKey = 'C3',
		baseKeyIndex = 4,
	},
}

Musician.HorizontalLayouts = {}
Musician.VerticalLayouts = {}

local mode
for _, mode in pairs(MODES) do
	if mode[2] then
		table.insert(Musician.HorizontalLayouts, getHorizontalScale(unpack(mode)))
		table.insert(Musician.VerticalLayouts, getVerticalScale(unpack(mode)))
	else
		table.insert(Musician.HorizontalLayouts, getSeparator(unpack(mode)))
		table.insert(Musician.VerticalLayouts, getSeparator(unpack(mode)))
	end
end

Musician.PercussionHorizontalLayout = getHorizontalScale(
	"Percussion",
	getPercussionScale({
		Percussion.AcousticBassDrum,
		Percussion.BassDrum1,
		Percussion.AcousticSnare,
		Percussion.ElectricSnare,
		Percussion.SideStick,
		Percussion.LowFloorTom,
		Percussion.HighFloorTom,
		Percussion.LowTom,
		Percussion.LowMidTom,
		Percussion.HiMidTom,
		Percussion.HighTom,

		Percussion.ClosedHiHat,
		Percussion.PedalHiHat,
		Percussion.OpenHiHat,
		Percussion.CrashCymbal1,
		Percussion.CrashCymbal2,
		Percussion.RideCymbal1,
		Percussion.RideCymbal2,
		Percussion.RideBell,
		Percussion.Tambourine,
		Percussion.Maracas,
		Percussion.HandClap,
	}),
	'D#0', 'D#0', 0, 0
)

Musician.PercussionVerticalLayout = {
	name = "Percussion",
	orientation = ORIENTATION.VERTICAL,
	scale = getPercussionScale({
		Percussion.AcousticBassDrum,
		Percussion.BassDrum1,
		Percussion.AcousticSnare,
		Percussion.ElectricSnare,
		Percussion.SideStick,

		Percussion.ClosedHiHat,
		Percussion.PedalHiHat,
		Percussion.OpenHiHat,
		Percussion.CrashCymbal1,
		Percussion.CrashCymbal2,

		Percussion.LowFloorTom,
		Percussion.HighFloorTom,
		Percussion.LowTom,
		Percussion.LowMidTom,
		Percussion.HiMidTom,
		Percussion.HighTom,

		Percussion.RideCymbal1,
		Percussion.RideCymbal2,
		Percussion.RideBell,
		Percussion.Tambourine,
		Percussion.Maracas,
		Percussion.HandClap,
	}),
	shift = 1,
	upper = {
		keyboardMapping = {
			KEY.KeyN, KEY.KeyM, KEY.Comma, KEY.Period, KEY.Slash,
			KEY.KeyJ, KEY.KeyK, KEY.KeyL, KEY.Semicolon, KEY.Quote,
			KEY.KeyU, KEY.KeyI, KEY.KeyO, KEY.KeyP, KEY.BracketLeft, KEY.BracketRight,
			KEY.Digit7, KEY.Digit8, KEY.Digit9, KEY.Digit0, KEY.Minus, KEY.Equal, -- KEY.IntlYen,
		},
		baseKey = 'D#0',
		baseKeyIndex = 0,
	},
	lower = {
		keyboardMapping = {
			KEY.KeyZ, KEY.KeyX, KEY.KeyC, KEY.KeyV, KEY.KeyB,
			KEY.KeyA, KEY.KeyS, KEY.KeyD, KEY.KeyF, KEY.KeyG,
			KEY.KeyQ, KEY.KeyW, KEY.KeyE, KEY.KeyR, KEY.KeyT, KEY.KeyY,
			KEY.Digit1, KEY.Digit2, KEY.Digit3, KEY.Digit4, KEY.Digit5, KEY.Digit6,
		},
		baseKey = 'D#0',
		baseKeyIndex = 0,
	},
}
