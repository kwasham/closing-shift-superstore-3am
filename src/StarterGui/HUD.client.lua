local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))
local UIStrings = require(Shared:WaitForChild("UIStrings"))

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local roundStateChanged = remotes:WaitForChild("RoundStateChanged")
local taskProgressChanged = remotes:WaitForChild("TaskProgressChanged")
local alertRaised = remotes:WaitForChild("AlertRaised")

local existingGui = playerGui:FindFirstChild("ShiftHUD")
if existingGui ~= nil then
	existingGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "ShiftHUD"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 20
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
sizeConstraint.MinSize = Vector2.new(284, 0)
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

local function makeLabel(name: string, textSize: number, bold: boolean?)
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

local title = makeLabel("Title", 16, true)
local stateLabel = makeLabel("State", 14, true)
local timerLabel = makeLabel("Timer", 14, false)
local cashLabel = makeLabel("Cash", 14, false)
local earningsLabel = makeLabel("Earnings", 14, false)
local objectivesLabel = makeLabel("Objectives", 13, false)
local alertLabel = makeLabel("Alert", 13, true)

local latestState = Constants.RoundState.Waiting
local latestTimer = 0
local latestProgress = nil
local latestActiveUserIds = {}
local latestRoundResult = nil
local cashValue = nil
local remoteAlert = nil
local pendingRemoteAlert = nil
local tutorialAlert = nil
local previousProgressCompleted = 0
local previousRegisterUnlocked = false
local tutorialStartToken = 0
local playingStartedToken = 0
local previousState = latestState

local tutorial = {
	sessionStarted = false,
	steps = {
		goal = false,
		follow_task = false,
		banked_pay = false,
		register_end = false,
	},
}

local function cloneTimedAlert(definition)
	local duration = definition.duration
	return {
		id = definition.id,
		message = definition.message,
		priority = definition.priority,
		duration = duration,
		expiresAt = if duration ~= nil then os.clock() + duration else nil,
		pinned = definition.pinned == true,
		cueId = definition.cueId,
	}
end

local function normalizeAlertPayload(payload)
	if typeof(payload) == "string" then
		return {
			id = payload,
			message = payload,
			priority = UIStrings.AlertPriority.Prompt,
			duration = 3,
			pinned = false,
		}
	end

	if typeof(payload) == "table" then
		return {
			id = payload.id or payload.message or "custom_alert",
			message = payload.message or tostring(payload.id or "Alert"),
			priority = payload.priority or UIStrings.AlertPriority.Prompt,
			duration = payload.duration,
			pinned = payload.pinned == true,
			cueId = payload.cueId,
		}
	end

	return {
		id = "unknown_alert",
		message = tostring(payload),
		priority = UIStrings.AlertPriority.Prompt,
		duration = 3,
		pinned = false,
	}
end

local function activateAlert(alertData)
	return cloneTimedAlert(alertData)
end

local function formatTime(secondsRemaining)
	local safeSeconds = math.max(0, secondsRemaining)
	local minutes = math.floor(safeSeconds / 60)
	local seconds = safeSeconds % 60
	return string.format("%02d:%02d", minutes, seconds)
end

local function isLocalPlayerActiveInSnapshot()
	return table.find(latestActiveUserIds, localPlayer.UserId) ~= nil
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

local function calculateSuccessPay(progress)
	if progress == nil then
		return Constants.Payout.SuccessBonus
	end

	return math.max(
		0,
		progress.bankedPay + Constants.Payout.SuccessBonus - getLocalPenalty(progress)
	)
end

local function calculateTimeoutPay(progress)
	if progress == nil then
		return 0
	end

	return math.max(
		0,
		math.floor(progress.bankedPay * Constants.Payout.FailureMultiplier)
			- getLocalPenalty(progress)
	)
end

local function getDerivedPinnedAlert()
	if isWaitingForNextShift() then
		return UIStrings.Alerts.late_join_wait
	end

	if latestProgress ~= nil and latestProgress.blackoutActive then
		return UIStrings.Alerts.blackout_active
	end

	if latestState == Constants.RoundState.Ended then
		if latestRoundResult == "success" then
			return UIStrings.Alerts.round_success
		end
		if latestRoundResult == "failure" then
			return UIStrings.Alerts.round_failure
		end
	end

	return nil
