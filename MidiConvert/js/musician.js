
var Musician = {}

Musician.NOTE_IDS = {'C': 0, 'C#': 1, 'D': 2, 'D#': 3, 'E': 4, 'F': 5, 'F#': 6, 'G': 7, 'G#': 8, 'A': 9, 'A#': 10, 'B': 11};
Musician.C0_INDEX = 24;

Musician.FILE_HEADER = 'MUS2';
Musician.MAX_NOTE_DURATION = 6
Musician.DURATION_FPS = 256 / Musician.MAX_NOTE_DURATION // 2^8

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

Musician.PackNote = function(note, isPercussion, fps) {
	// KTTD : key, time, duration
	return Musician.PackNumber(Musician.NoteKey(note.name) + (isPercussion ? (39 - 51) : 0), 1) + Musician.PackTime(note.time, 2, fps) + Musician.PackTime(note.duration, 1, Musician.DURATION_FPS);
}

Musician.PackTrack = function(track, fps) {
	var packedTrack;

	var instrumentNumber;

	if (track.isPercussion) {
		instrumentNumber = 128;
	} else {
		instrumentNumber = track.instrumentNumber;
	}

	// TINN : Track Id, instrument ID, Number of notes
	packedTrack = Musician.PackNumber(track.id, 1) + Musician.PackNumber(instrumentNumber, 1) + Musician.PackNumber(track.notes.length, 2);

	// Notes
	var note
	track.notes.forEach(function(note) {
		packedTrack += Musician.PackNote(note, track.isPercussion, fps);
	});

	return packedTrack;
}

Musician.PackSong = function(song) {

	var duration = Math.ceil(song.duration);
	
	var fps = 65536 / duration;

	if (fps < 60) {
		throw "Songs should not be longer than 18 minutes.";
	}

	var packedSong = Musician.FILE_HEADER;
	var songName = (song.header.name || '').substring(0, 255);

	// Song name length, song name
	packedSong += Musician.PackNumber(songName.length, 1) + songName;

	// Song duration, in seconds
	packedSong += Musician.PackNumber(duration, 2);

	// Number of tracks
	packedSong += Musician.PackNumber(song.tracks.length, 1);

	// Song tracks
	var track;	
	song.tracks.forEach(function(track) {
		packedSong += Musician.PackTrack(track, fps);
	});

	return packedSong;
}
