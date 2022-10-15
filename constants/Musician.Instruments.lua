--- Instrument definitions
-- @module Musician.Instruments

--- Available instrument colors
-- @table Musician.COLORS
-- @field Red (table)
-- @field DarkMagenta (table)
-- @field LightOrange (table)
-- @field Orange (table)
-- @field DarkOrange (table)
-- @field LightGreen (table)
-- @field Green (table)
-- @field DarkGreen (table)
-- @field LightBlue (table)
-- @field SpringGreen (table)
-- @field DarkSpringGreen (table)
-- @field Pink (table)
-- @field White (table)
-- @field DarkWhite (table)
-- @field Yellow (table)
-- @field DarkYellow (table)
-- @field Brown (table)
-- @field Blue (table)
-- @field Purple (table)
-- @field Tan (table)
-- @field DarkTan (table)
-- @field Gray (table)
Musician.COLORS = {
	Red = { 0.77, 0.12, 0.23 },
	DarkMagenta = { 0.64, 0.19, 0.79 },
	LightOrange = { 1.00, 0.49 * 1.5, 0.04 * 1.5 },
	Orange = { 1.00, 0.49, 0.04 },
	DarkOrange = { 1.00, 0.49 / 1.5, 0.04 / 1.5 },
	LightGreen = { 1, 0.94, 0.6 },
	Green = { 0.67, 0.83, 0.45 },
	DarkGreen = { 0.67 / 1.5, 0.83 / 1.5, 0.45 / 1.5 },
	LightBlue = { 0.41, 0.80, 0.94 },
	SpringGreen = { 0.00, 1.00, 0.59 },
	DarkSpringGreen = { 0.00, 1.00 / 1.5, 0.59 / 1.5 },
	Pink = { 0.96, 0.55, 0.73 },
	White = { 1.00, 1.00, 1.00 },
	DarkWhite = { 0.8, 0.8, 0.8 },
	LightYellow = { 1.00, 0.96, 0.85 },
	Yellow = { 1.00, 0.96, 0.41 },
	DarkYellow = { 1.00 / 1.5, 0.96 / 1.5, 0.41 / 1.5 },
	Brown = { 1.00 / 1.5, 0.96 / 3, 0.41 / 3 },
	Blue = { 0.00, 0.44, 0.87 },
	Purple = { 0.58, 0.51, 0.79 },
	Tan = { 0.78, 0.61, 0.43 },
	DarkTan = { 0.78 / 1.5, 0.61 / 1.5, 0.43 / 1.5 },
	Gray = { 0.6, 0.6, 0.6 },
}

