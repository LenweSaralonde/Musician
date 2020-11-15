--- Song sending module
-- @module Musician.SongSharer

Musician.SongSharer = LibStub("AceAddon-3.0"):NewAddon("Musician.SongSharer", "AceComm-3.0", "AceEvent-3.0")

local MODULE_NAME = "SongSharer"
Musician.AddModule(MODULE_NAME)

local LibDeflate = LibStub:GetLibrary("LibDeflate")

Musician.SongSharer.event = {}
Musician.SongSharer.event.song = "MusicianSong"
Musician.SongSharer.event.requestSong = "MusicianSongReq"
Musician.SongSharer.event.songError = "MusicianSongErr"

Musician.SongSharer.errors = {}
Musician.SongSharer.errors.notFound = 'notFound'
Musician.SongSharer.errors.alreadySending = 'alreadySending'
Musician.SongSharer.errors.alreadyRequested = 'alreadyRequested'
Musician.SongSharer.errors.timeout = 'timeout'
Musician.SongSharer.errors.importingFailed = 'importingFailed'

Musician.SongSharer.status = {}
Musician.SongSharer.status.requested = 'requested'
Musician.SongSharer.status.downloading = 'downloading'
Musician.SongSharer.status.importing = 'importing'

local sharedSongs = {}
local sendingSongs = {}
local requestedSongs = {}

local RECEIVING_PROGRESSION_RATIO = .9
local REQUEST_TIMEOUT = 30

local MSG_MULTI_FIRST = "\001"
local MSG_MULTI_NEXT  = "\002"
local MSG_MULTI_LAST  = "\003"

--- Print communication debug message
-- @param out (boolean) Outgoing message
-- @param event (string)
-- @param source (string)
-- @param message (string)
-- @param ... (string)
local function debugComm(out, event, source, message, ...)
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

--- Print debug message
-- @param message (string)
-- @param ... (string)
local function debug(message, ...)
	Musician.Utils.Debug(MODULE_NAME, message, ...)
end

--- Initialize song sharing
--
function Musician.SongSharer.Init()
	Musician.SongSharer:RegisterMessage(Musician.Events.SongImportProgress, Musician.SongSharer.OnSongImportProgress)
	Musician.SongSharer:RegisterComm(Musician.SongSharer.event.song, Musician.SongSharer.OnSongReceived)
	Musician.SongSharer:RegisterComm(Musician.SongSharer.event.requestSong, Musician.SongSharer.OnRequestSong)
	Musician.SongSharer:RegisterComm(Musician.SongSharer.event.songError, Musician.SongSharer.OnSongError)
	Musician.SongSharer:RegisterEvent("CHAT_MSG_ADDON", function(event, prefix, message, distribution, sender)
		if prefix == Musician.SongSharer.event.song then
			Musician.SongSharer.OnSongData(prefix, message, distribution, sender)
		end
	end)
end

--- Export and add song for sharing
-- @param song (Musician.Song)
-- @param[opt] title (string)
-- @param[opt] onComplete (function)
function Musician.SongSharer.AddSong(song, title, onComplete)
	if title == nil then
		title = song.name
	end

	song:ExportCompressed(function(songData)
		sharedSongs[title] = songData
		debug("Exported song for sharing", title)
		if onComplete then
			onComplete(title)
		end
	end)
end

