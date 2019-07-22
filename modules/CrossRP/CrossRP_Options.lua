Musician.CrossRP.Options = {}

local MODULE_NAME = "CrossRP.Options"
Musician.AddModule(MODULE_NAME)

local ALLIANCE_ICON = 2175463 -- interface/icons/ui_allianceicon-round.blp
local HORDE_ICON = 2175464 -- interface/icons/ui_hordeicon-round.blp

local NBSP = " " -- non breaking space

--- Init
--
Musician.CrossRP.Options.Init = function()
	C_Timer.NewTicker(1, Musician.CrossRP.Options.UpdateActiveBands)
	MusicianOptionsPanelCrossRP:SetScript("OnShow", Musician.CrossRP.Options.UpdateActiveBands)
end

--- Update active bands list in options panel
--
Musician.CrossRP.Options.UpdateActiveBands = function()
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
Musician.CrossRP.Options.GetActiveBandStrings = function()
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
	MusicianOptionsPanelCrossRPImage:Show()
end)

hooksecurefunc(Musician.Options, "Cancel", function()
	MusicianOptionsPanelCrossRPImage:Hide()
end)

hooksecurefunc(Musician.Options, "Save", function(fromButton)
	MusicianOptionsPanelCrossRPImage:Hide()
end)