Musician.Utils = LibStub("AceAddon-3.0"):NewAddon("Musician.Utils")

Musician.Utils.gameMusicIsMuted = false

--- Display a message in the console
-- @param msg (string)
function Musician.Utils.Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
end

--- Display an error message in the console
-- @param msg (string)
function Musician.Utils.Error(msg)
	message(msg)
	PlaySoundFile("Sound\\interface\\Error.ogg")
end

--- Highlight text
-- @param text (string)
-- @param color (string)
-- @return (string)
function Musician.Utils.Highlight(text, color)

	if color == nil then
		color = 'FFFFFF'
	end

	return "|cFF" .. color .. text .. "|r"
end	

--- Return the note name corresponding its MIDI key
-- @param key (int) MIDI key index
-- @return (string)
function Musician.Utils.NoteName(key)
	local noteId = key - Musician.C0_INDEX
	local octave = floor(noteId / 12)
	local note = noteId % 12
	return Musician.NOTE_NAMES[note] .. octave
end

--- Return the MIDI key of the note name
-- @param noteName (string)
-- @return (int)
function Musician.Utils.NoteKey(noteName)
	local octave, note

	for note in string.gmatch(noteName, "[A-Z#]+") do
		for octave in string.gmatch(noteName, "-?%d+") do
			return Musician.C0_INDEX + octave * 12 + Musician.NOTE_IDS[note]
		end
	end

	return nil
end

--- Reads some bytes from a string and remove them
-- @param str (string)
-- @param bytes (int)
-- @return (string, string) Read bytes, new string
function Musician.Utils.ReadBytes(str, bytes)
	return string.sub(str, 1, bytes), string.sub(str, bytes + 1)
end

--- Pack an integer number into a string
-- @param num (int) Integer to pack
-- @param bytes (int) Number of bytes
-- @return (string)
function Musician.Utils.PackNumber(num, bytes)
	local m = num
	local b
	local packed = ''
	local i = 0

	while m > 0 or i < bytes do
		b = m % 256
		m = (m - b) / 256
		packed = string.char(b) .. packed
		i = i + 1
	end

	return string.sub(packed, -bytes)
end

--- Unpack a string into an integer number
-- @param str (string)
-- @return (int)
function Musician.Utils.UnpackNumber(str)
	local num = 0

	while string.len(str) > 0 do
		num = num * 256 + string.byte(string.sub(str, 1, 1))
		str = string.sub(str, 2)
	end

	return num
end

--- Pack a time or duration in seconds into a string
-- @param seconds (float)
-- @param bytes (int) Number of bytes
-- @param fps (float) Precision in frames par second
-- @return (string)
function Musician.Utils.PackTime(seconds, bytes, fps)
	return Musician.Utils.PackNumber(floor(seconds * fps + .5), bytes)
end

--- Unpack a string into a time or duration in seconds
-- @param str (string)
-- @param fps (float) Precision in frames par second 
-- @return (float)
function Musician.Utils.UnpackTime(str, fps)
	return Musician.Utils.UnpackNumber(str) / fps
end

--- Pack player position into a string
-- @return (string)
function Musician.Utils.PackPosition()
	local posY, posX, posZ, instanceID = UnitPosition("player")
	return posY .. " " .. posX .. " " .. posZ .. " " .. instanceID
end

--- Unpack player position from string
-- @param str (string)
-- @return posY (number), posX (number), posZ (number), instanceID (number)
function Musician.Utils.UnpackPosition(str)
	local posY, posX, posZ, instanceID = strsplit(' ', str)
	return posY + 0, posX + 0, posZ + 0, instanceID + 0
end

--- Pack a note into a string
-- @param note (table)
-- @param fps (float)
-- @return (string)
function Musician.Utils.PackNote(note, fps)
	-- KTTD : key, time, duration
	return Musician.Utils.PackNumber(note[1], 1) .. Musician.Utils.PackTime(note[2], 2, fps) .. Musician.Utils.PackTime(note[3], 1, Musician.DURATION_FPS)
end

--- Unpack note from string
-- @param str (string)
-- @param fps (float)
-- @return (table)
function Musician.Utils.UnpackNote(str, fps)
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
function Musician.Utils.PackTrack(track, fps)
	local packedTrack

	-- TINN : Track Id, instrument ID, Number of notes
	packedTrack = Musician.Utils.PackNumber(track.id, 1) .. Musician.Utils.PackNumber(track.instrument, 1) .. Musician.Utils.PackNumber(table.getn(track.notes), 2)

	-- Notes
	local note
	for _, note in pairs(track.notes) do
		packedTrack = packedTrack .. Musician.Utils.PackNote(note, fps)
	end

	return packedTrack
end

