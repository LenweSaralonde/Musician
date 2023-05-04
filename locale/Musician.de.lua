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

local msg = Musician.InitLocale("de", "Deutsch", "deDE")

local Instrument = Musician.MIDI_INSTRUMENTS
local Percussion = Musician.MIDI_PERCUSSIONS
local KEY = Musician.KEYBOARD_KEY

------------------------------------------------------------------------
---------------- ↑↑↑ DO NOT EDIT THE LINES ABOVE ! ↑↑↑  ----------------
------------------------------------------------------------------------

--- Main frame controls
msg.PLAY = "Abspielen"
msg.STOP = "Stopp"
msg.PAUSE = "Pause"
msg.TEST_SONG = "Vorschau"
msg.STOP_TEST = "Vorsch. stopp"
msg.CLEAR = "klar"
msg.SELECT_ALL = "Alles auswählen"
msg.EDIT = "Bearb."
msg.MUTE = "Stumm"
msg.UNMUTE = "Stummschaltung aufheben"

--- Minimap button menu
msg.MENU_TITLE = "Musician"
msg.MENU_IMPORT_SONG = "Hauptmenü"
msg.MENU_PLAY = "abspielen"
msg.MENU_STOP = "anhalten"
msg.MENU_PLAY_PREVIEW = "Vorschau"
msg.MENU_STOP_PREVIEW = "Vorsch. stopp"
msg.MENU_LIVE_PLAY = "Live spielen"
msg.MENU_SHOW_KEYBOARD = "Tastatur öffnen"
msg.MENU_SETTINGS = "Einstellungen"
msg.MENU_OPTIONS = "Optionen"
msg.MENU_ABOUT = "Über"

--- Chat commands
msg.COMMAND_LIST_TITLE = "Musicianbefehle:"
msg.COMMAND_SHOW = "Fenster zum Importieren von Songs anzeigen"
msg.COMMAND_PREVIEW_PLAY = "Vorschau abspielen"
msg.COMMAND_PREVIEW_STOP = "Vorschau beenden"
msg.COMMAND_PLAY = "Lied abspielen"
msg.COMMAND_STOP = "Lied beenden"
msg.COMMAND_SONG_EDITOR = "Songeditor öffnen"
msg.COMMAND_LIVE_KEYBOARD = "Live-Tastatur öffnen"
msg.COMMAND_CONFIGURE_KEYBOARD = "Tastatur konfigurieren"
msg.COMMAND_LIVE_DEMO = "Tastatur-Demo-Modus"
msg.COMMAND_LIVE_DEMO_PARAMS = "{** <obere Spur #> ** ** <untere Spur #> ** || **aus** }"
msg.COMMAND_HELP = "Diese Hilfemeldung anzeigen"
msg.ERR_COMMAND_UNKNOWN = "Unbekannter Befehl “{command}”. Geben Sie {help} ein, um die Befehlsliste abzurufen."

--- Add-on options
msg.OPTIONS_TITLE = "Musician"
msg.OPTIONS_SUB_TEXT = "Tritt dem Discord-Server bei, um Unterstützung zu erhalten! {url}"
msg.OPTIONS_CATEGORY_EMOTE = "Emote"
msg.OPTIONS_ENABLE_EMOTE_LABEL = "Textemote für Spieler ohne Musician anzeigen"
msg.OPTIONS_ENABLE_EMOTE_PROMO_LABEL = "Bei Textemote einen Hinweis auf Musician anzeigen."
msg.OPTIONS_EMOTE_HINT = "Das Textemote zeigt einen Hinweis für Spieler ohne Musician an. Dies kann in den Optionen deaktiviert werden."
msg.OPTIONS_INTEGRATION_OPTIONS_TITLE = "Spieloptionen"
msg.OPTIONS_AUTO_MUTE_GAME_MUSIC_LABEL = "Spielmusik stummschalten während eines Liedes."
msg.OPTIONS_MUTE_INSTRUMENT_TOYS_LABEL = "Instrumentspielzeuge stummschalten {icons}"
msg.OPTIONS_AUDIO_CHANNELS_TITLE = "Audiokanäle"
msg.OPTIONS_AUDIO_CHANNELS_HINT = "Anzahl der Kanäle wählen um die maximale Anzahl der Noten zu erhöhen."
msg.OPTIONS_AUDIO_CHANNELS_CHANNEL_POLYPHONY = "{channel} ({polyphony})"
msg.OPTIONS_AUDIO_CHANNELS_TOTAL_POLYPHONY = "Maximale Kanalanzahl: {polyphony}"
msg.OPTIONS_AUDIO_CHANNELS_AUTO_ADJUST_CONFIG = "Audioeinstellungen automatisch optimieren, wenn mehrere Audiokanäle ausgewählt sind."
msg.OPTIONS_AUDIO_CACHE_SIZE_FOR_MUSICIAN = "Für Musician (%dMB)"
msg.OPTIONS_CATEGORY_SHORTCUTS = "Verknüpfungen"
msg.OPTIONS_SHORTCUT_MINIMAP = "Minikarte-Schaltfläche"
msg.OPTIONS_SHORTCUT_ADDON_MENU = "Minikarte-Menü"
msg.OPTIONS_QUICK_PRELOADING_TITLE = "Schnelles Vorladen"
msg.OPTIONS_QUICK_PRELOADING_TEXT = "Schnelles Vorladen der Instrumente beim Kaltstart aktivieren."
msg.OPTIONS_CATEGORY_NAMEPLATES = "Namensplakette und Animationen"
msg.OPTIONS_CATEGORY_NAMEPLATES_SUB_TEXT = "Namensplakette aktivieren um die Animation der Musiker anzuzeigen und um\nherauszufinden wer dich gerade hören kann."
msg.OPTIONS_ENABLE_NAMEPLATES = "Namensplakette und Animationen aktivieren"
msg.OPTIONS_SHOW_NAMEPLATE_ICON = "Zeige das  {icon} -Symbol neben allen Spielern die Musician haben."
msg.OPTIONS_HIDE_HEALTH_BARS = "Gesundheitsleiste ausserhalb des Kampfes ausblenden."
msg.OPTIONS_HIDE_NPC_NAMEPLATES = "NPC-Namensplakette ausblenden."
msg.OPTIONS_CINEMATIC_MODE = "Zeige die Animationen an, auch wenn die Benutzeroberfläche mit  {binding} ausgeblendet ist."
msg.OPTIONS_CINEMATIC_MODE_NO_BINDING = "Zeigen Sie Animationen an, wenn die Benutzeroberfläche ausgeblendet ist."
msg.OPTIONS_NAMEPLATES_CINEMATIC_MODE = "Zeigen Sie Namensplakette an, wenn die Benutzeroberfläche ausgeblendet ist."
msg.OPTIONS_TRP3 = "Total-RP 3"
msg.OPTIONS_TRP3_MAP_SCAN = "Zeige alle Spieler mit Musician auf der Karte mit einem  {icon} -Symbol an."
msg.OPTIONS_CROSS_RP_TITLE = "Cross RP"
msg.OPTIONS_CROSS_RP_SUB_TEXT = "Installiere Cross RP von Tammya-MoonGuard, um fraktions- und bereichsübergreifende Musik spielen zu können!"
msg.OPTIONS_CROSS_RP_SUB_TEXT_NO_GATEWAY = "Derzeit ist keine Cross-RP-Verbindung verfügbar.\n Bitte warte etwas…"
msg.OPTIONS_CROSS_RP_SUB_TEXT_ACTIVE = "Die RP-übergreifende Kommunikation ist für die folgenden Standorte aktiv:\n\n{bands}"

