export type RoundState = "Waiting" | "Intermission" | "Playing" | "Ended"

export type TaskProgress = {
	totalRequired: number,
	completed: number,
	remainingByTask: { [string]: number },
	bankedPay: number,
	projectedSuccessPay: number,
	projectedFailPay: number,
	registerUnlocked: boolean,
	registerCompleted: boolean,
	personalPenalties: { [number]: number },
	blackoutActive: boolean,
	securityAlarmActive: boolean,
	securityAlarmState: string,
}

export type ProfilePublic = {
	profileVersion: number,
	cash: number,
	xp: number,
	level: number,
	shiftsPlayed: number,
	shiftsCleared: number,
	ownedCosmetics: { [string]: boolean },
	equippedCosmetics: { [string]: string },
	lastRoundResult: { [string]: any }?,
}

return {}
