local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local StoreSignage = require(Shared:WaitForChild("StoreSignage"))
local VisualTheme = require(Shared:WaitForChild("VisualTheme"))

local FLOOR_NAME = "ShiftArenaFloor"
local SPAWN_NAME = "ShiftSpawn"
local SLICE_FOLDER_NAME = "FallbackArtSlice"
local ART_HOOK_FOLDER_NAME = "Sprint6ArtHooks"
local FLOOR_SIZE = Vector3.new(88, 1, 88)
local FLOOR_POSITION = Vector3.new(0, 180, 0)
local SPAWN_POSITION = Vector3.new(0, 184, -26)

local palette = VisualTheme.Palette
local floorTopY = FLOOR_POSITION.Y + (FLOOR_SIZE.Y * 0.5)

local function createZoneFolder(parent, name, priority)
	local zone = Instance.new("Folder")
	zone.Name = name
	zone:SetAttribute("Sprint6Zone", name)
	zone:SetAttribute("ZonePriority", priority)
	zone:SetAttribute("SupportsContentSwap", true)
	zone:SetAttribute("ArtOnly", true)
	zone.Parent = parent
	return zone
end

local function ensureFloor()
	local floor = Workspace:FindFirstChild(FLOOR_NAME)
	if floor ~= nil and floor:IsA("BasePart") then
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
	local existing = Workspace:FindFirstChild(SLICE_FOLDER_NAME)
	if existing ~= nil then
		existing:Destroy()
	end

	local folder = Instance.new("Folder")
	folder.Name = SLICE_FOLDER_NAME
	folder:SetAttribute("Sprint6VisualSlice", true)
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
	anchor:SetAttribute("Sprint6Zone", zoneName)
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
	stroke.Transparency = options.strokeTransparency or 0.5
	stroke.Parent = label

	return surface
end

local function makeSign(parent, name, size, cframe, text, options)
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
	return sign
end

local function makeBox(parent, name, size, cframe)
	local box = makePart(parent, name, size, cframe, {
		color = Color3.fromRGB(141, 107, 78),
		material = Enum.Material.Cardboard,
		canCollide = false,
	})
	makeSign(
		parent,
		name .. "Label",
		Vector3.new(size.X * 0.5, size.Y * 0.35, 0.1),
		cframe * CFrame.new(0, 0, (size.Z * 0.5) + 0.06),
		"BACKSTOCK",
		{
			backgroundColor = palette.receipt_cream,
			textColor = palette.charcoal,
			strokeColor = palette.charcoal,
			pixelsPerStud = 28,
			canvasSize = Vector2.new(256, 96),
		}
	)
	return box
end

