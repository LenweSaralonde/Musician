Musician.Locale.cn = {}

local msg = Musician.Locale.cn
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
msg.COMMAND_LIVE_DEMO_PARAMS = "{ **<upper track #>** **<lower track #>** || **off** }"
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
msg.PRESS_KEY_BINDING = "按下 #{col}列in row #{row}."
msg.KEY_IS_MERGEABLE = "This key could be the same as the {key} key on your keyboard: {action}"
msg.KEY_CAN_BE_MERGED = "in this case, just press the {key} key."
msg.KEY_CANNOT_BE_MERGED = "in this case, just ignore it and proceed to the next key."
msg.NEXT_KEY = "Next key"
msg.CLEAR_KEY = "Clear key"

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

msg.INSTRUMENT_NAMES = {
	["none"] = "(None)",
	["bagpipe"] = "Bagpipe",
	["dulcimer"] = "Dulcimer (hammered)",
	["lute"] = "Lute",
	["cello"] = "Cello",
	["harp"] = "Celtic harp",
	["bodhran-bassdrum-low"] = "Bodhrán (bassdrum)",
	["male-voice"] = "Male voice (tenor)",
	["female-voice"] = "Female voice (soprano)",
	["trumpet"] = "Trumpet",
	["trombone"] = "Trombone",
	["bassoon"] = "Bassoon",
	["clarinet"] = "Clarinet",
	["recorder"] = "Recorder",
	["fiddle"] = "Fiddle",
	["bodhran-snare-long-hi"] = "Bodhrán (snare high)",
	["bodhran-snare-long-low"] = "Bodhrán (snare low)",
	["percussions"] = "Percussions (traditional)",
	["distorsion-guitar"] = "Distorsion guitar",
	["clean-guitar"] = "Clean guitar",
	["bass-guitar"] = "Bass guitar",
	["drumkit"] = "Drum kit",
}

