-- ============================================
-- LGL MOD MENU - OFFICIAL STYLE REMAKE
-- Based on LGLTeam Android Mod Menu Template
-- ============================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "LGL_ModMenu"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- ============================================
-- COLORS (LGL Official Palette)
-- ============================================
local COLORS = {
    Background = Color3.fromRGB(15, 20, 25),
    Header = Color3.fromRGB(20, 30, 40),
    Category = Color3.fromRGB(25, 35, 45),
    TextPrimary = Color3.fromRGB(200, 220, 240),
    TextTitle = Color3.fromRGB(100, 180, 255),
    TextGreen = Color3.fromRGB(50, 255, 100),
    ToggleOff = Color3.fromRGB(60, 60, 60),
    ToggleOn = Color3.fromRGB(255, 50, 50), -- RED toggle (LGL style)
    ToggleKnobOff = Color3.fromRGB(150, 150, 150),
    ToggleKnobOn = Color3.fromRGB(255, 100, 100),
    ButtonHide = Color3.fromRGB(40, 50, 60),
    ButtonMinimize = Color3.fromRGB(40, 50, 60),
    Stroke = Color3.fromRGB(60, 80, 100),
    FloatingIcon = Color3.fromRGB(0, 0, 0),
    FloatingStroke = Color3.fromRGB(50, 255, 100)
}

-- ============================================
-- MAIN PANEL (Auto-size, centered)
-- ============================================
local main = Instance.new("Frame")
main.Name = "MainPanel"
main.Size = UDim2.new(0, 340, 0, 0) -- Height auto-adjusts
main.Position = UDim2.new(0.5, -170, 0.5, -200)
main.BackgroundColor3 = COLORS.Background
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = COLORS.Stroke
mainStroke.Thickness = 1
mainStroke.Parent = main

-- Auto-size with padding
local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingBottom = UDim.new(0, 50) -- Space for bottom buttons
uiPadding.Parent = main

local uiList = Instance.new("UIListLayout")
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 0)
uiList.Parent = main

-- ============================================
-- HEADER: "Modded by (yourname)"
-- ============================================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 70)
header.BackgroundColor3 = COLORS.Header
header.BorderSizePixel = 0
header.LayoutOrder = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = header

-- Fix bottom corners
local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 15)
headerFix.Position = UDim2.new(0, 0, 1, -15)
headerFix.BackgroundColor3 = COLORS.Header
headerFix.BorderSizePixel = 0
headerFix.Parent = header

-- Title: "Modded by (yourname)"
local titleText = Instance.new("TextLabel")
titleText.BackgroundTransparency = 1
titleText.Size = UDim2.new(1, -50, 0, 28)
titleText.Position = UDim2.new(0, 15, 0, 8)
titleText.Font = Enum.Font.GothamBold
titleText.Text = "Modded by (yourname)"
titleText.TextColor3 = COLORS.TextTitle
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = header

-- Subtitle: "Modded by LGL | github link"
local subText = Instance.new("TextLabel")
subText.BackgroundTransparency = 1
subText.Size = UDim2.new(1, -50, 0, 18)
subText.Position = UDim2.new(0, 15, 0, 36)
subText.Font = Enum.Font.Gotham
subText.Text = "Modded by LGL  |  https://github.com/LGLTeam"
subText.TextColor3 = COLORS.TextGreen
subText.TextSize = 10
subText.TextXAlignment = Enum.TextXAlignment.Left
subText.Parent = header

-- Settings Gear Button
local gearBtn = Instance.new("TextButton")
gearBtn.Size = UDim2.fromOffset(32, 32)
gearBtn.Position = UDim2.new(1, -42, 0, 19)
gearBtn.BackgroundTransparency = 1
gearBtn.Text = "⚙"
gearBtn.TextColor3 = Color3.fromRGB(150, 170, 190)
gearBtn.TextSize = 22
gearBtn.Font = Enum.Font.GothamBold
gearBtn.Parent = header

