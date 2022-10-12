--- Preloads sample files into the OS page cache
-- @module Musician.Preloader

Musician.Preloader = LibStub("AceAddon-3.0"):NewAddon("Musician.Preloader", "AceEvent-3.0")

local MODULE_NAME = "Preloader"
Musician.AddModule(MODULE_NAME)

Musician.Preloader.preloadedSamples = {}

local SSD_AVERAGE_LOADING_TIME = 10 -- Average loading time in ms of a sample from a SATA SSD
local HDD_AVERAGE_LOADING_TIME = 30 -- Average loading time in ms of a sample from a 5400 RPM USB HDD
local FIRST_QUICK_PRELOADING_PERIOD = 1000 -- Max duration in ms of the first quick preloading iteration, during Blizzard's loading screen
local QUICK_PRELOADING_PERIOD = 250 -- Max duration in ms of the quick preloading iterations, during Musician's custom loading screen
local SAMPLE_CACHE_KEEPALIVE_PERIOD = 10 -- Period in ms after an already preloaded sample is preloaded again to maintain it in page cache

local instrumentCursor
local keyCursor
local preloaded
local frameWaitedTime
local totalLoadedSamples
local totalLoadingTime
local averageLoadingTime
local totalSamples
local preloadedSamples
local quickPreloading = true
local quickPreloadingIsAborted = false
local quickPreloadingIterations = 0
local quickPreloadingFirstLoadedSamplesCount = 0

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
	averageLoadingTime = HDD_AVERAGE_LOADING_TIME -- Consider the worst case scenario during initialization

	-- Statistics on preloaded samples for progression
	totalSamples = 0
	preloadedSamples = 0

	-- Count total samples
	local sampleIds = {}
	for key = Musician.MIN_KEY, Musician.MAX_KEY do
		for _, instrumentName in pairs(Musician.INSTRUMENTS_AVAILABLE) do
			local instrumentData = Musician.Sampler.GetInstrumentData(instrumentName, key)
			local sampleId = Musician.Sampler.GetSampleId(instrumentData, key)
			if sampleId and sampleIds[sampleId] == nil then
				sampleIds[sampleId] = true
				totalSamples = totalSamples + 1
			end
		end
	end
	Musician.Utils.Debug(MODULE_NAME, totalSamples .. " samples to preload")

	-- Initiate quick preloading
	Musician.Preloader.QuickPreload()
end

--- Attempt to preload all samples at startup during the loading screen.
--
function Musician.Preloader.QuickPreload()
	local maxPreloadingTime = QUICK_PRELOADING_PERIOD

	-- Initiating first iteration
	if quickPreloadingIterations == 0 then
		Musician.Utils.Debug(MODULE_NAME, "quick preloading started.")
		maxPreloadingTime = FIRST_QUICK_PRELOADING_PERIOD
	end

	local startTime = debugprofilestop()
	while not preloaded do
		Musician.Preloader.PreloadNext()
		local quickPreloadingTime = debugprofilestop() - startTime
		-- The iteration didn't end in time
		if quickPreloadingTime > maxPreloadingTime then
			-- Don't go any further if the process was aborted
			if quickPreloadingIsAborted or not Musician_Settings.enableQuickPreloading then
				quickPreloading = false
				Musician.Utils.Debug(MODULE_NAME,
					quickPreloadingIsAborted and "quick preloading was aborted!" or "quick preloading is disabled.")
				Musician.Preloader:SendMessage(Musician.Events.QuickPreloadingComplete)
				return
			end

			-- Show the custom loading screen if was the first iteration
			if quickPreloadingIterations == 0 then
				-- Remove the already loaded samples count so the progress bar starts from 0
				quickPreloadingFirstLoadedSamplesCount = preloadedSamples

				-- Show the loading screen
				MusicianLoadingScreen:Show()

				-- Show the abort button if loading from an HDD to allow loading in background because it can take a while.
				if Musician.Preloader.GetAverageLoadingTime() >= SSD_AVERAGE_LOADING_TIME then
					MusicianLoadingScreen.close:Show()
				end
			end

			-- Refresh progression on loading screen and try again on next frame
			local progression = (preloadedSamples - quickPreloadingFirstLoadedSamplesCount) /
				(totalSamples - quickPreloadingFirstLoadedSamplesCount)
			MusicianLoadingScreen:SetProgression(progression)
			quickPreloadingIterations = quickPreloadingIterations + 1
			C_Timer.After(0, Musician.Preloader.QuickPreload)
			return
		end
	end

	-- Hide the loading screen
	if quickPreloadingIterations > 0 then
		MusicianLoadingScreen:SetProgression(1)
		C_Timer.After(maxPreloadingTime / 1000 / 2, function()
			MusicianLoadingScreen:Hide()
		end)
	end

	-- Quick preloading is complete
	quickPreloading = false
	Musician.Utils.Debug(MODULE_NAME, "quick preloading complete!")
	Musician.Preloader:SendMessage(Musician.Events.QuickPreloadingComplete)

	-- Measured total preloading time: ~12s from SSD, ~0.2s from RAM
	-- Average time per sample:
	-- ~30 ms from USB 5400 RPM HDD
	-- ~6ms from SATA SSD
	-- ~3ms from PCIe v4 SSD
end