msg.MIDI_INSTRUMENT_NAMES = {
	[Instrument.AcousticGrandPiano] = "Acoustic Grand Piano",
	[Instrument.BrightAcousticPiano] = "Bright Acoustic Piano",
	[Instrument.ElectricGrandPiano] = "Electric Grand Piano",
	[Instrument.HonkyTonkPiano] = "Honky-tonk Piano",
	[Instrument.ElectricPiano1] = "Electric Piano 1",
	[Instrument.ElectricPiano2] = "Electric Piano 2",
	[Instrument.Harpsichord] = "Harpsichord",
	[Instrument.Clavi] = "Clavi",

	[Instrument.Celesta] = "Celesta",
	[Instrument.Glockenspiel] = "Glockenspiel",
	[Instrument.MusicBox] = "Music Box",
	[Instrument.Vibraphone] = "Vibraphone",
	[Instrument.Marimba] = "Marimba",
	[Instrument.Xylophone] = "Xylophone",
	[Instrument.TubularBells] = "Tubular Bells",
	[Instrument.Dulcimer] = "Dulcimer",

	[Instrument.DrawbarOrgan] = "Drawbar Organ",
	[Instrument.PercussiveOrgan] = "Percussive Organ",
	[Instrument.RockOrgan] = "Rock Organ",
	[Instrument.ChurchOrgan] = "Church Organ",
	[Instrument.ReedOrgan] = "Reed Organ",
	[Instrument.Accordion] = "Accordion",
	[Instrument.Harmonica] = "Harmonica",
	[Instrument.TangoAccordion] = "Tango Accordion",

	[Instrument.AcousticGuitarNylon] = "Acoustic Guitar (nylon)",
	[Instrument.AcousticGuitarSteel] = "Acoustic Guitar (steel)",
	[Instrument.ElectricGuitarJazz] = "Electric Guitar (jazz)",
	[Instrument.ElectricGuitarClean] = "Electric Guitar (clean)",
	[Instrument.ElectricGuitarMuted] = "Electric Guitar (muted)",
	[Instrument.OverdrivenGuitar] = "Overdriven Guitar",
	[Instrument.DistortionGuitar] = "Distortion Guitar",
	[Instrument.Guitarharmonics] = "Guitar harmonics",

	[Instrument.AcousticBass] = "Acoustic Bass",
	[Instrument.ElectricBassFinger] = "Electric Bass (finger)",
	[Instrument.ElectricBassPick] = "Electric Bass (pick)",
	[Instrument.FretlessBass] = "Fretless Bass",
	[Instrument.SlapBass1] = "Slap Bass 1",
	[Instrument.SlapBass2] = "Slap Bass 2",
	[Instrument.SynthBass1] = "Synth Bass 1",
	[Instrument.SynthBass2] = "Synth Bass 2",

	[Instrument.Violin] = "Violin",
	[Instrument.Viola] = "Viola",
	[Instrument.Cello] = "Cello",
	[Instrument.Contrabass] = "Contrabass",
	[Instrument.TremoloStrings] = "Tremolo Strings",
	[Instrument.PizzicatoStrings] = "Pizzicato Strings",
	[Instrument.OrchestralHarp] = "Orchestral Harp",
	[Instrument.Timpani] = "Timpani",

	[Instrument.StringEnsemble1] = "String Ensemble 1",
	[Instrument.StringEnsemble2] = "String Ensemble 2",
	[Instrument.SynthStrings1] = "SynthStrings 1",
	[Instrument.SynthStrings2] = "SynthStrings 2",
	[Instrument.ChoirAahs] = "Choir Aahs",
	[Instrument.VoiceOohs] = "Voice Oohs",
	[Instrument.SynthVoice] = "Synth Voice",
	[Instrument.OrchestraHit] = "Orchestra Hit",

	[Instrument.Trumpet] = "Trumpet",
	[Instrument.Trombone] = "Trombone",
	[Instrument.Tuba] = "Tuba",
	[Instrument.MutedTrumpet] = "Muted Trumpet",
	[Instrument.FrenchHorn] = "French Horn",
	[Instrument.BrassSection] = "Brass Section",
	[Instrument.SynthBrass1] = "SynthBrass 1",
	[Instrument.SynthBrass2] = "SynthBrass 2",

	[Instrument.SopranoSax] = "Soprano Sax",
	[Instrument.AltoSax] = "Alto Sax",
	[Instrument.TenorSax] = "Tenor Sax",
	[Instrument.BaritoneSax] = "Baritone Sax",
	[Instrument.Oboe] = "Oboe",
	[Instrument.EnglishHorn] = "English Horn",
	[Instrument.Bassoon] = "Bassoon",
	[Instrument.Clarinet] = "Clarinet",

	[Instrument.Piccolo] = "Piccolo",
	[Instrument.Flute] = "Flute",
	[Instrument.Recorder] = "Recorder",
	[Instrument.PanFlute] = "Pan Flute",
	[Instrument.BlownBottle] = "Blown Bottle",
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

	[Instrument.TinkleBell] = "Tinkle Bell",
	[Instrument.Agogo] = "Agogo",
	[Instrument.SteelDrums] = "Steel Drums",
	[Instrument.Woodblock] = "Woodblock",
	[Instrument.TaikoDrum] = "Taiko Drum",
	[Instrument.MelodicTom] = "Melodic Tom",
	[Instrument.SynthDrum] = "Synth Drum",
	[Instrument.ReverseCymbal] = "Reverse Cymbal",

	[Instrument.GuitarFretNoise] = "Guitar Fret Noise",
	[Instrument.BreathNoise] = "Breath Noise",
	[Instrument.Seashore] = "Seashore",
	[Instrument.BirdTweet] = "Bird Tweet",
	[Instrument.TelephoneRing] = "Telephone Ring",
	[Instrument.Helicopter] = "Helicopter",
	[Instrument.Applause] = "Applause",
	[Instrument.Gunshot] = "Gunshot",

	[Instrument.Percussions] = "Percussions",
	[Instrument.Drumkit] = "Percussions",

	[Instrument.None] = "(None)",
}

