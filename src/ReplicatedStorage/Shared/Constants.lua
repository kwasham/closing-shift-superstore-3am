local Constants = {}

Constants.RoundState = {
	Waiting = "waiting",
	Intermission = "intermission",
	Playing = "playing",
	Ended = "ended",
}

Constants.Round = {
	MinPlayers = 1,
	IntermissionSeconds = 15,
	DurationSeconds = 540,
}

Constants.TaskId = {
	RestockShelf = "restock_shelf",
	CleanSpill = "clean_spill",
	TakeOutTrash = "take_out_trash",
	ReturnCart = "return_cart",
	CheckFreezer = "check_freezer",
	CloseRegister = "close_register",
}

Constants.Tasks = {
	[Constants.TaskId.RestockShelf] = {
		name = "Restock Shelf",
		promptText = "Hold to restock shelf",
		reward = 14,
		holdDuration = 1.5,
	},
	[Constants.TaskId.CleanSpill] = {
		name = "Clean Spill",
		promptText = "Hold to mop spill",
		reward = 18,
		holdDuration = 1.8,
	},
	[Constants.TaskId.TakeOutTrash] = {
		name = "Take Out Trash",
		promptText = "Hold to haul trash bag out back",
		reward = 16,
		holdDuration = 1.4,
	},
	[Constants.TaskId.ReturnCart] = {
		name = "Return Cart",
		promptText = "Hold to return cart to corral",
		reward = 12,
		holdDuration = 1.0,
	},
	[Constants.TaskId.CheckFreezer] = {
		name = "Check Freezer",
		promptText = "Hold to inspect freezer alarm",
		reward = 20,
		holdDuration = 1.6,
	},
	[Constants.TaskId.CloseRegister] = {
		name = "Close Register",
		promptText = "Hold to count drawer and lock register",
		reward = 24,
		holdDuration = 2.2,
	},
}

Constants.Prompts = {
	Waiting = "Waiting for next shift",
	Blackout = "Blackout. Wait for backup power.",
	Completed = "Done",
	Cooldown = "Cooling down",
	NodeLocked = "Unavailable",
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
		MinRemainingSeconds = 240,
		MaxRemainingSeconds = 300,
		DurationSeconds = 10,
	},
	Mimic = {
		MinRemainingSeconds = 135,
		MaxRemainingSeconds = 180,
		MinRealTasksRemaining = 3,
		LifetimeSeconds = 18,
		TimerPenaltySeconds = 8,
		CashPenalty = 12,
		NodeLockSeconds = 8,
	},
	SecurityAlarm = {
		EventId = "security_alarm",
		NodeId = "security_panel_node",
		MinRemainingSeconds = 125,
		MaxRemainingSeconds = 165,
		CancelAtRemainingSeconds = 45,
		ResponseWindowSeconds = 15,
		HoldDuration = 2.0,
		TimerPenaltySeconds = 12,
		FeedbackState = {
			Idle = "security_idle",
			Active = "security_active",
			Resolved = "security_resolved",
			Failed = "security_failed",
		},
	},
}

Constants.Progression = {
	DisplayLevelCap = 6,
	LevelThresholds = {
		[1] = 0,
		[2] = 20,
		[3] = 45,
		[4] = 75,
		[5] = 110,
		[6] = 150,
	},
}

Constants.CosmeticSlots = {
	NameplateStyle = "NameplateStyle",
	LanyardColor = "LanyardColor",
}

