const parseMidi = require('./lib/midi-file/index').parseMidi;

export const CONVERTER_VERSION = '8.3';

const FILE_HEADER = 'MUS8';
const MAX_NOTE_DURATION = 6;
const NOTE_DURATION_FPS = 255 / MAX_NOTE_DURATION; // 8-bit
const MAX_LONG_NOTE_DURATION = 255 * MAX_NOTE_DURATION;
const NOTE_TIME_FPS = 240;
const MAX_NOTE_TIME = 65535 / NOTE_TIME_FPS; // 16-bit
const MODE_DURATION = 0x10;

const DEFAULT_PITCH_BEND_RANGE = 2;
const MUSESCORE_DEFAULT_PITCH_BEND_RANGE = 12;

const CC_RPN_FINE = 0x64;
const CC_RPN_COARSE = 0x65;
const CC_DATA_ENTRY_COARSE = 0x06;
const CC_DATA_ENTRY_FINE = 0x26;

/**
 * Pack an integer number into a binary string.
 * @param {integer} num integer to pack
 * @param {integer} bytes number of bytes
 * @returns {string}
 */
function packNumber(num, bytes) {
	num = num & (Math.pow(256, bytes) - 1);
	let packed = '';
	for (let b = 0; b < bytes; b++) {
		packed = String.fromCharCode(num & 0xFF) + packed;
		num = num >> 8;
	}
	return packed;
}

/**
 * Pack a time or duration in seconds into a binary string.
 * @param {number} seconds
 * @param {int} bytes number of bytes
 * @param {number} fps precision in frames par second
 * @returns {string}
 */
function packTime(seconds, bytes, fps) {
	return packNumber(Math.round(seconds * fps), bytes);
}

/**
 * Pack a string into binary.
 * @param {string} str
 * @returns {string}
 */
function packString(str) {
	const utf8Str = utf8Encode(str);
	return packNumber(utf8Str.length, 2) + utf8Str;
}

/**
 * Encode string into UTF-8.
 * @param {string} str
 * @returns {string}
 */
function utf8Encode(str) {
	return unescape(encodeURIComponent(str)).replace(/\u0000+$/, '');
}

/**
 * Format file name into a title.
 * @param {string} fileName
 * @returns {string}
 */
function filenameToTitle(fileName) {
	return fileName.replace(/[_]+/g, ' ').replace(/\.[a-zA-Z0-9]+$/, '').replace(/^(.)|\s+(.)/g, function ($1) {
		return $1.toUpperCase();
	});
}

/**
 * Extract events from parsed MIDI file into an ordered flat array with timestamps in seconds.
 * @param {object} midi parsed MIDI file
 * @returns {array}
 */
function extractEvents(midi) {
	// Extract all events as a flat array
	const events = [];
	for (const trackIndex in midi.tracks) {
		const tick = 0;
		for (const event of midi.tracks[trackIndex]) {
			tick += event.deltaTime;
			event.tick = tick;
			event.trackIndex = parseInt(trackIndex, 10);
			events.push(event);
		}
	}

	// Sort events in chronological order
	events.sort((a, b) => {
		if (a.tick < b.tick) {
			return -1;
		} else if (a.tick > b.tick) {
			return 1;
		} else {
			return 0;
		}
	});

	// Convert event timings into seconds

	let currentTick = 0;
	let currentTime = 0;
	let bpm = 120;
	let tickDuration;
	if (midi.header.ticksPerBeat) {
		tickDuration = 60 / bpm / midi.header.ticksPerBeat;
	} else {
		tickDuration = 1000000 / (midi.header.framesPerSecond * midi.header.ticksPerFrame);
	}

	for (const event of events) {
		const relativeTick = event.tick - currentTick;
		event.time = currentTime + relativeTick * tickDuration;
		currentTime = event.time;
		currentTick = event.tick;

		// Handle tempo change
		if (event.type === 'setTempo') {
			bpm = 60000000 / event.microsecondsPerBeat;
			if (midi.header.ticksPerBeat) {
				tickDuration = 60 / bpm / midi.header.ticksPerBeat;
			}
		}
	}

	return events;
}

/**
 * Replace sustain pedal events by proper noteOff events.
 * @param {array} events
 * @returns {array}
 */
