local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local quotaBundles = {
	{
		minPlayers = 1,
		maxPlayers = 1,
		quotas = {
			[Constants.TaskId.RestockShelf] = 2,
			[Constants.TaskId.CleanSpill] = 1,
			[Constants.TaskId.TakeOutTrash] = 1,
			[Constants.TaskId.ReturnCart] = 2,
			[Constants.TaskId.CheckFreezer] = 1,
			[Constants.TaskId.CloseRegister] = 1,
		},
	},
	{
		minPlayers = 2,
		maxPlayers = 2,
		quotas = {
			[Constants.TaskId.RestockShelf] = 2,
			[Constants.TaskId.CleanSpill] = 2,
			[Constants.TaskId.TakeOutTrash] = 1,
			[Constants.TaskId.ReturnCart] = 2,
			[Constants.TaskId.CheckFreezer] = 1,
			[Constants.TaskId.CloseRegister] = 1,
		},
	},
	{
		minPlayers = 3,
		maxPlayers = 4,
		quotas = {
			[Constants.TaskId.RestockShelf] = 2,
			[Constants.TaskId.CleanSpill] = 2,
			[Constants.TaskId.TakeOutTrash] = 2,
			[Constants.TaskId.ReturnCart] = 2,
			[Constants.TaskId.CheckFreezer] = 1,
			[Constants.TaskId.CloseRegister] = 1,
		},
	},
	{
		minPlayers = 5,
		maxPlayers = 6,
		quotas = {
			[Constants.TaskId.RestockShelf] = 3,
			[Constants.TaskId.CleanSpill] = 2,
			[Constants.TaskId.TakeOutTrash] = 2,
			[Constants.TaskId.ReturnCart] = 3,
			[Constants.TaskId.CheckFreezer] = 1,
			[Constants.TaskId.CloseRegister] = 1,
		},
	},
}

local function copyQuotaMap(source)
	local clone = {}

	for _, taskId in ipairs(Constants.TaskOrder) do
		clone[taskId] = source[taskId] or 0
	end

	return clone
end

local Config = {
	intermissionSeconds = Constants.Round.IntermissionSeconds,
	durationSeconds = Constants.Round.DurationSeconds,
	endedSeconds = Constants.Round.EndedSeconds,
	minPlayers = Constants.Round.MinPlayers,
	maxPlayers = Constants.Round.MaxPlayers,
	taskOrder = Constants.TaskOrder,
}

function Config.getQuotaTemplate(playerCount: number)
	for _, bundle in ipairs(quotaBundles) do
		if playerCount >= bundle.minPlayers and playerCount <= bundle.maxPlayers then
			return copyQuotaMap(bundle.quotas)
		end
	end

	return copyQuotaMap(quotaBundles[#quotaBundles].quotas)
end

function Config.getTotalRequired(quotas)
	local total = 0

	for _, taskId in ipairs(Constants.TaskOrder) do
		total += quotas[taskId] or 0
	end

	return total
end

return Config
