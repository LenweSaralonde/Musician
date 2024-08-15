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

local msg = Musician.InitLocale("it", "Italiano", "itIT")

local Instrument = Musician.MIDI_INSTRUMENTS
local Percussion = Musician.MIDI_PERCUSSIONS
local KEY = Musician.KEYBOARD_KEY

------------------------------------------------------------------------
---------------- ↑↑↑ DO NOT EDIT THE LINES ABOVE ! ↑↑↑  ----------------
------------------------------------------------------------------------

--- Main frame controls
msg.PLAY = "Giocare"
msg.STOP = "Fermare"
msg.PAUSE = "Pausa"
msg.TEST_SONG = "Anteprima"
msg.STOP_TEST = "Fermare"
msg.CLEAR = "Chiaro"
msg.SELECT_ALL = "Seleziona tutto"
msg.EDIT = "Brani"
msg.MUTE = "Mute"
msg.UNMUTE = "Riattiva"

--- Minimap button menu
msg.MENU_TITLE = "Musician"
msg.MENU_IMPORT_SONG = "Importa e riproduci una canzone"
msg.MENU_PLAY = "Giocare"
msg.MENU_STOP = "Fermare"
msg.MENU_PLAY_PREVIEW = "Anteprima"
msg.MENU_STOP_PREVIEW = "Interrompi l'anteprima"
msg.MENU_LIVE_PLAY = "Gioco dal vivo"
msg.MENU_SHOW_KEYBOARD = "Tastiera aperta"
msg.MENU_SETTINGS = "impostazioni"
msg.MENU_OPTIONS = "Opzioni"
msg.MENU_ABOUT = "Di"

--- Chat commands
msg.COMMAND_LIST_TITLE = "Comandi di Musician:"
msg.COMMAND_SHOW = "Mostra la finestra di importazione del brano"
msg.COMMAND_PREVIEW_PLAY = "Avvia o interrompi l'anteprima del brano"
msg.COMMAND_PREVIEW_STOP = "Interrompi l'anteprima del brano"
msg.COMMAND_PLAY = "Riproduci o interrompi il brano"
msg.COMMAND_STOP = "Smetti di suonare la canzone"
msg.COMMAND_MUTE = "Disattiva tutta la musica"
msg.COMMAND_UNMUTE = "Riattiva la musica"
msg.COMMAND_SONG_EDITOR = "Apri l'editor di brani"
msg.COMMAND_LIVE_KEYBOARD = "Apri la tastiera live"
msg.COMMAND_CONFIGURE_KEYBOARD = "Configura la tastiera"
msg.COMMAND_LIVE_DEMO = "Modalità demo della tastiera"
msg.COMMAND_LIVE_DEMO_PARAMS = "{** <traccia superiore #> ** ** <traccia inferiore #> ** || ** off **}"
msg.COMMAND_HELP = "Mostra questo messaggio di aiuto"
msg.ERR_COMMAND_UNKNOWN = "Comando \"{command}\" sconosciuto. Digita {help} per ottenere l'elenco dei comandi."

--- Add-on options
msg.OPTIONS_TITLE = "Musician"
msg.OPTIONS_SUB_TEXT = "Unisciti al server Discord per il supporto! {url}"
msg.OPTIONS_CATEGORY_EMOTE = "Emote"
msg.OPTIONS_ENABLE_EMOTE_LABEL = "Invia un'emote di testo ai giocatori che non hanno Musician durante la riproduzione di una canzone."
msg.OPTIONS_ENABLE_EMOTE_PROMO_LABEL = "Includi un breve testo che li inviti a installarlo in modo che possano ascoltare la musica che suoni."
msg.OPTIONS_EMOTE_HINT = "Un'emote di testo viene mostrata ai giocatori che non hanno Musician quando riproduci una canzone. Puoi disabilitarlo nelle [opzioni]."
msg.OPTIONS_INTEGRATION_OPTIONS_TITLE = "Opzioni di integrazione nel gioco"
msg.OPTIONS_AUTO_MUTE_GAME_MUSIC_LABEL = "Disattiva la musica di gioco durante la riproduzione di un brano."
msg.OPTIONS_MUTE_INSTRUMENT_TOYS_LABEL = "Musica muta da giocattoli strumentali. {icons}"
msg.OPTIONS_AUDIO_CHANNELS_TITLE = "Canali audio"
msg.OPTIONS_AUDIO_CHANNELS_HINT = "Seleziona più canali audio per aumentare il numero massimo di note che Musician può suonare contemporaneamente."
msg.OPTIONS_AUDIO_CHANNELS_CHANNEL_POLYPHONY = "{channel} ({polyphony})"
msg.OPTIONS_AUDIO_CHANNELS_TOTAL_POLYPHONY = "Polifonia massima totale: {polyphony}"
msg.OPTIONS_AUDIO_CHANNELS_AUTO_ADJUST_CONFIG = "Ottimizza automaticamente le impostazioni audio quando sono selezionati più canali audio."
msg.OPTIONS_AUDIO_CACHE_SIZE_FOR_MUSICIAN = "Consigliato per Musician (%d MB)"
msg.OPTIONS_CATEGORY_SHORTCUTS = "Scorciatoie"
msg.OPTIONS_SHORTCUT_MINIMAP = "Pulsante Minimappa"
msg.OPTIONS_SHORTCUT_ADDON_MENU = "Menu Minimappa"
msg.OPTIONS_QUICK_PRELOADING_TITLE = "Precaricamento rapido"
msg.OPTIONS_QUICK_PRELOADING_TEXT = "Abilita il precarico rapido degli strumenti all'avvio a freddo."
msg.OPTIONS_CATEGORY_NAMEPLATES = "Targhette e animazioni"
msg.OPTIONS_CATEGORY_NAMEPLATES_SUB_TEXT = "Abilita le targhette per vedere le animazioni dei personaggi che suonano musica e scoprire\nchi può sentirti a colpo d'occhio."
msg.OPTIONS_ENABLE_NAMEPLATES = "Abilita targhette e animazioni."
msg.OPTIONS_SHOW_NAMEPLATE_ICON = "Mostra un'icona {icon} accanto al nome dei giocatori che hanno anche Musician."
msg.OPTIONS_HIDE_HEALTH_BARS = "Nascondi le barre della salute quando non sono in combattimento."
msg.OPTIONS_HIDE_NPC_NAMEPLATES = "Nascondi le targhette dei PNG."
msg.OPTIONS_CINEMATIC_MODE = "Mostra le animazioni quando l'interfaccia utente è nascosta con {binding}."
msg.OPTIONS_CINEMATIC_MODE_NO_BINDING = "Mostra le animazioni quando l'interfaccia utente è nascosta."
msg.OPTIONS_NAMEPLATES_CINEMATIC_MODE = "Mostra le targhette quando l'interfaccia utente è nascosta."
msg.OPTIONS_NAMEPLATES_OPTION_DISABLED_3RD_PARTY = "Questa opzione non ha alcun effetto perché è installato un componente aggiuntivo per la personalizzazione delle targhette."
msg.OPTIONS_TRP3 = "RP totale 3"
msg.OPTIONS_TRP3_MAP_SCAN = "Mostra i giocatori che hanno Musician sulla scansione della mappa con un'icona {icon}."
msg.OPTIONS_CROSS_RP_TITLE = "Cross RP"
msg.OPTIONS_CROSS_RP_SUB_TEXT = "Installa il componente aggiuntivo Cross RP di Tammya-MoonGuard per attivare\nmusica tra fazioni e reami!"
msg.OPTIONS_CROSS_RP_SUB_TEXT_NO_GATEWAY = "Al momento non è disponibile alcun nodo Cross RP.\nSii paziente…"
msg.OPTIONS_CROSS_RP_SUB_TEXT_ACTIVE = "La comunicazione Cross RP è attiva per le seguenti posizioni:\n\n{bands}"

