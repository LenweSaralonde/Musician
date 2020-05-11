--- Live play module
-- @module Musician.Live

Musician.Live = LibStub("AceAddon-3.0"):NewAddon("Musician.Live", "AceComm-3.0", "AceEvent-3.0")

local MODULE_NAME = "Live"
Musician.AddModule(MODULE_NAME)

local STREAM_PADDING = 10 -- Number of seconds to wait before ending streaming without activity

local NOTEON = {}
NOTEON.HANDLE = 1
NOTEON.LAYER = 2
NOTEON.KEY = 3
NOTEON.INSTRUMENT = 4
NOTEON.IS_CHORD_NOTE = 5

local notesOn = {}
local sustainedNotes = {}
local songStartTime = nil
local isLiveEnabled = true

Musician.Live.event = {}
Musician.Live.event.note = "MusicianLNote6"
Musician.Live.event.bandSync = "MusicianLSync"
Musician.Live.event.bandSyncQuery = "MusicianLQuery"

local NOTE = Musician.Song.Indexes.NOTE
local CHUNK_DURATION = 1

local streamingStartTimer
local isPlayingLive = false
local isBandSyncMode = false
local playingLiveTimer
local syncedBandPlayers = {}
local syncedBandPlayers = {}
local bandSongs = {}
local bandNotesOn = {}

--- Print debug message
-- @param out (boolean) Outgoing message
-- @param event (string)
-- @param source (string)
-- @param message (string)
-- @param ... (string)
local function debug(out, event, source, message, ...)
	local prefix
	if out then
		prefix = "|cFFFF0000>>>>>|r"
	else
		prefix = "|cFF00FF00<<<<<|r"
	end

	if type(source) == "table" then
		source = table.concat(source, ":")
	end

	event = "|cFFFF8000" .. event .. "|r"
	source = "|cFF00FFFF" .. source .. "|r"

	Musician.Utils.Debug(MODULE_NAME, prefix, event, source, message, ...)
end

--- Create a live song for a player
-- @param player (string)
-- @return song (Musician.Song)
local function createLiveSong(player)
	local song = Musician.Song.create()
	song.mode = Musician.Song.MODE_LIVE
	song.chunkDuration = CHUNK_DURATION
	song.name = Musician.Msg.LIVE_SONG_NAME
	song.player = player
	song.liveTrackIndexes = {}
	song.cropTo = STREAM_PADDING
	song.duration = STREAM_PADDING
	song.isLiveSong = true
	return song
end

--- Get the live song for a player
-- @param player (string)
-- @return song (Musician.Song)
local function getLiveSongForPlayer(player)
	if bandSongs[player] ~= nil then return bandSongs[player] end
	local song = createLiveSong(player)
	bandSongs[player] = song
	return song
end

--- Get the live track for the given layer and instrument
--- The track is created if it doesn't exist
-- @param song (Musician.Song)
-- @param layer (int)
-- @param instrument (int)
-- @return track (table)
local function getLiveTrack(song, layer, instrument)
	local trackId = layer .. '-' .. instrument
	local trackIndex = song.liveTrackIndexes[trackId]

	-- Existing track
	if trackIndex ~= nil then
		return song.tracks[trackIndex]
	end

	-- Create new track
	trackIndex = #song.tracks + 1
	local track = {
		index = trackIndex,
		midiInstrument = instrument,
		instrument = instrument,
		notes = {},
		playIndex = 1,
		muted = false,
		solo = false,
		transpose = 0,
		notesOn = {},
		polyphony = 0
	}

	table.insert(song.tracks, track)
	song.liveTrackIndexes[trackId] = trackIndex

	return track
end

--- Send visual note on event
-- @param noteOn (boolean) Note on/off
-- @param key (int) MIDI key index
-- @param layer (int)
-- @param instrument (int)
-- @param player (string)
local function sendVisualNoteEvent(noteOn, key, layer, instrument, player)

	local song = getLiveSongForPlayer(player)
	local track = getLiveTrack(song, layer, instrument)

	-- Send visual note event
	if noteOn then
		Musician:SendMessage(Musician.Events.VisualNoteOn, song, track, key)
	else
		Musician:SendMessage(Musician.Events.VisualNoteOff, song, track, key)
	end
end

