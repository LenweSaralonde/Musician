--- Dialog template
-- @module MusicianDialogTemplate

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
function MusicianDialogTemplate_OnLoad(self)
	Musician.RestoreFramePosition(self)
	self:RegisterForDrag("LeftButton")
end

--- OnDragStart
--
function MusicianDialogTemplate_OnDragStart(self)
	self:StartMoving()
end

--- OnDragStop
--
function MusicianDialogTemplate_OnDragStop(self)
	self:StopMovingOrSizing()
	Musician.SaveFramePosition(self)
end

--- OnKeyDown
-- @param key (string)
function MusicianDialogTemplate_OnKeyDown(self, key)
	if self:IsShown() and key == "ESCAPE" and not(self.noEscape) then
		self:SetPropagateKeyboardInput(false)
		self:Hide()
	else
		self:SetPropagateKeyboardInput(true)
	end
end

--- OnShow
--
function MusicianDialogTemplate_OnShow(self)
	PlaySound(SOUNDKIT.IG_QUEST_LIST_OPEN)
end

--- OnHide
--
function MusicianDialogTemplate_OnHide(self)
	PlaySound(SOUNDKIT.IG_QUEST_LIST_CLOSE)
end
