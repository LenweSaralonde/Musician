Musician.Song = {}
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
Musician.Song.Indexes.NOTEON.DECAY = 4

Musician.Song.Indexes.CHUNK = {}
Musician.Song.Indexes.CHUNK.SONG_ID = 1
Musician.Song.Indexes.CHUNK.TRACK_ID = 2
Musician.Song.Indexes.CHUNK.INSTRUMENT = 3
Musician.Song.Indexes.CHUNK.NOTES = 4
Musician.Song.Indexes.CHUNK.NOTE_COUNT = 5

local NOTE = Musician.Song.Indexes.NOTE
local NOTEON = Musician.Song.Indexes.NOTEON
local CHUNK = Musician.Song.Indexes.CHUNK

local CHUNK_MODE_DURATION = 0x10 -- Duration are set in chunk notes
local CHUNK_MODE_LIVE = 0x20 -- No duration in chunk notes
local CHUNK_VERSION = 0x01 -- Max: 0x0F (15)

-- Private functions
local StreamChunk

--- Constructor
-- @param packedSongData (string)
-- @param crop (boolean)
function Musician.Song.create(packedSongData, crop)
	local self = {}
	setmetatable(self, Musician.Song)

	-- @field id (number) Song ID, used for streaming
	self.id = nil

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

	-- @field cropFrom (number) Play song from this position
	self.cropFrom = 0

	-- @field cropTo (number) Play song until this position
	self.cropTo = 0

	-- @field cursor (number) Cursor position, in seconds
	self.cursor = 0

	-- @field soloTracks (number) Number of tracks in solo
	self.soloTracks = 0

	-- @field polyphony (number) Current polyphony
	self.polyphony = 0

	-- @field drops (number) Dropped notes
	self.drops = 0

	if packedSongData then
		self:Unpack(packedSongData, crop)
	end

	return self
end

--- Returns song ID
-- @return (number)
function Musician.Song:GetId()
	if self.songId == nil then
		self.songId = Musician.nextSongId
		Musician.nextSongId = Musician.nextSongId + 1
	end

	return self.songId
end

--- Returns true if the song is playing or about to be played (preloading).
-- @return (boolean)
function Musician.Song:IsPlaying()
	return self.playing or self.willPlayTimer ~= nil
end

--- Mute or unmute track
-- @param track (object)
-- @param isMuted (boolean)
function Musician.Song:SetTrackMuted(track, isMuted)
	if isMuted then
		self:TrackNotesOff(track)
	end

	track.muted = isMuted
end

--- Returns true if the track is muted
-- @param track (object)
-- @return (boolean)
function Musician.Song:TrackIsMuted(track)
	return track.muted or self.soloTracks > 0 and not(track.solo)
end

--- Set/unset track solo
-- @param track (object)
-- @param isMuted (boolean)
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
				self:TrackNotesOff(track)
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
		Musician.Comm:SendMessage(Musician.Events.SongPlay, self)
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
	Musician.Comm:SendMessage(Musician.Events.SongCursor, self)
end

--- Resume a song playing
-- @param eventSent (boolean)
function Musician.Song:Resume(eventSent)
	self.playing = true
	if not(eventSent) then
		Musician.Comm:SendMessage(Musician.Events.SongPlay, self)
	end
end

--- Stop song
function Musician.Song:Stop()
	self:SongNotesOff()
	if self.willPlayTimer then
		self.willPlayTimer:Cancel()
		self.willPlayTimer = nil
	end
	self.playing = false
	Musician.Comm:SendMessage(Musician.Events.SongStop, self)
end

--- Main on update function, play notes accordingly to every frame.
-- @param elapsed (number)
function Musician.Song:OnUpdate(elapsed)
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

	Musician.Comm:SendMessage(Musician.Events.SongCursor, self)

	-- Dropped notes
	if drops > 0 then
		self.drops = self.drops + drops
		Musician.Comm:SendMessage(Musician.Events.NoteDropped, self, self.drops, drops)
	end

	-- Song has ended
	if to >= self.cropTo then
		self:Stop()
	end
end