--- Init live mode
--
function Musician.Live.Init()
	local initialized = false
	Musician.Live:RegisterEvent("PLAYER_ENTERING_WORLD", function()
		if initialized then return end
		initialized = true
		Musician.Live.OnGroupJoined()
	end)

	Musician.Live:RegisterComm(Musician.Live.event.bandSync, Musician.Live.OnBandSync)
	Musician.Live:RegisterComm(Musician.Live.event.bandSyncQuery, Musician.Live.OnBandSyncQuery)
	Musician.Live:RegisterComm(Musician.Live.event.note, Musician.Live.OnLiveNote)
	Musician.Live:RegisterEvent("GROUP_JOINED", Musician.Live.OnGroupJoined)
	Musician.Live:RegisterEvent("GROUP_LEFT", Musician.Live.OnGroupLeft)
	Musician.Live:RegisterEvent("GROUP_ROSTER_UPDATE", Musician.Live.OnRosterUpdate)
end

--- Enable or disable live mode
-- @param enabled (boolean)
function Musician.Live.Enable(enabled)
	isLiveEnabled = enabled
end

--- Indicate whenever the live mode is enabled stream
-- @return isLiveEnabled (boolean)
function Musician.Live.IsEnabled()
	return isLiveEnabled
end

--- muteGameMusic
--
local function muteGameMusic()
	isPlayingLive = true
	Musician.Utils.MuteGameMusic()
	if playingLiveTimer then
		playingLiveTimer:Cancel()
	end
end

--- unmuteGameMusic
--
local function unmuteGameMusic()
	if playingLiveTimer then
		playingLiveTimer:Cancel()
	end
	playingLiveTimer = C_Timer.NewTimer(STREAM_PADDING, function()
		isPlayingLive = false
		Musician.Utils.MuteGameMusic()
		playingLiveTimer = nil
	end)
end

--- Indicate whenever the player is playing live, regardless if in solo or live mode
-- @return isPlayingLive (boolean)
function Musician.Live.IsPlayingLive()
	return isPlayingLive
end

--- Indicate whenever the live mode can stream
-- @return canStream (boolean)
function Musician.Live.CanStream()
	-- Communication not yet ready
	if not(Musician.Comm.CanPlay()) then
		return false
	end

	-- Actually streaming a song that is not a live song
	if Musician.streamingSong and Musician.streamingSong.streaming and Musician.streamingSong.mode ~= Musician.Song.MODE_LIVE then
		return false
	end

	return true
end

--- Create the live song for streaming, if needed
-- and assign it to Musician.streamingSong
function Musician.Live.CreateLiveSong()
	-- Live song already created
	if Musician.streamingSong and (Musician.streamingSong.streaming or streamingStartTimer) then
		return
	end

	-- Create song instance
	Musician.streamingSong = createLiveSong()

	-- Initialize start time
	songStartTime = GetTime()

	-- Start streaming!
	if streamingStartTimer then
		streamingStartTimer:Cancel()
	end

	streamingStartTimer = C_Timer.NewTimer(CHUNK_DURATION * 1.05, function()
		if Musician.streamingSong and not(Musician.streamingSong.streaming) and Musician.streamingSong.isLiveSong then
			Musician.streamingSong:Stream()
		end
		streamingStartTimer = nil
	end)
end

--- Send note
-- @param noteOn (boolean) Note on/off
-- @param key (int) MIDI key index
-- @param layer (int)
-- @param instrument (int)
function Musician.Live.InsertNote(noteOn, key, layer, instrument)

	-- Do nothing if live mode is not enabled or can't stream
	if not(Musician.Live.CanStream()) or not(Musician.Live.IsEnabled()) then
		return
	end

	Musician.Live.CreateLiveSong()

	-- Insert note in track
	local track = getLiveTrack(Musician.streamingSong, layer, instrument)
	local noteTime = GetTime() - songStartTime

	table.insert(track.notes, {
		[NOTE.ON] = noteOn,
		[NOTE.KEY] = key,
		[NOTE.TIME] = noteTime
	})

	-- Update song bounds
	Musician.streamingSong.cropTo = noteTime + STREAM_PADDING
	Musician.streamingSong.duration = noteTime + STREAM_PADDING

	-- Send visual note event
	if not(Musician.Live.IsBandSyncMode() and Musician.Live.IsEnabled()) then
		if noteOn then
			Musician.Live:SendMessage(Musician.Events.VisualNoteOn, Musician.streamingSong, track, key)
		else
			Musician.Live:SendMessage(Musician.Events.VisualNoteOff, Musician.streamingSong, track, key)
		end
	end
