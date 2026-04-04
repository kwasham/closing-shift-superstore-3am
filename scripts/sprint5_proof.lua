local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local AnalyticsService = require(ServerScriptService.Analytics:WaitForChild("AnalyticsService"))
local ProfileStore = require(ServerScriptService.Data:WaitForChild("ProfileStore"))
local RoundResultsService = require(ServerScriptService.Round:WaitForChild("RoundResultsService"))
local ShiftService = require(ServerScriptService.Round:WaitForChild("ShiftService"))
local ShopService = require(ServerScriptService.Round:WaitForChild("ShopService"))
local SoftLaunchService = require(ServerScriptService.Round:WaitForChild("SoftLaunchService"))

local function makePlayer(userId, name)
	return {
		UserId = userId,
		Name = name,
		Parent = Workspace,
	}
end

local function countRecentEvents(eventName)
	local count = 0
	for _, entry in ipairs(AnalyticsService.getRecentEvents()) do
		if entry.eventName == eventName then
			count += 1
		end
	end
	return count
end

local function getLatestEventPayload(eventName)
	local latest = nil
	for _, entry in ipairs(AnalyticsService.getRecentEvents()) do
		if entry.eventName == eventName then
			latest = entry.payload
		end
	end
	return latest
end

local function listRecentEventNames()
	local names = {}
	for _, entry in ipairs(AnalyticsService.getRecentEvents()) do
		table.insert(names, entry.eventName)
	end
	return table.concat(names, ",")
end

local player = makePlayer(9501, "Sprint5Closer")
local badgeAwards = {}
local currentUnixTime = DateTime.fromUniversalTime(2026, 4, 4, 0, 30, 0).UnixTimestamp

AnalyticsService.clearRecentEvents()
ProfileStore.loadProfile(player)

local softLaunchService = SoftLaunchService.new({
	profileStore = ProfileStore,
	timeProvider = function()
		return currentUnixTime
	end,
	badgeAwarder = {
		awardBadge = function(_, badgePlayer, badgeDefinition)
			table.insert(
				badgeAwards,
				string.format("%d:%s", badgePlayer.UserId, badgeDefinition.badgeId)
			)
			return true
		end,
	},
})
local roundResultsService = RoundResultsService.new({
	profileStore = ProfileStore,
	softLaunchService = softLaunchService,
})

local function finalizeRound(roundId, success, shiftCash)
	local resultsByUserId = roundResultsService:finalizeRound({ player }, {
		roundId = roundId,
		success = success,
		shiftCash = shiftCash,
		personalPenalties = {},
		playerTaskCountsByUserId = {
			[player.UserId] = {
				[Constants.TaskId.RestockShelf] = 2,
				[Constants.TaskId.CleanSpill] = 1,
				[Constants.TaskId.TakeOutTrash] = 1,
				[Constants.TaskId.ReturnCart] = 2,
				[Constants.TaskId.CheckFreezer] = 1,
				[Constants.TaskId.CloseRegister] = if success then 1 else 0,
			},
		},
		securityAlarmResolvedByUserId = if success then player.UserId else nil,
	})
	return resultsByUserId[player.UserId], ProfileStore.getPublicProfile(player)
end

local resultDay1, publicDay1 = finalizeRound("s5-day1-success", true, 130)
local resultDay1Repeat, publicDay1Repeat = finalizeRound("s5-day1-repeat", true, 130)
currentUnixTime = DateTime.fromUniversalTime(2026, 4, 5, 0, 30, 0).UnixTimestamp
local resultDay2 = finalizeRound("s5-day2-failure", false, 14)
currentUnixTime = DateTime.fromUniversalTime(2026, 4, 6, 0, 30, 0).UnixTimestamp
local resultDay3, publicDay3 = finalizeRound("s5-day3-failure", false, 14)

local shareShiftService = ShiftService.new({
	networkEnabled = false,
	profileStore = ProfileStore,
	roundResultsService = roundResultsService,
	taskService = {
		getProgressSnapshot = function()
			return {}
		end,
		endRound = function() end,
	},
	eventService = {
		endRound = function() end,
	},
})
shareShiftService.lastRoundResultsByUserId[player.UserId] = resultDay1
shareShiftService.shareTelemetryStateByUserId[player.UserId] = {
	roundId = resultDay1.roundId,
	shown = false,
	pressed = false,
	fallbackReasons = {},
}
local shareShownOk = shareShiftService:handleShareAction(player, {
	action = "cta_shown",
	roundId = resultDay1.roundId,
	inviteSupported = true,
})
local sharePressedOk = shareShiftService:handleShareAction(player, {
	action = "cta_pressed",
	roundId = resultDay1.roundId,
	inviteSupported = true,
})

local fallbackShiftService = ShiftService.new({
	networkEnabled = false,
	profileStore = ProfileStore,
	roundResultsService = roundResultsService,
	taskService = {
		getProgressSnapshot = function()
			return {}
		end,
		endRound = function() end,
	},
	eventService = {
		endRound = function() end,
	},
})
fallbackShiftService.lastRoundResultsByUserId[player.UserId] = resultDay2
fallbackShiftService.shareTelemetryStateByUserId[player.UserId] = {
	roundId = resultDay2.roundId,
	shown = false,
	pressed = false,
	fallbackReasons = {},
}
local shareShownFallbackOk = fallbackShiftService:handleShareAction(player, {
	action = "cta_shown",
	roundId = resultDay2.roundId,
	inviteSupported = false,
})
local shareFallbackOk = fallbackShiftService:handleShareAction(player, {
	action = "fallback_shown",
	roundId = resultDay2.roundId,
	fallbackReason = "platform_unsupported",
})

