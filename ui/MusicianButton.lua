--- Minimap button
-- @module MusicianButton

MusicianButton = LibStub("AceAddon-3.0"):NewAddon("MusicianButton", "AceEvent-3.0")

local icon = LibStub("LibDBIcon-1.0")
local menuFrame

local MUSICIAN_ICON = "Interface\\AddOns\\Musician\\ui\\textures\\button-unmuted"
local MUSICIAN_ICON_MUTED = "Interface\\AddOns\\Musician\\ui\\textures\\button-muted"
local MUSICIAN_ICON_WAIT = "Interface\\AddOns\\Musician\\ui\\textures\\button-wait"
local HOURGLASS = "Interface\\AddOns\\Musician\\ui\\textures\\hourglass"

--- Init
--
function MusicianButton.Init()
	local musicianLDB = LibStub("LibDataBroker-1.1"):NewDataObject("Musician", {
		type = "data source",
		text = "Musician",
		icon = MUSICIAN_ICON_WAIT,
		OnClick = MusicianButton.OnClick,
		OnEnter = MusicianButton.ShowTooltip,
		OnLeave = MusicianButton.HideTooltip
	})

	-- Convert old minimap position format
	if tonumber(Musician_Settings.minimapPosition) ~= nil then
		Musician_Settings.minimap = {
			minimapPos = Musician_Settings.minimapPosition,
			hide = false
		}
		Musician_Settings.minimapPosition = nil
	end

	-- Create button
	icon:Register("Musician", musicianLDB, Musician_Settings.minimap)

	-- Create menu frame
	local buttonFrame = icon:GetMinimapButton("Musician")
	menuFrame = CreateFrame("Frame", "MusicianButton_Menu", buttonFrame, "MusicianDropDownMenuTooltipTemplate")

	-- Hourglass icon for preloading
	local hourglass = buttonFrame:CreateTexture(nil, "OVERLAY", nil, 7)
	hourglass:SetTexture(HOURGLASS)
	hourglass:SetPoint("BOTTOMRIGHT", 2, -2)
	hourglass:SetPoint("TOPLEFT", 10, -10)
	buttonFrame.hourglass = hourglass

	-- Update tooltip text when preloading
	MusicianButton.tooltipIsVisible = false
	MusicianButton:RegisterMessage(Musician.Events.PreloadingProgress, function()
		if MusicianButton.tooltipIsVisible then
			MusicianButton.UpdateTooltipText(true)
		end
	end)

	-- Update icons when preloading is complete
	MusicianButton:RegisterMessage(Musician.Events.PreloadingComplete, MusicianButton.UpdateIcons)
end

--- Update icons
--
function MusicianButton.UpdateIcons()
	local button = icon:GetMinimapButton("Musician")
	if Musician.globalMute then
		button.icon:SetTexture(MUSICIAN_ICON_MUTED)
	elseif Musician.Preloader.IsComplete() then
		button.icon:SetTexture(MUSICIAN_ICON)
	else
		button.icon:SetTexture(MUSICIAN_ICON_WAIT)
	end

	if Musician.Preloader.IsComplete() then
		button.hourglass:Hide()
	else
		button.hourglass:Show()
	end
end

