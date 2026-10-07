-- LGL-style Auto Farm UI Template
-- UI ONLY: the Auto Farm callback is a placeholder.
-- Replace the callback with your own legitimate game logic.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "LGL_AutoFarm_UI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local panelWidth = 580
local panelHeight = 390

local main = Instance.new("Frame")
main.Name = "ModMenu"
main.Size = UDim2.fromOffset(panelWidth, panelHeight)
main.Position = UDim2.new(0, -panelWidth - 20, 0.5, -panelHeight/2)
main.BackgroundColor3 = Color3.fromRGB(43, 48, 39)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 18)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(95, 190, 70)
stroke.Thickness = 3
stroke.Parent = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 120)
header.BackgroundColor3 = Color3.fromRGB(112, 117, 110)
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 18)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -90, 0, 55)
title.Position = UDim2.fromOffset(25, 8)
title.Font = Enum.Font.GothamBold
title.Text = "MOD MENU"
title.TextColor3 = Color3.fromRGB(255, 255, 0)
title.TextSize = 32
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Size = UDim2.new(1, -50, 0, 35)
subtitle.Position = UDim2.fromOffset(25, 70)
subtitle.Font = Enum.Font.GothamBold
subtitle.Text = "LGL STYLE  |  UI TEMPLATE"
subtitle.TextColor3 = Color3.fromRGB(40, 255, 40)
subtitle.TextSize = 17
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

local gear = Instance.new("TextButton")
gear.Size = UDim2.fromOffset(58, 58)
gear.Position = UDim2.new(1, -72, 0, 28)
gear.BackgroundTransparency = 1
gear.Text = "⚙"
gear.TextColor3 = Color3.fromRGB(65, 65, 65)
gear.TextSize = 38
gear.Font = Enum.Font.GothamBold
gear.Parent = header

local category = Instance.new("TextLabel")
category.Size = UDim2.new(1, 0, 0, 52)
category.Position = UDim2.fromOffset(0, 120)
category.BackgroundColor3 = Color3.fromRGB(32, 36, 44)
category.BorderSizePixel = 0
category.Font = Enum.Font.GothamBold
category.Text = "AUTO FARM"
category.TextColor3 = Color3.fromRGB(235, 235, 240)
category.TextSize = 27
category.Parent = main

local row = Instance.new("Frame")
row.Size = UDim2.new(1, -20, 0, 90)
row.Position = UDim2.fromOffset(10, 182)
row.BackgroundTransparency = 1
row.Parent = main

local label = Instance.new("TextLabel")
label.BackgroundTransparency = 1
label.Size = UDim2.new(1, -115, 1, 0)
label.Position = UDim2.fromOffset(10, 0)
label.Font = Enum.Font.Gotham
label.Text = "Auto Farm"
label.TextColor3 = Color3.fromRGB(240, 240, 240)
label.TextSize = 26
label.TextXAlignment = Enum.TextXAlignment.Left
label.Parent = row

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.fromOffset(76, 42)
toggle.Position = UDim2.new(1, -86, 0.5, -21)
toggle.BackgroundColor3 = Color3.fromRGB(70, 75, 75)
toggle.BorderSizePixel = 0
toggle.Text = ""
toggle.AutoButtonColor = false
toggle.Parent = row

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggle

local knob = Instance.new("Frame")
knob.Size = UDim2.fromOffset(38, 38)
knob.Position = UDim2.fromOffset(2, 2)
knob.BackgroundColor3 = Color3.fromRGB(155, 160, 165)
knob.BorderSizePixel = 0
knob.Parent = toggle

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = knob

local hide = Instance.new("TextButton")
hide.Size = UDim2.new(0.32, 0, 0, 70)
hide.Position = UDim2.new(0, 5, 1, -75)
hide.BackgroundColor3 = Color3.fromRGB(55, 61, 52)
hide.BorderSizePixel = 0
hide.Font = Enum.Font.GothamBold
hide.Text = "HIDE/KILL"
hide.TextColor3 = Color3.fromRGB(255, 255, 0)
hide.TextSize = 23
hide.Parent = main

local hideCorner = Instance.new("UICorner")
hideCorner.CornerRadius = UDim.new(0, 18)
hideCorner.Parent = hide

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0.32, 0, 0, 70)
minimize.Position = UDim2.new(0.68, -5, 1, -75)
minimize.BackgroundColor3 = Color3.fromRGB(55, 61, 52)
minimize.BorderSizePixel = 0
minimize.Font = Enum.Font.GothamBold
minimize.Text = "MINIMIZE"
minimize.TextColor3 = Color3.fromRGB(255, 255, 0)
minimize.TextSize = 23
minimize.Parent = main

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 18)
minCorner.Parent = minimize

-- Small floating button shown after minimizing.
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.fromOffset(62, 62)
openButton.Position = UDim2.new(0, 15, 0.5, -31)
openButton.BackgroundColor3 = Color3.fromRGB(55, 61, 52)
openButton.BorderSizePixel = 0
openButton.Font = Enum.Font.GothamBold
openButton.Text = "LGL"
openButton.TextColor3 = Color3.fromRGB(255, 255, 0)
openButton.TextSize = 18
openButton.Visible = false
openButton.Parent = gui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = openButton

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(95, 190, 70)
openStroke.Thickness = 2
openStroke.Parent = openButton

local hidden = false
local autoFarm = false

local shownPos = UDim2.new(0.5, -panelWidth/2, 0.5, -panelHeight/2)
local hiddenPos = UDim2.new(0, -panelWidth - 20, 0.5, -panelHeight/2)

local function slideIn()
    main.Visible = true
    openButton.Visible = false
    TweenService:Create(
        main,
        TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = shownPos}
    ):Play()
    hidden = false
end

local function slideOut()
    local tween = TweenService:Create(
        main,
        TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
        {Position = hiddenPos}
    )
    tween:Play()
    tween.Completed:Connect(function()
        if hidden then
            main.Visible = false
            openButton.Visible = true
        end
    end)
    hidden = true
end

local function setAutoFarm(state)
    autoFarm = state

    local targetPos
    if state then
        toggle.BackgroundColor3 = Color3.fromRGB(82, 65, 150)
        knob.BackgroundColor3 = Color3.fromRGB(115, 65, 245)
        targetPos = UDim2.new(1, -40, 0, 2)

        -- PLACEHOLDER:
        -- Put your own legitimate Auto Farm/game logic here.
    else
        toggle.BackgroundColor3 = Color3.fromRGB(70, 75, 75)
        knob.BackgroundColor3 = Color3.fromRGB(155, 160, 165)
        targetPos = UDim2.fromOffset(2, 2)

        -- Stop your own Auto Farm logic here.
    end

    TweenService:Create(
        knob,
        TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = targetPos}
    ):Play()
end

toggle.MouseButton1Click:Connect(function()
    setAutoFarm(not autoFarm)
end)

minimize.MouseButton1Click:Connect(slideOut)
openButton.MouseButton1Click:Connect(slideIn)

hide.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Start with the menu visible using the same slide animation.
task.wait(0.15)
slideIn()
