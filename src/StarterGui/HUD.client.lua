local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local roundStateChanged = remotes:WaitForChild("RoundStateChanged")
local taskProgressChanged = remotes:WaitForChild("TaskProgressChanged")
local alertRaised = remotes:WaitForChild("AlertRaised")

local gui = Instance.new("ScreenGui")
gui.Name = "ShiftHUD"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "Panel"
frame.Size = UDim2.fromScale(0.5, 0)
frame.AutomaticSize = Enum.AutomaticSize.Y
frame.Position = UDim2.fromScale(0.02, 0.03)
frame.BackgroundTransparency = 0.12
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
frame.Parent = gui

local sizeConstraint = Instance.new("UISizeConstraint")
sizeConstraint.MinSize = Vector2.new(260, 0)
sizeConstraint.MaxSize = Vector2.new(360, 720)
sizeConstraint.Parent = frame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Transparency = 0.78
stroke.Parent = frame

local listLayout = Instance.new("UIListLayout")
listLayout.FillDirection = Enum.FillDirection.Vertical
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = frame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)
padding.PaddingLeft = UDim.new(0, 12)
padding.PaddingRight = UDim.new(0, 12)
padding.Parent = frame

local function makeLabel(name: string, _height: number, textSize: number, bold: boolean?)
	local label = Instance.new("TextLabel")
	label.Name = name
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.Size = UDim2.fromScale(1, 0)
	label.BackgroundTransparency = 1
	label.Font = if bold then Enum.Font.GothamBold else Enum.Font.GothamMedium
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = textSize
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.Text = ""
	label.Parent = frame
	return label
end

local title = makeLabel("Title", 22, 16, true)
local stateLabel = makeLabel("State", 22, 14, true)
local timerLabel = makeLabel("Timer", 20, 14)
local cashLabel = makeLabel("Cash", 20, 14)
local bankedLabel = makeLabel("Banked", 38, 14)
local objectivesLabel = makeLabel("Objectives", 82, 13)
local alertLabel = makeLabel("Alert", 42, 13, true)

local latestState = Constants.RoundState.Waiting
local latestTimer = 0
local latestProgress = nil
local latestActiveUserIds = {}
local cashValue = nil

local function formatTime(secondsRemaining)
	local safeSeconds = math.max(0, secondsRemaining)
	local minutes = math.floor(safeSeconds / 60)
	local seconds = safeSeconds % 60
	return string.format("%02d:%02d", minutes, seconds)
end

local function isLocalPlayerActiveInSnapshot()
	for _, userId in ipairs(latestActiveUserIds) do
		if userId == localPlayer.UserId then
			return true
		end
	end

	return false
end

local function isWaitingForNextShift()
	local roundHasSnapshot = #latestActiveUserIds > 0
	local roundIsClosing = latestState == Constants.RoundState.Playing
		or latestState == Constants.RoundState.Ended
	return roundHasSnapshot and roundIsClosing and not isLocalPlayerActiveInSnapshot()
end

local function getLocalPenalty(progress)
	if progress == nil or progress.personalPenalties == nil then
		return 0
	end

	return progress.personalPenalties[localPlayer.UserId] or 0
end

local function getProjectedPayoutText(progress)
	if isWaitingForNextShift() then
		return "Current shift is locked to the starting roster. You'll clock in next round."
	end

	if progress == nil then
		return "Banked this shift: $0"
	end

	local penalty = getLocalPenalty(progress)
	local successPay = math.max(0, progress.bankedPay + Constants.Payout.SuccessBonus - penalty)
	local failPay =
		math.max(0, math.floor(progress.bankedPay * Constants.Payout.FailureMultiplier) - penalty)
	return string.format(
		"Banked this shift: $%d | You clear: $%d | If time runs out: $%d",
		progress.bankedPay,
		successPay,
		failPay
	)
end

local function formatObjectives(progress)
	if isWaitingForNextShift() then
		return "Objectives: Shift in progress. Wait for the next one."
	end

	if progress == nil then
		return "Objectives: waiting for the next shift"
	end

	local remaining = progress.remainingByTask or {}
	local registerLine = if progress.registerCompleted
		then "Register: closed"
		elseif progress.registerUnlocked then "Register: ready"
		else "Register: locked"

	return table.concat({
		string.format(
			"Objectives: %d/%d complete",
			progress.completed or 0,
			progress.totalRequired or 0
		),
		string.format(
			"Restock %d | Spill %d | Trash %d",
			remaining[Constants.TaskId.RestockShelf] or 0,
			remaining[Constants.TaskId.CleanSpill] or 0,
			remaining[Constants.TaskId.TakeOutTrash] or 0
		),
		string.format(
			"Cart %d | Freezer %d | %s",
			remaining[Constants.TaskId.ReturnCart] or 0,
			remaining[Constants.TaskId.CheckFreezer] or 0,
			registerLine
		),
	}, "\n")
end

local function updateHud()
	title.Text = "CLOSING SHIFT"
	stateLabel.Text = if isWaitingForNextShift()
		then "State: Waiting for next shift"
		else "State: " .. tostring(latestState)
	timerLabel.Text = "Timer: " .. formatTime(latestTimer)
	cashLabel.Text = string.format("Saved cash: $%d", cashValue and cashValue.Value or 0)
	bankedLabel.Text = getProjectedPayoutText(latestProgress)
	objectivesLabel.Text = formatObjectives(latestProgress)

	if isWaitingForNextShift() then
		alertLabel.Text = "Alert: " .. Constants.Alerts.MidRoundJoin
	elseif alertLabel.Text == "Alert: " .. Constants.Alerts.MidRoundJoin then
		alertLabel.Text = ""
	end

	if alertLabel.Text == "" then
		if latestState == Constants.RoundState.Intermission then
			alertLabel.Text = "Alert: Shift starts when intermission ends."
		elseif latestState == Constants.RoundState.Playing then
			alertLabel.Text = "Alert: Bank task value, unlock the register, then close out."
		elseif latestState == Constants.RoundState.Ended then
			alertLabel.Text = "Alert: Round over. Payout is landing now."
		else
			alertLabel.Text = "Alert: Waiting for enough staff to start."
		end
	elseif not string.match(alertLabel.Text, "^Alert:") then
		alertLabel.Text = "Alert: " .. alertLabel.Text
	end
end

local function bindCashValue()
	local leaderstats = localPlayer:WaitForChild("leaderstats")
	cashValue = leaderstats:WaitForChild("Cash")
	cashValue:GetPropertyChangedSignal("Value"):Connect(updateHud)
end

roundStateChanged.OnClientEvent:Connect(function(payload)
	if typeof(payload) ~= "table" then
		return
	end

	latestState = payload.state or latestState
	latestTimer = payload.timerSeconds or latestTimer
	if payload.activeUserIds ~= nil then
		latestActiveUserIds = payload.activeUserIds
	end
	if payload.progress ~= nil then
		latestProgress = payload.progress
	end
	updateHud()
end)

taskProgressChanged.OnClientEvent:Connect(function(nextProgress)
	latestProgress = nextProgress
	updateHud()
end)

alertRaised.OnClientEvent:Connect(function(message)
	if isWaitingForNextShift() then
		alertLabel.Text = ""
		updateHud()
		return
	end

	alertLabel.Text = "Alert: " .. tostring(message)
	updateHud()
	task.delay(4, function()
		if alertLabel.Text == "Alert: " .. tostring(message) then
			alertLabel.Text = ""
			updateHud()
		end
	end)
end)

bindCashValue()
updateHud()
