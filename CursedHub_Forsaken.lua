local Workspace
Workspace = game:GetService("Workspace")
local Players
Players = game:GetService("Players")
local ReplicatedStorage
ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui
CoreGui = game:GetService("CoreGui")
local RunService
RunService = game:GetService("RunService")
local HttpService
HttpService = game:GetService("HttpService")
local PathfindingService
PathfindingService = game:GetService("PathfindingService")
local VirtualInputManager
VirtualInputManager = game:GetService("VirtualInputManager")
local TextChatService
TextChatService = game:GetService("TextChatService")
local UserInputService
UserInputService = game:GetService("UserInputService")
local Lighting
Lighting = game:GetService("Lighting")
local Stats
Stats = game:GetService("Stats")
local request_
local request_2 = request or http_request or http and http.request

if request_2 then
	request_ = request_2
else
	request_ = syn and syn.request
end

local forsakenFK
local genv = nil

pcall(function()
	genv = typeof(getgenv) == "function" and getgenv() or nil
end)

forsakenFK = genv and genv.ForsakenFK or {}

if genv and not genv.ForsakenFK then
	genv.ForsakenFK = forsakenFK
end

if not forsakenFK.__version then
	forsakenFK.__version = "1.0-slim"
	local localPlayer = Players.LocalPlayer

	forsakenFK.make = function(arg, arg2, parent)
		local instance = Instance.new(arg)
		local children = arg2 and arg2.Children

		if arg2 then
			for k, v in pairs(arg2) do
				if k ~= "Children" then
					pcall(function()
						instance[k] = v
					end)
				end
			end
		end

		if children then
			for _, child in ipairs(children) do
				child.Parent = instance
			end
		end

		if parent then
			instance.Parent = parent
		end

		return instance
	end

	local tbl = { [0] = Enum.Font.Gotham, Enum.Font.GothamMedium, Enum.Font.Code, Enum.Font.RobotoMono }
	local v = nil

	local function createScreenGui()
		if v and v.Parent then
			return v
		end
		local hui = nil

		pcall(function()
			if gethui then
				hui = gethui()
			end
		end)

		local flag = not hui

		if flag then
			pcall(function()
				hui = game:GetService("CoreGui")
			end)
		end

		if flag then
			pcall(function()
				local localPlayer2 = Players.LocalPlayer or localPlayer
				hui = localPlayer2 and localPlayer2:WaitForChild("PlayerGui", 5) or nil
			end)
		end

		if flag then
			return nil
		end
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "FK_TextTags"
		screenGui.ResetOnSpawn = false
		screenGui.IgnoreGuiInset = true
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

		pcall(function()
			screenGui.DisplayOrder = 100
		end)

		screenGui.Parent = hui
		v = screenGui
		return screenGui
	end

	forsakenFK.textTag = function()
		local v2 = createScreenGui()
		local textLabel = Instance.new("TextLabel")
		textLabel.BackgroundTransparency = 1
		textLabel.AutomaticSize = Enum.AutomaticSize.XY
		textLabel.Size = UDim2.new(0, 0, 0, 0)
		textLabel.Font = Enum.Font.Code
		textLabel.TextSize = 14
		textLabel.TextColor3 = Color3.new(1, 1, 1)
		textLabel.TextStrokeTransparency = 0
		textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
		textLabel.TextWrapped = false
		textLabel.Text = ""
		textLabel.Visible = false

		if v2 then
			textLabel.Parent = v2
		end

		local flag = true
		local vector2 = Vector2.new(0, 0)

		local function fn()
			textLabel.AnchorPoint = Vector2.new(flag and 0.5 or 0, flag and 0.5 or 0)
			textLabel.Position = UDim2.new(0, vector2.X, 0, vector2.Y)
		end

		fn()

		return setmetatable({
			Remove = function()
				pcall(function()
					textLabel:Destroy()
				end)
			end,
			Destroy = function()
				pcall(function()
					textLabel:Destroy()
				end)
			end,
		}, { __index = function(...) end, __newindex = function(...) end })
	end

	local tbl2 = {}
	local tbl3 = {}

	local function fn(arg, arg2, arg3)
		task.spawn(function()
			while true do
				local players = Workspace:FindFirstChild("Players")
				local v2 = players and players:FindFirstChild(arg)

				if v2 then
					local function fn2(child)
						if child:IsA("Model") and not arg3[child] then
							arg3[child] = true
							table.insert(arg2, child)
						end
					end

					local function fn3(child)
						arg3[child] = nil

						for i = #arg2, 1, -1 do
							if arg2[i] == child then
								table.remove(arg2, i)
							end
						end
					end

					local connection = v2.ChildAdded:Connect(fn2)
					local connection2 = v2.ChildRemoved:Connect(fn3)
					local flag = false

					local connection3 = players.ChildRemoved:Connect(function(child)
						if child == v2 then
							flag = true
						end
					end)

					for _, child in ipairs(v2:GetChildren()) do
						fn2(child)
					end

					while v2.Parent and not flag do
						task.wait(1)
					end

					connection:Disconnect()
					connection2:Disconnect()
					connection3:Disconnect()

					for i = #arg2, 1, -1 do
						arg3[arg2[i]] = nil
						table.remove(arg2, i)
					end
				end

				task.wait(1)
			end
		end)
	end

	fn("Killers", tbl2, {})
	fn("Survivors", tbl3, {})

	forsakenFK.Roster = {
		killers = function()
			return tbl2
		end,
		survivors = function()
			return tbl3
		end,
	}

	local obj = setmetatable({}, { __mode = "k" })

	forsakenFK.rayParams = function(filterDescendantsInstances)
		local v2 = filterDescendantsInstances and filterDescendantsInstances[1] or Workspace
		local raycastParams = obj[v2]

		if not raycastParams then
			raycastParams = RaycastParams.new()
			raycastParams.FilterType = Enum.RaycastFilterType.Exclude
			raycastParams.IgnoreWater = true
			obj[v2] = raycastParams
		end

		raycastParams.FilterDescendantsInstances = filterDescendantsInstances or {}
		return raycastParams
	end

	forsakenFK.sounds = {}
	local tbl4 = {}

	forsakenFK.sounds.on = function(arg)
		tbl4[#tbl4 + 1] = arg
		local n = #tbl4

		return function()
			tbl4[n] = nil
		end
	end

	local function fn2(arg)
		if not arg:IsA("Sound") or arg:GetAttribute("__FK_SOUND") then
			return
		end
		arg:SetAttribute("__FK_SOUND", true)
		local function fn3(...) end
		arg.Played:Connect(fn3)

		arg:GetPropertyChangedSignal("IsPlaying"):Connect(function()
			if arg.IsPlaying then
				fn3()
			end
		end)

		if arg.IsPlaying then
			fn3()
		end
	end

	task.delay(0.5, function()
		for _, descendant in ipairs(Workspace:GetDescendants()) do
			pcall(fn2, descendant)
		end

		Workspace.DescendantAdded:Connect(function(descendant)
			task.defer(function()
				pcall(fn2, descendant)
			end)
		end)
	end)

	forsakenFK.namecall = {}
	local tbl5 = {}
	local flag = false

	forsakenFK.namecall.add = function(arg)
		forsakenFK.namecall.install()
		tbl5[#tbl5 + 1] = arg
		local n = #tbl5

		return function()
			tbl5[n] = nil
		end
	end

	forsakenFK.namecall.install = function()
		if flag then
			return
		end
		flag = true
		local function fn3(...) end
		local v2 = newcclosure and newcclosure(fn3) or fn3

		if hookmetamethod then
			hookmetamethod(game, "__namecall", v2)
		else
			local v3 = getrawmetatable(game)
			setreadonly(v3, false)
			v3.__namecall = v2
			setreadonly(v3, true)
		end
	end
end

local localPlayer
localPlayer = Players.LocalPlayer
local playerGui
playerGui = localPlayer.PlayerGui
local currentCamera
currentCamera = Workspace.CurrentCamera
local assets
assets = ReplicatedStorage:FindFirstChild("Assets") or ReplicatedStorage:WaitForChild("Assets", 10)
local modules
modules = ReplicatedStorage:FindFirstChild("Modules") or ReplicatedStorage:WaitForChild("Modules", 10)
local v

local function fn()
	if not modules then
		return nil
	end
	local network = modules:FindFirstChild("Network") or modules:WaitForChild("Network", 10)
	if not network then
		local network2 = modules:FindFirstChild("Network", true)
		return network2 and network2:IsA("ModuleScript") and network2 or nil
	end

	if network:IsA("ModuleScript") then
		return network
	end
	local network2 = network:FindFirstChild("Network") or network:WaitForChild("Network", 10)
	if network2 and network2:IsA("ModuleScript") then
		return network2
	end

	for _, descendant in ipairs(modules:GetDescendants()) do
		if descendant.Name == "Network" and descendant:IsA("ModuleScript") then
			return descendant
		end
	end

	return nil
end

v = fn()
local remoteEvent

if v then
	remoteEvent = v:FindFirstChild("RemoteEvent") or modules:FindFirstChild("RemoteEvent", true)
else
	remoteEvent = v
end

local killers, survivors
local players = Workspace.Players
killers = players and players.Killers
survivors = players and players.Survivors
local ingame
ingame = Workspace.Map.Ingame
local tbl

tbl = {
	StaffState = false,
	Staff = {},
	StaffLeave = false,
	StaffLeaveDelay = 0,
	Invisibility = false,
	FlyBind = false,
	Noclip = false,
	BaseSpeed = 12,
	JumpPower = 50,
	DisableOutline = 0,
	HFillTransparency = 0.8,
	KillerEsp = false,
	PlayersTagsEsp = false,
	ObjectsTagsEsp = false,
	SurvivorsEsp = false,
	EspKillerColor = Color3.fromRGB(255, 0, 0),
	EspKillerSupportColor = Color3.fromRGB(180, 0, 0),
	EspSurvivorsColor = Color3.fromRGB(0, 255, 0),
	GeneratorEsp = false,
	GeneratorEsp2 = false,
	GeneratorColor = Color3.fromRGB(255, 255, 0),
	FakeGeneratorColor = Color3.fromRGB(255, 165, 0),
	DoneGeneratorColor = Color3.fromRGB(0, 255, 0),
	ItemEsp2 = false,
	BloxyColaEsp = false,
	MedkitEsp = false,
	BloxyColaColor = Color3.fromRGB(85, 0, 255),
	MedkitColor = Color3.fromRGB(85, 0, 255),
	TaphTrapsEsp = false,
	TaphTrapsEspColor = Color3.fromRGB(255, 165, 0),
	VeeronicaGraffitiEsp = false,
	VeeronicaGraffitiEspColor = Color3.fromRGB(255, 192, 203),
	RespawnLocationEsp = false,
	RespawnLocationEspColor = Color3.fromRGB(0, 255, 255),
	BuildermanEsp = false,
	BuildermanEspColor = Color3.fromRGB(0, 255, 255),
	AzureEsp = false,
	AzureEspColor = Color3.fromRGB(128, 0, 128),
	GetAutoItems = false,
	AutoGeneratorsTime = 1.05,
	GeneratorsUI = false,
	RandomGenTime = false,
	NormalFaceCheck = false,
	AimBot = false,
	AimBotMethod = "Camera Lock",
	AimBotDistance = 20,
	AimBotPrediction = 0.1,
	AimBotSmoothness = 35,
	AimBotPart = "Head",
	AimBotPingComp = true,
	SingleTargetMode = false,
	CurrentTarget = nil,
	AimTargetType = "Auto",
	VisualizeRadius = false,
	AutoBlocStuds = 5,
	AutoBlockChance = 100,
	AutoBlockm1c = false,
	WallCheck = false,
	VisWallCheck = false,
	FacingCheck = false,
	VisFacing = false,
	AntiSpin = false,
	VisAntiSpin = false,
	SpeedPredict = false,
	OverrideHitboxSizes = false,
	Delays = {},
	MobileFakeBlockEnabled = false,
	AutoPunch = false,
	AutoPunchStuds = 15,
	AutoPunch_method = "HumanoidRoot Lock",
	PunchDelay = 0,
	AnimCheck = false,
	GhostPunch = false,
	GhostBlock = false,
	PizzaAimbot = false,
	PizzaTargetLowestHP = false,
	PizzaLockMode = "HumanoidRoot Lock",
	PizzaSpeed = 80,
	PizzaPrediction = 0.5,
	PizzaSmoothness = 0.5,
	InfRushHour = false,
	RushHourCD = 3,
	AutoCoinFlip = false,
	Shoot_Aim_helper = false,
	Shoot_Aim_helper_method = "HumanoidRoot Lock",
	Shoot_Aim_helper_look_loock = 1.6,
	GhostShoot = false,
	AutoTrick = false,
	AutoEatChicken = false,
	Auto_Eat_Chicken_HP = 65,
	Auto_Eat_Chicken_Distance = 30,
	Auto_Slash_Shad = false,
	Auto_Slash_Shad_Dis = 10,
	ANosferatuHook = false,
	ANosferatuHookCoolDown = 0.3,
	NoliRushControl = false,
	AutoRagingPace = false,
	RagingPaceDistance = 30,
	CustomRagingPaceSpeed = false,
	RagingPaceSpeedValue = 2.1,
	AntiFallSlowness = false,
	AntiStun = false,
	Animid = nil,
	SelectedKiller = nil,
	UseKillerAnimations = false,
	UseKillerSounds = false,
	MobileAttackButtonEnabled = false,
	KillerAutoFarm = false,
	SurvivorAutoFarm2 = false,
	Invisibility2 = false,
	KillerDist = 30,
	CollectGinger = true,
	ChargeGenerators = true,
	DrawPaths = false,
	AutoCollectGingerbread = false,
	ResetIfKiller = true,
	AutoCloseEndGameScreen = false,
	NicknameReplacerEnabled = false,
	InfiniteCola = false,
	HitboxExpander = false,
	HitboxTargetMode = "Distance",
	HitboxExpanderDistance = 10,
}

local v2

v2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxcursedsocute/UI-Library/refs/heads/main/Mini5"))().CreateWindow({
	Name = "Cursedsaken",
	Description = "gg/MAVaSXXEnZ",
	Size = 620,
	Version = "version 1.5.1",
	Theme = "Cursed",
})

local str = "forsaken.json"

if isfile("zxcursedsocute/last_config.txt") then
	str = readfile("zxcursedsocute/last_config.txt")
end

v2:SetSavePath("zxcursedsocute", str)
local tbl2

tbl2 = {
	KillerAnimations = {},
	SurvivorAnimations = {},
	ChaseSounds = {},
	SurvivorStunSounds = {},
	TriggerSounds = {},
	ChanceSounds = {},
	GuestPunchAnim = {},
	GuestBlockAnim = {},
	AutoBlockTriggerSounds = {},
}

spawn(function()
	local response = game:HttpGet("https://gist.githubusercontent.com/zxcursedsocute/4e0833a7a6cfdc537844b7545dd9079e/raw/gistfile1.json")
	local data = HttpService:JSONDecode(response)
	local v3 = pairs
	local a = data.a or {}

	for k, v4 in v3(a) do
		tbl2.KillerAnimations[k] = v4
	end

	local v4 = pairs
	local b = data.b or {}

	for k, v5 in v4(b) do
		tbl2.SurvivorAnimations[k] = v5
	end

	local v5 = pairs
	local c = data.c or {}

	for k, v6 in v5(c) do
		tbl2.ChaseSounds[k] = v6
	end

	local tbl3 = { a = "Shedletsky", b = "Guest1337", c = "JaneDoe", d = "TwoTime", e = "Chance" }
	local v6 = pairs
	local d = data.d or {}

	for k, v7 in v6(d) do
		local v8 = tbl3[k]

		if v8 then
			tbl2.SurvivorStunSounds[v8] = {}

			for k2, v9 in pairs(v7) do
				if v9 then
					local match = tostring(k2):match("%d+")

					if match then
						table.insert(tbl2.SurvivorStunSounds[v8], match)
						tbl2.TriggerSounds[match] = true

						if k == "e" then
							tbl2.ChanceSounds[match] = true
						end
					end
				end
			end
		end
	end

	local v7 = pairs
	local e = data.e or {}

	for k, v8 in v7(e) do
		tbl2.GuestPunchAnim[k] = v8
	end

	local v8 = pairs
	local f = data.f or {}

	for k, v9 in v8(f) do
		tbl2.GuestBlockAnim[k] = v9
	end

	local v9 = pairs
	local g = data.g or {}

	for k, v10 in v9(g) do
		tbl2.AutoBlockTriggerSounds[k] = v10
	end
end)

local fn2

fn2 = function(arg, arg2, arg3, arg4)
	task.spawn(function()local f,C=pcall(game.HttpGet,game, arg );if f and C then local f=loadstring(C);if f then if  arg4 then local C,m=pcall(f);f=C and typeof(m)=="function"and m or nil;end;if f then return task.spawn(f,table.unpack( arg2 or{}));end;end;end;if  arg3 then  arg3 ();end;end)
end

local fn3

fn3 = function()
	local character = localPlayer.Character
	return character and character:FindFirstChild("HumanoidRootPart")
end

local fn4

fn4 = function()
	local character = localPlayer.Character
	return character and character:FindFirstChildOfClass("Humanoid")
end

local fn5

fn5 = function(arg, arg2, arg3, arg4)
	if arg4:find("HumanoidRoot") and arg then
		local vector = Vector3.new(arg2.X - arg.Position.X, 0, arg2.Z - arg.Position.Z)

		if vector.Magnitude > 0.01 then
			arg.CFrame = arg.CFrame:Lerp(CFrame.lookAt(arg.Position, arg.Position + vector.Unit), arg3)
		end
	end

	if arg4:find("Camera") then
		local currentCamera2 = workspace.CurrentCamera

		if currentCamera2 then
			currentCamera2.CFrame = currentCamera2.CFrame:Lerp(CFrame.lookAt(currentCamera2.CFrame.Position, arg2), arg3)
		end
	end
end

local fn6

fn6 = function(arg)
	if not remoteEvent then
		return
	end
	remoteEvent:FireServer("UseActorAbility", { buffer.fromstring(string.pack("<Bi4", 3, #arg) .. arg) })
end

local fn7, fn8, fn9
local tbl3 = {}

fn7 = function(arg)
	if tbl3[arg.name] then
		return nil
	end

	if arg.mobileOnly and not UserInputService.TouchEnabled then
		return nil
	end

	local TextButton = forsakenFK.make("TextButton", {
		Size = arg.size or UDim2.new(0, 100, 0, 40),
		Position = arg.position or UDim2.new(0.5, 0, 0.6, 0),
		BackgroundColor3 = arg.backgroundColor3 or Color3.fromRGB(30, 30, 30),
		BorderColor3 = arg.borderColor3 or Color3.fromRGB(255, 255, 255),
		BorderSizePixel = arg.borderSizePixel or 2,
		Text = arg.text or "BUTTON",
		TextColor3 = arg.textColor3 or Color3.fromRGB(255, 255, 255),
		TextSize = arg.textSize or 14,
		Font = arg.font or Enum.Font.GothamBold,
		Active = true,
		Draggable = arg.draggable ~= false,
	})

	local ScreenGui = forsakenFK.make("ScreenGui", { Name = arg.name .. "Gui", Children = { TextButton } }, CoreGui)
	local TextButton2 = nil

	if arg.showClose ~= false then
		TextButton2 = forsakenFK.make("TextButton", {
			Size = arg.closeSize or UDim2.new(0, 20, 0, 20),
			Position = arg.closePosition or UDim2.new(1, -20, 0, 0),
			BackgroundColor3 = arg.closeBackgroundColor3 or Color3.fromRGB(255, 0, 0),
			Text = arg.closeText or "X",
			TextColor3 = arg.closeTextColor3 or Color3.fromRGB(255, 255, 255),
			TextSize = arg.closeTextSize or 12,
			Font = arg.closeFont or Enum.Font.GothamBold,
		}, TextButton)
	end

	local function fn10()
		ScreenGui:Destroy()
		tbl3[arg.name] = nil

		if arg.onClose then
			arg.onClose()
		end
	end

	TextButton.MouseButton1Click:Connect(function()
		if arg.onClick then
			arg.onClick(TextButton)
		end
	end)

	if TextButton2 then
		TextButton2.MouseButton1Click:Connect(fn10)
	end

	tbl3[arg.name] = {
		gui = ScreenGui,
		button = TextButton,
		closeButton = TextButton2,
		remove = fn10,
		updateText = function(text)
			if TextButton then
				TextButton.Text = text
			end
		end,
	}

	return tbl3[arg.name]
end

fn8 = function(arg)
	local v3 = tbl3[arg]

	if v3 and v3.remove then
		v3.remove()
	end
end

fn9 = function(f)return  tbl3 [f];end
local fn10
fn10 = function()local f= localPlayer .Character;local Q=f and f.Parent;if not Q then return"Spectating";end;f=Q.Name;if f=="Survivors"or f=="Killers"then return f;end;return"Spectating";end
local tbl4
tbl4 = {}
local fn11

fn11 = function(arg)
	if tbl4[arg] then
		tbl4[arg]:Disconnect()
		tbl4[arg] = nil
	end
end

local fn12

fn12 = function(arg)
	fn11(arg)
	local flag = arg == "Shoot"

	if flag and 120 then
	end

	if flag and 0.25 then
	end

	if flag and 0.013888888888888888 then
	end

	tbl4[arg] = RunService.RenderStepped:Connect(function(...) end)
end

local fn13
local tbl5 = { Track = nil, AnimObj = nil }

fn13 = function()
	local character = localPlayer.Character
	if not character then
		return
	end
	local tbl6 = {}
	local torso = character:FindFirstChild("Torso")
	local upperTorso = character:FindFirstChild("UpperTorso")
	local lowerTorso = character:FindFirstChild("LowerTorso")
	local findFirstChild = character.FindFirstChild
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	tbl6[1] = torso
	tbl6[2] = upperTorso
	tbl6[3] = lowerTorso
	tbl6[4] = humanoidRootPart

	do
		local values = table.pack(findFirstChild(character, "Head"))
		table.move(values, 1, values.n, 5, tbl6)
	end

	if not tbl.Invisibility then
		for _, v3 in ipairs(tbl6) do
			if v3 then
				v3.CanCollide = true
			end
		end

		if tbl5.Track then
			tbl5.Track:Stop()
			tbl5.Track = nil
		end
	else
		for _, v3 in ipairs(tbl6) do
			if v3 then
				v3.CanCollide = false
			end
		end

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		humanoid = humanoid and humanoid:FindFirstChildOfClass("Animator")

		if humanoid then
			if not tbl5.AnimObj then
				tbl5.AnimObj = Instance.new("Animation")
				tbl5.AnimObj.AnimationId = "rbxassetid://75804462760596"
			end

			if tbl5.Track then
				tbl5.Track:Stop()
			end

			tbl5.Track = humanoid:LoadAnimation(tbl5.AnimObj)
			tbl5.Track:Play()
			tbl5.Track:AdjustSpeed(0)
		end
	end
end

local fn14

fn14 = function(arg)
	local originPos = arg.OriginPos
	local searchType = arg.SearchType or "World_3D"
	local targetFolder = arg.TargetFolder
	local maxDistance = arg.MaxDistance or math.huge
	local fovRadius = arg.FOVRadius or math.huge
	local wallCheck = arg.WallCheck or false
	local ignoreList = arg.IgnoreList or {}
	if not targetFolder or not originPos then
		return nil, nil
	end
	local currentCamera2 = workspace.CurrentCamera
	local children

	if targetFolder == killers then
		children = forsakenFK.Roster.killers()
	elseif targetFolder == survivors then
		children = forsakenFK.Roster.survivors()
	else
		children = targetFolder:GetChildren()
	end

	local huge = math.huge
	local v3 = nil
	local v4 = nil

	for _, child in ipairs(children) do
		local humanoidRootPart = child:FindFirstChild("HumanoidRootPart")
		local humanoid = child:FindFirstChild("Humanoid")

		if humanoidRootPart and humanoid and humanoid.Health > 0 then
			local flag = false

			for _, v5 in ipairs(ignoreList) do
				if child == v5 then
					flag = true
					break
				end
			end

			if not flag then
				local magnitude = (humanoidRootPart.Position - currentCamera2.CFrame.Position).Magnitude

				if searchType == "World_3D" then
					magnitude = (humanoidRootPart.Position - originPos).Magnitude
				end

				if magnitude <= maxDistance then
					if wallCheck then
						local v5 = forsakenFK.rayParams(ignoreList)
						local position = currentCamera2.CFrame.Position
						local hit = workspace:Raycast(position, humanoidRootPart.Position - position, v5)

						if not (hit and not hit.Instance:IsDescendantOf(child)) then
							if searchType == "World_3D" then
								if magnitude < huge then
									huge = magnitude
									v3 = child
									v4 = humanoidRootPart
								end
							elseif searchType == "Screen_2D" then
								local v6, v7 = currentCamera2:WorldToViewportPoint(humanoidRootPart.Position)

								if v7 then
									local magnitude2 = (Vector2.new(v6.X, v6.Y) - originPos).Magnitude

									if magnitude2 <= fovRadius and magnitude2 < huge then
										huge = magnitude2
										v3 = child
										v4 = humanoidRootPart
									end
								end
							end
						end
					elseif searchType == "World_3D" then
						if magnitude < huge then
							huge = magnitude
							v3 = child
							v4 = humanoidRootPart
						end
					elseif searchType == "Screen_2D" then
						local v5, v6 = currentCamera2:WorldToViewportPoint(humanoidRootPart.Position)

						if v6 then
							local magnitude2 = (Vector2.new(v5.X, v5.Y) - originPos).Magnitude

							if magnitude2 <= fovRadius and magnitude2 < huge then
								huge = magnitude2
								v3 = child
								v4 = humanoidRootPart
							end
						end
					end
				end
			end
		end
	end

	return v3, v4
end

local fn15

fn15 = function(arg)
	local v3 = fn3()
	local vector2 = arg.Screen2D and Vector2.new(currentCamera.ViewportSize.X / 2, currentCamera.ViewportSize.Y / 2) or v3 and v3.Position
	if not vector2 then
		return nil, nil
	end

	return fn14({
		OriginPos = vector2,
		SearchType = arg.Screen2D and "Screen_2D" or "World_3D",
		TargetFolder = arg.Folder,
		MaxDistance = arg.MaxDist or math.huge,
		FOVRadius = arg.FOV or math.huge,
		WallCheck = arg.WallCheck or false,
		IgnoreList = arg.IgnoreSelf and { localPlayer.Character } or {},
	})
end

local Info = v2:AddCategory("Home"):AddTab("Info", "Text")

fn2("https://raw.githubusercontent.com/zxcursedsocute/Forsaken-Script/refs/heads/main/info2.txt", { Info, v2 }, function()
	Info:AddParagraph("Error", "Failed to load info section")
end)

task.wait()
local Main
Main = v2:AddCategory("Main")
local Sprinting

do
	local Stamina = Main:AddTab("Stamina", "Run")
	Sprinting = nil

	pcall(function()
		Sprinting = require(ReplicatedStorage.Systems.Character.Game.Sprinting)
	end)

	local tbl6 = {
		Survivor = {
			MaxStamina = { Enabled = false, Value = 100 },
			StaminaGain = { Enabled = false, Value = 20 },
			StaminaLoss = { Enabled = false, Value = 10 },
			SprintSpeed = { Enabled = false, Value = 26 },
		},
		Killer = {
			MaxStamina = { Enabled = false, Value = 110 },
			StaminaGain = { Enabled = false, Value = 21 },
			StaminaLoss = { Enabled = false, Value = 9.5 },
			SprintSpeed = { Enabled = false, Value = 28 },
		},
		Staff = { InfStamina = false, AlwaysSprint = false },
		Management = { Enabled = false, ThresholdPercent = 20, RecoverPercent = 95, IsRecovering = false },
	}

	local connection = nil
	local flag = false
	local tbl7 = {}
	local character = nil
	local ScreenGui = nil
	local TextLabel = nil
	local connection2 = nil

	local function fn16()
		if not Sprinting then
			return
		end

		tbl7 = {
			MaxStamina = Sprinting.MaxStamina,
			MinStamina = Sprinting.MinStamina,
			StaminaGain = Sprinting.StaminaGain,
			StaminaLoss = Sprinting.StaminaLoss,
			SprintSpeed = Sprinting.SprintSpeed,
			StaminaLossDisabled = Sprinting.StaminaLossDisabled,
		}

		if Sprinting.DefaultConfig then
			tbl7.DefaultConfig = {
				MaxStamina = Sprinting.DefaultConfig.MaxStamina,
				MinStamina = Sprinting.DefaultConfig.MinStamina,
				StaminaGain = Sprinting.DefaultConfig.StaminaGain,
				StaminaLoss = Sprinting.DefaultConfig.StaminaLoss,
				SprintSpeed = Sprinting.DefaultConfig.SprintSpeed,
				StaminaLossDisabled = Sprinting.DefaultConfig.StaminaLossDisabled,
			}
		end
	end

	local function fn17(arg)
		if not Sprinting then
			return
		end

		if tbl7[arg] ~= nil then
			Sprinting[arg] = tbl7[arg]
		end

		if Sprinting.DefaultConfig and tbl7.DefaultConfig and tbl7.DefaultConfig[arg] ~= nil then
			Sprinting.DefaultConfig[arg] = tbl7.DefaultConfig[arg]
		end
	end

	local function fn18(arg, arg2)
		if not Sprinting then
			return
		end

		if Sprinting.DefaultConfig then
			Sprinting.DefaultConfig[arg] = arg2
		end

		Sprinting[arg] = arg2
	end

	local function fn19()
		if Sprinting then
			Sprinting.IsSprinting = false

			if Sprinting.__sprintedEvent then
				Sprinting.__sprintedEvent:Fire(false)
			end
		end
	end

	local function fn20()
		if not localPlayer.Character or not Sprinting then
			return
		end

		if character ~= localPlayer.Character then
			character = localPlayer.Character
			fn16()
		end

		local character2 = localPlayer.Character
		local name = character2.Parent and character2.Parent.Name or ""
		local survivor

		if name == "Survivors" then
			survivor = tbl6.Survivor
		else
			if name ~= "Killers" then
				for _, v3 in pairs({ "MaxStamina", "StaminaGain", "StaminaLoss", "SprintSpeed", "StaminaLossDisabled" }) do
					fn17(v3)
				end

				return
			end

			survivor = tbl6.Killer
		end

		if survivor.MaxStamina.Enabled then
			fn18("MaxStamina", tonumber(survivor.MaxStamina.Value))
		else
			fn17("MaxStamina")
		end

		if survivor.StaminaGain.Enabled then
			fn18("StaminaGain", tonumber(survivor.StaminaGain.Value))
		else
			fn17("StaminaGain")
		end

		if survivor.StaminaLoss.Enabled then
			fn18("StaminaLoss", tonumber(survivor.StaminaLoss.Value))
		else
			fn17("StaminaLoss")
		end

		if survivor.SprintSpeed.Enabled then
			fn18("SprintSpeed", tonumber(survivor.SprintSpeed.Value))
		else
			fn17("SprintSpeed")
		end

		if tbl6.Staff.InfStamina then
			fn18("StaminaLossDisabled", true)
		else
			fn17("StaminaLossDisabled")
		end
	end

	local function fn21()
		fn20()
		local flag2 = false

		for _, v3 in pairs({ "Survivor", "Killer" }) do
			for _, v4 in pairs({ "MaxStamina", "StaminaGain", "StaminaLoss", "SprintSpeed" }) do
				if tbl6[v3][v4].Enabled then
					flag2 = true
				end
			end
		end

		if tbl6.Staff.InfStamina then
			flag2 = true
		end

		if flag2 and not connection then
			connection = localPlayer.CharacterAdded:Connect(function(character2)
				task.wait(1)
				character = character2
				fn16()
				fn20()
			end)
		elseif not flag2 and connection then
			connection:Disconnect()
			connection = nil
		end

		local enabled = tbl6.Management.Enabled or tbl6.Staff.AlwaysSprint or tbl6.Staff.InfStamina

		if enabled and not flag then
			flag = true

			task.spawn(function()
				while flag do
					task.wait(0.1)

					if Sprinting then
						local stamina = Sprinting.Stamina or 100
						local maxStamina = Sprinting.MaxStamina or 100

						if tbl6.Staff.InfStamina then
							Sprinting.Stamina = maxStamina
						end

						if tbl6.Staff.AlwaysSprint then
							if not Sprinting.IsSprinting then
								Sprinting.IsSprinting = true

								if Sprinting.__sprintedEvent then
									Sprinting.__sprintedEvent:Fire(true)
								end
							end
						end

						if tbl6.Management.Enabled then
							if stamina / maxStamina * 100 <= tbl6.Management.ThresholdPercent then
								fn18("BindsEnabled", false)
								fn19()
							else
								fn18("BindsEnabled", true)
							end
						end
					end
				end

				fn19()
				fn18("BindsEnabled", true)
			end)
		elseif not enabled and flag then
			flag = false
			fn19()
			fn18("BindsEnabled", true)
		end
	end

	local n = 100
	local n2 = 0
	local flag2 = false
	local color = Color3.fromRGB(100, 255, 100)
	local color2 = Color3.fromRGB(255, 255, 100)
	local color3 = Color3.fromRGB(255, 100, 100)
	local n3 = -1
	local n4 = -1

	local function fn22(arg)
		if arg then
			if not connection2 then
				connection2 = RunService.Heartbeat:Connect(function(...) end)
			end
		elseif connection2 then
			connection2:Disconnect()
			connection2 = nil
		end
	end

	local function fn23(arg, arg2, arg3)
		local tbl8 = {}
		local v3 = arg3

		for _, v4 in ipairs(v3) do
			local v5 = v4[1]
			local v6 = v4[3]
			local v7 = v4[4]

			tbl8[#tbl8 + 1] = Stamina:AddToggle({
				Name = v4[2],
				Callback = function(enabled)
					arg[v5].Enabled = enabled
					fn21()
				end,
			})

			tbl8[#tbl8 + 1] = Stamina:AddInput({
				Name = v6,
				Default = v7,
				SaveUserText = true,
				Callback = function(arg4)
					arg[v5].Value = tonumber(arg4) or tonumber(v7)
					fn21()
				end,
			})
		end

		Stamina:AddList({ Name = arg2, Elems = tbl8 })
		return tbl8
	end

	local v3 = fn23(tbl6.Survivor, "Stamina system (Survivor)", {
		{ "MaxStamina", "Enable Stamina Max", "Max Stamina Value", "100" },
		{ "StaminaGain", "Enable Stamina Gain", "Stamina Gain Value", "20" },
		{ "StaminaLoss", "Enable Stamina Loss", "Stamina Loss Value", "10" },
		{ "SprintSpeed", "Enable Sprint Speed", "Sprint Speed Value", "26" },
	})

	local v4 = fn23(tbl6.Killer, "Stamina system (Killer)", {
		{ "MaxStamina", "Enable k-Stamina Max", "Max k-Stamina Value", "110" },
		{ "StaminaGain", "Enable k-Stamina Gain", "Stamina k-Gain Value", "20" },
		{ "StaminaLoss", "Enable k-Stamina Loss", "Stamina k-Loss Value", "10" },
		{ "SprintSpeed", "Enable k-Sprint Speed", "Sprint k-Speed Value", "28" },
	})

	local v5 = v3[2]
	local v6 = v3[4]
	local v7 = v3[6]
	local v8 = v3[8]
	local v9 = v4[2]
	local v10 = v4[4]
	local v11 = v4[6]
	local v12 = v4[8]

	local v13 = Stamina:AddButton({
		Name = "Load Recommended stats",
		Callback = function()
			tbl6.Survivor.MaxStamina.Value = "110"
			v5.SetText("110")
			tbl6.Survivor.StaminaGain.Value = "25"
			v6.SetText("25")
			tbl6.Killer.MaxStamina.Value = "120"
			v9.SetText("120")
			tbl6.Killer.StaminaGain.Value = "28"
			v10.SetText("28")
			fn21()
			v2:Notification({ Name = "Stamina", Description = "Recommended stats loaded", Duration = 3 })
		end,
	})

	local v14 = Stamina:AddButton({
		Name = "Load Blatant Stats",
		Callback = function()
			tbl6.Survivor.MaxStamina.Value = "150"
			v5.SetText("150")
			tbl6.Survivor.StaminaGain.Value = "30"
			v6.SetText("30")
			tbl6.Survivor.StaminaLoss.Value = "8"
			v7.SetText("8")
			tbl6.Survivor.SprintSpeed.Value = "27"
			v8.SetText("27")
			tbl6.Killer.MaxStamina.Value = "150"
			v9.SetText("150")
			tbl6.Killer.StaminaGain.Value = "30"
			v10.SetText("30")
			tbl6.Killer.StaminaLoss.Value = "8"
			v11.SetText("8")
			tbl6.Killer.SprintSpeed.Value = "29"
			v12.SetText("29")
			fn21()
			v2:Notification({ Name = "Stamina", Description = "Blatant stats loaded", Duration = 3 })
		end,
	})

	local v15 = Stamina:AddButton({
		Name = "Reset Settings",
		Callback = function()
			tbl6.Survivor.MaxStamina.Value = 100
			tbl6.Survivor.StaminaGain.Value = 20
			tbl6.Survivor.StaminaLoss.Value = 10
			tbl6.Survivor.SprintSpeed.Value = 26
			tbl6.Killer.MaxStamina.Value = 110
			tbl6.Killer.StaminaGain.Value = 21
			tbl6.Killer.StaminaLoss.Value = 9.5
			tbl6.Killer.SprintSpeed.Value = 28
			v5.SetText("100")
			v6.SetText("20")
			v7.SetText("10")
			v8.SetText("26")
			v9.SetText("110")
			v10.SetText("21")
			v11.SetText("9.5")
			v12.SetText("28")
			fn21()
			v2:Notification({ Name = "Stamina", Description = "Settings Reset", Duration = 3 })
		end,
	})

	Stamina:AddList({ Name = "Stamina Stats", Elems = { v13, v14, v15 } })

	local v16 = Stamina:AddToggle({
		Name = "Infinite Stamina",
		Callback = function(infStamina)
			tbl6.Staff.InfStamina = infStamina
			fn21()
		end,
	})

	local v17 = Stamina:AddToggle({
		Name = "Always Sprint",
		Callback = function(alwaysSprint)
			tbl6.Staff.AlwaysSprint = alwaysSprint

			if not alwaysSprint then
				fn19()
			end

			fn21()
		end,
	})

	local v18 = Stamina:AddToggle({
		Name = "Show Legit Stamina View",
		Callback = function(arg)
			if arg then
				if not ScreenGui then
					ScreenGui = forsakenFK.make("ScreenGui", { Name = "LegitStaminaView", ResetOnSpawn = false })
					local hui = nil

					if type(gethui) == "function" then
						pcall(function()
							hui = gethui()
						end)
					end

					if not hui then
						pcall(function()
							hui = CoreGui
						end)
					end

					ScreenGui.Parent = hui or localPlayer:WaitForChild("PlayerGui")

					TextLabel = forsakenFK.make("TextLabel", {
						Size = UDim2.new(0, 100, 0, 30),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						BackgroundTransparency = 0.5,
						BackgroundColor3 = Color3.fromRGB(20, 20, 20),
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 18,
						Font = Enum.Font.GothamBold,
						Text = "100/100",
						Children = { forsakenFK.make("UICorner", { CornerRadius = UDim.new(0, 6) }) },
					}, ScreenGui)
				end

				fn22(true)
			else
				if ScreenGui then
					ScreenGui:Destroy()
					ScreenGui = nil
					TextLabel = nil
				end

				fn22(false)
			end
		end,
	})

	local connection3 = nil

	Stamina:AddList({
		Name = "Stamina Staff",
		Elems = {
			v16,
			Stamina:AddToggle({
				Name = "No Stamina Penalty",
				Callback = function(arg)
					if connection3 then
						connection3:Disconnect()
						connection3 = nil
					end

					if not arg then
						return
					end
					connection3 = RunService.Heartbeat:Connect(function(...) end)
				end,
			}),
			v17,
			v18,
		},
	})

	local v19 = Stamina:AddToggle({
		Name = "Enable Stamina Management",
		Callback = function(enabled)
			tbl6.Management.Enabled = enabled

			if not enabled then
				fn18("BindsEnabled", true)
			end

			fn21()
		end,
	})

	local v20 = Stamina:AddInput({
		Name = "Disable Sprint at %",
		Default = "10",
		SaveUserText = true,
		Callback = function(arg)
			tbl6.Management.ThresholdPercent = tonumber(arg) or 20
			fn21()
		end,
	})

	Stamina:AddList({ Name = "Stamina management", Elems = { v19, v20 } })
end

task.wait()
local Visual
Visual = Main:AddTab("Visual", "Visual")

createHighlight = function(adornee, fillColor, arg)
	if not adornee or not adornee.Parent then
		return
	end

	if arg and arg.CheckWorkspace then
		local ok, result = pcall(function()
			return adornee:IsDescendantOf(workspace)
		end)

		if not ok or not result then
			return
		end
	end

	local highlight = adornee:FindFirstChild("Highlight")

	if highlight then
		highlight:Destroy()
	end

	local highlight2 = Instance.new("Highlight")
	highlight2.Adornee = adornee
	highlight2.FillColor = fillColor
	highlight2.OutlineColor = fillColor
	highlight2.FillTransparency = arg and arg.FillTransparency or tbl.HFillTransparency or 0.8
	highlight2.OutlineTransparency = arg and arg.OutlineTransparency or tbl.DisableOutline or 0
	highlight2.Parent = adornee
	return highlight2
end

do
	local name = "External_Protected_HL"
	local tbl6 = {}

	createHighlight2 = function(adornee, fillColor)
		if not adornee or not adornee.Parent then
			return
		end
		local name2 = localPlayer.Name
		if adornee:GetAttribute("Username") == name2 then
			return
		end

		if tbl6[adornee] then
			local externalProtectedHl = adornee:FindFirstChild("External_Protected_HL")

			if externalProtectedHl then
				externalProtectedHl.FillColor = fillColor
				externalProtectedHl.OutlineColor = fillColor
				return
			end
		end

		local function fn16()
			for _, descendant in ipairs(adornee:GetDescendants()) do
				if descendant:IsA("Highlight") and descendant.Name ~= name then
					descendant:Destroy()
					break
				end
			end

			local externalProtectedHl = adornee:FindFirstChild("External_Protected_HL")

			if not externalProtectedHl then
				externalProtectedHl = Instance.new("Highlight")
				externalProtectedHl.Name = name
				externalProtectedHl.Adornee = adornee
				externalProtectedHl.Parent = adornee
			end

			externalProtectedHl.FillColor = fillColor
			externalProtectedHl.OutlineColor = fillColor
			externalProtectedHl.FillTransparency = tbl.HFillTransparency or 0.5
			externalProtectedHl.OutlineTransparency = tbl.DisableOutline or 0
			externalProtectedHl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		end

		fn16()

		tbl6[adornee] = adornee.ChildAdded:Connect(function(child)
			if child:IsA("Highlight") and child.Name ~= name then
				task.wait(3)

				task.defer(function()
					if child.Parent then
						child:Destroy()
					end

					fn16()
				end)
			end
		end)
	end

	local connection = nil
	local connection2 = nil
	local connection3 = nil

	killerEsp = function()
		local v3 = killers

		if connection2 then
			connection2:Disconnect()
		end

		if connection3 then
			connection3:Disconnect()
		end

		if tbl.KillerEsp then
			for _, child in ipairs(killers:GetChildren()) do
				createHighlight2(child, tbl.EspKillerColor)
			end

			for _, child in ipairs(ingame:GetChildren()) do
				local humanoid = child:FindFirstChildOfClass("Humanoid")

				if humanoid and not Players:GetPlayerFromCharacter(child) and humanoid.WalkSpeed ~= 16 and humanoid.WalkSpeed ~= 26 then
					createHighlight2(child, tbl.EspKillerSupportColor)
				elseif child:IsA("Folder") and string.sub(child.Name, -7) == "Shadows" then
					for _, child2 in ipairs(child:GetChildren()) do
						if child2.Name == "Shadow" then
							child2.Transparency = 0
							createHighlight2(child2, tbl.EspKillerSupportColor)
						end
					end
				elseif string.sub(child.Name, -12) == "JohnDoeTrail" then
					local trailESPModel = child:FindFirstChild("TrailESPModel")

					if not trailESPModel then
						trailESPModel = Instance.new("Model")
						trailESPModel.Name = "TrailESPModel"
						trailESPModel.Parent = child
					end

					for _, child2 in ipairs(child:GetChildren()) do
						if child2:IsA("BasePart") then
							child2.Transparency = 0
							child2.Parent = trailESPModel
						end
					end

					createHighlight2(trailESPModel, tbl.EspKillerColor)
				end
			end

			connection2 = v3.ChildAdded:Connect(function(child)
				task.wait(0.5)
				createHighlight2(child, tbl.EspKillerColor)
			end)

			connection3 = ingame.ChildAdded:Connect(function(child)
				task.wait(0.5)
				local humanoid = child:FindFirstChildOfClass("Humanoid")

				if humanoid and not Players:GetPlayerFromCharacter(child) and humanoid.WalkSpeed ~= 16 and humanoid.WalkSpeed ~= 26 then
					createHighlight2(child, tbl.EspKillerSupportColor)
				elseif child:IsA("Folder") and string.sub(child.Name, -7) == "Shadows" then
					child.ChildAdded:Connect(function(child2)
						if child2.Name == "Shadow" then
							child2.Transparency = 0
							createHighlight2(child2, tbl.EspKillerSupportColor)
						end
					end)
				elseif string.sub(child.Name, -12) == "JohnDoeTrail" then
					local model = Instance.new("Model")
					model.Name = "TrailESPModel"
					model.Parent = child

					for _, child2 in ipairs(child:GetChildren()) do
						if child2:IsA("BasePart") then
							child2.Transparency = 0
							child2.Parent = model
						end
					end

					createHighlight2(model, tbl.EspKillerColor)
				end
			end)
		else
			for _, child in ipairs(killers:GetChildren()) do
				if tbl6[child] then
					tbl6[child]:Disconnect()
					tbl6[child] = nil
				end

				local externalProtectedHl = child:FindFirstChild("External_Protected_HL") or child:FindFirstChild("Highlight")

				if externalProtectedHl then
					externalProtectedHl:Destroy()
				end
			end

			for _, descendant in ipairs(ingame:GetDescendants()) do
				if descendant.Name == name then
					descendant:Destroy()
				end

				if descendant.Name == "Shadow" then
					descendant.Transparency = 1
				end
			end

			for _, child in ipairs(ingame:GetChildren()) do
				if string.sub(child.Name, -12) == "JohnDoeTrail" then
					local trailESPModel = child:FindFirstChild("TrailESPModel")

					if trailESPModel then
						for _, child2 in ipairs(trailESPModel:GetChildren()) do
							if child2:IsA("BasePart") then
								child2.Transparency = 1
								child2.Parent = child
							end
						end

						trailESPModel:Destroy()
					end

					for _, child2 in ipairs(child:GetChildren()) do
						if child2:IsA("BasePart") then
							child2.Transparency = 1
						end
					end
				end
			end
		end
	end

	killerEspColorUpdate = function()
		if tbl.KillerEsp then
			for _, descendant in pairs(Workspace.Players.Killers:GetDescendants()) do
				if descendant.ClassName == "Highlight" and descendant.Name == name then
					descendant.FillColor = tbl.EspKillerColor
					descendant.OutlineColor = tbl.EspKillerColor
				end
			end
		end
	end

	killerSupportsEspColorUpdate = function()
		if tbl.KillerEsp then
			for _, descendant in pairs(ingame:GetDescendants()) do
				if descendant.ClassName == "Highlight" and descendant.Name == name then
					descendant.FillColor = tbl.EspKillerSupportColor
					descendant.OutlineColor = tbl.EspKillerSupportColor
				end
			end
		end
	end

	survivorsEsp = function()
		local survivors2 = workspace:WaitForChild("Players"):WaitForChild("Survivors")

		if connection then
			connection:Disconnect()
		end

		if tbl.SurvivorsEsp then
			for _, child in ipairs(survivors2:GetChildren()) do
				createHighlight2(child, tbl.EspSurvivorsColor)
			end

			connection = survivors2.ChildAdded:Connect(function(child)
				task.wait(0.5)
				createHighlight2(child, tbl.EspSurvivorsColor)
			end)
		else
			for _, child in ipairs(survivors2:GetChildren()) do
				if tbl6[child] then
					tbl6[child]:Disconnect()
					tbl6[child] = nil
				end

				local externalProtectedHl = child:FindFirstChild("External_Protected_HL")

				if externalProtectedHl then
					externalProtectedHl:Destroy()
				end
			end
		end
	end

	survivorsEspColorUpdate = function()
		if tbl.SurvivorsEsp then
			for _, descendant in pairs(Workspace.Players.Survivors:GetDescendants()) do
				if descendant.ClassName == "Highlight" and descendant.Name == name then
					descendant.FillColor = tbl.EspSurvivorsColor
					descendant.OutlineColor = tbl.EspSurvivorsColor
				end
			end
		end
	end
end

Visual:AddSection("Jane Doe Quest")
local tbl6

do
	local flag = false
	Color3.fromRGB(0, 255, 255)
	tbl6 = {}
	local connection = nil
	local connection2 = nil
	local function fn16(...) end

	local function fn17()
		for _, v3 in pairs(tbl6) do
			v3:Remove()
		end

		tbl6 = {}
	end

	local function fn18(arg)
		if arg.Name == "Model" and arg:IsA("MeshPart") then
			if not tbl6[arg] then
				local flag2 = false

				for _, child in ipairs(arg:GetChildren()) do
					if child:IsA("Sound") and child.SoundId == "rbxassetid://9112795583" then
						flag2 = true
						break
					end
				end

				if flag2 then
					tbl6[arg] = fn16("📁 FOLDER")
				else
					tbl6[arg] = fn16("💍 RING")
				end
			end
		end
	end

	local function fn19(...) end

	local function fn20(arg)
		flag = arg

		if flag then
			fn17()

			for _, child in pairs(workspace:GetChildren()) do
				fn18(child)
			end

			if not connection then
				connection = workspace.ChildAdded:Connect(function(child)
					task.wait(0.2)
					fn18(child)
				end)
			end

			if not connection2 then
				connection2 = RunService.RenderStepped:Connect(fn19)
			end
		else
			if connection then
				connection:Disconnect()
				connection = nil
			end

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			fn17()
		end
	end

	Visual:AddToggle({
		Name = "Folder and ring esp",
		Callback = function(arg)
			fn20(arg)
		end,
	})
end

Visual:AddButton({
	Name = "TP to basement",
	Callback = function()
		localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3540.63892, -391.070618, 304.589996, 1, 2.37853248e-09, -4.93194786e-13, -2.37853248e-09, 1, -1.67291834e-08, 4.93154996e-13, 1.67291834e-08, 1)
	end,
})

Visual:AddSection("Players")

Visual:AddToggle({
	Name = "Killer esp",
	Callback = function(killerEsp_)
		tbl.KillerEsp = killerEsp_
		killerEsp()
	end,
})

Visual:AddToggle({
	Name = "Survivors esp",
	Callback = function(survivorsEsp_)
		tbl.SurvivorsEsp = survivorsEsp_
		survivorsEsp()
	end,
})

local tbl7, fn16

do
	local fn17 = gethui and gethui or function()
		return CoreGui
	end

	local flag = false
	tbl7 = {}
	local tbl8 = {}
	local connection = nil
	local connection2 = nil
	local tbl9 = {}
	local forsakenDeviceESP = nil
	local forsakenAbilityESP = nil
	local n = 0.5
	local n2 = 100
	local n3 = 0.5
	local n4 = 100

	local tbl10 = {
		MinStamina = 0,
		MaxStamina = 100,
		SprintSpeed = 26,
		StaminaLoss = 10,
		StaminaGain = 20,
		PenaltyTime = 2,
	}

	local tbl11 = {
		PC = "rbxassetid://135066638879377",
		Mobile = "rbxassetid://89227325753198",
		Console = "rbxassetid://118447973769044",
		Unknown = "rbxassetid://89227325753198",
	}

	local tbl12 = {
		c00lkidd = {
			{ Name = "Punch", Anim = "Attack" },
			{ Name = "CorruptNature", Anim = "CorruptNature" },
			{ Name = "WalkspeedOverride", Anim = "WalkspeedOverrideStart" },
			{ Name = "PizzaDelivery", Anim = "SummonPizzaDelivery" },
		},
		Sixer = {
			{ Name = "Carving Slash", Anim = "Slash.Slash" },
			{ Name = "DemonicPursuit", Anim = "DemonicPursuitStart" },
			{ Name = "InfernalCry", Anim = "Cry" },
			{ Name = "BloodHunt", Anim = "BloodHuntActivate" },
		},
		Nosferatu = {
			{ Name = "Slash", Anim = "Slash" },
			{ Name = "Uppercut", Anim = "Uppercut" },
			{ Name = "Spire", Anim = "SpireStart" },
			{ Name = "Bats", Anim = "BatsThrow" },
			{ Name = "Ascent", Anim = "Ascent" },
		},
		Slasher = {
			{ Name = "Slash", Anim = "Slash" },
			{ Name = "Behead", Anim = "Behead" },
			{ Name = "GashingWound", Anim = "GashingWoundStart" },
			{ Name = "RagingPace", Anim = "EnragedStart" },
		},
		JohnDoe = {
			{ Name = "Slash", Anim = "Slash" },
			{ Name = "CorruptEnergy", Anim = "CorruptEnergy" },
			{ Name = "DigitalFootprint", Anim = "DigitalFootprint" },
		},
		Noli = {
			{ Name = "Stab", Anim = "Stab", CooldownKey = "StabCooldown" },
			{ Name = "VoidRush", Anim = "VoidRush.StartCharge", CooldownKey = "VoidRushC00ldown" },
			{ Name = "Nova", Anim = "NovaThrow", CooldownKey = "NovaCooldown" },
			{ Name = "Observant", Anim = "ObservantStart", CooldownKey = "ObservantC00ldown" },
		},
		Noob = {
			{ Name = "BloxyCola", Anim = "Drinking1", CooldownKey = "BloxyColaCooldown" },
			{
				Name = "SlateskinPotion",
				Anim = "Drinking2",
				CooldownKey = "SlateskinPotionCooldown",
			},
			{ Name = "Ghostburger", Anim = "Eating", CooldownKey = "GhostburgerCooldown" },
		},
		Builderman = {
			{ Name = "Sentry", Anim = "ConstructStart", CooldownKey = "SentryCooldown" },
			{ Name = "Dispenser", Anim = "ConstructStart", CooldownKey = "DispenserCooldown" },
		},
		["007n7"] = {
			{ Name = "Clone", CustomTrigger = "Invisibility", CooldownKey = "CloneCooldown" },
			{ Name = "c00lgui", Anim = "c00lguiStart", CooldownKey = "c00lguiCooldown" },
		},
		TwoTime = {
			{ Name = "Dagger", Anim = { "Stab", "LungeStart" }, CooldownKey = "DaggerCooldown" },
			{ Name = "Crouch", CustomTrigger = "Crouching" },
			{ Name = "Ritual", Anim = "Ritual" },
		},
		JaneDoe = { { Name = "Crystal", Anim = "CrystalThrow" }, { Name = "Axe", Anim = "Axe" } },
		Taph = {
			{ Name = "Tripwire", Anim = "TripwirePlaceStart", CooldownKey = "TripwireCooldown" },
			{
				Name = "SubspaceTripmine",
				Anim = "ThrowSubspace",
				CooldownKey = "SubspaceTripmineCooldown",
			},
		},
		Dusekkar = {
			{
				Name = "SpawnProtection",
				Anim = "StaffStartup",
				CooldownKey = "SpawnProtectionCooldown",
			},
			{ Name = "PlasmaBeam", Anim = "StaffShot", CooldownKey = "PlasmaBeamCooldown" },
		},
		Veeronica = {
			{ Name = "Sk8", Anim = "Sk8Start", CooldownKey = "Sk8CD" },
			{ Name = "Broadcast", Anim = "BroadcastSwitch", AlwaysShow = true, CycleIcons = true },
		},
		Chance = {
			{
				Name = "CoinFlip",
				Anim = { "FlipCoinHeads", "FlipCoinTails" },
				CooldownKey = "CoinFlipCooldown",
			},
			{ Name = "Shoot", Anim = "AimGun", CooldownKey = "ShootCooldown" },
			{ Name = "HatFix", Anim = "HatFix", CooldownKey = "HatFixCooldown" },
		},
		Azure = {
			{ Name = "Slash", Anim = "Slash" },
			{ Name = "Unravel", Anim = "Unravel" },
			{ Name = "Sow", Anim = "Sow" },
			{ Name = "Blossom", Anim = "Blossom" },
			{ Name = "Pummeling", Anim = "GolemSlash" },
			{ Name = "Blooming", Anim = "GolemShockwave" },
			{ Name = "Burrowing", Anim = "Burrowing" },
			{ Name = "Unearthing", Anim = "Unearthing" },
		},
	}

	local tbl13 = { "rbxassetid://99218231350350", "rbxassetid://115049033276951", "rbxassetid://70948225384237" }
	local tbl14 = { BloxyCola = 10, SlateskinPotion = 6, Ghostburger = 10 }

	fn16 = function(arg)
		if not assets then
			return nil
		end
		local v3 = assets

		for _, v4 in ipairs(arg) do
			if v3:FindFirstChild(v4) then
				v3 = v3[v4]
				continue
			end
			return nil
		end

		if v3:IsA("ModuleScript") then
			local ok, result = pcall(require, v3)
			if ok and type(result) == "table" then
				return result
			end
		end

		return nil
	end

	local function fn18(arg, arg2, arg3)
		if not arg then
			return {}
		end
		local tbl15

		if type(arg2) == "string" then
			tbl15 = { arg2 }
		else
			tbl15 = arg2
		end

		local tbl16 = {}

		local function fn19(arg4)
			if type(arg4) == "string" or type(arg4) == "number" then
				return string.match(tostring(arg4), "%d+")
			end
			return nil
		end

		if arg3 and arg[arg3] then
			local v3 = fn19(arg[arg3])

			if v3 then
				table.insert(tbl16, v3)
			end
		end

		if tbl15 then
			for _, v3 in ipairs(tbl15) do
				if arg[v3] then
					local v4 = fn19(arg[v3])

					if v4 then
						table.insert(tbl16, v4)
					end
				end

				local v4 = string.split(v3, ".")
				local v5 = arg

				for _, v6 in ipairs(v4) do
					if type(v5) == "table" then
						v5 = v5[v6]
					else
						v5 = nil
						break
					end
				end

				local v6 = fn19(v5)

				if v6 then
					table.insert(tbl16, v6)
				end

				if #v4 > 1 then
					local v7 = v4[#v4]

					if arg[v7] then
						local v8 = fn19(arg[v7])

						if v8 then
							table.insert(tbl16, v8)
						end
					end
				end
			end
		end

		if #tbl16 == 0 then
			local fn20 = nil

			fn20 = function(arg4)
				for k, v3 in pairs(arg4) do
					if type(v3) == "table" then
						fn20(v3)
					else
						local v4 = fn19(v3)

						if v4 then
							local str2 = tostring(k):lower()
							local pos = arg3 and str2:find(arg3:lower(), 1, true)
							local flag2 = false

							if pos then
								flag2 = true
							end

							if tbl15 then
								for _, v5 in ipairs(tbl15) do
									if str2:find(v5:lower(), 1, true) or v5:lower():find(str2, 1, true) then
										flag2 = true
										break
									end
								end
							end

							if flag2 then
								table.insert(tbl16, v4)
							end
						end
					end
				end
			end

			pcall(fn20, arg)
		end

		return tbl16
	end

	local function fn19(arg)
		local attribute = arg:GetAttribute("CharacterName") or arg.Name
		local attribute2 = arg:GetAttribute("SkinName") or ""
		local str2 = arg.Parent and arg.Parent.Name == "Killers" and "Killers" or "Survivors"
		local v3 = fn16({ str2, attribute, "Config" })
		local v4 = fn16({ str2, attribute, "Behavior" })
		local flag2 = attribute2 ~= "" and fn16({ "Skins", str2, attribute, attribute2, "Config" }) or nil
		local tbl15 = {}

		if v4 and v4.Abilities then
			local v5 = tbl12[attribute]

			if v5 then
				for i, v6 in ipairs(v5) do
					local name = v6.Name
					local v7 = v4.Abilities[name]

					if v7 then
						local icon = v7.Icon or ""

						if name == "Broadcast" and attribute == "Veeronica" then
							icon = tbl13[1]
						end

						local tbl16 = {}
						local cooldown

						if typeof(v7.Cooldown) == "number" then
							cooldown = v7.Cooldown
						elseif v6.CooldownKey and v3 then
							cooldown = v3[v6.CooldownKey]
						else
							cooldown = nil

							if v3 then
								cooldown = v3[name .. "Cooldown"]
							end
						end

						if v6.Anim then
							local anim = v6.Anim

							if flag2 and flag2.Animations then
								tbl16 = fn18(flag2.Animations, anim, name)
							end

							if #tbl16 == 0 and v3 and v3.Animations then
								tbl16 = fn18(v3.Animations, anim, name)
							end
						end

						local activeCondition

						if attribute == "Slasher" and name == "RagingPace" then
							activeCondition = "IsEnraged"
						elseif attribute == "Veeronica" and name == "Sk8" then
							activeCondition = "IsSkating"
						elseif attribute == "Noob" and tbl14[name] then
							activeCondition = name .. "Active"
						else
							local flag3 = attribute == "TwoTime" and name == "Crouch"
							activeCondition = nil

							if flag3 then
								activeCondition = "IsCrouching"
							end
						end

						if #tbl16 > 0 or v6.CustomTrigger then
							local tbl17 = { AnimIds = tbl16 }
							cooldown = cooldown or 0
							tbl17.Cooldown = cooldown
							tbl17.Icon = icon
							tbl17.AlwaysShow = v6.AlwaysShow or false
							tbl17.CycleIcons = v6.CycleIcons or false
							tbl17.CustomTrigger = v6.CustomTrigger
							tbl17.LayoutOrder = i
							tbl17.ActiveCondition = activeCondition
							tbl15[name] = tbl17
						end
					end
				end
			else
				local n5 = 0

				for k, ability in pairs(v4.Abilities) do
					n5 += 1
					local layoutOrder = ability.LayoutOrder or n5
					local icon = ability.Icon or ""
					local cooldown = typeof(ability.Cooldown) == "number" and ability.Cooldown or v3 and v3[k .. "Cooldown"] or 0
					local tbl16 = {}

					if flag2 and flag2.Animations then
						tbl16 = fn18(flag2.Animations, nil, k)
					end

					if #tbl16 == 0 and v3 and v3.Animations then
						tbl16 = fn18(v3.Animations, nil, k)
					end

					if #tbl16 > 0 then
						tbl15[k] = {
							AnimIds = tbl16,
							Cooldown = cooldown,
							Icon = icon,
							AlwaysShow = false,
							CycleIcons = false,
							LayoutOrder = layoutOrder,
							ActiveCondition = nil,
						}
					end
				end
			end
		end

		if next(tbl15) == nil and v3 and v3.Animations then
			local n5 = 0

			for k in pairs(v3.Animations) do
				local v5 = v3[k .. "Cooldown"]

				if v5 then
					local tbl16 = {}

					if flag2 and flag2.Animations then
						tbl16 = fn18(flag2.Animations, nil, k)
					end

					if #tbl16 == 0 then
						tbl16 = fn18(v3.Animations, nil, k)
					end

					if #tbl16 > 0 then
						n5 += 1

						tbl15[k] = {
							AnimIds = tbl16,
							Cooldown = v5,
							Icon = "",
							AlwaysShow = false,
							CycleIcons = false,
							LayoutOrder = n5,
							ActiveCondition = nil,
						}
					end
				end
			end
		end

		return tbl15
	end

	local function fn20(arg, arg2)
		if arg:GetAttribute("FootstepOverride") == "GolemFootsteps" then
			return true
		end

		if arg2 and arg2.AbilityState and arg2.AbilityState.Animator then
			for _, v3 in ipairs(arg2.AbilityState.Animator:GetPlayingAnimationTracks()) do
				if v3.Animation and v3.Animation.AnimationId then
					if tostring(v3.Animation.AnimationId):lower():find("golem") then
						return true
					end
				end
			end
		end

		return false
	end

	local function fn21(arg, arg2)
		if fn20(arg, arg2) then
			return { MaxStamina = 50, StaminaGain = 20, StaminaLoss = 10, MinStamina = 0, PenaltyTime = 2 }
		end
		local str2 = arg.Parent and arg.Parent.Name == "Survivors" and "Survivors" or "Killers"
		local name = arg.Name
		if str2 == "Survivors" then
			return tbl10
		end
		local v3 = fn16({ "Killers", name, "Config" })

		if v3 then
			return {
				MaxStamina = v3.MaxStamina or 100,
				StaminaGain = v3.StaminaGain or 20,
				StaminaLoss = v3.StaminaLoss or 10,
				MinStamina = 0,
				PenaltyTime = 2,
			}
		end

		return tbl10
	end

	local function fn22(arg, arg2, arg3)
		local str2 = arg.Parent and arg.Parent.Name == "Survivors" and "Survivors" or "Killers"
		local name = arg.Name
		local attribute = arg:GetAttribute("SkinName") or ""
		local str3 = arg3 and "GolemRun" or arg2 and "InjuredRun" or "Run"

		if attribute ~= "" then
			local v3 = fn16({ "Skins", str2, name, attribute, "Config" })
			if v3 and v3.Animations and v3.Animations[str3] then
				return v3.Animations[str3]
			end
		end

		local v3 = fn16({ str2, name, "Config" })
		if v3 and v3.Animations and v3.Animations[str3] then
			return v3.Animations[str3]
		end

		if arg3 then
			return "rbxassetid://130480436367274"
		end

		if arg2 then
			local v4 = fn16({ str2, name, "Config" })
			if v4 and v4.Animations and v4.Animations.Run then
				return v4.Animations.Run
			end
		end

		return arg2 and "rbxassetid://115946474977409" or "rbxassetid://136252471123500"
	end

	local function fn23(arg, arg2)
		if not arg then
			return false
		end

		for _, v3 in ipairs(arg:GetPlayingAnimationTracks()) do
			if v3.Animation and v3.Animation.AnimationId then
				local v4 = string.match(tostring(v3.Animation.AnimationId), "%d+")
				if arg2 and v4 == arg2 and v3.WeightCurrent > 0.45 then
					return true
				end
			end
		end

		return false
	end

	local function fn24(arg)
		if arg and arg.MaxHealth > 0 then
			return arg.Health / arg.MaxHealth
		end
		return 1
	end

	local function fn25(arg)
		for k, v3 in pairs(tbl8) do
			if v3.Type == "Survivor" and k.Parent then
				local humanoidRootPart = k:FindFirstChild("HumanoidRootPart")
				if humanoidRootPart and (humanoidRootPart.Position - arg).Magnitude <= n4 then
					return true
				end
			end
		end

		return false
	end

	local function fn26(arg, arg2)
		if not arg.AnimIds then
			return false
		end

		for _, animId in ipairs(arg.AnimIds) do
			if animId == arg2 then
				return true
			end
		end

		return false
	end

	local function fn27(arg)
		local now = os.clock()
		if arg.LastCycleTime and now - arg.LastCycleTime < 0.5 then
			return
		end
		arg.LastCycleTime = now
		arg.BroadcastChannelIndex = arg.BroadcastChannelIndex % 3 + 1
		local v3 = tbl13[arg.BroadcastChannelIndex]

		if v3 then
			arg.Abilities.Broadcast.Icon = v3
			local broadcast = arg.Frames.Broadcast

			if broadcast then
				local imageLabel = broadcast:FindFirstChild("ImageLabel", true)

				if imageLabel and imageLabel:IsA("ImageLabel") then
					imageLabel.Image = v3
				end
			end
		end
	end

	local function fn28(arg, adornee)
		local name = arg.Name .. "_" .. arg:GetDebugId()
		local billboardGui = forsakenAbilityESP:FindFirstChild(name)
		local frame = nil
		local uiScale = nil

		if not billboardGui then
			billboardGui = Instance.new("BillboardGui")
			billboardGui.Name = name
			billboardGui.Size = UDim2.new(0, 250, 0, 60)
			billboardGui.StudsOffsetWorldSpace = Vector3.new(0, 4.5, 0)
			billboardGui.AlwaysOnTop = true
			frame = Instance.new("Frame")
			frame.Name = "MainContainer"
			frame.Size = UDim2.new(1, 0, 1, 0)
			frame.BackgroundTransparency = 1
			frame.AnchorPoint = Vector2.new(0.5, 0.5)
			frame.Position = UDim2.new(0.5, 0, 0.5, 0)
			frame.Parent = billboardGui
			uiScale = Instance.new("UIScale")
			uiScale.Name = "DistanceScale"
			uiScale.Parent = frame
			local uiListLayout = Instance.new("UIListLayout")
			uiListLayout.Parent = frame
			uiListLayout.FillDirection = Enum.FillDirection.Horizontal
			uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			uiListLayout.Padding = UDim.new(0, 4)
			billboardGui.Parent = forsakenAbilityESP
		end

		if billboardGui then
			billboardGui.Adornee = adornee
		end

		if billboardGui and not frame then
			frame = billboardGui:FindFirstChild("MainContainer")
			uiScale = frame and frame:FindFirstChild("DistanceScale")
		end

		return { Gui = billboardGui, MainContainer = frame, DistanceScale = uiScale }
	end

	local function createFrame(arg, name, arg2)
		local billboardCache = arg.BillboardCache
		if not billboardCache or not billboardCache.MainContainer then
			return nil
		end
		local frame = Instance.new("Frame")
		frame.Name = name
		frame.Size = UDim2.new(0, 42, 0, 55)
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.LayoutOrder = arg2.LayoutOrder
		frame.Parent = billboardCache.MainContainer
		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, 0, 0, 12)
		textLabel.BackgroundTransparency = 1
		textLabel.TextColor3 = Color3.fromRGB(255, 170, 0)
		textLabel.TextScaled = true
		textLabel.TextStrokeTransparency = 0.1
		textLabel.Font = Enum.Font.GothamBold
		textLabel.Text = name
		textLabel.Parent = frame
		local uiTextSizeConstraint = Instance.new("UITextSizeConstraint")
		uiTextSizeConstraint.MaxTextSize = 10
		uiTextSizeConstraint.MinTextSize = 7
		uiTextSizeConstraint.Parent = textLabel
		local frame2 = Instance.new("Frame")
		frame2.Name = "IconFrame"
		frame2.Size = UDim2.new(0, 36, 0, 36)
		frame2.Position = UDim2.new(0.5, -18, 0, 14)
		frame2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		frame2.BackgroundTransparency = 0.3
		frame2.BorderSizePixel = 0
		frame2.Parent = frame
		local uiCorner = Instance.new("UICorner")
		uiCorner.CornerRadius = UDim.new(0, 6)
		uiCorner.Parent = frame2
		local imageLabel = Instance.new("ImageLabel")
		imageLabel.Name = "ImageLabel"
		imageLabel.Size = UDim2.new(1, -2, 1, -2)
		imageLabel.Position = UDim2.new(0, 1, 0, 1)
		imageLabel.BackgroundTransparency = 1
		imageLabel.Image = arg2.Icon or ""
		imageLabel.Parent = frame2
		local textLabel2 = Instance.new("TextLabel")
		textLabel2.Name = "Timer"
		textLabel2.Size = UDim2.new(1, 0, 0, 15)
		textLabel2.Position = UDim2.new(0, 0, 1, -13)
		textLabel2.BackgroundTransparency = 1
		textLabel2.TextColor3 = Color3.new(1, 1, 1)
		textLabel2.TextSize = 13
		textLabel2.TextStrokeTransparency = 0
		textLabel2.TextStrokeColor3 = Color3.new(0, 0, 0)
		textLabel2.Font = Enum.Font.GothamBlack
		textLabel2.TextXAlignment = Enum.TextXAlignment.Center
		textLabel2.TextYAlignment = Enum.TextYAlignment.Center
		textLabel2.Text = ""
		textLabel2.Parent = frame
		arg.Frames[name] = frame
		arg.TimersUI[name] = textLabel2
		arg.IconLabels[name] = imageLabel
		return frame
	end

	local function fn29(arg, arg2)
		if not arg2.Animation or not arg2.Animation.AnimationId then
			return
		end
		local v3 = string.match(tostring(arg2.Animation.AnimationId), "%d+")
		if not v3 then
			return
		end

		for k, ability in pairs(arg.Abilities) do
			if ability.AnimIds and #ability.AnimIds > 0 and fn26(ability, v3) then
				if not arg.Timers[k] or arg.Timers[k] <= 0 then
					arg.Timers[k] = ability.Cooldown

					if ability.CycleIcons then
						fn27(arg)
					end

					local playerStateRef = arg.PlayerStateRef

					if playerStateRef and playerStateRef.NoobEffects and ability.ActiveCondition and tbl14[k] then
						local v4 = tbl14[k]
						playerStateRef.NoobEffects[k] = tick() + v4
						playerStateRef[ability.ActiveCondition] = true
					end
				end
			end
		end

		if arg.EnragedAnimIds and arg.EnragedAnimIds[v3] then
			local playerStateRef = arg.PlayerStateRef

			if playerStateRef then
				playerStateRef.IsEnraged = true
				playerStateRef.EnrageStartTime = tick()
			end
		end

		if arg.Sk8StartAnimId and v3 == arg.Sk8StartAnimId then
			local playerStateRef = arg.PlayerStateRef

			if playerStateRef then
				playerStateRef.IsSkating = true
			end
		end
	end

	local function fn30(arg, arg2, arg3, hum)
		local v3 = fn20(arg, nil)
		local v4 = fn21(arg, nil)
		local animator = hum and hum:WaitForChild("Animator", 5)
		local str2 = arg.Parent and arg.Parent.Name == "Survivors" and "Survivor" or "Killer"
		local v5 = fn24(hum)
		local isInjured = v5 <= 0.5
		local v6 = fn22(arg, false, false)
		local v7 = fn22(arg, true, false)
		local v8 = fn22(arg, false, true)
		local v9 = string.match(tostring(v6 or ""), "%d+")
		local v10 = string.match(tostring(v7 or ""), "%d+")
		local v11 = string.match(tostring(v8 or ""), "%d+")

		local tbl15 = {
			Name = arg.Name,
			Type = str2,
			Stats = v4,
			CurrentStamina = v4.MaxStamina,
			TimeUntilRecovery = 0,
			IsSprinting = false,
			StaminaPenaltyActive = false,
			MovementState = "IDLE",
			CurrentSpeed = 0,
			DisplaySpeed = 0,
			LastPosition = arg2 and arg2.Position or Vector3.zero,
		}

		tbl15.LastUpdateTime = tick()
		tbl15.LastSpeedUpdateTime = tick()
		tbl15.TotalDistance = 0
		tbl15.SpeedSampleCount = 0
		tbl15.NormalRunAnimationIdStr = v9
		tbl15.InjuredRunAnimationIdStr = v10
		tbl15.GolemRunAnimationIdStr = v11
		tbl15.IsInjured = isInjured
		tbl15.LastHealthCheck = v5
		tbl15.AbilityState = nil
		tbl15.Hum = hum
		tbl15.IsStaminaFrozen = false
		tbl15.IsEnraged = false
		tbl15.EnragedAnimIds = nil
		tbl15.EnrageStartTime = 0
		tbl15.IsSkating = false
		tbl15.Sk8SkatingAnimId = nil
		tbl15.IsCrouching = false
		tbl15.NoobEffects = {}
		tbl15.BloxyColaActive = false
		tbl15.SlateskinPotionActive = false
		tbl15.GhostburgerActive = false
		tbl15.CrouchAttrListener = nil
		tbl15.IsGolem = v3
		tbl15.GolemGraceUntil = v3 and tick() + 3 or 0
		local abilityState = nil

		if arg2 and animator then
			local v12 = fn19(arg)

			if v12 then
				abilityState = {
					Timers = {},
					Abilities = v12,
					Animator = animator,
					Head = arg3,
					BillboardCache = fn28(arg, arg2),
					Frames = {},
					TimersUI = {},
					IconLabels = {},
					Connections = {},
					BroadcastChannelIndex = 1,
					LastCycleTime = 0,
					WasInvisible = false,
					PlayerStateRef = tbl15,
					EnragedAnimIds = nil,
					Sk8StartAnimId = nil,
					Sk8SkatingAnimId = nil,
				}

				for k, v13 in pairs(v12) do
					if v13.AlwaysShow then
						createFrame(abilityState, k, v13)
					end
				end

				table.insert(abilityState.Connections, animator.AnimationPlayed:Connect(function(arg4)
					fn29(abilityState, arg4)
				end))

				for _, v13 in ipairs(animator:GetPlayingAnimationTracks()) do
					fn29(abilityState, v13)
				end

				if arg.Name == "Slasher" then
					local enragedAnimIds = {}
					local v13 = fn16({ "Killers", "Slasher", "Config" })

					if v13 and v13.Animations then
						for _, v14 in ipairs({
							"EnragedStart",
							"EnragedIdle",
							"EnragedWalk",
							"EnragedRun",
							"EnragedSlash",
							"EnragedBehead",
						}) do
							local v15 = v13.Animations[v14]

							if v15 then
								local v16 = string.match(tostring(v15), "%d+")

								if v16 then
									enragedAnimIds[v16] = true
								end
							end
						end
					end

					abilityState.EnragedAnimIds = enragedAnimIds
				end

				if arg.Name == "Veeronica" then
					local v13 = fn16({ "Survivors", "Veeronica", "Config" })

					if v13 and v13.Animations then
						local sk8Skating = v13.Animations.Sk8Skating
						local sk8Start = v13.Animations.Sk8Start

						if sk8Skating then
							tbl15.Sk8SkatingAnimId = string.match(tostring(sk8Skating), "%d+")
							abilityState.Sk8SkatingAnimId = tbl15.Sk8SkatingAnimId
						end

						if sk8Start then
							abilityState.Sk8StartAnimId = string.match(tostring(sk8Start), "%d+")
						end
					end
				end

				if arg.Name == "TwoTime" then
					local function fn31()
						tbl15.IsCrouching = arg:GetAttribute("Crouching") == true
					end

					fn31()
					tbl15.CrouchAttrListener = arg:GetAttributeChangedSignal("Crouching"):Connect(fn31)
				end
			end
		end

		tbl15.AbilityState = abilityState
		tbl8[arg] = tbl15
	end

	local function fn31(arg, arg2, arg3)
		if not arg or not arg.Parent then
			return
		end
		local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return
		end

		if arg3 <= 0 then
			arg3 = 0.016666666666666666
		end

		local attribute = arg:GetAttribute("FootstepOverride")
		local v3 = fn20(arg, arg2)
		local flag2 = attribute == "GolemFootsteps" or v3
		local flag3 = attribute ~= nil and attribute ~= "GolemFootsteps"
		local now = tick()

		if flag2 then
			arg2.GolemGraceUntil = now + 3
		end

		if not arg2.IsGolem then
			if flag2 then
				arg2.IsGolem = true
				arg2.Stats = fn21(arg, arg2)
				arg2.CurrentStamina = arg2.Stats.MaxStamina
				arg2.TimeUntilRecovery = 0
			end
		else
			local flag4 = not flag2

			if flag4 then
				if not flag3 then
					flag3 = now >= (arg2.GolemGraceUntil or 0)
				end
			else
				flag3 = flag4
			end

			if flag3 then
				arg2.IsGolem = false
				arg2.Stats = fn21(arg, arg2)
				arg2.CurrentStamina = arg2.Stats.MaxStamina
				arg2.TimeUntilRecovery = 0
			end
		end

		local isGolem = arg2.IsGolem
		arg2.IsStaminaFrozen = false

		if isGolem and arg2.AbilityState and arg2.AbilityState.Animator then
			for _, v4 in ipairs(arg2.AbilityState.Animator:GetPlayingAnimationTracks()) do
				local name = v4.Animation and v4.Animation.Name or ""
				if name:match("GolemShockwave") or name:match("Blooming") then
					arg2.IsStaminaFrozen = true
					break
				end
			end
		end

		local v4 = fn24(arg2.Hum)

		if math.abs(arg2.LastHealthCheck - v4) >= 0.05 then
			arg2.IsInjured = v4 <= 0.5
			arg2.LastHealthCheck = v4
		end

		local golemRunAnimationIdStr

		if isGolem then
			golemRunAnimationIdStr = arg2.GolemRunAnimationIdStr
		else
			golemRunAnimationIdStr = arg2.IsInjured and arg2.InjuredRunAnimationIdStr or arg2.NormalRunAnimationIdStr
		end

		local position = humanoidRootPart.Position
		local magnitude = (Vector3.new(position.X, 0, position.Z) - Vector3.new(arg2.LastPosition.X, 0, arg2.LastPosition.Z)).Magnitude
		local n5 = magnitude / arg3

		if n2 < n5 then
			n5 = arg2.CurrentSpeed
		end

		arg2.CurrentSpeed = arg2.CurrentSpeed * (1 - n) + n5 * n
		arg2.LastPosition = position
		local now2 = tick()
		arg2.TotalDistance = arg2.TotalDistance + magnitude
		arg2.SpeedSampleCount = arg2.SpeedSampleCount + 1

		if n3 <= now2 - arg2.LastSpeedUpdateTime then
			arg2.DisplaySpeed = math.min(arg2.TotalDistance / (now2 - arg2.LastSpeedUpdateTime), 100)
			arg2.LastSpeedUpdateTime = now2
			arg2.TotalDistance = 0
			arg2.SpeedSampleCount = 0
		end

		local flag4 = arg2.CurrentSpeed > 0.4
		local animator = arg2.AbilityState and arg2.AbilityState.Animator
		local flag5 = false

		if animator then
			flag5 = fn23(arg2.AbilityState.Animator, golemRunAnimationIdStr)
		end

		local animator2 = arg2.Sk8SkatingAnimId and arg2.AbilityState and arg2.AbilityState.Animator
		local isSkating = false

		if animator2 then
			isSkating = fn23(arg2.AbilityState.Animator, arg2.Sk8SkatingAnimId)
		end

		arg2.IsSkating = isSkating
		local n6 = 1
		local n7 = 1

		if isSkating then
			n6 = 0
			n7 = 1.35
		end

		isSkating = isSkating or flag5 and flag4

		if arg2.Type == "Killer" and isSkating and not fn25(position) then
			isSkating = false
		end

		if arg2.IsEnraged and arg2.Name == "Slasher" then
			local enragedAnimIds = arg2.AbilityState and arg2.AbilityState.EnragedAnimIds
			local flag6 = false

			if enragedAnimIds then
				for _, v5 in ipairs(arg2.AbilityState.Animator:GetPlayingAnimationTracks()) do
					if v5.Animation and v5.Animation.AnimationId then
						local v6 = string.match(tostring(v5.Animation.AnimationId), "%d+")
						if v6 and arg2.AbilityState.EnragedAnimIds[v6] then
							flag6 = true
							break
						end
					end
				end
			end

			if not flag6 then
				arg2.IsEnraged = false
			end
		end

		local maxStamina = arg2.Stats.MaxStamina

		if arg2.IsEnraged and arg2.Name == "Slasher" then
			maxStamina = arg2.Stats.MaxStamina + (70 - arg2.Stats.MaxStamina) * math.clamp((tick() - (arg2.EnrageStartTime or tick())) / 6.5, 0, 1)
		end

		if arg2.NoobEffects then
			local now3 = tick()
			arg2.BloxyColaActive = arg2.NoobEffects.BloxyCola and now3 < arg2.NoobEffects.BloxyCola or false
			arg2.SlateskinPotionActive = arg2.NoobEffects.SlateskinPotion and now3 < arg2.NoobEffects.SlateskinPotion or false
			arg2.GhostburgerActive = arg2.NoobEffects.Ghostburger and now3 < arg2.NoobEffects.Ghostburger or false
		end

		if isSkating then
			arg2.IsSprinting = true
			arg2.MovementState = arg2.IsInjured and "INJURED_RUN" or "RUN"

			if not arg2.IsStaminaFrozen then
				arg2.TimeUntilRecovery = math.clamp(arg2.TimeUntilRecovery + arg3 * 0.05, 0.2, 3)
				arg2.CurrentStamina = math.clamp(arg2.CurrentStamina - arg2.Stats.StaminaLoss * n7 * arg3, arg2.Stats.MinStamina, maxStamina)

				if arg2.CurrentStamina <= arg2.Stats.MinStamina then
					arg2.IsSprinting = false
					arg2.StaminaPenaltyActive = true
					arg2.TimeUntilRecovery = arg2.Stats.PenaltyTime
				end
			end
		else
			if arg2.IsSprinting == true then
				arg2.TimeUntilRecovery = math.max(arg2.TimeUntilRecovery, 0.11)
			end

			arg2.IsSprinting = false
			arg2.MovementState = arg2.CurrentSpeed > 2 and "WALK" or "IDLE"

			if not arg2.IsStaminaFrozen then
				arg2.TimeUntilRecovery = math.clamp(arg2.TimeUntilRecovery - arg3, 0, 3)

				if arg2.StaminaPenaltyActive then
					if arg2.TimeUntilRecovery <= 0 then
						arg2.StaminaPenaltyActive = false
					end
				elseif arg2.TimeUntilRecovery <= 0 then
					arg2.CurrentStamina = math.clamp(arg2.CurrentStamina + arg2.Stats.StaminaGain * n6 * arg3, arg2.Stats.MinStamina, maxStamina)
				end
			end
		end

		arg2.CurrentStamina = math.min(arg2.CurrentStamina, maxStamina)
	end

	CreatePlayerTagDrawing = function(arg, arg2, arg3, arg4)
		if tbl7[arg] then
			RemovePlayerTagDrawing(arg)
		end

		local name = localPlayer.Name
		if arg:GetAttribute("Username") == name then
			return
		end

		local function fn32(size, color)
			local v3 = forsakenFK.textTag()
			v3.Visible = false
			v3.Center = true
			v3.Outline = true
			v3.Font = 2
			v3.Size = size
			v3.Color = color
			v3.Text = ""
			return v3
		end

		local espTextSize = tbl.EspTextSize or 14
		local n5 = math.max(8, espTextSize - 1)
		local playerFromCharacter = Players:GetPlayerFromCharacter(arg)
		local frame = nil

		if forsakenDeviceESP then
			frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 24, 0, 24)
			frame.BackgroundTransparency = 1
			frame.Visible = false
			frame.Parent = forsakenDeviceESP
			local imageLabel = Instance.new("ImageLabel")
			imageLabel.Size = UDim2.new(1, 0, 1, 0)
			imageLabel.BackgroundTransparency = 1
			imageLabel.Image = tbl11[playerFromCharacter and playerFromCharacter:GetAttribute("Device") or "Unknown"] or tbl11.Unknown
			imageLabel.Parent = frame
		end

		tbl7[arg] = {
			MainText = fn32(espTextSize, arg2),
			SubText = fn32(n5, Color3.new(1, 1, 1)),
			DeviceGuiFrame = frame,
			HRP = arg3,
			Hum = arg4,
			RealNamePlr = playerFromCharacter,
			RealName = playerFromCharacter and playerFromCharacter.Name or arg.Name,
			CharName = arg.Name,
			_lastMainText = "",
			_lastSubText = "",
			_lastMainPos = Vector2.zero,
			_lastSubPos = Vector2.zero,
			_lastSubColor = Color3.new(1, 1, 1),
		}
	end

	RemovePlayerTagDrawing = function(arg)
		if tbl7[arg] then
			local v3 = tbl7[arg]
			v3.MainText:Remove()
			v3.SubText:Remove()

			if v3.DeviceGuiFrame then
				v3.DeviceGuiFrame:Destroy()
			end

			tbl7[arg] = nil
		end

		local v3 = tbl8[arg]

		if v3 then
			if v3.CrouchAttrListener then
				v3.CrouchAttrListener:Disconnect()
			end

			if v3.AbilityState then
				local abilityState = v3.AbilityState

				if abilityState.Connections then
					for _, connection3 in ipairs(abilityState.Connections) do
						connection3:Disconnect()
					end
				end

				if abilityState.BillboardCache and abilityState.BillboardCache.Gui then
					abilityState.BillboardCache.Gui:Destroy()
				end
			end
		end

		tbl8[arg] = nil
	end

	local function fn32()
		local tagsOptions = tbl.TagsOptions or {}

		if tbl.PlayersTagsEsp and (tagsOptions.Stamina or tagsOptions.Velocity or tagsOptions.Abilities) then
			if not connection then
				connection = RunService.Heartbeat:Connect(function(...) end)
			end
		elseif connection then
			connection:Disconnect()
			connection = nil
		end
	end

	local function fn33(...) end

	StopESPSystem = function()
		flag = false

		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end

		fn32()

		for _, v3 in ipairs(tbl9) do
			v3:Disconnect()
		end

		tbl9 = {}

		for k in pairs(tbl7) do
			RemovePlayerTagDrawing(k)
		end

		tbl8 = {}

		if forsakenDeviceESP then
			forsakenDeviceESP:Destroy()
			forsakenDeviceESP = nil
		end

		if forsakenAbilityESP then
			forsakenAbilityESP:Destroy()
			forsakenAbilityESP = nil
		end
	end

	StartESPSystem = function()
		if flag then
			return
		end
		flag = true

		if not forsakenDeviceESP then
			forsakenDeviceESP = CoreGui:FindFirstChild("ForsakenDeviceESP") or Instance.new("ScreenGui")
			forsakenDeviceESP.Name = "ForsakenDeviceESP"
			forsakenDeviceESP.DisplayOrder = 10
			forsakenDeviceESP.Parent = fn17()
		end

		if not forsakenAbilityESP then
			forsakenAbilityESP = CoreGui:FindFirstChild("ForsakenAbilityESP") or Instance.new("Folder")
			forsakenAbilityESP.Name = "ForsakenAbilityESP"
			forsakenAbilityESP.Parent = fn17()
		end

		local function fn34(child)
			task.spawn(function()
				if child:IsA("Model") then
					local humanoidRootPart = child:WaitForChild("HumanoidRootPart", 10)
					local humanoid = child:WaitForChild("Humanoid", 10)
					local head = child:WaitForChild("Head", 10)

					if humanoidRootPart and humanoid and child.Parent then
						CreatePlayerTagDrawing(child, child.Parent.Name == "Killers" and tbl.EspKillerColor or tbl.EspSurvivorsColor, humanoidRootPart, humanoid)
						fn30(child, humanoidRootPart, head, humanoid)
					end
				end
			end)
		end

		local function fn35(arg)
			if not arg then
				return
			end

			for _, child in ipairs(arg:GetChildren()) do
				fn34(child)
			end

			table.insert(tbl9, arg.ChildAdded:Connect(fn34))
			table.insert(tbl9, arg.ChildRemoved:Connect(RemovePlayerTagDrawing))
		end

		local players2 = workspace:WaitForChild("Players", 5)

		if players2 then
			fn35(players2:WaitForChild("Survivors", 5))
			fn35(players2:WaitForChild("Killers", 5))
		end

		if connection2 then
			connection2:Disconnect()
		end

		connection2 = RunService.RenderStepped:Connect(fn33)
		fn32()
	end

	Visual:AddToggle({
		Name = "Players Tags",
		Callback = function(playersTagsEsp)
			tbl.PlayersTagsEsp = playersTagsEsp

			if playersTagsEsp then
				if not flag then
					StartESPSystem()
				end
			else
				StopESPSystem()
			end

			fn32()
		end,
	})

	Visual:AddDropdown({
		Name = "Tags Settings",
		Options = { "Name", "Role", "Health", "Distance", "Stamina", "Velocity", "Device", "Abilities" },
		Multi = true,
		Default = { Name = true },
		Callback = function(tagsOptions)
			tbl.TagsOptions = tagsOptions
			fn32()
		end,
	})
end

Visual:AddColorPicker({
	Name = "Killer color",
	Default = Color3.new(1, 0, 0),
	Callback = function(espKillerColor)
		tbl.EspKillerColor = espKillerColor
		killerEspColorUpdate()
	end,
})

Visual:AddColorPicker({
	Name = "Killer supports color",
	Description = "PizzaDelivery,1x1x1x1Zombie",
	Default = tbl.EspKillerSupportColor,
	Callback = function(espKillerSupportColor)
		tbl.EspKillerSupportColor = espKillerSupportColor
		killerSupportsEspColorUpdate()
	end,
})

Visual:AddColorPicker({
	Name = "survivors color",
	Default = Color3.new(0, 1, 0),
	Callback = function(espSurvivorsColor)
		tbl.EspSurvivorsColor = espSurvivorsColor
		survivorsEspColorUpdate()
	end,
})

do
	local tbl8 = {}
	local connection = nil
	local folder = nil
	local tbl9 = {}
	local n = 0
	local n2 = 0.15
	local color = Color3.fromRGB(255, 185, 45)
	local vector = Vector3.new(0, 0, -2)

	local tbl10 = {
		c00lkidd = {},
		["1x1x1x1"] = {
			MassInfection = {
				Windup = 1.7,
				SpeedKey = "MassInfectionShockwaveSpeed",
				Speed = 104,
				LifetimeKey = "MassInfectionShockwaveLifetime",
				Lifetime = 6,
				Animation = "99050723653468",
				TemplateKey = "ShockwaveTemplate",
			},
			Entanglement = {
				Windup = 0.75,
				SpeedKey = "EntanglementSpeed",
				Speed = 125,
				LifetimeKey = "EntanglementLifetime",
				Lifetime = 1,
				Animation = "133272604443790",
				TemplateKey = "SwordsTemplate",
			},
		},
	}

	local fn17 = nil

	fn17 = function(arg, arg2)
		local tbl11 = arg2 or {}

		if typeof(arg) == "Instance" and arg:IsA("Animation") then
			arg = arg.AnimationId
		end

		if type(arg) == "string" or type(arg) == "number" then
			local match = tostring(arg):match("%d+")

			if match then
				tbl11[match] = true
			end
		elseif type(arg) == "table" then
			fn17(arg.AnimationId or arg.Id or arg.ID, tbl11)

			for _, v3 in ipairs(arg) do
				fn17(v3, tbl11)
			end
		end

		return tbl11
	end

	local function fn18(arg)
		if typeof(arg) ~= "Instance" then
			return nil
		end

		if not arg:IsA("BasePart") and not arg:IsA("Model") then
			return nil
		end
		local pivot = arg:GetPivot()
		local descendants = arg:IsA("BasePart") and { arg } or arg:GetDescendants()
		local vector2 = Vector3.new(math.huge, math.huge, math.huge)
		local vector3 = Vector3.new(-math.huge, -math.huge, -math.huge)
		local flag = false

		for _, descendant in ipairs(descendants) do
			if descendant:IsA("BasePart") then
				local v3 = pivot:ToObjectSpace(descendant.CFrame)
				local n3 = descendant.Size * 0.5

				for i = -1, 1, 2 do
					for i2 = -1, 1, 2 do
						for i3 = -1, 1, 2 do
							local v4 = v3:PointToWorldSpace(Vector3.new(n3.X * i, n3.Y * i2, n3.Z * i3))
							local min = math.min
							local z = vector2.Z
							local z2 = v4.Z
							vector2 = Vector3.new(math.min(vector2.X, v4.X), math.min(vector2.Y, v4.Y), min(z, z2))
							local max = math.max
							local z3 = vector3.Z
							local z4 = v4.Z
							vector3 = Vector3.new(math.max(vector3.X, v4.X), math.max(vector3.Y, v4.Y), max(z3, z4))
							flag = true
						end
					end
				end
			end
		end

		if flag then
			return vector3 - vector2, (vector3 + vector2) * 0.5
		end
		return nil
	end

	local function fn19(arg)
		if arg.Part then
			arg.Part:Destroy()
		end

		arg.Part = nil
		arg.Box = nil
	end

	local function fn20(...) end

	local function fn21(arg)
		for _, visual in ipairs(arg.Visuals) do
			fn19(visual)
		end

		table.clear(arg.Visuals)
		arg.Line = nil
		arg.Ring = nil
		arg.Trail = nil
		arg.LastPosition = nil
		arg.LastTrail = nil
		arg.Started = nil
		arg.Velocity = nil
		arg.Phase = nil
	end

	local function fn22(arg, arg2, arg3)
		local tbl11 = { Width = arg3, Height = arg3, Color = arg2 }
		table.insert(arg.Visuals, tbl11)
		return tbl11
	end

	local function fn23(arg, arg2)
		if not arg.Ring then
			arg.Ring = {}

			for i = 1, 40 do
				arg.Ring[i] = fn22(arg, Color3.fromRGB(255, 155, 45), 0.22)
			end
		end

		for i = 1, 40 do
			local n3 = (i - 1) * 3.1415926535897931 * 2 / 40
			local n4 = i * 3.1415926535897931 * 2 / 40
			local v3 = fn20
			local v4 = arg.Ring[i]
			local sin = math.sin
			local radius = arg.Radius
			local n5 = arg2 + Vector3.new(math.cos(n3), 0, sin(n3)) * radius
			local sin2 = math.sin
			local radius2 = arg.Radius
			v3(v4, n5, arg2 + Vector3.new(math.cos(n4), 0, sin2(n4)) * radius2)
		end
	end

	local function fn24(...) end

	local function fn25(arg)
		for _, visual in ipairs(arg.Visuals) do
			fn19(visual)
		end

		table.clear(arg.Visuals)
		arg.ChargeStart = nil
		arg.DashStart = nil
		arg.Accum = 0
	end

	local function fn26(arg, arg2, width, height)
		local tbl11 = arg.Visuals[arg2]

		if not tbl11 then
			tbl11 = { Color = color }
			arg.Visuals[arg2] = tbl11
		end

		tbl11.Width = width
		tbl11.Height = height
		return tbl11
	end

	local function fn27(...) end

	local function fn28(arg, arg2, arg3)
		local str2 = (arg == "JohnDoe" or arg == "JoshDoe") and "JohnDoe" or arg
		if str2 ~= "Chance" and str2 ~= "Sixer" and str2 ~= "JohnDoe" and str2 ~= "c00lkidd" then
			return nil
		end

		local function fn29(arg4, arg5)
			local v3 = arg3 and arg3[arg4]

			if v3 == nil then
				v3 = arg2[arg4]
			end

			if v3 == nil then
				return arg5
			end
			return v3
		end

		local function fn30(arg4, arg5)
			local v3 = fn17(arg3 and arg3.Animations and arg3.Animations[arg4])

			if not next(v3) then
				v3 = fn17(arg2.Animations and arg2.Animations[arg4])
			end

			if not next(v3) and arg5 then
				v3[arg5] = true
			end

			return v3
		end

		local tbl11 = { Kind = str2, Visuals = {}, Accum = 0 }

		if str2 == "Chance" then
			tbl11.Ids = fn30("AimGun", "133491532453922")
			tbl11.StopIds = {}

			for _, v3 in ipairs({ "GunFire", "GunFail", "GunExplode" }) do
				local v4 = pairs
				local v5 = fn30(v3)

				for k in v4(v5) do
					tbl11.StopIds[k] = true
				end
			end

			tbl11.Width = fn29("ShootHitboxSize", 2.5)
			tbl11.Range = fn29("ShootHitboxRange", 90)
		elseif str2 == "Sixer" then
			tbl11.StartIds = fn30("DemonicPursuitStart", "133363345661032")
			tbl11.Ids = table.clone(tbl11.StartIds)
			local v3 = pairs
			local DemonicPursuitLoop = fn30("DemonicPursuitLoop", "128414736976503")

			for k in v3(DemonicPursuitLoop) do
				tbl11.Ids[k] = true
			end

			tbl11.StopIds = fn30("DemonicPursuitLunge", "139309647473555")
			tbl11.Hold = fn29("PursuitHold", NumberRange.new(0.6, 1.25))
			tbl11.BaseSpeed = fn29("PursuitBaseSpeed", 7)
			tbl11.MaxSpeed = fn29("PursuitMaxSpeed", 17)
			tbl11.Speed = fn29("Speed", 9)
			tbl11.Length = fn29("PursuitLength", 0.8)
		elseif str2 == "c00lkidd" then
			tbl11.Ids = fn30("WalkspeedOverrideStart", "98456918873918")
			tbl11.LoopIds = fn30("WalkspeedOverrideLoop", "106776364623742")

			for k in pairs(tbl11.LoopIds) do
				tbl11.Ids[k] = true
			end

			tbl11.StopIds = {}

			for _, v3 in ipairs({
				"WalkspeedOverrideHit",
				"WalkspeedOverrideMiss",
				"WalkspeedOverrideDuration",
				"WalkspeedOverrideCollide",
			}) do
				local v4 = pairs
				local v5 = fn30(v3)

				for k in v4(v5) do
					tbl11.StopIds[k] = true
				end
			end

			tbl11.Speed = fn29("WalkspeedOverrideSpeed", 90)
			tbl11.Duration = fn29("WalkspeedOverrideDuration", 1.34)
			tbl11.Windup = fn29("WalkspeedOverrideWindup", 0.5)
			tbl11.Raycast = RaycastParams.new()
			tbl11.Raycast.FilterType = Enum.RaycastFilterType.Exclude
			local filterDescendantsInstances = { folder }
			local players2 = workspace:FindFirstChild("Players")

			if players2 then
				table.insert(filterDescendantsInstances, players2)
			end

			tbl11.Raycast.FilterDescendantsInstances = filterDescendantsInstances
			tbl11.Raycast.RespectCanCollide = true
		else
			tbl11.Ids = fn30("CorruptEnergy", "127172483138092")
			tbl11.Size = fn29("SpikeHitboxSize", Vector3.new(11, 5, 5))
			tbl11.Spacing = fn29("DistanceBetweenSpikes", 4)
			local clamp = math.clamp
			local floor = math.floor
			local SpikeAmount = fn29("SpikeAmount", 31)
			tbl11.Count = clamp(floor(SpikeAmount), 0, 64)
			tbl11.Raycast = RaycastParams.new()
			tbl11.Raycast.FilterType = Enum.RaycastFilterType.Exclude
			local filterDescendantsInstances = { folder }
			local players2 = workspace:FindFirstChild("Players")

			if players2 then
				table.insert(filterDescendantsInstances, players2)
			end

			tbl11.Raycast.FilterDescendantsInstances = filterDescendantsInstances
			tbl11.Raycast.RespectCanCollide = true
		end

		return tbl11
	end

	local function fn29(arg)
		local v3 = tbl9[arg]
		if not v3 then
			return
		end

		for _, ability in pairs(v3.Abilities) do
			fn19(ability)
		end

		if v3.Cat then
			fn21(v3.Cat)
		end

		if v3.Extra then
			fn25(v3.Extra)
		end

		tbl9[arg] = nil
	end

	local function fn30(arg, arg2, arg3)
		local tbl11 = tbl10[arg2]

		if not tbl11 then
			tbl11 = (arg2 == "Nosferatu" or arg2 == "Chance" or arg2 == "Sixer" or arg2 == "JohnDoe" or arg2 == "JoshDoe") and {}
		end

		if not tbl11 then
			return
		end
		local str2 = arg2 == "Chance" and "Survivors" or "Killers"
		local v3 = fn16({ str2, arg2, "Config" })
		if not v3 then
			return
		end
		local flag = arg3 ~= "" and fn16({ "Skins", str2, arg2, arg3, "Config" }) or nil
		if arg3 ~= "" and not flag then
			return
		end
		local tbl12 = { Name = arg2, Skin = arg3, Abilities = {} }

		if arg2 == "Nosferatu" then
			local function fn31(arg4, arg5)
				local v4 = fn17(flag and flag.Animations and flag.Animations[arg4])

				if not next(v4) then
					v4 = fn17(v3.Animations and v3.Animations[arg4])
				end

				if not next(v4) then
					v4[arg5] = true
				end

				return v4
			end

			local function fn32(arg4, arg5)
				local spire = flag and flag.Spire and flag.Spire[arg4]

				if spire == nil then
					spire = v3.Spire and v3.Spire[arg4]
				end

				return type(spire) == "number" and math.max(0, spire) or arg5
			end

			tbl12.Cat = {
				CacheKey = arg2 .. ":" .. arg3,
				StartIds = fn31("SpireStart", "72186169160926"),
				LoopIds = fn31("SpireLoop", "103995840833619"),
				EndIds = fn31("SpireEnd", "88612618621871"),
				Windup = fn32("Windup", 0.75),
				Duration = fn32("Duration", 1.25),
				Radius = fn32("ExplosionRadius", 17.5),
				Visuals = {},
			}
		end

		tbl12.Extra = fn28(arg2, v3, flag)

		for k, v4 in pairs(tbl11) do
			local animations = flag and flag.Animations
			local animations2 = v3.Animations
			local animKey = v4.AnimKey or k
			local v5 = fn17(animations and animations[animKey])

			if not next(v5) then
				v5 = fn17(animations2 and animations2[animKey])
			end

			if not next(v5) then
				v5[v4.Animation] = true
			end

			local instances = flag and flag.Instances
			local instances2 = v3.Instances
			local v6, v7 = fn18(instances and instances[v4.TemplateKey] or instances2 and instances2[v4.TemplateKey])
			local speedKey = v4.SpeedKey and (flag and flag[v4.SpeedKey] or v3[v4.SpeedKey]) or v4.Speed
			local lifetimeKey = v4.LifetimeKey and (flag and flag[v4.LifetimeKey] or v3[v4.LifetimeKey]) or v4.Lifetime
			local windupKey = v4.WindupKey and (flag and flag[v4.WindupKey] or v3[v4.WindupKey]) or v4.Windup
			local displayDistance = v4.DisplayDistance

			if not displayDistance and type(speedKey) == "number" and type(lifetimeKey) == "number" then
				displayDistance = speedKey * lifetimeKey
			end

			if type(displayDistance) == "number" then
				tbl12.Abilities[k] = {
					Ids = v5,
					Width = v6 and math.max(0.05, v6.X) or 0.8,
					Height = v6 and math.max(0.05, v6.Y) or 0.8,
					Center = v7 or Vector3.zero,
					Windup = windupKey,
					Distance = math.clamp(displayDistance, 0, 650),
				}
			end
		end

		tbl9[arg] = tbl12
	end

	local function fn31()
		local players2 = workspace:FindFirstChild("Players")
		local killers2 = players2 and players2:FindFirstChild("Killers")
		players2 = players2 and players2:FindFirstChild("Survivors")

		for k, v3 in pairs(tbl9) do
			local attribute = k:GetAttribute("CharacterName") or k.Name
			local attribute2 = k:GetAttribute("SkinName") or ""

			if not k.Parent or k.Parent ~= killers2 and k.Parent ~= players2 or attribute ~= v3.Name or attribute2 ~= v3.Skin then
				fn29(k)
			end
		end

		local function fn32(arg)
			if not arg then
				return
			end

			for _, child in ipairs(arg:GetChildren()) do
				if child:IsA("Model") and not tbl9[child] then
					fn30(child, child:GetAttribute("CharacterName") or child.Name, child:GetAttribute("SkinName") or "")
				end
			end
		end

		fn32(killers2)
		fn32(players2)
	end

	tbl8.SetEnabled = function(arg)
		if connection then
			connection:Disconnect()
			connection = nil
		end

		for k in pairs(tbl9) do
			fn29(k)
		end

		if folder then
			folder:Destroy()
			folder = nil
		end

		if not arg then
			return
		end
		folder = Instance.new("Folder")
		folder.Name = "ProjectileWindupPreview"
		folder.Parent = workspace
		n = n2
		connection = RunService.Heartbeat:Connect(function(...) end)
	end

	Visual:AddSection("Projectiles")
	local connection2 = nil
	local tbl11 = {}
	local color2 = Color3.fromRGB(255, 0, 0)
	local n3 = 3
	local n4 = 0.8
	local n5 = 3

	local function fn32()
		for _, v3 in pairs(tbl11) do
			if type(v3) == "table" and v3.Part then
				v3.Part:Destroy()
			end
		end

		table.clear(tbl11)
	end

	Visual:AddToggle({
		Name = "Projectile ESP",
		Callback = function(arg)
			tbl8.SetEnabled(arg)

			if arg then
				local ok, result = pcall(function()
					return require(ReplicatedStorage.Systems.Player.Game.ProjectileReplication)
				end)

				local ok2, result2 = pcall(function()
					return require(ReplicatedStorage.Modules.Gameplay.PredictProjectile)
				end)

				if not (ok and ok2 and result and result2) then
					return
				end

				if connection2 then
					connection2:Disconnect()
				end

				if type(fn32) == "function" then
					fn32()
				end

				local max = math.max
				local vector2 = Vector3.new
				local cframe = CFrame.new
				local cframe2 = CFrame.lookAt

				local function fn33(arg2)
					local model = arg2.Model

					if model then
						if model:IsA("Model") then
							local extentsSize = model:GetExtentsSize()
							return max(extentsSize.X, extentsSize.Y)
						end

						if model:IsA("BasePart") then
							return max(model.Size.X, model.Size.Y)
						end
					end

					local n6 = 0.8

					if not n4 then
						n6 = 1
					end

					return n6
				end

				local function fn34(arg2)
					local position = arg2.InitialCFrame.Position
					local initialVelocity = arg2.InitialVelocity
					local gravity = arg2.Gravity or 0
					local v3 = fn33(arg2)
					local n6 = result2:FindLeadShot(position, initialVelocity, initialVelocity.Magnitude, position, Vector3.zero, gravity)

					if not n6 or n6 == position then
						local n7 = 3

						if not n3 then
							n7 = 1
						end

						n6 = position + initialVelocity * n7 + vector2(0, gravity * 0.5 * n7 * n7, 0)
					end

					local magnitude = (n6 - position).Magnitude
					local part = Instance.new("Part")
					part.Name = "ESP_Line_" .. tostring(arg2.UUID or "Unknown")
					part.Anchored = true
					part.CanCollide = false
					part.CanQuery = false
					part.CanTouch = false
					part.CastShadow = false
					part.Size = vector2(v3, v3, magnitude)
					part.CFrame = cframe2(position, n6) * cframe(0, 0, -magnitude * 0.5)
					part.Material = Enum.Material.Plastic
					part.Color = color2 or Color3.new(1, 0, 0)
					part.Transparency = 0.5
					part.Parent = workspace
					local boxHandleAdornment = Instance.new("BoxHandleAdornment")
					boxHandleAdornment.Size = part.Size
					boxHandleAdornment.AlwaysOnTop = true
					boxHandleAdornment.ZIndex = 10
					boxHandleAdornment.Color3 = color2 or Color3.new(1, 0, 0)
					boxHandleAdornment.Transparency = 0.4
					boxHandleAdornment.Adornee = part
					boxHandleAdornment.CFrame = cframe()
					boxHandleAdornment.Parent = part
					return part, boxHandleAdornment, n6, v3
				end

				connection2 = RunService.Heartbeat:Connect(function(...) end)
			else
				if connection2 then
					connection2:Disconnect()
					connection2 = nil
				end

				if type(fn32) == "function" then
					fn32()
				end
			end
		end,
	})
end

do
	local connection = nil
	local connection2 = nil
	local tbl8 = {}

	getGeneratorColor = function(arg)
		if arg.Name == "FakeGenerator" then
			return tbl.FakeGeneratorColor
		end

		if arg:FindFirstChild("Progress") and arg.Progress.Value == 100 then
			return tbl.DoneGeneratorColor
		end
		return tbl.GeneratorColor
	end

	GeneratorsEsp = function()
		if connection then
			connection:Disconnect()
			connection = nil
		end

		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end

		for _, v3 in ipairs(tbl8) do
			v3:Disconnect()
		end

		table.clear(tbl8)

		if not tbl.GeneratorEsp then
			for _, descendant in pairs(workspace:GetDescendants()) do
				if (descendant.Name == "Generator" or descendant.Name == "FakeGenerator") and descendant:FindFirstChild("Highlight") then
					descendant.Highlight:Destroy()
				end
			end

			return
		end

		local function fn17(arg)
			if arg.Name ~= "Generator" and arg.Name ~= "FakeGenerator" then
				return
			end
			createHighlight(arg, getGeneratorColor(arg))
			local progress = arg:FindFirstChild("Progress")

			if progress then
				local connection3 = progress:GetPropertyChangedSignal("Value"):Connect(function()
					if tbl.GeneratorEsp and arg:FindFirstChild("Highlight") then
						local v3 = getGeneratorColor(arg)
						arg.Highlight.FillColor = v3
						arg.Highlight.OutlineColor = v3
					end
				end)

				table.insert(tbl8, connection3)
			end
		end

		local function fn18(arg)
			for _, child in pairs(arg:GetChildren()) do
				fn17(child)
			end

			connection = arg.ChildAdded:Connect(function(child)
				task.wait(0.5)

				if tbl.GeneratorEsp and child:IsDescendantOf(workspace) then
					fn17(child)
				end
			end)
		end

		local map = ingame:FindFirstChild("Map")

		if map then
			fn18(map)
		end

		connection2 = ingame.ChildAdded:Connect(function(child)
			if child.Name == "Map" then
				task.wait(1)

				if tbl.GeneratorEsp then
					fn18(child)
				end
			end
		end)
	end
end

UpdateGeneratorColors = function()
	if not tbl.GeneratorEsp then
		return
	end
	local map = ingame and ingame:FindFirstChild("Map")
	if not map then
		return
	end

	for _, child in pairs(map:GetChildren()) do
		if (child.Name == "Generator" or child.Name == "FakeGenerator") and child:FindFirstChild("Highlight") then
			local v3 = getGeneratorColor(child)
			child.Highlight.FillColor = v3
			child.Highlight.OutlineColor = v3
		end
	end
end

Visual:AddSection("Generators")

Visual:AddToggle({
	Name = "Generators esp",
	Callback = function(generatorEsp)
		tbl.GeneratorEsp = generatorEsp
		GeneratorsEsp()
	end,
})

local tbl8
tbl8 = {}

do
	local tbl9 = {}
	local connection = nil
	local connection2 = nil
	local connection3 = nil
	local connection4 = nil
	local format = string.format
	local vector2 = Vector2.new
	local vector = Vector3.new

	CreateGeneratorDrawing = function(arg)
		if tbl8[arg] then
			tbl8[arg]:Remove()
			tbl8[arg] = nil
		end

		local v3 = forsakenFK.textTag()
		v3.Visible = false
		v3.Center = true
		v3.Outline = true
		v3.Font = 2
		v3.Size = tbl.EspTextSize or 14
		v3.Text = arg.Name == "FakeGenerator" and "Fake Generator" or "Generator"
		v3.Color = getGeneratorColor(arg)
		tbl8[arg] = v3
	end

	RemoveGeneratorDrawing = function(arg)
		if tbl8[arg] then
			tbl8[arg]:Remove()
			tbl8[arg] = nil
		end

		if tbl9[arg] then
			tbl9[arg] = nil
		end
	end

	local function fn17()local f=workspace.CurrentCamera;if not f then return;end;for C,m in pairs( tbl8 )do if C and C.Parent then local H= tbl9 [C];if not H then local d=C:FindFirstChildOfClass("Part");if d then H={MainPart=d,ProgressObj=C:FindFirstChild("Progress"),IsFake=C.Name=="FakeGenerator",Offset= vector (0,d.Size.Y/2+1,0),LastProgress=-1,LastColor=nil}; tbl9 [C]=H;else if m.Visible then m.Visible=false;end;continue;end;end;local d,E=f:WorldToViewportPoint(H.MainPart.Position+H.Offset);if E then m.Position= vector2 (d.X,d.Y);if H.IsFake then if H.LastProgress~=-2 then m.Text="Fake Generator";H.LastProgress=-2;end;else local f=H.ProgressObj;local d=f and f.Value or 0;if d~=H.LastProgress then H.LastProgress=d;m.Text=d==100 and"Generator (Done)"or( format ("Generator (%d%%)",d));end;end;local Q=getGeneratorColor(C);if H.LastColor~=Q then H.LastColor=Q;m.Color=Q;end;if not m.Visible then m.Visible=true;end;elseif m.Visible then m.Visible=false;end;else RemoveGeneratorDrawing(C);end;end;end

	CleanupGeneratorESP = function()
		if connection then
			connection:Disconnect()
			connection = nil
		end

		if connection2 and not tbl.GeneratorEsp2 then
			connection2:Disconnect()
			connection2 = nil
		end

		if connection3 then
			connection3:Disconnect()
			connection3 = nil
		end

		if connection4 then
			connection4:Disconnect()
			connection4 = nil
		end

		for _, v3 in pairs(tbl8) do
			v3:Remove()
		end

		table.clear(tbl8)
		table.clear(tbl9)
	end

	SetupGeneratorESP = function(arg)
		for _, child in pairs(arg:GetChildren()) do
			if child.Name == "Generator" or child.Name == "FakeGenerator" then
				CreateGeneratorDrawing(child)
			end
		end

		connection3 = arg.ChildAdded:Connect(function(child)
			if child.Name == "Generator" or child.Name == "FakeGenerator" then
				task.wait(0.5)
				CreateGeneratorDrawing(child)
			end
		end)

		connection4 = arg.ChildRemoved:Connect(function(child)
			if child.Name == "Generator" or child.Name == "FakeGenerator" then
				RemoveGeneratorDrawing(child)
			end
		end)
	end

	CheckAndSetupGeneratorESP = function()
		local map = ingame:FindFirstChild("Map")
		if map then
			SetupGeneratorESP(map)
			return true
		end
		return false
	end

	InitializeGeneratorESP = function()
		CleanupGeneratorESP()
		if not tbl.GeneratorEsp2 then
			return
		end

		if CheckAndSetupGeneratorESP() then
			connection = RunService.RenderStepped:Connect(fn17)
		end

		connection2 = ingame.ChildAdded:Connect(function(child)
			if child.Name == "Map" then
				if connection then
					connection:Disconnect()
					connection = nil
				end

				task.wait(1)
				CleanupGeneratorESP()
				SetupGeneratorESP(child)
				connection = RunService.RenderStepped:Connect(fn17)
			end
		end)
	end

	GeneratorsEsp2 = function()
		InitializeGeneratorESP()
	end

	UpdateGeneratorColors2 = function()
		for _, v3 in pairs(tbl9) do
			v3.LastColor = nil
		end
	end
end

Visual:AddToggle({
	Name = "Generators Tags",
	Callback = function(generatorEsp2)
		tbl.GeneratorEsp2 = generatorEsp2
		GeneratorsEsp2()
	end,
})

Visual:AddColorPicker({
	Name = "Generators color",
	Default = tbl.GeneratorColor,
	Callback = function(generatorColor)
		tbl.GeneratorColor = generatorColor
		UpdateGeneratorColors()
	end,
})

Visual:AddColorPicker({
	Name = "Done Generators color",
	Default = tbl.DoneGeneratorColor,
	Callback = function(doneGeneratorColor)
		tbl.DoneGeneratorColor = doneGeneratorColor
		UpdateGeneratorColors()
	end,
})

Visual:AddColorPicker({
	Name = "Fake Generators color",
	Default = tbl.FakeGeneratorColor,
	Callback = function(fakeGeneratorColor)
		tbl.FakeGeneratorColor = fakeGeneratorColor
		UpdateGeneratorColors()
	end,
})

local tbl9

do
	local tbl10 = { BloxyCola = {}, Medkit = {} }
	local tbl11 = { BloxyCola = true, Medkit = true }

	local function fn17(arg)
		return typeof(arg) == "Instance" and arg:IsA("Tool") and tbl10[arg.Name] ~= nil
	end

	local function fn18(arg)
		return tbl11[arg] == true
	end

	local function fn19()
		return tbl.ItemsColor or Color3.new(0.35, 0, 1)
	end

	local function fn20(arg)
		if not fn17(arg) then
			return
		end

		if not (tbl.ItemsEsp and fn18(arg.Name)) then
			return
		end
		local v3 = fn19()
		local highlight = arg:FindFirstChild("Highlight")

		if highlight then
			highlight.FillColor = v3
			highlight.OutlineColor = v3
		else
			createHighlight(arg, v3, { FillTransparency = 0.5, OutlineTransparency = 0.2 })
		end
	end

	local function fn21()
		for _, descendant in ipairs(ingame:GetDescendants()) do
			if fn17(descendant) then
				if tbl.ItemsEsp and fn18(descendant.Name) then
					fn20(descendant)
				else
					local highlight = descendant:FindFirstChild("Highlight")

					if highlight then
						highlight:Destroy()
					end
				end
			end
		end
	end

	local connection = nil

	local function fn22()
		local flag = false

		if tbl.ItemsEsp then
			for k in pairs(tbl10) do
				if fn18(k) then
					flag = true
					break
				end
			end
		end

		if flag and not connection then
			connection = ingame.DescendantAdded:Connect(function(descendant)
				if descendant:IsA("Tool") then
					task.wait(0.1)
					fn20(descendant)
				end
			end)
		elseif not flag and connection then
			connection:Disconnect()
			connection = nil
		end

		fn21()
	end

	Visual:AddSection("Items")
	tbl9 = {}
	local connection2 = nil
	local connection3 = nil
	local connection4 = nil

	local function fn23(descendant)
		local v3 = tbl9[descendant]

		if v3 then
			v3.Text:Remove()
			tbl9[descendant] = nil
		end
	end

	local function fn24(arg)
		fn23(arg)
		local v3 = forsakenFK.textTag()
		v3.Visible = true
		v3.Center = true
		v3.Outline = true
		v3.Font = 2
		v3.Size = tbl.EspTextSize or 14
		v3.Color = fn19()
		v3.Text = arg.Name
		tbl9[arg] = { Text = v3, Part = arg:FindFirstChild("ItemRoot") or arg:FindFirstChild("Handle") or arg }
	end

	local function fn25(...) end

	local function fn26()
		local v3 = fn19()

		for _, v4 in pairs(tbl9) do
			v4.Text.Color = v3
		end
	end

	local function fn27()
		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end

		if connection3 then
			connection3:Disconnect()
			connection3 = nil
		end

		if connection4 then
			connection4:Disconnect()
			connection4 = nil
		end

		for _, v3 in pairs(tbl9) do
			v3.Text:Remove()
		end

		table.clear(tbl9)
	end

	local function fn28(arg)
		for _, descendant in ipairs(arg:GetDescendants()) do
			if fn17(descendant) and fn18(descendant.Name) then
				fn24(descendant)
			end
		end

		connection2 = arg.DescendantAdded:Connect(function(descendant)
			task.wait(0.3)

			if descendant.Parent and fn17(descendant) and fn18(descendant.Name) then
				fn24(descendant)
			end
		end)

		connection3 = arg.DescendantRemoving:Connect(fn23)
		connection4 = RunService.RenderStepped:Connect(fn25)
	end

	local function fn29()
		if not tbl.ItemsTagsEsp then
			return
		end

		for k in pairs(tbl9) do
			if not fn18(k.Name) then
				fn23(k)
			end
		end

		for _, descendant in ipairs(ingame:GetDescendants()) do
			if fn17(descendant) and fn18(descendant.Name) and not tbl9[descendant] then
				fn24(descendant)
			end
		end
	end

	local tbl12 = {}

	for k in pairs(tbl10) do
		table.insert(tbl12, k)
	end

	table.sort(tbl12)

	Visual:AddToggle({
		Name = "Items ESP",
		Callback = function(itemsEsp)
			tbl.ItemsEsp = itemsEsp
			fn22()
		end,
	})

	Visual:AddDropdown({
		Name = "Items",
		Options = tbl12,
		Default = tbl12,
		Multi = true,
		Callback = function(arg)
			for k in pairs(tbl10) do
				tbl11[k] = arg[k] == true
			end

			fn22()
			fn29()
		end,
	})

	Visual:AddColorPicker({
		Name = "Items color",
		Default = Color3.new(0.35, 0, 1),
		Callback = function(itemsColor)
			tbl.ItemsColor = itemsColor
			fn21()
			fn26()
		end,
	})

	Visual:AddToggle({
		Name = "Items Tags",
		Callback = function(itemsTagsEsp)
			tbl.ItemsTagsEsp = itemsTagsEsp

			if itemsTagsEsp then
				fn28(ingame)
			else
				fn27()
			end
		end,
	})
end

Visual:AddSection("Objects")

do
	local connection = nil

	local tbl10 = {
		{
			Name = "Veeronica Graffiti",
			Color = "VeeronicaGraffitiEspColor",
			ChangeTransparency = true,
			Match = function(arg)
				return arg.Name == "GraffitiCL"
			end,
		},
		{
			Name = "Taph Traps",
			Color = "TaphTrapsEspColor",
			ChangeTransparency = false,
			Match = function(arg)
				return arg.Name == "SubspaceTripmine" or arg:FindFirstChild("Wire") ~= nil
			end,
		},
		{
			Name = "Two Time Rituals",
			Color = "RespawnLocationEspColor",
			ChangeTransparency = true,
			Match = function(arg)
				return string.find(arg.Name, "RespawnLocation") ~= nil
			end,
		},
		{
			Name = "Builderman Sentry/Dispenser",
			Color = "BuildermanEspColor",
			ChangeTransparency = false,
			Match = function(arg)
				return arg.Name == "BuildermanSentry" or arg.Name == "BuildermanDispenser"
			end,
		},
		{
			Name = "Azure Traps",
			Color = "AzureEspColor",
			ChangeTransparency = false,
			Match = function(arg)
				return arg.Name == "GroundBulbModel" or string.find(arg.Name, "GroundBulb") ~= nil or arg.Name == "VineModel" or string.find(arg.Name, "Vine") ~= nil or arg.Name == "MisterBeast" or arg.Name == "GolemStatue" or arg.Name == "GolemHoverHitbox" or string.find(arg.Name, "Golem") ~= nil
			end,
			Radius = function(arg)
				if arg.Name == "GroundBulbModel" then
					return 30
				end

				if arg.Name == "VineModel" or string.find(arg.Name, "Vine") ~= nil then
					return 20
				end
				return nil
			end,
		},
	}

	local tbl11 = {}

	for _, v3 in ipairs(tbl10) do
		tbl11[v3.Name] = true
	end

	local function fn17(arg)
		for _, v3 in ipairs(tbl10) do
			if v3.Match(arg) then
				return v3
			end
		end

		return nil
	end

	local tbl12 = {}
	local connection2 = nil

	local function fn18(arg)
		if arg:IsA("Model") then
			return arg.PrimaryPart or arg:FindFirstChildWhichIsA("BasePart")
		end

		if arg:IsA("BasePart") then
			return arg
		end
		return nil
	end

	local function fn19(arg)
		local v3 = tbl12[arg]

		if v3 then
			v3:Remove()
			tbl12[arg] = nil
		end
	end

	local function fn20(arg, arg2, color)
		if tbl12[arg] then
			return
		end

		if not fn18(arg) then
			return
		end
		local v3 = forsakenFK.textTag()
		tbl12[arg] = v3
		v3.Visible = false
		v3.Center = true
		v3.Outline = true
		v3.Font = 2
		v3.Size = tbl.EspTextSize or 14
		v3.Color = color or Color3.new(1, 1, 1)
		v3.Text = arg2.Name
	end

	local function fn21(arg)
		local name = arg.Name or ""
		local n = arg:IsA("Model") and 2 or 1

		if name == "GroundBulbModel" or name == "VineModel" then
			n += 3
		end

		if name == "GolemStatue" or name == "MisterBeast" then
			n += 3
		end

		if string.find(name, "Model") then
			n += 1
		end

		if string.find(name, "HoverHitbox") or string.find(name, "Hitbox") then
			n -= 2
		end

		return n
	end

	local function fn22(...) end

	local function fn23(parent)
		if not parent or not parent.Parent then
			return
		end
		local v3 = fn17(parent)
		if not v3 then
			return
		end

		if tbl.ObjectsEsp == true and tbl11[v3.Name] == true then
			if v3.ChangeTransparency and parent:IsA("BasePart") then
				parent.Transparency = 0
			end

			local v4 = tbl[v3.Color]
			local hFillTransparency = tbl.HFillTransparency or 0.8
			local outlineTransparency = tbl.DisableOutline and 1 or 0
			local highlight = parent:FindFirstChild("Highlight")

			if not highlight then
				createHighlight(parent, v4, { CheckWorkspace = true })
				highlight = parent:FindFirstChild("Highlight")
			end

			if highlight then
				highlight.FillColor = v4
				highlight.OutlineColor = v4
				highlight.FillTransparency = hFillTransparency
				highlight.OutlineTransparency = outlineTransparency
			end
		else
			if v3.ChangeTransparency and parent:IsA("BasePart") then
				parent.Transparency = 1
			end

			local highlight = parent:FindFirstChild("Highlight")

			if highlight then
				highlight:Destroy()
			end
		end

		if tbl.ObjectsTagsEsp == true and tbl11[v3.Name] == true then
			fn20(parent, v3, tbl[v3.Color])
		else
			fn19(parent)
		end

		if v3.Radius then
			local v4 = v3.Radius(parent)
			local azureAttackRadius = parent:FindFirstChild("AzureAttackRadius")

			if v4 and tbl.AzureRadiusEsp then
				local isModel = parent:IsA("Model")
				local primaryPart

				if isModel then
					primaryPart = parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart")
				else
					primaryPart = isModel
				end

				primaryPart = primaryPart or parent

				if primaryPart then
					if not azureAttackRadius then
						azureAttackRadius = Instance.new("CylinderHandleAdornment")
						azureAttackRadius.Name = "AzureAttackRadius"
						azureAttackRadius.Color3 = Color3.fromRGB(255, 30, 30)
						azureAttackRadius.Transparency = 0.75
						azureAttackRadius.Height = 0.05
						azureAttackRadius.AlwaysOnTop = true
						azureAttackRadius.Parent = parent
					end

					azureAttackRadius.CFrame = primaryPart.CFrame:ToObjectSpace(CFrame.new(primaryPart.Position) * CFrame.Angles(1.5707963267948966, 0, 0))
					azureAttackRadius.Radius = v4
					azureAttackRadius.Adornee = primaryPart
				end
			elseif azureAttackRadius then
				azureAttackRadius:Destroy()
			end
		end
	end

	local function fn24()
		local flag = tbl.AzureRadiusEsp == true

		if tbl.ObjectsTagsEsp then
			flag = true
		end

		local v3

		if tbl.ObjectsEsp then
			for _, v4 in ipairs(tbl10) do
				if tbl11[v4.Name] then
					flag = true
					break
				end
			end

			v3 = flag
		else
			v3 = flag
		end

		if v3 then
			if not connection and ingame then
				connection = ingame.ChildAdded:Connect(function(child)
					task.wait(0.5)
					fn23(child)
				end)
			end

			if not connection2 then
				connection2 = RunService.RenderStepped:Connect(fn22)
			end
		else
			if connection then
				connection:Disconnect()
				connection = nil
			end

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			for k in pairs(tbl12) do
				fn19(k)
			end
		end
	end

	local function fn25()
		fn24()

		if ingame then
			for _, child in ipairs(ingame:GetChildren()) do
				fn23(child)
			end
		end
	end

	local tbl13 = {}

	for _, v3 in ipairs(tbl10) do
		table.insert(tbl13, v3.Name)
	end

	Visual:AddToggle({
		Name = "Objects ESP",
		Callback = function(objectsEsp)
			tbl.ObjectsEsp = objectsEsp
			fn25()
		end,
	})

	Visual:AddToggle({
		Name = "Objects Tags",
		Callback = function(objectsTagsEsp)
			tbl.ObjectsTagsEsp = objectsTagsEsp
			fn25()
		end,
	})

	Visual:AddDropdown({
		Name = "Objects",
		Options = tbl13,
		Multi = true,
		Callback = function(arg)
			for _, v3 in ipairs(tbl10) do
				tbl11[v3.Name] = arg[v3.Name] == true
			end

			fn25()
		end,
	})

	for _, v3 in ipairs(tbl10) do
		Visual:AddColorPicker({
			Name = v3.Name .. " color",
			Default = tbl[v3.Color] or Color3.fromRGB(255, 255, 255),
			Callback = function(arg)
				tbl[v3.Color] = arg
				fn25()
			end,
		})
	end

	Visual:AddToggle({
		Name = "Azure Traps Attack Radius",
		Callback = function(azureRadiusEsp)
			tbl.AzureRadiusEsp = azureRadiusEsp
			fn25()
		end,
	})

	Visual:AddSection("Settings")

	Visual:AddSlider({
		Name = "Highlight Transparency",
		Min = 0,
		Max = 1,
		Default = tbl.HFillTransparency or 0.8,
		Callback = function(hFillTransparency)
			tbl.HFillTransparency = hFillTransparency
		end,
	})

	local function fn26(size)
		local size2 = math.max(8, size - 1)

		for _, v3 in pairs(tbl6) do
			if v3 then
				v3.Size = size
			end
		end

		for _, v3 in pairs(tbl7) do
			if v3.MainText then
				v3.MainText.Size = size
			end

			if v3.InfoText then
				v3.InfoText.Size = size2
			end

			if v3.StaminaText then
				v3.StaminaText.Size = size2
			end
		end

		for _, v3 in pairs(tbl8) do
			if v3 then
				v3.Size = size
			end
		end

		for _, v3 in pairs(tbl9) do
			if v3.Text then
				v3.Text.Size = size
			end
		end

		for _, v3 in pairs(tbl12) do
			if v3 then
				v3.Size = size
			end
		end
	end

	Visual:AddSlider({
		Name = "Text Tags Size",
		Min = 8,
		Max = 30,
		Default = 14,
		Callback = function(espTextSize)
			tbl.EspTextSize = espTextSize
			fn26(espTextSize)
		end,
	})
end

task.wait()
local Generators
Generators = Main:AddTab("Generators", "Generator")
local flag, image, connection, tbl10

do
	local flag2 = false
	local thread = nil
	local n = 0
	local n2 = 0
	local flag3 = false
	flag = false
	local flag4 = false
	local tbl11 = {}
	image = "rbxassetid://80233106875927"
	local connection2 = nil
	local connection3 = nil
	local screenGui = nil
	local connection4 = nil
	connection = nil
	local flag5 = false
	local startGame = nil
	local v3 = nil
	local n3 = 4
	local n4 = 10

	local tbl12 = {
		EnableESP = false,
		AutoComplete = false,
		ActionDelay = 0.05,
		ESPTransparency = 0.5,
		CustomGridSizeEnabled = false,
		GridSize = 10,
	}

	tbl10 = {
		Settings = { AutoEnter = false, AutoExit = false, KillerDist = 40 },
		State = { LoopThread = nil },
	}

	local tbl13 = {
		["Nino Nakano"] = "rbxassetid://80233106875927",
		Ishowspeed = "rbxassetid://85159980827707",
		Astolfo = "rbxassetid://121262699921865",
		Nyansaken = "rbxassetid://126404850818879",
		["Random Cosplayer"] = "rbxassetid://74684171596187",
	}

	local FlowGameManager = nil
	local FlowGame = nil

	pcall(function()
		FlowGameManager = require(ReplicatedStorage.Modules.Minigames.FlowGameManager)
		FlowGame = require(ReplicatedStorage.Modules.Minigames.FlowGameManager.FlowGame)
	end)

	local function fn17()
		while flag2 do
			flag3 = true
			n2 = tbl and tbl.AutoGeneratorsTime or 1.5
			n = os.clock() + n2
			local now = os.clock()

			while flag2 and os.clock() - now < n2 do
				RunService.Heartbeat:Wait()
			end

			if flag2 then
				local character = localPlayer.Character
				character = character and character:FindFirstChild("HumanoidRootPart")
				local map = ingame and ingame:FindFirstChild("Map")

				if character and map then
					local position = character.Position

					for _, child in ipairs(map:GetChildren()) do
						if child.Name == "Generator" or child.Name == "FakeGenerator" then
							local progress = child:FindFirstChild("Progress")

							if progress and progress.Value ~= 100 then
								local main = child:FindFirstChild("Main")

								if main and (position - main.Position).Magnitude < 10 then
									local remotes = child:FindFirstChild("Remotes")
									remotes = remotes and remotes:FindFirstChild("RE")

									if remotes then
										remotes:FireServer()
									end
								end
							end
						end
					end
				end

				flag3 = false
				task.wait()
				continue
			end

			break
		end

		flag3 = false
	end

	local function fn18(arg)
		for _, v4 in pairs(tbl11) do
			v4:Disconnect()
		end

		table.clear(tbl11)
		flag2 = false
		flag3 = false

		if thread then
			task.cancel(thread)
			thread = nil
		end

		if arg then
			local playerGui2 = localPlayer.PlayerGui

			tbl11.open = playerGui2.ChildAdded:Connect(function(child)
				if child.Name == "PuzzleUI" then
					flag2 = true
					flag3 = false

					if thread then
						task.cancel(thread)
					end

					thread = task.spawn(fn17)
				end
			end)

			tbl11.close = playerGui2.ChildRemoved:Connect(function(child)
				if child.Name == "PuzzleUI" then
					flag2 = false
					flag3 = false

					if thread then
						task.cancel(thread)
						thread = nil
					end
				end
			end)

			if playerGui2:FindFirstChild("PuzzleUI") then
				flag2 = true
				flag3 = false
				thread = task.spawn(fn17)
			end
		end
	end

	Generators:AddSection("Auto Generators")
	Generators:AddToggle({ Name = "Auto Generator", Callback = fn18 })

	Generators:AddToggle({
		Name = "Random repair speed",
		Callback = function(randomGenTime)
			tbl.RandomGenTime = randomGenTime

			if randomGenTime then
				task.spawn(function()
					local v4 = Random.new()

					while tbl.RandomGenTime do
						local v5 = v4:NextNumber(n3, n4)
						tbl.AutoGeneratorsTime = v5
						task.wait(math.max(0.1, v5 * 0.5))
					end
				end)
			end
		end,
	})

	Generators:AddSlider({
		Name = "Repair speed (seconds)",
		Min = 1.5,
		Max = 10,
		Callback = function(autoGeneratorsTime)
			tbl.AutoGeneratorsTime = autoGeneratorsTime
		end,
	})

	Generators:AddSlider({
		Name = "Random repair max",
		Min = 1,
		Max = 10,
		Default = n4,
		Callback = function(arg)
			n4 = math.max(arg, n3)
		end,
	})

	Generators:AddSlider({
		Name = "Random repair min",
		Min = 1,
		Max = 10,
		Default = n3,
		Callback = function(arg)
			n3 = math.min(arg, n4)
		end,
	})

	local flag6 = false
	local ScreenGui = nil
	local n5 = 2.5

	local function fn19()
		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		local map = ingame and ingame:FindFirstChild("Map")
		local v4 = character and map
		local n6 = 0

		if v4 then
			local position = character.Position

			for _, child in ipairs(map:GetChildren()) do
				if child.Name == "Generator" or child.Name == "FakeGenerator" then
					local progress = child:FindFirstChild("Progress")

					if progress and progress.Value ~= 100 then
						local main = child:FindFirstChild("Main")

						if main and (position - main.Position).Magnitude < 10 then
							local remotes = child:FindFirstChild("Remotes")
							remotes = remotes and remotes:FindFirstChild("RE")

							if remotes then
								remotes:FireServer()
								n6 += 1
							end
						end
					end
				end
			end
		end

		return n6
	end

	local function fn20()
		if ScreenGui and ScreenGui.Parent then
			local main = ScreenGui:FindFirstChild("Main")
			main = main and main:FindFirstChild("Generate")
			if main and main.Parent then
				return main
			end
		end

		return nil
	end

	local function fn21()
		if flag6 then
			return
		end
		flag6 = true
		local v4 = fn20()
		local v5 = n5
		local now = os.clock()

		while os.clock() - now < v5 do
			if ScreenGui ~= nil then
				if v4 and v4.Parent then
					v4.Text = string.format("%.1f", math.max(v5 - os.clock() - now, 0))
					v4.BackgroundColor3 = Color3.fromRGB(255, 150, 60)
				end

				RunService.Heartbeat:Wait()
				continue
			end

			break
		end

		local v6 = fn19()

		if v4 and v4.Parent then
			v4.Text = v6 and v6 > 0 and "OK " .. v6 or "NO GEN"
			v4.BackgroundColor3 = Color3.fromRGB(0, 205, 160)
			RunService.Heartbeat:Wait()
			task.wait(0.6)
			v4.Text = "CLICK GENERATOR"
		end

		flag6 = false
	end

	local function fn22()
		local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
		if not playerGui2 then
			return
		end

		if ScreenGui then
			ScreenGui:Destroy()
		end

		ScreenGui = nil
		ScreenGui = forsakenFK.make("ScreenGui", { Name = "GeneratorManual", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling }, playerGui2)

		local TextBox = forsakenFK.make("TextBox", {
			Name = "Value",
			Size = UDim2.new(1, -46, 0, 43),
			Position = UDim2.new(0, 23, 0, 60),
			BackgroundColor3 = Color3.fromRGB(54, 54, 76),
			BorderSizePixel = 0,
			Text = "2.5",
			TextColor3 = Color3.fromRGB(225, 225, 225),
			TextSize = 15,
			Font = Enum.Font.Gotham,
			ClearTextOnFocus = false,
			PlaceholderText = "Value",
		})

		forsakenFK.make("UICorner", { CornerRadius = UDim.new(0, 10) }, TextBox)

		local TextButton = forsakenFK.make("TextButton", {
			Name = "Generate",
			Size = UDim2.new(1, -46, 0, 52),
			Position = UDim2.new(0, 23, 0, 108),
			BackgroundColor3 = Color3.fromRGB(0, 205, 160),
			BorderSizePixel = 0,
			Text = "CLICK GENERATOR",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 16,
			Font = Enum.Font.GothamBold,
			AutoButtonColor = false,
		})

		forsakenFK.make("UICorner", { CornerRadius = UDim.new(0, 11) }, TextButton)

		local TextLabel = forsakenFK.make("TextLabel", {
			Name = "Title",
			Size = UDim2.new(1, -52, 1, 0),
			Position = UDim2.new(0, 12, 0, 0),
			BackgroundTransparency = 1,
			Text = "Generator Manual",
			TextColor3 = Color3.fromRGB(245, 245, 245),
			TextSize = 17,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local TextButton2 = forsakenFK.make("TextButton", {
			Name = "Close",
			Size = UDim2.new(0, 31, 0, 31),
			Position = UDim2.new(1, -38, 0, 7),
			BackgroundColor3 = Color3.fromRGB(255, 80, 85),
			BorderSizePixel = 0,
			Text = "−",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 19,
			Font = Enum.Font.GothamBold,
			AutoButtonColor = true,
		})

		forsakenFK.make("UICorner", { CornerRadius = UDim.new(1, 0) }, TextButton2)
		local make = forsakenFK.make

		local tbl14 = {
			Name = "Header",
			Size = UDim2.new(1, 0, 0, 45),
			BackgroundColor3 = Color3.fromRGB(40, 40, 55),
			BorderSizePixel = 0,
			Active = true,
		}

		local children = {}
		local UICorner = forsakenFK.make("UICorner", { CornerRadius = UDim.new(0, 14) })

		local Frame = forsakenFK.make("Frame", {
			Name = "HeaderFix",
			Size = UDim2.new(1, 0, 0, 14),
			Position = UDim2.new(0, 0, 1, -14),
			BackgroundColor3 = Color3.fromRGB(40, 40, 55),
			BorderSizePixel = 0,
		})

		children[1] = UICorner
		children[2] = Frame
		children[3] = TextLabel
		children[4] = TextButton2
		tbl14.Children = children
		local Frame2 = make("Frame", tbl14)

		local Frame3 = forsakenFK.make("Frame", {
			Name = "Main",
			Size = UDim2.new(0, 231, 0, 181),
			Position = UDim2.new(0, 15, 0.5, -90),
			BackgroundColor3 = Color3.fromRGB(30, 29, 38),
			BorderSizePixel = 0,
			Children = { forsakenFK.make("UICorner", { CornerRadius = UDim.new(0, 14) }), Frame2, TextBox, TextButton },
		})

		Frame3.Parent = ScreenGui

		local function fn23()
			local num = tonumber(TextBox.Text)

			if not num or num <= 0 then
				TextBox.Text = "Invalid"
				task.wait(1)
				TextBox.Text = tostring(n5)
				return
			end

			n5 = num
			fn21()
		end

		TextButton.MouseButton1Click:Connect(fn23)

		TextButton.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch then
				fn23()
			end
		end)

		TextButton.MouseEnter:Connect(function()
			TextButton.BackgroundColor3 = Color3.fromRGB(0, 225, 175)
		end)

		TextButton.MouseLeave:Connect(function()
			TextButton.BackgroundColor3 = Color3.fromRGB(0, 205, 160)
		end)

		TextBox.FocusLost:Connect(function()
			local num = tonumber(TextBox.Text)

			if num and num > 0 then
				n5 = num
			end
		end)

		local flag7 = false

		TextButton2.MouseButton1Click:Connect(function()
			flag7 = not flag7

			if flag7 then
				TextBox.Visible = false
				TextButton.Visible = false
				Frame3.Size = UDim2.new(0, 231, 0, 45)
				TextButton2.Text = "+"
			else
				TextBox.Visible = true
				TextButton.Visible = true
				Frame3.Size = UDim2.new(0, 231, 0, 181)
				TextButton2.Text = "−"
			end
		end)

		local flag8 = false
		local position = nil
		local position2 = nil

		Frame2.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				flag8 = true
				position = input.Position
				position2 = Frame3.Position
			end
		end)

		Frame2.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				flag8 = false
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if not flag8 then
				return
			end

			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				local n6 = input.Position - position
				Frame3.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n6.X, position2.Y.Scale, position2.Y.Offset + n6.Y)
			end
		end)
	end

	if Generators.AddKeybind then
		Generators:AddKeybind({
			Name = "Manual Generator Keybind",
			Callback = function()
				if not flag6 then
					fn19()
				end
			end,
		})
	end

	Generators:AddToggle({
		Name = "Manual Generator GUI",
		Callback = function(arg)
			if arg then
				fn22()
			elseif ScreenGui then
				ScreenGui:Destroy()
				ScreenGui = nil
			end
		end,
	})

	Generators:AddSection("Generators UI")

	local function fn23()
		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end

		if connection3 then
			connection3:Disconnect()
			connection3 = nil
		end

		local playerGui2 = localPlayer.PlayerGui
		local puzzleUI = playerGui2:FindFirstChild("PuzzleUI")
		local backgroundUI = playerGui2:FindFirstChild("TemporaryUI") and playerGui2.TemporaryUI:FindFirstChild("BackgroundUI")

		if tbl.GeneratorsUI then
			if puzzleUI and backgroundUI then
				puzzleUI.Enabled = false
				backgroundUI.Enabled = false
			end

			connection2 = playerGui2.ChildAdded:Connect(function(child)
				if child.Name == "PuzzleUI" then
					child.Enabled = false
				end
			end)

			connection3 = playerGui2:WaitForChild("TemporaryUI").ChildAdded:Connect(function(child)
				if child.Name == "BackgroundUI" and child:FindFirstChild("Background") and child.Background:FindFirstChild("BarHolder") then
					child.Enabled = false
				end
			end)
		elseif puzzleUI and backgroundUI then
			puzzleUI.Enabled = true
			backgroundUI.Enabled = true
		end
	end

	Generators:AddToggle({
		Name = "Close generators UI",
		Callback = function(generatorsUI)
			tbl.GeneratorsUI = generatorsUI
			fn23()
		end,
	})

	local function fn24()
		if screenGui then
			return
		end
		screenGui = Instance.new("ScreenGui")
		local v4 = screenGui
		local v5 = screenGui
		local v6 = CoreGui
		screenGui.Name = "GeneratorRepairTimer"
		v4.ResetOnSpawn = false
		v5.Parent = v6
		local frame = Instance.new("Frame", screenGui)
		local udim2 = UDim2.fromOffset(220, 50)
		local udim22 = UDim2.new(0.5, -110, 0.85, 0)
		local color = Color3.fromRGB(25, 25, 25)
		frame.Size = udim2
		frame.Position = udim22
		frame.BackgroundColor3 = color
		frame.BorderSizePixel = 0
		frame.Active = true
		frame.Draggable = true
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
		local textLabel = Instance.new("TextLabel", frame)
		local udim23 = UDim2.fromScale(1, 1)
		local gothamBold = Enum.Font.GothamBold
		local color2 = Color3.new(1, 1, 1)
		textLabel.Name = "TimerText"
		textLabel.Size = udim23
		textLabel.BackgroundTransparency = 1
		textLabel.Font = gothamBold
		textLabel.TextScaled = true
		textLabel.TextColor3 = color2
		textLabel.Text = "Generator: --"
	end

	local function fn25()
		if connection4 then
			connection4:Disconnect()
			connection4 = nil
		end

		if screenGui then
			screenGui:Destroy()
			screenGui = nil
		end
	end

	Generators:AddToggle({
		Name = "shows the remaining time until repair",
		Callback = function(arg)
			if arg then
				fn24()

				if not connection4 then
					connection4 = RunService.RenderStepped:Connect(function(...) end)
				end
			else
				fn25()
			end
		end,
	})

	local v4 = nil

	local function fn26()
		local v5 = flag5
		local flag7

		if flag5 then
			flag7 = v5
		else
			flag7 = not FlowGameManager
		end

		if flag7 or not FlowGame then
			return
		end
		local new = FlowGame.new
		startGame = FlowGameManager.startGame
		v3 = new

		FlowGameManager.startGame = function(arg, arg2, arg3)
			return startGame(arg, tbl12.CustomGridSizeEnabled and tbl12.GridSize or arg2, arg3)
		end

		FlowGame.new = function(arg, arg2, arg3)
			local gridSize = tbl12.CustomGridSizeEnabled and tbl12.GridSize or arg2
			local v6 = v3(arg, gridSize, arg3)
			v6.CustomSizeHack = gridSize
			return v6
		end

		flag5 = true
	end

	local function fn27(arg, arg2)
		if not arg or #arg == 0 then
			return arg
		end
		arg2 = arg2 and arg2[1] or arg[1]
		local tbl14 = {}
		local tbl15 = {}
		local tbl16 = { row = arg2.row, col = arg2.col }

		for _, v5 in ipairs(arg) do
			tbl14[v5.row .. "-" .. v5.col] = { row = v5.row, col = v5.col }
		end

		table.insert(tbl15, tbl16)
		tbl14[tbl16.row .. "-" .. tbl16.col] = nil

		while next(tbl14) do
			local flag7 = false

			for k, v5 in pairs(tbl14) do
				local flag8 = v5.row == tbl16.row - 1 and v5.col == tbl16.col
				local flag9

				if flag8 then
					flag9 = flag8
				else
					flag9 = v5.row == tbl16.row + 1 and v5.col == tbl16.col
				end

				flag9 = flag9 or v5.row == tbl16.row and v5.col == tbl16.col - 1
				local flag10

				if flag9 then
					flag10 = flag9
				else
					flag10 = v5.row == tbl16.row and v5.col == tbl16.col + 1
				end

				if flag10 then
					table.insert(tbl15, v5)
					tbl14[k] = nil
					flag7 = true
					tbl16 = v5
					break
				end
			end

			if flag7 then
				continue
			end
			break
		end

		return tbl15
	end

	local function fn28(arg)
		local gridFrame = arg.gridFrame
		if not gridFrame or not gridFrame.Parent then
			return
		end

		if v4 == gridFrame and gridFrame.Parent:FindFirstChild("Generator") then
			return
		end
		v4 = gridFrame

		if gridFrame.Parent:FindFirstChild("Generator") then
			gridFrame.Parent.Generator:Destroy()
		end

		local frame = Instance.new("Frame")
		frame.Name = "Generator"
		frame.ZIndex = 6
		frame.BackgroundTransparency = 1
		frame.Size = gridFrame.Size
		frame.Position = UDim2.fromScale(0.5, 0.5)
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.Parent = gridFrame.Parent
		local n6 = 1 / (arg.CustomSizeHack or arg.size or 6)

		for i = 1, #arg.Solution do
			local v5 = fn27(arg.Solution[i], arg.targetPairs[i])
			local tbl14 = arg.colors[i] or { R = 1.2, G = 1.2, B = 1.2 }
			local color = Color3.new(tbl14.R / 1.2, tbl14.G / 1.2, tbl14.B / 1.2)

			for _, v6 in ipairs(v5) do
				local frame2 = Instance.new("Frame")
				frame2.BorderSizePixel = 0
				frame2.BackgroundTransparency = tbl12.ESPTransparency or 0.5
				frame2.Size = UDim2.fromScale(n6, n6)
				frame2.ZIndex = 7
				frame2.BackgroundColor3 = color
				frame2.Position = UDim2.fromScale(n6 * (v6.col - 1), n6 * (v6.row - 1))
				frame2.Parent = frame
			end
		end
	end

	local function fn29()
		if (tbl12.EnableESP or tbl12.AutoComplete) and not flag4 then
			flag4 = true

			task.spawn(function()
				local flag7 = false

				while tbl12.EnableESP or tbl12.AutoComplete do
					task.wait(0.1)

					if FlowGameManager then
						local activeGame = FlowGameManager.activeGame

						if activeGame and activeGame.gridFrame and activeGame.gridFrame.Parent then
							if tbl12.EnableESP then
								pcall(fn28, activeGame)
							end

							if tbl12.AutoComplete and not flag7 and activeGame.Solution and activeGame.paths then
								flag7 = true

								task.spawn(function()
									for i = 1, #activeGame.Solution do
										if tbl12.AutoComplete then
											activeGame.paths[i] = {}
											local v5 = fn27(activeGame.Solution[i], activeGame.targetPairs[i])
											local solverErrorMargin = tbl12.SolverErrorMargin or 0

											if solverErrorMargin > 0 and #v5 > 2 and math.random(1, 100) <= solverErrorMargin then
												local n6 = #v5 - 1

												for i2 = 1, n6 do
													if tbl12.AutoComplete then
														table.insert(activeGame.paths[i], { row = v5[i2].row, col = v5[i2].col })

														pcall(function()
															activeGame:updateGui()
														end)

														task.wait(tbl12.ActionDelay)
														continue
													end

													break
												end

												task.wait(math.random(5, 12) / 10)

												for i2 = n6 + 1, #v5 do
													if tbl12.AutoComplete then
														table.insert(activeGame.paths[i], { row = v5[i2].row, col = v5[i2].col })

														pcall(function()
															activeGame:updateGui()
														end)

														task.wait(tbl12.ActionDelay)
														continue
													end

													break
												end
											else
												for i2 = 1, #v5 do
													if tbl12.AutoComplete then
														table.insert(activeGame.paths[i], { row = v5[i2].row, col = v5[i2].col })

														pcall(function()
															activeGame:updateGui()
														end)

														task.wait(tbl12.ActionDelay)
														continue
													end

													break
												end
											end

											continue
										end

										break
									end

									pcall(function()
										activeGame:checkForWin()
									end)

									task.wait(0.5)
									flag7 = false
								end)
							end
						else
							flag7 = false
							v4 = nil
						end
					end
				end

				flag4 = false

				if FlowGameManager and FlowGameManager.activeGame and FlowGameManager.activeGame.gridFrame and FlowGameManager.activeGame.gridFrame.Parent and FlowGameManager.activeGame.gridFrame.Parent:FindFirstChild("Generator") then
					FlowGameManager.activeGame.gridFrame.Parent.Generator:Destroy()
					v4 = nil
				end
			end)
		end
	end

	Generators:AddSection("Generator Solver")

	Generators:AddToggle({
		Name = "Generator Solver",
		Callback = function(autoComplete)
			tbl12.AutoComplete = autoComplete
			fn29()
		end,
	})

	Generators:AddSlider({
		Name = "Solve Speed (ms)",
		Min = 0,
		Max = 50,
		Default = 10,
		Callback = function(arg)
			tbl12.ActionDelay = arg / 100
		end,
	})

	Generators:AddSlider({
		Name = "Mistake Chance (%)",
		Min = 0,
		Max = 100,
		Default = 0,
		Callback = function(solverErrorMargin)
			tbl12.SolverErrorMargin = solverErrorMargin
		end,
	})

	Generators:AddSection("Game Hinter")

	Generators:AddToggle({
		Name = "Game Hinter",
		Callback = function(enableESP)
			tbl12.EnableESP = enableESP

			if not enableESP and FlowGameManager and FlowGameManager.activeGame and FlowGameManager.activeGame.gridFrame and FlowGameManager.activeGame.gridFrame.Parent and FlowGameManager.activeGame.gridFrame.Parent:FindFirstChild("Generator") then
				FlowGameManager.activeGame.gridFrame.Parent.Generator:Destroy()
				v4 = nil
			end

			fn29()
		end,
	})

	Generators:AddSlider({
		Name = "Transparency",
		Min = 0,
		Max = 100,
		Default = 50,
		Callback = function(arg)
			tbl12.ESPTransparency = arg / 100
			v4 = nil
		end,
	})

	Generators:AddSection("Grid Size")

	Generators:AddToggle({
		Name = "Custom Grid Size",
		Callback = function(customGridSizeEnabled)
			tbl12.CustomGridSizeEnabled = customGridSizeEnabled

			if customGridSizeEnabled then
				fn26()
			end
		end,
	})

	Generators:AddSlider({
		Name = "Size",
		Min = 2,
		Max = 30,
		Default = 2,
		Callback = function(gridSize)
			tbl12.GridSize = gridSize
		end,
	})

	local function fn30(arg)
		if not flag or not arg then
			return
		end
		local background = arg:FindFirstChild("Container") and arg.Container:FindFirstChild("GridHolder") and arg.Container.GridHolder:FindFirstChild("Background")

		if background and background:IsA("ImageLabel") then
			background.Image = image
		end

		local grid = arg:FindFirstChild("Container") and arg.Container:FindFirstChild("GridHolder") and arg.Container.GridHolder:FindFirstChild("Grid")

		if grid then
			for _, child in ipairs(grid:GetChildren()) do
				local button = child:FindFirstChild("Button")

				if button and button:IsA("GuiObject") then
					button.BackgroundTransparency = 0.6
				end
			end
		end
	end

	Generators:AddSection("Background Changer")

	Generators:AddToggle({
		Name = "BG Changer (Image)",
		Callback = function(arg)
			flag = arg

			if arg then
				local puzzleUI = localPlayer.PlayerGui:FindFirstChild("PuzzleUI")

				if puzzleUI then
					fn30(puzzleUI)
				end

				connection = localPlayer.PlayerGui.ChildAdded:Connect(function(child)
					if child.Name == "PuzzleUI" then
						task.wait(0.1)
						fn30(child)
					end
				end)
			elseif connection then
				connection:Disconnect()
				connection = nil
			end
		end,
	})

	Generators:AddDropdown({
		Name = "BG image",
		Options = { "Nino Nakano", "Ishowspeed", "Astolfo", "Nyansaken", "Random Cosplayer" },
		Callback = function(arg)
			image = tbl13[arg]
			local puzzleUI = localPlayer.PlayerGui:FindFirstChild("PuzzleUI")

			if puzzleUI then
				fn30(puzzleUI)
			end
		end,
	})

	Generators:AddInput({
		Name = "Custom BG image",
		SaveUserText = true,
		Callback = function(arg)
			image = arg:match("%d+") and "rbxassetid://" .. arg:match("%d+") or arg
			local puzzleUI = localPlayer.PlayerGui:FindFirstChild("PuzzleUI")

			if puzzleUI then
				fn30(puzzleUI)
			end
		end,
	})
end

Generators:AddSection("Interact")
local function fn17(...) end

Generators:AddToggle({
	Name = "Auto Enter Generator",
	Callback = function(autoEnter)
		tbl10.Settings.AutoEnter = autoEnter

		if autoEnter then
			fn17()
		end
	end,
})

Generators:AddToggle({
	Name = "Auto Exit (when killer is near)",
	Callback = function(autoExit)
		tbl10.Settings.AutoExit = autoExit

		if autoExit then
			fn17()
		end
	end,
})

Generators:AddSlider({
	Name = "Exit Distance",
	Min = 10,
	Max = 100,
	Default = 30,
	Callback = function(killerDist)
		tbl10.Settings.KillerDist = killerDist
	end,
})

task.wait()
local Block
Block = Main:AddTab("Block", "box")
local str2
str2 = "Normal"
local str3
str3 = "Guest1337"
local tbl11

tbl11 = {
	Noli = Vector3.new(5, 7, 8),
	Slasher = Vector3.new(5, 7, 8),
	c00lkidd = Vector3.new(5, 7, 5.5),
	["1x1x1x1"] = Vector3.new(5, 7, 8),
	JohnDoe = Vector3.new(5, 7, 8),
	Sixer = Vector3.new(5, 7, 8),
	Nosferatu = Vector3.new(5, 7, 8),
	Azure = Vector3.new(5, 7, 8),
}

local tbl12

tbl12 = {
	Noli = -1.7,
	Slasher = -2.1,
	c00lkidd = -0.3,
	["1x1x1x1"] = -2,
	JohnDoe = -2.5,
	Sixer = 0,
	Nosferatu = -2,
}

local vector
vector = Vector3.new(4.5, 6, 7.5)
local color
color = Color3.new(1, 0, 0)
local tbl13
tbl13 = {}
local tbl14
tbl14 = {}
local tbl15
tbl15 = {}
local tbl16
tbl16 = {}
local connection2
connection2 = nil
local v3
v3 = nil
local raycastParams
raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
local overlapParams
overlapParams = OverlapParams.new()
overlapParams.FilterType = Enum.RaycastFilterType.Include
local n = CFrame.new(0, -2.5, 0) * CFrame.Angles(0, 0, 1.5707963267948966)
local flag2
flag2 = false
local flag3
flag3 = false
local n2
n2 = 10
local n3
n3 = 0
local connection3
connection3 = nil
local n4, n5, tbl17, fn18, fn19, fn20

do
	local connection4 = nil
	local animator = nil
	n4 = 0.55
	n5 = 0.12
	local n6 = 0.3
	local n7 = 2
	local tbl18 = { Slasher = { "Slash", "EnragedSlash" } }
	tbl17 = {}
	local sqrt = math.sqrt
	local acos = math.acos
	local vector2 = Vector3.new
	Color3.new(1, 0, 0)
	Color3.new(0, 1, 0)
	Color3.new(0, 0, 1)
	local vector3 = Vector3.new(0, 1.5, 0)
	local v4 = nil
	local n8 = 0
	local tbl19 = {}

	fn18 = function(arg)
		return arg and tostring(arg):match("%d+")
	end

	local function fn21()
		fn6(str3 == "Guest1337" and "Block" or "Clone")
	end

	local function fn22(arg)
		if arg then
			arg = arg:FindFirstChild("HumanoidRootPart") or arg.PrimaryPart or arg:FindFirstChildWhichIsA("BasePart", true)
		end

		return arg
	end

	local function fn23(arg)
		local tbl20 = {}
		local tbl21 = {}
		local killers2 = assets:FindFirstChild("Killers")
		local v5 = killers2 and killers2:FindFirstChild(arg)

		if v5 then
			tbl21[#tbl21 + 1] = v5
		end

		local skins = assets:FindFirstChild("Skins")
		skins = skins and skins:FindFirstChild("Killers")
		skins = skins and skins:FindFirstChild(arg)

		if skins then
			for _, child in ipairs(skins:GetChildren()) do
				tbl21[#tbl21 + 1] = child
			end
		end

		for _, v6 in ipairs(tbl21) do
			local config = v6:FindFirstChild("Config") or v6:FindFirstChildWhichIsA("ModuleScript")

			if config then
				local ok, result = pcall(require, config)

				if ok and type(result) == "table" and type(result.Animations) == "table" then
					for _, v7 in ipairs(tbl18[arg]) do
						local v8 = result.Animations[v7]

						if type(v8) == "string" and v8:match("%d+") then
							tbl20[v8:match("%d+")] = true
						elseif type(v8) == "table" then
							for _, v9 in pairs(v8) do
								local match = type(v9) == "string" and v9:match("%d+")

								if match then
									tbl20[match] = true
								end
							end
						end
					end
				end
			end
		end

		return tbl20
	end

	local function fn24(arg)
		if flag3 or not arg or not arg.Parent then
			return
		end
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local v5 = fn22(arg)
		if not (humanoidRootPart and humanoid and v5) then
			return
		end
		flag3 = true
		humanoid.WalkSpeed = 0
		humanoid.JumpPower = 0
		humanoid.PlatformStand = false
		humanoid.AutoRotate = false
		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(100000, 0, 100000)
		bodyVelocity.Velocity = Vector3.zero
		bodyVelocity.Parent = humanoidRootPart
		RunService.Heartbeat:Connect(function(...) end)

		task.delay(0.4, function()
			flag3 = false
		end)
	end

	local function fn25()
		local v5 = fn4()
		animator = v5 and v5:FindFirstChildOfClass("Animator") or nil
	end

	fn19 = function()
		if connection3 then
			connection3:Disconnect()
			connection3 = nil
		end

		if connection4 then
			connection4:Disconnect()
			connection4 = nil
		end

		if not flag2 then
			return
		end

		local function fn26(arg)
			if not flag2 or flag3 then
				return
			end
			local match = arg.Animation and arg.Animation.AnimationId:match("%d+")

			if match and tbl2.GuestBlockAnim[match] then
				local v5 = fn15({ Folder = killers })

				if v5 then
					task.spawn(function()
						if n3 > 0 then
							task.wait(n3)
						end

						fn24(v5)
					end)
				end
			end
		end

		local function fn27(arg)
			if connection4 then
				connection4:Disconnect()
				connection4 = nil
			end

			if arg then
				connection4 = arg.AnimationPlayed:Connect(fn26)
			end
		end

		connection3 = RunService.RenderStepped:Connect(function(...) end)

		if not animator or not animator:IsDescendantOf(Workspace) then
			fn25()
		end

		fn27(animator)
	end

	local function fn26(arg)
		return tbl.OverrideHitboxSizes and vector or tbl11[arg] or vector
	end

	fn20 = function()
		for k, v5 in pairs(tbl15) do
			v5:SetAttribute("BaseSize", fn26(k.Name))
		end
	end

	local function createPart()
		local part = Instance.new("Part")
		part.Name = "ForsakenWallTracer"
		part.Anchored = true
		part.CanCollide = false
		part.Massless = true
		part.CastShadow = false
		part.Material = Enum.Material.Neon
		part.Color = Color3.new(0, 1, 0)
		part.Transparency = 1
		part.Size = Vector3.new(0.05, 0.05, 1)
		part.Parent = Workspace:FindFirstChild("Camera") or Workspace
		return part
	end

	local function createPart2(parent, arg)
		if not arg then
			return nil
		end
		local forsakenAttackHitbox = parent:FindFirstChild("ForsakenAttackHitbox")

		if forsakenAttackHitbox then
			forsakenAttackHitbox:Destroy()
		end

		local v5 = fn26(parent.Name)
		local part = Instance.new("Part")
		part.Name = "ForsakenAttackHitbox"
		part.CanCollide = false
		part.Massless = true
		part.Anchored = true
		part.Material = Enum.Material.ForceField
		part.CastShadow = false
		part.Transparency = 1
		part.Size = v5
		part:SetAttribute("BaseSize", v5)
		local highlight = Instance.new("Highlight")
		highlight.Name = "HitboxHighlight"
		local v6 = color
		highlight.FillTransparency = 1
		highlight.OutlineColor = v6
		highlight.OutlineTransparency = 0
		highlight.Parent = part
		part.Parent = parent
		tbl15[parent] = part
		return part
	end

	local function fn27(arg)
		if tbl15[arg] then
			tbl15[arg]:Destroy()
			tbl15[arg] = nil
		end

		if tbl16[arg] and tbl16[arg].Tracer then
			tbl16[arg].Tracer:Destroy()
		end

		tbl16[arg] = nil
	end

	local function fn28(arg)
		arg.blocked = true
		local n9 = (tbl.GlobalDelay or 0) / 1000

		if n9 > 0 then
			task.delay(n9, fn21)
		else
			fn21()
		end
	end

	local function fn29(arg)
		local filterDescendantsInstances = { arg }
		local currentCamera2 = Workspace.CurrentCamera

		if currentCamera2 then
			filterDescendantsInstances[#filterDescendantsInstances + 1] = currentCamera2
		end

		if killers then
			for _, child in ipairs(killers:GetChildren()) do
				filterDescendantsInstances[#filterDescendantsInstances + 1] = child
			end
		end

		for _, player_ in ipairs(Players:GetPlayers()) do
			if player_ ~= localPlayer and player_.Character then
				filterDescendantsInstances[#filterDescendantsInstances + 1] = player_.Character
			end
		end

		raycastParams.FilterDescendantsInstances = filterDescendantsInstances
	end

	local function fn30(arg, arg2)
		local n9 = arg.Position + vector3
		local n10 = arg2.Position + vector3 - n9
		if n10.X * n10.X + n10.Y * n10.Y + n10.Z * n10.Z < 0.01 then
			return false
		end
		local hit = Workspace:Raycast(n9, n10, raycastParams)
		return hit and hit.Instance and hit.Instance.CanCollide == true and hit.Instance.Transparency < 0.8 or false
	end

	local function fn31(f,C,m)local H= sqrt (C*C+m*m);if H<1.0E-4 then return nil;end;local d= sqrt (f.X*f.X+f.Z*f.Z);if d<1.0E-4 then return nil;end;return(f.X*C+f.Z*m)/(d*H);end

	local function fn32(arg, arg2, arg3)
		if not arg2 then
			return true
		end

		if arg2 >= arg3 then
			return true
		end

		if not arg then
			return false
		end
		local angVelSmooth = arg.AngVelSmooth or 0
		local flag4 = angVelSmooth < n7

		if not flag4 then
			flag4 = (arg.DotRateSmooth or 0) <= 0
		end

		if flag4 then
			return false
		end

		local function fn33(arg4)
			return arg4 > 1 and 1 or arg4 < -1 and -1 or arg4
		end

		local v5 = fn33(arg2)
		local v6 = acos(v5)
		local v7 = fn33(arg3)
		local n9 = v6 - acos(v7)
		if n9 <= 0 then
			return true
		end
		return n9 / angVelSmooth <= n6
	end

	local function fn33(arg)
		return {
			LastPosition = nil,
			LastLookX = nil,
			LastLookZ = nil,
			LastDotVal = nil,
			CurrentSpeed = 0,
			AngVelSmooth = 0,
			DotRateSmooth = 0,
			SpinUntil = 0,
			IsSpinning = false,
			ZOffset = tbl12[arg.Name] or 0,
			WallCheckedAt = 0,
			IsWalled = false,
			Tracer = nil,
			Animators = nil,
			AnimatorsAt = 0,
			LastAnimTrack = nil,
			LastAnimTime = 0,
		}
	end

	local function fn34(arg)
		if v4 ~= arg then
			v4 = arg
			overlapParams.FilterDescendantsInstances = { arg }
		end
	end

	local function fn35(arg, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
		if not arg then
			local autoBlocStuds = tbl.AutoBlocStuds or 12

			if tbl.AntiSpin and arg6 then
				autoBlocStuds = autoBlocStuds + (arg2 and arg2.CurrentSpeed or 0) * 0.15 + 3
			end

			if arg3 * arg3 + arg4 * arg4 > autoBlocStuds * autoBlocStuds then
				return false
			end
			arg7 = tbl.WallCheck and arg7
			if arg7 then
				return false
			end
			return arg9
		end

		arg9 = arg8 and arg9
		local flag4

		if arg9 then
			flag4 = not (tbl.WallCheck and arg7)
		else
			flag4 = arg9
		end

		return flag4
	end

	local function fn36(arg)
		local v5 = tbl14[arg]
		if not v5 or v5.blocked then
			return
		end
		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoidRootPart2 = arg:FindFirstChild("HumanoidRootPart")
		if not (humanoidRootPart and humanoidRootPart2) then
			return
		end
		local v6 = tbl16[arg]
		local n9 = humanoidRootPart.Position.X - humanoidRootPart2.Position.X
		local n10 = humanoidRootPart.Position.Z - humanoidRootPart2.Position.Z
		local v7 = fn31(humanoidRootPart2.CFrame.LookVector, n9, n10)
		local isSpinning = v6 and v6.IsSpinning or false
		local flag4 = str2 == "Anti Bait"
		local flag5, flag6

		if flag4 then
			local v8 = tbl15[arg]
			if not v8 then
				return
			end
			fn34(character)
			flag5 = #Workspace:GetPartsInPart(v8, overlapParams) > 0
			local facingCheck = tbl.FacingCheck or tbl.VisFacing

			if facingCheck then
				facingCheck = not (tbl.AntiSpin and isSpinning)
			end

			flag6 = true

			if facingCheck then
				flag6 = fn32(v6, v7, 0.2)
			end
		else
			flag5 = false
			flag6 = true

			if tbl.NormalFaceCheck then
				flag6 = fn32(v6, v7, tbl.AntiSpin and isSpinning and -0.2 or 0.05)
			end
		end

		if fn35(flag4, v6, n9, n10, v7, isSpinning, tbl.WallCheck and fn30(humanoidRootPart2, humanoidRootPart) or false, flag5, flag6) then
			fn28(v5)
		end
	end

	local function fn37(arg)
		if not tbl.AutoBlockm1c then
			return
		end
		local now = tick()
		local v5 = tbl14[arg]
		if v5 and now - v5.createdAt < n5 then
			v5.endTime = now + n4
			return
		end
		tbl14[arg] = { createdAt = now, endTime = now + n4, blocked = false }
	end

	local function fn38(arg, arg2, animatorsAt)
		local v5 = tbl17[arg.Name]
		if not v5 then
			return
		end
		local animators = arg2.Animators

		if not animators or animatorsAt - arg2.AnimatorsAt > 1 then
			animators = {}

			for _, descendant in ipairs(arg:GetDescendants()) do
				if descendant:IsA("Animator") then
					animators[#animators + 1] = descendant
				end
			end

			arg2.Animators = animators
			arg2.AnimatorsAt = animatorsAt
		end

		for i = 1, #animators do
			local playingAnimationTracks = animators[i]:GetPlayingAnimationTracks()

			for i2 = 1, #playingAnimationTracks do
				local v6 = playingAnimationTracks[i2]
				local animation = v6.Animation

				if animation and v6.TimePosition <= 0.2 then
					local v7 = fn18(animation.AnimationId)

					if v7 and v5[v7] then
						if arg2.LastAnimTrack ~= v6 or animatorsAt - arg2.LastAnimTime > n5 then
							arg2.LastAnimTrack = v6
							arg2.LastAnimTime = animatorsAt

							if tbl.AutoBlockm1c then
								fn37(arg)
								pcall(fn36, arg)
							end
						end
					end
				end
			end
		end
	end

	local function fn39(...) end

	local function fn40(arg)
		task.spawn(function()
			if tbl18[arg.Name] then
				tbl17[arg.Name] = fn23(arg.Name)
			end

			local humanoidRootPart = arg:WaitForChild("HumanoidRootPart", 5)
			if not humanoidRootPart then
				return
			end

			if str2 == "Anti Bait" then
				createPart2(arg, humanoidRootPart)
			end
		end)
	end

	forsakenFK.sounds.on(function(...) end)

	local function fn41()
		for _, v5 in ipairs(tbl13) do
			v5:Disconnect()
		end

		table.clear(tbl13)
		table.clear(tbl14)

		for k in pairs(tbl16) do
			fn27(k)
		end

		table.clear(tbl15)
		table.clear(tbl16)
		table.clear(tbl19)
		table.clear(tbl17)

		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end

		if v3 then
			v3:Destroy()
			v3 = nil
		end

		if not tbl.AutoBlockm1c then
			return
		end
		v4 = nil
		n8 = 0
		connection2 = RunService.Heartbeat:Connect(fn39)

		if killers then
			for _, child in ipairs(killers:GetChildren()) do
				tbl19[#tbl19 + 1] = child
				fn40(child)
			end

			table.insert(tbl13, killers.ChildAdded:Connect(function(child)
				tbl19[#tbl19 + 1] = child
				fn40(child)
			end))

			table.insert(tbl13, killers.ChildRemoved:Connect(function(child)
				for i = #tbl19, 1, -1 do
					if tbl19[i] == child then
						table.remove(tbl19, i)
						break
					end
				end

				tbl14[child] = nil
				fn27(child)
			end))
		end
	end

	local v5 = Block:AddDropdown({
		Name = "Block Mode",
		Description = "Normal (radius); Anti Bait (hitbox)",
		Options = { "Normal", "Anti Bait" },
		Default = str2,
		Callback = function(arg)
			str2 = arg
			fn41()
		end,
	})

	local v6 = Block:AddDropdown({
		Name = "Auto Block Character",
		Options = { "Guest1337", "007n7" },
		Default = "Guest1337",
		Callback = function(arg)
			str3 = arg
		end,
	})

	local v7 = nil
	local tbl20 = { mobileButtonCreated = false, screenGui = nil, MobileButton = nil }

	createMobileAutoBlockButton = function()
		if tbl20.mobileButtonCreated then
			return
		end

		local v8 = fn7({
			name = "MobileAutoBlock",
			text = tbl.AutoBlockm1c and "BLOCK ON" or "BLOCK OFF",
			position = UDim2.new(0.8, 0, 0.8, 0),
			backgroundColor3 = Color3.fromRGB(30, 30, 30),
			borderColor3 = Color3.fromRGB(255, 0, 0),
			onClick = function(arg)
				tbl.AutoBlockm1c = not tbl.AutoBlockm1c
				fn41()
				arg.Text = tbl.AutoBlockm1c and "BLOCK ON" or "BLOCK OFF"

				if v7 then
					v7:SetState(tbl.AutoBlockm1c)
				end
			end,
			onClose = function()
				tbl20.mobileButtonCreated = false

				if tbl20.screenGui then
					tbl20.screenGui:Destroy()
					tbl20.screenGui = nil
				end
			end,
		})

		if v8 then
			local v9 = tbl20
			local v10 = tbl20
			local gui = v8.gui
			local button = v8.button
			tbl20.screenGui = gui
			v9.MobileButton = button
			v10.mobileButtonCreated = true
		end
	end

	v7 = Block:AddToggle({
		Name = "Auto block",
		Description = "Auto block when killer attacks",
		Default = tbl.AutoBlockm1c,
		Callback = function(autoBlockm1c)
			tbl.AutoBlockm1c = autoBlockm1c
			fn41()

			if pcall(function()
				return UserInputService.TouchEnabled
			end) then
				if autoBlockm1c and not tbl20.mobileButtonCreated then
					createMobileAutoBlockButton()
				elseif tbl20.mobileButtonCreated and tbl20.MobileButton then
					tbl20.MobileButton.Text = autoBlockm1c and "BLOCK ON" or "BLOCK OFF"
				end
			end
		end,
	})

	local v8 = Block:AddKeybind({
		Name = "Auto Block Keybind",
		Callback = function()
			if v7 then
				v7:Toggle()
			end
		end,
	})

	local v9 = Block:AddToggle({
		Name = "Visualize Auto Block Radius",
		Default = tbl.VisualizeRadius,
		Callback = function(visualizeRadius)
			tbl.VisualizeRadius = visualizeRadius
		end,
	})

	local v10 = Block:AddSlider({
		Name = "Auto block Radius (studs)",
		Min = 5,
		Max = 20,
		Default = tbl.AutoBlocStuds or 12,
		Callback = function(autoBlocStuds)
			tbl.AutoBlocStuds = autoBlocStuds

			if v3 then
				v3.Size = Vector3.new(0.1, autoBlocStuds * 2, autoBlocStuds * 2)
			end
		end,
	})

	local v11 = Block:AddToggle({
		Name = "Normal Mode Face Check",
		Default = tbl.NormalFaceCheck,
		Callback = function(normalFaceCheck)
			tbl.NormalFaceCheck = normalFaceCheck
		end,
	})

	local v12 = Block:AddSlider({
		Name = "Global Auto Block Delay (ms)",
		Min = 0,
		Max = 200,
		Default = tbl.GlobalDelay or 0,
		Callback = function(globalDelay)
			tbl.GlobalDelay = globalDelay
		end,
	})

	FAKEblock_FUNC = function()
		local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
		local flag4 = character.Name == "Guest1337" and character:GetAttribute("SkinNameDisplay") and character:GetAttribute("SkinNameDisplay") ~= ""
		local animationId = "rbxassetid://72722244508749"

		if flag4 then
			local attribute = character:GetAttribute("SkinNameDisplay")
			local guest1337 = assets and assets:FindFirstChild("Skins") and assets.Skins:FindFirstChild("Survivors") and assets.Skins.Survivors:FindFirstChild("Guest1337")

			if guest1337 then
				for _, child in pairs(guest1337:GetChildren()) do
					if child:FindFirstChild("Config") then
						local ok, result = pcall(require, child.Config)
						if ok and result and result.DisplayName == attribute and result.Animations and result.Animations.Block then
							animationId = result.Animations.Block
							break
						end
					end
				end
			end
		end

		local animator2 = character:WaitForChild("Humanoid"):WaitForChild("Animator")
		local animation = Instance.new("Animation")
		animation.AnimationId = animationId
		local v13 = animator2:LoadAnimation(animation)

		if v13 then
			v13:Play()
		end
	end

	local v13 = Block:AddButton({ Name = "Fake Block", Callback = FAKEblock_FUNC })
	local v14 = Block:AddKeybind({ Name = "Fake Block Keybind", Callback = FAKEblock_FUNC })
	local flag4 = false
	local button = nil

	createMobileFakeBlockButton = function()
		if flag4 then
			return
		end

		local v15 = fn7({
			name = "MobileFakeBlock",
			text = "BLOCK",
			position = UDim2.new(0.8, 0, 0.6, 0),
			backgroundColor3 = Color3.fromRGB(30, 30, 30),
			borderColor3 = Color3.fromRGB(255, 120, 0),
			onClick = FAKEblock_FUNC,
			onClose = function()
				flag4 = false
				button = nil
				tbl.MobileFakeBlockEnabled = false
			end,
		})

		if v15 then
			button = v15.button
			flag4 = true
		end
	end

	local v15 = Block:AddToggle({
		Name = "Mobile Fake Block Button",
		Default = tbl.MobileFakeBlockEnabled,
		Callback = function(mobileFakeBlockEnabled)
			tbl.MobileFakeBlockEnabled = mobileFakeBlockEnabled

			if mobileFakeBlockEnabled and UserInputService.TouchEnabled then
				createMobileFakeBlockButton()
			elseif button and button.Parent then
				button.Text = "BLOCK"
			end
		end,
	})

	Block:AddList({
		Name = "Main Settings",
		Elems = { v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15 },
	})
end

do
	local tbl18 = {}

	for i, v4 in ipairs({
		{ "Speed Predict (Z-Expansion)", "SpeedPredict" },
		{ "Wall Check", "WallCheck" },
		{ "Vis Wall Check", "VisWallCheck" },
		{ "Facing Check", "FacingCheck" },
		{ "Vis Facing Check", "VisFacing" },
		{ "Anti Spin", "AntiSpin" },
		{ "Vis Anti Spin", "VisAntiSpin" },
	}) do
		tbl18[i] = Block:AddToggle({
			Name = v4[1],
			Default = tbl[v4[2]],
			Callback = function(arg)
				tbl[v4[2]] = arg
			end,
		})
	end

	local v4 = tbl18[2]
	local v5 = tbl18[3]
	local v6 = tbl18[4]
	local v7 = tbl18[5]
	local v8 = tbl18[6]
	local v9 = tbl18[7]

	Block:AddList({
		Name = "Anti Bait Protection",
		Elems = {
			tbl18[1],
			Block:AddSlider({
				Name = "Speed Predict Multiplier",
				Min = 0.1,
				Max = 2,
				Default = tbl.SpeedPredictMultiplier,
				Callback = function(speedPredictMultiplier)
					tbl.SpeedPredictMultiplier = speedPredictMultiplier
				end,
			}),
			v4,
			v5,
			v6,
			v7,
			v8,
			v9,
		},
	})
end

do
	local v4 = Block:AddToggle({
		Name = "Override Default Sizes",
		Callback = function(overrideHitboxSizes)
			tbl.OverrideHitboxSizes = overrideHitboxSizes
			fn20()
		end,
	})

	local v5 = Block:AddColorPicker({
		Name = "Outline Color",
		Default = color,
		Callback = function(outlineColor)
			color = outlineColor

			for _, v5 in pairs(tbl15) do
				local hitboxHighlight = v5:FindFirstChild("HitboxHighlight")

				if hitboxHighlight then
					hitboxHighlight.OutlineColor = outlineColor
				end
			end
		end,
	})

	local v6 = Block:AddSlider({
		Name = "Width (X) - Global",
		Min = 1,
		Max = 20,
		Default = vector.X,
		Callback = function(arg)
			vector = Vector3.new(arg, vector.Y, vector.Z)

			if tbl.OverrideHitboxSizes then
				fn20()
			end
		end,
	})

	local v7 = Block:AddSlider({
		Name = "Height (Y) - Global",
		Min = 1,
		Max = 20,
		Default = vector.Y,
		Callback = function(arg)
			vector = Vector3.new(vector.X, arg, vector.Z)

			if tbl.OverrideHitboxSizes then
				fn20()
			end
		end,
	})

	local v8 = Block:AddSlider({
		Name = "Length (Z) - Global",
		Min = 1,
		Max = 20,
		Default = vector.Z,
		Callback = function(arg)
			vector = Vector3.new(vector.X, vector.Y, arg)

			if tbl.OverrideHitboxSizes then
				fn20()
			end
		end,
	})

	Block:AddList({ Name = "HitBox Settings", Elems = { v4, v5, v6, v7, v8 } })
end

do
	local v4 = Block:AddToggle({
		Name = "Hitbox Dragging Tech",
		CurrentValue = flag2,
		Callback = function(arg)
			flag2 = arg

			if arg then
				fn19()

				HDT_CharAddedConn = localPlayer.CharacterAdded:Connect(function()
					task.wait(0.5)
					fn19()
				end)
			else
				if connection3 then
					connection3:Disconnect()
					connection3 = nil
				end

				if HDT_CharAddedConn then
					HDT_CharAddedConn:Disconnect()
					HDT_CharAddedConn = nil
				end

				flag3 = false
			end
		end,
	})

	local v5 = Block:AddSlider({
		Name = "Dragging Speed",
		Min = 5,
		Max = 20,
		Default = n2,
		Callback = function(arg)
			n2 = arg
		end,
	})

	local v6 = Block:AddSlider({
		Name = "Start Delay (Seconds)",
		Min = 0,
		Max = 2,
		Default = n3,
		Callback = function(arg)
			n3 = arg
		end,
	})

	Block:AddList({ Name = "Hitbox Dragging", Elems = { v4, v5, v6 } })
end

do
	local flag4 = false

	local function fn21()
		local character = localPlayer.Character
		character = character and character:FindFirstChildOfClass("Humanoid")
		character = character and character:FindFirstChildOfClass("Animator")
		if not character then
			return false
		end

		for _, v4 in ipairs(character:GetPlayingAnimationTracks()) do
			local animation = v4.Animation
			animation = animation and animation.AnimationId:match("%d+$")
			if animation and tbl2.GuestPunchAnim[animation] then
				return true
			end
		end

		return false
	end

	local function fn22()
		local v4 = fn3()
		if not v4 or not killers then
			return false
		end

		for _, v5 in ipairs(forsakenFK.Roster.killers()) do
			local humanoidRootPart = v5:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart then
				humanoidRootPart = (humanoidRootPart.Position - v4.Position).Magnitude < (tbl.AutoPunchStuds or 15)
			end

			if humanoidRootPart then
				return true
			end
		end

		return false
	end

	local function fn23()
		fn6("Punch")

		task.spawn(function()
			fn12("Punch", tbl.AutoPunch_method)
			task.wait(0.45)
			fn11("Punch")
		end)
	end

	ManageCombatLoop = function()
		if not tbl.AutoParry and not tbl.AnimCheck then
			flag4 = false
			fn11("Punch")
			return
		end

		if flag4 then
			return
		end
		flag4 = true
		task.spawn(function(...) end)
	end
end

do
	local v4 = Block:AddDropdown({
		Name = "Aim method",
		Options = { "HumanoidRoot Lock", "HumanoidRoot Lock + Camera Lock" },
		Default = tbl.AutoPunch_method,
		Callback = function(autoPunchMethod)
			tbl.AutoPunch_method = autoPunchMethod
		end,
	})

	local v5 = Block:AddToggle({
		Name = "Auto Parry",
		Callback = function(autoParry)
			tbl.AutoParry = autoParry
			ManageCombatLoop()
		end,
	})

	local v6 = Block:AddToggle({
		Name = "Aim On Punch",
		Description = "Aim activates only when you punch manually",
		Callback = function(animCheck)
			tbl.AnimCheck = animCheck
			ManageCombatLoop()
		end,
	})

	local v7 = Block:AddSlider({
		Name = "Auto Parry Studs",
		Min = 5,
		Max = 20,
		Default = tbl.AutoPunchStuds,
		Callback = function(autoPunchStuds)
			tbl.AutoPunchStuds = autoPunchStuds
		end,
	})

	local v8 = Block:AddSlider({
		Name = "Parry Delay (ms)",
		Min = 0,
		Max = 1000,
		Callback = function(punchDelay)
			tbl.PunchDelay = punchDelay
		end,
	})

	Block:AddList({ Name = "Auto Parry", Elems = { v4, v5, v6, v7, v8 } })
end

do
	local flag4 = false
	local connection4 = nil
	local connection5 = nil
	local humanoid = nil
	local humanoidRootPart = nil

	local function fn21(character)
		humanoid = character:WaitForChild("Humanoid")
		humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	end

	local function fn22()
		if not humanoidRootPart or not killers then
			return nil
		end
		local huge = math.huge
		local v4 = nil

		for _, v5 in ipairs(forsakenFK.Roster.killers()) do
			local humanoidRootPart2 = v5:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart2 then
				local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude

				if magnitude < huge then
					huge = magnitude
					v4 = humanoidRootPart2
				end
			end
		end

		return v4
	end

	local function fn23(...) end

	local function fn24()
		if tbl.ChargeControl or tbl.ChargeAim then
			if localPlayer.Character then
				fn21(localPlayer.Character)
			end

			if not connection5 then
				connection5 = localPlayer.CharacterAdded:Connect(fn21)
			end

			if not connection4 then
				connection4 = RunService.RenderStepped:Connect(fn23)
			end
		else
			if connection4 then
				connection4:Disconnect()
				connection4 = nil
			end

			if connection5 then
				connection5:Disconnect()
				connection5 = nil
			end

			if flag4 and humanoid then
				humanoid.AutoRotate = true
				humanoid:Move(Vector3.zero)
			end

			flag4 = false
			humanoid = nil
			humanoidRootPart = nil
		end
	end

	local v4 = Block:AddToggle({
		Name = "Charge Control",
		Callback = function(chargeControl)
			tbl.ChargeControl = chargeControl
			fn24()
		end,
	})

	local v5 = Block:AddToggle({
		Name = "Charge Aim",
		Callback = function(chargeAim)
			tbl.ChargeAim = chargeAim
			fn24()
		end,
	})

	Block:AddList({ Name = "Charge", Elems = { v4, v5 } })
end

do
	local flag4 = false
	local color2 = Color3.new(1, 0, 0)
	local color3 = Color3.new(0, 1, 0)
	local tbl18 = {}
	local tbl19 = {}
	local tbl20 = {}
	local connection4 = nil

	forsakenFK.sounds.on(function(arg)
		if not arg or not arg.IsPlaying then
			return
		end

		if fn18(arg.SoundId) and tbl2.AutoBlockTriggerSounds[fn18(arg.SoundId)] then
			local model = arg:FindFirstAncestorOfClass("Model")

			if model and model.Parent and model.Parent.Name == "Killers" then
				tbl19[model] = tick() + 0.55
			end
		end
	end)

	local function fn21()
		for _, v4 in ipairs(tbl20) do
			pcall(function()
				v4:Disconnect()
			end)
		end

		table.clear(tbl20)

		for _, v4 in pairs(tbl18) do
			if v4 and v4.Parent then
				pcall(function()
					v4:Destroy()
				end)
			end
		end

		table.clear(tbl18)
		table.clear(tbl19)

		if connection4 then
			connection4:Disconnect()
			connection4 = nil
		end

		if not flag4 then
			return
		end
		connection4 = RunService.Heartbeat:Connect(function(...) end)

		if killers then
			table.insert(tbl20, killers.ChildRemoved:Connect(function(child)
				if tbl18[child] then
					pcall(function()
						tbl18[child]:Destroy()
					end)

					tbl18[child] = nil
				end

				tbl19[child] = nil
			end))
		end
	end

	Block:AddToggle({
		Name = "Enable Attack Visualizer (Legit)",
		Default = flag4,
		Callback = function(arg)
			flag4 = arg
			fn21()
		end,
	})
end

do
	local connection4 = nil
	local screenGui = nil

	local function fn21(arg)
		if not arg then
			if connection4 then
				connection4:Disconnect()
				connection4 = nil
			end

			if screenGui then
				screenGui:Destroy()
				screenGui = nil
			end

			return
		end

		if screenGui then
			return
		end
		screenGui = Instance.new("ScreenGui", CoreGui)
		local v4 = screenGui
		screenGui.Name = "PingChecker"
		v4.ResetOnSpawn = false
		local frame = Instance.new("Frame", screenGui)
		local udim2 = UDim2.new(0, 140, 0, 45)
		local udim22 = UDim2.new(1, -160, 0, 20)
		local color2 = Color3.fromRGB(15, 15, 15)
		frame.Size = udim2
		frame.Position = udim22
		frame.BackgroundColor3 = color2
		frame.BackgroundTransparency = 0.1
		frame.BorderSizePixel = 0
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
		Instance.new("UIStroke", frame).Color = Color3.fromRGB(10, 200, 80)
		local textLabel = Instance.new("TextLabel", frame)
		local udim23 = UDim2.new(1, 0, 1, 0)
		local color3 = Color3.fromRGB(30, 230, 110)
		local gothamBold = Enum.Font.GothamBold
		textLabel.Size = udim23
		textLabel.BackgroundTransparency = 1
		textLabel.TextColor3 = color3
		textLabel.TextSize = 20
		textLabel.Font = gothamBold
		connection4 = RunService.Heartbeat:Connect(function(...) end)
	end

	Block:AddToggle({
		Name = "Show Ping Checker",
		Callback = function(arg)
			fn21(arg)
		end,
	})
end

task.wait()
local Survivors
Survivors = Main:AddTab("Survivors", "Survivor")
local fn21

fn21 = function()
end

do
	local tbl18 = {
		AutoLMS = false,
		AutoInvis = false,
		LMSConnections = {},
		InvisConnections = {},
		Zero007Ability = "c00lgui",
	}

	local function fn22()
		if not tbl18.AutoLMS then
			return
		end
		local children = workspace.Players.Survivors:GetChildren()
		if #children ~= 1 then
			return
		end
		local v4 = children[1]

		if v4.Name == "007n7" then
			fn6(tbl18.Zero007Ability)
		elseif v4.Name == "Noob" then
			fn6("Ghostburger")
		end
	end

	local function fn23()
		if next(tbl18.LMSConnections) then
			return
		end
		tbl18.LMSConnections.Added = workspace.Players.Survivors.ChildAdded:Connect(fn22)
		tbl18.LMSConnections.Removed = workspace.Players.Survivors.ChildRemoved:Connect(fn22)
	end

	local function fn24()
		for _, lmsConnection in pairs(tbl18.LMSConnections) do
			lmsConnection:Disconnect()
		end

		table.clear(tbl18.LMSConnections)
	end

	local v4 = Survivors:AddToggle({
		Name = "LMS auto ability",
		Description = "Noob, 007n7",
		Callback = function(autoLMS)
			tbl18.AutoLMS = autoLMS

			if autoLMS then
				fn23()
				fn22()
			else
				fn24()
			end
		end,
	})

	local v5 = Survivors:AddDropdown({
		Name = "007n7 ability",
		Options = { "Clone", "c00lgui" },
		Default = "c00lgui",
		Callback = function(zero007Ability)
			tbl18.Zero007Ability = zero007Ability
		end,
	})

	local function fn25(character)
		if not character then
			return
		end

		if tbl18.InvisConnections.Attribute then
			tbl18.InvisConnections.Attribute:Disconnect()
			tbl18.InvisConnections.Attribute = nil
		end

		tbl18.InvisConnections.Attribute = character:GetAttributeChangedSignal("Undetectable"):Connect(function()
			if fn10() == "Killers" then
				return
			end

			if not tbl18.AutoInvis then
				return
			end
			tbl.Invisibility = character:GetAttribute("Undetectable") == true
			fn13()
		end)

		if tbl18.AutoInvis then
			tbl.Invisibility = character:GetAttribute("Undetectable") == true
			fn13()
		end
	end

	local function fn26(autoInvis)
		tbl18.AutoInvis = autoInvis

		if autoInvis then
			if localPlayer.Character then
				fn25(localPlayer.Character)
			end

			tbl18.InvisConnections.CharacterAdded = localPlayer.CharacterAdded:Connect(fn25)
		else
			for k, invisConnection in pairs(tbl18.InvisConnections) do
				invisConnection:Disconnect()
				tbl18.InvisConnections[k] = nil
			end

			tbl.Invisibility = false
			fn13()
		end
	end

	local v6 = Survivors:AddToggle({
		Name = "Auto Invis when ability (Rage)",
		Callback = function(arg)
			fn26(arg)
		end,
	})

	Survivors:AddList({ Name = "Auto undetect", Elems = { v5, v4, v6 } })
end

do
	local tbl18 = {
		Play = function()
		end,
		Stop = function()
		end,
		AdjustSpeed = function()
		end,
		Length = 1,
	}

	local tbl19 = {
		Shoot = false,
		Punch = false,
		Block = false,
		Cola = false,
		Sentry = false,
		Dispenser = false,
		Crystal = false,
		Axe = false,
	}

	local function fn22(arg, arg2, arg3)
		if not arg.Animations then
			return
		end

		if not arg._realAnims then
			arg._realAnims = {}

			for k, animation in pairs(arg.Animations) do
				arg._realAnims[k] = animation
			end
		end

		if arg3 then
			for _, v4 in ipairs(arg2) do
				if arg.Animations[v4] then
					arg.Animations[v4] = tbl18
				end
			end
		else
			for k, realAnim in pairs(arg._realAnims) do
				arg.Animations[k] = realAnim
			end
		end
	end

	local function fn23(arg, arg2)
		if tbl19[arg2] then
			return
		end

		local ok, result = pcall(function()
			return require(arg)
		end)

		if ok and type(result) == "table" and result.Abilities and result.Abilities[arg2] then
			local callback = result.Abilities[arg2].Callback
			if type(callback) ~= "function" then
				return
			end
			local v4 = hookfunction(callback, function(...) end)

			if type(v4) == "function" then
				tbl19[arg2] = true
			end
		end
	end

	local behavior = nil

	pcall(function()
		behavior = assets.Survivors.Guest1337.Behavior
	end)

	local v4 = Survivors:AddToggle({
		Name = "Ghost Punch",
		Callback = function(ghostPunch)
			tbl.GhostPunch = ghostPunch

			if ghostPunch then
				fn23(behavior, "Punch", { "Punch", "ParryPunch" }, "GhostPunch")
			end
		end,
	})

	local v5 = Survivors:AddToggle({
		Name = "Ghost Block",
		Callback = function(ghostBlock)
			tbl.GhostBlock = ghostBlock

			if ghostBlock then
				fn23(behavior, "Block", { "Block" }, "GhostBlock")
			end
		end,
	})

	local behavior2 = nil

	pcall(function()
		behavior2 = assets.Survivors.JaneDoe.Behavior
	end)

	local v6 = Survivors:AddToggle({
		Name = "Ghost Crystal Pitch",
		Callback = function(ghostCrystalPitch)
			tbl.GhostCrystalPitch = ghostCrystalPitch

			if behavior2 then
				fn23(behavior2, "Crystal", { "CrystalThrowCharge", "CrystalThrow" }, "GhostCrystalPitch")
			end
		end,
	})

	local v7 = Survivors:AddToggle({
		Name = "Ghost Hatchet",
		Callback = function(ghostHatchet)
			tbl.GhostHatchet = ghostHatchet

			if behavior2 then
				fn23(behavior2, "Axe", { "Axe" }, "GhostHatchet")
			end
		end,
	})

	local behavior3 = nil

	pcall(function()
		behavior3 = assets.Survivors.Chance.Behavior
	end)

	local v8 = Survivors:AddToggle({
		Name = "Ghost Shoot",
		Callback = function(ghostShoot)
			tbl.GhostShoot = ghostShoot

			if ghostShoot then
				fn23(behavior3, "Shoot", { "AimGun", "GunFire", "GunExplode", "GunFail" }, "GhostShoot")
			end
		end,
	})

	Survivors:AddList({ Name = "Ghost abilities", Elems = { v4, v5, v6, v7, v8 } })
	local flag4 = false
	local v9 = nil
	local v10 = nil

	local function fn24()
		return localPlayer:GetAttribute("Device") == "Mobile" or UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	end

	local function fn25(arg)
		local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return nil
		end
		arg = arg or math.huge
		local v11 = nil

		for _, child in ipairs(killers:GetChildren()) do
			local humanoidRootPart2 = child:FindFirstChild("HumanoidRootPart")
			local humanoid = child:FindFirstChild("Humanoid")

			if humanoidRootPart2 and humanoid and humanoid.Health > 0 then
				local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude

				if magnitude < arg then
					arg = magnitude
					v11 = humanoidRootPart2
				end
			end
		end

		return v11
	end

	local function fn26()
		if flag4 then
			return
		end
		local ok, result = pcall(require, behavior2)

		if ok and type(result) == "table" then
			if result.Abilities and result.Abilities.Crystal then
				v9 = hookfunction(result.Abilities.Crystal.Callback, function(...) end)
			end

			if result.Abilities and result.Abilities.Axe then
				v10 = hookfunction(result.Abilities.Axe.Callback, function(...) end)
			end

			flag4 = true
		end
	end

	local v11 = Survivors:AddToggle({
		Name = "Infinite Crystal Hold",
		Callback = function(janeInfHold)
			tbl.JaneInfHold = janeInfHold
			fn26()
		end,
	})

	local v12 = Survivors:AddToggle({
		Name = "Instant max Charge Crystal",
		Callback = function(janeAutoMaxCharge)
			tbl.JaneAutoMaxCharge = janeAutoMaxCharge
			fn26()
		end,
	})

	local v13 = Survivors:AddDropdown({
		Name = "Jane Doe Aim Method",
		Options = { "HumanoidRoot Lock", "Camera Lock", "HumanoidRoot Lock + Camera Lock" },
		Default = "HumanoidRoot Lock + Camera Lock",
		Callback = function(janeAimMethod)
			tbl.JaneAimMethod = janeAimMethod
		end,
	})

	local v14 = Survivors:AddToggle({
		Name = "Crystal Pitch Aimbot",
		Callback = function(janeCrystalAim)
			tbl.JaneCrystalAim = janeCrystalAim

			if janeCrystalAim then
				fn21()
			elseif tbl4.CrystalAim then
				tbl4.CrystalAim:Disconnect()
				tbl4.CrystalAim = nil
			end
		end,
	})

	local v15 = Survivors:AddToggle({
		Name = "Hatchet Aimbot",
		Callback = function(janeAxeAim)
			tbl.JaneAxeAim = janeAxeAim

			if janeAxeAim then
				fn26()
			end
		end,
	})

	Survivors:AddList({ Name = "Jane Doe", Elems = { v11, v12, v13, v14, v15 } })
end

do
	local n6 = 0
	local connection4 = nil
	local flag4 = false
	local v4 = nil
	local v5 = nil

	local function fn22(arg)
		local huge = tbl.PizzaTargetLowestHP and math.huge or math.huge
		local v6 = nil

		for _, child in ipairs(survivors:GetChildren()) do
			if child ~= arg then
				local humanoidRootPart = child:FindFirstChild("HumanoidRootPart")
				local humanoid = child:FindFirstChild("Humanoid")

				if humanoidRootPart and humanoid and humanoid.Health > 0 then
					local magnitude = (arg.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude

					if magnitude <= 50 then
						if tbl.PizzaTargetLowestHP then
							local n7 = humanoid.Health / humanoid.MaxHealth

							if n7 < huge then
								huge = n7
								v6 = humanoidRootPart
							end
						elseif magnitude < huge then
							huge = magnitude
							v6 = humanoidRootPart
						end
					end
				end
			end
		end

		return v6
	end

	local v6 = nil

	local function fn23(arg)
		if arg then
			if not v4 then
				local ok, result = pcall(function()
					return require(ReplicatedStorage.Assets.Survivors.Elliot.Behavior)
				end)

				if ok and result then
					v4 = result
				end
			end

			if v4 and v4.Abilities and v4.Abilities.ThrowPizza and v4.Abilities.ThrowPizza.Callback then
				if not v6 then
					v6 = hookfunction(v4.Abilities.ThrowPizza.Callback, function(...) end)
				end
			end
		else
			v5 = nil
		end
	end

	local function fn24()
		if connection4 then
			connection4:Disconnect()
		end

		connection4 = RunService.RenderStepped:Connect(function(...) end)
	end

	local function fn25()
		if connection4 then
			connection4:Disconnect()
			connection4 = nil
		end
	end

	local function fn26()
		if flag4 then
			return
		end
		flag4 = true

		task.spawn(function()
			while flag4 do
				local character = localPlayer.Character

				if character and character.Name == "Elliot" then
					pcall(function()
						local v7 = firesignal
						local onClientEvent = remoteEvent.OnClientEvent
						local tbl18 = {}
						local v8 = buffer.fromstring("\3\5\0\0\0Speed")

						local tbl19 = {
							Removed = buffer.fromstring("\0"),
							Data = {
								NoStack = { buffer.fromstring("\3\r\0\0\0HitSpeedBonus") },
								MaxLevel = buffer.fromstring("\2\0\0\0\0\0\0$@"),
								Description = buffer.fromstring("\3Q\0\0\0Increases your movement speed.\nEvery level of this status increases speed by 10%."),
								Duration = buffer.fromstring("\2\0\0\0\0\0\0\8@"),
								Stackable = buffer.fromstring("\1\0"),
								Level = buffer.fromstring("\2\0\0\0\0\0\0\8@"),
							},
							Character = character,
							Player = localPlayer,
							TimePast = buffer.fromstring("\2\0\0\0\0\0\0\0\0"),
							Applied = buffer.fromstring("\0"),
							Level = buffer.fromstring("\2\0\0\0\0\0\0\8@"),
							AppliedFrom = buffer.fromstring("\3\4\0\0\0None"),
							TimeRequired = buffer.fromstring("\2\0\0\0\0\0\0\8@"),
						}

						local tbl20 = {
							NoStack = { buffer.fromstring("\3\r\0\0\0HitSpeedBonus") },
							MaxLevel = buffer.fromstring("\2\0\0\0\0\0\0$@"),
							Description = buffer.fromstring("\3Q\0\0\0Increases your movement speed.\nEvery level of this status increases speed by 10%."),
							Duration = buffer.fromstring("\2\0\0\0\0\0\0\8@"),
							Stackable = buffer.fromstring("\1\0"),
							Level = buffer.fromstring("\2\0\0\0\0\0\0\8@"),
						}

						tbl18[1] = v8
						tbl18[2] = tbl19
						tbl18[3] = tbl20
						v7(onClientEvent, 3, tbl18)
					end)
				end

				local rushHourCD = tbl.RushHourCD
				task.wait(rushHourCD > 0 and rushHourCD or 3)
			end
		end)
	end

	local function fn27()
		flag4 = false
	end

	local v7 = Survivors:AddToggle({
		Name = "Pizza Aimbot",
		Callback = function(pizzaAimbot)
			tbl.PizzaAimbot = pizzaAimbot
			fn23(pizzaAimbot)

			if pizzaAimbot then
				fn24()
			else
				fn25()
			end
		end,
	})

	local v8 = Survivors:AddToggle({
		Name = "Target Lowest HP",
		Callback = function(pizzaTargetLowestHP)
			tbl.PizzaTargetLowestHP = pizzaTargetLowestHP
		end,
	})

	local v9 = Survivors:AddDropdown({
		Name = "Lock mode",
		Options = { "HumanoidRoot Lock", "Camera Lock", "HumanoidRoot Lock + Camera Lock" },
		Default = tbl.PizzaLockMode,
		Callback = function(pizzaLockMode)
			tbl.PizzaLockMode = pizzaLockMode
		end,
	})

	local v10 = Survivors:AddSlider({
		Name = "Extra Prediction (Ping)",
		Min = 0,
		Max = 2,
		Default = tbl.PizzaPrediction,
		Callback = function(pizzaPrediction)
			tbl.PizzaPrediction = pizzaPrediction
		end,
	})

	local v11 = Survivors:AddSlider({
		Name = "Smoothness",
		Min = 0.1,
		Max = 1,
		Default = tbl.PizzaSmoothness,
		Callback = function(pizzaSmoothness)
			tbl.PizzaSmoothness = pizzaSmoothness
		end,
	})

	local v12 = Survivors:AddSlider({
		Name = "Pizza Speed (Calculate Aim)",
		Min = 40,
		Max = 150,
		Default = tbl.PizzaSpeed or 80,
		Callback = function(pizzaSpeed)
			tbl.PizzaSpeed = pizzaSpeed
		end,
	})

	local v13 = Survivors:AddToggle({
		Name = "Inf Rush Hour (Local Buff)",
		Callback = function(infRushHour)
			tbl.InfRushHour = infRushHour

			if infRushHour then
				fn26()
			else
				fn27()
			end
		end,
	})

	local v14 = Survivors:AddInput({
		Name = "Rush Hour Apply Rate (sec)",
		Default = tostring(tbl.RushHourCD),
		SaveUserText = true,
		Callback = function(arg)
			tbl.RushHourCD = tonumber(arg) or 3
		end,
	})

	Survivors:AddList({ Name = "Elliot", Elems = { v7, v8, v9, v10, v11, v12, v13, v14 } })
end

local tbl18
tbl18 = { Enabled = false, Distance = 7, Target = "Killer", Behavior = "Normal", Prediction = 15 }

local function fn22(arg)
	local v4 = Workspace.Players:FindFirstChild(arg)
	local tbl19 = {}

	if v4 then
		for _, child in ipairs(v4:GetChildren()) do
			local humanoidRootPart = child:FindFirstChild("HumanoidRootPart")
			local humanoid = child:FindFirstChild("Humanoid")

			if humanoidRootPart and humanoid and humanoid.Health > 0 then
				table.insert(tbl19, child)
			end
		end
	end

	return tbl19
end

getTarget = function()
	if tbl18.Target == "Yourself" then
		return localPlayer.Character
	end

	if tbl18.Target == "Killer" then
		return fn22("Killers")[1]
	end
	local Survivors2 = fn22("Survivors")
	if tbl18.Target == "Survivor" then
		return Survivors2[1]
	end

	if tbl18.Target == "Nearest Survivor" then
		local character = localPlayer.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") then
			return nil
		end
		local position = character.HumanoidRootPart.Position
		local huge = math.huge
		local v4 = nil

		for _, v5 in ipairs(Survivors2) do
			if v5 ~= character then
				local magnitude = (v5.HumanoidRootPart.Position - position).Magnitude

				if magnitude < huge then
					huge = magnitude
					v4 = v5
				end
			end
		end

		return v4
	end

	if tbl18.Target == "Lowest HP" then
		local v4, v5, v6 = ipairs(Survivors2)
		local huge = math.huge
		local v7 = nil

		for _, v8 in v4, v5, v6 do
			local health = v8.Humanoid.Health

			if health < huge then
				huge = health
				v7 = v8
			end
		end

		return v7
	end

	return nil
end

calculateBehaviorPosition = function(arg)
	local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return nil
	end
	local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
	local unit = assemblyLinearVelocity.Magnitude > 1 and assemblyLinearVelocity.Unit or humanoidRootPart.CFrame.LookVector
	local n6 = humanoidRootPart.Position + assemblyLinearVelocity * tbl18.Prediction / 100
	local distance = tbl18.Distance
	local now = tick()
	if tbl18.Behavior == "Normal" then
		return n6
	end

	if tbl18.Behavior == "Front" then
		return n6 + unit * distance
	end

	if tbl18.Behavior == "Back" then
		return n6 - unit * distance
	end

	if tbl18.Behavior == "Orbit" then
		return n6 + Vector3.new(math.sin(now * 4) * distance, 0, math.cos(now * 4) * distance)
	end

	if tbl18.Behavior == "Strafe" then
		return n6 + unit * distance + humanoidRootPart.CFrame.RightVector * math.sin(now * 6) * distance / 1.5
	end

	if tbl18.Behavior == "Run Away" then
		local character = localPlayer.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			local humanoidRootPart2 = character.HumanoidRootPart
			return humanoidRootPart2.Position + humanoidRootPart2.CFrame.LookVector * distance * 1.5
		end
		return n6
	end

	return n6
end

do
	local v4 = Survivors:AddToggle({
		Name = "BodyBlock Enabled",
		Callback = function(enabled)
			tbl18.Enabled = enabled

			if enabled then
				fn21()
			end
		end,
	})

	local v5 = Survivors:AddDropdown({
		Name = "BodyBlock Target",
		Options = { "Yourself", "Killer", "Survivor", "Nearest Survivor", "Lowest HP" },
		Callback = function(target)
			tbl18.Target = target
		end,
	})

	local v6 = Survivors:AddDropdown({
		Name = "BodyBlock Behavior",
		Options = { "Normal", "Orbit", "Front", "Back", "Run Away", "Strafe" },
		Callback = function(behavior)
			tbl18.Behavior = behavior
		end,
	})

	local v7 = Survivors:AddSlider({
		Name = "BodyBlock Prediction",
		Min = 0,
		Max = 30,
		Default = 15,
		Callback = function(prediction)
			tbl18.Prediction = prediction
		end,
	})

	Survivors:AddList({ Name = "007n7", Elems = { v4, v5, v6, v7 } })
end

do
	local behavior = nil
	local module = nil
	local Util = nil

	pcall(function()
		behavior = ReplicatedStorage.Assets.Survivors.Veeronica.Behavior
		module = require(behavior)
		Util = require(ReplicatedStorage.Modules.Utilities.Util)
	end)

	local function fn23(arg, arg2)
		if module then
			module[arg] = arg2
		end

		for _, v4 in pairs(getgc(true)) do
			if type(v4) == "table" and rawget(v4, "DisplayName") == "Veeronica" then
				v4[arg] = arg2
			end
		end
	end

	local function fn24(sk8TurnControl)
		module.Sk8TurnControl = sk8TurnControl

		for _, v4 in pairs(getgc(true)) do
			if type(v4) == "table" and rawget(v4, "Sk8TurnControl") then
				v4.Sk8TurnControl = sk8TurnControl
			end
		end
	end

	local thread = nil

	AutoTrick_FUNC = function()
		if thread then
			task.cancel(thread)
			thread = nil
		end

		if not tbl.AutoTrick then
			return
		end

		local function fn25()
			if not UserInputService.TouchEnabled or UserInputService.MouseEnabled then
				VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
				task.wait(0.05)
				VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
			else
				local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
				playerGui2 = playerGui2 and playerGui2:FindFirstChild("MainUI")
				local sprintingButton = playerGui2 and playerGui2:FindFirstChild("SprintingButton")

				if sprintingButton then
					local v4 = getconnections(sprintingButton.MouseButton1Down)
					local v5 = getconnections(sprintingButton.MouseButton1Up)
					local v6 = getconnections(sprintingButton.Activated)

					for _, v7 in pairs(v4) do
						v7:Fire()
					end

					task.wait(0.05)

					for _, v7 in pairs(v5) do
						v7:Fire()
					end

					for _, v7 in pairs(v6) do
						v7:Fire()
					end
				end
			end
		end

		thread = task.spawn(function(...) end)
	end

	local v4 = Survivors:AddToggle({
		Name = "Auto Trick",
		Callback = function(autoTrick)
			tbl.AutoTrick = autoTrick
			AutoTrick_FUNC()
		end,
	})

	local v5 = Survivors:AddToggle({
		Name = "Skate Control",
		Callback = function(veeronicaControl)
			tbl.VeeronicaControl = veeronicaControl
			fn24(veeronicaControl and 6.5 or 0.65)
		end,
	})

	local flag4 = false
	local flag5 = false

	local function fn25()
		if flag5 then
			return
		end
		flag5 = true
		forsakenFK.namecall.add(function(...) end)
	end

	local v6 = Survivors:AddToggle({
		Name = "Anti Rebound",
		Callback = function(arg)
			flag4 = arg

			if arg then
				fn25()
			end
		end,
	})

	local flag6 = false
	local flag7 = false

	local function fn26()
		if flag7 then
			return
		end
		flag7 = true
		RunService.Heartbeat:Connect(function(...) end)
	end

	local v7 = Survivors:AddToggle({
		Name = "Unlimited Sk8",
		Callback = function(arg)
			flag6 = arg

			if arg then
				fn26()
			end
		end,
	})

	local flag8 = false
	local flag9 = false

	local function fn27()
		if flag9 then
			return
		end
		flag9 = true

		task.spawn(function()
			while true do
				if flag8 then
					remoteEvent:FireServer(localPlayer.Name .. "SkateTrick", {})
					task.wait(0.5)
				else
					task.wait(0.1)
				end
			end
		end)
	end

	local v8 = Survivors:AddToggle({
		Name = "Auto Farm sk8",
		Callback = function(arg)
			flag8 = arg

			if arg then
				fn27()
			end
		end,
	})

	local flag10 = false

	local function fn28()
		if flag10 then
			fn23("Sk8Speed", tbl.Sk8Speed or 1.15)
			fn23("Sk8SpeedExhaust", tbl.Sk8Speed or 1.15)
			fn23("Sk8TrickAirborneSpeed", tbl.Sk8TrickAirborneSpeed or 1.42)
			fn23("Sk8BumpPower", tbl.Sk8BumpPower or 11.9)
			fn23("Sk8BumpChargedPower", tbl.Sk8BumpPower or 15)
			fn23("Sk8TrickStamina", tbl.Sk8TrickStamina or 10)
			fn23("Sk8TrickStaminaNerfed", tbl.Sk8TrickStamina or 4)
			fn23("Sk8TrickCooldown", tbl.Sk8TrickCooldown or 1)
		else
			fn23("Sk8Speed", 1.15)
			fn23("Sk8SpeedExhaust", 1.15)
			fn23("Sk8TrickAirborneSpeed", 1.42)
			fn23("Sk8BumpPower", 11.9)
			fn23("Sk8BumpChargedPower", 15)
			fn23("Sk8TrickStamina", 10)
			fn23("Sk8TrickStaminaNerfed", 4)
			fn23("Sk8TrickCooldown", 1)
		end
	end

	local v9 = Survivors:AddToggle({
		Name = "Enable Custom Stats",
		Callback = function(arg)
			flag10 = arg
			fn28()
		end,
	})

	local v10 = Survivors:AddSlider({
		Name = "Skate Speed",
		Min = 1,
		Max = 10,
		Default = 1.15,
		Decimals = 2,
		Callback = function(sk8Speed)
			tbl.Sk8Speed = sk8Speed

			if flag10 then
				fn23("Sk8Speed", sk8Speed)
				fn23("Sk8SpeedExhaust", sk8Speed)
			end
		end,
	})

	local v11 = Survivors:AddSlider({
		Name = "Trick Boost Speed",
		Min = 1,
		Max = 15,
		Default = 1.42,
		Decimals = 2,
		Callback = function(sk8TrickAirborneSpeed)
			tbl.Sk8TrickAirborneSpeed = sk8TrickAirborneSpeed

			if flag10 then
				fn23("Sk8TrickAirborneSpeed", sk8TrickAirborneSpeed)
			end
		end,
	})

	local v12 = Survivors:AddSlider({
		Name = "Bumper Knockback Power",
		Min = 10,
		Max = 150,
		Default = 11.9,
		Decimals = 1,
		Callback = function(sk8BumpPower)
			tbl.Sk8BumpPower = sk8BumpPower

			if flag10 then
				fn23("Sk8BumpPower", sk8BumpPower)
				fn23("Sk8BumpChargedPower", sk8BumpPower)
			end
		end,
	})

	local v13 = Survivors:AddSlider({
		Name = "Stamina Per Trick",
		Min = 0,
		Max = 100,
		Default = 4,
		Decimals = 0,
		Callback = function(sk8TrickStamina)
			tbl.Sk8TrickStamina = sk8TrickStamina

			if flag10 then
				fn23("Sk8TrickStamina", sk8TrickStamina)
				fn23("Sk8TrickStaminaNerfed", sk8TrickStamina)
			end
		end,
	})

	local v14 = Survivors:AddSlider({
		Name = "Trick Cooldown",
		Min = 0,
		Max = 5,
		Default = 1,
		Decimals = 1,
		Callback = function(sk8TrickCooldown)
			tbl.Sk8TrickCooldown = sk8TrickCooldown

			if flag10 then
				fn23("Sk8TrickCooldown", sk8TrickCooldown)
			end
		end,
	})

	local thread2 = nil
	local v15 = nil

	local function fn29(arg)
		if type(arg) ~= "table" then
			return
		end
		local sk8 = arg.Sk8
		if type(sk8) ~= "table" or sk8.__bypassed then
			return
		end
		local callback = sk8.Callback
		if type(callback) ~= "function" then
			return
		end
		sk8.__origCallback = callback
		sk8.__bypassed = true

		sk8.Callback = function(arg2, arg3)
			if arg3 == "BAD" then
				arg3 = nil
			end

			return callback(arg2, arg3)
		end
	end

	local function fn30(arg)
		if type(arg) ~= "table" then
			return
		end
		local sk8 = arg.Sk8
		if type(sk8) ~= "table" or not sk8.__bypassed then
			return
		end

		if sk8.__origCallback then
			sk8.Callback = sk8.__origCallback
			sk8.__origCallback = nil
		end

		sk8.__bypassed = nil
	end

	local function fn31()
		if not Util or type(Util.GetActor) ~= "function" then
			return nil
		end
		local ok, result = pcall(Util.GetActor, Util, localPlayer)
		if ok and type(result) == "table" then
			return result
		end
		return nil
	end

	local v16 = Survivors:AddToggle({
		Name = "Sk8 Everywhere (rage 100% ban)",
		Callback = function(arg)
			if arg then
				if module.Abilities then
					fn29(module.Abilities)
				end

				local v16 = fn31()

				if v16 then
					if v16.Behavior and v16.Behavior.Abilities then
						fn29(v16.Behavior.Abilities)
					end

					if v16.State then
						v16.State.InZone = true
					end
				end

				pcall(function()
					Util:ToggleLockForAbilityIcon("Sk8", "NoCharges", false)
				end)

				if thread2 then
					task.cancel(thread2)
					thread2 = nil
				end

				thread2 = task.spawn(function()
					while task.wait(0.5) do
						if module.Abilities then
							fn29(module.Abilities)
						end

						local v17 = fn31()

						if v17 then
							if v17.Behavior and v17.Behavior.Abilities then
								fn29(v17.Behavior.Abilities)
							end

							if v17.State then
								v17.State.InZone = true
							end
						end

						pcall(function()
							Util:ToggleLockForAbilityIcon("Sk8", "NoCharges", false)
						end)
					end
				end)
			else
				if thread2 then
					task.cancel(thread2)
					thread2 = nil
				end

				if module and module.Abilities then
					fn30(module.Abilities)
				end

				local v16 = fn31()

				if v16 and v16.Behavior and v16.Behavior.Abilities then
					fn30(v16.Behavior.Abilities)
				end

				if Util and v15 then
					Util.ToggleLockForAbilityIcon = v15
					v15 = nil
				end
			end
		end,
	})

	local thread3 = nil

	AutoPhase_FUNC = function()
		if thread3 then
			task.cancel(thread3)
			thread3 = nil
		end

		if not tbl.AutoPhase then
			return
		end
		local Network = nil

		pcall(function()
			Network = require(ReplicatedStorage.Modules.Network.Network)
		end)

		local flag11 = false

		thread3 = task.spawn(function()
			while task.wait(0.5) do
				if tbl.AutoPhase then
					if not Network then
						pcall(function()
							Network = require(ReplicatedStorage.Modules.Network.Network)
						end)
					end

					local character = localPlayer.Character
					local v17 = Network
					local flag12

					if Network then
						flag12 = character
					else
						flag12 = v17
					end

					flag12 = flag12 and character.Name == "Veeronica" and killers

					if flag12 then
						local flag13 = true

						if flag11 then
							local v18 = fn31()
							flag13 = v18 and v18.State and v18.State.isSkating
						end

						if flag13 then
							for _, child in ipairs(killers:GetChildren()) do
								if tbl.AutoPhase then
									local humanoid = child:FindFirstChildOfClass("Humanoid")

									if humanoid and humanoid.Health > 0 then
										pcall(function()
											Network:FireServerConnection(localPlayer.Name .. "SkatePhase", "REMOTE_EVENT", child)
										end)

										task.wait((module and module.Sk8PhaseTime or 3) + 0.6)
									end

									continue
								end

								break
							end
						end
					end

					continue
				end

				break
			end
		end)
	end

	Survivors:AddList({
		Name = "Veeronica",
		Elems = {
			v4,
			v5,
			v6,
			Survivors:AddToggle({
				Name = "Auto Phase",
				Callback = function(autoPhase)
					tbl.AutoPhase = autoPhase
					AutoPhase_FUNC()
				end,
			}),
			v8,
			v7,
			v16,
			v9,
			v10,
			v11,
			v12,
			v13,
			v14,
		},
	})
end

do
	local tbl19 = {
		Enabled = false,
		Type = "Teleport",
		LerpSpeed = 0.37,
		MaxDist = 8,
		BehindDist = 1.7,
		DelayStab = 0.08,
		Duration = 0.7,
		RangeMode = "Around",
		DirectBehind = false,
		Prediction = false,
		PredStrength = 0.6,
		PredTime = 0.12,
		GlideStab = false,
		GlideStabType = "Legit",
		AimingMode = "Character",
		TargetAnimID = "89448354637442",
		KillerNoclip = false,
	}

	local tbl20 = {}
	local flag4 = false
	local connection4 = nil
	local connection5 = nil

	local function fn23(arg)
		local mainUI = playerGui:FindFirstChild("MainUI")
		mainUI = mainUI and mainUI:FindFirstChild("AbilityContainer")
		mainUI = mainUI and mainUI:FindFirstChild(arg)
		if not mainUI then
			return false
		end
		local cooldownTime = mainUI:FindFirstChild("CooldownTime")
		local flag5

		if cooldownTime then
			flag5 = cooldownTime.Text == "" or cooldownTime.Text == " "
		else
			flag5 = cooldownTime
		end

		return flag5
	end

	local function fn24(arg)
		local humanoid = arg:FindFirstChildWhichIsA("Humanoid")
		if not humanoid then
			return false
		end

		for _, v4 in ipairs(humanoid:GetPlayingAnimationTracks()) do
			local animation = v4.Animation

			if animation then
				local targetAnimID = tbl19.TargetAnimID
				animation = string.find(tostring(v4.Animation.AnimationId), targetAnimID)
			end

			if animation then
				return true
			end
		end

		return false
	end

	local function fn25(arg, arg2)
		local magnitude = (arg.Position - arg2.Position).Magnitude
		if tbl19.RangeMode == "Around" then
			return magnitude <= tbl19.MaxDist
		end
		local n6 = arg.Position - arg2.Position
		local v4 = n6:Dot(arg2.CFrame.LookVector)
		local n7 = n6.Magnitude > 0 and n6.Unit:Dot(arg2.CFrame.LookVector) or 0
		return (tbl19.DirectBehind and n7 <= -0.85 or v4 < 0.3) and magnitude <= tbl19.MaxDist
	end

	local function fn26(...) end

	local function fn27(arg, arg2)
		local cFrame = arg2.CFrame
		local n6 = cFrame.Position - cFrame.LookVector.Unit * tbl19.BehindDist
		local vector2 = Vector3.new(n6.X, cFrame.Position.Y, n6.Z)
		if not tbl19.Prediction then
			return CFrame.new(vector2, vector2 + cFrame.LookVector.Unit)
		end
		local v4 = tbl20[arg2]
		local vel = v4 and v4.vel or arg2.Velocity or Vector3.zero
		local n7 = Vector3.new(vel.X, 0, vel.Z) * tbl19.PredTime * tbl19.PredStrength
		local lookVector = cFrame.LookVector
		local rightVector = cFrame.RightVector
		local n8 = lookVector * n7:Dot(lookVector)
		local n9 = rightVector * n7:Dot(rightVector)
		local prevLook = v4 and v4.prevLook
		local vector3 = Vector3.zero

		if prevLook then
			local n10 = lookVector - v4.prevLook
			local predStrength = tbl19.PredStrength
			vector3 = rightVector * n10:Dot(rightVector) * 3 * predStrength
		end

		local n10 = n8 + n9 + vector3
		local n11 = vector2 + Vector3.new(n10.X, 0, n10.Z)
		return CFrame.new(n11, n11 + cFrame.LookVector.Unit)
	end

	local function fn28(arg)
		flag4 = true
		arg.Humanoid.AutoRotate = false

		task.spawn(function()
			task.wait(tbl19.DelayStab)

			pcall(function()
				fn6("Dagger")
			end)
		end)

		os.clock()
		RunService.Heartbeat:Connect(function(...) end)
	end

	local function fn29(...) end

	local function fn30()
		local enabled = tbl19.Enabled or tbl19.GlideStab

		if enabled and not connection4 then
			connection5 = RunService.Heartbeat:Connect(fn26)
			connection4 = RunService.Heartbeat:Connect(fn29)
		elseif not enabled and connection4 then
			connection4:Disconnect()
			connection5:Disconnect()
			connection4 = nil
			connection5 = nil
			tbl20 = {}
		end
	end

	local tbl21 = {}

	local v4 = Survivors:AddToggle({
		Name = "Auto Backstab",
		Callback = function(enabled)
			tbl19.Enabled = enabled
			fn30()
		end,
	})

	local v5 = Survivors:AddDropdown({
		Name = "Backstab Type",
		Options = { "Teleport", "Lerp", "just auto stab (if its on)" },
		Default = "Teleport",
		Callback = function(type_)
			tbl19.Type = type_
		end,
	})

	local v6 = Survivors:AddSlider({
		Name = "Trigger Distance",
		Min = 3,
		Max = 30,
		Default = 8,
		Callback = function(maxDist)
			tbl19.MaxDist = maxDist
		end,
	})

	local v7 = Survivors:AddToggle({
		Name = "Enable Prediction",
		Callback = function(prediction)
			tbl19.Prediction = prediction
		end,
	})

	local v8 = Survivors:AddToggle({
		Name = "GlideStab",
		Callback = function(glideStab)
			tbl19.GlideStab = glideStab
			fn30()
		end,
	})

	local addToggle = Survivors.AddToggle
	tbl21[1] = v4
	tbl21[2] = v5
	tbl21[3] = v6
	tbl21[4] = v7
	tbl21[5] = v8

	do
		local values = table.pack(addToggle(Survivors, {
		Name = "Killer Noclip",
		Callback = function(killerNoclip)
			tbl19.KillerNoclip = killerNoclip
		end,
	}))

		table.move(values, 1, values.n, 6, tbl21)
	end

	Survivors:AddList({ Name = "Two Time", Elems = tbl21 })
end

do
	local connection4 = nil
	local thread = nil

	Auto_CoinFlip_FUNC = function()
		if connection4 then
			connection4:Disconnect()
			connection4 = nil
		end

		if thread then
			task.cancel(thread)
			thread = nil
		end

		local flag4 = false
		local charges = nil

		local function fn23()
			if thread then
				task.cancel(thread)
			end

			thread = task.spawn(function()
				while task.wait(1.85) do
					if tbl.AutoCoinFlip then
						if flag4 then
							if charges and charges.Text ~= "3" then
								fn6("CoinFlip")
							end

							continue
						end
					end

					break
				end
			end)
		end

		if tbl.AutoCoinFlip then
			if localPlayer.Character and localPlayer.Character.Name == "Chance" then
				flag4 = true
				charges = localPlayer.PlayerGui.MainUI.AbilityContainer.Shoot.Charges
				fn23()
			end

			connection4 = localPlayer.CharacterAdded:Connect(function(character)
				flag4 = false

				if thread then
					task.cancel(thread)
					thread = nil
				end

				if character.Name == "Chance" then
					flag4 = true
					task.wait(2)
					charges = Players:GetPlayerFromCharacter(character).PlayerGui.MainUI.AbilityContainer.Shoot.Charges
					fn23()
				end
			end)
		end
	end
end

do
	local connection4 = nil
	local connection5 = nil
	local connection6 = nil

	Shoot_Aim_helper_FUNC = function()
		local tbl19 = {}

		local ok, result = pcall(function()
			return require(assets.Survivors.Chance.Config)
		end)

		if not ok or not result then
			return
		end
		table.insert(tbl19, result.Animations.AimGun)
		local chance = assets.Skins.Survivors:FindFirstChild("Chance")

		if chance then
			for _, child in pairs(chance:GetChildren()) do
				if child:FindFirstChild("Config") then
					local Config = require(child.Config)

					if Config and Config.Animations then
						table.insert(tbl19, Config.Animations.AimGun)
					end
				end
			end
		end

		if connection4 then
			connection4:Disconnect()
			connection4 = nil
		end

		if connection5 then
			connection5:Disconnect()
			connection5 = nil
		end

		if connection6 then
			connection6:Disconnect()
			connection6 = nil
		end

		if not tbl.Shoot_Aim_helper then
			fn11("Shoot")
			return
		end

		local function fn23()
			local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")

			if humanoid then
				connection4 = humanoid.AnimationPlayed:Connect(function(arg)
					if arg.Animation and table.find(tbl19, arg.Animation.AnimationId) then
						task.spawn(function()
							if tbl.Shoot_360_Spin then
								if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
									tick()
									RunService.RenderStepped:Connect(function(...) end)
									task.wait(0.5)
								end
							end

							fn12("Shoot", tbl.Shoot_Aim_helper_method or "HumanoidRoot Lock")
							task.wait(tbl.Shoot_Aim_helper_look_loock)
							fn11("Shoot")
						end)
					end
				end)
			end
		end

		fn23()

		connection5 = localPlayer.CharacterAdded:Connect(function()
			task.wait(1)
			fn23()
		end)

		connection6 = localPlayer.CharacterRemoving:Connect(function()
			if connection4 then
				connection4:Disconnect()
				connection4 = nil
			end

			fn11("Shoot")
		end)
	end
end

do
	local flag4 = false
	local flag5 = false
	local n6 = 2
	local flag6 = false

	local function fn23()
		if flag6 then
			return
		end
		flag6 = true
		forsakenFK.namecall.add(function(...) end)
	end

	local tbl19 = {}

	local v4 = Survivors:AddDropdown({
		Name = "Aim method",
		Options = { "HumanoidRoot Lock", "HumanoidRoot Lock + Camera Lock" },
		Default = tbl.Shoot_Aim_helper_method,
		Callback = function(shootAimHelperMethod)
			tbl.Shoot_Aim_helper_method = shootAimHelperMethod
		end,
	})

	local v5 = Survivors:AddToggle({
		Name = "Shoot Aim helper",
		Callback = function(shootAimHelper)
			tbl.Shoot_Aim_helper = shootAimHelper
			Shoot_Aim_helper_FUNC()
		end,
	})

	local v6 = Survivors:AddSlider({
		Name = "Lock Aim (seconds)",
		Min = 1,
		Max = 2,
		Default = tbl.Shoot_Aim_helper_look_loock,
		Callback = function(shootAimHelperLookLoock)
			tbl.Shoot_Aim_helper_look_loock = shootAimHelperLookLoock
		end,
	})

	local v7 = Survivors:AddToggle({
		Name = "Shoot 360 Spin",
		Callback = function(shoot360Spin)
			tbl.Shoot_360_Spin = shoot360Spin
		end,
	})

	local v8 = Survivors:AddToggle({
		Name = "Auto Coin Flip",
		Callback = function(autoCoinFlip)
			tbl.AutoCoinFlip = autoCoinFlip
			Auto_CoinFlip_FUNC()
		end,
	})

	local v9 = Survivors:AddToggle({
		Name = "Chance Hitbox Storing",
		Callback = function(arg)
			flag5 = arg

			if arg then
				fn23()
			end
		end,
	})

	local addInput = Survivors.AddInput

	local tbl20 = {
		Name = "Storing Delay (seconds)",
		Default = tostring(n6),
		SaveUserText = true,
		Callback = function(arg)
			n6 = tonumber(arg) or 2
		end,
	}

	tbl19[1] = v4
	tbl19[2] = v5
	tbl19[3] = v6
	tbl19[4] = v7
	tbl19[5] = v8
	tbl19[6] = v9

	do
		local values = table.pack(addInput(Survivors, tbl20))
		table.move(values, 1, values.n, 7, tbl19)
	end

	Survivors:AddList({ Name = "Chance", Elems = tbl19 })
end

do
	local connection4 = nil
	local connection5 = nil
	local connection6 = nil
	local n6 = 0
	tbl.Auto_Slash_Delay = tbl.Auto_Slash_Delay or 0.1
	tbl.Auto_Slash_TP = tbl.Auto_Slash_TP or false
	tbl.Auto_Slash_TP_Dist = tbl.Auto_Slash_TP_Dist or 3.5

	Shedletsky_Auto_Slash_FUNC = function()
		if connection4 then
			connection4:Disconnect()
			connection4 = nil
		end

		if connection5 then
			connection5:Disconnect()
			connection5 = nil
		end

		if connection6 then
			connection6:Disconnect()
			connection6 = nil
		end

		if not tbl.Auto_Slash_Shad then
			if fn11 then
				fn11("Slash")
			end

			return
		end

		local cooldownTime = nil
		local flag4 = false

		local function fn23()
			connection6 = RunService.Heartbeat:Connect(function(...) end)
		end

		local function fn24()
			if connection6 then
				connection6:Disconnect()
				connection6 = nil
			end

			if fn11 then
				fn11("Slash")
			end
		end

		if localPlayer.Character and localPlayer.Character.Name == "Shedletsky" then
			cooldownTime = localPlayer.PlayerGui.MainUI.AbilityContainer.Slash.CooldownTime
			fn23()
		end

		connection4 = localPlayer.CharacterAdded:Connect(function(character)
			task.wait(0.5)

			if character.Name == "Shedletsky" then
				task.wait(1)
				cooldownTime = localPlayer.PlayerGui.MainUI.AbilityContainer.Slash.CooldownTime
				fn24()
				fn23()
			end
		end)

		connection5 = localPlayer.CharacterRemoving:Connect(function()
			fn24()
		end)
	end
end

do
	local tbl19 = {}

	local v4 = Survivors:AddToggle({
		Name = "Auto Slash",
		Callback = function(autoSlashShad)
			tbl.Auto_Slash_Shad = autoSlashShad
			Shedletsky_Auto_Slash_FUNC()
		end,
	})

	local v5 = Survivors:AddSlider({
		Name = "Auto Slash Delay",
		Min = 0,
		Max = 3,
		Default = tbl.Auto_Slash_Delay,
		Callback = function(autoSlashDelay)
			tbl.Auto_Slash_Delay = autoSlashDelay
		end,
	})

	local v6 = Survivors:AddSlider({
		Name = "Auto Slash Distance(studs)",
		Min = 1,
		Max = 30,
		Default = tbl.Auto_Slash_Shad_Dis,
		Callback = function(autoSlashShadDis)
			tbl.Auto_Slash_Shad_Dis = autoSlashShadDis
		end,
	})

	local v7 = Survivors:AddToggle({
		Name = "TP Slash (Teleport Behind)",
		Default = tbl.Auto_Slash_TP,
		Callback = function(autoSlashTp)
			tbl.Auto_Slash_TP = autoSlashTp
		end,
	})

	local addSlider = Survivors.AddSlider

	local tbl20 = {
		Name = "TP Behind Distance",
		Min = 1,
		Max = 10,
		Default = tbl.Auto_Slash_TP_Dist,
		Callback = function(autoSlashTpDist)
			tbl.Auto_Slash_TP_Dist = autoSlashTpDist
		end,
	}

	tbl19[1] = v4
	tbl19[2] = v5
	tbl19[3] = v6
	tbl19[4] = v7

	do
		local values = table.pack(addSlider(Survivors, tbl20))
		table.move(values, 1, values.n, 5, tbl19)
	end

	Survivors:AddList({ Name = "Shedletsky", Elems = tbl19 })
end

do
	local tbl19 = { isActive = false, oldIsOnScreen = nil, oldIsCharWithinRadius = nil, targetRadiusFunc = nil }

	local function fn23()
		local ok, result = pcall(function()
			return require(ReplicatedStorage.Modules.Utilities.Util)
		end)

		if not ok and modules then
			local util = modules:FindFirstChild("Util", true)

			if util then
				ok, result = pcall(require, util)
			end
		end

		local ok2, result2 = pcall(function()
			return require(assets.Survivors.Dusekkar.Behavior)
		end)

		if not ok2 then
			local dusekkar = assets.Survivors:FindFirstChild("Dusekkar")
			dusekkar = dusekkar and dusekkar:FindFirstChild("Behavior")

			if dusekkar then
				ok2, result2 = pcall(require, dusekkar)
			end
		end

		if not (ok and ok2 and result and result2) then
			return
		end

		if not tbl19.targetRadiusFunc then
			tbl19.targetRadiusFunc = debug.getupvalue(result2.Created, 3)
		end

		if not tbl19.isActive then
			tbl19.oldIsOnScreen = hookfunction(result.IsOnScreen, function()return true;end)
			tbl19.oldIsCharWithinRadius = hookfunction(tbl19.targetRadiusFunc, function()return true,0;end)
		else
			if tbl19.oldIsOnScreen then
				hookfunction(result.IsOnScreen, tbl19.oldIsOnScreen)
				tbl19.oldIsOnScreen = nil
			end

			if tbl19.oldIsCharWithinRadius then
				hookfunction(tbl19.targetRadiusFunc, tbl19.oldIsCharWithinRadius)
				tbl19.oldIsCharWithinRadius = nil
			end
		end

		tbl19.isActive = not tbl19.isActive
	end

	local flag4 = not UserInputService.MouseEnabled
	local target = "Killer"
	local flag5 = true
	local n6 = 0.2
	local tbl20 = { ["77894750279891"] = true, ["118933622288262"] = true }
	local tbl21 = { enabled = false, isUsingPlasmaBeam = false, conns = {} }

	local function fn24()
		if not tbl21.enabled then
			return nil
		end
		local character = localPlayer.Character
		if not character or not character.PrimaryPart then
			return nil
		end
		local currentCamera2 = workspace.CurrentCamera
		local tbl22 = {}

		if target ~= "Survivor" then
			for _, child in ipairs(killers:GetChildren()) do
				table.insert(tbl22, child)
			end
		end

		if target ~= "Killer" then
			for _, child in ipairs(survivors:GetChildren()) do
				table.insert(tbl22, child)
			end
		end

		local raycastParams2 = RaycastParams.new()
		raycastParams2.FilterType = Enum.RaycastFilterType.Blacklist
		raycastParams2.FilterDescendantsInstances = { character }
		raycastParams2.IgnoreWater = true
		local huge = math.huge
		local v4 = nil

		for _, v5 in ipairs(tbl22) do
			if not (v5.Name == "Dusekkar" and character.Name == "Dusekkar") then
				if v5 and v5.PrimaryPart then
					local v6, v7 = currentCamera2:WorldToViewportPoint(v5.PrimaryPart.Position)

					if v7 then
						local magnitude = (currentCamera2.CFrame.Position - v5.PrimaryPart.Position).Magnitude
						local n7 = v5.PrimaryPart.Position - currentCamera2.CFrame.Position

						if n7.Magnitude > 0.05 then
							local hit = workspace:Raycast(currentCamera2.CFrame.Position, n7.Unit * 500, raycastParams2)

							if hit and hit.Instance:IsDescendantOf(v5) and magnitude < huge then
								huge = magnitude
								v4 = v5
							end
						end
					end
				end
			end
		end

		return v4
	end

	local function fn25(arg, arg2)
		if not arg or not arg.PrimaryPart then
			return nil
		end
		local position = arg.PrimaryPart.Position
		if not flag5 or n6 <= 0 then
			return position
		end
		local vector2 = Vector3.new()

		if arg.PrimaryPart:IsA("BasePart") then
			vector2 = arg.PrimaryPart.Velocity
		end

		local humanoid = arg:FindFirstChildOfClass("Humanoid")

		if humanoid and humanoid.MoveDirection then
			vector2 += humanoid.MoveDirection * humanoid.WalkSpeed
		end

		local n7 = position + vector2 * (position - arg2).Magnitude / 500 * n6

		if arg.PrimaryPart.Velocity.Y < 0 then
			n7 += Vector3.new(0, -2 * n6, 0)
		end

		return n7
	end

	local function fn26()
		if not (tbl21.enabled and tbl21.isUsingPlasmaBeam) then
			return
		end
		local character = localPlayer.Character
		if not character or character.Name ~= "Dusekkar" then
			return
		end
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return
		end
		local v4 = fn24()
		if not v4 then
			return
		end
		local currentCamera2 = workspace.CurrentCamera
		local v5 = fn25(v4, currentCamera2.CFrame.Position)
		if not v5 then
			return
		end
		local n7 = v5 + Vector3.new(0, 1.5, 0)
		currentCamera2.CFrame = CFrame.new(currentCamera2.CFrame.Position, n7)
		humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, Vector3.new(n7.X, humanoidRootPart.Position.Y, n7.Z))
	end

	local function fn27(arg)
		local humanoid = arg:WaitForChild("Humanoid", 5)
		if not humanoid then
			return
		end
		local animator = humanoid:FindFirstChildOfClass("Animator")
		if not animator then
			return
		end

		if tbl21.conns.anim then
			tbl21.conns.anim:Disconnect()
		end

		tbl21.conns.anim = animator.AnimationPlayed:Connect(function(arg2)
			for k in pairs(tbl20) do
				if tostring(arg2.Animation.AnimationId):find(k) then
					if tbl21.enabled then
						tbl21.isUsingPlasmaBeam = true

						local function fn28()
							tbl21.isUsingPlasmaBeam = false
						end

						arg2.Stopped:Once(fn28)
						arg2.Ended:Once(fn28)
					end

					break
				end
			end
		end)
	end

	local function fn28()
		local ok, result = pcall(require, v)
		if not (ok and result and result.SetConnection) then
			return
		end

		result:SetConnection("GetMousePosition", "REMOTE_FUNCTION", function()
			local v4 = fn24()

			if v4 and v4.PrimaryPart then
				local v5 = fn25(v4, workspace.CurrentCamera.CFrame.Position)
				if v5 then
					return v5
				end
				return v4.PrimaryPart.Position
			end

			return localPlayer:GetMouse().Hit.Position
		end)
	end

	local function fn29(character)
		if character.Name == "Dusekkar" then
			task.wait(1)

			if not flag4 then
				fn28()
			else
				fn27(character)

				if not tbl21.conns.render then
					tbl21.conns.render = RunService.RenderStepped:Connect(fn26)
				end
			end
		else
			tbl21.isUsingPlasmaBeam = false

			if tbl21.conns.render then
				tbl21.conns.render:Disconnect()
				tbl21.conns.render = nil
			end
		end
	end

	local function fn30(enabled)
		tbl21.enabled = enabled

		if enabled then
			if not tbl21.conns.charAdded then
				tbl21.conns.charAdded = localPlayer.CharacterAdded:Connect(fn29)
			end

			if localPlayer.Character then
				fn29(localPlayer.Character)
			end

			if UserInputService.TouchEnabled then
				fn7({
					name = "DusekkarAimTarget",
					text = "Target: " .. target,
					size = UDim2.new(0, 150, 0, 40),
					position = UDim2.new(0.5, -75, 0.8, 0),
					backgroundColor3 = Color3.fromRGB(20, 20, 20),
					onClick = function(arg)
						if target == "Killer" then
							target = "Survivor"
						else
							target = "Killer"
						end

						arg.Text = "Target: " .. target
					end,
				})
			end
		else
			for _, conn in pairs(tbl21.conns) do
				conn:Disconnect()
			end

			tbl21.conns = {}
			tbl21.isUsingPlasmaBeam = false
			fn8("DusekkarAimTarget")
		end
	end

	local tbl22 = {}
	local v4 = Survivors:AddToggle({ Name = "Plasma Beam Aim", Callback = fn30 })

	local v5 = Survivors:AddDropdown({
		Name = "Aim Target",
		Options = { "Killer", "Survivor", "Nearest" },
		Callback = function(target2)
			target = target2
			local DusekkarAimTarget = fn9("DusekkarAimTarget")

			if DusekkarAimTarget then
				DusekkarAimTarget.updateText("Target: " .. target2)
			end
		end,
	})

	local v6 = Survivors:AddSlider({
		Name = "Prediction (seconds)",
		Min = 0,
		Max = 1,
		Default = 0.2,
		Callback = function(arg)
			n6 = arg
		end,
	})

	local addToggle = Survivors.AddToggle
	tbl22[1] = v4
	tbl22[2] = v5
	tbl22[3] = v6

	do
		local values = table.pack(addToggle(Survivors, { Name = "Protection Wallbang (rage use on own risk)", Callback = fn23 }))
		table.move(values, 1, values.n, 4, tbl22)
	end

	Survivors:AddList({ Name = "Dusekkar", Elems = tbl22 })
end

task.wait()
local Killers
Killers = Main:AddTab("Killers", "Killer")
local fn23

fn23 = function(arg)
	if arg == "Noli" then
		return "Stab"
	end

	if arg == "c00lkidd" then
		return "Punch"
	end

	if arg == "Sixer" then
		return "Carving Slash"
	end
	return "Slash"
end

do
	local function fn24(arg)
		local v4 = fn23(arg)
		return buffer.fromstring(string.pack("<Bi4", 3, #v4) .. v4)
	end

	local tbl19 = {
		Enabled = false,
		Distance = 15,
		FacingCheck = false,
		AutoLock = false,
		Prediction = 0.1,
		AimMethod = "HRP + Camera Lock",
		LockDuration = 0.7,
		Smoothness = 0.08,
		HumanizeRadius = 1.2,
	}

	local connection4 = nil
	local n6 = 0
	local n7 = 0
	local v4 = nil

	local function fn25()
		if connection4 then
			connection4:Disconnect()
			connection4 = nil
		end

		if not tbl19.Enabled then
			return
		end
		connection4 = RunService.Heartbeat:Connect(function(...) end)
	end

	Killers:AddSection("Auto M1")

	Killers:AddToggle({
		Name = "Enable Auto M1",
		Callback = function(enabled)
			tbl19.Enabled = enabled
			fn25()
		end,
	})

	Killers:AddToggle({
		Name = "Facing Check",
		Callback = function(facingCheck)
			tbl19.FacingCheck = facingCheck
		end,
	})

	Killers:AddToggle({
		Name = "Auto Lock (On Attack)",
		Callback = function(autoLock)
			tbl19.AutoLock = autoLock
		end,
	})

	Killers:AddDropdown({
		Name = "Aim Method",
		Description = "Choose aim method",
		Options = { "HRP", "Camera Lock", "HRP + Camera Lock" },
		Default = tbl19.AimMethod,
		Callback = function(aimMethod)
			tbl19.AimMethod = aimMethod
		end,
	})

	Killers:AddSlider({
		Name = "Aim Lock Duration",
		Min = 0.1,
		Max = 3,
		Default = 0.7,
		Callback = function(lockDuration)
			tbl19.LockDuration = lockDuration
		end,
	})

	Killers:AddSlider({
		Name = "Aim Smoothness (Legit)",
		Min = 0.01,
		Max = 0.15,
		Default = 0.05,
		Callback = function(smoothness)
			tbl19.Smoothness = smoothness
		end,
	})

	Killers:AddSlider({
		Name = "Auto Lock Prediction",
		Min = 0,
		Max = 1,
		Default = 0.1,
		Callback = function(prediction)
			tbl19.Prediction = prediction
		end,
	})

	Killers:AddSlider({
		Name = "Attack Distance",
		Min = 5,
		Max = 30,
		Default = 15,
		Callback = function(distance)
			tbl19.Distance = distance
		end,
	})
end

do
	local tbl19 = { Enabled = false, Radius = 18, Cooldown = 0.8 }
	local tbl20 = { JohnDoe = "\3\8\0\0\000404Error", Slasher = "\3\n\0\0\0RagingPace" }
	local tbl21 = {}
	local n6 = 0

	local function fn24()
		if not tbl19.Enabled then
			return
		end
		local cooldown = tbl19.Cooldown
		if tick() - n6 < cooldown then
			return
		end
		local character = localPlayer.Character
		if not character then
			return
		end
		local v4 = tbl20[character.Name]

		if v4 and remoteEvent then
			remoteEvent:FireServer("UseActorAbility", { buffer.fromstring(v4) })
			n6 = tick()
		end
	end

	forsakenFK.sounds.on(function(arg)
		local match = tostring(arg.SoundId):match("%d+")

		if match and tbl2.TriggerSounds[match] then
			if fn15({ Folder = survivors, MaxDist = tbl2.ChanceSounds[match] and 75 or tbl19.Radius, IgnoreSelf = true }) then
				fn24()
			end
		end
	end)

	local function fn25()
		for _, v4 in ipairs(tbl21) do
			v4:Disconnect()
		end

		table.clear(tbl21)
	end

	Killers:AddSection("Auto Dodge")

	Killers:AddToggle({
		Name = "Auto Raging Pace/404",
		Description = "Punch/Slash/Dagger/Shoot/Axe",
		Callback = function(enabled)
			tbl19.Enabled = enabled
			fn25(enabled)
		end,
	})

	Killers:AddSlider({
		Name = "Dodge Radius",
		Min = 5,
		Max = 40,
		Default = 18,
		Callback = function(radius)
			tbl19.Radius = radius
		end,
	})
end

Killers:AddSection("Anti Backstab")

do
	local tbl19 = { Enabled = false, ShowCone = false, Mode = "Behind", Range = 10, Angle = 90 }
	local tbl20 = { ["99820161736138"] = true, ["86710781315432"] = true, ["144352131"] = true }
	local tbl21 = {}
	local tbl22 = {}
	local connection4 = nil
	local tbl23 = {}

	local function fn24(arg, arg2)
		if not tbl23[arg] then
			local part = Instance.new("Part")
			part.Anchored = true
			part.CanCollide = false
			part.CanTouch = false
			part.CanQuery = false
			part.CastShadow = false
			part.Material = Enum.Material.Neon
			part.Shape = arg2 and Enum.PartType.Cylinder or Enum.PartType.Block
			part.Parent = workspace
			tbl23[arg] = part
		end

		return tbl23[arg]
	end

	local function fn25()
		for _, v4 in pairs(tbl23) do
			v4.Transparency = 1
		end
	end

	local function fn26(arg, arg2, arg3, color2)
		local v4 = fn24(arg, false)
		local magnitude = (arg3 - arg2).Magnitude
		v4.Size = Vector3.new(0.08, 0.08, magnitude)
		v4.CFrame = CFrame.lookAt(arg2, arg3) * CFrame.new(0, 0, -magnitude / 2)
		v4.Color = color2
		v4.Transparency = 0
	end

	local function fn27(arg, arg2, arg3, color2)
		local v4 = fn24(arg, true)
		v4.Size = Vector3.new(0.05, arg3 * 2, arg3 * 2)
		v4.CFrame = CFrame.new(arg2) * CFrame.Angles(0, 0, 1.5707963267948966)
		v4.Color = color2
		v4.Transparency = 0.7
	end

	local function fn28(arg, arg2, color2)
		local v4 = fn24(arg, false)
		v4.Size = Vector3.new(0.5, 0.5, 0.5)
		v4.CFrame = CFrame.new(arg2)
		v4.Color = color2
		v4.Transparency = 0
		return v4
	end

	local function fn29()
		local tbl24 = {}

		for _, child in ipairs(survivors:GetChildren()) do
			if child:IsA("Model") then
				if string.lower(child.Name):gsub("%s+", "") == "twotime" and child:FindFirstChild("HumanoidRootPart") then
					table.insert(tbl24, child)
				end
			end
		end

		return tbl24
	end

	local flag4 = false
	local v4 = nil

	local function fn30()
		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		if not character then
			return
		end
		local v5 = fn29()
		flag4 = false
		v4 = nil
		local huge = math.huge

		for _, v6 in ipairs(v5) do
			local humanoidRootPart = v6:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart then
				local magnitude = (humanoidRootPart.Position - character.Position).Magnitude

				if tbl19.Mode == "Around" then
					if magnitude <= tbl19.Range then
						flag4 = true

						if magnitude < huge then
							v4 = v6
							huge = magnitude
						end
					elseif not v4 then
						v4 = v6
					end
				elseif tbl19.Mode == "Behind" then
					if magnitude <= tbl19.Range then
						local lookVector = character.CFrame.LookVector
						local n6 = humanoidRootPart.Position - character.Position
						local unit = n6.Magnitude > 0.05 and n6.Unit or -lookVector
						local n7 = -lookVector
						local deg = math.deg
						local v7 = table.pack(math.acos(math.clamp(n7:Dot(unit), -1, 1)))

						if deg(table.unpack(v7, 1, v7.n)) <= tbl19.Angle / 2 then
							flag4 = true

							if magnitude < huge then
								v4 = v6
								huge = magnitude
							end
						elseif not v4 then
							v4 = v6
						end
					elseif not v4 then
						v4 = v6
					end
				elseif not v4 then
					v4 = v6
				end
			end
		end

		if tbl19.ShowCone then
			local humanoidRootPart = v4 and v4:FindFirstChild("HumanoidRootPart")
			humanoidRootPart = humanoidRootPart and humanoidRootPart.Position or nil

			if tbl19.Mode == "Around" then
				fn24("FrameCenterToLeft").Transparency = 1
				fn24("FrameCenterToRight").Transparency = 1
				fn24("CP_Center").Transparency = 1
				fn24("CP_Left").Transparency = 1
				fn24("CP_Right").Transparency = 1
				fn24("LineToT_Center").Transparency = 1
				fn24("LineToT_Left").Transparency = 1
				fn24("LineToT_Right").Transparency = 1
				fn27("MainCircle", character.Position - Vector3.new(0, 0.8, 0), tbl19.Range, flag4 and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50))
			elseif tbl19.Mode == "Behind" then
				fn24("MainCircle", true).Transparency = 1
				local n6 = -character.CFrame.LookVector
				local lookVector = character.CFrame.LookVector
				local v6 = math.rad(tbl19.Angle / 2)
				local n7 = character.Position + n6 * tbl19.Range - Vector3.new(0, 0.8, 0)
				local lookVector2 = (CFrame.new(Vector3.zero, lookVector) * CFrame.Angles(0, v6, 0)).LookVector
				local lookVector3 = (CFrame.new(Vector3.zero, lookVector) * CFrame.Angles(0, -v6, 0)).LookVector
				local n8 = tbl19.Range * 90 / math.max(tbl19.Angle, 10)
				local n9 = n7 + lookVector2 * n8
				local n10 = n7 + lookVector3 * n8
				local color2 = Color3.fromRGB(255, 255, 0)
				fn26("FrameCenterToLeft", n7, n9, color2)
				fn26("FrameCenterToRight", n7, n10, color2)
				local color3 = Color3.fromRGB(150, 255, 0)
				fn28("CP_Center", n7, color3)
				fn28("CP_Left", n9, color3)
				fn28("CP_Right", n10, color3)

				if flag4 and humanoidRootPart then
					fn26("LineToT_Center", n7, humanoidRootPart, Color3.fromRGB(255, 0, 0))
					fn26("LineToT_Left", n9, humanoidRootPart, Color3.fromRGB(255, 0, 0))
					fn26("LineToT_Right", n10, humanoidRootPart, Color3.fromRGB(255, 0, 0))
				else
					fn24("LineToT_Center").Transparency = 1
					fn24("LineToT_Left").Transparency = 1
					fn24("LineToT_Right").Transparency = 1
				end
			end
		else
			fn25()
		end
	end

	local function fn31()
		if tbl19.Enabled or tbl19.ShowCone then
			if not connection4 then
				connection4 = RunService.Heartbeat:Connect(fn30)
			end
		elseif connection4 then
			connection4:Disconnect()
			connection4 = nil
			fn25()
		end
	end

	local function fn32(arg)
		if not tbl19.Enabled then
			return
		end
		local match = tostring(arg.SoundId):match("%d+")
		if not match then
			return
		end

		if tbl20[match] then
			if flag4 and v4 then
				local character = localPlayer.Character
				local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
				local humanoid = character and character:FindFirstChild("Humanoid")
				local humanoidRootPart2 = v4:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart and humanoidRootPart2 and humanoid then
					humanoid.AutoRotate = false
					local position = humanoidRootPart2.Position
					local cframe = CFrame.lookAt(humanoidRootPart.Position, Vector3.new(position.X, humanoidRootPart.Position.Y, position.Z))
					local bodyGyro = Instance.new("BodyGyro")
					bodyGyro.MaxTorque = Vector3.new(0, math.huge, 0)
					bodyGyro.D = 500
					bodyGyro.P = 50000
					bodyGyro.CFrame = cframe
					bodyGyro.Parent = humanoidRootPart

					task.delay(0.2, function()
						if bodyGyro then
							bodyGyro:Destroy()
						end

						if humanoid then
							humanoid.AutoRotate = true
						end
					end)
				end
			end
		end
	end

	local function fn33(arg)
		if not arg:IsA("Sound") or tbl21[arg] then
			return
		end

		local connection5 = arg.Played:Connect(function()
			fn32(arg)
		end)

		local connection6 = arg:GetPropertyChangedSignal("IsPlaying"):Connect(function()
			if arg.IsPlaying then
				fn32(arg)
			end
		end)

		local connection7 = nil

		connection7 = arg.Destroying:Connect(function()
			connection5:Disconnect()
			connection6:Disconnect()
			connection7:Disconnect()
			tbl21[arg] = nil
		end)

		tbl21[arg] = true

		if arg.IsPlaying then
			fn32(arg)
		end
	end

	local function fn34(arg)
		for _, v5 in ipairs(tbl22) do
			v5:Disconnect()
		end

		table.clear(tbl22)

		if arg then
			for _, descendant in ipairs(workspace:GetDescendants()) do
				if descendant:IsA("Sound") then
					fn33(descendant)
				end
			end

			table.insert(tbl22, workspace.DescendantAdded:Connect(function(descendant)
				if descendant:IsA("Sound") then
					fn33(descendant)
				end
			end))
		end
	end

	Killers:AddToggle({
		Name = "Anti Backstab",
		Callback = function(enabled)
			tbl19.Enabled = enabled
			fn34(enabled)
			fn31()
		end,
	})

	Killers:AddToggle({
		Name = "Show cone checking",
		Callback = function(showCone)
			tbl19.ShowCone = showCone
			fn31()
		end,
	})

	Killers:AddDropdown({
		Name = "Checking Area",
		Options = { "Behind", "Around" },
		Callback = function(mode)
			tbl19.Mode = mode
		end,
	})

	Killers:AddSlider({
		Name = "Cone / Circle Range",
		Min = 5,
		Max = 30,
		Default = 10,
		Callback = function(range)
			tbl19.Range = range
		end,
	})

	Killers:AddSlider({
		Name = "Cone Angle",
		Min = 10,
		Max = 180,
		Default = 90,
		Callback = function(angle)
			tbl19.Angle = angle
		end,
	})
end

Killers:AddSection("Killers")

do
	local tbl19 = { AutoQTE = false, Method = "Instance", Infinite = false }
	local flag4 = false
	local connection4 = nil
	local flag5 = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

	local function fn24()
		if not playerGui then
			return nil
		end

		for _, v4 in ipairs({ "TemporaryUI", "MainUI" }) do
			local v5 = playerGui:FindFirstChild(v4)

			if v5 then
				local qte = v5:FindFirstChild("QTE")
				if qte then
					return qte
				end
			end
		end

		return playerGui:FindFirstChild("QTE")
	end

	local function fn25(arg)
		local clickArea = arg:FindFirstChild("ClickArea", true)

		if not clickArea then
			for _, descendant in ipairs(arg:GetDescendants()) do
				if (descendant:IsA("ImageButton") or descendant:IsA("TextButton")) and descendant.Visible then
					clickArea = descendant
					break
				end
			end
		end

		if not (not clickArea and arg:IsA("GuiObject") and arg.Visible) then
			arg = clickArea
		end

		if not arg then
			return
		end
		local absolutePosition = arg.AbsolutePosition
		local absoluteSize = arg.AbsoluteSize
		local n6 = absolutePosition.X + absoluteSize.X / 2
		local n7 = absolutePosition.Y + absoluteSize.Y / 2

		if flag5 then
			VirtualInputManager:SendTouchEvent(1, 0, n6, n7)
			task.wait(0.01)
			VirtualInputManager:SendTouchEvent(1, 2, n6, n7)
		else
			VirtualInputManager:SendMouseButtonEvent(n6, n7, 0, true, game, 1)
			task.wait(0.01)
			VirtualInputManager:SendMouseButtonEvent(n6, n7, 0, false, game, 1)
		end
	end

	local function fn26(...) end

	local function fn27()
		if connection4 then
			return
		end
		connection4 = RunService.Heartbeat:Connect(fn26)
	end

	local function fn28()
		if connection4 then
			connection4:Disconnect()
			connection4 = nil
		end
	end

	local function fn29()
		if flag4 then
			return true
		end

		local ok, result = pcall(function()
			return require(assets.Killers.Azure.Config.cl_WorkaroundModules.cl_ConstructQTE)
		end)

		if not ok or not result or type(result.new) ~= "function" then
			return false
		end
		local new = result.new

		result.new = function(arg, arg2)
			local v4 = new(arg, arg2)

			if v4 then
				if tbl19.Infinite then
					v4.FailedAttempts = -math.huge
				end

				if tbl19.AutoQTE and tbl19.Method == "Instance" then
					task.defer(function()
						task.wait(0.12)

						if tbl19.AutoQTE and tbl19.Method == "Instance" and v4 and type(v4.AddProgress) == "function" then
							v4:AddProgress(100)
						end
					end)
				end
			end

			return v4
		end

		flag4 = true
		return true
	end

	local v4 = Killers:AddToggle({
		Name = "Auto Trap minigame",
		Default = tbl19.AutoQTE,
		Callback = function(autoQTE)
			tbl19.AutoQTE = autoQTE

			if autoQTE then
				if tbl19.Method == "Manual" then
					fn27()
				elseif not fn29() then
					tbl19.AutoQTE = false
				end
			else
				fn28()
			end
		end,
	})

	local v5 = Killers:AddDropdown({
		Name = "QTE Method",
		Options = { "Manual", "Instance" },
		Default = tbl19.Method,
		Callback = function(method)
			tbl19.Method = method

			if tbl19.AutoQTE then
				fn28()

				if method == "Manual" then
					fn27()
				else
					fn29()
				end
			end
		end,
	})

	local v6 = Killers:AddToggle({
		Name = "Infinite Attempts",
		Callback = function(infinite)
			tbl19.Infinite = infinite

			if infinite then
				fn29()
			end
		end,
	})

	local tbl20 = {
		Settings = {
			Enabled = false,
			TentaclesEnabled = false,
			SpikesEnabled = false,
			AimSmoothness = 0.15,
			VelocitySmoothFactor = 0.15,
			SearchType = "World_3D",
			MaxDistance = math.huge,
			FOVRadius = 360,
			AdditionalLeadTime = 0.05,
			MaxPredictTime = 1.25,
			MaxTargetSpeed = 120,
			TargetRefresh = 0.1,
			GrabWallCheck = true,
			SpikesWallCheck = true,
		},
		State = {
			CurrentTarget = nil,
			Actor = nil,
			Mode = nil,
			AimEndTime = 0,
			VelocityTable = {},
			Status = "Disabled",
		},
	}

	local connection5 = nil
	local v7 = nil
	local tbl21 = nil
	local n6 = 0
	local n7 = 0
	local n8 = 0
	local n9 = -math.huge
	local n10 = -math.huge
	local settings = tbl20.Settings
	local state = tbl20.State

	local function fn30()
		if survivors and survivors:IsDescendantOf(Workspace) then
			return survivors
		end
		local players2 = Workspace:FindFirstChild("Players")
		return players2 and players2:FindFirstChild("Survivors")
	end

	local function fn31(arg, arg2)
		return 1 - (1 - math.clamp(arg, 0, 1)) ^ (math.max(arg2, 0) * 60)
	end

	local function fn32()
		state.CurrentTarget = nil
		state.Mode = nil
		state.AimEndTime = 0
		state.SpikeTrack = nil
		n8 = 0
	end

	local function fn33()
		if tbl21 then
			if tbl21.Entry.Callback == tbl21.Wrapper then
				tbl21.Entry.Callback = tbl21.Original
			end

			tbl21 = nil
		end
	end

	local function fn34(arg)
		return type(arg) == "table" and not arg.Destroyed and typeof(arg.Rig) == "Instance" and arg.Rig:IsA("Model") and arg.Rig.Parent and (arg.Player == localPlayer or arg.Rig == localPlayer.Character) and type(arg.Config) == "table" and type(arg.Config.Grab) == "table" and type(arg.Config.GolemFissure) == "table" and type(arg.State) == "table"
	end

	local function fn35()
		if not v7 and os.clock() - n9 >= 2 then
			n9 = os.clock()

			local ok, result = pcall(function()
				return require(ReplicatedStorage.Modules.Gameplay.Actors)
			end)

			if ok and type(result) == "table" then
				v7 = result
			end
		end

		local currentActors = v7 and v7.CurrentActors
		if type(currentActors) ~= "table" then
			return nil
		end
		local v8 = currentActors[localPlayer]
		if fn34(v8) then
			return v8
		end

		for _, currentActor in pairs(currentActors) do
			if fn34(currentActor) then
				return currentActor
			end
		end

		return nil
	end

	local function fn36(arg)
		local behavior = arg.Behavior
		local blossom = behavior and behavior.Abilities and behavior.Abilities.Blossom
		if type(blossom) ~= "table" or type(blossom.Callback) ~= "function" then
			return
		end

		if tbl21 and tbl21.Entry == blossom and blossom.Callback == tbl21.Wrapper then
			return
		end
		fn33()
		local callback = blossom.Callback

		local function callback2(arg2, arg3, ...)
			local v8 = table.pack(callback(arg2, arg3, ...))

			if arg2 == state.Actor then
				if arg3 == "Plant" then
					fn32()
					local blossom2 = arg2.Config.Blossom or {}
					state.SuppressUntil = os.clock() + (blossom2.Windup or 0.8) + (blossom2.Endlag or 0.5)
				elseif arg3 == "Golem" and settings.Enabled and settings.SpikesEnabled and fn34(arg2) then
					state.SuppressUntil = nil
					local golemFissure = arg2.Config.GolemFissure
					state.Mode = "Spikes"
					state.AimEndTime = os.clock() + (golemFissure.Windup or 0.8)
					state.SpikeTrack = arg2.Animations and arg2.Animations.GolemFissure
					state.CurrentTarget = nil
					n8 = settings.TargetRefresh
				end
			end

			return table.unpack(v8, 1, v8.n)
		end

		blossom.Callback = callback2
		tbl21 = { Entry = blossom, Original = callback, Wrapper = callback2 }
	end

	local function fn37(arg)
		local v8 = fn30()
		if not v8 then
			table.clear(state.VelocityTable)
			return
		end
		local tbl22 = {}

		for _, child in ipairs(v8:GetChildren()) do
			local humanoidRootPart = child:FindFirstChild("HumanoidRootPart")
			local humanoid = child:FindFirstChildOfClass("Humanoid")

			if humanoidRootPart and humanoidRootPart:IsA("BasePart") and humanoid and humanoid.Health > 0 then
				tbl22[child] = true
				local position = humanoidRootPart.Position
				local v9 = state.VelocityTable[child]

				if not v9 or v9.Root ~= humanoidRootPart then
					state.VelocityTable[child] = { Root = humanoidRootPart, Position = position, Velocity = Vector3.zero }
				else
					local vector2 = arg > 0 and (position - v9.Position) / arg or Vector3.zero

					if arg > 0.25 or vector2.Magnitude > settings.MaxTargetSpeed then
						v9.Velocity = Vector3.zero
					else
						v9.Velocity = v9.Velocity:Lerp(vector2, fn31(settings.VelocitySmoothFactor, arg))
					end

					v9.Position = position
				end
			end
		end

		for k in pairs(state.VelocityTable) do
			if not tbl22[k] then
				state.VelocityTable[k] = nil
			end
		end
	end

	local function fn38(arg, arg2, arg3, arg4)
		local v8 = fn30()
		if not arg or not v8 or arg.Parent ~= v8 then
			return nil
		end
		local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
		local humanoid = arg:FindFirstChildOfClass("Humanoid")
		if not humanoidRootPart or not humanoidRootPart:IsA("BasePart") or not humanoid or humanoid.Health <= 0 then
			return nil
		end

		if arg4 == "Grab" and arg:GetAttribute("Undetectable") then
			return nil
		end

		if arg3 < (humanoidRootPart.Position - arg2).Magnitude then
			return nil
		end
		return humanoidRootPart
	end

	local function fn39(arg)
		local raycastParams2 = RaycastParams.new()
		raycastParams2.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams2.RespectCanCollide = true
		local players2 = Workspace:FindFirstChild("Players")
		raycastParams2.FilterDescendantsInstances = players2 and { players2 } or { arg.Rig }

		pcall(function()
			raycastParams2.CollisionGroup = "Killers"
		end)

		return raycastParams2
	end

	local function fn40(arg, arg2, arg3, arg4)
		local v8 = fn30()
		local currentCamera2 = Workspace.CurrentCamera
		if not v8 or not currentCamera2 then
			return nil
		end
		local grabWallCheck = (arg4 == "Grab" and settings.GrabWallCheck or arg4 == "Spikes" and settings.SpikesWallCheck) and fn39(arg)
		local huge = math.huge
		local v9 = nil

		for _, child in ipairs(v8:GetChildren()) do
			local v10 = fn38(child, arg2, arg3, arg4)

			if v10 then
				local n11 = v10.Position - arg2
				local magnitude = n11.Magnitude
				local flag6 = true

				if settings.SearchType == "Screen_2D" then
					local v11, v12 = currentCamera2:WorldToViewportPoint(v10.Position)
					local n12 = currentCamera2.ViewportSize / 2
					magnitude = (Vector2.new(v11.X, v11.Y) - n12).Magnitude
					flag6 = v12 and v11.Z > 0 and magnitude <= settings.FOVRadius
				end

				if flag6 and magnitude < huge and (not grabWallCheck or n11.Magnitude < 0.001 or not Workspace:Raycast(arg2, n11, grabWallCheck)) then
					huge = magnitude
					v9 = child
				end
			end
		end

		return v9
	end

	local function fn41(arg, arg2, arg3)
		if arg3 <= 0 then
			return 0
		end
		local n11 = arg2:Dot(arg2) - arg3 * arg3
		local n12 = 2 * arg:Dot(arg2)
		local v8 = arg:Dot(arg)
		if v8 < 0.0001 then
			return 0
		end

		if math.abs(n11) < 0.0001 then
			if math.abs(n12) > 0.0001 and -v8 / n12 >= 0 then
				return -v8 / n12
			end
		else
			local n13 = n12 * n12 - 4 * n11 * v8

			if n13 >= 0 then
				local v9 = math.sqrt(n13)
				local n14 = (-n12 - v9) / 2 * n11
				local n15 = (-n12 + v9) / 2 * n11
				local huge = math.huge

				if not (n14 >= 0) then
					n14 = huge
				end

				local n16

				if not (n15 >= 0) then
					n16 = n14
				else
					n16 = math.min(n14, n15)
				end

				if n16 < math.huge then
					return n16
				end
			end
		end

		return arg.Magnitude / arg3
	end

	local function fn42(arg, arg2, arg3, arg4, arg5)
		local velocity = state.VelocityTable[arg]
		velocity = velocity and velocity.Velocity or arg2.AssemblyLinearVelocity

		if velocity.Magnitude > settings.MaxTargetSpeed then
			velocity = Vector3.zero
		end

		local hookSpeed, additionalLeadTime

		if arg5 == "Grab" then
			hookSpeed = arg4.Config.Grab.HookSpeed or 270
			additionalLeadTime = settings.AdditionalLeadTime
		else
			local golemFissure = arg4.Config.GolemFissure
			hookSpeed = (golemFissure.StudInterval or 5) / math.max(0.001, golemFissure.TimeInterval or 0.07)
			additionalLeadTime = math.max(0, state.AimEndTime - os.clock()) + settings.AdditionalLeadTime
			velocity *= Vector3.new(1, 0, 1)
		end

		return arg2.Position + velocity * math.clamp(additionalLeadTime + fn41(arg2.Position + velocity * additionalLeadTime - arg3, velocity, hookSpeed), 0, settings.MaxPredictTime)
	end

	local function fn43(...) end

	tbl20.UpdateState = function()
		settings.Enabled = settings.TentaclesEnabled or settings.SpikesEnabled

		if not settings.Enabled then
			if connection5 then
				connection5:Disconnect()
				connection5 = nil
			end

			RunService:UnbindFromRenderStep("AzureAimV2_BeforeGameAim")
			fn33()
			fn32()
			state.Actor = nil
			table.clear(state.VelocityTable)
			state.Status = "Disabled"
			return
		end

		if state.Mode == "Spikes" and not settings.SpikesEnabled then
			fn32()
		end

		if state.Mode == "Grab" and not settings.TentaclesEnabled then
			fn32()
		end

		if connection5 then
			return
		end
		n6 = 0.2
		n7 = 0
		connection5 = RunService.Heartbeat:Connect(function(...) end)
		RunService:BindToRenderStep("AzureAimV2_BeforeGameAim", Enum.RenderPriority.Camera.Value + 1, fn43)
	end

	tbl20.Destroy = function()
		local v8 = settings
		settings.TentaclesEnabled = false
		v8.SpikesEnabled = false
		tbl20.UpdateState()
	end

	local v8 = Killers:AddToggle({
		Name = "Aim on Tentacles (Grab)",
		Default = false,
		Callback = function(tentaclesEnabled)
			tbl20.Settings.TentaclesEnabled = tentaclesEnabled
			tbl20.UpdateState()
		end,
	})

	local v9 = Killers:AddToggle({
		Name = "Aim on Unearthing (Golem only)",
		Default = false,
		Callback = function(spikesEnabled)
			tbl20.Settings.SpikesEnabled = spikesEnabled
			tbl20.UpdateState()
		end,
	})

	Killers:AddList({ Name = "Azure", Elems = { v5, v4, v6, v8, v9 } })
end

local connection4 = nil

Auto_Nosferatu_Hook_FUNC = function()
	if connection4 then
		connection4:Disconnect()
		connection4 = nil
	end

	if not tbl.ANosferatuHook then
		return
	end
	local temporaryUI = localPlayer.PlayerGui:WaitForChild("TemporaryUI", 5)
	if not temporaryUI then
		return
	end

	local function fn24(arg)
		task.spawn(function()
			while tbl.ANosferatuHook do
				if not (not arg or not arg:IsDescendantOf(game)) then
					local killers2 = workspace.Players:FindFirstChild("Killers")
					killers2 = killers2 and killers2:FindFirstChild("Nosferatu")
					local playerFromCharacter = killers2 and Players:GetPlayerFromCharacter(killers2)

					if playerFromCharacter and remoteEvent then
						remoteEvent:FireServer(playerFromCharacter.Name .. "NosHookQTE", { buffer.fromstring("\1\1") })
					end

					task.wait(tbl.ANosferatuHookCoolDown)
					continue
				end

				break
			end
		end)
	end

	local qte = temporaryUI:FindFirstChild("QTE")

	if qte and qte:IsA("Frame") then
		fn24(qte)
	end

	connection4 = temporaryUI.ChildAdded:Connect(function(child)
		if child.Name == "QTE" then
			task.wait(1)
			fn24(child)
		end
	end)
end

local v4

v4 = Killers:AddToggle({
	Name = "Auto Hook minigame",
	Callback = function(aNosferatuHook)
		tbl.ANosferatuHook = aNosferatuHook
		Auto_Nosferatu_Hook_FUNC()
	end,
})

local v5

v5 = Killers:AddSlider({
	Name = "Minigame CoolDown",
	Min = 0.1,
	Max = 1,
	Default = tbl.ANosferatuHookCoolDown,
	Callback = function(aNosferatuHookCoolDown)
		tbl.ANosferatuHookCoolDown = aNosferatuHookCoolDown
	end,
})

local v6, v7, v8

do
	local tbl19 = {}

	local function fn24(arg)
		local ok, result = pcall(function()
			return require(assets.Killers.Nosferatu.Config)
		end)

		if ok and type(result) == "table" then
			arg(result)
		end

		pcall(function()
			for _, v9 in pairs(getgc(true)) do
				if type(v9) == "table" then
					if rawget(v9, "AscentFlight") or rawget(v9, "AscentBite") or rawget(v9, "Spire") then
						arg(v9)
					elseif rawget(v9, "Config") and type(v9.Config) == "table" and (v9.Config.AscentFlight or v9.Config.Spire) then
						arg(v9.Config)
					end
				end
			end
		end)
	end

	v6 = Killers:AddToggle({
		Name = "Unlimited fly",
		Callback = function(arg)
			fn24(function(arg2)
				if arg2.AscentFlight then
					if tbl19.Duration == nil then
						tbl19.Duration = arg2.AscentFlight.Duration or 10
					end

					arg2.AscentFlight.Duration = arg and 999999 or tbl19.Duration
				end
			end)
		end,
	})

	v7 = Killers:AddToggle({
		Name = "Dive Control",
		Callback = function(arg)
			fn24(function(arg2)
				if arg2.AscentBite then
					if tbl19.TurnSpeed == nil then
						tbl19.TurnSpeed = arg2.AscentBite.TurnSpeed or 4
					end

					arg2.AscentBite.TurnSpeed = arg and 999999 or tbl19.TurnSpeed
				end

				if arg2.Ascent then
					if tbl19.CanTurn == nil then
						tbl19.CanTurn = arg2.Ascent.CanTurn or false
					end

					arg2.Ascent.CanTurn = arg and true or tbl19.CanTurn
				end
			end)
		end,
	})

	v8 = Killers:AddToggle({
		Name = "Cataclysm Control",
		Callback = function(arg)
			fn24(function(arg2)
				if arg2.Spire then
					if tbl19.TurnControl == nil then
						tbl19.TurnControl = arg2.Spire.TurnControl or 10
					end

					arg2.Spire.TurnControl = arg and 999999 or tbl19.TurnControl
				end
			end)
		end,
	})
end

do
	local tbl19 = { Settings = { Enabled = false, AimSmoothness = 0.5 }, State = { CurrentTarget = nil } }
	local function fn24(...) end

	local v9 = Killers:AddToggle({
		Name = "Nosferatu Dive Aimbot",
		Callback = function(enabled)
			tbl19.Settings.Enabled = enabled

			if enabled then
				RunService:BindToRenderStep("NosDiveAimbot", Enum.RenderPriority.Camera.Value + 1, fn24)
			else
				RunService:UnbindFromRenderStep("NosDiveAimbot")
				tbl19.State.CurrentTarget = nil
			end
		end,
	})

	local tbl20 = {
		Settings = {
			Smoothness = 1,
			AdditionalLead = 0.03,
			MaxLeadTime = 1.25,
			TargetRefresh = 0.1,
			WallCheck = false,
			MaxTargetSpeed = 120,
		},
		State = { Actor = nil, Target = nil, Status = "Disabled" },
	}

	local settings = tbl20.Settings
	local state = tbl20.State
	local connection5 = nil
	local v10 = nil
	local n6 = 0
	local n7 = -math.huge
	local n8 = -math.huge
	local v11 = nil
	local v12 = nil
	local v13 = nil
	local n9 = 0
	local v14 = nil
	local v15 = nil
	local obj = setmetatable({}, { __mode = "k" })

	local function fn25()
		if v14 and v14.Parent then
			v14.AutoRotate = v15
		end

		v14 = nil
		v15 = nil
	end

	local function fn26()
		fn25()
		v11 = nil
		v12 = nil
		v13 = nil
		state.Target = nil
		n9 = settings.TargetRefresh
	end

	local function fn27()
		if survivors and survivors:IsDescendantOf(Workspace) then
			return survivors
		end
		local players2 = Workspace:FindFirstChild("Players")
		return players2 and players2:FindFirstChild("Survivors")
	end

	local function fn28()
		if not v10 and os.clock() - n7 >= 2 then
			n7 = os.clock()

			local ok, result = pcall(function()
				return require(ReplicatedStorage.Modules.Gameplay.Actors)
			end)

			if ok and type(result) == "table" then
				v10 = result
			end
		end

		local currentActors = v10 and v10.CurrentActors
		if type(currentActors) ~= "table" then
			return nil
		end

		local function fn29(arg)
			return type(arg) == "table" and not arg.Destroyed and arg.ActorName == "Nosferatu" and (arg.Player == localPlayer or arg.Rig == localPlayer.Character) and typeof(arg.Rig) == "Instance" and arg.Rig.Parent and type(arg.Config) == "table" and type(arg.Config.Uppercut) == "table"
		end

		if fn29(currentActors[localPlayer]) then
			return currentActors[localPlayer]
		end

		if localPlayer.Character and fn29(currentActors[localPlayer.Character]) then
			return currentActors[localPlayer.Character]
		end

		for _, currentActor in pairs(currentActors) do
			if fn29(currentActor) then
				return currentActor
			end
		end

		return nil
	end

	local function fn29(arg, arg2, arg3)
		local v16 = fn27()
		if not arg or not v16 or arg.Parent ~= v16 then
			return nil
		end
		local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart") or arg.PrimaryPart
		local humanoid = arg:FindFirstChildOfClass("Humanoid")
		if not humanoidRootPart or not humanoidRootPart:IsA("BasePart") or not humanoid or humanoid.Health <= 0 then
			return nil
		end

		if arg3 < (humanoidRootPart.Position - arg2).Magnitude then
			return nil
		end
		return humanoidRootPart
	end

	local function fn30(arg)
		local raycastParams2 = RaycastParams.new()
		raycastParams2.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams2.RespectCanCollide = true
		local players2 = Workspace:FindFirstChild("Players")
		raycastParams2.FilterDescendantsInstances = players2 and { players2 } or { arg }

		pcall(function()
			raycastParams2.CollisionGroup = "Killers"
		end)

		return raycastParams2
	end

	local function fn31(arg, arg2, arg3)
		local v16 = fn27()
		if not v16 then
			return nil
		end
		local wallCheck = settings.WallCheck and fn30(arg)
		local huge = math.huge
		local v17 = nil

		for _, child in ipairs(v16:GetChildren()) do
			if child:IsA("Model") then
				local v18 = fn29(child, arg2, arg3)

				if v18 then
					local n10 = v18.Position - arg2
					local magnitude = n10.Magnitude
					local flag4 = magnitude < huge

					if flag4 then
						flag4 = not wallCheck or magnitude < 0.001 or not Workspace:Raycast(arg2, n10, wallCheck)
					end

					if flag4 then
						huge = magnitude
						v17 = child
					end
				end
			end
		end

		return v17
	end

	local function fn32(arg, arg2, arg3)
		local n10 = arg2:Dot(arg2) - arg3 * arg3
		local n11 = 2 * arg:Dot(arg2)
		local v16 = arg:Dot(arg)
		if v16 < 0.0001 then
			return 0
		end

		if math.abs(n10) < 0.0001 then
			if math.abs(n11) > 0.0001 and -v16 / n11 >= 0 then
				return -v16 / n11
			end
		else
			local n12 = n11 * n11 - 4 * n10 * v16

			if n12 >= 0 then
				local v17 = math.sqrt(n12)
				local n13 = (-n11 - v17) / 2 * n10
				local n14 = (-n11 + v17) / 2 * n10
				local huge = math.huge

				if not (n13 >= 0) then
					n13 = huge
				end

				local n15

				if not (n14 >= 0) then
					n15 = n13
				else
					n15 = math.min(n13, n14)
				end

				if n15 < math.huge then
					return n15
				end
			end
		end

		return arg.Magnitude / arg3
	end

	local function fn33(arg, arg2, arg3, arg4)
		local now = os.clock()
		local assemblyLinearVelocity = arg.AssemblyLinearVelocity

		if settings.MaxTargetSpeed < assemblyLinearVelocity.Magnitude then
			assemblyLinearVelocity = Vector3.zero
		end

		local n10 = assemblyLinearVelocity * Vector3.new(1, 0, 1)
		local v16 = obj[arg]
		local v17

		if v16 and now - v16.Time < 0.5 then
			v17 = v16.Velocity:Lerp(n10, 1 - math.exp(-14 * math.max(0, now - v16.Time)))
		else
			v17 = n10
		end

		obj[arg] = { Time = now, Velocity = v17 }
		local n11 = arg4 + settings.AdditionalLead
		local maxLeadTime = settings.MaxLeadTime
		return arg.Position + v17 * math.clamp(n11 + fn32(arg.Position + v17 * n11 - arg2, v17, arg3), 0, maxLeadTime)
	end

	local function fn34(...) end

	tbl20.SetEnabled = function(arg)
		tbl.NosferatuBloodhookAim = arg == true

		if connection5 then
			connection5:Disconnect()
			connection5 = nil
		end

		RunService:UnbindFromRenderStep("NosferatuBloodhookBodyAim")
		fn26()
		state.Actor = nil

		if not arg then
			table.clear(obj)
			state.Status = "Disabled"
			return
		end

		n6 = 0.2
		connection5 = RunService.Heartbeat:Connect(function(...) end)
		RunService:BindToRenderStep("NosferatuBloodhookBodyAim", Enum.RenderPriority.Camera.Value + 2, fn34)
	end

	local v16 = Killers:AddToggle({
		Name = "Bloodhook Aim",
		Callback = function(arg)
			tbl20.SetEnabled(arg)
		end,
	})

	Killers:AddList({ Name = "Nosferatu", Elems = { v4, v5, v6, v7, v8, v9, v16 } })
end

do
	local flag4 = false
	local flag5 = false
	local n6 = 0
	local flag6 = false
	local flag7 = false
	local flag8 = false
	local flag9 = false
	local module = nil
	local fireServerConnection = nil
	local n7 = 0
	local tbl19 = {}
	local n8 = 1
	local flag10 = false
	local position = nil
	local v9 = nil
	local v10 = nil
	local n9 = 60
	local n10 = 1
	local n11 = 1
	local n12 = 1.5
	local n13 = 6.6
	local n14 = 0.4
	local n15 = 22

	local function fn24(arg)
		return n11 * (n13 * (1 - math.cos(math.clamp((n12 - arg) / n12, 0, 1) * 3.1415926535897931 / 2)) + 1)
	end

	local function fn25(arg, arg2, arg3, arg4)
		if not arg4 or arg4 <= 0 then
			return arg
		end

		if not arg2 then
			return arg
		end
		local x = arg2.X
		local z = arg2.Z
		if x ~= x or z ~= z then
			return arg
		end
		local v11 = math.sqrt(x * x + z * z)
		if v11 < 0.001 then
			return arg
		end
		local n16 = x / v11
		local n17 = z / v11
		if not arg or arg.Magnitude < 0.001 then
			return Vector3.new(n16, 0, n17)
		end
		local x2 = arg.X
		local z2 = arg.Z
		if x2 ~= x2 or z2 ~= z2 then
			return Vector3.new(n16, 0, n17)
		end
		local v12 = math.sqrt(x2 * x2 + z2 * z2)
		if v12 < 0.001 then
			return Vector3.new(n16, 0, n17)
		end
		local n18 = x2 / v12
		local n19 = z2 / v12
		local n20 = math.clamp(n18 * n16 + n19 * n17, -1, 1)
		local v13 = math.acos(n20)
		local n21 = 2 * math.asin(math.clamp(math.min(arg4 * arg3, 0.5) / 2, 0, 1))
		if v13 <= n21 then
			return Vector3.new(n16, 0, n17)
		end
		local n22 = n21 * (n19 * n16 - n18 * n17 < -1e-05 and -1 or 1)
		local v14 = math.cos(n22)
		local v15 = math.sin(n22)
		return Vector3.new(n18 * v14 + n19 * v15, 0, -n18 * v15 + n19 * v14)
	end

	local function fn26(arg)
		local huge = arg or math.huge
		local v11 = fn3()
		if not v11 then
			return nil
		end
		local position2 = v11.Position
		local v12 = nil

		for _, player_ in pairs(Players:GetPlayers()) do
			if player_ ~= localPlayer and player_.Character and player_.Character:FindFirstChild("HumanoidRootPart") and player_.Character:FindFirstChild("Humanoid") then
				if player_.Character.Humanoid.Health > 0 then
					local magnitude = (player_.Character.HumanoidRootPart.Position - position2).Magnitude

					if magnitude < huge then
						huge = magnitude
						v12 = player_
					end
				end
			end
		end

		return v12
	end

	local function fn27(arg, arg2, arg3, arg4)
		local raycastParams2 = RaycastParams.new()
		raycastParams2.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams2.FilterDescendantsInstances = { arg2, arg3 }
		raycastParams2.IgnoreWater = true
		local n16 = arg.Position + Vector3.new(0, 1.5, 0)
		return workspace:Raycast(n16, arg4 - n16, raycastParams2) == nil
	end

	local function fn28()
		tbl19 = {}
		n8 = 1
		position = nil
		n7 = 0
	end

	local function fn29(arg, arg2)
		if flag10 then
			return
		end
		local now = os.clock()
		if not (position and Vector2.new(arg2.X - position.X, arg2.Z - position.Z).Magnitude > 8) and now - n7 < n14 then
			return
		end
		flag10 = true

		task.spawn(function()
			local v11 = PathfindingService:CreatePath({ AgentRadius = 2, AgentHeight = 5, AgentCanJump = false, WaypointSpacing = 3 })

			if pcall(function()
				v11:ComputeAsync(arg.Position, arg2)
			end) and v11.Status == Enum.PathStatus.Success then
				local waypoints = v11:GetWaypoints()

				if #waypoints > 0 then
					local n16 = 1

					for i = 1, #waypoints do
						local position2 = waypoints[i].Position
						if Vector2.new(position2.X - arg.Position.X, position2.Z - arg.Position.Z).Magnitude > 4 then
							n16 = i
							break
						end
					end

					tbl19 = waypoints
					n8 = math.min(n16, #waypoints)
					position = waypoints[#waypoints].Position
				end
			else
				fn28()
			end

			n7 = os.clock()
			flag10 = false
		end)
	end

	local function fn30(arg, arg2)
		local vector2 = Vector3.new(arg2.X - arg.Position.X, 0, arg2.Z - arg.Position.Z)
		if vector2.Magnitude < 0.5 then
			return nil
		end
		return vector2.Unit
	end

	local function fn31(arg, arg2, arg3)
		arg3 = arg3 and arg3.Character
		local humanoidRootPart = arg3 and arg3:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return nil
		end
		local position2 = humanoidRootPart.Position
		local position3 = arg.Position
		if Vector2.new(position2.X - position3.X, position2.Z - position3.Z).Magnitude <= n15 or fn27(arg, arg2, arg3, position2 + Vector3.new(0, 1.5, 0)) then
			fn28()
			return fn30(arg, position2)
		end
		fn29(arg, position2)
		local v11 = tbl19
		if not v11 or #v11 == 0 then
			return fn30(arg, position2)
		end
		local x = position3.X
		local z = position3.Z

		local function fn32(arg4, arg5)
			return math.sqrt((arg4 - x) * (arg4 - x) + (arg5 - z) * (arg5 - z))
		end

		while n8 < #v11 and fn32(v11[n8].Position.X, v11[n8].Position.Z) < 5 do
			n8 += 1
		end

		local v12 = n8
		local x2 = x
		local z2 = z
		local n16 = 14
		local n17 = nil
		local n18 = nil

		for i = v12, #v11 do
			local position4 = v11[i].Position
			local v13 = math.sqrt((position4.X - x2) ^ 2 + (position4.Z - z2) ^ 2)

			if n16 <= v13 then
				local n19 = n16 / v13
				n17 = x2 + (position4.X - x2) * n19
				n18 = z2 + (position4.Z - z2) * n19
				break
			else
				n16 -= v13
				x2 = position4.X
				z2 = position4.Z
				n17 = nil
				n18 = nil
			end
		end

		if n17 == nil then
			return fn30(arg, v11[#v11].Position)
		end
		local vector2 = Vector3.new(n17, position3.Y + 1.5, n18)

		if not fn27(arg, arg2, arg3, vector2) then
			local v13 = v11[v12]
			if not v13 then
				return fn30(arg, position2)
			end
			local vector3 = Vector3.new(v13.Position.X - x, 0, v13.Position.Z - z)
			if vector3.Magnitude < 0.5 then
				return nil
			end
			return vector3.Unit
		end

		local vector3 = Vector3.new(n17 - x, 0, n18 - z)
		if vector3.Magnitude < 0.5 then
			return nil
		end
		return vector3.Unit
	end

	local function fn32()
		if flag5 then
			flag5 = false
			local character = localPlayer.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				humanoid.WalkSpeed = 16
				humanoid.AutoRotate = true
				humanoid:Move(Vector3.zero)
			end
		end

		tbl19 = {}
		n8 = 1
		position = nil
		v9 = nil
		v10 = nil
		n6 = 0
		flag6 = false
		flag7 = false
		flag8 = false
	end

	local function fn33()
		fn32()

		if flag4 then
			pcall(function()
				RunService:UnbindFromRenderStep("ForsakenNoliRushControl")
			end)

			flag4 = false
		end
	end

	local function fn34(...) end

	NoliLogicManager_FUNC = function()
		fn33()
		if not tbl.NoliRushControl and not tbl.NoliAutoTarget then
			return
		end

		pcall(function()
			RunService:UnbindFromRenderStep("ForsakenNoliRushControl")
			RunService:BindToRenderStep("ForsakenNoliRushControl", Enum.RenderPriority.Camera.Value + 2, fn34)
		end)

		flag4 = true
	end

	local function fn35()
		if flag9 then
			return
		end

		if module == nil and fireServerConnection == nil then
			module = require(v)
			fireServerConnection = module.FireServerConnection
		end

		module.FireServerConnection = function(arg, arg2, arg3, ...)
			local v11 = table.pack(...)
			local tbl20 = { ... }

			if arg2 == localPlayer.Name .. "VoidRushCollision" and arg3 == "REMOTE_EVENT" then
				if #tbl20 > 0 then
					if type(tbl20[1]) == "table" then
						return
					end
				end

				return
			end

			return fireServerConnection(arg, arg2, arg3, table.unpack(v11, 1, v11.n))
		end

		flag9 = true
	end

	local function fn36()
		if not flag9 then
			return
		end
		module.FireServerConnection = fireServerConnection
		flag9 = false
	end

	local v11 = Killers:AddToggle({
		Name = "Noli Rush Control",
		Callback = function(noliRushControl)
			tbl.NoliRushControl = noliRushControl
			NoliLogicManager_FUNC()
		end,
	})

	local v12 = Killers:AddToggle({
		Name = "Noli Rush Anti Crash",
		Callback = function(arg)
			if arg then
				fn35()
			else
				fn36()
			end
		end,
	})

	local v13 = Killers:AddToggle({
		Name = "Noli Rush Auto Target",
		Callback = function(noliAutoTarget)
			tbl.NoliAutoTarget = noliAutoTarget
			NoliLogicManager_FUNC()
		end,
	})

	local v14 = Killers:AddSlider({
		Name = "Dash Speed",
		Min = 50,
		Max = 200,
		Default = n9,
		Callback = function(arg)
			n9 = arg
		end,
	})

	local v15 = Killers:AddSlider({
		Name = "Rush Control Strength (%)",
		Min = 0,
		Max = 100,
		Default = 100,
		Callback = function(arg)
			n10 = math.clamp((tonumber(arg) or 100) / 100, 0, 1)
		end,
	})

	local connection5 = nil
	local tbl20 = {}
	local n16 = 10

	local function fn37()
		if connection5 then
			connection5:Disconnect()
			connection5 = nil
		end

		table.clear(tbl20)
	end

	local v16 = Killers:AddToggle({
		Name = "Auto Detonate Nova",
		Callback = function(arg)
			if arg then
				fn37()
				require(game.ReplicatedStorage.Systems.Player.Game.ProjectileReplication)
				connection5 = RunService.Heartbeat:Connect(function(...) end)
			else
				fn37()
			end
		end,
	})

	Killers:AddList({ Name = "Noli", Elems = { v11, v12, v13, v14, v15, v16 } })
end

do
	local function fn24(arg, arg2, arg3, arg4, arg5)
		if arg3 then
			local position = arg3.Position
			local v9 = arg[arg2]

			if not v9 then
				arg[arg2] = { LastPos = position, SmoothedVel = Vector3.zero }
			else
				v9.SmoothedVel = v9.SmoothedVel:Lerp((position - v9.LastPos) / arg4, arg5)
				v9.LastPos = position
			end
		else
			arg[arg2] = nil
		end
	end

	local function fn25(arg)
		if arg.Connections.AimLoop then
			arg.Connections.AimLoop:Disconnect()
			arg.Connections.AimLoop = nil
		end

		arg.State.CurrentTarget = nil
		arg.State.CurrentAbility = nil
	end

	local function fn26(arg, currentTarget, currentAbility, arg2, arg3)
		if not arg.Settings.Enabled then
			return
		end
		arg.State.CurrentTarget = currentTarget
		arg.State.CurrentAbility = currentAbility
		arg.State.AimEndTime = tick() + arg2

		if not arg.Connections.AimLoop then
			arg.Connections.AimLoop = RunService.RenderStepped:Connect(arg3)
		end
	end

	local function fn27(arg, enabled, arg2, arg3)
		arg.Settings.Enabled = enabled

		if enabled then
			if not arg.Connections.VelocityLoop then
				arg.Connections.VelocityLoop = RunService.Heartbeat:Connect(arg2)
			end

			task.spawn(arg3)
		else
			if arg.Connections.VelocityLoop then
				arg.Connections.VelocityLoop:Disconnect()
				arg.Connections.VelocityLoop = nil
			end

			fn25(arg)
			arg.State.VelocityTable = {}
		end
	end

	local function fn28(arg, arg2, arg3)
		if not arg2 or not arg2.Abilities then
			return
		end
		local tbl19 = {}

		for k in pairs(arg3) do
			if arg2.Abilities[k] and arg2.Abilities[k].Callback then
				tbl19[k] = hookfunction(arg2.Abilities[k].Callback, function(...) end)
			end
		end
	end

	local tbl19 = {
		Settings = {
			Enabled = false,
			WallCheck = false,
			FOVRadius = 150,
			SmoothFactor = 0.15,
			MassLeadTime = 0.5,
			MassPostWindup = 1,
			EntLeadTime = 0.3,
			EntPostWindup = 0.3,
		},
		State = {
			HooksInstalled = false,
			CurrentTarget = nil,
			CurrentAbility = nil,
			AimEndTime = 0,
			VelocityTable = {},
		},
		Connections = { VelocityLoop = nil, AimLoop = nil },
	}

	local function fn29(arg)
		for _, player_ in pairs(Players:GetPlayers()) do
			if player_ ~= localPlayer and player_.Character then
				fn24(tbl19.State.VelocityTable, player_, player_.Character:FindFirstChild("HumanoidRootPart"), arg, tbl19.Settings.SmoothFactor)
			end
		end
	end

	local function fn30(arg)
		local v9 = tbl19.State.VelocityTable[arg]
		if v9 then
			return v9.SmoothedVel
		end
		local humanoidRootPart = arg.Character and arg.Character:FindFirstChild("HumanoidRootPart")
		return humanoidRootPart and humanoidRootPart.AssemblyLinearVelocity or Vector3.zero
	end

	local function fn31(arg)
		if not arg or arg == localPlayer then
			return false
		end
		local character = arg.Character
		if not character then
			return false
		end
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		local humanoid = character:FindFirstChild("Humanoid")
		return humanoidRootPart and humanoid and humanoid.Health > 0
	end

	local function fn32(arg)
		if not arg then
			return false
		end
		local position = currentCamera.CFrame.Position
		local n6 = arg.Position - position
		if n6.Magnitude < 0.05 then
			return false
		end
		local n7 = n6.Unit * n6.Magnitude
		local raycastParams2 = RaycastParams.new()
		raycastParams2.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams2.FilterDescendantsInstances = { localPlayer.Character, currentCamera }
		local hit = Workspace:Raycast(position, n7, raycastParams2)
		return not hit or hit.Instance and hit.Instance:IsDescendantOf(arg.Parent)
	end

	local function fn33()
		local vector2 = Vector2.new(currentCamera.ViewportSize.X / 2, currentCamera.ViewportSize.Y / 2)
		local huge = math.huge
		local v9 = nil

		for _, player_ in pairs(Players:GetPlayers()) do
			if fn31(player_) then
				local humanoidRootPart = player_.Character.HumanoidRootPart

				if not (tbl19.Settings.WallCheck and not fn32(humanoidRootPart)) then
					local v10, v11 = currentCamera:WorldToViewportPoint(humanoidRootPart.Position)

					if v11 then
						local magnitude = (Vector2.new(v10.X, v10.Y) - vector2).Magnitude

						if magnitude <= tbl19.Settings.FOVRadius and magnitude < huge then
							huge = magnitude
							v9 = player_
						end
					end
				end
			end
		end

		return v9
	end

	local function fn34(arg, arg2)
		if not arg or not arg.Character then
			return Vector3.zero
		end
		local humanoidRootPart = arg.Character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return Vector3.zero
		end
		local v9 = fn30(arg)
		if v9.Magnitude < 2 then
			return humanoidRootPart.Position
		end
		local massLeadTime = arg2 == "MassInfection" and tbl19.Settings.MassLeadTime or tbl19.Settings.EntLeadTime
		return humanoidRootPart.Position + v9 * massLeadTime * (massLeadTime > 1 and 0.65 or 1)
	end

	local function fn35(...) end

	local function fn36()
		if tbl19.State.HooksInstalled then
			return
		end

		local ok, result = pcall(function()
			local n1x1x1x1 = assets and assets:FindFirstChild("Killers") and assets.Killers:FindFirstChild("1x1x1x1")
			return n1x1x1x1 and require(n1x1x1x1.Behavior)
		end)

		if not ok or not result then
			return
		end

		fn28(tbl19, result, {
			MassInfection = {
				BaseWindup = 0.6,
				GetPostWindup = function()
					return tbl19.Settings.MassPostWindup
				end,
			},
			Entanglement = {
				BaseWindup = 0.45,
				GetPostWindup = function()
					return tbl19.Settings.EntPostWindup
				end,
			},
		}, fn35, fn33)

		tbl19.State.HooksInstalled = true
	end

	local function fn37(arg)
		fn27(tbl19, arg, fn29, fn36)
	end

	local tbl20 = {
		Settings = {
			Enabled = false,
			VelocitySmoothFactor = 0.15,
			AimSmoothness = 0.15,
			CorruptLeadTime = 0.5,
			CorruptPostWindup = 2.5,
			SpinAim = false,
			SpinSpeed = 20,
			DoubleStrike = false,
			DoubleStrikeSpeed = 25,
			DoubleStrikeWidth = 20,
		},
		State = {
			HooksInstalled = false,
			CurrentTarget = nil,
			CurrentAbility = nil,
			AimEndTime = 0,
			VelocityTable = {},
		},
		Connections = { VelocityLoop = nil, AimLoop = nil },
	}

	local function fn38(arg)
		for _, child in ipairs(survivors:GetChildren()) do
			local velocitySmoothFactor = tbl20.Settings.VelocitySmoothFactor
			fn24(tbl20.State.VelocityTable, child, child:FindFirstChild("HumanoidRootPart"), arg, velocitySmoothFactor)
		end
	end

	local function fn39(arg)
		local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return Vector3.zero
		end
		local smoothedVel = tbl20.State.VelocityTable[arg]
		smoothedVel = smoothedVel and smoothedVel.SmoothedVel or humanoidRootPart.AssemblyLinearVelocity
		if smoothedVel.Magnitude < 2 then
			return humanoidRootPart.Position
		end
		return humanoidRootPart.Position + smoothedVel * tbl20.Settings.CorruptLeadTime
	end

	local function fn40(...) end

	local function fn41()
		if tbl20.State.HooksInstalled then
			return
		end

		local ok, result = pcall(function()
			return require(ReplicatedStorage.Assets.Killers.JohnDoe.Behavior)
		end)

		if not ok or not result then
			return
		end

		fn28(tbl20, result, {
			CorruptEnergy = {
				BaseWindup = 0.7,
				GetPostWindup = function()
					return tbl20.Settings.CorruptPostWindup
				end,
			},
		}, fn40, function()
			local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart then
				humanoidRootPart = fn14({
					OriginPos = humanoidRootPart.Position,
					SearchType = "World_3D",
					TargetFolder = survivors,
					MaxDistance = math.huge,
					IgnoreList = localPlayer.Character and { localPlayer.Character } or {},
				})
			end

			return humanoidRootPart
		end)

		tbl20.State.HooksInstalled = true
	end

	local function fn42(arg)
		fn27(tbl20, arg, fn38, fn41)
	end

	local v9 = Killers:AddToggle({ Name = "Enable 1x4 Aimbot", Callback = fn37 })

	local v10 = Killers:AddToggle({
		Name = "Wall Check",
		Callback = function(wallCheck)
			tbl19.Settings.WallCheck = wallCheck
		end,
	})

	local v11 = Killers:AddSlider({
		Name = "FOV Radius",
		Min = 50,
		Max = 800,
		Default = tbl19.Settings.FOVRadius,
		Callback = function(fovRadius)
			tbl19.Settings.FOVRadius = fovRadius
		end,
	})

	local v12 = Killers:AddSlider({
		Name = "MassInfection prediction",
		Min = 0,
		Max = 2.5,
		Default = tbl19.Settings.MassLeadTime,
		Callback = function(massLeadTime)
			tbl19.Settings.MassLeadTime = massLeadTime
		end,
	})

	local v13 = Killers:AddSlider({
		Name = "Entanglement prediction",
		Min = 0,
		Max = 2.5,
		Default = tbl19.Settings.EntLeadTime,
		Callback = function(entLeadTime)
			tbl19.Settings.EntLeadTime = entLeadTime
		end,
	})

	Killers:AddList({ Name = "1x1x1x1", Elems = { v9, v10, v11, v12, v13 } })
	local v14 = Killers:AddToggle({ Name = "Enable John Doe Aimbot", Callback = fn42 })

	local v15 = Killers:AddToggle({
		Name = "Spin Aim Mode",
		Callback = function(spinAim)
			tbl20.Settings.SpinAim = spinAim
		end,
	})

	local v16 = Killers:AddToggle({
		Name = "Double Strike Mode",
		Callback = function(doubleStrike)
			tbl20.Settings.DoubleStrike = doubleStrike
		end,
	})

	local v17 = Killers:AddSlider({
		Name = "Spin Speed",
		Min = 10,
		Max = 100,
		Default = 20,
		Callback = function(spinSpeed)
			tbl20.Settings.SpinSpeed = spinSpeed
		end,
	})

	local v18 = Killers:AddSlider({
		Name = "Prediction Time",
		Min = 0,
		Max = 2,
		Default = 0.5,
		Callback = function(corruptLeadTime)
			tbl20.Settings.CorruptLeadTime = corruptLeadTime
		end,
	})

	Killers:AddList({ Name = "John Doe", Elems = { v14, v15, v16, v17, v18 } })
end

do
	local connection5 = nil
	local connection6 = nil
	local flag4 = false
	local n6 = 90
	local flag5 = false

	local function fn24()
		return hookmetamethod ~= nil and getnamecallmethod ~= nil
	end

	local flag6 = false

	local function fn25(arg)
		if not fn24() then
			return
		end
		flag4 = arg

		if not flag6 then
			flag6 = true
			forsakenFK.namecall.add(function(...) end)
		end
	end

	local function fn26(arg)
		if arg then
			if connection5 then
				connection5:Disconnect()
			end

			connection5 = RunService.Stepped:Connect(function(...) end)
		elseif connection5 then
			connection5:Disconnect()
			connection5 = nil
		end
	end

	local function fn27(arg)
		if arg then
			if connection6 then
				connection6:Disconnect()
			end

			connection6 = RunService.Stepped:Connect(function(...) end)
		else
			if connection6 then
				connection6:Disconnect()
				connection6 = nil
			end

			flag5 = false
		end
	end

	local v9 = Killers:AddToggle({ Name = "OverRide Anti collision (rage)", Callback = fn25 })
	local v10 = Killers:AddToggle({ Name = "OverRide Control (rage)", Callback = fn26 })
	local v11 = Killers:AddToggle({ Name = "Custom Walk Speed", Callback = fn27 })

	local v12 = Killers:AddSlider({
		Name = "Override Speed",
		Min = 30,
		Max = 150,
		Default = 90,
		Callback = function(arg)
			n6 = arg
		end,
	})

	Killers:AddList({ Name = "C00lKidd", Elems = { v9, v10, v11, v12 } })
end

do
	local v9 = nil
	local v10 = nil

	local function fn24(arg)
		if arg then
			if not v9 then
				local ok, result = pcall(function()
					return require(ReplicatedStorage.Assets.Killers.Slasher.Behavior)
				end)

				if ok and result then
					v9 = result
				end
			end

			if v9 and v9.Abilities and v9.Abilities.RagingPace and v9.Abilities.RagingPace.Callback then
				if not v10 then
					v10 = hookfunction(v9.Abilities.RagingPace.Callback, function(...) end)
				end
			end
		end
	end

	local v11 = Killers:AddToggle({
		Name = "Custom Raging Pace Speed",
		Callback = function(customRagingPaceSpeed)
			tbl.CustomRagingPaceSpeed = customRagingPaceSpeed
			fn24(true)
		end,
	})

	local v12 = Killers:AddSlider({
		Name = "Raging Pace Speed Multiplier",
		Min = 1,
		Max = 3,
		Default = tbl.RagingPaceSpeedValue,
		Callback = function(ragingPaceSpeedValue)
			tbl.RagingPaceSpeedValue = ragingPaceSpeedValue
		end,
	})

	Killers:AddList({ Name = "Slasher", Elems = { v11, v12 } })
end

local tbl19 = { State = { HooksInstalled = false } }

InstallSixerHooks = function()
	if tbl19.State.HooksInstalled then
		return
	end

	local ok, result = pcall(function()
		return require(ReplicatedStorage.Assets.Killers.Sixer.Behavior)
	end)

	if not ok or not result then
		return
	end
	local tbl20 = {}

	local function fn24(arg)
		if result.Abilities and result.Abilities[arg] then
			local callback = result.Abilities[arg].Callback

			if callback then
				tbl20[arg] = hookfunction(callback, function(...) end)
			end
		end
	end

	fn24("DemonicPursuit", 1.5)
	tbl19.State.HooksInstalled = true
end

local v9 = Killers:AddToggle({
	Name = "Demonic Pursuit Auto Aim",
	Callback = function(demonicPursuitAim)
		tbl.DemonicPursuitAim = demonicPursuitAim

		if demonicPursuitAim then
			InstallSixerHooks()
		end
	end,
})

Killers:AddList({ Name = "Sixer", Elems = { v9 } })
task.wait()
local tbl20

do
	local Aimbot = Main:AddTab("Aimbot", "Aim")
	Aimbot:AddSection("Silent Aim")
	tbl20 = { Enabled = false, SelectedTarget = {}, GeneralLeadTime = 0.15 }

	Aimbot:AddDropdown({
		Name = "Aim Target",
		Options = {
			"Void Star",
			"Corrupt Nature",
			"Infernal Cry",
			"Hunter's Feast",
			"Crystal Pitch",
			"Plasma Beam",
			"Tentacles (Grab)",
		},
		Multi = true,
		Callback = function(selectedTarget)
			tbl20.SelectedTarget = selectedTarget
		end,
	})

	Aimbot:AddToggle({
		Name = "Enable Silent Aim",
		Callback = function(enabled)
			tbl20.Enabled = enabled

			if enabled then
				fn21()
			end
		end,
	})

	Aimbot:AddSlider({
		Name = "Silent Aim Lead (ms)",
		Min = 0,
		Max = 500,
		Default = 150,
		Callback = function(arg)
			tbl20.GeneralLeadTime = arg / 1000
		end,
	})

	Aimbot:AddSection("Manual Aim")

	local tbl21 = {
		HeartbeatConn = nil,
		CharAddedConn = nil,
		CharRemovingConn = nil,
		isAimBotActive = false,
		mobileButtonCreated = false,
		MobileAimButton = nil,
		MobileAimClose = nil,
		screenGui = nil,
		aimPauseUntil = 0,
	}

	local function fn24(arg)
		tbl21.aimPauseUntil = tick() + arg
	end

	local function fn25()
		if tbl21.HeartbeatConn then
			tbl21.HeartbeatConn:Disconnect()
			tbl21.HeartbeatConn = nil
		end

		if tbl21.CharAddedConn then
			tbl21.CharAddedConn:Disconnect()
			tbl21.CharAddedConn = nil
		end

		if tbl21.CharRemovingConn then
			tbl21.CharRemovingConn:Disconnect()
			tbl21.CharRemovingConn = nil
		end

		tbl21.isAimBotActive = false
		tbl.CurrentTarget = nil
	end

	local tbl22 = {}

	local function fn26(arg)
		local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return Vector3.zero
		end
		local now = os.clock()
		local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity

		if assemblyLinearVelocity.Magnitude > 120 then
			assemblyLinearVelocity = Vector3.zero
		end

		local tbl23 = tbl22[arg]

		if not tbl23 then
			tbl23 = { t = now, v = assemblyLinearVelocity }
			tbl22[arg] = tbl23
		else
			tbl23.v = tbl23.v:Lerp(assemblyLinearVelocity, math.clamp(1 - math.exp(-math.max(now - tbl23.t, 0.001) * 10), 0, 1))
			tbl23.t = now
		end

		return tbl23.v
	end

	local function fn27(arg)
		local aimBotPart = tbl.AimBotPart
		local head

		if aimBotPart == "Head" then
			head = arg:FindFirstChild("Head")
		else
			head = nil

			if aimBotPart == "Torso" then
				head = arg:FindFirstChild("UpperTorso") or arg:FindFirstChild("Torso")
			end
		end

		return head or arg:FindFirstChild("HumanoidRootPart") or arg.PrimaryPart
	end

	local function fn28(arg, arg2, arg3, arg4)
		local v10 = forsakenFK.rayParams({ arg2 })
		local position = arg.CFrame.Position
		local hit = workspace:Raycast(position, arg4.Position + Vector3.new(0, 1, 0) - position, v10)
		if hit and not hit.Instance:IsDescendantOf(arg3) then
			return false
		end
		return true
	end

	local function fn29()
		fn25()
		if not tbl.AimBot then
			return
		end
		tbl21.isAimBotActive = true
		local v10 = localPlayer

		tbl21.CharAddedConn = v10.CharacterAdded:Connect(function()
			task.wait(1)
			tbl.CurrentTarget = nil
			table.clear(tbl22)
		end)

		tbl21.CharRemovingConn = v10.CharacterRemoving:Connect(function()
			tbl.CurrentTarget = nil
		end)

		tbl21.HeartbeatConn = RunService.Heartbeat:Connect(function(...) end)
	end

	local function fn30()
		if tbl21.mobileButtonCreated then
			return
		end

		local v10 = fn7({
			name = "MobileAim",
			text = tbl.AimBot and "AIM ON" or "AIM OFF",
			position = UDim2.new(0.8, 0, 0.7, 0),
			backgroundColor3 = Color3.fromRGB(30, 30, 30),
			borderColor3 = Color3.fromRGB(0, 120, 215),
			onClick = function(arg)
				tbl.AimBot = not tbl.AimBot
				fn29()
				arg.Text = tbl.AimBot and "AIM ON" or "AIM OFF"

				if AimBotToggle then
					AimBotToggle:SetState(tbl.AimBot)
				end
			end,
			onClose = function()
				tbl21.mobileButtonCreated = false
				tbl21.MobileAimButton = nil
				tbl21.MobileAimClose = nil
			end,
		})

		if v10 then
			tbl21.screenGui = v10.gui
			tbl21.MobileAimButton = v10.button
			tbl21.MobileAimClose = v10.closeButton
			tbl21.mobileButtonCreated = true
		end
	end

	local v10 = Aimbot:AddToggle({
		Name = "Enable Aim Bot",
		Description = "Automatically aim at players",
		Callback = function(aimBot)
			tbl.AimBot = aimBot
			fn29()

			if UserInputService.TouchEnabled then
				if tbl.AimBot and not tbl21.mobileButtonCreated then
					fn30()
				elseif tbl21.mobileButtonCreated and tbl21.MobileAimButton then
					tbl21.MobileAimButton.Text = tbl.AimBot and "AIM ON" or "AIM OFF"
				end
			end
		end,
	})

	Aimbot:AddDropdown({
		Name = "Aim Method",
		Description = "Choose aim method",
		Options = { "Camera Lock", "HumanoidRoot Lock", "HumanoidRoot Lock + Camera Lock" },
		Default = tbl.AimBotMethod,
		Callback = function(aimBotMethod)
			tbl.AimBotMethod = aimBotMethod
		end,
	})

	Aimbot:AddDropdown({
		Name = "Target Type",
		Description = "Choose who to aim at",
		Options = { "Auto", "Survivors", "Killers" },
		Default = tbl.AimTargetType,
		Callback = function(aimTargetType)
			tbl.AimTargetType = aimTargetType
			tbl.CurrentTarget = nil
		end,
	})

	Aimbot:AddToggle({
		Name = "Wall Check",
		Description = "Aim only at visible players",
		Default = tbl.WallCheck or false,
		Callback = function(wallCheck)
			tbl.WallCheck = wallCheck
			tbl.CurrentTarget = nil
		end,
	})

	Aimbot:AddToggle({
		Name = "Single Target Mode",
		Description = "Lock onto the target and dont let go",
		Default = tbl.SingleTargetMode,
		Callback = function(singleTargetMode)
			tbl.SingleTargetMode = singleTargetMode

			if not singleTargetMode then
				tbl.CurrentTarget = nil
			end
		end,
	})

	Aimbot:AddKeybind({
		Name = "Enable Aim Bot",
		Callback = function()
			tbl.AimBot = not tbl.AimBot
			v10:SetState(tbl.AimBot)
		end,
	})

	Aimbot:AddSlider({
		Name = "Aim Distance (studs)",
		Description = "Maximum distance to aim",
		Min = 5,
		Max = 500,
		Default = tbl.AimBotDistance,
		Callback = function(aimBotDistance)
			tbl.AimBotDistance = aimBotDistance
		end,
	})

	Aimbot:AddSlider({
		Name = "Prediction",
		Description = "Aim prediction for moving targets",
		Min = 0,
		Max = 2,
		Default = tbl.AimBotPrediction,
		Callback = function(aimBotPrediction)
			tbl.AimBotPrediction = aimBotPrediction
		end,
	})

	Aimbot:AddSlider({
		Name = "Aim Smoothness",
		Description = "Higher = slower, more human-like",
		Min = 1,
		Max = 100,
		Default = tbl.AimBotSmoothness,
		Callback = function(aimBotSmoothness)
			tbl.AimBotSmoothness = aimBotSmoothness
		end,
	})

	Aimbot:AddDropdown({
		Name = "Aim Part",
		Options = { "Head", "Torso", "HumanoidRootPart" },
		Default = tbl.AimBotPart,
		Callback = function(aimBotPart)
			tbl.AimBotPart = aimBotPart
		end,
	})

	Aimbot:AddToggle({
		Name = "Ping Prediction",
		Description = "Adds half of your ping as lead time",
		Default = tbl.AimBotPingComp,
		Callback = function(aimBotPingComp)
			tbl.AimBotPingComp = aimBotPingComp
		end,
	})
end

task.wait()

do
	local Antis = Main:AddTab("Antis", "Block")
	local statusEffects = nil

	pcall(function()
		statusEffects = modules.Schematics.StatusEffects
	end)

	local tbl21 = {}
	local tbl22 = {}

	local function fn24(arg)
		if statusEffects:FindFirstChild(arg) then
			return statusEffects[arg]
		end

		for _, v10 in pairs({ "KillerExclusive", "SurvivorExclusive" }) do
			local v11 = statusEffects:FindFirstChild(v10)
			if v11 and v11:FindFirstChild(arg) then
				return v11[arg]
			end
		end

		return nil
	end

	local function fn25(arg)
		local v10 = fn24(arg)
		if not v10 or tbl22[v10] then
			return
		end
		local ok, result = pcall(require, v10)

		if ok and type(result) == "table" then
			for k, v11 in pairs(result) do
				if type(v11) == "function" then
					result[k] = function(...)
						if tbl21[arg] then
							return
						end
						return v11(...)
					end
				end
			end

			tbl22[v10] = true
		end
	end

	local function fn26()
		if tbl.AntiFallSlowness then
			task.spawn(function()
				while tbl.AntiFallSlowness do
					local character = localPlayer.Character

					if character then
						if character:GetAttribute("NoFallSlow") ~= true then
							character:SetAttribute("NoFallSlow", true)
						end
					end

					task.wait(1)
				end
			end)
		else
			local character = localPlayer.Character

			if character then
				character:SetAttribute("NoFallSlow", false)
			end
		end
	end

	local DirectionalSpeed = nil

	pcall(function()
		DirectionalSpeed = require(ReplicatedStorage.Systems.Character.QualityOfLife.DirectionalSpeed)
	end)

	local function fn27()
		if tbl.DisableDirectionalMovement then
			task.spawn(function()
				while tbl.DisableDirectionalMovement do
					local character = localPlayer.Character

					if character then
						character:SetAttribute("DirectionalMovementDisabled", true)
					end

					task.wait(0.2)
				end
			end)
		else
			local character = localPlayer.Character

			if character then
				character:SetAttribute("DirectionalMovementDisabled", false)
			end
		end
	end

	local tbl23 = {}

	table.insert(tbl23, Antis:AddToggle({
		Name = "Anti fall slowness",
		Callback = function(antiFallSlowness)
			tbl.AntiFallSlowness = antiFallSlowness
			fn26()
		end,
	}))

	for _, v10 in pairs({ "Slowness", "Stunned" }) do
		tbl21[v10] = false

		table.insert(tbl23, Antis:AddToggle({
			Name = "Anti " .. v10,
			Callback = function(arg)
				tbl21[v10] = arg
				fn25(v10)
			end,
		}))
	end

	table.insert(tbl23, Antis:AddToggle({
		Name = "Disable directional speed",
		Callback = function(disableDirectionalSpeed)
			tbl.DisableDirectionalSpeed = disableDirectionalSpeed

			if DirectionalSpeed then
				if disableDirectionalSpeed then
					pcall(function()
						DirectionalSpeed:Destroy()
					end)
				else
					pcall(function()
						DirectionalSpeed:Start()
					end)
				end
			end
		end,
	}))

	table.insert(tbl23, Antis:AddToggle({
		Name = "Disable directional movement",
		Callback = function(disableDirectionalMovement)
			tbl.DisableDirectionalMovement = disableDirectionalMovement
			fn27()
		end,
	}))

	Antis:AddList({ Name = "Movement", Elems = tbl23 })
	local tbl24 = {}

	for _, v10 in pairs({
		{ Id = "Bleeding", Name = "Bleeding (Low HP)" },
		{ Id = "Nausea", Name = "Nausea (Low HP)" },
		{ Id = "Blindness", Name = "Blindness (Guest 666,1x1x1x1)" },
		{ Id = "Confusion", Name = "Confusion" },
		{ Id = "Hacked", Name = "Hacked (1x1x1x1)" },
		{ Id = "Glitched", Name = "Glitched (1x1x1x1)" },
		{ Id = "Corrupted", Name = "Corrupted (John Doe)" },
		{ Id = "Hallucination", Name = "Hallucination (noli)" },
		{ Id = "Oblivious", Name = "Oblivious (Nosferatu)" },
		{ Id = "Subspaced", Name = "Subspaced (Taph)" },
	}) do
		local id = v10.Id
		local name = v10.Name
		tbl21[id] = false

		table.insert(tbl24, Antis:AddToggle({
			Name = "Anti " .. name,
			Callback = function(arg)
				tbl21[id] = arg
				fn25(id)
			end,
		}))
	end

	Antis:AddList({ Name = "Debuffs", Elems = tbl24 })
	local connection5 = nil
	local connection6 = nil
	local connection7 = nil
	local connection8 = nil
	local connection9 = nil
	local connection10 = nil
	local connection11 = nil
	local connection12 = nil

	local function fn28()
		if connection5 then
			connection5:Disconnect()
			connection5 = nil
		end

		if tbl.DeleteTrail then
			for _, child in ipairs(ingame:GetChildren()) do
				if string.sub(child.Name, -12) == "JohnDoeTrail" then
					child:Destroy()
				end
			end

			connection5 = ingame.ChildAdded:Connect(function(child)
				if string.sub(child.Name, -12) == "JohnDoeTrail" then
					task.wait()
					child:Destroy()
				end
			end)
		end
	end

	local function fn29()
		if connection6 then
			connection6:Disconnect()
			connection6 = nil
		end

		local canTouch = not tbl.WalkablePuddle

		for _, descendant in ipairs(ingame:GetDescendants()) do
			if descendant:IsA("BasePart") and (descendant.Name == "Shadow" or string.sub(descendant.Name, -6) == "Puddle") then
				descendant.CanTouch = canTouch
			end
		end

		if tbl.WalkablePuddle then
			connection6 = ingame.DescendantAdded:Connect(function(descendant)
				if descendant:IsA("BasePart") and (descendant.Name == "Shadow" or string.sub(descendant.Name, -6) == "Puddle") then
					task.wait()

					if tbl.WalkablePuddle and descendant and descendant.Parent then
						descendant.CanTouch = false
					end
				end
			end)
		end
	end

	local function fn30()
		if connection7 then
			connection7:Disconnect()
			connection7 = nil
		end

		if tbl.DeleteSpikes then
			for _, child in ipairs(ingame:GetChildren()) do
				if child.Name == "Spike" or child.Name == "SpikeCollision" then
					child:Destroy()
				end
			end

			connection7 = ingame.ChildAdded:Connect(function(child)
				if child.Name == "Spike" or child.Name == "SpikeCollision" then
					task.wait()

					if tbl.DeleteSpikes and child and child.Parent then
						child:Destroy()
					end
				end
			end)
		end
	end

	local function fn31()
		if connection8 then
			connection8:Disconnect()
			connection8 = nil
		end

		if tbl.AntiFakeGenerators then
			for _, descendant in ipairs(ingame:GetDescendants()) do
				if descendant.Name == "FakeGenerator" or descendant.Name == "Fake Generator" then
					descendant:Destroy()
				end
			end

			connection8 = ingame.DescendantAdded:Connect(function(descendant)
				if descendant.Name == "FakeGenerator" or descendant.Name == "Fake Generator" then
					task.wait()

					if tbl.AntiFakeGenerators and descendant and descendant.Parent then
						descendant:Destroy()
					end
				end
			end)
		end
	end

	local function fn32()
		if connection9 then
			connection9:Disconnect()
			connection9 = nil
		end

		if tbl.AntiFakeNoli then
			for _, descendant in ipairs(ingame:GetDescendants()) do
				if descendant.Name == "Fake Noli" or descendant.Name == "FakeNoli" then
					descendant:Destroy()
				end
			end

			connection9 = ingame.DescendantAdded:Connect(function(descendant)
				if descendant.Name == "Fake Noli" or descendant.Name == "FakeNoli" then
					task.wait()

					if tbl.AntiFakeNoli and descendant and descendant.Parent then
						descendant:Destroy()
					end
				end
			end)
		end
	end

	local function fn33()
		if connection10 then
			connection10:Disconnect()
			connection10 = nil
		end

		if tbl.AntiClone007n7 then
			local n007n7 = ingame:FindFirstChild("007n7")

			if n007n7 then
				n007n7:Destroy()
			end

			connection10 = ingame.ChildAdded:Connect(function(child)
				if child.Name == "007n7" then
					task.wait()

					if tbl.AntiClone007n7 and child and child.Parent then
						child:Destroy()
					end
				end
			end)
		end
	end

	local function fn34()
		if connection11 then
			connection11:Disconnect()
			connection11 = nil
		end

		if connection12 then
			connection12:Disconnect()
			connection12 = nil
		end

		if tbl.AntiPull then
			local function fn35(character)
				if not character then
					return
				end
				local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)

				if humanoidRootPart then
					local function fn36(arg)
						if fn10(character) == "Killers" then
							return
						end

						if arg.Name == "CatchVelocity" then
							arg:Destroy()
						elseif arg:IsA("AlignPosition") or arg:IsA("LinearVelocity") or arg:IsA("BodyVelocity") or arg:IsA("BodyPosition") then
							arg:Destroy()
						end
					end

					for _, child in ipairs(humanoidRootPart:GetChildren()) do
						fn36(child)
					end

					connection11 = humanoidRootPart.ChildAdded:Connect(function(child)
						task.wait()

						if tbl.AntiPull and child and child.Parent then
							fn36(child)
						end
					end)
				end
			end

			fn35(localPlayer.Character)
			connection12 = localPlayer.CharacterAdded:Connect(fn35)
		end
	end

	local connection13 = nil
	local connection14 = nil

	local function fn35(arg)
		if connection13 then
			connection13:Disconnect()
			connection13 = nil
		end

		if connection14 then
			connection14:Disconnect()
			connection14 = nil
		end

		local function fn36(arg2)
			if not arg2 then
				return
			end
			local mapBoundaries = arg2:FindFirstChild("MapBoundaries")
			if not mapBoundaries then
				return
			end

			local function fn37(arg3)
				if not arg3 then
					return
				end

				for _, descendant in ipairs(arg3:GetDescendants()) do
					if descendant:IsA("BasePart") then
						descendant.CanCollide = not arg
					end
				end
			end

			local killerDoors = mapBoundaries:FindFirstChild("KillerDoors")
			local killerOnly = mapBoundaries:FindFirstChild("KillerOnly")

			if not arg then
				fn37(killerDoors)
				fn37(killerOnly)
				return
			end

			fn37(killerDoors)
			fn37(killerOnly)

			connection13 = mapBoundaries.DescendantAdded:Connect(function(descendant)
				local isBasePart = descendant:IsA("BasePart")

				if isBasePart then
					isBasePart = descendant:IsDescendantOf(killerDoors or descendant)

					if not isBasePart then
						isBasePart = descendant:IsDescendantOf(killerOnly or descendant)
					end
				end

				if isBasePart then
					descendant.CanCollide = false
				end
			end)
		end

		local map = ingame:FindFirstChild("Map")

		if map then
			fn36(map)
		end

		connection14 = ingame.ChildAdded:Connect(function(child)
			if child.Name == "Map" then
				fn36(child)
			end
		end)
	end

	local tbl25 = {}
	local v10 = Antis:AddToggle({ Name = "Disable killer Door Collision", Callback = fn35 })

	local v11 = Antis:AddToggle({
		Name = "Delete Trail",
		Callback = function(deleteTrail)
			tbl.DeleteTrail = deleteTrail
			fn28()
		end,
	})

	local v12 = Antis:AddToggle({
		Name = "Delete Spikes",
		Callback = function(deleteSpikes)
			tbl.DeleteSpikes = deleteSpikes
			fn30()
		end,
	})

	local v13 = Antis:AddToggle({
		Name = "Walkable John Doe & Nos puddle",
		Callback = function(walkablePuddle)
			tbl.WalkablePuddle = walkablePuddle
			fn29()
		end,
	})

	local v14 = Antis:AddToggle({
		Name = "Anti Fake Generators",
		Callback = function(antiFakeGenerators)
			tbl.AntiFakeGenerators = antiFakeGenerators
			fn31()
		end,
	})

	local v15 = Antis:AddToggle({
		Name = "Anti Fake Noli",
		Callback = function(antiFakeNoli)
			tbl.AntiFakeNoli = antiFakeNoli
			fn32()
		end,
	})

	local v16 = Antis:AddToggle({
		Name = "Anti Clone 007n7",
		Callback = function(antiClone007n7)
			tbl.AntiClone007n7 = antiClone007n7
			fn33()
		end,
	})

	local addToggle = Antis.AddToggle
	tbl25[1] = v10
	tbl25[2] = v11
	tbl25[3] = v12
	tbl25[4] = v13
	tbl25[5] = v14
	tbl25[6] = v15
	tbl25[7] = v16

	do
		local values = table.pack(addToggle(Antis, {
		Name = "Anti Pull",
		Description = "Bloodhook, Void Star & Azure tentacles",
		Callback = function(antiPull)
			tbl.AntiPull = antiPull
			fn34()
		end,
	}))

		table.move(values, 1, values.n, 8, tbl25)
	end

	Antis:AddList({ Name = "Utilities", Elems = tbl25 })
end

task.wait()
local Misc
Misc = Main:AddTab("Misc", "Misc")

do
	local connection5 = nil
	Misc:AddSection("Gameplay")
	local flag4 = false

	Misc:AddButton({
		Name = "Change Mobile UI",
		Callback = function()
			if flag4 then
				v2:Notification({
					Name = "Mobile UI",
					Description = "Editor already loaded - use the small UI button on the left",
					Duration = 4,
				})

				return
			end

			flag4 = true

			fn2("https://raw.githubusercontent.com/zxcursedsocute/Fish-It/refs/heads/main/nighier", nil, function()
				flag4 = false
				v2:Notification({ Name = "Mobile UI", Description = "Failed to load editor", Duration = 4 })
			end)
		end,
	})

	local function fn24(arg)
		local return_ = arg:FindFirstChild("Return", true)

		if return_ then
			firesignal(return_.MouseButton1Click)
		end
	end

	local function fn25()
		for _, child in pairs(playerGui:GetChildren()) do
			if child.Name == "EndScreen" then
				task.wait(0.1)
				fn24(child)
			end
		end

		connection5 = playerGui.ChildAdded:Connect(function(child)
			if child.Name == "EndScreen" then
				task.wait(0.2)
				fn24(child)
			end
		end)
	end

	Misc:AddToggle({
		Name = "Auto Close End Game Screen",
		Callback = function(autoCloseEndGameScreen)
			tbl.AutoCloseEndGameScreen = autoCloseEndGameScreen

			if autoCloseEndGameScreen then
				fn25()
			elseif connection5 then
				connection5:Disconnect()
				connection5 = nil
			end
		end,
	})
end

Misc:AddToggle({
	Name = "Disable AFK Insanity",
	Callback = function(disableAFKInsanity)
		tbl.DisableAFKInsanity = disableAFKInsanity

		if disableAFKInsanity then
			task.spawn(function()
				while tbl.DisableAFKInsanity do
					firesignal(UserInputService.InputEnded, {})
					task.wait(5)
				end
			end)
		end
	end,
})

Misc:AddSection("Lighting")

do
	local color2 = Color3.fromRGB(128, 128, 128)
	local color3 = Color3.fromRGB(220, 220, 220)
	local connection5 = nil
	local connection6 = nil

	local function fn24()
		if Lighting.FogEnd ~= 9999 then
			Lighting.FogEnd = 9999
		end

		if Lighting.GlobalShadows ~= false then
			Lighting.GlobalShadows = false
		end

		if Lighting.OutdoorAmbient ~= color2 then
			Lighting.OutdoorAmbient = color2
		end

		if Lighting.Ambient ~= color3 then
			Lighting.Ambient = color3
		end

		local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

		if atmosphere then
			atmosphere:Destroy()
		end
	end

	Misc:AddToggle({
		Name = "Full Bright + No Fog",
		Callback = function(arg)
			if arg then
				fn24()
				connection5 = Lighting.Changed:Connect(fn24)
				connection6 = Lighting.ChildAdded:Connect(fn24)
			else
				if connection5 then
					connection5:Disconnect()
					connection5 = nil
				end

				if connection6 then
					connection6:Disconnect()
					connection6 = nil
				end
			end
		end,
	})
end

Misc:AddSection("Chat")

do
	local chatWindowConfiguration = nil
	local connection5 = nil
	local connection6 = nil

	local function fn24()
		if not chatWindowConfiguration then
			chatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")
		end

		if chatWindowConfiguration and chatWindowConfiguration.Enabled ~= true then
			chatWindowConfiguration.Enabled = true
		end
	end

	Misc:AddToggle({
		Name = "Turn on chat",
		Callback = function(arg)
			if arg then
				fn24()

				if chatWindowConfiguration then
					connection5 = chatWindowConfiguration:GetPropertyChangedSignal("Enabled"):Connect(fn24)
				end

				connection6 = TextChatService.ChildAdded:Connect(function(child)
					if child:IsA("ChatWindowConfiguration") then
						chatWindowConfiguration = child
						fn24()

						if connection5 then
							connection5:Disconnect()
						end

						connection5 = chatWindowConfiguration:GetPropertyChangedSignal("Enabled"):Connect(fn24)
					end
				end)
			else
				if connection5 then
					connection5:Disconnect()
					connection5 = nil
				end

				if connection6 then
					connection6:Disconnect()
					connection6 = nil
				end
			end
		end,
	})
end

do
	local flag4 = false

	local function fn24()
		flag4 = tbl.SidebarVisibility
		local sidebarHandler = ReplicatedStorage:FindFirstChild("Systems") and ReplicatedStorage.Systems:FindFirstChild("Player") and ReplicatedStorage.Systems.Player:FindFirstChild("UI") and ReplicatedStorage.Systems.Player.UI:FindFirstChild("SidebarHandler")
		local v10 = nil

		if sidebarHandler then
			local ok, result = pcall(require, sidebarHandler)

			if ok and type(result) == "table" then
				v10 = result
			end
		end

		if not flag4 then
			if v10 then
				pcall(function()
					v10:ToggleSidebarButtons(false)
				end)
			end

			local mainUI = playerGui:FindFirstChild("MainUI")
			local sidebar = mainUI and mainUI:FindFirstChild("Sidebar")

			if sidebar then
				sidebar.Visible = false
			end

			return
		end

		task.spawn(function()
			while flag4 and tbl.SidebarVisibility do
				if v10 then
					pcall(function()
						v10:ToggleSidebarButtons(true)
					end)
				end

				local mainUI = playerGui:FindFirstChild("MainUI")
				mainUI = mainUI and mainUI:FindFirstChild("Sidebar")

				if mainUI and mainUI.Visible ~= true then
					mainUI.Visible = true
				end

				task.wait(0.2)
			end
		end)
	end

	Misc:AddToggle({
		Name = "Enable Sidebar Visibility",
		Callback = function(sidebarVisibility)
			tbl.SidebarVisibility = sidebarVisibility
			fn24()
		end,
	})
end

Misc:AddSection("Camera")

Misc:AddToggle({
	Name = "Infinite Zoom + Noclip",
	Callback = function(arg)
		if arg then
			localPlayer.CameraMaxZoomDistance = 10000
		else
			localPlayer.CameraMaxZoomDistance = 12
		end

		local setconstant_ = debug and debug.setconstant or setconstant
		local getconstants_ = debug and debug.getconstants or getconstants
		local popper = localPlayer.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper

		for _, v10 in pairs(getgc()) do
			if type(v10) == "function" and getfenv(v10).script == popper then
				for k, v11 in pairs(getconstants_(v10)) do
					local num = tonumber(v11)

					if arg and num == 0.25 then
						setconstant_(v10, k, 0)
					elseif not arg and num == 0 then
						setconstant_(v10, k, 0.25)
					end
				end
			end
		end
	end,
})

Misc:AddSection("Performance")

Misc:AddButton({
	Name = "Anti Lags",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/zxcursedsocute/Forsaken-Script/refs/heads/main/test"))()
	end,
})

Misc:AddSection("Spoof Device")

do
	local str4 = "PC"
	local flag4 = false

	Misc:AddDropdown({
		Name = "Choose Device",
		Options = { "PC", "Mobile", "Console", "Unknown" },
		Callback = function(arg)
			str4 = arg
		end,
	})

	Misc:AddToggle({
		Name = "Apply Changes",
		Callback = function(arg)
			local ok, result = pcall(function()
				if v then
					return require(v)
				end
				return require(ReplicatedStorage.Modules.Network.Network)
			end)

			flag4 = arg
			if not arg then
				return
			end
			local function fn24(...) end

			while wait() do
				if flag4 then
					fn24()
					continue
				end
				break
			end
		end,
	})
end

Misc:AddSection("Players & Spectate")

do
	local connection5 = nil
	local tbl21 = {}

	ShowHiddenStats = function(arg)
		if connection5 then
			connection5:Disconnect()
			connection5 = nil
		end

		if arg == false then
			for k, v10 in pairs(tbl21) do
				local playerByUserId = Players:GetPlayerByUserId(k)

				if playerByUserId and playerByUserId:FindFirstChild("PlayerData") then
					local privacy = playerByUserId.PlayerData:FindFirstChild("Settings") and playerByUserId.PlayerData.Settings:FindFirstChild("Privacy")

					if privacy then
						for k2, v11 in pairs(v10) do
							local v12 = privacy:FindFirstChild(k2)

							if v12 and v12:IsA("BoolValue") then
								v12.Value = v11
							end
						end
					end
				end
			end

			tbl21 = {}
			return
		end

		for _, player_ in ipairs(Players:GetPlayers()) do
			local privacy = player_:FindFirstChild("PlayerData") and player_.PlayerData:FindFirstChild("Settings") and player_.PlayerData.Settings:FindFirstChild("Privacy")

			if privacy then
				local userId = player_.UserId

				if not tbl21[userId] then
					tbl21[userId] = {}
				end

				local function fn24(arg2)
					local v10 = privacy:FindFirstChild(arg2)

					if v10 and v10:IsA("BoolValue") then
						tbl21[userId][arg2] = v10.Value
						v10.Value = false
					end
				end

				fn24("HideSurvivorWins")
				fn24("HidePlaytime")
				fn24("HideKillerWins")
			end
		end

		connection5 = Players.PlayerAdded:Connect(function(player_)
			player_.CharacterAdded:Wait()
			task.wait()
			local privacy = player_:FindFirstChild("PlayerData") and player_.PlayerData:FindFirstChild("Settings") and player_.PlayerData.Settings:FindFirstChild("Privacy")

			if privacy then
				local userId = player_.UserId

				if not tbl21[userId] then
					tbl21[userId] = {}
				end

				for _, v10 in ipairs({ "HideSurvivorWins", "HidePlaytime", "HideKillerWins" }) do
					local v11 = privacy:FindFirstChild(v10)

					if v11 and v11:IsA("BoolValue") then
						tbl21[userId][v10] = v11.Value
						v11.Value = false
					end
				end
			end
		end)
	end
end

Misc:AddToggle({
	Name = "Show Hidden Stats",
	Callback = function(arg)
		ShowHiddenStats(arg)
	end,
})

do
	local tbl21 = {}
	local tbl22 = {}
	local tbl23 = {}
	local tbl24 = {}
	local tbl25 = {}

	local function fn24()
		tbl23 = Players:GetPlayers()
		table.clear(tbl21)
		table.clear(tbl22)

		for _, v10 in ipairs(tbl23) do
			tbl21[v10.Name] = true
			local displayName = v10.DisplayName

			if displayName ~= v10.Name then
				tbl22[displayName] = true
			end
		end
	end

	local tbl26 = { TextLabel = true, TextButton = true, TextBox = true }

	local function fn25(arg)
		if arg.Name == "Username" or arg.Name == "ActorName" then
			local parent = arg.Parent
			if parent and parent.Name == "Spectate" then
				return true
			end
		end

		return false
	end

	local function fn26(arg)
		if not getconnections then
			return
		end

		for _, v10 in pairs(getconnections(arg.Changed)) do
			v10:Disable()
		end

		local v10 = pairs
		local v11 = table.pack(getconnections(arg:GetPropertyChangedSignal("Text")))
		v11.n = 1 + v11.n - 1
		table.move(v11, 1, v11.n, 1, v11)

		for _, v12 in v10(table.unpack(v11, 1, v11.n)) do
			v12:Disable()
		end
	end

	local function fn27()
		local mainUI = localPlayer.PlayerGui:FindFirstChild("MainUI")
		mainUI = mainUI and mainUI:FindFirstChild("Spectate")

		if mainUI then
			local username = mainUI:FindFirstChild("Username")
			local actorName = mainUI:FindFirstChild("ActorName")

			if username then
				fn26(username)
			end

			if actorName then
				fn26(actorName)
			end
		end
	end

	local function fn28(arg)
		if not tbl.NicknameReplacerEnabled then
			return false
		end
		local text = arg.Text

		if text and text ~= "" then
			if not tbl24[arg] then
				tbl24[arg] = text
			end

			local flag4

			if tbl21[text] or tbl22[text] then
				text = "CursedSaken Protection"
				flag4 = true
			else
				flag4 = false

				for k in pairs(tbl21) do
					if text:find(k, 1, true) then
						text = text:gsub(k, "CursedSaken Protection")
						flag4 = true
					end
				end

				for k in pairs(tbl22) do
					if text:find(k, 1, true) then
						text = text:gsub(k, "CursedSaken Protection")
						flag4 = true
					end
				end
			end

			if flag4 then
				arg.Text = text
				return true
			end
		end

		return false
	end

	local function fn29(arg)
		if tbl24[arg] then
			arg.Text = tbl24[arg]
			tbl24[arg] = nil
			return true
		end

		return false
	end

	local function fn30(arg)
		local descendants = playerGui:GetDescendants()
		local tbl27 = {}
		local n6 = 0

		for i = 1, #descendants do
			local v10 = descendants[i]

			if tbl26[v10.ClassName] then
				n6 += 1
				tbl27[n6] = v10
			end
		end

		local v10 = math.ceil(n6 / 25)
		local n7 = 0

		for i = 1, v10 do
			for i2 = (i - 1) * 25 + 1, math.min(i * 25, n6) do
				if arg then
					if fn29(tbl27[i2]) then
						n7 += 1
					end
				elseif fn28(tbl27[i2]) then
					n7 += 1
				end
			end

			if i < v10 then
				task.wait()
			end
		end

		return n6, n7
	end

	local function fn31()
		for _, v10 in ipairs(tbl25) do
			if v10.Connected then
				v10:Disconnect()
			end
		end

		table.clear(tbl25)
		fn27()

		local function fn32(arg)
			if tbl26[arg.ClassName] then
				local connection5 = arg:GetPropertyChangedSignal("Text"):Connect(function()
					fn28(arg)
				end)

				table.insert(tbl25, connection5)
				local connection6 = nil

				connection6 = arg.AncestryChanged:Connect(function()
					if not arg.Parent then
						tbl24[arg] = nil

						if connection6 then
							connection6:Disconnect()
						end
					end
				end)

				table.insert(tbl25, connection6)
			end
		end

		for _, descendant in ipairs(playerGui:GetDescendants()) do
			fn32(descendant)
		end

		local connection5 = playerGui.DescendantAdded:Connect(function(descendant)
			if fn25(descendant) then
				fn26(descendant)
			end

			fn32(descendant)

			if tbl26[descendant.ClassName] then
				fn28(descendant)
			end
		end)

		table.insert(tbl25, connection5)
	end

	local function fn32()
		if not tbl.NicknameReplacerEnabled then
			return
		end
		fn24()

		task.spawn(function()
			fn30(false)
		end)

		fn31()

		local function fn33()
			task.wait(0.5)
			fn24()

			task.delay(1, function()
				fn30(false)
			end)
		end

		table.insert(tbl25, Players.PlayerAdded:Connect(fn33))
		table.insert(tbl25, Players.PlayerRemoving:Connect(fn33))

		for _, v10 in ipairs(tbl23) do
			table.insert(tbl25, v10:GetPropertyChangedSignal("DisplayName"):Connect(fn33))
		end
	end

	local function fn33()
		fn30(true)
		table.clear(tbl24)

		for _, v10 in ipairs(tbl25) do
			if v10.Connected then
				v10:Disconnect()
			end
		end

		table.clear(tbl25)
	end

	local function fn34(text)
		local mainUI = localPlayer.PlayerGui:FindFirstChild("MainUI")
		if not mainUI then
			return
		end
		local spectate = mainUI:FindFirstChild("Spectate")
		if not spectate then
			return
		end
		local username = spectate:FindFirstChild("Username")
		local actorName = spectate:FindFirstChild("ActorName")
		if not (username and actorName) then
			return
		end
		fn26(username)
		username.Text = text
	end

	Misc:AddToggle({
		Name = "Hide Name",
		Callback = function(nicknameReplacerEnabled)
			tbl.NicknameReplacerEnabled = nicknameReplacerEnabled

			if nicknameReplacerEnabled then
				fn32()
			else
				fn33()
			end
		end,
	})

	Misc:AddInput({
		Name = "Custom Spectate Username",
		Default = "Roblox",
		SaveUserText = true,
		Callback = function(arg)
			fn34(arg)
		end,
	})
end

do
	local fireServerConnection = nil

	local function fn24(antiFootstepsActive)
		local module = require(v)

		if not fireServerConnection then
			fireServerConnection = module.FireServerConnection

			module.FireServerConnection = function(arg, arg2, ...)
				if arg2 == "FootSP" and module.__AntiFootstepsActive then
					return
				end
				local v10 = fireServerConnection
				local v11 = table.pack(...)
				v11.n = 3 + v11.n - 1
				table.move(v11, 1, v11.n, 3, v11)
				v11[1] = arg
				v11[2] = arg2
				return v10(table.unpack(v11, 1, v11.n))
			end
		end

		module.__AntiFootstepsActive = antiFootstepsActive
	end

	Misc:AddSection("Movement")

	Misc:AddToggle({
		Name = "Anti Footsteps",
		Description = "Silently walk/run",
		Callback = function(arg)
			fn24(arg)
		end,
	})
end

do
	local Actors = nil

	local function fn24(arg)
		if not Actors then
			Actors = require(game.ReplicatedStorage.Modules.Gameplay.Actors)
		end

		local v10 = Actors.CurrentActors[localPlayer]

		if v10 then
			v10.AnimationType = arg and "Injured" or nil

			if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
				localPlayer.Character.Humanoid.Health = localPlayer.Character.Humanoid.Health
			end
		end
	end

	Misc:AddToggle({
		Name = "Fake Injured",
		Callback = function(arg)
			fn24(arg)
		end,
	})
end

do
	local thread = nil
	local v10 = nil

	local function fn24()
		if v10 then
			pcall(function()
				v10:Stop()
			end)

			pcall(function()
				v10:Destroy()
			end)

			v10 = nil
		end
	end

	local function fn25()
		if thread then
			task.cancel(thread)
			thread = nil
		end

		fn24()
		if not tbl.FakeClone then
			return
		end

		thread = task.spawn(function()
			while task.wait(0.25) do
				if tbl.FakeClone then
					local character = localPlayer.Character
					character = character and character:FindFirstChildOfClass("Humanoid")
					local animator = character and character:FindFirstChildOfClass("Animator")
					local flag4 = false

					if v10 then
						pcall(function()
							flag4 = v10.IsPlaying
						end)
					end

					if not flag4 then
						v10 = nil
					end

					if animator then
						if character.MoveDirection.Magnitude > 0.1 and not v10 then
							local ok, result = pcall(function()
								local animation = Instance.new("Animation")
								animation.AnimationId = "rbxassetid://136252471123500"
								local v11 = animator:LoadAnimation(animation)
								v11.Priority = Enum.AnimationPriority.Action4
								v11.Looped = true
								v11:Play(0.1)
								v11:AdjustSpeed(1)
								return v11
							end)

							if ok and result then
								v10 = result
							end
						elseif character.MoveDirection.Magnitude <= 0.1 and v10 then
							fn24()
						end
					end

					continue
				end

				break
			end

			fn24()
		end)
	end

	Misc:AddToggle({
		Name = "Fake Clone",
		Callback = function(fakeClone)
			tbl.FakeClone = fakeClone
			fn25()
		end,
	})
end

Misc:AddSection("Round Timer")

Misc:AddDropdown({
	Name = "Timer Type",
	Default = "Select...",
	Options = { "Right", "Middle", "Left" },
	Callback = function(arg)
		if not playerGui:FindFirstChild("RoundTimer") then
			return
		end
		playerGui.RoundTimer.Main.Position = UDim2.new(0.5, 0, -0.018, 0)

		if arg == "Right" then
			playerGui.RoundTimer.Main.Position = UDim2.new(0.9, 0, -0.018, 0)
		elseif arg == "Left" then
			playerGui.RoundTimer.Main.Position = UDim2.new(0.1, 0, -0.018, 0)
		end
	end,
})

Misc:AddSection("FOV")

do
	local n6 = 1
	local connection5 = nil
	local function fn24(...) end

	Misc:AddToggle({
		Name = "Enable Custom FOV",
		Callback = function(arg)
			if connection5 then
				connection5:Disconnect()
				connection5 = nil
			end

			if arg then
				connection5 = RunService.RenderStepped:Connect(fn24)
			else
				pcall(function()
					localPlayer.Character.FOVMultipliers.FOVSetting.Value = 1
				end)
			end
		end,
	})

	Misc:AddSlider({
		Name = "FOV Multiplier",
		Min = 0.5,
		Max = 3,
		Default = n6,
		Precision = 0.1,
		Callback = function(arg)
			n6 = arg

			if connection5 then
				fn24()
			end
		end,
	})
end

Misc:AddSection("Character & Servers")

Misc:AddButton({
	Name = "Turn on Jump",
	Callback = function()
		localPlayer.Character.Humanoid.JumpPower = 50
	end,
})

Misc:AddButton({
	Name = "Reset",
	Callback = function()
		localPlayer.Character.Humanoid.Health = 0
	end,
})

Misc:AddButton({
	Name = "Rejoin",
	Callback = function()
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
	end,
})

Misc:AddButton({
	Name = "Server Hop",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/zxcursedsocute/Forsaken-Script/refs/heads/main/ServerHop"))()
	end,
})

task.wait()

do
	local Items = Main:AddTab("Items", "Items")
	Items:AddSection("Auto Pickup")
	local flag4 = false
	local v10 = nil
	local flag5 = false
	local connection5 = nil
	local flag6 = false

	local function fn24()
		if flag6 then
			return
		end
		flag6 = true

		task.spawn(function()
			local ok, result = pcall(function()
				local modules2 = ReplicatedStorage:WaitForChild("Modules", 5)
				modules2 = modules2 and modules2:WaitForChild("Network", 5)
				modules2 = modules2 and modules2:WaitForChild("Network", 5)
				return modules2 and modules2:WaitForChild("UnreliableRemoteEvent", 5)
			end)

			if ok and result then
				v10 = result
			end
		end)

		forsakenFK.namecall.add(function(...) end)
	end

	local function fn25(arg)
		local v11 = ingame:FindFirstChild(arg)
		if v11 then
			return v11
		end
		local map = ingame:FindFirstChild("Map")

		if map then
			local v12 = map:FindFirstChild(arg)
			if v12 then
				return v12
			end
		end

		return Workspace:FindFirstChild(arg)
	end

	local function fn26(arg)
		fn24()
		local character = localPlayer.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") then
			return
		end
		local humanoidRootPart = character.HumanoidRootPart
		local cFrame = humanoidRootPart.CFrame
		local v11 = fn25(arg)

		if v11 and v11:FindFirstChild("ItemRoot") and v11.ItemRoot:FindFirstChildOfClass("ProximityPrompt") then
			local flag7 = false

			if not flag4 then
				flag4 = true
				task.wait(0.1)
				flag7 = true
			end

			humanoidRootPart.CFrame = v11.ItemRoot.CFrame + Vector3.new(0, -4, 0)
			task.wait(0.2)
			fireproximityprompt(v11.ItemRoot:FindFirstChildOfClass("ProximityPrompt"))
			task.wait(0.2)
			humanoidRootPart.CFrame = cFrame
			task.wait(0.1)

			if flag7 then
				flag4 = false
			end
		end
	end

	local function fn27(arg)
		fn24()
		local character = localPlayer.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") then
			return
		end
		local humanoidRootPart = character.HumanoidRootPart
		local cFrame = humanoidRootPart.CFrame
		flag4 = true
		local tbl21 = { "Torso", "HumanoidRootPart", "Head", "CollisionHitbox" }

		for _, v11 in ipairs(tbl21) do
			local v12 = character:FindFirstChild(v11)

			if v12 then
				v12.CanCollide = false
			end
		end

		local tbl22 = {}
		local tbl23 = {}
		local map = ingame:FindFirstChild("Map")
		local v11 = Workspace
		tbl23[1] = ingame
		tbl23[2] = map
		tbl23[3] = v11

		for _, v12 in ipairs(tbl23) do
			if v12 then
				for _, child in ipairs(v12:GetChildren()) do
					if child:FindFirstChild("ItemRoot") then
						table.insert(tbl22, child)
					end
				end
			end
		end

		for _, v12 in ipairs(tbl22) do
			if v12:FindFirstChild("ItemRoot") then
				humanoidRootPart.CFrame = v12.ItemRoot.CFrame + Vector3.new(0, 2, 0)
				task.wait(0.2)

				if arg == "bring" then
					v12.ItemRoot.CFrame = cFrame
				elseif arg == "delete" then
					v12.ItemRoot.CFrame = CFrame.new(0, 0, 0)
				end

				task.wait(0.2)
			end
		end

		humanoidRootPart.CFrame = cFrame
		task.wait(0.1)

		for _, v12 in ipairs(tbl21) do
			local v13 = character:FindFirstChild(v12)

			if v13 then
				v13.CanCollide = true
			end
		end

		flag4 = false
	end

	local function fn28()
		fn24()
		flag5 = true
		local tbl21 = { "BloxyCola", "Medkit" }
		local tbl22 = {}

		local function fn29()
			tbl22 = {}
			local tbl23 = { Workspace, ingame }

			if ingame:FindFirstChild("Map") then
				table.insert(tbl23, ingame.Map)
			end

			for _, v11 in ipairs(tbl23) do
				for _, v12 in ipairs(tbl21) do
					for _, child in ipairs(v11:GetChildren()) do
						if child.Name == v12 and child:FindFirstChild("ItemRoot") then
							local proximityPrompt = child.ItemRoot:FindFirstChildOfClass("ProximityPrompt")

							if proximityPrompt then
								table.insert(tbl22, { root = child.ItemRoot, prompt = proximityPrompt })
							end
						end
					end
				end
			end
		end

		connection5 = RunService.Heartbeat:Connect(function(...) end)
		fn29()
	end

	local function fn29()
		flag5 = false

		if connection5 then
			connection5:Disconnect()
			connection5 = nil
		end
	end

	Items:AddToggle({
		Name = "Auto Pickup",
		Description = "Auto pickup BloxyCola and Medkit",
		Callback = function(arg)
			if arg then
				fn28()
			else
				fn29()
			end
		end,
	})

	Items:AddSection("Get items")

	Items:AddButton({
		Name = "Get Bloxy Cola",
		Description = "teleport + Hidden Desync",
		Callback = function()
			fn26("BloxyCola")
		end,
	})

	Items:AddButton({
		Name = "Get Medkit",
		Description = "teleport + Hidden Desync",
		Callback = function()
			fn26("Medkit")
		end,
	})

	Items:AddSection("Items management")

	Items:AddButton({
		Name = "Bring Items",
		Description = "teleport + Hidden Desync",
		Callback = function()
			fn27("bring")
		end,
	})

	Items:AddButton({
		Name = "Delete Items",
		Description = "teleport + Hidden Desync",
		Callback = function()
			fn27("delete")
		end,
	})

	Items:AddSection("Auto")
	local connection6 = nil

	local function fn30()
		connection6 = localPlayer.CharacterAdded:Connect(function(character)
			task.wait(4)

			if character and character.Parent and character.Parent.Name == "Survivors" and tbl.GetAutoItems then
				flag4 = true
				fn26("Medkit")
				fn26("BloxyCola")
				flag4 = false
			end
		end)
	end

	local function fn31()
		if connection6 then
			connection6:Disconnect()
			connection6 = nil
		end
	end

	Items:AddToggle({
		Name = "Get BloxCola and Medkit",
		Description = "After round start (teleport + Hidden Desync)",
		Callback = function(getAutoItems)
			tbl.GetAutoItems = getAutoItems

			if getAutoItems then
				fn30()
			else
				fn31()
			end
		end,
	})
end

task.wait(0.1)
tbl20 = tbl20 or {}
tbl20.Enabled = tbl20.Enabled == true
tbl20.SelectedTarget = tbl20.SelectedTarget or {}
tbl20.GrabExtraLead = tbl20.GrabExtraLead or 0.03
tbl20.GrabMaxLead = tbl20.GrabMaxLead or 0.4
tbl20.GrabFOV = tbl20.GrabFOV or math.huge
tbl20.GrabWallCheck = false
tbl20.GeneralLeadTime = tbl20.GeneralLeadTime or 0.15

do
	local v10 = nil
	local v11 = nil
	local v12 = nil
	local flag4 = nil
	local tbl21 = { Actor = nil, Target = nil, NextActorScan = 0, NextTargetScan = 0 }
	local obj = setmetatable({}, { __mode = "k" })
	local n6 = -math.huge

	local tbl22 = {
		Installed = false,
		NetworkCalls = 0,
		Matched = 0,
		Replaced = 0,
		Reason = "Not called",
		LastMessage = "",
		Target = "",
	}

	PrintGrabSilentDiagnostics = function()
		print("[GrabSilent] installed=", tbl22.Installed, "enabled=", tbl20 and tbl20.Enabled, "selected=", tbl20 and tbl20.SelectedTarget and tbl20.SelectedTarget["Tentacles (Grab)"], "calls=", tbl22.NetworkCalls, "matched=", tbl22.Matched, "replaced=", tbl22.Replaced, "reason=", tbl22.Reason, "target=", tbl22.Target, "lastMessage=", tbl22.LastMessage)
	end

	local function fn24(reason)
		tbl22.Reason = reason
		return nil
	end

	local function fn25(arg)
		local v13 = tbl20
		local enabled = tbl20

		if v13 then
			enabled = v13.Enabled
		end

		return enabled and type(v13.SelectedTarget) == "table" and v13.SelectedTarget[arg] == true
	end

	local function fn26()
		local character = localPlayer.Character
		return character and (character:GetAttribute("CharacterName") or character.Name)
	end

	local function fn27(arg)
		if typeof(arg) ~= "Instance" then
			return nil
		end

		if arg:IsA("BasePart") then
			return arg
		end

		if arg:IsA("Model") then
			return arg:FindFirstChild("HumanoidRootPart") or arg.PrimaryPart
		end
		return nil
	end

	local obj2 = setmetatable({}, { __mode = "k" })

	local function fn28(arg)
		local now = os.clock()
		local assemblyLinearVelocity = arg.AssemblyLinearVelocity

		if assemblyLinearVelocity.Magnitude > 120 then
			assemblyLinearVelocity = Vector3.zero
		end

		local v13 = obj2[arg]
		if not v13 then
			obj2[arg] = { t = now, v = assemblyLinearVelocity }
			return assemblyLinearVelocity
		end
		v13.v = v13.v:Lerp(assemblyLinearVelocity, math.clamp(1 - math.exp(-math.max(now - v13.t, 0.001) * 12), 0, 1))
		v13.t = now
		return v13.v
	end

	predictTargetPosition = function(arg)
		local v13 = fn27(arg)
		if not v13 then
			return nil
		end
		local generalLeadTime = tbl20.GeneralLeadTime or 0.15

		pcall(function()
			generalLeadTime += localPlayer:GetNetworkPing() * 0.5
		end)

		return v13.Position + fn28(v13) * generalLeadTime
	end

	local function fn29()
		local now = os.clock()
		if now < tbl21.NextActorScan then
			return tbl21.Actor
		end
		tbl21.NextActorScan = now + 0.2
		tbl21.Actor = nil
		local currentActors = flag4 and flag4.CurrentActors
		if type(currentActors) ~= "table" then
			return nil
		end

		local function fn30(arg)
			return type(arg) == "table" and not arg.Destroyed and arg.Player == localPlayer and typeof(arg.Rig) == "Instance" and arg.Rig.Parent and type(arg.State) == "table" and type(arg.Config) == "table" and type(arg.Config.Grab) == "table"
		end

		if fn30(currentActors[localPlayer]) then
			tbl21.Actor = currentActors[localPlayer]
		end

		if not tbl21.Actor then
			for _, currentActor in pairs(currentActors) do
				if fn30(currentActor) then
					tbl21.Actor = currentActor
					break
				end
			end
		end

		return tbl21.Actor
	end

	local function fn30(arg, arg2, arg3)
		if typeof(arg) ~= "Instance" or not survivors or arg.Parent ~= survivors then
			return nil
		end
		local v13 = fn27(arg)
		local humanoid = arg:FindFirstChildOfClass("Humanoid")
		if not v13 or not humanoid or humanoid.Health <= 0 then
			return nil
		end

		if arg3 < (v13.Position - arg2).Magnitude then
			return nil
		end
		return v13
	end

	local function fn31(arg)
		local raycastParams2 = RaycastParams.new()
		raycastParams2.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams2.RespectCanCollide = true
		local players2 = Workspace:FindFirstChild("Players")
		raycastParams2.FilterDescendantsInstances = players2 and { players2 } or { arg.Rig }

		pcall(function()
			raycastParams2.CollisionGroup = "Killers"
		end)

		return raycastParams2
	end

	local function fn32(arg, arg2, arg3)
		if not survivors or not survivors.Parent then
			return nil
		end
		local flag5 = tbl20.GrabWallCheck == true and fn31(arg)
		local huge = math.huge
		local v13 = nil

		for _, child in ipairs(survivors:GetChildren()) do
			local v14 = fn30(child, arg2, arg3)

			if v14 then
				local n7 = v14.Position - arg2
				local magnitude = n7.Magnitude

				if magnitude < huge and (not flag5 or magnitude < 0.001 or not Workspace:Raycast(arg2, n7, flag5)) then
					huge = magnitude
					v13 = child
				end
			end
		end

		return v13
	end

	local function fn33(arg, arg2)
		local now = os.clock()
		local assemblyLinearVelocity = arg2.AssemblyLinearVelocity

		if assemblyLinearVelocity.Magnitude > 120 then
			assemblyLinearVelocity = Vector3.zero
		end

		local tbl23 = obj[arg]

		if not tbl23 or tbl23.Root ~= arg2 or now - tbl23.Time > 0.5 then
			tbl23 = { Root = arg2, Time = now, Velocity = assemblyLinearVelocity }
			obj[arg] = tbl23
		else
			tbl23.Velocity = tbl23.Velocity:Lerp(assemblyLinearVelocity, 1 - math.exp(-14 * math.max(0, now - tbl23.Time)))
			tbl23.Time = now
		end

		return tbl23.Velocity
	end

	local function fn34(arg, arg2, arg3)
		local n7 = arg2:Dot(arg2) - arg3 * arg3
		local n8 = 2 * arg:Dot(arg2)
		local v13 = arg:Dot(arg)
		if v13 < 0.0001 then
			return 0
		end

		if math.abs(n7) < 0.0001 then
			if math.abs(n8) > 0.0001 and -v13 / n8 >= 0 then
				return -v13 / n8
			end
		else
			local n9 = n8 * n8 - 4 * n7 * v13

			if n9 >= 0 then
				local v14 = math.sqrt(n9)
				local n10 = (-n8 - v14) / 2 * n7
				local n11 = (-n8 + v14) / 2 * n7
				local huge = math.huge

				if n10 >= 0 then
					huge = n10
				end

				local n12

				if not (n11 >= 0) then
					n12 = huge
				else
					n12 = math.min(huge, n11)
				end

				if n12 < math.huge then
					return n12
				end
			end
		end

		return arg.Magnitude / arg3
	end

	local function fn35()
		if not fn25("Tentacles (Grab)") then
			return fn24("Grab option disabled")
		end
		local v13 = fn29()
		local rig = v13 and v13.Rig or localPlayer.Character
		if not rig or not rig.Parent then
			return fn24("Local rig unavailable")
		end
		local state = v13 and v13.State
		if state and state.GrabbedRoot then
			return fn24("Holding victim: throw unchanged")
		end

		if state and state.ControllingGolem then
			return fn24("Controlling Golem")
		end
		local primaryPart = rig.PrimaryPart or fn27(rig)
		local humanoid = rig:FindFirstChildOfClass("Humanoid")
		if not primaryPart or not humanoid or humanoid.Health <= 0 then
			return fn24("Local character not alive")
		end
		local grab = v13 and v13.Config and v13.Config.Grab or {}
		local hookRange = grab.HookRange or 60
		local hookSpeed = grab.HookSpeed or 270
		if hookSpeed <= 0 then
			return fn24("Invalid HookSpeed")
		end
		local now = os.clock()

		if now >= tbl21.NextTargetScan then
			tbl21.NextTargetScan = now + 0.1
			tbl21.Target = fn32(v13 or { Rig = rig }, primaryPart.Position, hookRange)
		end

		local v14 = fn30(tbl21.Target, primaryPart.Position, hookRange)
		if not v14 then
			return fn24("No living target within HookRange")
		end
		local v15 = tbl20
		local v16 = fn33(tbl21.Target, v14)
		local n7 = math.max(0, v15.GrabExtraLead or 0.03)
		local cameraLookPosition = v14.Position + v16 * math.clamp(fn34(v14.Position + v16 * n7 - primaryPart.Position, v16, hookSpeed) + n7, 0, math.max(0, v15.GrabMaxLead or 0.4))
		local n8 = cameraLookPosition - primaryPart.Position

		if n8.Magnitude > hookRange then
			cameraLookPosition = primaryPart.Position + n8.Unit * hookRange
		end

		local flag5 = v15.GrabWallCheck == true and n8.Magnitude > 0.001

		if flag5 then
			flag5 = Workspace:Raycast(primaryPart.Position, cameraLookPosition - primaryPart.Position, fn31(v13 or { Rig = rig }))
		end

		if flag5 then
			return fn24("Optional wall check blocked target")
		end

		if state then
			state.CameraLookPosition = cameraLookPosition
		end

		tbl22.Target = tbl21.Target.Name
		tbl22.Reason = v13 and "Point prepared" or "Point prepared (actor fallback)"
		return cameraLookPosition
	end

	local function fn36()
		if v11 then
			return true
		end

		if type(hookfunction) ~= "function" then
			warn("[SilentAim] hookfunction unavailable")
			return false
		end

		local ok, result = pcall(function()
			return require(ReplicatedStorage.Systems.Player.Miscellaneous.GetPlayerMousePosition).GetMousePos
		end)

		if not ok or type(result) ~= "function" then
			warn("[SilentAim] GetMousePos not found; no fallback function was hooked")
			return false
		end
		v10 = result
		v11 = hookfunction(v10, function(...) end)
		return true
	end

	local function fn37()
		if v12 then
			return true
		end

		if type(hookfunction) ~= "function" then
			return false
		end

		local ok, result = pcall(function()
			return require(ReplicatedStorage.Modules.Network.Network)
		end)

		if not ok or type(result) ~= "table" or type(result.FireServerConnection) ~= "function" then
			warn("[SilentAim/Grab] Network module unavailable")
			return false
		end

		local ok2, result2 = pcall(function()
			return require(ReplicatedStorage.Modules.Gameplay.Actors)
		end)

		flag4 = ok2 and type(result2) == "table" and result2 or nil
		v12 = hookfunction(result.FireServerConnection, function(...) end)
		tbl22.Installed = true
		return true
	end

	fn21 = function()
		local v13 = tbl18
		local v14 = tbl20

		if tbl.JaneCrystalAim or tbl.JaneAxeAim or v13 and v13.Enabled or v14 and v14.Enabled then
			fn36()
		end

		if v14 and v14.Enabled then
			fn37()
		end
	end
end

local Misc2
Misc2 = v2:AddCategory("Misc")

do
	local Animations = Misc2:AddTab("Animations", "Animation")
	Animations:AddSection("Animations")

	local tbl21 = {
		EmoteMusicId = nil,
		EmoteMusicLooped = false,
		EmoteTrack = nil,
		EmoteMusicObj = nil,
		LoadedAnims = {},
		ActiveTrack = nil,
		Animator = nil,
		AnimUpdateConn = nil,
		LastKey = nil,
		PlayingSounds = {},
		AttackTrack = nil,
		MobileAttackCreated = false,
		MobileAttackGui = nil,
		MobileAttackBtn = nil,
		MobileAttackClose = nil,
	}

	local killers2 = assets.Killers
	local killers3 = assets.Skins.Killers

	local function fn24()
		local tbl22 = {}
		local tbl23 = {}

		if not pcall(function()
			for k, child in pairs(assets.Emotes:GetChildren()) do
				tbl22[k] = child
			end

			for k, v10 in pairs(tbl22) do
				tbl23[k] = require(v10).DisplayName or "Unknown"
			end
		end) then
			return {}, {}
		end

		return tbl22, tbl23
	end

	local v10, v11 = fn24()

	Animations:AddDropdown({
		Name = "Animations",
		Description = "Choose the animation",
		Options = v11,
		Default = "Select...",
		Callback = function(arg)
			for _, v12 in pairs(v10) do
				local module = require(v12)

				if module.DisplayName == arg then
					tbl.Animid = type(module.AssetID) == "table" and module.AssetID[1] or module.AssetID
					tbl21.EmoteMusicId = type(module.SFX) == "table" and module.SFX[1] or module.SFX
					tbl21.EmoteMusicLooped = false

					pcall(function()
						tbl21.EmoteMusicLooped = module.SFXProperties.Looped
					end)

					break
				end
			end
		end,
	})

	local function fn25()
		tbl21.EmoteMusicObj = Instance.new("Sound")

		if tbl21.EmoteMusicId then
			tbl21.EmoteMusicObj.SoundId = tbl21.EmoteMusicId
			tbl21.EmoteMusicObj.Parent = workspace:FindFirstChild("Sounds") or workspace
			tbl21.EmoteMusicObj.Looped = tbl21.EmoteMusicLooped
		end

		local animator = (localPlayer.Character or localPlayer.CharacterAdded:Wait()):WaitForChild("Humanoid"):WaitForChild("Animator")
		local animation = Instance.new("Animation")
		animation.AnimationId = tbl.Animid

		if tbl21.EmoteTrack then
			tbl21.EmoteTrack:Stop()
			tbl21.EmoteTrack:Destroy()
		end

		if tbl21.EmoteMusicId then
			tbl21.EmoteMusicObj:Play()
		end

		tbl21.EmoteTrack = animator:LoadAnimation(animation)
		tbl21.EmoteTrack:Play()
	end

	local function fn26()
		if tbl21.EmoteTrack then
			if tbl21.EmoteMusicObj then
				tbl21.EmoteMusicObj:Stop()
				tbl21.EmoteMusicObj:Destroy()
				tbl21.EmoteMusicObj = nil
			end

			tbl21.EmoteTrack:Stop()
			tbl21.EmoteTrack:Destroy()
			tbl21.EmoteTrack = nil
		end
	end

	local v12 = Animations:AddToggle({
		Name = "Play/Stop animation",
		Callback = function(arg)
			if arg then
				fn25()
			else
				fn26()
			end
		end,
	})

	Animations:AddKeybind({
		Name = "Play/Stop animation",
		Callback = function()
			v12:Toggle()
		end,
	})

	Animations:AddToggle({
		Name = "Mobile animation button",
		Callback = function(arg)
			if arg then
				fn7({
					name = "ToggleAnimButton",
					text = tbl21.EmoteTrack and "Stop Anim" or "Play Anim",
					size = UDim2.new(0, 100, 0, 45),
					position = UDim2.new(0.6, 0, 0.4, 0),
					backgroundColor3 = tbl21.EmoteTrack and Color3.fromRGB(170, 0, 0) or Color3.fromRGB(0, 170, 0),
					onClick = function(arg2)
						if tbl21.EmoteTrack then
							fn26()
							arg2.Text = "Play Anim"
							arg2.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

							if v12 and v12.Set then
								v12:Set(false)
							end
						else
							fn25()
							arg2.Text = "Stop Anim"
							arg2.BackgroundColor3 = Color3.fromRGB(170, 0, 0)

							if v12 and v12.Set then
								v12:Set(true)
							end
						end
					end,
				})
			else
				fn8("ToggleAnimButton")
			end
		end,
	})

	local v13 = nil

	JorkinIn = function(arg)
		if arg then
			local animation = Instance.new("Animation")
			animation.AnimationId = "rbxassetid://72042024"
			v13 = localPlayer.Character.Humanoid.Animator:LoadAnimation(animation)
			v13.Looped = true
			v13:Play()
		elseif v13 then
			v13:Stop()
		end
	end

	Animations:AddToggle({ Name = "Jerking", Callback = JorkinIn })
	Animations:AddSection("Killers Anim")
	local v14 = nil

	local function fn27()
		local tbl22 = {}

		pcall(function()
			for _, child in ipairs(killers2:GetChildren()) do
				if child:FindFirstChild("Config") then
					table.insert(tbl22, child.Name)
				end
			end
		end)

		return tbl22
	end

	local function fn28()
		if not tbl.SelectedKiller then
			return nil
		end
		local v15 = killers2:FindFirstChild(tbl.SelectedKiller)
		local selectedSkin = tbl.SelectedSkin

		if selectedSkin and selectedSkin ~= "Default" and killers3 then
			local v16 = killers3:FindFirstChild(tbl.SelectedKiller)

			if v16 and v16:FindFirstChild(selectedSkin) then
				v15 = v16[selectedSkin]
			end
		end

		if not v15 or not v15:FindFirstChild("Config") then
			return nil
		end
		local ok, result = pcall(require, v15.Config)
		return ok and type(result) == "table" and result or nil
	end

	local function fn29(arg, animationId)
		if not arg or not animationId then
			return nil
		end
		local animation = Instance.new("Animation")
		animation.AnimationId = animationId
		local v15 = arg:LoadAnimation(animation)

		pcall(function()
			v15.Priority = Enum.AnimationPriority.Movement
		end)

		v15.Looped = true
		return v15
	end

	local function fn30(arg, arg2)
		local parent = arg.Parent
		local humanoidRootPart = parent:FindFirstChild("HumanoidRootPart")
		humanoidRootPart = humanoidRootPart and humanoidRootPart.Velocity.Magnitude or 0
		local platformStand = arg.PlatformStand
		local value

		if parent:FindFirstChild("Stunned") then
			value = platformStand or parent.Stunned.Value
		else
			value = platformStand
		end

		if value and arg2.Animations and arg2.Animations.Stunned then
			return "Stunned"
		end
		local flag4 = arg.Health / arg.MaxHealth <= 0.5
		local sprintSpeed = arg2.SprintSpeed or arg.WalkSpeed * 1.8
		if humanoidRootPart < 1.5 then
			flag4 = flag4 and "InjuredIdle"
			return flag4 or "Idle"
		end

		if sprintSpeed * 0.75 <= humanoidRootPart then
			flag4 = flag4 and "InjuredRun"
			return flag4 or "Run"
		end
		return flag4 and "InjuredWalk" or "Walk"
	end

	local function fn31()
		if tbl21.ActiveTrack then
			pcall(function()
				tbl21.ActiveTrack:Stop()
			end)
		end

		for _, loadedAnim in pairs(tbl21.LoadedAnims) do
			pcall(function()
				loadedAnim:Stop()
			end)
		end

		tbl21.LoadedAnims = {}
		tbl21.LastKey = nil

		if tbl21.AnimUpdateConn then
			tbl21.AnimUpdateConn:Disconnect()
			tbl21.AnimUpdateConn = nil
		end
	end

	local function fn32(arg, arg2)
		fn31()
		tbl21.Animator = arg2:FindFirstChild("Animator") or Instance.new("Animator", arg2)
		if not arg.Animations then
			return
		end

		for k, animation in pairs(arg.Animations) do
			if typeof(animation) == "string" then
				tbl21.LoadedAnims[k] = fn29(tbl21.Animator, animation)
			elseif k == "Stunned" and typeof(animation) == "table" and animation.Loop then
				tbl21.LoadedAnims.StunnedLoop = fn29(tbl21.Animator, animation.Loop)
			end
		end
	end

	local function fn33(lastKey)
		if lastKey == tbl21.LastKey then
			return
		end

		if tbl21.ActiveTrack then
			pcall(function()
				tbl21.ActiveTrack:Stop()
			end)
		end

		if lastKey == "Stunned" then
			if tbl21.LoadedAnims.StunnedLoop then
				tbl21.ActiveTrack = tbl21.LoadedAnims.StunnedLoop
				tbl21.ActiveTrack:Play()
				tbl21.LastKey = lastKey
			end

			return
		end

		if tbl21.LoadedAnims[lastKey] then
			tbl21.ActiveTrack = tbl21.LoadedAnims[lastKey]
			tbl21.ActiveTrack:Play()
			tbl21.LastKey = lastKey
		end
	end

	local function fn34()
		fn31()
		if not tbl.UseKillerAnimations then
			return
		end
		local v15 = fn28()
		if not v15 then
			return
		end
		local humanoid = (localPlayer.Character or localPlayer.CharacterAdded:Wait()):WaitForChild("Humanoid")
		fn32(v15, humanoid)
		tbl21.AnimUpdateConn = RunService.RenderStepped:Connect(function(...) end)
	end

	local function fn35()
		for _, playingSound in ipairs(tbl21.PlayingSounds) do
			pcall(function()
				playingSound:Stop()
				playingSound:Destroy()
			end)
		end

		tbl21.PlayingSounds = {}
	end

	local function fn36()
		fn35()
		if not tbl.UseKillerSounds then
			return
		end
		local v15 = fn28()
		if not v15 or not v15.Sounds then
			return
		end

		for _, sound in pairs(v15.Sounds) do
			if typeof(sound) == "string" then
				local sound2 = Instance.new("Sound")
				sound2.Parent = localPlayer:WaitForChild("PlayerGui")
				sound2.SoundId = sound
				sound2.Volume = 1
				sound2:Play()
				table.insert(tbl21.PlayingSounds, sound2)
			end
		end
	end

	local function fn37()
		if not tbl.SelectedKiller or not tbl.UseKillerAnimations then
			return
		end
		local v15 = fn28()
		if not v15 or not v15.Animations then
			return
		end
		local attack = v15.Animations.Attack or v15.Animations.Slash or v15.Animations.Stab
		if not attack then
			return
		end
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoid = character:FindFirstChild("Humanoid")
		if not humanoid then
			return
		end
		local animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator", humanoid)

		if tbl21.AttackTrack then
			tbl21.AttackTrack:Stop()
			tbl21.AttackTrack = nil
		end

		local animation = Instance.new("Animation")
		animation.AnimationId = type(attack) == "table" and attack[1] or attack
		tbl21.AttackTrack = animator:LoadAnimation(animation)

		if tbl21.AttackTrack then
			tbl21.AttackTrack.Priority = Enum.AnimationPriority.Action
			tbl21.AttackTrack:Play()
			local length = tbl21.AttackTrack.Length

			task.spawn(function()
				task.wait(length > 0 and length or 1)

				if tbl21.AttackTrack then
					tbl21.AttackTrack:Stop()
					tbl21.AttackTrack = nil
				end
			end)
		end
	end

	local function fn38()
		if tbl21.MobileAttackCreated then
			return
		end

		local v15 = fn7({
			name = "MobileAttack",
			text = "ATTACK",
			position = UDim2.new(0.2, 0, 0.5, 0),
			backgroundColor3 = Color3.fromRGB(200, 0, 0),
			borderColor3 = Color3.fromRGB(255, 255, 255),
			mobileOnly = true,
			onClick = function()
				fn37()
			end,
			onClose = function()
				tbl21.MobileAttackCreated = false
				tbl21.MobileAttackBtn = nil
				tbl21.MobileAttackClose = nil
				tbl.MobileAttackButtonEnabled = false
			end,
		})

		if v15 then
			tbl21.MobileAttackGui = v15.gui
			tbl21.MobileAttackBtn = v15.button
			tbl21.MobileAttackClose = v15.closeButton
			tbl21.MobileAttackCreated = true
		end
	end

	Animations:AddButton({
		Name = "Load Killer Animations",
		DestroyOnClick = true,
		Callback = function()
			Animations:AddDropdown({
				Name = "Select Killer",
				Options = fn27(),
				Callback = function(selectedKiller)
					tbl.SelectedKiller = selectedKiller
					tbl.SelectedSkin = "Default"
					local tbl22 = { "Default" }

					if killers3 then
						local v15 = killers3:FindFirstChild(selectedKiller)

						if v15 then
							for _, child in ipairs(v15:GetChildren()) do
								if child:FindFirstChild("Config") then
									local ok, result = pcall(require, child.Config)

									if ok and type(result) == "table" and result.Animations then
										table.insert(tbl22, child.Name)
									end
								end
							end
						end
					end

					if v14 then
						v14:UpdateOptions(tbl22)
						v14:Set("Default")
					end

					if tbl.UseKillerAnimations then
						fn34()
					end

					if tbl.UseKillerSounds then
						fn36()
					end
				end,
			})

			v14 = Animations:AddDropdown({
				Name = "Select Skin",
				Options = { "Default" },
				Default = "Default",
				Callback = function(selectedSkin)
					tbl.SelectedSkin = selectedSkin

					if tbl.UseKillerAnimations then
						fn34()
					end

					if tbl.UseKillerSounds then
						fn36()
					end
				end,
			})

			Animations:AddToggle({
				Name = "Replace Animations",
				Callback = function(useKillerAnimations)
					tbl.UseKillerAnimations = useKillerAnimations

					if useKillerAnimations then
						fn34()
					else
						fn31()
					end
				end,
			})

			Animations:AddToggle({
				Name = "Replace Sounds",
				Callback = function(useKillerSounds)
					tbl.UseKillerSounds = useKillerSounds

					if useKillerSounds then
						fn36()
					else
						fn35()
					end
				end,
			})

			Animations:AddKeybind({
				Name = "Hit animation",
				Default = Enum.KeyCode.Q,
				Callback = function()
					fn37()
				end,
			})

			Animations:AddToggle({
				Name = "Mobile attack button",
				Callback = function(mobileAttackButtonEnabled)
					tbl.MobileAttackButtonEnabled = mobileAttackButtonEnabled

					if mobileAttackButtonEnabled then
						if UserInputService.TouchEnabled then
							fn38()
						else
							tbl.MobileAttackButtonEnabled = false
						end
					else
						fn8("MobileAttack")
						tbl21.MobileAttackCreated = false
					end
				end,
			})
		end,
	})
end

task.wait()

do
	local Music = Misc2:AddTab("Music", "Music")
	local volume = 0.4
	local themes = workspace:FindFirstChild("Themes")

	local function fn24(arg)
		return tostring(arg):match("%d+") or ""
	end

	local tbl21 = {
		LMS = {
			["Destroy Die Of Death"] = {
				File = "Destroy Die Of Death.mp3",
				Url = "https://raw.githubusercontent.com/zxcursedsocute/music/refs/heads/main/Music/Destroy%20Die%20Of%20Death.mp3",
			},
			["PLEAD (c00lkidd vs 007n7)"] = {
				File = "PLEAD (c00lkidd vs 007n7).mp3",
				Url = "https://raw.githubusercontent.com/zxcursedsocute/music/refs/heads/main/Music/PLEAD%20(c00lkidd%20vs%20007n7).mp3",
			},
			["DEAD RINGER (Guest 666 vs Noob)"] = {
				File = "DEAD RINGER (Guest 666 vs Noob).mp3",
				Url = "https://raw.githubusercontent.com/zxcursedsocute/music/refs/heads/main/Music/DEAD%20RINGER%20(Guest%20666%20vs%20Noob).mp3",
			},
			["You And I ( John Doe Vs Jane Doe)"] = {
				File = "You And I ( John Doe Vs Jane Doe).mp3",
				Url = "https://raw.githubusercontent.com/zxcursedsocute/music/refs/heads/main/Music/You%20And%20I%20(%20John%20Doe%20Vs%20Jane%20Doe).mp3",
			},
		},
		InGame = {
			zxc3 = {
				File = "zxc3.mp3",
				Url = "https://raw.githubusercontent.com/zxcursedsocute/music/refs/heads/main/Music/zxc3.mp3",
			},
			["Pixel Galaxy"] = {
				File = "Pixel Galaxy.mp3",
				Url = "https://raw.githubusercontent.com/zxcursedsocute/music/refs/heads/main/Music/Pixel%20Galaxy.mp3",
			},
			c418 = {
				File = "c418.mp3",
				Url = "https://raw.githubusercontent.com/zxcursedsocute/music/refs/heads/main/Music/c418.mp3",
			},
		},
		Lobby = {
			["Monkeys Spinning Monkeys"] = {
				File = "Monkeys Spinning Monkeys.mp3",
				Url = "https://raw.githubusercontent.com/zxcursedsocute/music/refs/heads/main/Music/Monkeys%20Spinning%20Monkeys.mp3",
			},
			["Wii Shop"] = {
				File = "Wii Shop.mp3",
				Url = "https://raw.githubusercontent.com/zxcursedsocute/music/refs/heads/main/Music/Wii%20Shop.mp3",
			},
			["confess your love"] = {
				File = "confess your love.mp3",
				Url = "https://raw.githubusercontent.com/zxcursedsocute/music/refs/heads/main/Music/confess%20your%20love.mp3",
			},
		},
		Chase = {
			["1X1X1X1 INFERNUM CHASE THEME"] = {
				File = "1X1X1X1 INFERNUM CHASE THEME.mp3",
				Url = "https://raw.githubusercontent.com/zxcursedsocute/music/refs/heads/main/Music/1X1X1X1%20INFERNUM%20CHASE%20THEME.mp3",
			},
			["Champion 1x1"] = {
				File = "Champion 1x1.mp3",
				Url = "https://raw.githubusercontent.com/zxcursedsocute/music/refs/heads/main/Music/Champion%201x1.mp3",
			},
			["ONE EGG"] = {
				File = "ONE EGG.mp3",
				Url = "https://raw.githubusercontent.com/zxcursedsocute/music/refs/heads/main/Music/ONE%20EGG.mp3",
			},
		},
	}

	local tbl22 = {
		LMS = { Enabled = false, Mode = "PLEAD (c00lkidd vs 007n7)" },
		InGame = { Enabled = false, Mode = "zxc3" },
		Lobby = { Enabled = false, Mode = "Monkeys Spinning Monkeys" },
		Chase = { Enabled = false, Mode = "1X1X1X1 INFERNUM CHASE THEME" },
	}

	local tbl23 = { LMS = 0, InGame = 0, Lobby = 0, Chase = 0 }
	local tbl24 = { LMS = {}, InGame = {}, Lobby = {}, Chase = {} }

	local function fn25()
		pcall(function()
			writefile("ForsakenCustomTracks.json", HttpService:JSONEncode(tbl24))
		end)
	end

	local function fn26()
		if isfile("ForsakenCustomTracks.json") then
			local ok, result = pcall(function()
				return HttpService:JSONDecode(readfile("ForsakenCustomTracks.json"))
			end)

			if ok and type(result) == "table" then
				for k, v10 in pairs(result) do
					if tbl24[k] then
						for k2, v11 in pairs(v10) do
							tbl24[k][k2] = v11
						end
					end
				end
			end
		end
	end

	fn26()
	local tbl25 = {}

	local function fn27(arg, arg2, arg3, arg4)
		if arg3 ~= "Error" and arg3 ~= "Warn" and arg3 ~= "Notification" then
			arg3 = "Notification"
		end

		pcall(function()
			if typeof(v2) ~= "nil" and v2.Notification then
				v2:Notification({ Name = arg, Title = arg, Description = arg2, Content = arg2, Type = arg3, Duration = arg4 or 3 })
			end
		end)

		task.wait(0.05)
	end

	local function fn28(arg)
		return arg and string.gsub(string.gsub(string.gsub(arg, "\n", "\r\n"), "([^%w %-%_%.%~])", function(arg2)
			return string.format("%%%02X", string.byte(arg2))
		end), " ", "+")
	end

	local function fn29(arg)
		local n6 = 5381

		for i = 1, #arg do
			n6 = (n6 * 33 + string.byte(arg, i)) % 2147483647
		end

		return string.format("%x", n6)
	end

	local function fn30(arg)
		if not arg then
			return nil
		end
		return arg:match("v=([%w-_]+)") or arg:match("youtu%.be/([%w-_]+)") or arg:match("shorts/([%w-_]+)")
	end

	local function fn31(arg, arg2, arg3)
		local v10 = fn30(arg2)

		for k, v11 in pairs(tbl24[arg]) do
			if arg2 ~= "" and v11.Url == arg2 then
				return k, v11
			end

			if arg3 ~= "" and v11.File == arg3 then
				return k, v11
			end

			if v10 and v11.Url then
				local v12 = fn30(v11.Url)
				if v12 and v12 == v10 then
					return k, v11
				end
			end
		end

		return nil, nil
	end

	local function fn32(arg, arg2)
		if arg2 and arg2 ~= "" and not arg2:find("^https?://") and not arg2:find("^www%.") then
			local str4 = arg2:gsub("%s*%-?%s*Single%s*by.*$", ""):gsub("%s*%|%s*Spotify.*$", "")
			if #str4 > 30 then
				return str4:sub(1, 27) .. "..."
			end
			return str4
		end

		if arg:find("soundcloud%.com") then
			local str4 = (arg:gsub("%?.*$", ""):gsub("/+$", ""):match("([^/]+)$") or "SoundCloud Track"):gsub("%-", " "):gsub("%%20", " ")
			local sc

			if #str4 > 25 then
				sc = str4:sub(1, 22) .. "..."
			else
				sc = str4
			end

			return "SC: " .. sc
		end

		if arg:find("spotify%.com") then
			return "Spotify: " .. (arg:match("track/([%w]+)") or "Track"):sub(1, 10)
		end

		if arg:find("http") then
			local yt = fn30(arg)
			if yt then
				return "YT: " .. yt
			end
			return "Custom Track " .. tostring(math.random(100, 999))
		end

		return arg:gsub("%.mp3$", ""):gsub("%.ogg$", "")
	end

	local function fn33(arg)
		if not isfile(arg) then
			return nil
		end
		return (getcustomasset or getsynasset)(arg)
	end

	local function fn34(arg, arg2, arg3, arg4)
		local v10 = request_ or http_request
		local request_3

		if v10 then
			request_3 = v10
		else
			request_3 = syn and syn.request
		end

		local pos = arg2 and (arg2:find("youtube%.com") or arg2:find("youtu%.be"))
		local pos2 = arg2 and arg2:find("soundcloud%.com")
		local pos3 = arg2 and arg2:find("spotify%.com")

		if pos then
			local v11 = fn30(arg2)

			if v11 then
				arg = "yt_audio_" .. v11 .. ".mp3"
			else
				arg = "yt_audio_unknown_" .. tostring(math.random(1000, 9999)) .. ".mp3"
			end
		elseif pos2 then
			arg = "sc_audio_" .. fn29(arg2) .. ".mp3"
		elseif pos3 then
			arg = "sp_audio_" .. fn29(arg2) .. ".mp3"
		elseif (not arg or arg == "") and arg2 and arg2:find("http") then
			arg = "custom_audio_" .. fn29(arg2) .. ".mp3"
		end

		if not arg or arg == "" then
			return false, nil, nil
		end

		while tbl25[arg] do
			if arg3 and arg4 and tbl23[arg3] ~= arg4 then
				return false, nil, nil
			end
			task.wait(0.1)
		end

		local flag4 = isfile(arg)

		if flag4 then
			flag4 = readfile(arg):len() < 100
		end

		if flag4 then
			pcall(function()
				delfile(arg)
			end)
		end

		local v11 = nil

		if not isfile(arg) then
			tbl25[arg] = true
			local title

			if pos or pos2 or pos3 then
				fn27("Downloading Track", "Downloading track, please wait...", "Notification", 3)
				local str4 = "https://p.savenow.to/api/v2/download?format=mp3&url=" .. fn28(arg2)

				local tbl26 = {
					referer = "https://en.loader.to/",
					origin = "https://en.loader.to/",
					["user-agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
				}

				local ok, result = pcall(function()
					return request_3({ Url = str4, Method = "GET", Headers = tbl26 })
				end)

				if ok and result and result.StatusCode == 200 then
					local data = HttpService:JSONDecode(result.Body)
					title = nil
					title = data.title or title

					if data.info and data.info.title then
						title = data.info.title
					end

					local progressUrl = data.progress_url

					if progressUrl then
						if progressUrl:sub(1, 2) == "//" then
							progressUrl = "https:" .. progressUrl
						elseif progressUrl:sub(1, 1) == "/" then
							progressUrl = "https://p.savenow.to" .. progressUrl
						end

						local downloadUrl = nil
						local now = os.clock()
						local n6 = 0
						local n7 = 0

						while n6 < 120 do
							n6 += 1
							if arg3 and arg4 and tbl23[arg3] ~= arg4 then
								tbl25[arg] = nil
								return false, nil, nil
							end

							local ok2, result2 = pcall(function()
								return request_3({ Url = progressUrl, Method = "GET", Headers = tbl26 })
							end)

							if ok2 and result2.StatusCode == 200 then
								local data2 = HttpService:JSONDecode(result2.Body)

								if data2.title and data2.title ~= "" then
									title = data2.title
								end

								if data2.error or data2.text == "Error" or data2.text == "Failed" then
									fn27("Error", "Audio conversion error on server.", "Error")
									break
								end

								if data2.download_url and data2.download_url ~= "" then
									downloadUrl = data2.download_url
									break
								end
								local progress = data2.progress or n7
								local n8 = math.floor(progress / 10)

								if os.clock() - now >= 10 then
									now = os.clock()
									fn27("Downloading Track", "Converting audio: " .. tostring(n8) .. "%", "Notification", 2)
								end

								local flag5 = progress >= 1000
								local flag6

								if flag5 then
									flag6 = not data2.download_url or data2.download_url == ""
								else
									flag6 = flag5
								end

								if flag6 then
									fn27("Error", "Server provided no download link (service may be unsupported).", "Error")
									break
								end
								n7 = progress
							end

							task.wait(1.5)
						end

						if downloadUrl then
							if arg3 and arg4 and tbl23[arg3] ~= arg4 then
								tbl25[arg] = nil
								return false, nil, nil
							end
							fn27("Downloading Track", "Saving MP3 file...", "Notification", 2)

							local ok2, result2 = pcall(function()
								return request_3({ Url = downloadUrl, Method = "GET" })
							end)

							if ok2 and result2.StatusCode == 200 then
								writefile(arg, result2.Body)
							end
						end
					else
						fn27("Error", "API response error.", "Error")
					end
				else
					fn27("Error", "Failed to connect to Downloader API.", "Error")
					title = nil
				end
			else
				local pos4 = arg2 and arg2:find("http")
				title = nil

				if pos4 then
					fn27("Downloading Track", "Downloading direct MP3...", "Notification", 2)

					local ok, result = pcall(function()
						return request_3({ Url = arg2, Method = "GET" })
					end)

					ok = ok and result and result.StatusCode == 200
					title = nil

					if ok then
						writefile(arg, result.Body)
						title = nil
					end
				end
			end

			tbl25[arg] = nil
			v11 = title
		end

		return isfile(arg), arg, v11
	end

	local function fn35(arg, arg2)
		local name = arg.Name
		if name == "MapAmbience" then
			return "InGame"
		end

		if name == "LastSurvivor" then
			return "LMS"
		end

		if name == "lobby" or name == "oldLobby" or name == "deathLobby" or name == "spectreOutside" then
			return "Lobby"
		end

		if tbl2.ChaseSounds[fn24(arg2 or arg.SoundId)] then
			return "Chase"
		end
		return nil
	end

	local function fn36(arg, arg2)
		if not arg or not arg:IsA("Sound") then
			return
		end

		if not arg:GetAttribute("OriginalSoundId") then
			local soundId = arg.SoundId

			if soundId ~= "" and not soundId:find("rbxasset://") then
				arg:SetAttribute("OriginalSoundId", soundId)
			end
		end

		if not arg:GetAttribute("OriginalVolume") then
			arg:SetAttribute("OriginalVolume", arg.Volume)
		end

		if not arg:GetAttribute("GameVolume") then
			arg:SetAttribute("GameVolume", arg.Volume)
		end

		local attribute = arg:GetAttribute("OriginalSoundId")
		if not attribute then
			return
		end
		local v10 = fn35(arg, attribute)
		if not v10 then
			return
		end
		local v11 = tbl22[v10]
		local enabled = v11.Enabled

		if enabled then
			local v12 = tbl21[v10][v11.Mode] or tbl24[v10][v11.Mode]
			local str4 = ""
			local str5 = ""

			if v12 then
				str5 = v12.File
				str4 = v12.Url
			end

			local v13, v14 = fn34(str5, str4, v10, tbl23[v10])

			if v13 and v14 then
				local v15 = fn33(v14)

				if v15 and (arg.SoundId ~= v15 or arg2) then
					local playing = arg.Playing
					local attribute2 = arg:GetAttribute("GameVolume")
					arg.SoundId = v15
					arg:SetAttribute("IsCustom", true)
					arg:SetAttribute("CurrentAsset", v15)
					arg.TimePosition = 0

					if playing then
						arg:Play()
					end

					if attribute2 > 0 then
						arg:SetAttribute("IsUpdatingVolume", true)
						arg.Volume = volume
						arg:SetAttribute("IsUpdatingVolume", false)
					else
						arg:SetAttribute("IsUpdatingVolume", true)
						arg.Volume = 0
						arg:SetAttribute("IsUpdatingVolume", false)
					end

					if not arg:GetAttribute("VolumeHooked") then
						arg:SetAttribute("VolumeHooked", true)

						arg:GetPropertyChangedSignal("Volume"):Connect(function()
							if arg:GetAttribute("IsUpdatingVolume") then
								return
							end
							local volume2 = arg.Volume
							arg:SetAttribute("GameVolume", volume2)

							if arg:GetAttribute("IsCustom") then
								if volume2 > 0 then
									arg:SetAttribute("IsUpdatingVolume", true)
									arg.Volume = volume
									arg:SetAttribute("IsUpdatingVolume", false)
								end
							end
						end)
					end
				end
			else
				enabled = false
			end
		end

		if not enabled and arg:GetAttribute("IsCustom") then
			local playing = arg.Playing
			arg.SoundId = attribute
			arg:SetAttribute("IsCustom", false)
			local attribute2 = arg:GetAttribute("GameVolume")
			arg:SetAttribute("IsUpdatingVolume", true)

			if attribute2 > 0 then
				arg.Volume = arg:GetAttribute("OriginalVolume") or 1
			else
				arg.Volume = 0
			end

			arg:SetAttribute("IsUpdatingVolume", false)

			if playing then
				arg:Play()
			end
		end
	end

	local function fn37(arg, arg2)
		if not themes then
			return
		end

		for _, child in ipairs(themes:GetChildren()) do
			if arg2 then
				if fn35(child, child:GetAttribute("OriginalSoundId") or child.SoundId) == arg2 then
					fn36(child, arg)
				end
			else
				fn36(child, arg)
			end
		end
	end

	local flag4 = false

	local function fn38()
		if flag4 or not themes then
			return
		end
		flag4 = true

		themes.ChildAdded:Connect(function(child)
			task.wait(0.1)
			fn36(child)

			child:GetPropertyChangedSignal("SoundId"):Connect(function()
				if child:GetAttribute("IsCustom") and child.SoundId ~= child:GetAttribute("CurrentAsset") then
					fn36(child)
				end
			end)
		end)

		for _, child in ipairs(themes:GetChildren()) do
			fn36(child)

			child:GetPropertyChangedSignal("SoundId"):Connect(function()
				if child:GetAttribute("IsCustom") and child.SoundId ~= child:GetAttribute("CurrentAsset") then
					fn36(child)
				end
			end)
		end
	end

	Music:AddSlider({
		Name = "Global Custom Volume",
		Min = 0,
		Max = 1,
		Default = 0.4,
		Increment = 0.05,
		Callback = function(volume2)
			volume = volume2

			if themes then
				for _, child in ipairs(themes:GetChildren()) do
					if child:IsA("Sound") and child:GetAttribute("IsCustom") then
						local attribute = child:GetAttribute("GameVolume")

						if attribute == nil then
							attribute = child.Volume
						end

						if attribute > 0 then
							child:SetAttribute("IsUpdatingVolume", true)
							child.Volume = volume2
							child:SetAttribute("IsUpdatingVolume", false)
						end
					end
				end
			end
		end,
	})

	local tbl26 = {}

	for _, v10 in ipairs({
		{ ID = "LMS", Name = "LMS" },
		{ ID = "InGame", Name = "Map" },
		{ ID = "Chase", Name = "Chase" },
		{ ID = "Lobby", Name = "Lobby" },
	}) do
		Music:AddSection(v10.Name)

		Music:AddToggle({
			Name = "Enable " .. v10.Name .. " Replacement",
			Callback = function(enabled)
				tbl22[v10.ID].Enabled = enabled

				if enabled then
					fn38()
				end

				fn37(true, v10.ID)
			end,
		})

		local function fn39()
			local tbl27 = {}
			local flag5 = false

			for k in pairs(tbl24[v10.ID]) do
				table.insert(tbl27, k)
				flag5 = true
			end

			if flag5 then
				table.insert(tbl27, "───────────────")
			end

			for k in pairs(tbl21[v10.ID]) do
				table.insert(tbl27, k)
			end

			return tbl27
		end

		tbl26[v10.ID] = Music:AddDropdown({
			Name = "Select " .. v10.Name .. " Track",
			Options = fn39(),
			Callback = function(mode)
				if mode == "───────────────" or mode:find("^─") then
					return
				end
				tbl23[v10.ID] = tbl23[v10.ID] + 1
				tbl22[v10.ID].Mode = mode
				fn37(true, v10.ID)
			end,
		})

		Music:AddButton({
			Name = "Delete Selected Track (" .. v10.Name .. ")",
			Callback = function()
				local mode = tbl22[v10.ID].Mode
				local v11 = tbl24[v10.ID][mode]

				if v11 then
					tbl23[v10.ID] = tbl23[v10.ID] + 1

					pcall(function()
						if isfile(v11.File) then
							delfile(v11.File)
						end
					end)

					tbl24[v10.ID][mode] = nil
					fn25()
					local mode2 = next(tbl21[v10.ID])
					tbl22[v10.ID].Mode = mode2

					if tbl26[v10.ID] then
						tbl26[v10.ID]:UpdateOptions(fn39(), mode2)
					end

					fn37(true, v10.ID)
					fn27("Track Deleted", "Successfully deleted: " .. mode, "Notification")
				else
					fn27("Cannot Delete", "Default tracks cannot be deleted!", "Warn")
				end
			end,
		})

		Music:AddInput({
			Name = "Download/Add Track",
			Description = "File Name or URL",
			Callback = function(arg)
				local match = arg:match("^%s*(.-)%s*$") or ""
				if match == "" then
					return
				end

				if (match:find("youtube%.com") or match:find("youtu%.be") or match:find("soundcloud%.com") or match:find("spotify%.com")) and not match:find("^https?://") then
					match = "https://" .. match
				end

				local flag5 = match:find("http://") ~= nil or match:find("https://") ~= nil
				local str4 = ""
				local str5 = ""

				if flag5 then
					str5 = match
				else
					str4 = match

					if not (str4:lower():match("%.mp3$") or str4:lower():match("%.ogg$")) then
						str4 ..= ".mp3"
					end
				end

				tbl23[v10.ID] = tbl23[v10.ID] + 1
				local v11 = tbl23[v10.ID]

				task.spawn(function()
					local trackIsAlreadyDownloaded, v12 = fn31(v10.ID, str5, str4)
					local flag6 = trackIsAlreadyDownloaded and v12 and isfile(v12.File)

					if flag6 then
						flag6 = readfile(v12.File):len() > 100
					end

					if flag6 then
						tbl22[v10.ID].Mode = trackIsAlreadyDownloaded

						if tbl26[v10.ID] then
							tbl26[v10.ID]:UpdateOptions(fn39(), trackIsAlreadyDownloaded)
						end

						fn37(true, v10.ID)
						fn27("Already Loaded", "Track is already downloaded: " .. trackIsAlreadyDownloaded, "Notification")
						return
					end

					local v13, v14, v15 = fn34(str4, str5, v10.ID, v11)
					if tbl23[v10.ID] ~= v11 then
						return
					end

					if v13 and v14 then
						local addedTrack = fn32(match, v15)
						local v16 = fn31(v10.ID, str5, v14)

						if v16 and v16 ~= addedTrack then
							tbl24[v10.ID][v16] = nil
						end

						tbl24[v10.ID][addedTrack] = { File = v14, Url = str5 }
						fn25()

						if tbl26[v10.ID] then
							tbl26[v10.ID]:UpdateOptions(fn39(), addedTrack)
						end

						tbl22[v10.ID].Mode = addedTrack
						fn37(true, v10.ID)
						fn27("Success!", "Added track: " .. addedTrack, "Notification", 4)
					elseif flag5 then
						fn27("Download Error", "Failed to download audio.", "Error")
					else
						fn27("File Not Found", "File '" .. str4 .. "' was not found!", "Warn")
					end
				end)
			end,
		})
	end
end

task.wait()
local Fun
Fun = Misc2:AddTab("Fun", "Fun")
Fun:AddSection("Staff Detector")

do
	local connection5 = nil

	local function fn24(arg)
		local roleInGroup = arg:GetRoleInGroup(33548380)

		if tbl.Staff and tbl.Staff[roleInGroup] then
			localPlayer:Kick("Staff Detected: " .. arg.Name .. " | Role: " .. roleInGroup)
		end
	end

	local function fn25()
		if connection5 then
			connection5:Disconnect()
			connection5 = nil
		end

		if not tbl.StaffState then
			return
		end

		for _, player_ in ipairs(Players:GetPlayers()) do
			if player_ ~= localPlayer then
				task.spawn(fn24, player_)
			end
		end

		connection5 = Players.PlayerAdded:Connect(function(player_)
			task.wait(0.5)
			fn24(player_)
		end)
	end

	Fun:AddDropdown({
		Name = "Staff",
		Description = "Choose roles to detect",
		Multi = true,
		Options = {
			"Forsaken Developer",
			"Forsaken Head Moderator",
			"Forsaken Moderator",
			"Forsaken Contributor",
			"Forsaken Tester",
			"Member",
		},
		Callback = function(staff)
			tbl.Staff = staff
		end,
	})

	Fun:AddToggle({
		Name = "Leave if staff detected",
		Callback = function(staffState)
			tbl.StaffState = staffState
			fn25()
		end,
	})
end

Random.new()

do
	local flag4 = false
	local v10 = nil

	local function fn24(arg, arg2, arg3)
		local hitboxTargetMode = tbl.HitboxTargetMode
		local hitboxExpanderDistance = tbl.HitboxExpanderDistance
		local huge = hitboxTargetMode == "Lowest HP" and math.huge or hitboxExpanderDistance
		local v11 = nil

		for _, v12 in ipairs(arg) do
			if v12 ~= arg2 and v12:FindFirstChild("HumanoidRootPart") and v12:FindFirstChild("Humanoid") then
				local humanoid = v12.Humanoid

				if humanoid.Health > 0 then
					local magnitude = (v12.HumanoidRootPart.Position - arg3.Position).Magnitude

					if magnitude < hitboxExpanderDistance then
						if hitboxTargetMode == "Distance" then
							if magnitude < huge then
								huge = magnitude
								v11 = v12
							end
						elseif hitboxTargetMode == "Lowest HP" then
							local health = humanoid.Health

							if health < huge then
								huge = health
								v11 = v12
							elseif health == huge and v11 then
								if magnitude < (v11.HumanoidRootPart.Position - arg3.Position).Magnitude then
									v11 = v12
								end
							end
						end
					end
				end
			end
		end

		return v11
	end

	local function fn25(arg, arg2)
		local tbl21 = {}
		local players2 = workspace:FindFirstChild("Players")

		if players2 then
			for _, descendant in ipairs(players2:GetDescendants()) do
				table.insert(tbl21, descendant)
			end
		end

		local map = workspace:FindFirstChild("Map", true)
		map = map and map:FindFirstChild("NPCs", true)

		if map then
			for _, child in ipairs(map:GetChildren()) do
				table.insert(tbl21, child)
			end
		end

		return fn24(tbl21, arg, arg2)
	end

	local function fn26(arg)
		local players2 = workspace:FindFirstChild("Players")
		local killers2 = players2 and players2:FindFirstChild("Killers")
		if not killers2 then
			return nil
		end
		return fn24(killers2:GetChildren(), localPlayer.Character, arg)
	end

	local function fn27()
		if flag4 then
			return
		end
		flag4 = true
		task.spawn(function(...) end)
	end

	Fun:AddSection("Hitbox Expander (rage)")

	Fun:AddToggle({
		Name = "Enable Hitbox Expander",
		Callback = function(hitboxExpander)
			tbl.HitboxExpander = hitboxExpander

			if hitboxExpander then
				fn27()
			end
		end,
	})
end

Fun:AddDropdown({
	Name = "Target Priority",
	Options = { "Distance", "Lowest HP" },
	Callback = function(hitboxTargetMode)
		tbl.HitboxTargetMode = hitboxTargetMode
	end,
})

Fun:AddSlider({
	Name = "Hitbox Distance (studs)",
	Min = 1,
	Max = 200,
	Callback = function(hitboxExpanderDistance)
		tbl.HitboxExpanderDistance = hitboxExpanderDistance
	end,
})

Fun:AddSection("Godmode")

do
	local flag4 = false
	local flag5 = false
	local flag6 = false
	local flag7 = false
	local thread = nil

	local function fn24()
		if flag5 then
			return
		end
		local CharacterReplication = nil

		if pcall(function()
			CharacterReplication = require(ReplicatedStorage.Systems.Player.Game.CharacterReplication)
		end) and CharacterReplication and type(CharacterReplication.Serialize) == "function" then
			hookfunction(CharacterReplication.Serialize, function(...) end)
		end

		if not flag6 then
			flag6 = true
			forsakenFK.namecall.add(function(...) end)
		end

		flag5 = true
	end

	local function fn25()
		if thread then
			task.cancel(thread)
			thread = nil
		end

		flag7 = false

		thread = task.delay(0.5, function()
			if flag4 then
				flag7 = true
			end

			thread = nil
		end)
	end

	Fun:AddToggle({
		Name = "Enable Godmode",
		Description = "Moves your position down on the server",
		Callback = function(arg)
			flag4 = arg

			if arg then
				if not flag5 then
					fn24()
				end

				fn25()
			else
				if thread then
					task.cancel(thread)
					thread = nil
				end

				flag7 = false
			end
		end,
	})
end

Fun:AddSection("invisibility")

Fun:AddToggle({
	Name = "Enable invisibility",
	Callback = function(invisibility)
		tbl.Invisibility = invisibility
		fn13()
	end,
})

Fun:AddKeybind({
	Name = "Enable invisibility",
	Callback = function()
		tbl.Invisibility = not tbl.Invisibility
		fn13()
	end,
})

Fun:AddSection("Noclip")

do
	local function fn24()
		pcall(function()
			localPlayer.Character.Torso.CanCollide = false
			localPlayer.Character.HumanoidRootPart.CanCollide = false
			localPlayer.Character.Head.CanCollide = false
			localPlayer.Character.CollisionHitbox.CanCollide = false

			while wait(1) do
				if not tbl.Noclip then
					localPlayer.Character.Torso.CanCollide = true
					localPlayer.Character.HumanoidRootPart.CanCollide = true
					localPlayer.Character.Head.CanCollide = true
					localPlayer.Character.CollisionHitbox.CanCollide = true
					break
				else
					localPlayer.Character.Torso.CanCollide = false
					localPlayer.Character.HumanoidRootPart.CanCollide = false
					localPlayer.Character.Head.CanCollide = false
					localPlayer.Character.CollisionHitbox.CanCollide = false
				end
			end
		end)
	end

	local v10 = Fun:AddToggle({
		Name = "Enable Noclip",
		Callback = function(noclip)
			tbl.Noclip = noclip
			fn24()
		end,
	})

	Fun:AddKeybind({
		Name = "Enable Noclip",
		Callback = function()
			v10:Toggle()
		end,
	})
end

Fun:AddSection("TrollBox")

do
	local tbl21 = {
		Level = buffer.fromstring(string.pack("<Bd", 2, 2)),
		Duration = buffer.fromstring(string.pack("<Bd", 2, 10)),
		MaxLevel = buffer.fromstring(string.pack("<Bd", 2, 10)),
		SpeedName = buffer.fromstring(string.pack("<Bs4", 3, "Speed")),
		ColaName = buffer.fromstring(string.pack("<Bs4", 3, "BloxyCola")),
		Desc = buffer.fromstring(string.pack("<Bs4", 3, "Increases your movement speed.\nEvery level of this status increases speed by 10%.")),
		Stackable = buffer.fromstring("\1\0"),
		Applied = buffer.fromstring("\0"),
		TimePast = buffer.fromstring("\2\0\0\0\0\0\0\0\0"),
	}

	local flag4 = false

	local function fn24()
		if flag4 then
			return
		end

		local ok, result = pcall(function()
			return require(assets.Items.BloxyCola.Behavior)
		end)

		if not ok then
			local bloxyCola = assets.Items:FindFirstChild("BloxyCola")
			bloxyCola = bloxyCola and bloxyCola:FindFirstChild("Behavior")

			if bloxyCola then
				ok, result = pcall(require, bloxyCola)
			end
		end

		if not (ok and type(result) == "table" and type(result.Activated) == "function") then
			return
		end
		local activated = result.Activated

		result.Activated = function(arg, ...)
			if RunService:IsServer() or not tbl.InfiniteCola then
				return activated(arg, ...)
			end
			activated(arg, ...)
			local drinkTime = arg.Config and arg.Config.DrinkTime or 1.5

			task.spawn(function()
				task.wait(drinkTime - 0.5)
				if not tbl.InfiniteCola then
					return
				end

				if firesignal then
					firesignal(remoteEvent.OnClientEvent, 3, {
						tbl21.SpeedName,
						{
							Removed = tbl21.Applied,
							Data = {
								MaxLevel = tbl21.MaxLevel,
								Description = tbl21.Desc,
								Duration = tbl21.Duration,
								Level = tbl21.Level,
								AppliedFrom = tbl21.ColaName,
								Stackable = tbl21.Stackable,
							},
							Character = localPlayer.Character,
							Player = localPlayer,
							TimePast = tbl21.TimePast,
							Applied = tbl21.Applied,
							Level = tbl21.Level,
							AppliedFrom = tbl21.ColaName,
							TimeRequired = tbl21.Duration,
						},
						{
							MaxLevel = tbl21.MaxLevel,
							Description = tbl21.Desc,
							Duration = tbl21.Duration,
							Level = tbl21.Level,
							AppliedFrom = tbl21.ColaName,
							Stackable = tbl21.Stackable,
						},
					})
				end

				local character = localPlayer.Character
				character = character and character:FindFirstChildOfClass("Humanoid")

				if character then
					character:UnequipTools()
				end
			end)
		end

		flag4 = true
	end

	Fun:AddToggle({
		Name = "Inf Bloxy Cola",
		Callback = function(infiniteCola)
			tbl.InfiniteCola = infiniteCola

			if infiniteCola then
				fn24()
			end
		end,
	})
end

do
	local Ragdolls = nil
	local Icon = nil

	pcall(function()
		Ragdolls = require(ReplicatedStorage.Modules.Rendering.Ragdolls)
		Icon = require(ReplicatedStorage.Modules.Utilities.Icon)
	end)

	local v10 = nil

	local function fn24()
		local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")
		if not humanoid then
			return
		end
		humanoid.PlatformStand = true
		Ragdolls.EnableRagdoll(localPlayer.Character)
	end

	local function fn25()
		local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")
		if not humanoid then
			return
		end
		humanoid.PlatformStand = false
		Ragdolls.DisableRagdoll(localPlayer.Character)
	end

	Fun:AddToggle({
		Name = "Ragdoll (Not 100% FE)",
		Callback = function(arg)
			if arg then
				v10 = Icon.new():setImage(88371433550733):setLeft():setOrder(-10):setImageScale(0.75):bindEvent("selected", fn24):bindEvent("deselected", fn25):setEnabled(true)
			elseif v10 then
				fn25()
				v10:destroy()
				v10 = nil
			end
		end,
	})

	local tbl21 = { Enabled = false, Height = 15, Distance = 30, Duration = 0.6 }
	local v11 = nil

	local function fn26()
		if not tbl21.Enabled then
			return
		end

		if not localPlayer.Character then
			return
		end
		local character = localPlayer.Character
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then
			return
		end

		if character:FindFirstChild("IsFlipping") then
			return
		end
		local boolValue = Instance.new("BoolValue")
		boolValue.Name = "IsFlipping"
		boolValue.Parent = character
		local moveDirection = humanoid.MoveDirection

		if moveDirection.Magnitude < 0.1 then
			moveDirection = humanoidRootPart.CFrame.LookVector
		end

		humanoid.PlatformStand = true
		local attachment = Instance.new("Attachment")
		attachment.Name = "FlipAttachment"
		attachment.Parent = humanoidRootPart
		local linearVelocity = Instance.new("LinearVelocity")
		linearVelocity.MaxForce = math.huge
		linearVelocity.VectorVelocity = moveDirection * tbl21.Distance + Vector3.new(0, tbl21.Height, 0)
		linearVelocity.Attachment0 = attachment
		linearVelocity.Parent = humanoidRootPart
		local angularVelocity = Instance.new("AngularVelocity")
		angularVelocity.MaxTorque = math.huge
		angularVelocity.AngularVelocity = humanoidRootPart.CFrame.RightVector * 6.2831853071795862 / tbl21.Duration
		angularVelocity.Attachment0 = attachment
		angularVelocity.Parent = humanoidRootPart
		os.clock()
		RunService.Heartbeat:Connect(function(...) end)
	end

	local function fn27()
		local v12 = v11
		local flag4

		if v11 then
			flag4 = v12
		else
			flag4 = not Icon
		end

		if flag4 then
			return
		end

		v11 = Icon.new():setImage(131523679474566):setLeft():setOrder(-9):setImageScale(0.75):bindEvent("selected", function()
			fn26()
		end):setEnabled(true)
	end

	local function fn28()
		if v11 then
			v11:destroy()
			v11 = nil
		end
	end

	Fun:AddToggle({
		Name = "Enable Frontflip",
		Callback = function(enabled)
			tbl21.Enabled = enabled

			if enabled then
				fn27()
			else
				fn28()
			end
		end,
	})
end

do
	local tbl21 = { interval = 0.4, lastSendTime = 0, originalFireServer = nil }
	local flag4 = false

	local function fn24(arg)
		local flag5 = arg == nil and not flag4 or arg
		if flag5 == flag4 then
			return flag4
		end

		local ok, result = pcall(function()
			return require(v)
		end)

		if not ok then
			return flag4
		end

		if flag5 then
			if not tbl21.originalFireServer then
				tbl21.originalFireServer = result.FireServerConnection
			end

			result.FireServerConnection = function(arg2, arg3, arg4, ...)
				if arg4 ~= "UREMOTE_EVENT" then
					return tbl21.originalFireServer(arg2, arg3, arg4, ...)
				end
				local now = tick()
				if now - tbl21.lastSendTime >= tbl21.interval then
					tbl21.lastSendTime = now
					return tbl21.originalFireServer(arg2, arg3, arg4, ...)
				end
				return nil
			end

			flag4 = true
		else
			if tbl21.originalFireServer then
				result.FireServerConnection = tbl21.originalFireServer
			end

			flag4 = false
		end
	end

	Fun:AddToggle({
		Name = "Fake Lags (rage)",
		Callback = function(arg)
			fn24(arg)
		end,
	})
end

Fun:AddButton({
	Name = "Load Skin Changer",
	DestroyOnClick = true,
	Callback = function()
		fn2("https://raw.githubusercontent.com/zxcursedsocute/Forsaken-Script/refs/heads/main/skins", { Fun, Players })
	end,
})

local function fn24()
	local v10 = fn3()
	if not v10 or not killers then
		return nil
	end
	local v11 = nil
	local v12 = nil

	for _, v13 in ipairs(forsakenFK.Roster.killers()) do
		local humanoidRootPart = v13:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart then
			local magnitude = (humanoidRootPart.Position - v10.Position).Magnitude

			if not v11 or magnitude < v11 then
				v11 = magnitude
				v12 = v13
			end
		end
	end

	return v12
end

Fun:AddSection("Stupid Ai")

Fun:AddButton({
	Name = "load AI",
	DestroyOnClick = true,
	Callback = function()
		fn2("https://raw.githubusercontent.com/zxcursedsocute/Trollge-Incident-Fights-Reborn2-script/refs/heads/main/dontlooknigger", {
			Fun,
			tbl,
			fn10,
			fn24,
			remoteEvent,
			function(arg)
				local v10 = fn23(arg)
				return buffer.fromstring(string.pack("<Bi4", 3, #v10) .. v10)
			end,
		}, nil, true)
	end,
})

task.wait()
local Teleport = Misc2:AddTab("Teleport", "Teleport")

Teleport:AddButton({
	Name = "Load Teleports",
	DestroyOnClick = true,
	Callback = function()
		fn2("https://raw.githubusercontent.com/zxcursedsocute/Fish-It/refs/heads/main/ijaWADO.txt", { Teleport, Players, localPlayer, Workspace, assets })
	end,
})

task.wait()
fn2("https://raw.githubusercontent.com/zxcursedsocute/Forsaken-Script/refs/heads/main/settings2.txt", { Misc2:AddTab("UI settings", "Settings"), v2, UserInputService })
