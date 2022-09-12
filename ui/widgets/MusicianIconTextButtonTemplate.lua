--- Standard button with text and icon template
-- @module MusicianIconTextButtonTemplate

--- OnEnter
--
function MusicianIconTextButtonTemplate_OnEnter(self)
	if self:IsEnabled() then
		self.icon:SetFontObject(MusicianFontIconsHighlight)
	end
end

--- OnLeave
--
function MusicianIconTextButtonTemplate_OnLeave(self)
	if self:IsEnabled() then
		self.icon:SetFontObject(MusicianFontIconsNormal)
	end
end

--- OnEnable
--
function MusicianIconTextButtonTemplate_OnEnable(self)
	self.icon:SetFontObject(MusicianFontIconsNormal)
end

--- OnDisable
--
function MusicianIconTextButtonTemplate_OnDisable(self)
	self.icon:SetFontObject(MusicianFontIconsDisable)
end

--- OnMouseDown
--
function MusicianIconTextButtonTemplate_OnMouseDown(self)
	if self:IsEnabled() then
		if not(self.icon.oldPoint) then
			local point, _, _, x, y = self.icon:GetPoint(1)
			self.icon.oldPoint = point
			self.icon.oldX = x
			self.icon.oldY = y
		end
		local ox, oy = self:GetPushedTextOffset()
		self.icon:SetPoint(self.icon.oldPoint, self.icon.oldX + ox, self.icon.oldY + oy)
	end
end

--- OnMouseUp
--
function MusicianIconTextButtonTemplate_OnMouseUp(self)
	if self:IsEnabled() and self.icon.oldPoint then
		self.icon:SetPoint(self.icon.oldPoint, self.icon.oldX, self.icon.oldY)
	end
end
