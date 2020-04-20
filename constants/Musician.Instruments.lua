Musician.COLORS = {
	Red = {0.77, 0.12, 0.23},
	DarkMagenta = {0.64, 0.19, 0.79},
	LightOrange = {1.00, 0.49*1.5, 0.04*1.5},
	Orange = {1.00, 0.49, 0.04},
	DarkOrange = {1.00, 0.49/1.5, 0.04/1.5},
	LightGreen = {1, 0.94, 0.6},
	Green = {0.67, 0.83, 0.45},
	DarkGreen = {0.67/1.5, 0.83/1.5, 0.45/1.5},
	LightBlue = {0.41, 0.80, 0.94},
	SpringGreen = {0.00, 1.00, 0.59},
	DarkSpringGreen = {0.00, 1.00/1.5, 0.59/1.5},
	Pink = {0.96, 0.55, 0.73},
	White = {1.00, 1.00, 1.00},
	DarkWhite = {0.8, 0.8, 0.8},
	Yellow = {1.00, 0.96, 0.41},
	DarkYellow = {1.00/1.5, 0.96/1.5, 0.41/1.5},
	Brown = {1.00/1.5, 0.96/3, 0.41/3},
	Blue = {0.00, 0.44, 0.87},
	Purple = {0.58, 0.51, 0.79},
	Tan = {0.78, 0.61, 0.43},
	DarkTan = {0.78/1.5, 0.61/1.5, 0.43/1.5},
	Gray = {0.6, 0.6, 0.6},
}

Musician.INSTRUMENTS = {
	["none"] = {
		midi = -1,
		color = Musician.COLORS.Gray
	},
	["accordion"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\accordion",
		decay = 100,
		isPercussion = false,
		midi = 22,
		color = Musician.COLORS.DarkSpringGreen,
		source = "Safwan Matni Accordion"
	},
	["bagpipe"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bagpipe",
		decay = 100,
		isPercussion = false,
		midi = 109,
		color = Musician.COLORS.LightGreen,
		source = "ERA II Medieval Legends"
	},
	["bassoon"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bassoon",
		decay = 150,
		isPercussion = false,
		midi = 70,
		color = Musician.COLORS.DarkGreen,
		source = "Sinfonia 3"
	},
	["viola-da-gamba"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\viola-da-gamba",
		decay = 150,
		isPercussion = false,
		midi = 42,
		color = Musician.COLORS.DarkOrange,
		source = "ERA II Medieval Legends"
	},
	["clarinet"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\clarinet",
		decay = 150,
		isPercussion = false,
		midi = 71,
		color = Musician.COLORS.Green,
		source = "Sinfonia 3"
	},
	["dulcimer"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\dulcimer",
		decay = 500,
		isPercussion = false,
		isPlucked = true,
		midi = 15,
		color = Musician.COLORS.DarkWhite,
		source = "LABS Dulcimer"
	},
	["female-voice"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\female-voice",
		decay = 100,
		isPercussion = false,
		midi = 53,
		color = Musician.COLORS.LightBlue,
		source = "Irina Brochin"
	},
	["male-voice"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\male-voice",
		decay = 100,
		isPercussion = false,
		midi = 52,
		color = Musician.COLORS.Blue,
		source = "ERA II Vocal Codex"
	},
	["fiddle"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\fiddle",
		decay = 100,
		isPercussion = false,
		midi = 110,
		color = Musician.COLORS.Orange,
		source = "Lewis E. Pyle Violin"
	},
	["harp"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\harp",
		decay = 500,
		isPercussion = false,
		isPlucked = true,
		midi = 46,
		color = Musician.COLORS.White,
		source = "Etherealwinds Harp II CE"
	},
	["lute"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\lute",
		decay = 100,
		isPercussion = false,
		isPlucked = true,
		midi = 24,
		color = Musician.COLORS.LightOrange,
		source = "ERA II Medieval Legends"
	},
	["recorder"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\recorder",
		decay = 150,
		isPercussion = false,
		midi = 74,
		color = Musician.COLORS.SpringGreen,
		source = "ERA II Medieval Legends"
	},
	["sackbut"] = {
		regions = {
			{
				path = "Interface\\AddOns\\Musician\\instruments\\sackbut",
				loKey = 12, -- C0
				hiKey = 72, -- C5
			},
			{
				path = "Interface\\AddOns\\Musician\\instruments\\trumpet",
				loKey = 73, -- C#5
				hiKey = 108, -- C8
			}
		},
		decay = 150,
		isPercussion = false,
		midi = 57,
		color = Musician.COLORS.DarkYellow,
		source = "ERA II Medieval Legends"
	},
	["trumpet"] = {
		regions = {
			{
				path = "Interface\\AddOns\\Musician\\instruments\\sackbut",
				loKey = 12, -- C0
				hiKey = 54, -- F#3
			},
			{
				path = "Interface\\AddOns\\Musician\\instruments\\trumpet",
				loKey = 55, -- G3
				hiKey = 108, -- C8
			}
		},
		decay = 75,
		isPercussion = false,
		midi = 56,
		color = Musician.COLORS.Yellow,
		source = "ERA II Medieval Legends"
	},
	["war-horn"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\war-horn",
		decay = 150,
		isPercussion = false,
		midi = 60,
		color = Musician.COLORS.Brown,
		source = "ERA II Medieval Legends"
	},
	["distorsion-guitar"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\distorsion-guitar",
		decay = 75,
		isPercussion = false,
		isPlucked = false,
		midi = 29,
		color = Musician.COLORS.DarkMagenta,
		source = "DirectGuitar 2.0"
	},
	["clean-guitar"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\clean-guitar",
		decay = 75,
		isPercussion = false,
		isPlucked = true,
		midi = 27,
		color = Musician.COLORS.Pink,
		source = "DirectGuitar 2.0"
	},
	["bass-guitar"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bass-guitar",
		decay = 75,
		isPercussion = false,
		isPlucked = true,
		midi = 33,
		color = Musician.COLORS.Purple,
		source = "BooBass"
	},
	["percussions"] = {
		midi = 128,
		color = Musician.COLORS.Tan
	},
	["drumkit"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\drumkit",
		decay = 150,
		isPercussion = false,
		isPlucked = true,
		midi = 129,
		color = Musician.COLORS.Red,
		transpose = 12, -- Percussions' middle C is shifted
		source = "E-mu Systems '96"
	},

	-- Percussion
}


Musician.INSTRUMENTS_AVAILABLE = {
	"lute",
	"recorder",
	"harp",
	"dulcimer",
	"bagpipe",
	"accordion",
	"fiddle",
	"viola-da-gamba",
	"female-voice",
	"male-voice",
	"trumpet",
	"sackbut",
	"war-horn",
	"clarinet",
	"bassoon",
	"percussions",

	"distorsion-guitar",
	"clean-guitar",
	"bass-guitar",
	"drumkit",

	"none",
}