--- Tips and Tricks
msg.TIPS_AND_TRICKS_ENABLE = "Hinweise und Tricks anzeigen."

msg.TIPS_AND_TRICKS_NAMEPLATES_TITLE = "Animationen und Namensplakette"
msg.TIPS_AND_TRICKS_NAMEPLATES_TEXT = "Eine spezielle Animation ist für Charaktere sichtbar, die Musik abspielen, wenn die Namensplakette aktiviert sind.\n\nEin Symbol {icon} zeigt auch an, wer Musician hat und zuhören kann.\n\nMöchtest du die Namensplaketten nun aktivieren?"
msg.TIPS_AND_TRICKS_NAMEPLATES_OK = "Animationen und Namensplaketten aktivieren"
msg.TIPS_AND_TRICKS_NAMEPLATES_CANCEL = "Abbrechen"

msg.TIPS_AND_TRICKS_CROSS_RP_TITLE = "Fraktionsübergreifende Musik mit Cross RP"
msg.TIPS_AND_TRICKS_CROSS_RP_TEXT = "Installiere Cross RP von Tammya-MoonGuard, um fraktions- und bereichsübergreifende Musik spielen zu können!"
msg.TIPS_AND_TRICKS_CROSS_RP_OK = "OK"

--- Welcome messages
msg.STARTUP = "Willkommen bei Musician v {version}."
msg.PLAYER_COUNT_ONLINE = "Es gibt noch {count} andere Musikfans!"
msg.PLAYER_COUNT_ONLINE_ONE = "Es gibt noch einen Musikfan!"
msg.PLAYER_COUNT_ONLINE_NONE = "Es gibt noch keine anderen Musikfans."

--- New version notifications
msg.NEW_VERSION = "Eine neue Version von Musician wurde veröffentlicht! Laden Sie das Update von {url} herunter."
msg.NEW_PROTOCOL_VERSION = "Ihre Version von Musician ist veraltet und funktioniert nicht mehr.\nBitte laden Sie das Update von\n{url} herunter."

-- Module warnings
msg.ERR_INCOMPATIBLE_MODULE_API = "Musician-Modul für {module} konnte nicht gestartet werden, da {module} nicht kompatibel ist. Versuchen Sie, Musician und {module} zu aktualisieren."

-- Loading screen
msg.LOADING_SCREEN_MESSAGE = "Musician lädt die Instrumenten-Samples vorab in den Cache-Speicher…"
msg.LOADING_SCREEN_CLOSE_TOOLTIP = "Schließen und Vorladen im Hintergrund fortsetzen."

--- Player tooltips
msg.PLAYER_TOOLTIP = "Musician"
msg.PLAYER_TOOLTIP_VERSION = "{name} v {version}"
msg.PLAYER_TOOLTIP_VERSION_OUTDATED = " (Veraltet)"
msg.PLAYER_TOOLTIP_VERSION_INCOMPATIBLE = " (UNVEREINBAR)"
msg.PLAYER_TOOLTIP_PRELOADING = "Vorladen von Sounds… ({progress})"

--- URL hyperlinks tooltip
msg.TOOLTIP_COPY_URL = "Drücken Sie zum Kopieren {shortcut}."

--- Song import
msg.INVALID_MUSIC_CODE = "Ungültiger Musikcode."
msg.PLAY_A_SONG = "Spiel ein Lied"
msg.IMPORT_A_SONG = "Importiere ein Lied"
msg.PASTE_MUSIC_CODE = "Importiere dein Lied im MIDI-Format unter:\n{url}\n\nindem du den Code hier ({shortcut})…"
msg.SONG_IMPORTED = "Geladenes Lied: {title}."

--- Play as a band
msg.PLAY_IN_BAND = "Spiele als Band"
msg.PLAY_IN_BAND_HINT = "Hier klicken wenn du bereit bist als Band zu spielen."
msg.PLAY_IN_BAND_READY_PLAYERS = "Bandmitglieder:"
msg.EMOTE_PLAYER_IS_READY = "ist bereit, als Band zu spielen."
msg.EMOTE_PLAYER_IS_NOT_READY = "ist nicht mehr bereit, als Band zu spielen."
msg.EMOTE_PLAY_IN_BAND_START = "begann die Band zu spielen."
msg.EMOTE_PLAY_IN_BAND_STOP = "hörte auf zu spielen."

