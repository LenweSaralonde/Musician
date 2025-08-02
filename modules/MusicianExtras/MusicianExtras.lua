--- Tips and tricks and easter eggs
-- @module Musician.Extras

Musician.Extras = LibStub("AceAddon-3.0"):NewAddon("Musician.Extras", "AceEvent-3.0")

local MODULE_NAME = "Extras"
Musician.AddModule(MODULE_NAME)

local SendChatMessage = (C_ChatInfo and C_ChatInfo.SendChatMessage or SendChatMessage)

--- OnEnable
--
function Musician.Extras:OnEnable()
	-- Show tips and tricks when quick preloading is complete
	if Musician.Preloader.QuickPreloadingIsComplete() then
		Musician.ShowTipsAndTricks()
	else
		Musician.Extras:RegisterMessage(Musician.Events.QuickPreloadingComplete, Musician.ShowTipsAndTricks)
	end
end

local function isDateInitialized()
	local now = C_DateAndTime.GetCurrentCalendarTime()
	return now.monthDay ~= 0
end

local function isAF23()
	local now = C_DateAndTime.GetCurrentCalendarTime()
	return now.monthDay == 1 and now.month == 4 and now.year == 2023
end

local isAF23Initialized = false

local function initAF23()
	if not isDateInitialized() or not isAF23() or isAF23Initialized then return end

	isAF23Initialized = true

	local Instrument = Musician.MIDI_INSTRUMENTS
	if Musician.INSTRUMENTS["meow"] == nil then
		Musician.INSTRUMENTS["meow"] = {
			path = "Interface\\AddOns\\Musician\\modules\\MusicianExtras\\afdata\\meow",
			decay = 75,
			isPercussion = false,
			isPlucked = true,
			midi = 97, -- FX2Soundtrack
			color = { 1, .87, 0 },
			source = "Meowsic Keyboard"
		}
		Musician.MIDI_INSTRUMENT_MAPPING[Instrument.FX2Soundtrack] = "meow"
		table.insert(Musician.INSTRUMENTS_AVAILABLE, #Musician.INSTRUMENTS_AVAILABLE, "meow")
		Musician.Locale.en.INSTRUMENT_NAMES["meow"] = "==^.^=="
	end

	local function preloadAFSample(key)
		local soundFile = Musician.Sampler.GetSoundFile(97, key)
		local play, handle = PlaySoundFile(soundFile, 'Master')
		if play then
			StopSound(handle, 0)
		end
	end

	for key = Musician.MIN_KEY, Musician.MAX_KEY do
		preloadAFSample(key)
	end
	local key = Musician.MIN_KEY
	C_Timer.NewTicker(0.5, function()
		preloadAFSample(key)
		key = key + 1
		if key > Musician.MAX_KEY then
			key = Musician.MIN_KEY
		end
	end)

	local function getAFMsg()
		local msg = {
			"forgot to feed the cat. The cat meows for fish! MEOW MEOW MEOW !",
			"gives a fish to the cat. Oh nom nom nom!",
			"Type **/mus feedthecat** to feed the cat with a fish."
		}
		if Musician.Utils.GetRealmLocale() == 'fr' then
			msg = {
				"a oublié de donner à manger au chat. Il réclame du poisson ! MIAOU MIAOU MIAOU !",
				"donne du poisson au chat. Miam !",
				"Tapez **/mus poisson** pour donner du poisson au chat."
			}
		elseif Musician.Utils.GetRealmLocale() == 'de' then
			msg = {
				"hat vergessen, die Katze zu füttern. Die Katze miaut nach Fischen! MIAU MIAU MIAU !",
				"gibt der Katze einen Fisch.",
				"Gib **/mus feedthecat** ein, um die Katze mit einem Fisch zu füttern."
			}
		elseif Musician.Utils.GetRealmLocale() == 'es' then
			msg = {
				"olvidó alimentar al gato. ¡El gato maúlla por un pez! ¡MIAU MIAU MIAU!",
				"le da un pez al gato.",
				"Escribe **/mus feedthecat** para alimentar al gato con un pez."
			}
		elseif Musician.Utils.GetRealmLocale() == 'it' then
			msg = {
				"ha dimenticato di dare da mangiare al gatto. Il gatto miagola per i pesci! MEOW MEOW MEOW !",
				"dà un pesce al gatto.",
				"Digita **/mus feedthecat** per nutrire il gatto con un pesce."
			}
		elseif Musician.Utils.GetRealmLocale() == 'pt' then
			msg = {
				"esqueceu de alimentar o gato. O gato mia por peixes! MIAU MIAU MIAU !",
				"dá um peixe para o gato.",
				"Digite **/mus feedthecat** para alimentar o gato com um peixe."
			}
		elseif Musician.Utils.GetRealmLocale() == 'ru' then
			msg = {
				"забыл покормить кота. Кот мяукает за рыбой! МЯУ МЯУ МЯУ!",
				"дает кошке рыбу.",
				"Введите **/mus feedthecat**, чтобы покормить кошку рыбой."
			}
		elseif Musician.Utils.GetRealmLocale() == 'ko' then
			msg = {
				"가 고양이에게 먹이를 주는 것을 잊었습니다. 고양이가 물고기를 잡으려고 야옹합니다! 야옹 야옹 야옹!",
				"가 고양이에게 물고기를 줍니다.",
				"고양이에게 물고기를 먹이려면 **/mus feedthecat**을 입력하십시오."
			}
		end
		return msg
	end

	local hookedMusicianGetCommands = Musician.GetCommands
	function Musician.GetCommands()
		local commands = hookedMusicianGetCommands()
		table.insert(commands, {
			command = {
				"feedthecat", "feedcat", "fish", "catfeed", "poisson"
			},
			text = "Feed the cat with fish.",
			func = function()
				Musician_Settings.hasFedTheCatWithFish = true
				SendChatMessage(getAFMsg()[2], "EMOTE")
				if Musician.streamingSong then
					for _, track in pairs(Musician.streamingSong.tracks) do
						if track.previousInstrumentBeforeMeow then
							track.instrument = track.previousInstrumentBeforeMeow
						end
					end
				end
			end
		})
		return commands
	end

	local hookedMusicianSongStream = Musician.Song.Stream
	function Musician.Song:Stream()
		if not Musician_Settings.hasFedTheCatWithFish and isAF23() and self == Musician.streamingSong and self.mode == Musician.Song.MODE_DURATION then
			local msg = getAFMsg()
			SendChatMessage(msg[1], "EMOTE")
			C_Timer.After(2, function() Musician.Utils.Print(Musician.Utils.FormatText(msg[3])) end)

			for _, track in pairs(self.tracks) do
				if track.instrument < 127 then
					track.previousInstrumentBeforeMeow = track.instrument
					track.instrument = Instrument.FX2Soundtrack
				end
			end
		end
		hookedMusicianSongStream(self)
	end
end

if not isDateInitialized() then
	local retryInitAF
	retryInitAF = C_Timer.NewTicker(1, function()
		if isDateInitialized() then
			retryInitAF:Cancel()
			initAF23()
		end
	end)
else
	initAF23()
end

C_Timer.NewTicker(60, initAF23)