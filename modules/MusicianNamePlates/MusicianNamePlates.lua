Musician.NamePlates = LibStub("AceAddon-3.0"):NewAddon("Musician.NamePlates", "AceEvent-3.0")

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

--- OnEnable
--
function Musician.NamePlates:OnEnable()
	Musician.NamePlates.CreatePlayerAnimatedNotesFrame()

	-- Name plate added
	Musician.NamePlates:RegisterEvent("NAME_PLATE_UNIT_ADDED", Musician.NamePlates.OnNamePlateAdded)

	-- Name plate removed
	Musician.NamePlates:RegisterEvent("NAME_PLATE_UNIT_REMOVED", Musician.NamePlates.OnNamePlateRemoved)

	-- Player registered
	Musician.NamePlates:RegisterMessage(Musician.Registry.event.playerRegistered, Musician.NamePlates.OnPlayerRegistered)

	-- Note On
	Musician.NamePlates:RegisterMessage(Musician.Events.NoteOn, Musician.NamePlates.OnNoteOn)
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
	noteFrame.texture:Hide()
	noteFrame:SetParent(nil)
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

	-- Adjust frame position for fixed player frame (not hooked to a name plate)
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

--- OnNamePlateAdded
-- @param event (string)
-- @param unitToken (string)
function Musician.NamePlates.OnNamePlateAdded(event, unitToken)
	if not(UnitIsPlayer(unitToken)) then return end

	-- May return "Unknown" on first attempt: try again later.
	if GetUnitName(unitToken, true) == UNKNOWN then
		C_Timer.After(.1, function()
			Musician.NamePlates.OnNamePlateAdded(event, unitToken)
		end)
		return
	end

	-- Add references to the name plate
	local player = Musician.Utils.NormalizePlayerName(GetUnitName(unitToken, true))
	playerNamePlates[player] = C_NamePlate.GetNamePlateForUnit(unitToken)
	playerNamePlates[player].musicianPlayer = player
	namePlatePlayers[unitToken] = player

	-- Attach name plate
	Musician.NamePlates.AttachNamePlate(playerNamePlates[player], player)
end

--- OnNamePlateRemoved
-- @param event (string)
-- @param unitToken (string)
function Musician.NamePlates.OnNamePlateRemoved(event, unitToken)
	if not(UnitIsPlayer(unitToken)) then return end

	-- Detach name plate and remove references
	local player = namePlatePlayers[unitToken]
	if player and playerNamePlates[player] then
		Musician.NamePlates.DetachNamePlate(playerNamePlates[player])
		playerNamePlates[player].musicianPlayer = nil
		playerNamePlates[player] = nil
	end

	namePlatePlayers[unitToken] = nil
end

--- Update name plate for player when registered
-- @param event (string)
-- @param player (string)
function Musician.NamePlates.OnPlayerRegistered(event, player)
	local player = Musician.Utils.NormalizePlayerName(player)
	if not(playerNamePlates[player]) then return end
	Musician.NamePlates.AttachNamePlate(playerNamePlates[player], player)
end

