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

local msg = Musician.InitLocale("tw", "繁體中文", "zhTW")

local Instrument = Musician.MIDI_INSTRUMENTS
local Percussion = Musician.MIDI_PERCUSSIONS
local KEY = Musician.KEYBOARD_KEY

------------------------------------------------------------------------
---------------- ↑↑↑ DO NOT EDIT THE LINES ABOVE ! ↑↑↑  ----------------
------------------------------------------------------------------------

--- Main frame controls
msg.PLAY = "播放"
msg.STOP = "停止"
msg.PAUSE = "暫停"
msg.TEST_SONG = "預覽"
msg.STOP_TEST = "停止預覽"
msg.CLEAR = "清除"
msg.SELECT_ALL = "全選"
msg.EDIT = "編輯"
msg.MUTE = "靜音"
msg.UNMUTE = "取消靜音"

--- Minimap button menu
msg.MENU_TITLE = "Musician"
msg.MENU_IMPORT_SONG = "導入並播放一首音樂"
msg.MENU_PLAY = "播放"
msg.MENU_STOP = "停止"
msg.MENU_PLAY_PREVIEW = "預覽"
msg.MENU_STOP_PREVIEW = "停止預覽"
msg.MENU_LIVE_PLAY = "現場演奏"
msg.MENU_SHOW_KEYBOARD = "打開鍵盤"
msg.MENU_SETTINGS = "設定"
msg.MENU_OPTIONS = "選項"
msg.MENU_ABOUT = "關於"

--- Chat commands
msg.COMMAND_LIST_TITLE = "Musician指令："
msg.COMMAND_SHOW = "顯示音樂導入窗口"
msg.COMMAND_PREVIEW_PLAY = "開始或停止預覽音樂"
msg.COMMAND_PREVIEW_STOP = "停止預覽音樂"
msg.COMMAND_PLAY = "播放或停止播放音樂"
msg.COMMAND_STOP = "停止播放音樂"
msg.COMMAND_SONG_EDITOR = "打開音樂編輯器"
msg.COMMAND_LIVE_KEYBOARD = "打開演奏鍵盤"
msg.COMMAND_CONFIGURE_KEYBOARD = "設置鍵盤"
msg.COMMAND_LIVE_DEMO = "鍵盤演示模式"
msg.COMMAND_LIVE_DEMO_PARAMS = "{ **<上音軌編號>** **<下音軌編號>** || **關閉** }"
msg.COMMAND_HELP = "顯示這條幫助信息"
msg.ERR_COMMAND_UNKNOWN = "未知的 \"{command}\" 指令。輸入 {help} 來獲得指令表。"

--- Global error messages
msg.ERR_CLASSIC_ON_RETAIL = "你正在正式版服務器使用懷舊版Musician插件，請安裝正式版的插件。"
msg.ERR_RETAIL_ON_CLASSIC = "你正在懷舊版服務器使用正式版Musician插件，請安裝懷舊版的插件。"

--- Add-on options
msg.OPTIONS_TITLE = "Musician"
msg.OPTIONS_SUB_TEXT = "加入Discord社區來幫助我們！ {url}"
msg.OPTIONS_CATEGORY_EMOTE = "表情"
msg.OPTIONS_ENABLE_EMOTE_LABEL = "當播放音樂時，向沒有Musician插件的玩家發送一條表情信息。"
msg.OPTIONS_ENABLE_EMOTE_PROMO_LABEL = "以一條短文字來邀請他們安裝插件，這樣他們就能聽到你的演奏了。"
msg.OPTIONS_EMOTE_HINT = "當你播放音樂的時候，沒有Musician插件的玩家會收到一條表情信息。你可以在[options]當中禁用它."
msg.OPTIONS_INTEGRATION_OPTIONS_TITLE = "遊戲內嵌整合選項"
msg.OPTIONS_AUTO_MUTE_GAME_MUSIC_LABEL = "播放歌曲時靜音遊戲背景音樂。"
msg.OPTIONS_MUTE_INSTRUMENT_TOYS_LABEL = "靜音來自樂器玩具的音樂。 {icons}"
msg.OPTIONS_CATEGORY_NAMEPLATES = "姓名版和動作"
msg.OPTIONS_CATEGORY_NAMEPLATES_SUB_TEXT = "打開姓名版選項以便看到正在演奏音樂的玩家的動畫並確認附近有誰可以聽到你。"
msg.OPTIONS_ENABLE_NAMEPLATES = "啟用姓名版和動畫。"
msg.OPTIONS_SHOW_NAMEPLATE_ICON = "在擁有Musician插件的玩家名字旁邊顯示一個{icon}圖標。"
msg.OPTIONS_HIDE_HEALTH_BARS = "在未進入戰鬥時，隱藏玩家和友善單位的姓名版。"
msg.OPTIONS_HIDE_NPC_NAMEPLATES = "隱藏NPC姓名版。"
msg.OPTIONS_CINEMATIC_MODE = "當使用{binding}關閉UI姓名版時也顯示動畫。"
msg.OPTIONS_CINEMATIC_MODE_NO_BINDING = "隱藏UI時顯示動畫。"
msg.OPTIONS_NAMEPLATES_CINEMATIC_MODE = "隱藏UI時顯示姓名版。"
msg.OPTIONS_TRP3 = "Total RP 3"
msg.OPTIONS_TRP3_MAP_SCAN = "在地圖上擁有Musician插件的玩家名字旁邊顯示一個{icon}圖標。"
msg.OPTIONS_CROSS_RP_TITLE = "Cross RP"
msg.OPTIONS_CROSS_RP_SUB_TEXT = "安裝Tammya-月亮守衛的Cross RP插件來進行跨服/跨陣營的音樂演奏！"
msg.OPTIONS_CROSS_RP_SUB_TEXT_NO_GATEWAY = "目前暫無可用的Cross RP節點。\n請耐心等待……"
msg.OPTIONS_CROSS_RP_SUB_TEXT_ACTIVE = "Cross RP連接已在以下位置啟動：\n\n{bands}"

