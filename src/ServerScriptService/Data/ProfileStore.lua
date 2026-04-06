local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local ProfileStore = {}

local profilesByUserId = {}

local function getLevelFromXP(xp)
	local level = 1
	for nextLevel = 2, Constants.Progression.DisplayLevelCap do
		local threshold = Constants.Progression.LevelThresholds[nextLevel]
		if threshold ~= nil and xp >= threshold then
			level = nextLevel
		end
	end
	return level
end

local function cloneDictionary(source)
	return table.clone(source or {})
end

local function createDefaultProfile(userId)
	local ownedCosmetics = {}
	for itemId, item in pairs(Constants.Cosmetics.Catalog) do
		if item.defaultOwned == true then
			ownedCosmetics[itemId] = true
		end
	end

	return {
		UserId = userId,
		Cash = 0,
		XP = 0,
		Level = 1,
		OwnedCosmetics = ownedCosmetics,
		EquippedCosmetics = cloneDictionary(Constants.Cosmetics.DefaultEquipped),
		AwardedBadges = {},
		DailyBonusClaimDays = {},
		LastDailyBonusResetKeyUtc = nil,
		LastRoundResult = nil,
		ShiftsPlayed = 0,
		ShiftsCleared = 0,
	}
end

local function refreshDerivedProfileFields(profile)
	profile.Level = getLevelFromXP(profile.XP)
end

local function getProfileByUserId(userId)
	if profilesByUserId[userId] == nil then
		profilesByUserId[userId] = createDefaultProfile(userId)
	end
	return profilesByUserId[userId]
end

local function getRemotesFolder()
	local ok, remotes = pcall(function()
		return ReplicatedStorage:FindFirstChild("Remotes")
	end)
	if ok then
		return remotes
	end
	return nil
end

local function replicateProfile(player)
	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		return
	end

	local remotes = getRemotesFolder()
	if remotes == nil then
		return
	end
	local profileChanged = remotes:FindFirstChild("ProfileChanged")
	if profileChanged == nil or not profileChanged:IsA("RemoteEvent") then
		return
	end

	profileChanged:FireClient(player, {
		profile = ProfileStore.getPublicProfile(player),
		lastRoundResult = ProfileStore.getLastRoundResult(player),
	})
end

function ProfileStore.getLeaderstats(player)
	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		return nil
	end

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

function ProfileStore.loadProfile(player)
	local profile = getProfileByUserId(player.UserId)
	refreshDerivedProfileFields(profile)

	local leaderstats = ProfileStore.getLeaderstats(player)
	if leaderstats ~= nil then
		local cash = leaderstats:FindFirstChild("Cash")
		if cash ~= nil and cash:IsA("IntValue") then
			cash.Value = profile.Cash
		end
	end

	replicateProfile(player)
	return profile
end

function ProfileStore.getProfile(player)
	return getProfileByUserId(player.UserId)
end

function ProfileStore.getLastRoundResult(player)
	local profile = getProfileByUserId(player.UserId)
	if profile.LastRoundResult == nil then
		return nil
	end
	return table.clone(profile.LastRoundResult)
end

function ProfileStore.getPublicProfile(player)
	local profile = getProfileByUserId(player.UserId)
	refreshDerivedProfileFields(profile)
	return {
		cash = profile.Cash,
		xp = profile.XP,
		level = profile.Level,
		ownedCosmetics = cloneDictionary(profile.OwnedCosmetics),
		equippedCosmetics = cloneDictionary(profile.EquippedCosmetics),
		awardedBadges = cloneDictionary(profile.AwardedBadges),
		lastDailyBonusResetKeyUtc = profile.LastDailyBonusResetKeyUtc,
		lastRoundResult = if profile.LastRoundResult ~= nil
			then table.clone(profile.LastRoundResult)
			else nil,
		shiftsPlayed = profile.ShiftsPlayed,
		shiftsCleared = profile.ShiftsCleared,
	}
end

function ProfileStore.mutateProfile(player, mutator, options)
	local profile = getProfileByUserId(player.UserId)
	mutator(profile)
	refreshDerivedProfileFields(profile)

	local leaderstats = ProfileStore.getLeaderstats(player)
	if leaderstats ~= nil then
		local cash = leaderstats:FindFirstChild("Cash")
		if cash ~= nil and cash:IsA("IntValue") then
			cash.Value = profile.Cash
		end
	end

	if options == nil or options.suppressReplicate ~= true then
		replicateProfile(player)
	end

	return profile
end

function ProfileStore.addCash(player, amount)
	ProfileStore.mutateProfile(player, function(profile)
		profile.Cash += amount
	end)
end

function ProfileStore.setLastRoundResult(player, resultPayload)
	ProfileStore.mutateProfile(player, function(profile)
		profile.LastRoundResult = table.clone(resultPayload)
	end)
end

Players.PlayerAdded:Connect(function(player)
	ProfileStore.loadProfile(player)
end)

return ProfileStore
