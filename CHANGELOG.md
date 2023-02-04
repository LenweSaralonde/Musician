Changelog
=========

v1.9.7.0
--------
* Added plugin version handling.
* Minor bugfixes and improvements.

v1.9.6.4
--------
* TOC bump for WoW patch 10.0.5.
* TOC bump for WoW Classic patch 3.4.1.
* Added internal events to notify when song settings have changed.
* Minor bugfixes and improvements.

v1.9.6.3
--------
* Fixed tooltip bug with HandyNotes: Dragonflight (Dragon Isles) Treasures and Rares. #90
* Updated HereBeDragons-2.0.

v1.9.6.2
--------
* Fixed player name note icon missing in Total RP3 map scan.
* Fixed translations not fitting in some UI elements.

v1.9.6.1
--------
* Adjusted levels for bass guitar, female voice and sackbut.
* Fixed minimap button style.
* TOC bump for WoW patch 10.0.2.

v1.9.6.0
--------
* Added track accent to play notes in double and make them sound louder.
* Fixed minor cosmetic issues in the song editor.

v1.9.5.0
--------
* The audio cache size is automatically expanded to fit the instrument samples.
* Added options to disable the minimap button and menu.

v1.9.4.1
--------
* Fixed song links over Battle.net conflicting with Total RP3.
* Fixed minimap button gap.
* Added Musician button to the add-on compartment frame.
* Adjusted close buttons size.

v1.9.4.0
--------
* TOC bump for WoW patch 10.0.0.

v1.9.3.1
--------
* Fixed tooltip on WoW patch 10.0.2 (Dragonflight beta).
* Add checkbox to disable quick loading. #87
* Changed celtic harp color.
* Added support for release samples.
* Minor bugfixes and improvements.

v1.9.3.0
--------
* Added loading screen during quick preloading on cold start.
* Fixed trumpet F4 tuning.
* Added custom color support for version text in Total RP 3 tooltips.
* Minor improvements.

v1.9.2.2
--------
* Fixed Lua error when clicking empty hyperlinks.
* Minor bugfixes and improvements.

v1.9.2.1
--------
* Fixed memory leaks.
* Fixed held notes not being stopped when closing the live keyboard.
* Minor bugfixes and improvements.

v1.9.2.0
--------
* Rearranged UI code to improve maintainability.
* Added WoW 10.0 support.
* Fixed Russian localization by MalyDupek.
* Added API version for third party add-ons.
* Hide chat password popup for the comm channel. #86
* Fixed song editor cursor bounds.
* Fixed song links in chat bubbles on Classic.
* Fixed nameplate bug with TRP3 in cinematic mode.
* Minor bugfixes and improvements.

v1.9.1.1
--------
* Fixed chat channel colors and order getting swapped when joining the communication channel. #83
* Added hyperlinks to URLs that can be selected and copied to the clipboard. #85
* Minor bugfixes and improvements.

v1.9.1.0
--------
* Added support for Wrath of the Lich King Classic.
* Updated for WoW Retail patch 9.2.7.
* Minor bugfixes and improvements.

v1.9.0.10
---------
* Fixed nameplate note icons still showing when the player name is hidden. #80
* Fixed nameplate raid icons not hiding when health bars are hidden.

v1.9.0.9
--------
* Fixed NPCs nameplates showing incorrect names. #81

v1.9.0.8
--------
* Fixed nameplates not showing up when leaving cinematic mode.

v1.9.0.7
--------
* Updated for WoW patch 9.2.5.

v1.9.0.6
--------
* Restored TidyPlates_ThreatPlates support (different as TidyPlates).

v1.9.0.5
--------
* Fixed standard nameplates not showing up even when "Show nameplates when the UI is hidden." is checked. #80
* Fixed Tidy Plates support.
* Fixed RPN messages for pitch bend range in MIDI converter.
* Fixed a rare LUA error when a song is previewed too early.

v1.9.0.4
--------
* Added keyboard bindings.
* Fixed nameplate icon showing in double with Plater.

v1.9.0.3
--------
* Added song links support for instance chat.
* Fixed stopped songs resuming unexpectedly.

v1.9.0.2
--------
* Improved band play synchronization.

v1.9.0.1
--------
* Fixed pitch bend range implementation in MIDI converter.
* TOC bump for WoW 9.2 and WoW Classic 1.14.2.

v1.9.0.0
--------
*"Piano Man"*

* The piano is now included in the standard instrument list.

v1.8.0.4
--------
* German translation by Lyntharia.
* Removed README.md images from add-on package.
* TOC update for BC Classic 2.5.3.

v1.8.0.3
--------
* Mute audio from the Winter Veil Chorus Book instrument toy.
* TOC bump for WoW Classic Era 1.14.1.

v1.8.0.2
--------
* TOC bump for WoW 9.1.5.

