--- Main window with song import and controls
-- @module Musician.Frame

Musician.Frame = LibStub("AceAddon-3.0"):NewAddon("Musician.Frame", "AceEvent-3.0")

local MODULE_NAME = "MusicianFrame"
Musician.AddModule(MODULE_NAME)

local sourceBuffer
local sourceBufferCharIndex

local isCommActionPending = false

--- Init
--
function Musician.Frame.Init()
	-- Register events
	Musician.Frame:RegisterMessage(Musician.Events.CommChannelUpdate, Musician.Frame.OnCommChannelUpdate)
	Musician.Frame:RegisterMessage(Musician.Events.CommSendAction, Musician.Frame.OnCommSendAction)
	Musician.Frame:RegisterMessage(Musician.Events.CommSendActionComplete, Musician.Frame.OnCommSendAction)
	Musician.Frame:RegisterMessage(Musician.Events.SongImportStart, Musician.Frame.RefreshButtons)
	Musician.Frame:RegisterMessage(Musician.Events.SongImportComplete, Musician.Frame.RefreshButtons)
	Musician.Frame:RegisterMessage(Musician.Events.SongImportProgress, Musician.Frame.RefreshLoadingProgressBar)
	Musician.Frame:RegisterMessage(Musician.Events.SongPlay, Musician.Frame.OnSongPlayOrStop)
	Musician.Frame:RegisterMessage(Musician.Events.SongStop, Musician.Frame.OnSongPlayOrStop)
	Musician.Frame:RegisterMessage(Musician.Events.SongCursor, Musician.Frame.RefreshPlayingProgressBar)
	Musician.Frame:RegisterMessage(Musician.Events.SourceSongLoaded, Musician.Frame.OnSourceSongUpdated)
	Musician.Frame:RegisterMessage(Musician.Events.SongImportFailed, Musician.Frame.OnSourceSongUpdated)
	Musician.Frame:RegisterMessage(Musician.Events.Bandwidth, Musician.Frame.RefreshBandwidthIndicator)
	Musician.Frame:RegisterMessage(Musician.Events.BandPlay, Musician.Frame.OnBandPlay)
	Musician.Frame:RegisterMessage(Musician.Events.BandStop, Musician.Frame.OnBandStop)
	Musician.Frame:RegisterMessage(Musician.Events.BandPlayReady, Musician.Frame.OnBandPlayReady)
	Musician.Frame:RegisterMessage(Musician.Events.BandReadyPlayersUpdated, Musician.Frame.UpdateBandPlayButton)
	Musician.Frame:RegisterMessage(Musician.Events.SongReceiveSuccessful, Musician.Frame.OnSongReceiveSuccessful)
	Musician.Frame:RegisterEvent("GROUP_ROSTER_UPDATE", Musician.Frame.OnRosterUpdate)
	Musician.Frame:RegisterEvent("PLAYER_DEAD", Musician.Frame.OnCommChannelUpdate)
	Musician.Frame:RegisterEvent("PLAYER_ALIVE", Musician.Frame.OnCommChannelUpdate)
	Musician.Frame:RegisterEvent("PLAYER_UNGHOST", Musician.Frame.OnCommChannelUpdate)

	-- Main frame settings
	MusicianFrame.noEscape = true
	MusicianFrame:SetClampedToScreen(true)

	-- Set default frame position
	if not MusicianFrame:IsUserPlaced() then
		MusicianFrame:ClearAllPoints()
		local defaultY = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE and 93 or 126
		MusicianFrame:SetPoint('RIGHT', UIParent, 'RIGHT', 0, defaultY)
	end

	-- Main title
	MusicianFrameTitle:SetText(Musician.Msg.PLAY_A_SONG)

	-- Song source
	MusicianFrameSource:SetMaxBytes(512)
	MusicianFrameSource:SetScript("OnTextChanged", Musician.Frame.OnSourceChanged)
	MusicianFrameSource:SetScript("OnChar", function(self, c)
		sourceBuffer[sourceBufferCharIndex] = c
		sourceBufferCharIndex = sourceBufferCharIndex + 1
	end)
	MusicianFrameSource:SetScript("OnMouseUp", function()
		MusicianFrameSource:SetFocus()
	end)
	MusicianFrameSource:SetScript("OnEditFocusGained", function()
		MusicianFrameSource:HighlightText(0)
	end)
	MusicianFrameSource:SetScript("OnEscapePressed", function()
		MusicianFrameSource:ClearFocus()
	end)
	MusicianFrameScrollFrame:SetScript("OnMouseUp", function()
		MusicianFrameSource:SetFocus()
	end)
	MusicianFrameTextBackgroundLoadingProgressBar:Hide()
	Musician.Frame.Clear()

	-- Reduce source text size in Chinese
	if Musician.Msg == Musician.Locale.zh or Musician.Msg == Musician.Locale.tw then
		local w, h = MusicianFrameSource:GetSize()
		local scale = .75
		MusicianFrameSource:SetScale(scale)
		MusicianFrameSource:SetSize(w / scale, h / scale)
	end

	-- Clear song source button
	MusicianFrameClearButton:SetText(Musician.Icons.Edit)
	MusicianFrameClearButton:SetFrameLevel(MusicianFrameSource:GetFrameLevel() + 1000)
	MusicianFrameClearButton.tooltipText = Musician.Msg.SELECT_ALL
	MusicianFrameClearButton:HookScript("OnClick", function()
		Musician.Frame.Clear(true)
	end)

	-- Preview button
	MusicianFrameTestButton:SetText(Musician.Msg.TEST_SONG)
	MusicianFrameTestButton.icon:SetText(Musician.Icons.Headphones)
	MusicianFrameTestButton:SetEnabled(false)
	MusicianFrameTestButtonProgressBar:Hide()
	MusicianFrameTestButton:HookScript("OnClick", Musician.Frame.TogglePreviewSong)

	-- Play button
	MusicianFramePlayButton:SetText(Musician.Msg.PLAY)
	MusicianFramePlayButton.icon:SetText(Musician.Icons.Speaker)
	MusicianFramePlayButtonProgressBar:Hide()
	Musician.Frame.UpdatePlayButton()
	MusicianFramePlayButton:HookScript("OnClick", Musician.Comm.TogglePlaySong)

	-- Track editor button
	MusicianFrameTrackEditorButton:Disable()
	MusicianFrameTrackEditorButton:SetText(Musician.Msg.EDIT)
	MusicianFrameTrackEditorButton.icon:SetText(Musician.Icons.Sliders2)
	MusicianFrameTrackEditorButton:HookScript("OnClick", Musician.ShowTrackEditor)

	-- Link button
	MusicianFrameLinkButton:Disable()
	MusicianFrameLinkButton:SetText(Musician.Msg.LINKS_LINK_BUTTON)
	MusicianFrameLinkButton.icon:SetText(Musician.Icons.Export)
	MusicianFrameLinkButton:HookScript("OnClick", Musician.SongLinkExportFrame.Show)

	-- Band play button
	Musician.Frame.UpdateBandPlayButton()
	MusicianFrameBandPlayButton:HookScript("OnClick", Musician.Comm.ToggleBandPlayReady)
