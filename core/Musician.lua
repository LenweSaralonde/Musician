Musician = LibStub("AceAddon-3.0"):NewAddon("Musician")

function Musician:OnInitialize()
	Musician.Utils.Print(string.gsub(Musician.Msg.STARTUP, "{version}", Musician.Utils.Highlight(GetAddOnMetadata("Musician", "Version"))))

	-- Init settings
	local defaultSettings = {
		minimapPosition = 154,
		mutedPlayers = {}
	}
	if Musician_Settings ~= nil then
		local k, v
		for k,v in pairs(Musician_Settings) do defaultSettings[k] = v end
	end
	Musician_Settings = defaultSettings

	Musician.songs = {}
	Musician.sourceSong = nil
	Musician.songIsPlaying = false
	Musician.globalMute = false

	Musician.Comm.Init()
	Musician.Registry.Init()
	Musician.SetupHooks()

	C_Timer.NewTicker(0.5, Musician.Utils.MuteGameMusic)

	MusicianFrame.Init()
	MusicianButton.Init()

	Musician.Comm:RegisterMessage(Musician.Events.SongStop, Musician.OnSongStopped)

	-- /musician command
	SlashCmdList["MUSICIAN"] = function(cmd)

		cmd = strlower(strtrim(cmd))

		-- Stop all music currently playing
		if cmd == "stop" or cmd == "panic" then

			if Musician.sourceSong and Musician.sourceSong.playing then
				Musician.sourceSong:Stop()
			end

			local song, player
			for player, song in pairs(Musician.songs) do
				if song.playing then
					song.playing:Stop()
					Musician.songs[player].playing = nil
				end
			end

			-- Show main window
		elseif cmd == "show" or cmd == "" then
			MusicianFrame:Show()
			MusicianFrameSource:SetFocus()
		end
	end

	SLASH_MUSICIAN1 = "/musician"
	SLASH_MUSICIAN2 = "/music"
	SLASH_MUSICIAN3 = "/mus"

	-- /stopmusic command
	SlashCmdList["STOPMUSIC"] = function()
		SlashCmdList["MUSICIAN"]("stop")
	end

	SLASH_STOPMUSIC1 = "/stopmusic"
	SLASH_STOPMUSIC2 = "/stopmus"
	SLASH_STOPMUSIC3 = "/musicstop"
	SLASH_STOPMUSIC4 = "/musstop"
end

--- Play a song loaded by a player
-- @param playerName (string)
function Musician.PlayLoadedSong(playerName)
	if Musician.songs[playerName] ~= nil and Musician.songs[playerName].received ~= nil then
		Musician.StopLoadedSong(playerName)
		Musician.songs[playerName].playing = Musician.songs[playerName].received
		Musician.songs[playerName].received = nil
		Musician.Utils.MuteGameMusic()
		Musician.songs[playerName].playing:Play()
	end
end

--- Stop a song loaded by a player
-- @param playerName (string)
function Musician.StopLoadedSong(playerName)
	if Musician.songs[playerName].playing then
		Musician.songs[playerName].playing:Stop()
	end
end

--- Handle stopped song
-- @param playerName (string)
function Musician.OnSongStopped(event, song)
	local playerName = song.player

	if playerName ~= nil and Musician.songs[playerName] ~= nil and Musician.songs[playerName].playing ~= nil then

		-- Stop broadcasting my position if the song is initiated by myself
		if playerName == Musician.Utils.NormalizePlayerName(UnitName("player")) then
			Musician.Comm.StopPositionUpdate()
			Musician.songIsPlaying = false
		end

		Musician.songs[playerName].playing = nil
		Musician.Utils.MuteGameMusic()
	end

	Musician.Comm:SendMessage(Musician.Events.RefreshFrame)
end

--- Mute or unmute a player
-- @param playerName (string)
-- @param isMuted (boolean)
function Musician.MutePlayer(playerName, isMuted)
	if Musician.PlayerIsMuted(playerName) == isMuted then
		return
	end

	local icon, msg
	if isMuted then
		Musician_Settings.mutedPlayers[playerName] = true
		icon = Musician.Icons.PlayerMuted
		msg = Musician.Msg.PLAYER_IS_MUTED
	else
		Musician_Settings.mutedPlayers[playerName] = nil
		icon = Musician.Icons.PlayerUnmuted
		msg = Musician.Msg.PLAYER_IS_UNMUTED
	end

	msg = msg.gsub(msg, "{player}", Musician.Utils.Highlight(Musician.Utils.GetPlayerLink(playerName)))
	msg = msg.gsub(msg, "{icon}", Musician.Utils.GetChatIcon(icon))
	Musician.Utils.Print(msg)
end

--- Returns true if the player is muted
-- @param playerName (string)
-- @return (boolean)
function Musician.PlayerIsMuted(playerName)
	return Musician_Settings.mutedPlayers[playerName] == true
end

