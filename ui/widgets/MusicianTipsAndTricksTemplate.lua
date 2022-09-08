--- Tips and tricks window template
-- @module MusicianTipsAndTricksTemplate

--- OnShow
--
function MusicianTipsAndTricksTemplate_OnShow(self)
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
	self:SetChecked(Musician_Settings.enableTipsAndTricks)
end

--- Enable checkbox OnLoad
--
function MusicianTipsAndTricksTemplateEnableTipsAndTricks_OnLoad(self)
	_G[self:GetName().."Text"]:SetText(Musician.Msg.TIPS_AND_TRICKS_ENABLE)
	self:SetHitRectInsets(0, -_G[self:GetName().."Text"]:GetWidth(), 0, 0)
end

MusicianTipsAndTricksTemplateEnableTipsAndTricksMixin = {}

--- Enable checkbox SetValue
--
function MusicianTipsAndTricksTemplateEnableTipsAndTricksMixin:SetValue(value)
	Musician_Settings.enableTipsAndTricks = value == 1
end