-- ============================================
-- SETTINGS PANEL (Hidden by default)
-- ============================================
local settingsPanel = Instance.new("Frame")
settingsPanel.Size = UDim2.new(1, 0, 0, 0)
settingsPanel.BackgroundColor3 = COLORS.Background
settingsPanel.BorderSizePixel = 0
settingsPanel.Visible = false
settingsPanel.LayoutOrder = 1
settingsPanel.Parent = main

local settingsList = Instance.new("UIListLayout")
settingsList.SortOrder = Enum.SortOrder.LayoutOrder
settingsList.Padding = UDim.new(0, 2)
settingsList.Parent = settingsPanel

-- Settings Title
local settingsTitle = Instance.new("TextLabel")
settingsTitle.Size = UDim2.new(1, 0, 0, 30)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.Text = "Settings"
settingsTitle.TextColor3 = COLORS.TextPrimary
settingsTitle.TextSize = 14
settingsTitle.LayoutOrder = 0
settingsTitle.Parent = settingsPanel

-- Setting items
local settingItems = {
    {name = "Color animation", default = true},
    {name = "Auto size vertically", default = true},
    {name = "Save feature preferences (Radio Button is not saved)", default = true},
}

for i, item in ipairs(settingItems) do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 36)
    row.Position = UDim2.new(0, 10, 0, 0)
    row.BackgroundTransparency = 1
    row.LayoutOrder = i
    row.Parent = settingsPanel
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = item.name
    label.TextColor3 = COLORS.TextPrimary
    label.TextSize = 12
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row
    
    -- Red toggle
    local stToggle = Instance.new("TextButton")
    stToggle.Size = UDim2.fromOffset(44, 24)
    stToggle.Position = UDim2.new(1, -50, 0.5, -12)
    stToggle.BackgroundColor3 = item.default and COLORS.ToggleOn or COLORS.ToggleOff
    stToggle.BorderSizePixel = 0
    stToggle.Text = ""
    stToggle.AutoButtonColor = false
    stToggle.Parent = row
    
    local stCorner = Instance.new("UICorner")
    stCorner.CornerRadius = UDim.new(1, 0)
    stCorner.Parent = stToggle
    
    local stKnob = Instance.new("Frame")
    stKnob.Size = UDim2.fromOffset(20, 20)
    stKnob.Position = item.default and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
    stKnob.BackgroundColor3 = item.default and COLORS.ToggleKnobOn or COLORS.ToggleKnobOff
    stKnob.BorderSizePixel = 0
    stKnob.Parent = stToggle
    
    local stKnobCorner = Instance.new("UICorner")
    stKnobCorner.CornerRadius = UDim.new(1, 0)
    stKnobCorner.Parent = stKnob
end

-- Logcat Section
local logcatTitle = Instance.new("TextLabel")
logcatTitle.Size = UDim2.new(1, 0, 0, 26)
logcatTitle.BackgroundColor3 = COLORS.Category
logcatTitle.BorderSizePixel = 0
logcatTitle.Font = Enum.Font.GothamBold
logcatTitle.Text = "  Logcat"
logcatTitle.TextColor3 = COLORS.TextPrimary
logcatTitle.TextSize = 12
logcatTitle.TextXAlignment = Enum.TextXAlignment.Left
logcatTitle.LayoutOrder = 4
logcatTitle.Parent = settingsPanel

local logcatDesc = Instance.new("TextLabel")
logcatDesc.Size = UDim2.new(1, -20, 0, 50)
logcatDesc.Position = UDim2.new(0, 10, 0, 0)
logcatDesc.BackgroundTransparency = 1
logcatDesc.Font = Enum.Font.Gotham
logcatDesc.Text = "Save logcat if a bug occured and sent it to the modder. Clear logcat and reproduce bug again if the log file is too large"
logcatDesc.TextColor3 = COLORS.TextPrimary
logcatDesc.TextSize = 11
logcatDesc.TextWrapped = true
logcatDesc.TextXAlignment = Enum.TextXAlignment.Left
logcatDesc.LayoutOrder = 5
logcatDesc.Parent = settingsPanel

