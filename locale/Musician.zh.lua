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

local msg = Musician.InitLocale("zh", "中文", "zhCN")

local Instrument = Musician.MIDI_INSTRUMENTS
local Percussion = Musician.MIDI_PERCUSSIONS
local KEY = Musician.KEYBOARD_KEY

------------------------------------------------------------------------
---------------- ↑↑↑ DO NOT EDIT THE LINES ABOVE ! ↑↑↑  ----------------
------------------------------------------------------------------------

--- Main frame controls
msg.PLAY = "播放"
msg.STOP = "停止"
msg.PAUSE = "暂停"
msg.TEST_SONG = "预览"
msg.STOP_TEST = "停止预览"
msg.CLEAR = "清除"
msg.SELECT_ALL = "全选"
msg.EDIT = "编辑"
msg.MUTE = "静音"
msg.UNMUTE = "取消静音"

--- Minimap button menu
msg.MENU_TITLE = "Musician"
msg.MENU_IMPORT_SONG = "导入并播放一首音乐"
msg.MENU_PLAY = "播放"
msg.MENU_STOP = "停止"
msg.MENU_PLAY_PREVIEW = "预览"
msg.MENU_STOP_PREVIEW = "停止预览"
msg.MENU_LIVE_PLAY = "现场演奏"
msg.MENU_SHOW_KEYBOARD = "打开键盘"
msg.MENU_SETTINGS = "设定"
msg.MENU_OPTIONS = "选项"
msg.MENU_ABOUT = "关于"

--- Chat commands
msg.COMMAND_LIST_TITLE = "Musician指令："
msg.COMMAND_SHOW = "显示音乐导入窗口"
msg.COMMAND_PREVIEW_PLAY = "开始或停止预览音乐"
msg.COMMAND_PREVIEW_STOP = "停止预览音乐"
msg.COMMAND_PLAY = "播放或停止播放音乐"
msg.COMMAND_STOP = "停止播放音乐"
msg.COMMAND_SONG_EDITOR = "打开音乐编辑器"
msg.COMMAND_LIVE_KEYBOARD = "打开演奏键盘"
msg.COMMAND_CONFIGURE_KEYBOARD = "设置键盘"
msg.COMMAND_LIVE_DEMO = "键盘演示模式"
msg.COMMAND_LIVE_DEMO_PARAMS = "{ **<上音轨编号>** **<下音轨编号>** || **关闭** }"
msg.COMMAND_HELP = "显示这条帮助信息"
msg.ERR_COMMAND_UNKNOWN = "未知的 \"{command}\" 指令。输入 {help} 来获得指令表。"

--- Add-on options
msg.OPTIONS_TITLE = "Musician"
msg.OPTIONS_SUB_TEXT = "加入Discord社区来帮助我们！ {url}"
msg.OPTIONS_CATEGORY_EMOTE = "表情"
msg.OPTIONS_ENABLE_EMOTE_LABEL = "当播放音乐时，向没有Musician插件的玩家发送一条表情信息。"
msg.OPTIONS_ENABLE_EMOTE_PROMO_LABEL = "以一条短文字来邀请他们安装插件，这样他们就能听到你的演奏了。"
msg.OPTIONS_EMOTE_HINT = "当你播放音乐的时候，没有Musician插件的玩家会收到一条表情信息。你可以在[options]当中禁用它."
msg.OPTIONS_INTEGRATION_OPTIONS_TITLE = "游戏内嵌整合选项"
msg.OPTIONS_AUTO_MUTE_GAME_MUSIC_LABEL = "播放歌曲时静音游戏背景音乐。"
msg.OPTIONS_MUTE_INSTRUMENT_TOYS_LABEL = "静音来自乐器玩具的音乐。{icons}"
msg.OPTIONS_AUDIO_CHANNELS_TITLE = "声音频道"
msg.OPTIONS_AUDIO_CHANNELS_HINT = "选择更多的声音频道以增加Musician同时能播放的音符数量。"
msg.OPTIONS_AUDIO_CHANNELS_CHANNEL_POLYPHONY = "{channel} ({polyphony})"
msg.OPTIONS_AUDIO_CHANNELS_TOTAL_POLYPHONY = "总最大复调数： {polyphony}"
msg.OPTIONS_AUDIO_CHANNELS_AUTO_ADJUST_CONFIG = "多个声音频道启用时自动优化声音设置。"
msg.OPTIONS_AUDIO_CACHE_SIZE_FOR_MUSICIAN = "对于Musician (%dMB)"
msg.OPTIONS_CATEGORY_SHORTCUTS = "快捷方式"
msg.OPTIONS_SHORTCUT_MINIMAP = "小地图按钮"
msg.OPTIONS_SHORTCUT_ADDON_MENU = "小地图菜单"
msg.OPTIONS_QUICK_PRELOADING_TITLE = "快速预加载"
msg.OPTIONS_QUICK_PRELOADING_TEXT = "在冷启动时启用仪器快速预加载。"
msg.OPTIONS_CATEGORY_NAMEPLATES = "姓名版和动作"
msg.OPTIONS_CATEGORY_NAMEPLATES_SUB_TEXT = "打开姓名版选项以便看到正在演奏音乐的玩家的动画并确认附近有\n谁可以听到你。"
msg.OPTIONS_ENABLE_NAMEPLATES = "启用姓名版和动画。"
msg.OPTIONS_SHOW_NAMEPLATE_ICON = "在拥有Musician插件的玩家名字旁边显示一个{icon}图标。"
msg.OPTIONS_HIDE_HEALTH_BARS = "在未进入战斗时，隐藏玩家和友善单位的姓名版。"
msg.OPTIONS_HIDE_NPC_NAMEPLATES = "隐藏NPC姓名版。"
msg.OPTIONS_CINEMATIC_MODE = "当使用{binding}关闭UI姓名版时也显示动画。"
msg.OPTIONS_CINEMATIC_MODE_NO_BINDING = "隐藏UI时显示动画。"
msg.OPTIONS_NAMEPLATES_CINEMATIC_MODE = "隐藏UI时显示姓名版。"
msg.OPTIONS_TRP3 = "Total RP 3"
msg.OPTIONS_TRP3_MAP_SCAN = "在地图上拥有Musician插件的玩家名字旁边显示一个{icon}图标。"
msg.OPTIONS_CROSS_RP_TITLE = "Cross RP"
msg.OPTIONS_CROSS_RP_SUB_TEXT = "安装Tammya-月亮守卫的Cross RP插件来进行跨服/跨阵营的音乐演奏！"
msg.OPTIONS_CROSS_RP_SUB_TEXT_NO_GATEWAY = "目前暂无可用的Cross RP节点。\n请耐心等待……"
msg.OPTIONS_CROSS_RP_SUB_TEXT_ACTIVE = "Cross RP连接已在以下位置启动：\n\n{bands}"

