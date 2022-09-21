--- About window
-- @module Musician.About

Musician.About = LibStub("AceAddon-3.0"):NewAddon("Musician.About")

local MODULE_NAME = "MusicianAbout"
Musician.AddModule(MODULE_NAME)

local function highlightUrl(text, url)
	return (string.gsub(text, "{url}", Musician.Utils.GetUrlLink(url)))
end

local function randomizeHighlight(coloredList, list, color)
	list = Musician.Utils.DeepCopy(list)
	while #list > 0 do
		table.insert(coloredList, Musician.Utils.Highlight(table.remove(list, random(1, #list)), color))
	end
end

--- Init
--
function Musician.About.Init()
	MusicianAbout:SetClampedToScreen(true)
	Musician.EnableHyperlinks(MusicianAbout)
	MusicianAbout:SetScript("OnShow", Musician.About.OnShow)
end

--- OnShow handler
--
function Musician.About.OnShow()
	MusicianAboutTitle:SetText(Musician.Msg.ABOUT_TITLE)

	local versionStr = string.gsub(Musician.Msg.ABOUT_VERSION, "{version}", Musician.Utils.GetVersionText())
	MusicianAboutVersion:SetText(versionStr)

	MusicianAboutAuthor:SetText(highlightUrl(Musician.Msg.ABOUT_AUTHOR, Musician.URL))

	-- Localization Team
	local translators = {}
	for _, row in pairs(Musician.LocalizationTeam) do
		local locale = row[1]
		for i = 2, #row do
			local translator = row[i]
			if translators[translator] == nil then
				translators[translator] = {}
			end
			for _, localeCode in pairs(Musician.Locale[locale].LOCALE_CODES) do
				if localeCode == 'enGB' then localeCode = 'enUS' end
				translators[translator][localeCode] = localeCode
			end
		end
	end
	local translatorsFlat = {}
	for translator, localeCodes in pairs(translators) do
		local localCodesFlat = {}
		for _, localeCode in pairs(localeCodes) do
			table.insert(localCodesFlat, localeCode)
		end
		table.insert(translatorsFlat, { translator, localCodesFlat })
	end
	table.sort(translatorsFlat, function(a, b)
		return a[1] ~= Musician.DefaultTranslator and b[1] == Musician.DefaultTranslator
	end)
	local translatorsText = {}
	for _, row in pairs(translatorsFlat) do
		table.insert(translatorsText, row[1] .. " (" .. strjoin(", ", unpack(row[2])) .. ")")
	end

	MusicianAboutLocalization:SetText(
		Musician.Msg.ABOUT_LOCALIZATION_TEAM .. "\n\n" ..
		strjoin(" / ", unpack(translatorsText)) .. "\n\n" ..
		highlightUrl(Musician.Msg.ABOUT_CONTRIBUTE_TO_LOCALIZATION, Musician.LOCALIZATION_URL)
	)

	-- Instrument sources
	local sampleSources = {}
	for _, instrument in pairs(Musician.INSTRUMENTS) do
		if instrument.source and sampleSources[instrument.source] == nil then
			table.insert(sampleSources, instrument.source)
			sampleSources[instrument.source] = true
		end
	end
	MusicianAboutInstrumentSources:SetText(strjoin(" / ", unpack(sampleSources)))

	MusicianAboutLicense:SetText(Musician.Msg.ABOUT_LICENSE)

	MusicianAboutDiscord:SetText(highlightUrl(Musician.Msg.ABOUT_DISCORD, Musician.DISCORD_URL))

	MusicianAboutSupport:SetText(Musician.Msg.ABOUT_SUPPORT)
	MusicianAboutPatreon:SetText(highlightUrl(Musician.Msg.ABOUT_PATREON, Musician.PATREON_URL))
	MusicianAboutPaypal:SetText(highlightUrl(Musician.Msg.ABOUT_PAYPAL, Musician.PAYPAL_URL))

	-- Supporters
	MusicianAboutSupportersTitle:SetText(Musician.Msg.ABOUT_SUPPORTERS)
	local supporters = {}
	randomizeHighlight(supporters, Musician.LEGENDARY_SUPPORTERS, "FF8000")
	randomizeHighlight(supporters, Musician.SUPPORTERS, "FFFFFF")
	MusicianAboutSupportersList:SetText(strjoin(" / ", unpack(supporters)))

	-- Resize window to fit content
	MusicianAbout:SetHeight(MusicianAboutSupportersList:GetBottom() - 40 - MusicianAbout:GetTop())

	-- Slightly enlarge window in Chinese
	if Musician.Msg == Musician.Locale.zh then
		MusicianAbout:SetWidth(480 * 1.2)
	end

	-- Center window
	MusicianAbout:ClearAllPoints()
	MusicianAbout:SetPoint("CENTER")
end