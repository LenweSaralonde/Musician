--- Standard button with LED template
-- @module MusicianLEDTextButtonTemplate

--- OnLoad
-- @param self (Frame)
function MusicianLEDTextButtonTemplate_OnLoad(self)
	self.ledOff:SetDrawLayer("OVERLAY", 1)
	self.led:SetDrawLayer("OVERLAY", 2)
	self.led:SetAlpha(0)
	self.oldPoint = { self.ledOff:GetPoint() }
end

--- OnMouseDown
-- @param self (Frame)
function MusicianLEDTextButtonTemplate_OnMouseDown(self)
	if self:IsEnabled() then
		local point, relativeTo, relativePoint, x, y = unpack(self.oldPoint)
		local ox, oy = self:GetPushedTextOffset()
		self.ledOff:SetPoint(point, relativeTo, relativePoint, x + ox, y + oy)
	end
end

--- OnMouseUp
-- @param self (Frame)
function MusicianLEDTextButtonTemplate_OnMouseUp(self)
	if self:IsEnabled() then
		self.ledOff:SetPoint(unpack(self.oldPoint))
	end
end