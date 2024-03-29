--- Song class
-- @module Musician.Song

Musician.Song = LibStub("AceAddon-3.0"):NewAddon("Musician.Song", "AceEvent-3.0")

local MODULE_NAME = "Song"
Musician.AddModule(MODULE_NAME)

local LibCRC32 = LibStub:GetLibrary("LibCRC32")
local LibDeflate = LibStub:GetLibrary("LibDeflate")
local LibBase64 = LibStub:GetLibrary("LibBase64")

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
Musician.Song.Indexes.NOTEON.HANDLE_ACCENT = 4

Musician.Song.Indexes.CHUNK = {}
Musician.Song.Indexes.CHUNK.SONG_ID = 1
Musician.Song.Indexes.CHUNK.TRACK_ID = 2
Musician.Song.Indexes.CHUNK.INSTRUMENT = 3
Musician.Song.Indexes.CHUNK.NOTES = 4
Musician.Song.Indexes.CHUNK.NOTE_COUNT = 5

local NOTE = Musician.Song.Indexes.NOTE
local NOTEON = Musician.Song.Indexes.NOTEON
local CHUNK = Musician.Song.Indexes.CHUNK

-- Max length for the song title
Musician.Song.MAX_NAME_LENGTH = 512

-- Song modes
Musician.Song.MODE_DURATION = 0x10 -- Duration are set in chunk notes
Musician.Song.MODE_LIVE = 0x20 -- No duration in chunk notes

-- Track options
Musician.Song.TRACK_OPTION_HAS_INSTRUMENT = 0x1
Musician.Song.TRACK_OPTION_MUTED = 0x2
Musician.Song.TRACK_OPTION_SOLO = 0x4
Musician.Song.TRACK_OPTION_ACCENT = 0x8

local CHUNK_VERSION = 0x01 -- Max: 0x0F (15)
local BASE64DECODE_PROGRESSION_RATIO = .75
local COMPRESS_PROGRESSION_RATIO = .5
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

	-- @field sender (string) Name of the player who sent the song
	self.sender = nil

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

	-- @field header (string) Song file header that determines the file format
	self.header = Musician.FILE_HEADER

	-- @field isLiveStreamingSong (boolean) Song is used for, or results from live streaming from the current player
	self.isLiveStreamingSong = false

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
	return self.playing
end

--- Return playing progression
-- @return progression (number)
function Musician.Song:GetProgression()
	if not self.playing then
		return nil
	end
	local duration = self.cropTo - self.cropFrom
	local position = self.cursor - self.cropFrom
	if duration == 0 then return 0 end
	return position / duration
end

--- Get track by index
-- @param trackIndex (int)
-- @return track (table)
function Musician.Song:GetTrack(trackIndex)
	return self.tracks[trackIndex]
end

--- Compute the track audible flag after a track was muted or set as solo.
-- @param song (Musician.Song)
-- @param track (table)
-- @param sendAudibleEvent (boolean) Send Musician.Events.SongAudibleChange when true
local function computeTrackAudible(song, track, sendAudibleEvent)
	track.audible = not (track.muted or song.soloTracks > 0 and not track.solo)
	if sendAudibleEvent then
		Musician.Song:SendMessage(Musician.Events.SongAudibleChange, song, track, track.audible)
	end
end

--- Mute or unmute track
-- @param song (Musician.Song)
-- @param track (table)
-- @param isMuted (boolean)
-- @param sendAudibleEvent (boolean) Send Musician.Events.SongAudibleChange when true
local function setTrackMuted(song, track, isMuted, sendAudibleEvent)
	track.muted = isMuted
	computeTrackAudible(song, track, sendAudibleEvent)
end

--- Set/unset track solo
-- @param song (Musician.Song)
-- @param track (table)
-- @param isSolo (boolean)
-- @param sendAudibleEvent (boolean) Send Musician.Events.SongAudibleChange when true
local function setTrackSolo(song, track, isSolo, sendAudibleEvent)
	if track.solo and not isSolo then
		track.solo = false
		song.soloTracks = song.soloTracks - 1
	elseif not track.solo and isSolo then
		track.solo = true
		song.soloTracks = song.soloTracks + 1
	end
	for _, t in pairs(song.tracks) do
		computeTrackAudible(song, t, sendAudibleEvent)
	end
end

--- Mute or unmute track
-- @param track (int|table)
-- @param isMuted (boolean)
function Musician.Song:SetTrackMuted(track, isMuted)
	if type(track) == "number" then
		track = self:GetTrack(track)
	end
	if track == nil then return end
	setTrackMuted(self, track, isMuted, true)
	Musician.Song:SendMessage(Musician.Events.SongMutedChange, self, track, isMuted)
end

--- Set/unset track solo
-- @param track (int|table)
-- @param isSolo (boolean)
function Musician.Song:SetTrackSolo(track, isSolo)
	if type(track) == "number" then
		track = self:GetTrack(track)
	end
	if track == nil then return end
	setTrackSolo(self, track, isSolo, true)
	Musician.Song:SendMessage(Musician.Events.SongSoloChange, self, track, isSolo)
end

--- Set/unset track accent
-- @param track (int|table)
-- @param isAccent (boolean)
function Musician.Song:SetTrackAccent(track, isAccent)
	if type(track) == "number" then
		track = self:GetTrack(track)
	end
	if track == nil then return end
	track.accent = isAccent
	Musician.Song:SendMessage(Musician.Events.SongAccentChange, self, track, isAccent)
end

--- Set track transposition in semitones
-- @param track (int|table)
-- @param semitones (int)
function Musician.Song:SetTrackTranspose(track, semitones)
	if type(track) == "number" then
		track = self:GetTrack(track)
	end
	if track == nil then return end
	track.transpose = semitones
	Musician.Song:SendMessage(Musician.Events.SongTransposeChange, self, track, semitones)
