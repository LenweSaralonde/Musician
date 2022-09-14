--- URL Hyperlink selector
-- @module Musician.UrlHyperlinkSelector

Musician.UrlHyperlinkSelector = LibStub("AceAddon-3.0"):NewAddon("Musician.UrlHyperlinkSelector")

local MODULE_NAME = "Musician.UrlHyperlinkSelector"
Musician.AddModule(MODULE_NAME)

-- Currently active URL hyperlink
local currentHyperlink

-- Main frame mixin
MusicianUrlHyperlinkSelectorMixin = {}

--- Indicates if Ctrl or Cmd key is down, depending on the current OS.
-- @return isCtrl (boolean)
local function isCtrlKeyDown()
	if IsMacClient() then
		return IsMetaKeyDown()
	end
	return IsControlKeyDown()
end

--- OnLoad handler
--
function MusicianUrlHyperlinkSelectorMixin:OnLoad()

	local editBox = self.editBox

	-- Create tooltip
	self.tooltip = CreateFrame("GameTooltip", "MusicianUrlHyperlinkSelectorMixinTooltip", nil, "SharedTooltipTemplate")
	local tooltip = self.tooltip
	local font = GameFontNormalSmall
	local shortcut
	if IsMacClient() then
		shortcut = "cmd" .. Musician.Utils.GetChatIcon(Musician.IconImages.Cmd, 1, 1, 1) .. "+C"
	else
		shortcut = "Ctrl+C"
	end
	local tooltipText = string.gsub(Musician.Msg.TOOLTIP_COPY_URL, '{shortcut}', Musician.Utils.Highlight(shortcut))
	tooltip.TextLeft1:SetFontObject(font)
	tooltip.TextRight1:SetFontObject(font)

	-- Close on escape
	editBox:SetScript("OnEscapePressed", function()
		self:Hide()
	end)

	-- Close when EditBox focus is lost
	editBox:SetScript("OnEditFocusLost", function()
		self:Hide()
	end)

	-- Close the selector when a CTRL+C is registered
	editBox:SetScript("OnKeyDown", function(_, key)
		if isCtrlKeyDown() and key == "C" then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
			self:Hide()
		end
	end)

	-- Make the EditBox readonly
	hooksecurefunc(editBox, 'SetText', function(_, text)
		editBox.readonlyText = text
	end)
	editBox:SetScript("OnChar", function()
		-- Call native editBox SetText(), ignoring the hook
		getmetatable(editBox).__index.SetText(editBox, editBox.readonlyText)
		editBox:HighlightText()
	end)
	editBox:SetScript("OnCursorChanged", function()
		editBox:HighlightText()
	end)

	-- Show tooltip on focus
	editBox:SetScript("OnEditFocusGained", function()
		tooltip:SetOwner(self, "ANCHOR_TOP")
		tooltip:SetText(tooltipText, font:GetTextColor())
		tooltip:Show()
	end)

	-- Hide tooltip on hide
	self:SetScript("OnHide", function()
		tooltip:Hide()
	end)
end

--- Hyperlink mouse enter handler
-- @param self (Frame)
-- @param link (string)
-- @param text (string)
-- @param fontstring (FontString)
-- @param x (number)
-- @param y (number)
-- @param width (number)
-- @param height (number)
function Musician.UrlHyperlinkSelector.OnHyperlinkEnter(self, link, text, fontstring, x, y, width, height)
	-- Pack hyperlink specs for further use in click handler
	currentHyperlink = { link, text, fontstring, x, y, width, height }
end

--- Hyperlink mouse leave handler
-- @param self (Frame)
function Musician.UrlHyperlinkSelector.OnHyperlinkLeave(self)
	if currentHyperlink then
		currentHyperlink = nil
	end
end

--- Hyperlink click handler
-- @param self (Frame)
-- @param link (string)
-- @param text (string)
function Musician.UrlHyperlinkSelector.OnHyperlinkClick(self, link, text)
	-- Hyperlink was not properly activated
	if currentHyperlink == nil then return end

	-- Extract URL and parameters
	local url = Musician.Utils.RemoveHighlight(Musician.Utils.RemoveLinks(text))
	local _, _, fontstring, x, y, width, height = unpack(currentHyperlink)

	local selector = MusicianUrlHyperlinkSelector
	local editBox = selector.editBox

	-- Attach selector to the fontstring
	selector:SetParent(self)
	selector:ClearAllPoints()
	selector:SetPoint('TOPLEFT', fontstring, 'TOPLEFT', x, y)
	selector:SetSize(width, height)

	-- Copy font style
	editBox:SetFontObject(fontstring:GetFontObject())
	editBox:SetTextColor(0, 1, 1, 1)

	-- Set URL
	editBox:SetText(url)

	-- Show and focus EditBox
	selector:Show()
	editBox:HighlightText()
	editBox:SetFocus()
end