--- Tips and Tricks
msg.TIPS_AND_TRICKS_ENABLE = "Mostra suggerimenti e trucchi all'avvio."

msg.TIPS_AND_TRICKS_NAMEPLATES_TITLE = "Animazioni e targhette"
msg.TIPS_AND_TRICKS_NAMEPLATES_TEXT = "Un'animazione speciale è visibile sui personaggi che suonano la musica quando le targhette sono abilitate.\n\nUn'icona {icon} indica anche chi ha Musician e può sentirti.\n\nAbilitare le targhette e le animazioni adesso?"
msg.TIPS_AND_TRICKS_NAMEPLATES_OK = "Abilita targhette e animazioni"
msg.TIPS_AND_TRICKS_NAMEPLATES_CANCEL = "Dopo"

msg.TIPS_AND_TRICKS_CROSS_RP_TITLE = "Musica per fazioni incrociate con Cross RP"
msg.TIPS_AND_TRICKS_CROSS_RP_TEXT = "Installa il componente aggiuntivo Cross RP di Tammya-MoonGuard per attivare\nmusica tra fazioni e reami!"
msg.TIPS_AND_TRICKS_CROSS_RP_OK = "ok"

--- Welcome messages
msg.STARTUP = "Benvenuto in Musician v {version}."
msg.PLAYER_COUNT_ONLINE = "Ci sono {count} altri fan della musica in giro!"
msg.PLAYER_COUNT_ONLINE_ONE = "C'è un altro appassionato di musica in giro!"
msg.PLAYER_COUNT_ONLINE_NONE = "Non ci sono ancora altri fan della musica in giro."

--- New version notifications
msg.NEW_VERSION = "È stata rilasciata una nuova versione di Musician! Scarica l'aggiornamento da {url}."
msg.NEW_PROTOCOL_VERSION = "La tua versione di Musician è obsoleta e non funziona più.\nScarica l'aggiornamento da\n{url}"

-- Module warnings
msg.ERR_INCOMPATIBLE_MODULE_API = "Il modulo Musician per {module} non può essere avviato perché {module} è incompatibile. Prova ad aggiornare Musician e {module}."

-- Loading screen
msg.LOADING_SCREEN_MESSAGE = "Musician sta precaricando i campioni dello strumento nella memoria cache…"
msg.LOADING_SCREEN_CLOSE_TOOLTIP = "Chiudi e continua il precaricamento in background."

--- Player tooltips
msg.PLAYER_TOOLTIP = "Musician"
msg.PLAYER_TOOLTIP_VERSION = "{name} v {version}"
msg.PLAYER_TOOLTIP_VERSION_OUTDATED = " (Obsoleto)"
msg.PLAYER_TOOLTIP_VERSION_INCOMPATIBLE = " (INCOMPATIBILE)"
msg.PLAYER_TOOLTIP_PRELOADING = "Precaricamento dei suoni… ({progress})"

--- URL hyperlinks tooltip
msg.TOOLTIP_COPY_URL = "Premi {shortcut} per copiare."

--- Song import
msg.INVALID_MUSIC_CODE = "Codice musicale non valido."
msg.PLAY_A_SONG = "Suonare una canzone"
msg.IMPORT_A_SONG = "Importa una canzone"
msg.PASTE_MUSIC_CODE = "Importa la tua canzone in formato MIDI su:\n{url}\n\nquindi incolla il codice musicale qui ({shortcut})…"
msg.SONG_IMPORTED = "Canzone caricata: {title}."

--- Play as a band
msg.PLAY_IN_BAND = "Suona come una band"
msg.PLAY_IN_BAND_HINT = "Clicca qui quando sei pronto per suonare questa canzone con la tua band."
msg.PLAY_IN_BAND_READY_PLAYERS = "Membri della band pronti:"
msg.EMOTE_PLAYER_IS_READY = "è pronto per suonare come band."
msg.EMOTE_PLAYER_IS_NOT_READY = "non è più pronto per suonare come band."
msg.EMOTE_PLAY_IN_BAND_START = "ha iniziato a suonare la band."
msg.EMOTE_PLAY_IN_BAND_STOP = "ha smesso di suonare la band."

