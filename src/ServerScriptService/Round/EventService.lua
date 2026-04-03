local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local EventService = {}
EventService.__index = EventService

function EventService.new(taskService, callbacks)
	local self = setmetatable({}, EventService)
	self.taskService = taskService
	self.sendAlert = callbacks.sendAlert
	self.onMimicTriggered = callbacks.onMimicTriggered
	self.round = nil
	return self
end

function EventService:startRound()
	self.round = {
		blackoutTriggerRemaining = Random.new():NextInteger(
			Constants.Events.Blackout.MinRemainingSeconds,
			Constants.Events.Blackout.MaxRemainingSeconds
		),
		blackoutActive = false,
		blackoutEndsAt = 0,
		blackoutConsumed = false,
		mimicTriggerRemaining = Random.new():NextInteger(
			Constants.Events.Mimic.MinRemainingSeconds,
			Constants.Events.Mimic.MaxRemainingSeconds
		),
		mimicPending = false,
		mimicConsumed = false,
	}
end

function EventService:update(now, remainingSeconds, realTasksRemaining)
	if self.round == nil then
		return
	end

	if
		not self.round.blackoutConsumed
		and remainingSeconds <= self.round.blackoutTriggerRemaining
	then
		self.round.blackoutConsumed = true
		self.round.blackoutActive = true
		self.round.blackoutEndsAt = now + Constants.Events.Blackout.DurationSeconds
		self.taskService:setBlackoutActive(true, now)
		self.sendAlert(Constants.Alerts.BlackoutStart)
	end

	if self.round.blackoutActive and now >= self.round.blackoutEndsAt then
		self.round.blackoutActive = false
		self.taskService:setBlackoutActive(false, now)
		self.sendAlert(Constants.Alerts.BlackoutEnd)
	end

	if not self.round.mimicConsumed then
		if remainingSeconds <= self.round.mimicTriggerRemaining then
			self.round.mimicPending = true
		end

		if self.round.mimicPending then
			if remainingSeconds < Constants.Events.Mimic.MinRemainingSeconds then
				self.round.mimicPending = false
				self.round.mimicConsumed = true
			elseif
				not self.round.blackoutActive
				and realTasksRemaining >= Constants.Events.Mimic.MinRealTasksRemaining
			then
				local spawned = self.taskService:activateMimic(now)
				if spawned then
					self.round.mimicPending = false
					self.round.mimicConsumed = true
				end
			end
		end
	end
end

function EventService:handleMimicTriggered(player)
	if self.round == nil then
		return
	end

	self.round.mimicPending = false
	self.round.mimicConsumed = true
	self.onMimicTriggered(player)
end

function EventService:endRound()
	self.round = nil
end

return EventService
