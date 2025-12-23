--- Shows position of currently playing musicians on the world map.
-- @module Musician.Map

Musician.Map = LibStub("AceAddon-3.0"):NewAddon("Musician.Map", "AceEvent-3.0")

local MODULE_NAME = "Map"
Musician.AddModule(MODULE_NAME)

local HereBeDragons_Pins = LibStub("HereBeDragons-Pins-2.0")

local PIN_TEMPLATE_WORLD_MAP = 'MusicianWorldMapPinTemplate'
local PIN_TEMPLATE_MINI_MAP = 'MusicianMiniMapPinTemplate'

local PIN_TEXTURE = 'Interface\\AddOns\\Musician\\ui\\textures\\map-pin'
local PIN_PING_TEXTURE = 'Interface\\AddOns\\Musician\\ui\\textures\\map-pin-ping'
local PIN_HIGHLIGHT_TEXTURE = 'Interface\\AddOns\\Musician\\ui\\textures\\map-pin-highlight'

local activePlayers = {}
local worldMapPlayerPins = {}
local miniMapPlayerPins = {}

local miniMapPinPool

Musician.Map.TRACKING = {}
Musician.Map.TRACKING.MINIMAP = 'mini'
Musician.Map.TRACKING.WORLDMAP = 'world'
local TRACKING = Musician.Map.TRACKING

--- Convert the world coordinates into map coordinates
-- Wrapper for C_Map.GetMapPosFromWorldPos
-- @param instanceID (number)
-- @param posX (number)
-- @param posY (number)
-- @param overrideUiMapID (number)
-- @return uiMapID (number)
-- @return mapX (number)
-- @return mapY (number)
local function worldToMapCoordinates(instanceID, posX, posY, overrideUiMapID)
	local worldPosition = CreateVector2D(posY, posX) -- X and Y coordinates have to be swapped
	local success, uiMapID, mapPosition = pcall(function()
		return C_Map.GetMapPosFromWorldPos(instanceID, worldPosition, overrideUiMapID)
	end)

	if success and uiMapID then
		local mapX, mapY = mapPosition:GetXY()
		return uiMapID, mapX, mapY
	end

	return nil
end

--- Return map tracking option setting
-- @param option (string) from Musician.Map.TRACKING
-- @return enabled (boolean)
local function getTrackingOption(option)
	return Musician_CharacterSettings.tracking[option]
end

--- Set map tracking option setting
-- @param option (string) from Musician.Map.TRACKING
-- @param enabled (boolean)
local function setTrackingOption(option, enabled)
	Musician_CharacterSettings.tracking[option] = enabled
end

--- OnEnable
--
function Musician.Map:OnEnable()
	-- Init character settings
	local defaultCharacterSettings = {
		tracking = {
			[Musician.Map.TRACKING.MINIMAP] = true,
			[Musician.Map.TRACKING.WORLDMAP] = true,
		},
	}
	Musician_CharacterSettings = Mixin(defaultCharacterSettings, Musician_CharacterSettings or {})

	-- Remove obsolete global settings
	Musician_Settings.tracking = nil

	miniMapPinPool = CreateFramePool("FRAME", Minimap, PIN_TEMPLATE_MINI_MAP)
	self:RegisterMessage(Musician.Events.SongChunk, Musician.Map.OnSongChunk)
	hooksecurefunc(WorldMapFrame, 'OnMapChanged', Musician.Map.RefreshWorldMap)

	-- Tracking menu generators
	local function getMenuGenerator(getter, setter)
		return function(_, rootDescription)
			rootDescription:CreateDivider()
			rootDescription:CreateTitle(Musician.Msg.MAP_TRACKING_OPTIONS_TITLE)
			local checkbox = rootDescription:CreateCheckbox(Musician.Msg.MAP_TRACKING_OPTION_ACTIVE_MUSICIANS,
				getter,
				function() setter(not getter()) end)
			checkbox:AddInitializer(function(button)
				local rightTexture = button:AttachTexture()
				rightTexture:SetSize(20, 20)
				rightTexture:SetPoint("RIGHT")
				rightTexture:SetTexture(Musician.IconImages.Note)
			end)
		end
	end
	local miniMapMenuGenerator = getMenuGenerator(Musician.Map.GetMiniMapTracking, Musician.Map.SetMiniMapTracking)
	local worldMapMenuGenerator = getMenuGenerator(Musician.Map.GetWorldMapTracking, Musician.Map.SetWorldMapTracking)

	Menu.ModifyMenu("MENU_MINIMAP_TRACKING", miniMapMenuGenerator)
	Menu.ModifyMenu("MENU_WORLD_MAP_TRACKING", worldMapMenuGenerator) -- Retail
	if WorldMapFrame.WorldMapOptionsDropDown and WorldMapFrame.WorldMapOptionsDropDown.menuGenerator then
		hooksecurefunc(WorldMapFrame.WorldMapOptionsDropDown, 'menuGenerator', worldMapMenuGenerator) -- Classic
	end

	Musician.Map.MinimapTrackingUpdate()
