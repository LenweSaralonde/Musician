--- Song class
-- @module Musician.Song

Musician.Song = LibStub("AceAddon-3.0"):NewAddon("Musician.Song", "AceEvent-3.0")

local MODULE_NAME = "Song"
Musician.AddModule(MODULE_NAME)

LibCRC32 = LibStub:GetLibrary("LibCRC32")

Musician.Song.__index = Musician.Song

Musician.Song.Indexes = {}

Musician.Song.Indexes.NOTE = {}
Musician.Song.Indexes.NOTE.ON = 1
Musician.Song.Indexes.NOTE.KEY = 2
Musician.Song.Indexes.NOTE.TIME = 3
Musician.Song.Indexes.NOTE.DURATION = 4

Musician.Song.Indexes.NOTEON = {}
Musician.Song.Indexes.NOTEON.TIME = 1
Musician.Song.Indexes.NOTEON.ENDTIME = 2
Musician.Song.Indexes.NOTEON.HANDLE = 3

Musician.Song.Indexes.CHUNK = {}
Musician.Song.Indexes.CHUNK.SONG_ID = 1
Musician.Song.Indexes.CHUNK.TRACK_ID = 2
Musician.Song.Indexes.CHUNK.INSTRUMENT = 3
Musician.Song.Indexes.CHUNK.NOTES = 4
Musician.Song.Indexes.CHUNK.NOTE_COUNT = 5

local NOTE = Musician.Song.Indexes.NOTE
local NOTEON = Musician.Song.Indexes.NOTEON
local CHUNK = Musician.Song.Indexes.CHUNK

Musician.Song.MODE_DURATION = 0x10 -- Duration are set in chunk notes
Musician.Song.MODE_LIVE = 0x20 -- No duration in chunk notes

local CHUNK_VERSION = 0x01 -- Max: 0x0F (15)

--- Song class
-- @type Musician.Song
function Musician.Song.create()
	local self = {}
	setmetatable(self, Musician.Song)

	-- @field id (int) Song ID, used for streaming
	self.id = nil

	-- @field crc32 (int) CRC32 of imported song data
	self.crc32 = nil

	-- @field tracks (table) Song tracks, including instrument and notes
	self.tracks = {}

	-- @field duration (float) Song duration in seconds
	self.duration = 0

	-- @field name (string) Song title
	self.name = nil

	-- @field player (string) Player name, with realm slug
	self.player = nil

	-- @field notified (boolean) True when the notification for the song playing has been displayed
	self.notified = false

	-- @field playing (boolean) True when the song is playing
	self.playing = false

	-- @field streaming (boolean) True when the song is streaming
	self.streaming = false

	-- @field importing (boolean) True when the song is being imported
	self.importing = false

	-- @field chunkDuration (number) Duration of a streaming chunk, in seconds
	self.chunkDuration = Musician.CHUNK_DURATION

	-- @field mode (int) Song mode
	self.mode = Musician.Song.MODE_DURATION

	-- @field cropFrom (number) Play song from this position
	self.cropFrom = 0

	-- @field cropTo (number) Play song until this position
	self.cropTo = 0

	-- @field cursor (number) Cursor position, in seconds
	self.cursor = 0

	-- @field soloTracks (int) Number of tracks in solo
	self.soloTracks = 0

	-- @field polyphony (int) Current polyphony
	self.polyphony = 0

	-- @field drops (int) Dropped notes
	self.drops = 0

	return self
end

--- Return song ID
-- @return songId (int)
function Musician.Song:GetId()
	if self.songId == nil then
		self.songId = Musician_Settings.nextSongId
		Musician_Settings.nextSongId = (Musician_Settings.nextSongId + 1) % 256
	end

	return self.songId
end

--- Return true if the song is playing or about to be played (preloading).
-- @return isPlaying (boolean)
function Musician.Song:IsPlaying()
	return self.playing or self.willPlayTimer ~= nil
end

--- Return playing progression
-- @return progression (number)
function Musician.Song:GetProgression()
	if not(self.playing) then
		return nil
	end
	local duration = self.cropTo - self.cropFrom
	local position = self.cursor - self.cropFrom
	return position / duration
end

--- Mute or unmute track
-- @param track (table)
-- @param isMuted (boolean)
function Musician.Song:SetTrackMuted(track, isMuted)
	if isMuted then
		self:TrackNotesOff(track, true)
	end

	track.muted = isMuted
end

--- Return true if the track is muted
-- @param track (table)
-- @return isMuted (boolean)
function Musician.Song:TrackIsMuted(track)
	return track.muted or self.soloTracks > 0 and not(track.solo)
end

--- Set/unset track solo
-- @param track (table)
-- @param isSolo (boolean)
function Musician.Song:SetTrackSolo(track, isSolo)
	if track.solo and not(isSolo) then
		track.solo = false
		self.soloTracks = self.soloTracks - 1
	elseif not(track.solo) and isSolo then
		track.solo = true
		self.soloTracks = self.soloTracks + 1
		local track
		for _, track in pairs(self.tracks) do
			if self:TrackIsMuted(track) then
				self:TrackNotesOff(track, true)
			end
		end
	end
