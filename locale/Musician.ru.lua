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

local msg = Musician.InitLocale("ru", "Русский", "ruRU")

local Instrument = Musician.MIDI_INSTRUMENTS
local Percussion = Musician.MIDI_PERCUSSIONS
local KEY = Musician.KEYBOARD_KEY

------------------------------------------------------------------------
---------------- ↑↑↑ DO NOT EDIT THE LINES ABOVE ! ↑↑↑  ----------------
------------------------------------------------------------------------

--- Main frame controls
msg.PLAY = "Играть"
msg.STOP = "Стоп"
msg.PAUSE = "Пауза"
msg.TEST_SONG = "Предварительный просмотр"
msg.STOP_TEST = "Остановить предварительный просмотр"
msg.CLEAR = "Очистить"
msg.SELECT_ALL = "Выбрать все"
msg.EDIT = "Редактировать"
msg.MUTE = "Немой"
msg.UNMUTE = "Включить звук"

--- Minimap button menu
msg.MENU_TITLE = "Musician"
msg.MENU_IMPORT_SONG = "Импортировать и воспроизвести песню"
msg.MENU_PLAY = "Играть"
msg.MENU_STOP = "Стоп"
msg.MENU_PLAY_PREVIEW = "Предварительный просмотр"
msg.MENU_STOP_PREVIEW = "Остановить предварительный просмотр"
msg.MENU_LIVE_PLAY = "Живая игра"
msg.MENU_SHOW_KEYBOARD = "Открытая клавиатура"
msg.MENU_SETTINGS = "Настройки"
msg.MENU_OPTIONS = "Параметры"
msg.MENU_ABOUT = "О"

--- Chat commands
msg.COMMAND_LIST_TITLE = "Команды Musician:"
msg.COMMAND_SHOW = "Показать окно импорта песни"
msg.COMMAND_PREVIEW_PLAY = "Начать или прекратить предварительный просмотр песни"
msg.COMMAND_PREVIEW_STOP = "Прекратить предварительный просмотр песни"
msg.COMMAND_PLAY = "Воспроизвести или остановить песню"
msg.COMMAND_STOP = "Прекратить играть песню"
msg.COMMAND_SONG_EDITOR = "Открыть редактор песен"
msg.COMMAND_LIVE_KEYBOARD = "Открыть клавиатуру для игры вживую"
msg.COMMAND_CONFIGURE_KEYBOARD = "Настроить клавиатуру"
msg.COMMAND_LIVE_DEMO = "Демо-режим клавиатуры"
msg.COMMAND_LIVE_DEMO_PARAMS = "{** <верхняя дорожка №> ** ** <нижняя дорожка №> ** || **выключенный** }"
msg.COMMAND_HELP = "Показать это справочное сообщение"
msg.ERR_COMMAND_UNKNOWN = "Неизвестная команда «{command}». Введите {help}, чтобы получить список команд."

--- Add-on options
msg.OPTIONS_TITLE = "Musician"
msg.OPTIONS_SUB_TEXT = "Присоединяйтесь к серверу Discord для поддержки! {url}"
msg.OPTIONS_CATEGORY_EMOTE = "Эмоция"
msg.OPTIONS_ENABLE_EMOTE_LABEL = "Отправляйте текстовые эмоции игрокам, у которых нет Musicianа, при воспроизведении песни."
msg.OPTIONS_ENABLE_EMOTE_PROMO_LABEL = "Включите короткий текст с приглашением установить его, чтобы они могли слышать музыку, которую вы играете."
msg.OPTIONS_EMOTE_HINT = "Текстовая эмоция отображается игрокам, у которых нет Musicianа, когда вы играете песню. Вы можете отключить его в [опциях]."
msg.OPTIONS_INTEGRATION_OPTIONS_TITLE = "Варианты интеграции в игре"
msg.OPTIONS_AUTO_MUTE_GAME_MUSIC_LABEL = "Отключение музыки в игре во время воспроизведения песни."
msg.OPTIONS_MUTE_INSTRUMENT_TOYS_LABEL = "Отключите музыку из инструментальных игрушек. {icons}"
msg.OPTIONS_AUDIO_CHANNELS_TITLE = "Аудиоканалы"
msg.OPTIONS_AUDIO_CHANNELS_HINT = "Выберите больше аудиоканалов, чтобы увеличить максимальное количество нот, которые Musician может воспроизводить одновременно."
msg.OPTIONS_AUDIO_CHANNELS_CHANNEL_POLYPHONY = "{channel} ({polyphony})"
msg.OPTIONS_AUDIO_CHANNELS_TOTAL_POLYPHONY = "Общая максимальная полифония: {polyphony}"
msg.OPTIONS_AUDIO_CHANNELS_AUTO_ADJUST_CONFIG = "Автоматически оптимизировать настройки звука при выборе нескольких аудиоканалов."
msg.OPTIONS_CATEGORY_NAMEPLATES = "Таблички и анимация"
msg.OPTIONS_CATEGORY_NAMEPLATES_SUB_TEXT = "Включите именные таблички, чтобы увидеть анимацию персонажей, играющих музыку, и\nузнавать, кто вас слышит, с первого взгляда."
msg.OPTIONS_ENABLE_NAMEPLATES = "Включите таблички с именами и анимацию."
msg.OPTIONS_SHOW_NAMEPLATE_ICON = "Показывать значок {icon} рядом с именами игроков, у которых также есть Musician."
msg.OPTIONS_HIDE_HEALTH_BARS = "Скрывайте шкалы здоровья игроков и дружественных юнитов, когда не в бою."
msg.OPTIONS_HIDE_NPC_NAMEPLATES = "Скрыть таблички с именами NPC."
msg.OPTIONS_CINEMATIC_MODE = "Показывать анимацию, когда пользовательский интерфейс скрыт с помощью {binding}."
msg.OPTIONS_CINEMATIC_MODE_NO_BINDING = "Показывать анимацию, когда пользовательский интерфейс скрыт."
msg.OPTIONS_NAMEPLATES_CINEMATIC_MODE = "Показывать таблички с именами, когда пользовательский интерфейс скрыт."
msg.OPTIONS_TRP3 = "Итого RP 3"
msg.OPTIONS_TRP3_MAP_SCAN = "Покажите игрокам, у которых на сканированной карте есть Musician, с помощью значка {icon}."
msg.OPTIONS_CROSS_RP_TITLE = "Кросс RP"
msg.OPTIONS_CROSS_RP_SUB_TEXT = "Установите надстройку Cross RP от Tammya-MoonGuard, чтобы активировать\nмузыку между фракциями и игровыми мирами!"
msg.OPTIONS_CROSS_RP_SUB_TEXT_NO_GATEWAY = "На данный момент нет доступного узла Cross RP.\nПожалуйста, подождите ..."
msg.OPTIONS_CROSS_RP_SUB_TEXT_ACTIVE = "Перекрестная связь RP активна для следующих мест:\n\n{bands}"

