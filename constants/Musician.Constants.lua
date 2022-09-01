--- Global constants
-- @module Musician.Constants

Musician.CHANNEL  = "MusicianComm"
Musician.PASSWORD = "TrustMeIMAMusician"

Musician.URL = "https://musician.lenwe.io"
Musician.CONVERTER_URL = "https://musician.lenwe.io/import"
Musician.DISCORD_URL = "https://discord.gg/ypfpGxK"
Musician.PATREON_URL = "https://musician.lenwe.io/patreon"
Musician.PAYPAL_URL = "https://musician.lenwe.io/paypal"
Musician.LOCALIZATION_URL = "https://musician.lenwe.io/localize"

Musician.FILE_HEADER = "MUS8"
Musician.FILE_HEADER_COMPRESSED = "MUZ8"
Musician.PROTOCOL_VERSION = 7
Musician.MAX_NOTE_DURATION = 6
Musician.NOTE_DURATION_FPS = 255 / Musician.MAX_NOTE_DURATION -- 8-bit
Musician.MAX_LONG_NOTE_DURATION = 255 * Musician.MAX_NOTE_DURATION
Musician.CHUNK_DURATION = 2
Musician.NOTE_TIME_FPS = 240
Musician.MAX_CHUNK_NOTE_TIME = 255 / Musician.NOTE_TIME_FPS -- 8-bit
Musician.MAX_NOTE_TIME = 65535 / Musician.NOTE_TIME_FPS -- 16-bit

Musician.NOTE_NAMES = {[0] = 'C', [1] = 'C#', [2] = 'D', [3] = 'D#', [4] = 'E', [5] = 'F', [6] = 'F#', [7] = 'G', [8] = 'G#', [9] = 'A', [10] = 'Bb', [11] = 'B'}
Musician.NOTE_IDS   = {['C'] = 0, ['C#'] = 1, ['D'] = 2, ['D#'] = 3, ['E'] = 4, ['F'] = 5, ['F#'] = 6, ['G'] = 7, ['G#'] = 8, ['A'] = 9, ['Bb'] = 10, ['B'] = 11}
Musician.C0_INDEX = 12

Musician.MIN_KEY = 12 -- C0
Musician.MAX_KEY = 108 -- C8

Musician.LISTENING_RADIUS = 40

Musician.BANDWIDTH_LIMIT_MIN = 255 -- Sending up to 255 characters in 1 message
Musician.BANDWIDTH_LIMIT_MAX = 508 -- Sending up to 508 characters in 2 messages

Musician.OS_WINDOWS = "Windows"
Musician.OS_MAC = "MacOS"
Musician.OS_LINUX = "Linux"

Musician.Msg = {}
Musician.Locale = {}

-- Instrument toys to be muted (Retail only)
Musician.InstrumentToys = {
	{
		itemId = 184489, -- Fae Harp
		soundFiles = {
			3885818, -- sound/music/shadowlands/mus_90_aw_nocturne_celestial_harp_a.mp3
			3885820, -- sound/music/shadowlands/mus_90_aw_nocturne_celestial_harp_b.mp3
			3885822, -- sound/music/shadowlands/mus_90_aw_nocturne_celestial_harp_c.mp3
			3885824, -- sound/music/shadowlands/mus_90_aw_nocturne_celestial_harp_d.mp3
		}
	},
	{
		itemId = 188680, -- Winter Veil Chorus Book
		soundFiles = {
			568190, -- 	sound/spells/fx_wintersveil_carolingsweater_05.ogg
			568370, -- 	sound/spells/fx_wintersveil_carolingsweater_04.ogg
			568584, -- 	sound/spells/fx_wintersveil_carolingsweater_06.ogg
			568623, -- 	sound/spells/fx_wintersveil_carolingsweater_07.ogg
			568701, -- 	sound/spells/fx_wintersveil_carolingsweater_03.ogg
			569399, -- 	sound/spells/fx_wintersveil_carolingsweater_01.ogg
			569645, -- 	sound/spells/fx_wintersveil_carolingsweater_02.ogg
		}
	},
}

-- Texture icons paths, for use within strings.
Musician.IconImages = {}
Musician.IconImages.NoteDisabled = "Interface\\AddOns\\Musician\\ui\\textures\\muted.blp"
Musician.IconImages.Note = "Interface\\AddOns\\Musician\\ui\\textures\\unmuted.blp"
Musician.IconImages.Cmd = "Interface\\AddOns\\Musician\\ui\\textures\\cmd.blp"
