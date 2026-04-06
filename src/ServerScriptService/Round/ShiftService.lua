local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))
local UIStrings = require(Shared:WaitForChild("UIStrings"))

local Config = require(script.Parent:WaitForChild("Config"))
local ProfileStore = require(script.Parent.Parent:WaitForChild("Data"):WaitForChild("ProfileStore"))
local EventService = require(script.Parent:WaitForChild("EventService"))
local RoundResultsService = require(script.Parent:WaitForChild("RoundResultsService"))
local ShopService = require(script.Parent:WaitForChild("ShopService"))
local TaskService = require(script.Parent:WaitForChild("TaskService"))

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local roundStateChanged = remotes:WaitForChild("RoundStateChanged")
local taskProgressChanged = remotes:WaitForChild("TaskProgressChanged")
local alertRaised = remotes:WaitForChild("AlertRaised")
local shopAction = remotes:WaitForChild("ShopAction")
local roundEndShareAction = remotes:WaitForChild("RoundEndShareAction")

local ShiftService = {}
ShiftService.__index = ShiftService

local singleton = nil

local function shallowCopy(source)
	return table.clone(source or {})
end

local function isNetworkPlayer(player)
	return typeof(player) == "Instance" and player:IsA("Player")
end

local function fireAlertToPlayer(player, payload)
	if not isNetworkPlayer(player) then
		return
	end
	alertRaised:FireClient(player, payload)
end

local function resolveAlertPayload(payload)
	if typeof(payload) == "string" and UIStrings.Alerts[payload] ~= nil then
		return UIStrings.Alerts[payload]
	end
	return payload
end

local function listActiveUserIds(players)
	local userIds = {}
	for _, player in ipairs(players) do
		table.insert(userIds, player.UserId)
	end
	return userIds
end

function ShiftService.new(options)
	local self = setmetatable({}, ShiftService)
	self.networkEnabled = options.networkEnabled ~= false
	self.getPlayers = options.getPlayers or function()
		return Players:GetPlayers()
	end
	self.profileStore = options.profileStore or ProfileStore
	self.roundResultsService = options.roundResultsService
		or RoundResultsService.new({
			profileStore = self.profileStore,
		})
	self.shopService = options.shopService or ShopService.new(self.profileStore)
	self.intermissionSeconds = options.intermissionSeconds or Config.intermissionSeconds
	self.durationSeconds = options.durationSeconds or Config.durationSeconds
	self.endDelaySeconds = options.endDelaySeconds or Config.endDelaySeconds
	self.heartbeatSeconds = options.heartbeatSeconds or Config.heartbeatSeconds
	self.onStateChanged = options.onStateChanged
	self.running = false
	self.loopToken = 0
	self.currentRoundId = nil
	self.roundSequence = 0
	self.state = Constants.RoundState.Waiting
	self.timerSeconds = 0
	self.roundResult = nil
	self.activePlayers = {}
	self.lastRoundResultsByUserId = {}
	self.shareTelemetryStateByUserId = {}
	self.progressSnapshot = {
		totalRequired = 0,
		completed = 0,
		remainingByTask = {},
		bankedPay = 0,
		projectedSuccessPay = 0,
		projectedFailPay = 0,
		registerUnlocked = false,
		registerCompleted = false,
		personalPenalties = {},
		blackoutActive = false,
		securityAlarmActive = false,
		securityAlarmState = "idle",
	}

	self.taskService = options.taskService
		or TaskService.new({
			sendAlert = function(payload, targetPlayer)
				self:sendAlert(payload, targetPlayer)
			end,
			onRoundSuccess = function(player)
				self:finishRound(true, player)
			end,
			onProgressChanged = function(progress)
				self.progressSnapshot = progress
				self:broadcastProgress()
				self:broadcastState()
			end,
			onTaskCompleted = function() end,
			onMimicTriggered = function(player, nodeId)
				if self.eventService ~= nil then
					self.eventService:handleMimicTriggered(player, nodeId)
				end
				self:sendAlert("mimic_triggered")
			end,
			onMimicExpired = function(nodeId)
				if self.eventService ~= nil then
					self.eventService:handleMimicExpired(nodeId)
				end
			end,
			onSecurityAlarmTriggered = function(player, now)
				if self.eventService ~= nil then
					return self.eventService:handleSecurityAlarmTriggered(player, now)
				end
				return false
			end,
		})

	self.eventService = options.eventService
		or EventService.new(self.taskService, {
			sendAlert = function(payload)
				self:sendAlert(payload)
			end,
			onBlackoutSeen = function() end,
			onMimicSpawned = function() end,
			onMimicTriggered = function() end,
			onMimicExpired = function() end,
			onSecurityAlarmSeen = function() end,
			onSecurityAlarmReset = function() end,
			onSecurityAlarmFailed = function() end,
			onTimerPenalty = function(seconds)
				self:applyTimerPenalty(seconds)
			end,
		})

	if self.networkEnabled then
		self:_bindNetwork()
	end

	return self
end

