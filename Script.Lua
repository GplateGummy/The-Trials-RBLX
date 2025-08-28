local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "Trial Panel",
	LoadingTitle = "Rayfield Interface Suite",
	LoadingSubtitle = "Trial Panel",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil,
		FileName = "Trials"
	},
	Discord = {
		Enabled = false,
		Invite = "noinvitelink",
		RememberJoins = true
	},
	KeySystem = false
})

local Ids = {
	Lobby = "8473958692",
	Phase1 = "8473959225",
	Phase0 = {"8564062480", "78080369340687", "126844134510236", "118745041726468", "113726803758515", "102093306582585", "8564062480"}
}

local LobbyTab = Window:CreateTab("Lobby")

if tostring(game.PlaceId) == Ids["Lobby"] then
	local Section = LobbyTab:CreateSection("Teleporters")

	local function Teleport(TargetCFrame)
		local Character = LocalPlayer.Character

		if Character and Character:FindFirstChild("HumanoidRootPart") then
			Character:PivotTo(TargetCFrame)
		end
	end

	LobbyTab:CreateButton({
		Name = "Outdoors",
		Callback = function()
			Teleport(CFrame.new(-61.5, 5, 30.1499958, 1, 0, 0, 0, 1, 0, 0, 0, 1) * CFrame.Angles(0, math.rad(-90), 0))
		end
	})

	LobbyTab:CreateButton({
		Name = "Phase 0",
		Callback = function()
			Teleport(CFrame.new(13.8750067, 5, -62.4499817, 1, 0, 0, 0, 1, 0, 0, 0, 1))
		end
	})

	LobbyTab:CreateButton({
		Name = "Phase 0 Chamber",
		Callback = function()
			Teleport(CFrame.new(13.8749962, 5, -103.750008, 1, 0, 0, 0, 1, 0, 0, 0, 1) * CFrame.Angles(0, math.rad(180), 0))
		end
	})

	LobbyTab:CreateButton({
		Name = "Phase 1",
		Callback = function()
			Teleport(CFrame.new(69.3955231, 5, 95.6215744, -0.309060812, 0, 0.951042235, 0, 1, 0, -0.951042235, 0, -0.309060812) * CFrame.Angles(0, math.rad(-90), 0))
		end
	})

	LobbyTab:CreateButton({
		Name = "Phase 2",
		Callback = function()
			Teleport(CFrame.new(116.657669, 5, 61.4363899, -0.808997631, 0, 0.587812185, 0, 1, 0, -0.587812185, 0, -0.808997631) * CFrame.Angles(0, math.rad(-90), 0))
		end
	})
else
	local Section = LobbyTab:CreateSection("Info")
	LobbyTab:CreateLabel("This is only accessible in the lobby!")
end

local Phase0Tab = Window:CreateTab("Phase 0")

local Arena = Workspace:FindFirstChild("Arena")

