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
-- @param [onError (function)]
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

	local maxTime = debugprofilestop() + MAX_EXECUTION_TIME
	local worker, workerData
	repeat
		local currentWorkers = Musician.Utils.DeepCopy(workers) -- Use a copy in case some workers are removed during the process
		for worker, workerData in pairs(currentWorkers) do
			if not(workerData.isRemoved) then
				if workerData.onError then
					local status, err = pcall(function()
						worker()
					end)
					if not(status) then
						workerData.onError(err)
						Musician.Worker.Remove(worker)
					end
				else
					worker()
				end
			end
		end

		-- Run workers until max execution time has been reached
	until workerCount == 0 or debugprofilestop() > maxTime
end