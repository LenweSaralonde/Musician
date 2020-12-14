--- Options for CrossRP
-- @module Musician.CrossRP.Options

Musician.CrossRP.Options = {}

local MODULE_NAME = "CrossRP.Options"
Musician.AddModule(MODULE_NAME)

local ALLIANCE_ICON = 2175463 -- interface/icons/ui_allianceicon-round.blp
local HORDE_ICON = 2175464 -- interface/icons/ui_hordeicon-round.blp

local NBSP = " " -- non breaking space

--- Init
--
function Musician.CrossRP.Options.Init()
	C_Timer.NewTicker(1, Musician.CrossRP.Options.UpdateActiveBands)
	MusicianOptionsPanelCrossRP:SetScript("OnShow", Musician.CrossRP.Options.UpdateActiveBands)
	MusicianOptionsPanelCrossRPImage:ClearAllPoints()
	MusicianOptionsPanelCrossRPImage:SetPoint("BOTTOMRIGHT", 10, 10)
	MusicianOptionsPanelCrossRPSubText:SetJustifyH("LEFT")
end

--- Update active bands list in options panel
--
function Musician.CrossRP.Options.UpdateActiveBands()
	if MusicianOptionsPanelCrossRPSubText:IsVisible() then
		local bands = Musician.CrossRP.Options.GetActiveBandStrings()
		if #bands > 0 then
			local bandsText = strjoin("  ", unpack(bands))
			local text = string.gsub(Musician.Msg.OPTIONS_CROSS_RP_SUB_TEXT_ACTIVE, "{bands}", bandsText)
			MusicianOptionsPanelCrossRPSubText:SetText(text)
		else
			MusicianOptionsPanelCrossRPSubText:SetText(Musician.Msg.OPTIONS_CROSS_RP_SUB_TEXT_NO_GATEWAY)
		end
	end
end

--- Get active bands as strings
-- @return {table}
function Musician.CrossRP.Options.GetActiveBandStrings()
	local status = CrossRP.Proto.GetNetworkStatus()
	local item

	local bands = {}

	for _, item in ipairs(status) do
		local name = string.gsub(item.name, "%s[^%s]+$", "")
		name = string.gsub(name, " ", NBSP)
		local f = string.sub(item.band, #item.band)
		if f == "A" then
			name = Musician.Utils.GetChatIcon(ALLIANCE_ICON) .. NBSP .. name
		elseif f == "H" then
			name = Musician.Utils.GetChatIcon(HORDE_ICON) .. NBSP .. name
		end
		table.insert(bands, name)
	end

	return bands
end

hooksecurefunc(Musician.Options, "Refresh", function()
	MusicianOptionsPanelCrossRPImage:SetFrameLevel(MusicianOptionsPanelCrossRP:GetFrameLevel() - 1)
	MusicianOptionsPanelCrossRPImage:Show()
end)

hooksecurefunc(Musician.Options, "Cancel", function()
	MusicianOptionsPanelCrossRPImage:Hide()
end)

hooksecurefunc(Musician.Options, "Save", function(fromButton)
	MusicianOptionsPanelCrossRPImage:Hide()
end)