local function makeShelfBay(parent, origin, labelText)
	local group = Instance.new("Folder")
	group.Name = "ShelfBay"
	group.Parent = parent

	makePart(group, "BackPanel", Vector3.new(8, 7.5, 0.5), origin * CFrame.new(0, 3.75, 0), {
		color = Color3.fromRGB(83, 90, 102),
		material = Enum.Material.Metal,
		canCollide = false,
	})
	makePart(group, "TopCap", Vector3.new(8.4, 0.35, 1.4), origin * CFrame.new(0, 7.35, 0), {
		color = palette.night_blue,
		material = Enum.Material.SmoothPlastic,
		canCollide = false,
	})
	makePart(group, "ShelfBase", Vector3.new(8.4, 0.5, 1.4), origin * CFrame.new(0, 0.25, 0), {
		color = Color3.fromRGB(109, 116, 128),
		material = Enum.Material.Metal,
		canCollide = false,
	})

	for _, xOffset in ipairs({ -3.8, 3.8 }) do
		makePart(
			group,
			"Upright",
			Vector3.new(0.35, 7.2, 1.2),
			origin * CFrame.new(xOffset, 3.6, 0),
			{
				color = Color3.fromRGB(116, 124, 137),
				material = Enum.Material.Metal,
				canCollide = false,
			}
		)
	end

	for _, yOffset in ipairs({ 1.2, 2.9, 4.6, 6.1 }) do
		makePart(
			group,
			"Shelf",
			Vector3.new(7.8, 0.18, 1.2),
			origin * CFrame.new(0, yOffset, 0.25),
			{
				color = Color3.fromRGB(214, 216, 220),
				material = Enum.Material.Metal,
				canCollide = false,
			}
		)
		makePart(
			group,
			"PriceStrip",
			Vector3.new(7.7, 0.12, 0.08),
			origin * CFrame.new(0, yOffset - 0.18, 0.83),
			{
				color = palette.receipt_cream,
				material = Enum.Material.SmoothPlastic,
				canCollide = false,
				castShadow = false,
			}
		)
	end

	makeSign(
		group,
		"CategoryTopper",
		Vector3.new(6.6, 1.25, 0.16),
		origin * CFrame.new(0, 8.3, 0.72),
		labelText,
		{
			backgroundColor = palette.night_blue,
			textColor = palette.fluorescent_white,
			strokeColor = palette.charcoal,
			pixelsPerStud = 34,
			doubleSided = true,
		}
	)

	local productColors = {
		Color3.fromRGB(214, 88, 72),
		Color3.fromRGB(236, 184, 82),
		Color3.fromRGB(87, 147, 215),
		Color3.fromRGB(104, 178, 116),
	}
	for rowIndex, yOffset in ipairs({ 0.68, 2.38, 4.08, 5.58 }) do
		for column = -3, 3 do
			local color = productColors[((column + rowIndex) % #productColors) + 1]
			local width = if column % 2 == 0 then 0.65 else 0.9
			local depth = if rowIndex % 2 == 0 then 0.42 else 0.58
			makePart(
				group,
				"Product",
				Vector3.new(width, 0.75, depth),
				origin * CFrame.new(column * 1.05, yOffset, 0.18),
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

local function makeCounter(parent, origin, labelText)
	local group = Instance.new("Folder")
	group.Name = labelText:gsub("%s+", "") .. "Counter"
	group.Parent = parent

	makePart(group, "CounterBase", Vector3.new(9, 3.2, 3.6), origin * CFrame.new(0, 1.6, 0), {
		color = Color3.fromRGB(82, 78, 76),
		material = Enum.Material.WoodPlanks,
		canCollide = false,
	})
	makePart(group, "CounterTop", Vector3.new(9.2, 0.35, 3.8), origin * CFrame.new(0, 3.35, 0), {
		color = Color3.fromRGB(205, 205, 205),
		material = Enum.Material.Metal,
		canCollide = false,
	})
	makePart(group, "Scanner", Vector3.new(1.1, 0.4, 1.2), origin * CFrame.new(-1.3, 3.72, 0.2), {
		color = palette.safety_red,
		material = Enum.Material.SmoothPlastic,
		canCollide = false,
		castShadow = false,
	})
	makePart(
		group,
		"ReceiptPlate",
		Vector3.new(0.6, 0.08, 1.1),
		origin * CFrame.new(0.4, 3.58, 0.2),
		{
			color = palette.receipt_cream,
			material = Enum.Material.SmoothPlastic,
			canCollide = false,
			castShadow = false,
		}
	)
	makePart(group, "BagWell", Vector3.new(1.8, 1.8, 1.4), origin * CFrame.new(2.7, 2.25, 0.5), {
		color = Color3.fromRGB(143, 151, 164),
		material = Enum.Material.Metal,
		canCollide = false,
	})
	makeSign(
		group,
		"LaneSign",
		Vector3.new(3.8, 0.95, 0.16),
		origin * CFrame.new(0, 6.25, -1.65),
		labelText,
		{
			backgroundColor = palette.night_blue,
			textColor = palette.fluorescent_white,
			strokeColor = palette.charcoal,
			pixelsPerStud = 34,
		}
	)
	return group
end

local function makeQueueRail(parent, cframe, length)
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
	makePart(parent, "RailBand", Vector3.new(length, 0.18, 0.18), cframe * CFrame.new(0, 2.1, 0), {
		color = palette.safety_red,
		material = Enum.Material.SmoothPlastic,
		canCollide = false,
		castShadow = false,
	})
end

local function makeFreezerCase(parent, origin, labelText)
	local group = Instance.new("Folder")
	group.Name = "FreezerCase"
	group.Parent = parent

	makePart(group, "Body", Vector3.new(8.5, 7.5, 2.4), origin * CFrame.new(0, 3.75, 0), {
		color = Color3.fromRGB(108, 118, 132),
		material = Enum.Material.Metal,
		canCollide = false,
	})
	makePart(group, "TopAccent", Vector3.new(8.6, 0.45, 2.5), origin * CFrame.new(0, 7.4, 0), {
		color = palette.powder_blue,
		material = Enum.Material.SmoothPlastic,
		canCollide = false,
		castShadow = false,
	})
	for _, xOffset in ipairs({ -2.7, 0, 2.7 }) do
		makePart(
			group,
			"DoorGlass",
			Vector3.new(2.35, 5.2, 0.12),
			origin * CFrame.new(xOffset, 3.55, 1.22),
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
	makeSign(
		group,
		"FreezerHeader",
		Vector3.new(5.8, 0.95, 0.16),
		origin * CFrame.new(0, 6.65, 1.32),
		labelText,
		{
			backgroundColor = palette.night_blue,
			textColor = palette.fluorescent_white,
			strokeColor = palette.charcoal,
			pixelsPerStud = 34,
		}
	)
	return group
end

local function makePalletStack(parent, origin)
	local group = Instance.new("Folder")
	group.Name = "PalletStack"
	group.Parent = parent

	makePart(group, "Pallet", Vector3.new(4.2, 0.45, 4.2), origin * CFrame.new(0, 0.22, 0), {
		color = Color3.fromRGB(127, 92, 62),
		material = Enum.Material.WoodPlanks,
		canCollide = false,
	})
	makeBox(group, "BoxA", Vector3.new(2.4, 1.6, 2.2), origin * CFrame.new(-0.9, 1.25, -0.4))
	makeBox(group, "BoxB", Vector3.new(1.8, 1.3, 1.8), origin * CFrame.new(1.1, 1.05, 0.5))
	makeBox(group, "BoxC", Vector3.new(2.1, 1.4, 1.7), origin * CFrame.new(0.2, 2.55, 0))
	return group
end

local function buildArtHooks(parent)
	local hooks = Instance.new("Folder")
	hooks.Name = ART_HOOK_FOLDER_NAME
	hooks:SetAttribute("SupportsContentSwap", true)
	hooks.Parent = parent

	makeAnchor(
		hooks,
		"LobbyCaptureAnchor",
		CFrame.lookAt(Vector3.new(0, floorTopY + 5.5, -33), Vector3.new(0, floorTopY + 8, -37)),
		"Lobby",
		"capture"
	)
	makeAnchor(
		hooks,
		"CheckoutCaptureAnchor",
		CFrame.lookAt(Vector3.new(17, floorTopY + 5.2, -6), Vector3.new(2, floorTopY + 4.4, -18)),
		"Checkout",
		"capture"
	)
	makeAnchor(
		hooks,
		"HeroAisleCaptureAnchor",
		CFrame.lookAt(Vector3.new(-20, floorTopY + 5.3, -17), Vector3.new(-20, floorTopY + 5, 8)),
		"HeroAisle",
		"capture"
	)
	makeAnchor(
		hooks,
		"FreezerCaptureAnchor",
		CFrame.lookAt(Vector3.new(-17, floorTopY + 5.1, 17), Vector3.new(0, floorTopY + 5.2, 25)),
		"Freezer",
		"capture"
	)
	makeAnchor(
		hooks,
		"StockroomCaptureAnchor",
		CFrame.lookAt(Vector3.new(8, floorTopY + 5.1, 8), Vector3.new(22, floorTopY + 5.2, 18)),
		"Stockroom",
		"capture"
	)

	makeAnchor(hooks, "LobbyBrandHook", CFrame.new(0, floorTopY + 8.4, -37.1), "Lobby", "signage")
	makeAnchor(
		hooks,
		"CheckoutSignHook",
		CFrame.new(0, floorTopY + 8.5, -12.3),
		"Checkout",
		"signage"
	)
	makeAnchor(
		hooks,
		"HeroAisleHeaderHook",
		CFrame.new(-20, floorTopY + 9.6, -13.2),
		"HeroAisle",
		"signage"
	)
	makeAnchor(
		hooks,
		"FreezerHeaderHook",
		CFrame.new(0, floorTopY + 6.8, 26.4),
		"Freezer",
		"signage"
	)
	makeAnchor(
		hooks,
		"StockroomNoticeHook",
		CFrame.new(18.2, floorTopY + 5.4, 25.02),
		"Stockroom",
		"signage"
	)

	return hooks
end

local function buildBackdropWalls(parent)
	makePart(parent, "SouthWall", Vector3.new(62, 18, 1), CFrame.new(0, floorTopY + 9, -38), {
		color = Color3.fromRGB(204, 206, 210),
		material = Enum.Material.Concrete,
		canCollide = false,
	})
	makePart(parent, "NorthWall", Vector3.new(62, 18, 1), CFrame.new(0, floorTopY + 9, 38), {
		color = Color3.fromRGB(187, 195, 205),
		material = Enum.Material.Concrete,
		canCollide = false,
	})
	makePart(parent, "WestWall", Vector3.new(1, 18, 52), CFrame.new(-34, floorTopY + 9, 4), {
		color = Color3.fromRGB(196, 198, 203),
		material = Enum.Material.Concrete,
		canCollide = false,
	})
	makePart(parent, "EastWall", Vector3.new(1, 18, 52), CFrame.new(34, floorTopY + 9, 4), {
		color = Color3.fromRGB(188, 187, 181),
		material = Enum.Material.Concrete,
		canCollide = false,
	})

	for _, zOffset in ipairs({ -22, -4, 14, 30 }) do
		makePart(
			parent,
			"CeilingLight",
			Vector3.new(12, 0.35, 3),
			CFrame.new(0, floorTopY + 12.8, zOffset),
			{
				color = palette.fluorescent_white,
				material = Enum.Material.Neon,
				canCollide = false,
				castShadow = false,
			}
		)
	end
end

local function buildLobby(parent)
	local zone = createZoneFolder(parent, "Lobby", 1)

	makePart(
		zone,
		"ThresholdStrip",
		Vector3.new(18, 0.12, 3.5),
		CFrame.new(0, floorTopY + 0.06, -30),
		{
			color = Color3.fromRGB(86, 94, 104),
			material = Enum.Material.Metal,
			canCollide = false,
			castShadow = false,
		}
	)
	makeSign(
		zone,
		"BrandWall",
		Vector3.new(18, 4.5, 0.2),
		CFrame.new(0, floorTopY + 8.5, -37.35),
		StoreSignage.Brand.wordmark,
		{
			backgroundColor = palette.night_blue,
			textColor = palette.fluorescent_white,
			strokeColor = palette.charcoal,
			pixelsPerStud = 42,
		}
	)
	makeSign(
		zone,
		"BrandTag",
		Vector3.new(4, 1.3, 0.22),
		CFrame.new(11.2, floorTopY + 6.1, -37.2),
		StoreSignage.Brand.tag,
		{
			backgroundColor = palette.payroll_green,
			textColor = palette.charcoal,
			strokeColor = palette.charcoal,
			pixelsPerStud = 34,
		}
	)
	makeSign(
		zone,
		"HoursCard",
		Vector3.new(5.2, 1.1, 0.16),
		CFrame.new(-12.5, floorTopY + 5.1, -37.2),
		StoreSignage.Brand.supportLine,
		{
			backgroundColor = palette.receipt_cream,
			textColor = palette.charcoal,
			strokeColor = palette.charcoal,
			pixelsPerStud = 28,
		}
	)

	makePart(
		zone,
		"PromoStand",
		Vector3.new(5, 2.8, 2.4),
		CFrame.new(-18, floorTopY + 1.4, -27.5),
		{
			color = Color3.fromRGB(134, 114, 88),
			material = Enum.Material.WoodPlanks,
			canCollide = false,
		}
	)
	makeSign(
		zone,
		"PromoCard",
		Vector3.new(3.4, 1.2, 0.16),
		CFrame.new(-18, floorTopY + 3.4, -26.22),
		StoreSignage.SaleCards[1].copy,
		{
			backgroundColor = palette.safety_red,
			textColor = palette.fluorescent_white,
			strokeColor = palette.charcoal,
			pixelsPerStud = 30,
		}
	)

	for index = 0, 3 do
		makePart(
			zone,
			"Basket",
			Vector3.new(1.2, 0.4, 1.6),
			CFrame.new(18, floorTopY + 0.2 + (index * 0.28), -29),
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
			CFrame.new(24, floorTopY + 0.8, -24 + (index * 3.6)),
			{
				color = Color3.fromRGB(176, 178, 182),
				material = Enum.Material.Metal,
				canCollide = false,
			}
		)
	end
end

local function buildCheckout(parent)
	local zone = createZoneFolder(parent, "Checkout", 2)

	makePart(
		zone,
		"CheckoutFloorAccent",
		Vector3.new(26, 0.12, 11),
		CFrame.new(0, floorTopY + 0.06, -18),
		{
			color = Color3.fromRGB(98, 98, 104),
			material = Enum.Material.Metal,
			canCollide = false,
			castShadow = false,
		}
	)
	makeCounter(zone, CFrame.new(-9, floorTopY, -18), StoreSignage.Checkout[1].copy)
	makeCounter(zone, CFrame.new(9, floorTopY, -18), StoreSignage.Checkout[2].copy)
	makeSign(
		zone,
		"CashOutSign",
		Vector3.new(8.5, 1.25, 0.16),
		CFrame.new(0, floorTopY + 8.5, -12.6),
		StoreSignage.Checkout[3].copy,
		{
			backgroundColor = palette.receipt_cream,
			textColor = palette.charcoal,
			strokeColor = palette.charcoal,
			pixelsPerStud = 32,
		}
	)
	makeQueueRail(zone, CFrame.new(-7, floorTopY, -12), 8)
	makeQueueRail(zone, CFrame.new(7, floorTopY, -12), 8)
	makeQueueRail(zone, CFrame.new(0, floorTopY, -9), 10)
end

local function buildHeroAisle(parent)
	local zone = createZoneFolder(parent, "HeroAisle", 3)

	makePart(
		zone,
		"AisleRunner",
		Vector3.new(16, 0.08, 22),
		CFrame.new(-20, floorTopY + 0.04, -2),
		{
			color = Color3.fromRGB(163, 165, 170),
			material = Enum.Material.SmoothPlastic,
			canCollide = false,
			castShadow = false,
		}
	)
	makeShelfBay(zone, CFrame.new(-25.5, floorTopY, -3.8), StoreSignage.Aisles[5].label)
	makeShelfBay(
		zone,
		CFrame.new(-14.5, floorTopY, -3.8) * CFrame.Angles(0, math.rad(180), 0),
		StoreSignage.Aisles[5].label
	)
	makeShelfBay(zone, CFrame.new(-25.5, floorTopY, 8.4), StoreSignage.Aisles[5].label)
	makeShelfBay(
		zone,
		CFrame.new(-14.5, floorTopY, 8.4) * CFrame.Angles(0, math.rad(180), 0),
		StoreSignage.Aisles[5].label
	)
	makeSign(
		zone,
		"AisleNumber",
		Vector3.new(2.8, 1.2, 0.16),
		CFrame.new(-20, floorTopY + 9.6, -13.5),
		StoreSignage.Aisles[5].numeral,
		{
			backgroundColor = palette.night_blue,
			textColor = palette.fluorescent_white,
			strokeColor = palette.charcoal,
			pixelsPerStud = 42,
			doubleSided = true,
		}
	)
	makeSign(
		zone,
		"EndcapSale",
		Vector3.new(3.6, 1.4, 0.16),
		CFrame.new(-20, floorTopY + 4.4, 14.3),
		StoreSignage.SaleCards[2].copy,
		{
			backgroundColor = palette.safety_red,
			textColor = palette.fluorescent_white,
			strokeColor = palette.charcoal,
			pixelsPerStud = 30,
		}
	)
	makeBox(zone, "EndcapBox", Vector3.new(2.1, 1.4, 1.8), CFrame.new(-20, floorTopY + 0.7, 12.4))
end

local function buildFreezer(parent)
	local zone = createZoneFolder(parent, "Freezer", 4)

	makePart(zone, "ColdFloor", Vector3.new(22, 0.12, 9), CFrame.new(0, floorTopY + 0.06, 24), {
		color = Color3.fromRGB(181, 196, 207),
		material = Enum.Material.SmoothPlastic,
		canCollide = false,
		castShadow = false,
	})
	makeFreezerCase(zone, CFrame.new(-10, floorTopY, 25), StoreSignage.Freezer[1].copy)
	makeFreezerCase(zone, CFrame.new(0, floorTopY, 25), StoreSignage.Freezer[2].copy)
	makeFreezerCase(zone, CFrame.new(10, floorTopY, 25), StoreSignage.Freezer[3].copy)
end

local function buildStockroom(parent)
	local zone = createZoneFolder(parent, "Stockroom", 5)

	makePart(zone, "BackroomWallA", Vector3.new(1, 14, 16), CFrame.new(28, floorTopY + 7, 18), {
		color = Color3.fromRGB(121, 110, 98),
		material = Enum.Material.Concrete,
		canCollide = false,
	})
	makePart(zone, "BackroomWallB", Vector3.new(14, 14, 1), CFrame.new(21.5, floorTopY + 7, 25.5), {
		color = Color3.fromRGB(121, 110, 98),
		material = Enum.Material.Concrete,
		canCollide = false,
	})
	makePart(
		zone,
		"BackroomFloor",
		Vector3.new(14, 0.12, 14),
		CFrame.new(22, floorTopY + 0.06, 18),
		{
			color = Color3.fromRGB(102, 92, 83),
			material = Enum.Material.Concrete,
			canCollide = false,
			castShadow = false,
		}
	)
	makePart(
		zone,
		"UtilityLight",
		Vector3.new(5, 0.28, 2.2),
		CFrame.new(22, floorTopY + 10.8, 18),
		{
			color = palette.sodium_amber,
			material = Enum.Material.Neon,
			canCollide = false,
			castShadow = false,
		}
	)
	makeSign(
		zone,
		"EmployeesOnly",
		Vector3.new(6, 1.2, 0.16),
		CFrame.new(28.05, floorTopY + 7.6, 14.8) * CFrame.Angles(0, math.rad(-90), 0),
		StoreSignage.Stockroom[1].copy,
		{
			backgroundColor = palette.safety_red,
			textColor = palette.fluorescent_white,
			strokeColor = palette.charcoal,
			pixelsPerStud = 30,
		}
	)
	makeSign(
		zone,
		"PayrollBoard",
		Vector3.new(4.2, 2, 0.16),
		CFrame.new(18.2, floorTopY + 6.2, 25.05),
		StoreSignage.Stockroom[3].copy,
		{
			backgroundColor = palette.receipt_cream,
			textColor = palette.charcoal,
			strokeColor = palette.charcoal,
			pixelsPerStud = 24,
		}
	)
	makePalletStack(zone, CFrame.new(22.5, floorTopY, 20))
	makePart(
		zone,
		"MopBucket",
		Vector3.new(1.4, 1.2, 1.2),
		CFrame.new(16.5, floorTopY + 0.6, 14.5),
		{
			color = palette.sodium_amber,
			material = Enum.Material.Metal,
			canCollide = false,
		}
	)
	makeSign(
		zone,
		"SafetyCheck",
		Vector3.new(3.8, 1, 0.16),
		CFrame.new(18.1, floorTopY + 3.6, 25.05),
		StoreSignage.Stockroom[4].copy,
		{
			backgroundColor = palette.night_blue,
			textColor = palette.fluorescent_white,
			strokeColor = palette.charcoal,
			pixelsPerStud = 24,
		}
	)
end

local function buildSlice()
	ensureFloor()
	ensureSpawn()

	local sliceFolder = resetSliceFolder()
	buildArtHooks(sliceFolder)
	buildBackdropWalls(sliceFolder)
	buildLobby(sliceFolder)
	buildCheckout(sliceFolder)
	buildHeroAisle(sliceFolder)
	buildFreezer(sliceFolder)
	buildStockroom(sliceFolder)
end

buildSlice()