end

local function tickAlerts()
	local changed = false
	local now = os.clock()

	if remoteAlert ~= nil and remoteAlert.expiresAt ~= nil and now >= remoteAlert.expiresAt then
		remoteAlert = nil
		changed = true
	end

	if
		tutorialAlert ~= nil
		and tutorialAlert.expiresAt ~= nil
		and now >= tutorialAlert.expiresAt
	then
		tutorialAlert = nil
		changed = true
	end

	if remoteAlert == nil and pendingRemoteAlert ~= nil and getDerivedPinnedAlert() == nil then
		remoteAlert = activateAlert(pendingRemoteAlert)
		pendingRemoteAlert = nil
		changed = true
	end

	return changed
end

local function pushRemoteAlert(payload)
	local alertData = normalizeAlertPayload(payload)
	if isWaitingForNextShift() and alertData.priority < UIStrings.AlertPriority.Pinned then
		return
	end

	if remoteAlert ~= nil and remoteAlert.id == alertData.id then
		remoteAlert = activateAlert(alertData)
		return
	end

	if remoteAlert == nil then
		remoteAlert = activateAlert(alertData)
		return
	end

	if alertData.priority > remoteAlert.priority then
		if
			remoteAlert.priority >= UIStrings.AlertPriority.Important
			and alertData.priority >= UIStrings.AlertPriority.Urgent
		then
			pendingRemoteAlert = {
				id = remoteAlert.id,
				message = remoteAlert.message,
				priority = remoteAlert.priority,
				duration = remoteAlert.duration,
				pinned = remoteAlert.pinned,
				cueId = remoteAlert.cueId,
			}
		elseif pendingRemoteAlert == nil or alertData.priority >= pendingRemoteAlert.priority then
			pendingRemoteAlert = nil
		end

		remoteAlert = activateAlert(alertData)
		return
	end

	if pendingRemoteAlert == nil or alertData.priority >= pendingRemoteAlert.priority then
		pendingRemoteAlert = alertData
	end
end

local function startTutorialStep(stepKey)
	if tutorial.steps[stepKey] then
		return
	end

	local definition = UIStrings.Tutorial[stepKey]
	if definition == nil then
		return
	end

	tutorial.steps[stepKey] = true
	tutorialAlert = activateAlert(definition)

	if stepKey == "register_end" then
		pendingRemoteAlert = UIStrings.Alerts.register_unlocked
	end
end

local function scheduleTutorialGoalIfEligible()
	if tutorial.sessionStarted then
		return
	end

	tutorialStartToken += 1
	local token = tutorialStartToken
	task.delay(1, function()
		if tutorialStartToken ~= token then
			return
		end
		if tutorial.sessionStarted then
			return
		end
		if latestState ~= Constants.RoundState.Intermission then
			return
		end
		if isWaitingForNextShift() then
			return
		end

		tutorial.sessionStarted = true
		startTutorialStep("goal")
	end)
end

local function scheduleBankedTutorial()
	playingStartedToken += 1
	local token = playingStartedToken
	task.delay(20, function()
		if playingStartedToken ~= token then
			return
		end
		if latestState ~= Constants.RoundState.Playing then
			return
		end
		if not tutorial.sessionStarted or tutorial.steps.banked_pay then
			return
		end
		startTutorialStep("banked_pay")
	end)
end