--- Update the note icon for the name plate unit name frame
-- @param namePlate (Frame)
-- @param unitFrame (Frame)
-- @param textObject (FontString)
function Musician.NamePlates.updateNoteIcon(namePlate, unitFrame, textObject)
	-- Create icon frame
	if not(unitFrame.musicianNoteIcon) then
		unitFrame.musicianNoteIcon = CreateFrame("Frame")
		unitFrame.musicianNoteIcon:SetParent(unitFrame)
		unitFrame.musicianNoteIcon:SetWidth(textObject:GetHeight())
		unitFrame.musicianNoteIcon:SetScript("OnSizeChanged", function(self, width, height)
			self:SetWidth(textObject:GetHeight())
		end)
		unitFrame.musicianNoteIcon:SetPoint("TOPRIGHT", textObject, "TOPLEFT", -3, 0)
		unitFrame.musicianNoteIcon:SetPoint("BOTTOMRIGHT", textObject, "BOTTOMLEFT", -3, 0)
		unitFrame.musicianNoteIcon.texture = unitFrame.musicianNoteIcon:CreateTexture(nil, "BACKGROUND")
		unitFrame.musicianNoteIcon.texture:SetAllPoints()
		unitFrame.musicianNoteIcon.texture:SetTexture(Musician.IconImages.Note)
	end

	-- Show it if player is registered
	if UnitIsPlayer(namePlate.namePlateUnitToken) and namePlate.musicianPlayer and not(Musician.Utils.PlayerIsMyself(namePlate.musicianPlayer)) and Musician.Registry.PlayerIsRegistered(namePlate.musicianPlayer) then
		textObject:SetPoint("CENTER", textObject:GetHeight() / 2 + 1.5, 0)
		unitFrame.musicianNoteIcon:Show()
	else
		textObject:SetPoint("CENTER", 0, 0)
		unitFrame.musicianNoteIcon:Hide()
	end
end

--- Update Musician icon in name plate
-- @param namePlate (Frame)
function Musician.NamePlates.updateNamePlateIcons(namePlate)
	if namePlate.UnitFrame and namePlate.UnitFrame.name then
		Musician.NamePlates.updateNoteIcon(namePlate, namePlate.UnitFrame, namePlate.UnitFrame.name)
	end
end

--- Attach Musician name plate
-- @param namePlate (Frame)
-- @param player (string)
function Musician.NamePlates.AttachNamePlate(namePlate, player)

	Musician.NamePlates.updateNamePlateIcons(namePlate)

	if not(Musician.Registry.PlayerIsRegistered(player)) then return end

	-- Create or show animated notes frames
	if not(namePlate.musicianAnimatedNotesFrame) then
		namePlate.musicianAnimatedNotesFrame = CreateFrame("Frame")
		namePlate.musicianAnimatedNotesFrame:SetParent(namePlate)
		namePlate.musicianAnimatedNotesFrame:SetFrameLevel(0)
		namePlate.musicianAnimatedNotesFrame:SetPoint("BOTTOM", namePlate, "BOTTOM", 0, -20)
		namePlate.musicianAnimatedNotesFrame:SetWidth(NOTES_ANIMATION_WIDTH)
		namePlate.musicianAnimatedNotesFrame:SetHeight(NOTES_ANIMATION_HEIGHT)
		namePlate.musicianAnimatedNotesFrame:SetScript("OnUpdate", Musician.NamePlates.OnNamePlateNotesFrameUpdate)
	else
		namePlate.musicianAnimatedNotesFrame:Show()
	end

	-- Set data
	namePlate.musicianAnimatedNotesFrame.player = player
	namePlate.musicianAnimatedNotesFrame.songId = nil
	namePlate.musicianAnimatedNotesFrame.race = select(2, UnitRace(namePlate.namePlateUnitToken))
	namePlate.musicianAnimatedNotesFrame.notesAddedDuringFrame = {}
end

--- Detach Musician name plate
-- @param namePlate (Frame)
function Musician.NamePlates.DetachNamePlate(namePlate)

	Musician.NamePlates.updateNamePlateIcons(namePlate)

	if not(namePlate.musicianAnimatedNotesFrame) then return end

	-- Hide animated notes frame
	namePlate.musicianAnimatedNotesFrame:Hide()

	-- Remove animated notes frames
	local noteFrame
	local children = { namePlate.musicianAnimatedNotesFrame:GetChildren() }
	for _, noteFrame in ipairs(children) do
		removeNote(noteFrame)
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
	if not(song.player) then return end

	if not(Musician.Utils.PlayerIsMyself(song.player)) then
		local namePlate = playerNamePlates[song.player]
		if namePlate then
			addNote(namePlate.musicianAnimatedNotesFrame, song, track, key)
		end
	else
		addNote(playerAnimatedNotesFrame, song, track, key)
	end
end

