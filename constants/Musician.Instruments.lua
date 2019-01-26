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
	["bagpipe"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bagpipe",
		decay = 100,
		isPercussion = false,
		midi = 109,
		color = Musician.COLORS.LightGreen
	},
	["bassoon"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bassoon",
		decay = 150,
		isPercussion = false,
		midi = 70,
		color = Musician.COLORS.DarkGreen
	},
	["cello"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\cello",
		decay = 100,
		isPercussion = false,
		midi = 42,
		color = Musician.COLORS.DarkOrange
	},
	["clarinet"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\clarinet",
		decay = 150,
		isPercussion = false,
		midi = 71,
		color = Musician.COLORS.Green
	},
	["dulcimer"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\dulcimer",
		decay = 500,
		isPercussion = false,
		isPlucked = true,
		midi = 15,
		color = Musician.COLORS.DarkWhite
	},
	["female-voice"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\female-voice",
		decay = 200,
		isPercussion = false,
		midi = 53,
		color = Musician.COLORS.LightBlue
	},
	["male-voice"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\male-voice",
		decay = 200,
		isPercussion = false,
		midi = 52,
		color = Musician.COLORS.Blue
	},
	["fiddle"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\fiddle",
		decay = 100,
		isPercussion = false,
		midi = 110,
		color = Musician.COLORS.Orange
	},
	["harp"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\harp",
		decay = 500,
		isPercussion = false,
		isPlucked = true,
		midi = 46,
		color = Musician.COLORS.White
	},
	["lute"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\lute",
		decay = 100,
		isPercussion = false,
		isPlucked = true,
		midi = 24,
		color = Musician.COLORS.LightOrange
	},
	["recorder"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\recorder",
		decay = 150,
		isPercussion = false,
		midi = 74,
		color = Musician.COLORS.SpringGreen
	},
	["trombone"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\trombone",
		decay = 150,
		isPercussion = false,
		midi = 57,
		color = Musician.COLORS.DarkYellow
	},
	["trumpet"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\trumpet",
		decay = 150,
		isPercussion = false,
		midi = 56,
		color = Musician.COLORS.Yellow
	},
	["distorsion-guitar"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\distorsion-guitar",
		decay = 75,
		isPercussion = false,
		isPlucked = false,
		midi = 29,
		color = Musician.COLORS.DarkMagenta
	},
	["clean-guitar"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\clean-guitar",
		decay = 75,
		isPercussion = false,
		isPlucked = true,
		midi = 27,
		color = Musician.COLORS.Pink
	},
	["bass-guitar"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bass-guitar",
		decay = 75,
		isPercussion = false,
		isPlucked = true,
		midi = 33,
		color = Musician.COLORS.Purple
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
		transpose = 51 - 39
	},

	-- Percussion
	["clap"] = {
		pathList = {
			"Sound\\Character\\EmoteClap1",
			"Sound\\Character\\EmoteClap2",
			"Sound\\Character\\EmoteClap3",
			"Sound\\Character\\EmoteClap4",
			"Sound\\Character\\EmoteClap5",
			"Sound\\Character\\EmoteClap6",
			"Sound\\Character\\EmoteClap7",
		},
		decay = 100,
		isPercussion = true
	},
	["tambourine-crash-long1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\crash-long1",
		decay = 100,
		isPercussion = true
	},
	["tambourine-crash-long2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\crash-long2",
		decay = 100,
		isPercussion = true
	},
	["tambourine-crash-short1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\crash-short1",
		decay = 100,
		isPercussion = true
	},
	["tambourine-crash-short2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\crash-short2",
		decay = 100,
		isPercussion = true
	},
	["tambourine-crash-short-hi"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\crash-short-hi",
		decay = 100,
		isPercussion = true
	},
	["tambourine-hit1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\hit1",
		decay = 100,
		isPercussion = true
	},
	["tambourine-hit2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\hit2",
		decay = 100,
		isPercussion = true
	},
	["tambourine-shake-long"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\shake-long",
		decay = 100,
		isPercussion = true
	},
	["tambourine-shake-short"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\shake-short",
		decay = 100,
		isPercussion = true
	},
	["rattle-egg"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\rattle-egg\\rattle-egg",
		decay = 100,
		isPercussion = true
	},
	["bodhran-bassdrum-hi"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\bassdrum-hi",
		decay = 250,
		isPercussion = true
	},
	["bodhran-bassdrum-low"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\bassdrum-low",
		decay = 250,
		isPercussion = true,
		midi = 47,
		color = Musician.COLORS.DarkTan
	},
	["bodhran-guiro-hi"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\guiro-hi",
		decay = 100,
		isPercussion = true
	},
	["bodhran-guiro-low"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\guiro-low",
		decay = 100,
		isPercussion = true
	},
	["bodhran-roll-bassdrum"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\roll-bassdrum",
		decay = 100,
		isPercussion = true
	},
	["bodhran-roll-hi"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\roll-hi",
		decay = 100,
		isPercussion = true
	},
	["bodhran-roll-low"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\roll-low",
		decay = 100,
		isPercussion = true
	},
	["bodhran-roll"] = {
		pathList = {
			"Interface\\AddOns\\Musician\\instruments\\bodhran\\roll1",
			"Interface\\AddOns\\Musician\\instruments\\bodhran\\roll2",
			"Interface\\AddOns\\Musician\\instruments\\bodhran\\roll3",
		},
		decay = 100,
		isPercussion = true
	},
	["bodhran-snare-long-hi"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\snare-long-hi",
		decay = 100,
		isPercussion = true,
		midi = 117,
		color = Musician.COLORS.DarkTan
	},
	["bodhran-snare-long-low"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\snare-long-low",
		decay = 100,
		isPercussion = true,
		midi = 118,
		color = Musician.COLORS.DarkTan
	},
	["bodhran-snare-long-med"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\snare-long-med",
		decay = 100,
		isPercussion = true
	},
	["bodhran-snare-short-hi"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\snare-short-hi",
		decay = 100,
		isPercussion = true
	},
	["bodhran-snare-short-low"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\snare-short-low",
		decay = 100,
		isPercussion = true
	},
	["bodhran-stick-hi"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\stick-hi",
		decay = 100,
		isPercussion = true
	},
	["bodhran-stick-low"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\stick-low",
		decay = 100,
		isPercussion = true
	},
	["bodhran-stick-med"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\stick-med",
		decay = 100,
		isPercussion = true
	},
	["bodhran-tom-long-hi"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-long-hi",
		decay = 100,
		isPercussion = true
	},
	["bodhran-tom-long-low"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-long-low",
		decay = 100,
		isPercussion = true
	},
	["bodhran-tom-long-med"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-long-med",
		decay = 100,
		isPercussion = true
	},
	["bodhran-tom-short-hi"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-short-hi",
		decay = 100,
		isPercussion = true
	},
	["bodhran-tom-short-low"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-short-low",
		decay = 100,
		isPercussion = true
	},
	["bodhran-tom-short-med"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-short-med",
		decay = 100,
		isPercussion = true
	},
}


Musician.INSTRUMENTS_AVAILABLE = {
	"lute",
	"recorder",
	"harp",
	"dulcimer",
	"bagpipe",
	"fiddle",
	"cello",
	"female-voice",
	"male-voice",
	"trumpet",
	"trombone",
	"clarinet",
	"bassoon",
	"percussions",
	"bodhran-bassdrum-low",
	"bodhran-snare-long-hi",
	"bodhran-snare-long-low",

	"distorsion-guitar",
	"clean-guitar",
	"bass-guitar",
	"drumkit",

	"none",
}