--- Tips and Tricks
msg.TIPS_AND_TRICKS_ENABLE = "启动时显示小贴士。"

msg.TIPS_AND_TRICKS_NAMEPLATES_TITLE = "动画和姓名版"
msg.TIPS_AND_TRICKS_NAMEPLATES_TEXT = "当姓名版选项打开时，正在播放音乐的玩家会显示特殊动画。\n\n{icon}显示了安装Musician并能听到你演奏的玩家。\n\n你想打开姓名版和动画吗？"
msg.TIPS_AND_TRICKS_NAMEPLATES_OK = "打开姓名版和动画"
msg.TIPS_AND_TRICKS_NAMEPLATES_CANCEL = "稍后再说"

msg.TIPS_AND_TRICKS_CROSS_RP_TITLE = "使用Cross RP进行跨阵营/跨服演奏"
msg.TIPS_AND_TRICKS_CROSS_RP_TEXT = "安装Tammya-月亮守卫的Cross RP插件来进行跨服/跨阵营的音乐演奏！"
msg.TIPS_AND_TRICKS_CROSS_RP_OK = "好的"

--- Welcome messages
msg.STARTUP = "欢迎使用Musician v{version}."
msg.PLAYER_COUNT_ONLINE = "现在有{count}个音乐迷在线！"
msg.PLAYER_COUNT_ONLINE_ONE = "有一个音乐迷在线！"
msg.PLAYER_COUNT_ONLINE_NONE = "没有在线的音乐迷。"

--- New version notifications
msg.NEW_VERSION = "一个新的Musician版本发布了！可以在以下链接下载升级：{url}。"
msg.NEW_PROTOCOL_VERSION = "你的Musician版本过老，已经无法使用。\n请前往以下链接升级\n{url}"

-- Module warnings
msg.ERR_INCOMPATIBLE_MODULE_API = "{module} 的 Musician 模块无法启动，因为 {module} 不兼容。尝试更新 Musician 和 {module}。"

-- Loading screen
msg.LOADING_SCREEN_MESSAGE = "Musician 正在将乐器样本预加载到缓存中……"
msg.LOADING_SCREEN_CLOSE_TOOLTIP = "关闭并在后台继续预加载。"

--- Player tooltips
msg.PLAYER_TOOLTIP = "Musician"
msg.PLAYER_TOOLTIP_VERSION = "{name} v{version}"
msg.PLAYER_TOOLTIP_VERSION_OUTDATED = " (当前版本已过期)"
msg.PLAYER_TOOLTIP_VERSION_INCOMPATIBLE = " (当前版本不兼容)"
msg.PLAYER_TOOLTIP_PRELOADING = "音效预载中……({progress})"

--- URL hyperlinks tooltip
msg.TOOLTIP_COPY_URL = "按 {shortcut} 复制。"

--- Song import
msg.INVALID_MUSIC_CODE = "音乐代码无效。"
msg.PLAY_A_SONG = "播放音乐"
msg.IMPORT_A_SONG = "导入音乐"
msg.PASTE_MUSIC_CODE = "通过以下地址导入你MIDI格式的音乐\n{url}\n\n并把音乐代码粘贴在这里({shortcut})…"
msg.SONG_IMPORTED = "音乐已载入：{title}."

--- Play as a band
msg.PLAY_IN_BAND = "乐队演奏"
msg.PLAY_IN_BAND_HINT = "当你准备好和你的乐队一起演奏时，点击这里。"
msg.PLAY_IN_BAND_READY_PLAYERS = "已就绪的乐队成员："
msg.EMOTE_PLAYER_IS_READY = "已准备好作为乐队成员演奏。"
msg.EMOTE_PLAYER_IS_NOT_READY = "已离开就绪状态。"
msg.EMOTE_PLAY_IN_BAND_START = "开始乐队演奏。"
msg.EMOTE_PLAY_IN_BAND_STOP = "停止乐队演奏。"