--- Tips and Tricks
msg.TIPS_AND_TRICKS_ENABLE = "啟動時顯示小貼士。"

msg.TIPS_AND_TRICKS_NAMEPLATES_TITLE = "動畫和姓名版"
msg.TIPS_AND_TRICKS_NAMEPLATES_TEXT = "當姓名版選項打開時，正在播放音樂的玩家會顯示特殊動畫。\n\n{icon}顯示了安裝Musician並能聽到你演奏的玩家。\n\n你想打開姓名版和動畫嗎？"
msg.TIPS_AND_TRICKS_NAMEPLATES_OK = "打開姓名版和動畫"
msg.TIPS_AND_TRICKS_NAMEPLATES_CANCEL = "稍後再說"

msg.TIPS_AND_TRICKS_CROSS_RP_TITLE = "使用Cross RP進行跨陣營/跨服演奏"
msg.TIPS_AND_TRICKS_CROSS_RP_TEXT = "安裝Tammya-月亮守衛的Cross RP插件來進行跨服/跨陣營的音樂演奏！"
msg.TIPS_AND_TRICKS_CROSS_RP_OK = "好的"

--- Welcome messages
msg.STARTUP = "歡迎使用Musician v{version}."
msg.PLAYER_COUNT_ONLINE = "現在有{count}個音樂迷在線！"
msg.PLAYER_COUNT_ONLINE_ONE = "有一個音樂迷在線！"
msg.PLAYER_COUNT_ONLINE_NONE = "沒有在線的音樂迷。"

--- New version notifications
msg.NEW_VERSION = "一個新的Musician版本發布了！可以在以下鏈接下載升級：{url}。"
msg.NEW_PROTOCOL_VERSION = "你的Musician版本過老，已經無法使用。\n請前往以下鏈接升級\n{url}"

--- Player tooltips
msg.PLAYER_TOOLTIP = "Musician"
msg.PLAYER_TOOLTIP_VERSION = "Musician v{version}"
msg.PLAYER_TOOLTIP_VERSION_OUTDATED = " (當前版本已過期)"
msg.PLAYER_TOOLTIP_VERSION_INCOMPATIBLE = " (當前版本不兼容)"
msg.PLAYER_TOOLTIP_PRELOADING = "音效預載中……({progress})"

--- Song import
msg.INVALID_MUSIC_CODE = "音樂代碼無效。"
msg.PLAY_A_SONG = "播放音樂"
msg.IMPORT_A_SONG = "導入音樂"
msg.PASTE_MUSIC_CODE = "通過以下地址導入你MIDI格式的音樂\n{url}\n\n並把音樂代碼粘貼在這裡({shortcut})…"
msg.SONG_IMPORTED = "音樂已載入：{title}."

--- Play as a band
msg.PLAY_IN_BAND = "樂隊演奏"
msg.PLAY_IN_BAND_HINT = "當你準備好和你的樂隊一起演奏時，點擊這裡。"
msg.PLAY_IN_BAND_READY_PLAYERS = "已就緒的樂隊成員："
msg.EMOTE_PLAYER_IS_READY = "已準備好作為樂隊成員演奏。"
msg.EMOTE_PLAYER_IS_NOT_READY = "已離開就緒狀態。"
msg.EMOTE_PLAY_IN_BAND_START = "開始樂隊演奏。"
msg.EMOTE_PLAY_IN_BAND_STOP = "停止樂隊演奏。"

--- Play as a band (live)
msg.LIVE_SYNC = "樂隊現場演奏。"
msg.LIVE_SYNC_HINT = "點擊這裡進行樂隊演奏同步。"
msg.SYNCED_PLAYERS = "就位的樂隊成員："
msg.EMOTE_PLAYER_LIVE_SYNC_ENABLED = "正在和你一起演奏音樂。"
msg.EMOTE_PLAYER_LIVE_SYNC_DISABLED = "停止了和你演奏音樂。"

--- Song editor frame
msg.SONG_EDITOR = "音樂編輯器"
msg.MARKER_FROM = "從"
msg.MARKER_TO = "到"
msg.POSITION = "位置"
msg.TRACK_NUMBER = "音軌 #{track}"
msg.CHANNEL_NUMBER_SHORT = "頻道.{channel}"
msg.JUMP_PREV = "後退10秒"
msg.JUMP_NEXT = "前進10秒"
msg.GO_TO_START = "前往起始"
msg.GO_TO_END = "前往結尾"
msg.SET_CROP_FROM = "設置起始點"
msg.SET_CROP_TO = "設置結尾點"
msg.SYNCHRONIZE_TRACKS = "以當前音樂同步音軌設定"
msg.MUTE_TRACK = "靜音"
msg.SOLO_TRACK = "獨奏"
msg.TRANSPOSE_TRACK = "變調(八度音階)"
msg.CHANGE_TRACK_INSTRUMENT = "切換樂器"
msg.HEADER_NUMBER = "#"
msg.HEADER_OCTAVE = "八度音階"
msg.HEADER_INSTRUMENT = "樂器"

