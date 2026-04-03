local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local Config = {
	intermissionSeconds = Constants.Round.IntermissionSeconds,
	durationSeconds = Constants.Round.DurationSeconds,
	resultsSeconds = Constants.Round.ResultsSeconds,
	minPlayers = Constants.Round.MinPlayers,
	taskOrder = Constants.TaskOrder,
}

local quotaByPlayerBucket = {
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
}

local function cloneDictionary(source)
	return table.clone(source)
end

function Config.getQuotaTemplate(playerCount)
	local bucket = if playerCount <= 1 then 1 elseif playerCount == 2 then 2 else 3
	return cloneDictionary(quotaByPlayerBucket[bucket])
end

function Config.getTotalRequired(quotas)
	local total = 0
	for _, taskId in ipairs(Config.taskOrder) do
		total += quotas[taskId] or 0
	end
	return total
end

return Config
