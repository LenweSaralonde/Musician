Musician.Button = LibStub("AceAddon-3.0"):NewAddon("Musician.Button", "AceEvent-3.0")

--- Init
--
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

--- Reposition button
--
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

--- DraggingFrame_OnUpdate
--
function MusicianButton.DraggingFrame_OnUpdate()
	local xpos, ypos = GetCursorPosition()
	local xmin, ymin = Minimap:GetCenter()
	local scale = UIParent:GetScale()

	xpos = xpos / scale
	ypos = ypos / scale

	Musician_Settings.minimapPosition = math.deg(math.atan2(ypos - ymin, xpos - xmin)) % 360
	MusicianButton.Reposition()
end

--- OnMouseDown
--
function MusicianButton.OnMouseDown()
	MusicianButton_IconUnmuted:SetWidth(14)
	MusicianButton_IconUnmuted:SetHeight(14)
	MusicianButton_IconMuted:SetWidth(14)
	MusicianButton_IconMuted:SetHeight(14)
end

--- OnMouseUp
--
function MusicianButton.OnMouseUp()
	MusicianButton_IconUnmuted:SetWidth(16)
	MusicianButton_IconUnmuted:SetHeight(16)
	MusicianButton_IconMuted:SetWidth(16)
	MusicianButton_IconMuted:SetHeight(16)
end

--- OnClick
-- @param event (string)
-- @param button (string)
function MusicianButton.OnClick(event, button)
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

--- Return main menu elements
-- @return (table)
function MusicianButton.GetMenu()
	local menu = {}

	-- Main menu title

	table.insert(menu, {
		notCheckable = true,
		text = Musician.Msg.MENU_TITLE,
		isTitle = true
	})

	-- Import a song

	table.insert(menu, {
		notCheckable = true,
		text = Musician.Msg.MENU_IMPORT_SONG,
		func = function()
			MusicianFrame:Show()
		end
	})

	if Musician.sourceSong then

		-- Source song title

		table.insert(menu, {
			notCheckable = true,
			text = "\"" .. Musician.sourceSong.name .. "\"",
			isTitle = true
		})

		-- Preview imported song

		local labelPreview
		if Musician.sourceSong:IsPlaying() then
			labelPreview = Musician.Utils.GetChatIcon(Musician.IconImages.PlayerUnmuted) .. " " .. Musician.Msg.MENU_STOP_PREVIEW
		else
			labelPreview = Musician.Msg.MENU_PLAY_PREVIEW
		end

		table.insert(menu, {
			notCheckable = true,
			text = labelPreview,
			func = MusicianFrame.Test
		})

		-- Open track editor

		table.insert(menu, {
			notCheckable = true,
			text = Musician.Msg.SONG_EDITOR,
			func = function()
				MusicianFrame.TrackEditor()
			end
		})

		-- Play imported song

		local labelPlay
		if Musician.songIsPlaying then

			-- If the song being playing is not the same as the source song, show its title
			if Musician.sourceSong and Musician.streamingSong and Musician.sourceSong.name ~= Musician.streamingSong.name then
				table.insert(menu, {
					notCheckable = true,
					text = "\"" .. Musician.streamingSong.name .. "\"",
					isTitle = true
				})
			end

			labelPlay = Musician.Utils.GetChatIcon(Musician.IconImages.PlayerUnmuted) .. " " .. Musician.Msg.MENU_STOP
		else
			labelPlay = Musician.Msg.MENU_PLAY
		end

		table.insert(menu, {
			notCheckable = true,
			text = labelPlay,
			func = MusicianFrame.Play
		})
	end

	-- Live play separator

	table.insert(menu, {
		notCheckable = true,
		text = Musician.Msg.MENU_LIVE_PLAY,
		isTitle = true
	})

	-- Show keyboard

	table.insert(menu, {
		notCheckable = true,
		text = Musician.Msg.MENU_SHOW_KEYBOARD,
		func = function()
			MusicianFrameSource:ClearFocus()
			Musician.Keyboard.Show()
		end
	})

	return menu
end

--- Open main menu
--
function MusicianButton.OpenMenu()
	local menu = MusicianButton.GetMenu()
	local indent = "     "
	local i, row
	for i, row in pairs(menu) do
		if not(row.isTitle) then
			row.text = indent .. row.text
		end
	end

	EasyMenu(menu, MusicianButton_Menu, "cursor", 0 , 0, "MENU")
end

--- ShowTooltip
--
function MusicianButton.ShowTooltip()
	GameTooltip:SetOwner(MusicianButton, "ANCHOR_BOTTOMLEFT")
	MusicianButton.UpdateTooltipText(false)
	GameTooltip:Show()
	MusicianButton.tooltipIsVisible = true
end

--- UpdateTooltipText
-- @param alwaysShowLoadingProgression (boolean)
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

--- HideTooltip
--
function MusicianButton.HideTooltip()
	MusicianButton.tooltipIsVisible = false
	GameTooltip:Hide()
end