--- Configure live keyboard frame
msg.SHOULD_CONFIGURE_KEYBOARD = "在開始演奏前需要對鍵盤進行設置。"
msg.CONFIGURE_KEYBOARD = "設置鍵盤"
msg.CONFIGURE_KEYBOARD_HINT = "點擊一個鍵以設置……"
msg.CONFIGURE_KEYBOARD_HINT_COMPLETE = "鍵盤設置已完成。\n你現在可以保存更改並開始演奏了！"
msg.CONFIGURE_KEYBOARD_START_OVER = "重新設置"
msg.CONFIGURE_KEYBOARD_SAVE = "保存配置"
msg.PRESS_KEY_BINDING = "按下 #{col}列#{row}行的按鈕。"
msg.KEY_CAN_BE_EMPTY = "該密鑰是可選的，可以為空。"
msg.KEY_IS_MERGEABLE = "這可以和你鍵盤上的{key}鍵相同：{action}"
msg.KEY_CAN_BE_MERGED = "此時，請直接按下{key}鍵。"
msg.KEY_CANNOT_BE_MERGED = "此時，請忽略並設置下一個鍵。"
msg.NEXT_KEY = "下一個按鍵"
msg.CLEAR_KEY = "清除按鍵"

--- About frame
msg.ABOUT_TITLE = "Musician"
msg.ABOUT_VERSION = "版本 {version}"
msg.ABOUT_AUTHOR = "By LenweSaralonde – {url}"
msg.ABOUT_AUTHOR_EXTRA1 = "中文漢化 by 格雷森·黑爪"
msg.ABOUT_LICENSE = "本插件遵循GNU通用公共授權v3.0"
msg.ABOUT_DISCORD = "Discord頻道: {url}"
msg.ABOUT_SUPPORT = "你喜歡Musician嗎？把它分享給大家吧！"
msg.ABOUT_PATREON = "成為Patreon捐助者：{url}"
msg.ABOUT_PAYPAL = "成為PayPal捐助者：{url}"
msg.ABOUT_SUPPORTERS = "特別鳴謝本插件的捐助者們！ <3"

--- Fixed PC keyboard key names
msg.FIXED_KEY_NAMES[KEY.Backspace] = "Backspace"
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
msg.KEYBOARD_LAYOUTS["Piano"] = "鋼琴"
msg.KEYBOARD_LAYOUTS["Chromatic"] = "半音階"
msg.KEYBOARD_LAYOUTS["Modes"] = "調式"
msg.KEYBOARD_LAYOUTS["Ionian"] = "伊奧尼亞調式"
msg.KEYBOARD_LAYOUTS["Dorian"] = "多利亞調式"
msg.KEYBOARD_LAYOUTS["Phrygian"] = "弗利幾亞調式"
msg.KEYBOARD_LAYOUTS["Lydian"] = "利底亞調式"
msg.KEYBOARD_LAYOUTS["Mixolydian"] = "混合利底亞調式"
msg.KEYBOARD_LAYOUTS["Aeolian"] = "愛奧利亞調式"
msg.KEYBOARD_LAYOUTS["Locrian"] = "洛克利亞調式"
msg.KEYBOARD_LAYOUTS["minor Harmonic"] = "和聲小調"
msg.KEYBOARD_LAYOUTS["minor Melodic"] = "旋律小調"
msg.KEYBOARD_LAYOUTS["Blues scales"] = "布魯斯音階"
msg.KEYBOARD_LAYOUTS["Major Blues"] = "大調布魯斯"
msg.KEYBOARD_LAYOUTS["minor Blues"] = "小調布魯斯"
msg.KEYBOARD_LAYOUTS["Diminished scales"] = "減音階"
msg.KEYBOARD_LAYOUTS["Diminished"] = "減弱"
msg.KEYBOARD_LAYOUTS["Complement Diminished"] = "補充減弱"
msg.KEYBOARD_LAYOUTS["Pentatonic scales"] = "五聲音階"
msg.KEYBOARD_LAYOUTS["Major Pentatonic"] = "大五聲"
msg.KEYBOARD_LAYOUTS["minor Pentatonic"] = "小五聲"
msg.KEYBOARD_LAYOUTS["World scales"] = "世界音階"
msg.KEYBOARD_LAYOUTS["Raga 1"] = "印度拉加 1"
msg.KEYBOARD_LAYOUTS["Raga 2"] = "印度拉加 2"
msg.KEYBOARD_LAYOUTS["Raga 3"] = "印度拉加 3"
msg.KEYBOARD_LAYOUTS["Arabic"] = "阿拉伯"
msg.KEYBOARD_LAYOUTS["Spanish"] = "西班牙"
msg.KEYBOARD_LAYOUTS["Gypsy"] = "吉普賽"
msg.KEYBOARD_LAYOUTS["Egyptian"] = "埃及"
msg.KEYBOARD_LAYOUTS["Hawaiian"] = "夏威夷"
msg.KEYBOARD_LAYOUTS["Bali Pelog"] = "巴厘島"
msg.KEYBOARD_LAYOUTS["Japanese"] = "日本"
msg.KEYBOARD_LAYOUTS["Ryukyu"] = "琉球"
msg.KEYBOARD_LAYOUTS["Chinese"] = "中國"
msg.KEYBOARD_LAYOUTS["Miscellaneous scales"] = "其他音階"
msg.KEYBOARD_LAYOUTS["Bass Line"] = "貝斯弦"
msg.KEYBOARD_LAYOUTS["Wholetone"] = "全音"
msg.KEYBOARD_LAYOUTS["minor 3rd"] = "小三度"
msg.KEYBOARD_LAYOUTS["Major 3rd"] = "大三度"
msg.KEYBOARD_LAYOUTS["4th"] = "純四度"
msg.KEYBOARD_LAYOUTS["5th"] = "純五度"
msg.KEYBOARD_LAYOUTS["Octave"] = "八度"

