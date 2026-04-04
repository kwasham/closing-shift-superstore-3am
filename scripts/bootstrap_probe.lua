local Workspace = game:GetService("Workspace")

task.wait(3)
print("BOOTSTRAP floor", Workspace:FindFirstChild("ShiftArenaFloor") ~= nil)
print("BOOTSTRAP spawn", Workspace:FindFirstChild("ShiftSpawn") ~= nil)
print("BOOTSTRAP tasknodes", Workspace:FindFirstChild("TaskNodes") ~= nil)
print("BOOTSTRAP events", Workspace:FindFirstChild("EventNodes") ~= nil)