--- Play as a band (live)
msg.LIVE_SYNC = "乐队现场演奏。"
msg.LIVE_SYNC_HINT = "点击这里进行乐队演奏同步。"
msg.SYNCED_PLAYERS = "就位的乐队成员："
msg.EMOTE_PLAYER_LIVE_SYNC_ENABLED = "正在和你一起演奏音乐。"
msg.EMOTE_PLAYER_LIVE_SYNC_DISABLED = "停止了和你演奏音乐。"

--- Song editor frame
msg.SONG_EDITOR = "音乐编辑器"
msg.MARKER_FROM = "从"
msg.MARKER_TO = "到"
msg.POSITION = "位置"
msg.TRACK_NUMBER = "音轨 #{track}"
msg.CHANNEL_NUMBER_SHORT = "频道.{channel}"
msg.JUMP_PREV = "后退10秒"
msg.JUMP_NEXT = "前进10秒"
msg.GO_TO_START = "前往起始"
msg.GO_TO_END = "前往结尾"
msg.SET_CROP_FROM = "设置起始点"
msg.SET_CROP_TO = "设置结尾点"
msg.SYNCHRONIZE_TRACKS = "以当前音乐同步音轨设定"
msg.MUTE_TRACK = "静音"
msg.SOLO_TRACK = "独奏"
msg.ACCENT_TRACK = "强调"
msg.TRANSPOSE_TRACK = "变调(八度音阶)"
msg.CHANGE_TRACK_INSTRUMENT = "切换乐器"
msg.HEADER_NUMBER = "#"
msg.HEADER_OCTAVE = "八度音阶"
msg.HEADER_INSTRUMENT = "乐器"
msg.HEADER_ACCENT = "x2"

--- Configure live keyboard frame
msg.SHOULD_CONFIGURE_KEYBOARD = "在开始演奏前需要对键盘进行设置。"
msg.CONFIGURE_KEYBOARD = "设置键盘"
msg.CONFIGURE_KEYBOARD_HINT = "点击一个键以设置……"
msg.CONFIGURE_KEYBOARD_HINT_COMPLETE = "键盘设置已完成。\n你现在可以保存更改并开始演奏了！"
msg.CONFIGURE_KEYBOARD_START_OVER = "重新设置"
msg.CONFIGURE_KEYBOARD_SAVE = "保存配置"
msg.PRESS_KEY_BINDING = "按下 #{col}列#{row}行的按钮。"
msg.KEY_CAN_BE_EMPTY = "该密钥是可选的，可以为空。"
msg.KEY_IS_MERGEABLE = "这可以和你键盘上的{key}键相同：{action}"
msg.KEY_CAN_BE_MERGED = "此时，请直接按下{key}键。"
msg.KEY_CANNOT_BE_MERGED = "此时，请忽略并设置下一个键。"
msg.NEXT_KEY = "下一个按键"
msg.CLEAR_KEY = "清除按键"

--- About frame
msg.ABOUT_TITLE = "Musician"
msg.ABOUT_VERSION = "版本 {version}"
msg.ABOUT_AUTHOR = "By LenweSaralonde – {url}"
msg.ABOUT_LICENSE = "本插件遵循GNU通用公共授权v3.0"
msg.ABOUT_DISCORD = "Discord: {url}"
msg.ABOUT_SUPPORT = "你喜欢Musician吗？把它分享给大家吧！"
msg.ABOUT_PATREON = "Patreon: {url}"
msg.ABOUT_PAYPAL = "PayPal: {url}"
msg.ABOUT_SUPPORTERS = "特别鸣谢本插件的捐助者们！ <3"
msg.ABOUT_LOCALIZATION_TEAM = "本地化团队:"
msg.ABOUT_CONTRIBUTE_TO_LOCALIZATION = "帮助我们将Musician翻译为你的语言！\n{url}"

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
msg.KEYBOARD_LAYOUTS["Piano"] = "钢琴"
msg.KEYBOARD_LAYOUTS["Chromatic"] = "半音阶"
msg.KEYBOARD_LAYOUTS["Modes"] = "调式"
msg.KEYBOARD_LAYOUTS["Ionian"] = "伊奥尼亚调式"
msg.KEYBOARD_LAYOUTS["Dorian"] = "多利亚调式"
msg.KEYBOARD_LAYOUTS["Phrygian"] = "弗利几亚调式"
msg.KEYBOARD_LAYOUTS["Lydian"] = "利底亚调式"
msg.KEYBOARD_LAYOUTS["Mixolydian"] = "混合利底亚调式"
msg.KEYBOARD_LAYOUTS["Aeolian"] = "爱奥利亚调式"
msg.KEYBOARD_LAYOUTS["Locrian"] = "洛克利亚调式"
msg.KEYBOARD_LAYOUTS["minor Harmonic"] = "和声小调"
msg.KEYBOARD_LAYOUTS["minor Melodic"] = "旋律小调"
msg.KEYBOARD_LAYOUTS["Blues scales"] = "布鲁斯音阶"
msg.KEYBOARD_LAYOUTS["Major Blues"] = "大调布鲁斯"
msg.KEYBOARD_LAYOUTS["minor Blues"] = "小调布鲁斯"
msg.KEYBOARD_LAYOUTS["Diminished scales"] = "减音阶"
msg.KEYBOARD_LAYOUTS["Diminished"] = "减弱"
msg.KEYBOARD_LAYOUTS["Complement Diminished"] = "补充减弱"
msg.KEYBOARD_LAYOUTS["Pentatonic scales"] = "五声音阶"
msg.KEYBOARD_LAYOUTS["Major Pentatonic"] = "大五声"
msg.KEYBOARD_LAYOUTS["minor Pentatonic"] = "小五声"
msg.KEYBOARD_LAYOUTS["World scales"] = "世界音阶"
msg.KEYBOARD_LAYOUTS["Raga 1"] = "印度拉加 1"
msg.KEYBOARD_LAYOUTS["Raga 2"] = "印度拉加 2"
msg.KEYBOARD_LAYOUTS["Raga 3"] = "印度拉加 3"
msg.KEYBOARD_LAYOUTS["Arabic"] = "阿拉伯"
msg.KEYBOARD_LAYOUTS["Spanish"] = "西班牙"
msg.KEYBOARD_LAYOUTS["Gypsy"] = "吉普赛"
msg.KEYBOARD_LAYOUTS["Egyptian"] = "埃及"
msg.KEYBOARD_LAYOUTS["Hawaiian"] = "夏威夷"
msg.KEYBOARD_LAYOUTS["Bali Pelog"] = "巴厘岛"
msg.KEYBOARD_LAYOUTS["Japanese"] = "日本"
msg.KEYBOARD_LAYOUTS["Ryukyu"] = "琉球"
msg.KEYBOARD_LAYOUTS["Chinese"] = "中国"
msg.KEYBOARD_LAYOUTS["Miscellaneous scales"] = "其他音阶"
msg.KEYBOARD_LAYOUTS["Bass Line"] = "贝斯弦"
msg.KEYBOARD_LAYOUTS["Wholetone"] = "全音"
msg.KEYBOARD_LAYOUTS["minor 3rd"] = "小三度"
msg.KEYBOARD_LAYOUTS["Major 3rd"] = "大三度"
msg.KEYBOARD_LAYOUTS["4th"] = "纯四度"
msg.KEYBOARD_LAYOUTS["5th"] = "纯五度"
msg.KEYBOARD_LAYOUTS["Octave"] = "八度"

