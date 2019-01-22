Musician.Button = LibStub("AceAddon-3.0"):NewAddon("Musician.Button", "AceEvent-3.0")

function MusicianButton.Init()
	MusicianButton.Reposition()
	MusicianButton.tooltipIsVisible = false
	MusicianButton:SetScript("OnClick", MusicianButton.OnClick)
	Musician.Button:RegisterMessage(Musician.Events.PreloadingProgress, function()
		if MusicianButton.tooltipIsVisible then
			MusicianButton.UpdateTooltipText(true)
		end
	end)
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
	local xpos, ypos = GetCursorPosition()
	local xmin, ymin = Minimap:GetCenter()
	local scale = UIParent:GetScale()

	xpos = xpos / scale
	ypos = ypos / scale

	Musician_Settings.minimapPosition = math.deg(math.atan2(ypos - ymin, xpos - xmin)) % 360
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
		PlaySound(SOUNDKIT.IG_MINIMAP_ZOOM_IN)
		MusicianButton.OpenMenu()
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

function MusicianButton.OpenMenu()
	local menu = {
		{
			notCheckable = true,
			text = Musician.Msg.MENU_TITLE,
			isTitle = true
		},
		{
			notCheckable = true,
			text = Musician.Msg.MENU_PLAY_SONG,
			func = function()
				MusicianKeyboardConfig:Hide()
				MusicianKeyboard:Hide()
				MusicianFrame:Show()
				MusicianFrameSource:SetFocus()
			end
		},
		{
			notCheckable = true,
			text = Musician.Msg.MENU_PLAY_LIVE,
			func = function()
				MusicianFrame:Hide()
				MusicianFrameSource:ClearFocus()
				Musician.Keyboard.Show()
			end
		},
	}

	EasyMenu(menu, MusicianButton_Menu, "cursor", 0 , 0, "MENU")
end

function MusicianButton.ShowTooltip()
	GameTooltip:SetOwner(MusicianButton, "ANCHOR_BOTTOMLEFT")
	MusicianButton.UpdateTooltipText(false)
	GameTooltip:Show()
	MusicianButton.tooltipIsVisible = true
end

function MusicianButton.UpdateTooltipText(alwaysShowLoadingProgression)

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

	GameTooltip:ClearLines()
	GameTooltip:AddLine(mainLine, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	GameTooltip:AddLine(Musician.Utils.FormatText(leftClickLine), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	GameTooltip:AddLine(Musician.Utils.FormatText(rightClickLine), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	GameTooltip:AddLine(Musician.Utils.FormatText(Musician.Msg.TOOLTIP_DRAG_AND_DROP), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

	local preloadingProgression = Musician.Preloader.GetProgress()
	local loadingLine = ''
	if alwaysShowLoadingProgression or preloadingProgression < 1 then
		local strPreloadingProgression = floor(preloadingProgression * 100) .. "%%"
		loadingLine = string.gsub(Musician.Msg.PLAYER_TOOLTIP_PRELOADING, "{progress}", strPreloadingProgression)
	end
	GameTooltip:AddLine(Musician.Utils.FormatText(loadingLine), LIGHTBLUE_FONT_COLOR.r, LIGHTBLUE_FONT_COLOR.g, LIGHTBLUE_FONT_COLOR.b)
end

function MusicianButton.HideTooltip()
	MusicianButton.tooltipIsVisible = false
	GameTooltip:Hide()
end
