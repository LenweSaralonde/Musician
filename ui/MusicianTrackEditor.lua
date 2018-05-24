Musician.TrackEditor = LibStub("AceAddon-3.0"):NewAddon("Musician.TrackEditor", "AceEvent-3.0")

Musician.TrackEditor.PAUSE_ICON = 'p'
Musician.TrackEditor.PLAY_ICON = 'P'

Musician.TrackEditor.Init = function()

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

	MusicianTrackEditor:SetScript("OnUpdate", Musician.TrackEditor.OnUpdate)
	Musician.TrackEditor:RegisterMessage(Musician.Events.NoteOn, Musician.TrackEditor.NoteOn)
	Musician.TrackEditor:RegisterMessage(Musician.Events.NoteOff, Musician.TrackEditor.NoteOff)
end

Musician.TrackEditor.OnLoad = function()
	Musician.TrackEditor.UpdateSlider()
	Musician.TrackEditor.UpdateButtons()
	Musician.TrackEditor.UpdateBounds()
	Musician.TrackEditor.UpdateCursor(nil, Musician.sourceSong)

	-- Get tracks
	local trackCount = table.getn(Musician.sourceSong.tracks)
	local trackIndex
	for trackIndex = 1, trackCount, 1 do
		Musician.TrackEditor.GetTrackWidget(trackIndex)
	end
	MusicianTrackEditorTrackContainer:SetHeight(32 * trackCount)

	-- Hide unused tracks
	trackIndex = trackCount + 1
	while _G['MusicianTrackEditorTrack' .. trackIndex] ~= nil do
		_G['MusicianTrackEditorTrack' .. trackIndex]:Hide()
		trackIndex = trackIndex + 1
	end
end

Musician.TrackEditor.UpdateButtons = function()
	if Musician.sourceSong:IsPlaying() then
		MusicianTrackEditorPlayButton.tooltipText = Musician.Msg.PAUSE
		MusicianTrackEditorPlayButton:SetText(Musician.TrackEditor.PAUSE_ICON)
	else
		MusicianTrackEditorPlayButton.tooltipText = Musician.Msg.PLAY
		MusicianTrackEditorPlayButton:SetText(Musician.TrackEditor.PLAY_ICON)
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

Musician.TrackEditor.GetTrackWidget = function(trackIndex)
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
		_G[trackFrameName .. 'Mute'].setFunc = function(setting)
			Musician.sourceSong:SetTrackMuted(Musician.sourceSong.tracks[trackIndex], setting == "1")
		end

		-- Solo
		_G[trackFrameName .. 'Solo'].tooltipText = Musician.Msg.SOLO_TRACK
		_G[trackFrameName .. 'Solo'].setFunc = function(setting)
			Musician.sourceSong:SetTrackSolo(Musician.sourceSong.tracks[trackIndex], setting == "1")
		end

		-- Meter
		_G[trackFrameName .. 'Meter'].maxWidth = _G[trackFrameName .. 'Meter']:GetWidth()
		_G[trackFrameName .. 'Meter'].decay = nil
		_G[trackFrameName .. 'Meter'].time = nil
	end

	local track = Musician.sourceSong.tracks[trackIndex]

	-- Muted
	_G[trackFrameName .. 'Mute']:SetChecked(track.muted)

	-- Solo
	_G[trackFrameName .. 'Solo']:SetChecked(track.solo)

	-- Meter
	_G[trackFrameName .. 'Meter']:SetWidth(0)
	_G[trackFrameName .. 'Meter']:Hide()

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

	local noteCount = table.getn(track.notes)
	if table.getn(track.notes) > 0 then
		local firstNote = track.notes[1][2]
		local lastNote = track.notes[noteCount][2] + track.notes[noteCount][3]
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