--- Live keyboard layout types
msg.HORIZONTAL_LAYOUT = "水平"
msg.VERTICAL_LAYOUT = "垂直"

--- Live keyboard frame
msg.LIVE_SONG_NAME = "現場演奏"
msg.SOLO_MODE = "獨奏模式"
msg.LIVE_MODE = "演奏模式"
msg.LIVE_MODE_DISABLED = "演奏模式在回放時已關閉。"
msg.ENABLE_SOLO_MODE = "啟動獨奏模式（演奏給自己聽）"
msg.ENABLE_LIVE_MODE = "啟動演奏模式（演奏給所有人聽）"
msg.PLAY_LIVE = "開始演奏"
msg.PLAY_SOLO = "開始獨奏"
msg.SHOW_KEYBOARD = "顯示鍵盤"
msg.HIDE_KEYBOARD = "隱藏鍵盤"
msg.KEYBOARD_LAYOUT = "鍵盤模式和大小"
msg.CHANGE_KEYBOARD_LAYOUT = "修改鍵盤佈局"
msg.BASE_KEY = "基礎鍵"
msg.CHANGE_BASE_KEY = "基礎鍵"
msg.CHANGE_LOWER_INSTRUMENT = "改變下方樂器"
msg.CHANGE_UPPER_INSTRUMENT = "改變上方樂器"
msg.LOWER_INSTRUMENT_MAPPED_TO_CHANNEL = "下方樂器(音軌 #{track})"
msg.UPPER_INSTRUMENT_MAPPED_TO_CHANNEL = "上方樂器(音軌 #{track})"
msg.SUSTAIN_KEY = "延音"
msg.POWER_CHORDS = "強力和弦"
msg.PROGRAM_BUTTON = "P {num}"
msg.EMPTY_PROGRAM = "空白程序"
msg.LOAD_PROGRAM_NUM = "載入程序 #{num} ({key})"
msg.SAVE_PROGRAM_NUM = "保存至程序 #{num} ({key})"
msg.DELETE_PROGRAM_NUM = "清空程序 #{num} ({key})"
msg.WRITE_PROGRAM = "保存程序 ({key})"
msg.DELETE_PROGRAM = "刪除程序 ({key})"
msg.PROGRAM_SAVED = "程序 #{num} 已保存。"
msg.PROGRAM_DELETED = "程序 #{num} 已清空。"
msg.DEMO_MODE_ENABLED = "鍵盤演示模式啟動：\n{mapping}"
msg.DEMO_MODE_MAPPING = "{layer} → 音軌 #{track}"
msg.DEMO_MODE_DISABLED = "鍵盤演示模式已關閉。"

--- Live keyboard layers
msg.LAYERS[Musician.KEYBOARD_LAYER.UPPER] = "上層"
msg.LAYERS[Musician.KEYBOARD_LAYER.LOWER] = "下層"

--- Chat emotes
msg.EMOTE_PLAYING_MUSIC = "正在演奏一首音樂。"
msg.EMOTE_PROMO = "(安裝 \"Musician\" 插件就可以聽了)"
msg.EMOTE_SONG_NOT_LOADED = "(這首音樂無法播放，因為玩家 {player}使用的插件版本和你不兼容。)"
msg.EMOTE_PLAYER_OTHER_REALM = "(這個玩家處於另一個服務器。)"
msg.EMOTE_PLAYER_OTHER_FACTION = "(該玩家來自另一個陣營。)"

--- Minimap button tooltips
msg.TOOLTIP_LEFT_CLICK = "**左鍵點擊**: {action}"
msg.TOOLTIP_RIGHT_CLICK = "**右鍵點擊**: {action}"
msg.TOOLTIP_DRAG_AND_DROP = "**拖放** 來移動"
msg.TOOLTIP_ISMUTED = "(已靜音)"
msg.TOOLTIP_ACTION_OPEN_MENU = "打開主菜單"
msg.TOOLTIP_ACTION_MUTE = "靜音所有音樂"
msg.TOOLTIP_ACTION_UNMUTE = "取消靜音"

