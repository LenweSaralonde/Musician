--- Main module
-- @module Musician

Musician = LibStub("AceAddon-3.0"):NewAddon("Musician", "AceEvent-3.0")

local MODULE_NAME = "Main"
Musician.modules = { MODULE_NAME } -- All modules

local ChatFrame_AddMessageEventFilter = ChatFrameUtil and ChatFrameUtil.AddMessageEventFilter or ChatFrame_AddMessageEventFilter

local tipsAndTricks = {}

--- OnInitialize
--
function Musician:OnInitialize()
	-- Init settings
	local defaultSettings = {
		nextSongId = 0,
		enableEmote = true,
		enableEmotePromo = true,
		emoteHintShown = false,
		enableTipsAndTricks = true,
		muteGameMusic = true,
		muteInstrumentToys = true,
		debug = {},
		mutedPlayers = {},
		audioChannels = {
			SFX = true,
			Master = true,
			Dialog = true,
		},
		autoAdjustAudioSettings = true,
		enableQuickPreloading = true,
	}
	Musician_Settings = Mixin(defaultSettings, Musician_Settings or {})

	-- Remove obsolete settings
	Musician_Settings.minimapPosition = nil
	Musician_Settings.minimap = nil

	-- Fix audio settings
	Musician.Utils.AdjustAudioSettings()

	-- Init character settings
	local defaultCharacterSettings = {
		minimap = {
			minimapPos = LE_EXPANSION_LEVEL_CURRENT == 0 and 177 or -- Classic Era
				LE_EXPANSION_LEVEL_CURRENT == 1 and 197 or -- BC
				LE_EXPANSION_LEVEL_CURRENT == 2 and 149 or -- WotLK
				LE_EXPANSION_LEVEL_CURRENT == 3 and 149 or -- Cata
				LE_EXPANSION_LEVEL_CURRENT == 4 and 155 or -- MoP
				150.5,                                     -- Retail
			hide = false,
		},
		addonCompartment = {
			hide = false,
		},
	}
	Musician_CharacterSettings = Mixin(defaultCharacterSettings, Musician_CharacterSettings or {})

	-- Remove obsolete character settings
	Musician_CharacterSettings.framePosition = nil
	Musician_CharacterSettings.addOnMenu = nil

	-- Init bindings names
	_G.BINDING_CATEGORY_MUSICIAN = Musician.Msg.ABOUT_TITLE
	_G.BINDING_NAME_MUSICIANTOGGLE = Musician.Msg.COMMAND_SHOW
	_G.BINDING_NAME_MUSICIANPLAY = Musician.Msg.COMMAND_PLAY
	_G.BINDING_NAME_MUSICIANKEYBOARD = Musician.Msg.COMMAND_LIVE_KEYBOARD

	Musician.songs = {}
	Musician.sourceSong = nil

	Musician.Comm.Init()
	Musician.Registry.Init()
	Musician.SongLinks.Init()
	Musician.SetupHooks()

	Musician.Frame.Init()
	MusicianButton.Init()
	Musician.SongLinkImportFrame.Init()
	Musician.TrackEditor.Init()
	Musician.KeyboardUtils.Init()
	Musician.KeyboardConfig.Init()
	Musician.Live.Init()
	Musician.Keyboard.Init()
	Musician.Options.Init()
	Musician.About.Init()

	Musician:RegisterMessage(Musician.Events.SongPlay, Musician.OnSongPlayed)
	Musician:RegisterMessage(Musician.Events.SongImportSuccessful, Musician.OnSourceImportSuccessful)
	Musician:RegisterMessage(Musician.Events.SongImportFailed, Musician.OnSourceImportFailed)

	-- Automatically mute game music
	C_Timer.NewTicker(0.5, function() Musician.Utils.MuteGameMusic() end)
	local muteGameMusic = function()
		C_Timer.After(1, function()
			Musician.Utils.MuteGameMusic(true)
		end)
	end
	Musician:RegisterEvent("PLAYER_ENTERING_WORLD", muteGameMusic)
	hooksecurefunc(C_CVar, 'SetCVar', function(cvar)
		if cvar == 'Sound_EnableMusic' then
			muteGameMusic()
		end
	end)

	-- @var frame (Frame)
	Musician.playerFrame = CreateFrame("Frame")
	Musician.playerFrame:SetFrameStrata("HIGH")
	Musician.playerFrame:EnableMouse(false)
	Musician.playerFrame:SetMovable(false)

	Musician.playerFrame:SetScript("OnUpdate", Musician.OnUpdate)

	-- /musician command
	SlashCmdList["MUSICIAN"] = Musician.RunCommandLine

	SLASH_MUSICIAN1 = "/musician"
	SLASH_MUSICIAN2 = "/music"
	SLASH_MUSICIAN3 = "/mus"