--- Unpack a track from string
-- @param str (string)
-- @param fps (float)
-- @return (table)
function Musician.Utils.UnpackTrack(str, fps)
	local track = {}

	-- TINN : Track Id, instrument ID, Number of notes
	track.id = Musician.Utils.UnpackNumber(string.sub(str, 1, 1))
	track.instrument = Musician.Utils.UnpackNumber(string.sub(str, 2, 2))
	local noteCount  = Musician.Utils.UnpackNumber(string.sub(str, 3, 4))

	track.notes = {}
	local noteId
	for noteId = 0, noteCount - 1 do
		local cursor = 5 + noteId * 4 -- Notes are 4-byte long
		table.insert(track.notes, Musician.Utils.UnpackNote(string.sub(str, cursor, cursor + 3), fps))
	end

	return track
end

--- Pack a song into a string
-- @param song (table)
-- @return (string)
function Musician.Utils.PackSong(song)
	local packedSong = Musician.FILE_HEADER
	local songName = string.sub(song.name, 1, 255)
	local fps = 65536 / song.duration -- 2^16

	-- Song name length, song name
	packedSong = packedSong .. Musician.Utils.PackNumber(string.len(songName), 1) .. songName

	-- Song duration
	packedSong = packedSong .. Musician.Utils.PackNumber(song.duration, 2)

	-- Number of tracks
	packedSong = packedSong .. Musician.Utils.PackNumber(table.getn(song.tracks), 1)

	-- Song tracks
	local track
	for _, track in pairs(song.tracks) do
		packedSong = packedSong .. Musician.Utils.PackTrack(track, fps)
	end

	return packedSong
end

--- Unpack a song from string
-- @param str (string)
-- @return (table)
function Musician.Utils.UnpackSong(str)
	local song = {}
	local cursor = 1

	-- Check format
	if string.sub(str, 1, string.len(Musician.FILE_HEADER)) ~= Musician.FILE_HEADER then
		error(Musician.Msg.INVALID_MUSIC_CODE)
	end
	cursor = cursor + string.len(Musician.FILE_HEADER)

	-- Song name length (1), song name
	local songNameLength = Musician.Utils.UnpackNumber(string.sub(str, cursor, cursor))
	cursor = cursor + 1
	song.name = string.sub(str, cursor, cursor + songNameLength - 1)
	cursor = cursor + songNameLength

	-- song duration (2)
	local duration = Musician.Utils.UnpackNumber(string.sub(str, cursor, cursor + 1))
	local fps = 65536 / duration -- 2^16
	song.duration = duration
	cursor = cursor + 2

	-- number of tracks (1)
	local trackCount = Musician.Utils.UnpackNumber(string.sub(str, cursor, cursor))
	cursor = cursor + 1

	-- tracks
	local trackId
	song.tracks = {}
	for trackId = 0, trackCount - 1 do
		local trackLength = Musician.Utils.UnpackNumber(string.sub(str, cursor + 2, cursor + 3))
		local trackEnd = cursor + 3 + trackLength * 4
		table.insert(song.tracks, Musician.Utils.UnpackTrack(string.sub(str, cursor, trackEnd), fps))
		cursor = trackEnd + 1
	end

	return song
end


--- Returns true if the player is in listening range
-- @param player (string)
-- @return (boolean)
function Musician.Utils.PlayerIsInRange(player)

	player = Musician.Utils.NormalizePlayerName(player)

	-- Musician not registered
	if Musician.songs[player] == nil or Musician.songs[player].position == nil then
		return false
	end

	local posY, posX, posZ, instanceID = UnitPosition("player")
	local posY2, posX2, posZ2, instanceID2 = unpack(Musician.songs[player].position)

	-- Not the same instance
	if instanceID2 ~= instanceID then
		return false
	end

	-- Range check
	return Musician.LISTENING_RADIUS ^ 2 > (posY2 - posY) ^ 2 + (posX2 - posX) ^ 2 + (posZ2 - posZ) ^ 2
end

--- Returns the sound file for this instrument and key
-- @param instrument (int) MIDI instrument index
-- @param key (int) MIDI key
-- @return (string, table)
function Musician.Utils.GetSoundFile(instrument, key)

	local noteName = Musician.Utils.NoteName(key)
	noteName = string.gsub(noteName, 'A#', 'Bb')

	local instrumentName
	if instrument ~= 0 then -- Not a percussion
		instrumentName = Musician.MIDI_INSTRUMENT_MAPPING[instrument]
		if instrumentName == nil then
			return nil
		end
	else -- Percussion
		instrumentName = Musician.MIDI_PERCUSSION_MAPPING[key]
	end

	local instrumentData = Musician.INSTRUMENTS[instrumentName]
	if instrumentData == nil then
		return nil
	end

	local soundFile

	if instrumentData.pathFunc ~= nil then
		soundFile = instrumentData.pathFunc()
	else
		soundFile = instrumentData.path
	end

	if not(instrumentData.isPercussion) then
		soundFile = soundFile .. '\\' .. noteName
	end

	instrumentData.name = instrumentName

	return soundFile .. ".ogg", instrumentData
end

