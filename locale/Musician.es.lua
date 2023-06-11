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

local msg = Musician.InitLocale("es", "Español", "esES", "esMX")

local Instrument = Musician.MIDI_INSTRUMENTS
local Percussion = Musician.MIDI_PERCUSSIONS
local KEY = Musician.KEYBOARD_KEY

------------------------------------------------------------------------
---------------- ↑↑↑ DO NOT EDIT THE LINES ABOVE ! ↑↑↑  ----------------
------------------------------------------------------------------------

--- Main frame controls
msg.PLAY = "Tocar"
msg.STOP = "Detener"
msg.PAUSE = "Pausa"
msg.TEST_SONG = "Avance"
msg.STOP_TEST = "Detener"
msg.CLEAR = "Claro"
msg.SELECT_ALL = "Seleccionar todo"
msg.EDIT = "Editar"
msg.MUTE = "Silencio"
msg.UNMUTE = "Activar sonido"

--- Minimap button menu
msg.MENU_TITLE = "Musician"
msg.MENU_IMPORT_SONG = "Importar y reproducir una canción"
msg.MENU_PLAY = "Tocar"
msg.MENU_STOP = "Detener"
msg.MENU_PLAY_PREVIEW = "Avance"
msg.MENU_STOP_PREVIEW = "Detener vista previa"
msg.MENU_LIVE_PLAY = "Juego en vivo"
msg.MENU_SHOW_KEYBOARD = "Teclado abierto"
msg.MENU_SETTINGS = "Ajustes"
msg.MENU_OPTIONS = "Opciones"
msg.MENU_ABOUT = "Acerca de"

--- Chat commands
msg.COMMAND_LIST_TITLE = "Comandos de Musician:"
msg.COMMAND_SHOW = "Mostrar ventana de importación de canciones"
msg.COMMAND_PREVIEW_PLAY = "Iniciar o detener la vista previa de la canción"
msg.COMMAND_PREVIEW_STOP = "Dejar de escuchar la canción"
msg.COMMAND_PLAY = "Reproducir o detener la canción"
msg.COMMAND_STOP = "Deja de tocar la canción"
msg.COMMAND_MUTE = "Silenciar toda la música"
msg.COMMAND_UNMUTE = "Activar el sonido de la música"
msg.COMMAND_SONG_EDITOR = "Abrir editor de canciones"
msg.COMMAND_LIVE_KEYBOARD = "Abrir teclado en vivo"
msg.COMMAND_CONFIGURE_KEYBOARD = "Configurar teclado"
msg.COMMAND_LIVE_DEMO = "Modo de demostración del teclado"
msg.COMMAND_LIVE_DEMO_PARAMS = "{** <número de pista superior> ** ** <número de pista inferior> ** || **apagado** }"
msg.COMMAND_HELP = "Mostrar este mensaje de ayuda"
msg.ERR_COMMAND_UNKNOWN = "Comando “{command}” desconocido. Escriba {help} para obtener la lista de comandos."

--- Add-on options
msg.OPTIONS_TITLE = "Musician"
msg.OPTIONS_SUB_TEXT = "¡Únete al servidor de Discord para recibir asistencia! {url}"
msg.OPTIONS_CATEGORY_EMOTE = "Ser emocionado"
msg.OPTIONS_ENABLE_EMOTE_LABEL = "Envía un mensaje de texto a los jugadores que no tienen Musician al reproducir una canción."
msg.OPTIONS_ENABLE_EMOTE_PROMO_LABEL = "Incluye un texto breve invitándolos a instalarlo para que puedan escuchar la música que tocas."
msg.OPTIONS_EMOTE_HINT = "Se muestra un gesto de texto a los jugadores que no tienen Musician cuando tocas una canción. Puede desactivarlo en las [opciones]."
msg.OPTIONS_INTEGRATION_OPTIONS_TITLE = "Opciones de integración en el juego"
msg.OPTIONS_AUTO_MUTE_GAME_MUSIC_LABEL = "Silencia la música del juego mientras se reproduce una canción."
msg.OPTIONS_MUTE_INSTRUMENT_TOYS_LABEL = "Silenciar la música de los juguetes instrumentales. {icons}"
msg.OPTIONS_AUDIO_CHANNELS_TITLE = "Canales de audio"
msg.OPTIONS_AUDIO_CHANNELS_HINT = "Seleccione más canales de audio para aumentar el número máximo de notas que Musician puede tocar simultáneamente."
msg.OPTIONS_AUDIO_CHANNELS_CHANNEL_POLYPHONY = "{channel} ({polyphony})"
msg.OPTIONS_AUDIO_CHANNELS_TOTAL_POLYPHONY = "Polifonía máxima total: {polyphony}"
msg.OPTIONS_AUDIO_CHANNELS_AUTO_ADJUST_CONFIG = "Optimiza automáticamente la configuración de audio cuando se seleccionan varios canales de audio."
msg.OPTIONS_AUDIO_CACHE_SIZE_FOR_MUSICIAN = "Para Musician (%d MB)"
msg.OPTIONS_CATEGORY_SHORTCUTS = "Accesos directos"
msg.OPTIONS_SHORTCUT_MINIMAP = "Botón del minimapa"
msg.OPTIONS_SHORTCUT_ADDON_MENU = "Menú del minimapa"
msg.OPTIONS_QUICK_PRELOADING_TITLE = "Precarga rápida"
msg.OPTIONS_QUICK_PRELOADING_TEXT = "Habilitar precarga rápida de instrumentos en arranque en frío."
msg.OPTIONS_CATEGORY_NAMEPLATES = "Placas de identificación y animaciones"
msg.OPTIONS_CATEGORY_NAMEPLATES_SUB_TEXT = "Habilita las placas de identificación para ver las animaciones de los personajes que tocan\nmúsica y descubre quién puede escucharte de un vistazo."
msg.OPTIONS_ENABLE_NAMEPLATES = "Habilite placas de identificación y animaciones."
msg.OPTIONS_SHOW_NAMEPLATE_ICON = "Muestra un icono {icon} junto al nombre de los jugadores que también tienen Musician."
msg.OPTIONS_HIDE_HEALTH_BARS = "Oculta las barras de salud de los jugadores y las unidades amigas no en combate."
msg.OPTIONS_HIDE_NPC_NAMEPLATES = "Ocultar las placas de identificación de los NPC."
msg.OPTIONS_CINEMATIC_MODE = "Muestre animaciones cuando la interfaz de usuario esté oculta con {binding}."
msg.OPTIONS_CINEMATIC_MODE_NO_BINDING = "Muestra animaciones cuando la interfaz de usuario está oculta."
msg.OPTIONS_NAMEPLATES_CINEMATIC_MODE = "Muestre placas de identificación cuando la interfaz de usuario esté oculta."
msg.OPTIONS_TRP3 = "RP total 3"
msg.OPTIONS_TRP3_MAP_SCAN = "Muestra a los jugadores que tienen Musician en el mapa escaneado con un icono {icon}."
msg.OPTIONS_CROSS_RP_TITLE = "RP cruzado"
msg.OPTIONS_CROSS_RP_SUB_TEXT = "¡Instala el complemento Cross RP de Tammya-MoonGuard para activar\nla música entre facciones y entre reinos!"
msg.OPTIONS_CROSS_RP_SUB_TEXT_NO_GATEWAY = "No hay ningún nodo Cross RP disponible por el momento.\nTenga paciencia…"
msg.OPTIONS_CROSS_RP_SUB_TEXT_ACTIVE = "La comunicación cruzada de RP está activa para las siguientes ubicaciones:\n\n{bands}"

