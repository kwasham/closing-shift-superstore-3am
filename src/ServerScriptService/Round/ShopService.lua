local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))
local AnalyticsService =
	require(script.Parent.Parent:WaitForChild("Analytics"):WaitForChild("AnalyticsService"))

local ShopService = {}
ShopService.__index = ShopService

function ShopService.new(profileStore)
	local self = setmetatable({}, ShopService)
	self.profileStore = profileStore
	return self
end

local function isNonPlayingState(roundState)
	return roundState ~= Constants.RoundState.Playing
end

local function getProfileSnapshot(profileStore, player)
	return profileStore.getPublicProfile(player)
end

function ShopService:openShop(player, entryPoint, roundState)
	if not isNonPlayingState(roundState) then
		return {
			ok = false,
			message = "Shop closed during shift.",
			profile = getProfileSnapshot(self.profileStore, player),
		}
	end

	AnalyticsService.emit("shop_opened", {
		user_id = player.UserId,
		round_id = nil,
		entry_point = entryPoint or "lobby",
	})

	return {
		ok = true,
		profile = getProfileSnapshot(self.profileStore, player),
	}
end

function ShopService:handlePrimaryAction(player, itemId, roundState)
	if not isNonPlayingState(roundState) then
		return {
			ok = false,
			message = "Shop closed during shift.",
			profile = getProfileSnapshot(self.profileStore, player),
		}
	end

	local profile = self.profileStore.getProfile(player)
	local item = Constants.Cosmetics.Catalog[itemId]
	if profile == nil or item == nil then
		return {
			ok = false,
			message = "Unavailable item.",
			profile = getProfileSnapshot(self.profileStore, player),
		}
	end

	local slotId = item.slot
	local equippedItemId = profile.EquippedCosmetics[slotId]
	local isOwned = profile.OwnedCosmetics[itemId] == true
	local isEquipped = equippedItemId == itemId

	if isEquipped then
		return {
			ok = true,
			noop = true,
			message = "Equipped",
			profile = getProfileSnapshot(self.profileStore, player),
		}
	end

	if isOwned then
		local previousItemId = equippedItemId
		self.profileStore.mutateProfile(player, function(nextProfile)
			nextProfile.EquippedCosmetics[slotId] = itemId
		end, {
			saveImmediately = true,
		})
		AnalyticsService.emit("cosmetic_equipped", {
			user_id = player.UserId,
			round_id = nil,
			item_id = itemId,
			slot_id = slotId,
			previous_item_id = previousItemId,
		})
		return {
			ok = true,
			action = "equipped",
			message = "Equipped",
			profile = getProfileSnapshot(self.profileStore, player),
		}
	end

	if profile.Level < item.requiredLevel then
		local message = string.format("Employee Rank too low. Reach Level %d.", item.requiredLevel)
		AnalyticsService.emit("shop_purchase_denied", {
			user_id = player.UserId,
			round_id = nil,
			item_id = itemId,
			slot_id = slotId,
			deny_reason = "insufficient_level",
			required_level = item.requiredLevel,
			price_cash = item.priceCash,
			player_level = profile.Level,
			player_cash = profile.Cash,
		})
		return {
			ok = false,
			message = message,
			profile = getProfileSnapshot(self.profileStore, player),
		}
	end

	if profile.Cash < item.priceCash then
		local message = "Not enough Cash. Finish another shift."
		AnalyticsService.emit("shop_purchase_denied", {
			user_id = player.UserId,
			round_id = nil,
			item_id = itemId,
			slot_id = slotId,
			deny_reason = "insufficient_cash",
			required_level = item.requiredLevel,
			price_cash = item.priceCash,
			player_level = profile.Level,
			player_cash = profile.Cash,
		})
		return {
			ok = false,
			message = message,
			profile = getProfileSnapshot(self.profileStore, player),
		}
	end

	local cashBefore = profile.Cash
	self.profileStore.mutateProfile(player, function(nextProfile)
		nextProfile.Cash -= item.priceCash
		nextProfile.OwnedCosmetics[itemId] = true
	end, {
		saveImmediately = true,
	})
	AnalyticsService.emit("shop_purchase_succeeded", {
		user_id = player.UserId,
		round_id = nil,
		item_id = itemId,
		slot_id = slotId,
		price_cash = item.priceCash,
		required_level = item.requiredLevel,
		cash_before = cashBefore,
		cash_after = cashBefore - item.priceCash,
	})

	return {
		ok = true,
		action = "purchased",
		message = "Owned — Equip",
		profile = getProfileSnapshot(self.profileStore, player),
	}
end

function ShopService:handleRequest(player, request, roundState)
	local action = if type(request) == "table" then request.action else nil
	if action == "open" then
		return self:openShop(player, request.entryPoint, roundState)
	end
	if action == "primary" then
		return self:handlePrimaryAction(player, request.itemId, roundState)
	end

	return {
		ok = true,
		profile = getProfileSnapshot(self.profileStore, player),
	}
end

return ShopService
