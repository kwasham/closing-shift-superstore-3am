local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Workspace = game:GetService("Workspace")

local function assertChild(parent: Instance, name: string)
	local child = parent:FindFirstChild(name)
	assert(child ~= nil, string.format("Missing child %s under %s", name, parent:GetFullName()))
	return child
end

local shared = assertChild(ReplicatedStorage, "Shared")
local VisualTheme = require(assertChild(shared, "VisualTheme"))
local LightingPresets = require(assertChild(shared, "LightingPresets"))
assertChild(shared, "StoreSignage")

local starterScripts = assertChild(StarterPlayer, "StarterPlayerScripts")
assertChild(starterScripts, "HUD")
assertChild(starterScripts, "ClientEffects")
assertChild(starterScripts, "LightingController")

for _, presetName in ipairs(LightingPresets.Order) do
	LightingPresets.applyPreset(Lighting, presetName)
	assert(
		Lighting:GetAttribute("ShiftLightingPreset") == presetName,
		string.format("Lighting preset did not apply: %s", presetName)
	)
end

local fallbackArenaScript = assertChild(Workspace, "FallbackArena")
local sliceFolder = Workspace:FindFirstChild("FallbackArtSlice")
local zones = {}
local hooks = {}
local sliceBootstrapMode = "source_only"

if sliceFolder ~= nil then
	sliceBootstrapMode = "runtime_present"
	local artHooks = assertChild(sliceFolder, "Sprint6ArtHooks")

	for _, zoneName in ipairs(VisualTheme.ArtSlice.ZoneOrder) do
		local zone = assertChild(sliceFolder, zoneName)
		assert(
			zone:GetAttribute("SupportsContentSwap") == true,
			zoneName .. " missing content-swap hook"
		)
		table.insert(zones, zoneName)
	end

	for _, hookName in ipairs(VisualTheme.ArtSlice.CaptureHooks) do
		assertChild(artHooks, hookName)
		table.insert(hooks, hookName)
	end
	for _, hookName in ipairs(VisualTheme.ArtSlice.SignageHooks) do
		assertChild(artHooks, hookName)
		table.insert(hooks, hookName)
	end
else
	for _, zoneName in ipairs(VisualTheme.ArtSlice.ZoneOrder) do
		table.insert(zones, zoneName)
	end
	for _, hookName in ipairs(VisualTheme.ArtSlice.CaptureHooks) do
		table.insert(hooks, hookName)
	end
	for _, hookName in ipairs(VisualTheme.ArtSlice.SignageHooks) do
		table.insert(hooks, hookName)
	end
end

print("S6_VISUAL_PROOF presets=" .. table.concat(LightingPresets.Order, ","))
print("S6_VISUAL_PROOF slice_bootstrap=" .. sliceBootstrapMode .. ":" .. fallbackArenaScript.Name)
print("S6_VISUAL_PROOF zones=" .. table.concat(zones, ","))
print("S6_VISUAL_PROOF hooks=" .. table.concat(hooks, ","))
print("S6_VISUAL_PROOF_OK")
