local Workspace = game:GetService("Workspace")

local FLOOR_NAME = "ShiftArenaFloor"
local SPAWN_NAME = "ShiftSpawn"
local FLOOR_SIZE = Vector3.new(88, 1, 88)
local FLOOR_POSITION = Vector3.new(0, 180, 0)
local SPAWN_POSITION = Vector3.new(0, 184, -26)

local function ensureFloor()
	local floor = Workspace:FindFirstChild(FLOOR_NAME)
	if floor ~= nil and floor:IsA("BasePart") then
		return floor
	end

	floor = Instance.new("Part")
	floor.Name = FLOOR_NAME
	floor.Anchored = true
	floor.Size = FLOOR_SIZE
	floor.Position = FLOOR_POSITION
	floor.Material = Enum.Material.Concrete
	floor.Color = Color3.fromRGB(64, 64, 72)
	floor.TopSurface = Enum.SurfaceType.Smooth
	floor.BottomSurface = Enum.SurfaceType.Smooth
	floor.Parent = Workspace
	return floor
end

local function ensureSpawn()
	local spawn = Workspace:FindFirstChild(SPAWN_NAME)
	if spawn ~= nil and spawn:IsA("SpawnLocation") then
		return spawn
	end

	spawn = Instance.new("SpawnLocation")
	spawn.Name = SPAWN_NAME
	spawn.Anchored = true
	spawn.Neutral = true
	spawn.Size = Vector3.new(6, 1, 6)
	spawn.Position = SPAWN_POSITION
	spawn.Material = Enum.Material.Metal
	spawn.Color = Color3.fromRGB(109, 158, 235)
	spawn.Parent = Workspace
	return spawn
end

ensureFloor()
ensureSpawn()
