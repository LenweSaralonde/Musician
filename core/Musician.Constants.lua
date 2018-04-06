Musician.CHANNEL  = "MusicianComm"
Musician.PASSWORD = "TrustMeIMAMusician"

Musician.URL = "https://lenwe.info/musician"

Musician.FILE_HEADER = "MUS2"
Musician.MAX_NOTE_DURATION = 6
Musician.DURATION_FPS = 256 / Musician.MAX_NOTE_DURATION -- 2^8

Musician.NOTE_NAMES = {[0] = 'C', [1] = 'C#', [2] = 'D', [3] = 'D#', [4] = 'E', [5] = 'F', [6] = 'F#', [7] = 'G', [8] = 'G#', [9] = 'A', [10] = 'A#', [11] = 'B'}
Musician.NOTE_IDS   = {['C'] = 0, ['C#'] = 1, ['D'] = 2, ['D#'] = 3, ['E'] = 4, ['F'] = 5, ['F#'] = 6, ['G'] = 7, ['G#'] = 8, ['A'] = 9, ['A#'] = 10, ['B'] = 11}
Musician.C0_INDEX = 24

Musician.POSITION_UPDATE_PERIOD = 4
Musician.LISTENING_RADIUS = 40

Musician.PLAY_PREROLL = 1

Musician.Msg = {}

Musician.Events = {}
Musician.Events.RefreshFrame = "MusicianRefreshFrame"

