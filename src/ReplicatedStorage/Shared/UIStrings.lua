local UIStrings = {}

UIStrings.AlertPriority = {
	Pinned = 100,
	Urgent = 90,
	Important = 80,
	Tutorial = 70,
	Prompt = 60,
	Ambient = 10,
}

UIStrings.Alerts = {
	late_join_wait = {
		id = "late_join_wait",
		message = "Shift in progress. Wait for the next one.",
		priority = UIStrings.AlertPriority.Pinned,
		pinned = true,
	},
	blackout_active = {
		id = "blackout_active",
		message = "Blackout. Wait for backup power.",
		priority = UIStrings.AlertPriority.Pinned,
		pinned = true,
		cueId = "blackout_start",
	},
	blackout_end = {
		id = "blackout_end",
		message = "Power restored. Get back to work.",
		priority = UIStrings.AlertPriority.Important,
		duration = 3,
		cueId = "blackout_end",
	},
	mimic_triggered = {
		id = "mimic_triggered",
		message = "False task. Lost time and pay.",
		priority = UIStrings.AlertPriority.Urgent,
		duration = 4,
		cueId = "mimic_triggered",
	},
	register_unlocked = {
		id = "register_unlocked",
		message = "Close Register unlocked.",
		priority = UIStrings.AlertPriority.Important,
		duration = 4,
		cueId = "register_unlocked",
	},
	security_alarm_active = {
		id = "security_alarm_active",
		message = "Security Alarm. Reset the front panel.",
		priority = UIStrings.AlertPriority.Pinned,
		pinned = true,
		cueId = "security_alarm_start",
	},
	security_alarm_reset = {
		id = "security_alarm_reset",
		message = "Alarm reset. Keep closing.",
		priority = UIStrings.AlertPriority.Important,
		duration = 4,
		cueId = "security_alarm_reset",
	},
	security_alarm_failed = {
		id = "security_alarm_failed",
		message = "Alarm missed. Lost 12 seconds.",
		priority = UIStrings.AlertPriority.Urgent,
		duration = 4,
		cueId = "security_alarm_fail",
	},
	round_success = {
		id = "round_success",
		message = "Shift cleared. Cashing out.",
		priority = UIStrings.AlertPriority.Pinned,
		pinned = true,
		cueId = "round_success",
	},
	round_failure = {
		id = "round_failure",
		message = "Time's up. Partial pay.",
		priority = UIStrings.AlertPriority.Pinned,
		pinned = true,
		cueId = "round_failure",
	},
	round_start_hint = {
		id = "round_start_hint",
		message = "Clock in. Follow the glow to your first task.",
		priority = UIStrings.AlertPriority.Tutorial,
		duration = 4,
	},
}

UIStrings.Tutorial = {
	goal = {
		id = "tutorial_goal",
		message = "Finish the task list before the timer hits zero.",
		priority = UIStrings.AlertPriority.Tutorial,
		duration = 4,
	},
	follow_task = {
		id = "tutorial_follow_task",
		message = "Clock in. Follow the glow to your first task.",
		priority = UIStrings.AlertPriority.Tutorial,
		duration = 5,
	},
	banked_pay = {
		id = "tutorial_banked_pay",
		message = "Tasks add Shift Cash. Register unlocks last.",
		priority = UIStrings.AlertPriority.Tutorial,
		duration = 5,
	},
	register_end = {
		id = "tutorial_register_end",
		message = "Close Register is ready. Finish the shift.",
		priority = UIStrings.AlertPriority.Important + 1,
		duration = 4,
	},
}

UIStrings.State = {
	Waiting = "Waiting for staff",
	Intermission = "Intermission",
	Playing = "Closing shift live",
	Ended = "Shift complete",
	LateJoin = "Waiting for next shift",
}

UIStrings.AmbientAlerts = {
	Waiting = "Waiting for enough staff.",
	Intermission = "Shift starts soon.",
	Playing = "Tasks add Shift Cash. Register unlocks last.",
	Ended = "Shift payout in progress.",
}

UIStrings.SoftLaunch = {
	Summary = "Soft launch: claim a Daily First Shift Bonus, unlock launch badges, and invite friends from the results screen.",
	ReleaseNotes = {
		"Daily First Shift Bonus: your first completed shift each UTC day adds +$25 Saved Cash.",
		"Launch badges: First Shift, Store Closed, and 3AM Regular.",
		"Round-end Invite Friends button with fallback messaging on unsupported platforms.",
	},
	DailyFirstShiftBonusLine = "Daily First Shift Bonus: +$25 Saved Cash",
	BadgeUnlockedPrefix = "Badge unlocked: ",
	ShareSuccessHelper = "Good shift. Bring a crew back in.",
	ShareFailureHelper = "Bring backup for the next shift.",
	ShareFallbackHelper = "Invites aren’t available here. Use the Roblox game page or platform share menu.",
	ShareButton = "Invite Friends",
}

return UIStrings
