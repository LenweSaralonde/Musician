--- Standard edit box template
-- @module MusicianEditBoxTemplate

MusicianEditBoxTemplateMixin = {}

--- Disable
--
function MusicianEditBoxTemplateMixin:Disable()
	getmetatable(self).__index.Disable(self)
	self:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
	local label = _G[self:GetName() .. "Label"]
	if not label then return end
	label:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
end

--- Enable
--
function MusicianEditBoxTemplateMixin:Enable()
	getmetatable(self).__index.Enable(self)
	self:SetTextColor(WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	local label = _G[self:GetName() .. "Label"]
	if not label then return end
	label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
end