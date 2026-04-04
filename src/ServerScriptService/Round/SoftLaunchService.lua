local BadgeService = game:GetService("BadgeService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))
local UIStrings = require(Shared:WaitForChild("UIStrings"))

local Config = require(script.Parent:WaitForChild("Config"))
local AnalyticsService =
	require(script.Parent.Parent:WaitForChild("Analytics"):WaitForChild("AnalyticsService"))

local SoftLaunchService = {}
SoftLaunchService.__index = SoftLaunchService

local function countDictionaryKeys(dictionary)
	local count = 0
	for _ in pairs(dictionary) do
		count += 1
	end
	return count
end

local function createDefaultBadgeAwarder()
	local awarder = {}

	function awarder:awardBadge(player, badgeDefinition)
		if RunService:IsStudio() then
			return true
		end
		if badgeDefinition.assetId == nil or badgeDefinition.assetId <= 0 then
			return false, "service_error"
		end

		local ok, hadBadgeOrAwarded = pcall(function()
			if BadgeService:UserHasBadgeAsync(player.UserId, badgeDefinition.assetId) then
				return true
			end
			BadgeService:AwardBadge(player.UserId, badgeDefinition.assetId)
			return true
		end)
		if not ok or hadBadgeOrAwarded ~= true then
			return false, "service_error"
		end
		return true
	end

	return awarder
end

function SoftLaunchService.new(options)
	local self = setmetatable({}, SoftLaunchService)
	self.profileStore = options.profileStore
	self.config = options.config or Config.softLaunch
	self.badgeAwarder = options.badgeAwarder or createDefaultBadgeAwarder()
	self.timeProvider = options.timeProvider or os.time
	return self
end

function SoftLaunchService:getResetKeyUtc(unixTimestamp)
	local adjustedTimestamp = unixTimestamp
		- (self.config.daily_first_shift_bonus_reset_hour_utc * 60 * 60)
	return os.date("!%Y-%m-%d", adjustedTimestamp)
end

function SoftLaunchService:buildShareCtaPayload(roundOutcome)
	if not self.config.soft_launch_enabled or not self.config.share_cta_enabled then
		return nil
	end
	if roundOutcome == "success" and not self.config.share_cta_show_on_success then
		return nil
	end
	if roundOutcome == "failure" and not self.config.share_cta_show_on_failure then
		return nil
	end

	return {
		variant = roundOutcome,
		helperText = if roundOutcome == "success"
			then UIStrings.SoftLaunch.ShareSuccessHelper
			else UIStrings.SoftLaunch.ShareFailureHelper,
		fallbackHelperText = UIStrings.SoftLaunch.ShareFallbackHelper,
		buttonText = UIStrings.SoftLaunch.ShareButton,
	}
end

function SoftLaunchService:_emitDailyBonusEvent(eventName, payload)
	AnalyticsService.emit(eventName, payload)
end

function SoftLaunchService:_emitBadgeEvent(eventName, payload)
	AnalyticsService.emit(eventName, payload)
end

function SoftLaunchService:_awardEligibleBadges(player, roundContext, bonusAwarded)
	local unlockedBadges = {}
	local profile = self.profileStore.getProfile(player)
	local eligibleBadgeIds = {}

	if profile.AwardedBadges[Constants.SoftLaunch.BadgeId.FirstShift] ~= true then
		table.insert(eligibleBadgeIds, Constants.SoftLaunch.BadgeId.FirstShift)
	end
	if
		roundContext.roundOutcome == "success"
		and profile.AwardedBadges[Constants.SoftLaunch.BadgeId.ShiftCleared] ~= true
	then
		table.insert(eligibleBadgeIds, Constants.SoftLaunch.BadgeId.ShiftCleared)
	end
	if
		bonusAwarded
		and profile.AwardedBadges[Constants.SoftLaunch.BadgeId.ThreeAmRegular] ~= true
		and countDictionaryKeys(profile.DailyBonusClaimDays)
			>= self.config.three_am_regular_days_required
	then
		table.insert(eligibleBadgeIds, Constants.SoftLaunch.BadgeId.ThreeAmRegular)
	end

	for _, badgeId in ipairs(Constants.SoftLaunch.BadgeOrder) do
		if table.find(eligibleBadgeIds, badgeId) ~= nil then
			local badgeDefinition = Constants.SoftLaunch.BadgeDefinitions[badgeId]
			if not self.config.soft_launch_enabled or not self.config.launch_badges_enabled then
				self:_emitBadgeEvent("launch_badge_award_failed", {
					user_id = player.UserId,
					round_id = roundContext.roundId,
					round_outcome = roundContext.roundOutcome,
					badge_id = badgeId,
					failure_reason = "feature_disabled",
				})
			else
				local ok, failureReason = self.badgeAwarder:awardBadge(player, badgeDefinition)
				if ok then
					self.profileStore.mutateProfile(player, function(nextProfile)
						nextProfile.AwardedBadges[badgeId] = true
					end, {
						suppressReplicate = true,
					})
					table.insert(unlockedBadges, {
						badgeId = badgeDefinition.badgeId,
						badgeName = badgeDefinition.badgeName,
					})
					self:_emitBadgeEvent("launch_badge_awarded", {
						user_id = player.UserId,
						round_id = roundContext.roundId,
						round_outcome = roundContext.roundOutcome,
						badge_id = badgeDefinition.badgeId,
						badge_name = badgeDefinition.badgeName,
						award_source = "round_end_results",
					})
				else
					self:_emitBadgeEvent("launch_badge_award_failed", {
						user_id = player.UserId,
						round_id = roundContext.roundId,
						round_outcome = roundContext.roundOutcome,
						badge_id = badgeId,
						failure_reason = failureReason or "service_error",
					})
				end
			end
		end
	end

	return unlockedBadges
end

function SoftLaunchService:applyRoundEnd(player, roundContext)
	local resetKeyUtc = self:getResetKeyUtc(self.timeProvider())
	local dailyFirstShiftBonusCash = 0
	local bonusAwarded = false
	local profile = self.profileStore.getProfile(player)

	if not self.config.soft_launch_enabled or not self.config.daily_first_shift_bonus_enabled then
		self:_emitDailyBonusEvent("daily_first_shift_bonus_skipped", {
			user_id = player.UserId,
			round_id = roundContext.roundId,
			round_outcome = roundContext.roundOutcome,
			shift_cash = roundContext.shiftCash,
			base_saved_cash_added = roundContext.baseSavedCashAdded,
			reset_key_utc = resetKeyUtc,
			skip_reason = "feature_disabled",
		})
	elseif profile.LastDailyBonusResetKeyUtc == resetKeyUtc then
		self:_emitDailyBonusEvent("daily_first_shift_bonus_skipped", {
			user_id = player.UserId,
			round_id = roundContext.roundId,
			round_outcome = roundContext.roundOutcome,
			shift_cash = roundContext.shiftCash,
			base_saved_cash_added = roundContext.baseSavedCashAdded,
			reset_key_utc = resetKeyUtc,
			skip_reason = "already_claimed_today",
		})
	else
		dailyFirstShiftBonusCash = self.config.daily_first_shift_bonus_cash
		bonusAwarded = true
		self.profileStore.mutateProfile(player, function(nextProfile)
			nextProfile.Cash += dailyFirstShiftBonusCash
			nextProfile.LastDailyBonusResetKeyUtc = resetKeyUtc
			nextProfile.DailyBonusClaimDays[resetKeyUtc] = true
		end, {
			suppressReplicate = true,
		})
		self:_emitDailyBonusEvent("daily_first_shift_bonus_awarded", {
			user_id = player.UserId,
			round_id = roundContext.roundId,
			round_outcome = roundContext.roundOutcome,
			shift_cash = roundContext.shiftCash,
			base_saved_cash_added = roundContext.baseSavedCashAdded,
			bonus_cash = dailyFirstShiftBonusCash,
			total_saved_cash_added = roundContext.baseSavedCashAdded + dailyFirstShiftBonusCash,
			reset_key_utc = resetKeyUtc,
		})
	end

	local unlockedBadges = self:_awardEligibleBadges(player, roundContext, bonusAwarded)
	local shareCta = self:buildShareCtaPayload(roundContext.roundOutcome)
	return {
		dailyFirstShiftBonusCash = dailyFirstShiftBonusCash,
		unlockedBadges = unlockedBadges,
		shareCta = shareCta,
		resetKeyUtc = resetKeyUtc,
	}
end

function SoftLaunchService:recordShareCtaShown(player, roundResult, inviteSupported)
	AnalyticsService.emit("round_end_share_cta_shown", {
		user_id = player.UserId,
		round_id = roundResult.roundId,
		round_outcome = roundResult.outcome,
		cta_variant = roundResult.shareCta.variant,
		invite_supported = inviteSupported == true,
	})
end

function SoftLaunchService:recordShareCtaPressed(player, roundResult, inviteSupported)
	AnalyticsService.emit("round_end_share_cta_pressed", {
		user_id = player.UserId,
		round_id = roundResult.roundId,
		round_outcome = roundResult.outcome,
		cta_variant = roundResult.shareCta.variant,
		invite_supported = inviteSupported == true,
	})
end

function SoftLaunchService:recordShareCtaFallbackShown(player, roundResult, fallbackReason)
	AnalyticsService.emit("round_end_share_cta_fallback_shown", {
		user_id = player.UserId,
		round_id = roundResult.roundId,
		round_outcome = roundResult.outcome,
		fallback_reason = fallbackReason,
	})
end

return SoftLaunchService
