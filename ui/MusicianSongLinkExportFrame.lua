--- Link export window
-- @module Musician.SongLinkExportFrame

Musician.SongLinkExportFrame = LibStub("AceAddon-3.0"):NewAddon("Musician.SongLinkExportFrame", "AceEvent-3.0")

local MODULE_NAME = "Musician.SongLinkExportFrame"
Musician.AddModule(MODULE_NAME)

local exporting = false

local function onExportComplete()
	MusicianSongLinkExportFrame:Hide()
end

local function postLink(sharedSong)
	local frame = MusicianSongLinkExportFrame
	local name = Musician.Utils.NormalizeSongName(frame.songTitle:GetText())
	sharedSong.name = name
	if sharedSong == Musician.sourceSong then
		MusicianFrame.Clear()
	end
	ChatEdit_LinkItem(nil, Musician.SongLinks.GetHyperlink(name))
	Musician.SongLinks.AddSong(sharedSong, name, onExportComplete)
end

function Musician.SongLinkExportFrame.Show()
	if not(Musician.sourceSong) then return end

	local frame = MusicianSongLinkExportFrame

	if not(exporting) then
		local sharedSong = Musician.sourceSong

		frame.postLink = function()
			postLink(sharedSong)
		end

		frame.songTitle:SetMaxBytes(Musician.Song.MAX_NAME_LENGTH)
		frame.songTitle:SetText(sharedSong.name)
		frame.songTitle:HighlightText(0)
		frame.songTitle:SetFocus()
		frame.songTitle:Enable()

		frame.hint:SetText(Musician.Msg.LINK_EXPORT_WINDOW_HINT)
		frame.hint:Show()

		frame.progressText:SetText(Musician.Msg.LINK_EXPORT_WINDOW_PROGRESS)
		frame.progressText:Hide()
		frame.progressBar:Hide()

		frame.postLinkButton:SetText(Musician.Msg.LINK_EXPORT_WINDOW_POST_BUTTON)
		frame.postLinkButton:Enable()

		Musician.SongLinkExportFrame:RegisterMessage(Musician.Events.SongExportStart, function(event, song)
			if song ~= sharedSong then return end
			exporting = true
			frame.postLinkButton:Disable()
			frame.songTitle:Disable()
			frame.progressBar:Show()
			frame.progressText:Show()
			frame.hint:Hide()
		end)

		Musician.SongLinkExportFrame:RegisterMessage(Musician.Events.SongExportProgress, function(event, song, progress)
			if song ~= sharedSong then return end
			frame.progressBar:SetProgress(progress)
			local percentageText = floor(progress * 100)
			local progressText = string.gsub(Musician.Msg.LINK_EXPORT_WINDOW_PROGRESS, '{progress}', percentageText)
			frame.progressText:SetText(progressText)
		end)

		Musician.SongLinkExportFrame:RegisterMessage(Musician.Events.SongExportComplete, function(event, song)
			if song ~= sharedSong then return end
			frame.progressBar:Hide()
			frame.progressText:Hide()
			frame.hint:Show()
			exporting = false
			Musician.SongLinkExportFrame:UnregisterMessage(Musician.Events.SongExportStart)
			Musician.SongLinkExportFrame:UnregisterMessage(Musician.Events.SongExportProgress)
			Musician.SongLinkExportFrame:UnregisterMessage(Musician.Events.SongExportComplete)
			sharedSong = nil
			collectgarbage()
		end)
	end

	frame:Show()
end
