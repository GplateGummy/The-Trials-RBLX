--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local TrailParts = Workspace:FindFirstChild("TrialParts")

if not TrailParts then return end

--// Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--// Main GUI Window
local Window = Rayfield:CreateWindow({
	Name = "Trial GUI",
	LoadingTitle = "Rayfield Interface Suite",
	LoadingSubtitle = "Trial Control Panel",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil,
		FileName = "Trails"
	},
	Discord = {
		Enabled = false,
		Invite = "noinvitelink",
		RememberJoins = true
	},
	KeySystem = false
})

--// Main Tab
local Tab = Window:CreateTab("Trials", "settings")

--// Utility Functions
local function SnapToGrid(value)
	return math.floor(value * 100) / 100
end

--// Trial 1

if fireclickdetector then
	local Section = Tab:CreateSection("Trial 1")

	local Trail1Folder = TrailParts:FindFirstChild("Trial1")

	if Trail1Folder then
		Tab:CreateButton({
			Name = "Press Button",
			Callback = function()
				-- Add Trial 1 logic here
				print("Trial 1: Auto Press Button")
			end
		})

		Tab:CreateButton({
			Name = "Enable Auto Press Button",
			Callback = function()
				-- Add Trial 1 logic here
				print("Trial 1: Auto Press Button")
			end
		})

		Tab:CreateButton({
			Name = "Disable Auto Press Button",
			Callback = function()
				-- Add Trial 1 logic here
				print("Trial 1: Auto Press Button")
			end
		})

	end
end

--// Trial 2

local Section = Tab:CreateSection("Trial 2")

local Trail2Folder = TrailParts:FindFirstChild("Trial2")

if Trail2Folder then

	local Crates = Trail2Folder:FindFirstChild("Crates")
	local UsedCrates = Trail2Folder:FindFirstChild("UsedCrates")
	local Chambers = Trail2Folder:FindFirstChild("Chambers")

	if Crates and UsedCrates and Chambers then

		local AllCrates = {}

		for _, Crate in ipairs(Crates:GetChildren()) do
			table.insert(AllCrates, Crate)
		end

		for _, Crate in ipairs(UsedCrates:GetChildren()) do
			table.insert(AllCrates, Crate)
		end

		if fireclickdetector then

			Tab:CreateButton({
				Name = "Open All Crates",
				Callback = function()
					for _, Crate in ipairs(AllCrates) do

						local Latches = Crate:FindFirstChild("Latches")
						if Latches then
							for _, Latch in pairs(Latches:GetChildren()) do
								local Button = Latch:FindFirstChild("Button")

								if Button then
									local ClickDetector = Button:FindFirstChildWhichIsA("ClickDetector")
									if ClickDetector then
										fireclickdetector(ClickDetector)
									end 
								end
							end
						end
					end
				end
			})

			local CrateOpenerSetup = false

			Tab:CreateButton({
				Name = "Enable Crate Opener",
				Callback = function()
					if not CrateOpenerSetup then
						CrateOpenerSetup = true
						for _, Crate in ipairs(AllCrates) do

							local Latches = Crate:FindFirstChild("Latches")
							if Latches then

								local Lid = Crate:FindFirstChild("Lid")
								if Lid then

									local ItemSpawn = Lid:FindFirstChild("ItemSpawn")
									if ItemSpawn then
										local ProximityPrompt = Instance.new("ProximityPrompt")
										ProximityPrompt.Parent = ItemSpawn
										ProximityPrompt.Enabled = false
										ProximityPrompt.MaxActivationDistance = 15
										ProximityPrompt.RequiresLineOfSight = false
										ProximityPrompt.ActionText = "Unlock"
										ProximityPrompt.ObjectText = "Unlock Crate"

										ProximityPrompt.Triggered:Connect(function(TriggeredPlayer)
											ProximityPrompt.Enabled = false
											
											for _, Latch in pairs(Latches:GetChildren()) do
												local Button = Latch:FindFirstChild("Button")

												if Button then
													local ClickDetector = Button:FindFirstChildWhichIsA("ClickDetector")
													if ClickDetector then
														fireclickdetector(ClickDetector)
													end 
												end
											end
											
											task.wait(0.5)
											
											local Destroyed = false
											
											if Latches:GetChildren()[1]:FindFirstChild("Button") then
												if Latches:GetChildren()[1]:FindFirstChild("Button").Color == Color3.fromRGB(0, 255, 0) then
													pcall(function()
														ProximityPrompt:Destroy()
													end)
													Destroyed = true
												end
											end
											
											if not Destroyed then
												ProximityPrompt.Enabled = true
											end
										end)
										
										ProximityPrompt.Enabled = true
									end
								end
							end
						end
					end
					
					for _, Crate in ipairs(AllCrates) do
						local Lid = Crate:FindFirstChild("Lid")
						if Lid then
							local ItemSpawn = Lid:FindFirstChild("ItemSpawn")
							if ItemSpawn then
								local ProximityPrompt = ItemSpawn:FindFirstChildWhichIsA("ProximityPrompt")
								if ProximityPrompt then
									ProximityPrompt.Enabled = true
								end
							end
						end
					end
				end
			})

			Tab:CreateButton({
				Name = "Disable Crate Opener",
				Callback = function()
					for _, Crate in ipairs(AllCrates) do
						local Lid = Crate:FindFirstChild("Lid")
						if Lid then
							local ItemSpawn = Lid:FindFirstChild("ItemSpawn")
							if ItemSpawn then
								local ProximityPrompt = ItemSpawn:FindFirstChildWhichIsA("ProximityPrompt")
								if ProximityPrompt then
									ProximityPrompt.Enabled = false
								end
							end
						end
					end
				end
			})

		end

		Tab:CreateButton({
			Name = "Teleport into Chamber [Random]",
			Callback = function()
				-- Trial 2: Teleport logic
			end
		})

		Tab:CreateButton({
			Name = "Enable Key ESP",
			Callback = function()
				-- Trial 2: Enable key ESP
			end
		})

		Tab:CreateButton({
			Name = "Disable Key ESP",
			Callback = function()
				-- Trial 2: Disable key ESP
			end
		})
	end
