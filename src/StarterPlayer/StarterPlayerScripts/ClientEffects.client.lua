local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local alertRaised = remotes:WaitForChild("AlertRaised")

local existingGui = playerGui:FindFirstChild("ShiftPresentation")
if existingGui ~= nil then
	existingGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "ShiftPresentation"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 10
gui.Parent = playerGui

local blackoutOverlay = Instance.new("Frame")
blackoutOverlay.Name = "BlackoutOverlay"
blackoutOverlay.Size = UDim2.fromScale(1, 1)
blackoutOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
blackoutOverlay.BackgroundTransparency = 1
blackoutOverlay.BorderSizePixel = 0
blackoutOverlay.Parent = gui

local flashOverlay = Instance.new("Frame")
flashOverlay.Name = "FlashOverlay"
flashOverlay.Size = UDim2.fromScale(1, 1)
flashOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
flashOverlay.BackgroundTransparency = 1
flashOverlay.BorderSizePixel = 0
flashOverlay.Parent = gui

local trackedNodes = {}
local taskFolderConnection = nil
local activeBlackoutTween = nil
local activeFlashTween = nil

local function isTaskPrompt(prompt)
	local taskNodes = Workspace:FindFirstChild("TaskNodes")
	return taskNodes ~= nil
		and prompt ~= nil
		and prompt.Parent ~= nil
		and prompt.Parent:IsDescendantOf(taskNodes)
end

local function tweenOverlay(frame, properties, duration)
	local tween = TweenService:Create(
		frame,
		TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		properties
	)
	tween:Play()
	return tween
end

local function setBlackoutOverlay(active)
	if activeBlackoutTween ~= nil then
		activeBlackoutTween:Cancel()
	end

	activeBlackoutTween = tweenOverlay(
		blackoutOverlay,
		{ BackgroundTransparency = if active then 0.72 else 1 },
		if active then 0.25 else 0.35
	)
end

local function flashScreen(color, transparency, duration)
	if activeFlashTween ~= nil then
		activeFlashTween:Cancel()
	end

	flashOverlay.BackgroundColor3 = color
	flashOverlay.BackgroundTransparency = transparency
	activeFlashTween = tweenOverlay(flashOverlay, { BackgroundTransparency = 1 }, duration)
end

local function getNodeStyle(part, state)
	local baseColor = part.Color
	if state == "available" then
		return {
			fillColor = baseColor,
			outlineColor = Color3.fromRGB(255, 255, 255),
			fillTransparency = 0.9,
			outlineTransparency = 0.18,
			pulse = 0.05,
		}
	end
	if state == "register_locked" then
		return {
			fillColor = Color3.fromRGB(136, 108, 210),
			outlineColor = Color3.fromRGB(255, 255, 255),
			fillTransparency = 0.96,
			outlineTransparency = 0.42,
			pulse = 0.02,
		}
	end
	if state == "register_ready" then
		return {
			fillColor = Color3.fromRGB(255, 224, 126),
			outlineColor = Color3.fromRGB(255, 255, 255),
			fillTransparency = 0.8,
			outlineTransparency = 0.04,
			pulse = 0.08,
		}
	end
	if state == "blackout" then
		return {
			fillColor = baseColor:Lerp(Color3.fromRGB(44, 70, 116), 0.6),
			outlineColor = Color3.fromRGB(171, 199, 255),
			fillTransparency = 0.96,
			outlineTransparency = 0.58,
			pulse = 0.02,
		}
	end
	if state == "mimic_lockout" then
		return {
			fillColor = Color3.fromRGB(255, 108, 108),
			outlineColor = Color3.fromRGB(255, 214, 214),
			fillTransparency = 0.88,
			outlineTransparency = 0.12,
			pulse = 0.05,
		}
	end
	if state == "cooldown" then
		return {
			fillColor = baseColor,
			outlineColor = Color3.fromRGB(180, 180, 180),
			fillTransparency = 0.98,
			outlineTransparency = 0.78,
			pulse = 0,
		}
	end
	if state == "completed" or state == "register_closed" then
		return {
			fillColor = baseColor,
			outlineColor = Color3.fromRGB(170, 170, 170),
			fillTransparency = 1,
			outlineTransparency = 0.9,
			pulse = 0,
		}
	end

	return {
		fillColor = baseColor,
		outlineColor = Color3.fromRGB(150, 150, 150),
		fillTransparency = 1,
		outlineTransparency = 0.95,
		pulse = 0,
	}
end

local function updateNodeVisual(nodeData, now)
	local style = getNodeStyle(nodeData.part, nodeData.state)
	local pulseAlpha = if style.pulse > 0 then (math.sin(now * 3.5) + 1) * 0.5 else 0
	local fillTransparency = style.fillTransparency - style.pulse * pulseAlpha
	local outlineTransparency = style.outlineTransparency - (style.pulse * 0.5) * pulseAlpha

	if nodeData.holdFocused then
		fillTransparency = math.max(0.66, fillTransparency - 0.14)
		outlineTransparency = math.max(0.02, outlineTransparency - 0.1)
	end

	if nodeData.flashUntil > now then
		nodeData.highlight.FillColor = nodeData.flashColor
		nodeData.highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		nodeData.highlight.FillTransparency = 0.74
		nodeData.highlight.OutlineTransparency = 0.02
		return
	end

	nodeData.highlight.FillColor = style.fillColor
	nodeData.highlight.OutlineColor = style.outlineColor
	nodeData.highlight.FillTransparency = math.clamp(fillTransparency, 0, 1)
	nodeData.highlight.OutlineTransparency = math.clamp(outlineTransparency, 0, 1)
