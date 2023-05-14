--- Song editor window
-- @module Musician.TrackEditor

Musician.TrackEditor = LibStub("AceAddon-3.0"):NewAddon("Musician.TrackEditor", "AceEvent-3.0")

local MODULE_NAME = "TrackEditor"
Musician.AddModule(MODULE_NAME)

Musician.TrackEditor.MAX_NOTE_DURATION = 6

local NOTE = Musician.Song.Indexes.NOTE

--- Init
--
function Musician.TrackEditor.Init()
	-- Register events
	Musician.TrackEditor:RegisterMessage(Musician.Events.SongCursor, Musician.TrackEditor.UpdateCursor)
	Musician.TrackEditor:RegisterMessage(Musician.Events.SongPlay, Musician.TrackEditor.UpdateButtons)
	Musician.TrackEditor:RegisterMessage(Musician.Events.SongStop, Musician.TrackEditor.UpdateButtons)
	Musician.TrackEditor:RegisterMessage(Musician.Events.Frame, Musician.TrackEditor.OnUpdate)
	Musician.TrackEditor:RegisterMessage(Musician.Events.VisualNoteOn, Musician.TrackEditor.NoteOn)
	Musician.TrackEditor:RegisterMessage(Musician.Events.VisualNoteOff, Musician.TrackEditor.NoteOff)
	Musician.TrackEditor:RegisterMessage(Musician.Events.SourceSongLoaded, Musician.TrackEditor.OnLoad)
	Musician.TrackEditor:RegisterMessage(Musician.Events.StreamStart, Musician.TrackEditor.UpdateSyncButton)
	Musician.TrackEditor:RegisterMessage(Musician.Events.StreamStop, Musician.TrackEditor.UpdateSyncButton)
	Musician.TrackEditor:RegisterMessage(Musician.Events.SongInstrumentChange, Musician.TrackEditor.OnInstrumentChange)
	Musician.TrackEditor:RegisterMessage(Musician.Events.SongTransposeChange, Musician.TrackEditor.OnTransposeChange)
	Musician.TrackEditor:RegisterMessage(Musician.Events.SongMutedChange, Musician.TrackEditor.OnMutedChange)
	Musician.TrackEditor:RegisterMessage(Musician.Events.SongSoloChange, Musician.TrackEditor.OnSoloChange)
	Musician.TrackEditor:RegisterMessage(Musician.Events.SongAccentChange, Musician.TrackEditor.OnAccentChange)
	Musician.TrackEditor:RegisterMessage(Musician.Events.SongCropFromChange, Musician.TrackEditor.OnCropChange)
	Musician.TrackEditor:RegisterMessage(Musician.Events.SongCropToChange, Musician.TrackEditor.OnCropChange)

	-- Main frame settings
	MusicianTrackEditor:SetClampedToScreen(true)

	-- Clamp main frame size
	MusicianTrackEditor:HookScript("OnSizeChanged", function(self)
		local width, height = self:GetSize()
		local minWidth, minHeight = 600, 270
		local maxWidth, maxHeight = UIParent:GetWidth() / self:GetScale(), UIParent:GetHeight() / self:GetScale()
		self:SetSize(
			max(minWidth, min(maxWidth, width)),
			max(minHeight, min(maxHeight, height))
		)
	end)

	-- Set text labels
	MusicianTrackEditorTitle:SetText(Musician.Msg.SONG_EDITOR)
	MusicianTrackEditorHeaderTrackId:SetText(Musician.Msg.HEADER_NUMBER)
	MusicianTrackEditorHeaderMute:SetText(Musician.Icons.Mute)
	MusicianTrackEditorHeaderSolo:SetText(Musician.Icons.Solo)
	MusicianTrackEditorHeaderAccent:SetText(Musician.Msg.HEADER_ACCENT)
	MusicianTrackEditorHeaderTranspose:SetText(Musician.Msg.HEADER_OCTAVE)
	MusicianTrackEditorHeaderInstrument:SetText(Musician.Msg.HEADER_INSTRUMENT)

	-- Resize button
	local resizeButton = MusicianTrackEditorResizeButton
	for _, texture in ipairs({ resizeButton:GetNormalTexture(), resizeButton:GetHighlightTexture(),
		resizeButton:GetPushedTexture() }) do
		texture:ClearAllPoints()
		texture:SetPoint("TOPLEFT", -10, 10)
		texture:SetSize(20, 20)
	end
	resizeButton.frameLevel = MusicianTrackEditorScrollFrame:GetFrameLevel() + 100
	resizeButton:SetFrameLevel(resizeButton.frameLevel)
	resizeButton:SetScript("OnMouseDown", function(self)
		self:SetButtonState("PUSHED", true)
		self:GetHighlightTexture():Hide()
		MusicianTrackEditor:StartSizing("BOTTOMRIGHT")
	end)
	resizeButton:SetScript("OnMouseUp", function(self)
		self:SetButtonState("NORMAL", false)
		self:GetHighlightTexture():Show()
		MusicianTrackEditor:StopMovingOrSizing()
	end)

	-- Scroll frame

	-- Fix precision issues with the scrollbar track thumb size
	local scrollBarSetVisibleExtentPercentage = MusicianTrackEditorScrollFrame.ScrollBar.SetVisibleExtentPercentage
	MusicianTrackEditorScrollFrame.ScrollBar.SetVisibleExtentPercentage = function(self, visibleExtentPercentage)
		scrollBarSetVisibleExtentPercentage(self, floor(visibleExtentPercentage * 100000 + .5) / 100000)
	end

	-- Put the tracks container on top of the background artwork
	MusicianTrackEditorTracksContainer:SetFrameLevel(MusicianTrackEditorBackground:GetFrameLevel() + 1)

	-- Synchronize scroll child
	MusicianTrackEditorScrollFrame:HookScript("OnSizeChanged", function(self)
		MusicianTrackEditorScrollFrameContentPlaceholder:SetWidth(self:GetWidth())
	end)

	-- WoW Classic still uses the old school scrollbars, adjust anchors accordingly
	if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE then
		MusicianTrackEditorTracksContainer:SetPoint("BOTTOMRIGHT", MusicianTrackEditorScrollFrame, "BOTTOMRIGHT", 0, -2)
	end

	-- Slider
	MusicianTrackEditorSourceSongSlider:SetScript("OnMouseDown", function(self)
		self.dragging = true
	end)
	MusicianTrackEditorSourceSongSlider:SetScript("OnMouseUp", function(self)
		self.dragging = false
		if Musician.sourceSong then
			Musician.sourceSong:Seek(self:GetValue() - .001)
		end
	end)

	-- Play button
	MusicianTrackEditorPlayButton:SetScript("OnClick", function()
		if Musician.sourceSong:IsPlaying() then
			Musician.sourceSong:Stop()
		else
			if Musician.sourceSong.cursor >= Musician.sourceSong.cropTo then
				Musician.sourceSong:Seek(Musician.sourceSong.cropFrom)
			end
			Musician.sourceSong:Resume()
		end
	end)

	-- Previous button
	MusicianTrackEditorPrevButton:SetText(Musician.Icons.FastBw)
	MusicianTrackEditorPrevButton.tooltipText = Musician.Msg.JUMP_PREV
	MusicianTrackEditorPrevButton:SetScript("OnClick", function()
		Musician.sourceSong:Seek(max(Musician.sourceSong.cropFrom, Musician.sourceSong.cursor - 10))
	end)

	-- Next button
	MusicianTrackEditorNextButton:SetText(Musician.Icons.FastFw)
	MusicianTrackEditorNextButton.tooltipText = Musician.Msg.JUMP_NEXT
	MusicianTrackEditorNextButton:SetScript("OnClick", function()
		Musician.sourceSong:Seek(min(Musician.sourceSong.cropTo, Musician.sourceSong.cursor + 10))
	end)

	-- Go to start button
	MusicianTrackEditorGoToStartButton:SetText(Musician.Icons.ToStart)
	MusicianTrackEditorGoToStartButton.tooltipText = Musician.Msg.GO_TO_START
	MusicianTrackEditorGoToStartButton:SetScript("OnClick", function()
		Musician.sourceSong:Seek(Musician.sourceSong.cropFrom)
	end)

	-- Go to end button
	MusicianTrackEditorGoToEndButton:SetText(Musician.Icons.ToEnd)
	MusicianTrackEditorGoToEndButton.tooltipText = Musician.Msg.GO_TO_END
	MusicianTrackEditorGoToEndButton:SetScript("OnClick", function()
		Musician.sourceSong:Seek(Musician.sourceSong.cropTo)
	end)

	-- Crop from button
	MusicianTrackEditorSetCropFromButton:SetText(Musician.Icons.InPoint)
	MusicianTrackEditorSetCropFromButton.tooltipText = Musician.Msg.SET_CROP_FROM
	MusicianTrackEditorSetCropFromButton:SetScript("OnClick", function()
		Musician.TrackEditor.SetCropFrom(Musician.sourceSong.cursor)
	end)

	-- Crop to button
	MusicianTrackEditorSetCropToButton.tooltipText = Musician.Msg.SET_CROP_TO
	MusicianTrackEditorSetCropToButton:SetText(Musician.Icons.OutPoint)
	MusicianTrackEditorSetCropToButton:SetScript("OnClick", function()
		Musician.TrackEditor.SetCropTo(Musician.sourceSong.cursor)
	end)

	-- Sync button
	MusicianTrackEditorSynchronizeButton:SetText(Musician.Icons.Reset)
	MusicianTrackEditorSynchronizeButton.tooltipText = Musician.Msg.SYNCHRONIZE_TRACKS
	Musician.TrackEditor.UpdateSyncButton()
	MusicianTrackEditorSynchronizeButton:SetScript("OnClick", Musician.TrackEditor.Synchronize)

	-- Crop from edit box
	MusicianTrackEditorCropFromTitle:SetText(Musician.Msg.MARKER_FROM)
	MusicianTrackEditorCropFromTitle:SetJustifyH('LEFT')
	MusicianTrackEditorCropFrom.tooltipText = Musician.Msg.SET_CROP_FROM
	MusicianTrackEditorCropFrom:SetScript("OnEditFocusLost", function(self)
		Musician.TrackEditor.SetCropFrom(Musician.Utils.ParseTime(self:GetText()))
	end)

	-- Crop to edit box
	MusicianTrackEditorCropToTitle:SetText(Musician.Msg.MARKER_TO)
	MusicianTrackEditorCropToTitle:SetJustifyH('RIGHT')
	MusicianTrackEditorCropTo.tooltipText = Musician.Msg.SET_CROP_TO
	MusicianTrackEditorCropTo:SetScript("OnEditFocusLost", function(self)
		local cropTo = Musician.Utils.ParseTime(self:GetText())
		if cropTo == 0 then
			Musician.TrackEditor.SetCropTo(Musician.sourceSong.duration)
		else
			Musician.TrackEditor.SetCropTo(cropTo)
		end
	end)

	-- Cursor position edit box
	MusicianTrackEditorCursorAt:SetScript("OnEditFocusLost", function(self)
		local cursor = Musician.Utils.ParseTime(self:GetText())
		cursor = max(Musician.sourceSong.cropFrom, min(cursor, Musician.sourceSong.cropTo))
		self:SetText(Musician.Utils.FormatTime(cursor))
		Musician.sourceSong:Seek(cursor)
	end)