--- Play as a band (live)
msg.LIVE_SYNC = "Live als Band spielen"
msg.LIVE_SYNC_HINT = "Klick hier, um die Bandsynchronisation zu aktivieren."
msg.SYNCED_PLAYERS = "Live-Bandmitglieder:"
msg.EMOTE_PLAYER_LIVE_SYNC_ENABLED = "spielt Musik mit dir."
msg.EMOTE_PLAYER_LIVE_SYNC_DISABLED = "hat aufgehört, mit dir Musik zu spielen."

--- Song editor frame
msg.SONG_EDITOR = "Songeditor"
msg.MARKER_FROM = "Von"
msg.MARKER_TO = "Zu"
msg.POSITION = "Position"
msg.TRACK_NUMBER = "Track # {track}"
msg.CHANNEL_NUMBER_SHORT = "Ch. {channel}"
msg.JUMP_PREV = "Zurück 10s"
msg.JUMP_NEXT = "Vorwärts 10s"
msg.GO_TO_START = "Anfang"
msg.GO_TO_END = "Ende"
msg.SET_CROP_FROM = "Schnittpunkt Anfang"
msg.SET_CROP_TO = "Schnittpunkt Ende"
msg.SYNCHRONIZE_TRACKS = "Synchronisieren Sie die Spureinstellungen mit dem aktuellen Titel"
msg.MUTE_TRACK = "Stumm"
msg.SOLO_TRACK = "Solo"
msg.ACCENT_TRACK = "Betonen"
msg.TRANSPOSE_TRACK = "Transponieren (Oktave)"
msg.CHANGE_TRACK_INSTRUMENT = "Instrument wechseln"
msg.HEADER_NUMBER = "#"
msg.HEADER_OCTAVE = "Oktave"
msg.HEADER_INSTRUMENT = "Instrument"
msg.HEADER_ACCENT = "x2"

--- Configure live keyboard frame
msg.SHOULD_CONFIGURE_KEYBOARD = "Die Tastatur muss vor dem spielen konfiguriert werden."
msg.CONFIGURE_KEYBOARD = "Tastatur konfigurieren"
msg.CONFIGURE_KEYBOARD_HINT = "Klicken Sie auf einen Schlüssel, um…"
msg.CONFIGURE_KEYBOARD_HINT_COMPLETE = "Die Tastaturkonfiguration ist abgeschlossen.\nDu kannst die Änderungen nun speichern und mit dem spielen beginnen!"
msg.CONFIGURE_KEYBOARD_START_OVER = "Von vorn anfangen"
msg.CONFIGURE_KEYBOARD_SAVE = "Konfiguration speichern"
msg.PRESS_KEY_BINDING = "Drücke die Taste # {col} in Zeile # {row}."
msg.KEY_CAN_BE_EMPTY = "Diese Taste ist optional und darf unbelegt bleiben."
msg.KEY_IS_MERGEABLE = "Diese Taste kann mit der Taste {key} auf Ihrer Tastatur identisch sein: {action}"
msg.KEY_CAN_BE_MERGED = "In diesem Fall drücken Sie einfach die Taste {key}."
msg.KEY_CANNOT_BE_MERGED = "Die Taste kann nicht mit einer anderen identisch sein."
msg.NEXT_KEY = "Nächste Taste"
msg.CLEAR_KEY = "Taste löschen"

--- About frame
msg.ABOUT_TITLE = "Musician"
msg.ABOUT_VERSION = "version {version}"
msg.ABOUT_AUTHOR = "Von LenweSaralonde - {url}"
msg.ABOUT_LICENSE = "Veröffentlicht unter GNU General Public License v3.0"
msg.ABOUT_DISCORD = "Zwietracht: {url}"
msg.ABOUT_SUPPORT = "Magst du Musician? Teile es mit allen!"
msg.ABOUT_PATREON = "Werde Benutzer: {url}"
msg.ABOUT_PAYPAL = "Spenden: {url}"
msg.ABOUT_SUPPORTERS = "Besonderer Dank geht an die Unterstützer des Projekts <3"
msg.ABOUT_LOCALIZATION_TEAM = "Übersetzungsteam:"
msg.ABOUT_CONTRIBUTE_TO_LOCALIZATION = "Hilf uns, Musician in deine Sprache zu übersetzen!\n{url}"

--- Fixed PC keyboard key names
msg.FIXED_KEY_NAMES[KEY.Backspace] = "Rücktaste"
msg.FIXED_KEY_NAMES[KEY.Tab] = "Tabulator"
msg.FIXED_KEY_NAMES[KEY.CapsLock] = "Caps Lock"
msg.FIXED_KEY_NAMES[KEY.Enter] = "Eingeben"
msg.FIXED_KEY_NAMES[KEY.ShiftLeft] = "Umschalt L"
msg.FIXED_KEY_NAMES[KEY.ShiftRight] = "Umschalt R"
msg.FIXED_KEY_NAMES[KEY.ControlLeft] = "Strg L"
msg.FIXED_KEY_NAMES[KEY.MetaLeft] = "Meta L"
msg.FIXED_KEY_NAMES[KEY.AltLeft] = "Alt L"
msg.FIXED_KEY_NAMES[KEY.Space] = "Leertaste"
msg.FIXED_KEY_NAMES[KEY.AltRight] = "Alt R"
msg.FIXED_KEY_NAMES[KEY.MetaRight] = "Meta R"
msg.FIXED_KEY_NAMES[KEY.ContextMenu] = "Kontextmenü"
msg.FIXED_KEY_NAMES[KEY.ControlRight] = "Strg R"
msg.FIXED_KEY_NAMES[KEY.Delete] = "Löschen"