--- Tips and Tricks
msg.TIPS_AND_TRICKS_ENABLE = "Покажите советы и рекомендации при запуске."

msg.TIPS_AND_TRICKS_NAMEPLATES_TITLE = "Анимации и шильдики"
msg.TIPS_AND_TRICKS_NAMEPLATES_TEXT = "Специальная анимация видна у персонажей, которые играют музыку, когда включены таблички с именами.\n\nЗначок {icon} также указывает, у кого есть Musician и кто вас слышит.\n\nВы хотите включить таблички с именами и анимацию сейчас?"
msg.TIPS_AND_TRICKS_NAMEPLATES_OK = "Включить таблички с именами и анимацию"
msg.TIPS_AND_TRICKS_NAMEPLATES_CANCEL = "Позже"

msg.TIPS_AND_TRICKS_CROSS_RP_TITLE = "Межфракционная музыка с Cross RP"
msg.TIPS_AND_TRICKS_CROSS_RP_TEXT = "Установите надстройку Cross RP от Tammya-MoonGuard, чтобы активировать\nмузыку между фракциями и игровыми мирами!"
msg.TIPS_AND_TRICKS_CROSS_RP_OK = "ОК"

--- Welcome messages
msg.STARTUP = "Добро пожаловать в Musician v {version}."
msg.PLAYER_COUNT_ONLINE = "Вокруг ещё {count} меломаны!"
msg.PLAYER_COUNT_ONLINE_ONE = "Вокруг еще один меломан!"
msg.PLAYER_COUNT_ONLINE_NONE = "Других меломанов пока нет."

--- New version notifications
msg.NEW_VERSION = "Вышла новая версия Musicianа! Загрузите обновление с {url}."
msg.NEW_PROTOCOL_VERSION = "Ваша версия Musicianа устарела и больше не работает.\nЗагрузите обновление с\n{url}"

--- Player tooltips
msg.PLAYER_TOOLTIP = "Musician"
msg.PLAYER_TOOLTIP_VERSION = "Musician v {version}"
msg.PLAYER_TOOLTIP_VERSION_OUTDATED = " (Устарело)"
msg.PLAYER_TOOLTIP_VERSION_INCOMPATIBLE = " (НЕСОВМЕСТИМО)"
msg.PLAYER_TOOLTIP_PRELOADING = "Звуки предварительной загрузки… ({progress})"

--- URL hyperlinks tooltip
msg.TOOLTIP_COPY_URL = "Нажмите {shortcut}, чтобы скопировать."

--- Song import
msg.INVALID_MUSIC_CODE = "Неверный музыкальный код."
msg.PLAY_A_SONG = "Сыграть песню"
msg.IMPORT_A_SONG = "Импортировать песню"
msg.PASTE_MUSIC_CODE = "Импортируйте свою песню в формате MIDI по адресу:\n{url}\n\n, затем вставьте сюда музыкальный код ({shortcut})…"
msg.SONG_IMPORTED = "Загруженная песня: {title}."

--- Play as a band
msg.PLAY_IN_BAND = "Играйте как группа"
msg.PLAY_IN_BAND_HINT = "Щелкните здесь, когда будете готовы сыграть эту песню со своей группой."
msg.PLAY_IN_BAND_READY_PLAYERS = "Готовые участники группы:"
msg.EMOTE_PLAYER_IS_READY = "готов играть в группе."
msg.EMOTE_PLAYER_IS_NOT_READY = "не готов играть в группе."
msg.EMOTE_PLAY_IN_BAND_START = "начал играть в группе."
msg.EMOTE_PLAY_IN_BAND_STOP = "перестал играть в группе."

--- Play as a band (live)
msg.LIVE_SYNC = "Играйте вживую как группа"
msg.LIVE_SYNC_HINT = "Щелкните здесь, чтобы активировать синхронизацию диапазона."
msg.SYNCED_PLAYERS = "Участники живой группы:"
msg.EMOTE_PLAYER_LIVE_SYNC_ENABLED = "играет с вами музыку."
msg.EMOTE_PLAYER_LIVE_SYNC_DISABLED = "перестал играть с тобой музыку."

--- Song editor frame
msg.SONG_EDITOR = "Редактор песен"
msg.MARKER_FROM = "Из"
msg.MARKER_TO = "К"
msg.POSITION = "Должность"
msg.TRACK_NUMBER = "Трек № {track}"
msg.CHANNEL_NUMBER_SHORT = "Ch. {channel}"
msg.JUMP_PREV = "Назад 10 с"
msg.JUMP_NEXT = "Вперед 10сек"
msg.GO_TO_START = "Иди, чтобы начать"
msg.GO_TO_END = "Иди до конца"
msg.SET_CROP_FROM = "Установить начальную точку"
msg.SET_CROP_TO = "Установить конечную точку"
msg.SYNCHRONIZE_TRACKS = "Синхронизировать настройки трека с текущей песней"
msg.MUTE_TRACK = "Немой"
msg.SOLO_TRACK = "Соло"
msg.TRANSPOSE_TRACK = "Транспонирование (октава)"
msg.CHANGE_TRACK_INSTRUMENT = "Сменить инструмент"
msg.HEADER_NUMBER = "#"
msg.HEADER_OCTAVE = "Октава"
msg.HEADER_INSTRUMENT = "Инструмент"

