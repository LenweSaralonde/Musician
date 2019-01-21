Musician.Live = LibStub("AceAddon-3.0"):NewAddon("Musician.Live", "AceEvent-3.0")

local STREAM_PADDING = 10 -- Number of seconds to wait before ending streaming without activity

Musician.Live.NotesOn = {}
Musician.Live.songStartTime = nil
Musician.Live.InstrumentTrackMapping = {}
Musician.Live.enabled = true

local NOTE = Musician.Song.Indexes.NOTE

local CHUNK_DURATION = 1

local streamingStartTimer

--- Init live mode
--
function Musician.Live.Init()
	-- Build instrument ID => track ID mapping table
	local instrumentName, trackId, instrumentId

	trackId = 1
	for _, layerId in pairs(Musician.KEYBOARD_LAYER) do
		Musician.Live.InstrumentTrackMapping[layerId] = {}
		for _, instrumentName in pairs(Musician.INSTRUMENTS_AVAILABLE) do
			instrumentId = Musician.INSTRUMENTS[instrumentName].midi
			if instrumentId >= 0 then
				Musician.Live.InstrumentTrackMapping[layerId][instrumentId] = trackId
				trackId = trackId + 1
			end
		end
	end
end

--- Enable or disable live mode
-- @param enable (boolean)
function Musician.Live.Enable(enabled)
	Musician.Live.enabled = enabled
end

--- Indicates whenever the live mode is enabled stream
-- @return (boolean)
function Musician.Live.IsEnabled()
	return Musician.Live.enabled
end

--- Indicates whenever the live mode can stream
-- @return (boolean)
function Musician.Live.CanStream()
	-- Communication not yet ready
	if not(Musician.Comm.isReady()) then
		return false
	end

	-- Actually streaming a song that is not a live song
	if Musician.streamingSong and Musician.streamingSong.streaming and Musician.streamingSong.mode ~= Musician.Song.MODE_LIVE then
		return false
	end

	return true
end

--- Create the live song for streaming, if needed
--
function Musician.Live.CreateLiveSong()

	-- Live song already created
	if Musician.streamingSong and (Musician.streamingSong.streaming or streamingStartTimer) then
		return
	end

	-- Create song instance
	local song = Musician.Song.create()
	song.mode = Musician.Song.MODE_LIVE
	song.chunkDuration = CHUNK_DURATION

	-- Create one track per instrument and per layer
	local trackId, layerId, instrumentId
	trackId = 1
	for _, layerId in pairs(Musician.KEYBOARD_LAYER) do
		for _, instrumentName in pairs(Musician.INSTRUMENTS_AVAILABLE) do
			instrumentId = Musician.INSTRUMENTS[instrumentName].midi
			if instrumentId >= 0 then
				local track = {
					['index'] = trackId,
					['midiInstrument'] = min(128, instrumentId),
					['instrument'] = instrumentId,
					['notes'] = {},
					['playIndex'] = 1,
					['muted'] = false,
					['solo'] = false,
					['transpose'] = 0,
					['notesOn'] = {},
					['polyphony'] = 0
				}
				trackId = trackId + 1
				table.insert(song.tracks, track)
			end
		end
	end

	-- Initialize start time
	Musician.Live.songStartTime = GetTime()

	song.cropTo = STREAM_PADDING
	song.duration = STREAM_PADDING

	Musician.streamingSong = song

	-- Start streaming!
	if streamingStartTimer then
		streamingStartTimer:Cancel()
	end

	streamingStartTimer = C_Timer.NewTimer(CHUNK_DURATION * 1.05, function()
		Musician.streamingSong:Stream()
		streamingStartTimer = nil
	end)
end

--- Send note
-- @param noteOn (boolean) Note on/off
-- @param key (int) MIDI key index
-- @param layer (int)
-- @param instrument (int)
function Musician.Live.InsertNote(noteOn, key, layer, instrument)

	-- Do nothing if live mode is not enabled or can't stream
	if not(Musician.Live.CanStream()) or not(Musician.Live.IsEnabled()) then
		return
	end

	Musician.Live.CreateLiveSong()

	-- Insert note in track
	local trackId = Musician.Live.InstrumentTrackMapping[layer][instrument]
	local noteTime = GetTime() - Musician.Live.songStartTime

	if trackId == nil then
		return
	end

	table.insert(Musician.streamingSong.tracks[trackId].notes, {
		[NOTE.ON] = noteOn,
		[NOTE.KEY] = key,
		[NOTE.TIME] = noteTime
	})

	-- Update song bounds
	Musician.streamingSong.cropTo = noteTime + STREAM_PADDING
	Musician.streamingSong.duration = noteTime + STREAM_PADDING
end

--- Send note on
-- @param key (int) MIDI key index
-- @param layer (int)
-- @param instrument (int)
function Musician.Live.NoteOn(key, layer, instrument)

	local soundFile, instrumentData = Musician.Utils.GetSoundFile(instrument, key)
	if soundFile == nil then
		return
	end

	-- Insert note on in streaming song
	Musician.Live.InsertNote(true, key, layer, instrument)

	-- Play note
	if Musician.globalMute then
		return
	end

	local play, handle = PlaySoundFile(soundFile, 'SFX')

	if play then
		Musician.Live.NotesOn[key .. '-' .. layer .. '-' .. instrument] = {handle, instrumentData.decay, layer, key, instrumentData.midi}
	end
end

--- Send note off
-- @param key (int) MIDI key index
-- @param layer (int)
-- @param instrument (int)
function Musician.Live.NoteOff(key, layer, instrument)

	-- Insert note off in streaming song
	Musician.Live.InsertNote(false, key, layer, instrument)

	local noteOnKey = key .. '-' .. layer .. '-' .. instrument
	if Musician.Live.NotesOn[noteOnKey] then
		local handle, decay, _, _, _ = unpack(Musician.Live.NotesOn[noteOnKey])
		StopSound(handle, decay)
		Musician.Live.NotesOn[noteOnKey] = nil
	end
end

--- Set all notes to off
-- @param onlyForLayer (int)
function Musician.Live.AllNotesOff(onlyForLayer)
	local noteOnKey, note
	for noteOnKey, note in pairs(Musician.Live.NotesOn) do
		local _, _, layer, key, instrument = unpack(note)

		if onlyForLayer == nil or onlyForLayer == layer then
			Musician.Live.NoteOff(key, layer, instrument)
		end
	end
end
