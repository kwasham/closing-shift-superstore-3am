local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local roundFolder = ServerScriptService:WaitForChild("Round")
local ShiftService = require(roundFolder:WaitForChild("ShiftService"))

ShiftService.stop()

local fakePlayer = {
	UserId = 9101,
	Name = "ProofCloser",
	Parent = Workspace,
}

local observedStates = {}
local observedPlayingPayload = nil

local noopEventService = {
	startRound = function() end,
	update = function() end,
	endRound = function() end,
	handleMimicTriggered = function() end,
	handleMimicExpired = function() end,
	handleSecurityAlarmTriggered = function()
		return false
	end,
}

local proofService = ShiftService.new({
	networkEnabled = false,
	getPlayers = function()
		return { fakePlayer }
	end,
	eventService = noopEventService,
	profileStore = {
		addCash = function()
			return 0
		end,
	},
	intermissionSeconds = 1,
	durationSeconds = 30,
	endDelaySeconds = 0,
	heartbeatSeconds = 0.1,
	onStateChanged = function(payload)
		table.insert(
			observedStates,
			string.format("%s:%s", tostring(payload.state), tostring(payload.timerSeconds))
		)
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

assert(Workspace:FindFirstChild("ShiftArenaFloor") ~= nil, "ShiftArenaFloor was not created")
assert(Workspace:FindFirstChild("ShiftSpawn") ~= nil, "ShiftSpawn was not created")
assert(Workspace:FindFirstChild("TaskNodes") ~= nil, "TaskNodes was not created")
assert(observedPlayingPayload ~= nil, "Round never entered playing")

local progressBefore = proofService.taskService:getProgressSnapshot()
proofService.taskService:handlePromptTriggeredForNodeId("clean_spill_node", fakePlayer)
local progressAfter = proofService.taskService:getProgressSnapshot()

assert(
	progressAfter.completed == progressBefore.completed + 1,
	"Task completion did not increment progress"
)
assert(
	(progressAfter.remainingByTask[Constants.TaskId.CleanSpill] or -1)
		== math.max(0, (progressBefore.remainingByTask[Constants.TaskId.CleanSpill] or 0) - 1),
	"Clean spill quota did not decrement"
)

print("ROUND_BOOTSTRAP_PROOF states=" .. table.concat(observedStates, ","))
print(
	string.format(
		"ROUND_BOOTSTRAP_PROOF playing active=%d timer=%d total=%d completed_before=%d completed_after=%d",
		#observedPlayingPayload.activeUserIds,
		observedPlayingPayload.timerSeconds or -1,
		progressBefore.totalRequired or -1,
		progressBefore.completed or -1,
		progressAfter.completed or -1
	)
)
print(
	string.format(
		"ROUND_BOOTSTRAP_PROOF clean_spill_remaining_before=%d after=%d",
		progressBefore.remainingByTask[Constants.TaskId.CleanSpill] or -1,
		progressAfter.remainingByTask[Constants.TaskId.CleanSpill] or -1
	)
)

proofService:shutdown()
print("ROUND_BOOTSTRAP_PROOF_OK")
