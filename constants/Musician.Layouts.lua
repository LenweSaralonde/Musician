Musician.Layouts = {}

local KEY = Musician.KEYBOARD_KEY

Musician.Layouts = {
	{
		['name'] = "piano",
		['scale'] = { 0, 1, 2, 3, 4, -1, 5, 6, 7, 8, 9, 10, 11, -1 },
		['shift'] = 2,
		['upper'] = {
			['keyboardMapping'] = {
				KEY.Backquote, KEY.Tab, KEY.Digit1,
				KEY.KeyQ, KEY.Digit2, KEY.KeyW, KEY.Digit3, KEY.KeyE, KEY.Digit4, KEY.KeyR, KEY.Digit5, KEY.KeyT, KEY.Digit6, KEY.KeyY, KEY.Digit7, KEY.KeyU, KEY.Digit8,
				KEY.KeyI, KEY.Digit9, KEY.KeyO, KEY.Digit0, KEY.KeyP, KEY.Minus, KEY.BracketLeft, KEY.Equal, KEY.BracketRight, KEY.IntlYen, KEY.Backslash1, KEY.Backspace
			},
			['baseKey'] = 'C4',
			['baseKeyIndex'] = 3,
		},
		['lower'] = {
			['keyboardMapping'] = {
				KEY.ShiftLeft, KEY.CapsLock, KEY.IntlBackslash, KEY.KeyA,
				KEY.KeyZ, KEY.KeyS, KEY.KeyX, KEY.KeyD, KEY.KeyC, KEY.KeyF, KEY.KeyV, KEY.KeyG, KEY.KeyB, KEY.KeyH, KEY.KeyN, KEY.KeyJ, KEY.KeyM, KEY.KeyK,
				KEY.Comma, KEY.KeyL, KEY.Period,  KEY.Semicolon, KEY.Slash, KEY.Quote, KEY.IntlRo, KEY.Backslash2, KEY.ShiftRight
			},
			['baseKey'] = 'C3',
			['baseKeyIndex'] = 4,
		},
	},

}
