Musician.Locale.en = {}

local msg = Musician.Locale.en
local Instrument = Musician.MIDI_INSTRUMENTS
local Percussion = Musician.MIDI_PERCUSSIONS

msg.LOCALE_NAME = "English"

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
msg.MENU_SETTINGS = "Settings"
msg.MENU_OPTIONS = "Options"
msg.MENU_ABOUT = "About"

msg.COMMAND_LIST_TITLE = "Musician Commands:"
msg.COMMAND_SHOW = "Show song import window"
msg.COMMAND_PREVIEW_PLAY = "Start or stop previewing song"
msg.COMMAND_PREVIEW_STOP = "Stop previewing song"
msg.COMMAND_PLAY = "Play or stop song"
msg.COMMAND_STOP = "Stop playing song"
msg.COMMAND_SONG_EDITOR = "Open song editor"
msg.COMMAND_LIVE_KEYBOARD = "Open live keyboard"
msg.COMMAND_CONFIGURE_KEYBOARD = "Configure keyboard"
msg.COMMAND_LIVE_DEMO = "Keyboard demo mode"
msg.COMMAND_LIVE_DEMO_PARAMS = "{ **<upper track #>** **<lower track #>** || **off** }"
msg.COMMAND_HELP = "Show this help message"
msg.ERR_COMMAND_UNKNOWN = "Unknown \"{command}\" command. Type {help} to get the command list."

msg.ERR_CLASSIC_ON_RETAIL = "You're using the **Classic** version of Musician on the **Retail** version of WoW.\nPlease install the **Retail** version of Musician."
msg.ERR_RETAIL_ON_CLASSIC = "You're using the ***Retail** version of Musician on the **Classic** version of WoW.\nPlease install the **Classic** version of Musician."

msg.OPTIONS_TITLE = "Musician"
msg.OPTIONS_SUB_TEXT = "Join the Discord server for support! {url}"
msg.OPTIONS_CATEGORY_EMOTE = "Emote"
msg.OPTIONS_ENABLE_EMOTE_LABEL = "Send a text emote to players who don't have Musician when playing a song."
msg.OPTIONS_ENABLE_EMOTE_PROMO_LABEL = "Include a short text inviting them to install it so that they can hear the music you play."
msg.OPTIONS_EMOTE_HINT = "A text emote is shown to the players who don't have Musician when you play a song. You can disable it in the [options]."
msg.OPTIONS_INTEGRATION_OPTIONS_TITLE = "In-game integration options"
msg.OPTIONS_AUTO_MUTE_GAME_MUSIC_LABEL = "Mute in-game music while a song is playing."
msg.OPTIONS_MUTE_INSTRUMENT_TOYS_LABEL = "Mute music from instrumental toys. {icons}"
msg.OPTIONS_CATEGORY_NAMEPLATES = "Nameplates and animations"
msg.OPTIONS_CATEGORY_NAMEPLATES_SUB_TEXT = "Enable nameplates to see the animations on characters playing music and find out\nwho can hear you at a glance."
msg.OPTIONS_ENABLE_NAMEPLATES = "Enable nameplates and animations."
msg.OPTIONS_SHOW_NAMEPLATE_ICON = "Show a {icon} icon next to the name of the players who also have Musician."
msg.OPTIONS_HIDE_HEALTH_BARS = "Hide player and friendly unit health bars when not in combat."
msg.OPTIONS_HIDE_NPC_NAMEPLATES = "Hide NPC nameplates."
msg.OPTIONS_CINEMATIC_MODE = "Show animations when the UI is hidden with {binding}."
msg.OPTIONS_CINEMATIC_MODE_NO_BINDING = "Show animations when the UI is hidden."
msg.OPTIONS_NAMEPLATES_CINEMATIC_MODE = "Show nameplates when the UI is hidden."
msg.OPTIONS_TRP3 = "Total RP 3"
msg.OPTIONS_TRP3_MAP_SCAN = "Show players who have Musician on the map scan with a {icon} icon."
msg.OPTIONS_CROSS_RP_TITLE = "Cross RP"
msg.OPTIONS_CROSS_RP_SUB_TEXT = "Install the Cross RP add-on by Tammya-MoonGuard to activate\ncross-faction and cross-realm music!"
msg.OPTIONS_CROSS_RP_SUB_TEXT_NO_GATEWAY = "There is no Cross RP node available for the moment.\nPlease be patient…"
msg.OPTIONS_CROSS_RP_SUB_TEXT_ACTIVE = "Cross RP communication is active for the following locations:\n\n{bands}"