end

--- Set track instrument MIDI ID
-- @param track (int|table)
-- @param midiId (int)
function Musician.Song:SetTrackInstrument(track, midiId)
	if type(track) == "number" then
		track = self:GetTrack(track)
	end
	if track == nil then return end
	track.instrument = midiId
	Musician.Song:SendMessage(Musician.Events.SongInstrumentChange, self, track, midiId)
end

--- Set crop from point
-- @param cropFrom (number)
function Musician.Song:SetCropFrom(cropFrom)
	if cropFrom < self.cropTo then
		self.cropFrom = cropFrom
	end
	if self.cursor < cropFrom then
		self:Seek(cropFrom)
	end
	Musician.Song:SendMessage(Musician.Events.SongCropFromChange, self, cropFrom)
end

--- Set crop to point
-- @param cropTo (number)
function Musician.Song:SetCropTo(cropTo)
	if cropTo > self.cropFrom then
		self.cropTo = cropTo
	end
	if self.cursor > cropTo then
		self:Seek(cropTo)
	end
	Musician.Song:SendMessage(Musician.Events.SongCropToChange, self, cropTo)
end

--- Play song
-- @param delay (number) Delay in seconds to wait before playing the song
function Musician.Song:Play(delay)
	if delay == nil then
		delay = 0
	end

	self:SongNotesOff()
	self:Seek(self.cropFrom - delay)
	self:Resume()
end

--- Reset song to initial position
function Musician.Song:Reset()
	self:SongNotesOff()
	self:Seek(self.cropFrom)
end

--- Perform seek within track
-- @param cursor (number) Position to reach
-- @param track (table)
-- @return playIndex (int)
local function trackSeek(cursor, track)
	local noteCount = #track.notes

	if noteCount == 0 then
		return 0
	end

	-- Cursor is before the first note
	if cursor <= track.notes[1][NOTE.TIME] then
		return 1
		-- Cursor is after the last note
	elseif cursor > track.notes[noteCount][NOTE.TIME] then
		return noteCount + 1
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
	while not found do
		index = from + floor((to - from) / 2 + .5)

		-- Exact position found! Find first note at exact position
		while index >= 1 and track.notes[index][NOTE.TIME] == cursor do
			found = true
			index = index - 1
		end

		if found then
			return index + 1
		end

		local previousNoteTime = track.notes[index - 1][NOTE.TIME]
		local noteTime = track.notes[index][NOTE.TIME]

		-- In-between position found
		if cursor > previousNoteTime and cursor <= noteTime then
			return index
		end

		-- Seek before
		if cursor < noteTime then
			to = index
		else -- Seek after
			from = index
		end
	end

	return index
end

--- Seek to position
-- @param cursor (number)
function Musician.Song:Seek(cursor)
	cursor = min(cursor, self.cropTo)

	if cursor == self.cursor then
		return
	end

	self:SongNotesOff()

	for _, track in pairs(self.tracks) do
		track.playIndex = trackSeek(cursor, track)
	end

	self.cursor = cursor
	Musician.Song:SendMessage(Musician.Events.SongCursor, self)

	self:ResumeNotes()
end

--- Resume a song playing
-- @param eventSent (boolean)
function Musician.Song:Resume(eventSent)
	Musician.Utils.AdjustAudioSettings(true)
	addPlayingSong(self)
	self.playing = true
	if not eventSent then
		Musician.Song:SendMessage(Musician.Events.SongPlay, self)
	end
	self:ResumeNotes()
end

--- Resume notes after the song was paused
--
function Musician.Song:ResumeNotes()
	if self.playing then
		for _, track in pairs(self.tracks) do
			-- Only resume notes for sustained instruments
			if not Musician.Sampler.IsInstrumentPlucked(track.instrument) then
				for noteIndex = track.playIndex - 1, 1, -1 do
					local time = track.notes[noteIndex][NOTE.TIME]
					-- No need to seek if the maximum note duration was exceeded
					if time + track.maxNoteDuration < self.cursor then
						break
					end
					local duration = track.notes[noteIndex][NOTE.DURATION]
					if duration ~= nil and time + duration > self.cursor then
						self:NoteOn(track, noteIndex)
					end
				end
			end
		end
	end
end

--- Stop song
function Musician.Song:Stop()
	self:SongNotesOff()
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
	for _, song in pairs(playingSongs) do
		song:PlayOnFrame(elapsed)
	end
	for _, song in pairs(streamingSongs) do
		song:StreamOnFrame(elapsed)
	end
end

--- Play notes accordingly to every frame.
-- @param elapsed (number)
function Musician.Song:PlayOnFrame(elapsed)
	if not self.playing then
		return
	end

	local drops = 0
	local from = self.cursor
	local to = self.cursor + elapsed
	self.cursor = to

	for _, track in pairs(self.tracks) do
		-- Stop expired notes currently playing
		for noteKey, noteOnStack in pairs(track.notesOn) do
			for noteIndex = #noteOnStack, 1, -1 do
				local noteOn = noteOnStack[noteIndex]
				if noteOn[NOTEON.ENDTIME] ~= nil and noteOn[NOTEON.ENDTIME] < to then -- Off time is in the past
					self:NoteOff(track, noteKey, noteIndex)
				end
			end
		end

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
	if not self:IsPlaying() then return false end

	-- Not played by another player: always audible
	if not self.player then return true end

	-- Played by another player who is in range and not muted
	return Musician.Registry.PlayerIsInRange(self.player) and not Musician.PlayerIsMuted(self.player)