--- Tips and Tricks
msg.TIPS_AND_TRICKS_ENABLE = "Muestre consejos y trucos al inicio."

msg.TIPS_AND_TRICKS_NAMEPLATES_TITLE = "Animaciones y placas de identificación"
msg.TIPS_AND_TRICKS_NAMEPLATES_TEXT = "Se ve una animación especial en los personajes que tocan música cuando las placas de identificación están habilitadas.\n\nUn icono {icon} también indica quién tiene Musician y quién puede oírte.\n\n¿Desea habilitar las placas de identificación y las animaciones ahora?"
msg.TIPS_AND_TRICKS_NAMEPLATES_OK = "Habilitar placas de identificación y animaciones"
msg.TIPS_AND_TRICKS_NAMEPLATES_CANCEL = "Mas tarde"

msg.TIPS_AND_TRICKS_CROSS_RP_TITLE = "Música entre facciones con Cross RP"
msg.TIPS_AND_TRICKS_CROSS_RP_TEXT = "¡Instala el complemento Cross RP de Tammya-MoonGuard para activar\nla música entre facciones y entre reinos!"
msg.TIPS_AND_TRICKS_CROSS_RP_OK = "OK"

--- Welcome messages
msg.STARTUP = "Bienvenido a Musician v {version}."
msg.PLAYER_COUNT_ONLINE = "¡Hay {count} otros fanáticos de la música alrededor!"
msg.PLAYER_COUNT_ONLINE_ONE = "¡Hay otro fanático de la música!"
msg.PLAYER_COUNT_ONLINE_NONE = "Todavía no hay otros fanáticos de la música."

--- New version notifications
msg.NEW_VERSION = "¡Se ha lanzado una nueva versión de Musician! Descargue la actualización de {url}."
msg.NEW_PROTOCOL_VERSION = "Tu versión de Musician está desactualizada y ya no funciona.\nDescargue la actualización de\n{url}"

-- Module warnings
msg.ERR_INCOMPATIBLE_MODULE_API = "El módulo de Musician para {module} no pudo iniciarse porque {module} es incompatible. Intente actualizar Musician y {module}."

-- Loading screen
msg.LOADING_SCREEN_MESSAGE = "Musician está precargando las muestras de instrumentos en la memoria caché…"
msg.LOADING_SCREEN_CLOSE_TOOLTIP = "Cerrar y continuar con la precarga en segundo plano."

--- Player tooltips
msg.PLAYER_TOOLTIP = "Musician"
msg.PLAYER_TOOLTIP_VERSION = "{name} v {version}"
msg.PLAYER_TOOLTIP_VERSION_OUTDATED = " (Anticuado)"
msg.PLAYER_TOOLTIP_VERSION_INCOMPATIBLE = " (INCOMPATIBLE)"
msg.PLAYER_TOOLTIP_PRELOADING = "Precarga de sonidos… ({progress})"

--- URL hyperlinks tooltip
msg.TOOLTIP_COPY_URL = "Presione {shortcut} para copiar."

--- Song import
msg.INVALID_MUSIC_CODE = "Código de música no válido."
msg.PLAY_A_SONG = "Toca una canción"
msg.IMPORT_A_SONG = "Importar una cancion"
msg.PASTE_MUSIC_CODE = "Importa tu canción en formato MIDI en:\n{url}\n\nluego pega el código de música aquí ({shortcut})…"
msg.SONG_IMPORTED = "Canción cargada: {title}."

--- Play as a band
msg.PLAY_IN_BAND = "Tocar como una banda"
msg.PLAY_IN_BAND_HINT = "Haga clic aquí cuando esté listo para tocar esta canción con su banda."
msg.PLAY_IN_BAND_READY_PLAYERS = "Miembros de la banda listos:"
msg.EMOTE_PLAYER_IS_READY = "está listo para tocar como banda."
msg.EMOTE_PLAYER_IS_NOT_READY = "ya no está listo para tocar como banda."
msg.EMOTE_PLAY_IN_BAND_START = "comenzó a tocar la banda."
msg.EMOTE_PLAY_IN_BAND_STOP = "dejó de tocar la banda."

