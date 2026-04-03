local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))
local Config = require(ServerScriptService.Round:WaitForChild("Config"))
local TaskService = require(ServerScriptService.Round:WaitForChild("TaskService"))

local function makePlayer(userId, name)
	return {
		UserId = userId,
		Name = name,
		Parent = Workspace,
	}
end

local activePlayer = makePlayer(101, "Active")
local lateJoiner = makePlayer(303, "LateJoiner")

local targetAlerts = {}

local service = TaskService.new({
	sendAlert = function(message, targetPlayer)
		if targetPlayer ~= nil then
			local bucket = targetAlerts[targetPlayer.UserId]
			if bucket == nil then
				bucket = {}
				targetAlerts[targetPlayer.UserId] = bucket
			end
			table.insert(bucket, tostring(message))
		end
	end,
	onProgressChanged = function() end,
	onRoundSuccess = function() end,
	onMimicTriggered = function() end,
})

service:startRound({ activePlayer }, Config.getQuotaTemplate(1))

local node = nil
for _, candidate in ipairs(service.nodes) do
	if candidate.taskId == Constants.TaskId.RestockShelf then
		node = candidate
		break
	end
end

if node == nil then
	error("late join proof: missing restock node")
end

local beforeProgress = service:getProgressSnapshot()
service:_handlePromptTriggered(node, lateJoiner)
local afterProgress = service:getProgressSnapshot()
local lateAlerts = targetAlerts[lateJoiner.UserId] or {}
local lastAlert = lateAlerts[#lateAlerts]
local canParticipate = afterProgress.completed ~= beforeProgress.completed

print(
	string.format(
		"LATE_JOIN_PROOF progress_before=%d progress_after=%d",
		beforeProgress.completed,
		afterProgress.completed
	)
)
print(
	string.format(
		"LATE_JOIN_PROOF banked_before=%d banked_after=%d",
		beforeProgress.bankedPay,
		afterProgress.bankedPay
	)
)
print(string.format("LATE_JOIN_PROOF late_join_alert=%s", tostring(lastAlert)))
print(string.format("LATE_JOIN_PROOF can_participate=%s", tostring(canParticipate)))

if canParticipate then
	error("late join proof: late joiner changed round progress")
end

if lastAlert ~= Constants.Alerts.MidRoundJoin then
	error("late join proof: late joiner did not receive expected wait alert")
end

print("LATE_JOIN_PROOF_OK")