--- Play a note
-- @param track (table) Reference to the track
-- @param noteIndex (int) Note index
-- @param noRetry (boolean) Do not attempt to recover dropped notes
function Musician.Song:NoteOn(track, noteIndex, noRetry)
	local key = track.notes[noteIndex][NOTE.KEY] + track.transpose
	local time = track.notes[noteIndex][NOTE.TIME]
	local duration = track.notes[noteIndex][NOTE.DURATION]
	local soundFile, instrumentData = Musician.Utils.GetSoundFile(track.instrument, key)
	if soundFile == nil then
		return
	end

	-- Send notification emote
	if self.player ~= nil and Musician.Registry.PlayerIsInRange(self.player, Musician.LISTENING_RADIUS) and not(self.notified) then
		Musician.Utils.DisplayEmote(self.player, Musician.Registry.GetPlayerGUID(self.player), Musician.Msg.EMOTE_PLAYING_MUSIC)
		self.notified = true
	end

	-- Do not play note if the source song is playing or if the player is out of range
	local sourceSongIsPlaying = Musician.sourceSong ~= nil and Musician.sourceSong:IsPlaying()
	if self.player ~= nil and (sourceSongIsPlaying or not(Musician.Registry.PlayerIsInRange(self.player, Musician.LISTENING_RADIUS))) or self:TrackIsMuted(track) or Musician.globalMute or Musician.PlayerIsMuted(self.player) then
		return
	end

	-- The note cannot be already playing on the same track
	self:NoteOff(track, key)

	-- Play note sound file
	local play, handle = Musician.Utils.PlayNote(track.instrument, key)

	-- Note dropped: interrupt the oldest one and retry
	if not(play) and not(noRetry) then
		self:StopOldestNote()
		C_Timer.After(0, function()
			self:NoteOn(track, noteIndex, true)
		end)
		return
	end

	-- Add note to notesOn with sound handle and note off time
	if play then
		local endTime = nil
		if duration ~= nil then
			endTime = self.cursor + duration
		end

		track.notesOn[key] = {
			[NOTEON.TIME] = time,
			[NOTEON.ENDTIME] = endTime,
			[NOTEON.HANDLE] = handle,
			[NOTEON.DECAY] = instrumentData.decay
		}

		track.polyphony = track.polyphony + 1
		self.polyphony = self.polyphony + 1
		Musician:SendMessage(Musician.Events.NoteOn, self, track, noteIndex, endTime, instrumentData.decay)
	end
end

--- Stop a note of a track
-- @param track (table) Reference to the track
-- @param key (int) Note key
function Musician.Song:NoteOff(track, key)
	if track.notesOn[key] ~= nil then
		local handle = track.notesOn[key][NOTEON.HANDLE]
		StopSound(handle, track.notesOn[key][NOTEON.DECAY])
		track.notesOn[key] = nil
		track.polyphony = track.polyphony - 1
		self.polyphony = self.polyphony - 1
		Musician:SendMessage(Musician.Events.NoteOff, self, track, key)
	end
end

--- Stop all notes of a track
-- @param track (table) Reference to the track
function Musician.Song:TrackNotesOff(track)
	local noteKey, noteOn
	for noteKey, noteOn in pairs(track.notesOn) do
		self:NoteOff(track, noteKey)
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
		foundTrack.notesOn[foundNoteKey][NOTEON.DECAY] = 0 -- Remove decay
		self:NoteOff(foundTrack, foundNoteKey)
	end
end

--- Unpack note from string
-- @param str (string)
-- @param fps (float)
-- @return (table)
function Musician.Song:UnpackNote(str, fps)
	-- KTTD : key, time, duration
	local key = Musician.Utils.UnpackNumber(string.sub(str, 1, 1))
	local time = Musician.Utils.UnpackTime(string.sub(str, 2, 3), fps)
	local duration = Musician.Utils.UnpackTime(string.sub(str, 4, 4), Musician.DURATION_FPS)

	return {
		[NOTE.ON] = true,
		[NOTE.KEY] = key,
		[NOTE.TIME] = time,
		[NOTE.DURATION] = duration
	}
end