--- Play as a band (live)
msg.LIVE_SYNC = "Suona dal vivo come band"
msg.LIVE_SYNC_HINT = "Fare clic qui per attivare la sincronizzazione della banda."
msg.SYNCED_PLAYERS = "Membri della band dal vivo:"
msg.EMOTE_PLAYER_LIVE_SYNC_ENABLED = "sta suonando con te."
msg.EMOTE_PLAYER_LIVE_SYNC_DISABLED = "ha smesso di riprodurre musica con te."

--- Song editor frame
msg.SONG_EDITOR = "Editor di canzoni"
msg.MARKER_FROM = "Da"
msg.MARKER_TO = "Per"
msg.POSITION = "Posizione"
msg.TRACK_NUMBER = "Traccia n. {track}"
msg.CHANNEL_NUMBER_SHORT = "Ch. {channel}"
msg.JUMP_PREV = "Indietro 10s"
msg.JUMP_NEXT = "Avanti di 10 secondi"
msg.GO_TO_START = "Vai all'inizio"
msg.GO_TO_END = "Vai alla fine"
msg.SET_CROP_FROM = "Imposta il punto di partenza"
msg.SET_CROP_TO = "Imposta punto finale"
msg.SYNCHRONIZE_TRACKS = "Sincronizza le impostazioni della traccia con la canzone corrente"
msg.MUTE_TRACK = "Mute"
msg.SOLO_TRACK = "Assolo"
msg.ACCENT_TRACK = "Enfatizzare"
msg.TRANSPOSE_TRACK = "Trasposizione (ottava)"
msg.CHANGE_TRACK_INSTRUMENT = "Cambia strumento"
msg.HEADER_NUMBER = "#"
msg.HEADER_OCTAVE = "Ottava"
msg.HEADER_INSTRUMENT = "Strumento"
msg.HEADER_ACCENT = "x2"

--- Configure live keyboard frame
msg.SHOULD_CONFIGURE_KEYBOARD = "Devi configurare la tastiera prima di suonare."
msg.CONFIGURE_KEYBOARD = "Configura la tastiera"
msg.CONFIGURE_KEYBOARD_HINT = "Fare clic su una chiave per impostare…"
msg.CONFIGURE_KEYBOARD_HINT_COMPLETE = "La configurazione della tastiera è completa.\nOra puoi salvare le modifiche e iniziare a riprodurre musica!"
msg.CONFIGURE_KEYBOARD_START_OVER = "Ricominciare"
msg.CONFIGURE_KEYBOARD_SAVE = "Salva configurazione"
msg.PRESS_KEY_BINDING = "Premere il tasto # {col} nella riga # {row}."
msg.KEY_CAN_BE_EMPTY = "Questa chiave è facoltativa e può essere vuota."
msg.KEY_IS_MERGEABLE = "Questo tasto potrebbe essere lo stesso del tasto {key} sulla tastiera: {action}"
msg.KEY_CAN_BE_MERGED = "in questo caso, basta premere il tasto {key}."
msg.KEY_CANNOT_BE_MERGED = "in questo caso, ignoralo e procedi alla chiave successiva."
msg.NEXT_KEY = "Chiave successiva"
msg.CLEAR_KEY = "Chiaro chiave"

--- About frame
msg.ABOUT_TITLE = "Musician"
msg.ABOUT_VERSION = "versione {version}"
msg.ABOUT_AUTHOR = "Di LenweSaralonde - {url}"
msg.ABOUT_LICENSE = "Rilasciato sotto GNU General Public License v3.0"
msg.ABOUT_DISCORD = "Discordia: {url}"
msg.ABOUT_SUPPORT = "Ti piace Musician? Condividilo con tutti!"
msg.ABOUT_PATREON = "Diventa un mecenate: {url}"
msg.ABOUT_PAYPAL = "Dona: {url}"
msg.ABOUT_SUPPORTERS = "Un ringraziamento speciale ai sostenitori del progetto <3"
msg.ABOUT_LOCALIZATION_TEAM = "Team di traduzione:"
msg.ABOUT_CONTRIBUTE_TO_LOCALIZATION = "Aiutaci a tradurre Musician nella tua lingua!\n{url}"

--- Fixed PC keyboard key names
msg.FIXED_KEY_NAMES[KEY.Backspace] = "Indietro"
msg.FIXED_KEY_NAMES[KEY.Tab] = "Tab"
msg.FIXED_KEY_NAMES[KEY.CapsLock] = "Blocco maiuscole"
msg.FIXED_KEY_NAMES[KEY.Enter] = "accedere"
msg.FIXED_KEY_NAMES[KEY.ShiftLeft] = "Cambio"
msg.FIXED_KEY_NAMES[KEY.ShiftRight] = "Cambio"
msg.FIXED_KEY_NAMES[KEY.ControlLeft] = "Ctrl"
msg.FIXED_KEY_NAMES[KEY.MetaLeft] = "Meta"
msg.FIXED_KEY_NAMES[KEY.AltLeft] = "Alt"
msg.FIXED_KEY_NAMES[KEY.Space] = "Spazio"
msg.FIXED_KEY_NAMES[KEY.AltRight] = "Alt"
msg.FIXED_KEY_NAMES[KEY.MetaRight] = "Meta"
msg.FIXED_KEY_NAMES[KEY.ContextMenu] = "Menù"
msg.FIXED_KEY_NAMES[KEY.ControlRight] = "Ctrl"
msg.FIXED_KEY_NAMES[KEY.Delete] = "Elimina"