--- Request a song for download to a player
-- @param title (string)
-- @param playerName (string)
function Musician.SongSharer.RequestSong(title, playerName)
	playerName = Musician.Utils.NormalizePlayerName(playerName)

	-- Song is already being requested
	if requestedSongs[playerName] ~= nil then
		Musician.SongSharer:SendMessage(Musician.Events.SongReceiveFailed, playerName, Musician.SongSharer.errors.alreadyRequested, title)
		return
	end

	-- Timeout function
	local onTimeout = function()
		if requestedSongs[playerName] == nil then return end
		debug("Timed out after", REQUEST_TIMEOUT, playerName, title)
		Musician.SongSharer.RemoveRequest(playerName)
		Musician.SongSharer:SendMessage(Musician.Events.SongReceiveComplete, playerName)
		Musician.SongSharer:SendMessage(Musician.Events.SongReceiveFailed, playerName, Musician.SongSharer.errors.timeout, title)
	end

	-- Add song request
	requestedSongs[playerName] = {
		['title'] = title,
		['status'] = Musician.SongSharer.status.requested,
		['total'] = nil,
		['downloaded'] = 0,
		['song'] = nil,
		['onTimeout'] = onTimeout,
		['timeoutTimer'] = C_Timer.NewTimer(REQUEST_TIMEOUT, onTimeout)
	}

	Musician.SongSharer:SendMessage(Musician.Events.SongReceiveStart, playerName)
	Musician.SongSharer:SendMessage(Musician.Events.SongReceiveProgress, playerName, 0)

	-- Send song request to player
	debugComm(true, Musician.SongSharer.event.requestSong, playerName, title)
	Musician.SongSharer:SendCommMessage(Musician.SongSharer.event.requestSong, title, 'WHISPER', playerName, 'ALERT')
end

--- Remove a song download request
-- @param playerName (string)
function Musician.SongSharer.RemoveRequest(playerName)
	playerName = Musician.Utils.NormalizePlayerName(playerName)

	local requestedSong = requestedSongs[playerName]

	if requestedSong == nil then return end

	requestedSongs[playerName] = nil

	if requestedSong.timeoutTimer then
		requestedSong.timeoutTimer:Cancel()
	end

	if requestedSong.status == Musician.SongSharer.status.importing then
		requestedSong.song:CancelImport()
	end
end

--- Cancel a song download request
-- @param playerName (string)
function Musician.SongSharer.CancelRequest(playerName)
	Musician.SongSharer.RemoveRequest(playerName)
	Musician.SongSharer:SendMessage(Musician.Events.SongReceiveComplete, playerName)
	Musician.SongSharer:SendMessage(Musician.Events.SongReceiveCanceled, playerName)
end

