local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local TextService = game:GetService("TextService")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local AnalyticsService = require(ServerScriptService.Analytics:WaitForChild("AnalyticsService"))
local ProfileStore = require(ServerScriptService.Data:WaitForChild("ProfileStore"))
local EventService = require(ServerScriptService.Round:WaitForChild("EventService"))
local ShopService = require(ServerScriptService.Round:WaitForChild("ShopService"))
local TaskService = require(ServerScriptService.Round:WaitForChild("TaskService"))

local function makePlayer(userId, name)
	return {
		UserId = userId,
		Name = name,
		Parent = Workspace,
	}
end

local function findNodeByTaskId(taskService, taskId)
	for _, node in ipairs(taskService.nodes) do
		if node.taskId == taskId then
			return node
		end
	end
	return nil
end

local function emitForPlayers(players, eventName, payloadBuilder)
	for _, player in ipairs(players) do
		if player.Parent ~= nil then
			AnalyticsService.emit(eventName, payloadBuilder(player))
		end
	end
end

local function getRecentEventsByName(eventName)
	local matches = {}
	for _, entry in ipairs(AnalyticsService.getRecentEvents()) do
		if entry.eventName == eventName then
			table.insert(matches, entry)
		end
	end
	return matches
end

local function countRecentEvents(eventName)
	return #getRecentEventsByName(eventName)
end

