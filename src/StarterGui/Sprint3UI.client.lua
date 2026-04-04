local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Constants = require(Shared:WaitForChild("Constants"))

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local roundStateChanged = remotes:WaitForChild("RoundStateChanged")
local profileChanged = remotes:WaitForChild("ProfileChanged")
local shopAction = remotes:WaitForChild("ShopAction")

local existingGui = playerGui:FindFirstChild("Sprint3Meta")
if existingGui ~= nil then
	existingGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "Sprint3Meta"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 30
gui.Parent = playerGui

local root = Instance.new("ScrollingFrame")
root.Name = "Root"
root.Size = UDim2.fromOffset(340, 490)
root.Position = UDim2.new(1, -356, 0, 20)
root.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
root.BackgroundTransparency = 0.08
root.BorderSizePixel = 0
root.CanvasSize = UDim2.fromOffset(0, 0)
root.AutomaticCanvasSize = Enum.AutomaticSize.Y
root.ScrollBarThickness = 6
root.ScrollingDirection = Enum.ScrollingDirection.Y
root.Parent = gui

local rootCorner = Instance.new("UICorner")
rootCorner.CornerRadius = UDim.new(0, 14)
rootCorner.Parent = root

local rootStroke = Instance.new("UIStroke")
rootStroke.Transparency = 0.72
rootStroke.Color = Color3.fromRGB(255, 255, 255)
rootStroke.Parent = root

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 12)
padding.PaddingBottom = UDim.new(0, 12)
padding.PaddingLeft = UDim.new(0, 12)
padding.PaddingRight = UDim.new(0, 12)
padding.Parent = root

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.Padding = UDim.new(0, 8)
layout.Parent = root

local function makeLabel(parent, name, textSize, bold)
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Size = UDim2.fromScale(1, 0)
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.BackgroundTransparency = 1
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.Font = if bold then Enum.Font.GothamBold else Enum.Font.GothamMedium
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = textSize
	label.Parent = parent
	return label
end

local function makeFrame(parent, name, height)
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.Size = UDim2.new(1, 0, 0, height)
	frame.BackgroundColor3 = Color3.fromRGB(24, 27, 37)
	frame.BackgroundTransparency = 0.08
	frame.BorderSizePixel = 0
	frame.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Transparency = 0.82
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Parent = frame

	return frame
end

local title = makeLabel(root, "Title", 18, true)
local subtitle = makeLabel(root, "Subtitle", 12, false)
local profileSummary = makeLabel(root, "ProfileSummary", 13, false)

local previewCard = makeFrame(root, "PreviewCard", 112)
local previewTitle = makeLabel(previewCard, "PreviewTitle", 14, true)
previewTitle.Position = UDim2.fromOffset(12, 10)
previewTitle.Size = UDim2.new(1, -24, 0, 0)
local previewHint = makeLabel(previewCard, "PreviewHint", 12, false)
previewHint.Position = UDim2.fromOffset(12, 32)
previewHint.Size = UDim2.new(1, -24, 0, 0)

local previewHolder = Instance.new("Frame")
previewHolder.Name = "PreviewHolder"
previewHolder.Size = UDim2.new(1, -24, 0, 54)
previewHolder.Position = UDim2.fromOffset(12, 48)
previewHolder.BackgroundTransparency = 1
previewHolder.Parent = previewCard

local lanyardBar = Instance.new("Frame")
lanyardBar.Name = "LanyardBar"
lanyardBar.Size = UDim2.fromOffset(36, 50)
lanyardBar.Position = UDim2.fromOffset(16, 0)
lanyardBar.BorderSizePixel = 0
lanyardBar.Parent = previewHolder
local lanyardCorner = Instance.new("UICorner")
lanyardCorner.CornerRadius = UDim.new(0, 12)
lanyardCorner.Parent = lanyardBar

