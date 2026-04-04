local ServerScriptService = game:GetService("ServerScriptService")
local roundFolder = ServerScriptService:WaitForChild("Round")
local taskServiceModule = roundFolder:WaitForChild("TaskService")

local okRequire, taskService = pcall(require, taskServiceModule)
print("TASKSERVICE_REQUIRE", okRequire, if okRequire then "ok" else tostring(taskService))
if not okRequire then
	return
end

local function noop() end
local okNew, result = pcall(function()
	return taskService.new({
		sendAlert = noop,
		onRoundSuccess = noop,
		onProgressChanged = noop,
		onTaskCompleted = noop,
		onMimicTriggered = noop,
		onMimicExpired = noop,
		onSecurityAlarmTriggered = function()
			return false
		end,
	})
end)
print("TASKSERVICE_NEW", okNew, if okNew then "ok" else tostring(result))
