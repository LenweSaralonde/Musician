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

local msg = Musician.InitLocale("ko", "한국어", "koKR")

local Instrument = Musician.MIDI_INSTRUMENTS
local Percussion = Musician.MIDI_PERCUSSIONS
local KEY = Musician.KEYBOARD_KEY

------------------------------------------------------------------------
---------------- ↑↑↑ DO NOT EDIT THE LINES ABOVE ! ↑↑↑  ----------------
------------------------------------------------------------------------

--- Main frame controls
msg.PLAY = "플레이"
msg.STOP = "중지"
msg.PAUSE = "중지"
msg.TEST_SONG = "시사"
msg.STOP_TEST = "미리보기 중지"
msg.CLEAR = "맑은"
msg.SELECT_ALL = "모두 선택"
msg.EDIT = "편집하다"
msg.MUTE = "음소거"
msg.UNMUTE = "음소거 해제"

--- Minimap button menu
msg.MENU_TITLE = "Musician"
msg.MENU_IMPORT_SONG = "노래 가져 오기 및 재생"
msg.MENU_PLAY = "플레이"
msg.MENU_STOP = "중지"
msg.MENU_PLAY_PREVIEW = "시사"
msg.MENU_STOP_PREVIEW = "미리보기 중지"
msg.MENU_LIVE_PLAY = "라이브 플레이"
msg.MENU_SHOW_KEYBOARD = "키보드 열기"
msg.MENU_SETTINGS = "설정"
msg.MENU_OPTIONS = "옵션"
msg.MENU_ABOUT = "약"

--- Chat commands
msg.COMMAND_LIST_TITLE = "뮤지션 명령 :"
msg.COMMAND_SHOW = "노래 가져 오기 창보기"
msg.COMMAND_PREVIEW_PLAY = "노래 미리보기 시작 또는 중지"
msg.COMMAND_PREVIEW_STOP = "노래 미리보기 중지"
msg.COMMAND_PLAY = "노래 재생 또는 중지"
msg.COMMAND_STOP = "노래 재생 중지"
msg.COMMAND_MUTE = "모든 음악 음소거"
msg.COMMAND_UNMUTE = "음악 음소거 해제"
msg.COMMAND_SONG_EDITOR = "노래 편집기 열기"
msg.COMMAND_LIVE_KEYBOARD = "라이브 키보드 열기"
msg.COMMAND_CONFIGURE_KEYBOARD = "키보드 구성"
msg.COMMAND_LIVE_DEMO = "키보드 데모 모드"
msg.COMMAND_LIVE_DEMO_PARAMS = "{** <위쪽 트랙 #> ** ** <아래쪽 트랙 #> ** || ** 꺼짐 **}"
msg.COMMAND_HELP = "이 도움말 메시지 표시"
msg.ERR_COMMAND_UNKNOWN = "알 수없는“{command}”명령입니다. 명령 목록을 얻으려면 {help}를 입력하십시오."

--- Add-on options
msg.OPTIONS_TITLE = "Musician"
msg.OPTIONS_SUB_TEXT = "Discord 서버에 가입하여 지원을 받으세요! {url}"
msg.OPTIONS_CATEGORY_EMOTE = "감정 표현"
msg.OPTIONS_ENABLE_EMOTE_LABEL = "노래를 재생할 때 뮤지션이없는 플레이어에게 텍스트 이모티콘을 보냅니다."
msg.OPTIONS_ENABLE_EMOTE_PROMO_LABEL = "사용자가 재생하는 음악을들을 수 있도록 설치를 요청하는 짧은 텍스트를 포함합니다."
msg.OPTIONS_EMOTE_HINT = "노래를 재생할 때 뮤지션이없는 플레이어에게 텍스트 이모티콘이 표시됩니다. [옵션]에서 비활성화 할 수 있습니다."
msg.OPTIONS_INTEGRATION_OPTIONS_TITLE = "게임 내 통합 옵션"
msg.OPTIONS_AUTO_MUTE_GAME_MUSIC_LABEL = "노래가 재생되는 동안 게임 내 음악을 음소거합니다."
msg.OPTIONS_MUTE_INSTRUMENT_TOYS_LABEL = "악기 장난감에서 음악을 음소거합니다. {icons}"
msg.OPTIONS_AUDIO_CHANNELS_TITLE = "오디오 채널"
msg.OPTIONS_AUDIO_CHANNELS_HINT = "Musician이 동시에 재생할 수있는 최대 음표 수를 늘리려면 더 많은 오디오 채널을 선택하십시오."
msg.OPTIONS_AUDIO_CHANNELS_CHANNEL_POLYPHONY = "{channel} ({polyphony})"
msg.OPTIONS_AUDIO_CHANNELS_TOTAL_POLYPHONY = "총 최대 동시 발음 수 : {polyphony}"
msg.OPTIONS_AUDIO_CHANNELS_AUTO_ADJUST_CONFIG = "여러 오디오 채널이 선택되면 자동으로 오디오 설정을 최적화합니다."
msg.OPTIONS_AUDIO_CACHE_SIZE_FOR_MUSICIAN = "Musician에게 권장(%dMB)"
msg.OPTIONS_CATEGORY_SHORTCUTS = "바로 가기"
msg.OPTIONS_SHORTCUT_MINIMAP = "미니맵 버튼"
msg.OPTIONS_SHORTCUT_ADDON_MENU = "미니맵 메뉴"
msg.OPTIONS_QUICK_PRELOADING_TITLE = "빠른 사전 로드"
msg.OPTIONS_QUICK_PRELOADING_TEXT = "콜드 스타트 시 기기의 빠른 사전 로드를 활성화합니다."
msg.OPTIONS_CATEGORY_NAMEPLATES = "명판 및 애니메이션"
msg.OPTIONS_CATEGORY_NAMEPLATES_SUB_TEXT = "명판을 사용하여 음악을 재생하는 캐릭터의 애니메이션을보고\n누가 당신을 한 눈에들을 수 있는지 찾아보세요."
msg.OPTIONS_ENABLE_NAMEPLATES = "명판과 애니메이션을 활성화합니다."
msg.OPTIONS_SHOW_NAMEPLATE_ICON = "Musician이있는 플레이어의 이름 옆에 {icon} 아이콘을 표시합니다."
msg.OPTIONS_HIDE_HEALTH_BARS = "전투 중이 아닐 때 플레이어와 아군 유닛 체력 바를 숨 깁니다."
msg.OPTIONS_HIDE_NPC_NAMEPLATES = "NPC 명판을 숨 깁니다."
msg.OPTIONS_CINEMATIC_MODE = "{binding}으로 UI가 숨겨지면 애니메이션을 표시합니다."
msg.OPTIONS_CINEMATIC_MODE_NO_BINDING = "UI가 숨겨져있을 때 애니메이션을 표시합니다."
msg.OPTIONS_NAMEPLATES_CINEMATIC_MODE = "UI가 숨겨지면 명판을 표시합니다."
msg.OPTIONS_TRP3 = "총 RP 3"
msg.OPTIONS_TRP3_MAP_SCAN = "지도에 Musician가있는 플레이어를 {icon} 아이콘으로 스캔하여 보여줍니다."
msg.OPTIONS_CROSS_RP_TITLE = "크로스 RP"
msg.OPTIONS_CROSS_RP_SUB_TEXT = "Tammya-MoonGuard의 Cross RP 애드온을 설치하여\n교차 파 및 교차 영역 음악을 활성화하세요!"
msg.OPTIONS_CROSS_RP_SUB_TEXT_NO_GATEWAY = "현재 사용 가능한 Cross RP 노드가 없습니다.\n잠시만 기다려주세요…"
msg.OPTIONS_CROSS_RP_SUB_TEXT_ACTIVE = "교차 RP 통신은 다음 위치에서 활성화됩니다.\n\n{bands}"