--- Configure live keyboard frame
msg.SHOULD_CONFIGURE_KEYBOARD = "Вы должны настроить клавиатуру перед игрой."
msg.CONFIGURE_KEYBOARD = "Настроить клавиатуру"
msg.CONFIGURE_KEYBOARD_HINT = "Нажмите кнопку, чтобы установить…"
msg.CONFIGURE_KEYBOARD_HINT_COMPLETE = "Настройка клавиатуры завершена.\r\nТеперь вы можете сохранить изменения и начать играть музыку!"
msg.CONFIGURE_KEYBOARD_START_OVER = "Начать сначала"
msg.CONFIGURE_KEYBOARD_SAVE = "Сохранить конфигурацию"
msg.PRESS_KEY_BINDING = "Нажмите клавишу # {col} в строке # {row}."
msg.KEY_CAN_BE_EMPTY = "Этот ключ не является обязательным и может быть пустым."
msg.KEY_IS_MERGEABLE = "Эта клавиша может быть такой же, как клавиша {key} на клавиатуре: {action}"
msg.KEY_CAN_BE_MERGED = "в этом случае просто нажмите клавишу {key}."
msg.KEY_CANNOT_BE_MERGED = "в этом случае просто проигнорируйте его и перейдите к следующему ключу."
msg.NEXT_KEY = "Следующий ключ"
msg.CLEAR_KEY = "Очистить ключ"

--- About frame
msg.ABOUT_TITLE = "Musician"
msg.ABOUT_VERSION = "версия {version}"
msg.ABOUT_AUTHOR = "Автор LenweSaralonde - {url}"
msg.ABOUT_LICENSE = "Выпущено под лицензией GNU General Public License v3.0"
msg.ABOUT_DISCORD = "Discord: {url}"
msg.ABOUT_SUPPORT = "Тебе нравится Musician? Поделись со всеми!"
msg.ABOUT_PATREON = "Станьте патреоном: {url}"
msg.ABOUT_PAYPAL = "Пожертвовать (PayPal): {url}"
msg.ABOUT_SUPPORTERS = "Отдельное спасибо поддерживающим проект <3"
msg.ABOUT_LOCALIZATION_TEAM = "Команда переводчиков:"
msg.ABOUT_CONTRIBUTE_TO_LOCALIZATION = "Помогите нам перевести Musician на ваш язык!\n{url}"

--- Fixed PC keyboard key names
msg.FIXED_KEY_NAMES[KEY.Backspace] = "Назад"
msg.FIXED_KEY_NAMES[KEY.Tab] = "Вкладка"
msg.FIXED_KEY_NAMES[KEY.CapsLock] = "Caps Lock"
msg.FIXED_KEY_NAMES[KEY.Enter] = "Входить"
msg.FIXED_KEY_NAMES[KEY.ShiftLeft] = "Сдвиг"
msg.FIXED_KEY_NAMES[KEY.ShiftRight] = "Сдвиг"
msg.FIXED_KEY_NAMES[KEY.ControlLeft] = "Ctrl"
msg.FIXED_KEY_NAMES[KEY.MetaLeft] = "Мета"
msg.FIXED_KEY_NAMES[KEY.AltLeft] = "Alt"
msg.FIXED_KEY_NAMES[KEY.Space] = "Космос"
msg.FIXED_KEY_NAMES[KEY.AltRight] = "Alt"
msg.FIXED_KEY_NAMES[KEY.MetaRight] = "Мета"
msg.FIXED_KEY_NAMES[KEY.ContextMenu] = "Меню"
msg.FIXED_KEY_NAMES[KEY.ControlRight] = "Ctrl"
msg.FIXED_KEY_NAMES[KEY.Delete] = "Удалить"

