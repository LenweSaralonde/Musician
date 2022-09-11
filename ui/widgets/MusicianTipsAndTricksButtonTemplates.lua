--- Tips and tricks window buttons templates
-- @module MusicianTipsAndTricksButtonTemplates

--- Cancel button OnLoad
--
function MusicianTipsAndTricksCancelButtonTemplate_OnLoad(self)
	hooksecurefunc(self, "SetText", function()
		self:SetWidth(self.Text:GetStringWidth() + 24)
	end)
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
	hooksecurefunc(self, "SetText", function()
		self:SetWidth(max(128, self.Text:GetStringWidth() + 40))
	end)
end

--- OK button OnClick
--
function MusicianTipsAndTricksOkButtonTemplate_OnClick(self)
	Musician_UIPanelCloseButton_OnClick(self)
end
