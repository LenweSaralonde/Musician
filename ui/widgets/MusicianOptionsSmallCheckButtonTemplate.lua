--- Small Checkbox template
-- @module MusicianOptionsSmallCheckButtonTemplate

--- OnClick
--
function MusicianOptionsSmallCheckButtonTemplate_OnClick(self)
	PlaySound(self:GetChecked() and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
end