end

--- OnEnable
--
function Musician:OnEnable()
	-- Init localized strings
	Musician.Msg = Musician.Utils.DeepMerge(Mixin({}, Musician.Locale.en), Musician.Msg)

	-- Init audio samples
	Musician.Sampler.Init()
	Musician.Preloader.Init()

	-- Show startup message
	Musician.Utils.Print(string.gsub(Musician.Msg.STARTUP, "{version}",
		Musician.Utils.Highlight(Musician.Utils.GetVersionText())))
end

--- Add a module
-- @param moduleName (string)
function Musician.AddModule(moduleName)
	table.insert(Musician.modules, moduleName)
end

--- Initialize a locale and returns the initialized message table
-- @param languageCode (string) Short language code (ie 'en')
-- @param languageName (string) Locale name (ie "English")
-- @param localeCode (string) Long locale code (ie 'enUS')
-- @param[opt] ... (string) Additional locale codes
-- @return msg (table) Initialized message table
function Musician.InitLocale(languageCode, languageName, localeCode, ...)
	local localeCodes = { localeCode, ... }

	-- Set English (en) as base locale
	local baseLocale = languageCode == 'en' and Musician.LocaleBase or Musician.Locale.en

	-- Init table
	local msg = Musician.Utils.DeepCopy(baseLocale)
	Musician.Locale[languageCode] = msg
	msg.LOCALE_NAME = languageName
	msg.LOCALE_CODES = localeCodes

	-- Set English (en) as the current language by default
	if languageCode == 'en' then
		Musician.Msg = msg
	else
		-- Set localized messages
		for _, locale in pairs(localeCodes) do
			if GetLocale() == locale then
				Musician.Msg = msg
				break
			end
		end
	end

	return msg
end

--- Show the song editor
--
function Musician.ShowTrackEditor()
	if Musician.sourceSong then
		MusicianTrackEditor:Show()
	end
end