end

--- Set focus to import field
--
function Musician.Frame.Focus()
	if not MusicianFrameSource:HasFocus() then
		MusicianFrameSource:HighlightText(0)
		MusicianFrameSource:SetFocus()
	end
end

--- Clear import field
-- @param focus (boolean)
function Musician.Frame.Clear(focus)
	sourceBuffer = {}
	sourceBufferCharIndex = 1

	MusicianFrameSource:SetText(Musician.Frame.GetDefaultText())
	MusicianFrameSource:HighlightText(0)

	if focus then
		MusicianFrameSource:SetFocus()
	end
end

--- OnSourceChanged
--
function Musician.Frame.OnSourceChanged(self, isUserInput)
	MusicianFrameSource:HighlightText(0, 0)
	MusicianFrameSource:ClearFocus()

	if isUserInput then
		Musician.Frame.ImportSource()
		Musician.Frame.Focus()
		sourceBuffer = {}
		sourceBufferCharIndex = 1
	end
end

--- Import source song
--
function Musician.Frame.ImportSource()
	local source = table.concat(sourceBuffer)
	if source == "" or source == Musician.Frame.GetDefaultText() then
		return
	end

	Musician.ImportSource(source)
end

--- Preview source song
--
function Musician.Frame.TogglePreviewSong()
	if Musician.sourceSong then
		if Musician.sourceSong:IsPlaying() then
			Musician.sourceSong:Stop()
		else
			Musician.sourceSong:Play()
		end
	end
end

--- Return default text for import text field
-- @return (string)
function Musician.Frame.GetDefaultText()
	local defaultText = string.gsub(Musician.Msg.PASTE_MUSIC_CODE, "{url}", Musician.CONVERTER_URL)
	local shortcut

	if IsMacClient() then
		local r, g, b = MusicianFrameSource:GetTextColor()
		shortcut = "cmd" .. Musician.Utils.GetChatIcon(Musician.IconImages.Cmd, r, g, b) .. "+V"
	else
		shortcut = "Ctrl+V"
	end

	defaultText = string.gsub(defaultText, "{shortcut}", shortcut)

	if Musician.sourceSong and Musician.sourceSong.name then
		local importedText = string.gsub(Musician.Msg.SONG_IMPORTED, "{title}", Musician.sourceSong.name)
		defaultText = importedText .. "\n\n" .. defaultText
	end

	return defaultText
