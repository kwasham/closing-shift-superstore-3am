local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local roundStateChanged = remotes:WaitForChild("RoundStateChanged")
local taskProgressChanged = remotes:WaitForChild("TaskProgressChanged")
local alertRaised = remotes:WaitForChild("AlertRaised")

local gui = Instance.new("ScreenGui")
gui.Name = "ShiftHUD"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "Panel"
frame.Size = UDim2.fromScale(0.3, 0.18)
frame.Position = UDim2.fromScale(0.02, 0.03)
frame.BackgroundTransparency = 0.15
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local function makeLabel(name: string, y: number, textSize: number)
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Size = UDim2.fromScale(0.92, 0.2)
	label.Position = UDim2.fromScale(0.04, y)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = textSize
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = ""
	label.Parent = frame
	return label
end

local title = makeLabel("Title", 0.05, 16)
local state = makeLabel("State", 0.28, 18)
local progress = makeLabel("Progress", 0.52, 16)
local alert = makeLabel("Alert", 0.76, 14)

title.Text = "CLOSING SHIFT"

roundStateChanged.OnClientEvent:Connect(function(payload)
	if typeof(payload) == "table" then
		state.Text = "State: " .. tostring(payload.state)
		if payload.progress then
			progress.Text = string.format(
				"Objectives: %d/%d",
				payload.progress.completed or 0,
				payload.progress.total or 0
			)
		end
	end
end)

taskProgressChanged.OnClientEvent:Connect(function(nextProgress)
	progress.Text =
		string.format("Objectives: %d/%d", nextProgress.completed or 0, nextProgress.total or 0)
end)

alertRaised.OnClientEvent:Connect(function(message)
	alert.Text = tostring(message)
	task.delay(3, function()
		if alert.Text == tostring(message) then
			alert.Text = ""
		end
	end)
end)