--- Play as a band (live)
msg.LIVE_SYNC = "Toca en vivo como una banda"
msg.LIVE_SYNC_HINT = "Haga clic aquí para activar la sincronización de banda."
msg.SYNCED_PLAYERS = "Miembros de la banda en vivo:"
msg.EMOTE_PLAYER_LIVE_SYNC_ENABLED = "está tocando música contigo."
msg.EMOTE_PLAYER_LIVE_SYNC_DISABLED = "dejó de tocar música contigo."

--- Song editor frame
msg.SONG_EDITOR = "Editor de canciones"
msg.MARKER_FROM = "De"
msg.MARKER_TO = "A"
msg.POSITION = "Posición"
msg.TRACK_NUMBER = "Pista n.º {track}"
msg.CHANNEL_NUMBER_SHORT = "Ch. {channel}"
msg.JUMP_PREV = "Atrás 10s"
msg.JUMP_NEXT = "Adelante 10s"
msg.GO_TO_START = "Ir a empezar"
msg.GO_TO_END = "Ir al final"
msg.SET_CROP_FROM = "Fijar el punto de partida"
msg.SET_CROP_TO = "Establecer punto final"
msg.SYNCHRONIZE_TRACKS = "Sincronizar la configuración de la pista con la canción actual"
msg.MUTE_TRACK = "Silencio"
msg.SOLO_TRACK = "Solo"
msg.ACCENT_TRACK = "Recalcar"
msg.TRANSPOSE_TRACK = "Transponer (octava)"
msg.CHANGE_TRACK_INSTRUMENT = "Cambiar instrumento"
msg.HEADER_NUMBER = "#"
msg.HEADER_OCTAVE = "Octava"
msg.HEADER_INSTRUMENT = "Instrumento"
msg.HEADER_ACCENT = "x2"

--- Configure live keyboard frame
msg.SHOULD_CONFIGURE_KEYBOARD = "Tienes que configurar el teclado antes de jugar."
msg.CONFIGURE_KEYBOARD = "Configurar teclado"
msg.CONFIGURE_KEYBOARD_HINT = "Haga clic en una tecla para configurar…"
msg.CONFIGURE_KEYBOARD_HINT_COMPLETE = "La configuración del teclado está completa.\n¡Ahora puede guardar sus cambios y comenzar a reproducir música!"
msg.CONFIGURE_KEYBOARD_START_OVER = "Comenzar de nuevo"
msg.CONFIGURE_KEYBOARD_SAVE = "Guardar configuración"
msg.PRESS_KEY_BINDING = "Presione la tecla # {col} en la fila # {row}."
msg.KEY_CAN_BE_EMPTY = "Esta clave es opcional y puede estar vacía."
msg.KEY_IS_MERGEABLE = "Esta tecla podría ser la misma que la tecla {key} de su teclado: {action}"
msg.KEY_CAN_BE_MERGED = "en este caso, simplemente presione la tecla {key}."
msg.KEY_CANNOT_BE_MERGED = "en este caso, simplemente ignórelo y continúe con la siguiente clave."
msg.NEXT_KEY = "Siguiente clave"
msg.CLEAR_KEY = "Clave clara"

--- About frame
msg.ABOUT_TITLE = "Musician"
msg.ABOUT_VERSION = "versión {version}"
msg.ABOUT_AUTHOR = "Por LenweSaralonde - {url}"
msg.ABOUT_LICENSE = "Publicado bajo la licencia pública general GNU v3.0"
msg.ABOUT_DISCORD = "Discord: {url}"
msg.ABOUT_SUPPORT = "¿Te gusta Musician? ¡Compártelo con todos!"
msg.ABOUT_PATREON = "Patreon: {url}"
msg.ABOUT_PAYPAL = "Donar: {url}"
msg.ABOUT_SUPPORTERS = "Un agradecimiento especial a los patrocinadores <3"
msg.ABOUT_LOCALIZATION_TEAM = "Equipo de traducción:"
msg.ABOUT_CONTRIBUTE_TO_LOCALIZATION = "¡Ayúdanos a traducir Musician en tu idioma!\n{url}"

--- Fixed PC keyboard key names
msg.FIXED_KEY_NAMES[KEY.Backspace] = "atrás"
msg.FIXED_KEY_NAMES[KEY.Tab] = "Pestaña"
msg.FIXED_KEY_NAMES[KEY.CapsLock] = "Bloq Mayús"
msg.FIXED_KEY_NAMES[KEY.Enter] = "Ingresar"
msg.FIXED_KEY_NAMES[KEY.ShiftLeft] = "Cambiar"
msg.FIXED_KEY_NAMES[KEY.ShiftRight] = "Cambiar"
msg.FIXED_KEY_NAMES[KEY.ControlLeft] = "control"
msg.FIXED_KEY_NAMES[KEY.MetaLeft] = "Meta"
msg.FIXED_KEY_NAMES[KEY.AltLeft] = "Alt"
msg.FIXED_KEY_NAMES[KEY.Space] = "Espacio"
msg.FIXED_KEY_NAMES[KEY.AltRight] = "Alt"
msg.FIXED_KEY_NAMES[KEY.MetaRight] = "Meta"
msg.FIXED_KEY_NAMES[KEY.ContextMenu] = "Menú"
msg.FIXED_KEY_NAMES[KEY.ControlRight] = "control"
msg.FIXED_KEY_NAMES[KEY.Delete] = "Borrar"

