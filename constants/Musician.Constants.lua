Musician.CHANNEL  = "MusicianComm"
Musician.PASSWORD = "TrustMeIMAMusician"

Musician.URL = "https://lenwe.info/musician"
Musician.CONVERTER_URL = "https://lenwe.info/musician-midi-convert"

Musician.FILE_HEADER = "MUS2"
Musician.MAX_NOTE_DURATION = 6
Musician.DURATION_FPS = 255 / Musician.MAX_NOTE_DURATION -- 2^8

Musician.NOTE_NAMES = {[0] = 'C', [1] = 'C#', [2] = 'D', [3] = 'D#', [4] = 'E', [5] = 'F', [6] = 'F#', [7] = 'G', [8] = 'G#', [9] = 'A', [10] = 'A#', [11] = 'B'}
Musician.NOTE_IDS   = {['C'] = 0, ['C#'] = 1, ['D'] = 2, ['D#'] = 3, ['E'] = 4, ['F'] = 5, ['F#'] = 6, ['G'] = 7, ['G#'] = 8, ['A'] = 9, ['A#'] = 10, ['B'] = 11}
Musician.C0_INDEX = 24

Musician.POSITION_UPDATE_PERIOD = 4
Musician.LISTENING_RADIUS = 40

Musician.Msg = {}
Musician.Locale = {}

Musician.Events = {}
Musician.Events.RefreshFrame = "MusicianRefreshFrame"
Musician.Events.SongPlay = "MusicianSongPlay"
Musician.Events.SongStop = "MusicianSongStop"
Musician.Events.SongCursor = "MusicianSongCursor"
Musician.Events.NoteOn = "MusicianNoteOn"
Musician.Events.NoteOff = "MusicianNoteOff"

Musician.Icons = {}
Musician.Icons.PlayerMuted = "Interface\\AddOns\\Musician\\ui\\textures\\muted.blp"
Musician.Icons.PlayerUnmuted = "Interface\\AddOns\\Musician\\ui\\textures\\unmuted.blp"
