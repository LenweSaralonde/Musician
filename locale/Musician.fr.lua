Musician.Locale.fr = Musician.Utils.DeepCopy(Musician.Locale.en)

local msg = Musician.Locale.fr
local Instrument = Musician.MIDI_INSTRUMENTS
local Percussion = Musician.MIDI_PERCUSSIONS

msg.PLAY = "Jouer"
msg.STOP = "Stop"
msg.PAUSE = "Pause"
msg.TEST_SONG = "Aperçu"
msg.STOP_TEST = "Arrêter aperçu"
msg.CLEAR = "Effacer"
msg.SELECT_ALL = "Sélectionner tout"
msg.EDIT = "Éditer"
msg.MUTE = "Rendre silencieux"
msg.UNMUTE = "Rétablir la musique"

msg.MENU_TITLE = "Musician"
msg.MENU_IMPORT_SONG = "Importer et jouer un morceau"
msg.MENU_PLAY = msg.PLAY
msg.MENU_STOP = msg.STOP
msg.MENU_PLAY_PREVIEW = msg.TEST_SONG
msg.MENU_STOP_PREVIEW = "Arrêter l'aperçu"
msg.MENU_LIVE_PLAY = "Jouer en direct"
msg.MENU_SHOW_KEYBOARD = "Ouvrir le clavier"
msg.MENU_SETTINGS = "Paramètres"
msg.MENU_OPTIONS = "Options"

msg.COMMAND_LIST_TITLE = "Commandes de Musician :"
msg.COMMAND_SHOW = "Ouvrir la fenêtre d'import"
msg.COMMAND_PREVIEW_PLAY = "Lire ou arrêter l'aperçu du morceau"
msg.COMMAND_PREVIEW_STOP = "Arrêter l'aperçu"
msg.COMMAND_PLAY = "Jouer ou arrêter le morceau"
msg.COMMAND_STOP = "Arrêter de jouer le morceau"
msg.COMMAND_SONG_EDITOR = "Ouvrir l'éditeur de morceau"
msg.COMMAND_LIVE_KEYBOARD = "Ouvrir le clavier"
msg.COMMAND_CONFIGURE_KEYBOARD = "Configurer le clavier"
msg.COMMAND_LIVE_DEMO = "Mode démo clavier"
msg.COMMAND_LIVE_DEMO_PARAMS = "{ **<n° piste supérieur>** **<n° piste inférieur>** || **off** }"
msg.COMMAND_HELP = "Afficher ce message d'aide"
msg.ERR_COMMAND_UNKNOWN = "Commande \"{command}\" inconnue. Tapez {help} pour obtenir la liste des commandes disponibles."

msg.OPTIONS_TITLE = "Musician"
msg.OPTIONS_SUB_TEXT = "Rejoignez le serveur Discord pour obtenir de l'aide ! {url}"
msg.OPTIONS_CATEGORY_EMOTE = "Emote"
msg.OPTIONS_ENABLE_EMOTE_LABEL = "Envoyer une emote aux joueurs n'ayant pas Musician lorsque vous jouez un morceau."
msg.OPTIONS_ENABLE_EMOTE_PROMO_LABEL = "Y inclure une invitation à l'installer afin qu'ils puissent vous écouter."
msg.OPTIONS_EMOTE_HINT = "Une emote est affichée aux joueurs n'ayant pas Musician lorsque vous jouez un morceau. Vous pouvez la désactiver dans les [options]."
msg.OPTIONS_CATEGORY_NAMEPLATES = "Barres d'info et animations"
msg.OPTIONS_CATEGORY_NAMEPLATES_SUB_TEXT = "Activez les barres d'info pour voir une animation sur les personnages qui jouent\nde la musique, ainsi que pour découvrir qui peut vous écouter d'un seul coup d'œil."
msg.OPTIONS_ENABLE_NAMEPLATES = "Activer les barres d'info des unités et les animations."
msg.OPTIONS_HIDE_HEALTH_BARS = "Masquer la barre de vie des joueurs et des unités amicales hors combat."
msg.OPTIONS_HIDE_NPC_NAMEPLATES = "Masquer les barres d'info des PNJs."
msg.OPTIONS_CINEMATIC_MODE = "Afficher les animations lorsque l'interface est masquée avec {binding}."
msg.OPTIONS_CINEMATIC_MODE_NO_BINDING = "Afficher les animations lorsque l'interface est masquée."
msg.OPTIONS_NAMEPLATES_CINEMATIC_MODE = "Afficher les barres d'info lorsque l'interface est masquée."
msg.OPTIONS_CROSS_RP_TITLE = "Cross RP"
msg.OPTIONS_CROSS_RP_SUB_TEXT = "Installez l'add-on Cross RP de Tammya-MoonGuard pour activer\nla musique inter-faction et inter-royaumes !"
msg.OPTIONS_CROSS_RP_SUB_TEXT_NO_GATEWAY = "Il n'y a aucun relais Cross RP de disponible pour le moment.\nPatientez un peu…"
msg.OPTIONS_CROSS_RP_SUB_TEXT_ACTIVE = "La communication Cross RP est active pour les destinations suivantes :\n\n{bands}"

