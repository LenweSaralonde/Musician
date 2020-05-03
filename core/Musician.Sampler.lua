--- Sampler engine
-- @module Musician.Sampler

Musician.Sampler = LibStub("AceAddon-3.0"):NewAddon("Musician.Sampler")

local MODULE_NAME = "Sampler"
Musician.AddModule(MODULE_NAME)

local notesOn = {}

--- Init sampler engine
--
function Musician.Sampler.Init()
	-- Augment instrument data
	local instrumentName, instrumentData
	for instrumentName, instrumentData in pairs(Musician.INSTRUMENTS) do
		-- Set instrument name
		instrumentData.name = instrumentName

		-- Assign percussion MIDI id
		if instrumentData.midi == nil and instrumentData.isPercussion then
			instrumentData.midi = 128
		end

		-- Initialize round robin
		if instrumentData.pathList ~= nil then
			instrumentData.rr = 1
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
	local octave, note

	for note in string.gmatch(noteName, "[A-Z#]+") do
		for octave in string.gmatch(noteName, "-?%d+") do
			return Musician.C0_INDEX + octave * 12 + Musician.NOTE_IDS[note]
		end
	end

	return nil
end

--- Return instrument name from its MIDI ID and key number
-- @param instrument (int)
-- @param key (int)
-- @return instrumentName (string) used as key in Musician.INSTRUMENTS
function Musician.Sampler.GetInstrumentName(instrument, key)
	if instrument ~= 128 then -- Not a percussion
		return Musician.MIDI_INSTRUMENT_MAPPING[instrument]
	else -- Percussion
		return Musician.MIDI_PERCUSSION_MAPPING[key]
	end
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
	if instrumentData.midi == 128 and not(instrumentData.isPercussion) then
		return Musician.Sampler.GetInstrumentData(Musician.MIDI_PERCUSSION_MAPPING[key], key)
	end

	return instrumentData
end

--- Get the path to a sound file for an instrument and a key.
-- Also returns the instrument data from Musician.INSTRUMENTS
-- and all other suitable sound file paths for randomization.
-- @param instrument (int|string|table) MIDI instrument index, instrument name or instrument data
-- @param key (int) MIDI key
-- @return filePath (string) file path to be played
-- @return instrumentData (table) from Musician.INSTRUMENTS
-- @return soundFiles (table) all suitable file paths for this instrument and note
function Musician.Sampler.GetSoundFile(instrument, key)

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

	local soundPaths, soundPath
	-- Use regions
	if instrumentData.regions ~= nil then
		local region
		soundPaths = {}
		for _, region in pairs(instrumentData.regions) do
			local hiKey = region.hiKey - 12 + Musician.C0_INDEX
			local loKey = region.loKey - 12 + Musician.C0_INDEX
			if key >= loKey and key <= hiKey then
				table.insert(soundPaths, region.path)
			end
		end

	-- Use path list with round robin
	elseif instrumentData.pathList ~= nil then
		soundPaths = instrumentData.pathList
	-- Use single path
	else
		soundPaths = { instrumentData.path }
	end

	-- Apply transposition
	if instrumentData["transpose"] then
		key = key + instrumentData["transpose"]
	end

	local noteName = Musician.Sampler.NoteName(key)

	local soundFiles = {}
	local i, soundPath
	for i, soundPath in pairs(soundPaths) do
		local soundFile = soundPath
		if not(instrumentData.isPercussion) then
			soundFile = soundFile .. '\\' .. noteName
		end
		soundFiles[i] = soundFile .. ".ogg"
	end

	if #soundFiles == 1 then
		return soundFiles[1], instrumentData, soundFiles
	end

	local soundFile
	if instrumentData.keyMod ~= nil then
		soundFile = soundFiles[(key - instrumentData.keyMod) % #soundFiles + 1]
	else
		soundFile = soundFiles[instrumentData.rr]
	end

	return soundFile, instrumentData, soundFiles
end

--- Start playing a note
-- Returns true if sound will actually be played, sound handle and instrument data
-- @param instrument (int|string|table) MIDI instrument index, instrument name or instrument data
-- @param key (int)
-- @return willPlay (boolean)
-- @return soundHandle (int)
function Musician.Sampler.PlayNote(instrument, key)
	local soundFile, instrumentData = Musician.Sampler.GetSoundFile(instrument, key)
	local sampleId = Musician.Sampler.GetSampleId(instrumentData, key)
	local play, handle = false

	if not(Musician.Preloader.IsPreloaded(sampleId)) then
		play, handle = true, 0 -- Silent note
	elseif soundFile then
		play, handle = Musician.Sampler.PlaySoundFile(soundFile, 'SFX')

		-- Increment instrument round robin
		if play and instrumentData.pathList ~= nil then
			if instrumentData.rr >= #instrumentData.pathList then
				instrumentData.rr = 1
			else
				instrumentData.rr = instrumentData.rr + 1
			end
		end

		if play and handle then
			notesOn[handle] = { instrumentData.decay }
		end
	end

	return play, handle
end

--- Stop playing note
-- @param handle (int) The note handle returned by PlayNote()
-- @param [decay (number)] Override instrument decay
function Musician.Sampler.StopNote(handle, decay)
	if not(notesOn[handle]) then
		return
	end

	if decay == nil then
		decay = unpack(notesOn[handle])
	end

	StopSound(handle, decay)

	notesOn[handle] = nil
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

--- Safely play a sound file, even if the sound file does not exist.
-- @param soundFile (string)
-- @param channel (string)
-- @return willPlay (boolean)
-- @return soundHandle (int)
function Musician.Sampler.PlaySoundFile(soundFile, channel)
	local willPlay, soundHandle
	pcall(function()
		willPlay, soundHandle = PlaySoundFile(soundFile, channel)
	end)
	return willPlay, soundHandle
end