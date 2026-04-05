local Players = game:GetService("Players")

local ProfileStore = {}

function ProfileStore.getLeaderstats(player: Player)
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

	return leaderstats
end

Players.PlayerAdded:Connect(function(player)
	ProfileStore.getLeaderstats(player)
end)

return ProfileStore
