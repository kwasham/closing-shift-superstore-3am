local VisualTheme = {}

local palette = {
	fluorescent_white = Color3.fromRGB(233, 240, 236),
	tile_gray = Color3.fromRGB(174, 178, 184),
	powder_blue = Color3.fromRGB(134, 166, 198),
	safety_red = Color3.fromRGB(176, 68, 70),
	receipt_cream = Color3.fromRGB(245, 238, 222),
	sodium_amber = Color3.fromRGB(211, 162, 96),
	mimic_violet = Color3.fromRGB(128, 96, 186),
	night_blue = Color3.fromRGB(28, 38, 57),
	payroll_green = Color3.fromRGB(96, 170, 118),
	charcoal = Color3.fromRGB(19, 23, 29),
	charcoal_soft = Color3.fromRGB(30, 35, 43),
	ink = Color3.fromRGB(39, 42, 48),
	paper_shadow = Color3.fromRGB(220, 212, 195),
	emergency_green = Color3.fromRGB(124, 214, 156),
	emergency_blue = Color3.fromRGB(168, 206, 255),
	cooler_teal = Color3.fromRGB(141, 201, 218),
	sign_amber = Color3.fromRGB(231, 196, 124),
}

VisualTheme.Palette = palette

VisualTheme.LightingStates = {
	Normal = "normal",
	Blackout = "blackout",
	Mimic = "mimic",
	RoundSuccess = "round_success",
	RoundFailure = "round_failure",
}

VisualTheme.Presentation = {
	MimicLightingDuration = 2.6,
}

VisualTheme.ArtSlice = {
	ZoneOrder = { "Lobby", "Checkout", "HeroAisle", "Freezer", "Stockroom" },
	CaptureHooks = {
		"LobbyCaptureAnchor",
		"CheckoutCaptureAnchor",
		"HeroAisleCaptureAnchor",
		"FreezerCaptureAnchor",
		"StockroomCaptureAnchor",
	},
	SignageHooks = {
		"LobbyBrandHook",
		"CheckoutSignHook",
		"HeroAisleHeaderHook",
		"FreezerHeaderHook",
		"StockroomNoticeHook",
	},
}

VisualTheme.StoreRollout = {
	RootFolderName = "FallbackArtSlice",
	HooksFolderName = "Sprint7ArtHooks",
	RuntimeGroupsFolderName = "Sprint7RuntimeGroups",
	TierAZoneOrder = {
		"Lobby",
		"EntranceTransition",
		"Checkout",
		"Queue",
		"AislesWest",
		"AislesCenter",
		"AislesEast",
		"FreezerTransition",
		"Freezer",
		"StockroomTransition",
		"Stockroom",
	},
	TierBZoneOrder = {
		"Perimeter",
		"StaffHall",
		"SightlineCeiling",
		"SecondaryEndcaps",
		"TaskCorners",
	},
	RuntimeGroups = {
		"AisleMarkers",
		"CategoryHeaders",
		"CheckoutMarkers",
		"StaffSigns",
		"SaleCards",
		"EmergencyRead",
		"FixtureBanks",
		"BrandSigns",
		"PlaceholderMasks",
	},
	CaptureHooks = {
		"LobbyCaptureAnchor",
		"CheckoutCaptureAnchor",
		"AisleWestCaptureAnchor",
		"AisleCenterCaptureAnchor",
		"AisleEastCaptureAnchor",
		"FreezerCaptureAnchor",
		"StockroomCaptureAnchor",
		"FrontContinuityAnchor",
		"FreezerContinuityAnchor",
		"StockroomContinuityAnchor",
		"BlackoutReadAnchor",
		"MimicReadAnchor",
		"UpdateShotAnchor",
	},
	SignageHooks = {
		"LobbyBrandHook",
		"CheckoutHeaderHook",
		"AisleWestHook",
		"AisleCenterHook",
		"AisleEastHook",
		"FreezerHeaderHook",
		"StockroomDoorHook",
		"ExitHook",
	},
}

