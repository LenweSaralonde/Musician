Musician.Layouts = {}

local KEY = Musician.KEYBOARD_KEY
local Percussion = Musician.MIDI_PERCUSSIONS

local function getScale(name, notes, upperBaseKey, lowerBaseKey, upperBaseKeyIndex, lowerBaseKeyIndex)
	return {
		name = name,
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

local function getSeparator(label)
	return {
		name = label
	}
end

local function getPercussionScale(scale)
	local shiftedScale = {}
	local k, v
	for k, v in pairs(scale) do
		table.insert(shiftedScale, v - 27)
	end
	return shiftedScale
end

Musician.Layouts = {
	getSeparator("Piano"),
	{
		name = "Piano",
		scale = { 0, 1, 2, 3, 4, -1, 5, 6, 7, 8, 9, 10, 11, -1 },
		shift = 2,
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
	},

	getSeparator("Modes"),
	getScale("Chromatic", { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 }),
	getScale("Ionian", { 0, 2, 4, 5, 7, 9, 11 }),
	getScale("Dorian", { 0, 2, 3, 5, 7, 9, 10 }),
	getScale("Phrygian", { 0, 1, 3, 5, 7, 8, 10 }),
	getScale("Lydian", { 0, 2, 4, 6, 7, 9, 11 }),
	getScale("Mixolydian", { 0, 2, 4, 5, 7, 9, 10 }),
	getScale("Aeolian", { 0, 2, 3, 5, 7, 8, 10 }),
	getScale("Locrian", { 0, 1, 3, 5, 6, 8, 10 }),
	getScale("minor Harmonic", { 0, 2, 3, 5, 7, 8, 11 }),
	getScale("minor Melodic", { 0, 2, 3, 5, 7, 9, 11 }),

	getSeparator("Blues scales"),
	getScale("Major Blues", { 0, 2, 3, 4, 7, 9 }),
	getScale("minor Blues", { 0, 3, 5, 6, 7, 10 }),

	getSeparator("Diminished scales"),
	getScale("Diminished", { 0, 2, 3, 5, 6, 8, 9, 11 }),
	getScale("Complement Diminished", { 0, 1, 3, 4, 6, 7, 9, 10 }),

	getSeparator("Pentatonic scales"),
	getScale("Major Pentatonic", { 0, 2, 4, 7, 9 }),
	getScale("minor Pentatonic", { 0, 3, 5, 7, 10 }),

	getSeparator("World scales"),
	getScale("Raga 1", { 0, 1, 4, 5, 7, 8, 11 }),
	getScale("Raga 2", { 0, 1, 4, 6, 7, 9, 11 }),
	getScale("Raga 3", { 0, 1, 3, 6, 7, 8, 11 }),
	getScale("Arabic", { 0, 2, 4, 5, 6, 8, 10 }),
	getScale("Spanish", { 0, 1, 3, 4, 5, 7, 8, 10 }),
	getScale("Gypsy", { 0, 2, 3, 6, 7, 8, 11 }),
	getScale("Egyptian", { 0, 2, 5, 7, 10 }),
	getScale("Hawaiian", { 0, 2, 3, 7, 9 }),
	getScale("Bali Pelog", { 0, 1, 3, 7, 8 }),
	getScale("Japanese", { 0, 1, 5, 7, 8 }),
	getScale("Ryukyu", { 0, 4, 5, 7, 11 }),
	getScale("Chinese", { 0, 4, 6, 7, 11 }),

	getSeparator("Miscellaneous scales"),
	getScale("Bass Line", { 0, 7, 10 }, 'C3', 'C1'),
	getScale("Wholetone", { 0, 2, 4, 6, 8, 10 }),
	getScale("minor 3rd", { 0, 3, 6, 9 }, 'C0', 'C0'),
	getScale("Major 3rd", { 0, 4, 8 }),
	getScale("4th", { 0, 5, 10 }),
	getScale("5th", { 0, 7 }),
	getScale("Octave", { 0 }, 'C0', 'C0', 2, 1),
}

Musician.PercussionLayout = getScale(
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
