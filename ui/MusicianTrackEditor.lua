Musician.TrackEditor = LibStub("AceAddon-3.0"):NewAddon("Musician.TrackEditor", "AceEvent-3.0")

Musician.TrackEditor.MAX_NOTE_DURATION = 6

local NOTE = Musician.Song.Indexes.NOTE
local NOTEON = Musician.Song.Indexes.NOTEON

--- Init
--
Musician.TrackEditor.Init = function()

	MusicianTrackEditor:SetClampedToScreen(true)

	-- Init texts
	Musician.TrackEditor:RegisterMessage(Musician.Events.SongCursor, Musician.TrackEditor.UpdateCursor)
	Musician.TrackEditor:RegisterMessage(Musician.Events.SongPlay, Musician.TrackEditor.UpdateButtons)
	Musician.TrackEditor:RegisterMessage(Musician.Events.SongStop, Musician.TrackEditor.UpdateButtons)

	MusicianTrackEditorTitle:SetText(Musician.Msg.SONG_EDITOR)
	MusicianTrackEditorHeaderTrackId:SetText(Musician.Msg.HEADER_NUMBER)
	MusicianTrackEditorHeaderInstrument:SetText(Musician.Msg.HEADER_INSTRUMENT)
	MusicianTrackEditorHeaderTranspose:SetText(Musician.Msg.HEADER_OCTAVE)

	MusicianTrackEditorCropFromTitle:SetText(Musician.Msg.MARKER_FROM)
	MusicianTrackEditorCropFrom.tooltipText = Musician.Msg.SET_CROP_FROM
	MusicianTrackEditorCropToTitle:SetText(Musician.Msg.MARKER_TO)
	MusicianTrackEditorCropTo.tooltipText = Musician.Msg.SET_CROP_TO

	MusicianTrackEditorPrevButton.tooltipText = Musician.Msg.JUMP_PREV
	MusicianTrackEditorNextButton.tooltipText = Musician.Msg.JUMP_NEXT
	MusicianTrackEditorGoToStartButton.tooltipText = Musician.Msg.GO_TO_START
	MusicianTrackEditorGoToEndButton.tooltipText = Musician.Msg.GO_TO_END
	MusicianTrackEditorSetCropFromButton.tooltipText = Musician.Msg.SET_CROP_FROM
	MusicianTrackEditorSetCropToButton.tooltipText = Musician.Msg.SET_CROP_TO

	MusicianTrackEditorCropFrom:SetScript("OnEditFocusLost", function(self)
		Musician.TrackEditor.SetCropFrom(Musician.Utils.ParseTime(self:GetText()))
	end)

	MusicianTrackEditorCropTo:SetScript("OnEditFocusLost", function(self)
		local cropTo = Musician.Utils.ParseTime(self:GetText())
		if cropTo == 0 then
			Musician.TrackEditor.SetCropTo(Musician.sourceSong.duration)
		else
			Musician.TrackEditor.SetCropTo(cropTo)
		end
	end)

	MusicianTrackEditorCursorAt:SetScript("OnEditFocusLost", function(self)
		Musician.sourceSong:Seek(Musician.Utils.ParseTime(self:GetText()))
	end)

	Musician.TrackEditor:RegisterMessage(Musician.Events.Frame, Musician.TrackEditor.OnUpdate)
	Musician.TrackEditor:RegisterMessage(Musician.Events.NoteOn, Musician.TrackEditor.NoteOn)
	Musician.TrackEditor:RegisterMessage(Musician.Events.NoteOff, Musician.TrackEditor.NoteOff)
	Musician.TrackEditor:RegisterMessage(Musician.Events.SourceSongLoaded, Musician.TrackEditor.OnLoad)
end

--- Song loaded handler
--
Musician.TrackEditor.OnLoad = function()
	Musician.TrackEditor.UpdateSlider()
	Musician.TrackEditor.UpdateButtons(nil, Musician.sourceSong)
	Musician.TrackEditor.UpdateBounds()
	Musician.TrackEditor.UpdateCursor(nil, Musician.sourceSong)

	-- Get tracks
	local trackCount = #Musician.sourceSong.tracks
	local trackIndex
	for trackIndex = 1, trackCount, 1 do
		Musician.TrackEditor.CreateTrackWidget(trackIndex)
	end
	MusicianTrackEditorTrackContainer:SetHeight(32 * trackCount)

	-- Hide unused tracks
	trackIndex = trackCount + 1
	while _G['MusicianTrackEditorTrack' .. trackIndex] ~= nil do
		_G['MusicianTrackEditorTrack' .. trackIndex]:Hide()
		trackIndex = trackIndex + 1
	end
end

--- Update buttons when the song starts or stops playing
-- @param event (string)
-- @param song (Musician.Song)
Musician.TrackEditor.UpdateButtons = function(event, song)
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

