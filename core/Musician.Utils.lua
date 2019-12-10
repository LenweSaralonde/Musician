Musician.Utils = LibStub("AceAddon-3.0"):NewAddon("Musician.Utils")

local MODULE_NAME = "Utils"
Musician.AddModule(MODULE_NAME)

local LibRealmInfo = LibStub:GetLibrary("LibRealmInfo")

local FULL_PROMO_EMOTE_COOLDOWN = 10 * 60 -- Cooldown in seconds for the full promo emote

local isGameMusicMuted = false
local fullPromoEmoteLastSeen
local overrideNextFullPromoEmote = false

--- Display a message in the console
-- @param msg (string)
function Musician.Utils.Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
end

--- Prints debug stuff in the console
-- @param module (string)
-- @param ... (string)
function Musician.Utils.Debug(module, ...)
	if module ~= nil then
		if Musician_Settings.debug[module] then
			print("[|cFFFFFF00Musician DEBUG|r]", module, ...)
		end
	else
		print("[|cFFFFFF00Musician DEBUG|r]", ...)
	end
end

--- Safely play a sound file, even if the sound file does not exist.
-- @param soundFile (string)
-- @param channel (string)
-- @return willPlay, soundHandle (boolean), (number)
function Musician.Utils.PlaySoundFile(soundFile, channel)
	local willPlay, soundHandle
	pcall(function()
		willPlay, soundHandle = PlaySoundFile(soundFile, channel)
	end)
	return willPlay, soundHandle
end

