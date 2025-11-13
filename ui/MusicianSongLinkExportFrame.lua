--- Link export window
-- @module Musician.SongLinkExportFrame

Musician.SongLinkExportFrame = LibStub("AceAddon-3.0"):NewAddon("Musician.SongLinkExportFrame", "AceEvent-3.0")

local MODULE_NAME = "Musician.SongLinkExportFrame"
Musician.AddModule(MODULE_NAME)

local ChatEdit_LinkItem = ChatFrameUtil and ChatFrameUtil.LinkItem or ChatEdit_LinkItem
local ChatEdit_GetActiveWindow = ChatFrameUtil and ChatFrameUtil.GetActiveWindow or ChatEdit_GetActiveWindow

local exporting = false
local exportingSong

local function onExportComplete()
	MusicianSongLinkExportFrame:Hide()
	exportingSong:Wipe()
	exportingSong = nil
end

local function postLink()
	local frame = MusicianSongLinkExportFrame
	local name = Musician.Utils.NormalizeSongName(frame.songTitle:GetText())

	Musician.sourceSong.name = name
	Musician.Frame.Clear()

	exportingSong = Musician.sourceSong:Clone()
	ChatEdit_LinkItem(nil, Musician.SongLinks.GetHyperlink(name))

	-- Focus the chat edit box on WoW Classic (it's not done by default)
	if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE then
		local activeWindow = ChatEdit_GetActiveWindow()
		if activeWindow then
			activeWindow:SetFocus()
		end
	end

	Musician.SongLinks.AddSong(exportingSong, name, onExportComplete)
end

--- Show the export frame
--
function Musician.SongLinkExportFrame.Show()
	if not Musician.sourceSong then return end

	local frame = MusicianSongLinkExportFrame

	if not exporting then
		frame.postLink = function()
			postLink()
		end

		frame.songTitle:SetMaxBytes(Musician.Song.MAX_NAME_LENGTH)
		frame.songTitle:SetText(Musician.sourceSong.name)
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

		-- Update the exported song title if the source song has changed before starting the export
		Musician.SongLinkExportFrame:RegisterMessage(Musician.Events.SourceSongLoaded, function()
			if not exportingSong then
				frame.songTitle:SetText(Musician.sourceSong.name)
			end
		end)

		Musician.SongLinkExportFrame:RegisterMessage(Musician.Events.SongExportStart, function(event, song)
			if song ~= exportingSong then return end
			exporting = true
			frame.postLinkButton:Disable()
			frame.songTitle:Disable()
			frame.progressBar:Show()
			frame.progressText:Show()
			frame.hint:Hide()
		end)

		Musician.SongLinkExportFrame:RegisterMessage(Musician.Events.SongExportProgress, function(event, song, progress)
			if song ~= exportingSong then return end
			frame.progressBar:SetProgress(progress)
			local percentageText = floor(progress * 100)
			local progressText = string.gsub(Musician.Msg.LINK_EXPORT_WINDOW_PROGRESS, '{progress}', percentageText)
			frame.progressText:SetText(progressText)
		end)

		Musician.SongLinkExportFrame:RegisterMessage(Musician.Events.SongExportComplete, function(event, song)
			if song ~= exportingSong then return end
			frame.progressBar:Hide()
			frame.progressText:Hide()
			frame.hint:Show()
			exporting = false
			Musician.SongLinkExportFrame:UnregisterMessage(Musician.Events.SongExportStart)
			Musician.SongLinkExportFrame:UnregisterMessage(Musician.Events.SongExportProgress)
			Musician.SongLinkExportFrame:UnregisterMessage(Musician.Events.SongExportComplete)
		end)
	end

	frame:Show()
end

-- Main mixin

MusicianSongLinkExportFrameMixin = {}

--- OnLoad
--
function MusicianSongLinkExportFrameMixin:OnLoad()
	self.title:SetText(Musician.Msg.LINK_EXPORT_WINDOW_TITLE)
	self.songTitleLabel:SetText(Musician.Msg.LINK_EXPORT_WINDOW_SONG_TITLE_LABEL)

	-- Song title edit box
	self.songTitle:SetScript("OnEnterPressed", function()
		self.postLink()
	end)
	self.songTitle:SetScript("OnEscapePressed", function()
		self:Hide()
	end)
	-- Prevent the chat edit box from being closed when the link EditBox is focused on WoW Classic
	if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE and ChatEdit_OnEditFocusLost then
		local chatEditOnFocusLost = ChatEdit_OnEditFocusLost
		self.songTitle:HookScript("OnEnter", function()
			ChatEdit_OnEditFocusLost = function() end
		end)
		self.songTitle:HookScript("OnLeave", function()
			ChatEdit_OnEditFocusLost = chatEditOnFocusLost
		end)
	end

	-- Post link button
	self.postLinkButton:HookScript("OnClick", function()
		self.postLink()
	end)
end