--- Tips and Tricks
msg.TIPS_AND_TRICKS_ENABLE = "시작시 팁과 요령을 보여줍니다."

msg.TIPS_AND_TRICKS_NAMEPLATES_TITLE = "애니메이션 및 명판"
msg.TIPS_AND_TRICKS_NAMEPLATES_TEXT = "명판이 활성화되면 음악을 재생하는 캐릭터에게 특별한 애니메이션이 표시됩니다.\n\n아이콘 {icon}은 또한 뮤지션이 있고 내 목소리를들을 수있는 사람을 나타냅니다.\n\n지금 명판과 애니메이션을 사용 하시겠습니까?"
msg.TIPS_AND_TRICKS_NAMEPLATES_OK = "명판 및 애니메이션 활성화"
msg.TIPS_AND_TRICKS_NAMEPLATES_CANCEL = "나중"

msg.TIPS_AND_TRICKS_CROSS_RP_TITLE = "Cross RP와 함께하는 크로스 팩션 음악"
msg.TIPS_AND_TRICKS_CROSS_RP_TEXT = "Tammya-MoonGuard의 Cross RP 애드온을 설치하여\n교차 파 및 교차 영역 음악을 활성화하세요!"
msg.TIPS_AND_TRICKS_CROSS_RP_OK = "확인"

--- Welcome messages
msg.STARTUP = "Musician v {version}에 오신 것을 환영합니다."
msg.PLAYER_COUNT_ONLINE = "주변에 {count} 명의 다른 음악 팬이 있습니다!"
msg.PLAYER_COUNT_ONLINE_ONE = "주위에 또 다른 음악 팬이 있습니다!"
msg.PLAYER_COUNT_ONLINE_NONE = "아직 다른 음악 팬이 없습니다."

--- New version notifications
msg.NEW_VERSION = "Musician의 새 버전이 출시되었습니다! {url}에서 업데이트를 다운로드하십시오."
msg.NEW_PROTOCOL_VERSION = "Musician 버전이 오래되어 더 이상 작동하지 않습니다.\n\n{url}에서 업데이트를 다운로드하십시오."

-- Module warnings
msg.ERR_INCOMPATIBLE_MODULE_API = "{module}이(가) 호환되지 않기 때문에 {module}용 Musician 모듈을 시작할 수 없습니다. Musician 및 {module}을(를) 업데이트해 보십시오."

-- Loading screen
msg.LOADING_SCREEN_MESSAGE = "Musician 이 악기 샘플을 캐시 메모리에 미리 로드하고 있습니다…"
msg.LOADING_SCREEN_CLOSE_TOOLTIP = "닫고 백그라운드에서 사전 로드를 계속합니다."

--- Player tooltips
msg.PLAYER_TOOLTIP = "Musician"
msg.PLAYER_TOOLTIP_VERSION = "{name} v{version}"
msg.PLAYER_TOOLTIP_VERSION_OUTDATED = " (시대에 뒤쳐진)"
msg.PLAYER_TOOLTIP_VERSION_INCOMPATIBLE = " (호환 불가)"
msg.PLAYER_TOOLTIP_PRELOADING = "소리 미리로드 중… ({progress})"

--- URL hyperlinks tooltip
msg.TOOLTIP_COPY_URL = "{shortcut}를 눌러 복사합니다."

--- Song import
msg.INVALID_MUSIC_CODE = "잘못된 음악 코드입니다."
msg.PLAY_A_SONG = "노래 재생"
msg.IMPORT_A_SONG = "노래 가져 오기"
msg.PASTE_MUSIC_CODE = "다음 위치에서 MIDI 형식으로 노래를 가져옵니다.\n{url}\n\n여기에 음악 코드를 붙여 넣으세요 ({shortcut})…"
msg.SONG_IMPORTED = "로드 된 노래 : {title}."

--- Play as a band
msg.PLAY_IN_BAND = "밴드로 플레이"
msg.PLAY_IN_BAND_HINT = "밴드와 함께이 노래를 연주 할 준비가 되었으면 여기를 클릭하십시오."
msg.PLAY_IN_BAND_READY_PLAYERS = "준비된 밴드 멤버 :"
msg.EMOTE_PLAYER_IS_READY = "밴드로 연주 할 준비가되었습니다."
msg.EMOTE_PLAYER_IS_NOT_READY = "더 이상 밴드로 연주 할 준비가되지 않았습니다."
msg.EMOTE_PLAY_IN_BAND_START = "밴드 연주를 시작했습니다."
msg.EMOTE_PLAY_IN_BAND_STOP = "밴드 연주를 중단했습니다."

