-- BNetChatThrottleLib by LenweSaralonde
--
-- BNetChatThrottleLib is a fork of ChatThrottleLib to support Battle.net add-on communication.
-- It's fully independant of ChatThrottleLib and doesn't interfere with other add-ons
-- that may implement a non-standard version of ChatThrottleLib.
--

local BNCTL_VERSION = 1

local _G = _G

if _G.BNetChatThrottleLib and _G.BNetChatThrottleLib.version >= BNCTL_VERSION then
	-- There's already a newer (or same) version loaded. Buh-bye.
	return
end

if not _G.BNetChatThrottleLib then
	_G.BNetChatThrottleLib = {}
end

BNetChatThrottleLib = _G.BNetChatThrottleLib  -- in case some addon does "local BNetChatThrottleLib" above us and we're copypasted (AceComm-2, sigh)
local BNetChatThrottleLib = _G.BNetChatThrottleLib

BNetChatThrottleLib.version = BNCTL_VERSION

BNetChatThrottleLib.BNET_CHAT_TYPE = 'BNET_WHISPER'
BNetChatThrottleLib.BNET_MAX_LENGTH = 4079


------------------ TWEAKABLES -----------------

BNetChatThrottleLib.MSG_OVERHEAD = 40 -- Guesstimate overhead for sending a message; source+dest+chattype+protocolstuff
BNetChatThrottleLib.MIN_FPS = 20 -- Reduce output CPS to half (and don't burst) if FPS drops below this value

-- Battle.net messages limit is 10 messages per 10 seconds
-- http://web.archive.org/web/20150104185757/http://us.battle.net/wow/en/forum/topic/11437004031
BNetChatThrottleLib.MAX_CPS = BNetChatThrottleLib.BNET_MAX_LENGTH * .5 -- Set to 50% of the theoretical max rate
BNetChatThrottleLib.BURST = BNetChatThrottleLib.MAX_CPS -- No burst


local setmetatable = setmetatable
local table_remove = table.remove
local tostring = tostring
local GetTime = GetTime
local math_min = math.min
local math_max = math.max
local next = next
local GetFramerate = GetFramerate
local strlower = string.lower
local unpack,type,pairs,wipe = unpack,type,pairs,table.wipe
local UnitInRaid,UnitInParty = UnitInRaid,UnitInParty


-----------------------------------------------------------------------
-- Double-linked ring implementation

local Ring = {}
local RingMeta = { __index = Ring }

function Ring:New()
	local ret = {}
	setmetatable(ret, RingMeta)
	return ret
end

function Ring:Add(obj)	-- Append at the "far end" of the ring (aka just before the current position)
	if self.pos then
		obj.prev = self.pos.prev
		obj.prev.next = obj
		obj.next = self.pos
		obj.next.prev = obj
	else
		obj.next = obj
		obj.prev = obj
		self.pos = obj
	end
end

function Ring:Remove(obj)
	obj.next.prev = obj.prev
	obj.prev.next = obj.next
	if self.pos == obj then
		self.pos = obj.next
		if self.pos == obj then
			self.pos = nil
		end
	end
end


-----------------------------------------------------------------------
-- Recycling bin for pipes
-- A pipe is a plain integer-indexed queue of messages
-- Pipes normally live in Rings of pipes  (3 rings total, one per priority)

BNetChatThrottleLib.PipeBin = nil -- pre-v19, drastically different
local PipeBin = setmetatable({}, {__mode="k"})

local function DelPipe(pipe)
	PipeBin[pipe] = true
end

local function NewPipe()
	local pipe = next(PipeBin)
	if pipe then
		wipe(pipe)
		PipeBin[pipe] = nil
		return pipe
	end
	return {}
end


-----------------------------------------------------------------------
-- Recycling bin for messages

BNetChatThrottleLib.MsgBin = nil -- pre-v19, drastically different
local MsgBin = setmetatable({}, {__mode="k"})

local function DelMsg(msg)
	msg[1] = nil
	-- there's more parameters, but they're very repetetive so the string pool doesn't suffer really, and it's faster to just not delete them.
	MsgBin[msg] = true
end


-----------------------------------------------------------------------
-- BNetChatThrottleLib:Init
-- Initialize queues, set up frame for OnUpdate, etc

function BNetChatThrottleLib:Init()

	-- Set up queues
	if not self.Prio then
		self.Prio = {}
		self.Prio["ALERT"] = { ByName = {}, Ring = Ring:New(), avail = 0 }
		self.Prio["NORMAL"] = { ByName = {}, Ring = Ring:New(), avail = 0 }
		self.Prio["BULK"] = { ByName = {}, Ring = Ring:New(), avail = 0 }
	end

	-- v4: total send counters per priority
	for _, Prio in pairs(self.Prio) do
		Prio.nTotalSent = Prio.nTotalSent or 0
	end

	if not self.avail then
		self.avail = 0 -- v5
	end
	if not self.nTotalSent then
		self.nTotalSent = 0 -- v5
	end

	-- Set up a frame to get OnUpdate events
	if not self.Frame then
		self.Frame = CreateFrame("Frame")
		self.Frame:Hide()
	end
	self.Frame:SetScript("OnUpdate", self.OnUpdate)
	self.Frame:SetScript("OnEvent", self.OnEvent)	-- v11: Monitor P_E_W so we can throttle hard for a few seconds
	self.Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	self.OnUpdateDelay = 0
	self.LastAvailUpdate = GetTime()
	self.HardThrottlingBeginTime = GetTime()	-- v11: Throttle hard for a few seconds after startup

	-- Hook BNSendGameData, SendChatMessage and SendAddonMessage so we can measure unpiped traffic and avoid overloads (v7)
	-- BNSendGameData
	hooksecurefunc("BNSendGameData", BNetChatThrottleLib.Hook_BNSendGameData)
	-- SendChatMessage
	hooksecurefunc("SendChatMessage", BNetChatThrottleLib.Hook_SendChatMessage)
	-- SendAddonMessage
	if _G.C_ChatInfo then
		hooksecurefunc(_G.C_ChatInfo, "SendAddonMessage", BNetChatThrottleLib.Hook_SendAddonMessage)
	else
		hooksecurefunc("SendAddonMessage", BNetChatThrottleLib.Hook_SendAddonMessage)
	end

	self.nBypass = 0
end


-----------------------------------------------------------------------
-- ChatThrottleLib.Hook_SendChatMessage / .Hook_SendAddonMessage / .Hook_BNSendGameData

local bMyTraffic = false

function BNetChatThrottleLib.Hook_BNSendGameData(destination, prefix, text)
	if bMyTraffic then
		return
	end
	local self = BNetChatThrottleLib
	local size = tostring(text or ""):len() + tostring(prefix or ""):len();
	size = size + tostring(destination or ""):len() + self.MSG_OVERHEAD
	self.avail = self.avail - size
	self.nBypass = self.nBypass + size	-- just a statistic
end
function BNetChatThrottleLib.Hook_SendChatMessage(text, _, _, destination)
	BNetChatThrottleLib.Hook_BNSendGameData(destination, nil, text)
end
function BNetChatThrottleLib.Hook_SendAddonMessage(prefix, text, _, destination)
	BNetChatThrottleLib.Hook_BNSendGameData(destination, prefix, text)
end


-----------------------------------------------------------------------
-- BNetChatThrottleLib:UpdateAvail
-- Update self.avail with how much bandwidth is currently available

function BNetChatThrottleLib:UpdateAvail()
	local now = GetTime()
	local MAX_CPS = self.MAX_CPS;
	local newavail = MAX_CPS * (now - self.LastAvailUpdate)
	local avail = self.avail

	if now - self.HardThrottlingBeginTime < 5 then
		-- First 5 seconds after startup/zoning: VERY hard clamping to avoid irritating the server rate limiter, it seems very cranky then
		avail = math_min(avail + (newavail*0.1), MAX_CPS*0.5)
		self.bChoking = true
	elseif GetFramerate() < self.MIN_FPS then		-- GetFrameRate call takes ~0.002 secs
		avail = math_min(MAX_CPS, avail + newavail*0.5)
		self.bChoking = true		-- just a statistic
	else
		avail = math_min(self.BURST, avail + newavail)
		self.bChoking = false
	end

	avail = math_max(avail, 0-(MAX_CPS*2))	-- Can go negative when someone is eating bandwidth past the lib. but we refuse to stay silent for more than 2 seconds; if they can do it, we can.

	self.avail = avail
	self.LastAvailUpdate = now

	return avail
end


-----------------------------------------------------------------------
-- Despooling logic
-- Reminder:
-- - We have 3 Priorities, each containing a "Ring" construct ...
-- - ... made up of N "Pipe"s (1 for each destination/pipename)
-- - and each pipe contains messages

function BNetChatThrottleLib:Despool(Prio)
	local ring = Prio.Ring
	while ring.pos and Prio.avail > ring.pos[1].nSize do
		local msg = table_remove(ring.pos, 1)
		if not ring.pos[1] then  -- did we remove last msg in this pipe?
			local pipe = Prio.Ring.pos
			Prio.Ring:Remove(pipe)
			Prio.ByName[pipe.name] = nil
			DelPipe(pipe)
		else
			Prio.Ring.pos = Prio.Ring.pos.next
		end
		local didSend=false
		local lowerDest = strlower(msg[3] or "")
		if lowerDest == "raid" and not UnitInRaid("player") then
			-- do nothing
		elseif lowerDest == "party" and not UnitInParty("player") then
			-- do nothing
		else
			Prio.avail = Prio.avail - msg.nSize
			bMyTraffic = true
			msg.f(unpack(msg, 1, msg.n))
			bMyTraffic = false
			Prio.nTotalSent = Prio.nTotalSent + msg.nSize
			DelMsg(msg)
			didSend = true
		end
		-- notify caller of delivery (even if we didn't send it)
		if msg.callbackFn then
			msg.callbackFn (msg.callbackArg, didSend)
		end
		-- USER CALLBACK MAY ERROR
	end
end


function BNetChatThrottleLib.OnEvent(_,event)
	-- v11: We know that the rate limiter is touchy after login. Assume that it's touchy after zoning, too.
	local self = BNetChatThrottleLib
	if event == "PLAYER_ENTERING_WORLD" then
		self.HardThrottlingBeginTime = GetTime()	-- Throttle hard for a few seconds after zoning
		self.avail = 0
	end
end


function BNetChatThrottleLib.OnUpdate(_,delay)
	local self = BNetChatThrottleLib

	self.OnUpdateDelay = self.OnUpdateDelay + delay
	if self.OnUpdateDelay < 0.08 then
		return
	end
	self.OnUpdateDelay = 0

	self:UpdateAvail()

	if self.avail < 0  then
		return -- argh. some bastard is spewing stuff past the lib. just bail early to save cpu.
	end

	-- See how many of our priorities have queued messages (we only have 3, don't worry about the loop)
	local n = 0
	for _,Prio in pairs(self.Prio) do
		if Prio.Ring.pos or Prio.avail < 0 then
			n = n + 1
		end
	end

	-- Anything queued still?
	if n<1 then
		-- Nope. Move spillover bandwidth to global availability gauge and clear self.bQueueing
		for _, Prio in pairs(self.Prio) do
			self.avail = self.avail + Prio.avail
			Prio.avail = 0
		end
		self.bQueueing = false
		self.Frame:Hide()
		return
	end

	-- There's stuff queued. Hand out available bandwidth to priorities as needed and despool their queues
	local avail = self.avail/n
	self.avail = 0

	for _, Prio in pairs(self.Prio) do
		if Prio.Ring.pos or Prio.avail < 0 then
			Prio.avail = Prio.avail + avail
			if Prio.Ring.pos and Prio.avail > Prio.Ring.pos[1].nSize then
				self:Despool(Prio)
				-- Note: We might not get here if the user-supplied callback function errors out! Take care!
			end
		end
	end

end


-----------------------------------------------------------------------
-- Spooling logic

function BNetChatThrottleLib:Enqueue(prioname, pipename, msg)
	local Prio = self.Prio[prioname]
	local pipe = Prio.ByName[pipename]
	if not pipe then
		self.Frame:Show()
		pipe = NewPipe()
		pipe.name = pipename
		Prio.ByName[pipename] = pipe
		Prio.Ring:Add(pipe)
	end

	pipe[#pipe + 1] = msg

	self.bQueueing = true
end


-----------------------------------------------------------------------
-- BNetChatThrottleLib:BNSendGameData

function BNetChatThrottleLib:BNSendGameData(prio, prefix, text, target, queueName, callbackFn, callbackArg)
	if not self or not prio or not prefix or not text  or not self.Prio[prio] then
		error('Usage: BNetChatThrottleLib:BNSendGameData("{BULK||NORMAL||ALERT}", "prefix", "text", "target")', 2)
	end
	if callbackFn and type(callbackFn)~="function" then
		error('BNetChatThrottleLib:BNSendGameData(): callbackFn: expected function, got '..type(callbackFn), 2)
	end

	local nSize = text:len()

	if C_ChatInfo or RegisterAddonMessagePrefix then
		if nSize>BNetChatThrottleLib.BNET_MAX_LENGTH then
			error("BNetChatThrottleLib:BNSendGameData(): message length cannot exceed "..BNetChatThrottleLib.BNET_MAX_LENGTH.." bytes", 2)
		end
	else
		nSize = nSize + prefix:len() + 1
		if nSize>BNetChatThrottleLib.BNET_MAX_LENGTH then
			error("BNetChatThrottleLib:BNSendGameData(): prefix + message length cannot exceed "..(BNetChatThrottleLib.BNET_MAX_LENGTH - 1).." bytes", 2)
		end
	end

	nSize = nSize + self.MSG_OVERHEAD

	-- Check if there's room in the global available bandwidth gauge to send directly
	if not self.bQueueing and nSize < self:UpdateAvail() then
		self.avail = self.avail - nSize
		bMyTraffic = true
		_G.BNSendGameData(target, prefix, text)
		bMyTraffic = false
		self.Prio[prio].nTotalSent = self.Prio[prio].nTotalSent + nSize
		if callbackFn then
			callbackFn (callbackArg, true)
		end
		-- USER CALLBACK MAY ERROR
		return
	end

	-- Message needs to be queued
	local msg = {}
	msg.f = _G.BNSendGameData
	msg[1] = target
	msg[2] = prefix
	msg[3] = text
	msg.n = 3
	msg.nSize = nSize
	msg.callbackFn = callbackFn
	msg.callbackArg = callbackArg
	self:Enqueue(prio, queueName or (prefix..BNetChatThrottleLib.BNET_CHAT_TYPE..(target or "")), msg)
end


-----------------------------------------------------------------------
-- Get the ball rolling!

BNetChatThrottleLib:Init()
