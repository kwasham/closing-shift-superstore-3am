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
	MaxPlayers = 6,
	MinPlayers = 1,
}

Constants.Tasks = {
	RestockShelf = { reward = 15, holdDuration = 1.2 },
	CleanSpill = { reward = 20, holdDuration = 1.4 },
	TakeOutTrash = { reward = 18, holdDuration = 1.1 },
	ReturnCart = { reward = 12, holdDuration = 0.9 },
	CheckFreezer = { reward = 16, holdDuration = 1.2 },
	CloseRegister = { reward = 25, holdDuration = 1.8 },
}

Constants.Events = {
	Blackout = {
		triggerAtSecondsRemaining = 200,
		durationSeconds = 12,
	},
	Mimic = {
		triggerAtSecondsRemaining = 90,
		cashPenalty = 10,
		damage = 30,
	},
}

return Constants
