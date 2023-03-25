--- Band live play button template
-- @module MusicianBandLivePlayButtonTemplate

MusicianBandLivePlayButtonTemplateMixin = {}

local AceEvent = LibStub:GetLibrary("AceEvent-3.0")

--- Update the button
-- @param checked (boolean)
function MusicianBandLivePlayButtonTemplateMixin:Update()
	-- Update button visibility

	local isVisible = IsInGroup()
	local isEnabled = Musician.Comm.GetGroupChatType() ~= nil

	self:SetShown(isVisible)
	self:SetEnabled(isEnabled)

	-- Update button LED

	self:SetChecked(Musician.Live.IsBandSyncMode())

	-- Update tooltip and the number of ready players

	local players = Musician.Live.GetSyncedBandPlayers()
	local tooltipText = Musician.Msg.LIVE_SYNC

	if not Musician.Live.IsBandSyncMode() then
		tooltipText = tooltipText .. "\n" .. Musician.Utils.Highlight(Musician.Msg.LIVE_SYNC_HINT, "00FFFF")
	end

	if #players > 0 then
		self.count.text:SetText(#players)
		self.count:Show()

		local playerNames = {}
		for _, playerName in ipairs(players) do
			table.insert(playerNames, "– " .. Musician.Utils.FormatPlayerName(playerName))
		end

		tooltipText = tooltipText .. "\n" .. Musician.Msg.SYNCED_PLAYERS
		tooltipText = tooltipText .. "\n" .. strjoin("\n", unpack(playerNames))
	else
		self.count:Hide()
	end
	self:SetTooltipText(tooltipText)
end

--- OnLoad
-- @param self (Frame)
function MusicianBandLivePlayButtonTemplate_OnLoad(self)
	self.count:SetPoint("CENTER", self, "TOPRIGHT", -4, -4)
	self:SetText(Musician.Icons.BandPlay)
	self.tooltipText = Musician.Msg.LIVE_SYNC
	AceEvent:Embed(self)
	local doUpdate = function() self:Update() end
	self:RegisterEvent("GROUP_ROSTER_UPDATE", doUpdate)
	self:RegisterMessage(Musician.Events.LiveBandSync, doUpdate)
	self:Update()
end

--- OnClick
--
function MusicianBandLivePlayButtonTemplate_OnClick()
	PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
	Musician.Live.ToggleBandSyncMode()
end