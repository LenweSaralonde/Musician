------------------------------------------------------------------------
-- Please read the localization guide in the Wiki:
-- https://github.com/LenweSaralonde/Musician/wiki/Localization
--
-- * Commented out msg lines need to be translated.
-- * Do not translate anything on the left hand side of the = sign.
-- * Do not translate placeholders in curly braces ({variable}).
-- * Keep the text as a single line. Use \n for carriage return.
-- * Escape double quotes (") with a backslash (\").
-- * Check the result in game to make sure your text fits the UI.
------------------------------------------------------------------------

local msg = Musician.InitLocale('en', "English", 'enUS', 'enGB')

local Instrument = Musician.MIDI_INSTRUMENTS
local Percussion = Musician.MIDI_PERCUSSIONS
local KEY = Musician.KEYBOARD_KEY

------------------------------------------------------------------------
---------------- ↑↑↑ DO NOT EDIT THE LINES ABOVE ! ↑↑↑  ----------------
------------------------------------------------------------------------

--- Main frame controls
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

--- Minimap button menu
msg.MENU_TITLE = "Musician"
msg.MENU_IMPORT_SONG = "Import and play a song"
msg.MENU_PLAY = "Play"
msg.MENU_STOP = "Stop"
msg.MENU_PLAY_PREVIEW = "Preview"
msg.MENU_STOP_PREVIEW = "Stop preview"
msg.MENU_LIVE_PLAY = "Live play"
msg.MENU_SHOW_KEYBOARD = "Open keyboard"
msg.MENU_SETTINGS = "Settings"
msg.MENU_OPTIONS = "Options"
msg.MENU_ABOUT = "About"

--- Chat commands
msg.COMMAND_LIST_TITLE = "Musician Commands:"
msg.COMMAND_SHOW = "Show song import window"
msg.COMMAND_PREVIEW_PLAY = "Start or stop previewing song"
msg.COMMAND_PREVIEW_STOP = "Stop previewing song"
msg.COMMAND_PLAY = "Play or stop song"
msg.COMMAND_STOP = "Stop playing song"
msg.COMMAND_MUTE = "Mute all music"
msg.COMMAND_UNMUTE = "Unmute music"
msg.COMMAND_SONG_EDITOR = "Open song editor"
msg.COMMAND_LIVE_KEYBOARD = "Open live keyboard"
msg.COMMAND_CONFIGURE_KEYBOARD = "Configure keyboard"
msg.COMMAND_LIVE_DEMO = "Keyboard demo mode"
msg.COMMAND_LIVE_DEMO_PARAMS = "{ **<upper track #>** **<lower track #>** || **off** }"
msg.COMMAND_HELP = "Show this help message"
msg.ERR_COMMAND_UNKNOWN = "Unknown “{command}” command. Type {help} to get the command list."

--- Add-on options
msg.OPTIONS_TITLE = "Musician"
msg.OPTIONS_SUB_TEXT = "Join the Discord server for support! {url}"
msg.OPTIONS_CATEGORY_EMOTE = "Emote"
msg.OPTIONS_ENABLE_EMOTE_LABEL = "Send a text emote to players who don't have Musician when playing a song."
msg.OPTIONS_ENABLE_EMOTE_PROMO_LABEL = "Include a short text inviting them to install it so that they can hear the music you play."
msg.OPTIONS_EMOTE_HINT = "A text emote is shown to the players who don't have Musician when you play a song. You can disable it in the [options]."
msg.OPTIONS_INTEGRATION_OPTIONS_TITLE = "In-game integration options"
msg.OPTIONS_AUTO_MUTE_GAME_MUSIC_LABEL = "Mute in-game music while a song is playing."
msg.OPTIONS_MUTE_INSTRUMENT_TOYS_LABEL = "Mute music from instrumental toys. {icons}"
msg.OPTIONS_AUDIO_CHANNELS_TITLE = "Audio channels"
msg.OPTIONS_AUDIO_CHANNELS_HINT = "Select several audio channels to increase the maximum number of notes Musician can play simultaneously."
msg.OPTIONS_AUDIO_CHANNELS_CHANNEL_POLYPHONY = "{channel} ({polyphony})"
msg.OPTIONS_AUDIO_CHANNELS_TOTAL_POLYPHONY = "Total max polyphony: {polyphony}"
msg.OPTIONS_AUDIO_CHANNELS_AUTO_ADJUST_CONFIG = "Automatically optimize audio settings when multiple audio channels are selected."
msg.OPTIONS_AUDIO_CACHE_SIZE_FOR_MUSICIAN = "Recommended for Musician (%dMB)"
msg.OPTIONS_CATEGORY_SHORTCUTS = "Shortcuts"
msg.OPTIONS_SHORTCUT_MINIMAP = "Minimap button"
msg.OPTIONS_SHORTCUT_ADDON_MENU = "Minimap menu"
msg.OPTIONS_QUICK_PRELOADING_TITLE = "Quick preloading"
msg.OPTIONS_QUICK_PRELOADING_TEXT = "Enable instruments quick preloading on cold start."
msg.OPTIONS_CATEGORY_NAMEPLATES = "Nameplates and animations"
msg.OPTIONS_CATEGORY_NAMEPLATES_SUB_TEXT = "Enable nameplates to see the animations on characters playing music and find out\nwho can hear you at a glance."
msg.OPTIONS_ENABLE_NAMEPLATES = "Enable nameplates and animations."
msg.OPTIONS_SHOW_NAMEPLATE_ICON = "Show a {icon} icon next to the name of the players who also have Musician."
msg.OPTIONS_HIDE_HEALTH_BARS = "Hide player and friendly unit health bars when not in combat."
msg.OPTIONS_HIDE_NPC_NAMEPLATES = "Hide NPC nameplates."
msg.OPTIONS_CINEMATIC_MODE = "Show animations when the UI is hidden with {binding}."
msg.OPTIONS_CINEMATIC_MODE_NO_BINDING = "Show animations when the UI is hidden."
msg.OPTIONS_NAMEPLATES_CINEMATIC_MODE = "Show nameplates when the UI is hidden."
msg.OPTIONS_NAMEPLATES_OPTION_DISABLED_3RD_PARTY = "This option has no effect because a nameplates customization add-on is installed."
msg.OPTIONS_TRP3 = "Total RP 3"
msg.OPTIONS_TRP3_MAP_SCAN = "Show players who have Musician on the map scan with a {icon} icon."
msg.OPTIONS_CROSS_RP_TITLE = "Cross RP"
msg.OPTIONS_CROSS_RP_SUB_TEXT = "Install the Cross RP add-on by Tammya-MoonGuard to activate\ncross-faction and cross-realm music!"
msg.OPTIONS_CROSS_RP_SUB_TEXT_NO_GATEWAY = "There is no Cross RP node available for the moment.\nPlease be patient…"
msg.OPTIONS_CROSS_RP_SUB_TEXT_ACTIVE = "Cross RP communication is active for the following locations:\n\n{bands}"

--- Tips and Tricks
msg.TIPS_AND_TRICKS_ENABLE = "Show tips and tricks on startup."

msg.TIPS_AND_TRICKS_NAMEPLATES_TITLE = "Animations and nameplates"
msg.TIPS_AND_TRICKS_NAMEPLATES_TEXT = "A special animation is visible on characters who play music when nameplates are enabled.\n\nAn icon {icon} also indicates who have Musician and can hear you.\n\nDo you want to enable nameplates and animations now?"
msg.TIPS_AND_TRICKS_NAMEPLATES_OK = "Enable nameplates and animations"
msg.TIPS_AND_TRICKS_NAMEPLATES_CANCEL = "Later"

msg.TIPS_AND_TRICKS_CROSS_RP_TITLE = "Cross-faction music with Cross RP"
msg.TIPS_AND_TRICKS_CROSS_RP_TEXT = "Install the Cross RP add-on by Tammya-MoonGuard to activate\ncross-faction and cross-realm music!"
msg.TIPS_AND_TRICKS_CROSS_RP_OK = "OK"

--- Welcome messages
msg.STARTUP = "Welcome to Musician v{version}."
msg.PLAYER_COUNT_ONLINE = "There are {count} other music fans around!"
msg.PLAYER_COUNT_ONLINE_ONE = "There is another music fan around!"
msg.PLAYER_COUNT_ONLINE_NONE = "There are no other music fans around yet."

--- New version notifications
msg.NEW_VERSION = "A new version of Musician has been released! Download the update from {url} ."
msg.NEW_PROTOCOL_VERSION = "Your version of Musician is outdated and does not work anymore.\nPlease download the update from\n{url}"

-- Module warnings
msg.ERR_INCOMPATIBLE_MODULE_API = "Musician module for {module} could not start because {module} is incompatible. Try updating Musician and {module}."

-- Loading screen
msg.LOADING_SCREEN_MESSAGE = "Musician is preloading the instrument samples into cache…"
msg.LOADING_SCREEN_CLOSE_TOOLTIP = "Close and continue preloading in background."

--- Player tooltips
msg.PLAYER_TOOLTIP = "Musician"
msg.PLAYER_TOOLTIP_VERSION = "{name} v{version}"
msg.PLAYER_TOOLTIP_VERSION_OUTDATED = " (Outdated)"
msg.PLAYER_TOOLTIP_VERSION_INCOMPATIBLE = " (INCOMPATIBLE)"
msg.PLAYER_TOOLTIP_PRELOADING = "Preloading sounds… ({progress})"

--- URL hyperlinks tooltip
msg.TOOLTIP_COPY_URL = "Press {shortcut} to copy."

--- Song import
msg.INVALID_MUSIC_CODE = "Invalid music code."
msg.PLAY_A_SONG = "Play a song"
msg.IMPORT_A_SONG = "Import a song"
msg.PASTE_MUSIC_CODE = "Import your song in MIDI format at:\n{url}\n\nthen paste the music code here ({shortcut})…"
msg.SONG_IMPORTED = "Loaded song: {title}."

--- Play as a band
msg.PLAY_IN_BAND = "Play as a band"
msg.PLAY_IN_BAND_HINT = "Click here when you are ready to play this song with your band."
msg.PLAY_IN_BAND_READY_PLAYERS = "Ready band members:"
msg.EMOTE_PLAYER_IS_READY = "is ready to play as a band."
msg.EMOTE_PLAYER_IS_NOT_READY = "is no longer ready to play as a band."
msg.EMOTE_PLAY_IN_BAND_START = "started band playing."
msg.EMOTE_PLAY_IN_BAND_STOP = "stopped band playing."

--- Play as a band (live)
msg.LIVE_SYNC = "Play live as a band"
msg.LIVE_SYNC_HINT = "Click here to activate band synchronization."
msg.SYNCED_PLAYERS = "Live band members:"
msg.EMOTE_PLAYER_LIVE_SYNC_ENABLED = "is playing music with you."
msg.EMOTE_PLAYER_LIVE_SYNC_DISABLED = "stopped playing music with you."

--- Song editor frame
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
msg.ACCENT_TRACK = "Accent"
msg.TRANSPOSE_TRACK = "Transpose (octave)"
msg.CHANGE_TRACK_INSTRUMENT = "Change instrument"
msg.HEADER_NUMBER = "#"
msg.HEADER_OCTAVE = "Octave"
msg.HEADER_INSTRUMENT = "Instrument"
msg.HEADER_ACCENT = "x2"

--- Configure live keyboard frame
msg.SHOULD_CONFIGURE_KEYBOARD = "You have to configure the keyboard before playing."
msg.CONFIGURE_KEYBOARD = "Configure keyboard"
msg.CONFIGURE_KEYBOARD_HINT = "Click a key to set…"
msg.CONFIGURE_KEYBOARD_HINT_COMPLETE = "Keyboard configuration is complete.\nYou can now save your changes and start playing music!"
msg.CONFIGURE_KEYBOARD_START_OVER = "Start over"
msg.CONFIGURE_KEYBOARD_SAVE = "Save configuration"
msg.PRESS_KEY_BINDING = "Press the key #{col} in row #{row}."
msg.KEY_CAN_BE_EMPTY = "This key is optional and can be empty."
msg.KEY_IS_MERGEABLE = "This key could be the same as the {key} key on your keyboard: {action}"
msg.KEY_CAN_BE_MERGED = "in this case, just press the {key} key."
msg.KEY_CANNOT_BE_MERGED = "in this case, just ignore it and proceed to the next key."
msg.NEXT_KEY = "Next key"
msg.CLEAR_KEY = "Clear key"

--- About frame
msg.ABOUT_TITLE = "Musician"
msg.ABOUT_VERSION = "version {version}"
msg.ABOUT_AUTHOR = "By LenweSaralonde – {url}"
msg.ABOUT_LICENSE = "Released under GNU General Public License v3.0"
msg.ABOUT_DISCORD = "Discord: {url}"
msg.ABOUT_SUPPORT = "Do you like Musician? Share it with everyone!"
msg.ABOUT_PATREON = "Become a patron: {url}"
msg.ABOUT_PAYPAL = "Donate: {url}"
msg.ABOUT_SUPPORTERS = "Special thanks to the supporters of the project <3"
msg.ABOUT_LOCALIZATION_TEAM = "Localization Team:"
msg.ABOUT_CONTRIBUTE_TO_LOCALIZATION = "Help us translating Musician in your language!\n{url}"

--- Fixed PC keyboard key names
msg.FIXED_KEY_NAMES[KEY.Backspace] = "Back"
msg.FIXED_KEY_NAMES[KEY.Tab] = "Tab"
msg.FIXED_KEY_NAMES[KEY.CapsLock] = "Caps lock"
msg.FIXED_KEY_NAMES[KEY.Enter] = "Enter"
msg.FIXED_KEY_NAMES[KEY.ShiftLeft] = "Shift"
msg.FIXED_KEY_NAMES[KEY.ShiftRight] = "Shift"
msg.FIXED_KEY_NAMES[KEY.ControlLeft] = "Ctrl"
msg.FIXED_KEY_NAMES[KEY.MetaLeft] = "Meta"
msg.FIXED_KEY_NAMES[KEY.AltLeft] = "Alt"
msg.FIXED_KEY_NAMES[KEY.Space] = "Space"
msg.FIXED_KEY_NAMES[KEY.AltRight] = "Alt"
msg.FIXED_KEY_NAMES[KEY.MetaRight] = "Meta"
msg.FIXED_KEY_NAMES[KEY.ContextMenu] = "Menu"
msg.FIXED_KEY_NAMES[KEY.ControlRight] = "Ctrl"
msg.FIXED_KEY_NAMES[KEY.Delete] = "Delete"

--- Live keyboard layouts, based on musical modes
msg.KEYBOARD_LAYOUTS["Piano"] = "Piano"
msg.KEYBOARD_LAYOUTS["Chromatic"] = "Chromatic"
msg.KEYBOARD_LAYOUTS["Modes"] = "Modes"
msg.KEYBOARD_LAYOUTS["Ionian"] = "Ionian"
msg.KEYBOARD_LAYOUTS["Dorian"] = "Dorian"
msg.KEYBOARD_LAYOUTS["Phrygian"] = "Phrygian"
msg.KEYBOARD_LAYOUTS["Lydian"] = "Lydian"
msg.KEYBOARD_LAYOUTS["Mixolydian"] = "Mixolydian"
msg.KEYBOARD_LAYOUTS["Aeolian"] = "Aeolian"
msg.KEYBOARD_LAYOUTS["Locrian"] = "Locrian"
msg.KEYBOARD_LAYOUTS["minor Harmonic"] = "minor Harmonic"
msg.KEYBOARD_LAYOUTS["minor Melodic"] = "minor Melodic"
msg.KEYBOARD_LAYOUTS["Blues scales"] = "Blues scales"
msg.KEYBOARD_LAYOUTS["Major Blues"] = "Major Blues"
msg.KEYBOARD_LAYOUTS["minor Blues"] = "minor Blues"
msg.KEYBOARD_LAYOUTS["Diminished scales"] = "Diminished scales"
msg.KEYBOARD_LAYOUTS["Diminished"] = "Diminished"
msg.KEYBOARD_LAYOUTS["Complement Diminished"] = "Complement Diminished"
msg.KEYBOARD_LAYOUTS["Pentatonic scales"] = "Pentatonic scales"
msg.KEYBOARD_LAYOUTS["Major Pentatonic"] = "Major Pentatonic"
msg.KEYBOARD_LAYOUTS["minor Pentatonic"] = "minor Pentatonic"
msg.KEYBOARD_LAYOUTS["World scales"] = "World scales"
msg.KEYBOARD_LAYOUTS["Raga 1"] = "Raga 1"
msg.KEYBOARD_LAYOUTS["Raga 2"] = "Raga 2"
msg.KEYBOARD_LAYOUTS["Raga 3"] = "Raga 3"
msg.KEYBOARD_LAYOUTS["Arabic"] = "Arabic"
msg.KEYBOARD_LAYOUTS["Spanish"] = "Spanish"
msg.KEYBOARD_LAYOUTS["Gypsy"] = "Gypsy"
msg.KEYBOARD_LAYOUTS["Egyptian"] = "Egyptian"
msg.KEYBOARD_LAYOUTS["Hawaiian"] = "Hawaiian"
msg.KEYBOARD_LAYOUTS["Bali Pelog"] = "Bali Pelog"
msg.KEYBOARD_LAYOUTS["Japanese"] = "Japanese"
msg.KEYBOARD_LAYOUTS["Ryukyu"] = "Ryukyu"
msg.KEYBOARD_LAYOUTS["Chinese"] = "Chinese"
msg.KEYBOARD_LAYOUTS["Miscellaneous scales"] = "Miscellaneous scales"
msg.KEYBOARD_LAYOUTS["Bass Line"] = "Bass Line"
msg.KEYBOARD_LAYOUTS["Wholetone"] = "Wholetone"
msg.KEYBOARD_LAYOUTS["minor 3rd"] = "minor 3rd"
msg.KEYBOARD_LAYOUTS["Major 3rd"] = "Major 3rd"
msg.KEYBOARD_LAYOUTS["4th"] = "4th"
msg.KEYBOARD_LAYOUTS["5th"] = "5th"
msg.KEYBOARD_LAYOUTS["Octave"] = "Octave"

--- Live keyboard layout types
msg.HORIZONTAL_LAYOUT = "Horizontal"
msg.VERTICAL_LAYOUT = "Vertical"

--- Live keyboard frame
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
msg.SUSTAIN_KEY = "Sustain"
msg.POWER_CHORDS = "Power chords"
msg.PROGRAM_BUTTON = "P {num}"
msg.EMPTY_PROGRAM = "Empty program"
msg.LOAD_PROGRAM_NUM = "Load program #{num} ({key})"
msg.SAVE_PROGRAM_NUM = "Save in program #{num} ({key})"
msg.DELETE_PROGRAM_NUM = "Erase program #{num} ({key})"
msg.WRITE_PROGRAM = "Save program ({key})"
msg.DELETE_PROGRAM = "Delete program ({key})"
msg.PROGRAM_SAVED = "Program #{num} saved."
msg.PROGRAM_DELETED = "Program #{num} erased."
msg.DEMO_MODE_ENABLED = "Keyboard demo mode enabled:\n{mapping}"
msg.DEMO_MODE_MAPPING = "{layer} → Track #{track}"
msg.DEMO_MODE_DISABLED = "Keyboard demo mode disabled."

--- Live keyboard layers
msg.LAYERS[Musician.KEYBOARD_LAYER.UPPER] = "Upper"
msg.LAYERS[Musician.KEYBOARD_LAYER.LOWER] = "Lower"

--- Chat emotes
msg.EMOTE_PLAYING_MUSIC = "is playing a song."
msg.EMOTE_PROMO = "(Get the “Musician” add-on to listen)"
msg.EMOTE_SONG_NOT_LOADED = "(The song cannot play because {player} is using an incompatible version.)"
msg.EMOTE_PLAYER_OTHER_REALM = "(This player is on another realm.)"
msg.EMOTE_PLAYER_OTHER_FACTION = "(This player is from another faction.)"

--- Minimap button tooltips
msg.TOOLTIP_LEFT_CLICK = "**Left click**: {action}"
msg.TOOLTIP_RIGHT_CLICK = "**Right click**: {action}"
msg.TOOLTIP_DRAG_AND_DROP = "**Drag and drop** to move"
msg.TOOLTIP_ISMUTED = "(muted)"
msg.TOOLTIP_ACTION_OPEN_MENU = "Open the main menu"
msg.TOOLTIP_ACTION_MUTE = "Mute all music"
msg.TOOLTIP_ACTION_UNMUTE = "Unmute music"

--- Player menu options
msg.PLAYER_MENU_TITLE = "Music"
msg.PLAYER_MENU_STOP_CURRENT_SONG = "Stop current song"
msg.PLAYER_MENU_MUTE = "Mute"
msg.PLAYER_MENU_UNMUTE = "Unmute"

--- Player actions feedback
msg.PLAYER_IS_MUTED = "{icon}{player} is now muted."
msg.PLAYER_IS_UNMUTED = "{icon}{player} is now unmuted."

--- Song links
msg.LINKS_PREFIX = "Music"
msg.LINKS_FORMAT = "{prefix}: {title}"
msg.LINKS_LINK_BUTTON = "Link"
msg.LINKS_CHAT_BUBBLE = "“{note}{title}”"

--- Song link export frame
msg.LINK_EXPORT_WINDOW_TITLE = "Create song link"
msg.LINK_EXPORT_WINDOW_SONG_TITLE_LABEL = "Song title:"
msg.LINK_EXPORT_WINDOW_HINT = "The link will remain active until you log out or reload the interface."
msg.LINK_EXPORT_WINDOW_PROGRESS = "Generating link… {progress}%"
msg.LINK_EXPORT_WINDOW_POST_BUTTON = "Post link into the chat"

--- Song link import frame
msg.LINK_IMPORT_WINDOW_TITLE = "Import song from {player}:"
msg.LINK_IMPORT_WINDOW_HINT = "Click “Import” to start importing the song into Musician."
msg.LINK_IMPORT_WINDOW_IMPORT_BUTTON = "Import song"
msg.LINK_IMPORT_WINDOW_CANCEL_IMPORT_BUTTON = "Cancel import"
msg.LINK_IMPORT_WINDOW_REQUESTING = "Requesting song from {player}…"
msg.LINK_IMPORT_WINDOW_PROGRESS = "Importing… {progress}%"
msg.LINK_IMPORT_WINDOW_SELECT_ACCOUNT = "Please select the character to retrieve the song from:"

--- Song links errors
msg.LINKS_ERROR.notFound = "The song “{title}” is not available from {player}."
msg.LINKS_ERROR.alreadySending = "A song is already being sent to you by {player}. Please try again in a few seconds."
msg.LINKS_ERROR.alreadyRequested = "A song is already being requested from {player}."
msg.LINKS_ERROR.timeout = "{player} did not respond."
msg.LINKS_ERROR.offline = "{player} is not logged into World of Warcraft."
msg.LINKS_ERROR.importingFailed = "The song {title} could not be imported from {player}."

--- Map tracking options
msg.MAP_OPTIONS_TITLE = "Map"
msg.MAP_OPTIONS_SUB_TEXT = "Show nearby musicians playing:"
msg.MAP_OPTIONS_MINI_MAP = "On the minimap"
msg.MAP_OPTIONS_WORLD_MAP = "On the world map"
msg.MAP_TRACKING_OPTIONS_TITLE = "Musician"
msg.MAP_TRACKING_OPTION_ACTIVE_MUSICIANS = "Musicians playing"

--- Total RP Extended module
msg.TRPE_ITEM_NAME = "{title}"
msg.TRPE_ITEM_TOOLTIP_REQUIRES_MUSICIAN = "Requires Musician"
msg.TRPE_ITEM_TOOLTIP_SHEET_MUSIC = "Sheet music"
msg.TRPE_ITEM_USE_HINT = "Read the sheet music"
msg.TRPE_ITEM_MUSICIAN_NOT_FOUND = "You need to install the latest version of the “Musician” add-on to be able to use this item.\nGet it from {url}"
msg.TRPE_ITEM_NOTES = "Import the song into Musician to play it for the nearby players.\n\nDownload Musician: {url}\n"

msg.TRPE_EXPORT_BUTTON = "Export"
msg.TRPE_EXPORT_WINDOW_TITLE = "Export song as a Total RP item"
msg.TRPE_EXPORT_WINDOW_LOCALE = "Item language:"
msg.TRPE_EXPORT_WINDOW_ADD_TO_BAG = "Add to your bag"
msg.TRPE_EXPORT_WINDOW_QUANTITY = "Quantity:"
msg.TRPE_EXPORT_WINDOW_HINT_NEW = "Create a sheet music item in Total RP that can be traded with other players."
msg.TRPE_EXPORT_WINDOW_HINT_EXISTING = "An item already exists for this song, it will be updated."
msg.TRPE_EXPORT_WINDOW_CREATE_ITEM_BUTTON = "Create item"
msg.TRPE_EXPORT_WINDOW_PROGRESS = "Creating item… {progress}%"

--- Musician instrument names
msg.INSTRUMENT_NAMES["none"] = "(None)"
msg.INSTRUMENT_NAMES["accordion"] = "Accordion"
msg.INSTRUMENT_NAMES["bagpipe"] = "Bagpipe"
msg.INSTRUMENT_NAMES["dulcimer"] = "Dulcimer (hammered)"
msg.INSTRUMENT_NAMES["piano"] = "Piano"
msg.INSTRUMENT_NAMES["lute"] = "Lute"
msg.INSTRUMENT_NAMES["viola_da_gamba"] = "Viola da gamba"
msg.INSTRUMENT_NAMES["harp"] = "Celtic harp"
msg.INSTRUMENT_NAMES["male_voice"] = "Male voice (tenor)"
msg.INSTRUMENT_NAMES["female_voice"] = "Female voice (soprano)"
msg.INSTRUMENT_NAMES["trumpet"] = "Trumpet"
msg.INSTRUMENT_NAMES["sackbut"] = "Sackbut"
msg.INSTRUMENT_NAMES["war_horn"] = "War horn"
msg.INSTRUMENT_NAMES["bassoon"] = "Bassoon"
msg.INSTRUMENT_NAMES["clarinet"] = "Clarinet"
msg.INSTRUMENT_NAMES["recorder"] = "Recorder"
msg.INSTRUMENT_NAMES["fiddle"] = "Fiddle"
msg.INSTRUMENT_NAMES["percussions"] = "Percussions (traditional)"
msg.INSTRUMENT_NAMES["distortion_guitar"] = "Distortion guitar"
msg.INSTRUMENT_NAMES["clean_guitar"] = "Clean guitar"
msg.INSTRUMENT_NAMES["bass_guitar"] = "Bass guitar"
msg.INSTRUMENT_NAMES["drumkit"] = "Drum kit"
msg.INSTRUMENT_NAMES["war_drum"] = "War drum"
msg.INSTRUMENT_NAMES["woodblock"] = "Woodblock"
msg.INSTRUMENT_NAMES["tambourine_shake"] = "Tambourine (shaken)"

--- General MIDI instrument names
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGrandPiano] = "Acoustic grand piano"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrightAcousticPiano] = "Bright acoustic piano"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGrandPiano] = "Electric grand piano"
msg.MIDI_INSTRUMENT_NAMES[Instrument.HonkyTonkPiano] = "Honky-tonk piano"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricPiano1] = "Electric piano 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricPiano2] = "Electric piano 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Harpsichord] = "Harpsichord"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Clavi] = "Clavi"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Celesta] = "Celesta"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Glockenspiel] = "Glockenspiel"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MusicBox] = "Music box"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Vibraphone] = "Vibraphone"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Marimba] = "Marimba"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Xylophone] = "Xylophone"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TubularBells] = "Tubular bells"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Dulcimer] = "Dulcimer"
msg.MIDI_INSTRUMENT_NAMES[Instrument.DrawbarOrgan] = "Drawbar organ"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PercussiveOrgan] = "Percussive organ"
msg.MIDI_INSTRUMENT_NAMES[Instrument.RockOrgan] = "Rock organ"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ChurchOrgan] = "Church organ"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ReedOrgan] = "Reed organ"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Accordion] = "Accordion"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Harmonica] = "Harmonica"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TangoAccordion] = "Tango accordion"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGuitarNylon] = "Acoustic guitar (nylon)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGuitarSteel] = "Acoustic guitar (steel)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarJazz] = "Electric guitar (jazz)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarClean] = "Electric guitar (clean)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarMuted] = "Electric guitar (muted)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OverdrivenGuitar] = "Overdriven guitar"
msg.MIDI_INSTRUMENT_NAMES[Instrument.DistortionGuitar] = "Distortion guitar"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Guitarharmonics] = "Guitar harmonics"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticBass] = "Acoustic bass"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricBassFinger] = "Electric bass (fingered)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricBassPick] = "Electric bass (picked)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FretlessBass] = "Fretless bass"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SlapBass1] = "Slap bass 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SlapBass2] = "Slap bass 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBass1] = "Synth bass 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBass2] = "Synth bass 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Violin] = "Violin"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Viola] = "Viola"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Cello] = "Cello"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Contrabass] = "Contrabass"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TremoloStrings] = "Tremolo strings"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PizzicatoStrings] = "Pizzicato strings"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestralHarp] = "Orchestral harp"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Timpani] = "Timpani"
msg.MIDI_INSTRUMENT_NAMES[Instrument.StringEnsemble1] = "String ensemble 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.StringEnsemble2] = "String ensemble 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthStrings1] = "Synth strings 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthStrings2] = "Synth strings 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ChoirAahs] = "Choir aahs"
msg.MIDI_INSTRUMENT_NAMES[Instrument.VoiceOohs] = "Voice oohs"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthVoice] = "Synth voice"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestraHit] = "Orchestra hit"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Trumpet] = "Trumpet"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Trombone] = "Trombone"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Tuba] = "Tuba"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MutedTrumpet] = "Muted trumpet"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FrenchHorn] = "French horn"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrassSection] = "Brass section"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBrass1] = "Synth brass 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBrass2] = "Synth brass 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SopranoSax] = "Soprano sax"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AltoSax] = "Alto sax"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TenorSax] = "Tenor sax"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BaritoneSax] = "Baritone sax"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Oboe] = "Oboe"
msg.MIDI_INSTRUMENT_NAMES[Instrument.EnglishHorn] = "English horn"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Bassoon] = "Bassoon"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Clarinet] = "Clarinet"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Piccolo] = "Piccolo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Flute] = "Flute"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Recorder] = "Recorder"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PanFlute] = "Pan flute"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BlownBottle] = "Blown bottle"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shakuhachi] = "Shakuhachi"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Whistle] = "Whistle"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Ocarina] = "Ocarina"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead1Square] = "Lead 1 (square)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead2Sawtooth] = "Lead 2 (sawtooth)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead3Calliope] = "Lead 3 (calliope)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead4Chiff] = "Lead 4 (chiff)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead5Charang] = "Lead 5 (charang)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead6Voice] = "Lead 6 (voice)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead7Fifths] = "Lead 7 (fifths)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead8BassLead] = "Lead 8 (bass + lead)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad1Newage] = "Pad 1 (new age)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad2Warm] = "Pad 2 (warm)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad3Polysynth] = "Pad 3 (polysynth)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad4Choir] = "Pad 4 (choir)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad5Bowed] = "Pad 5 (bowed)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad6Metallic] = "Pad 6 (metallic)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad7Halo] = "Pad 7 (halo)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad8Sweep] = "Pad 8 (sweep)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX1Rain] = "FX 1 (rain)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX2Soundtrack] = "FX 2 (soundtrack)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX3Crystal] = "FX 3 (crystal)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX4Atmosphere] = "FX 4 (atmosphere)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX5Brightness] = "FX 5 (brightness)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX6Goblins] = "FX 6 (goblins)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX7Echoes] = "FX 7 (echoes)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX8SciFi] = "FX 8 (sci-fi)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Sitar] = "Sitar"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Banjo] = "Banjo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shamisen] = "Shamisen"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Koto] = "Koto"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Kalimba] = "Kalimba"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Bagpipe] = "Bag pipe"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Fiddle] = "Fiddle"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shanai] = "Shanai"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TinkleBell] = "Tinkle bell"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Agogo] = "Agogo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SteelDrums] = "Steel drums"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Woodblock] = "Woodblock"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TaikoDrum] = "Taiko drum"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MelodicTom] = "Melodic tom"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthDrum] = "Synth drum"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ReverseCymbal] = "Reverse cymbal"
msg.MIDI_INSTRUMENT_NAMES[Instrument.GuitarFretNoise] = "Guitar fret noise"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BreathNoise] = "Breath noise"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Seashore] = "Seashore"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BirdTweet] = "Bird tweet"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TelephoneRing] = "Telephone ring"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Helicopter] = "Helicopter"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Applause] = "Applause"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Gunshot] = "Gunshot"