Musician.TrackEditor.InitInstrumentDropdown = function(dropdown, trackIndex)
	dropdown.value = nil
	dropdown.trackIndex = trackIndex
	dropdown.tooltipText = Musician.Msg.CHANGE_TRACK_INSTRUMENT

	dropdown.SetValue = function(value)
		local originalMidiId = value
		local instrumentId = Musician.MIDI_INSTRUMENT_MAPPING[originalMidiId]
		local midiId = Musician.INSTRUMENTS[instrumentId].midi
		local instrumentName = Musician.Locale.fr.INSTRUMENT_NAMES[instrumentId]
		dropdown.value = midiId
		Musician.sourceSong.tracks[dropdown.trackIndex].instrument = midiId
		UIDropDownMenu_SetText(dropdown, instrumentName)
	end

	dropdown.OnClick = function(self, arg1, arg2, checked)
		dropdown.SetValue(arg1)
	end

	dropdown.GetItems = function(frame, level, menuList)
		local info = UIDropDownMenu_CreateInfo()
		info.func = dropdown.OnClick

		local instrumentId
		for _, instrumentId in pairs(Musician.INSTRUMENTS_AVAILABLE) do
			local midiId = Musician.INSTRUMENTS[instrumentId].midi
			info.text = Musician.Locale.fr.INSTRUMENT_NAMES[instrumentId]
			info.arg1 = midiId
			info.checked = dropdown.value == midiId
			UIDropDownMenu_AddButton(info)
		end
	end

	UIDropDownMenu_Initialize(dropdown, dropdown.GetItems)
	dropdown.SetValue(Musician.sourceSong.tracks[trackIndex].instrument)
end

Musician.TrackEditor.SetCropFrom = function(position)
	if position < Musician.sourceSong.cropTo then
		Musician.sourceSong.cropFrom = position
	end
	Musician.TrackEditor.UpdateSlider()
	Musician.TrackEditor.UpdateBounds()
end

Musician.TrackEditor.OnUpdate = function(self, elapsed)
	local attack = .2
	local maxLength = 6

	if Musician.sourceSong then
		local track
		-- Update track activity meters
		for _, track in pairs(Musician.sourceSong.tracks) do
			local meter = _G['MusicianTrackEditorTrack' .. track.index .. 'Meter']

			if meter.time ~= nil then
				meter.cursor = meter.cursor + elapsed

				if meter.cursor > meter.endTime then -- Decay phase
					local decayProgression = (meter.decay - (meter.cursor - meter.endTime)) / meter.decay
					local level = max(0, meter.sustainLevel * decayProgression)
					meter:SetWidth(level * meter.maxWidth)

					if level <= 0 then
						meter:Hide()
						meter.time = nil
					end

				elseif meter.cursor - meter.time <= attack then -- Attack phase
					local attackProgression = (attack - (meter.cursor - meter.time)) / attack
					local level = meter.sustainLevel + attackProgression * (1 - meter.sustainLevel)
					meter:SetWidth(level * meter.maxWidth)

				else -- Sustain phase
					level = meter.sustainLevel + (.05 - random() * .1)
					meter:SetWidth(level * meter.maxWidth)

				end

			end
		end
	end
end

Musician.TrackEditor.SetCropTo = function(position)
	if position > Musician.sourceSong.cropFrom then
		Musician.sourceSong.cropTo = position
	end
	Musician.TrackEditor.UpdateSlider()
	Musician.TrackEditor.UpdateBounds()
end

Musician.TrackEditor.NoteOn = function(self, song, track, noteIndex, endTime, decay)
	if song == Musician.sourceSong then
		local meter = _G['MusicianTrackEditorTrack' .. track.index .. 'Meter']
		local note = track.notes[noteIndex]
		local _, instrumentData = Musician.Utils.GetSoundFile(track.instrument, note[1] + track.transpose)
		meter:SetWidth(meter.maxWidth)
		meter.cursor = note[2]
		meter.time = note[2]

		if meter.endTime == nil then
			meter.endTime = meter.time
		end

		if instrumentData.isPlucked or instrumentData.isPercussion then
			meter.endTime = max(meter.endTime, min(meter.time + .2, endTime))
			meter.sustainLevel = .5
			meter.decay = 5
		else
			meter.endTime = max(meter.endTime, endTime)
			meter.sustainLevel = .75
		end
		meter.decay = instrumentData.decay / 1000
		meter:Show()
	end
end

Musician.TrackEditor.NoteOff = function(self, song, track, noteIndex)
	if song == Musician.sourceSong then
		-- Stop if all notes of the track are off
		if track.polyphony == 0 then
			local note = track.notes[noteIndex]
			local _, instrumentData = Musician.Utils.GetSoundFile(track.instrument, note[1] + track.transpose)
			local meter = _G['MusicianTrackEditorTrack' .. track.index .. 'Meter']
			meter.cursor = meter.endTime
			meter.decay = instrumentData.decay / 1000
		end
	end
end
