------------------------------------------------------------------------
-- Please read the localization guide in the Wiki:
-- https://github.com/LenweSaralonde/Musician/wiki/Localization
--
-- * Commented out msg lines need to be translated.
-- * Do not translate anything on the left hand side of the = sign.
-- * Do not translate placeholders in curly braces ({variable}).
-- * Keep the text as a single line. Use \n for carriage return.
-- * Escape double quotes (") with a backslash (\").
-- * Check the result in game to make sure your text fits the UI.
------------------------------------------------------------------------

local msg = Musician.InitLocale("pt", "Português", "ptBR")

local Instrument = Musician.MIDI_INSTRUMENTS
local Percussion = Musician.MIDI_PERCUSSIONS
local KEY = Musician.KEYBOARD_KEY

------------------------------------------------------------------------
---------------- ↑↑↑ DO NOT EDIT THE LINES ABOVE ! ↑↑↑  ----------------
------------------------------------------------------------------------

--- Main frame controls
msg.PLAY = "Jogar"
msg.STOP = "Pare"
msg.PAUSE = "Pausa"
msg.TEST_SONG = "Antevisão"
msg.STOP_TEST = "Parar a pré-visualização"
msg.CLEAR = "Claro"
msg.SELECT_ALL = "Selecionar tudo"
msg.EDIT = "Editar"
msg.MUTE = "Mudo"
msg.UNMUTE = "Com som"

--- Minimap button menu
msg.MENU_TITLE = "Musician"
msg.MENU_IMPORT_SONG = "Importar e reproduzir uma música"
msg.MENU_PLAY = "Jogar"
msg.MENU_STOP = "Pare"
msg.MENU_PLAY_PREVIEW = "Antevisão"
msg.MENU_STOP_PREVIEW = "Parar a pré-visualização"
msg.MENU_LIVE_PLAY = "Jogo ao vivo"
msg.MENU_SHOW_KEYBOARD = "Abra o teclado"
msg.MENU_SETTINGS = "Definições"
msg.MENU_OPTIONS = "Opções"
msg.MENU_ABOUT = "Cerca de"

--- Chat commands
msg.COMMAND_LIST_TITLE = "Comandos do Musician:"
msg.COMMAND_SHOW = "Mostrar janela de importação de música"
msg.COMMAND_PREVIEW_PLAY = "Iniciar ou parar a pré-visualização da música"
msg.COMMAND_PREVIEW_STOP = "Pare de visualizar a música"
msg.COMMAND_PLAY = "Tocar ou parar a música"
msg.COMMAND_STOP = "Pare de tocar música"
msg.COMMAND_SONG_EDITOR = "Abra o editor de música"
msg.COMMAND_LIVE_KEYBOARD = "Abra o teclado ao vivo"
msg.COMMAND_CONFIGURE_KEYBOARD = "Configurar teclado"
msg.COMMAND_LIVE_DEMO = "Modo de demonstração do teclado"
msg.COMMAND_LIVE_DEMO_PARAMS = "{** <faixa superior #> ** ** <faixa inferior #> ** || **fora** }"
msg.COMMAND_HELP = "Mostrar esta mensagem de ajuda"
msg.ERR_COMMAND_UNKNOWN = "Comando “{command}” desconhecido. Digite {help} para obter a lista de comandos."

--- Add-on options
msg.OPTIONS_TITLE = "Musician"
msg.OPTIONS_SUB_TEXT = "Junte-se ao servidor Discord para suporte! {url}"
msg.OPTIONS_CATEGORY_EMOTE = "Emote"
msg.OPTIONS_ENABLE_EMOTE_LABEL = "Envie um emote de texto para jogadores que não possuem Musician ao tocar uma música."
msg.OPTIONS_ENABLE_EMOTE_PROMO_LABEL = "Inclua um pequeno texto convidando-os a instalá-lo para que possam ouvir a música que você toca."
msg.OPTIONS_EMOTE_HINT = "Um emote de texto é mostrado aos jogadores que não têm Musician quando você toca uma música. Você pode desativá-lo nas [opções]."
msg.OPTIONS_INTEGRATION_OPTIONS_TITLE = "Opções de integração no jogo"
msg.OPTIONS_AUTO_MUTE_GAME_MUSIC_LABEL = "Silencie a música do jogo enquanto uma música está tocando."
msg.OPTIONS_MUTE_INSTRUMENT_TOYS_LABEL = "Música muda de brinquedos instrumentais. {icons}"
msg.OPTIONS_AUDIO_CHANNELS_TITLE = "Canais de áudio"
msg.OPTIONS_AUDIO_CHANNELS_HINT = "Selecione mais canais de áudio para aumentar o número máximo de notas que o Musician pode tocar simultaneamente."
msg.OPTIONS_AUDIO_CHANNELS_CHANNEL_POLYPHONY = "{channel} ({polyphony})"
msg.OPTIONS_AUDIO_CHANNELS_TOTAL_POLYPHONY = "Polifonia máxima total: {polyphony}"
msg.OPTIONS_AUDIO_CHANNELS_AUTO_ADJUST_CONFIG = "Otimize automaticamente as configurações de áudio quando vários canais de áudio são selecionados."
msg.OPTIONS_AUDIO_CACHE_SIZE_FOR_MUSICIAN = "Para Musician (%dMB)"
msg.OPTIONS_CATEGORY_SHORTCUTS = "Atalhos"
msg.OPTIONS_SHORTCUT_MINIMAP = "Botão Minimapa"
msg.OPTIONS_SHORTCUT_ADDON_MENU = "Menu Minimapa"
msg.OPTIONS_QUICK_PRELOADING_TITLE = "Pré-carregamento rápido"
msg.OPTIONS_QUICK_PRELOADING_TEXT = "Ativar pré-carregamento rápido dos instrumentos na partida a frio."
msg.OPTIONS_CATEGORY_NAMEPLATES = "Placas de identificação e animações"
msg.OPTIONS_CATEGORY_NAMEPLATES_SUB_TEXT = "Habilite as placas de identificação para ver as animações nos personagens tocando música e descubra\nquem pode ouvi-lo de relance."
msg.OPTIONS_ENABLE_NAMEPLATES = "Habilite placas de identificação e animações."
msg.OPTIONS_SHOW_NAMEPLATE_ICON = "Mostra um ícone {icon} próximo ao nome dos jogadores que também têm Musician."
msg.OPTIONS_HIDE_HEALTH_BARS = "Oculte as barras de saúde do jogador e da unidade aliada quando não estiver em combate."
msg.OPTIONS_HIDE_NPC_NAMEPLATES = "Oculte as placas de identificação do NPC."
msg.OPTIONS_CINEMATIC_MODE = "Mostra animações quando a IU está oculta com {binding}."
msg.OPTIONS_CINEMATIC_MODE_NO_BINDING = "Mostra animações quando a IU está oculta."
msg.OPTIONS_NAMEPLATES_CINEMATIC_MODE = "Mostra as placas de identificação quando a IU está oculta."
msg.OPTIONS_TRP3 = "RP total 3"
msg.OPTIONS_TRP3_MAP_SCAN = "Mostre aos jogadores que possuem Musician no mapa a varredura com um ícone {icon}."
msg.OPTIONS_CROSS_RP_TITLE = "Cross RP"
msg.OPTIONS_CROSS_RP_SUB_TEXT = "Instale o complemento Cross RP de Tammya-MoonGuard para ativar\nmúsica entre facções e reinos!"
msg.OPTIONS_CROSS_RP_SUB_TEXT_NO_GATEWAY = "Não há nenhum nó Cross RP disponível no momento.\nPor favor, seja paciente…"
msg.OPTIONS_CROSS_RP_SUB_TEXT_ACTIVE = "A comunicação RP cruzada está ativa para os seguintes locais:\n\n{bands}"

--- Tips and Tricks
msg.TIPS_AND_TRICKS_ENABLE = "Mostre dicas e truques na inicialização."

msg.TIPS_AND_TRICKS_NAMEPLATES_TITLE = "Animações e placas de identificação"
msg.TIPS_AND_TRICKS_NAMEPLATES_TEXT = "Uma animação especial é visível em personagens que tocam música quando as placas de identificação estão habilitadas.\n\nUm ícone {icon} também indica quem tem músico e pode ouvi-lo.\n\nDeseja habilitar placas de identificação e animações agora?"
msg.TIPS_AND_TRICKS_NAMEPLATES_OK = "Habilitar placas de identificação e animações"
msg.TIPS_AND_TRICKS_NAMEPLATES_CANCEL = "Mais tarde"

msg.TIPS_AND_TRICKS_CROSS_RP_TITLE = "Música cross-faction com Cross RP"
msg.TIPS_AND_TRICKS_CROSS_RP_TEXT = "Instale o complemento Cross RP de Tammya-MoonGuard para ativar\nmúsica entre facções e reinos!"
msg.TIPS_AND_TRICKS_CROSS_RP_OK = "OK"

--- Welcome messages
msg.STARTUP = "Bem-vindo ao Musician v {version}."
msg.PLAYER_COUNT_ONLINE = "Existem {count} outros fãs de música por aí!"
msg.PLAYER_COUNT_ONLINE_ONE = "Há outro fã de música por aí!"
msg.PLAYER_COUNT_ONLINE_NONE = "Não há outros fãs de música por aí ainda."

--- New version notifications
msg.NEW_VERSION = "Uma nova versão do Musician foi lançada! Baixe a atualização de {url}."
msg.NEW_PROTOCOL_VERSION = "Sua versão do Musician está desatualizada e não funciona mais.\nFaça download da atualização em\n{url}"

-- Loading screen
msg.LOADING_SCREEN_MESSAGE = "Musician está pré-carregando as amostras do instrumento na memória cache…"
msg.LOADING_SCREEN_CLOSE_TOOLTIP = "Feche e continue pré-carregando em segundo plano."

--- Player tooltips
msg.PLAYER_TOOLTIP = "Musician"
msg.PLAYER_TOOLTIP_VERSION = "Musician v {version}"
msg.PLAYER_TOOLTIP_VERSION_OUTDATED = " (Desatualizado)"
msg.PLAYER_TOOLTIP_VERSION_INCOMPATIBLE = " (INCOMPATÍVEL)"
msg.PLAYER_TOOLTIP_PRELOADING = "Pré-carregando sons… ({progress})"

--- URL hyperlinks tooltip
msg.TOOLTIP_COPY_URL = "Pressione {shortcut} para copiar."

--- Song import
msg.INVALID_MUSIC_CODE = "Código de música inválido."
msg.PLAY_A_SONG = "Tocar uma musica"
msg.IMPORT_A_SONG = "Importar uma música"
msg.PASTE_MUSIC_CODE = "Importe sua música no formato MIDI em:\n{url}\n\ne cole o código da música aqui ({shortcut})…"
msg.SONG_IMPORTED = "Música carregada: {title}."

--- Play as a band
msg.PLAY_IN_BAND = "Toque como uma banda"
msg.PLAY_IN_BAND_HINT = "Clique aqui quando estiver pronto para tocar essa música com sua banda."
msg.PLAY_IN_BAND_READY_PLAYERS = "Membros da banda prontos:"
msg.EMOTE_PLAYER_IS_READY = "está pronto para tocar como uma banda."
msg.EMOTE_PLAYER_IS_NOT_READY = "não está mais pronto para tocar como uma banda."
msg.EMOTE_PLAY_IN_BAND_START = "começou a tocar banda."
msg.EMOTE_PLAY_IN_BAND_STOP = "parou de tocar a banda."

--- Play as a band (live)
msg.LIVE_SYNC = "Toque ao vivo como uma banda"
msg.LIVE_SYNC_HINT = "Clique aqui para ativar a sincronização de banda."
msg.SYNCED_PLAYERS = "Membros da banda ao vivo:"
msg.EMOTE_PLAYER_LIVE_SYNC_ENABLED = "está tocando música com você."
msg.EMOTE_PLAYER_LIVE_SYNC_DISABLED = "parou de tocar música com você."

--- Song editor frame
msg.SONG_EDITOR = "Editor de canções"
msg.MARKER_FROM = "A partir de"
msg.MARKER_TO = "Para"
msg.POSITION = "Posição"
msg.TRACK_NUMBER = "Pista # {track}"
msg.CHANNEL_NUMBER_SHORT = "Ch. {channel}"
msg.JUMP_PREV = "Back 10s"
msg.JUMP_NEXT = "Avançado 10s"
msg.GO_TO_START = "Vá para começar"
msg.GO_TO_END = "Vai para o fim"
msg.SET_CROP_FROM = "Definir ponto de início"
msg.SET_CROP_TO = "Definir ponto final"
msg.SYNCHRONIZE_TRACKS = "Sincronizar as configurações da faixa com a música atual"
msg.MUTE_TRACK = "Mudo"
msg.SOLO_TRACK = "Só"
msg.TRANSPOSE_TRACK = "Transpor (oitava)"
msg.CHANGE_TRACK_INSTRUMENT = "Alterar instrumento"
msg.HEADER_NUMBER = "#"
msg.HEADER_OCTAVE = "Oitava"
msg.HEADER_INSTRUMENT = "Instrumento"

--- Configure live keyboard frame
msg.SHOULD_CONFIGURE_KEYBOARD = "Você tem que configurar o teclado antes de jogar."
msg.CONFIGURE_KEYBOARD = "Configurar teclado"
msg.CONFIGURE_KEYBOARD_HINT = "Clique em uma tecla para definir…"
msg.CONFIGURE_KEYBOARD_HINT_COMPLETE = "A configuração do teclado está concluída.\nAgora você pode salvar suas alterações e começar a tocar música!"
msg.CONFIGURE_KEYBOARD_START_OVER = "Recomeçar"
msg.CONFIGURE_KEYBOARD_SAVE = "Salvar configuração"
msg.PRESS_KEY_BINDING = "Pressione a tecla # {col} na linha # {row}."
msg.KEY_CAN_BE_EMPTY = "Essa chave é opcional e pode estar vazia."
msg.KEY_IS_MERGEABLE = "Esta tecla pode ser igual à tecla {key} do seu teclado: {action}"
msg.KEY_CAN_BE_MERGED = "neste caso, apenas pressione a tecla {key}."
msg.KEY_CANNOT_BE_MERGED = "neste caso, apenas ignore e prossiga para a próxima chave."
msg.NEXT_KEY = "Próxima chave"
msg.CLEAR_KEY = "Chave limpa"

--- About frame
msg.ABOUT_TITLE = "Musician"
msg.ABOUT_VERSION = "versão {version}"
msg.ABOUT_AUTHOR = "Por LenweSaralonde - {url}"
msg.ABOUT_LICENSE = "Distribuído sob GNU General Public License v3.0"
msg.ABOUT_DISCORD = "Discord: {url}"
msg.ABOUT_SUPPORT = "Você gosta de Musician? Compartilhe com todos!"
msg.ABOUT_PATREON = "Torne-se um patrono: {url}"
msg.ABOUT_PAYPAL = "Doe: {url}"
msg.ABOUT_SUPPORTERS = "Agradecimentos especiais aos apoiadores do projeto <3"
msg.ABOUT_LOCALIZATION_TEAM = "Equipe de Tradução:"
msg.ABOUT_CONTRIBUTE_TO_LOCALIZATION = "Ajude-nos a traduzir Musician em seu idioma!\n{url}"

--- Fixed PC keyboard key names
msg.FIXED_KEY_NAMES[KEY.Backspace] = "Voltar"
msg.FIXED_KEY_NAMES[KEY.Tab] = "Aba"
msg.FIXED_KEY_NAMES[KEY.CapsLock] = "Caps Lock"
msg.FIXED_KEY_NAMES[KEY.Enter] = "Entrar"
msg.FIXED_KEY_NAMES[KEY.ShiftLeft] = "Mudança"
msg.FIXED_KEY_NAMES[KEY.ShiftRight] = "Mudança"
msg.FIXED_KEY_NAMES[KEY.ControlLeft] = "Ctrl"
msg.FIXED_KEY_NAMES[KEY.MetaLeft] = "Meta"
msg.FIXED_KEY_NAMES[KEY.AltLeft] = "Alt"
msg.FIXED_KEY_NAMES[KEY.Space] = "Espaço"
msg.FIXED_KEY_NAMES[KEY.AltRight] = "Alt"
msg.FIXED_KEY_NAMES[KEY.MetaRight] = "Meta"
msg.FIXED_KEY_NAMES[KEY.ContextMenu] = "Cardápio"
msg.FIXED_KEY_NAMES[KEY.ControlRight] = "Ctrl"
msg.FIXED_KEY_NAMES[KEY.Delete] = "Excluir"

--- Live keyboard layouts, based on musical modes
msg.KEYBOARD_LAYOUTS["Piano"] = "Piano"
msg.KEYBOARD_LAYOUTS["Chromatic"] = "Cromático"
msg.KEYBOARD_LAYOUTS["Modes"] = "Modos"
msg.KEYBOARD_LAYOUTS["Ionian"] = "Jônico"
msg.KEYBOARD_LAYOUTS["Dorian"] = "Dorian"
msg.KEYBOARD_LAYOUTS["Phrygian"] = "frígio"
msg.KEYBOARD_LAYOUTS["Lydian"] = "Lídio"
msg.KEYBOARD_LAYOUTS["Mixolydian"] = "Mixolídio"
msg.KEYBOARD_LAYOUTS["Aeolian"] = "Eólico"
msg.KEYBOARD_LAYOUTS["Locrian"] = "Locrian"
msg.KEYBOARD_LAYOUTS["minor Harmonic"] = "Harmônica menor"
msg.KEYBOARD_LAYOUTS["minor Melodic"] = "melódico menor"
msg.KEYBOARD_LAYOUTS["Blues scales"] = "Escalas de blues"
msg.KEYBOARD_LAYOUTS["Major Blues"] = "Major Blues"
msg.KEYBOARD_LAYOUTS["minor Blues"] = "Blues menor"
msg.KEYBOARD_LAYOUTS["Diminished scales"] = "Escalas diminuídas"
msg.KEYBOARD_LAYOUTS["Diminished"] = "Diminuída"
msg.KEYBOARD_LAYOUTS["Complement Diminished"] = "Complemento diminuído"
msg.KEYBOARD_LAYOUTS["Pentatonic scales"] = "Escalas pentatônicas"
msg.KEYBOARD_LAYOUTS["Major Pentatonic"] = "Pentatônico Maior"
msg.KEYBOARD_LAYOUTS["minor Pentatonic"] = "Pentatônico menor"
msg.KEYBOARD_LAYOUTS["World scales"] = "Escalas mundiais"
msg.KEYBOARD_LAYOUTS["Raga 1"] = "Raga 1"
msg.KEYBOARD_LAYOUTS["Raga 2"] = "Raga 2"
msg.KEYBOARD_LAYOUTS["Raga 3"] = "Raga 3"
msg.KEYBOARD_LAYOUTS["Arabic"] = "árabe"
msg.KEYBOARD_LAYOUTS["Spanish"] = "espanhol"
msg.KEYBOARD_LAYOUTS["Gypsy"] = "cigano"
msg.KEYBOARD_LAYOUTS["Egyptian"] = "egípcio"
msg.KEYBOARD_LAYOUTS["Hawaiian"] = "havaiano"
msg.KEYBOARD_LAYOUTS["Bali Pelog"] = "Bali Pelog"
msg.KEYBOARD_LAYOUTS["Japanese"] = "japonês"
msg.KEYBOARD_LAYOUTS["Ryukyu"] = "Ryukyu"
msg.KEYBOARD_LAYOUTS["Chinese"] = "chinês"
msg.KEYBOARD_LAYOUTS["Miscellaneous scales"] = "Escalas diversas"
msg.KEYBOARD_LAYOUTS["Bass Line"] = "Linha de baixo"
msg.KEYBOARD_LAYOUTS["Wholetone"] = "Wholetone"
msg.KEYBOARD_LAYOUTS["minor 3rd"] = "3ª menor"
msg.KEYBOARD_LAYOUTS["Major 3rd"] = "3ª maior"
msg.KEYBOARD_LAYOUTS["4th"] = "4º"
msg.KEYBOARD_LAYOUTS["5th"] = "5 ª"
msg.KEYBOARD_LAYOUTS["Octave"] = "Oitava"

--- Live keyboard layout types
msg.HORIZONTAL_LAYOUT = "Horizontal"
msg.VERTICAL_LAYOUT = "Vertical"

--- Live keyboard frame
msg.LIVE_SONG_NAME = "Musica ao vivo"
msg.SOLO_MODE = "Modo Solo"
msg.LIVE_MODE = "Modo Ao Vivo"
msg.LIVE_MODE_DISABLED = "O modo ao vivo é desativado durante a reprodução."
msg.ENABLE_SOLO_MODE = "Habilite o modo Solo (você joga para você)"
msg.ENABLE_LIVE_MODE = "Ative o modo ao vivo (você joga para todos)"
msg.PLAY_LIVE = "Tocar ao vivo"
msg.PLAY_SOLO = "Jogar sozinho"
msg.SHOW_KEYBOARD = "Mostrar teclado"
msg.HIDE_KEYBOARD = "Esconder teclado"
msg.KEYBOARD_LAYOUT = "Modo e escala do teclado"
msg.CHANGE_KEYBOARD_LAYOUT = "Alterar layout do teclado"
msg.BASE_KEY = "Chave de base"
msg.CHANGE_BASE_KEY = "Chave de base"
msg.CHANGE_LOWER_INSTRUMENT = "Mudar o instrumento inferior"
msg.CHANGE_UPPER_INSTRUMENT = "Mudar o instrumento superior"
msg.LOWER_INSTRUMENT_MAPPED_TO_CHANNEL = "Instrumento inferior (faixa # {track})"
msg.UPPER_INSTRUMENT_MAPPED_TO_CHANNEL = "Instrumento superior (faixa # {track})"
msg.SUSTAIN_KEY = "Sustentar"
msg.POWER_CHORDS = "Power chords"
msg.PROGRAM_BUTTON = "P {num}"
msg.EMPTY_PROGRAM = "Programa vazio"
msg.LOAD_PROGRAM_NUM = "Carregar programa # {num} ({key})"
msg.SAVE_PROGRAM_NUM = "Salvar no programa nº {num} ({key})"
msg.DELETE_PROGRAM_NUM = "Apagar programa nº {num} ({key})"
msg.WRITE_PROGRAM = "Salvar programa ({key})"
msg.DELETE_PROGRAM = "Excluir programa ({key})"
msg.PROGRAM_SAVED = "Programa nº {num} salvo."
msg.PROGRAM_DELETED = "Programa nº {num} apagado."
msg.DEMO_MODE_ENABLED = "Modo de demonstração do teclado habilitado:\n{mapping}"
msg.DEMO_MODE_MAPPING = "{layer} → Track # {track}"
msg.DEMO_MODE_DISABLED = "Modo de demonstração do teclado desativado."

--- Live keyboard layers
msg.LAYERS[Musician.KEYBOARD_LAYER.UPPER] = "Superior"
msg.LAYERS[Musician.KEYBOARD_LAYER.LOWER] = "Diminuir"

--- Chat emotes
msg.EMOTE_PLAYING_MUSIC = "está tocando uma música."
msg.EMOTE_PROMO = "(Obtenha o add-on “Musician” para ouvir)"
msg.EMOTE_SONG_NOT_LOADED = "(A música não pode ser reproduzida porque {player} está usando uma versão incompatível.)"
msg.EMOTE_PLAYER_OTHER_REALM = "(Este jogador está em outro reino.)"
msg.EMOTE_PLAYER_OTHER_FACTION = "(Este jogador é de outra facção.)"

--- Minimap button tooltips
msg.TOOLTIP_LEFT_CLICK = "** Clique com o botão esquerdo **: {action}"
msg.TOOLTIP_RIGHT_CLICK = "** Clique com o botão direito **: {action}"
msg.TOOLTIP_DRAG_AND_DROP = "** Arraste e solte ** para mover"
msg.TOOLTIP_ISMUTED = "(mudo)"
msg.TOOLTIP_ACTION_OPEN_MENU = "Abra o menu principal"
msg.TOOLTIP_ACTION_MUTE = "Silenciar todas as músicas"
msg.TOOLTIP_ACTION_UNMUTE = "Música com som"

--- Player menu options
msg.PLAYER_MENU_TITLE = "Música"
msg.PLAYER_MENU_STOP_CURRENT_SONG = "Parar a música atual"
msg.PLAYER_MENU_MUTE = "Mudo"
msg.PLAYER_MENU_UNMUTE = "Com som"

--- Player actions feedback
msg.PLAYER_IS_MUTED = "{icon} {player} agora está mudo."
msg.PLAYER_IS_UNMUTED = "{icon} {player} agora está com som."

--- Song links
msg.LINKS_PREFIX = "Música"
msg.LINKS_FORMAT = "{prefix}: {title}"
msg.LINKS_LINK_BUTTON = "Link"
msg.LINKS_CHAT_BUBBLE = "“{note} {title}”"

--- Song link export frame
msg.LINK_EXPORT_WINDOW_TITLE = "Criar link de música"
msg.LINK_EXPORT_WINDOW_SONG_TITLE_LABEL = "Título da música:"
msg.LINK_EXPORT_WINDOW_HINT = "O link permanecerá ativo até que você saia ou recarregue a interface."
msg.LINK_EXPORT_WINDOW_PROGRESS = "Gerando link… {progress}%"
msg.LINK_EXPORT_WINDOW_POST_BUTTON = "Postar link no chat"

--- Song link import frame
msg.LINK_IMPORT_WINDOW_TITLE = "Importar música do {player}:"
msg.LINK_IMPORT_WINDOW_HINT = "Clique em “Importar” para começar a importar a música para o Musician."
msg.LINK_IMPORT_WINDOW_IMPORT_BUTTON = "Importar música"
msg.LINK_IMPORT_WINDOW_CANCEL_IMPORT_BUTTON = "Cancelar importação"
msg.LINK_IMPORT_WINDOW_REQUESTING = "Solicitando música de {player}…"
msg.LINK_IMPORT_WINDOW_PROGRESS = "Importando… {progress}%"
msg.LINK_IMPORT_WINDOW_SELECT_ACCOUNT = "Selecione o personagem de onde recuperar a música:"

--- Song links errors
msg.LINKS_ERROR.notFound = "A música “{title}” não está disponível no {player}."
msg.LINKS_ERROR.alreadySending = "Uma música já está sendo enviada para você por {player}. Tente novamente em alguns segundos."
msg.LINKS_ERROR.alreadyRequested = "Uma música já está sendo solicitada de {player}."
msg.LINKS_ERROR.timeout = "{player} não respondeu."
msg.LINKS_ERROR.offline = "{player} não está conectado ao World of Warcraft."
msg.LINKS_ERROR.importingFailed = "A música {title} não pôde ser importada de {player}."

--- Map tracking options
msg.MAP_OPTIONS_TITLE = "Mapa"
msg.MAP_OPTIONS_SUB_TEXT = "Mostrar músicos próximos tocando:"
msg.MAP_OPTIONS_MINI_MAP = "No minimapa"
msg.MAP_OPTIONS_WORLD_MAP = "No mapa mundial"
msg.MAP_TRACKING_OPTIONS_TITLE = "Musician"
msg.MAP_TRACKING_OPTION_ACTIVE_MUSICIANS = "Musicians tocando"

--- Total RP Extended module
msg.TRPE_ITEM_NAME = "{title}"
msg.TRPE_ITEM_TOOLTIP_REQUIRES_MUSICIAN = "Requer Musician"
msg.TRPE_ITEM_TOOLTIP_SHEET_MUSIC = "Partitura"
msg.TRPE_ITEM_USE_HINT = "Leia a partitura"
msg.TRPE_ITEM_MUSICIAN_NOT_FOUND = "Você precisa instalar a versão mais recente do complemento “Musician” para poder usar este item.\nObtenha em {url}"
msg.TRPE_ITEM_NOTES = "Importe a música para o Musician para tocá-la para os jogadores próximos.\n\nBaixar Musician: {url}\n"

msg.TRPE_EXPORT_BUTTON = "Exportar"
msg.TRPE_EXPORT_WINDOW_TITLE = "Exportar música como um item do Total RP"
msg.TRPE_EXPORT_WINDOW_LOCALE = "Idioma do item:"
msg.TRPE_EXPORT_WINDOW_ADD_TO_BAG = "Adicione à sua bolsa"
msg.TRPE_EXPORT_WINDOW_QUANTITY = "Quantidade:"
msg.TRPE_EXPORT_WINDOW_HINT_NEW = "Crie um item de partitura no Total RP que pode ser negociado com outros jogadores."
msg.TRPE_EXPORT_WINDOW_HINT_EXISTING = "Já existe um item para esta música, ele será atualizado."
msg.TRPE_EXPORT_WINDOW_CREATE_ITEM_BUTTON = "Criar item"
msg.TRPE_EXPORT_WINDOW_PROGRESS = "Criando item… {progress}%"

--- Musician instrument names
msg.INSTRUMENT_NAMES["none"] = "(Nenhum)"
msg.INSTRUMENT_NAMES["accordion"] = "Acordeão"
msg.INSTRUMENT_NAMES["bagpipe"] = "Gaita de foles"
msg.INSTRUMENT_NAMES["dulcimer"] = "Dulcimer (martelado)"
msg.INSTRUMENT_NAMES["piano"] = "Piano"
msg.INSTRUMENT_NAMES["lute"] = "Alaúde"
msg.INSTRUMENT_NAMES["viola_da_gamba"] = "Viola da gamba"
msg.INSTRUMENT_NAMES["harp"] = "Harpa celta"
msg.INSTRUMENT_NAMES["male_voice"] = "Voz masculina (tenor)"
msg.INSTRUMENT_NAMES["female_voice"] = "Voz feminina (soprano)"
msg.INSTRUMENT_NAMES["trumpet"] = "Trompete"
msg.INSTRUMENT_NAMES["sackbut"] = "Sackbut"
msg.INSTRUMENT_NAMES["war_horn"] = "Trompa de guerra"
msg.INSTRUMENT_NAMES["bassoon"] = "Fagote"
msg.INSTRUMENT_NAMES["clarinet"] = "Clarinete"
msg.INSTRUMENT_NAMES["recorder"] = "Gravador"
msg.INSTRUMENT_NAMES["fiddle"] = "Violino"
msg.INSTRUMENT_NAMES["percussions"] = "Percussões (tradicionais)"
msg.INSTRUMENT_NAMES["distortion_guitar"] = "Guitarra de distorção"
msg.INSTRUMENT_NAMES["clean_guitar"] = "Guitarra limpa"
msg.INSTRUMENT_NAMES["bass_guitar"] = "Baixo"
msg.INSTRUMENT_NAMES["drumkit"] = "Kit de bateria"
msg.INSTRUMENT_NAMES["war_drum"] = "Tambor de guerra"
msg.INSTRUMENT_NAMES["woodblock"] = "Bloco de madeira"
msg.INSTRUMENT_NAMES["tambourine_shake"] = "Pandeiro (agitado)"

--- General MIDI instrument names
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGrandPiano] = "Piano de cauda acústico"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrightAcousticPiano] = "Piano acústico brilhante"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGrandPiano] = "Piano de cauda elétrico"
msg.MIDI_INSTRUMENT_NAMES[Instrument.HonkyTonkPiano] = "Piano Honky-tonk"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricPiano1] = "Piano elétrico 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricPiano2] = "Piano elétrico 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Harpsichord] = "Cravo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Clavi] = "Clavi"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Celesta] = "Celesta"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Glockenspiel] = "Glockenspiel"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MusicBox] = "Caixa de música"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Vibraphone] = "Vibrafone"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Marimba] = "Marimba"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Xylophone] = "Xilofone"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TubularBells] = "Sinos tubulares"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Dulcimer] = "Dulcimer"
msg.MIDI_INSTRUMENT_NAMES[Instrument.DrawbarOrgan] = "Órgão de drawbar"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PercussiveOrgan] = "Órgão percussivo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.RockOrgan] = "Órgão de rock"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ChurchOrgan] = "Órgão da igreja"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ReedOrgan] = "Órgão de junco"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Accordion] = "Acordeão"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Harmonica] = "Harmônica"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TangoAccordion] = "Acordeão de tango"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGuitarNylon] = "Violão (nylon)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticGuitarSteel] = "Violão (aço)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarJazz] = "Guitarra elétrica (jazz)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarClean] = "Guitarra elétrica (limpa)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricGuitarMuted] = "Guitarra elétrica (sem som)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OverdrivenGuitar] = "Guitarra com overdrive"
msg.MIDI_INSTRUMENT_NAMES[Instrument.DistortionGuitar] = "Guitarra de distorção"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Guitarharmonics] = "Harmônicos de guitarra"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AcousticBass] = "Baixo acústico"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricBassFinger] = "Baixo elétrico (dedilhado)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectricBassPick] = "Baixo elétrico (escolhido)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FretlessBass] = "Baixo Fretless"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SlapBass1] = "Slap bass 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SlapBass2] = "Slap bass 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBass1] = "Synth bass 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBass2] = "Synth bass 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Violin] = "Violino"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Viola] = "Viola"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Cello] = "Violoncelo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Contrabass] = "Contrabaixo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TremoloStrings] = "Cordas tremolo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PizzicatoStrings] = "Cordas de pizzicato"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestralHarp] = "Harpa orquestral"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Timpani] = "Tímpanos"
msg.MIDI_INSTRUMENT_NAMES[Instrument.StringEnsemble1] = "Conjunto de cordas 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.StringEnsemble2] = "Conjunto de cordas 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthStrings1] = "Strings de sintetizador 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthStrings2] = "Strings de sintetizador 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ChoirAahs] = "Coro aahs"
msg.MIDI_INSTRUMENT_NAMES[Instrument.VoiceOohs] = "Voz oohs"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthVoice] = "Voz de sintetizador"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestraHit] = "Sucesso de orquestra"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Trumpet] = "Trompete"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Trombone] = "Trombone"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Tuba] = "Tuba"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MutedTrumpet] = "Trompete silenciado"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FrenchHorn] = "Trompa francesa"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrassSection] = "Seção de latão"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBrass1] = "Latão sintético 1"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthBrass2] = "Latão sintético 2"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SopranoSax] = "Sax soprano"
msg.MIDI_INSTRUMENT_NAMES[Instrument.AltoSax] = "Sax alto"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TenorSax] = "Sax tenor"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BaritoneSax] = "Sax barítono"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Oboe] = "Oboé"
msg.MIDI_INSTRUMENT_NAMES[Instrument.EnglishHorn] = "chifre Inglês"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Bassoon] = "Fagote"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Clarinet] = "Clarinete"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Piccolo] = "Flautim"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Flute] = "Flauta"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Recorder] = "Gravador"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PanFlute] = "Flauta pan"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BlownBottle] = "Garrafa estourada"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shakuhachi] = "Shakuhachi"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Whistle] = "Apito"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Ocarina] = "Ocarina"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead1Square] = "Lead 1 (quadrado)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead2Sawtooth] = "Lead 2 (dente de serra)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead3Calliope] = "Lead 3 (calliope)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead4Chiff] = "Lead 4 (chiff)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead5Charang] = "Lead 5 (charang)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead6Voice] = "Lead 6 (voz)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead7Fifths] = "Lead 7 (quintos)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Lead8BassLead] = "Lead 8 (baixo + lead)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad1Newage] = "Pad 1 (nova era)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad2Warm] = "Almofada 2 (quente)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad3Polysynth] = "Pad 3 (polissintetizador)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad4Choir] = "Bloco 4 (coro)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad5Bowed] = "Almofada 5 (curvada)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad6Metallic] = "Almofada 6 (metálica)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad7Halo] = "Pad 7 (halo)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Pad8Sweep] = "Pad 8 (varredura)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX1Rain] = "FX 1 (chuva)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX2Soundtrack] = "FX 2 (trilha sonora)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX3Crystal] = "FX 3 (cristal)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX4Atmosphere] = "FX 4 (atmosfera)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX5Brightness] = "FX 5 (brilho)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX6Goblins] = "FX 6 (goblins)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX7Echoes] = "FX 7 (ecos)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.FX8SciFi] = "FX 8 (ficção científica)"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Sitar] = "Cítara"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Banjo] = "Banjo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shamisen] = "Shamisen"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Koto] = "Koto"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Kalimba] = "Kalimba"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Bagpipe] = "Tubo de saco"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Fiddle] = "Violino"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Shanai] = "Shanai"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TinkleBell] = "Tinir sino"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Agogo] = "Agogo"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SteelDrums] = "Tambores de aço"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Woodblock] = "Bloco de madeira"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TaikoDrum] = "Tambor taiko"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MelodicTom] = "Tom melódico"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SynthDrum] = "Tambor sintetizador"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ReverseCymbal] = "Prato reverso"
msg.MIDI_INSTRUMENT_NAMES[Instrument.GuitarFretNoise] = "Ruído de traste de guitarra"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BreathNoise] = "Ruído de respiração"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Seashore] = "Beira Mar"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BirdTweet] = "Tweet de pássaro"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TelephoneRing] = "Toque de telefone"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Helicopter] = "Helicóptero"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Applause] = "Aplausos"
msg.MIDI_INSTRUMENT_NAMES[Instrument.Gunshot] = "Tiro"