--- Get command definitions
-- @return commands (table)
function Musician.GetCommands()
	local commands = {}

	-- Show main window

	table.insert(commands, {
		command = { "", "show", "import" },
		text = Musician.Msg.COMMAND_SHOW,
		func = function()
			MusicianFrame:Show()
		end
	})

	-- Play/stop song

	table.insert(commands, {
		command = { "play", "tplay", "toggleplay" },
		text = Musician.Msg.COMMAND_PLAY,
		func = Musician.Comm.TogglePlaySong
	})

	-- Stop playing song

	table.insert(commands, {
		command = { "stop" },
		text = Musician.Msg.COMMAND_STOP,
		func = Musician.Comm.StopSong
	})

	-- Preview/stop previewing song

	table.insert(commands, {
		command = {
			"preview", "previewplay", "playpreview",
			"tpreview", "tpreviewplay", "tplaypreview", "togglepreviewplay", "toggleplaypreview",
			"test", "testplay", "playtest"
		},
		text = Musician.Msg.COMMAND_PREVIEW_PLAY,
		func = function()
			if Musician.sourceSong then
				if Musician.sourceSong:IsPlaying() then
					Musician.sourceSong:Stop()
				else
					Musician.sourceSong:Play()
				end
			end
		end
	})

	-- Stop previewing song

	table.insert(commands, {
		command = {
			"previewstop", "stoppreview",
			"teststop", "stoptest"
		},
		text = Musician.Msg.COMMAND_PREVIEW_STOP,
		func = function()
			if Musician.sourceSong and Musician.sourceSong:IsPlaying() then
				Musician.sourceSong:Stop()
			end
		end
	})

	-- Mute all music

	table.insert(commands, {
		command = {
			"mute",
		},
		text = Musician.Msg.COMMAND_MUTE,
		func = function()
			Musician.Sampler.SetMuted(true)
		end
	})

	-- Unmute music

	table.insert(commands, {
		command = {
			"unmute",
		},
		text = Musician.Msg.COMMAND_UNMUTE,
		func = function()
			Musician.Sampler.SetMuted(false)
		end
	})

	-- Open track editor

	table.insert(commands, {
		command = { "edit", "tracks" },
		text = Musician.Msg.COMMAND_SONG_EDITOR,
		func = Musician.ShowTrackEditor
	})

	-- Show live keyboard

	table.insert(commands, {
		command = { "live", "keyboard" },
		text = Musician.Msg.COMMAND_LIVE_KEYBOARD,
		func = function()
			MusicianFrameSource:ClearFocus()
			Musician.Keyboard.Show()
		end
	})

	-- Configure keyboard

	table.insert(commands, {
		command = {
			"setupkeyboard", "keyboardsetup",
			"configkeyboard", "keyboardconfig"
		},
		text = Musician.Msg.COMMAND_CONFIGURE_KEYBOARD,
		func = function()
			MusicianFrameSource:ClearFocus()
			MusicianKeyboardConfig:Show()
		end
	})

	-- Live demo mode

	table.insert(commands, {
		command = {
			"livedemo", "demolive",
			"keyboarddemo", "demokeyboard",
		},
		params = Musician.Msg.COMMAND_LIVE_DEMO_PARAMS,
		text = Musician.Msg.COMMAND_LIVE_DEMO,
		unpackArgs = true,
		func = function(param1, param2)
			local upperTrackIndex = tonumber(param1)
			if upperTrackIndex and upperTrackIndex <= 0 then
				upperTrackIndex = nil
			end
			local lowerTrackIndex = tonumber(param2)
			if lowerTrackIndex and lowerTrackIndex <= 0 then
				lowerTrackIndex = nil
			end
			Musician.Keyboard.EnableDemoMode(upperTrackIndex, lowerTrackIndex)
		end
	})

	-- Display help

	table.insert(commands, {
		command = { "help" },
		text = Musician.Msg.COMMAND_HELP,
		func = Musician.Help
	})

	return commands
end

--- Display command-line help
--
function Musician.Help()
	Musician.Utils.Print(Musician.Msg.COMMAND_LIST_TITLE)

	for _, row in pairs(Musician.GetCommands()) do
		local params = ""
		if row.params then
			params = Musician.Utils.FormatText(row.params) .. "\n"
		end

		local cmd = ""
		if row.command[1] ~= "" then
			cmd = row.command[1] .. " "
		end

		Musician.Utils.Print(
			Musician.Utils.Highlight("/mus " .. cmd) ..
			params ..
			Musician.Utils.FormatText(row.text)
		)
	end
end

--- Run command line
-- @param commandLine (string)
function Musician.RunCommandLine(commandLine)
	local normalizedCommandLine = string.gsub(commandLine, "[%s]+", " ")
	local args = { string.split(" ", strtrim(normalizedCommandLine)) }
	local cmd = strtrim(strlower(table.remove(args, 1)))

	local commands = Musician.GetCommands()

	-- Add hidden debug command
	table.insert(commands, {
		command = {
			"debug"
		},
		unpackArgs = true,
		func = function(arg1, arg2)
			local module, state
			if arg2 == nil then
				state = arg1
			else
				module, state = arg1, arg2
			end

			if state == "on" then
				state = true
			elseif state == "off" then
				state = false
			else
				state = nil
			end

			if module ~= nil then
				if state then
					Musician_Settings.debug[module] = true
					Musician.Utils.Debug(nil, "Debug mode enabled for module " .. module .. ".")
				else
					Musician_Settings.debug[module] = nil
					Musician.Utils.Debug(nil, "Debug mode disabled for module " .. module .. ".")
				end
			else
				if state then
					for _, moduleName in ipairs(Musician.modules) do
						Musician_Settings.debug[moduleName] = true
					end
					Musician.Utils.Debug(nil, "Debug mode enabled for all modules.")
				else
					Musician_Settings.debug = {}
					Musician.Utils.Debug(nil, "Debug mode disabled for all modules.")
				end
			end
		end
	})

	for _, row in pairs(commands) do
		for _, command in pairs(row.command) do
			if cmd == command then
				if row.unpackArgs then
					row.func(unpack(args))
				else
					row.func(table.concat(args, " "))
				end
				return
			end
		end
	end

	local errorMessage = Musician.Msg.ERR_COMMAND_UNKNOWN
	errorMessage = string.gsub(errorMessage, "{command}", Musician.Utils.Highlight(cmd))
	errorMessage = string.gsub(errorMessage, "{help}", Musician.Utils.Highlight("/mus help"))
	Musician.Utils.PrintError(errorMessage)
