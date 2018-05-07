Musician.CHANNEL  = "MusicianComm"
Musician.PASSWORD = "TrustMeIMAMusician"

Musician.URL = "https://lenwe.info/musician"
Musician.CONVERTER_URL = "https://lenwe.info/musician-midi-convert"

Musician.FILE_HEADER = "MUS2"
Musician.MAX_NOTE_DURATION = 6
Musician.DURATION_FPS = 255 / Musician.MAX_NOTE_DURATION -- 2^8

Musician.NOTE_NAMES = {[0] = 'C', [1] = 'C#', [2] = 'D', [3] = 'D#', [4] = 'E', [5] = 'F', [6] = 'F#', [7] = 'G', [8] = 'G#', [9] = 'A', [10] = 'A#', [11] = 'B'}
Musician.NOTE_IDS   = {['C'] = 0, ['C#'] = 1, ['D'] = 2, ['D#'] = 3, ['E'] = 4, ['F'] = 5, ['F#'] = 6, ['G'] = 7, ['G#'] = 8, ['A'] = 9, ['A#'] = 10, ['B'] = 11}
Musician.C0_INDEX = 24

Musician.POSITION_UPDATE_PERIOD = 4
Musician.LISTENING_RADIUS = 40

Musician.PLAY_PREROLL = 1

Musician.Msg = {}

Musician.Events = {}
Musician.Events.RefreshFrame = "MusicianRefreshFrame"
Musician.Events.SongPlay = "MusicianSongPlay"
Musician.Events.SongStop = "MusicianSongStop"

