local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local VisualTheme = require(Shared:WaitForChild("VisualTheme"))

local LightingPresets = {}

local palette = VisualTheme.Palette

LightingPresets.Order = {
	VisualTheme.LightingStates.Normal,
	VisualTheme.LightingStates.Blackout,
	VisualTheme.LightingStates.Mimic,
	VisualTheme.LightingStates.RoundSuccess,
	VisualTheme.LightingStates.RoundFailure,
}

LightingPresets.EffectNames = {
	Atmosphere = "Sprint6Atmosphere",
	ColorCorrection = "Sprint6ColorCorrection",
	Bloom = "Sprint6Bloom",
	SunRays = "Sprint6SunRays",
}

LightingPresets.Presets = {
	[VisualTheme.LightingStates.Normal] = {
		lighting = {
			Ambient = Color3.fromRGB(112, 118, 126),
			OutdoorAmbient = Color3.fromRGB(96, 104, 114),
			Brightness = 2.15,
			ClockTime = 2.35,
			EnvironmentDiffuseScale = 0.28,
			EnvironmentSpecularScale = 0.16,
			ExposureCompensation = -0.08,
			FogColor = Color3.fromRGB(191, 197, 205),
			FogStart = 0,
			FogEnd = 385,
			GlobalShadows = true,
		},
		atmosphere = {
			Density = 0.23,
			Offset = 0.12,
			Color = palette.fluorescent_white,
			Decay = palette.tile_gray,
			Glare = 0.06,
			Haze = 1.3,
		},
		colorCorrection = {
			Brightness = 0.01,
			Contrast = 0.08,
			Saturation = -0.04,
			TintColor = palette.fluorescent_white,
			Enabled = true,
		},
		bloom = {
			Enabled = true,
			Intensity = 0.12,
			Size = 18,
			Threshold = 1.55,
		},
		sunRays = {
			Enabled = true,
			Intensity = 0.01,
			Spread = 0.82,
		},
	},
	[VisualTheme.LightingStates.Blackout] = {
		lighting = {
			Ambient = Color3.fromRGB(34, 45, 61),
			OutdoorAmbient = Color3.fromRGB(21, 27, 37),
			Brightness = 0.82,
			ClockTime = 2.35,
			EnvironmentDiffuseScale = 0.2,
			EnvironmentSpecularScale = 0.08,
			ExposureCompensation = -0.34,
			FogColor = Color3.fromRGB(36, 48, 68),
			FogStart = 0,
			FogEnd = 265,
			GlobalShadows = true,
		},
		atmosphere = {
			Density = 0.3,
			Offset = 0.18,
			Color = Color3.fromRGB(72, 90, 120),
			Decay = palette.night_blue,
			Glare = 0,
			Haze = 2.35,
		},
		colorCorrection = {
			Brightness = -0.04,
			Contrast = 0.18,
			Saturation = -0.18,
			TintColor = Color3.fromRGB(189, 205, 228),
			Enabled = true,
		},
		bloom = {
			Enabled = true,
			Intensity = 0.04,
			Size = 14,
			Threshold = 1.9,
		},
		sunRays = {
			Enabled = false,
			Intensity = 0,
			Spread = 0.8,
		},
	},
	[VisualTheme.LightingStates.Mimic] = {
		lighting = {
			Ambient = Color3.fromRGB(104, 105, 126),
			OutdoorAmbient = Color3.fromRGB(82, 84, 110),
			Brightness = 1.96,
			ClockTime = 2.35,
			EnvironmentDiffuseScale = 0.26,
			EnvironmentSpecularScale = 0.14,
			ExposureCompensation = -0.12,
			FogColor = Color3.fromRGB(145, 139, 181),
			FogStart = 0,
			FogEnd = 320,
			GlobalShadows = true,
		},
		atmosphere = {
			Density = 0.24,
			Offset = 0.14,
			Color = Color3.fromRGB(180, 170, 214),
			Decay = Color3.fromRGB(72, 63, 102),
			Glare = 0.02,
			Haze = 1.65,
		},
		colorCorrection = {
			Brightness = -0.01,
			Contrast = 0.13,
			Saturation = -0.08,
			TintColor = Color3.fromRGB(223, 214, 255),
			Enabled = true,
		},
		bloom = {
			Enabled = true,
			Intensity = 0.09,
			Size = 20,
			Threshold = 1.45,
		},
		sunRays = {
			Enabled = true,
			Intensity = 0.006,
			Spread = 0.78,
		},
	},
	[VisualTheme.LightingStates.RoundSuccess] = {
		lighting = {
			Ambient = Color3.fromRGB(126, 122, 110),
			OutdoorAmbient = Color3.fromRGB(106, 104, 96),
			Brightness = 2.35,
			ClockTime = 2.35,
			EnvironmentDiffuseScale = 0.32,
			EnvironmentSpecularScale = 0.18,
			ExposureCompensation = 0.06,
			FogColor = Color3.fromRGB(225, 219, 200),
			FogStart = 0,
			FogEnd = 360,
			GlobalShadows = true,
		},
		atmosphere = {
			Density = 0.2,
			Offset = 0.08,
			Color = palette.receipt_cream,
			Decay = Color3.fromRGB(182, 195, 177),
			Glare = 0.08,
			Haze = 1.1,
		},
		colorCorrection = {
			Brightness = 0.04,
			Contrast = 0.08,
			Saturation = -0.02,
			TintColor = Color3.fromRGB(234, 245, 228),
			Enabled = true,
		},
		bloom = {
			Enabled = true,
			Intensity = 0.15,
			Size = 22,
			Threshold = 1.35,
		},
		sunRays = {
			Enabled = true,
			Intensity = 0.014,
			Spread = 0.82,
		},
	},
	[VisualTheme.LightingStates.RoundFailure] = {
		lighting = {
			Ambient = Color3.fromRGB(102, 82, 72),
			OutdoorAmbient = Color3.fromRGB(76, 59, 51),
			Brightness = 1.68,
			ClockTime = 2.35,
			EnvironmentDiffuseScale = 0.24,
			EnvironmentSpecularScale = 0.1,
			ExposureCompensation = -0.16,
			FogColor = Color3.fromRGB(132, 96, 74),
			FogStart = 0,
			FogEnd = 300,
			GlobalShadows = true,
		},
		atmosphere = {
			Density = 0.25,
			Offset = 0.12,
			Color = Color3.fromRGB(189, 146, 101),
			Decay = Color3.fromRGB(88, 52, 44),
			Glare = 0.03,
			Haze = 1.8,
		},
		colorCorrection = {
			Brightness = -0.02,
			Contrast = 0.14,
			Saturation = -0.1,
			TintColor = Color3.fromRGB(245, 220, 193),
			Enabled = true,
		},
		bloom = {
			Enabled = true,
			Intensity = 0.08,
			Size = 18,
			Threshold = 1.6,
		},
		sunRays = {
			Enabled = false,
			Intensity = 0,
			Spread = 0.8,
		},
	},
}

