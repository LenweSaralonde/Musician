--- MSA-DropDownMenu-1.0 - DropDown menu for non-Blizzard addons
--- Copyright (c) 2016-2026, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- https://www.curseforge.com/wow/addons/msa-dropdownmenu-10

-- Custom dropdown buttons are instantiated by some external system.
-- When calling MSA_DropDownMenu_AddButton that system sets info.customFrame to the instance of the frame it wants to place on the menu.
-- The dropdown menu creates its button for the entry as it normally would, but hides all elements.  The custom frame is then anchored
-- to that button and assumes responsibility for all relevant dropdown menu operations.
-- The hidden button will request a size that it should become from the custom frame.

MSA_DropDownMenuButtonMixin = {};

function MSA_DropDownMenuButtonMixin:OnEnter(...)
    ExecuteFrameScript(self:GetParent(), "OnEnter", ...);
end

function MSA_DropDownMenuButtonMixin:OnLeave(...)
    ExecuteFrameScript(self:GetParent(), "OnLeave", ...);
end

function MSA_DropDownMenuButtonMixin:OnMouseDown(button)
    if self:IsEnabled() then
        MSA_ToggleDropDownMenu(nil, nil, self:GetParent());
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
    end
end

MSA_DropDownExpandArrowMixin = {};

function MSA_DropDownExpandArrowMixin:OnEnter()
    local level =  self:GetParent():GetParent():GetID() + 1;

    MSA_CloseDropDownMenus(level);

    if self:IsEnabled() then
        local listFrame = _G["MSA_DropDownList"..level];
        if ( not listFrame or not listFrame:IsShown() or select(2, listFrame:GetPoint(1)) ~= self ) then
            MSA_ToggleDropDownMenu(level, self:GetParent().value, nil, nil, nil, nil, self:GetParent().menuList, self, nil, self:GetParent().menuListDisplayMode);
        end
    end
end

function MSA_DropDownExpandArrowMixin:OnMouseDown(button)
    if self:IsEnabled() then
        MSA_ToggleDropDownMenu(self:GetParent():GetParent():GetID() + 1, self:GetParent().value, nil, nil, nil, nil, self:GetParent().menuList, self, nil, self:GetParent().menuListDisplayMode);
    end
end

MSA_DropDownCustomMenuEntryMixin = {};

function MSA_DropDownCustomMenuEntryMixin:GetPreferredEntryWidth()
    return self:GetWidth();
end

function MSA_DropDownCustomMenuEntryMixin:GetPreferredEntryHeight()
    return self:GetHeight();
end

function MSA_DropDownCustomMenuEntryMixin:OnSetOwningButton()
    -- for derived objects to implement
end

function MSA_DropDownCustomMenuEntryMixin:SetOwningButton(button)
    self:SetParent(button:GetParent());
    self.owningButton = button;
    self:OnSetOwningButton();
end

function MSA_DropDownCustomMenuEntryMixin:GetOwningDropdown()
    return self.owningButton:GetParent();
end

function MSA_DropDownCustomMenuEntryMixin:SetContextData(contextData)
    self.contextData = contextData;
end

function MSA_DropDownCustomMenuEntryMixin:GetContextData()
    return self.contextData;
end