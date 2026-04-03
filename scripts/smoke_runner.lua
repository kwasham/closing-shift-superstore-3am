local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local Workspace = game:GetService("Workspace")

local function assertChild(parent: Instance, name: string)
	local child = parent:FindFirstChild(name)
	assert(child ~= nil, string.format("Missing child %s under %s", name, parent:GetFullName()))
	return child
end

local shared = assertChild(ReplicatedStorage, "Shared")
local constantsModule = assertChild(shared, "Constants")
assertChild(shared, "Types")
assertChild(shared, "UIStrings")

local constants = require(constantsModule)
assert(constants.Round.DurationSeconds == 540, "Round duration must be 540 seconds")
assert(constants.Round.IntermissionSeconds == 15, "Intermission must be 15 seconds")
assert(
	constants.Tasks[constants.TaskId.CloseRegister].reward == 24,
	"Close Register reward mismatch"
)

local remotes = assertChild(ReplicatedStorage, "Remotes")
assertChild(remotes, "RoundStateChanged")
assertChild(remotes, "TaskProgressChanged")
assertChild(remotes, "AlertRaised")

local roundFolder = assertChild(ServerScriptService, "Round")
local configModule = assertChild(roundFolder, "Config")
assertChild(roundFolder, "TaskRegistry")
assertChild(roundFolder, "TaskService")
assertChild(roundFolder, "EventService")
assertChild(roundFolder, "PayoutService")
local shiftServiceModule = assertChild(roundFolder, "ShiftService")

local config = require(configModule)
local shiftService = require(shiftServiceModule)

-- run-in-roblox executes this harness directly and does not reliably auto-run
-- the ServerScriptService bootstrap script before smoke assertions fire.
-- Start the round bootstrap explicitly so runtime-created instances exist.
shiftService.start()
local soloQuotas = config.getQuotaTemplate(1)
local fullQuotas = config.getQuotaTemplate(6)
assert(config.getTotalRequired(soloQuotas) == 8, "Solo quota total mismatch")
assert(config.getTotalRequired(fullQuotas) == 12, "Full party quota total mismatch")
assert(soloQuotas[constants.TaskId.CloseRegister] == 1, "Register quota must stay final-only")
assert(fullQuotas[constants.TaskId.RestockShelf] == 3, "6-player restock quota mismatch")

local dataFolder = assertChild(ServerScriptService, "Data")
assertChild(dataFolder, "ProfileStore")
assertChild(ServerScriptService, "Bootstrap")

local starterGui = assertChild(StarterGui, "HUD")
assert(starterGui:IsA("LocalScript"), "HUD must stay a LocalScript")

local starterScripts = assertChild(StarterPlayer, "StarterPlayerScripts")
assertChild(starterScripts, "Audio")
assertChild(starterScripts, "ClientEffects")

local taskNodes = Workspace:WaitForChild("TaskNodes", 5)
assert(taskNodes ~= nil, "TaskNodes folder was not created by the round bootstrap")
assert(taskNodes:FindFirstChild("close_register_node") ~= nil, "Missing Close Register node")

print("SMOKE_OK: core folders and scripts are present")
print("SMOKE_OK: sprint 1 round loop structure is present")