--- Play as a band (live)
msg.LIVE_SYNC = "밴드로 라이브 플레이"
msg.LIVE_SYNC_HINT = "밴드 동기화를 활성화하려면 여기를 클릭하십시오."
msg.SYNCED_PLAYERS = "라이브 밴드 멤버 :"
msg.EMOTE_PLAYER_LIVE_SYNC_ENABLED = "당신과 함께 음악을 연주하고 있습니다."
msg.EMOTE_PLAYER_LIVE_SYNC_DISABLED = "당신과 함께 음악 재생을 중단했습니다."

--- Song editor frame
msg.SONG_EDITOR = "노래 편집기"
msg.MARKER_FROM = "에서"
msg.MARKER_TO = "에"
msg.POSITION = "위치"
msg.TRACK_NUMBER = "트랙 # {track}"
msg.CHANNEL_NUMBER_SHORT = "Ch. {channel}"
msg.JUMP_PREV = "10 초 뒤로"
msg.JUMP_NEXT = "앞으로 10 초"
msg.GO_TO_START = "시작으로 이동"
msg.GO_TO_END = "끝으로 이동"
msg.SET_CROP_FROM = "시작점 설정"
msg.SET_CROP_TO = "끝점 설정"
msg.SYNCHRONIZE_TRACKS = "현재 노래와 트랙 설정 동기화"
msg.MUTE_TRACK = "음소거"
msg.SOLO_TRACK = "독주"
msg.ACCENT_TRACK = "강조"
msg.TRANSPOSE_TRACK = "조옮김 (옥타브)"
msg.CHANGE_TRACK_INSTRUMENT = "악기 변경"
msg.HEADER_NUMBER = "#"
msg.HEADER_OCTAVE = "옥타브"
msg.HEADER_INSTRUMENT = "악기"
msg.HEADER_ACCENT = "x2"

--- Configure live keyboard frame
msg.SHOULD_CONFIGURE_KEYBOARD = "연주하기 전에 키보드를 구성해야합니다."
msg.CONFIGURE_KEYBOARD = "키보드 구성"
msg.CONFIGURE_KEYBOARD_HINT = "설정할 키를 클릭하세요…"
msg.CONFIGURE_KEYBOARD_HINT_COMPLETE = "키보드 구성이 완료되었습니다.\n이제 변경 사항을 저장하고 음악 재생을 시작할 수 있습니다!"
msg.CONFIGURE_KEYBOARD_START_OVER = "다시 시작하다"
msg.CONFIGURE_KEYBOARD_SAVE = "구성 저장"
msg.PRESS_KEY_BINDING = "# {row} 행에서 # {col} 키를 누릅니다."
msg.KEY_CAN_BE_EMPTY = "이 키는 선택 사항이며 비어있을 수 있습니다."
msg.KEY_IS_MERGEABLE = "이 키는 키보드의 {key} 키와 동일 할 수 있습니다. {action}"
msg.KEY_CAN_BE_MERGED = "이 경우 {key} 키를 누르기 만하면됩니다."
msg.KEY_CANNOT_BE_MERGED = "이 경우 무시하고 다음 키로 진행하십시오."
msg.NEXT_KEY = "다음 키"
msg.CLEAR_KEY = "지우기 키"

--- About frame
msg.ABOUT_TITLE = "Musician"
msg.ABOUT_VERSION = "버전 {version}"
msg.ABOUT_AUTHOR = "LenweSaralonde – {url}"
msg.ABOUT_LICENSE = "GNU General Public License v3.0에 따라 출시되었습니다."
msg.ABOUT_DISCORD = "불화 : {url}"
msg.ABOUT_SUPPORT = "뮤지션 좋아하세요? 모두와 공유하세요!"
msg.ABOUT_PATREON = "후원자되기 : {url}"
msg.ABOUT_PAYPAL = "기부 : {url}"
msg.ABOUT_SUPPORTERS = "프로젝트의 지지자들에게 특별한 감사 <3"
msg.ABOUT_LOCALIZATION_TEAM = "번역 팀 :"
msg.ABOUT_CONTRIBUTE_TO_LOCALIZATION = "Musician 를 귀하의 언어로 번역하도록 도와주세요!\n{url}"

--- Fixed PC keyboard key names
msg.FIXED_KEY_NAMES[KEY.Backspace] = "뒤"
msg.FIXED_KEY_NAMES[KEY.Tab] = "탭"
msg.FIXED_KEY_NAMES[KEY.CapsLock] = "Caps Lock"
msg.FIXED_KEY_NAMES[KEY.Enter] = "시작하다"
msg.FIXED_KEY_NAMES[KEY.ShiftLeft] = "시프트"
msg.FIXED_KEY_NAMES[KEY.ShiftRight] = "시프트"
msg.FIXED_KEY_NAMES[KEY.ControlLeft] = "Ctrl"
msg.FIXED_KEY_NAMES[KEY.MetaLeft] = "메타"
msg.FIXED_KEY_NAMES[KEY.AltLeft] = "Alt"
msg.FIXED_KEY_NAMES[KEY.Space] = "우주"
msg.FIXED_KEY_NAMES[KEY.AltRight] = "Alt"
msg.FIXED_KEY_NAMES[KEY.MetaRight] = "메타"
msg.FIXED_KEY_NAMES[KEY.ContextMenu] = "메뉴"
msg.FIXED_KEY_NAMES[KEY.ControlRight] = "Ctrl"
msg.FIXED_KEY_NAMES[KEY.Delete] = "지우다"