msg.TIPS_AND_TRICKS_ENABLE = "Show tips and tricks on startup."

msg.TIPS_AND_TRICKS_NAMEPLATES_TITLE = "Animations and nameplates"
msg.TIPS_AND_TRICKS_NAMEPLATES_TEXT = "A special animation is visible on characters who play music when nameplates are enabled.\n\n" ..
	"An icon {icon} also indicates who have Musician and can hear you.\n\n" ..
	"Do you want to enable nameplates and animations now?"
msg.TIPS_AND_TRICKS_NAMEPLATES_OK = "Enable nameplates and animations"
msg.TIPS_AND_TRICKS_NAMEPLATES_CANCEL = "Later"

msg.TIPS_AND_TRICKS_CROSS_RP_TITLE = "Cross-faction music with Cross RP"
msg.TIPS_AND_TRICKS_CROSS_RP_TEXT = msg.OPTIONS_CROSS_RP_SUB_TEXT
msg.TIPS_AND_TRICKS_CROSS_RP_OK = "OK"

msg.STARTUP = "Welcome to Musician v{version}."

msg.NEW_VERSION = "A new version of Musician has been released! Download the update from {url} ."
msg.NEW_PROTOCOL_VERSION = "Your version of Musician is outdated and does not work anymore.\nPlease download the update from\n{url}"
msg.SHOULD_CONFIGURE_KEYBOARD = "You have to configure the keyboard before playing."

msg.PLAYER_TOOLTIP = "Musician"
msg.PLAYER_TOOLTIP_VERSION = "Musician v{version}"
msg.PLAYER_TOOLTIP_VERSION_OUTDATED = " (Outdated)"
msg.PLAYER_TOOLTIP_VERSION_INCOMPATIBLE = " (INCOMPATIBLE)"
msg.PLAYER_TOOLTIP_PRELOADING = "Preloading sounds… ({progress})"

msg.PLAYER_COUNT_ONLINE = "There are {count} other music fans around!"
msg.PLAYER_COUNT_ONLINE_ONE = "There is another music fan around!"
msg.PLAYER_COUNT_ONLINE_NONE = "There are no other music fans around yet."

msg.INVALID_MUSIC_CODE = "Invalid music code."

msg.PLAY_A_SONG = "Play a song"
msg.IMPORT_A_SONG = "Import a song"
msg.PASTE_MUSIC_CODE = "Import your song in MIDI format at:\n{url}\n\nthen paste the music code here ({shortcut})…"
msg.SONG_IMPORTED = "Loaded song: {title}."

msg.PLAY_IN_BAND = "Play as a band"
msg.PLAY_IN_BAND_HINT = "Click here when you are ready to play this song with your band."
msg.PLAY_IN_BAND_READY_PLAYERS = "Ready band members:"
msg.EMOTE_PLAYER_IS_READY = "is ready to play as a band."
msg.EMOTE_PLAYER_IS_NOT_READY = "is no longer ready to play as a band."
msg.EMOTE_PLAY_IN_BAND_START = "started band playing."
msg.EMOTE_PLAY_IN_BAND_STOP = "stopped band playing."

