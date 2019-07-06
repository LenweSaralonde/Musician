Musician.Live = LibStub("AceAddon-3.0"):NewAddon("Musician.Live", "AceEvent-3.0")

local MODULE_NAME = "Live"
Musician.AddModule(MODULE_NAME)

local STREAM_PADDING = 10 -- Number of seconds to wait before ending streaming without activity

Musician.Live.NotesOn = {}
Musician.Live.songStartTime = nil
Musician.Live.InstrumentTrackMapping = {}
Musician.Live.enabled = true

local NOTE = Musician.Song.Indexes.NOTE

local CHUNK_DURATION = 1

local streamingStartTimer
local isPlayingLive = false
local playingLiveTimer

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

--- Indicates whenever the player is playing live, regardless if in solo or live mode
-- @return (boolean)
function Musician.Live.IsPlayingLive()
	return isPlayingLive
end

--- Indicates whenever the live mode can stream
-- @return (boolean)
function Musician.Live.CanStream()
	-- Communication not yet ready
	if not(Musician.Comm.CanBroadcast()) then
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
	song.name = Musician.Msg.LIVE_SONG_NAME

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

	local track = Musician.streamingSong.tracks[trackId]

	table.insert(track.notes, {
		[NOTE.ON] = noteOn,
		[NOTE.KEY] = key,
		[NOTE.TIME] = noteTime
	})

	-- Update song bounds
	Musician.streamingSong.cropTo = noteTime + STREAM_PADDING
	Musician.streamingSong.duration = noteTime + STREAM_PADDING

	-- Send visual note event
	if noteOn then
		Musician:SendMessage(Musician.Events.VisualNoteOn, Musician.streamingSong, track, key)
	else
		Musician:SendMessage(Musician.Events.VisualNoteOff, Musician.streamingSong, track, key)
	end
end

--- Send note on
-- @param key (int) MIDI key index
-- @param layer (int)
-- @param instrument (int)
-- @param isChordNote (boolean)
function Musician.Live.NoteOn(key, layer, instrument, isChordNote)

	local soundFile, instrumentData = Musician.Utils.GetSoundFile(instrument, key)
	if soundFile == nil then
		return
	end

	local noteOnKey = key .. '-' .. layer .. '-' .. instrument

	-- This is an auto-chord note but a higher priority note actually exists: do nothing
	if isChordNote and Musician.Live.NotesOn[noteOnKey] and not(Musician.Live.NotesOn[noteOnKey].isChordNote) then
		return
	end

	isPlayingLive = true
	if playingLiveTimer then
		playingLiveTimer:Cancel()
	end

	-- Play note
	local handle
	if Musician.globalMute then
		handle = 0
	else
		_, handle = Musician.Utils.PlaySoundFile(soundFile, 'SFX')
	end

	-- Insert note on and trigger event
	Musician.Live.InsertNote(true, key, layer, instrument)
	Musician.Live.NotesOn[noteOnKey] = { handle, instrumentData.decay, layer, key, instrumentData.midi, isChordNote }
	Musician.Comm:SendMessage(Musician.Events.LiveNoteOn, key, layer, instrumentData, isChordNote)
end

--- Send note off
-- @param key (int) MIDI key index
-- @param layer (int)
-- @param instrument (int)
-- @param isChordNote (boolean)
function Musician.Live.NoteOff(key, layer, instrument, isChordNote)

	local noteOnKey = key .. '-' .. layer .. '-' .. instrument
	if Musician.Live.NotesOn[noteOnKey] then
		local handle, decay, _, _, _, noteOnIsChordNote = unpack(Musician.Live.NotesOn[noteOnKey])

		-- If current note off is from an auto-chord but actual note is not: do nothing
		if isChordNote and not(noteOnIsChordNote) then
			return
		end

		if playingLiveTimer then
			playingLiveTimer:Cancel()
		end
		playingLiveTimer = C_Timer.NewTimer(STREAM_PADDING, function()
			isPlayingLive = false
			playingLiveTimer = nil
		end)

		-- Stop playing note
		if handle then
			StopSound(handle, decay)
		end

		-- Insert note off and trigger event
		Musician.Live.InsertNote(false, key, layer, instrument)
		Musician.Live.NotesOn[noteOnKey] = nil
		Musician.Comm:SendMessage(Musician.Events.LiveNoteOff, key, layer, isChordNote)
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