--- Live keyboard layouts, based on musical modes
msg.KEYBOARD_LAYOUTS["Piano"] = "Piano"
msg.KEYBOARD_LAYOUTS["Chromatic"] = "Cromático"
msg.KEYBOARD_LAYOUTS["Modes"] = "Modos"
msg.KEYBOARD_LAYOUTS["Ionian"] = "Jónico"
msg.KEYBOARD_LAYOUTS["Dorian"] = "dorio"
msg.KEYBOARD_LAYOUTS["Phrygian"] = "frigio"
msg.KEYBOARD_LAYOUTS["Lydian"] = "Lidio"
msg.KEYBOARD_LAYOUTS["Mixolydian"] = "Mixolidio"
msg.KEYBOARD_LAYOUTS["Aeolian"] = "eólico"
msg.KEYBOARD_LAYOUTS["Locrian"] = "Locrio"
msg.KEYBOARD_LAYOUTS["minor Harmonic"] = "armónico menor"
msg.KEYBOARD_LAYOUTS["minor Melodic"] = "melódico menor"
msg.KEYBOARD_LAYOUTS["Blues scales"] = "Escalas de blues"
msg.KEYBOARD_LAYOUTS["Major Blues"] = "Blues mayor"
msg.KEYBOARD_LAYOUTS["minor Blues"] = "blues menor"
msg.KEYBOARD_LAYOUTS["Diminished scales"] = "Escamas disminuidas"
msg.KEYBOARD_LAYOUTS["Diminished"] = "Disminuido"
msg.KEYBOARD_LAYOUTS["Complement Diminished"] = "Complemento disminuido"
msg.KEYBOARD_LAYOUTS["Pentatonic scales"] = "Escalas pentatónicas"
msg.KEYBOARD_LAYOUTS["Major Pentatonic"] = "Pentatónico mayor"
msg.KEYBOARD_LAYOUTS["minor Pentatonic"] = "pentatónico menor"
msg.KEYBOARD_LAYOUTS["World scales"] = "Escalas mundiales"
msg.KEYBOARD_LAYOUTS["Raga 1"] = "Raga 1"
msg.KEYBOARD_LAYOUTS["Raga 2"] = "Raga 2"
msg.KEYBOARD_LAYOUTS["Raga 3"] = "Raga 3"
msg.KEYBOARD_LAYOUTS["Arabic"] = "Arábica"
msg.KEYBOARD_LAYOUTS["Spanish"] = "Español"
msg.KEYBOARD_LAYOUTS["Gypsy"] = "gitano"
msg.KEYBOARD_LAYOUTS["Egyptian"] = "egipcio"
msg.KEYBOARD_LAYOUTS["Hawaiian"] = "hawaiano"
msg.KEYBOARD_LAYOUTS["Bali Pelog"] = "Bali Pelog"
msg.KEYBOARD_LAYOUTS["Japanese"] = "japonés"
msg.KEYBOARD_LAYOUTS["Ryukyu"] = "Ryukyu"
msg.KEYBOARD_LAYOUTS["Chinese"] = "chino"
msg.KEYBOARD_LAYOUTS["Miscellaneous scales"] = "Escalas varias"
msg.KEYBOARD_LAYOUTS["Bass Line"] = "Línea de bajo"
msg.KEYBOARD_LAYOUTS["Wholetone"] = "Wholetone"
msg.KEYBOARD_LAYOUTS["minor 3rd"] = "menor tercero"
msg.KEYBOARD_LAYOUTS["Major 3rd"] = "Mayor tercero"
msg.KEYBOARD_LAYOUTS["4th"] = "Cuarto"
msg.KEYBOARD_LAYOUTS["5th"] = "Quinto"
msg.KEYBOARD_LAYOUTS["Octave"] = "Octava"

--- Live keyboard layout types
msg.HORIZONTAL_LAYOUT = "Horizontal"
msg.VERTICAL_LAYOUT = "Vertical"

--- Live keyboard frame
msg.LIVE_SONG_NAME = "Canción en vivo"
msg.SOLO_MODE = "Modo Solo"
msg.LIVE_MODE = "Modo en vivo"
msg.LIVE_MODE_DISABLED = "El modo en vivo está desactivado durante la reproducción."
msg.ENABLE_SOLO_MODE = "Habilita el modo Solo (juegas solo)"
msg.ENABLE_LIVE_MODE = "Habilita el modo en vivo (juegas para todos)"
msg.PLAY_LIVE = "Tocar en vivo"
msg.PLAY_SOLO = "Jugar solo"
msg.SHOW_KEYBOARD = "Mostrar teclado"
msg.HIDE_KEYBOARD = "Ocultar teclado"
msg.KEYBOARD_LAYOUT = "Modo de teclado y escala"
msg.CHANGE_KEYBOARD_LAYOUT = "Cambiar la distribución del teclado"
msg.BASE_KEY = "Clave base"
msg.CHANGE_BASE_KEY = "Clave base"
msg.CHANGE_LOWER_INSTRUMENT = "Cambiar instrumento inferior"
msg.CHANGE_UPPER_INSTRUMENT = "Cambiar instrumento superior"
msg.LOWER_INSTRUMENT_MAPPED_TO_CHANNEL = "Instrumento inferior (pista n° {track})"
msg.UPPER_INSTRUMENT_MAPPED_TO_CHANNEL = "Instrumento superior (pista n° {track})"
msg.SUSTAIN_KEY = "Sostener"
msg.POWER_CHORDS = "Acordes de poder"
msg.PROGRAM_BUTTON = "P {num}"
msg.EMPTY_PROGRAM = "Programa vacio"
msg.LOAD_PROGRAM_NUM = "Cargar programa # {num} ({key})"
msg.SAVE_PROGRAM_NUM = "Guardar en el programa # {num} ({key})"
msg.DELETE_PROGRAM_NUM = "Borrar programa # {num} ({key})"
msg.WRITE_PROGRAM = "Guardar programa ({key})"
msg.DELETE_PROGRAM = "Eliminar programa ({key})"
msg.PROGRAM_SAVED = "Programa # {num} guardado."
msg.PROGRAM_DELETED = "Programa # {num} borrado."
msg.DEMO_MODE_ENABLED = "Modo de demostración de teclado habilitado:\n{mapping}"
msg.DEMO_MODE_MAPPING = "{layer} → Track # {track}"
msg.DEMO_MODE_DISABLED = "El modo de demostración del teclado está desactivado."

--- Live keyboard layers
msg.LAYERS[Musician.KEYBOARD_LAYER.UPPER] = "Superior"
msg.LAYERS[Musician.KEYBOARD_LAYER.LOWER] = "Más bajo"

