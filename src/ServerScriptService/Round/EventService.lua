local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local EventService = {}
EventService.__index = EventService

function EventService.new(taskService, callbacks)
	local self = setmetatable({}, EventService)
	self.taskService = taskService
	self.sendAlert = callbacks.sendAlert
	self.onBlackoutSeen = callbacks.onBlackoutSeen
	self.onMimicSpawned = callbacks.onMimicSpawned
	self.onMimicTriggered = callbacks.onMimicTriggered
	self.onMimicExpired = callbacks.onMimicExpired
	self.onSecurityAlarmSeen = callbacks.onSecurityAlarmSeen
	self.onSecurityAlarmReset = callbacks.onSecurityAlarmReset
	self.onSecurityAlarmFailed = callbacks.onSecurityAlarmFailed
	self.onTimerPenalty = callbacks.onTimerPenalty
	self.round = nil
	return self
end

local function rollBetween(minimum, maximum)
	return Random.new():NextInteger(minimum, maximum)
end

function EventService:startRound()
	self.round = {
		blackoutTriggerRemaining = rollBetween(
			Constants.Events.Blackout.MinRemainingSeconds,
			Constants.Events.Blackout.MaxRemainingSeconds
		),
		blackoutPending = false,
		blackoutActive = false,
		blackoutEndsAt = 0,
		blackoutConsumed = false,
		mimicTriggerRemaining = rollBetween(
			Constants.Events.Mimic.MinRemainingSeconds,
			Constants.Events.Mimic.MaxRemainingSeconds
		),
		mimicPending = false,
		mimicConsumed = false,
		securityAlarmTriggerRemaining = rollBetween(
			Constants.Events.SecurityAlarm.MinRemainingSeconds,
			Constants.Events.SecurityAlarm.MaxRemainingSeconds
		),
		securityAlarmPending = false,
		securityAlarmActive = false,
		securityAlarmEndsAt = 0,
		securityAlarmStartedAt = 0,
		securityAlarmConsumed = false,
		securityAlarmState = "idle",
		securityAlarmResolvedByUserId = nil,
	}
end

function EventService:isSecurityAlarmActive()
	return self.round ~= nil and self.round.securityAlarmActive == true
end

function EventService:handleSecurityAlarmTriggered(player, now)
	if self.round == nil or not self.round.securityAlarmActive then
		return false
	end
	if now > self.round.securityAlarmEndsAt then
		return false
	end

	self.round.securityAlarmActive = false
	self.round.securityAlarmConsumed = true
	self.round.securityAlarmState = "resolved"
	self.round.securityAlarmResolvedByUserId = player.UserId
	self.taskService:setSecurityAlarmState("resolved", now)
	self.sendAlert("security_alarm_reset")
	if self.onSecurityAlarmReset ~= nil then
		self.onSecurityAlarmReset(
			player,
			Constants.Events.SecurityAlarm.NodeId,
			math.max(0, self.round.securityAlarmEndsAt - now),
			now - self.round.securityAlarmStartedAt
		)
	end
	return true
end

function EventService:_failSecurityAlarm(now)
	if self.round == nil or not self.round.securityAlarmActive then
		return
	end

	self.round.securityAlarmActive = false
	self.round.securityAlarmConsumed = true
	self.round.securityAlarmState = "failed"
	self.taskService:setSecurityAlarmState("failed", now)
	self.sendAlert("security_alarm_failed")
	if self.onTimerPenalty ~= nil then
		self.onTimerPenalty(Constants.Events.SecurityAlarm.TimerPenaltySeconds)
	end
	if self.onSecurityAlarmFailed ~= nil then
		self.onSecurityAlarmFailed(
			Constants.Events.SecurityAlarm.NodeId,
			Constants.Events.SecurityAlarm.TimerPenaltySeconds
		)
	end
end

function EventService:_canStartSecurityAlarm(realTasksRemaining)
	if self.round == nil then
		return false
	end

	return not self.round.securityAlarmConsumed
		and not self.round.securityAlarmActive
		and not self.taskService:isBlackoutActive()
		and not self.taskService:hasActiveMimic()
		and not self.taskService:isRegisterUnlocked()
		and not self.taskService:isRegisterCompleted()
		and realTasksRemaining > 0
end