end

--- Set sustain state for the layer
-- @param enable (boolean)
-- @param layer (int)
function Musician.Live.SetSustain(enable, layer)
	if enable and sustainedNotes[layer] == nil then
		-- Create sustained notes container for layer
		sustainedNotes[layer] = {}
	elseif not(enable) and sustainedNotes[layer] ~= nil then
		-- Turn off all sustained notes
		local noteOn
		for _, noteOn in pairs(sustainedNotes[layer]) do
			local key = noteOn[NOTEON.KEY]
			local instrument = noteOn[NOTEON.INSTRUMENT]
			local isChordNote = noteOn[NOTEON.IS_CHORD_NOTE]
			Musician.Live.NoteOff(key, layer, instrument, isChordNote, true)
		end
		-- Remove sustained notes container
		sustainedNotes[layer] = nil
	end
end

--- Send note on
-- @param key (int) MIDI key index
-- @param layer (int)
-- @param instrument (int)
-- @param isChordNote (boolean)
function Musician.Live.NoteOn(key, layer, instrument, isChordNote)

	local soundFile, instrumentData = Musician.Sampler.GetSoundFile(instrument, key)
	if soundFile == nil then
		return
	end

	local noteOnKey = key .. '-' .. layer .. '-' .. instrument

	-- This is an auto-chord note but a higher priority note actually exists: do nothing
	if isChordNote and notesOn[noteOnKey] and not(notesOn[noteOnKey][NOTEON.IS_CHORD_NOTE]) then
		return
	end

	-- Layer is sustained and note is already sustained: turn it off then start over
	if sustainedNotes[layer] ~= nil and sustainedNotes[layer][noteOnKey] ~= nil then
		local sustainedNote = sustainedNotes[layer][noteOnKey]
		Musician.Live.NoteOff(key, layer, instrument, isChordNote, true)
	end

	-- Mute game music
	muteGameMusic()

	-- Play note
	local handle = 0
	if not(Musician.Live.IsBandSyncMode() and Musician.Live.IsEnabled()) then
		handle = Musician.Sampler.PlayNote(instrumentData, key)
	end

	-- Insert note on and trigger event
	Musician.Live.InsertNote(true, key, layer, instrument)
	notesOn[noteOnKey] = {
		[NOTEON.HANDLE] = handle,
		[NOTEON.LAYER] = layer,
		[NOTEON.KEY] = key,
		[NOTEON.INSTRUMENT] = instrumentData.midi,
		[NOTEON.IS_CHORD_NOTE] = isChordNote
	}
	Musician.Live:SendMessage(Musician.Events.LiveNoteOn, key, layer, instrumentData, isChordNote)

	-- Send band note message if synchronization is enabled
	Musician.Live.BandNote(true, key, layer, instrument)
end

--- Send note off
-- @param key (int) MIDI key index
-- @param layer (int)
-- @param instrument (int)
-- @param isChordNote (boolean)
-- @param [ignoreSustain (boolean)] Force note off even is sustain is enabled for this layer
function Musician.Live.NoteOff(key, layer, instrument, isChordNote, ignoreSustain)

	local noteOnKey = key .. '-' .. layer .. '-' .. instrument
	if not(notesOn[noteOnKey]) then return end

	local handle = notesOn[noteOnKey][NOTEON.HANDLE]
	local noteOnIsChordNote = notesOn[noteOnKey][NOTEON.IS_CHORD_NOTE]

	-- If current note off is from an auto-chord but actual note is not: do nothing
	if isChordNote and not(noteOnIsChordNote) then
		return
	end

	-- Layer is sustained
	if not(ignoreSustain) and sustainedNotes[layer] ~= nil then
		sustainedNotes[layer][noteOnKey] = notesOn[noteOnKey]
		return
	end

	-- Unmute game music
	unmuteGameMusic()

	-- Stop playing note
	if handle then
		Musician.Sampler.StopNote(handle)
	end

	-- Insert note off and trigger event
	Musician.Live.InsertNote(false, key, layer, instrument)
	notesOn[noteOnKey] = nil
	Musician.Live:SendMessage(Musician.Events.LiveNoteOff, key, layer, isChordNote)

	-- Send band note message if synchronization is enabled
	Musician.Live.BandNote(false, key, layer, instrument)
