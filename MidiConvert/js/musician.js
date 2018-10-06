
var Musician = {}

Musician.NOTE_IDS = {'C': 0, 'C#': 1, 'D': 2, 'D#': 3, 'E': 4, 'F': 5, 'F#': 6, 'G': 7, 'G#': 8, 'A': 9, 'A#': 10, 'B': 11};
Musician.C0_INDEX = 24;

Musician.FILE_HEADER = 'MUS3';
Musician.MAX_NOTE_DURATION = 6;
Musician.NOTE_DURATION_FPS = 255 / Musician.MAX_NOTE_DURATION; // 8-bit
Musician.NOTE_TIME_FPS = 240;
Musician.MAX_NOTE_TIME = 65535 / Musician.NOTE_TIME_FPS; // 16-bit
Musician.PERCUSSION_KEY_OFFSET = -12;

Musician.NoteKey = function(noteName) {
	var matches = noteName.match(/^([^0-9-]+)(-?[0-9]+)$/);

	var octave = parseInt(matches[2], 10);
	var note = matches[1];

	if (Musician.NOTE_IDS[note] === undefined) {
		return 0;
	}

	return Musician.C0_INDEX + octave * 12 + Musician.NOTE_IDS[note];
}

Musician.PackNumber = function(num, bytes) {
	var m = num;
	var b;
	var packed = '';
	var i = 0

	while ((m > 0) || (i < bytes)) {
		b = m % 256;
		m = (m - b) / 256;
		packed = String.fromCharCode(b) + packed;
		i = i + 1;
	}

	return packed.substring(packed.length - bytes)
}

Musician.PackTime = function(seconds, bytes, fps) {
	return Musician.PackNumber(Math.round(seconds * fps), bytes);
}

Musician.PackString = function(str) {
	var utf8Str = Musician.EncodeUTF8(str);
	return Musician.PackNumber(utf8Str.length, 2) + utf8Str;
}

Musician.EncodeUTF8 = function(str) {
	return unescape(encodeURIComponent(str));
}

Musician.PackSong = function(song) {

	var packedSong = '';

	// Header (4)
	packedSong += Musician.FILE_HEADER;

	// Duration (3)
	var duration = Math.ceil(song.duration);
	packedSong += Musician.PackNumber(duration, 3);

	// Number of tracks (1)
	if (song.tracks.length > 255) {
		throw "A song cannot have more than 255 tracks.";
	}
	packedSong += Musician.PackNumber(song.tracks.length, 1);

	// Find some heavy metal instruments
	var isMetal = false
	song.tracks.forEach(function(track) {
		// Overdriven Guitar, Distortion Guitar, Guitar harmonics
		isMetal = isMetal || track.instrumentNumber >= 29 && track.instrumentNumber <= 31;
	});

	// Grab track and notes
	var tracks = [];
	song.tracks.forEach(function(rawTrack) {
		var track = {};

		// Track instrument
		if (rawTrack.isPercussion) {
			// Use modern drumkit (129) instead of the tradition one (128) if the song contains heavy metal instruments
			track.instrument = isMetal ? 129 : 128;
		} else {
			track.instrument = rawTrack.instrumentNumber;
		}
		track.isPercussion = rawTrack.isPercussion;

		// Track channel
		track.channel = rawTrack.channelNumber + 1;

		// Track name
		track.name = rawTrack.name || "";

		// Track notes
		var offset = 0;
		var notes = [];
		rawTrack.notes.forEach(function(rawNote) {
			//var noteTime = rawNote.time - lastNoteTime;
			var noteTime = rawNote.time - offset;
			var noteKey = Musician.NoteKey(rawNote.name) + (rawTrack.isPercussion ? Musician.PERCUSSION_KEY_OFFSET : 0);
			var noteDuration = Math.min(rawNote.duration, Musician.MAX_NOTE_DURATION);

			// Insert note spacers if needed
			var noteSpacer = '';
			while (noteTime > Musician.MAX_NOTE_TIME) {
				noteSpacer += Musician.PackNumber(0xFF, 1); // 0xFF char
				noteTime -= Musician.MAX_NOTE_TIME;
				offset += Musician.MAX_NOTE_TIME;
			}

			// Insert packed note: key (1), time (2), duration (1)
			notes.push(
				noteSpacer +
				Musician.PackNumber(noteKey, 1) +
				Musician.PackTime(noteTime, 2, Musician.NOTE_TIME_FPS) +
				Musician.PackTime(noteDuration, 1, Musician.NOTE_DURATION_FPS)
			);

			lastNoteTime = rawNote.time;
		});
		track.notes = notes;

		tracks.push(track);
	});

	// Track data: instrument (1), channel (1), number of notes (2),
	tracks.forEach(function(track) {
		if (track.notes.length > 65535) {
			throw "A track cannot have more than 65535 notes.";
		}

		packedSong += Musician.PackNumber(track.instrument, 1);
		packedSong += Musician.PackNumber(track.channel, 1);
		packedSong += Musician.PackNumber(track.notes.length, 2);
	});

	// Note data
	tracks.forEach(function(track) {
		packedSong += track.notes.join(''); // Notes are already packed
	});

	// Song title (2) + (title length in bytes)
	packedSong += Musician.PackString(song.header.name || '');

	// Track names (2) + (title length in bytes)
	tracks.forEach(function(track) {
		packedSong +=  Musician.PackString(track.name);
	});

	return packedSong;
}
