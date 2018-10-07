Musician.CHANNEL  = "MusicianComm"
Musician.PASSWORD = "TrustMeIMAMusician"

Musician.URL = "https://lenwe.info/musician"
Musician.CONVERTER_URL = "https://lenwe.info/musician-midi-convert"

Musician.FILE_HEADER = "MUS3"
Musician.MAX_NOTE_DURATION = 6
Musician.NOTE_DURATION_FPS = 255 / Musician.MAX_NOTE_DURATION -- 8-bit
Musician.CHUNK_DURATION = 2
Musician.NOTE_TIME_FPS = 240
Musician.MAX_CHUNK_NOTE_TIME = 255 / Musician.NOTE_TIME_FPS -- 8-bit

Musician.NOTE_NAMES = {[0] = 'C', [1] = 'C#', [2] = 'D', [3] = 'D#', [4] = 'E', [5] = 'F', [6] = 'F#', [7] = 'G', [8] = 'G#', [9] = 'A', [10] = 'A#', [11] = 'B'}
Musician.NOTE_IDS   = {['C'] = 0, ['C#'] = 1, ['D'] = 2, ['D#'] = 3, ['E'] = 4, ['F'] = 5, ['F#'] = 6, ['G'] = 7, ['G#'] = 8, ['A'] = 9, ['A#'] = 10, ['B'] = 11}
Musician.C0_INDEX = 24

Musician.MIN_KEY = 24 -- C0
Musician.MAX_KEY = 120 -- C8

Musician.POSITION_UPDATE_PERIOD = 4
Musician.LISTENING_RADIUS = 40
Musician.LOADING_RADIUS = 100

Musician.IMPORT_CONVERT_RATE = 210 / 3 -- Number of base64 bytes to be converted in 1 ms
Musician.IMPORT_NOTE_RATE = 110 / 3 -- Number of notes to be imported in 1 ms

Musician.BANDWIDTH_LIMIT_MIN = 240
Musician.BANDWIDTH_LIMIT_MAX = 500

Musician.Msg = {}
Musician.Locale = {}

Musician.Events = {}
Musician.Events.RefreshFrame = "MusicianRefreshFrame"
Musician.Events.SongPlay = "MusicianSongPlay"
Musician.Events.SongStop = "MusicianSongStop"
Musician.Events.SongCursor = "MusicianSongCursor"
Musician.Events.NoteOn = "MusicianNoteOn"
Musician.Events.NoteOff = "MusicianNoteOff"
Musician.Events.NoteDropped = "MusicianNoteDropped"
Musician.Events.PreloadingProgress = "MusicianPreloadingProgress"
Musician.Events.SongImportStart = "MusicianSongImportStart"
Musician.Events.SongImportProgress = "MusicianSongImportProgress"
Musician.Events.SongImportComplete = "MusicianSongImportComplete"
Musician.Events.SongImportSucessful = "MusicianSongImportSucessful"
Musician.Events.SongImportFailed = "MusicianSongImportFailed"
Musician.Events.SourceSongLoaded = "MusicianSourceSongLoaded"
Musician.Events.Bandwidth = "MusicianBandwidth"

Musician.Icons = {}
Musician.Icons.PlayerMuted = "Interface\\AddOns\\Musician\\ui\\textures\\muted.blp"
Musician.Icons.PlayerUnmuted = "Interface\\AddOns\\Musician\\ui\\textures\\unmuted.blp"
