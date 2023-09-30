--- Dropdown menu with tooltip template
-- @module MusicianDropDownMenuTooltipTemplate

--- OnLoad
-- @param self (Frame)
function MusicianDropDownMenuTooltipTemplate_OnLoad(self)
	MSA_DropDownMenu_Create(self, self:GetParent())
end

--- OnKeyDown
-- @param self (Frame)
-- @param key (string)
function MusicianDropDownMenuTooltipTemplate_OnKeyDown(self, key)
	if MSA_DropDownList1:IsShown() and key == "ESCAPE" then
		Musician.Utils.SetPropagateKeyboardInput(self, false)
		MSA_DropDownMenu_OnHide(self)
	else
		Musician.Utils.SetPropagateKeyboardInput(self, true)
	end
end

--- OnEnter
-- @param self (Frame)
function MusicianDropDownMenuTooltipTemplate_OnEnter(self)
	if (self.tooltipText ~= nil) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip_SetTitle(GameTooltip, self.tooltipText)
		GameTooltip:Show()
	end
end

--- OnLeave
-- @param self (Frame)
function MusicianDropDownMenuTooltipTemplate_OnLeave(self)
	if (self.tooltipText ~= nil) then
		GameTooltip:Hide()
	end
end