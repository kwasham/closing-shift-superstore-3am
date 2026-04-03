local Constants = {}

Constants.RoundState = {
	Waiting = "Waiting",
	Intermission = "Intermission",
	Playing = "Playing",
	Ended = "Ended",
}

Constants.Round = {
	IntermissionSeconds = 15,
	DurationSeconds = 540,
	ResultsSeconds = 6,
	TickSeconds = 0.25,
	MaxPlayers = 6,
	MinPlayers = 1,
}

Constants.TaskId = {
	RestockShelf = "RestockShelf",
	CleanSpill = "CleanSpill",
	TakeOutTrash = "TakeOutTrash",
	ReturnCart = "ReturnCart",
	CheckFreezer = "CheckFreezer",
	CloseRegister = "CloseRegister",
}

Constants.TaskOrder = {
	Constants.TaskId.RestockShelf,
	Constants.TaskId.CleanSpill,
	Constants.TaskId.TakeOutTrash,
	Constants.TaskId.ReturnCart,
	Constants.TaskId.CheckFreezer,
	Constants.TaskId.CloseRegister,
}

Constants.Tasks = {
	[Constants.TaskId.RestockShelf] = {
		name = "Restock Shelf",
		promptText = "Restock Shelf",
		reward = 14,
		holdDuration = 1.2,
		reuseCooldown = 4,
	},
	[Constants.TaskId.CleanSpill] = {
		name = "Clean Spill",
		promptText = "Clean Spill",
		reward = 18,
		holdDuration = 1.4,
		reuseCooldown = 4.5,
	},
	[Constants.TaskId.TakeOutTrash] = {
		name = "Take Out Trash",
		promptText = "Take Out Trash",
		reward = 20,
		holdDuration = 1.1,
		reuseCooldown = 4,
	},
	[Constants.TaskId.ReturnCart] = {
		name = "Return Cart",
		promptText = "Return Cart",
		reward = 16,
		holdDuration = 0.9,
		reuseCooldown = 3.5,
	},
	[Constants.TaskId.CheckFreezer] = {
		name = "Check Freezer",
		promptText = "Check Freezer",
		reward = 22,
		holdDuration = 1.2,
		reuseCooldown = 4,
	},
	[Constants.TaskId.CloseRegister] = {
		name = "Close Register",
		promptText = "Close Register",
		lockedPromptText = "Finish all other tasks first",
		reward = 40,
		holdDuration = 1.8,
		reuseCooldown = 0,
	},
}

Constants.Prompts = {
	Waiting = "Waiting for next shift",
	Cooldown = "Task cooling down",
	Completed = "Completed",
	RegisterLocked = "Finish all other tasks first",
	NodeLocked = "False task locked",
	Blackout = "Blackout — wait for backup power",
}

Constants.Alerts = {
	MidRoundJoin = "Shift in progress. Wait for the next one.",
}

Constants.Payout = {
	SuccessBonus = 35,
	FailureMultiplier = 0.60,
}

Constants.Progression = {
	ProfileVersion = 1,
	XPBySource = {
		Task = 2,
		CloseRegister = 4,
		SecurityAlarmReset = 4,
		ShiftSuccess = 10,
		ShiftFailure = 4,
	},
	LevelThresholds = {
		0,
		20,
		45,
		75,
		110,
		150,
	},
	DisplayLevelCap = 6,
}

Constants.CosmeticSlots = {
	NameplateStyle = "NameplateStyle",
	LanyardColor = "LanyardColor",
}

