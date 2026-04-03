export type RoundState = "Waiting" | "Intermission" | "Playing" | "Ended"
export type RoundResult = "success" | "failure"

export type TaskId =
	"restock_shelf"
	| "clean_spill"
	| "take_out_trash"
	| "return_cart"
	| "check_freezer"
	| "close_register"

export type TaskConfig = {
	id: TaskId,
	name: string,
	promptText: string,
	reward: number,
	holdDuration: number,
	reuseCooldown: number,
	finalTask: boolean,
	lockedPromptText: string?,
}

export type QuotaMap = {
	[TaskId]: number,
}

export type ProgressSnapshot = {
	totalRequired: number,
	completed: number,
	remainingByTask: QuotaMap,
	bankedPay: number,
	projectedSuccessPay: number,
	projectedFailPay: number,
	registerUnlocked: boolean,
	registerCompleted: boolean,
	personalPenalties: { [number]: number },
	blackoutActive: boolean,
}

export type AlertPayload = {
	id: string,
	message: string,
	priority: number,
	duration: number?,
	pinned: boolean?,
	cueId: string?,
}

export type RoundSnapshot = {
	state: RoundState,
	timerSeconds: number,
	progress: ProgressSnapshot?,
	activeUserIds: { number },
	roundResult: RoundResult?,
}

return {}