end

--- Send note event in band mode
-- @param noteOn (boolean)
-- @param key (int) MIDI key index
-- @param layer (int)
-- @param instrument (int)
function Musician.Live.BandNote(noteOn, key, layer, instrument)
	if not(Musician.Live.IsBandSyncMode() and Musician.Live.IsEnabled()) then return end

	local noteOn = noteOn and "ON" or "OFF"
	local posY, posX, posZ, instanceID = UnitPosition("player")
	local guid = UnitGUID("player")
	local message = strjoin(" ", noteOn, key, layer, instrument, posY, posX, posZ, instanceID, guid)
	local groupChatType = Musician.Comm.GetGroupChatType()

	debug(true, Musician.Live.event.note, groupChatType, message)
	Musician.Live:SendCommMessage(Musician.Live.event.note, message, groupChatType, nil, "ALERT")
end

--- Set all notes to off
-- @param onlyForLayer (int)
function Musician.Live.AllNotesOff(onlyForLayer)
	local noteOnKey, note
	for noteOnKey, note in pairs(notesOn) do
		local layer = note[NOTEON.LAYER]
		local key = note[NOTEON.KEY]
		local instrument = note[NOTEON.INSTRUMENT]

		if onlyForLayer == nil or onlyForLayer == layer then
			Musician.Live.NoteOff(key, layer, instrument)
		end
	end
end

--- Indicate if the player in band sync mode
-- @return isBandSyncMode (boolean)
function Musician.Live.IsBandSyncMode()
	return isBandSyncMode and Musician.Comm.GetGroupChatType() ~= nil
end

--- Indicate if the provided player is in band sync mode
-- @param player (string)
-- @return isPlayerSynced (boolean)
function Musician.Live.IsPlayerSynced(player)
	return syncedBandPlayers[player]
end

--- Return the list of synced band players
-- @return readyPlayers (table)
function Musician.Live.GetSyncedBandPlayers()
	local readyPlayers = {}
	local player

	for player, _ in pairs(syncedBandPlayers) do
		table.insert(readyPlayers, player)
	end

	return readyPlayers
end

--- Set sync mode
-- @param enabled (boolean)
function Musician.Live.ToggleBandSyncMode()
	Musician.Live.SetBandSyncMode(not(isBandSyncMode))
end

--- Set band sync mode
-- @param enabled (boolean)
-- @return success (boolean)
function Musician.Live.SetBandSyncMode(enabled)
	local groupChatType = Musician.Comm.GetGroupChatType()
	if groupChatType == nil then return false end

	local type = Musician.Live.event.bandSync
	local message = tostring(enabled)

	debug(true, type, groupChatType, message)
	Musician.Live:SendCommMessage(type, message, groupChatType, nil, "ALERT")
end

