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

--- Format text, adding highlights etc.
-- @param text (string)
-- @return (string)
function Musician.Utils.FormatText(text)

	-- Highlight **text**
	local search = "%*%*[^%*]+%*%*"
	while string.find(text, search) do
		local from, to = string.find(text, search)
		text = string.sub(text, 1, from - 1) .. Musician.Utils.Highlight(string.sub(text, from + 2, to - 2)) .. string.sub(text, to + 1)
	end

	return text
end

--- Get hyperlink
-- @param command (string)
-- @param text (string)
-- @param ... (string)
-- @return (string)
function Musician.Utils.GetLink(command, text, ...)
	return "|H" .. strjoin(':', command, ... ) .. "|h" .. text .. "|h"
end

--- Get player hyperlink
-- @param player (string)
-- @return (string)
function Musician.Utils.GetPlayerLink(player)
	local player, realm = strsplit('-', Musician.Utils.NormalizePlayerName(player), 2)
	local _, myRealm = strsplit('-', Musician.Utils.NormalizePlayerName(UnitName("player")), 2)

	if myRealm ~= realm then
		player = player .. "-" .. realm
	end

	return Musician.Utils.GetLink('player', player, player)
end

--- Return the code to insert an icon in a chat message
-- @param path (string)
-- @return (string)
function Musician.Utils.GetChatIcon(path)
	local _, fontHeight = FCF_GetChatWindowInfo(DEFAULT_CHAT_FRAME:GetID())

	if fontHeight == 0 then
		-- fontHeight will be 0 if it's still at the default (14)
		fontHeight = 14;
	end

	return "|T" .. path .. ":" .. fontHeight .. "|t"
end

--- Display a faked emote
-- @param player (string)
-- @param playerGUID (string)
-- @param message (string)
-- @return (string)
function Musician.Utils.DisplayEmote(player, playerGUID, message)
	local player, realm = strsplit('-', Musician.Utils.NormalizePlayerName(player), 2)
	local _, myRealm = strsplit('-', Musician.Utils.NormalizePlayerName(UnitName("player")), 2)
	local fullPlayerName = player .. "-" .. realm

	if myRealm ~= realm then
		player = fullPlayerName
	end

	if playerGUID then
		ChatFrame_OnEvent(DEFAULT_CHAT_FRAME, "CHAT_MSG_EMOTE", message, fullPlayerName, '', '', player, '', nil, nil, nil, nil, -1, playerGUID)
	else
		ChatFrame_OnEvent(DEFAULT_CHAT_FRAME, "CHAT_MSG_EMOTE", message, fullPlayerName, '', '', player, '')
	end
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
	return posY .. " " .. posX .. " " .. posZ .. " " .. instanceID .. " " .. UnitGUID("player")
end

--- Unpack player position from string
-- @param str (string)
-- @return posY (number), posX (number), posZ (number), instanceID (number), guid (string)
function Musician.Utils.UnpackPosition(str)
	local posY, posX, posZ, instanceID, guid = strsplit(' ', str)
	return posY + 0, posX + 0, posZ + 0, instanceID + 0, guid
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
	if instrument ~= 128 then -- Not a percussion
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

--- Start or stop the actual game music if a song can actually be heard
--
function Musician.Utils.MuteGameMusic()
	local mute

	if GetCVar("Sound_EnableMusic") ~= "0" then
		local sourceSongIsPlaying = Musician.sourceSong ~= nil and Musician.sourceSong.playing
		mute = sourceSongIsPlaying and not(Musician.globalMute)

		if not(mute) then
			local song, player
			for player, song in pairs(Musician.songs) do
				if song.playing and Musician.Utils.PlayerIsInRange(player) and not(Musician.globalMute) and not(Musician.PlayerIsMuted(player)) then
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

--- Return true if the provided player name is myself
-- @param name (string)
-- @return (boolean)
function Musician.Utils.PlayerIsMyself(player)
	return Musician.Utils.NormalizePlayerName(player) == Musician.Utils.NormalizePlayerName(UnitName("player"))
end

--- Return the emote for "Player is playing music" with promo URL
-- @return (string)
function Musician.Utils.GetPromoEmote()
	local promo = string.gsub(Musician.Msg.EMOTE_PROMO, "{url}", Musician.URL)
	return Musician.Msg.EMOTE_PLAYING_MUSIC .. " " .. promo
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
