Musician.TrackEditor = LibStub("AceAddon-3.0"):NewAddon("Musician.TrackEditor", "AceEvent-3.0")

Musician.TrackEditor.Init = function()
	Musician.TrackEditor:RegisterMessage(Musician.Events.SongCursor, Musician.TrackEditor.UpdateCursor)
	Musician.TrackEditor:RegisterMessage(Musician.Events.SongPlay, Musician.TrackEditor.UpdateButtons)
	Musician.TrackEditor:RegisterMessage(Musician.Events.SongStop, Musician.TrackEditor.UpdateButtons)
	MusicianTrackEditorTitle:SetText(Musician.Msg.SONG_EDITOR)
	MusicianTrackEditorPrevButton:SetText("<<")
	MusicianTrackEditorNextButton:SetText(">>")
	MusicianTrackEditorCropFromTitle:SetText(Musician.Msg.MARKER_FROM)
	MusicianTrackEditorCropToTitle:SetText(Musician.Msg.MARKER_TO)
	MusicianTrackEditorCursorAtTitle:SetText(Musician.Msg.POSITION)

	MusicianTrackEditorCropFrom:SetScript("OnEditFocusLost", function(self)
		Musician.sourceSong.cropFrom = Musician.Utils.ParseTime(self:GetText())
		Musician.TrackEditor.UpdateSlider()
		Musician.TrackEditor.UpdateBounds()
	end)

	MusicianTrackEditorCropTo:SetScript("OnEditFocusLost", function(self)
		local cropTo = Musician.Utils.ParseTime(self:GetText())
		if cropTo == 0 then
			Musician.sourceSong.cropTo = Musician.sourceSong.duration
		else
			Musician.sourceSong.cropTo = cropTo
		end
		Musician.TrackEditor.UpdateSlider()
		Musician.TrackEditor.UpdateBounds()
	end)

	MusicianTrackEditorCursorAt:SetScript("OnEditFocusLost", function(self)
		Musician.sourceSong:Seek(Musician.Utils.ParseTime(self:GetText()))
	end)
end

Musician.TrackEditor.OnLoad = function()
	Musician.TrackEditor.UpdateSlider()
	Musician.TrackEditor.UpdateButtons()
	Musician.TrackEditor.UpdateBounds()
	Musician.TrackEditor.UpdateCursor(nil, Musician.sourceSong)
end

Musician.TrackEditor.UpdateButtons = function()
	if Musician.sourceSong:IsPlaying() then
		MusicianTrackEditorPlayButton:SetText(Musician.Msg.PAUSE)
	else
		MusicianTrackEditorPlayButton:SetText(Musician.Msg.PLAY)
	end
end

Musician.TrackEditor.UpdateSlider = function()
	MusicianTrackEditorSourceSongSliderLow:SetText("")
	MusicianTrackEditorSourceSongSliderHigh:SetText("")
	MusicianTrackEditorSourceSongSlider:SetMinMaxValues(Musician.sourceSong.cropFrom, Musician.sourceSong.cropTo)
	MusicianTrackEditorSourceSongSlider:SetValue(Musician.sourceSong.cursor)
end

Musician.TrackEditor.UpdateCursor = function(event, song)
	if song == Musician.sourceSong then
		if not(MusicianTrackEditorSourceSongSlider.dragging) then
			local cursor = max(Musician.sourceSong.cropFrom, min(Musician.sourceSong.cropTo, Musician.sourceSong.cursor))
			MusicianTrackEditorSourceSongSlider:SetValue(cursor)
			if not(MusicianTrackEditorCursorAt:HasFocus()) then
				MusicianTrackEditorCursorAt:SetText(Musician.Utils.FormatTime(cursor))
			end
		else
			MusicianTrackEditorCursorAt:SetText(Musician.Utils.FormatTime(MusicianTrackEditorSourceSongSlider:GetValue()))
		end
	end
end

Musician.TrackEditor.UpdateBounds = function()
	MusicianTrackEditorCropFrom:SetText(Musician.Utils.FormatTime(Musician.sourceSong.cropFrom))
	MusicianTrackEditorCropTo:SetText(Musician.Utils.FormatTime(Musician.sourceSong.cropTo))
end



