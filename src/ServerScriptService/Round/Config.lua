local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local Config = {
	intermissionSeconds = Constants.Round.IntermissionSeconds,
	durationSeconds = Constants.Round.DurationSeconds,
	minPlayers = Constants.Round.MinPlayers,
	endDelaySeconds = Constants.Round.EndDelaySeconds,
	heartbeatSeconds = Constants.Round.HeartbeatSeconds,
	taskOrder = {
		Constants.TaskId.RestockShelf,
		Constants.TaskId.CleanSpill,
		Constants.TaskId.TakeOutTrash,
		Constants.TaskId.ReturnCart,
		Constants.TaskId.CheckFreezer,
		Constants.TaskId.CloseRegister,
	},
	quotaByPlayerCount = {
		[1] = {
			[Constants.TaskId.RestockShelf] = 2,
			[Constants.TaskId.CleanSpill] = 1,
			[Constants.TaskId.TakeOutTrash] = 1,
			[Constants.TaskId.ReturnCart] = 2,
			[Constants.TaskId.CheckFreezer] = 1,
			[Constants.TaskId.CloseRegister] = 1,
		},
		[2] = {
			[Constants.TaskId.RestockShelf] = 2,
			[Constants.TaskId.CleanSpill] = 2,
			[Constants.TaskId.TakeOutTrash] = 1,
			[Constants.TaskId.ReturnCart] = 2,
			[Constants.TaskId.CheckFreezer] = 1,
			[Constants.TaskId.CloseRegister] = 1,
		},
		[3] = {
			[Constants.TaskId.RestockShelf] = 3,
			[Constants.TaskId.CleanSpill] = 2,
			[Constants.TaskId.TakeOutTrash] = 2,
			[Constants.TaskId.ReturnCart] = 3,
			[Constants.TaskId.CheckFreezer] = 1,
			[Constants.TaskId.CloseRegister] = 1,
		},
	},
	softLaunch = {
		soft_launch_enabled = true,
		daily_first_shift_bonus_enabled = true,
		daily_first_shift_bonus_cash = 25,
		daily_first_shift_bonus_reset_hour_utc = 0,
		launch_badges_enabled = true,
		three_am_regular_days_required = 3,
		share_cta_enabled = true,
		share_cta_show_on_success = true,
		share_cta_show_on_failure = true,
		analytics_debug_logging_enabled = true,
	},
}

local function shallowCopy(source)
	return table.clone(source)
end

function Config.getTaskQuotas(playerCount)
	local resolvedPlayerCount = math.clamp(playerCount or 1, 1, 3)
	local quotas = Config.quotaByPlayerCount[resolvedPlayerCount] or Config.quotaByPlayerCount[1]
	return shallowCopy(quotas)
end

function Config.getTotalRequired(quotas)
	local total = 0
	for _, taskId in ipairs(Config.taskOrder) do
		total += quotas[taskId] or 0
	end
	return total
end

return Config