Constants.Cosmetics = {
	DefaultOwned = {
		nameplate_standard_issue = true,
		lanyard_gray_clip = true,
	},
	DefaultEquipped = {
		NameplateStyle = "nameplate_standard_issue",
		LanyardColor = "lanyard_gray_clip",
	},
	CatalogOrder = {
		"nameplate_standard_issue",
		"clean_shift",
		"retro_plastic",
		"neon_night",
		"lanyard_gray_clip",
		"blue_id",
		"red_id",
		"gold_id",
	},
	Catalog = {
		nameplate_standard_issue = {
			itemId = "nameplate_standard_issue",
			displayName = "Standard Issue",
			slot = "NameplateStyle",
			priceCash = 0,
			requiredLevel = 1,
			flavorCopy = "Default issued store badge.",
			defaultOwned = true,
			preview = {
				nameplateFill = Color3.fromRGB(205, 211, 223),
				nameplateBorder = Color3.fromRGB(102, 112, 132),
				lanyardColor = Color3.fromRGB(140, 146, 152),
			},
		},
		clean_shift = {
			itemId = "clean_shift",
			displayName = "Clean Shift",
			slot = "NameplateStyle",
			priceCash = 40,
			requiredLevel = 1,
			flavorCopy = "Fresh laminated badge for a dependable closer.",
			preview = {
				nameplateFill = Color3.fromRGB(238, 243, 249),
				nameplateBorder = Color3.fromRGB(118, 135, 163),
				lanyardColor = Color3.fromRGB(140, 146, 152),
			},
		},
		retro_plastic = {
			itemId = "retro_plastic",
			displayName = "Retro Plastic",
			slot = "NameplateStyle",
			priceCash = 80,
			requiredLevel = 3,
			flavorCopy = "Old store plastic with worn late-night charm.",
			preview = {
				nameplateFill = Color3.fromRGB(237, 223, 197),
				nameplateBorder = Color3.fromRGB(157, 116, 84),
				lanyardColor = Color3.fromRGB(140, 146, 152),
			},
		},
		neon_night = {
			itemId = "neon_night",
			displayName = "Neon Night",
			slot = "NameplateStyle",
			priceCash = 120,
			requiredLevel = 5,
			flavorCopy = "Electric edge trim that reads from across the lobby.",
			preview = {
				nameplateFill = Color3.fromRGB(32, 35, 52),
				nameplateBorder = Color3.fromRGB(79, 255, 232),
				lanyardColor = Color3.fromRGB(140, 146, 152),
			},
		},
		lanyard_gray_clip = {
			itemId = "lanyard_gray_clip",
			displayName = "Gray Clip",
			slot = "LanyardColor",
			priceCash = 0,
			requiredLevel = 1,
			flavorCopy = "Default gray store lanyard.",
			defaultOwned = true,
			preview = {
				nameplateFill = Color3.fromRGB(205, 211, 223),
				nameplateBorder = Color3.fromRGB(102, 112, 132),
				lanyardColor = Color3.fromRGB(140, 146, 152),
			},
		},
		blue_id = {
			itemId = "blue_id",
			displayName = "Blue ID",
			slot = "LanyardColor",
			priceCash = 50,
			requiredLevel = 1,
			flavorCopy = "Calm blue strap for routine night shifts.",
			preview = {
				nameplateFill = Color3.fromRGB(205, 211, 223),
				nameplateBorder = Color3.fromRGB(102, 112, 132),
				lanyardColor = Color3.fromRGB(76, 141, 255),
			},
		},
		red_id = {
			itemId = "red_id",
			displayName = "Red ID",
			slot = "LanyardColor",
			priceCash = 75,
			requiredLevel = 2,
			flavorCopy = "Loud red strap that stands out fast.",
			preview = {
				nameplateFill = Color3.fromRGB(205, 211, 223),
				nameplateBorder = Color3.fromRGB(102, 112, 132),
				lanyardColor = Color3.fromRGB(235, 71, 71),
			},
		},
		gold_id = {
			itemId = "gold_id",
			displayName = "Gold ID",
			slot = "LanyardColor",
			priceCash = 100,
			requiredLevel = 4,
			flavorCopy = "Gold trim for proven overnight staff.",
			preview = {
				nameplateFill = Color3.fromRGB(205, 211, 223),
				nameplateBorder = Color3.fromRGB(102, 112, 132),
				lanyardColor = Color3.fromRGB(241, 197, 74),
			},
		},
	},
}

Constants.Events = {
	Blackout = {
		MinRemainingSeconds = 240,
		MaxRemainingSeconds = 190,
		DurationSeconds = 10,
	},
	Mimic = {
		MinRemainingSeconds = 165,
		MaxRemainingSeconds = 95,
		LifetimeSeconds = 18,
		NodeLockSeconds = 8,
		TimerPenaltySeconds = 8,
		CashPenalty = 12,
		MinRealTasksRemaining = 2,
	},
	SecurityAlarm = {
		EventId = "security_alarm",
		NodeId = "security_panel_node",
		MinRemainingSeconds = 125,
		MaxRemainingSeconds = 165,
		ResponseWindowSeconds = 15,
		HoldDuration = 2,
		CancelAtRemainingSeconds = 45,
		TimerPenaltySeconds = 12,
		FeedbackState = {
			Idle = "security_idle",
			Active = "security_active",
			Resolved = "security_resolved",
			Failed = "security_failed",
		},
	},
}

return Constants
