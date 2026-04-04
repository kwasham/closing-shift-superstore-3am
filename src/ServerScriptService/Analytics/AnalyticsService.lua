local HttpService = game:GetService("HttpService")
local ServerScriptService = game:GetService("ServerScriptService")

local AnalyticsService = {}

local function isDebugLoggingEnabled()
	local ok, config = pcall(function()
		return require(ServerScriptService:WaitForChild("Round"):WaitForChild("Config"))
	end)
	if not ok or type(config) ~= "table" or type(config.softLaunch) ~= "table" then
		return true
	end
	return config.softLaunch.analytics_debug_logging_enabled ~= false
end

local recentEvents = {}
local maxRecentEvents = 256

local function pushRecent(eventName, payload)
	table.insert(recentEvents, {
		eventName = eventName,
		payload = table.clone(payload),
	})
	if #recentEvents > maxRecentEvents then
		table.remove(recentEvents, 1)
	end
end

local function withCommonFields(eventName, payload)
	local merged = table.clone(payload)

	if merged.server_job_id == nil then
		merged.server_job_id = game.JobId ~= "" and game.JobId or "studio"
	end
	if merged.ts_unix == nil then
		merged.ts_unix = os.time()
	end

	pushRecent(eventName, merged)
	if isDebugLoggingEnabled() then
		print(string.format("[analytics] %s %s", eventName, HttpService:JSONEncode(merged)))
	end
	return merged
end

function AnalyticsService.emit(eventName, payload)
	return withCommonFields(eventName, payload)
end

function AnalyticsService.getRecentEvents()
	local snapshot = {}
	for index, entry in ipairs(recentEvents) do
		snapshot[index] = {
			eventName = entry.eventName,
			payload = table.clone(entry.payload),
		}
	end
	return snapshot
end

function AnalyticsService.clearRecentEvents()
	table.clear(recentEvents)
end

return AnalyticsService
