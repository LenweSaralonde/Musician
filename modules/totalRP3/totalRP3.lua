--- Total RP 3 integration including RP player names, nameplates, tooltips and map scan.
-- @module Musician.TRP3

Musician.TRP3 = LibStub("AceAddon-3.0"):NewAddon("Musician.TRP3", "AceEvent-3.0")

local MODULE_NAME = "TRP3"
Musician.AddModule(MODULE_NAME)

local playersPlayingMusic = {}
local IS_PLAYING_TIMEOUT = 3
local PIN_TEXTURE = 'Interface\\AddOns\\Musician\\ui\\textures\\map-pin'
local PIN_HIGHLIGHT_TEXTURE = 'Interface\\AddOns\\Musician\\ui\\textures\\map-pin-highlight'
local CONFIG_TOOLTIP_MAIN_COLOR = "tooltip_main_color"

function Musician.TRP3:OnEnable()
	if TRP3_API then
		-- Check third party add-on API
		if not Musician.Utils.CheckModuleDependencies("Total RP 3", Musician.TRP3.CheckAPI) then
			return
		end

		Musician.Utils.Debug(MODULE_NAME, "Total RP3 module started.")

		-- Init settings
		Musician_Settings = Mixin(Musician.TRP3.Options.GetDefaults(), Musician_Settings)

		Musician.TRP3.HookPlayerNames()
		Musician.TRP3.HookNamePlates()
		Musician.TRP3.HookPlayerMap()
		if TRP3_CharacterTooltip then
			Musician.TRP3.HookTooltip()
		else
			TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_FINISH, Musician.TRP3.HookTooltip)
		end
		Musician.TRP3:RegisterMessage(Musician.Events.SongChunk, Musician.TRP3.OnSongChunk)
	end
end

--- Check the TRP3 API is valid
-- @return isValid (boolean)
function Musician.TRP3.CheckAPI()
	local ok, apiOk = pcall(function()
		return
			TRP3_API.CreateColorFromHexString and
			TRP3_RefTooltip.Show and
			TRP3_API.CreateColorFromHexString and
			TRP3_API.globals and
			TRP3_API.configuration.getValue and
			TRP3_API.utils.str.id and
			TRP3_API.ui.frame.createTabPanel and
			TRP3_API.ui.tooltip and
			TRP3_API.popup.showPopup and
			TRP3_API.popup.ICONS and
			TRP3_API.RegisterCallback and
			TRP3_API.loc.EDITOR_PREVIEW and
			TRP3_API.loc.EDITOR_ICON_SELECT and
			TRP3_Addon.Events.WORKFLOW_ON_FINISH and
			TRP3_PlayerMapPinMixin and
			TRP3_PlayerMapPinMixin.Decorate and
			TRP3_PlayerMapPinMixin.GetDisplayDataFromPoiInfo and
			AddOn_TotalRP3.Player.static.CreateFromCharacterID and
			TRP3_NamePlates.RegisterCallback and
			TRP3_NamePlates.UpdateAllNamePlates and
			TRP3_API.utils.getIconTexture and
			TRP3_NamePlatesUtil.GetPreferredIconSize
	end)
	return ok and apiOk
end

--- Return RP display name for player
-- @param player (string)
-- @return (string)
function Musician.TRP3.GetRpName(player)
	player = Musician.Utils.GetFullPlayerName(player)
	local trpPlayer = AddOn_TotalRP3.Player.static.CreateFromCharacterID(player)
	return trpPlayer:GetCustomColoredRoleplayingNamePrefixedWithIcon()
end

--- Hook player name formatting
--
function Musician.TRP3.HookPlayerNames()
	Musician.Utils.FormatPlayerName = Musician.TRP3.GetRpName
end

--- Hook TRP player tooltip
--
function Musician.TRP3.HookTooltip()
	Musician.Utils.Debug(MODULE_NAME, "Adding tooltip support.")

	-- Add Musician version to Total RP player tooltip
	TRP3_CharacterTooltip:HookScript("OnShow", function(t)
		Musician.TRP3.UpdateTooltipInfo(t.target)
	end)

	-- Update Total RP player tooltip to add missing Musician client version, if applicable.
	hooksecurefunc(Musician.Registry, "UpdatePlayerTooltip", function(player)
		if TRP3_CharacterTooltip ~= nil and TRP3_CharacterTooltip.target == player then
			Musician.TRP3.UpdateTooltipInfo(player)
		end
	end)
