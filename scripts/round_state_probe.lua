local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RoundStateChanged = Remotes:WaitForChild("RoundStateChanged")

local latest = nil
RoundStateChanged.OnClientEvent:Connect(function(payload)
	if typeof(payload) == "table" then
		latest = payload.state or latest
		print("ROUND_STATE", tostring(latest), tostring(payload.timerSeconds))
	else
		print("ROUND_STATE_PAYLOAD", typeof(payload))
	end
end)

task.wait(20)
print("ROUND_STATE_FINAL", tostring(latest))
