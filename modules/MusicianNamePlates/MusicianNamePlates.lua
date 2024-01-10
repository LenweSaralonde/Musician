--- Adds animated notes and music icon in player nameplates.
-- @module Musician.NamePlates

Musician.NamePlates = LibStub("AceAddon-3.0"):NewAddon("Musician.NamePlates", "AceEvent-3.0")

local MODULE_NAME = "NamePlates"
Musician.AddModule(MODULE_NAME)

-- WoW Classic polyfills
local GetCVar = (C_CVar and C_CVar.GetCVar or GetCVar)
local GetCVarBool = (C_CVar and C_CVar.GetCVarBool or GetCVarBool)

local playerNamePlates = {}
local namePlatePlayers = {}
local NOTES_TEXTURE = 167069 -- "spells\\t_vfx_note.blp"
local NOTES_TEXTURE_RACE = {
	VoidElf = 1664883, -- "spells\\t_vfx_note_void.blp",
}

if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE then
	NOTES_TEXTURE = "Interface\\AddOns\\Musician\\ui\\textures\\t_vfx_note.blp"
end

local NOTES_TEXTURE_COORDS = {
	{ 0, 0.5, 0, 0.5 },
	{ 0.5, 1, 0, 0.5 },
	{ 0, 0.5, 0.5, 1 },
	{ 0.5, 1, 0.5, 1 },
}
local NOTES_ANIMATION_HEIGHT = 220
local NOTES_ANIMATION_WIDTH = 110
local NOTES_ANIMATION_DURATION = 2
local ANIMATION_KEY_RANGE = 48
local ANIMATION_ANGLE_RANGE = 90 -- degrees
local ZOOM_STEP_DURATION = .25

-- Animation parameter indexes
local PARAM = {
	PROGRESSION = 1,
	X = 2,
	Y = 3,
	ORIENTATION = 4,
	IS_PERCUSSION = 5,
	SPEED = 6
}

local noteTexturePoolFrame = CreateFrame("Frame")

local playerAnimatedNotesFrame

Musician.NamePlates.playerNamePlates = playerNamePlates

--- OnEnable
--
function Musician.NamePlates:OnEnable()
	-- Init settings
	Musician_Settings = Mixin(Musician.NamePlates.Options.GetDefaults(), Musician_Settings)

	-- Create animated notes frame for player
	Musician.NamePlates.CreatePlayerAnimatedNotesFrame()

	-- Nameplate added
	Musician.NamePlates:RegisterEvent("NAME_PLATE_UNIT_ADDED", Musician.NamePlates.OnNamePlateAdded)

	-- Nameplate removed
	Musician.NamePlates:RegisterEvent("NAME_PLATE_UNIT_REMOVED", Musician.NamePlates.OnNamePlateRemoved)

	-- Health bar updated
	hooksecurefunc("CompactUnitFrame_UpdateHealth", Musician.NamePlates.OnUnitFrameUpdate)
	hooksecurefunc("CompactUnitFrame_UpdateMaxHealth", Musician.NamePlates.OnUnitFrameUpdate)

	-- Auras (combat) updated
	hooksecurefunc("CompactUnitFrame_UpdateAuras", Musician.NamePlates.OnUnitFrameUpdate)

	-- Name updated
	hooksecurefunc("CompactUnitFrame_UpdateName", Musician.NamePlates.OnUnitFrameUpdate)

	-- Player target changed
	if CompactUnitFrame_UpdateWidgetsOnlyMode ~= nil then
		hooksecurefunc("CompactUnitFrame_UpdateWidgetsOnlyMode", Musician.NamePlates.OnUnitFrameUpdate)
	end

	-- Player registered
	Musician.NamePlates:RegisterMessage(Musician.Registry.event.playerRegistered, Musician.NamePlates.OnPlayerRegistered)

	-- Note On
	Musician.NamePlates:RegisterMessage(Musician.Events.VisualNoteOn, Musician.NamePlates.OnNoteOn)

	-- Cinematic mode
	UIParent:HookScript("OnShow", Musician.NamePlates.UpdateAll)
	UIParent:HookScript("OnHide", Musician.NamePlates.UpdateAll)
	hooksecurefunc("SetUIVisibility", Musician.NamePlates.OnSetUIVisibility)

	-- Tips and tricks
	Musician.NamePlates.InitTipsAndTricks()