--- Live keyboard layouts, based on musical modes
msg.KEYBOARD_LAYOUTS["Piano"] = "피아노"
msg.KEYBOARD_LAYOUTS["Chromatic"] = "색채"
msg.KEYBOARD_LAYOUTS["Modes"] = "모드"
msg.KEYBOARD_LAYOUTS["Ionian"] = "이오니아"
msg.KEYBOARD_LAYOUTS["Dorian"] = "도리스 사람"
msg.KEYBOARD_LAYOUTS["Phrygian"] = "프리지아 인"
msg.KEYBOARD_LAYOUTS["Lydian"] = "리디안"
msg.KEYBOARD_LAYOUTS["Mixolydian"] = "Mixolydian"
msg.KEYBOARD_LAYOUTS["Aeolian"] = "에 올리 언"
msg.KEYBOARD_LAYOUTS["Locrian"] = "로크 리안"
msg.KEYBOARD_LAYOUTS["minor Harmonic"] = "마이너 고조파"
msg.KEYBOARD_LAYOUTS["minor Melodic"] = "마이너 멜로딕"
msg.KEYBOARD_LAYOUTS["Blues scales"] = "블루스 비늘"
msg.KEYBOARD_LAYOUTS["Major Blues"] = "메이저 블루스"
msg.KEYBOARD_LAYOUTS["minor Blues"] = "마이너 블루스"
msg.KEYBOARD_LAYOUTS["Diminished scales"] = "감소 된 비늘"
msg.KEYBOARD_LAYOUTS["Diminished"] = "감소"
msg.KEYBOARD_LAYOUTS["Complement Diminished"] = "보완 감소"
msg.KEYBOARD_LAYOUTS["Pentatonic scales"] = "오음 비늘"
msg.KEYBOARD_LAYOUTS["Major Pentatonic"] = "주요 오순절"
msg.KEYBOARD_LAYOUTS["minor Pentatonic"] = "마이너 오순절"
msg.KEYBOARD_LAYOUTS["World scales"] = "세계 저울"
msg.KEYBOARD_LAYOUTS["Raga 1"] = "라가 1"
msg.KEYBOARD_LAYOUTS["Raga 2"] = "라가 2"
msg.KEYBOARD_LAYOUTS["Raga 3"] = "라가 3"
msg.KEYBOARD_LAYOUTS["Arabic"] = "아라비아 말"
msg.KEYBOARD_LAYOUTS["Spanish"] = "스페인의"
msg.KEYBOARD_LAYOUTS["Gypsy"] = "집시"
msg.KEYBOARD_LAYOUTS["Egyptian"] = "이집트 사람"
msg.KEYBOARD_LAYOUTS["Hawaiian"] = "하와이안"
msg.KEYBOARD_LAYOUTS["Bali Pelog"] = "발리 펠 로그"
msg.KEYBOARD_LAYOUTS["Japanese"] = "일본어"
msg.KEYBOARD_LAYOUTS["Ryukyu"] = "류큐"
msg.KEYBOARD_LAYOUTS["Chinese"] = "중국말"
msg.KEYBOARD_LAYOUTS["Miscellaneous scales"] = "기타 저울"
msg.KEYBOARD_LAYOUTS["Bass Line"] = "베이스 라인"
msg.KEYBOARD_LAYOUTS["Wholetone"] = "통음"
msg.KEYBOARD_LAYOUTS["minor 3rd"] = "마이너 3"
msg.KEYBOARD_LAYOUTS["Major 3rd"] = "주요 3 차"
msg.KEYBOARD_LAYOUTS["4th"] = "4 위"
msg.KEYBOARD_LAYOUTS["5th"] = "5 위"
msg.KEYBOARD_LAYOUTS["Octave"] = "옥타브"

--- Live keyboard layout types
msg.HORIZONTAL_LAYOUT = "수평"
msg.VERTICAL_LAYOUT = "세로"

--- Live keyboard frame
msg.LIVE_SONG_NAME = "라이브 노래"
msg.SOLO_MODE = "솔로 모드"
msg.LIVE_MODE = "라이브 모드"
msg.LIVE_MODE_DISABLED = "재생 중에는 라이브 모드가 비활성화됩니다."
msg.ENABLE_SOLO_MODE = "솔로 모드 활성화 (직접 플레이)"
msg.ENABLE_LIVE_MODE = "라이브 모드 활성화 (모든 사람을 위해 플레이)"
msg.PLAY_LIVE = "라이브 플레이"
msg.PLAY_SOLO = "솔로 플레이"
msg.SHOW_KEYBOARD = "키보드 표시"
msg.HIDE_KEYBOARD = "키보드 숨기기"
msg.KEYBOARD_LAYOUT = "키보드 모드 및 스케일"
msg.CHANGE_KEYBOARD_LAYOUT = "키보드 레이아웃 변경"
msg.BASE_KEY = "기본 키"
msg.CHANGE_BASE_KEY = "기본 키"
msg.CHANGE_LOWER_INSTRUMENT = "하단 악기 변경"
msg.CHANGE_UPPER_INSTRUMENT = "상단 악기 변경"
msg.LOWER_INSTRUMENT_MAPPED_TO_CHANNEL = "하단 악기 (트랙 # {track})"
msg.UPPER_INSTRUMENT_MAPPED_TO_CHANNEL = "상단 악기 (트랙 # {track})"
msg.SUSTAIN_KEY = "버티다"
msg.POWER_CHORDS = "파워 코드"
msg.PROGRAM_BUTTON = "P {num}"
msg.EMPTY_PROGRAM = "빈 프로그램"
msg.LOAD_PROGRAM_NUM = "로드 프로그램 # {num} ({key})"
msg.SAVE_PROGRAM_NUM = "프로그램 # {num} ({key})에 저장"
msg.DELETE_PROGRAM_NUM = "프로그램 # {num} ({key}) 지우기"
msg.WRITE_PROGRAM = "프로그램 저장 ({key})"
msg.DELETE_PROGRAM = "프로그램 삭제 ({key})"
msg.PROGRAM_SAVED = "프로그램 # {num}이 저장되었습니다."
msg.PROGRAM_DELETED = "프로그램 # {num}이 지워졌습니다."
msg.DEMO_MODE_ENABLED = "키보드 데모 모드 활성화 :\n{mapping}"
msg.DEMO_MODE_MAPPING = "{layer} → 트랙 # {track}"
msg.DEMO_MODE_DISABLED = "키보드 데모 모드가 비활성화되었습니다."

