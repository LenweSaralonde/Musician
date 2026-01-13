Musician
========
For the first time in World of Warcraft, your character can literally become a bard!

Play music for you and the other players, from MIDI files or live, using 22 instruments and 2 percussion sets from various styles: medieval, celtic, folk, tribal and heavy metal. 🤘

Quick links
-----------
* 💬 [Discord server](https://discord.gg/ypfpGxK) (EN/FR) for help, good music and more!
* 🔌 Additional modules:
  * 🎷 [Musician: Extended](https://musician.lenwe.io/extended) — Add even more instruments to Musician.
  * 📜 [Musician List](https://musician.lenwe.io/list) — Save and load your songs in-game.
  * 🎹 [Musician MIDI](https://musician.lenwe.io/midi) — Play live music using your MIDI keyboard.
* 📖 [Wiki](https://github.com/LenweSaralonde/Musician/wiki) — Tips and tricks, FAQ and detailed documentation for gamers, developers and music producers.
* 🐞 [Bug tracker](https://github.com/LenweSaralonde/Musician/issues) — Report issues
* 👨‍💻 [GitHub repo](https://github.com/LenweSaralonde/Musician) — Contribute to the project

Un [Guide en français](https://www.lenwe.info/guide-musician/) est également disponible. 🇫🇷🥖🍷

tl;dr
-----
Left-click on the minimap button to open the main menu.

Type `/mus help` in the chat window to get the command list.

How to listen to music
----------------------
All you need is to have the add-on installed. Nothing more is required.

* Enable nameplates with **SHIFT+V** (or from the add-on options) to see cool animations on characters playing music and show a 🎵 next to the name of your fellow music addicts.
* To mute a player, right-click on their name or portrait to open the menu then select **Mute**. Do the same to unmute.
* You can also just stop the song being played by clicking the **[Stop]** hyperlink in the player's emote.
* Right click on the minimap button to enable or disable all the music from the add-on.
* The characters currently playing music can be shown on the world map and the minimap.

![Nameplate animations](https://raw.githubusercontent.com/LenweSaralonde/Musician/master/img/nameplates.gif)

How to play music
-----------------
Musician plays music files in **MIDI format**. MIDI files have a **.mid**, **.midi** or **.kar** extension and do not contain any sound like MP3s, but a sequence of notes. This is why a MIDI file sounds differently according to the software or musical instrument it's played on.

💡 You can find millions of MIDI files very easily by searching for *MIDI* + *music genre/title/etc.* on Google. I also made a [selection of cool music files](https://www.dropbox.com/sh/6ypecquora72sne/AADAS0HnHS142bhpMNurRfX8a?dl=0) you can try with the add-on.

⚠️ **Don't try to convert audio files such as MP3s or YouTube videos into MIDI**, the result will be disappointing. This is a tedious work that can only be done manually by experienced musicians.

### How to play a song

1. Open the [**MIDI import tool**](https://musician.lenwe.io/import/) located at [musician.lenwe.io/import](https://musician.lenwe.io/import/) in your web browser. (You can also find the import tool in the **Interface/AddOns/Musician/MidiConvert** folder.)
2. Drag and drop a **MIDI file**.
3. Copy the generated music code by clicking the **Copy** button.
4. Back in WoW, left-click on the minimap button to open the main menu then choose **Import and play a song**  to open the main window (or type `/music`).
5. Click the **Select all** button then paste the music code in the edit window (*Ctrl+V* or *CMD+V* on Mac).
6. Click **Play**.

![Main window](https://raw.githubusercontent.com/LenweSaralonde/Musician/master/img/main-window.png)

### Save and load songs in game
Songs can be saved and loaded back in game using the optional add-on [MusicianList](https://musician.lenwe.io/musicianlist).

### Play as a band
Songs can be played in sync as a band, in which each member is playing a different part.

To allow synchronized play, all band members should be grouped in the same party or raid and have the same song loaded into Musician.

Use the **Link**/**Export** button ![Link button](https://raw.githubusercontent.com/LenweSaralonde/Musician/master/img/link-button.png) to share songs with your band members.

1. Load the same song as the other members of the band from MIDI, [from the list](https://musician.lenwe.io/musicianlist) or from a song chat link.
2. Open the **Song Editor** then check **Solo** for the tracks you want to play with your character. Adjust other track settings as you like.
3. Click the **Play as a band** button ![Play as band button](https://raw.githubusercontent.com/LenweSaralonde/Musician/master/img/band-play-button-song.png) when you're done (the green LED starts blinking).
4. When every member is ready, the band leader clicks the **Play** button for synchronized start (the green LED turns on).
5. Song stops playing if the band leader clicks the **Stop** button.

Remarks:

* Mouse over the **Play as a band** button to check which members of the band are ready.
* Each band member can do all the changes they want in the Song Editor, except changing the start and end points that would result in being out of sync.
* Keep in mind that the overall polyphony can be limited and is shared among all the members of the band.

Play live
---------
Live Mode literally turns your computer keyboard into a piano.

Click **Open keyboard** in the main menu or type `/mus live` to open the live keyboard.

### Configure the keyboard
Before using the keyboard for the first time, you have configure it to determine its physical layout.

This process is straightforward and takes approximately 30 seconds to complete, just follow the on-screen instructions.

![Configuration example for the US keyboard](https://raw.githubusercontent.com/LenweSaralonde/Musician/master/img/configure-keyboard-us.png)

### The live keyboard
The live keyboard consists in two layers, **Upper** and **Lower**, respectively the two first and two last rows of your keyboard (or the right and left side, depending on the layout used). Each layer has its own instrument setting so 2 different instruments can be played at the same time or the same instrument can be set to both layers to take advantage of the full keyboard.

Various keyboard layouts are available, including simplified ones with limited notes but a wider range of keys.

The space bar acts like the sustain pedal of a piano.

In **Live Mode**, the other players hear you playing while in **Solo Mode**, you play for yourself. In Live Mode, keep in mind that if you hear the sound playing instantly at the press of the key, the other players will hear it after a slight delay of approximately 2 seconds.

The keyboard settings can be saved in 12 program slots, accessible using the 12 Function keys:
* Press the **Function key** to load a program.
* Press **Ctrl** (or **Shift** on Mac) **+** the **Function key** to save the current settings in a program.
* Press **Delete +** the **Function key** to erase a program.

![The live keyboard](https://raw.githubusercontent.com/LenweSaralonde/Musician/master/img/live-keyboard.png)

### Play as a band
It's possible to play as a band in Live Mode. All the members of the band should be grouped in the same party or raid.

Click the **Play live as a band** button ![Play live as a band button](https://raw.githubusercontent.com/LenweSaralonde/Musician/master/img/band-play-button-live.png) on the live keyboard window to turn on the synchronization. In counterpart, this may result in some latency so you won't be able to play fast paced songs in this mode.

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
* Accent tracks, to make them louder by doubling the notes

The song editor also shows some information about the tracks (MIDI instrument, start and end points, number of notes…) and the activity while the song is playing. Click the track start or end point time code to reach it in the timeline.

You can still change the track settings of the song currently playing by clicking the **Synchronize track settings** button ![Synchronize track settings button](https://raw.githubusercontent.com/LenweSaralonde/Musician/master/img/synchronize-track-settings-button.png) as long as you have the same song loaded in the editor.

![Song editor](https://raw.githubusercontent.com/LenweSaralonde/Musician/master/img/song-editor.png)

Share your songs with the other players
---------------------------------------
Songs can be shared with other players as links to be posted into the chat. Click the **Link** or **Export** button ![Link button](https://raw.githubusercontent.com/LenweSaralonde/Musician/master/img/link-button.png), set a title and you're done!

The links remain active until you log out or reload the interface.

Cross-faction play
------------------
Cross-faction (and cross-realm) music can be achieved on WoW Retail through the [Cross RP add-on](https://www.curseforge.com/wow/addons/cross-rp) by Tammya-MoonGuard.

This add-on is very straightforward, just install it and it works!

Cross RP relies on a peer to peer network established by the players who run it so the faction/realm you want to play with may not be always reachable. Feel free to encourage other players to install Cross RP and expand the network!

You can see what realms and factions you're connected to in Musician's options or by mousing over the Cross RP minimap button.

![Cross-faction play with Cross RP](https://raw.githubusercontent.com/LenweSaralonde/Musician/master/img/cross-rp.png)

Integration with role-playing add-ons
-------------------------------------
Musician integrates with role-playing add-ons [Total RP](https://www.curseforge.com/wow/addons/total-rp-3) and [MyRolePlay](https://www.curseforge.com/wow/addons/my-role-play) to benefit from some of their features, such as roleplaying character names and tooltips.

[Total RP](https://www.curseforge.com/wow/addons/total-rp-3)'s map scan feature shows players who also have Musician with a 🎵 icon. The icon blinks for players who are currently playing music.

![Total RP map scan](https://raw.githubusercontent.com/LenweSaralonde/Musician/master/img/trp-map-scan.png)

In addition, the [Total RP Extended](https://www.curseforge.com/wow/addons/total-rp-3-extended) plugin allows you to export your songs as sheet music items that can be traded with other players. Click the **Export** button to create one.

![Total RP Extended item export](https://raw.githubusercontent.com/LenweSaralonde/Musician/master/img/total-rp-extended-item-export.png)![Total RP Extended item in bag](https://raw.githubusercontent.com/LenweSaralonde/Musician/master/img/total-rp-extended-sheet-music-item.png)

Tips and tricks
---------------
* You can preview the song at any moment prior to playing it for other players by clicking the **Preview** button or using the song editor. If another song is playing nearby, it will be muted for you only.
* If another player has Musician, it will be shown in their tooltip. Just hover the other players with your mouse cursor to see who can hear you!
* Use toys such as the [\[Blingtron's Circuit Design Tutorial\]](https://www.wowhead.com/item=132518/blingtrons-circuit-design-tutorial) and the [\[Fae Harp\]](https://www.wowhead.com/item=184489/fae-harp) to make your performance visually more immersive! (WoW Retail only)
* You can add lyrics by combining Musician with the [StoryTeller add-on](https://musician.lenwe.io/storyteller).
* Load and prepare the next song while the current one is playing to reduce waiting time between songs.
* The radius for hearing the music is approximately 40 meters.
* Play songs that are relevant with your "band" composition. It's nonsense to play orchestral music with only two bards ! 😃 However you can still role-play as if your character owns a kind of gnomish *Music-o-Matic* jukebox machine that is capable of reproducing a whole band.
* A text emote is shown to the players who don't have Musician when you play a song. You can disable this emote in the add-on options.
* Nameplates animations and icons are compatible with the most popular nameplate add-ons (KuiNameplates, Plater, ElvUI…).
* You can configure the add-on to use several audio channels to increase the maximum polyphony.
* [Check out the wiki](https://github.com/LenweSaralonde/Musician/wiki/) for more!

Compose your own music
----------------------
You can compose music for Musician using any MIDI sequencer such as [MidiEditor](https://www.midieditor.org/) (free and cross-platform).

The 18 melodic instruments available are:

* Lute (24 Acoustic guitar)
* Recorder (74)
* Celtic harp (46)
* Hammered dulcimer (15)
* Piano (0)
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
* Standard drum set (drum kit 16)
* War drums (47 Timpani)
* Woodblock (115)
* Tambourine shake (119)

The other instruments are mapped to the closest-sounding instrument among the ones available (violin → fiddle, guitar → lute etc.).

The drum kits are replaced by traditional percussions such as a bodhrán (frame drum), a tambourine and a shaker. A standard drum kit is also available for heavy metal songs.

Check the full mapping in [Musician.MidiMapping.lua](https://github.com/LenweSaralonde/Musician/blob/master/constants/Musician.MidiMapping.lua) for details.

Unfortunately, due to limitations of the WoW UI, velocity and controls (volume, padding, pitch bend, modulation…) are not supported. The polyphony may be limited for some players, try to avoid songs having more than 12 simultaneous notes.

Limitations and known issues
----------------------------
Musician has several issues that are due to limitations of the World of Warcraft API. Unfortunately, these can't be fixed but there are some tricks you can do to work around them:

* The volume of the music played with Musician can't be adjusted. Reduce the Master volume if it's too loud for you or if you're experiencing clipping. Setting the Master volume to 75% should deliver a comfortable experience in most cases.
* Musician has lots of audio files that need to be loaded into memory when the game starts. This results in a loading screen showing up or audio not playing properly for a few seconds after entering the game. Make sure you have more RAM than the minimum required by Blizzard. Run WoW on an SSD if possible. Avoid running too much applications in the background while you play WoW with Musician.
* Audio delay occurs when playing live on Windows, because WoW doesn't support low latency drivers such as ASIO or WASAPI. If you have a digital piano with MIDI output, you can use it with [MusicianMIDI](https://lenwe.io/musicianmidi) to play live, and rely on your direct instrument sound instead of Musician's (you can mute Musician using the minimap button).
* Music playing relies on the refresh rate of the screen so stuttering may occur on slower computers. Adjust your settings to maintain a framerate above 30 FPS for good results. Songs having an overly high note rate may stutter.
* There is no support for velocity and modulation in MIDI files.
* The volume of MIDI tracks can't be adjusted. However, each track has an **Accent** checkbox you can enable to double the notes and make the track sound louder.
* The polyphony is limited, some notes may drop if there are too many playing at the same time. By default, Musician uses the SFX and Dialog channels to reach a 64-note polyphony which is enough for 99,99% of the songs. Both channels' volume is set to 100% to make sure all notes play at the same level.
* The *Play as a band* feature does not work with trial accounts in raid mode.

Support
-------
If you like Musician and want to support its development, the best you can do is to spread the word and invite your friends to install it! ❤️

You can also toss a coin to your developer on [Patreon](https://musician.lenwe.io/patreon) or [Paypal](https://musician.lenwe.io/paypal).

🙏 Special thanks to the official supporters of the project:

* Foogiano
* Lindalë Dawnsinger
* Larxania Lunimarch
* Serreldian
* Derenly
* Aphex
* Naelyel
* Crisellianna
* Selena - WRA
* ChanceTheCheetah
* Grayson Blackclaw
