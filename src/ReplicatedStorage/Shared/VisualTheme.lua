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

return VisualTheme
