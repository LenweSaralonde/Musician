--- Main window with song import and controls
-- @module Musician.Frame

Musician.Frame = LibStub("AceAddon-3.0"):NewAddon("Musician.Frame", "AceEvent-3.0")

local MODULE_NAME = "MusicianFrame"
Musician.AddModule(MODULE_NAME)

local sourceBuffer
local sourceBufferCharIndex

local isCommActionPending = false
local readyBandPlayPlayers = {}

MusicianFrame.bandPlayReadyPlayers = {}

--- Init
--
function MusicianFrame.Init()
	MusicianFrame:SetClampedToScreen(true)

	Musician.Frame:RegisterMessage(Musician.Events.CommChannelUpdate, MusicianFrame.OnCommChannelUpdate)
	Musician.Frame:RegisterMessage(Musician.Events.CommSendAction, MusicianFrame.OnCommSendAction)
	Musician.Frame:RegisterMessage(Musician.Events.CommSendActionComplete, MusicianFrame.OnCommSendAction)
	Musician.Frame:RegisterMessage(Musician.Events.SongImportStart, MusicianFrame.RefreshButtons)
	Musician.Frame:RegisterMessage(Musician.Events.SongImportComplete, MusicianFrame.RefreshButtons)
	Musician.Frame:RegisterMessage(Musician.Events.SongImportProgress, MusicianFrame.RefreshLoadingProgressBar)
	Musician.Frame:RegisterMessage(Musician.Events.SongPlay, MusicianFrame.OnSongPlayOrStop)
	Musician.Frame:RegisterMessage(Musician.Events.SongStop, MusicianFrame.OnSongPlayOrStop)
	Musician.Frame:RegisterMessage(Musician.Events.SongCursor, MusicianFrame.RefreshPlayingProgressBar)
	Musician.Frame:RegisterMessage(Musician.Events.SourceSongLoaded, MusicianFrame.OnSourceSongUpdated)
	Musician.Frame:RegisterMessage(Musician.Events.SongImportFailed, MusicianFrame.OnSourceSongUpdated)
	Musician.Frame:RegisterMessage(Musician.Events.Bandwidth, MusicianFrame.RefreshBandwidthIndicator)
	Musician.Frame:RegisterMessage(Musician.Events.BandPlay, MusicianFrame.OnBandPlay)
	Musician.Frame:RegisterMessage(Musician.Events.BandStop, MusicianFrame.OnBandStop)
	Musician.Frame:RegisterMessage(Musician.Events.BandPlayReady, MusicianFrame.OnBandPlayReady)
	Musician.Frame:RegisterMessage(Musician.Events.BandReadyPlayersUpdated, MusicianFrame.UpdateBandPlayButton)
	Musician.Frame:RegisterMessage(Musician.Events.SongReceiveSucessful, MusicianFrame.OnSongReceiveSucessful)
	Musician.Frame:RegisterEvent("GROUP_ROSTER_UPDATE", MusicianFrame.OnRosterUpdate)
	Musician.Frame:RegisterEvent("PLAYER_DEAD", MusicianFrame.OnCommChannelUpdate)
	Musician.Frame:RegisterEvent("PLAYER_ALIVE", MusicianFrame.OnCommChannelUpdate)
	Musician.Frame:RegisterEvent("PLAYER_UNGHOST", MusicianFrame.OnCommChannelUpdate)

	MusicianFrameTrackEditorButton:Disable()
	MusicianFrameLinkButton:Disable()
	MusicianFrameTestButton:SetText(Musician.Msg.TEST_SONG)
	MusicianFrameTestButton:SetEnabled(false)
	MusicianFramePlayButton:SetText(Musician.Msg.PLAY)
	MusicianFrame.UpdatePlayButton()
	MusicianFrame.UpdateBandPlayButton()
	MusicianFrame.Clear()

	MusicianFrameSource:SetMaxBytes(512)
	MusicianFrameSource:SetScript("OnTextChanged", MusicianFrame.OnSourceChanged)
	MusicianFrameSource:SetScript("OnChar", function(self, c)
		sourceBuffer[sourceBufferCharIndex] = c
		sourceBufferCharIndex = sourceBufferCharIndex + 1
	end)

	MusicianFrameTextBackgroundLoadingProgressBar:Hide()
	MusicianFrameTestButtonProgressBar:Hide()
	MusicianFramePlayButtonProgressBar:Hide()
end

