/**
 * Base64 encoding. Fast enough.
 *
 *
 * Usage example:
 *  base64("me@sib.li")
 *  result: "bWVAc2liLmxp"
 *
 * UTF strings are also accepted.
 *
 * Or let’s assume some binary data:
 *  base64( hexStr2bin('89 50 4e 47 0d 0a 1a 0a') );
 *  result: "iVBORw0KGgo="
 */
var base64 = function(input) {
	var result = '', binData, i;
	var base64Alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/='.split(''); // Base is 65 in fact :-)
	if (typeof input === 'string') for (i = 0, input = input.split(''); i < input.length; i++) input[i] = input[i].charCodeAt(0);
	// Extreme optimization. Something like black magic.
	// Risk of breaking the brain :-)
	for (i = 0; i < input.length; i += 3) {
		// Warning, bitwise operations! :-)
		// Grabbing three bytes (octets in binary):
		binData = (input[i] & 0xFF) << 16 |     // FF.00.00
				  (input[i + 1] & 0xFF) << 8 |  // 00.FF.00
				  (input[i + 2] & 0xFF);        // 00.00.FF
		// And converting them to four base64 "sixtets" (letters):
		result += base64Alphabet[(binData & 0xFC0000) >>> 18] +                   //11111100.00000000.00000000 = 0xFC0000 = 16515072
				  base64Alphabet[(binData & 0x03F000) >>> 12] +                   //00000011.11110000.00000000 = 0x03F000 = 258048
				  base64Alphabet[( i + 3 >= input.length && (input.length << 1) % 3 === 2 ? 64 :
									 (binData & 0x000FC0) >>> 6 )] +              //00000000.00001111.11000000 = 0x000FC0 = 4032
				  base64Alphabet[( i + 3 >= input.length && (input.length << 1) % 3 ? 64 :
								  binData & 0x00003F )];                          //00000000.00000000.00111111 = 0x00003F = 63
				  // If we haven't last byte, or two (for complete three octets),
				  // we place '=' [61] letter (or two) at the end.
	}
	return result;
} // base64


// Converts human-readable hex string to binary buffer.
var hexStr2bin = function(str) {
	str = str.replace(/[^0-9^a-f]/ig, ''); // Cutting off the garbage.
	if (str.length & 1) return false; // Oh, this is not hex string (len % 2 !== 0).
	var result = [], i;
	for (i = 0; i < str.length; i += 2) {
		result[result.length] = parseInt(str.substr(i, 2), 16);
	}
	return result;
} // hexStr2bin