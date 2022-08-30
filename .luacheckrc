max_line_length = false

exclude_files = {
	"lib",
};

ignore = {
	-- Ignore global writes/accesses/mutations on anything prefixed with
	-- "Musician". This is the standard prefix for all of our global frame names
	-- and mixins.
	"11./^Musician",

	-- Ignore unused self. This would popup for Mixins and Objects
	"212/self",

	-- Ignore unused event. This would popup for event handlers
	"212/event",

	-- Ignore unused frame. This would popup for onUpdate handlers
	"212/frame",

	-- Ignore unused chat message handler variables.
	"212/prefix",
	"212/distribution",

	-- Ignore Live play handler variables.
	"212/isChordNote",

	-- Ignore unused link. This would popup for hyperlink handlers
	"212/link",
};

globals = {
	"Musician",

	-- Globals
	"SLASH_MUSICIAN1",
	"SLASH_MUSICIAN2",
	"SLASH_MUSICIAN3",

	-- AddOn Overrides
	TRP3_PlayerMapPinMixin = {
		fields = {
			"GetDisplayDataFromPoiInfo"
		},
	},
	TRP3_API = {
		fields = {
			script = {
				fields = {
					"executeClassScript",
					"clearRootCompilation" -- Accessed only
				}
			},
			ui = {
				fields = {
					frame = {
						fields = {
							"createTabPanel"
						}
					},
					"tooltip" -- Accessed only
				}
			}
		},
	},
	TRP3_DB = {
		fields = {
			"my",
			"global", -- Accessed only
			"modes", -- Accessed only
			"types" -- Accessed only
		}
	}
};

read_globals = {
	-- Libraries
	"LibStub",

	"MSA_DropDownMenu_Initialize",
	"MSA_ToggleDropDownMenu",
	"MSA_DropDownMenu_AddButton",
	"MSA_DropDownMenu_SetText",
	"MSA_DropDownMenu_CreateInfo",
	"MSA_DropDownMenu_EnableDropDown",
	"MSA_DropDownMenu_DisableDropDown",
	"MSA_CloseDropDownMenus",
	"MSA_DropDownList1",
	"MSA_DropDownList2",

	-- 3rd party add-ons
	"ElvUI",
	"CrossRP",
	"KuiNameplates",
	"NeatPlates",
	"TidyPlates",
	"TidyPlatesThreat",
	"Plater",

	"mrp",
	"msp",

	"AddOn_TotalRP3",
	"TRP3_API",
	"TRP3_CharacterTooltip",
	"TRP3_BlizzardNamePlates",
	"TRP3_PlayerMapPinMixin",

	"TRP3_InventoryPage",
	"TRP3_ItemTooltip",
	"TRP3_RefTooltip",
	"TRP3_ToolFrameItemNormalTabPanel",
};

std = "lua51+wow";