end

--// Trial 3

local Section = Tab:CreateSection("Trial 3")

local Remotes = Workspace:FindFirstChild("Remotes")

if fireclickdetector and Remotes then
	Tab:CreateButton({
		Name = "Get Remote",
		Callback = function()
			local RemainingRemotes = #Remotes:GetChildren()
			local Remote = Remotes:GetChildren()[math.random(1, RemainingRemotes)]
			local ClickDetector = Remote:FindFirstChildWhichIsA("ClickDetector")

			if ClickDetector then
				fireclickdetector(ClickDetector)
			end
		end
	})

end

local Passed = false

Tab:CreateButton({
	Name = "Instant Completion",
	Callback = function()
		if Passed then return end

		local Trial3RemoteUI = Player:FindFirstChildWhichIsA("PlayerGui"):FindFirstChild("Trial3Remote")
		if not Trial3RemoteUI then
			return
		end

		local HorseRemoteNumberObject = Trial3RemoteUI:FindFirstChild("HorseRemoteNumber")
		if not HorseRemoteNumberObject then
			return
		end

		Passed = true

		for I = 1,45 do 
			ReplicatedStorage:WaitForChild("Trial3"):WaitForChild("MoveHorse"):FireServer(HorseRemoteNumberObject.Value)
			task.wait(0.015)
		end

		ReplicatedStorage:WaitForChild("Trial3"):WaitForChild("Pass"):FireServer(HorseRemoteNumberObject.Value)
	end
})

Tab:CreateButton({
	Name = "Pass Without Crossing",
	Callback = function()
		if Passed then return end

		local Trial3RemoteUI = Player:FindFirstChildWhichIsA("PlayerGui"):FindFirstChild("Trial3Remote")
		if not Trial3RemoteUI then
			return
		end

		local HorseRemoteNumberObject = Trial3RemoteUI:FindFirstChild("HorseRemoteNumber")
		if not HorseRemoteNumberObject then
			return
		end

		Passed = true

		ReplicatedStorage:WaitForChild("Trial3"):WaitForChild("Pass"):FireServer(HorseRemoteNumberObject.Value)
	end
})


--// Trial 4

local Section = Tab:CreateSection("Trial 4")
local CurrentTigerLabel = Tab:CreateLabel("Current Tiger: ...")
local CurrentTigerTimeLabel = Tab:CreateLabel("Current Tiger's Timer: ...")

-- Workspace.TrialParts.Trial4.Screens:FindFirstChild("TV").Screen.SurfaceGui.Frame.BackgroundFrame.GameFrame

Tab:CreateButton({
	Name = "Enable Star Keys ESP",
	Callback = function()
		-- Enable ESP logic
	end
})

Tab:CreateButton({
	Name = "Disable Star Keys ESP",
	Callback = function()
		-- Disable ESP logic
	end
})


--// Trial 5

local Section = Tab:CreateSection("Trial 5")

local function Trial5Press()

end

Tab:CreateButton({
	Name = "Press",
	Callback = function()
		-- Press logic
	end
})

