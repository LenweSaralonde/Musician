--- Utility functions
-- @module Musician.Utils

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

--- Print debug stuff in the console
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

--- Display a message in a popup
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
-- @return highlightedText (string)
function Musician.Utils.Highlight(text, color)

	if color == nil then
		color = 'FFFFFF'
	elseif type(color) == 'table' and color.GenerateHexColorMarkup then
		return color:GenerateHexColorMarkup() .. text .. "|r"
	end

	return "|cFF" .. color .. text .. "|r"
end

--- Remove text coloring
-- @param highlightedText (string)
-- @return text (string)
function Musician.Utils.RemoveHighlight(highlightedText)
	local text = highlightedText
	text = string.gsub(text, '|c[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]', '')
	text = string.gsub(text, '|r', '')
	return text
end

--- Get color code from RGB values
-- @param r (number) 0-1
-- @param g (number) 0-1
-- @param b (number) 0-1
-- @return colorCode (string)
function Musician.Utils.GetColorCode(r, g, b)
	local rh = string.format('%02X', floor(r * 255))
	local gh = string.format('%02X', floor(g * 255))
	local bh = string.format('%02X', floor(b * 255))
	return "|cFF" .. rh .. gh .. bh
end

--- Format text, adding highlights etc.
-- @param text (string)
-- @return formattedText (string)
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
-- @return link (string)
function Musician.Utils.GetLink(command, text, ...)
	return "|H" .. strjoin(':', command, ... ) .. "|h" .. text .. "|h"
end

--- Get player hyperlink
-- @param player (string)
-- @return playerLink (string)
function Musician.Utils.GetPlayerLink(player)
	local player, realm = strsplit('-', Musician.Utils.NormalizePlayerName(player), 2)
	local _, myRealm = strsplit('-', Musician.Utils.NormalizePlayerName(UnitName("player")), 2)

	if myRealm ~= realm then
		player = player .. "-" .. realm
	end

	return Musician.Utils.GetLink('player', player, player)
end

--- Get player full name with realm slug or Battle.net account name if a Battle.net game account ID is provided
-- @param player (string)
-- @return fullPlayerName (string)
function Musician.Utils.GetFullPlayerName(player)
	if Musician.Utils.IsBattleNetID(player) then
		for i = 1, BNGetNumFriends() do
			local accountInfo = C_BattleNet.GetFriendAccountInfo(i)
			if accountInfo.gameAccountInfo and accountInfo.gameAccountInfo.gameAccountID == tonumber(player) then
				return string.gsub(accountInfo.battleTag, '#[0-9]+$', '')
			end
		end
		return UNKNOWN
	end
	return Musician.Utils.NormalizePlayerName(player)
end

--- Get player name for display
-- @param player (string)
-- @return formattedPlayerName (string)
function Musician.Utils.FormatPlayerName(player)
	return Musician.Utils.SimplePlayerName(Musician.Utils.GetFullPlayerName(player))
end

--- Return true when the provided player name is a Battle.net ID
-- @param playerName (string)
-- @return isBattleNetID (boolean)
function Musician.Utils.IsBattleNetID(playerName)
	return string.find(playerName, '^%d+$') ~= nil
end

--- Get Battle.net game account ID from the Battle.net account ID.
-- @param battleNetAccountId (string)
-- @return battleNetGameAccountId (string)
function Musician.Utils.GetBattleNetGameAccountID(battleNetAccountId)
	local accountInfo = C_BattleNet.GetAccountInfoByID(battleNetAccountId)
	local gameAccountInfo = accountInfo and accountInfo.gameAccountInfo
	if gameAccountInfo and Musician.Utils.IsBattleNetGameAccountOnline(gameAccountInfo.gameAccountID) then
		return gameAccountInfo.gameAccountID
	end
	return nil
end