end

--- Update Play button
-- @param isEnabled (boolean)
-- @param isPlaying (boolean)
function Musician.Frame.UpdatePlayButton()
	local isEnabled = Musician.sourceSong and Musician.Comm.CanPlay() and not isCommActionPending

	-- This may happen on trial accounts in raid mode
	if IsInGroup() and (Musician.Comm.GetGroupChatType() == nil) then
		isEnabled = false
	end

	MusicianFramePlayButton:SetEnabled(isEnabled)
end

--- OnRosterUpdate
--
function Musician.Frame.OnRosterUpdate(event)
	Musician.Frame.UpdatePlayButton()
	Musician.Frame.UpdateBandPlayButton()
end

--- OnCommChannelUpdate
-- @param event (string)
function Musician.Frame.OnCommChannelUpdate(event)
	Musician.Frame.UpdatePlayButton()
	Musician.Frame.UpdateBandPlayButton()
end

--- OnCommSendAction
-- @param event (string)
function Musician.Frame.OnCommSendAction(event)
	local isComplete = event == Musician.Events.CommSendActionComplete
	isCommActionPending = not isComplete
	Musician.Frame.UpdatePlayButton()
	Musician.Frame.UpdateBandPlayButton()
end

--- OnCommSendAction
-- @param event (string)
-- @param song (Musician.Song)
function Musician.Frame.OnSongPlayOrStop(event, song)
	local isPlaying = event == Musician.Events.SongPlay

	if song == Musician.sourceSong then
		MusicianFrameTestButton:SetText(isPlaying and Musician.Msg.STOP_TEST or Musician.Msg.TEST_SONG)
		Musician.Frame.RefreshPlayingProgressBar(event, song)
	elseif Musician.Utils.PlayerIsMyself(song.player) and Musician.songs[song.player] and not song.isLiveStreamingSong then
		MusicianFramePlayButton:SetText(isPlaying and Musician.Msg.STOP or Musician.Msg.PLAY)
		Musician.Frame.RefreshPlayingProgressBar(event, song)

		-- My song started in band playing mode: set the button LED still
		if Musician.Comm.IsBandPlayReady() and isPlaying then
			MusicianFrameBandPlayButton:SetBlinking(false)
		end
	end
end

--- OnSourceSongUpdated
--
function Musician.Frame.OnSourceSongUpdated()
	if Musician.sourceSong == nil then
		MusicianFrameTestButton:Disable()
		MusicianFrameTrackEditorButton:Disable()
		MusicianFrameLinkButton:Disable()
		MusicianTrackEditor:Hide()
	else
		MusicianFrameTestButton:Enable()
		MusicianFrameTrackEditorButton:Enable()
		MusicianFrameLinkButton:Enable()
	end
	Musician.Frame.UpdatePlayButton()
	Musician.Frame.UpdateBandPlayButton()
	Musician.Frame.Clear()
end

--- Refresh buttons
-- @param event (string)
-- @param song (Musician.Song)
function Musician.Frame.RefreshButtons(event, song)
	if song ~= Musician.importingSong then return end
	if not song.importing then
		MusicianFrameClearButton:Enable()
		MusicianFrameSource:Enable()
		Musician.Frame.SetLoadingProgressBar(nil)
		Musician.Frame.Clear()
	else
		MusicianFrameClearButton:Disable()
		MusicianFrameSource:Disable()
	end
end

--- Refresh loading progress bar
-- @param event (string)
-- @param song (Musician.Song)
-- @param progression (number)
function Musician.Frame.RefreshLoadingProgressBar(event, song, progression)
	if song ~= Musician.importingSong then return end
	Musician.Frame.SetLoadingProgressBar(progression)
end

--- Set loading progress bar position
-- @param[opt] progression (number)
function Musician.Frame.SetLoadingProgressBar(progression)
	if progression == nil then
		MusicianFrameTextBackgroundLoadingProgressBar:Hide()
	else
		MusicianFrameTextBackgroundLoadingProgressBar:Show()
		MusicianFrameTextBackgroundLoadingProgressBar:SetWidth(max(1,
			(MusicianFrameTextBackground:GetWidth() - 10) * progression))
	end
end

--- Regresh progress bar of the song
-- @param event (string)
-- @param song (Musician.Song) Can be the source song or the song currently playing
function Musician.Frame.RefreshPlayingProgressBar(event, song)
	local button

	if song == Musician.sourceSong then
		button = MusicianFrameTestButton
	elseif Musician.Utils.PlayerIsMyself(song.player) and
		Musician.songs[song.player] and
		not Musician.songs[song.player].isLiveStreamingSong
	then
		button = MusicianFramePlayButton
	else
		return
	end

	local progression = song:GetProgression()
	if progression ~= nil then
		button.progressBar:Show()
		button.progressBar:SetWidth(max(1, (button:GetWidth() - 10) * progression))
	else
		button.progressBar:Hide()
	end
