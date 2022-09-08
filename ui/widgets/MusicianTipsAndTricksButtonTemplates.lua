--- Tips and tricks window buttons templates
-- @module MusicianTipsAndTricksButtonTemplates

--- Cancel button OnLoad
--
function MusicianTipsAndTricksCancelButtonTemplate_OnLoad(self)
	self:SetWidth(self.Text:GetStringWidth() + 24)
	self:GetHighlightTexture():SetTexCoord(0, 1, 0.2086, 0.5659)
end

--- Cancel button OnClick
--
function MusicianTipsAndTricksCancelButtonTemplate_OnClick(self)
	Musician_UIPanelCloseButton_OnClick(self)
end

--- OK button OnLoad
--
function MusicianTipsAndTricksOkButtonTemplate_OnLoad(self)
	self.background:SetDrawLayer("BACKGROUND", -8)
	self:SetWidth(max(128, self.Text:GetStringWidth() + 40))
	self:GetHighlightTexture():SetTexCoord(0, 1, 0.2086, 0.5659)
end

--- OK button OnClick
--
function MusicianTipsAndTricksOkButtonTemplate_OnClick(self)
	Musician_UIPanelCloseButton_OnClick(self)
end
