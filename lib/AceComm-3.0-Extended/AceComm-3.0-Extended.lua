-- **AceComm-3.0-Extended** is an additional module for AceComm-3.0 that allows you to send and
-- receive add-on messages over the Battle.net chat system.
--
-- Import the AceComm-3.0-Extended module in addition to AceComm-3.0 to be able to use the Battle.net-specific functions:
-- MyModule = LibStub("AceAddon-3.0"):NewAddon("MyModule", "AceComm-3.0", "AceComm-3.0-Extended")
--
-- https://github.com/LenweSaralonde/AceComm-3.0-Extended

local CallbackHandler = LibStub("CallbackHandler-1.0")
local CTLE = assert(ChatThrottleLibExtended, "AceComm-3.0-Extended requires ChatThrottleLibExtended")

local AceComm, AceCommVersion = LibStub:GetLibrary("AceComm-3.0")

if AceCommVersion == nil or AceCommVersion < 12 then
	error("AceComm-3.0-Extended requires AceComm-3.0 v12 or higher.")
	return
end

local MAJOR, MINOR = "AceComm-3.0-Extended", 1
local AceCommExtended, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not AceCommExtended then return end

-- Lua APIs
local type, next, pairs, tostring = type, next, pairs, tostring
local strsub, strfind = string.sub, string.find
local match = string.match
local tinsert, tconcat = table.insert, table.concat
local error, assert = error, assert

-- WoW APIs
local Ambiguate = Ambiguate

-- for my sanity and yours, let's give the message type bytes some names
local MSG_MULTI_FIRST = "\001"
local MSG_MULTI_NEXT  = "\002"
local MSG_MULTI_LAST  = "\003"
local MSG_ESCAPE = "\004"

--- Register for Addon Traffic on a specified prefix
-- @param prefix A printable character (\032-\255) classification of the message (typically AddonName or AddonNameEvent), max 16 characters
-- @param method Callback to call on message reception: Function reference, or method name (string) to call on self. Defaults to "OnCommReceived"
function AceCommExtended:RegisterBNetComm(prefix, method)
	if method == nil then
		method = "OnCommReceived"
	end

	if #prefix > 16 then
		error("AceCommExtended:RegisterComm(prefix,method): prefix length is limited to 16 characters")
	end
	if C_ChatInfo then
		C_ChatInfo.RegisterAddonMessagePrefix(prefix)
	else
		RegisterAddonMessagePrefix(prefix)
	end

	return AceCommExtended._RegisterBNetComm(self, prefix, method)	-- created by CallbackHandler
end

