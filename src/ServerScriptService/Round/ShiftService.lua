local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")

local RoundFolder = script.Parent
local Config = require(RoundFolder:WaitForChild("Config"))
local EventService = require(RoundFolder:WaitForChild("EventService"))
local RoundResultsService = require(RoundFolder:WaitForChild("RoundResultsService"))
local TaskService = require(RoundFolder:WaitForChild("TaskService"))

local ProfileStore = require(ServerScriptService:WaitForChild("Data"):WaitForChild("ProfileStore"))

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))
local UIStrings = require(Shared:WaitForChild("UIStrings"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RoundStateChanged = Remotes:WaitForChild("RoundStateChanged")
local TaskProgressChanged = Remotes:WaitForChild("TaskProgressChanged")
local AlertRaised = Remotes:WaitForChild("AlertRaised")

local ShiftService = {}
ShiftService.__index = ShiftService

local singleton = nil

local function cloneArray(source)
	local copy = table.create(#source)
	for index, value in ipairs(source) do
		copy[index] = value
	end
	return copy
end

local function buildActiveUserIds(players)
	local activeUserIds = table.create(#players)
	for _, player in ipairs(players) do
		table.insert(activeUserIds, player.UserId)
	end
	return activeUserIds
end

local function cloneAlertPayload(alertIdOrPayload)
	if typeof(alertIdOrPayload) == "table" then
		return table.clone(alertIdOrPayload)
	end

	if typeof(alertIdOrPayload) == "string" then
		if UIStrings.Alerts[alertIdOrPayload] ~= nil then
			return table.clone(UIStrings.Alerts[alertIdOrPayload])
		end
		if alertIdOrPayload == Constants.Alerts.MidRoundJoin then
			return table.clone(UIStrings.Alerts.late_join_wait)
		end
		return {
			id = alertIdOrPayload,
			message = alertIdOrPayload,
			priority = UIStrings.AlertPriority.Prompt,
			duration = 3,
			pinned = false,
		}
	end

	return {
		id = "unknown_alert",
		message = tostring(alertIdOrPayload),
		priority = UIStrings.AlertPriority.Prompt,
		duration = 3,
		pinned = false,
	}
end

local function isNetworkPlayer(player)
	return typeof(player) == "Instance" and player:IsA("Player") and player.Parent ~= nil
end

function ShiftService.new(options)
	options = options or {}

	local self = setmetatable({}, ShiftService)
	self.playersService = options.playersService or Players
	self.getPlayers = options.getPlayers
	self.profileStore = options.profileStore or ProfileStore
	self.roundStateChanged = options.roundStateChanged
	if self.roundStateChanged == nil and options.networkEnabled ~= false then
		self.roundStateChanged = RoundStateChanged
	end
	self.taskProgressChanged = options.taskProgressChanged
	if self.taskProgressChanged == nil and options.networkEnabled ~= false then
		self.taskProgressChanged = TaskProgressChanged
	end
	self.alertRaised = options.alertRaised
	if self.alertRaised == nil and options.networkEnabled ~= false then
		self.alertRaised = AlertRaised
	end
	self.networkEnabled = options.networkEnabled ~= false
	self.onStateChanged = options.onStateChanged
	self.onProgressChanged = options.onProgressChanged
	self.onAlertRaised = options.onAlertRaised
	self.intermissionSeconds = options.intermissionSeconds or Config.intermissionSeconds
	self.durationSeconds = options.durationSeconds or Config.durationSeconds
	self.minPlayers = options.minPlayers or Config.minPlayers
	self.endDelaySeconds = options.endDelaySeconds or Config.endDelaySeconds
	self.heartbeatSeconds = options.heartbeatSeconds or Config.heartbeatSeconds
	self.stopAfterRound = options.stopAfterRound == true
	self.started = false
	self.running = false
	self.currentState = Constants.RoundState.Waiting
	self.currentTimerSeconds = 0
	self.currentProgress = nil
	self.currentRoundResult = nil
	self.activePlayers = {}
	self.activeUserIds = {}
	self.lastRoundResultsByUserId = {}
	self.shareTelemetryStateByUserId = {}
	self.round = nil
	self.taskService = options.taskService
	self.eventService = options.eventService
	self.roundResultsService = options.roundResultsService
		or RoundResultsService.new({
			profileStore = self.profileStore,
		})
	self:_ensureServices()
	return self
end

function ShiftService:_ensureServices()
	if self.taskService ~= nil and self.eventService ~= nil then
		return
	end

	if self.taskService == nil then
		self.taskService = TaskService.new({
			sendAlert = function(alertIdOrPayload, targetPlayer)
				self:sendAlert(alertIdOrPayload, targetPlayer)
			end,
			onRoundSuccess = function(player)
				self:_markRoundSuccess(player)
			end,
			onProgressChanged = function(progress)
				self:_handleProgressChanged(progress)
			end,
			onTaskCompleted = function()
				self:_broadcastState()
			end,
			onMimicTriggered = function(player, nodeId)
				if self.eventService ~= nil then
					self.eventService:handleMimicTriggered(player, nodeId)
				end
			end,
			onMimicExpired = function(nodeId)
				if self.eventService ~= nil then
					self.eventService:handleMimicExpired(nodeId)
				end
			end,
			onSecurityAlarmTriggered = function(player, now)
				if self.eventService == nil then
					return false
				end
				return self.eventService:handleSecurityAlarmTriggered(player, now)
			end,
		})
	end

	if self.eventService == nil then
		self.eventService = EventService.new(self.taskService, {
			sendAlert = function(alertIdOrPayload)
				self:sendAlert(alertIdOrPayload)
			end,
			onBlackoutSeen = function() end,
			onMimicSpawned = function() end,
			onMimicTriggered = function() end,
			onMimicExpired = function() end,
			onSecurityAlarmSeen = function() end,
			onSecurityAlarmReset = function() end,
			onSecurityAlarmFailed = function() end,
			onTimerPenalty = function(seconds)
				self:_applyTimerPenalty(seconds)
			end,
		})
	end
end

function ShiftService:_getPlayers()
	if self.getPlayers ~= nil then
		return self.getPlayers()
	end

	if self.playersService == nil then
		return {}
	end

	return self.playersService:GetPlayers()
end

function ShiftService:_getEligiblePlayers()
	local eligiblePlayers = {}
	for _, player in ipairs(self:_getPlayers()) do
		if player ~= nil and player.Parent ~= nil then
			table.insert(eligiblePlayers, player)
		end
	end
	return eligiblePlayers
end

function ShiftService:_emitState(payload)
	if self.onStateChanged ~= nil then
		self.onStateChanged(payload)
	end
	if self.networkEnabled and self.roundStateChanged ~= nil then
		self.roundStateChanged:FireAllClients(payload)
	end
end

function ShiftService:_emitProgress(progress)
	if self.onProgressChanged ~= nil then
		self.onProgressChanged(progress)
	end
	if self.networkEnabled and self.taskProgressChanged ~= nil then
		self.taskProgressChanged:FireAllClients(progress)
	end
end

function ShiftService:_emitAlert(payload, targetPlayer)
	if self.onAlertRaised ~= nil then
		self.onAlertRaised(payload, targetPlayer)
	end

	if not self.networkEnabled or self.alertRaised == nil then
		return
	end

	if targetPlayer ~= nil then
		if isNetworkPlayer(targetPlayer) then
			self.alertRaised:FireClient(targetPlayer, payload)
		end
		return
	end

	local sentToActivePlayers = false
	for _, player in ipairs(self.activePlayers) do
		if isNetworkPlayer(player) then
			self.alertRaised:FireClient(player, payload)
			sentToActivePlayers = true
		end
	end

	if not sentToActivePlayers then
		self.alertRaised:FireAllClients(payload)
	end
end

function ShiftService:_buildStatePayload()
	return {
		state = self.currentState,
		timerSeconds = self.currentTimerSeconds,
		roundResult = self.currentRoundResult,
		activeUserIds = cloneArray(self.activeUserIds),
		progress = self.currentProgress,
	}
end

function ShiftService:_broadcastState()
	self:_emitState(self:_buildStatePayload())
end

function ShiftService:_handleProgressChanged(progress)
	self.currentProgress = progress
	self:_emitProgress(progress)
	if
		self.currentState == Constants.RoundState.Playing
		or self.currentState == Constants.RoundState.Ended
	then
		self:_broadcastState()
	end
end

function ShiftService:_setWaitingState()
	self.currentState = Constants.RoundState.Waiting
	self.currentTimerSeconds = 0
	self.currentRoundResult = nil
	self.currentProgress = nil
	self.activePlayers = {}
	self.activeUserIds = {}
	self:_broadcastState()
end

function ShiftService:_setIntermissionTimer(timerSeconds)
	self.currentState = Constants.RoundState.Intermission
	self.currentTimerSeconds = timerSeconds
	self.currentRoundResult = nil
	self.currentProgress = nil
	self.activePlayers = {}
	self.activeUserIds = {}
	self:_broadcastState()
end

function ShiftService:_setPlayingState(activePlayers)
	self.activePlayers = cloneArray(activePlayers)
	self.activeUserIds = buildActiveUserIds(activePlayers)
	self.currentState = Constants.RoundState.Playing
	self.currentTimerSeconds = self.durationSeconds
	self.currentRoundResult = nil
end

function ShiftService:_setEndedState(roundResult)
	self.currentState = Constants.RoundState.Ended
	self.currentTimerSeconds = 0
	self.currentRoundResult = roundResult
	self.currentProgress = self.taskService:getProgressSnapshot()
	self:_broadcastState()
end

function ShiftService:sendAlert(alertIdOrPayload, targetPlayer)
	self:_emitAlert(cloneAlertPayload(alertIdOrPayload), targetPlayer)
end

function ShiftService:_markRoundSuccess(player)
	if self.round == nil then
		return
	end
	self.round.success = true
	self.round.successPlayer = player
end

function ShiftService:_applyTimerPenalty(seconds)
	if self.round == nil then
		return
	end

	self.round.endsAt -= seconds
	local remainingSeconds = math.max(0, math.ceil(self.round.endsAt - os.clock()))
	if remainingSeconds ~= self.currentTimerSeconds then
		self.currentTimerSeconds = remainingSeconds
		self:_broadcastState()
	end
end

function ShiftService:_runIntermission()
	local intermissionEndsAt = os.clock() + self.intermissionSeconds
	local lastBroadcastTimer = -1

	while self.running do
		local eligiblePlayers = self:_getEligiblePlayers()
		if #eligiblePlayers < self.minPlayers then
			self:_setWaitingState()
			return false
		end

		local remainingSeconds = math.max(0, math.ceil(intermissionEndsAt - os.clock()))
		if remainingSeconds ~= lastBroadcastTimer then
			lastBroadcastTimer = remainingSeconds
			self:_setIntermissionTimer(remainingSeconds)
		end

		if remainingSeconds <= 0 then
			return true
		end

		task.wait(self.heartbeatSeconds)
	end

	return false
end

function ShiftService:_finishRound(success)
	local roundId = self.round.roundId
	local resultsByUserId = self.roundResultsService:finalizeRound(self.activePlayers, {
		roundId = roundId,
		success = success,
		shiftCash = self.taskService:getBasePay(),
		personalPenalties = self.taskService:getPersonalPenalties(),
		playerTaskCountsByUserId = self.taskService:getPlayerTaskCountsByUserId(),
		securityAlarmResolvedByUserId = self.eventService:getSecurityAlarmResolvedByUserId(),
	})
	self.lastRoundResultsByUserId = resultsByUserId
	self.shareTelemetryStateByUserId = {}
	for userId, resultPayload in pairs(resultsByUserId) do
		if resultPayload.shareCta ~= nil then
			self.shareTelemetryStateByUserId[userId] = {
				roundId = roundId,
				shown = false,
				pressed = false,
				fallbackReasons = {},
			}
		end
	end

	self:_setEndedState(if success then "success" else "failure")
	self:sendAlert(if success then "round_success" else "round_failure")

	if self.endDelaySeconds > 0 then
		task.wait(self.endDelaySeconds)
	end

	self.eventService:endRound()
	self.taskService:endRound()
	self.round = nil

	if self.stopAfterRound then
		self:shutdown()
		return
	end

	self:_setWaitingState()
end

function ShiftService:_runRound()
	local activePlayers = self:_getEligiblePlayers()
	if #activePlayers < self.minPlayers then
		self:_setWaitingState()
		return false
	end

	self:_setPlayingState(activePlayers)
	self.round = {
		roundId = HttpService:GenerateGUID(false),
		endsAt = os.clock() + self.durationSeconds,
		success = false,
		successPlayer = nil,
	}

	self.taskService:startRound(activePlayers, Config.getQuotaTemplate(#activePlayers))
	self.eventService:startRound()
	self.currentProgress = self.taskService:getProgressSnapshot()
	self:_broadcastState()
	self:sendAlert("round_start_hint")

	local lastBroadcastTimer = -1
	while self.running and self.round ~= nil do
		local now = os.clock()
		self.taskService:update(now)
		self.eventService:update(
			now,
			math.max(0, math.ceil(self.round.endsAt - now)),
			self.taskService:getRemainingRealTasks()
		)

		local remainingSeconds = math.max(0, math.ceil(self.round.endsAt - os.clock()))
		if remainingSeconds ~= lastBroadcastTimer then
			lastBroadcastTimer = remainingSeconds
			self.currentTimerSeconds = remainingSeconds
			self:_broadcastState()
		end

		if self.round.success then
			self:_finishRound(true)
			return true
		end
		if remainingSeconds <= 0 then
			self:_finishRound(false)
			return true
		end

		task.wait(self.heartbeatSeconds)
	end

	return false
end

function ShiftService:run()
	if self.started then
		return self
	end

	self.started = true
	self.running = true
	self:_setWaitingState()

	task.spawn(function()
		while self.running do
			local eligiblePlayers = self:_getEligiblePlayers()
			if #eligiblePlayers < self.minPlayers then
				self:_setWaitingState()
				task.wait(1)
			else
				local intermissionFinished = self:_runIntermission()
				if intermissionFinished and self.running then
					self:_runRound()
				end
			end
		end
	end)

	return self
end

function ShiftService:getCurrentState()
	return self.currentState
end

function ShiftService:handleShareAction(player, request)
	if type(request) ~= "table" then
		return false
	end

	local resultPayload = self.lastRoundResultsByUserId[player.UserId]
	local telemetryState = self.shareTelemetryStateByUserId[player.UserId]
	if resultPayload == nil or telemetryState == nil or resultPayload.shareCta == nil then
		return false
	end
	if request.roundId ~= telemetryState.roundId then
		return false
	end

	local softLaunchService = self.roundResultsService.softLaunchService
	if request.action == "cta_shown" then
		if telemetryState.shown then
			return false
		end
		telemetryState.shown = true
		softLaunchService:recordShareCtaShown(
			player,
			resultPayload,
			request.inviteSupported == true
		)
		return true
	end
	if request.action == "cta_pressed" then
		if telemetryState.pressed then
			return false
		end
		telemetryState.pressed = true
		softLaunchService:recordShareCtaPressed(
			player,
			resultPayload,
			request.inviteSupported == true
		)
		return true
	end
	if request.action == "fallback_shown" then
		local fallbackReason = request.fallbackReason
		if
			fallbackReason ~= "platform_unsupported"
			and fallbackReason ~= "policy_blocked"
			and fallbackReason ~= "prompt_error"
		then
			return false
		end
		if telemetryState.fallbackReasons[fallbackReason] == true then
			return false
		end
		telemetryState.fallbackReasons[fallbackReason] = true
		softLaunchService:recordShareCtaFallbackShown(player, resultPayload, fallbackReason)
		return true
	end

	return false
end

function ShiftService:shutdown()
	self.running = false
	self.started = false
	if self.round ~= nil then
		self.eventService:endRound()
		self.taskService:endRound()
		self.round = nil
	end
	self.lastRoundResultsByUserId = {}
	self.shareTelemetryStateByUserId = {}
	self:_setWaitingState()
end

function ShiftService.start(options)
	if singleton == nil then
		singleton = ShiftService.new(options)
	end
	return singleton:run()
end

function ShiftService.stop()
	if singleton ~= nil then
		singleton:shutdown()
	end
end

return ShiftService
