Changelog
=========

v1.5.5.8
--------
* Fixed "Solo" track status not synchronizing with song actually being played #40

v1.5.5.7
--------
* Updated communication protocol for WoW Classic 1.13.3 #39
* Added "About" box with the list of supporters list #37
* Added donation and Patreon links on the MIDI converter web app
* Fixed add-on options sometimes not showing up #36
* Fixed music not playing in battlegrounds #38

v1.5.5.6
--------
* Fixed ElvUI Classic nameplates hook #34
* Fixed live keyboard UI dropdowns go off screen #35

v1.5.5.5
--------
* Stop playing song when dead (Issue #33)
* Fixed note icon sometimes not showing up in nameplates (Issue #32)

v1.5.5.4
--------
* Added NeatPlates support
* Added WoW client version check

v1.5.5.3
--------
* Added cooldown for the promo message emote (Issue #29)
* Added option to disable the note icon in nameplates (Issue #30)
* Added option to disable the musician pin on the TRP3 map scan (Issue #31)

v1.5.5.2
--------
* Fixed notes dropping when previewing a song with muted tracks
* Fixed LUA error when playing a song on an unknown realm (PTR, Classic...)

v1.5.5.1
--------
* Chinese localization by @Kalevalar
* Added track settings synchronization button in song editor
* Minor bugfixes and improvements

v1.5.5.0
--------
*"Rock Band"*

* Nameplate animations with support of the major nameplate add-ons
* "Play as a band" mode for MIDI songs and live performance
* Cross RP integration to allow cross-faction music playing
* Integration with role-playing add-ons Total RP and MyRolePlay
* Improved preloading to avoid freezings for HDD users during startup
* Minor bugfixes and improvements

v1.5.0.5
--------
* WoW 8.2 update
* Play and Preview commands now behave as a toggle (Issue #12)
* Fixed range and phasing detection (Issue #5)
* Fixed communication channel not joining no channel has been joined (Issue #9)
* Fixed import of MIDI files with missing tempo information (Issue #14)

v1.5.0.4
--------
* Reworked the "promo" emote to make it less intrusive
* Added options panel

v1.5.0.3
--------
* Fixed "Musician has been blocked from an action only available to the Blizzard UI." error popups that occurred in various UI areas
* The Escape key now only closes the current window

v1.5.0.2
--------
* Player tooltips now show a warning for players who use an incompatible outdated version of the addon
* Minor bugfixes and improvements

v1.5.0.1
--------
* Live keyboard no longer blocks default keypresses unnecessarily
* Added program deletion in live keyboard
* Improved keyboard configuration UX to make it more intuitive
* Fixed ordering in live keyboard base key dropdown
* Fixed track list scrolling gap in song editor
* Live demo settings are now saved in live keyboard programs
* Minor bugfixes and improvements

v1.5.0.0
--------
*"Go live!"*

* Live play mode: turns your PC keyboard into a piano!
* New *MUS4* streaming protocol using the powerful Deflate compression
* Various bugfixes and improvements

v1.4.1.1
--------
* Updated for WoW 8.1
* Minor bugfixes

v1.4.1.0
--------
* Added support for groups, raids and instances.

v1.4.0.1
--------
* Fixed bug breaking the "Target" option from player chat menu.

v1.4.0.0
--------
*"Stream Machine"*

* New *MUS3* streaming protocol
* No more loading times, music now starts playing instantly for everyone!
* *Load* button removed. We won't miss it.
* No more freezings and slowdowns
* Progress bars, progress bars everywhere...
* Minor bugfixes

v1.3.1.0
--------
* Samples are now preloaded in background to avoid freezings every time a song starts playing.

v1.3.0.3
--------
* Fixed bug with solo and mute checkboxes in track editor after WoW 8.0 update

v1.3.0.2
--------
* Fixed bug with dropdown menu after WoW 8.0 update

v1.3.0.1
--------
* Updated for WoW 8.0

v1.3.0.0
--------
*Get heavy! \m/*

* Added power trio (electric guitars, bass and drum kit) to play heavy metal. The *Elite Tauren Chieftains* and the *Blight Boar* are now in for a real challenge!
* Improved player to better deal with note drops due to the lack of polyphony
* Added instrument coloring in track editor

v1.2.0.6
--------
* Removed unnecessary separator in unit popup menu.

v1.2.0.5
--------
* Fixed missing protected actions in player popup menu such as targeting.

v1.2.0.4
--------
* Fixed issue with music from other addons that could not play.

v1.2.0.3
--------
* Fixed blocked commands issue in unit popup menus

v1.2.0.2
--------
* Fixed missing or glitchy samples

v1.2.0.1
--------
* Fixed minimap button when UI is scaled (Yimiprod)
* Added missing MIDI mapping for banjo

v1.2.0
------
* Brand new music player: better performance and less RAM usage
* Normalized instrument samples
* Added song editor (song crop, instrument replacement, transposition, track mute and solo)
* Fixed minor bugs

v1.1.2
------
* Added new instrument "Male voice" on patch 52 ("Choir Aahs")
* Fixed recorder tuning

v1.1.1
------
* Added minimap button
* Added global and player mute
* Improved UI to make it more comprehensive and intuitive
* Fixed minor bugs

v1.1
----
* New v2 protocol: loading time dropped by ~66%
* Adjusted the levels of instrument samples
* Fixed bugs with the MIDI converter: variable tempo and program changes are now supported.
* Redesigned MIDI converter interface
* Added `/stopmusic` command
* Fixed minor UI bugs

v1.0
----
* First release
* Plays songs to nearby players
* 12 traditional instruments
* MIDI Converter