--- Indicates whenever the provided game account ID is online
-- @param gameAccountId (int)
-- @return isOnline (string)
function Musician.Utils.IsBattleNetGameAccountOnline(gameAccountId)
	local gameAccountInfo = C_BattleNet.GetGameAccountInfoByID(gameAccountId)
	return gameAccountInfo and gameAccountInfo.clientProgram == 'WoW' and gameAccountInfo.isOnline
end
--- Return the code to insert an icon in a chat message or a text string
-- @param path (string)
-- @param[opt=0] r (number) 0-1
-- @param[opt=0] g (number) 0-1
-- @param[opt=0] b (number) 0-1
-- @return chatIcon (string)
function Musician.Utils.GetChatIcon(path, r, g, b)
	if r ~= nil and g ~= nil and b ~= nil then
		r = floor(r * 255) or 0
		g = floor(g * 255) or 0
		b = floor(b * 255) or 0
		return "|T" .. path .. ":0:aspectRatio:0:0:1:1:0:1:0:1:" .. r .. ":" .. g .. ":" .. b .. "|t"
	end

	return "|T" .. path .. ":0:aspectRatio|t"
end

--- Get the player position in the 3D world
-- @return posY (number)
-- @return posX (number)
-- @return posZ (number) Always 0
-- @return instanceID (number)
function Musician.Utils.GetPlayerPosition()
	local posY, posX, posZ, instanceID = UnitPosition("player") -- posZ is always 0
	return posY or 0, posX or 0, posZ or 0, instanceID or 0xFFFFFFFF
end

--- Display a faked emote
-- @param player (string)
-- @param playerGUID (string)
-- @param message (string)
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
-- @param lineID (int)
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

--- Read some bytes from a string and remove them
-- @param str (string)
-- @param bytes (int)
-- @return data (string) read bytes
-- @return str (string) new string
function Musician.Utils.ReadBytes(str, bytes)
	return string.sub(str, 1, bytes), string.sub(str, bytes + 1)
end

--- Pack an integer number into a string
-- @param num (int) integer to pack
-- @param bytes (int) number of bytes
-- @return data (string)
function Musician.Utils.PackNumber(num, bytes)
	local m = num
	local b
	local packed = ''
	local i

	for i = 1, bytes do
		b = m % 256
		m = (m - b) / 256
		packed = string.char(b) .. packed
	end

	return string.sub(packed, -bytes)
end

--- Unpack a string into an integer number
-- @param data (string)
-- @return num (int)
function Musician.Utils.UnpackNumber(data)
	local num = 0

	local i
	for i = 1, #data do
		num = num * 256 + string.byte(data:sub(i, i))
	end

	return num
end

local base64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

--- Decode base 64 string
-- Lua 5.1+ base64 v3.0 (c) 2009 by Alex Kloss <alexthkloss@web.de>
-- licensed under the terms of the LGPL2
-- http://lua-users.org/wiki/BaseSixtyFour
-- @param data (string)
-- @return str (string)
function Musician.Utils.Base64Decode(data)
	local b=base64chars
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

