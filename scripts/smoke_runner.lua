local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")

local function assertChild(parent: Instance, name: string)
	local child = parent:FindFirstChild(name)
	assert(child ~= nil, string.format("Missing child %s under %s", name, parent:GetFullName()))
	return child
end

local shared = assertChild(ReplicatedStorage, "Shared")
assertChild(shared, "Constants")
assertChild(shared, "Types")
assertChild(shared, "UIStrings")

local remotes = assertChild(ReplicatedStorage, "Remotes")
assertChild(remotes, "RoundStateChanged")
assertChild(remotes, "AlertRaised")
assertChild(remotes, "TaskProgressChanged")
assertChild(remotes, "ProfileChanged")
assertChild(remotes, "ShopAction")

local analyticsFolder = assertChild(ServerScriptService, "Analytics")
assertChild(analyticsFolder, "AnalyticsService")

local roundFolder = assertChild(ServerScriptService, "Round")
assertChild(roundFolder, "Config")
assertChild(roundFolder, "ShiftService")
assertChild(roundFolder, "ShopService")
assertChild(roundFolder, "TaskService")
assertChild(roundFolder, "EventService")

local dataFolder = assertChild(ServerScriptService, "Data")
assertChild(dataFolder, "ProfileStore")

assertChild(StarterGui, "HUD")
assertChild(StarterGui, "Sprint3UI")

local starterScripts = assertChild(StarterPlayer, "StarterPlayerScripts")
assertChild(starterScripts, "HUD")

print("SMOKE_OK: core folders and scripts are present")