end

--- OnSongChunk
-- Handler for Musician.Events.SongChunk
function Musician.Map.OnSongChunk(event, sender, mode, _, _, _, posY, posX, _, instanceID)
	sender = Musician.Utils.NormalizePlayerName(sender)

	-- Ignore myself
	if Musician.Utils.PlayerIsMyself(sender) then
		return
	end

	-- Cancel previous activity expiration timer
	if activePlayers[sender] ~= nil then
		activePlayers[sender].timer:Cancel()
	end

	-- Verify map ID
	local uiMapID = worldToMapCoordinates(instanceID, posX, posY)
	if uiMapID == nil then
		Musician.Map.RemovePlayer(sender)
		return
	end

	-- Determine map type
	local info = C_Map.GetMapInfo(uiMapID)

	-- Within a dungeon (mapType 4) or the coordinates are (0, 0): ignore
	if info.mapType == 4 or posX == 0 and posY == 0 then
		Musician.Map.RemovePlayer(sender)
		return
	end

	-- Remove player from active player list after the song chunk has expired
	local timeout = mode == Musician.Song.MODE_DURATION and 3 or 2
	local timer = C_Timer.NewTimer(timeout, function()
		Musician.Map.RemovePlayer(sender)
	end)

	-- Add player to active player list
	activePlayers[sender] = {
		timer = timer,
		posX = posX,
		posY = posY,
		instanceID = instanceID
	}

	-- Update player position
	Musician.Map.UpdatePlayer(sender, posX, posY, instanceID)
end

--- Get tracking setting for the world map
-- @return enabled (boolean)
function Musician.Map.GetWorldMapTracking()
	return getTrackingOption(TRACKING.WORLDMAP)
end

--- Set tracking setting for the world map
-- @param enabled (boolean)
function Musician.Map.SetWorldMapTracking(enabled)
	setTrackingOption(TRACKING.WORLDMAP, enabled)
	Musician.Map.RefreshWorldMap()
end

--- Get tracking setting for the mini map
-- @return enabled (boolean)
function Musician.Map.GetMiniMapTracking()
	return getTrackingOption(TRACKING.MINIMAP)
end

--- Set tracking setting for the mini map
-- @param enabled (boolean)
function Musician.Map.SetMiniMapTracking(enabled)
	setTrackingOption(TRACKING.MINIMAP, enabled)
	Musician.Map.RefreshMiniMap()
	Musician.Map.MinimapTrackingUpdate()
end

--- Update the minimap tracking
--
function Musician.Map.MinimapTrackingUpdate()
	if MiniMapTracking_Update and LE_EXPANSION_LEVEL_CURRENT > 0 then
		MiniMapTracking_Update()
	end
end

--- Update or add active player position to maps from world position
-- @param player (string)
-- @param posX (number)
-- @param posY (number)
-- @param instanceID (number)
function Musician.Map.UpdatePlayer(player, posX, posY, instanceID)
	if Musician.Map.GetWorldMapTracking() then
		Musician.Map.UpdateWorldMapPin(player, posX, posY, instanceID)
	end
	if Musician.Map.GetMiniMapTracking() then
		Musician.Map.UpdateMiniMapPin(player, posX, posY, instanceID)
	end
end

--- Remove active player from maps
--
function Musician.Map.RemovePlayer(player)
	if activePlayers[player] ~= nil then
		-- Cancel previous activity expiration timer
		if activePlayers[player].timer then
			activePlayers[player].timer:Cancel()
		end
		-- Wipe data
		wipe(activePlayers[player])
		activePlayers[player] = nil
	end
	-- Remove pins
	Musician.Map.RemoveWorldMapPin(player)
	Musician.Map.RemoveMiniMapPin(player)
end

--- Add or update player world map pin
-- @param player (string)
-- @param posX (number)
-- @param posY (number)
-- @param instanceID (number)
function Musician.Map.UpdateWorldMapPin(player, posX, posY, instanceID)
	local map = WorldMapFrame

	-- Determine player position on the map
	local uiMapID, mapX, mapY = worldToMapCoordinates(instanceID, posX, posY, map:GetMapID())

	-- Position is valid for the current map
	if uiMapID then
		local position = CreateVector2D(mapX, mapY)

		if worldMapPlayerPins[player] == nil then
			-- Create a new pin
			if not InCombatLockdown() then
				worldMapPlayerPins[player] = map:AcquirePin(PIN_TEMPLATE_WORLD_MAP, {
					player = player,
					name = Musician.Utils.FormatPlayerName(player),
					position = position
				})
			end
		else
			-- Update pin position
			worldMapPlayerPins[player]:SetPosition(position:GetXY())
		end
	else
		-- Position is invalid: remove existing pin
		Musician.Map.RemoveWorldMapPin(player)
	end