local function getVisibleAlertText()
	tickAlerts()

	local pinnedAlert = getDerivedPinnedAlert()
	if pinnedAlert ~= nil then
		return pinnedAlert.message
	end

	if remoteAlert ~= nil and tutorialAlert ~= nil then
		if tutorialAlert.priority >= remoteAlert.priority then
			return tutorialAlert.message
		end
		return remoteAlert.message
	end

	if remoteAlert ~= nil then
		return remoteAlert.message
	end

	if tutorialAlert ~= nil then
		return tutorialAlert.message
	end

	if isWaitingForNextShift() then
		return UIStrings.Alerts.late_join_wait.message
	end

	if latestState == Constants.RoundState.Intermission then
		return UIStrings.AmbientAlerts.Intermission
	end
	if latestState == Constants.RoundState.Playing then
		return UIStrings.AmbientAlerts.Playing
	end
	if latestState == Constants.RoundState.Ended then
		return UIStrings.AmbientAlerts.Ended
	end
	return UIStrings.AmbientAlerts.Waiting
end

local function buildObjectivesText()
	if isWaitingForNextShift() then
		return table.concat({
			"This shift started without you.",
			"Clock in next round to take tasks and earn payout.",
		}, "\n")
	end

	if
		latestState == Constants.RoundState.Ended
		and latestRoundResult ~= nil
		and latestProgress ~= nil
	then
		local header = if latestRoundResult == "success" then "SHIFT CLEARED" else "SHIFT FAILED"
		return table.concat({
			header,
			string.format(
				"Tasks: %d/%d",
				latestProgress.completed or 0,
				latestProgress.totalRequired or 0
			),
		}, "\n")
	end

	if latestProgress == nil or latestProgress.totalRequired == 0 then
		if latestState == Constants.RoundState.Intermission then
			return "Shift starts after intermission."
		end
		if latestState == Constants.RoundState.Waiting then
			return "Waiting for enough staff to clock in."
		end
		return "Tasks: 0/0"
	end

	local remaining = latestProgress.remainingByTask or {}
	local registerState = if latestProgress.registerCompleted
		then "closed"
		elseif latestProgress.registerUnlocked then "ready"
		else "locked"

	return table.concat({
		string.format(
			"Tasks: %d/%d",
			latestProgress.completed or 0,
			latestProgress.totalRequired or 0
		),
		string.format(
			"Restock %d | Spill %d | Trash %d",
			remaining[Constants.TaskId.RestockShelf] or 0,
			remaining[Constants.TaskId.CleanSpill] or 0,
			remaining[Constants.TaskId.TakeOutTrash] or 0
		),
		string.format(
			"Cart %d | Freezer %d | Reg %s",
			remaining[Constants.TaskId.ReturnCart] or 0,
			remaining[Constants.TaskId.CheckFreezer] or 0,
			registerState
		),
	}, "\n")
end

local function buildEarningsText()
	if isWaitingForNextShift() then
		return table.concat({
			"Shift Cash: $0",
			"This shift started without you.",
			"Next shift payout is what can add to Saved Cash.",
		}, "\n")
	end

	if
		latestState == Constants.RoundState.Ended
		and latestRoundResult ~= nil
		and latestProgress ~= nil
	then
		local penalty = getLocalPenalty(latestProgress)
		local bankedPay = latestProgress.bankedPay or 0
		local success = latestRoundResult == "success"
		local lines = {
			string.format("Shift Cash: $%d", bankedPay),
		}

		if success then
			table.insert(lines, string.format("Clear bonus: +$%d", Constants.Payout.SuccessBonus))
		else
			table.insert(
				lines,
				string.format(
					"Timeout pay (60%%): $%d",
					math.floor(bankedPay * Constants.Payout.FailureMultiplier)
				)
			)
		end

		if penalty > 0 then
			table.insert(lines, string.format("False task penalty: -$%d", penalty))
		end

		table.insert(
			lines,
			string.format(
				"Saved Cash added: +$%d",
				if success
					then calculateSuccessPay(latestProgress)
					else calculateTimeoutPay(latestProgress)
			)
		)

		return table.concat(lines, "\n")
	end

	local successPay = calculateSuccessPay(latestProgress)
	local timeoutPay = calculateTimeoutPay(latestProgress)
	local lines = {
		string.format(
			"Shift Cash: $%d",
			if latestProgress ~= nil then latestProgress.bankedPay or 0 else 0
		),
		string.format("If you clear: +$%d | If time runs out: +$%d", successPay, timeoutPay),
	}

	local penalty = getLocalPenalty(latestProgress)
	if penalty > 0 then
		table.insert(lines, string.format("False task penalty: -$%d", penalty))
	end

	return table.concat(lines, "\n")
