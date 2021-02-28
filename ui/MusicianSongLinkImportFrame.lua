--- Link import window
-- @module Musician.SongLinkImportFrame

Musician.SongLinkImportFrame = LibStub("AceAddon-3.0"):NewAddon("Musician.SongLinkImportFrame", "AceEvent-3.0")

local MODULE_NAME = "Musician.SongLinkImportFrame"
Musician.AddModule(MODULE_NAME)

local gameAccountSelectorFrame

--- Init
--
function Musician.SongLinkImportFrame.Init()
	Musician.SongLinkImportFrame:RegisterMessage(Musician.Events.SongLink, Musician.SongLinkImportFrame.OnSongLinkClick)

	-- Print an error message if an import error occurred
	Musician.SongLinkImportFrame:RegisterMessage(Musician.Events.SongReceiveFailed, function(event, sender, reason, title)
		sender = Musician.Utils.NormalizePlayerName(sender)
		local msg = Musician.Msg.LINKS_ERROR[reason] or ''
		msg = string.gsub(msg, '{player}', Musician.Utils.FormatPlayerName(sender))
		msg = string.gsub(msg, '{title}', title)
		Musician.Utils.Error(msg)
	end)

	-- Create WoW game account selector menu frame
	gameAccountSelectorFrame = CreateFrame("Frame", "MusicianSongLinkImportFrame_GameAccountSelector", UIParent, "MusicianDropDownMenuTooltipTemplate")
end

local function startImport(title, playerName)
	if not(Musician.SongLinks.GetRequestingSong(playerName)) then
		Musician.SongLinks.RequestSong(title, playerName)
	end
end

local function cancelImport(playerName)
	Musician.SongLinks.CancelRequest(playerName)
end

local function updateProgression(progress)
	local frame = MusicianSongLinkImportFrame
	if progress == nil then
		frame.progressText:SetText(Musician.Msg.LINK_IMPORT_WINDOW_PROGRESS)
		frame.progressText:Hide()
		frame.progressBar:Hide()
	else
		local progressText = string.gsub(Musician.Msg.LINK_IMPORT_WINDOW_PROGRESS, '{progress}', floor(progress * 100))
		frame.hint:Hide()
		frame.progressText:SetText(progressText)
		frame.progressText:Show()
		frame.progressBar:SetProgress(progress)
		frame.progressBar:Show()
	end
end

local function update(title, playerName)
	playerName = Musician.Utils.NormalizePlayerName(playerName)

	local frame = MusicianSongLinkImportFrame

	-- Set frame title
	local playerLink
	if Musician.Utils.IsBattleNetID(playerName) then
		local playerDisplayName = Musician.Utils.FormatPlayerName(playerName)
		playerLink = Musician.Utils.Highlight('[') .. Musician.Utils.Highlight(playerDisplayName) .. Musician.Utils.Highlight(']')
	else
		local playerDisplayName = Musician.Utils.FormatPlayerName(playerName)
		playerLink = Musician.Utils.Highlight('[') .. Musician.Utils.GetLink('player', Musician.Utils.Highlight(playerDisplayName), playerName) .. Musician.Utils.Highlight(']')
	end

	local frameTitle = string.gsub(Musician.Msg.LINK_IMPORT_WINDOW_TITLE, '{player}', playerLink)
	frame.title:SetText(frameTitle)

	local requestingSong = Musician.SongLinks.GetRequestingSong(playerName)
	-- A song is not being requested
	if not(requestingSong) then
		-- Set song title
		frame.songTitle:SetText(title)

		-- Default hint text
		frame.hint:SetText(Musician.Msg.LINK_IMPORT_WINDOW_HINT)
		frame.hint:Show()

		-- Show import button
		frame.importButton:Show()

		-- Hide cancel button
		frame.cancelImportButton:Hide()

		-- Update progression
		updateProgression()
	else
		-- Set song title
		frame.songTitle:SetText(requestingSong.title)

		-- Hide import button
		frame.importButton:Hide()

		-- Show cancel button
		frame.cancelImportButton:Show()

		-- Set hint text
		if requestingSong.progress == nil then
			-- Song has been requested but download has not started
			local hintText = string.gsub(Musician.Msg.LINK_IMPORT_WINDOW_REQUESTING, '{player}', playerLink)
			frame.hint:SetText(hintText)
			frame.hint:Show()
		else
			frame.hint:Hide()
		end

		-- Update progression
		updateProgression(requestingSong.progress)
	end
