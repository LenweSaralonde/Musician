
var Musician = {};

Musician.FILE_HEADER = 'MUS6';
Musician.MAX_NOTE_DURATION = 6;
Musician.NOTE_DURATION_FPS = 255 / Musician.MAX_NOTE_DURATION; // 8-bit
Musician.NOTE_TIME_FPS = 240;
Musician.MAX_NOTE_TIME = 65535 / Musician.NOTE_TIME_FPS; // 16-bit
Musician.CONVERTER_VERSION = 11;

Musician.CompareEvents = function(a, b) {
	if (a.time < b.time) { // A before B
		return -1;
	} else if (a.time > b.time) { // A after B
		return 1;
	}

	// A and B have the same time

	if (a.cc && b.note) { // A is CC, B is note
		return -1;
	} else if (a.note && b.cc) { // A is note, B is CC
		return 1;
	} else if (a.cc && b.cc) { // A and B are both CC
		return 0;
	}

	// A and B are notes

	if (a.state && !b.state) { // Note on is before note off
		return -1;
	} else if (!a.state && b.state) { // Note off is after note on
		return 1;
	}
	return 0;
};

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

Musician.ExtractCC = function(song) {
	var cc = {};

	song.tracks.forEach(function(track) {
		var ccTypes = Object.keys(track.controlChanges);
		ccTypes.forEach(function(ccType) {
			track.controlChanges[ccType].forEach(function(ccEvent) {
				if (cc[ccEvent.channel] === undefined) {
					cc[ccEvent.channel] = [];
				}
				cc[ccEvent.channel].push(ccEvent);
			});
		});
	});

	Object.keys(cc).forEach(function(channel) {
		cc[channel].sort(function(a, b) {
			if (a.time < b.time) {
				return -1;
			} else if (a.time > b.time) {
				return 1;
			} else {
				return 0;
			}
		});
	});

	song.controlChanges = cc;
}

Musician.ProcessSustainPedal = function(song) {

	song.tracks.forEach(function(track) {

		// Mix pedal events with notes
		var events = [];

		// Add notes as note on/note off events
		track.notes.forEach(function(note) {
			events.push({ time: note.time, state: true, note: note });
			events.push({ time: note.time + note.duration, state: false, note: note });
		});

		// Add pedal events
		song.controlChanges[track.channelNumber] && song.controlChanges[track.channelNumber].forEach(function(cc) {
			if (cc.number === 64) { // pedal CC
				events.push({ time: cc.time, cc: cc});
			}
		});

		// Reorder events
		events.sort(Musician.CompareEvents);

		// Sustain notes
		var sustainedNotes = {};
		var isSustained = false;
		var lastNoteTime;
		events.forEach(function(event) {
			if (event.cc) {
				if (!isSustained && event.cc.value >= .5) { // Pedal down (sustain on)
					isSustained = true;
					sustainedTime = event.time;
				} else if (isSustained && event.cc.value < .5) { // Pedal up (sustain off)
					isSustained = false;

					// Release all notes
					var keys = Object.keys(sustainedNotes);
					keys.forEach(function(key) {
						sustainedNotes[key].duration = Math.max(sustainedNotes[key].duration, event.time - sustainedNotes[key].time);
						delete sustainedNotes[key];
					});
				}
			} else {
				var isSustainedNote = isSustained;
				if (!isSustainedNote) {
					return;
				}

				// Note is already sustained
				if (sustainedNotes[event.note.midi] === event.note) {
					return;
				}

				// Another note is already sustained for the same key: stop it then remove it
				if (event.state && sustainedNotes[event.note.midi]) {
					sustainedNotes[event.note.midi].duration = Math.max(sustainedNotes[event.note.midi].duration, event.time - sustainedNotes[event.note.midi].time);
					delete sustainedNotes[event.note.midi];
				}

				// Add sustained note
				sustainedNotes[event.note.midi] = event.note;

				lastNoteTime = event.time + event.note.duration;
			}
		});

		// Release all leftover notes
		var keys = Object.keys(sustainedNotes);
		keys.forEach(function(key) {
			sustainedNotes[key].duration = Math.max(sustainedNotes[key].duration, lastNoteTime - sustainedNotes[key].time);
			delete sustainedNotes[key];
		});
	});
}

Musician.ProcessPitchBend = function(song) {
	song.tracks.forEach(function(track) {

		// Mix pitch bend events with notes
		var events = [];
		var noteId = 1;

		// Add notes as note on/note off events
		track.notes.forEach(function(note) {
			events.push({ time: note.time, state: true, id: noteId, duration: note.duration, note: note });
			events.push({ time: note.time + note.duration, state: false, id: noteId, note: note });
			noteId++;
		});

		// Add pitch bend events
		song.controlChanges[track.channelNumber] && song.controlChanges[track.channelNumber].forEach(function(cc) {
			if (cc.number === 'pitchBend') {
				events.push({ time: cc.time, id: 0, cc: cc});
			}
		});

		// Reorder events
		events.sort(Musician.CompareEvents);

		// Process pitch bend
		var noteEvents = [];
		var notesOn = {};
		var currentPitchBend = 0;
		events.forEach(function(event) {
			if (event.note && event.state) { // Note on
				var midi = event.note.midi + currentPitchBend;
				notesOn[event.id] = { time: event.time, midi: midi, velocity: event.note.velocity };
			} else if (event.note && !event.state) { // Note off
				// Insert note event
				notesOn[event.id].duration = event.time - notesOn[event.id].time; // Update duration
				noteEvents.push(notesOn[event.id]);
				delete notesOn[event.id];
			} else if (event.cc) { // Pitch bend CC
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

		noteEvents.sort(Musician.CompareEvents);

		track.notes = noteEvents;
	});
};

Musician.PackSong = function(song, fileName) {

	var duration = Math.ceil(song.duration);

	Musician.ExtractCC(song);

	Musician.ProcessSustainPedal(song);
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
			// Shift instrument number by 128 for percussions
			track.instrument = rawTrack.instrumentNumber + 128;
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
			var noteKey = rawNote.midi;
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