Musician.Icons = {}
Musician.Icons.PlayerMuted = "Interface\\AddOns\\Musician\\ui\\textures\\muted.blp"
Musician.Icons.PlayerUnmuted = "Interface\\AddOns\\Musician\\ui\\textures\\unmuted.blp"

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
	["male-voice"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\male-voice",
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
	[0] = "dulcimer", -- Acoustic Grand Piano
	[1] = "dulcimer", -- Bright Acoustic Piano
	[2] = "dulcimer", -- Electric Grand Piano
	[3] = "dulcimer", -- Honky-tonk Piano
	[4] = "dulcimer", -- Electric Piano 1
	[5] = "dulcimer", -- Electric Piano 2
	[6] = "harp", -- Harpsichord
	[7] = "harp", -- Clavi

	-- Chromatic Percussion
	[8] = "dulcimer", -- Celesta
	[9] = "dulcimer", -- Glockenspiel
	[10] = "dulcimer", -- Music Box
	[11] = "dulcimer", -- Vibraphone
	[12] = "dulcimer", -- Marimba
	[13] = "dulcimer", -- Xylophone
	[14] = "dulcimer", -- Tubular Bells
	[15] = "dulcimer", -- Dulcimer

	-- Organ
	[16] = "lute", -- Drawbar Organ
	[17] = "lute", -- Percussive Organ
	[18] = "lute", -- Rock Organ
	[19] = "lute", -- Church Organ
	[20] = "lute", -- Reed Organ
	[21] = "lute", -- Accordion
	[22] = "lute", -- Harmonica
	[23] = "lute", -- Tango Accordion

	-- Guitar
	[24] = "lute", -- Acoustic Guitar (nylon)
	[25] = "lute", -- Acoustic Guitar (steel)
	[26] = "lute", -- Electric Guitar (jazz)
	[27] = "lute", -- Electric Guitar (clean)
	[28] = "lute", -- Electric Guitar (muted)
	[29] = "lute", -- Overdriven Guitar
	[30] = "lute", -- Distortion Guitar
	[31] = "lute", -- Guitar harmonics

	-- Bass
	[32] = "lute", -- Acoustic Bass
	[33] = "lute", -- Electric Bass (finger)
	[34] = "lute", -- Electric Bass (pick)
	[35] = "lute", -- Fretless Bass
	[36] = "lute", -- Slap Bass 1
	[37] = "lute", -- Slap Bass 2
	[38] = "lute", -- Synth Bass 1
	[39] = "lute", -- Synth Bass 2

	-- Strings
	[40] = "fiddle", -- Violin
	[41] = "fiddle", -- Viola
	[42] = "cello", -- Cello
	[43] = "cello", -- Contrabass
	[44] = "fiddle", -- Tremolo Strings
	[45] = "lute", -- Pizzicato Strings
	[46] = "harp", -- Orchestral Harp
	[47] = "bodhran-bassdrum-low", -- Timpani

	-- Ensemble
	[48] = "fiddle", -- String Ensemble 1
	[49] = "fiddle", -- String Ensemble 2
	[50] = "fiddle", -- SynthStrings 1
	[51] = "fiddle", -- SynthStrings 2
	[52] = "male-voice", -- Choir Aahs
	[53] = "female-voice", -- Voice Oohs
	[54] = "female-voice", -- Synth Voice
	[55] = "lute", -- Orchestra Hit

	-- Brass
	[56] = "trumpet", -- Trumpet
	[57] = "trombone", -- Trombone
	[58] = "trombone", -- Tuba
	[59] = "trumpet", -- Muted Trumpet
	[60] = "trumpet", -- French Horn
	[61] = "trumpet", -- Brass Section
	[62] = "trumpet", -- SynthBrass 1
	[63] = "trumpet", -- SynthBrass 2

	-- Reed
	[64] = "clarinet", -- Soprano Sax
	[65] = "clarinet", -- Alto Sax
	[66] = "bassoon", -- Tenor Sax
	[67] = "bassoon", -- Baritone Sax
	[68] = "clarinet", -- Oboe
	[69] = "clarinet", -- English Horn
	[70] = "bassoon", -- Bassoon
	[71] = "clarinet", -- Clarinet

	-- Pipe
	[72] = "recorder", -- Piccolo
	[73] = "recorder", -- Flute
	[74] = "recorder", -- Recorder
	[75] = "recorder", -- Pan Flute
	[76] = "recorder", -- Blown Bottle
	[77] = "recorder", -- Shakuhachi
	[78] = "recorder", -- Whistle
	[79] = "recorder", -- Ocarina

	-- Synth Lead
	[80] = "clarinet", -- Lead 1 (square)
	[81] = "fiddle", -- Lead 2 (sawtooth)
	[82] = "recorder", -- Lead 3 (calliope)
	[83] = "recorder", -- Lead 4 (chiff)
	[84] = "recorder", -- Lead 5 (charang)
	[85] = "female-voice", -- Lead 6 (voice)
	[86] = "fiddle", -- Lead 7 (fifths)
	[87] = "lute", -- Lead 8 (bass + lead)

	-- Synth Pad
	[88] = "lute", -- Pad 1 (new age)
	[89] = "fiddle", -- Pad 2 (warm)
	[90] = "fiddle", -- Pad 3 (polysynth)
	[91] = "fiddle", -- Pad 4 (choir)
	[92] = "fiddle", -- Pad 5 (bowed)
	[93] = "fiddle", -- Pad 6 (metallic)
	[94] = "fiddle", -- Pad 7 (halo)
	[95] = "fiddle", -- Pad 8 (sweep)

	-- Synth Effects
	[96] = "dulcimer", -- FX 1 (rain)
	[97] = "dulcimer", -- FX 2 (soundtrack)
	[98] = "dulcimer", -- FX 3 (crystal)
	[99] = "dulcimer", -- FX 4 (atmosphere)
	[100] = "dulcimer", -- FX 5 (brightness)
	[101] = "dulcimer", -- FX 6 (goblins)
	[102] = "dulcimer", -- FX 7 (echoes)
	[103] = "dulcimer", -- FX 8 (sci-fi)

	-- Ethnic
	[104] = "dulcimer", -- Sitar
	[105] = "lute", -- Banjo
	[106] = "lute", -- Shamisen
	[107] = "dulcimer", -- Koto
	[108] = "dulcimer", -- Kalimba
	[109] = "bagpipe", -- Bag pipe
	[110] = "fiddle", -- Fiddle
	[111] = "bagpipe", -- Shanai

	-- Percussive
	[112] = "lute", -- Tinkle Bell
	[113] = "none", -- Agogo
	[114] = "dulcimer", -- Steel Drums
	[115] = "none", -- Woodblock
	[116] = "bodhran-bassdrum-low", -- Taiko Drum
	[117] = "bodhran-snare-long-hi", -- Melodic Tom
	[118] = "bodhran-snare-long-low", -- Synth Drum
	[119] = "none", -- Reverse Cymbal

	-- Sound Effects
	[120] = "none", -- Guitar Fret Noise
	[121] = "none", -- Breath Noise
	[122] = "none", -- Seashore
	[123] = "none", -- Bird Tweet
	[124] = "none", -- Telephone Ring
	[125] = "none", -- Helicopter
	[126] = "none", -- Applause
	[127] = "none", -- Gunshot
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