--- Live keyboard layout types
msg.HORIZONTAL_LAYOUT = "水平"
msg.VERTICAL_LAYOUT = "垂直"

--- Live keyboard frame
msg.LIVE_SONG_NAME = "现场演奏"
msg.SOLO_MODE = "独奏模式"
msg.LIVE_MODE = "演奏模式"
msg.LIVE_MODE_DISABLED = "演奏模式在回放时已关闭。"
msg.ENABLE_SOLO_MODE = "启动独奏模式（演奏给自己听）"
msg.ENABLE_LIVE_MODE = "启动演奏模式（演奏给所有人听）"
msg.PLAY_LIVE = "开始演奏"
msg.PLAY_SOLO = "开始独奏"
msg.SHOW_KEYBOARD = "显示键盘"
msg.HIDE_KEYBOARD = "隐藏键盘"
msg.KEYBOARD_LAYOUT = "键盘模式和大小"
msg.CHANGE_KEYBOARD_LAYOUT = "修改键盘布局"
msg.BASE_KEY = "基础键"
msg.CHANGE_BASE_KEY = "基础键"
msg.CHANGE_LOWER_INSTRUMENT = "改变下方乐器"
msg.CHANGE_UPPER_INSTRUMENT = "改变上方乐器"
msg.LOWER_INSTRUMENT_MAPPED_TO_CHANNEL = "下方乐器(音轨 #{track})"
msg.UPPER_INSTRUMENT_MAPPED_TO_CHANNEL = "上方乐器(音轨 #{track})"
msg.SUSTAIN_KEY = "延音"
msg.POWER_CHORDS = "强力和弦"
msg.PROGRAM_BUTTON = "P {num}"
msg.EMPTY_PROGRAM = "空白程序"
msg.LOAD_PROGRAM_NUM = "载入程序 #{num} ({key})"
msg.SAVE_PROGRAM_NUM = "保存至程序 #{num} ({key})"
msg.DELETE_PROGRAM_NUM = "清空程序 #{num} ({key})"
msg.WRITE_PROGRAM = "保存程序 ({key})"
msg.DELETE_PROGRAM = "删除程序 ({key})"
msg.PROGRAM_SAVED = "程序 #{num} 已保存。"
msg.PROGRAM_DELETED = "程序 #{num} 已清空。"
msg.DEMO_MODE_ENABLED = "键盘演示模式启动：\n{mapping}"
msg.DEMO_MODE_MAPPING = "{layer} → 音轨 #{track}"
msg.DEMO_MODE_DISABLED = "键盘演示模式已关闭。"

--- Live keyboard layers
msg.LAYERS[Musician.KEYBOARD_LAYER.UPPER] = "上层"
msg.LAYERS[Musician.KEYBOARD_LAYER.LOWER] = "下层"

--- Chat emotes
msg.EMOTE_PLAYING_MUSIC = "正在演奏一首音乐。"
msg.EMOTE_PROMO = "(安装 \"Musician\" 插件就可以听了)"
msg.EMOTE_SONG_NOT_LOADED = "(这首音乐无法播放，因为玩家 {player}使用的插件版本和你不兼容。)"
msg.EMOTE_PLAYER_OTHER_REALM = "(这个玩家处于另一个服务器。)"
msg.EMOTE_PLAYER_OTHER_FACTION = "(该玩家来自另一个阵营。)"

