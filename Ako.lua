-- ============================================
-- LGL MOD MENU - FIXED LAYOUT
-- Header > Scrollable Content > Bottom Buttons
-- Settings overlay, smaller size, draggable icon
-- ============================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "LGL_ModMenu_Fixed"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- ============================================
-- COLORS
-- ============================================
local COLORS = {
    Background = Color3.fromRGB(18, 22, 28),
    Header = Color3.fromRGB(28, 35, 45),
    Category = Color3.fromRGB(35, 42, 52),
    TextPrimary = Color3.fromRGB(200, 210, 220),
    TextTitle = Color3.fromRGB(100, 170, 255),
    TextGreen = Color3.fromRGB(60, 255, 100),
    ToggleOff = Color3.fromRGB(55, 55, 55),
    ToggleOn = Color3.fromRGB(255, 55, 55),
    ToggleKnobOff = Color3.fromRGB(160, 160, 160),
    ToggleKnobOn = Color3.fromRGB(255, 120, 120),
    ButtonBottom = Color3.fromRGB(45, 52, 62),
    SliderKnob = Color3.fromRGB(100, 230, 200),
    Stroke = Color3.fromRGB(70, 85, 105)
}

-- ============================================
-- MAIN PANEL (SMALLER SIZE)
-- ============================================
local main = Instance.new("Frame")
main.Name = "MainPanel"
main.Size = UDim2.new(0, 280, 0, 360) -- MAS MALIIT
main.Position = UDim2.new(0, -300, 0.5, -180)
main.BackgroundColor3 = COLORS.Background
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = COLORS.Stroke
mainStroke.Thickness = 1
mainStroke.Parent = main

-- ============================================
-- HEADER (TOP)
-- ============================================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 65)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = COLORS.Header
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 15)
headerFix.Position = UDim2.new(0, 0, 1, -15)
headerFix.BackgroundColor3 = COLORS.Header
headerFix.BorderSizePixel = 0
headerFix.Parent = header

-- Animated title with left slide
local titleText = Instance.new("TextLabel")
titleText.BackgroundTransparency = 1
titleText.Size = UDim2.new(1, -50, 0, 26)
titleText.Position = UDim2.new(0, 12, 0, 8)
titleText.Font = Enum.Font.GothamBold
titleText.Text = "Modded by (yourname)"
titleText.TextColor3 = COLORS.TextTitle
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = header

-- Animated subtitle (green sliding)
local subText = Instance.new("TextLabel")
subText.BackgroundTransparency = 1
subText.Size = UDim2.new(2, 0, 0, 16) -- Wider for animation
subText.Position = UDim2.new(0, 12, 0, 36)
subText.Font = Enum.Font.Gotham
subText.Text = "Modded by LGL  |  https://github.com/LGLTeam"
subText.TextColor3 = COLORS.TextGreen
subText.TextSize = 10
subText.TextXAlignment = Enum.TextXAlignment.Left
subText.Parent = header

-- LEFT SLIDE ANIMATION for subtitle
local function startSubAnimation()
    subText.Position = UDim2.new(0, 280, 0, 36) -- Start from right
    local tween = TweenService:Create(subText, TweenInfo.new(8, Enum.EasingStyle.Linear), {
        Position = UDim2.new(0, -280, 0, 36) -- Slide to left
    })
    tween:Play()
    tween.Completed:Connect(function()
        startSubAnimation() -- Loop
    end)
end
startSubAnimation()

-- Gear button
local gearBtn = Instance.new("TextButton")
gearBtn.Size = UDim2.fromOffset(30, 30)
gearBtn.Position = UDim2.new(1, -38, 0, 17)
gearBtn.BackgroundTransparency = 1
gearBtn.Text = "⚙"
gearBtn.TextColor3 = Color3.fromRGB(140, 160, 180)
gearBtn.TextSize = 20
gearBtn.Font = Enum.Font.GothamBold
gearBtn.Parent = header

-- ============================================
-- CONTENT AREA (Scrollable)
-- ============================================
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -120) -- Minus header + bottom
contentFrame.Position = UDim2.new(0, 0, 0, 65)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = main

-- ScrollingFrame for features
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 90, 100)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Auto
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = contentFrame

local scrollList = Instance.new("UIListLayout")
scrollList.SortOrder = Enum.SortOrder.LayoutOrder
scrollList.Padding = UDim.new(0, 0)
scrollList.Parent = scrollFrame

-- ============================================
-- FEATURES PAGE (Default view)
-- ============================================
local featuresPage = Instance.new("Frame")
featuresPage.Size = UDim2.new(1, 0, 0, 0)
featuresPage.BackgroundTransparency = 1
featuresPage.AutomaticSize = Enum.AutomaticSize.Y
featuresPage.Parent = scrollFrame