end

--- Stop a song playing by a player
-- @param playerName (string)
-- @param remove (boolean)
function Musician.StopPlayerSong(playerName, remove)
	if Musician.songs[playerName] then
		Musician.songs[playerName]:Stop()
		if remove then
			Musician.songs[playerName]:Wipe()
			Musician.songs[playerName] = nil
		end
	end
end

--- Handle playing song
-- @param event (table)
-- @param song (Musician.Song)
function Musician.OnSongPlayed(event, song)
	-- Send promo emote if my song is playing
	if song.player and Musician.songs[song.player] ~= nil and Musician.Utils.PlayerIsMyself(song.player) then
		Musician.Utils.SendPromoEmote()
	end
end

--- Import song from encoded string
-- @param str (string)
function Musician.ImportSource(str)
	-- Remove previously importing song
	if Musician.importingSong ~= nil then
		Musician.importingSong:CancelImport()
		Musician.importingSong:Wipe()
		Musician.importingSong = nil
	end

	Musician.importingSong = Musician.Song.create()
	Musician.importingSong:ImportFromBase64(str, true)
end

--- Handle successful source import
-- @param event (string)
-- @param song (Musician.Song)
function Musician.OnSourceImportSuccessful(event, song)
	if song ~= Musician.importingSong then return end

	-- Stop and wipe previous source song
	if Musician.sourceSong and Musician.sourceSong:IsPlaying() then
		Musician.sourceSong:Stop()
	end
	local previousSourceSongToWipe = Musician.sourceSong

	Musician.sourceSong = song

	Musician.importingSong = nil

	Musician:SendMessage(Musician.Events.SourceSongLoaded, song)

	if previousSourceSongToWipe then
		previousSourceSongToWipe:Wipe()
	end
end

--- Handle failed source import
--
function Musician.OnSourceImportFailed()
	if Musician.importingSong then
		Musician.importingSong:Wipe()
		Musician.importingSong = nil
	end
end

--- Perform all on-frame actions
-- @param frame (Frame)
-- @param elapsed (number)
function Musician.OnUpdate(frame, elapsed)
	Musician.Song.OnUpdate(elapsed)
	Musician.Preloader.OnUpdate(elapsed)
	Musician.Worker.OnUpdate(elapsed)
	Musician.Sampler.OnUpdate(elapsed)

	Musician:SendMessage(Musician.Events.Frame, elapsed)
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
		icon = Musician.IconImages.NoteDisabled
		msg = Musician.Msg.PLAYER_IS_MUTED
	else
		Musician_Settings.mutedPlayers[playerName] = nil
		icon = Musician.IconImages.Note
		msg = Musician.Msg.PLAYER_IS_UNMUTED
	end

	msg = msg.gsub(msg, "{player}", Musician.Utils.Highlight(Musician.Utils.GetPlayerLink(playerName)))
	msg = msg.gsub(msg, "{icon}", Musician.Utils.GetChatIcon(icon))
	Musician.Utils.Print(msg)
end

--- Return true if the player is muted
-- @param playerName (string)
-- @return isMuted (boolean)
function Musician.PlayerIsMuted(playerName)
	return Musician_Settings.mutedPlayers[playerName] == true
end

--- Hyperlink mouse enter handler
--
function Musician.OnHyperlinkEnter(...)
	Musician.UrlHyperlinkSelector.OnHyperlinkEnter(...)
end

--- Hyperlink mouse leave handler
--
function Musician.OnHyperlinkLeave(...)
	Musician.UrlHyperlinkSelector.OnHyperlinkLeave(...)
end