end

local function markFlash(nodeData, flashColor, duration)
	nodeData.flashColor = flashColor
	nodeData.flashUntil = os.clock() + duration
end

local function ensureTrackedNode(part)
	if trackedNodes[part] ~= nil then
		return
	end

	local highlight = Instance.new("Highlight")
	highlight.Name = "TaskFeedbackHighlight"
	highlight.Adornee = part
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.FillTransparency = 1
	highlight.OutlineTransparency = 1
	highlight.Parent = gui

	local nodeData = {
		part = part,
		highlight = highlight,
		state = tostring(part:GetAttribute("FeedbackState") or "waiting"),
		holdFocused = false,
		flashColor = Color3.fromRGB(255, 255, 255),
		flashUntil = 0,
	}
	trackedNodes[part] = nodeData

	local function refreshState()
		local previousState = nodeData.state
		nodeData.state = tostring(part:GetAttribute("FeedbackState") or "waiting")

		if
			(previousState == "available" or previousState == "register_ready")
			and (
				nodeData.state == "cooldown"
				or nodeData.state == "completed"
				or nodeData.state == "register_closed"
			)
		then
			markFlash(nodeData, Color3.fromRGB(124, 255, 166), 0.6)
		elseif previousState ~= "register_ready" and nodeData.state == "register_ready" then
			markFlash(nodeData, Color3.fromRGB(255, 224, 126), 0.7)
		elseif previousState ~= "mimic_lockout" and nodeData.state == "mimic_lockout" then
			markFlash(nodeData, Color3.fromRGB(255, 118, 118), 0.75)
		end
	end

	part:GetAttributeChangedSignal("FeedbackState"):Connect(refreshState)
	part.Destroying:Connect(function()
		trackedNodes[part] = nil
		highlight:Destroy()
	end)

	refreshState()
end

local function attachTaskFolder(folder)
	if taskFolderConnection ~= nil then
		taskFolderConnection:Disconnect()
		taskFolderConnection = nil
	end

	for _, child in ipairs(folder:GetChildren()) do
		if child:IsA("BasePart") then
			ensureTrackedNode(child)
		end
	end

	taskFolderConnection = folder.ChildAdded:Connect(function(child)
		if child:IsA("BasePart") then
			ensureTrackedNode(child)
		end
	end)
end

local existingTaskFolder = Workspace:FindFirstChild("TaskNodes")
if existingTaskFolder ~= nil then
	attachTaskFolder(existingTaskFolder)
end

Workspace.ChildAdded:Connect(function(child)
	if child.Name == "TaskNodes" and child:IsA("Folder") then
		attachTaskFolder(child)
	end
end)

ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
	if not isTaskPrompt(prompt) then
		return
	end

	local nodeData = trackedNodes[prompt.Parent]
	if nodeData ~= nil then
		nodeData.holdFocused = true
	end
end)

ProximityPromptService.PromptButtonHoldEnded:Connect(function(prompt)
	if not isTaskPrompt(prompt) then
		return
	end

	local nodeData = trackedNodes[prompt.Parent]
	if nodeData ~= nil then
		nodeData.holdFocused = false
	end
end)

ProximityPromptService.PromptTriggered:Connect(function(prompt)
	if not isTaskPrompt(prompt) then
		return
	end

	local nodeData = trackedNodes[prompt.Parent]
	if nodeData ~= nil then
		nodeData.holdFocused = false
	end
end)

alertRaised.OnClientEvent:Connect(function(payload)
	if typeof(payload) ~= "table" then
		return
	end

	if payload.id == "blackout_active" then
		setBlackoutOverlay(true)
	elseif payload.id == "blackout_end" then
		setBlackoutOverlay(false)
	elseif payload.id == "mimic_triggered" then
		flashScreen(Color3.fromRGB(140, 24, 24), 0.72, 0.45)
	elseif payload.id == "round_success" then
		flashScreen(Color3.fromRGB(46, 116, 72), 0.82, 0.55)
	elseif payload.id == "round_failure" then
		flashScreen(Color3.fromRGB(96, 42, 42), 0.8, 0.55)
	elseif payload.id == "register_unlocked" then
		flashScreen(Color3.fromRGB(255, 208, 118), 0.88, 0.35)
	end
end)

RunService.RenderStepped:Connect(function()
	local now = os.clock()
	for part, nodeData in pairs(trackedNodes) do
		if part.Parent == nil then
			trackedNodes[part] = nil
			nodeData.highlight:Destroy()
		else
			updateNodeVisual(nodeData, now)
		end
	end
end)