function processSustain(events) {

	const eventsWithSustain = [];
	const notesDown = new Map(); // Notes that have their piano key pushed down
	const skippedNotesOff = new Map(); // Notes off events that were skipped because of channel sustain
	const sustainedChannels = {}; // Channels being sustained

	for (const event of events) {
		// Note events
		if (event.type === 'noteOn' || event.type === 'noteOff') {
			const noteKey = `${event.channel}-${event.trackIndex}-${event.noteNumber}`;
			if (event.type === 'noteOn') {
				notesDown.set(noteKey, event); // The piano key is down

				// There is already a noteOff awaiting for this note: insert it first
				const previousNoteOffEvent = skippedNotesOff.get(noteKey);
				if (previousNoteOffEvent) {
					eventsWithSustain.push({
						deltaTime: event.deltaTime,
						tick: event.tick,
						time: event.time,
						channel: previousNoteOffEvent.channel,
						noteNumber: previousNoteOffEvent.noteNumber,
						trackIndex: previousNoteOffEvent.trackIndex,
						type: 'noteOff',
						velocity: previousNoteOffEvent.velocity,
					});
					skippedNotesOff.delete(noteKey);
				}

				// Always insert noteOn events
				eventsWithSustain.push({ ...event });
			} else { // noteOff
				notesDown.delete(noteKey); // The piano key is up
				if (!sustainedChannels[event.channel]) {
					// Add noteOff event if the channel is not sustained
					eventsWithSustain.push({ ...event });
				} else {
					// Don't add noteOff event when sustained but keep if for later on pedal release
					skippedNotesOff.set(noteKey, event);
				}
			}
		}
		// Sustain pedal events
		else if (event.type === 'controller' && event.controllerType === 64) {
			const isSustained = event.value >= 64;
			if (!isSustained && sustainedChannels[event.channel]) { // Sustain pedal was released
				for (const [noteKey, noteOff] of skippedNotesOff) {
					// Only stop notes for the current channel and that is not held down
					if (noteOff.channel === event.channel && !notesDown.has(noteKey)) {
						// Add noteOff event
						eventsWithSustain.push({
							deltaTime: event.deltaTime,
							tick: event.tick,
							time: event.time,
							channel: noteOff.channel,
							noteNumber: noteOff.noteNumber,
							trackIndex: noteOff.trackIndex,
							type: 'noteOff',
							velocity: noteOff.velocity,
						});
						skippedNotesOff.delete(noteKey);
					}
				}
			}
			sustainedChannels[event.channel] = isSustained;
		}
		// Other events
		else {
			eventsWithSustain.push({ ...event });
		}
	}

	// Add noteOff leftovers
	for (const [noteKey, noteOff] of skippedNotesOff) {
		eventsWithSustain.push({ ...noteOff });
	}

	return eventsWithSustain;
}

/**
 * Replace pitch bend events by semitone slides.
 * @param {array} events
 * @param {object} options
 * @param {boolean} options.fromMuseScore Fix default pitch bend range for songs imported from MuseScore
 * @returns {array}
 */