VisualTheme.WorldStateStyles = {
	[VisualTheme.LightingStates.Normal] = {
		FixtureBanks = { mode = "base", material = Enum.Material.Neon },
		EmergencyRead = {
			color = palette.emergency_green,
			transparency = 0.02,
			material = Enum.Material.Neon,
		},
		AisleMarkers = { mode = "base", transparency = 0 },
		CategoryHeaders = { mode = "base", transparency = 0 },
		CheckoutMarkers = { mode = "base", transparency = 0 },
		StaffSigns = { mode = "base", transparency = 0 },
		SaleCards = { mode = "base", transparency = 0 },
		BrandSigns = { mode = "base", transparency = 0 },
	},
	[VisualTheme.LightingStates.Blackout] = {
		FixtureBanks = {
			color = Color3.fromRGB(82, 93, 112),
			transparency = 0.24,
			material = Enum.Material.SmoothPlastic,
		},
		EmergencyRead = {
			color = palette.emergency_green,
			transparency = 0.01,
			material = Enum.Material.Neon,
		},
		AisleMarkers = {
			color = palette.emergency_blue,
			transparency = 0.04,
			material = Enum.Material.SmoothPlastic,
		},
		CategoryHeaders = {
			color = Color3.fromRGB(196, 208, 225),
			transparency = 0.08,
			material = Enum.Material.SmoothPlastic,
		},
		CheckoutMarkers = {
			color = palette.receipt_cream,
			transparency = 0.04,
			material = Enum.Material.SmoothPlastic,
		},
		StaffSigns = {
			color = palette.emergency_green,
			transparency = 0.02,
			material = Enum.Material.SmoothPlastic,
		},
		SaleCards = {
			color = Color3.fromRGB(103, 88, 94),
			transparency = 0.16,
			material = Enum.Material.SmoothPlastic,
		},
		BrandSigns = {
			color = Color3.fromRGB(160, 178, 205),
			transparency = 0.08,
			material = Enum.Material.SmoothPlastic,
		},
	},
	[VisualTheme.LightingStates.Mimic] = {
		FixtureBanks = {
			color = Color3.fromRGB(171, 159, 214),
			transparency = 0.1,
			material = Enum.Material.Neon,
		},
		EmergencyRead = {
			color = palette.emergency_green,
			transparency = 0.03,
			material = Enum.Material.Neon,
		},
		AisleMarkers = {
			color = Color3.fromRGB(232, 221, 255),
			transparency = 0.02,
			material = Enum.Material.SmoothPlastic,
		},
		CategoryHeaders = {
			color = Color3.fromRGB(208, 192, 244),
			transparency = 0.02,
			material = Enum.Material.SmoothPlastic,
		},
		CheckoutMarkers = {
			color = Color3.fromRGB(229, 216, 255),
			transparency = 0.02,
			material = Enum.Material.SmoothPlastic,
		},
		StaffSigns = {
			color = Color3.fromRGB(195, 178, 232),
			transparency = 0.04,
			material = Enum.Material.SmoothPlastic,
		},
		SaleCards = {
			color = palette.mimic_violet,
			transparency = 0.04,
			material = Enum.Material.SmoothPlastic,
		},
		BrandSigns = {
			color = Color3.fromRGB(189, 170, 236),
			transparency = 0.04,
			material = Enum.Material.SmoothPlastic,
		},
	},
	[VisualTheme.LightingStates.RoundSuccess] = {
		FixtureBanks = {
			color = palette.fluorescent_white,
			transparency = 0.02,
			material = Enum.Material.Neon,
		},
		EmergencyRead = {
			color = palette.emergency_green,
			transparency = 0.02,
			material = Enum.Material.Neon,
		},
		AisleMarkers = {
			color = Color3.fromRGB(221, 241, 228),
			transparency = 0,
			material = Enum.Material.SmoothPlastic,
		},
		CategoryHeaders = {
			color = Color3.fromRGB(207, 230, 213),
			transparency = 0,
			material = Enum.Material.SmoothPlastic,
		},
		CheckoutMarkers = {
			color = Color3.fromRGB(214, 240, 220),
			transparency = 0,
			material = Enum.Material.SmoothPlastic,
		},
		StaffSigns = {
			color = Color3.fromRGB(214, 232, 218),
			transparency = 0.02,
			material = Enum.Material.SmoothPlastic,
		},
		SaleCards = {
			color = Color3.fromRGB(176, 84, 84),
			transparency = 0,
			material = Enum.Material.SmoothPlastic,
		},
		BrandSigns = {
			color = Color3.fromRGB(205, 231, 212),
			transparency = 0,
			material = Enum.Material.SmoothPlastic,
		},
	},
	[VisualTheme.LightingStates.RoundFailure] = {
		FixtureBanks = {
			color = Color3.fromRGB(183, 155, 121),
			transparency = 0.08,
			material = Enum.Material.Neon,
		},
		EmergencyRead = {
			color = palette.sign_amber,
			transparency = 0.04,
			material = Enum.Material.Neon,
		},
		AisleMarkers = {
			color = Color3.fromRGB(239, 221, 188),
			transparency = 0.02,
			material = Enum.Material.SmoothPlastic,
		},
		CategoryHeaders = {
			color = Color3.fromRGB(214, 187, 149),
			transparency = 0.04,
			material = Enum.Material.SmoothPlastic,
		},
		CheckoutMarkers = {
			color = Color3.fromRGB(233, 204, 176),
			transparency = 0.02,
			material = Enum.Material.SmoothPlastic,
		},
		StaffSigns = {
			color = Color3.fromRGB(206, 174, 145),
			transparency = 0.04,
			material = Enum.Material.SmoothPlastic,
		},
		SaleCards = {
			color = Color3.fromRGB(146, 91, 73),
			transparency = 0.05,
			material = Enum.Material.SmoothPlastic,
		},
		BrandSigns = {
			color = Color3.fromRGB(218, 189, 161),
			transparency = 0.04,
			material = Enum.Material.SmoothPlastic,
		},
	},
}