--- Unpack a track from string
-- @param str (string)
-- @param fps (float)
-- @return (table)
function Musician.Song:UnpackTrack(str, fps)
	local track = {}

	-- TINN : Track Id, instrument ID, Number of notes
	track.id = Musician.Utils.UnpackNumber(string.sub(str, 1, 1))
	track.midiInstrument = Musician.Utils.UnpackNumber(string.sub(str, 2, 2))
	track.instrument = track.midiInstrument

	local noteCount  = Musician.Utils.UnpackNumber(string.sub(str, 3, 4))

	track.notes = {}
	local noteId
	for noteId = 0, noteCount - 1 do
		local cursor = 5 + noteId * 4 -- Notes are 4-byte long
		table.insert(track.notes, self:UnpackNote(string.sub(str, cursor, cursor + 3), fps))
	end

	-- Current playing note index
	track.playIndex = 1

	-- Track is muted
	track.muted = (noteCount == 0)

	-- Track is solo
	track.solo = false

	-- Track transposition
	track.transpose = 0

	-- Notes currently playing
	track.notesOn = {}

	-- Polyphony
	track.polyphony = 0

	-- Channel number
	track.channel = nil

	-- Track name
	track.name = nil

	return track
end

--- Unpack song metadata from string
-- @param str (string)
function Musician.Song:UnpackMetadata(str)
	local cursor = 1

	while cursor <= string.len(str) do

		-- TRN: Track names
		if string.sub(str, cursor, cursor + 2) == 'TRN' then
			cursor = cursor + 3
			local track

			for	_, track in pairs(self.tracks) do
				local length = Musician.Utils.UnpackNumber(string.sub(str, cursor, cursor))
				if length > 0 then
					track.name = string.sub(str, cursor + 1, cursor + length)
				end
				cursor = cursor + length + 1
			end

		-- TRC: Track channels
		elseif string.sub(str, cursor, cursor + 2) == 'TRC' then
			cursor = cursor + 3
			local track
			for	_, track in pairs(self.tracks) do
				track.channel = Musician.Utils.UnpackNumber(string.sub(str, cursor, cursor))
				cursor = cursor + 1
			end

		-- DRK: Drum Kits
		elseif string.sub(str, cursor, cursor + 2) == 'DRK' then
			cursor = cursor + 3
			local track
			for	_, track in pairs(self.tracks) do
				if track.instrument >= 128 then
					track.instrument = 128 + Musician.Utils.UnpackNumber(string.sub(str, cursor, cursor))
					cursor = cursor + 1
				end
			end

			-- Unsupported
		else
			return

		end
	end
end

--- Unpack a song from string
-- @param str (string)
-- @param crop (boolean)
function Musician.Song:Unpack(str, crop)
	local cursor = 1

	-- Check format
	if string.sub(str, 1, string.len(Musician.FILE_HEADER)) ~= Musician.FILE_HEADER then
		error(Musician.Msg.INVALID_MUSIC_CODE)
	end
	cursor = cursor + string.len(Musician.FILE_HEADER)

	-- Song name length (1), song name
	local songNameLength = Musician.Utils.UnpackNumber(string.sub(str, cursor, cursor))
	cursor = cursor + 1
	self.name = string.sub(str, cursor, cursor + songNameLength - 1)
	cursor = cursor + songNameLength

	-- song duration (2)
	local duration = Musician.Utils.UnpackNumber(string.sub(str, cursor, cursor + 1))
	local fps = 65535 / duration -- 2^16
	self.duration = duration
	if crop then
		self.cropTo = 0
		self.cropFrom = self.duration
	else
		self.cropTo = self.duration
		self.cropFrom = 0
	end

	cursor = cursor + 2

	-- number of tracks (1)
	local trackCount = Musician.Utils.UnpackNumber(string.sub(str, cursor, cursor))
	cursor = cursor + 1

	-- tracks
	local trackId
	self.tracks = {}
	for trackId = 0, trackCount - 1 do
		local trackLength = Musician.Utils.UnpackNumber(string.sub(str, cursor + 2, cursor + 3))
		local trackEnd = cursor + 3 + trackLength * 4
		local track = self:UnpackTrack(string.sub(str, cursor, trackEnd), fps)
		track.index = trackId + 1
		table.insert(self.tracks, track)
		if track.notes[NOTE.KEY] ~= nil and crop then
			local noteCount = #track.notes
			self.cropFrom = min(self.cropFrom, track.notes[1][NOTE.TIME])
			self.cropTo = max(self.cropTo, track.notes[noteCount][NOTE.TIME] + (track.notes[noteCount][NOTE.DURATION] or 0))
		end
		cursor = trackEnd + 1
	end

	-- metadata
	self:UnpackMetadata(string.sub(str, cursor))

	self.cursor = self.cropFrom
