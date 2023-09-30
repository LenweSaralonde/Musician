--- Loading screen mixin
-- @module MusicianLoadingScreenMixin

MusicianLoadingScreenMixin = {}

--- OnShow
--
function MusicianLoadingScreenMixin:OnShow()
	self:SetParent(WorldFrame)
	self:SetAllPoints(true)
	local imageRatio = 16 / 9
	local minRatio = 1.6 -- For 16:9 background image
	local screenWidth, screenHeight = WorldFrame:GetSize()
	local screenRatio = screenWidth / screenHeight

	local imageScale = 1
	local viewportHeight = screenHeight
	local viewportWidth = screenHeight * min(imageRatio, screenRatio)

	if screenRatio >= imageRatio then
		self.content:SetSize(screenHeight * imageRatio, screenHeight)
	else
		imageScale = screenRatio / minRatio
		viewportHeight = screenHeight * imageScale
	end

	self.content:SetSize(screenHeight * imageRatio * imageScale, viewportHeight)

	local contentScale = screenHeight / 1080
	local borderWidth = .6 * viewportWidth
	local borderHeight = 64 * .8 * 1080 / 1024 * contentScale * imageScale

	-- Set the loading bar to 4/3 width to match the WoW Classic loading screen skin
	if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE then
		borderWidth = borderWidth * (4 / 3) / imageRatio
	end

	-- Setup progress bar
	self.content.background:SetSize(borderWidth, borderHeight)
	self.content.background:ClearAllPoints()
	self.content.background:SetPoint("BOTTOM", 0, 54 * contentScale * imageScale)

	self.content.border:SetSize(borderWidth, borderHeight)
	self.content.border:ClearAllPoints()
	self.content.border:SetPoint("BOTTOM", 0, 54 * contentScale * imageScale)

	self.content.fill.fullWidth = borderWidth * (1024 - 64) / 1024
	self.content.fill:SetSize(1, borderHeight * (64 - 32) / 64)
	self.content.fill:ClearAllPoints()
	self.content.fill:SetPoint("LEFT", self.content.border, "LEFT", borderWidth * 32 / 1024, 0)

	-- Setup text
	self.content.text:SetSize(viewportWidth * .38, borderHeight)
	self.content.text:ClearAllPoints()
	self.content.text:SetPoint("BOTTOM", self.content.border, "TOP", 0, -3)
	self.content.text:SetText(Musician.Msg.LOADING_SCREEN_MESSAGE)
	self.content.text:SetTextScale(imageScale)

	-- Setup abort quick preloading button
	self.close:SetPoint("CENTER", viewportWidth / 2 - 20, viewportHeight / 2 - 20)
	self.close.tooltip = CreateFrame("GameTooltip", "LoadingScreenTooltip", nil, "SharedTooltipTemplate")
	self.close:HookScript("OnClick", Musician.Preloader.AbortQuickPreloading)
	self.close:HookScript("OnEnter", function()
		self.close.tooltip:SetOwner(self.close, "ANCHOR_NONE")
		self.close.tooltip:SetPoint("TOPRIGHT", self.close, "BOTTOMRIGHT")
		GameTooltip_SetTitle(self.close.tooltip, Musician.Msg.LOADING_SCREEN_CLOSE_TOOLTIP)
		self.close.tooltip:Show()
	end)
	self.close:HookScript("OnLeave", function()
		self.close.tooltip:Hide()
	end)

	-- Hide the main UI during the process
	UIParent:SetShown(false)
end

--- OnHide
--
function MusicianLoadingScreenMixin:OnHide()
	-- Show UI when complete
	UIParent:SetShown(true)
	self.content.image:SetTexture(nil) -- Unload image texture
end

--- Suppress any keyboard input
--
function MusicianLoadingScreenMixin:SuppressKeyboardInput()
	Musician.Utils.SetPropagateKeyboardInput(self, false)
end

--- Set progression
-- @param progression (number) 0-1
function MusicianLoadingScreenMixin:SetProgression(progression)
	self.content.fill:SetWidth(self.content.fill.fullWidth * progression)
end