end

--- Song loaded handler
--
function Musician.TrackEditor.OnLoad()
	Musician.TrackEditor.UpdateSlider()
	Musician.TrackEditor.UpdateButtons(nil, Musician.sourceSong)
	Musician.TrackEditor.UpdateBounds()
	Musician.TrackEditor.UpdateCursor(nil, Musician.sourceSong)

	-- Get tracks
	local trackCount = #Musician.sourceSong.tracks
	for trackIndex = 1, trackCount, 1 do
		Musician.TrackEditor.CreateTrackWidget(trackIndex)
	end

	-- Resize track container
	MusicianTrackEditorScrollFrameContentPlaceholder:SetHeight(32 * trackCount)
	MusicianTrackEditorTracksContainer:SetClipsChildren(true)
	MusicianTrackEditorScrollFrame:SetVerticalScroll(0)
	MusicianTrackEditorScrollFrame:UpdateScrollChildRect()

	-- Resize main window
	local headerHeight = 142
	local minRows = 4
	local maxRows = floor((UIParent:GetHeight() / MusicianTrackEditor:GetScale() - headerHeight) / 32)
	MusicianTrackEditor:SetHeight(headerHeight + 32 * min(maxRows, max(minRows, trackCount)))

	-- Hide unused tracks
	local trackIndex = trackCount + 1
	while _G['MusicianTrackEditorTrack' .. trackIndex] ~= nil do
		_G['MusicianTrackEditorTrack' .. trackIndex]:Hide()
		trackIndex = trackIndex + 1
	end

	-- Update synchronize button
	Musician.TrackEditor.UpdateSyncButton()