--- OnClick
-- @param event (string)
-- @param button (string)
function MusicianButton.OnClick(event, button)
	if button == "LeftButton" then
		PlaySound(SOUNDKIT.IG_MINIMAP_ZOOM_IN)
		MusicianButton.HideTooltip()
		MusicianButton.OpenMenu()
	elseif button == "RightButton" then
		Musician.globalMute = not(Musician.globalMute)
		if Musician.globalMute then
			PlaySound(SOUNDKIT.IG_MINIMAP_ZOOM_OUT)
		else
			PlaySound(SOUNDKIT.IG_MINIMAP_ZOOM_IN)
		end
		MusicianButton.UpdateIcons()
		MusicianButton.ShowTooltip()
	end
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

		if Musician.sourceSong:IsPlaying() then
			table.insert(menu, {
				notCheckable = true,
				text = Musician.Utils.GetChatIcon(Musician.IconImages.Note) .. " " .. Musician.Msg.MENU_STOP_PREVIEW,
				func = function() Musician.sourceSong:Stop() end
			})
		else
			table.insert(menu, {
				notCheckable = true,
				text = Musician.Msg.MENU_PLAY_PREVIEW,
				func = function() Musician.sourceSong:Play() end
			})
		end

		-- Open track editor

		table.insert(menu, {
			notCheckable = true,
			text = Musician.Msg.SONG_EDITOR,
			func = MusicianFrame.TrackEditor
		})

		-- Play/stop imported song

		if Musician.Comm.IsSongPlaying() then

			-- If the song being playing is not the same as the source song, show its title
			if Musician.sourceSong and Musician.streamingSong and Musician.sourceSong.name ~= Musician.streamingSong.name then
				table.insert(menu, {
					notCheckable = true,
					text = "\"" .. Musician.streamingSong.name .. "\"",
					isTitle = true
				})
			end

			table.insert(menu, {
				notCheckable = true,
				text = Musician.Utils.GetChatIcon(Musician.IconImages.Note) .. " " .. Musician.Msg.MENU_STOP,
				func = Musician.Comm.StopSong
			})
		else
			table.insert(menu, {
				notCheckable = true,
				text = Musician.Msg.MENU_PLAY,
				func = Musician.Comm.PlaySong
			})
		end
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

	-- Settings separator

	table.insert(menu, {
		notCheckable = true,
		text = Musician.Msg.MENU_OPTIONS,
		isTitle = true
	})

	-- Show options

	table.insert(menu, {
		notCheckable = true,
		text = Musician.Msg.MENU_SETTINGS,
		func = function()
			Musician.Options.Show()
		end
	})

	-- About

	table.insert(menu, {
		notCheckable = true,
		text = Musician.Msg.MENU_ABOUT,
		func = function()
			MusicianAbout:Show()
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

	Musician.Utils.EasyMenu(menu, MusicianButton_Menu, "cursor", 0 , 0, "MENU")
end

--- ShowTooltip
--
function MusicianButton.ShowTooltip()
	GameTooltip:SetOwner(icon:GetMinimapButton("Musician"), "ANCHOR_BOTTOMLEFT")
	MusicianButton.UpdateTooltipText(false)
	GameTooltip:Show()
	MusicianButton.tooltipIsVisible = true
end

--- UpdateTooltipText
-- @param alwaysShowLoadingProgression (boolean)
function MusicianButton.UpdateTooltipText(alwaysShowLoadingProgression)

	local mainLine = string.gsub(Musician.Msg.PLAYER_TOOLTIP_VERSION, "{version}", GetAddOnMetadata("Musician", "Version"))

	local leftClickLine = Musician.Msg.TOOLTIP_LEFT_CLICK
	local leftAction = Musician.Msg.TOOLTIP_ACTION_OPEN_MENU
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

	local preloadingProgression = Musician.Preloader.GetProgress()
	local loadingLine = ''
	if alwaysShowLoadingProgression or preloadingProgression < 1 then
		local strPreloadingProgression = floor(preloadingProgression * 100) .. "%%"
		loadingLine = string.gsub(Musician.Msg.PLAYER_TOOLTIP_PRELOADING, "{progress}", strPreloadingProgression)
	end

	local tooltipText = Musician.Utils.Highlight(mainLine, NORMAL_FONT_COLOR)
	tooltipText = tooltipText .. "\n" .. Musician.Utils.FormatText(leftClickLine)
	tooltipText = tooltipText .. "\n" .. Musician.Utils.FormatText(rightClickLine)
	tooltipText = tooltipText .. "\n" .. Musician.Utils.FormatText(Musician.Msg.TOOLTIP_DRAG_AND_DROP)

	if loadingLine ~= "" then
		tooltipText = tooltipText .. "\n" .. Musician.Utils.Highlight(Musician.Utils.FormatText(loadingLine), LIGHTBLUE_FONT_COLOR)
	end

	if (GameTooltipTextLeft1 == nil) or (tooltipText ~= GameTooltipTextLeft1:GetText()) then
		GameTooltip:SetText("0") -- Workaround for colored text issues with chinese client
		GameTooltip:SetText(tooltipText, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	end

end

--- HideTooltip
--
function MusicianButton.HideTooltip()
	MusicianButton.tooltipIsVisible = false
	GameTooltip:Hide()
end