end

--- Render a single animated note
-- @param noteTexture (Texture)
-- @param position (number) 0-1
local function renderAnimatedNote(noteTexture, position)
	if not noteTexture:IsVisible() then return end

	local speed = noteTexture.animationParams[PARAM.SPEED]
	local isPercussion = noteTexture.animationParams[PARAM.IS_PERCUSSION]

	-- Position
	local x, y
	local width, height = noteTexture:GetParent():GetSize()
	if not isPercussion then
		local theta, distance
		theta = noteTexture.animationParams[PARAM.X] * (1 - position / 2) * ANIMATION_ANGLE_RANGE / 2
		theta = min(80, max(-80, theta))
		distance = position * speed * height
		x = sin(theta) * (width / 2 + distance)
		y = cos(theta) * (width / 6 + distance)
	else
		x = noteTexture.animationParams[PARAM.X] * width
		y = noteTexture.animationParams[PARAM.Y] * height
	end
	noteTexture:SetPoint("BOTTOM", x, y)

	-- Rotation, scale and fade
	local anglePosition = (position * 2 - 1) * noteTexture.animationParams[PARAM.ORIENTATION]
	local angle = anglePosition * PI / 4
	local alpha = 1 - position
	local scale = 1 + position * .8
	noteTexture:SetScale(scale)
	noteTexture:SetAlpha(alpha)
	noteTexture:SetRotation(angle)
end

--- Remove note from animated notes frame
-- @param noteTexture (Texture)
local function removeNote(noteTexture)
	noteTexture:Hide()
	noteTexture:ClearAllPoints()
	noteTexture:SetParent(noteTexturePoolFrame)
end

--- Render notes animation frame
-- @param animatedNotesFrame (Frame)
-- @param elapsed (number)
local function animateNotes(animatedNotesFrame, elapsed)
	-- Empty the table of notes added during the frame
	wipe(animatedNotesFrame.notesAddedDuringFrame)
	wipe(animatedNotesFrame.percussionNotesAddedDuringFrame)

	-- Animate notes
	local numRegions = animatedNotesFrame:GetNumRegions()

	if numRegions == 0 then return end

	for regionIndex = numRegions, 1, -1 do
		local noteTexture = select(regionIndex, animatedNotesFrame:GetRegions())
		noteTexture.animationParams[PARAM.PROGRESSION] = noteTexture.animationParams[PARAM.PROGRESSION] + elapsed

		local duration = NOTES_ANIMATION_DURATION
		local isPercussion = noteTexture.animationParams[PARAM.IS_PERCUSSION]

		if isPercussion then
			duration = duration / 3
		end
		local position = noteTexture.animationParams[PARAM.PROGRESSION] / duration

		-- Animation is complete
		if position >= 1 then
			renderAnimatedNote(noteTexture, 1)
			removeNote(noteTexture)
			numRegions = numRegions - 1
		else
			renderAnimatedNote(noteTexture, position)
		end
	end
end