msg.LIVE_SYNC = "Play live as a band"
msg.LIVE_SYNC_HINT = "Click here to activate band synchronization."
msg.SYNCED_PLAYERS = "Live band members:"
msg.EMOTE_PLAYER_LIVE_SYNC_ENABLED = "is playing music with you."
msg.EMOTE_PLAYER_LIVE_SYNC_DISABLED = "stopped playing music with you."

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
msg.SYNCHRONIZE_TRACKS = "Synchronize track settings with the current song"
msg.MUTE_TRACK = "Mute"
msg.SOLO_TRACK = "Solo"
msg.TRANSPOSE_TRACK = "Transpose (octave)"
msg.CHANGE_TRACK_INSTRUMENT = "Change instrument"
msg.HEADER_NUMBER = "#"
msg.HEADER_OCTAVE = "Octave"
msg.HEADER_INSTRUMENT = "Instrument"

msg.CONFIGURE_KEYBOARD = "Configure keyboard"
msg.CONFIGURE_KEYBOARD_HINT = "Click a key to set…"
msg.CONFIGURE_KEYBOARD_HINT_COMPLETE = "Keyboard configuration is complete.\nYou can now save your changes and start playing music!"
msg.CONFIGURE_KEYBOARD_START_OVER = "Start over"
msg.CONFIGURE_KEYBOARD_SAVE = "Save configuration"
msg.PRESS_KEY_BINDING = "Press the key #{col} in row #{row}."
msg.KEY_IS_MERGEABLE = "This key could be the same as the {key} key on your keyboard: {action}"
msg.KEY_CAN_BE_MERGED = "in this case, just press the {key} key."
msg.KEY_CANNOT_BE_MERGED = "in this case, just ignore it and proceed to the next key."
msg.NEXT_KEY = "Next key"
msg.CLEAR_KEY = "Clear key"

msg.ABOUT_TITLE = "Musician"
msg.ABOUT_VERSION = "version {version}"
msg.ABOUT_AUTHOR = "By LenweSaralonde – {url}"
msg.ABOUT_AUTHOR_EXTRA1 = "Chinese localization by Grayson Blackclaw"
msg.ABOUT_LICENSE = "Released under GNU General Public License v3.0"
msg.ABOUT_DISCORD = "Discord: {url}"
msg.ABOUT_SUPPORT = "Do you like Musician? Share it with everyone!"
msg.ABOUT_PATREON = "Become a patron: {url}"
msg.ABOUT_PAYPAL = "Donate: {url}"
msg.ABOUT_SUPPORTERS = "Special thanks to the supporters of the project <3"

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
msg.HORIZONTAL_LAYOUT = "Horizontal"
msg.VERTICAL_LAYOUT = "Vertical"

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
msg.LOWER_INSTRUMENT_MAPPED_TO_CHANNEL = "Lower instrument (track #{track})"
msg.UPPER_INSTRUMENT_MAPPED_TO_CHANNEL = "Upper instrument (track #{track})"
msg.POWER_CHORDS = "Power chords"
msg.PROGRAM_BUTTON = "P {num}"
msg.EMPTY_PROGRAM = "Empty program"
msg.LOAD_PROGRAM_NUM = "Load program #{num} ({key})"
msg.SAVE_PROGRAM_NUM = "Save in program #{num} ({key})"
msg.DELETE_PROGRAM_NUM = "Erase program #{num} ({key})"
msg.WRITE_PROGRAM = "Save program ({key})"
msg.PROGRAM_SAVED = "Program #{num} saved."
msg.PROGRAM_DELETED = "Program #{num} erased."
msg.DEMO_MODE_ENABLED = "Keyboard demo mode enabled:\n{mapping}"
msg.DEMO_MODE_MAPPING = "{layer} → Track #{track}"
msg.DEMO_MODE_DISABLED = "Keyboard demo mode disabled."

msg.LAYERS = {
	[Musician.KEYBOARD_LAYER.UPPER] = "Upper",
	[Musician.KEYBOARD_LAYER.LOWER] = "Lower",
}

msg.EMOTE_PLAYING_MUSIC = "is playing a song."
msg.EMOTE_PROMO = "(Get the \"Musician\" add-on to listen)"
msg.EMOTE_SONG_NOT_LOADED = "(The song cannot play because {player} is using an incompatible version.)"
msg.EMOTE_PLAYER_OTHER_REALM = "(This player is on another realm.)"