function processPitchBend(events, options = {}) {

	// Set default pitch bend range to 12 for songs imported from MuseScore
	const defaultPitchBendRange = options.fromMuseScore ? MUSESCORE_DEFAULT_PITCH_BEND_RANGE : DEFAULT_PITCH_BEND_RANGE;

	const eventsWithPitchBend = [];
	const notesOn = {};
	const channelCC = {};
	const pitchBendValue = {};
	const pitchBendRange = {};
	const pitchBendRangeCCTypes = [CC_RPN_COARSE, CC_RPN_FINE, CC_DATA_ENTRY_COARSE, CC_DATA_ENTRY_FINE];

	let isSettingPitchBendRangeCoarse = {};
	let isSettingPitchBendRangeFine = {};

	for (const event of events) {
		// Control change event to reset all controllers
		if (event.type === 'controller' && event.controllerType === 0x79) {
			pitchBendRange[event.channel] = defaultPitchBendRange;
		}

		// Control change event for pitch bend range
		if (event.type === 'controller' && pitchBendRangeCCTypes.includes(event.controllerType)) {
			if (!channelCC[event.channel]) {
				channelCC[event.channel] = {};
			}
			channelCC[event.channel][event.controllerType] = event.value;

			let isPitchBendRangeMessageComplete = false;
			if (event.controllerType === CC_RPN_COARSE && event.value === 0x00) {
				isSettingPitchBendRangeCoarse[event.channel] = true;
			} else if (event.controllerType === CC_RPN_FINE && event.value === 0x00) {
				isSettingPitchBendRangeFine[event.channel] = true;
			} else if (event.controllerType === CC_DATA_ENTRY_COARSE && isSettingPitchBendRangeCoarse[event.channel]) {
				isSettingPitchBendRangeCoarse[event.channel] = false;
				isPitchBendRangeMessageComplete = true;
			} else if (event.controllerType === CC_DATA_ENTRY_FINE && isSettingPitchBendRangeFine[event.channel]) {
				isSettingPitchBendRangeFine[event.channel] = false;
				isPitchBendRangeMessageComplete = true;
			}

			// We're done receiving our pitch bend range message
			if (isPitchBendRangeMessageComplete &&
				(channelCC[event.channel][CC_RPN_COARSE] || 0x00) === 0x00 &&
				(channelCC[event.channel][CC_RPN_FINE] || 0x00) === 0x00) {
				pitchBendRange[event.channel] = (channelCC[event.channel][CC_DATA_ENTRY_COARSE] || defaultPitchBendRange) + (channelCC[event.channel][CC_DATA_ENTRY_FINE] || 0) / 100;
			}
		}

		// Note events
		if (event.type === 'noteOn' || event.type === 'noteOff') {
			// Apply pitch bend note offset to the note event
			const channelPitchBendValue = pitchBendValue[event.channel] || 0;
			const channelPitchBendRange = pitchBendRange[event.channel] || defaultPitchBendRange;
			const noteOffset = Math.round(channelPitchBendValue * channelPitchBendRange);
			const noteNumber = event.noteNumber + noteOffset;
			eventsWithPitchBend.push({ ...event, noteNumber });

			// Keep noteOn events to split them if a pitch bend variation occurs
			const noteKey = `${event.trackIndex}-${event.noteNumber}`;
			if (!notesOn[event.channel]) {
				notesOn[event.channel] = new Map();
			}
			if (event.type === 'noteOn') {
				notesOn[event.channel].set(noteKey, event);
			} else {
				notesOn[event.channel].delete(noteKey);
			}
		}
		// Pitch bend events
		else if (event.type === 'pitchBend') {
			const currentPitchBendValue = (pitchBendValue[event.channel] || 0) * (pitchBendRange[event.channel] || defaultPitchBendRange);

			// Changing pitch bend value
			if (event.type === 'pitchBend') {
				pitchBendValue[event.channel] = event.value / 0x2000;
			}

			const newPitchBendValue = (pitchBendValue[event.channel] || 0) * (pitchBendRange[event.channel] || defaultPitchBendRange);

			// Get current and new note (semitone) offsets
			const currentNoteOffset = Math.round(currentPitchBendValue);
			const newNoteOffset = Math.round(newPitchBendValue);

			// The semitone offset has changed
			if (currentNoteOffset !== newNoteOffset && notesOn[event.channel]) {
				// Split note to create the slide
				for (const [noteKey, noteOn] of notesOn[event.channel]) {
					// Insert noteOff event from current pitch bend value
					eventsWithPitchBend.push({
						deltaTime: event.deltaTime,
						tick: event.tick,
						time: event.time,
						channel: noteOn.channel,
						noteNumber: noteOn.noteNumber + currentNoteOffset,
						trackIndex: noteOn.trackIndex,
						type: 'noteOff',
						velocity: noteOn.velocity,
					});
					// Insert new noteOn event with the new pitch bend value
					eventsWithPitchBend.push({
						deltaTime: event.deltaTime,
						tick: event.tick,
						time: event.time,
						channel: noteOn.channel,
						noteNumber: noteOn.noteNumber + newNoteOffset,
						trackIndex: noteOn.trackIndex,
						type: 'noteOn',
						velocity: noteOn.velocity,
					});
				}
			}
		}
		// Other events
		else {
			eventsWithPitchBend.push({ ...event });
		}
	}

	return eventsWithPitchBend;
}