local nameplate = Instance.new("Frame")
nameplate.Name = "Nameplate"
nameplate.Size = UDim2.fromOffset(220, 44)
nameplate.Position = UDim2.fromOffset(68, 3)
nameplate.BorderSizePixel = 0
nameplate.Parent = previewHolder
local nameplateCorner = Instance.new("UICorner")
nameplateCorner.CornerRadius = UDim.new(0, 12)
nameplateCorner.Parent = nameplate
local nameplateStroke = Instance.new("UIStroke")
nameplateStroke.Parent = nameplate
nameplateStroke.Thickness = 3

local previewText = makeLabel(nameplate, "PreviewText", 15, true)
previewText.Position = UDim2.fromOffset(12, 8)
previewText.Size = UDim2.new(1, -24, 0, 0)
local previewSubtext = makeLabel(nameplate, "PreviewSubtext", 12, false)
previewSubtext.Position = UDim2.fromOffset(12, 24)
previewSubtext.Size = UDim2.new(1, -24, 0, 0)

local controlsRow = Instance.new("Frame")
controlsRow.Name = "ControlsRow"
controlsRow.Size = UDim2.new(1, 0, 0, 36)
controlsRow.BackgroundTransparency = 1
controlsRow.Parent = root

local controlsLayout = Instance.new("UIListLayout")
controlsLayout.FillDirection = Enum.FillDirection.Horizontal
controlsLayout.Padding = UDim.new(0, 8)
controlsLayout.Parent = controlsRow

local shopToggle = Instance.new("TextButton")
shopToggle.Name = "ShopToggle"
shopToggle.Size = UDim2.fromOffset(132, 36)
shopToggle.AutoButtonColor = true
shopToggle.Text = "Open Shop"
shopToggle.TextSize = 14
shopToggle.Font = Enum.Font.GothamBold
shopToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
shopToggle.BackgroundColor3 = Color3.fromRGB(70, 98, 166)
shopToggle.BorderSizePixel = 0
shopToggle.Parent = controlsRow
local shopCorner = Instance.new("UICorner")
shopCorner.CornerRadius = UDim.new(0, 12)
shopCorner.Parent = shopToggle

local dismissResults = Instance.new("TextButton")
dismissResults.Name = "DismissResults"
dismissResults.Size = UDim2.fromOffset(132, 36)
dismissResults.AutoButtonColor = true
dismissResults.Text = "Hide Results"
dismissResults.TextSize = 14
dismissResults.Font = Enum.Font.GothamBold
dismissResults.TextColor3 = Color3.fromRGB(255, 255, 255)
dismissResults.BackgroundColor3 = Color3.fromRGB(86, 86, 96)
dismissResults.BorderSizePixel = 0
dismissResults.Parent = controlsRow
local dismissCorner = Instance.new("UICorner")
dismissCorner.CornerRadius = UDim.new(0, 12)
dismissCorner.Parent = dismissResults

local statusLabel = makeLabel(root, "StatusLabel", 12, false)

local resultsCard = makeFrame(root, "ResultsCard", 118)
resultsCard.Size = UDim2.fromScale(1, 0)
resultsCard.AutomaticSize = Enum.AutomaticSize.Y
local resultsTitle = makeLabel(resultsCard, "ResultsTitle", 14, true)
resultsTitle.Position = UDim2.fromOffset(12, 10)
resultsTitle.Size = UDim2.new(1, -24, 0, 0)
local resultsBody = makeLabel(resultsCard, "ResultsBody", 12, false)
resultsBody.Position = UDim2.fromOffset(12, 34)
resultsBody.Size = UDim2.new(1, -24, 0, 0)

local shopFrame = makeFrame(root, "ShopFrame", 174)
local shopHeader = makeLabel(shopFrame, "ShopHeader", 14, true)
shopHeader.Position = UDim2.fromOffset(12, 10)
shopHeader.Size = UDim2.new(1, -24, 0, 0)
local shopHint = makeLabel(shopFrame, "ShopHint", 12, false)
shopHint.Position = UDim2.fromOffset(12, 34)
shopHint.Size = UDim2.new(1, -24, 0, 0)