--- Chat emotes
msg.EMOTE_PLAYING_MUSIC = "está tocando una canción."
msg.EMOTE_PROMO = "(Obtén el complemento “Musician” para escuchar)"
msg.EMOTE_SONG_NOT_LOADED = "(La canción no se puede reproducir porque {player} está usando una versión incompatible)."
msg.EMOTE_PLAYER_OTHER_REALM = "(Este jugador está en otro reino)."
msg.EMOTE_PLAYER_OTHER_FACTION = "(Este jugador es de otra facción)."

--- Minimap button tooltips
msg.TOOLTIP_LEFT_CLICK = "** Clic izquierdo **: {action}"
msg.TOOLTIP_RIGHT_CLICK = "** Clic derecho **: {action}"
msg.TOOLTIP_DRAG_AND_DROP = "** Arrastra y suelta ** para mover"
msg.TOOLTIP_ISMUTED = "(apagado)"
msg.TOOLTIP_ACTION_OPEN_MENU = "Abre el menú principal"
msg.TOOLTIP_ACTION_MUTE = "Silenciar toda la música"
msg.TOOLTIP_ACTION_UNMUTE = "Activar el sonido de la música"

--- Player menu options
msg.PLAYER_MENU_TITLE = "Música"
msg.PLAYER_MENU_STOP_CURRENT_SONG = "Detener la canción actual"
msg.PLAYER_MENU_MUTE = "Silencio"
msg.PLAYER_MENU_UNMUTE = "Activar sonido"

--- Player actions feedback
msg.PLAYER_IS_MUTED = "{icon} {player} ahora está silenciado."
msg.PLAYER_IS_UNMUTED = "{icon} {player} ahora está desactivado."

--- Song links
msg.LINKS_PREFIX = "Música"
msg.LINKS_FORMAT = "{prefix}: {title}"
msg.LINKS_LINK_BUTTON = "Enlace"
msg.LINKS_CHAT_BUBBLE = "“{note} {title}”"

--- Song link export frame
msg.LINK_EXPORT_WINDOW_TITLE = "Crear enlace de canción"
msg.LINK_EXPORT_WINDOW_SONG_TITLE_LABEL = "Título de la canción:"
msg.LINK_EXPORT_WINDOW_HINT = "El enlace permanecerá activo hasta que cierre la sesión o vuelva a cargar la interfaz."
msg.LINK_EXPORT_WINDOW_PROGRESS = "Generando vínculo… {progress}%"
msg.LINK_EXPORT_WINDOW_POST_BUTTON = "Publicar enlace en el chat"

--- Song link import frame
msg.LINK_IMPORT_WINDOW_TITLE = "Importar canción de {player}:"
msg.LINK_IMPORT_WINDOW_HINT = "Haga clic en “Importar” para comenzar a importar la canción en Musician."
msg.LINK_IMPORT_WINDOW_IMPORT_BUTTON = "Importar canción"
msg.LINK_IMPORT_WINDOW_CANCEL_IMPORT_BUTTON = "Cancelar importación"
msg.LINK_IMPORT_WINDOW_REQUESTING = "Solicitando canción de {player}…"
msg.LINK_IMPORT_WINDOW_PROGRESS = "Importando… {progress}%"
msg.LINK_IMPORT_WINDOW_SELECT_ACCOUNT = "Seleccione el personaje del que desea recuperar la canción:"

--- Song links errors
msg.LINKS_ERROR.notFound = "La canción “{title}” no está disponible en {player}."
msg.LINKS_ERROR.alreadySending = "{player} ya te ha enviado una canción. Vuelva a intentarlo en unos segundos."
msg.LINKS_ERROR.alreadyRequested = "Ya se está solicitando una canción a {player}."
msg.LINKS_ERROR.timeout = "{player} no respondió."
msg.LINKS_ERROR.offline = "{player} no ha iniciado sesión en World of Warcraft."
msg.LINKS_ERROR.importingFailed = "La canción {title} no se pudo importar desde {player}."

--- Map tracking options
msg.MAP_OPTIONS_TITLE = "Mapa"
msg.MAP_OPTIONS_SUB_TEXT = "Mostrar músicos cercanos tocando:"
msg.MAP_OPTIONS_MINI_MAP = "En el minimapa"
msg.MAP_OPTIONS_WORLD_MAP = "En el mapa del mundo"
msg.MAP_TRACKING_OPTIONS_TITLE = "Musician"
msg.MAP_TRACKING_OPTION_ACTIVE_MUSICIANS = "Músicos tocando"

--- Total RP Extended module
msg.TRPE_ITEM_NAME = "{title}"
msg.TRPE_ITEM_TOOLTIP_REQUIRES_MUSICIAN = "Requiere Musician"
msg.TRPE_ITEM_TOOLTIP_SHEET_MUSIC = "Partitura"
msg.TRPE_ITEM_USE_HINT = "Leer la partitura"
msg.TRPE_ITEM_MUSICIAN_NOT_FOUND = "Debe instalar la última versión del complemento “Musician” para poder utilizar este elemento.\nConsíguelo en {url}"
msg.TRPE_ITEM_NOTES = "Importa la canción a Musician para reproducirla para los jugadores cercanos.\n\nDescargar Musician: {url}\n"

msg.TRPE_EXPORT_BUTTON = "Exportar"
msg.TRPE_EXPORT_WINDOW_TITLE = "Exportar canción como elemento de RP total"
msg.TRPE_EXPORT_WINDOW_LOCALE = "Idioma del artículo:"
msg.TRPE_EXPORT_WINDOW_ADD_TO_BAG = "Añádelo a tu bolsa"
msg.TRPE_EXPORT_WINDOW_QUANTITY = "Cantidad:"
msg.TRPE_EXPORT_WINDOW_HINT_NEW = "Cree un elemento de partitura en Total RP que pueda intercambiarse con otros jugadores."
msg.TRPE_EXPORT_WINDOW_HINT_EXISTING = "Ya existe un elemento para esta canción, se actualizará."
msg.TRPE_EXPORT_WINDOW_CREATE_ITEM_BUTTON = "Crear artículo"
msg.TRPE_EXPORT_WINDOW_PROGRESS = "Creando elemento… {progress}%"

