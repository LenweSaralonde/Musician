Musician.Frame = LibStub("AceAddon-3.0"):NewAddon("Musician.Frame", "AceEvent-3.0")

local MODULE_NAME = "MusicianFrame"
Musician.AddModule(MODULE_NAME)

local sourceBuffer
local sourceBufferCharIndex

--- Init
--
MusicianFrame.Init = function()
	MusicianFrame:SetClampedToScreen(true)

	Musician.Frame:RegisterMessage(Musician.Events.CommChannelUpdate, MusicianFrame.OnCommChannelUpdate)
	Musician.Frame:RegisterMessage(Musician.Events.CommSendAction, MusicianFrame.OnCommSendAction)
	Musician.Frame:RegisterMessage(Musician.Events.CommSendActionComplete, MusicianFrame.OnCommSendAction)
	Musician.Frame:RegisterMessage(Musician.Events.SongImportProgress, MusicianFrame.RefreshLoadingProgressBar)
	Musician.Frame:RegisterMessage(Musician.Events.SongImportComplete, MusicianFrame.RefreshLoadingProgressBar)
	Musician.Frame:RegisterMessage(Musician.Events.SongPlay, MusicianFrame.OnSongPlayOrStop)
	Musician.Frame:RegisterMessage(Musician.Events.SongStop, MusicianFrame.OnSongPlayOrStop)
	Musician.Frame:RegisterMessage(Musician.Events.SongCursor, MusicianFrame.RefreshPlayingProgressBar)
	Musician.Frame:RegisterMessage(Musician.Events.SourceSongLoaded, MusicianFrame.OnSourceSongUpdated)
	Musician.Frame:RegisterMessage(Musician.Events.SongImportFailed, MusicianFrame.OnSourceSongUpdated)
	Musician.Frame:RegisterMessage(Musician.Events.Bandwidth, MusicianFrame.RefreshBandwidthIndicator)

	MusicianFrameTestButton:SetText(Musician.Msg.TEST_SONG)
	MusicianFrameTestButton:SetEnabled(false)
	MusicianFramePlayButton:SetText(Musician.Msg.PLAY)
	MusicianFramePlayButton.isReady = true
	MusicianFrame.UpdatePlayButton()
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
MusicianFrame.Focus = function()
	if not(MusicianFrameSource:HasFocus()) then
		MusicianFrameSource:HighlightText(0)
		MusicianFrameSource:SetFocus()
	end
end

--- Clear import field
--
MusicianFrame.Clear = function(noFocus)
	sourceBuffer = {}
	sourceBufferCharIndex = 1

	MusicianFrameSource:SetText(MusicianFrame.GetDefaultText())
	MusicianFrameSource:HighlightText(0)

	if not(noFocus) then
		MusicianFrameSource:SetFocus()
	end

	-- Frame contents have been refreshed
	Musician.Frame:SendMessage(Musician.Events.RefreshFrame)
end

--- Open track editor
--
MusicianFrame.TrackEditor = function()
	if Musician.sourceSong then
		MusicianTrackEditor:Show()
	end
end

--- OnSourceChanged
--
MusicianFrame.OnSourceChanged = function(self, isUserInput)
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
MusicianFrame.ImportSource = function()
	local source = table.concat(sourceBuffer)
	if source == "" or source == MusicianFrame.GetDefaultText() then
		return
	end

	Musician.ImportSource(source)
end

--- Preview source song
--
MusicianFrame.TogglePreviewSong = function()
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
MusicianFrame.GetDefaultText = function()
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
MusicianFrame.UpdatePlayButton = function()
	isEnabled = Musician.sourceSong and Musician.Comm.ChannelIsReady() and MusicianFramePlayButton.isReady
	MusicianFramePlayButton:SetEnabled(isEnabled)
end

--- OnCommChannelUpdate
-- @param event (string)
-- @param isConnected (boolean)
MusicianFrame.OnCommChannelUpdate = function(event, isConnected)
	MusicianFrame.UpdatePlayButton()
end

--- OnCommSendAction
-- @param event (string)
-- @param action (string)
MusicianFrame.OnCommSendAction = function(event, action)
	local isComplete = event == Musician.Events.CommSendActionComplete

	if (action == Musician.Comm.action.play) or (action == Musician.Comm.action.stop) then
		MusicianFramePlayButton.isReady = isComplete
		MusicianFrame.UpdatePlayButton()
	end
end

--- OnCommSendAction
-- @param event (string)
-- @param song (Musician.Song)
MusicianFrame.OnSongPlayOrStop = function(event, song)
	local isPlaying = event == Musician.Events.SongPlay
	local isSourceSong = song == Musician.sourceSong
	local isMySong = Musician.Utils.PlayerIsMyself(song.player) and Musician.songs[song.player]

	if isSourceSong then
		MusicianFrameTestButton:SetText(isPlaying and Musician.Msg.STOP_TEST or Musician.Msg.TEST_SONG)
		MusicianFrame.RefreshPlayingProgressBar(event, song)
	elseif isMySong then
		MusicianFramePlayButton:SetText(isPlaying and Musician.Msg.STOP or Musician.Msg.PLAY)
		MusicianFrame.RefreshPlayingProgressBar(event, song)
	end
end

--- OnSourceSongUpdated
--
MusicianFrame.OnSourceSongUpdated = function(event, ...)
	if Musician.sourceSong == nil then
		MusicianFrameTestButton:Disable()
		MusicianFrameTrackEditorButton:Disable()
		MusicianTrackEditor:Hide()
	else
		MusicianFrameTestButton:Enable()
		MusicianFrameTrackEditorButton:Enable()
		MusicianFrame.UpdatePlayButton()
	end
	MusicianFrame.Clear()
end

--- Refresh loading progress bar
-- @param event (string)
-- @param song (Musician.Song)
-- @param progression (number)
MusicianFrame.RefreshLoadingProgressBar = function(event, song, progression)
	if not(song.importing) then
		MusicianFrameTextBackgroundLoadingProgressBar:Hide()
		MusicianFrame.Clear(true)
	else
		MusicianFrameTextBackgroundLoadingProgressBar:Show()

		if progression ~= nil then
			MusicianFrameTextBackgroundLoadingProgressBar:SetWidth(max(1, (MusicianFrameTextBackground:GetWidth() - 10) * progression))
		end
	end
end

--- Regresh progress bar of the song
-- @param event (string)
-- @param song (Musician.Song) Can be the source song or the song currently playing
MusicianFrame.RefreshPlayingProgressBar = function(event, song)
	local button
	local isSourceSong = song == Musician.sourceSong
	local isMySong = Musician.Utils.PlayerIsMyself(song.player) and Musician.songs[song.player]

	if isSourceSong then
		button = MusicianFrameTestButton
	elseif isMySong then
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
MusicianFrame.RefreshBandwidthIndicator = function(event, bandwidth)
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