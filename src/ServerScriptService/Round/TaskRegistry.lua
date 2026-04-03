local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local TaskRegistry = {}

local ARENA_ORIGIN = Vector3.new(0, 180, 0)

TaskRegistry.Arena = {
	floorName = "ShiftArenaFloor",
	floorSize = Vector3.new(88, 1, 88),
	floorPosition = ARENA_ORIGIN,
	spawnName = "ShiftSpawn",
	spawnPosition = ARENA_ORIGIN + Vector3.new(0, 4, -26),
}

TaskRegistry.Nodes = {
	{
		nodeId = "restock_shelf_node",
		taskId = Constants.TaskId.RestockShelf,
		position = ARENA_ORIGIN + Vector3.new(-24, 3, -8),
		size = Vector3.new(6, 6, 3),
		color = Color3.fromRGB(239, 184, 56),
	},
	{
		nodeId = "clean_spill_node",
		taskId = Constants.TaskId.CleanSpill,
		position = ARENA_ORIGIN + Vector3.new(-10, 1.5, 16),
		size = Vector3.new(8, 1, 8),
		color = Color3.fromRGB(88, 172, 255),
	},
	{
		nodeId = "take_out_trash_node",
		taskId = Constants.TaskId.TakeOutTrash,
		position = ARENA_ORIGIN + Vector3.new(18, 3, 16),
		size = Vector3.new(4, 5, 4),
		color = Color3.fromRGB(84, 104, 94),
	},
	{
		nodeId = "return_cart_node",
		taskId = Constants.TaskId.ReturnCart,
		position = ARENA_ORIGIN + Vector3.new(26, 3, -8),
		size = Vector3.new(5, 5, 4),
		color = Color3.fromRGB(176, 176, 176),
	},
	{
		nodeId = "check_freezer_node",
		taskId = Constants.TaskId.CheckFreezer,
		position = ARENA_ORIGIN + Vector3.new(0, 3, 22),
		size = Vector3.new(6, 7, 4),
		color = Color3.fromRGB(129, 212, 250),
	},
	{
		nodeId = "close_register_node",
		taskId = Constants.TaskId.CloseRegister,
		position = ARENA_ORIGIN + Vector3.new(0, 3, -18),
		size = Vector3.new(7, 4, 4),
		color = Color3.fromRGB(113, 77, 194),
	},
}

TaskRegistry.SecurityAlarm = {
	nodeId = Constants.Events.SecurityAlarm.NodeId,
	position = ARENA_ORIGIN + Vector3.new(0, 3, -2),
	size = Vector3.new(5, 5, 2),
	color = Color3.fromRGB(161, 64, 64),
}

return TaskRegistry