end

--- Regresh bandwidth indicator
-- @param event (string)
-- @param bandwidth (number)
function Musician.Frame.RefreshBandwidthIndicator(event, bandwidth)
	local r = max(0, min(1, bandwidth * 2))
	local g = max(0, min(1, 2 - bandwidth * 2))
	local b = 0
	local a = 1

	if bandwidth == 1 then
		local t = GetTime()
		r = sin((t - floor(t)) * 720) * .33 + .67
	end

	MusicianFramePlayButtonProgressBar:SetColorTexture(r, g, b, a)
end

--- Update band play button
--
function Musician.Frame.UpdateBandPlayButton()

	-- Update button visibility

	local isVisible = IsInGroup()
	local isEnabled = Musician.sourceSong and (Musician.Comm.GetGroupChatType() ~= nil) and not isCommActionPending
	MusicianFrameBandPlayButton:SetShown(isVisible)
	MusicianFrameBandPlayButton:SetEnabled(isEnabled)

	-- Update button LED

	MusicianFrameBandPlayButton:SetChecked(Musician.Comm.IsBandPlayReady())
	MusicianFrameBandPlayButton:SetBlinking(not Musician.Comm.IsSongPlaying())

	-- Update tooltip and the number of ready players

	local players = Musician.Comm.GetReadyBandPlayers()
	local tooltipText = Musician.Msg.PLAY_IN_BAND

	if not Musician.Comm.IsBandPlayReady() then
		tooltipText = tooltipText .. "\n" .. Musician.Utils.Highlight(Musician.Msg.PLAY_IN_BAND_HINT, "00FFFF")
	end

	if #players > 0 then
		MusicianFrameBandPlayButton.count.text:SetText(#players)
		MusicianFrameBandPlayButton.count:Show()

		local playerNames = {}
		for _, playerName in ipairs(players) do
			table.insert(playerNames, "– " .. Musician.Utils.FormatPlayerName(playerName))
		end

		tooltipText = tooltipText .. "\n" .. Musician.Msg.PLAY_IN_BAND_READY_PLAYERS
		tooltipText = tooltipText .. "\n" .. strjoin("\n", unpack(playerNames))
	else
		MusicianFrameBandPlayButton.count:Hide()
	end
	MusicianFrameBandPlayButton:SetTooltipText(tooltipText)
end

--- OnBandPlayReady
--
function Musician.Frame.OnBandPlayReady(event, player, songCrc32, isReady)
	-- Display "Is ready" emote in the chat
	if Musician.Comm.GetCurrentSongCrc32() == songCrc32 then
		local emote = isReady and Musician.Msg.EMOTE_PLAYER_IS_READY or Musician.Msg.EMOTE_PLAYER_IS_NOT_READY
		Musician.Utils.DisplayEmote(player, UnitGUID(Musician.Utils.SimplePlayerName(player)), emote)
	end
end

--- OnBandPlay
--
function Musician.Frame.OnBandPlay(event, player, songCrc32)
	-- Display "Started band play" emote in the chat
	if Musician.Comm.GetCurrentSongCrc32() == songCrc32 then
		Musician.Utils.DisplayEmote(player, UnitGUID(Musician.Utils.SimplePlayerName(player)),
			Musician.Msg.EMOTE_PLAY_IN_BAND_START)
	end
end

--- OnBandStop
--
function Musician.Frame.OnBandStop(event, player, songCrc32)
	-- Display "Stopped band play" emote in the chat
	if Musician.Comm.GetCurrentSongCrc32() == songCrc32 then
		Musician.Utils.DisplayEmote(player, UnitGUID(Musician.Utils.SimplePlayerName(player)),
			Musician.Msg.EMOTE_PLAY_IN_BAND_STOP)
	end
end

--- OnSongReceiveSuccessful
-- Show main window when a downloaded song has been successfully imported for playing.
function Musician.Frame.OnSongReceiveSuccessful(event, _, _, song, context)
	if context ~= Musician then return end
	local isDataOnly = song == nil
	if not isDataOnly then

		-- Stop and wipe previous source song
		if Musician.sourceSong then
			if Musician.sourceSong:IsPlaying() then
				Musician.sourceSong:Stop()
			end
			Musician.sourceSong:Wipe()
		end

		-- Load source song
		Musician.sourceSong = song

		-- Refresh and show UI
		Musician.SongLinks:SendMessage(Musician.Events.SourceSongLoaded, song)
		MusicianFrame:Show()
	end
end