stds.wow = {
	-- Globals that we mutate.
	globals = {
		ItemRefTooltip = {
			fields = {
				"SetHyperlink"
			}
		},

		"HandleModifiedItemClick",
		"SlashCmdList",
		"GetPlayerLink",
		"SubstituteChatMessageBeforeSend",
		"GetNumTrackingTypes",
		"GetTrackingInfo",
	},

	-- Globals that we access.
	read_globals = {
		-- Lua function aliases and extensions

		bit = {
			fields = {
				"band",
				"bor",
				"bxor",
			},
		},

		string = {
			fields = {
				"concat",
				"join",
				"split",
				"trim",
				"utf8sub", -- Added by the UTF8 library.
			},
		},

		table = {
			fields = {
				"wipe",
			},
		},

		"date",
		"floor",
		"ceil",
		"format",
		"sort",
		"strconcat",
		"strjoin",
		"strlen",
		"strlenutf8",
		"strsplit",
		"strtrim",
		"strupper",
		"strlower",
		"tAppendAll",
		"tContains",
		"tFilter",
		"time",
		"tinsert",
		"tInvert",
		"tremove",
		"wipe",
		"max",
		"min",
		"abs",
		"random",
		"Lerp",
		"sin",
		"cos",

		-- Global Functions

		C_ChatInfo = {
			fields = {
				"GetChannelShortcut",
				"SwapChatChannelsByChannelIndex"
			},
		},

		C_Timer = {
			fields = {
				"After",
				"NewTicker",
				"NewTimer"
			}
		},

		C_ChatBubbles = {
			fields = {
				"GetAllChatBubbles"
			}
		},

		C_CVar = {
			fields = {
				"GetCVar",
				"GetCVarBool",
			}
		},

		C_BattleNet = {
			fields = {
				"GetFriendNumGameAccounts",
				"GetFriendGameAccountInfo",
				"GetFriendAccountInfo",
				"GetAccountInfoByID",
				"GetGameAccountInfoByID",
			}
		},

		C_PlayerInfo = {
			fields = {
				"IsConnected"
			}
		},

		C_Map = {
			fields = {
				"GetMapPosFromWorldPos",
				"GetMapInfo"
			}
		},

		C_NamePlate = {
			fields = {
				"GetNamePlates",
				"GetNamePlateForUnit",
			}
		},

		"message",
		"debugprofilestop",
		"hooksecurefunc",
		"IsWindowsClient",
		"IsMacClient",
		"IsLinuxClient",
		"IsLoggedIn",
		"GetTime",
		"GetChannelList",
		"ChatConfigChannelSettings_SwapChannelsByIndex",
		"ChatFrame_AddMessageEventFilter",
		"JoinTemporaryChannel",
		"IsInInstance",
		"IsTrialAccount",
		"IsInGroup",
		"IsInRaid",
		"IsModifiedClick",
		"InCombatLockdown",
		"GetChannelName",
		"ListChannelByName",
		"UnitIsDead",
		"UnitIsGhost",
		"UnitName",
		"UnitGUID",
		"UnitInRange",
		"UnitIsConnected",
		"UnitInParty",
		"UnitPosition",
		"UnitFactionGroup",
		"UnitIsFriend",
		"UnitIsUnit",
		"UnitRace",
		"GetUnitName",
		"UnitAffectingCombat",
		"UnitHealth",
		"UnitHealthMax",
		"GetBindingText",
		"GetBindingKey",
		"GetBindingFromClick",
		"Mixin",
		"CreateFrame",
		"CreateFramePool",
		"GetLocale",
		"PlaySound",
		"PlaySoundFile",
		"StopSound",
		"PlayMusic",
		"StopMusic",
		"MuteSoundFile",
		"UnmuteSoundFile",
		"Sound_GameSystem_RestartSoundSystem",
		"UnitIsPlayer",
		"GetNormalizedRealmName",
		"GetAutoCompleteRealms",
		"GetNumLanguages",
		"GetDefaultLanguage",
		"GetLanguageByIndex",
		"GetAddOnMetadata",
		"GetCVar",
		"GetCVarBool",
		"SetCVar",
		"UIDropDownMenu_AddSeparator",
		"UIDropDownMenu_CreateInfo",
		"UIDropDownMenu_AddButton",
		"BNGetNumFriends",
		"BNGetNumFriendGameAccounts",
		"BNGetFriendGameAccountInfo",
		"BNGetFriendInfo",
		"BNGetFriendInfoByID",
		"BNGetGameAccountInfo",
		"BNGetFriendIndex",
		"ChatFrame_OnEvent",
		"SendChatMessage",
		"ChatEdit_LinkItem",
		"CreateVector2D",
		"MiniMapTracking_Update",
		"CreateFromMixins",
		"CompactUnitFrame_UpdateWidgetsOnlyMode",
		"BindingButtonTemplate_SetSelected",
		"GetCameraZoom",
		"SetInWorldUIVisibility",
		"ExecuteFrameScript",
		"HideUIPanel",
		"ToggleFrame",
		"IsMouseButtonDown",
		"IsShiftKeyDown",
		"IsControlKeyDown",
		"IsMetaKeyDown",
		"IsAltKeyDown",
		"InterfaceOptions_AddCategory",
		"BlizzardOptionsPanel_RegisterControl",
		"BlizzardOptionsPanel_SetupDependentControl",
		"InterfaceOptionsFrame_Show",
		"InterfaceOptionsFrame_OpenToCategory",

		-- Global Mixins and UI Objects

		ColorPickerFrame = {
			fields = {
				"GetColorRGB",
				"SetColorRGB",
			},
		},

		GameTooltip = {
			fields = {
				"HookScript",
				"GetUnit",
				"GetOwner",
				"SetOwner",
				"SetText",
				"Show",
				"Hide"
			}
		},

		DEFAULT_CHAT_FRAME = {
			fields = {
				"AddMessage",
			}
		},

		PlayerLocation = {
			fields = {
				"CreateFromGUID"
			}
		},

		BaseMapPoiPinMixin = {
			fields = {
				"OnLoad",
				"OnAcquired",
			}
		},

		"UIParent",
		"WorldFrame",
		"WorldMapFrame",
		"Minimap",
		"GameFontNormal",
		"GameFontDisable",
		"GameFontHighlight",
		"GameFontNormalSmall",
		"GameFontDisableSmall",
		"GameTooltipTextSmall",

		-- Global Constants
		"LE_PARTY_CATEGORY_INSTANCE",
		"LE_EXPANSION_LEVEL_CURRENT",
		"MAX_WOW_CHAT_CHANNELS",
		"UIDROPDOWNMENU_MENU_LEVEL",
		"WRONG_PASSWORD",
		"RED_FONT_COLOR",
		"ORANGE_FONT_COLOR",
		"NORMAL_FONT_COLOR",
		"DIM_RED_FONT_COLOR",
		"GRAY_FONT_COLOR",
		"LIGHTBLUE_FONT_COLOR",
		"WOW_PROJECT_ID",
		"WOW_PROJECT_MAINLINE",
		"WOW_PROJECT_CLASSIC",
		"NUM_CHAT_WINDOWS",
		"CONTROLTYPE_CHECKBOX",
		"SOUNDKIT",
		"UNKNOWN",
		"PI",
	},
};