if Arena and table.find(Ids["Phase0"], tostring(game.PlaceId)) then

	local Section = Phase0Tab:CreateSection("Butterfly Blossom Skull")

	local RoleImageIDs = {
		["Butterfly"] = "rbxassetid://10323622334",
		["Blossom"] = "rbxassetid://10323696386",
		["Skull"] = "rbxassetid://10323745552"
	}

	local RoleColors = {
		["Butterfly"] = Color3.fromRGB(213, 109, 40),
		["Blossom"] = Color3.fromRGB(209, 185, 67),
		["Skull"] = Color3.fromRGB(181, 55, 55)
	}

	local Enabled = false
	local StatusLabel = nil

	local function GetRoleFromColor(Color)
		for Role, RoleColor in pairs(RoleColors) do
			if Color:ToHex() == RoleColor:ToHex() then
				return Role
			end
		end
		return nil
	end

	local function CreateOrUpdateRoleTag(Character, Role)

		local Head = Character:FindFirstChild("Head")
		local RoleImageID = RoleImageIDs[Role]

		if not Head then
			return
		end

		if not RoleImageID then
			return
		end

		local ExistingTag = Head:FindFirstChild("RoleTag")
		if not ExistingTag then

			local RoleTag = Instance.new("BillboardGui")
			RoleTag.Name = "RoleTag"
			RoleTag.Active = true
			RoleTag.AlwaysOnTop = true
			RoleTag.MaxDistance = 40
			RoleTag.Size = UDim2.new(2.2, 0, 2.2, 0)
			RoleTag.StudsOffset = Vector3.new(0, 3.5, 0)
			RoleTag.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			RoleTag.Parent = Head

			local RoleImage = Instance.new("ImageLabel")
			RoleImage.Name = "RoleImage"
			RoleImage.Image = RoleImageID
			RoleImage.ScaleType = Enum.ScaleType.Fit
			RoleImage.BackgroundTransparency = 1
			RoleImage.ImageTransparency = 0.12
			RoleImage.BorderSizePixel = 0
			RoleImage.Size = UDim2.new(1, 0, 1, 0)
			RoleImage.Parent = RoleTag

		else
			local RoleImage = ExistingTag:FindFirstChild("RoleImage")

			if RoleImage then
				RoleImage.Image = RoleImageID
				RoleImage.Visible = true
			end
		end
	end

	local function OnPlayerFrameAdded(PlayerFrame)

		if not Enabled then
			return
		end

		if not tonumber(PlayerFrame.Name) then
			return
		end

		local RoleImageFrame = PlayerFrame:FindFirstChild("RoleImage", true)
		if not RoleImageFrame then
			return
		end

		local Role = GetRoleFromColor(RoleImageFrame.BackgroundColor3)
		if not Role then
			return
		end

		local UserId = tonumber(PlayerFrame.Name)
		local Player = game.Players:GetPlayerByUserId(UserId)

		if not Player then
			return
		end

		local Character = Player.Character
		if Character then
			CreateOrUpdateRoleTag(Character, Role)
		end

		Player.CharacterAdded:Connect(function(Char)
			if Enabled then
				CreateOrUpdateRoleTag(Char, Role)
			end
		end)
	end

	for _, Screen in ipairs(Workspace.Arena.Screens:GetChildren()) do

		local SurfaceGui = Screen:FindFirstChild("SurfaceGui")
		local Frame = SurfaceGui and SurfaceGui:FindFirstChild("Frame")
		local PlayerFrames = Frame and Frame:FindFirstChild("PlayerFrames")

		if PlayerFrames then

			PlayerFrames.ChildAdded:Connect(OnPlayerFrameAdded)
			for _, PlayerFrame in ipairs(PlayerFrames:GetChildren()) do
				OnPlayerFrameAdded(PlayerFrame)
			end
		end
	end

	local function RescanAllPlayerFrames()
		for _, Screen in ipairs(Workspace.Arena.Screens:GetChildren()) do
			local SurfaceGui = Screen:FindFirstChild("SurfaceGui")
			local Frame = SurfaceGui and SurfaceGui:FindFirstChild("Frame")
			local PlayerFrames = Frame and Frame:FindFirstChild("PlayerFrames")

			if PlayerFrames then
				for _, PlayerFrame in ipairs(PlayerFrames:GetChildren()) do
					OnPlayerFrameAdded(PlayerFrame)
				end
			end
		end
	end

	local function EnableRoleESP()

		if Enabled then
			return
		end

		Enabled = true
		if StatusLabel then
			StatusLabel:Set("Status : Enabled")
		end

		RescanAllPlayerFrames()
	end

	local function DisableRoleESP()

		if not Enabled then
			return
		end

		Enabled = false
		if StatusLabel then
			StatusLabel:Set("Status : Disabled")
		end

		for _, Player in ipairs(game.Players:GetPlayers()) do
			local Character = Player.Character
			if Character and Character:FindFirstChild("Head") then
				local Tag = Character.Head:FindFirstChild("RoleTag")
				if Tag then
					Tag:Destroy()
				end
			end
		end
	end

	local function ResetRoles()

		for _, Player in ipairs(game.Players:GetPlayers()) do
			local Character = Player.Character
			if Character and Character:FindFirstChild("Head") then
				local Tag = Character.Head:FindFirstChild("RoleTag")
				if Tag then
					local Image = Tag:FindFirstChild("RoleImage")
					if Image then
						Image.Visible = false
						Image.Image = ""
					end
				end
			end
		end
	end

	local InfoText = [[After a round, all roles are revealed. However, the role images are already preloaded. This means if someone stands on a circle, the screen can be scanned to identify their role.]]
	Phase0Tab:CreateLabel("How does this work?")
	Phase0Tab:CreateLabel(InfoText)

	Phase0Tab:CreateButton({
		Name = "Rescan Roles",
		Callback = function()
			RescanAllPlayerFrames()
		end
	})


	Phase0Tab:CreateButton({
		Name = "Reset Roles",
		Callback = function()
			ResetRoles()
		end
	})

	StatusLabel = Phase0Tab:CreateLabel("Status : Disabled")

	Phase0Tab:CreateButton({
		Name = "Enable Role ESP",
		Callback = function()
			EnableRoleESP()
		end
	})

	Phase0Tab:CreateButton({
		Name = "Disable Role ESP",
		Callback = function()
			DisableRoleESP()
		end
	})

