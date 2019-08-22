Musician.Locale.zh = Musician.Utils.DeepCopy(Musician.Locale.en)

local msg = Musician.Locale.zh
local Instrument = Musician.MIDI_INSTRUMENTS
local Percussion = Musician.MIDI_PERCUSSIONS

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

msg.MENU_TITLE = "Musician"
msg.MENU_IMPORT_SONG = "导入并播放一首音乐"
msg.MENU_PLAY = msg.PLAY
msg.MENU_STOP = msg.STOP
msg.MENU_PLAY_PREVIEW = msg.TEST_SONG
msg.MENU_STOP_PREVIEW = msg.STOP_TEST
msg.MENU_LIVE_PLAY = "现场演奏"
msg.MENU_SHOW_KEYBOARD = "打开键盘"
msg.MENU_SETTINGS = "设定"
msg.MENU_OPTIONS = "选项"

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

msg.OPTIONS_TITLE = "Musician"
msg.OPTIONS_SUB_TEXT = "加入Discord社区来帮助我们！ {url}"
msg.OPTIONS_CATEGORY_EMOTE = "表情"
msg.OPTIONS_ENABLE_EMOTE_LABEL = "当播放音乐时，向没有Musician插件的玩家发送一条表情信息。"
msg.OPTIONS_ENABLE_EMOTE_PROMO_LABEL = "以一条短文字来邀请他们安装插件，这样他们就能听到你的演奏了。"
msg.OPTIONS_EMOTE_HINT = "当你播放音乐的时候，没有Musician插件的玩家会收到一条表情信息。你可以在[options]当中禁用它."
msg.OPTIONS_CATEGORY_NAMEPLATES = "姓名版和动作"
msg.OPTIONS_CATEGORY_NAMEPLATES_SUB_TEXT = "打开姓名版选项以便看到正在演奏音乐的玩家的动画并确认附近有谁可以听到你。"
msg.OPTIONS_ENABLE_NAMEPLATES = "启用姓名版和动画。"
-- msg.OPTIONS_SHOW_NAMEPLATE_ICON = "Show a {icon} icon next to the name of the players who also have Musician."
msg.OPTIONS_HIDE_HEALTH_BARS = "在未进入战斗时，隐藏玩家和友善单位的姓名版。"
msg.OPTIONS_HIDE_NPC_NAMEPLATES = "隐藏NPC姓名版。"
msg.OPTIONS_CINEMATIC_MODE = "当使用{binding}关闭UI姓名版时也显示动画。"
msg.OPTIONS_CINEMATIC_MODE_NO_BINDING = "隐藏UI时显示动画。"
msg.OPTIONS_NAMEPLATES_CINEMATIC_MODE = "隐藏UI时显示姓名版。"
msg.OPTIONS_CROSS_RP_TITLE = "Cross RP"
msg.OPTIONS_CROSS_RP_SUB_TEXT = "安装Tammya-月亮守卫的Cross RP插件来进行跨服/跨阵营的音乐演奏！"
msg.OPTIONS_CROSS_RP_SUB_TEXT_NO_GATEWAY = "目前暂无可用的Cross RP节点。\n请耐心等待……"
msg.OPTIONS_CROSS_RP_SUB_TEXT_ACTIVE = "Cross RP连接已在以下位置启动：\n\n{bands}"

msg.TIPS_AND_TRICKS_ENABLE = "启动时显示小贴士。"

msg.TIPS_AND_TRICKS_NAMEPLATES_TITLE = "动画和姓名版"
msg.TIPS_AND_TRICKS_NAMEPLATES_TEXT = "当姓名版选项打开时，正在播放音乐的玩家会显示特殊动画。\n\n" ..
	"{icon}显示了安装Musician并能听到你演奏的玩家。\n\n" ..
	"你想打开姓名版和动画吗？"
msg.TIPS_AND_TRICKS_NAMEPLATES_OK = "打开姓名版和动画"
msg.TIPS_AND_TRICKS_NAMEPLATES_CANCEL = "稍后再说"

msg.TIPS_AND_TRICKS_CROSS_RP_TITLE = "使用Cross RP进行跨阵营/跨服演奏"
msg.TIPS_AND_TRICKS_CROSS_RP_TEXT = msg.OPTIONS_CROSS_RP_SUB_TEXT
msg.TIPS_AND_TRICKS_CROSS_RP_OK = "好的"

msg.STARTUP = "欢迎使用Musician v{version}."