--- Live keyboard layouts, based on musical modes
msg.KEYBOARD_LAYOUTS["Piano"] = "Pianoforte"
msg.KEYBOARD_LAYOUTS["Chromatic"] = "Cromatico"
msg.KEYBOARD_LAYOUTS["Modes"] = "Modalità"
msg.KEYBOARD_LAYOUTS["Ionian"] = "Ionico"
msg.KEYBOARD_LAYOUTS["Dorian"] = "Dorian"
msg.KEYBOARD_LAYOUTS["Phrygian"] = "Frigio"
msg.KEYBOARD_LAYOUTS["Lydian"] = "Lydian"
msg.KEYBOARD_LAYOUTS["Mixolydian"] = "Mixolydian"
msg.KEYBOARD_LAYOUTS["Aeolian"] = "Eolie"
msg.KEYBOARD_LAYOUTS["Locrian"] = "Locrian"
msg.KEYBOARD_LAYOUTS["minor Harmonic"] = "armonica minore"
msg.KEYBOARD_LAYOUTS["minor Melodic"] = "minore Melodic"
msg.KEYBOARD_LAYOUTS["Blues scales"] = "Scale blues"
msg.KEYBOARD_LAYOUTS["Major Blues"] = "Major Blues"
msg.KEYBOARD_LAYOUTS["minor Blues"] = "blues minore"
msg.KEYBOARD_LAYOUTS["Diminished scales"] = "Scale diminuite"
msg.KEYBOARD_LAYOUTS["Diminished"] = "Diminuito"
msg.KEYBOARD_LAYOUTS["Complement Diminished"] = "Complemento diminuito"
msg.KEYBOARD_LAYOUTS["Pentatonic scales"] = "Scale pentatoniche"
msg.KEYBOARD_LAYOUTS["Major Pentatonic"] = "Pentatonica maggiore"
msg.KEYBOARD_LAYOUTS["minor Pentatonic"] = "pentatonica minore"
msg.KEYBOARD_LAYOUTS["World scales"] = "Bilance mondiali"
msg.KEYBOARD_LAYOUTS["Raga 1"] = "Raga 1"
msg.KEYBOARD_LAYOUTS["Raga 2"] = "Raga 2"
msg.KEYBOARD_LAYOUTS["Raga 3"] = "Raga 3"
msg.KEYBOARD_LAYOUTS["Arabic"] = "Arabo"
msg.KEYBOARD_LAYOUTS["Spanish"] = "spagnolo"
msg.KEYBOARD_LAYOUTS["Gypsy"] = "Zingara"
msg.KEYBOARD_LAYOUTS["Egyptian"] = "egiziano"
msg.KEYBOARD_LAYOUTS["Hawaiian"] = "hawaiano"
msg.KEYBOARD_LAYOUTS["Bali Pelog"] = "Bali Pelog"
msg.KEYBOARD_LAYOUTS["Japanese"] = "giapponese"
msg.KEYBOARD_LAYOUTS["Ryukyu"] = "Ryukyu"
msg.KEYBOARD_LAYOUTS["Chinese"] = "Cinese"
msg.KEYBOARD_LAYOUTS["Miscellaneous scales"] = "Scale varie"
msg.KEYBOARD_LAYOUTS["Bass Line"] = "Linea di basso"
msg.KEYBOARD_LAYOUTS["Wholetone"] = "Wholetone"
msg.KEYBOARD_LAYOUTS["minor 3rd"] = "terza minore"
msg.KEYBOARD_LAYOUTS["Major 3rd"] = "Terza maggiore"
msg.KEYBOARD_LAYOUTS["4th"] = "4 °"
msg.KEYBOARD_LAYOUTS["5th"] = "5 °"
msg.KEYBOARD_LAYOUTS["Octave"] = "Ottava"

--- Live keyboard layout types
msg.HORIZONTAL_LAYOUT = "Orizzontale"
msg.VERTICAL_LAYOUT = "Verticale"

--- Live keyboard frame
msg.LIVE_SONG_NAME = "Canzone dal vivo"
msg.SOLO_MODE = "Modalità Solo"
msg.LIVE_MODE = "Modalità live"
msg.LIVE_MODE_DISABLED = "La modalità live è disabilitata durante la riproduzione."
msg.ENABLE_SOLO_MODE = "Abilita la modalità Solo (giochi per te stesso)"
msg.ENABLE_LIVE_MODE = "Abilita la modalità live (giochi per tutti)"
msg.PLAY_LIVE = "Suona dal vivo"
msg.PLAY_SOLO = "Gioca da solo"
msg.SHOW_KEYBOARD = "Mostra tastiera"
msg.HIDE_KEYBOARD = "Nascondi tastiera"
msg.KEYBOARD_LAYOUT = "Modalità tastiera e scala"
msg.CHANGE_KEYBOARD_LAYOUT = "Cambia il layout della tastiera"
msg.BASE_KEY = "Chiave di base"
msg.CHANGE_BASE_KEY = "Chiave di base"
msg.CHANGE_LOWER_INSTRUMENT = "Cambia lo strumento inferiore"
msg.CHANGE_UPPER_INSTRUMENT = "Cambia strumento superiore"
msg.LOWER_INSTRUMENT_MAPPED_TO_CHANNEL = "Strumento inferiore (traccia n. {track})"
msg.UPPER_INSTRUMENT_MAPPED_TO_CHANNEL = "Strumento superiore (traccia n. {track})"
msg.SUSTAIN_KEY = "Sostenere"
msg.POWER_CHORDS = "Accordi di potere"
msg.PROGRAM_BUTTON = "P {num}"
msg.EMPTY_PROGRAM = "Programma vuoto"
msg.LOAD_PROGRAM_NUM = "Carica il programma n. {num} ({key})"
msg.SAVE_PROGRAM_NUM = "Salva nel programma n. {num} ({key})"
msg.DELETE_PROGRAM_NUM = "Cancella programma n. {num} ({key})"
msg.WRITE_PROGRAM = "Salva programma ({key})"
msg.DELETE_PROGRAM = "Elimina programma ({key})"
msg.PROGRAM_SAVED = "Programma n. {num} salvato."
msg.PROGRAM_DELETED = "Programma n. {num} cancellato."
msg.DEMO_MODE_ENABLED = "Modalità demo della tastiera abilitata:\n{mapping}"
msg.DEMO_MODE_MAPPING = "{layer} → Traccia n. {track}"
msg.DEMO_MODE_DISABLED = "Modalità demo della tastiera disabilitata."

