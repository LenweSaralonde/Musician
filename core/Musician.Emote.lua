--- Emote management module
-- Handles the "Player is playing music" promo emote sent when playing a song and display other players actions as emotes.
-- @module Musician.Emote

Musician.Emote = LibStub("AceAddon-3.0"):NewAddon("Musician.Emote", "AceEvent-3.0")

local MODULE_NAME = "Emote"
Musician.AddModule(MODULE_NAME)

local FULL_PROMO_EMOTE_COOLDOWN = 10 * 60 -- Cooldown in seconds for the full promo emote
local PROMO_EMOTE_TIMEOUT = 2 -- Time in seconds after which an error is displayed if the song of a received promo emote is not playing

local ChatFrame_AddMessageEventFilter = ChatFrameUtil and ChatFrameUtil.AddMessageEventFilter or ChatFrame_AddMessageEventFilter
local SendChatMessage = (C_ChatInfo and C_ChatInfo.SendChatMessage or SendChatMessage)
local ChatFrame_OnEvent = ChatFrameMixin and ChatFrameMixin.OnEvent or ChatFrame_OnEvent
local BetterDate = TimeUtil and TimeUtil.BetterDate or BetterDate

local fullPromoEmoteLastSeen
local overrideNextFullPromoEmote = false
local isDisplayingEmote = false -- true while an emote is being displayed by Musician.Emote.DisplayEmote()
local pendingPromoEmotes = {} -- Promo emotes received while the player's song is not playing yet, by player name

--- Set the received promo emote of a player as pending until the player's song plays
-- Cancels the previously pending promo emote of the player, if any.
-- @param playerName (string)
-- @param lineID (int) Chat line ID of the promo emote
-- @param timer (table) Timeout timer, as returned by C_Timer.NewTimer()
-- @param resolve (function) Function to call with isPromoEmoteSuccessful when the outcome is known
local function setPendingPromoEmote(playerName, lineID, timer, resolve)
	Musician.Emote.CancelPendingPromoEmote(playerName)
	pendingPromoEmotes[Musician.Utils.NormalizePlayerName(playerName)] = {
		lineID = lineID,
		timer = timer,
		resolve = resolve,
	}
end

--- Return the chat line ID of the pending promo emote of a player
-- @param playerName (string)
-- @return lineID (int|nil)
local function getPendingPromoEmoteLineID(playerName)
	local pendingPromoEmote = pendingPromoEmotes[Musician.Utils.NormalizePlayerName(playerName)]
	return pendingPromoEmote and pendingPromoEmote.lineID
end

--- Resolve the pending promo emote of a player, if any
-- @param playerName (string)
-- @param isPromoEmoteSuccessful (boolean) true if the player's song is playing
local function resolvePendingPromoEmote(playerName, isPromoEmoteSuccessful)
	local pendingPromoEmote = pendingPromoEmotes[Musician.Utils.NormalizePlayerName(playerName)]
	if pendingPromoEmote then
		Musician.Emote.CancelPendingPromoEmote(playerName)
		pendingPromoEmote.resolve(isPromoEmoteSuccessful)
	end
end

--- Chat filter handling the received promo emotes
-- Add stop button to "Player plays music" emote
local function promoEmoteFilter(self, event, msg, player, languageName, channelName, playerName2, pflag, ...)
	-- Emote displayed by Musician itself
	if isDisplayingEmote then
		return false, msg, player, languageName, channelName, playerName2, pflag, ...
	end

	-- "Player is playing music."
	local isPromoEmote, isFullPromoEmote = Musician.Emote.HasPromoEmote(msg)
	if not isPromoEmote then
		return false, msg, player, languageName, channelName, playerName2, pflag, ...
	end

	if isFullPromoEmote then
		Musician.Emote.ResetFullPromoEmoteCooldown()
	end

	local fullPlayerName = Musician.Utils.NormalizePlayerName(player)
	local _, _, _, _, lineID, playerGUID = ...
	local song = Musician.songs[fullPlayerName]

	-- Music is loaded and actually playing
	if song ~= nil and song:IsPlaying() then
		-- Ignore emote if the player has already been notified by another message
		if song.notified and song.notifiedLineID ~= lineID then
			return true
		end

		-- Remove the "promo" part of the emote and mark as already notified
		msg = Musician.Emote.GetPlayingMusicEmote(fullPlayerName)
		if not song.notified then
			song.notified = true
			song.notifiedLineID = lineID
			Musician.Emote:SendMessage(Musician.Events.PromoEmote, true, msg, fullPlayerName,
				languageName, channelName, playerName2, pflag, ...)
		end

		return false, msg, player, languageName, channelName, playerName2, pflag, ...
	end

	-- The song is usually not playing yet when the emote is received, since the emote is sent
	-- when the song starts streaming. Hide the emote for now: the "Player is playing music" emote will be
	-- displayed when the song actually starts playing, or an error if it's still not playing after a while.
	-- The filter is called once per chat frame: only handle the message once.
	if getPendingPromoEmoteLineID(fullPlayerName) ~= lineID then
		local eventArgs = { languageName, channelName, playerName2, pflag, ... }
		local eventArgsCount = 4 + select('#', ...)

		local function resolve(isPromoEmoteSuccessful)
			if isPromoEmoteSuccessful then
				-- The "Player is playing music" emote is displayed when the song starts playing
				msg = Musician.Emote.GetPlayingMusicEmote(fullPlayerName)
			else
				msg = Musician.Emote.GetPromoEmoteErrorMessage(player, fullPlayerName, languageName)
				Musician.Emote.DisplayEmote(player, playerGUID, msg, lineID)
			end

			-- Send promo emote event
			Musician.Emote:SendMessage(Musician.Events.PromoEmote, isPromoEmoteSuccessful, msg, fullPlayerName,
				unpack(eventArgs, 1, eventArgsCount))
		end

		-- The song is still not playing after the timeout: display the error
		local timer = C_Timer.NewTimer(PROMO_EMOTE_TIMEOUT, function()
			resolvePendingPromoEmote(fullPlayerName, false)
		end)

		setPendingPromoEmote(fullPlayerName, lineID, timer, resolve)
	end

	return true
