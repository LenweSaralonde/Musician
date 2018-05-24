Musician.Locale.fr = {}

Musician.Locale.fr.PLAY = "Jouer"
Musician.Locale.fr.STOP = "Stop"
Musician.Locale.fr.PAUSE = "Pause"
Musician.Locale.fr.LOAD = "Charger"
Musician.Locale.fr.LOADING = "Chargement"
Musician.Locale.fr.TEST_SONG = "Aperçu"
Musician.Locale.fr.STOP_TEST = "Arrêter aperçu"
Musician.Locale.fr.CLEAR = "Effacer"
Musician.Locale.fr.EDIT = "Éditer"
Musician.Locale.fr.MUTE = "Rendre silencieux"
Musician.Locale.fr.UNMUTE = "Rétablir la musique"

Musician.Locale.fr.STARTUP = "Bienvenue dans Musician v{version}."

Musician.Locale.fr.NEW_VERSION = "Une nouvelle version de Musician est disponible ! Téléchargez-la sur {url}"

Musician.Locale.fr.PLAYER_TOOLTIP = "Musician"
Musician.Locale.fr.PLAYER_TOOLTIP_VERSION = "Musician v{version}"

Musician.Locale.fr.PLAYER_COUNT_ONLINE = "Il y a {count} autres amateurs de musique dans le coin !"
Musician.Locale.fr.PLAYER_COUNT_ONLINE_ONE = "Il y a un autre amateur de musique dans le coin !"

Musician.Locale.fr.INVALID_MUSIC_CODE = "Le code musical est invalide."

Musician.Locale.fr.PLAY_A_SONG = "Jouer un morceau"
Musician.Locale.fr.PASTE_MUSIC_CODE = "Importez votre morceau au format MIDI à l'adresse :\n{url}\n\npuis collez le code de la musique ici..."

Musician.Locale.fr.SONG_EDITOR = "Éditeur de morceau"
Musician.Locale.fr.MARKER_FROM = "Début"
Musician.Locale.fr.MARKER_TO = "Fin"
Musician.Locale.fr.POSITION = "Position"
Musician.Locale.fr.TRACK_NUMBER = "Piste n°{track}"
Musician.Locale.fr.CHANNEL_NUMBER_SHORT = "Ch.{channel}"
Musician.Locale.fr.JUMP_PREV = "Reculer de 10s"
Musician.Locale.fr.JUMP_NEXT = "Avancer de 10s"
Musician.Locale.fr.GO_TO_START = "Aller au début"
Musician.Locale.fr.GO_TO_END = "Aller à la fin"
Musician.Locale.fr.SET_CROP_FROM = "Définir le point d'entrée"
Musician.Locale.fr.SET_CROP_TO = "Définir le point de sortie"
Musician.Locale.fr.MUTE_TRACK = "Muet"
Musician.Locale.fr.SOLO_TRACK = "Solo"
Musician.Locale.fr.TRANSPOSE_TRACK = "Transposer (octave)"
Musician.Locale.fr.CHANGE_TRACK_INSTRUMENT = "Changer d'instrument"
Musician.Locale.fr.HEADER_NUMBER = "#"
Musician.Locale.fr.HEADER_OCTAVE = "Octave"
Musician.Locale.fr.HEADER_INSTRUMENT = "Instrument"

Musician.Locale.fr.EMOTE_PLAYING_MUSIC = "joue de la musique."
Musician.Locale.fr.EMOTE_PROMO = "(Téléchargez l'add-on \"Musician\" sur {url} pour l'écouter !)"
Musician.Locale.fr.EMOTE_SONG_NOT_LOADED = "(Le morceau n'a pas pu être chargé.)"
Musician.Locale.fr.EMOTE_PLAYER_OTHER_REALM = "(Ce joueur est sur un autre royaume.)"

Musician.Locale.fr.TOOLTIP_LEFT_CLICK = "**Clic gauche** : {action}"
Musician.Locale.fr.TOOLTIP_RIGHT_CLICK = "**Clic droit** : {action}"
Musician.Locale.fr.TOOLTIP_DRAG_AND_DROP = "**Glisser-déposer** pour déplacer le bouton"
Musician.Locale.fr.TOOLTIP_ISMUTED = "(silencieux)"
Musician.Locale.fr.TOOLTIP_ACTION_SHOW = "Ouvrir"
Musician.Locale.fr.TOOLTIP_ACTION_HIDE = "Fermer"
Musician.Locale.fr.TOOLTIP_ACTION_MUTE = "Activer le mode silencieux"
Musician.Locale.fr.TOOLTIP_ACTION_UNMUTE = "Désactiver le mode silencieux"

Musician.Locale.fr.PLAYER_MENU_TITLE = "Musique"
Musician.Locale.fr.PLAYER_MENU_STOP_CURRENT_SONG = "Arrêter le morceau en cours"
Musician.Locale.fr.PLAYER_MENU_MUTE = "Rendre silencieux"
Musician.Locale.fr.PLAYER_MENU_UNMUTE = "Rétablir la musique"

Musician.Locale.fr.PLAYER_IS_MUTED = "{icon}{player} est maintenant en mode silencieux."
Musician.Locale.fr.PLAYER_IS_UNMUTED = "{icon}{player} n'est plus en mode silencieux."

Musician.Locale.fr.INSTRUMENT_NAMES = {
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
	["percussions"] = "Percussions",
}

Musician.Locale.fr.MIDI_INSTRUMENT_NAMES = Musician.Locale.en.MIDI_INSTRUMENT_NAMES

if ( GetLocale() == "frFR" ) then
	Musician.Msg = Musician.Locale.fr
end