--- Live keyboard layers
msg.LAYERS[Musician.KEYBOARD_LAYER.UPPER] = "Superiore"
msg.LAYERS[Musician.KEYBOARD_LAYER.LOWER] = "Inferiore"

--- Chat emotes
msg.EMOTE_PLAYING_MUSIC = "sta suonando una canzone."
msg.EMOTE_PROMO = "(Scarica il componente aggiuntivo \"Musician\" per ascoltare)"
msg.EMOTE_SONG_NOT_LOADED = "(Il brano non può essere riprodotto perché {player} sta utilizzando una versione incompatibile.)"
msg.EMOTE_PLAYER_OTHER_REALM = "(Questo giocatore è su un altro regno.)"
msg.EMOTE_PLAYER_OTHER_FACTION = "(Questo giocatore è di un'altra fazione.)"

--- Minimap button tooltips
msg.TOOLTIP_LEFT_CLICK = "** Clic sinistro **: {action}"
msg.TOOLTIP_RIGHT_CLICK = "** Clic destro **: {action}"
msg.TOOLTIP_DRAG_AND_DROP = "** Trascina e rilascia ** per spostarti"
msg.TOOLTIP_ISMUTED = "(disattivato)"
msg.TOOLTIP_ACTION_OPEN_MENU = "Apri il menu principale"
msg.TOOLTIP_ACTION_MUTE = "Disattiva tutta la musica"
msg.TOOLTIP_ACTION_UNMUTE = "Riattiva la musica"

--- Player menu options
msg.PLAYER_MENU_TITLE = "Musica"
msg.PLAYER_MENU_STOP_CURRENT_SONG = "Interrompi il brano corrente"
msg.PLAYER_MENU_MUTE = "Mute"
msg.PLAYER_MENU_UNMUTE = "Riattiva"

--- Player actions feedback
msg.PLAYER_IS_MUTED = "{icon} {player} è ora disattivato."
msg.PLAYER_IS_UNMUTED = "{icon} {player} è ora riattivato."

--- Song links
msg.LINKS_PREFIX = "Musica"
msg.LINKS_FORMAT = "{prefix}: {title}"
msg.LINKS_LINK_BUTTON = "Link"
msg.LINKS_CHAT_BUBBLE = "\"{note} {title}\""

--- Song link export frame
msg.LINK_EXPORT_WINDOW_TITLE = "Crea link al brano"
msg.LINK_EXPORT_WINDOW_SONG_TITLE_LABEL = "Titolo Canzone:"
msg.LINK_EXPORT_WINDOW_HINT = "Il collegamento rimarrà attivo fino a quando non ti disconnetti o ricarichi l'interfaccia."
msg.LINK_EXPORT_WINDOW_PROGRESS = "Generazione collegamento in corso… {progress}%"
msg.LINK_EXPORT_WINDOW_POST_BUTTON = "Pubblica il link nella chat"

--- Song link import frame
msg.LINK_IMPORT_WINDOW_TITLE = "Importa brano da {player}:"
msg.LINK_IMPORT_WINDOW_HINT = "Fare clic su \"Importa\" per avviare l'importazione della canzone in Musician."
msg.LINK_IMPORT_WINDOW_IMPORT_BUTTON = "Importa brano"
msg.LINK_IMPORT_WINDOW_CANCEL_IMPORT_BUTTON = "Annulla importazione"
msg.LINK_IMPORT_WINDOW_REQUESTING = "Richiesta del brano da {player}…"
msg.LINK_IMPORT_WINDOW_PROGRESS = "Importazione in corso… {progress}%"
msg.LINK_IMPORT_WINDOW_SELECT_ACCOUNT = "Seleziona il personaggio da cui recuperare la canzone:"

--- Song links errors
msg.LINKS_ERROR.notFound = "Il brano \"{title}\" non è disponibile da {player}."
msg.LINKS_ERROR.alreadySending = "Una canzone ti è già stata inviata da {player}. Riprova tra qualche secondo."
msg.LINKS_ERROR.alreadyRequested = "Una canzone è già stata richiesta da {player}."
msg.LINKS_ERROR.timeout = "{player} non ha risposto."
msg.LINKS_ERROR.offline = "{player} non è connesso a World of Warcraft."
msg.LINKS_ERROR.importingFailed = "Impossibile importare il brano {title} da {player}."

--- Map tracking options
msg.MAP_OPTIONS_TITLE = "Mappa"
msg.MAP_OPTIONS_SUB_TEXT = "Mostra musicisti nelle vicinanze in riproduzione:"
msg.MAP_OPTIONS_MINI_MAP = "Sulla minimappa"
msg.MAP_OPTIONS_WORLD_MAP = "Sulla mappa del mondo"
msg.MAP_TRACKING_OPTIONS_TITLE = "Musician"
msg.MAP_TRACKING_OPTION_ACTIVE_MUSICIANS = "Musicisti che suonano"

--- Total RP Extended module
msg.TRPE_ITEM_NAME = "{title}"
msg.TRPE_ITEM_TOOLTIP_REQUIRES_MUSICIAN = "Richiede Musician"
msg.TRPE_ITEM_TOOLTIP_SHEET_MUSIC = "Spartito"
msg.TRPE_ITEM_USE_HINT = "Leggi lo spartito"
msg.TRPE_ITEM_MUSICIAN_NOT_FOUND = "È necessario installare l'ultima versione del componente aggiuntivo \"Musician\" per poter utilizzare questo elemento.\nScaricalo da {url}"
msg.TRPE_ITEM_NOTES = "Importa la canzone in Musician per riprodurla per i giocatori vicini.\n\nScarica Musician: {url}\n"

