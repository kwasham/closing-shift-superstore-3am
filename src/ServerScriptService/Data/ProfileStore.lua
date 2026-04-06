local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local ProfileStore = {}

local STORE_NAME = "ClosingShiftProfileStore_V2"
local DATASTORE = DataStoreService:GetDataStore(STORE_NAME)

local profilesByUserId = {}
local loadedUserIds = {}
local dirtyUserIds = {}

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

local function deepClone(value)
	if type(value) ~= "table" then
		return value
	end

	local copy = {}
	for key, innerValue in pairs(value) do
		copy[key] = deepClone(innerValue)
	end
	return copy
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

local function mergeLoadedProfile(userId, loadedProfile)
	local profile = createDefaultProfile(userId)
	if type(loadedProfile) ~= "table" then
		refreshDerivedProfileFields(profile)
		return profile
	end

	profile.Cash = tonumber(loadedProfile.Cash) or profile.Cash
	profile.XP = tonumber(loadedProfile.XP) or profile.XP
	profile.OwnedCosmetics = cloneDictionary(loadedProfile.OwnedCosmetics or profile.OwnedCosmetics)
	profile.EquippedCosmetics =
		cloneDictionary(loadedProfile.EquippedCosmetics or profile.EquippedCosmetics)
	profile.AwardedBadges = cloneDictionary(loadedProfile.AwardedBadges)
	profile.DailyBonusClaimDays = cloneDictionary(loadedProfile.DailyBonusClaimDays)
	profile.LastDailyBonusResetKeyUtc = loadedProfile.LastDailyBonusResetKeyUtc
	profile.LastRoundResult = if loadedProfile.LastRoundResult ~= nil
		then deepClone(loadedProfile.LastRoundResult)
		else nil
	profile.ShiftsPlayed = tonumber(loadedProfile.ShiftsPlayed) or 0
	profile.ShiftsCleared = tonumber(loadedProfile.ShiftsCleared) or 0

	for itemId, item in pairs(Constants.Cosmetics.Catalog) do
		if item.defaultOwned == true then
			profile.OwnedCosmetics[itemId] = true
		end
	end

	for slotId, defaultItemId in pairs(Constants.Cosmetics.DefaultEquipped) do
		if profile.EquippedCosmetics[slotId] == nil then
			profile.EquippedCosmetics[slotId] = defaultItemId
		end
	end

	refreshDerivedProfileFields(profile)
	return profile
end

local function getProfileKey(userId)
	return string.format("player_%d", userId)
end

local function serializeProfile(profile)
	return {
		Cash = profile.Cash,
		XP = profile.XP,
		OwnedCosmetics = deepClone(profile.OwnedCosmetics),
		EquippedCosmetics = deepClone(profile.EquippedCosmetics),
		AwardedBadges = deepClone(profile.AwardedBadges),
		DailyBonusClaimDays = deepClone(profile.DailyBonusClaimDays),
		LastDailyBonusResetKeyUtc = profile.LastDailyBonusResetKeyUtc,
		LastRoundResult = deepClone(profile.LastRoundResult),
		ShiftsPlayed = profile.ShiftsPlayed,
		ShiftsCleared = profile.ShiftsCleared,
	}
end

local function loadPersistedProfile(userId)
	local success, result = pcall(function()
		return DATASTORE:GetAsync(getProfileKey(userId))
	end)
	if not success then
		warn("[ProfileStore] failed to load profile", userId, result)
		return createDefaultProfile(userId)
	end
	return mergeLoadedProfile(userId, result)
end

local function ensureProfileLoaded(userId)
	if profilesByUserId[userId] ~= nil then
		return profilesByUserId[userId]
	end

	local profile = loadPersistedProfile(userId)
	profilesByUserId[userId] = profile
	loadedUserIds[userId] = true
	return profile
end

local function markDirty(userId)
	dirtyUserIds[userId] = true
end

local function saveProfileByUserId(userId)
	local profile = profilesByUserId[userId]
	if profile == nil then
		return false
	end

	local serialized = serializeProfile(profile)
	local success, result = pcall(function()
		DATASTORE:UpdateAsync(getProfileKey(userId), function()
			return serialized
		end)
	end)
	if not success then
		warn("[ProfileStore] failed to save profile", userId, result)
		return false
	end

	dirtyUserIds[userId] = nil
	return true
end

local function getProfileByUserId(userId)
	return ensureProfileLoaded(userId)
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

	if
		typeof(player) == "Instance"
		and player:IsA("Player")
		and loadedUserIds[player.UserId] == true
	then
		-- Replicate on the first real-player load and let mutations push later updates.
		if player:GetAttribute("ProfileReplicatedOnce") ~= true then
			player:SetAttribute("ProfileReplicatedOnce", true)
			replicateProfile(player)
		end
	end

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
	return deepClone(profile.LastRoundResult)
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
			then deepClone(profile.LastRoundResult)
			else nil,
		shiftsPlayed = profile.ShiftsPlayed,
		shiftsCleared = profile.ShiftsCleared,
	}
end

function ProfileStore.mutateProfile(player, mutator, options)
	local profile = getProfileByUserId(player.UserId)
	mutator(profile)
	refreshDerivedProfileFields(profile)
	markDirty(player.UserId)

	local leaderstats = ProfileStore.getLeaderstats(player)
	if leaderstats ~= nil then
		local cash = leaderstats:FindFirstChild("Cash")
		if cash ~= nil and cash:IsA("IntValue") then
			cash.Value = profile.Cash
		end
	end

	if options ~= nil and options.saveImmediately == true then
		saveProfileByUserId(player.UserId)
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
		profile.LastRoundResult = deepClone(resultPayload)
	end, {
		saveImmediately = true,
	})
end

function ProfileStore.saveProfile(player)
	if player == nil then
		return false
	end
	return saveProfileByUserId(player.UserId)
end

Players.PlayerAdded:Connect(function(player)
	ProfileStore.loadProfile(player)
end)

Players.PlayerRemoving:Connect(function(player)
	saveProfileByUserId(player.UserId)
	profilesByUserId[player.UserId] = nil
	loadedUserIds[player.UserId] = nil
	dirtyUserIds[player.UserId] = nil
end)

game:BindToClose(function()
	for userId in pairs(dirtyUserIds) do
		saveProfileByUserId(userId)
	end
end)

return ProfileStore
