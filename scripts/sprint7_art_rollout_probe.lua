local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local function assertChild(parent: Instance, name: string)
	local child = parent:FindFirstChild(name)
	assert(child ~= nil, string.format("Missing child %s under %s", name, parent:GetFullName()))
	return child
end

local shared = assertChild(ReplicatedStorage, "Shared")
local StoreRollout = require(assertChild(shared, "StoreRollout"))
local StoreSignage = require(assertChild(shared, "StoreSignage"))
local VisualTheme = require(assertChild(shared, "VisualTheme"))
local LightingPresets = require(assertChild(shared, "LightingPresets"))

assertChild(shared, "StoreSignage")
assertChild(shared, "StoreRollout")
assertChild(Workspace, "FallbackArena")

for _, presetName in ipairs(LightingPresets.Order) do
	LightingPresets.applyPreset(Lighting, presetName)
	assert(
		Lighting:GetAttribute("ShiftLightingPreset") == presetName,
		string.format("Lighting preset did not apply: %s", presetName)
	)
end

local root = Workspace:FindFirstChild(StoreRollout.RootFolderName)
local runtimeMode = "source_only"
local zoneNames = {}
local groupNames = {}
local hookNames = {}

if root ~= nil then
	runtimeMode = "runtime_present"
	local hooks = assertChild(root, StoreRollout.HooksFolderName)
	local runtimeGroups = assertChild(root, StoreRollout.RuntimeGroupsFolderName)

	for _, zoneName in ipairs(StoreRollout.TierAZoneOrder) do
		local zone = assertChild(root, zoneName)
		assert(
			zone:GetAttribute("SupportsContentSwap") == true,
			zoneName .. " missing content-swap hook"
		)
		table.insert(zoneNames, zoneName)
	end
	for _, zoneName in ipairs(StoreRollout.TierBZoneOrder) do
		assertChild(root, zoneName)
		table.insert(zoneNames, zoneName)
	end
	for _, groupName in ipairs(StoreRollout.RuntimeGroups) do
		local groupFolder = assertChild(runtimeGroups, groupName)
		assert(#groupFolder:GetChildren() > 0, groupName .. " runtime group is empty")
		table.insert(groupNames, groupName)
	end
	for _, hookName in ipairs(StoreRollout.CaptureHooks) do
		assertChild(hooks, hookName)
		table.insert(hookNames, hookName)
	end
	for _, hookName in ipairs(StoreRollout.SignageHooks) do
		assertChild(hooks, hookName)
		table.insert(hookNames, hookName)
	end
else
	for _, zoneName in ipairs(StoreRollout.TierAZoneOrder) do
		table.insert(zoneNames, zoneName)
	end
	for _, zoneName in ipairs(StoreRollout.TierBZoneOrder) do
		table.insert(zoneNames, zoneName)
	end
	for _, groupName in ipairs(StoreRollout.RuntimeGroups) do
		table.insert(groupNames, groupName)
	end
	for _, hookName in ipairs(StoreRollout.CaptureHooks) do
		table.insert(hookNames, hookName)
	end
	for _, hookName in ipairs(StoreRollout.SignageHooks) do
		table.insert(hookNames, hookName)
	end
end

print("S7_ART_PROOF rollout_mode=" .. runtimeMode)
print("S7_ART_PROOF zones=" .. table.concat(zoneNames, ","))
print("S7_ART_PROOF tier_a=" .. table.concat(StoreRollout.TierAZoneOrder, ","))
print("S7_ART_PROOF tier_b=" .. table.concat(StoreRollout.TierBZoneOrder, ","))
print("S7_ART_PROOF groups=" .. table.concat(groupNames, ","))
print("S7_ART_PROOF hooks=" .. table.concat(hookNames, ","))
print(
	string.format(
		"S7_ART_PROOF signage aisles=%d checkout=%d sale_family=%s",
		#StoreSignage.Aisles,
		#StoreSignage.Checkout,
		StoreSignage.SaleCard.familyId
	)
)
print(
	"S7_ART_PROOF states="
		.. table.concat(LightingPresets.Order, ",")
		.. " world_groups="
		.. table.concat(VisualTheme.StoreRollout.RuntimeGroups, ",")
)
print("S7_ART_PROOF_OK")
