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
	self:RegisterForDrag("LeftButton")

	-- Slightly rescale the close button on Retail
	if LE_EXPANSION_LEVEL_CURRENT >= 9 then
		self.close:SetScale(.75)
		self.close:SetPoint("CENTER", self, "TOPRIGHT", -10, -10)
	end
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
end

--- OnKeyDown
-- @param self (Frame)
-- @param key (string)
function MusicianDialogTemplate_OnKeyDown(self, key)
	if self:IsShown() and key == "ESCAPE" and not self.noEscape then
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