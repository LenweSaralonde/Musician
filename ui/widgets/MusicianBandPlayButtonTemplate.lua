--- Band play button template
-- @module MusicianBandPlayButtonTemplate

MusicianBandPlayButtonTemplateMixin = {}

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

--- OnLoad
-- @param self (Frame)
function MusicianBandPlayButtonTemplate_OnLoad(self)
	self.tooltipText = Musician.Msg.PLAY_IN_BAND
	self:SetText(Musician.Icons.BandPlay)
	self.led:SetVertexColor(.33, 1, 0, 1)
	self:SetChecked(false)
	self.count.texture:SetVertexColor(1, .82, 0)
end

--- OnUpdate
-- @param self (Frame)
-- @param elapsed (number)
function MusicianBandPlayButtonTemplate_OnUpdate(self, elapsed)
	if self.checked and self.blinking then
		self.blinkTime = self.blinkTime + elapsed
		self.led:SetAlpha(abs(1 - 2 * (4 * self.blinkTime % 1)))
	end
end

--- OnClick
--
function MusicianBandPlayButtonTemplate_OnClick()
	PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
end

--- OnEnter
-- @param self (Frame)
function MusicianBandPlayButtonTemplate_OnEnter(self)
	self.mouseOver = true
end

--- OnLeave
-- @param self (Frame)
function MusicianBandPlayButtonTemplate_OnLeave(self)
	self.mouseOver = false
end
