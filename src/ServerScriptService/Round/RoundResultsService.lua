local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local PayoutService = require(script.Parent:WaitForChild("PayoutService"))
local SoftLaunchService = require(script.Parent:WaitForChild("SoftLaunchService"))

local RoundResultsService = {}
RoundResultsService.__index = RoundResultsService

function RoundResultsService.new(options)
	local self = setmetatable({}, RoundResultsService)
	self.profileStore = options.profileStore
	self.softLaunchService = options.softLaunchService
		or SoftLaunchService.new({
			profileStore = options.profileStore,
		})
	return self
end

function RoundResultsService.calculatePlayerXPEarned(taskCounts, success, securityAlarmResolver)
	local xpEarned = 0
	for taskId, count in pairs(taskCounts or {}) do
		if taskId == Constants.TaskId.CloseRegister then
			xpEarned += count * Constants.Progression.Rewards.CloseRegisterXP
		else
			xpEarned += count * Constants.Progression.Rewards.TaskXP
		end
	end

	xpEarned += if success
		then Constants.Progression.Rewards.ShiftSuccessBonusXP
		else Constants.Progression.Rewards.ShiftFailureXP
	if securityAlarmResolver then
		xpEarned += Constants.Progression.Rewards.SecurityAlarmResetXP
	end

	return xpEarned
end

function RoundResultsService:finalizeRound(players, roundData)
	local roundOutcome = if roundData.success then "success" else "failure"
	local resultsByUserId = {}

	for _, player in ipairs(players) do
		if player.Parent ~= nil then
			local userId = player.UserId
			local personalPenalty = roundData.personalPenalties[userId] or 0
			local baseSavedCashAdded = PayoutService.calculatePlayerPayout(
				roundData.shiftCash,
				roundData.success,
				personalPenalty
			)
			local xpEarned = RoundResultsService.calculatePlayerXPEarned(
				roundData.playerTaskCountsByUserId[userId],
				roundData.success,
				roundData.securityAlarmResolvedByUserId == userId
			)

			self.profileStore.mutateProfile(player, function(profile)
				profile.Cash += baseSavedCashAdded
				profile.XP += xpEarned
				profile.ShiftsPlayed += 1
				if roundData.success then
					profile.ShiftsCleared += 1
				end
			end, {
				suppressReplicate = true,
			})

			local softLaunchResult = self.softLaunchService:applyRoundEnd(player, {
				roundId = roundData.roundId,
				roundOutcome = roundOutcome,
				shiftCash = roundData.shiftCash,
				baseSavedCashAdded = baseSavedCashAdded,
			})
			local publicProfile = self.profileStore.getPublicProfile(player)
			local totalSavedCashAdded = baseSavedCashAdded
				+ softLaunchResult.dailyFirstShiftBonusCash
			local resultPayload = {
				roundId = roundData.roundId,
				outcome = roundOutcome,
				shiftCash = roundData.shiftCash,
				baseSavedCashAdded = baseSavedCashAdded,
				dailyFirstShiftBonusCash = softLaunchResult.dailyFirstShiftBonusCash,
				totalSavedCashAdded = totalSavedCashAdded,
				cashEarned = totalSavedCashAdded,
				xpEarned = xpEarned,
				levelAfter = publicProfile.level,
				cashTotal = publicProfile.cash,
				xpTotal = publicProfile.xp,
				unlockedBadges = {},
				shareCta = softLaunchResult.shareCta,
			}

			for index, badge in ipairs(softLaunchResult.unlockedBadges) do
				resultPayload.unlockedBadges[index] = {
					badgeId = badge.badgeId,
					badgeName = badge.badgeName,
				}
			end

			self.profileStore.setLastRoundResult(player, resultPayload)
			resultsByUserId[userId] = resultPayload
		end
	end

	return resultsByUserId
end

return RoundResultsService