-- Close settings button
local closeSettings = Instance.new("TextButton")
closeSettings.Size = UDim2.new(1, -20, 0, 32)
closeSettings.Position = UDim2.new(0, 10, 0, 0)
closeSettings.BackgroundTransparency = 1
closeSettings.Font = Enum.Font.GothamBold
closeSettings.Text = "Close settings"
closeSettings.TextColor3 = Color3.fromRGB(255, 50, 50)
closeSettings.TextSize = 13
closeSettings.LayoutOrder = 6
closeSettings.Parent = settingsPanel

-- ============================================
-- CATEGORY: "The Category"
-- ============================================
local categoryBar = Instance.new("TextLabel")
categoryBar.Size = UDim2.new(1, 0, 0, 32)
categoryBar.BackgroundColor3 = COLORS.Category
categoryBar.BorderSizePixel = 0
categoryBar.Font = Enum.Font.GothamBold
categoryBar.Text = "  The Category"
categoryBar.TextColor3 = COLORS.TextPrimary
categoryBar.TextSize = 13
categoryBar.TextXAlignment = Enum.TextXAlignment.Left
categoryBar.LayoutOrder = 2
categoryBar.Parent = main

-- ============================================
-- FEATURE LIST (Toggles & Sliders)
-- ============================================
local featuresFrame = Instance.new("Frame")
featuresFrame.Size = UDim2.new(1, 0, 0, 0)
featuresFrame.BackgroundTransparency = 1
featuresFrame.LayoutOrder = 3
featuresFrame.Parent = main

local featuresList = Instance.new("UIListLayout")
featuresList.SortOrder = Enum.SortOrder.LayoutOrder
featuresList.Padding = UDim.new(0, 2)
featuresList.Parent = featuresFrame

-- Feature data
local features = {
    {type = "toggle", name = "The toggle", state = false},
    {type = "toggle", name = "The toggle 2", state = false},
    {type = "toggle", name = "The toggle 3", state = false},
    {type = "slider", name = "The slider", value = 1, min = 1, max = 10},
    {type = "slider", name = "Kittymemory slider example", value = 1, min = 1, max = 10},
}

local featureConnections = {}