--- Play a note
-- @param instrument (int) MIDI instrument index
-- @param key (int) MIDI key
-- @param start (float) Start time in seconds
-- @param duration (float) Duration in seconds
-- @param player (string) Player name
-- @return (table) Timer or nil if the not could not start
function Musician.Utils.PlayNote(instrument, key, start, duration, player)

	local soundFile, instrumentData = Musician.Utils.GetSoundFile(instrument, key)

	if soundFile == nil or start < 0 then
		return nil
	end

	return C_Timer.NewTimer(start, function()

			-- Do not play note if a test song is playing or if player is out of range
			if player ~= nil and (Musician.testSongIsPlaying or not(Musician.Utils.PlayerIsInRange(player))) then
				return
			end

			local play, handle = PlaySoundFile(soundFile, 'SFX')

			if play then
				local soundDuration = duration
				local soundDecay = instrumentData.decay
				-- local soundDuration = max(0, duration - instrumentData.decay / 1000)
				-- local soundDecay = min(duration * 1000, instrumentData.decay)

				C_Timer.After(soundDuration, function()
					StopSound(handle, soundDecay)
				end)
			end
	end)
end

--- Play a song
-- @param songData (table)
-- @param preroll (float)
-- @return (float) The total duration of the song
function Musician.Utils.PlaySong(songData, preroll)

	Musician.Utils.PreloadSong(songData)

	local now = GetTime()
	local track, note
	local endTime = 0

	if preroll == nil then
		preroll = 0
	end

	for _, track in pairs(songData["tracks"]) do
		for _, note in pairs(track["notes"]) do
			endTime = max(endTime, preroll + note[2] + now - GetTime() + note[3] + 1)
		end
	end

	C_Timer.After(0.1, function()
		for _, track in pairs(songData["tracks"]) do
			for _, note in pairs(track["notes"]) do
				note[4] = Musician.Utils.PlayNote(track["instrument"], note[1], preroll + note[2] + now - GetTime(), note[3], songData.player)
			end
		end
	end)

	return endTime
end

--- Preload song sounds into memory cache
-- @param songData (table)
function Musician.Utils.PreloadSong(songData)

	local track, note

	local notes = {}

	for _, track in pairs(songData["tracks"]) do
		for _, note in pairs(track["notes"]) do
			local noteString = track["instrument"] .. note[1]
			notes[noteString] = {track["instrument"], note[1]}
		end
	end

	local index = 0
	local duration = .25
	for _, note in pairs(notes) do
		-- Musician.Utils.PlayNote(note[1], note[2], index * duration, duration)
		local soundFile, _ = Musician.Utils.GetSoundFile(note[1], note[2])
		if soundFile ~= nil then
			local play, handle = PlaySoundFile(soundFile, 'SFX')
			if play then
				StopSound(handle, 0)
			end
		end
	end
end

--- Stop a song currently playing
-- @param songData (table)
function Musician.Utils.StopSong(songData)

	if songData.endTimer ~= nil then
		songData.endTimer:Cancel()
	end

	local track, note
	for _, track in pairs(songData["tracks"]) do
		for _, note in pairs(track["notes"]) do
			if note[4] ~= nil then
				note[4]:Cancel()
				note[4] = nil
			end
		end
	end
end

--- Start or stop the actual game music if a song can actually be heard
--
function Musician.Utils.MuteGameMusic()
	local mute

	if GetCVar("Sound_EnableMusic") ~= "0" then
		mute = Musician.testSongIsPlaying

		if not(mute) then
			local song, player
			for player, song in pairs(Musician.songs) do
				if song.playing and Musician.Utils.PlayerIsInRange(player) then
					mute = true
				end
			end
		end
	else
		mute = false
	end

	if Musician.Utils.gameMusicIsMuted == mute then return end

	Musician.Utils.gameMusicIsMuted = mute

	if mute then
		-- Play a silent music track to mute and fade actual game music
		PlayMusic("Interface\\AddOns\\Musician\\instruments\\silent.mp3")
	else
		-- Stop custom silent music, resume game music
		StopMusic()
	end
end

--- Return the normalized player name, including realm slug
-- @param name (string)
-- @return (string)
function Musician.Utils.NormalizePlayerName(name)

	-- Append missing realm name
	if string.find(name, '-') == nil then
		return name .. '-' .. string.gsub(GetRealmName(), "%s+", "")
	end

	return name
end

--- Compare two version numbers
-- @param versionA (string)
-- @param versionB (string)
-- @return (number)
function Musician.Utils.VersionCompare(versionA, versionB)

	if versionA == versionB then
		return 0
	end

	local partsA = { strsplit('.', versionA) }
	local partsB = { strsplit('.', versionB) }
	local countA = table.getn(partsA)
	local countB = table.getn(partsB)

	local i
	for i = 1, min(countA, countB) do
		local a = tonumber(partsA[i])
		local b = tonumber(partsB[i])
	
		if a > b then
			return 1
		elseif a < b then
			return -1
		end
	end
	
	if countA > countB then
		return 1
	elseif countA < countB then
		return -1
	end
	
	return 0
end
