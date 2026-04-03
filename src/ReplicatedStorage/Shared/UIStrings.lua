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
		message = "Clock in. Follow the task glow.",
		priority = UIStrings.AlertPriority.Tutorial,
		duration = 4,
	},
}

UIStrings.Tutorial = {
	goal = {
		id = "tutorial_goal",
		message = "Finish the list before time runs out.",
		priority = UIStrings.AlertPriority.Tutorial,
		duration = 4,
	},
	follow_task = {
		id = "tutorial_follow_task",
		message = "Follow the glow. Hold on a task to work.",
		priority = UIStrings.AlertPriority.Tutorial,
		duration = 5,
	},
	banked_pay = {
		id = "tutorial_banked_pay",
		message = "Task cash is banked. Register unlocks last.",
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
	Playing = "Bank tasks. Close register last.",
	Ended = "Shift payout in progress.",
}

return UIStrings