msg.TOOLTIP_LEFT_CLICK = "**Left click**: {action}"
msg.TOOLTIP_RIGHT_CLICK = "**Right click**: {action}"
msg.TOOLTIP_DRAG_AND_DROP = "**Drag and drop** to move"
msg.TOOLTIP_ISMUTED = "(muted)"
msg.TOOLTIP_ACTION_OPEN_MENU = "Open the main menu"
msg.TOOLTIP_ACTION_MUTE = "Mute all music"
msg.TOOLTIP_ACTION_UNMUTE = "Unmute music"

msg.PLAYER_MENU_TITLE = "Music"
msg.PLAYER_MENU_STOP_CURRENT_SONG = "Stop current song"
msg.PLAYER_MENU_MUTE = "Mute"
msg.PLAYER_MENU_UNMUTE = "Unmute"

msg.PLAYER_IS_MUTED = "{icon}{player} is now muted."
msg.PLAYER_IS_UNMUTED = "{icon}{player} is now unmuted."

msg.LINKS_PREFIX = "Music"
msg.LINKS_FORMAT = "{prefix}: {title}"
msg.LINKS_LINK_BUTTON = "Link"

msg.LINK_EXPORT_WINDOW_TITLE = "Create song link"
msg.LINK_EXPORT_WINDOW_SONG_TITLE_LABEL = "Song title:"
msg.LINK_EXPORT_WINDOW_HINT = "The link will remain active until you log out or reload the interface."
msg.LINK_EXPORT_WINDOW_PROGRESS = "Generating link… {progress}%"
msg.LINK_EXPORT_WINDOW_POST_BUTTON = "Post link into the chat"

msg.LINK_IMPORT_WINDOW_TITLE = "Import song from {player}:"
msg.LINK_IMPORT_WINDOW_HINT = "Click “Import” to start importing the song into Musician."
msg.LINK_IMPORT_WINDOW_IMPORT_BUTTON = "Import song"
msg.LINK_IMPORT_WINDOW_CANCEL_IMPORT_BUTTON = "Cancel import"
msg.LINK_IMPORT_WINDOW_REQUESTING = "Requesting song from {player}…"
msg.LINK_IMPORT_WINDOW_PROGRESS = "Importing… {progress}%"

msg.LINKS_ERROR = {}
msg.LINKS_ERROR.notFound = "The song {title} is not available from {player}."
msg.LINKS_ERROR.alreadySending = "A song is already being sent to you by {player}. Please try again in a few seconds."
msg.LINKS_ERROR.alreadyRequested = "A song is already being requested from {player}."
msg.LINKS_ERROR.timeout = "The player {player} did not respond."
msg.LINKS_ERROR.importingFailed = "The song {title} could not be imported from {player}."

msg.TRPE_ITEM_NAME = "{title}"
msg.TRPE_ITEM_TOOLTIP_REQUIRES_MUSICIAN = "Requires Musician"
msg.TRPE_ITEM_TOOLTIP_SHEET_MUSIC = "Sheet music"
msg.TRPE_ITEM_USE_HINT = "Read the sheet music"
msg.TRPE_ITEM_MUSICIAN_NOT_FOUND = "You need the Musician add-on to be able to use this item.\nGet it from {url}."
msg.TRPE_ITEM_NOTES = "Import the song into Musician to play it for nearby players.\n\nDownload Musician: {url}\n"

msg.TRPE_EXPORT_BUTTON = "Export"
msg.TRPE_EXPORT_WINDOW_TITLE = "Export song as a Total RP item"
msg.TRPE_EXPORT_WINDOW_LOCALE = "Item language:"
msg.TRPE_EXPORT_WINDOW_ADD_TO_BAG = "Add to your bag"
msg.TRPE_EXPORT_WINDOW_QUANTITY = "Quantity:"
msg.TRPE_EXPORT_WINDOW_ADD_TO_DB_AND_CUSTOMIZE = "Add to the database and customize"
msg.TRPE_EXPORT_WINDOW_HINT = "Create a sheet music item in Total RP Extended that can be traded with other players."
msg.TRPE_EXPORT_WINDOW_CREATE_ITEM_BUTTON = "Create item"
msg.TRPE_EXPORT_WINDOW_PROGRESS = "Creating item… {progress}%"