--- Hyperlink click handler
-- @param self (Frame)
-- @param link (string)
-- @param text (string)
-- @param button (string)
function Musician.OnHyperlinkClick(self, link, text, button)
	local args = { strsplit(':', link) }
	if not IsModifiedClick("CHATLINK") then
		if args[2] == "stop" then
			-- Stop current song for player
			PlaySound(80)
			Musician.StopPlayerSong(args[3])
		elseif args[2] == "mute" then
			-- Mute player
			PlaySound(80)
			Musician.MutePlayer(args[3], true)
		elseif args[2] == "unmute" then
			-- Unmute player
			PlaySound(80)
			Musician.MutePlayer(args[3], false)
		elseif args[2] == "options" then
			-- Open options panel
			Musician.Options.Show()
		elseif args[2] == "seek" and Musician.sourceSong ~= nil then
			-- Seek source song
			Musician.sourceSong:Seek(args[3])
		elseif args[2] == "url" then
			-- Open URL
			Musician.UrlHyperlinkSelector.OnHyperlinkClick(self, link, text, button)
		end
	end
end

--- Enable hyperlinks support on frame
-- @param self (Frame)
function Musician.EnableHyperlinks(self)
	self:SetHyperlinksEnabled(true)
	self:HookScript("OnHyperlinkClick", Musician.OnHyperlinkClick)
	self:HookScript("OnHyperlinkEnter", Musician.OnHyperlinkEnter)
	self:HookScript("OnHyperlinkLeave", Musician.OnHyperlinkLeave)
end

--- Return menu entries for player menu
-- @param unit (string)
-- @param chatTarget (string)
-- @param name (string)
-- @param server (string)
-- @return items (table)
function Musician.GetPlayerMenuItems(unit, chatTarget, name, server)
	local isPlayer = unit and UnitIsPlayer(unit) or chatTarget
	local isMyself = false
	local isMuted = false
	local isPlaying = false
	local isRegistered = false
	local player

	if isPlayer then
		if chatTarget then
			player = Musician.Utils.NormalizePlayerName(chatTarget)
		else
			if server then
				player = name .. '-' .. server
			else
				player = Musician.Utils.NormalizePlayerName(name)
			end
		end

		isMyself = Musician.Utils.PlayerIsMyself(player)
		isMuted = Musician.PlayerIsMuted(player)
		isPlaying = Musician.songs[player] ~= nil and Musician.songs[player]:IsPlaying()
		isRegistered = Musician.Registry.PlayerIsRegistered(player)
	end

	if not isPlayer or not isRegistered or isMyself then
		return {}
	end

	local items = {}
	table.insert(items, {
		text = Musician.Msg.PLAYER_MENU_TITLE ..
			" " .. Musician.Utils.GetChatIcon(isMuted and Musician.IconImages.NoteDisabled or Musician.IconImages.Note),
		isTitle = true,
	})
	if isPlaying and not isMuted then
		table.insert(items, {
			text = Musician.Msg.PLAYER_MENU_STOP_CURRENT_SONG,
			func = function() Musician.StopPlayerSong(player) end
		})
	end
	table.insert(items, {
		text = isMuted and Musician.Msg.PLAYER_MENU_UNMUTE or Musician.Msg.PLAYER_MENU_MUTE,
		func = function() Musician.MutePlayer(player, not isMuted) end
	})
	return items
end

