Musician
========
For the first time in World of Warcraft, your character can literally become a bard!

Play music for you and the other players, from MIDI files or live, using 18 instruments and 2 percussion sets from various styles: medieval, celtic, folk, tribal and heavy metal. 🤘

Quick links
-----------
* [Discord server](https://discord.gg/ypfpGxK) (EN/FR) for help, good music and more!
* Additional modules:
  * [MusicianList](https://musician.lenwe.io/list) — Save and load your songs in-game.
  * [MusicianMIDI](https://musician.lenwe.io/midi) — Play live music using your MIDI keyboard.
* [Wiki](https://github.com/LenweSaralonde/Musician/wiki) — Tips and tricks, FAQ and detailed documentation for gamers, developers and music producers.
* [Bug tracker](https://github.com/LenweSaralonde/Musician/issues) — Report issues
* [GitHub repo](https://github.com/LenweSaralonde/Musician) — Contribute to the project

Musician is also available for WoW Classic, be sure to install the right version of the add-on.

Un [Guide en français](https://www.lenwe.info/guide-musician/) est également disponible. 🇫🇷🥖🍷

tl;dr
-----
Left-click on the minimap button to open the main menu.

Type `/mus help` in the chat window to get the command list.

How to listen to music
----------------------
All you need is to have the add-on installed. Nothing more is required.

* Enable nameplates with **SHIFT+V** (or from the add-on options) to see cool animations on characters playing music and show a 🎵 next to the name of your fellow music addicts.
* To mute a player, right-click on his/her name or portrait to open the menu then select **Mute**. Do the same to unmute.
* You can also just stop the song being played by clicking the **[Stop]** hyperlink in the player's emote.
* Right click on the minimap button to enable or disable all the music from the add-on.

![Nameplate animations](./img/nameplates.gif)

How to play music
-----------------
Musician plays music files in **MIDI format**. MIDI files have a **.mid**, **.midi** or **.kar** extension and do not contain any sound like MP3s, but a sequence of notes. This is why a MIDI file sounds differently according to the software or musical instrument it's played on.

You can find millions of MIDI files very easily by searching for *MIDI* + *music genre/title/etc.* on Google. I also made a [selection of cool music files](https://www.dropbox.com/sh/6ypecquora72sne/AADAS0HnHS142bhpMNurRfX8a?dl=0) you can try with the add-on.

### How to play a song

1. Open the [**MIDI import tool**](https://musician.lenwe.io/import/) located at [musician.lenwe.io/import](https://musician.lenwe.io/import/) in your web browser. (You can also find the import tool in the **Interface/AddOns/Musician/MidiConvert** folder.)
2. Drag and drop a **MIDI file**.
3. Copy the generated music code by clicking the **Copy** button.
4. Back in WoW, left-click on the minimap button to open the main menu then choose **Import and play a song**  to open the main window (or type `/music`).
5. Click the **Select all** button then paste the music code in the edit window (*Ctrl+V* or *CMD+V* on Mac).
6. Click **Play**.

![Main window](./img/main-window.png)

### Save and load songs in game
Songs can be saved and loaded back in game using the optional add-on [MusicianList](https://musician.lenwe.io/musicianlist).

### Play as a band
Songs can be played in sync as a band, in which each member is playing a different part.

To allow synchronized play, all band members should be grouped in the same party or raid.

1. Load the same song as the other members of the band from MIDI of [from the list](https://musician.lenwe.io/musicianlist).
2. Open the **Song Editor** then check **Solo** for the tracks you want to play with your character. Adjust other track settings as you like.
3. Click the **Play as a band** button ![Play as band button](./img/band-play-button-song.png) when you're done (the green LED starts blinking).
4. When every member is ready, the band leader clicks the **Play** button for synchronized start (the green LED turns on).
5. Song stops playing if the band leader clicks the **Stop** button.

Remarks:

* The song should be loaded from the same MIDI file to work.
* Mouse over the **Play as a band** button to check which members of the band are ready.
* Each band member can do all the changes they want in the Song Editor, except changing the start and end points that would result in being out of sync.
* Keep in mind that the overall polyphony is limited and is shared among all the members of the band.

Play live
---------
Live Mode literally turns your computer keyboard into a piano.

Click **Open keyboard** in the main menu or type `/mus live` to open the live keyboard.

### Configure the keyboard
Before using the keyboard for the first time, you have configure it to determine its physical layout.

This process is straightforward and takes approximately 30 seconds to complete, just follow the on-screen instructions.

![Configuration example for the US keyboard](./img/configure-keyboard-us.png)

### The live keyboard
The live keyboard consists in two layers, **Upper** and **Lower**, respectively the two first and two last rows of your keyboard (or the right and left side, depending on the layout used). Each layer has its own instrument setting so 2 different instruments can be played at the same time or the same instrument can be set to both layers to take advantage of the full keyboard.

Various keyboard layouts are available, including simplified ones with limited notes but a wider range of keys.

The spacebar acts like the sustain pedal of a piano.

In **Live Mode**, the other players hear you playing while in **Solo Mode**, you play for yourself. In Live Mode, keep in mind that if you hear the sound playing instantly at the press of the key, the other players will hear it after a slight delay of approximately 2 seconds.

The keyboard settings can be saved in 12 program slots, accessible using the 12 Function keys:
* Press the **Function key** to load a program.
* Press **Ctrl** (or **Shift** on Mac) **+** the **Function key** to save the current settings in a program.
* Press **Delete +** the **Function key** to erase a program.

![The live keyboard](./img/live-keyboard.png)

### Play as a band
It's possible to play as a band in Live Mode. All the members of the band should be grouped in the same party or raid.

Click the **Play live as a band** button ![Play live as a band button](./img/band-play-button-live.png) on the live keyboard window to turn on the synchronization. In counterpart, this may result in some latency so you won't be able to play fast paced songs in this mode.

Use the **Solo Mode** if you need to do some adjustments you don't want the other members of the band to hear.

Enable nameplates to see who is playing what.

### Play with a MIDI keyboard

There is no support for MIDI keyboards in World of Warcraft. However, it's possible to emulate keystrokes with a MIDI keyboard using third party software. Check out the [Musician MIDI add-on](https://musician.lenwe.io/midi) to learn how to achieve this.

Song editor
-----------
Some basic modifications can be made to the imported song in the song editor, which is accessible from the **Edit** button or the main menu:

* Set start and end points, to use a part of the song
* Mute and solo tracks
* Change track instruments
* Transpose tracks

The song editor also shows some information about the tracks (MIDI instrument, start and end points, number of notes...) and the activity while the song is playing.

You can still change the track settings of the song currently playing by clicking the **Synchronize track settings** button ![Synchronize track settings button](./img/synchronize-track-settings-button.png) as long as you have the same song loaded in the editor.

![Song editor](./img/song-editor.png)

Cross-faction play
------------------
Cross-faction (and cross-realm) music can be achieved through the [Cross RP add-on](https://www.curseforge.com/wow/addons/cross-rp) by Tammya-MoonGuard.

This add-on is very straightforward, just install it and it works!

Cross RP relies on a peer to peer network established by the players who run it so the faction/realm you want to play with may not be always reachable. Feel free to encourage other players to install Cross RP and expand the network!

You can see what realms and factions you're connected to in Musician's options or by mousing over the Cross RP minimap button.

Cross-faction play is not available on WoW Classic.

![Cross-faction play with Cross RP](./img/cross-rp.png)

Integration with role-playing add-ons
-------------------------------------
Musician integrates with role-playing add-ons [Total RP](https://www.curseforge.com/wow/addons/total-rp-3) and [MyRolePlay](https://www.curseforge.com/wow/addons/my-role-play) to benefit from some of their features, such as roleplay character names and tooltips.

[Total RP](https://www.curseforge.com/wow/addons/total-rp-3)'s map scan feature shows players who also have Musician with a 🎵 icon. The icon blinks for players who are currently playing music.

![Total RP map scan](./img/trp-map-scan.png)

Tips
----
* You can preview the song at any moment prior to playing it for other players by clicking the **Preview** button or using the song editor. If another song is playing nearby, it will be muted for you only.
* If another player has Musician, it will be shown in his/her tooltip. Just hover the other players with your mouse cursor to see who can hear you!
* You can add lyrics by combining Musician with the [StoryTeller add-on](https://musician.lenwe.io/storyteller)!
* Load the next song while the current one is playing to reduce waiting time between songs.
* The radius for hearing the music is approximately 40 meters.
* Play songs that are relevant with your "band" composition. It's nonsense to play orchestral music with only two bards ! 😃 However you can still role-play as if your character owns a kind of gnomish *Music-o-Matic* jukebox machine that is capable of reproducing a whole band.
* A text emote is shown to the players who don't have Musician when you play a song. You can disable this emote in the add-on options.
* Nameplates animations and icons are compatible with the most popular nameplate add-ons (KuiNameplates, Plater, ElvUI...).

Compose your own music
----------------------
You can compose music for Musician using any MIDI sequencer such as [MidiEditor](https://www.midieditor.org/) (free and cross-platform).

The 18 melodic instruments available are:

* Lute (24 Acoustic guitar)
* Recorder (74)
* Celtic harp (46)
* Hammered dulcimer (15)
* Bagpipe (109)
* Accordion (22)
* Fiddle (110)
* Viola da gamba (ancient cello) (42)
* Female voice (53 Voice Oohs)
* Male voice (52 Choir Aahs)
* Trumpet (56)
* Sackbut (ancient trombone) (57)
* War horn (shofar) (60 French horn)
* Clarinet (71)
* Bassoon (70)
* Metal guitar (29)
* Clean Guitar (27)
* Bass guitar (33 Fingered bass)

Percussions:
* Traditional percussion set (drum kit 0)
* Standard drum set (drumm kit 16)
* War drums (47 Timpani)
* Woodblock (115)
* Tambourine shake (119)

The other instruments are mapped to the closest-sounding instrument among the ones available (violin → fiddle, piano → dulcimer, guitar → lute etc.).

The drum kits are replaced by traditional percussions such as a bodhrán (frame drum), a tambourine and a shaker. A standard drum kit is also available for heavy metal songs.

Check the full mapping in [Musician.MidiMapping.lua](https://github.com/LenweSaralonde/Musician/blob/master/constants/Musician.MidiMapping.lua) for details.

Unfortunately, due to limitations of the WoW UI, velocity and controls (volume, padding, pitch bend, modulation...) are not supported. The polypohony is roughly 12 notes.

Limitations and known issues
----------------------------
Here is a summary of the problems you may encounter:

* There is no support for velocity and modulation. This is actually not possible with the WoW UI.
* Wait for the preloading process to complete before playing to ensure good conditions.
* Sound latency may be experienced with the live keyboard on Windows, depending on your sound card model and drivers.
* Music playing relies on the refresh rate of the screen so stuttering may occur on slower computers. Adjust your settings to maintain a framerate above 30 FPS for good results.
* The polyphony is limited, some notes may drop if there are too many playing at the same time.
* Songs having an overly high note rate may stutter.
* Clipping may occur for some songs if you have all your volume settings maxed out. Just reduce in-game volume to avoid this.
* Play as a band features do not work with trial accounts in raid mode.

Support
-------
If you like Musician and want to support its development, you can [become a patron](https://musician.lenwe.io/patreon) or just [make a donation](https://musician.lenwe.io/paypal).

Special thanks to the supporters of the project:

Grayson Blackclaw / ChanceTheCheetah / Selena - WRA / Crisellianna / Naelyel