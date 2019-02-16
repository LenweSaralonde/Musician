Musician.Utils = LibStub("AceAddon-3.0"):NewAddon("Musician.Utils")

Musician.Utils.gameMusicIsMuted = false

--- Display a message in the console
-- @param msg (string)
function Musician.Utils.Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
end

--- Display an error message in the console
-- @param msg (string)
function Musician.Utils.PrintError(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	PlaySoundFile("Sound\\interface\\Error.ogg")
end

--- Display an error message in a popup
-- @param msg (string)
function Musician.Utils.Error(msg)
	message(msg)
	PlaySoundFile("Sound\\interface\\Error.ogg")
end

--- Display an message in a popup
-- @param msg (string)
-- @param callback (function)
-- @param force (boolean)
function Musician.Utils.Popup(msg, callback, force)
	if (force or not MusicianBasicMessageDialog:IsShown()) then
		MusicianBasicMessageDialogButton:SetScript("OnMouseUp", callback)
		MusicianBasicMessageDialog.Text:SetText(msg)
		MusicianBasicMessageDialog:Show()
	end
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

--- Get color code from RGB values
-- @param r (number)
-- @param g (number)
-- @param b (number)
-- @return (string)
function Musician.Utils.GetColorCode(r, g, b)
	local rh = string.format('%02X', floor(r * 255))
	local gh = string.format('%02X', floor(g * 255))
	local bh = string.format('%02X', floor(b * 255))
	return "|cFF" .. rh .. gh .. bh
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
		ChatFrame_OnEvent(DEFAULT_CHAT_FRAME, "CHAT_MSG_EMOTE", message, fullPlayerName, '', '', player, '', nil, nil, nil, nil, 0, playerGUID)
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

--- Decode base 64 string
-- Lua 5.1+ base64 v3.0 (c) 2009 by Alex Kloss <alexthkloss@web.de>
-- licensed under the terms of the LGPL2
-- http://lua-users.org/wiki/BaseSixtyFour
-- @param data (string)
-- @return string
function Musician.Utils.Base64Decode(data)
	local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
	data = string.gsub(data, '[^'..b..'=]', '')
	return (data:gsub('.', function(x)
		if (x == '=') then return '' end
		local r,f='',(b:find(x)-1)
		for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
		return r;
	end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
		if (#x ~= 8) then return '' end
		local c=0
		for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
		return string.char(c)
	end))
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

--- Pack player GUID into a 6-byte string
-- @return (string)
function Musician.Utils.PackPlayerGuid()
	local _, serverId, playerHexId = string.split('-', UnitGUID("player"))
	return Musician.Utils.PackNumber(tonumber(serverId), 2) .. Musician.Utils.FromHex(playerHexId)
end

--- Unpack player GUID from string
-- @param str (string)
-- @return (string)
function Musician.Utils.UnpackPlayerGuid(str)
	local serverId = Musician.Utils.UnpackNumber(string.sub(str, 1, 2))
	local playerHexId = Musician.Utils.ToHex(string.sub(str, 3, 6))
	return "Player-" .. serverId .. "-" .. playerHexId
end

--- Pack player position into a 18-byte chunk string
-- @return (string)
function Musician.Utils.PackPlayerPosition()
	local posY, posX, posZ, instanceID = UnitPosition("player") -- posZ is always 0

	local x = Musician.Utils.PackNumber(floor((posX or 0) + .5) + 0x7fffffff, 4)
	local y = Musician.Utils.PackNumber(floor((posY or 0) + .5) + 0x7fffffff, 4)
	local i = Musician.Utils.PackNumber(instanceID, 4)
	local g = Musician.Utils.PackPlayerGuid()

	return x .. y .. i .. g
end

--- Unpack player position from chunk string
-- @param str (string)
-- @return posY (number), posX (number), posZ (number), instanceID (number), guid (string)
function Musician.Utils.UnpackPlayerPosition(str)
	local posX = Musician.Utils.UnpackNumber(string.sub(str, 1, 4)) - 0x7fffffff
	local posY = Musician.Utils.UnpackNumber(string.sub(str, 5, 8)) - 0x7fffffff
	local instanceID = Musician.Utils.UnpackNumber(string.sub(str, 9, 12))
	local guid = Musician.Utils.UnpackPlayerGuid(string.sub(str, 13, 18))

	return posY, posX, 0, instanceID, guid
end

--- Convert hex string to string
-- @param str (string)
-- @return (string)
function Musician.Utils.FromHex(str)
	return (str:gsub('..', function (cc)
		return string.char(tonumber(cc, 16))
	end))
end

--- Convert string to hex string
-- @param str (string)
-- @return (string)
function Musician.Utils.ToHex(str)
	return (str:gsub('.', function (c)
		return string.format('%02X', string.byte(c))
	end))
end

--- Return instrument name from its MIDI ID
-- @param instrument (number)
-- @param key (number)
-- @return (string)
function Musician.Utils.GetInstrumentName(instrument, key)
	if instrument ~= 128 then -- Not a percussion
		return Musician.MIDI_INSTRUMENT_MAPPING[instrument]
	else -- Percussion
		return Musician.MIDI_PERCUSSION_MAPPING[key]
	end
end

--- Returns the sound file for this instrument and key
-- @param instrument (int) MIDI instrument index
-- @param key (int) MIDI key
-- @return (string, table, table)
function Musician.Utils.GetSoundFile(instrument, key)

	local instrumentName = Musician.Utils.GetInstrumentName(instrument, key)
	if instrumentName == nil or instrumentName == "none" then
		return nil
	end

	local instrumentData = Musician.Utils.GetInstrumentData(instrumentName, key)
	if instrumentData == nil then
		return nil
	end

	local soundPaths, soundPath
	if instrumentData.pathList ~= nil then
		soundPaths = instrumentData.pathList
	else
		soundPaths = { instrumentData.path }
	end

	if instrumentData["transpose"] then
		key = key + instrumentData["transpose"]
	end

	local noteName = Musician.Utils.NoteName(key)

	local soundFiles = {}
	local i, soundPath
	for i, soundPath in pairs(soundPaths) do
		local soundFile = soundPath
		if not(instrumentData.isPercussion) then
			soundFile = soundFile .. '\\' .. noteName
		end
		soundFiles[i] = soundFile .. ".ogg"
	end

	instrumentData.name = instrumentName

	if #soundFiles == 1 then
		return soundFiles[1], instrumentData, soundFiles
	end

	return soundFiles[floor(math.random() * #soundFiles) + 1], instrumentData, soundFiles
end

--- Returns true if a song is actually playing and audible
-- @return (boolean)
function Musician.Utils.SongIsPlaying()
	local isPlaying

	local sourceSongIsPlaying = Musician.sourceSong ~= nil and Musician.sourceSong:IsPlaying()
	isPlaying = sourceSongIsPlaying and not(Musician.globalMute)

	if not(isPlaying) then
		local song, player
		for player, song in pairs(Musician.songs) do
			if song:IsPlaying() and Musician.Registry.PlayerIsInRange(player, Musician.LISTENING_RADIUS) and not(Musician.globalMute) and not(Musician.PlayerIsMuted(player)) then
				return true
			end
		end
	end

	return isPlaying
end

--- Start or stop the actual game music if a song can actually be heard
-- @param force (boolean)
function Musician.Utils.MuteGameMusic(force)
	local mute

	if GetCVar("Sound_EnableMusic") ~= "0" then
		mute = Musician.Utils.SongIsPlaying()
	else
		mute = false
	end

	if not(force) and Musician.Utils.gameMusicIsMuted == mute then return end

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

--- Return the simple player name, including realm slug if needed
-- @param name (string)
-- @return (string)
function Musician.Utils.SimplePlayerName(name)
	local fullName = Musician.Utils.NormalizePlayerName(name)
	local myRealmName = string.gsub(GetRealmName(), "%s+", "")
	local simpleName, realmName = string.split('-', fullName)

	if realmName == myRealmName then
		return simpleName
	end

	return fullName
end

--- Returns true if the player is in my party or raid
-- @param name (string)
-- @return (boolean)
function Musician.Utils.PlayerIsInGroup(name)

	if Musician.Utils.PlayerIsMyself(name) and (IsInGroup() or IsInRaid()) then
		return true
	end

	local slug = 'party'
	local to = 4
	name = Musician.Utils.NormalizePlayerName(name)

	if IsInRaid() then
		slug = 'raid'
		to = 40
	end

	local i
	for i = 1, to do
		if GetUnitName(slug .. i, true) and Musician.Utils.NormalizePlayerName(GetUnitName(slug .. i, true)) == name then
			return true
		end
	end

	return false
end

--- Return true if the provided player name is myself
-- @param name (string)
-- @return (boolean)
function Musician.Utils.PlayerIsMyself(player)
	return player ~= nil and Musician.Utils.NormalizePlayerName(player) == Musician.Utils.NormalizePlayerName(UnitName("player"))
end

--- Return the emote for "Player is playing music" with promo URL
-- @return (string)
function Musician.Utils.GetPromoEmote()
	local promo = string.gsub(Musician.Msg.EMOTE_PROMO, "{url}", Musician.URL)
	return Musician.Msg.EMOTE_PLAYING_MUSIC .. " " .. promo
end

--- Return true if the message contains the promo emote, in any language
-- @param message (string)
-- @return (boolean)
function Musician.Utils.HasPromoEmote(message)
	local lang
	for lang, locale in pairs(Musician.Locale) do
		if string.find(message, locale.EMOTE_PLAYING_MUSIC) == 1 then
			return true
		end
	end

	return false
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
	local countA = #partsA
	local countB = #partsB

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

--- Add padding zeros
-- @param number (number)
-- @param zeros (number)
-- @return (string)
function Musician.Utils.PaddingZeros(number, zeros)
	local str = number .. ""

	while strlen(str) < zeros do
		str = "0" .. str
	end

	return str
end

--- Format time to mm:ss.ss format
-- @param time (number)
-- @param simple (boolean)
-- @return (string)
function Musician.Utils.FormatTime(time, simple)
	time = floor(time * 100 + .5)
	local cs = time % 100
	time = floor(time / 100)
	local s = time % 60
	time = floor(time / 60)
	local m = time

	if simple then
		return Musician.Utils.PaddingZeros(m, 2) .. ":" .. Musician.Utils.PaddingZeros(s, 2)
	end

	return Musician.Utils.PaddingZeros(m, 2) .. ":" .. Musician.Utils.PaddingZeros(s, 2) .. "." .. Musician.Utils.PaddingZeros(cs, 2)
end

--- Parse time from mm:ss.ss format
-- @param timestamp (string)
-- @return (number)
function Musician.Utils.ParseTime(timestamp)
	local parts = {string.split(':', timestamp)}
	local m, s

	if #parts >= 2 then
		m = string.match(parts[#parts - 1], "(%d*)")
	end
	s, _, cs = string.match(parts[#parts], "(%d*)(%.?)(%d*)")

	local time = 0

	if m and m ~= "" then
		time = tonumber(m) * 60
	end

	if s and s ~= "" then
		time = time + tonumber(s)
	end

	if cs and cs ~= "" then
		time = time + tonumber('0.' .. cs)
	end

	return max(0, time)
end

--- Return instrument data
-- @param instrumentName (string)
-- @param key (number)
-- @return (table)
function Musician.Utils.GetInstrumentData(instrumentName, key)
	local instrumentData = Musician.INSTRUMENTS[instrumentName]
	if instrumentData == nil then
		return nil
	end

	instrumentData.name = instrumentName

	-- Handle specific percussion mapping
	if instrumentData.midi == 128 and not(instrumentData.isPercussion) then
		return Musician.Utils.GetInstrumentData(Musician.MIDI_PERCUSSION_MAPPING[key], key)
	end

	-- Assign percussion MIDI id
	if instrumentData.midi == nil and instrumentData.isPercussion then
		instrumentData.midi = 128
	end

	return instrumentData
end

--- Returns sample ID for note and instrument
-- @param instrumentData (table) as returned by Musician.Utils.GetSoundFile()
-- @param key (number)
-- @return (string)
function Musician.Utils.GetSampleId(instrumentData, key)
	if instrumentData == nil or instrumentData.name == nil or instrumentData.name == "none" then
		return nil
	end

	if instrumentData.isPercussion then
		return instrumentData.name
	else
		return instrumentData.name .. '-' .. key
	end
end

--- Play Note
-- @param instrument (number)
-- @param key (number)
-- @return (boolean), (number), (table) willPlay, soundHandle, instrumentData
function Musician.Utils.PlayNote(instrument, key)
	local soundFile, instrumentData = Musician.Utils.GetSoundFile(instrument, key)
	local sampleId = Musician.Utils.GetSampleId(instrumentData, key)
	local play, handle = false
	if soundFile then
		play, handle = PlaySoundFile(soundFile, 'SFX')
	end
	Musician.Preloader.AddPreloaded(sampleId)
	return play, handle, instrumentData
end

--- Preload Note
-- @param instrument (number)
-- @param key (number)
-- @return (boolean), (number) hasSample, preloadTime
function Musician.Utils.PreloadNote(instrument, key)
	local soundFile, instrumentData, soundFiles = Musician.Utils.GetSoundFile(instrument, key)
	local sampleId = Musician.Utils.GetSampleId(instrumentData, key)
	local hasSample = false
	local startTime = debugprofilestop()
	for i, soundFile in pairs(soundFiles) do
		local play, handle
		play, handle = PlaySoundFile(soundFile, 'SFX')
		if play then
			hasSample = true
			StopSound(handle, 0)
		end
	end
	Musician.Preloader.AddPreloaded(sampleId)
	return hasSample, debugprofilestop() - startTime
end

--- Deep copy a table
-- http://lua-users.org/wiki/CopyTable
-- @param orig (table)
-- @return (table)
function Musician.Utils.DeepCopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		local orig_key, orig_value
		for orig_key, orig_value in next, orig, nil do
			copy[Musician.Utils.DeepCopy(orig_key)] = Musician.Utils.DeepCopy(orig_value)
		end
		--setmetatable(copy, Musician.Utils.DeepCopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

--- Deep merge two tables
-- @param merged (table)
-- @param orig (table)
-- @return (table)
function Musician.Utils.DeepMerge(merged, orig)
	local orig_type = type(orig)
	if orig_type == 'table' then
		local orig_key, orig_value
		for orig_key, orig_value in next, orig, nil do
			merged[orig_key] = Musician.Utils.DeepMerge(merged[orig_key], orig_value)
		end
	else -- number, string, boolean, etc
		merged = orig
	end
	return merged
end

--- Flip a table
-- @param orig (table)
-- @return (table)
function Musician.Utils.FlipTable(orig)
	local flipped = {}
	local key, value
	for key, value in pairs(orig) do
		flipped[value] = key
	end
	return flipped
end

--- Return operating system name
-- @return (string)
function Musician.Utils.GetOs()
	return
		IsWindowsClient() and Musician.OS_WINDOWS or
		IsMacClient() and Musician.OS_MAC or
		IsLinuxClient() and Musician.OS_LINUX
end
