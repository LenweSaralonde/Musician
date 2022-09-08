--- Dialog template mixin
-- @module MusicianDialogTemplateMixin

MusicianDialogTemplateMixin = {}

--- Toggle visibility
--
function MusicianDialogTemplateMixin:Toggle()
	if self:IsVisible() then
		self:Hide()
	else
		self:Show()
	end
end

--- OnLoad
--
function MusicianDialogTemplateMixin:OnLoad()
	Musician.RestoreFramePosition(self)
	self:RegisterForDrag("LeftButton")
end

--- OnDragStart
--
function MusicianDialogTemplateMixin:OnDragStart()
	self:StartMoving()
end

--- OnDragStop
--
function MusicianDialogTemplateMixin:OnDragStop()
	self:StopMovingOrSizing()
	Musician.SaveFramePosition(self)
end

--- OnKeyDown
-- @param key (string)
function MusicianDialogTemplateMixin:OnKeyDown(key)
	if self:IsShown() and key == "ESCAPE" and not(self.noEscape) then
		self:SetPropagateKeyboardInput(false)
		self:Hide()
	else
		self:SetPropagateKeyboardInput(true)
	end
end

--- OnShow
--
function MusicianDialogTemplateMixin:OnShow()
	PlaySound(SOUNDKIT.IG_QUEST_LIST_OPEN)
end

--- OnHide
--
function MusicianDialogTemplateMixin:OnHide()
	PlaySound(SOUNDKIT.IG_QUEST_LIST_CLOSE)
end