Tab:CreateButton({
	Name = "Enable Auto Press",
	Callback = function()
		-- Enable auto press
	end
})

Tab:CreateButton({
	Name = "Disable Auto Press",
	Callback = function()
		-- Disable auto press
	end
})


--// Trial 6

local Section = Tab:CreateSection("Trial 6")

Tab:CreateButton({
	Name = "Press Light Switch",
	Callback = function()
		-- Light press logic
	end
})


--// Trial 7

local Section = Tab:CreateSection("Trial 7")

local UnslipperyBeamSetup = false

Tab:CreateButton({
	Name = "Unslippery Beam",
	Callback = function()
		if not UnslipperyBeamSetup then
			local Beams = Workspace:FindFirstChild("Beams")
			local CustomProperties = PhysicalProperties.new(0.919, 0.15, 1, 0.15, 1)

			if Beams then
				UnslipperyBeamSetup = true
				for _, Beam in ipairs(Beams:GetDescendants()) do
					if Beam:IsA("BasePart") then
						pcall(function()
							Beam.CustomPhysicalProperties = CustomProperties
						end)
					end
				end
			end
		end
	end
})

if fireclickdetector then

	Tab:CreateButton({
		Name = "Get First Key",
		Callback = function()
			local TargetPosition = Vector3.new(137.049, -37.159, -369.362)

			for _, KeyModel in ipairs(workspace:GetChildren()) do
				if KeyModel.Name == "IceKeyZel" then
					local ClickPart = KeyModel:FindFirstChild("ClickPart")
					if ClickPart and ClickPart:IsA("MeshPart") then
						local distance = (ClickPart.Position - TargetPosition).Magnitude
						if distance <= 1 then
							local ClickDetector = ClickPart:FindFirstChildWhichIsA("ClickDetector")
							if ClickDetector then
								fireclickdetector(ClickDetector)
							else
								warn("ClickDetector not found in ClickPart.")
							end
							return 
						end
					end
				end
			end

			warn("First key not found within range.")
		end
	})

	Tab:CreateButton({
		Name = "Get Second Key",
		Callback = function()
			local TargetPosition = Vector3.new(137.049, -37.159, -354.762)

			for _, KeyModel in ipairs(workspace:GetChildren()) do
				if KeyModel.Name == "IceKeyZel" then
					local ClickPart = KeyModel:FindFirstChild("ClickPart")
					if ClickPart and ClickPart:IsA("MeshPart") then
						local distance = (ClickPart.Position - TargetPosition).Magnitude
						if distance <= 1 then
							local ClickDetector = ClickPart:FindFirstChildWhichIsA("ClickDetector")
							if ClickDetector then
								fireclickdetector(ClickDetector)
							else
								warn("ClickDetector not found in ClickPart.")
							end
							return 
						end
					end
				end
			end

			warn("Second key not found within range.")
		end
	})

	Tab:CreateButton({
		Name = "Get Third Key",
		Callback = function()
			local TargetPosition = Vector3.new(137.049, -37.159, -339.962)

			for _, KeyModel in ipairs(workspace:GetChildren()) do
				if KeyModel.Name == "IceKeyZel" then
					local ClickPart = KeyModel:FindFirstChild("ClickPart")
					if ClickPart and ClickPart:IsA("MeshPart") then
						local distance = (ClickPart.Position - TargetPosition).Magnitude
						if distance <= 1 then
							local ClickDetector = ClickPart:FindFirstChildWhichIsA("ClickDetector")
							if ClickDetector then
								fireclickdetector(ClickDetector)
							else
								warn("ClickDetector not found in ClickPart.")
							end
							return 
						end
					end
				end
			end

			warn("Third key not found within range.")
		end
	})

end

--// Trial 8 COMPLETE

local Trial8Remote = ReplicatedStorage:FindFirstChild("Trial8")
local Section = Tab:CreateSection("Trial 8")

local Transporter1SpeedLabel = Tab:CreateLabel("Current Transporter 1 Speed: 0")
local Transporter2SpeedLabel = Tab:CreateLabel("Current Transporter 2 Speed: 0")

local SelectedTransporter = 1
local InputSpeed = 0
local Transporter1Speed = 0
local Transporter2Speed = 0

local function UpdateTransporterLabels()
	local label1 = "Current Transporter 1 Speed: " .. Transporter1Speed
	local label2 = "Current Transporter 2 Speed: " .. Transporter2Speed

	if SelectedTransporter == 1 then
		label1 = label1 .. " [SELECTED]"
	else
		label2 = label2 .. " [SELECTED]"
	end

	Transporter1SpeedLabel:Set(label1)
	Transporter2SpeedLabel:Set(label2)