--- Musician instrument names
msg.INSTRUMENT_NAMES["none"] = "(Ninguno)"
msg.INSTRUMENT_NAMES["accordion"] = "Acordeón"
msg.INSTRUMENT_NAMES["bagpipe"] = "Cornamusa"
msg.INSTRUMENT_NAMES["dulcimer"] = "Dulcimer (martillado)"
msg.INSTRUMENT_NAMES["piano"] = "Piano"
msg.INSTRUMENT_NAMES["lute"] = "Laúd"
msg.INSTRUMENT_NAMES["viola_da_gamba"] = "Viola da gamba"
msg.INSTRUMENT_NAMES["harp"] = "Arpa celta"
msg.INSTRUMENT_NAMES["male_voice"] = "Voz masculina (tenor)"
msg.INSTRUMENT_NAMES["female_voice"] = "Voz femenina (soprano)"
msg.INSTRUMENT_NAMES["trumpet"] = "Trompeta"
msg.INSTRUMENT_NAMES["sackbut"] = "Sacabuche"
msg.INSTRUMENT_NAMES["war_horn"] = "Cuerno de guerra"
msg.INSTRUMENT_NAMES["bassoon"] = "Fagot"
msg.INSTRUMENT_NAMES["clarinet"] = "Clarinete"
msg.INSTRUMENT_NAMES["recorder"] = "Grabadora"
msg.INSTRUMENT_NAMES["fiddle"] = "Violín"
msg.INSTRUMENT_NAMES["percussions"] = "Percusiones (tradicionales)"
msg.INSTRUMENT_NAMES["distortion_guitar"] = "Guitarra de distorsión"
msg.INSTRUMENT_NAMES["clean_guitar"] = "Guitarra limpia"
msg.INSTRUMENT_NAMES["bass_guitar"] = "Bajo"
msg.INSTRUMENT_NAMES["drumkit"] = "Kit de batería"
msg.INSTRUMENT_NAMES["war_drum"] = "Tambor de guerra"
msg.INSTRUMENT_NAMES["woodblock"] = "Bloque de madera"
msg.INSTRUMENT_NAMES["tambourine_shake"] = "Pandereta (agitada)"

--- General MIDI instrument names
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGrandPiano] = "Piano de cola acústico"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrightAcousticPiano] = "Piano acústico brillante"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGrandPiano] = "Piano de cola electrico"
msg.MIDI_INSTRUMENT_NAMES[Instrument.HonkyTonkPiano] = "Piano honky-tonk"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricPiano1] = "Piano eléctrico 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricPiano2] = "Piano eléctrico 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Harpsichord] = "Clave"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Clavi] = "Clavi"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Celesta] = "Celesta"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Glockenspiel] = "Glockenspiel"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MusicBox] = "Caja de música"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Vibraphone] = "Vibráfono"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Marimba] = "Marimba"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Xylophone] = "Xilófono"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TubularBells] = "Campanas tubulares"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Dulcimer] = "Dulcimer"
msg.MIDI_INSTRUMENT_NAMES[Instrument.DrawbarOrgan] = "Órgano de barra de tiro"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PercussiveOrgan] = "Órgano de percusión"
msg.MIDI_INSTRUMENT_NAMES[Instrument.RockOrgan] = "Órgano de rock"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ChurchOrgan] = "Órgano de la iglesia"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ReedOrgan] = "Órgano de lengüeta"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Accordion] = "Acordeón"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Harmonica] = "Harmónica"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TangoAccordion] = "Acordeón de tango"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGuitarNylon] = "Guitarra acústica (nailon)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGuitarSteel] = "Guitarra acústica (acero)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarJazz] = "Guitarra eléctrica (jazz)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarClean] = "Guitarra eléctrica (limpia)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarMuted] = "Guitarra eléctrica (silenciada)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OverdrivenGuitar] = "Guitarra saturada"
msg.MIDI_INSTRUMENT_NAMES[Instrument.DistortionGuitar] = "Guitarra de distorsión"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Guitarharmonics] = "Armónicos de guitarra"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticBass] = "Bajo acústico"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricBassFinger] = "Bajo eléctrico (digitado)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricBassPick] = "Bajo eléctrico (elegido)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FretlessBass] = "Bajo sin trastes"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SlapBass1] = "Bofetada bajo 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SlapBass2] = "Bajo bofetada 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBass1] = "Bajo sintetizado 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBass2] = "Bajo sintetizado 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Violin] = "Violín"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Viola] = "Viola"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Cello] = "Violonchelo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Contrabass] = "Contrabajo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TremoloStrings] = "Cuerdas de trémolo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PizzicatoStrings] = "Cuerdas Pizzicato"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestralHarp] = "Arpa orquestal"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Timpani] = "Tímpanos"
msg.MIDI_INSTRUMENT_NAMES[Instrument.StringEnsemble1] = "Conjunto de cuerdas 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.StringEnsemble2] = "Conjunto de cuerdas 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthStrings1] = "Cuerdas de sintetizador 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthStrings2] = "Cuerdas de sintetizador 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ChoirAahs] = "Coro aahs"
msg.MIDI_INSTRUMENT_NAMES[Instrument.VoiceOohs] = "Voz ooh"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthVoice] = "Voz de sintetizador"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestraHit] = "Golpe de orquesta"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Trumpet] = "Trompeta"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Trombone] = "Trombón"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Tuba] = "Tuba"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MutedTrumpet] = "Trompeta silenciada"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FrenchHorn] = "cuerno francés"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrassSection] = "Sección de latón"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBrass1] = "Latón de sintetizador 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBrass2] = "Sintetizador de metales 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SopranoSax] = "Saxo soprano"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AltoSax] = "Saxo alto"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TenorSax] = "Saxo tenor"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BaritoneSax] = "Saxo barítono"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Oboe] = "Oboe"
msg.MIDI_INSTRUMENT_NAMES[Instrument.EnglishHorn] = "Cuerno inglés"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Bassoon] = "Fagot"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Clarinet] = "Clarinete"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Piccolo] = "Piccolo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Flute] = "Flauta"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Recorder] = "Grabadora"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PanFlute] = "Flauta de pan"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BlownBottle] = "Botella soplada"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shakuhachi] = "Shakuhachi"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Whistle] = "Silbar"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Ocarina] = "Ocarina"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead1Square] = "Plomo 1 (cuadrado)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead2Sawtooth] = "Plomo 2 (diente de sierra)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead3Calliope] = "Plomo 3 (calliope)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead4Chiff] = "Plomo 4 (gasa)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead5Charang] = "Plomo 5 (charang)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead6Voice] = "Lead 6 (voz)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead7Fifths] = "Lead 7 (quintos)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead8BassLead] = "Lead 8 (bajo + lead)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad1Newage] = "Pad 1 (nueva era)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad2Warm] = "Pad 2 (caliente)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad3Polysynth] = "Pad 3 (polysynth)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad4Choir] = "Pad 4 (coro)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad5Bowed] = "Pad 5 (inclinado)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad6Metallic] = "Pad 6 (metálico)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad7Halo] = "Pad 7 (halo)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad8Sweep] = "Pad 8 (barrido)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX1Rain] = "FX 1 (lluvia)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX2Soundtrack] = "FX 2 (banda sonora)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX3Crystal] = "FX 3 (cristal)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX4Atmosphere] = "FX 4 (atmósfera)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX5Brightness] = "FX 5 (brillo)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX6Goblins] = "FX 6 (duendes)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX7Echoes] = "FX 7 (ecos)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX8SciFi] = "FX 8 (ciencia ficción)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Sitar] = "Sitar"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Banjo] = "Banjo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shamisen] = "Shamisen"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Koto] = "Koto"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Kalimba] = "Kalimba"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Bagpipe] = "Tubo de bolsa"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Fiddle] = "Violín"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shanai] = "Shanai"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TinkleBell] = "Campanilla"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Agogo] = "Agogo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SteelDrums] = "Tambores de acero"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Woodblock] = "Bloque de madera"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TaikoDrum] = "Tambor taiko"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MelodicTom] = "Tom melódico"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthDrum] = "Tambor sintetizador"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ReverseCymbal] = "Platillo inverso"
msg.MIDI_INSTRUMENT_NAMES[Instrument.GuitarFretNoise] = "Ruido de trastes de guitarra"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BreathNoise] = "Ruido de respiración"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Seashore] = "Costa"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BirdTweet] = "Tweet de pájaro"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TelephoneRing] = "Anillo telefónico"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Helicopter] = "Helicóptero"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Applause] = "Aplausos"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Gunshot] = "Cañonazo"