end

--- Update buttons when the song starts or stops playing
-- @param event (string)
-- @param song (Musician.Song)
function Musician.TrackEditor.UpdateButtons(event, song)
	if song == Musician.sourceSong then
		if song:IsPlaying() then
			MusicianTrackEditorPlayButton.tooltipText = Musician.Msg.PAUSE
			MusicianTrackEditorPlayButton:SetText(Musician.Icons.Pause)
		else
			MusicianTrackEditorPlayButton.tooltipText = Musician.Msg.PLAY
			MusicianTrackEditorPlayButton:SetText(Musician.Icons.Play)
		end
	end
end

--- Return true when the source song is currently streaming
-- @return (boolean)
local function isSourceSongStreaming()
	return Musician.streamingSong and Musician.streamingSong.streaming and Musician.sourceSong and
		Musician.sourceSong.crc32 == Musician.streamingSong.crc32
end

--- UpdateSyncButton
--
function Musician.TrackEditor.UpdateSyncButton()
	MusicianTrackEditorSynchronizeButton:SetEnabled(isSourceSongStreaming())
end

--- UpdateSlider
--
function Musician.TrackEditor.UpdateSlider()
	if MusicianTrackEditorSourceSongSliderLow then
		MusicianTrackEditorSourceSongSliderLow:SetText("")
		MusicianTrackEditorSourceSongSliderHigh:SetText("")
	end
	MusicianTrackEditorSourceSongSlider:SetMinMaxValues(Musician.sourceSong.cropFrom, Musician.sourceSong.cropTo)
	MusicianTrackEditorSourceSongSlider:SetValue(Musician.sourceSong.cursor)