--- Send a message over the Battle.net Addon Channel
-- @param prefix A printable character (\032-\255) classification of the message (typically AddonName or AddonNameEvent)
-- @param text Data to send, nils (\000) not allowed. Any length.
-- @param target Battle.net game account ID.
-- @param prio OPTIONAL: ChatThrottleLib priority, "BULK", "NORMAL" or "ALERT". Defaults to "NORMAL".
-- @param callbackFn OPTIONAL: callback function to be called as each chunk is sent. receives 3 args: the user supplied arg (see next), the number of bytes sent so far, and the number of bytes total to send.
-- @param callbackArg: OPTIONAL: first arg to the callback function. nil will be passed if not specified.
function AceCommExtended:SendBNetCommMessage(prefix, text, target, prio, callbackFn, callbackArg)
	local distribution = CTLE.BNET_CHAT_TYPE
	prio = prio or "NORMAL"	-- pasta's reference implementation had different prio for singlepart and multipart, but that's a very bad idea since that can easily lead to out-of-sequence delivery!
	if not( type(prefix)=="string" and
			type(text)=="string" and
			(target==nil or type(target)=="string" or type(target)=="number") and
			(prio=="BULK" or prio=="NORMAL" or prio=="ALERT")
		) then
		error('Usage: SendBNetCommMessage(addon, "prefix", "text"[, "target"[, "prio"[, callbackFn, callbackarg]]])', 2)
	end

	local textlen = #text
	local maxtextlen = CTLE.BNET_MAX_LENGTH
	local queueName = prefix..distribution..(target or "")

	local ctlCallback = nil
	if callbackFn then
		ctlCallback = function(sent)
			return callbackFn(callbackArg, sent, textlen)
		end
	end

	local forceMultipart
	if match(text, "^[\001-\009]") then -- 4.1+: see if the first character is a control character
		-- we need to escape the first character with a \004
		if textlen+1 > maxtextlen then	-- would we go over the size limit?
			forceMultipart = true	-- just make it multipart, no escape problems then
		else
			text = MSG_ESCAPE .. text
		end
	end

	if not forceMultipart and textlen <= maxtextlen then
		-- fits all in one message
		CTLE:BNSendGameData(prio, prefix, text, target, queueName, ctlCallback, textlen)
	else
		maxtextlen = maxtextlen - 1	-- 1 extra byte for part indicator in prefix(4.0)/start of message(4.1)

		-- first part
		local chunk = strsub(text, 1, maxtextlen)
		CTLE:BNSendGameData(prio, prefix, MSG_MULTI_FIRST..chunk, target, queueName, ctlCallback, maxtextlen)

		-- continuation
		local pos = 1+maxtextlen

		while pos+maxtextlen <= textlen do
			chunk = strsub(text, pos, pos+maxtextlen-1)
			CTLE:BNSendGameData(prio, prefix, MSG_MULTI_NEXT..chunk, target, queueName, ctlCallback, pos+maxtextlen-1)
			pos = pos + maxtextlen
		end

		-- final part
		chunk = strsub(text, pos)
		CTLE:BNSendGameData(prio, prefix, MSG_MULTI_LAST..chunk, target, queueName, ctlCallback, textlen)
	end
end

----------------------------------------
-- Embed CallbackHandler
----------------------------------------

if not AceCommExtended.callbacks then
	AceCommExtended.callbacks = CallbackHandler:New(AceCommExtended,
						"_RegisterBNetComm",
						"UnregisterBNetComm",
						"UnregisterAllBNetComm")
end

AceCommExtended.callbacks.OnUsed = nil
AceCommExtended.callbacks.OnUnused = nil

----------------------------------------
-- Event handler
----------------------------------------

local function OnEvent(self, event, prefix, message, distribution, sender)
	if event == "BN_CHAT_MSG_ADDON" then
		-- Temporarly hook AceComm's callbacks fire to use AceCommExtended's callbacks instead so we can just use AceComm's message receiving handler
		local AceCommCallbacksFire = AceComm.callbacks.Fire
		AceComm.callbacks.Fire = function(self, prefix, rest, distribution, sender)
			AceCommExtended.callbacks:Fire(prefix, rest, distribution, sender)
		end

		-- Call AceComm's event handler
		AceComm.frame:GetScript("OnEvent")(self, "CHAT_MSG_ADDON", prefix, message, distribution, sender)

		-- Remove hook
		AceComm.callbacks.Fire = AceCommCallbacksFire
	end
end

AceCommExtended.frame = AceCommExtended.frame or CreateFrame("Frame", "AceComm30ExtendedFrame")
AceCommExtended.frame:SetScript("OnEvent", OnEvent)
AceCommExtended.frame:UnregisterAllEvents()
AceCommExtended.frame:RegisterEvent("BN_CHAT_MSG_ADDON")

----------------------------------------
-- Library embeds
----------------------------------------

local mixins = {
	"SendBNetCommMessage",
	"UnregisterBNetComm",
	"UnregisterAllBNetComm",
	"RegisterBNetComm",
}

AceCommExtended.embeds = AceCommExtended.embeds or {}

-- Embeds AceComm-3.0 into the target object making the functions from the mixins list available on target:..
-- @param target target object to embed AceComm-3.0 in
function AceCommExtended:Embed(target)
	for k, v in pairs(mixins) do
		target[v] = self[v]
	end
	self.embeds[target] = true
	return target
end

function AceCommExtended:OnEmbedDisable(target)
	target:UnregisterAllBNetComm()
end

-- Update embeds
for target, v in pairs(AceCommExtended.embeds) do
	AceCommExtended:Embed(target)
end
