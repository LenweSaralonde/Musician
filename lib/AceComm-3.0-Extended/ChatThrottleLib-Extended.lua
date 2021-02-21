-- Extension to ChatThrottleLib to support Battle.net add-on communication
--
-- https://github.com/LenweSaralonde/AceComm-3.0-Extended

local CTLE_VERSION = 1

if ChatThrottleLib == nil or ChatThrottleLib.version < 24 then
	error("ChatThrottleLibExtended requires ChatThrottleLib v24 or higher.")
	return
end

if ChatThrottleLibExtended and ChatThrottleLibExtended.version >= CTL_VERSION then
	-- There's already a newer (or same) version loaded. Buh-bye.
	return
end

if not(ChatThrottleLibExtended) then
	ChatThrottleLibExtended = Mixin({}, ChatThrottleLib)
	ChatThrottleLibExtended.SendChatMessage = nil
	ChatThrottleLibExtended.SendAddonMessage = nil
end

ChatThrottleLibExtended.version = CTLE_VERSION

ChatThrottleLibExtended.BNET_CHAT_TYPE = 'BNET_WHISPER'
ChatThrottleLibExtended.BNET_MAX_LENGTH = 4079

local bMyTraffic = false

------------------ TWEAKABLES -----------------

-- Battle.net messages limit is 10 messages per 10 seconds
-- http://web.archive.org/web/20150104185757/http://us.battle.net/wow/en/forum/topic/11437004031
ChatThrottleLibExtended.MAX_CPS = ChatThrottleLibExtended.BNET_MAX_LENGTH
ChatThrottleLibExtended.BURST = 2 * ChatThrottleLibExtended.BNET_MAX_LENGTH

-----------------------------------------------------------------------
-- ChatThrottleLibExtended:Init

function ChatThrottleLibExtended:Init()
	if not(self.securelyHooked) then
		ChatThrottleLib.Init(self)
		self.securelyHooked = true
		-- BNSendGameData
		hooksecurefunc("BNSendGameData", function(...)
			return ChatThrottleLibExtended.Hook_BNSendGameData(...)
		end)
	end
end

-----------------------------------------------------------------------
-- ChatThrottleLibExtended.Hook_BNSendGameData

function ChatThrottleLibExtended.Hook_BNSendGameData(destination, prefix, text)
	if bMyTraffic then
		return
	end
	local self = ChatThrottleLibExtended -- Use ChatThrottleLib's own queue and stat values
	local size = tostring(text or ""):len() + tostring(prefix or ""):len()
	size = size + tostring(destination or ""):len() + self.MSG_OVERHEAD
	self.avail = self.avail - size
	self.nBypass = self.nBypass + size
end

-----------------------------------------------------------------------
-- ChatThrottleLibExtended:BNSendGameData

function ChatThrottleLibExtended:BNSendGameData(prio, prefix, text, target, queueName, callbackFn, callbackArg)
	if not self or not prio or not prefix or not text  or not self.Prio[prio] then
		error('Usage: ChatThrottleLibExtended:BNSendGameData("{BULK||NORMAL||ALERT}", "prefix", "text", "target")', 2)
	end
	if callbackFn and type(callbackFn)~="function" then
		error('ChatThrottleLibExtended:BNSendGameData(): callbackFn: expected function, got '..type(callbackFn), 2)
	end

	local nSize = text:len()

	if C_ChatInfo or RegisterAddonMessagePrefix then
		if nSize>ChatThrottleLibExtended.BNET_MAX_LENGTH then
			error("ChatThrottleLibExtended:BNSendGameData(): message length cannot exceed "..ChatThrottleLibExtended.BNET_MAX_LENGTH.." bytes", 2)
		end
	else
		nSize = nSize + prefix:len() + 1
		if nSize>ChatThrottleLibExtended.BNET_MAX_LENGTH then
			error("ChatThrottleLibExtended:BNSendGameData(): prefix + message length cannot exceed "..(ChatThrottleLibExtended.BNET_MAX_LENGTH - 1).." bytes", 2)
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
	self:Enqueue(prio, queueName or (prefix..ChatThrottleLib.BNET_CHAT_TYPE..(target or "")), msg)
end

-----------------------------------------------------------------------
-- Get the ball rolling!

ChatThrottleLibExtended:Init()
