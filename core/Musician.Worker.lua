--- Worker manager
-- @module Musician.Worker

Musician.Worker = LibStub("AceAddon-3.0"):NewAddon("Musician.Worker")

local MODULE_NAME = "Worker"
Musician.AddModule(MODULE_NAME)

local MAX_EXECUTION_TIME = 1000 / 60 / 4 -- ms

local workers = {}
local workerCount = 0

--- Set worker function
-- @param worker (function)
-- @param[opt] onError (function)
function Musician.Worker.Set(worker, onError)
	if workers[worker] == nil then
		workerCount = workerCount + 1
	end
	workers[worker] = { onError = onError }
end

--- Remove worker function
-- @param worker (function)
function Musician.Worker.Remove(worker)
	if workers[worker] == nil then return end
	workerCount = workerCount - 1
	workers[worker] = nil
end

--- Run workers on each frame
-- @param elapsed (number)
function Musician.Worker.OnUpdate(elapsed)
	-- No worker to run
	if workerCount == 0 then return end

	local startTime = debugprofilestop()
	local maxTime = startTime + MAX_EXECUTION_TIME
	local cycles = 0
	local now
	repeat
		Musician.Utils.ForEach(workers, function(workerData, worker)
			if workerData.onError then
				local status, err = pcall(function()
					worker()
				end)
				if not status then
					workerData.onError(err)
					Musician.Worker.Remove(worker)
				end
			else
				worker()
			end
		end)
		cycles = cycles + 1
		now = debugprofilestop()

		-- Run workers until max execution time has been reached
	until workerCount == 0 or now > maxTime

	Musician.Utils.Debug(MODULE_NAME, "Workers:", workerCount, "Time:", now - startTime, "Overage:", now - maxTime,
		"Cycles:", cycles, "FPS:", elapsed ~= 0 and floor(1 / elapsed) or 0)
end