
function MusicianButton.Init()
	MusicianButton.Reposition()
	MusicianButton:SetScript("OnClick", MusicianButton.OnClick)
end

function MusicianButton.Reposition()
	local radius = Minimap:GetWidth() / 2 + 8
	MusicianButton:SetPoint("CENTER", "Minimap", "CENTER", radius * cos(Musician_Settings.minimapPosition), radius * sin(Musician_Settings.minimapPosition))

	if Musician.globalMute then
		MusicianButton_IconMuted:Show()
		MusicianButton_IconUnmuted:Hide()
	else
		MusicianButton_IconMuted:Hide()
		MusicianButton_IconUnmuted:Show()
	end

	MusicianButton:SetFrameLevel(Minimap:GetFrameLevel()+1000)
end

function MusicianButton.DraggingFrame_OnUpdate()
	local xpos,ypos = GetCursorPosition()
	local xmin,ymin = Minimap:GetLeft() + Minimap:GetWidth() / 2, Minimap:GetBottom() + Minimap:GetHeight() / 2

	xpos = xpos-xmin/UIParent:GetScale()
	ypos = ypos-ymin/UIParent:GetScale()

	Musician_Settings.minimapPosition = math.deg(math.atan2(ypos,xpos))
	MusicianButton.Reposition()
end

function MusicianButton.OnMouseDown()
	MusicianButton_IconUnmuted:SetWidth(14)
	MusicianButton_IconUnmuted:SetHeight(14)
	MusicianButton_IconMuted:SetWidth(14)
	MusicianButton_IconMuted:SetHeight(14)
end

function MusicianButton.OnMouseUp()
	MusicianButton_IconUnmuted:SetWidth(16)
	MusicianButton_IconUnmuted:SetHeight(16)
	MusicianButton_IconMuted:SetWidth(16)
	MusicianButton_IconMuted:SetHeight(16)
end

function MusicianButton.OnClick(self, button)
	if button == "LeftButton" then
		if MusicianFrame:IsVisible() then
			MusicianFrame:Hide()
		else
			MusicianFrame:Show()
			MusicianFrameSource:SetFocus()
			MusicianFrameSource:HighlightText(0)
		end
	elseif button == "RightButton" then
		Musician.globalMute = not(Musician.globalMute)
		if Musician.globalMute then
			PlaySound(SOUNDKIT.IG_MINIMAP_ZOOM_OUT)
		else
			PlaySound(SOUNDKIT.IG_MINIMAP_ZOOM_IN)
		end
	end
	MusicianButton.Reposition()
	MusicianButton.ShowTooltip()
end

function MusicianButton.ShowTooltip()
	GameTooltip:SetOwner(MusicianButton, "ANCHOR_BOTTOMLEFT");

	local mainLine = string.gsub(Musician.Msg.PLAYER_TOOLTIP_VERSION, "{version}", GetAddOnMetadata("Musician", "Version"))

	local leftClickLine = Musician.Msg.TOOLTIP_LEFT_CLICK
	local leftAction
	if MusicianFrame:IsVisible() then
		leftAction = Musician.Msg.TOOLTIP_ACTION_HIDE
	else
		leftAction = Musician.Msg.TOOLTIP_ACTION_SHOW
	end
	leftClickLine = string.gsub(leftClickLine, "{action}", leftAction)

	local rightClickLine = Musician.Msg.TOOLTIP_RIGHT_CLICK
	local rightAction
	if Musician.globalMute then
		mainLine = mainLine .. " " .. Musician.Msg.TOOLTIP_ISMUTED
		rightAction = Musician.Msg.TOOLTIP_ACTION_UNMUTE
	else
		rightAction = Musician.Msg.TOOLTIP_ACTION_MUTE
	end
	rightClickLine = string.gsub(rightClickLine, "{action}", rightAction)

	GameTooltip:AddLine(mainLine, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	GameTooltip:AddLine(Musician.Utils.FormatText(leftClickLine), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	GameTooltip:AddLine(Musician.Utils.FormatText(rightClickLine), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	GameTooltip:AddLine(Musician.Utils.FormatText(Musician.Msg.TOOLTIP_DRAG_AND_DROP), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

	GameTooltip:Show();
end

function MusicianButton.HideTooltip()
	GameTooltip:Hide();
end