--- Player menu options
msg.PLAYER_MENU_TITLE = "音樂"
msg.PLAYER_MENU_STOP_CURRENT_SONG = "停止當前音樂"
msg.PLAYER_MENU_MUTE = "靜音"
msg.PLAYER_MENU_UNMUTE = "取消靜音"

--- Player actions feedback
msg.PLAYER_IS_MUTED = "{icon}{player}已靜音。"
msg.PLAYER_IS_UNMUTED = "{icon}{player}已關閉靜音。"

--- Song links
msg.LINKS_PREFIX = "音樂"
msg.LINKS_FORMAT = "{prefix}: {title}"
msg.LINKS_LINK_BUTTON = "鏈接"
msg.LINKS_CHAT_BUBBLE = "“{note}{title}”"

--- Song link export frame
msg.LINK_EXPORT_WINDOW_TITLE = "創建音樂鏈接"
msg.LINK_EXPORT_WINDOW_SONG_TITLE_LABEL = "音樂標題："
msg.LINK_EXPORT_WINDOW_HINT = "鏈接將在你退出登陸或重載界面前一直有效。"
msg.LINK_EXPORT_WINDOW_PROGRESS = "正在創建鏈接…… {progress}%"
msg.LINK_EXPORT_WINDOW_POST_BUTTON = "將鏈接粘貼到聊天框"

--- Song link import frame
msg.LINK_IMPORT_WINDOW_TITLE = "從玩家{player}導入音樂："
msg.LINK_IMPORT_WINDOW_HINT = "點擊“導入”以開始將音樂導入Musician。"
msg.LINK_IMPORT_WINDOW_IMPORT_BUTTON = "導入音樂"
msg.LINK_IMPORT_WINDOW_CANCEL_IMPORT_BUTTON = "取消導入"
msg.LINK_IMPORT_WINDOW_REQUESTING = "正從玩家{player}請求數據……"
msg.LINK_IMPORT_WINDOW_PROGRESS = "導入中……{progress}%"
msg.LINK_IMPORT_WINDOW_SELECT_ACCOUNT = "請選擇希望獲取歌曲的角色："

--- Song links errors
msg.LINKS_ERROR.notFound = "音樂“{title}”無法從玩家{player}獲取。"
msg.LINKS_ERROR.alreadySending = "玩家{player}已經向你發送了一首音樂。請幾秒後重試。"
msg.LINKS_ERROR.alreadyRequested = "玩家{player}已經請求發送一首音樂。"
msg.LINKS_ERROR.timeout = "玩家{player}沒有響應。"
msg.LINKS_ERROR.offline = "{player}未登錄魔獸世界。"
msg.LINKS_ERROR.importingFailed = "歌曲{title}無法從玩家{player}處導入。"

--- Map tracking options
msg.MAP_TRACKING_OPTIONS_TITLE = "Musician"
msg.MAP_TRACKING_OPTION_ACTIVE_MUSICIANS = "活躍音樂家"

--- Total RP Extended module
msg.TRPE_ITEM_NAME = "{title}"
msg.TRPE_ITEM_TOOLTIP_REQUIRES_MUSICIAN = "需要Musician"
msg.TRPE_ITEM_TOOLTIP_SHEET_MUSIC = "樂譜"
msg.TRPE_ITEM_USE_HINT = "閱讀樂譜"
msg.TRPE_ITEM_MUSICIAN_NOT_FOUND = "你需要安裝最新版本的“Musician”插件來使用這個物品。\n從{url}下載"
msg.TRPE_ITEM_NOTES = "將音樂導入至Musician以向附近的玩家播放。\n\n下載Musician：{url}\n"

msg.TRPE_EXPORT_BUTTON = "導出"
msg.TRPE_EXPORT_WINDOW_TITLE = "將音樂導出為Total RP 3物品"
msg.TRPE_EXPORT_WINDOW_LOCALE = "物品語言："
msg.TRPE_EXPORT_WINDOW_ADD_TO_BAG = "添加到背包"
msg.TRPE_EXPORT_WINDOW_QUANTITY = "數量"
msg.TRPE_EXPORT_WINDOW_HINT_NEW = "創建一個可以交易給其他玩家的Total RP 3物品。"
msg.TRPE_EXPORT_WINDOW_HINT_EXISTING = "已經存在一個這首音樂的物品了，它將被更新。"
msg.TRPE_EXPORT_WINDOW_CREATE_ITEM_BUTTON = "創建物品"
msg.TRPE_EXPORT_WINDOW_PROGRESS = "創建物品……{progress}%"