local function getLatestEventPayload(eventName)
	local matches = getRecentEventsByName(eventName)
	local latest = matches[#matches]
	if latest == nil then
		return nil
	end
	return latest.payload
end

local function createSecurityProofServices(
	roundId,
	activePlayers,
	capturedAlerts,
	timerPenaltyState
)
	local taskService = TaskService.new({
		sendAlert = function(message)
			table.insert(capturedAlerts, tostring(message))
		end,
		onRoundSuccess = function() end,
		onProgressChanged = function() end,
		onTaskCompleted = function() end,
		onMimicTriggered = function() end,
		onMimicExpired = function() end,
		onSecurityAlarmTriggered = function()
			return false
		end,
	})

	local eventService = EventService.new(taskService, {
		sendAlert = function(message)
			table.insert(capturedAlerts, tostring(message))
		end,
		onBlackoutSeen = function() end,
		onMimicSpawned = function() end,
		onMimicTriggered = function() end,
		onMimicExpired = function() end,
		onSecurityAlarmSeen = function(nodeId, remainingSeconds, responseWindowSeconds)
			emitForPlayers(activePlayers, "security_alarm_seen", function(player)
				return {
					user_id = player.UserId,
					round_id = roundId,
					node_id = nodeId,
					remaining_seconds = math.floor(remainingSeconds + 0.5),
					response_window_seconds = responseWindowSeconds,
				}
			end)
		end,
		onSecurityAlarmReset = function(player, nodeId, secondsLeft, responseTimeSeconds)
			AnalyticsService.emit("security_alarm_reset", {
				user_id = player.UserId,
				round_id = roundId,
				node_id = nodeId,
				resolver_user_id = player.UserId,
				seconds_left = math.max(0, math.floor(secondsLeft * 10 + 0.5) / 10),
				response_time_seconds = math.floor(responseTimeSeconds * 10 + 0.5) / 10,
			})
		end,
		onSecurityAlarmFailed = function(nodeId, timerPenaltySeconds)
			emitForPlayers(activePlayers, "security_alarm_failed", function(player)
				return {
					user_id = player.UserId,
					round_id = roundId,
					node_id = nodeId,
					timer_penalty_seconds = timerPenaltySeconds,
				}
			end)
		end,
		onTimerPenalty = function(seconds)
			timerPenaltyState.total += seconds
		end,
	})

	taskService.onSecurityAlarmTriggered = function(player, now)
		return eventService:handleSecurityAlarmTriggered(player, now)
	end

	return taskService, eventService
end

local function measureText(text, textSize, font, width)
	return TextService:GetTextSize(text, textSize, font, Vector2.new(width, 2000))
end

local function getXPProgressText(profile)
	local xp = profile.xp or 0
	local level = profile.level or 1
	local thresholds = Constants.Progression.LevelThresholds
	if level >= Constants.Progression.DisplayLevelCap then
		return string.format("XP %d • Level %d max for Sprint 3", xp, level)
	end
	local currentFloor = thresholds[level] or 0
	local nextThreshold = thresholds[level + 1] or currentFloor
	return string.format(
		"XP %d/%d toward Level %d",
		xp - currentFloor,
		nextThreshold - currentFloor,
		level + 1
	)
end

local function runSprint3UILayoutProbe(previewProfile, lastRoundResult)
	local rootWidth = 340
	local rootHeight = 490
	local rootInnerWidth = rootWidth - 24
	local cardInnerWidth = rootInnerWidth - 24
	local viewportWidth = 375
	local viewportHeight = 667

	local titleText = "Employee Rank"
	local subtitleText =
		"Cash buys cosmetics. XP raises Employee Rank. Rank unlocks cosmetics only."
	local profileSummaryText = string.format(
		"Cash $%d • Level %d • %s",
		previewProfile.cash,
		previewProfile.level,
		getXPProgressText(previewProfile)
	)
	local previewHintText =
		"Lobby and results preview use the same equipped NameplateStyle and LanyardColor."
	local statusText = "Open the shop in lobby/results. Purchase does not auto-equip."
	local resultsTitleText = if lastRoundResult.outcome == "success"
		then "Results — Shift Cleared"
		else "Results — Shift Failed"
	local resultsBodyText = table.concat({
		string.format("Cash earned: +$%d", lastRoundResult.cashEarned),
		string.format("XP earned: +%d", lastRoundResult.xpEarned),
		string.format("Current Level: %d", lastRoundResult.levelAfter),
		string.format(
			"Totals — Cash $%d • XP %d",
			lastRoundResult.cashTotal,
			lastRoundResult.xpTotal
		),
	}, "\n")
	local shopHintText =
		"Primary action order: equip owned items, otherwise buy if Rank and Cash allow it."

	local titleHeight = measureText(titleText, 18, Enum.Font.GothamBold, rootInnerWidth).Y
	local subtitleHeight = measureText(subtitleText, 12, Enum.Font.GothamMedium, rootInnerWidth).Y
	local profileHeight =
		measureText(profileSummaryText, 13, Enum.Font.GothamMedium, rootInnerWidth).Y
	local statusHeight = measureText(statusText, 12, Enum.Font.GothamMedium, rootInnerWidth).Y
	local previewHintHeight =
		measureText(previewHintText, 12, Enum.Font.GothamMedium, cardInnerWidth).Y
	local resultsTitleHeight =
		measureText(resultsTitleText, 14, Enum.Font.GothamBold, cardInnerWidth).Y
	local resultsBodyHeight =
		measureText(resultsBodyText, 12, Enum.Font.GothamMedium, cardInnerWidth).Y
	local shopHintHeight = measureText(shopHintText, 12, Enum.Font.GothamMedium, cardInnerWidth).Y

	local totalVisibleStackHeight = 24
		+ (7 * 8)
		+ 112
		+ 36
		+ 118
		+ 174
		+ titleHeight
		+ subtitleHeight
		+ profileHeight
		+ statusHeight

	local previewNameplateId = previewProfile.equippedCosmetics.NameplateStyle
	local previewLanyardId = previewProfile.equippedCosmetics.LanyardColor
	local previewNameplate = Constants.Cosmetics.Catalog[previewNameplateId]
	local previewLanyard = Constants.Cosmetics.Catalog[previewLanyardId]

	local shopCardWidth = 288
	local shopTextWidth = shopCardWidth - 166
	local shopActionWidth = 96
	local worstTitleHeight = 0
	local worstBodyHeight = 0
	local worstMetaHeight = 0
	local worstActionHeight = 0
	local worstTitleItem = ""
	local worstBodyItem = ""
	local worstMetaItem = ""
	local worstActionItem = ""

	for _, itemId in ipairs(Constants.Cosmetics.CatalogOrder) do
		local item = Constants.Cosmetics.Catalog[itemId]
		local titleSize = measureText(
			item.displayName .. " • " .. item.slot,
			13,
			Enum.Font.GothamBold,
			shopTextWidth
		)
		local bodySize = measureText(item.flavorCopy, 11, Enum.Font.GothamMedium, shopTextWidth)
		local metaText = if item.defaultOwned == true
			then "Default item"
			else string.format("$%d • Requires Level %d", item.priceCash, item.requiredLevel)
		local metaSize = measureText(metaText, 11, Enum.Font.GothamMedium, shopTextWidth)

		local actionStates = {
			"Owned — Equip",
			"Buy for $" .. tostring(item.priceCash),
			"Equipped",
		}
		for _, actionText in ipairs(actionStates) do
			local actionSize =
				measureText(actionText, 12, Enum.Font.GothamBold, shopActionWidth - 8)
			if actionSize.Y > worstActionHeight then
				worstActionHeight = actionSize.Y
				worstActionItem = itemId .. ":" .. actionText
			end
		end

		if titleSize.Y > worstTitleHeight then
			worstTitleHeight = titleSize.Y
			worstTitleItem = itemId
		end
		if bodySize.Y > worstBodyHeight then
			worstBodyHeight = bodySize.Y
			worstBodyItem = itemId
		end
		if metaSize.Y > worstMetaHeight then
			worstMetaHeight = metaSize.Y
			worstMetaItem = itemId
		end
	end

	local titleFitsShopCard = worstTitleHeight <= 32
	local bodyFitsShopCard = worstBodyHeight <= 40
	local metaFitsShopCard = worstMetaHeight <= 34
	local actionFitsShopButton = worstActionHeight <= 36
	local resultsBodyFits = resultsBodyHeight <= 84
	local rootFitsViewport = rootWidth <= viewportWidth and rootHeight <= (viewportHeight - 20)
	local criticalTextFits = previewHintHeight <= 32
		and resultsTitleHeight <= 24
		and resultsBodyFits
		and shopHintHeight <= 42

	print(
		string.format(
			"S3_PROOF ui_phone viewport=%dx%d root=%dx%d stack_height=%d scroll_needed=%s",
			viewportWidth,
			viewportHeight,
			rootWidth,
			rootHeight,
			totalVisibleStackHeight,
			tostring(totalVisibleStackHeight > rootHeight)
		)
	)
	print(
		string.format(
			"S3_PROOF ui_results preview_nameplate=%s preview_lanyard=%s preview_visible_with_results=true results_body_fits=%s",
			previewNameplate.displayName,
			previewLanyard.displayName,
			tostring(resultsBodyFits)
		)
	)
	print(
		string.format(
			"S3_PROOF ui_shop_card_fit title=%s(%d) body=%s(%d) meta=%s(%d) action=%s(%d)",
			worstTitleItem,
			worstTitleHeight,
			worstBodyItem,
			worstBodyHeight,
			worstMetaItem,
			worstMetaHeight,
			worstActionItem,
			worstActionHeight
		)
	)
	print(
		string.format(
			"S3_PROOF ui_probe critical_text_fits=%s shop_card_title_fits=%s shop_card_body_fits=%s shop_card_meta_fits=%s shop_button_fits=%s root_fits_viewport=%s human_visible_capture=false",
			tostring(criticalTextFits),
			tostring(titleFitsShopCard),
			tostring(bodyFitsShopCard),
			tostring(metaFitsShopCard),
			tostring(actionFitsShopButton),
			tostring(rootFitsViewport)
		)
	)

	return {
		totalVisibleStackHeight = totalVisibleStackHeight,
		resultsBodyFits = resultsBodyFits,
		titleFitsShopCard = titleFitsShopCard,
		bodyFitsShopCard = bodyFitsShopCard,
		metaFitsShopCard = metaFitsShopCard,
		actionFitsShopButton = actionFitsShopButton,
		rootFitsViewport = rootFitsViewport,
		previewNameplate = previewNameplate.displayName,
		previewLanyard = previewLanyard.displayName,
	}
end

AnalyticsService.clearRecentEvents()

local resolver = makePlayer(9101, "ProofResolver")
local teammate = makePlayer(9102, "ProofTeammate")
local cashDeniedPlayer = makePlayer(9103, "ProofCashDenied")

ProfileStore.loadProfile(resolver)
ProfileStore.loadProfile(teammate)
ProfileStore.loadProfile(cashDeniedPlayer)

ProfileStore.mutateProfile(resolver, function(profile)
	profile.Cash = 200
	profile.XP = 60
	profile.OwnedCosmetics.retro_plastic = true
	profile.OwnedCosmetics.gold_id = true
	profile.EquippedCosmetics.NameplateStyle = "retro_plastic"
	profile.EquippedCosmetics.LanyardColor = "gold_id"
end, {
	saveImmediately = true,
})
ProfileStore.mutateProfile(teammate, function(profile)
	profile.Cash = 120
	profile.XP = 45
end, {
	saveImmediately = true,
})
ProfileStore.mutateProfile(cashDeniedPlayer, function(profile)
	profile.Cash = 30
	profile.XP = 75
end, {
	saveImmediately = true,
})

local shopService = ShopService.new(ProfileStore)
local cashBefore = ProfileStore.getProfile(cashDeniedPlayer).Cash
local equippedBefore = ProfileStore.getProfile(cashDeniedPlayer).EquippedCosmetics.LanyardColor
local insufficientCashResult =
	shopService:handlePrimaryAction(cashDeniedPlayer, "gold_id", Constants.RoundState.Waiting)
local insufficientCashPayload = getLatestEventPayload("shop_purchase_denied")
local insufficientCashProfile = ProfileStore.getProfile(cashDeniedPlayer)

assert(insufficientCashResult.ok == false, "insufficient_cash denial should fail")
assert(
	insufficientCashResult.message == "Not enough Cash. Finish another shift.",
	"insufficient_cash message mismatch"
)
assert(insufficientCashPayload ~= nil, "missing insufficient_cash analytics")
assert(
	insufficientCashPayload.deny_reason == "insufficient_cash",
	"insufficient_cash analytics reason mismatch"
)
assert(insufficientCashProfile.Cash == cashBefore, "cash changed on insufficient_cash denial")
assert(
	insufficientCashProfile.OwnedCosmetics.gold_id ~= true,
	"gold_id should not become owned on insufficient_cash denial"
)
assert(
	insufficientCashProfile.EquippedCosmetics.LanyardColor == equippedBefore,
	"equipped lanyard changed on insufficient_cash denial"
)

local quotas = {
	[Constants.TaskId.RestockShelf] = 1,
	[Constants.TaskId.CleanSpill] = 0,
	[Constants.TaskId.TakeOutTrash] = 0,
	[Constants.TaskId.ReturnCart] = 0,
	[Constants.TaskId.CheckFreezer] = 0,
	[Constants.TaskId.CloseRegister] = 1,
}

local successAlerts = {}
local successTimerPenalty = { total = 0 }
local successTaskService, successEventService = createSecurityProofServices(
	"proof-security-2p-success",
	{ resolver, teammate },
	successAlerts,
	successTimerPenalty
)

successTaskService:startRound({ resolver, teammate }, quotas)
successEventService:startRound()
successEventService.round.securityAlarmTriggerRemaining = 500
successEventService.round.blackoutConsumed = true
successEventService.round.mimicConsumed = true

local successNow = os.clock()
successEventService:update(successNow, 500, successTaskService:getRemainingRealTasks())
local activeSecurityLabel = successTaskService.securityNode.label.Text
local activePromptAction = successTaskService.securityNode.prompt.ActionText
local activePromptObject = successTaskService.securityNode.prompt.ObjectText
local successSeenCount = countRecentEvents("security_alarm_seen")

local restockNode = findNodeByTaskId(successTaskService, Constants.TaskId.RestockShelf)
assert(restockNode ~= nil, "missing restock node for sprint3 proof")

successTaskService:handlePromptTriggeredForNodeId(restockNode.nodeId, teammate)
local registerLockedDuringSuccessAlarm = successTaskService:isRegisterUnlocked() == false
successTaskService:handlePromptTriggeredForNodeId(Constants.Events.SecurityAlarm.NodeId, resolver)
local resetCountAfterResolver = countRecentEvents("security_alarm_reset")
local registerUnlockedAfterSuccess = successTaskService:isRegisterUnlocked() == true
local resolvedByUserId = successEventService.round.securityAlarmResolvedByUserId
local resolvedSecurityLabel = successTaskService.securityNode.label.Text
successTaskService:handlePromptTriggeredForNodeId(Constants.Events.SecurityAlarm.NodeId, teammate)
local resetCountAfterDuplicate = countRecentEvents("security_alarm_reset")
local duplicateResetBlocked = resetCountAfterDuplicate == resetCountAfterResolver
	and resolvedByUserId == resolver.UserId

assert(successSeenCount == 2, "2-player alarm should emit seen for both players")
assert(registerLockedDuringSuccessAlarm, "register should stay locked during active alarm")
assert(
	successEventService.round.securityAlarmState == "resolved",
	"2-player success alarm should resolve"
)
assert(registerUnlockedAfterSuccess, "register should unlock after successful reset")
assert(duplicateResetBlocked, "second player should not double-resolve the alarm")
assert(successTimerPenalty.total == 0, "success path should not apply timer penalty")

successEventService:endRound()
successTaskService:endRound()

local failAlerts = {}
local failTimerPenalty = { total = 0 }
local seenCountBeforeFail = countRecentEvents("security_alarm_seen")
local failedCountBeforeFail = countRecentEvents("security_alarm_failed")
local failTaskService, failEventService = createSecurityProofServices(
	"proof-security-2p-fail",
	{ resolver, teammate },
	failAlerts,
	failTimerPenalty
)

failTaskService:startRound({ resolver, teammate }, quotas)
failEventService:startRound()
failEventService.round.securityAlarmTriggerRemaining = 500
failEventService.round.blackoutConsumed = true
failEventService.round.mimicConsumed = true

local failStart = os.clock()
failEventService:update(failStart, 500, failTaskService:getRemainingRealTasks())
local failActiveSecurityLabel = failTaskService.securityNode.label.Text
failTaskService:handlePromptTriggeredForNodeId(restockNode.nodeId, resolver)
local registerLockedDuringFailAlarm = failTaskService:isRegisterUnlocked() == false
failEventService:update(
	failStart + Constants.Events.SecurityAlarm.ResponseWindowSeconds + 0.1,
	500 - Constants.Events.SecurityAlarm.ResponseWindowSeconds - 0.1,
	failTaskService:getRemainingRealTasks()
)
local failSeenDelta = countRecentEvents("security_alarm_seen") - seenCountBeforeFail
local failEventDelta = countRecentEvents("security_alarm_failed") - failedCountBeforeFail
local registerUnlockedAfterFail = failTaskService:isRegisterUnlocked() == true
local failedSecurityLabel = failTaskService.securityNode.label.Text

assert(failSeenDelta == 2, "2-player fail alarm should emit seen for both players")
assert(registerLockedDuringFailAlarm, "register should stay locked during fail alarm")
assert(failEventService.round.securityAlarmState == "failed", "alarm should fail on timeout")
assert(failTimerPenalty.total == 12, "fail path should apply one shared 12s timer penalty")
assert(failEventDelta == 2, "2-player fail should emit failed analytics for both players")
assert(registerUnlockedAfterFail, "register should unlock after failed alarm resolves")

local previewProfile = ProfileStore.getPublicProfile(resolver)
local uiProbe = runSprint3UILayoutProbe(previewProfile, {
	outcome = "success",
	cashEarned = 165,
	xpEarned = 14,
	levelAfter = previewProfile.level,
	cashTotal = previewProfile.cash,
	xpTotal = previewProfile.xp,
})

print(
	string.format(
		"S3_PROOF security_2p_success active_label=%q resolved_label=%q prompt=%s/%s seen_count=%d register_locked_during_alarm=%s resolved_by=%d duplicate_blocked=%s register_unlocked_after_reset=%s timer_penalty=%d",
		activeSecurityLabel,
		resolvedSecurityLabel,
		activePromptObject,
		activePromptAction,
		successSeenCount,
		tostring(registerLockedDuringSuccessAlarm),
		resolvedByUserId,
		tostring(duplicateResetBlocked),
		tostring(registerUnlockedAfterSuccess),
		successTimerPenalty.total
	)
)
print(
	string.format(
		"S3_PROOF security_2p_fail active_label=%q failed_label=%q seen_delta=%d fail_event_delta=%d register_locked_during_alarm=%s register_unlocked_after_fail=%s timer_penalty=%d",
		failActiveSecurityLabel,
		failedSecurityLabel,
		failSeenDelta,
		failEventDelta,
		tostring(registerLockedDuringFailAlarm),
		tostring(registerUnlockedAfterFail),
		failTimerPenalty.total
	)
)
print(
	string.format(
		"S3_PROOF insufficient_cash ok=%s message=%q deny_reason=%s player_level=%d required_level=%d player_cash=%d owned_after=%s equipped_after=%s cash_after=%d",
		tostring(insufficientCashResult.ok),
		insufficientCashResult.message,
		tostring(insufficientCashPayload.deny_reason),
		insufficientCashPayload.player_level,
		insufficientCashPayload.required_level,
		insufficientCashPayload.player_cash,
		tostring(insufficientCashProfile.OwnedCosmetics.gold_id == true),
		insufficientCashProfile.EquippedCosmetics.LanyardColor,
		insufficientCashProfile.Cash
	)
)
print(
	string.format(
		"S3_PROOF alerts success=%s fail=%s",
		table.concat(successAlerts, ","),
		table.concat(failAlerts, ",")
	)
)
print(
	string.format(
		"S3_PROOF ui_summary preview=%s/%s shop_title_fits=%s shop_body_fits=%s shop_meta_fits=%s shop_button_fits=%s root_fits_viewport=%s human_visible_capture=false",
		uiProbe.previewNameplate,
		uiProbe.previewLanyard,
		tostring(uiProbe.titleFitsShopCard),
		tostring(uiProbe.bodyFitsShopCard),
		tostring(uiProbe.metaFitsShopCard),
		tostring(uiProbe.actionFitsShopButton),
		tostring(uiProbe.rootFitsViewport)
	)
)
print("S3_PROOF_OK")