--- Add note to the provided animated notes frame
-- @param animatedNotesFrame (Frame)
-- @param song (Musician.Song)
-- @param track (table)
-- @param key (Number)
local function addNote(animatedNotesFrame, song, track, key)
	-- New song: reset center key
	if animatedNotesFrame.songId ~= song:GetId() then
		animatedNotesFrame.songId = song:GetId()
		animatedNotesFrame.centerKey = { 72, 1 }
	end

	-- Set initial data
	local _, instrument = Musician.Sampler.GetSoundFile(track.instrument, key)
	local orientation = Musician.Utils.GetRandomArgument(1, -1)
	local x, y, isPercussion
	local noteSymbold

	-- Not a percussion
	if track.instrument < 128 and not (instrument and instrument.isPercussion) then
		-- Avoid duplicates during the same frame
		if animatedNotesFrame.notesAddedDuringFrame[key] then return end
		animatedNotesFrame.notesAddedDuringFrame[key] = true

		-- Adjust center key
		animatedNotesFrame.centerKey[1] = animatedNotesFrame.centerKey[1] + key
		animatedNotesFrame.centerKey[2] = animatedNotesFrame.centerKey[2] + 1
		local centerKey = animatedNotesFrame.centerKey[1] / animatedNotesFrame.centerKey[2]
		local minKey = centerKey - ANIMATION_KEY_RANGE / 4
		local maxKey = centerKey + ANIMATION_KEY_RANGE / 4

		-- Calculate initial position
		x = (key - minKey) / (maxKey - minKey) - .5
		y = 0
		isPercussion = false
		noteSymbold = Musician.Utils.GetRandomArgument(2, 3)
	else
		-- Avoid duplicates during the same frame
		if animatedNotesFrame.percussionNotesAddedDuringFrame[key .. track.index] then return end
		animatedNotesFrame.percussionNotesAddedDuringFrame[key .. track.index] = true

		-- Position is random for percussions
		x = random() - .5
		y = random() * .66
		isPercussion = true
		noteSymbold = Musician.Utils.GetRandomArgument(1, 4)
	end

	-- Acquire note texture from pool
	local noteTexture = noteTexturePoolFrame:GetRegions()
	local animationParams
	if not noteTexture then
		noteTexture = noteTexturePoolFrame:CreateTexture(nil, "BACKGROUND", nil, -8)
		noteTexture:SetBlendMode("ADD")
		noteTexture.animationParams = {}
	end

	-- Set animation parameters
	animationParams = noteTexture.animationParams
	animationParams[PARAM.PROGRESSION] = 0
	animationParams[PARAM.X] = x
	animationParams[PARAM.Y] = y
	animationParams[PARAM.ORIENTATION] = orientation
	animationParams[PARAM.IS_PERCUSSION] = isPercussion
	animationParams[PARAM.SPEED] = .6 + random() * .6

	-- Reset frame
	noteTexture:SetParent(animatedNotesFrame)
	noteTexture:SetTexture(NOTES_TEXTURE_RACE[animatedNotesFrame.race] or NOTES_TEXTURE)
	noteTexture:SetTexCoord(unpack(NOTES_TEXTURE_COORDS[noteSymbold]))
	noteTexture:SetSize(32, 32)
	noteTexture:Show()

	-- Render first animation frame
	renderAnimatedNote(noteTexture, 0)
end

--- Set frame text bypassing hooks
-- @param frame (Frame)
-- @param text (string)
local function setTextUnhooked(frame, text)
	getmetatable(frame).__index.SetText(frame, text)
end

--- OnUpdate handler for the animated notes frame
-- @param animatedNotesFrame (Frame)
-- @param elapsed (number)
function Musician.NamePlates.OnNamePlateNotesFrameUpdate(animatedNotesFrame, elapsed)

	-- Adjust frame position for fixed player frame (not hooked to a nameplate)
	if animatedNotesFrame == playerAnimatedNotesFrame then

		-- Get current zoom level
		local cameraZoom = GetCameraZoom()
		local cameraOffset = GetCVar("test_cameraOverShoulder")

		-- Zoom level changed
		if animatedNotesFrame.zoomTo ~= cameraZoom or animatedNotesFrame.cameraOffset ~= cameraOffset then
			animatedNotesFrame.zoomFrom = animatedNotesFrame.zoom
			animatedNotesFrame.zoomTo = cameraZoom
			animatedNotesFrame.zoomElapsed = 0
			animatedNotesFrame.cameraOffset = cameraOffset
		end

		-- Zoom animation in progress
		if animatedNotesFrame.zoomElapsed ~= nil and animatedNotesFrame.zoomElapsed < ZOOM_STEP_DURATION then

			animatedNotesFrame.zoomElapsed = animatedNotesFrame.zoomElapsed + elapsed
			local progression = min(1, animatedNotesFrame.zoomElapsed / ZOOM_STEP_DURATION)
			if progression == 1 then
				animatedNotesFrame.zoomElapsed = nil
			end

			local range = animatedNotesFrame.zoomTo - animatedNotesFrame.zoomFrom
			animatedNotesFrame.zoom = animatedNotesFrame.zoomFrom + progression * range

			local cameraMaxZoom = 28.5
			local x, y
			if animatedNotesFrame.zoom ~= 0 then
				local zoom = 1 - cameraMaxZoom / min(9999999, animatedNotesFrame.zoom)
				y = -zoom * 10 + 10
				x = ((zoom / 17) * 648 - 32) * cameraOffset / 1.5
			else
				y = 9999999
				x = 0
			end

			playerAnimatedNotesFrame:SetPoint("BOTTOM", WorldFrame, "CENTER", x, y)
		end
	end

	-- Animate notes
	animateNotes(animatedNotesFrame, elapsed)
