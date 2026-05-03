--- Live mode button template
-- @module MusicianLiveModeButtonTemplate

MusicianLiveModeButtonTemplateMixin = {}

local AceEvent = LibStub:GetLibrary("AceEvent-3.0")

--- Update the button
--
function MusicianLiveModeButtonTemplateMixin:Update()
	if Musician.Live.IsLiveEnabled() and Musician.Live.CanStream() then
		self.led:SetAlpha(1)
		self:RefreshBandwidthIndicator(nil, 0)
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

--- Refresh bandwidth indicator
-- @param event (string)
-- @param bandwidth (number)
function MusicianLiveModeButtonTemplateMixin:RefreshBandwidthIndicator(event, bandwidth)
	if not Musician.Live.IsLiveEnabled() or not Musician.Live.CanStream() then
		bandwidth = 0
	end

	self.led:SetVertexColor(Musician.Comm.GetBandwidthColor(bandwidth, true))

	-- Make the LED blink if the maximum bandwidth is reached
	if bandwidth == 1 then
		if self.blinkingTicker == nil then
			self.blinkingTicker = C_Timer.NewTicker(1 / 60, function()
				self.led:SetVertexColor(Musician.Comm.GetBandwidthColor(bandwidth, true))
			end)
		end
	elseif self.blinkingTicker then
		self.blinkingTicker:Cancel()
		self.blinkingTicker = nil
	end
end

--- OnLoad
-- @param self (Frame)
function MusicianLiveModeButtonTemplate_OnLoad(self)
	self:SetText(Musician.Msg.LIVE_MODE)
	self.led:SetVertexColor(.33, 1, 0, 1)
	AceEvent:Embed(self)
	self:RegisterMessage(Musician.Events.LiveModeChange, function() self:Update() end)
	self:RegisterMessage(Musician.Events.Bandwidth, function(...) self:RefreshBandwidthIndicator(...) end)
	self:Update()
end

--- OnClick
--
function MusicianLiveModeButtonTemplate_OnClick(self)
	Musician.Live.EnableLive(not Musician.Live.IsLiveEnabled())
	PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
end