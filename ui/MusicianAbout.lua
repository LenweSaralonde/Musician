--- About window
-- @module Musician.About

Musician.About = LibStub("AceAddon-3.0"):NewAddon("Musician.About")

local MODULE_NAME = "MusicianAbout"
Musician.AddModule(MODULE_NAME)

local function highlightUrl(text, url)
	return string.gsub(text, "{url}", Musician.Utils.Highlight(url, "00FFFF"))
end

local function randomizeHighlight(coloredList, list, color)
	list = Musician.Utils.DeepCopy(list)
	while #list > 0 do
		table.insert(coloredList, Musician.Utils.Highlight(table.remove(list, random(1, #list)), color))
	end
end

--- Init
--
Musician.About.Init = function()
	MusicianAbout:SetClampedToScreen(true)
	MusicianAbout:SetScript("OnShow", Musician.About.OnShow)
end

Musician.About.OnShow = function()
	MusicianAboutTitle:SetText(Musician.Msg.ABOUT_TITLE)

	local versionStr = string.gsub(Musician.Msg.ABOUT_VERSION, "{version}", Musician.Utils.GetVersionText())
	MusicianAboutVersion:SetText(versionStr)

	MusicianAboutAuthor:SetText(highlightUrl(Musician.Msg.ABOUT_AUTHOR, Musician.URL))

	local extra = 1
	local authorExtra = {}
	while Musician.Msg['ABOUT_AUTHOR_EXTRA' .. extra] ~= nil do
		table.insert(authorExtra, Musician.Msg['ABOUT_AUTHOR_EXTRA' .. extra])
		extra = extra + 1
	end
	MusicianAboutAuthorExtra:SetText(strjoin("\n", unpack(authorExtra)))

	MusicianAboutLicense:SetText(Musician.Msg.ABOUT_LICENSE)

	MusicianAboutDiscord:SetText(highlightUrl(Musician.Msg.ABOUT_DISCORD, Musician.DISCORD_URL))

	MusicianAboutSupport:SetText(Musician.Msg.ABOUT_SUPPORT)
	MusicianAboutPatreon:SetText(highlightUrl(Musician.Msg.ABOUT_PATREON, Musician.PATREON_URL))
	MusicianAboutPaypal:SetText(highlightUrl(Musician.Msg.ABOUT_PAYPAL, Musician.PAYPAL_URL))

	MusicianAboutSupportersTitle:SetText(Musician.Msg.ABOUT_SUPPORTERS)

	local supporters = { }
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