msg.MIDI_PERCUSSION_NAMES = {
	[Percussion.Laser] = "Laser",
	[Percussion.Whip] = "Whip",
	[Percussion.ScratchPush] = "Scratch Push",
	[Percussion.ScratchPull] = "Scratch Pull",
	[Percussion.StickClick] = "Stick Click",
	[Percussion.SquareClick] = "Square Click",
	[Percussion.MetronomeClick] = "Metronome Click",
	[Percussion.MetronomeBell] = "Metronome Bell",
	[Percussion.AcousticBassDrum] = "Acoustic Bass Drum",
	[Percussion.BassDrum1] = "Bass Drum 1",
	[Percussion.SideStick] = "Side Stick",
	[Percussion.AcousticSnare] = "Acoustic Snare",
	[Percussion.HandClap] = "Hand Clap",
	[Percussion.ElectricSnare] = "Electric Snare",
	[Percussion.LowFloorTom] = "Low Floor Tom",
	[Percussion.ClosedHiHat] = "Closed Hi Hat",
	[Percussion.HighFloorTom] = "High Floor Tom",
	[Percussion.PedalHiHat] = "Pedal Hi-Hat",
	[Percussion.LowTom] = "Low Tom",
	[Percussion.OpenHiHat] = "Open Hi-Hat",
	[Percussion.LowMidTom] = "Low-Mid Tom",
	[Percussion.HiMidTom] = "Hi-Mid Tom",
	[Percussion.CrashCymbal1] = "Crash Cymbal 1",
	[Percussion.HighTom] = "High Tom",
	[Percussion.RideCymbal1] = "Ride Cymbal 1",
	[Percussion.ChineseCymbal] = "Chinese Cymbal",
	[Percussion.RideBell] = "Ride Bell",
	[Percussion.Tambourine] = "Tambourine",
	[Percussion.SplashCymbal] = "Splash Cymbal",
	[Percussion.Cowbell] = "Cowbell",
	[Percussion.CrashCymbal2] = "Crash Cymbal 2",
	[Percussion.Vibraslap] = "Vibraslap",
	[Percussion.RideCymbal2] = "Ride Cymbal 2",
	[Percussion.HiBongo] = "Hi Bongo",
	[Percussion.LowBongo] = "Low Bongo",
	[Percussion.MuteHiConga] = "Mute Hi Conga",
	[Percussion.OpenHiConga] = "Open Hi Conga",
	[Percussion.LowConga] = "Low Conga",
	[Percussion.HighTimbale] = "High Timbale",
	[Percussion.LowTimbale] = "Low Timbale",
	[Percussion.HighAgogo] = "High Agogo",
	[Percussion.LowAgogo] = "Low Agogo",
	[Percussion.Cabasa] = "Cabasa",
	[Percussion.Maracas] = "Maracas",
	[Percussion.ShortWhistle] = "Short Whistle",
	[Percussion.LongWhistle] = "Long Whistle",
	[Percussion.ShortGuiro] = "Short Guiro",
	[Percussion.LongGuiro] = "Long Guiro",
	[Percussion.Claves] = "Claves",
	[Percussion.HiWoodBlock] = "Hi Wood Block",
	[Percussion.LowWoodBlock] = "Low Wood Block",
	[Percussion.MuteCuica] = "Mute Cuica",
	[Percussion.OpenCuica] = "Open Cuica",
	[Percussion.MuteTriangle] = "Mute Triangle",
	[Percussion.OpenTriangle] = "Open Triangle",
	[Percussion.Shaker] = "Shaker",
	[Percussion.SleighBell] = "Sleigh Bell",
	[Percussion.BellTree] = "Bell Tree",
	[Percussion.Castanets] = "Castanets",
	[Percussion.SurduDeadStroke] = "Surdu Dead Stroke",
	[Percussion.Surdu] = "Surdu",
	[Percussion.SnareDrumRod] = "Snare Drum Rod",
	[Percussion.OceanDrum] = "Ocean Drum",
	[Percussion.SnareDrumBrush] = "Snare Drum Brush",
}

Musician.Msg = msg