--- Live keyboard layouts, based on musical modes
msg.KEYBOARD_LAYOUTS["Piano"] = "Пианино"
msg.KEYBOARD_LAYOUTS["Chromatic"] = "Хроматический"
msg.KEYBOARD_LAYOUTS["Modes"] = "Режимы"
msg.KEYBOARD_LAYOUTS["Ionian"] = "Ионический"
msg.KEYBOARD_LAYOUTS["Dorian"] = "Дориан"
msg.KEYBOARD_LAYOUTS["Phrygian"] = "Фригийский"
msg.KEYBOARD_LAYOUTS["Lydian"] = "Лидийский"
msg.KEYBOARD_LAYOUTS["Mixolydian"] = "Миксолидийский"
msg.KEYBOARD_LAYOUTS["Aeolian"] = "Эолийский"
msg.KEYBOARD_LAYOUTS["Locrian"] = "Локрийский"
msg.KEYBOARD_LAYOUTS["minor Harmonic"] = "минорная гармоника"
msg.KEYBOARD_LAYOUTS["minor Melodic"] = "минорный мелодический"
msg.KEYBOARD_LAYOUTS["Blues scales"] = "Блюзовые гаммы"
msg.KEYBOARD_LAYOUTS["Major Blues"] = "Мажорный блюз"
msg.KEYBOARD_LAYOUTS["minor Blues"] = "минорный блюз"
msg.KEYBOARD_LAYOUTS["Diminished scales"] = "Уменьшенные чешуйки"
msg.KEYBOARD_LAYOUTS["Diminished"] = "Уменьшено"
msg.KEYBOARD_LAYOUTS["Complement Diminished"] = "Дополнение уменьшено"
msg.KEYBOARD_LAYOUTS["Pentatonic scales"] = "Пентатонические весы"
msg.KEYBOARD_LAYOUTS["Major Pentatonic"] = "Мажорная пентатоника"
msg.KEYBOARD_LAYOUTS["minor Pentatonic"] = "минорная пентатоника"
msg.KEYBOARD_LAYOUTS["World scales"] = "Мировые масштабы"
msg.KEYBOARD_LAYOUTS["Raga 1"] = "Рага 1"
msg.KEYBOARD_LAYOUTS["Raga 2"] = "Рага 2"
msg.KEYBOARD_LAYOUTS["Raga 3"] = "Рага 3"
msg.KEYBOARD_LAYOUTS["Arabic"] = "арабский"
msg.KEYBOARD_LAYOUTS["Spanish"] = "испанский"
msg.KEYBOARD_LAYOUTS["Gypsy"] = "Цыганский"
msg.KEYBOARD_LAYOUTS["Egyptian"] = "Египтянин"
msg.KEYBOARD_LAYOUTS["Hawaiian"] = "Гавайский"
msg.KEYBOARD_LAYOUTS["Bali Pelog"] = "Бали Пелог"
msg.KEYBOARD_LAYOUTS["Japanese"] = "Японский"
msg.KEYBOARD_LAYOUTS["Ryukyu"] = "Рюкю"
msg.KEYBOARD_LAYOUTS["Chinese"] = "китайский язык"
msg.KEYBOARD_LAYOUTS["Miscellaneous scales"] = "Разные весы"
msg.KEYBOARD_LAYOUTS["Bass Line"] = "Басовая линия"
msg.KEYBOARD_LAYOUTS["Wholetone"] = "Wholetone"
msg.KEYBOARD_LAYOUTS["minor 3rd"] = "второстепенный 3-й"
msg.KEYBOARD_LAYOUTS["Major 3rd"] = "Майор 3-й"
msg.KEYBOARD_LAYOUTS["4th"] = "4-й"
msg.KEYBOARD_LAYOUTS["5th"] = "5-й"
msg.KEYBOARD_LAYOUTS["Octave"] = "Октава"

--- Live keyboard layout types
msg.HORIZONTAL_LAYOUT = "По горизонтали"
msg.VERTICAL_LAYOUT = "Вертикальный"

--- Live keyboard frame
msg.LIVE_SONG_NAME = "Живая песня"
msg.SOLO_MODE = "Соло режим"
msg.LIVE_MODE = "Живой режим"
msg.LIVE_MODE_DISABLED = "Живой режим отключен во время воспроизведения."
msg.ENABLE_SOLO_MODE = "Включите Solo Mode (вы играете за себя)"
msg.ENABLE_LIVE_MODE = "Включите Live Mode (вы играете для всех)"
msg.PLAY_LIVE = "Играть вживую"
msg.PLAY_SOLO = "Играть соло"
msg.SHOW_KEYBOARD = "Показать клавиатуру"
msg.HIDE_KEYBOARD = "Скрыть клавиатуру"
msg.KEYBOARD_LAYOUT = "Режим клавиатуры и масштаб"
msg.CHANGE_KEYBOARD_LAYOUT = "Изменить раскладку клавиатуры"
msg.BASE_KEY = "Базовый ключ"
msg.CHANGE_BASE_KEY = "Базовый ключ"
msg.CHANGE_LOWER_INSTRUMENT = "Заменить нижний инструмент"
msg.CHANGE_UPPER_INSTRUMENT = "Заменить верхний инструмент"
msg.LOWER_INSTRUMENT_MAPPED_TO_CHANNEL = "Нижний инструмент (трек № {track})"
msg.UPPER_INSTRUMENT_MAPPED_TO_CHANNEL = "Верхний инструмент (трек № {track})"
msg.SUSTAIN_KEY = "Поддерживать"
msg.POWER_CHORDS = "Силовые аккорды"
msg.PROGRAM_BUTTON = "P {num}"
msg.EMPTY_PROGRAM = "Пустая программа"
msg.LOAD_PROGRAM_NUM = "Загрузить программу # {num} ({key})"
msg.SAVE_PROGRAM_NUM = "Сохранить в программе № {num} ({key})"
msg.DELETE_PROGRAM_NUM = "Удалить программу № {num} ({key})"
msg.WRITE_PROGRAM = "Сохранить программу ({key})"
msg.DELETE_PROGRAM = "Удалить программу ({key})"
msg.PROGRAM_SAVED = "Программа № {num} сохранена."
msg.PROGRAM_DELETED = "Программа № {num} удалена."
msg.DEMO_MODE_ENABLED = "Включен демонстрационный режим клавиатуры:\n{mapping}"
msg.DEMO_MODE_MAPPING = "{layer} → Track # {track}"
msg.DEMO_MODE_DISABLED = "Демо-режим клавиатуры отключен."

--- Live keyboard layers
msg.LAYERS[Musician.KEYBOARD_LAYER.UPPER] = "Верхний"
msg.LAYERS[Musician.KEYBOARD_LAYER.LOWER] = "Ниже"

--- Chat emotes
msg.EMOTE_PLAYING_MUSIC = "играет песню."
msg.EMOTE_PROMO = "(Чтобы послушать, установите аддон \"Musician\")"
msg.EMOTE_SONG_NOT_LOADED = "(Песня не может воспроизвестись, потому что {player} использует несовместимую версию.)"
msg.EMOTE_PLAYER_OTHER_REALM = "(Этот игрок находится в другом мире.)"
msg.EMOTE_PLAYER_OTHER_FACTION = "(Этот игрок из другой фракции.)"