--- OnRequestSong
--
function Musician.SongSharer.OnRequestSong(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	debugComm(false, Musician.SongSharer.event.requestSong, sender, message)
	Musician.SongSharer.SendSong(message, sender)
end

--- OnSongError
--
function Musician.SongSharer.OnSongError(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	local errorCode, title = string.match(message, "^([^ ]+) (.*)")
	debugComm(false, Musician.SongSharer.event.songError, sender, errorCode, title)
	Musician.SongSharer.RemoveRequest(sender)
	Musician.SongSharer:SendMessage(Musician.Events.SongReceiveComplete, sender)
	Musician.SongSharer:SendMessage(Musician.Events.SongReceiveFailed, sender, errorCode, title)
end

--- Send shared song to another player by title
-- @param title (string)
-- @param playerName (string)
function Musician.SongSharer.SendSong(title, playerName)
	playerName = Musician.Utils.NormalizePlayerName(playerName)

	-- Song not available in shared songs list
	if sharedSongs[title] == nil then
		debug("Song not found")
		local message = Musician.SongSharer.errors.notFound .. ' ' .. title
		debugComm(true, Musician.SongSharer.event.songError, playerName, message)
		Musician.SongSharer:SendCommMessage(Musician.SongSharer.event.songError, message, 'WHISPER', playerName, 'ALERT')
		return
	end

	-- Send song data
	Musician.SongSharer.SendSongData(title, playerName, sharedSongs[title])
end

--- Send song data to another player
-- @param title (string)
-- @param playerName (string)
-- @param songData (string)
function Musician.SongSharer.SendSongData(title, playerName, songData)
	playerName = Musician.Utils.NormalizePlayerName(playerName)

	debug("Sending song", playerName, title)

	-- Already sending a song to the player
	if sendingSongs[playerName] then
		debug("Song already sending")
		local message = Musician.SongSharer.errors.alreadySending .. ' ' .. title
		debugComm(true, Musician.SongSharer.event.songError, playerName, message)
		Musician.SongSharer:SendCommMessage(Musician.SongSharer.event.songError, message, 'WHISPER', playerName, 'ALERT')
		return
	end

	sendingSongs[playerName] = title

	local encodedData = LibDeflate:EncodeForWoWAddonChannel(songData)

	-- Prepend data length to the message so the recipient can determine the progression
	local msg = #encodedData .. " " .. encodedData

	-- Send song
	debugComm(true, Musician.SongSharer.event.song, playerName, title, #msg)
	Musician.SongSharer:SendCommMessage(Musician.SongSharer.event.song, msg, 'WHISPER', playerName, 'BULK', function(_, sent, total)
		-- Song upload complete
		if sent == total then
			sendingSongs[playerName] = nil
		end
	end)
end

--- OnSongData
-- Notify download progression
function Musician.SongSharer.OnSongData(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)

	local requestedSong = requestedSongs[sender]

	if requestedSong == nil then return end

	-- Reset timeout timer
	if requestedSong.timeoutTimer then
		requestedSong.timeoutTimer:Cancel()
		requestedSong.timeoutTimer = C_Timer.NewTimer(REQUEST_TIMEOUT, requestedSong.onTimeout)
	end

	-- Get progression from chunks
	local control, data = string.match(message, "^([\001-\009])(.*)")
	if control then
		if control == MSG_MULTI_FIRST then
			requestedSong.status = Musician.SongSharer.status.downloading
			-- Extract total data length to determine the progression
			requestedSong.total, data = string.match(data, "^([0-9]+) (.*)")
			requestedSong.downloaded = #data
		elseif control == MSG_MULTI_NEXT or control == MSG_MULTI_LAST then
			-- Lost chunk (may happen after a /reload while receiving a song)
			if requestedSong.total == nil then return end

			-- Update received data length
			requestedSong.downloaded = requestedSong.downloaded + #data
		end
		Musician.SongSharer:SendMessage(Musician.Events.SongReceiveProgress, sender, RECEIVING_PROGRESSION_RATIO * requestedSong.downloaded / requestedSong.total)
	else
		-- The whole song fits in a single message
		Musician.SongSharer:SendMessage(Musician.Events.SongReceiveProgress, sender, RECEIVING_PROGRESSION_RATIO)
	end
end

--- OnSongImportProgress
-- Notify import progression
function Musician.SongSharer.OnSongImportProgress(event, song, importProgress)
	if song.sender then
		local totalProgress = RECEIVING_PROGRESSION_RATIO + (1 - RECEIVING_PROGRESSION_RATIO) * importProgress
		Musician.SongSharer:SendMessage(Musician.Events.SongReceiveProgress, song.sender, totalProgress)
	end
end

--- OnSongReceived
-- Song data has been received
function Musician.SongSharer.OnSongReceived(prefix, message, distribution, sender)
	sender = Musician.Utils.NormalizePlayerName(sender)
	debugComm(false, Musician.SongSharer.event.song, sender, #message)
	local requestedSong = requestedSongs[sender]

	if requestedSong == nil then return end

	local song = Musician.Song.create()
	song.sender = sender
	collectgarbage()

	requestedSong.song = song
	requestedSong.status = Musician.SongSharer.status.importing
	requestedSong.timeoutTimer:Cancel()
	requestedSong.timeoutTimer = nil
	local title = requestedSong.title

	local dataLength, encodedData = string.match(message, "^([0-9]+) (.*)")
	local songData = LibDeflate:DecodeForWoWAddonChannel(encodedData)
	song:ImportCompressed(songData, false, function(success)

		Musician.SongSharer.RemoveRequest(sender)
		Musician.SongSharer:SendMessage(Musician.Events.SongReceiveComplete, sender)

		-- Import failed
		if not(success) then
			debug("Song downloading failed")
			Musician.SongSharer:SendMessage(Musician.Events.SongReceiveFailed, sender, Musician.SongSharer.errors.importingFailed, title)
			return
		end

		-- Stop previous source song being played
		if Musician.sourceSong and Musician.sourceSong:IsPlaying() then
			Musician.sourceSong:Stop()
		end

		Musician.sourceSong = song
		collectgarbage()

		debug("Song downloading complete", song.name)
		Musician.SongSharer:SendMessage(Musician.Events.SongReceiveSucessful, sender, song)

		Musician.SongSharer:SendMessage(Musician.Events.SourceSongLoaded, song, songData)
	end)
end