end

local function WatchTransporterSpeed(transporterId)
	local transporter = Workspace:FindFirstChild("TrialParts")
		and Workspace.TrialParts:FindFirstChild("Trial8")
		and Workspace.TrialParts.Trial8:FindFirstChild("Transporters")
		and Workspace.TrialParts.Trial8.Transporters:FindFirstChild(tostring(transporterId))

	if transporter then
		local root = transporter:FindFirstChild("RootTp")
		if root then
			local speed = root:FindFirstChild("Speed")
			if speed and speed:IsA("NumberValue") then
				local newSpeed = SnapToGrid(speed.Value)
				if transporterId == 1 then
					Transporter1Speed = newSpeed
				else
					Transporter2Speed = newSpeed
				end
				UpdateTransporterLabels()

				speed:GetPropertyChangedSignal("Value"):Connect(function()
					local updated = SnapToGrid(speed.Value)
					if transporterId == 1 then
						Transporter1Speed = updated
					else
						Transporter2Speed = updated
					end
					UpdateTransporterLabels()
				end)
			end
		end
	end
end

WatchTransporterSpeed(1)
WatchTransporterSpeed(2)

Tab:CreateButton({
	Name = "Select Transporter 1",
	Callback = function()
		SelectedTransporter = 1
		UpdateTransporterLabels()
	end,
})

Tab:CreateButton({
	Name = "Select Transporter 2",
	Callback = function()
		SelectedTransporter = 2
		UpdateTransporterLabels()
	end,
})

Tab:CreateInput({
	Name = "Speed Value",
	PlaceholderText = "Enter speed (e.g., -1 or 5)",
	RemoveTextAfterFocusLost = false,
	Callback = function(Value)
		local number = tonumber(Value)
		if number then
			InputSpeed = SnapToGrid(number)
		end
	end,
})

Tab:CreateButton({
	Name = "Set Transporter Speed [Broken]",
	Callback = function()
		if not Trial8Remote then return end

		local currentSpeed = (SelectedTransporter == 1) and Transporter1Speed or Transporter2Speed
		local targetSpeed = InputSpeed
		local delta = SnapToGrid(targetSpeed - currentSpeed)

		local wholeSteps = math.floor(math.abs(delta))
		local direction = (delta > 0) and 1 or -1
		local remainder = delta - (wholeSteps * direction)

		for i = 1, wholeSteps do
			Trial8Remote:FireServer(direction, tostring(SelectedTransporter))
			task.wait()
		end

		if remainder ~= 0 then
			if math.abs(remainder) <= 1 then
				Trial8Remote:FireServer(remainder, tostring(SelectedTransporter))
			end
		end
	end,
})

Tab:CreateButton({
	Name = "Increase Transporter Speed",
	Callback = function()
		if not Trial8Remote then return end

		local delta = SnapToGrid(InputSpeed)

		local wholeSteps = math.floor(math.abs(delta))
		local direction = (delta > 0) and 1 or -1
		local remainder = delta - (wholeSteps * direction)

		for i = 1, wholeSteps do
			Trial8Remote:FireServer(direction, tostring(SelectedTransporter))
			task.wait()
		end

		if remainder ~= 0 then
			if math.abs(remainder) <= 1 then
				Trial8Remote:FireServer(remainder, tostring(SelectedTransporter))
			end
		end
	end,
})


--[[
Phase 0 Butterfly BLossom skull

local UserInputService = game:GetService("UserInputService")
local RunLoop = true

-- Stop the loop when Delete is pressed
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.Delete then
		RunLoop = false
		warn("[RoleImage Loop] Stopped by Delete key.")
	end
end)

-- Start loop in a coroutine to avoid blocking
coroutine.wrap(function()
	while RunLoop do
		local screensFolder = workspace:FindFirstChild("Arena") and workspace.Arena:FindFirstChild("Screens")
		if screensFolder then
			for _, v in ipairs(screensFolder:GetDescendants()) do
				if v:IsA("ImageLabel") and v.Name == "RoleImage" then
					v.Visible = true
					v.ImageTransparency = 0

					local playerNameLabel = v.Parent:FindFirstChild("PlayerName")
					if playerNameLabel and playerNameLabel:IsA("TextLabel") then
						playerNameLabel.ZIndex = 2
					end
				end
			end
		end
		task.wait(0.1)
	end
end)()




workspace.TrialParts.Trial6.Stands["3"].CollarAttachment.PersonAttached
workspace.TrialParts.Trial6.Stands["3"].CollarAttachment

]]