msg.TIPS_AND_TRICKS_ENABLE = "Montrer les astuces au démarrage."

msg.TIPS_AND_TRICKS_NAMEPLATES_TITLE = "Animations et barres d'info"
msg.TIPS_AND_TRICKS_NAMEPLATES_TEXT = "Une animation spéciale est visible sur les personnages qui jouent de la musique lorsque les barres d'info sont activées.\n\n" ..
	"Une icône {icon} apparaît également pour les joueurs qui ont Musician et qui peuvent vous écouter.\n\n" ..
	"Souhaitez-vous activer les barres d'info et les animations maintenant ?"
msg.TIPS_AND_TRICKS_NAMEPLATES_OK = "Activer les barres d'info et les animations"
msg.TIPS_AND_TRICKS_NAMEPLATES_CANCEL = "Non merci"

msg.TIPS_AND_TRICKS_CROSS_RP_TITLE = "Musique inter-faction avec Cross RP"
msg.TIPS_AND_TRICKS_CROSS_RP_TEXT = msg.OPTIONS_CROSS_RP_SUB_TEXT
msg.TIPS_AND_TRICKS_CROSS_RP_OK = "OK"

msg.STARTUP = "Bienvenue dans Musician v{version}."

msg.NEW_VERSION = "Une nouvelle version de Musician est disponible ! Téléchargez la mise à jour sur {url} ."
msg.NEW_PROTOCOL_VERSION = "Votre version de Musician est périmée et n'est plus fonctionnelle.\nTéléchargez la mise à jour sur\n{url}"
msg.SHOULD_CONFIGURE_KEYBOARD = "Vous devez configurer le clavier avant de pouvoir jouer."

msg.PLAYER_TOOLTIP = "Musician"
msg.PLAYER_TOOLTIP_VERSION = "Musician v{version}"
msg.PLAYER_TOOLTIP_VERSION_OUTDATED = " (Périmé)"
msg.PLAYER_TOOLTIP_VERSION_INCOMPATIBLE = " (INCOMPATIBLE)"
msg.PLAYER_TOOLTIP_PRELOADING = "Préchargement des sons… ({progress})"

msg.PLAYER_COUNT_ONLINE = "Il y a {count} autres amateurs de musique dans le coin !"
msg.PLAYER_COUNT_ONLINE_ONE = "Il y a un autre amateur de musique dans le coin !"
msg.PLAYER_COUNT_ONLINE_NONE = "Il n'y a pas encore d'autre amateur de musique dans le coin."

msg.INVALID_MUSIC_CODE = "Le code musical est invalide."

msg.PLAY_A_SONG = "Jouer un morceau"
msg.IMPORT_A_SONG = "Importer un morceau"
msg.PASTE_MUSIC_CODE = "Importez votre morceau au format MIDI à l'adresse :\n{url}\n\npuis collez le code de la musique ici ({shortcut})…"
msg.SONG_IMPORTED = "Morceau importé : {title}."

