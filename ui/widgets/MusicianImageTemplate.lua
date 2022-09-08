--- Image template
-- @module MusicianImageTemplate

--- OnLoad
--
function MusicianImageTemplate_OnLoad(self)
	self.texture = self:CreateTexture(nil, "ARTWORK", nil, 7)
	self.texture:SetAllPoints(self)
	self:Hide()
	self.textureFile = 1
end

--- OnShow
--
function MusicianImageTemplate_OnShow(self)
	self.texture:SetTexture(self.textureFile)
end

--- OnHide
--
function MusicianImageTemplate_OnHide(self)
	self.texture:SetTexture(1)
end
