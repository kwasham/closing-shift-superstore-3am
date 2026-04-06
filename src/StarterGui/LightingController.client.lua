local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local StoreRollout = require(Shared:WaitForChild("StoreRollout"))
local VisualTheme = require(Shared:WaitForChild("VisualTheme"))
local LightingPresets = require(Shared:WaitForChild("LightingPresets"))

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local roundStateChanged = remotes:WaitForChild("RoundStateChanged")
local alertRaised = remotes:WaitForChild("AlertRaised")

local RoundState = {
	Waiting = "Waiting",
	Intermission = "Intermission",
	Playing = "Playing",
	Ended = "Ended",
}

local state = {
	blackoutActive = false,
	roundEndPreset = nil,
	mimicExpiresAt = 0,
	currentPreset = nil,
	currentWorldState = nil,
	trackedGroups = {},
}

local function normalizeAlertId(payload)
	if typeof(payload) == "table" then
		return payload.id
	end
	if typeof(payload) == "string" then
		return payload
	end
	return nil
end

local function resolvePreset(now)
	if state.roundEndPreset ~= nil then
		return state.roundEndPreset
	end
	if state.blackoutActive then
		return VisualTheme.LightingStates.Blackout
	end
	if state.mimicExpiresAt > now then
		return VisualTheme.LightingStates.Mimic
	end
	return VisualTheme.LightingStates.Normal
end

local function getOrCreateTrackedGroup(groupName)
	local trackedGroup = state.trackedGroups[groupName]
	if trackedGroup == nil then
		trackedGroup = {}
		state.trackedGroups[groupName] = trackedGroup
	end
	return trackedGroup
end

local function registerTrackedPart(groupName, part)
	if not part:IsA("BasePart") then
		return
	end

	local trackedGroup = getOrCreateTrackedGroup(groupName)
	if trackedGroup[part] ~= nil then
		return
	end

	trackedGroup[part] = {
		baseColor = part.Color,
		baseTransparency = part.Transparency,
		baseMaterial = part.Material,
	}

	part.Destroying:Connect(function()
		trackedGroup[part] = nil
	end)
end

local function tryCollectRuntimeGroups()
	local root = Workspace:FindFirstChild(StoreRollout.RootFolderName)
	if root == nil then
		return false
	end

	local runtimeGroups = root:FindFirstChild(StoreRollout.RuntimeGroupsFolderName)
	if runtimeGroups == nil then
		return false
	end

	for _, groupName in ipairs(StoreRollout.RuntimeGroups) do
		local groupFolder = runtimeGroups:FindFirstChild(groupName)
		if groupFolder ~= nil then
			for _, child in ipairs(groupFolder:GetChildren()) do
				if
					child:IsA("ObjectValue")
					and child.Value ~= nil
					and child.Value:IsA("BasePart")
				then
					registerTrackedPart(groupName, child.Value)
				end
			end
			groupFolder.ChildAdded:Connect(function(child)
				if
					child:IsA("ObjectValue")
					and child.Value ~= nil
					and child.Value:IsA("BasePart")
				then
					registerTrackedPart(groupName, child.Value)
				end
			end)
		end
	end

	return true
end

local function applyWorldState(stateName)
	if state.currentWorldState == stateName and next(state.trackedGroups) ~= nil then
		return
	end

	tryCollectRuntimeGroups()
	state.currentWorldState = stateName

	for groupName, trackedGroup in pairs(state.trackedGroups) do
		local style = VisualTheme.getWorldStateStyle(stateName, groupName)
		for part, base in pairs(trackedGroup) do
			if part.Parent == nil then
				trackedGroup[part] = nil
			else
				if style.mode == "base" or style.color == nil then
					part.Color = base.baseColor
				else
					part.Color = style.color
				end
				part.Transparency = if style.transparency ~= nil
					then style.transparency
					else base.baseTransparency
				part.Material = if style.material ~= nil then style.material else base.baseMaterial
			end
		end
	end
end

local function applyResolvedPreset(force)
	local presetName = resolvePreset(os.clock())
	if force or presetName ~= state.currentPreset then
		state.currentPreset = LightingPresets.applyPreset(Lighting, presetName)
	end

	applyWorldState(presetName)
end

roundStateChanged.OnClientEvent:Connect(function(payload)
	if typeof(payload) ~= "table" then
		return
	end

	if payload.progress ~= nil and payload.progress.blackoutActive ~= nil then
		state.blackoutActive = payload.progress.blackoutActive == true
	end

	if payload.state == RoundState.Ended then
		if payload.roundResult == "success" then
			state.roundEndPreset = VisualTheme.LightingStates.RoundSuccess
		elseif payload.roundResult == "failure" then
			state.roundEndPreset = VisualTheme.LightingStates.RoundFailure
		end
	elseif payload.state == RoundState.Waiting or payload.state == RoundState.Intermission then
		state.blackoutActive = false
		state.roundEndPreset = nil
		state.mimicExpiresAt = 0
	elseif payload.state == RoundState.Playing then
		state.roundEndPreset = nil
	end

	applyResolvedPreset(false)
end)

alertRaised.OnClientEvent:Connect(function(payload)
	local alertId = normalizeAlertId(payload)
	if alertId == nil then
		return
	end

	if alertId == "blackout_active" then
		state.blackoutActive = true
	elseif alertId == "blackout_end" then
		state.blackoutActive = false
	elseif alertId == "mimic_triggered" then
		state.mimicExpiresAt = os.clock() + VisualTheme.Presentation.MimicLightingDuration
	elseif alertId == "round_success" then
		state.roundEndPreset = VisualTheme.LightingStates.RoundSuccess
	elseif alertId == "round_failure" then
		state.roundEndPreset = VisualTheme.LightingStates.RoundFailure
	end

	applyResolvedPreset(false)
end)

Workspace.ChildAdded:Connect(function(child)
	if child.Name == StoreRollout.RootFolderName then
		applyResolvedPreset(true)
	end
end)

RunService.Heartbeat:Connect(function()
	if state.mimicExpiresAt > 0 and os.clock() >= state.mimicExpiresAt then
		state.mimicExpiresAt = 0
		applyResolvedPreset(false)
	end
	if next(state.trackedGroups) == nil then
		tryCollectRuntimeGroups()
	end
end)

applyResolvedPreset(true)
