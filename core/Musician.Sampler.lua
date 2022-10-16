--- Sampler engine
-- @module Musician.Sampler

Musician.Sampler = LibStub("AceAddon-3.0"):NewAddon("Musician.Sampler")

local MODULE_NAME = "Sampler"
Musician.AddModule(MODULE_NAME)

local notesOn = {}
local playersInRange = {}
local lastHandleId = 0
local globalMute = false

local SAMPLE_FILE_EXT = ".ogg"

local PERCUSSION_MIDI = 128
local FALLBACK_DRUMKIT_MIDI = 128

local NOTEON = {}
NOTEON.KEY = 1
NOTEON.INSTRUMENT_DATA = 2
NOTEON.SOUND_FILE = 3
NOTEON.SOUND_HANDLE = 4
NOTEON.LOOP = 5
NOTEON.TRACK = 6
NOTEON.PLAYER = 7

--- Init sampler engine
--
function Musician.Sampler.Init()
	-- Augment instrument data
	for instrumentName, instrumentData in pairs(Musician.INSTRUMENTS) do
		-- Set instrument name
		instrumentData.name = instrumentName

		-- Assign percussion MIDI id
		if instrumentData.midi == nil and instrumentData.isPercussion then
			instrumentData.midi = PERCUSSION_MIDI
		end

		if instrumentData.pathList ~= nil then
			-- Initialize sound files list
			instrumentData.soundFiles = {}
			for _, path in pairs(instrumentData.pathList) do
				table.insert(instrumentData.soundFiles, path .. SAMPLE_FILE_EXT)
			end

			-- Initialize round robin
			if instrumentData.keyMod == nil then
				instrumentData.roundRobin = 1
			end
		end
	end
end

--- Return the note name corresponding its MIDI key
-- @param key (int) MIDI key index
-- @return name (string) from Musician.NOTE_NAMES
function Musician.Sampler.NoteName(key)
	local noteId = key - Musician.C0_INDEX
	local octave = floor(noteId / 12)
	local note = noteId % 12
	return Musician.NOTE_NAMES[note] .. octave
end

--- Return the MIDI key of the note name
-- @param noteName (string) from Musician.NOTE_NAMES
-- @return key (int)
function Musician.Sampler.NoteKey(noteName)
	for note in string.gmatch(noteName, "[A-Z#]+") do
		local octave = string.match(noteName, "-?%d+")
		if octave then
			return Musician.C0_INDEX + octave * 12 + Musician.NOTE_IDS[note]
		end
	end
	return nil
end

--- Return instrument name from its MIDI ID and key number
-- @param instrument (int) MIDI instrument ID
-- @param[opt] key (int) Only needed to get the final instrument name for traditional percussions
-- @return instrumentName (string) used as key in Musician.INSTRUMENTS
function Musician.Sampler.GetInstrumentName(instrument, key)
	local instrumentName

	-- Unknown drum kit: use fallback
	if Musician.MIDI_INSTRUMENT_MAPPING[instrument] == nil and instrument >= 128 and instrument <= 255 then
		instrumentName = Musician.MIDI_INSTRUMENT_MAPPING[FALLBACK_DRUMKIT_MIDI]
	else
		instrumentName = Musician.MIDI_INSTRUMENT_MAPPING[instrument] or 'none'
	end

	-- Return final instrument name for traditional percussions if a key number is provided
	if key ~= nil and Musician.INSTRUMENTS[instrumentName].midi == PERCUSSION_MIDI then
		instrumentName = Musician.MIDI_PERCUSSION_MAPPING[key] or "none"
	end

	return instrumentName
end

--- Return localized General MIDI instrument name
-- @param instrument (int)
-- @return localizedInstrumentName (string)
function Musician.Sampler.GetLocalizedMIDIInstrumentName(instrument)
	-- Unsupported drum kit
	if Musician.MIDI_INSTRUMENT_MAPPING[instrument] == nil and instrument >= 128 and instrument <= 255 then
		return (string.gsub(Musician.Msg.UNKNOWN_DRUMKIT, '{midi}', instrument - 128))
	end
	return Musician.Msg.MIDI_INSTRUMENT_NAMES[instrument] or ""
