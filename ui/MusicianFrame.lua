Musician.Frame = LibStub("AceAddon-3.0"):NewAddon("Musician.Frame", "AceEvent-3.0")

local sourceBuffer
local i

local bandwidthLevel = 0

MusicianFrame.Init = function()
	MusicianFrame:SetClampedToScreen(true)
	MusicianFrame.Refresh()

	local onSongLoaded = function(event, ...)
		MusicianFrame.Refresh()
		MusicianFrame.Clear(true)
	end

	local onSongPlayStop = function(event, song)
		MusicianFrame.Refresh()
		MusicianFrame.RefreshPlayingProgressBar(event, song)
	end

	local doRefresh = function(event, ...)
		MusicianFrame.Refresh()
	end

	Musician.Frame:RegisterMessage(Musician.Events.RefreshFrame, MusicianFrame.Refresh)
	Musician.Frame:RegisterMessage(Musician.Events.CommChannelUpdate, doRefresh)
	Musician.Frame:RegisterMessage(Musician.Events.CommSendAction, doRefresh)
	Musician.Frame:RegisterMessage(Musician.Events.CommSendActionComplete, doRefresh)
	Musician.Frame:RegisterMessage(Musician.Events.SongImportProgress, MusicianFrame.RefreshLoadingProgressBar)
	Musician.Frame:RegisterMessage(Musician.Events.SongImportComplete, MusicianFrame.RefreshLoadingProgressBar)
	Musician.Frame:RegisterMessage(Musician.Events.SongPlay, onSongPlayStop)
	Musician.Frame:RegisterMessage(Musician.Events.SongStop, onSongPlayStop)
	Musician.Frame:RegisterMessage(Musician.Events.SongCursor, MusicianFrame.RefreshPlayingProgressBar)
	Musician.Frame:RegisterMessage(Musician.Events.SourceSongLoaded, onSongLoaded)
	Musician.Frame:RegisterMessage(Musician.Events.SongImportFailed, doRefresh)
	Musician.Frame:RegisterMessage(Musician.Events.Bandwidth, MusicianFrame.RefreshBandwidthIndicator)

	MusicianFrame:SetScript("OnUpdate", MusicianFrame.OnUpdate)

	MusicianFrame.Clear()

	MusicianFrameSource:SetMaxBytes(512)
	MusicianFrameSource:SetScript("OnTextChanged", MusicianFrame.SourceChanged)
	MusicianFrameSource:SetScript("OnChar", function(self, c)
		sourceBuffer[i] = c
		i = i + 1
	end)

	MusicianFrameTextBackgroundLoadingProgressBar:Hide()
	MusicianFrameTestButtonProgressBar:Hide()
	MusicianFramePlayButtonProgressBar:Hide()
end

MusicianFrame.Focus = function()
	if not(MusicianFrameSource:HasFocus()) then
		MusicianFrameSource:HighlightText(0)
		MusicianFrameSource:SetFocus()
	end
end

MusicianFrame.Clear = function(noFocus)
	sourceBuffer = {}
	i = 1

	MusicianFrameSource:SetText(MusicianFrame.GetDefaultText())
	MusicianFrameSource:HighlightText(0)

	if not(noFocus) then
		MusicianFrameSource:SetFocus()
	end
end

MusicianFrame.TrackEditor = function()
	if Musician.sourceSong then
		MusicianTrackEditor:Show()
	end
end

MusicianFrame.SourceChanged = function(self, isUserInput)
	MusicianFrameSource:HighlightText(0, 0)
	MusicianFrameSource:ClearFocus()

	if isUserInput then
		MusicianFrame.ImportSource()
		MusicianFrame.Focus()
		sourceBuffer = {}
		i = 1
	end
end

MusicianFrame.ImportSource = function()
	local source = table.concat(sourceBuffer)
	if source == "" or source == MusicianFrame.GetDefaultText() then
		return
	end

	Musician.ImportSource(source)
end

MusicianFrame.Test = function()
	if Musician.sourceSong then
		if Musician.sourceSong:IsPlaying() then
			Musician.sourceSong:Stop()
		else
			Musician.sourceSong:Play()
		end
	end
end

MusicianFrame.Play = function()
	if Musician.songIsPlaying then
		Musician.Comm.StopSong()
	else
		Musician.Comm.PlaySong()
	end
end

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

MusicianFrame.Refresh = function(event, isComplete)

	if isComplete then return end

	-- Track editor button
	if Musician.sourceSong == nil then
		MusicianFrameTrackEditorButton:Disable()
		MusicianTrackEditor:Hide()
	else
		MusicianFrameTrackEditorButton:Enable()
	end

	-- Test song button
	if Musician.sourceSong == nil then
		MusicianFrameTestButton:Disable()
	else
		MusicianFrameTestButton:Enable()
	end

	if Musician.sourceSong ~= nil and Musician.sourceSong:IsPlaying() then
		MusicianFrameTestButton:SetText(Musician.Msg.STOP_TEST)
	else
		MusicianFrameTestButton:SetText(Musician.Msg.TEST_SONG)
	end

	-- Play button
	if not(Musician.Comm.CanBroadcast()) or Musician.Comm.isPlaySent or Musician.Comm.isStopSent or not(Musician.sourceSong) and not(Musician.songIsPlaying) then
		MusicianFramePlayButton:Disable()
	else
		MusicianFramePlayButton:Enable()
	end

	if Musician.songIsPlaying then
		MusicianFramePlayButton:SetText(Musician.Msg.STOP)
	else
		MusicianFramePlayButton:SetText(Musician.Msg.PLAY)
	end

	-- Refresh is complete
	Musician.Frame:SendMessage(Musician.Events.RefreshFrame, true)
end

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

MusicianFrame.RefreshPlayingProgressBar = function(event, song)
	local button

	if song == Musician.sourceSong then
		button = MusicianFrameTestButton
	elseif song == Musician.songs[Musician.Utils.NormalizePlayerName(UnitName("player"))] then
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

MusicianFrame.RefreshBandwidthIndicator = function(event, bandwidth)
	bandwidthLevel = bandwidth
end

MusicianFrame.OnUpdate = function()

	local r = max(0, min(1, bandwidthLevel * 2))
	local g = max(0, min(1, 2 - bandwidthLevel * 2))
	local b = 0
	local a = 1

	if bandwidthLevel == 1 then
		local t = GetTime()
		r = sin((t - floor(t)) * 720) * .33 + .67
	end

	MusicianFramePlayButtonProgressBar:SetColorTexture(r, g, b, a)
end