end

--- Initialize module
--
function Musician.Emote.Init()
	ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", promoEmoteFilter)

	-- Resolve the pending promo emote as soon as the player's song starts playing
	Musician.Emote:RegisterMessage(Musician.Events.SongPlay, function(event, song)
		if song.player then
			resolvePendingPromoEmote(song.player, true)
		end
	end)
end

--- Cancel the pending promo emote of a player, if any
-- @param playerName (string)
function Musician.Emote.CancelPendingPromoEmote(playerName)
	playerName = Musician.Utils.NormalizePlayerName(playerName)
	local pendingPromoEmote = pendingPromoEmotes[playerName]
	if pendingPromoEmote then
		pendingPromoEmote.timer:Cancel()
		pendingPromoEmotes[playerName] = nil
	end
end

--- Display a player action as an emote
-- @param player (string)
-- @param playerGUID (string)
-- @param message (string)
-- @param[opt=0] lineID (int) Chat line ID
function Musician.Emote.DisplayEmote(player, playerGUID, message, lineID)
	lineID = lineID or 0

	-- Old school way
	if not ChatFrameUtil or not ChatFrameUtil.GetDecoratedSenderName then
		isDisplayingEmote = true
		ChatFrame_OnEvent(DEFAULT_CHAT_FRAME, "CHAT_MSG_EMOTE", message, player, '', '', player, '', nil, nil, nil, nil, lineID, playerGUID)
		isDisplayingEmote = false
		return
	end

	local coloredName = ChatFrameUtil.GetDecoratedSenderName("CHAT_MSG_EMOTE", message, player, nil, nil, player, nil,
	nil, nil, nil, nil, lineID, playerGUID)
	local playerLink = GetPlayerLink(player, coloredName, lineID)

	local emoteMessage = playerLink .. " " .. message

	--Add Timestamps
	local chatTimestampFmt = ChatFrameUtil.GetTimestampFormat()
	if (chatTimestampFmt) then
		emoteMessage = BetterDate(chatTimestampFmt, time()) .. emoteMessage
	end

	local info = ChatTypeInfo.EMOTE
	for i = 1, NUM_CHAT_WINDOWS do
		local chatFrame = _G["ChatFrame" .. i]
		if chatFrame and chatFrame:ContainsMessageGroup("EMOTE") then
			chatFrame:AddMessage(emoteMessage, info.r, info.g, info.b, info.id)
		end
	end
end

--- Return the "Player is playing music" emote with promo message
-- @return promoEmote (string)
function Musician.Emote.GetPromoEmote()
	local EMOTE_PLAYING_MUSIC = Musician.Utils.GetMsg('EMOTE_PLAYING_MUSIC')
	local EMOTE_PROMO = Musician.Utils.GetMsg('EMOTE_PROMO')

	local sendPromoPart = Musician_Settings.enableEmotePromo

	-- Do not send the promo part too often
	if sendPromoPart and
		(
		overrideNextFullPromoEmote or
			fullPromoEmoteLastSeen ~= nil and (fullPromoEmoteLastSeen + FULL_PROMO_EMOTE_COOLDOWN) > GetTime()) then
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
-- @return isFullPromoEmote (boolean) true if the emote contains the part inviting other players to install Musician
function Musician.Emote.HasPromoEmote(message)
	for _, locale in pairs(Musician.Locale) do
		if locale.EMOTE_PLAYING_MUSIC ~= nil and string.find(message, locale.EMOTE_PLAYING_MUSIC, 1, true) == 1 then
			local isFullPromoEmote = string.find(message, locale.EMOTE_PROMO, 1, true) ~= nil
			return true, isFullPromoEmote
		end
	end

	return false, false
