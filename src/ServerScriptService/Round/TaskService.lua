local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local Config = require(script.Parent:WaitForChild("Config"))
local TaskRegistry = require(script.Parent:WaitForChild("TaskRegistry"))
local PayoutService = require(script.Parent:WaitForChild("PayoutService"))

local TaskService = {}
TaskService.__index = TaskService

local function shallowCopy(source)
	return table.clone(source)
end

local function clearDictionary(dictionary)
	for key in pairs(dictionary) do
		dictionary[key] = nil
	end
end

local function createBillboard(part: BasePart)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "TaskBillboard"
	billboard.AlwaysOnTop = true
	billboard.Size = UDim2.fromOffset(220, 64)
	billboard.StudsOffsetWorldSpace = Vector3.new(0, 4.5, 0)
	billboard.Parent = part

	local frame = Instance.new("Frame")
	frame.Name = "Frame"
	frame.BackgroundTransparency = 0.18
	frame.BackgroundColor3 = Color3.fromRGB(17, 19, 26)
	frame.BorderSizePixel = 0
	frame.Size = UDim2.fromScale(1, 1)
	frame.Parent = billboard

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Transparency = 0.7
	stroke.Parent = frame

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.BackgroundTransparency = 1
	label.Size = UDim2.fromScale(1, 1)
	label.Position = UDim2.fromScale(0.5, 0.5)
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Font = Enum.Font.GothamMedium
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 16
	label.TextWrapped = true
	label.Text = ""
	label.Parent = frame

	return label
end

local function createNodePart(nodeDefinition, taskConfig)
	local part = Instance.new("Part")
	part.Name = nodeDefinition.nodeId
	part.Anchored = true
	part.CanCollide = true
	part.Size = nodeDefinition.size
	part.Position = nodeDefinition.position
	part.Material = Enum.Material.SmoothPlastic
	part.Color = nodeDefinition.color
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part:SetAttribute("TaskId", nodeDefinition.taskId)
	part:SetAttribute("NodeId", nodeDefinition.nodeId)

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "Prompt"
	prompt.ActionText = taskConfig.promptText
	prompt.ObjectText = taskConfig.name
	prompt.HoldDuration = taskConfig.holdDuration
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.RequiresLineOfSight = false
	prompt.MaxActivationDistance = 12
	prompt.Parent = part

	return part, prompt
end

function TaskService.new(options)
	local self = setmetatable({}, TaskService)
	self.sendAlert = options.sendAlert
	self.onRoundSuccess = options.onRoundSuccess
	self.onProgressChanged = options.onProgressChanged
	self.onMimicTriggered = options.onMimicTriggered
	self.taskFolder = nil
	self.floor = nil
	self.spawn = nil
	self.nodes = {}
	self.nodesById = {}
	self.nodesByTaskId = {}
	self.round = nil
	self:_ensureArena()
	self:_ensureNodes()
	return self
end

function TaskService:_ensureArena()
	local arena = TaskRegistry.Arena

	self.floor = Workspace:FindFirstChild(arena.floorName)
	if self.floor == nil then
		local floor = Instance.new("Part")
		floor.Name = arena.floorName
		floor.Anchored = true
		floor.Size = arena.floorSize
		floor.Position = arena.floorPosition
		floor.Material = Enum.Material.Concrete
		floor.Color = Color3.fromRGB(64, 64, 72)
		floor.TopSurface = Enum.SurfaceType.Smooth
		floor.BottomSurface = Enum.SurfaceType.Smooth
		floor.Parent = Workspace
		self.floor = floor
	end

	self.spawn = Workspace:FindFirstChild(arena.spawnName)
	if self.spawn == nil then
		local spawn = Instance.new("SpawnLocation")
		spawn.Name = arena.spawnName
		spawn.Anchored = true
		spawn.Neutral = true
		spawn.Size = Vector3.new(6, 1, 6)
		spawn.Position = arena.spawnPosition
		spawn.Material = Enum.Material.Metal
		spawn.Color = Color3.fromRGB(109, 158, 235)
		spawn.Parent = Workspace
		self.spawn = spawn
	end

	self.taskFolder = Workspace:FindFirstChild("TaskNodes")
	if self.taskFolder == nil then
		local folder = Instance.new("Folder")
		folder.Name = "TaskNodes"
		folder.Parent = Workspace
		self.taskFolder = folder
	end
end

