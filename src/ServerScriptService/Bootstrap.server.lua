local ServerScriptService = game:GetService("ServerScriptService")

local roundFolder = ServerScriptService:WaitForChild("Round")
local shiftService = require(roundFolder:WaitForChild("ShiftService"))

shiftService.start()