end

--- Play song
-- @param delay (number) Delay in seconds to wait before playing the song
function Musician.Song:Play(delay)
	self:Reset()

	if delay then
		self.willPlayTimer = C_Timer.NewTimer(delay, function()
			self:Resume(true)
			self.willPlayTimer = nil
		end)
		Musician.Utils.MuteGameMusic()
		Musician.Song:SendMessage(Musician.Events.SongPlay, self)
	else
		self:Resume()
	end
end

--- Reset song to initial position
function Musician.Song:Reset()
	self:SongNotesOff()
	self:Seek(self.cropFrom)
end

--- Seek to position
-- @param cursor (number)
function Musician.Song:Seek(cursor)

	--- Perform seek within track
	-- @param cursor (number) Position to reach
	-- @param track (table)
	local trackSeek = function(cursor, track)
		local noteCount = #track.notes

		if noteCount == 0 then
			return
		end

		-- Cursor is before the first note
		if cursor <= track.notes[1][NOTE.TIME] then
			track.playIndex = 1
			return
			-- Cursor is after the last note
		elseif cursor > track.notes[noteCount][NOTE.TIME] then
			track.playIndex = noteCount + 1
			return
		end

		local from = 1
		local to = noteCount
		local index = max(1, min(noteCount, track.playIndex))

		if cursor <= track.notes[index][NOTE.TIME] then
			to = index
		else
			from = index
		end

		local found = false
		while not(found) do
			index = from + floor((to - from) / 2 + .5)

			-- Exact position found! Find first note at exact position
			while index >= 1 and track.notes[index][NOTE.TIME] == cursor do
				found = true
				index = index - 1
			end

			if found then
				track.playIndex = index + 1
				return
			end

			-- In-between position found
			if cursor > track.notes[index - 1][NOTE.TIME] and cursor <= track.notes[index][NOTE.TIME] then
				track.playIndex = index
				return
			end

			-- Seek before
			if cursor < track.notes[index][NOTE.TIME ] then
				to = index
				-- Seek after
			else
				from = index
			end
		end
	end

	cursor = max(0, min(cursor, self.duration))

	if cursor == self.cursor then
		return
	end

	self:SongNotesOff()

	local track
	for _, track in pairs(self.tracks) do
		trackSeek(cursor, track)
	end

	self.cursor = cursor
	Musician.Song:SendMessage(Musician.Events.SongCursor, self)
end

--- Resume a song playing
-- @param eventSent (boolean)
function Musician.Song:Resume(eventSent)
	self.playing = true
	if not(eventSent) then
		Musician.Song:SendMessage(Musician.Events.SongPlay, self)
	end
end

--- Stop song
function Musician.Song:Stop()
	self:SongNotesOff()
	if self.willPlayTimer then
		self.willPlayTimer:Cancel()
		self.willPlayTimer = nil
	end
	if self.playing then
		self.playing = false
		Musician.Utils.MuteGameMusic()
		Musician.Song:SendMessage(Musician.Events.SongStop, self)
	end
end

--- Main on frame update function
-- @param elapsed (number)
function Musician.Song:OnUpdate(elapsed)
	self:ImportOnFrame(elapsed)
	self:StreamOnFrame(elapsed)
	self:PlayOnFrame(elapsed)
end

--- Play notes accordingly to every frame.
-- @param elapsed (number)
function Musician.Song:PlayOnFrame(elapsed)
	if not(self.playing) then
		return
	end

	local drops = 0
	local from = self.cursor
	local to = self.cursor + elapsed
	self.cursor = to

	local track
	for _, track in pairs(self.tracks) do
		-- Notes On and Notes Off
		while track.notes[track.playIndex] and (track.notes[track.playIndex][NOTE.TIME] < to) do
			if track.notes[track.playIndex][NOTE.TIME] >= from then
				if track.notes[track.playIndex][NOTE.ON] then
					-- Note On
					if elapsed < 1 then -- Do not play notes if frame is longer than 1 s (after loading screen) to avoid slowdowns
						self:NoteOn(track, track.playIndex)
					end
				else
					-- Note Off
					self:NoteOff(track, track.notes[track.playIndex][NOTE.KEY])
				end
			else -- Note dropped due to lag
				drops = drops + 1
			end
			track.playIndex = track.playIndex + 1
		end

		-- Stop expired notes currently playing
		local noteIndex, noteOn
		for noteIndex, noteOn in pairs(track.notesOn) do
			if noteOn[NOTEON.ENDTIME] ~= nil and noteOn[NOTEON.ENDTIME] < to then -- Off time is in the past
				self:NoteOff(track, noteIndex)
			end
		end

	end

	Musician.Song:SendMessage(Musician.Events.SongCursor, self)

	-- Dropped notes
	if drops > 0 then
		self.drops = self.drops + drops
		Musician.Song:SendMessage(Musician.Events.NoteDropped, self, self.drops, drops)
	end

	-- Song has ended
	if to >= self.cropTo then
		self:Stop()
	end
