local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RoundFolder = script.Parent
local Config = require(RoundFolder:WaitForChild("Config"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RoundStateChanged = Remotes:WaitForChild("RoundStateChanged")
local TaskProgressChanged = Remotes:WaitForChild("TaskProgressChanged")
local AlertRaised = Remotes:WaitForChild("AlertRaised")

local ShiftService = {}

local currentState = "Waiting"
local progress = {
	total = 0,
	completed = 0,
}

local function broadcastState()
	RoundStateChanged:FireAllClients({
		state = currentState,
		progress = progress,
	})
end

local function broadcastProgress()
	TaskProgressChanged:FireAllClients(progress)
end

local function alert(message: string)
	AlertRaised:FireAllClients(message)
end

function ShiftService.setState(nextState: string)
	currentState = nextState
	broadcastState()
end

function ShiftService.resetProgress(totalTasks: number)
	progress.total = totalTasks
	progress.completed = 0
	broadcastProgress()
end

function ShiftService.completeTask()
	progress.completed += 1
	broadcastProgress()
end

function ShiftService.start()
	task.spawn(function()
		while true do
			if #Players:GetPlayers() < Config.minPlayers then
				ShiftService.setState("Waiting")
				task.wait(2)
				continue
			end

			ShiftService.setState("Intermission")
			alert("Get ready for the next closing shift.")
			task.wait(Config.intermissionSeconds)

			ShiftService.setState("Playing")
			ShiftService.resetProgress(6)
			alert("Clock in. Finish the store tasks before time runs out.")

			task.wait(Config.durationSeconds)

			ShiftService.setState("Ended")
			alert("Shift over.")
			task.wait(5)
		end
	end)
end

return ShiftService
