Musician.KeyboardUtils = LibStub("AceAddon-3.0"):NewAddon("Musician.KeyboardUtils")

local keyValues -- Reverse mapping table (physical key => key value)

--- Init
--
function Musician.KeyboardUtils.Init()
	if Musician_Settings.keyboardMapping == nil then
		Musician_Settings.keyboardMapping = {}
		Musician_Settings.keyboardIsConfigured = false
	end
	Musician_Settings.keyboardMapping = Musician.Utils.DeepMerge(Musician.KeyboardUtils.GetEmptyMapping(), Musician_Settings.keyboardMapping)
	keyValues = Musician.KeyboardUtils.GetReverseMapping()
end

--- Return a brand new empty mapping
-- @return (table) key value => physical key
function Musician.KeyboardUtils.GetEmptyMapping()
	return Musician.Utils.DeepCopy(Musician.KEYBOARD_FIXED_MAPPING)
end

--- Return the current keyboard mapping
-- @return (table) key value => physical key
function Musician.KeyboardUtils.GetMapping()
	return Musician.Utils.DeepCopy(Musician_Settings.keyboardMapping)
end

--- Return the current reverse mapping
-- @return (table) physical key => key value
function Musician.KeyboardUtils.GetReverseMapping()
	return Musician.Utils.FlipTable(Musician.KeyboardUtils.GetMapping())
end

--- Set the keyboard mapping
-- @param mapping (table) key value => physical key
function Musician.KeyboardUtils.SetMapping(mapping)
	Musician_Settings.keyboardMapping = Musician.Utils.DeepMerge(Musician.KeyboardUtils.GetEmptyMapping(), mapping)
	keyValues = Musician.KeyboardUtils.GetReverseMapping()
	Musician_Settings.keyboardIsConfigured = true
end

--- Return the physical key mapped to the actual key value.
-- @param keyValue (string) key value
-- @return (string) physical key
function Musician.KeyboardUtils.GetKey(keyValue)
	if Musician_Settings.keyboardMapping[keyValue] then
		return Musician_Settings.keyboardMapping[keyValue]
	end
	return nil
end

--- Return the actual key value mapped to the physical key.
-- @param key (string) physical key
-- @return (string) key value
function Musician.KeyboardUtils.GetKeyValue(key)
	if keyValues[key] then
		return keyValues[key]
	end
	return nil
end

--- Return the localized name of the physical key, base on the current mapping
-- @param key (string) physical key
-- @return (string)
function Musician.KeyboardUtils.GetKeyName(key)
	if Musician.Msg.FIXED_KEY_NAMES[key] then
		return Musician.Msg.FIXED_KEY_NAMES[key]
	end

	if Musician.KeyboardUtils.GetKeyValue(key) ~= nil then
		return GetBindingText(Musician.KeyboardUtils.GetKeyValue(key), "KEY_")
	end

	return ""
end

--- Return the localized name of the key value
-- @param keyValue (string) key value
-- @return (string)
function Musician.KeyboardUtils.GetKeyValueName(keyValue)
	if Musician.KEYBOARD_FIXED_MAPPING[keyValue] then
		return Musician.Msg.FIXED_KEY_NAMES[Musician.KEYBOARD_FIXED_MAPPING[keyValue]]
	end

	return GetBindingText(keyValue, "KEY_")
end