end

--- Clone song
-- @return (Musician.Song)
function Musician.Song:Clone(str, crop)

	local clone = Musician.Song.create()
	local key, value

	for key, value in pairs(self) do
		clone[key] = Musician.Utils.DeepCopy(value)
	end
	return clone
end

--- Stream song
function Musician.Song:Stream()
	self:StopStreaming() -- Stop and reset streaming
	self.streaming = true
	StreamChunk(self)
	self.streamingTimer = C_Timer.NewTicker(Musician.CHUNK_DURATION, function() StreamChunk(self) end);
end

--- Stop streaming song
function Musician.Song:StopStreaming()
	self.streaming = false

	if self.streamingTimer ~= nil then
		self.streamingTimer:Cancel()
		self.streamingTimer = nil
	end

	local track
	for _, track in pairs(self.tracks) do
		track.streamIndex = nil
	end

	self.streamPosition = self.cropFrom
	self.songId = nil
end

--- Append chunk data to current song
-- @param chunk (table)
function Musician.Song:AppendChunk(chunk)

	local CROP_OFFSET = 10 -- TODO: Workaround for empty chunks

	if self.chunkCount == nil then
		self.chunkCount = 0
	end

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

		track.instrument = trackData[CHUNK.INSTRUMENT]
		track.midiInstrument = trackData[CHUNK.INSTRUMENT]

		local noteOffset = max(self.chunkCount * Musician.CHUNK_DURATION, self.cursor + Musician.CHUNK_DURATION / 2)
		local note
		for _, note in pairs(trackData[CHUNK.NOTES]) do
			note[NOTE.TIME] = note[NOTE.TIME] + noteOffset
			noteOffset = note[NOTE.TIME]
			self.cropTo = max(self.cropTo, CROP_OFFSET + note[NOTE.TIME] + note[NOTE.DURATION])
			table.insert(track.notes, note)
		end
	end

	self.chunkCount = self.chunkCount + 1
	self.cropTo = max(self.cropTo, CROP_OFFSET + max(self.chunkCount * Musician.CHUNK_DURATION, self.cursor + Musician.CHUNK_DURATION / 2))
end

--- Stream a chunk of the song
-- Private
-- @param self (Musician.Song)
StreamChunk = function(self)

	local from = self.streamPosition
	local to = from	+ Musician.CHUNK_DURATION

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
	local packedChunk = Musician.Song.PackChunk(chunk, self:GetId())

	Musician.Comm.StreamSongChunk(packedChunk)

	if self.streamPosition >= self.cropTo then
		self:StopStreaming()
	end
end

