Musician.Locale.en = {}

local msg = Musician.Locale.en
local Instrument = Musician.MIDI_INSTRUMENTS
local Percussion = Musician.MIDI_PERCUSSIONS

msg.PLAY = "Play"
msg.STOP = "Stop"
msg.PAUSE = "Pause"
msg.TEST_SONG = "Preview"
msg.STOP_TEST = "Stop preview"
msg.CLEAR = "Clear"
msg.SELECT_ALL = "Select all"
msg.EDIT = "Edit"
msg.MUTE = "Mute"
msg.UNMUTE = "Unmute"

msg.MENU_TITLE = "Musician"
msg.MENU_IMPORT_SONG = "Import and play a song"
msg.MENU_PLAY = msg.PLAY
msg.MENU_STOP = msg.STOP
msg.MENU_PLAY_PREVIEW = msg.TEST_SONG
msg.MENU_STOP_PREVIEW = msg.STOP_TEST
msg.MENU_LIVE_PLAY = "Live play"
msg.MENU_SHOW_KEYBOARD = "Open keyboard"

msg.STARTUP = "Welcome to Musician v{version}."

msg.NEW_VERSION = "A new version of Musician has been released! Download the update from {url} ."
msg.NEW_MAJOR_VERSION = "Your version of Musician is obsolete and does not work anymore.\nPlease download the update from\n{url}"
msg.SHOULD_CONFIGURE_KEYBOARD = "You have to configure the keyboard before playing."

msg.PLAYER_TOOLTIP = "Musician"
msg.PLAYER_TOOLTIP_VERSION = "Musician v{version}"
msg.PLAYER_TOOLTIP_PRELOADING = "Preloading sounds… ({progress})"

msg.PLAYER_COUNT_ONLINE = "There are {count} other music fans around!"
msg.PLAYER_COUNT_ONLINE_ONE = "There is another music fan around!"

msg.INVALID_MUSIC_CODE = "Invalid music code."

msg.PLAY_A_SONG = "Play a song"
msg.IMPORT_A_SONG = "Import a song"
msg.PASTE_MUSIC_CODE = "Import your song in MIDI format at:\n{url}\n\nthen paste the music code here ({shortcut})..."
msg.SONG_IMPORTED = "Loaded song: {title}."

msg.SONG_EDITOR = "Song editor"
msg.MARKER_FROM = "From"
msg.MARKER_TO = "To"
msg.POSITION = "Position"
msg.TRACK_NUMBER = "Track #{track}"
msg.CHANNEL_NUMBER_SHORT = "Ch.{channel}"
msg.JUMP_PREV = "Back 10s"
msg.JUMP_NEXT = "Forward 10s"
msg.GO_TO_START = "Go to start"
msg.GO_TO_END = "Go to end"
msg.SET_CROP_FROM = "Set start point"
msg.SET_CROP_TO = "Set end point"
msg.MUTE_TRACK = "Mute"
msg.SOLO_TRACK = "Solo"
msg.TRANSPOSE_TRACK = "Transpose (octave)"
msg.CHANGE_TRACK_INSTRUMENT = "Change instrument"
msg.HEADER_NUMBER = "#"
msg.HEADER_OCTAVE = "Octave"
msg.HEADER_INSTRUMENT = "Instrument"

msg.CONFIGURE_KEYBOARD = "Configure keyboard"
msg.CONFIGURE_KEYBOARD_HINT = "Click a key to set..."
msg.CONFIGURE_KEYBOARD_HINT_COMPLETE = "Keyboard configuration is complete.\nYou can now save your changes and start playing music!"
msg.CONFIGURE_KEYBOARD_START_OVER = "Start over"
msg.CONFIGURE_KEYBOARD_SAVE = "Save configuration"
msg.PRESS_KEY_BINDING = "Press the key #{col} in row #{row}."
msg.KEY_CAN_BE_MERGED = "This key might be {key} on your keyboard."
msg.KEY_IS_OPTIONAL = "This key is optional."

