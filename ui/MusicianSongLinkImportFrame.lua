--- Link import window
-- @module Musician.SongLinkImportFrame

Musician.SongLinkImportFrame = LibStub("AceAddon-3.0"):NewAddon("Musician.SongLinkImportFrame", "AceEvent-3.0")

local MODULE_NAME = "Musician.SongLinkImportFrame"
Musician.AddModule(MODULE_NAME)

--- Init
--
function Musician.SongLinkImportFrame.Init()
	Musician.SongLinkImportFrame:RegisterMessage(Musician.Events.SongLink, Musician.SongLinkImportFrame.OnSongLinkClick)
end

local function startImport(title, playerName)
	if not(Musician.SongLinks.GetRequestingSong(playerName)) then
		Musician.SongLinks.RequestSong(title, playerName)
	end
end

local function cancelImport(playerName)
	Musician.SongLinks.CancelRequest(playerName)
end

--- OnSongLinkClick
-- Called when clicking on a song link
function Musician.SongLinkImportFrame.OnSongLinkClick(event, title, playerName)
	playerName = Musician.Utils.NormalizePlayerName(playerName)
	local playerDisplayName = Musician.Utils.FormatPlayerName(playerName)
	local playerLink = Musician.Utils.GetLink('player', Musician.Utils.Highlight(playerDisplayName), playerName)

	-- Get currently requesting song title from the player, if any
	local isAlreadyImporting = false
	local requestingSongTitle = Musician.SongLinks.GetRequestingSong(playerName)
	if requestingSongTitle then
		title = requestingSongTitle
		isAlreadyImporting = true
	end

	local frame = MusicianSongLinkImportFrame

	if not(isAlreadyImporting) then
		local frameTitle = string.gsub(Musician.Msg.LINK_IMPORT_WINDOW_TITLE, '{player}', playerLink)
		frame.title:SetText(frameTitle)
		frame.songTitle:SetText(title)
		frame.progressText:SetText(Musician.Msg.LINK_IMPORT_WINDOW_PROGRESS)
		frame.progressText:Hide()
		frame.progressBar:Hide()
		frame.hint:SetText(Musician.Msg.LINK_IMPORT_WINDOW_HINT)
		frame.hint:Show()
		frame.importButton:SetText(Musician.Msg.LINK_IMPORT_WINDOW_IMPORT_BUTTON)
		frame.importButton:Show()
		frame.cancelImportButton:SetText(Musician.Msg.LINK_IMPORT_WINDOW_CANCEL_IMPORT_BUTTON)
		frame.cancelImportButton:Hide()

		frame.startImport = function()
			startImport(title, playerName)
		end
		frame.cancelImport = function()
			cancelImport(playerName)
		end

		-- Hide popup when complete
		Musician.SongLinkImportFrame:RegisterMessage(Musician.Events.SongReceiveComplete, function()
			frame:Hide()
		end)

		-- Start import
		Musician.SongLinkImportFrame:RegisterMessage(Musician.Events.SongReceiveStart, function(event, sender, progress)
			sender = Musician.Utils.NormalizePlayerName(sender)
			if sender ~= playerName then return end
			local hintText = string.gsub(Musician.Msg.LINK_IMPORT_WINDOW_REQUESTING, '{player}', playerLink)
			frame.hint:SetText(hintText)
			frame.importButton:Hide()
			frame.cancelImportButton:Show()
		end)

		-- Update import progression
		Musician.SongLinkImportFrame:RegisterMessage(Musician.Events.SongReceiveProgress, function(event, sender, progress)
			sender = Musician.Utils.NormalizePlayerName(sender)
			if sender ~= playerName then return end
			frame.hint:Hide()
			local progressText = string.gsub(Musician.Msg.LINK_IMPORT_WINDOW_PROGRESS, '{progress}', floor(progress * 100))
			frame.progressText:SetText(progressText)
			frame.progressText:Show()
			frame.progressBar:SetProgress(progress)
			frame.progressBar:Show()
		end)

		-- Print an error message if an error occurred
		Musician.SongLinkImportFrame:RegisterMessage(Musician.Events.SongReceiveFailed, function(event, sender, reason, title)
			sender = Musician.Utils.NormalizePlayerName(sender)
			if sender ~= playerName then return end
			local msg = Musician.Msg.LINKS_ERROR[reason] or ''
			msg = string.gsub(msg, '{player}', Musician.Utils.FormatPlayerName(sender))
			msg = string.gsub(msg, '{title}', title)
			Musician.Utils.Error(msg)
		end)
	end

	frame:Show()
end
