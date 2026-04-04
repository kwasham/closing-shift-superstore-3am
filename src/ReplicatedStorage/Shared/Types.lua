export type RoundState = "Waiting" | "Intermission" | "Playing" | "Ended"

export type TaskConfig = {
	reward: number,
	holdDuration: number,
}

export type TaskProgress = {
	total: number,
	completed: number,
}

return {}