end

--- Return the "Player is playing music" emote message, with action links
-- @param fullPlayerName (string)
-- @return msg (string)
function Musician.Emote.GetPlayingMusicEmote(fullPlayerName)
	local msg = Musician.Msg.EMOTE_PLAYING_MUSIC

	-- Add action link if playing music (and not current player)
	if not Musician.Utils.PlayerIsMyself(fullPlayerName) then
		-- Stop music
		if not Musician.PlayerIsMuted(fullPlayerName) then
			local stopAction = Musician.Utils.Highlight(
				Musician.Utils.GetLink("musician", Musician.Msg.STOP, "stop", fullPlayerName), 'FF0000')
			msg = msg .. " " .. Musician.Utils.Highlight('[') .. stopAction .. Musician.Utils.Highlight(']')
		-- Unmute player
		else
			local unmuteAction = Musician.Utils.Highlight(
				Musician.Utils.GetLink("musician", Musician.Msg.UNMUTE, "unmute", fullPlayerName), '00FF00')
			msg = msg .. " " .. Musician.Utils.Highlight('[') .. unmuteAction .. Musician.Utils.Highlight(']')
		end
	end

	return msg
end

--- Return the "Player is playing music" emote message with the reason why the music can't be heard
-- @param player (string) Player name, as provided by the chat event
-- @param fullPlayerName (string)
-- @param languageName (string) Language of the emote, as provided by the chat event
-- @return msg (string)
function Musician.Emote.GetPromoEmoteErrorMessage(player, fullPlayerName, languageName)
	-- Player is not in the channel and not in my group: it's from another realm
	if not Musician.Utils.PlayerIsOnSameRealm(player) and not Musician.Utils.PlayerIsInGroup(player) then
		return Musician.Msg.EMOTE_PLAYING_MUSIC ..
			" " .. Musician.Utils.Highlight(Musician.Msg.EMOTE_PLAYER_OTHER_REALM, 'FF0000')
	end

	-- languageName may not be provided
	if languageName == nil or languageName == '' then
		languageName = GetDefaultLanguage()
	end

	-- Determine if it's a language I'm supposed to understand
	local isUnderstoodLanguage = false
	for l = 1, GetNumLanguages() do
		local myLanguageName, _ = GetLanguageByIndex(l)
		if languageName == myLanguageName then
			isUnderstoodLanguage = true
			break
		end
	end

	-- Player does not speak a language I should understand: player is from the other faction and I'm using an Elixir of Tongues
	if not isUnderstoodLanguage then
		return Musician.Msg.EMOTE_PLAYING_MUSIC ..
			" " .. Musician.Utils.Highlight(Musician.Msg.EMOTE_PLAYER_OTHER_FACTION, 'FF0000')
	end

	-- Song has not been loaded (incompatible version)
	local errorMsg = string.gsub(Musician.Msg.EMOTE_SONG_NOT_LOADED, '{player}',
		Musician.Utils.GetPlayerLink(fullPlayerName))
	return Musician.Msg.EMOTE_PLAYING_MUSIC .. " " .. Musician.Utils.Highlight(errorMsg, 'FF0000')
end

--- Mark the full promo emote as recently seen
--
function Musician.Emote.ResetFullPromoEmoteCooldown()
	fullPromoEmoteLastSeen = GetTime()
end

--- Override the next full promo emote
--
function Musician.Emote.OverrideNextFullPromoEmote()
	overrideNextFullPromoEmote = true
end

--- Send the "Player is playing music" emote with promo message
--
function Musician.Emote.SendPromoEmote()
	if Musician_Settings.enableEmote then
		SendChatMessage(Musician.Emote.GetPromoEmote(), "EMOTE")
		overrideNextFullPromoEmote = false

		-- Show a hint to the user that an emote is also being sent by default
		if not Musician_Settings.emoteHintShown then
			Musician_Settings.emoteHintShown = true
			local emoteHint = Musician.Msg.OPTIONS_EMOTE_HINT
			local emoteHintLinkText = emoteHint:match("%[(.+)%]")
			local emoteHintLink = Musician.Utils.Highlight(Musician.Utils.GetLink("musician", emoteHintLinkText, "options"),
				'00BBBB')
			emoteHintLink = Musician.Utils.Highlight('[', 'BBBBBB') .. emoteHintLink .. Musician.Utils.Highlight(']', 'BBBBBB')
			emoteHint = string.gsub(emoteHint, '%[' .. emoteHintLinkText .. '%]', emoteHintLink)
			DEFAULT_CHAT_FRAME:AddMessage(emoteHint,
				ORANGE_FONT_COLOR.r * .75, ORANGE_FONT_COLOR.g * .75, ORANGE_FONT_COLOR.b * .75)
		end
	end
end