msg.NEW_VERSION = "一个新的Musician版本发布了！可以在以下链接下载升级：{url}。"
msg.NEW_PROTOCOL_VERSION = "你的Musician版本过老，已经无法使用。\n请前往以下链接升级\n{url}"
msg.SHOULD_CONFIGURE_KEYBOARD = "在开始演奏前需要对键盘进行设置。"

msg.PLAYER_TOOLTIP = "Musician"
msg.PLAYER_TOOLTIP_VERSION = "Musician v{version}"
msg.PLAYER_TOOLTIP_VERSION_OUTDATED = " (当前版本已过期)"
msg.PLAYER_TOOLTIP_VERSION_INCOMPATIBLE = " (当前版本不兼容)"
msg.PLAYER_TOOLTIP_PRELOADING = "音效预载中……({progress})"

msg.PLAYER_COUNT_ONLINE = "现在有{count}个音乐迷在线！"
msg.PLAYER_COUNT_ONLINE_ONE = "有一个音乐迷在线！"
msg.PLAYER_COUNT_ONLINE_NONE = "没有在线的音乐迷。"

msg.INVALID_MUSIC_CODE = "音乐代码无效。"

msg.PLAY_A_SONG = "播放音乐"
msg.IMPORT_A_SONG = "导入音乐"
msg.PASTE_MUSIC_CODE = "通过以下地址导入你MIDI格式的音乐\n{url}\n\n并把音乐代码粘贴在这里({shortcut})…"
msg.SONG_IMPORTED = "音乐已载入：{title}."

msg.PLAY_IN_BAND = "乐队演奏"
msg.PLAY_IN_BAND_HINT = "当你准备好和你的乐队一起演奏时，点击这里。"
msg.PLAY_IN_BAND_READY_PLAYERS = "已就绪的乐队成员："
msg.EMOTE_PLAYER_IS_READY = "已准备好作为乐队成员演奏。"
msg.EMOTE_PLAYER_IS_NOT_READY = "已离开就绪状态。"
msg.EMOTE_PLAY_IN_BAND_START = "开始乐队演奏。"
msg.EMOTE_PLAY_IN_BAND_STOP = "停止乐队演奏。"

msg.LIVE_SYNC = "乐队现场演奏。"
msg.LIVE_SYNC_HINT = "点击这里进行乐队演奏同步。"
msg.SYNCED_PLAYERS = "就位的乐队成员："
msg.EMOTE_PLAYER_LIVE_SYNC_ENABLED = "正在和你一起演奏音乐。"
msg.EMOTE_PLAYER_LIVE_SYNC_DISABLED = "停止了和你演奏音乐。"

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
msg.TRANSPOSE_TRACK = "变调(八度音阶)"
msg.CHANGE_TRACK_INSTRUMENT = "切换乐器"
msg.HEADER_NUMBER = "#"
msg.HEADER_OCTAVE = "八度音阶"
msg.HEADER_INSTRUMENT = "乐器"

msg.CONFIGURE_KEYBOARD = "设置键盘"
msg.CONFIGURE_KEYBOARD_HINT = "点击一个键以设置……"
msg.CONFIGURE_KEYBOARD_HINT_COMPLETE = "键盘设置已完成。\n你现在可以保存更改并开始演奏了！"
msg.CONFIGURE_KEYBOARD_START_OVER = "重新设置"
msg.CONFIGURE_KEYBOARD_SAVE = "保存配置"
msg.PRESS_KEY_BINDING = "按下 #{col}列#{row}行的按钮。"
msg.KEY_IS_MERGEABLE = "这可以和你键盘上的{key}键相同：{action}"
msg.KEY_CAN_BE_MERGED = "此时，请直接按下{key}键。"
msg.KEY_CANNOT_BE_MERGED = "此时，请忽略并设置下一个键。"
msg.NEXT_KEY = "下一个按键"
msg.CLEAR_KEY = "清除按键"