/**
 * Calculate the duration property of the noteOn events inside the provided events array.
 * @param {array} events
 * @returns {array} same as provided
 */
function calculateNoteOnDurations(events) {
	const notesOn = new Map();

	for (const event of events) {
		if (event.type === 'noteOn' || event.type === 'noteOff') {
			const noteKey = `${event.trackIndex}-${event.channel}-${event.noteNumber}`;
			const noteOnStack = notesOn.get(noteKey) || [];

			if (event.type === 'noteOn') {
				noteOnStack.push(event);
				notesOn.set(noteKey, noteOnStack);
			} else if (noteOnStack.length > 0) {
				const noteOnEvent = noteOnStack.pop();
				noteOnEvent.duration = event.time - noteOnEvent.time;
				if (noteOnStack.length === 0) {
					notesOn.delete(noteKey);
				}
			}
		}
	}

	return events;
}

/**
 * Convert MIDI file into a Musician song object.
 * @param {ArrayBuffer} midiArray
 * @param {string} fileName
 * @param {object} options
 * @returns {object}
 */
function convertMidi(midiArray, fileName, options) {

	// Parse binary MIDI file
	if (midiArray instanceof ArrayBuffer) {
		midiArray = new Uint8Array(midiArray);
	}
	const midi = parseMidi(midiArray);
	const rawEvents = extractEvents(midi);

	// Process sustain pedal
	const eventsWithSustain = processSustain(rawEvents);

	// Process pitch bend
	const eventsWithPitchBend = processPitchBend(eventsWithSustain, options);

	// Calculate noteOn durations
	const events = calculateNoteOnDurations(eventsWithPitchBend);

	// Create song object
	let title;
	const duration = events[events.length - 1].time; // Get the last event time as song duration
	const tracksMap = new Map();
	const trackNames = {}
	const instrumentByTrack = new Map();
	const instrumentByChannel = new Map();
	const titleParts = [];

	/**
	 * Create or return existing track matching index and channel
	 * @param {integer} trackIndex MIDI track index
	 * @param {integer} channel MIDI channel
	 * @returns {object}
	 */
	function getTrack(trackIndex = 0, channel = 0) {
		const trackInstrument = instrumentByTrack.get(`${channel}-${trackIndex}`);
		const channelInstrument = instrumentByChannel.get(channel);
		const instrument = (trackInstrument !== undefined) ? trackInstrument : (channelInstrument || 0);
		const trackKey = `${trackIndex}-${channel}-${instrument}`;
		// For MIDI format 2 files, channels 10 and 11 can be used for percussions
		const isPercussion = (midi.format === 2) ? (channel === 9 || channel === 10) : (channel === 9);

		// Create new track
		if (!tracksMap.has(trackKey)) {
			const track = {
				name: '',
				trackIndex,
				channel,
				instrument,
				isPercussion,
				notes: []
			};
			tracksMap.set(trackKey, track);
			return track;
		}

		else {
			return tracksMap.get(trackKey);
		}
	}

	// Fill song data
	for (const event of events) {
		switch (event.type) {
			case 'noteOn':
				const track = getTrack(event.trackIndex, event.channel);
				track.notes.push({
					time: event.time,
					duration: event.duration,
					key: event.noteNumber,
					velocity: event.velocity,
				});
				break;

			case 'programChange':
				instrumentByTrack.set(`${event.channel}-${event.trackIndex}`, event.programNumber);
				instrumentByChannel.set(event.channel, event.programNumber);
				break;

			case 'trackName':
				const trackName = event.text;
				trackNames[event.trackIndex] = trackName;
				break;

			case 'text':
				// Extract title from Karaoke metadata
				const matches = event.text.match(/^@T(.*)$/);
				if (matches) {
					titleParts.push(matches[1]);
				}

			default:
		}
	}

	// Song title
	title = (titleParts.length > 0) ? titleParts.join(' - ') : filenameToTitle(fileName); // Default to file name

	// Create tracks list
	const tracks = Array.from(tracksMap, ([trackKey, track]) => track).filter(track => (track.notes.length > 0)); // Only keep tracks with notes
	tracks.sort((a, b) => {
		const weightA = a.trackIndex * 1000000 + a.channel * 1000 + a.instrument;
		const weightB = b.trackIndex * 1000000 + b.channel * 1000 + b.instrument;
		if (weightA < weightB) {
			return -1;
		} else {
			return 1;
		}
	})

	// Track names
	for (const track of tracks) {
		track.name = trackNames[track.trackIndex] || '';
	}

	// Return final object
	return { title, duration, tracks };
}

