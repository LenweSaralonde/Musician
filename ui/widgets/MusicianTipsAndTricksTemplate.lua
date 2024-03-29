--- Tips and tricks window template
-- @module MusicianTipsAndTricksTemplate

--- OnShow
--
function MusicianTipsAndTricksTemplate_OnShow(self)
	self:SetParent(UIParent)
	PlaySound(SOUNDKIT.IG_QUEST_LIST_OPEN)
end

--- OnHide
--
function MusicianTipsAndTricksTemplate_OnHide(self)
	PlaySound(SOUNDKIT.IG_QUEST_LIST_CLOSE)
end

--- Enable checkbox OnShow
--
function MusicianTipsAndTricksTemplateEnableTipsAndTricks_OnShow(self)
	local isEnabled = Musician_Settings == nil or Musician_Settings.enableTipsAndTricks == nil or Musician_Settings.enableTipsAndTricks
	self:SetChecked(isEnabled)
end

--- Enable checkbox OnLoad
--
function MusicianTipsAndTricksTemplateEnableTipsAndTricks_OnLoad(self)
	self.Text:SetText(Musician.Msg.TIPS_AND_TRICKS_ENABLE)
	self:SetHitRectInsets(0, -self.Text:GetWidth(), 0, 0)
end

--- Enable checkbox OnClick
--
function MusicianTipsAndTricksTemplateEnableTipsAndTricks_OnClick(self)
	Musician_Settings.enableTipsAndTricks = self:GetChecked()
end