--- Instruments table. The key is the internal instrument ID (string) and each value is a table having the following attribues (all are optional):
--
--  color (table) Color {r, g, b} from Musician.COLORS
--
--  name (string) Same as the instrument id (automatically generated)
--
--  midi (int) General MIDI instrument ID (0-127). For percussions, midi is its MIDI ID + 128
--
--  decay (number) Decay duration in milliseconds
--
--  isPlucked (boolean) True for plucked instruments such as guitar, piano etc. Used for visualization only.
--
--  path (string) Path to the instrument melodic samples directory.
--
--  regions (table) Tables of path, lokey and hikey (inclusive) in replacement of path allowing picking melodic samples from multiple directories according to the MIDI key range defined by lokey and hikey.
--
--  isPercussion (boolean) Act as a percussion instrument using the single sample file (without extension) from path or picked from pathList using keyMod or roundRobin methods
--
--  pathList (table) List of file paths to be chosen using keyMod or roundRobin (without extension)
--
--  keyMod (int) Plays nth sample file from pathList modulo the MIDI key number
--
--  roundRobin (boolean) Plays sample file from pathList using round robin
--
--  source (string) Credits to author, software, library etc used to create the instrument. Displayed in the "About" window.
-- @table Musician.INSTRUMENTS
-- @field none (table)
-- @field accordion (table)
-- @field bagpipe (table)
-- @field bassoon (table)
-- @field viola_da_gamba (table)
-- @field clarinet (table)
-- @field dulcimer (table)
-- @field piano (table)
-- @field female_voice (table)
-- @field male_voice (table)
-- @field fiddle (table)
-- @field harp (table)
-- @field lute (table)
-- @field recorder (table)
-- @field sackbut (table)
-- @field trumpet (table)
-- @field war_horn (table)
-- @field distortion_guitar (table)
-- @field clean_guitar (table)
-- @field bass_guitar (table)
-- @field percussions (table)
-- @field drumkit (table)
-- @field war_drum (table)
-- @field frame_drum_kick_1 (table)
-- @field frame_drum_kick_2 (table)
-- @field frame_drum_snare_1 (table)
-- @field frame_drum_snare_2 (table)
-- @field frame_drum_roll_1 (table)
-- @field frame_drum_roll_2 (table)
-- @field frame_drum_roll_3 (table)
-- @field frame_drum_hit (table)
-- @field sticks (table)
-- @field misc_hit (table)
-- @field cajon_hit (table)
-- @field clap (table)
-- @field tambourine_short (table)
-- @field tambourine_shake (table)
-- @field tambourine_long (table)
-- @field riq_hit_1 (table)
-- @field riq_hit_2 (table)
-- @field riq_hit_3 (table)
-- @field riq_hit_4 (table)
-- @field riq_hit_5 (table)
-- @field riq_shake_1 (table)
-- @field riq_shake_2 (table)
-- @field bodhran_1 (table)
-- @field bodhran_2 (table)
-- @field bodhran_3 (table)
-- @field bodhran_4 (table)
-- @field bodhran_5 (table)
-- @field bodhran_6 (table)
-- @field barbarian_frame_drum_dead_stroke (table)
-- @field barbarian_frame_drum (table)
-- @field frame_drum_timbale_1 (table)
-- @field frame_drum_timbale_2 (table)
-- @field djembe_hi_1 (table)
-- @field djembe_hi_2 (table)
-- @field djembe_hi_3 (table)
-- @field djembe_muted (table)
-- @field djembe_bass (table)
-- @field claves (table)
-- @field woodblock_hi (table)
-- @field woodblock_low (table)
-- @field woodblock (table)
-- @field shaker (table)
-- @field sleigh_bells (table)
-- @field sleigh_bells_shake (table)
-- @field metallic_1 (table)
-- @field metallic_2 (table)
Musician.INSTRUMENTS = {
	["none"] = {
		midi = -1,
		color = Musician.COLORS.Gray
	},
	["accordion"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\accordion",
		decay = 100,
		isPercussion = false,
		midi = 21,
		loop = { 5, 5 },
		crossfade = 100,
		color = Musician.COLORS.DarkSpringGreen,
		source = "Safwan Matni Accordion"
	},
	["bagpipe"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bagpipe",
		decay = 100,
		isPercussion = false,
		midi = 109,
		loop = { 4, 5 },
		crossfade = 100,
		color = Musician.COLORS.LightGreen,
		source = "ERA II Medieval Legends"
	},
	["bassoon"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\bassoon",
		decay = 75,
		isPercussion = false,
		midi = 70,
		loop = { 4, 5 },
		crossfade = 150,
		color = Musician.COLORS.DarkGreen,
		source = "Ethan Winer Bassoon"
	},
	["viola_da_gamba"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\viola-da-gamba",
		decay = 150,
		isPercussion = false,
		midi = 42,
		loop = { 5, 5 },
		crossfade = 150,
		color = Musician.COLORS.DarkOrange,
		source = "ERA II Medieval Legends"
	},
	["clarinet"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\clarinet",
		decay = 150,
		isPercussion = false,
		midi = 71,
		loop = { 4, 5 },
		crossfade = 150,
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
	["piano"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\piano",
		decay = 200,
		isPercussion = false,
		isPlucked = true,
		midi = 0,
		color = Musician.COLORS.White,
		source = "NeoPiano mini"
	},
	["female_voice"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\female-voice",
		decay = 100,
		isPercussion = false,
		midi = 53,
		loop = { 4, 5 },
		crossfade = 100,
		color = Musician.COLORS.LightBlue,
		source = "ERA II Vocal Codex"
	},
	["male_voice"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\male-voice",
		decay = 100,
		isPercussion = false,
		midi = 52,
		loop = { 2.5, 3.5 },
		crossfade = 100,
		color = Musician.COLORS.Blue,
		source = "ERA II Vocal Codex"
	},
	["fiddle"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\fiddle",
		decay = 100,
		isPercussion = false,
		midi = 110,
		loop = { 5, 5 },
		crossfade = 100,
		color = Musician.COLORS.Orange,
		source = "Lewis E. Pyle Violin"
	},
	["harp"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\harp",
		decay = 500,
		isPercussion = false,
		isPlucked = true,
		midi = 46,
		color = Musician.COLORS.LightYellow,
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
		loop = { 4, 5 },
		crossfade = 150,
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
		loop = { 4, 5 },
		crossfade = 150,
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
		loop = { 4, 5 },
		crossfade = 150,
		color = Musician.COLORS.Yellow,
		source = "ERA II Medieval Legends"
	},
	["war_horn"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\war-horn",
		decay = 150,
		isPercussion = false,
		midi = 60,
		loop = { 4, 5 },
		crossfade = 150,
		color = Musician.COLORS.Brown,
		source = "ERA II Medieval Legends"
	},
	["distortion_guitar"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\distortion-guitar",
		decay = 75,
		isPercussion = false,
		isPlucked = false,
		midi = 29,
		color = Musician.COLORS.DarkMagenta,
		source = "DirectGuitar 2.0"
	},
	["clean_guitar"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\clean-guitar",
		decay = 75,
		isPercussion = false,
		isPlucked = true,
		midi = 27,
		color = Musician.COLORS.Pink,
		source = "DirectGuitar 2.0"
	},
	["bass_guitar"] = {
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
		decay = 100,
		decayByKey = {
			[27] = 35,
			[28] = 211,
			[29] = 130,
			[30] = 125,
			[31] = 141,
			[32] = 2,
			[33] = 63,
			[34] = 1000,
			[35] = 111,
			[36] = 99,
			[37] = 111,
			[38] = 248,
			[39] = 169,
			[40] = 268,
			[41] = 1000,
			[42] = 75,
			[43] = 1000,
			[44] = 88,
			[45] = 1000,
			[46] = 1000,
			[47] = 1000,
			[48] = 1000,
			[49] = 1000,
			[50] = 1000,
			[51] = 1000,
			[52] = 1000,
			[53] = 1000,
			[54] = 755,
			[55] = 1000,
			[56] = 106,
			[57] = 1000,
			[58] = 1000,
			[59] = 1000,
			[60] = 238,
			[61] = 134,
			[62] = 170,
			[63] = 1000,
			[64] = 1000,
			[65] = 1000,
			[66] = 1000,
			[67] = 603,
			[68] = 894,
			[69] = 114,
			[70] = 110,
			[71] = 486,
			[72] = 505,
			[73] = 143,
			[74] = 276,
			[75] = 94,
			[76] = 108,
			[77] = 145,
			[78] = 156,
			[79] = 169,
			[80] = 89,
			[81] = 1000,
			[82] = 60,
			[83] = 1000,
			[84] = 1000,
			[85] = 128,
			[86] = 248,
			[87] = 1000,
		},
		isPercussion = false,
		isPlucked = true,
		midi = 144,
		color = Musician.COLORS.Red,
		source = "E-mu Systems '96"
	},

	-- Percussion
	["war_drum"] = {
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
		decay = 1000,
		isPercussion = true,
		keyMod = -3,
		midi = 47,
		color = Musician.COLORS.DarkTan,
		source = "Kstnbass Frame Drum"
	},
	["frame_drum_kick_1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-kick-1",
		decay = 108,
		isPercussion = true,
		source = "Sonic Bloom Frame Drum"
	},
	["frame_drum_kick_2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-kick-2",
		decay = 93,
		isPercussion = true,
		source = "Sonic Bloom Frame Drum"
	},
	["frame_drum_snare_1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-snare-1",
		decay = 498,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["frame_drum_snare_2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-snare-2",
		decay = 498,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["frame_drum_roll_1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-roll-1",
		decay = 1000,
		isPercussion = true,
		source = "ERA II Medieval Legends"
	},
	["frame_drum_roll_2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-roll-2",
		decay = 793,
		isPercussion = true,
		source = "ERA II Medieval Legends"
	},
	["frame_drum_roll_3"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-roll-3",
		decay = 528,
		isPercussion = true,
		source = "ERA II Medieval Legends"
	},
	["frame_drum_hit"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-hit",
		decay = 339,
		isPercussion = true,
		source = "ERA II Medieval Legends"
	},
	["sticks"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\misc-percussions\\sticks",
		decay = 99,
		isPercussion = true,
		source = "Michael Picher Auxiliary Percussion"
	},
	["misc_hit"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\misc-percussions\\misc-hit",
		decay = 133,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["cajon_hit"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\misc-percussions\\cajon-hit",
		decay = 323,
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
		decay = 150,
		isPercussion = true,
		source = "LenweSaralonde Claps"
	},
	["tambourine_short"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\tambourine-short",
		decay = 250,
		isPercussion = true,
		source = "Michael Picher Auxiliary Percussion"
	},
	["tambourine_shake"] = {
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
	["tambourine_long"] = {
		pathList = {
			"Interface\\AddOns\\Musician\\instruments\\tambourine\\tambourine-long-1",
			"Interface\\AddOns\\Musician\\instruments\\tambourine\\tambourine-long-2",
			"Interface\\AddOns\\Musician\\instruments\\tambourine\\tambourine-long-3",
			"Interface\\AddOns\\Musician\\instruments\\tambourine\\tambourine-long-4",
		},
		decay = 300,
		isPercussion = true,
		source = "Michael Picher Auxiliary Percussion"
	},
	["riq_hit_1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\riq-hit-1",
		decay = 753,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["riq_hit_2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\riq-hit-2",
		decay = 928,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["riq_hit_3"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\riq-hit-3",
		decay = 1000,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["riq_hit_4"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\riq-hit-4",
		decay = 625,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["riq_hit_5"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\riq-hit-5",
		decay = 1000,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["riq_shake_1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\riq-shake-1",
		decay = 572,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["riq_shake_2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\tambourine\\riq-shake-2",
		decay = 838,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["bodhran_1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\bodhran-1",
		decay = 1000,
		isPercussion = true,
		source = "Bosone Bodhran"
	},
	["bodhran_2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\bodhran-2",
		decay = 1000,
		isPercussion = true,
		source = "Bosone Bodhran"
	},
	["bodhran_3"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\bodhran-3",
		decay = 1000,
		isPercussion = true,
		source = "Bosone Bodhran"
	},
	["bodhran_4"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\bodhran-4",
		decay = 1000,
		isPercussion = true,
		source = "Bosone Bodhran"
	},
	["bodhran_5"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\bodhran-5",
		decay = 1000,
		isPercussion = true,
		source = "Bosone Bodhran"
	},
	["bodhran_6"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\bodhran-6",
		decay = 1000,
		isPercussion = true,
		source = "Bosone Bodhran"
	},
	["barbarian_frame_drum_dead_stroke"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\barbarian-frame-drum-dead-stroke",
		decay = 317,
		isPercussion = true,
		source = "ERA II Medieval Legends"
	},
	["barbarian_frame_drum"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\barbarian-frame-drum",
		decay = 1000,
		isPercussion = true,
		source = "ERA II Medieval Legends"
	},
	["frame_drum_timbale_1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-timbale-1",
		decay = 589,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["frame_drum_timbale_2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\frame-drum\\frame-drum-timbale-2",
		decay = 758,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["djembe_hi_1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\djembe\\djembe-hi-1",
		decay = 650,
		isPercussion = true,
		source = "Samplephonics Gambian Percussion"
	},
	["djembe_hi_2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\djembe\\djembe-hi-2",
		decay = 472,
		isPercussion = true,
		source = "Samplephonics Gambian Percussion"
	},
	["djembe_hi_3"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\djembe\\djembe-hi-3",
		decay = 661,
		isPercussion = true,
		source = "Samplephonics Gambian Percussion"
	},
	["djembe_muted"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\djembe\\djembe-muted",
		decay = 341,
		isPercussion = true,
		source = "Samplephonics Gambian Percussion"
	},
	["djembe_bass"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\djembe\\djembe-bass",
		decay = 498,
		isPercussion = true,
		source = "Samplephonics Gambian Percussion"
	},
	["claves"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\misc-percussions\\claves",
		decay = 102,
		isPercussion = true,
		source = "Michael Picher Auxiliary Percussion"
	},
	["woodblock_hi"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\misc-percussions\\woodblock-hi",
		decay = 106,
		isPercussion = true,
		source = "Michael Picher Auxiliary Percussion"
	},
	["woodblock_low"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\misc-percussions\\woodblock-low",
		decay = 95,
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
		decay = 400,
		isPercussion = true,
		source = "Michael Picher Auxiliary Percussion"
	},
	["sleigh_bells"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\misc-percussions\\sleigh-bells",
		decay = 568,
		isPercussion = true,
		source = "Michael Picher Auxiliary Percussion"
	},
	["sleigh_bells_shake"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\misc-percussions\\sleigh-bells-shake",
		decay = 725,
		isPercussion = true,
		source = "Michael Picher Auxiliary Percussion"
	},
	["metallic_1"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\misc-percussions\\metallic-1",
		decay = 625,
		isPercussion = true,
		source = "Loopmasters Frame Drums"
	},
	["metallic_2"] = {
		path = "Interface\\AddOns\\Musician\\instruments\\misc-percussions\\metallic-2",
		decay = 1000,
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
	"piano",
	"bagpipe",
	"accordion",
	"fiddle",
	"viola_da_gamba",
	"female_voice",
	"male_voice",
	"trumpet",
	"sackbut",
	"war_horn",
	"clarinet",
	"bassoon",

	"distortion_guitar",
	"clean_guitar",
	"bass_guitar",

	"percussions",
	"drumkit",
	"war_drum",
	"woodblock",
	"tambourine_shake",

	"none",
}