msg.INSTRUMENT_NAMES = {
	["none"] = "(None)",
	["accordion"] = "Accordion",
	["bagpipe"] = "Bagpipe",
	["dulcimer"] = "Dulcimer (hammered)",
	["lute"] = "Lute",
	["viola-da-gamba"] = "Viola da gamba",
	["harp"] = "Celtic harp",
	["male-voice"] = "Male voice (tenor)",
	["female-voice"] = "Female voice (soprano)",
	["trumpet"] = "Trumpet",
	["sackbut"] = "Sackbut",
	["war-horn"] = "War horn",
	["bassoon"] = "Bassoon",
	["clarinet"] = "Clarinet",
	["recorder"] = "Recorder",
	["fiddle"] = "Fiddle",
	["percussions"] = "Percussions (traditional)",
	["distorsion-guitar"] = "Distorsion guitar",
	["clean-guitar"] = "Clean guitar",
	["bass-guitar"] = "Bass guitar",
	["drumkit"] = "Drum kit",
	["war-drum"] = "War drum",
	["woodblock"] = "Woodblock",
	["tambourine-shake"] = "Tambourine (shaken)",
}

msg.MIDI_INSTRUMENT_NAMES = {
	[Instrument.AcousticGrandPiano] = "Acoustic grand piano",
	[Instrument.BrightAcousticPiano] = "Bright acoustic piano",
	[Instrument.ElectricGrandPiano] = "Electric grand piano",
	[Instrument.HonkyTonkPiano] = "Honky-tonk piano",
	[Instrument.ElectricPiano1] = "Electric piano 1",
	[Instrument.ElectricPiano2] = "Electric piano 2",
	[Instrument.Harpsichord] = "Harpsichord",
	[Instrument.Clavi] = "Clavi",

	[Instrument.Celesta] = "Celesta",
	[Instrument.Glockenspiel] = "Glockenspiel",
	[Instrument.MusicBox] = "Music box",
	[Instrument.Vibraphone] = "Vibraphone",
	[Instrument.Marimba] = "Marimba",
	[Instrument.Xylophone] = "Xylophone",
	[Instrument.TubularBells] = "Tubular bells",
	[Instrument.Dulcimer] = "Dulcimer",

	[Instrument.DrawbarOrgan] = "Drawbar organ",
	[Instrument.PercussiveOrgan] = "Percussive organ",
	[Instrument.RockOrgan] = "Rock organ",
	[Instrument.ChurchOrgan] = "Church organ",
	[Instrument.ReedOrgan] = "Reed organ",
	[Instrument.Accordion] = "Accordion",
	[Instrument.Harmonica] = "Harmonica",
	[Instrument.TangoAccordion] = "Tango accordion",

	[Instrument.AcousticGuitarNylon] = "Acoustic guitar (nylon)",
	[Instrument.AcousticGuitarSteel] = "Acoustic guitar (steel)",
	[Instrument.ElectricGuitarJazz] = "Electric guitar (jazz)",
	[Instrument.ElectricGuitarClean] = "Electric guitar (clean)",
	[Instrument.ElectricGuitarMuted] = "Electric guitar (muted)",
	[Instrument.OverdrivenGuitar] = "Overdriven guitar",
	[Instrument.DistortionGuitar] = "Distortion guitar",
	[Instrument.Guitarharmonics] = "Guitar harmonics",

	[Instrument.AcousticBass] = "Acoustic bass",
	[Instrument.ElectricBassFinger] = "Electric bass (fingered)",
	[Instrument.ElectricBassPick] = "Electric bass (picked)",
	[Instrument.FretlessBass] = "Fretless bass",
	[Instrument.SlapBass1] = "Slap bass 1",
	[Instrument.SlapBass2] = "Slap bass 2",
	[Instrument.SynthBass1] = "Synth bass 1",
	[Instrument.SynthBass2] = "Synth bass 2",

	[Instrument.Violin] = "Violin",
	[Instrument.Viola] = "Viola",
	[Instrument.Cello] = "Cello",
	[Instrument.Contrabass] = "Contrabass",
	[Instrument.TremoloStrings] = "Tremolo strings",
	[Instrument.PizzicatoStrings] = "Pizzicato strings",
	[Instrument.OrchestralHarp] = "Orchestral harp",
	[Instrument.Timpani] = "Timpani",

	[Instrument.StringEnsemble1] = "String ensemble 1",
	[Instrument.StringEnsemble2] = "String ensemble 2",
	[Instrument.SynthStrings1] = "Synth strings 1",
	[Instrument.SynthStrings2] = "Synth strings 2",
	[Instrument.ChoirAahs] = "Choir aahs",
	[Instrument.VoiceOohs] = "Voice oohs",
	[Instrument.SynthVoice] = "Synth voice",
	[Instrument.OrchestraHit] = "Orchestra hit",

	[Instrument.Trumpet] = "Trumpet",
	[Instrument.Trombone] = "Trombone",
	[Instrument.Tuba] = "Tuba",
	[Instrument.MutedTrumpet] = "Muted trumpet",
	[Instrument.FrenchHorn] = "French horn",
	[Instrument.BrassSection] = "Brass section",
	[Instrument.SynthBrass1] = "Synth brass 1",
	[Instrument.SynthBrass2] = "Synth brass 2",

	[Instrument.SopranoSax] = "Soprano sax",
	[Instrument.AltoSax] = "Alto sax",
	[Instrument.TenorSax] = "Tenor sax",
	[Instrument.BaritoneSax] = "Baritone sax",
	[Instrument.Oboe] = "Oboe",
	[Instrument.EnglishHorn] = "English horn",
	[Instrument.Bassoon] = "Bassoon",
	[Instrument.Clarinet] = "Clarinet",

	[Instrument.Piccolo] = "Piccolo",
	[Instrument.Flute] = "Flute",
	[Instrument.Recorder] = "Recorder",
	[Instrument.PanFlute] = "Pan flute",
	[Instrument.BlownBottle] = "Blown bottle",
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

	[Instrument.TinkleBell] = "Tinkle bell",
	[Instrument.Agogo] = "Agogo",
	[Instrument.SteelDrums] = "Steel drums",
	[Instrument.Woodblock] = "Woodblock",
	[Instrument.TaikoDrum] = "Taiko drum",
	[Instrument.MelodicTom] = "Melodic tom",
	[Instrument.SynthDrum] = "Synth drum",
	[Instrument.ReverseCymbal] = "Reverse cymbal",

	[Instrument.GuitarFretNoise] = "Guitar fret noise",
	[Instrument.BreathNoise] = "Breath noise",
	[Instrument.Seashore] = "Seashore",
	[Instrument.BirdTweet] = "Bird tweet",
	[Instrument.TelephoneRing] = "Telephone ring",
	[Instrument.Helicopter] = "Helicopter",
	[Instrument.Applause] = "Applause",
	[Instrument.Gunshot] = "Gunshot",

	[Instrument.StandardKit] = "Standard drum kit",
	[Instrument.RoomKit] = "Room drum kit",
	[Instrument.PowerKit] = "Power drum kit",
	[Instrument.ElectronicKit] = "Electronic drum kit",
	[Instrument.TR808Kit] = "TR-808 drum machine",
	[Instrument.JazzKit] = "Jazz drum kit",
	[Instrument.BrushKit] = "Brush drum kit",
	[Instrument.OrchestraKit] = "Orchestra drum kit",
	[Instrument.SoundFXKit] = "Sound FX",
	[Instrument.MT32Kit] = "MT-32 drum kit",

	[Instrument.None] = "(None)",
}

