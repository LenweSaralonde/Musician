--- Dropdown menu with tooltip template
-- @module MusicianDropDownMenuTooltipTemplate

local IS_MAINLINE = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE

local SCREEN_MARGIN = 16
local SCROLLBAR_WIDTH = IS_MAINLINE and 10 or 18
local SCROLLBAR_MARGIN = IS_MAINLINE and 16 or 8
local SCROLLBAR_STEPPER_HEIGHT = IS_MAINLINE and 0 or 10 -- Classic up and down buttons are outside the slider
local SCROLL_STEP = 3

local specialFrameToRestore = nil
local hooksInitialized = false
local rootOpener = nil

--- Return the list button frame for the provided index
-- @param listFrame (Frame)
-- @param index (int)
-- @return button (Button)
local function getListButton(listFrame, index)
	return _G[listFrame:GetName() .. "Button" .. index]
end

--- Create a minimal scroll bar, as used in the retail scroll frames
-- @param listFrame (Frame)
-- @return scrollBar (EventFrame)
local function createMinimalScrollBar(listFrame)
	local bar = CreateFrame("EventFrame", nil, listFrame, "MinimalScrollBar")

	bar:RegisterCallback(BaseScrollBoxEvents.OnScroll, function(_, scrollPercentage)
		bar.onScroll(floor(scrollPercentage * bar.maxOffset + .5))
	end, bar)

	bar.SetRange = function(_, visibleRows, numRows)
		bar.maxOffset = numRows - visibleRows
		bar:Init(visibleRows / numRows, 1 / bar.maxOffset)
	end

	bar.ScrollTo = function(_, offset)
		bar:SetScrollPercentage(offset / bar.maxOffset, true)
	end

	bar.ScrollBy = function(_, rows)
		bar:ScrollInDirection(abs(rows) / bar.maxOffset, rows > 0 and 1 or -1)
	end

	return bar
end

--- Create a panel scroll bar, as used in the classic scroll frames
-- @param listFrame (Frame)
-- @return scrollBar (Slider)
local function createPanelScrollBar(listFrame)
	local bar = CreateFrame("Slider", "MusicianDropDownMenuScrollBar" .. listFrame:GetID(), listFrame,
		"UIPanelScrollBarTemplate")
	bar.scrollStep = 1
	bar:SetValueStep(1)
	bar:SetObeyStepOnDrag(true)

	bar:SetScript("OnValueChanged", function(self, value)
		local _, maxValue = self:GetMinMaxValues()
		self.ScrollUpButton:SetEnabled(value > 0)
		self.ScrollDownButton:SetEnabled(value < maxValue)
		self.onScroll(floor(value + .5))
	end)

	bar.SetRange = function(_, visibleRows, numRows)
		bar:SetMinMaxValues(0, numRows - visibleRows)
	end

	bar.ScrollTo = function(_, offset)
		bar:SetValue(offset)
		bar:GetScript("OnValueChanged")(bar, bar:GetValue())
	end

	bar.ScrollBy = function(_, rows)
		bar:SetValue(bar:GetValue() + rows)
	end

	return bar
end

--- Return the scroll bar of the list frame, creating it if needed
-- @param listFrame (Frame)
-- @return scrollBar (Frame)
local function getScrollBar(listFrame)
	if listFrame.musicianScrollBar then return listFrame.musicianScrollBar end

	local bar = IS_MAINLINE and createMinimalScrollBar(listFrame) or createPanelScrollBar(listFrame)
	bar:Hide()
	bar:SetWidth(SCROLLBAR_WIDTH)
	bar:SetPoint("TOPRIGHT", -SCROLLBAR_MARGIN, -MSA_DROPDOWNMENU_BORDER_HEIGHT - SCROLLBAR_STEPPER_HEIGHT)
	bar:SetPoint("BOTTOMRIGHT", -SCROLLBAR_MARGIN, MSA_DROPDOWNMENU_BORDER_HEIGHT + SCROLLBAR_STEPPER_HEIGHT)
	bar:SetFrameLevel(listFrame:GetFrameLevel() + 5)
	bar.onScroll = function() end

	listFrame.musicianScrollBar = bar
	return bar
end

--- Disable scrolling on the list frame
-- @param listFrame (Frame)
local function disableScrolling(listFrame)
	if not listFrame.musicianScrolling then return end
	listFrame.musicianScrolling = nil
	listFrame.musicianScrollBar:Hide()
	listFrame:EnableMouseWheel(false)
	listFrame:SetScript("OnMouseWheel", nil)
end

