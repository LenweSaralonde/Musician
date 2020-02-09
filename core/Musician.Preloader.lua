--- Preloads sample files into the disk cache in background
-- @module Musician.Preloader

Musician.Preloader = LibStub("AceAddon-3.0"):NewAddon("Musician.Preloader", "AceEvent-3.0")

local MODULE_NAME = "Preloader"
Musician.AddModule(MODULE_NAME)

Musician.Preloader.preloadedSamples = {}

local DEFAULT_LOADING_TIME = 30 -- Average loading time in ms of an uncached sample from a 5400 RPM HDD

local instrumentCursor
local keyCursor
local preloaded
local frameWaitedTime
local totalLoadedSamples
local totalLoadingTime
local averageLoadingTime
local totalSamples
local preloadedSamples

--- Preloader initialization
--
function Musician.Preloader.Init()
	-- Process cursors
	instrumentCursor = 1
	keyCursor = Musician.MIN_KEY

	-- First preloading cycle is complete
	preloaded = false

	-- Waited time before a new sample preloading
	frameWaitedTime = 0

	-- Stastics on preloaded samples from disk
	totalLoadingTime = 0
	totalLoadedSamples = 0
	averageLoadingTime = DEFAULT_LOADING_TIME

	-- Statistics on preloaded samples for progression
	totalSamples = 0
	preloadedSamples = 0

	-- Count total samples
	local instrumentName, key
	local sampleIds = {}
	for key = Musician.MIN_KEY, Musician.MAX_KEY do
		for _, instrumentName in pairs(Musician.INSTRUMENTS_AVAILABLE) do
			local instrumentData = Musician.Utils.GetInstrumentData(instrumentName, key)
			local sampleId = Musician.Utils.GetSampleId(instrumentData, key)
			if sampleId and sampleIds[sampleId] == nil then
				sampleIds[sampleId] = true
				totalSamples = totalSamples + 1
			end
		end
	end
end

--- Preload next sample
--
function Musician.Preloader.PreloadNext()

	-- Suspend preloading while a song is playing after the first cycle
	if preloaded and Musician.Utils.SongIsPlaying() then
		return
	end

	local sampleIsPreloaded = false

	while not(sampleIsPreloaded) do
		local key = Musician.Preloader.GetCursorKey(keyCursor)
		local instrumentName = Musician.INSTRUMENTS_AVAILABLE[instrumentCursor]
		local instrumentData = Musician.Utils.GetInstrumentData(instrumentName, key)

		if instrumentData ~= nil then
			local sampleId = Musician.Utils.GetSampleId(instrumentData, key)

			-- Sample not preloaded
			if sampleId and not(Musician.Preloader.IsPreloaded(sampleId, true)) then
				-- Preload note samples
				local hasSample, preloadTime = Musician.Utils.PreloadNote(instrumentData.midi, key)
				if hasSample then
					-- Calculate average loading time during first preloading cycle
					if not(preloaded) then
						totalLoadingTime = totalLoadingTime + preloadTime
						totalLoadedSamples = totalLoadedSamples + 1
						averageLoadingTime = Musician.Preloader.GetAverageLoadingTime()
					end
				end
				sampleIsPreloaded = true
			end
		end

		-- Get next cursor IDs

		-- Increment instrument cursor
		if instrumentCursor < #Musician.INSTRUMENTS_AVAILABLE then
			instrumentCursor = instrumentCursor + 1
		else
			instrumentCursor = 1

			-- Increment key cursor
			if keyCursor < Musician.MAX_KEY then
				keyCursor = keyCursor + 1
			else
				-- No more note to preload
				if not(preloaded) then
					preloaded = true
					Musician.Preloader:SendMessage(Musician.Events.PreloadingProgress, Musician.Preloader.GetProgress())
					Musician.Preloader:SendMessage(Musician.Events.PreloadingComplete)
				end

				-- Start a new cycle at lower rate to maintain the samples in cache
				Musician.Preloader.preloadedSamples = {}
				preloadedSamples = 0
				keyCursor = Musician.MIN_KEY
				averageLoadingTime = DEFAULT_LOADING_TIME
			end
		end
	end
end

function Musician.Preloader.GetLoadedSamples()
	return totalLoadedSamples
end

function Musician.Preloader.GetAverageLoadingTime()
	return totalLoadingTime / totalLoadedSamples
end

--- Return frame waiting time in seconds
-- @return (number)
function Musician.Preloader.GetFrameWaitingTime()
	-- Consider using 25% of frame time for loading the sample to limit FPS drop
	return 3 * (averageLoadingTime / 1000)
end

--- Main on update function, called on each frame
-- @param elapsed (number)
function Musician.Preloader.OnUpdate(elapsed)
	frameWaitedTime = frameWaitedTime + elapsed
	if frameWaitedTime >= Musician.Preloader.GetFrameWaitingTime() then
		frameWaitedTime = 0
		Musician.Preloader.PreloadNext()
	end
end

--- Return the key to be preloaded by cursor.
--  Starts from the middle to the bounds to preload the most used keys in priority.
-- @param cursor (number) cursor key
-- @return (number) key to be preloaded
function Musician.Preloader.GetCursorKey(cursor)
	local middle = floor((Musician.MAX_KEY - Musician.MIN_KEY) / 2) + Musician.MIN_KEY
	local index = cursor - Musician.MIN_KEY

	if (index % 2) == 0 then
		return middle + floor(index / 2)
	else
		return middle - ceil(index / 2)
	end
end

--- Return the initial preloading progression
-- @return (number)
function Musician.Preloader.GetProgress()
	if preloaded then
		return 1
	end
	return preloadedSamples / totalSamples
end

--- Flag a note sample as preloaded
-- @param sampleId (string) as returned by Musician.Utils.GetSampleId()
function Musician.Preloader.AddPreloaded(sampleId)
	if not(Musician.Preloader.IsPreloaded(sampleId, true)) then
		Musician.Preloader.preloadedSamples[sampleId] = true
		preloadedSamples = preloadedSamples + 1
		if not(preloaded) then
			Musician.Preloader:SendMessage(Musician.Events.PreloadingProgress, Musician.Preloader.GetProgress())
		end
	end
end

--- Return true if the note sample has been preloaded
-- @param sampleId (string) as returned by Musician.Utils.GetSampleId()
-- @param currentCycle (boolean) for current preloading cycle only (even if the sample is already in cache)
-- @return (boolean)
function Musician.Preloader.IsPreloaded(sampleId, currentCycle)

	-- Consider the sample as preloaded if the average loading time is < 1 ms
	if not(currentCycle) and (Musician.Preloader.IsComplete() or averageLoadingTime < 1) then
		return true
	end

	return sampleId == nil or Musician.Preloader.preloadedSamples[sampleId] ~= nil
end

--- Return true if all the samples have been preloaded
-- @return (boolean)
function Musician.Preloader.IsComplete()
	return preloaded
end
