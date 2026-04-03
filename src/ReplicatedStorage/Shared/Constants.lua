local Constants = {}

Constants.RoundState = {
	Waiting = "Waiting",
	Intermission = "Intermission",
	Playing = "Playing",
	Ended = "Ended",
}

Constants.TaskId = {
	RestockShelf = "restock_shelf",
	CleanSpill = "clean_spill",
	TakeOutTrash = "take_out_trash",
	ReturnCart = "return_cart",
	CheckFreezer = "check_freezer",
	CloseRegister = "close_register",
}

Constants.TaskOrder = {
	Constants.TaskId.RestockShelf,
	Constants.TaskId.CleanSpill,
	Constants.TaskId.TakeOutTrash,
	Constants.TaskId.ReturnCart,
	Constants.TaskId.CheckFreezer,
	Constants.TaskId.CloseRegister,
}

Constants.Round = {
	IntermissionSeconds = 15,
	DurationSeconds = 540,
	EndedSeconds = 3,
	MaxPlayers = 6,
	MinPlayers = 1,
}

Constants.Payout = {
	SuccessBonus = 35,
	FailureMultiplier = 0.60,
}

Constants.Prompts = {
	RegisterLocked = "Finish all other tasks first",
	Blackout = "Blackout — wait for backup power",
	Cooldown = "Task resets soon",
	NodeLocked = "Node locked after false task",
	Waiting = "Waiting for the next shift",
	Completed = "Task complete",
}

Constants.Alerts = {
	Intermission = "Get ready for the next closing shift.",
	RoundStart = "Clock in. Follow the task glow.",
	MidRoundJoin = "Shift in progress. Wait for the next one.",
	BlackoutStart = "Blackout. Wait for backup power.",
	BlackoutEnd = "Power restored. Get back to work.",
	RegisterUnlocked = "Close Register unlocked.",
	MimicTriggered = "False task. Lost time and pay.",
	Success = "Shift cleared. Cashing out.",
	Failure = "Time's up. Partial pay.",
}

Constants.Tasks = {
	[Constants.TaskId.RestockShelf] = {
		id = Constants.TaskId.RestockShelf,
		name = "Restock Shelf",
		promptText = "Hold to restock shelf",
		reward = 14,
		holdDuration = 1.5,
		reuseCooldown = 6,
		finalTask = false,
	},
	[Constants.TaskId.CleanSpill] = {
		id = Constants.TaskId.CleanSpill,
		name = "Clean Spill",
		promptText = "Hold to mop spill",
		reward = 18,
		holdDuration = 1.8,
		reuseCooldown = 6,
		finalTask = false,
	},
	[Constants.TaskId.TakeOutTrash] = {
		id = Constants.TaskId.TakeOutTrash,
		name = "Take Out Trash",
		promptText = "Hold to haul trash bag out back",
		reward = 16,
		holdDuration = 1.4,
		reuseCooldown = 6,
		finalTask = false,
	},
	[Constants.TaskId.ReturnCart] = {
		id = Constants.TaskId.ReturnCart,
		name = "Return Cart",
		promptText = "Hold to return cart to corral",
		reward = 12,
		holdDuration = 1.0,
		reuseCooldown = 6,
		finalTask = false,
	},
	[Constants.TaskId.CheckFreezer] = {
		id = Constants.TaskId.CheckFreezer,
		name = "Check Freezer",
		promptText = "Hold to inspect freezer alarm",
		reward = 20,
		holdDuration = 1.6,
		reuseCooldown = 6,
		finalTask = false,
	},
	[Constants.TaskId.CloseRegister] = {
		id = Constants.TaskId.CloseRegister,
		name = "Close Register",
		promptText = "Hold to count drawer and lock register",
		reward = 24,
		holdDuration = 2.2,
		reuseCooldown = 0,
		finalTask = true,
		lockedPromptText = Constants.Prompts.RegisterLocked,
	},
}

Constants.Events = {
	Blackout = {
		MaxRemainingSeconds = 300,
		MinRemainingSeconds = 240,
		DurationSeconds = 10,
	},
	Mimic = {
		MaxRemainingSeconds = 180,
		MinRemainingSeconds = 135,
		LifetimeSeconds = 18,
		TimePenaltySeconds = 8,
		CashPenalty = 12,
		NodeLockSeconds = 8,
		MinRealTasksRemaining = 3,
	},
}

return Constants