local shopService = ShopService.new(ProfileStore)
local shopSync = shopService:handleRequest(player, {
	action = "sync",
}, Constants.RoundState.Waiting)

local dailyAwardPayload = getLatestEventPayload("daily_first_shift_bonus_awarded")
local dailySkipPayload = getLatestEventPayload("daily_first_shift_bonus_skipped")
local badgeAwardPayload = getLatestEventPayload("launch_badge_awarded")
local shareShownPayload = getLatestEventPayload("round_end_share_cta_shown")
local sharePressedPayload = getLatestEventPayload("round_end_share_cta_pressed")
local shareFallbackPayload = getLatestEventPayload("round_end_share_cta_fallback_shown")

assert(resultDay1.baseSavedCashAdded == 165, "success base payout should stay 165")
assert(resultDay1.dailyFirstShiftBonusCash == 25, "day 1 should award daily bonus")
assert(resultDay1.totalSavedCashAdded == 190, "day 1 total saved cash should be 190")
assert(resultDay1Repeat.baseSavedCashAdded == 165, "repeat same-day base payout should stay 165")
assert(resultDay1Repeat.dailyFirstShiftBonusCash == 0, "repeat same-day should skip bonus")
assert(resultDay2.baseSavedCashAdded == 8, "failure base payout should stay 8")
assert(resultDay2.dailyFirstShiftBonusCash == 25, "day 2 should award daily bonus")
assert(resultDay3.dailyFirstShiftBonusCash == 25, "day 3 should award daily bonus")
assert(publicDay1.lastDailyBonusResetKeyUtc == "2026-04-04", "day 1 reset key mismatch")
assert(publicDay3.lastDailyBonusResetKeyUtc == "2026-04-06", "day 3 reset key mismatch")
assert(publicDay3.awardedBadges.first_shift == true, "first_shift badge missing")
assert(publicDay3.awardedBadges.shift_cleared == true, "shift_cleared badge missing")
assert(publicDay3.awardedBadges.three_am_regular == true, "three_am_regular badge missing")
assert(shareShownOk == true, "share shown path should be accepted")
assert(sharePressedOk == true, "share pressed path should be accepted")
assert(shareShownFallbackOk == true, "share shown fallback path should be accepted")
assert(shareFallbackOk == true, "share fallback path should be accepted")
assert(shopSync.profile ~= nil, "shop sync should still return a profile")
assert(publicDay1.lastRoundResult ~= nil, "public profile should expose round result")
assert(publicDay1Repeat.lastRoundResult ~= nil, "repeat result should persist to public profile")

print(
	string.format(
		"S5_PROOF daily_bonus_award base=%d bonus=%d total=%d reset=%s",
		resultDay1.baseSavedCashAdded,
		resultDay1.dailyFirstShiftBonusCash,
		resultDay1.totalSavedCashAdded,
		publicDay1.lastDailyBonusResetKeyUtc
	)
)
print(
	string.format(
		"S5_PROOF daily_bonus_skip_same_day base=%d bonus=%d total=%d skip_reason=%s",
		resultDay1Repeat.baseSavedCashAdded,
		resultDay1Repeat.dailyFirstShiftBonusCash,
		resultDay1Repeat.totalSavedCashAdded,
		tostring(dailySkipPayload and dailySkipPayload.skip_reason)
	)
)
print(
	string.format(
		"S5_PROOF launch_badges first_shift=%s shift_cleared=%s three_am_regular=%s awards=%s",
		tostring(publicDay3.awardedBadges.first_shift == true),
		tostring(publicDay3.awardedBadges.shift_cleared == true),
		tostring(publicDay3.awardedBadges.three_am_regular == true),
		table.concat(badgeAwards, ",")
	)
)
print(
	string.format(
		"S5_PROOF share_cta shown=%s pressed=%s variant=%s invite_supported=%s",
		tostring(shareShownOk),
		tostring(sharePressedOk),
		tostring(shareShownPayload and shareShownPayload.cta_variant),
		tostring(sharePressedPayload and sharePressedPayload.invite_supported)
	)
)
print(
	string.format(
		"S5_PROOF share_cta_fallback shown=%s reason=%s",
		tostring(shareFallbackOk),
		tostring(shareFallbackPayload and shareFallbackPayload.fallback_reason)
	)
)
print(
	string.format(
		"S5_PROOF persistence daily_reset=%s badge_count=%d shifts_played=%d shifts_cleared=%d cash=%d xp=%d",
		tostring(publicDay3.lastDailyBonusResetKeyUtc),
		countRecentEvents("launch_badge_awarded"),
		publicDay3.shiftsPlayed,
		publicDay3.shiftsCleared,
		publicDay3.cash,
		publicDay3.xp
	)
)
print(
	string.format(
		"S5_PROOF store_sync ok=%s cash=%d level=%d",
		tostring(shopSync.ok),
		shopSync.profile.cash,
		shopSync.profile.level
	)
)
print(
	string.format(
		"S5_PROOF analytics daily_awarded=%s daily_skipped=%s badge_awarded=%s share_shown=%s share_pressed=%s share_fallback=%s names=%s",
		tostring(dailyAwardPayload ~= nil),
		tostring(dailySkipPayload ~= nil),
		tostring(badgeAwardPayload ~= nil),
		tostring(shareShownPayload ~= nil),
		tostring(sharePressedPayload ~= nil),
		tostring(shareFallbackPayload ~= nil),
		listRecentEventNames()
	)
)
print("S5_PROOF_OK")