function TaskService:_ensureNodes()
	for _, nodeDefinition in ipairs(TaskRegistry.Nodes) do
		local taskConfig = Constants.Tasks[nodeDefinition.taskId]
		local part = self.taskFolder:FindFirstChild(nodeDefinition.nodeId)
		local prompt
		if part == nil or not part:IsA("BasePart") then
			part, prompt = createNodePart(nodeDefinition, taskConfig)
			part.Parent = self.taskFolder
		else
			prompt = part:FindFirstChild("Prompt")
			if prompt == nil or not prompt:IsA("ProximityPrompt") then
				prompt = Instance.new("ProximityPrompt")
				prompt.Name = "Prompt"
				prompt.Parent = part
			end
			prompt.ActionText = taskConfig.promptText
			prompt.ObjectText = taskConfig.name
			prompt.HoldDuration = taskConfig.holdDuration
			prompt.RequiresLineOfSight = false
			prompt.MaxActivationDistance = 12
			prompt.KeyboardKeyCode = Enum.KeyCode.E
		end

		local billboard = part:FindFirstChild("TaskBillboard")
		local label = nil
		if billboard ~= nil and billboard:IsA("BillboardGui") then
			local frame = billboard:FindFirstChild("Frame")
			if frame ~= nil then
				label = frame:FindFirstChild("Label")
			end
		end
		if label == nil or not label:IsA("TextLabel") then
			if billboard ~= nil then
				billboard:Destroy()
			end
			label = createBillboard(part)
		end

		local node = self.nodesById[nodeDefinition.nodeId]
		if node == nil then
			node = {
				nodeId = nodeDefinition.nodeId,
				taskId = nodeDefinition.taskId,
				part = part,
				prompt = prompt,
				label = label,
				baseColor = nodeDefinition.color,
				cooldownUntil = 0,
				lockoutUntil = 0,
				isMimic = false,
				mimicExpiresAt = 0,
				mimicTriggered = false,
				holders = {},
				allowedDuringBlackout = {},
				blockedDuringBlackout = {},
			}
			self.nodesById[node.nodeId] = node
			table.insert(self.nodes, node)
			self.nodesByTaskId[node.taskId] = node
			self:_connectPromptSignals(node)
		else
			node.part = part
			node.prompt = prompt
			node.label = label
		end

		self:_applyNodeVisual(node, Constants.Prompts.Waiting, false)
	end
end

function TaskService:_connectPromptSignals(node)
	node.prompt.PromptButtonHoldBegan:Connect(function(player)
		node.holders[player] = true
		if self.round ~= nil and self.round.blackoutActive then
			if node.allowedDuringBlackout[player.UserId] ~= true then
				node.blockedDuringBlackout[player.UserId] = true
			end
		end
	end)

	node.prompt.PromptButtonHoldEnded:Connect(function(player)
		node.holders[player] = nil
		node.blockedDuringBlackout[player.UserId] = nil
		node.allowedDuringBlackout[player.UserId] = nil
	end)

	node.prompt.Triggered:Connect(function(player)
		self:_handlePromptTriggered(node, player)
		node.holders[player] = nil
		node.blockedDuringBlackout[player.UserId] = nil
		node.allowedDuringBlackout[player.UserId] = nil
	end)
end

function TaskService:_applyNodeVisual(node, text, promptEnabled)
	local taskConfig = Constants.Tasks[node.taskId]
	node.label.Text = text
	node.prompt.Enabled = promptEnabled
	node.prompt.ActionText = text
	node.prompt.ObjectText = taskConfig.name
	node.prompt.HoldDuration = taskConfig.holdDuration

	if promptEnabled then
		node.part.Color = node.baseColor
	else
		node.part.Color = node.baseColor:Lerp(Color3.fromRGB(36, 38, 44), 0.35)
	end
end

function TaskService:_isRoundPlayer(player)
	if self.round == nil then
		return false
	end

	return self.round.activePlayerLookup[player.UserId] == true
end

function TaskService:_nonRegisterTasksComplete()
	if self.round == nil then
		return false
	end

	for _, taskId in ipairs(Config.taskOrder) do
		if
			taskId ~= Constants.TaskId.CloseRegister
			and (self.round.remainingByTask[taskId] or 0) > 0
		then
			return false
		end
	end

	return true
end

function TaskService:_setRegisterUnlocked(unlocked)
	if self.round == nil then
		return
	end

	self.round.registerUnlocked = unlocked
end

