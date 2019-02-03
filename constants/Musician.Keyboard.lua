-- https://www.w3.org/TR/uievents-code/#keyboard-key-codes

local KEY = {
	AltLeft = "AltLeft",
	AltRight = "AltRight",
	Backquote = "Backquote",
	Backslash1 = "Backslash1",
	Backslash2 = "Backslash2",
	Backspace = "Backspace",
	BracketLeft = "BracketLeft",
	BracketRight = "BracketRight",
	CapsLock = "CapsLock",
	Comma = "Comma",
	ContextMenu = "ContextMenu",
	ControlLeft = "ControlLeft",
	ControlRight = "ControlRight",
	Digit0 = "Digit0",
	Digit1 = "Digit1",
	Digit2 = "Digit2",
	Digit3 = "Digit3",
	Digit4 = "Digit4",
	Digit5 = "Digit5",
	Digit6 = "Digit6",
	Digit7 = "Digit7",
	Digit8 = "Digit8",
	Digit9 = "Digit9",
	Enter = "Enter",
	Equal = "Equal",
	IntlBackslash = "IntlBackslash",
	IntlRo = "IntlRo",
	IntlYen = "IntlYen",
	KeyA = "KeyA",
	KeyB = "KeyB",
	KeyC = "KeyC",
	KeyD = "KeyD",
	KeyE = "KeyE",
	KeyF = "KeyF",
	KeyG = "KeyG",
	KeyH = "KeyH",
	KeyI = "KeyI",
	KeyJ = "KeyJ",
	KeyK = "KeyK",
	KeyL = "KeyL",
	KeyM = "KeyM",
	KeyN = "KeyN",
	KeyO = "KeyO",
	KeyP = "KeyP",
	KeyQ = "KeyQ",
	KeyR = "KeyR",
	KeyS = "KeyS",
	KeyT = "KeyT",
	KeyU = "KeyU",
	KeyV = "KeyV",
	KeyW = "KeyW",
	KeyX = "KeyX",
	KeyY = "KeyY",
	KeyZ = "KeyZ",
	MetaLeft = "MetaLeft",
	MetaRight = "MetaRight",
	Minus = "Minus",
	Period = "Period",
	Quote = "Quote",
	Semicolon = "Semicolon",
	ShiftLeft = "ShiftLeft",
	ShiftRight = "ShiftRight",
	Slash = "Slash",
	Space = "Space",
	Tab = "Tab",
}

Musician.KEYBOARD = {
	{ KEY.Backquote, KEY.Digit1, KEY.Digit2, KEY.Digit3, KEY.Digit4, KEY.Digit5, KEY.Digit6, KEY.Digit7, KEY.Digit8, KEY.Digit9, KEY.Digit0, KEY.Minus, KEY.Equal, KEY.IntlYen, KEY.Backspace },
	{ KEY.Tab, KEY.KeyQ, KEY.KeyW, KEY.KeyE, KEY.KeyR, KEY.KeyT, KEY.KeyY, KEY.KeyU, KEY.KeyI, KEY.KeyO, KEY.KeyP, KEY.BracketLeft, KEY.BracketRight, KEY.Backslash1 },
	{ KEY.CapsLock, KEY.KeyA, KEY.KeyS, KEY.KeyD, KEY.KeyF, KEY.KeyG, KEY.KeyH, KEY.KeyJ, KEY.KeyK, KEY.KeyL, KEY.Semicolon, KEY.Quote, KEY.Backslash2, KEY.Enter },
	{ KEY.ShiftLeft, KEY.IntlBackslash, KEY.KeyZ, KEY.KeyX, KEY.KeyC, KEY.KeyV, KEY.KeyB, KEY.KeyN, KEY.KeyM, KEY.Comma, KEY.Period, KEY.Slash, KEY.IntlRo, KEY.ShiftRight },
	{ KEY.ControlLeft, KEY.MetaLeft, KEY.AltLeft, KEY.Space, KEY.AltRight, KEY.MetaRight, KEY.ContextMenu, KEY.ControlRight },
}

Musician.KEYBOARD_KEY = KEY

Musician.KEYBOARD_KEY_SIZE = {
	{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
	{ 1.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.5 },
	{ 1.666, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.333 },
	{ 1.333, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.666 },
	{ 1.5, 1, 1.333, 6.333, 1.333, 1, 1, 1.5 },
}

Musician.KEYBOARD_MERGEABLE_KEYS = {
	[KEY.IntlYen] = KEY.Backspace,
	[KEY.Backslash1] = KEY.Enter,
	[KEY.Backslash2] = KEY.Enter,
	[KEY.IntlBackslash] = KEY.ShiftLeft,
	[KEY.IntlRo] = KEY.ShiftRight,
}

if not(IsMacClient()) then
	Musician.DISABLED_KEYS = {}
	Musician.DISABLED_KEY_VALUES = {}
else
	Musician.DISABLED_KEYS = {
		[KEY.ShiftLeft] = true,
		[KEY.ShiftRight] = true,
		[KEY.CapsLock] = true,
	}
	Musician.DISABLED_KEY_VALUES = {
		LSHIFT = true,
		RSHIFT = true,
		CAPSLOCK = true,
	}
end

Musician.KEYBOARD_FIXED_MAPPING = {
	BACKSPACE = KEY.Backspace,
	TAB = KEY.Tab,
	CAPSLOCK = KEY.CapsLock,
	ENTER = KEY.Enter,
	LSHIFT = KEY.ShiftLeft,
	RSHIFT = KEY.ShiftRight,
	LCTRL = KEY.ControlLeft,
	LMETA = KEY.MetaLeft,
	LALT = KEY.AltLeft,
	SPACE = KEY.Space,
	RALT = KEY.AltRight,
	RMETA = KEY.MetaRight,
	MENU = KEY.ContextMenu,
	RCTRL = KEY.ControlRight,
}

Musician.KEYBOARD_LAYER = {
	UPPER = 0,
	LOWER = 1,
}