--- Enable scrolling on the list frame if it does not fit in the screen height
-- @param listFrame (Frame)
local function enableScrolling(listFrame)
	local buttonHeight = MSA_DROPDOWNMENU_BUTTON_HEIGHT
	local borderHeight = MSA_DROPDOWNMENU_BORDER_HEIGHT
	local numButtons = listFrame.numButtons

	-- Available screen height, in list frame coordinates
	local scale = UIParent:GetEffectiveScale() / listFrame:GetEffectiveScale()
	local screenTop = UIParent:GetTop() * scale
	local maxHeight = UIParent:GetHeight() * scale - 2 * SCREEN_MARGIN

	if listFrame:GetHeight() <= maxHeight then return end

	local visibleRows = max(1, floor((maxHeight - 2 * borderHeight) / buttonHeight))
	local maxOffset = numButtons - visibleRows
	if maxOffset <= 0 then return end

	listFrame.musicianScrolling = true

	-- Save original button positions, as set by MSA_DropDownMenu_AddButton
	for index = 1, numButtons do
		local button = getListButton(listFrame, index)
		local _, _, _, x, y = button:GetPoint(1)
		button.musicianOriginalX = x
		button.musicianOriginalY = y
	end

	-- Resize the list frame
	local height = visibleRows * buttonHeight + 2 * borderHeight
	listFrame:SetHeight(height)
	listFrame:SetWidth(listFrame:GetWidth() + SCROLLBAR_WIDTH + SCROLLBAR_MARGIN)

	-- Move the list frame back inside the screen
	local top, bottom = listFrame:GetTop(), listFrame:GetBottom()
	local yAddOffset = 0
	if top > screenTop - SCREEN_MARGIN then
		yAddOffset = screenTop - SCREEN_MARGIN - top
	elseif bottom < SCREEN_MARGIN then
		yAddOffset = SCREEN_MARGIN - bottom
	end
	if yAddOffset ~= 0 then
		local point, relativeTo, relativePoint, x, y = listFrame:GetPoint(1)
		listFrame:ClearAllPoints()
		listFrame:SetPoint(point, relativeTo, relativePoint, x, y + yAddOffset)
	end

	-- Scroll bar
	local bar = getScrollBar(listFrame)
	local currentOffset = nil
	bar.onScroll = function(offset)
		if offset == currentOffset then return end
		currentOffset = offset

		-- Close sub menus since their opener button may move or get hidden
		MSA_CloseDropDownMenus(listFrame:GetID() + 1)

		local shift = offset * buttonHeight
		local minY = -height + borderHeight + buttonHeight
		for index = 1, numButtons do
			local button = getListButton(listFrame, index)
			local y = button.musicianOriginalY + shift
			button:ClearAllPoints()
			button:SetPoint("TOPLEFT", listFrame, "TOPLEFT", button.musicianOriginalX, y)
			button:SetShown(y <= -borderHeight + .5 and y >= minY - .5)
		end
	end
	bar:SetRange(visibleRows, numButtons)
	bar:Show()

	-- Mouse wheel
	listFrame:EnableMouseWheel(true)
	listFrame:SetScript("OnMouseWheel", function(_, delta)
		bar:ScrollBy(-delta * SCROLL_STEP)
	end)

	-- Initial scroll position: center the checked item
	local offset = 0
	for index = 1, numButtons do
		local button = getListButton(listFrame, index)
		local checked = button.checked
		if type(checked) == "function" then
			checked = checked(button)
		end
		if checked then
			offset = min(maxOffset, max(0, index - ceil(visibleRows / 2)))
			break
		end
	end
	bar:ScrollTo(offset)
end

--- Disable the escape key for the dropdown menu
--
local function disableEscape()
	for index = #UISpecialFrames, 1, -1 do
		local frameName = UISpecialFrames[index]
		if string.match(frameName, "MSA[0-9]*_DropDownList[0-9]+") then
			table.remove(UISpecialFrames, index)
		end
	end
end

--- Set the escape key for the provided dropdown menu level
-- @param level (int)
local function enableEscape(level)
	disableEscape()
	table.insert(UISpecialFrames, Musician.Utils.GetDropDownList(level):GetName())
end

--- Initialize MSA Hooks
--
local function initializeHooks()
	if hooksInitialized then return end

	hooksInitialized = true

	hooksecurefunc('MSA_ToggleDropDownMenu',
		function(level, _, dropDownFrame, _, _, _, _, button, _)
			level = level or 1
			local frame = Musician.Utils.GetDropDownList(level)

			if frame and frame:IsShown() then
				local opener = (dropDownFrame or button:GetParent())

				-- Set root opener
				if level == 1 then
					rootOpener = opener
				end

				-- Ignore if the root opener is not a MusicianDropDownMenuTooltipTemplate
				if not rootOpener or not rootOpener.hasEscape then return end

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

	-- Make the dropdown list scrollable when it does not fit in the screen
	hooksecurefunc('MSA_ToggleDropDownMenu', function(level)
		local listFrame = Musician.Utils.GetDropDownList(level or 1)
		local dropdown = MSA_DROPDOWNMENU_OPEN_MENU
		if listFrame and listFrame:IsShown() and dropdown and dropdown.isScrollable then
			enableScrolling(listFrame)
		end
	end)

	hooksecurefunc('MSA_DropDownMenu_OnHide', disableScrolling)

	hooksecurefunc('MSA_DropDownMenu_OnHide', function(frame)
		if not rootOpener or not rootOpener.hasEscape then return end

		local level = string.gsub(frame:GetName(), 'MSA[0-9]*_DropDownList', '') + 0

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
	self.isScrollable = true
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