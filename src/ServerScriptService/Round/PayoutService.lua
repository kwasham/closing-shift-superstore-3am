local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local PayoutService = {}

function PayoutService.calculatePlayerPayout(
	basePay: number,
	success: boolean,
	personalPenalty: number
)
	local gross = if success
		then basePay + Constants.Payout.SuccessBonus
		else math.floor(basePay * Constants.Payout.FailureMultiplier)

	return math.max(0, gross - personalPenalty)
end

function PayoutService.awardPlayers(
	players,
	basePay: number,
	success: boolean,
	personalPenalties,
	profileStore
)
	local awardedPayouts = {}

	for _, player in ipairs(players) do
		if player.Parent ~= nil then
			local userId = player.UserId
			local payout = PayoutService.calculatePlayerPayout(
				basePay,
				success,
				personalPenalties[userId] or 0
			)
			profileStore.addCash(player, payout)
			awardedPayouts[userId] = payout
		end
	end

	return awardedPayouts
end

return PayoutService
