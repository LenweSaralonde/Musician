--- Song class
-- @module Musician.Song

Musician.Song = LibStub("AceAddon-3.0"):NewAddon("Musician.Song", "AceEvent-3.0")

local MODULE_NAME = "Song"
Musician.AddModule(MODULE_NAME)

local LibCRC32 = LibStub:GetLibrary("LibCRC32")
local LibDeflate = LibStub:GetLibrary("LibDeflate")

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
local BASE64DECODE_PROGRESSION_RATIO = .75
local UNCOMPRESS_PROGRESSION_RATIO = .33
local DEFLATE_CHUNK_SIZE = 2048

local IMPORT_CONVERT_RATE = 70 -- Number of base64 chunks to be converted in 1 ms
local IMPORT_NOTE_RATE = 36 -- Number of notes to be imported in 1 ms
local EXPORT_NOTE_RATE = 36 -- Number of notes to be exported in 1 ms

local playingSongs = {}
local playingSongCount = 0

local streamingSongs = {}
local streamingSongCount = 0

--- Add playing song to the list
-- @param song (Musician.Song)
local function addPlayingSong(song)
	if playingSongs[song] == nil then
		playingSongs[song] = song
		playingSongCount = playingSongCount + 1
	end
end

--- Remove playing song from the list
-- @param song (Musician.Song)
local function removePlayingSong(song)
	if playingSongs[song] ~= nil then
		playingSongs[song] = nil
		playingSongCount = playingSongCount - 1
	end
end

--- Add streaming song to the list
-- @param song (Musician.Song)
local function addStreamingSong(song)
	if streamingSongs[song] == nil then
		streamingSongs[song] = song
		streamingSongCount = streamingSongCount + 1
	end
end

--- Remove streaming song from the list
-- @param song (Musician.Song)
local function removeStreamingSong(song)
	if streamingSongs[song] ~= nil then
		streamingSongs[song] = nil
		streamingSongCount = streamingSongCount - 1
	end
end

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

	-- @field duration (int) Song duration in seconds
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

	-- @field exporting (boolean) True when the song is being exported
	self.exporting = false

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

	-- @field polyphony (int) Current theoretical polyphony
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
	if duration == 0 then return 0 end
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
	addPlayingSong(self)
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
		removePlayingSong(self)
		self.playing = false
		Musician.Utils.MuteGameMusic()
		Musician.Song:SendMessage(Musician.Events.SongStop, self)
	end
end

--- Main on frame update function
-- @param elapsed (number)
function Musician.Song.OnUpdate(elapsed)
	Musician.Utils.ForEach(playingSongs, function(song)
		song:PlayOnFrame(elapsed)
	end)
	Musician.Utils.ForEach(streamingSongs, function(song)
		song:StreamOnFrame(elapsed)
	end)
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

--- Returns true when the song is being played and can be heard
-- @return isAudible (boolean)
function Musician.Song:IsAudible()
	-- Song is not playing
	if not(self:IsPlaying()) then return false end

	-- Not played by another player: always audible
	if not(self.player) then return true end

	-- Played by another player who is in range and not muted
	return Musician.Registry.PlayerIsInRange(self.player) and not(Musician.PlayerIsMuted(player))
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
	if self.player ~= nil and (sourceSongIsPlaying or not(playerIsInRange)) or self:TrackIsMuted(track) or Musician.PlayerIsMuted(self.player) then
		shouldPlay = false
	end

	-- The same note cannot be already playing on the same track
	self:NoteOff(track, key)

	-- Play note sound file
	local handle
	if shouldPlay then
		Musician.Song:SendMessage(Musician.Events.NoteOn, self, track, key)
		handle = Musician.Sampler.PlayNote(track.instrument, key)
	end

	-- Add note to notesOn with sound handle and note off time
	local endTime = nil
	if duration ~= nil then
		endTime = self.cursor + duration
	end

	track.notesOn[key] = {
		[NOTEON.TIME] = time,
		[NOTEON.ENDTIME] = endTime,
		[NOTEON.HANDLE] = handle or 0
	}
	track.polyphony = track.polyphony + 1
	self.polyphony = self.polyphony + 1

	Musician.Song:SendMessage(Musician.Events.VisualNoteOn, self, track, key)
