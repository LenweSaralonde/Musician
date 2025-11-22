--- Global Events
-- @module Musician.Events

--- Events
Musician.Events = {}

--- Fired at every screen refresh. OnUpdate functions can be attached to this event without needing to create a new frame.
-- @field Musician.Events.Frame
-- @param elapsed (number) Time in seconds since last frame
Musician.Events.Frame = "MusicianFrame"

--- Fired when the player registry is ready to use.
-- @field Musician.Events.RegistryReady
Musician.Events.RegistryReady = "MusicianRegistryReady"

--- Fired when the status of the communication channel has changed
-- @field Musician.Events.CommChannelUpdate
-- @param isConnected (boolean) True when connected to the channel
Musician.Events.CommChannelUpdate = "MusicianCommChannelUpdate"

--- Fired when a communication action has been initiated
-- @field Musician.Events.CommSendAction
-- @param action (string) Action name, from Musician.Comm.action
Musician.Events.CommSendAction = "MusicianCommSendAction"

--- Fired when a communication action has been completed
-- @field Musician.Events.CommSendActionComplete
-- @param action (string) Action name, from Musician.Comm.action
Musician.Events.CommSendActionComplete = "MusicianCommSendActionComplete"

--- Fired when a song starts playing
-- @field Musician.Events.SongPlay
-- @param song (Musician.Song)
Musician.Events.SongPlay = "MusicianSongPlay"

--- Fired when a song stops playing
-- @field Musician.Events.SongStop
-- @param song (Musician.Song)
Musician.Events.SongStop = "MusicianSongStop"

--- Fired when the global mute state has changed
-- @field Musician.Events.GlobalMute
-- @param isMuted (boolean)
Musician.Events.GlobalMute = "MusicianGlobalMute"

--- Fired when a song chunk has been received
-- @field Musician.Events.SongChunk
-- @param sender (string) Player name
-- @param mode (number) Song mode (Musician.Song.MODE_DURATION or Musician.Song.MODE_LIVE)
-- @param songId (number)
-- @param chunkDuration (number) in seconds
-- @param playtimeLeft (number) in seconds
-- @param posY (number) Player world position Y
-- @param posX (number) Player world position X
-- @param posZ (number) Player world position Z
-- @param instanceID (number) Player instance ID
-- @param guid (string) Player GUID
Musician.Events.SongChunk = "MusicianSongChunk"

--- Fired when a song starts streaming
-- @field Musician.Events.StreamStart
-- @param song (Musician.Song)
Musician.Events.StreamStart = "MusicianStreamStart"

--- Fired when a song stops streaming
-- @field Musician.Events.StreamStop
-- @param song (Musician.Song)
Musician.Events.StreamStop = "MusicianStreamStop"

--- Fired when the song cursor position has changed
-- @field Musician.Events.SongCursor
-- @param song (Musician.Song)
Musician.Events.SongCursor = "MusicianSongCursor"

--- Fired when the instrument of a song track has changed
-- @field Musician.Events.SongInstrumentChange
-- @param song (Musician.Song)
-- @param track (table) Track object of the song
-- @param midiId (number) MIDI id of the instrument
Musician.Events.SongInstrumentChange = "MusicianSongInstrumentChange"

--- Fired when the transposition of a song track has changed
-- @field Musician.Events.SongTransposeChange
-- @param song (Musician.Song)
-- @param track (table) Track object of the song
-- @param semitones (number) Transposition level, in semitones
Musician.Events.SongTransposeChange = "MusicianSongTransposeChange"

--- Fired when the muted flag of a song track has changed
-- @field Musician.Events.SongMutedChange
-- @param song (Musician.Song)
-- @param track (table) Track object of the song
-- @param isMuted (boolean) Muted flag
Musician.Events.SongMutedChange = "MusicianSongMutedChange"

--- Fired when the solo flag of a song track has changed
-- @field Musician.Events.SongSoloChange
-- @param song (Musician.Song)
-- @param track (table) Track object of the song
-- @param isSolo (boolean) Solo flag
Musician.Events.SongSoloChange = "MusicianSongSoloChange"

--- Fired when the audible flag of a song track has changed
-- @field Musician.Events.SongAudibleChange
-- @param song (Musician.Song)
-- @param track (table) Track object of the song
-- @param isAudible (boolean) Audible flag
Musician.Events.SongAudibleChange = "MusicianSongAudibleChange"

--- Fired when the accent flag of a song track has changed
-- @field Musician.Events.SongAccentChange
-- @param song (Musician.Song)
-- @param track (table) Track object of the song
-- @param isAccent (boolean) Accent flag
Musician.Events.SongAccentChange = "MusicianSongAccentChange"

--- Fired when the song crop from point has changed
-- @field Musician.Events.SongCropFromChange
-- @param song (Musician.Song)
-- @param cropFrom (number) Crop from point
Musician.Events.SongCropFromChange = "MusicianSongCropFromChange"

