Musician.LocaleBase = {}
local msg = Musician.LocaleBase

msg.FIXED_KEY_NAMES = {}
msg.KEYBOARD_LAYOUTS = {}
msg.LAYERS = {}
msg.LINKS_ERROR = {}
msg.INSTRUMENT_NAMES = {}
msg.MIDI_INSTRUMENT_NAMES = {}
msg.MIDI_PERCUSSION_NAMES = {}

Musician.DefaultTranslator = "Google Translate"

Musician.LocalizationTeam = {
	{ 'de', Musician.DefaultTranslator },
	{ 'en', "LenweSaralonde" },
	{ 'es', Musician.DefaultTranslator },
	{ 'fr', "LenweSaralonde" },
	{ 'it', Musician.DefaultTranslator },
	{ 'ko', Musician.DefaultTranslator },
	{ 'pt', Musician.DefaultTranslator },
	{ 'ru', Musician.DefaultTranslator, "ToxaAveNCR" },
	{ 'tw', Musician.DefaultTranslator },
	{ 'zh', "Grayson Blackclaw" },
}