--- General MIDI drum kit names
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_INSTRUMENT_NAMES[Instrument.StandardKit] = "Kit de bateria padrão"
msg.MIDI_INSTRUMENT_NAMES[Instrument.RoomKit] = "Kit de bateria da sala"
msg.MIDI_INSTRUMENT_NAMES[Instrument.PowerKit] = "Kit de bateria poderosa"
msg.MIDI_INSTRUMENT_NAMES[Instrument.ElectronicKit] = "Kit de bateria eletrônica"
msg.MIDI_INSTRUMENT_NAMES[Instrument.TR808Kit] = "TR-808 drum machine"
msg.MIDI_INSTRUMENT_NAMES[Instrument.JazzKit] = "Kit de bateria de jazz"
msg.MIDI_INSTRUMENT_NAMES[Instrument.BrushKit] = "Brush drum kit"
msg.MIDI_INSTRUMENT_NAMES[Instrument.OrchestraKit] = "Kit de bateria de orquestra"
msg.MIDI_INSTRUMENT_NAMES[Instrument.SoundFXKit] = "Sound FX"
msg.MIDI_INSTRUMENT_NAMES[Instrument.MT32Kit] = "Kit de bateria MT-32"
msg.MIDI_INSTRUMENT_NAMES[Instrument.None] = "(Nenhum)"
msg.UNKNOWN_DRUMKIT = "Kit de bateria desconhecido ({midi})"

