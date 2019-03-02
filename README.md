

Musician
========
Hear and play music with nearby players. For the first time in World of Warcraft, your character can litterally become a bard!

Join our [Discord server](https://discord.gg/ypfpGxK) (EN/FR) and our [Battle.net group](https://blizzard.com/invite/X2Gy7ztwX7) for help, bug reports, good music and more!

Download the optional module [MusicianList](https://www.lenwe.info/musicianlist) to add in-game loading and saving features.

Un [Guide en français](https://www.lenwe.info/guide-musician/) est également disponible. 🇫🇷🥖🍷

tl;dr
-----
Left-click on the minimap button to open the main menu.

Type `/mus help` in the chat window to get the command list.

How to listen to music
----------------------
All you need is to have the addon installed. Nothing more is required.

* To mute a player, right-click on his/her name or portrait to open the menu then select **Mute**. Do the same to unmute.
* You can also just stop the song being played by clicking the **[Stop]** hyperlink in the player's emote.
* Right click on the minimap button to enable or disable all the music from the addon.

How to play music
-----------------
Musician plays music files in **MIDI format**. MIDI files have a **.mid**, **.midi** or **.kar** extension and do not contain any sound like MP3s, but a sequence of notes. This is why a MIDI file sounds differently according to the software or musical instrument it's played on.

You can find millions of MIDI files very easily by searching for *MIDI* + *music genre/title/etc.* on Google. I also made a [selection of cool music files](https://www.dropbox.com/sh/6ypecquora72sne/AADAS0HnHS142bhpMNurRfX8a?dl=0) you can try with the addon.

### How to play a song:

1. Open the [**MIDI converter**](https://www.lenwe.info/musician-midi-convert/) located at [lenwe.info/musician-midi-convert](https://www.lenwe.info/musician-midi-convert/) in your web browser. (You can also find the converter in the **Interface/AddOns/Musician/MidiConvert** folder.)
2. Drag and drop a **MIDI file**.
3. Copy the generated music code by clicking the **Copy** button.
4. Back in WoW, left-click on the minimap button to open the main menu then choose **Import and play a song**  to open the main window (or type `/music`).
5. Click the **Select all** button then paste the music code in the edit window (*Ctrl+V* or *CMD+V* on Mac).
6. Click **Play**.

### Save and load songs in game
Songs can be saved and loaded back in game using the optional addon [MusicianList](https://www.lenwe.info/musicianlist).

Play live
---------
Live Mode literally turns your computer keyboard into a piano.

Click **Open keyboard** in the main menu or type `/mus live` to open the live keyboard.

### Configure the keyboard
Before using the keyboard for the first time, you have configure it to determine its physical layout.

This process is straightforward and takes approximately 30 seconds to complete, just follow the on-screen instructions.

### The live keyboard
The live keyboard consists in two layers, **Upper** and **Lower**, respectively the two first and two last rows of your keyboard (or the right and left side, depending on the layout used). Each layer has its own instrument setting so 2 different instruments can be played at the same time or the same instrument can be set to both layers to take advantage of the full keyboard.

Various keyboard layouts are available, including simplified ones with limited notes but a wider range of keys.

In **Live Mode**, the other players hear you playing while in **Solo Mode**, you play for yourself. In Live Mode, keep in mind that if you hear the sound playing instantly at the press of the key, the other players will hear it after a slight delay of approximately 2 seconds.

The keyboard settings can be saved in 12 program slots, accessible using the 12 Function keys:
* Press the **Function key** to load a program.
* Press **Ctrl** (or **Shift** on Mac) **+** the **Function key** to save the current settings in a program.
* Press **Delete +** the **Function key** to erase a program.

Song editor
-----------
Some basic modifications can be made to the imported song in the song editor, which is accessible from the **Edit** button or the main menu:

* Set start and end points, to use a part of the song
* Mute and solo tracks
* Change track instruments
* Transpose tracks

The song editor also shows some information about the tracks (MIDI instrument, start and end points, number of notes...) and the activity while the song is playing.

Tips
----
* You can preview the song at any moment prior to playing it for other players by clicking the **Preview** button or using the song editor. If another song is playing nearby, it will be muted for you only.
* If another player has Musician, it will be shown in his/her tooltip. Just hover the other players with your mouse cursor to see who can hear you!
* You can add lyrics by combining Musician with the [StoryTeller addon](https://www.lenwe.info/story-teller)!
* Load the next song while the current one is playing to reduce waiting time between songs.
* The radius for hearing the music is approximately 40 meters.
* Play songs that are relevant with your "band" composition. It's nonsense to play orchestral music with only two bards ! 😃 However you can still roleplay as if your character owns a kind of gnomish *Music-o-Matic* machine that is capable of reproducing a whole band.

Compose your own music
----------------------
You can compose music for Musician using any MIDI sequencer, even in your browser with this [free online sequencer](https://onlinesequencer.net/).

The 16 instruments available are:

* Bagpipe (109)
* Bassoon (70)
* Cello (42)
* Clarinet (71)
* Dulcimer (15)
* Male voice (52 Choir Aahs)
* Female voice (53 Voice Oohs)
* Fiddle (110)
* Harp (46)
* Lute (24 Acoustic guitar)
* Recorder (74)
* Trombone (57)
* Trumpet (56)

And also:

* Distorsion guitar (29)
* Clean Guitar (27)
* Bass guitar (33 Fingered bass)

The other instruments are mapped to the closest-sounding instrument among the 16 available (violin → fiddle, piano → dulcimer, guitar → lute etc.).

The drum kits are replaced by traditional percussions such as a bodhrán (frame drum), a tambourine and a shaker. A standard drum kit is also available for heavy metal songs.

Check the full mapping in [Musician.MidiMapping.lua](https://github.com/LenweSaralonde/Musician/blob/master/constants/Musician.MidiMapping.lua) for details.

Unfortunately, due to limitations of the WoW UI, velocity and controls (volume, padding, pitch bend, modulation...) are not supported. The polypohony is roughly 12 notes.

Limitations and known issues
----------------------------
This addon is still experimental. Here is a summary of the problems you may encounter:

* There is no support for velocity and modulation. This is actually not possible with the WoW UI.
* It is **NOT possible to play live with other players** since the other players do not hear what you play instantly but only after 1 or 2 seconds.
* Sound latency may be experienced with the live keyboard on Windows, depending on your sound card model and drivers.
* Wait for the preloading process to complete before playing to ensure good conditions.
* Music playing relies on the refresh rate of the screen so stuttering may occur on slower computers. Adjust your settings to maintain a framerate above 30 FPS for good results.
* The polyphony is limited, some notes may drop if there are too many playing at the same time.
* Songs having an overly high note rate may stutter.
* Clipping may occur for some songs if you have all your volume settings maxed out. Just reduce in-game volume to avoid this.
