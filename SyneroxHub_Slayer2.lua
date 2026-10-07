local Players
Players = game:GetService("Players")
local RunService
RunService = game:GetService("RunService")
local UserInputService
UserInputService = game:GetService("UserInputService")
game:GetService("TweenService")
local Workspace
Workspace = game:GetService("Workspace")
local ReplicatedStorage
ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager
VirtualInputManager = game:GetService("VirtualInputManager")
game:GetService("TeleportService")
game:GetService("CollectionService")
local localPlayer
localPlayer = Players.LocalPlayer

while not localPlayer do
	task.wait()
	localPlayer = Players.LocalPlayer
end

if getgenv()._SyneroxOuwlandRunning and getgenv()._SyneroxOuwlandDestroy then
	pcall(getgenv()._SyneroxOuwlandDestroy)
	task.wait(0.3)
end

if getgenv()._ZenithLockDestroy then
	pcall(getgenv()._ZenithLockDestroy)
	getgenv()._ZenithLockDestroy = nil
end

getgenv()._SyneroxOuwlandRunning = true

print("[Slayers 2] build=2026-09-30e-DEVSKIP-ON (no comments)")

if _G.SlayersKyokaHub and _G.SlayersKyokaHub.Destroy then
	pcall(function()
		_G.SlayersKyokaHub:Destroy()
	end)

	_G.SlayersKyokaHub = nil
end

if _G.SlayersSyneroxHub and _G.SlayersSyneroxHub.Destroy then
	pcall(function()
		_G.SlayersSyneroxHub:Destroy()
	end)

	_G.SlayersSyneroxHub = nil
end

pcall(function()
	local CoreGui = game:GetService("CoreGui")

	local function fn(arg)
		if not arg then
			return
		end

		for _, child in ipairs(arg:GetChildren()) do
			if child:IsA("ScreenGui") and (child.Name:find("Vesper") or child.Name:find("Kyoka") or child.Name:find("AuroraLib") or child.Name:find("Synerox")) then
				pcall(function()
					child:Destroy()
				end)
			end
		end
	end

	fn(CoreGui)

	if CoreGui:FindFirstChild("RobloxGui") then
		fn(CoreGui.RobloxGui)
	end

	if localPlayer and localPlayer:FindFirstChild("PlayerGui") then
		fn(localPlayer.PlayerGui)
	end
end)

local v
v = nil

do
	local ok, result = pcall(function()
		return loadstring(game:HttpGet("https://synex.lat/loaders/synerox.lua"))()
	end)

	if ok and result then
		v = result
	else
		for _, v2 in ipairs({
			"https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua",
			"https://pastebin.com/raw/0wYyH9Z2",
		}) do
			local ok2, result2 = pcall(function()
				return loadstring(game:HttpGet(v2))()
			end)

			if ok2 and result2 then
				v = result2
				break
			end
		end
	end
end

if not v then
	warn("[Synerox] Fatal: Failed to initialize Aurora UI Library")
	return
end

local fn

fn = function(arg, arg2, arg3)
	pcall(function()
		if not v or not v.Notify then
			return
		end

		if type(arg) == "table" then
			v:Notify({ Title = arg.Title or "Synerox", Content = arg.Content or "", Duration = arg.Duration or 3.5 })
		else
			v:Notify({ Title = tostring(arg or "Synerox"), Content = tostring(arg2 or ""), Duration = arg3 or 3.5 })
		end
	end)
end

do
	local VALID_KEYS = {
		["zenith1"] = true,
	}

	local DISCORD_URL = "https://discord.gg/qtpXAmu6UA"

	local SOUNDS = {
		Click = "rbxassetid://6895079853",
		Toggle = "rbxassetid://6895079683",
		Notif = "rbxassetid://4590657391",
	}

	local NEON_CYAN = Color3.fromRGB(0, 235, 255)
	local NEON_PURPLE = Color3.fromRGB(160, 85, 255)
	local NEON_PINK = Color3.fromRGB(255, 75, 155)
	local SUCCESS = Color3.fromRGB(45, 225, 140)
	local WARNING = Color3.fromRGB(255, 185, 45)
	local DANGER = Color3.fromRGB(255, 75, 90)

	local WINDOW_GLASS = Color3.fromRGB(10, 12, 18)
	local CARD_GLASS = Color3.fromRGB(18, 22, 33)
	local CARD_STROKE = Color3.fromRGB(42, 48, 68)
	local TEXT_PRIMARY = Color3.fromRGB(245, 248, 255)
	local TEXT_SECONDARY = Color3.fromRGB(150, 158, 182)
	local TEXT_MUTED = Color3.fromRGB(95, 103, 128)
	local ACCENT_TEXT = Color3.fromRGB(5, 10, 16)
	local GETKEY_BG = Color3.fromRGB(24, 28, 42)

	local TweenService = game:GetService("TweenService")
	local Lighting = game:GetService("Lighting")
	local SoundService = game:GetService("SoundService")

	local function playSound(asset, volume)
		pcall(function()
			local sound = Instance.new("Sound")
			sound.SoundId = asset
			sound.Volume = volume or 0.3
			sound.Parent = SoundService
			sound:Play()
			task.delay(2, function()
				sound:Destroy()
			end)
		end)
	end

	local function openInBrowser(url)
		local opened = false

		pcall(function()
			for _, fn in ipairs({ openurl, openUrl, OpenUrl, open_url, windowopen, WindowOpen }) do
				if type(fn) == "function" then
					local ok = pcall(fn, url)

					if ok and not opened then
						opened = true
					end
				end
			end
		end)

		pcall(function()
			local genv = getgenv and getgenv() or {}

			for _, name in ipairs({ "openurl", "openUrl", "OpenUrl", "open_url", "OpenURL", "windowopen" }) do
				if type(genv[name]) == "function" then
					local ok = pcall(genv[name], url)

					if ok and not opened then
						opened = true
					end
				end
			end
		end)

		return opened
	end

	local parentGui = nil

	do
		local ok, coreGui = pcall(function()
			return game:GetService("CoreGui")
		end)

		if ok and coreGui then
			parentGui = coreGui
		else
			ok, parentGui = pcall(function()
				return localPlayer:WaitForChild("PlayerGui")
			end)
		end
	end

	local function notify(content)
		local gui = Instance.new("ScreenGui")
		gui.Name = "ZenithLockToast"
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = true
		gui.DisplayOrder = 1000
		gui.Parent = parentGui

		local card = Instance.new("Frame")
		card.Size = UDim2.new(0, 300, 0, 52)
		card.AnchorPoint = Vector2.new(0.5, 0)
		card.Position = UDim2.new(0.5, 0, 0, 24)
		card.BackgroundColor3 = WINDOW_GLASS
		card.BackgroundTransparency = 0.1
		card.BorderSizePixel = 0
		card.Parent = gui

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 12)
		corner.Parent = card

		local stroke = Instance.new("UIStroke")
		stroke.Color = NEON_CYAN
		stroke.Transparency = 0.4
		stroke.Thickness = 1.2
		stroke.Parent = card

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -20, 1, 0)
		label.Position = UDim2.new(0, 10, 0, 0)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 13
		label.TextColor3 = TEXT_PRIMARY
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Text = content
		label.Parent = card

		task.wait(3.5)

		pcall(function()
			TweenService:Create(card, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
			TweenService:Create(label, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
			TweenService:Create(stroke, TweenInfo.new(0.3), { Transparency = 1 }):Play()
		end)

		task.wait(0.35)

		pcall(function()
			gui:Destroy()
		end)
	end

	local zenUnlocked = false
	local isChecking = false
	local TryUnlock = nil

	local DEV_SKIP = true

	local devSkip = DEV_SKIP or getgenv().ZenithDevSkip == true

	if devSkip then
		zenUnlocked = true
		getgenv().SCRIPT_KEY = "devskip"
		getgenv().SyneroxTier = "premium"
		print("[Zenith] DEV SKIP - key gate bypassed.")
	end

	local existingLock = parentGui and parentGui:FindFirstChild("ZenithLock")

	if existingLock then
		existingLock:Destroy()
	end

	local lockScreen = Instance.new("ScreenGui")
	lockScreen.Name = "ZenithLock"
	lockScreen.ResetOnSpawn = false
	lockScreen.IgnoreGuiInset = true
	lockScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	lockScreen.DisplayOrder = 999

	if not devSkip then
		lockScreen.Parent = parentGui
	end

	local lockBlur = nil

	if not devSkip then
		pcall(function()
			lockBlur = Instance.new("BlurEffect")
			lockBlur.Name = "ZenithLockBlur"
			lockBlur.Size = 8
			lockBlur.Parent = Lighting
		end)
	end

	local dim = Instance.new("Frame")
	dim.Name = "Dim"
	dim.Size = UDim2.fromScale(1, 1)
	dim.BackgroundColor3 = Color3.fromRGB(4, 6, 12)
	dim.BackgroundTransparency = 0.35
	dim.BorderSizePixel = 0
	dim.Active = true
	dim.Parent = lockScreen

	local function FreezeHumanoid(hum)
		hum.WalkSpeed = 0
		hum.JumpPower = 0
		hum.JumpHeight = 0
		hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			if not zenUnlocked then
				hum.WalkSpeed = 0
			end
		end)

		if hum and not zenUnlocked then
			hum.JumpPower = 0
			hum.JumpHeight = 0
		end
	end

	local function HoldCharacter(char)
		local hum = char and char:WaitForChild("Humanoid", 10)

		if hum and not zenUnlocked then
			FreezeHumanoid(hum)
		end
	end

	task.spawn(function()
		HoldCharacter(localPlayer.Character)
	end)

	local charConn = localPlayer.CharacterAdded:Connect(HoldCharacter)

	local function UnfreezeCharacter()
		pcall(function()
			local char = localPlayer.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")

			if hum then
				hum.WalkSpeed = 16
				hum.JumpPower = 50
				hum.JumpHeight = 7.2
			end
		end)
	end

	local lockCard = Instance.new("Frame")
	lockCard.Name = "LockCard"
	lockCard.Size = UDim2.new(0, 390, 0, 440)
	lockCard.AnchorPoint = Vector2.new(0.5, 0.5)
	lockCard.Position = UDim2.new(0.5, 0, 0.5, 0)
	lockCard.BackgroundColor3 = WINDOW_GLASS
	lockCard.BackgroundTransparency = 0.08
	lockCard.BorderSizePixel = 0
	lockCard.ClipsDescendants = true
	lockCard.Active = true
	lockCard.Parent = lockScreen

	local lockCorner = Instance.new("UICorner")
	lockCorner.CornerRadius = UDim.new(0, 16)
	lockCorner.Parent = lockCard

	local lockStroke = Instance.new("UIStroke")
	lockStroke.Color = Color3.fromRGB(255, 255, 255)
	lockStroke.Thickness = 1.8
	lockStroke.Parent = lockCard

	local borderGradient = Instance.new("UIGradient")
	borderGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.0, NEON_PURPLE),
		ColorSequenceKeypoint.new(0.35, NEON_CYAN),
		ColorSequenceKeypoint.new(0.70, NEON_PINK),
		ColorSequenceKeypoint.new(1.0, NEON_PURPLE),
	})
	borderGradient.Rotation = 45
	borderGradient.Parent = lockStroke

	local rotAngle = 0
	local rotConn = RunService.RenderStepped:Connect(function(dt)
		rotAngle = (rotAngle + (dt * 45)) % 360
		borderGradient.Rotation = rotAngle
	end)

	local sheen = Instance.new("Frame")
	sheen.Name = "Sheen"
	sheen.Size = UDim2.new(1, 0, 0, 90)
	sheen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sheen.BorderSizePixel = 0
	sheen.Parent = lockCard

	local sheenGrad = Instance.new("UIGradient")
	sheenGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.94),
		NumberSequenceKeypoint.new(0.4, 0.98),
		NumberSequenceKeypoint.new(1, 1),
	})
	sheenGrad.Rotation = 90
	sheenGrad.Parent = sheen

	local lockAccent = Instance.new("Frame")
	lockAccent.Name = "LockAccent"
	lockAccent.Size = UDim2.new(0, 64, 0, 3)
	lockAccent.AnchorPoint = Vector2.new(0.5, 0)
	lockAccent.Position = UDim2.new(0.5, 0, 0, 0)
	lockAccent.BackgroundColor3 = NEON_CYAN
	lockAccent.BorderSizePixel = 0
	lockAccent.Parent = lockCard

	local lockAccentCorner = Instance.new("UICorner")
	lockAccentCorner.CornerRadius = UDim.new(1, 0)
	lockAccentCorner.Parent = lockAccent

	local brandLogo = Instance.new("TextLabel")
	brandLogo.Name = "BrandLogo"
	brandLogo.Size = UDim2.new(0, 38, 0, 38)
	brandLogo.AnchorPoint = Vector2.new(0.5, 0)
	brandLogo.Position = UDim2.new(0.5, 0, 0, 20)
	brandLogo.BackgroundColor3 = CARD_GLASS
	brandLogo.BackgroundTransparency = 0.2
	brandLogo.Text = "\u{1F7E1}"
	brandLogo.TextSize = 18
	brandLogo.TextColor3 = NEON_CYAN
	brandLogo.Font = Enum.Font.GothamBold
	brandLogo.Parent = lockCard

	local brandLogoCorner = Instance.new("UICorner")
	brandLogoCorner.CornerRadius = UDim.new(0, 10)
	brandLogoCorner.Parent = brandLogo

	local brandLogoStroke = Instance.new("UIStroke")
	brandLogoStroke.Color = NEON_CYAN
	brandLogoStroke.Transparency = 0.4
	brandLogoStroke.Thickness = 1.2
	brandLogoStroke.Parent = brandLogo

	local lockTitle = Instance.new("TextLabel")
	lockTitle.Name = "LockTitle"
	lockTitle.Size = UDim2.new(1, 0, 0, 28)
	lockTitle.Position = UDim2.new(0, 0, 0, 64)
	lockTitle.BackgroundTransparency = 1
	lockTitle.Font = Enum.Font.GothamBlack
	lockTitle.TextSize = 22
	lockTitle.TextColor3 = TEXT_PRIMARY
	lockTitle.RichText = true
	lockTitle.Text = "<b>ZENITH</b> <font color=\"rgb(0,235,255)\">STUDIO</font>"
	lockTitle.TextXAlignment = Enum.TextXAlignment.Center
	lockTitle.Parent = lockCard

	local lockSubtitle = Instance.new("TextLabel")
	lockSubtitle.Name = "LockSubtitle"
	lockSubtitle.Size = UDim2.new(1, -40, 0, 16)
	lockSubtitle.AnchorPoint = Vector2.new(0.5, 0)
	lockSubtitle.Position = UDim2.new(0.5, 0, 0, 94)
	lockSubtitle.BackgroundTransparency = 1
	lockSubtitle.Font = Enum.Font.Gotham
	lockSubtitle.TextSize = 12
	lockSubtitle.TextColor3 = TEXT_SECONDARY
	lockSubtitle.Text = "Enter your license key to continue"
	lockSubtitle.TextXAlignment = Enum.TextXAlignment.Center
	lockSubtitle.Parent = lockCard

	local statusBadge = Instance.new("Frame")
	statusBadge.Name = "StatusBadge"
	statusBadge.Size = UDim2.new(0, 240, 0, 24)
	statusBadge.AnchorPoint = Vector2.new(0.5, 0)
	statusBadge.Position = UDim2.new(0.5, 0, 0, 118)
	statusBadge.BackgroundColor3 = CARD_GLASS
	statusBadge.BackgroundTransparency = 0.35
	statusBadge.BorderSizePixel = 0
	statusBadge.Parent = lockCard

	local sbCorner = Instance.new("UICorner")
	sbCorner.CornerRadius = UDim.new(0, 12)
	sbCorner.Parent = statusBadge

	local sbStroke = Instance.new("UIStroke")
	sbStroke.Color = CARD_STROKE
	sbStroke.Transparency = 0.5
	sbStroke.Thickness = 1
	sbStroke.Parent = statusBadge

	local sbDot = Instance.new("Frame")
	sbDot.Name = "Dot"
	sbDot.Size = UDim2.new(0, 6, 0, 6)
	sbDot.AnchorPoint = Vector2.new(0, 0.5)
	sbDot.Position = UDim2.new(0, 10, 0.5, 0)
	sbDot.BackgroundColor3 = WARNING
	sbDot.BorderSizePixel = 0
	sbDot.Parent = statusBadge

	local sbDotCorner = Instance.new("UICorner")
	sbDotCorner.CornerRadius = UDim.new(1, 0)
	sbDotCorner.Parent = sbDot

	local lockStatus = Instance.new("TextLabel")
	lockStatus.Name = "StatusText"
	lockStatus.Size = UDim2.new(1, -26, 1, 0)
	lockStatus.Position = UDim2.new(0, 22, 0, 0)
	lockStatus.BackgroundTransparency = 1
	lockStatus.Font = Enum.Font.GothamMedium
	lockStatus.TextSize = 11
	lockStatus.TextColor3 = TEXT_SECONDARY
	lockStatus.TextXAlignment = Enum.TextXAlignment.Left
	lockStatus.TextTruncate = Enum.TextTruncate.AtEnd
	lockStatus.Text = "License Gate \u{2022} Awaiting Key"
	lockStatus.Parent = statusBadge

	local keyLabel = Instance.new("TextLabel")
	keyLabel.Name = "KeyLabel"
	keyLabel.Size = UDim2.new(1, -48, 0, 14)
	keyLabel.AnchorPoint = Vector2.new(0.5, 0)
	keyLabel.Position = UDim2.new(0.5, 0, 0, 152)
	keyLabel.BackgroundTransparency = 1
	keyLabel.Font = Enum.Font.GothamBold
	keyLabel.TextSize = 10
	keyLabel.TextColor3 = TEXT_MUTED
	keyLabel.TextXAlignment = Enum.TextXAlignment.Left
	keyLabel.Text = "LICENSE KEY"
	keyLabel.Parent = lockCard

	local keyBox = Instance.new("TextBox")
	keyBox.Name = "KeyBox"
	keyBox.Size = UDim2.new(1, -48, 0, 42)
	keyBox.AnchorPoint = Vector2.new(0.5, 0)
	keyBox.Position = UDim2.new(0.5, 0, 0, 170)
	keyBox.BackgroundColor3 = CARD_GLASS
	keyBox.BackgroundTransparency = 0.25
	keyBox.BorderSizePixel = 0
	keyBox.Font = Enum.Font.GothamBold
	keyBox.TextSize = 14
	keyBox.TextColor3 = TEXT_PRIMARY
	keyBox.PlaceholderText = "ENTER KEY"
	keyBox.PlaceholderColor3 = TEXT_MUTED
	keyBox.TextXAlignment = Enum.TextXAlignment.Center
	keyBox.ClearTextOnFocus = false
	keyBox.Text = ""
	keyBox.Parent = lockCard

	local keyCorner = Instance.new("UICorner")
	keyCorner.CornerRadius = UDim.new(0, 8)
	keyCorner.Parent = keyBox

	local keyStroke = Instance.new("UIStroke")
	keyStroke.Color = CARD_STROKE
	keyStroke.Transparency = 0.5
	keyStroke.Thickness = 1
	keyStroke.Parent = keyBox

	keyBox.Focused:Connect(function()
		TweenService:Create(keyStroke, TweenInfo.new(0.2), {
			Color = NEON_CYAN,
			Transparency = 0.2,
			Thickness = 1.4,
		}):Play()
	end)

	keyBox.FocusLost:Connect(function(enterPressed)
		TweenService:Create(keyStroke, TweenInfo.new(0.2), { Color = CARD_STROKE, Transparency = 0.5, Thickness = 1 }):Play()

		if enterPressed and TryUnlock then
			TryUnlock()
		end
	end)

	local unlockBtn = Instance.new("TextButton")
	unlockBtn.Name = "UnlockBtn"
	unlockBtn.Size = UDim2.new(1, -48, 0, 42)
	unlockBtn.AnchorPoint = Vector2.new(0.5, 0)
	unlockBtn.Position = UDim2.new(0.5, 0, 0, 224)
	unlockBtn.BackgroundColor3 = NEON_CYAN
	unlockBtn.BorderSizePixel = 0
	unlockBtn.AutoButtonColor = false
	unlockBtn.Font = Enum.Font.GothamBold
	unlockBtn.TextSize = 14
	unlockBtn.TextColor3 = ACCENT_TEXT
	unlockBtn.Text = "UNLOCK"
	unlockBtn.Parent = lockCard

	local unlockCorner = Instance.new("UICorner")
	unlockCorner.CornerRadius = UDim.new(0, 8)
	unlockCorner.Parent = unlockBtn

	local getKeyBtn = Instance.new("TextButton")
	getKeyBtn.Name = "GetKeyBtn"
	getKeyBtn.Size = UDim2.new(1, -48, 0, 38)
	getKeyBtn.AnchorPoint = Vector2.new(0.5, 0)
	getKeyBtn.Position = UDim2.new(0.5, 0, 0, 276)
	getKeyBtn.BackgroundColor3 = GETKEY_BG
	getKeyBtn.BackgroundTransparency = 0.25
	getKeyBtn.BorderSizePixel = 0
	getKeyBtn.AutoButtonColor = false
	getKeyBtn.Font = Enum.Font.GothamBold
	getKeyBtn.TextSize = 13
	getKeyBtn.TextColor3 = TEXT_PRIMARY
	getKeyBtn.Text = "GET A KEY"
	getKeyBtn.Parent = lockCard

	local getKeyCorner = Instance.new("UICorner")
	getKeyCorner.CornerRadius = UDim.new(0, 8)
	getKeyCorner.Parent = getKeyBtn

	local getKeyStroke = Instance.new("UIStroke")
	getKeyStroke.Color = CARD_STROKE
	getKeyStroke.Transparency = 0.6
	getKeyStroke.Thickness = 1
	getKeyStroke.Parent = getKeyBtn

	local discordBtn = Instance.new("TextButton")
	discordBtn.Name = "DiscordBtn"
	discordBtn.Size = UDim2.new(1, -48, 0, 30)
	discordBtn.AnchorPoint = Vector2.new(0.5, 0)
	discordBtn.Position = UDim2.new(0.5, 0, 0, 324)
	discordBtn.BackgroundTransparency = 1
	discordBtn.AutoButtonColor = false
	discordBtn.Font = Enum.Font.GothamMedium
	discordBtn.TextSize = 12
	discordBtn.TextColor3 = TEXT_SECONDARY
	discordBtn.Text = "Need a key or help? Join Discord"
	discordBtn.Parent = lockCard

	discordBtn.MouseEnter:Connect(function()
		TweenService:Create(discordBtn, TweenInfo.new(0.15), { TextColor3 = NEON_CYAN }):Play()
	end)

	discordBtn.MouseLeave:Connect(function()
		TweenService:Create(discordBtn, TweenInfo.new(0.15), { TextColor3 = TEXT_SECONDARY }):Play()
	end)

	discordBtn.MouseButton1Click:Connect(function()
		playSound(SOUNDS.Click, 0.3)

		if not openInBrowser(DISCORD_URL) then
			pcall(function()
				if setclipboard then
					setclipboard(DISCORD_URL)
				end
			end)

			lockStatus.Text = "Discord link copied to clipboard"
			sbDot.BackgroundColor3 = WARNING
			TweenService:Create(sbStroke, TweenInfo.new(0.2), { Color = WARNING, Transparency = 0.2 }):Play()
		end
	end)

	local lockFooter = Instance.new("TextLabel")
	lockFooter.Name = "FooterLabel"
	lockFooter.Size = UDim2.new(1, 0, 0, 20)
	lockFooter.AnchorPoint = Vector2.new(0.5, 1)
	lockFooter.Position = UDim2.new(0.5, 0, 1, -14)
	lockFooter.BackgroundTransparency = 1
	lockFooter.Font = Enum.Font.GothamMedium
	lockFooter.TextSize = 10
	lockFooter.TextColor3 = TEXT_MUTED
	lockFooter.Text = "ZENITH STUDIO \u{2022} OFFLINE KEY"
	lockFooter.TextXAlignment = Enum.TextXAlignment.Center
	lockFooter.Parent = lockCard

	TryUnlock = function()
		if zenUnlocked or isChecking then
			return
		end

		local key = (keyBox.Text:gsub("%s+", ""))

		if #key == 0 then
			lockStatus.Text = "Enter your key first"
			sbDot.BackgroundColor3 = WARNING
			TweenService:Create(sbStroke, TweenInfo.new(0.2), { Color = WARNING, Transparency = 0.2 }):Play()
			playSound(SOUNDS.Notif, 0.3)

			return
		end

		isChecking = true
		unlockBtn.Text = "CHECKING..."
		unlockBtn.Active = false
		lockStatus.Text = "Verifying key..."
		sbDot.BackgroundColor3 = NEON_CYAN
		TweenService:Create(sbStroke, TweenInfo.new(0.2), { Color = NEON_CYAN, Transparency = 0.2 }):Play()

		task.spawn(function()
			local ok = VALID_KEYS[key:lower()] == true

			if not ok then
				isChecking = false
				unlockBtn.Text = "UNLOCK"
				unlockBtn.Active = true

				lockStatus.Text = "Invalid key entered"
				sbDot.BackgroundColor3 = DANGER
				TweenService:Create(sbStroke, TweenInfo.new(0.2), { Color = DANGER, Transparency = 0.2 }):Play()
				playSound(SOUNDS.Notif, 0.4)

				return
			end

			zenUnlocked = true

			getgenv().SCRIPT_KEY = key
			getgenv().SyneroxTier = "premium"
			v.IsPremium = true

			if rotConn then
				rotConn:Disconnect()
				rotConn = nil
			end

			pcall(function()
				if charConn then
					charConn:Disconnect()
					charConn = nil
				end
			end)

			pcall(function()
				if lockBlur then
					lockBlur:Destroy()
					lockBlur = nil
				end
			end)

			sbDot.BackgroundColor3 = SUCCESS
			lockStatus.Text = "Key Accepted \u{2022} Loading UI..."
			TweenService:Create(sbStroke, TweenInfo.new(0.2), { Color = SUCCESS, Transparency = 0.2 }):Play()

			UnfreezeCharacter()

			playSound(SOUNDS.Toggle, 0.4)

			pcall(function()
				for _, d in ipairs(lockScreen:GetDescendants()) do
					if d:IsA("GuiObject") then
						TweenService:Create(d, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
					end

					if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
						TweenService:Create(d, TweenInfo.new(0.25), { TextTransparency = 1 }):Play()
					end

					if d:IsA("UIStroke") then
						TweenService:Create(d, TweenInfo.new(0.25), { Transparency = 1 }):Play()
					end
				end

				task.wait(0.3)
			end)

			pcall(function()
				lockScreen:Destroy()
			end)

			print("[Zenith] Key accepted - " .. localPlayer.Name)

			task.spawn(function()
				notify("Key accepted - welcome back, " .. localPlayer.Name .. "!")
			end)
		end)
	end

	unlockBtn.MouseButton1Click:Connect(function()
		playSound(SOUNDS.Click, 0.4)
		TryUnlock()
	end)

	getKeyBtn.MouseButton1Click:Connect(function()
		playSound(SOUNDS.Click, 0.3)

		if openInBrowser(DISCORD_URL) then
			lockStatus.Text = "Discord opened - grab a key there!"
			sbDot.BackgroundColor3 = SUCCESS
			TweenService:Create(sbStroke, TweenInfo.new(0.2), { Color = SUCCESS, Transparency = 0.2 }):Play()
		else
			pcall(function()
				if setclipboard then
					setclipboard(DISCORD_URL)
				end
			end)

			lockStatus.Text = "Discord link copied to clipboard"
			sbDot.BackgroundColor3 = WARNING
			TweenService:Create(sbStroke, TweenInfo.new(0.2), { Color = WARNING, Transparency = 0.2 }):Play()
		end
	end)

	unlockBtn.MouseEnter:Connect(function()
		if not isChecking then
			TweenService:Create(unlockBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0.15 }):Play()
		end
	end)

	unlockBtn.MouseLeave:Connect(function()
		TweenService:Create(unlockBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0 }):Play()
	end)

	getKeyBtn.MouseEnter:Connect(function()
		TweenService:Create(getKeyBtn, TweenInfo.new(0.15), { BackgroundColor3 = CARD_STROKE }):Play()
		TweenService:Create(getKeyStroke, TweenInfo.new(0.15), { Color = NEON_CYAN, Transparency = 0.3 }):Play()
	end)

	getKeyBtn.MouseLeave:Connect(function()
		TweenService:Create(getKeyBtn, TweenInfo.new(0.15), { BackgroundColor3 = GETKEY_BG }):Play()
		TweenService:Create(getKeyStroke, TweenInfo.new(0.15), { Color = CARD_STROKE, Transparency = 0.6 }):Play()
	end)

	getgenv()._ZenithLockDestroy = function()
		zenUnlocked = true
		UnfreezeCharacter()

		pcall(function()
			if rotConn then
				rotConn:Disconnect()
				rotConn = nil
			end
		end)

		pcall(function()
			if charConn then
				charConn:Disconnect()
				charConn = nil
			end
		end)

		pcall(function()
			if lockBlur then
				lockBlur:Destroy()
				lockBlur = nil
			end
		end)

		pcall(function()
			lockScreen:Destroy()
		end)
	end

	if not devSkip then
		print("[Zenith] Lock screen loaded - enter key to unlock.")
	end

	repeat
		task.wait(0.1)
	until zenUnlocked
end

v.IsPremium = getgenv().SyneroxTier == "premium"
local slayersSyneroxHub
slayersSyneroxHub = nil
local SignalFunction
SignalFunction = nil

pcall(function()
	SignalFunction = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction)

	if SignalFunction and type(SignalFunction.ToServer) == "function" and not SignalFunction._kyokaHooked then
		local toServer = SignalFunction.ToServer

		SignalFunction.ToServer = function(arg, ...)
			local v2 = table.pack(...)

			if arg == "SunDamage" and slayersSyneroxHub and slayersSyneroxHub.Combat and slayersSyneroxHub.Combat.NoSunDamage then
				if select(1, ...) == true then
					return toServer(arg, false)
				end
				return toServer(arg, table.unpack(v2, 1, v2.n))
			end

			return toServer(arg, ...)
		end

		SignalFunction._kyokaHooked = true
	end
end)

local SignalEvent
SignalEvent = nil

pcall(function()
	SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent)
end)

local Clans
Clans = nil

pcall(function()
	Clans = require(ReplicatedStorage.CAM.Clans)
end)

local fn2

fn2 = function()
	local playerService = ReplicatedStorage:FindFirstChild("Player_Service")
	local data = playerService and playerService:FindFirstChild("Data")
	data = data and data:FindFirstChild(localPlayer.Name)
	if not data then
		return nil
	end
	local slotEquipped = data:FindFirstChild("slotEquipped")
	slotEquipped = slotEquipped and tostring(slotEquipped.Value) or "1"
	local slots = data:FindFirstChild("slots")
	if slots then
		return slots:FindFirstChild("Slot" .. slotEquipped) or slots:FindFirstChild(slotEquipped) or slots:GetChildren()[1]
	end
	return data
end

local fn3

fn3 = function()
	local clan = fn2()
	clan = clan and clan:FindFirstChild("Clan")
	return clan and clan.Value or "None"
end

local fn4

fn4 = function()
	local spinning = fn2()
	spinning = spinning and spinning:FindFirstChild("Spinning")
	if not spinning then
		return 0
	end
	return (spinning:FindFirstChild("FreeClanSpins") and spinning.FreeClanSpins.Value or 0) + (spinning:FindFirstChild("Spins") and spinning.Spins.Value or 0)
end

local fn5

fn5 = function()
	local powers = fn2()
	powers = powers and powers:FindFirstChild("Powers")
	powers = powers and powers:FindFirstChild("DemonArt")
	local value = powers and powers.Value
	return value and value ~= "" and tostring(value) or "None"
end

local fn6

fn6 = function()
	local ok, result = pcall(function()
		local SpinBalance = require(ReplicatedStorage.CAM.Global.SpinBalance)
		local v2 = require(ReplicatedStorage.CAM.Global.Utility).GetData(localPlayer, true)
		if v2 and SpinBalance and SpinBalance.Total then
			return SpinBalance.Total(v2, false)
		end
	end)

	if ok and typeof(result) == "number" then
		return result
	end
	local spinning = fn2()
	spinning = spinning and spinning:FindFirstChild("Spinning")
	return (spinning and spinning:FindFirstChild("FreeOtherSpins") and spinning.FreeOtherSpins.Value or 0) + (spinning and spinning:FindFirstChild("Spins") and spinning.Spins.Value or 0)
end

local fn7

fn7 = function()
	local playerService = ReplicatedStorage:FindFirstChild("Player_Service")
	playerService = playerService and playerService:FindFirstChild("Values")
	return playerService and playerService:FindFirstChild(localPlayer.Name)
end

local fn8

fn8 = function()
	local character = localPlayer.Character
	return character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso"))
end

local fn9

fn9 = function()
	local character = localPlayer.Character
	return character and character:FindFirstChildOfClass("Humanoid")
end

local InputHandler
InputHandler = nil

pcall(function()
	InputHandler = require(ReplicatedStorage.CAM.Client.Components.Client.InputHandler)
end)

local fn10

fn10 = function()
	local character = localPlayer.Character
	character = character and character:FindFirstChildOfClass("Humanoid")
	if not character or character.Health <= 0 then
		return false
	end
	local state = character:GetState()
	if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.GettingUp then
		return true
	end
	local v2 = nil

	pcall(function()
		v2 = game.ReplicatedStorage.Player_Service.Values:FindFirstChild(localPlayer.Name)
	end)

	if v2 then
		if v2:FindFirstChild("Stun") or v2:FindFirstChild("Strict_Stun") or v2:FindFirstChild("CombatStun") or v2:FindFirstChild("RagDoll") then
			return true
		end
	end

	return false
end

local fn11

fn11 = function()
	local character = localPlayer.Character
	if not character then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")

	pcall(function()
		local v2 = game.ReplicatedStorage.Player_Service.Values:FindFirstChild(localPlayer.Name)

		if v2 then
			for _, v3 in ipairs({
				"Stun",
				"Strict_Stun",
				"CombatStun",
				"RagDoll",
				"Ragdoll",
				"ragdoll",
				"ragDoll",
				"Blocking",
				"JumpingDisabled",
				"skill_stand_still",
				"skill_slow",
			}) do
				local v4 = v2:FindFirstChild(v3)

				if v4 then
					pcall(function()
						v4:Destroy()
					end)
				end
			end
		end
	end)

	pcall(function()
		if humanoidRootPart then
			for _, v2 in ipairs({ "skill_stand_still", "skill_slow", "air_combo_bp" }) do
				local v3 = humanoidRootPart:FindFirstChild(v2)

				if v3 then
					pcall(function()
						v3:Destroy()
					end)
				end
			end
		end
	end)

	pcall(function()
		if InputHandler and InputHandler.VirtualRelease then
			InputHandler.VirtualRelease("Block")
			InputHandler.VirtualRelease("Combat")
		end
	end)

	pcall(function()
		local ragdollConstraints = character:FindFirstChild("RagdollConstraints")

		if ragdollConstraints then
			for _, child in ipairs(ragdollConstraints:GetChildren()) do
				if child:IsA("Constraint") then
					child.Enabled = false

					if child:FindFirstChild("RigidJoint") and child.RigidJoint.Value then
						local value = child.RigidJoint.Value
						local attachment1 = child.Attachment1

						if attachment1 and attachment1.Parent and value.Part1 ~= attachment1.Parent then
							value.Part1 = attachment1.Parent
						end
					end
				end
			end
		end
	end)

	pcall(function()
		if animator then
			for _, v2 in ipairs(animator:GetPlayingAnimationTracks()) do
				if v2.Name ~= "idle" then
					pcall(function()
						v2:Stop(0)
						v2:Destroy()
					end)
				end
			end
		end
	end)

	pcall(function()
		if humanoid and humanoid.Health > 0 then
			humanoid:ChangeState(Enum.HumanoidStateType.Running)

			if humanoid.WalkSpeed < 10 then
				humanoid.WalkSpeed = 16
			end

			if humanoid.JumpPower == 0 then
				humanoid.JumpPower = 50
			end

			humanoid.PlatformStand = false
			humanoid.Sit = false
			humanoid.AutoRotate = true
		end
	end)
end

local fn12

do
	local n = 0
	local n2 = 1

	fn12 = function()
		if not slayersSyneroxHub or not slayersSyneroxHub.Farm or not slayersSyneroxHub.Farm.AutoSkills then
			return false
		end

		if fn10() then
			return false
		end
		local now = os.clock()
		if now - n < (slayersSyneroxHub.Farm.SkillInterval or 1) then
			return false
		end
		local flag = false

		pcall(function()
			local v2 = require(ReplicatedStorage.CAM.Client.Controllers.Skills_Provider).get_current_keys()
			if not v2 or #v2 == 0 then
				return
			end
			local tbl = {}

			for _, v3 in ipairs(v2) do
				if v3.Name and v3.Name ~= "Blocking" and v3.Key and not v3.RequiresModeBar then
					table.insert(tbl, v3)
				end
			end

			if #tbl == 0 then
				return
			end

			if #tbl < n2 then
				n2 = 1
			end

			local v3 = tbl[n2]
			n2 += 1
			if not v3 then
				return
			end
			local n3 = getthreadidentity and getthreadidentity() or 8
			local flag2 = false

			pcall(function()
				if setthreadidentity then
					setthreadidentity(2)
				end

				local Skill_Controller = require(ReplicatedStorage.CAM.Client.Controllers.Skill_Controller)
				flag2 = Skill_Controller.Attempt_Hold(v3.Name)

				if flag2 then
					task.delay(0.08, function()
						pcall(function()
							if setthreadidentity then
								setthreadidentity(2)
							end

							Skill_Controller.StopHold(v3.Name)

							if setthreadidentity then
								setthreadidentity(n3)
							end
						end)
					end)
				end
			end)

			if setthreadidentity then
				setthreadidentity(n3)
			end

			if flag2 then
				n = now
				flag = true
				return
			end

			pcall(function()
				local componentsHolder = localPlayer:FindFirstChild("PlayerGui") and localPlayer.PlayerGui:FindFirstChild("ComponentsHolder")
				componentsHolder = componentsHolder and componentsHolder:FindFirstChild("BottomHolder")
				componentsHolder = componentsHolder and componentsHolder:FindFirstChild("SkillsHolder")

				if componentsHolder then
					for _, child in ipairs(componentsHolder:GetChildren()) do
						local keyLabel = child:FindFirstChild("KeyLabel", true)

						if keyLabel and keyLabel.Text == v3.Key then
							local guiButton = child:FindFirstChildWhichIsA("GuiButton", true)

							if guiButton then
								firesignal(guiButton.MouseButton1Down)
								task.wait(0.04)
								firesignal(guiButton.MouseButton1Up)
								n = now
								flag = true
								return
							end
						end
					end
				end
			end)

			if flag then
				return
			end

			if v3.Key and VirtualInputManager then
				local v4 = Enum.KeyCode[v3.Key]

				if v4 then
					VirtualInputManager:SendKeyEvent(true, v4, false, game)
					task.wait(0.04)
					VirtualInputManager:SendKeyEvent(false, v4, false, game)
					n = now
					flag = true
				end
			end
		end)

		return flag
	end
end

local fn13

fn13 = function(arg)
	local character = localPlayer.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return
	end

	if fn10() then
		return
	end
	local animator = humanoid:FindFirstChildOfClass("Animator")

	if animator and slayersSyneroxHub.Combat.TrackGuard then
		pcall(function()
			local playingAnimationTracks = animator:GetPlayingAnimationTracks()

			for _, playingAnimationTrack in ipairs(playingAnimationTracks) do
				local name = playingAnimationTrack.Name

				if string.find(name, "Swing") or string.find(name, "Punch") or string.find(name, "Slash") or string.find(name, "React") then
					pcall(function()
						playingAnimationTrack:Stop(0)
						playingAnimationTrack:Destroy()
					end)
				end
			end
		end)
	end

	local n = arg or 1

	for i = 1, n do
		if InputHandler and InputHandler.VirtualPress and InputHandler.VirtualRelease then
			pcall(function()
				InputHandler.VirtualPress("Combat")
				task.wait(0.015)
				InputHandler.VirtualRelease("Combat")
			end)
		elseif mouse1click then
			mouse1click()
		elseif mouse1press and mouse1release then
			mouse1press()
			task.wait(0.02)
			mouse1release()
		elseif VirtualInputManager then
			VirtualInputManager:SendMouseButtonEvent(600, 400, 0, true, game, 0)
			task.wait(0.02)
			VirtualInputManager:SendMouseButtonEvent(600, 400, 0, false, game, 0)
		end

		if n > 1 and i < n then
			task.wait(0.04)
		end
	end
end

local fn14

fn14 = function()
	local tbl = {}
	local humanoids = Workspace:FindFirstChild("Humanoids")
	local regions = humanoids and humanoids:FindFirstChild("Regions")

	if regions then
		for _, child in ipairs(regions:GetChildren()) do
			local activeNpcs = child:FindFirstChild("ActiveNpcs")

			if activeNpcs then
				for _, child2 in ipairs(activeNpcs:GetChildren()) do
					for _, child3 in ipairs(child2:GetChildren()) do
						if child3:IsA("Model") and child3 ~= localPlayer.Character then
							local humanoid = child3:FindFirstChildOfClass("Humanoid")
							local humanoidRootPart = child3:FindFirstChild("HumanoidRootPart") or child3:FindFirstChild("Torso")

							if humanoid and humanoidRootPart and humanoid.Health > 0 and humanoidRootPart.Position.Y > -400 then
								table.insert(tbl, {
									Model = child3,
									Root = humanoidRootPart,
									Humanoid = humanoid,
									Name = child3.Name,
									Type = child2.Name,
									Region = child.Name,
								})
							end
						end
					end
				end
			end
		end
	end

	if #tbl == 0 and humanoids then
		for _, child in ipairs(humanoids:GetChildren()) do
			if child:IsA("Model") and child ~= localPlayer.Character and not Players:GetPlayerFromCharacter(child) then
				local humanoid = child:FindFirstChildOfClass("Humanoid")
				local humanoidRootPart = child:FindFirstChild("HumanoidRootPart") or child:FindFirstChild("Torso")

				if humanoid and humanoidRootPart and humanoid.Health > 0 and humanoidRootPart.Position.Y > -400 then
					table.insert(tbl, {
						Model = child,
						Root = humanoidRootPart,
						Humanoid = humanoid,
						Name = child.Name,
						Type = child.Name,
						Region = "Direct",
					})
				end
			end
		end
	end

	return tbl
end

local fn15

local tbl = {
	yetidemon = true,
	smallyeti = true,
	handdemon = true,
	zuko = true,
	saneri = true,
	obari = true,
	shinora = true,
	giyen = true,
	tengai = true,
	tengen = true,
	zentaro = true,
	gyorei = true,
	rengu = true,
	gyutai = true,
	datai = true,
	reaper = true,
	akazo = true,
	domae = true,
	nezura = true,
	yahari = true,
	sumari = true,
	enru = true,
	hoyuzo = true,
	kaiden = true,
	flametrainee = true,
	watertrainee = true,
	watertraineesabito = true,
	thundertrainee = true,
	windtrainee = true,
	soundtrainee = true,
	stonetrainee = true,
	serpenttrainee = true,
	insecttrainee = true,
	taichitrainee = true,
	taichitraineesuzume = true,
	soryutrainee = true,
	soryutraineegoki = true,
	reapertrainee = true,
	reapertraineekuzan = true,
}

fn15 = function(arg)
	local v2 = string.lower(arg.Name or "")
	local v3 = string.gsub(v2, "%s+", "")
	local v4 = string.lower(arg.Type or "")
	local v5 = string.gsub(v4, "%s+", "")
	return tbl[v2] or tbl[v3] or tbl[v4] or tbl[v5] or string.find(v2, "trainee") or string.find(v4, "trainee") or false
end

local fn16

fn16 = function(arg, arg2, arg3, arg4)
	if not arg then
		return false
	end

	if not arg.Model or not arg.Model.Parent then
		return false
	end
	local flag = not arg.Humanoid or not arg.Humanoid.Parent

	if not flag then
		flag = (arg.Humanoid.Health or 0) <= 0
	end

	if flag then
		return false
	end

	if not arg.Root or not arg.Root.Parent or arg.Root.Position.Y <= -400 then
		return false
	end
	local v2 = string.find(string.lower(arg.Type or ""), "civilian")

	if not v2 then
		v2 = string.find(string.lower(arg.Name or ""), "civilian")
	end

	local flag2 = type(arg2) == "string" and arg2 ~= "All" and (string.find(string.lower(arg2), "civilian") or string.find(string.lower(arg2), "civil"))
	if v2 and not flag2 then
		return false
	end
	local v3 = fn15(arg)
	if arg4 == "Boss" and not v3 then
		return false
	end

	if arg4 == "Normal" and v3 then
		return false
	end

	local function fn17(arg5)
		if not arg5 or arg5 == "All" or arg5 == "All Bosses" or arg5 == "All Normal Mobs" then
			return true
		end
		local v4 = string.lower(arg5)
		local v5 = string.gsub(v4, "%s+", "")
		local v6 = string.lower(arg.Type or "")
		local v7 = string.lower(arg.Name or "")
		local v8 = string.gsub(v6, "%s+", "")
		local v9 = string.gsub(v7, "%s+", "")
		if v8 == v5 or v9 == v5 or v6 == v4 or v7 == v4 then
			return true
		end
		local str = v5:gsub("_%a+", "")
		local str2 = v8:gsub("_%a+", "")
		local str3 = v9:gsub("_%a+", "")
		if str2 == str or str3 == str or v8 == str or v9 == str then
			return true
		end
		local flag3 = string.find(str, "greater") ~= nil
		local flag4 = string.find(str, "lesser") ~= nil
		local flag5 = (string.find(v8, "greater") or string.find(v9, "greater")) ~= nil
		local flag6 = (string.find(v8, "lesser") or string.find(v9, "lesser")) ~= nil
		if flag3 and flag6 then
			return false
		end

		if flag4 and flag5 then
			return false
		end

		if string.find(v5, "trainee") and (v6:find("trainee") or v7:find("trainee")) then
			local str4 = v5:gsub("trainee", "")
			if str4 == "" or v8:find(str4) or v9:find(str4) then
				return true
			end
		else
			if (v5:find("tengen") or v5:find("tengai")) and (v6:find("tengai") or v7:find("tengai")) then
				return true
			end

			if not string.find(v8, "subordinate") and not string.find(v9, "subordinate") then
				if string.find(v6, v4) or string.find(v7, v4) or string.find(v8, v5) or string.find(v9, v5) or string.find(v8, str) or string.find(v9, str) then
					return true
				end
			end
		end

		return false
	end

	local flag3

	if type(arg2) == "table" then
		if #arg2 == 0 then
			flag3 = true
		else
			flag3 = false

			for _, v4 in ipairs(arg2) do
				if fn17(v4) then
					flag3 = true
					break
				end
			end
		end
	else
		flag3 = fn17(arg2)
	end

	if not flag3 then
		return false
	end
	return true
end

local fn17

fn17 = function(arg, arg2, arg3)
	local v2 = fn8()
	if not v2 then
		return nil
	end
	local v3 = fn14()
	local huge = math.huge
	local v4 = nil

	for _, v5 in ipairs(v3) do
		if fn16(v5, arg, arg2, arg3) then
			if arg2 == "All" or v5.Region == arg2 then
				local magnitude = (v2.Position - v5.Root.Position).Magnitude

				if magnitude < huge then
					huge = magnitude
					v4 = v5
				end
			end
		end
	end

	return v4
end

local fn18

fn18 = function(arg, arg2)
	if not arg or #arg == 0 then
		return nil
	end
	local position = fn8()
	position = position and position.Position
	local v2 = fn14()
	local huge = math.huge
	local v3 = nil

	for _, v4 in ipairs(v2) do
		if fn16(v4, arg, arg2, "Boss") then
			if not arg2 or arg2 == "All" or v4.Region == arg2 then
				local magnitude = position and (position - v4.Root.Position).Magnitude or 0

				if magnitude < huge then
					huge = magnitude
					v3 = v4
				end
			end
		end
	end

	return v3
end

local fn19, fn20

local function fn21()
	local tbl2 = {}
	local position = fn8()
	position = position and position.Position
	local position2

	if position then
		position2 = position
	else
		position2 = localPlayer.Character and localPlayer.Character:GetPivot().Position
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			local character = player.Character
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
			local pivot = character:GetPivot()
			local position3 = humanoidRootPart and humanoidRootPart.Position or pivot and pivot.Position
			local cFrame = humanoidRootPart and humanoidRootPart.CFrame or pivot
			local health = humanoid and humanoid.Health or 100

			if position3 and health > 0 and position3.Y > 0 and position3.Y < 2500 and math.abs(position3.X) < 3500 and math.abs(position3.Z) < 3500 then
				table.insert(tbl2, {
					Player = player,
					Model = character,
					Root = humanoidRootPart,
					Position = position3,
					CFrame = cFrame,
					Humanoid = humanoid,
					Health = health,
					Name = player.Name,
					DisplayName = player.DisplayName,
					Type = "Player",
					Region = "World",
					HasRoot = humanoidRootPart ~= nil,
				})
			end
		end
	end

	table.sort(tbl2, function(arg, arg2)
		if arg.HasRoot ~= arg2.HasRoot then
			return arg.HasRoot
		end

		if position2 and arg.Position and arg2.Position then
			return (position2 - arg.Position).Magnitude < (position2 - arg2.Position).Magnitude
		end
		return false
	end)

	return tbl2
end

fn19 = function(arg, arg2)
	if not arg then
		return false
	end

	if not arg.Player or not arg.Player.Parent then
		return false
	end

	if not arg.Model or not arg.Model.Parent then
		return false
	end
	local humanoidRootPart = arg.Model:FindFirstChild("HumanoidRootPart") or arg.Model:FindFirstChild("Torso")

	if humanoidRootPart then
		arg.Root = humanoidRootPart
		arg.Position = humanoidRootPart.Position
		arg.CFrame = humanoidRootPart.CFrame
		arg.HasRoot = true
	else
		local pivot = arg.Model:GetPivot()

		if pivot then
			arg.Position = pivot.Position
			arg.CFrame = pivot
		end
	end

	local humanoid = arg.Model:FindFirstChildOfClass("Humanoid")

	if humanoid then
		arg.Humanoid = humanoid
		arg.Health = humanoid.Health
		if humanoid.Health <= 0 then
			return false
		end
	end

	if not arg.Position then
		return false
	end

	if arg.Position.Y <= 0 or arg.Position.Y >= 2500 or math.abs(arg.Position.X) >= 3500 or math.abs(arg.Position.Z) >= 3500 then
		return false
	end

	if arg2 and arg2 ~= "All Players" then
		local v2 = string.lower(arg2)
		local v3 = string.lower(arg.Name or "")
		local v4 = string.lower(arg.DisplayName or "")
		if v3 ~= v2 and v4 ~= v2 and not v2:find(v3, 1, true) then
			return false
		end
	end

	return true
end

fn20 = function(arg)
	local position = fn8()
	position = position and position.Position
	local position2

	if position then
		position2 = position
	else
		position2 = localPlayer.Character and localPlayer.Character:GetPivot().Position
	end

	if not position2 then
		return nil
	end
	local v2 = fn21()
	arg = arg and string.lower(arg)
	local huge = math.huge
	local v3 = nil

	for _, v4 in ipairs(v2) do
		if arg and arg ~= "all players" then
			local v5 = string.lower(v4.Name or "")
			local v6 = string.lower(v4.DisplayName or "")

			if not (v5 ~= arg and v6 ~= arg and not arg:find(v5, 1, true)) then
				local magnitude = (position2 - v4.Position).Magnitude

				if magnitude < huge then
					huge = magnitude
					v3 = v4
				end
			end
		else
			local magnitude = (position2 - v4.Position).Magnitude

			if magnitude < huge then
				huge = magnitude
				v3 = v4
			end
		end
	end

	return v3
end

slayersSyneroxHub = {
	Alive = true,
	Connections = {},
	ESPHighlights = {},
	CurrentTarget = nil,
	LockedTarget = nil,
	FarmPlatform = nil,
	IsInteractingQuest = false,
	IsCollectingLoot = false,
	Farm = {
		AutoFarm = false,
		TargetLock = true,
		MobCategory = "Normal",
		NormalMob = "All Normal Mobs",
		BossMob = "All Bosses",
		SelectedBosses = {},
		BossRotationInterval = 15,
		TargetMob = "All",
		RegionFilter = "All",
		AutoTravelToRegion = true,
		Distance = 2,
		AutoM1 = true,
		PlayerFarm = false,
		PlayerTargetMode = "Closest Player",
		SelectedPlayer = "All Players",
		PlayerSafeMode = "Overhead",
		PlayerHeightOffset = 3,
		PlayerDistance = 2.5,
		SafeMode = "Overhead",
		HeightOffset = 2.5,
		MultiHit = true,
		MultiHitCount = 3,
		AutoSkills = true,
		SkillInterval = 1,
		AutoCollectChests = true,
		AutoCollectLoot = true,
		AutoCollectSouls = true,
		BossLootWaitTime = 4,
		MobLootWaitTime = 1.8,
		AutoQuest = false,
		QuestMode = "Auto Best Quest (By Level)",
		ActiveQuestName = nil,
		ActiveQuestTarget = nil,
	},
	Training = {
		AutoTraining = false,
		AutoMinigames = false,
		AutoBoulder = false,
		AutoSquats = false,
		AutoPushups = false,
		AutoMeditation = false,
		AutoGourd = false,
		SelectedGourd = "Small Gourd (700 Wen)",
	},
	Activities = {
		AutoFish = false,
		AutoBuyBait = false,
		AutoBuyExp = false,
		CollectSchematics = false,
		FishingSpot = "Mistfall Harbor",
		AutoBecomeDemon = false,
		AutoFarmEvilKarma = false,
	},
	Webhook = {
		Url = "",
		Enabled = false,
		ClanRerollNotify = true,
		RerollMinRarity = "Rare+",
		MuzanNotify = true,
		BlackMarketNotify = true,
		TailorNotify = true,
		FinalSelectionNotify = true,
		BossHuntsNotify = true,
		BossSpawnNotify = true,
		PingUser = false,
		DiscordUserId = "",
	},
	Notifiers = {
		Muzan = true,
		BlackMarketer = true,
		TailorRestocks = true,
		FinalSelection = true,
		BossHunts = true,
		BossSpawns = true,
	},
	Equipment = { AutoEquipBest = false, PrioritizeDamage = true },
	Dungeon = {
		AutoUnlock = false,
		AutoQueue = false,
		AutoReadyUp = false,
		MinLevel = 50,
		OuwigaharaUnlockedAlready = false,
		AutoFarm = false,
		AttackMode = "Overhead (Safe)",
		HeightOffset = 6.5,
		MultiHit = true,
		MultiHitCount = 3,
		AutoSkills = true,
		AutoPickCards = true,
		AutoCollectChests = true,
		TargetPriority = "Closest",
	},
	SkillTree = { AutoAllocate = false, Priority = "Balanced" },
	Shop = {
		SelectedWeapon = "Common Katana (500 Wen)",
		SelectedGourd = "Small Gourd (700 Wen)",
		SelectedConsumable = "Bandage (50 Wen)",
		AutoEquip = true,
	},
	Combat = {
		InfStamina = true,
		NoSunDamage = false,
		NoColdDamage = false,
		FastAttack = false,
		AntiFreeze = true,
		TrackGuard = true,
		AutoParry = false,
		ParryRange = 16,
		ParryMode = "All Enemies",
		ParryDuration = 0.18,
		ParryCooldown = 0.22,
		LastParry = 0,
		IsParrying = false,
		AutoCounter = true,
	},
	Visuals = {
		PlayerESP = false,
		MobESP = true,
		ESPBoxes = true,
		PlayerColor = Color3.fromRGB(124, 108, 255),
		MobColor = Color3.fromRGB(255, 65, 65),
	},
	Spin = {
		AutoSpin = false,
		Mode = "Rarity",
		StopRarity = "Mythic+",
		TargetClan = "Kamado",
		Delay = 0.15,
		IsSpinning = false,
		LastResult = "None",
		BDA = {
			AutoSpin = false,
			Mode = "Rarity",
			StopRarity = "Legendary+",
			TargetBDA = "Shockwave",
			Delay = 0.15,
			LastResult = "None",
		},
	},
	Misc = { CustomSpeed = false, WalkSpeed = 35, NoClip = false, InfiniteJump = false },
}

_G.SlayersSyneroxHub = slayersSyneroxHub
_G.SlayersKyokaHub = slayersSyneroxHub
local fn22

fn22 = function(arg)
	local v2 = fn8()
	if not v2 then
		return
	end

	if not slayersSyneroxHub.FarmPlatform or not slayersSyneroxHub.FarmPlatform.Parent then
		local part = Instance.new("Part")
		part.Name = "SyneroxFarmPlatform"
		part.Size = Vector3.new(16, 1.2, 16)
		part.Transparency = 1
		part.Anchored = true
		part.CanCollide = true
		part.Parent = Workspace
		slayersSyneroxHub.FarmPlatform = part
	end

	local position = typeof(arg) == "CFrame" and arg.Position

	if position then
		arg = position
	else
		arg = typeof(arg) == "Vector3" and arg
	end

	arg = arg or v2.Position
	slayersSyneroxHub.FarmPlatform.Size = Vector3.new(16, 1.2, 16)
	slayersSyneroxHub.FarmPlatform.CanCollide = true
	slayersSyneroxHub.FarmPlatform.CFrame = CFrame.new(arg.X, arg.Y - 3.2, arg.Z)
end

local fn23

fn23 = function()
	if slayersSyneroxHub.FarmPlatform then
		pcall(function()
			slayersSyneroxHub.FarmPlatform:Destroy()
		end)

		slayersSyneroxHub.FarmPlatform = nil
	end
end

local tbl2

tbl2 = {
	["Hidden Mist Village"] = Vector3.new(1651, 607.3, -124),
	["Mistfall Harbor"] = Vector3.new(140.7, 873.5, 728.2),
	["Bamboo Grove"] = Vector3.new(570, 1140, -1150),
	["Windy Peak"] = Vector3.new(-456, 1241, -932),
	["Butterfly Estate"] = Vector3.new(-1772, 311.3, -110.9),
	["Iceveil Valley"] = Vector3.new(283.9, 1305, -2041.2),
	["Final Selection Plains"] = Vector3.new(-1834, 35, 487.5),
	Misc = Vector3.new(-315.6, 1292.6, -1488.7),
	Temporary = Vector3.new(807, 1122, -1005),
}

local n
n = 1
local n2
n2 = 0
local tbl3

tbl3 = {
	["Kanoe Demon Slayer"] = Vector3.new(283.9, 1305, -2041.2),
	["Mizunoe Demon Slayer"] = Vector3.new(-1834, 35, 487.5),
	Mizunoto = Vector3.new(-784.5, 966.5, -133.8),
	Civilian = Vector3.new(-567.4, 1246, -1024.5),
	["*Civilian*"] = Vector3.new(-703.9, 1246, -946.1),
	Bandit = Vector3.new(570, 1140, -1150),
	KaruVillageBandit = Vector3.new(-456, 1241, -932),
	Spy = Vector3.new(-456, 1241, -932),
	VillageSpy = Vector3.new(-456, 1241, -932),
	["Bear Cub"] = Vector3.new(520, 1122, -1045),
	["Mother Bear"] = Vector3.new(507.2, 1124, -970.3),
	Kaiden = Vector3.new(634, 1131.5, -1167),
	["Kaiden Subordinate"] = Vector3.new(590, 1148, -1300),
	Hoyuzo = Vector3.new(546.9, 1003.9, -1166.8),
	["Hoyuzo Subordinate"] = Vector3.new(546.9, 1003.9, -1166.8),
	["Grove Raider"] = Vector3.new(570, 1140, -1150),
	["Raid Captain"] = Vector3.new(570, 1140, -1150),
	["Cache Prowler"] = Vector3.new(570, 1140, -1150),
	["Prowler Captain"] = Vector3.new(570, 1140, -1150),
	["Cache Lancer"] = Vector3.new(570, 1140, -1150),
	["Lancer Captain"] = Vector3.new(570, 1140, -1150),
	IceveilRoadBandit = Vector3.new(142.1, 1385.1, -2783.2),
	IceveilRoadMarauder = Vector3.new(142.1, 1385.1, -2783.2),
	IceveilRoadPikeman = Vector3.new(142.1, 1385.1, -2783.2),
	["High Demon"] = Vector3.new(283.9, 1302, -2041.2),
	["Fire Profound Demon"] = Vector3.new(142.1, 1385.1, -2783.2),
	["Ice Profound Demon"] = Vector3.new(142.1, 1385.1, -2783.2),
	GreaterDemon_ButterflyEstate = Vector3.new(-498.9, 284.8, 528.8),
	LesserDemon_ButterflyEstate = Vector3.new(-675.7, 230.5, 397.1),
	["Greater Demon"] = Vector3.new(-498.9, 284.8, 528.8),
	["Lesser Demon"] = Vector3.new(-675.7, 230.5, 397.1),
	BloodHoundedDemon_MistfallHarbor = Vector3.new(140.7, 873.5, 728.2),
	["Beast Born Demon"] = Vector3.new(140.7, 873.5, 728.2),
	YetiDemon = Vector3.new(142.1, 1385.1, -2783.2),
	SmallYeti = Vector3.new(142.1, 1385.1, -2783.2),
	HandDemon = Vector3.new(-1834, 35, 487.5),
	["Flame Trainee"] = Vector3.new(-1128.9, 1029, 994.4),
	["Water Trainee"] = Vector3.new(815.3, 1018.8, 101.6),
	["Water Trainee Sabito"] = Vector3.new(815.3, 1018.8, 101.6),
	["Thunder Trainee"] = Vector3.new(2425.5, 1073.6, -556.8),
	["Wind Trainee"] = Vector3.new(-941.6, 1381, -2635.6),
	["Sound Trainee"] = Vector3.new(192.5, 1349, -2581.3),
	["Stone Trainee"] = Vector3.new(2685.2, 1073.6, -568.8),
	["Serpent Trainee"] = Vector3.new(-271.4, 1292, -1535.7),
	["Insect Trainee"] = Vector3.new(-1395.6, 261.5, 69.2),
	["Tai Chi Trainee"] = Vector3.new(2360.5, 602, -642.3),
	["Tai Chi Trainee Suzume"] = Vector3.new(2360.5, 602, -642.3),
	["Soryu Trainee"] = Vector3.new(-427, 288.8, 543.3),
	["Soryu Trainee Goki"] = Vector3.new(-427, 288.8, 543.3),
	["Reaper Trainee"] = Vector3.new(-1219.3, 1373.6, -3034.4),
	["Reaper Trainee Kuzan"] = Vector3.new(-1219.3, 1373.6, -3034.4),
	Tengai = Vector3.new(-133.5, 1349, -2631.3),
	Tengen = Vector3.new(-133.5, 1349, -2631.3),
	["Tengai (Tengen)"] = Vector3.new(-133.5, 1349, -2631.3),
	Zentaro = Vector3.new(1332.1, 821.5, -1017.6),
	Reaper = Vector3.new(98.5, 1043, -573.9),
	Akazo = Vector3.new(-1132, 1380.9, -1746.6),
	Shinora = Vector3.new(-452.6, 964.5, 2.1),
	Yahari = Vector3.new(825.7, 1019.2, -641.3),
	Domae = Vector3.new(-296.5, 1350.5, -3451.3),
	Obari = Vector3.new(770.5, 1121, -1047),
	Saneri = Vector3.new(-379.1, 1093.5, -422.4),
	Enru = Vector3.new(821.8, 800, 543.9),
	Sumari = Vector3.new(396.4, 1018, -620.4),
	Rengu = Vector3.new(-712.9, 965, 883.8),
	Gyorei = Vector3.new(2574.6, 1089, -742.4),
	Datai = Vector3.new(-165.5, 1043, -1137.5),
	Nezura = Vector3.new(-1459.5, 276, 935.5),
	Giyen = Vector3.new(388.9, 1018, -85.1),
	Gyutai = Vector3.new(-266.1, 1043.2, -1139.7),
}

local fn24

fn24 = function(arg, arrivedAt)
	local v2 = fn8()
	if not v2 then
		return
	end
	v2.AssemblyLinearVelocity = Vector3.zero
	v2.AssemblyAngularVelocity = Vector3.zero
	v2.CFrame = CFrame.new(arg + Vector3.new(0, 3, 0))
	fn22(v2.CFrame)

	if arrivedAt then
		fn({ Title = "Teleport", Content = "Arrived at: " .. arrivedAt, Type = "success", Duration = 3 })
	end
end

local tbl4

tbl4 = {
	{
		Name = "Ill take 3 bandits",
		DisplayName = "Bandits (Lv 0+)",
		QuestInstanceName = "Defeat 3 bandits",
		MinLevel = 0,
		Category = "Normal",
		Region = "Windy Peak",
		Race = "Any",
		NPC = "Krue",
		MobName = "Bandit",
		MobWp = Vector3.new(-297, 1224, -1023),
		Tasks = { ["Bandits remaining"] = "Bandit" },
	},
	{
		Name = "Ill take the bandit boss(Lv 7)",
		DisplayName = "Zuko (Boss Lv 7+)",
		QuestInstanceName = "Defeat The Bandit Boss",
		MinLevel = 7,
		Category = "Boss",
		Region = "Windy Peak",
		Race = "Any",
		NPC = "Krue",
		MobName = "Zuko",
		MobWp = Vector3.new(-297, 1224, -1023),
		Tasks = { ["Defeat Zuko"] = "Zuko" },
	},
	{
		Name = "Ill drive the bears back(Lv 10)",
		DisplayName = "Bear Cubs (Lv 10+)",
		QuestInstanceName = "Hunt the Bears",
		MinLevel = 10,
		Category = "Normal",
		Region = "Bamboo Grove",
		Race = "Any",
		NPC = "Tom",
		MobName = "Bear Cub",
		MobWp = Vector3.new(540, 1121, -1024),
		Tasks = { ["Bear Cubs hunted"] = "Bear Cub" },
	},
	{
		Name = "Ill fell the Mother Bear(Lv 18)",
		DisplayName = "Mother Bear (Lv 18+)",
		QuestInstanceName = "Fell the Mother Bear",
		MinLevel = 18,
		Category = "Normal",
		Region = "Bamboo Grove",
		Race = "Any",
		NPC = "Tom",
		MobName = "Mother Bear",
		MobWp = Vector3.new(540, 1121, -1024),
		Tasks = { ["Fell the Mother Bear"] = "Mother Bear" },
	},
	{
		Name = "Ill clear out his subordinates(Lv 26)",
		DisplayName = "Kaiden Subordinates (Lv 26+)",
		QuestInstanceName = "Clear Kaiden's Subordinates",
		MinLevel = 26,
		Category = "Normal",
		Region = "Bamboo Grove",
		Race = "Any",
		NPC = "Chaka",
		MobName = "Kaiden Subordinate",
		MobWp = Vector3.new(585, 1146, -1315),
		Tasks = { ["Subordinates defeated"] = "Kaiden Subordinate" },
	},
	{
		Name = "Ill deal with Kaiden(Lv 34)",
		DisplayName = "Kaiden (Boss Lv 34+)",
		QuestInstanceName = "Defeat Kaiden",
		MinLevel = 34,
		Category = "Boss",
		Region = "Bamboo Grove",
		Race = "Any",
		NPC = "Chaka",
		MobName = "Kaiden",
		MobWp = Vector3.new(585, 1146, -1315),
		Tasks = { ["Defeat Kaiden"] = "Kaiden" },
	},
	{
		Name = "I will clear out his guards(Lv 40)",
		DisplayName = "Hoyuzo Guards (Lv 40+)",
		QuestInstanceName = "Clear Hoyuzo's Guard",
		MinLevel = 40,
		Category = "Normal",
		Region = "Bamboo Grove",
		Race = "Any",
		NPC = "Wagwan",
		MobName = "Hoyuzo Subordinate",
		MobWp = Vector3.new(533, 1001, -1357),
		Tasks = { ["Guards defeated"] = "Hoyuzo Subordinate" },
	},
	{
		Name = "Ill drive them off(Lv 47)",
		DisplayName = "Beast Born Demons (Lv 47+)",
		QuestInstanceName = "Hold the Night",
		MinLevel = 47,
		Category = "Normal",
		Region = "Mistfall Harbor",
		Race = "Any",
		NPC = "Rin",
		MobName = "Beast Born Demon",
		MobWp = Vector3.new(170, 888, 603),
		Tasks = { ["Beast Born Demons defeated"] = "Beast Born Demon" },
	},
	{
		Name = "I will take care of Hoyuzo(Lv 50)",
		DisplayName = "Hoyuzo (Boss Lv 50+)",
		QuestInstanceName = "Defeat Hoyuzo",
		MinLevel = 50,
		Category = "Boss",
		Region = "Bamboo Grove",
		Race = "Any",
		NPC = "Wagwan",
		MobName = "Hoyuzo",
		MobWp = Vector3.new(746, 1001, -1413),
		Tasks = { ["Defeat Hoyuzo"] = "Hoyuzo" },
	},
	{
		Name = "Ill clear the cave(Lv 62)",
		DisplayName = "Blood Hounded Demons (Lv 62+)",
		QuestInstanceName = "Purge Dreamfall Hollow",
		MinLevel = 62,
		Category = "Normal",
		Region = "Mistfall Harbor",
		Race = { "Slayer", "Hybrid" },
		NPC = "Jugg",
		MobName = "Blood Hounded Demon",
		MobWp = Vector3.new(789, 829, 927),
		Tasks = { ["Blood Hounded Demons defeated"] = "Blood Hounded Demon" },
	},
	{
		Name = "Ill eliminate the Mizunoto(Lv 62)",
		DisplayName = "Mizunoto Slayers (Lv 62+)",
		QuestInstanceName = "Eliminate the Mizunoto",
		MinLevel = 62,
		Category = "Normal",
		Region = "Mistfall Harbor",
		Race = { "Demon", "Hybrid" },
		NPC = "Shady Individual Rooyi",
		MobName = "Mizunoto",
		MobWp = Vector3.new(-834, 964, -76),
		Tasks = { ["Broken Nichirin Katanas"] = "Mizunoto" },
	},
	{
		Name = "Ill thin them out(Lv 75)",
		DisplayName = "Lesser Demons (Lv 75+)",
		QuestInstanceName = "Thin the Cavern Floor",
		MinLevel = 75,
		Category = "Normal",
		Region = "Butterfly Estate",
		Race = { "Slayer", "Hybrid" },
		NPC = "Demon Slayer Goro",
		MobName = "Lesser Demon",
		MobWp = Vector3.new(-675, 230, 397),
		Tasks = { ["Lesser Demons defeated"] = "Lesser Demon" },
	},
	{
		Name = "Ill break their watch(Lv 75)",
		DisplayName = "Mizunoe Slayers (Lv 75+)",
		QuestInstanceName = "Break Their Watch",
		MinLevel = 75,
		Category = "Normal",
		Region = "Final Selection Plains",
		Race = { "Demon", "Hybrid" },
		NPC = "Demon Mokuro",
		MobName = "Mizunoe Demon Slayer",
		MobWp = Vector3.new(-1835, 31, 487),
		Tasks = { ["Mizunoe Demon Slayers defeated"] = "Mizunoe Demon Slayer" },
	},
	{
		Name = "Ill go up after the greater ones(Lv 83)",
		DisplayName = "Greater Demons (Lv 83+)",
		QuestInstanceName = "Hunt the Greater Demons",
		MinLevel = 83,
		Category = "Normal",
		Region = "Butterfly Estate",
		Race = { "Slayer", "Hybrid" },
		NPC = "Demon Slayer Goro",
		MobName = "Greater Demon",
		MobWp = Vector3.new(-498, 284, 528),
		Tasks = { ["Greater Demons defeated"] = "Greater Demon" },
	},
	{
		Name = "Ill help you defeat them(Lv 90)",
		DisplayName = "High Demons (Lv 90+)",
		QuestInstanceName = "Drive Off the High Demons",
		MinLevel = 90,
		Category = "Normal",
		Region = "Iceveil Valley",
		Race = { "Slayer", "Hybrid" },
		NPC = "Wounded Slayer Tomoi",
		MobName = "High Demon",
		MobWp = Vector3.new(388, 1253, -1928),
		Tasks = { ["High Demons defeated"] = "High Demon" },
	},
	{
		Name = "Theyre not welcome here(Lv 90)",
		DisplayName = "Kanoe Slayers (Lv 90+)",
		QuestInstanceName = "They're Not Welcome Here",
		MinLevel = 90,
		Category = "Normal",
		Region = "Iceveil Valley",
		Race = { "Demon", "Hybrid" },
		NPC = "Demon Delroy",
		MobName = "Kanoe Demon Slayer",
		MobWp = Vector3.new(283, 1302, -2042),
		Tasks = { ["Kanoe Demon Slayers defeated"] = "Kanoe Demon Slayer" },
	},
	{
		Name = "Ill drive back the frost(Lv 105)",
		DisplayName = "Ice Profound Demons (Lv 105+)",
		QuestInstanceName = "Drive Back the Frost",
		MinLevel = 105,
		Category = "Normal",
		Region = "Iceveil Valley",
		Race = "Any",
		NPC = "Demon Slayer Mitsu",
		MobName = "Ice Profound Demon",
		MobWp = Vector3.new(-920, 1381, -2448),
		Tasks = { ["Ice Profound Demons defeated"] = "Ice Profound Demon" },
	},
	{
		Name = "Ill put out the blaze(Lv 115)",
		DisplayName = "Fire Profound Demons (Lv 115+)",
		QuestInstanceName = "Put Out the Blaze",
		MinLevel = 115,
		Category = "Normal",
		Region = "Iceveil Valley",
		Race = "Any",
		NPC = "Demon Slayer Mitsu",
		MobName = "Fire Profound Demon",
		MobWp = Vector3.new(-916, 1374, -2431),
		Tasks = { ["Fire Profound Demons defeated"] = "Fire Profound Demon" },
	},
}

local fn25

fn25 = function()
	local str = "Slayer"

	pcall(function()
		local v2, v3 = require(ReplicatedStorage.CAM.Global.Utility).GetData(localPlayer, true)

		if v2 and v2:FindFirstChild("Race") and v2.Race.Value ~= "" then
			str = v2.Race.Value
		elseif v3 and v3:FindFirstChild("Race") and v3.Race.Value ~= "" then
			str = v3.Race.Value
		end
	end)

	return str
end

local fn26

fn26 = function()
	local ok, result = pcall(function()
		local Utility = require(ReplicatedStorage.CAM.Global.Utility)
		local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings)
		local exp, v2 = Utility.GetData(localPlayer, true)
		exp = exp and exp:FindFirstChild("Exp") or v2 and v2:FindFirstChild("Exp")
		if exp and exp:FindFirstChild("Goal") then
			return math.floor(exp.Goal.Value / (gameSettings and gameSettings.expPerLevel or 60))
		end
	end)

	if ok and type(result) == "number" and result > 0 then
		return result
	end
	return 1
end

local fn27, fn28, n3, fn29, fn30

do
	local function fn31(arg)
		if not arg then
			return nil, nil
		end
		local debree = Workspace:FindFirstChild("Debree")
		local regions = debree and debree:FindFirstChild("Regions")

		if regions then
			for _, child in ipairs(regions:GetChildren()) do
				local stationaryNpcs = child:FindFirstChild("StationaryNpcs")
				local activeNpcs = child:FindFirstChild("ActiveNpcs")
				stationaryNpcs = stationaryNpcs and stationaryNpcs:FindFirstChild(arg) or activeNpcs and activeNpcs:FindFirstChild(arg)

				if stationaryNpcs then
					local humanoidRootPart = stationaryNpcs:FindFirstChild("HumanoidRootPart") or stationaryNpcs:FindFirstChild("Torso") or stationaryNpcs.PrimaryPart
					if humanoidRootPart then
						return humanoidRootPart.Position, stationaryNpcs
					end
				end
			end
		end

		local humanoids = Workspace:FindFirstChild("Humanoids")
		humanoids = humanoids and humanoids:FindFirstChild("Regions")

		if humanoids then
			for _, child in ipairs(humanoids:GetChildren()) do
				local stationaryNpcs = child:FindFirstChild("StationaryNpcs")
				local activeNpcs = child:FindFirstChild("ActiveNpcs")
				stationaryNpcs = stationaryNpcs and stationaryNpcs:FindFirstChild(arg) or activeNpcs and activeNpcs:FindFirstChild(arg)

				if stationaryNpcs then
					local humanoidRootPart = stationaryNpcs:FindFirstChild("HumanoidRootPart") or stationaryNpcs:FindFirstChild("Torso") or stationaryNpcs.PrimaryPart
					if humanoidRootPart then
						return humanoidRootPart.Position, stationaryNpcs
					end
				end
			end
		end

		local ok, result = pcall(function()
			local Regions = require(ReplicatedStorage.Regions)
			if Regions.GetNpcSpawn then
				return Regions.GetNpcSpawn(arg)
			end
		end)

		if ok and typeof(result) == "Vector3" then
			return result, nil
		end

		return ({
			Krue = Vector3.new(-425.5, 1243.5, -952.5),
			Tom = Vector3.new(540, 1121, -1024),
			Chaka = Vector3.new(585, 1146, -1315),
			Wagwan = Vector3.new(723.8, 1019.2, -802),
			Rin = Vector3.new(170, 888, 603),
			Jugg = Vector3.new(487.7, 874.1, 1007.8),
			["Shady Individual Rooyi"] = Vector3.new(-834, 964, -76),
			["Demon Slayer Goro"] = Vector3.new(-872, 234.8, 318.5),
			["Demon Mokuro"] = Vector3.new(-1835, 31, 487),
			["Wounded Slayer Tomoi"] = Vector3.new(485.3, 1222.6, -1813),
			["Demon Delroy"] = Vector3.new(283, 1302, -2042),
			["Demon Slayer Mitsu"] = Vector3.new(-824.3, 1381.5, -2537.8),
		})[arg], nil
	end

	fn27 = function()
		local ok, result = pcall(function()
			local quests, v2 = require(ReplicatedStorage.CAM.Global.Utility).GetData(localPlayer, true)
			quests = quests and quests:FindFirstChild("Quests") or v2 and v2:FindFirstChild("Quests")
			quests = quests and quests:FindFirstChild("Holder")
			if not quests then
				return nil
			end
			local v3 = nil

			for _, child in ipairs(quests:GetChildren()) do
				local name = child:FindFirstChild("QuestString") and child.QuestString.Value or child.Name
				local tbl5 = {}
				local flag = true
				local flag2 = false

				if child:FindFirstChild("Tasks") then
					for _, child2 in ipairs(child.Tasks:GetChildren()) do
						local n4 = child2:FindFirstChild("Value") and child2.Value.Value or 0
						local n5 = child2:FindFirstChild("Max") and child2.Max.Value or 1
						tbl5[child2.Name] = { Current = n4, Max = n5 }
						flag2 = true

						if n4 < n5 then
							flag = false
						end
					end
				end

				local tbl6 = {
					Name = child.Name,
					QuestString = name,
					Tasks = tbl5,
					Finished = flag2 and flag,
					IsFinished = flag2 and flag,
					HasTasks = flag2,
					Instance = child,
				}

				if flag2 and not flag then
					return tbl6
				end

				if flag2 then
					v3 = tbl6
				else
					v3 = v3 or tbl6
				end
			end

			return v3
		end)

		return ok and result or nil
	end

	fn28 = function()
		local v2 = fn27()
		local flag = false

		if v2 then
			pcall(function()
				local SignalEvent2 = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent)
				SignalEvent2.ToServer("RemoveQuest", v2.Name)

				if v2.QuestString and v2.QuestString ~= v2.Name then
					SignalEvent2.ToServer("RemoveQuest", v2.QuestString)
				end
			end)

			pcall(function()
				require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests).DeleteQuest(localPlayer, v2.Instance or v2.Name)
			end)

			flag = true
		end

		pcall(function()
			local v3 = require(ReplicatedStorage.CAM.Global.Utility).GetData(localPlayer, true)
			local holder = v3 and v3:FindFirstChild("Quests") and v3.Quests:FindFirstChild("Holder")

			if holder then
				for _, child in ipairs(holder:GetChildren()) do
					if not child:FindFirstChild("Tasks") or #child.Tasks:GetChildren() == 0 then
						pcall(function()
							child:Destroy()
						end)
					end
				end
			end
		end)

		return flag
	end

	local function fn32(arg)
		if not arg then
			return false
		end
		local v2 = fn25()

		if arg.Race and arg.Race ~= "Any" then
			if type(arg.Race) == "table" then
				local flag = false

				for _, v3 in ipairs(arg.Race) do
					if v3 == v2 then
						flag = true
						break
					end
				end

				if not flag then
					return false
				end
			elseif type(arg.Race) == "string" and arg.Race ~= v2 then
				return false
			end
		end

		return true
	end

	n3 = 0

	fn29 = function(arg)
		if slayersSyneroxHub.IsInteractingQuest then
			return false, "Already interacting"
		end
		local v2 = nil

		for _, v3 in ipairs(tbl4) do
			if v3.Name == arg or v3.DisplayName == arg then
				v2 = v3
				break
			end
		end

		if not v2 then
			return false, "Quest not in database"
		end
		local v3 = fn27()
		local flag

		if v3 then
			flag = v3.QuestString == v2.Name or v3.Name == v2.QuestInstanceName or v3.Name == v2.Name
		else
			flag = v3
		end

		if flag then
			if not v3.IsFinished then
				return true, "Already active"
			end
		end

		local v4, v5 = fn31(v2.NPC)
		if not v4 then
			return false, "NPC position not found"
		end
		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return false, "Character not ready"
		end
		slayersSyneroxHub.IsInteractingQuest = true
		fn23()
		humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
		humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
		humanoidRootPart.CFrame = CFrame.new(v4 + Vector3.new(0, 2, 3), v4)
		fn22(humanoidRootPart.CFrame)

		pcall(function()
			require(ReplicatedStorage.CAM.Global.Subsets.Areas.AreaLocator):Update(humanoidRootPart)
		end)

		task.wait(0.35)
		local proximityPrompt = nil

		if v5 then
			proximityPrompt = v5:FindFirstChildWhichIsA("ProximityPrompt", true)
		end

		if not proximityPrompt then
			local v6, v7 = fn31(v2.NPC)

			if v7 then
				proximityPrompt = v7:FindFirstChildWhichIsA("ProximityPrompt", true)
			end
		end

		if proximityPrompt then
			pcall(function()
				fireproximityprompt(proximityPrompt)
			end)

			task.wait(0.3)
		end

		local playerGui = localPlayer:FindFirstChild("PlayerGui")

		local function fn33()
			local componentsHolder = playerGui and playerGui:FindFirstChild("ComponentsHolder")
			componentsHolder = componentsHolder and componentsHolder:FindFirstChild("DialogueFrame")
			componentsHolder = componentsHolder and componentsHolder:FindFirstChild("Actual")
			return componentsHolder and componentsHolder:FindFirstChild("ButtonHolder"), componentsHolder
		end

		local n4 = os.clock() + 9
		local flag2 = false
		local n5 = 0
		local flag3

		while true do
			flag3 = false

			if not (os.clock() < n4) then
				break
			else
				local v6, v7 = fn33()

				if v6 then
					local v8 = nil

					for _, child in ipairs(v6:GetChildren()) do
						if child.Name == v2.Name or string.find(string.lower(child.Name), string.lower(v2.Name), 1, true) then
							v8 = child
							break
						else
							v8 = nil
						end
					end

					if v8 then
						local textButton = v8:FindFirstChildWhichIsA("TextButton", true)

						if textButton then
							pcall(function()
								firesignal(textButton.MouseButton1Click)
							end)

							pcall(function()
								firesignal(textButton.Activated)
							end)

							flag3 = true
						end

						flag2 = true
						break
					else
						flag2 = true

						if v7 then
							local clickDetector = v7:FindFirstChild("ClickDetector")

							if clickDetector and clickDetector.Visible and os.clock() - n5 >= 0.25 then
								n5 = os.clock()

								pcall(function()
									firesignal(clickDetector.MouseButton1Click)
								end)

								if VirtualInputManager then
									local n6 = clickDetector.AbsolutePosition + clickDetector.AbsoluteSize / 2

									pcall(function()
										VirtualInputManager:SendMouseButtonEvent(n6.X, n6.Y, 0, true, game, 0)
										task.wait(0.03)
										VirtualInputManager:SendMouseButtonEvent(n6.X, n6.Y, 0, false, game, 0)
									end)
								end
							end
						end

						task.wait(0.2)
					end
				else
					task.wait(0.2)
				end
			end
		end

		if not flag3 and not flag2 then
			pcall(function()
				local Dialogue = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue)

				if Dialogue.Functions and Dialogue.Functions.AddQuest then
					Dialogue.Functions.AddQuest(v2.Name)
				end
			end)

			pcall(function()
				local name = v2.Name
				require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent).ToServer("AddQuest", name)
			end)
		end

		local n6 = os.clock() + 3
		local flag4

		while true do
			flag4 = false

			if not (os.clock() < n6) then
				break
			else
				task.wait(0.1)
				local flag5 = fn27()

				if flag5 then
					flag5 = flag5.QuestString == v2.Name or flag5.Name == v2.QuestInstanceName or flag5.Name == v2.Name
				end

				if flag5 then
					flag4 = true
					break
				end
			end
		end

		pcall(function()
			require(ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.DialogueUtility).Close()
		end)

		pcall(function()
			local Dialogue = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue)
			Dialogue.CurrentDialogue.Current = nil

			if Dialogue.CurrentDialogue.Cancel then
				Dialogue.CurrentDialogue.Cancel:Fire()
			end
		end)

		task.wait(0.1)
		slayersSyneroxHub.IsInteractingQuest = false
		return flag4
	end

	fn30 = function(arg)
		local v2 = tbl4[1]
		local n4 = -1

		for _, v3 in ipairs(tbl4) do
			if arg >= v3.MinLevel and v3.MinLevel >= n4 and fn32(v3) then
				n4 = v3.MinLevel
				v2 = v3
			end
		end

		return v2
	end
end

GetPromptPosition = function(arg)
	if not arg then
		return nil
	end

	if not arg:IsA("ProximityPrompt") then
		if arg:IsA("BasePart") then
			return arg.Position
		end

		if arg:IsA("Attachment") then
			return arg.WorldPosition
		end

		if arg:IsA("Model") then
			return arg:GetPivot().Position
		end
		return nil
	end

	local parent = arg.Parent
	if not parent then
		return nil
	end

	if parent:IsA("BasePart") then
		return parent.Position
	end

	if parent:IsA("Attachment") then
		return parent.WorldPosition
	end

	if parent:IsA("Model") then
		return parent:GetPivot().Position
	end
	local basePart = parent:FindFirstAncestorWhichIsA("BasePart") or parent:FindFirstChildWhichIsA("BasePart", true)
	if basePart then
		return basePart.Position
	end
	local model = parent:FindFirstAncestorWhichIsA("Model") or parent:FindFirstChildWhichIsA("Model", true)
	if model then
		return model:GetPivot().Position
	end
	return nil
end

GetPlayerWen = function()
	local n4 = 0

	pcall(function()
		local v2 = fn2()

		if v2 and v2:FindFirstChild("Wen") then
			n4 = tonumber(v2.Wen.Value) or 0
		end
	end)

	if n4 == 0 then
		pcall(function()
			local playerService = ReplicatedStorage:FindFirstChild("Player_Service")
			local data = playerService and playerService:FindFirstChild("Data") and playerService.Data:FindFirstChild(localPlayer.Name)

			if data and data:FindFirstChild("Wen") then
				n4 = tonumber(data.Wen.Value) or 0
			end
		end)
	end

	return n4
end

SendDiscordWebhook = function(arg)
	if not slayersSyneroxHub.Webhook or not slayersSyneroxHub.Webhook.Url or slayersSyneroxHub.Webhook.Url == "" or not slayersSyneroxHub.Webhook.Enabled then
		return
	end

	task.spawn(function()
		pcall(function()
			local json = game:GetService("HttpService"):JSONEncode(arg)
			local request_ = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request

			if request_ then
				request_({
					Url = slayersSyneroxHub.Webhook.Url,
					Method = "POST",
					Headers = { ["Content-Type"] = "application/json" },
					Body = json,
				})
			end
		end)
	end)
end

SendWebhookEmbed = function(arg, arg2, arg3, arg4)
	if not slayersSyneroxHub.Webhook or not slayersSyneroxHub.Webhook.Url or slayersSyneroxHub.Webhook.Url == "" or not slayersSyneroxHub.Webhook.Enabled then
		return
	end
	local flag = slayersSyneroxHub.Webhook.PingUser and slayersSyneroxHub.Webhook.DiscordUserId and slayersSyneroxHub.Webhook.DiscordUserId ~= ""
	local str = ""

	if flag then
		str = "<@" .. slayersSyneroxHub.Webhook.DiscordUserId .. ">"
	end

	SendDiscordWebhook({
		content = str ~= "" and str or nil,
		embeds = {
			{
				title = arg,
				description = arg2,
				color = arg3 or 7549397,
				fields = arg4 or {},
				footer = { text = "Synerox Hub • Project Slayers" },
				timestamp = DateTime.now():ToIsoDate(),
			},
		},
	})
end

TestDiscordWebhook = function()
	if not slayersSyneroxHub.Webhook or not slayersSyneroxHub.Webhook.Url or slayersSyneroxHub.Webhook.Url == "" then
		fn("Discord Webhook", "Please enter a valid Webhook URL first!", 4)
		return
	end
	local v2 = SendWebhookEmbed
	local str = "Successfully connected to **" .. localPlayer.DisplayName .. "** (" .. localPlayer.Name .. ")'s session."
	local tbl5 = {}
	local tbl6 = { name = "Player Level", value = tostring(fn26()), inline = true }
	local tbl7 = { name = "Current Clan", value = tostring(fn3()), inline = true }
	local tbl8 = { name = "Player Wen", value = tostring(GetPlayerWen()), inline = true }
	tbl5[1] = { name = "Game", value = "Project Slayers", inline = true }
	tbl5[2] = tbl6
	tbl5[3] = tbl7
	tbl5[4] = tbl8
	v2("Synerox Webhook Connected!", str, 10027263, tbl5)
	fn("Discord Webhook", "Test message dispatched to Discord Webhook!", 4)
end

GetClanRarity = function(arg)
	local tbl5 = { Agatsuma = true, Douma = true, Himejima = true, Iguro = true, Shinazugawa = true, Tamayo = true }
	local tbl6 = { Kocho = true, Shabana = true, Tomioka = true, Ubuyashiki = true }
	local tbl7 = { Makomo = true, Sabito = true, Susumaru = true, Urokodaki = true, Yahaba = true }
	local tbl8 = { Aori = true, Aoshima = true, Kaneki = true, Kurotsume = true, Yamagiri = true }
	if ({ Kamado = true, Rengoku = true, Soyama = true, Uzui = true })[arg] then
		return "Supreme", 16766720
	end

	if tbl5[arg] then
		return "Mythic", 16711731
	end

	if tbl6[arg] then
		return "Legendary", 10027263
	end

	if tbl7[arg] then
		return "Rare", 39423
	end

	if tbl8[arg] then
		return "Uncommon", 65382
	end
	return "Common", 8421504
end

IsOuwigaharaUnlocked = function()
	local flag = false

	pcall(function()
		if localPlayer:GetAttribute("OuwigaharaUnlocked") == true or localPlayer:GetAttribute("Ouwigahara") == true or localPlayer:GetAttribute("DungeonUnlocked") == true then
			flag = true
		end
	end)

	local flag2 = not flag

	if flag2 then
		pcall(function()
			local v2 = fn2()

			if v2 then
				if v2:FindFirstChild("OuwigaharaUnlocked") and v2.OuwigaharaUnlocked.Value == true then
					flag = true
				elseif v2:FindFirstChild("Dungeons") and v2.Dungeons:FindFirstChild("Ouwigahara") and v2.Dungeons.Ouwigahara.Value == true then
					flag = true
				elseif v2:FindFirstChild("Unlocks") and v2.Unlocks:FindFirstChild("Ouwigahara") and v2.Unlocks.Ouwigahara.Value == true then
					flag = true
				elseif v2:FindFirstChild("OuwiUnlocked") and v2.OuwiUnlocked.Value == true then
					flag = true
				end
			end
		end)
	end

	if flag2 and slayersSyneroxHub.Dungeon and slayersSyneroxHub.Dungeon.OuwigaharaUnlockedAlready then
		flag = true
	end

	return flag
end

CheckOuwigaharaRequirements = function()
	local v2 = fn26()
	local v3 = GetPlayerWen()
	local v4 = fn25()
	local flag = v2 >= 50
	local v5 = IsOuwigaharaUnlocked()
	local v6 = flag or v5
	local str

	if v5 then
		str = "ALREADY UNLOCKED (Ready for Ouwigahara)"
	elseif flag then
		str = "ELIGIBLE (Ready to Unlock)"
	else
		str = string.format("INCOMPLETE (Need %d more levels)", 50 - v2)
	end

	return {
		Level = v2,
		RequiredLevel = 50,
		LevelPass = flag,
		AlreadyUnlocked = v5,
		Wen = v3,
		Race = v4,
		CanEnter = v6,
		Status = str,
	}
end

AutoUnlockOuwigahara = function()
	if IsOuwigaharaUnlocked() then
		fn("Ouwigahara Dungeon", "Ouwigahara is ALREADY UNLOCKED! No action needed.", 4)
		return true
	end
	local v2 = CheckOuwigaharaRequirements()
	if not v2.LevelPass then
		fn("Ouwigahara Dungeon", string.format("Level %d/50 — You need Level 50 to unlock Ouwigahara!", v2.Level), 5)
		return false
	end
	fn("Ouwigahara Dungeon", "Level 50 confirmed! Teleporting to portal gate...", 4)
	local vector = Vector3.new(-1607.1, 1018, 1142.4)
	fn24(Vector3.new(-1607.1, 1018, 1142.4), "Ouwigahara Dungeon Portal")
	task.wait(0.6)
	local v3 = fn8()

	if v3 then
		pcall(function()
			require(ReplicatedStorage.CAM.Global.Subsets.Areas.AreaLocator):Update(v3)
		end)
	end

	pcall(function()
		for _, descendant in ipairs(Workspace:GetDescendants()) do
			if descendant:IsA("ProximityPrompt") then
				local v4 = GetPromptPosition(descendant)

				if v4 and (v4 - vector).Magnitude < 40 then
					fireproximityprompt(descendant)
				end
			end
		end
	end)

	pcall(function()
		require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent).ToServer("MinigameQueue", "Ouwigahara")
	end)

	pcall(function()
		require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction).ToServer("OuwigaharaJoin", "Normal")
	end)

	slayersSyneroxHub.Dungeon.OuwigaharaUnlockedAlready = true
	fn("Ouwigahara Dungeon", "Unlock & Matchmaking signals dispatched successfully!", 5)
	return true
end

GetDungeonQueuePad = function()
	local map = Workspace:FindFirstChild("Map")
	map = map and map:FindFirstChild("Minigame Map")

	if map then
		local startPad = map:FindFirstChild("StartPad")
		if startPad then
			return startPad
		end
	end

	for _, descendant in ipairs(Workspace:GetDescendants()) do
		if descendant.Name == "StartPad" and descendant:IsA("BasePart") then
			return descendant
		end
	end

	return nil
end

IsInDungeonQueueArea = function()
	if GetDungeonQueuePad() then
		return true
	end
	local v2 = fn8()
	if v2 and (v2.Position - Vector3.new(-2547, 1148.6, -5082.3)).Magnitude < 450 then
		return true
	end
	return false
end

local n4 = 0

StepAutoQueuePad = function(arg)
	local now = os.clock()
	if not arg and now - n4 < 1 then
		return false
	end
	n4 = now
	local v2 = GetDungeonQueuePad()
	local v3 = fn8()
	if not v2 or not v3 then
		return false
	end
	local proximityPrompt = v2:FindFirstChildWhichIsA("ProximityPrompt", true)

	if not proximityPrompt then
		for _, descendant in ipairs(v2:GetDescendants()) do
			if descendant:IsA("ProximityPrompt") then
				proximityPrompt = descendant
				break
			end
		end
	end

	if not proximityPrompt or not proximityPrompt.Enabled then
		return false
	end
	v3.CFrame = v2.CFrame + Vector3.new(0, 2.5, 0)
	v3.AssemblyLinearVelocity = Vector3.zero
	v3.AssemblyAngularVelocity = Vector3.zero

	pcall(function()
		proximityPrompt.HoldDuration = 0
		proximityPrompt.RequiresLineOfSight = false
		proximityPrompt.MaxActivationDistance = 50
	end)

	task.wait(0.05)
	pcall(fireproximityprompt, proximityPrompt)

	pcall(function()
		firetouchinterest(v3, v2, 0)
		task.wait(0.05)
		firetouchinterest(v3, v2, 1)
	end)

	pcall(function()
		local SignalEvent2 = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent)
		SignalEvent2.ToServer("MinigameQueue", "Ouwigahara")
		SignalEvent2.ToServer("ReadyUp", true)
	end)

	fn("Ouwigahara Queue", "Queue Area detected! Ready Up activated.", 3.5)
	return true
end

GetAvailableSkillPoints = function()
	local n5 = 0

	pcall(function()
		local v2 = fn2()

		if v2 then
			local points = v2:FindFirstChild("Points") or v2:FindFirstChild("SkillPoints") or v2:FindFirstChild("StatPoints") or v2:FindFirstChild("PointsLeft")

			if points then
				n5 = tonumber(points.Value) or 0
			end
		end
	end)

	if n5 == 0 then
		pcall(function()
			local playerService = ReplicatedStorage:FindFirstChild("Player_Service")
			local data = playerService and playerService:FindFirstChild("Data") and playerService.Data:FindFirstChild(localPlayer.Name)

			if data then
				local points = data:FindFirstChild("Points") or data:FindFirstChild("SkillPoints") or data:FindFirstChild("StatPoints")

				if points then
					n5 = tonumber(points.Value) or 0
				end
			end
		end)
	end

	return n5
end

AllocateSkillPoint = function(arg)
	pcall(function()
		local SignalFunction2 = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction)

		if SignalFunction2 and SignalFunction2.ToServer then
			SignalFunction2.ToServer("AddPoint", arg)
			SignalFunction2.ToServer("Upgrade_Stat", arg)
			SignalFunction2.ToServer("StatAdd", arg)
			SignalFunction2.ToServer("Upgrade_Skill", arg)
			SignalFunction2.ToServer("AllocatePoint", arg)
		end
	end)

	pcall(function()
		local SignalEvent2 = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent)

		if SignalEvent2 and SignalEvent2.ToServer then
			SignalEvent2.ToServer("AddPoint", arg)
			SignalEvent2.ToServer("Upgrade_Stat", arg)
			SignalEvent2.ToServer("StatAdd", arg)
			SignalEvent2.ToServer("Upgrade_Skill", arg)
			SignalEvent2.ToServer("AllocatePoint", arg)
		end
	end)

	pcall(function()
		local playerGui = localPlayer:FindFirstChild("PlayerGui")
		if not playerGui then
			return
		end
		local tbl5 = {}
		local menu = playerGui:FindFirstChild("Menu")
		local skills = playerGui:FindFirstChild("Skills")
		local stats = playerGui:FindFirstChild("Stats")
		local findFirstChild = playerGui.FindFirstChild
		tbl5[1] = menu
		tbl5[2] = skills
		tbl5[3] = stats

		do
			local values = table.pack(findFirstChild(playerGui, "ComponentsHolder"))
			table.move(values, 1, values.n, 4, tbl5)
		end

		for _, v2 in ipairs(tbl5) do
			if v2 then
				for _, descendant in ipairs(v2:GetDescendants()) do
					if (descendant:IsA("TextButton") or descendant:IsA("ImageButton")) and descendant.Visible then
						local v3 = string.lower(descendant.Name)
						local parent = descendant.Parent and string.lower(descendant.Parent.Name) or ""
						local isTextButton = descendant:IsA("TextButton") and string.lower(descendant.Text) or ""
						local v4 = string.lower(arg)

						if v3:find(v4) or parent:find(v4) or isTextButton:find(v4) or isTextButton:find("+") and parent:find(v4) then
							firesignal(descendant.MouseButton1Click)
							firesignal(descendant.Activated)
						end
					end
				end
			end
		end
	end)
end

RunAutoSkillTreeAllocation = function()
	if not slayersSyneroxHub.SkillTree.AutoAllocate then
		return
	end

	if GetAvailableSkillPoints() <= 0 then
		return
	end

	local tbl5 = ({
		Balanced = { "Strength", "Stamina", "Health", "Sword" },
		["Strength / M1 Damage"] = { "Strength", "Sword" },
		["Health / Max Stamina"] = { "Health", "Stamina" },
		["Sword Mastery"] = { "Sword", "Strength" },
		["Breathing / BDA Mastery"] = { "Breathing", "Stamina" },
	})[slayersSyneroxHub.SkillTree.Priority] or { "Strength", "Stamina", "Health" }

	for _, v2 in ipairs(tbl5) do
		AllocateSkillPoint(v2)
		task.wait(0.04)
	end
end

RunImmediateSkillAllocation = function()
	local v2 = GetAvailableSkillPoints()
	if v2 <= 0 then
		fn("Skill Tree", "No skill points available to allocate!", 3)
		return
	end
	fn("Skill Tree", string.format("Allocating %d points with priority: %s...", v2, slayersSyneroxHub.SkillTree.Priority), 3)

	local tbl5 = ({
		Balanced = { "Strength", "Stamina", "Health", "Sword" },
		["Strength / M1 Damage"] = { "Strength", "Sword" },
		["Health / Max Stamina"] = { "Health", "Stamina" },
		["Sword Mastery"] = { "Sword", "Strength" },
		["Breathing / BDA Mastery"] = { "Breathing", "Stamina" },
	})[slayersSyneroxHub.SkillTree.Priority] or { "Strength", "Stamina", "Health" }

	task.spawn(function()
		for i = 1, math.min(v2, 100) do
			for _, v3 in ipairs(tbl5) do
				AllocateSkillPoint(v3)
				task.wait(0.03)
			end
		end

		fn("Skill Tree", "Skill point allocation routine finished!", 4)
	end)
end

do
	local flag = false
	local n5 = 0

	ExecuteParryBlock = function()
		if flag then
			return
		end
		local now = os.clock()
		if now - n5 < (slayersSyneroxHub.Combat.ParryCooldown or 0.22) then
			return
		end
		flag = true
		n5 = now

		pcall(function()
			if InputHandler and InputHandler.VirtualPress then
				InputHandler.VirtualPress("Block")
			else
				VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
			end
		end)

		pcall(function()
			local SignalFunction2 = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction)

			if SignalFunction2 and SignalFunction2.ToServer then
				SignalFunction2.ToServer("Block", true)
			end
		end)

		task.delay(slayersSyneroxHub.Combat.ParryDuration or 0.18, function()
			pcall(function()
				if InputHandler and InputHandler.VirtualRelease then
					InputHandler.VirtualRelease("Block")
				else
					VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
				end
			end)

			pcall(function()
				local SignalFunction2 = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction)

				if SignalFunction2 and SignalFunction2.ToServer then
					SignalFunction2.ToServer("Block", false)
				end
			end)

			flag = false

			if slayersSyneroxHub.Combat.AutoCounter and slayersSyneroxHub.Combat.FastAttack then
				task.delay(0.03, function()
					fn13()
				end)
			end
		end)
	end
end

CheckPredictiveParry = function()
	if not slayersSyneroxHub.Combat.AutoParry then
		return
	end
	local v2 = fn8()
	if not v2 then
		return
	end
	local parryRange = slayersSyneroxHub.Combat.ParryRange or 16

	local function fn31(arg, arg2)
		if not arg or arg == localPlayer.Character then
			return
		end
		local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart") or arg:FindFirstChild("Torso")
		if not humanoidRootPart then
			return
		end

		if parryRange < (humanoidRootPart.Position - v2.Position).Magnitude then
			return
		end
		local humanoid = arg:FindFirstChildOfClass("Humanoid")
		if not humanoid or humanoid.Health <= 0 then
			return
		end
		local animator = humanoid:FindFirstChildOfClass("Animator")

		if animator then
			for _, v3 in ipairs(animator:GetPlayingAnimationTracks()) do
				if v3.IsPlaying and v3.WeightCurrent > 0.1 then
					local v4 = string.lower(v3.Name)
					if v4:find("attack") or v4:find("punch") or v4:find("swing") or v4:find("slash") or v4:find("m1") or v4:find("m2") or v4:find("heavy") or v4:find("skill") or v4:find("strike") or v4:find("thrust") or v4:find("combo") or v4:find("flurry") or v4:find("cleave") or v3.Speed > 1 and v3.TimePosition < 0.35 then
						ExecuteParryBlock()
						return
					end
				end
			end
		end

		local rightHand = arg:FindFirstChild("RightHand") or arg:FindFirstChild("Right Arm")

		if rightHand and rightHand.AssemblyLinearVelocity.Magnitude > 14 then
			if (v2.Position - rightHand.Position).Unit:Dot(rightHand.AssemblyLinearVelocity.Unit) > 0.4 then
				ExecuteParryBlock()
				return
			end
		end

		if arg2 then
			pcall(function()
				local playerService = ReplicatedStorage:FindFirstChild("Player_Service")
				local values = playerService and playerService:FindFirstChild("Values") and playerService.Values:FindFirstChild(arg.Name)

				if values then
					values = values:FindFirstChild("Attacking") or values:FindFirstChild("CombatAction") or values:FindFirstChild("M1")
				end

				if values then
					ExecuteParryBlock()
				end
			end)
		end
	end

	if slayersSyneroxHub.Combat.ParryMode ~= "Players Only" then
		local debree = Workspace:FindFirstChild("Debree")
		debree = debree and debree:FindFirstChild("Regions")

		if debree then
			for _, child in ipairs(debree:GetChildren()) do
				local activeNpcs = child:FindFirstChild("ActiveNpcs")

				if activeNpcs then
					for _, child2 in ipairs(activeNpcs:GetChildren()) do
						if child2:IsA("Model") and child2:FindFirstChildOfClass("Humanoid") then
							fn31(child2, false)
						end
					end
				end
			end
		end

		local mobs = Workspace:FindFirstChild("Mobs")

		if mobs then
			for _, child in ipairs(mobs:GetChildren()) do
				fn31(child, false)
			end
		end
	end

	if slayersSyneroxHub.Combat.ParryMode ~= "Mobs Only" then
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer and player.Character then
				fn31(player.Character, true)
			end
		end
	end
end

local tbl5

tbl5 = {
	Weapons = {
		["Common Katana (500 Wen)"] = { Name = "Common Katana", Price = 500, Pos = Vector3.new(-586.3, 1244.6, -1085.8) },
		["Water Nichirin (2500 Wen)"] = { Name = "Water Nichirin", Price = 2500, Pos = Vector3.new(667.2, 1022.7, -228.2) },
		["Thunder Nichirin (2500 Wen)"] = { Name = "Thunder Nichirin", Price = 2500, Pos = Vector3.new(1970.2, 1660, -609.8) },
		["Wind Nichirin (2500 Wen)"] = { Name = "Wind Nichirin", Price = 2500, Pos = Vector3.new(-275.6, 1187.5, -3436.7) },
		["Flame Nichirin (2500 Wen)"] = { Name = "Flame Nichirin", Price = 2500, Pos = Vector3.new(-967.6, 1028.7, 1188.2) },
		["Insect Nichirin (3000 Wen)"] = { Name = "Insect Nichirin", Price = 3000, Pos = Vector3.new(-1805, 350, -180) },
		["Sound Nichirin (3000 Wen)"] = { Name = "Sound Nichirin", Price = 3000, Pos = Vector3.new(1980, 1670, -620) },
		["Beast Nichirin (3000 Wen)"] = { Name = "Beast Nichirin", Price = 3000, Pos = Vector3.new(450, 1050, -320) },
		["Mist Nichirin (3500 Wen)"] = { Name = "Mist Nichirin", Price = 3500, Pos = Vector3.new(980, 280, -2820) },
		["Sun Nichirin (5000 Wen)"] = { Name = "Sun Nichirin", Price = 5000, Pos = Vector3.new(-1050, 1135, -630) },
		["Moon Nichirin (5000 Wen)"] = { Name = "Moon Nichirin", Price = 5000, Pos = Vector3.new(3100, 1800, -1500) },
		["Devourer Katana (10000 Wen)"] = { Name = "Devourer Katana", Price = 10000, Pos = Vector3.new(-2500, 2100, 800) },
	},
	Gourds = {
		["Small Gourd (700 Wen)"] = { Name = "Small Gourd", Price = 700, Pos = Vector3.new(-1798.9, 347.9, -189.3) },
		["Medium Gourd (1500 Wen)"] = { Name = "Medium Gourd", Price = 1500, Pos = Vector3.new(-1798.9, 347.9, -189.3) },
		["Big Gourd (3500 Wen)"] = { Name = "Big Gourd", Price = 3500, Pos = Vector3.new(-1798.9, 347.9, -189.3) },
	},
	Items = {
		["Bandage (50 Wen)"] = { Name = "Bandage", Price = 50, Pos = Vector3.new(-586.3, 1244.6, -1085.8) },
		["Health Potion (200 Wen)"] = { Name = "Health Potion", Price = 200, Pos = Vector3.new(-1798.9, 347.9, -189.3) },
		["Stamina Elixir (200 Wen)"] = { Name = "Stamina Elixir", Price = 200, Pos = Vector3.new(-1798.9, 347.9, -189.3) },
		["Lantern (250 Wen)"] = { Name = "Lantern", Price = 250, Pos = Vector3.new(540, 1121, -1024) },
		["Fishing Bait (100 Wen)"] = { Name = "Bait", Price = 100, Pos = Vector3.new(140.7, 873.5, 728.2) },
	},
}

ExecuteShopPurchase = function(arg)
	if not arg then
		return
	end
	local v2 = GetPlayerWen()
	if v2 < arg.Price then
		fn("Shop", string.format("Not enough Wen! Need %d Wen (Current: %d)", arg.Price, v2), 4)
		return
	end
	fn("Shop", string.format("Purchasing %s (%d Wen)...", arg.Name, arg.Price), 3)

	pcall(function()
		local SignalFunction2 = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction)

		if SignalFunction2 and SignalFunction2.ToServer then
			SignalFunction2.ToServer("BuyItem", arg.Name)
			SignalFunction2.ToServer("BuyWeapon", arg.Name)
			SignalFunction2.ToServer("Purchase", arg.Name)
			SignalFunction2.ToServer("ShopBuy", arg.Name)
			SignalFunction2.ToServer("Item_Purchase", arg.Name)
		end
	end)

	pcall(function()
		local SignalEvent2 = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent)

		if SignalEvent2 and SignalEvent2.ToServer then
			SignalEvent2.ToServer("Item_Purchase", arg.Name)
			SignalEvent2.ToServer("BuyItem", arg.Name)
			SignalEvent2.ToServer("BuyWeapon", arg.Name)
			SignalEvent2.ToServer("ShopAction", "Buy", arg.Name)
		end
	end)

	if arg.Pos then
		local cFrame = fn8() and fn8().CFrame
		fn24(arg.Pos, arg.Name .. " Merchant")
		task.wait(0.35)

		pcall(function()
			for _, descendant in ipairs(Workspace:GetDescendants()) do
				if descendant:IsA("ProximityPrompt") then
					local v3 = GetPromptPosition(descendant)

					if v3 and (v3 - arg.Pos).Magnitude < 25 then
						fireproximityprompt(descendant)
					end
				end
			end
		end)

		local n5 = os.clock() + 3

		while os.clock() < n5 do
			local playerGui = localPlayer:FindFirstChild("PlayerGui")
			playerGui = playerGui and playerGui:FindFirstChild("ComponentsHolder")
			playerGui = playerGui and playerGui:FindFirstChild("DialogueFrame")
			playerGui = playerGui and playerGui:FindFirstChild("Actual")

			if playerGui then
				local clickDetector = playerGui:FindFirstChild("ClickDetector")

				if clickDetector and clickDetector.Visible then
					firesignal(clickDetector.MouseButton1Click)
				end

				local buttonHolder = playerGui:FindFirstChild("ButtonHolder")

				if buttonHolder then
					for _, child in ipairs(buttonHolder:GetChildren()) do
						local textButton = child:FindFirstChildWhichIsA("TextButton", true) or child:IsA("TextButton") and child

						if textButton then
							local v3 = string.lower(textButton.Text)
							local v4 = string.lower(arg.Name)

							if v3:find(v4) or v3:find("buy") or v3:find("yes") or v3:find("purchase") then
								firesignal(textButton.MouseButton1Click)
								firesignal(textButton.Activated)
								break
							end
						end
					end
				end
			end

			task.wait(0.2)
		end

		task.wait(0.2)

		if cFrame and fn8() then
			fn8().CFrame = cFrame
		end
	end

	if slayersSyneroxHub.Shop.AutoEquip then
		task.delay(0.5, function()
			local backpack = localPlayer:FindFirstChild("Backpack")
			local character = localPlayer.Character

			if backpack and character then
				for _, child in ipairs(backpack:GetChildren()) do
					local isTool = child:IsA("Tool")
					local v3

					if isTool then
						local flag = child.Name == arg.Name

						if flag then
							v3 = flag
						else
							local lower = string.lower
							local name = arg.Name
							v3 = string.find(string.lower(child.Name), lower(name))
						end
					else
						v3 = isTool
					end

					if v3 then
						child.Parent = character
						fn("Shop", "Equipped " .. child.Name .. "!", 3)
						break
					end
				end
			end
		end)
	end

	fn("Shop", "Purchase processed for " .. arg.Name .. "!", 4)
end

local tbl6 = {
	devourer = 100,
	sun = 90,
	moon = 85,
	mist = 80,
	sound = 75,
	insect = 70,
	flame = 65,
	thunder = 60,
	water = 55,
	wind = 50,
	beast = 45,
	common = 20,
	wooden = 10,
}

AutoEquipBestGear = function()
	local character = localPlayer.Character
	local backpack = localPlayer:FindFirstChild("Backpack")
	if not character or not backpack then
		return
	end
	local tbl7 = {}

	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Tool") then
			table.insert(tbl7, child)
		end
	end

	for _, child in ipairs(backpack:GetChildren()) do
		if child:IsA("Tool") then
			table.insert(tbl7, child)
		end
	end

	local n5 = -1
	local v2 = nil

	for _, v3 in ipairs(tbl7) do
		local v4 = string.lower(v3.Name)

		for k, v5 in pairs(tbl6) do
			if v4:find(k) and v5 > n5 then
				n5 = v5
				v2 = v3
			end
		end
	end

	if v2 then
		if v2.Parent == backpack then
			for _, child in ipairs(character:GetChildren()) do
				if child:IsA("Tool") and child ~= v2 then
					child.Parent = backpack
				end
			end

			v2.Parent = character
			fn("Equipment", "Equipped Best Katana: " .. v2.Name, 3)
		end
	end

	pcall(function()
		local SignalFunction2 = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction)
		local SignalEvent2 = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent)

		for _, v3 in ipairs({ "Polar Haori", "Polar Mask", "Devourer Haori", "Champion Haori" }) do
			if SignalFunction2 and SignalFunction2.ToServer then
				SignalFunction2.ToServer("EquipItem", v3)
			end

			if SignalEvent2 and SignalEvent2.ToServer then
				SignalEvent2.ToServer("EquipItem", v3)
			end
		end
	end)
end

local tbl7

tbl7 = {
	Nezuko = { RespawnTime = 600, Pos = Vector3.new(-1040, 1120, -680), LastDeath = 0, IsAlive = false },
	Yahaba = { RespawnTime = 900, Pos = Vector3.new(-150, 280, -1650), LastDeath = 0, IsAlive = false },
	Sasumaru = { RespawnTime = 900, Pos = Vector3.new(-180, 280, -1700), LastDeath = 0, IsAlive = false },
	["Hand Demon"] = { RespawnTime = 600, Pos = Vector3.new(2250, 1600, -750), LastDeath = 0, IsAlive = false },
	Sabito = {
		RespawnTime = 600,
		Pos = Vector3.new(-1046.8, 1133.5, -628.8),
		LastDeath = 0,
		IsAlive = false,
	},
	["Zanegutsu Kuuchie"] = { RespawnTime = 480, Pos = Vector3.new(450, 1050, -320), LastDeath = 0, IsAlive = false },
	Shiron = { RespawnTime = 480, Pos = Vector3.new(800, 1030, -180), LastDeath = 0, IsAlive = false },
	Sanemi = { RespawnTime = 1200, Pos = Vector3.new(-280, 1190, -3450), LastDeath = 0, IsAlive = false },
	Giyu = { RespawnTime = 1200, Pos = Vector3.new(670, 1030, -250), LastDeath = 0, IsAlive = false },
	Rengoku = { RespawnTime = 1200, Pos = Vector3.new(-970, 1035, 1200), LastDeath = 0, IsAlive = false },
	Tengen = { RespawnTime = 1200, Pos = Vector3.new(1980, 1670, -620), LastDeath = 0, IsAlive = false },
	Akaza = { RespawnTime = 1500, Pos = Vector3.new(3100, 1800, -1500), LastDeath = 0, IsAlive = false },
	Douma = { RespawnTime = 1800, Pos = Vector3.new(-2500, 2100, 800), LastDeath = 0, IsAlive = false },
}

local tbl8
tbl8 = {}

UpdateBossTimers = function()
	local now = os.clock()
	local v2 = fn14()
	local tbl9 = {}

	for _, v3 in ipairs(v2) do
		local v4 = string.lower(v3.Name)

		for k in pairs(tbl7) do
			if v4:find(string.lower(k)) then
				tbl9[k] = true
			end
		end
	end

	for k, v3 in pairs(tbl7) do
		local flag = tbl9[k] == true

		if flag and not v3.IsAlive then
			v3.IsAlive = true

			if slayersSyneroxHub.Notifiers and slayersSyneroxHub.Notifiers.BossSpawns then
				fn("Boss Spawns Notify", k .. " is now ALIVE!", 4)

				if slayersSyneroxHub.Webhook and slayersSyneroxHub.Webhook.BossSpawnNotify then
					SendWebhookEmbed("Boss Spawned: " .. k, "**" .. k .. "** has spawned on the server!", 16711680, {
						{ name = "Boss", value = k, inline = true },
						{ name = "Status", value = "ALIVE", inline = true },
					})
				end
			end
		elseif not flag and v3.IsAlive then
			v3.IsAlive = false
			v3.LastDeath = now

			if slayersSyneroxHub.Notifiers and slayersSyneroxHub.Notifiers.BossHunts then
				fn("[ 〢 ] Boss Hunts Notify", k .. " was defeated!", 4)
			end
		end

		local v4 = tbl8[k]

		if v4 then
			pcall(function()
				if v3.IsAlive then
					v4:SetText(k .. ": [ ALIVE ]")
				elseif v3.LastDeath > 0 then
					local n5 = math.max(0, math.floor(v3.RespawnTime - now - v3.LastDeath))

					if n5 > 0 then
						v4:SetText(string.format("%s: [ DEAD ] Respawn: %02d:%02d", k, math.floor(n5 / 60), n5 % 60))
					else
						v4:SetText(k .. ": [ DUE TO SPAWN ]")
					end
				else
					v4:SetText(k .. ": [ SCANNING / READY ]")
				end
			end)
		end
	end
end

FindAndTeleportBlackMarket = function()
	fn("Black Market", "Scanning server for Black Market Merchant...", 3)
	local v2 = nil
	local position = nil

	local function fn31(arg)
		if not arg or not arg:IsA("Model") then
			return
		end
		local v3 = string.lower(arg.Name)

		if v3:find("black market") or v3:find("black merchant") or v3:find("kuro") or v3:find("roaming merchant") or v3:find("merchant") and not v3:find("gourd") then
			local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart") or arg:FindFirstChild("Torso") or arg.PrimaryPart

			if humanoidRootPart then
				v2 = arg
				position = humanoidRootPart.Position
			end
		end
	end

	for _, child in ipairs(Workspace:GetChildren()) do
		fn31(child)
	end

	local debree = Workspace:FindFirstChild("Debree")

	if debree then
		for _, child in ipairs(debree:GetChildren()) do
			local stationaryNpcs = child:FindFirstChild("StationaryNpcs")
			local activeNpcs = child:FindFirstChild("ActiveNpcs")

			if stationaryNpcs then
				for _, child2 in ipairs(stationaryNpcs:GetChildren()) do
					fn31(child2)
				end
			end

			if activeNpcs then
				for _, child2 in ipairs(activeNpcs:GetChildren()) do
					fn31(child2)
				end
			end
		end
	end

	if position then
		fn24(position + Vector3.new(0, 3, 0), "Roaming Black Market (" .. v2.Name .. ")")
		fn("Black Market", "Teleported to Roaming Black Market: " .. v2.Name, 5)
		return
	end

	fn24(Vector3.new(540, 1121, -1024), "Kuro the Black Merchant (Bamboo Grove)")
	fn("Black Market", "Roaming dealer not spawned — teleported to Kuro at Bamboo Grove!", 5)
end

StepAutoGourd = function()
	if not slayersSyneroxHub.Training or not slayersSyneroxHub.Training.AutoGourd then
		return
	end
	local character = localPlayer.Character
	if not character then
		return
	end
	local tool = character:FindFirstChildWhichIsA("Tool")

	if not tool or not string.find(string.lower(tool.Name), "gourd") then
		local backpack = localPlayer:FindFirstChild("Backpack")

		if backpack then
			for _, child in ipairs(backpack:GetChildren()) do
				if string.find(string.lower(child.Name), "gourd") then
					child.Parent = character
					tool = child
					task.wait(0.15)
					break
				end
			end
		end
	end

	if tool then
		pcall(function()
			tool:Activate()
		end)

		pcall(function()
			require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent).ToServer("training_signaler", "Stop", true)
		end)
	end
end

StepAutoBoulder = function()
	if not slayersSyneroxHub.Training or not slayersSyneroxHub.Training.AutoBoulder then
		return
	end
	local v2 = fn8()
	if not v2 then
		return
	end

	if (v2.Position - Vector3.new(-1046.8, 1133.5, -628.8)).Magnitude > 30 then
		fn24(Vector3.new(-1046.8, 1133.5, -628.8), "Sabito Boulder Split")
		task.wait(0.5)
	end

	for _, descendant in ipairs(Workspace:GetDescendants()) do
		if descendant:IsA("ProximityPrompt") then
			local v3 = GetPromptPosition(descendant)
			if v3 and (v3 - Vector3.new(-1046.8, 1133.5, -628.8)).Magnitude < 18 then
				fireproximityprompt(descendant)
				break
			end
		end
	end
end

StepAutoTraining = function()
	if not slayersSyneroxHub.Training or not slayersSyneroxHub.Training.AutoTraining then
		return
	end
	StepAutoGourd()
	StepAutoBoulder()

	pcall(function()
		local v2 = fn7()

		if v2 then
			local skillStandStill = v2:FindFirstChild("skill_stand_still")
			local pauseGameplay = v2:FindFirstChild("pause_gameplay")

			if skillStandStill and skillStandStill.Value or pauseGameplay and pauseGameplay.Value then
				require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent).ToServer("training_signaler", "Stop", true)
			end
		end
	end)
end

StepAutoFish = function()
	if not slayersSyneroxHub.Activities or not slayersSyneroxHub.Activities.AutoFish then
		return
	end
	local character = localPlayer.Character
	local backpack = localPlayer:FindFirstChild("Backpack")
	if not character or not backpack then
		return
	end
	local v2 = nil

	local function fn31(arg)
		if not arg or not arg:IsA("Tool") then
			return false
		end
		local v3 = string.lower(arg.Name)
		return v3:find("rod") or v3:find("fishing")
	end

	for _, v3 in ipairs({ "Legendary Fishing Rod", "Rare Fishing Rod", "Basic Fishing Rod" }) do
		local v4 = character:FindFirstChild(v3)

		if v4 and v4:IsA("Tool") then
			v2 = v4
			break
		else
			local v5 = backpack:FindFirstChild(v3)

			if v5 and v5:IsA("Tool") then
				v5.Parent = character
				v2 = v5
				task.wait(0.2)
				break
			end
		end
	end

	if not v2 then
		for _, child in ipairs(character:GetChildren()) do
			if fn31(child) then
				v2 = child
				break
			end
		end

		if not v2 then
			for _, child in ipairs(backpack:GetChildren()) do
				if fn31(child) then
					child.Parent = character
					v2 = child
					task.wait(0.2)
					break
				end
			end
		end
	end

	if not v2 then
		fn("Auto Fish", "No Fishing Rod found! Teleporting to Angler Runo at Mistfall Harbor...", 4)
		fn24(Vector3.new(140.7, 873.5, 728.2), "Angler Runo (Mistfall Harbor)")
		task.wait(0.5)

		pcall(function()
			require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent).ToServer("BuyItem", "Basic Fishing Rod")
		end)

		return
	end

	local v3 = fn8()

	if v3 and (v3.Position - Vector3.new(156.4, 870.2, 745.8)).Magnitude > 22 then
		fn24(Vector3.new(156.4, 870.2, 745.8), "Mistfall Harbor Fishing Dock")
		task.wait(0.5)
	end

	pcall(function()
		v2:Activate()
	end)

	pcall(function()
		require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction).ToServer("CastRod")
	end)

	pcall(function()
		local SignalEvent2 = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent)
		SignalEvent2.ToServer("CastRod")
		SignalEvent2.ToServer("Fishing_Cast")
	end)

	task.wait(0.2)

	pcall(function()
		local SignalEvent2 = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent)
		SignalEvent2.ToServer("FishingCatch")
		SignalEvent2.ToServer("Fishing_Complete", true)
	end)

	pcall(function()
		require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction).ToServer("FishingCatch")
	end)

	pcall(function()
		local playerGui = localPlayer:FindFirstChild("PlayerGui")
		if not playerGui then
			return
		end

		for _, v4 in ipairs({ "FishMinigame", "Fishing", "FishingGui", "Minigame" }) do
			local v5 = playerGui:FindFirstChild(v4)

			if v5 and v5.Enabled then
				for _, descendant in ipairs(v5:GetDescendants()) do
					if descendant:IsA("TextButton") or descendant:IsA("ImageButton") then
						firesignal(descendant.MouseButton1Click)
						firesignal(descendant.Activated)
					end
				end
			end
		end
	end)
end

StepAutoBuyBait = function()
	if not slayersSyneroxHub.Activities or not slayersSyneroxHub.Activities.AutoBuyBait then
		return
	end

	if GetPlayerWen() < 100 then
		return
	end
	local n5 = 0

	pcall(function()
		local backpack = localPlayer:FindFirstChild("Backpack")
		local character = localPlayer.Character

		if backpack then
			for _, child in ipairs(backpack:GetChildren()) do
				if string.find(string.lower(child.Name), "bait") then
					n5 += 1
				end
			end
		end

		if character then
			for _, child in ipairs(character:GetChildren()) do
				if string.find(string.lower(child.Name), "bait") then
					n5 += 1
				end
			end
		end
	end)

	if n5 < 3 then
		local fishingBait100Wen = tbl5.Items["Fishing Bait (100 Wen)"]

		if fishingBait100Wen then
			ExecuteShopPurchase(fishingBait100Wen)
		end
	end
end

StepAutoBuyExp = function()
	if not slayersSyneroxHub.Activities or not slayersSyneroxHub.Activities.AutoBuyExp then
		return
	end

	if GetPlayerWen() < 1000 then
		return
	end

	pcall(function()
		local SignalFunction2 = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction)
		local SignalEvent2 = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent)

		if SignalFunction2 and SignalFunction2.ToServer then
			SignalFunction2.ToServer("BuyExp")
			SignalFunction2.ToServer("BuyTraining")
		end

		if SignalEvent2 and SignalEvent2.ToServer then
			SignalEvent2.ToServer("TrainExp")
		end
	end)
end

StepCollectSchematics = function()
	local v2 = fn8()
	if not v2 then
		return
	end
	local cFrame = v2.CFrame
	local tbl9 = {}

	local function fn31(arg)
		if not arg then
			return
		end
		local v3 = string.lower(arg.Name)

		if v3:find("schematic") or v3:find("blueprint") or v3:find("chest") then
			local position = arg:IsA("Model") and arg:GetPivot().Position or arg:IsA("BasePart") and arg.Position

			if position then
				table.insert(tbl9, { Object = arg, Pos = position })
			end
		end
	end

	for _, child in ipairs(Workspace:GetChildren()) do
		fn31(child)
	end

	local debree = Workspace:FindFirstChild("Debree")

	if debree then
		for _, child in ipairs(debree:GetChildren()) do
			for _, child2 in ipairs(child:GetChildren()) do
				fn31(child2)
			end
		end
	end

	if #tbl9 == 0 then
		fn("Schematics", "No schematics or blueprints currently detected on the map!", 3)
		return
	end
	fn("Schematics", string.format("Found %d schematics! Collecting...", #tbl9), 3)

	task.spawn(function()
		for _, v3 in ipairs(tbl9) do
			if v3.Pos and v2 then
				v2.CFrame = CFrame.new(v3.Pos + Vector3.new(0, 2.5, 0))
				task.wait(0.2)

				pcall(function()
					for _, descendant in ipairs(v3.Object:GetDescendants()) do
						if descendant:IsA("ProximityPrompt") then
							fireproximityprompt(descendant)
						end
					end
				end)

				pcall(function()
					if v3.Object:IsA("BasePart") then
						firetouchinterest(v2, v3.Object, 0)
						task.wait(0.05)
						firetouchinterest(v2, v3.Object, 1)
					end
				end)

				task.wait(0.15)
			end
		end

		if cFrame and v2 then
			v2.CFrame = cFrame
		end

		fn("Schematics", "Finished schematic sweep!", 3)
	end)
end

do
	local n5 = 0
	local n6 = 0

	CheckWorldNotifiers = function()
		if not slayersSyneroxHub.Notifiers then
			return
		end
		local now = os.clock()

		if slayersSyneroxHub.Notifiers.Muzan and now - n5 > 120 then
			local flag = false

			for _, child in ipairs(Workspace:GetChildren()) do
				if child:IsA("Model") and child.Name:lower():find("muzan") then
					flag = true
					break
				end
			end

			if flag then
				n5 = now
				fn("Muzan Notify", "Muzan Kibutsuji has spawned on the server!", 6)

				if slayersSyneroxHub.Webhook and slayersSyneroxHub.Webhook.MuzanNotify then
					SendWebhookEmbed("Muzan Kibutsuji Spawned!", "Muzan has appeared in the server!", 10027263)
				end
			end
		end

		if slayersSyneroxHub.Notifiers.BlackMarketer and now - n6 > 120 then
			local flag = false

			for _, child in ipairs(Workspace:GetChildren()) do
				if child:IsA("Model") and (child.Name:lower():find("kuro") or child.Name:lower():find("black market")) then
					flag = true
					break
				end
			end

			if flag then
				n6 = now
				fn("Black Marketer Notify", "Roaming Black Market Merchant is active!", 6)

				if slayersSyneroxHub.Webhook and slayersSyneroxHub.Webhook.BlackMarketNotify then
					SendWebhookEmbed("Black Market Merchant Active!", "The Black Market merchant is open for trading!", 39423)
				end
			end
		end
	end
end

GetDungeonAliveMobs = function()
	local tbl9 = {}
	local character = localPlayer.Character
	local v2 = fn8()
	if not v2 then
		return tbl9
	end

	local function fn31(arg)
		if not arg or not arg:IsA("Model") or arg == character then
			return
		end

		if Players:GetPlayerFromCharacter(arg) then
			return
		end
		local humanoid = arg:FindFirstChildOfClass("Humanoid")
		local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart") or arg:FindFirstChild("Torso") or arg:FindFirstChildWhichIsA("BasePart")

		if humanoid and humanoidRootPart and humanoid.Health > 0 and humanoidRootPart.Position.Y > -450 then
			table.insert(tbl9, {
				Model = arg,
				Root = humanoidRootPart,
				Humanoid = humanoid,
				Health = humanoid.Health,
				MaxHealth = humanoid.MaxHealth,
				Name = arg.Name,
				Distance = (v2.Position - humanoidRootPart.Position).Magnitude,
			})
		end
	end

	local humanoids = Workspace:FindFirstChild("Humanoids")

	if humanoids then
		for _, descendant in ipairs(humanoids:GetDescendants()) do
			if descendant:IsA("Model") then
				fn31(descendant)
			end
		end
	end

	local debree = Workspace:FindFirstChild("Debree")

	if debree then
		for _, descendant in ipairs(debree:GetDescendants()) do
			if descendant:IsA("Model") then
				fn31(descendant)
			end
		end
	end

	for _, v3 in ipairs({ "Mobs", "Enemies", "DungeonMobs", "WaveMobs", "ActiveNpcs" }) do
		local v4 = Workspace:FindFirstChild(v3)

		if v4 then
			for _, descendant in ipairs(v4:GetDescendants()) do
				if descendant:IsA("Model") then
					fn31(descendant)
				end
			end
		end
	end

	for _, child in ipairs(Workspace:GetChildren()) do
		if child:IsA("Model") and child ~= character then
			fn31(child)
		end
	end

	if slayersSyneroxHub.Dungeon and slayersSyneroxHub.Dungeon.TargetPriority == "Lowest Health" then
		table.sort(tbl9, function(arg, arg2)
			return arg.Health < arg2.Health
		end)
	else
		table.sort(tbl9, function(arg, arg2)
			return arg.Distance < arg2.Distance
		end)
	end

	return tbl9
end

AutoPickDungeonCard = function()
	if not slayersSyneroxHub.Dungeon or not slayersSyneroxHub.Dungeon.AutoPickCards then
		return
	end
	local playerGui = localPlayer:FindFirstChild("PlayerGui")
	if not playerGui then
		return
	end

	for _, child in ipairs(playerGui:GetChildren()) do
		local v2 = string.lower(child.Name)

		if v2:find("card") or v2:find("perk") or v2:find("buff") or v2:find("choice") or v2:find("reward") then
			for _, descendant in ipairs(child:GetDescendants()) do
				if (descendant:IsA("TextButton") or descendant:IsA("ImageButton")) and descendant.Visible then
					firesignal(descendant.MouseButton1Click)
					firesignal(descendant.Activated)
					task.wait(0.15)
					return
				end
			end
		end
	end

	local componentsHolder = playerGui:FindFirstChild("ComponentsHolder")

	if componentsHolder then
		for _, descendant in ipairs(componentsHolder:GetDescendants()) do
			local v2 = string.lower(descendant.Name)

			if v2:find("card") or v2:find("perk") then
				for _, descendant2 in ipairs(descendant:GetDescendants()) do
					if (descendant2:IsA("TextButton") or descendant2:IsA("ImageButton")) and descendant2.Visible then
						firesignal(descendant2.MouseButton1Click)
						firesignal(descendant2.Activated)
						task.wait(0.15)
						return
					end
				end
			end
		end
	end

	pcall(function()
		local SignalEvent2 = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent)
		SignalEvent2.ToServer("PickCard", 1)
		SignalEvent2.ToServer("ChooseCard", 1)
		SignalEvent2.ToServer("DungeonCard", 1)
	end)
end

CollectDungeonChests = function()
	if not slayersSyneroxHub.Dungeon or not slayersSyneroxHub.Dungeon.AutoCollectChests then
		return
	end
	local v2 = fn8()
	if not v2 then
		return
	end

	for _, descendant in ipairs(Workspace:GetDescendants()) do
		if descendant:IsA("ProximityPrompt") and descendant.Enabled then
			local parent = descendant.Parent
			parent = parent and string.lower(parent.Name) or ""
			local v3 = string.lower(descendant.ActionText or "")

			if parent:find("chest") or parent:find("cache") or parent:find("drop") or v3:find("open") or v3:find("claim") or v3:find("collect") or v3:find("loot") then
				local v4 = GetPromptPosition(descendant)

				if v4 and (v4 - v2.Position).Magnitude < 100 then
					pcall(fireproximityprompt, descendant)
				end
			end
		end
	end
end

do
	local n5 = 0
	local n6 = 0
	local n7 = 0
	local v2 = nil

	StepAutoFarmDungeon = function()
		if not slayersSyneroxHub.Dungeon or not slayersSyneroxHub.Dungeon.AutoFarm then
			return
		end
		local v3 = fn8()
		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if not v3 or not character or not humanoid or humanoid.Health <= 0 then
			return
		end

		if IsInDungeonQueueArea() then
			StepAutoQueuePad(false)
			return
		end
		local now = os.clock()

		if now - n6 >= 1 then
			n6 = now
			AutoPickDungeonCard()
		end

		if now - n7 >= 1.5 then
			n7 = now
			CollectDungeonChests()
		end

		local tool = character:FindFirstChildWhichIsA("Tool")

		if not tool then
			local backpack = localPlayer:FindFirstChild("Backpack")

			if backpack then
				for _, child in ipairs(backpack:GetChildren()) do
					if child:IsA("Tool") and not string.lower(child.Name):find("rod") and not string.lower(child.Name):find("gourd") then
						child.Parent = character
						tool = child
						task.wait(0.1)
						break
					end
				end
			end
		end

		if not v2 or not v2.Root or not v2.Humanoid or v2.Humanoid.Health <= 0 or not v2.Root.Parent then
			local v4 = GetDungeonAliveMobs()

			if not (#v4 > 0) then
				v2 = nil
				fn22(v3.CFrame)
				return
			end

			v2 = v4[1]
		end

		local root = v2.Root
		local position = root.Position
		local heightOffset = slayersSyneroxHub.Dungeon and slayersSyneroxHub.Dungeon.HeightOffset or 6.5
		local attackMode = slayersSyneroxHub.Dungeon and slayersSyneroxHub.Dungeon.AttackMode or "Overhead (Safe)"
		local cframe

		if attackMode == "Behind Target" then
			local lookVector = root.CFrame.LookVector
			cframe = CFrame.lookAt(position - Vector3.new(lookVector.X, 0, lookVector.Z).Unit * 3.5 + Vector3.new(0, 1.5, 0), position)
		elseif attackMode == "Ground" then
			cframe = CFrame.lookAt(position + root.CFrame.LookVector * 3, position)
		else
			cframe = CFrame.lookAt(position + Vector3.new(0, heightOffset, 0), position)
		end

		v3.CFrame = cframe
		v3.AssemblyLinearVelocity = Vector3.zero
		v3.AssemblyAngularVelocity = Vector3.zero
		fn22(cframe)

		if now - n5 >= 0.22 then
			n5 = now
			fn13(slayersSyneroxHub.Dungeon and slayersSyneroxHub.Dungeon.MultiHit and (slayersSyneroxHub.Dungeon.MultiHitCount or 3) or 2)

			if tool then
				pcall(function()
					tool:Activate()
				end)
			end
		end

		if slayersSyneroxHub.Dungeon and slayersSyneroxHub.Dungeon.AutoSkills then
			fn12()
		end
	end
end

do
	local tbl9 = {
		["Black Market Dealer"] = { Pos = Vector3.new(540, 1121, -1024), Dynamic = true },
		["Kuro the Black Merchant"] = { Pos = Vector3.new(540, 1121, -1024) },
		["Village Weapon Shop (Raze)"] = { Pos = Vector3.new(-586.3, 1244.6, -1085.8) },
		["Master Swordsmith"] = { Pos = Vector3.new(-1200, 950, 850) },
		["Village Tailor"] = { Pos = Vector3.new(-535, 1245, -1325) },
		["Mask Merchant"] = { Pos = Vector3.new(-650, 1250, -1180) },
		["Gourd Merchant"] = { Pos = Vector3.new(-1798.9, 347.9, -189.3) },
		["Angler Runo"] = { Pos = Vector3.new(140.7, 873.5, 728.2) },
		["Butterfly Medical Clinic"] = { Pos = Vector3.new(-1798.9, 347.9, -189.3) },
		["Horse Carriage Guy"] = { Pos = Vector3.new(-715, 1260, -1120) },
		["Grandpa Somi"] = { Pos = Vector3.new(700, 1150, -1050) },
		Beth = { Pos = Vector3.new(-690, 1261, -1200) },
		Sabito = { Pos = Vector3.new(-1046.8, 1133.5, -628.8) },
		["Doctor Ino"] = { Pos = Vector3.new(895, 1120, -880) },
		["Final Selection Guides"] = { Pos = Vector3.new(-1994.1, 750, 1050.1) },
	}

	local tbl10 = {}

	FindNpcModelInWorld = function(arg)
		local v2 = string.lower(arg or "")
		if v2 == "" then
			return nil
		end

		if tbl10[arg] and tbl10[arg].Parent then
			return tbl10[arg]
		end
		local v3 = nil

		local function fn31(arg2)
			if not arg2 or not arg2:IsA("Model") then
				return
			end

			if Players:GetPlayerFromCharacter(arg2) then
				return
			end
			local v4 = string.lower(arg2.Name)

			if v4 == v2 or v4:find(v2, 1, true) or v2:find(v4, 1, true) then
				if arg2:FindFirstChild("HumanoidRootPart") or arg2:FindFirstChild("Torso") or arg2.PrimaryPart then
					v3 = arg2
				end
			end
		end

		for _, child in ipairs(Workspace:GetChildren()) do
			fn31(child)
		end

		for _, v4 in ipairs({ "Debree", "Humanoids", "NPCs" }) do
			local v5 = Workspace:FindFirstChild(v4)

			if v5 then
				for _, descendant in ipairs(v5:GetDescendants()) do
					if descendant:IsA("Model") then
						fn31(descendant)
					end

					if not v3 then
						continue
					end
					break
				end
			end

			if not v3 then
				continue
			end
			break
		end

		return v3
	end

	TeleportToMiscNpc = function(arg)
		if not arg or arg == "" then
			return
		end

		if string.lower(arg):find("black market") then
			FindAndTeleportBlackMarket()
			return
		end
		local v2 = FindNpcModelInWorld(arg)

		if v2 then
			local humanoidRootPart = v2:FindFirstChild("HumanoidRootPart") or v2:FindFirstChild("Torso") or v2.PrimaryPart

			if humanoidRootPart then
				fn24(humanoidRootPart.Position + Vector3.new(0, 2.5, 0), arg)
				fn("NPC Teleport", "Teleported to " .. arg .. "!", 3.5)
				return
			end
		end

		local v3 = tbl9[arg]

		if v3 and v3.Pos then
			fn24(v3.Pos + Vector3.new(0, 2.5, 0), arg)
			fn("NPC Teleport", "Teleported to " .. arg .. "!", 3.5)
			return
		end

		fn("NPC Teleport", "Could not locate " .. arg .. " in the server.", 4)
	end

	InteractWithMiscNpc = function(arg)
		TeleportToMiscNpc(arg)
		task.wait(0.4)
		local v2 = FindNpcModelInWorld(arg)
		local proximityPrompt = nil

		if v2 then
			proximityPrompt = v2:FindFirstChildWhichIsA("ProximityPrompt", true)
		end

		if not proximityPrompt then
			local v3 = fn8()

			if v3 then
				for _, descendant in ipairs(Workspace:GetDescendants()) do
					if descendant:IsA("ProximityPrompt") then
						local v4 = GetPromptPosition(descendant)
						if v4 and (v4 - v3.Position).Magnitude < 15 then
							proximityPrompt = descendant
							break
						end
					end
				end
			end
		end

		if proximityPrompt then
			pcall(function()
				proximityPrompt.HoldDuration = 0
				proximityPrompt.RequiresLineOfSight = false
			end)

			pcall(fireproximityprompt, proximityPrompt)
			fn("NPC Interaction", "Triggered dialogue prompt for " .. arg .. "!", 3.5)
		else
			fn("NPC Interaction", "No interaction prompt found near " .. arg .. ".", 3.5)
		end
	end

	RefreshServerNpcList = function(arg)
		local n5 = 0
		local tbl11 = {}
		local tbl12 = {}

		for k in pairs(tbl9) do
			tbl12[k] = true
			table.insert(tbl11, k)
		end

		local function fn31(arg2)
			if not arg2 or not arg2:IsA("Model") or tbl12[arg2.Name] then
				return
			end

			if Players:GetPlayerFromCharacter(arg2) then
				return
			end

			if arg2:FindFirstChild("HumanoidRootPart") or arg2:FindFirstChild("Torso") or arg2.PrimaryPart then
				tbl12[arg2.Name] = true
				tbl10[arg2.Name] = arg2
				table.insert(tbl11, arg2.Name)
				n5 += 1
			end
		end

		for _, child in ipairs(Workspace:GetChildren()) do
			if child:IsA("Model") then
				fn31(child)
			end
		end

		for _, v2 in ipairs({ "Debree", "Humanoids", "NPCs" }) do
			local v3 = Workspace:FindFirstChild(v2)

			if v3 then
				for _, descendant in ipairs(v3:GetDescendants()) do
					if descendant:IsA("Model") then
						fn31(descendant)
					end
				end
			end
		end

		table.sort(tbl11)

		if arg and arg.Refresh then
			pcall(function()
				arg:Refresh(tbl11)
			end)
		elseif arg and arg.SetValues then
			pcall(function()
				arg:SetValues(tbl11)
			end)
		end

		return #tbl11
	end
end

GetPlayerReputation = function()
	local n5 = 0

	pcall(function()
		local v2 = require(ReplicatedStorage.CAM.Global.Utility).GetData(localPlayer, true)

		if v2 and v2:FindFirstChild("Reputation") then
			n5 = tonumber(v2.Reputation.Value) or 0
		end
	end)

	if n5 == 0 then
		pcall(function()
			local v2 = fn2()

			if v2 and v2:FindFirstChild("Reputation") then
				n5 = tonumber(v2.Reputation.Value) or 0
			end
		end)
	end

	return n5
end

GetMuzanQuestProgress = function()
	local tbl9 = {
		Status = "None",
		Lilies = 0,
		RequiredLilies = 9,
		HigoshimaDelivered = false,
		HasBell = false,
		HasBlood = false,
	}

	pcall(function()
		local v2 = require(ReplicatedStorage.CAM.Global.Utility).GetData(localPlayer, true)
		local backpack = localPlayer:FindFirstChild("Backpack")
		local character = localPlayer.Character

		if backpack and backpack:FindFirstChild("Biwa Bell") or character and character:FindFirstChild("Biwa Bell") then
			tbl9.HasBell = true
		end

		if backpack and backpack:FindFirstChild("Muzan's Blood") or character and character:FindFirstChild("Muzan's Blood") then
			tbl9.HasBlood = true
		end

		if v2 and v2:FindFirstChild("Inventory") then
			local inventory = v2.Inventory:FindFirstChild("Inventory") or v2.Inventory

			if inventory:FindFirstChild("Biwa Bell") then
				tbl9.HasBell = true
			end

			if inventory:FindFirstChild("Muzan's Blood") then
				tbl9.HasBlood = true
			end

			local spiderLily = inventory:FindFirstChild("Spider Lily") or inventory:FindFirstChild("Red Spider Lily") or inventory:FindFirstChild("SpiderLily")

			if spiderLily then
				local amount = spiderLily:FindFirstChild("Amount") or spiderLily:FindFirstChild("Quantity") or spiderLily:FindFirstChild("Count")

				if amount then
					tbl9.Lilies = tonumber(amount.Value) or 1
				else
					tbl9.Lilies = tonumber(spiderLily.Value) or 1
				end
			end
		end

		if backpack then
			local lilies = 0

			for _, child in ipairs(backpack:GetChildren()) do
				if child.Name:lower():find("lily") or child.Name:lower():find("spider") then
					lilies += 1
				end
			end

			if tbl9.Lilies < lilies then
				tbl9.Lilies = lilies
			end
		end

		if v2 and v2:FindFirstChild("Quests") then
			local holder = v2.Quests:FindFirstChild("Holder")

			if holder then
				holder = holder:FindFirstChild("Muzan Quest") or holder:FindFirstChild("Muzan")
			end

			if holder then
				tbl9.Status = "Doing"
				local tasks = holder:FindFirstChild("Tasks") or holder
				local deliverDrHigoshima = tasks:FindFirstChild("Deliver Dr. Higoshima") or tasks:FindFirstChild("Higoshima")

				if deliverDrHigoshima then
					if deliverDrHigoshima:FindFirstChild("Completed") and deliverDrHigoshima.Completed.Value == true then
						tbl9.HigoshimaDelivered = true
					elseif tonumber(deliverDrHigoshima.Value) and tonumber(deliverDrHigoshima.Value) >= 1 then
						tbl9.HigoshimaDelivered = true
					end
				end

				local spiderLilies = tasks:FindFirstChild("Spider Lilies") or tasks:FindFirstChild("Lilies")

				if spiderLilies then
					local lilies = tonumber(spiderLilies.Value) or 0

					if tbl9.Lilies < lilies then
						tbl9.Lilies = lilies
					end
				end
			else
				local completed = v2.Quests:FindFirstChild("Completed")

				if completed and (completed:FindFirstChild("Muzan Quest") or completed:FindFirstChild("Muzan")) then
					tbl9.Status = "Completed"
				end
			end
		end

		if localPlayer:GetAttribute("HigoshimaDeliverTo") ~= nil then
			tbl9.Status = "Doing"
		end
	end)

	return tbl9
end

CheckDemonRequirements = function()
	local v2 = fn25()
	local v3 = fn26()
	local v4 = GetPlayerReputation()
	local clockTime = game:GetService("Lighting").ClockTime
	local flag = clockTime >= 18 or clockTime <= 6
	local flag2 = v2 == "Demon" or v2 == "Hybrid"
	local flag3 = v2 == "Human"
	local flag4 = v3 >= 15
	local flag5 = v4 <= -40
	local v5 = GetMuzanQuestProgress()
	local v6 = flag3 and flag4 and flag5
	local str

	if flag2 then
		str = "ALREADY DEMON (" .. v2 .. ")"
	elseif v5.HasBlood then
		str = "READY TO TRANSFORM (Drink Muzan's Blood)"
	elseif v5.Status == "Doing" then
		if v5.Lilies >= 9 and v5.HigoshimaDelivered then
			str = "QUEST READY TO TURN IN (Talk to Muzan)"
		else
			str = string.format("QUEST IN PROGRESS (%d/9 Lilies | Higoshima: %s)", v5.Lilies, v5.HigoshimaDelivered and "DONE" or "PENDING")
		end
	elseif not flag3 then
		str = "INVALID RACE (Requires Human, Current: " .. v2 .. ")"
	elseif not flag4 then
		str = string.format("FAIL: LEVEL %d/15 (Need %d more levels)", v3, 15 - v3)
	elseif not flag5 then
		str = string.format("FAIL: REPUTATION %d/-40 (Need %d more evil karma)", v4, v4 - -40)
	elseif not flag then
		str = string.format("WAITING FOR NIGHT (Clock: %.1f, Muzan spawns at 18:00)", clockTime)
	else
		str = "ELIGIBLE (Ready to Speak with Muzan!)"
	end

	return {
		Race = v2,
		IsHuman = flag3,
		IsDemonOrHybrid = flag2,
		Level = v3,
		RequiredLevel = 15,
		LevelPass = flag4,
		Reputation = v4,
		RequiredReputation = -40,
		ReputationPass = flag5,
		ClockTime = clockTime,
		IsNight = flag,
		Quest = v5,
		CanBecomeDemon = v6,
		Summary = str,
	}
end

TeleportToMuzan = function()
	if not fn8() then
		return false
	end
	local v2 = nil
	local position = nil

	local function fn31(arg)
		if not arg or not arg:IsA("Model") then
			return
		end

		if string.lower(arg.Name):find("muzan") then
			local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart") or arg:FindFirstChild("Torso") or arg.PrimaryPart

			if humanoidRootPart then
				v2 = arg
				position = humanoidRootPart.Position
			end
		end
	end

	for _, child in ipairs(Workspace:GetChildren()) do
		fn31(child)
	end

	local debree = Workspace:FindFirstChild("Debree")

	if debree then
		local muzanLairModel = debree:FindFirstChild("MuzanLairModel")

		if muzanLairModel then
			fn31(muzanLairModel)
		end

		for _, child in ipairs(debree:GetChildren()) do
			local stationaryNpcs = child:FindFirstChild("StationaryNpcs")
			local activeNpcs = child:FindFirstChild("ActiveNpcs")

			if stationaryNpcs then
				for _, child2 in ipairs(stationaryNpcs:GetChildren()) do
					fn31(child2)
				end
			end

			if activeNpcs then
				for _, child2 in ipairs(activeNpcs:GetChildren()) do
					fn31(child2)
				end
			end
		end
	end

	if not position then
		for _, v3 in ipairs({
			Vector3.new(2466.3, 1079.3, 2334.5),
			Vector3.new(-125, 315, -1450),
			Vector3.new(710, 1140, -2560),
			Vector3.new(-820, 420, 380),
			Vector3.new(-1540, 340, -1120),
		}) do
			for _, descendant in ipairs(Workspace:GetDescendants()) do
				if descendant:IsA("Model") and descendant.Name:lower():find("muzan") and (descendant:GetPivot().Position - v3).Magnitude < 60 then
					v2 = descendant
					position = descendant:GetPivot().Position
					break
				end
			end

			if not position then
				continue
			end
			break
		end

		position = position or Vector3.new(2466.3, 1079.3, 2334.5)
	end

	fn24(position + Vector3.new(0, 2.5, 0), "Muzan Kibutsuji")
	fn("Teleport", "Teleported to Muzan Kibutsuji!", 3.5)
	return true
end

TeleportToDrHigoshima = function()
	fn24(Vector3.new(1451.5, 1245.5, -220) + Vector3.new(0, 2.5, 0), "Dr. Higoshima Spawn")
	fn("Teleport", "Teleported to Dr. Higoshima spawn location!", 3.5)
end

TeleportToHigoshimaSafezone = function()
	fn24(Vector3.new(-1159.57, 1195.05, -1008.91) + Vector3.new(0, 2.5, 0), "Dr. Higoshima Safe Zone")
	fn("Teleport", "Teleported to Dr. Higoshima delivery Safe Zone!", 3.5)
end

TeleportKiribatingCivilians = function()
	fn24(Vector3.new(-531, 1248, -1186) + Vector3.new(0, 2.5, 0), "Kiribating Village Civilians")
	fn("Teleport", "Teleported to Kiribating Village (Evil Karma Spot)!", 3.5)
end

TeleportButterflyGardenLilies = function()
	fn24(Vector3.new(-1480, 1198, -1350) + Vector3.new(0, 2.5, 0), "Butterfly Garden (Lily Spot)")
	fn("Teleport", "Teleported to Butterfly Garden Spider Lily spot!", 3.5)
end

TeleportBambooPondLilies = function()
	fn24(Vector3.new(-320, 1105, -1640) + Vector3.new(0, 2.5, 0), "Bamboo Pond (Lily Spot)")
	fn("Teleport", "Teleported to Bamboo Pond Spider Lily spot!", 3.5)
end

FindSpiderLiliesInWorld = function()
	local tbl9 = {}
	local tbl10 = {}

	local function fn31(arg)
		if not arg or not arg:IsA("Model") or tbl10[arg] then
			return
		end
		local str = arg.Name:lower()

		if str:find("lily") or str:find("spider") or str:find("flower") then
			local rootPart = arg:FindFirstChild("RootPart") or arg.PrimaryPart or arg:FindFirstChildWhichIsA("BasePart")
			local proximityPrompt = arg:FindFirstChildWhichIsA("ProximityPrompt", true)

			if rootPart then
				tbl10[arg] = true
				table.insert(tbl9, { Model = arg, Root = rootPart, Prompt = proximityPrompt, Pos = rootPart.Position })
			end
		end
	end

	local debree = Workspace:FindFirstChild("Debree")

	if debree then
		for _, child in ipairs(debree:GetChildren()) do
			fn31(child)
		end
	end

	for _, child in ipairs(Workspace:GetChildren()) do
		fn31(child)
	end

	return tbl9
end

CollectSpiderLily = function(arg)
	if not arg or not arg.Root then
		return false
	end
	local v2 = fn8()
	if not v2 then
		return false
	end
	v2.CFrame = arg.Root.CFrame * CFrame.new(0, 1.5, 1.5)
	task.wait(0.2)
	local prompt = arg.Prompt or arg.Model:FindFirstChildWhichIsA("ProximityPrompt", true)

	if prompt then
		pcall(function()
			prompt.HoldDuration = 0
			prompt.RequiresLineOfSight = false
		end)

		pcall(fireproximityprompt, prompt, 1.2)

		pcall(function()
			prompt:InputHoldBegin()
			task.wait(1.15)
			prompt:InputHoldEnd()
		end)
	else
		for _, descendant in ipairs(arg.Model:GetDescendants()) do
			if descendant:IsA("BasePart") then
				firetouchinterest(v2, descendant, 0)
				task.wait(0.05)
				firetouchinterest(v2, descendant, 1)
			end
		end
	end

	task.wait(0.3)
	return true
end

TeleportClosestSpiderLily = function()
	local v2 = fn8()
	if not v2 then
		return
	end
	local v3 = FindSpiderLiliesInWorld()
	if #v3 == 0 then
		fn("Spider Lilies", "No Spider Lilies currently found nearby in Debree!", 3.5)
		return
	end
	local v4, v5, v6 = ipairs(v3)
	local huge = math.huge
	local v7 = nil

	for _, v8 in v4, v5, v6 do
		local magnitude = (v8.Pos - v2.Position).Magnitude

		if magnitude < huge then
			huge = magnitude
			v7 = v8
		end
	end

	if v7 then
		fn24(v7.Pos + Vector3.new(0, 2.5, 0), "Closest Spider Lily")
		fn("Spider Lilies", string.format("Teleported to Spider Lily (%.0f studs away)!", huge), 3)
	end
end

CollectAllSpiderLilies = function()
	local v2 = FindSpiderLiliesInWorld()

	if #v2 == 0 then
		fn("Spider Lilies", "No Spider Lilies loaded right now! Checking known spawn spots...", 3.5)

		for _, v3 in ipairs({
			Vector3.new(1233.8, 980.1, -76.5),
			Vector3.new(2696.8, 1091.8, -724.7),
			Vector3.new(955.9, 1021.4, -133.6),
			Vector3.new(-1480, 1198, -1350),
			Vector3.new(-320, 1105, -1640),
		}) do
			fn24(v3 + Vector3.new(0, 2.5, 0), "Lily Hotspot")
			task.wait(0.8)
			local v4 = FindSpiderLiliesInWorld()

			if #v4 > 0 then
				for _, v5 in ipairs(v4) do
					CollectSpiderLily(v5)
					task.wait(0.3)
				end
			end
		end

		return
	end

	fn("Spider Lilies", string.format("Collecting %d Spider Lilies...", #v2), 3)

	for _, v3 in ipairs(v2) do
		CollectSpiderLily(v3)
		task.wait(0.4)
	end

	fn("Spider Lilies", "Finished Spider Lily collection run!", 3)
end

DeliverDrHigoshima = function()
	if not fn8() then
		return
	end
	local attribute = localPlayer:GetAttribute("HigoshimaDeliverTo")

	if typeof(attribute) ~= "CFrame" then
		fn("Dr. Higoshima", "Teleporting to Dr. Higoshima spawn point...", 3)
		fn24(Vector3.new(1451.5, 1245.5, -220) + Vector3.new(0, 2.5, 0), "Dr. Higoshima Spawn")
		task.wait(1)
		local v2 = nil

		for _, descendant in ipairs(Workspace:GetDescendants()) do
			if descendant:IsA("ProximityPrompt") then
				local v3 = GetPromptPosition(descendant)
				if v3 and (v3 - Vector3.new(1451.5, 1245.5, -220)).Magnitude < 25 then
					v2 = descendant
					break
				end
			end
		end

		if v2 then
			pcall(function()
				v2.HoldDuration = 0
				v2.RequiresLineOfSight = false
			end)

			pcall(fireproximityprompt, v2, 1.2)

			pcall(function()
				v2:InputHoldBegin()
				task.wait(1)
				v2:InputHoldEnd()
			end)

			task.wait(0.8)
		end
	end

	local attribute2 = localPlayer:GetAttribute("HigoshimaDeliverTo")
	local position = typeof(attribute2) == "CFrame" and attribute2.Position
	position = position or Vector3.new(-1159.57, 1195.05, -1008.91)
	fn("Dr. Higoshima", "Delivering Dr. Higoshima to Safe Zone...", 3.5)
	fn24(position + Vector3.new(0, 2.5, 0), "Higoshima Safe Zone")
	task.wait(1.5)
	local now = os.clock()

	while localPlayer:GetAttribute("HigoshimaDeliverTo") ~= nil and os.clock() - now < 4 do
		task.wait(0.2)
	end

	fn("Dr. Higoshima", "Dr. Higoshima delivery completed!", 4)
end

TalkToMuzan = function()
	if not fn8() then
		return
	end
	local muzanLairModel = Workspace:FindFirstChild("Debree") and Workspace.Debree:FindFirstChild("MuzanLairModel") or Workspace:FindFirstChild("Muzan")
	local vector = Vector3.new(2466.3, 1079.3, 2334.5)

	if muzanLairModel then
		vector = muzanLairModel:GetPivot().Position
	end

	fn24(vector + Vector3.new(0, 2.5, 0), "Muzan Kibutsuji")
	task.wait(0.8)
	local proximityPrompt = muzanLairModel and muzanLairModel:FindFirstChildWhichIsA("ProximityPrompt", true)

	if not proximityPrompt then
		for _, descendant in ipairs(Workspace:GetDescendants()) do
			if descendant:IsA("ProximityPrompt") then
				local v2 = GetPromptPosition(descendant)
				if v2 and (v2 - vector).Magnitude < 15 then
					proximityPrompt = descendant
					break
				end
			end
		end
	end

	if proximityPrompt then
		pcall(function()
			proximityPrompt.HoldDuration = 0
			proximityPrompt.RequiresLineOfSight = false
		end)

		pcall(fireproximityprompt, proximityPrompt, 1.2)
	end

	pcall(function()
		require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent).ToServer("MuzanGiveBell")
	end)

	pcall(function()
		require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction).ToServer("AddQuest", "Muzan Quest")
	end)

	fn("Muzan Contact", "Interacted with Muzan! Requested Biwa Bell & Questline.", 4)
end

DrinkMuzansBlood = function()
	local character = localPlayer.Character
	local backpack = localPlayer:FindFirstChild("Backpack")
	if not character then
		return false
	end
	local v2 = fn25()
	if v2 == "Demon" or v2 == "Hybrid" then
		fn("Demon Transformation", "You are ALREADY a " .. v2 .. "!", 4)
		return true
	end

	if (localPlayer:GetAttribute("InCombat") or localPlayer:GetAttribute("in_combat")) == true then
		fn("Demon Transformation", "Cannot transform while in combat! Backing off...", 4)
		return false
	end
	local muzanSBlood = character:FindFirstChild("Muzan's Blood") or backpack and backpack:FindFirstChild("Muzan's Blood")
	if not muzanSBlood then
		fn("Demon Transformation", "Muzan's Blood not found in Inventory or Backpack!", 4)
		return false
	end

	if muzanSBlood.Parent ~= character then
		muzanSBlood.Parent = character
		task.wait(0.3)
	end

	fn("Demon Transformation", "Drinking Muzan's Blood! Transforming into Demon...", 6)

	pcall(function()
		muzanSBlood:Activate()
	end)

	task.wait(1.5)

	pcall(function()
		local VirtualInputManager2 = game:GetService("VirtualInputManager")
		VirtualInputManager2:SendMouseButtonEvent(600, 400, 0, true, game, 0)
		task.wait(0.05)
		VirtualInputManager2:SendMouseButtonEvent(600, 400, 0, false, game, 0)
	end)

	task.wait(6)
	local v3 = fn25()

	if v3 == "Demon" or v3 == "Hybrid" then
		fn("SUCCESS!", "Congratulations! You have awakened as a DEMON!", 8)

		if slayersSyneroxHub.Webhook and slayersSyneroxHub.Webhook.Enabled then
			SendWebhookEmbed("Demon Awakened!", localPlayer.DisplayName .. " has successfully transformed into a Demon!", 16711680)
		end

		return true
	end

	return false
end

local flag = false

StepFarmEvilKarma = function()
	if flag then
		return
	end
	local v2 = GetPlayerReputation()

	if v2 <= -40 then
		if slayersSyneroxHub.Activities and slayersSyneroxHub.Activities.AutoFarmEvilKarma then
			slayersSyneroxHub.Activities.AutoFarmEvilKarma = false
			fn("Karma Farm", "Evil Reputation goal reached (" .. v2 .. " <= -40)! Stopped civilian farm.", 5)
		end

		return
	end

	flag = true
	local v3 = fn8()
	local character = localPlayer.Character
	if not v3 or not character then
		flag = false
		return
	end

	if (v3.Position - Vector3.new(-531, 1248, -1186)).Magnitude > 200 then
		fn24(Vector3.new(-531, 1248, -1186) + Vector3.new(0, 3, 0), "Kiribating Village (Civilians)")
		task.wait(1.2)
		v3 = fn8()
	end

	local tbl9 = nil

	for _, descendant in ipairs(Workspace:GetDescendants()) do
		local isModel = descendant:IsA("Model")
		local pos

		if isModel then
			pos = descendant.Name:lower():find("civilian") or descendant.Name:lower():find("slayer")
		else
			pos = isModel
		end

		if pos then
			local humanoidRootPart = descendant:FindFirstChild("HumanoidRootPart") or descendant.PrimaryPart
			local humanoid = descendant:FindFirstChildOfClass("Humanoid")

			if humanoidRootPart and humanoid and humanoid.Health > 0 then
				tbl9 = { Model = descendant, Root = humanoidRootPart, Humanoid = humanoid }
				break
			else
				tbl9 = nil
			end
		else
			tbl9 = nil
		end
	end

	if not tbl9 then
		fn22(v3.CFrame)
		task.wait(0.5)
		flag = false
		return
	end

	if character:FindFirstChild("Weapon_Unequipped_Config") then
		local VirtualInputManager2 = game:GetService("VirtualInputManager")
		VirtualInputManager2:SendKeyEvent(true, Enum.KeyCode.One, false, game)
		task.wait(0.05)
		VirtualInputManager2:SendKeyEvent(false, Enum.KeyCode.One, false, game)
		task.wait(0.2)
	end

	local cframe = CFrame.lookAt(tbl9.Root.Position + Vector3.new(0, 2.8, 0), tbl9.Root.Position)
	v3.CFrame = cframe
	v3.AssemblyLinearVelocity = Vector3.zero
	v3.AssemblyAngularVelocity = Vector3.zero
	fn22(cframe)
	fn13(3)
	flag = false
end

local flag2 = false

RunAutoBecomeDemon = function()
	if flag2 then
		return
	end
	flag2 = true
	local v2 = CheckDemonRequirements()

	if v2.IsDemonOrHybrid then
		if slayersSyneroxHub.Activities then
			slayersSyneroxHub.Activities.AutoBecomeDemon = false
		end

		fn("Demon Progression", "You are already a " .. v2.Race .. "! Progression complete.", 5)
		flag2 = false
		return
	end

	if not v2.LevelPass then
		if slayersSyneroxHub.Activities then
			slayersSyneroxHub.Activities.AutoBecomeDemon = false
		end

		fn("Demon Progression", string.format("Level 15+ Required! (Current: %d / 15). Level up first!", v2.Level), 6)
		flag2 = false
		return
	end

	if v2.Quest.HasBlood then
		fn("Demon Progression", "Muzan's Blood found! Initiating transformation...", 5)
		DrinkMuzansBlood()
		flag2 = false
		return
	end

	if not v2.ReputationPass then
		fn("Demon Progression", string.format("Evil Karma Required (Current: %d / -40). Defeating Civilians...", v2.Reputation), 4)
		StepFarmEvilKarma()
		flag2 = false
		return
	end

	if not v2.IsNight then
		if v2.Quest.Lilies < 9 then
			fn("Demon Progression", "Daytime active (Muzan spawns at night 18:00). Pre-collecting Spider Lilies...", 4)
			CollectAllSpiderLilies()
		else
			fn("Demon Progression", string.format("Waiting for nightfall... (Clock: %.1f, Muzan spawns at 18:00)", v2.ClockTime), 4)
		end

		flag2 = false
		return
	end

	if v2.Quest.Status == "None" then
		fn("Demon Progression", "Nightfall active! Teleporting to Muzan to accept quest...", 4)
		TalkToMuzan()
		task.wait(1.5)
		flag2 = false
		return
	end

	if v2.Quest.Status == "Doing" then
		if v2.Quest.Lilies < 9 then
			fn("Demon Progression", string.format("Gathering Spider Lilies (%d/9)...", v2.Quest.Lilies), 4)
			CollectAllSpiderLilies()
			flag2 = false
			return
		end

		if not v2.Quest.HigoshimaDelivered then
			fn("Demon Progression", "Delivering Dr. Higoshima...", 4)
			DeliverDrHigoshima()
			task.wait(1.5)
			flag2 = false
			return
		end

		fn("Demon Progression", "All quest tasks complete! Returning to Muzan for blood reward...", 4)
		TalkToMuzan()
		task.wait(2)

		if GetMuzanQuestProgress().HasBlood then
			DrinkMuzansBlood()
		end

		flag2 = false
		return
	end

	flag2 = false
end

local tbl9, tbl10, tbl11, tbl12, v2, v3, CurrentClanLabel, TotalSpinsLabel, LastRollLabel, fn31
local AutoSpinToggle, fn32, fn33, tbl13, v4, v5, CurrentBDALabel, TotalBDASpinsLabel, bdaRaceLabel, LastBDARollLabel
local fn34, AutoBDAToggle, fn35, fn36, v6, AutoQuestToggle, v7, fn37, AutoFarmToggle

do
	local tbl14 = {
		"All Normal Mobs",
		"Kanoe Demon Slayer",
		"Mizunoe Demon Slayer",
		"Mizunoto",
		"Civilian",
		"*Civilian*",
		"Bandit",
		"KaruVillageBandit",
		"Spy",
		"VillageSpy",
		"Bear Cub",
		"Mother Bear",
		"Kaiden",
		"Kaiden Subordinate",
		"Hoyuzo",
		"Hoyuzo Subordinate",
		"High Demon",
		"LesserDemon",
		"RogueDemon",
		"Lost",
		"Beast Born Demon",
		"BloodHoundedDemon_MistfallHarbor",
		"GreaterDemon_ButterflyEstate",
		"LesserDemon_ButterflyEstate",
		"Fire Profound Demon",
		"Ice Profound Demon",
		"Grove Raider",
		"Raid Captain",
		"Cache Prowler",
		"Prowler Captain",
		"Cache Lancer",
		"Lancer Captain",
		"Kanoe Demon Slayer",
		"IceveilRoadBandit",
		"IceveilRoadMarauder",
		"IceveilRoadPikeman",
		"Flame Trainee",
		"Water Trainee",
		"Thunder Trainee",
		"Wind Trainee",
		"Sound Trainee",
		"Stone Trainee",
		"Serpent Trainee",
		"Insect Trainee",
		"Tai Chi Trainee",
		"Soryu Trainee",
		"Reaper Trainee",
	}

	local tbl15 = {
		"All Bosses",
		"YetiDemon",
		"SmallYeti",
		"HandDemon",
		"Hoyuzo",
		"Kaiden",
		"Zuko",
		"Saneri",
		"Obari",
		"Shinora",
		"Giyen",
		"Tengai (Tengen)",
		"Tengai",
		"Tengen",
		"Zentaro",
		"Gyorei",
		"Rengu",
		"Gyutai",
		"Datai",
		"Reaper",
		"Akazo",
		"Domae",
		"Nezura",
		"Yahari",
		"Sumari",
		"Enru",
		"Flame Trainee",
		"Water Trainee",
		"Water Trainee Sabito",
		"Thunder Trainee",
		"Wind Trainee",
		"Sound Trainee",
		"Stone Trainee",
		"Serpent Trainee",
		"Insect Trainee",
		"Tai Chi Trainee",
		"Tai Chi Trainee Suzume",
		"Soryu Trainee",
		"Soryu Trainee Goki",
		"Reaper Trainee",
		"Reaper Trainee Kuzan",
	}

	local tbl16 = {
		"All",
		"Bamboo Grove",
		"Windy Peak",
		"Iceveil Valley",
		"Mistfall Harbor",
		"Hidden Mist Village",
		"Butterfly Estate",
		"Final Selection Plains",
		"Misc",
		"Temporary",
	}

	local tbl17 = {}

	for _, v8 in ipairs(tbl15) do
		if v8 ~= "All Bosses" then
			tbl17[string.lower(v8)] = true
			tbl17[string.lower(string.gsub(v8, "%s+", ""))] = true
		end
	end

	local function fn38()
		local tbl18 = { "All Players" }

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer then
				table.insert(tbl18, player.Name)
			end
		end

		return tbl18
	end

	tbl9 = { "Auto Best Quest (By Level)" }

	for _, v8 in ipairs(tbl4) do
		table.insert(tbl9, v8.DisplayName)
	end

	table.insert(tbl9, "Kasugai Crow: Urgent Dispatch")
	table.insert(tbl9, "Grandpa Somi: Rescue Mission")
	table.insert(tbl9, "Beth: Lost Daughter Search")
	table.insert(tbl9, "Sabito: Boulder Split Trial")
	table.insert(tbl9, "Final Selection: Examination Trial")
	table.insert(tbl9, "Demon Raid: Hashira Scout")

	tbl10 = {
		{
			Name = "Water Trainer Urokodaki",
			DisplayName = "Water Breathing (Urokodaki)",
			Position = Vector3.new(667.2, 1022.7, -228.2),
			Style = "Water Breathing",
			Region = "Bamboo Grove / Mistfall",
		},
		{
			Name = "Thunder Trainer Zentaro",
			DisplayName = "Thunder Breathing (Zentaro)",
			Position = Vector3.new(1970.2, 1660, -609.8),
			Style = "Thunder Breathing",
			Region = "Verdant Cliffs (High Mountain)",
		},
		{
			Name = "Flame Trainer Rengu",
			DisplayName = "Flame Breathing (Rengu)",
			Position = Vector3.new(-967.6, 1028.7, 1188.2),
			Style = "Flame Breathing",
			Region = "Forgotten Ruins",
		},
		{
			Name = "Wind Trainer Saneri",
			DisplayName = "Wind Breathing (Saneri)",
			Position = Vector3.new(-275.6, 1187.5, -3436.7),
			Style = "Wind Breathing",
			Region = "Iceveil Mountain / Windy Pass",
		},
		{
			Name = "Stone Trainer Gyorei",
			DisplayName = "Stone Breathing (Gyorei)",
			Position = Vector3.new(2578.6, 1095.8, -828.4),
			Style = "Stone Breathing",
			Region = "Stone Sanctuary",
		},
		{
			Name = "Insect Trainer Shinora",
			DisplayName = "Insect Breathing (Shinora)",
			Position = Vector3.new(-1798.9, 347.9, -189.3),
			Style = "Insect Breathing",
			Region = "Butterfly Estate",
		},
		{
			Name = "Serpent Trainer Obari",
			DisplayName = "Serpent Breathing (Obari)",
			Position = Vector3.new(37, 1311.2, -1179.5),
			Style = "Serpent Breathing",
			Region = "Windy Peak Cave",
		},
		{
			Name = "Sound Trainer Tengai",
			DisplayName = "Sound Breathing (Tengai)",
			Position = Vector3.new(464.9, 1491.1, -3272.8),
			Style = "Sound Breathing",
			Region = "Iceveil Peak",
		},
		{
			Name = "Soryu Expert Kazuma",
			DisplayName = "Soryu Martial Arts (Kazuma)",
			Position = Vector3.new(-769.5, 909.4, 303.3),
			Style = "Soryu (Fist Combat)",
			Region = "Mistfall Harbor Outskirts",
		},
		{
			Name = "Tai Chi Expert Renjiro",
			DisplayName = "Tai Chi Martial Arts (Renjiro)",
			Position = Vector3.new(1883.1, 686.6, -761.1),
			Style = "Tai Chi (Combat)",
			Region = "Hidden Mist Outskirts",
		},
		{
			Name = "Harvester of Souls Zurinyz",
			DisplayName = "Reaper / Dark Style (Zurinyz)",
			Position = Vector3.new(-1212.6, 1387.4, -2371.6),
			Style = "Soul Harvester / Reaper",
			Region = "Iceveil Hollow",
		},
	}

	tbl11 = {}

	for _, v8 in ipairs(tbl10) do
		table.insert(tbl11, v8.DisplayName)
	end

	tbl12 = {
		"Kamado",
		"Rengoku",
		"Soyama",
		"Uzui",
		"Agatsuma",
		"Douma",
		"Himejima",
		"Iguro",
		"Shinazugawa",
		"Tamayo",
		"Kocho",
		"Shabana",
		"Tomioka",
		"Ubuyashiki",
		"Makomo",
		"Sabito",
		"Susumaru",
		"Urokodaki",
		"Yahaba",
		"Aori",
		"Aoshima",
		"Kaneki",
		"Kurotsume",
		"Yamagiri",
		"Ando",
		"Aokawa",
		"Fujiwara",
		"Fukukoshi",
		"Hagiwara",
		"Hozumi",
		"Kanzaki",
		"Kazetani",
		"Kuroaki",
		"Kurosaki",
		"Mori",
		"Saito",
		"Sakurai",
		"Suzuki",
		"Toka",
		"Tsukino",
		"Yukimori",
	}

	v2 = fn3()
	v3 = fn4()
	CurrentClanLabel = nil
	TotalSpinsLabel = nil
	LastRollLabel = nil

	fn31 = function()
		pcall(function()
			local v8 = fn3()
			local v9 = fn4()

			if CurrentClanLabel then
				CurrentClanLabel:SetText("Current Clan: " .. tostring(v8))
			end

			if TotalSpinsLabel then
				TotalSpinsLabel:SetText("Spins Left: " .. tostring(v9))
			end
		end)
	end

	pcall(function()
		local v8 = fn2()

		if v8 then
			local clan = v8:FindFirstChild("Clan")
			local spinning = v8:FindFirstChild("Spinning")

			if clan then
				table.insert(slayersSyneroxHub.Connections, clan:GetPropertyChangedSignal("Value"):Connect(fn31))
			end

			if spinning then
				local freeClanSpins = spinning:FindFirstChild("FreeClanSpins")
				local spins = spinning:FindFirstChild("Spins")

				if freeClanSpins then
					table.insert(slayersSyneroxHub.Connections, freeClanSpins:GetPropertyChangedSignal("Value"):Connect(fn31))
				end

				if spins then
					table.insert(slayersSyneroxHub.Connections, spins:GetPropertyChangedSignal("Value"):Connect(fn31))
				end
			end
		end
	end)

	local thread = nil
	AutoSpinToggle = nil

	fn32 = function(arg)
		slayersSyneroxHub.Spin.AutoSpin = false

		if arg and AutoSpinToggle then
			SyncToggle(AutoSpinToggle, false)
		end

		if thread and coroutine.running() ~= thread then
			pcall(task.cancel, thread)
			thread = nil
		end
	end

	fn33 = function()
		if thread and coroutine.running() ~= thread then
			pcall(task.cancel, thread)
			thread = nil
		end

		slayersSyneroxHub.Spin.AutoSpin = true

		thread = task.spawn(function()
			while true do
				if slayersSyneroxHub.Spin.AutoSpin and slayersSyneroxHub.Alive then
					if fn4() <= 0 then
						fn32(true)
						fn({ Title = "Auto Spin", Content = "No spins available!", Type = "warning" })
						break
					else
						local now = os.clock()

						while localPlayer:GetAttribute("PendingClanSpin") ~= nil and os.clock() - now < 1.5 do
							task.wait(0.02)
						end

						local ok, lastResult = pcall(function()
							return SignalFunction.ToServer("ClanSpin")
						end)

						local wait, delay

						if ok and typeof(lastResult) == "string" then
							pcall(function()
								SignalEvent.ToServer("ClanSpinComplete")
							end)

							local now2 = os.clock()

							while localPlayer:GetAttribute("PendingClanSpin") ~= nil and os.clock() - now2 < 0.5 do
								task.wait(0.02)
							end

							slayersSyneroxHub.Spin.LastResult = lastResult
							local rarity = Clans and Clans.TierOf(lastResult)
							local name = rarity and rarity.name or "Common"
							rarity = rarity and rarity.rarity or 1

							pcall(function()
								if LastRollLabel then
									LastRollLabel:SetText("Last Rolled: " .. lastResult .. " (" .. name .. ")")
								end
							end)

							fn31()

							pcall(function()
								if slayersSyneroxHub.Webhook and slayersSyneroxHub.Webhook.Enabled and slayersSyneroxHub.Webhook.ClanRerollNotify then
									local v8, v9 = GetClanRarity(lastResult)
									local rerollMinRarity = slayersSyneroxHub.Webhook.RerollMinRarity or "Rare+"
									local flag3

									if rerollMinRarity == "All Rolls" then
										flag3 = true
									elseif rerollMinRarity == "Rare+" then
										flag3 = v8 == "Rare" or v8 == "Legendary" or v8 == "Mythic" or v8 == "Supreme"
									elseif rerollMinRarity == "Legendary+" then
										flag3 = v8 == "Legendary" or v8 == "Mythic" or v8 == "Supreme"
									elseif rerollMinRarity == "Supreme Only" then
										flag3 = v8 == "Supreme"
									else
										flag3 = false

										if rerollMinRarity == "Desired Only" then
											flag3 = stop == true
										end
									end

									if flag3 then
										local v10 = SendWebhookEmbed
										local str = "Clan Rerolled: " .. tostring(lastResult)
										local str2 = string.format("**%s** just rolled clan **%s** (%s)!", localPlayer.DisplayName, tostring(lastResult), v8)
										local tbl18 = {}
										local tbl19 = { name = "Clan", value = "**" .. tostring(lastResult) .. "**", inline = true }
										local tbl20 = { name = "Rarity", value = v8, inline = true }
										local tbl21 = { name = "Spins Remaining", value = tostring(fn4()), inline = true }
										local tbl22 = { name = "Target Match", value = stop == true and "YES" or "NO", inline = true }
										tbl18[1] = tbl19
										tbl18[2] = tbl20
										tbl18[3] = tbl21
										tbl18[4] = tbl22
										v10(str, str2, v9, tbl18)
									end
								end
							end)

							local flag3

							if slayersSyneroxHub.Spin.Mode == "Specific Clan" then
								local flag4 = string.lower(lastResult) == string.lower(tostring(slayersSyneroxHub.Spin.TargetClan or ""))
								flag3 = false

								if flag4 then
									flag3 = true
								end
							elseif slayersSyneroxHub.Spin.StopRarity == "Supreme Only" and rarity >= 7 then
								flag3 = true
							elseif slayersSyneroxHub.Spin.StopRarity == "Legendary+" and rarity >= 5 then
								flag3 = true
							else
								flag3 = false

								if rarity >= 6 then
									flag3 = true
								end
							end

							if flag3 then
								fn32(true)

								fn({
									Title = "Auto Spin Completed!",
									Content = "Rolled: " .. lastResult .. " [" .. name .. "]",
									Type = "success",
									Duration = 8,
								})

								break
							else
								wait = task.wait
								delay = slayersSyneroxHub.Spin.Delay or 0.15
								wait(delay)
								continue
							end
						else
							pcall(function()
								SignalEvent.ToServer("ClanSpinComplete")
							end)

							task.wait(0.15)
							wait = task.wait
							delay = slayersSyneroxHub.Spin.Delay or 0.15
							wait(delay)
							continue
						end
					end
				end

				break
			end

			thread = nil
		end)
	end

	tbl13 = {
		"Arrow",
		"Blood Manipulation",
		"Cryokinesis",
		"Dream",
		"Obi Manipulation",
		"Pyrokenesis",
		"Reaper",
		"Shockwave",
		"Tamari",
	}

	v4 = fn5()
	v5 = fn6()
	CurrentBDALabel = nil
	TotalBDASpinsLabel = nil
	bdaRaceLabel = nil
	LastBDARollLabel = nil

	fn34 = function()
		pcall(function()
			local v8 = fn5()
			local v9 = fn6()
			local v10 = fn25()

			if CurrentBDALabel then
				CurrentBDALabel:SetText("Current BDA: " .. tostring(v8))
			end

			if TotalBDASpinsLabel then
				TotalBDASpinsLabel:SetText("BDA Spins: " .. tostring(v9) .. " (" .. tostring(math.floor(v9 / 3)) .. " Rolls Left)")
			end

			if bdaRaceLabel then
				bdaRaceLabel:SetText("Player Race: " .. tostring(v10))
			end
		end)
	end

	pcall(function()
		local v8 = fn2()

		if v8 then
			local powers = v8:FindFirstChild("Powers")
			powers = powers and powers:FindFirstChild("DemonArt")
			local spinning = v8:FindFirstChild("Spinning")
			spinning = spinning and spinning:FindFirstChild("FreeOtherSpins")
			local race = v8:FindFirstChild("Race")

			if powers then
				table.insert(slayersSyneroxHub.Connections, powers:GetPropertyChangedSignal("Value"):Connect(fn34))
			end

			if spinning then
				table.insert(slayersSyneroxHub.Connections, spinning:GetPropertyChangedSignal("Value"):Connect(fn34))
			end

			if race then
				table.insert(slayersSyneroxHub.Connections, race:GetPropertyChangedSignal("Value"):Connect(fn34))
			end
		end
	end)

	task.spawn(function()
		while slayersSyneroxHub.Alive do
			task.wait(2.5)

			pcall(function()
				if fn34 then
					fn34()
				end

				if fn31 then
					fn31()
				end
			end)
		end
	end)

	local thread2 = nil
	AutoBDAToggle = nil

	fn35 = function(arg)
		slayersSyneroxHub.Spin.BDA.AutoSpin = false

		if arg and AutoBDAToggle then
			SyncToggle(AutoBDAToggle, false)
		end

		if thread2 and coroutine.running() ~= thread2 then
			pcall(task.cancel, thread2)
			thread2 = nil
		end
	end

	fn36 = function()
		if thread2 and coroutine.running() ~= thread2 then
			pcall(task.cancel, thread2)
			thread2 = nil
		end

		local v8 = fn25()

		if v8 ~= "Demon" and v8 ~= "Hybrid" then
			fn35(true)
			fn("Auto BDA Spin", "Requires Demon or Hybrid race! Current: " .. tostring(v8) .. ". Become Demon first!", 5)
			return
		end

		local v9 = fn6()

		if v9 < 3 then
			fn35(true)
			fn("Auto BDA Spin", "Need at least 3 spins per roll! (You have: " .. tostring(v9) .. ")", 4)
			return
		end

		slayersSyneroxHub.Spin.BDA.AutoSpin = true

		thread2 = task.spawn(function()
			local n5 = 0

			while true do
				if slayersSyneroxHub.Spin.BDA.AutoSpin and slayersSyneroxHub.Alive then
					local v10 = fn6()

					if v10 < 3 then
						fn35(true)
						fn("Auto BDA Spin", "Out of BDA spins! (Need 3 per roll, you have " .. tostring(v10) .. ")", 4)
						break
					else
						local v11 = fn25()

						if v11 ~= "Demon" and v11 ~= "Hybrid" then
							fn35(true)
							fn("Auto BDA Spin", "Demon Art spins require Demon or Hybrid race! Current: " .. tostring(v11), 5)
							break
						else
							local now = os.clock()

							while localPlayer:GetAttribute("PendingEvilArtSpin") ~= nil and os.clock() - now < 1.5 do
								task.wait(0.02)
							end

							local ok, lastRolled = pcall(function()
								return SignalFunction.ToServer("EvilArtSpin")
							end)

							local wait, delay, n6

							if ok and typeof(lastRolled) == "string" then
								pcall(function()
									SignalEvent.ToServer("EvilArtSpinComplete")
								end)

								local now2 = os.clock()

								while localPlayer:GetAttribute("PendingEvilArtSpin") ~= nil and os.clock() - now2 < 0.5 do
									task.wait(0.02)
								end

								slayersSyneroxHub.Spin.BDA.LastResult = lastRolled

								pcall(function()
									if LastBDARollLabel then
										LastBDARollLabel:SetText("Last Rolled: " .. lastRolled)
									end
								end)

								fn34()
								local str = tostring(slayersSyneroxHub.Spin.BDA.TargetBDA or "")
								local flag3

								if str ~= "" and str ~= "All" then
									flag3 = false

									if string.lower(lastRolled) == string.lower(str) then
										flag3 = true
									end
								else
									flag3 = true
								end

								n5 = 0

								if flag3 then
									fn35(true)
									fn("BDA Spin Completed!", "Rolled desired BDA: " .. lastRolled, 6)
									break
								else
									wait = task.wait
									delay = slayersSyneroxHub.Spin.BDA.Delay
									n6 = delay or 0.15
									wait(n6)
									continue
								end
							else
								n5 += 1

								pcall(function()
									SignalEvent.ToServer("EvilArtSpinComplete")
								end)

								if n5 >= 3 then
									fn35(true)
									fn("Auto BDA Spin Stopped", "Server rejected spin 3 times. Check race and spins.", 5)
									break
								else
									task.wait(0.3)
									wait = task.wait
									delay = slayersSyneroxHub.Spin.BDA.Delay
									n6 = delay or 0.15
									wait(n6)
									continue
								end
							end
						end
					end
				end

				break
			end

			thread2 = nil
		end)
	end

	v6 = v:CreateWindow({
		Title = "Synerox",
		SubTitle = "Ouwland / Slayers 2 v2.8",
		Theme = "Amethyst",
		Size = UDim2.fromOffset(920, 710),
		MinimizeKey = Enum.KeyCode.RightControl,
	})

	AutoQuestToggle = nil
	v7 = tbl11[1]

	fn37 = function(arg, arg2)
		if arg then
			pcall(function()
				if arg.SetValue then
					arg:SetValue(arg2)
				elseif arg.Set then
					arg:Set(arg2)
				end
			end)
		end
	end

	local v8 = v6:AddCategory("FARMING", "solar/swords-bold"):AddTab({ Title = "Farming", Icon = "solar/swords-bold" })
	local v9, v10 = v8:AddSubTab("Mob & Boss Farm"):AddColumns()
	local v11 = v9:AddSection("Mob Auto Farm")

	AutoFarmToggle = v11:AddToggle("AutoFarmToggle", {
		Title = "Enable Auto Farm",
		Default = false,
		Callback = function(autoFarm)
			slayersSyneroxHub.Farm.AutoFarm = autoFarm

			if not autoFarm then
				slayersSyneroxHub.LockedTarget = nil
				slayersSyneroxHub.CurrentTarget = nil
				fn23()
				local v12 = fn8()

				if v12 then
					v12.AssemblyLinearVelocity = Vector3.zero
				end

				if slayersSyneroxHub.Farm.AutoQuest then
					slayersSyneroxHub.Farm.AutoQuest = false
					slayersSyneroxHub.IsInteractingQuest = false
					fn37(AutoQuestToggle, false)
					fn("Auto Farm", "Auto Farm + Auto Quest disabled!")
				end
			end
		end,
	})

	pcall(function()
		AutoFarmToggle:AddKeybind("AutoFarmKey", { Default = Enum.KeyCode.V, Mode = "Toggle" })
	end)

	v11:AddToggle("TargetLockToggle", {
		Title = "Lock Target Until Death",
		Default = true,
		Tooltip = "Locks onto the current boss or mob until death. Zero target switching mid-fight!",
		Callback = function(targetLock)
			slayersSyneroxHub.Farm.TargetLock = targetLock
		end,
	})

	v11:AddDropdown("MobCategorySelection", {
		Title = "Target Category",
		Values = { "Normal Mobs", "Bosses & Hashiras", "All Targets" },
		Default = "Normal Mobs",
		Callback = function(arg)
			slayersSyneroxHub.LockedTarget = nil
			slayersSyneroxHub.CurrentTarget = nil

			if arg == "Normal Mobs" then
				slayersSyneroxHub.Farm.MobCategory = "Normal"
				slayersSyneroxHub.Farm.TargetMob = slayersSyneroxHub.Farm.NormalMob == "All Normal Mobs" and "All" or slayersSyneroxHub.Farm.NormalMob
			elseif arg == "Bosses & Hashiras" then
				slayersSyneroxHub.Farm.MobCategory = "Boss"

				if slayersSyneroxHub.Farm.SelectedBosses and #slayersSyneroxHub.Farm.SelectedBosses > 0 then
					slayersSyneroxHub.Farm.TargetMob = slayersSyneroxHub.Farm.SelectedBosses
				else
					slayersSyneroxHub.Farm.TargetMob = slayersSyneroxHub.Farm.BossMob == "All Bosses" and "All" or slayersSyneroxHub.Farm.BossMob
				end
			else
				slayersSyneroxHub.Farm.MobCategory = "All"
				slayersSyneroxHub.Farm.TargetMob = "All"
			end
		end,
	})

	v11:AddDropdown("NormalMobDropdown", {
		Title = "Select Normal Mob",
		Values = tbl14,
		Default = "All Normal Mobs",
		Callback = function(normalMob)
			slayersSyneroxHub.Farm.NormalMob = normalMob

			if slayersSyneroxHub.Farm.MobCategory == "Normal" then
				slayersSyneroxHub.Farm.TargetMob = normalMob == "All Normal Mobs" and "All" or normalMob
				slayersSyneroxHub.LockedTarget = nil
				slayersSyneroxHub.CurrentTarget = nil
			end
		end,
	})

	v11:AddDropdown("BossMobDropdown", {
		Title = "Boss Priority Target",
		Values = tbl15,
		Default = "All Bosses",
		Callback = function(bossMob)
			slayersSyneroxHub.Farm.BossMob = bossMob

			if slayersSyneroxHub.Farm.MobCategory == "Boss" and (not slayersSyneroxHub.Farm.SelectedBosses or #slayersSyneroxHub.Farm.SelectedBosses == 0) then
				slayersSyneroxHub.Farm.TargetMob = bossMob == "All Bosses" and "All" or bossMob
				slayersSyneroxHub.LockedTarget = nil
				slayersSyneroxHub.CurrentTarget = nil
			end
		end,
	})

	v11:AddDropdown("MultiBossDropdown", {
		Title = "Boss Rotation (Multi-Select)",
		Values = tbl15,
		Default = {},
		Multi = true,
		Callback = function(arg)
			local selectedBosses = {}

			for k, v12 in pairs(arg) do
				v12 = v12 and k ~= "All Bosses"

				if v12 then
					table.insert(selectedBosses, k)
				end
			end

			slayersSyneroxHub.Farm.SelectedBosses = selectedBosses

			if slayersSyneroxHub.Farm.MobCategory == "Boss" then
				if #selectedBosses > 0 then
					slayersSyneroxHub.Farm.TargetMob = selectedBosses
				else
					slayersSyneroxHub.Farm.TargetMob = slayersSyneroxHub.Farm.BossMob == "All Bosses" and "All" or slayersSyneroxHub.Farm.BossMob
				end

				slayersSyneroxHub.LockedTarget = nil
				slayersSyneroxHub.CurrentTarget = nil
			end
		end,
	})

	v11:AddSlider("BossRotationSlider", {
		Title = "Boss Rotation Timeout",
		Min = 5,
		Max = 60,
		Default = 15,
		Rounding = 0,
		Suffix = "s",
		Callback = function(bossRotationInterval)
			slayersSyneroxHub.Farm.BossRotationInterval = bossRotationInterval
		end,
	})

	v11:AddDropdown("RegionFilterDropdown", {
		Title = "Filter By Region",
		Values = tbl16,
		Default = "All",
		Callback = function(regionFilter)
			slayersSyneroxHub.Farm.RegionFilter = regionFilter
			slayersSyneroxHub.LockedTarget = nil
			slayersSyneroxHub.CurrentTarget = nil
		end,
	})

	local v12 = v10:AddSection("Combat & Farm Precision")

	v12:AddDropdown("SafeModeDropdown", {
		Title = "Safe Farm Position Mode",
		Values = { "Overhead", "Underground", "In Front" },
		Default = "Overhead",
		Callback = function(safeMode)
			slayersSyneroxHub.Farm.SafeMode = safeMode
		end,
	})

	v12:AddSlider("HeightOffsetSlider", {
		Title = "Farm Height Offset",
		Min = -15,
		Max = 20,
		Default = 3.8,
		Rounding = 1,
		Suffix = " studs",
		Callback = function(heightOffset)
			slayersSyneroxHub.Farm.HeightOffset = heightOffset
		end,
	})

	v12:AddSlider("DistanceSlider", {
		Title = "Attack Distance Offset",
		Min = 0,
		Max = 10,
		Default = 2,
		Rounding = 1,
		Suffix = " studs",
		Callback = function(distance)
			slayersSyneroxHub.Farm.Distance = distance
		end,
	})

	v12:AddToggle("AutoSkillsToggle", {
		Title = "Auto Cast Skills / Breathing Arts",
		Default = true,
		Callback = function(autoSkills)
			slayersSyneroxHub.Farm.AutoSkills = autoSkills
		end,
	})

	v12:AddToggle("AutoCollectLootToggle", {
		Title = "Auto Collect Drops & Vacuum",
		Default = true,
		Callback = function(autoCollectLoot)
			slayersSyneroxHub.Farm.AutoCollectLoot = autoCollectLoot
		end,
	})

	v12:AddToggle("AutoCollectChestsToggle", {
		Title = "Auto Open Boss Chests",
		Default = true,
		Callback = function(autoCollectChests)
			slayersSyneroxHub.Farm.AutoCollectChests = autoCollectChests
		end,
	})

	v12:AddToggle("AutoCollectSoulsToggle", {
		Title = "Auto Collect Demon Souls",
		Default = true,
		Callback = function(autoCollectSouls)
			slayersSyneroxHub.Farm.AutoCollectSouls = autoCollectSouls
		end,
	})

	local v13, v14 = v8:AddSubTab("Player Farm"):AddColumns()
	local v15 = v13:AddSection("Player Auto Farm")

	v15:AddToggle("PlayerFarmToggle", {
		Title = "Enable Player Auto Farm",
		Default = false,
		Callback = function(playerFarm)
			slayersSyneroxHub.Farm.PlayerFarm = playerFarm

			if not playerFarm then
				slayersSyneroxHub.LockedTarget = nil
				slayersSyneroxHub.CurrentTarget = nil
				fn23()
				local v16 = fn8()

				if v16 then
					v16.AssemblyLinearVelocity = Vector3.zero
				end
			end
		end,
	})

	v15:AddDropdown("PlayerTargetModeDropdown", {
		Title = "Target Mode",
		Values = { "Closest Player", "Specific Player" },
		Default = "Closest Player",
		Callback = function(playerTargetMode)
			slayersSyneroxHub.Farm.PlayerTargetMode = playerTargetMode
			slayersSyneroxHub.LockedTarget = nil
			slayersSyneroxHub.CurrentTarget = nil
		end,
	})

	local SelectedPlayerDropdown = v15:AddDropdown("SelectedPlayerDropdown", {
		Title = "Select Specific Target",
		Values = fn38(),
		Default = "All Players",
		Callback = function(selectedPlayer)
			slayersSyneroxHub.Farm.SelectedPlayer = selectedPlayer
			slayersSyneroxHub.LockedTarget = nil
			slayersSyneroxHub.CurrentTarget = nil
		end,
	})

	local v16 = v14:AddSection("Target & Precision Actions")

	v16:AddButton({
		Title = "Refresh Online Players List",
		Callback = function()
			local v17 = fn38()

			if SelectedPlayerDropdown and SelectedPlayerDropdown.SetValues then
				SelectedPlayerDropdown:SetValues(v17)
			end

			fn("Player List", string.format("Updated: %d players online", #v17 - 1))
		end,
	})

	v16:AddSlider("PlayerHeightSlider", {
		Title = "Player Farm Height Offset",
		Min = -10,
		Max = 15,
		Default = 3.5,
		Rounding = 1,
		Suffix = " studs",
		Callback = function(playerHeightOffset)
			slayersSyneroxHub.Farm.PlayerHeightOffset = playerHeightOffset
		end,
	})

	v16:AddSlider("PlayerDistanceSlider", {
		Title = "Player Distance Offset",
		Min = 0,
		Max = 8,
		Default = 2,
		Rounding = 1,
		Suffix = " studs",
		Callback = function(playerDistance)
			slayersSyneroxHub.Farm.PlayerDistance = playerDistance
		end,
	})

	local v17, v18 = v8:AddSubTab("Quest Farm"):AddColumns()
	local v19 = v17:AddSection("Auto Quest Progression")

	AutoQuestToggle = v19:AddToggle("AutoQuestToggle", {
		Title = "Enable Auto Quest (Auto EXP)",
		Default = false,
		Callback = function(autoQuest)
			slayersSyneroxHub.Farm.AutoQuest = autoQuest

			if autoQuest then
				if not slayersSyneroxHub.Farm.AutoFarm then
					slayersSyneroxHub.Farm.AutoFarm = true
					fn37(AutoFarmToggle, true)
				end

				fn("Auto Quest", "Auto Quest loop active! Auto-taking level quests...")
			else
				slayersSyneroxHub.IsInteractingQuest = false
				slayersSyneroxHub.Farm.AutoFarm = false
				slayersSyneroxHub.LockedTarget = nil
				slayersSyneroxHub.CurrentTarget = nil
				fn23()
				local v20 = fn8()

				if v20 then
					v20.AssemblyLinearVelocity = Vector3.zero
				end

				fn37(AutoFarmToggle, false)
				fn("Auto Quest", "Auto Quest + Farm disabled!")
			end
		end,
	})

	pcall(function()
		AutoQuestToggle:AddKeybind("AutoQuestKey", { Default = Enum.KeyCode.B, Mode = "Toggle" })
	end)

	v19:AddDropdown("QuestSelectionDropdown", {
		Title = "Selected Quest / Category",
		Values = tbl9,
		Default = "Auto Best Quest (By Level)",
		Callback = function(questMode)
			slayersSyneroxHub.Farm.QuestMode = questMode
			slayersSyneroxHub.LockedTarget = nil
			slayersSyneroxHub.CurrentTarget = nil
		end,
	})

	v19:AddToggle("CrowDispatchAutoAccept", {
		Title = "Auto Accept Kasugai Crow Dispatches",
		Default = true,
		Tooltip = "Automatically listens for urgent Kasugai Crow mission dispatches and accepts them instantly!",
		Callback = function()
		end,
	})

	local v20 = v18:AddSection("Quest Controls & Info")

	v20:AddButton({
		Title = "Take Best Level Quest Now",
		Callback = function()
			local v21 = fn26()
			local v22 = fn30(v21)

			if v22 then
				local v23 = fn27()

				if v23 and v23.IsFinished then
					fn28()
					task.wait(0.2)
				end

				if fn29(v22.Name) then
					slayersSyneroxHub.Farm.TargetMob = v22.MobName
					slayersSyneroxHub.Farm.MobCategory = v22.Category
					slayersSyneroxHub.Farm.RegionFilter = v22.Region
					slayersSyneroxHub.LockedTarget = nil
					slayersSyneroxHub.CurrentTarget = nil
					fn("Quest Accepted", string.format("Accepted: %s (Lv %d+)", v22.DisplayName, v22.MinLevel), 4)

					if v22.MobWp then
						fn24(v22.MobWp, v22.MobName .. " Area")
					end
				end
			end
		end,
	})

	v20:AddButton({
		Title = "Check Active Quest Status",
		Callback = function()
			local v21 = fn26()
			local v22 = fn27()

			if v22 then
				local str = ""

				for k, task_ in pairs(v22.Tasks) do
					str ..= string.format("%s: %d/%d ", k, task_.Current, task_.Max)
				end

				fn("Active Quest", string.format("Player Lv %d | %s | %s", v21, v22.Name, str), 6)
			else
				fn("Active Quest", string.format("Player Lv %d | No active quest in progress", v21), 4)
			end
		end,
	})

	v20:AddButton({
		Title = "Cancel Active Quest (Abandon)",
		Callback = function()
			local v21 = fn27()
			local v22 = fn28()
			slayersSyneroxHub.LockedTarget = nil
			slayersSyneroxHub.CurrentTarget = nil

			if v22 or v21 then
				fn("Quest Abandoned", "Active quest successfully cancelled!", 4)
			else
				fn("Quest Notice", "No active quest was found to cancel.", 3)
			end
		end,
	})

	v20:AddButton({
		Title = "STOP ALL (Farm + Quest)",
		Callback = function()
			slayersSyneroxHub.Farm.AutoQuest = false
			slayersSyneroxHub.Farm.AutoFarm = false
			slayersSyneroxHub.IsInteractingQuest = false
			slayersSyneroxHub.LockedTarget = nil
			slayersSyneroxHub.CurrentTarget = nil
			fn23()
			local v21 = fn8()

			if v21 then
				v21.AssemblyLinearVelocity = Vector3.zero
			end

			fn37(AutoQuestToggle, false)
			fn37(AutoFarmToggle, false)
			fn("STOP ALL", "Farm + Quest disabled!", 4)
		end,
	})

	local v21, v22 = v8:AddSubTab("Training Farm"):AddColumns()
	local v23 = v21:AddSection("Training Automations")

	v23:AddToggle("AutoTrainingMasterToggle", {
		Title = "[ 〢 ] Auto Training (Master Routine)",
		Default = false,
		Tooltip = "Fully automates Pushups, Meditation, Boulder splitting, Squats, and Gourd mastery!",
		Callback = function(autoTraining)
			slayersSyneroxHub.Training.AutoTraining = autoTraining

			if autoTraining then
				fn("Auto Training", "Master training routine active!")
			end
		end,
	})

	v23:AddToggle("AutoMinigamesToggle", {
		Title = "Instant Auto-Win Minigames (All)",
		Default = true,
		Tooltip = "Instantly clears Boulder, Squats, Pushups, Tea Cup, and Meditation minigames!",
		Callback = function(autoMinigames)
			slayersSyneroxHub.Training.AutoMinigames = autoMinigames
		end,
	})

	v23:AddToggle("AutoGourdToggle", {
		Title = "Auto Gourd Training (Breathing Mastery)",
		Default = false,
		Tooltip = "Automatically equips and blows into gourds to expand maximum breathing capacity!",
		Callback = function(autoGourd)
			slayersSyneroxHub.Training.AutoGourd = autoGourd
		end,
	})

	v23:AddToggle("AutoBoulderToggle", {
		Title = "Auto Boulder Split Farm (Sabito)",
		Default = false,
		Tooltip = "Repeatedly splits Sabito's boulder for swift strength & weapon EXP!",
		Callback = function(autoBoulder)
			slayersSyneroxHub.Training.AutoBoulder = autoBoulder
		end,
	})

	v23:AddToggle("AutoMeditationToggle", {
		Title = "Auto Meditation",
		Default = false,
		Callback = function(autoMeditation)
			slayersSyneroxHub.Training.AutoMeditation = autoMeditation
		end,
	})

	local v24 = v22:AddSection("Training Stations (Teleports)")

	v24:AddButton({
		Title = "TP Sabito (Boulder Split)",
		Callback = function()
			fn24(Vector3.new(-1046.8, 1133.5, -628.8), "Sabito (Boulder Split)")
		end,
	})

	v24:AddButton({
		Title = "TP Boulder Push",
		Callback = function()
			fn24(Vector3.new(-306.3, 1073.2, -593.9), "Boulder Push")
		end,
	})

	v24:AddButton({
		Title = "TP Parkour Dungeon",
		Callback = function()
			fn24(Vector3.new(116.3, 1069.1, -1290.9), "Parkour Dungeon")
		end,
	})

	v24:AddButton({
		Title = "TP Power Statue",
		Callback = function()
			fn24(Vector3.new(-697.4, 1386.5, -1914.3), "Power Statue")
		end,
	})

	v24:AddButton({
		Title = "TP Squat Rack & Gym",
		Callback = function()
			fn24(Vector3.new(465, 1125, -960), "Squat Rack & Gym")
		end,
	})

	v24:AddButton({
		Title = "TP Meditation Rock (Butterfly)",
		Callback = function()
			fn24(Vector3.new(-1750, 320, -150), "Meditation Rock")
		end,
	})

	local v25, v26 = v8:AddSubTab("Activities & Life"):AddColumns()
	local v27 = v25:AddSection("Fishing Automations")

	v27:AddToggle("AutoFishToggle", {
		Title = "[ 〢 ] Auto Fish",
		Default = false,
		Tooltip = "Auto equips fishing rod, teleports to fishing dock, casts, and solves the minigame!",
		Callback = function(autoFish)
			slayersSyneroxHub.Activities.AutoFish = autoFish

			if autoFish then
				fn("Auto Fish", "Auto Fishing loop enabled!")
				task.spawn(StepAutoFish)
			end
		end,
	})

	v27:AddToggle("AutoBuyBaitToggle", {
		Title = "[ 〢 ] Auto Buy Bait",
		Default = false,
		Tooltip = "Automatically purchases fishing bait when inventory drops below 3!",
		Callback = function(autoBuyBait)
			slayersSyneroxHub.Activities.AutoBuyBait = autoBuyBait

			if autoBuyBait then
				task.spawn(StepAutoBuyBait)
			end
		end,
	})

	v27:AddToggle("AutoBuyExpToggle", {
		Title = "[ 〢 ] Auto Buy Exp",
		Default = false,
		Tooltip = "Automatically purchases EXP training boosts when Wen is available!",
		Callback = function(autoBuyExp)
			slayersSyneroxHub.Activities.AutoBuyExp = autoBuyExp

			if autoBuyExp then
				task.spawn(StepAutoBuyExp)
			end
		end,
	})

	v27:AddButton({
		Title = "TP to Mistfall Harbor Fishing Dock",
		Callback = function()
			fn24(Vector3.new(156.4, 870.2, 745.8), "Mistfall Harbor Fishing Dock")
		end,
	})

	v27:AddButton({
		Title = "TP to Angler Runo (Bait & Rod Shop)",
		Callback = function()
			fn24(Vector3.new(140.7, 873.5, 728.2), "Angler Runo (Mistfall Harbor)")
		end,
	})

	local v28 = v26:AddSection("Schematics & Collectibles")

	v28:AddToggle("AutoCollectSchematicsToggle", {
		Title = "[ 〢 ] Collect Schematics (Auto Loop)",
		Default = false,
		Tooltip = "Continuously sweeps the world for dropped blueprints, schematics, and chests!",
		Callback = function(collectSchematics)
			slayersSyneroxHub.Activities.CollectSchematics = collectSchematics
		end,
	})

	v28:AddButton({
		Title = "Collect All World Schematics Now",
		Callback = function()
			StepCollectSchematics()
		end,
	})

	local v29, v30 = v8:AddSubTab("Demon Progression"):AddColumns()
	local v31 = v29:AddSection("Demon Requirements & Verification")
	local DemonRaceLabel = v31:AddLabel("DemonRaceLabel", "Race: Scanning...")
	local DemonLvlLabel = v31:AddLabel("DemonLvlLabel", "Level (15+): Scanning...")
	local DemonRepLabel = v31:AddLabel("DemonRepLabel", "Reputation (-40): Scanning...")
	local DemonTimeLabel = v31:AddLabel("DemonTimeLabel", "World Time: Scanning...")
	local DemonQuestLabel = v31:AddLabel("DemonQuestLabel", "Muzan Quest: Scanning...")
	local DemonItemsLabel = v31:AddLabel("DemonItemsLabel", "Items: Scanning...")
	local DemonOverallLabel = v31:AddLabel("DemonOverallLabel", "Status: Checking...")

	local function updateDemonProgressionLabels()
		local v32 = CheckDemonRequirements()

		pcall(function()
			if DemonRaceLabel then
				DemonRaceLabel:SetText(string.format("Race: %s %s", v32.Race, v32.IsDemonOrHybrid and "[ALREADY DEMON]" or v32.IsHuman and "[PASS]" or "[FAIL - NEED HUMAN]"))
			end

			if DemonLvlLabel then
				DemonLvlLabel:SetText(string.format("Level: %d / %d %s", v32.Level, v32.RequiredLevel, v32.LevelPass and "[PASS]" or string.format("[FAIL - NEED LV 15 (+%d)]", 15 - v32.Level)))
			end

			if DemonRepLabel then
				DemonRepLabel:SetText(string.format("Reputation: %d / -40 %s", v32.Reputation, v32.ReputationPass and "[PASS - EVIL READY]" or string.format("[FAIL - NEED %d EVIL KARMA]", v32.Reputation - -40)))
			end

			if DemonTimeLabel then
				DemonTimeLabel:SetText(string.format("World Time: %.1f %s", v32.ClockTime, v32.IsNight and "[NIGHT - MUZAN ACTIVE]" or "[DAY - WAIT FOR NIGHT]"))
			end

			if DemonQuestLabel then
				local quest = v32.Quest
				local muzanQuest

				if quest.Status == "Doing" then
					muzanQuest = string.format("Doing (%d/9 Lilies | Higoshima: %s)", quest.Lilies, quest.HigoshimaDelivered and "DONE" or "PENDING")
				else
					muzanQuest = "None"

					if quest.Status == "Completed" then
						muzanQuest = "Completed"
					end
				end

				DemonQuestLabel:SetText("Muzan Quest: " .. muzanQuest)
			end

			if DemonItemsLabel then
				local quest = v32.Quest
				DemonItemsLabel:SetText(string.format("Biwa Bell: %s | Muzan Blood: %s", quest.HasBell and "YES" or "NO", quest.HasBlood and "YES (READY TO DRINK!)" or "NO"))
			end

			if DemonOverallLabel then
				DemonOverallLabel:SetText("Overall: " .. v32.Summary)
			end
		end)
	end

	_G.UpdateDemonProgressionLabels = updateDemonProgressionLabels

	v31:AddButton({
		Title = "Check Requirements (Detailed)",
		Callback = function()
			updateDemonProgressionLabels()
			fn("Demon Requirements Check", CheckDemonRequirements().Summary, 5)
		end,
	})

	local v32 = v29:AddSection("Automated Progression")

	v32:AddToggle("AutoBecomeDemonToggle", {
		Title = "Auto Become Demon (Full Flow)",
		Default = false,
		Tooltip = "Fully autonomous! Verifies requirements, farms evil karma from civilians, talks to Muzan at night, collects lilies, delivers Dr. Higoshima, and transforms!",
		Callback = function(autoBecomeDemon)
			slayersSyneroxHub.Activities.AutoBecomeDemon = autoBecomeDemon

			if autoBecomeDemon then
				fn("Demon Progression", "Auto Demon routine activated!")

				task.spawn(function()
					RunAutoBecomeDemon(true)
				end)
			end
		end,
	})

	v32:AddToggle("AutoFarmEvilKarmaToggle", {
		Title = "Auto Farm Evil Karma (Civilians)",
		Default = false,
		Tooltip = "Continuously defeats Civilians in Kiribating village until Reputation <= -40 (required for Muzan)!",
		Callback = function(autoFarmEvilKarma)
			slayersSyneroxHub.Activities.AutoFarmEvilKarma = autoFarmEvilKarma

			if autoFarmEvilKarma then
				fn("Evil Karma Farm", "Defeating civilians until Reputation <= -40...")
				task.spawn(StepFarmEvilKarma)
			end
		end,
	})

	v32:AddButton({
		Title = "Drink Muzan's Blood Now",
		Tooltip = "Consumes Muzan's Blood outside combat to complete the Demon transformation!",
		Callback = function()
			DrinkMuzansBlood()
		end,
	})

	local v33 = v30:AddSection("Muzan & Quest Actions")

	v33:AddButton({
		Title = "Talk to Muzan / Accept Quest",
		Tooltip = "Teleports to Muzan and interacts to request Biwa Bell and accept Muzan Quest",
		Callback = function()
			TalkToMuzan()
		end,
	})

	v33:AddButton({
		Title = "Auto-Deliver Dr. Higoshima",
		Tooltip = "Picks up Dr. Higoshima from spawn point and delivers him to Safe Zone",
		Callback = function()
			DeliverDrHigoshima()
		end,
	})

	v33:AddButton({
		Title = "Auto-Collect 9 Spider Lilies",
		Tooltip = "Sweeps the world and hotspots to gather 9 Spider Lilies",
		Callback = function()
			CollectAllSpiderLilies()
		end,
	})

	v33:AddButton({
		Title = "TP Muzan's Lair",
		Callback = function()
			TeleportToMuzan()
		end,
	})

	v33:AddButton({
		Title = "TP Dr. Higoshima Spawn",
		Callback = function()
			TeleportToDrHigoshima()
		end,
	})

	v33:AddButton({
		Title = "TP Higoshima Safe Zone (Delivery)",
		Callback = function()
			TeleportToHigoshimaSafezone()
		end,
	})

	local v34 = v30:AddSection("Locations & Gathering")

	v34:AddButton({
		Title = "TP Closest Spider Lily",
		Callback = function()
			TeleportClosestSpiderLily()
		end,
	})

	v34:AddButton({
		Title = "TP Butterfly Garden (Lily Spot)",
		Callback = function()
			TeleportButterflyGardenLilies()
		end,
	})

	v34:AddButton({
		Title = "TP Bamboo Pond (Lily Spot)",
		Callback = function()
			TeleportBambooPondLilies()
		end,
	})

	v34:AddButton({
		Title = "TP Kiribating Civilians (Karma Spot)",
		Callback = function()
			TeleportKiribatingCivilians()
		end,
	})
end

do
	local v8 = v6:AddCategory("DUNGEON", "solar/shield-star-bold"):AddTab({ Title = "Dungeon", Icon = "solar/shield-star-bold" })
	local v9, v10 = v8:AddSubTab("Ouwigahara Dungeon"):AddColumns()
	local v11 = v9:AddSection("Ouwigahara Status & Verification")
	local DungeonLvlLabel = v11:AddLabel("DungeonLvlLabel", "Dungeon Level Check: Scanning...")
	local DungeonWenLabel = v11:AddLabel("DungeonWenLabel", "Player Wen: Scanning...")
	local DungeonRaceLabel = v11:AddLabel("DungeonRaceLabel", "Race & Style: Scanning...")
	local DungeonStatusLabel = v11:AddLabel("DungeonStatusLabel", "Access Status: Checking...")
	local DungeonZoneLabel = v11:AddLabel("DungeonZoneLabel", "Current Location: Scanning...")

	if DungeonLvlLabel then
		DungeonLvlLabel:SetText("Dungeon Level Check: Scanning...")
	end

	if DungeonWenLabel then
		DungeonWenLabel:SetText("Player Wen: Scanning...")
	end

	if DungeonRaceLabel then
		DungeonRaceLabel:SetText("Race & Style: Scanning...")
	end

	if DungeonStatusLabel then
		DungeonStatusLabel:SetText("Access Status: Checking...")
	end

	if DungeonZoneLabel then
		DungeonZoneLabel:SetText("Current Location: Scanning...")
	end

	local function fn38()
		local v12 = CheckOuwigaharaRequirements()

		pcall(function()
			if DungeonLvlLabel then
				DungeonLvlLabel:SetText(string.format("Level: %d / %d [%s]", v12.Level, v12.RequiredLevel, v12.LevelPass and "PASS" or "FAIL - NEED LV 50"))
			end

			if DungeonWenLabel then
				DungeonWenLabel:SetText(string.format("Current Wen: %d", v12.Wen))
			end

			if DungeonRaceLabel then
				DungeonRaceLabel:SetText(string.format("Race: %s", v12.Race))
			end

			if DungeonStatusLabel then
				DungeonStatusLabel:SetText("Status: " .. v12.Status)
			end

			if DungeonZoneLabel then
				local str = IsInDungeonQueueArea() and "LOBBY QUEUE AREA (StartPad Detected)"
				local currentLocation

				if str then
					currentLocation = str
				else
					currentLocation = game.PlaceId == 75556147183481 and "IN DUNGEON MATCH" or "MAIN MAP"
				end

				DungeonZoneLabel:SetText("Current Location: " .. currentLocation)
			end
		end)
	end

	v11:AddButton({
		Title = "Check & Verify Requirements Now",
		Callback = function()
			fn38()
			local v12 = CheckOuwigaharaRequirements()

			if v12.AlreadyUnlocked then
				fn("Ouwigahara Check", "Ouwigahara is ALREADY UNLOCKED!", 4)
			elseif v12.LevelPass then
				fn("Ouwigahara Check", string.format("Level %d/50 — All requirements satisfied!", v12.Level), 5)
			else
				fn("Ouwigahara Check", string.format("Level %d/50 — Must reach Level 50!", v12.Level), 5)
			end
		end,
	})

	local v12 = v10:AddSection("Auto Unlock & Dungeon Entry")

	v12:AddToggle("AutoReadyUpToggle", {
		Title = "[ 〢 ] Auto Ready Up / Auto Queue",
		Default = false,
		Tooltip = "Detects when you are in the Dungeon Queue/Lobby area, teleports onto StartPad and activates Ready Up automatically!",
		Callback = function(autoReadyUp)
			slayersSyneroxHub.Dungeon.AutoReadyUp = autoReadyUp
			slayersSyneroxHub.Dungeon.AutoQueue = autoReadyUp

			if autoReadyUp then
				fn("Dungeon Queue", "Auto Ready Up enabled! Checking queue pad...")

				task.spawn(function()
					if IsInDungeonQueueArea() then
						StepAutoQueuePad(true)
					end
				end)
			end
		end,
	})

	v12:AddButton({
		Title = "Ready Up Now (Activate Queue)",
		Callback = function()
			if not StepAutoQueuePad(true) then
				fn("Dungeon Queue", "StartPad prompt not found or not in queue area!", 3.5)
			end
		end,
	})

	v12:AddButton({
		Title = "Auto Unlock Ouwigahara (Talk to Gate NPC)",
		Callback = function()
			fn38()
			if IsOuwigaharaUnlocked() then
				fn("Ouwigahara Dungeon", "Ouwigahara is ALREADY UNLOCKED! Button will not perform redundant actions.", 4)
				return
			end
			AutoUnlockOuwigahara()
			fn38()
		end,
	})

	v12:AddButton({
		Title = "Auto Join Matchmaking Queue",
		Callback = function()
			fn("Dungeon Queue", "Dispatching matchmaking request for Ouwigahara...", 4)

			pcall(function()
				require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent).ToServer("MinigameQueue", "Ouwigahara")
			end)

			pcall(function()
				require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction).ToServer("OuwigaharaJoin", "Normal")
			end)
		end,
	})

	v12:AddButton({
		Title = "Teleport Directly to Dungeon Server",
		Callback = function()
			fn("Dungeon Teleport", "Teleporting to Ouwigahara Dungeon Server (PlaceId: 75556147183481)...", 5)

			pcall(function()
				game:GetService("TeleportService"):Teleport(75556147183481, localPlayer)
			end)
		end,
	})

	v12:AddButton({
		Title = "TP to Dungeon Portal (Map Entrance)",
		Callback = function()
			fn24(Vector3.new(-1607.1, 1018, 1142.4), "Ouwigahara Dungeon Portal")
		end,
	})

	local v13 = v9:AddSection("Dungeon Auto Farm (Wave Sweeper)")

	v13:AddToggle("AutoFarmDungeonToggle", {
		Title = "Auto Farm Dungeon Waves",
		Default = false,
		Tooltip = "Automatically sweeps all dungeon wave enemies, bosses, picks perk cards, and opens chests!",
		Callback = function(autoFarm)
			slayersSyneroxHub.Dungeon.AutoFarm = autoFarm

			if autoFarm then
				fn("Dungeon Farm", "Dungeon Auto Farm started! Sweeping wave enemies...")

				task.spawn(function()
					if IsInDungeonQueueArea() then
						StepAutoQueuePad(true)
					end

					StepAutoFarmDungeon()
				end)
			else
				fn23()
				fn("Dungeon Farm", "Dungeon Auto Farm stopped.")
			end
		end,
	})

	v13:AddDropdown("DungeonAttackModeDropdown", {
		Title = "Attack Positioning",
		Values = { "Overhead (Safe)", "Behind Target", "Ground" },
		Default = "Overhead (Safe)",
		Tooltip = "Overhead hovers above enemies to avoid melee damage.",
		Callback = function(attackMode)
			slayersSyneroxHub.Dungeon.AttackMode = attackMode
		end,
	})

	v13:AddSlider("DungeonHeightOffsetSlider", {
		Title = "Overhead Height Offset",
		Min = 3,
		Max = 12,
		Default = 6.5,
		Step = 0.5,
		Tooltip = "Distance in studs above target when using Overhead mode.",
		Callback = function(heightOffset)
			slayersSyneroxHub.Dungeon.HeightOffset = heightOffset
		end,
	})

	v13:AddToggle("DungeonAutoSkillsToggle", {
		Title = "Auto Cast Skills (Z, X, C, V, B)",
		Default = true,
		Tooltip = "Automatically fires breathing / BDA skills during combat for massive AoE damage!",
		Callback = function(autoSkills)
			slayersSyneroxHub.Dungeon.AutoSkills = autoSkills
		end,
	})

	local v14 = v10:AddSection("Dungeon Cards, Chests & Upgrades")

	v14:AddToggle("DungeonAutoPickCardsToggle", {
		Title = "Auto Pick Best Perk Cards",
		Default = true,
		Tooltip = "Automatically chooses Damage/Health perk cards when wave clears so you never stall!",
		Callback = function(autoPickCards)
			slayersSyneroxHub.Dungeon.AutoPickCards = autoPickCards
		end,
	})

	v14:AddToggle("DungeonAutoCollectChestsToggle", {
		Title = "Auto Collect Dungeon Chests",
		Default = true,
		Tooltip = "Sweeps and opens all dropped chests and sealed caches after waves and boss kills!",
		Callback = function(autoCollectChests)
			slayersSyneroxHub.Dungeon.AutoCollectChests = autoCollectChests
		end,
	})

	v14:AddDropdown("DungeonTargetPriorityDropdown", {
		Title = "Target Priority",
		Values = { "Closest", "Lowest Health" },
		Default = "Closest",
		Tooltip = "Whether to attack the nearest enemy or finish off lowest health enemies first.",
		Callback = function(targetPriority)
			slayersSyneroxHub.Dungeon.TargetPriority = targetPriority
		end,
	})

	v14:AddSlider("DungeonMultiHitSlider", {
		Title = "Multi-Hit Attack Count",
		Min = 1,
		Max = 5,
		Default = 3,
		Step = 1,
		Tooltip = "Number of M1 strikes executed per attack tick.",
		Callback = function(multiHitCount)
			slayersSyneroxHub.Dungeon.MultiHitCount = multiHitCount
		end,
	})

	v14:AddButton({
		Title = "Clear Current Wave Now",
		Callback = function()
			StepAutoFarmDungeon()
		end,
	})

	task.spawn(function()
		task.wait(1.5)
		fn38()
	end)

	local v15, v16 = v8:AddSubTab("Auto Skill Tree"):AddColumns()
	local v17 = v15:AddSection("Point Allocation Controls")

	v17:AddToggle("AutoAllocateSkillPoints", {
		Title = "Enable Auto Allocate Skill Points",
		Default = false,
		Tooltip = "Automatically detects newly gained skill points and invests them according to your chosen priority!",
		Callback = function(autoAllocate)
			slayersSyneroxHub.SkillTree.AutoAllocate = autoAllocate

			if autoAllocate then
				fn("Skill Tree", "Auto point allocation active!")
				RunAutoSkillTreeAllocation()
			end
		end,
	})

	v17:AddDropdown("SkillPriorityDropdown", {
		Title = "Allocation Priority",
		Values = {
			"Balanced",
			"Strength / M1 Damage",
			"Health / Max Stamina",
			"Sword Mastery",
			"Breathing / BDA Mastery",
		},
		Default = "Balanced",
		Callback = function(priority)
			slayersSyneroxHub.SkillTree.Priority = priority
		end,
	})

	v17:AddButton({
		Title = "Allocate Available Points Now",
		Description = "Instantly fires all allocation remotes and GUI buttons for all unspent points.",
		Callback = function()
			RunImmediateSkillAllocation()
		end,
	})

	local v18 = v16:AddSection("Points & Masteries Status")
	local SkillPointsLabel = v18:AddLabel("SkillPointsLabel", "Available Points: Scanning...")
	local PlayerLvlLabel = v18:AddLabel("PlayerLvlLabel", "Current Level: Scanning...")

	if SkillPointsLabel then
		SkillPointsLabel:SetText("Available Points: Scanning...")
	end

	if PlayerLvlLabel then
		PlayerLvlLabel:SetText("Current Level: Scanning...")
	end

	local function fn39()
		pcall(function()
			local v19 = GetAvailableSkillPoints()
			local v20 = fn26()

			if SkillPointsLabel then
				SkillPointsLabel:SetText(string.format("Unspent Skill Points: %d", v19))
			end

			if PlayerLvlLabel then
				PlayerLvlLabel:SetText(string.format("Player Level: %d", v20))
			end
		end)
	end

	v18:AddButton({
		Title = "Refresh Points Count",
		Callback = function()
			fn39()
		end,
	})

	task.spawn(function()
		task.wait(2)
		fn39()
	end)

	local v19, v20 = v8:AddSubTab("Boss Timers"):AddColumns()
	local v21 = v19:AddSection("Map Bosses Cooldown Clocks")
	local v22 = v20:AddSection("Hashiras & Upper Moons Clocks")
	local tbl14 = { "Sanemi", "Giyu", "Rengoku", "Tengen", "Akaza", "Douma" }

	for _, v23 in ipairs({ "Nezuko", "Yahaba", "Sasumaru", "Hand Demon", "Sabito", "Zanegutsu Kuuchie", "Shiron" }) do
		local v24 = v21:AddLabel("Boss_" .. v23, v23 .. ": [ SCANNING ]")

		if v24 then
			v24:SetText(v23 .. ": [ SCANNING ]")
		end

		tbl8[v23] = v24
		local pos = tbl7[v23] and tbl7[v23].Pos

		if pos then
			v21:AddButton({
				Title = "TP to " .. v23 .. " Spawn",
				Callback = function()
					fn24(pos, v23 .. " Spawn")
				end,
			})
		end
	end

	for _, v23 in ipairs(tbl14) do
		local v24 = v22:AddLabel("BossHigh_" .. v23, v23 .. ": [ SCANNING ]")

		if v24 then
			v24:SetText(v23 .. ": [ SCANNING ]")
		end

		tbl8[v23] = v24
		local pos = tbl7[v23] and tbl7[v23].Pos

		if pos then
			v22:AddButton({
				Title = "TP to " .. v23 .. " Spawn",
				Callback = function()
					fn24(pos, v23 .. " Spawn")
				end,
			})
		end
	end
end

do
	local v8 = v6:AddCategory("COMBAT", "solar/bomb-bold"):AddTab({ Title = "Combat", Icon = "solar/bomb-bold" })
	local v9, v10 = v8:AddSubTab("Combat & Buffs"):AddColumns()
	local v11 = v9:AddSection("Stamina & Elemental Buffs")

	v11:AddToggle("InfStaminaToggle", {
		Title = "Infinite Stamina (Engine Lock)",
		Default = true,
		Callback = function(infStamina)
			slayersSyneroxHub.Combat.InfStamina = infStamina
		end,
	})

	v11:AddToggle("NoSunDamageToggle", {
		Title = "No Sun Damage (Demon Immunity)",
		Default = false,
		Callback = function(noSunDamage)
			slayersSyneroxHub.Combat.NoSunDamage = noSunDamage

			if noSunDamage then
				pcall(function()
					local playerGui = localPlayer:FindFirstChild("PlayerGui")
					playerGui = playerGui and playerGui:FindFirstChild("UCS")
					local gamePlay = playerGui and playerGui:FindFirstChild("Game_Play")
					gamePlay = gamePlay and gamePlay:FindFirstChild("SunDamage")

					if gamePlay and gamePlay:IsA("LocalScript") then
						gamePlay.Enabled = false
					end
				end)

				pcall(function()
					localPlayer:SetAttribute("SecondarySituation", "Sunless")
				end)

				pcall(function()
					if SignalFunction and SignalFunction.ToServer then
						SignalFunction.ToServer("SunDamage", false)
					end
				end)

				fn("Sun Immunity", "Sun damage immunity enabled!")
			else
				pcall(function()
					local playerGui = localPlayer:FindFirstChild("PlayerGui")
					playerGui = playerGui and playerGui:FindFirstChild("UCS")
					local gamePlay = playerGui and playerGui:FindFirstChild("Game_Play")
					gamePlay = gamePlay and gamePlay:FindFirstChild("SunDamage")

					if gamePlay and gamePlay:IsA("LocalScript") then
						gamePlay.Enabled = true
					end
				end)

				pcall(function()
					if localPlayer:GetAttribute("SecondarySituation") == "Sunless" then
						localPlayer:SetAttribute("SecondarySituation", nil)
					end
				end)
			end
		end,
	})

	v11:AddToggle("NoColdDamageToggle", {
		Title = "No Cold / Snow Damage (Iceveil Valley)",
		Default = false,
		Callback = function(noColdDamage)
			slayersSyneroxHub.Combat.NoColdDamage = noColdDamage

			if noColdDamage then
				pcall(function()
					local v12 = fn7()

					if v12 then
						local snowFrostTick = v12:FindFirstChild("Snow Frost Tick")

						if snowFrostTick then
							snowFrostTick:Destroy()
						end
					end
				end)

				fn("Cold Immunity", "Snow & cold damage immunity enabled!")
			end
		end,
	})

	v11:AddToggle("FastAttackToggle", {
		Title = "Fast M1 Attack (Continuous)",
		Default = false,
		Callback = function(fastAttack)
			slayersSyneroxHub.Combat.FastAttack = fastAttack
		end,
	})

	v11:AddToggle("AntiFreezeToggle", {
		Title = "Auto Anti-Freeze & Stun Recovery",
		Default = true,
		Callback = function(antiFreeze)
			slayersSyneroxHub.Combat.AntiFreeze = antiFreeze
		end,
	})

	v11:AddToggle("TrackGuardToggle", {
		Title = "Animation Track Guard (Anti-64 Cap)",
		Default = true,
		Callback = function(trackGuard)
			slayersSyneroxHub.Combat.TrackGuard = trackGuard
		end,
	})

	local v12 = v10:AddSection("Recovery & Status")

	v12:AddButton({
		Title = "Force Unfreeze Character",
		Callback = function()
			fn11()
			fn("Player Recovery", "Unfreezing character, clearing ragdoll and stun tags!", 3)
		end,
	})

	v12:AddButton({
		Title = "Clear All Combat Cooldowns",
		Callback = function()
			pcall(function()
				local character = localPlayer.Character

				if character then
					for _, descendant in ipairs(character:GetDescendants()) do
						if descendant.Name:find("Cooldown") or descendant.Name:find("cooldown") or descendant.Name:find("busy") then
							pcall(function()
								descendant:Destroy()
							end)
						end
					end
				end
			end)

			fn("Combat", "Combat cooldown flags cleared!")
		end,
	})

	local v13, v14 = v8:AddSubTab("Auto Parry & Defense"):AddColumns()
	local v15 = v13:AddSection("Predictive Auto Parry Engine")

	v15:AddToggle("AutoParryToggle", {
		Title = "Enable Predictive Auto Parry",
		Default = false,
		Tooltip = "Reads enemy attack startup frames and incoming arm velocity to deflect hits perfectly!",
		Callback = function(autoParry)
			slayersSyneroxHub.Combat.AutoParry = autoParry

			if autoParry then
				fn("Auto Parry", "Predictive deflect defense enabled!")
			end
		end,
	})

	v15:AddDropdown("ParryModeDropdown", {
		Title = "Target Filter",
		Values = { "All Enemies", "Bosses & Players", "Mobs Only", "Players Only" },
		Default = "All Enemies",
		Callback = function(parryMode)
			slayersSyneroxHub.Combat.ParryMode = parryMode
		end,
	})

	v15:AddSlider("ParryRangeSlider", {
		Title = "Parry Detection Distance",
		Min = 8,
		Max = 30,
		Default = 16,
		Rounding = 0,
		Suffix = " studs",
		Callback = function(parryRange)
			slayersSyneroxHub.Combat.ParryRange = parryRange
		end,
	})

	v15:AddToggle("AutoCounterToggle", {
		Title = "Auto Counter Attack",
		Default = true,
		Tooltip = "Instantly queues a counter-attack punish immediately after deflecting an enemy strike!",
		Callback = function(autoCounter)
			slayersSyneroxHub.Combat.AutoCounter = autoCounter
		end,
	})

	local v16 = v14:AddSection("Frame & Latency Tuning")

	v16:AddSlider("ParryDurationSlider", {
		Title = "Deflect Window Duration",
		Min = 0.1,
		Max = 0.35,
		Default = 0.18,
		Rounding = 2,
		Suffix = "s",
		Callback = function(parryDuration)
			slayersSyneroxHub.Combat.ParryDuration = parryDuration
		end,
	})

	v16:AddSlider("ParryCooldownSlider", {
		Title = "Deflect Cooldown Interval",
		Min = 0.1,
		Max = 0.5,
		Default = 0.22,
		Rounding = 2,
		Suffix = "s",
		Callback = function(parryCooldown)
			slayersSyneroxHub.Combat.ParryCooldown = parryCooldown
		end,
	})

	local v17, v18 = v8:AddSubTab("Equipment & Armory"):AddColumns()
	local v19 = v17:AddSection("Auto Gear Automation")

	v19:AddToggle("AutoEquipBestToggle", {
		Title = "Auto Equip Best Equipment",
		Default = false,
		Tooltip = "Scans inventory and backpack, equipping the highest damage Katana and best armor automatically!",
		Callback = function(autoEquipBest)
			slayersSyneroxHub.Equipment.AutoEquipBest = autoEquipBest

			if autoEquipBest then
				fn("Equipment", "Auto equip best gear enabled!")
				AutoEquipBestGear()
			end
		end,
	})

	v19:AddButton({
		Title = "Equip Best Gear Now",
		Callback = function()
			AutoEquipBestGear()
		end,
	})

	v18:AddSection("Katana Controls"):AddButton({
		Title = "Equip Katana from Backpack",
		Callback = function()
			local character = localPlayer.Character
			local backpack = localPlayer:FindFirstChild("Backpack")

			if character and backpack then
				for _, child in ipairs(backpack:GetChildren()) do
					if child:IsA("Tool") and (child.Name:lower():find("katana") or child.Name:lower():find("nichirin")) then
						child.Parent = character
						fn("Equipment", "Equipped: " .. child.Name, 3)
						break
					end
				end
			end
		end,
	})
end

do
	local v8 = v6:AddCategory("SHOP", "solar/cart-large-bold"):AddTab({ Title = "Shop", Icon = "solar/cart-large-bold" })
	local v9, v10 = v8:AddSubTab("Weapons & Katanas"):AddColumns()
	local v11 = v9:AddSection("Nichirin & Katana Shop")

	local tbl14 = {
		"Common Katana (500 Wen)",
		"Water Nichirin (2500 Wen)",
		"Thunder Nichirin (2500 Wen)",
		"Wind Nichirin (2500 Wen)",
		"Flame Nichirin (2500 Wen)",
		"Insect Nichirin (3000 Wen)",
		"Sound Nichirin (3000 Wen)",
		"Beast Nichirin (3000 Wen)",
		"Mist Nichirin (3500 Wen)",
		"Sun Nichirin (5000 Wen)",
		"Moon Nichirin (5000 Wen)",
		"Devourer Katana (10000 Wen)",
	}

	v11:AddDropdown("WeaponToBuyDropdown", {
		Title = "Select Weapon",
		Values = tbl14,
		Default = tbl14[1],
		Callback = function(selectedWeapon)
			slayersSyneroxHub.Shop.SelectedWeapon = selectedWeapon
		end,
	})

	v11:AddButton({
		Title = "Buy Selected Weapon",
		Description = "Interacts with merchant prompt, progresses dialogue, sends remotes, and auto-equips!",
		Callback = function()
			local v12 = tbl5.Weapons[slayersSyneroxHub.Shop.SelectedWeapon]

			if v12 then
				ExecuteShopPurchase(v12)
			end
		end,
	})

	v11:AddToggle("AutoEquipBoughtWeapon", {
		Title = "Auto Equip Weapon on Purchase",
		Default = true,
		Callback = function(autoEquip)
			slayersSyneroxHub.Shop.AutoEquip = autoEquip
		end,
	})

	local v12 = v10:AddSection("Weapon Stores & Blacksmiths")

	v12:AddButton({
		Title = "TP to Village Weapon Shop (Raze)",
		Callback = function()
			fn24(Vector3.new(-586.3, 1244.6, -1085.8), "Village Weapon Shop (Raze)")
		end,
	})

	v12:AddButton({
		Title = "TP to Master Swordsmith (Haganezuka)",
		Callback = function()
			fn24(Vector3.new(-1200, 950, 850), "Master Swordsmith")
		end,
	})

	local v13, v14 = v8:AddSubTab("Gourds & Items"):AddColumns()
	local v15 = v13:AddSection("Breathing Gourds Shop")
	local tbl15 = { "Small Gourd (700 Wen)", "Medium Gourd (1500 Wen)", "Big Gourd (3500 Wen)" }

	v15:AddDropdown("GourdToBuyDropdown", {
		Title = "Select Gourd",
		Values = tbl15,
		Default = tbl15[1],
		Callback = function(selectedGourd)
			slayersSyneroxHub.Shop.SelectedGourd = selectedGourd
		end,
	})

	v15:AddButton({
		Title = "Buy Selected Gourd",
		Callback = function()
			local v16 = tbl5.Gourds[slayersSyneroxHub.Shop.SelectedGourd]

			if v16 then
				ExecuteShopPurchase(v16)
			end
		end,
	})

	v15:AddButton({
		Title = "TP to Gourd Merchant",
		Callback = function()
			fn24(Vector3.new(-1798.9, 347.9, -189.3), "Gourd Merchant")
		end,
	})

	local v16 = v14:AddSection("Medicines & Consumables")

	local tbl16 = {
		"Bandage (50 Wen)",
		"Health Potion (200 Wen)",
		"Stamina Elixir (200 Wen)",
		"Lantern (250 Wen)",
		"Fishing Bait (100 Wen)",
	}

	v16:AddDropdown("ConsumableToBuyDropdown", {
		Title = "Select Consumable",
		Values = tbl16,
		Default = tbl16[1],
		Callback = function(selectedConsumable)
			slayersSyneroxHub.Shop.SelectedConsumable = selectedConsumable
		end,
	})

	v16:AddButton({
		Title = "Buy Selected Consumable",
		Callback = function()
			local v17 = tbl5.Items[slayersSyneroxHub.Shop.SelectedConsumable]

			if v17 then
				ExecuteShopPurchase(v17)
			end
		end,
	})

	v16:AddButton({
		Title = "TP to Butterfly Medical Shop",
		Callback = function()
			fn24(Vector3.new(-1798.9, 347.9, -189.3), "Butterfly Medical Shop")
		end,
	})

	local v17, v18 = v8:AddSubTab("Black Market"):AddColumns()
	local v19 = v17:AddSection("Black Market Merchant")

	v19:AddButton({
		Title = "Find & Teleport to Black Market",
		Callback = function()
			FindAndTeleportBlackMarket()
		end,
	})

	v19:AddButton({
		Title = "TP Kuro Merchant (Bamboo Grove)",
		Callback = function()
			fn24(Vector3.new(540, 1121, -1024), "Kuro (Bamboo Grove)")
		end,
	})

	local Information = v18:AddSection("Information")
	local BMDesc1 = Information:AddLabel("BMDesc1", "Black Market sells rare potions, ore, and exotic katanas.")
	local BMDesc2 = Information:AddLabel("BMDesc2", "Kuro stays at Bamboo Grove. Roaming Merchant moves every 30m.")

	if BMDesc1 then
		BMDesc1:SetText("Black Market sells rare potions, ore, and exotic katanas.")
	end

	if BMDesc2 then
		BMDesc2:SetText("Kuro stays at Bamboo Grove. Roaming Merchant moves every 30m.")
	end
end

do
	local v8 = v6:AddCategory("SPINS", "solar/refresh-circle-bold"):AddTab({ Title = "Spins", Icon = "solar/refresh-circle-bold" })
	local v9, v10 = v8:AddSubTab("Clan Spins"):AddColumns()
	local v11 = v9:AddSection("Auto Clan Spin")

	AutoSpinToggle = v11:AddToggle("AutoSpinToggle", {
		Title = "Enable Fast Auto Spin",
		Default = false,
		Callback = function(arg)
			if arg then
				fn("Auto Spin", "Fast Auto Clan Spin enabled!")
				fn33()
			else
				fn32(false)
			end
		end,
	})

	v11:AddDropdown("SpinModeDropdown", {
		Title = "Auto Spin Mode",
		Values = { "Rarity (Stop at Rarity)", "Specific Clan" },
		Default = "Rarity (Stop at Rarity)",
		Callback = function(arg)
			slayersSyneroxHub.Spin.Mode = arg == "Specific Clan" and "Specific Clan" or "Rarity"
		end,
	})

	v11:AddDropdown("TargetClanDropdown", {
		Title = "Target Clan (Specific Mode)",
		Values = tbl12,
		Default = "Kamado",
		Callback = function(targetClan)
			slayersSyneroxHub.Spin.TargetClan = targetClan
		end,
	})

	v11:AddDropdown("StopRarityDropdown", {
		Title = "Stop At Rarity",
		Values = { "Mythic+", "Supreme Only", "Legendary+" },
		Default = "Mythic+",
		Callback = function(stopRarity)
			slayersSyneroxHub.Spin.StopRarity = stopRarity
		end,
	})

	v11:AddSlider("SpinDelaySlider", {
		Title = "Spin Interval Delay",
		Min = 0.05,
		Max = 1,
		Default = 0.15,
		Rounding = 2,
		Suffix = "s",
		Callback = function(delay)
			slayersSyneroxHub.Spin.Delay = delay
		end,
	})

	local v12 = v10:AddSection("Spin Status & Inventory")
	CurrentClanLabel = v12:AddLabel("CurrentClanLabel", "Current Clan: " .. tostring(v2))
	TotalSpinsLabel = v12:AddLabel("TotalSpinsLabel", "Spins Left: " .. tostring(v3))
	LastRollLabel = v12:AddLabel("LastRollLabel", "Last Rolled: None")

	if CurrentClanLabel then
		CurrentClanLabel:SetText("Current Clan: " .. tostring(v2))
	end

	if TotalSpinsLabel then
		TotalSpinsLabel:SetText("Spins Left: " .. tostring(v3))
	end

	if LastRollLabel then
		LastRollLabel:SetText("Last Rolled: None")
	end

	fn31()

	v12:AddButton({
		Title = "Spin Clan Once",
		Callback = function()
			if fn4() <= 0 then
				fn("Spin Notice", "No clan spins available!", 3)
				return
			end

			task.spawn(function()
				if SignalFunction and SignalEvent then
					local ok, result = pcall(function()
						return SignalFunction.ToServer("ClanSpin")
					end)

					if ok and typeof(result) == "string" then
						pcall(function()
							SignalEvent.ToServer("ClanSpinComplete")
						end)

						local name = Clans and Clans.TierOf(result)
						name = name and name.name or "Common"

						if LastRollLabel then
							LastRollLabel:SetText("Last Rolled: " .. result .. " (" .. name .. ")")
						end

						fn31()
						fn("Single Spin", "Rolled: " .. result .. " [" .. name .. "]", 4)

						if slayersSyneroxHub.Webhook and slayersSyneroxHub.Webhook.Enabled and slayersSyneroxHub.Webhook.ClanRerollNotify then
							local v13, v14 = GetClanRarity(result)
							local v15 = SendWebhookEmbed
							local str = "Single Clan Roll: " .. tostring(result)
							local str2 = string.format("**%s** rolled **%s** (%s)!", localPlayer.DisplayName, tostring(result), v13)
							local tbl14 = {}
							local tbl15 = { name = "Clan", value = "**" .. tostring(result) .. "**", inline = true }
							local tbl16 = { name = "Spins Remaining", value = tostring(fn4()), inline = true }
							tbl14[1] = tbl15
							tbl14[2] = { name = "Rarity", value = v13, inline = true }
							tbl14[3] = tbl16
							v15(str, str2, v14, tbl14)
						end
					end
				end
			end)
		end,
	})

	local v13, v14 = v8:AddSubTab("Discord Webhook"):AddColumns()
	local v15 = v13:AddSection("Discord Webhook Integration")

	v15:AddInput("DiscordWebhookURL", {
		Title = "Discord Webhook URL",
		Default = "",
		Placeholder = "https://discord.com/api/webhooks/...",
		Callback = function(url)
			slayersSyneroxHub.Webhook.Url = url
		end,
	})

	v15:AddButton({
		Title = "Test Discord Webhook",
		Callback = function()
			TestDiscordWebhook()
		end,
	})

	v15:AddToggle("EnableWebhookToggle", {
		Title = "Enable Discord Webhook",
		Default = false,
		Callback = function(enabled)
			slayersSyneroxHub.Webhook.Enabled = enabled

			if enabled then
				fn("Webhook", "Discord Webhook alerts active!")
			end
		end,
	})

	local v16 = v14:AddSection("Clan Reroll Notification Settings")

	v16:AddToggle("ClanRerollNotifyToggle", {
		Title = "Send Clan Reroll Embeds",
		Default = true,
		Callback = function(clanRerollNotify)
			slayersSyneroxHub.Webhook.ClanRerollNotify = clanRerollNotify
		end,
	})

	v16:AddDropdown("RerollRarityFilterDropdown", {
		Title = "Minimum Rarity to Send",
		Values = { "All Rolls", "Rare+", "Legendary+", "Supreme Only", "Desired Only" },
		Default = "Rare+",
		Callback = function(rerollMinRarity)
			slayersSyneroxHub.Webhook.RerollMinRarity = rerollMinRarity
		end,
	})

	v16:AddToggle("PingDiscordUserToggle", {
		Title = "Ping Discord User / Role",
		Default = false,
		Callback = function(pingUser)
			slayersSyneroxHub.Webhook.PingUser = pingUser
		end,
	})

	v16:AddInput("DiscordUserIDInput", {
		Title = "Discord User ID (For Pings)",
		Default = "",
		Placeholder = "123456789012345678",
		Callback = function(discordUserId)
			slayersSyneroxHub.Webhook.DiscordUserId = discordUserId
		end,
	})

	local v17, v18 = v8:AddSubTab("Blood Demon Arts"):AddColumns()
	local v19 = v17:AddSection("Auto BDA Spin (Demons)")

	AutoBDAToggle = v19:AddToggle("AutoBDAToggle", {
		Title = "Enable Fast BDA Spin",
		Default = false,
		Callback = function(arg)
			if arg then
				fn("Auto BDA Spin", "Fast Auto BDA Spin enabled!")
				fn36()
			else
				fn35(false)
			end
		end,
	})

	v19:AddDropdown("TargetBDADropdown", {
		Title = "Target Demon Art",
		Values = tbl13,
		Default = "Dream",
		Callback = function(targetBDA)
			slayersSyneroxHub.Spin.BDA.TargetBDA = targetBDA
		end,
	})

	v19:AddSlider("BDASpinDelaySlider", {
		Title = "BDA Spin Interval Delay",
		Min = 0.05,
		Max = 1,
		Default = 0.15,
		Rounding = 2,
		Suffix = "s",
		Callback = function(delay)
			slayersSyneroxHub.Spin.BDA.Delay = delay
		end,
	})

	local v20 = v18:AddSection("BDA Status & Inventory")
	CurrentBDALabel = v20:AddLabel("CurrentBDALabel", "Current BDA: " .. tostring(v4))
	TotalBDASpinsLabel = v20:AddLabel("TotalBDASpinsLabel", "BDA Spins Left: " .. tostring(v5) .. " (" .. tostring(math.floor(v5 / 3)) .. " Rolls)")
	local addLabel = v20.AddLabel
	local v21 = tostring
	local v22 = fn25()
	bdaRaceLabel = addLabel(v20, "BDARaceLabel", "Player Race: " .. v21(v22))
	LastBDARollLabel = v20:AddLabel("LastBDARollLabel", "Last Rolled BDA: None")

	if CurrentBDALabel then
		local v23 = CurrentBDALabel
		local setText = v23.SetText
		local v24 = tostring
		local v25 = fn5()
		setText(v23, "Current BDA: " .. v24(v25))
	end

	if TotalBDASpinsLabel then
		local v23 = fn6()
		TotalBDASpinsLabel:SetText("BDA Spins Left: " .. tostring(v23) .. " (" .. tostring(math.floor(v23 / 3)) .. " Rolls)")
	end

	if bdaRaceLabel then
		local v23 = bdaRaceLabel
		local setText = v23.SetText
		local v24 = tostring
		local v25 = fn25()
		setText(v23, "Player Race: " .. v24(v25))
	end

	if LastBDARollLabel then
		LastBDARollLabel:SetText("Last Rolled BDA: None")
	end

	fn34()

	v20:AddButton({
		Title = "Spin BDA Once",
		Callback = function()
			local v23 = fn6()
			if v23 < 3 then
				fn("BDA Spin", "Need at least 3 BDA spins to roll! (You have: " .. tostring(v23) .. ")", 4)
				return
			end
			local v24 = fn25()
			if v24 ~= "Demon" and v24 ~= "Hybrid" then
				fn("BDA Spin Notice", "Blood Demon Arts require Demon or Hybrid race! (Current: " .. tostring(v24) .. "). Become a Demon first!", 5)
				return
			end

			task.spawn(function()
				if SignalFunction and SignalEvent then
					local now = os.clock()

					while localPlayer:GetAttribute("PendingEvilArtSpin") ~= nil and os.clock() - now < 1.5 do
						task.wait(0.02)
					end

					local ok, lastRolled = pcall(function()
						return SignalFunction.ToServer("EvilArtSpin")
					end)

					if ok and typeof(lastRolled) == "string" then
						pcall(function()
							SignalEvent.ToServer("EvilArtSpinComplete")
						end)

						local now2 = os.clock()

						while localPlayer:GetAttribute("PendingEvilArtSpin") ~= nil and os.clock() - now2 < 0.5 do
							task.wait(0.02)
						end

						if LastBDARollLabel then
							LastBDARollLabel:SetText("Last Rolled: " .. lastRolled)
						end

						fn34()
						fn("Single BDA Spin", "Rolled BDA: " .. lastRolled, 4)
					else
						pcall(function()
							SignalEvent.ToServer("EvilArtSpinComplete")
						end)

						fn("BDA Spin Failed", "Server rejected roll. Check race / slot data.", 4)
					end
				end
			end)
		end,
	})
end

do
	local v8, v9 = v6:AddCategory("NOTIFIERS", "solar/bell-bold"):AddTab({ Title = "Notifiers", Icon = "solar/bell-bold" }):AddSubTab("World Notifiers"):AddColumns()
	local v10 = v8:AddSection("Server Event & Spawn Alerts")

	v10:AddToggle("MuzanNotifyToggle", {
		Title = "[ 〢 ] Muzan Notify",
		Default = true,
		Tooltip = "Alerts immediately when Muzan Kibutsuji spawns in the server at night!",
		Callback = function(muzan)
			slayersSyneroxHub.Notifiers.Muzan = muzan
		end,
	})

	v10:AddToggle("BlackMarketerNotifyToggle", {
		Title = "[ 〢 ] Black Marketer Notify",
		Default = true,
		Tooltip = "Alerts when the roaming Black Market dealer or Kuro is detected!",
		Callback = function(blackMarketer)
			slayersSyneroxHub.Notifiers.BlackMarketer = blackMarketer
		end,
	})

	v10:AddToggle("TailorRestocksNotifyToggle", {
		Title = "[ 〢 ] Tailor Restocks Notify",
		Default = true,
		Tooltip = "Alerts when the village tailor refreshes clothing & haori stocks!",
		Callback = function(tailorRestocks)
			slayersSyneroxHub.Notifiers.TailorRestocks = tailorRestocks
		end,
	})

	v10:AddToggle("FinalSelectionNotifyToggle", {
		Title = "[ 〢 ] Final Selection Notify",
		Default = true,
		Tooltip = "Alerts when the Final Selection examination trial opens!",
		Callback = function(finalSelection)
			slayersSyneroxHub.Notifiers.FinalSelection = finalSelection
		end,
	})

	v10:AddToggle("BossHuntsNotifyToggle", {
		Title = "[ 〢 ] Boss Hunts Notify",
		Default = true,
		Tooltip = "Alerts when special boss bounty hunts become active!",
		Callback = function(bossHunts)
			slayersSyneroxHub.Notifiers.BossHunts = bossHunts
		end,
	})

	v10:AddToggle("BossSpawnsNotifyToggle", {
		Title = "[ 〢 ] Boss Spawns Notify",
		Default = true,
		Tooltip = "Alerts whenever any tracked world boss respawns!",
		Callback = function(bossSpawns)
			slayersSyneroxHub.Notifiers.BossSpawns = bossSpawns
		end,
	})

	local v11 = v9:AddSection("Notifier Quick Actions")

	v11:AddButton({
		Title = "[ 〢 ] Teleport to Muzan",
		Callback = function()
			TeleportToMuzan()
		end,
	})

	v11:AddButton({
		Title = "[ 〢 ] Teleport to Black Market",
		Callback = function()
			FindAndTeleportBlackMarket()
		end,
	})

	v11:AddButton({
		Title = "Check All World Spawns Now",
		Callback = function()
			CheckWorldNotifiers()
			UpdateBossTimers()
			fn("Notifiers", "World scans completed!", 3)
		end,
	})
end

do
	local v8 = v6:AddCategory("TELEPORTS", "solar/map-point-bold"):AddTab({ Title = "Teleports", Icon = "solar/map-point-bold" })
	local v9, v10 = v8:AddSubTab("Regions & Shrines"):AddColumns()
	local v11 = v9:AddSection("Major Regions & Towns")

	for _, v12 in ipairs({
		{ Name = "Hidden Mist Village", Pos = Vector3.new(1651, 607.3, -124) },
		{ Name = "Mistfall Harbor", Pos = Vector3.new(140.7, 873.5, 728.2) },
		{ Name = "Bamboo Grove", Pos = Vector3.new(422, 1128, -915) },
		{ Name = "Windy Peak", Pos = Vector3.new(-456, 1241, -932) },
		{ Name = "Butterfly Estate", Pos = Vector3.new(-1772, 311.3, -110.9) },
		{ Name = "Iceveil Valley", Pos = Vector3.new(142.1, 1385.1, -2783.2) },
		{ Name = "Verdant Cliffs", Pos = Vector3.new(1775, 715, -425) },
		{ Name = "Forgotten Ruins", Pos = Vector3.new(-954, 950, 945.5) },
		{ Name = "Stone Sanctuary", Pos = Vector3.new(2564.1, 980, -590) },
		{ Name = "Final Selection Plains", Pos = Vector3.new(-1994.1, 750, 1050.1) },
	}) do
		v11:AddButton({
			Title = v12.Name,
			Callback = function()
				fn24(v12.Pos, v12.Name)
			end,
		})
	end

	local v12 = v10:AddSection("Shrines & Secret Locations")

	for _, v13 in ipairs({
		{ Name = "Akaza Cave (Infinity Passage)", Pos = Vector3.new(3880, 480, -1240) },
		{ Name = "Demon Slayer Corps HQ", Pos = Vector3.new(-2100, 320, -450) },
		{ Name = "Mount Natagumo Border", Pos = Vector3.new(1150, 920, 1420) },
		{ Name = "Underground Water Cavern", Pos = Vector3.new(620, 890, 110) },
	}) do
		v12:AddButton({
			Title = v13.Name,
			Callback = function()
				fn24(v13.Pos, v13.Name)
			end,
		})
	end

	local v13, v14 = v8:AddSubTab("Trainers & Masters"):AddColumns()
	local v15 = v13:AddSection("Select & Teleport")

	v15:AddDropdown("TrainerDropdown", {
		Title = "Select Trainer",
		Values = tbl11,
		Default = tbl11[1],
		Callback = function(arg)
			v7 = arg
		end,
	})

	v15:AddButton({
		Title = "Teleport to Selected Trainer",
		Callback = function()
			for _, v16 in ipairs(tbl10) do
				if v16.DisplayName == v7 or v16.Name == v7 then
					fn24(v16.Position, v16.DisplayName)
					return
				end
			end
		end,
	})

	local v16 = v14:AddSection("Quick Teleports")

	for i = 1, math.min(6, #tbl10) do
		local v17 = tbl10[i]

		v16:AddButton({
			Title = v17.DisplayName,
			Callback = function()
				fn24(v17.Position, v17.DisplayName)
			end,
		})
	end

	local v17, v18 = v8:AddSubTab("Miscellaneous NPCs"):AddColumns()
	local v19 = v17:AddSection("Black Market & Merchants")

	v19:AddButton({
		Title = "[ 〢 ] Teleport to Black Market (Auto Scan)",
		Description = "Scans server for dynamic roaming Black Market merchant & Kuro",
		Callback = function()
			FindAndTeleportBlackMarket()
		end,
	})

	v19:AddButton({
		Title = "TP Kuro the Black Merchant (Bamboo Grove)",
		Callback = function()
			fn24(Vector3.new(540, 1121, -1024), "Kuro (Bamboo Grove)")
		end,
	})

	v19:AddButton({
		Title = "Village Weapon Shop (Raze Katana Seller)",
		Callback = function()
			fn24(Vector3.new(-586.3, 1244.6, -1085.8), "Village Weapon Shop (Raze)")
		end,
	})

	v19:AddButton({
		Title = "Master Swordsmith / Blacksmith",
		Callback = function()
			fn24(Vector3.new(-1200, 950, 850), "Master Swordsmith")
		end,
	})

	v19:AddButton({
		Title = "Village Tailor (Haori & Outfits)",
		Callback = function()
			fn24(Vector3.new(-535, 1245, -1325), "Village Tailor")
		end,
	})

	v19:AddButton({
		Title = "Mask Merchant",
		Callback = function()
			fn24(Vector3.new(-650, 1250, -1180), "Mask Merchant")
		end,
	})

	v19:AddButton({
		Title = "Gourd Merchant (Breathing Mastery)",
		Callback = function()
			fn24(Vector3.new(-1798.9, 347.9, -189.3), "Gourd Merchant")
		end,
	})

	v19:AddButton({
		Title = "Angler Runo (Mistfall Harbor Fishing Dock)",
		Callback = function()
			fn24(Vector3.new(140.7, 873.5, 728.2), "Angler Runo (Mistfall Harbor)")
		end,
	})

	v19:AddButton({
		Title = "Butterfly Medical Clinic (Doctor)",
		Callback = function()
			fn24(Vector3.new(-1798.9, 347.9, -189.3), "Butterfly Medical Shop")
		end,
	})

	v19:AddButton({
		Title = "Horse Carriage Guy (Fast Travel)",
		Callback = function()
			fn24(Vector3.new(-715, 1260, -1120), "Horse Carriage Guy")
		end,
	})

	local v20 = v18:AddSection("Quest & Story NPCs")

	v20:AddButton({
		Title = "Grandpa Somi (Starter Quests)",
		Callback = function()
			fn24(Vector3.new(700, 1150, -1050), "Grandpa Somi")
		end,
	})

	v20:AddButton({
		Title = "Beth (Lost Daughter Quest)",
		Callback = function()
			fn24(Vector3.new(-690, 1261, -1200), "Beth")
		end,
	})

	v20:AddButton({
		Title = "Sabito (Boulder Split Trial)",
		Callback = function()
			fn24(Vector3.new(-1046.8, 1133.5, -628.8), "Sabito (Boulder Split)")
		end,
	})

	v20:AddButton({
		Title = "Doctor Ino / Tamayo Associate",
		Callback = function()
			fn24(Vector3.new(895, 1120, -880), "Doctor Ino")
		end,
	})

	v20:AddButton({
		Title = "Final Selection Examination Guides",
		Callback = function()
			fn24(Vector3.new(-1994.1, 750, 1050.1), "Final Selection Guides")
		end,
	})

	local v21 = v18:AddSection("Live NPC Teleporter & Scanner")
	local str = "Black Market Dealer"

	local tbl14 = {
		"Black Market Dealer",
		"Kuro the Black Merchant",
		"Village Weapon Shop (Raze)",
		"Master Swordsmith",
		"Village Tailor",
		"Mask Merchant",
		"Gourd Merchant",
		"Angler Runo",
		"Butterfly Medical Clinic",
		"Horse Carriage Guy",
		"Grandpa Somi",
		"Beth",
		"Sabito",
		"Doctor Ino",
		"Final Selection Guides",
	}

	local MiscNpcDropdown = v21:AddDropdown("MiscNpcDropdown", {
		Title = "Select Miscellaneous NPC",
		Values = tbl14,
		Default = tbl14[1],
		Callback = function(arg)
			str = arg
		end,
	})

	v21:AddButton({
		Title = "Teleport to Selected NPC",
		Callback = function()
			TeleportToMiscNpc(str)
		end,
	})

	v21:AddButton({
		Title = "Interact / Talk to Selected NPC",
		Tooltip = "Teleports to the NPC and automatically triggers their ProximityPrompt dialogue!",
		Callback = function()
			InteractWithMiscNpc(str)
		end,
	})

	v21:AddButton({
		Title = "Scan & Add Newly Loaded Server NPCs",
		Callback = function()
			local v22 = RefreshServerNpcList(MiscNpcDropdown)
			fn("NPC Scanner", string.format("Found %d active NPCs in the server!", v22), 4)
		end,
	})

	local v22, v23 = v8:AddSubTab("Special Locations"):AddColumns()
	local v24 = v22:AddSection("Rare Bosses & World Spawns")

	v24:AddButton({
		Title = "[ 〢 ] Teleport to Muzan",
		Callback = function()
			TeleportToMuzan()
		end,
	})

	v24:AddButton({
		Title = "Muzan's Lair (Throne Room)",
		Callback = function()
			fn24(Vector3.new(2466.3, 1079.3, 2334.5), "Muzan's Lair (Throne)")
		end,
	})

	v24:AddButton({
		Title = "Auto Collect Blue Spider Lily",
		Callback = function()
			if not fn8() then
				return
			end
			local n5 = 0

			for _, descendant in ipairs(Workspace:GetDescendants()) do
				if descendant.Name == "Blue Spider Lily" or descendant:GetAttribute("IsLily") then
					local isBasePart = descendant:IsA("BasePart") and descendant or descendant:FindFirstChildWhichIsA("BasePart", true)

					if isBasePart then
						fn24(isBasePart.Position + Vector3.new(0, 1.5, 0), "Blue Spider Lily")
						task.wait(0.3)

						pcall(function()
							local proximityPrompt = descendant:FindFirstChildWhichIsA("ProximityPrompt", true)

							if proximityPrompt then
								fireproximityprompt(proximityPrompt)
							end
						end)

						n5 += 1
					end
				end
			end

			if n5 > 0 then
				fn("Blue Spider Lily", string.format("Harvested %d lilies!", n5), 4)
			else
				fn("Blue Spider Lily", "No Blue Spider Lilies found in the world.", 3)
			end
		end,
	})

	local v25 = v23:AddSection("Dungeons & Shrines")

	v25:AddButton({
		Title = "TP to Ouwigahara Portal",
		Callback = function()
			fn24(Vector3.new(-1607.1, 1018, 1142.4), "Ouwigahara Dungeon Portal")
		end,
	})

	v25:AddButton({
		Title = "TP to Final Selection Plains",
		Callback = function()
			fn24(Vector3.new(-1994.1, 750, 1050.1), "Final Selection Plains")
		end,
	})

	v25:AddButton({
		Title = "Akaza Cave (Infinity Passage)",
		Callback = function()
			fn24(Vector3.new(3880, 480, -1240), "Akaza Cave")
		end,
	})

	v25:AddButton({
		Title = "Underground Water Cavern",
		Callback = function()
			fn24(Vector3.new(620, 890, 110), "Underground Water Cavern")
		end,
	})

	v25:AddButton({
		Title = "TP to Mistfall Harbor Fishing Dock",
		Callback = function()
			fn24(Vector3.new(982, 278, -2824), "Mistfall Harbor Fishing Dock")
		end,
	})
end

	local miscTab = v6:AddCategory("MISC", "solar/settings-bold"):AddTab({ Title = "Misc", Icon = "solar/settings-bold" })

do
	local v8, v9 = miscTab:AddSubTab("Visuals & ESP"):AddColumns()
	local v10 = v8:AddSection("Chams / ESP Highlights")

	v10:AddToggle("MobESPToggle", {
		Title = "Monsters & Bosses ESP",
		Default = true,
		Callback = function(mobESP)
			slayersSyneroxHub.Visuals.MobESP = mobESP

			if not mobESP then
				for k, espHighlight in pairs(slayersSyneroxHub.ESPHighlights) do
					if k and not Players:GetPlayerFromCharacter(k) then
						pcall(function()
							espHighlight:Destroy()
						end)

						slayersSyneroxHub.ESPHighlights[k] = nil
					end
				end
			end
		end,
	})

	v10:AddToggle("PlayerESPToggle", {
		Title = "Players ESP",
		Default = false,
		Callback = function(playerESP)
			slayersSyneroxHub.Visuals.PlayerESP = playerESP

			if not playerESP then
				for k, espHighlight in pairs(slayersSyneroxHub.ESPHighlights) do
					if k and Players:GetPlayerFromCharacter(k) then
						pcall(function()
							espHighlight:Destroy()
						end)

						slayersSyneroxHub.ESPHighlights[k] = nil
					end
				end
			end
		end,
	})

	v9:AddSection("ESP Appearance"):AddToggle("ESPBoxesToggle", {
		Title = "Show Adornment Outlines",
		Default = true,
		Callback = function(espBoxes)
			slayersSyneroxHub.Visuals.ESPBoxes = espBoxes
		end,
	})
end

do
	local v9, v10 = miscTab:AddSubTab("Movement & Lifecycle"):AddColumns()
	local v11 = v9:AddSection("Movement Controls")

	v11:AddSlider("WalkSpeedSlider", {
		Title = "WalkSpeed Multiplier",
		Min = 16,
		Max = 150,
		Default = 16,
		Rounding = 0,
		Callback = function(speed)
			slayersSyneroxHub.Misc.Speed = speed
			local v12 = fn9()

			if v12 then
				v12.WalkSpeed = speed
			end
		end,
	})

	v11:AddSlider("JumpPowerSlider", {
		Title = "JumpPower Override",
		Min = 50,
		Max = 250,
		Default = 50,
		Rounding = 0,
		Callback = function(jumpPower)
			slayersSyneroxHub.Misc.JumpPower = jumpPower
			local v12 = fn9()

			if v12 then
				v12.UseJumpPower = true
				v12.JumpPower = jumpPower
			end
		end,
	})

	v11:AddToggle("NoClipToggle", {
		Title = "NoClip (Pass Through Walls)",
		Default = false,
		Callback = function(noClip)
			slayersSyneroxHub.Misc.NoClip = noClip
		end,
	})

	v11:AddToggle("InfJumpToggle", {
		Title = "Infinite Jump",
		Default = false,
		Callback = function(infiniteJump)
			slayersSyneroxHub.Misc.InfiniteJump = infiniteJump
		end,
	})

	v10:AddSection("Menu & Lifecycle"):AddButton({
		Title = "Unload Synerox Hub",
		Callback = function()
			slayersSyneroxHub:Destroy()

			if v and v.Destroy then
				pcall(function()
					v:Destroy()
				end)
			end
		end,
	})
end

table.insert(slayersSyneroxHub.Connections, UserInputService.JumpRequest:Connect(function()
	if slayersSyneroxHub.Misc.InfiniteJump then
		local v8 = fn9()

		if v8 then
			v8:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end))

table.insert(slayersSyneroxHub.Connections, RunService.Stepped:Connect(function()
	if slayersSyneroxHub.Misc.NoClip then
		local character = localPlayer.Character

		if character then
			for _, descendant in ipairs(character:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant.CanCollide then
					descendant.CanCollide = false
				end
			end
		end
	end
end))

table.insert(slayersSyneroxHub.Connections, RunService.Heartbeat:Connect(function()
	local character = localPlayer.Character
	local v8 = fn9()

	if v8 and character then
		if slayersSyneroxHub.Misc.CustomSpeed then
			v8.WalkSpeed = slayersSyneroxHub.Misc.WalkSpeed
		end

		if slayersSyneroxHub.Combat.InfStamina then
			local stamina = fn7()
			stamina = stamina and stamina:FindFirstChild("Stamina")
			local flag3

			if stamina then
				flag3 = stamina.Value < (stamina.MaxValue or 220)
			else
				flag3 = stamina
			end

			if flag3 then
				stamina.Value = stamina.MaxValue or 220
			end
		end
	end
end))

do
	local n5 = 0
	local n6 = 0
	local n7 = 0
	local n8 = 0
	local position = nil
	local n9 = 0
	local position2 = nil
	local n10 = 0
	local n11 = 0
	local name = nil

	table.insert(slayersSyneroxHub.Connections, RunService.Heartbeat:Connect(function()
		local now = os.clock()

		if slayersSyneroxHub.Farm.AutoQuest and now - n8 >= 2 then
			n8 = now
			local v8 = fn26()
			local v9 = fn27()
			local v10 = nil

			if slayersSyneroxHub.Farm.QuestMode == "Auto Best Quest (By Level)" then
				v10 = fn30(v8)
			else
				for _, v11 in ipairs(tbl4) do
					if v11.DisplayName == slayersSyneroxHub.Farm.QuestMode then
						v10 = v11
						break
					end
				end
			end

			if v10 and type(v10.MinLevel) == "number" and v8 < v10.MinLevel then
				if name ~= v10.Name then
					name = v10.Name

					fn({
						Title = "Auto Quest",
						Content = string.format("%s requires Lv %d (you are %d). Pick another quest.", v10.DisplayName, v10.MinLevel, v8),
						Type = "warning",
						Duration = 6,
					})
				end

				v10 = nil
			end

			if v9 then
				if v9.IsFinished then
					fn28()
					slayersSyneroxHub.LockedTarget = nil
					slayersSyneroxHub.CurrentTarget = nil
					n8 = now + 1
					v9 = nil
				elseif slayersSyneroxHub.Farm.QuestMode ~= "Auto Best Quest (By Level)" and v10 then
					local v11 = string.lower(string.gsub(v9.QuestString or v9.Name, "%s+", ""))
					local v12 = string.lower(string.gsub(v10.Name, "%s+", ""))

					if not v11:find(v12) and not v12:find(v11) then
						fn28()
						slayersSyneroxHub.LockedTarget = nil
						slayersSyneroxHub.CurrentTarget = nil
						n8 = now + 1
						v9 = nil
					end
				end
			end

			if not v9 and not slayersSyneroxHub.IsInteractingQuest then
				if v10 and now - n3 >= 3 then
					n3 = now

					task.spawn(function()
						local v11 = fn29(v10.Name)
						if not slayersSyneroxHub.Farm.AutoQuest then
							return
						end

						if v11 then
							n11 = 0
							name = nil

							fn({
								Title = "Quest Accepted",
								Content = string.format("Accepted: %s", v10.DisplayName),
								Type = "success",
							})

							slayersSyneroxHub.Farm.TargetMob = v10.MobName
							slayersSyneroxHub.Farm.MobCategory = v10.Category
							slayersSyneroxHub.Farm.RegionFilter = v10.Region
							slayersSyneroxHub.LockedTarget = nil
							slayersSyneroxHub.CurrentTarget = nil

							if v10.MobWp then
								fn24(v10.MobWp, v10.MobName .. " Area")
								local v12 = fn8()

								if v12 then
									pcall(function()
										require(ReplicatedStorage.CAM.Global.Subsets.Areas.AreaLocator):Update(v12)
									end)
								end
							end
						else
							if name == v10.Name then
								n11 += 1
							else
								name = v10.Name
								n11 = 1
							end

							if n11 >= 3 then
								slayersSyneroxHub.Farm.AutoQuest = false
								slayersSyneroxHub.Farm.AutoFarm = false
								slayersSyneroxHub.IsInteractingQuest = false
								fn37(AutoQuestToggle, false)
								fn37(AutoFarmToggle, false)

								fn({
									Title = "Auto Quest",
									Content = "Could not accept quest 3 times - auto disabled for safety.",
									Type = "error",
									Duration = 7,
								})
							end
						end
					end)
				end
			end

			if v9 and not v9.IsFinished and not slayersSyneroxHub.IsInteractingQuest then
				local mobName = nil
				local mobCategory = "Normal"
				local regionFilter = "All"
				local mobWp = nil

				for k, task_ in pairs(v9.Tasks) do
					if not (task_.Current < task_.Max) then
						continue
					else
						for _, v11 in ipairs(tbl4) do
							if v11.Tasks[k] then
								mobName = v11.Tasks[k]
								mobCategory = v11.Category
								regionFilter = v11.Region
								mobWp = v11.MobWp
								break
							end
						end

						if not mobName then
							continue
						end
					end

					break
				end

				if not mobName then
					for k, task_ in pairs(v9.Tasks) do
						if not (task_.Current < task_.Max) then
							continue
						else
							local v11 = string.lower(k)

							for _, v12 in ipairs(tbl4) do
								if v11:find(string.lower(v12.MobName)) then
									mobName = v12.MobName
									mobCategory = v12.Category
									regionFilter = v12.Region
									mobWp = v12.MobWp
									break
								end
							end

							if not mobName then
								continue
							end
						end

						break
					end
				end

				if not mobName then
					local v11 = string.lower(v9.Name or "")
					local v12 = string.lower(v9.QuestString or "")

					for _, v13 in ipairs(tbl4) do
						local v14 = string.lower(v13.MobName)
						local v15 = string.lower(v13.Name)
						local v16 = string.lower(v13.QuestInstanceName or "")

						if v13.Name == v9.QuestString or v13.QuestInstanceName == v9.Name or v11:find(v14) or v12:find(v14) or v15:find(v11) or v16:find(v11) then
							mobName = v13.MobName
							mobCategory = v13.Category
							regionFilter = v13.Region
							mobWp = v13.MobWp
							break
						end
					end
				end

				if mobName then
					if slayersSyneroxHub.Farm.TargetMob ~= mobName then
						slayersSyneroxHub.Farm.TargetMob = mobName
						slayersSyneroxHub.Farm.MobCategory = mobCategory
						slayersSyneroxHub.Farm.RegionFilter = regionFilter
						slayersSyneroxHub.LockedTarget = nil
						slayersSyneroxHub.CurrentTarget = nil
					end

					local v11 = fn8()

					if v11 and mobWp and (v11.Position - mobWp).Magnitude > 90 then
						local v12 = fn14()
						local flag3 = false

						for _, v13 in ipairs(v12) do
							if fn16(v13, mobName, regionFilter, mobCategory) and (v13.Root.Position - v11.Position).Magnitude <= 80 then
								flag3 = true
								break
							end
						end

						if not flag3 then
							fn24(mobWp, mobName .. " Area")
							local v13 = fn8()

							if v13 then
								pcall(function()
									require(ReplicatedStorage.CAM.Global.Subsets.Areas.AreaLocator):Update(v13)
								end)
							end
						end
					end
				end
			end
		end

		if slayersSyneroxHub.Farm.AutoFarm and not slayersSyneroxHub.IsInteractingQuest and not slayersSyneroxHub.IsCollectingLoot then
			local v8 = fn8()
			local v9 = fn9()

			if v8 and v9 and v9.Health > 0 then
				if fn10() then
					fn23()
				else
					local lockedTarget = slayersSyneroxHub.LockedTarget

					if slayersSyneroxHub.Farm.TargetLock and lockedTarget then
						if not fn16(lockedTarget, slayersSyneroxHub.Farm.TargetMob, slayersSyneroxHub.Farm.RegionFilter, slayersSyneroxHub.Farm.MobCategory) then
							if lockedTarget.Root then
								if fn15(lockedTarget) then
									position = lockedTarget.Root.Position
									n9 = now

									if type(slayersSyneroxHub.Farm.SelectedBosses) == "table" and #slayersSyneroxHub.Farm.SelectedBosses > 1 then
										local v10 = fn18(slayersSyneroxHub.Farm.SelectedBosses, slayersSyneroxHub.Farm.RegionFilter)

										if v10 then
											for i, selectedBosse in ipairs(slayersSyneroxHub.Farm.SelectedBosses) do
												if fn16(v10, selectedBosse, "All", "Boss") then
													n = i
													break
												end
											end

											n2 = now
											slayersSyneroxHub.LockedTarget = v10
											lockedTarget = v10
										else
											n = n % #slayersSyneroxHub.Farm.SelectedBosses + 1
											n2 = now
										end
									end
								else
									local str = (lockedTarget.Name or ""):lower()

									if str:find("demon") or str:find("lost") or str:find("beast") then
										position2 = lockedTarget.Root.Position
										n10 = now
									end
								end
							end

							if not slayersSyneroxHub.LockedTarget or slayersSyneroxHub.LockedTarget == lockedTarget and not fn16(lockedTarget, slayersSyneroxHub.Farm.TargetMob, slayersSyneroxHub.Farm.RegionFilter, slayersSyneroxHub.Farm.MobCategory) then
								slayersSyneroxHub.LockedTarget = nil
								lockedTarget = nil
							end
						end
					else
						lockedTarget = nil
					end

					local bossLootWaitTime = slayersSyneroxHub.Farm.BossLootWaitTime or 4
					local mobLootWaitTime = slayersSyneroxHub.Farm.MobLootWaitTime or 1.8
					local flag3 = (slayersSyneroxHub.Farm.AutoCollectChests or slayersSyneroxHub.Farm.AutoCollectLoot or slayersSyneroxHub.Farm.AutoCollectSouls) and position and now - n9 < bossLootWaitTime
					local flag4 = (slayersSyneroxHub.Farm.AutoCollectSouls or slayersSyneroxHub.Farm.AutoCollectLoot) and position2 and now - n10 < mobLootWaitTime
					flag4 = flag3 or flag4
					local v10 = flag3 and position or position2

					if not lockedTarget and not flag4 then
						lockedTarget = fn17(slayersSyneroxHub.Farm.TargetMob, slayersSyneroxHub.Farm.RegionFilter, slayersSyneroxHub.Farm.MobCategory)
						slayersSyneroxHub.LockedTarget = lockedTarget
					end

					if flag4 and not lockedTarget and v10 then
						local cframe = CFrame.new(v10 + Vector3.new(0, slayersSyneroxHub.Farm.HeightOffset or 2.5, 0), v10)
						v8.CFrame = cframe
						v8.AssemblyLinearVelocity = Vector3.zero
						v8.AssemblyAngularVelocity = Vector3.zero
						fn22(cframe)
					elseif lockedTarget and lockedTarget.Root and lockedTarget.Humanoid and lockedTarget.Humanoid.Health > 0 and lockedTarget.Root.Position.Y > -400 then
						slayersSyneroxHub.CurrentTarget = lockedTarget
						local root = lockedTarget.Root
						local position3 = root.Position
						local heightOffset = slayersSyneroxHub.Farm.HeightOffset or 2.5
						local cframe

						if slayersSyneroxHub.Farm.SafeMode == "Overhead" then
							cframe = CFrame.new(position3 + Vector3.new(0, heightOffset, 0), position3)
						else
							local lookVector = root.CFrame.LookVector
							local vector = Vector3.new(lookVector.X, 0, lookVector.Z)
							local unit

							if vector.Magnitude > 0.001 then
								unit = vector.Unit
							else
								unit = Vector3.new(0, 0, 1)
							end

							local n12 = position3 + unit * (slayersSyneroxHub.Farm.Distance or 2)
							cframe = CFrame.new(n12, Vector3.new(position3.X, n12.Y, position3.Z))
						end

						v8.CFrame = cframe
						v8.AssemblyLinearVelocity = Vector3.zero
						v8.AssemblyAngularVelocity = Vector3.zero
						fn22(cframe)

						if slayersSyneroxHub.Farm.AutoM1 and now - n5 >= 0.28 then
							n5 = now
							fn13(slayersSyneroxHub.Farm.MultiHit and (slayersSyneroxHub.Farm.MultiHitCount or 3) or 1)
						end

						if slayersSyneroxHub.Farm.AutoSkills then
							fn12()
						end
					else
						slayersSyneroxHub.CurrentTarget = nil
						slayersSyneroxHub.LockedTarget = nil
						local flag5 = not flag3

						if flag5 then
							fn23()
						end

						if flag5 and slayersSyneroxHub.Farm.AutoTravelToRegion and not slayersSyneroxHub.IsCollectingLoot and not slayersSyneroxHub.IsInteractingQuest and now - n6 >= 2.5 then
							n6 = now
							local position3 = v8.Position
							local tbl14 = {}

							if type(slayersSyneroxHub.Farm.SelectedBosses) == "table" and #slayersSyneroxHub.Farm.SelectedBosses > 0 then
								for _, selectedBosse in ipairs(slayersSyneroxHub.Farm.SelectedBosses) do
									if selectedBosse ~= "All Bosses" and selectedBosse ~= "All" and selectedBosse ~= "" then
										table.insert(tbl14, selectedBosse)
									end
								end
							elseif type(slayersSyneroxHub.Farm.BossMob) == "string" and slayersSyneroxHub.Farm.BossMob ~= "All Bosses" and slayersSyneroxHub.Farm.BossMob ~= "All" then
								table.insert(tbl14, slayersSyneroxHub.Farm.BossMob)
							end

							local targetMob, position4

							if slayersSyneroxHub.Farm.MobCategory == "Boss" and #tbl14 > 0 then
								local v11 = fn18(tbl14, slayersSyneroxHub.Farm.RegionFilter)

								if v11 then
									targetMob = nil

									for i, v12 in ipairs(tbl14) do
										if fn16(v11, v12, "All", "Boss") then
											n = i
											targetMob = v12
											break
										else
											targetMob = nil
										end
									end

									targetMob = targetMob or tbl14[n] or tbl14[1]
									n2 = now
									position4 = v11.Root and v11.Root.Position or tbl3[targetMob]
								else
									if #tbl14 > 1 and now - n2 >= (slayersSyneroxHub.Farm.BossRotationInterval or 15) then
										n = n % #tbl14 + 1
										n2 = now
									end

									if n > #tbl14 then
										n = 1
									end

									targetMob = tbl14[n]
									position4 = tbl3[targetMob]
								end

								if not position4 then
									local v12 = string.lower(targetMob)
									local v13 = string.gsub(v12, "%s+", "")

									for k, v14 in pairs(tbl3) do
										local v15 = string.lower(k)
										local v16 = string.gsub(v15, "%s+", "")
										if v15 == v12 or v16 == v13 or string.find(v15, v12) or string.find(v12, v15) then
											position4 = v14
											break
										end
									end
								end
							else
								local flag6 = slayersSyneroxHub.Farm.TargetMob and slayersSyneroxHub.Farm.TargetMob ~= "All" and type(slayersSyneroxHub.Farm.TargetMob) == "string"
								position4 = nil
								targetMob = nil

								if flag6 then
									targetMob = slayersSyneroxHub.Farm.TargetMob
									position4 = tbl3[targetMob]

									if not position4 then
										local v11 = string.lower(targetMob)
										local v12 = string.gsub(v11, "%s+", "")

										for k, v13 in pairs(tbl3) do
											local v14 = string.lower(k)
											local v15 = string.gsub(v14, "%s+", "")
											if v14 == v11 or v15 == v12 or string.find(v14, v11) or string.find(v11, v14) then
												position4 = v13
												break
											end
										end
									end
								end
							end

							if position4 then
								if (position3 - position4).Magnitude > 60 then
									fn24(position4, (targetMob or "Boss") .. " Spawn")
								end
							elseif slayersSyneroxHub.Farm.RegionFilter ~= "All" then
								local v11 = tbl2[slayersSyneroxHub.Farm.RegionFilter]

								if v11 and (position3 - v11).Magnitude > 80 then
									fn24(v11, slayersSyneroxHub.Farm.RegionFilter)
								end
							end
						end
					end
				end
			end
		elseif not slayersSyneroxHub.Farm.PlayerFarm then
			slayersSyneroxHub.LockedTarget = nil
			slayersSyneroxHub.CurrentTarget = nil
			fn23()
		end

		if slayersSyneroxHub.Farm.PlayerFarm and not slayersSyneroxHub.IsInteractingQuest and not slayersSyneroxHub.IsCollectingLoot then
			local v8 = fn8()
			local v9 = fn9()

			if v8 and v9 and v9.Health > 0 then
				if fn10() then
					fn23()
				else
					local lockedTarget = slayersSyneroxHub.LockedTarget

					if lockedTarget and lockedTarget.Type == "Player" then
						if not fn19(lockedTarget, slayersSyneroxHub.Farm.SelectedPlayer) then
							slayersSyneroxHub.LockedTarget = nil
							lockedTarget = nil
						end
					else
						lockedTarget = nil
					end

					if not lockedTarget then
						local v10 = fn20(slayersSyneroxHub.Farm.SelectedPlayer)
						slayersSyneroxHub.LockedTarget = v10
						lockedTarget = v10
					end

					if lockedTarget and lockedTarget.Position and lockedTarget.Position.Y > 0 and lockedTarget.Position.Y < 2500 then
						if not lockedTarget.Root and lockedTarget.Model then
							lockedTarget.Root = lockedTarget.Model:FindFirstChild("HumanoidRootPart") or lockedTarget.Model:FindFirstChild("Torso")
						end

						local position3 = lockedTarget.Root and lockedTarget.Root.Position or lockedTarget.Position
						local magnitude = (v8.Position - position3).Magnitude

						if magnitude > 40 then
							v8.AssemblyLinearVelocity = Vector3.zero
							v8.AssemblyAngularVelocity = Vector3.zero
							v8.CFrame = CFrame.new(position3 + Vector3.new(0, (slayersSyneroxHub.Farm.PlayerHeightOffset or 3.2) + 1, 0))
							fn22(v8.CFrame)
						end

						slayersSyneroxHub.CurrentTarget = lockedTarget
						local playerHeightOffset = slayersSyneroxHub.Farm.PlayerHeightOffset or 3.2
						local lookVector = lockedTarget.Root and lockedTarget.Root.CFrame.LookVector or lockedTarget.CFrame and lockedTarget.CFrame.LookVector or Vector3.new(0, 0, 1)
						local vector = Vector3.new(lookVector.X, 0, lookVector.Z)
						local vector2

						if vector.Magnitude < 0.01 then
							vector2 = Vector3.new(0, 0, 1)
						else
							vector2 = vector.Unit
						end

						local cFrame

						if slayersSyneroxHub.Farm.PlayerSafeMode == "Overhead" then
							local n12 = position3 + Vector3.new(0, playerHeightOffset, 0)
							cFrame = CFrame.lookAt(n12, n12 + vector2) * CFrame.Angles(-0.78539816339744828, 0, 0)
						else
							cFrame = CFrame.lookAt(position3 + vector2 * (slayersSyneroxHub.Farm.PlayerDistance or 2.5), position3)
						end

						v8.CFrame = cFrame
						v8.AssemblyLinearVelocity = Vector3.zero
						v8.AssemblyAngularVelocity = Vector3.zero
						fn22(cFrame)

						if slayersSyneroxHub.Farm.AutoM1 and magnitude <= 30 and now - n5 >= 0.28 then
							n5 = now
							fn13(slayersSyneroxHub.Farm.MultiHit and (slayersSyneroxHub.Farm.MultiHitCount or 3) or 1)
						end

						if slayersSyneroxHub.Farm.AutoSkills and magnitude <= 30 then
							fn12()
						end
					else
						slayersSyneroxHub.CurrentTarget = nil
						slayersSyneroxHub.LockedTarget = nil
						fn23()
					end
				end
			end
		end

		local flag3 = position

		if position then
			flag3 = now - n9 < (slayersSyneroxHub.Farm.BossLootWaitTime or 5)
		end

		if not flag3 then
			flag3 = position2

			if position2 then
				flag3 = now - n10 < (slayersSyneroxHub.Farm.MobLootWaitTime or 2.5)
			end
		end

		if (slayersSyneroxHub.Farm.AutoCollectChests or slayersSyneroxHub.Farm.AutoCollectLoot or slayersSyneroxHub.Farm.AutoCollectSouls) and not slayersSyneroxHub.IsCollectingLoot and now - n7 >= (flag3 and 0.15 or 0.5) then
			n7 = now
			local v8 = fn8()
			local v9 = fn9()

			if v8 and v9 and v9.Health > 0 then
				local position3 = v8.Position
				local userId = localPlayer.UserId
				local flag4 = position

				if position then
					flag4 = now - n9 < (slayersSyneroxHub.Farm.BossLootWaitTime or 5)
				end

				flag4 = flag4 and position
				local v10

				if flag4 then
					v10 = flag4
				else
					local flag5 = position2

					if position2 then
						flag5 = now - n10 < (slayersSyneroxHub.Farm.MobLootWaitTime or 2.5)
					end

					v10 = flag5 and position2 or position3
				end

				local function fn38(arg, arg2, arg3)
					local n12 = tick() + (arg3 or 6)
					local lootDrops = Workspace:FindFirstChild("LootDrops")
					local CollectionService = game:GetService("CollectionService")

					while true do
						if tick() < n12 and slayersSyneroxHub.Alive then
							local v11 = fn8()

							if v11 then
								local position4 = v11.Position
								local tbl14 = {}

								local function fn39(arg4)
									if not arg4 or not arg4.Parent then
										return
									end

									if arg4:FindFirstAncestor("Regions") or arg4:FindFirstAncestor("StationaryNpcs") then
										return
									end

									if arg4.Name == "Regions" or arg4.Name == "Debree" then
										return
									end

									if arg4:GetAttribute("DropClaimedBy") ~= nil then
										return
									end

									if not (arg4:GetAttribute("DropItemId") ~= nil or arg4.Parent == lootDrops or CollectionService:HasTag(arg4, "LootDrop")) then
										return
									end
									local attribute = arg4:GetAttribute("DropOwnerUserId")
									local attribute2 = arg4:GetAttribute("DropReservedFor")
									local flag5 = attribute == nil or attribute == userId or attribute == 0

									if attribute2 then
										local str = "," .. userId .. ","
										attribute2 = not string.find(tostring(attribute2), str, 1, true)
									end

									if attribute2 then
										flag5 = false
									end

									if not flag5 then
										return
									end
									local attribute3 = arg4:GetAttribute("DropTarget")
									local isBasePart = arg4:IsA("BasePart") and arg4 or arg4:FindFirstChild("Handle") or arg4:FindFirstChildWhichIsA("BasePart", true)
									local position5 = typeof(attribute3) == "Vector3" and attribute3 or isBasePart and isBasePart.Position or arg4:IsA("Model") and arg4:GetPivot().Position
									if not position5 then
										return
									end
									local magnitude = (position5 - (arg or position4)).Magnitude

									if magnitude <= (arg2 or 350) then
										table.insert(tbl14, { Item = arg4, Part = isBasePart, Pos = position5, Dist = magnitude })
									end
								end

								if lootDrops then
									for _, child in ipairs(lootDrops:GetChildren()) do
										fn39(child)
									end
								end

								for _, v12 in ipairs(CollectionService:GetTagged("LootDrop")) do
									if not lootDrops or v12.Parent ~= lootDrops then
										fn39(v12)
									end
								end

								local flag5, item, part, pos, parent, flag6, cframe, proximityPrompt, holdDuration, maxActivationDistance, flag7, keyboardKeyCode, flag8

								if #tbl14 ~= 0 then
									table.sort(tbl14, function(arg4, arg5)
										return arg4.Dist < arg5.Dist
									end)

									flag5 = false

									for _, v12 in ipairs(tbl14) do
										item = v12.Item
										part = v12.Part
										pos = v12.Pos
										parent = item and item.Parent
										flag6 = parent and item:GetAttribute("DropClaimedBy") == nil and v11

										if flag6 then
											cframe = CFrame.new(pos + Vector3.new(0, 1.2, 0))
											v11.CFrame = cframe
											v11.AssemblyLinearVelocity = Vector3.zero
											v11.AssemblyAngularVelocity = Vector3.zero
											fn22(cframe)
											proximityPrompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)

											if proximityPrompt then
												proximityPrompt.Enabled = true
												holdDuration = proximityPrompt.HoldDuration
												maxActivationDistance = proximityPrompt.MaxActivationDistance
												proximityPrompt.HoldDuration = 0
												proximityPrompt.MaxActivationDistance = 60
												pcall(fireproximityprompt, proximityPrompt, 0)
												pcall(fireproximityprompt, proximityPrompt)
												flag7 = proximityPrompt.KeyboardKeyCode ~= Enum.KeyCode.Unknown
												keyboardKeyCode = flag7 and proximityPrompt.KeyboardKeyCode or Enum.KeyCode.T

												if VirtualInputManager then
													VirtualInputManager:SendKeyEvent(true, keyboardKeyCode, false, game)
													task.wait(0.05)
													VirtualInputManager:SendKeyEvent(false, keyboardKeyCode, false, game)
												end

												pcall(function()
													proximityPrompt.HoldDuration = holdDuration
													proximityPrompt.MaxActivationDistance = maxActivationDistance
												end)
											end

											if part then
												pcall(function()
													firetouchinterest(v11, part, 0)
													task.wait(0.02)
													firetouchinterest(v11, part, 1)
												end)
											end

											task.wait(0.14)
											flag8 = item and item.Parent and item:GetAttribute("DropClaimedBy") == nil

											if flag8 then
												if proximityPrompt then
													proximityPrompt.Enabled = true
													pcall(fireproximityprompt, proximityPrompt, 0)
													pcall(fireproximityprompt, proximityPrompt)
												end

												if part then
													pcall(function()
														firetouchinterest(v11, part, 0)
														task.wait(0.02)
														firetouchinterest(v11, part, 1)
													end)
												end

												task.wait(0.08)
											end

											flag5 = true
										end
									end

									if flag5 then
										task.wait(0.08)
										continue
									end
								else
									task.wait(0.25)

									if lootDrops then
										for _, child in ipairs(lootDrops:GetChildren()) do
											fn39(child)
										end
									end

									for _, v12 in ipairs(CollectionService:GetTagged("LootDrop")) do
										if not lootDrops or v12.Parent ~= lootDrops then
											fn39(v12)
										end
									end

									if #tbl14 ~= 0 then
										table.sort(tbl14, function(arg4, arg5)
											return arg4.Dist < arg5.Dist
										end)

										flag5 = false

										for _, v12 in ipairs(tbl14) do
											item = v12.Item
											part = v12.Part
											pos = v12.Pos
											parent = item and item.Parent
											flag6 = parent and item:GetAttribute("DropClaimedBy") == nil and v11

											if flag6 then
												cframe = CFrame.new(pos + Vector3.new(0, 1.2, 0))
												v11.CFrame = cframe
												v11.AssemblyLinearVelocity = Vector3.zero
												v11.AssemblyAngularVelocity = Vector3.zero
												fn22(cframe)
												proximityPrompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)

												if proximityPrompt then
													proximityPrompt.Enabled = true
													holdDuration = proximityPrompt.HoldDuration
													maxActivationDistance = proximityPrompt.MaxActivationDistance
													proximityPrompt.HoldDuration = 0
													proximityPrompt.MaxActivationDistance = 60
													pcall(fireproximityprompt, proximityPrompt, 0)
													pcall(fireproximityprompt, proximityPrompt)
													flag7 = proximityPrompt.KeyboardKeyCode ~= Enum.KeyCode.Unknown
													keyboardKeyCode = flag7 and proximityPrompt.KeyboardKeyCode or Enum.KeyCode.T

													if VirtualInputManager then
														VirtualInputManager:SendKeyEvent(true, keyboardKeyCode, false, game)
														task.wait(0.05)
														VirtualInputManager:SendKeyEvent(false, keyboardKeyCode, false, game)
													end

													pcall(function()
														proximityPrompt.HoldDuration = holdDuration
														proximityPrompt.MaxActivationDistance = maxActivationDistance
													end)
												end

												if part then
													pcall(function()
														firetouchinterest(v11, part, 0)
														task.wait(0.02)
														firetouchinterest(v11, part, 1)
													end)
												end

												task.wait(0.14)
												flag8 = item and item.Parent and item:GetAttribute("DropClaimedBy") == nil

												if flag8 then
													if proximityPrompt then
														proximityPrompt.Enabled = true
														pcall(fireproximityprompt, proximityPrompt, 0)
														pcall(fireproximityprompt, proximityPrompt)
													end

													if part then
														pcall(function()
															firetouchinterest(v11, part, 0)
															task.wait(0.02)
															firetouchinterest(v11, part, 1)
														end)
													end

													task.wait(0.08)
												end

												flag5 = true
											end
										end

										if flag5 then
											task.wait(0.08)
											continue
										end
									end
								end
							end
						end

						break
					end
				end

				local v11 = nil
				local v12 = nil
				local v13 = nil

				if slayersSyneroxHub.Farm.AutoCollectChests then
					local function fn39(arg, arg2)
						if not arg or not arg2 or not arg:IsA("ProximityPrompt") then
							return false
						end

						if not arg.Parent then
							return false
						end

						if (arg2 - position3).Magnitude > 350 and (arg2 - v10).Magnitude > 350 then
							return false
						end
						local str = (arg.ActionText or ""):lower()
						local str2 = (arg.ObjectText or ""):lower()
						local str3 = (arg.Name or ""):lower()
						if str:find("chat") or str:find("talk") or str:find("speak") or str:find("train") or str:find("buy") or str:find("shop") or str:find("quest") or str:find("dialogue") then
							return false
						end

						if str2:find("trainer") or str2:find("urokodaki") or str2:find("muzan") or str2:find("npc") or str2:find("station") or str2:find("corps") or str2:find("slayer") or str2:find("shop") then
							return false
						end
						local parent = arg.Parent
						local v14

						while true do
							local flag5 = parent and parent ~= Workspace
							v14 = nil

							if flag5 then
								if parent.Parent == Workspace:FindFirstChild("Chests") or parent:GetAttribute("ChestState") ~= nil or parent:GetAttribute("IsOpen") ~= nil or parent:GetAttribute("ChestId") ~= nil or parent:GetAttribute("ChestGuid") ~= nil then
									v14 = parent
									break
								else
									parent = parent.Parent
									continue
								end
							end

							break
						end

						if not v14 and not str3:find("chest") and not str2:find("chest") and not str2:find("cache") and not str:find("open") then
							return false
						end

						if v14 then
							if v14:GetAttribute("IsOpen") == true or v14:GetAttribute("ChestState") == "Opened" or v14:GetAttribute("ChestState") == "Despawned" then
								return false
							end

							if v14:GetAttribute("ChestState") == "Locked" and not arg.Enabled then
								return false
							end

							if (v14.Name or ""):lower():find("mound") then
								return false
							end
						end

						return true, v14
					end

					local chests = Workspace:FindFirstChild("Chests")

					if chests then
						for _, descendant in ipairs(chests:GetDescendants()) do
							if descendant:IsA("ProximityPrompt") then
								local parent = descendant.Parent

								if parent then
									local worldPosition = parent:IsA("Attachment") and parent.WorldPosition

									if worldPosition then
										parent = worldPosition
									else
										local position4 = parent:IsA("BasePart") and parent.Position

										if position4 then
											parent = position4
										else
											parent = parent:IsA("Model") and parent:GetPivot().Position
										end
									end
								end

								local v14, v15 = fn39(descendant, parent)

								if v14 then
									v11 = descendant
									v12 = parent
									v13 = v15
									break
								end
							end
						end
					end

					if not v11 then
						for _, v14 in ipairs(game:GetService("CollectionService"):GetTagged("Chest")) do
							for _, descendant in ipairs(v14:GetDescendants()) do
								if descendant:IsA("ProximityPrompt") then
									local parent = descendant.Parent

									if parent then
										local worldPosition = parent:IsA("Attachment") and parent.WorldPosition

										if worldPosition then
											parent = worldPosition
										else
											local position4 = parent:IsA("BasePart") and parent.Position

											if position4 then
												parent = position4
											else
												parent = parent:IsA("Model") and parent:GetPivot().Position
											end
										end
									end

									local v15, v16 = fn39(descendant, parent)

									if v15 then
										v11 = descendant
										v12 = parent
										v13 = v16
										break
									end
								end
							end

							if not v11 then
								continue
							end
							break
						end
					end
				end

				local proximityPrompt = nil
				local v14 = nil
				local v15 = nil

				if slayersSyneroxHub.Farm.AutoCollectSouls and not v11 then
					local function fn39(arg)
						if not arg or not arg.Parent then
							return false
						end

						if arg:FindFirstAncestor("StationaryNpcs") or arg:FindFirstAncestor("ActiveNpcs") then
							return false
						end

						if arg:FindFirstChildOfClass("Humanoid") then
							return false
						end
						local str = (arg.Name or ""):lower()
						local pos = str:find("soul") or str == "weak soul" or str == "strong soul" or str == "brave soul"

						if not pos then
							if arg:GetAttribute("IsSoul") or arg:GetAttribute("SoulType") then
								pos = true
							end
						end

						if not pos then
							return false
						end
						local isBasePart = arg:IsA("BasePart") and arg

						if not isBasePart then
							isBasePart = arg:FindFirstChild("Root") or arg:FindFirstChild("Handle") or arg:FindFirstChildWhichIsA("BasePart", true)
						end

						local position4 = isBasePart and isBasePart.Position or arg:IsA("Model") and arg:GetPivot().Position
						if not position4 then
							return false
						end

						if (position4 - position3).Magnitude > 250 and (position4 - v10).Magnitude > 250 then
							return false
						end
						proximityPrompt = arg:FindFirstChildWhichIsA("ProximityPrompt", true)
						v14 = position4
						v15 = isBasePart
						return true
					end

					for _, child in ipairs(Workspace:GetChildren()) do
						if not fn39(child) then
							continue
						end
						break
					end

					local flag5 = not v14

					if flag5 then
						local debree = Workspace:FindFirstChild("Debree")

						if debree then
							for _, child in ipairs(debree:GetChildren()) do
								if not fn39(child) then
									continue
								end
								break
							end
						end
					end

					if flag5 then
						local lootDrops = Workspace:FindFirstChild("LootDrops")

						if lootDrops then
							for _, child in ipairs(lootDrops:GetChildren()) do
								if not fn39(child) then
									continue
								end
								break
							end
						end
					end

					if flag5 then
						local CollectionService = game:GetService("CollectionService")

						for _, v16 in ipairs({ "Soul", "Souls", "DemonSoul" }) do
							for _, v17 in ipairs(CollectionService:GetTagged(v16)) do
								if not fn39(v17) then
									continue
								end
								break
							end

							if not v14 then
								continue
							end
							break
						end
					end
				end

				local flag5 = false

				if slayersSyneroxHub.Farm.AutoCollectLoot and not v11 and not v14 then
					local lootDrops = Workspace:FindFirstChild("LootDrops")
					local CollectionService = game:GetService("CollectionService")

					local function fn39(arg)
						if not arg or not arg.Parent then
							return false
						end

						if arg:FindFirstAncestor("Regions") or arg:FindFirstAncestor("StationaryNpcs") then
							return false
						end

						if arg.Name == "Regions" or arg.Name == "Debree" then
							return false
						end

						if arg:GetAttribute("DropClaimedBy") ~= nil then
							return false
						end

						if not (arg:GetAttribute("DropItemId") ~= nil or arg.Parent == lootDrops or CollectionService:HasTag(arg, "LootDrop")) then
							return false
						end
						local attribute = arg:GetAttribute("DropTarget")
						local isBasePart = arg:IsA("BasePart") and arg or arg:FindFirstChild("Handle") or arg:FindFirstChildWhichIsA("BasePart", true)
						attribute = typeof(attribute) == "Vector3" and attribute or isBasePart and isBasePart.Position
						local position4

						if attribute then
							position4 = attribute
						else
							position4 = arg:IsA("Model") and arg:GetPivot().Position
						end

						if position4 then
							position4 = (position4 - position3).Magnitude <= 350 or (position4 - v10).Magnitude <= 350
						end

						if position4 then
							return true
						end
						return false
					end

					if lootDrops then
						for _, child in ipairs(lootDrops:GetChildren()) do
							if fn39(child) then
								flag5 = true
								break
							end
						end
					end

					if not flag5 then
						for _, v16 in ipairs(CollectionService:GetTagged("LootDrop")) do
							if not lootDrops or v16.Parent ~= lootDrops then
								if fn39(v16) then
									flag5 = true
									break
								end
							end
						end
					end
				end

				if v11 or v14 or flag5 then
					slayersSyneroxHub.IsCollectingLoot = true

					task.spawn(function()
						local v16 = fn8()
						if not v16 then
							slayersSyneroxHub.IsCollectingLoot = false
							return
						end

						if v11 and v12 then
							local v17 = v11
							v17.Enabled = true
							local holdDuration = v17.HoldDuration
							local maxActivationDistance = v17.MaxActivationDistance
							v17.HoldDuration = 0
							v17.MaxActivationDistance = 60
							local cframe = CFrame.new(v12 + Vector3.new(0, 1.5, 2.5), v12)
							v16.CFrame = cframe
							v16.AssemblyLinearVelocity = Vector3.zero
							v16.AssemblyAngularVelocity = Vector3.zero
							fn22(cframe)
							task.wait(0.18)
							pcall(fireproximityprompt, v17, 0)
							pcall(fireproximityprompt, v17)
							local keyboardKeyCode = v17.KeyboardKeyCode ~= Enum.KeyCode.Unknown and v17.KeyboardKeyCode or Enum.KeyCode.T

							if VirtualInputManager then
								VirtualInputManager:SendKeyEvent(true, keyboardKeyCode, false, game)
								task.wait(0.08)
								VirtualInputManager:SendKeyEvent(false, keyboardKeyCode, false, game)
							end

							local now2 = tick()

							while tick() - now2 < 2.5 do
								if not (v13 and (v13:GetAttribute("IsOpen") == true or v13:GetAttribute("ChestState") == "Opened")) then
									if tick() - now2 > 0.6 and tick() - now2 < 0.75 then
										pcall(fireproximityprompt, v17, 0)
										pcall(fireproximityprompt, v17)
									end

									task.wait(0.12)
									continue
								end

								break
							end

							pcall(function()
								v17.HoldDuration = holdDuration
								v17.MaxActivationDistance = maxActivationDistance
							end)

							local now3 = tick()

							while tick() - now3 < 2 do
								local lootDrops = Workspace:FindFirstChild("LootDrops")
								local CollectionService = game:GetService("CollectionService")
								lootDrops = lootDrops and #lootDrops:GetChildren() > 0
								local flag6 = false

								if lootDrops then
									flag6 = true
								end

								if not flag6 and #CollectionService:GetTagged("LootDrop") > 0 then
									flag6 = true
								end

								if flag6 then
									task.wait(0.5)
									break
								else
									task.wait(0.15)
								end
							end

							fn38(v12, 200, 6)
						elseif v14 then
							local cframe = CFrame.new(v14 + Vector3.new(0, 0.6, 0))
							v16.CFrame = cframe
							v16.AssemblyLinearVelocity = Vector3.zero
							v16.AssemblyAngularVelocity = Vector3.zero
							fn22(cframe)
							task.wait(0.08)

							if proximityPrompt then
								local v17 = proximityPrompt
								v17.Enabled = true
								local holdDuration = v17.HoldDuration
								local maxActivationDistance = v17.MaxActivationDistance
								v17.HoldDuration = 0
								v17.MaxActivationDistance = 50
								pcall(fireproximityprompt, v17, 0)
								pcall(fireproximityprompt, v17)
								local keyboardKeyCode = v17.KeyboardKeyCode ~= Enum.KeyCode.Unknown and v17.KeyboardKeyCode or Enum.KeyCode.T

								if VirtualInputManager then
									VirtualInputManager:SendKeyEvent(true, keyboardKeyCode, false, game)
									task.wait(0.06)
									VirtualInputManager:SendKeyEvent(false, keyboardKeyCode, false, game)
								end

								pcall(function()
									v17.HoldDuration = holdDuration
									v17.MaxActivationDistance = maxActivationDistance
								end)
							end

							if v15 then
								pcall(function()
									firetouchinterest(v16, v15, 0)
									task.wait(0.02)
									firetouchinterest(v16, v15, 1)
								end)
							end

							task.wait(0.1)
							position2 = nil
						elseif flag5 then
							fn38(v10, 350, 4)
						end

						slayersSyneroxHub.IsCollectingLoot = false
					end)
				end
			end
		end
	end))
end

table.insert(slayersSyneroxHub.Connections, RunService.Heartbeat:Connect(function()
	local v8 = fn8()
	if not v8 then
		return
	end

	if slayersSyneroxHub.Training.AutoBoulder then
		local boulderPush = Workspace.Training:FindFirstChild("Boulder Push")

		if boulderPush then
			for _, child in ipairs(boulderPush:GetChildren()) do
				local proximityPrompt = child:FindFirstChildOfClass("ProximityPrompt") or child:FindFirstChildWhichIsA("ProximityPrompt", true)
				local position = child:IsA("BasePart") and child.Position or child:IsA("Model") and child:GetPivot().Position

				if not position then
					position = proximityPrompt and proximityPrompt.Parent and proximityPrompt.Parent:IsA("BasePart") and proximityPrompt.Parent.Position
				end

				if proximityPrompt and position and (position - v8.Position).Magnitude <= proximityPrompt.MaxActivationDistance + 4 then
					fireproximityprompt(proximityPrompt)
				end
			end
		end
	end

	if slayersSyneroxHub.Training.AutoSquats then
		local squatRack = Workspace.Training:FindFirstChild("Squat Rack")

		if squatRack then
			for _, child in ipairs(squatRack:GetChildren()) do
				local proximityPrompt = child:FindFirstChildOfClass("ProximityPrompt") or child:FindFirstChildWhichIsA("ProximityPrompt", true)
				local position = child:IsA("BasePart") and child.Position or child:IsA("Model") and child:GetPivot().Position or proximityPrompt and proximityPrompt.Parent and proximityPrompt.Parent:IsA("BasePart") and proximityPrompt.Parent.Position

				if proximityPrompt and position and (position - v8.Position).Magnitude <= proximityPrompt.MaxActivationDistance + 4 then
					fireproximityprompt(proximityPrompt)
				end
			end
		end
	end
end))

local function fn38(child)
	if not slayersSyneroxHub.Training.AutoMinigames then
		return
	end

	if not child or not child:IsA("GuiObject") and not child:IsA("ScreenGui") then
		return
	end
	local v8 = string.lower(child.Name)

	if string.find(v8, "slider") or string.find(v8, "cup") or string.find(v8, "training") or string.find(v8, "minigame") or string.find(v8, "bar") then
		task.wait(0.05)

		pcall(function()
			if SignalEvent then
				SignalEvent.ToServer("training_signaler", "Stop", true)
			end
		end)
	end
end

pcall(function()
	local misc = localPlayer.PlayerGui:WaitForChild("Misc", 5)

	if misc then
		table.insert(slayersSyneroxHub.Connections, misc.ChildAdded:Connect(fn38))

		for _, child in ipairs(misc:GetChildren()) do
			fn38(child)
		end
	end

	table.insert(slayersSyneroxHub.Connections, localPlayer.PlayerGui.ChildAdded:Connect(function(child)
		if child.Name == "Misc" then
			table.insert(slayersSyneroxHub.Connections, child.ChildAdded:Connect(fn38))
		end
	end))
end)

local n5 = 0

table.insert(slayersSyneroxHub.Connections, RunService.Heartbeat:Connect(function()
	if slayersSyneroxHub.Training.AutoMinigames then
		local now = os.clock()

		if now - n5 >= 0.4 then
			local v8 = fn7()

			if v8 then
				local skillStandStill = v8:FindFirstChild("skill_stand_still")
				local pauseGameplay = v8:FindFirstChild("pause_gameplay")

				if skillStandStill and skillStandStill.Value or pauseGameplay and pauseGameplay.Value then
					n5 = now

					pcall(function()
						if SignalEvent then
							SignalEvent.ToServer("training_signaler", "Stop", true)
						end
					end)
				end
			end
		end
	end
end))

do
	local n6 = 0
	local n7 = 0
	local n8 = 0
	local n9 = 0

	table.insert(slayersSyneroxHub.Connections, RunService.Heartbeat:Connect(function()
		local now = os.clock()

		if slayersSyneroxHub.Combat.NoSunDamage then
			pcall(function()
				local playerGui = localPlayer:FindFirstChild("PlayerGui")
				playerGui = playerGui and playerGui:FindFirstChild("UCS")
				playerGui = playerGui and playerGui:FindFirstChild("Game_Play")
				local sunDamage = playerGui and playerGui:FindFirstChild("SunDamage")

				if sunDamage and sunDamage:IsA("LocalScript") and sunDamage.Enabled then
					sunDamage.Enabled = false
				end
			end)

			if localPlayer:GetAttribute("SecondarySituation") ~= "Sunless" then
				pcall(function()
					localPlayer:SetAttribute("SecondarySituation", "Sunless")
				end)
			end

			if now - n6 >= 1 then
				n6 = now

				pcall(function()
					if SignalFunction and SignalFunction.ToServer then
						SignalFunction.ToServer("SunDamage", false)
					end
				end)
			end
		end

		if slayersSyneroxHub.Combat.NoColdDamage then
			local v8 = fn9()

			if v8 and v8.Health > 0 then
				local v9 = fn7()

				if v9 then
					local snowFrostTick = v9:FindFirstChild("Snow Frost Tick")

					if snowFrostTick then
						pcall(function()
							snowFrostTick:Destroy()
						end)
					end
				end

				if v8.Health < v8.MaxHealth then
					v8.Health = v8.MaxHealth
				end
			end
		end

		if slayersSyneroxHub.Combat.FastAttack and now - n7 >= 0.16 then
			if fn8() and not slayersSyneroxHub.Farm.AutoFarm then
				n7 = now
				fn13()
			end
		end

		if slayersSyneroxHub.Combat.AntiFreeze and now - n8 >= 1 then
			n8 = now
			local v8 = fn9()

			if v8 and v8.Health > 0 then
				local flag3 = v8.WalkSpeed < 8 and v8.JumpPower == 0
				local v9 = nil

				pcall(function()
					v9 = game.ReplicatedStorage.Player_Service.Values:FindFirstChild(localPlayer.Name)
				end)

				local flag4 = false

				if v9 then
					if v9:FindFirstChild("Stun") or v9:FindFirstChild("RagDoll") then
						flag4 = true
					elseif v9:FindFirstChild("CombatStun") then
						flag4 = true
					end
				end

				if flag3 or flag4 then
					n9 += 1

					if n9 >= 2 then
						fn11()
						n9 = 0
					end
				else
					n9 = 0
				end

				if slayersSyneroxHub.Combat.TrackGuard then
					local animator = v8:FindFirstChildOfClass("Animator")

					if animator then
						local playingAnimationTracks = animator:GetPlayingAnimationTracks()

						if #playingAnimationTracks > 8 then
							for _, playingAnimationTrack in ipairs(playingAnimationTracks) do
								local name = playingAnimationTrack.Name

								if string.find(name, "Swing") or string.find(name, "React") or string.find(name, "Dash") or string.find(name, "Combat") or playingAnimationTrack.TimePosition >= playingAnimationTrack.Length - 0.05 or playingAnimationTrack.Speed == 0 then
									pcall(function()
										playingAnimationTrack:Stop(0)
										playingAnimationTrack:Destroy()
									end)
								end
							end
						end
					end
				end
			end
		end
	end))
end

local function fn39()
	for k, espHighlight in pairs(slayersSyneroxHub.ESPHighlights) do
		if not k or not k.Parent then
			pcall(function()
				espHighlight:Destroy()
			end)

			slayersSyneroxHub.ESPHighlights[k] = nil
		end
	end

	if slayersSyneroxHub.Visuals.MobESP then
		local v8 = fn14()

		for _, v9 in ipairs(v8) do
			local model = v9.Model

			if not slayersSyneroxHub.ESPHighlights[model] and slayersSyneroxHub.Visuals.ESPBoxes then
				local highlight = Instance.new("Highlight")
				highlight.Name = "SyneroxMobESP"
				highlight.Adornee = model
				highlight.FillColor = slayersSyneroxHub.Visuals.MobColor
				highlight.OutlineColor = Color3.new(1, 1, 1)
				highlight.FillTransparency = 0.55
				highlight.OutlineTransparency = 0.2
				highlight.Parent = model
				slayersSyneroxHub.ESPHighlights[model] = highlight
			elseif slayersSyneroxHub.ESPHighlights[model] then
				slayersSyneroxHub.ESPHighlights[model].Enabled = slayersSyneroxHub.Visuals.ESPBoxes
				slayersSyneroxHub.ESPHighlights[model].FillColor = slayersSyneroxHub.Visuals.MobColor
			end
		end
	else
		for _, espHighlight in pairs(slayersSyneroxHub.ESPHighlights) do
			if espHighlight.Name == "SyneroxMobESP" then
				espHighlight.Enabled = false
			end
		end
	end

	if slayersSyneroxHub.Visuals.PlayerESP then
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer and player.Character then
				local character = player.Character

				if not slayersSyneroxHub.ESPHighlights[character] and slayersSyneroxHub.Visuals.ESPBoxes then
					local highlight = Instance.new("Highlight")
					highlight.Name = "SyneroxPlayerESP"
					highlight.Adornee = character
					highlight.FillColor = slayersSyneroxHub.Visuals.PlayerColor
					highlight.OutlineColor = Color3.new(1, 1, 1)
					highlight.FillTransparency = 0.5
					highlight.OutlineTransparency = 0.2
					highlight.Parent = character
					slayersSyneroxHub.ESPHighlights[character] = highlight
				elseif slayersSyneroxHub.ESPHighlights[character] then
					slayersSyneroxHub.ESPHighlights[character].Enabled = slayersSyneroxHub.Visuals.ESPBoxes
					slayersSyneroxHub.ESPHighlights[character].FillColor = slayersSyneroxHub.Visuals.PlayerColor
				end
			end
		end
	else
		for _, espHighlight in pairs(slayersSyneroxHub.ESPHighlights) do
			if espHighlight.Name == "SyneroxPlayerESP" then
				espHighlight.Enabled = false
			end
		end
	end
end

table.insert(slayersSyneroxHub.Connections, RunService.Heartbeat:Connect(function()
	fn39()
end))

slayersSyneroxHub.Destroy = function()
	slayersSyneroxHub.Alive = false

	pcall(function()
		fn32(false)
	end)

	pcall(function()
		fn35(false)
	end)

	for _, connection in ipairs(slayersSyneroxHub.Connections) do
		pcall(function()
			connection:Disconnect()
		end)
	end

	table.clear(slayersSyneroxHub.Connections)

	for _, espHighlight in pairs(slayersSyneroxHub.ESPHighlights) do
		pcall(function()
			espHighlight:Destroy()
		end)
	end

	table.clear(slayersSyneroxHub.ESPHighlights)
	fn23()

	pcall(function()
		if v and v.Destroy then
			pcall(function()
				v:Destroy()
			end)
		end
	end)

	_G.SlayersSyneroxHub = nil
end

local n6 = 0

table.insert(slayersSyneroxHub.Connections, RunService.Heartbeat:Connect(function()
	if slayersSyneroxHub.Combat and slayersSyneroxHub.Combat.AutoParry then
		local now = os.clock()

		if now - n6 >= 0.03 then
			n6 = now
			CheckPredictiveParry()
		end
	end
end))

local n7 = 0

table.insert(slayersSyneroxHub.Connections, RunService.Heartbeat:Connect(function()
	if slayersSyneroxHub.SkillTree and slayersSyneroxHub.SkillTree.AutoAllocate then
		local now = os.clock()

		if now - n7 >= 3.5 then
			n7 = now
			RunAutoSkillTreeAllocation()
		end
	end
end))

local n8 = 0

table.insert(slayersSyneroxHub.Connections, RunService.Heartbeat:Connect(function()
	local now = os.clock()

	if now - n8 >= 0.6 then
		n8 = now

		if slayersSyneroxHub.Training then
			if slayersSyneroxHub.Training.AutoTraining then
				StepAutoTraining()
			else
				if slayersSyneroxHub.Training.AutoGourd then
					StepAutoGourd()
				end

				if slayersSyneroxHub.Training.AutoBoulder then
					StepAutoBoulder()
				end
			end
		end
	end
end))

local n9 = 0

table.insert(slayersSyneroxHub.Connections, RunService.Heartbeat:Connect(function()
	if slayersSyneroxHub.Activities then
		local now = os.clock()

		if now - n9 >= 1.5 then
			n9 = now

			if slayersSyneroxHub.Activities.AutoFish then
				StepAutoFish()
			end

			if slayersSyneroxHub.Activities.AutoBuyBait then
				StepAutoBuyBait()
			end

			if slayersSyneroxHub.Activities.AutoBuyExp then
				StepAutoBuyExp()
			end
		end
	end
end))

local n10 = 0

table.insert(slayersSyneroxHub.Connections, RunService.Heartbeat:Connect(function()
	if slayersSyneroxHub.Activities and slayersSyneroxHub.Activities.AutoBecomeDemon then
		local now = os.clock()

		if now - n10 >= 3.5 then
			n10 = now
			RunAutoBecomeDemon()
		end
	end
end))

local n11 = 0

table.insert(slayersSyneroxHub.Connections, RunService.Heartbeat:Connect(function()
	if slayersSyneroxHub.Activities and slayersSyneroxHub.Activities.AutoFarmEvilKarma then
		local now = os.clock()

		if now - n11 >= 0.28 then
			n11 = now
			StepFarmEvilKarma()
		end
	end
end))

local n12 = 0

table.insert(slayersSyneroxHub.Connections, RunService.Heartbeat:Connect(function()
	local now = os.clock()

	if now - n12 >= 1.5 then
		n12 = now

		pcall(function()
			if _G.UpdateDemonProgressionLabels then
				_G.UpdateDemonProgressionLabels()
			end
		end)
	end
end))

do
	local n13 = 0
	local n14 = 0

	table.insert(slayersSyneroxHub.Connections, RunService.Heartbeat:Connect(function()
		local now = os.clock()

		if now - n13 >= 1 then
			n13 = now
			UpdateBossTimers()
		end

		if now - n14 >= 5 then
			n14 = now
			CheckWorldNotifiers()
		end
	end))
end

local n13 = 0

table.insert(slayersSyneroxHub.Connections, RunService.Heartbeat:Connect(function()
	if slayersSyneroxHub.Equipment and slayersSyneroxHub.Equipment.AutoEquipBest then
		local now = os.clock()

		if now - n13 >= 5 then
			n13 = now
			AutoEquipBestGear()
		end
	end
end))

local n14 = 0

table.insert(slayersSyneroxHub.Connections, RunService.Heartbeat:Connect(function()
	if slayersSyneroxHub.Dungeon and slayersSyneroxHub.Dungeon.AutoFarm then
		local now = os.clock()

		if now - n14 >= 0.05 then
			n14 = now
			StepAutoFarmDungeon()
		end
	end
end))

local n15 = 0

table.insert(slayersSyneroxHub.Connections, RunService.Heartbeat:Connect(function()
	if slayersSyneroxHub.Dungeon and (slayersSyneroxHub.Dungeon.AutoReadyUp or slayersSyneroxHub.Dungeon.AutoQueue) then
		local now = os.clock()

		if now - n15 >= 1 then
			n15 = now

			if IsInDungeonQueueArea() then
				StepAutoQueuePad(false)
			end
		end
	end
end))

getgenv()._ZenithLockDestroy = nil

getgenv()._SyneroxOuwlandDestroy = function()
	slayersSyneroxHub:Destroy()
end

fn("Synerox Hub", "Ouwland / Slayers 2 v2.8 Loaded (All Features Active)!", 4)