local shopList = Instance.new("ScrollingFrame")
shopList.Name = "ShopList"
shopList.Position = UDim2.fromOffset(12, 58)
shopList.Size = UDim2.new(1, -24, 1, -70)
shopList.BackgroundTransparency = 1
shopList.BorderSizePixel = 0
shopList.ScrollBarThickness = 6
shopList.CanvasSize = UDim2.fromOffset(0, 0)
shopList.Parent = shopFrame

local shopListLayout = Instance.new("UIListLayout")
shopListLayout.Padding = UDim.new(0, 8)
shopListLayout.Parent = shopList
shopListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	shopList.CanvasSize = UDim2.fromOffset(0, shopListLayout.AbsoluteContentSize.Y + 8)
end)

local currentRoundState = Constants.RoundState.Waiting
local currentProfile = nil
local lastRoundResult = nil
local shopVisible = false
local itemCards = {}

local function isShopAvailable()
	return currentRoundState ~= Constants.RoundState.Playing
end

local function getCurrentLevel()
	return if currentProfile ~= nil then currentProfile.level or 1 else 1
end

local function getCurrentCash()
	return if currentProfile ~= nil then currentProfile.cash or 0 else 0
end

local function getXPProgressText()
	local xp = if currentProfile ~= nil then currentProfile.xp or 0 else 0
	local level = getCurrentLevel()
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

local function getEquippedPreview()
	local equipped = if currentProfile ~= nil then currentProfile.equippedCosmetics or {} else {}
	local nameplateItem =
		Constants.Cosmetics.Catalog[equipped.NameplateStyle or Constants.Cosmetics.DefaultEquipped.NameplateStyle]
	local lanyardItem =
		Constants.Cosmetics.Catalog[equipped.LanyardColor or Constants.Cosmetics.DefaultEquipped.LanyardColor]
	return nameplateItem, lanyardItem
end

local function updatePreview()
	local nameplateItem, lanyardItem = getEquippedPreview()
	local platePreview = nameplateItem.preview
	local lanyardPreview = lanyardItem.preview

	nameplate.BackgroundColor3 = platePreview.nameplateFill
	nameplateStroke.Color = platePreview.nameplateBorder
	lanyardBar.BackgroundColor3 = lanyardPreview.lanyardColor
	previewText.TextColor3 = Color3.fromRGB(18, 20, 28)
	previewText.Text = nameplateItem.displayName
	previewSubtext.TextColor3 = Color3.fromRGB(42, 48, 62)
	previewSubtext.Text = lanyardItem.displayName
end

local function getActionText(item)
	local ownedCosmetics = if currentProfile ~= nil then currentProfile.ownedCosmetics or {} else {}
	local equippedCosmetics = if currentProfile ~= nil
		then currentProfile.equippedCosmetics or {}
		else {}
	if equippedCosmetics[item.slot] == item.itemId then
		return "Equipped"
	end
	if ownedCosmetics[item.itemId] == true or item.defaultOwned == true then
		return "Owned — Equip"
	end
	return string.format("Buy for $%d", item.priceCash)
end

local function updateItemCard(itemId)
	local card = itemCards[itemId]
	if card == nil then
		return
	end

	local item = Constants.Cosmetics.Catalog[itemId]
	local ownedCosmetics = if currentProfile ~= nil then currentProfile.ownedCosmetics or {} else {}
	local equippedCosmetics = if currentProfile ~= nil
		then currentProfile.equippedCosmetics or {}
		else {}
	local playerLevel = getCurrentLevel()
	local levelLocked = not item.defaultOwned
		and playerLevel < item.requiredLevel
		and ownedCosmetics[item.itemId] ~= true

	card.title.Text = string.format("%s • %s", item.displayName, item.slot)
	card.body.Text = item.flavorCopy
	if item.defaultOwned == true then
		card.meta.Text = "Default item"
	elseif levelLocked then
		card.meta.Text = string.format("Requires Level %d", item.requiredLevel)
	else
		card.meta.Text =
			string.format("$%d • Requires Level %d", item.priceCash, item.requiredLevel)
	end
	card.action.Text = getActionText(item)
	card.action.Active = isShopAvailable()
	card.action.AutoButtonColor = isShopAvailable()
	card.action.BackgroundColor3 = if equippedCosmetics[item.slot] == item.itemId
		then Color3.fromRGB(76, 142, 96)
		else Color3.fromRGB(73, 91, 139)
