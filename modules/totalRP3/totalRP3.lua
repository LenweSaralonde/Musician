Musician.TRP3 = LibStub("AceAddon-3.0"):NewAddon("Musician.TRP3", "AceEvent-3.0")

local MODULE_NAME = "TRP3"
Musician.AddModule(MODULE_NAME)

function Musician.TRP3:OnEnable()
	if TRP3_API then
		Musician.Utils.Debug(MODULE_NAME, "Total RP3 module started.")
		Musician.TRP3.HookNamePlates()
		Musician.TRP3.HookPlayerMap()
		TRP3_API.Events.registerCallback("WORKFLOW_ON_FINISH", function()
			Musician.TRP3.HookTooltip()
		end)
	end
end

--- Hook TRP player tooltip
--
function Musician.TRP3.HookTooltip()
	Musician.Utils.Debug(MODULE_NAME, "Adding tooltip support.")

	-- Add Musician version to Total RP player tooltip
	TRP3_CharacterTooltip:HookScript("OnShow", function(t)
		Musician.Registry.UpdateTooltipInfo(TRP3_CharacterTooltip, t.target, TRP3_API.ui.tooltip.getSmallLineFontSize())
	end)

	--- Update Total RP player tooltip to add missing Musician client version, if applicable.
	hooksecurefunc(Musician.Registry, "UpdatePlayerTooltip", function(player)
		if TRP3_CharacterTooltip ~= nil and TRP3_CharacterTooltip.target == player then
			Musician.Registry.UpdateTooltipInfo(TRP3_CharacterTooltip, player, TRP3_API.ui.tooltip.getSmallLineFontSize())
		end
	end)
end

--- Hook TRP player nameplates (standard)
--
function Musician.TRP3.HookNamePlates()
	if AddOn_TotalRP3 and AddOn_TotalRP3.NamePlates and AddOn_TotalRP3.NamePlates.BlizzardDecoratorMixin then
		Musician.Utils.Debug(MODULE_NAME, "Adding nameplate support.")
		hooksecurefunc(AddOn_TotalRP3.NamePlates.BlizzardDecoratorMixin, "UpdateNamePlateName", function(self, namePlate)
			Musician.NamePlates.UpdateNoteIcon(namePlate)
		end)
	end
end

--- Hook TRP player map
--
function Musician.TRP3.HookPlayerMap()

	if TRP3_PlayerMapPinMixin then

		if TRP3_PlayerMapPinMixin.GetDisplayDataFromPoiInfo then
			local TRP3_PlayerMapPinMixin_GetDisplayDataFromPoiInfo = TRP3_PlayerMapPinMixin.GetDisplayDataFromPoiInfo
			TRP3_PlayerMapPinMixin.GetDisplayDataFromPoiInfo = function(self, poiInfo, ...)
				local displayData = TRP3_PlayerMapPinMixin_GetDisplayDataFromPoiInfo(self, poiInfo, ...)

				displayData.musicianIsRegistered = Musician.Registry.PlayerIsRegistered(poiInfo.sender)

				-- Slightly raise priority if the player has no special relationship with this one
				if displayData.musicianIsRegistered and displayData.categoryPriority == -1 then
					displayData.categoryPriority = -.5
				end

				return displayData
			end
		end

		if TRP3_PlayerMapPinMixin.Decorate then
			local TRP3_PlayerMapPinMixin_Decorate = TRP3_PlayerMapPinMixin.Decorate
			TRP3_PlayerMapPinMixin.Decorate = function(self, displayData, ...)

				local newDisplayData = Mixin({}, displayData)

				-- Append note icon to player name and replace pin texture by a musical note
				if displayData.musicianIsRegistered then
					newDisplayData.playerName = newDisplayData.playerName .. " " .. Musician.Utils.GetChatIcon(Musician.IconImages.Note)
					self.Texture:SetTexture("Interface\\AddOns\\Musician\\ui\\textures\\map-pin.blp")
					self.HighlightTexture:SetTexture("Interface\\AddOns\\Musician\\ui\\textures\\map-pin-highlight.blp")
				end

				TRP3_PlayerMapPinMixin_Decorate(self, newDisplayData, ...)
			end
		end
	end

end