--- Musician instrument names
msg.INSTRUMENT_NAMES["none"] = "(無)"
msg.INSTRUMENT_NAMES["accordion"] = "手風琴"
msg.INSTRUMENT_NAMES["bagpipe"] = "風笛"
msg.INSTRUMENT_NAMES["dulcimer"] = "擊鎚揚琴"
msg.INSTRUMENT_NAMES["lute"] = "魯特琴"
msg.INSTRUMENT_NAMES["viola-da-gamba"] = "維奧爾琴（古大提琴）"
msg.INSTRUMENT_NAMES["harp"] = "凱爾特豎琴"
msg.INSTRUMENT_NAMES["male-voice"] = "男高音"
msg.INSTRUMENT_NAMES["female-voice"] = "女高音"
msg.INSTRUMENT_NAMES["trumpet"] = "小號"
msg.INSTRUMENT_NAMES["sackbut"] = "古長號"
msg.INSTRUMENT_NAMES["war-horn"] = "戰爭號角"
msg.INSTRUMENT_NAMES["bassoon"] = "大管"
msg.INSTRUMENT_NAMES["clarinet"] = "單簧管"
msg.INSTRUMENT_NAMES["recorder"] = "豎笛"
msg.INSTRUMENT_NAMES["fiddle"] = "類提琴樂器"
msg.INSTRUMENT_NAMES["percussions"] = "打擊樂（傳統）"
msg.INSTRUMENT_NAMES["distortion-guitar"] = "變音電吉他"
msg.INSTRUMENT_NAMES["clean-guitar"] = "清音吉他"
msg.INSTRUMENT_NAMES["bass-guitar"] = "貝斯吉他"
msg.INSTRUMENT_NAMES["drumkit"] = "鼓組"
msg.INSTRUMENT_NAMES["war-drum"] = "戰鼓"
msg.INSTRUMENT_NAMES["woodblock"] = "木塊"
msg.INSTRUMENT_NAMES["tambourine-shake"] = "鈴鼓"

--- General MIDI instrument names
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGrandPiano] = "大鋼琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrightAcousticPiano] = "亮音立式鋼琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGrandPiano] = "電聲大鋼琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.HonkyTonkPiano] = "叮噹琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricPiano1] = "電鋼琴1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricPiano2] = "電鋼琴2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Harpsichord] = "撥弦古鋼琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Clavi] = "擊弦古鋼琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Celesta] = "鋼片琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Glockenspiel] = "鍾琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MusicBox] = "八音盒"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Vibraphone] = "電顫琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Marimba] = "馬林巴琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Xylophone] = "木琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TubularBells] = "管鐘"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Dulcimer] = "揚琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.DrawbarOrgan] = "拉桿風琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PercussiveOrgan] = "打擊型風琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.RockOrgan] = "搖滾風琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ChurchOrgan] = "管風琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ReedOrgan] = "簧風琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Accordion] = "手風琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Harmonica] = "口琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TangoAccordion] = "探戈手風琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGuitarNylon] = "古典吉他"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGuitarSteel] = "民謠吉他"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarJazz] = "爵士電吉他"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarClean] = "清音電吉他"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarMuted] = "弱音電吉他"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OverdrivenGuitar] = "失真音效電吉他"
msg.MIDI_INSTRUMENT_NAMES[Instrument.DistortionGuitar] = "破音音效電吉他"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Guitarharmonics] = "吉他泛音"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticBass] = "原聲貝斯"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricBassFinger] = "指撥電貝斯"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricBassPick] = "撥片電貝斯"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FretlessBass] = "無品貝斯"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SlapBass1] = "擊弦貝斯1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SlapBass2] = "擊弦貝斯2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBass1] = "合成貝斯1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBass2] = "合成貝斯2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Violin] = "小提琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Viola] = "中提琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Cello] = "大提琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Contrabass] = "低音提琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TremoloStrings] = "弦樂震音"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PizzicatoStrings] = "弦樂撥奏"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestralHarp] = "豎琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Timpani] = "定音鼓"
msg.MIDI_INSTRUMENT_NAMES[Instrument.StringEnsemble1] = "弦樂合奏1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.StringEnsemble2] = "弦樂合奏2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthStrings1] = "合成弦樂1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthStrings2] = "合成弦樂2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ChoirAahs] = "合唱“啊”音"
msg.MIDI_INSTRUMENT_NAMES[Instrument.VoiceOohs] = "人聲“嘟”音"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthVoice] = "合成人聲"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestraHit] = "管弦樂隊重音齊奏"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Trumpet] = "小號"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Trombone] = "長號"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Tuba] = "大號"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MutedTrumpet] = "弱音小號"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FrenchHorn] = "圓號"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrassSection] = "銅管組"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBrass1] = "合成銅管1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBrass2] = "合成銅管2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SopranoSax] = "高音薩克斯"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AltoSax] = "中音薩克斯"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TenorSax] = "次中音薩克斯"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BaritoneSax] = "上低音薩克斯"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Oboe] = "雙簧管"
msg.MIDI_INSTRUMENT_NAMES[Instrument.EnglishHorn] = "英國管"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Bassoon] = "大管"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Clarinet] = "單簧管"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Piccolo] = "短笛"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Flute] = "長笛"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Recorder] = "豎笛"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PanFlute] = "長笛"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BlownBottle] = "吹瓶口"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shakuhachi] = "尺八"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Whistle] = "口哨"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Ocarina] = "洋塤"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead1Square] = "合成主音1（方波）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead2Sawtooth] = "合成主音2（鋸齒波）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead3Calliope] = "合成主音3（汽笛風琴）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead4Chiff] = "合成主音4 （吹管）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead5Charang] = "合成主音5（吉他）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead6Voice] = "合成主音6（人聲）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead7Fifths] = "合成主音7（五度鋸齒波）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead8BassLead] = "合成主音8（貝斯加主音）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad1Newage] = "合成柔音1（幻想/新時代）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad2Warm] = "合成柔音（溫暖）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad3Polysynth] = "合成柔音3（八度複音合成）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad4Choir] = "合成柔音4（太空合唱）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad5Bowed] = "合成柔音5（弓奏玻璃杯）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad6Metallic] = "合成柔音6（金屬）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad7Halo] = "合成柔音7（光環）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad8Sweep] = "合成柔音8（橫掃）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX1Rain] = "合成特效1（雨）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX2Soundtrack] = "合成特效2（音軌）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX3Crystal] = "合成特效3（水晶）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX4Atmosphere] = "合成特效4（大氣）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX5Brightness] = "合成特效5（亮音）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX6Goblins] = "合成特效6（小妖）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX7Echoes] = "合成特效7（迴聲）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX8SciFi] = "合成特效8（科幻）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Sitar] = "印度西塔琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Banjo] = "班卓"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shamisen] = "三味線"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Koto] = "日本十三弦箏"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Kalimba] = "卡林巴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Bagpipe] = "風笛"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Fiddle] = "類提琴樂器"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shanai] = "嗩吶"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TinkleBell] = "鈴鐺"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Agogo] = "拉丁打鈴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SteelDrums] = "鋼鼓"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Woodblock] = "木塊"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TaikoDrum] = "太鼓"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MelodicTom] = "嗵鼓"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthDrum] = "合成嗵鼓"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ReverseCymbal] = "镲波形反轉"
msg.MIDI_INSTRUMENT_NAMES[Instrument.GuitarFretNoise] = "磨弦聲"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BreathNoise] = "呼吸聲"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Seashore] = "海浪聲"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BirdTweet] = "鳥鳴聲"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TelephoneRing] = "電話鈴聲"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Helicopter] = "直升機聲"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Applause] = "歡呼鼓掌聲"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Gunshot] = "槍聲"