--- General MIDI drum kit names
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_INSTRUMENT_NAMES[Instrument.StandardKit] = "Standard drum kit"
msg.MIDI_INSTRUMENT_NAMES[Instrument.RoomKit] = "Room drum kit"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PowerKit] = "Power drum kit"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectronicKit] = "Electronic drum kit"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TR808Kit] = "TR-808 drum machine"
msg.MIDI_INSTRUMENT_NAMES[Instrument.JazzKit] = "Jazz drum kit"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrushKit] = "Brush drum kit"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestraKit] = "Orchestra drum kit"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SoundFXKit] = "Sound FX"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MT32Kit] = "MT-32 drum kit"
msg.MIDI_INSTRUMENT_NAMES[Instrument.None] = "(None)"
msg.UNKNOWN_DRUMKIT = "Unknown drum kit ({midi})"

--- General MIDI percussion list
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_PERCUSSION_NAMES[Percussion.Laser] = "Laser" -- MIDI key 27
msg.MIDI_PERCUSSION_NAMES[Percussion.Whip] = "Whip" -- MIDI key 28
msg.MIDI_PERCUSSION_NAMES[Percussion.ScratchPush] = "Scratch push" -- MIDI key 29
msg.MIDI_PERCUSSION_NAMES[Percussion.ScratchPull] = "Scratch pull" -- MIDI key 30
msg.MIDI_PERCUSSION_NAMES[Percussion.StickClick] = "Stick click" -- MIDI key 31
msg.MIDI_PERCUSSION_NAMES[Percussion.SquareClick] = "Square click" -- MIDI key 32
msg.MIDI_PERCUSSION_NAMES[Percussion.MetronomeClick] = "Metronome click" -- MIDI key 33
msg.MIDI_PERCUSSION_NAMES[Percussion.MetronomeBell] = "Metronome bell" -- MIDI key 34
msg.MIDI_PERCUSSION_NAMES[Percussion.AcousticBassDrum] = "Acoustic bass drum" -- MIDI key 35
msg.MIDI_PERCUSSION_NAMES[Percussion.BassDrum1] = "Bass drum 1" -- MIDI key 36
msg.MIDI_PERCUSSION_NAMES[Percussion.SideStick] = "Side stick" -- MIDI key 37
msg.MIDI_PERCUSSION_NAMES[Percussion.AcousticSnare] = "Acoustic snare" -- MIDI key 38
msg.MIDI_PERCUSSION_NAMES[Percussion.HandClap] = "Hand clap" -- MIDI key 39
msg.MIDI_PERCUSSION_NAMES[Percussion.ElectricSnare] = "Electric snare" -- MIDI key 40
msg.MIDI_PERCUSSION_NAMES[Percussion.LowFloorTom] = "Low floor tom" -- MIDI key 41
msg.MIDI_PERCUSSION_NAMES[Percussion.ClosedHiHat] = "Closed hi-hat" -- MIDI key 42
msg.MIDI_PERCUSSION_NAMES[Percussion.HighFloorTom] = "High floor tom" -- MIDI key 43
msg.MIDI_PERCUSSION_NAMES[Percussion.PedalHiHat] = "Pedal hi-hat" -- MIDI key 44
msg.MIDI_PERCUSSION_NAMES[Percussion.LowTom] = "Low tom" -- MIDI key 45
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenHiHat] = "Open hi-hat" -- MIDI key 46
msg.MIDI_PERCUSSION_NAMES[Percussion.LowMidTom] = "Low-mid tom" -- MIDI key 47
msg.MIDI_PERCUSSION_NAMES[Percussion.HiMidTom] = "Hi-mid tom" -- MIDI key 48
msg.MIDI_PERCUSSION_NAMES[Percussion.CrashCymbal1] = "Crash cymbal 1" -- MIDI key 49
msg.MIDI_PERCUSSION_NAMES[Percussion.HighTom] = "High tom" -- MIDI key 50
msg.MIDI_PERCUSSION_NAMES[Percussion.RideCymbal1] = "Ride cymbal 1" -- MIDI key 51
msg.MIDI_PERCUSSION_NAMES[Percussion.ChineseCymbal] = "Chinese cymbal" -- MIDI key 52
msg.MIDI_PERCUSSION_NAMES[Percussion.RideBell] = "Ride bell" -- MIDI key 53
msg.MIDI_PERCUSSION_NAMES[Percussion.Tambourine] = "Tambourine" -- MIDI key 54
msg.MIDI_PERCUSSION_NAMES[Percussion.SplashCymbal] = "Splash cymbal" -- MIDI key 55
msg.MIDI_PERCUSSION_NAMES[Percussion.Cowbell] = "Cowbell" -- MIDI key 56
msg.MIDI_PERCUSSION_NAMES[Percussion.CrashCymbal2] = "Crash cymbal 2" -- MIDI key 57
msg.MIDI_PERCUSSION_NAMES[Percussion.Vibraslap] = "Vibraslap" -- MIDI key 58
msg.MIDI_PERCUSSION_NAMES[Percussion.RideCymbal2] = "Ride cymbal 2" -- MIDI key 59
msg.MIDI_PERCUSSION_NAMES[Percussion.HiBongo] = "Hi bongo" -- MIDI key 60
msg.MIDI_PERCUSSION_NAMES[Percussion.LowBongo] = "Low bongo" -- MIDI key 61
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteHiConga] = "Mute hi conga" -- MIDI key 62
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenHiConga] = "Open hi conga" -- MIDI key 63
msg.MIDI_PERCUSSION_NAMES[Percussion.LowConga] = "Low conga" -- MIDI key 64
msg.MIDI_PERCUSSION_NAMES[Percussion.HighTimbale] = "High timbale" -- MIDI key 65
msg.MIDI_PERCUSSION_NAMES[Percussion.LowTimbale] = "Low timbale" -- MIDI key 66
msg.MIDI_PERCUSSION_NAMES[Percussion.HighAgogo] = "High agogo" -- MIDI key 67
msg.MIDI_PERCUSSION_NAMES[Percussion.LowAgogo] = "Low agogo" -- MIDI key 68
msg.MIDI_PERCUSSION_NAMES[Percussion.Cabasa] = "Cabasa" -- MIDI key 69
msg.MIDI_PERCUSSION_NAMES[Percussion.Maracas] = "Maracas" -- MIDI key 70
msg.MIDI_PERCUSSION_NAMES[Percussion.ShortWhistle] = "Short whistle" -- MIDI key 71
msg.MIDI_PERCUSSION_NAMES[Percussion.LongWhistle] = "Long whistle" -- MIDI key 72
msg.MIDI_PERCUSSION_NAMES[Percussion.ShortGuiro] = "Short guiro" -- MIDI key 73
msg.MIDI_PERCUSSION_NAMES[Percussion.LongGuiro] = "Long guiro" -- MIDI key 74
msg.MIDI_PERCUSSION_NAMES[Percussion.Claves] = "Claves" -- MIDI key 75
msg.MIDI_PERCUSSION_NAMES[Percussion.HiWoodBlock] = "Hi wood block" -- MIDI key 76
msg.MIDI_PERCUSSION_NAMES[Percussion.LowWoodBlock] = "Low wood block" -- MIDI key 77
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteCuica] = "Mute cuica" -- MIDI key 78
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenCuica] = "Open cuica" -- MIDI key 79
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteTriangle] = "Mute triangle" -- MIDI key 80
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenTriangle] = "Open triangle" -- MIDI key 81
msg.MIDI_PERCUSSION_NAMES[Percussion.Shaker] = "Shaker" -- MIDI key 82
msg.MIDI_PERCUSSION_NAMES[Percussion.SleighBell] = "Sleigh bell" -- MIDI key 83
msg.MIDI_PERCUSSION_NAMES[Percussion.BellTree] = "Bell tree" -- MIDI key 84
msg.MIDI_PERCUSSION_NAMES[Percussion.Castanets] = "Castanets" -- MIDI key 85
msg.MIDI_PERCUSSION_NAMES[Percussion.SurduDeadStroke] = "Surdu dead stroke" -- MIDI key 86
msg.MIDI_PERCUSSION_NAMES[Percussion.Surdu] = "Surdu" -- MIDI key 87
msg.MIDI_PERCUSSION_NAMES[Percussion.SnareDrumRod] = "Snare drum rod" -- MIDI key 88
msg.MIDI_PERCUSSION_NAMES[Percussion.OceanDrum] = "Ocean drum" -- MIDI key 89
msg.MIDI_PERCUSSION_NAMES[Percussion.SnareDrumBrush] = "Snare drum brush" -- MIDI key 90