end

--- OnSongLinkClick
-- Called when a song hyperlink is clicked
function Musician.SongLinkImportFrame.OnSongLinkClick(event, title, playerName)
	playerName = Musician.Utils.NormalizePlayerName(playerName)

	-- Requesting from a Battle.net friend
	if Musician.Utils.IsBattleNetID(playerName) then
		local accountID = playerName
		local gameAccountsInfo = Musician.Utils.GetBattleNetGameAccounts(accountID)

		if #gameAccountsInfo == 0 then
			-- No WoW game account is online
			local accountInfo = Musician.Utils.GetBattleNetAccount(accountID)
			local friendName = accountInfo.accountDisplayName or UNKNOWN
			if friendName then
				local msg = Musician.Msg.LINKS_ERROR[Musician.SongLinks.errors.offline]
				msg = string.gsub(msg, '{player}', friendName)
				msg = string.gsub(msg, '{title}', title)
				Musician.Utils.Error(msg)
			end
		elseif #gameAccountsInfo == 1 then
			-- Only one WoW game account is online: proceed with import
			Musician.SongLinkImportFrame.ShowImportFrame(title, gameAccountsInfo[1].gameAccountID)
		else
			-- Multiple WoW game accounts are online: Open account selector menu
			local menu = {}

			table.insert(menu, {
				notCheckable = true,
				text = Musician.Msg.LINK_IMPORT_WINDOW_SELECT_ACCOUNT,
				isTitle = true
			})

			for _, gameAccountInfo in pairs(gameAccountsInfo) do
				table.insert(menu, {
					notCheckable = true,
					text = gameAccountInfo.characterName .. ' – ' .. gameAccountInfo.realmDisplayName,
					func = function()
						Musician.SongLinkImportFrame.ShowImportFrame(title, gameAccountInfo.gameAccountID)
					end
				})
			end

			Musician.Utils.EasyMenu(menu, gameAccountSelectorFrame, "cursor", 0 , 0, "MENU")
		end
	else
		-- In-game character
		Musician.SongLinkImportFrame.ShowImportFrame(title, playerName)
	end
end

--- Show the song import frame
-- @param title (string)
-- @param playerName (string|number)
function Musician.SongLinkImportFrame.ShowImportFrame(title, playerName)

	local frame = MusicianSongLinkImportFrame

	update(title, playerName)

	frame.startImport = function()
		startImport(title, playerName)
	end
	frame.cancelImport = function()
		cancelImport(playerName)
	end

	-- Start import
	Musician.SongLinkImportFrame:RegisterMessage(Musician.Events.SongReceiveStart, function(event, sender)
		sender = Musician.Utils.NormalizePlayerName(sender)
		if sender ~= playerName then return end
		update(title, playerName)
		Musician.SongLinkImportFrame:UnregisterMessage(Musician.Events.SongReceiveStart)
	end)

	-- Update import progression
	Musician.SongLinkImportFrame:RegisterMessage(Musician.Events.SongReceiveProgress, function(event, sender, progress)
		sender = Musician.Utils.NormalizePlayerName(sender)
		if sender ~= playerName then return end
		updateProgression(progress)
	end)

	-- Hide popup when complete
	Musician.SongLinkImportFrame:RegisterMessage(Musician.Events.SongReceiveComplete, function(event, sender)
		sender = Musician.Utils.NormalizePlayerName(sender)
		if sender ~= playerName then return end
		frame:Hide()
		Musician.SongLinkImportFrame:UnregisterMessage(Musician.Events.SongReceiveComplete)
		Musician.SongLinkImportFrame:UnregisterMessage(Musician.Events.SongReceiveProgress)
	end)

	frame:Show()
end