local KEY = Musician.KEYBOARD_KEY
msg.FIXED_KEY_NAMES = {
	[KEY.Backspace] = "Backspace",
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

msg.KEYBOARD_LAYOUTS = {
	["Piano"] = "钢琴",
	["Chromatic"] = "半音阶",

	["Modes"] = "调式",
	["Ionian"] = "伊奥尼亚调式",
	["Dorian"] = "多利亚调式",
	["Phrygian"] = "弗利几亚调式",
	["Lydian"] = "利底亚调式",
	["Mixolydian"] = "混合利底亚调式",
	["Aeolian"] = "爱奥利亚调式",
	["Locrian"] = "洛克利亚调式",
	["minor Harmonic"] = "和声小调",
	["minor Melodic"] = "旋律小调",

	["Blues scales"] = "布鲁斯音阶",
	["Major Blues"] = "大调布鲁斯",
	["minor Blues"] = "小调布鲁斯",

	["Diminished scales"] = "减音阶",
	["Diminished"] = "减弱",
	["Complement Diminished"] = "补充减弱",

	["Pentatonic scales"] = "五声音阶",
	["Major Pentatonic"] = "大五声",
	["minor Pentatonic"] = "小五声",

	["World scales"] = "世界音阶",
	["Raga 1"] = "印度拉加 1",
	["Raga 2"] = "印度拉加 2",
	["Raga 3"] = "印度拉加 3",
	["Arabic"] = "阿拉伯",
	["Spanish"] = "西班牙",
	["Gypsy"] = "吉普赛",
	["Egyptian"] = "埃及",
	["Hawaiian"] = "夏威夷",
	["Bali Pelog"] = "巴厘岛",
	["Japanese"] = "日本",
	["Ryukyu"] = "琉球",
	["Chinese"] = "中国",

	["Miscellaneous scales"] = "其他音阶",
	["Bass Line"] = "贝斯弦",
	["Wholetone"] = "全音",
	["minor 3rd"] = "小三度",
	["Major 3rd"] = "大三度",
	["4th"] = "纯四度",
	["5th"] = "纯五度",
	["Octave"] = "八度",
}
msg.HORIZONTAL_LAYOUT = "水平"
msg.VERTICAL_LAYOUT = "垂直"

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
msg.POWER_CHORDS = "强力和弦"
msg.PROGRAM_BUTTON = "P {num}"
msg.EMPTY_PROGRAM = "空白程序"
msg.LOAD_PROGRAM_NUM = "载入程序 #{num} ({key})"
msg.SAVE_PROGRAM_NUM = "保存至程序 #{num} ({key})"
msg.DELETE_PROGRAM_NUM = "清空程序 #{num} ({key})"
msg.WRITE_PROGRAM = "保存程序 ({key})"
msg.PROGRAM_SAVED = "程序 #{num} 已保存。"
msg.PROGRAM_DELETED = "程序 #{num} 已清空。"
msg.DEMO_MODE_ENABLED = "键盘演示模式启动：\n{mapping}"
msg.DEMO_MODE_MAPPING = "{layer} → 音轨 #{track}"
msg.DEMO_MODE_DISABLED = "键盘演示模式已关闭。"

msg.LAYERS = {
	[Musician.KEYBOARD_LAYER.UPPER] = "上层",
	[Musician.KEYBOARD_LAYER.LOWER] = "下层",
}

msg.EMOTE_PLAYING_MUSIC = "正在演奏一首音乐。"
msg.EMOTE_PROMO = "(安装 \"Musician\" 插件就可以听了)"
msg.EMOTE_SONG_NOT_LOADED = "(这首音乐无法播放，因为玩家 {player}使用的插件版本和你不兼容。)"
msg.EMOTE_PLAYER_OTHER_REALM = "(这个玩家处于另一个服务器。)"

msg.TOOLTIP_LEFT_CLICK = "**左键点击**: {action}"
msg.TOOLTIP_RIGHT_CLICK = "**右键点击**: {action}"
msg.TOOLTIP_DRAG_AND_DROP = "**拖放** 来移动"
msg.TOOLTIP_ISMUTED = "(已静音)"
msg.TOOLTIP_ACTION_OPEN_MENU = "打开主菜单"
msg.TOOLTIP_ACTION_MUTE = "静音所有音乐"
msg.TOOLTIP_ACTION_UNMUTE = "取消静音"

msg.PLAYER_MENU_TITLE = "音乐"
msg.PLAYER_MENU_STOP_CURRENT_SONG = "停止当前音乐"
msg.PLAYER_MENU_MUTE = "静音"
msg.PLAYER_MENU_UNMUTE = "取消静音"

msg.PLAYER_IS_MUTED = "{icon}{player}已静音。"
msg.PLAYER_IS_UNMUTED = "{icon}{player}已关闭静音。"

msg.INSTRUMENT_NAMES = {
	["none"] = "(无)",
	["bagpipe"] = "风笛",
	["dulcimer"] = "击锤扬琴",
	["lute"] = "鲁特琴",
	["cello"] = "大提琴",
	["harp"] = "凯尔特竖琴",
	["bodhran-bassdrum-low"] = "爱尔兰低音鼓",
	["male-voice"] = "男高音",
	["female-voice"] = "女高音",
	["trumpet"] = "小号",
	["trombone"] = "长号",
	["bassoon"] = "大管",
	["clarinet"] = "单簧管",
	["recorder"] = "竖笛",
	["fiddle"] = "类提琴乐器",
	["bodhran-snare-long-hi"] = "低音鼓高音",
	["bodhran-snare-long-low"] = "低音鼓低音",
	["percussions"] = "打击乐（传统）",
	["distorsion-guitar"] = "变音电吉他",
	["clean-guitar"] = "清音吉他",
	["bass-guitar"] = "贝斯吉他",
	["drumkit"] = "鼓组",
}

msg.MIDI_INSTRUMENT_NAMES = {
	[Instrument.AcousticGrandPiano] = "大钢琴",
	[Instrument.BrightAcousticPiano] = "亮音立式钢琴",
	[Instrument.ElectricGrandPiano] = "电声大钢琴",
	[Instrument.HonkyTonkPiano] = "叮当琴",
	[Instrument.ElectricPiano1] = "电钢琴1",
	[Instrument.ElectricPiano2] = "电钢琴2",
	[Instrument.Harpsichord] = "拨弦古钢琴",
	[Instrument.Clavi] = "击弦古钢琴",

	[Instrument.Celesta] = "钢片琴",
	[Instrument.Glockenspiel] = "钟琴",
	[Instrument.MusicBox] = "八音盒",
	[Instrument.Vibraphone] = "电颤琴",
	[Instrument.Marimba] = "马林巴琴",
	[Instrument.Xylophone] = "木琴",
	[Instrument.TubularBells] = "管钟",
	[Instrument.Dulcimer] = "扬琴",

	[Instrument.DrawbarOrgan] = "拉杆风琴",
	[Instrument.PercussiveOrgan] = "打击型风琴",
	[Instrument.RockOrgan] = "摇滚风琴",
	[Instrument.ChurchOrgan] = "管风琴",
	[Instrument.ReedOrgan] = "簧风琴",
	[Instrument.Accordion] = "手风琴",
	[Instrument.Harmonica] = "口琴",
	[Instrument.TangoAccordion] = "探戈手风琴",

	[Instrument.AcousticGuitarNylon] = "古典吉他",
	[Instrument.AcousticGuitarSteel] = "民谣吉他",
	[Instrument.ElectricGuitarJazz] = "爵士电吉他",
	[Instrument.ElectricGuitarClean] = "清音电吉他",
	[Instrument.ElectricGuitarMuted] = "弱音电吉他",
	[Instrument.OverdrivenGuitar] = "失真音效电吉他",
	[Instrument.DistortionGuitar] = "破音音效电吉他",
	[Instrument.Guitarharmonics] = "吉他泛音",

	[Instrument.AcousticBass] = "原声贝斯",
	[Instrument.ElectricBassFinger] = "指拨电贝斯",
	[Instrument.ElectricBassPick] = "拨片电贝斯",
	[Instrument.FretlessBass] = "无品贝斯",
	[Instrument.SlapBass1] = "击弦贝斯1",
	[Instrument.SlapBass2] = "击弦贝斯2",
	[Instrument.SynthBass1] = "合成贝斯1",
	[Instrument.SynthBass2] = "合成贝斯2",

	[Instrument.Violin] = "小提琴",
	[Instrument.Viola] = "中提琴",
	[Instrument.Cello] = "大提琴",
	[Instrument.Contrabass] = "低音提琴",
	[Instrument.TremoloStrings] = "弦乐震音",
	[Instrument.PizzicatoStrings] = "弦乐拨奏",
	[Instrument.OrchestralHarp] = "竖琴",
	[Instrument.Timpani] = "定音鼓",

	[Instrument.StringEnsemble1] = "弦乐合奏1",
	[Instrument.StringEnsemble2] = "弦乐合奏2",
	[Instrument.SynthStrings1] = "合成弦乐1",
	[Instrument.SynthStrings2] = "合成弦乐2",
	[Instrument.ChoirAahs] = "合唱“啊”音",
	[Instrument.VoiceOohs] = "人声“嘟”音",
	[Instrument.SynthVoice] = "合成人声",
	[Instrument.OrchestraHit] = "管弦乐队重音齐奏",

	[Instrument.Trumpet] = "小号",
	[Instrument.Trombone] = "长号",
	[Instrument.Tuba] = "大号",
	[Instrument.MutedTrumpet] = "弱音小号",
	[Instrument.FrenchHorn] = "圆号",
	[Instrument.BrassSection] = "铜管组",
	[Instrument.SynthBrass1] = "合成铜管1",
	[Instrument.SynthBrass2] = "合成铜管2",

	[Instrument.SopranoSax] = "高音萨克斯",
	[Instrument.AltoSax] = "中音萨克斯",
	[Instrument.TenorSax] = "次中音萨克斯",
	[Instrument.BaritoneSax] = "上低音萨克斯",
	[Instrument.Oboe] = "双簧管",
	[Instrument.EnglishHorn] = "英国管",
	[Instrument.Bassoon] = "大管",
	[Instrument.Clarinet] = "单簧管",

	[Instrument.Piccolo] = "短笛",
	[Instrument.Flute] = "长笛",
	[Instrument.Recorder] = "竖笛",
	[Instrument.PanFlute] = "长笛",
	[Instrument.BlownBottle] = "吹瓶口",
	[Instrument.Shakuhachi] = "尺八",
	[Instrument.Whistle] = "口哨",
	[Instrument.Ocarina] = "洋埙",

	[Instrument.Lead1Square] = "合成主音1（方波）",
	[Instrument.Lead2Sawtooth] = "合成主音2（锯齿波）",
	[Instrument.Lead3Calliope] = "合成主音3（汽笛风琴）",
	[Instrument.Lead4Chiff] = "合成主音4 （吹管）",
	[Instrument.Lead5Charang] = "合成主音5（吉他）",
	[Instrument.Lead6Voice] = "合成主音6（人声）",
	[Instrument.Lead7Fifths] = "合成主音7（五度锯齿波）",
	[Instrument.Lead8BassLead] = "合成主音8（贝斯加主音）",

	[Instrument.Pad1Newage] = "合成柔音1（幻想/新时代）",
	[Instrument.Pad2Warm] = "合成柔音（温暖）",
	[Instrument.Pad3Polysynth] = "合成柔音3（八度复音合成）",
	[Instrument.Pad4Choir] = "合成柔音4（太空合唱）",
	[Instrument.Pad5Bowed] = "合成柔音5（弓奏玻璃杯）",
	[Instrument.Pad6Metallic] = "合成柔音6（金属）",
	[Instrument.Pad7Halo] = "合成柔音7（光环）",
	[Instrument.Pad8Sweep] = "合成柔音8（横扫）",

	[Instrument.FX1Rain] = "合成特效1（雨）",
	[Instrument.FX2Soundtrack] = "合成特效2（音轨）",
	[Instrument.FX3Crystal] = "合成特效3（水晶）",
	[Instrument.FX4Atmosphere] = "合成特效4（大气）",
	[Instrument.FX5Brightness] = "合成特效5（亮音）",
	[Instrument.FX6Goblins] = "合成特效6（小妖）",
	[Instrument.FX7Echoes] = "合成特效7（回声）",
	[Instrument.FX8SciFi] = "合成特效8（科幻）",

	[Instrument.Sitar] = "印度西塔琴",
	[Instrument.Banjo] = "班卓",
	[Instrument.Shamisen] = "三味线",
	[Instrument.Koto] = "日本十三弦筝",
	[Instrument.Kalimba] = "卡林巴",
	[Instrument.Bagpipe] = "风笛",
	[Instrument.Fiddle] = "类提琴乐器",
	[Instrument.Shanai] = "唢呐",

	[Instrument.TinkleBell] = "铃铛",
	[Instrument.Agogo] = "拉丁打铃",
	[Instrument.SteelDrums] = "钢鼓",
	[Instrument.Woodblock] = "木块",
	[Instrument.TaikoDrum] = "太鼓",
	[Instrument.MelodicTom] = "嗵鼓",
	[Instrument.SynthDrum] = "合成嗵鼓",
	[Instrument.ReverseCymbal] = "镲波形反转",

	[Instrument.GuitarFretNoise] = "磨弦声",
	[Instrument.BreathNoise] = "呼吸声",
	[Instrument.Seashore] = "海浪声",
	[Instrument.BirdTweet] = "鸟鸣声",
	[Instrument.TelephoneRing] = "电话铃声",
	[Instrument.Helicopter] = "直升机声",
	[Instrument.Applause] = "欢呼鼓掌声",
	[Instrument.Gunshot] = "枪声",

	[Instrument.Percussions] = "打击乐器",
	[Instrument.Drumkit] = "鼓组",

	[Instrument.None] = "(无)",
}

msg.MIDI_PERCUSSION_NAMES = {
	[Percussion.Laser] = "激光",
	[Percussion.Whip] = "鞭打",
	[Percussion.ScratchPush] = "特效处理推音",
	[Percussion.ScratchPull] = "特效处理拉音",
	[Percussion.StickClick] = "鼓槌对敲",
	[Percussion.SquareClick] = "敲方板",
	[Percussion.MetronomeClick] = "节拍器",
	[Percussion.MetronomeBell] = "节拍器重音",
	[Percussion.AcousticBassDrum] = "低音大鼓",
	[Percussion.BassDrum1] = "高音大鼓",
	[Percussion.SideStick] = "鼓边",
	[Percussion.AcousticSnare] = "小鼓",
	[Percussion.HandClap] = "拍手声",
	[Percussion.ElectricSnare] = "电子小鼓",
	[Percussion.LowFloorTom] = "低音落地嗵鼓",
	[Percussion.ClosedHiHat] = "合音踩镲",
	[Percussion.HighFloorTom] = "高音落地嗵鼓",
	[Percussion.PedalHiHat] = "踏音踩镲",
	[Percussion.LowTom] = "低音嗵鼓",
	[Percussion.OpenHiHat] = "开音踩镲",
	[Percussion.LowMidTom] = "中低音嗵鼓",
	[Percussion.HiMidTom] = "中高音嗵鼓",
	[Percussion.CrashCymbal1] = "低砸音镲",
	[Percussion.HighTom] = "高音嗵鼓",
	[Percussion.RideCymbal1] = "低浮音镲",
	[Percussion.ChineseCymbal] = "中国镲",
	[Percussion.RideBell] = "浮音镲碗",
	[Percussion.Tambourine] = "铃鼓",
	[Percussion.SplashCymbal] = "溅音镲",
	[Percussion.Cowbell] = "牛铃",
	[Percussion.CrashCymbal2] = "高砸音镲",
	[Percussion.Vibraslap] = "颤音叉",
	[Percussion.RideCymbal2] = "高浮音镲",
	[Percussion.HiBongo] = "高音邦戈",
	[Percussion.LowBongo] = "低音邦戈",
	[Percussion.MuteHiConga] = "弱音康加",
	[Percussion.OpenHiConga] = "高音康加",
	[Percussion.LowConga] = "低音康加",
	[Percussion.HighTimbale] = "高音铜鼓",
	[Percussion.LowTimbale] = "低音铜鼓",
	[Percussion.HighAgogo] = "高音拉丁打铃",
	[Percussion.LowAgogo] = "低音拉丁打铃",
	[Percussion.Cabasa] = "沙锤",
	[Percussion.Maracas] = "响葫芦",
	[Percussion.ShortWhistle] = "短哨",
	[Percussion.LongWhistle] = "长哨",
	[Percussion.ShortGuiro] = "短锯琴",
	[Percussion.LongGuiro] = "长锯琴",
	[Percussion.Claves] = "击杆",
	[Percussion.HiWoodBlock] = "高音木块",
	[Percussion.LowWoodBlock] = "低音木块",
	[Percussion.MuteCuica] = "弱音吉加",
	[Percussion.OpenCuica] = "开音吉加",
	[Percussion.MuteTriangle] = "弱音三角铁",
	[Percussion.OpenTriangle] = "开音三角铁",
	[Percussion.Shaker] = "沙锤（高音）",
	[Percussion.SleighBell] = "马铃",
	[Percussion.BellTree] = "铃树",
	[Percussion.Castanets] = "响板",
	[Percussion.SurduDeadStroke] = "巴西鼓终音",
	[Percussion.Surdu] = "巴西鼓",
	[Percussion.SnareDrumRod] = "军鼓击杆",
	[Percussion.OceanDrum] = "拨浪鼓",
	[Percussion.SnareDrumBrush] = "军鼓擦杆",
}

if (GetLocale() == "zhCN" or GetLocale() == "zhTW") then
    Musician.Msg = msg
end