for i, feat in ipairs(features) do
    if feat.type == "toggle" then
        -- Toggle Row
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -16, 0, 38)
        row.Position = UDim2.new(0, 8, 0, 0)
        row.BackgroundTransparency = 1
        row.LayoutOrder = i
        row.Parent = featuresFrame
        
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -60, 1, 0)
        label.Font = Enum.Font.Gotham
        label.Text = feat.name
        label.TextColor3 = COLORS.TextPrimary
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = row
        
        -- RED Toggle (LGL Style)
        local tgl = Instance.new("TextButton")
        tgl.Size = UDim2.fromOffset(44, 24)
        tgl.Position = UDim2.new(1, -52, 0.5, -12)
        tgl.BackgroundColor3 = COLORS.ToggleOff
        tgl.BorderSizePixel = 0
        tgl.Text = ""
        tgl.AutoButtonColor = false
        tgl.Parent = row
        
        local tglCorner = Instance.new("UICorner")
        tglCorner.CornerRadius = UDim.new(1, 0)
        tglCorner.Parent = tgl
        
        local tglKnob = Instance.new("Frame")
        tglKnob.Size = UDim2.fromOffset(20, 20)
        tglKnob.Position = UDim2.new(0, 2, 0, 2)
        tglKnob.BackgroundColor3 = COLORS.ToggleKnobOff
        tglKnob.BorderSizePixel = 0
        tglKnob.Parent = tgl
        
        local tglKnobCorner = Instance.new("UICorner")
        tglKnobCorner.CornerRadius = UDim.new(1, 0)
        tglKnobCorner.Parent = tglKnob
        
        -- Toggle functionality
        local enabled = feat.state
        tgl.MouseButton1Click:Connect(function()
            enabled = not enabled
            local targetPos = enabled and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
            tgl.BackgroundColor3 = enabled and COLORS.ToggleOn or COLORS.ToggleOff
            tglKnob.BackgroundColor3 = enabled and COLORS.ToggleKnobOn or COLORS.ToggleKnobOff
            
            TweenService:Create(tglKnob, TweenInfo.new(0.15), {Position = targetPos}):Play()
        end)
        
    elseif feat.type == "slider" then
        -- Slider Row
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -16, 0, 55)
        row.Position = UDim2.new(0, 8, 0, 0)
        row.BackgroundTransparency = 1
        row.LayoutOrder = i
        row.Parent = featuresFrame
        
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 0, 22)
        label.Font = Enum.Font.Gotham
        label.Text = feat.name .. ": " .. feat.value
        label.TextColor3 = COLORS.TextPrimary
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = row
        
        -- Slider track
        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -20, 0, 4)
        track.Position = UDim2.new(0, 10, 0, 35)
        track.BackgroundColor3 = Color3.fromRGB(60, 70, 80)
        track.BorderSizePixel = 0
        track.Parent = row
        
        local trackCorner = Instance.new("UICorner")
        trackCorner.CornerRadius = UDim.new(1, 0)
        trackCorner.Parent = track
        
        -- Slider knob (teal color like LGL)
        local knob = Instance.new("TextButton")
        knob.Size = UDim2.fromOffset(16, 16)
        knob.Position = UDim2.new(0, -8, 0.5, -8)
        knob.BackgroundColor3 = Color3.fromRGB(100, 220, 200)
        knob.BorderSizePixel = 0
        knob.Text = ""
        knob.AutoButtonColor = false
        knob.Parent = track
        
        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = knob
        
        -- Simple slider drag
        local dragging = false
        knob.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local absPos = track.AbsolutePosition.X
                local absSize = track.AbsoluteSize.X
                local relX = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
                knob.Position = UDim2.new(relX, -8, 0.5, -8)
                local val = math.floor(feat.min + (feat.max - feat.min) * relX)
                label.Text = feat.name .. ": " .. val
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end
end

-- ============================================
-- BOTTOM BUTTONS (Fixed at bottom)
-- ============================================
local bottomFrame = Instance.new("Frame")
bottomFrame.Size = UDim2.new(1, 0, 0, 45)
bottomFrame.Position = UDim2.new(0, 0, 1, -45)
bottomFrame.BackgroundColor3 = COLORS.Header
bottomFrame.BorderSizePixel = 0
bottomFrame.Parent = main

local bottomCorner = Instance.new("UICorner")
bottomCorner.CornerRadius = UDim.new(0, 8)
bottomCorner.Parent = bottomFrame

local bottomFix = Instance.new("Frame")
bottomFix.Size = UDim2.new(1, 0, 0, 15)
bottomFix.BackgroundColor3 = COLORS.Header
bottomFix.BorderSizePixel = 0
bottomFix.Parent = bottomFrame

-- Hide/Kill (Hold) Button
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0.48, -4, 0, 32)
hideBtn.Position = UDim2.new(0, 6, 0.5, -16)
hideBtn.BackgroundColor3 = COLORS.ButtonHide
hideBtn.BorderSizePixel = 0
hideBtn.Font = Enum.Font.GothamBold
hideBtn.Text = "HIDE/KILL (HOLD)"
hideBtn.TextColor3 = COLORS.TextTitle
hideBtn.TextSize = 11
hideBtn.Parent = bottomFrame

local hideBtnCorner = Instance.new("UICorner")
hideBtnCorner.CornerRadius = UDim.new(0, 6)
hideBtnCorner.Parent = hideBtn

-- Minimize Button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0.48, -4, 0, 32)
minBtn.Position = UDim2.new(0.52, -2, 0.5, -16)
minBtn.BackgroundColor3 = COLORS.ButtonMinimize
minBtn.BorderSizePixel = 0
minBtn.Font = Enum.Font.GothamBold
minBtn.Text = "MINIMIZE"
minBtn.TextColor3 = COLORS.TextTitle
minBtn.TextSize = 11
minBtn.Parent = bottomFrame

