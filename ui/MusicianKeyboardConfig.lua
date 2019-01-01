Musician.KeyboardConfig = LibStub("AceAddon-3.0"):NewAddon("Musician.KeyboardConfig", "AceEvent-3.0")

local KEY = Musician.KEYBOARD_KEY

KEY_SIZE = 50

local ALLOWED_DUPLICATES = {
	[KEY.IntlYen] = "BACKSPACE",
	[KEY.Backslash1] = "ENTER",
	[KEY.Backslash2] = "ENTER",
	[KEY.IntlBackslash] = "LSHIFT",
	[KEY.IntlRo] = "RSHIFT",
}

local selectedKeyButton = nil
local keyButtons = {}
local currentMapping
local keysTodo
local keysDone

--- Return the binding button for the given physical key.
-- @param key (string)
-- @return (Button)
local getKeyButton = function(key)
	return _G["MusicianKeyboardConfigKeyboard" .. key .. "Button"]
end

--- Create the keyboard UI.
--
local function createKeyboard()

	-- Set labels
	MusicianKeyboardConfigTitle:SetText(Musician.Msg.CONFIGURE_KEYBOARD)
	MusicianKeyboardConfigHint:SetText(Musician.Msg.CONFIGURE_KEYBOARD_HINT)
	MusicianKeyboardConfigStartOverButton:SetText(Musician.Msg.CONFIGURE_KEYBOARD_START_OVER)
	MusicianKeyboardConfigSaveButton:SetText(Musician.Msg.CONFIGURE_KEYBOARD_SAVE)

	-- Size container
	MusicianKeyboardConfigKeyboard:SetHeight(5 * KEY_SIZE)
	MusicianKeyboardConfigKeyboard:SetWidth(15 * KEY_SIZE)

	-- Create keys
	local row, col, rowKeys, key
	for row, rowKeys in pairs(Musician.KEYBOARD) do
		local x = 0
		for col, key in pairs(rowKeys) do
			local size = Musician.KEYBOARD_KEY_SIZE[row][col]
			local button = CreateFrame("Button", "$parent" .. key .. "Button", MusicianKeyboardConfigKeyboard, "MusicianKeyTemplate")
			local keyHeight = KEY_SIZE
			local keyWidth = size * KEY_SIZE

			button:SetWidth(keyWidth)
			button:SetHeight(keyHeight)
			button:SetPoint("TOPLEFT", MusicianKeyboardConfigKeyboard, "TOPLEFT", x, - (row - 1) * KEY_SIZE)

			table.insert(keyButtons, button)

			button.key = key
			button.row = row
			button.col = col
			button.index = #keyButtons

			x = x + keyWidth
		end
	end

	-- Disable keys with fixed mapping
	for _, key in pairs(Musician.KEYBOARD_FIXED_MAPPING) do
		getKeyButton(key):Disable()
	end
end

--- Initialize keyboard configurator.
--
Musician.KeyboardConfig.Init = function()
	createKeyboard()

	-- Bind scripts
	MusicianKeyboardConfig:SetScript("OnKeyDown", Musician.KeyboardConfig.Button_OnKeyDown)
	MusicianKeyboardConfig:SetScript("OnShow", Musician.KeyboardConfig.OnShow)
	MusicianKeyboardConfig:SetScript("OnHide", Musician.KeyboardConfig.OnHide)
end

--- OnShow
--
Musician.KeyboardConfig.OnShow = function(self)
	PlaySound(SOUNDKIT.IG_QUEST_LIST_OPEN)
	Musician.KeyboardConfig.UnselectKeyBinding()
	Musician.KeyboardConfig.Reset()
	if not(Musician.KeyboardConfig.IsComplete()) then
		Musician.KeyboardConfig.SelectKeyBinding(KEY.Backquote)
	end
end

--- OnHide
--
Musician.KeyboardConfig.OnHide = function(self)
	PlaySound(SOUNDKIT.IG_QUEST_LIST_CLOSE)