--- Set focus to import field
--
function MusicianFrame.Focus()
	if not(MusicianFrameSource:HasFocus()) then
		MusicianFrameSource:HighlightText(0)
		MusicianFrameSource:SetFocus()
	end
end

--- Clear import field
-- @param focus (boolean)
function MusicianFrame.Clear(focus)
	sourceBuffer = {}
	sourceBufferCharIndex = 1

	MusicianFrameSource:SetText(MusicianFrame.GetDefaultText())
	MusicianFrameSource:HighlightText(0)

	if focus then
		MusicianFrameSource:SetFocus()
	end
end

--- Open track editor
--
function MusicianFrame.TrackEditor()
	if Musician.sourceSong then
		MusicianTrackEditor:Show()
	end
end

--- OnSourceChanged
--
function MusicianFrame.OnSourceChanged(self, isUserInput)
	MusicianFrameSource:HighlightText(0, 0)
	MusicianFrameSource:ClearFocus()

	if isUserInput then
		MusicianFrame.ImportSource()
		MusicianFrame.Focus()
		sourceBuffer = {}
		sourceBufferCharIndex = 1
	end
end

--- Import source song
--
function MusicianFrame.ImportSource()
	local source = table.concat(sourceBuffer)
	if source == "" or source == MusicianFrame.GetDefaultText() then
		return
	end

	Musician.ImportSource(source)
end

--- Preview source song
--
function MusicianFrame.TogglePreviewSong()
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
function MusicianFrame.GetDefaultText()
	local defaultText = string.gsub(Musician.Msg.PASTE_MUSIC_CODE, "{url}", Musician.CONVERTER_URL)
	local shortcut

	if IsMacClient() then
		shortcut = "Cmd+V"
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
function MusicianFrame.UpdatePlayButton()
	isEnabled = Musician.sourceSong and Musician.Comm.CanPlay() and not(isCommActionPending)

	-- This may happen on trial accounts in raid mode
	if IsInGroup() and (Musician.Comm.GetGroupChatType() == nil) then
		isEnabled = false
	end

	MusicianFramePlayButton:SetEnabled(isEnabled)
end

--- OnRosterUpdate
--
function MusicianFrame.OnRosterUpdate(event)
	MusicianFrame.UpdatePlayButton()
	MusicianFrame.UpdateBandPlayButton()
end

--- OnCommChannelUpdate
-- @param event (string)
-- @param isConnected (boolean)
function MusicianFrame.OnCommChannelUpdate(event, isConnected)
	MusicianFrame.UpdatePlayButton()
	MusicianFrame.UpdateBandPlayButton()
end

--- OnCommSendAction
-- @param event (string)
-- @param action (string)
function MusicianFrame.OnCommSendAction(event, action)
	local isComplete = event == Musician.Events.CommSendActionComplete
	isCommActionPending = not(isComplete)
	MusicianFrame.UpdatePlayButton()
	MusicianFrame.UpdateBandPlayButton()
end

--- OnCommSendAction
-- @param event (string)
-- @param song (Musician.Song)
function MusicianFrame.OnSongPlayOrStop(event, song)
	local isPlaying = event == Musician.Events.SongPlay

	if song == Musician.sourceSong then
		MusicianFrameTestButton:SetText(isPlaying and Musician.Msg.STOP_TEST or Musician.Msg.TEST_SONG)
		MusicianFrame.RefreshPlayingProgressBar(event, song)
	elseif Musician.Utils.PlayerIsMyself(song.player) and Musician.songs[song.player] and not(song.isLiveStreamingSong) then
		MusicianFramePlayButton:SetText(isPlaying and Musician.Msg.STOP or Musician.Msg.PLAY)
		MusicianFrame.RefreshPlayingProgressBar(event, song)

		-- My song started in band playing mode: set the button LED still
		if Musician.Comm.IsBandPlayReady() and isPlaying then
			MusicianFrameBandPlayButton:SetBlinking(false)
		end
	end
end

--- OnSourceSongUpdated
--
function MusicianFrame.OnSourceSongUpdated()
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
	MusicianFrame.UpdatePlayButton()
	MusicianFrame.UpdateBandPlayButton()
	MusicianFrame.Clear()
end

--- Refresh buttons
-- @param event (string)
-- @param song (Musician.Song)
function MusicianFrame.RefreshButtons(event, song)
	if song ~= Musician.importingSong then return end
	if not(song.importing) then
		MusicianFrameClearButton:Enable()
		MusicianFrameSource:Enable()
		MusicianFrame.SetLoadingProgressBar(nil)
		MusicianFrame.Clear()
	else
		MusicianFrameClearButton:Disable()
		MusicianFrameSource:Disable()
	end
