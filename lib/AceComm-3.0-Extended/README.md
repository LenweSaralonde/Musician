AceComm-3.0-Extended
====================

**AceComm-3.0-Extended** is an additional module for [AceComm-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-comm-3-0) that allows you to send and receive add-on messages over the Battle.net chat system.

Import the **AceComm-3.0-Extended** module in addition to **AceComm-3.0** to be able to use the Battle.net-specific functions.
```lua
MyModule = LibStub("AceAddon-3.0"):NewAddon("MyModule", "AceComm-3.0", "AceComm-3.0-Extended")
```

## AceCommExtended:RegisterBNetComm(prefix, method)
Register for add-on traffic over Battle.net on a specified prefix.

### Parameters
* prefix
: A printable character (\032-\255) classification of the message (typically AddonName or AddonNameEvent), max 16 characters.
* method
: Callback to call on message reception: Function reference, or method name (string) to call on self. Defaults to "OnCommReceived". The same arguments as *AceComm:RegisterComm* are provided (prefix, message, distribution, sender): *distribution* is "WHISPER" and *sender* is the Battle.net game account ID.

## AceCommExtended:SendBNetCommMessage(prefix, text, target, prio, callbackFn, callbackArg)
Send an add-on message over Battle.net chat.

### Parameters
* prefix
: A printable character (\032-\255) classification of the message (typically AddonName or AddonNameEvent).
* text
: Data to send, nils (\000) not allowed. Any length.
* target
: Battle.net game account ID.
* prio
: OPTIONAL: ChatThrottleLib priority, "BULK", "NORMAL" or "ALERT". Defaults to "NORMAL".
* callbackFn
: OPTIONAL: callback function to be called as each chunk is sent. receives 3 args: the user supplied arg (see next), the number of bytes sent so far, and the number of bytes total to send.
* callbackArg
