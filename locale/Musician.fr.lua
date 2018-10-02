Musician.Locale.fr = {}
local msg = Musician.Locale.fr

msg.PLAY = "Jouer"
msg.STOP = "Stop"
msg.PAUSE = "Pause"
msg.TEST_SONG = "Aperçu"
msg.STOP_TEST = "Arrêter aperçu"
msg.CLEAR = "Effacer"
msg.EDIT = "Éditer"
msg.MUTE = "Rendre silencieux"
msg.UNMUTE = "Rétablir la musique"

msg.STARTUP = "Bienvenue dans Musician v{version}."

msg.NEW_VERSION = "Une nouvelle version de Musician est disponible ! Téléchargez la mise à jour sur {url} ."
msg.NEW_MAJOR_VERSION = "Votre version de Musician est obsolète et n'est plus fonctionnelle.\nTéléchargez la mise à jour sur\n{url}"

msg.PLAYER_TOOLTIP = "Musician"
msg.PLAYER_TOOLTIP_VERSION = "Musician v{version}"
msg.PLAYER_TOOLTIP_PRELOADING = "Préchargement des sons… ({progress})"

msg.PLAYER_COUNT_ONLINE = "Il y a {count} autres amateurs de musique dans le coin !"
msg.PLAYER_COUNT_ONLINE_ONE = "Il y a un autre amateur de musique dans le coin !"

msg.INVALID_MUSIC_CODE = "Le code musical est invalide."

msg.PLAY_A_SONG = "Jouer un morceau"
msg.PASTE_MUSIC_CODE = "Importez votre morceau au format MIDI à l'adresse :\n{url}\n\npuis collez le code de la musique ici..."

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

msg.EMOTE_PLAYING_MUSIC = "joue de la musique."
msg.EMOTE_PROMO = "(Téléchargez l'add-on \"Musician\" sur {url} pour l'écouter !)"
msg.EMOTE_SONG_NOT_LOADED = "(Le morceau n'a pas pu être chargé.)"
msg.EMOTE_PLAYER_OTHER_REALM = "(Ce joueur est sur un autre royaume.)"

msg.TOOLTIP_LEFT_CLICK = "**Clic gauche** : {action}"
msg.TOOLTIP_RIGHT_CLICK = "**Clic droit** : {action}"
msg.TOOLTIP_DRAG_AND_DROP = "**Glisser-déposer** pour déplacer le bouton"
msg.TOOLTIP_ISMUTED = "(silencieux)"
msg.TOOLTIP_ACTION_SHOW = "Ouvrir"
msg.TOOLTIP_ACTION_HIDE = "Fermer"
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

msg.MIDI_INSTRUMENT_NAMES = Musician.Locale.en.MIDI_INSTRUMENT_NAMES

if ( GetLocale() == "frFR" ) then
	Musician.Msg = msg
end
