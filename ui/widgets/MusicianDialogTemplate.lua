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
-- @param self (Frame)
function MusicianDialogTemplate_OnLoad(self)
	Musician.RestoreFramePosition(self)
	self:RegisterForDrag("LeftButton")
end

--- OnDragStart
-- @param self (Frame)
function MusicianDialogTemplate_OnDragStart(self)
	self:StartMoving()
end

--- OnDragStop
-- @param self (Frame)
function MusicianDialogTemplate_OnDragStop(self)
	self:StopMovingOrSizing()
	Musician.SaveFramePosition(self)
end

--- OnKeyDown
-- @param self (Frame)
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
function MusicianDialogTemplate_OnShow()
	PlaySound(SOUNDKIT.IG_QUEST_LIST_OPEN)
end

--- OnHide
--
function MusicianDialogTemplate_OnHide()
	PlaySound(SOUNDKIT.IG_QUEST_LIST_CLOSE)
end
