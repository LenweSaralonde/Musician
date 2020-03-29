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
	["cello"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\cello",
		decay = 100,
		isPercussion = false,
		midi = 42,
		color = Musician.COLORS.DarkOrange,
		source = "Sinfonia 3"
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
		decay = 200,
		isPercussion = false,
		midi = 53,
		color = Musician.COLORS.LightBlue,
		source = "Irina Brochin"
	},
	["male-voice"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\male-voice",
		decay = 200,
		isPercussion = false,
		midi = 52,
		color = Musician.COLORS.Blue,
		source = "Olympus Mike-Ro Solo Tenor"
	},
	["fiddle"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\fiddle",
		decay = 100,
		isPercussion = false,
		midi = 110,
		color = Musician.COLORS.Orange,
		source = "Celtic And Folks Sounds For Christmas"
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
		source = "BOB Early Music Renaissance Lute"
	},
	["recorder"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\recorder",
		decay = 150,
		isPercussion = false,
		midi = 74,
		color = Musician.COLORS.SpringGreen,
		source = "Feroyn's Flute"
	},
	["trombone"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\trombone",
		decay = 150,
		isPercussion = false,
		midi = 57,
		color = Musician.COLORS.DarkYellow,
		source = "Sinfonia 3"
	},
	["trumpet"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\trumpet",
		decay = 150,
		isPercussion = false,
		midi = 56,
		color = Musician.COLORS.Yellow,
		source = "Sinfonia 3"
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
	["clap"] = {
		pathList = {
			"Interface\\AddOns\\Musician\\instruments\\claps\\clap1",
			"Interface\\AddOns\\Musician\\instruments\\claps\\clap2",
			"Interface\\AddOns\\Musician\\instruments\\claps\\clap3",
			"Interface\\AddOns\\Musician\\instruments\\claps\\clap4",
			"Interface\\AddOns\\Musician\\instruments\\claps\\clap5",
			"Interface\\AddOns\\Musician\\instruments\\claps\\clap6",
			"Interface\\AddOns\\Musician\\instruments\\claps\\clap7",
		},
		decay = 100,
		isPercussion = true,
		source = "LenweSaralonde"
	},
	["tambourine-crash-long1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\crash-long1",
		decay = 100,
		isPercussion = true,
		source = "ELPHNT SHAKE"
	},
	["tambourine-crash-long2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\crash-long2",
		decay = 100,
		isPercussion = true,
		source = "ELPHNT SHAKE"
	},
	["tambourine-crash-short1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\crash-short1",
		decay = 100,
		isPercussion = true,
		source = "ELPHNT SHAKE"
	},
	["tambourine-crash-short2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\crash-short2",
		decay = 100,
		isPercussion = true,
		source = "ELPHNT SHAKE"
	},
	["tambourine-crash-short-hi"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\crash-short-hi",
		decay = 100,
		isPercussion = true,
		source = "ELPHNT SHAKE"
	},
	["tambourine-hit1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\hit1",
		decay = 100,
		isPercussion = true,
		source = "ELPHNT SHAKE"
	},
	["tambourine-hit2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\hit2",
		decay = 100,
		isPercussion = true,
		source = "ELPHNT SHAKE"
	},
	["tambourine-shake-long"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\shake-long",
		decay = 100,
		isPercussion = true,
		source = "ELPHNT SHAKE"
	},
	["tambourine-shake-short"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\shake-short",
		decay = 100,
		isPercussion = true,
		source = "ELPHNT SHAKE"
	},
	["rattle-egg"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\rattle-egg\\rattle-egg",
		decay = 100,
		isPercussion = true,
		source = "qubodup"
	},
	["bodhran-bassdrum-hi"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\bassdrum-hi",
		decay = 250,
		isPercussion = true,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-bassdrum-low"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\bassdrum-low",
		decay = 250,
		isPercussion = true,
		midi = 47,
		color = Musician.COLORS.DarkTan,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-guiro-hi"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\guiro-hi",
		decay = 100,
		isPercussion = true,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-guiro-low"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\guiro-low",
		decay = 100,
		isPercussion = true,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-roll-bassdrum"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\roll-bassdrum",
		decay = 100,
		isPercussion = true,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-roll-hi"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\roll-hi",
		decay = 100,
		isPercussion = true,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-roll-low"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\roll-low",
		decay = 100,
		isPercussion = true,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-roll"] = {
		pathList = {
			"Interface\\AddOns\\Musician\\instruments\\bodhran\\roll1",
			"Interface\\AddOns\\Musician\\instruments\\bodhran\\roll2",
			"Interface\\AddOns\\Musician\\instruments\\bodhran\\roll3",
		},
		decay = 100,
		isPercussion = true,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-snare-long-hi"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\snare-long-hi",
		decay = 100,
		isPercussion = true,
		midi = 117,
		color = Musician.COLORS.DarkTan,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-snare-long-low"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\snare-long-low",
		decay = 100,
		isPercussion = true,
		midi = 118,
		color = Musician.COLORS.DarkTan,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-snare-long-med"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\snare-long-med",
		decay = 100,
		isPercussion = true,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-snare-short-hi"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\snare-short-hi",
		decay = 100,
		isPercussion = true,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-snare-short-low"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\snare-short-low",
		decay = 100,
		isPercussion = true,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-stick-hi"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\stick-hi",
		decay = 100,
		isPercussion = true,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-stick-low"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\stick-low",
		decay = 100,
		isPercussion = true,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-stick-med"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\stick-med",
		decay = 100,
		isPercussion = true,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-tom-long-hi"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-long-hi",
		decay = 100,
		isPercussion = true,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-tom-long-low"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-long-low",
		decay = 100,
		isPercussion = true,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-tom-long-med"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-long-med",
		decay = 100,
		isPercussion = true,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-tom-short-hi"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-short-hi",
		decay = 100,
		isPercussion = true,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-tom-short-low"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-short-low",
		decay = 100,
		isPercussion = true,
		source = "FMJ-Soft Bodhran"
	},
	["bodhran-tom-short-med"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-short-med",
		decay = 100,
		isPercussion = true,
		source = "FMJ-Soft Bodhran"
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