end

--- Reset configurator with actually saved values.
--
Musician.KeyboardConfig.Reset = function()
	local key
	keysTodo = 0
	keysDone = 0
	for _, key in pairs(Musician.KEYBOARD_KEY) do
		local keyValue = Musician.KeyboardUtils.GetKeyValue(key)
		local keyName = Musician.KeyboardUtils.GetKeyValueName(keyValue)
		if keyName == "" then
			keyName = Musician.KeyboardUtils.GetKeyName(key)
		end

		getKeyButton(key):SetText(keyName)
		getKeyButton(key).keyValue = keyValue

		if Musician.Msg.FIXED_KEY_NAMES[key] == nil and ALLOWED_DUPLICATES[key] == nil then
			keysTodo = keysTodo + 1
			if getKeyButton(key).keyValue ~= nil then
				keysDone = keysDone + 1
			end
		end
	end

	currentMapping = Musician.KeyboardUtils.GetMapping()
	Musician.KeyboardConfig.UpdateCompletion()
end

--- Clear keyboard configuration and start over.
--
Musician.KeyboardConfig.Clear = function()
	local key
	keysTodo = 0
	keysDone = 0
	for _, key in pairs(Musician.KEYBOARD_KEY) do
		if Musician.Msg.FIXED_KEY_NAMES[key] == nil then
			getKeyButton(key):SetText("")
			getKeyButton(key).keyValue = nil
			if ALLOWED_DUPLICATES[key] == nil then
				keysTodo = keysTodo + 1
			end
		end
	end

	currentMapping = Musician.KeyboardUtils.GetEmptyMapping()
	Musician.KeyboardConfig.UpdateCompletion()
	Musician.KeyboardConfig.SelectKeyBinding(KEY.Backquote)
end

--- Save configuration and close.
--
Musician.KeyboardConfig.Save = function()
	Musician.KeyboardUtils.SetMapping(currentMapping)
	MusicianKeyboardConfig:Hide()
end

--- Cancel changes and close.
--
Musician.KeyboardConfig.Cancel = function()
	MusicianKeyboardConfig:Hide()
end

--- Return true if configuration is complete.
--
Musician.KeyboardConfig.IsComplete = function()
	return keysDone == keysTodo
end

--- Update UI accordingly to configuration completion.
-- Lock save button if configuration is incomplete.
Musician.KeyboardConfig.UpdateCompletion = function()
	Musician.KeyboardConfig.UpdateHint()
	if Musician.KeyboardConfig.IsComplete() then
		MusicianKeyboardConfigSaveButton:Enable()
	else
		MusicianKeyboardConfigSaveButton:Disable()
	end
end