--- Live keyboard layers
msg.LAYERS[Musician.KEYBOARD_LAYER.UPPER] = "높은"
msg.LAYERS[Musician.KEYBOARD_LAYER.LOWER] = "보다 낮은"

--- Chat emotes
msg.EMOTE_PLAYING_MUSIC = "노래를 재생하고 있습니다."
msg.EMOTE_PROMO = "(듣려면 \"Musician\"추가 기능을 다운로드하십시오)"
msg.EMOTE_SONG_NOT_LOADED = "({player}가 호환되지 않는 버전을 사용 중이므로 노래를 재생할 수 없습니다.)"
msg.EMOTE_PLAYER_OTHER_REALM = "(이 플레이어는 다른 영역에 있습니다.)"
msg.EMOTE_PLAYER_OTHER_FACTION = "(이 플레이어는 다른 진영 출신입니다.)"

--- Minimap button tooltips
msg.TOOLTIP_LEFT_CLICK = "** 왼쪽 클릭 ** : {action}"
msg.TOOLTIP_RIGHT_CLICK = "** 오른쪽 클릭 ** : {action}"
msg.TOOLTIP_DRAG_AND_DROP = "이동하려면 ** 드래그 앤 드롭 **"
msg.TOOLTIP_ISMUTED = "(음소거 됨)"
msg.TOOLTIP_ACTION_OPEN_MENU = "메인 메뉴 열기"
msg.TOOLTIP_ACTION_MUTE = "모든 음악 음소거"
msg.TOOLTIP_ACTION_UNMUTE = "음악 음소거 해제"

--- Player menu options
msg.PLAYER_MENU_TITLE = "음악"
msg.PLAYER_MENU_STOP_CURRENT_SONG = "현재 노래 중지"
msg.PLAYER_MENU_MUTE = "음소거"
msg.PLAYER_MENU_UNMUTE = "음소거 해제"

--- Player actions feedback
msg.PLAYER_IS_MUTED = "이제 {icon} {player}가 음소거되었습니다."
msg.PLAYER_IS_UNMUTED = "이제 {icon} {player}의 음소거가 해제되었습니다."

--- Song links
msg.LINKS_PREFIX = "음악"
msg.LINKS_FORMAT = "{prefix} : {title}"
msg.LINKS_LINK_BUTTON = "링크"
msg.LINKS_CHAT_BUBBLE = "“{note} {title}”"

--- Song link export frame
msg.LINK_EXPORT_WINDOW_TITLE = "노래 링크 만들기"
msg.LINK_EXPORT_WINDOW_SONG_TITLE_LABEL = "노래 제목:"
msg.LINK_EXPORT_WINDOW_HINT = "링크는 로그 아웃하거나 인터페이스를 다시로드 할 때까지 활성 상태로 유지됩니다."
msg.LINK_EXPORT_WINDOW_PROGRESS = "링크 생성 중… {progress} %"
msg.LINK_EXPORT_WINDOW_POST_BUTTON = "채팅에 링크 게시"

--- Song link import frame
msg.LINK_IMPORT_WINDOW_TITLE = "{player}에서 노래 가져 오기 :"
msg.LINK_IMPORT_WINDOW_HINT = "\"가져 오기\"를 클릭하여 Musician으로 노래 가져 오기를 시작합니다."
msg.LINK_IMPORT_WINDOW_IMPORT_BUTTON = "노래 가져 오기"
msg.LINK_IMPORT_WINDOW_CANCEL_IMPORT_BUTTON = "가져 오기 취소"
msg.LINK_IMPORT_WINDOW_REQUESTING = "{player}에서 노래 요청 중…"
msg.LINK_IMPORT_WINDOW_PROGRESS = "가져 오는 중… {progress} %"
msg.LINK_IMPORT_WINDOW_SELECT_ACCOUNT = "노래를 검색 할 캐릭터를 선택하십시오 :"

--- Song links errors
msg.LINKS_ERROR.notFound = "{player}에서 \"{title}\"노래를 사용할 수 없습니다."
msg.LINKS_ERROR.alreadySending = "{player}에서 이미 노래를 전송 중입니다. 몇 초 후에 다시 시도하십시오."
msg.LINKS_ERROR.alreadyRequested = "{player}에서 이미 노래를 요청하고 있습니다."
msg.LINKS_ERROR.timeout = "{player}가 응답하지 않았습니다."
msg.LINKS_ERROR.offline = "{player}는 월드 오브 워크래프트에 로그인되어 있지 않습니다."
msg.LINKS_ERROR.importingFailed = "{player}에서 {title} 노래를 가져올 수 없습니다."

--- Map tracking options
msg.MAP_OPTIONS_TITLE = "지도"
msg.MAP_OPTIONS_SUB_TEXT = "재생중인 주변 음악가 표시 :"
msg.MAP_OPTIONS_MINI_MAP = "미니 맵에서"
msg.MAP_OPTIONS_WORLD_MAP = "세계지도에서"
msg.MAP_TRACKING_OPTIONS_TITLE = "Musician"
msg.MAP_TRACKING_OPTION_ACTIVE_MUSICIANS = "연주하는 Musician"

--- Total RP Extended module
msg.TRPE_ITEM_NAME = "{title}"
msg.TRPE_ITEM_TOOLTIP_REQUIRES_MUSICIAN = "Musician 필요"
msg.TRPE_ITEM_TOOLTIP_SHEET_MUSIC = "망할 음악"
msg.TRPE_ITEM_USE_HINT = "악보 읽기"
msg.TRPE_ITEM_MUSICIAN_NOT_FOUND = "이 항목을 사용하려면 최신 버전의 \"Musician\"추가 기능을 설치해야합니다.\n{url}에서 가져 오기"
msg.TRPE_ITEM_NOTES = "노래를 Musician으로 가져 와서 근처 플레이어를 위해 재생합니다.\n\n뮤지션 다운로드 : {url}\n"

