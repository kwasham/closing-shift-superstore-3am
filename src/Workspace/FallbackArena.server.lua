local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local StoreRollout = require(Shared:WaitForChild("StoreRollout"))
local StoreSignage = require(Shared:WaitForChild("StoreSignage"))
local VisualTheme = require(Shared:WaitForChild("VisualTheme"))

local FLOOR_NAME = "ShiftArenaFloor"
local SPAWN_NAME = "ShiftSpawn"
local FLOOR_SIZE = Vector3.new(120, 1, 110)
local FLOOR_POSITION = Vector3.new(0, 180, 0)
local SPAWN_POSITION = Vector3.new(0, 184, -30)

local palette = VisualTheme.Palette
local floorTopY = FLOOR_POSITION.Y + (FLOOR_SIZE.Y * 0.5)

local function createZoneFolder(parent, name)
	local zone = Instance.new("Folder")
	zone.Name = name
	zone:SetAttribute("Sprint7Zone", name)
	zone:SetAttribute("RolloutTier", StoreRollout.ZoneTiers[name] or "B")
	zone:SetAttribute("SupportsContentSwap", true)
	zone:SetAttribute("ArtOnly", true)
	zone.Parent = parent
	return zone
end

local function ensureFloor()
	local floor = Workspace:FindFirstChild(FLOOR_NAME)
	if floor ~= nil and floor:IsA("BasePart") then
		floor.Size = FLOOR_SIZE
		floor.Position = FLOOR_POSITION
		floor.Material = Enum.Material.Concrete
		floor.Color = palette.tile_gray
		floor.TopSurface = Enum.SurfaceType.Smooth
		floor.BottomSurface = Enum.SurfaceType.Smooth
		return floor
	end

	floor = Instance.new("Part")
	floor.Name = FLOOR_NAME
	floor.Anchored = true
	floor.Size = FLOOR_SIZE
	floor.Position = FLOOR_POSITION
	floor.Material = Enum.Material.Concrete
	floor.Color = palette.tile_gray
	floor.TopSurface = Enum.SurfaceType.Smooth
	floor.BottomSurface = Enum.SurfaceType.Smooth
	floor.Parent = Workspace
	return floor
end

local function ensureSpawn()
	local spawn = Workspace:FindFirstChild(SPAWN_NAME)
	if spawn ~= nil and spawn:IsA("SpawnLocation") then
		spawn.Anchored = true
		spawn.Neutral = true
		spawn.Size = Vector3.new(6, 1, 6)
		spawn.Position = SPAWN_POSITION
		spawn.Material = Enum.Material.Metal
		spawn.Color = palette.powder_blue
		return spawn
	end

	spawn = Instance.new("SpawnLocation")
	spawn.Name = SPAWN_NAME
	spawn.Anchored = true
	spawn.Neutral = true
	spawn.Size = Vector3.new(6, 1, 6)
	spawn.Position = SPAWN_POSITION
	spawn.Material = Enum.Material.Metal
	spawn.Color = palette.powder_blue
	spawn.Parent = Workspace
	return spawn
end

local function resetSliceFolder()
	local existing = Workspace:FindFirstChild(StoreRollout.RootFolderName)
	if existing ~= nil then
		existing:Destroy()
	end

	local folder = Instance.new("Folder")
	folder.Name = StoreRollout.RootFolderName
	folder:SetAttribute("Sprint7FullStoreRollout", true)
	folder:SetAttribute("SupportsContentSwap", true)
	folder.Parent = Workspace
	return folder
end

local function makePart(parent, name, size, cframe, options)
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.Size = size
	part.CFrame = cframe
	part.Material = options.material or Enum.Material.SmoothPlastic
	part.Color = options.color or palette.tile_gray
	part.Transparency = options.transparency or 0
	part.Reflectance = options.reflectance or 0
	part.CanCollide = options.canCollide == true
	part.CanQuery = options.canQuery == true
	part.CastShadow = options.castShadow ~= false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent
	return part
end

local function makeAnchor(parent, name, cframe, zoneName, hookType)
	local anchor = Instance.new("Part")
	anchor.Name = name
	anchor.Anchored = true
	anchor.CanCollide = false
	anchor.CanQuery = false
	anchor.CanTouch = false
	anchor.Size = Vector3.new(1, 1, 1)
	anchor.Transparency = 1
	anchor.CFrame = cframe
	anchor:SetAttribute("Sprint7Zone", zoneName)
	anchor:SetAttribute("HookType", hookType)
	anchor.Parent = parent
	return anchor
end

local function makeTextSurface(part, face, text, options)
	local surface = Instance.new("SurfaceGui")
	surface.Name = face.Name .. "Surface"
	surface.Face = face
	surface.CanvasSize = options.canvasSize or Vector2.new(512, 256)
	surface.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	surface.PixelsPerStud = options.pixelsPerStud or 48
	surface.AlwaysOnTop = false
	surface.Parent = part

	local label = Instance.new("TextLabel")
	label.Name = "Text"
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Font = options.font or Enum.Font.GothamBold
	label.Text = text
	label.TextColor3 = options.textColor or palette.fluorescent_white
	label.TextScaled = true
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.Parent = surface

	local stroke = Instance.new("UIStroke")
	stroke.Color = options.strokeColor or Color3.fromRGB(0, 0, 0)
	stroke.Thickness = options.strokeThickness or 2
	stroke.Transparency = options.strokeTransparency or 0.45
	stroke.Parent = label

	return surface
end

local function buildRuntimeGroups(parent)
	local groups = {}
	local folder = Instance.new("Folder")
	folder.Name = StoreRollout.RuntimeGroupsFolderName
	folder:SetAttribute("Sprint7RuntimeGroups", true)
	folder.Parent = parent

	for _, groupName in ipairs(StoreRollout.RuntimeGroups) do
		local groupFolder = Instance.new("Folder")
		groupFolder.Name = groupName
		groupFolder.Parent = folder
		groups[groupName] = groupFolder
	end

	return groups
