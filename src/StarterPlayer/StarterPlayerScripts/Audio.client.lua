local Debris = game:GetService("Debris")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local roundStateChanged = remotes:WaitForChild("RoundStateChanged")
local taskProgressChanged = remotes:WaitForChild("TaskProgressChanged")
local alertRaised = remotes:WaitForChild("AlertRaised")

local fallbackCueIds = {
	register_unlocked = { "task_complete" },
	blackout_end = { "register_unlocked", "task_complete" },
	round_success = { "register_unlocked", "task_complete" },
}

local lastCompleted = 0
local completionWindowEndsAt = 0

local function isTaskPrompt(prompt)
	local taskNodes = Workspace:FindFirstChild("TaskNodes")
	return taskNodes ~= nil
		and prompt ~= nil
		and prompt.Parent ~= nil
		and prompt.Parent:IsDescendantOf(taskNodes)
end

local function findCueInstance(cueId)
	local feedbackFolder = SoundService:FindFirstChild("Feedback")
	if feedbackFolder ~= nil then
		local cue = feedbackFolder:FindFirstChild(cueId)
		if cue ~= nil and cue:IsA("Sound") then
			return cue
		end
	end

	local directCue = SoundService:FindFirstChild(cueId)
	if directCue ~= nil and directCue:IsA("Sound") then
		return directCue
	end

	for _, fallbackCueId in ipairs(fallbackCueIds[cueId] or {}) do
		local fallbackCue = findCueInstance(fallbackCueId)
		if fallbackCue ~= nil then
			return fallbackCue
		end
	end

	return nil
end

local function playCue(cueId)
	local cueTemplate = findCueInstance(cueId)
	if cueTemplate == nil then
		return false
	end

	local cue = cueTemplate:Clone()
	cue.Name = string.format("%s_runtime", cueId)
	cue.Parent = SoundService
	cue:Play()
	Debris:AddItem(cue, math.max(cue.TimeLength + 1, 3))
	return true
end

roundStateChanged.OnClientEvent:Connect(function(payload)
	if typeof(payload) ~= "table" then
		return
	end

	if payload.progress ~= nil then
		lastCompleted = payload.progress.completed or 0
	end
end)

taskProgressChanged.OnClientEvent:Connect(function(progress)
	if typeof(progress) ~= "table" then
		return
	end

	local completed = progress.completed or 0
	if completed > lastCompleted and os.clock() <= completionWindowEndsAt then
		playCue("task_complete")
		completionWindowEndsAt = 0
	end

	lastCompleted = completed
end)

alertRaised.OnClientEvent:Connect(function(payload)
	if typeof(payload) ~= "table" or payload.cueId == nil then
		return
	end

	playCue(payload.cueId)
end)

ProximityPromptService.PromptTriggered:Connect(function(prompt)
	if prompt == nil or not prompt.Enabled or not isTaskPrompt(prompt) then
		return
	end

	completionWindowEndsAt = os.clock() + 1.5
end)