msg.TRPE_EXPORT_BUTTON = "수출"
msg.TRPE_EXPORT_WINDOW_TITLE = "총 RP 항목으로 노래 내보내기"
msg.TRPE_EXPORT_WINDOW_LOCALE = "항목 언어 :"
msg.TRPE_EXPORT_WINDOW_ADD_TO_BAG = "가방에 추가"
msg.TRPE_EXPORT_WINDOW_QUANTITY = "수량:"
msg.TRPE_EXPORT_WINDOW_HINT_NEW = "Total RP에서 다른 플레이어와 거래 할 수있는 악보 아이템을 만듭니다."
msg.TRPE_EXPORT_WINDOW_HINT_EXISTING = "이 노래에 대한 항목이 이미 있으며 업데이트됩니다."
msg.TRPE_EXPORT_WINDOW_CREATE_ITEM_BUTTON = "아이템 생성"
msg.TRPE_EXPORT_WINDOW_PROGRESS = "항목 생성 중… {progress} %"

--- Musician instrument names
msg.INSTRUMENT_NAMES["none"] = "(없음)"
msg.INSTRUMENT_NAMES["accordion"] = "아코디언"
msg.INSTRUMENT_NAMES["bagpipe"] = "풍적"
msg.INSTRUMENT_NAMES["dulcimer"] = "덜 시머 (망치)"
msg.INSTRUMENT_NAMES["piano"] = "피아노"
msg.INSTRUMENT_NAMES["lute"] = "류트"
msg.INSTRUMENT_NAMES["viola_da_gamba"] = "비올라 다 감바"
msg.INSTRUMENT_NAMES["harp"] = "셀틱 하프"
msg.INSTRUMENT_NAMES["male_voice"] = "남성 목소리 (테너)"
msg.INSTRUMENT_NAMES["female_voice"] = "여성 목소리 (소프라노)"
msg.INSTRUMENT_NAMES["trumpet"] = "트럼펫"
msg.INSTRUMENT_NAMES["sackbut"] = "Sackbut"
msg.INSTRUMENT_NAMES["war_horn"] = "전쟁 경적"
msg.INSTRUMENT_NAMES["bassoon"] = "바순"
msg.INSTRUMENT_NAMES["clarinet"] = "클라리넷"
msg.INSTRUMENT_NAMES["recorder"] = "기록계"
msg.INSTRUMENT_NAMES["fiddle"] = "깡깡이"
msg.INSTRUMENT_NAMES["percussions"] = "타악기 (전통)"
msg.INSTRUMENT_NAMES["distortion_guitar"] = "왜곡 기타"
msg.INSTRUMENT_NAMES["clean_guitar"] = "깨끗한 기타"
msg.INSTRUMENT_NAMES["bass_guitar"] = "베이스 기타"
msg.INSTRUMENT_NAMES["drumkit"] = "드럼 키트"
msg.INSTRUMENT_NAMES["war_drum"] = "전쟁 드럼"
msg.INSTRUMENT_NAMES["woodblock"] = "판목"
msg.INSTRUMENT_NAMES["tambourine_shake"] = "탬버린 (흔들림)"