local KEY = Musician.KEYBOARD_KEY
msg.FIXED_KEY_NAMES = {
	[KEY.Backspace] = "Back",
	[KEY.Tab] = "Tab",
	[KEY.CapsLock] = "Caps lock",
	[KEY.Enter] = "Enter",
	[KEY.ShiftLeft] = "Shift",
	[KEY.ShiftRight] = "Shift",
	[KEY.ControlLeft] = "Ctrl",
	[KEY.MetaLeft] = "Meta",
	[KEY.AltLeft] = "Alt",
	[KEY.Space] = "Space",
	[KEY.AltRight] = "Alt",
	[KEY.MetaRight] = "Meta",
	[KEY.ContextMenu] = "Menu",
	[KEY.ControlRight] = "Ctrl",
}

msg.KEYBOARD_LAYOUTS = {}

msg.LIVE_SONG_NAME = "Live song"
msg.SOLO_MODE = "Solo Mode"
msg.LIVE_MODE = "Live Mode"
msg.LIVE_MODE_DISABLED = "Live Mode is disabled during playback."
msg.ENABLE_SOLO_MODE = "Enable Solo Mode (you play for yourself)"
msg.ENABLE_LIVE_MODE = "Enable Live Mode (you play for everyone)"
msg.PLAY_LIVE = "Play live"
msg.PLAY_SOLO = "Play solo"
msg.SHOW_KEYBOARD = "Show keyboard"
msg.HIDE_KEYBOARD = "Hide keyboard"
msg.KEYBOARD_LAYOUT = "Keyboard mode & scale"
msg.CHANGE_KEYBOARD_LAYOUT = "Change keyboard layout"
msg.BASE_KEY = "Base key"
msg.CHANGE_BASE_KEY = "Base key"
msg.CHANGE_LOWER_INSTRUMENT = "Change lower instrument"
msg.CHANGE_UPPER_INSTRUMENT = "Change upper instrument"
msg.POWER_CHORDS = "Power chords"
msg.PROGRAM_BUTTON = "P {num}"
msg.LOAD_PROGRAM_NUM = "Load program #{num} ({key})"
msg.SAVE_PROGRAM_NUM = "Save in program #{num} ({key})"
msg.WRITE_PROGRAM = "Save program ({key})"
msg.PROGRAM_SAVED = "Program #{num} saved."

msg.LAYERS = {
	[Musician.KEYBOARD_LAYER.UPPER] = "Upper",
	[Musician.KEYBOARD_LAYER.LOWER] = "Lower",
}

msg.EMOTE_PLAYING_MUSIC = "is playing a song."
msg.EMOTE_PROMO = "(Get \"Musician\" add-on or upgrade it from {url} to listen!)"
msg.EMOTE_SONG_NOT_LOADED = "(The song cannot play because {player} is using an incompatible version.)"
msg.EMOTE_PLAYER_OTHER_REALM = "(This player is on another realm.)"

msg.TOOLTIP_LEFT_CLICK = "**Left click** : {action}"
msg.TOOLTIP_RIGHT_CLICK = "**Right click** : {action}"
msg.TOOLTIP_DRAG_AND_DROP = "**Drag and drop** to move"
msg.TOOLTIP_ISMUTED = "(muted)"
msg.TOOLTIP_ACTION_SHOW = "Show"
msg.TOOLTIP_ACTION_HIDE = "Hide"
msg.TOOLTIP_ACTION_MUTE = "Mute all music"
msg.TOOLTIP_ACTION_UNMUTE = "Unmute music"

msg.PLAYER_MENU_TITLE = "Music"
msg.PLAYER_MENU_STOP_CURRENT_SONG = "Stop current song"
msg.PLAYER_MENU_MUTE = "Mute"
msg.PLAYER_MENU_UNMUTE = "Unmute"

msg.PLAYER_IS_MUTED = "{icon}{player} is now muted."
msg.PLAYER_IS_UNMUTED = "{icon}{player} is now unmuted."

msg.INSTRUMENT_NAMES = {
	["none"] = "(None)",
	["bagpipe"] = "Bagpipe",
	["dulcimer"] = "Dulcimer (hammered)",
	["lute"] = "Lute",
	["cello"] = "Cello",
	["harp"] = "Celtic harp",
	["bodhran-bassdrum-low"] = "Bodhrán (bassdrum)",
	["male-voice"] = "Male voice (tenor)",
	["female-voice"] = "Female voice (soprano)",
	["trumpet"] = "Trumpet",
	["trombone"] = "Trombone",
	["bassoon"] = "Bassoon",
	["clarinet"] = "Clarinet",
	["recorder"] = "Recorder",
	["fiddle"] = "Fiddle",
	["bodhran-snare-long-hi"] = "Bodhrán (snare high)",
	["bodhran-snare-long-low"] = "Bodhrán (snare low)",
	["percussions"] = "Percussions (traditional)",
	["distorsion-guitar"] = "Distorsion guitar",
	["clean-guitar"] = "Clean guitar",
	["bass-guitar"] = "Bass guitar",
	["drumkit"] = "Drum kit",
}

