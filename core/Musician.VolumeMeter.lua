--- Simulate a volume meter for visual feedback
-- @module Musician.VolumeMeter

Musician.VolumeMeter = {}

local MODULE_NAME = "VolumeMeter"
Musician.AddModule(MODULE_NAME)

Musician.VolumeMeter.__index = Musician.VolumeMeter

--- Volume meter
-- @type Musician.VolumeMeter
function Musician.VolumeMeter.create()
	local self = {}
	setmetatable(self, Musician.VolumeMeter)

	-- @field level (number) Current level
	self.level = 0

	-- @field time (number) Current time, from noteOn
	self.time = 0

	-- @field cursor (number) Cursor envelope position
	self.cursor = nil

	-- @field envelope (table) Envelope points (time, level)
	self.envelope = {}

	-- @field entropy (number) Vibration entropy
	self.entropy = 0

	-- @field gain (number) Overall gain to be applied to the level
	self.gain = 1

	return self
end

--- Reset
--
function Musician.VolumeMeter:Reset()
	self.level = 0
	self.time = 0
	self.cursor = nil
	self.envelope = {}
	self.entropy = 0
end

--- Note on
-- @param instrument (table) instrument data from Musician.INSTRUMENTS
-- @param[opt] key (int) MIDI key number
function Musician.VolumeMeter:NoteOn(instrument, key)
	if instrument == nil then return end

	local instrumentDecay
	if instrument.decayByKey ~= nil and key ~= nil then
		instrumentDecay = instrument.decayByKey[key] or instrument.decay
	else
		instrumentDecay = instrument.decay
	end

	if instrument.isPlucked or instrument.isPercussion then
		local decay

		-- Parameters for percussions
		if instrument.midi >= 128 then
			decay = 1
			self.entropy = 0
		else
			decay = 5
			self.entropy = .1
		end

		self.envelope = {
			{ 0, 1 },
			{ .15, .666 },
			{ decay, 0 },
			{ decay + instrumentDecay / 1000, 0 },
		}
	else
		local maxDuration = (instrument.loop and Musician.MAX_LONG_NOTE_DURATION or Musician.MAX_NOTE_DURATION) - .5
		self.envelope = {
			{ 0, self.level / 3 },
			{ .075, 1 },
			{ maxDuration, .75 },
			{ maxDuration + instrumentDecay / 1000, 0 },
		}
		self.entropy = .2
	end

	self.cursor = 1
	self.time = 0
end

--- Note off
--
function Musician.VolumeMeter:NoteOff()
	if self.cursor ~= nil and self.cursor < 3 then
		local decay = self.envelope[4][1] - self.envelope[3][1]
		self.envelope[3][1] = self.time
		self.envelope[3][2] = self.level
		self.envelope[4][1] = self.time + decay
		self.cursor = 3
	end
end

--- Get current level
-- @return level (number)
function Musician.VolumeMeter:GetLevel()
	if self.cursor == nil then
		return 0
	end

	local time1 = self.envelope[self.cursor][1]
	local time2 = self.envelope[self.cursor + 1][1]
	local level1 = self.envelope[self.cursor][2]
	local level2 = self.envelope[self.cursor + 1][2]

	local sectionProgression = (self.time - time1) / (time2 - time1)
	self.level = sectionProgression * (level2 - level1) + level1

	return self.gain * (self.level - random() * self.entropy * self.level * min(1, self.time) / 1)
end

--- Add elapsed seconds after previous frame
-- @param elapsed (number)
function Musician.VolumeMeter:AddElapsed(elapsed)
	if self.cursor == nil then
		return
	end

	while self.time + elapsed >= self.envelope[self.cursor + 1][1] do
		self.cursor = self.cursor + 1
		if self.cursor >= #self.envelope then
			self.cursor = nil
			return
		end
	end

	self.time = self.time + elapsed
end