end

--- Play a note
-- @param track (table) Reference to the track
-- @param noteIndex (int) Note index
function Musician.Song:NoteOn(track, noteIndex)
	local note = track.notes[noteIndex]
	local key = note[NOTE.KEY] + track.transpose
	local time = note[NOTE.TIME]
	local duration = note[NOTE.DURATION]

	-- Send notification emote
	if self.player ~= nil and not self.notified and Musician.Registry.PlayerIsInRange(self.player) then
		Musician.Utils.DisplayEmote(self.player, Musician.Registry.GetPlayerGUID(self.player), Musician.Msg.EMOTE_PLAYING_MUSIC)
		self.notified = true
	end

	-- Don't play back my own live notes
	if Musician.Utils.PlayerIsMyself(self.player) and self.isLiveStreamingSong then
		return
	end

	-- Don't play back other player's live notes
	if Musician.Live.IsPlayerSynced(self.player) and self.mode == Musician.Song.MODE_LIVE then
		return
	end

	local shouldPlay = true

	-- Play note sound file
	local handle, handleAccent
	if shouldPlay then
		local loopNote = (duration == nil) or (duration > Musician.MAX_NOTE_DURATION)
		handle = Musician.Sampler.PlayNote(track.instrument, key, loopNote, track, self.player)
		-- Double the note if the track has accent
		if track.accent then
			handleAccent = Musician.Sampler.PlayNote(track.instrument, key, loopNote, track, self.player)
		end
		if track.audible then
			Musician.Song:SendMessage(Musician.Events.NoteOn, self, track, key)
		end
	end

	-- Add note to notesOn with sound handle and note off time
	local endTime = nil
	if duration ~= nil then
		endTime = time + duration
	end

	if track.notesOn[key] == nil then
		track.notesOn[key] = {}
	end
	table.insert(track.notesOn[key], {
		[NOTEON.TIME] = time,
		[NOTEON.ENDTIME] = endTime,
		[NOTEON.HANDLE] = handle or 0,
		[NOTEON.HANDLE_ACCENT] = handleAccent or 0
	})

	track.polyphony = track.polyphony + 1
	self.polyphony = self.polyphony + 1

	Musician.Song:SendMessage(Musician.Events.VisualNoteOn, self, track, key)
end

--- Stop a note of a track
-- @param track (table) Reference to the track
-- @param key (int) Note key
-- @param[opt] stackIndex (int) Note on stack index
function Musician.Song:NoteOff(track, key, stackIndex)
	if self.mode == Musician.Song.MODE_LIVE then
		key = key + track.transpose
	end

	if track.notesOn[key] ~= nil then
		local noteOnStack = track.notesOn[key]

		-- Get note on from the stack (topmost by default)
		local noteOn = noteOnStack[stackIndex or #noteOnStack]

		-- Stop playing the note
		local handle = noteOn[NOTEON.HANDLE]
		if handle ~= nil then
			Musician.Sampler.StopNote(handle)
		end
		local handleAccent = noteOn[NOTEON.HANDLE_ACCENT]
		if handleAccent ~= nil then
			Musician.Sampler.StopNote(handleAccent)
		end
		if track.audible then
			Musician.Song:SendMessage(Musician.Events.NoteOff, self, track, key)
		end

		-- Remove note from stack
		wipe(noteOn)
		table.remove(noteOnStack, stackIndex)
		if #noteOnStack == 0 then
			track.notesOn[key] = nil
		end
		track.polyphony = track.polyphony - 1
		self.polyphony = self.polyphony - 1
		Musician.Song:SendMessage(Musician.Events.VisualNoteOff, self, track, key)
	end
end

--- Stop all notes of a track
-- @param track (table) Reference to the track
function Musician.Song:TrackNotesOff(track)
	for noteKey, noteOnStack in pairs(track.notesOn) do
		for index = #noteOnStack, 1, -1 do
			self:NoteOff(track, noteKey, index)
		end
	end
end

--- Stop all notes of the song
function Musician.Song:SongNotesOff()
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
		self:OnImportError("The song is already importing or exporting.", onComplete)
		return
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
		if not self.importing then
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
		decodedData = decodedData .. LibBase64:dec(string.sub(base64data, cursor, cursorTo))
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
		Musician.Worker.Remove(base64DecodingWorker)
		self.importing = false
		self:OnImportError(Musician.Msg.INVALID_MUSIC_CODE, onComplete)
	end)
end

--- Import song from a compressed string
-- @param compressedData (string)
-- @param crop (boolean) Automatically crop song to first and last note
-- @param[opt] onComplete (function) Called when the whole import process is complete. Argument is true when successful
function Musician.Song:ImportCompressed(compressedData, crop, onComplete)
	if self.importing or self.exporting then
		self:OnImportError("The song is already importing or exporting.", onComplete)
		return
	end
	self.importing = true

	local success = pcall(function()
		-- Get header
		local header = string.sub(compressedData, 1, #Musician.FILE_HEADER_COMPRESSED)
		if header ~= 'MUZ8' and header ~= 'MUZ7' then
			error(Musician.Msg.INVALID_MUSIC_CODE)
		end

		local cursor = #Musician.FILE_HEADER_COMPRESSED + 1
		local uncompressedData = string.gsub(header, 'MUZ', 'MUS')
		local uncompressWorker

		-- Uncompress string in a worker
		uncompressWorker = function()
			-- Importing process has been canceled
			if not self.importing then
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
			Musician.Worker.Remove(uncompressWorker)
			self.importing = false
			self:OnImportError(Musician.Msg.INVALID_MUSIC_CODE, onComplete)
		end)
	end)

	if not success then
		self.importing = false
		self:OnImportError(Musician.Msg.INVALID_MUSIC_CODE, onComplete)
	end