end

--- Remove player world map pin
-- @param player (string)
function Musician.Map.RemoveWorldMapPin(player)
	local pin = worldMapPlayerPins[player]
	if pin ~= nil then
		WorldMapFrame:RemovePin(pin)
		worldMapPlayerPins[player] = nil
	end
end

--- Refresh world map pins
--
function Musician.Map.RefreshWorldMap()
	if Musician.Map.GetWorldMapTracking() then
		for player, data in pairs(activePlayers) do
			Musician.Map.UpdateWorldMapPin(player, data.posX, data.posY, data.instanceID)
		end
	else
		WorldMapFrame:RemoveAllPinsByTemplate(PIN_TEMPLATE_WORLD_MAP)
		wipe(worldMapPlayerPins)
	end
end

--- Add or update player minimap pin
-- @param player (string)
-- @param posX (number)
-- @param posY (number)
-- @param instanceID (number)
function Musician.Map.UpdateMiniMapPin(player, posX, posY, instanceID)
	local pin = miniMapPlayerPins[player]
	if pin == nil then
		pin = miniMapPinPool:Acquire()
		pin:SetScript('OnEnter', pin.OnEnter)
		pin:SetScript('OnLeave', pin.OnLeave)
		miniMapPlayerPins[player] = pin
	end
	pin.name = Musician.Utils.FormatPlayerName(player)
	HereBeDragons_Pins:AddMinimapIconWorld(Musician.Map, pin, instanceID, posX, posY, false)
end

--- Remove player minimap pin
-- @param player (string)
function Musician.Map.RemoveMiniMapPin(player)
	local pin = miniMapPlayerPins[player]
	if pin ~= nil then
		HereBeDragons_Pins:RemoveMinimapIcon(Musician.Map, pin)
		miniMapPinPool:Release(pin)
		miniMapPlayerPins[player] = nil
	end
end

--- Refresh minimap pins
--
function Musician.Map.RefreshMiniMap()
	if Musician.Map.GetMiniMapTracking() then
		for player, data in pairs(activePlayers) do
			Musician.Map.UpdateMiniMapPin(player, data.posX, data.posY, data.instanceID)
		end
	else
		HereBeDragons_Pins:RemoveAllMinimapIcons(Musician.Map)
		wipe(miniMapPlayerPins)
	end
end

--- World map pin mixin
--

MusicianWorldMapPoiMixin = CreateFromMixins(BaseMapPoiPinMixin)

function MusicianWorldMapPoiMixin:OnLoad()
	BaseMapPoiPinMixin.OnLoad(self)
	self:SetScript('OnUpdate', MusicianWorldMapPoiMixin.OnUpdate)
end

function MusicianWorldMapPoiMixin:OnAcquired(poiInfo)
	self.blinkTime = 0
	BaseMapPoiPinMixin.OnAcquired(self, poiInfo)
	self:UseFrameLevelType('PIN_FRAME_LEVEL_GROUP_MEMBER')
	self.player = poiInfo.player
end

function MusicianWorldMapPoiMixin:SetTexture()
	self.Texture:SetTexture(PIN_TEXTURE)
	self.PingTexture:SetTexture(PIN_PING_TEXTURE)
	self.HighlightTexture:SetTexture(PIN_HIGHLIGHT_TEXTURE)
end

function MusicianWorldMapPoiMixin:OnUpdate(elapsed)
	self.blinkTime = self.blinkTime + elapsed
	local ping = self.blinkTime % 1
	self.PingTexture:Show()
	self.PingTexture:SetScale(Lerp(1, 4, ping))
	self.PingTexture:SetVertexColor(1, 1, .8, Lerp(.75, 0, ping))
end

--- Minimap pin mixin
--

MusicianMiniMapPoiMixin = {}

function MusicianMiniMapPoiMixin:OnEnter()
	GameTooltip:SetOwner(self, 'ANCHOR_CURSOR')
	GameTooltip:SetText('0') -- Workaround for colored text issues with chinese client
	GameTooltip:SetText(self.name, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	GameTooltip:Show()
end

function MusicianMiniMapPoiMixin:OnLeave()
	GameTooltip:Hide()
end