end

--- UpdateNamePlate
-- @param namePlate (Frame)
function Musician.NamePlates.UpdateNamePlate(namePlate)

	-- Handle cinematic mode
	Musician.NamePlates.UpdateNamePlateCinematicMode(namePlate)

	-- Hide friendly and player health bars when not in combat

	local unitToken = namePlate.namePlateUnitToken
	local isPlayerOrFriendly = unitToken and (UnitIsFriend(unitToken, "player") or UnitIsPlayer(unitToken))

	if not namePlate:IsForbidden() and isPlayerOrFriendly and not UnitIsUnit(unitToken, "player") then

		local healthBarIsVisible, classificationFrameIsVisible, levelFrameIsVisible, raidTargetFrameIsVisible

		local isInCombat = UnitAffectingCombat(namePlate.namePlateUnitToken)
		local health = UnitHealth(namePlate.namePlateUnitToken)
		local healthMax = UnitHealthMax(namePlate.namePlateUnitToken)
		local showHealthBar = not Musician_Settings.hideNamePlateBars

		if isInCombat or (health < healthMax) or showHealthBar then
			healthBarIsVisible = true
			classificationFrameIsVisible = true
			levelFrameIsVisible = true
			raidTargetFrameIsVisible = true
		else
			healthBarIsVisible = false
			classificationFrameIsVisible = false
			levelFrameIsVisible = false
			raidTargetFrameIsVisible = false
		end

		if GetCVarBool("nameplateShowOnlyNames") then
			healthBarIsVisible = false
			classificationFrameIsVisible = false
			levelFrameIsVisible = false
			raidTargetFrameIsVisible = false
		end

		if healthBarIsVisible ~= namePlate.UnitFrame.healthBar:IsVisible() then
			namePlate.UnitFrame.healthBar:SetShown(healthBarIsVisible)
		end
		if namePlate.UnitFrame.ClassificationFrame and
			classificationFrameIsVisible ~= namePlate.UnitFrame.ClassificationFrame:IsVisible() then
			namePlate.UnitFrame.ClassificationFrame:SetShown(classificationFrameIsVisible)
		end
		if namePlate.UnitFrame.RaidTargetFrame and raidTargetFrameIsVisible ~= namePlate.UnitFrame.RaidTargetFrame:IsVisible() then
			namePlate.UnitFrame.RaidTargetFrame:SetShown(raidTargetFrameIsVisible)
		end
		if namePlate.UnitFrame.LevelFrame and levelFrameIsVisible ~= namePlate.UnitFrame.LevelFrame:IsVisible() then
			namePlate.UnitFrame.LevelFrame:SetShown(classificationFrameIsVisible)
		end
	end

	-- Update icon
	Musician.NamePlates.UpdateNoteIcon(namePlate)
end

