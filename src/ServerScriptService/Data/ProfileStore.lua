local Players = game:GetService("Players")

local ProfileStore = {}

local function getOrCreateCashValue(player: Player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats == nil then
		leaderstats = Instance.new("Folder")
		leaderstats.Name = "leaderstats"
		leaderstats.Parent = player
	end

	local cash = leaderstats:FindFirstChild("Cash")
	if cash == nil then
		cash = Instance.new("IntValue")
		cash.Name = "Cash"
		cash.Value = 0
		cash.Parent = leaderstats
	end

	return cash
end

function ProfileStore.getLeaderstats(player: Player)
	getOrCreateCashValue(player)
	return player:FindFirstChild("leaderstats")
end

function ProfileStore.getCash(player: Player)
	return getOrCreateCashValue(player).Value
end

function ProfileStore.addCash(player: Player, amount: number)
	local cash = getOrCreateCashValue(player)
	cash.Value += math.max(0, math.floor(amount))
	return cash.Value
end

Players.PlayerAdded:Connect(function(player)
	ProfileStore.getLeaderstats(player)
end)

return ProfileStore