end

--- Return instrument data for given MIDI key number
-- @param instrumentName (string)
-- @param key (int) MIDI key number
-- @return instrumentData (table) from Musician.INSTRUMENTS
function Musician.Sampler.GetInstrumentData(instrumentName, key)
	local instrumentData = Musician.INSTRUMENTS[instrumentName]
	if instrumentData == nil then
		return nil
	end

	-- Handle specific percussion mapping
	if instrumentData.midi == PERCUSSION_MIDI and not instrumentData.isPercussion then
		return Musician.Sampler.GetInstrumentData(Musician.MIDI_PERCUSSION_MAPPING[key], key)
	end

	return instrumentData
end

--- Get the path to a sound file for an instrument and a key.
-- Also returns the instrument data from Musician.INSTRUMENTS
-- and all other suitable sound file paths for randomization.
-- @param instrument (int|string|table) MIDI instrument index, instrument name or instrument data
-- @param key (int) MIDI key
-- @return soundFile (string|nil) file path to be played
-- @return instrumentData (table|nil) from Musician.INSTRUMENTS
-- @return soundFiles (table|nil) all possible file paths for this instrument and note, when applicable
function Musician.Sampler.GetSoundFile(instrument, key)

	if instrument == nil or key == nil then return nil end

	-- Key is out of range
	if key < Musician.MIN_KEY or key > Musician.MAX_KEY then return nil end

	local instrumentNumber = type(instrument) == 'number' and instrument
	local instrumentName = type(instrument) == 'string' and instrument
	local instrumentData = type(instrument) == 'table' and instrument

	if instrumentNumber then
		instrumentName = Musician.Sampler.GetInstrumentName(instrumentNumber, key)
		if instrumentName == nil then
			return nil
		end
	end

	if instrumentName then
		instrumentData = Musician.Sampler.GetInstrumentData(instrumentName, key)
		if instrumentData == nil then
			return nil
		end
	end

	if instrumentData.name == 'none' then
		return nil
	end

	local noteName = Musician.Sampler.NoteName(key)

	if instrumentData.regions ~= nil then
		-- Use regions
		for _, region in pairs(instrumentData.regions) do
			if key >= region.loKey and key <= region.hiKey then
				local soundFile = region.path
				if not instrumentData.isPercussion then
					soundFile = soundFile .. '\\' .. noteName
				end
				soundFile = soundFile .. SAMPLE_FILE_EXT
				return soundFile, instrumentData
			end
		end
		return nil, instrumentData
	elseif instrumentData.pathList ~= nil then
		-- Use path list
		local soundFile
		if instrumentData.keyMod ~= nil then
			-- Use key modulo
			soundFile = instrumentData.soundFiles[(key - instrumentData.keyMod) % #instrumentData.soundFiles + 1]
		else
			-- Use round robin
			soundFile = instrumentData.soundFiles[instrumentData.roundRobin]
		end
		return soundFile, instrumentData, instrumentData.soundFiles
	else
		-- Use single path
		local soundFile = instrumentData.path
		if not instrumentData.isPercussion then
			soundFile = soundFile .. '\\' .. noteName
		end
		soundFile = soundFile .. SAMPLE_FILE_EXT
		return soundFile, instrumentData
	end
end

--- Get the release sound file, if applicable
-- @param instrumentData (table)
-- @param key (int) MIDI key
-- @return releaseSoundFile (string|nil)
function Musician.Sampler.GetReleaseSoundFile(instrumentData, key)
	if instrumentData.release then
		local noteName = Musician.Sampler.NoteName(key)
		return instrumentData.release .. "\\" .. noteName .. SAMPLE_FILE_EXT
	end
	return nil
end

--- Returns true if the provided instrument is "plucked".
-- @param instrument (int) MIDI instrument ID
-- @return isPlucked (boolean)
function Musician.Sampler.IsInstrumentPlucked(instrument)
	-- Percussions are always plucked
	if instrument >= 128 then
		return true
	end

	-- Melodic instruments
	local instrumentName = Musician.MIDI_INSTRUMENT_MAPPING[instrument]
	local instrumentData = instrumentName and Musician.INSTRUMENTS[instrumentName]
	return instrumentData and (instrumentData.isPercussion or instrumentData.isPlucked) or false
end

--- Clear the "player is in range" cache
--
local function clearPlayerRangeCache()
	wipe(playersInRange)
end

--- Indicates if the the player is in hearing range, using cache
-- @param player (string)
-- @return isInRange (boolean)
local function isPlayerInRange(player)
	if playersInRange[player] == nil then
		playersInRange[player] = Musician.Registry.PlayerIsInRange(player)
	end
	return playersInRange[player]
end

--- Indicates if the provided note on should be playing
-- @param noteOn (table)
-- @return shouldPlay (boolean)
local function noteOnShouldPlay(noteOn)
	local player = noteOn[NOTEON.PLAYER]
	local track = noteOn[NOTEON.TRACK]
	local shouldPlay = not globalMute

	-- If the note comes from another player while the source song is playing, it should not play.
	if shouldPlay and player ~= nil and Musician.sourceSong ~= nil and Musician.sourceSong:IsPlaying() then
		shouldPlay = false
	end

	-- The track is audible
	if shouldPlay and track ~= nil then
		shouldPlay = track.audible
	end

	-- The player is not muted
	if shouldPlay and player ~= nil then
		shouldPlay = not Musician.PlayerIsMuted(player)
	end

	-- The player should be in range
	if shouldPlay and player ~= nil then
		shouldPlay = isPlayerInRange(player)
	end

	return shouldPlay
end

--- Play a sound file using the first available sound channel.
-- @param soundFile (string) Path to the sound file
-- @return willPlay (boolean|nil)
-- @return soundHandle (int|nil)
-- @return channel (string|nil)
function Musician.Sampler.PlaySoundFile(soundFile)
	local soundHandle, willPlay, channel
	local audioChannels = Musician_Settings.audioChannels

	-- Try Master
	if audioChannels.Master then
		channel = "Master"
		willPlay, soundHandle = PlaySoundFile(soundFile, channel)
	end

	-- Try SFX
	if not willPlay and audioChannels.SFX then
		channel = "SFX"
		willPlay, soundHandle = PlaySoundFile(soundFile, channel)
	end

	-- Try Dialog
	if not willPlay and audioChannels.Dialog then
		channel = "Dialog"
		willPlay, soundHandle = PlaySoundFile(soundFile, channel)
	end

	return willPlay, soundHandle, channel
end

--- Play a sample file
-- Can perform multiple attempts if the sound file could not play
-- @param handle (int) Sampler note handle
-- @param instrumentData (table)
-- @param soundFile (string) Sample file path
-- @param tries (int) Number of attempts in case of failures due to limited polyphony
local function playSampleFile(handle, instrumentData, soundFile, tries)
	if not notesOn[handle] then
		return
	end

	local audioChannels = Musician_Settings.audioChannels

	-- No channel is set
	if not audioChannels.Master and not audioChannels.SFX and not audioChannels.Dialog then
		return
	end

	-- Play the sample sound file
	local willPlay, soundHandle, channel = Musician.Sampler.PlaySoundFile(soundFile)

	-- Note sound file will play
	if willPlay then
		Musician.Utils.Debug(MODULE_NAME, 'playSampleFile', handle, channel, soundFile)

		-- Keep internal handle
		notesOn[handle][NOTEON.SOUND_HANDLE] = soundHandle

		-- Increment instrument round robin
		if instrumentData.roundRobin ~= nil then
			if instrumentData.roundRobin >= #instrumentData.pathList then
				instrumentData.roundRobin = 1
			else
				instrumentData.roundRobin = instrumentData.roundRobin + 1
			end
		end

		return
	end

	-- Note failed to play due to lack of available polyphony
	Musician.Utils.Debug(MODULE_NAME, 'Dropped note', handle, "(tries: " .. tries .. ")")

	-- Set a dummy sound handle to avoid the main loop to attempt to play the note on its own
	notesOn[handle][NOTEON.SOUND_HANDLE] = -1

	if tries < 2 then
		-- Stop the oldest note to release a polyphony slot
		Musician.Sampler.StopOldestNote()
		-- Try again on the next frame
		C_Timer.After(0, function()
			playSampleFile(handle, instrumentData, soundFile, tries + 1)
		end)
	end
end

--- Start playing a note audio sample.
-- @param handle (int) The note handle returned by PlayNote()
-- @param loopNote (boolean) The note sample should be looped (long note or live note)
-- @param isLooped (boolean) The note sample is being looped
local function playNoteSample(handle, loopNote, isLooped)
	local noteOn = notesOn[handle]
	local key = noteOn[NOTEON.KEY]
	local instrumentData = noteOn[NOTEON.INSTRUMENT_DATA]

	if isLooped then
		-- Stop the previously playing handle for looping
		StopSound(noteOn[NOTEON.SOUND_HANDLE], instrumentData.crossfade)
	end

	-- Set sample loop
	if loopNote and instrumentData.loop ~= nil then
		local loop = instrumentData.loop[1] + random() * (instrumentData.loop[2] - instrumentData.loop[1])
		noteOn[NOTEON.LOOP] = debugprofilestop() + loop * 1000
	end

	-- Play the note file only if it has already been preloaded in the file cache
	local sampleId = Musician.Sampler.GetSampleId(instrumentData, key)
	local soundFile = noteOn[NOTEON.SOUND_FILE]
	if soundFile and Musician.Preloader.IsPreloaded(sampleId) then
		playSampleFile(handle, instrumentData, soundFile, 0)
	end
end

--- Start playing a note
-- @param instrument (int|string|table) MIDI instrument index, instrument name or instrument data
-- @param key (int) Note MIDI key
-- @param loopNote (boolean) The note sample should be looped (long note or live note)
-- @param[opt] track (table) The track the note comes from
-- @param[opt] player (string) The normalized name of the player who plays the note
-- @return handle (int)
-- @return willPlay (boolean)
function Musician.Sampler.PlayNote(instrument, key, loopNote, track, player)
	local soundFile, instrumentData = Musician.Sampler.GetSoundFile(instrument, key)

	if soundFile == nil then
		return nil, false
	end

	local noteOn = {
		[NOTEON.INSTRUMENT_DATA] = instrumentData,
		[NOTEON.SOUND_FILE] = soundFile,
		[NOTEON.KEY] = key,
		[NOTEON.TRACK] = track,
		[NOTEON.PLAYER] = player,
	}

	lastHandleId = lastHandleId + 1
	notesOn[lastHandleId] = noteOn

	Musician.Utils.Debug(MODULE_NAME, 'PlayNote', lastHandleId, instrumentData and instrumentData.name, key,
		loopNote and '(looped)' or '')

	local willPlay = noteOnShouldPlay(noteOn)
	if willPlay then
		playNoteSample(lastHandleId, loopNote, false)
	end

	return lastHandleId, willPlay
end

--- Stop playing a note audio sample.
-- @param handle (int) The note handle returned by PlayNote()
-- @param[opt] decay (number) Override instrument decay
-- @param[opt] playReleaseSample (boolean) Play the release sample, if any
local function stopNoteSample(handle, decay, playReleaseSample)
	local noteOn = notesOn[handle]

	-- Note sample is not playing
	local soundHandle = noteOn[NOTEON.SOUND_HANDLE]
	if soundHandle == nil then
		return
	end

	-- Get sample decay
	local instrumentData = noteOn[NOTEON.INSTRUMENT_DATA]
	local key = noteOn[NOTEON.KEY]
	if decay == nil and instrumentData then
		if instrumentData.decayByKey ~= nil then
			decay = instrumentData.decayByKey[key] or instrumentData.decay
		else
			decay = instrumentData.decay
		end
	end

	-- Stop playing the sample
	Musician.Utils.Debug(MODULE_NAME, 'stopNoteSample', handle, decay)
	StopSound(soundHandle, decay)

	-- Play release sample
	if playReleaseSample and instrumentData.release and decay ~= 0 then
		local releaseSampleFile = Musician.Sampler.GetReleaseSoundFile(instrumentData, key)
		local releaseWillPlay, releaseSoundHandle, channel = Musician.Sampler.PlaySoundFile(releaseSampleFile)
		Musician.Utils.Debug(MODULE_NAME, "stopNoteSample", "Play release sample", handle, channel, releaseSampleFile)
		if releaseWillPlay then
			C_Timer.After((instrumentData.releaseSustain or 0) / 1000, function()
				StopSound(releaseSoundHandle, instrumentData.releaseDecay)
			end)
		end
	end

	-- Remove note on
	noteOn[NOTEON.SOUND_HANDLE] = nil
end

--- Stop playing note
-- @param handle (int) The note handle returned by PlayNote()
-- @param[opt] decay (number) Override instrument decay
function Musician.Sampler.StopNote(handle, decay)
	if handle == nil or not notesOn[handle] then
		return
	end

	local noteOn = notesOn[handle]
	local key = noteOn[NOTEON.KEY]
	local instrumentData = noteOn[NOTEON.INSTRUMENT_DATA]
	Musician.Utils.Debug(MODULE_NAME, 'StopNote', handle, instrumentData and instrumentData.name, key)

	stopNoteSample(handle, decay, true)

	wipe(notesOn[handle])
	notesOn[handle] = nil
end

--- Main on frame update function
--
function Musician.Sampler.OnUpdate()
	clearPlayerRangeCache() -- Refresh in range player status on every frame

	-- Determine notes that should be playing and those that should be stopped
	for handle, noteOn in pairs(notesOn) do
		local shouldPlayNote = noteOnShouldPlay(noteOn)
		local isNotePlaying = noteOn[NOTEON.SOUND_HANDLE] ~= nil

		if isNotePlaying and not shouldPlayNote then
			-- The note audio should be stopped
			stopNoteSample(handle)

		elseif not isNotePlaying and shouldPlayNote then
			-- The note audio should be started after it was muted
			local instrumentData = noteOn[NOTEON.INSTRUMENT_DATA]
			local isPlucked = instrumentData.midi > 127 or instrumentData.isPercussion or instrumentData.isPlucked
			if not isPlucked then
				playNoteSample(handle, noteOn[NOTEON.LOOP] ~= nil, false)
			end

		elseif isNotePlaying and noteOn[NOTEON.LOOP] ~= nil and noteOn[NOTEON.LOOP] < debugprofilestop() then
			-- The note audio should be looped
			playNoteSample(handle, true, true)
		end
	end
end

--- Stop playing the oldest note to release a polyphony slot
--
function Musician.Sampler.StopOldestNote()

	Musician.Utils.Debug(MODULE_NAME, 'StopOldestNote')

	local minHandle
	for handle, noteOn in pairs(notesOn) do
		if noteOn[NOTEON.SOUND_HANDLE] and (minHandle == nil or handle < minHandle) then
			minHandle = handle
		end
	end
	if minHandle then
		Musician.Sampler.StopNote(minHandle, 0) -- No decay
	end
end

--- Return sample ID for note and instrument data
-- @param instrumentData (table) as returned by Musician.Sampler.GetInstrumentData()
-- @param key (int) MIDI key number
-- @return sampleId (string)
function Musician.Sampler.GetSampleId(instrumentData, key)
	if instrumentData == nil or instrumentData.name == nil or instrumentData.name == "none" then
		return nil
	end

	if instrumentData.isPercussion then
		return instrumentData.name
	else
		return instrumentData.name .. '-' .. key
	end
end

--- Set global mute state
-- @param isMuted (boolean)
function Musician.Sampler.SetMuted(isMuted)
	globalMute = isMuted
end

--- Return global mute state
-- @return isMuted (boolean)
function Musician.Sampler.GetMuted()
	return globalMute
end