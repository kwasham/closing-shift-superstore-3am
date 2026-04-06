local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

local function assertChild(parent, childName)
	local child = parent:FindFirstChild(childName)
	if child == nil then
		error(string.format("%s missing child %s", parent:GetFullName(), childName))
	end
	return child
end

assertChild(ServerScriptService, "Bootstrap")
assertChild(StarterGui, "HUD")
assertChild(StarterGui, "ClientEffects")
assertChild(StarterGui, "LightingController")

local shared = assertChild(ReplicatedStorage, "Shared")
assertChild(shared, "StoreSignage")
assertChild(shared, "StoreRollout")
assertChild(shared, "VisualTheme")
assertChild(Workspace, "FallbackArena")

local roundFolder = assertChild(ServerScriptService, "Round")
local taskServiceModule = assertChild(roundFolder, "TaskService")

local deadline = os.clock() + 2
while os.clock() < deadline do
	if
		Workspace:FindFirstChild("ShiftArenaFloor") ~= nil
		and Workspace:FindFirstChild("TaskNodes") ~= nil
		and Workspace:FindFirstChild("EventNodes") ~= nil
	then
		break
	end
	task.wait(0.1)
end

if
	Workspace:FindFirstChild("ShiftArenaFloor") == nil
	or Workspace:FindFirstChild("TaskNodes") == nil
	or Workspace:FindFirstChild("EventNodes") == nil
then
	local taskService = require(taskServiceModule)
	taskService.new({
		sendAlert = function() end,
		onRoundSuccess = function() end,
		onProgressChanged = function() end,
		onTaskCompleted = function() end,
		onMimicTriggered = function() end,
		onMimicExpired = function() end,
		onSecurityAlarmTriggered = function()
			return false
		end,
	})
end

assertChild(Workspace, "ShiftArenaFloor")
assertChild(Workspace, "TaskNodes")
assertChild(Workspace, "EventNodes")

print("SMOKE_OK: core folders and scripts are present")
print("SMOKE_OK: sprint 7 art rollout sources are present")
