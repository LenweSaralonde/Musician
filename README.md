Musician
========
Listen and play medieval/celtic folk music that can be heard by the nearby players. For the first time in World of Warcraft, your character can litterally become a bard!

([Tuto en français ici](https://www.lenwe.info/guide-musician/))

How to listen to music
----------------------
All you need to do is install the addon. Nothing more is required.

To mute a player, right click on his/her name or portrait to open the menu then select **Mute**. Do the same to unmute. If you prefer, you can just stop the song being played.

Right click on the minimap button to enable or disable all the music from the addon.

How to play music
-----------------
Musician plays music files in MIDI format. MIDI files have a **.mid** or **.midi** extension and do not contain sound but a sequence of notes that can be played by music software and instruments.

You can find lots of MIDI files very easily on Google by searching for *MIDI* + *music genre/title* etc. I also made a [selection of cool music files](https://www.dropbox.com/sh/6ypecquora72sne/AADAS0HnHS142bhpMNurRfX8a?dl=0) you can try with the addon.

To play a song:

1. Open the [**MIDI converter**](https://www.lenwe.info/musician-midi-convert/) located at [lenwe.info/musician-midi-convert](https://www.lenwe.info/musician-midi-convert/) in your web browser. (You can also find the converter in the **Interface/AddOns/Musician/MidiConvert** folder.)
2. Drag and drop a **MIDI file**
3. Copy the generated music code by clicking the **Copy** button
4. Left click on the minimap button (or type `/music`) to open the main window
5. Click **Clear** then paste the music code in the edit window (*Ctrl+V* or *CMD+V* on Mac)
6. Click **Load** then wait for the song to load (may take ~1 minute)
7. Click **Play**

Tips
----
* You can preview the song at any moment prior to playing it for other players without loading time by clicking the **Preview** button. If another song is playing nearby, it will be muted for you only.
* If another player has Musician, it will be shown in his/her tooltip. Just hover the other players with your mouse cursor to see who can hear you !
* You can add lyrics by combining Musician with the [StoryTeller addon](https://www.lenwe.info/story-teller) !
* Load the next song while the current one is playing to reduce waiting time between songs.
* The radius for hearing the music is approximately 40 meters.
* Play songs that are relevant with your "band" composition. It's nonsense to play orchestral music with only two bards or heavy metal with traditional instruments ! 😃

Compose your own music
----------------------
You can compose music for Musician using any MIDI sequencer, even in your browser with this [free online sequencer](https://onlinesequencer.net/).

The 13 instruments available are:

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

The other instruments are mapped with the closest-sounding of the 13 instruments above (violin → fiddle, piano → dulcimer, guitar → lute etc.). The drum kits are replaced by a bodhrán (frame drum), a tambourine and a shaker. Check the mappings in [Musician.Constants.lua](https://github.com/LenweSaralonde/Musician/blob/master/core/Musician.Constants.lua#L265) for details.

Unfortunately, due to limitations of the WoW UI, velocity and controls (volume, padding, pitch bend, modulation...) are not supported. The polypohony is approximately 10 notes.

Limitations and known issues
----------------------------
This addon is still experimental. Here is a summary of the problems you may encounter:

* There is no support for velocity and modulation. This is actually not possible with the WoW UI.
* Music playing relies on the refresh rate of the screen so stuttering may occur on slower computers. Adjust yout settings to maintain a framerate above 30 FPS for good results.
* The polyphony is limited, some notes may drop if there are too many playing at the same time.
* Clipping may occur for some songs if you have all your volume settings maxed out. Just reduce in-game volume to avoid this.
* Loading may take a while for large files (about 1 minute).
* Play/Stop button may take some time to respond while loading a song.
* Avoid moving while loading a song since the position of your character cannot be updated.
