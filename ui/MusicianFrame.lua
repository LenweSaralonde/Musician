Musician.Frame = LibStub("AceAddon-3.0"):NewAddon("Musician.Frame", "AceEvent-3.0")

local sourceBuffer
local i

MusicianFrame.Init = function()
	MusicianFrame:SetClampedToScreen(true)
	MusicianFrame.Refresh()
	Musician.Frame:RegisterMessage(Musician.Events.RefreshFrame, MusicianFrame.Refresh)
	MusicianFrame.Clear()
	MusicianFrameTitle:SetText(Musician.Msg.PLAY_A_SONG)
	MusicianFrameClearButton:SetText(Musician.Msg.CLEAR)
	MusicianFrameTrackEditorButton:SetText(Musician.Msg.EDIT)
	MusicianFrameSource:SetMaxBytes(512)
	MusicianFrameSource:SetScript("OnTextChanged", MusicianFrame.SourceChanged)
	MusicianFrameSource:SetScript("OnChar", function(self, c)
		sourceBuffer[i] = c
		i = i + 1
	end)
end

MusicianFrame.Focus = function()
	if not(MusicianFrameSource:HasFocus()) then
		MusicianFrameSource:HighlightText(0)
		MusicianFrameSource:SetFocus()
	end
end

MusicianFrame.Clear = function()
	sourceBuffer = {}
	i = 1
	MusicianFrameSource:SetText(MusicianFrame.GetDefaultText())
	MusicianFrameSource:HighlightText(0)
	MusicianFrameSource:SetFocus()
end

MusicianFrame.TrackEditor = function()
	MusicianTrackEditor:Show()
end

MusicianFrame.SourceChanged = function(self, isUserInput)
	MusicianFrameSource:HighlightText(0, 0)
	MusicianFrameSource:ClearFocus()

	if isUserInput then
		MusicianFrame.LoadSource()
		MusicianFrame.Focus()
		sourceBuffer = {}
		i = 1
	end
end

MusicianFrame.LoadSource = function()
	local source = table.concat(sourceBuffer)
	if source == "" or source == MusicianFrame.GetDefaultText() then
		return
	end

	local sourceSong
	local success = pcall(function()
		sourceSong = Musician.Song.create(Musician.Utils.Base64Decode(source), true)
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

	-- Play button
	if Musician.Comm.isPlaySent or Musician.Comm.isStopSent or not(Musician.sourceSong) and not(Musician.songIsPlaying) then
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
