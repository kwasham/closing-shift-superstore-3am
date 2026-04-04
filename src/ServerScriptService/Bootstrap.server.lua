local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local roundFolder = ServerScriptService:WaitForChild("Round")
local dataFolder = ServerScriptService:WaitForChild("Data")

local ProfileStore = require(dataFolder:WaitForChild("ProfileStore"))
local ShopService = require(roundFolder:WaitForChild("ShopService"))
local shiftService = require(roundFolder:WaitForChild("ShiftService"))

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local shopAction = remotes:WaitForChild("ShopAction")
local roundEndShareAction = remotes:WaitForChild("RoundEndShareAction")

local shopService = ShopService.new(ProfileStore)
local shiftController = shiftService.start()

local function snapCharacterToFallbackSpawn(character: Model)
	task.defer(function()
		local rootPart = character:FindFirstChild("HumanoidRootPart")
			or character:WaitForChild("HumanoidRootPart", 5)
		local spawn = Workspace:FindFirstChild("ShiftSpawn")
		local floor = Workspace:FindFirstChild("ShiftArenaFloor")
		if rootPart == nil or spawn == nil or floor == nil then
			return
		end

		local spawnPart = if spawn:IsA("SpawnLocation") then spawn else nil
		local floorPart = if floor:IsA("BasePart") then floor else nil
		if spawnPart == nil or floorPart == nil then
			return
		end

		local spawnPosition = spawnPart.Position + Vector3.new(0, 4, 0)
		local tooFarFromArena = (rootPart.Position - spawnPosition).Magnitude > 32
		local belowArenaFloor = rootPart.Position.Y < (floorPart.Position.Y - 5)
		if tooFarFromArena or belowArenaFloor then
			character:PivotTo(CFrame.new(spawnPosition))
		end
	end)
end

local function hookPlayer(player: Player)
	player.CharacterAdded:Connect(snapCharacterToFallbackSpawn)
	if player.Character ~= nil then
		snapCharacterToFallbackSpawn(player.Character)
	end
end

shopAction.OnServerInvoke = function(player, request)
	return shopService:handleRequest(player, request, shiftController:getCurrentState())
end

roundEndShareAction.OnServerEvent:Connect(function(player, request)
	shiftController:handleShareAction(player, request)
end)

for _, player in ipairs(Players:GetPlayers()) do
	hookPlayer(player)
end
Players.PlayerAdded:Connect(hookPlayer)