--- Fired when the song crop to point has changed
-- @field Musician.Events.SongCropToChange
-- @param song (Musician.Song)
-- @param cropTo (number) Crop to point
Musician.Events.SongCropToChange = "MusicianSongCropToChange"

--- Fired when a song note starts playing and is audible
-- @field Musician.Events.NoteOn
-- @param song (Musician.Song)
-- @param track (table) Track object of the song
-- @param key (number) MIDI key of the note
Musician.Events.NoteOn = "MusicianNoteOn"

--- Fired when a song note stops playing
-- @field Musician.Events.NoteOff
-- @param song (Musician.Song)
-- @param track (table) Track object of the song
-- @param key (number) MIDI key of the note
Musician.Events.NoteOff = "MusicianNoteOff"

--- Fired when a song note starts playing, even when it's not audible (track muted, note dropped due to low polyphony etc.)
-- Used for visual feedback
-- @field Musician.Events.VisualNoteOn
-- @param song (Musician.Song)
-- @param track (table) Track object of the song
-- @param key (number) MIDI key of the note
-- @param play (boolean) true when the note is audible
Musician.Events.VisualNoteOn = "MusicianVisualNoteOn"

--- Fired when a song note stops playing, even when it was not audible (track muted, note dropped due to low polyphony etc.)
-- Used for visual feedback
-- @field Musician.Events.VisualNoteOff
-- @param song (Musician.Song)
-- @param track (table) Track object of the song
-- @param key (number) MIDI key of the note
Musician.Events.VisualNoteOff = "MusicianVisualNoteOff"

--- Fired when a live note on event is being sent in live mode
-- @field Musician.Events.LiveNoteOn
-- @param key (number) MIDI key of the note
-- @param layer (number) Keyboard layer from Musician.KEYBOARD_LAYER
-- @param instrumentData (table) Instrument data from Musician.INSTRUMENTS
-- @param isChordNote (boolean) true when note is a power chord
-- @param source (table) UI component triggering the note
Musician.Events.LiveNoteOn = "MusicianLiveNoteOn"

--- Fired when a live note off event is being sent in live mode
-- @field Musician.Events.LiveNoteOff
-- @param key (number) MIDI key of the note
-- @param layer (number) Keyboard layer from Musician.KEYBOARD_LAYER
-- @param isChordNote (boolean) true when note is a power chord
-- @param source (table) UI component triggering the note
Musician.Events.LiveNoteOff = "MusicianLiveNoteOff"

--- Fired when the live mode state is changed, by user's action or any other event that affects the live mode.
-- @field Musician.Events.LiveModeChange
Musician.Events.LiveModeChange = "MusicianLiveModeChange"

--- Fired when one or more note have been dropped due to a lack of polyphony during one frame while playing
-- @field Musician.Events.NoteDropped
-- @param song (Musician.Song)
-- @param totalDrops (number) Total dropped notes since the song has been created
-- @param drops (number) Number of notes dropped during the same frame
Musician.Events.NoteDropped = "MusicianNoteDropped"

--- Fired when the preloading process is making progress
-- @field Musician.Events.PreloadingProgress
-- @param progress (number) Progression between 0 and 1
Musician.Events.PreloadingProgress = "MusicianPreloadingProgress"

--- Fired when the preloading process is complete and all samples are now in disk cache
-- @field Musician.Events.PreloadingComplete
Musician.Events.PreloadingComplete = "MusicianPreloadingComplete"

--- Fired when the quick preloading process is complete and the loading screen has been dismissed
-- @field Musician.Events.QuickPreloadingComplete
Musician.Events.QuickPreloadingComplete = "MusicianQuickPreloadingComplete"

--- Fired when the song importing process is starting
-- @field Musician.Events.SongImportStart
-- @param song (Musician.Song)
Musician.Events.SongImportStart = "MusicianSongImportStart"

--- Fired when the song importing process is making progress
-- @field Musician.Events.SongImportProgress
-- @param song (Musician.Song)
-- @param progress (number) Progression between 0 and 1
Musician.Events.SongImportProgress = "MusicianSongImportProgress"

--- Fired when the song importing process is complete, regardless if it failed or not
-- @field Musician.Events.SongImportComplete
-- @param song (Musician.Song)
Musician.Events.SongImportComplete = "MusicianSongImportComplete"

--- Fired when the song importing process is complete successfully
-- @field Musician.Events.SongImportSuccessful
-- @param song (Musician.Song)
Musician.Events.SongImportSuccessful = "MusicianSongImportSuccessful"

--- Fired when the song importing process failed
-- @field Musician.Events.SongImportFailed
-- @param song (Musician.Song)
Musician.Events.SongImportFailed = "MusicianSongImportFailed"

--- Fired when the song exporting process is starting
-- @field Musician.Events.SongExportStart
-- @param song (Musician.Song)
Musician.Events.SongExportStart = "MusicianSongExportStart"