local function ensureEffect(lighting, className, effectName)
	local effect = lighting:FindFirstChild(effectName)
	if effect ~= nil and not effect:IsA(className) then
		effect:Destroy()
		effect = nil
	end

	if effect == nil then
		effect = Instance.new(className)
		effect.Name = effectName
		effect.Parent = lighting
	end

	return effect
end

function LightingPresets.ensureRig(lighting)
	return {
		atmosphere = ensureEffect(lighting, "Atmosphere", LightingPresets.EffectNames.Atmosphere),
		colorCorrection = ensureEffect(
			lighting,
			"ColorCorrectionEffect",
			LightingPresets.EffectNames.ColorCorrection
		),
		bloom = ensureEffect(lighting, "BloomEffect", LightingPresets.EffectNames.Bloom),
		sunRays = ensureEffect(lighting, "SunRaysEffect", LightingPresets.EffectNames.SunRays),
	}
end

local function applyProperties(instance, properties)
	for propertyName, value in pairs(properties) do
		instance[propertyName] = value
	end
end

function LightingPresets.getPreset(presetName)
	return LightingPresets.Presets[presetName]
		or LightingPresets.Presets[VisualTheme.LightingStates.Normal]
end

function LightingPresets.applyPreset(lighting, presetName)
	local resolvedName = if LightingPresets.Presets[presetName] ~= nil
		then presetName
		else VisualTheme.LightingStates.Normal
	local preset = LightingPresets.getPreset(resolvedName)
	local rig = LightingPresets.ensureRig(lighting)

	applyProperties(lighting, preset.lighting)
	applyProperties(rig.atmosphere, preset.atmosphere)
	applyProperties(rig.colorCorrection, preset.colorCorrection)
	applyProperties(rig.bloom, preset.bloom)
	applyProperties(rig.sunRays, preset.sunRays)
	lighting:SetAttribute("ShiftLightingPreset", resolvedName)

	return resolvedName
end

return LightingPresets