end

local function registerGroup(groups, groupName, instance)
	local groupFolder = groups[groupName]
	if groupFolder == nil then
		return
	end

	local reference = Instance.new("ObjectValue")
	reference.Name = string.format("%s_%d", instance.Name, #groupFolder:GetChildren() + 1)
	reference.Value = instance
	reference.Parent = groupFolder
end

local function markPart(part, zoneName, groupName)
	part:SetAttribute("Sprint7Zone", zoneName)
	if groupName ~= nil then
		part:SetAttribute("RuntimeGroup", groupName)
	end
end

local function makeSign(parent, groups, name, size, cframe, text, options)
	local sign = makePart(parent, name, size, cframe, {
		color = options.backgroundColor,
		material = options.material or Enum.Material.SmoothPlastic,
		transparency = options.transparency,
		canCollide = false,
		castShadow = false,
	})
	makeTextSurface(sign, Enum.NormalId.Front, text, {
		textColor = options.textColor,
		strokeColor = options.strokeColor,
		pixelsPerStud = options.pixelsPerStud,
		canvasSize = options.canvasSize,
	})
	if options.doubleSided == true then
		makeTextSurface(sign, Enum.NormalId.Back, text, {
			textColor = options.textColor,
			strokeColor = options.strokeColor,
			pixelsPerStud = options.pixelsPerStud,
			canvasSize = options.canvasSize,
		})
	end
	markPart(sign, options.zoneName, options.groupName)
	if options.groupName ~= nil then
		registerGroup(groups, options.groupName, sign)
	end
	return sign
end

local function makeShelfBay(parent, groups, origin, aisleInfo, facingBack, zoneName)
	local group = Instance.new("Folder")
	group.Name =
		string.format("ShelfBay_%s_%s", aisleInfo.numeral, facingBack and "Back" or "Front")
	group.Parent = parent

	local rotation = if facingBack then CFrame.Angles(0, math.rad(180), 0) else CFrame.new()
	local base = origin * rotation

	makePart(group, "BackPanel", Vector3.new(8.2, 7.2, 0.45), base * CFrame.new(0, 3.6, 0), {
		color = Color3.fromRGB(88, 95, 108),
		material = Enum.Material.Metal,
		canCollide = false,
	})
	makePart(group, "TopCap", Vector3.new(8.4, 0.3, 1.4), base * CFrame.new(0, 7.1, 0), {
		color = palette.night_blue,
		material = Enum.Material.SmoothPlastic,
		canCollide = false,
	})
	makePart(group, "ShelfBase", Vector3.new(8.4, 0.45, 1.4), base * CFrame.new(0, 0.22, 0), {
		color = Color3.fromRGB(115, 122, 132),
		material = Enum.Material.Metal,
		canCollide = false,
	})

	for _, xOffset in ipairs({ -3.8, 3.8 }) do
		makePart(
			group,
			"Upright",
			Vector3.new(0.28, 7.0, 1.18),
			base * CFrame.new(xOffset, 3.5, 0),
			{
				color = Color3.fromRGB(116, 124, 137),
				material = Enum.Material.Metal,
				canCollide = false,
			}
		)
	end

	for _, yOffset in ipairs({ 1.2, 2.9, 4.6, 6.0 }) do
		makePart(
			group,
			"Shelf",
			Vector3.new(7.8, 0.18, 1.15),
			base * CFrame.new(0, yOffset, 0.24),
			{
				color = Color3.fromRGB(214, 216, 220),
				material = Enum.Material.Metal,
				canCollide = false,
			}
		)
		local strip = makePart(
			group,
			"PriceStrip",
			Vector3.new(7.7, 0.12, 0.08),
			base * CFrame.new(0, yOffset - 0.18, 0.79),
			{
				color = palette.receipt_cream,
				material = Enum.Material.SmoothPlastic,
				canCollide = false,
				castShadow = false,
			}
		)
		markPart(strip, zoneName, "SaleCards")
	end

	local header = makeSign(
		group,
		groups,
		"CategoryHeader",
		Vector3.new(6.4, 1.1, 0.16),
		base * CFrame.new(0, 8.05, 0.72),
		aisleInfo.label,
		{
			backgroundColor = palette.night_blue,
			textColor = palette.fluorescent_white,
			strokeColor = palette.charcoal,
			pixelsPerStud = 34,
			doubleSided = true,
			zoneName = zoneName,
			groupName = "CategoryHeaders",
		}
	)
	header:SetAttribute("SignageFamily", "category_header")

	local productColors = {
		Color3.fromRGB(214, 88, 72),
		Color3.fromRGB(236, 184, 82),
		Color3.fromRGB(87, 147, 215),
		Color3.fromRGB(104, 178, 116),
	}
	for rowIndex, yOffset in ipairs({ 0.68, 2.38, 4.08, 5.58 }) do
		for column = -2, 2 do
			local color = productColors[((column + rowIndex + 1) % #productColors) + 1]
			local width = if column % 2 == 0 then 0.68 else 0.92
			makePart(
				group,
				"Product",
				Vector3.new(width, 0.75, 0.52),
				base * CFrame.new(column * 1.28, yOffset, 0.18),
				{
					color = color,
					material = Enum.Material.SmoothPlastic,
					canCollide = false,
					castShadow = false,
				}
			)
		end
	end

	return group
end

local function makeCheckoutLane(parent, groups, origin, laneInfo, zoneName)
	local group = Instance.new("Folder")
	group.Name = "CheckoutLane" .. laneInfo.numeral
	group.Parent = parent

	makePart(group, "CounterBase", Vector3.new(8.6, 3.2, 3.6), origin * CFrame.new(0, 1.6, 0), {
		color = Color3.fromRGB(82, 78, 76),
		material = Enum.Material.WoodPlanks,
		canCollide = false,
	})
	makePart(group, "CounterTop", Vector3.new(8.8, 0.35, 3.8), origin * CFrame.new(0, 3.35, 0), {
		color = Color3.fromRGB(208, 208, 210),
		material = Enum.Material.Metal,
		canCollide = false,
	})
	makePart(group, "Scanner", Vector3.new(1.0, 0.35, 1.0), origin * CFrame.new(-1.3, 3.65, 0.15), {
		color = palette.safety_red,
		material = Enum.Material.SmoothPlastic,
		canCollide = false,
		castShadow = false,
	})
	makePart(
		group,
		"ReceiptPlate",
		Vector3.new(0.6, 0.08, 1.1),
		origin * CFrame.new(0.45, 3.57, 0.2),
		{
			color = palette.receipt_cream,
			material = Enum.Material.SmoothPlastic,
			canCollide = false,
			castShadow = false,
		}
	)
	makePart(group, "BagWell", Vector3.new(1.7, 1.7, 1.4), origin * CFrame.new(2.55, 2.15, 0.4), {
		color = Color3.fromRGB(143, 151, 164),
		material = Enum.Material.Metal,
		canCollide = false,
	})

	local laneSign = makeSign(
		group,
		groups,
		"LaneSign",
		Vector3.new(3.6, 0.95, 0.16),
		origin * CFrame.new(0, 6.15, -1.7),
		laneInfo.copy,
		{
			backgroundColor = palette.night_blue,
			textColor = palette.fluorescent_white,
			strokeColor = palette.charcoal,
			pixelsPerStud = 34,
			zoneName = zoneName,
			groupName = "CheckoutMarkers",
		}
	)
	laneSign:SetAttribute("SignageFamily", "checkout_marker")

	return group
end

local function makeQueueRail(parent, cframe, length, zoneName)
	makePart(
		parent,
		"RailPost",
		Vector3.new(0.18, 2.7, 0.18),
		cframe * CFrame.new(-length * 0.5, 1.35, 0),
		{
			color = Color3.fromRGB(170, 174, 180),
			material = Enum.Material.Metal,
			canCollide = false,
		}
	)
	makePart(
		parent,
		"RailPost",
		Vector3.new(0.18, 2.7, 0.18),
		cframe * CFrame.new(length * 0.5, 1.35, 0),
		{
			color = Color3.fromRGB(170, 174, 180),
			material = Enum.Material.Metal,
			canCollide = false,
		}
	)
	local band = makePart(
		parent,
		"RailBand",
		Vector3.new(length, 0.18, 0.18),
		cframe * CFrame.new(0, 2.1, 0),
		{
			color = palette.safety_red,
			material = Enum.Material.SmoothPlastic,
			canCollide = false,
			castShadow = false,
		}
	)
	markPart(band, zoneName, "CheckoutMarkers")
end

local function makeFreezerCase(parent, groups, origin, zoneName)
	local group = Instance.new("Folder")
	group.Name = "FreezerCase"
	group.Parent = parent

	makePart(group, "Body", Vector3.new(9, 7.4, 2.6), origin * CFrame.new(0, 3.7, 0), {
		color = Color3.fromRGB(108, 118, 132),
		material = Enum.Material.Metal,
		canCollide = false,
	})
	local light =
		makePart(group, "TopAccent", Vector3.new(8.9, 0.4, 2.45), origin * CFrame.new(0, 7.28, 0), {
			color = palette.cooler_teal,
			material = Enum.Material.Neon,
			canCollide = false,
			castShadow = false,
		})
	markPart(light, zoneName, "FixtureBanks")
	registerGroup(groups, "FixtureBanks", light)

	for _, xOffset in ipairs({ -2.9, 0, 2.9 }) do
		makePart(
			group,
			"DoorGlass",
			Vector3.new(2.45, 5.2, 0.12),
			origin * CFrame.new(xOffset, 3.55, 1.31),
			{
				color = Color3.fromRGB(181, 216, 244),
				material = Enum.Material.Glass,
				transparency = 0.45,
				reflectance = 0.06,
				canCollide = false,
				castShadow = false,
			}
		)
	end

	local header = makeSign(
		group,
		groups,
		"FreezerHeader",
		Vector3.new(5.8, 0.95, 0.16),
		origin * CFrame.new(0, 6.65, 1.42),
		StoreSignage.Freezer.header,
		{
			backgroundColor = palette.night_blue,
			textColor = palette.fluorescent_white,
			strokeColor = palette.charcoal,
			pixelsPerStud = 34,
			zoneName = zoneName,
			groupName = "EmergencyRead",
		}
	)
	header:SetAttribute("SignageFamily", "freezer_header")

	return group
end

local function makeBackstockStack(parent, groups, origin, zoneName)
	local group = Instance.new("Folder")
	group.Name = "BackstockStack"
	group.Parent = parent

	makePart(group, "Pallet", Vector3.new(4.4, 0.45, 4.2), origin * CFrame.new(0, 0.22, 0), {
		color = Color3.fromRGB(127, 92, 62),
		material = Enum.Material.WoodPlanks,
		canCollide = false,
	})

	local boxPositions = {
		{
			name = "BoxA",
			offset = Vector3.new(-0.9, 1.25, -0.4),
			size = Vector3.new(2.4, 1.6, 2.2),
		},
		{ name = "BoxB", offset = Vector3.new(1.1, 1.05, 0.5), size = Vector3.new(1.8, 1.3, 1.8) },
		{ name = "BoxC", offset = Vector3.new(0.15, 2.45, 0), size = Vector3.new(2.1, 1.35, 1.7) },
	}
	for _, entry in ipairs(boxPositions) do
		makePart(group, entry.name, entry.size, origin * CFrame.new(entry.offset), {
			color = Color3.fromRGB(141, 107, 78),
			material = Enum.Material.Cardboard,
			canCollide = false,
		})
	end

	local label = makeSign(
		group,
		groups,
		"BackstockCard",
		Vector3.new(2.8, 0.95, 0.1),
		origin * CFrame.new(0.1, 3.4, 2.18),
		StoreSignage.DepartmentHeaders.backstock,
		{
			backgroundColor = palette.receipt_cream,
			textColor = palette.charcoal,
			strokeColor = palette.charcoal,
			pixelsPerStud = 28,
			zoneName = zoneName,
			groupName = "StaffSigns",
		}
	)
	label:SetAttribute("SignageFamily", "staff_sign")

	return group
end

local function makeCeilingFixture(parent, groups, position, size, zoneName)
	local fixture = makePart(parent, "CeilingFixture", size, CFrame.new(position), {
		color = palette.fluorescent_white,
		material = Enum.Material.Neon,
		canCollide = false,
		castShadow = false,
	})
	markPart(fixture, zoneName, "FixtureBanks")
	registerGroup(groups, "FixtureBanks", fixture)
	return fixture
end

local function buildHooks(parent)
	local hooks = Instance.new("Folder")
	hooks.Name = StoreRollout.HooksFolderName
	hooks:SetAttribute("SupportsContentSwap", true)
	hooks.Parent = parent

	makeAnchor(
		hooks,
		"LobbyCaptureAnchor",
		CFrame.lookAt(Vector3.new(0, floorTopY + 5.8, -42), Vector3.new(0, floorTopY + 6.5, -30)),
		"Lobby",
		"capture"
	)
	makeAnchor(
		hooks,
		"CheckoutCaptureAnchor",
		CFrame.lookAt(Vector3.new(20, floorTopY + 5.5, -12), Vector3.new(0, floorTopY + 4.5, -18)),
		"Checkout",
		"capture"
	)
	makeAnchor(
		hooks,
		"AisleWestCaptureAnchor",
		CFrame.lookAt(Vector3.new(-30, floorTopY + 5.4, -6), Vector3.new(-30, floorTopY + 4.8, 20)),
		"AislesWest",
		"capture"
	)
	makeAnchor(
		hooks,
		"AisleCenterCaptureAnchor",
		CFrame.lookAt(Vector3.new(0, floorTopY + 5.4, -6), Vector3.new(0, floorTopY + 4.8, 20)),
		"AislesCenter",
		"capture"
	)
	makeAnchor(
		hooks,
		"AisleEastCaptureAnchor",
		CFrame.lookAt(Vector3.new(30, floorTopY + 5.4, -6), Vector3.new(30, floorTopY + 4.8, 20)),
		"AislesEast",
		"capture"
	)
	makeAnchor(
		hooks,
		"FreezerCaptureAnchor",
		CFrame.lookAt(Vector3.new(-12, floorTopY + 5.2, 24), Vector3.new(10, floorTopY + 5.2, 31)),
		"Freezer",
		"capture"
	)
	makeAnchor(
		hooks,
		"StockroomCaptureAnchor",
		CFrame.lookAt(Vector3.new(18, floorTopY + 5.2, 22), Vector3.new(28, floorTopY + 4.8, 12)),
		"Stockroom",
		"capture"
	)
	makeAnchor(
		hooks,
		"FrontContinuityAnchor",
		CFrame.lookAt(Vector3.new(0, floorTopY + 6.2, -46), Vector3.new(0, floorTopY + 5.8, 10)),
		"EntranceTransition",
		"capture"
	)
	makeAnchor(
		hooks,
		"FreezerContinuityAnchor",
		CFrame.lookAt(Vector3.new(0, floorTopY + 5.4, 8), Vector3.new(0, floorTopY + 5.2, 30)),
		"FreezerTransition",
		"capture"
	)
	makeAnchor(
		hooks,
		"StockroomContinuityAnchor",
		CFrame.lookAt(Vector3.new(9, floorTopY + 5.4, 3), Vector3.new(24, floorTopY + 5.2, 20)),
		"StockroomTransition",
		"capture"
	)
	makeAnchor(
		hooks,
		"BlackoutReadAnchor",
		CFrame.lookAt(Vector3.new(0, floorTopY + 5.6, -8), Vector3.new(0, floorTopY + 5.2, 18)),
		"Queue",
		"capture"
	)
	makeAnchor(
		hooks,
		"MimicReadAnchor",
		CFrame.lookAt(Vector3.new(-14, floorTopY + 5.3, -2), Vector3.new(-10, floorTopY + 4.8, 16)),
		"AislesCenter",
		"capture"
	)
	makeAnchor(
		hooks,
		"UpdateShotAnchor",
		CFrame.lookAt(Vector3.new(-20, floorTopY + 5.8, -20), Vector3.new(14, floorTopY + 5.4, 0)),
		"AislesWest",
		"capture"
	)

	makeAnchor(hooks, "LobbyBrandHook", CFrame.new(0, floorTopY + 8.5, -51), "Lobby", "signage")
	makeAnchor(
		hooks,
		"CheckoutHeaderHook",
		CFrame.new(0, floorTopY + 8.5, -20.5),
		"Checkout",
		"signage"
	)
	makeAnchor(
		hooks,
		"AisleWestHook",
		CFrame.new(-30, floorTopY + 9.4, -17),
		"AislesWest",
		"signage"
	)
	makeAnchor(
		hooks,
		"AisleCenterHook",
		CFrame.new(0, floorTopY + 9.4, -17),
		"AislesCenter",
		"signage"
	)
	makeAnchor(
		hooks,
		"AisleEastHook",
		CFrame.new(30, floorTopY + 9.4, -17),
		"AislesEast",
		"signage"
	)
	makeAnchor(hooks, "FreezerHeaderHook", CFrame.new(0, floorTopY + 7.0, 35), "Freezer", "signage")
	makeAnchor(
		hooks,
		"StockroomDoorHook",
		CFrame.new(27.5, floorTopY + 6.8, 10.5),
		"StockroomTransition",
		"signage"
	)
	makeAnchor(hooks, "ExitHook", CFrame.new(-47.8, floorTopY + 6.6, -43), "Lobby", "signage")

	return hooks
end

local function buildPerimeter(parent, groups)
	local zone = createZoneFolder(parent, "Perimeter")

	local wallSpecs = {
		{
			name = "SouthWall",
			size = Vector3.new(106, 18, 1),
			position = Vector3.new(0, floorTopY + 9, -54),
			color = Color3.fromRGB(202, 204, 210),
		},
		{
			name = "NorthWall",
			size = Vector3.new(106, 18, 1),
			position = Vector3.new(0, floorTopY + 9, 44),
			color = Color3.fromRGB(188, 196, 205),
		},
		{
			name = "WestWall",
			size = Vector3.new(1, 18, 86),
			position = Vector3.new(-52, floorTopY + 9, -5),
			color = Color3.fromRGB(194, 198, 203),
		},
		{
			name = "EastWall",
			size = Vector3.new(1, 18, 86),
			position = Vector3.new(52, floorTopY + 9, -5),
			color = Color3.fromRGB(188, 187, 181),
		},
	}
	for _, spec in ipairs(wallSpecs) do
		makePart(zone, spec.name, spec.size, CFrame.new(spec.position), {
			color = spec.color,
			material = Enum.Material.Concrete,
			canCollide = false,
		})
	end

	local ceiling = makePart(
		zone,
		"FrontCeilingBand",
		Vector3.new(106, 1.2, 86),
		CFrame.new(0, floorTopY + 13.3, -5),
		{
			color = Color3.fromRGB(212, 214, 218),
			material = Enum.Material.SmoothPlastic,
			canCollide = false,
			castShadow = false,
		}
	)
	markPart(ceiling, "SightlineCeiling", nil)

	for _, xPos in ipairs({ -36, -12, 12, 36 }) do
		for _, zPos in ipairs({ -38, -14, 10, 34 }) do
			makeCeilingFixture(
				zone,
				groups,
				Vector3.new(xPos, floorTopY + 12.9, zPos),
				Vector3.new(14, 0.35, 3.2),
				"SightlineCeiling"
			)
		end
	end

	local exitSign = makeSign(
		zone,
		groups,
		"ExitSign",
		Vector3.new(4.2, 1.1, 0.16),
		CFrame.new(-47.9, floorTopY + 6.8, -43) * CFrame.Angles(0, math.rad(90), 0),
		StoreSignage.Staff.exit,
		{
			backgroundColor = palette.payroll_green,
			textColor = palette.charcoal,
			strokeColor = palette.charcoal,
			pixelsPerStud = 34,
			zoneName = "Perimeter",
			groupName = "EmergencyRead",
		}
	)
	exitSign:SetAttribute("SignageFamily", "emergency_read")

	local maskA = makePart(
		zone,
		"LobbyMaskWest",
		Vector3.new(10, 9, 2),
		CFrame.new(-42, floorTopY + 4.5, -28),
		{
			color = Color3.fromRGB(186, 188, 193),
			material = Enum.Material.Concrete,
			canCollide = false,
		}
	)
	markPart(maskA, "Perimeter", "PlaceholderMasks")
	registerGroup(groups, "PlaceholderMasks", maskA)

	local maskB = makePart(
		zone,
		"LobbyMaskEast",
		Vector3.new(10, 9, 2),
		CFrame.new(42, floorTopY + 4.5, -28),
		{
			color = Color3.fromRGB(186, 188, 193),
			material = Enum.Material.Concrete,
			canCollide = false,
		}
	)
	markPart(maskB, "Perimeter", "PlaceholderMasks")
	registerGroup(groups, "PlaceholderMasks", maskB)
end

local function buildLobby(parent, groups)
	local zone = createZoneFolder(parent, "Lobby")

	makePart(zone, "EntryTile", Vector3.new(58, 0.1, 22), CFrame.new(0, floorTopY + 0.05, -43), {
		color = Color3.fromRGB(122, 124, 128),
		material = Enum.Material.SmoothPlastic,
		canCollide = false,
		castShadow = false,
	})
	makePart(zone, "EntryMat", Vector3.new(18, 0.08, 5.5), CFrame.new(0, floorTopY + 0.08, -47), {
		color = Color3.fromRGB(41, 45, 56),
		material = Enum.Material.Fabric,
		canCollide = false,
		castShadow = false,
	})

	local brandWall = makeSign(
		zone,
		groups,
		"BrandWall",
		Vector3.new(20, 4.2, 0.2),
		CFrame.new(0, floorTopY + 8.4, -53.4),
		StoreSignage.Brand.wordmark,
		{
			backgroundColor = palette.night_blue,
			textColor = palette.fluorescent_white,
			strokeColor = palette.charcoal,
			pixelsPerStud = 42,
			zoneName = "Lobby",
			groupName = "BrandSigns",
		}
	)
	brandWall:SetAttribute("SignageFamily", "brand_sign")

	local brandTag = makeSign(
		zone,
		groups,
		"BrandTag",
		Vector3.new(4.2, 1.2, 0.22),
		CFrame.new(11.8, floorTopY + 6.0, -53.2),
		StoreSignage.Brand.tag,
		{
			backgroundColor = palette.payroll_green,
			textColor = palette.charcoal,
			strokeColor = palette.charcoal,
			pixelsPerStud = 34,
			zoneName = "Lobby",
			groupName = "BrandSigns",
		}
	)
	brandTag:SetAttribute("SignageFamily", "brand_sign")

	makeSign(
		zone,
		groups,
		"HoursCard",
		Vector3.new(6.2, 1.05, 0.16),
		CFrame.new(-13.5, floorTopY + 5.2, -53.2),
		StoreSignage.Brand.supportLine,
		{
			backgroundColor = palette.receipt_cream,
			textColor = palette.charcoal,
			strokeColor = palette.charcoal,
			pixelsPerStud = 28,
			zoneName = "Lobby",
			groupName = "BrandSigns",
		}
	)

	local saleCard = makeSign(
		zone,
		groups,
		"PromoCard",
		Vector3.new(4.1, 1.5, 0.16),
		CFrame.new(-24, floorTopY + 4.2, -39.2),
		string.format("%s\n%s", StoreSignage.SaleCard.headline, StoreSignage.SaleCard.prices[1]),
		{
			backgroundColor = palette.safety_red,
			textColor = palette.fluorescent_white,
			strokeColor = palette.charcoal,
			pixelsPerStud = 28,
			zoneName = "Lobby",
			groupName = "SaleCards",
		}
	)
	saleCard:SetAttribute("SignageFamily", StoreSignage.SaleCard.familyId)

	for index = 0, 3 do
		makePart(
			zone,
			"Basket",
			Vector3.new(1.2, 0.35, 1.6),
			CFrame.new(21, floorTopY + 0.2 + (index * 0.26), -42),
			{
				color = Color3.fromRGB(76, 82, 96),
				material = Enum.Material.Metal,
				canCollide = false,
			}
		)
	end

	for index = 0, 2 do
		makePart(
			zone,
			"Cart",
			Vector3.new(3.2, 1.6, 2.4),
			CFrame.new(31, floorTopY + 0.8, -46 + (index * 4.2)),
			{
				color = Color3.fromRGB(176, 178, 182),
				material = Enum.Material.Metal,
				canCollide = false,
			}
		)
	end
end

local function buildEntranceTransition(parent, groups)
	local zone = createZoneFolder(parent, "EntranceTransition")
	makePart(
		zone,
		"ThresholdStrip",
		Vector3.new(40, 0.1, 4),
		CFrame.new(0, floorTopY + 0.05, -30),
		{
			color = Color3.fromRGB(92, 98, 110),
			material = Enum.Material.Metal,
			canCollide = false,
			castShadow = false,
		}
	)
	makePart(zone, "CenterRun", Vector3.new(18, 0.08, 12), CFrame.new(0, floorTopY + 0.04, -24), {
		color = Color3.fromRGB(162, 165, 170),
		material = Enum.Material.SmoothPlastic,
		canCollide = false,
		castShadow = false,
	})

	local checkoutHeader = makeSign(
		zone,
		groups,
		"CheckoutHeader",
		Vector3.new(8.2, 1.2, 0.16),
		CFrame.new(0, floorTopY + 8.4, -25.2),
		StoreSignage.Brand.checkoutHeader,
		{
			backgroundColor = palette.receipt_cream,
			textColor = palette.charcoal,
			strokeColor = palette.charcoal,
			pixelsPerStud = 32,
			zoneName = "EntranceTransition",
			groupName = "CheckoutMarkers",
		}
	)
	checkoutHeader:SetAttribute("SignageFamily", "checkout_header")
end

local function buildCheckout(parent, groups)
	local zone = createZoneFolder(parent, "Checkout")

	makePart(
		zone,
		"CheckoutFloorAccent",
		Vector3.new(40, 0.1, 12),
		CFrame.new(0, floorTopY + 0.05, -18),
		{
			color = Color3.fromRGB(96, 96, 102),
			material = Enum.Material.Metal,
			canCollide = false,
			castShadow = false,
		}
	)

	makeCheckoutLane(
		zone,
		groups,
		CFrame.new(-18, floorTopY, -18),
		StoreSignage.Checkout[1],
		"Checkout"
	)
	makeCheckoutLane(
		zone,
		groups,
		CFrame.new(-6, floorTopY, -18),
		StoreSignage.Checkout[2],
		"Checkout"
	)
	makeCheckoutLane(
		zone,
		groups,
		CFrame.new(6, floorTopY, -18),
		StoreSignage.Checkout[3],
		"Checkout"
	)
	makeCheckoutLane(
		zone,
		groups,
		CFrame.new(18, floorTopY, -18),
		StoreSignage.Checkout[4],
		"Checkout"
	)
end

local function buildQueue(parent)
	local zone = createZoneFolder(parent, "Queue")
	makePart(zone, "QueueLaneA", Vector3.new(10, 0.06, 16), CFrame.new(-12, floorTopY + 0.03, -8), {
		color = Color3.fromRGB(166, 168, 174),
		material = Enum.Material.SmoothPlastic,
		canCollide = false,
		castShadow = false,
	})
	makePart(zone, "QueueLaneB", Vector3.new(10, 0.06, 16), CFrame.new(0, floorTopY + 0.03, -8), {
		color = Color3.fromRGB(166, 168, 174),
		material = Enum.Material.SmoothPlastic,
		canCollide = false,
		castShadow = false,
	})
	makePart(zone, "QueueLaneC", Vector3.new(10, 0.06, 16), CFrame.new(12, floorTopY + 0.03, -8), {
		color = Color3.fromRGB(166, 168, 174),
		material = Enum.Material.SmoothPlastic,
		canCollide = false,
		castShadow = false,
	})

	makeQueueRail(zone, CFrame.new(-12, floorTopY, -10), 10, "Queue")
	makeQueueRail(zone, CFrame.new(0, floorTopY, -10), 10, "Queue")
	makeQueueRail(zone, CFrame.new(12, floorTopY, -10), 10, "Queue")
end

local function buildAisles(parent, groups)
	local aisleZones = {
		{
			name = "AislesWest",
			x = -30,
			signs = { StoreSignage.Aisles[1], StoreSignage.Aisles[2] },
			salePrice = StoreSignage.SaleCard.prices[2],
		},
		{
			name = "AislesCenter",
			x = 0,
			signs = { StoreSignage.Aisles[3], StoreSignage.Aisles[4] },
			salePrice = StoreSignage.SaleCard.prices[3],
		},
		{
			name = "AislesEast",
			x = 30,
			signs = { StoreSignage.Aisles[5], StoreSignage.Aisles[6] },
			salePrice = StoreSignage.SaleCard.prices[1],
		},
	}

	for _, aisleZone in ipairs(aisleZones) do
		local zone = createZoneFolder(parent, aisleZone.name)
		makePart(
			zone,
			"AisleRunner",
			Vector3.new(16, 0.08, 36),
			CFrame.new(aisleZone.x, floorTopY + 0.04, 3),
			{
				color = Color3.fromRGB(163, 165, 170),
				material = Enum.Material.SmoothPlastic,
				canCollide = false,
				castShadow = false,
			}
		)

		makeShelfBay(
			zone,
			groups,
			CFrame.new(aisleZone.x - 5.5, floorTopY, -5),
			aisleZone.signs[1],
			false,
			aisleZone.name
		)
		makeShelfBay(
			zone,
			groups,
			CFrame.new(aisleZone.x + 5.5, floorTopY, -5),
			aisleZone.signs[1],
			true,
			aisleZone.name
		)
		makeShelfBay(
			zone,
			groups,
			CFrame.new(aisleZone.x - 5.5, floorTopY, 11),
			aisleZone.signs[2],
			false,
			aisleZone.name
		)
		makeShelfBay(
			zone,
			groups,
			CFrame.new(aisleZone.x + 5.5, floorTopY, 11),
			aisleZone.signs[2],
			true,
			aisleZone.name
		)

		local marker = makeSign(
			zone,
			groups,
			"AisleMarker",
			Vector3.new(2.8, 1.2, 0.16),
			CFrame.new(aisleZone.x, floorTopY + 9.3, -18),
			aisleZone.signs[1].numeral,
			{
				backgroundColor = palette.night_blue,
				textColor = palette.fluorescent_white,
				strokeColor = palette.charcoal,
				pixelsPerStud = 42,
				doubleSided = true,
				zoneName = aisleZone.name,
				groupName = "AisleMarkers",
			}
		)
		marker:SetAttribute("SignageFamily", "aisle_marker")

		local secondaryMarker = makeSign(
			zone,
			groups,
			"AisleMarkerBack",
			Vector3.new(2.8, 1.2, 0.16),
			CFrame.new(aisleZone.x, floorTopY + 9.3, -2),
			aisleZone.signs[2].numeral,
			{
				backgroundColor = palette.night_blue,
				textColor = palette.fluorescent_white,
				strokeColor = palette.charcoal,
				pixelsPerStud = 42,
				doubleSided = true,
				zoneName = aisleZone.name,
				groupName = "AisleMarkers",
			}
		)
		secondaryMarker:SetAttribute("SignageFamily", "aisle_marker")

		local saleCard = makeSign(
			zone,
			groups,
			"SaleCard",
			Vector3.new(4.0, 1.4, 0.16),
			CFrame.new(aisleZone.x, floorTopY + 4.6, 21),
			string.format("%s\n%s", StoreSignage.SaleCard.headline, aisleZone.salePrice),
			{
				backgroundColor = palette.safety_red,
				textColor = palette.fluorescent_white,
				strokeColor = palette.charcoal,
				pixelsPerStud = 28,
				zoneName = aisleZone.name,
				groupName = "SaleCards",
			}
		)
		saleCard:SetAttribute("SignageFamily", StoreSignage.SaleCard.familyId)
	end

	local secondary = createZoneFolder(parent, "SecondaryEndcaps")
	for _, xPos in ipairs({ -30, 0, 30 }) do
		makePart(
			secondary,
			"EndcapBlock",
			Vector3.new(5.5, 4.5, 2.6),
			CFrame.new(xPos, floorTopY + 2.25, 24),
			{
				color = Color3.fromRGB(139, 126, 102),
				material = Enum.Material.WoodPlanks,
				canCollide = false,
			}
		)
	end
end

local function buildFreezerTransition(parent, groups)
	local zone = createZoneFolder(parent, "FreezerTransition")
	makePart(zone, "ColdRun", Vector3.new(32, 0.08, 12), CFrame.new(0, floorTopY + 0.04, 22), {
		color = Color3.fromRGB(183, 196, 207),
		material = Enum.Material.SmoothPlastic,
		canCollide = false,
		castShadow = false,
	})
	makeSign(
		zone,
		groups,
		"FreezerHeader",
		Vector3.new(6.2, 1.1, 0.16),
		CFrame.new(0, floorTopY + 7.1, 35),
		StoreSignage.Freezer.subheader,
		{
			backgroundColor = palette.receipt_cream,
			textColor = palette.charcoal,
			strokeColor = palette.charcoal,
			pixelsPerStud = 28,
			zoneName = "FreezerTransition",
			groupName = "EmergencyRead",
		}
	)
end

local function buildFreezer(parent, groups)
	local zone = createZoneFolder(parent, "Freezer")
	makePart(zone, "ColdFloor", Vector3.new(38, 0.1, 10), CFrame.new(0, floorTopY + 0.05, 31), {
		color = Color3.fromRGB(181, 196, 207),
		material = Enum.Material.SmoothPlastic,
		canCollide = false,
		castShadow = false,
	})
	makeFreezerCase(zone, groups, CFrame.new(-12, floorTopY, 31), "Freezer")
	makeFreezerCase(zone, groups, CFrame.new(0, floorTopY, 31), "Freezer")
	makeFreezerCase(zone, groups, CFrame.new(12, floorTopY, 31), "Freezer")
end

local function buildStockroomTransition(parent, groups)
	local zone = createZoneFolder(parent, "StockroomTransition")
	makePart(zone, "UtilityFloor", Vector3.new(16, 0.08, 18), CFrame.new(20, floorTopY + 0.04, 9), {
		color = Color3.fromRGB(118, 110, 101),
		material = Enum.Material.Concrete,
		canCollide = false,
		castShadow = false,
	})
	local staffDoor = makeSign(
		zone,
		groups,
		"EmployeesOnly",
		Vector3.new(6.2, 1.2, 0.16),
		CFrame.new(27.9, floorTopY + 7.2, 9.2) * CFrame.Angles(0, math.rad(-90), 0),
		StoreSignage.Staff.employeesOnly,
		{
			backgroundColor = palette.safety_red,
			textColor = palette.fluorescent_white,
			strokeColor = palette.charcoal,
			pixelsPerStud = 30,
			zoneName = "StockroomTransition",
			groupName = "StaffSigns",
		}
	)
	staffDoor:SetAttribute("SignageFamily", "staff_sign")
end

local function buildStockroom(parent, groups)
	local zone = createZoneFolder(parent, "Stockroom")
	makePart(
		zone,
		"BackroomFloor",
		Vector3.new(20, 0.1, 22),
		CFrame.new(28, floorTopY + 0.05, 20),
		{
			color = Color3.fromRGB(102, 92, 83),
			material = Enum.Material.Concrete,
			canCollide = false,
			castShadow = false,
		}
	)
	makePart(zone, "BackroomWallA", Vector3.new(1, 14, 22), CFrame.new(38, floorTopY + 7, 20), {
		color = Color3.fromRGB(121, 110, 98),
		material = Enum.Material.Concrete,
		canCollide = false,
	})
	makePart(zone, "BackroomWallB", Vector3.new(18, 14, 1), CFrame.new(29, floorTopY + 7, 31), {
		color = Color3.fromRGB(121, 110, 98),
		material = Enum.Material.Concrete,
		canCollide = false,
	})

	local utilityLight = makePart(
		zone,
		"UtilityLight",
		Vector3.new(6, 0.28, 2.4),
		CFrame.new(28, floorTopY + 10.8, 20),
		{
			color = palette.sodium_amber,
			material = Enum.Material.Neon,
			canCollide = false,
			castShadow = false,
		}
	)
	markPart(utilityLight, "Stockroom", "FixtureBanks")
	registerGroup(groups, "FixtureBanks", utilityLight)

	local notice = makeSign(
		zone,
		groups,
		"NoticeBoard",
		Vector3.new(4.4, 2.0, 0.16),
		CFrame.new(20.2, floorTopY + 6.0, 31.02),
		StoreSignage.Staff.noticeBoard,
		{
			backgroundColor = palette.receipt_cream,
			textColor = palette.charcoal,
			strokeColor = palette.charcoal,
			pixelsPerStud = 24,
			zoneName = "Stockroom",
			groupName = "StaffSigns",
		}
	)
	notice:SetAttribute("SignageFamily", "staff_sign")

	local receiving = makeSign(
		zone,
		groups,
		"ReceivingSign",
		Vector3.new(4.0, 1.0, 0.16),
		CFrame.new(32.2, floorTopY + 6.8, 31.02),
		StoreSignage.DepartmentHeaders.receiving,
		{
			backgroundColor = palette.night_blue,
			textColor = palette.fluorescent_white,
			strokeColor = palette.charcoal,
			pixelsPerStud = 24,
			zoneName = "Stockroom",
			groupName = "EmergencyRead",
		}
	)
	receiving:SetAttribute("SignageFamily", "emergency_read")

	makeBackstockStack(zone, groups, CFrame.new(28, floorTopY, 21), "Stockroom")
	makeBackstockStack(zone, groups, CFrame.new(34, floorTopY, 16), "Stockroom")

	makePart(zone, "MopBucket", Vector3.new(1.4, 1.2, 1.2), CFrame.new(21, floorTopY + 0.6, 14.4), {
		color = palette.sodium_amber,
		material = Enum.Material.Metal,
		canCollide = false,
	})
end

local function buildStaffHall(parent)
	local zone = createZoneFolder(parent, "StaffHall")
	makePart(zone, "HallRun", Vector3.new(8, 0.08, 18), CFrame.new(44, floorTopY + 0.04, 8), {
		color = Color3.fromRGB(112, 104, 96),
		material = Enum.Material.Concrete,
		canCollide = false,
		castShadow = false,
	})
end

local function buildTaskCorners(parent)
	local zone = createZoneFolder(parent, "TaskCorners")
	makePart(
		zone,
		"SpillReadFrame",
		Vector3.new(8, 0.08, 8),
		CFrame.new(-10, floorTopY + 0.04, 16),
		{
			color = Color3.fromRGB(170, 188, 204),
			material = Enum.Material.SmoothPlastic,
			canCollide = false,
			castShadow = false,
		}
	)
	makePart(
		zone,
		"TrashReadFrame",
		Vector3.new(8, 0.08, 8),
		CFrame.new(18, floorTopY + 0.04, 16),
		{
			color = Color3.fromRGB(132, 126, 112),
			material = Enum.Material.SmoothPlastic,
			canCollide = false,
			castShadow = false,
		}
	)
	makePart(zone, "CartReadFrame", Vector3.new(8, 0.08, 8), CFrame.new(26, floorTopY + 0.04, -8), {
		color = Color3.fromRGB(167, 171, 176),
		material = Enum.Material.SmoothPlastic,
		canCollide = false,
		castShadow = false,
	})
end

local function buildSlice()
	ensureFloor()
	ensureSpawn()

	local sliceFolder = resetSliceFolder()
	local groups = buildRuntimeGroups(sliceFolder)
	buildHooks(sliceFolder)
	buildPerimeter(sliceFolder, groups)
	buildLobby(sliceFolder, groups)
	buildEntranceTransition(sliceFolder, groups)
	buildCheckout(sliceFolder, groups)
	buildQueue(sliceFolder)
	buildAisles(sliceFolder, groups)
	buildFreezerTransition(sliceFolder, groups)
	buildFreezer(sliceFolder, groups)
	buildStockroomTransition(sliceFolder, groups)
	buildStockroom(sliceFolder, groups)
	buildStaffHall(sliceFolder)
	buildTaskCorners(sliceFolder)
end

buildSlice()