v1.8.0.1
--------
* Fixed annoying LUA errors poping up randomly.
* Fixed Play/Stop button getting stuck when clicked too fast.

v1.8.0.0
--------
* Removed 6-second limit for note duration. #59
* Added sample looping.
* Properly resume ongoing notes after being muted.
* Fixed percussion envelopes.
* Updated for WoW Classic Era 1.14 and BC Classic 2.5.2.
* Bugfixes and improvements.

v1.7.5.2
--------
* Dummy version bump to force refresh CurseForge's client API.

v1.7.5.1
--------
* Fixed checkbox text width in options panel. #67
* Fixed missing instrument information for MIDI tracks sharing the same channel. #68

v1.7.5.0
--------
* Song editor window can now be resized. #65
* MIDI converter was entierly rewritten to remove the dependency to ToneJS Midi, fix minor issues and improve performance. #58
* Fixed held down notes sometimes getting stopped on sustain pedal release in live play mode. #66

v1.7.4.0
--------
* Instrument samples can now be played using multiple audio channels to increase polyphony. #60

v1.7.3.0
--------
* Unified version for WoW Shadowlands, WoW Classic and WoW Burning Crusade Classic.
* Created localization for German, Spanish, Italian, Korean, Portugese, Russian and traditional Chinese using Google Translate.
* Minor bugfixes and improvements.

v1.7.2.2
--------
* Improved localization to ease up collaboration.
* Fixed Total RP Extended sheet music items localized strings not updating when item locale is changed. (Retail)

v1.7.2.1
--------
* TOC update for WoW patch 9.0.5.
* TOC update for WoW Classic patch 1.13.7

v1.7.2.0
--------
* Song links can now be exchanged through Battle.net messages.
* Improved synchronization when playing songs as a band.
* MIDI converter has been translated in chinese.
* Window positions are now properly saved.

v1.7.1.3
--------
* Added Threat Plates support.
* Fixed song link owner when sent as whisper message.

v1.7.1.2
--------
* Updated 3rd party libraries to address rare compatibility errors with other add-ons.

v1.7.1.1
--------
* Fixed minimap pin sometimes blinking

v1.7.1.0
--------
* Added active musicians tracking on the world map and the minimap
* Improved live keyboard ergonomics
* Fixed compatibility issue with japanese keyboards
* Improved localization to ease up collaboration
* Minor bugfixes and improvements

v1.7.0.0
--------
*"A link to the bard"*

* Songs can now be shared with other players using chat hyperlinks and Total RP Extended items.
* Track start and end timecodes are now clickable in the song editor.
* Added sustain key (spacebar) in the live keyboard interface.
* Added soundfont list for CoolSoft VirtualMIDISynth.
* Several bugfixes and improvements

v1.6.2.0
--------
* Added option to mute instrumental toys such as the Fae Harp. (Retail)
* Added option to allow in-game music playing along with Musician.

v1.6.1.3
--------
* Fixed broken option checkboxes #57

v1.6.1.2
--------
* Updated for WoW Shadowlands 9.0.2
* Fixed error if changing zone while playing music #56

v1.6.1.1
--------
* Fixed minor menu glitch that may occur with outdated add-ons

v1.6.1.0
--------
* Updated for WoW Shadowlands 9.0.1 prepatch
* Set default window position to the right
* Fixed altered GameTooltip font size
* Fixed rare LUA error in CrossRP module #55 (Retail)
* Misc improvements

v1.6.0.9
--------
* Fixed API conflicts with AceAddon #53

v1.6.0.8
--------
* Fixed preloading progression in tooltip #52

v1.6.0.7
--------
* Fixed nameplate icons with ElvUI #51

v1.6.0.6
--------
* Fixed checkboxes in WoW Classic #49

v1.6.0.5
--------
* Fixed notes position in over shoulder camera #48
* Misc bugfixes and improvements

v1.6.0.4
--------
* Force MusicianComm channel in last position #41
* Fixed overlapping notes duration in the MIDI converter
* Fixed JS error with zero duration notes in the MIDI converter

v1.6.0.3
--------
* Fine tuned clarinet, bassoon and dulcimer
* Fixed LUA error when attempting to play a sample that does not exist
* Re-encoded samples to 96 Kbits/s to reduce RAM and disk usage without altering quality

v1.6.0.2
--------
* Added MIDI sustain pedal control changes
* Fixed minimap button issues with some 3rd party addons #47

v1.6.0.1
--------
* Fixed third party instruments do not preload #46

v1.6.0.0
--------
*"Renaissance"*

* Almost all the instruments have been remade from professional high quality samples
* Added 3 new instruments: accordion, war horn and war drum
* Optimized sample caching during loading screen
* Misc bugfixes and improvements

v1.5.5.8
--------
* Update for WoW 8.3
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
* Update for WoW 8.2.5
* HD borders! (Retail)
* Fixed ElvUI Classic nameplates hook #34 (Classic)
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