end

local function getStateText()
	if isWaitingForNextShift() then
		return UIStrings.State.LateJoin
	end

	return UIStrings.State[latestState] or tostring(latestState)
end

local function updateHud()
	title.Text = "CLOSING SHIFT"
	stateLabel.Text = "State: " .. getStateText()
	timerLabel.Text = "Timer: " .. formatTime(latestTimer)
	cashLabel.Text = string.format("Saved Cash: $%d", cashValue and cashValue.Value or 0)
	earningsLabel.Text = buildEarningsText()
	objectivesLabel.Text = buildObjectivesText()
	alertLabel.Text = getVisibleAlertText()
end

local function evaluateTutorialTriggers()
	if latestState ~= Constants.RoundState.Playing or not tutorial.sessionStarted then
		return
	end

	local completedNow = if latestProgress ~= nil then latestProgress.completed or 0 else 0
	if not tutorial.steps.banked_pay and previousProgressCompleted == 0 and completedNow > 0 then
		startTutorialStep("banked_pay")
	end

	local registerUnlockedNow = latestProgress ~= nil and latestProgress.registerUnlocked == true
	if not tutorial.steps.register_end and not previousRegisterUnlocked and registerUnlockedNow then
		startTutorialStep("register_end")
	end

	previousProgressCompleted = completedNow
	previousRegisterUnlocked = registerUnlockedNow
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

	previousState = latestState
	latestState = payload.state or latestState
	latestTimer = payload.timerSeconds or latestTimer
	latestRoundResult = payload.roundResult or nil
	if payload.activeUserIds ~= nil then
		latestActiveUserIds = payload.activeUserIds
	end
	if payload.progress ~= nil then
		latestProgress = payload.progress
	elseif
		latestState == Constants.RoundState.Waiting
		or latestState == Constants.RoundState.Intermission
	then
		latestProgress = nil
	end

	if latestState ~= previousState then
		if latestState == Constants.RoundState.Intermission then
			previousProgressCompleted = 0
			previousRegisterUnlocked = false
			scheduleTutorialGoalIfEligible()
		elseif latestState == Constants.RoundState.Playing then
			previousProgressCompleted = if latestProgress ~= nil
				then latestProgress.completed or 0
				else 0
			previousRegisterUnlocked = latestProgress ~= nil
				and latestProgress.registerUnlocked == true
			if
				tutorial.sessionStarted
				and tutorial.steps.goal
				and not tutorial.steps.follow_task
			then
				startTutorialStep("follow_task")
			end
			scheduleBankedTutorial()
		elseif tutorialAlert ~= nil and tutorialAlert.id == UIStrings.Tutorial.goal.id then
			tutorialAlert = nil
		end
	end

	if latestState ~= Constants.RoundState.Playing then
		playingStartedToken += 1
	end

	evaluateTutorialTriggers()
	updateHud()
end)

taskProgressChanged.OnClientEvent:Connect(function(nextProgress)
	latestProgress = nextProgress
	evaluateTutorialTriggers()
	updateHud()
end)

alertRaised.OnClientEvent:Connect(function(payload)
	pushRemoteAlert(payload)
	updateHud()
end)

ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
	if latestState ~= Constants.RoundState.Playing then
		return
	end
	if prompt == nil or prompt.Parent == nil or not prompt.Enabled then
		return
	end

	local taskNodes = Workspace:FindFirstChild("TaskNodes")
	if taskNodes == nil or not prompt.Parent:IsDescendantOf(taskNodes) then
		return
	end

	if tutorialAlert ~= nil and tutorialAlert.id == UIStrings.Tutorial.follow_task.id then
		tutorialAlert = nil
		updateHud()
	end
end)

bindCashValue()
updateHud()

task.spawn(function()
	while gui.Parent ~= nil do
		if tickAlerts() then
			updateHud()
		end
		task.wait(0.1)
	end
end)
