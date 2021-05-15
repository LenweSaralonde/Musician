--- Widget global functions
-- @module Musician.Widgets

-- A bit ugly, we want the talent frame to display a dialog box in certain conditions.
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