msg.PLAY_IN_BAND = "Jouer en groupe"
msg.PLAY_IN_BAND_HINT = "Cliquez ici lorsque vous êtes prêt(e) à jouer ce morceau avec votre groupe."
msg.PLAY_IN_BAND_READY_PLAYERS = "Membres du groupe prêts :"
msg.EMOTE_PLAYER_IS_READY = "est prêt(e) à jouer en groupe."
msg.EMOTE_PLAYER_IS_NOT_READY = "n'est plus prêt(e) à jouer en groupe."
msg.EMOTE_PLAY_IN_BAND_START = "a lancé le morceau de groupe."
msg.EMOTE_PLAY_IN_BAND_STOP = "a stoppé le morceau de groupe."

msg.LIVE_SYNC = "Jouer en groupe"
msg.LIVE_SYNC_HINT = "Cliquez ici pour activer la synchronisation de groupe."
msg.SYNCED_PLAYERS = "Membres du groupe :"
msg.EMOTE_PLAYER_LIVE_SYNC_ENABLED = "joue de la musique avec vous."
msg.EMOTE_PLAYER_LIVE_SYNC_DISABLED = "a arrêté de jouer de la musique avec vous."

msg.SONG_EDITOR = "Éditeur de morceau"
msg.MARKER_FROM = "Début"
msg.MARKER_TO = "Fin"
msg.POSITION = "Position"
msg.TRACK_NUMBER = "Piste n°{track}"
msg.CHANNEL_NUMBER_SHORT = "Ch.{channel}"
msg.JUMP_PREV = "Reculer de 10s"
msg.JUMP_NEXT = "Avancer de 10s"
msg.GO_TO_START = "Aller au début"
msg.GO_TO_END = "Aller à la fin"
msg.SET_CROP_FROM = "Définir le point d'entrée"
msg.SET_CROP_TO = "Définir le point de sortie"
msg.MUTE_TRACK = "Muet"
msg.SOLO_TRACK = "Solo"
msg.TRANSPOSE_TRACK = "Transposer (octave)"
msg.CHANGE_TRACK_INSTRUMENT = "Changer d'instrument"
msg.HEADER_NUMBER = "#"
msg.HEADER_OCTAVE = "Octave"
msg.HEADER_INSTRUMENT = "Instrument"

msg.CONFIGURE_KEYBOARD = "Configurer le clavier"
msg.CONFIGURE_KEYBOARD_HINT = "Cliquez sur une touche à définir…"
msg.CONFIGURE_KEYBOARD_HINT_COMPLETE = "La configuration du clavier est terminée.\nVous pouvez maintenant enregistrer les modifications et commencer à jouer !"
msg.CONFIGURE_KEYBOARD_START_OVER = "Recommencer"
msg.CONFIGURE_KEYBOARD_SAVE = "Enregistrer"
msg.PRESS_KEY_BINDING = "Appuyez sur la touche n°{col} de la rangée {row}."
msg.KEY_IS_MERGEABLE = "Il se peut que cette touche soit la même que {key} sur votre clavier : {action}"
msg.KEY_CAN_BE_MERGED = "si c'est le cas, appuyez simplement sur la touche {key}."
msg.KEY_CANNOT_BE_MERGED = "si c'est le cas, passez à la touche suivante."
msg.NEXT_KEY = "Touche suivante"
msg.CLEAR_KEY = "Effacer"

local KEY = Musician.KEYBOARD_KEY
msg.FIXED_KEY_NAMES = {
	[KEY.Backspace] = "Suppr.",
	[KEY.Tab] = "Tab",
	[KEY.CapsLock] = "Verr. Maj",
	[KEY.Enter] = "Entrée",
	[KEY.ShiftLeft] = "Maj",
	[KEY.ShiftRight] = "Maj",
	[KEY.ControlLeft] = "Ctrl",
	[KEY.MetaLeft] = "Meta",
	[KEY.AltLeft] = "Alt",
	[KEY.Space] = "Espace",
	[KEY.AltRight] = "Alt",
	[KEY.MetaRight] = "Meta",
	[KEY.ContextMenu] = "Menu",
	[KEY.ControlRight] = "Ctrl",
}