end

local function updateShopCards()
	for _, itemId in ipairs(Constants.Cosmetics.CatalogOrder) do
		updateItemCard(itemId)
	end
end

local function updateShopVisibility()
	shopFrame.Visible = shopVisible and isShopAvailable()
	shopToggle.Text = if shopFrame.Visible then "Close Shop" else "Open Shop"
	shopToggle.BackgroundColor3 = if isShopAvailable()
		then Color3.fromRGB(70, 98, 166)
		else Color3.fromRGB(72, 72, 80)
	shopToggle.Active = isShopAvailable()
	shopToggle.AutoButtonColor = isShopAvailable()
end

local function updateResults()
	resultsCard.Visible = lastRoundResult ~= nil
	if lastRoundResult == nil then
		return
	end

	resultsTitle.Text = if lastRoundResult.outcome == "success"
		then "Results — Shift Cleared"
		else "Results — Shift Failed"
	resultsBody.Text = table.concat({
		string.format("Saved Cash added: +$%d", lastRoundResult.cashEarned or 0),
		string.format("XP earned: +%d", lastRoundResult.xpEarned or 0),
		string.format("Current Level: %d", lastRoundResult.levelAfter or getCurrentLevel()),
		string.format(
			"Totals — Saved Cash $%d • XP %d",
			lastRoundResult.cashTotal or getCurrentCash(),
			lastRoundResult.xpTotal or 0
		),
	}, "\n")
end

local function updateHeader()
	title.Text = "Employee Rank"
	subtitle.Text =
		"Saved Cash buys cosmetics. XP raises Employee Rank. Rank unlocks cosmetics only."
	profileSummary.Text = string.format(
		"Saved Cash $%d • Level %d • %s",
		getCurrentCash(),
		getCurrentLevel(),
		getXPProgressText()
	)
	previewTitle.Text = "Current cosmetics"
	previewHint.Text =
		"Lobby and results preview use the same equipped NameplateStyle and LanyardColor."
	shopHeader.Text = "Lobby Shop"
	shopHint.Text = if isShopAvailable()
		then "Primary action order: equip owned items, otherwise buy if Rank and Cash allow it."
		else "Shop unavailable during Playing."
	statusLabel.Text = if currentRoundState == Constants.RoundState.Playing
		then "Shop locked during shift. Saved Cash and Rank stay visible here for QA."
		else "Open the shop in lobby/results. Purchase does not auto-equip."
	updatePreview()
	updateResults()
	updateShopCards()
	updateShopVisibility()
end

