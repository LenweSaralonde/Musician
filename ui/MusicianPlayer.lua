--- Player window
-- @module Musician.Player

Musician.Player = LibStub("AceAddon-3.0"):NewAddon("Musician.Player", "AceEvent-3.0")

local MODULE_NAME = "Musician.Player"
Musician.AddModule(MODULE_NAME)

--- Init
--
function Musician.Player.Init()
	MusicianPlayer.noEscape = true
	MusicianPlayer:ClearAllPoints()
	local defaultY = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE and 93 or 126
	MusicianPlayer:SetPoint('RIGHT', UIParent, 'RIGHT', 0, defaultY)

	-- Play button
	local playButton = MusicianPlayer.playButton
	playButton.icon:SetText(Musician.Icons.Speaker)
	playButton:HookScript('OnClick', Musician.Comm.TogglePlaySong)
	playButton:SetText(Musician.Msg.PLAY)
	Musician.Player.UpdatePlayButton()
	playButton.progressBar:Hide()

	-- Band play button
	MusicianPlayer.bandPlayButton:HookScript("OnClick", Musician.Comm.ToggleBandPlayReady)
	Musician.Player.UpdateBandPlayButton()

	-- Preview controls
	MusicianPlayer.previousButton:SetText(Musician.Icons.ToStart)
	MusicianPlayer.previousButton:Disable()
	MusicianPlayer.previousButton:HookScript("OnClick", function()
		if Musician.sourceSong == nil then return end
		Musician.sourceSong:Seek(Musician.sourceSong.cropFrom)
	end)

	MusicianPlayer.nextButton:SetText(Musician.Icons.ToEnd)
	MusicianPlayer.nextButton:Disable()
	MusicianPlayer.nextButton:HookScript("OnClick", function()
		if Musician.sourceSong == nil then return end
		Musician.sourceSong:Seek(Musician.sourceSong.cropTo)
	end)

	MusicianPlayer.previewButton.tooltipText = Musician.Msg.PLAY
	MusicianPlayer.previewButton:SetText(Musician.Icons.Play)
	MusicianPlayer.previewButton:Disable()
	MusicianPlayer.previewButton:HookScript("OnClick", function()
		if Musician.sourceSong == nil then return end
		if Musician.sourceSong:IsPlaying() then
			Musician.sourceSong:Stop()
		else
			if Musician.sourceSong.cursor >= Musician.sourceSong.cropTo then
				Musician.sourceSong:Seek(Musician.sourceSong.cropFrom)
			end
			Musician.sourceSong:Resume()
		end
	end)

	-- Slider
	MusicianPlayer.slider:SetScript("OnMouseDown", function(self)
		self.dragging = true
	end)
	MusicianPlayer.slider:SetScript("OnMouseUp", function(self)
		self.dragging = false
		if Musician.sourceSong then
			Musician.sourceSong:Seek(self:GetValue() - .001)
		end
	end)

	-- Setup event listeners
	Musician.Player:RegisterMessage(Musician.Events.CommSendAction, Musician.Player.OnCommSendAction)
	Musician.Player:RegisterMessage(Musician.Events.CommSendActionComplete, Musician.Player.OnCommSendAction)
	Musician.Player:RegisterMessage(Musician.Events.BandReadyPlayersUpdated, Musician.Player.UpdateBandPlayButton)
	Musician.Player:RegisterMessage(Musician.Events.SourceSongLoaded, Musician.Player.OnSourceSongUpdated)
	Musician.Player:RegisterMessage(Musician.Events.SongImportFailed, Musician.Player.OnSourceSongUpdated)
	Musician.Player:RegisterMessage(Musician.Events.SongPlay, Musician.Player.OnSongPlayOrStop)
	Musician.Player:RegisterMessage(Musician.Events.SongStop, Musician.Player.OnSongPlayOrStop)
	Musician.Player:RegisterMessage(Musician.Events.SongCursor, Musician.Player.RefreshPlayingProgressBar)
	Musician.Player:RegisterMessage(Musician.Events.Bandwidth, Musician.Player.RefreshBandwidthIndicator)
	Musician.Player:RegisterMessage(Musician.Events.CommChannelUpdate, Musician.Player.OnCommChannelUpdate)
	Musician.Player:RegisterEvent("PLAYER_DEAD", Musician.Player.OnCommChannelUpdate)
	Musician.Player:RegisterEvent("PLAYER_ALIVE", Musician.Player.OnCommChannelUpdate)
	Musician.Player:RegisterEvent("PLAYER_UNGHOST", Musician.Player.OnCommChannelUpdate)
	Musician.Player:RegisterEvent("GROUP_ROSTER_UPDATE", Musician.Player.OnRosterUpdate)
end

-- True when awaiting a communication action from the chat
local isCommActionPending = false

--- Update Play button
function Musician.Player.UpdatePlayButton()
	local isEnabled = Musician.sourceSong and Musician.Comm.CanPlay() and not isCommActionPending

	-- This may happen on trial accounts in raid mode
	if IsInGroup() and (Musician.Comm.GetGroupChatType() == nil) then
		isEnabled = false
	end

	MusicianPlayerPlayButton:SetEnabled(isEnabled)
end