--- General MIDI instrument names
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGrandPiano] = "어쿠스틱 그랜드 피아노"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrightAcousticPiano] = "밝은 어쿠스틱 피아노"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGrandPiano] = "일렉트릭 그랜드 피아노"
msg.MIDI_INSTRUMENT_NAMES[Instrument.HonkyTonkPiano] = "홍키 통크 피아노"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricPiano1] = "일렉트릭 피아노 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricPiano2] = "일렉트릭 피아노 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Harpsichord] = "하프시 코드"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Clavi] = "Clavi"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Celesta] = "Celesta"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Glockenspiel] = "Glockenspiel"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MusicBox] = "뮤직 박스"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Vibraphone] = "비브라폰"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Marimba] = "마림바"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Xylophone] = "목금"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TubularBells] = "관형 벨"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Dulcimer] = "덜 시머"
msg.MIDI_INSTRUMENT_NAMES[Instrument.DrawbarOrgan] = "견인 바 오르간"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PercussiveOrgan] = "타악기"
msg.MIDI_INSTRUMENT_NAMES[Instrument.RockOrgan] = "록 오르간"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ChurchOrgan] = "교회 기관"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ReedOrgan] = "리드 오르간"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Accordion] = "아코디언"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Harmonica] = "하모니카"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TangoAccordion] = "탱고 아코디언"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGuitarNylon] = "어쿠스틱 기타 (나일론)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGuitarSteel] = "어쿠스틱 기타 (스틸)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarJazz] = "일렉트릭 기타 (재즈)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarClean] = "일렉트릭 기타 (클린)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarMuted] = "일렉트릭 기타 (음소거)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OverdrivenGuitar] = "오버 드라이브 기타"
msg.MIDI_INSTRUMENT_NAMES[Instrument.DistortionGuitar] = "왜곡 기타"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Guitarharmonics] = "기타 고조파"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticBass] = "어쿠스틱베이스"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricBassFinger] = "일렉트릭베이스 (손가락)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricBassPick] = "일렉트릭베이스 (선택됨)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FretlessBass] = "번뜩이는 저음"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SlapBass1] = "슬랩베이스 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SlapBass2] = "슬랩베이스 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBass1] = "신스베이스 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBass2] = "신스베이스 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Violin] = "바이올린"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Viola] = "비올라"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Cello] = "첼로"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Contrabass] = "콘트라베이스"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TremoloStrings] = "트레몰로 현"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PizzicatoStrings] = "피치카토 현"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestralHarp] = "오케스트라 하프"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Timpani] = "팀파니"
msg.MIDI_INSTRUMENT_NAMES[Instrument.StringEnsemble1] = "현악 앙상블 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.StringEnsemble2] = "현악 앙상블 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthStrings1] = "신스 문자열 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthStrings2] = "신스 문자열 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ChoirAahs] = "합창단 aahs"
msg.MIDI_INSTRUMENT_NAMES[Instrument.VoiceOohs] = "목소리 oohs"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthVoice] = "신스 보이스"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestraHit] = "오케스트라 히트"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Trumpet] = "트럼펫"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Trombone] = "트롬본"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Tuba] = "튜바"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MutedTrumpet] = "음소거 된 트럼펫"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FrenchHorn] = "프렌치 호른"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrassSection] = "황동 섹션"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBrass1] = "신스 황동 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBrass2] = "신스 브라스 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SopranoSax] = "소프라노 색소폰"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AltoSax] = "알토 색소폰"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TenorSax] = "테너 색소폰"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BaritoneSax] = "바리톤 색소폰"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Oboe] = "오보에"
msg.MIDI_INSTRUMENT_NAMES[Instrument.EnglishHorn] = "잉글리시 혼"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Bassoon] = "바순"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Clarinet] = "클라리넷"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Piccolo] = "피콜로"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Flute] = "플루트"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Recorder] = "기록계"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PanFlute] = "팬 플루트"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BlownBottle] = "불어 진 병"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shakuhachi] = "Shakuhachi"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Whistle] = "휘파람"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Ocarina] = "오카리나"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead1Square] = "리드 1 (정사각형)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead2Sawtooth] = "리드 2 (톱니)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead3Calliope] = "리드 3 (칼리오페)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead4Chiff] = "리드 4 (쉬프)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead5Charang] = "리드 5 (차랑)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead6Voice] = "리드 6 (음성)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead7Fifths] = "리드 7 (5 분의 1)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead8BassLead] = "리드 8 (베이스 + 리드)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad1Newage] = "패드 1 (뉴 에이지)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad2Warm] = "패드 2 (따뜻함)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad3Polysynth] = "패드 3 (폴리 신스)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad4Choir] = "패드 4 (합창단)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad5Bowed] = "패드 5 (활)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad6Metallic] = "패드 6 (메탈릭)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad7Halo] = "패드 7 (후광)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad8Sweep] = "패드 8 (스위프)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX1Rain] = "FX 1 (비)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX2Soundtrack] = "FX 2 (사운드 트랙)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX3Crystal] = "FX 3 (크리스탈)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX4Atmosphere] = "FX 4 (대기)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX5Brightness] = "FX 5 (밝기)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX6Goblins] = "FX 6 (고블린)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX7Echoes] = "FX 7 (에코)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX8SciFi] = "FX 8 (공상 과학)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Sitar] = "시타르"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Banjo] = "밴조"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shamisen] = "샤미센"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Koto] = "Koto"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Kalimba] = "칼 림바"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Bagpipe] = "백 파이프"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Fiddle] = "깡깡이"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shanai] = "Shanai"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TinkleBell] = "팅클 벨"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Agogo] = "아 고고"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SteelDrums] = "쇠 드럼"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Woodblock] = "판목"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TaikoDrum] = "타이코 드럼"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MelodicTom] = "멜로딕 탐"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthDrum] = "신스 드럼"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ReverseCymbal] = "리버스 심벌즈"
msg.MIDI_INSTRUMENT_NAMES[Instrument.GuitarFretNoise] = "기타 프렛 소음"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BreathNoise] = "숨소리"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Seashore] = "해변"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BirdTweet] = "새 트윗"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TelephoneRing] = "전화벨"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Helicopter] = "헬리콥터"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Applause] = "박수 갈채"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Gunshot] = "사격"

--- General MIDI drum kit names
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_INSTRUMENT_NAMES[Instrument.StandardKit] = "표준 드럼 키트"
msg.MIDI_INSTRUMENT_NAMES[Instrument.RoomKit] = "룸 드럼 키트"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PowerKit] = "파워 드럼 키트"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectronicKit] = "전자 드럼 키트"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TR808Kit] = "TR-808 드럼 머신"
msg.MIDI_INSTRUMENT_NAMES[Instrument.JazzKit] = "재즈 드럼 키트"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrushKit] = "브러시 드럼 키트"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestraKit] = "오케스트라 드럼 키트"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SoundFXKit] = "사운드 FX"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MT32Kit] = "MT-32 드럼 키트"
msg.MIDI_INSTRUMENT_NAMES[Instrument.None] = "(없음)"
msg.UNKNOWN_DRUMKIT = "알 수없는 드럼 키트 ({midi})"

