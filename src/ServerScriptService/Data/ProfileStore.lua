local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))
local AnalyticsService =
	require(script.Parent.Parent:WaitForChild("Analytics"):WaitForChild("AnalyticsService"))

local PROFILE_STORE_NAME = "ClosingShift_Profile_v1"

local ProfileStore = {}

local profileDataStore = nil
local sessionProfiles = {}
local memoryProfiles = {}
local onProfileChanged = nil

local function deepCopy(value)
	if type(value) ~= "table" then
		return value
	end

	local result = {}
	for key, nestedValue in pairs(value) do
		result[key] = deepCopy(nestedValue)
	end
	return result
end

local function getDefaultProfile()
	return {
		ProfileVersion = Constants.Progression.ProfileVersion,
		Cash = 0,
		XP = 0,
		Level = 1,
		ShiftsPlayed = 0,
		ShiftsCleared = 0,
		OwnedCosmetics = deepCopy(Constants.Cosmetics.DefaultOwned),
		EquippedCosmetics = deepCopy(Constants.Cosmetics.DefaultEquipped),
	}
end

local function cloneDictionary(dictionary)
	return table.clone(dictionary)
end

local function ensureDataStore()
	if profileDataStore ~= nil then
		return profileDataStore
	end

	local ok, store = pcall(function()
		return DataStoreService:GetDataStore(PROFILE_STORE_NAME)
	end)
	if ok then
		profileDataStore = store
	end

	return profileDataStore
end

function ProfileStore.computeLevelFromXP(xp)
	local thresholds = Constants.Progression.LevelThresholds
	local level = 1
	for index, requiredXP in ipairs(thresholds) do
		if xp >= requiredXP then
			level = index
		end
	end
	return math.min(level, Constants.Progression.DisplayLevelCap)
end

local function countOwnedCosmetics(ownedCosmetics)
	local count = 0
	for _, isOwned in pairs(ownedCosmetics) do
		if isOwned then
			count += 1
		end
	end
	return count
end

local function normalizeProfile(rawProfile)
	local defaultProfile = getDefaultProfile()
	local normalized = defaultProfile
	local source = if type(rawProfile) == "table" then rawProfile else {}

	if type(source.ProfileVersion) == "number" then
		normalized.ProfileVersion = source.ProfileVersion
	end
	if type(source.Cash) == "number" then
		normalized.Cash = math.max(0, math.floor(source.Cash))
	end
	if type(source.XP) == "number" then
		normalized.XP = math.max(0, math.floor(source.XP))
	end
	if type(source.ShiftsPlayed) == "number" then
		normalized.ShiftsPlayed = math.max(0, math.floor(source.ShiftsPlayed))
	end
	if type(source.ShiftsCleared) == "number" then
		normalized.ShiftsCleared = math.max(0, math.floor(source.ShiftsCleared))
	end

	if type(source.OwnedCosmetics) == "table" then
		for itemId, isOwned in pairs(source.OwnedCosmetics) do
			if isOwned == true and Constants.Cosmetics.Catalog[itemId] ~= nil then
				normalized.OwnedCosmetics[itemId] = true
			end
		end
	end

	for defaultItemId in pairs(Constants.Cosmetics.DefaultOwned) do
		normalized.OwnedCosmetics[defaultItemId] = true
	end

	if type(source.EquippedCosmetics) == "table" then
		for slotId, defaultItemId in pairs(Constants.Cosmetics.DefaultEquipped) do
			local equippedItemId = source.EquippedCosmetics[slotId]
			local item = if type(equippedItemId) == "string"
				then Constants.Cosmetics.Catalog[equippedItemId]
				else nil
			if
				item ~= nil
				and item.slot == slotId
				and normalized.OwnedCosmetics[equippedItemId] == true
			then
				normalized.EquippedCosmetics[slotId] = equippedItemId
			else
				normalized.EquippedCosmetics[slotId] = defaultItemId
			end
		end
	end

	normalized.Level = ProfileStore.computeLevelFromXP(normalized.XP)
	return normalized
end

local function resolveUserId(playerOrUserId)
	if type(playerOrUserId) == "number" then
		return playerOrUserId
	end
	if type(playerOrUserId) == "table" then
		return playerOrUserId.UserId
	end
	if typeof(playerOrUserId) == "Instance" then
		return playerOrUserId.UserId
	end
	return nil
end

local function syncPlayerInstance(player, profile)
	if typeof(player) ~= "Instance" then
		return
	end

	local leaderstats = ProfileStore.getLeaderstats(player)
	local cash = leaderstats:FindFirstChild("Cash")
	if cash ~= nil and cash:IsA("IntValue") then
		cash.Value = profile.Cash
	end

	player:SetAttribute("ProfileVersion", profile.ProfileVersion)
	player:SetAttribute("XP", profile.XP)
	player:SetAttribute("Level", profile.Level)
	player:SetAttribute("ShiftsPlayed", profile.ShiftsPlayed)
	player:SetAttribute("ShiftsCleared", profile.ShiftsCleared)
	player:SetAttribute("EquippedNameplateStyle", profile.EquippedCosmetics.NameplateStyle)
	player:SetAttribute("EquippedLanyardColor", profile.EquippedCosmetics.LanyardColor)
end

local function fireProfileChanged(player, profile, extraPayload)
	if onProfileChanged ~= nil then
		onProfileChanged(player, profile, extraPayload)
	end
end