--- General MIDI percussion list
-- Check out Wikipedia in your own language to get the list.
msg.MIDI_PERCUSSION_NAMES[Percussion.Laser] = "Laser" -- MIDI key 27
msg.MIDI_PERCUSSION_NAMES[Percussion.Whip] = "Chicote" -- MIDI key 28
msg.MIDI_PERCUSSION_NAMES[Percussion.ScratchPush] = "Scratch push" -- MIDI key 29
msg.MIDI_PERCUSSION_NAMES[Percussion.ScratchPull] = "Arranhão" -- MIDI key 30
msg.MIDI_PERCUSSION_NAMES[Percussion.StickClick] = "Clique do stick" -- MIDI key 31
msg.MIDI_PERCUSSION_NAMES[Percussion.SquareClick] = "Clique quadrado" -- MIDI key 32
msg.MIDI_PERCUSSION_NAMES[Percussion.MetronomeClick] = "Clique do metrônomo" -- MIDI key 33
msg.MIDI_PERCUSSION_NAMES[Percussion.MetronomeBell] = "Sino metrônomo" -- MIDI key 34
msg.MIDI_PERCUSSION_NAMES[Percussion.AcousticBassDrum] = "Bumbo acústico" -- MIDI key 35
msg.MIDI_PERCUSSION_NAMES[Percussion.BassDrum1] = "Bombo 1" -- MIDI key 36
msg.MIDI_PERCUSSION_NAMES[Percussion.SideStick] = "Vara lateral" -- MIDI key 37
msg.MIDI_PERCUSSION_NAMES[Percussion.AcousticSnare] = "Laço acústico" -- MIDI key 38
msg.MIDI_PERCUSSION_NAMES[Percussion.HandClap] = "Palmas" -- MIDI key 39
msg.MIDI_PERCUSSION_NAMES[Percussion.ElectricSnare] = "Laço elétrico" -- MIDI key 40
msg.MIDI_PERCUSSION_NAMES[Percussion.LowFloorTom] = "Tom de piso baixo" -- MIDI key 41
msg.MIDI_PERCUSSION_NAMES[Percussion.ClosedHiHat] = "Chimbal fechado" -- MIDI key 42
msg.MIDI_PERCUSSION_NAMES[Percussion.HighFloorTom] = "Tom de andar alto" -- MIDI key 43
msg.MIDI_PERCUSSION_NAMES[Percussion.PedalHiHat] = "Chimbal de pedal" -- MIDI key 44
msg.MIDI_PERCUSSION_NAMES[Percussion.LowTom] = "Tom baixo" -- MIDI key 45
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenHiHat] = "Chimbal aberto" -- MIDI key 46
msg.MIDI_PERCUSSION_NAMES[Percussion.LowMidTom] = "Tom médio baixo" -- MIDI key 47
msg.MIDI_PERCUSSION_NAMES[Percussion.HiMidTom] = "Hi-mid tom" -- MIDI key 48
msg.MIDI_PERCUSSION_NAMES[Percussion.CrashCymbal1] = "Crash cymbal 1" -- MIDI key 49
msg.MIDI_PERCUSSION_NAMES[Percussion.HighTom] = "Tom alto" -- MIDI key 50
msg.MIDI_PERCUSSION_NAMES[Percussion.RideCymbal1] = "Ride cymbal 1" -- MIDI key 51
msg.MIDI_PERCUSSION_NAMES[Percussion.ChineseCymbal] = "Prato chinês" -- MIDI key 52
msg.MIDI_PERCUSSION_NAMES[Percussion.RideBell] = "Ride bell" -- MIDI key 53
msg.MIDI_PERCUSSION_NAMES[Percussion.Tambourine] = "Pandeiro" -- MIDI key 54
msg.MIDI_PERCUSSION_NAMES[Percussion.SplashCymbal] = "Prato splash" -- MIDI key 55
msg.MIDI_PERCUSSION_NAMES[Percussion.Cowbell] = "Sino de vaca" -- MIDI key 56
msg.MIDI_PERCUSSION_NAMES[Percussion.CrashCymbal2] = "Crash cymbal 2" -- MIDI key 57
msg.MIDI_PERCUSSION_NAMES[Percussion.Vibraslap] = "Vibraslap" -- MIDI key 58
msg.MIDI_PERCUSSION_NAMES[Percussion.RideCymbal2] = "Ride cymbal 2" -- MIDI key 59
msg.MIDI_PERCUSSION_NAMES[Percussion.HiBongo] = "Oi bongô" -- MIDI key 60
msg.MIDI_PERCUSSION_NAMES[Percussion.LowBongo] = "Bongô baixo" -- MIDI key 61
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteHiConga] = "Mudo oi conga" -- MIDI key 62
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenHiConga] = "Abra oi conga" -- MIDI key 63
msg.MIDI_PERCUSSION_NAMES[Percussion.LowConga] = "Conga baixa" -- MIDI key 64
msg.MIDI_PERCUSSION_NAMES[Percussion.HighTimbale] = "Alto timbale" -- MIDI key 65
msg.MIDI_PERCUSSION_NAMES[Percussion.LowTimbale] = "Baixo timbale" -- MIDI key 66
msg.MIDI_PERCUSSION_NAMES[Percussion.HighAgogo] = "Alto agogo" -- MIDI key 67
msg.MIDI_PERCUSSION_NAMES[Percussion.LowAgogo] = "Baixo agogo" -- MIDI key 68
msg.MIDI_PERCUSSION_NAMES[Percussion.Cabasa] = "Cabasa" -- MIDI key 69
msg.MIDI_PERCUSSION_NAMES[Percussion.Maracas] = "Maracás" -- MIDI key 70
msg.MIDI_PERCUSSION_NAMES[Percussion.ShortWhistle] = "Apito curto" -- MIDI key 71
msg.MIDI_PERCUSSION_NAMES[Percussion.LongWhistle] = "Apito longo" -- MIDI key 72
msg.MIDI_PERCUSSION_NAMES[Percussion.ShortGuiro] = "Guiro curto" -- MIDI key 73
msg.MIDI_PERCUSSION_NAMES[Percussion.LongGuiro] = "Guiro longo" -- MIDI key 74
msg.MIDI_PERCUSSION_NAMES[Percussion.Claves] = "Claves" -- MIDI key 75
msg.MIDI_PERCUSSION_NAMES[Percussion.HiWoodBlock] = "Oi bloco de madeira" -- MIDI key 76
msg.MIDI_PERCUSSION_NAMES[Percussion.LowWoodBlock] = "Bloco de madeira baixo" -- MIDI key 77
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteCuica] = "Cuica muda" -- MIDI key 78
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenCuica] = "Cuica aberta" -- MIDI key 79
msg.MIDI_PERCUSSION_NAMES[Percussion.MuteTriangle] = "Triângulo mudo" -- MIDI key 80
msg.MIDI_PERCUSSION_NAMES[Percussion.OpenTriangle] = "Triângulo aberto" -- MIDI key 81
msg.MIDI_PERCUSSION_NAMES[Percussion.Shaker] = "Shaker" -- MIDI key 82
msg.MIDI_PERCUSSION_NAMES[Percussion.SleighBell] = "Sino de trenó" -- MIDI key 83
msg.MIDI_PERCUSSION_NAMES[Percussion.BellTree] = "Árvore do sino" -- MIDI key 84
msg.MIDI_PERCUSSION_NAMES[Percussion.Castanets] = "Castanholas" -- MIDI key 85
msg.MIDI_PERCUSSION_NAMES[Percussion.SurduDeadStroke] = "Golpe morto Surdu" -- MIDI key 86
msg.MIDI_PERCUSSION_NAMES[Percussion.Surdu] = "Surdu" -- MIDI key 87
msg.MIDI_PERCUSSION_NAMES[Percussion.SnareDrumRod] = "Tarola" -- MIDI key 88
msg.MIDI_PERCUSSION_NAMES[Percussion.OceanDrum] = "Tambor do oceano" -- MIDI key 89
msg.MIDI_PERCUSSION_NAMES[Percussion.SnareDrumBrush] = "Escova de tarola" -- MIDI key 90