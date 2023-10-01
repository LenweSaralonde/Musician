--- Dropdown menu with tooltip template
-- @module MusicianDropDownMenuTooltipTemplate

local specialFrameToRestore = nil
local hooksInitialized = false
local rootOpener = nil

--- Disable the escape key for the dropdown menu
--
local function disableEscape()
	for index = #UISpecialFrames, 1, -1 do
		local frameName = UISpecialFrames[index]
		if string.match(frameName, "MSA_DropDownList[0-9]+") then
			table.remove(UISpecialFrames, index)
		end
	end
end

--- Set the escape key for the provided dropdown menu level
-- @param level (int)
local function enableEscape(level)
	disableEscape()
	table.insert(UISpecialFrames, 'MSA_DropDownList' .. level)
end

--- Initialize MSA Hooks
--
local function initializeHooks()
	if hooksInitialized then return end

	hooksInitialized = true

	hooksecurefunc('MSA_ToggleDropDownMenu',
		function(level, _, dropDownFrame, _, _, _, _, button, _)
			level = level or 1
			local frame = _G["MSA_DropDownList" .. level]

			if frame:IsShown() then
				local opener = (dropDownFrame or button:GetParent())

				-- Set root opener
				if level == 1 then
					rootOpener = opener
				end

				-- Ignore if the root opener is not a MusicianDropDownMenuTooltipTemplate
				if not rootOpener.hasEscape then return end

				-- Enable escape for the current level
				enableEscape(level)

				-- Remove escape from parent while the menu is open
				local parent = rootOpener:GetParent()

				if level == 1 then
					for index, frameName in pairs(UISpecialFrames) do
						local parentOfParent = parent
						while parentOfParent ~= nil do
							if frameName == parentOfParent:GetName() then
								table.remove(UISpecialFrames, index)
								specialFrameToRestore = parentOfParent:GetName()
								return
							end
							parentOfParent = parentOfParent:GetParent()
						end
					end
				end
			end
		end)

	hooksecurefunc('MSA_DropDownMenu_OnHide', function(frame)
		if not rootOpener.hasEscape then return end

		local level = string.gsub(frame:GetName(), 'MSA_DropDownList', '') + 0

		if (level == 1) then
			-- Restore escape for the parent
			disableEscape()
			if specialFrameToRestore then
				table.insert(UISpecialFrames, specialFrameToRestore)
				specialFrameToRestore = nil
			end
		else
			-- Enable escape for the previous level
			enableEscape(level - 1)
		end
	end)
end

--- OnLoad
-- @param self (Frame)
function MusicianDropDownMenuTooltipTemplate_OnLoad(self)
	initializeHooks()
	MSA_DropDownMenu_Create(self, self:GetParent())
	self.hasEscape = true
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