--- Live keyboard layouts, based on musical modes
msg.KEYBOARD_LAYOUTS["Piano"] = "Klavier"
msg.KEYBOARD_LAYOUTS["Chromatic"] = "Chromatisch"
msg.KEYBOARD_LAYOUTS["Modes"] = "Modi"
msg.KEYBOARD_LAYOUTS["Ionian"] = "ionisch"
msg.KEYBOARD_LAYOUTS["Dorian"] = "Dorian"
msg.KEYBOARD_LAYOUTS["Phrygian"] = "Phrygian"
msg.KEYBOARD_LAYOUTS["Lydian"] = "Lydian"
msg.KEYBOARD_LAYOUTS["Mixolydian"] = "Mixolydian"
msg.KEYBOARD_LAYOUTS["Aeolian"] = "äolisch"
msg.KEYBOARD_LAYOUTS["Locrian"] = "Locrian"
msg.KEYBOARD_LAYOUTS["minor Harmonic"] = "Moll Harmonische"
msg.KEYBOARD_LAYOUTS["minor Melodic"] = "Moll Melodic"
msg.KEYBOARD_LAYOUTS["Blues scales"] = "Blues-Skalen"
msg.KEYBOARD_LAYOUTS["Major Blues"] = "Major Blues"
msg.KEYBOARD_LAYOUTS["minor Blues"] = "Moll Blues"
msg.KEYBOARD_LAYOUTS["Diminished scales"] = "Verminderte Schuppen"
msg.KEYBOARD_LAYOUTS["Diminished"] = "Vermindert"
msg.KEYBOARD_LAYOUTS["Complement Diminished"] = "Komplement vermindert"
msg.KEYBOARD_LAYOUTS["Pentatonic scales"] = "Pentatonische Skalen"
msg.KEYBOARD_LAYOUTS["Major Pentatonic"] = "Major Pentatonic"
msg.KEYBOARD_LAYOUTS["minor Pentatonic"] = "Moll Pentatonisch"
msg.KEYBOARD_LAYOUTS["World scales"] = "Weltwaagen"
msg.KEYBOARD_LAYOUTS["Raga 1"] = "Raga 1"
msg.KEYBOARD_LAYOUTS["Raga 2"] = "Raga 2"
msg.KEYBOARD_LAYOUTS["Raga 3"] = "Raga 3"
msg.KEYBOARD_LAYOUTS["Arabic"] = "Arabisch"
msg.KEYBOARD_LAYOUTS["Spanish"] = "Spanisch"
msg.KEYBOARD_LAYOUTS["Gypsy"] = "Zigeuner"
msg.KEYBOARD_LAYOUTS["Egyptian"] = "ägyptisch"
msg.KEYBOARD_LAYOUTS["Hawaiian"] = "hawaiianisch"
msg.KEYBOARD_LAYOUTS["Bali Pelog"] = "Bali Pelog"
msg.KEYBOARD_LAYOUTS["Japanese"] = "japanisch"
msg.KEYBOARD_LAYOUTS["Ryukyu"] = "Ryukyu"
msg.KEYBOARD_LAYOUTS["Chinese"] = "Chinesisch"
msg.KEYBOARD_LAYOUTS["Miscellaneous scales"] = "Verschiedene Skalen"
msg.KEYBOARD_LAYOUTS["Bass Line"] = "Bass Line"
msg.KEYBOARD_LAYOUTS["Wholetone"] = "Vollton"
msg.KEYBOARD_LAYOUTS["minor 3rd"] = "Moll 3 .."
msg.KEYBOARD_LAYOUTS["Major 3rd"] = "Major 3 .."
msg.KEYBOARD_LAYOUTS["4th"] = "4 .."
msg.KEYBOARD_LAYOUTS["5th"] = "5 .."
msg.KEYBOARD_LAYOUTS["Octave"] = "Oktave"

--- Live keyboard layout types
msg.HORIZONTAL_LAYOUT = "Horizontal"
msg.VERTICAL_LAYOUT = "Vertikal"

--- Live keyboard frame
msg.LIVE_SONG_NAME = "Live-Song"
msg.SOLO_MODE = "Solo-Modus"
msg.LIVE_MODE = "Live-Modus"
msg.LIVE_MODE_DISABLED = "Der Live-Modus ist während der Wiedergabe deaktiviert."
msg.ENABLE_SOLO_MODE = "Solo Modus aktivieren (du spielst nur für dich)"
msg.ENABLE_LIVE_MODE = "Live Modus aktivieren (du spielst für alle!)"
msg.PLAY_LIVE = "Live spielen"
msg.PLAY_SOLO = "Solo spielen"
msg.SHOW_KEYBOARD = "Tastatur anzeigen"
msg.HIDE_KEYBOARD = "Tastatur ausblenden"
msg.KEYBOARD_LAYOUT = "Tastaturmodus & Skalierung"
msg.CHANGE_KEYBOARD_LAYOUT = "Tastaturlayout anpassen"
msg.BASE_KEY = "Basistaste"
msg.CHANGE_BASE_KEY = "Basistaste anpassen"
msg.CHANGE_LOWER_INSTRUMENT = "Unteres Instrument wechseln"
msg.CHANGE_UPPER_INSTRUMENT = "Oberes Instrument wechseln"
msg.LOWER_INSTRUMENT_MAPPED_TO_CHANNEL = "Unteres Instrument (Spur # {track})"
msg.UPPER_INSTRUMENT_MAPPED_TO_CHANNEL = "Oberes Instrument (Spur # {track})"
msg.SUSTAIN_KEY = "Sustain"
msg.POWER_CHORDS = "Power-Akkorde"
msg.PROGRAM_BUTTON = "P {num}"
msg.EMPTY_PROGRAM = "Programm leeren"
msg.LOAD_PROGRAM_NUM = "Programm laden # {num} ({key})"
msg.SAVE_PROGRAM_NUM = "Programm speichern # {num} ({key})"
msg.DELETE_PROGRAM_NUM = "Programm löschen # {num} ({key})"
msg.WRITE_PROGRAM = "Programm schreiben ({key})"
msg.DELETE_PROGRAM = "Programm löschen ({key})"
msg.PROGRAM_SAVED = "Programm # {num} gespeichert."
msg.PROGRAM_DELETED = "Programm # {num} gelöscht."
msg.DEMO_MODE_ENABLED = "Tastatur-Demo-Modus aktiviert:\n{mapping}"
msg.DEMO_MODE_MAPPING = "{layer} → Spur # {track}"
msg.DEMO_MODE_DISABLED = "Tastatur-Demo-Modus deaktiviert."

--- Live keyboard layers
msg.LAYERS[Musician.KEYBOARD_LAYER.UPPER] = "Oberer, höher"
msg.LAYERS[Musician.KEYBOARD_LAYER.LOWER] = "Niedriger"

