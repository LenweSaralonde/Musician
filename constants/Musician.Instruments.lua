--- Instrument definitions
-- @module Musician.Instruments

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

--- Instruments table. The key is the internal instrument ID (string) and each value is a table having the following attribues:
-- @field[opt] color (table) Color {r, g, b} from Musician.COLORS
-- @field[opt] name (string) Same as the instrument id (automatically generated)
-- @field[opt] midi (int) General MIDI instrument ID (0-127). For percussions, midi is its MIDI ID + 128
-- @field[opt] decay (number) Decay duration in seconds
-- @field[opt] isPlucked (boolean) True for plucked instruments such as guitar, piano etc. Used for visualization only.
-- @field[opt] path (string) Path to the instrument melodic samples directory.
-- @field[opt] regions (table) Tables of path, lokey and hikey (inclusive) in replacement of path allowing picking melodic samples from multiple directories according to the MIDI key range defined by lokey and hikey.
-- @field[opt] isPercussion (boolean) Act as a percussion instrument using the single sample file (without extension) from path or picked from pathList using keyMod or roundRobin methods
-- @field[opt] pathList (table) List of file paths to be chosen using keyMod or roundRobin (without extension)
-- @field[opt] keyMod (int) Plays nth sample file from pathList modulo the MIDI key number
-- @field[opt] roundRobin (boolean) Plays sample file from pathList using round robin
-- @field[opt] source (string) Credits to author, software, library etc used to create the instrument. Displayed in the "About" window.
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
		decay = 75,
		isPercussion = false,
		midi = 70,
		color = Musician.COLORS.DarkGreen,
		source = "Ethan Winer Bassoon"
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
		source = "Mats Helgesson Maestro Clarinet"
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
		source = "ERA II Vocal Codex"
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
		midi = 144,
		color = Musician.COLORS.Red,
		source = "E-mu Systems '96"
	},

	-- Percussion
	["war-drum"] = {
		pathList = {
			"Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-long-A",
			"Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-long-Bb",
			"Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-long-B",
			"Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-long-C",
			"Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-long-C#",
			"Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-long-D",
			"Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-long-D#",
			"Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-long-E",
			"Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-long-F",
			"Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-long-F#",
			"Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-long-G",
			"Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-long-G#",
		},
		decay = 200,
		isPercussion = true,
		keyMod = -3,
		midi = 47,
		color = Musician.COLORS.DarkTan,
		source = "Kstnbass Frame Drum"
	},
	["frame-drum-kick-1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-kick-1",
		decay = 100,
		isPercussion = true,
		source = "Sonic Bloom Frame Drum"
	},
	["frame-drum-kick-2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-kick-2",
		decay = 100,
		isPercussion = true,
		source = "Sonic Bloom Frame Drum"
	},
	["frame-drum-snare-1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-snare-1",
		decay = 100,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["frame-drum-snare-2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-snare-2",
		decay = 100,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["frame-drum-roll-1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-roll-1",
		decay = 100,
		isPercussion = true,
		source = "ERA II Medieval Legends"
	},
	["frame-drum-roll-2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-roll-2",
		decay = 100,
		isPercussion = true,
		source = "ERA II Medieval Legends"
	},
	["frame-drum-roll-3"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-roll-3",
		decay = 100,
		isPercussion = true,
		source = "ERA II Medieval Legends"
	},
	["frame-drum-hit"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-hit",
		decay = 100,
		isPercussion = true,
		source = "ERA II Medieval Legends"
	},
	["sticks"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\misc-percussions\\sticks",
		decay = 100,
		isPercussion = true,
		source = "Michael Picher Auxiliary Percussion"
	},
	["misc-hit"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\misc-percussions\\misc-hit",
		decay = 100,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["cajon-hit"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\misc-percussions\\cajon-hit",
		decay = 100,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["clap"] = {
		pathList = {
			"Interface\\AddOns\\Musician\\instruments\\claps\\clap-1",
			"Interface\\AddOns\\Musician\\instruments\\claps\\clap-2",
			"Interface\\AddOns\\Musician\\instruments\\claps\\clap-3",
			"Interface\\AddOns\\Musician\\instruments\\claps\\clap-4",
			"Interface\\AddOns\\Musician\\instruments\\claps\\clap-5",
			"Interface\\AddOns\\Musician\\instruments\\claps\\clap-6",
			"Interface\\AddOns\\Musician\\instruments\\claps\\clap-7",
		},
		decay = 100,
		isPercussion = true,
		source = "LenweSaralonde Claps"
	},
	["tambourine-short"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\tambourine-short",
		decay = 100,
		isPercussion = true,
		source = "Michael Picher Auxiliary Percussion"
	},
	["tambourine-shake"] = {
		pathList = {
			"Interface\\AddOns\\Musician\\instruments\\tambourine\\tambourine-shake-1",
			"Interface\\AddOns\\Musician\\instruments\\tambourine\\tambourine-shake-2",
		},
		decay = 300,
		isPercussion = true,
		midi = 119,
		color = Musician.COLORS.DarkTan,
		source = "Michael Picher Auxiliary Percussion"
	},
	["tambourine-long"] = {
		pathList = {
			"Interface\\AddOns\\Musician\\instruments\\tambourine\\tambourine-long-1",
			"Interface\\AddOns\\Musician\\instruments\\tambourine\\tambourine-long-2",
			"Interface\\AddOns\\Musician\\instruments\\tambourine\\tambourine-long-3",
			"Interface\\AddOns\\Musician\\instruments\\tambourine\\tambourine-long-4",
		},
		decay = 250,
		isPercussion = true,
		source = "Michael Picher Auxiliary Percussion"
	},
	["riq-hit-1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\riq-hit-1",
		decay = 100,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["riq-hit-2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\riq-hit-2",
		decay = 100,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["riq-hit-3"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\riq-hit-3",
		decay = 100,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["riq-hit-4"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\riq-hit-4",
		decay = 100,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["riq-hit-5"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\riq-hit-5",
		decay = 100,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["riq-shake-1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\riq-shake-1",
		decay = 100,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["riq-shake-2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\riq-shake-2",
		decay = 100,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["bodhran-1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\bodhran-1",
		decay = 300,
		isPercussion = true,
		source = "Bosone Bodhran"
	},
	["bodhran-2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\bodhran-2",
		decay = 300,
		isPercussion = true,
		source = "Bosone Bodhran"
	},
	["bodhran-3"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\bodhran-3",
		decay = 300,
		isPercussion = true,
		source = "Bosone Bodhran"
	},
	["bodhran-4"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\bodhran-4",
		decay = 300,
		isPercussion = true,
		source = "Bosone Bodhran"
	},
	["bodhran-5"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\bodhran-5",
		decay = 300,
		isPercussion = true,
		source = "Bosone Bodhran"
	},
	["bodhran-6"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\bodhran-6",
		decay = 300,
		isPercussion = true,
		source = "Bosone Bodhran"
	},
	["barbarian-frame-drum-dead-stroke"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\barbarian-frame-drum-dead-stroke",
		decay = 100,
		isPercussion = true,
		source = "ERA II Medieval Legends"
	},
	["barbarian-frame-drum"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\barbarian-frame-drum",
		decay = 300,
		isPercussion = true,
		source = "ERA II Medieval Legends"
	},
	["frame-drum-timbale-1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-timbale-1",
		decay = 100,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["frame-drum-timbale-2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-timbale-2",
		decay = 100,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["djembe-hi-1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\djembe\\djembe-hi-1",
		decay = 100,
		isPercussion = true,
		source = "Samplephonics Gambian Percussion"
	},
	["djembe-hi-2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\djembe\\djembe-hi-2",
		decay = 100,
		isPercussion = true,
		source = "Samplephonics Gambian Percussion"
	},
	["djembe-hi-3"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\djembe\\djembe-hi-3",
		decay = 100,
		isPercussion = true,
		source = "Samplephonics Gambian Percussion"
	},
	["djembe-muted"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\djembe\\djembe-muted",
		decay = 100,
		isPercussion = true,
		source = "Samplephonics Gambian Percussion"
	},
	["djembe-bass"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\djembe\\djembe-bass",
		decay = 100,
		isPercussion = true,
		source = "Samplephonics Gambian Percussion"
	},
	["claves"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\misc-percussions\\claves",
		decay = 100,
		isPercussion = true,
		source = "Michael Picher Auxiliary Percussion"
	},
	["woodblock-hi"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\misc-percussions\\woodblock-hi",
		decay = 100,
		isPercussion = true,
		source = "Michael Picher Auxiliary Percussion"
	},
	["woodblock-low"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\misc-percussions\\woodblock-low",
		decay = 100,
		isPercussion = true,
		source = "Michael Picher Auxiliary Percussion"
	},
	["woodblock"] = {
		pathList = {
			"Interface\\AddOns\\Musician\\instruments\\misc-percussions\\woodblock-hi",
			"Interface\\AddOns\\Musician\\instruments\\misc-percussions\\woodblock-low",
		},
		midi = 115,
		decay = 100,
		isPercussion = true,
		color = Musician.COLORS.DarkTan,
		source = "Michael Picher Auxiliary Percussion"
	},
	["shaker"] = {
		pathList = {
			"Interface\\AddOns\\Musician\\instruments\\misc-percussions\\shaker-1",
			"Interface\\AddOns\\Musician\\instruments\\misc-percussions\\shaker-2",
			"Interface\\AddOns\\Musician\\instruments\\misc-percussions\\shaker-3",
			"Interface\\AddOns\\Musician\\instruments\\misc-percussions\\shaker-4",
		},
		decay = 100,
		isPercussion = true,
		source = "Michael Picher Auxiliary Percussion"
	},
	["sleigh-bells"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\misc-percussions\\sleigh-bells",
		decay = 200,
		isPercussion = true,
		source = "Michael Picher Auxiliary Percussion"
	},
	["sleigh-bells-shake"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\misc-percussions\\sleigh-bells-shake",
		decay = 300,
		isPercussion = true,
		source = "Michael Picher Auxiliary Percussion"
	},
	["metallic-1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\misc-percussions\\metallic-1",
		decay = 200,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["metallic-2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\misc-percussions\\metallic-2",
		decay = 200,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
}

--- Ordered list of internal instrument IDs available to the end user
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

	"distorsion-guitar",
	"clean-guitar",
	"bass-guitar",

	"percussions",
	"drumkit",
	"war-drum",
	"woodblock",
	"tambourine-shake",

	"none",
}
