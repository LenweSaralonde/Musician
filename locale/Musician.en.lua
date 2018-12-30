Musician.Locale.en = {}
local msg = Musician.Locale.en

msg.PLAY = "Play"
msg.STOP = "Stop"
msg.PAUSE = "Pause"
msg.TEST_SONG = "Preview"
msg.STOP_TEST = "Stop preview"
msg.CLEAR = "Clear"
msg.EDIT = "Edit"
msg.MUTE = "Mute"
msg.UNMUTE = "Unmute"

msg.STARTUP = "Welcome to Musician v{version}."

msg.NEW_VERSION = "A new version of Musician has been released! Download the update from {url} ."
msg.NEW_MAJOR_VERSION = "Your version of Musician is obsolete and does not work anymore.\nPlease download the update from\n{url}"

msg.PLAYER_TOOLTIP = "Musician"
msg.PLAYER_TOOLTIP_VERSION = "Musician v{version}"
msg.PLAYER_TOOLTIP_PRELOADING = "Preloading sounds… ({progress})"

msg.PLAYER_COUNT_ONLINE = "There are {count} other music fans around!"
msg.PLAYER_COUNT_ONLINE_ONE = "There is another music fan around!"

msg.INVALID_MUSIC_CODE = "Invalid music code."

msg.PLAY_A_SONG = "Play a song"
msg.PASTE_MUSIC_CODE = "Import your song in MIDI format at:\n{url}\n\nthen paste the music code here..."
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
	-- 	Piano
	[-1] = "(None)",

	-- 	Piano
	[0] = "Acoustic Grand Piano",
	[1] = "Bright Acoustic Piano",
	[2] = "Electric Grand Piano",
	[3] = "Honky-tonk Piano",
	[4] = "Electric Piano 1",
	[5] = "Electric Piano 2",
	[6] = "Harpsichord",
	[7] = "Clavi",

	-- Chromatic Percussion
	[8] = "Celesta",
	[9] = "Glockenspiel",
	[10] = "Music Box",
	[11] = "Vibraphone",
	[12] = "Marimba",
	[13] = "Xylophone",
	[14] = "Tubular Bells",
	[15] = "Dulcimer",

	-- Organ
	[16] = "Drawbar Organ",
	[17] = "Percussive Organ",
	[18] = "Rock Organ",
	[19] = "Church Organ",
	[20] = "Reed Organ",
	[21] = "Accordion",
	[22] = "Harmonica",
	[23] = "Tango Accordion",

	-- Guitar
	[24] = "Acoustic Guitar (nylon)",
	[25] = "Acoustic Guitar (steel)",
	[26] = "Electric Guitar (jazz)",
	[27] = "Electric Guitar (clean)",
	[28] = "Electric Guitar (muted)",
	[29] = "Overdriven Guitar",
	[30] = "Distortion Guitar",
	[31] = "Guitar harmonics",

	-- Bass
	[32] = "Acoustic Bass",
	[33] = "Electric Bass (finger)",
	[34] = "Electric Bass (pick)",
	[35] = "Fretless Bass",
	[36] = "Slap Bass 1",
	[37] = "Slap Bass 2",
	[38] = "Synth Bass 1",
	[39] = "Synth Bass 2",

	-- Strings
	[40] = "Violin",
	[41] = "Viola",
	[42] = "Cello",
	[43] = "Contrabass",
	[44] = "Tremolo Strings",
	[45] = "Pizzicato Strings",
	[46] = "Orchestral Harp",
	[47] = "Timpani",

	-- Ensemble
	[48] = "String Ensemble 1",
	[49] = "String Ensemble 2",
	[50] = "SynthStrings 1",
	[51] = "SynthStrings 2",
	[52] = "Choir Aahs",
	[53] = "Voice Oohs",
	[54] = "Synth Voice",
	[55] = "Orchestra Hit",

	-- Brass
	[56] = "Trumpet",
	[57] = "Trombone",
	[58] = "Tuba",
	[59] = "Muted Trumpet",
	[60] = "French Horn",
	[61] = "Brass Section",
	[62] = "SynthBrass 1",
	[63] = "SynthBrass 2",

	-- Reed
	[64] = "Soprano Sax",
	[65] = "Alto Sax",
	[66] = "Tenor Sax",
	[67] = "Baritone Sax",
	[68] = "Oboe",
	[69] = "English Horn",
	[70] = "Bassoon",
	[71] = "Clarinet",

	-- Pipe
	[72] = "Piccolo",
	[73] = "Flute",
	[74] = "Recorder",
	[75] = "Pan Flute",
	[76] = "Blown Bottle",
	[77] = "Shakuhachi",
	[78] = "Whistle",
	[79] = "Ocarina",

	-- Synth Lead
	[80] = "Lead 1 (square)",
	[81] = "Lead 2 (sawtooth)",
	[82] = "Lead 3 (calliope)",
	[83] = "Lead 4 (chiff)",
	[84] = "Lead 5 (charang)",
	[85] = "Lead 6 (voice)",
	[86] = "Lead 7 (fifths)",
	[87] = "Lead 8 (bass + lead)",

	-- Synth Pad
	[88] = "Pad 1 (new age)",
	[89] = "Pad 2 (warm)",
	[90] = "Pad 3 (polysynth)",
	[91] = "Pad 4 (choir)",
	[92] = "Pad 5 (bowed)",
	[93] = "Pad 6 (metallic)",
	[94] = "Pad 7 (halo)",
	[95] = "Pad 8 (sweep)",

	-- Synth Effects
	[96] = "FX 1 (rain)",
	[97] = "FX 2 (soundtrack)",
	[98] = "FX 3 (crystal)",
	[99] = "FX 4 (atmosphere)",
	[100] = "FX 5 (brightness)",
	[101] = "FX 6 (goblins)",
	[102] = "FX 7 (echoes)",
	[103] = "FX 8 (sci-fi)",

	-- Ethnic
	[104] = "Sitar",
	[105] = "Banjo",
	[106] = "Shamisen",
	[107] = "Koto",
	[108] = "Kalimba",
	[109] = "Bag pipe",
	[110] = "Fiddle",
	[111] = "Shanai",

	-- Percussive
	[112] = "Tinkle Bell",
	[113] = "Agogo",
	[114] = "Steel Drums",
	[115] = "Woodblock",
	[116] = "Taiko Drum",
	[117] = "Melodic Tom",
	[118] = "Synth Drum",
	[119] = "Reverse Cymbal",

	-- Sound Effects
	[120] = "Guitar Fret Noise",
	[121] = "Breath Noise",
	[122] = "Seashore",
	[123] = "Bird Tweet",
	[124] = "Telephone Ring",
	[125] = "Helicopter",
	[126] = "Applause",
	[127] = "Gunshot",

	-- Percussions
	[128] = "Percussions",
}

Musician.Msg = msg