VisualTheme.HUD = {
	ShellBackground = palette.charcoal,
	ShellStroke = palette.fluorescent_white,
	HeaderBackground = palette.night_blue,
	HeaderText = palette.fluorescent_white,
	HeaderAccent = palette.payroll_green,
	ReceiptBackground = palette.receipt_cream,
	ReceiptStroke = palette.paper_shadow,
	ReceiptHeading = palette.ink,
	ReceiptBody = Color3.fromRGB(61, 64, 70),
	ReceiptAccent = palette.night_blue,
	AlertDefaultBackground = palette.charcoal_soft,
	AlertDefaultText = palette.fluorescent_white,
	AlertDefaultStroke = palette.fluorescent_white,
	BlackoutOverlayColor = palette.night_blue,
	BlackoutOverlayTransparency = 0.24,
}

VisualTheme.AlertStyles = {
	default = {
		backgroundColor = palette.charcoal_soft,
		textColor = palette.fluorescent_white,
		strokeColor = palette.fluorescent_white,
		strokeTransparency = 0.7,
	},
	tutorial = {
		backgroundColor = palette.night_blue,
		textColor = palette.fluorescent_white,
		strokeColor = palette.payroll_green,
		strokeTransparency = 0.58,
	},
	blackout = {
		backgroundColor = Color3.fromRGB(26, 36, 56),
		textColor = Color3.fromRGB(220, 234, 255),
		strokeColor = Color3.fromRGB(126, 166, 220),
		strokeTransparency = 0.52,
	},
	mimic = {
		backgroundColor = Color3.fromRGB(48, 34, 73),
		textColor = Color3.fromRGB(241, 231, 255),
		strokeColor = palette.mimic_violet,
		strokeTransparency = 0.45,
	},
	success = {
		backgroundColor = Color3.fromRGB(228, 239, 224),
		textColor = Color3.fromRGB(49, 82, 58),
		strokeColor = palette.payroll_green,
		strokeTransparency = 0.42,
	},
	failure = {
		backgroundColor = Color3.fromRGB(71, 49, 41),
		textColor = Color3.fromRGB(248, 231, 213),
		strokeColor = palette.sodium_amber,
		strokeTransparency = 0.4,
	},
	warning = {
		backgroundColor = Color3.fromRGB(77, 43, 41),
		textColor = Color3.fromRGB(255, 234, 225),
		strokeColor = palette.safety_red,
		strokeTransparency = 0.38,
	},
}

