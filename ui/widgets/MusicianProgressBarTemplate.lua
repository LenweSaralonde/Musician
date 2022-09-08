--- Progress bar template
-- @module MusicianProgressBarTemplate

MusicianProgressBarTemplateMixin = {}

--- Set progression
-- @param progression (number) 0-1
function MusicianProgressBarTemplateMixin:SetProgress(progression)
	self.fill:SetWidth(progression * self:GetWidth())
end