end

--- Import song from string
-- @param data (string)
-- @param crop (boolean) Automatically crop song to first and last note
-- @param[opt=0] previousProgression (number) Add previous progression (0-1)
-- @param[opt] onComplete (function) Called when the whole import process is complete. Argument is true when successful
function Musician.Song:Import(data, crop, previousProgression, onComplete)
	if self.importing or self.exporting then
		self:OnImportError("The song is already importing or exporting.", onComplete)
		return
	end

	local success = pcall(function()
		self.importing = true

		if previousProgression == nil then
			Musician.Song:SendMessage(Musician.Events.SongImportStart, self)
			previousProgression = 0
		end
		Musician.Song:SendMessage(Musician.Events.SongImportProgress, self, previousProgression)

		local chunksCrc32
		local readBytesInternal, getCursor = Musician.Utils.GetByteReader(data, Musician.Msg.INVALID_MUSIC_CODE)

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
		local header = readBytes(#Musician.FILE_HEADER)
		if header ~= 'MUS8' and header ~= 'MUS7' then
			error(Musician.Msg.INVALID_MUSIC_CODE)
		end
		self.header = header

		-- Song title (2) + (title length in bytes)
		local songTitleLength = Musician.Utils.UnpackNumber(readBytes(2))
		self.name = Musician.Utils.NormalizeSongName(readBytes(songTitleLength))

		-- Song mode (1)
		local mode = Musician.Utils.UnpackNumber(readBytes(1, true))
		if mode ~= Musician.Song.MODE_LIVE and mode ~= Musician.Song.MODE_DURATION then
			error("Invalid song mode.")
		end
		self.mode = mode

		-- Duration (3)
		self.duration = Musician.Utils.UnpackNumber(readBytes(3, true))
		self.cropFrom = 0
		self.cropTo = self.duration

		-- Number of tracks (1)
		local trackCount = Musician.Utils.UnpackNumber(readBytes(1, true))

		-- Track information: instrument (1), channel (1), number of notes (2)
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

			-- Track has accent
			track.accent = false

			-- Track is audible
			track.audible = not track.muted

			-- Track transposition
			track.transpose = 0

			-- Maximum note duration
			track.maxNoteDuration = 0

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
		local cropFrom
		local cropTo

		-- Import notes in a worker
		noteImportingWorker = function()
			-- Importing process has been canceled
			if not self.importing then
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

				-- Key + note type (1)
				local noteData = Musician.Utils.UnpackNumber(readBytes(1, true))

				-- This is a spacer (key 0xFF)
				if noteData == 0xFF then
					trackOffset = trackOffset + 65535 / Musician.NOTE_TIME_FPS -- 16-bit
				else
					local key = bit.band(noteData, 0x7F)
					local noteType = bit.band(noteData, 0x80) == 0x80

					-- Time (2)
					local time = trackOffset + Musician.Utils.UnpackTime(readBytes(2, true), Musician.NOTE_TIME_FPS)

					-- Note on with duration
					if self.mode == Musician.Song.MODE_DURATION then
						-- Duration (1 or 2)
						local durationBytes = noteType and 2 or 1
						local duration = Musician.Utils.UnpackTime(readBytes(durationBytes, true), Musician.NOTE_DURATION_FPS)

						-- Update song cropping
						local endTime = time + duration
						if crop then
							cropFrom = min(cropFrom or time, time)
						end
						cropTo = max(cropTo or endTime, endTime)

						-- Insert note with duration
						table.insert(track.notes, {
							[NOTE.ON] = true,
							[NOTE.KEY] = key,
							[NOTE.TIME] = time,
							[NOTE.DURATION] = duration
						})

						-- Update the max note duration
						if duration > track.maxNoteDuration then
							track.maxNoteDuration = duration
						end
					elseif self.mode == Musician.Song.MODE_LIVE then
						-- Update song cropping
						if noteType then
							if crop then
								cropFrom = min(cropFrom or time, time)
							end
						else
							cropTo = max(cropTo or time, time)
						end

						-- Insert live note event
						table.insert(track.notes, {
							[NOTE.ON] = noteType,
							[NOTE.KEY] = key,
							[NOTE.TIME] = time
						})
					end

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

				-- Track names (2) + (title length in bytes)
				for _, track in pairs(self.tracks) do
					local trackNameLength = Musician.Utils.UnpackNumber(readBytes(2))
					track.name = readBytes(trackNameLength)
				end

				-- Optional metadata
				if getCursor() < #data then

					-- Song settings (optional)
					-- ========================

					-- cropFrom (4)
					cropFrom = Musician.Utils.UnpackNumber(readBytes(4)) / 100

					-- cropTo (4)
					cropTo = Musician.Utils.UnpackNumber(readBytes(4)) / 100

					-- Track settings (optional)
					-- =========================

					for _, track in pairs(self.tracks) do
						-- Track options (1)
						local trackOptions = Musician.Utils.UnpackNumber(readBytes(1))
						local hasInstrument = bit.band(trackOptions, Musician.Song.TRACK_OPTION_HAS_INSTRUMENT) ~= 0
						local muted = bit.band(trackOptions, Musician.Song.TRACK_OPTION_MUTED) ~= 0
						local solo = bit.band(trackOptions, Musician.Song.TRACK_OPTION_SOLO) ~= 0
						local accent = bit.band(trackOptions, Musician.Song.TRACK_OPTION_ACCENT) ~= 0
						setTrackSolo(self, track, solo, false)
						setTrackMuted(self, track, muted, false)
						track.accent = accent

						-- Instrument (1)
						local instrument = Musician.Utils.UnpackNumber(readBytes(1))
						track.instrument = hasInstrument and instrument or -1

						-- Transpose (1)
						track.transpose = Musician.Utils.UnpackNumber(readBytes(1)) - 127
					end
				end

				-- Crop song
				self.cropFrom = floor((cropFrom or 0) * 100) / 100
				self.cropTo = ceil((cropTo or 0) * 100) / 100
				self:Seek(self.cropFrom)

				-- CRC32
				self.crc32 = LibCRC32:getFinalCrc(chunksCrc32)

				-- Update progression
				progression = 1
				Musician.Song:SendMessage(Musician.Events.SongImportProgress, self, progression)

				-- Import is complete!
				self.importing = false
				Musician.Song:SendMessage(Musician.Events.SongImportComplete, self)
				Musician.Song:SendMessage(Musician.Events.SongImportSuccessful, self)
				if onComplete then
					onComplete(true)
				end
			end
		end

		Musician.Worker.Set(noteImportingWorker, function()
			Musician.Worker.Remove(noteImportingWorker)
			self.importing = false
			self:OnImportError(Musician.Msg.INVALID_MUSIC_CODE, onComplete)
		end)
	end)

	if not success then
		self.importing = false
		self:OnImportError(Musician.Msg.INVALID_MUSIC_CODE, onComplete)
	end
end

--- Export song to string
-- @param onComplete (function) Called when the whole export process is complete. Data is provided when successful
-- @param[opt=1] progressionFactor (number) (0-1)
function Musician.Song:Export(onComplete, progressionFactor)
	if self.importing or self.exporting then
		self:OnExportError("The song is already importing or exporting.", onComplete)
		return
	end
	self.exporting = true

	-- Invalid song mode
	if self.mode ~= Musician.Song.MODE_LIVE and self.mode ~= Musician.Song.MODE_DURATION then
		self.exporting = false
		self:OnExportError("Invalid song mode.", onComplete)
		return
	end

	if progressionFactor == nil then
		progressionFactor = 1
	end

	Musician.Song:SendMessage(Musician.Events.SongExportStart, self)
	Musician.Song:SendMessage(Musician.Events.SongExportProgress, self, 0)

	local data = ''

	-- Song header
	-- ===========

	-- Header (4)
	data = data .. self.header

	-- Song title (2) + (title length in bytes)
	data = data .. Musician.Utils.PackNumber(#self.name, 2) .. self.name

	-- Song mode (1)
	data = data .. Musician.Utils.PackNumber(self.mode, 1)

	-- Duration (3)
	data = data .. Musician.Utils.PackNumber(self.duration, 3)

	-- Number of tracks (1)
	data = data .. Musician.Utils.PackNumber(#self.tracks, 1)

	-- Tracks and notes
	-- ================

	local notesData = ''
	local exportedNotes = 0
	local trackIndex = 1
	local noteIndex = 1
	local offset = 0
	local noteExportingWorker
	local trackNoteCount = {}

	-- Count total amount of notes
	local noteCount = 0
	for _, track in pairs(self.tracks) do
		noteCount = noteCount + #track.notes
		trackNoteCount[track.index] = 0
	end

	-- Export notes in a worker
	noteExportingWorker = function()
		-- Exporting process has been canceled
		if not self.exporting then
			Musician.Worker.Remove(noteExportingWorker)
			return
		end

		-- Export some notes
		local notesDataChunk = ''
		local trackNotesDataChunkCount = 0
		local track = self.tracks[trackIndex]
		local stopOnNoteCount = min(exportedNotes + EXPORT_NOTE_RATE, noteCount)
		while exportedNotes < stopOnNoteCount do
			local note = track.notes[noteIndex]

			if note == nil then
				-- No more note in this track: skip to next track

				trackNoteCount[track.index] = trackNoteCount[track.index] + trackNotesDataChunkCount
				trackIndex = trackIndex + 1
				track = self.tracks[trackIndex]
				trackNotesDataChunkCount = 0
				noteIndex = 1
				offset = 0

			elseif note[NOTE.KEY] >= 0 and note[NOTE.KEY] < 127 then
				-- Ignore notes that are not within the MIDI range
				-- Also ignore notes with key = 127 to avoid notes type 1 being taken for a separator (0xFF).

				trackNotesDataChunkCount = trackNotesDataChunkCount + 1
				local noteTime = note[NOTE.TIME] - offset

				-- Insert note spacers if needed
				local noteSpacer = ''
				while noteTime > Musician.MAX_NOTE_TIME do
					noteSpacer = noteSpacer .. Musician.Utils.PackNumber(0xFF, 1)
					noteTime = noteTime - Musician.MAX_NOTE_TIME
					offset = offset + Musician.MAX_NOTE_TIME
				end
				notesDataChunk = notesDataChunk .. noteSpacer

				-- Pack time
				local timeFrames = floor(noteTime * Musician.NOTE_TIME_FPS + .5)

				-- Duration mode
				if self.mode == Musician.Song.MODE_DURATION then
					-- Pack duration
					local maxDuration = self.header == 'MUS8' and note[NOTE.KEY] < 127 and Musician.MAX_LONG_NOTE_DURATION or
						Musician.MAX_NOTE_DURATION
					local duration = max(0, min(note[NOTE.DURATION], maxDuration))
					local durationFrames = floor(duration * Musician.NOTE_DURATION_FPS + .5)

					-- Determine if it's a long note or a short one
					local isLongNote = durationFrames > 0xFF

					-- Key and note flag (1)
					local noteFlag = isLongNote and 0x80 or 0x00
					notesDataChunk = notesDataChunk .. Musician.Utils.PackNumber(bit.bor(note[NOTE.KEY], noteFlag), 1)

					-- Time (2)
					notesDataChunk = notesDataChunk .. Musician.Utils.PackNumber(timeFrames, 2)

					-- Duration (1 or 2)
					local durationBytes = isLongNote and 2 or 1
					notesDataChunk = notesDataChunk .. Musician.Utils.PackNumber(durationFrames, durationBytes)
				elseif self.mode == Musician.Song.MODE_LIVE then
					-- Key on/off event (1)
					local noteFlag = note[NOTE.ON] and 0x80 or 0x00
					notesDataChunk = notesDataChunk .. Musician.Utils.PackNumber(bit.bor(note[NOTE.KEY], noteFlag), 1)

					-- Time (2)
					notesDataChunk = notesDataChunk .. Musician.Utils.PackNumber(timeFrames, 2)
				end
			end

			-- Proceed with the next note
			if note ~= nil then
				exportedNotes = exportedNotes + 1
				noteIndex = noteIndex + 1
			end
		end

		trackNoteCount[track.index] = trackNoteCount[track.index] + trackNotesDataChunkCount

		notesData = notesData .. notesDataChunk

		if noteCount > 0 then
			Musician.Song:SendMessage(Musician.Events.SongExportProgress, self, progressionFactor * exportedNotes / noteCount)
		end

		-- All notes have been exported
		if exportedNotes == noteCount then
			Musician.Worker.Remove(noteExportingWorker)

			-- Add track data
			local tracksData = ''
			for _, t in pairs(self.tracks) do
				-- Instrument (1)
				tracksData = tracksData .. Musician.Utils.PackNumber(t.midiInstrument, 1)

				-- Channel (1)
				tracksData = tracksData .. Musician.Utils.PackNumber(t.channel or 0, 1)

				-- Note count (2)
				tracksData = tracksData .. Musician.Utils.PackNumber(trackNoteCount[t.index], 2)
			end
			data = data .. tracksData

			-- Add note data
			data = data .. notesData

			-- Metadata
			-- ========

			local metadata = ''

			-- Track names (2) + (title length in bytes)
			for _, t in pairs(self.tracks) do
				local trackName = t.name or ''
				metadata = metadata .. Musician.Utils.PackNumber(#trackName, 2) .. trackName
			end

			-- Song settings
			-- =============

			-- cropFrom (4)
			metadata = metadata .. Musician.Utils.PackNumber(floor(self.cropFrom * 100), 4)

			-- cropTo (4)
			metadata = metadata .. Musician.Utils.PackNumber(ceil(self.cropTo * 100), 4)

			-- Track settings
			-- ==============

			for _, t in pairs(self.tracks) do

				-- Track options (1)
				local hasInstrument = (t.instrument ~= -1) and Musician.Song.TRACK_OPTION_HAS_INSTRUMENT or 0
				local muted = t.muted and Musician.Song.TRACK_OPTION_MUTED or 0
				local solo = t.solo and Musician.Song.TRACK_OPTION_SOLO or 0
				local accent = t.accent and Musician.Song.TRACK_OPTION_ACCENT or 0
				local trackOptions = bit.bor(hasInstrument, muted, solo, accent)
				metadata = metadata .. Musician.Utils.PackNumber(trackOptions, 1)

				-- Instrument (1)
				local instrument = hasInstrument and t.instrument or 0
				metadata = metadata .. Musician.Utils.PackNumber(instrument, 1)

				-- Transpose (1)
				metadata = metadata .. Musician.Utils.PackNumber(t.transpose + 127, 1)
			end

			-- Append metadata
			data = data .. metadata

			-- Export complete!

			self.exporting = false

			if progressionFactor == 1 then
				Musician.Song:SendMessage(Musician.Events.SongExportComplete, self)
			end

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
			if not self.exporting then
				Musician.Worker.Remove(compressChunkWorker)
				return
			end

			-- Exporting process is complete
			if bytesToRead == 0 then
				Musician.Worker.Remove(compressChunkWorker)
				self.exporting = false
				Musician.Song:SendMessage(Musician.Events.SongExportComplete, self)
				onComplete(compressedData)
				return
			end

			-- Compress chunk
			local chunkSize
			local chunk

			-- First chunk: Uncompressed header + compressed song title only
			if compressedData == '' then
				-- Header
				compressedData = string.gsub(self.header, 'MUS', 'MUZ')
				readBytes(#Musician.FILE_HEADER)

				-- Title
				local packedTitleLength = readBytes(2)
				local titleLength = Musician.Utils.UnpackNumber(packedTitleLength)
				local title = readBytes(titleLength)
				chunkSize = 2 + titleLength
				chunk = packedTitleLength .. title
			else
				chunkSize = min(DEFLATE_CHUNK_SIZE, bytesToRead)
				chunk = readBytes(chunkSize)
			end

			local compressedChunk = LibDeflate:CompressDeflate(chunk, { level = 9 })
			bytesToRead = bytesToRead - chunkSize
			compressedData = compressedData .. Musician.Utils.PackNumber(#compressedChunk, 2) .. compressedChunk

			local progression = 1 - COMPRESS_PROGRESSION_RATIO + COMPRESS_PROGRESSION_RATIO * (1 - bytesToRead / #data)
			Musician.Song:SendMessage(Musician.Events.SongExportProgress, self, progression)
		end
		Musician.Worker.Set(compressChunkWorker)
	end, 1 - COMPRESS_PROGRESSION_RATIO)
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
-- @param msg (string) Error message
-- @param[opt] onComplete (function)
function Musician.Song:OnImportError(msg, onComplete)
	Musician.Song:SendMessage(Musician.Events.SongImportComplete, self)
	Musician.Song:SendMessage(Musician.Events.SongImportFailed, self)
	if onComplete then
		onComplete(false)
	end
	Musician.Utils.Error(msg)
end

--- Handle exporting error
-- @param msg (string) Error message
-- @param[opt] onComplete (function)
function Musician.Song:OnExportError(msg, onComplete)
	Musician.Song:SendMessage(Musician.Events.SongExportComplete, self)
	if onComplete then
		onComplete()
	end
	Musician.Utils.Error(msg)
end

--- Clone song
-- @return song (Musician.Song)
function Musician.Song:Clone()

	local song = Musician.Song.create()

	for key, value in pairs(self) do
		song[key] = Musician.Utils.DeepCopy(value)
	end

	-- Stop playing and streaming to avoid unexpected behavior
	song.playing = false
	song.streaming = false

	return song
end

--- Completely wipes the song data from memory.
function Musician.Song:Wipe()
	-- Already wiped
	if not self.tracks then	return end

	-- Wipe tracks
	for _, track in next, self.tracks, nil do
		-- Track notes
		for _, note in next, track.notes, nil do
			wipe(note)
		end
		wipe(track.notes)
		-- Track notes on
		for _, noteOn in next, track.notesOn, nil do
			wipe(noteOn)
		end
		wipe(track.notesOn)
	end
	wipe(self.tracks)

	-- Wipe object
	wipe(self)
end

--- Stream song
function Musician.Song:Stream()
	Musician.Utils.Debug(MODULE_NAME, "Stream", self.name)

	-- Stop song if playing
	removePlayingSong(self)
	self.playing = false

	-- Stop and reset streaming
	self:StopStreaming()

	-- Init stream indexes
	for _, track in pairs(self.tracks) do
		track.streamIndex = trackSeek(self.cropFrom, track)

		-- Move streamIndex backwards to the earliest playing note (for non-"plucked" instruments)
		if not Musician.Sampler.IsInstrumentPlucked(track.instrument) then
			for noteIndex = track.streamIndex - 1, 1, -1 do
				local time = track.notes[noteIndex][NOTE.TIME]
				-- No need to seek if the maximum note duration was exceeded
				if time + track.maxNoteDuration < self.cursor then
					break
				end
				local duration = track.notes[noteIndex][NOTE.DURATION]
				if duration ~= nil and time + duration > self.cursor then
					track.streamIndex = noteIndex
				end
			end
		end
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
	if not self.streaming then return end
	Musician.Utils.Debug(MODULE_NAME, "StopStreaming", self.name)
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

	self.mode = mode
	self.songId = songId
	self.player = player
	self.chunkDuration = chunkDuration
	self.cropTo = max(self.cropTo, self.chunkTime + playtimeLeft)
	self.duration = ceil(self.cropTo)

	for _, trackData in pairs(chunk) do
		if self.tracks[trackData[CHUNK.TRACK_ID]] == nil then
			self.tracks[trackData[CHUNK.TRACK_ID]] = {
				index = trackData[CHUNK.TRACK_ID],
				midiInstrument = nil,
				instrument = nil,
				notes = {},
				playIndex = 1,
				audible = true,
				muted = false,
				solo = false,
				transpose = 0,
				maxNoteDuration = 0,
				notesOn = {},
				polyphony = 0,
				channel = nil,
				name = nil
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
		for _, note in pairs(trackData[CHUNK.NOTES]) do
			note[NOTE.TIME] = note[NOTE.TIME] + noteOffset
			noteOffset = note[NOTE.TIME]
			self.cropTo = max(self.cropTo, note[NOTE.TIME] + (note[NOTE.DURATION] or 0))

			-- Insert received note if the key is within allowed range
			if note[NOTE.KEY] >= Musician.MIN_KEY and note[NOTE.KEY] <= Musician.MAX_KEY then
				table.insert(track.notes, note)
				if note[NOTE.DURATION] ~= nil and note[NOTE.DURATION] > track.maxNoteDuration then
					track.maxNoteDuration = note[NOTE.DURATION]
				end
			end
		end
	end

	self.chunkTime = self.chunkTime + self.chunkDuration
end

--- Stream a chunk of the song on frame
-- @param elapsed (number)
function Musician.Song:StreamOnFrame(elapsed)

	if not self.streaming then
		return
	end

	self.timeSinceLastStreamChunk = self.timeSinceLastStreamChunk + elapsed

	if self.timeSinceLastStreamChunk >= self.chunkDuration then
		self.timeSinceLastStreamChunk = self.timeSinceLastStreamChunk - self.chunkDuration
	else
		return
	end

	local from = self.streamPosition
	local to = from + self.chunkDuration

	local chunk = {}

	for _, track in pairs(self.tracks) do
		if track.streamIndex == nil then
			track.streamIndex = 1
		end

		-- Notes On and Notes Off
		local notes = {}
		local noteOffset = from
		while track.notes[track.streamIndex] and (track.notes[track.streamIndex][NOTE.TIME] < to) and
			(track.notes[track.streamIndex][NOTE.TIME] <= self.cropTo) do
			local note = track.notes[track.streamIndex]
			local on = note[NOTE.ON]
			local time = note[NOTE.TIME]
			local duration = note[NOTE.DURATION]
			local endTime = duration and (time + duration)
			if from <= time or (duration ~= nil and from <= endTime) then
				if track.audible and track.instrument >= 0 and track.instrument <= 255 then
					local key = note[NOTE.KEY] + track.transpose

					-- Send note if key is within allowed range
					if key >= Musician.MIN_KEY and key <= Musician.MAX_KEY then
						-- Already "playing" note: adjust time and duration
						if time < from then
							if duration ~= nil then
								duration = duration - (from - time)
							end
							time = from
						end

						-- Adjust duration if the note ends after the cropTo point
						if duration ~= nil and endTime > self.cropTo then
							duration = self.cropTo - time
						end

						-- Calculate relative time
						local relativeTime = time - noteOffset

						-- Insert note in chunk data
						table.insert(notes, {
							[NOTE.ON] = on,
							[NOTE.KEY] = key,
							[NOTE.TIME] = relativeTime,
							[NOTE.DURATION] = duration
						})

						-- Insert doubled note if the track has accent
						if track.accent then
							table.insert(notes, {
								[NOTE.ON] = on,
								[NOTE.KEY] = key,
								[NOTE.TIME] = 0,
								[NOTE.DURATION] = duration
							})
						end

						noteOffset = noteOffset + relativeTime
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
	for _, trackData in pairs(chunk) do
		packedTrackInfo = packedTrackInfo .. Musician.Utils.PackNumber(trackData[CHUNK.TRACK_ID], 1)
		packedTrackInfo = packedTrackInfo .. Musician.Utils.PackNumber(trackData[CHUNK.INSTRUMENT], 1)
		packedTrackInfo = packedTrackInfo .. Musician.Utils.PackNumber(#trackData[CHUNK.NOTES], 2)
	end

	-- Note information: key on/off or spacer (1), time (1), [duration (1)]
	local packedNoteData = ''
	for _, trackData in pairs(chunk) do
		for _, note in pairs(trackData[CHUNK.NOTES]) do

			-- Get note time relatively to previous note
			local noteTime = note[NOTE.TIME]

			-- Get note type and duration
			local noteType, duration, durationFrames
			if self.mode == Musician.Song.MODE_DURATION then
				duration = max(0, min(Musician.MAX_LONG_NOTE_DURATION, note[NOTE.DURATION]))
				durationFrames = floor(duration * Musician.NOTE_DURATION_FPS + .5)
				noteType = durationFrames > 0xFF -- true for a long note, false for a short one
			else
				noteType = note[NOTE.ON] -- Live note on or note off
			end

			-- Insert spacers if note time exceeds the maximum
			while noteTime > Musician.MAX_CHUNK_NOTE_TIME do
				packedNoteData = packedNoteData .. Musician.Utils.PackNumber(0xFF, 1)
				noteTime = noteTime - Musician.MAX_CHUNK_NOTE_TIME
			end

			-- First bit: type, the rest: key (1 byte)
			local noteFlag = noteType and 0x80 or 0x00
			local packedKey = Musician.Utils.PackNumber(bit.bor(noteFlag, note[NOTE.KEY]), 1)

			-- Note time (1 byte)
			local packedTime = Musician.Utils.PackTime(noteTime, 1, Musician.NOTE_TIME_FPS)

			-- Duration (1 or 2 bytes)
			local packedDuration = ""
			if self.mode == Musician.Song.MODE_DURATION then
				local durationBytes = noteType and 2 or 1
				packedDuration = Musician.Utils.PackNumber(durationFrames, durationBytes)
			end

			packedNoteData = packedNoteData .. packedKey .. packedTime .. packedDuration
		end
	end

	return packedVersionAndMode ..
		packedChunkDuration ..
		packedSongId ..
		packedPlaytimeLeft ..
		packedPlayerPosition ..
		packedTrackCount ..
		packedTrackInfo ..
		packedNoteData
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
function Musician.Song.UnpackChunkHeader(data)

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

	if not success then
		return nil
	end

	return mode, songId, chunkDuration, playtimeLeft, position, trackCount, 24
end

--- Unpack song chunk data
-- @param data (string)
-- @return chunk (table)
function Musician.Song.UnpackChunkData(data)

	-- Get header data
	local mode, _, _, _, _, trackCount, headerLength = Musician.Song.UnpackChunkHeader(data)

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
		for _ = 1, trackCount do
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
		for t, trackData in pairs(chunk) do
			for _ = 1, trackData[CHUNK.NOTE_COUNT] do
				-- Key, note on/off or spacer (1)
				local offset = 0
				local keyByte = Musician.Utils.UnpackNumber(readBytes(1))

				-- Spacer bytes
				while keyByte == 255 do
					offset = offset + Musician.MAX_CHUNK_NOTE_TIME
					keyByte = Musician.Utils.UnpackNumber(readBytes(1))
				end

				-- Note type
				local noteType = bit.band(keyByte, 0x80) == 0x80

				-- Key
				local key = bit.band(keyByte, 0x7F)

				-- Time relative to previous note
				local time = Musician.Utils.UnpackTime(readBytes(1), Musician.NOTE_TIME_FPS) + offset

				-- Note duration, note on
				local duration, noteOn
				if mode == Musician.Song.MODE_DURATION then
					local durationBytes = noteType and 2 or 1
					duration = Musician.Utils.UnpackTime(readBytes(durationBytes), Musician.NOTE_DURATION_FPS)
					noteOn = true
				else
					noteOn = noteType
				end

				-- Insert decoded note
				table.insert(chunk[t][CHUNK.NOTES], {
					[NOTE.ON] = noteOn,
					[NOTE.KEY] = key,
					[NOTE.TIME] = time,
					[NOTE.DURATION] = duration
				})
			end
		end
	end)

	if not success then
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

	for _, track in pairs(self.tracks) do
		for _, note in pairs(track.notes) do
			if note[NOTE.DURATION] then
				table.insert(track.notes, {
					[NOTE.ON] = false,
					[NOTE.KEY] = note[NOTE.KEY],
					[NOTE.TIME] = note[NOTE.TIME] + note[NOTE.DURATION] - 1 / 30
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