msg.UNKNOWN_DRUMKIT = "Unknown drum kit ({midi})"

msg.MIDI_PERCUSSION_NAMES = {
	[Percussion.Laser] = "Laser",
	[Percussion.Whip] = "Whip",
	[Percussion.ScratchPush] = "Scratch push",
	[Percussion.ScratchPull] = "Scratch pull",
	[Percussion.StickClick] = "Stick click",
	[Percussion.SquareClick] = "Square click",
	[Percussion.MetronomeClick] = "Metronome click",
	[Percussion.MetronomeBell] = "Metronome bell",
	[Percussion.AcousticBassDrum] = "Acoustic bass drum",
	[Percussion.BassDrum1] = "Bass drum 1",
	[Percussion.SideStick] = "Side stick",
	[Percussion.AcousticSnare] = "Acoustic snare",
	[Percussion.HandClap] = "Hand clap",
	[Percussion.ElectricSnare] = "Electric snare",
	[Percussion.LowFloorTom] = "Low floor tom",
	[Percussion.ClosedHiHat] = "Closed hi-hat",
	[Percussion.HighFloorTom] = "High floor tom",
	[Percussion.PedalHiHat] = "Pedal hi-hat",
	[Percussion.LowTom] = "Low tom",
	[Percussion.OpenHiHat] = "Open hi-hat",
	[Percussion.LowMidTom] = "Low-mid tom",
	[Percussion.HiMidTom] = "Hi-mid tom",
	[Percussion.CrashCymbal1] = "Crash cymbal 1",
	[Percussion.HighTom] = "High tom",
	[Percussion.RideCymbal1] = "Ride cymbal 1",
	[Percussion.ChineseCymbal] = "Chinese cymbal",
	[Percussion.RideBell] = "Ride bell",
	[Percussion.Tambourine] = "Tambourine",
	[Percussion.SplashCymbal] = "Splash cymbal",
	[Percussion.Cowbell] = "Cowbell",
	[Percussion.CrashCymbal2] = "Crash cymbal 2",
	[Percussion.Vibraslap] = "Vibraslap",
	[Percussion.RideCymbal2] = "Ride cymbal 2",
	[Percussion.HiBongo] = "Hi bongo",
	[Percussion.LowBongo] = "Low bongo",
	[Percussion.MuteHiConga] = "Mute hi conga",
	[Percussion.OpenHiConga] = "Open hi conga",
	[Percussion.LowConga] = "Low conga",
	[Percussion.HighTimbale] = "High timbale",
	[Percussion.LowTimbale] = "Low timbale",
	[Percussion.HighAgogo] = "High agogo",
	[Percussion.LowAgogo] = "Low agogo",
	[Percussion.Cabasa] = "Cabasa",
	[Percussion.Maracas] = "Maracas",
	[Percussion.ShortWhistle] = "Short whistle",
	[Percussion.LongWhistle] = "Long whistle",
	[Percussion.ShortGuiro] = "Short guiro",
	[Percussion.LongGuiro] = "Long guiro",
	[Percussion.Claves] = "Claves",
	[Percussion.HiWoodBlock] = "Hi wood block",
	[Percussion.LowWoodBlock] = "Low wood block",
	[Percussion.MuteCuica] = "Mute cuica",
	[Percussion.OpenCuica] = "Open cuica",
	[Percussion.MuteTriangle] = "Mute triangle",
	[Percussion.OpenTriangle] = "Open triangle",
	[Percussion.Shaker] = "Shaker",
	[Percussion.SleighBell] = "Sleigh bell",
	[Percussion.BellTree] = "Bell tree",
	[Percussion.Castanets] = "Castanets",
	[Percussion.SurduDeadStroke] = "Surdu dead stroke",
	[Percussion.Surdu] = "Surdu",
	[Percussion.SnareDrumRod] = "Snare drum rod",
	[Percussion.OceanDrum] = "Ocean drum",
	[Percussion.SnareDrumBrush] = "Snare drum brush",
}

Musician.Msg = msg