--- Minimap button tooltips
msg.TOOLTIP_LEFT_CLICK = "** Щелкните левой кнопкой мыши **: {action}"
msg.TOOLTIP_RIGHT_CLICK = "** Щелкните правой кнопкой мыши **: {action}"
msg.TOOLTIP_DRAG_AND_DROP = "** Перетащите **, чтобы переместить"
msg.TOOLTIP_ISMUTED = "(без звука)"
msg.TOOLTIP_ACTION_OPEN_MENU = "Открыть главное меню"
msg.TOOLTIP_ACTION_MUTE = "Отключить всю музыку"
msg.TOOLTIP_ACTION_UNMUTE = "Включить музыку"

--- Player menu options
msg.PLAYER_MENU_TITLE = "Музыка"
msg.PLAYER_MENU_STOP_CURRENT_SONG = "Остановить текущую песню"
msg.PLAYER_MENU_MUTE = "Немой"
msg.PLAYER_MENU_UNMUTE = "Включить звук"

--- Player actions feedback
msg.PLAYER_IS_MUTED = "{icon} {player} теперь отключен."
msg.PLAYER_IS_UNMUTED = "{icon} {player} теперь включен."

--- Song links
msg.LINKS_PREFIX = "Музыка"
msg.LINKS_FORMAT = "{prefix}: {title}"
msg.LINKS_LINK_BUTTON = "Ссылка на сайт"
msg.LINKS_CHAT_BUBBLE = "«{note} {title}»"

--- Song link export frame
msg.LINK_EXPORT_WINDOW_TITLE = "Создать ссылку на песню"
msg.LINK_EXPORT_WINDOW_SONG_TITLE_LABEL = "Название песни:"
msg.LINK_EXPORT_WINDOW_HINT = "Ссылка будет оставаться активной до тех пор, пока вы не выйдете из системы или не перезагрузите интерфейс."
msg.LINK_EXPORT_WINDOW_PROGRESS = "Создание ссылки… {progress}%"
msg.LINK_EXPORT_WINDOW_POST_BUTTON = "Опубликовать ссылку в чате"

--- Song link import frame
msg.LINK_IMPORT_WINDOW_TITLE = "Импортировать песню из {player}:"
msg.LINK_IMPORT_WINDOW_HINT = "Нажмите «Импорт», чтобы начать импорт песни в Musician."
msg.LINK_IMPORT_WINDOW_IMPORT_BUTTON = "Импортировать песню"
msg.LINK_IMPORT_WINDOW_CANCEL_IMPORT_BUTTON = "Отменить импорт"
msg.LINK_IMPORT_WINDOW_REQUESTING = "Запрос песни у {player}…"
msg.LINK_IMPORT_WINDOW_PROGRESS = "Импорт… {progress}%"
msg.LINK_IMPORT_WINDOW_SELECT_ACCOUNT = "Пожалуйста, выберите персонажа, из которого хотите получить песню:"

--- Song links errors
msg.LINKS_ERROR.notFound = "Песня «{title}» недоступна на {player}."
msg.LINKS_ERROR.alreadySending = "{player} уже отправил вам песню. Пожалуйста, попробуйте еще раз через несколько секунд."
msg.LINKS_ERROR.alreadyRequested = "Песня уже запрашивается у {player}."
msg.LINKS_ERROR.timeout = "{player} не ответил."
msg.LINKS_ERROR.offline = "{player} не вошел в World of Warcraft."
msg.LINKS_ERROR.importingFailed = "Не удалось импортировать композицию {title} из {player}."

--- Map tracking options
msg.MAP_OPTIONS_TITLE = "Карта"
msg.MAP_OPTIONS_SUB_TEXT = "Показать находящихся поблизости музыкантов, играющих:"
msg.MAP_OPTIONS_MINI_MAP = "На миникарте"
msg.MAP_OPTIONS_WORLD_MAP = "На карте мира"
msg.MAP_TRACKING_OPTIONS_TITLE = "Musician"
msg.MAP_TRACKING_OPTION_ACTIVE_MUSICIANS = "Musicianы играют"

--- Total RP Extended module
msg.TRPE_ITEM_NAME = "{title}"
msg.TRPE_ITEM_TOOLTIP_REQUIRES_MUSICIAN = "Требуется Musician"
msg.TRPE_ITEM_TOOLTIP_SHEET_MUSIC = "Ноты"
msg.TRPE_ITEM_USE_HINT = "Читать ноты"
msg.TRPE_ITEM_MUSICIAN_NOT_FOUND = "Вам необходимо установить последнюю версию дополнения «Musician», чтобы иметь возможность использовать этот элемент.\nПолучить с {url}"
msg.TRPE_ITEM_NOTES = "Импортируйте песню в Musician, чтобы воспроизвести ее для ближайших игроков.\n\nСкачать \"Musician\": {url}\n"

msg.TRPE_EXPORT_BUTTON = "Экспорт"
msg.TRPE_EXPORT_WINDOW_TITLE = "Экспорт песни как предмет Total RP"
msg.TRPE_EXPORT_WINDOW_LOCALE = "Язык товара:"
msg.TRPE_EXPORT_WINDOW_ADD_TO_BAG = "Добавить в сумку"
msg.TRPE_EXPORT_WINDOW_QUANTITY = "Количество:"
msg.TRPE_EXPORT_WINDOW_HINT_NEW = "Создайте в Total RP ноты, которыми можно будет торговать с другими игроками."
msg.TRPE_EXPORT_WINDOW_HINT_EXISTING = "Элемент для этой песни уже существует, он будет обновлен."
msg.TRPE_EXPORT_WINDOW_CREATE_ITEM_BUTTON = "Создать предмет"
msg.TRPE_EXPORT_WINDOW_PROGRESS = "Создание элемента… {progress}%"