Constants.Cosmetics = {
	DefaultEquipped = {
		NameplateStyle = "nameplate_standard_issue",
		LanyardColor = "lanyard_gray_clip",
	},
	CatalogOrder = {
		"clean_shift",
		"retro_plastic",
		"neon_night",
		"blue_id",
		"red_id",
		"gold_id",
	},
	Catalog = {
		nameplate_standard_issue = {
			itemId = "nameplate_standard_issue",
			slot = Constants.CosmeticSlots.NameplateStyle,
			displayName = "Standard Issue",
			flavorCopy = "The plain badge every new closer starts with.",
			priceCash = 0,
			requiredLevel = 1,
			defaultOwned = true,
			preview = {
				nameplateFill = Color3.fromRGB(229, 231, 236),
				nameplateBorder = Color3.fromRGB(103, 112, 132),
				lanyardColor = Color3.fromRGB(130, 130, 136),
			},
		},
		lanyard_gray_clip = {
			itemId = "lanyard_gray_clip",
			slot = Constants.CosmeticSlots.LanyardColor,
			displayName = "Gray Clip",
			flavorCopy = "A neutral lanyard for the overnight shift.",
			priceCash = 0,
			requiredLevel = 1,
			defaultOwned = true,
			preview = {
				nameplateFill = Color3.fromRGB(229, 231, 236),
				nameplateBorder = Color3.fromRGB(103, 112, 132),
				lanyardColor = Color3.fromRGB(130, 130, 136),
			},
		},
		clean_shift = {
			itemId = "clean_shift",
			slot = Constants.CosmeticSlots.NameplateStyle,
			displayName = "Clean Shift",
			flavorCopy = "A crisp badge that looks like you still trust the schedule.",
			priceCash = 40,
			requiredLevel = 1,
			preview = {
				nameplateFill = Color3.fromRGB(214, 229, 255),
				nameplateBorder = Color3.fromRGB(78, 118, 182),
				lanyardColor = Color3.fromRGB(92, 118, 168),
			},
		},
		retro_plastic = {
			itemId = "retro_plastic",
			slot = Constants.CosmeticSlots.NameplateStyle,
			displayName = "Retro Plastic",
			flavorCopy = "A faded checkout-era badge with old-store energy.",
			priceCash = 80,
			requiredLevel = 3,
			preview = {
				nameplateFill = Color3.fromRGB(247, 217, 176),
				nameplateBorder = Color3.fromRGB(168, 99, 52),
				lanyardColor = Color3.fromRGB(166, 111, 69),
			},
		},
		neon_night = {
			itemId = "neon_night",
			slot = Constants.CosmeticSlots.NameplateStyle,
			displayName = "Neon Night",
			flavorCopy = "Bright enough to look wrong under supermarket lights.",
			priceCash = 120,
			requiredLevel = 5,
			preview = {
				nameplateFill = Color3.fromRGB(157, 253, 233),
				nameplateBorder = Color3.fromRGB(26, 148, 149),
				lanyardColor = Color3.fromRGB(34, 142, 150),
			},
		},
		blue_id = {
			itemId = "blue_id",
			slot = Constants.CosmeticSlots.LanyardColor,
			displayName = "Blue ID",
			flavorCopy = "A calm blue strap that feels almost official.",
			priceCash = 50,
			requiredLevel = 1,
			preview = {
				nameplateFill = Color3.fromRGB(229, 231, 236),
				nameplateBorder = Color3.fromRGB(103, 112, 132),
				lanyardColor = Color3.fromRGB(71, 120, 201),
			},
		},
		red_id = {
			itemId = "red_id",
			slot = Constants.CosmeticSlots.LanyardColor,
			displayName = "Red ID",
			flavorCopy = "A red strap that makes routine tasks feel riskier.",
			priceCash = 75,
			requiredLevel = 2,
			preview = {
				nameplateFill = Color3.fromRGB(229, 231, 236),
				nameplateBorder = Color3.fromRGB(103, 112, 132),
				lanyardColor = Color3.fromRGB(184, 70, 82),
			},
		},
		gold_id = {
			itemId = "gold_id",
			slot = Constants.CosmeticSlots.LanyardColor,
			displayName = "Gold ID",
			flavorCopy = "A bright strap for closers who keep surviving the night.",
			priceCash = 100,
			requiredLevel = 4,
			preview = {
				nameplateFill = Color3.fromRGB(229, 231, 236),
				nameplateBorder = Color3.fromRGB(103, 112, 132),
				lanyardColor = Color3.fromRGB(214, 171, 74),
			},
		},
	},
}

return Constants
