local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
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

local function applyResolvedPreset(force)
	local presetName = resolvePreset(os.clock())
	if not force and presetName == state.currentPreset then
		return
	end

	state.currentPreset = LightingPresets.applyPreset(Lighting, presetName)
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

RunService.Heartbeat:Connect(function()
	if state.mimicExpiresAt > 0 and os.clock() >= state.mimicExpiresAt then
		state.mimicExpiresAt = 0
		applyResolvedPreset(false)
	end
end)

applyResolvedPreset(true)