msg.MIDI_INSTRUMENT_NAMES = {
	[Instrument.AcousticGrandPiano] = "Acoustic Grand Piano",
	[Instrument.BrightAcousticPiano] = "Bright Acoustic Piano",
	[Instrument.ElectricGrandPiano] = "Electric Grand Piano",
	[Instrument.HonkyTonkPiano] = "Honky-tonk Piano",
	[Instrument.ElectricPiano1] = "Electric Piano 1",
	[Instrument.ElectricPiano2] = "Electric Piano 2",
	[Instrument.Harpsichord] = "Harpsichord",
	[Instrument.Clavi] = "Clavi",

	[Instrument.Celesta] = "Celesta",
	[Instrument.Glockenspiel] = "Glockenspiel",
	[Instrument.MusicBox] = "Music Box",
	[Instrument.Vibraphone] = "Vibraphone",
	[Instrument.Marimba] = "Marimba",
	[Instrument.Xylophone] = "Xylophone",
	[Instrument.TubularBells] = "Tubular Bells",
	[Instrument.Dulcimer] = "Dulcimer",

	[Instrument.DrawbarOrgan] = "Drawbar Organ",
	[Instrument.PercussiveOrgan] = "Percussive Organ",
	[Instrument.RockOrgan] = "Rock Organ",
	[Instrument.ChurchOrgan] = "Church Organ",
	[Instrument.ReedOrgan] = "Reed Organ",
	[Instrument.Accordion] = "Accordion",
	[Instrument.Harmonica] = "Harmonica",
	[Instrument.TangoAccordion] = "Tango Accordion",

	[Instrument.AcousticGuitarNylon] = "Acoustic Guitar (nylon)",
	[Instrument.AcousticGuitarSteel] = "Acoustic Guitar (steel)",
	[Instrument.ElectricGuitarJazz] = "Electric Guitar (jazz)",
	[Instrument.ElectricGuitarClean] = "Electric Guitar (clean)",
	[Instrument.ElectricGuitarMuted] = "Electric Guitar (muted)",
	[Instrument.OverdrivenGuitar] = "Overdriven Guitar",
	[Instrument.DistortionGuitar] = "Distortion Guitar",
	[Instrument.Guitarharmonics] = "Guitar harmonics",

	[Instrument.AcousticBass] = "Acoustic Bass",
	[Instrument.ElectricBassFinger] = "Electric Bass (finger)",
	[Instrument.ElectricBassPick] = "Electric Bass (pick)",
	[Instrument.FretlessBass] = "Fretless Bass",
	[Instrument.SlapBass1] = "Slap Bass 1",
	[Instrument.SlapBass2] = "Slap Bass 2",
	[Instrument.SynthBass1] = "Synth Bass 1",
	[Instrument.SynthBass2] = "Synth Bass 2",

	[Instrument.Violin] = "Violin",
	[Instrument.Viola] = "Viola",
	[Instrument.Cello] = "Cello",
	[Instrument.Contrabass] = "Contrabass",
	[Instrument.TremoloStrings] = "Tremolo Strings",
	[Instrument.PizzicatoStrings] = "Pizzicato Strings",
	[Instrument.OrchestralHarp] = "Orchestral Harp",
	[Instrument.Timpani] = "Timpani",

	[Instrument.StringEnsemble1] = "String Ensemble 1",
	[Instrument.StringEnsemble2] = "String Ensemble 2",
	[Instrument.SynthStrings1] = "SynthStrings 1",
	[Instrument.SynthStrings2] = "SynthStrings 2",
	[Instrument.ChoirAahs] = "Choir Aahs",
	[Instrument.VoiceOohs] = "Voice Oohs",
	[Instrument.SynthVoice] = "Synth Voice",
	[Instrument.OrchestraHit] = "Orchestra Hit",

	[Instrument.Trumpet] = "Trumpet",
	[Instrument.Trombone] = "Trombone",
	[Instrument.Tuba] = "Tuba",
	[Instrument.MutedTrumpet] = "Muted Trumpet",
	[Instrument.FrenchHorn] = "French Horn",
	[Instrument.BrassSection] = "Brass Section",
	[Instrument.SynthBrass1] = "SynthBrass 1",
	[Instrument.SynthBrass2] = "SynthBrass 2",

	[Instrument.SopranoSax] = "Soprano Sax",
	[Instrument.AltoSax] = "Alto Sax",
	[Instrument.TenorSax] = "Tenor Sax",
	[Instrument.BaritoneSax] = "Baritone Sax",
	[Instrument.Oboe] = "Oboe",
	[Instrument.EnglishHorn] = "English Horn",
	[Instrument.Bassoon] = "Bassoon",
	[Instrument.Clarinet] = "Clarinet",

	[Instrument.Piccolo] = "Piccolo",
	[Instrument.Flute] = "Flute",
	[Instrument.Recorder] = "Recorder",
	[Instrument.PanFlute] = "Pan Flute",
	[Instrument.BlownBottle] = "Blown Bottle",
	[Instrument.Shakuhachi] = "Shakuhachi",
	[Instrument.Whistle] = "Whistle",
	[Instrument.Ocarina] = "Ocarina",

	[Instrument.Lead1Square] = "Lead 1 (square)",
	[Instrument.Lead2Sawtooth] = "Lead 2 (sawtooth)",
	[Instrument.Lead3Calliope] = "Lead 3 (calliope)",
	[Instrument.Lead4Chiff] = "Lead 4 (chiff)",
	[Instrument.Lead5Charang] = "Lead 5 (charang)",
	[Instrument.Lead6Voice] = "Lead 6 (voice)",
	[Instrument.Lead7Fifths] = "Lead 7 (fifths)",
	[Instrument.Lead8BassLead] = "Lead 8 (bass + lead)",

	[Instrument.Pad1Newage] = "Pad 1 (new age)",
	[Instrument.Pad2Warm] = "Pad 2 (warm)",
	[Instrument.Pad3Polysynth] = "Pad 3 (polysynth)",
	[Instrument.Pad4Choir] = "Pad 4 (choir)",
	[Instrument.Pad5Bowed] = "Pad 5 (bowed)",
	[Instrument.Pad6Metallic] = "Pad 6 (metallic)",
	[Instrument.Pad7Halo] = "Pad 7 (halo)",
	[Instrument.Pad8Sweep] = "Pad 8 (sweep)",

	[Instrument.FX1Rain] = "FX 1 (rain)",
	[Instrument.FX2Soundtrack] = "FX 2 (soundtrack)",
	[Instrument.FX3Crystal] = "FX 3 (crystal)",
	[Instrument.FX4Atmosphere] = "FX 4 (atmosphere)",
	[Instrument.FX5Brightness] = "FX 5 (brightness)",
	[Instrument.FX6Goblins] = "FX 6 (goblins)",
	[Instrument.FX7Echoes] = "FX 7 (echoes)",
	[Instrument.FX8SciFi] = "FX 8 (sci-fi)",

	[Instrument.Sitar] = "Sitar",
	[Instrument.Banjo] = "Banjo",
	[Instrument.Shamisen] = "Shamisen",
	[Instrument.Koto] = "Koto",
	[Instrument.Kalimba] = "Kalimba",
	[Instrument.Bagpipe] = "Bag pipe",
	[Instrument.Fiddle] = "Fiddle",
	[Instrument.Shanai] = "Shanai",

	[Instrument.TinkleBell] = "Tinkle Bell",
	[Instrument.Agogo] = "Agogo",
	[Instrument.SteelDrums] = "Steel Drums",
	[Instrument.Woodblock] = "Woodblock",
	[Instrument.TaikoDrum] = "Taiko Drum",
	[Instrument.MelodicTom] = "Melodic Tom",
	[Instrument.SynthDrum] = "Synth Drum",
	[Instrument.ReverseCymbal] = "Reverse Cymbal",

	[Instrument.GuitarFretNoise] = "Guitar Fret Noise",
	[Instrument.BreathNoise] = "Breath Noise",
	[Instrument.Seashore] = "Seashore",
	[Instrument.BirdTweet] = "Bird Tweet",
	[Instrument.TelephoneRing] = "Telephone Ring",
	[Instrument.Helicopter] = "Helicopter",
	[Instrument.Applause] = "Applause",
	[Instrument.Gunshot] = "Gunshot",

	[Instrument.Percussions] = "Percussions",
	[Instrument.Drumkit] = "Percussions",

	[Instrument.None] = "(None)",
}

