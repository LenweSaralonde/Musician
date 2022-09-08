--- Dropdown menu with tooltip template
-- @module MusicianDropDownMenuTooltipTemplate

MusicianDropDownMenuTooltipTemplateMixin = {}

--- OnLoad
--
function MusicianDropDownMenuTooltipTemplateMixin:OnLoad()
	MSA_DropDownMenu_Create(self, self:GetParent())
end

--- OnKeyDown
-- @param key (string)
function MusicianDropDownMenuTooltipTemplateMixin:OnKeyDown(key)
	if MSA_DropDownList1:IsShown() and key == "ESCAPE" then
		self:SetPropagateKeyboardInput(false)
		MSA_DropDownMenu_OnHide(self)
	else
		self:SetPropagateKeyboardInput(true)
	end
end

--- OnEnter
--
function MusicianDropDownMenuTooltipTemplateMixin:OnEnter()
	if (self.tooltipText ~= nil) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip_SetTitle(GameTooltip, self.tooltipText)
		GameTooltip:Show()
	end
end

--- OnLeave
--
function MusicianDropDownMenuTooltipTemplateMixin:OnLeave()
	if (self.tooltipText ~= nil) then
		GameTooltip:Hide()
	end
end