--- Dialog template mixin
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