end

--- Update cursor position
-- @param event (string)
-- @param song (Musician.Song)
function Musician.TrackEditor.UpdateCursor(event, song)
	if song == Musician.sourceSong then
		if not MusicianTrackEditorSourceSongSlider.dragging then
			local cursor = max(Musician.sourceSong.cropFrom, min(Musician.sourceSong.cropTo, Musician.sourceSong.cursor))
			MusicianTrackEditorSourceSongSlider:SetValue(cursor)
			if not MusicianTrackEditorCursorAt:HasFocus() then
				MusicianTrackEditorCursorAt:SetText(Musician.Utils.FormatTime(cursor))
			end
		else
			MusicianTrackEditorCursorAt:SetText(Musician.Utils.FormatTime(MusicianTrackEditorSourceSongSlider:GetValue()))
		end
	end
end

--- UpdateBounds
--
function Musician.TrackEditor.UpdateBounds()
	MusicianTrackEditorCropFrom:SetText(Musician.Utils.FormatTime(Musician.sourceSong.cropFrom))
	MusicianTrackEditorCropTo:SetText(Musician.Utils.FormatTime(Musician.sourceSong.cropTo))
end

--- Track widget factory
-- @param trackIndex (number)
function Musician.TrackEditor.CreateTrackWidget(trackIndex)
	local trackFrameName = 'MusicianTrackEditorTrack' .. trackIndex
	local trackFrame = _G[trackFrameName]
	local track = Musician.sourceSong.tracks[trackIndex]

	-- Create frame, init dropdowns, labels and checkboxes
	if trackFrame == nil then
		_G[trackFrameName] = CreateFrame("Frame", trackFrameName, MusicianTrackEditorTracksContainer, "MusicianTrackTemplate")
		trackFrame = _G[trackFrameName]
		local y = -trackFrame:GetHeight() * (trackIndex - 1)
		trackFrame:SetPoint("TOPLEFT", MusicianTrackEditorScrollFrameContentPlaceholder, "TOPLEFT", 1, y - 2)
		Musician.TrackEditor.InitTransposeDropdown(trackFrame.transposeDropdown, trackIndex)
		Musician.TrackEditor.InitInstrumentDropdown(trackFrame.instrumentDropdown, trackIndex)

		-- Track index
		trackFrame.idText:SetText(trackIndex)

		-- Mute
		trackFrame.muteCheckbox.tooltipText = Musician.Msg.MUTE_TRACK
		trackFrame.muteCheckbox:HookScript('OnClick', function(checkButton)
			Musician.sourceSong:SetTrackMuted(trackIndex, checkButton:GetChecked())
		end)

		-- Solo
		trackFrame.soloCheckbox.tooltipText = Musician.Msg.SOLO_TRACK
		trackFrame.soloCheckbox:HookScript('OnClick', function(checkButton)
			Musician.sourceSong:SetTrackSolo(trackIndex, checkButton:GetChecked())
		end)

		-- Accent
		trackFrame.accentCheckbox.tooltipText = Musician.Msg.ACCENT_TRACK
		trackFrame.accentCheckbox:HookScript('OnClick', function(checkButton)
			Musician.sourceSong:SetTrackAccent(trackIndex, checkButton:GetChecked())
		end)

		-- Meter
		trackFrame.meterTexture.maxWidth = trackFrame.meterTexture:GetWidth()
		trackFrame.meterTexture.volumeMeter = Musician.VolumeMeter.create()
	end

	-- Muted
	trackFrame.muteCheckbox:SetChecked(track.muted)

	-- Solo
	trackFrame.soloCheckbox:SetChecked(track.solo)

	-- Accent
	trackFrame.accentCheckbox:SetChecked(track.accent)

	-- Meter
	trackFrame.meterTexture:SetWidth(0)
	trackFrame.meterTexture:Hide()
	trackFrame.meterTexture.volumeMeter:Reset()

	-- Track name
	local trackName
	if track.name ~= nil and track.name ~= "" then
		trackName = track.name
	else
		trackName = string.gsub(Musician.Msg.TRACK_NUMBER, '{track}', trackIndex)
	end
	Musician.Utils.SetFontStringTextFixedSize(trackFrame.nameText, trackName)

	-- Track info (channel, instrument, duration and number of notes)
	local trackInfo = ''

	if track.channel ~= nil then
		trackInfo = string.gsub(Musician.Msg.CHANNEL_NUMBER_SHORT, '{channel}', track.channel) .. " "
	end

	trackInfo = trackInfo .. Musician.Sampler.GetLocalizedMIDIInstrumentName(track.midiInstrument)

	local noteCount = #track.notes
	if #track.notes > 0 then
		local firstNote = track.notes[1][NOTE.TIME]
		local lastNote = track.notes[noteCount][NOTE.TIME] + (track.notes[noteCount][NOTE.DURATION] or 0)
		trackInfo = trackInfo ..
			" [" .. Musician.Utils.GetLink('musician', Musician.Utils.FormatTime(firstNote, true), 'seek', firstNote)
		trackInfo = trackInfo ..
			" – " .. Musician.Utils.GetLink('musician', Musician.Utils.FormatTime(lastNote, true), 'seek', lastNote) .. "]"
	end
	trackInfo = trackInfo .. " (" .. noteCount .. ")"

	Musician.Utils.SetFontStringTextFixedSize(trackFrame.infoText, trackInfo)

	-- Transposition
	trackFrame.transposeDropdown.UpdateValue(track.transpose)

	-- Instrument
	trackFrame.instrumentDropdown.UpdateValue(track.instrument)

	trackFrame:Show()
