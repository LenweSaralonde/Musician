--- Basic message dialog mixin
-- @module MusicianBasicMessageDialogMixin

MusicianBasicMessageDialogMixin = {}

--- OnLoad
--
function MusicianBasicMessageDialogMixin:OnLoad()
	Musician.EnableHyperlinks(self)

	self.button:SetScript("OnClick", function()
		self:Hide()
	end)
end