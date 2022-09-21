--- Standard edit box template
-- @module MusicianEditBoxTemplate

MusicianEditBoxTemplateMixin = {}

--- Disable
--
function MusicianEditBoxTemplateMixin:Disable()
	getmetatable(self).__index.Disable(self)
	local text = _G[self:GetName() .. "Label"]
	text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
end

--- Enable
--
function MusicianEditBoxTemplateMixin:Enable()
	getmetatable(self).__index.Enable(self)
	local text = _G[self:GetName() .. "Label"]
	local fontObject = text:GetFontObject()
	text:SetTextColor(fontObject:GetTextColor())
end