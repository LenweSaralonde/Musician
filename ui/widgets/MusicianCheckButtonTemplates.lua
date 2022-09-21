--- Check button templates
-- @module MusicianCheckButtonTemplates

--- OnClick
--
function MusicianCheckButtonTemplate_OnClick(self)
	PlaySound(self:GetChecked() and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
end

--- OnEnable
--
function MusicianCheckButtonTemplate_OnEnable(self)
	local fontObject = self.Text:GetFontObject()
	self.Text:SetTextColor(fontObject:GetTextColor())
end

--- OnDisable
--
function MusicianCheckButtonTemplate_OnDisable(self)
	self.Text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
end

--- OnEnter
--
function MusicianCheckButtonTemplate_OnEnter(self)
	if self.tooltipText ~= nil then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip_SetTitle(GameTooltip, self.tooltipText)
		GameTooltip:Show()
	end
end

--- OnLeave
--
function MusicianCheckButtonTemplate_OnLeave(self)
	if self.tooltipText ~= nil then
		GameTooltip:Hide()
	end
end

-- Hack to set an alias for addon backward compatibility.
function MusicianCheckButtonTemplate_SetParentKeyAlias(fontString)
	local parent = fontString:GetParent()
	parent.text = fontString
end