end

--- Play a note
-- @param track (table) Reference to the track
-- @param noteIndex (int) Note index
-- @param retries (int) Number of attempts to recover dropped notes
function Musician.Song:NoteOn(track, noteIndex, retries)
	local key = track.notes[noteIndex][NOTE.KEY] + track.transpose
	local time = track.notes[noteIndex][NOTE.TIME]
	local duration = track.notes[noteIndex][NOTE.DURATION]
	local soundFile, instrumentData = Musician.Sampler.GetSoundFile(track.instrument, key)
	local playerIsInRange = self.player ~= nil and Musician.Registry.PlayerIsInRange(self.player)
	if soundFile == nil then
		return
	end

	-- Send notification emote
	if playerIsInRange and not(self.notified) then
		Musician.Utils.DisplayEmote(self.player, Musician.Registry.GetPlayerGUID(self.player), Musician.Msg.EMOTE_PLAYING_MUSIC)
		self.notified = true
	end

	-- Don't play back my own live notes
	if Musician.Utils.PlayerIsMyself(self.player) and self.mode == Musician.Song.MODE_LIVE then
		return
	end

	-- Don't play back other player's live notes
	if Musician.Live.IsPlayerSynced(self.player) and self.mode == Musician.Song.MODE_LIVE then
		return
	end

	local shouldPlay = true

	-- Do not play note if the source song is playing or if the player is out of range
	local sourceSongIsPlaying = Musician.sourceSong ~= nil and Musician.sourceSong:IsPlaying()
	if self.player ~= nil and (sourceSongIsPlaying or not(playerIsInRange)) or self:TrackIsMuted(track) or Musician.globalMute or Musician.PlayerIsMuted(self.player) then
		shouldPlay = false
	end

	-- The note cannot be already playing on the same track
	self:NoteOff(track, key)

	-- Play note sound file
	local play, handle
	if shouldPlay then
		play, handle = Musician.Sampler.PlayNote(track.instrument, key)

		-- Note dropped: interrupt the oldest one and retry
		retries = retries or 0
		if not(play) and retries < 2 then
			self:StopOldestNote()
			C_Timer.After(0, function()
				self:NoteOn(track, noteIndex, retries + 1)
			end)
			return
		end
	end

	-- Add note to notesOn with sound handle and note off time
	local endTime = nil
	if duration ~= nil then
		endTime = self.cursor + duration
	end

	track.notesOn[key] = {
		[NOTEON.TIME] = time,
		[NOTEON.ENDTIME] = endTime,
		[NOTEON.HANDLE] = play and handle or 0
	}

	if play then
		track.polyphony = track.polyphony + 1
		self.polyphony = self.polyphony + 1
		Musician.Song:SendMessage(Musician.Events.NoteOn, self, track, key)
	end

	Musician.Song:SendMessage(Musician.Events.VisualNoteOn, self, track, key, play)
end

--- Stop a note of a track
-- @param track (table) Reference to the track
-- @param key (int) Note key
-- @param keepVisual (boolean)
-- @param [decay (number)] Override instrument decay
function Musician.Song:NoteOff(track, key, keepVisual, decay)
	if track.notesOn[key] ~= nil then
		local handle = track.notesOn[key][NOTEON.HANDLE]
		if handle ~= 0 then
			Musician.Sampler.StopNote(handle, decay)
			track.polyphony = track.polyphony - 1
			self.polyphony = self.polyphony - 1
		end
		Musician.Song:SendMessage(Musician.Events.NoteOff, self, track, key)

		if keepVisual then
			track.notesOn[key][NOTEON.HANDLE] = 0
		else
			track.notesOn[key] = nil
			Musician.Song:SendMessage(Musician.Events.VisualNoteOff, self, track, key)
		end
	end
end

--- Stop all notes of a track
-- @param track (table) Reference to the track
-- @param keepVisual (boolean)
function Musician.Song:TrackNotesOff(track, keepVisual)
	local noteKey, noteOn
	for noteKey, noteOn in pairs(track.notesOn) do
		self:NoteOff(track, noteKey, keepVisual)
	end
end

--- Stop all notes of the song
function Musician.Song:SongNotesOff()
	local track
	for _, track in pairs(self.tracks) do
		self:TrackNotesOff(track)
	end
end

--- Stop the oldest note still playing
function Musician.Song:StopOldestNote()
	local foundTrack, foundNoteKey
	local track
	for _, track in pairs(self.tracks) do
		local noteKey, noteOn
		for noteKey, noteOn in pairs(track.notesOn) do
			if foundNoteKey == nil or track.notesOn[noteKey][NOTE.TIME] < foundTrack.notesOn[foundNoteKey][NOTE.TIME] then
				foundTrack = track
				foundNoteKey = noteKey
			end
		end
	end

	if foundNoteKey ~= nil then
		self:NoteOff(foundTrack, foundNoteKey, false, 0) -- Remove decay
	end
end