--- Chat emotes
msg.EMOTE_PLAYING_MUSIC = "spielt ein Lied."
msg.EMOTE_PROMO = "(Hole dir das Addon Musician um zuzuhören!)"
msg.EMOTE_SONG_NOT_LOADED = "(Das Lied kann nicht abgespielt werden, da {player} eine inkompatible Version verwendet.)"
msg.EMOTE_PLAYER_OTHER_REALM = "(Dieser Spieler befindet sich auf einem anderen Server.)"
msg.EMOTE_PLAYER_OTHER_FACTION = "(Dieser Spieler stammt aus einer anderen Fraktion.)"

--- Minimap button tooltips
msg.TOOLTIP_LEFT_CLICK = "** Linksklick **: {action}"
msg.TOOLTIP_RIGHT_CLICK = "** Rechtsklick **: {action}"
msg.TOOLTIP_DRAG_AND_DROP = "** Ziehen und Ablegen **, um sich zu bewegen"
msg.TOOLTIP_ISMUTED = "(stumm geschaltet)"
msg.TOOLTIP_ACTION_OPEN_MENU = "Hauptmenü öffnen"
msg.TOOLTIP_ACTION_MUTE = "Alle Musik stumm schalten"
msg.TOOLTIP_ACTION_UNMUTE = "Musik stumm schalten"

--- Player menu options
msg.PLAYER_MENU_TITLE = "Musik"
msg.PLAYER_MENU_STOP_CURRENT_SONG = "Aktuelles Lied stoppen"
msg.PLAYER_MENU_MUTE = "Stumm"
msg.PLAYER_MENU_UNMUTE = "Stummschaltung aufheben"

--- Player actions feedback
msg.PLAYER_IS_MUTED = "{icon} {player} ist jetzt stummgeschaltet."
msg.PLAYER_IS_UNMUTED = "{icon} {player} ist jetzt nicht stummgeschaltet."

--- Song links
msg.LINKS_PREFIX = "Musik"
msg.LINKS_FORMAT = "{prefix}: {title}"
msg.LINKS_LINK_BUTTON = "Verknüpfung"
msg.LINKS_CHAT_BUBBLE = "“{note} {title}”"

--- Song link export frame
msg.LINK_EXPORT_WINDOW_TITLE = "Song-Link erstellen"
msg.LINK_EXPORT_WINDOW_SONG_TITLE_LABEL = "Song Titel:"
msg.LINK_EXPORT_WINDOW_HINT = "Der Link bleibt aktiv bis du dich abmeldetest oder das Spiel neu ladest."
msg.LINK_EXPORT_WINDOW_PROGRESS = "Link generieren… {progress}%"
msg.LINK_EXPORT_WINDOW_POST_BUTTON = "Link in den Chat posten"

--- Song link import frame
msg.LINK_IMPORT_WINDOW_TITLE = "Song von {player} importieren:"
msg.LINK_IMPORT_WINDOW_HINT = "Klicke auf “Importieren”, um den Import des Songs in Musician zu starten."
msg.LINK_IMPORT_WINDOW_IMPORT_BUTTON = "Song importieren"
msg.LINK_IMPORT_WINDOW_CANCEL_IMPORT_BUTTON = "Import abbrechen"
msg.LINK_IMPORT_WINDOW_REQUESTING = "Song von {player} anfordern…"
msg.LINK_IMPORT_WINDOW_PROGRESS = "Importieren… {progress}%"
msg.LINK_IMPORT_WINDOW_SELECT_ACCOUNT = "Bitte wähle den Charakter aus von dem das Lied abgerufen werden soll:"

--- Song links errors
msg.LINKS_ERROR.notFound = "Das Lied “{title}” ist nicht bei {player} erhältlich."
msg.LINKS_ERROR.alreadySending = "Ein Song wird bereits von {player} gesendet. Bitte versuchen es gleich erneut."
msg.LINKS_ERROR.alreadyRequested = "Ein Lied wird bereits von {player} angefordert."
msg.LINKS_ERROR.timeout = "{player} hat nicht geantwortet."
msg.LINKS_ERROR.offline = "{player} ist nicht bei World of Warcraft angemeldet."
msg.LINKS_ERROR.importingFailed = "Das Lied {title} konnte nicht aus {player} importiert werden."

--- Map tracking options
msg.MAP_OPTIONS_TITLE = "Karte"
msg.MAP_OPTIONS_SUB_TEXT = "Musiker in der Nähe anzeigen, die spielen:"
msg.MAP_OPTIONS_MINI_MAP = "Auf der Minikarte"
msg.MAP_OPTIONS_WORLD_MAP = "Auf der Weltkarte"
msg.MAP_TRACKING_OPTIONS_TITLE = "Musician"
msg.MAP_TRACKING_OPTION_ACTIVE_MUSICIANS = "Musician spielen"

--- Total RP Extended module
msg.TRPE_ITEM_NAME = "{title}"
msg.TRPE_ITEM_TOOLTIP_REQUIRES_MUSICIAN = "Benötigt Musician"
msg.TRPE_ITEM_TOOLTIP_SHEET_MUSIC = "Noten"
msg.TRPE_ITEM_USE_HINT = "Lese die Noten"
msg.TRPE_ITEM_MUSICIAN_NOT_FOUND = "Du brauchst die neuste Version von Musician um das hier zu verwenden, \ninstallierte es hier: {url}"
msg.TRPE_ITEM_NOTES = "Importiere das Lied nach Musician, um es für die Spieler in der Nähe abzuspielen.\n\nMusician herunterladen: {url}\n"