function TaskService:_getTaskText(node, now)
	local taskConfig = Constants.Tasks[node.taskId]

	if self.round == nil then
		return Constants.Prompts.Waiting, false
	end

	if self.round.blackoutActive then
		local canCarry = node.allowedDuringBlackout ~= nil
			and next(node.allowedDuringBlackout) ~= nil
		return Constants.Prompts.Blackout, canCarry
	end

	if node.lockoutUntil > now then
		return Constants.Prompts.NodeLocked, false
	end

	if node.cooldownUntil > now then
		return Constants.Prompts.Cooldown, false
	end

	if node.taskId == Constants.TaskId.CloseRegister then
		if self.round.registerCompleted then
			return Constants.Prompts.Completed, false
		end

		if not self.round.registerUnlocked then
			return taskConfig.lockedPromptText or Constants.Prompts.RegisterLocked, false
		end

		return taskConfig.promptText, true
	end

	if (self.round.remainingByTask[node.taskId] or 0) <= 0 then
		return Constants.Prompts.Completed, false
	end

	return taskConfig.promptText, true
end

function TaskService:_broadcastProgress()
	if self.onProgressChanged ~= nil and self.round ~= nil then
		self.onProgressChanged(self:getProgressSnapshot())
	end
end

function TaskService:_refreshAllNodes(now)
	for _, node in ipairs(self.nodes) do
		local text, promptEnabled = self:_getTaskText(node, now)
		self:_applyNodeVisual(node, text, promptEnabled)
	end
end

function TaskService:_completeRealTask(node, player, now)
	local taskConfig = Constants.Tasks[node.taskId]
	self.round.remainingByTask[node.taskId] =
		math.max(0, (self.round.remainingByTask[node.taskId] or 0) - 1)
	self.round.totalCompleted += 1
	self.round.basePay += taskConfig.reward

	if
		node.taskId ~= Constants.TaskId.CloseRegister
		and self.round.remainingByTask[node.taskId] > 0
	then
		node.cooldownUntil = now + taskConfig.reuseCooldown
	end

	if self:_nonRegisterTasksComplete() then
		self:_setRegisterUnlocked(true)
		if self.round.registerAnnounced ~= true then
			self.round.registerAnnounced = true
			self.sendAlert(Constants.Alerts.RegisterUnlocked)
		end
	end

	if node.taskId == Constants.TaskId.CloseRegister then
		self.round.registerCompleted = true
		if self.onRoundSuccess ~= nil then
			self.onRoundSuccess(player)
		end
	end
end

function TaskService:_resolveMimic(node, player, now)
	node.isMimic = false
	node.mimicExpiresAt = 0
	node.mimicTriggered = true
	node.lockoutUntil = now + Constants.Events.Mimic.NodeLockSeconds
	self.round.personalPenalties[player.UserId] = (self.round.personalPenalties[player.UserId] or 0)
		+ Constants.Events.Mimic.CashPenalty

	if self.onMimicTriggered ~= nil then
		self.onMimicTriggered(player)
	end
end

function TaskService:_handlePromptTriggered(node, player)
	if self.round == nil then
		return
	end

	if not self:_isRoundPlayer(player) then
		self.sendAlert(Constants.Alerts.MidRoundJoin, player)
		return
	end

	local now = os.clock()
	if self.round.blackoutActive and node.allowedDuringBlackout[player.UserId] ~= true then
		self.sendAlert(Constants.Prompts.Blackout, player)
		return
	end

	if node.lockoutUntil > now or node.cooldownUntil > now then
		return
	end

	if node.blockedDuringBlackout[player.UserId] == true then
		self.sendAlert(Constants.Prompts.Blackout, player)
		return
	end

	if node.taskId == Constants.TaskId.CloseRegister and not self.round.registerUnlocked then
		self.sendAlert(Constants.Prompts.RegisterLocked, player)
		return
	end

	if node.isMimic then
		self:_resolveMimic(node, player, now)
		self:_refreshAllNodes(now)
		self:_broadcastProgress()
		return
	end

	if (self.round.remainingByTask[node.taskId] or 0) <= 0 then
		return
	end

	self:_completeRealTask(node, player, now)
	self:_refreshAllNodes(now)
	self:_broadcastProgress()
end

function TaskService:startRound(activePlayers, quotas)
	local activePlayerLookup = {}
	for _, player in ipairs(activePlayers) do
		activePlayerLookup[player.UserId] = true
	end

	self.round = {
		activePlayers = activePlayers,
		activePlayerLookup = activePlayerLookup,
		remainingByTask = shallowCopy(quotas),
		totalRequired = Config.getTotalRequired(quotas),
		totalCompleted = 0,
		basePay = 0,
		personalPenalties = {},
		registerUnlocked = false,
		registerCompleted = false,
		registerAnnounced = false,
		blackoutActive = false,
	}

	for _, node in ipairs(self.nodes) do
		node.cooldownUntil = 0
		node.lockoutUntil = 0
		node.isMimic = false
		node.mimicExpiresAt = 0
		node.mimicTriggered = false
		clearDictionary(node.holders)
		clearDictionary(node.allowedDuringBlackout)
		clearDictionary(node.blockedDuringBlackout)
	end

	self:_refreshAllNodes(os.clock())
	self:_broadcastProgress()