--- Musician instrument names
msg.INSTRUMENT_NAMES["none"] = "(Никто)"
msg.INSTRUMENT_NAMES["accordion"] = "Аккордеон"
msg.INSTRUMENT_NAMES["bagpipe"] = "Волынка"
msg.INSTRUMENT_NAMES["dulcimer"] = "Дульцимер (забитый)"
msg.INSTRUMENT_NAMES["piano"] = "Рояль"
msg.INSTRUMENT_NAMES["lute"] = "Лютня"
msg.INSTRUMENT_NAMES["viola-da-gamba"] = "Виола да гамба"
msg.INSTRUMENT_NAMES["harp"] = "Кельтская арфа"
msg.INSTRUMENT_NAMES["male-voice"] = "Мужской голос (тенор)"
msg.INSTRUMENT_NAMES["female-voice"] = "Женский голос (сопрано)"
msg.INSTRUMENT_NAMES["trumpet"] = "Труба"
msg.INSTRUMENT_NAMES["sackbut"] = "Sackbut"
msg.INSTRUMENT_NAMES["war-horn"] = "Боевой рог"
msg.INSTRUMENT_NAMES["bassoon"] = "Фагот"
msg.INSTRUMENT_NAMES["clarinet"] = "Кларнет"
msg.INSTRUMENT_NAMES["recorder"] = "Рекордер"
msg.INSTRUMENT_NAMES["fiddle"] = "Скрипка"
msg.INSTRUMENT_NAMES["percussions"] = "Ударные (традиционные)"
msg.INSTRUMENT_NAMES["distortion-guitar"] = "Гитара искажения"
msg.INSTRUMENT_NAMES["clean-guitar"] = "Чистая гитара"
msg.INSTRUMENT_NAMES["bass-guitar"] = "Бас-гитара"
msg.INSTRUMENT_NAMES["drumkit"] = "Ударная установка"
msg.INSTRUMENT_NAMES["war-drum"] = "Барабан войны"
msg.INSTRUMENT_NAMES["woodblock"] = "Блок дерева"
msg.INSTRUMENT_NAMES["tambourine-shake"] = "Бубен (встряхнутый)"

--- General MIDI instrument names
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGrandPiano] = "Акустический рояль"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrightAcousticPiano] = "Яркое акустическое пианино"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGrandPiano] = "Электрический рояль"
msg.MIDI_INSTRUMENT_NAMES[Instrument.HonkyTonkPiano] = "Хонки-тонк фортепиано"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricPiano1] = "Электрическое пианино 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricPiano2] = "Электрическое пианино 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Harpsichord] = "Клавесин"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Clavi] = "Клави"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Celesta] = "Селеста"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Glockenspiel] = "Глокеншпиль"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MusicBox] = "Музыкальная коробка"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Vibraphone] = "Вибрафон"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Marimba] = "Маримба"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Xylophone] = "Ксилофон"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TubularBells] = "Трубчатые колокола"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Dulcimer] = "Цимбалы"
msg.MIDI_INSTRUMENT_NAMES[Instrument.DrawbarOrgan] = "Дышевый орган"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PercussiveOrgan] = "Ударный орган"
msg.MIDI_INSTRUMENT_NAMES[Instrument.RockOrgan] = "Рок-орган"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ChurchOrgan] = "Церковный орган"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ReedOrgan] = "Рид-орган"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Accordion] = "Аккордеон"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Harmonica] = "Гармоника"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TangoAccordion] = "Танго аккордеон"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGuitarNylon] = "Акустическая гитара (нейлон)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGuitarSteel] = "Акустическая гитара (сталь)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarJazz] = "Электрогитара (джаз)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarClean] = "Электрогитара (чистая)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarMuted] = "Электрогитара (без звука)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OverdrivenGuitar] = "Гитара с перегрузкой"
msg.MIDI_INSTRUMENT_NAMES[Instrument.DistortionGuitar] = "Гитара искажения"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Guitarharmonics] = "Гармоники гитары"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticBass] = "Акустический бас"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricBassFinger] = "Электрический бас (пальчиковый)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricBassPick] = "Электрический бас (выбранный)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FretlessBass] = "Безладовый бас"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SlapBass1] = "Шлепок бас 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SlapBass2] = "Шлепок бас 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBass1] = "Синтетический бас 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBass2] = "Синти-бас 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Violin] = "Скрипка"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Viola] = "Альт"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Cello] = "Виолончель"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Contrabass] = "Контрабас"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TremoloStrings] = "Струны тремоло"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PizzicatoStrings] = "Струны для пиццикато"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestralHarp] = "Оркестровая арфа"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Timpani] = "Литавры"
msg.MIDI_INSTRUMENT_NAMES[Instrument.StringEnsemble1] = "Ансамбль струн 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.StringEnsemble2] = "Струнный ансамбль 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthStrings1] = "Синтезаторные струны 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthStrings2] = "Синтетические струны 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ChoirAahs] = "Хор аас"
msg.MIDI_INSTRUMENT_NAMES[Instrument.VoiceOohs] = "Голос ох"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthVoice] = "Синтезаторный голос"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestraHit] = "Оркестровый хит"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Trumpet] = "Труба"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Trombone] = "Тромбон"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Tuba] = "Туба"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MutedTrumpet] = "Приглушенная труба"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FrenchHorn] = "валторна"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrassSection] = "Латунная секция"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBrass1] = "Синтетическая латунь 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBrass2] = "Синтетическая медь 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SopranoSax] = "Сопрано-саксофон"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AltoSax] = "Альтовый саксофон"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TenorSax] = "Теноровый саксофон"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BaritoneSax] = "Баритон-саксофон"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Oboe] = "Гобой"
msg.MIDI_INSTRUMENT_NAMES[Instrument.EnglishHorn] = "Английский рог"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Bassoon] = "Фагот"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Clarinet] = "Кларнет"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Piccolo] = "Пикколо"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Flute] = "Флейта"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Recorder] = "Рекордер"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PanFlute] = "Флейта Пана"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BlownBottle] = "Выдувная бутылка"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shakuhachi] = "Сякухати"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Whistle] = "Свист"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Ocarina] = "Окарина"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead1Square] = "Свинец 1 (квадрат)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead2Sawtooth] = "Свинец 2 (пилообразный)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead3Calliope] = "Отведение 3 (каллиопа)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead4Chiff] = "Свинец 4 (chiff)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead5Charang] = "Свинец 5 (чаранг)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead6Voice] = "Ведущий 6 (голос)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead7Fifths] = "Свинец 7 (пятый)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead8BassLead] = "Ведущий 8 (бас + ведущий)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad1Newage] = "Pad 1 (нью-эйдж)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad2Warm] = "Pad 2 (теплый)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad3Polysynth] = "Pad 3 (полисинт)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad4Choir] = "Пэд 4 (хор)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad5Bowed] = "Пэд 5 (изогнутый)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad6Metallic] = "Pad 6 (металлик)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad7Halo] = "Пэд 7 (нимб)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad8Sweep] = "Пэд 8 (развертка)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX1Rain] = "FX 1 (дождь)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX2Soundtrack] = "FX 2 (саундтрек)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX3Crystal] = "FX 3 (кристалл)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX4Atmosphere] = "FX 4 (атмосфера)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX5Brightness] = "FX 5 (яркость)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX6Goblins] = "FX 6 (гоблины)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX7Echoes] = "FX 7 (эхо)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX8SciFi] = "FX 8 (научная фантастика)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Sitar] = "Ситар"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Banjo] = "Банджо"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shamisen] = "Шамисен"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Koto] = "Кото"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Kalimba] = "Калимба"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Bagpipe] = "Мешок труба"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Fiddle] = "Скрипка"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shanai] = "Шанаи"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TinkleBell] = "Звон колокольчика"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Agogo] = "Агого"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SteelDrums] = "Стальные барабаны"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Woodblock] = "Блок дерева"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TaikoDrum] = "Барабан тайко"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MelodicTom] = "Мелодичный том"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthDrum] = "Синтезаторный барабан"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ReverseCymbal] = "Обратная тарелка"
msg.MIDI_INSTRUMENT_NAMES[Instrument.GuitarFretNoise] = "Гитарный лад"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BreathNoise] = "Шум дыхания"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Seashore] = "Морской берег"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BirdTweet] = "Птичий твит"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TelephoneRing] = "Телефонный звонок"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Helicopter] = "Вертолет"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Applause] = "Аплодисменты"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Gunshot] = "Выстрел"