--- Minimap button tooltips
msg.TOOLTIP_LEFT_CLICK = "**左键点击**: {action}"
msg.TOOLTIP_RIGHT_CLICK = "**右键点击**: {action}"
msg.TOOLTIP_DRAG_AND_DROP = "**拖放** 来移动"
msg.TOOLTIP_ISMUTED = "(已静音)"
msg.TOOLTIP_ACTION_OPEN_MENU = "打开主菜单"
msg.TOOLTIP_ACTION_MUTE = "静音所有音乐"
msg.TOOLTIP_ACTION_UNMUTE = "取消静音"

--- Player menu options
msg.PLAYER_MENU_TITLE = "音乐"
msg.PLAYER_MENU_STOP_CURRENT_SONG = "停止当前音乐"
msg.PLAYER_MENU_MUTE = "静音"
msg.PLAYER_MENU_UNMUTE = "取消静音"

--- Player actions feedback
msg.PLAYER_IS_MUTED = "{icon}{player}已静音。"
msg.PLAYER_IS_UNMUTED = "{icon}{player}已关闭静音。"

--- Song links
msg.LINKS_PREFIX = "音乐"
msg.LINKS_FORMAT = "{prefix}: {title}"
msg.LINKS_LINK_BUTTON = "链接"
msg.LINKS_CHAT_BUBBLE = "“{note}{title}”"

--- Song link export frame
msg.LINK_EXPORT_WINDOW_TITLE = "创建音乐链接"
msg.LINK_EXPORT_WINDOW_SONG_TITLE_LABEL = "音乐标题："
msg.LINK_EXPORT_WINDOW_HINT = "链接将在你退出登陆或重载界面前一直有效。"
msg.LINK_EXPORT_WINDOW_PROGRESS = "正在创建链接…… {progress}%"
msg.LINK_EXPORT_WINDOW_POST_BUTTON = "将链接粘贴到聊天框"

--- Song link import frame
msg.LINK_IMPORT_WINDOW_TITLE = "从玩家{player}导入音乐："
msg.LINK_IMPORT_WINDOW_HINT = "点击“导入”以开始将音乐导入Musician。"
msg.LINK_IMPORT_WINDOW_IMPORT_BUTTON = "导入音乐"
msg.LINK_IMPORT_WINDOW_CANCEL_IMPORT_BUTTON = "取消导入"
msg.LINK_IMPORT_WINDOW_REQUESTING = "正从玩家{player}请求数据……"
msg.LINK_IMPORT_WINDOW_PROGRESS = "导入中……{progress}%"
msg.LINK_IMPORT_WINDOW_SELECT_ACCOUNT = "请选择希望获取歌曲的角色："

--- Song links errors
msg.LINKS_ERROR.notFound = "音乐“{title}”无法从玩家{player}获取。"
msg.LINKS_ERROR.alreadySending = "玩家{player}已经向你发送了一首音乐。请几秒后重试。"
msg.LINKS_ERROR.alreadyRequested = "玩家{player}已经请求发送一首音乐。"
msg.LINKS_ERROR.timeout = "玩家{player}没有响应。"
msg.LINKS_ERROR.offline = "{player}未登录魔兽世界。"
msg.LINKS_ERROR.importingFailed = "歌曲{title}无法从玩家{player}处导入。"

--- Map tracking options
msg.MAP_OPTIONS_TITLE = "地图”"
msg.MAP_OPTIONS_SUB_TEXT = "显示附近在演奏的玩家："
msg.MAP_OPTIONS_MINI_MAP = "于小地图显示"
msg.MAP_OPTIONS_WORLD_MAP = "于世界地图显示"
msg.MAP_TRACKING_OPTIONS_TITLE = "Musician"
msg.MAP_TRACKING_OPTION_ACTIVE_MUSICIANS = "活跃音乐家"

--- Total RP Extended module
msg.TRPE_ITEM_NAME = "{title}"
msg.TRPE_ITEM_TOOLTIP_REQUIRES_MUSICIAN = "需要Musician"
msg.TRPE_ITEM_TOOLTIP_SHEET_MUSIC = "乐谱"
msg.TRPE_ITEM_USE_HINT = "阅读乐谱"
msg.TRPE_ITEM_MUSICIAN_NOT_FOUND = "你需要安装最新版本的“Musician”插件来使用这个物品。\n从{url}下载"
msg.TRPE_ITEM_NOTES = "将音乐导入至Musician以向附近的玩家播放。\n\n下载Musician：{url}\n"

msg.TRPE_EXPORT_BUTTON = "导出"
msg.TRPE_EXPORT_WINDOW_TITLE = "将音乐导出为Total RP 3物品"
msg.TRPE_EXPORT_WINDOW_LOCALE = "物品语言："
msg.TRPE_EXPORT_WINDOW_ADD_TO_BAG = "添加到背包"
msg.TRPE_EXPORT_WINDOW_QUANTITY = "数量"
msg.TRPE_EXPORT_WINDOW_HINT_NEW = "创建一个可以交易给其他玩家的Total RP 3物品。"
msg.TRPE_EXPORT_WINDOW_HINT_EXISTING = "已经存在一个这首音乐的物品了，它将被更新。"
msg.TRPE_EXPORT_WINDOW_CREATE_ITEM_BUTTON = "创建物品"
msg.TRPE_EXPORT_WINDOW_PROGRESS = "创建物品……{progress}%"

