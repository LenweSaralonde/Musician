--- Animated image template
-- @module MusicianAnimatedImageTemplate

--- OnLoad
-- @param self (Frame)
function MusicianAnimatedImageTemplate_OnLoad(self)
	self.width = 1024
	self.height = 1024
	self.tileWidth = 128
	self.tileHeight = 128
	self.fps = 30
end

--- OnShow
-- @param self (Frame)
function MusicianAnimatedImageTemplate_OnShow(self)
	self.frame = 0
	self.elapsed = 0
end

--- OnUpdate
-- @param self (Frame)
-- @param elapsed (number)
function MusicianAnimatedImageTemplate_OnUpdate(self, elapsed)
	local frameW = self.tileWidth / self.width
	local frameH = self.tileHeight / self.height

	local framesX = floor(self.width / self.tileWidth)
	local framesY = floor(self.height / self.tileHeight)
	local frames = framesX * framesY

	self.elapsed = self.elapsed + elapsed
	self.frame = floor(self.fps * (self.elapsed % (frames / self.fps)))

	local row = math.floor(self.frame / framesX)
	local col = self.frame % framesX

	self.texture:SetTexCoord(col * frameW, (col + 1) * frameW, row * frameH, (row + 1) * frameH)
end