end

--- Hook TRP player nameplates
--
function Musician.TRP3.HookNamePlates()
	if not Musician.NamePlates then return end
	-- Hook Blizzard nameplates module
	if TRP3_BlizzardNamePlates and TRP3_BlizzardNamePlates.UpdateNamePlate then
		Musician.Utils.Debug(MODULE_NAME, "Adding Blizzard nameplates support.")
		hooksecurefunc(TRP3_BlizzardNamePlates, "UpdateNamePlate", function(self, namePlate)
			if namePlate and namePlate.UnitFrame then
				Musician.NamePlates.UpdateNamePlate(namePlate)
			end
		end)
	end
	-- Hook Plater nameplates module
	if TRP3_PlaterNamePlates and TRP3_PlaterNamePlates.CustomizeNameplate then
		Musician.Utils.Debug(MODULE_NAME, "Adding Plater nameplates support.")
		-- Prevent the TRP3 icon from remaining visible in cinematic mode
		hooksecurefunc(TRP3_PlaterNamePlates, "CustomizeNameplate", function(self, namePlate, _, displayInfo)
			if namePlate:IsForbidden() then
				return
			end
			if namePlate.TRP3Icon and namePlate.CurrentUnitNameString then
				local shouldDisplayTrp3Icon = namePlate.CurrentUnitNameString:IsVisible() and displayInfo.icon and
					not displayInfo.shouldHide
				namePlate.TRP3Icon:SetShown(shouldDisplayTrp3Icon)
			end
		end)
	end
	-- Force refreshing the nameplates on TRP side when toggling the cinematic mode
	-- to avoid player names showing in NPCs nameplates.
	UIParent:HookScript("OnShow", function() TRP3_NamePlates:UpdateAllNamePlates() end)
	UIParent:HookScript("OnHide", function() TRP3_NamePlates:UpdateAllNamePlates() end)
	-- Update Musician nameplates with TRP3 info
	TRP3_NamePlates.RegisterCallback(Musician.TRP3, "OnNamePlateDataUpdated")
end

--- Update the Musician nameplate with TRP info
--
function Musician.TRP3:OnNamePlateDataUpdated(_, namePlate, _, displayInfo)
	if namePlate:IsForbidden() or not namePlate:IsShown() or not displayInfo or not namePlate.musicianUnitFrame then
		return
	end
	-- Attach icon
	if not namePlate.musicianUnitFrame.trp3Icon then
		namePlate.musicianUnitFrame.trp3Icon = namePlate.musicianUnitFrame:CreateTexture(nil, "ARTWORK")
		namePlate.musicianUnitFrame.trp3Icon:ClearAllPoints()
		namePlate.musicianUnitFrame.trp3Icon:SetPoint("RIGHT", namePlate.musicianUnitFrame.name, "LEFT", -4, 0)
		namePlate.musicianUnitFrame.trp3Icon:Hide()
	end
	-- Update icon
	if displayInfo.icon and namePlate.musicianUnitFrame.trp3Icon and not displayInfo.shouldHide then
		namePlate.musicianUnitFrame.trp3Icon:ClearAllPoints()
		namePlate.musicianUnitFrame.trp3Icon:SetTexture(TRP3_API.utils.getIconTexture(displayInfo.icon))
		namePlate.musicianUnitFrame.trp3Icon:SetSize(TRP3_NamePlatesUtil.GetPreferredIconSize())
		namePlate.musicianUnitFrame.trp3Icon:SetPoint("RIGHT", namePlate.musicianUnitFrame.name, "LEFT", -4, 0)
		namePlate.musicianUnitFrame.trp3Icon:Show()
	elseif namePlate.musicianUnitFrame.trp3Icon then
		namePlate.musicianUnitFrame.trp3Icon:Hide()
	end
end

--- Update the TRP3 player tooltip info with Musician version information.
-- @param player (string)
function Musician.TRP3.UpdateTooltipInfo(player)
	local r, g, b
	if TRP3_Configuration and TRP3_Configuration[CONFIG_TOOLTIP_MAIN_COLOR] then
		local mainColorHex = TRP3_API.configuration.getValue(CONFIG_TOOLTIP_MAIN_COLOR)
		local mainColor = TRP3_API.CreateColorFromHexString(mainColorHex)
		r, g, b = mainColor.r, mainColor.g, mainColor.b
	end
	Musician.Registry.UpdateTooltipInfo(TRP3_CharacterTooltip, player, 10, r, g, b)