--- Update all nameplates
--
function Musician.NamePlates.UpdateAll()
	for _, namePlate in pairs(C_NamePlate.GetNamePlates()) do
		Musician.NamePlates.UpdateNamePlate(namePlate)
	end
end

--- OnUnitFrameUpdate
-- @param frame (Frame)
function Musician.NamePlates.OnUnitFrameUpdate(frame)
	if frame:IsForbidden() then return end
	local namePlate = frame:GetParent()
	if namePlate and namePlate.namePlateUnitToken then
		Musician.NamePlates.UpdateNamePlate(namePlate)
	end
end

--- OnNamePlateAdded
-- @param event (string)
-- @param unitToken (string)
function Musician.NamePlates.OnNamePlateAdded(event, unitToken)

	local namePlate = C_NamePlate.GetNamePlateForUnit(unitToken)

	-- Animated notes may not have been cleaned up when the nameplate was recycled
	Musician.NamePlates.DetachNamePlate(namePlate)

	-- May return "Unknown" on first attempt: try again later.
	if GetUnitName(unitToken, true) == UNKNOWN then
		C_Timer.After(.1, function()
			Musician.NamePlates.OnNamePlateAdded(event, unitToken)
		end)
		return
	end

	if UnitIsPlayer(unitToken) then
		-- Add references to the nameplate
		local player = Musician.Utils.NormalizePlayerName(GetUnitName(unitToken, true))
		playerNamePlates[player] = namePlate
		namePlatePlayers[unitToken] = player

		-- Attach nameplate
		Musician.NamePlates.AttachNamePlate(namePlate, player, event)
	end
end

--- OnNamePlateRemoved
-- @param event (string)
-- @param unitToken (string)
function Musician.NamePlates.OnNamePlateRemoved(event, unitToken)
	if not UnitIsPlayer(unitToken) then return end

	-- Detach nameplate and remove references
	local player = namePlatePlayers[unitToken]
	if player and playerNamePlates[player] then
		Musician.NamePlates.DetachNamePlate(playerNamePlates[player])
		playerNamePlates[player] = nil
	end

	namePlatePlayers[unitToken] = nil
end

--- Update nameplate for player when registered
-- @param event (string)
-- @param player (string)
function Musician.NamePlates.OnPlayerRegistered(event, player)
	local fullPlayerName = Musician.Utils.NormalizePlayerName(player)
	if not playerNamePlates[fullPlayerName] then return end
	Musician.NamePlates.AttachNamePlate(playerNamePlates[fullPlayerName], fullPlayerName, event)
end

--- Hide nameplates in cinematic mode if nameplates are not enabled in this mode
-- @param namePlate (Frame)
function Musician.NamePlates.UpdateNamePlateCinematicMode(namePlate)

	if InCombatLockdown() then return end

	local UIParentIsVisible = UIParent:IsVisible()

	-- Attach animated notes frame to WorldFrame if hiding nameplates in cinematic mode
	if not Musician_Settings.cinematicModeNamePlates and Musician_Settings.cinematicMode then
		local parent, scale
		if not UIParentIsVisible then
			parent = WorldFrame
			scale = namePlate:GetScale()
		else
			parent = namePlate
			scale = 1
		end

		if namePlate.musicianAnimatedNotesFrame and namePlate.musicianAnimatedNotesFrame:GetParent() ~= parent then
			namePlate.musicianAnimatedNotesFrame:SetParent(parent)
			namePlate.musicianAnimatedNotesFrame:SetScale(scale)
		end
	end

	-- Set nameplate visibility
	if not Musician_Settings.cinematicModeNamePlates and Musician_Settings.cinematicMode or
		not Musician_Settings.cinematicMode then
		if UIParentIsVisible then
			namePlate:Show()
		else
			namePlate:Hide()
		end
	end
end

--- Update note icon next to player name
-- @param namePlate (Frame)
function Musician.NamePlates.UpdateNoteIcon(namePlate)
	if namePlate.UnitFrame and namePlate.UnitFrame.name then
		Musician.NamePlates.AddNoteIcon(namePlate, namePlate.UnitFrame.name)
	end