else
	local Section = Phase0Tab:CreateSection("Info")
	Phase0Tab:CreateLabel("This is only accessible in-game!")
end

local Phase1Tab = Window:CreateTab("Phase 1")

local TrialParts = Workspace:FindFirstChild("TrialParts")

if TrialParts and tostring(game.PlaceId) == Ids["Phase1"] then

	local function SnapToGrid(value)
		return math.floor(value * 1000) / 1000
	end


	if fireclickdetector then
		local Section = Phase1Tab:CreateSection("Trial 1 - Push The Button")

		local Trial1Folder = TrialParts:FindFirstChild("Trial1")

		if Trial1Folder then

			local Trial1Rooms = Trial1Folder:FindFirstChild("Rooms")

			if Trial1Rooms then

				local Trial1RoomLabel = Phase1Tab:CreateLabel("My Room ID : ? [Required for button pressing!]")

				local BoundingBoxCFrames = {
					[1] = CFrame.new(18.2000008, 25, -17.7000008, 1, 0, 0, 0, 1, 0, 0, 0, 1),
					[2] = CFrame.new(-28.2000008, 25, -17.7000008, 1, 0, 0, 0, 1, 0, 0, 0, 1),
					[3] = CFrame.new(-74.5999985, 25, -17.7000008, 1, 0, 0, 0, 1, 0, 0, 0, 1),
					[4] = CFrame.new(-121, 25, -17.7000008, 1, 0, 0, 0, 1, 0, 0, 0, 1),
					[5] = CFrame.new(-190.099991, 25, 52.3000107, 0, 0, 1, 0, 1, 0, -1, 0, 0),
					[6] = CFrame.new(-190.099991, 25, 98.7000046, 0, 0, 1, 0, 1, 0, -1, 0, 0),
					[7] = CFrame.new(-190.099991, 25, 145.100021, 0, 0, 1, 0, 1, 0, -1, 0, 0),
					[8] = CFrame.new(-120.999985, 25, 215.099991, -1, 0, 0, 0, 1, 0, 0, 0, -1),
					[9] = CFrame.new(-74.5999908, 25, 215.099991, -1, 0, 0, 0, 1, 0, 0, 0, -1),
					[10] = CFrame.new(-28.1999893, 25, 215.099991, -1, 0, 0, 0, 1, 0, 0, 0, -1),
					[11] = CFrame.new(18.2000122, 25, 215.099991, -1, 0, 0, 0, 1, 0, 0, 0, -1)
				}

				local BoundingBoxSize = Vector3.new(43, 50, 43)

				local RoomID = nil

				Phase1Tab:CreateButton({
					Name = "Fetch Room ID",
					Callback = function()
						local Character = LocalPlayer.Character
						if Character then
							local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
							if HumanoidRootPart then
								local HrpCFrame = HumanoidRootPart.CFrame
								local HrpPosition = HrpCFrame.Position

								for Index, BoundingBoxCFrame in ipairs(BoundingBoxCFrames) do
									local relativePos = BoundingBoxCFrame:PointToObjectSpace(HrpPosition)
									local halfSize = BoundingBoxSize / 2

									if math.abs(relativePos.X) <= halfSize.X and
										math.abs(relativePos.Y) <= halfSize.Y and
										math.abs(relativePos.Z) <= halfSize.Z then
										RoomID = Index
										local LabelText = "My Room ID : " .. tostring(RoomID)
										Trial1RoomLabel:Set(LabelText)
										break
									end
								end
							end
						end
					end
				})


				Phase1Tab:CreateButton({
					Name = "Press Button",
					Callback = function()
						if RoomID then
							local Room = Trial1Rooms:FindFirstChild(tostring(RoomID))
							if Room then
								local Buttons = Room:FindFirstChild("Buttons")
								if Buttons then
									for _, Button in ipairs(Buttons:GetChildren()) do
										local ButtonPart = Button:FindFirstChild("Button")
										if ButtonPart and ButtonPart:IsA("BasePart") and ButtonPart.Color == Color3.fromRGB(0, 255, 0) then
											local ClickDetector = ButtonPart:FindFirstChildWhichIsA("ClickDetector")
											if ClickDetector then
												fireclickdetector(ClickDetector)
											end
										end
									end
								end
							end
						end				
					end
				})

			end
		end
	end


	local Section = Phase1Tab:CreateSection("Trial 2 - Match A Lock")

	local Trial2Folder = TrialParts:FindFirstChild("Trial2")

	local function AddHighlight(Object, Color)
		local Highlight = Instance.new("Highlight")
		Highlight.Parent = Object
		Highlight.Adornee = Object

		if Color == "Yellow" then
			Highlight.FillColor = Color3.fromRGB(255, 217, 0)
			Highlight.FillTransparency = 0
			Highlight.OutlineColor = Color3.fromRGB(255, 183, 0)
			Highlight.OutlineTransparency = 0.5
			return Highlight
		elseif Color == "Green" then
			Highlight.FillColor = Color3.fromRGB(26, 255, 0)
			Highlight.FillTransparency = 0
			Highlight.OutlineColor = Color3.fromRGB(22, 89, 21)
			Highlight.OutlineTransparency = 0.2
			return Highlight
		else 
			Highlight.FillTransparency = 0
			Highlight.OutlineColor = Color3.fromRGB(75, 0, 0)
			return Highlight
		end
	end

	local function AddTitle(Object, String)
		local BillboardGui = Instance.new("BillboardGui")
		BillboardGui.Active = true
		BillboardGui.AlwaysOnTop = true
		BillboardGui.ClipsDescendants = true
		BillboardGui.LightInfluence = 0.5
		BillboardGui.Size = UDim2.new(5, 0, 0.75, 0)
		BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 0, -4)
		BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

		local Label = Instance.new("TextLabel")
		Label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
		Label.RichText = true
		Label.Text = String
		Label.TextColor3 = Color3.fromRGB(255, 255, 255)
		Label.TextScaled = true
		Label.TextWrapped = true
		Label.BackgroundTransparency = 1
		Label.BorderSizePixel = 0
		Label.Size = UDim2.new(1, 0, 1, 0)
		Label.Name = "Label"

		BillboardGui.Parent = Object
		Label.Parent = BillboardGui

		return BillboardGui
	end

	if Trial2Folder then

		local Crates = Trial2Folder:FindFirstChild("Crates")
		local UsedCrates = Trial2Folder:FindFirstChild("UsedCrates")
		local Chambers = Trial2Folder:FindFirstChild("Chambers")

		if Crates and UsedCrates and Chambers then

			local AllCrates = {}

			for _, Crate in ipairs(Crates:GetChildren()) do
				table.insert(AllCrates, Crate)
			end

			for _, Crate in ipairs(UsedCrates:GetChildren()) do
				table.insert(AllCrates, Crate)
			end

			if fireclickdetector then

				Phase1Tab:CreateButton({
					Name = "Open All Crates",
					Callback = function()
						for _, Crate in ipairs(AllCrates) do

							local Latches = Crate:FindFirstChild("Latches")
							if Latches then
								for _, Latch in ipairs(Latches:GetChildren()) do
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

				Phase1Tab:CreateButton({
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

												for _, Latch in ipairs(Latches:GetChildren()) do
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

				Phase1Tab:CreateButton({
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

			Phase1Tab:CreateButton({
				Name = "Teleport into Chamber [Random]",
				Callback = function()
					local RandomChamber = math.random(1, 7)
					local Chamber = Chambers:FindFirstChild(tostring(RandomChamber))
					if Chamber then
						local LightModel = Chamber:FindFirstChild("Light")
						if LightModel then
							local LightPart = LightModel:FindFirstChild("LightPart")
							if LightPart then
								local TeleportPosition = LightPart.Position + Vector3.new(0, -6.5, 0)
								if LocalPlayer.Character then
									LocalPlayer.Character:PivotTo(CFrame.new(TeleportPosition) * CFrame.Angles(0, math.rad(90), 0))
								end
							end
						end
					end
				end
			})

			local Highlights = {}
			local Titles = {}

			local function EnableKeyEsp()
				for _, Crate in ipairs(AllCrates) do
					local Lid = Crate:FindFirstChild("Lid")
					if Lid then
						local ItemSpawn = Lid:FindFirstChild("ItemSpawn")
						if ItemSpawn then
							local Item = nil
							local ItemName = nil
							local ItemColor = nil

							for _, Object in ipairs(Lid:GetChildren()) do
								if Object:IsA("Model") then
									if Object.Name == "Gun" then
										Item = Object
										ItemName = "Gun"
										ItemColor = "Red"
										break
									end
									if Object.Name == "StarKey" then
										Item = Object
										ItemName = "Star Key"
										ItemColor = "Yellow"
										break
									end
									if string.find(Object.Name:lower(), "zel") then
										Item = Object
										ItemName = (Object.Name:gsub("Zel", "") .. " Key")
										ItemColor = "Green"
										break
									end
								end
							end


							if Item and ItemName and ItemColor then
								local Highlight = AddHighlight(Item, ItemColor)
								local Title = AddTitle(ItemSpawn, ItemName)

								if Highlight then
									table.insert(Highlights, Highlight)
								end
								if Title then
									table.insert(Titles, Title)
								end
							end
						end
					end
				end
			end

			local function DisabledKeyEsp()
				for _, Highlight in ipairs(Highlights) do
					if Highlight and Highlight.Parent then
						pcall(function()
							Highlight:Destroy()
						end)
					end
				end
				for _, Title in ipairs(Titles) do
					if Title and Title.Parent then
						pcall(function()
							Title:Destroy()
						end)
					end
				end
			end

			local Enabled = false

			Phase1Tab:CreateButton({
				Name = "Enable Key ESP",
				Callback = function()
					if not Enabled then
						Enabled = true
						EnableKeyEsp()
					end
				end
			})

			Phase1Tab:CreateButton({
				Name = "Disable Key ESP",
				Callback = function()
					if Enabled then
						Enabled = false
						DisabledKeyEsp()
					end
				end
			})
		end
	end


	local Section = Phase1Tab:CreateSection("Trial 3 - Horse Race")

	local Remotes = Workspace:FindFirstChild("Remotes")

	if fireclickdetector and Remotes then
		Phase1Tab:CreateButton({
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

	local WarningLabel = Phase1Tab:CreateLabel("Warning! Only use these three buttons below if trial 3 starts started AND if you have the remote!")

	local PassDebounce = false

	Phase1Tab:CreateButton({
		Name = "Slow Completion [Looks Legit]",
		Callback = function()
			if not PassDebounce then
				PassDebounce = true

				local Trial3RemoteUI = LocalPlayer:FindFirstChildWhichIsA("PlayerGui"):FindFirstChild("Trial3Remote")
				if not Trial3RemoteUI then
					return
				end

				local HorseRemoteNumberObject = Trial3RemoteUI:FindFirstChild("HorseRemoteNumber")
				if not HorseRemoteNumberObject then
					return
				end

				for I = 1,41 do 
					ReplicatedStorage:WaitForChild("Trial3"):WaitForChild("MoveHorse"):FireServer(HorseRemoteNumberObject.Value)
					task.wait(math.random(800, 1600) / 1000)
				end

				ReplicatedStorage:WaitForChild("Trial3"):WaitForChild("Pass"):FireServer(HorseRemoteNumberObject.Value)

				task.wait(2.5)
				PassDebounce = false
			end
		end
	})

	Phase1Tab:CreateButton({
		Name = "Instant Completion",
		Callback = function()
			if not PassDebounce then
				PassDebounce = true

				local Trial3RemoteUI = LocalPlayer:FindFirstChildWhichIsA("PlayerGui"):FindFirstChild("Trial3Remote")
				if not Trial3RemoteUI then
					return
				end

				local HorseRemoteNumberObject = Trial3RemoteUI:FindFirstChild("HorseRemoteNumber")
				if not HorseRemoteNumberObject then
					return
				end

				for I = 1,45 do 
					ReplicatedStorage:WaitForChild("Trial3"):WaitForChild("MoveHorse"):FireServer(HorseRemoteNumberObject.Value)
					task.wait(0.015)
				end

				ReplicatedStorage:WaitForChild("Trial3"):WaitForChild("Pass"):FireServer(HorseRemoteNumberObject.Value)

				task.wait(5)
				PassDebounce = false
			end
		end
	})

	Phase1Tab:CreateButton({
		Name = "Pass Without Crossing",
		Callback = function()
			if not PassDebounce then
				PassDebounce = true

				local Trial3RemoteUI = LocalPlayer:FindFirstChildWhichIsA("PlayerGui"):FindFirstChild("Trial3Remote")
				if not Trial3RemoteUI then
					return
				end

				local HorseRemoteNumberObject = Trial3RemoteUI:FindFirstChild("HorseRemoteNumber")
				if not HorseRemoteNumberObject then
					return
				end

				ReplicatedStorage:WaitForChild("Trial3"):WaitForChild("Pass"):FireServer(HorseRemoteNumberObject.Value)

				task.wait(5)
				PassDebounce = false
			end
		end
	})



	local Section = Phase1Tab:CreateSection("Trial 4 - Outrun The Tiger")
	local CurrentTigerLabel = Phase1Tab:CreateLabel("Current Tiger: ... (Coming someday)")
	local CurrentTigerTimeLabel = Phase1Tab:CreateLabel("Current Tiger's Timer: ... (Coming someday)")

	local Enabled = false
	local StarKeyHighlights = {}

	Phase1Tab:CreateButton({
		Name = "Enable Star Keys ESP",
		Callback = function()
			if not Enabled then
				Enabled = true
				for _, KeyModel in ipairs(Workspace:GetChildren()) do
					if KeyModel:IsA("Model") and KeyModel.Name == "StarKey" then
						local Highlight = AddHighlight(KeyModel, "Yellow")
						if Highlight then
							table.insert(StarKeyHighlights, Highlight)
						end
					end
				end
			end
		end
	})

	Phase1Tab:CreateButton({
		Name = "Disable Star Keys ESP",
		Callback = function()
			if Enabled then
				Enabled = false
				for _, Highlight in ipairs(StarKeyHighlights) do
					if Highlight and Highlight.Parent then
						pcall(function()
							Highlight:Destroy()
						end)
					end
				end
			end
		end
	})



	local Section = Phase1Tab:CreateSection("Trial 5 - Trigger Finger")

	local Trial5Remote = ReplicatedStorage:FindFirstChild("Trial5")

	Phase1Tab:CreateButton({
		Name = "Press",
		Callback = function()
			Trial5Remote:FireServer()
		end
	})

	local Trial5Enabled = false

	Trial5Remote.OnClientEvent:Connect(function()
		if Trial5Enabled then
			Trial5Remote:FireServer()	
			task.wait(0.01)
			Trial5Remote:FireServer()	
			task.wait(0.01)
			Trial5Remote:FireServer()
		end
	end)

	local Trial5Status = Phase1Tab:CreateLabel("Status : Disabled")

	Phase1Tab:CreateButton({
		Name = "Enable Auto Press",
		Callback = function()
			if not Trial5Enabled then
				Trial5Enabled = true
				Trial5Status:Set("Status : Enabled")
			end
		end
	})

	Phase1Tab:CreateButton({
		Name = "Disable Auto Press",
		Callback = function()
			if Trial5Enabled then
				Trial5Enabled = false
				Trial5Status:Set("Status : Disabled")
			end
		end
	})



	local Section = Phase1Tab:CreateSection("Trial 6 - Light Switch")

	local Trial6Folder = TrialParts:FindFirstChild("Trial6")

	if fireclickdetector then

		Phase1Tab:CreateButton({
			Name = "Press Light Switch",
			Callback = function()
				local LocalPlayerUsername = LocalPlayer.Name
				local Stands = Trial6Folder:FindFirstChild("Stands")
				if Stands then
					for _, Stand in ipairs(Stands:GetChildren()) do

						local Switch = Stand:FindFirstChild("Switch")
						if not Switch then continue end

						local ClickPart = Switch:FindFirstChild("ClickPart")
						if not ClickPart then continue end

						local CollarAttachment = Stand:FindFirstChild("CollarAttachment")
						if not CollarAttachment then continue end

						local PersonAttached = CollarAttachment:FindFirstChild("PersonAttached")
						if PersonAttached and PersonAttached:IsA("StringValue") then
							if PersonAttached.Value == LocalPlayerUsername then
								local ClickDetector = ClickPart:FindFirstChildWhichIsA("ClickDetector")
								if ClickDetector then
									fireclickdetector(ClickDetector)
								end
							end
						end

					end
				end
			end
		})

	end

	Phase1Tab:CreateLabel("The rope still appears for others, but it just looks like the rope is really long for other people.")

	Phase1Tab:CreateButton({
		Name = "Remove Rope",
		Callback = function()
			local LocalPlayerUsername = LocalPlayer.Name
			local Stands = Trial6Folder:FindFirstChild("Stands")
			if Stands then
				for _, Stand in ipairs(Stands:GetChildren()) do

					local CollarAttachment = Stand:FindFirstChild("CollarAttachment")
					if not CollarAttachment then continue end

					local RopePart = CollarAttachment:FindFirstChild("RopePart")
					if not RopePart then continue end

					local PersonAttached = CollarAttachment:FindFirstChild("PersonAttached")
					if PersonAttached and PersonAttached:IsA("StringValue") then
						if PersonAttached.Value == LocalPlayerUsername then
							local RopeConstraint = RopePart:FindFirstChildWhichIsA("RopeConstraint")
							RopeConstraint.Visible = false
							RopeConstraint.Length = 2000
						end
					end

				end
			end
		end
	})

	Phase1Tab:CreateButton({
		Name = "Reset Rope",
		Callback = function()
			local LocalPlayerUsername = LocalPlayer.Name
			local Stands = Trial6Folder:FindFirstChild("Stands")
			if Stands then
				for _, Stand in ipairs(Stands:GetChildren()) do

					local CollarAttachment = Stand:FindFirstChild("CollarAttachment")
					if not CollarAttachment then continue end

					local RopePart = CollarAttachment:FindFirstChild("RopePart")
					if not RopePart then continue end

					local PersonAttached = CollarAttachment:FindFirstChild("PersonAttached")
					if PersonAttached and PersonAttached:IsA("StringValue") then
						if PersonAttached.Value == LocalPlayerUsername then
							local RopeConstraint = RopePart:FindFirstChildWhichIsA("RopeConstraint")
							RopeConstraint.Visible = true
							RopeConstraint.Length = 16
						end
					end

				end
			end
		end
	})


	local Section = Phase1Tab:CreateSection("Trial 7 - Slippery Beam")

	local UnslipperyBeamSetup = false

	Phase1Tab:CreateButton({
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

		Phase1Tab:CreateButton({
			Name = "Get First Key",
			Callback = function()
				local TargetPosition = Vector3.new(137.049, -37.159, -369.362)

				for _, KeyModel in ipairs(Workspace:GetChildren()) do
					if KeyModel:IsA("Model") and KeyModel.Name == "IceKeyZel" then
						local ClickPart = KeyModel:FindFirstChild("ClickPart")
						if ClickPart and ClickPart:IsA("MeshPart") then
							local distance = (ClickPart.Position - TargetPosition).Magnitude
							if distance <= 1 then
								local ClickDetector = ClickPart:FindFirstChildWhichIsA("ClickDetector")
								if ClickDetector then
									fireclickdetector(ClickDetector)
								else
								end
								return 
							end
						end
					end
				end

			end
		})

		Phase1Tab:CreateButton({
			Name = "Get Second Key",
			Callback = function()
				local TargetPosition = Vector3.new(137.049, -37.159, -354.762)

				for _, KeyModel in ipairs(Workspace:GetChildren()) do
					if KeyModel:IsA("Model") and KeyModel.Name == "IceKeyZel" then
						local ClickPart = KeyModel:FindFirstChild("ClickPart")
						if ClickPart and ClickPart:IsA("MeshPart") then
							local distance = (ClickPart.Position - TargetPosition).Magnitude
							if distance <= 1 then
								local ClickDetector = ClickPart:FindFirstChildWhichIsA("ClickDetector")
								if ClickDetector then
									fireclickdetector(ClickDetector)
								else
								end
								return 
							end
						end
					end
				end

			end
		})

		Phase1Tab:CreateButton({
			Name = "Get Third Key",
			Callback = function()
				local TargetPosition = Vector3.new(137.049, -37.159, -339.962)

				for _, KeyModel in ipairs(Workspace:GetChildren()) do
					if KeyModel:IsA("Model") and KeyModel.Name == "IceKeyZel" then
						local ClickPart = KeyModel:FindFirstChild("ClickPart")
						if ClickPart and ClickPart:IsA("MeshPart") then
							local distance = (ClickPart.Position - TargetPosition).Magnitude
							if distance <= 1 then
								local ClickDetector = ClickPart:FindFirstChildWhichIsA("ClickDetector")
								if ClickDetector then
									fireclickdetector(ClickDetector)
								else
								end
								return 
							end
						end
					end
				end

			end
		})

	end


	local Trial8Remote = ReplicatedStorage:FindFirstChild("Trial8")
	local Section = Phase1Tab:CreateSection("Trial 8 - One Must Move Forward")

	local SelectedTransporter = 1
	local InputSpeed = 0
	local Transporter1Speed = 0
	local Transporter2Speed = 0

	local Transporter1SpeedLabel = Phase1Tab:CreateLabel("Current Transporter 1 Speed: " .. tostring(Transporter1Speed))
	local Transporter2SpeedLabel = Phase1Tab:CreateLabel("Current Transporter 2 Speed: " .. tostring(Transporter2Speed))

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

	local function WatchTransporterSpeed(TransporterId)
		local Trial8Folder = TrialParts:FindFirstChild("Trial8")
		if Trial8Folder then

			local Transporters = Trial8Folder:FindFirstChild("Transporters")
			if Transporters then

				local Transporter = Transporters:FindFirstChild(tostring(TransporterId))
				if Transporter then

					local RootPart = Transporter:FindFirstChild("RootTp")
					if RootPart then

						local SpeedString = RootPart:FindFirstChild("Speed")
						if SpeedString and SpeedString:IsA("StringValue") then

							local NewSpeed = SnapToGrid(tonumber(SpeedString.Value))
							if TransporterId == 1 then
								Transporter1Speed = NewSpeed
							else
								Transporter2Speed = NewSpeed
							end

							UpdateTransporterLabels()

							SpeedString:GetPropertyChangedSignal("Value"):Connect(function()
								local UpdatedSpeed = SnapToGrid(tonumber(SpeedString.Value))

								if TransporterId == 1 then
									Transporter1Speed = UpdatedSpeed
								else
									Transporter2Speed = UpdatedSpeed
								end
								UpdateTransporterLabels()
							end)
						end
					end
				end
			end
		end
	end

	WatchTransporterSpeed(1)
	WatchTransporterSpeed(2)

	UpdateTransporterLabels()

	Phase1Tab:CreateButton({
		Name = "Select Transporter 1",
		Callback = function()
			SelectedTransporter = 1
			UpdateTransporterLabels()
		end,
	})

	Phase1Tab:CreateButton({
		Name = "Select Transporter 2",
		Callback = function()
			SelectedTransporter = 2
			UpdateTransporterLabels()
		end,
	})

	Phase1Tab:CreateInput({
		Name = "Speed Value",
		PlaceholderText = "Enter speed (Even negative numbers)",
		RemoveTextAfterFocusLost = false,
		Callback = function(Value)
			local number = tonumber(Value)
			if number then
				InputSpeed = SnapToGrid(number)
			end
		end,
	})

	Phase1Tab:CreateButton({
		Name = "Set Transporter Speed",
		Callback = function()
			if not Trial8Remote then return end

			local currentSpeed = (SelectedTransporter == 1) and Transporter1Speed or Transporter2Speed

			local targetSpeed = SnapToGrid(InputSpeed)
			currentSpeed = SnapToGrid(currentSpeed)

			local delta = targetSpeed - currentSpeed

			if delta ~= 0 then
				Trial8Remote:FireServer(delta, tostring(SelectedTransporter))
			end
		end,
	})

	Phase1Tab:CreateButton({
		Name = "Increase Transporter Speed",
		Callback = function()
			if not Trial8Remote then return end

			Trial8Remote:FireServer(InputSpeed, tostring(SelectedTransporter))
		end
	})

else
	local Section = Phase1Tab:CreateSection("Info")
	Phase1Tab:CreateLabel("This is only accessible in-game!")
end