--- General MIDI drum kit names
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_INSTRUMENT_NAMES[Instrument.StandardKit] = "Стандартная ударная установка"
msg.MIDI_INSTRUMENT_NAMES[Instrument.RoomKit] = "Барабанная установка для комнаты"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PowerKit] = "Ударная установка Power"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectronicKit] = "Электронная ударная установка"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TR808Kit] = "Драм-машина TR-808"
msg.MIDI_INSTRUMENT_NAMES[Instrument.JazzKit] = "Джазовая ударная установка"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrushKit] = "Щеточный барабан"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestraKit] = "Оркестровая ударная установка"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SoundFXKit] = "Звуковые эффекты"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MT32Kit] = "Ударная установка МТ-32"
msg.MIDI_INSTRUMENT_NAMES[Instrument.None] = "(Никто)"
msg.UNKNOWN_DRUMKIT = "Неизвестная ударная установка ({midi})"

--- General MIDI percussion list
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_PERCUSSION_NAMES[Percussion.Laser] = "Лазерный" -- MIDI key 27
msg.MIDI_PERCUSSION_NAMES[Percussion.Whip] = "Хлыст" -- MIDI key 28
msg.MIDI_PERCUSSION_NAMES[Percussion.ScratchPush] = "Скретч-толчок" -- MIDI key 29
msg.MIDI_PERCUSSION_NAMES[Percussion.ScratchPull] = "Царапина" -- MIDI key 30
msg.MIDI_PERCUSSION_NAMES[Percussion.StickClick] = "Палка щелчок" -- MIDI key 31
msg.MIDI_PERCUSSION_NAMES[Percussion.SquareClick] = "Квадратный щелчок" -- MIDI key 32
msg.MIDI_PERCUSSION_NAMES[Percussion.MetronomeClick] = "Щелчок метронома" -- MIDI key 33
msg.MIDI_PERCUSSION_NAMES[Percussion.MetronomeBell] = "Звонок метронома" -- MIDI key 34
msg.MIDI_PERCUSSION_NAMES[Percussion.AcousticBassDrum] = "Акустический бас-барабан" -- MIDI key 35
msg.MIDI_PERCUSSION_NAMES[Percussion.BassDrum1] = "Большой барабан 1" -- MIDI key 36
msg.MIDI_PERCUSSION_NAMES[Percussion.SideStick] = "Боковой стик" -- MIDI key 37
msg.MIDI_PERCUSSION_NAMES[Percussion.AcousticSnare] = "Акустическая ловушка" -- MIDI key 38
msg.MIDI_PERCUSSION_NAMES[Percussion.HandClap] = "Хлопок в ладоши" -- MIDI key 39
msg.MIDI_PERCUSSION_NAMES[Percussion.ElectricSnare] = "Электрический малый барабан" -- MIDI key 40
msg.MIDI_PERCUSSION_NAMES[Percussion.LowFloorTom] = "Том с низким полом" -- MIDI key 41
msg.MIDI_PERCUSSION_NAMES[Percussion.ClosedHiHat] = "Закрытый хай-хет" -- MIDI key 42
msg.MIDI_PERCUSSION_NAMES[Percussion.HighFloorTom] = "Том высокого этажа" -- MIDI key 43
msg.MIDI_PERCUSSION_NAMES[Percussion.PedalHiHat] = "Педальный хай-хет" -- MIDI key 44
msg.MIDI_PERCUSSION_NAMES[Percussion.LowTom] = "Низкий том" -- MIDI key 45
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenHiHat] = "Открытый хай-хет" -- MIDI key 46
msg.MIDI_PERCUSSION_NAMES[Percussion.LowMidTom] = "Низко-средний том" -- MIDI key 47
msg.MIDI_PERCUSSION_NAMES[Percussion.HiMidTom] = "Привет-средний том" -- MIDI key 48
msg.MIDI_PERCUSSION_NAMES[Percussion.CrashCymbal1] = "Тарелка Crash 1" -- MIDI key 49
msg.MIDI_PERCUSSION_NAMES[Percussion.HighTom] = "Высокий том" -- MIDI key 50
msg.MIDI_PERCUSSION_NAMES[Percussion.RideCymbal1] = "Тарелка райд 1" -- MIDI key 51
msg.MIDI_PERCUSSION_NAMES[Percussion.ChineseCymbal] = "Китайская тарелка" -- MIDI key 52
msg.MIDI_PERCUSSION_NAMES[Percussion.RideBell] = "Поездка на колокол" -- MIDI key 53
msg.MIDI_PERCUSSION_NAMES[Percussion.Tambourine] = "Бубен" -- MIDI key 54
msg.MIDI_PERCUSSION_NAMES[Percussion.SplashCymbal] = "Тарелка Splash" -- MIDI key 55
msg.MIDI_PERCUSSION_NAMES[Percussion.Cowbell] = "Cowbell" -- MIDI key 56
msg.MIDI_PERCUSSION_NAMES[Percussion.CrashCymbal2] = "Тарелка Crash 2" -- MIDI key 57
msg.MIDI_PERCUSSION_NAMES[Percussion.Vibraslap] = "Виброзащита" -- MIDI key 58
msg.MIDI_PERCUSSION_NAMES[Percussion.RideCymbal2] = "Тарелка райд 2" -- MIDI key 59
msg.MIDI_PERCUSSION_NAMES[Percussion.HiBongo] = "Привет бонго" -- MIDI key 60
msg.MIDI_PERCUSSION_NAMES[Percussion.LowBongo] = "Низкое бонго" -- MIDI key 61
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteHiConga] = "Mute привет Конга" -- MIDI key 62
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenHiConga] = "Открыть привет конга" -- MIDI key 63
msg.MIDI_PERCUSSION_NAMES[Percussion.LowConga] = "Низкая конга" -- MIDI key 64
msg.MIDI_PERCUSSION_NAMES[Percussion.HighTimbale] = "Высокий тимбал" -- MIDI key 65
msg.MIDI_PERCUSSION_NAMES[Percussion.LowTimbale] = "Низкий тимбал" -- MIDI key 66
msg.MIDI_PERCUSSION_NAMES[Percussion.HighAgogo] = "Высокий agogo" -- MIDI key 67
msg.MIDI_PERCUSSION_NAMES[Percussion.LowAgogo] = "Низкий агого" -- MIDI key 68
msg.MIDI_PERCUSSION_NAMES[Percussion.Cabasa] = "Cabasa" -- MIDI key 69
msg.MIDI_PERCUSSION_NAMES[Percussion.Maracas] = "Маракасы" -- MIDI key 70
msg.MIDI_PERCUSSION_NAMES[Percussion.ShortWhistle] = "Короткий свисток" -- MIDI key 71
msg.MIDI_PERCUSSION_NAMES[Percussion.LongWhistle] = "Длинный свисток" -- MIDI key 72
msg.MIDI_PERCUSSION_NAMES[Percussion.ShortGuiro] = "Короткий гуйро" -- MIDI key 73
msg.MIDI_PERCUSSION_NAMES[Percussion.LongGuiro] = "Длинный гуйро" -- MIDI key 74
msg.MIDI_PERCUSSION_NAMES[Percussion.Claves] = "Клавес" -- MIDI key 75
msg.MIDI_PERCUSSION_NAMES[Percussion.HiWoodBlock] = "Привет деревянный блок" -- MIDI key 76
msg.MIDI_PERCUSSION_NAMES[Percussion.LowWoodBlock] = "Низкий деревянный блок" -- MIDI key 77
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteCuica] = "Mute cuica" -- MIDI key 78
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenCuica] = "Open cuica" -- MIDI key 79
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteTriangle] = "Треугольник отключения звука" -- MIDI key 80
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenTriangle] = "Открытый треугольник" -- MIDI key 81
msg.MIDI_PERCUSSION_NAMES[Percussion.Shaker] = "Шейкер" -- MIDI key 82
msg.MIDI_PERCUSSION_NAMES[Percussion.SleighBell] = "Сани колокольчик" -- MIDI key 83
msg.MIDI_PERCUSSION_NAMES[Percussion.BellTree] = "Колокольчик" -- MIDI key 84
msg.MIDI_PERCUSSION_NAMES[Percussion.Castanets] = "Кастаньеты" -- MIDI key 85
msg.MIDI_PERCUSSION_NAMES[Percussion.SurduDeadStroke] = "Сурду мертвый инсульт" -- MIDI key 86
msg.MIDI_PERCUSSION_NAMES[Percussion.Surdu] = "Сурду" -- MIDI key 87
msg.MIDI_PERCUSSION_NAMES[Percussion.SnareDrumRod] = "Стержень малого барабана" -- MIDI key 88
msg.MIDI_PERCUSSION_NAMES[Percussion.OceanDrum] = "Океанский барабан" -- MIDI key 89
msg.MIDI_PERCUSSION_NAMES[Percussion.SnareDrumBrush] = "Щетка для малого барабана" -- MIDI key 90