local function loadStoredProfile(userId)
	if memoryProfiles[userId] ~= nil then
		return deepCopy(memoryProfiles[userId])
	end

	local store = ensureDataStore()
	if store == nil or RunService:IsStudio() then
		return nil
	end

	local ok, data = pcall(function()
		return store:GetAsync(tostring(userId))
	end)
	if ok and type(data) == "table" then
		memoryProfiles[userId] = deepCopy(data)
		return deepCopy(data)
	end

	return nil
end

local function saveStoredProfile(userId, profile)
	memoryProfiles[userId] = deepCopy(profile)

	local store = ensureDataStore()
	if store == nil or RunService:IsStudio() then
		return true
	end

	local ok = pcall(function()
		store:SetAsync(tostring(userId), deepCopy(profile))
	end)
	return ok
end

function ProfileStore.getLeaderstats(player)
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

function ProfileStore.setOnProfileChanged(callback)
	onProfileChanged = callback
end

function ProfileStore.getProfile(playerOrUserId)
	local userId = resolveUserId(playerOrUserId)
	if userId == nil then
		return nil
	end

	local entry = sessionProfiles[userId]
	if entry ~= nil then
		return entry.profile
	end

	return nil
end

function ProfileStore.getPublicProfile(playerOrUserId)
	local profile = ProfileStore.getProfile(playerOrUserId)
	if profile == nil then
		return nil
	end

	return {
		profileVersion = profile.ProfileVersion,
		cash = profile.Cash,
		xp = profile.XP,
		level = profile.Level,
		shiftsPlayed = profile.ShiftsPlayed,
		shiftsCleared = profile.ShiftsCleared,
		ownedCosmetics = cloneDictionary(profile.OwnedCosmetics),
		equippedCosmetics = cloneDictionary(profile.EquippedCosmetics),
	}
end

function ProfileStore.loadProfile(player)
	local userId = resolveUserId(player)
	assert(userId ~= nil, "ProfileStore.loadProfile requires a player-like value with UserId")

	local entry = sessionProfiles[userId]
	if entry ~= nil then
		entry.player = player
		syncPlayerInstance(player, entry.profile)
		fireProfileChanged(player, entry.profile)
		return entry.profile
	end

	local storedProfile = loadStoredProfile(userId)
	local profile = normalizeProfile(storedProfile)
	sessionProfiles[userId] = {
		player = player,
		profile = profile,
	}

	syncPlayerInstance(player, profile)
	AnalyticsService.emit("profile_loaded", {
		user_id = userId,
		round_id = nil,
		profile_version = profile.ProfileVersion,
		cash = profile.Cash,
		xp = profile.XP,
		level = profile.Level,
		owned_cosmetic_count = countOwnedCosmetics(profile.OwnedCosmetics),
	})
	fireProfileChanged(player, profile)
	return profile
end

function ProfileStore.saveProfile(playerOrUserId)
	local userId = resolveUserId(playerOrUserId)
	if userId == nil then
		return false
	end

	local entry = sessionProfiles[userId]
	if entry == nil then
		return false
	end

	return saveStoredProfile(userId, entry.profile)
end

function ProfileStore.mutateProfile(playerOrUserId, mutator, options)
	local userId = resolveUserId(playerOrUserId)
	if userId == nil then
		return nil
	end

	local entry = sessionProfiles[userId]
	if entry == nil then
		local playerLike = if type(playerOrUserId) == "number"
			then { UserId = userId }
			else playerOrUserId
		ProfileStore.loadProfile(playerLike)
		entry = sessionProfiles[userId]
	end
	if entry == nil then
		return nil
	end

	mutator(entry.profile)
	entry.profile.Level = ProfileStore.computeLevelFromXP(entry.profile.XP)
	syncPlayerInstance(entry.player, entry.profile)
	fireProfileChanged(
		entry.player,
		entry.profile,
		if options ~= nil then options.extraPayload else nil
	)
	if options ~= nil and options.saveImmediately == true then
		ProfileStore.saveProfile(userId)
	end
	return entry.profile
end

function ProfileStore.addCash(playerOrUserId, amount)
	return ProfileStore.mutateProfile(playerOrUserId, function(profile)
		profile.Cash = math.max(0, profile.Cash + math.floor(amount))
	end)
end

function ProfileStore.commitRoundRewards(playerOrUserId, rewardPayload)
	return ProfileStore.mutateProfile(playerOrUserId, function(profile)
		profile.Cash = math.max(0, profile.Cash + math.floor(rewardPayload.cashDelta or 0))
		profile.XP = math.max(0, profile.XP + math.floor(rewardPayload.xpDelta or 0))
		profile.ShiftsPlayed += math.max(0, math.floor(rewardPayload.shiftsPlayedDelta or 0))
		profile.ShiftsCleared += math.max(0, math.floor(rewardPayload.shiftsClearedDelta or 0))
	end, {
		saveImmediately = true,
		extraPayload = {
			lastRoundResult = rewardPayload.lastRoundResult,
		},
	})
end

function ProfileStore.releaseProfile(playerOrUserId)
	local userId = resolveUserId(playerOrUserId)
	if userId == nil then
		return
	end
	ProfileStore.saveProfile(userId)
	sessionProfiles[userId] = nil
end

Players.PlayerAdded:Connect(function(player)
	ProfileStore.loadProfile(player)
end)

Players.PlayerRemoving:Connect(function(player)
	ProfileStore.saveProfile(player)
end)

return ProfileStore
