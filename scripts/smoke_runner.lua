local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")
local Workspace = game:GetService("Workspace")

local function assertChild(parent: Instance, name: string)
	local child = parent:FindFirstChild(name)
	assert(child ~= nil, string.format("Missing child %s under %s", name, parent:GetFullName()))
	return child
end

local shared = assertChild(ReplicatedStorage, "Shared")
assertChild(shared, "Constants")
assertChild(shared, "Types")
assertChild(shared, "StoreSignage")
assertChild(shared, "VisualTheme")
assertChild(shared, "LightingPresets")

local remotes = assertChild(ReplicatedStorage, "Remotes")
assertChild(remotes, "RoundStateChanged")
assertChild(remotes, "AlertRaised")

local roundFolder = assertChild(ServerScriptService, "Round")
assertChild(roundFolder, "Config")
assertChild(roundFolder, "ShiftService")

local dataFolder = assertChild(ServerScriptService, "Data")
assertChild(dataFolder, "ProfileStore")

local starterScripts = assertChild(StarterPlayer, "StarterPlayerScripts")
assertChild(starterScripts, "HUD")
assertChild(starterScripts, "ClientEffects")
assertChild(starterScripts, "LightingController")

assertChild(Workspace, "FallbackArena")

print("SMOKE_OK: core folders and scripts are present")
print("SMOKE_OK: sprint 6 visual runtime sources are present")
