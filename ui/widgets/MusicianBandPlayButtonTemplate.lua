--- Band play button template
-- @module MusicianBandPlayButtonTemplate

MusicianBandPlayButtonTemplateMixin = {}

--- OnLoad
--
function MusicianBandPlayButtonTemplateMixin:OnLoad()
	self.tooltipText = Musician.Msg.PLAY_IN_BAND
	self:SetText(Musician.Icons.BandPlay)
	self.led:SetVertexColor(.33, 1, 0, 1)
	self:SetChecked(false)
	self.count.texture:SetVertexColor(1, .82, 0)
end

--- OnUpdate
-- @param elapsed (number)
function MusicianBandPlayButtonTemplateMixin:OnUpdate(elapsed)
	if self.checked and self.blinking then
		self.blinkTime = self.blinkTime + elapsed
		self.led:SetAlpha(abs(1 - 2 * (4 * self.blinkTime % 1)))
	end
end

--- OnClick
--
function MusicianBandPlayButtonTemplateMixin:OnClick()
	PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
end

--- OnEnter
--
function MusicianBandPlayButtonTemplateMixin:OnEnter()
	self.mouseOver = true
end

--- OnLeave
--
function MusicianBandPlayButtonTemplateMixin:OnLeave()
	self.mouseOver = false
end

--- Set the button checked
-- @param checked (boolean)
function MusicianBandPlayButtonTemplateMixin:SetChecked(checked)
	self.checked = checked
	if checked then
		self.led:SetAlpha(1)
	else
		self.led:SetAlpha(0)
	end
end

--- Set the LED blinking
-- @param blinking (boolean)
function MusicianBandPlayButtonTemplateMixin:SetBlinking(blinking)
	self.blinking = blinking
	self.blinkTime = 0
	self:SetChecked(self.checked)
end

--- Set the tooltip text
-- @param text (string)
function MusicianBandPlayButtonTemplateMixin:SetTooltipText(text)
	self.tooltipText = text
	if self.mouseOver then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip_SetTitle(GameTooltip, self.tooltipText)
		GameTooltip:Show()
	end
end