--- Fired when the song exporting process is making progress
-- @field Musician.Events.SongExportProgress
-- @param song (Musician.Song)
-- @param progress (number) Progression between 0 and 1
Musician.Events.SongExportProgress = "MusicianSongExportProgress"

--- Fired when the song exporting process is complete, regardless if it failed or not
-- @field Musician.Events.SongExportComplete
-- @param song (Musician.Song)
Musician.Events.SongExportComplete = "MusicianSongExportComplete"

--- Fired when the source song Musician.sourceSong has been successfully loaded
-- @field Musician.Events.SourceSongLoaded
-- @param song (Musician.Song)
Musician.Events.SourceSongLoaded = "MusicianSourceSongLoaded"

--- Fired when a "promo" emote has been received and filtered in the chat
-- @field Musician.Events.PromoEmote
-- @param isPromoEmoteSuccessful (boolean) true if the music can be heard
-- @param msg (string)
-- @param fullPlayerName (string)
-- @param ... (string) Other arguments provided by ChatFrameUtil.AddMessageEventFilter() (languageName, channelName...)
Musician.Events.PromoEmote = "MusicianPromoEmote"

--- Fired when bandwidth limit indicator has changed while streaming a song
-- @field Musician.Events.Bandwidth
-- @param bandwidth (number) Equals to 0 when < Musician.BANDWIDTH_LIMIT_MIN and > 1 when exceeding Musician.BANDWIDTH_LIMIT_MAX
Musician.Events.Bandwidth = "MusicianBandwidth"

--- Fired when a player of the party or raid starts playing a song as a band
-- @field Musician.Events.BandPlay
-- @param sender (string) Player name
-- @param songCrc32 (number) The song CRC32 that will play
Musician.Events.BandPlay = "MusicianBandPlay"

--- Fired when a player of the party or raid stops playing a song as a band
-- @field Musician.Events.BandStop
-- @param sender (string) Player name
-- @param songCrc32 (number) The song CRC32 that will be stopped
Musician.Events.BandStop = "MusicianBandStop"

--- Fired when a player of the party or raid is ready (or no longer ready) for band play
-- @field Musician.Events.BandPlayReady
-- @param player (string) Player name
-- @param songCrc32 (number) The song CRC32 the player has loaded
-- @param isReady (boolean) Player is ready when true
-- @param eventPrefix (string) Message prefix from Musician.Comm.event
Musician.Events.BandPlayReady = "MusicianBandPlayReady"

--- Fired every time the list of players ready for band play should be updated
-- @field Musician.Events.BandReadyPlayersUpdated
Musician.Events.BandReadyPlayersUpdated = "MusicianBandReadyPlayersUpdated"

--- Fired when a player of the party or raid is synchronized (or no longer synchronized) for band play in live mode
-- @field Musician.Events.LiveBandSync
-- @param player (string) Player name
-- @param isSynced (boolean)
Musician.Events.LiveBandSync = "MusicianLiveBandSync"

--- Fired when the song reception process is starting
-- @field Musician.Events.SongReceiveStart
-- @param sender (string)
-- @param[opt] context (table) Reference to the module that initiated the song request.
Musician.Events.SongReceiveStart = "MusicianSongReceiveStart"

--- Fired when the song reception process is making progress
-- @field Musician.Events.SongReceiveProgress
-- @param sender (string)
-- @param progress (number) Progression between 0 and 1
-- @param[opt] context (table) Reference to the module that initiated the song request.
Musician.Events.SongReceiveProgress = "MusicianSongReceiveProgress"

--- Fired when the song reception process is complete, regardless if it failed or not
-- @field Musician.Events.SongReceiveComplete
-- @param sender (string)
-- @param[opt] context (table) Reference to the module that initiated the song request.
Musician.Events.SongReceiveComplete = "MusicianSongReceiveComplete"

--- Fired when the song reception process has been canceled
-- @field Musician.Events.SongReceiveCanceled
-- @param sender (string)
-- @param[opt] context (table) Reference to the module that initiated the song request.
Musician.Events.SongReceiveCanceled = "MusicianSongReceiveCanceled"

--- Fired when the song reception process is complete successfully
-- @field Musician.Events.SongReceiveSuccessful
-- @param sender (string)
-- @param songData (string)
-- @param[opt] song (Musician.Song)
-- @param[opt] context (table) Reference to the module that initiated the song request.
Musician.Events.SongReceiveSuccessful = "MusicianSongReceiveSuccessful"

--- Fired when the song reception process failed
-- @field Musician.Events.SongReceiveFailed
-- @param sender (string)
-- @param reason (string)
-- @param title (string)
-- @param[opt] context (table) Reference to the module that initiated the song request.
Musician.Events.SongReceiveFailed = "MusicianSongReceiveFailed"

--- Fired when the user clicks on a song link
-- @field Musician.Events.SongLink
-- @param title (string)
-- @param playerName (string)
Musician.Events.SongLink = "MusicianSongLink"