--- OnKeyDown
--
Musician.KeyboardConfig.Button_OnKeyDown = function(self, keyValue, arg)
	if selectedKeyButton then
		if keyValue == "ESCAPE" then
			Musician.KeyboardConfig.UnselectKeyBinding()
		else
			local mergedKey = Musician.KEYBOARD_MERGEABLE_KEYS[selectedKeyButton.key]
			local fixedBindingKey = Musician.KEYBOARD_FIXED_MAPPING[keyValue]
			local isAllowedBinding = (strlenutf8(keyValue) == 1 or fixedBindingKey ~= nil and fixedBindingKey == mergedKey)

			if isAllowedBinding then

				-- This key value is already mapped to another physical key: clear text (except if it's a key with fixed binding)
				if currentMapping[keyValue] ~= nil and (fixedBindingKey == nil or fixedBindingKey ~= currentMapping[keyValue]) then
					getKeyButton(currentMapping[keyValue]):SetText("")
					getKeyButton(currentMapping[keyValue]).keyValue = nil
					if ALLOWED_DUPLICATES[currentMapping[keyValue]] == nil then
						keysDone = keysDone - 1
					end
				end

				-- The current physical key already had a key value: remove it
				if selectedKeyButton.keyValue ~= nil then
					if Musician.KEYBOARD_FIXED_MAPPING[selectedKeyButton.keyValue] then
						currentMapping[selectedKeyButton.keyValue] = Musician.KEYBOARD_FIXED_MAPPING[selectedKeyButton.keyValue]
					else
						currentMapping[selectedKeyButton.keyValue] = nil
					end
				else
					if ALLOWED_DUPLICATES[selectedKeyButton.key] == nil then
						keysDone = keysDone + 1
					end
				end

				-- Set new binding
				currentMapping[keyValue] = selectedKeyButton.key
				selectedKeyButton.keyValue = keyValue
				selectedKeyButton:SetText(Musician.KeyboardUtils.GetKeyValueName(keyValue))

				Musician.KeyboardConfig.UpdateCompletion()
				Musician.KeyboardConfig.SelectNextKeyBinding()
			else
				PlaySoundFile("Sound\\interface\\Error.ogg")
			end
		end
	else
		if keyValue == "ESCAPE" then
			Musician.KeyboardConfig.Cancel()
		end
	end
end

--- Jump to the next binding
--
Musician.KeyboardConfig.SelectNextKeyBinding = function()
	if selectedKeyButton == nil then
		return
	end
	local index = selectedKeyButton.index + 1

	while index <= #keyButtons and not(keyButtons[index]:IsEnabled()) do
		index = index + 1
	end

	if index > #keyButtons then
		Musician.KeyboardConfig.UnselectKeyBinding()
		return
	end

	if keyButtons[index].row ~= selectedKeyButton.row then
		PlaySound(SOUNDKIT.ALARM_CLOCK_WARNING_3)
	end

	Musician.KeyboardConfig.SelectKeyBinding(keyButtons[index].key)
end

--- Key bindings OnClick
--
Musician.KeyboardConfig.Key_OnClick = function(self, button, down)
	if selectedKeyButton and selectedKeyButton == self then
		Musician.KeyboardConfig.UnselectKeyBinding()
	else
		Musician.KeyboardConfig.SelectKeyBinding(self.key)
	end
end

--- Select a key binding
-- @param key (string)
Musician.KeyboardConfig.SelectKeyBinding = function(key)
	Musician.KeyboardConfig.UnselectKeyBinding()
	local button = getKeyButton(key)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	BindingButtonTemplate_SetSelected(button, true)
	selectedKeyButton = button
	Musician.KeyboardConfig.UpdateHint()
end

--- Unselect key binding
--
Musician.KeyboardConfig.UnselectKeyBinding = function()
	if selectedKeyButton then
		BindingButtonTemplate_SetSelected(selectedKeyButton, false)
		selectedKeyButton = nil
		Musician.KeyboardConfig.UpdateHint()
	end
end

--- Update hint text
--
Musician.KeyboardConfig.UpdateHint = function()
	if selectedKeyButton then
		local msg = Musician.Msg.PRESS_KEY_BINDING
		msg = string.gsub(msg, '{col}', Musician.Utils.Highlight(selectedKeyButton.col))
		msg = string.gsub(msg, '{row}', Musician.Utils.Highlight(selectedKeyButton.row))

		if ALLOWED_DUPLICATES[selectedKeyButton.key] ~= nil then
			local msg2 = Musician.Msg.KEY_CAN_BE_MERGED
			msg2 = string.gsub(msg2, '{key}', Musician.Utils.Highlight(Musician.KeyboardUtils.GetKeyValueName(ALLOWED_DUPLICATES[selectedKeyButton.key])))
			msg = msg .. "\n" .. msg2
		end

		MusicianKeyboardConfigHint:SetText(msg)
	elseif Musician.KeyboardConfig.IsComplete() then
		MusicianKeyboardConfigHint:SetText(Musician.Msg.CONFIGURE_KEYBOARD_HINT_COMPLETE)
	else
		MusicianKeyboardConfigHint:SetText(Musician.Msg.CONFIGURE_KEYBOARD_HINT)
	end
end
