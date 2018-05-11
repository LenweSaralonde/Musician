Musician.Frame = LibStub("AceAddon-3.0"):NewAddon("Musician.Frame", "AceEvent-3.0")

MusicianFrame.Init = function()
	MusicianFrame.Refresh()
	Musician.Frame:RegisterMessage(Musician.Events.RefreshFrame, MusicianFrame.Refresh)
	MusicianFrame.Clear()
	MusicianFrameTitle:SetText(Musician.Msg.PLAY_A_SONG)
	MusicianFrameClearButton:SetText(Musician.Msg.CLEAR)
	MusicianFrameTrackEditorButton:SetText(Musician.Msg.EDIT)
	MusicianFrameSource:SetScript("OnTextChanged", MusicianFrame.SourceChanged)
end

MusicianFrame.Focus = function()
	local editable = MusicianFrameSource:GetText() == "" or MusicianFrameSource:GetText() == MusicianFrame.GetDefaultText()
	if editable then
		MusicianFrameSource:HighlightText(0)
		MusicianFrameSource:SetFocus()
	else
		MusicianFrameSource:HighlightText(0, 0)
		MusicianFrameSource:ClearFocus()
	end
end

MusicianFrame.Clear = function()
	MusicianFrameSource:SetText(MusicianFrame.GetDefaultText())
	MusicianFrame.Focus()
end

MusicianFrame.TrackEditor = function()
	MusicianTrackEditor:Show()
end

MusicianFrame.SourceChanged = function(self, isUserInput)
	ScrollingEdit_OnTextChanged(self, self:GetParent())

	if isUserInput then
		MusicianFrame.LoadSource()
		MusicianFrame.Focus()
	end
end

MusicianFrame.LoadSource = function()
	if MusicianFrameSource:GetText() == "" or MusicianFrameSource:GetText() == MusicianFrame.GetDefaultText() then
		return
	end

	local sourceSong
	local success = pcall(function()
		sourceSong = Musician.Song.create(MusicianBase64.decode(MusicianFrameSource:GetText()))
	end)

	if not(success) then
		Musician.Utils.Error(Musician.Msg.INVALID_MUSIC_CODE)
	else
		-- Stop previous source song being played
		if Musician.sourceSong and  Musician.sourceSong:IsPlaying() then
			Musician.sourceSong:Stop()
		end

		Musician.sourceSong = sourceSong
		Musician.TrackEditor.OnLoad()
	end

	Musician.Comm:SendMessage(Musician.Events.RefreshFrame)
end

MusicianFrame.Test = function()
	if Musician.sourceSong then
		if Musician.sourceSong:IsPlaying() then
			Musician.sourceSong:Stop()
		else
			Musician.sourceSong:Play()
		end
	end
	Musician.Comm:SendMessage(Musician.Events.RefreshFrame)
end

MusicianFrame.Load = function()
	if not(Musician.Comm.isSending) and Musician.sourceSong then
		Musician.Comm.BroadcastSong(Musician.sourceSong)
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
	return string.gsub(Musician.Msg.PASTE_MUSIC_CODE, "{url}", Musician.CONVERTER_URL)
end

MusicianFrame.Refresh = function()

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

	-- Load button
	if Musician.sourceSong == nil or Musician.Comm.isSending then
		MusicianFrameLoadButton:Disable()
	else
		MusicianFrameLoadButton:Enable()
	end

	if Musician.Comm.isSending then

		if MusicianFrame.LoadingSpinner == nil then
			MusicianFrameLoadButton:SetText(Musician.Msg.LOADING)

			local dots = 1
			MusicianFrame.LoadingSpinner = C_Timer.NewTicker(.25, function()
				if Musician.Comm.isSending then
					MusicianFrameLoadButton:SetText(Musician.Msg.LOADING .. string.rep('.', dots) .. string.rep(' ', 3 - dots))
					dots = (dots + 1) % 4
				else
					MusicianFrame.LoadingSpinner:Cancel()
					MusicianFrame.LoadingSpinner = nil
					MusicianFrame.Refresh()
				end
			end)

		end
	else
		if MusicianFrame.LoadingSpinner ~= nil then
			MusicianFrame.LoadingSpinner:Cancel()
			MusicianFrame.LoadingSpinner = nil
		end

		MusicianFrameLoadButton:SetText(Musician.Msg.LOAD)
	end

	-- Play button
	if Musician.Comm.isPlaySent or Musician.Comm.isStopSent or not(Musician.Comm.SongIsLoaded()) and not(Musician.songIsPlaying) then
		MusicianFramePlayButton:Disable()
	else
		MusicianFramePlayButton:Enable()
	end

	if Musician.songIsPlaying then
		MusicianFramePlayButton:SetText(Musician.Msg.STOP)
	else
		MusicianFramePlayButton:SetText(Musician.Msg.PLAY)
	end
end