msg.KEYBOARD_LAYOUTS = {
	["Piano"] = "Piano",
	["Chromatic"] = "Chromatique",

	["Modes"] = "Modes",
	["Ionian"] = "Ionien",
	["Dorian"] = "Dorien",
	["Phrygian"] = "Phrygien",
	["Lydian"] = "Lydien",
	["Mixolydian"] = "Mixolydien",
	["Aeolian"] = "Éolien",
	["Locrian"] = "Locrien",
	["minor Harmonic"] = "mineur Harmonique",
	["minor Melodic"] = "mineur Mélodique",

	["Blues scales"] = "Gammes de Blues",
	["Major Blues"] = "Blues Majeure",
	["minor Blues"] = "Blues mineure",

	["Diminished scales"] = "Gammes diminuées",
	["Diminished"] = "Diminuée",
	["Complement Diminished"] = "Diminuée complémentaire",

	["Pentatonic scales"] = "Gammes pentatoniques",
	["Major Pentatonic"] = "Pentatonique Majeure",
	["minor Pentatonic"] = "Pentatonique mineure",

	["World scales"] = "Gammes du Monde",
	["Raga 1"] = "Raga 1",
	["Raga 2"] = "Raga 2",
	["Raga 3"] = "Raga 3",
	["Arabic"] = "Arabe",
	["Spanish"] = "Espagnole",
	["Gypsy"] = "Gitane",
	["Egyptian"] = "Égyptienne",
	["Hawaiian"] = "Hawaïenne",
	["Bali Pelog"] = "Pelog Balinaise",
	["Japanese"] = "Japonaise",
	["Ryukyu"] = "Ryukyu",
	["Chinese"] = "Chinoise",

	["Miscellaneous scales"] = "Gammes diverses",
	["Bass Line"] = "Ligne de basse",
	["Wholetone"] = "Gamme par ton",
	["minor 3rd"] = "mineure tierce",
	["Major 3rd"] = "Majeure tierce",
	["4th"] = "Quarte",
	["5th"] = "Quinte",
	["Octave"] = "Octave",
}
msg.HORIZONTAL_LAYOUT = "Horizontal"
msg.VERTICAL_LAYOUT = "Vertical"

msg.LIVE_SONG_NAME = "Morceau en direct"
msg.SOLO_MODE = "Mode Solo"
msg.LIVE_MODE = "Mode Direct"
msg.LIVE_MODE_DISABLED = "Le Mode Direct est désactivé pendant la lecture."
msg.ENABLE_SOLO_MODE = "Activer le Mode Solo (vous jouez pour vous-même)"
msg.ENABLE_LIVE_MODE = "Activer le Mode Direct (vous jouez pour tout le monde)"
msg.PLAY_LIVE = "Jouer en direct"
msg.PLAY_SOLO = "Jouer en solo"
msg.SHOW_KEYBOARD = "Afficher le clavier"
msg.HIDE_KEYBOARD = "Cacher le clavier"
msg.KEYBOARD_LAYOUT = "Mode/gamme du clavier"
msg.CHANGE_KEYBOARD_LAYOUT = "Changer la disposition du clavier"
msg.BASE_KEY = "Note de base"
msg.CHANGE_BASE_KEY = "Changer la note de base"
msg.CHANGE_LOWER_INSTRUMENT = "Changer l'instrument inférieur"
msg.CHANGE_UPPER_INSTRUMENT = "Changer l'instrument supérieur"
msg.LOWER_INSTRUMENT_MAPPED_TO_CHANNEL = "Instrument inférieur (piste n°{track})"
msg.UPPER_INSTRUMENT_MAPPED_TO_CHANNEL = "Instrument supérieur (piste n°{track})"
msg.POWER_CHORDS = "Power chords"
msg.PROGRAM_BUTTON = "P {num}"
msg.EMPTY_PROGRAM = "Programme vide"
msg.LOAD_PROGRAM_NUM = "Charger le programme n°{num} ({key})"
msg.SAVE_PROGRAM_NUM = "Enregistrer dans le programme n°{num} ({key})"
msg.DELETE_PROGRAM_NUM = "Effacer le programme n°{num} ({key})"
msg.WRITE_PROGRAM = "Enregistrer un programme ({key})"
msg.PROGRAM_SAVED = "Programme n°{num} enregistré."
msg.PROGRAM_DELETED = "Programme n°{num} effacé."
msg.DEMO_MODE_ENABLED = "Mode démo clavier activé :\n{mapping}"
msg.DEMO_MODE_MAPPING = "{layer} → Piste n°{track}"
msg.DEMO_MODE_DISABLED = "Mode démo clavier désactivé."

