local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local roundFolder = ServerScriptService:WaitForChild("Round")
local ShiftService = require(roundFolder:WaitForChild("ShiftService"))

ShiftService.stop()

local playerA = {
	UserId = 9201,
	Name = "TwoPlayerA",
	Parent = Workspace,
}

local playerB = {
	UserId = 9202,
	Name = "TwoPlayerB",
	Parent = Workspace,
}

local observedPlayingPayload = nil
local proofService = ShiftService.new({
	networkEnabled = false,
	getPlayers = function()
		return { playerA, playerB }
	end,
	intermissionSeconds = 1,
	durationSeconds = 30,
	endDelaySeconds = 0,
	heartbeatSeconds = 0.1,
	onStateChanged = function(payload)
		if payload.state == Constants.RoundState.Playing and payload.progress ~= nil then
			observedPlayingPayload = payload
		end
	end,
})

proofService:run()

local deadline = os.clock() + 4
while observedPlayingPayload == nil and os.clock() < deadline do
	task.wait(0.1)
end

assert(observedPlayingPayload ~= nil, "Two-player round never entered playing")
assert(#observedPlayingPayload.activeUserIds == 2, "Expected two active user ids")

local progressBefore = proofService.taskService:getProgressSnapshot()
proofService.taskService:handlePromptTriggeredForNodeId("restock_shelf_node", playerA)
proofService.taskService:handlePromptTriggeredForNodeId("return_cart_node", playerB)
local progressAfter = proofService.taskService:getProgressSnapshot()
local taskCounts = proofService.taskService:getPlayerTaskCountsByUserId()

assert(
	progressAfter.completed == progressBefore.completed + 2,
	"Two-player completions did not register"
)
assert(
	(taskCounts[playerA.UserId] or {})[Constants.TaskId.RestockShelf] == 1,
	"Player A task count missing"
)
assert(
	(taskCounts[playerB.UserId] or {})[Constants.TaskId.ReturnCart] == 1,
	"Player B task count missing"
)

print(
	string.format(
		"S7_2P_SANITY active=%d completed_before=%d completed_after=%d",
		#observedPlayingPayload.activeUserIds,
		progressBefore.completed or -1,
		progressAfter.completed or -1
	)
)
print(
	string.format(
		"S7_2P_SANITY player_a_restock=%d player_b_cart=%d",
		(taskCounts[playerA.UserId] or {})[Constants.TaskId.RestockShelf] or 0,
		(taskCounts[playerB.UserId] or {})[Constants.TaskId.ReturnCart] or 0
	)
)
print("S7_2P_SANITY_OK")

proofService:shutdown()