--- Import song from a base 64 string
-- @param str (string)
-- @param crop (boolean)
function Musician.Song:Import(str, crop)
	if self.importing then
		error("The song is already importing.")
	end

	self.import = {}
	local import = self.import

	import.step = 1

	import.encodedData = str
	import.data = ''
	import.cursor = 1
	import.progression = 0
	import.crop = crop
	import.chunksCrc32 = nil

	self.importing = true

	Musician.Song:SendMessage(Musician.Events.SongImportStart, self)
	Musician.Song:SendMessage(Musician.Events.SongImportProgress, self, import.progression)
end

--- Advance the song importing process on frame
-- @param elapsed (number)
function Musician.Song:ImportOnFrame(elapsed)

	if not(self.importing) then
		return
	end

	local success = pcall(function()
		self:ImportStep(elapsed)
	end)

	-- Abort import on error
	if not(success) then
		Musician.Utils.Error(Musician.Msg.INVALID_MUSIC_CODE)
		self.importing = false
		Musician.Song:SendMessage(Musician.Events.SongImportComplete, self)
		Musician.Song:SendMessage(Musician.Events.SongImportFailed, self)
	end
end

--- Run a step of importing process
-- @param elapsed (number)
function Musician.Song:ImportStep(elapsed)

	local import = self.import

	local MAX_NOTE_TIME = 65535 / Musician.NOTE_TIME_FPS -- 16-bit
	local BASE64DECODE_PROGRESSION_RATIO = .75
	local NOTE_PROGRESSION_RATIO = .25
	local PROCESS_FRAME_TIME_RATIO = .5

	local advanceCursor = function(bytes, updateCrc32)
		import.cursor = import.cursor + bytes
		if import.cursor > #import.data + 1 then
			error(Musician.Msg.INVALID_MUSIC_CODE)
		elseif updateCrc32 then
			local chunk = string.sub(import.data, import.cursor - bytes, import.cursor - 1)
			import.chunksCrc32 = LibCRC32:hashChunk(chunk, import.chunksCrc32)
		end
	end

	local elapsedMs = min(1/60, elapsed) * 1000


	-- Step 1 : Decode base64 string
	-- =============================

	if import.step == 1 then

		-- Decode base64 chunk
		local chunksToImport = floor(Musician.IMPORT_CONVERT_RATE * elapsedMs * PROCESS_FRAME_TIME_RATIO / 4)
		local from = import.cursor
		local to = min(#import.encodedData, import.cursor + chunksToImport * 4 - 1)

		import.data = import.data .. Musician.Utils.Base64Decode(string.sub(import.encodedData, from, to))
		import.cursor = to + 1

		-- Update progression
		import.progression = BASE64DECODE_PROGRESSION_RATIO * to / #import.encodedData
		Musician.Song:SendMessage(Musician.Events.SongImportProgress, self, import.progression)

		-- Base 64 decoding is complete
		if to == #import.encodedData then
			-- Advance to step 2
			import.step = 2
			import.encodedData = nil
			import.cursor = 1
		end

		return
	end


	-- Step 2 : Import song header
	-- ===========================

	if import.step == 2 then

		import.noteCount = 0

		-- Header (4)
		if string.sub(import.data, import.cursor, import.cursor + 3) ~= Musician.FILE_HEADER then
			error(Musician.Msg.INVALID_MUSIC_CODE)
		end
		advanceCursor(4)

		-- Duration (3)
		self.duration = Musician.Utils.UnpackNumber(string.sub(import.data, import.cursor, import.cursor + 2))
		self.cropFrom = 0
		self.cropTo = self.duration
		advanceCursor(3, true)

		-- Number of tracks (1)
		local trackCount = Musician.Utils.UnpackNumber(string.sub(import.data, import.cursor, import.cursor))
		advanceCursor(1, true)

		-- Track information: instrument (1), channel (1), number of notes (2)
		local track, trackIndex
		self.tracks = {}
		for trackIndex = 1, trackCount do
			local track = {}

			-- Instrument (1)
			track.instrument = Musician.Utils.UnpackNumber(string.sub(import.data, import.cursor, import.cursor))
			track.midiInstrument = min(128, track.instrument) -- Handle the metal drumkit that has Musician ID 129 but MIDI ID 128
			advanceCursor(1)

			-- Channel (1)
			track.channel = Musician.Utils.UnpackNumber(string.sub(import.data, import.cursor, import.cursor))
			advanceCursor(1)

			-- Note count (2)
			track.noteCount = Musician.Utils.UnpackNumber(string.sub(import.data, import.cursor, import.cursor + 1))
			import.noteCount = import.noteCount + track.noteCount
			advanceCursor(2, true)

			-- Track index
			track.index = trackIndex

			-- Track notes
			track.notes = {}

			-- Current playing note index
			track.playIndex = 1

			-- Track is muted
			track.muted = (track.noteCount == 0)

			-- Track is solo
			track.solo = false

			-- Track transposition
			track.transpose = 0

			-- Notes currently playing
			track.notesOn = {}

			-- Polyphony
			track.polyphony = 0

			-- Track name
			track.name = nil

			-- Insert track
			table.insert(self.tracks, track)
		end

		-- Update progression
		import.progression = BASE64DECODE_PROGRESSION_RATIO + NOTE_PROGRESSION_RATIO * 1 / (import.noteCount + 2)
		Musician.Song:SendMessage(Musician.Events.SongImportProgress, self, import.progression)

		-- Advance to step 3
		import.step = 3
		import.importedNotes = 0
		import.trackIndex = 1
		import.trackOffset = 0
		import.noteIndex = 1

		return
	end


	-- Step 3 : Import notes
	-- =====================

	if import.step == 3 then

		-- Import notes
		local notesToImport = floor(Musician.IMPORT_NOTE_RATE * elapsedMs * PROCESS_FRAME_TIME_RATIO)
		local stopOnNoteCount = min(import.importedNotes + notesToImport, import.noteCount)
		while import.importedNotes < stopOnNoteCount do

			local track = self.tracks[import.trackIndex]

			-- Ignore empty tracks
			while track.noteCount == 0 do
				import.trackIndex = import.trackIndex + 1
				track = self.tracks[import.trackIndex]
			end

			-- Key (1)
			local key = Musician.Utils.UnpackNumber(string.sub(import.data, import.cursor, import.cursor))
			advanceCursor(1, true)

			-- This is a spacer (key 0xFF)
			if key == 0xFF then
				import.trackOffset = import.trackOffset + MAX_NOTE_TIME
			else
				-- Note on with duration

				-- Time (2)
				local time = import.trackOffset + Musician.Utils.UnpackTime(string.sub(import.data, import.cursor, import.cursor + 1), Musician.NOTE_TIME_FPS)
				advanceCursor(2, true)

				-- Duration (1)
				local duration = Musician.Utils.UnpackTime(string.sub(import.data, import.cursor, import.cursor), Musician.NOTE_DURATION_FPS)
				advanceCursor(1, true)

				-- Insert note
				table.insert(track.notes, {
					[NOTE.ON] = true,
					[NOTE.KEY] = key,
					[NOTE.TIME] = time,
					[NOTE.DURATION] = duration
				})

				import.importedNotes = import.importedNotes + 1

				-- Track import complete
				if import.noteIndex == track.noteCount then
					track.noteCount = nil -- We don't need this information anymore

					-- Proceed with next track
					import.trackIndex = import.trackIndex + 1
					import.trackOffset = 0
					import.noteIndex = 1
				else
					import.noteIndex = import.noteIndex + 1
				end
			end

		end

		-- All notes have been imported
		if import.importedNotes == import.noteCount then
			import.step = 4
		end

		-- Update progression
		import.progression = BASE64DECODE_PROGRESSION_RATIO + NOTE_PROGRESSION_RATIO * (import.importedNotes + 1) / (import.noteCount + 2)
		Musician.Song:SendMessage(Musician.Events.SongImportProgress, self, import.progression)

		return
	end


	-- Step 4 : Import metadata
	-- ========================

	if import.step == 4 then

		-- Song title (2) + (title length in bytes)
		local songTitleLength = Musician.Utils.UnpackNumber(string.sub(import.data, import.cursor, import.cursor + 1))
		advanceCursor(2)
		self.name = string.sub(import.data, import.cursor, import.cursor + songTitleLength - 1)
		advanceCursor(songTitleLength)

		-- Track names (2) + (title length in bytes)
		for trackIndex, track in pairs(self.tracks) do
			local trackNameLength = Musician.Utils.UnpackNumber(string.sub(import.data, import.cursor, import.cursor + 1))
			advanceCursor(2)
			track.name = string.sub(import.data, import.cursor, import.cursor + trackNameLength - 1)
			advanceCursor(trackNameLength)
		end

		-- Crop song
		if import.crop then
			self.cropFrom = self.duration
			self.cropTo = 0
			for trackIndex, track in pairs(self.tracks) do
				if #track.notes > 0 then
					self.cropFrom = min(self.cropFrom, track.notes[1][NOTE.TIME])
					self.cropTo = max(self.cropTo, track.notes[#track.notes][NOTE.TIME] + track.notes[#track.notes][NOTE.DURATION])
				end
			end
		end
		self.cursor = self.cropFrom

		-- CRC32
		self.crc32 = LibCRC32:getFinalCrc(import.chunksCrc32)

		-- Update progression
		import.progression = 1
		Musician.Song:SendMessage(Musician.Events.SongImportProgress, self, import.progression)

		-- Import is complete!
		self.importing = false
		Musician.Song:SendMessage(Musician.Events.SongImportComplete, self)
		Musician.Song:SendMessage(Musician.Events.SongImportSucessful, self)
	end

end

--- Clone song
-- @return song (Musician.Song)
function Musician.Song:Clone()

	local song = Musician.Song.create()
	local key, value

	for key, value in pairs(self) do
		song[key] = Musician.Utils.DeepCopy(value)
	end
	return song
end

--- Stream song
function Musician.Song:Stream()
	self.playing = false
	self:StopStreaming() -- Stop and reset streaming
	self.streaming = true
	self.timeSinceLastStreamChunk = self.chunkDuration
	Musician.Song:SendMessage(Musician.Events.StreamStart, self)
end

--- Stop streaming song
function Musician.Song:StopStreaming()
	local wasStreaming = self.streaming

	self.streaming = false
	self.timeSinceLastStreamChunk = 0

	local track
	for _, track in pairs(self.tracks) do
		track.streamIndex = nil
	end

	self.streamPosition = self.cropFrom
	self.songId = nil

	if wasStreaming then
		Musician.Song:SendMessage(Musician.Events.StreamStop, self)
	end
end

--- Append chunk data to current song
-- @param chunk (table)
-- @param mode (number)
-- @param songId (number)
-- @param chunkDuration (number)
-- @param playtimeLeft (number)
-- @param player (string)
function Musician.Song:AppendChunk(chunk, mode, songId, chunkDuration, playtimeLeft, player)

	if self.chunkTime == nil then
		self.chunkTime = 0
	end

	self.isStreamed = true
	self.mode = mode
	self.songId = songId
	self.player = player
	self.chunkDuration = chunkDuration
	self.cropTo = max(self.cropTo, self.chunkTime + playtimeLeft)

	local trackData
	for _, trackData in pairs(chunk) do
		if self.tracks[trackData[CHUNK.TRACK_ID]] == nil then
			self.tracks[trackData[CHUNK.TRACK_ID]] = {
				['index'] = trackData[CHUNK.TRACK_ID],
				['midiInstrument'] = nil,
				['instrument'] = nil,
				['notes'] = {},
				['playIndex'] = 1,
				['muted'] = false,
				['solo'] = false,
				['transpose'] = 0,
				['notesOn'] = {},
				['polyphony'] = 0,
				['channel'] = nil,
				['name'] = nil
			}
		end

		local track = self.tracks[trackData[CHUNK.TRACK_ID]]

		-- Track instrument
		track.instrument = trackData[CHUNK.INSTRUMENT]
		track.midiInstrument = min(128, track.instrument) -- Handle the metal drumkit that has Musician ID 129 but MIDI ID 128

		-- The chunk has been received too late, after the current cursor position
		if self.cursor > self.chunkTime then
			-- Advance chunkTime accordingly to avoid note drops
			local advance = self.cursor + self.chunkDuration / 2 - self.chunkTime
			self.chunkTime = self.chunkTime + advance
			self.cropTo = self.cropTo + advance
		end

		local noteOffset = self.chunkTime
		local note
		for _, note in pairs(trackData[CHUNK.NOTES]) do
			note[NOTE.TIME] = note[NOTE.TIME] + noteOffset
			noteOffset = note[NOTE.TIME]
			self.cropTo = max(self.cropTo, note[NOTE.TIME] + (note[NOTE.DURATION] or 0))
			table.insert(track.notes, note)
		end
	end

	self.chunkTime = self.chunkTime + self.chunkDuration
end

--- Stream a chunk of the song on frame
-- @param elapsed (number)
function Musician.Song:StreamOnFrame(elapsed)

	if not(self.streaming) then
		return
	end

	self.timeSinceLastStreamChunk = self.timeSinceLastStreamChunk + elapsed

	if self.timeSinceLastStreamChunk >= self.chunkDuration then
		self.timeSinceLastStreamChunk = self.timeSinceLastStreamChunk - self.chunkDuration
	else
		return
	end

	local from = self.streamPosition
	local to = from	+ self.chunkDuration

	local chunk = {}

	local track
	for _, track in pairs(self.tracks) do
		if track.streamIndex == nil then
			track.streamIndex = 1
		end

		-- Notes On and Notes Off
		local notes = {}
		local noteOffset = from
		while track.notes[track.streamIndex] and (track.notes[track.streamIndex][NOTE.TIME] < to) and (track.notes[track.streamIndex][NOTE.TIME] <= self.cropTo) do

			if track.notes[track.streamIndex][NOTE.TIME] >= from then
				local note = Musician.Utils.DeepCopy(track.notes[track.streamIndex])

				if not(self:TrackIsMuted(track)) and Musician.MIDI_INSTRUMENT_MAPPING[track.instrument] ~= "none" then
					note[NOTE.KEY] = note[NOTE.KEY] + track.transpose

					local noteTimeRelative = note[NOTE.TIME] - noteOffset
					noteOffset = note[NOTE.TIME]
					note[NOTE.TIME] = noteTimeRelative

					if note[NOTE.DURATION] ~= nil then
						note[NOTE.DURATION] = note[NOTE.DURATION]
					end

					table.insert(notes, note)
				end
			end

			track.streamIndex = track.streamIndex + 1
		end

		if #notes > 0 then
			-- ID, instrument, notes
			table.insert(chunk, {
				[CHUNK.SONG_ID] = self.id,
				[CHUNK.TRACK_ID] = track.index,
				[CHUNK.INSTRUMENT] = track.instrument,
				[CHUNK.NOTE_COUNT] = #notes,
				[CHUNK.NOTES] = notes
			})
		end
	end

	self.streamPosition = to

	local player = Musician.Utils.NormalizePlayerName(UnitName("player"))
	local packedChunk = self:PackChunk(chunk)

	Musician.Comm.StreamSongChunk(packedChunk)

	if self.streamPosition >= self.cropTo then
		self:StopStreaming()
	end
end

--- Pack a song chunk
-- @param chunk (table)
-- @return data (string)
function Musician.Song:PackChunk(chunk)

	-- Chunk version and mode (1)
	local packedVersionAndMode = Musician.Utils.PackNumber(bit.bor(self.mode, CHUNK_VERSION), 1)

	-- Chunk duration (1)
	local packedChunkDuration = Musician.Utils.PackNumber(self.chunkDuration * 10, 1)

	-- Song ID (1)
	local packedSongId = Musician.Utils.PackNumber(self:GetId() % 256, 1)

	-- Playtime left (2)
	local playtimeLeft = ceil(self.cropTo - self.streamPosition + self.chunkDuration)
	local packedPlaytimeLeft = Musician.Utils.PackNumber(playtimeLeft, 2)

	-- Player position (18)
	local packedPlayerPosition = Musician.Utils.PackPlayerPosition()

	-- Number of tracks (1)
	local packedTrackCount = Musician.Utils.PackNumber(#chunk, 1)

	-- Track information: trackId (1), instrumentId (1), note count (2)
	local packedTrackInfo = ''
	local trackData
	for _, trackData in pairs(chunk) do
		packedTrackInfo = packedTrackInfo .. Musician.Utils.PackNumber(trackData[CHUNK.TRACK_ID], 1)
		packedTrackInfo = packedTrackInfo .. Musician.Utils.PackNumber(trackData[CHUNK.INSTRUMENT], 1)
		packedTrackInfo = packedTrackInfo .. Musician.Utils.PackNumber(#trackData[CHUNK.NOTES], 2)
	end

	-- Note information: key on/off or spacer (1), time (1), [duration (1)]
	local packedNoteData = ''
	local note
	for _, trackData in pairs(chunk) do
		for _, note in pairs(trackData[CHUNK.NOTES]) do

			-- Get note time relatively to previous note
			local noteTime = note[NOTE.TIME]

			-- Insert spacers if note time exceeds the maximum
			while noteTime > Musician.MAX_CHUNK_NOTE_TIME do
				packedNoteData = packedNoteData .. Musician.Utils.PackNumber(255, 1)
				noteTime = noteTime - Musician.MAX_CHUNK_NOTE_TIME
			end

			-- Note time (1 byte)
			local packedTime = Musician.Utils.PackTime(noteTime, 1, Musician.NOTE_TIME_FPS)

			-- First bit: note on, the rest: key (C0 is 0) (1 byte)
			local packedKeyOnOff = Musician.Utils.PackNumber(bit.bor(note[NOTE.ON] and 0x80 or 0x00, bit.band(note[NOTE.KEY] - Musician.C0_INDEX, 0x7F)), 1)

			-- Duration (1 byte, MAX_NOTE_DURATION is 255)
			local packedDuration = ""
			if note[NOTE.ON] and self.mode == Musician.Song.MODE_DURATION then
				packedDuration = Musician.Utils.PackTime(min(note[NOTE.DURATION], Musician.MAX_NOTE_DURATION), 1, Musician.NOTE_DURATION_FPS)
			end

			packedNoteData = packedNoteData .. packedKeyOnOff .. packedTime .. packedDuration
		end
	end

	return packedVersionAndMode .. packedChunkDuration .. packedSongId .. packedPlaytimeLeft .. packedPlayerPosition .. packedTrackCount .. packedTrackInfo .. packedNoteData
end

--- Unpack song chunk header
-- @param str (string)
-- @return mode (int)
-- @return songId (int)
-- @return chunkDuration (number)
-- @return playtimeLeft (number)
-- @return position (table) player position and GUID
-- @return trackCount (int)
-- @return cursor (number)
Musician.Song.UnpackChunkHeader = function(str)

	local cursor = 1
	local advanceCursor = function(bytes, isLastBit)
		cursor = cursor + bytes
		if cursor > #str + 1 then
			error(Musician.Msg.INVALID_MUSIC_CODE)
		end
	end

	local mode, songId, chunkDuration, playtimeLeft, position, trackCount

	local success = pcall(function()

		-- Version and mode (1)
		local versionAndModeByte = Musician.Utils.UnpackNumber(string.sub(str, cursor, cursor))
		local version = bit.band(versionAndModeByte, 0x0f)
		mode = bit.band(versionAndModeByte, 0xf0)
		advanceCursor(1)

		-- Invalid version
		if version > CHUNK_VERSION then
			error(Musician.Msg.INVALID_MUSIC_CODE)
		end

		-- Chunk duration (1)
		chunkDuration = Musician.Utils.UnpackNumber(string.sub(str, cursor, cursor)) / 10
		advanceCursor(1)

		-- Song ID (1)
		songId = Musician.Utils.UnpackNumber(string.sub(str, cursor, cursor))
		advanceCursor(1)

		-- Playtime left (2)
		playtimeLeft = Musician.Utils.UnpackNumber(string.sub(str, cursor, cursor + 1))
		advanceCursor(2)

		-- Player position (18)
		position = { Musician.Utils.UnpackPlayerPosition(string.sub(str, cursor, cursor + 17)) }
		advanceCursor(18)

		-- Number of tracks (1)
		trackCount = Musician.Utils.UnpackNumber(string.sub(str, cursor, cursor))
		advanceCursor(1)
	end)

	if not(success) then
		return nil
	end

	return mode, songId, chunkDuration, playtimeLeft, position, trackCount, cursor
end

--- Unpack song chunk data
-- @param str (table)
-- @return chunk (table)
Musician.Song.UnpackChunkData = function(str)

	-- Get header data
	local mode, songId, chunkDuration, playtimeLeft, position, trackCount, cursor = Musician.Song.UnpackChunkHeader(str)

	-- Failed to decode header
	if mode == nil then
		return nil
	end

	local advanceCursor = function(bytes, isLastBit)
		cursor = cursor + bytes
		if cursor > #str + 1 then
			error(Musician.Msg.INVALID_MUSIC_CODE)
		end
	end

	local chunk

	local success = pcall(function()
		-- Track information: trackId (1), instrumentId (1), note count (2)
		chunk = {}
		local t, trackData
		for t = 1, trackCount do
			local trackId = Musician.Utils.UnpackNumber(string.sub(str, cursor, cursor))
			advanceCursor(1)

			local instrument = Musician.Utils.UnpackNumber(string.sub(str, cursor, cursor))
			advanceCursor(1)

			local noteCount = Musician.Utils.UnpackNumber(string.sub(str, cursor, cursor + 1))
			advanceCursor(2)

			table.insert(chunk, {
				[CHUNK.TRACK_ID] = trackId,
				[CHUNK.INSTRUMENT] = instrument,
				[CHUNK.NOTE_COUNT] = noteCount,
				[CHUNK.NOTES] = {}
			})
		end

		-- Note information: key on/off or spacer (1), time (1), [duration (1)]
		local n, note
		for t, trackData in pairs(chunk) do
			for n = 1, trackData[CHUNK.NOTE_COUNT] do

				-- Key, note on/off or spacer (1)
				local offset = 0
				local keyByte = Musician.Utils.UnpackNumber(string.sub(str, cursor, cursor))
				advanceCursor(1)

				-- Spacer bytes
				while keyByte == 255 do
					offset = offset + Musician.MAX_CHUNK_NOTE_TIME
					keyByte = Musician.Utils.UnpackNumber(string.sub(str, cursor, cursor))
					advanceCursor(1)
				end

				-- Note on
				local noteOn = bit.band(keyByte, 0x80) == 0x80

				-- Key
				local key = bit.band(keyByte, 0x7F) + Musician.C0_INDEX

				-- Time relative to previous note
				local time = Musician.Utils.UnpackTime(string.sub(str, cursor, cursor), Musician.NOTE_TIME_FPS) + offset
				advanceCursor(1)

				-- Note duration
				local duration = nil
				if noteOn and mode == Musician.Song.MODE_DURATION then
					duration = Musician.Utils.UnpackTime(string.sub(str, cursor, cursor), Musician.NOTE_DURATION_FPS)
					advanceCursor(1)
				end

				table.insert(chunk[t][CHUNK.NOTES], {
					[NOTE.ON] = noteOn,
					[NOTE.KEY] = key,
					[NOTE.TIME] = time,
					[NOTE.DURATION] = duration
				})

			end
		end
	end)

	if not(success) then
		return nil
	end

	return chunk
end

--- Convert song to live mode.
-- For testing only
function Musician.Song:ConvertToLive()

	-- Already in live mode
	if self.mode == Musician.Song.MODE_LIVE then
		return
	end

	local track
	for _, track in pairs(self.tracks) do
		local note
		for _, note in pairs(track.notes) do
			if note[NOTE.DURATION] then
				table.insert(track.notes, {
					[NOTE.ON] = false,
					[NOTE.KEY] = note[NOTE.KEY],
					[NOTE.TIME] = note[NOTE.TIME] + note[NOTE.DURATION] - 1/30
				})
				note[NOTE.DURATION] = nil
			end
		end

		table.sort(track.notes, function(a, b)
			if a[NOTE.TIME] == b[NOTE.TIME] then
				return (a[NOTE.ON] and 1 or 0) < (b[NOTE.ON] and 1 or 0)
			end
			return a[NOTE.TIME] < b[NOTE.TIME]
		end)
	end

	self.mode = Musician.Song.MODE_LIVE
	self.chunkDuration = 1
end