end

--- Init track transpose dropdown
-- @param dropdown (MSA_DropDownMenu)
-- @param trackIndex (number)
function Musician.TrackEditor.InitTransposeDropdown(dropdown, trackIndex)

	local transposeValues = { "+2", "+1", "0", "-1", "-2" }

	dropdown.index = nil
	dropdown.trackIndex = trackIndex
	dropdown.tooltipText = Musician.Msg.TRANSPOSE_TRACK

	dropdown.SetValue = function(value)
		dropdown.UpdateValue(value)
		Musician.sourceSong:SetTrackTranspose(dropdown.trackIndex, dropdown.value)
	end

	dropdown.SetIndex = function(index)
		dropdown.UpdateValue((-index + 3) * 12)
		Musician.sourceSong:SetTrackTranspose(dropdown.trackIndex, dropdown.value)
	end

	dropdown.UpdateValue = function(value)
		dropdown.index = 3 - floor(value / 12)
		dropdown.value = value
		MSA_DropDownMenu_SetText(dropdown, transposeValues[dropdown.index])
	end

	dropdown.OnClick = function(self, arg1)
		dropdown.SetIndex(arg1)
	end

	dropdown.GetItems = function(frame)
		local info = MSA_DropDownMenu_CreateInfo()
		info.func = dropdown.OnClick

		for index, label in pairs(transposeValues) do
			info.text = label
			info.arg1 = index
			info.checked = dropdown.index == index
			MSA_DropDownMenu_AddButton(info)
		end
	end

	MSA_DropDownMenu_Initialize(dropdown, dropdown.GetItems)
	dropdown.SetValue(Musician.sourceSong.tracks[trackIndex].transpose)