--- General MIDI drum kit names
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_INSTRUMENT_NAMES[Instrument.StandardKit] = "標準鼓組"
msg.MIDI_INSTRUMENT_NAMES[Instrument.RoomKit] = "錄音室鼓組"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PowerKit] = "強音鼓組"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectronicKit] = "電子鼓組"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TR808Kit] = "TR-808鼓組"
msg.MIDI_INSTRUMENT_NAMES[Instrument.JazzKit] = "爵士鼓組"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrushKit] = "鼓刷鼓組"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestraKit] = "管弦樂鼓組"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SoundFXKit] = "聲音效果"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MT32Kit] = "MT-32鼓組"
msg.MIDI_INSTRUMENT_NAMES[Instrument.None] = "(無)"
msg.UNKNOWN_DRUMKIT = "未知鼓組 ({midi})"

--- General MIDI percussion list
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_PERCUSSION_NAMES[Percussion.Laser] = "激光" -- MIDI key 27
msg.MIDI_PERCUSSION_NAMES[Percussion.Whip] = "鞭打" -- MIDI key 28
msg.MIDI_PERCUSSION_NAMES[Percussion.ScratchPush] = "特效處理推音" -- MIDI key 29
msg.MIDI_PERCUSSION_NAMES[Percussion.ScratchPull] = "特效處理拉音" -- MIDI key 30
msg.MIDI_PERCUSSION_NAMES[Percussion.StickClick] = "鼓槌對敲" -- MIDI key 31
msg.MIDI_PERCUSSION_NAMES[Percussion.SquareClick] = "敲方板" -- MIDI key 32
msg.MIDI_PERCUSSION_NAMES[Percussion.MetronomeClick] = "節拍器" -- MIDI key 33
msg.MIDI_PERCUSSION_NAMES[Percussion.MetronomeBell] = "節拍器重音" -- MIDI key 34
msg.MIDI_PERCUSSION_NAMES[Percussion.AcousticBassDrum] = "低音大鼓" -- MIDI key 35
msg.MIDI_PERCUSSION_NAMES[Percussion.BassDrum1] = "高音大鼓" -- MIDI key 36
msg.MIDI_PERCUSSION_NAMES[Percussion.SideStick] = "鼓邊" -- MIDI key 37
msg.MIDI_PERCUSSION_NAMES[Percussion.AcousticSnare] = "小鼓" -- MIDI key 38
msg.MIDI_PERCUSSION_NAMES[Percussion.HandClap] = "拍手聲" -- MIDI key 39
msg.MIDI_PERCUSSION_NAMES[Percussion.ElectricSnare] = "電子小鼓" -- MIDI key 40
msg.MIDI_PERCUSSION_NAMES[Percussion.LowFloorTom] = "低音落地嗵鼓" -- MIDI key 41
msg.MIDI_PERCUSSION_NAMES[Percussion.ClosedHiHat] = "合音踩镲" -- MIDI key 42
msg.MIDI_PERCUSSION_NAMES[Percussion.HighFloorTom] = "高音落地嗵鼓" -- MIDI key 43
msg.MIDI_PERCUSSION_NAMES[Percussion.PedalHiHat] = "踏音踩镲" -- MIDI key 44
msg.MIDI_PERCUSSION_NAMES[Percussion.LowTom] = "低音嗵鼓" -- MIDI key 45
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenHiHat] = "開音踩镲" -- MIDI key 46
msg.MIDI_PERCUSSION_NAMES[Percussion.LowMidTom] = "中低音嗵鼓" -- MIDI key 47
msg.MIDI_PERCUSSION_NAMES[Percussion.HiMidTom] = "中高音嗵鼓" -- MIDI key 48
msg.MIDI_PERCUSSION_NAMES[Percussion.CrashCymbal1] = "低砸音镲" -- MIDI key 49
msg.MIDI_PERCUSSION_NAMES[Percussion.HighTom] = "高音嗵鼓" -- MIDI key 50
msg.MIDI_PERCUSSION_NAMES[Percussion.RideCymbal1] = "低浮音镲" -- MIDI key 51
msg.MIDI_PERCUSSION_NAMES[Percussion.ChineseCymbal] = "中國镲" -- MIDI key 52
msg.MIDI_PERCUSSION_NAMES[Percussion.RideBell] = "浮音镲碗" -- MIDI key 53
msg.MIDI_PERCUSSION_NAMES[Percussion.Tambourine] = "鈴鼓" -- MIDI key 54
msg.MIDI_PERCUSSION_NAMES[Percussion.SplashCymbal] = "濺音镲" -- MIDI key 55
msg.MIDI_PERCUSSION_NAMES[Percussion.Cowbell] = "牛鈴" -- MIDI key 56
msg.MIDI_PERCUSSION_NAMES[Percussion.CrashCymbal2] = "高砸音镲" -- MIDI key 57
msg.MIDI_PERCUSSION_NAMES[Percussion.Vibraslap] = "顫音叉" -- MIDI key 58
msg.MIDI_PERCUSSION_NAMES[Percussion.RideCymbal2] = "高浮音镲" -- MIDI key 59
msg.MIDI_PERCUSSION_NAMES[Percussion.HiBongo] = "高音邦戈" -- MIDI key 60
msg.MIDI_PERCUSSION_NAMES[Percussion.LowBongo] = "低音邦戈" -- MIDI key 61
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteHiConga] = "弱音康加" -- MIDI key 62
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenHiConga] = "高音康加" -- MIDI key 63
msg.MIDI_PERCUSSION_NAMES[Percussion.LowConga] = "低音康加" -- MIDI key 64
msg.MIDI_PERCUSSION_NAMES[Percussion.HighTimbale] = "高音銅鼓" -- MIDI key 65
msg.MIDI_PERCUSSION_NAMES[Percussion.LowTimbale] = "低音銅鼓" -- MIDI key 66
msg.MIDI_PERCUSSION_NAMES[Percussion.HighAgogo] = "高音拉丁打鈴" -- MIDI key 67
msg.MIDI_PERCUSSION_NAMES[Percussion.LowAgogo] = "低音拉丁打鈴" -- MIDI key 68
msg.MIDI_PERCUSSION_NAMES[Percussion.Cabasa] = "沙錘" -- MIDI key 69
msg.MIDI_PERCUSSION_NAMES[Percussion.Maracas] = "響葫蘆" -- MIDI key 70
msg.MIDI_PERCUSSION_NAMES[Percussion.ShortWhistle] = "短哨" -- MIDI key 71
msg.MIDI_PERCUSSION_NAMES[Percussion.LongWhistle] = "長哨" -- MIDI key 72
msg.MIDI_PERCUSSION_NAMES[Percussion.ShortGuiro] = "短鋸琴" -- MIDI key 73
msg.MIDI_PERCUSSION_NAMES[Percussion.LongGuiro] = "長鋸琴" -- MIDI key 74
msg.MIDI_PERCUSSION_NAMES[Percussion.Claves] = "擊桿" -- MIDI key 75
msg.MIDI_PERCUSSION_NAMES[Percussion.HiWoodBlock] = "高音木塊" -- MIDI key 76
msg.MIDI_PERCUSSION_NAMES[Percussion.LowWoodBlock] = "低音木塊" -- MIDI key 77
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteCuica] = "弱音吉加" -- MIDI key 78
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenCuica] = "開音吉加" -- MIDI key 79
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteTriangle] = "弱音三角鐵" -- MIDI key 80
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenTriangle] = "開音三角鐵" -- MIDI key 81
msg.MIDI_PERCUSSION_NAMES[Percussion.Shaker] = "沙錘（高音）" -- MIDI key 82
msg.MIDI_PERCUSSION_NAMES[Percussion.SleighBell] = "馬鈴" -- MIDI key 83
msg.MIDI_PERCUSSION_NAMES[Percussion.BellTree] = "鈴樹" -- MIDI key 84
msg.MIDI_PERCUSSION_NAMES[Percussion.Castanets] = "響板" -- MIDI key 85
msg.MIDI_PERCUSSION_NAMES[Percussion.SurduDeadStroke] = "巴西鼓終音" -- MIDI key 86
msg.MIDI_PERCUSSION_NAMES[Percussion.Surdu] = "巴西鼓" -- MIDI key 87
msg.MIDI_PERCUSSION_NAMES[Percussion.SnareDrumRod] = "軍鼓擊桿" -- MIDI key 88
msg.MIDI_PERCUSSION_NAMES[Percussion.OceanDrum] = "撥浪鼓" -- MIDI key 89
msg.MIDI_PERCUSSION_NAMES[Percussion.SnareDrumBrush] = "軍鼓擦桿" -- MIDI key 90
