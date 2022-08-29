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
local debugStartTime = debugprofilestop()

local GetCVar = (C_CVar and C_CVar.GetCVar or GetCVar)
local GetCVarNumber = function(cvar)
	return floor(tonumber(GetCVar(cvar)) * 1000) / 1000
end

--- Display a message in the console
-- @param msg (string)
function Musician.Utils.Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
end

--- Print debug stuff in the console
-- @param module (string)
-- @param ... (string)
function Musician.Utils.Debug(module, ...)
	local prompt = "[|cFFFFFF00Musician DEBUG|r]"
	local time = debugprofilestop() - debugStartTime
	local s = floor(time / 1000)
	local ms = floor(time % 1000)
	local timeCode = "|cFFA0A0A0" .. Musician.Utils.PaddingZeros(s, 5) .. '.' .. Musician.Utils.PaddingZeros(ms, 3) .. "|r"
	if module ~= nil then
		if Musician_Settings.debug[module] then
			print(prompt, timeCode, "|cFFFFFF00" .. module .. "|r", ...)
		end
	else
		print(prompt, timeCode, ...)
	end
end

--- Display an error message in the console
-- @param msg (string)
function Musician.Utils.PrintError(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
		PlaySound(32051)
	else
		PlaySoundFile("sound\\interface\\error.ogg")
	end
end

--- Display an error message in a popup
-- @param msg (string)
function Musician.Utils.Error(msg)
	message(msg)
	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
		PlaySound(32051)
	else
		PlaySoundFile("sound\\interface\\error.ogg")
	end
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

--- Remove hyperlinks from text
-- @param textWithLinks (string)
-- @return text (string)
function Musician.Utils.RemoveLinks(textWithLinks)
	local text = textWithLinks
	text = string.gsub(text, '|H[^|]+|h', '')
	text = string.gsub(text, '|h', '')
	return text
end

--- Get player hyperlink
-- @param player (string)
-- @return playerLink (string)
function Musician.Utils.GetPlayerLink(player)
	local simplePlayerName, realm = strsplit('-', Musician.Utils.NormalizePlayerName(player), 2)
	local _, myRealm = strsplit('-', Musician.Utils.NormalizePlayerName(UnitName("player")), 2)

	local displayPlayerName = simplePlayerName
	if myRealm ~= realm then
		displayPlayerName = simplePlayerName .. "-" .. realm
	end

	return Musician.Utils.GetLink('player', displayPlayerName, displayPlayerName)
end

--- Get URL hyperlink
-- @param url (string)
-- @return urlLink (string)
function Musician.Utils.GetUrlLink(url)
	return Musician.Utils.Highlight("[" .. Musician.Utils.GetLink('musician', url, 'url') .. "]", "00FFFF")
end

--- Get player full name with realm slug or Battle.net account name if a Battle.net game account ID is provided.
-- @param playerOrGameAccountID (string|number)
-- @return fullPlayerName (string)
function Musician.Utils.GetFullPlayerName(playerOrGameAccountID)
	if Musician.Utils.IsBattleNetID(playerOrGameAccountID) then
		local gameAccountID = playerOrGameAccountID
		local accountID = Musician.Utils.GetBattleNetAccountID(gameAccountID)
		if accountID == nil then return UNKNOWN end

		local accountInfo = Musician.Utils.GetBattleNetAccount(accountID)
		local gameAccountInfo = Musician.Utils.GetBattleNetGameAccount(gameAccountID)

		return accountInfo.accountDisplayName .. ' (' .. gameAccountInfo.characterName .. ')'
	end
	return Musician.Utils.NormalizePlayerName(playerOrGameAccountID)
end

--- Get player name for display
-- @param player (string)
-- @return formattedPlayerName (string)
function Musician.Utils.FormatPlayerName(player)
	return Musician.Utils.SimplePlayerName(Musician.Utils.GetFullPlayerName(player))
end

--- Return true when the provided player name is a Battle.net account ID or Battle.net game account ID.
-- @param playerName (string|number)
-- @return isBattleNetID (boolean)
function Musician.Utils.IsBattleNetID(playerName)
	return type(playerName) == 'number' or string.find(playerName, '^[0-9]+$') ~= nil
end

--- Get the Battle.net account ID from the Battle.net game account ID.
-- @param gameAccountID (number)
-- @return accountID (number)
function Musician.Utils.GetBattleNetAccountID(gameAccountID)
	gameAccountID = tonumber(gameAccountID)
	for i = 1, BNGetNumFriends() do
		local numGameAccounts = C_BattleNet and C_BattleNet.GetFriendNumGameAccounts(i) or BNGetNumFriendGameAccounts(i)
		for g = 1, numGameAccounts do
			local foundGameAccountID
			if C_BattleNet then
				local gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(i, g)
				foundGameAccountID = gameAccountInfo and gameAccountInfo.gameAccountID
			else
				local gameAccountInfo = { BNGetFriendGameAccountInfo(i, g) }
				foundGameAccountID = gameAccountInfo and gameAccountInfo[16]
			end
			if foundGameAccountID == gameAccountID then
				if C_BattleNet then
					local accountInfo = C_BattleNet.GetFriendAccountInfo(i)
					return accountInfo.bnetAccountID
				else
					local accountInfo = { BNGetFriendInfo(i) }
					return accountInfo[1]
				end
			end
		end
	end
	return nil
end

--- Get Battle.net account info for provided Battle.net account ID.
-- @param accountID (number)
-- @return accountInfo (table)
function Musician.Utils.GetBattleNetAccount(accountID)
	local accountInfo
	if C_BattleNet then
		accountInfo = C_BattleNet.GetAccountInfoByID(accountID)
		if accountInfo == nil then return {} end
	else
		local presenceID, accountName, battleTag, isBattleTagPresence,
			_, _, _, isOnline, lastOnline,
			isAFK, isDND, messageText, _, _, messageTime = BNGetFriendInfoByID(accountID)
		if presenceID == nil then return {} end
		accountInfo = {
			bnetAccountID = presenceID, -- Unique numeric identifier for the friend's Battle.net account during this session
			accountName = accountName, -- A protected string representing the friend's full name or BattleTag name
			battleTag = battleTag, -- The friend's BattleTag (e.g., "Nickname#0001")
			--isFriend = , --
			isBattleTagFriend = isBattleTagPresence, -- Whether or not the friend is known by their BattleTag
			lastOnlineTime = lastOnline, -- The number of seconds elapsed since this friend was last online (from the epoch date of January 1, 1970). Returns nil if currently online.
			isAFK = isAFK, -- Whether or not the friend is flagged as Away
			isDND = isDND, -- Whether or not the friend is flagged as Busy
			--isFavorite = , -- Whether or not the friend is marked as a favorite by you
			appearOffline = not(isOnline), --
			customMessage = messageText, -- The Battle.net broadcast message
			customMessageTime = messageTime, -- The number of seconds elapsed since the current broadcast message was sent
			--note = , -- The contents of the player's note about this friend
			--rafLinkType = , -- Enum.RafLinkType
			--gameAccountInfo = , -- BNetGameAccountInfo
		}
	end

	accountInfo.gameAccountInfo = nil
	accountInfo.accountDisplayName = string.gsub(accountInfo.battleTag, '#[0-9]+$', '')

	return accountInfo
end

--- formatClassicGameAccountInfo
-- @return gameAccountInfo (table)
local function formatClassicGameAccountInfo(...)
	local hasFocus, characterName, client, realmName, realmID, faction,
	race, class, _, zoneName, level, gameText, _, _,
	_, bnetIDGameAccount, _, _, _, characterGUID, wowProjectID = ...

	if characterName == nil then return {} end

	local realmDisplayName = string.gsub(gameText, '^.+%s%-%s', '')

	return {
		gameAccountID = bnetIDGameAccount, -- Unique numeric identifier for the friend's Battle.net game account
		clientProgram = client, -- BNET_CLIENT
		isOnline = characterName ~= nil, -- boolean
		--isGameBusy = , -- boolean
		--isGameAFK = , -- boolean
		wowProjectID = wowProjectID, -- number?
		characterName = characterName, -- The name of the logged in toon/character
		realmName = realmName, -- The name of the logged in realm
		realmDisplayName = realmDisplayName, --
		realmID = realmID, -- The ID for the logged in realm
		factionName = faction, -- The englishFaction name (i.e., "Alliance" or "Horde")
		raceName = race, -- The localized race name (e.g., "Blood Elf")
		className = class, -- The localized class name (e.g., "Death Knight")
		areaName = zoneName, -- The localized zone name (e.g., "The Undercity")
		characterLevel = level, -- The current level (e.g., "90")
		richPresence = gameText, -- For WoW, returns "zoneName - realmName". For StarCraft 2 and Diablo 3, returns the location or activity the player is currently engaged in.
		playerGuid = characterGUID, -- A unique numeric identifier for the friend's character during this session.
		--isWowMobile = , --
		--canSummon = , --
		hasFocus = hasFocus, -- Whether or not this toon is the one currently being displayed in Blizzard's FriendFrame
	}
end

--- Get Battle.net WoW game account info for provided Battle.net game account ID.
-- @param gameAccountID (number)
-- @return gameAccountInfo (table)
function Musician.Utils.GetBattleNetGameAccount(gameAccountID)
	if C_BattleNet then
		return C_BattleNet.GetGameAccountInfoByID(gameAccountID) or {}
	else
		return formatClassicGameAccountInfo(BNGetGameAccountInfo(gameAccountID))
	end
end

--- Get WoW game accounts info for provided Battle.net account ID.
-- @param accountID (number)
-- @return gameAccountsInfo (table)
function Musician.Utils.GetBattleNetGameAccounts(accountID)
	local gameAccountsInfo = {}
	local friendIndex = BNGetFriendIndex(accountID)
	if friendIndex == nil then return gameAccountsInfo end
	local numGameAccounts = C_BattleNet and C_BattleNet.GetFriendNumGameAccounts(friendIndex) or BNGetNumFriendGameAccounts(friendIndex)
	if numGameAccounts == nil or numGameAccounts == 0 then return gameAccountsInfo end

	for gameAccountIndex = 1, numGameAccounts do
		local gameAccountInfo
		if C_BattleNet then
			gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(friendIndex, gameAccountIndex)
		else
			gameAccountInfo = formatClassicGameAccountInfo(BNGetFriendGameAccountInfo(friendIndex, gameAccountIndex))
		end

		if gameAccountInfo.clientProgram == 'WoW' and gameAccountInfo.isOnline then
			table.insert(gameAccountsInfo, gameAccountInfo)
		end
	end

	return gameAccountsInfo
end

--- Indicates whenever the provided Battle.net game account ID is online
-- @param gameAccountID (number)
-- @return isOnline (boolean)
function Musician.Utils.IsBattleNetGameAccountOnline(gameAccountID)
	local gameAccountInfo = Musician.Utils.GetBattleNetGameAccount(gameAccountID)
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
	local simplePlayerName, realm = strsplit('-', Musician.Utils.NormalizePlayerName(player), 2)
	local _, myRealm = strsplit('-', Musician.Utils.NormalizePlayerName(UnitName("player")), 2)
	local fullPlayerName = simplePlayerName .. "-" .. realm

	local displayPlayerName = player
	if myRealm ~= realm then
		displayPlayerName = fullPlayerName
	end

	if playerGUID then
		ChatFrame_OnEvent(DEFAULT_CHAT_FRAME, "CHAT_MSG_EMOTE", message, fullPlayerName, '', '', displayPlayerName, '', nil, nil, nil, nil, 0, playerGUID)
	else
		ChatFrame_OnEvent(DEFAULT_CHAT_FRAME, "CHAT_MSG_EMOTE", message, fullPlayerName, '', '', displayPlayerName, '')
	end
end

--- Remove a chat message by its line ID
-- @param lineID (int)
function Musician.Utils.RemoveChatMessage(lineID)
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

	for _ = 1, bytes do
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

	for i = 1, #data do
		num = num * 256 + string.byte(data:sub(i, i))
	end

	return num
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
	local posY, posX, _, instanceID = Musician.Utils.GetPlayerPosition()

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

--- Mute or unmute music from instrument toys (Retail only)
-- @param isMuted (boolean)
function Musician.Utils.SetInstrumentToysMuted(isMuted)
	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
		local muteFunc = isMuted and MuteSoundFile or UnmuteSoundFile
		for _, item in pairs(Musician.InstrumentToys) do
			for _, file in pairs(item.soundFiles) do
				muteFunc(file)
			end
		end
	end
end

--- Calculate the maximum polyphony depending on the enabled audio channels.
-- @return polyphony (number)
function Musician.Utils.GetMaxPolyphony()
	local audioChannels = Musician_Settings.audioChannels
	return (audioChannels.Master and 30 or 0) + (audioChannels.SFX and 15 or 0) + (audioChannels.Dialog and 20 or 0)
end

--- Get the current audio settings.
-- @return audioSettings (table)
function Musician.Utils.GetCurrentAudioSettings()
	return {
		audioChannels = Mixin({}, Musician_Settings.audioChannels),
		polyphony = Musician.Utils.GetMaxPolyphony(),
		CVars = {
			Sound_SFXVolume = GetCVarNumber('Sound_SFXVolume'),
			Sound_DialogVolume = GetCVarNumber('Sound_DialogVolume'),
			Sound_NumChannels = GetCVarNumber('Sound_NumChannels'),
		}
	}
end

--- Get the new audio settings that differs from the provided ones.
-- @param oldSettings (table) as returned by Musician.Utils.GetCurrentAudioSettings()
-- @return newSettings (table)
function Musician.Utils.GetNewAudioSettings(oldSettings)

	local audioChannels = Mixin({}, Musician_Settings.audioChannels)
	local newSettings = {
		audioChannels = audioChannels,
		polyphony = Musician.Utils.GetMaxPolyphony(),
		CVars = {}
	}

	-- Master is enabled along with SFX: make sure SFX level is 100%
	if audioChannels.Master and audioChannels.SFX and oldSettings.CVars.Sound_SFXVolume ~= 1 then
		newSettings.CVars.Sound_SFXVolume = 1
	end

	-- Master is enabled along with Dialog: make sure Dialog level is 100%
	if audioChannels.Master and audioChannels.Dialog and oldSettings.CVars.Sound_DialogVolume ~= 1 then
		newSettings.CVars.Sound_DialogVolume = 1
	end

	-- Dialog is enabled along with SFX: Use the highest value of the two
	if not(audioChannels.Master) and audioChannels.SFX and audioChannels.Dialog then
		local sfxVolume = oldSettings.CVars.Sound_SFXVolume
		local dialogVolume = oldSettings.CVars.Sound_DialogVolume
		if sfxVolume > dialogVolume and newSettings.CVars.Sound_DialogVolume ~= sfxVolume then
			newSettings.CVars.Sound_DialogVolume = sfxVolume
		elseif dialogVolume > sfxVolume and newSettings.CVars.Sound_SFXVolume ~= dialogVolume then
			newSettings.CVars.Sound_SFXVolume = dialogVolume
		end
	end

	-- Make sure we have enough audio channels to fit the polyphony
	if oldSettings.CVars.Sound_NumChannels < newSettings.polyphony then
		local channelNumberSettings = { 24, 48, 64, 128, 256, 512 }
		for _, numChannels in pairs(channelNumberSettings) do
			if numChannels >= newSettings.polyphony then
				if newSettings.CVars.Sound_NumChannels ~= numChannels then
					newSettings.CVars.Sound_NumChannels = numChannels
				end
				break
			end
		end
	end

	return newSettings
end

--- Update the audio settings to the new provided parameters
-- @param newSettings (table) as returned by Musician.Utils.GetCurrentAudioSettings() or Musician.Utils.GetNewAudioSettings()
-- @param [noSoundSystemRestart=false] (boolean) Don't restart sound system when true
function Musician.Utils.UpdateAudioSettings(newSettings, noSoundSystemRestart)

	-- Avoid changing settings while in combat
	if InCombatLockdown() then
		C_Timer.After(1, function() Musician.Utils.UpdateAudioSettings(newSettings, noSoundSystemRestart) end)
		return
	end

	-- CVars
	for key, value in pairs(newSettings.CVars) do
		if GetCVarNumber(key) ~= value then
			SetCVar(key, value)
			-- Sound system needs to be restarted after the total number of sound channels was changed
			if key == 'Sound_NumChannels' and not(noSoundSystemRestart) then
				Sound_GameSystem_RestartSoundSystem()
			end
		end
	end

	-- Musician audio channels
	Mixin(Musician_Settings.audioChannels, newSettings.audioChannels)
end

--- Automatically adjust the audio settings, if needed.
-- @param [noSoundSystemRestart=false] (boolean) Don't restart sound system when true
function Musician.Utils.AdjustAudioSettings(noSoundSystemRestart)
	-- Always make sure at least one audio channel is selected (SFX)
	local audioChannels = Musician_Settings.audioChannels
	if not(audioChannels.Master) and not(audioChannels.SFX) and not(audioChannels.Dialog) then
		audioChannels.SFX = true
	end

	-- Adjust audio settings if the option is enabled
	if Musician_Settings.autoAdjustAudioSettings then
		local currentAudioSettings = Musician.Utils.GetCurrentAudioSettings()
		local newAudioSettings = Musician.Utils.GetNewAudioSettings(currentAudioSettings)
		Musician.Utils.UpdateAudioSettings(newAudioSettings, noSoundSystemRestart)
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

--- Return the normalized player name, including realm slug. Normalized player name is a number if a Battle.net account ID or Battle.net game account ID is provided.
-- @param playerName (string|number)
-- @return normalizedPlayerName (string|number)
function Musician.Utils.NormalizePlayerName(playerName)
	-- Battle.net ID
	if Musician.Utils.IsBattleNetID(playerName) then
		return tonumber(playerName)
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
		local ellipsis = '…'
		if #ellipsis > maxBytes then
			return '' -- The ellipsis doesn't fit
		elseif #ellipsis == maxBytes then
			return ellipsis -- Only the ellipsis fits
		end
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
	for _, locale in pairs(Musician.Locale) do
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
	return GetAddOnMetadata("Musician", "Version")
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

	local m

	if #parts >= 2 then
		m = string.match(parts[#parts - 1], "(%d*)")
	end
	local s, _, cs = string.match(parts[#parts], "(%d*)(%.?)(%d*)")

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
		fontString.expectedFontHeight = select(2, fontString:GetFont())

		-- Store points at 1:1 scale
		fontString.unscaledPoints = {}
		local numPoints = fontString:GetNumPoints()
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

	for _, pointArgs in pairs(fontString.unscaledPoints) do
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
	for key, value in pairs(listCopy) do
		func(value, key, list)
	end
end

--- Randomly returns one of the provided arguments
--
function Musician.Utils.GetRandomArgument(...)
	return (select(random(select("#", ...)), ...));
end