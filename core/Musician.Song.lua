Musician.Song = {}
Musician.Song.__index = Musician.Song

--- Constructor
-- @param packedSongData (string)
function Musician.Song.create(packedSongData)
	local self = {}
	setmetatable(self, Musician.Song)

	-- @field tracks (table) Song tracks, including instrument and notes
	self.tracks = {}

	-- @field duration (float) Song duration in seconds
	self.duration = 0

	-- @field name (string) Song title
	self.name = nil

	-- @field player (string) Player name, with realm slug
	self.player = nil

	-- @field guid (string) Player GUID
	self.guid = nil

	-- @field position (table) Player position
	self.position = nil

	-- @field notified (boolean) True when the notification for the song playing has been displayed
	self.notified = false

	if packedSongData then
		self:Unpack(packedSongData)
	end

	return self
end

--- Preload song sounds into memory cache
function Musician.Song:Preload()
	local track, note

	local notes = {}

	for _, track in pairs(self.tracks) do
		for _, note in pairs(track.notes) do
			local noteString = track.instrument .. note[1]
			notes[noteString] = {track.instrument, note[1]}
		end
	end

	local index = 0
	local duration = .25
	for _, note in pairs(notes) do
		local soundFile, _ = Musician.Utils.GetSoundFile(note[1], note[2])
		if soundFile ~= nil then
			local play, handle = PlaySoundFile(soundFile, 'SFX')
			if play then
				StopSound(handle, 0)
			end
		end
	end
end

--- Play song
-- @return (float) The total duration of the song
function Musician.Song:Play()

	local preroll = Musician.PLAY_PREROLL

	self:Preload()

	local now = GetTime()
	local track, note
	local endTime = 0

	if preroll == nil then
		preroll = 0
	end

	for _, track in pairs(self.tracks) do
		for _, note in pairs(track.notes) do
			endTime = max(endTime, preroll + note[2] + now - GetTime() + note[3] + 1)
		end
	end

	C_Timer.After(0.1, function()
		for _, track in pairs(self.tracks) do
			for _, note in pairs(track.notes) do
				note[4] = self:PlayNote(track, note[1], preroll + note[2] + now - GetTime(), note[3])
			end
		end
	end)

	return endTime
end

--- Stop song
function Musician.Song:Stop()

	if self.endTimer ~= nil then
		self.endTimer:Cancel()
	end

	local track, note
	for _, track in pairs(self.tracks) do
		for _, note in pairs(track.notes) do
			if note[4] ~= nil then
				note[4]:Cancel()
				note[4] = nil
			end
		end
	end
end

--- Play a note
-- @param track (table) Reference to the track
-- @param key (int) MIDI key
-- @param start (float) Start time in seconds
-- @param duration (float) Duration in seconds
-- @return (table) Timer or nil if the not could not start
function Musician.Song:PlayNote(track, key, start, duration)

	if start < 0 then
		return nil
	end

	return C_Timer.NewTimer(start, function()
		local soundFile, instrumentData = Musician.Utils.GetSoundFile(track.instrument, key)

		if soundFile == nil then
			return
		end

		-- Send notification emote
		if self.player ~= nil and Musician.Utils.PlayerIsInRange(self.player) and not(self.notified) then
			self.notified = true
			Musician.Utils.DisplayEmote(self.player, self.guid, Musician.Msg.EMOTE_PLAYING_MUSIC)
		end

		-- Do not play note if a test song is playing or if player is out of range
		if self.player ~= nil and (Musician.testSongIsPlaying or not(Musician.Utils.PlayerIsInRange(self.player))) or Musician.globalMute or Musician.PlayerIsMuted(self.player) then
			return
		end

		local play, handle = PlaySoundFile(soundFile, 'SFX')

		if play then
			local soundDuration = duration
			local soundDecay = instrumentData.decay

			C_Timer.After(soundDuration, function()
				StopSound(handle, soundDecay)
			end)
		end
	end)
end

--- Pack a note into a string
-- @param note (table)
-- @param fps (float)
-- @return (string)
function Musician.Song:PackNote(note, fps)
	-- KTTD : key, time, duration
	return Musician.Utils.PackNumber(note[1], 1) .. Musician.Utils.PackTime(note[2], 2, fps) .. Musician.Utils.PackTime(min(note[3], Musician.MAX_NOTE_DURATION), 1, Musician.DURATION_FPS)
end

--- Unpack note from string
-- @param str (string)
-- @param fps (float)
-- @return (table)
function Musician.Song:UnpackNote(str, fps)
	-- KTTD : key, time, duration
	return {
		Musician.Utils.UnpackNumber(string.sub(str, 1, 1)),
		Musician.Utils.UnpackTime(string.sub(str, 2, 3), fps),
		Musician.Utils.UnpackTime(string.sub(str, 4, 4), Musician.DURATION_FPS)
	}
end

--- Pack a track into a string
-- @param track (table)
-- @param fps (float)
-- @return (string)
function Musician.Song:PackTrack(track, fps)
	local packedTrack

	-- TINN : Track Id, instrument ID, Number of notes
	packedTrack = Musician.Utils.PackNumber(track.id, 1) .. Musician.Utils.PackNumber(track.instrument, 1) .. Musician.Utils.PackNumber(table.getn(track.notes), 2)

	-- Notes
	local note
	for _, note in pairs(track.notes) do
		packedTrack = packedTrack .. self:PackNote(note, fps)
	end

	return packedTrack
end

--- Unpack a track from string
-- @param str (string)
-- @param fps (float)
-- @return (table)
function Musician.Song:UnpackTrack(str, fps)
	local track = {}

	-- TINN : Track Id, instrument ID, Number of notes
	track.id = Musician.Utils.UnpackNumber(string.sub(str, 1, 1))
	track.instrument = Musician.Utils.UnpackNumber(string.sub(str, 2, 2))
	local noteCount  = Musician.Utils.UnpackNumber(string.sub(str, 3, 4))

	track.notes = {}
	local noteId
	for noteId = 0, noteCount - 1 do
		local cursor = 5 + noteId * 4 -- Notes are 4-byte long
		table.insert(track.notes, self:UnpackNote(string.sub(str, cursor, cursor + 3), fps))
	end

	return track
end

--- Pack a song into a string
-- @return (string)
function Musician.Song:Pack()
	local packedSong = Musician.FILE_HEADER
	local songName = string.sub(self.name, 1, 255)
	local fps = 65535 / self.duration -- 2^16

	-- Song name length, song name
	packedSong = packedSong .. Musician.Utils.PackNumber(string.len(songName), 1) .. songName

	-- Song duration
	packedSong = packedSong .. Musician.Utils.PackNumber(self.duration, 2)

	-- Number of tracks
	packedSong = packedSong .. Musician.Utils.PackNumber(table.getn(self.tracks), 1)

	-- Song tracks
	local track
	for _, track in pairs(self.tracks) do
		packedSong = packedSong .. self:PackTrack(track, fps)
	end

	return packedSong
end

--- Unpack a song from string
-- @param str (string)
function Musician.Song:Unpack(str)
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
		table.insert(self.tracks, self:UnpackTrack(string.sub(str, cursor, trackEnd), fps))
		cursor = trackEnd + 1
	end
end