msg.LAYERS = {
	[Musician.KEYBOARD_LAYER.UPPER] = "Supérieur",
	[Musician.KEYBOARD_LAYER.LOWER] = "Inférieur",
}

msg.EMOTE_PLAYING_MUSIC = "joue de la musique."
msg.EMOTE_PROMO = "(Installez l'add-on \"Musician\" pour l'écouter)"
msg.EMOTE_SONG_NOT_LOADED = "(Le morceau ne peut pas être joué car {player} utilise une version incompatible.)"
msg.EMOTE_PLAYER_OTHER_REALM = "(Ce joueur est sur un autre royaume.)"

msg.TOOLTIP_LEFT_CLICK = "**Clic gauche** : {action}"
msg.TOOLTIP_RIGHT_CLICK = "**Clic droit** : {action}"
msg.TOOLTIP_DRAG_AND_DROP = "**Glisser-déposer** pour déplacer le bouton"
msg.TOOLTIP_ISMUTED = "(silencieux)"
msg.TOOLTIP_ACTION_OPEN_MENU = "Ouvrir le menu"
msg.TOOLTIP_ACTION_MUTE = "Activer le mode silencieux"
msg.TOOLTIP_ACTION_UNMUTE = "Désactiver le mode silencieux"

msg.PLAYER_MENU_TITLE = "Musique"
msg.PLAYER_MENU_STOP_CURRENT_SONG = "Arrêter le morceau en cours"
msg.PLAYER_MENU_MUTE = "Rendre silencieux"
msg.PLAYER_MENU_UNMUTE = "Rétablir la musique"

msg.PLAYER_IS_MUTED = "{icon}{player} est maintenant en mode silencieux."
msg.PLAYER_IS_UNMUTED = "{icon}{player} n'est plus en mode silencieux."

msg.INSTRUMENT_NAMES = {
	["none"] = "(Aucun)",
	["bagpipe"] = "Cornemuse",
	["dulcimer"] = "Dulcimer à marteaux",
	["lute"] = "Luth",
	["cello"] = "Violoncelle",
	["harp"] = "Harpe celtique",
	["bodhran-bassdrum-low"] = "Bodhrán (grosse caisse)",
	["male-voice"] = "Voix d'homme (tenor)",
	["female-voice"] = "Voix de femme (soprano)",
	["trumpet"] = "Trompette",
	["trombone"] = "Trombone",
	["bassoon"] = "Basson",
	["clarinet"] = "Clarinette",
	["recorder"] = "Flûte à bec",
	["fiddle"] = "Violon irlandais",
	["bodhran-snare-long-hi"] = "Bodhrán (caisse claire aigüe)",
	["bodhran-snare-long-low"] = "Bodhrán (caisse claire grave)",
	["percussions"] = "Percussions traditionnelles",
	["distorsion-guitar"] = "Guitare metal",
	["clean-guitar"] = "Guitare son clair",
	["bass-guitar"] = "Guitare basse",
	["drumkit"] = "Batterie",
}