msg.TRPE_EXPORT_BUTTON = "Export"
msg.TRPE_EXPORT_WINDOW_TITLE = "Song als Total RP-Element exportieren"
msg.TRPE_EXPORT_WINDOW_LOCALE = "Artikelsprache:"
msg.TRPE_EXPORT_WINDOW_ADD_TO_BAG = "Füge zu deiner Tasche hinzu"
msg.TRPE_EXPORT_WINDOW_QUANTITY = "Menge:"
msg.TRPE_EXPORT_WINDOW_HINT_NEW = "Erstelle Noten in Total RP die du mit anderen handeln kannst!"
msg.TRPE_EXPORT_WINDOW_HINT_EXISTING = "Für dieses Lied ist bereits ein Element vorhanden, das aktualisiert wird."
msg.TRPE_EXPORT_WINDOW_CREATE_ITEM_BUTTON = "Element erstellen"
msg.TRPE_EXPORT_WINDOW_PROGRESS = "Element erstellen… {progress}%"

--- Musician instrument names
msg.INSTRUMENT_NAMES["none"] = "(Keiner)"
msg.INSTRUMENT_NAMES["accordion"] = "Akkordeon"
msg.INSTRUMENT_NAMES["bagpipe"] = "Dudelsack"
msg.INSTRUMENT_NAMES["dulcimer"] = "Dulcimer"
msg.INSTRUMENT_NAMES["piano"] = "Klavier"
msg.INSTRUMENT_NAMES["lute"] = "Laute"
msg.INSTRUMENT_NAMES["viola_da_gamba"] = "Kniegeige"
msg.INSTRUMENT_NAMES["harp"] = "Keltische Harfe"
msg.INSTRUMENT_NAMES["male_voice"] = "Männerstimme (Tenor)"
msg.INSTRUMENT_NAMES["female_voice"] = "Frauenstimme (Sopran)"
msg.INSTRUMENT_NAMES["trumpet"] = "Trompete"
msg.INSTRUMENT_NAMES["sackbut"] = "Posaune"
msg.INSTRUMENT_NAMES["war_horn"] = "Kriegshorn"
msg.INSTRUMENT_NAMES["bassoon"] = "Fagott"
msg.INSTRUMENT_NAMES["clarinet"] = "Klarinette"
msg.INSTRUMENT_NAMES["recorder"] = "Recorder"
msg.INSTRUMENT_NAMES["fiddle"] = "Geige"
msg.INSTRUMENT_NAMES["percussions"] = "Percussions (traditionell)"
msg.INSTRUMENT_NAMES["distortion_guitar"] = "verzerrte Gitarre"
msg.INSTRUMENT_NAMES["clean_guitar"] = "Normale Gitarre"
msg.INSTRUMENT_NAMES["bass_guitar"] = "Bassgitarre"
msg.INSTRUMENT_NAMES["drumkit"] = "Schlagzeug"
msg.INSTRUMENT_NAMES["war_drum"] = "Kriegstrommel"
msg.INSTRUMENT_NAMES["woodblock"] = "Holzblock"
msg.INSTRUMENT_NAMES["tambourine_shake"] = "Tamburin (geschüttelt)"

--- General MIDI instrument names
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGrandPiano] = "Akustischer Flügel"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrightAcousticPiano] = "Helles akustisches Klavier"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGrandPiano] = "Elektrischer Flügel"
msg.MIDI_INSTRUMENT_NAMES[Instrument.HonkyTonkPiano] = "Honky-Tonk-Klavier"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricPiano1] = "E-Piano 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricPiano2] = "E-Piano 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Harpsichord] = "Cembalo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Clavi] = "Clavi"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Celesta] = "Celesta"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Glockenspiel] = "Glockenspiel"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MusicBox] = "Musikbox"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Vibraphone] = "Vibraphon"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Marimba] = "Marimba"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Xylophone] = "Xylophon"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TubularBells] = "Röhrenglocken"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Dulcimer] = "Hackbrett"
msg.MIDI_INSTRUMENT_NAMES[Instrument.DrawbarOrgan] = "Deichselorgel"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PercussiveOrgan] = "Schlagorgan"
msg.MIDI_INSTRUMENT_NAMES[Instrument.RockOrgan] = "Rockorgel"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ChurchOrgan] = "Kirchenorgel"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ReedOrgan] = "Harmonium"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Accordion] = "Akkordeon"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Harmonica] = "Mundharmonika"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TangoAccordion] = "Tango Akkordeon"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGuitarNylon] = "Akustikgitarre (Nylon)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGuitarSteel] = "Akustikgitarre (Stahl)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarJazz] = "E-Gitarre (Jazz)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarClean] = "E-Gitarre (sauber)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarMuted] = "E-Gitarre (gedämpft)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OverdrivenGuitar] = "Übersteuerte Gitarre"
msg.MIDI_INSTRUMENT_NAMES[Instrument.DistortionGuitar] = "Verzerrungsgitarre"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Guitarharmonics] = "Gitarre Harmonisch"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticBass] = "Akustischer Bass"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricBassFinger] = "E-Bass (gefingert)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricBassPick] = "E-Bass (Plektron)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FretlessBass] = "Fretless Bass"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SlapBass1] = "Schlagbass 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SlapBass2] = "Schlagbass 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBass1] = "Synth Bass 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBass2] = "Synth Bass 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Violin] = "Violine"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Viola] = "Viola"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Cello] = "Cello"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Contrabass] = "Kontrabass"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TremoloStrings] = "Tremolo-Saiten"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PizzicatoStrings] = "Pizzicato-Saiten"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestralHarp] = "Orchesterharfe"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Timpani] = "Timpani"
msg.MIDI_INSTRUMENT_NAMES[Instrument.StringEnsemble1] = "Streichensemble 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.StringEnsemble2] = "Streichensemble 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthStrings1] = "Synth Strings 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthStrings2] = "Synth Strings 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ChoirAahs] = "Chor aahs"
msg.MIDI_INSTRUMENT_NAMES[Instrument.VoiceOohs] = "Stimme oohs"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthVoice] = "Synth Stimme"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestraHit] = "Orchesterhit"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Trumpet] = "Trompete"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Trombone] = "Posaune"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Tuba] = "Tuba"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MutedTrumpet] = "Gedämpfte Trompete"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FrenchHorn] = "Waldhorn"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrassSection] = "Messingteil"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBrass1] = "Synth Messing 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBrass2] = "Synth Messing 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SopranoSax] = "Sopransaxophon"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AltoSax] = "Altsaxophon"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TenorSax] = "Tenorsaxophon"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BaritoneSax] = "Baritonsaxophon"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Oboe] = "Oboe"
msg.MIDI_INSTRUMENT_NAMES[Instrument.EnglishHorn] = "Englischhorn"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Bassoon] = "Fagott"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Clarinet] = "Klarinette"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Piccolo] = "Piccolo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Flute] = "Flöte"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Recorder] = "Recorder"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PanFlute] = "Panflöte"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BlownBottle] = "Geblasene Flasche"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shakuhachi] = "Shakuhachi"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Whistle] = "Pfeifen"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Ocarina] = "Okarina"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead1Square] = "Blei 1 (Quadrat)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead2Sawtooth] = "Blei 2 (Sägezahn)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead3Calliope] = "Blei 3 (Kalliope)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead4Chiff] = "Blei 4 (Chiff)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead5Charang] = "Blei 5 (Charang)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead6Voice] = "Blei 6 (Stimme)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead7Fifths] = "Blei 7 (Fünftel)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead8BassLead] = "Lead 8 (Bass + Lead)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad1Newage] = "Pad 1 (neues Zeitalter)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad2Warm] = "Pad 2 (warm)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad3Polysynth] = "Pad 3 (Polysynthese)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad4Choir] = "Pad 4 (Chor)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad5Bowed] = "Pad 5 (gebeugt)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad6Metallic] = "Pad 6 (metallisch)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad7Halo] = "Pad 7 (halo)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad8Sweep] = "Pad 8 (Sweep)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX1Rain] = "FX 1 (Regen)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX2Soundtrack] = "FX 2 (Soundtrack)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX3Crystal] = "FX 3 (Kristall)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX4Atmosphere] = "FX 4 (Atmosphäre)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX5Brightness] = "FX 5 (Helligkeit)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX6Goblins] = "FX 6 (Goblins)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX7Echoes] = "FX 7 (Echos)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX8SciFi] = "FX 8 (Sci-Fi)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Sitar] = "Sitar"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Banjo] = "Banjo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shamisen] = "Shamisen"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Koto] = "Koto"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Kalimba] = "Kalimba"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Bagpipe] = "Sackpfeife"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Fiddle] = "Geige"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shanai] = "Shanai"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TinkleBell] = "Klingeln"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Agogo] = "Agogo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SteelDrums] = "Stahl-Trommeln"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Woodblock] = "Holzblock"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TaikoDrum] = "Taiko Trommel"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MelodicTom] = "Melodischer Tom"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthDrum] = "Synth Drum"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ReverseCymbal] = "Reverse Becken"
msg.MIDI_INSTRUMENT_NAMES[Instrument.GuitarFretNoise] = "Gitarrenbundgeräusch"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BreathNoise] = "Atemgeräusche"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Seashore] = "Strand"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BirdTweet] = "Vogel Tweet"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TelephoneRing] = "Telefon klingelt"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Helicopter] = "Hubschrauber"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Applause] = "Beifall"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Gunshot] = "Schuss"