--- UpdateSlider
--
Musician.TrackEditor.UpdateSlider = function()
	MusicianTrackEditorSourceSongSliderLow:SetText("")
	MusicianTrackEditorSourceSongSliderHigh:SetText("")
	MusicianTrackEditorSourceSongSlider:SetMinMaxValues(Musician.sourceSong.cropFrom, Musician.sourceSong.cropTo)
	MusicianTrackEditorSourceSongSlider:SetValue(Musician.sourceSong.cursor)
end

--- Update cursor position
-- @param event (string)
-- @param song (Musician.Song)
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

--- UpdateBounds
--
Musician.TrackEditor.UpdateBounds = function()
	MusicianTrackEditorCropFrom:SetText(Musician.Utils.FormatTime(Musician.sourceSong.cropFrom))
	MusicianTrackEditorCropTo:SetText(Musician.Utils.FormatTime(Musician.sourceSong.cropTo))
end

--- Track widget factory
-- @param trackIndex (number)
Musician.TrackEditor.CreateTrackWidget = function(trackIndex)
	local trackFrameName = 'MusicianTrackEditorTrack' .. trackIndex
	local transposeDropdownName = trackFrameName .. 'TransposeDropdown'
	local instrumentDropdownName = trackFrameName .. 'InstrumentDropdown'

	-- Create frame, init dropdowns, labels and checkboxes
	if _G[trackFrameName] == nil then
		_G[trackFrameName] = CreateFrame("Frame", trackFrameName, MusicianTrackEditorTrackContainer, "MusicianTrackTemplate")
		_G[trackFrameName]:SetPoint("TOPLEFT", 0, -_G[trackFrameName]:GetHeight() * (trackIndex - 1))
		Musician.TrackEditor.InitTransposeDropdown(_G[transposeDropdownName], trackIndex)
		Musician.TrackEditor.InitInstrumentDropdown(_G[instrumentDropdownName], trackIndex)

		-- Track index
		_G[trackFrameName .. 'TrackId']:SetText(trackIndex)

		-- Mute
		_G[trackFrameName .. 'Mute'].tooltipText = Musician.Msg.MUTE_TRACK
		_G[trackFrameName .. 'Mute'].SetValue = function(self, setting)
			Musician.sourceSong:SetTrackMuted(Musician.sourceSong.tracks[trackIndex], setting == "1")
		end

		-- Solo
		_G[trackFrameName .. 'Solo'].tooltipText = Musician.Msg.SOLO_TRACK
		_G[trackFrameName .. 'Solo'].SetValue = function(self, setting)
			Musician.sourceSong:SetTrackSolo(Musician.sourceSong.tracks[trackIndex], setting == "1")
		end

		-- Meter
		_G[trackFrameName .. 'Meter'].maxWidth = _G[trackFrameName .. 'Meter']:GetWidth()
		_G[trackFrameName .. 'Meter'].volumeMeter = Musician.VolumeMeter.create()
	end

	local track = Musician.sourceSong.tracks[trackIndex]

	-- Muted
	_G[trackFrameName .. 'Mute']:SetChecked(track.muted)

	-- Solo
	_G[trackFrameName .. 'Solo']:SetChecked(track.solo)

	-- Meter
	_G[trackFrameName .. 'Meter']:SetWidth(0)
	_G[trackFrameName .. 'Meter']:Hide()
	_G[trackFrameName .. 'Meter'].volumeMeter:Reset()

	-- Track name
	local trackName = ""
	if track.name ~= nil then
		trackName = track.name
	else
		trackName = string.gsub(Musician.Msg.TRACK_NUMBER, '{track}', trackIndex)
	end

	_G[trackFrameName .. 'TrackName']:SetText(trackName)

	-- Track info (channel, instrument, duration and number of notes)
	local trackInfo = ''

	if track.channel ~= nil then
		trackInfo = string.gsub(Musician.Msg.CHANNEL_NUMBER_SHORT, '{channel}', track.channel) .. " "
	end

	trackInfo = trackInfo .. Musician.Msg.MIDI_INSTRUMENT_NAMES[track.midiInstrument]

	local noteCount = #track.notes
	if #track.notes > 0 then
		local firstNote = track.notes[1][NOTE.TIME]
		local lastNote = track.notes[noteCount][NOTE.TIME] + (track.notes[noteCount][NOTE.DURATION] or 0)
		trackInfo = trackInfo .. " [" .. Musician.Utils.GetLink('seek', Musician.Utils.FormatTime(firstNote, true), firstNote)
		trackInfo = trackInfo .. " – " .. Musician.Utils.GetLink('seek', Musician.Utils.FormatTime(lastNote, true), lastNote) .. "]"
	end
	trackInfo = trackInfo .. " (" .. noteCount .. ")"

	_G[trackFrameName .. 'TrackInfo']:SetText(trackInfo)

	-- Transposition
	_G[transposeDropdownName].SetValue(track.transpose)

	-- Instrument
	_G[instrumentDropdownName].SetValue(track.instrument)

	_G[trackFrameName]:Show()