end

--- Stop a note of a track
-- @param track (table) Reference to the track
-- @param key (int) Note key
-- @param audioOnly (boolean) Stop note audio only
-- @param[opt] decay (number) Override instrument decay
function Musician.Song:NoteOff(track, key, audioOnly, decay)
	if track.notesOn[key] ~= nil then
		local handle = track.notesOn[key][NOTEON.HANDLE]
		if handle ~= 0 then
			Musician.Sampler.StopNote(handle, decay)
			Musician.Song:SendMessage(Musician.Events.NoteOff, self, track, key)
		end

		if audioOnly then
			track.notesOn[key][NOTEON.HANDLE] = 0
		else
			track.notesOn[key] = nil
			track.polyphony = track.polyphony - 1
			self.polyphony = self.polyphony - 1
			Musician.Song:SendMessage(Musician.Events.VisualNoteOff, self, track, key)
		end
	end
end

--- Stop all notes of a track
-- @param track (table) Reference to the track
-- @param audioOnly (boolean)
function Musician.Song:TrackNotesOff(track, audioOnly)
	local noteKey, noteOn
	for noteKey, noteOn in pairs(track.notesOn) do
		self:NoteOff(track, noteKey, audioOnly)
	end
end

--- Stop all notes of the song
function Musician.Song:SongNotesOff()
	local track
	for _, track in pairs(self.tracks) do
		self:TrackNotesOff(track)
	end
end