--- General MIDI drum kit names
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_INSTRUMENT_NAMES[Instrument.StandardKit] = "Standard-Schlagzeug"
msg.MIDI_INSTRUMENT_NAMES[Instrument.RoomKit] = "Raumtrommel-Kit"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PowerKit] = "Power Drum Kit"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectronicKit] = "Elektronisches Schlagzeug"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TR808Kit] = "TR-808 Trommelmaschine"
msg.MIDI_INSTRUMENT_NAMES[Instrument.JazzKit] = "Jazz Drum Kit"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrushKit] = "Brush Drum Kit"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestraKit] = "Orchester-Schlagzeug"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SoundFXKit] = "Sound FX"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MT32Kit] = "MT-32 Schlagzeug"
msg.MIDI_INSTRUMENT_NAMES[Instrument.None] = "(Keiner)"
msg.UNKNOWN_DRUMKIT = "Unbekanntes Schlagzeug ({midi})"

--- General MIDI percussion list
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_PERCUSSION_NAMES[Percussion.Laser] = "Laser" -- MIDI key 27
msg.MIDI_PERCUSSION_NAMES[Percussion.Whip] = "Peitsche" -- MIDI key 28
msg.MIDI_PERCUSSION_NAMES[Percussion.ScratchPush] = "Scratch Push" -- MIDI key 29
msg.MIDI_PERCUSSION_NAMES[Percussion.ScratchPull] = "Kratzer ziehen" -- MIDI key 30
msg.MIDI_PERCUSSION_NAMES[Percussion.StickClick] = "Stick klicken" -- MIDI key 31
msg.MIDI_PERCUSSION_NAMES[Percussion.SquareClick] = "Quadratischer Klick" -- MIDI key 32
msg.MIDI_PERCUSSION_NAMES[Percussion.MetronomeClick] = "Metronom klicken" -- MIDI key 33
msg.MIDI_PERCUSSION_NAMES[Percussion.MetronomeBell] = "Metronomglocke" -- MIDI key 34
msg.MIDI_PERCUSSION_NAMES[Percussion.AcousticBassDrum] = "Akustische Bassdrum" -- MIDI key 35
msg.MIDI_PERCUSSION_NAMES[Percussion.BassDrum1] = "Bassdrum 1" -- MIDI key 36
msg.MIDI_PERCUSSION_NAMES[Percussion.SideStick] = "Seitenstock" -- MIDI key 37
msg.MIDI_PERCUSSION_NAMES[Percussion.AcousticSnare] = "Akustische Schlinge" -- MIDI key 38
msg.MIDI_PERCUSSION_NAMES[Percussion.HandClap] = "Hand klatschen" -- MIDI key 39
msg.MIDI_PERCUSSION_NAMES[Percussion.ElectricSnare] = "Elektrische Schlinge" -- MIDI key 40
msg.MIDI_PERCUSSION_NAMES[Percussion.LowFloorTom] = "Niederflur Tom" -- MIDI key 41
msg.MIDI_PERCUSSION_NAMES[Percussion.ClosedHiHat] = "Hi-Hat geschlossen" -- MIDI key 42
msg.MIDI_PERCUSSION_NAMES[Percussion.HighFloorTom] = "Hoher Stock Tom" -- MIDI key 43
msg.MIDI_PERCUSSION_NAMES[Percussion.PedalHiHat] = "Pedal Hi-Hat" -- MIDI key 44
msg.MIDI_PERCUSSION_NAMES[Percussion.LowTom] = "Niedriger Tom" -- MIDI key 45
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenHiHat] = "Hi-Hat öffnen" -- MIDI key 46
msg.MIDI_PERCUSSION_NAMES[Percussion.LowMidTom] = "Low-Mid-Tom" -- MIDI key 47
msg.MIDI_PERCUSSION_NAMES[Percussion.HiMidTom] = "Hi-mid tom" -- MIDI key 48
msg.MIDI_PERCUSSION_NAMES[Percussion.CrashCymbal1] = "Crash-Becken 1" -- MIDI key 49
msg.MIDI_PERCUSSION_NAMES[Percussion.HighTom] = "Hoher Tom" -- MIDI key 50
msg.MIDI_PERCUSSION_NAMES[Percussion.RideCymbal1] = "Becken 1 fahren" -- MIDI key 51
msg.MIDI_PERCUSSION_NAMES[Percussion.ChineseCymbal] = "Chinesisches Becken" -- MIDI key 52
msg.MIDI_PERCUSSION_NAMES[Percussion.RideBell] = "Glocke fahren" -- MIDI key 53
msg.MIDI_PERCUSSION_NAMES[Percussion.Tambourine] = "Tambourin" -- MIDI key 54
msg.MIDI_PERCUSSION_NAMES[Percussion.SplashCymbal] = "Splash Becken" -- MIDI key 55
msg.MIDI_PERCUSSION_NAMES[Percussion.Cowbell] = "Kuhglocke" -- MIDI key 56
msg.MIDI_PERCUSSION_NAMES[Percussion.CrashCymbal2] = "Crash-Becken 2" -- MIDI key 57
msg.MIDI_PERCUSSION_NAMES[Percussion.Vibraslap] = "Vibraslap" -- MIDI key 58
msg.MIDI_PERCUSSION_NAMES[Percussion.RideCymbal2] = "Becken 2 fahren" -- MIDI key 59
msg.MIDI_PERCUSSION_NAMES[Percussion.HiBongo] = "Hallo Bongo" -- MIDI key 60
msg.MIDI_PERCUSSION_NAMES[Percussion.LowBongo] = "Niedriger Bongo" -- MIDI key 61
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteHiConga] = "Stumm Hallo Conga" -- MIDI key 62
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenHiConga] = "Öffne hi conga" -- MIDI key 63
msg.MIDI_PERCUSSION_NAMES[Percussion.LowConga] = "Niedrige Conga" -- MIDI key 64
msg.MIDI_PERCUSSION_NAMES[Percussion.HighTimbale] = "Hoher Timbale" -- MIDI key 65
msg.MIDI_PERCUSSION_NAMES[Percussion.LowTimbale] = "Niedriger Timbale" -- MIDI key 66
msg.MIDI_PERCUSSION_NAMES[Percussion.HighAgogo] = "Hohe Agogo" -- MIDI key 67
msg.MIDI_PERCUSSION_NAMES[Percussion.LowAgogo] = "Niedrige Agogo" -- MIDI key 68
msg.MIDI_PERCUSSION_NAMES[Percussion.Cabasa] = "Cabasa" -- MIDI key 69
msg.MIDI_PERCUSSION_NAMES[Percussion.Maracas] = "Maracas" -- MIDI key 70
msg.MIDI_PERCUSSION_NAMES[Percussion.ShortWhistle] = "Kurzer Pfiff" -- MIDI key 71
msg.MIDI_PERCUSSION_NAMES[Percussion.LongWhistle] = "Lange Pfeife" -- MIDI key 72
msg.MIDI_PERCUSSION_NAMES[Percussion.ShortGuiro] = "Kurzer Guiro" -- MIDI key 73
msg.MIDI_PERCUSSION_NAMES[Percussion.LongGuiro] = "Langer Guiro" -- MIDI key 74
msg.MIDI_PERCUSSION_NAMES[Percussion.Claves] = "Claves" -- MIDI key 75
msg.MIDI_PERCUSSION_NAMES[Percussion.HiWoodBlock] = "Hallo Holzblock" -- MIDI key 76
msg.MIDI_PERCUSSION_NAMES[Percussion.LowWoodBlock] = "Niedriger Holzblock" -- MIDI key 77
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteCuica] = "Stumme Cuica" -- MIDI key 78
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenCuica] = "Öffnen Sie cuica" -- MIDI key 79
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteTriangle] = "Dreieck stumm schalten" -- MIDI key 80
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenTriangle] = "Dreieck öffnen" -- MIDI key 81
msg.MIDI_PERCUSSION_NAMES[Percussion.Shaker] = "Shaker" -- MIDI key 82
msg.MIDI_PERCUSSION_NAMES[Percussion.SleighBell] = "Schlittenglocke" -- MIDI key 83
msg.MIDI_PERCUSSION_NAMES[Percussion.BellTree] = "Glockenbaum" -- MIDI key 84
msg.MIDI_PERCUSSION_NAMES[Percussion.Castanets] = "Kastagnetten" -- MIDI key 85
msg.MIDI_PERCUSSION_NAMES[Percussion.SurduDeadStroke] = "Surdu toter Schlaganfall" -- MIDI key 86
msg.MIDI_PERCUSSION_NAMES[Percussion.Surdu] = "Surdu" -- MIDI key 87
msg.MIDI_PERCUSSION_NAMES[Percussion.SnareDrumRod] = "Snare Drum Rod" -- MIDI key 88
msg.MIDI_PERCUSSION_NAMES[Percussion.OceanDrum] = "Ozeantrommel" -- MIDI key 89
msg.MIDI_PERCUSSION_NAMES[Percussion.SnareDrumBrush] = "Snare Drum Brush" -- MIDI key 90