end

--- Return true if the player is currently playing some music
-- @param player (string)
-- @return (boolean)
function Musician.TRP3.IsPlayingMusic(player)
	if not playersPlayingMusic[player] then return false end

	if playersPlayingMusic[player] + IS_PLAYING_TIMEOUT < GetTime() then
		playersPlayingMusic[player] = nil
		return false
	end

	return true
end

--- OnSongChunk
--
function Musician.TRP3.OnSongChunk(event, sender)
	local now = GetTime()

	playersPlayingMusic[sender] = now

	for playerName, time in pairs(playersPlayingMusic) do
		if time + IS_PLAYING_TIMEOUT < now then
			playersPlayingMusic[playerName] = nil
		end
	end
end

--- Hook TRP player map
--
function Musician.TRP3.HookPlayerMap()
	if TRP3_PlayerMapPinMixin then
		-- TRP3_PlayerMapPinMixin.GetDisplayDataFromPoiInfo
		--
		if TRP3_PlayerMapPinMixin.GetDisplayDataFromPoiInfo then
			local TRP3_PlayerMapPinMixin_GetDisplayDataFromPoiInfo = TRP3_PlayerMapPinMixin.GetDisplayDataFromPoiInfo
			TRP3_PlayerMapPinMixin.GetDisplayDataFromPoiInfo = function(self, poiInfo, ...)
				local displayData = TRP3_PlayerMapPinMixin_GetDisplayDataFromPoiInfo(self, poiInfo, ...)

				if not Musician_Settings.trp3MapScan then return displayData end

				local sender = poiInfo.sender
				displayData.musicianIsRegistered = Musician.Registry.PlayerIsRegistered(sender)
				displayData.musicianPlayer = sender

				-- Check if the player is actually playing music
				displayData.musicianIsPlayingMusic = false
				if playersPlayingMusic[sender] then
					if playersPlayingMusic[sender] + IS_PLAYING_TIMEOUT < GetTime() then
						playersPlayingMusic[sender] = nil
					else
						displayData.musicianIsPlayingMusic = true
					end
				end

				-- Slightly raise priority if the player has no special relationship with this one
				if displayData.musicianIsRegistered and displayData.categoryPriority == -1 then
					if displayData.musicianIsPlayingMusic then
						displayData.categoryPriority = 99
					else
						displayData.categoryPriority = -.5
					end
				end

				return displayData
			end
		end

		-- TRP3_PlayerMapPinMixin.Decorate
		--
		if TRP3_PlayerMapPinMixin.Decorate then
			local TRP3_PlayerMapPinMixin_Decorate = TRP3_PlayerMapPinMixin.Decorate
			TRP3_PlayerMapPinMixin.Decorate = function(self, displayData, ...)
				local newDisplayData = Mixin({}, displayData)

				-- Append note icon to player name and replace pin texture by a musical note
				if Musician_Settings.trp3MapScan and displayData.musicianIsRegistered then
					local icon

					local isPlayingMusic = Musician.TRP3.IsPlayingMusic(displayData.musicianPlayer)
					if isPlayingMusic then
						icon = Musician.Utils.GetChatIcon(Musician.IconImages.Note, 1, .82, 0)
					else
						icon = Musician.Utils.GetChatIcon(Musician.IconImages.Note)
					end

					newDisplayData.playerNameColored = newDisplayData.playerNameColored .. " " .. icon
					newDisplayData.playerNameFancy = newDisplayData.playerNameFancy .. " " .. icon
					self.Texture:SetTexture(PIN_TEXTURE)
					self.HighlightTexture:SetTexture(PIN_HIGHLIGHT_TEXTURE)

					TRP3_PlayerMapPinMixin_Decorate(self, newDisplayData, ...)

					self.Texture:SetSize(20, 20)
					self.HighlightTexture:SetSize(20, 20)
					self:SetSize(20, 20)
				else
					TRP3_PlayerMapPinMixin_Decorate(self, newDisplayData, ...)
				end
			end
		end
	end
end