--- Preload next sample
--
function Musician.Preloader.PreloadNext()

	-- Suspend preloading while a song is playing after the first cycle
	if preloaded and Musician.Utils.SongIsPlaying() then
		return
	end

	local sampleIsPreloaded = false

	while not sampleIsPreloaded do
		local key = Musician.Preloader.GetCursorKey(keyCursor)
		local instrumentName = Musician.INSTRUMENTS_AVAILABLE[instrumentCursor]
		local instrumentData = Musician.Sampler.GetInstrumentData(instrumentName, key)

		if instrumentData ~= nil then
			local sampleId = Musician.Sampler.GetSampleId(instrumentData, key)

			-- Sample not preloaded
			if sampleId and not Musician.Preloader.IsPreloaded(sampleId, true) then
				-- Preload note samples
				local hasSample, preloadTime = Musician.Preloader.PreloadNote(instrumentData.midi, key)
				if hasSample then
					-- Calculate average loading time during first preloading cycle
					if not preloaded then
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
				if not preloaded then
					Musician.Utils.Debug(MODULE_NAME,
						"preloading complete in " .. floor(totalLoadingTime) .. " ms (average " .. floor(averageLoadingTime) .. " ms).")
					preloaded = true
					Musician.Preloader:SendMessage(Musician.Events.PreloadingProgress, Musician.Preloader.GetProgress())
					Musician.Preloader:SendMessage(Musician.Events.PreloadingComplete)
				end

				-- Start a new cycle at lower rate to maintain the samples in cache
				wipe(Musician.Preloader.preloadedSamples)
				preloadedSamples = 0
				keyCursor = Musician.MIN_KEY
				averageLoadingTime = SAMPLE_CACHE_KEEPALIVE_PERIOD
			end
		end
	end
end

--- Preload note
-- @param instrument (int)
-- @param key (int)
-- @return hasSample (boolean)
-- @return preloadTime (number) in seconds
function Musician.Preloader.PreloadNote(instrument, key)
	local startTime = debugprofilestop()
	local count = 0
	local hasSample = false

	local soundFile, instrumentData, soundFiles = Musician.Sampler.GetSoundFile(instrument, key)
	local sampleId = Musician.Sampler.GetSampleId(instrumentData, key)

	if soundFiles ~= nil then
		-- Multiple files
		for _, soundFileItem in pairs(soundFiles) do
			local play, handle = PlaySoundFile(soundFileItem, 'Master')
			if play then
				hasSample = true
				count = count + 1
				StopSound(handle, 0)
			else
				Musician.Utils.Debug(MODULE_NAME, "Sample file not found for", instrumentData.name, key, soundFileItem)
			end
		end

	elseif soundFile ~= nil then
		-- Single file
		local play, handle = PlaySoundFile(soundFile, 'Master')
		if play then
			hasSample = true
			count = count + 1
			StopSound(handle, 0)
		else
			Musician.Utils.Debug(MODULE_NAME, "Sample file not found for", instrumentData.name, key, soundFile)
		end

	else
		-- No file
		Musician.Utils.Debug(MODULE_NAME, "No sample file for", instrumentData.name, key)
	end

	Musician.Preloader.AddPreloaded(sampleId)

	local preloadTime = 0
	if count > 0 then
		preloadTime = (debugprofilestop() - startTime) / count
	end

	return hasSample, preloadTime
end

function Musician.Preloader.GetLoadedSamples()
	return totalLoadedSamples
end

function Musician.Preloader.GetAverageLoadingTime()
	if totalLoadedSamples == 0 then return 0 end
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
	-- Quick preloading in progress
	if quickPreloading and not preloaded then
		return
	end

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
	if preloaded then return 1 end
	if totalSamples == 0 then return 0 end
	return preloadedSamples / totalSamples
end

--- Flag a note sample as preloaded
-- @param sampleId (string) as returned by Musician.Sampler.GetSampleId()
function Musician.Preloader.AddPreloaded(sampleId)
	if not Musician.Preloader.IsPreloaded(sampleId, true) then
		Musician.Preloader.preloadedSamples[sampleId] = true
		preloadedSamples = preloadedSamples + 1
		if not preloaded then
			Musician.Preloader:SendMessage(Musician.Events.PreloadingProgress, Musician.Preloader.GetProgress())
		end
	end
end

--- Return true if the note sample has been preloaded
-- @param sampleId (string) as returned by Musician.Sampler.GetSampleId()
-- @param currentCycle (boolean) for current preloading cycle only (even if the sample is already in cache)
-- @return (boolean)
function Musician.Preloader.IsPreloaded(sampleId, currentCycle)

	-- Consider the sample as preloaded if the average loading time is < 1 ms
	if not currentCycle and (Musician.Preloader.IsComplete() or averageLoadingTime < 1) then
		return true
	end

	return sampleId == nil or Musician.Preloader.preloadedSamples[sampleId] ~= nil
end

--- Return true if all the samples have been preloaded
-- @return (boolean)
function Musician.Preloader.IsComplete()
	return preloaded
end

--- Return true if the quick preloading is complete or was aborted
-- @return (boolean)
function Musician.Preloader.QuickPreloadingIsComplete()
	return not quickPreloading
end

--- Abort quick preloading
--
function Musician.Preloader.AbortQuickPreloading()
	quickPreloadingIsAborted = true
end