--- Setup hooks
--
function Musician.SetupHooks()
	-- Hyperlinks
	--

	-- Set global hyperlink handler
	LinkUtil.RegisterLinkHandler("musician", function(link, text, linkData, contextData)
		Musician.OnHyperlinkClick(contextData.frame, link, text, contextData.button)
	end)

	-- Set hyperlink enter and leave global handlers to the chat frames (required by URL hyperlinks posted in the chat)
	local function chatFrameOnLoad(self)
		self:HookScript("OnHyperlinkEnter", Musician.OnHyperlinkEnter)
		self:HookScript("OnHyperlinkLeave", Musician.OnHyperlinkLeave)
	end
	if ChatFrameMixin and ChatFrameMixin.OnLoad then
		hooksecurefunc(ChatFrameMixin, "OnLoad", chatFrameOnLoad)
	else
		hooksecurefunc("ChatFrame_OnLoad", chatFrameOnLoad)
	end
	local chatFrameIndex = 1
	while _G['ChatFrame' .. chatFrameIndex] ~= nil do
		chatFrameOnLoad(_G['ChatFrame' .. chatFrameIndex])
		chatFrameIndex = chatFrameIndex + 1
	end

	-- Player dropdown menus
	--

	if UnitPopup_ShowMenu then
		-- Old school way
		hooksecurefunc("UnitPopup_ShowMenu", function(dropdownMenu, which)
			if UIDROPDOWNMENU_MENU_LEVEL ~= 1 then return end
			if
				which == "PARTY" or which == "PLAYER" or which == "RAID_PLAYER" or which == "FRIEND" or which == "FRIEND_OFFLINE" or
				which == "TARGET" then
				local items = Musician.GetPlayerMenuItems(dropdownMenu.unit, dropdownMenu.chatTarget, dropdownMenu.name,
					dropdownMenu.server)

				if #items > 0 then
					UIDropDownMenu_AddSeparator(1)
					for _, item in pairs(items) do
						local info = UIDropDownMenu_CreateInfo()
						info.text = item.text
						info.isTitle = item.isTitle
						info.func = item.func
						info.notCheckable = true
						info.value = item.value
						UIDropDownMenu_AddButton(info)
					end
				end
			end
		end)
	else
		local modifyPlayerMenu = function(_, rootDescription, contextData)
			local items = Musician.GetPlayerMenuItems(contextData.unit, contextData.chatTarget, contextData.name,
				contextData.server)

			if #items > 0 then
				rootDescription:CreateDivider()
				for _, item in pairs(items) do
					if item.isTitle then
						rootDescription:CreateTitle(item.text)
					else
						rootDescription:CreateButton(item.text, item.func)
					end
				end
			end
		end

		Menu.ModifyMenu("MENU_UNIT_PLAYER", modifyPlayerMenu)
		Menu.ModifyMenu("MENU_UNIT_FRIEND", modifyPlayerMenu)
		Menu.ModifyMenu("MENU_UNIT_PARTY", modifyPlayerMenu)
		Menu.ModifyMenu("MENU_UNIT_RAID_PLAYER", modifyPlayerMenu)
		Menu.ModifyMenu("MENU_UNIT_ENEMY_PLAYER", modifyPlayerMenu)
	end

	-- Add muted/unmuted status to player messages when playing
	--

	local HookedGetPlayerLink = GetPlayerLink
	GetPlayerLink = function(...)
		local link = HookedGetPlayerLink(...)

		local playerName = ...
		local fullPlayerName = Musician.Utils.NormalizePlayerName(playerName)

		if Musician.songs[fullPlayerName] ~= nil and Musician.songs[fullPlayerName]:IsPlaying() then
			if Musician.PlayerIsMuted(fullPlayerName) then
				link = Musician.Utils.GetChatIcon(Musician.IconImages.NoteDisabled) .. link
			else
				link = Musician.Utils.GetChatIcon(Musician.IconImages.Note) .. link
			end
		end

		return link
	end

	-- Add stop button to "Player plays music" emote
	--

	ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE",
		function(self, event, msg, player, languageName, channelName, playerName2, pflag, ...)
			local fullPlayerName = Musician.Utils.NormalizePlayerName(player)

			-- "Player is playing music."
			local isPromoEmote, isFullPromoEmote = Musician.Utils.HasPromoEmote(msg)
			if isFullPromoEmote then
				Musician.Utils.ResetFullPromoEmoteCooldown()
			end

			-- Process promo emote
			if isPromoEmote then
				local isPromoEmoteSuccessful

				-- Music is loaded and actually playing
				if Musician.songs[fullPlayerName] ~= nil and Musician.songs[fullPlayerName]:IsPlaying() then
					-- Ignore emote if the player has already been notified
					if Musician.songs[fullPlayerName].notified then
						return true
					end

					-- Remove the "promo" part of the emote and mark as already notified
					Musician.songs[fullPlayerName].notified = true
					msg = Musician.Msg.EMOTE_PLAYING_MUSIC

					-- Add action link if playing music (and not current player)
					if not Musician.Utils.PlayerIsMyself(fullPlayerName) then
						-- Stop music
						if not Musician.PlayerIsMuted(fullPlayerName) then
							local stopAction = Musician.Utils.Highlight(
								Musician.Utils.GetLink("musician", Musician.Msg.STOP, "stop",
									fullPlayerName), 'FF0000')
							msg = msg ..
								" " .. Musician.Utils.Highlight('[') .. stopAction .. Musician.Utils.Highlight(']')
							-- Unmute player
						else
							local unmuteAction = Musician.Utils.Highlight(
								Musician.Utils.GetLink("musician", Musician.Msg.UNMUTE, "unmute",
									fullPlayerName), '00FF00')
							msg = msg ..
								" " .. Musician.Utils.Highlight('[') .. unmuteAction .. Musician.Utils.Highlight(']')
						end
					end

					isPromoEmoteSuccessful = true

					-- Music is not loaded
				else
					-- Player is not in the channel and not in my group: it's from another realm
					if not Musician.Utils.PlayerIsOnSameRealm(player) and not Musician.Utils.PlayerIsInGroup(player) then
						msg = Musician.Msg.EMOTE_PLAYING_MUSIC ..
							" " .. Musician.Utils.Highlight(Musician.Msg.EMOTE_PLAYER_OTHER_REALM, 'FF0000')
					else
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
							msg = Musician.Msg.EMOTE_PLAYING_MUSIC ..
								" " .. Musician.Utils.Highlight(Musician.Msg.EMOTE_PLAYER_OTHER_FACTION, 'FF0000')
						else -- Song has not been loaded (incompatible version)
							local errorMsg = string.gsub(Musician.Msg.EMOTE_SONG_NOT_LOADED, '{player}',
								Musician.Utils.GetPlayerLink(fullPlayerName))
							msg = Musician.Msg.EMOTE_PLAYING_MUSIC .. " " .. Musician.Utils.Highlight(errorMsg, 'FF0000')
						end
					end

					isPromoEmoteSuccessful = false
				end

				-- Send promo emote event
				Musician:SendMessage(Musician.Events.PromoEmote, isPromoEmoteSuccessful, msg, fullPlayerName,
					languageName,
					channelName, playerName2, pflag, ...)
			end

			return false, msg, player, languageName, channelName, playerName2, pflag, ...
		end)

	-- Add custom Sound_MaxCacheSizeInBytes option for Musician
	--

	local isSoundCacheOptionHooked = false
	if SettingsLayoutMixin and SettingsLayoutMixin.Init then
		hooksecurefunc(SettingsLayoutMixin, "Init", function(layout, layoutType)
			if layoutType == SettingsLayoutMixin.LayoutType.Vertical then
				hooksecurefunc(layout, "AddInitializer", function(_, initializer)
					if type(initializer) == "table" and type(initializer.GetSetting) == "function" then
						local setting = initializer:GetSetting()
						if type(setting) == "table" and type(setting.GetVariable) == "function" and
							setting:GetVariable() == "Sound_MaxCacheSizeInBytes" and not isSoundCacheOptionHooked then
							local hookedInitializerGetOptions = initializer.GetOptions
							isSoundCacheOptionHooked = true
							initializer.GetOptions = function(...)
								local options = hookedInitializerGetOptions(...)()
								local cacheSize = Musician.Utils.GetSoundCacheSize()
								local label = Musician.Msg.OPTIONS_AUDIO_CACHE_SIZE_FOR_MUSICIAN:format(cacheSize)
								table.insert(options, {
									label = label,
									text = label,
									value = cacheSize * 1024 * 1024, -- Value is in bytes
									controlType = 1,
								})
								return function()
									return options
								end
							end
						end
					end
				end)
			end
		end)
	end
end

--- Add a tips and tricks callback
-- @param callback (function)
-- @param priority (boolean) If true, add the tip to the top of the list
function Musician.AddTipsAndTricks(callback, priority)
	if priority then
		table.insert(tipsAndTricks, 1, callback)
	else
		table.insert(tipsAndTricks, callback)
	end
end

--- Show the first tips and tricks
-- @param callback (function)
function Musician.ShowTipsAndTricks()
	if not Musician_Settings.enableTipsAndTricks then return end
	if #tipsAndTricks > 0 then
		local callback = table.remove(tipsAndTricks, 1)
		callback()
	end
end