local featuresList = Instance.new("UIListLayout")
featuresList.SortOrder = Enum.SortOrder.LayoutOrder
featuresList.Padding = UDim.new(0, 0)
featuresList.Parent = featuresPage

-- Category bar
local categoryBar = Instance.new("TextLabel")
categoryBar.Size = UDim2.new(1, 0, 0, 30)
categoryBar.BackgroundColor3 = COLORS.Category
categoryBar.BorderSizePixel = 0
categoryBar.Font = Enum.Font.GothamBold
categoryBar.Text = "  The Category"
categoryBar.TextColor3 = COLORS.TextPrimary
categoryBar.TextSize = 12
categoryBar.TextXAlignment = Enum.TextXAlignment.Left
categoryBar.LayoutOrder = 0
categoryBar.Parent = featuresPage

-- Feature items
local featureData = {
    {type = "toggle", name = "The toggle", state = false},
    {type = "toggle", name = "The toggle 2", state = false},
    {type = "toggle", name = "The toggle 3", state = false},
    {type = "slider", name = "The slider", value = 1, min = 1, max = 10},
    {type = "slider", name = "Kittymemory slider example", value = 1, min = 1, max = 10},
}

for i, feat in ipairs(featureData) do
    if feat.type == "toggle" then
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -12, 0, 42)
        row.Position = UDim2.new(0, 6, 0, 0)
        row.BackgroundTransparency = 1
        row.LayoutOrder = i
        row.Parent = featuresPage
        
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -60, 1, 0)
        label.Font = Enum.Font.Gotham
        label.Text = feat.name
        label.TextColor3 = COLORS.TextPrimary
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = row
        
        -- RED Toggle
        local tgl = Instance.new("TextButton")
        tgl.Size = UDim2.fromOffset(46, 26)
        tgl.Position = UDim2.new(1, -54, 0.5, -13)
        tgl.BackgroundColor3 = COLORS.ToggleOff
        tgl.BorderSizePixel = 0
        tgl.Text = ""
        tgl.AutoButtonColor = false
        tgl.Parent = row
        
        local tc = Instance.new("UICorner")
        tc.CornerRadius = UDim.new(1, 0)
        tc.Parent = tgl
        
        local tknob = Instance.new("Frame")
        tknob.Size = UDim2.fromOffset(22, 22)
        tknob.Position = UDim2.new(0, 2, 0, 2)
        tknob.BackgroundColor3 = COLORS.ToggleKnobOff
        tknob.BorderSizePixel = 0
        tknob.Parent = tgl
        
        local tkc = Instance.new("UICorner")
        tkc.CornerRadius = UDim.new(1, 0)
        tkc.Parent = tknob
        
        local enabled = feat.state
        tgl.MouseButton1Click:Connect(function()
            enabled = not enabled
            local tp = enabled and UDim2.new(1, -24, 0, 2) or UDim2.new(0, 2, 0, 2)
            tgl.BackgroundColor3 = enabled and COLORS.ToggleOn or COLORS.ToggleOff
            tknob.BackgroundColor3 = enabled and COLORS.ToggleKnobOn or COLORS.ToggleKnobOff
            TweenService:Create(tknob, TweenInfo.new(0.15), {Position = tp}):Play()
        end)
        
    elseif feat.type == "slider" then
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -12, 0, 58)
        row.Position = UDim2.new(0, 6, 0, 0)
        row.BackgroundTransparency = 1
        row.LayoutOrder = i
        row.Parent = featuresPage
        
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 0, 22)
        label.Font = Enum.Font.Gotham
        label.Text = feat.name .. ": " .. feat.value
        label.TextColor3 = COLORS.TextPrimary
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = row
        
        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -20, 0, 4)
        track.Position = UDim2.new(0, 10, 0, 36)
        track.BackgroundColor3 = Color3.fromRGB(55, 65, 75)
        track.BorderSizePixel = 0
        track.Parent = row
        
        local trc = Instance.new("UICorner")
        trc.CornerRadius = UDim.new(1, 0)
        trc.Parent = track
        
        local knob = Instance.new("TextButton")
        knob.Size = UDim2.fromOffset(16, 16)
        knob.Position = UDim2.new(0, -8, 0.5, -8)
        knob.BackgroundColor3 = COLORS.SliderKnob
        knob.BorderSizePixel = 0
        knob.Text = ""
        knob.AutoButtonColor = false
        knob.Parent = track
        
        local knc = Instance.new("UICorner")
        knc.CornerRadius = UDim.new(1, 0)
        knc.Parent = knob
        
        -- Slider drag
        local dragging = false
        knob.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local ap = track.AbsolutePosition.X
                local as = track.AbsoluteSize.X
                local rx = math.clamp((input.Position.X - ap) / as, 0, 1)
                knob.Position = UDim2.new(rx, -8, 0.5, -8)
                local val = math.floor(feat.min + (feat.max - feat.min) * rx)
                label.Text = feat.name .. ": " .. val
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
    end