--- Receive band sync mode message
--
function Musician.Live.OnBandSync(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	debug(false, prefix, sender .. "(" .. distribution .. ")", message)

	if not(Musician.Utils.PlayerIsInGroup(sender)) then return end

	local isSynced = message == "true"

	if Musician.Utils.PlayerIsMyself(sender) then
		isBandSyncMode = isSynced
	end

	-- Add/remove player in sync band members
	local wasSynced = not(not(syncedBandPlayers[sender]))
	syncedBandPlayers[sender] = isSynced or nil

	-- Trigger local event if sync status have changed
	if wasSynced ~= isSynced then
		Musician.Live:SendMessage(Musician.Events.LiveBandSync, sender, isSynced)
	end
end

--- OnGroupJoined
--
function Musician.Live.OnGroupJoined()
	syncedBandPlayers = {}
	bandNotesOn = {}
	bandSongs = {}
	isBandSyncMode = false
	local groupChatType = Musician.Comm.GetGroupChatType()
	if groupChatType then
		local message = Musician.Live.event.bandSyncQuery
		debug(true, Musician.Live.event.bandSyncQuery, groupChatType, message)
		Musician.Live:SendCommMessage(Musician.Live.event.bandSyncQuery, message, groupChatType, nil, "ALERT")
	end
end

--- OnBandSyncQuery
--
function Musician.Live.OnBandSyncQuery(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	debug(false, prefix, sender .. "(" .. distribution .. ")", message)

	if not(Musician.Utils.PlayerIsInGroup(sender)) then return end

	-- Send sync message in return
	local groupChatType = Musician.Comm.GetGroupChatType()
	if isBandSyncMode and groupChatType then
		local message = tostring(true)
		debug(true, Musician.Live.event.bandSync, groupChatType, message)
		Musician.Live:SendCommMessage(Musician.Live.event.bandSync, message, groupChatType, nil, "ALERT")
	end

	-- If the player was synced before, remove it
	if syncedBandPlayers[sender] then
		syncedBandPlayers[sender] = nil
		Musician.Live:SendMessage(Musician.Events.LiveBandSync, sender, false)
	end
end

--- OnGroupLeft
--
function Musician.Live.OnGroupLeft()
	Musician.Live.OnRosterUpdate()
	syncedBandPlayers = {}
	bandNotesOn = {}
	bandSongs = {}
	isBandSyncMode = false
end

--- OnRosterUpdate
--
function Musician.Live.OnRosterUpdate()
	-- Remove players from syncedBandPlayers who are no longer in the group
	local player
	for player, _ in pairs(syncedBandPlayers) do
		if not(Musician.Utils.PlayerIsInGroup(player)) then

			-- Stop all player notes
			if bandNotesOn[player] then
				local noteOnKey, noteData
				for noteOnKey, noteData in pairs(bandNotesOn[player]) do
					local handle, layer, key, instrument = unpack(noteData)
					if handle then
						Musician.Sampler.StopNote(handle, 0)
						sendVisualNoteEvent(false, key, layer, instrument, player)
					end
				end
			end

			-- Remove player
			syncedBandPlayers[player] = nil
			bandNotesOn[player] = nil
			bandSongs[player] = nil
			Musician.Live:SendMessage(Musician.Events.LiveBandSync, player, false)
		end
	end
end

--- OnLiveNote
--
function Musician.Live.OnLiveNote(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	debug(false, prefix, sender .. "(" .. distribution .. ")", message)

	if not(Musician.Utils.PlayerIsInGroup(sender)) then return end

	local noteOn, key, layer, instrument, posY, posX, posZ, instanceID, guid = message:match("^(%S+) (%S+) (%S+) (%S+) (%S+) (%S+) (%S+) (%S+) (.*)")
	noteOn = noteOn == "ON"
	key = tonumber(key)
	layer = tonumber(layer)
	instrument = tonumber(instrument)
	posY = tonumber(posY)
	posX = tonumber(posX)
	posZ = tonumber(posZ)
	instanceID = tonumber(instanceID)

	-- Update player position
	Musician.Registry.UpdatePlayerPositionAndGUID(posY, posX, posZ, instanceID, guid)

	local noteOnKey = key .. '-' .. layer .. '-' .. instrument

	-- Note on
	if noteOn then
		local handle
		local soundFile, instrumentData = Musician.Sampler.GetSoundFile(instrument, key)
		if soundFile == nil then return end

		-- Mute game music
		muteGameMusic()

		if bandNotesOn[sender] == nil then bandNotesOn[sender] = {} end

		-- Interrupt previous note
		if bandNotesOn[sender][noteOnKey] then
			local prevHandle, prevLayer, prevKey, prevInstrument = unpack(bandNotesOn[sender][noteOnKey])
			if prevHandle then
				Musician.Sampler.StopNote(prevHandle)
				sendVisualNoteEvent(false, prevKey, prevLayer, prevInstrument, sender)
			end
		end

		-- Play note
		local sampleId = Musician.Sampler.GetSampleId(instrumentData, key)
		if not(Musician.PlayerIsMuted(sender)) and Musician.Registry.PlayerIsInRange(sender) then
			handle = Musician.Sampler.PlayNote(instrumentData, key)
		end

		-- Insert note on
		if handle then
			bandNotesOn[sender][noteOnKey] = { handle, layer, key, instrumentData.midi }
		end

		-- Trigger event
		sendVisualNoteEvent(true, key, layer, instrument, sender)

	-- Note off
	elseif bandNotesOn[sender] and bandNotesOn[sender][noteOnKey] then
		local handle = unpack(bandNotesOn[sender][noteOnKey])

		-- Stop playing note
		if handle then
			C_Timer.After(1/60, function() Musician.Sampler.StopNote(handle) end)
			bandNotesOn[sender][noteOnKey] = nil
		end

		-- Unmute game music
		unmuteGameMusic()

		-- Trigger event
		sendVisualNoteEvent(false, key, layer, instrument, sender)
	end
end