msg.MIDI_INSTRUMENT_NAMES = {
	[Instrument.AcousticGrandPiano] = "Grand piano",
	[Instrument.BrightAcousticPiano] = "Piano droit",
	[Instrument.ElectricGrandPiano] = "Grand piano électrique",
	[Instrument.HonkyTonkPiano] = "Piano honky-tonk",
	[Instrument.ElectricPiano1] = "Piano électrique 1",
	[Instrument.ElectricPiano2] = "Piano électrique 2",
	[Instrument.Harpsichord] = "Clavecin",
	[Instrument.Clavi] = "Clavicorde",

	[Instrument.Celesta] = "Célesta",
	[Instrument.Glockenspiel] = "Carillon",
	[Instrument.MusicBox] = "Boîte à musique",
	[Instrument.Vibraphone] = "Vibraphone",
	[Instrument.Marimba] = "Marimba",
	[Instrument.Xylophone] = "Xylophone",
	[Instrument.TubularBells] = "Cloches tubulaires",
	[Instrument.Dulcimer] = "Tympanon",

	[Instrument.DrawbarOrgan] = "Orgue à tubes",
	[Instrument.PercussiveOrgan] = "Orgue percussif",
	[Instrument.RockOrgan] = "Orgue rock",
	[Instrument.ChurchOrgan] = "Orgue d'église",
	[Instrument.ReedOrgan] = "Harmonium",
	[Instrument.Accordion] = "Accordéon",
	[Instrument.Harmonica] = "Harmonica",
	[Instrument.TangoAccordion] = "Bandonéon",

	[Instrument.AcousticGuitarNylon] = "Guitare acoustique classique",
	[Instrument.AcousticGuitarSteel] = "Guitare acoustique folk",
	[Instrument.ElectricGuitarJazz] = "Guitare acoustique jazz",
	[Instrument.ElectricGuitarClean] = "Guitare électrique pure",
	[Instrument.ElectricGuitarMuted] = "Guitare électrique mute",
	[Instrument.OverdrivenGuitar] = "Guitare électrique saturée",
	[Instrument.DistortionGuitar] = "Guitare électrique avec distorsion",
	[Instrument.Guitarharmonics] = "Guitare électrique (harmonique)",

	[Instrument.AcousticBass] = "Basse acoustique",
	[Instrument.ElectricBassFinger] = "Basse électrique 1",
	[Instrument.ElectricBassPick] = "Basse électrique 2",
	[Instrument.FretlessBass] = "Basse électrique 3",
	[Instrument.SlapBass1] = "Basse slap 1",
	[Instrument.SlapBass2] = "Basse slap 2",
	[Instrument.SynthBass1] = "Basse synthétiseur 1",
	[Instrument.SynthBass2] = "Basse synthétiseur 2",

	[Instrument.Violin] = "Violon",
	[Instrument.Viola] = "Viole",
	[Instrument.Cello] = "Violoncelle",
	[Instrument.Contrabass] = "Contrebasse",
	[Instrument.TremoloStrings] = "Cordes trémolo",
	[Instrument.PizzicatoStrings] = "Cordes pizzicato",
	[Instrument.OrchestralHarp] = "Harpe",
	[Instrument.Timpani] = "Timbales",

	[Instrument.StringEnsemble1] = "Quartet cordes 1",
	[Instrument.StringEnsemble2] = "Quartet cordes 2",
	[Instrument.SynthStrings1] = "Cordes synthétiseur 1",
	[Instrument.SynthStrings2] = "Cordes synthétiseur 2",
	[Instrument.ChoirAahs] = "Chœurs Aahs",
	[Instrument.VoiceOohs] = "Voix Oohs",
	[Instrument.SynthVoice] = "Voix synthétiseur",
	[Instrument.OrchestraHit] = "Coup d'orchestre",

	[Instrument.Trumpet] = "Trompette",
	[Instrument.Trombone] = "Trombone",
	[Instrument.Tuba] = "Tuba",
	[Instrument.MutedTrumpet] = "Trompette bouchée",
	[Instrument.FrenchHorn] = "Cors",
	[Instrument.BrassSection] = "Ensemble de cuivres",
	[Instrument.SynthBrass1] = "Cuivres synthétiseur 1",
	[Instrument.SynthBrass2] = "Cuivres synthétiseur 2",

	[Instrument.SopranoSax] = "Saxophone soprano",
	[Instrument.AltoSax] = "Saxophone alto",
	[Instrument.TenorSax] = "Saxophone ténor",
	[Instrument.BaritoneSax] = "Saxophone baryton",
	[Instrument.Oboe] = "Hautbois",
	[Instrument.EnglishHorn] = "Cors anglais",
	[Instrument.Bassoon] = "Basson",
	[Instrument.Clarinet] = "Clarinette",

	[Instrument.Piccolo] = "Flûte piccolo",
	[Instrument.Flute] = "Flûte",
	[Instrument.Recorder] = "Flûte à bec",
	[Instrument.PanFlute] = "Flûte de pan",
	[Instrument.BlownBottle] = "Bouteille sifflée",
	[Instrument.Shakuhachi] = "Shakuhachi",
	[Instrument.Whistle] = "Sifflet",
	[Instrument.Ocarina] = "Ocarina",

	[Instrument.Lead1Square] = "Lead 1 (signal carré)",
	[Instrument.Lead2Sawtooth] = "Lead 2 (signal dents de scie)",
	[Instrument.Lead3Calliope] = "Lead 3 (orgue)",
	[Instrument.Lead4Chiff] = "Lead 4 (chiff)",
	[Instrument.Lead5Charang] = "Lead 5 (charang)",
	[Instrument.Lead6Voice] = "Lead 6 (voix)",
	[Instrument.Lead7Fifths] = "Lead 7 (son accordé en quinte)",
	[Instrument.Lead8BassLead] = "Lead 8 (basse)",

	[Instrument.Pad1Newage] = "Pad 1 (new age)",
	[Instrument.Pad2Warm] = "Pad 2 (warm)",
	[Instrument.Pad3Polysynth] = "Pad 3 (synthétiseur polyphonique)",
	[Instrument.Pad4Choir] = "Pad 4 (chœurs)",
	[Instrument.Pad5Bowed] = "Pad 5 (archet)",
	[Instrument.Pad6Metallic] = "Pad 6 (métal)",
	[Instrument.Pad7Halo] = "Pad 7 (halo)",
	[Instrument.Pad8Sweep] = "Pad 8 (glissement)",

	[Instrument.FX1Rain] = "Pluie (FX 1)",
	[Instrument.FX2Soundtrack] = "Bande sonore (FX 2)",
	[Instrument.FX3Crystal] = "Cristal (FX 3)",
	[Instrument.FX4Atmosphere] = "Atmosphère (FX 4)",
	[Instrument.FX5Brightness] = "Brightness (FX 5)",
	[Instrument.FX6Goblins] = "Goblins (FX 6)",
	[Instrument.FX7Echoes] = "Echoes (FX 7)",
	[Instrument.FX8SciFi] = "Sci-fi(FX 8)",

	[Instrument.Sitar] = "Sitar",
	[Instrument.Banjo] = "Banjo",
	[Instrument.Shamisen] = "Shamisen",
	[Instrument.Koto] = "Koto",
	[Instrument.Kalimba] = "Kalimba",
	[Instrument.Bagpipe] = "Cornemuse",
	[Instrument.Fiddle] = "Violon irlandais",
	[Instrument.Shanai] = "Shehnai",

	[Instrument.TinkleBell] = "Clochette",
	[Instrument.Agogo] = "Agogo",
	[Instrument.SteelDrums] = "Percussion métallique",
	[Instrument.Woodblock] = "Woodblock",
	[Instrument.TaikoDrum] = "Taiko drum",
	[Instrument.MelodicTom] = "Tom mélodique",
	[Instrument.SynthDrum] = "Percussion synthétique",
	[Instrument.ReverseCymbal] = "Cymbale inversée",

	[Instrument.GuitarFretNoise] = "Touche de guitare",
	[Instrument.BreathNoise] = "Respiration",
	[Instrument.Seashore] = "Vague",
	[Instrument.BirdTweet] = "Chants d'oiseaux",
	[Instrument.TelephoneRing] = "Sonnerie de téléphone",
	[Instrument.Helicopter] = "Hélicoptère",
	[Instrument.Applause] = "Aplaudissements",
	[Instrument.Gunshot] = "Coup de feu",

	[Instrument.Percussions] = "Batterie",
	[Instrument.Drumkit] = "Batterie",

	[Instrument.None] = "Aucun"
}