end

--- Init track instrument dropdown
-- @param dropdown (MSA_DropDownMenu)
-- @param trackIndex (number)
function Musician.TrackEditor.InitInstrumentDropdown(dropdown, trackIndex)
	dropdown.trackIndex = trackIndex
	dropdown.tooltipText = Musician.Msg.CHANGE_TRACK_INSTRUMENT
	dropdown.OnChange = function(midiId)
		Musician.sourceSong:SetTrackInstrument(dropdown.trackIndex, midiId)
	end

	-- Change track row color
	hooksecurefunc(dropdown, "UpdateValue", function(value)
		local trackFrame = dropdown:GetParent()
		local instrumentName = Musician.Sampler.GetInstrumentName(value)
		if Musician.INSTRUMENTS[instrumentName].color ~= nil then
			local r, g, b = unpack(Musician.INSTRUMENTS[instrumentName].color)
			trackFrame.nameText:SetTextColor(r, g, b)
			trackFrame.infoText:SetTextColor(r, g, b)
			trackFrame.idText:SetTextColor(r, g, b)
		end
	end)
end

--- Get track frame for source song track
-- @param song (Musician.Song)
-- @param track (table) Track object of the song
-- @return trackFrame (Frame)
function Musician.TrackEditor.GetTrackFrame(song, track)
	if song ~= Musician.sourceSong then return nil end
	return _G['MusicianTrackEditorTrack' .. track.index]
end

--- Handle track instruent change
-- @param event (string)
-- @param song (Musician.Song)
-- @param track (table) Track object of the song
-- @param midiId (number) MIDI id of the instrument
function Musician.TrackEditor.OnInstrumentChange(event, song, track, midiId)
	local trackFrame = Musician.TrackEditor.GetTrackFrame(song, track)
	if trackFrame then
		trackFrame.instrumentDropdown.UpdateValue(midiId)
	end
end

--- Handle track transpose change
-- @param event (string)
-- @param song (Musician.Song)
-- @param track (table) Track object of the song
-- @param semitones (number) Transpose level, in semitones
function Musician.TrackEditor.OnTransposeChange(event, song, track, semitones)
	local trackFrame = Musician.TrackEditor.GetTrackFrame(song, track)
	if trackFrame then
		trackFrame.transposeDropdown.UpdateValue(semitones)
	end
end

--- Handle track muted change
-- @param event (string)
-- @param song (Musician.Song)
-- @param track (table) Track object of the song
-- @param isMuted (boolean) Muted flag
function Musician.TrackEditor.OnMutedChange(event, song, track, isMuted)
	local trackFrame = Musician.TrackEditor.GetTrackFrame(song, track)
	if trackFrame then
		trackFrame.muteCheckbox:SetChecked(isMuted)
	end
end

--- Handle track solo change
-- @param event (string)
-- @param song (Musician.Song)
-- @param track (table) Track object of the song
-- @param isSolo (boolean) Solo flag
function Musician.TrackEditor.OnSoloChange(event, song, track, isSolo)
	local trackFrame = Musician.TrackEditor.GetTrackFrame(song, track)
	if trackFrame then
		trackFrame.soloCheckbox:SetChecked(isSolo)
	end
end

