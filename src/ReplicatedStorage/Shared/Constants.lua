local Constants = {}

Constants.RoundState = {
	Waiting = "Waiting",
	Intermission = "Intermission",
	Playing = "Playing",
	Ended = "Ended",
}

Constants.Round = {
	IntermissionSeconds = 15,
	DurationSeconds = 300,
	EndDelaySeconds = 5,
	HeartbeatSeconds = 0.25,
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

Constants.Tasks = {
	[Constants.TaskId.RestockShelf] = {
		name = "Shelf Bay",
		promptText = "Restock Shelf",
		reward = 15,
		holdDuration = 1.2,
		reuseCooldown = 4,
	},
	[Constants.TaskId.CleanSpill] = {
		name = "Spill Zone",
		promptText = "Clean Spill",
		reward = 18,
		holdDuration = 1.4,
		reuseCooldown = 0,
	},
	[Constants.TaskId.TakeOutTrash] = {
		name = "Trash Cage",
		promptText = "Take Out Trash",
		reward = 16,
		holdDuration = 1.1,
		reuseCooldown = 0,
	},
	[Constants.TaskId.ReturnCart] = {
		name = "Cart Return",
		promptText = "Return Cart",
		reward = 12,
		holdDuration = 0.9,
		reuseCooldown = 3,
	},
	[Constants.TaskId.CheckFreezer] = {
		name = "Freezer Door",
		promptText = "Check Freezer",
		reward = 17,
		holdDuration = 1.2,
		reuseCooldown = 0,
	},
	[Constants.TaskId.CloseRegister] = {
		name = "Front Register",
		promptText = "Close Register",
		lockedPromptText = "Finish other tasks first",
		reward = 25,
		holdDuration = 1.8,
		reuseCooldown = 0,
	},
}

Constants.Prompts = {
	Waiting = "Waiting for next shift",
	Blackout = "Blackout. Wait for backup power.",
	NodeLocked = "Area locked",
	Cooldown = "Resetting...",
	Completed = "Completed",
	RegisterLocked = "Finish all other tasks first",
}

Constants.Alerts = {
	MidRoundJoin = "Shift in progress. Wait for the next one.",
}

Constants.Payout = {
	SuccessBonus = 35,
	FailureMultiplier = 0.6,
}

Constants.Events = {
	Blackout = {
		MinRemainingSeconds = 165,
		MaxRemainingSeconds = 235,
		DurationSeconds = 12,
	},
	Mimic = {
		MinRemainingSeconds = 70,
		MaxRemainingSeconds = 125,
		MinRealTasksRemaining = 2,
		LifetimeSeconds = 16,
		TimerPenaltySeconds = 8,
		CashPenalty = 10,
		NodeLockSeconds = 8,
	},
	SecurityAlarm = {
		EventId = "SecurityAlarm",
		NodeId = "security_panel_node",
		MinRemainingSeconds = 115,
		MaxRemainingSeconds = 175,
		CancelAtRemainingSeconds = 45,
		ResponseWindowSeconds = 15,
		TimerPenaltySeconds = 12,
		HoldDuration = 1.4,
		FeedbackState = {
			Idle = "idle",
			Active = "active",
			Resolved = "resolved",
			Failed = "failed",
		},
	},
}

Constants.Progression = {
	LevelThresholds = {
		[1] = 0,
		[2] = 15,
		[3] = 45,
		[4] = 75,
		[5] = 110,
		[6] = 150,
	},
	DisplayLevelCap = 6,
	Rewards = {
		TaskXP = 2,
		CloseRegisterXP = 5,
		ShiftSuccessBonusXP = 8,
		ShiftFailureXP = 4,
		SecurityAlarmResetXP = 5,
	},
}

Constants.CosmeticSlots = {
	NameplateStyle = "NameplateStyle",
	LanyardColor = "LanyardColor",
}

Constants.Cosmetics = {
	DefaultEquipped = {
		NameplateStyle = "standard_issue",
		LanyardColor = "gray_clip",
	},
	CatalogOrder = {
		"standard_issue",
		"retro_plastic",
		"night_shift",
		"gray_clip",
		"gold_id",
		"safety_orange",
	},
	Catalog = {
		standard_issue = {
			itemId = "standard_issue",
			displayName = "Standard Issue",
			slot = Constants.CosmeticSlots.NameplateStyle,
			priceCash = 0,
			requiredLevel = 1,
			defaultOwned = true,
			flavorCopy = "Factory nameplate for every overnight closer.",
			preview = {
				nameplateFill = Color3.fromRGB(223, 228, 235),
				nameplateBorder = Color3.fromRGB(94, 103, 118),
				lanyardColor = Color3.fromRGB(120, 126, 134),
			},
		},
		retro_plastic = {
			itemId = "retro_plastic",
			displayName = "Retro Plastic",
			slot = Constants.CosmeticSlots.NameplateStyle,
			priceCash = 60,
			requiredLevel = 2,
			defaultOwned = false,
			flavorCopy = "Chunky cream plastic with a late-night office supply vibe.",
			preview = {
				nameplateFill = Color3.fromRGB(246, 232, 199),
				nameplateBorder = Color3.fromRGB(126, 99, 78),
				lanyardColor = Color3.fromRGB(120, 126, 134),
			},
		},
		night_shift = {
			itemId = "night_shift",
			displayName = "Night Shift",
			slot = Constants.CosmeticSlots.NameplateStyle,
			priceCash = 95,
			requiredLevel = 3,
			defaultOwned = false,
			flavorCopy = "Deep navy card with a fluorescent trim for the late crew.",
			preview = {
				nameplateFill = Color3.fromRGB(32, 47, 73),
				nameplateBorder = Color3.fromRGB(144, 195, 255),
				lanyardColor = Color3.fromRGB(120, 126, 134),
			},
		},
		gray_clip = {
			itemId = "gray_clip",
			displayName = "Gray Clip",
			slot = Constants.CosmeticSlots.LanyardColor,
			priceCash = 0,
			requiredLevel = 1,
			defaultOwned = true,
			flavorCopy = "Standard lanyard from the staff drawer.",
			preview = {
				nameplateFill = Color3.fromRGB(223, 228, 235),
				nameplateBorder = Color3.fromRGB(94, 103, 118),
				lanyardColor = Color3.fromRGB(114, 120, 129),
			},
		},
		gold_id = {
			itemId = "gold_id",
			displayName = "Gold ID",
			slot = Constants.CosmeticSlots.LanyardColor,
			priceCash = 55,
			requiredLevel = 4,
			defaultOwned = false,
			flavorCopy = "Supervisor-grade gold clip with a polished badge loop.",
			preview = {
				nameplateFill = Color3.fromRGB(223, 228, 235),
				nameplateBorder = Color3.fromRGB(94, 103, 118),
				lanyardColor = Color3.fromRGB(217, 176, 74),
			},
		},
		safety_orange = {
			itemId = "safety_orange",
			displayName = "Safety Orange",
			slot = Constants.CosmeticSlots.LanyardColor,
			priceCash = 80,
			requiredLevel = 5,
			defaultOwned = false,
			flavorCopy = "High-vis orange for closers who never miss a reset.",
			preview = {
				nameplateFill = Color3.fromRGB(223, 228, 235),
				nameplateBorder = Color3.fromRGB(94, 103, 118),
				lanyardColor = Color3.fromRGB(232, 126, 64),
			},
		},
	},
}

Constants.SoftLaunch = {
	BadgeId = {
		FirstShift = "first_shift",
		ShiftCleared = "shift_cleared",
		ThreeAmRegular = "three_am_regular",
	},
	BadgeOrder = {
		"first_shift",
		"shift_cleared",
		"three_am_regular",
	},
	BadgeDefinitions = {
		first_shift = {
			badgeId = "first_shift",
			badgeName = "First Shift",
			assetId = 0,
		},
		shift_cleared = {
			badgeId = "shift_cleared",
			badgeName = "Store Closed",
			assetId = 0,
		},
		three_am_regular = {
			badgeId = "three_am_regular",
			badgeName = "3AM Regular",
			assetId = 0,
		},
	},
}

return Constants
