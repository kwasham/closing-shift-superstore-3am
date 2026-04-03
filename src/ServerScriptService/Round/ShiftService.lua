local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RoundFolder = script.Parent
local Config = require(RoundFolder:WaitForChild("Config"))
local TaskService = require(RoundFolder:WaitForChild("TaskService"))
local EventService = require(RoundFolder:WaitForChild("EventService"))
local PayoutService = require(RoundFolder:WaitForChild("PayoutService"))

local DataFolder = RoundFolder.Parent:WaitForChild("Data")
local ProfileStore = require(DataFolder:WaitForChild("ProfileStore"))

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local ShiftService = {}

local started = false
local currentState = Constants.RoundState.Waiting
local currentTimerSeconds = 0
local currentProgress = nil
local activeUserIds = {}
local activeRound = nil

local remotes = ReplicatedStorage:FindFirstChild("Remotes")
if remotes == nil then
	remotes = Instance.new("Folder")
	remotes.Name = "Remotes"
	remotes.Parent = ReplicatedStorage
end

local function getOrCreateRemoteEvent(name)
	local remote = remotes:FindFirstChild(name)
	if remote == nil then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = remotes
	end

	return remote
end

local RoundStateChanged = getOrCreateRemoteEvent("RoundStateChanged")
local TaskProgressChanged = getOrCreateRemoteEvent("TaskProgressChanged")
local AlertRaised = getOrCreateRemoteEvent("AlertRaised")

local function buildActiveUserIds(players)
	local userIds = {}
	for _, player in ipairs(players) do
		table.insert(userIds, player.UserId)
	end
	return userIds
end

local function buildRoundSnapshot()
	return {
		state = currentState,
		timerSeconds = currentTimerSeconds,
		progress = currentProgress,
		activeUserIds = activeUserIds,
	}
end

local function broadcastState(targetPlayer)
	local payload = buildRoundSnapshot()
	if targetPlayer ~= nil then
		RoundStateChanged:FireClient(targetPlayer, payload)
	else
		RoundStateChanged:FireAllClients(payload)
	end
end

local function broadcastProgress()
	if currentProgress ~= nil then
		TaskProgressChanged:FireAllClients(currentProgress)
	end
end

local function alert(message, targetPlayer)
	if targetPlayer ~= nil then
		AlertRaised:FireClient(targetPlayer, message)
	else
		AlertRaised:FireAllClients(message)
	end
end

local taskService = TaskService.new({
	sendAlert = alert,
	onProgressChanged = function(progress)
		currentProgress = progress
		broadcastProgress()
		broadcastState()
	end,
	onRoundSuccess = function()
		if activeRound ~= nil then
			activeRound.success = true
			activeRound.shouldEnd = true
		end
	end,
	onMimicTriggered = function()
		if activeRound ~= nil then
			activeRound.endsAt -= Constants.Events.Mimic.TimePenaltySeconds
			alert(Constants.Alerts.MimicTriggered)
			broadcastState()
		end
	end,
})

local eventService = EventService.new(taskService, {
	sendAlert = alert,
	onMimicTriggered = function()
		taskService:update(os.clock())
		if activeRound ~= nil then
			activeRound.endsAt -= Constants.Events.Mimic.TimePenaltySeconds
			alert(Constants.Alerts.MimicTriggered)
			broadcastState()
		end
	end,
})

local function setState(nextState, timerSeconds, players)
	currentState = nextState
	currentTimerSeconds = timerSeconds or 0
	activeUserIds = if players ~= nil then buildActiveUserIds(players) else {}
	broadcastState()
end

local function refreshTimer(secondsRemaining)
	if currentTimerSeconds ~= secondsRemaining then
		currentTimerSeconds = secondsRemaining
		broadcastState()
	end
end

local function updateProgressSnapshot()
	currentProgress = taskService:getProgressSnapshot()
	broadcastProgress()
	broadcastState()
end

local function beginRound(roundPlayers)
	local quotas = Config.getQuotaTemplate(#roundPlayers)
	activeRound = {
		players = roundPlayers,
		endsAt = os.clock() + Config.durationSeconds,
		shouldEnd = false,
		success = false,
	}

	taskService:startRound(roundPlayers, quotas)
	eventService:startRound()
	currentProgress = taskService:getProgressSnapshot()
	setState(Constants.RoundState.Playing, Config.durationSeconds, roundPlayers)
	broadcastProgress()
	alert(Constants.Alerts.RoundStart)

	while activeRound ~= nil and not activeRound.shouldEnd do
		local now = os.clock()
		taskService:update(now)
		local remainingSeconds = math.max(0, math.ceil(activeRound.endsAt - now))
		refreshTimer(remainingSeconds)
		eventService:update(now, remainingSeconds, taskService:getRemainingRealTasks())
		if remainingSeconds <= 0 then
			break
		end
		task.wait(0.2)
	end

	local success = activeRound ~= nil and activeRound.success == true
	local roundPlayersSnapshot = if activeRound ~= nil then activeRound.players else roundPlayers
	local basePay = taskService:getBasePay()
	local penalties = taskService:getPersonalPenalties()

	updateProgressSnapshot()
	setState(Constants.RoundState.Ended, 0, roundPlayersSnapshot)
	alert(if success then Constants.Alerts.Success else Constants.Alerts.Failure)
	task.wait(Config.endedSeconds)

	PayoutService.awardPlayers(roundPlayersSnapshot, basePay, success, penalties, ProfileStore)
	taskService:endRound()
	eventService:endRound()
	currentProgress = nil
	activeRound = nil
end

local function runIntermissionLoop()
	setState(Constants.RoundState.Intermission, Config.intermissionSeconds)
	alert(Constants.Alerts.Intermission)
	local intermissionEndsAt = os.clock() + Config.intermissionSeconds

	while true do
		local playerCount = #Players:GetPlayers()
		if playerCount < Config.minPlayers then
			setState(Constants.RoundState.Waiting, 0)
			return false
		end

		local secondsRemaining = math.max(0, math.ceil(intermissionEndsAt - os.clock()))
		refreshTimer(secondsRemaining)
		if secondsRemaining <= 0 then
			return true
		end
		task.wait(0.2)
	end
end

local function onPlayerAdded(player)
	ProfileStore.getLeaderstats(player)
	task.defer(function()
		broadcastState(player)
		if currentProgress ~= nil then
			TaskProgressChanged:FireClient(player, currentProgress)
		end
		if currentState == Constants.RoundState.Playing then
			alert(Constants.Alerts.MidRoundJoin, player)
		end
	end)
end

function ShiftService.start()
	if started then
		return
	end
	started = true

	Players.PlayerAdded:Connect(onPlayerAdded)
	for _, player in ipairs(Players:GetPlayers()) do
		onPlayerAdded(player)
	end

	setState(Constants.RoundState.Waiting, 0)

	task.spawn(function()
		while true do
			if #Players:GetPlayers() < Config.minPlayers then
				if currentState ~= Constants.RoundState.Waiting then
					setState(Constants.RoundState.Waiting, 0)
				end
				task.wait(0.5)
				continue
			end

			local shouldStartRound = runIntermissionLoop()
			if not shouldStartRound then
				continue
			end

			local roundPlayers = Players:GetPlayers()
			if #roundPlayers < Config.minPlayers then
				setState(Constants.RoundState.Waiting, 0)
				continue
			end

			beginRound(roundPlayers)
			setState(Constants.RoundState.Waiting, 0)
			task.wait(0.5)
		end
	end)
end

return ShiftService