--- Handle track accent change
-- @param event (string)
-- @param song (Musician.Song)
-- @param track (table) Track object of the song
-- @param isAccent (boolean) Accent flag
function Musician.TrackEditor.OnAccentChange(event, song, track, isAccent)
	local trackFrame = Musician.TrackEditor.GetTrackFrame(song, track)
	if trackFrame then
		trackFrame.accentCheckbox:SetChecked(isAccent)
	end
end

--- Set crop start position
-- @param position (number)
function Musician.TrackEditor.SetCropFrom(position)
	Musician.sourceSong:SetCropFrom(floor(position * 100) / 100)
end

--- Set crop end position
-- @param position (number)
function Musician.TrackEditor.SetCropTo(position)
	Musician.sourceSong:SetCropTo(ceil(position * 100) / 100)
end

--- Handle song crop from or crop to change
-- @param event (string)
-- @param song (Musician.Song)
function Musician.TrackEditor.OnCropChange(event, song)
	if song == Musician.sourceSong then
		Musician.TrackEditor.UpdateSlider()
		Musician.TrackEditor.UpdateBounds()
	end
end

--- Synchronize track settings with currently streaming song
--
function Musician.TrackEditor.Synchronize()
	if not isSourceSongStreaming() then return end

	for trackIndex, sourceTrack in pairs(Musician.sourceSong.tracks) do
		Musician.streamingSong:SetTrackInstrument(trackIndex, sourceTrack.instrument)
		Musician.streamingSong:SetTrackTranspose(trackIndex, sourceTrack.transpose)
		Musician.streamingSong:SetTrackMuted(trackIndex, sourceTrack.muted)
		Musician.streamingSong:SetTrackSolo(trackIndex, sourceTrack.solo)
		Musician.streamingSong:SetTrackAccent(trackIndex, sourceTrack.accent)
	end
end

--- OnUpdate
--
function Musician.TrackEditor.OnUpdate(event, elapsed)
	if Musician.sourceSong then
		-- Update track activity meters
		for _, track in pairs(Musician.sourceSong.tracks) do
			local meterTexture = _G['MusicianTrackEditorTrack' .. track.index].meterTexture
			meterTexture.volumeMeter:AddElapsed(elapsed)

			local width = meterTexture.volumeMeter:GetLevel() * meterTexture.maxWidth
			meterTexture:SetWidth(width)

			if not track.audible then
				meterTexture:SetAlpha(.25)
			else
				meterTexture:SetAlpha(1)
			end

			if width > 0 then
				meterTexture:Show()
			else
				meterTexture:Hide()
			end

		end
	end
end

--- NoteOn handler
-- @param event (string)
-- @param song (Musician.Song)
-- @param track (table)
-- @param key (number)
function Musician.TrackEditor.NoteOn(event, song, track, key)
	if song == Musician.sourceSong then
		local meter = _G['MusicianTrackEditorTrack' .. track.index]
		if not meter then return end
		local meterTexture = meter.meterTexture
		local _, instrumentData = Musician.Sampler.GetSoundFile(track.instrument, key)
		if instrumentData ~= nil then
			meterTexture.volumeMeter:NoteOn(instrumentData, key)
			meterTexture:Show()
		end
	end
end

--- NoteOff handler
-- @param event (string)
-- @param song (Musician.Song)
-- @param track (table)
function Musician.TrackEditor.NoteOff(event, song, track)
	if song == Musician.sourceSong then
		-- Stop if all notes of the track are off
		if track.polyphony == 0 then
			local meter = _G['MusicianTrackEditorTrack' .. track.index]
			if not meter then return end
			local meterTexture = meter.meterTexture
			meterTexture.volumeMeter:NoteOff()
		end
	end
end

--- Time edit box template OnLoad
--
function MusicianTimeEditBoxTemplate_OnLoad(self)
	self:HookScript("OnEscapePressed", function()
		self:ClearFocus()
	end)
	self:HookScript("OnKeyUp", function(_, key)
		if key == "ENTER" then
			self:ClearFocus()
		end
	end)
end

--- Track template OnLoad
--
function MusicianTrackTemplate_OnLoad(self)
	MSA_DropDownMenu_SetWidth(self.transposeDropdown, 40)
	Musician.EnableHyperlinks(self)
end