--- Musician instrument names
msg.INSTRUMENT_NAMES["none"] = "(无)"
msg.INSTRUMENT_NAMES["accordion"] = "手风琴"
msg.INSTRUMENT_NAMES["bagpipe"] = "风笛"
msg.INSTRUMENT_NAMES["dulcimer"] = "击锤扬琴"
msg.INSTRUMENT_NAMES["piano"] = "钢琴"
msg.INSTRUMENT_NAMES["lute"] = "鲁特琴"
msg.INSTRUMENT_NAMES["viola_da_gamba"] = "维奥尔琴（古大提琴）"
msg.INSTRUMENT_NAMES["harp"] = "凯尔特竖琴"
msg.INSTRUMENT_NAMES["male_voice"] = "男高音"
msg.INSTRUMENT_NAMES["female_voice"] = "女高音"
msg.INSTRUMENT_NAMES["trumpet"] = "小号"
msg.INSTRUMENT_NAMES["sackbut"] = "古长号"
msg.INSTRUMENT_NAMES["war_horn"] = "战争号角"
msg.INSTRUMENT_NAMES["bassoon"] = "大管"
msg.INSTRUMENT_NAMES["clarinet"] = "单簧管"
msg.INSTRUMENT_NAMES["recorder"] = "竖笛"
msg.INSTRUMENT_NAMES["fiddle"] = "类提琴乐器"
msg.INSTRUMENT_NAMES["percussions"] = "打击乐（传统）"
msg.INSTRUMENT_NAMES["distortion_guitar"] = "变音电吉他"
msg.INSTRUMENT_NAMES["clean_guitar"] = "清音吉他"
msg.INSTRUMENT_NAMES["bass_guitar"] = "贝斯吉他"
msg.INSTRUMENT_NAMES["drumkit"] = "鼓组"
msg.INSTRUMENT_NAMES["war_drum"] = "战鼓"
msg.INSTRUMENT_NAMES["woodblock"] = "木块"
msg.INSTRUMENT_NAMES["tambourine_shake"] = "铃鼓"

--- General MIDI instrument names
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGrandPiano] = "大钢琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrightAcousticPiano] = "亮音立式钢琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGrandPiano] = "电声大钢琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.HonkyTonkPiano] = "叮当琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricPiano1] = "电钢琴1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricPiano2] = "电钢琴2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Harpsichord] = "拨弦古钢琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Clavi] = "击弦古钢琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Celesta] = "钢片琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Glockenspiel] = "钟琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MusicBox] = "八音盒"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Vibraphone] = "电颤琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Marimba] = "马林巴琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Xylophone] = "木琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TubularBells] = "管钟"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Dulcimer] = "扬琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.DrawbarOrgan] = "拉杆风琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PercussiveOrgan] = "打击型风琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.RockOrgan] = "摇滚风琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ChurchOrgan] = "管风琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ReedOrgan] = "簧风琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Accordion] = "手风琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Harmonica] = "口琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TangoAccordion] = "探戈手风琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGuitarNylon] = "古典吉他"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGuitarSteel] = "民谣吉他"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarJazz] = "爵士电吉他"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarClean] = "清音电吉他"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarMuted] = "弱音电吉他"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OverdrivenGuitar] = "失真音效电吉他"
msg.MIDI_INSTRUMENT_NAMES[Instrument.DistortionGuitar] = "破音音效电吉他"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Guitarharmonics] = "吉他泛音"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticBass] = "原声贝斯"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricBassFinger] = "指拨电贝斯"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricBassPick] = "拨片电贝斯"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FretlessBass] = "无品贝斯"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SlapBass1] = "击弦贝斯1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SlapBass2] = "击弦贝斯2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBass1] = "合成贝斯1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBass2] = "合成贝斯2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Violin] = "小提琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Viola] = "中提琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Cello] = "大提琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Contrabass] = "低音提琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TremoloStrings] = "弦乐震音"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PizzicatoStrings] = "弦乐拨奏"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestralHarp] = "竖琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Timpani] = "定音鼓"
msg.MIDI_INSTRUMENT_NAMES[Instrument.StringEnsemble1] = "弦乐合奏1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.StringEnsemble2] = "弦乐合奏2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthStrings1] = "合成弦乐1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthStrings2] = "合成弦乐2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ChoirAahs] = "合唱“啊”音"
msg.MIDI_INSTRUMENT_NAMES[Instrument.VoiceOohs] = "人声“嘟”音"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthVoice] = "合成人声"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestraHit] = "管弦乐队重音齐奏"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Trumpet] = "小号"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Trombone] = "长号"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Tuba] = "大号"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MutedTrumpet] = "弱音小号"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FrenchHorn] = "圆号"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrassSection] = "铜管组"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBrass1] = "合成铜管1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBrass2] = "合成铜管2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SopranoSax] = "高音萨克斯"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AltoSax] = "中音萨克斯"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TenorSax] = "次中音萨克斯"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BaritoneSax] = "上低音萨克斯"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Oboe] = "双簧管"
msg.MIDI_INSTRUMENT_NAMES[Instrument.EnglishHorn] = "英国管"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Bassoon] = "大管"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Clarinet] = "单簧管"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Piccolo] = "短笛"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Flute] = "长笛"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Recorder] = "竖笛"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PanFlute] = "长笛"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BlownBottle] = "吹瓶口"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shakuhachi] = "尺八"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Whistle] = "口哨"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Ocarina] = "洋埙"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead1Square] = "合成主音1（方波）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead2Sawtooth] = "合成主音2（锯齿波）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead3Calliope] = "合成主音3（汽笛风琴）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead4Chiff] = "合成主音4 （吹管）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead5Charang] = "合成主音5（吉他）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead6Voice] = "合成主音6（人声）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead7Fifths] = "合成主音7（五度锯齿波）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead8BassLead] = "合成主音8（贝斯加主音）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad1Newage] = "合成柔音1（幻想/新时代）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad2Warm] = "合成柔音（温暖）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad3Polysynth] = "合成柔音3（八度复音合成）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad4Choir] = "合成柔音4（太空合唱）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad5Bowed] = "合成柔音5（弓奏玻璃杯）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad6Metallic] = "合成柔音6（金属）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad7Halo] = "合成柔音7（光环）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad8Sweep] = "合成柔音8（横扫）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX1Rain] = "合成特效1（雨）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX2Soundtrack] = "合成特效2（音轨）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX3Crystal] = "合成特效3（水晶）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX4Atmosphere] = "合成特效4（大气）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX5Brightness] = "合成特效5（亮音）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX6Goblins] = "合成特效6（小妖）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX7Echoes] = "合成特效7（回声）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX8SciFi] = "合成特效8（科幻）"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Sitar] = "印度西塔琴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Banjo] = "班卓"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shamisen] = "三味线"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Koto] = "日本十三弦筝"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Kalimba] = "卡林巴"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Bagpipe] = "风笛"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Fiddle] = "类提琴乐器"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shanai] = "唢呐"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TinkleBell] = "铃铛"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Agogo] = "拉丁打铃"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SteelDrums] = "钢鼓"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Woodblock] = "木块"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TaikoDrum] = "太鼓"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MelodicTom] = "嗵鼓"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthDrum] = "合成嗵鼓"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ReverseCymbal] = "镲波形反转"
msg.MIDI_INSTRUMENT_NAMES[Instrument.GuitarFretNoise] = "磨弦声"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BreathNoise] = "呼吸声"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Seashore] = "海浪声"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BirdTweet] = "鸟鸣声"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TelephoneRing] = "电话铃声"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Helicopter] = "直升机声"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Applause] = "欢呼鼓掌声"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Gunshot] = "枪声"

