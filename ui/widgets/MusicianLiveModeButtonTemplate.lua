--- Live mode button template
-- @module MusicianLiveModeButtonTemplate

MusicianLiveModeButtonTemplateMixin = {}

local AceEvent = LibStub:GetLibrary("AceEvent-3.0")

--- Update the button
--
function MusicianLiveModeButtonTemplateMixin:Update()
	if Musician.Live.IsLiveEnabled() and Musician.Live.CanStream() then
		self.led:SetAlpha(1)
		self.tooltipText = Musician.Msg.ENABLE_SOLO_MODE
	else
		self.led:SetAlpha(0)
		self.tooltipText = Musician.Msg.ENABLE_LIVE_MODE
	end

	if not Musician.Live.CanStream() then
		self:Disable()
		self.tooltipText = Musician.Msg.LIVE_MODE_DISABLED
	else
		self:Enable()
	end
end

--- OnLoad
-- @param self (Frame)
function MusicianLiveModeButtonTemplate_OnLoad(self)
	self:SetText(Musician.Msg.LIVE_MODE)
	self.led:SetVertexColor(.33, 1, 0, 1)
	AceEvent:Embed(self)
	self:RegisterMessage(Musician.Events.LiveModeChange, function() self:Update() end)
	self:Update()
end

--- OnClick
--
function MusicianLiveModeButtonTemplate_OnClick(self)
	Musician.Live.EnableLive(not Musician.Live.IsLiveEnabled())
	PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
end