end

--- Refresh loading progress bar
-- @param event (string)
-- @param song (Musician.Song)
-- @param progression (number)
function MusicianFrame.RefreshLoadingProgressBar(event, song, progression)
	if song ~= Musician.importingSong then return end
	MusicianFrame.SetLoadingProgressBar(progression)
end

--- Set loading progress bar position
-- @param[opt] progression (number)
function MusicianFrame.SetLoadingProgressBar(progression)
	if progression == nil then
		MusicianFrameTextBackgroundLoadingProgressBar:Hide()
	else
		MusicianFrameTextBackgroundLoadingProgressBar:Show()
		MusicianFrameTextBackgroundLoadingProgressBar:SetWidth(max(1, (MusicianFrameTextBackground:GetWidth() - 10) * progression))
	end
end

--- Regresh progress bar of the song
-- @param event (string)
-- @param song (Musician.Song) Can be the source song or the song currently playing
function MusicianFrame.RefreshPlayingProgressBar(event, song)
	local button

	if song == Musician.sourceSong then
		button = MusicianFrameTestButton
	elseif Musician.Utils.PlayerIsMyself(song.player) and Musician.songs[song.player] and not(Musician.songs[song.player].isLiveStreamingSong) then
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
function MusicianFrame.RefreshBandwidthIndicator(event, bandwidth)
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
function MusicianFrame.UpdateBandPlayButton()

	-- Update button visibility

	local isVisible = IsInGroup()
	local isEnabled = Musician.sourceSong and (Musician.Comm.GetGroupChatType() ~= nil) and not(isCommActionPending)
	MusicianFrameBandPlayButton:SetShown(isVisible)
	MusicianFrameBandPlayButton:SetEnabled(isEnabled)

	-- Update button LED

	MusicianFrameBandPlayButton:SetChecked(Musician.Comm.IsBandPlayReady())
	MusicianFrameBandPlayButton:SetBlinking(not(Musician.Comm.IsSongPlaying()))

	-- Update tooltip and the number of ready players

	local players = Musician.Comm.GetReadyBandPlayers()
	local tooltipText = Musician.Msg.PLAY_IN_BAND

	if not(Musician.Comm.IsBandPlayReady()) then
		tooltipText = tooltipText .. "\n" .. Musician.Utils.Highlight(Musician.Msg.PLAY_IN_BAND_HINT, "00FFFF")
	end

	if #players > 0 then
		MusicianFrameBandPlayButton.count.text:SetText(#players)
		MusicianFrameBandPlayButton.count:Show()

		local playerNames = {}
		local playerName
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
function MusicianFrame.OnBandPlayReady(event, player, songCrc32, isReady)
	-- Display "Is ready" emote in the chat
	if Musician.Comm.GetCurrentSongCrc32() == songCrc32 then
		local emote = isReady and Musician.Msg.EMOTE_PLAYER_IS_READY or Musician.Msg.EMOTE_PLAYER_IS_NOT_READY
		Musician.Utils.DisplayEmote(player, UnitGUID(Musician.Utils.SimplePlayerName(player)), emote)
	end
end

--- OnBandPlay
--
function MusicianFrame.OnBandPlay(event, player, songCrc32)
	-- Display "Started band play" emote in the chat
	if Musician.Comm.GetCurrentSongCrc32() == songCrc32 then
		Musician.Utils.DisplayEmote(player, UnitGUID(Musician.Utils.SimplePlayerName(player)), Musician.Msg.EMOTE_PLAY_IN_BAND_START)
	end
end

--- OnBandStop
--
function MusicianFrame.OnBandStop(event, player, songCrc32)
	-- Display "Stopped band play" emote in the chat
	if Musician.Comm.GetCurrentSongCrc32() == songCrc32 then
		Musician.Utils.DisplayEmote(player, UnitGUID(Musician.Utils.SimplePlayerName(player)), Musician.Msg.EMOTE_PLAY_IN_BAND_STOP)
	end
end

--- OnSongReceiveSucessful
-- Show main window when a downloaded song has been successfully imported for playing.
function MusicianFrame.OnSongReceiveSucessful(event, sender, songData, song)
	local isDataOnly = song == nil
	if not(isDataOnly) then
		MusicianFrame:Show()
	end
end