local minBtnCorner = Instance.new("UICorner")
minBtnCorner.CornerRadius = UDim.new(0, 6)
minBtnCorner.Parent = minBtn

-- ============================================
-- FLOATING ICON (Circular, Draggable)
-- ============================================
local floatingIcon = Instance.new("TextButton")
floatingIcon.Name = "FloatingIcon"
floatingIcon.Size = UDim2.fromOffset(56, 56)
floatingIcon.Position = UDim2.new(0, 20, 0.5, -28)
floatingIcon.BackgroundColor3 = COLORS.FloatingIcon
floatingIcon.BorderSizePixel = 0
floatingIcon.Text = "OPEN\nMOD MENU"
floatingIcon.TextColor3 = COLORS.FloatingStroke
floatingIcon.TextSize = 9
floatingIcon.Font = Enum.Font.GothamBold
floatingIcon.Visible = false
floatingIcon.Parent = gui

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(1, 0)
floatCorner.Parent = floatingIcon

local floatStroke = Instance.new("UIStroke")
floatStroke.Color = COLORS.FloatingStroke
floatStroke.Thickness = 2
floatStroke.Parent = floatingIcon

-- Draggable floating icon
local dragIcon = false
local dragStartPos, iconStartPos

floatingIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragIcon = true
        dragStartPos = input.Position
        iconStartPos = floatingIcon.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragIcon and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartPos
        floatingIcon.Position = UDim2.new(
            iconStartPos.X.Scale, iconStartPos.X.Offset + delta.X,
            iconStartPos.Y.Scale, iconStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragIcon = false
    end
end)

-- ============================================
-- ANIMATIONS & FUNCTIONALITY
-- ============================================
local isVisible = true
local isSettingsOpen = false

-- Slide positions (from left side, pabalik-balik)
local posVisible = UDim2.new(0.5, -170, 0.5, -200)
local posHidden = UDim2.new(0, -400, 0.5, -200)

local function updateHeight()
    local contentHeight = 70 + 32 -- header + category
    for _, child in ipairs(featuresFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            contentHeight = contentHeight + 40
        end
    end
    if isSettingsOpen then
        contentHeight = contentHeight + 200
    end
    contentHeight = math.min(contentHeight + 60, 500) -- cap height
    
    TweenService:Create(main, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 340, 0, contentHeight)
    }):Play()
end

local function slideIn()
    main.Visible = true
    floatingIcon.Visible = false
    TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = posVisible
    }):Play()
    isVisible = true
end

local function slideOut()
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Position = posHidden
    }):Play()
    task.delay(0.3, function()
        main.Visible = false
        floatingIcon.Visible = true
    end)
    isVisible = false
end

-- Button connections
minBtn.MouseButton1Click:Connect(slideOut)
floatingIcon.MouseButton1Click:Connect(slideIn)

hideBtn.MouseButton1Down:Connect(function()
    TweenService:Create(hideBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
end)

hideBtn.MouseButton1Up:Connect(function()
    gui:Destroy()
end)

-- Settings toggle
gearBtn.MouseButton1Click:Connect(function()
    isSettingsOpen = not isSettingsOpen
    settingsPanel.Visible = isSettingsOpen
    updateHeight()
end)

closeSettings.MouseButton1Click:Connect(function()
    isSettingsOpen = false
    settingsPanel.Visible = false
    updateHeight()
end)

-- Auto size initially
updateHeight()

-- Start animation
main.Position = posHidden
task.wait(0.3)
slideIn()

-- ============================================
-- AUTO FARM / AUTO PUNCH (Blox Fruits Ready)
-- ============================================
-- Add your features to the features table above
-- Example: Auto Farm, Auto Punch, ESP, etc.

print("LGL Mod Menu Loaded - Ready for Blox Fruits")