--- General MIDI drum kit names
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_INSTRUMENT_NAMES[Instrument.StandardKit] = "标准鼓组"
msg.MIDI_INSTRUMENT_NAMES[Instrument.RoomKit] = "录音室鼓组"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PowerKit] = "强音鼓组"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectronicKit] = "电子鼓组"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TR808Kit] = "TR-808鼓组"
msg.MIDI_INSTRUMENT_NAMES[Instrument.JazzKit] = "爵士鼓组"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrushKit] = "鼓刷鼓组"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestraKit] = "管弦乐鼓组"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SoundFXKit] = "声音效果"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MT32Kit] = "MT-32鼓组"
msg.MIDI_INSTRUMENT_NAMES[Instrument.None] = "(无)"
msg.UNKNOWN_DRUMKIT = "未知鼓组 ({midi})"

--- General MIDI percussion list
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_PERCUSSION_NAMES[Percussion.Laser] = "激光" -- MIDI key 27
msg.MIDI_PERCUSSION_NAMES[Percussion.Whip] = "鞭打" -- MIDI key 28
msg.MIDI_PERCUSSION_NAMES[Percussion.ScratchPush] = "特效处理推音" -- MIDI key 29
msg.MIDI_PERCUSSION_NAMES[Percussion.ScratchPull] = "特效处理拉音" -- MIDI key 30
msg.MIDI_PERCUSSION_NAMES[Percussion.StickClick] = "鼓槌对敲" -- MIDI key 31
msg.MIDI_PERCUSSION_NAMES[Percussion.SquareClick] = "敲方板" -- MIDI key 32
msg.MIDI_PERCUSSION_NAMES[Percussion.MetronomeClick] = "节拍器" -- MIDI key 33
msg.MIDI_PERCUSSION_NAMES[Percussion.MetronomeBell] = "节拍器重音" -- MIDI key 34
msg.MIDI_PERCUSSION_NAMES[Percussion.AcousticBassDrum] = "低音大鼓" -- MIDI key 35
msg.MIDI_PERCUSSION_NAMES[Percussion.BassDrum1] = "高音大鼓" -- MIDI key 36
msg.MIDI_PERCUSSION_NAMES[Percussion.SideStick] = "鼓边" -- MIDI key 37
msg.MIDI_PERCUSSION_NAMES[Percussion.AcousticSnare] = "小鼓" -- MIDI key 38
msg.MIDI_PERCUSSION_NAMES[Percussion.HandClap] = "拍手声" -- MIDI key 39
msg.MIDI_PERCUSSION_NAMES[Percussion.ElectricSnare] = "电子小鼓" -- MIDI key 40
msg.MIDI_PERCUSSION_NAMES[Percussion.LowFloorTom] = "低音落地嗵鼓" -- MIDI key 41
msg.MIDI_PERCUSSION_NAMES[Percussion.ClosedHiHat] = "合音踩镲" -- MIDI key 42
msg.MIDI_PERCUSSION_NAMES[Percussion.HighFloorTom] = "高音落地嗵鼓" -- MIDI key 43
msg.MIDI_PERCUSSION_NAMES[Percussion.PedalHiHat] = "踏音踩镲" -- MIDI key 44
msg.MIDI_PERCUSSION_NAMES[Percussion.LowTom] = "低音嗵鼓" -- MIDI key 45
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenHiHat] = "开音踩镲" -- MIDI key 46
msg.MIDI_PERCUSSION_NAMES[Percussion.LowMidTom] = "中低音嗵鼓" -- MIDI key 47
msg.MIDI_PERCUSSION_NAMES[Percussion.HiMidTom] = "中高音嗵鼓" -- MIDI key 48
msg.MIDI_PERCUSSION_NAMES[Percussion.CrashCymbal1] = "低砸音镲" -- MIDI key 49
msg.MIDI_PERCUSSION_NAMES[Percussion.HighTom] = "高音嗵鼓" -- MIDI key 50
msg.MIDI_PERCUSSION_NAMES[Percussion.RideCymbal1] = "低浮音镲" -- MIDI key 51
msg.MIDI_PERCUSSION_NAMES[Percussion.ChineseCymbal] = "中国镲" -- MIDI key 52
msg.MIDI_PERCUSSION_NAMES[Percussion.RideBell] = "浮音镲碗" -- MIDI key 53
msg.MIDI_PERCUSSION_NAMES[Percussion.Tambourine] = "铃鼓" -- MIDI key 54
msg.MIDI_PERCUSSION_NAMES[Percussion.SplashCymbal] = "溅音镲" -- MIDI key 55
msg.MIDI_PERCUSSION_NAMES[Percussion.Cowbell] = "牛铃" -- MIDI key 56
msg.MIDI_PERCUSSION_NAMES[Percussion.CrashCymbal2] = "高砸音镲" -- MIDI key 57
msg.MIDI_PERCUSSION_NAMES[Percussion.Vibraslap] = "颤音叉" -- MIDI key 58
msg.MIDI_PERCUSSION_NAMES[Percussion.RideCymbal2] = "高浮音镲" -- MIDI key 59
msg.MIDI_PERCUSSION_NAMES[Percussion.HiBongo] = "高音邦戈" -- MIDI key 60
msg.MIDI_PERCUSSION_NAMES[Percussion.LowBongo] = "低音邦戈" -- MIDI key 61
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteHiConga] = "弱音康加" -- MIDI key 62
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenHiConga] = "高音康加" -- MIDI key 63
msg.MIDI_PERCUSSION_NAMES[Percussion.LowConga] = "低音康加" -- MIDI key 64
msg.MIDI_PERCUSSION_NAMES[Percussion.HighTimbale] = "高音铜鼓" -- MIDI key 65
msg.MIDI_PERCUSSION_NAMES[Percussion.LowTimbale] = "低音铜鼓" -- MIDI key 66
msg.MIDI_PERCUSSION_NAMES[Percussion.HighAgogo] = "高音拉丁打铃" -- MIDI key 67
msg.MIDI_PERCUSSION_NAMES[Percussion.LowAgogo] = "低音拉丁打铃" -- MIDI key 68
msg.MIDI_PERCUSSION_NAMES[Percussion.Cabasa] = "沙锤" -- MIDI key 69
msg.MIDI_PERCUSSION_NAMES[Percussion.Maracas] = "响葫芦" -- MIDI key 70
msg.MIDI_PERCUSSION_NAMES[Percussion.ShortWhistle] = "短哨" -- MIDI key 71
msg.MIDI_PERCUSSION_NAMES[Percussion.LongWhistle] = "长哨" -- MIDI key 72
msg.MIDI_PERCUSSION_NAMES[Percussion.ShortGuiro] = "短锯琴" -- MIDI key 73
msg.MIDI_PERCUSSION_NAMES[Percussion.LongGuiro] = "长锯琴" -- MIDI key 74
msg.MIDI_PERCUSSION_NAMES[Percussion.Claves] = "击杆" -- MIDI key 75
msg.MIDI_PERCUSSION_NAMES[Percussion.HiWoodBlock] = "高音木块" -- MIDI key 76
msg.MIDI_PERCUSSION_NAMES[Percussion.LowWoodBlock] = "低音木块" -- MIDI key 77
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteCuica] = "弱音吉加" -- MIDI key 78
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenCuica] = "开音吉加" -- MIDI key 79
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteTriangle] = "弱音三角铁" -- MIDI key 80
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenTriangle] = "开音三角铁" -- MIDI key 81
msg.MIDI_PERCUSSION_NAMES[Percussion.Shaker] = "沙锤（高音）" -- MIDI key 82
msg.MIDI_PERCUSSION_NAMES[Percussion.SleighBell] = "马铃" -- MIDI key 83
msg.MIDI_PERCUSSION_NAMES[Percussion.BellTree] = "铃树" -- MIDI key 84
msg.MIDI_PERCUSSION_NAMES[Percussion.Castanets] = "响板" -- MIDI key 85
msg.MIDI_PERCUSSION_NAMES[Percussion.SurduDeadStroke] = "巴西鼓终音" -- MIDI key 86
msg.MIDI_PERCUSSION_NAMES[Percussion.Surdu] = "巴西鼓" -- MIDI key 87
msg.MIDI_PERCUSSION_NAMES[Percussion.SnareDrumRod] = "军鼓击杆" -- MIDI key 88
msg.MIDI_PERCUSSION_NAMES[Percussion.OceanDrum] = "拨浪鼓" -- MIDI key 89
msg.MIDI_PERCUSSION_NAMES[Percussion.SnareDrumBrush] = "军鼓擦杆" -- MIDI key 90