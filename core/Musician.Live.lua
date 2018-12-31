Musician.Live = LibStub("AceAddon-3.0"):NewAddon("Musician.Live", "AceEvent-3.0")

local STREAM_PADDING = 10 -- Number of seconds to wait before ending streaming without activity

Musician.Live.NotesOn = {}
Musician.Live.songStartTime = nil
Musician.Live.InstrumentTrackMapping = {}

local NOTE = Musician.Song.Indexes.NOTE

local CHUNK_DURATION = 1

local streamingStartTimer

function Musician.Live.Init()
	-- Build instrument ID => track ID mapping table
	local instrumentName, trackId, instrumentId

	trackId = 1
	for _, instrumentName in pairs(Musician.INSTRUMENTS_AVAILABLE) do
		instrumentId = Musician.INSTRUMENTS[instrumentName].midi
		if instrumentId >= 0 then
			Musician.Live.InstrumentTrackMapping[instrumentId] = trackId
			trackId = trackId + 1
		end
	end
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

	-- Create one track per instrument
	local trackId, instrumentId
	trackId = 1
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
-- @param instrument (int)
function Musician.Live.InsertNote(noteOn, key, instrument)

	Musician.Live.CreateLiveSong()

	-- No live streaming song
	if not(Musician.streamingSong) or Musician.streamingSong.mode ~= Musician.Song.MODE_LIVE then
		return
	end

	-- Insert note in track
	local trackId = Musician.Live.InstrumentTrackMapping[instrument]
	local noteTime = GetTime() - Musician.Live.songStartTime

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
-- @param instrument (int)
function Musician.Live.NoteOn(key, instrument)

	local soundFile, instrumentData = Musician.Utils.GetSoundFile(instrument, key)
	if soundFile == nil then
		return
	end

	-- Insert note on in streaming song
	Musician.Live.InsertNote(true, key, instrument)

	-- Play note
	if Musician.globalMute then
		return
	end

	local play, handle = PlaySoundFile(soundFile, 'SFX')

	if play then
		Musician.Live.NotesOn[key .. '-' .. instrument] = {handle, instrumentData.decay, instrumentData.midi}
	end
end

--- Send note off
-- @param key (int) MIDI key index
-- @param instrument (int)
function Musician.Live.NoteOff(key, instrument)

	-- Insert note off in streaming song
	Musician.Live.InsertNote(false, key, instrument)
	
	local noteOnKey = key .. '-' .. instrument
	if Musician.Live.NotesOn[noteOnKey] then
		local handle, decay, instrumentId = unpack(Musician.Live.NotesOn[noteOnKey])
		StopSound(handle, decay)
		Musician.Live.NotesOn[noteOnKey] = nil
	end

end