function ShiftService:_bindNetwork()
	shopAction.OnServerInvoke = function(player, request)
		return self.shopService:handleRequest(player, request, self.state)
	end
	roundEndShareAction.OnServerInvoke = function(player, request)
		return self:handleShareAction(player, request)
	end
end

function ShiftService:_getProgressSnapshot()
	if self.taskService ~= nil and self.taskService.getProgressSnapshot ~= nil then
		return self.taskService:getProgressSnapshot()
	end
	return shallowCopy(self.progressSnapshot)
end

function ShiftService:_makeStatePayload()
	return {
		state = self.state,
		timerSeconds = math.max(0, math.ceil(self.timerSeconds)),
		progress = self:_getProgressSnapshot(),
		activeUserIds = listActiveUserIds(self.activePlayers),
		roundResult = self.roundResult,
	}
end

function ShiftService:broadcastState()
	local payload = self:_makeStatePayload()
	if self.networkEnabled then
		roundStateChanged:FireAllClients(payload)
	end
	if self.onStateChanged ~= nil then
		self.onStateChanged(payload)
	end
end

function ShiftService:broadcastProgress()
	local snapshot = self:_getProgressSnapshot()
	if self.networkEnabled then
		taskProgressChanged:FireAllClients(snapshot)
	end
end

function ShiftService:sendAlert(payload, targetPlayer)
	local resolvedPayload = resolveAlertPayload(payload)
	if self.networkEnabled then
		if targetPlayer ~= nil then
			fireAlertToPlayer(targetPlayer, resolvedPayload)
		else
			alertRaised:FireAllClients(resolvedPayload)
		end
	end
end

function ShiftService:applyTimerPenalty(seconds)
	self.timerSeconds = math.max(0, self.timerSeconds - seconds)
	self:broadcastState()
end

function ShiftService:_setState(nextState, timerSeconds)
	self.state = nextState
	self.timerSeconds = timerSeconds or 0
	if nextState ~= Constants.RoundState.Ended then
		self.roundResult = nil
	end
	self:broadcastState()
end

function ShiftService:_resetRoundRuntime()
	if self.taskService ~= nil and self.taskService.endRound ~= nil then
		self.taskService:endRound()
	end
	if self.eventService ~= nil and self.eventService.endRound ~= nil then
		self.eventService:endRound()
	end
	self.progressSnapshot = self:_getProgressSnapshot()
end

function ShiftService:_getAvailablePlayers()
	local available = {}
	for _, player in ipairs(self.getPlayers()) do
		if player ~= nil and player.Parent ~= nil then
			if isNetworkPlayer(player) then
				self.profileStore.loadProfile(player)
			end
			table.insert(available, player)
		end
	end
	return available
end

function ShiftService:_beginIntermission(players)
	self.activePlayers = players
	self:_setState(Constants.RoundState.Intermission, self.intermissionSeconds)
end