msg.TRPE_EXPORT_BUTTON = "Esportare"
msg.TRPE_EXPORT_WINDOW_TITLE = "Esporta il brano come elemento Total RP"
msg.TRPE_EXPORT_WINDOW_LOCALE = "Lingua articolo:"
msg.TRPE_EXPORT_WINDOW_ADD_TO_BAG = "Aggiungi alla tua borsa"
msg.TRPE_EXPORT_WINDOW_QUANTITY = "Quantità:"
msg.TRPE_EXPORT_WINDOW_HINT_NEW = "Crea un elemento spartito in Total RP che può essere scambiato con altri giocatori."
msg.TRPE_EXPORT_WINDOW_HINT_EXISTING = "Esiste già un elemento per questa canzone, verrà aggiornato."
msg.TRPE_EXPORT_WINDOW_CREATE_ITEM_BUTTON = "Crea oggetto"
msg.TRPE_EXPORT_WINDOW_PROGRESS = "Creazione elemento… {progress}%"

--- Musician instrument names
msg.INSTRUMENT_NAMES["none"] = "(Nessuna)"
msg.INSTRUMENT_NAMES["accordion"] = "Fisarmonica"
msg.INSTRUMENT_NAMES["bagpipe"] = "Cornamusa"
msg.INSTRUMENT_NAMES["dulcimer"] = "Dulcimer (martellato)"
msg.INSTRUMENT_NAMES["piano"] = "Pianoforte"
msg.INSTRUMENT_NAMES["lute"] = "Liuto"
msg.INSTRUMENT_NAMES["viola_da_gamba"] = "Viola da gamba"
msg.INSTRUMENT_NAMES["harp"] = "Arpa celtica"
msg.INSTRUMENT_NAMES["male_voice"] = "Voce maschile (tenore)"
msg.INSTRUMENT_NAMES["female_voice"] = "Voce femminile (soprano)"
msg.INSTRUMENT_NAMES["trumpet"] = "Tromba"
msg.INSTRUMENT_NAMES["sackbut"] = "Sackbut"
msg.INSTRUMENT_NAMES["war_horn"] = "Corno da guerra"
msg.INSTRUMENT_NAMES["bassoon"] = "Fagotto"
msg.INSTRUMENT_NAMES["clarinet"] = "Clarinetto"
msg.INSTRUMENT_NAMES["recorder"] = "Registratore"
msg.INSTRUMENT_NAMES["fiddle"] = "Violino"
msg.INSTRUMENT_NAMES["percussions"] = "Percussioni (tradizionali)"
msg.INSTRUMENT_NAMES["distortion_guitar"] = "Chitarra di distorsione"
msg.INSTRUMENT_NAMES["clean_guitar"] = "Chitarra pulita"
msg.INSTRUMENT_NAMES["bass_guitar"] = "Basso"
msg.INSTRUMENT_NAMES["drumkit"] = "Batteria"
msg.INSTRUMENT_NAMES["war_drum"] = "Tamburo di guerra"
msg.INSTRUMENT_NAMES["woodblock"] = "Blocco di legno"
msg.INSTRUMENT_NAMES["tambourine_shake"] = "Tamburello (agitato)"

--- General MIDI instrument names
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGrandPiano] = "Pianoforte a coda acustico"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrightAcousticPiano] = "Piano acustico luminoso"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGrandPiano] = "Pianoforte a coda elettrico"
msg.MIDI_INSTRUMENT_NAMES[Instrument.HonkyTonkPiano] = "Piano Honky-tonk"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricPiano1] = "Piano elettrico 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricPiano2] = "Piano elettrico 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Harpsichord] = "Clavicembalo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Clavi] = "Clavi"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Celesta] = "Celesta"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Glockenspiel] = "Glockenspiel"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MusicBox] = "Carillon"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Vibraphone] = "Vibrafono"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Marimba] = "Marimba"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Xylophone] = "Xilofono"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TubularBells] = "Campane tubolari"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Dulcimer] = "Dulcimer"
msg.MIDI_INSTRUMENT_NAMES[Instrument.DrawbarOrgan] = "Organo a timone"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PercussiveOrgan] = "Organo a percussione"
msg.MIDI_INSTRUMENT_NAMES[Instrument.RockOrgan] = "Organo rock"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ChurchOrgan] = "Organo da chiesa"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ReedOrgan] = "Organo a canne"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Accordion] = "Fisarmonica"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Harmonica] = "Armonica"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TangoAccordion] = "Fisarmonica da tango"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGuitarNylon] = "Chitarra acustica (nylon)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGuitarSteel] = "Chitarra acustica (acciaio)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarJazz] = "Chitarra elettrica (jazz)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarClean] = "Chitarra elettrica (pulita)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarMuted] = "Chitarra elettrica (disattivata)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OverdrivenGuitar] = "Chitarra overdrive"
msg.MIDI_INSTRUMENT_NAMES[Instrument.DistortionGuitar] = "Chitarra di distorsione"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Guitarharmonics] = "Armoniche di chitarra"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticBass] = "Basso acustico"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricBassFinger] = "Basso elettrico (dita)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricBassPick] = "Basso elettrico (scelto)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FretlessBass] = "Bassi fretless"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SlapBass1] = "Basso schiaffo 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SlapBass2] = "Slap bass 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBass1] = "Basso sintetizzato 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBass2] = "Basso sintetizzato 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Violin] = "Violino"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Viola] = "Viola"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Cello] = "Violoncello"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Contrabass] = "Contrabbasso"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TremoloStrings] = "Corde tremolo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PizzicatoStrings] = "Corde pizzicato"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestralHarp] = "Arpa orchestrale"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Timpani] = "Timpani"
msg.MIDI_INSTRUMENT_NAMES[Instrument.StringEnsemble1] = "Insieme di archi 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.StringEnsemble2] = "Insieme di archi 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthStrings1] = "Corde sintetiche 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthStrings2] = "Corde sintetiche 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ChoirAahs] = "Choir aahs"
msg.MIDI_INSTRUMENT_NAMES[Instrument.VoiceOohs] = "Voce ooh"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthVoice] = "Voce sintetizzata"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestraHit] = "Colpo d'orchestra"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Trumpet] = "Tromba"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Trombone] = "Trombone"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Tuba] = "Tuba"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MutedTrumpet] = "Tromba silenziata"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FrenchHorn] = "Corno francese"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrassSection] = "Sezione in ottone"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBrass1] = "Ottone sintetico 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBrass2] = "Ottone sintetico 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SopranoSax] = "Sax soprano"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AltoSax] = "Sax contralto"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TenorSax] = "Sax tenore"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BaritoneSax] = "Sax baritono"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Oboe] = "Oboe"
msg.MIDI_INSTRUMENT_NAMES[Instrument.EnglishHorn] = "Corno inglese"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Bassoon] = "Fagotto"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Clarinet] = "Clarinetto"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Piccolo] = "Ottavino"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Flute] = "Flauto"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Recorder] = "Registratore"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PanFlute] = "Flauto di Pan"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BlownBottle] = "Bottiglia soffiata"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shakuhachi] = "Shakuhachi"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Whistle] = "Fischio"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Ocarina] = "Ocarina"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead1Square] = "Piombo 1 (quadrato)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead2Sawtooth] = "Piombo 2 (dente di sega)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead3Calliope] = "Lead 3 (calliope)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead4Chiff] = "Lead 4 (chiff)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead5Charang] = "Piombo 5 (charang)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead6Voice] = "Lead 6 (voce)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead7Fifths] = "Lead 7 (quinte)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead8BassLead] = "Lead 8 (basso + lead)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad1Newage] = "Pad 1 (nuova era)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad2Warm] = "Pad 2 (caldo)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad3Polysynth] = "Pad 3 (polysynth)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad4Choir] = "Pad 4 (coro)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad5Bowed] = "Pad 5 (piegato)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad6Metallic] = "Pad 6 (metallico)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad7Halo] = "Pad 7 (alone)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad8Sweep] = "Pad 8 (sweep)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX1Rain] = "FX 1 (pioggia)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX2Soundtrack] = "FX 2 (colonna sonora)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX3Crystal] = "FX 3 (cristallo)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX4Atmosphere] = "FX 4 (atmosfera)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX5Brightness] = "FX 5 (luminosità)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX6Goblins] = "FX 6 (goblin)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX7Echoes] = "FX 7 (echi)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX8SciFi] = "FX 8 (fantascienza)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Sitar] = "Sitar"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Banjo] = "Banjo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shamisen] = "Shamisen"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Koto] = "Koto"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Kalimba] = "Kalimba"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Bagpipe] = "Pipa a sacco"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Fiddle] = "Violino"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shanai] = "Shanai"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TinkleBell] = "Tinkle bell"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Agogo] = "Agogo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SteelDrums] = "Fusti in acciaio"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Woodblock] = "Blocco di legno"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TaikoDrum] = "Tamburo Taiko"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MelodicTom] = "Tom melodico"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthDrum] = "Tamburo sintetizzatore"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ReverseCymbal] = "Piatto inverso"
msg.MIDI_INSTRUMENT_NAMES[Instrument.GuitarFretNoise] = "Rumore del tasto della chitarra"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BreathNoise] = "Rumore di respiro"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Seashore] = "Seashore"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BirdTweet] = "Tweet sugli uccelli"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TelephoneRing] = "Squillo del telefono"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Helicopter] = "Elicottero"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Applause] = "Applausi"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Gunshot] = "Sparo"