end

--- Returns true when the note icon container should be rendered
-- @param textElement (FontString)
function Musician.NamePlates.ShouldRenderNoteIcon(textElement)
	return textElement:IsVisible()
end

--- Add note icon in nameplate's textElement, if needed
-- @param namePlate (Frame)
-- @param textElement (FontString)
-- @param append (boolean) Add note icon at the end of the string
function Musician.NamePlates.AddNoteIcon(namePlate, textElement, append)

	-- Hook the SetText() function to ensure the icon is always added, even when modified by a third party
	if textElement.musicianSetTextIsHooked == nil then
		textElement.musicianSetTextIsHooked = true
		hooksecurefunc(textElement, "SetText", function(self)
			Musician.NamePlates.AddNoteIcon(namePlate, self, append)
		end)
	end

	local player = UnitIsPlayer(namePlate.namePlateUnitToken) and
		Musician.Utils.NormalizePlayerName(GetUnitName(namePlate.namePlateUnitToken, true))
	local isNameVisible = Musician.NamePlates.ShouldRenderNoteIcon(textElement)
	local hasNoteIcon = player and not Musician.Utils.PlayerIsMyself(player) and Musician_Settings.showNamePlateIcon and
		Musician.Registry.PlayerIsRegistered(player)
	local iconPlaceholder = Musician.Utils.GetChatIcon("")

	if hasNoteIcon and isNameVisible then
		local nameString = textElement:GetText()
		if nameString == nil then
			return
		end

		-- Icon placeholder is present but not at the right position: remove it
		local from, to = string.find(nameString, iconPlaceholder, 1, true)
		if append and to and to ~= nameString or not append and from and from ~= 1 then
			nameString = string.sub(nameString, 1, from - 1) .. string.sub(nameString, to + 1, #nameString)
			nameString = string.gsub(nameString, '%s+', ' ')
			nameString = strtrim(nameString)
			from = nil
		end

		-- Add icon placeholder if not found or previously removed
		if from == nil then
			if append then
				setTextUnhooked(textElement, nameString .. " " .. iconPlaceholder)
			else
				setTextUnhooked(textElement, iconPlaceholder .. " " .. nameString)
			end
		end

		local parent = textElement:GetParent()
		-- Create note icon
		if textElement.noteIcon == nil then
			textElement.noteIcon = parent:CreateTexture(nil, "ARTWORK")
			textElement.noteIcon:SetTexture(Musician.IconImages.Note)
			textElement.noteIcon.updateSize = function(self)
				textElement.noteIcon:SetWidth(textElement:GetHeight())
				textElement.noteIcon:SetHeight(textElement:GetHeight())
				textElement.noteIcon:SetScale(textElement:GetScale())
			end
			parent:HookScript("OnSizeChanged", textElement.noteIcon.updateSize)
		end

		-- Update note icon
		textElement.noteIcon:SetParent(parent)

		local offset = 0
		if textElement:GetJustifyH() == "CENTER" then
			local textWidth = textElement:GetStringWidth()
			offset = (textElement:GetWidth() - textWidth) / 2
		end

		textElement.noteIcon:ClearAllPoints()
		if append then
			textElement.noteIcon:SetPoint("RIGHT", textElement, "RIGHT", -offset, 0)
		else
			textElement.noteIcon:SetPoint("LEFT", textElement, "LEFT", offset, 0)
		end

		textElement.noteIcon.updateSize()
		textElement.noteIcon:Show()
	else
		-- Hide icon
		if textElement.noteIcon then
			textElement.noteIcon:Hide()
		end

		-- Remove note icon placeholder
		local nameString = textElement:GetText()
		if nameString ~= nil then
			local from, to = string.find(nameString, iconPlaceholder, 1, true)
			if to and from ~= nil then
				nameString = string.sub(nameString, 1, from - 1) .. string.sub(nameString, to + 1, #nameString)
				nameString = string.gsub(nameString, '%s+', ' ')
				nameString = strtrim(nameString)
				setTextUnhooked(textElement, nameString)
			end
		end
	end
end

--- Attach Musician nameplate
-- @param namePlate (Frame)
-- @param player (string)
-- @param event (string)
function Musician.NamePlates.AttachNamePlate(namePlate, player, event)

	Musician.NamePlates.UpdateNamePlate(namePlate)

	if not Musician.Registry.PlayerIsRegistered(player) then return end

	-- Create or show animated notes frames
	if not namePlate.musicianAnimatedNotesFrame then
		namePlate.musicianAnimatedNotesFrame = CreateFrame("Frame")
		namePlate.musicianAnimatedNotesFrame:SetFrameStrata("BACKGROUND")
		namePlate.musicianAnimatedNotesFrame:SetParent(namePlate)
		namePlate.musicianAnimatedNotesFrame:SetFrameLevel(0)
		namePlate.musicianAnimatedNotesFrame:SetPoint("BOTTOM", namePlate, "BOTTOM", 0, -20)
		namePlate.musicianAnimatedNotesFrame:SetWidth(NOTES_ANIMATION_WIDTH)
		namePlate.musicianAnimatedNotesFrame:SetHeight(NOTES_ANIMATION_HEIGHT)
		namePlate.musicianAnimatedNotesFrame:SetScript("OnUpdate", Musician.NamePlates.OnNamePlateNotesFrameUpdate)
		namePlate.musicianAnimatedNotesFrame.namePlate = namePlate
	else
		namePlate.musicianAnimatedNotesFrame:Show()
	end

	-- Set data
	namePlate.musicianAnimatedNotesFrame.player = player
	namePlate.musicianAnimatedNotesFrame.songId = nil
	namePlate.musicianAnimatedNotesFrame.race = select(2, UnitRace(namePlate.namePlateUnitToken))
	namePlate.musicianAnimatedNotesFrame.notesAddedDuringFrame = {}
	namePlate.musicianAnimatedNotesFrame.percussionNotesAddedDuringFrame = {}
end

--- Detach animated notes frame from the nameplate
-- @param namePlate (Frame)
function Musician.NamePlates.DetachNamePlate(namePlate)

	if not namePlate or not namePlate.musicianAnimatedNotesFrame then return end

	-- Hide animated notes frame
	namePlate.musicianAnimatedNotesFrame:Hide()

	-- Remove animated notes frames
	while namePlate.musicianAnimatedNotesFrame:GetNumRegions() > 0 do
		removeNote(select(1, namePlate.musicianAnimatedNotesFrame:GetRegions()))
	end
end

--- Create fixed animated notes frame for the current player
--
function Musician.NamePlates.CreatePlayerAnimatedNotesFrame()
	playerAnimatedNotesFrame = CreateFrame("Frame")
	playerAnimatedNotesFrame:SetParent(WorldFrame)
	playerAnimatedNotesFrame:SetFrameLevel(0)
	playerAnimatedNotesFrame:SetWidth(NOTES_ANIMATION_WIDTH)
	playerAnimatedNotesFrame:SetHeight(NOTES_ANIMATION_HEIGHT)
	playerAnimatedNotesFrame:SetScript("OnUpdate", Musician.NamePlates.OnNamePlateNotesFrameUpdate)

	-- Set data
	playerAnimatedNotesFrame.player = Musician.Utils.NormalizePlayerName(UnitName("player"))
	playerAnimatedNotesFrame.songId = nil
	playerAnimatedNotesFrame.race = select(2, UnitRace("player"))
	playerAnimatedNotesFrame.notesAddedDuringFrame = {}
	playerAnimatedNotesFrame.percussionNotesAddedDuringFrame = {}
	playerAnimatedNotesFrame.zoom = GetCameraZoom()
	playerAnimatedNotesFrame.zoomTo = playerAnimatedNotesFrame.zoom
	playerAnimatedNotesFrame.zoomFrom = playerAnimatedNotesFrame.zoom
	playerAnimatedNotesFrame.zoomElapsed = 0
end

--- Add note to the appropriate animated notes frame
-- @param event (string)
-- @param song (Musician.Song)
-- @param track (table)
-- @param key (Number)
function Musician.NamePlates.OnNoteOn(event, song, track, key)
	if not track.audible then return end
	if not song.player and song ~= Musician.streamingSong then return end

	if song ~= Musician.streamingSong and not Musician.Utils.PlayerIsMyself(song.player) then
		local namePlate = playerNamePlates[song.player]
		if namePlate and namePlate.musicianAnimatedNotesFrame then
			addNote(namePlate.musicianAnimatedNotesFrame, song, track, key)
		end
	else
		addNote(playerAnimatedNotesFrame, song, track, key)
	end
end

--- OnSetUIVisibility
-- @param isVisible (boolean)
function Musician.NamePlates.OnSetUIVisibility(isVisible)
	if isVisible or not isVisible and Musician_Settings.cinematicMode then
		SetInWorldUIVisibility(true)
	end
end

--- Indicates whenever the friendly player nameplates are enabled.
-- @return areVisible (boolean)
function Musician.NamePlates.AreNamePlatesEnabled()
	return
		GetCVarBool("nameplateShowAll") and
		GetCVarBool("nameplateShowFriends") and
		tonumber(GetCVar("nameplatePlayerMaxDistance")) or 0 > 0
end

--- Initialize tips and tricks
--
function Musician.NamePlates.InitTipsAndTricks()
	-- Already shown
	if Musician_Settings.namePlatesHintShown then return end

	-- Title
	MusicianNamePlatesTipsAndTricks.title:SetText(Musician.Msg.TIPS_AND_TRICKS_NAMEPLATES_TITLE)

	-- Text
	local text = string.gsub(Musician.Msg.TIPS_AND_TRICKS_NAMEPLATES_TEXT, '{icon}',
		Musician.Utils.GetChatIcon(Musician.IconImages.Note))
	MusicianNamePlatesTipsAndTricks.text:SetPoint("LEFT", 180, 0)
	MusicianNamePlatesTipsAndTricks.text:SetPoint("BOTTOM", MusicianNamePlatesTipsAndTricks.okButton, "TOP")
	MusicianNamePlatesTipsAndTricks.text:SetText(text)

	-- Already enabled
	if Musician.NamePlates.AreNamePlatesEnabled() then
		Musician_Settings.namePlatesHintShown = true
		return
	end

	-- Cancel button
	MusicianNamePlatesTipsAndTricksCancelButton:SetText(Musician.Msg.TIPS_AND_TRICKS_NAMEPLATES_CANCEL)
	MusicianNamePlatesTipsAndTricksCancelButton:HookScript("OnClick", function()
		Musician_Settings.namePlatesHintShown = true
	end)

	-- OK button
	MusicianNamePlatesTipsAndTricksOKButton:SetText(Musician.Msg.TIPS_AND_TRICKS_NAMEPLATES_OK)
	MusicianNamePlatesTipsAndTricksOKButton:HookScript("OnClick", function()
		Musician.NamePlates.Options.Defaults()
		Musician_Settings.namePlatesHintShown = true
	end)

	-- Animated image
	MusicianNamePlatesTipsAndTricksImage.fps = 30
	MusicianNamePlatesTipsAndTricksImage.width = 1024
	MusicianNamePlatesTipsAndTricksImage.height = 1024
	MusicianNamePlatesTipsAndTricksImage.tileHeight = 256
	MusicianNamePlatesTipsAndTricksImage.tileWidth = 128
	MusicianNamePlatesTipsAndTricksImage.textureFile = "Interface\\AddOns\\Musician\\ui\\textures\\nameplates-demo.blp"
	MusicianNamePlatesTipsAndTricks:HookScript("OnShow", function(self)
		self.image:Show()
	end)

	-- Add tip
	Musician.AddTipsAndTricks(function()
		MusicianNamePlatesTipsAndTricks:Show()
	end, true)
end