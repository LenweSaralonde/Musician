--- Widget global functions
-- @module Musician.Widgets

Musician_UIPanelCloseButton_OnClick = _G["UIPanelCloseButton_OnClick"] or function(self)
	local parent = self:GetParent();
	if parent then
		if parent.onCloseCallback then
			parent.onCloseCallback(self);
		else
			HideUIPanel(parent);
		end
	end
end