local function createItemCard(itemId)
	local item = Constants.Cosmetics.Catalog[itemId]
	local card = Instance.new("Frame")
	card.Name = itemId
	card.Size = UDim2.new(1, -4, 0, 116)
	card.BackgroundColor3 = Color3.fromRGB(30, 34, 44)
	card.BorderSizePixel = 0
	card.Parent = shopList
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = card

	local swatch = Instance.new("Frame")
	swatch.Name = "Swatch"
	swatch.Size = UDim2.fromOffset(36, 60)
	swatch.Position = UDim2.fromOffset(12, 18)
	swatch.BorderSizePixel = 0
	swatch.BackgroundColor3 = if item.slot == Constants.CosmeticSlots.NameplateStyle
		then item.preview.nameplateFill
		else item.preview.lanyardColor
	swatch.Parent = card
	local swatchCorner = Instance.new("UICorner")
	swatchCorner.CornerRadius = UDim.new(0, 10)
	swatchCorner.Parent = swatch
	local swatchStroke = Instance.new("UIStroke")
	swatchStroke.Color = item.preview.nameplateBorder
	swatchStroke.Parent = swatch

	local titleLabel = makeLabel(card, "Title", 13, true)
	titleLabel.Position = UDim2.fromOffset(58, 10)
	titleLabel.Size = UDim2.new(1, -166, 0, 0)

	local bodyLabel = makeLabel(card, "Body", 11, false)
	bodyLabel.Position = UDim2.fromOffset(58, 42)
	bodyLabel.Size = UDim2.new(1, -166, 0, 0)
	bodyLabel.TextColor3 = Color3.fromRGB(214, 218, 230)

	local metaLabel = makeLabel(card, "Meta", 11, false)
	metaLabel.Position = UDim2.fromOffset(58, 82)
	metaLabel.Size = UDim2.new(1, -166, 0, 0)
	metaLabel.TextColor3 = Color3.fromRGB(171, 183, 214)

	local actionButton = Instance.new("TextButton")
	actionButton.Name = "Action"
	actionButton.Size = UDim2.fromOffset(96, 36)
	actionButton.Position = UDim2.new(1, -108, 0, 40)
	actionButton.BorderSizePixel = 0
	actionButton.TextSize = 12
	actionButton.TextWrapped = true
	actionButton.Font = Enum.Font.GothamBold
	actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	actionButton.Parent = card
	local actionCorner = Instance.new("UICorner")
	actionCorner.CornerRadius = UDim.new(0, 12)
	actionCorner.Parent = actionButton

	actionButton.MouseButton1Click:Connect(function()
		if not isShopAvailable() then
			statusLabel.Text = "Shop unavailable during Playing."
			updateHeader()
			return
		end
		local response = shopAction:InvokeServer({
			action = "primary",
			itemId = itemId,
		})
		if response ~= nil and response.profile ~= nil then
			currentProfile = response.profile
		end
		if response ~= nil and response.message ~= nil then
			statusLabel.Text = tostring(response.message)
		end
		updateHeader()
	end)

	itemCards[itemId] = {
		frame = card,
		title = titleLabel,
		body = bodyLabel,
		meta = metaLabel,
		action = actionButton,
	}
	updateItemCard(itemId)
end

for _, itemId in ipairs(Constants.Cosmetics.CatalogOrder) do
	createItemCard(itemId)
end

shopToggle.MouseButton1Click:Connect(function()
	if not isShopAvailable() then
		statusLabel.Text = "Shop unavailable during Playing."
		updateHeader()
		return
	end

	if not shopVisible then
		local response = shopAction:InvokeServer({
			action = "open",
			entryPoint = if lastRoundResult ~= nil then "results" else "lobby",
		})
		if response ~= nil and response.profile ~= nil then
			currentProfile = response.profile
		end
	end
	shopVisible = not shopVisible
	updateHeader()
end)

dismissResults.MouseButton1Click:Connect(function()
	lastRoundResult = nil
	updateHeader()
end)

profileChanged.OnClientEvent:Connect(function(payload)
	if typeof(payload) ~= "table" then
		return
	end
	currentProfile = payload
	if payload.lastRoundResult ~= nil then
		lastRoundResult = payload.lastRoundResult
	end
	updateHeader()
end)

roundStateChanged.OnClientEvent:Connect(function(payload)
	if typeof(payload) ~= "table" then
		return
	end
	currentRoundState = payload.state or currentRoundState
	if currentRoundState == Constants.RoundState.Playing then
		shopVisible = false
	end
	updateHeader()
end)

local ok, response = pcall(function()
	return shopAction:InvokeServer({ action = "sync" })
end)
if ok and response ~= nil and response.profile ~= nil then
	currentProfile = response.profile
end

updateHeader()