--- General MIDI percussion list
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_PERCUSSION_NAMES[Percussion.Laser] = "레이저" -- MIDI key 27
msg.MIDI_PERCUSSION_NAMES[Percussion.Whip] = "채찍" -- MIDI key 28
msg.MIDI_PERCUSSION_NAMES[Percussion.ScratchPush] = "스크래치 푸시" -- MIDI key 29
msg.MIDI_PERCUSSION_NAMES[Percussion.ScratchPull] = "스크래치 풀" -- MIDI key 30
msg.MIDI_PERCUSSION_NAMES[Percussion.StickClick] = "스틱 클릭" -- MIDI key 31
msg.MIDI_PERCUSSION_NAMES[Percussion.SquareClick] = "스퀘어 클릭" -- MIDI key 32
msg.MIDI_PERCUSSION_NAMES[Percussion.MetronomeClick] = "메트로놈 클릭" -- MIDI key 33
msg.MIDI_PERCUSSION_NAMES[Percussion.MetronomeBell] = "메트로놈 벨" -- MIDI key 34
msg.MIDI_PERCUSSION_NAMES[Percussion.AcousticBassDrum] = "어쿠스틱베이스 드럼" -- MIDI key 35
msg.MIDI_PERCUSSION_NAMES[Percussion.BassDrum1] = "베이스 드럼 1" -- MIDI key 36
msg.MIDI_PERCUSSION_NAMES[Percussion.SideStick] = "사이드 스틱" -- MIDI key 37
msg.MIDI_PERCUSSION_NAMES[Percussion.AcousticSnare] = "어쿠스틱 스네어" -- MIDI key 38
msg.MIDI_PERCUSSION_NAMES[Percussion.HandClap] = "박수" -- MIDI key 39
msg.MIDI_PERCUSSION_NAMES[Percussion.ElectricSnare] = "전기 스네어" -- MIDI key 40
msg.MIDI_PERCUSSION_NAMES[Percussion.LowFloorTom] = "저상 톰" -- MIDI key 41
msg.MIDI_PERCUSSION_NAMES[Percussion.ClosedHiHat] = "폐쇄 형 하이햇" -- MIDI key 42
msg.MIDI_PERCUSSION_NAMES[Percussion.HighFloorTom] = "고층 톰" -- MIDI key 43
msg.MIDI_PERCUSSION_NAMES[Percussion.PedalHiHat] = "페달 하이햇" -- MIDI key 44
msg.MIDI_PERCUSSION_NAMES[Percussion.LowTom] = "로우 톰" -- MIDI key 45
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenHiHat] = "하이햇 열기" -- MIDI key 46
msg.MIDI_PERCUSSION_NAMES[Percussion.LowMidTom] = "중저가 탐" -- MIDI key 47
msg.MIDI_PERCUSSION_NAMES[Percussion.HiMidTom] = "하이 미드 톰" -- MIDI key 48
msg.MIDI_PERCUSSION_NAMES[Percussion.CrashCymbal1] = "크래시 심벌즈 1" -- MIDI key 49
msg.MIDI_PERCUSSION_NAMES[Percussion.HighTom] = "하이 톰" -- MIDI key 50
msg.MIDI_PERCUSSION_NAMES[Percussion.RideCymbal1] = "라이드 심벌즈 1" -- MIDI key 51
msg.MIDI_PERCUSSION_NAMES[Percussion.ChineseCymbal] = "중국 심벌즈" -- MIDI key 52
msg.MIDI_PERCUSSION_NAMES[Percussion.RideBell] = "라이드 벨" -- MIDI key 53
msg.MIDI_PERCUSSION_NAMES[Percussion.Tambourine] = "탬버린" -- MIDI key 54
msg.MIDI_PERCUSSION_NAMES[Percussion.SplashCymbal] = "스플래시 심벌즈" -- MIDI key 55
msg.MIDI_PERCUSSION_NAMES[Percussion.Cowbell] = "카우벨" -- MIDI key 56
msg.MIDI_PERCUSSION_NAMES[Percussion.CrashCymbal2] = "크래시 심벌즈 2" -- MIDI key 57
msg.MIDI_PERCUSSION_NAMES[Percussion.Vibraslap] = "비 브라 슬랩" -- MIDI key 58
msg.MIDI_PERCUSSION_NAMES[Percussion.RideCymbal2] = "라이드 심벌즈 2" -- MIDI key 59
msg.MIDI_PERCUSSION_NAMES[Percussion.HiBongo] = "안녕 봉고" -- MIDI key 60
msg.MIDI_PERCUSSION_NAMES[Percussion.LowBongo] = "낮은 봉고" -- MIDI key 61
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteHiConga] = "안녕 콩가 음소거" -- MIDI key 62
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenHiConga] = "안녕 콩가 열기" -- MIDI key 63
msg.MIDI_PERCUSSION_NAMES[Percussion.LowConga] = "낮은 콩가" -- MIDI key 64
msg.MIDI_PERCUSSION_NAMES[Percussion.HighTimbale] = "높은 팀 베일" -- MIDI key 65
msg.MIDI_PERCUSSION_NAMES[Percussion.LowTimbale] = "낮은 팀 베일" -- MIDI key 66
msg.MIDI_PERCUSSION_NAMES[Percussion.HighAgogo] = "높은 아 고고" -- MIDI key 67
msg.MIDI_PERCUSSION_NAMES[Percussion.LowAgogo] = "낮은 아 고고" -- MIDI key 68
msg.MIDI_PERCUSSION_NAMES[Percussion.Cabasa] = "카바 사" -- MIDI key 69
msg.MIDI_PERCUSSION_NAMES[Percussion.Maracas] = "마라카스" -- MIDI key 70
msg.MIDI_PERCUSSION_NAMES[Percussion.ShortWhistle] = "짧은 휘파람" -- MIDI key 71
msg.MIDI_PERCUSSION_NAMES[Percussion.LongWhistle] = "긴 휘파람" -- MIDI key 72
msg.MIDI_PERCUSSION_NAMES[Percussion.ShortGuiro] = "짧은 귀로" -- MIDI key 73
msg.MIDI_PERCUSSION_NAMES[Percussion.LongGuiro] = "긴 귀로" -- MIDI key 74
msg.MIDI_PERCUSSION_NAMES[Percussion.Claves] = "Claves" -- MIDI key 75
msg.MIDI_PERCUSSION_NAMES[Percussion.HiWoodBlock] = "안녕하세요 나무 블록" -- MIDI key 76
msg.MIDI_PERCUSSION_NAMES[Percussion.LowWoodBlock] = "낮은 나무 블록" -- MIDI key 77
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteCuica] = "cuica 음소거" -- MIDI key 78
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenCuica] = "cuica 열기" -- MIDI key 79
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteTriangle] = "삼각형 음소거" -- MIDI key 80
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenTriangle] = "열린 삼각형" -- MIDI key 81
msg.MIDI_PERCUSSION_NAMES[Percussion.Shaker] = "셰이커" -- MIDI key 82
msg.MIDI_PERCUSSION_NAMES[Percussion.SleighBell] = "썰매 종" -- MIDI key 83
msg.MIDI_PERCUSSION_NAMES[Percussion.BellTree] = "벨 트리" -- MIDI key 84
msg.MIDI_PERCUSSION_NAMES[Percussion.Castanets] = "캐스터네츠" -- MIDI key 85
msg.MIDI_PERCUSSION_NAMES[Percussion.SurduDeadStroke] = "Surdu 데드 스트로크" -- MIDI key 86
msg.MIDI_PERCUSSION_NAMES[Percussion.Surdu] = "수르 두" -- MIDI key 87
msg.MIDI_PERCUSSION_NAMES[Percussion.SnareDrumRod] = "스네어 드럼로드" -- MIDI key 88
msg.MIDI_PERCUSSION_NAMES[Percussion.OceanDrum] = "오션 드럼" -- MIDI key 89
msg.MIDI_PERCUSSION_NAMES[Percussion.SnareDrumBrush] = "스네어 드럼 브러시" -- MIDI key 90