end

--- Init track transpose dropdown
-- @param dropdown (UIDropDownMenu)
-- @param trackIndex (number)
Musician.TrackEditor.InitTransposeDropdown = function(dropdown, trackIndex)

	local transposeValues = {"+2", "+1", "0", "-1", "-2"}

	dropdown.index = nil
	dropdown.trackIndex = trackIndex
	dropdown.tooltipText = Musician.Msg.TRANSPOSE_TRACK

	dropdown.SetValue = function(value)
		dropdown.SetIndex(3 - floor(value / 12))
	end

	dropdown.SetIndex = function(index)
		dropdown.index = index
		Musician.sourceSong.tracks[dropdown.trackIndex].transpose = (-index + 3) * 12
		UIDropDownMenu_SetText(dropdown, transposeValues[index])
	end

	dropdown.OnClick = function(self, arg1, arg2, checked)
		dropdown.SetIndex(arg1)
	end

	dropdown.GetItems = function(frame, level, menuList)
		local info = UIDropDownMenu_CreateInfo()
		info.func = dropdown.OnClick

		local index, label
		for index, label in pairs(transposeValues) do
			info.text = label
			info.arg1 = index
			info.checked = dropdown.index == index
			UIDropDownMenu_AddButton(info)
		end
	end

	UIDropDownMenu_Initialize(dropdown, dropdown.GetItems)
	dropdown.SetValue(Musician.sourceSong.tracks[trackIndex].transpose)
end

--- Init track instrument dropdown
-- @param dropdown (UIDropDownMenu)
-- @param trackIndex (number)
Musician.TrackEditor.InitInstrumentDropdown = function(dropdown, trackIndex)
	dropdown.trackIndex = trackIndex
	dropdown.tooltipText = Musician.Msg.CHANGE_TRACK_INSTRUMENT

	dropdown.OnChange = function(midiId, instrumentId)
		Musician.sourceSong.tracks[dropdown.trackIndex].instrument = midiId

		if Musician.INSTRUMENTS[instrumentId].color ~= nil then
			local r, g, b = unpack(Musician.INSTRUMENTS[instrumentId].color)
			local trackFrameName = 'MusicianTrackEditorTrack' .. trackIndex
			_G[trackFrameName .. 'TrackName']:SetTextColor(r, g, b)
			_G[trackFrameName .. 'TrackInfo']:SetTextColor(r, g, b)
			_G[trackFrameName .. 'TrackId']:SetTextColor(r, g, b)
		end
	end
end

--- Set crop start position
-- @param position (number)
Musician.TrackEditor.SetCropFrom = function(position)
	if position < Musician.sourceSong.cropTo then
		Musician.sourceSong.cropFrom = position
	end

	if Musician.sourceSong.cursor < position then
		Musician.sourceSong:Seek(position)
	end

	Musician.TrackEditor.UpdateSlider()
	Musician.TrackEditor.UpdateBounds()
end


--- Set crop end position
-- @param position (number)
Musician.TrackEditor.SetCropTo = function(position)
	if position > Musician.sourceSong.cropFrom then
		Musician.sourceSong.cropTo = position
	end

	if Musician.sourceSong.cursor > position then
		Musician.sourceSong:Seek(position)
	end

	Musician.TrackEditor.UpdateSlider()
	Musician.TrackEditor.UpdateBounds()
end

--- OnUpdate
--
Musician.TrackEditor.OnUpdate = function(event, elapsed)
	if Musician.sourceSong then
		local track
		-- Update track activity meters
		for _, track in pairs(Musician.sourceSong.tracks) do
			local meter = _G['MusicianTrackEditorTrack' .. track.index .. 'Meter']
			meter.volumeMeter:AddElapsed(elapsed)

			local width = meter.volumeMeter:GetLevel() * meter.maxWidth
			meter:SetWidth(width)

			if width > 0 then
				meter:Show()
			else
				meter:Hide()
			end

		end
	end
end

--- NoteOn handler
-- @param event (string)
-- @param song (Musician.Song)
-- @param track (table)
-- @param key (number)
Musician.TrackEditor.NoteOn = function(event, song, track, key)
	if song == Musician.sourceSong then
		local meter = _G['MusicianTrackEditorTrack' .. track.index .. 'Meter']
		local _, instrumentData = Musician.Utils.GetSoundFile(track.instrument, key)
		meter.volumeMeter:NoteOn(instrumentData)
		meter:Show()
	end
end

--- NoteOff handler
-- @param event (string)
-- @param song (Musician.Song)
-- @param track (table)
-- @param key (number)
Musician.TrackEditor.NoteOff = function(event, song, track, key)
	if song == Musician.sourceSong then
		-- Stop if all notes of the track are off
		if track.polyphony == 0 then
			local meter = _G['MusicianTrackEditorTrack' .. track.index .. 'Meter']
			meter.volumeMeter:NoteOff()
		end
	end
end
