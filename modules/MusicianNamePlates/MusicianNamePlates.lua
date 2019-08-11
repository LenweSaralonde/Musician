Musician.NamePlates = LibStub("AceAddon-3.0"):NewAddon("Musician.NamePlates", "AceEvent-3.0")

local MODULE_NAME = "NamePlates"
Musician.AddModule(MODULE_NAME)

local playerNamePlates = {}
local namePlatePlayers = {}
local NOTES_TEXTURE = 167069 -- "spells\\t_vfx_note.blp"
local NOTES_TEXTURE_RACE = {
	VoidElf = 1664883, -- "spells\\t_vfx_note_void.blp",
}
local NOTES_TEXTURE_COORDS = {
	{0, 0.5, 0, 0.5},
	{0.5, 1, 0, 0.5},
	{0, 0.5, 0.5, 1},
	{0.5, 1, 0.5, 1},
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

local releasedNoteFrames = {}

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

	-- Player registered
	Musician.NamePlates:RegisterMessage(Musician.Registry.event.playerRegistered, Musician.NamePlates.OnPlayerRegistered)

	-- Note On
	Musician.NamePlates:RegisterMessage(Musician.Events.VisualNoteOn, Musician.NamePlates.OnNoteOn)

	-- Cinematic mode
	UIParent:HookScript("OnShow", Musician.NamePlates.UpdateAll)
	UIParent:HookScript("OnHide", Musician.NamePlates.UpdateAll)
	hooksecurefunc("SetUIVisibility", Musician.NamePlates.OnSetUIVisibility)

	--- Tips and tricks
	Musician.NamePlates.InitTipsAndTricks()
end

--- Render a single animated note
-- @param noteFrame (Frame)
-- @param position (number) 0-1
local function renderAnimatedNote(noteFrame, position)
	if not(noteFrame:IsVisible()) then return end

	local speed = noteFrame.animationParams[PARAM.SPEED]
	local isPercussion = noteFrame.animationParams[PARAM.IS_PERCUSSION]

	-- Position
	local x, y
	local width = noteFrame:GetParent():GetWidth()
	local height = noteFrame:GetParent():GetHeight()
	if not(isPercussion) then
		local theta, distance
		theta = noteFrame.animationParams[PARAM.X] * (1 - position / 2) * ANIMATION_ANGLE_RANGE / 2
		theta = min(80, max(-80, theta))
		distance = position * speed * height
		x = sin(theta) * (width / 2 + distance)
		y = cos(theta) * (width / 6 + distance)
	else
		x = noteFrame.animationParams[PARAM.X] * width
		y = noteFrame.animationParams[PARAM.Y] * height
	end
	noteFrame:SetPoint("BOTTOM", x, y)

	-- Rotation, scale and fade
	local anglePosition = (position * 2 - 1) * noteFrame.animationParams[PARAM.ORIENTATION]
	local angle = anglePosition * PI / 4
	local alpha = 1 - position
	local scale = 1 + position * .8
	noteFrame:SetScale(scale)
	noteFrame.texture:SetAlpha(alpha)
	noteFrame.texture:SetRotation(angle)
end

--- Remove note from animated notes frame
-- @param noteFrame (Frame)
local function removeNote(noteFrame)
	noteFrame:Hide()
	noteFrame:SetParent(nil)
	noteFrame:ClearAllPoints()
	table.insert(releasedNoteFrames, noteFrame)
end

--- Render notes animation frame
-- @param animatedNotesFrame (Frame)
-- @param elapsed (number)
local function animateNotes(animatedNotesFrame, elapsed)
	-- Empty the table of notes added during the frame
	animatedNotesFrame.notesAddedDuringFrame = {}

	-- Animate notes
	local noteFrame
	local children = { animatedNotesFrame:GetChildren() }
	for _, noteFrame in ipairs(children) do
		noteFrame.animationParams[PARAM.PROGRESSION] = noteFrame.animationParams[PARAM.PROGRESSION] + elapsed

		local duration = NOTES_ANIMATION_DURATION
		local isPercussion = noteFrame.animationParams[PARAM.IS_PERCUSSION]

		if isPercussion then
			duration = duration / 3
		end
		local position = noteFrame.animationParams[PARAM.PROGRESSION] / duration

		-- Animation is complete
		if position >= 1 then
			renderAnimatedNote(noteFrame, 1)
			removeNote(noteFrame)
		else
			renderAnimatedNote(noteFrame, position)
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
		animatedNotesFrame.centerKey = {72, 1}
	end

	-- Set initial data
	local _, instrument = Musician.Utils.GetSoundFile(track.instrument, key)
	local orientation = GetRandomArgument(1, -1)
	local x, y, isPercussion

	-- Not a percussion
	if track.instrument < 128 and not(instrument.isPercussion) then
		-- Avoid duplicates during the same frame
		if animatedNotesFrame.notesAddedDuringFrame[key] then return end

		-- Adjust center key
		animatedNotesFrame.notesAddedDuringFrame[key] = key
		animatedNotesFrame.centerKey[1] = animatedNotesFrame.centerKey[1] + key
		animatedNotesFrame.centerKey[2] = animatedNotesFrame.centerKey[2] + 1
		local centerKey = animatedNotesFrame.centerKey[1] / animatedNotesFrame.centerKey[2]
		local minKey = centerKey - ANIMATION_KEY_RANGE / 4
		local maxKey = centerKey + ANIMATION_KEY_RANGE / 4

		-- Calculate initial position
		x = (key - minKey) / (maxKey - minKey) - .5
		y = 0
		isPercussion = false
		noteSymbold = GetRandomArgument(2, 3)
	else
		-- Position is random for percussions
		x = random() - .5
		y = random() * .66
		isPercussion = true
		noteSymbold = GetRandomArgument(1, 4)
	end

	-- Get a released note frame or create a new one
	local noteFrame = table.remove(releasedNoteFrames)
	if not(noteFrame) then
		noteFrame = CreateFrame("Frame")
		noteFrame:SetFrameStrata("BACKGROUND")
		noteFrame.texture = noteFrame:CreateTexture(nil, "BACKGROUND", nil, -8)
		noteFrame.texture:SetAllPoints(noteFrame)
		noteFrame.texture:SetBlendMode("ADD")
	end

	-- Set animation parameters
	noteFrame.animationParams = {
		[PARAM.PROGRESSION] = 0,
		[PARAM.X] = x,
		[PARAM.Y] = y,
		[PARAM.ORIENTATION] = orientation,
		[PARAM.IS_PERCUSSION] = isPercussion,
		[PARAM.SPEED] = .6 + random() * .6
	}

	-- Reset frame
	noteFrame:SetParent(animatedNotesFrame)
	noteFrame:SetFrameLevel(0)
	noteFrame.texture:SetTexture(NOTES_TEXTURE_RACE[animatedNotesFrame.race] or NOTES_TEXTURE)
	noteFrame.texture:SetTexCoord(unpack(NOTES_TEXTURE_COORDS[noteSymbold]))
	noteFrame:SetWidth(32)
	noteFrame:SetHeight(32)
	noteFrame.texture:Show()
	noteFrame:Show()

	-- Render first animation frame
	renderAnimatedNote(noteFrame, 0)
end

--- OnUpdate handler for the animated notes frame
-- @param animatedNotesFrame (Frame)
-- @param elapsed (number)
function Musician.NamePlates.OnNamePlateNotesFrameUpdate(animatedNotesFrame, elapsed)

	-- Adjust frame position for fixed player frame (not hooked to a nameplate)
	if animatedNotesFrame == playerAnimatedNotesFrame then

		-- Get current zoom level
		local cameraZoom = GetCameraZoom()

		-- Zoom level changed
		if animatedNotesFrame.zoomTo ~= cameraZoom then
			animatedNotesFrame.zoomFrom = animatedNotesFrame.zoom
			animatedNotesFrame.zoomTo = cameraZoom
			animatedNotesFrame.zoomElapsed = 0
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
			local y = -tan(atan(1 - cameraMaxZoom / min(9999999, animatedNotesFrame.zoom))) * 10 + 10

			playerAnimatedNotesFrame:SetPoint("BOTTOM", WorldFrame, "CENTER", 0, y)
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

	if not(namePlate:IsForbidden()) and not(UnitIsUnit(unitToken, "player")) and isPlayerOrFriendly then

		local healthBarIsVisible, classificationFrameIsVisible

		local isInCombat = UnitAffectingCombat(namePlate.namePlateUnitToken)
		local health = UnitHealth(namePlate.namePlateUnitToken)
		local healthMax = UnitHealthMax(namePlate.namePlateUnitToken)
		local showHealthBar = not(Musician_Settings.hideNamePlateBars)

		if isInCombat or (health < healthMax) or not(Musician_Settings.hideNamePlateBars) then
			healthBarIsVisible = true
			classificationFrameIsVisible = true
		else
			healthBarIsVisible = false
			classificationFrameIsVisible = false
		end

		if GetCVarBool("nameplateShowOnlyNames") then
			healthBarIsVisible = false
			classificationFrameIsVisible = false
		end

		if healthBarIsVisible ~= namePlate.UnitFrame.healthBar:IsVisible() then
			namePlate.UnitFrame.healthBar:SetShown(healthBarIsVisible)
		end
		if classificationFrameIsVisible ~= namePlate.UnitFrame.ClassificationFrame:IsVisible() then
			namePlate.UnitFrame.ClassificationFrame:SetShown(classificationFrameIsVisible)
		end
	end

	-- Update icon
	Musician.NamePlates.UpdateNoteIcon(namePlate)
end

--- Update all nameplates
--
function Musician.NamePlates.UpdateAll()
	local namePlate
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
	if not(UnitIsPlayer(unitToken)) then return end

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
	local player = Musician.Utils.NormalizePlayerName(player)
	if not(playerNamePlates[player]) then return end
	Musician.NamePlates.AttachNamePlate(playerNamePlates[player], player, event)
end

--- Hide nameplates in cinematic mode if nameplates are not enabled in this mode
-- @param namePlate (Frame)
function Musician.NamePlates.UpdateNamePlateCinematicMode(namePlate)

	if InCombatLockdown() then return end

	local UIParentIsVisible = UIParent:IsVisible()

	-- Attach animated notes frame to WorldFrame if hiding nameplates in cinematic mode
	if not(Musician_Settings.cinematicModeNamePlates) and Musician_Settings.cinematicMode then
		local parent, scale
		if not(UIParentIsVisible) then
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

	-- Show or hide the nameplate
	if not(Musician_Settings.cinematicModeNamePlates) and Musician_Settings.cinematicMode then
		if not(UIParentIsVisible) then
			namePlate:Hide()
		else
			namePlate:Show()
		end
	elseif not(Musician_Settings.cinematicMode) then
		namePlate:SetShown(UIParentIsVisible)
	end
end

--- Update note icon next to player name
-- @param namePlate (Frame)
function Musician.NamePlates.UpdateNoteIcon(namePlate)
	Musician.NamePlates.AddNoteIcon(namePlate, namePlate.UnitFrame.name)
end

--- Add note icon in nameplate's textElement, if needed
-- @param namePlate (Frame)
-- @param textElement (FontString)
-- @param append (boolean) Add note icon at the end of the string
function Musician.NamePlates.AddNoteIcon(namePlate, textElement, append)
	local player = UnitIsPlayer(namePlate.namePlateUnitToken) and Musician.Utils.NormalizePlayerName(GetUnitName(namePlate.namePlateUnitToken, true))
	if player and not(Musician.Utils.PlayerIsMyself(player)) and Musician.Registry.PlayerIsRegistered(player) then
		local nameString = textElement:GetText()
		if nameString == nil then return end

		local iconPlaceholder = Musician.Utils.GetChatIcon("")

		-- Icon placeholder is present but not at the right position: remove it
		local from, to = string.find(nameString, iconPlaceholder, 1, true)
		if append and to and to ~= nameString or not(append) and from and from ~= 1 then
			nameString = string.sub(nameString, 1, from - 1) .. string.sub(nameString, to + 1, #nameString)
			nameString = strtrim(string.gsub(nameString, '%s+', ' '))
			from, to = nil, nil
		end

		-- Add icon placeholder if not found or previously removed
		if from == nil then
			if append then
				textElement:SetText(nameString .. " " .. iconPlaceholder)
			else
				textElement:SetText(iconPlaceholder .. " " .. nameString)
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

		textElement.noteIcon:ClearAllPoints()
		if append then
			textElement.noteIcon:SetPoint("RIGHT", textElement, "RIGHT")
		else
			textElement.noteIcon:SetPoint("LEFT", textElement, "LEFT")
		end

		textElement.noteIcon.updateSize()
		textElement.noteIcon:Show()
	elseif textElement.noteIcon then
		textElement.noteIcon:Hide()
	end
end

--- Attach Musician nameplate
-- @param namePlate (Frame)
-- @param player (string)
-- @param event (string)
function Musician.NamePlates.AttachNamePlate(namePlate, player, event)

	Musician.NamePlates.UpdateNamePlate(namePlate)

	if not(Musician.Registry.PlayerIsRegistered(player)) then return end

	-- Create or show animated notes frames
	if not(namePlate.musicianAnimatedNotesFrame) then
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
end

--- Detach Musician nameplate
-- @param namePlate (Frame)
function Musician.NamePlates.DetachNamePlate(namePlate)

	if not(namePlate.musicianAnimatedNotesFrame) then return end

	-- Hide animated notes frame
	namePlate.musicianAnimatedNotesFrame:Hide()

	-- Remove animated notes frames
	while namePlate.musicianAnimatedNotesFrame:GetNumChildren() > 0 do
		removeNote(select(1, namePlate.musicianAnimatedNotesFrame:GetChildren()))
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
	if song:TrackIsMuted(track) then return end
	if not(song.player) and song ~= Musician.streamingSong then return end

	if song ~= Musician.streamingSong and not(Musician.Utils.PlayerIsMyself(song.player)) then
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
	if not(isVisible) then
		if Musician_Settings.cinematicMode then
			SetInWorldUIVisibility(true)
		end
	else
		SetInWorldUIVisibility(true)
	end
end

--- Initialize tips and tricks
--
function Musician.NamePlates.InitTipsAndTricks()
	-- Already shown
	if Musician_Settings.namePlatesHintShown then return end

	-- Already enabled
	local nameplatesEnabled = C_CVar.GetCVarBool("nameplateShowAll") and C_CVar.GetCVarBool("nameplateShowFriends")
	if nameplatesEnabled then
		Musician_Settings.namePlatesHintShown = true
		return
	end

	-- Add tip
	Musician.AddTipsAndTricks(function()
		MusicianNamePlatesTipsAndTricks:Show()
	end, true)
end