VisualTheme.AlertStyleById = {
	blackout_active = "blackout",
	blackout_end = "tutorial",
	mimic_triggered = "mimic",
	register_unlocked = "success",
	round_success = "success",
	round_failure = "failure",
	security_alarm_active = "warning",
	security_alarm_reset = "tutorial",
	security_alarm_failed = "failure",
	round_start_hint = "tutorial",
	tutorial_goal = "tutorial",
	tutorial_follow_task = "tutorial",
	tutorial_banked_pay = "tutorial",
	tutorial_register_end = "success",
}

VisualTheme.NodeStyles = {
	available = {
		useBaseColor = true,
		outlineColor = palette.fluorescent_white,
		fillTransparency = 0.9,
		outlineTransparency = 0.18,
		pulse = 0.05,
	},
	register_locked = {
		fillColor = Color3.fromRGB(104, 110, 132),
		outlineColor = Color3.fromRGB(212, 219, 232),
		fillTransparency = 0.96,
		outlineTransparency = 0.42,
		pulse = 0.02,
	},
	register_ready = {
		fillColor = Color3.fromRGB(236, 204, 118),
		outlineColor = palette.receipt_cream,
		fillTransparency = 0.8,
		outlineTransparency = 0.04,
		pulse = 0.08,
	},
	blackout = {
		fillColor = Color3.fromRGB(45, 69, 110),
		outlineColor = Color3.fromRGB(171, 199, 255),
		fillTransparency = 0.96,
		outlineTransparency = 0.58,
		pulse = 0.02,
	},
	mimic_lockout = {
		fillColor = palette.mimic_violet,
		outlineColor = Color3.fromRGB(241, 231, 255),
		fillTransparency = 0.88,
		outlineTransparency = 0.12,
		pulse = 0.05,
	},
	cooldown = {
		useBaseColor = true,
		outlineColor = palette.tile_gray,
		fillTransparency = 0.98,
		outlineTransparency = 0.78,
		pulse = 0,
	},
	completed = {
		useBaseColor = true,
		outlineColor = palette.tile_gray,
		fillTransparency = 1,
		outlineTransparency = 0.9,
		pulse = 0,
	},
	register_closed = {
		useBaseColor = true,
		outlineColor = palette.tile_gray,
		fillTransparency = 1,
		outlineTransparency = 0.9,
		pulse = 0,
	},
	waiting = {
		useBaseColor = true,
		outlineColor = Color3.fromRGB(150, 150, 150),
		fillTransparency = 1,
		outlineTransparency = 0.95,
		pulse = 0,
	},
}

function VisualTheme.getAlertStyle(alertId)
	local styleKey = VisualTheme.AlertStyleById[alertId] or "default"
	return VisualTheme.AlertStyles[styleKey], styleKey
end

function VisualTheme.getNodeStyle(state)
	return VisualTheme.NodeStyles[state] or VisualTheme.NodeStyles.waiting
end

function VisualTheme.getWorldStateStyle(stateName, groupName)
	local stateStyles = VisualTheme.WorldStateStyles[stateName]
	if stateStyles == nil then
		stateStyles = VisualTheme.WorldStateStyles[VisualTheme.LightingStates.Normal]
	end
	return stateStyles[groupName] or { mode = "base" }
end

return VisualTheme
