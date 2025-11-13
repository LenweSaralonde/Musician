max_line_length = false

exclude_files = {
	"lib/AceAddon-3.0",
	"lib/AceComm-3.0",
	"lib/AceEvent-3.0",
	"lib/CallbackHandler-1.0",
	"lib/HereBeDragons",
	"lib/LibBase64",
	"lib/LibCRC32",
	"lib/LibDataBroker-1.10",
	"lib/LibDBIcon-1.0",
	"lib/LibDeflate",
	"lib/LibRealmInfo",
	"lib/LibStub",
	"lib/MSA-DropDownMenu-1.0",
}

ignore = {
	-- Ignore global writes/accesses/mutations on anything prefixed with "Musician".
	-- This is the standard prefix for all of our global frame names and mixins.
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

	-- Ignore unused link and linkData. This would popup for hyperlink handlers
	"212/link",
	"212/linkData",

	-- Ignore empty then statements.
	"542",
}

globals = {
	"Musician",

	-- Globals
	"SLASH_MUSICIAN1",
	"SLASH_MUSICIAN2",
	"SLASH_MUSICIAN3",

	-- Custom libraries
	"BNetChatThrottleLib",

	-- AddOn Overrides
	TRP3_PlayerMapPinMixin = {
		fields = {
			"Decorate",
			"GetDisplayDataFromPoiInfo"
		},
	},
	TRP3_RefTooltip = {
		fields = {
			"Show"
		}
	},
	TRP3_API = {
		fields = {
			"CreateColorFromHexString", -- Accessed only
			"RegisterCallback", -- Accessed only
			globals = {
				fields = {
					"empty",    -- Accessed only
					"player_id", -- Accessed only
					"extended_version", -- Accessed only
					"extended_display_version" -- Accessed only
				}
			},
			configuration = {
				fields = {
					"getValue" -- Accessed only
				}
			},
			extended = {
				fields = {
					"unregisterObject", -- Accessed only
					"registerObject", -- Accessed only
					tools = {
						fields = {
							"getBlankItemData" -- Accessed only
						}
					}
				},
			},
			utils = {
				fields = {
					str = {
						fields = {
							"id" -- Accessed only
						}
					}
				}
			},
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
			},
			inventory = {
				fields = {
					"addItem", -- Accessed only
					"showItemTooltip" -- Accessed only
				}
			},
			popup = {
				fields = {
					"showPopup", -- Accessed only
					"ICONS" -- Accessed only
				}
			},
			security = {
				fields = {
					"computeSecurity" -- Accessed only
				}
			},
			loc = {
				fields = {
					"EDITOR_PREVIEW", -- Accessed only
					"EDITOR_ICON_SELECT" -- Accessed only
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
	},

	mrp = {
		fields = {
			"UpdateTooltip"
		}
	},

	"oUF_NamePlateDriver"
}

read_globals = {
	-- Libraries
	"LibStub",

	"MSA_DropDownMenu_Initialize",
	"MSA_DropDownMenu_SetWidth",
	"MSA_ToggleDropDownMenu",
	"MSA_DropDownMenu_AddButton",
	"MSA_DropDownMenu_SetText",
	"MSA_DropDownMenu_Create",
	"MSA_DropDownMenu_CreateInfo",
	"MSA_DropDownMenu_EnableDropDown",
	"MSA_DropDownMenu_DisableDropDown",
	"MSA_CloseDropDownMenus",
	"MSA_DropDownMenu_OnHide",
	"MSA_DropDownList1",
	"MSA_DropDownList2",
	ChatThrottleLib = {
		fields = {
			"SendAddonMessage",
			"BNSendGameData"
		}
	},

	-- 3rd party add-ons
	"ElvUI",
	"Tukui",
	CrossRP = {
		fields = {
			Proto = {
				fields = {
					"IsDestLinked",
					"SelectBridge",
					"DestFromFullname",
					"GetBandFromUnit",
					"GetBandFromDest",
					"DestToFullname",
					"Send",
					"GetNetworkStatus",
					"SetMessageHandler",
				}
			}
		}
	},
	"KuiNameplates",
	"NeatPlates",
	"TidyPlates",
	"TidyPlatesThreat",
	Plater = {
		fields = {
			"UpdatePlateText"
		}
	},

	msp = {
		fields = {
			"char"
		}
	},

	AddOn_TotalRP3 = {
		fields = {
			Player = {
				fields = {
					static = {
						fields = {
							"CreateFromCharacterID"
						}
					}
				}
			}
		}
	},
	TRP3_CharacterTooltip = {
		fields = {
			"HookScript",
			"target"
		}
	},
	TRP3_BlizzardNamePlates = {
		fields = {
			"UpdateNamePlate",
			"UpdateAllNamePlates",
			"initializedNameplates"
		}
	},
	TRP3_Configuration = {
		fields = {
			"tooltip_main_color"
		}
	},
	TRP3_Addon = {
		fields = {
			Events = {
				fields = {
					"WORKFLOW_ON_FINISH"
				}
			}
		}
	},

	TRP3_InventoryPage = {
		fields = {
			"Main"
		}
	},
	TRP3_ItemTooltip = {
		fields = {
			"Hide"
		}
	},
	TRP3_ToolFrameItemNormalTabPanel = {
		fields = {
			"GetChildren"
		}
	},
	TRP3_ToolFrame = {
		fields = {
			"HookScript",
			item = {
				fields = {
					normal = {
						fields = {
							"gameplay",
							"display"
						}
					}
				}
			}
		}
	},
	TRP3_Extended = {
		fields = {
			"TriggerEvent",
			Events = {
				fields = {
					"REFRESH_BAG",
					"REFRESH_CAMPAIGN",
					"ON_OBJECT_UPDATED",
				}
			}
		}
	}
}

std = "lua51+wow"

stds.wow = {
	-- Globals that we mutate.
	globals = {
		C_Minimap = {
			fields = {
				"GetNumTrackingTypes",
				"GetTrackingInfo",
				"GetTrackingFilter",
				"SetTracking",
				"ClearAllTracking",
			}
		},

		ChatFrameUtil = {
			fields = {
				"SubstituteChatMessageBeforeSend",
			}
		},

		ChatFrameMixin = {
			fields = {
				"OnLoad",
			}
		},

		"HandleModifiedItemClick",
		"SlashCmdList",
		"GetPlayerLink",
		"SubstituteChatMessageBeforeSend",
		"GetNumTrackingTypes",
		"GetTrackingInfo",
		"MiniMapTracking_FilterIsVisible",
		"StaticPopupDialogs",
		"ChatEdit_OnEditFocusLost",
		"SettingsLayoutMixin",
		"UnitPopup_ShowMenu",
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
		"tIndexOf",
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
				"SwapChatChannelsByChannelIndex",
				"RegisterAddonMessagePrefix",
				"SendChatMessage"
			},
		},

		C_Timer = {
			fields = {
				"After",
				"NewTicker",
				"NewTimer"
			}
		},

		C_DateAndTime = {
			fields = {
				"GetCurrentCalendarTime",
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

		TooltipDataProcessor = {
			fields = {
				"AddTooltipPostCall",
			}
		},

		C_AddOns = {
			fields = {
				"GetAddOnMetadata",
			}
		},

		LinkUtil = {
			fields = {
				"RegisterLinkHandler",
			}
		},

		ChatFrameUtil = {
			fields = {
				"LinkItem",
				"GetActiveWindow",
			}
		},

		"SetBasicMessageDialogText",
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
		"IsVeteranTrialAccount",
		"IsInGroup",
		"IsInRaid",
		"IsModifiedClick",
		"InCombatLockdown",
		"GetChannelName",
		"ListChannelByName",
		"StaticPopup_Visible",
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
		"ChatEdit_GetActiveWindow",
		"CreateVector2D",
		"MiniMapTracking_Update",
		"CreateFromMixins",
		"CompactUnitFrame_UpdateWidgetsOnlyMode",
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
		"InterfaceOptionsFrame_Show",
		"InterfaceOptionsFrame_OpenToCategory",
		"InlineHyperlinkFrame_OnEnter",
		"InlineHyperlinkFrame_OnLeave",
		"InlineHyperlinkFrame_OnClick",
		"ScrollFrame_OnScrollRangeChanged",
		"GetFramerate",
		"UnitInRaid",
		"RegisterAddonMessagePrefix",
		"securecall",
		"CloseSpecialWindows",
		"ShouldShowName",

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
		"GameTooltip_SetTitle",

		GameTooltipTextLeft1 = {
			fields = {
				"GetText",
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

		Item = {
			fields = {
				"CreateFromItemID"
			}
		},

		InterfaceOptionsNamesPanelUnitNameplatesShowAll = {
			fields = {
				"SetChecked"
			}
		},

		InterfaceOptionsNamesPanelUnitNameplatesEnemies = {
			fields = {
				"SetChecked"
			}
		},

		InterfaceOptionsNamesPanelUnitNameplatesFriends = {
			fields = {
				"SetChecked"
			}
		},

		InterfaceOptionsNamesPanelUnitNameplatesMotionDropDown = {
			fields = {
				"SetValue"
			}
		},

		AddonCompartmentFrame = {
			fields = {
				"RegisterAddon",
				"registeredAddons",
				"UpdateDisplay"
			}
		},

		Settings = {
			fields = {
				"RegisterCanvasLayoutCategory",
				"RegisterAddOnCategory",
				"OpenToCategory"
			}
		},

		Menu = {
			fields = {
				"ModifyMenu",
			}
		},

		Enum = {
			fields = {
				TooltipDataType = {
					fields = {
						"Unit"
					}
				}
			}
		},

		"UIParent",
		"WorldFrame",
		"WorldMapFrame",
		"Minimap",
		"UISpecialFrames",
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
		"RED_FONT_COLOR",
		"ORANGE_FONT_COLOR",
		"NORMAL_FONT_COLOR",
		"DIM_RED_FONT_COLOR",
		"GRAY_FONT_COLOR",
		"LIGHTBLUE_FONT_COLOR",
		"TOOLTIP_DEFAULT_COLOR",
		"TOOLTIP_DEFAULT_BACKGROUND_COLOR",
		"WOW_PROJECT_ID",
		"WOW_PROJECT_MAINLINE",
		"WOW_PROJECT_CLASSIC",
		"NUM_CHAT_WINDOWS",
		"SOUNDKIT",
		"MASTER_VOLUME",
		"SOUND_VOLUME",
		"FX_VOLUME",
		"DIALOG_VOLUME",
		"UNKNOWN",
		"PI",
	},
}