--- General MIDI drum kit names
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_INSTRUMENT_NAMES[Instrument.StandardKit] = "Kit de batería estándar"
msg.MIDI_INSTRUMENT_NAMES[Instrument.RoomKit] = "Batería de sala"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PowerKit] = "Batería de potencia"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectronicKit] = "Kit de batería electrónica"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TR808Kit] = "Caja de ritmos TR-808"
msg.MIDI_INSTRUMENT_NAMES[Instrument.JazzKit] = "Batería de jazz"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrushKit] = "Kit de tambor de cepillo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestraKit] = "Batería de orquesta"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SoundFXKit] = "Sonido FX"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MT32Kit] = "Batería MT-32"
msg.MIDI_INSTRUMENT_NAMES[Instrument.None] = "(Ninguno)"
msg.UNKNOWN_DRUMKIT = "Batería desconocida ({midi})"

--- General MIDI percussion list
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_PERCUSSION_NAMES[Percussion.Laser] = "Láser" -- MIDI key 27
msg.MIDI_PERCUSSION_NAMES[Percussion.Whip] = "Látigo" -- MIDI key 28
msg.MIDI_PERCUSSION_NAMES[Percussion.ScratchPush] = "Empuje de cero" -- MIDI key 29
msg.MIDI_PERCUSSION_NAMES[Percussion.ScratchPull] = "Tirador de rasguño" -- MIDI key 30
msg.MIDI_PERCUSSION_NAMES[Percussion.StickClick] = "Stick clic" -- MIDI key 31
msg.MIDI_PERCUSSION_NAMES[Percussion.SquareClick] = "Clic cuadrado" -- MIDI key 32
msg.MIDI_PERCUSSION_NAMES[Percussion.MetronomeClick] = "Clic del metrónomo" -- MIDI key 33
msg.MIDI_PERCUSSION_NAMES[Percussion.MetronomeBell] = "Campana de metrónomo" -- MIDI key 34
msg.MIDI_PERCUSSION_NAMES[Percussion.AcousticBassDrum] = "Bombo acústico" -- MIDI key 35
msg.MIDI_PERCUSSION_NAMES[Percussion.BassDrum1] = "Bombo 1" -- MIDI key 36
msg.MIDI_PERCUSSION_NAMES[Percussion.SideStick] = "Palo de lado" -- MIDI key 37
msg.MIDI_PERCUSSION_NAMES[Percussion.AcousticSnare] = "Caja acústica" -- MIDI key 38
msg.MIDI_PERCUSSION_NAMES[Percussion.HandClap] = "Aplauso" -- MIDI key 39
msg.MIDI_PERCUSSION_NAMES[Percussion.ElectricSnare] = "Lazo eléctrico" -- MIDI key 40
msg.MIDI_PERCUSSION_NAMES[Percussion.LowFloorTom] = "Tom de piso bajo" -- MIDI key 41
msg.MIDI_PERCUSSION_NAMES[Percussion.ClosedHiHat] = "Charles cerrado" -- MIDI key 42
msg.MIDI_PERCUSSION_NAMES[Percussion.HighFloorTom] = "Tom de piso alto" -- MIDI key 43
msg.MIDI_PERCUSSION_NAMES[Percussion.PedalHiHat] = "Charles de pedal" -- MIDI key 44
msg.MIDI_PERCUSSION_NAMES[Percussion.LowTom] = "Tom bajo" -- MIDI key 45
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenHiHat] = "Hi-hat abierto" -- MIDI key 46
msg.MIDI_PERCUSSION_NAMES[Percussion.LowMidTom] = "Tom de medios bajos" -- MIDI key 47
msg.MIDI_PERCUSSION_NAMES[Percussion.HiMidTom] = "Tom hi-mid" -- MIDI key 48
msg.MIDI_PERCUSSION_NAMES[Percussion.CrashCymbal1] = "Platillo crash 1" -- MIDI key 49
msg.MIDI_PERCUSSION_NAMES[Percussion.HighTom] = "Tom alto" -- MIDI key 50
msg.MIDI_PERCUSSION_NAMES[Percussion.RideCymbal1] = "Platillo Ride 1" -- MIDI key 51
msg.MIDI_PERCUSSION_NAMES[Percussion.ChineseCymbal] = "Platillo chino" -- MIDI key 52
msg.MIDI_PERCUSSION_NAMES[Percussion.RideBell] = "Campana de paseo" -- MIDI key 53
msg.MIDI_PERCUSSION_NAMES[Percussion.Tambourine] = "Pandereta" -- MIDI key 54
msg.MIDI_PERCUSSION_NAMES[Percussion.SplashCymbal] = "Platillo splash" -- MIDI key 55
msg.MIDI_PERCUSSION_NAMES[Percussion.Cowbell] = "Cencerro" -- MIDI key 56
msg.MIDI_PERCUSSION_NAMES[Percussion.CrashCymbal2] = "Platillo crash 2" -- MIDI key 57
msg.MIDI_PERCUSSION_NAMES[Percussion.Vibraslap] = "Vibraslap" -- MIDI key 58
msg.MIDI_PERCUSSION_NAMES[Percussion.RideCymbal2] = "Platillo Ride 2" -- MIDI key 59
msg.MIDI_PERCUSSION_NAMES[Percussion.HiBongo] = "Hola bongo" -- MIDI key 60
msg.MIDI_PERCUSSION_NAMES[Percussion.LowBongo] = "Bongo bajo" -- MIDI key 61
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteHiConga] = "Mute hola conga" -- MIDI key 62
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenHiConga] = "Abrir hola conga" -- MIDI key 63
msg.MIDI_PERCUSSION_NAMES[Percussion.LowConga] = "Conga baja" -- MIDI key 64
msg.MIDI_PERCUSSION_NAMES[Percussion.HighTimbale] = "Timbal alto" -- MIDI key 65
msg.MIDI_PERCUSSION_NAMES[Percussion.LowTimbale] = "Timbal bajo" -- MIDI key 66
msg.MIDI_PERCUSSION_NAMES[Percussion.HighAgogo] = "Alto agogo" -- MIDI key 67
msg.MIDI_PERCUSSION_NAMES[Percussion.LowAgogo] = "Bajo agogo" -- MIDI key 68
msg.MIDI_PERCUSSION_NAMES[Percussion.Cabasa] = "Cabasa" -- MIDI key 69
msg.MIDI_PERCUSSION_NAMES[Percussion.Maracas] = "Maracas" -- MIDI key 70
msg.MIDI_PERCUSSION_NAMES[Percussion.ShortWhistle] = "Silbido corto" -- MIDI key 71
msg.MIDI_PERCUSSION_NAMES[Percussion.LongWhistle] = "Silbido largo" -- MIDI key 72
msg.MIDI_PERCUSSION_NAMES[Percussion.ShortGuiro] = "Guiro corto" -- MIDI key 73
msg.MIDI_PERCUSSION_NAMES[Percussion.LongGuiro] = "Largo guiro" -- MIDI key 74
msg.MIDI_PERCUSSION_NAMES[Percussion.Claves] = "Claves" -- MIDI key 75
msg.MIDI_PERCUSSION_NAMES[Percussion.HiWoodBlock] = "Hola bloque de madera" -- MIDI key 76
msg.MIDI_PERCUSSION_NAMES[Percussion.LowWoodBlock] = "Bloque de madera bajo" -- MIDI key 77
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteCuica] = "Muda cuica" -- MIDI key 78
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenCuica] = "Cuica abierta" -- MIDI key 79
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteTriangle] = "Triángulo mudo" -- MIDI key 80
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenTriangle] = "Triángulo abierto" -- MIDI key 81
msg.MIDI_PERCUSSION_NAMES[Percussion.Shaker] = "Criba vibradora" -- MIDI key 82
msg.MIDI_PERCUSSION_NAMES[Percussion.SleighBell] = "Campana de trineo" -- MIDI key 83
msg.MIDI_PERCUSSION_NAMES[Percussion.BellTree] = "Árbol de campana" -- MIDI key 84
msg.MIDI_PERCUSSION_NAMES[Percussion.Castanets] = "Castañuelas" -- MIDI key 85
msg.MIDI_PERCUSSION_NAMES[Percussion.SurduDeadStroke] = "Golpe muerto surdu" -- MIDI key 86
msg.MIDI_PERCUSSION_NAMES[Percussion.Surdu] = "Surdu" -- MIDI key 87
msg.MIDI_PERCUSSION_NAMES[Percussion.SnareDrumRod] = "Varilla de caja" -- MIDI key 88
msg.MIDI_PERCUSSION_NAMES[Percussion.OceanDrum] = "Tambor oceánico" -- MIDI key 89
msg.MIDI_PERCUSSION_NAMES[Percussion.SnareDrumBrush] = "Cepillo para caja" -- MIDI key 90