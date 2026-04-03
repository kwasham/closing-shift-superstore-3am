local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))
local UIStrings = require(Shared:WaitForChild("UIStrings"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RoundStateChanged = Remotes:WaitForChild("RoundStateChanged")
local TaskProgressChanged = Remotes:WaitForChild("TaskProgressChanged")
local AlertRaised = Remotes:WaitForChild("AlertRaised")
local ProfileChanged = Remotes:WaitForChild("ProfileChanged")
local ShopAction = Remotes:WaitForChild("ShopAction")

local DataFolder = ServerScriptService:WaitForChild("Data")
local ProfileStore = require(DataFolder:WaitForChild("ProfileStore"))
local AnalyticsService =
	require(ServerScriptService:WaitForChild("Analytics"):WaitForChild("AnalyticsService"))

local RoundFolder = script.Parent
local Config = require(RoundFolder:WaitForChild("Config"))
local EventService = require(RoundFolder:WaitForChild("EventService"))
local PayoutService = require(RoundFolder:WaitForChild("PayoutService"))
local ShopService = require(RoundFolder:WaitForChild("ShopService"))
local TaskService = require(RoundFolder:WaitForChild("TaskService"))

local ShiftService = {}

local currentState = Constants.RoundState.Waiting
local currentTimerSeconds = 0
local currentRoundResult = nil
local currentProgress = nil
local roundSession = nil
local shopService = ShopService.new(ProfileStore)
local onboardingStateByUserId = {}

local function getOnboardingState(userId)
	local state = onboardingStateByUserId[userId]
	if state == nil then
		state = {
			shown = false,
			completed = false,
		}
		onboardingStateByUserId[userId] = state
	end
	return state
end

function ShiftService._emitOnboardingShownForPlayers(players)
	for _, player in ipairs(players) do
		if player.Parent ~= nil then
			local onboardingState = getOnboardingState(player.UserId)
			if not onboardingState.shown then
				onboardingState.shown = true
				AnalyticsService.emit("onboarding_shown", {
					user_id = player.UserId,
					round_id = nil,
				})
			end
		end
	end
end

function ShiftService._emitOnboardingCompletedForPlayers(players, roundId)
	for _, player in ipairs(players) do
		if player.Parent ~= nil then
			local onboardingState = getOnboardingState(player.UserId)
			if onboardingState.shown and not onboardingState.completed then
				onboardingState.completed = true
				AnalyticsService.emit("onboarding_completed", {
					user_id = player.UserId,
					round_id = roundId,
				})
			end
		end
	end
end

local function getActiveUserIds()
	if roundSession == nil then
		return {}
	end

	local userIds = {}
	for _, player in ipairs(roundSession.activePlayers) do
		table.insert(userIds, player.UserId)
	end
	return userIds
end

local function buildProfilePayload(player, extraPayload)
	local publicProfile = ProfileStore.getPublicProfile(player)
	if publicProfile == nil then
		return nil
	end

	local payload = table.clone(publicProfile)
	if type(extraPayload) == "table" and extraPayload.lastRoundResult ~= nil then
		payload.lastRoundResult = extraPayload.lastRoundResult
	end
	return payload
end

local function pushProfileUpdate(player, extraPayload)
	if typeof(player) ~= "Instance" or player.Parent == nil then
		return
	end

	local payload = buildProfilePayload(player, extraPayload)
	if payload ~= nil then
		ProfileChanged:FireClient(player, payload)
	end
end

ProfileStore.setOnProfileChanged(function(player, _, extraPayload)
	pushProfileUpdate(player, extraPayload)
end)

local function getRemainingSecondsPrecise()
	if roundSession == nil then
		return currentTimerSeconds
	end
	return math.max(0, roundSession.roundEndsAt - os.clock())
end

local function broadcastState()
	RoundStateChanged:FireAllClients({
		state = currentState,
		timerSeconds = currentTimerSeconds,
		roundResult = currentRoundResult,
		activeUserIds = getActiveUserIds(),
		progress = currentProgress,
	})
end

local function broadcastProgress(progress)
	currentProgress = progress
	TaskProgressChanged:FireAllClients(progress)
	broadcastState()
end

local function resolveAlertPayload(message)
	if type(message) == "string" and UIStrings.Alerts[message] ~= nil then
		return table.clone(UIStrings.Alerts[message])
	end
	if type(message) == "table" then
		return table.clone(message)
	end
	return message
end

local function sendAlert(message, targetPlayer)
	local payload = resolveAlertPayload(message)
	if
		targetPlayer ~= nil
		and typeof(targetPlayer) == "Instance"
		and targetPlayer.Parent ~= nil
	then
		AlertRaised:FireClient(targetPlayer, payload)
		return
	end
	AlertRaised:FireAllClients(payload)
end

local function emitForPlayers(eventName, players, payloadBuilder)
	for _, player in ipairs(players) do
		if player.Parent ~= nil then
			AnalyticsService.emit(eventName, payloadBuilder(player))
		end
	end
end

local taskService = TaskService.new({
	sendAlert = sendAlert,
	onRoundSuccess = function()
		-- Set below after function declarations.
	end,
	onProgressChanged = broadcastProgress,
	onTaskCompleted = function()
		-- Set below after function declarations.
	end,
	onMimicTriggered = function()
		-- Set below after function declarations.
	end,
	onMimicExpired = function()
		-- Set below after function declarations.
	end,
	onSecurityAlarmTriggered = function()
		return false
	end,
})

local eventService = EventService.new(taskService, {
	sendAlert = sendAlert,
	onBlackoutSeen = function(remainingSeconds)
		if roundSession == nil then
			return
		end
		emitForPlayers("blackout_seen", roundSession.activePlayers, function(player)
			return {
				user_id = player.UserId,
				round_id = roundSession.roundId,
				remaining_seconds = math.floor(remainingSeconds + 0.5),
			}
		end)
	end,
	onMimicSpawned = function(nodeId, remainingSeconds)
		if roundSession == nil then
			return
		end
		emitForPlayers("mimic_spawned", roundSession.activePlayers, function(player)
			return {
				user_id = player.UserId,
				round_id = roundSession.roundId,
				node_id = nodeId,
				remaining_seconds = math.floor(remainingSeconds + 0.5),
			}
		end)
	end,
	onMimicTriggered = function(player, nodeId)
		if roundSession == nil then
			return
		end
		AnalyticsService.emit("mimic_triggered", {
			user_id = player.UserId,
			round_id = roundSession.roundId,
			node_id = nodeId,
			trigger_user_id = player.UserId,
			timer_penalty_seconds = Constants.Events.Mimic.TimerPenaltySeconds,
			cash_penalty = Constants.Events.Mimic.CashPenalty,
		})
	end,
	onMimicExpired = function(nodeId)
		if roundSession == nil then
			return
		end
		emitForPlayers("mimic_expired", roundSession.activePlayers, function(player)
			return {
				user_id = player.UserId,
				round_id = roundSession.roundId,
				node_id = nodeId,
			}
		end)
	end,
	onSecurityAlarmSeen = function(nodeId, remainingSeconds, responseWindowSeconds)
		if roundSession == nil then
			return
		end
		emitForPlayers("security_alarm_seen", roundSession.activePlayers, function(player)
			return {
				user_id = player.UserId,
				round_id = roundSession.roundId,
				node_id = nodeId,
				remaining_seconds = math.floor(remainingSeconds + 0.5),
				response_window_seconds = responseWindowSeconds,
			}
		end)
	end,
	onSecurityAlarmReset = function(player, nodeId, secondsLeft, responseTimeSeconds)
		if roundSession == nil then
			return
		end
		roundSession.pendingXP[player.UserId] = (roundSession.pendingXP[player.UserId] or 0)
			+ Constants.Progression.XPBySource.SecurityAlarmReset
		AnalyticsService.emit("security_alarm_reset", {
			user_id = player.UserId,
			round_id = roundSession.roundId,
			node_id = nodeId,
			resolver_user_id = player.UserId,
			seconds_left = math.max(0, math.floor(secondsLeft * 10 + 0.5) / 10),
			response_time_seconds = math.floor(responseTimeSeconds * 10 + 0.5) / 10,
		})
	end,
	onSecurityAlarmFailed = function(nodeId, timerPenaltySeconds)
		if roundSession == nil then
			return
		end
		emitForPlayers("security_alarm_failed", roundSession.activePlayers, function(player)
			return {
				user_id = player.UserId,
				round_id = roundSession.roundId,
				node_id = nodeId,
				timer_penalty_seconds = timerPenaltySeconds,
			}
		end)
	end,
	onTimerPenalty = function(seconds)
		if roundSession == nil then
			return
		end
		roundSession.roundEndsAt = math.max(os.clock(), roundSession.roundEndsAt - seconds)
		currentTimerSeconds = math.ceil(getRemainingSecondsPrecise())
		broadcastState()
	end,
})

local finishRound

local function onTaskCompleted(player, taskId)
	if roundSession == nil then
		return
	end

	local xpGain = if taskId == Constants.TaskId.CloseRegister
		then Constants.Progression.XPBySource.CloseRegister
		else Constants.Progression.XPBySource.Task
	roundSession.pendingXP[player.UserId] = (roundSession.pendingXP[player.UserId] or 0) + xpGain

	if roundSession.firstTaskCompleted[player.UserId] ~= true then
		roundSession.firstTaskCompleted[player.UserId] = true
		AnalyticsService.emit("first_task_completed", {
			user_id = player.UserId,
			round_id = roundSession.roundId,
			task_id = taskId,
			seconds_elapsed = math.floor(
				Constants.Round.DurationSeconds - getRemainingSecondsPrecise() + 0.5
			),
		})
	end
end

local function onMimicTriggered(player, nodeId)
	eventService:handleMimicTriggered(player, nodeId)
	sendAlert("mimic_triggered")
end

local function onMimicExpired(nodeId)
	eventService:handleMimicExpired(nodeId)
end

taskService.onRoundSuccess = function()
	finishRound(true)
end

taskService.onTaskCompleted = onTaskCompleted

taskService.onMimicTriggered = onMimicTriggered

taskService.onMimicExpired = onMimicExpired

taskService.onSecurityAlarmTriggered = function(player, now)
	return eventService:handleSecurityAlarmTriggered(player, now)
end

local function setState(nextState, timerSeconds, roundResult)
	currentState = nextState
	currentTimerSeconds = timerSeconds or 0
	currentRoundResult = roundResult
	broadcastState()
end

local function getActivePlayersSnapshot()
	local players = Players:GetPlayers()
	local activePlayers = {}
	for index = 1, math.min(#players, Constants.Round.MaxPlayers) do
		table.insert(activePlayers, players[index])
	end
	return activePlayers
end

local function startIntermissionTimer(durationSeconds)
	setState(Constants.RoundState.Intermission, durationSeconds, nil)
	ShiftService._emitOnboardingShownForPlayers(getActivePlayersSnapshot())
	local endsAt = os.clock() + durationSeconds
	while currentState == Constants.RoundState.Intermission and os.clock() < endsAt do
		currentTimerSeconds = math.max(0, math.ceil(endsAt - os.clock()))
		broadcastState()
		task.wait(Constants.Round.TickSeconds)
	end
	currentTimerSeconds = 0
end

local function startRound()
	local activePlayers = getActivePlayersSnapshot()
	if #activePlayers < Constants.Round.MinPlayers then
		return false
	end

	roundSession = {
		roundId = string.format("r-%d-%d", os.time(), Random.new():NextInteger(1000, 9999)),
		activePlayers = activePlayers,
		pendingXP = {},
		firstTaskCompleted = {},
		roundEndsAt = os.clock() + Constants.Round.DurationSeconds,
		resolving = false,
	}
	for _, player in ipairs(activePlayers) do
		ProfileStore.loadProfile(player)
		roundSession.pendingXP[player.UserId] = 0
	end
	ShiftService._emitOnboardingCompletedForPlayers(activePlayers, roundSession.roundId)

	local quotas = Config.getQuotaTemplate(#activePlayers)
	taskService:startRound(activePlayers, quotas)
	eventService:startRound()
	currentProgress = taskService:getProgressSnapshot()
	setState(Constants.RoundState.Playing, Constants.Round.DurationSeconds, nil)
	sendAlert("round_start_hint")

	emitForPlayers("shift_started", activePlayers, function(player)
		local profile = ProfileStore.getProfile(player)
		return {
			user_id = player.UserId,
			round_id = roundSession.roundId,
			party_size = #activePlayers,
			level = if profile ~= nil then profile.Level else 1,
			cash = if profile ~= nil then profile.Cash else 0,
		}
	end)
	return true
end

finishRound = function(success)
	if roundSession == nil or roundSession.resolving then
		return
	end
	roundSession.resolving = true

	local basePay = taskService:getBasePay()
	local personalPenalties = taskService:getPersonalPenalties()
	local awardedPayouts = PayoutService.calculateAwardedPayouts(
		roundSession.activePlayers,
		basePay,
		success,
		personalPenalties
	)
	local remainingSeconds = math.floor(getRemainingSecondsPrecise() + 0.5)
	local outcome = if success then "success" else "failure"

	setState(Constants.RoundState.Ended, remainingSeconds, outcome)
	sendAlert(if success then "round_success" else "round_failure")

	for _, player in ipairs(roundSession.activePlayers) do
		local userId = player.UserId
		local profileBefore = ProfileStore.getProfile(player)
		local playerStillPresent = player.Parent ~= nil
		local cashAwarded = if playerStillPresent then awardedPayouts[userId] or 0 else 0
		local xpAwarded = roundSession.pendingXP[userId] or 0
		if playerStillPresent then
			xpAwarded += if success
				then Constants.Progression.XPBySource.ShiftSuccess
				else Constants.Progression.XPBySource.ShiftFailure
		end

		local lastRoundResult = nil
		if playerStillPresent then
			lastRoundResult = {
				outcome = outcome,
				cashEarned = cashAwarded,
				xpEarned = xpAwarded,
				levelBefore = if profileBefore ~= nil then profileBefore.Level else 1,
			}
		end

		local profileAfter = ProfileStore.commitRoundRewards(player, {
			cashDelta = cashAwarded,
			xpDelta = xpAwarded,
			shiftsPlayedDelta = 1,
			shiftsClearedDelta = if success and playerStillPresent then 1 else 0,
			lastRoundResult = lastRoundResult,
		})

		if playerStillPresent and profileAfter ~= nil then
			lastRoundResult.levelAfter = profileAfter.Level
			lastRoundResult.cashTotal = profileAfter.Cash
			lastRoundResult.xpTotal = profileAfter.XP
			pushProfileUpdate(player, { lastRoundResult = lastRoundResult })
			AnalyticsService.emit(if success then "shift_success" else "shift_failure", {
				user_id = userId,
				round_id = roundSession.roundId,
				party_size = #roundSession.activePlayers,
				remaining_seconds = remainingSeconds,
				cash_awarded = cashAwarded,
				xp_awarded = xpAwarded,
			})
			AnalyticsService.emit("results_shown", {
				user_id = userId,
				round_id = roundSession.roundId,
				outcome = outcome,
				cash_total = profileAfter.Cash,
				xp_total = profileAfter.XP,
				level = profileAfter.Level,
			})
		end
	end
end

local function endRoundCleanup()
	eventService:endRound()
	taskService:endRound()
	currentProgress = taskService:getProgressSnapshot()
	roundSession = nil
end

Players.PlayerRemoving:Connect(function(player)
	onboardingStateByUserId[player.UserId] = nil
end)

function ShiftService.start()
	ShopAction.OnServerInvoke = function(player, request)
		return shopService:handleRequest(player, request, currentState)
	end

	for _, player in ipairs(Players:GetPlayers()) do
		ProfileStore.loadProfile(player)
	end

	task.spawn(function()
		while true do
			if #Players:GetPlayers() < Config.minPlayers then
				setState(Constants.RoundState.Waiting, 0, nil)
				currentProgress = taskService:getProgressSnapshot()
				task.wait(2)
				continue
			end

			startIntermissionTimer(Config.intermissionSeconds)
			if #Players:GetPlayers() < Config.minPlayers then
				continue
			end
			if not startRound() then
				continue
			end

			while roundSession ~= nil and not roundSession.resolving do
				local now = os.clock()
				currentTimerSeconds = math.max(0, math.ceil(roundSession.roundEndsAt - now))
				currentProgress = taskService:getProgressSnapshot()
				broadcastState()
				taskService:update(now)
				eventService:update(
					now,
					math.max(0, roundSession.roundEndsAt - now),
					taskService:getRemainingRealTasks()
				)
				if now >= roundSession.roundEndsAt then
					finishRound(false)
					break
				end
				task.wait(Constants.Round.TickSeconds)
			end

			if roundSession ~= nil then
				currentProgress = taskService:getProgressSnapshot()
				broadcastState()
				task.wait(Constants.Round.ResultsSeconds)
			end
			endRoundCleanup()
			setState(Constants.RoundState.Waiting, 0, nil)
		end
	end)
end

return ShiftService