function EventService:_startSecurityAlarm(now, remainingSeconds)
	self.round.securityAlarmPending = false
	self.round.securityAlarmActive = true
	self.round.securityAlarmEndsAt = now + Constants.Events.SecurityAlarm.ResponseWindowSeconds
	self.round.securityAlarmStartedAt = now
	self.round.securityAlarmState = "active"
	self.taskService:setSecurityAlarmState("active", now)
	self.sendAlert("security_alarm_active")
	if self.onSecurityAlarmSeen ~= nil then
		self.onSecurityAlarmSeen(
			Constants.Events.SecurityAlarm.NodeId,
			remainingSeconds,
			Constants.Events.SecurityAlarm.ResponseWindowSeconds
		)
	end
end

function EventService:update(now, remainingSeconds, realTasksRemaining)
	if self.round == nil then
		return
	end

	if self.round.securityAlarmActive and now >= self.round.securityAlarmEndsAt then
		self:_failSecurityAlarm(now)
	end

	if
		not self.round.blackoutConsumed
		and remainingSeconds <= self.round.blackoutTriggerRemaining
	then
		self.round.blackoutPending = true
	end

	if self.round.blackoutPending and not self.round.blackoutActive then
		if not self.taskService:isSecurityAlarmActive() and remainingSeconds > 0 then
			self.round.blackoutPending = false
			self.round.blackoutConsumed = true
			self.round.blackoutActive = true
			self.round.blackoutEndsAt = now + Constants.Events.Blackout.DurationSeconds
			self.taskService:setBlackoutActive(true, now)
			self.sendAlert("blackout_active")
			if self.onBlackoutSeen ~= nil then
				self.onBlackoutSeen(remainingSeconds)
			end
		end
	end

	if self.round.blackoutActive and now >= self.round.blackoutEndsAt then
		self.round.blackoutActive = false
		self.taskService:setBlackoutActive(false, now)
		self.sendAlert("blackout_end")
	end

	if not self.round.mimicConsumed and remainingSeconds <= self.round.mimicTriggerRemaining then
		self.round.mimicPending = true
	end

	if self.round.mimicPending then
		if remainingSeconds < Constants.Events.SecurityAlarm.CancelAtRemainingSeconds then
			self.round.mimicPending = false
			self.round.mimicConsumed = true
		elseif
			not self.taskService:isBlackoutActive()
			and not self.taskService:isSecurityAlarmActive()
			and realTasksRemaining >= Constants.Events.Mimic.MinRealTasksRemaining
		then
			local nodeId = self.taskService:activateMimic(now)
			if nodeId ~= nil then
				self.round.mimicPending = false
				self.round.mimicConsumed = true
				if self.onMimicSpawned ~= nil then
					self.onMimicSpawned(nodeId, remainingSeconds)
				end
			end
		end
	end

	if
		not self.round.securityAlarmConsumed
		and remainingSeconds <= self.round.securityAlarmTriggerRemaining
	then
		self.round.securityAlarmPending = true
	end

	if self.round.securityAlarmPending then
		if
			remainingSeconds < Constants.Events.SecurityAlarm.CancelAtRemainingSeconds
			or self.taskService:isRegisterCompleted()
			or realTasksRemaining <= 0
		then
			self.round.securityAlarmPending = false
			self.round.securityAlarmConsumed = true
			self.round.securityAlarmState = "canceled"
			self.taskService:setSecurityAlarmState("idle", now)
		elseif self:_canStartSecurityAlarm(realTasksRemaining) then
			self:_startSecurityAlarm(now, remainingSeconds)
		end
	end
end

function EventService:handleMimicTriggered(player, nodeId)
	if self.round == nil then
		return
	end
	self.round.mimicPending = false
	self.round.mimicConsumed = true
	if self.onTimerPenalty ~= nil then
		self.onTimerPenalty(Constants.Events.Mimic.TimerPenaltySeconds)
	end
	if self.onMimicTriggered ~= nil then
		self.onMimicTriggered(player, nodeId)
	end
end

function EventService:handleMimicExpired(nodeId)
	if self.round == nil then
		return
	end
	self.round.mimicPending = false
	self.round.mimicConsumed = true
	if self.onMimicExpired ~= nil then
		self.onMimicExpired(nodeId)
	end
end

function EventService:endRound()
	if self.round ~= nil and self.round.blackoutActive then
		self.taskService:setBlackoutActive(false, os.clock())
	end
	if self.round ~= nil and self.round.securityAlarmActive then
		self.taskService:setSecurityAlarmState("idle", os.clock())
	end
	self.round = nil
end

return EventService