end

-- ============================================
-- SETTINGS PAGE (Hidden overlay)
-- ============================================
local settingsPage = Instance.new("Frame")
settingsPage.Size = UDim2.new(1, 0, 1, 0)
settingsPage.BackgroundColor3 = COLORS.Background
settingsPage.BorderSizePixel = 0
settingsPage.Visible = false
settingsPage.ZIndex = 10
settingsPage.Parent = contentFrame

local settingsList = Instance.new("UIListLayout")
settingsList.SortOrder = Enum.SortOrder.LayoutOrder
settingsList.Padding = UDim.new(0, 0)
settingsList.Parent = settingsPage

-- Settings title
local stTitle = Instance.new("TextLabel")
stTitle.Size = UDim2.new(1, 0, 0, 36)
stTitle.BackgroundColor3 = COLORS.Category
stTitle.BorderSizePixel = 0
stTitle.Font = Enum.Font.GothamBold
stTitle.Text = "  Settings"
stTitle.TextColor3 = COLORS.TextPrimary
stTitle.TextSize = 13
stTitle.TextXAlignment = Enum.TextXAlignment.Left
stTitle.LayoutOrder = 0
stTitle.Parent = settingsPage

-- Setting toggles
local settingsData = {
    {name = "Color animation", default = true},
    {name = "Auto size vertically", default = true},
    {name = "Save feature preferences", default = true},
}

for i, sd in ipairs(settingsData) do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -12, 0, 40)
    row.Position = UDim2.new(0, 6, 0, 0)
    row.BackgroundTransparency = 1
    row.LayoutOrder = i
    row.Parent = settingsPage
    
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Font = Enum.Font.Gotham
    lbl.Text = sd.name
    lbl.TextColor3 = COLORS.TextPrimary
    lbl.TextSize = 12
    lbl.TextWrapped = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    
    local tgl = Instance.new("TextButton")
    tgl.Size = UDim2.fromOffset(44, 24)
    tgl.Position = UDim2.new(1, -52, 0.5, -12)
    tgl.BackgroundColor3 = sd.default and COLORS.ToggleOn or COLORS.ToggleOff
    tgl.BorderSizePixel = 0
    tgl.Text = ""
    tgl.AutoButtonColor = false
    tgl.Parent = row
    
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(1, 0)
    tc.Parent = tgl
    
    local tknob = Instance.new("Frame")
    tknob.Size = UDim2.fromOffset(20, 20)
    tknob.Position = sd.default and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
    tknob.BackgroundColor3 = sd.default and COLORS.ToggleKnobOn or COLORS.ToggleKnobOff
    tknob.BorderSizePixel = 0
    tknob.Parent = tgl
    
    local tkc = Instance.new("UICorner")
    tkc.CornerRadius = UDim.new(1, 0)
    tkc.Parent = tknob
end

-- Logcat section
local logcatBar = Instance.new("TextLabel")
logcatBar.Size = UDim2.new(1, 0, 0, 28)
logcatBar.BackgroundColor3 = COLORS.Category
logcatBar.BorderSizePixel = 0
logcatBar.Font = Enum.Font.GothamBold
logcatBar.Text = "  Logcat"
logcatBar.TextColor3 = COLORS.TextPrimary
logcatBar.TextSize = 12
logcatBar.TextXAlignment = Enum.TextXAlignment.Left
logcatBar.LayoutOrder = 4
logcatBar.Parent = settingsPage

local logcatDesc = Instance.new("TextLabel")
logcatDesc.Size = UDim2.new(1, -16, 0, 55)
logcatDesc.Position = UDim2.new(0, 8, 0, 0)
logcatDesc.BackgroundTransparency = 1
logcatDesc.Font = Enum.Font.Gotham
logcatDesc.Text = "Save logcat if a bug occured and sent it to the modder. Clear logcat and reproduce bug again if the log file is too large"
logcatDesc.TextColor3 = COLORS.TextPrimary
logcatDesc.TextSize = 10
logcatDesc.TextWrapped = true
logcatDesc.TextXAlignment = Enum.TextXAlignment.Left
logcatDesc.LayoutOrder = 5
logcatDesc.Parent = settingsPage

