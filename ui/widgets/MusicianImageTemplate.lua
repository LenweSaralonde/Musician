--- Image template
-- @module MusicianImageTemplate

MusicianImageTemplateMixin = {}

--- OnLoad
--
function MusicianImageTemplateMixin:OnLoad()
	self.texture = self:CreateTexture(nil, "ARTWORK", nil, 7)
	self.texture:SetAllPoints(self)
	self:Hide()
	self.textureFile = 1
end

--- OnShow
--
function MusicianImageTemplateMixin:OnShow()
	self.texture:SetTexture(self.textureFile)
end

--- OnHide
--
function MusicianImageTemplateMixin:OnHide()
	self.texture:SetTexture(1)
end
