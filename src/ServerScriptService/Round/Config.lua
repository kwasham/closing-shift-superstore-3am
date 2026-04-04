local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local SOLO_QUOTAS = {
	[Constants.TaskId.RestockShelf] = 2,
	[Constants.TaskId.CleanSpill] = 1,
	[Constants.TaskId.TakeOutTrash] = 1,
	[Constants.TaskId.ReturnCart] = 2,
	[Constants.TaskId.CheckFreezer] = 1,
	[Constants.TaskId.CloseRegister] = 1,
}

local COOP_QUOTAS = {
	[Constants.TaskId.RestockShelf] = 2,
	[Constants.TaskId.CleanSpill] = 2,
	[Constants.TaskId.TakeOutTrash] = 1,
	[Constants.TaskId.ReturnCart] = 2,
	[Constants.TaskId.CheckFreezer] = 1,
	[Constants.TaskId.CloseRegister] = 1,
}

local function cloneQuotas(template)
	return table.clone(template)
end

local Config = {
	intermissionSeconds = Constants.Round.IntermissionSeconds,
	durationSeconds = Constants.Round.DurationSeconds,
	minPlayers = Constants.Round.MinPlayers,
	endDelaySeconds = 5,
	heartbeatSeconds = 0.25,
	taskOrder = {
		Constants.TaskId.RestockShelf,
		Constants.TaskId.CleanSpill,
		Constants.TaskId.TakeOutTrash,
		Constants.TaskId.ReturnCart,
		Constants.TaskId.CheckFreezer,
		Constants.TaskId.CloseRegister,
	},
}

function Config.getQuotaTemplate(playerCount)
	if playerCount > 1 then
		return cloneQuotas(COOP_QUOTAS)
	end
	return cloneQuotas(SOLO_QUOTAS)
end

function Config.getTotalRequired(quotas)
	local total = 0
	for _, taskId in ipairs(Config.taskOrder) do
		total += quotas[taskId] or 0
	end
	return total
end

return Config