-- Close settings
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(1, -20, 0, 32)
closeBtn.Position = UDim2.new(0, 10, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "Close settings"
closeBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.TextSize = 12
closeBtn.LayoutOrder = 6
closeBtn.Parent = settingsPage

-- ============================================
-- BOTTOM BUTTONS (NASA IBABA TALAGA)
-- ============================================
local bottomFrame = Instance.new("Frame")
bottomFrame.Size = UDim2.new(1, 0, 0, 55)
bottomFrame.Position = UDim2.new(0, 0, 1, -55)
bottomFrame.BackgroundColor3 = COLORS.Header
bottomFrame.BorderSizePixel = 0
bottomFrame.Parent = main

local bfc = Instance.new("UICorner")
bfc.CornerRadius = UDim.new(0, 10)
bfc.Parent = bottomFrame

local bff = Instance.new("Frame")
bff.Size = UDim2.new(1, 0, 0, 15)
bff.BackgroundColor3 = COLORS.Header
bff.BorderSizePixel = 0
bff.Parent = bottomFrame

-- HIDE/KILL (LEFT)
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0.47, -4, 0, 38)
hideBtn.Position = UDim2.new(0, 6, 0.5, -19)
hideBtn.BackgroundColor3 = COLORS.ButtonBottom
hideBtn.BorderSizePixel = 0
hideBtn.Font = Enum.Font.GothamBold
hideBtn.Text = "HIDE/KILL (HOLD)"
hideBtn.TextColor3 = COLORS.TextTitle
hideBtn.TextSize = 11
hideBtn.Parent = bottomFrame

local hbc = Instance.new("UICorner")
hbc.CornerRadius = UDim.new(0, 8)
hbc.Parent = hideBtn

-- MINIMIZE (RIGHT)
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0.47, -4, 0, 38)
minBtn.Position = UDim2.new(0.53, 0, 0.5, -19)
minBtn.BackgroundColor3 = COLORS.ButtonBottom
minBtn.BorderSizePixel = 0
minBtn.Font = Enum.Font.GothamBold
minBtn.Text = "MINIMIZE"
minBtn.TextColor3 = COLORS.TextTitle
minBtn.TextSize = 11
minBtn.Parent = bottomFrame

local mbc = Instance.new("UICorner")
mbc.CornerRadius = UDim.new(0, 8)
mbc.Parent = minBtn

-- ============================================
-- FLOATING ICON (DRAGGABLE, CIRCULAR)
-- ============================================
local floatIcon = Instance.new("TextButton")
floatIcon.Size = UDim2.fromOffset(52, 52)
floatIcon.Position = UDim2.new(0, 15, 0.5, -26)
floatIcon.BackgroundColor3 = Color3.fromRGB(10, 15, 20)
floatIcon.BorderSizePixel = 0
floatIcon.Text = "OPEN\nMOD MENU"
floatIcon.TextColor3 = COLORS.TextGreen
floatIcon.TextSize = 8
floatIcon.Font = Enum.Font.GothamBold
floatIcon.Visible = false
floatIcon.Parent = gui

local fic = Instance.new("UICorner")
fic.CornerRadius = UDim.new(1, 0)
fic.Parent = floatIcon

local fis = Instance.new("UIStroke")
fis.Color = COLORS.TextGreen
fis.Thickness = 2
fis.Parent = floatIcon

-- Draggable
local dragI = false
local dStart, iStart

floatIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragI = true
        dStart = input.Position
        iStart = floatIcon.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragI and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dStart
        floatIcon.Position = UDim2.new(iStart.X.Scale, iStart.X.Offset + d.X, iStart.Y.Scale, iStart.Y.Offset + d.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragI = false
    end
end)

-- ============================================
-- ANIMATIONS & LOGIC
-- ============================================
local isVisible = false
local isSettings = false

local posShow = UDim2.new(0.5, -140, 0.5, -180)
local posHide = UDim2.new(0, -300, 0.5, -180)

local function slideIn()
    main.Visible = true
    floatIcon.Visible = false
    TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = posShow
    }):Play()
    isVisible = true
end

local function slideOut()
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Position = posHide
    }):Play()
    task.delay(0.3, function()
        main.Visible = false
        floatIcon.Visible = true
    end)
    isVisible = false
end

-- Settings toggle
gearBtn.MouseButton1Click:Connect(function()
    isSettings = true
    featuresPage.Visible = false
    settingsPage.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
    isSettings = false
    settingsPage.Visible = false
    featuresPage.Visible = true
end)

minBtn.MouseButton1Click:Connect(slideOut)
floatIcon.MouseButton1Click:Connect(slideIn)

hideBtn.MouseButton1Down:Connect(function()
    TweenService:Create(hideBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 60, 60)}):Play()
end)
hideBtn.MouseButton1Up:Connect(function()
    gui:Destroy()
end)

-- Start
main.Position = posHide
task.wait(0.2)
slideIn()

print("LGL Menu Loaded - Scrollable, Settings Overlay, Bottom Buttons")