/**
 * Convert MIDI file into a Musician song file.
 * @param {ArrayBuffer} midiArray
 * @param {string} fileName
 * @param {object} options
 * @returns {string}
 */
export function packSong(midiArray, fileName, options) {
	// Get formatted song
	const song = convertMidi(midiArray, fileName, options);

	let packedSong = '';

	// Header (4)
	packedSong += FILE_HEADER;

	// Song title (2) + (title length in bytes)
	packedSong += packString(song.title);

	// Song mode (1)
	packedSong += packNumber(MODE_DURATION, 1);

	// Duration (3)
	packedSong += packNumber(Math.ceil(song.duration), 3);

	// Grab track and notes
	const tracks = [];
	for (const rawTrack of song.tracks) {
		const track = {};

		// Track instrument
		if (rawTrack.isPercussion) {
			// Shift instrument number by 128 for percussions
			track.instrument = rawTrack.instrument + 128;
		} else {
			track.instrument = rawTrack.instrument;
		}
		track.isPercussion = rawTrack.isPercussion;

		// Track channel
		track.channel = rawTrack.channel + 1;

		// Track name
		track.name = rawTrack.name || "";

		// Track notes
		let offset = 0;
		const notes = [];
		for (const rawNote of rawTrack.notes) {
			const noteKey = rawNote.key;

			// Ignore notes that are not within the MIDI range
			// Also ignore notes with key = 127 to avoid notes type 1 being taken for a separator (0xFF).
			if (noteKey >= 0 && noteKey < 127) {
				// Get time and duration
				let noteTime = rawNote.time - offset;
				const noteDuration = Math.min(rawNote.duration, MAX_LONG_NOTE_DURATION);

				// Insert note spacers if needed
				let noteSpacer = '';
				while (noteTime > MAX_NOTE_TIME) {
					noteSpacer += packNumber(0xFF, 1); // 0xFF char
					noteTime -= MAX_NOTE_TIME;
					offset += MAX_NOTE_TIME;
				}

				// Calculate rounded time based on NOTE_TIME_FPS
				const timeFrames = Math.round(noteTime * NOTE_TIME_FPS);
				const roundedTime = timeFrames / NOTE_TIME_FPS;

				// Calculated rounded duration based on NOTE_DURATION_FPS
				const adjustedDuration = Math.max(0, noteDuration + noteTime - roundedTime);
				const durationFrames = Math.floor(adjustedDuration * NOTE_DURATION_FPS);

				// Determine if it's a long note or a short one
				const isLongNote = durationFrames > 0xFF && noteKey < 127; // Avoid long notes of the max 127 key to avoid confusion with a spacer
				const longNoteFlag = isLongNote ? 0x80 : 0x00;

				// Insert packed note: key (1), time (2), duration (1 or 2)
				notes.push(
					noteSpacer +
					packNumber(noteKey | longNoteFlag, 1) +
					packNumber(timeFrames, 2) +
					packNumber(durationFrames, isLongNote ? 2 : 1)
				);
			}
		}
		track.notes = notes;

		tracks.push(track);
	}

	// Number of tracks (1)
	if (tracks.length > 255) {
		throw "A song cannot have more than 255 tracks.";
	}
	packedSong += packNumber(tracks.length, 1);

	// Track data: instrument (1), channel (1), number of notes (2),
	for (const track of tracks) {
		if (track.notes.length > 65535) {
			throw "A track cannot have more than 65535 notes.";
		}

		packedSong += packNumber(track.instrument, 1);
		packedSong += packNumber(track.channel, 1);
		packedSong += packNumber(track.notes.length, 2);
	}

	// Note data
	for (const track of tracks) {
		packedSong += track.notes.join(''); // Notes are already packed
	};

	// Track names (2) + (title length in bytes)
	for (const track of tracks) {
		packedSong += packString(track.name);
	}

	return packedSong;
}