--- Pack a song chunk
-- @param chunk (table)
-- @param songId (number)
-- @return (string)
Musician.Song.PackChunk = function(chunk, songId)

	local mode = CHUNK_MODE_DURATION
	local chunkDuration = Musician.CHUNK_DURATION

	-- Chunk version and mode (1)
	local packedVersionAndMode = Musician.Utils.PackNumber(bit.bor(mode, CHUNK_VERSION), 1)

	-- Chunk duration (1)
	local packedChunkDuration = Musician.Utils.PackNumber(chunkDuration, 1)

	-- Song ID (1)
	local packedSongId = Musician.Utils.PackNumber(songId % 255, 1)

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

	-- Note information: time (1), on/off + key(1), [duration (1)]
	local packedNoteData = ''
	local note
	for _, trackData in pairs(chunk) do
		for _, note in pairs(trackData[CHUNK.NOTES]) do
			-- Consider a whole chunk to last 255
			local packedTime = Musician.Utils.PackTime(note[NOTE.TIME], 1, Musician.CHUNK_FPS)

			-- First bit: note on, the rest: key (C0 is 0)
			local packedNoteOnAndKey = Musician.Utils.PackNumber(bit.bor(note[NOTE.ON] and 0x80, bit.band(note[NOTE.KEY] - Musician.C0_INDEX, 0x7F)), 1)

			-- Duration (MAX_NOTE_DURATION is 255)
			local packedDuration = ""
			if note[NOTE.ON] and mode == CHUNK_MODE_DURATION then
				packedDuration = Musician.Utils.PackTime(min(note[NOTE.DURATION], Musician.MAX_NOTE_DURATION), 1, Musician.DURATION_FPS)
			end

			packedNoteData = packedNoteData .. packedTime .. packedNoteOnAndKey .. packedDuration
		end
	end

	return packedVersionAndMode .. packedChunkDuration .. packedSongId .. packedPlayerPosition .. packedTrackCount .. packedTrackInfo .. packedNoteData
end

--- Unpack a song chunk
-- @param chunk (table)
-- @return (table), (number), (number), (table) chunk, song ID, chunk duration, player position and GUID
Musician.Song.UnpackChunk = function(str)

	local chunk = {}
	local cursor

	-- Version (1)
	local version = bit.band(Musician.Utils.UnpackNumber(string.sub(str, 1, 1)), 0x0f)
	local mode = bit.band(Musician.Utils.UnpackNumber(string.sub(str, 1, 1)), 0xf0)

	-- Chunk duration (1)
	local chunkDuration = Musician.Utils.UnpackNumber(string.sub(str, 2, 2))

	-- Song ID (1)
	local songId = Musician.Utils.UnpackNumber(string.sub(str, 3, 3))

	-- Player position (18)
	local position = { Musician.Utils.UnpackPlayerPosition(string.sub(str, 4, 21)) }

	-- Number of tracks (1)
	local trackCount = Musician.Utils.UnpackNumber(string.sub(str, 22, 22))

	-- Track information: trackId (1), instrumentId (1), note count (2)
	cursor = 23
	local t, trackData
	for t = 1, trackCount do
		table.insert(chunk, {
			[CHUNK.TRACK_ID] = Musician.Utils.UnpackNumber(string.sub(str, cursor, cursor)),
			[CHUNK.INSTRUMENT] = Musician.Utils.UnpackNumber(string.sub(str, cursor + 1, cursor + 1)),
			[CHUNK.NOTE_COUNT] = Musician.Utils.UnpackNumber(string.sub(str, cursor + 2, cursor + 3)),
			[CHUNK.NOTES] = {}
		})
		cursor = cursor + 4
	end

	-- Note information: time (1), on/off + key(1), [duration (1)]
	local n, note
	for t, trackData in pairs(chunk) do
		for n = 1, trackData[CHUNK.NOTE_COUNT] do
			local time = Musician.Utils.UnpackTime(string.sub(str, cursor, cursor), Musician.CHUNK_FPS)
			local noteOn = bit.band(Musician.Utils.UnpackNumber(string.sub(str, cursor + 1, cursor + 1)), 0x80)
			local key = bit.band(Musician.Utils.UnpackNumber(string.sub(str, cursor + 1, cursor + 1)), 0x7F) + Musician.C0_INDEX
			local duration = nil

			if noteOn and mode == CHUNK_MODE_DURATION then
				duration = Musician.Utils.UnpackTime(string.sub(str, cursor + 2, cursor + 2), Musician.DURATION_FPS)
				cursor = cursor + 3
			else
				cursor = cursor + 2
			end

			table.insert(chunk[t][CHUNK.NOTES], {
				[NOTE.ON] = noteOn,
				[NOTE.KEY] = key,
				[NOTE.TIME] = time,
				[NOTE.DURATION] = duration
			})
		end
	end

	return chunk, songId, chunkDuration, position
end