Musician.INSTRUMENTS = {
	["none"] = nil,
	["bagpipe"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bagpipe",
		["decay"] = 100,
		["isPercussion"] = false
	},
	["bassoon"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bassoon",
		["decay"] = 150,
		["isPercussion"] = false
	},
	["cello"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\cello",
		["decay"] = 100,
		["isPercussion"] = false
	},
	["clarinet"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\clarinet",
		["decay"] = 150,
		["isPercussion"] = false
	},
	["dulcimer"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\dulcimer",
		["decay"] = 500,
		["isPercussion"] = false
	},
	["female-voice"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\female-voice",
		["decay"] = 200,
		["isPercussion"] = false
	},
	["fiddle"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\fiddle",
		["decay"] = 100,
		["isPercussion"] = false
	},
	["harp"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\harp",
		["decay"] = 500,
		["isPercussion"] = false
	},
	["lute"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\lute",
		["decay"] = 100,
		["isPercussion"] = false
	},
	["recorder"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\recorder",
		["decay"] = 150,
		["isPercussion"] = false
	},
	["trombone"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\trombone",
		["decay"] = 150,
		["isPercussion"] = false
	},
	["trumpet"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\trumpet",
		["decay"] = 150,
		["isPercussion"] = false
	},

	-- Percussion
	["clap"] = {
		["pathFunc"] = function() return "Sound\\Character\\EmoteClap" .. (floor(math.random() * 7) + 1) end, -- EmoteClap1 - 7
		["decay"] = 50,
		["isPercussion"] = true
	},
	["tambourine-crash-long1"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\tambourine\\crash-long1",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["tambourine-crash-long2"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\tambourine\\crash-long2",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["tambourine-crash-short1"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\tambourine\\crash-short1",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["tambourine-crash-short2"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\tambourine\\crash-short2",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["tambourine-crash-short-hi"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\tambourine\\crash-short-hi",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["tambourine-hit1"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\tambourine\\hit1",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["tambourine-hit2"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\tambourine\\hit2",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["tambourine-shake-long"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\tambourine\\shake-long",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["tambourine-shake-short"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\tambourine\\shake-short",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["rattle-egg"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\rattle-egg\\rattle-egg",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["bodhran-bassdrum-hi"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\bassdrum-hi",
		["decay"] = 200,
		["isPercussion"] = true
	},
	["bodhran-bassdrum-low"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\bassdrum-low",
		["decay"] = 200,
		["isPercussion"] = true
	},
	["bodhran-guiro-hi"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\guiro-hi",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["bodhran-guiro-low"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\guiro-low",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["bodhran-roll-bassdrum"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\roll-bassdrum",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["bodhran-roll-hi"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\roll-hi",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["bodhran-roll-low"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\roll-low",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["bodhran-roll"] = {
		["pathFunc"] = function() return "Interface\\AddOns\\Musician\\instruments\\bodhran\\roll" .. (floor(math.random() * 3) + 1) end, -- roll1 - 3
		["decay"] = 50,
		["isPercussion"] = true
	},
	["bodhran-snare-long-hi"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\snare-long-hi",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["bodhran-snare-long-low"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\snare-long-low",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["bodhran-snare-long-med"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\snare-long-med",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["bodhran-snare-short-hi"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\snare-short-hi",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["bodhran-snare-short-low"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\snare-short-low",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["bodhran-stick-hi"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\stick-hi",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["bodhran-stick-low"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\stick-low",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["bodhran-stick-med"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\stick-med",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["bodhran-tom-long-hi"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-long-hi",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["bodhran-tom-long-low"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-long-low",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["bodhran-tom-long-med"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-long-med",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["bodhran-tom-short-hi"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-short-hi",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["bodhran-tom-short-low"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-short-low",
		["decay"] = 50,
		["isPercussion"] = true
	},
	["bodhran-tom-short-med"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-short-med",
		["decay"] = 50,
		["isPercussion"] = true
	},
}

Musician.MIDI_INSTRUMENT_MAPPING = {
	-- 	Piano
	[1] = "dulcimer", -- Acoustic Grand Piano
	[2] = "dulcimer", -- Bright Acoustic Piano
	[3] = "dulcimer", -- Electric Grand Piano
	[4] = "dulcimer", -- Honky-tonk Piano
	[5] = "dulcimer", -- Electric Piano 1
	[6] = "dulcimer", -- Electric Piano 2
	[7] = "harp", -- Harpsichord
	[8] = "harp", -- Clavi

	-- Chromatic Percussion
	[9] = "dulcimer", -- Celesta
	[10] = "dulcimer", -- Glockenspiel
	[11] = "dulcimer", -- Music Box
	[12] = "dulcimer", -- Vibraphone
	[13] = "dulcimer", -- Marimba
	[14] = "dulcimer", -- Xylophone
	[15] = "dulcimer", -- Tubular Bells
	[16] = "dulcimer", -- Dulcimer

	-- Organ
	[17] = "lute", -- Drawbar Organ
	[18] = "lute", -- Percussive Organ
	[19] = "lute", -- Rock Organ
	[20] = "lute", -- Church Organ
	[21] = "lute", -- Reed Organ
	[22] = "lute", -- Accordion
	[23] = "lute", -- Harmonica
	[24] = "lute", -- Tango Accordion

	-- Guitar
	[25] = "lute", -- Acoustic Guitar (nylon)
	[26] = "lute", -- Acoustic Guitar (steel)
	[27] = "lute", -- Electric Guitar (jazz)
	[28] = "lute", -- Electric Guitar (clean)
	[29] = "lute", -- Electric Guitar (muted)
	[30] = "lute", -- Overdriven Guitar
	[31] = "lute", -- Distortion Guitar
	[32] = "lute", -- Guitar harmonics

	-- Bass
	[33] = "lute", -- Acoustic Bass
	[34] = "lute", -- Electric Bass (finger)
	[35] = "lute", -- Electric Bass (pick)
	[36] = "lute", -- Fretless Bass
	[37] = "lute", -- Slap Bass 1
	[38] = "lute", -- Slap Bass 2
	[39] = "lute", -- Synth Bass 1
	[40] = "lute", -- Synth Bass 2

	-- Strings
	[41] = "fiddle", -- Violin
	[42] = "fiddle", -- Viola
	[43] = "cello", -- Cello
	[44] = "cello", -- Contrabass
	[45] = "fiddle", -- Tremolo Strings
	[46] = "lute", -- Pizzicato Strings
	[47] = "harp", -- Orchestral Harp
	[48] = "bodhran-bassdrum-low", -- Timpani

	-- Ensemble
	[49] = "fiddle", -- String Ensemble 1
	[50] = "fiddle", -- String Ensemble 2
	[51] = "fiddle", -- SynthStrings 1
	[52] = "fiddle", -- SynthStrings 2
	[53] = "female-voice", -- Choir Aahs
	[54] = "female-voice", -- Voice Oohs
	[55] = "female-voice", -- Synth Voice
	[56] = "lute", -- Orchestra Hit

	-- Brass
	[57] = "trumpet", -- Trumpet
	[58] = "trombone", -- Trombone
	[59] = "trombone", -- Tuba
	[60] = "trumpet", -- Muted Trumpet
	[61] = "trumpet", -- French Horn
	[62] = "trumpet", -- Brass Section
	[63] = "trumpet", -- SynthBrass 1
	[64] = "trumpet", -- SynthBrass 2

	-- Reed
	[65] = "clarinet", -- Soprano Sax
	[66] = "clarinet", -- Alto Sax
	[67] = "bassoon", -- Tenor Sax
	[68] = "bassoon", -- Baritone Sax
	[69] = "clarinet", -- Oboe
	[70] = "clarinet", -- English Horn
	[71] = "bassoon", -- Bassoon
	[72] = "clarinet", -- Clarinet

	-- Pipe
	[73] = "recorder", -- Piccolo
	[74] = "recorder", -- Flute
	[75] = "recorder", -- Recorder
	[76] = "recorder", -- Pan Flute
	[77] = "recorder", -- Blown Bottle
	[78] = "recorder", -- Shakuhachi
	[79] = "recorder", -- Whistle
	[80] = "recorder", -- Ocarina

	-- Synth Lead
	[81] = "clarinet", -- Lead 1 (square)
	[82] = "fiddle", -- Lead 2 (sawtooth)
	[83] = "recorder", -- Lead 3 (calliope)
	[84] = "recorder", -- Lead 4 (chiff)
	[85] = "recorder", -- Lead 5 (charang)
	[86] = "female-voice", -- Lead 6 (voice)
	[87] = "fiddle", -- Lead 7 (fifths)
	[88] = "lute", -- Lead 8 (bass + lead)

	-- Synth Pad
	[89] = "lute", -- Pad 1 (new age)
	[90] = "fiddle", -- Pad 2 (warm)
	[91] = "fiddle", -- Pad 3 (polysynth)
	[92] = "fiddle", -- Pad 4 (choir)
	[93] = "fiddle", -- Pad 5 (bowed)
	[94] = "fiddle", -- Pad 6 (metallic)
	[95] = "fiddle", -- Pad 7 (halo)
	[96] = "fiddle", -- Pad 8 (sweep)

	-- Synth Effects
	[97] = "dulcimer", -- FX 1 (rain)
	[98] = "dulcimer", -- FX 2 (soundtrack)
	[99] = "dulcimer", -- FX 3 (crystal)
	[100] = "dulcimer", -- FX 4 (atmosphere)
	[101] = "dulcimer", -- FX 5 (brightness)
	[102] = "dulcimer", -- FX 6 (goblins)
	[103] = "dulcimer", -- FX 7 (echoes)
	[104] = "dulcimer", -- FX 8 (sci-fi)

	-- Ethnic
	[105] = "dulcimer", -- Sitar
	[106] = "lute", -- Banjo
	[107] = "lute", -- Shamisen
	[108] = "dulcimer", -- Koto
	[109] = "dulcimer", -- Kalimba
	[110] = "bagpipe", -- Bag pipe
	[111] = "fiddle", -- Fiddle
	[112] = "bagpipe", -- Shanai

	-- Percussive
	[113] = "lute", -- Tinkle Bell
	[114] = "none", -- Agogo
	[115] = "dulcimer", -- Steel Drums
	[116] = "none", -- Woodblock
	[117] = "bodhran-bassdrum-low", -- Taiko Drum
	[118] = "bodhran-snare-long-hi", -- Melodic Tom
	[119] = "bodhran-snare-long-low", -- Synth Drum
	[120] = "none", -- Reverse Cymbal

	-- Sound Effects
	[121] = "none", -- Guitar Fret Noise
	[122] = "none", -- Breath Noise
	[123] = "none", -- Seashore
	[124] = "none", -- Bird Tweet
	[125] = "none", -- Telephone Ring
	[126] = "none", -- Helicopter
	[127] = "none", -- Applause
	[128] = "none", -- Gunshot
}

Musician.MIDI_PERCUSSION_MAPPING = {
	[27] = "none", -- Laser
	[28] = "none", -- Whip
	[29] = "bodhran-roll-hi", -- Scratch Push
	[30] = "bodhran-roll-low", -- Scratch Pull
	[31] = "bodhran-stick-hi", -- 	Stick Click
	[32] = "bodhran-stick-hi", -- 	Square Click
	[33] = "bodhran-stick-med", -- 	Metronome Click
	[34] = "bodhran-stick-low", -- 	Metronome Bell
	[35] = "bodhran-bassdrum-low", -- Acoustic Bass Drum
	[36] = "bodhran-bassdrum-hi", -- Bass Drum 1
	[37] = "bodhran-stick-low", -- Side Stick
	[38] = "bodhran-snare-long-low", -- Acoustic Snare
	[39] = "clap", -- Hand Clap
	[40] = "bodhran-snare-long-hi", -- Electric Snare
	[41] = "bodhran-tom-long-low", -- Low Floor Tom
	[42] = "tambourine-hit1", -- Closed Hi Hat
	[43] = "bodhran-tom-long-med", -- High Floor Tom
	[44] = "tambourine-shake-short", -- Pedal Hi-Hat
	[45] = "bodhran-tom-long-hi", -- Low Tom
	[46] = "tambourine-shake-long", -- Open Hi-Hat
	[47] = "bodhran-tom-short-low", -- Low-Mid Tom
	[48] = "bodhran-tom-short-med", -- Hi-Mid Tom
	[49] = "tambourine-crash-long1", -- Crash Cymbal 1
	[50] = "bodhran-tom-short-hi", -- High Tom
	[51] = "tambourine-hit1", -- Ride Cymbal 1
	[52] = "tambourine-shake-long", -- Chinese Cymbal
	[53] = "tambourine-hit2", -- Ride Bell
	[54] = "tambourine-hit2", -- Tambourine
	[55] = "tambourine-crash-short-hi", -- Splash Cymbal
	[56] = "bodhran-stick-low", -- Cowbell
	[57] = "tambourine-crash-long2", -- Crash Cymbal 2
	[58] = "bodhran-guiro-hi", -- Vibraslap
	[59] = "tambourine-hit2", -- Ride Cymbal 2
	[60] = "bodhran-tom-short-hi", -- Hi Bongo
	[61] = "bodhran-tom-short-low", -- Low Bongo
	[62] = "bodhran-stick-hi", -- Mute Hi Conga
	[63] = "bodhran-tom-short-hi", -- Open Hi Conga
	[64] = "bodhran-tom-short-low", -- Low Conga
	[65] = "bodhran-tom-long-hi", -- High Timbale
	[66] = "bodhran-tom-long-med", -- Low Timbale
	[67] = "bodhran-stick-hi", -- High Agogo
	[68] = "bodhran-stick-low", -- Low Agogo
	[69] = "rattle-egg", -- Cabasa
	[70] = "rattle-egg", -- Maracas
	[71] = "none", -- Short Whistle
	[72] = "none", -- Long Whistle
	[73] = "bodhran-stick-med", -- Short Guiro
	[74] = "bodhran-guiro-low", -- Long Guiro
	[75] = "bodhran-stick-med", -- Claves
	[76] = "bodhran-stick-hi", -- Hi Wood Block
	[77] = "bodhran-stick-low", -- Low Wood Block
	[78] = "none", -- Mute Cuica
	[79] = "none", -- Open Cuica
	[80] = "tambourine-crash-short1", -- Mute Triangle
	[81] = "tambourine-crash-short2", -- Open Triangle
	[82] = "rattle-egg", -- Shaker
	[83] = "tambourine-shake-long", -- Sleigh Bell
	[84] = "none", -- Bell Tree
	[85] = "clap", -- Castanets
	[86] = "bodhran-tom-long-low", -- Surdu Dead Stroke
	[87] = "bodhran-tom-short-low", -- Surdu
	[91] = "none", -- Snare Drum Rod
	[92] = "none", -- Ocean Drum
	[93] = "none", -- Snare Drum Brush
}
