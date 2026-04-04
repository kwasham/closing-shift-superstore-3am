local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local AnalyticsService =
	require(script.Parent.Parent:WaitForChild("Analytics"):WaitForChild("AnalyticsService"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ProfileChanged = Remotes:WaitForChild("ProfileChanged")

local ProfileStore = {}

local savedProfilesByUserId = {}
local sessionStateByUserId = {}

local function isNetworkPlayer(player)
	return typeof(player) == "Instance" and player:IsA("Player")
end

local function getUserId(player)
	if player == nil then
		return nil
	end
	if isNetworkPlayer(player) then
		return player.UserId
	end
	if type(player) == "table" then
		return player.UserId
	end
	return nil
end

local function deepCopy(value)
	if type(value) ~= "table" then
		return value
	end

	local copy = {}
	for key, nestedValue in pairs(value) do
		copy[deepCopy(key)] = deepCopy(nestedValue)
	end
	return copy
end

local function countOwnedCosmetics(ownedCosmetics)
	local count = 0
	for _, owned in pairs(ownedCosmetics) do
		if owned == true then
			count += 1
		end
	end
	return count
end

local function getLevelForXP(xp)
	local resolvedLevel = 1
	for level, threshold in pairs(Constants.Progression.LevelThresholds) do
		if xp >= threshold and level > resolvedLevel then
			resolvedLevel = level
		end
	end
	return resolvedLevel
end

local function getDefaultProfile()
	local ownedCosmetics = {}
	for itemId, item in pairs(Constants.Cosmetics.Catalog) do
		if item.defaultOwned == true then
			ownedCosmetics[itemId] = true
		end
	end

	return {
		ProfileVersion = 1,
		Cash = 0,
		XP = 0,
		Level = 1,
		ShiftsPlayed = 0,
		ShiftsCleared = 0,
		OwnedCosmetics = ownedCosmetics,
		EquippedCosmetics = deepCopy(Constants.Cosmetics.DefaultEquipped),
		DailyBonusClaimDays = {},
		LastDailyBonusResetKeyUtc = nil,
		AwardedBadges = {},
	}
end

local function normalizeProfile(profile)
	profile.ProfileVersion = profile.ProfileVersion or 1
	profile.Cash = math.max(0, profile.Cash or 0)
	profile.XP = math.max(0, profile.XP or 0)
	profile.ShiftsPlayed = math.max(0, profile.ShiftsPlayed or 0)
	profile.ShiftsCleared = math.max(0, profile.ShiftsCleared or 0)
	profile.OwnedCosmetics = profile.OwnedCosmetics or {}
	profile.EquippedCosmetics = profile.EquippedCosmetics or {}
	profile.DailyBonusClaimDays = profile.DailyBonusClaimDays or {}
	profile.AwardedBadges = profile.AwardedBadges or {}

	for itemId, item in pairs(Constants.Cosmetics.Catalog) do
		if item.defaultOwned == true then
			profile.OwnedCosmetics[itemId] = true
		end
	end

	for slotId, defaultItemId in pairs(Constants.Cosmetics.DefaultEquipped) do
		local equippedItemId = profile.EquippedCosmetics[slotId]
		local equippedItemIsValid = equippedItemId ~= nil
			and Constants.Cosmetics.Catalog[equippedItemId] ~= nil
			and profile.OwnedCosmetics[equippedItemId] == true
		if not equippedItemIsValid then
			profile.EquippedCosmetics[slotId] = defaultItemId
		end
	end

	profile.Level = getLevelForXP(profile.XP)
	return profile
end

local function saveSessionProfile(userId)
	local sessionState = sessionStateByUserId[userId]
	if sessionState == nil then
		return
	end
	savedProfilesByUserId[userId] = deepCopy(sessionState.profile)
end

local function getOrCreateSessionState(player)
	local userId = getUserId(player)
	assert(userId ~= nil, "ProfileStore requires a player with UserId")

	local sessionState = sessionStateByUserId[userId]
	if sessionState ~= nil then
		return sessionState
	end

	local savedProfile = savedProfilesByUserId[userId]
	local profile = normalizeProfile(deepCopy(savedProfile or getDefaultProfile()))
	sessionState = {
		profile = profile,
		lastRoundResult = nil,
	}
	sessionStateByUserId[userId] = sessionState
	savedProfilesByUserId[userId] = deepCopy(profile)
	return sessionState
end

local function syncLeaderstats(player, profile)
	if not isNetworkPlayer(player) or player.Parent == nil then
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
		cash.Parent = leaderstats
	end

	cash.Value = profile.Cash
	return leaderstats
end

local function buildPublicProfile(userId, sessionState)
	local profile = sessionState.profile
	return {
		profileVersion = profile.ProfileVersion,
		cash = profile.Cash,
		xp = profile.XP,
		level = profile.Level,
		shiftsPlayed = profile.ShiftsPlayed,
		shiftsCleared = profile.ShiftsCleared,
		ownedCosmetics = deepCopy(profile.OwnedCosmetics),
		equippedCosmetics = deepCopy(profile.EquippedCosmetics),
		lastDailyBonusResetKeyUtc = profile.LastDailyBonusResetKeyUtc,
		awardedBadges = deepCopy(profile.AwardedBadges),
		lastRoundResult = deepCopy(sessionState.lastRoundResult),
		userId = userId,
	}
end

local function broadcastProfileChanged(player)
	if not isNetworkPlayer(player) or player.Parent == nil then
		return
	end

	local userId = getUserId(player)
	local sessionState = sessionStateByUserId[userId]
	if sessionState == nil then
		return
	end

	ProfileChanged:FireClient(player, buildPublicProfile(userId, sessionState))
end

function ProfileStore.getLeaderstats(player)
	local sessionState = getOrCreateSessionState(player)
	return syncLeaderstats(player, sessionState.profile)
end

function ProfileStore.loadProfile(player)
	local userId = getUserId(player)
	local sessionState = getOrCreateSessionState(player)
	syncLeaderstats(player, sessionState.profile)
	AnalyticsService.emit("profile_loaded", {
		user_id = userId,
		profile_version = sessionState.profile.ProfileVersion,
		cash = sessionState.profile.Cash,
		xp = sessionState.profile.XP,
		level = sessionState.profile.Level,
		owned_cosmetic_count = countOwnedCosmetics(sessionState.profile.OwnedCosmetics),
	})
	broadcastProfileChanged(player)
	return deepCopy(sessionState.profile)
end

function ProfileStore.getProfile(player)
	local sessionState = getOrCreateSessionState(player)
	return sessionState.profile
end

function ProfileStore.getPublicProfile(player)
	local userId = getUserId(player)
	local sessionState = getOrCreateSessionState(player)
	return buildPublicProfile(userId, sessionState)
end

function ProfileStore.mutateProfile(player, mutator, options)
	options = options or {}
	local userId = getUserId(player)
	local sessionState = getOrCreateSessionState(player)
	local profile = sessionState.profile

	mutator(profile)
	normalizeProfile(profile)
	syncLeaderstats(player, profile)
	saveSessionProfile(userId)

	if options.suppressReplicate ~= true then
		broadcastProfileChanged(player)
	end

	return deepCopy(profile)
end

function ProfileStore.addCash(player, amount)
	local nextCash = 0
	ProfileStore.mutateProfile(player, function(profile)
		profile.Cash += amount
		nextCash = profile.Cash
	end)
	return nextCash
end

function ProfileStore.addXP(player, amount)
	local nextXP = 0
	ProfileStore.mutateProfile(player, function(profile)
		profile.XP += amount
		nextXP = profile.XP
	end)
	return nextXP
end

function ProfileStore.setLastRoundResult(player, payload)
	local userId = getUserId(player)
	local sessionState = getOrCreateSessionState(player)
	sessionState.lastRoundResult = deepCopy(payload)
	saveSessionProfile(userId)
	broadcastProfileChanged(player)
end

function ProfileStore.clearLastRoundResult(player)
	local userId = getUserId(player)
	local sessionState = getOrCreateSessionState(player)
	sessionState.lastRoundResult = nil
	saveSessionProfile(userId)
	broadcastProfileChanged(player)
end

function ProfileStore.unloadProfile(player)
	local userId = getUserId(player)
	if userId == nil then
		return
	end
	saveSessionProfile(userId)
	sessionStateByUserId[userId] = nil
end

for _, player in ipairs(Players:GetPlayers()) do
	ProfileStore.loadProfile(player)
end

Players.PlayerAdded:Connect(function(player)
	ProfileStore.loadProfile(player)
end)

Players.PlayerRemoving:Connect(function(player)
	ProfileStore.unloadProfile(player)
end)

return ProfileStore
