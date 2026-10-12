--- Dropdown with tooltip template
-- @module MusicianDropdownTemplate

local SCREEN_MARGIN = 16

--- Return the maximum height the menu can have without going off screen
-- @param dropdown (DropdownButton)
-- @return maxHeight (number)
local function getMaxMenuHeight(dropdown)
	local top, bottom = dropdown:GetTop(), dropdown:GetBottom()

	-- The frame has no position yet: the menu will be generated again when opened
	if not top or not bottom then
		return UIParent:GetHeight() - SCREEN_MARGIN
	end

	local scale = dropdown:GetEffectiveScale() / UIParent:GetEffectiveScale()
	local spaceBelow = bottom * scale
	local spaceAbove = UIParent:GetHeight() - top * scale
	return max(spaceBelow, spaceAbove) - SCREEN_MARGIN
end

--- OnLoad
-- @param self (DropdownButton)
function MusicianDropdownTemplate_OnLoad(self)
	self:HookScript("OnEnter", MusicianDropdownTemplate_OnEnter)
	self:HookScript("OnLeave", MusicianDropdownTemplate_OnLeave)

	--- Same as SetupMenu, making the menu scrollable when it does not fit in the screen
	-- @param generator (function)
	self.SetupScrollableMenu = function(generator)
		self:SetupMenu(function(dropdown, rootDescription)
			rootDescription:SetScrollMode(getMaxMenuHeight(self))
			generator(dropdown, rootDescription)
		end)
	end
end

--- OnEnter
-- @param self (DropdownButton)
function MusicianDropdownTemplate_OnEnter(self)
	if (self.tooltipText ~= nil) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip_SetTitle(GameTooltip, self.tooltipText)
		GameTooltip:Show()
	end
end

--- OnLeave
-- @param self (DropdownButton)
function MusicianDropdownTemplate_OnLeave(self)
	if (self.tooltipText ~= nil) then
		GameTooltip:Hide()
	end
end