--- Import song from a base 64 encoded string
-- @param base64data (string)
-- @param crop (boolean) Automatically crop song to first and last note
-- @param[opt] onComplete (function) Called when the whole import process is complete. Argument is true when successful
function Musician.Song:ImportFromBase64(base64data, crop, onComplete)
	if self.importing or self.exporting then
		error("The song is already importing or exporting.")
	end
	self.importing = true

	Musician.Song:SendMessage(Musician.Events.SongImportStart, self)
	Musician.Song:SendMessage(Musician.Events.SongImportProgress, self, 0)

	local cursor = 1
	local decodedData = ''
	local base64DecodingWorker

	-- Decode string in a worker
	base64DecodingWorker = function()
		-- Importing process has been canceled
		if not(self.importing) then
			Musician.Worker.Remove(base64DecodingWorker)
			Musician.Song:SendMessage(Musician.Events.SongImportComplete, self)
			Musician.Song:SendMessage(Musician.Events.SongImportFailed, self)
			return
		end

		-- Notify progression
		local progression = min(1, cursor / #base64data)
		Musician.Song:SendMessage(Musician.Events.SongImportProgress, self, progression * BASE64DECODE_PROGRESSION_RATIO)

		-- Decode some chunks
		local cursorTo = min(#base64data, cursor + IMPORT_CONVERT_RATE * 4 - 1)
		decodedData = decodedData .. Musician.Utils.Base64Decode(string.sub(base64data, cursor, cursorTo))
		cursor = cursorTo + 1

		-- Decoding is complete: import data
		if cursor >= #base64data then
			Musician.Song:SendMessage(Musician.Events.SongImportProgress, self, BASE64DECODE_PROGRESSION_RATIO)
			self.importing = false
			Musician.Worker.Remove(base64DecodingWorker)
			self:Import(decodedData, crop, BASE64DECODE_PROGRESSION_RATIO, onComplete)
			return
		end
	end
	Musician.Worker.Set(base64DecodingWorker, function()
		self:OnImportError()
		if onComplete then
			onComplete(false)
		end
	end)
end

--- Import song from a compressed string
-- @param compressedData (string)
-- @param crop (boolean) Automatically crop song to first and last note
-- @param[opt] onComplete (function) Called when the whole import process is complete. Argument is true when successful
function Musician.Song:ImportCompressed(compressedData, crop, onComplete)
	if self.importing or self.exporting then
		error("The song is already importing or exporting.")
	end
	self.importing = true

	local cursor = 1
	local uncompressedData = ''
	local uncompressWorker

	-- Uncompress string in a worker
	uncompressWorker = function()
		-- Importing process has been canceled
		if not(self.importing) then
			Musician.Worker.Remove(uncompressWorker)
			Musician.Song:SendMessage(Musician.Events.SongImportComplete, self)
			Musician.Song:SendMessage(Musician.Events.SongImportFailed, self)
			return
		end

		-- Notify progression
		local progression = min(1, cursor / #compressedData)
		Musician.Song:SendMessage(Musician.Events.SongImportProgress, self, progression * UNCOMPRESS_PROGRESSION_RATIO)

		-- Compressed chunk size (2)
		local compressedChunkSize = Musician.Utils.UnpackNumber(string.sub(compressedData, cursor, cursor + 1))
		cursor = cursor + 2

		-- Uncompress chunk
		local compressedChunk = string.sub(compressedData, cursor, cursor + compressedChunkSize - 1)
		cursor = cursor + compressedChunkSize
		uncompressedData = uncompressedData .. LibDeflate:DecompressDeflate(compressedChunk)

		-- Uncompressing is complete: import data
		if cursor >= #compressedData then
			Musician.Song:SendMessage(Musician.Events.SongImportProgress, self, UNCOMPRESS_PROGRESSION_RATIO)
			self.importing = false
			Musician.Worker.Remove(uncompressWorker)
			self:Import(uncompressedData, crop, UNCOMPRESS_PROGRESSION_RATIO, onComplete)
			return
		end
	end
	Musician.Worker.Set(uncompressWorker, function()
		self:OnImportError()
		if onComplete then
			onComplete(false)
		end
	end)
end

--- Import song from string
-- @param data (string)
-- @param crop (boolean) Automatically crop song to first and last note
-- @param[opt=0] previousProgression (number) Add previous progression (0-1)
-- @param[opt] onComplete (function) Called when the whole import process is complete. Argument is true when successful
function Musician.Song:Import(data, crop, previousProgression, onComplete)
	if self.importing or self.exporting then
		error("The song is already importing or exporting.")
	end
	self.importing = true

	if previousProgression == nil then
		Musician.Song:SendMessage(Musician.Events.SongImportStart, self)
		previousProgression = 0
	end
	Musician.Song:SendMessage(Musician.Events.SongImportProgress, self, previousProgression)

	local chunksCrc32
	local readBytesInternal = Musician.Utils.GetByteReader(data, Musician.Msg.INVALID_MUSIC_CODE)

	local readBytes = function(length, updateCrc32)
		local bytes = readBytesInternal(length)
		if updateCrc32 then
			chunksCrc32 = LibCRC32:hashChunk(bytes, chunksCrc32)
		end
		return bytes
	end

	local progression

	-- Import song header
	-- ==================

	local noteCount = 0

	-- Header (4)
	if readBytes(4) ~= Musician.FILE_HEADER then
		error(Musician.Msg.INVALID_MUSIC_CODE)
	end

	-- Duration (3)
	self.duration = Musician.Utils.UnpackNumber(readBytes(3, true))
	self.cropFrom = 0
	self.cropTo = self.duration

	-- Number of tracks (1)
	local trackCount = Musician.Utils.UnpackNumber(readBytes(1, true))

	-- Track information: instrument (1), channel (1), number of notes (2)
	local track, trackIndex
	self.tracks = {}
	for trackIndex = 1, trackCount do
		local track = {}

		-- Instrument (1)
		track.instrument = Musician.Utils.UnpackNumber(readBytes(1))
		track.midiInstrument = track.instrument

		-- Channel (1)
		track.channel = Musician.Utils.UnpackNumber(readBytes(1))

		-- Note count (2)
		track.noteCount = Musician.Utils.UnpackNumber(readBytes(2, true))
		noteCount = noteCount + track.noteCount

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
	progression = previousProgression + (1 - previousProgression) / (noteCount + 2)
	Musician.Song:SendMessage(Musician.Events.SongImportProgress, self, progression)

	-- Import notes
	-- ============

	local importedNotes = 0
	local trackOffset = 0
	local trackIndex = 1
	local noteIndex = 1
	local noteImportingWorker

	-- Import notes in a worker
	noteImportingWorker = function()
		-- Importing process has been canceled
		if not(self.importing) then
			Musician.Worker.Remove(noteImportingWorker)
			Musician.Song:SendMessage(Musician.Events.SongImportComplete, self)
			Musician.Song:SendMessage(Musician.Events.SongImportFailed, self)
			return
		end

		-- Import some notes
		local stopOnNoteCount = min(importedNotes + IMPORT_NOTE_RATE, noteCount)
		while importedNotes < stopOnNoteCount do

			local track = self.tracks[trackIndex]

			-- Ignore empty tracks
			while track.noteCount == 0 do
				trackIndex = trackIndex + 1
				track = self.tracks[trackIndex]
			end

			-- Key (1)
			local key = Musician.Utils.UnpackNumber(readBytes(1, true))

			-- This is a spacer (key 0xFF)
			if key == 0xFF then
				trackOffset = trackOffset + 65535 / Musician.NOTE_TIME_FPS -- 16-bit
			else
				-- Note on with duration

				-- Time (2)
				local time = trackOffset + Musician.Utils.UnpackTime(readBytes(2, true), Musician.NOTE_TIME_FPS)

				-- Duration (1)
				local duration = Musician.Utils.UnpackTime(readBytes(1, true), Musician.NOTE_DURATION_FPS)

				-- Insert note
				table.insert(track.notes, {
					[NOTE.ON] = true,
					[NOTE.KEY] = key,
					[NOTE.TIME] = time,
					[NOTE.DURATION] = duration
				})

				importedNotes = importedNotes + 1

				-- Track import complete
				if noteIndex == track.noteCount then
					track.noteCount = nil -- We don't need this information anymore

					-- Proceed with next track
					trackIndex = trackIndex + 1
					trackOffset = 0
					noteIndex = 1
				else
					noteIndex = noteIndex + 1
				end
			end
		end

		-- Update progression
		progression = previousProgression + (1 - previousProgression) * (importedNotes + 1) / (noteCount + 2)
		Musician.Song:SendMessage(Musician.Events.SongImportProgress, self, progression)

		-- All notes have been imported
		if importedNotes == noteCount then
			Musician.Worker.Remove(noteImportingWorker)

			-- Import metadata
			-- ===============

			-- Song title (2) + (title length in bytes)
			local songTitleLength = Musician.Utils.UnpackNumber(readBytes(2))
			self.name = readBytes(songTitleLength)

			-- Track names (2) + (title length in bytes)
			for trackIndex, track in pairs(self.tracks) do
				local trackNameLength = Musician.Utils.UnpackNumber(readBytes(2))
				track.name = readBytes(trackNameLength)
			end

			-- Crop song
			if crop then
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
			self.crc32 = LibCRC32:getFinalCrc(chunksCrc32)

			-- Update progression
			progression = 1
			Musician.Song:SendMessage(Musician.Events.SongImportProgress, self, progression)

			-- Import is complete!
			self.importing = false
			Musician.Song:SendMessage(Musician.Events.SongImportComplete, self)
			Musician.Song:SendMessage(Musician.Events.SongImportSucessful, self, data)
			if onComplete then
				onComplete(true)
			end
		end
	end

	Musician.Worker.Set(noteImportingWorker, function()
		self:OnImportError()
		if onComplete then
			onComplete(false)
		end
	end)
end

--- Export song to string
-- @param onComplete (function) Called when the whole export process is complete. Data is provided when successful
function Musician.Song:Export(onComplete)

	if self.importing or self.exporting then
		error("The song is already importing or exporting.")
	end
	self.exporting = true

	local data = ''

	-- Song header
	-- ===========

	-- Header (4)
	data = data .. Musician.FILE_HEADER

	-- Duration (3)
	data = data .. Musician.Utils.PackNumber(self.duration, 3)

	-- Number of tracks (1)
	data = data .. Musician.Utils.PackNumber(#Musician.sourceSong.tracks, 1)

	-- Tracks
	-- ======

	local track
	local noteCount = 0
	for _, track in pairs(self.tracks) do
		-- Instrument (1)
		data = data .. Musician.Utils.PackNumber(track.instrument, 1)

		-- Channel (1)
		data = data .. Musician.Utils.PackNumber(track.channel, 1)

		-- Note count (2)
		data = data .. Musician.Utils.PackNumber(#track.notes, 2)
		noteCount = noteCount + #track.notes
	end

	-- Notes
	-- =====

	local exportedNotes = 0
	local trackOffset = 0
	local trackIndex = 1
	local noteIndex = 1
	local offset = 0
	local noteExportingWorker

	-- Export notes in a worker
	noteExportingWorker = function()
		-- Exporting process has been canceled
		if not(self.exporting) then
			Musician.Worker.Remove(noteExportingWorker)
			return
		end

		-- Export some notes
		local track = self.tracks[trackIndex]
		local notesData = ''
		local stopOnNoteCount = min(exportedNotes + EXPORT_NOTE_RATE, noteCount)
		while exportedNotes < stopOnNoteCount do
			local note = track.notes[noteIndex]

			-- No more note in this track: skip to next track
			if note == nil then
				trackIndex = trackIndex + 1
				track = self.tracks[trackIndex]
				noteIndex = 1
				offset = 0
			else
				local noteTime = note[NOTE.TIME] - offset

				-- Insert note spacers if needed
				local noteSpacer = ''
				while noteTime > Musician.MAX_NOTE_TIME do
					noteSpacer = noteSpacer .. Musician.Utils.PackNumber(0xFF, 1)
					noteTime = noteTime - Musician.MAX_NOTE_TIME
					offset = offset + Musician.MAX_NOTE_TIME
				end
				notesData = notesData .. noteSpacer

				-- Key (1)
				notesData = notesData .. Musician.Utils.PackNumber(note[NOTE.KEY], 1)

				-- Time (2)
				notesData = notesData .. Musician.Utils.PackTime(noteTime, 2, Musician.NOTE_TIME_FPS)

				-- Duration (1)
				notesData = notesData .. Musician.Utils.PackTime(note[NOTE.DURATION], 1, Musician.NOTE_DURATION_FPS)

				-- Proceed with next note
				exportedNotes = exportedNotes + 1
				noteIndex = noteIndex + 1
			end
		end
		data = data .. notesData

		-- All notes have been exported
		if exportedNotes == noteCount then
			Musician.Worker.Remove(noteExportingWorker)

			-- Metadata
			-- ========

			-- Song title (2) + (title length in bytes)
			data = data .. Musician.Utils.PackNumber(#self.name, 2) .. self.name

			-- Track names (2) + (title length in bytes)
			for _, track in pairs(self.tracks) do
				data = data .. Musician.Utils.PackNumber(#track.name, 2) .. track.name
			end

			self.exporting = false

			onComplete(data)
		end
	end

	Musician.Worker.Set(noteExportingWorker)
end

--- Export song to compressed string
-- @param onComplete (function) Called when the whole export process is complete. Data is provided when successful
function Musician.Song:ExportCompressed(onComplete)
	self:Export(function(data)
		self.exporting = true
		local readBytes = Musician.Utils.GetByteReader(data)
		local bytesToRead = #data
		local compressedData = ''

		-- Compress exported data using worker
		local compressChunkWorker
		compressChunkWorker = function()
			-- Exporting process has been cancelled
			if not(self.exporting) then
				Musician.Worker.Remove(compressChunkWorker)
				return
			end

			-- Exporting process is complete
			if bytesToRead == 0 then
				Musician.Worker.Remove(compressChunkWorker)
				self.exporting = false
				onComplete(compressedData)
				return
			end

			-- Compress chunk
			local chunkSize = min(DEFLATE_CHUNK_SIZE, bytesToRead)
			local chunk = readBytes(chunkSize)
			local compressedChunk = LibDeflate:CompressDeflate(chunk, { level = 9 })
			bytesToRead = bytesToRead - chunkSize
			compressedData = compressedData .. Musician.Utils.PackNumber(#compressedChunk, 2) .. compressedChunk
		end
		Musician.Worker.Set(compressChunkWorker)
	end)
end

--- Cancel current import
--
function Musician.Song:CancelImport()
	self.importing = false
end

--- Cancel current export
--
function Musician.Song:CancelExport()
	self.exporting = false
end

--- Handle importing error
--
function Musician.Song:OnImportError()
	self.importing = false
	Musician.Song:SendMessage(Musician.Events.SongImportComplete, self)
	Musician.Song:SendMessage(Musician.Events.SongImportFailed, self)
	Musician.Utils.Error(Musician.Msg.INVALID_MUSIC_CODE)
end

--- Clone song
-- @return song (Musician.Song)
function Musician.Song:Clone()

	local song = Musician.Song.create()
	local key, value

	for key, value in pairs(self) do
		song[key] = Musician.Utils.DeepCopy(value)
	end

	-- Stop playing and streaming to avoid unexpected behavior
	song.playing = false
	song.streaming = false

	return song
end

--- Stream song
function Musician.Song:Stream()
	Musician.Utils.Debug(MODULE_NAME, "Stream", self.name, self)

	-- Stop song if playing
	removePlayingSong(self)
	self.playing = false

	-- Stop and reset streaming
	self:StopStreaming()

	local track
	for _, track in pairs(self.tracks) do
		track.streamIndex = nil
	end

	self.timeSinceLastStreamChunk = 0
	self.streamPosition = self.cropFrom
	self.songId = nil

	-- Start streaming
	addStreamingSong(self)
	self.streaming = true
	self.timeSinceLastStreamChunk = self.chunkDuration
	Musician.Song:SendMessage(Musician.Events.StreamStart, self)
end

--- Stop streaming song
function Musician.Song:StopStreaming()
	if not(self.streaming) then return end
	Musician.Utils.Debug(MODULE_NAME, "StopStreaming", wasStreaming, self.name, self)
	removeStreamingSong(self)
	self.streaming = false

	Musician.Song:SendMessage(Musician.Events.StreamStop, self)
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
		track.midiInstrument = track.instrument

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

			-- Insert received note if the key is within allowed range
			if note[NOTE.KEY] >= Musician.MIN_KEY and note[NOTE.KEY] <= Musician.MAX_KEY then
				table.insert(track.notes, note)
			end
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
				if not(self:TrackIsMuted(track)) and track.instrument >= 0 and track.instrument <= 255 then
					local note = Musician.Utils.DeepCopy(track.notes[track.streamIndex])
					local key = note[NOTE.KEY] + track.transpose

					-- Send note if key is within allowed range
					if key >= Musician.MIN_KEY and key <= Musician.MAX_KEY then
						note[NOTE.KEY] = key
						local noteTimeRelative = note[NOTE.TIME] - noteOffset
						noteOffset = note[NOTE.TIME]
						note[NOTE.TIME] = noteTimeRelative

						if note[NOTE.DURATION] ~= nil then
							note[NOTE.DURATION] = note[NOTE.DURATION]
						end

						table.insert(notes, note)
					end
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
-- @param data (string)
-- @return mode (int)
-- @return songId (int)
-- @return chunkDuration (number)
-- @return playtimeLeft (number)
-- @return position (table) player position and GUID
-- @return trackCount (int)
-- @return headerLength (number)
Musician.Song.UnpackChunkHeader = function(data)

	local readBytes = Musician.Utils.GetByteReader(data)

	local mode, songId, chunkDuration, playtimeLeft, position, trackCount

	local success = pcall(function()

		-- Version and mode (1)
		local versionAndModeByte = Musician.Utils.UnpackNumber(readBytes(1))
		local version = bit.band(versionAndModeByte, 0x0f)
		mode = bit.band(versionAndModeByte, 0xf0)

		-- Invalid version
		if version > CHUNK_VERSION then
			error(Musician.Msg.INVALID_MUSIC_CODE)
		end

		-- Chunk duration (1)
		chunkDuration = Musician.Utils.UnpackNumber(readBytes(1)) / 10

		-- Song ID (1)
		songId = Musician.Utils.UnpackNumber(readBytes(1))

		-- Playtime left (2)
		playtimeLeft = Musician.Utils.UnpackNumber(readBytes(2))

		-- Player position (18)
		position = { Musician.Utils.UnpackPlayerPosition(readBytes(18)) }

		-- Number of tracks (1)
		trackCount = Musician.Utils.UnpackNumber(readBytes(1))
	end)

	if not(success) then
		return nil
	end

	return mode, songId, chunkDuration, playtimeLeft, position, trackCount, 24
end

--- Unpack song chunk data
-- @param data (string)
-- @return chunk (table)
Musician.Song.UnpackChunkData = function(data)

	-- Get header data
	local mode, songId, chunkDuration, playtimeLeft, position, trackCount, headerLength = Musician.Song.UnpackChunkHeader(data)

	-- Failed to decode header
	if mode == nil then
		return nil
	end

	local readBytes = Musician.Utils.GetByteReader(data)

	local chunk
	local success = pcall(function()
		-- Skip header
		readBytes(headerLength)

		-- Track information: trackId (1), instrumentId (1), note count (2)
		chunk = {}
		local t, trackData
		for t = 1, trackCount do
			local trackId = Musician.Utils.UnpackNumber(readBytes(1))
			local instrument = Musician.Utils.UnpackNumber(readBytes(1))
			local noteCount = Musician.Utils.UnpackNumber(readBytes(2))

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
				local keyByte = Musician.Utils.UnpackNumber(readBytes(1))

				-- Spacer bytes
				while keyByte == 255 do
					offset = offset + Musician.MAX_CHUNK_NOTE_TIME
					keyByte = Musician.Utils.UnpackNumber(readBytes(1))
				end

				-- Note on
				local noteOn = bit.band(keyByte, 0x80) == 0x80

				-- Key
				local key = bit.band(keyByte, 0x7F) + Musician.C0_INDEX

				-- Time relative to previous note
				local time = Musician.Utils.UnpackTime(readBytes(1), Musician.NOTE_TIME_FPS) + offset

				-- Note duration
				local duration = nil
				if noteOn and mode == Musician.Song.MODE_DURATION then
					duration = Musician.Utils.UnpackTime(readBytes(1), Musician.NOTE_DURATION_FPS)
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

--- Return songs currently playing
-- @return playingSongCount (int)
function Musician.Song.GetPlayingSongs()
	return Musician.Utils.ShallowCopy(playingSongs)
end

--- Return the number of songs currently playing
-- @return playingSongCount (int)
function Musician.Song.GetPlayingSongCount()
	return playingSongCount
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