--- Setup hooks
--
function Musician.SetupHooks()

	-- Hyperlinks
	--

	MusicianFrame.HookedChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow
	ChatFrame_OnHyperlinkShow = function(chatFrame, link, text, button)
		local args = { strsplit(':', link) }
		if args[1] == "musician" then
			-- Stop current song for player
			if args[2] == "stop" then
				PlaySound(80)
				Musician.StopLoadedSong(args[3])
				-- Mute player
			elseif args[2] == "mute" then
				PlaySound(80)
				Musician.MutePlayer(args[3], true)
				-- Unmute player
			elseif args[2] == "unmute" then
				PlaySound(80)
				Musician.MutePlayer(args[3], false)
			end
		else
			return MusicianFrame.HookedChatFrame_OnHyperlinkShow(chatFrame, link, text, button)
		end
	end

	-- Player dropdown menus
	--

	UnitPopupButtons["MUSICIAN_SUBSECTION_TITLE_MUTED"] = { text = Musician.Msg.PLAYER_MENU_TITLE .. " " .. Musician.Utils.GetChatIcon(Musician.Icons.PlayerMuted), dist = 0, isTitle = true, isUninteractable = true, isSubsection = true, isSubsectionTitle = true, isSubsectionSeparator = true }
	UnitPopupButtons["MUSICIAN_SUBSECTION_TITLE_UNMUTED"] = { text = Musician.Msg.PLAYER_MENU_TITLE .. " " .. Musician.Utils.GetChatIcon(Musician.Icons.PlayerUnmuted), dist = 0, isTitle = true, isUninteractable = true, isSubsection = true, isSubsectionTitle = true, isSubsectionSeparator = true }
	UnitPopupButtons["MUSICIAN_STOP"] = { text = Musician.Msg.PLAYER_MENU_STOP_CURRENT_SONG, dist = 0, space = 1, isCloseCommand = true }
	UnitPopupButtons["MUSICIAN_MUTE"] = { text = Musician.Msg.PLAYER_MENU_MUTE, dist = 0, space = 1, isCloseCommand = true }
	UnitPopupButtons["MUSICIAN_UNMUTE"] = { text = Musician.Msg.PLAYER_MENU_UNMUTE, dist = 0, space = 1, isCloseCommand = true }

	local items = {"MUSICIAN_SUBSECTION_TITLE_MUTED", "MUSICIAN_SUBSECTION_TITLE_UNMUTED", "MUSICIAN_MUTE", "MUSICIAN_UNMUTE", "MUSICIAN_STOP"}
	local menus = {"PARTY", "PLAYER", "RAID_PLAYER", "FRIEND", "FRIEND_OFFLINE", "TARGET"}
	local insertBefore = "OTHER_SUBSECTION_TITLE"

	local item, menu
	for _, menu in pairs(menus) do
		local newItems = {}
		local oldItem
		for _, oldItem in pairs(UnitPopupMenus[menu]) do
			if oldItem == insertBefore then
				for _, item in pairs(items) do
					table.insert(newItems, item)
				end
			end
			table.insert(newItems, oldItem)
		end
		UnitPopupMenus[menu] = newItems
	end

	-- Show or hide player dropdown menu options
	--

	MusicianFrame.HookedUnitPopup_HideButtons = UnitPopup_HideButtons
	UnitPopup_HideButtons = function()
		MusicianFrame.HookedUnitPopup_HideButtons()
		local dropdownMenu = UIDROPDOWNMENU_INIT_MENU;
		local isPlayer = dropdownMenu.unit and UnitIsPlayer(dropdownMenu.unit) or dropdownMenu.chatTarget
		local isMyself = false
		local isMuted = false
		local isPlaying = false
		local isRegistered = false
		local player

		if isPlayer then
			if dropdownMenu.chatTarget then
				player = Musician.Utils.NormalizePlayerName(dropdownMenu.chatTarget)
			else
				if dropdownMenu.server then
					player = dropdownMenu.name .. '-' .. dropdownMenu.server
				else
					player = Musician.Utils.NormalizePlayerName(dropdownMenu.name)
				end
			end

			isMyself = Musician.Utils.PlayerIsMyself(player)
			isMuted = Musician.PlayerIsMuted(player)
			isPlaying = Musician.songs[player] ~= nil and Musician.songs[player].playing ~= nil
			isRegistered = Musician.Registry.players[player] ~= nil
		end

		local index, value
		for index, value in ipairs(UnitPopupMenus[UIDROPDOWNMENU_MENU_VALUE] or UnitPopupMenus[dropdownMenu.which]) do
			if value == "MUSICIAN_SUBSECTION_TITLE_MUTED" then
				if not(isPlayer) or not(isRegistered) or isMyself or not(isMuted) then
					UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0
				end
			elseif value == "MUSICIAN_SUBSECTION_TITLE_UNMUTED" then
				if not(isPlayer) or not(isRegistered) or isMyself or isMuted then
					UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0
				end
			elseif value == "MUSICIAN_MUTE" then
				if not(isPlayer) or not(isRegistered) or isMyself or isMuted then
					UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0
				end
			elseif value == "MUSICIAN_UNMUTE" then
				if not(isPlayer) or not(isRegistered) or isMyself or not(isMuted) then
					UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0
				end
			elseif value == "MUSICIAN_STOP" then
				if not(isPlayer) or not(isRegistered) or isMyself or not(isPlaying) or isMuted then
					UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0
				end
			end
		end
	end

	-- Handle actions in player dropdown menus
	--

	MusicianFrame.HookedUnitPopup_OnClick = UnitPopup_OnClick
	UnitPopup_OnClick = function(self)
		local dropdownMenu = UIDROPDOWNMENU_INIT_MENU;
		local button = self.value
		local isPlayer = dropdownMenu.unit and UnitIsPlayer(dropdownMenu.unit) or dropdownMenu.chatTarget
		local player

		if isPlayer then
			if dropdownMenu.chatTarget then
				player = Musician.Utils.NormalizePlayerName(dropdownMenu.chatTarget)
			else
				if dropdownMenu.server then
					player = dropdownMenu.name .. '-' .. dropdownMenu.server
				else
					player = Musician.Utils.NormalizePlayerName(dropdownMenu.name)
				end
			end
		end

		if button == "MUSICIAN_MUTE" then
			Musician.MutePlayer(player, true)
		elseif button == "MUSICIAN_UNMUTE" then
			Musician.MutePlayer(player, false)
		elseif button == "MUSICIAN_STOP" then
			Musician.StopLoadedSong(player)
		end

		MusicianFrame.HookedUnitPopup_OnClick(self)
	end

	-- Add muted/unmuted status to player messages when playing
	-- Add stop button to "Player plays music" emote
	local messageEventFilter = function(self, event, msg, player, arg3, arg4, arg5, pflag, ...)

		local fullPlayerName = Musician.Utils.NormalizePlayerName(player)

		-- "Player is playing music."
		if (msg == Musician.Utils.GetPromoEmote() or msg == Musician.Msg.EMOTE_PLAYING_MUSIC) and event == "CHAT_MSG_EMOTE" then

			-- Music is loaded and actually playing
			if Musician.songs[fullPlayerName] ~= nil and Musician.songs[fullPlayerName].playing ~= nil then

				-- Remove the "promo" part of the emote and mark as already notified
				Musician.songs[fullPlayerName].playing.notified = true
				msg = Musician.Msg.EMOTE_PLAYING_MUSIC

				-- Add action link if playing music (and not current player)
				if not(Musician.Utils.PlayerIsMyself(fullPlayerName)) then
					-- Stop music
					if not(Musician.PlayerIsMuted(fullPlayerName)) then
						local stopAction = Musician.Utils.Highlight(Musician.Utils.GetLink("musician", Musician.Msg.STOP, "stop", fullPlayerName), 'FF0000')
						msg = msg .. " " .. Musician.Utils.Highlight('[') .. stopAction .. Musician.Utils.Highlight(']')
					-- Unmute player
					else
						local unmuteAction = Musician.Utils.Highlight(Musician.Utils.GetLink("musician", Musician.Msg.UNMUTE, "unmute", fullPlayerName), '00FF00')
						msg = msg .. " " .. Musician.Utils.Highlight('[') .. unmuteAction .. Musician.Utils.Highlight(']')
					end
				end

			-- Music is not loaded
			else
				-- Player is not in the registry (other server)
				if Musician.Registry.players[fullPlayerName] == nil then
					msg = Musician.Msg.EMOTE_PLAYING_MUSIC .. " " .. Musician.Utils.Highlight(Musician.Msg.EMOTE_PLAYER_OTHER_REALM, 'FF0000')
				-- Song has not been loaded
				else
					msg = Musician.Msg.EMOTE_PLAYING_MUSIC .. " " .. Musician.Utils.Highlight(Musician.Msg.EMOTE_SONG_NOT_LOADED, 'FF0000')
				end
			end
		end

		-- Add muted/unmuted flag if currently playing music
		if Musician.songs[fullPlayerName] ~= nil and Musician.songs[fullPlayerName].playing ~= nil then
			if pflag and _G["CHAT_FLAG_" .. pflag] then
				if Musician.PlayerIsMuted(fullPlayerName) then
					_G["CHAT_FLAG_" .. pflag .. "_MUSICIAN_MUTED"] = _G["CHAT_FLAG_" .. pflag] .. CHAT_FLAG_MUSICIAN_MUTED
					pflag = pflag .. "_MUSICIAN_MUTED"
				else
					_G["CHAT_FLAG_" .. pflag .. "_MUSICIAN_UNMUTED"] = _G["CHAT_FLAG_" .. pflag] .. CHAT_FLAG_MUSICIAN_UNMUTED
					pflag = pflag .. "_MUSICIAN_UNMUTED"
				end
			else
				if Musician.PlayerIsMuted(fullPlayerName) then
					pflag = "MUSICIAN_MUTED"
				else
					pflag = "MUSICIAN_UNMUTED"
				end
			end
		end

		return false, msg, player, arg3, arg4, arg5, pflag, ...
	end

	CHAT_FLAG_MUSICIAN_MUTED = Musician.Utils.GetChatIcon(Musician.Icons.PlayerMuted)
	CHAT_FLAG_MUSICIAN_UNMUTED = Musician.Utils.GetChatIcon(Musician.Icons.PlayerUnmuted)

	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", messageEventFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", messageEventFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", messageEventFilter)
end