msg.MIDI_PERCUSSION_NAMES = {
	[Percussion.Laser] = "Laser",
	[Percussion.Whip] = "Fouet",
	[Percussion.ScratchPush] = "Scratch poussé",
	[Percussion.ScratchPull] = "Scratch tiré",
	[Percussion.StickClick] = "Baguettes",
	[Percussion.SquareClick] = "Click",
	[Percussion.MetronomeClick] = "Clic de métronome",
	[Percussion.MetronomeBell] = "Cloche de métronome",
	[Percussion.AcousticBassDrum] = "Grosse caisse basse",
	[Percussion.BassDrum1] = "Grosse caisse médium",
	[Percussion.SideStick] = "Coup de métronome (Rimshot)",
	[Percussion.AcousticSnare] = "Caisse claire acoustique",
	[Percussion.HandClap] = "Claps",
	[Percussion.ElectricSnare] = "Caisse claire électrique",
	[Percussion.LowFloorTom] = "Tom basse grave",
	[Percussion.ClosedHiHat] = "Charleston frappé",
	[Percussion.HighFloorTom] = "Tom basse 2",
	[Percussion.PedalHiHat] = "Charleston au pied",
	[Percussion.LowTom] = "Tom médium",
	[Percussion.OpenHiHat] = "Charleston ouvert",
	[Percussion.LowMidTom] = "Tom médium 2",
	[Percussion.HiMidTom] = "Tom aigu",
	[Percussion.CrashCymbal1] = "Cymbale crash",
	[Percussion.HighTom] = "Tom aigu 2",
	[Percussion.RideCymbal1] = "Cymbale ride",
	[Percussion.ChineseCymbal] = "Cymbale chinoise",
	[Percussion.RideBell] = "Cymbale cloche",
	[Percussion.Tambourine] = "Tambourin",
	[Percussion.SplashCymbal] = "Cymbale splash",
	[Percussion.Cowbell] = "Cloche à vache",
	[Percussion.CrashCymbal2] = "Cymbale crash 2",
	[Percussion.Vibraslap] = "Vibraslap",
	[Percussion.RideCymbal2] = "Cymbale ride 2 (aiguë)",
	[Percussion.HiBongo] = "Bongo aigu",
	[Percussion.LowBongo] = "Bongo grave",
	[Percussion.MuteHiConga] = "Conga aigu sourd",
	[Percussion.OpenHiConga] = "Conga aigu ouvert",
	[Percussion.LowConga] = "Conga grave",
	[Percussion.HighTimbale] = "Timbales aiguës",
	[Percussion.LowTimbale] = "Timbales graves",
	[Percussion.HighAgogo] = "Cloche agogo aiguë",
	[Percussion.LowAgogo] = "Cloche agogo grave",
	[Percussion.Cabasa] = "Cabasa",
	[Percussion.Maracas] = "Maracas",
	[Percussion.ShortWhistle] = "Sifflet aigu",
	[Percussion.LongWhistle] = "Sifflet grave",
	[Percussion.ShortGuiro] = "Guiro cout",
	[Percussion.LongGuiro] = "Guiro long",
	[Percussion.Claves] = "Claves",
	[Percussion.HiWoodBlock] = "Woodblock aigu",
	[Percussion.LowWoodBlock] = "Woodblock grave",
	[Percussion.MuteCuica] = "Cuica assourdie",
	[Percussion.OpenCuica] = "Cuica ouverte",
	[Percussion.MuteTriangle] = "Triangle tenu (non résonant)",
	[Percussion.OpenTriangle] = "Triangle libre (résonant)",
	[Percussion.Shaker] = "Shaker",
	[Percussion.SleighBell] = "Clochettes",
	[Percussion.BellTree] = "Arbre à cloches (Bell tree)",
	[Percussion.Castanets] = "Castagnettes",
	[Percussion.SurduDeadStroke] = "Surdo étouffé",
	[Percussion.Surdu] = "Surdo résonant",
	[Percussion.SnareDrumRod] = "Tige de caisse claire",
	[Percussion.OceanDrum] = "Tambour de l'océan",
	[Percussion.SnareDrumBrush] = "Balais",
}

if ( GetLocale() == "frFR" ) then
	Musician.Msg = msg
end