msg.MIDI_PERCUSSION_NAMES = {
	[Percussion.Laser] = "Laser",
	[Percussion.Whip] = "Whip",
	[Percussion.ScratchPush] = "Scratch Push",
	[Percussion.ScratchPull] = "Scratch Pull",
	[Percussion.StickClick] = "Stick Click",
	[Percussion.SquareClick] = "Square Click",
	[Percussion.MetronomeClick] = "Metronome Click",
	[Percussion.MetronomeBell] = "Metronome Bell",
	[Percussion.AcousticBassDrum] = "Acoustic Bass Drum",
	[Percussion.BassDrum1] = "Bass Drum 1",
	[Percussion.SideStick] = "Side Stick",
	[Percussion.AcousticSnare] = "Acoustic Snare",
	[Percussion.HandClap] = "Hand Clap",
	[Percussion.ElectricSnare] = "Electric Snare",
	[Percussion.LowFloorTom] = "Low Floor Tom",
	[Percussion.ClosedHiHat] = "Closed Hi Hat",
	[Percussion.HighFloorTom] = "High Floor Tom",
	[Percussion.PedalHiHat] = "Pedal Hi-Hat",
	[Percussion.LowTom] = "Low Tom",
	[Percussion.OpenHiHat] = "Open Hi-Hat",
	[Percussion.LowMidTom] = "Low-Mid Tom",
	[Percussion.HiMidTom] = "Hi-Mid Tom",
	[Percussion.CrashCymbal1] = "Crash Cymbal 1",
	[Percussion.HighTom] = "High Tom",
	[Percussion.RideCymbal1] = "Ride Cymbal 1",
	[Percussion.ChineseCymbal] = "Chinese Cymbal",
	[Percussion.RideBell] = "Ride Bell",
	[Percussion.Tambourine] = "Tambourine",
	[Percussion.SplashCymbal] = "Splash Cymbal",
	[Percussion.Cowbell] = "Cowbell",
	[Percussion.CrashCymbal2] = "Crash Cymbal 2",
	[Percussion.Vibraslap] = "Vibraslap",
	[Percussion.RideCymbal2] = "Ride Cymbal 2",
	[Percussion.HiBongo] = "Hi Bongo",
	[Percussion.LowBongo] = "Low Bongo",
	[Percussion.MuteHiConga] = "Mute Hi Conga",
	[Percussion.OpenHiConga] = "Open Hi Conga",
	[Percussion.LowConga] = "Low Conga",
	[Percussion.HighTimbale] = "High Timbale",
	[Percussion.LowTimbale] = "Low Timbale",
	[Percussion.HighAgogo] = "High Agogo",
	[Percussion.LowAgogo] = "Low Agogo",
	[Percussion.Cabasa] = "Cabasa",
	[Percussion.Maracas] = "Maracas",
	[Percussion.ShortWhistle] = "Short Whistle",
	[Percussion.LongWhistle] = "Long Whistle",
	[Percussion.ShortGuiro] = "Short Guiro",
	[Percussion.LongGuiro] = "Long Guiro",
	[Percussion.Claves] = "Claves",
	[Percussion.HiWoodBlock] = "Hi Wood Block",
	[Percussion.LowWoodBlock] = "Low Wood Block",
	[Percussion.MuteCuica] = "Mute Cuica",
	[Percussion.OpenCuica] = "Open Cuica",
	[Percussion.MuteTriangle] = "Mute Triangle",
	[Percussion.OpenTriangle] = "Open Triangle",
	[Percussion.Shaker] = "Shaker",
	[Percussion.SleighBell] = "Sleigh Bell",
	[Percussion.BellTree] = "Bell Tree",
	[Percussion.Castanets] = "Castanets",
	[Percussion.SurduDeadStroke] = "Surdu Dead Stroke",
	[Percussion.Surdu] = "Surdu",
	[Percussion.SnareDrumRod] = "Snare Drum Rod",
	[Percussion.OceanDrum] = "Ocean Drum",
	[Percussion.SnareDrumBrush] = "Snare Drum Brush",
}

Musician.Msg = msg
