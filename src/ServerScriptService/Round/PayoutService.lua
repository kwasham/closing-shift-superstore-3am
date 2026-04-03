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

function PayoutService.calculateAwardedPayouts(
	players,
	basePay: number,
	success: boolean,
	personalPenalties
)
	local awardedPayouts = {}
	for _, player in ipairs(players) do
		local userId = player.UserId
		awardedPayouts[userId] =
			PayoutService.calculatePlayerPayout(basePay, success, personalPenalties[userId] or 0)
	end
	return awardedPayouts
end

function PayoutService.awardPlayers(
	players,
	basePay: number,
	success: boolean,
	personalPenalties,
	profileStore
)
	local awardedPayouts =
		PayoutService.calculateAwardedPayouts(players, basePay, success, personalPenalties)
	if profileStore ~= nil then
		for _, player in ipairs(players) do
			if player.Parent ~= nil then
				profileStore.addCash(player, awardedPayouts[player.UserId] or 0)
			end
		end
	end
	return awardedPayouts
end

return PayoutService