end

function TaskService:setBlackoutActive(active, now)
	if self.round == nil then
		return
	end

	self.round.blackoutActive = active

	for _, node in ipairs(self.nodes) do
		clearDictionary(node.allowedDuringBlackout)
		clearDictionary(node.blockedDuringBlackout)
		if active then
			for player in pairs(node.holders) do
				node.allowedDuringBlackout[player.UserId] = true
			end
		end
	end

	self:_refreshAllNodes(now)
end

function TaskService:getRemainingRealTasks()
	if self.round == nil then
		return 0
	end

	local remaining = 0
	for _, taskId in ipairs(Config.taskOrder) do
		if taskId ~= Constants.TaskId.CloseRegister then
			remaining += self.round.remainingByTask[taskId] or 0
		end
	end

	return remaining
end

function TaskService:activateMimic(now)
	if self.round == nil then
		return false
	end

	local eligibleNodes = {}
	for _, node in ipairs(self.nodes) do
		if
			node.taskId ~= Constants.TaskId.CloseRegister
			and (self.round.remainingByTask[node.taskId] or 0) > 0
			and node.lockoutUntil <= now
			and node.cooldownUntil <= now
			and not node.isMimic
			and next(node.holders) == nil
		then
			table.insert(eligibleNodes, node)
		end
	end

	if #eligibleNodes == 0 then
		return false
	end

	local selectedNode = eligibleNodes[Random.new():NextInteger(1, #eligibleNodes)]
	selectedNode.isMimic = true
	selectedNode.mimicExpiresAt = now + Constants.Events.Mimic.LifetimeSeconds
	self:_refreshAllNodes(now)
	return true
end

function TaskService:update(now)
	if self.round == nil then
		return
	end

	local shouldRefresh = false
	for _, node in ipairs(self.nodes) do
		if node.isMimic and node.mimicExpiresAt > 0 and now >= node.mimicExpiresAt then
			node.isMimic = false
			node.mimicExpiresAt = 0
			shouldRefresh = true
		end
		if node.cooldownUntil > 0 and now >= node.cooldownUntil then
			node.cooldownUntil = 0
			shouldRefresh = true
		end
		if node.lockoutUntil > 0 and now >= node.lockoutUntil then
			node.lockoutUntil = 0
			shouldRefresh = true
		end
	end

	if shouldRefresh then
		self:_refreshAllNodes(now)
	end
end

function TaskService:getPersonalPenalties()
	if self.round == nil then
		return {}
	end

	return shallowCopy(self.round.personalPenalties)
end

function TaskService:getBasePay()
	if self.round == nil then
		return 0
	end

	return self.round.basePay
end

function TaskService:getProgressSnapshot()
	if self.round == nil then
		return {
			totalRequired = 0,
			completed = 0,
			remainingByTask = {},
			bankedPay = 0,
			projectedSuccessPay = 0,
			projectedFailPay = 0,
			registerUnlocked = false,
			registerCompleted = false,
			personalPenalties = {},
		}
	end

	local successPenalty = 0
	local failPenalty = 0
	for _, penalty in pairs(self.round.personalPenalties) do
		successPenalty = math.max(successPenalty, penalty)
		failPenalty = math.max(failPenalty, penalty)
	end

	return {
		totalRequired = self.round.totalRequired,
		completed = self.round.totalCompleted,
		remainingByTask = shallowCopy(self.round.remainingByTask),
		bankedPay = self.round.basePay,
		projectedSuccessPay = PayoutService.calculatePlayerPayout(
			self.round.basePay,
			true,
			successPenalty
		),
		projectedFailPay = PayoutService.calculatePlayerPayout(
			self.round.basePay,
			false,
			failPenalty
		),
		registerUnlocked = self.round.registerUnlocked,
		registerCompleted = self.round.registerCompleted,
		personalPenalties = shallowCopy(self.round.personalPenalties),
		blackoutActive = self.round.blackoutActive,
	}
end

function TaskService:endRound()
	self.round = nil
	for _, node in ipairs(self.nodes) do
		node.cooldownUntil = 0
		node.lockoutUntil = 0
		node.isMimic = false
		node.mimicExpiresAt = 0
		clearDictionary(node.holders)
		clearDictionary(node.allowedDuringBlackout)
		clearDictionary(node.blockedDuringBlackout)
		self:_applyNodeVisual(node, Constants.Prompts.Waiting, false)
	end
end

return TaskService