--- Encode base 64 string
-- Lua 5.1+ base64 v3.0 (c) 2009 by Alex Kloss <alexthkloss@web.de>
-- licensed under the terms of the LGPL2
-- http://lua-users.org/wiki/BaseSixtyFour
-- @param data (string)
-- @return string
function Musician.Utils.Base64Encode(data)
	local b=base64chars
	return ((data:gsub('.', function(x)
		local r,b='',x:byte()
		for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
		return r;
	end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
		if (#x < 6) then return '' end
		local c=0
		for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
		return b:sub(c+1,c+1)
	end)..({ '', '==', '=' })[#data%3+1])
end

--- Pack a time or duration in seconds into a string
-- @param seconds (float)
-- @param bytes (int) Number of bytes
-- @param fps (float) Precision in frames par second
-- @return data (string)
function Musician.Utils.PackTime(seconds, bytes, fps)
	return Musician.Utils.PackNumber(floor(seconds * fps + .5), bytes)
end

--- Unpack a string into a time or duration in seconds
-- @param data (string)
-- @param fps (float) Precision in frames par second
-- @return seconds (float)
function Musician.Utils.UnpackTime(data, fps)
	return Musician.Utils.UnpackNumber(data) / fps
end

--- Pack player GUID into a 6-byte string
-- @return data (string)
function Musician.Utils.PackPlayerGuid()
	local _, serverId, playerHexId = string.split('-', UnitGUID("player"))
	return Musician.Utils.PackNumber(tonumber(serverId), 2) .. Musician.Utils.FromHex(playerHexId)
end

--- Unpack player GUID from string
-- @param str (string)
-- @return guid (string)
function Musician.Utils.UnpackPlayerGuid(str)
	local serverId = Musician.Utils.UnpackNumber(string.sub(str, 1, 2))
	local playerHexId = Musician.Utils.ToHex(string.sub(str, 3, 6))
	return "Player-" .. serverId .. "-" .. playerHexId
end

--- Pack player position into a 18-byte chunk string
-- @return data (string)
function Musician.Utils.PackPlayerPosition()
	local posY, posX, posZ, instanceID = Musician.Utils.GetPlayerPosition()

	-- Only set (0, 0) as integer coordinates when posX and posY exactly equal 0,
	-- meaning the coordinates could not be retrieved (for example in a dungeon).
	if not(posX == 0 and posY == 0) and posX >= -.5 and posX < .5 and posY >= -.5 and posY < 5 then
		-- Round to the closest non-zero integer coordinates
		posX = 2 * floor(posX) + 1
		posY = 2 * floor(posY) + 1
	end

	local x = Musician.Utils.PackNumber(floor(posX + .5) + 0x7fffffff, 4)
	local y = Musician.Utils.PackNumber(floor(posY + .5) + 0x7fffffff, 4)
	local i = Musician.Utils.PackNumber(instanceID, 4)
	local g = Musician.Utils.PackPlayerGuid()

	return x .. y .. i .. g
end

--- Unpack player position from chunk string
-- @param str (string)
-- @return posY (number)
-- @return posX (number)
-- @return posZ (number)
-- @return instanceID (int)
-- @return guid (string)
function Musician.Utils.UnpackPlayerPosition(str)
	local posX = Musician.Utils.UnpackNumber(string.sub(str, 1, 4)) - 0x7fffffff
	local posY = Musician.Utils.UnpackNumber(string.sub(str, 5, 8)) - 0x7fffffff
	local instanceID = Musician.Utils.UnpackNumber(string.sub(str, 9, 12))
	local guid = Musician.Utils.UnpackPlayerGuid(string.sub(str, 13, 18))

	return posY, posX, 0, instanceID, guid
end

--- Convert hex string to string
-- @param hex (string)
-- @return str (string)
function Musician.Utils.FromHex(hex)
	return (hex:gsub('..', function (cc)
		return string.char(tonumber(cc, 16))
	end))
end

--- Convert string to hex string
-- @param str (string)
-- @return hex (string)
function Musician.Utils.ToHex(str)
	return (str:gsub('.', function (c)
		return string.format('%02X', string.byte(c))
	end))
end

--- Return true if a song is actually playing and is audible
-- @return isPlaying (boolean)
function Musician.Utils.SongIsPlaying()
	local playingSongs = Musician.Song.GetPlayingSongs()
	local song
	for _, song in pairs(playingSongs) do
		if song:IsAudible() then
			return true
		end
	end
	return false
end

--- Start or stop the actual game music if a song can actually be heard
-- @param force (boolean)
function Musician.Utils.MuteGameMusic(force)
	local isMusicianPlaying = Musician.Utils.SongIsPlaying() or Musician.Live.IsPlaying()
	local isInGameMusicEnabled = GetCVar("Sound_EnableMusic") ~= "0"
	local mute = Musician_Settings.muteGameMusic and isInGameMusicEnabled and isMusicianPlaying and not(Musician.Sampler.GetMuted())

	if not(force) and isGameMusicMuted == mute then return end

	if mute then
		-- Play a silent music track to mute and fade actual game music
		PlayMusic("Interface\\AddOns\\Musician\\instruments\\silent\\silent.mp3")
		isGameMusicMuted = true
	elseif isGameMusicMuted then
		-- Stop custom silent music, resume game music
		StopMusic()
		isGameMusicMuted = false
	end
end

local currentNormalizedRealmName

--- Return the normalized realm name the player belongs to
-- Safer than the standard GetNormalizedRealmName() that may return nil sometimes
-- @return realmName (string)
function Musician.Utils.GetNormalizedRealmName()
	if currentNormalizedRealmName then
		return currentNormalizedRealmName
	end
	currentNormalizedRealmName = GetNormalizedRealmName()
	return currentNormalizedRealmName
end

--- Return the short locale code of the realm the player belongs to
-- @return locale (string) 'en', 'fr' etc.
function Musician.Utils.GetRealmLocale()
	local locale = select(5, LibRealmInfo:GetRealmInfoByUnit("player")) or GetLocale()
	return string.gsub(locale, "[A-Z]+", "")
end

--- Return the normalized player name, including realm slug
-- @param playerName (string)
-- @return normalizedPlayerName (string)
function Musician.Utils.NormalizePlayerName(playerName)
	-- Battle.net id
	if Musician.Utils.IsBattleNetID(playerName) then
		return tostring(playerName) -- Should always be a string
	end

	-- Append missing realm name
	if string.find(playerName, '-') == nil then
		return playerName .. '-' .. Musician.Utils.GetNormalizedRealmName()
	end

	return playerName
end

--- Return the normalized song name
-- @param songName (string)
-- @return normalizedSongName (string)
function Musician.Utils.NormalizeSongName(songName)
	return Musician.Utils.Ellipsis(strtrim(songName), Musician.Song.MAX_NAME_LENGTH)
end

--- Return the simple player name, including the realm slug if needed
-- @param playerName (string)
-- @return simpleName (string)
-- @return realmName (string)
-- @return fullName (string)
local function getPlayerNameParts(playerName)
	local fullName = Musician.Utils.NormalizePlayerName(playerName)
	local simpleName, realmName = string.split('-', fullName)
	return simpleName, realmName, fullName
end

--- Return the simple player name, including the realm slug if needed
-- @param playerName (string)
-- @return simpleName (string)
function Musician.Utils.SimplePlayerName(playerName)
	local _, myRealmName = getPlayerNameParts(UnitName("player"))
	local simpleName, realmName, fullName = getPlayerNameParts(playerName)

	if realmName == myRealmName then
		return simpleName
	end

	return fullName
end

--- Return the player realm slug
-- @param playerName (string)
-- @return realmSlug (string)
function Musician.Utils.PlayerRealm(playerName)
	return select(2, getPlayerNameParts(playerName))
end

--- Return true if the player is in my party or raid
-- @param playerName (string)
-- @return isInMyGroup (boolean)
function Musician.Utils.PlayerIsInGroup(playerName)
	local simpleName = Musician.Utils.SimplePlayerName(playerName)
	return UnitInParty(simpleName) and UnitIsConnected(simpleName)
end

--- Return true if the provided player name is myself
-- @param playerName (string)
-- @return isMyself (boolean)
function Musician.Utils.PlayerIsMyself(playerName)
	return playerName ~= nil and Musician.Utils.NormalizePlayerName(playerName) == Musician.Utils.NormalizePlayerName(UnitName("player"))
end

--- Return true if the provided player name is on the same realm or connected realm as me
-- @param playerName (string)
-- @return isOnSameRealm (boolean)
function Musician.Utils.PlayerIsOnSameRealm(playerName)
	local playerRealm = Musician.Utils.PlayerRealm(playerName)

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
-- @return isVisible (boolean)
function Musician.Utils.PlayerGuidIsVisible(guid)
	return guid and C_PlayerInfo.IsConnected(PlayerLocation:CreateFromGUID(guid))
end

--- Shortens the UTF-8 text with ellipsis if its size in bytes is longer than specified
-- @param text (string)
-- @param maxBytes (int)
-- @return ellipsisText (string)
function Musician.Utils.Ellipsis(text, maxBytes)
	if #text > maxBytes then
		local ellipsis = (maxBytes > 3) and '…' or ''
		local cursor = maxBytes - #ellipsis
		local characterCount = strlenutf8(string.sub(text, 1, cursor))

		-- Cutting within an UTF-8 character
		if cursor < #text and characterCount == strlenutf8(string.sub(text, 1, cursor + 1)) then
			-- Remove incomplete UTF-8 character as well
			while cursor >= 1 and characterCount == strlenutf8(string.sub(text, 1, cursor)) do
				cursor = cursor - 1
			end
		end

		return string.sub(text, 1, cursor) .. ellipsis
	end
	return text
end

--- Returns localized message
-- @param msg (string)
-- @param[opt] locale (string) Defaults to the realm locale
-- @return localizedMsg (string)
function Musician.Utils.GetMsg(msg, locale)
	if locale == nil then locale = Musician.Utils.GetRealmLocale() end
	return Musician.Locale[locale] and Musician.Locale[locale][msg] or Musician.Msg[msg]
end

--- Return the "Player is playing music" emote with promo message
-- @return promoEmote (string)
function Musician.Utils.GetPromoEmote()
	local EMOTE_PLAYING_MUSIC = Musician.Utils.GetMsg('EMOTE_PLAYING_MUSIC')
	local EMOTE_PROMO = Musician.Utils.GetMsg('EMOTE_PROMO')

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
-- @return hasPromoEmote (boolean)
-- @return isFullPromoEmote (boolean) true if the emote contains the part invinting other players to install Musician
function Musician.Utils.HasPromoEmote(message)
	local lang
	for lang, locale in pairs(Musician.Locale) do
		if locale.EMOTE_PLAYING_MUSIC ~= nil and string.find(message, locale.EMOTE_PLAYING_MUSIC, 1, true) == 1 then
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
--
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
-- @return version (string)
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
-- @return difference (number) 0 if A = B, 1 if A > B, -1 if A < B
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
-- @param number (int)
-- @param zeros (int)
-- @return formattedNumber (string)
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
-- @return formattedTime (string)
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

--- Parse time in seconds from mm:ss.ss format
-- @param timestamp (string)
-- @return seconds (number)
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

--- Shallow copy a table
-- http://lua-users.org/wiki/CopyTable
-- @param orig (table)
-- @return copy (table)
function Musician.Utils.ShallowCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--- Deep copy a table
-- http://lua-users.org/wiki/CopyTable
-- @param orig (table)
-- @return copy (table)
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
-- @return merged (table)
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
-- @return flipped (table)
function Musician.Utils.FlipTable(orig)
	local flipped = {}
	local key, value
	for key, value in pairs(orig) do
		flipped[value] = key
	end
	return flipped
end

--- Return operating system name
-- @return os (string)
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

--- Return byte reader functions for provided data string
-- @param data (string)
-- @param err (string) Error to be returned in case of reading error
-- @return readBytes (function), getCursor (function)
function Musician.Utils.GetByteReader(data, err)
	local cursor = 1
	return function(length)
		if length == nil then length = 1 end
		local bytes = string.sub(data, cursor, cursor + length - 1)
		cursor = cursor + length
		if cursor > #data + 1 and err then
			error(err)
		end
		return bytes
	end,
	function()
		return cursor
	end
end

--- Call function for each item of the provided table
-- @param list (table)
-- @param func (function) Takes 3 arguments: value, key and the provided table.
function Musician.Utils.ForEach(list, func)
	-- Make a shallow copy of the table to avoid issues if an element is removed in the process
	local listCopy = Musician.Utils.ShallowCopy(list)
	local key, value
	for key, value in pairs(listCopy) do
		func(value, key, list)
	end
end