function ShiftService:_startRound(players)
	self.roundSequence += 1
	self.currentRoundId = string.format("round-%03d", self.roundSequence)
	self.activePlayers = players
	self.roundResult = nil
	self.timerSeconds = self.durationSeconds

	local quotas = Config.getTaskQuotas(#players)
	self.taskService:startRound(players, quotas)
	self.eventService:startRound()
	self.progressSnapshot = self:_getProgressSnapshot()
	self.state = Constants.RoundState.Playing
	self:broadcastProgress()
	self:broadcastState()
	self:sendAlert(UIStrings.Alerts.round_start_hint)
end

function ShiftService:_storeRoundResults(resultsByUserId)
	for userId, resultPayload in pairs(resultsByUserId or {}) do
		self.lastRoundResultsByUserId[userId] = table.clone(resultPayload)
		self.shareTelemetryStateByUserId[userId] = {
			roundId = resultPayload.roundId,
			shown = false,
			pressed = false,
			fallbackReasons = {},
		}
	end
end

function ShiftService:finishRound(success, _resolverPlayer)
	if self.state == Constants.RoundState.Ended then
		return
	end

	self.roundResult = if success then "success" else "failure"
	self.state = Constants.RoundState.Ended

	local roundData = {
		roundId = self.currentRoundId or string.format("round-%03d", self.roundSequence + 1),
		success = success,
		shiftCash = if self.taskService.getBasePay ~= nil then self.taskService:getBasePay() else 0,
		personalPenalties = if self.taskService.getPersonalPenalties ~= nil
			then self.taskService:getPersonalPenalties()
			else {},
		playerTaskCountsByUserId = if self.taskService.getPlayerTaskCountsByUserId ~= nil
			then self.taskService:getPlayerTaskCountsByUserId()
			else {},
		securityAlarmResolvedByUserId = if self.eventService.getSecurityAlarmResolvedByUserId
				~= nil
			then self.eventService:getSecurityAlarmResolvedByUserId()
			else nil,
	}

	local resultsByUserId = {}
	if self.roundResultsService ~= nil and self.roundResultsService.finalizeRound ~= nil then
		resultsByUserId = self.roundResultsService:finalizeRound(self.activePlayers, roundData)
	end
	self:_storeRoundResults(resultsByUserId)
	self.progressSnapshot = self:_getProgressSnapshot()
	self:broadcastProgress()
	self:broadcastState()
	self:sendAlert(if success then "round_success" else "round_failure")
end

function ShiftService:handleShareAction(player, request)
	if type(request) ~= "table" then
		return false
	end

	local roundResult = self.lastRoundResultsByUserId[player.UserId]
	if roundResult == nil or roundResult.roundId ~= request.roundId then
		return false
	end

	local telemetry = self.shareTelemetryStateByUserId[player.UserId]
	if telemetry == nil or telemetry.roundId ~= roundResult.roundId then
		telemetry = {
			roundId = roundResult.roundId,
			shown = false,
			pressed = false,
			fallbackReasons = {},
		}
		self.shareTelemetryStateByUserId[player.UserId] = telemetry
	end

	local softLaunchService = if self.roundResultsService ~= nil
		then self.roundResultsService.softLaunchService
		else nil
	if softLaunchService == nil then
		return true
	end

	if request.action == "cta_shown" then
		if telemetry.shown ~= true then
			telemetry.shown = true
			softLaunchService:recordShareCtaShown(player, roundResult, request.inviteSupported)
		end
		return true
	end
	if request.action == "cta_pressed" then
		if telemetry.pressed ~= true then
			telemetry.pressed = true
			softLaunchService:recordShareCtaPressed(player, roundResult, request.inviteSupported)
		end
		return true
	end
	if request.action == "fallback_shown" then
		local fallbackReason = tostring(request.fallbackReason or "unknown")
		if telemetry.fallbackReasons[fallbackReason] ~= true then
			telemetry.fallbackReasons[fallbackReason] = true
			softLaunchService:recordShareCtaFallbackShown(player, roundResult, fallbackReason)
		end
		return true
	end

	return false
end

function ShiftService:run()
	if self.running then
		return
	end

	self.running = true
	self.loopToken += 1
	local token = self.loopToken

	task.spawn(function()
		while self.running and self.loopToken == token do
			local availablePlayers = self:_getAvailablePlayers()
			if #availablePlayers < Config.minPlayers then
				self.activePlayers = {}
				self:_resetRoundRuntime()
				self:_setState(Constants.RoundState.Waiting, 0)
				task.wait(1)
				continue
			end

			self:_beginIntermission(availablePlayers)
			while
				self.running
				and self.loopToken == token
				and self.state == Constants.RoundState.Intermission
				and self.timerSeconds > 0
			do
				task.wait(self.heartbeatSeconds)
				self.timerSeconds = math.max(0, self.timerSeconds - self.heartbeatSeconds)
				self:broadcastState()
			end
			if not self.running or self.loopToken ~= token then
				break
			end

			availablePlayers = self:_getAvailablePlayers()
			if #availablePlayers < Config.minPlayers then
				continue
			end

			self:_startRound(availablePlayers)
			while
				self.running
				and self.loopToken == token
				and self.state == Constants.RoundState.Playing
			do
				task.wait(self.heartbeatSeconds)
				self.timerSeconds = math.max(0, self.timerSeconds - self.heartbeatSeconds)
				local now = os.clock()
				if self.taskService.update ~= nil then
					self.taskService:update(now)
				end
				if self.eventService.update ~= nil then
					self.eventService:update(
						now,
						math.max(0, math.ceil(self.timerSeconds)),
						self.taskService:getRemainingRealTasks()
					)
				end
				self:broadcastState()

				if
					self.taskService.isRegisterCompleted ~= nil
					and self.taskService:isRegisterCompleted()
				then
					self:finishRound(true)
					break
				end
				if self.timerSeconds <= 0 then
					self:finishRound(false)
					break
				end
			end
			if not self.running or self.loopToken ~= token then
				break
			end

			local endDeadline = os.clock() + self.endDelaySeconds
			while self.running and self.loopToken == token and os.clock() < endDeadline do
				task.wait(0.25)
			end
			self:_resetRoundRuntime()
			self.activePlayers = {}
			self.currentRoundId = nil
		end

		self:_resetRoundRuntime()
		self.activePlayers = {}
		self.state = Constants.RoundState.Waiting
		self.timerSeconds = 0
		self.roundResult = nil
		self:broadcastState()
	end)
end

function ShiftService:shutdown()
	self.running = false
	self.loopToken += 1
	self:_resetRoundRuntime()
	self.activePlayers = {}
	self.currentRoundId = nil
	self.state = Constants.RoundState.Waiting
	self.timerSeconds = 0
	self.roundResult = nil
	self:broadcastState()
end

function ShiftService.start()
	if singleton ~= nil then
		singleton:shutdown()
	end
	singleton = ShiftService.new({})
	singleton:run()
	return singleton
end

function ShiftService.stop()
	if singleton ~= nil then
		singleton:shutdown()
		singleton = nil
	end
end

return ShiftService