--- General MIDI drum kit names
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_INSTRUMENT_NAMES[Instrument.StandardKit] = "Batteria standard"
msg.MIDI_INSTRUMENT_NAMES[Instrument.RoomKit] = "Batteria da camera"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PowerKit] = "Power drum kit"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectronicKit] = "Batteria elettronica"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TR808Kit] = "Drum machine TR-808"
msg.MIDI_INSTRUMENT_NAMES[Instrument.JazzKit] = "Batteria jazz"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrushKit] = "Kit tamburo spazzole"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestraKit] = "Batteria per orchestra"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SoundFXKit] = "Effetti sonori"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MT32Kit] = "Batteria MT-32"
msg.MIDI_INSTRUMENT_NAMES[Instrument.None] = "(Nessuna)"
msg.UNKNOWN_DRUMKIT = "Batteria sconosciuta ({midi})"

--- General MIDI percussion list
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_PERCUSSION_NAMES[Percussion.Laser] = "Laser" -- MIDI key 27
msg.MIDI_PERCUSSION_NAMES[Percussion.Whip] = "Frusta" -- MIDI key 28
msg.MIDI_PERCUSSION_NAMES[Percussion.ScratchPush] = "Scratch push" -- MIDI key 29
msg.MIDI_PERCUSSION_NAMES[Percussion.ScratchPull] = "Tirare i graffi" -- MIDI key 30
msg.MIDI_PERCUSSION_NAMES[Percussion.StickClick] = "Clic su stick" -- MIDI key 31
msg.MIDI_PERCUSSION_NAMES[Percussion.SquareClick] = "Clic quadrato" -- MIDI key 32
msg.MIDI_PERCUSSION_NAMES[Percussion.MetronomeClick] = "Clic del metronomo" -- MIDI key 33
msg.MIDI_PERCUSSION_NAMES[Percussion.MetronomeBell] = "Campana metronomo" -- MIDI key 34
msg.MIDI_PERCUSSION_NAMES[Percussion.AcousticBassDrum] = "Grancassa acustica" -- MIDI key 35
msg.MIDI_PERCUSSION_NAMES[Percussion.BassDrum1] = "Grancassa 1" -- MIDI key 36
msg.MIDI_PERCUSSION_NAMES[Percussion.SideStick] = "Stick laterale" -- MIDI key 37
msg.MIDI_PERCUSSION_NAMES[Percussion.AcousticSnare] = "Rullante acustico" -- MIDI key 38
msg.MIDI_PERCUSSION_NAMES[Percussion.HandClap] = "Applauso" -- MIDI key 39
msg.MIDI_PERCUSSION_NAMES[Percussion.ElectricSnare] = "Rullante elettrico" -- MIDI key 40
msg.MIDI_PERCUSSION_NAMES[Percussion.LowFloorTom] = "Tom piano basso" -- MIDI key 41
msg.MIDI_PERCUSSION_NAMES[Percussion.ClosedHiHat] = "Hi-hat chiuso" -- MIDI key 42
msg.MIDI_PERCUSSION_NAMES[Percussion.HighFloorTom] = "Tom piano alto" -- MIDI key 43
msg.MIDI_PERCUSSION_NAMES[Percussion.PedalHiHat] = "Hi-hat a pedale" -- MIDI key 44
msg.MIDI_PERCUSSION_NAMES[Percussion.LowTom] = "Tom basso" -- MIDI key 45
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenHiHat] = "Apri charleston" -- MIDI key 46
msg.MIDI_PERCUSSION_NAMES[Percussion.LowMidTom] = "Tom basso-medio" -- MIDI key 47
msg.MIDI_PERCUSSION_NAMES[Percussion.HiMidTom] = "Hi-mid tom" -- MIDI key 48
msg.MIDI_PERCUSSION_NAMES[Percussion.CrashCymbal1] = "Piatto crash 1" -- MIDI key 49
msg.MIDI_PERCUSSION_NAMES[Percussion.HighTom] = "Tom alto" -- MIDI key 50
msg.MIDI_PERCUSSION_NAMES[Percussion.RideCymbal1] = "Piatto ride 1" -- MIDI key 51
msg.MIDI_PERCUSSION_NAMES[Percussion.ChineseCymbal] = "Piatto cinese" -- MIDI key 52
msg.MIDI_PERCUSSION_NAMES[Percussion.RideBell] = "Ride bell" -- MIDI key 53
msg.MIDI_PERCUSSION_NAMES[Percussion.Tambourine] = "Tamburello" -- MIDI key 54
msg.MIDI_PERCUSSION_NAMES[Percussion.SplashCymbal] = "Piatto Splash" -- MIDI key 55
msg.MIDI_PERCUSSION_NAMES[Percussion.Cowbell] = "Campanaccio" -- MIDI key 56
msg.MIDI_PERCUSSION_NAMES[Percussion.CrashCymbal2] = "Piatto crash 2" -- MIDI key 57
msg.MIDI_PERCUSSION_NAMES[Percussion.Vibraslap] = "Vibraslap" -- MIDI key 58
msg.MIDI_PERCUSSION_NAMES[Percussion.RideCymbal2] = "Piatto ride 2" -- MIDI key 59
msg.MIDI_PERCUSSION_NAMES[Percussion.HiBongo] = "Ciao bongo" -- MIDI key 60
msg.MIDI_PERCUSSION_NAMES[Percussion.LowBongo] = "Bongo basso" -- MIDI key 61
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteHiConga] = "Mute ciao conga" -- MIDI key 62
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenHiConga] = "Apri ciao conga" -- MIDI key 63
msg.MIDI_PERCUSSION_NAMES[Percussion.LowConga] = "Conga bassa" -- MIDI key 64
msg.MIDI_PERCUSSION_NAMES[Percussion.HighTimbale] = "Timballo alto" -- MIDI key 65
msg.MIDI_PERCUSSION_NAMES[Percussion.LowTimbale] = "Timballo basso" -- MIDI key 66
msg.MIDI_PERCUSSION_NAMES[Percussion.HighAgogo] = "Agogo alto" -- MIDI key 67
msg.MIDI_PERCUSSION_NAMES[Percussion.LowAgogo] = "Agogo basso" -- MIDI key 68
msg.MIDI_PERCUSSION_NAMES[Percussion.Cabasa] = "Cabasa" -- MIDI key 69
msg.MIDI_PERCUSSION_NAMES[Percussion.Maracas] = "Maracas" -- MIDI key 70
msg.MIDI_PERCUSSION_NAMES[Percussion.ShortWhistle] = "Fischio corto" -- MIDI key 71
msg.MIDI_PERCUSSION_NAMES[Percussion.LongWhistle] = "Fischio lungo" -- MIDI key 72
msg.MIDI_PERCUSSION_NAMES[Percussion.ShortGuiro] = "Guiro corto" -- MIDI key 73
msg.MIDI_PERCUSSION_NAMES[Percussion.LongGuiro] = "Guiro lungo" -- MIDI key 74
msg.MIDI_PERCUSSION_NAMES[Percussion.Claves] = "Claves" -- MIDI key 75
msg.MIDI_PERCUSSION_NAMES[Percussion.HiWoodBlock] = "Ciao blocco di legno" -- MIDI key 76
msg.MIDI_PERCUSSION_NAMES[Percussion.LowWoodBlock] = "Blocco di legno basso" -- MIDI key 77
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteCuica] = "Mute cuica" -- MIDI key 78
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenCuica] = "Apri cuica" -- MIDI key 79
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteTriangle] = "Triangolo muto" -- MIDI key 80
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenTriangle] = "Triangolo aperto" -- MIDI key 81
msg.MIDI_PERCUSSION_NAMES[Percussion.Shaker] = "Shaker" -- MIDI key 82
msg.MIDI_PERCUSSION_NAMES[Percussion.SleighBell] = "Campanello della slitta" -- MIDI key 83
msg.MIDI_PERCUSSION_NAMES[Percussion.BellTree] = "Albero della campana" -- MIDI key 84
msg.MIDI_PERCUSSION_NAMES[Percussion.Castanets] = "Nacchere" -- MIDI key 85
msg.MIDI_PERCUSSION_NAMES[Percussion.SurduDeadStroke] = "Colpo morto di Surdu" -- MIDI key 86
msg.MIDI_PERCUSSION_NAMES[Percussion.Surdu] = "Surdu" -- MIDI key 87
msg.MIDI_PERCUSSION_NAMES[Percussion.SnareDrumRod] = "Bacchetta per rullante" -- MIDI key 88
msg.MIDI_PERCUSSION_NAMES[Percussion.OceanDrum] = "Tamburo oceanico" -- MIDI key 89
msg.MIDI_PERCUSSION_NAMES[Percussion.SnareDrumBrush] = "Spazzola per rullante" -- MIDI key 90