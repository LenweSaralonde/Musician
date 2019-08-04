
var Musician = {};

Musician.C0_INDEX = 12;

Musician.FILE_HEADER = 'MUS4';
Musician.MAX_NOTE_DURATION = 6;
Musician.NOTE_DURATION_FPS = 255 / Musician.MAX_NOTE_DURATION; // 8-bit
Musician.NOTE_TIME_FPS = 240;
Musician.MAX_NOTE_TIME = 65535 / Musician.NOTE_TIME_FPS; // 16-bit
Musician.PERCUSSION_KEY_OFFSET = -12;

Musician.PackNumber = function(num, bytes) {
	var m = Math.max(0, num);
	var b;
	var packed = '';
	var i = 0;

	while ((m > 0) || (i < bytes)) {
		b = m % 256;
		m = (m - b) / 256;
		packed = String.fromCharCode(b) + packed;
		i = i + 1;
	}

	return packed.substring(packed.length - bytes);
};

Musician.PackTime = function(seconds, bytes, fps) {
	return Musician.PackNumber(Math.round(seconds * fps), bytes);
};

Musician.PackString = function(str) {
	var utf8Str = Musician.EncodeUTF8(str);
	return Musician.PackNumber(utf8Str.length, 2) + utf8Str;
};

Musician.EncodeUTF8 = function(str) {
	return unescape(encodeURIComponent(str));
};

Musician.FilenameToTitle = function(fileName) {
	return fileName.replace(/[_]+/g, ' ').replace(/\.[a-zA-Z0-9]+$/, '').replace(/^(.)|\s+(.)/g, function ($1) {
		return $1.toUpperCase();
	});
};

Musician.ProcessPitchBend = function(song) {

	var eventTypeOrder = {
		'pitchBend': 1,
		'noteOn': 2,
		'noteOff': 3,
	};

	var eventSorter = function(a, b) {
		if (a.time < b.time) {
			return -1;
		} else if (a.time > b.time) {
			return 1;
		} else if (eventTypeOrder[a.type] < eventTypeOrder[b.type]) {
			return -1;
		} else if (eventTypeOrder[a.type] > eventTypeOrder[b.type]) {
			return 1;
		} else {
			return 0;
		}
	};

	song.tracks.forEach(function(track) {
		var events = [];
		var noteId = 1;

		// Add notes as note on/note off events
		track.notes.forEach(function(note) {
			events.push({ time: note.time, type: 'noteOn', id: noteId, duration: note.duration, note: note });
			events.push({ time: note.time + note.duration, type: 'noteOff', id: noteId, note: note });
			noteId++;
		});

		// Add pitch bend events
		track.controlChanges && track.controlChanges.pitchBend && track.controlChanges.pitchBend.forEach(function(cc) {
			events.push({ time: cc.time, type: 'pitchBend', id: 0, cc: cc});
		});

		// Reorder events
		events.sort(eventSorter);

		// Process pitch bend
		var noteEvents = [];
		var notesOn = {};
		var currentPitchBend = 0;
		events.forEach(function(event) {
			if (event.type === 'noteOn') {
				// Insert note on
				var midi = event.note.midi + currentPitchBend;
				notesOn[event.id] = { time: event.time, midi: midi, velocity: event.note.velocity };
			} else if (event.type === 'noteOff') {
				// Insert note event
				notesOn[event.id].duration = event.time - notesOn[event.id].time;
				noteEvents.push(notesOn[event.id]);
				delete notesOn[event.id];
			} else if (event.type === 'pitchBend') {
				var pitchBend = Math.round(event.cc.value);

				// New pitch bend value step: split notes
				if (pitchBend !== currentPitchBend) {
					// Split notes
					Object.keys(notesOn).forEach(function(id) {
						// Insert note event
						var note = notesOn[id];
						note.duration = event.time - note.time;
						noteEvents.push(Object.assign({}, note));

						// Insert note on
						midi = note.midi - currentPitchBend + pitchBend;
						var newNote = Object.assign({}, note, { time: event.time, midi: midi });
						notesOn[id] = newNote;
					});

					currentPitchBend = pitchBend;
				}
			}
		});

		noteEvents.sort(eventSorter);

		track.notes = noteEvents;
	});
};

Musician.PackSong = function(song, fileName) {

	var duration = Math.ceil(song.duration);

	Musician.ProcessPitchBend(song);

	var packedSong = '';

	// Header (4)
	packedSong += Musician.FILE_HEADER;

	// Duration (3)
	var duration = duration;
	packedSong += Musician.PackNumber(duration, 3);

	// Find some heavy metal instruments
	var isMetal = false;
	song.tracks.forEach(function(track) {
		// Overdriven Guitar, Distortion Guitar, Guitar harmonics
		isMetal = isMetal || track.instrumentNumber >= 29 && track.instrumentNumber <= 31;
	});

	// Grab track and notes
	var tracks = [];
	song.tracks.forEach(function(rawTrack) {
		if (rawTrack.notes.length === 0) {
			return;
		}

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
			var noteTime = rawNote.time - offset;
			var noteKey = Musician.C0_INDEX + rawNote.midi + (rawTrack.isPercussion ? Musician.PERCUSSION_KEY_OFFSET : 0);
			var noteDuration = Math.min(rawNote.duration, Musician.MAX_NOTE_DURATION);

			// Do not pack notes having zero duration
			if (noteDuration === 0) {
				return;
			}

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

	// Number of tracks (1)
	if (tracks.length > 255) {
		throw "A song cannot have more than 255 tracks.";
	}
	packedSong += Musician.PackNumber(tracks.length, 1);

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
	packedSong += Musician.PackString(song.header.name || Musician.FilenameToTitle(fileName) || '');

	// Track names (2) + (title length in bytes)
	tracks.forEach(function(track) {
		packedSong +=  Musician.PackString(track.name);
	});

	return packedSong;
};