--- Display an error message in the console
-- @param msg (string)
function Musician.Utils.PrintError(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	PlaySoundFile("sound\\interface\\error.ogg")
end

--- Display an error message in a popup
-- @param msg (string)
function Musician.Utils.Error(msg)
	message(msg)
	PlaySoundFile("sound\\interface\\error.ogg")
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
-- @param color (string|Color)
-- @return (string)
function Musician.Utils.Highlight(text, color)

	if color == nil then
		color = 'FFFFFF'
	elseif type(color) == 'table' and color.GenerateHexColorMarkup then
		return color:GenerateHexColorMarkup() .. text .. "|r"
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

--- Get player name for display
-- @param player (string)
-- @return (string)
function Musician.Utils.FormatPlayerName(player)
	return Musician.Utils.SimplePlayerName(player)
end

--- Return the code to insert an icon in a chat message or a text string
-- @param path (string)
-- @param [r (number)]
-- @param [g (number)]
-- @param [b (number)]
-- @return (string)
function Musician.Utils.GetChatIcon(path, r, g, b)
	if r ~= nil and g ~= nil and b ~= nil then
		r = floor(r * 255)
		g = floor(g * 255)
		b = floor(b * 255)
		return "|T" .. path .. ":0:aspectRatio:0:0:1:1:0:1:0:1:" .. r .. ":" .. g .. ":" .. b .. "|t"
	end

	return "|T" .. path .. ":0:aspectRatio|t"
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

--- Remove a chat message by its line ID
-- @param lineID (number)
function Musician.Utils.RemoveChatMessage(lineID)
	local i
	for i = 1, NUM_CHAT_WINDOWS do
		local chatFrame = _G["ChatFrame" .. i]
		if chatFrame then
			chatFrame:RemoveMessagesByPredicate(function(text)
				return text:match("^|Hplayer:(%S+):" .. lineID .. ":")
			end)
		end
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
			if song:IsPlaying() and Musician.Registry.PlayerIsInRange(player) and not(Musician.globalMute) and not(Musician.PlayerIsMuted(player)) then
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
		mute = Musician.Utils.SongIsPlaying() or Musician.Live.IsPlayingLive()
	else
		mute = false
	end

	if not(force) and isGameMusicMuted == mute then return end

	isGameMusicMuted = mute

	if mute then
		-- Play a silent music track to mute and fade actual game music
		PlayMusic("Interface\\AddOns\\Musician\\instruments\\silent.mp3")
	else
		-- Stop custom silent music, resume game music
		StopMusic()
	end
end

local currentNormalizedRealmName

--- Return the normalized realm name the player belongs to
-- Safer than the standard GetNormalizedRealmName() that may return nil sometimes
-- @return (string)
function Musician.Utils.GetNormalizedRealmName()
	if currentNormalizedRealmName then
		return currentNormalizedRealmName
	end
	currentNormalizedRealmName = GetNormalizedRealmName()
	return currentNormalizedRealmName
end

--- Return the short locale code of the realm the player belongs to
-- @return (string)
function Musician.Utils.GetRealmLocale()
	local locale = select(5, LibRealmInfo:GetRealmInfoByUnit("player")) or GetLocale()
	return string.gsub(locale, "[A-Z]+", "")
end

--- Return the normalized player name, including realm slug
-- @param name (string)
-- @return (string)
function Musician.Utils.NormalizePlayerName(name)
	-- Append missing realm name
	if string.find(name, '-') == nil then
		return name .. '-' .. Musician.Utils.GetNormalizedRealmName()
	end

	return name
end

--- Return the simple player name, including realm slug if needed
-- @param name (string)
-- @return (string), (string), (string) Player name, realm name, full name
local function getPlayerNameParts(name)
	local fullName = Musician.Utils.NormalizePlayerName(name)
	local simpleName, realmName = string.split('-', fullName)
	return simpleName, realmName, fullName
end

--- Return the simple player name, including realm slug if needed
-- @param name (string)
-- @return (string)
function Musician.Utils.SimplePlayerName(name)
	local _, myRealmName = getPlayerNameParts(UnitName("player"))
	local simpleName, realmName, fullName = getPlayerNameParts(name)

	if realmName == myRealmName then
		return simpleName
	end

	return fullName
end

--- Return the player realm slug
-- @param name (string)
-- @return (string)
function Musician.Utils.PlayerRealm(name)
	return select(2, getPlayerNameParts(name))
end

--- Returns true if the player is in my party or raid
-- @param name (string)
-- @return (boolean)
function Musician.Utils.PlayerIsInGroup(name)
	local simpleName = Musician.Utils.SimplePlayerName(name)
	return UnitInParty(simpleName) and UnitIsConnected(simpleName)
end

--- Return true if the provided player name is myself
-- @param name (string)
-- @return (boolean)
function Musician.Utils.PlayerIsMyself(player)
	return player ~= nil and Musician.Utils.NormalizePlayerName(player) == Musician.Utils.NormalizePlayerName(UnitName("player"))
end

--- Return true if the provided player name is on the same realm or connected realm as me
-- @param name (string)
-- @return (boolean)
function Musician.Utils.PlayerIsOnSameRealm(player)
	local playerRealm = Musician.Utils.PlayerRealm(player)

	-- Is on the same realm
	if playerRealm == Musician.Utils.PlayerRealm(UnitName("player")) then
		return true
	end

	-- Is on a connected realm
	local realm
	for _, realm in pairs(GetAutoCompleteRealms()) do
		if realm == playerRealm then
			return true
		end
	end

	return false
end

--- Return true if the player whose GUID is provided is visible (loaded) by the game client
-- @param guid (string)
-- @return (boolean)
function Musician.Utils.PlayerGuidIsVisible(guid)
	return guid and C_PlayerInfo.IsConnected(PlayerLocation:CreateFromGUID(guid))
end

--- Return the "Player is playing music" emote with promo message
-- @return (string)
function Musician.Utils.GetPromoEmote()
	local locale = Musician.Utils.GetRealmLocale()
	local EMOTE_PLAYING_MUSIC = Musician.Locale[locale] and Musician.Locale[locale].EMOTE_PLAYING_MUSIC or Musician.Msg.EMOTE_PLAYING_MUSIC
	local EMOTE_PROMO = Musician.Locale[locale] and Musician.Locale[locale].EMOTE_PROMO or Musician.Msg.EMOTE_PROMO

	local sendPromoPart = Musician_Settings.enableEmotePromo

	-- Do not send the promo part too often
	if sendPromoPart and (overrideNextFullPromoEmote or fullPromoEmoteLastSeen ~= nil and (fullPromoEmoteLastSeen + FULL_PROMO_EMOTE_COOLDOWN) > GetTime()) then
		sendPromoPart = false
	end

	-- Append promo part
	if sendPromoPart then
		local promo = string.gsub(EMOTE_PROMO, "{url}", Musician.URL)
		return EMOTE_PLAYING_MUSIC .. " " .. promo
	else
		return EMOTE_PLAYING_MUSIC
	end
end

--- Return true if the message contains the promo emote, in any language
-- @param message (string)
-- @return (boolean), (boolean)
function Musician.Utils.HasPromoEmote(message)
	local lang
	for lang, locale in pairs(Musician.Locale) do
		if string.find(message, locale.EMOTE_PLAYING_MUSIC, 1, true) == 1 then
			local isFullPromoEmote = string.find(message, locale.EMOTE_PROMO, 1, true) ~= nil
			return true, isFullPromoEmote
		end
	end

	return false, false
end

--- Mark the full promo emote as recently seen
--
function Musician.Utils.ResetFullPromoEmoteCooldown()
	fullPromoEmoteLastSeen = GetTime()
end

--- Override the next full promo emote
--
function Musician.Utils.OverrideNextFullPromoEmote()
	overrideNextFullPromoEmote = true
end

--- Send the "Player is playing music" emote with promo message
-- @return (string)
function Musician.Utils.SendPromoEmote()
	if Musician_Settings.enableEmote then
		SendChatMessage(Musician.Utils.GetPromoEmote(), "EMOTE")
		overrideNextFullPromoEmote = false

		-- Show a hint to the user that an emote is also being sent by default
		if not(Musician_Settings.emoteHintShown) then
			Musician_Settings.emoteHintShown = true
			local emoteHint = Musician.Msg.OPTIONS_EMOTE_HINT
			local emoteHintLinkText = emoteHint:match("%[(.+)%]")
			local emoteHintLink = Musician.Utils.Highlight(Musician.Utils.GetLink("musician", emoteHintLinkText, "options"), '00BBBB')
			emoteHintLink = Musician.Utils.Highlight('[', 'BBBBBB') .. emoteHintLink .. Musician.Utils.Highlight(']', 'BBBBBB')
			emoteHint = string.gsub(emoteHint, '%[' .. emoteHintLinkText .. '%]', emoteHintLink)
			DEFAULT_CHAT_FRAME:AddMessage(emoteHint, ORANGE_FONT_COLOR.r * .75, ORANGE_FONT_COLOR.g * .75, ORANGE_FONT_COLOR.b * .75)
		end
	end
end

--- Return the current version as text for the end user
-- @return (string)
function Musician.Utils.GetVersionText()
	local version = GetAddOnMetadata("Musician", "Version")
	if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE then
		version = version .. "-classic"
	end
	return version
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
		local a = tonumber(partsA[i]) or 0
		local b = tonumber(partsB[i]) or 0

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
	local m, s, cs

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

	if not(Musician.Preloader.IsPreloaded(sampleId)) then
		play, handle = true, 0 -- Silent note
	elseif soundFile then
		play, handle = Musician.Utils.PlaySoundFile(soundFile, 'SFX')
	end

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
	local count = 0
	local startTime = debugprofilestop()
	for i, soundFile in pairs(soundFiles) do
		local play, handle
		play, handle = Musician.Utils.PlaySoundFile(soundFile, 'SFX')
		if play then
			hasSample = true
			count = count + 1
			StopSound(handle, 0)
		end
	end
	Musician.Preloader.AddPreloaded(sampleId)
	return hasSample, (debugprofilestop() - startTime) / count
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

--- Blizzard's EasyMenu using MSA_DropDownMenu
--
function Musician.Utils.EasyMenu(menuList, menuFrame, anchor, x, y, displayMode, autoHideDelay )
	if ( displayMode == "MENU" ) then
		menuFrame.displayMode = displayMode;
	end
	MSA_DropDownMenu_Initialize(menuFrame, Musician.Utils.EasyMenu_Initialize, displayMode, nil, menuList);
	MSA_ToggleDropDownMenu(1, nil, menuFrame, anchor, x, y, menuList, nil, autoHideDelay);
end

--- Blizzard's EasyMenu_Initialize using MSA_DropDownMenu
--
function Musician.Utils.EasyMenu_Initialize( frame, level, menuList )
	for index = 1, #menuList do
		local value = menuList[index]
		if (value.text) then
			value.index = index;
			MSA_DropDownMenu_AddButton( value, level );
		end
	end
end

--- Set text to a FontString element ensuring the visual text size is respected
-- @param fontString (FontString)
-- @param text (string)
function Musician.Utils.SetFontStringTextFixedSize(fontString, text)

	-- Get expected scale and points with roman text
	if fontString.unscaledPoints == nil then
		-- Measure expected font height
		fontString:SetScale(1)
		fontString:SetText('0')
		_, fontString.expectedFontHeight = fontString:GetFont()

		-- Store points at 1:1 scale
		fontString.unscaledPoints = {}
		local numPoints, i = fontString:GetNumPoints()
		for i = 1, numPoints do
			fontString.unscaledPoints[i] = { fontString:GetPoint(i) }
		end
	end

	-- Set text content
	fontString:SetText(text)

	-- Adjust scale

	local _, fontHeight = fontString:GetFont()
	local scale = 1
	if fontString.expectedFontHeight ~= fontHeight then
		scale = fontString.expectedFontHeight / fontHeight
	end

	fontString:SetScale(scale)

	local i, pointArgs
	for i, pointArgs in pairs(fontString.unscaledPoints) do
		local point, relativeTo, relativePoint, xOfs, yOfs = unpack(pointArgs)
		fontString:SetPoint(point, relativeTo, relativePoint, xOfs / scale, yOfs / scale)
	end
end