--- OnSongPlayOrStop
-- @param event (string)
-- @param song (Musician.Song)
function Musician.Player.OnSongPlayOrStop(event, song)
	local isPlaying = event == Musician.Events.SongPlay
	local playButton = MusicianPlayer.playButton
	local bandPlayButton = MusicianPlayer.bandPlayButton
	local previewButton = MusicianPlayer.previewButton

	if song == Musician.sourceSong then
		if song:IsPlaying() then
			previewButton.tooltipText = Musician.Msg.PAUSE
			previewButton:SetText(Musician.Icons.Pause)
		else
			previewButton.tooltipText = Musician.Msg.PLAY
			previewButton:SetText(Musician.Icons.Play)
		end
		Musician.Player.RefreshPlayingProgressBar(event, song)
	elseif Musician.Utils.PlayerIsMyself(song.player) and Musician.songs[song.player] and not song.isLiveStreamingSong then
		playButton:SetText(isPlaying and Musician.Msg.STOP or Musician.Msg.PLAY)
		Musician.Player.RefreshPlayingProgressBar(event, song)

		-- My song started in band playing mode: set the button LED still
		if Musician.Comm.IsBandPlayReady() and isPlaying then
			bandPlayButton:SetBlinking(false)
		end
	end
end

--- Refresh progress bar of the song
-- @param event (string)
-- @param song (Musician.Song) Can be the source song or the song currently playing
function Musician.Player.RefreshPlayingProgressBar(event, song)
	if song == Musician.sourceSong then
		local slider = MusicianPlayer.slider
		slider:SetMinMaxValues(Musician.sourceSong.cropFrom, Musician.sourceSong.cropTo)
		if not slider.dragging then
			slider:SetValue(Musician.sourceSong.cursor)
		end

	elseif Musician.Utils.PlayerIsMyself(song.player) and
		Musician.songs[song.player] and
		not Musician.songs[song.player].isLiveStreamingSong
	then
		local button = MusicianPlayerPlayButton
		local progression = song:GetProgression()
		if progression ~= nil then
			button.progressBar:Show()
			button.progressBar:SetWidth(max(1, (button:GetWidth() - 10) * progression))
		else
			button.progressBar:Hide()
		end
	end
end

--- Refresh bandwidth indicator
-- @param event (string)
-- @param bandwidth (number)
function Musician.Player.RefreshBandwidthIndicator(event, bandwidth)
	local r = max(0, min(1, bandwidth * 2))
	local g = max(0, min(1, 2 - bandwidth * 2))
	local b = 0
	local a = 1

	if bandwidth == 1 then
		local t = GetTime()
		r = sin((t - floor(t)) * 720) * .33 + .67
	end

	MusicianPlayer.playButton.progressBar:SetColorTexture(r, g, b, a)
end

--- OnCommSendAction
-- @param event (string)
function Musician.Player.OnCommSendAction(event)
	local isComplete = event == Musician.Events.CommSendActionComplete
	isCommActionPending = not isComplete
	Musician.Player.UpdatePlayButton()
	Musician.Player.UpdateBandPlayButton()
end

--- Update band play button
--
function Musician.Player.UpdateBandPlayButton()

	local button = MusicianPlayerBandPlayButton

	-- Update button visibility

	local isVisible = IsInGroup()
	local isEnabled = Musician.sourceSong and (Musician.Comm.GetGroupChatType() ~= nil) and not isCommActionPending
	button:SetShown(isVisible)
	button:SetEnabled(isEnabled)

	-- Update button LED

	button:SetChecked(Musician.Comm.IsBandPlayReady())
	button:SetBlinking(not Musician.Comm.IsSongPlaying())

	-- Update tooltip and the number of ready players

	local players = Musician.Comm.GetReadyBandPlayers()
	local tooltipText = Musician.Msg.PLAY_IN_BAND

	if not Musician.Comm.IsBandPlayReady() then
		tooltipText = tooltipText .. "\n" .. Musician.Utils.Highlight(Musician.Msg.PLAY_IN_BAND_HINT, "00FFFF")
	end

	if #players > 0 then
		button.count.text:SetText(#players)
		button.count:Show()

		local playerNames = {}
		for _, playerName in ipairs(players) do
			table.insert(playerNames, "– " .. Musician.Utils.FormatPlayerName(playerName))
		end

		tooltipText = tooltipText .. "\n" .. Musician.Msg.PLAY_IN_BAND_READY_PLAYERS
		tooltipText = tooltipText .. "\n" .. strjoin("\n", unpack(playerNames))
	else
		button.count:Hide()
	end
	button:SetTooltipText(tooltipText)
end

--- OnRosterUpdate
--
function Musician.Player.OnRosterUpdate(event)
	Musician.Player.UpdatePlayButton()
	Musician.Player.UpdateBandPlayButton()
end

--- OnCommChannelUpdate
-- @param event (string)
function Musician.Player.OnCommChannelUpdate(event)
	Musician.Player.UpdatePlayButton()
	Musician.Player.UpdateBandPlayButton()
end

--- OnSourceSongUpdated
--
function Musician.Player.OnSourceSongUpdated()
	Musician.Player.UpdatePlayButton()
	Musician.Player.UpdateBandPlayButton()
	local isEnabled = Musician.sourceSong ~= nil
	MusicianPlayer.previousButton:SetEnabled(isEnabled)
	MusicianPlayer.nextButton:SetEnabled(isEnabled)
	MusicianPlayer.previewButton:SetEnabled(isEnabled)

	if Musician.sourceSong then
		local slider = MusicianPlayer.slider
		slider:SetMinMaxValues(Musician.sourceSong.cropFrom, Musician.sourceSong.cropTo)
		slider:SetValue(Musician.sourceSong.cursor)
	end
end