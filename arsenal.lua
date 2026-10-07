local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Workspace        = game:GetService("Workspace")
local StarterGui       = game:GetService("StarterGui")
local VIM              = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera
local Mouse       = LocalPlayer:GetMouse()

local function getChar()  return LocalPlayer.Character end
local function getHRP()
    local c = getChar(); return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHum()
    local c = getChar(); return c and c:FindFirstChildOfClass("Humanoid")
end

local function hasLOS(origin, target)
    local dir = target - origin
    local rp  = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local ex = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then table.insert(ex, p.Character) end
    end
    rp.FilterDescendantsInstances = ex
    return Workspace:Raycast(origin, dir.Unit * dir.Magnitude, rp) == nil
end

local function worldToViewport(pos)
    local vp, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(vp.X, vp.Y), onScreen, vp.Z
end

local flags = {
    fly            = false,
    noclip         = false,
    shootWalls     = false,
    triggerbot     = false,
    esp            = false,
    espNames       = true,
    espBoxes       = true,
    espHealth      = true,
    espTracers     = true,
    espDistance    = true,
    espWallCheck   = false,
    aimbot         = false,
    aimbotHead     = true,
    aimbotSmooth   = true,
    teamCheck      = true,
    hitbox         = false,
    speed          = false,
    infJump        = false,
    killAura       = false,
    antiAfk        = false,
    godMode        = false,
}

local FLY_SPEED    = 60
local SPEED_MULT   = 1.5
local AIMBOT_FOV   = 120
local AIMBOT_SMOOTH= 0.5
local KILLAURA_R   = 15
local HITBOX_SIZE  = 10

local function isEnemy(p)
    if p == LocalPlayer then return false end
    if flags.teamCheck then
        local myTeam    = LocalPlayer.Team
        local theirTeam = p.Team
        if myTeam and theirTeam then return myTeam ~= theirTeam end
    end
    return true
end

local hitboxOriginals = {}

local function applyHitbox(p)
    if not isEnemy(p) then return end
    local char = p.Character; if not char then return end
    local hrp  = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    if not hitboxOriginals[p] then hitboxOriginals[p] = hrp.Size end
    hrp.Size = Vector3.new(HITBOX_SIZE, HITBOX_SIZE, HITBOX_SIZE)
    hrp.Transparency = 1
end

local function restoreHitbox(p)
    local orig = hitboxOriginals[p]; if not orig then return end
    local char = p.Character; if not char then return end
    local hrp  = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    hrp.Size = orig
    hitboxOriginals[p] = nil
end

local function enableHitbox() for _, p in ipairs(Players:GetPlayers()) do applyHitbox(p) end end
local function disableHitbox() for _, p in ipairs(Players:GetPlayers()) do restoreHitbox(p) end; hitboxOriginals = {} end

RunService.Heartbeat:Connect(function()
    if not flags.hitbox then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if not isEnemy(p) then continue end
        local char = p.Character; if not char then continue end
        local hrp  = char:FindFirstChild("HumanoidRootPart"); if not hrp then continue end
        if hrp.Size.X < HITBOX_SIZE then applyHitbox(p) end
    end
end)

Players.PlayerRemoving:Connect(function(p) hitboxOriginals[p] = nil end)

local flyBV, flyBG
local function enableFly()
    local hrp = getHRP(); if not hrp then return end
    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(9e9,9e9,9e9); flyBG.P = 9e4
    flyBG.CFrame = hrp.CFrame; flyBG.Parent = hrp
    flyBV = Instance.new("BodyVelocity")
    flyBV.Velocity = Vector3.zero
    flyBV.MaxForce = Vector3.new(9e9,9e9,9e9); flyBV.Parent = hrp
end
local function disableFly()
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end
end

RunService.Heartbeat:Connect(function()
    if not flags.fly then return end
    local hrp = getHRP(); if not hrp or not flyBV or not flyBG then return end
    local v = Vector3.zero
    local ui = UserInputService
    if ui:IsKeyDown(Enum.KeyCode.W)         then v = v + Camera.CFrame.LookVector  end
    if ui:IsKeyDown(Enum.KeyCode.S)         then v = v - Camera.CFrame.LookVector  end
    if ui:IsKeyDown(Enum.KeyCode.A)         then v = v - Camera.CFrame.RightVector end
    if ui:IsKeyDown(Enum.KeyCode.D)         then v = v + Camera.CFrame.RightVector end
    if ui:IsKeyDown(Enum.KeyCode.Space)     then v = v + Vector3.yAxis             end
    if ui:IsKeyDown(Enum.KeyCode.LeftShift) then v = v - Vector3.yAxis             end
    flyBV.Velocity = v * FLY_SPEED
    flyBG.CFrame   = Camera.CFrame
end)

RunService.Stepped:Connect(function()
    if not flags.noclip then return end
    local c = getChar(); if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
end)

local shootWallConn
local function enableShootWall()
    if shootWallConn then return end
    shootWallConn = RunService.Heartbeat:Connect(function()
        if not flags.shootWalls then return end
        local t = Mouse.Target
        if not t or not t:IsA("BasePart") then return end
        local inChar = false
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and t:IsDescendantOf(p.Character) then inChar = true; break end
        end
        if inChar then return end
        local orig = t.CanCollide; t.CanCollide = false
        task.defer(function() if t and t.Parent then t.CanCollide = orig end end)
    end)
end
local function disableShootWall()
    if shootWallConn then shootWallConn:Disconnect(); shootWallConn = nil end
end

local triggerbotConn
local function getEnemyAtCrosshair()
    local vp = Camera.ViewportSize
    local unitRay = Camera:ScreenPointToRay(vp.X / 2, vp.Y / 2)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local exclude = {}; local myChar = getChar()
    if myChar then table.insert(exclude, myChar) end
    rp.FilterDescendantsInstances = exclude
    local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, rp)
    if not result then return nil, nil end
    local hitPart = result.Instance
    for _, p in ipairs(Players:GetPlayers()) do
        if not isEnemy(p) then continue end
        local char = p.Character; if not char then continue end
        if not hitPart:IsDescendantOf(char) then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then return char, hitPart end
    end
    return nil, nil
end

local function triggerFireTool(enemyChar, hitPart)
    local char = getChar(); if not char then return end
    local tool = char:FindFirstChildOfClass("Tool"); if not tool then return end
    local hitPos    = hitPart and hitPart.Position or Mouse.Hit.Position
    local hitNormal = Vector3.new(0, 1, 0)
    for _, obj in ipairs(tool:GetDescendants()) do
        if not obj:IsA("RemoteEvent") then continue end
        pcall(function() obj:FireServer(hitPos, hitPart, hitNormal) end)
        pcall(function() obj:FireServer(hitPos, hitPart) end)
        pcall(function() obj:FireServer(hitPos) end)
    end
    for _, name in ipairs({"RE","Fire","Shoot","FireWeapon","ShootEvent","RemoteEvent","BulletEvent","HitEvent","Attack"}) do
        local r = tool:FindFirstChild(name)
        if r and r:IsA("RemoteEvent") then
            pcall(function() r:FireServer(hitPos, hitPart, hitNormal) end)
            pcall(function() r:FireServer(hitPos) end)
        end
    end
    pcall(function() VIM:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, true, game, 1); VIM:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, false, game, 1) end)
end

local function enableTriggerbot()
    if triggerbotConn then return end
    triggerbotConn = RunService.Heartbeat:Connect(function()
        if not flags.triggerbot then return end
        local enemyChar, hitPart = getEnemyAtCrosshair()
        if not enemyChar then return end
        triggerFireTool(enemyChar, hitPart)
    end)
end
local function disableTriggerbot()
    if triggerbotConn then triggerbotConn:Disconnect(); triggerbotConn = nil end
end

local espFolder = Instance.new("Folder")
espFolder.Name  = "ESP_Drawings"
espFolder.Parent = LocalPlayer.PlayerGui

local espObjects = {}
local ESP_COLOR     = Color3.fromRGB(255, 105, 180) 
local TRACER_COLOR  = Color3.fromRGB(255, 105, 180)

local function newDrawing(type_, props)
    local d = Drawing.new(type_)
    for k, v in pairs(props) do d[k] = v end
    return d
end

local function removeESPForPlayer(p)
    local objs = espObjects[p]
    if not objs then return end
    for _, d in pairs(objs) do
        if typeof(d) == "table" then
            for _, dd in pairs(d) do pcall(function() dd:Remove() end) end
        else pcall(function() d:Remove() end) end
    end
    espObjects[p] = nil
end

local function createESPForPlayer(p)
    if p == LocalPlayer then return end
    removeESPForPlayer(p)
    local objs = {}
    objs.boxLines = {}
    for i = 1, 4 do objs.boxLines[i] = newDrawing("Line", {Visible=false, Color=ESP_COLOR, Thickness=1.5, Transparency=1, ZIndex=5}) end
    objs.cornerLines = {}
    for i = 1, 8 do objs.cornerLines[i] = newDrawing("Line", {Visible=false, Color=Color3.fromRGB(255,255,255), Thickness=2, Transparency=1, ZIndex=6}) end
    objs.nameLabel = newDrawing("Text", {Visible=false, Color=Color3.fromRGB(255,255,255), Size=13, Font=Drawing.Fonts.UI, Outline=true, OutlineColor=Color3.fromRGB(0,0,0), Center=true, ZIndex=7})
    objs.distLabel = newDrawing("Text", {Visible=false, Color=Color3.fromRGB(255,192,203), Size=11, Font=Drawing.Fonts.UI, Outline=true, OutlineColor=Color3.fromRGB(0,0,0), Center=true, ZIndex=7})
    objs.healthBg = newDrawing("Line", {Visible=false, Color=Color3.fromRGB(0,0,0), Thickness=4, Transparency=1, ZIndex=4})
    objs.healthBar = newDrawing("Line", {Visible=false, Color=Color3.fromRGB(255,20,147), Thickness=3, Transparency=1, ZIndex=5})
    objs.tracer = newDrawing("Line", {Visible=false, Color=TRACER_COLOR, Thickness=1, Transparency=0.7, ZIndex=3})
    espObjects[p] = objs
end

local function updateESP()
    if not flags.esp then
        for p, objs in pairs(espObjects) do
            for _, v in pairs(objs) do
                if typeof(v) == "table" then for _, d in pairs(v) do pcall(function() d.Visible = false end) end
                else pcall(function() v.Visible = false end) end
            end
        end
        return
    end

    local vp = Camera.ViewportSize
    local tracerOrigin = Vector2.new(vp.X / 2, vp.Y)

    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        if not espObjects[p] then createESPForPlayer(p) end

        local objs = espObjects[p]
        local char = p.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")

        if not hrp or not hum or hum.Health <= 0 then
            for _, v in pairs(objs) do
                if typeof(v) == "table" then for _, d in pairs(v) do pcall(function() d.Visible = false end) end
                else pcall(function() v.Visible = false end) end
            end
            continue
        end

        local myHRP = getHRP()
        if flags.espWallCheck and myHRP and not hasLOS(myHRP.Position, hrp.Position) then
            for _, v in pairs(objs) do
                if typeof(v) == "table" then for _, d in pairs(v) do pcall(function() d.Visible = false end) end
                else pcall(function() v.Visible = false end) end
            end
            continue
        end

        local head = char:FindFirstChild("Head")
        local headPos = head and head.Position or (hrp.Position + Vector3.new(0, 2.5, 0))
        local feetPos = hrp.Position - Vector3.new(0, 2.8, 0)
        local topScreen, topOn, topZ = worldToViewport(headPos + Vector3.new(0, 0.4, 0))
        local bottomScreen, bottomOn, _ = worldToViewport(feetPos)

        if not (topOn or bottomOn) or topZ < 0 then
            for _, v in pairs(objs) do
                if typeof(v) == "table" then for _, d in pairs(v) do pcall(function() d.Visible = false end) end
                else pcall(function() v.Visible = false end) end
            end
            continue
        end

        local height = math.abs(topScreen.Y - bottomScreen.Y)
        local width  = height * 0.5
        local cx     = topScreen.X
        local L, R, T, B = cx - width / 2, cx + width / 2, topScreen.Y, bottomScreen.Y
        local dist = myHRP and math.floor((myHRP.Position - hrp.Position).Magnitude) or 0
        local hpRatio = hum.MaxHealth > 0 and math.clamp(hum.Health / hum.MaxHealth, 0, 1) or 0
        local hpColor = Color3.fromRGB(255, math.floor(20 + (100 * hpRatio)), math.floor(100 + (80 * hpRatio)))

        if flags.espBoxes then
            local bl = objs.boxLines
            bl[1].From = Vector2.new(L, T); bl[1].To = Vector2.new(R, T); bl[1].Visible = true; bl[1].Color = ESP_COLOR
            bl[2].From = Vector2.new(L, B); bl[2].To = Vector2.new(R, B); bl[2].Visible = true; bl[2].Color = ESP_COLOR
            bl[3].From = Vector2.new(L, T); bl[3].To = Vector2.new(L, B); bl[3].Visible = true; bl[3].Color = ESP_COLOR
            bl[4].From = Vector2.new(R, T); bl[4].To = Vector2.new(R, B); bl[4].Visible = true; bl[4].Color = ESP_COLOR
            local cw, ch, cl = width * 0.28, height * 0.18, objs.cornerLines
            cl[1].From=Vector2.new(L,T); cl[1].To=Vector2.new(L+cw,T); cl[1].Visible=true
            cl[2].From=Vector2.new(L,T); cl[2].To=Vector2.new(L,T+ch); cl[2].Visible=true
            cl[3].From=Vector2.new(R,T); cl[3].To=Vector2.new(R-cw,T); cl[3].Visible=true
            cl[4].From=Vector2.new(R,T); cl[4].To=Vector2.new(R,T+ch); cl[4].Visible=true
            cl[5].From=Vector2.new(L,B); cl[5].To=Vector2.new(L+cw,B); cl[5].Visible=true
            cl[6].From=Vector2.new(L,B); cl[6].To=Vector2.new(L,B-ch); cl[6].Visible=true
            cl[7].From=Vector2.new(R,B); cl[7].To=Vector2.new(R-cw,B); cl[7].Visible=true
            cl[8].From=Vector2.new(R,B); cl[8].To=Vector2.new(R,B-ch); cl[8].Visible=true
        else
            for _, l in ipairs(objs.boxLines) do l.Visible = false end
            for _, l in ipairs(objs.cornerLines) do l.Visible = false end
        end

        objs.nameLabel.Text, objs.nameLabel.Position, objs.nameLabel.Visible = p.DisplayName, Vector2.new(cx, T - 16), flags.espNames
        objs.distLabel.Text, objs.distLabel.Position, objs.distLabel.Visible = dist .. "m", Vector2.new(cx, B + 3), flags.espDistance

        if flags.espHealth then
            local barX = L - 5
            objs.healthBg.From, objs.healthBg.To, objs.healthBg.Visible = Vector2.new(barX, T), Vector2.new(barX, B), true
            objs.healthBar.From, objs.healthBar.To, objs.healthBar.Color, objs.healthBar.Visible = Vector2.new(barX, B - (B - T) * hpRatio), Vector2.new(barX, B), hpColor, true
        else
            objs.healthBg.Visible, objs.healthBar.Visible = false, false
        end

        if flags.espTracers then
            local centerScreen, _, _ = worldToViewport(hrp.Position)
            objs.tracer.From, objs.tracer.To, objs.tracer.Visible = tracerOrigin, centerScreen, true
        else
            objs.tracer.Visible = false
        end
    end
end
Players.PlayerRemoving:Connect(removeESPForPlayer)
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then createESPForPlayer(p) end end
Players.PlayerAdded:Connect(function(p) task.wait(1); createESPForPlayer(p) end)

local fovCircle = Drawing.new("Circle")
fovCircle.Visible, fovCircle.Color, fovCircle.Thickness, fovCircle.NumSides, fovCircle.Filled, fovCircle.Transparency = false, Color3.fromRGB(255, 105, 180), 2, 64, false, 1

local aimbotHue = 0
local function getBestAimTarget()
    local mPos, myHRP, best, bestDist = UserInputService:GetMouseLocation(), getHRP(), nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer or not isEnemy(p) then continue end
        local char = p.Character; if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local aimPart = (flags.aimbotHead and char:FindFirstChild("Head")) or char:FindFirstChild("HumanoidRootPart")
        if not aimPart or (myHRP and not hasLOS(myHRP.Position, aimPart.Position)) then continue end
        local vPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
        if not onScreen or vPos.Z <= 0 then continue end
        local d = (Vector2.new(vPos.X, vPos.Y) - mPos).Magnitude
        if d < AIMBOT_FOV and d < bestDist then best, bestDist = aimPart, d end
    end
    return best
end

local aimbotConn
local function enableAimbot()
    if aimbotConn then return end
    aimbotConn = RunService.RenderStepped:Connect(function(dt)
        aimbotHue = (aimbotHue + dt * 0.4) % 1
        fovCircle.Position, fovCircle.Radius, fovCircle.Color, fovCircle.Visible = UserInputService:GetMouseLocation(), AIMBOT_FOV, Color3.fromHSV(aimbotHue, 0.6, 1), flags.aimbot
        if not flags.aimbot then return end
        local target = getBestAimTarget()
        if not target then return end
        local goalCF = CFrame.lookAt(Camera.CFrame.Position, target.Position)
        Camera.CFrame = flags.aimbotSmooth and Camera.CFrame:Lerp(goalCF, 0.35) or goalCF
    end)
end
local function disableAimbot()
    if aimbotConn then aimbotConn:Disconnect(); aimbotConn = nil end
    fovCircle.Visible = false
end

local defaultWalkSpeed = 16
RunService.Heartbeat:Connect(function()
    local hum = getHum(); if not hum then return end
    hum.WalkSpeed = flags.speed and (defaultWalkSpeed * SPEED_MULT) or (hum.WalkSpeed ~= defaultWalkSpeed and not flags.fly and defaultWalkSpeed or hum.WalkSpeed)
end)

UserInputService.JumpRequest:Connect(function()
    if not flags.infJump then return end
    local hum = getHum()
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

local killAuraConn, killAuraCooldown = nil, {}
local function enableKillAura()
    if killAuraConn then return end
    killAuraConn = RunService.Heartbeat:Connect(function()
        if not flags.killAura then return end
        local char = getChar(); local hrp = getHRP(); local tool = char and char:FindFirstChildOfClass("Tool")
        if not hrp then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if not isEnemy(p) then continue end
            local eChar = p.Character; local eHRP = eChar and eChar:FindFirstChild("HumanoidRootPart")
            local eHum = eChar and eChar:FindFirstChildOfClass("Humanoid")
            if not eHRP or not eHum or eHum.Health <= 0 or (hrp.Position - eHRP.Position).Magnitude > KILLAURA_R then continue end
            local now = tick(); if killAuraCooldown[p] and (now - killAuraCooldown[p]) < 0.12 then continue end
            killAuraCooldown[p] = now
            local prevCT, prevCF = Camera.CameraType, Camera.CFrame
            Camera.CameraType, Camera.CFrame = Enum.CameraType.Scriptable, CFrame.new(Camera.CFrame.Position, eHRP.Position)
            pcall(function() VIM:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, true, game, 1); VIM:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, false, game, 1) end)
            if tool then
                for _, obj in ipairs(tool:GetDescendants()) do
                    if obj:IsA("RemoteEvent") then pcall(function() obj:FireServer(eHRP, 100) end) end
                end
            end
            task.defer(function() pcall(function() Camera.CameraType, Camera.CFrame = prevCT, prevCF end) end)
        end
    end)
end
local function disableKillAura() if killAuraConn then killAuraConn:Disconnect(); killAuraConn = nil end; killAuraCooldown = {} end

local antiAfkConn
local function enableAntiAfk()
    if antiAfkConn then return end
    antiAfkConn = task.spawn(function()
        while flags.antiAfk do
            task.wait(110); if not flags.antiAfk then break end
            local hum = getHum(); if hum then hum.Jump = true end
            pcall(function() game:GetService("VirtualUser"):CaptureController(); game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end)
        end
    end)
end
local function disableAntiAfk() flags.antiAfk = false; antiAfkConn = nil end

RunService.Heartbeat:Connect(function()
    if not flags.godMode then return end
    local hum = getHum(); if hum and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
end)
RunService.RenderStepped:Connect(updateESP)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "PradaxcaDashboard"
ScreenGui.Parent         = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder   = 999

local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenUI"
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 15, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 15, 25)
OpenBtn.Text = "🎀"
OpenBtn.TextSize = 20
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local OBStroke = Instance.new("UIStroke")
OBStroke.Color = Color3.fromRGB(255, 105, 180)
OBStroke.Thickness = 2
OBStroke.Parent = OpenBtn

local MainFrame = Instance.new("Frame")
MainFrame.Name              = "MainFrame"
MainFrame.Size              = UDim2.new(0, 600, 0, 360) 
MainFrame.Position          = UDim2.new(0.5, -300, 0.5, -180)
MainFrame.BackgroundColor3  = Color3.fromRGB(20, 10, 15)
MainFrame.BackgroundTransparency = 1 
MainFrame.BorderSizePixel   = 0
MainFrame.ClipsDescendants  = true
MainFrame.Parent            = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local BgImage = Instance.new("ImageLabel")
BgImage.Name = "BackgroundDecal"
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.Image = "rbxassetid://85750320211965" 
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.BackgroundTransparency = 1
BgImage.ZIndex = 0
BgImage.Parent = MainFrame

local BgOverlay = Instance.new("Frame")
BgOverlay.Name = "TintOverlay"
BgOverlay.Size = UDim2.new(1, 0, 1, 0)
BgOverlay.BackgroundColor3 = Color3.fromRGB(20, 10, 15)
BgOverlay.BackgroundTransparency = 0.35 
BgOverlay.BorderSizePixel = 0
BgOverlay.ZIndex = 1
BgOverlay.Parent = MainFrame

local MFStroke = Instance.new("UIStroke")
MFStroke.Color        = Color3.fromRGB(255, 105, 180)
MFStroke.Thickness    = 1.5
MFStroke.Transparency = 0.3
MFStroke.Parent       = MainFrame

local isUIOpen = true
local function toggleUI()
    isUIOpen = not isUIOpen
    if isUIOpen then
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 600, 0, 360),
            Position = UDim2.new(0.5, -300, 0.5, -180)
        }):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 500, 0, 0),
            Position = UDim2.new(0.5, -250, 0.5, 0)
        }):Play()
        task.delay(0.3, function() MainFrame.Visible = false end)
    end
end
OpenBtn.MouseButton1Click:Connect(toggleUI)

local Header = Instance.new("Frame")
Header.Size             = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 15, 25)
Header.BackgroundTransparency = 0.3
Header.BorderSizePixel  = 0; 
Header.ZIndex = 2
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local HCover = Instance.new("Frame")
HCover.Size = UDim2.new(1, 0, 0, 10)
HCover.Position = UDim2.new(0, 0, 1, -10)
HCover.BackgroundColor3 = Header.BackgroundColor3
HCover.BackgroundTransparency = Header.BackgroundTransparency
HCover.BorderSizePixel = 0; 
HCover.ZIndex = 2
HCover.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "🎀 pradaxca"
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 240, 245)
TitleLabel.Font = Enum.Font.BuilderSansBold
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 3
TitleLabel.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 1, 0)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 105, 180)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.BuilderSansBold
CloseBtn.ZIndex = 3
CloseBtn.Parent = Header

CloseBtn.MouseButton1Click:Connect(toggleUI)

local dragging, dragStart, startPos = false, nil, nil
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 35)
TabBar.Position = UDim2.new(0, 10, 0, 50)
TabBar.BackgroundTransparency = 1
TabBar.ZIndex = 2
TabBar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 6)
TabListLayout.Parent = TabBar

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 1, -100)
TabContainer.Position = UDim2.new(0, 10, 0, 90)
TabContainer.BackgroundTransparency = 1
TabContainer.ClipsDescendants = true 
TabContainer.ZIndex = 2
TabContainer.Parent = MainFrame

local tabs = {}
local rowOrders = {}
local currentTabScroll = nil

local function createTab(name, layoutOrder)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = name.."Btn"
    TabBtn.Size = UDim2.new(0.25, -5, 1, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 30)
    TabBtn.BackgroundTransparency = 0.2
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(255, 150, 190)
    TabBtn.Font = Enum.Font.BuilderSansBold
    TabBtn.TextSize = 13
    TabBtn.LayoutOrder = layoutOrder
    TabBtn.ZIndex = 3
    TabBtn.Parent = TabBar
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Name = name.."Scroll"
    Scroll.Size = UDim2.new(1, 0, 1, 0)
    Scroll.Position = UDim2.new(0, 50, 0, 0) 
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 4
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 105, 180)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Scroll.Visible = false
    Scroll.ZIndex = 3
    Scroll.Parent = TabContainer
    
    rowOrders[Scroll] = 0

    local List = Instance.new("UIListLayout")
    List.SortOrder = Enum.SortOrder.LayoutOrder
    List.Padding = UDim.new(0, 6)
    List.Parent = Scroll
    
    local LPad = Instance.new("UIPadding")
    LPad.PaddingTop = UDim.new(0, 2); LPad.PaddingBottom = UDim.new(0, 5)
    LPad.PaddingLeft = UDim.new(0, 2); LPad.PaddingRight = UDim.new(0, 2)
    LPad.Parent = Scroll

    TabBtn.MouseButton1Click:Connect(function()
        if currentTabScroll == Scroll then return end
        
        local oldScroll = currentTabScroll
        currentTabScroll = Scroll

        for _, t in pairs(tabs) do
            TweenService:Create(t.Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 20, 30), TextColor3 = Color3.fromRGB(255, 150, 190)}):Play()
        end
        TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 105, 180), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()

        if oldScroll then
            TweenService:Create(oldScroll, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, -50, 0, 0)}):Play()
            task.delay(0.25, function() if currentTabScroll ~= oldScroll then oldScroll.Visible = false end end)
        end

        Scroll.Position = UDim2.new(0, 50, 0, 0)
        Scroll.Visible = true
        TweenService:Create(Scroll, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    end)

    tabs[name] = {Btn = TabBtn, Scroll = Scroll}
    return Scroll
end

local MovementTab = createTab("Movement", 1)
local CombatTab   = createTab("Combat", 2)
local VisualTab   = createTab("Visuals", 3)
local UtilityTab  = createTab("Utility", 4)

currentTabScroll = tabs["Movement"].Scroll
tabs["Movement"].Btn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
tabs["Movement"].Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
tabs["Movement"].Scroll.Visible = true
tabs["Movement"].Scroll.Position = UDim2.new(0, 0, 0, 0)

local function makeToggleRow(parentTab, name, sub, color, onEnable, onDisable)
    rowOrders[parentTab] = (rowOrders[parentTab] or 0) + 1
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 52); Row.BackgroundColor3 = Color3.fromRGB(35, 20, 30)
    Row.BackgroundTransparency = 0.2
    Row.BorderSizePixel = 0; Row.LayoutOrder = rowOrders[parentTab]
    Row.ZIndex = 3; Row.Parent = parentTab
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 8)

    local Stripe = Instance.new("Frame")
    Stripe.Size = UDim2.new(0, 3, 0, 30); Stripe.Position = UDim2.new(0, 9, 0.5, -15)
    Stripe.BackgroundColor3 = color; Stripe.BorderSizePixel = 0; 
    Stripe.ZIndex = 4; Stripe.Parent = Row
    Instance.new("UICorner", Stripe).CornerRadius = UDim.new(1, 0)

    local NL = Instance.new("TextLabel")
    NL.Text = name; NL.Size = UDim2.new(0, 400, 0, 20); NL.Position = UDim2.new(0, 21, 0.5, -19)
    NL.BackgroundTransparency = 1; NL.TextColor3 = Color3.fromRGB(255, 240, 245)
    NL.Font = Enum.Font.BuilderSansMedium; NL.TextSize = 13; NL.TextXAlignment = Enum.TextXAlignment.Left; 
    NL.ZIndex = 4; NL.Parent = Row

    local SL = Instance.new("TextLabel")
    SL.Text = sub; SL.Size = UDim2.new(0, 400, 0, 14); SL.Position = UDim2.new(0, 21, 0.5, 3)
    SL.BackgroundTransparency = 1; SL.TextColor3 = Color3.fromRGB(255, 150, 190)
    SL.Font = Enum.Font.BuilderSans; SL.TextSize = 10; SL.TextXAlignment = Enum.TextXAlignment.Left; 
    SL.ZIndex = 4; SL.Parent = Row

    local isOn = false
    local Btn  = Instance.new("TextButton")
    Btn.Text = "OFF"; Btn.Size = UDim2.new(0, 46, 0, 26); Btn.Position = UDim2.new(1, -52, 0.5, -13)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 30, 40); Btn.TextColor3 = Color3.fromRGB(255, 150, 190)
    Btn.Font = Enum.Font.BuilderSansBold; Btn.TextSize = 10; Btn.BorderSizePixel = 0
    Btn.AutoButtonColor = false; Btn.ZIndex = 4; Btn.Parent = Row
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    Btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            Btn.Text = "ON"; TweenService:Create(Btn, TweenInfo.new(0.18), {BackgroundColor3=color, TextColor3=Color3.fromRGB(255,255,255)}):Play()
            if onEnable then onEnable() end
        else
            Btn.Text = "OFF"; TweenService:Create(Btn, TweenInfo.new(0.18), {BackgroundColor3=Color3.fromRGB(50, 30, 40), TextColor3=Color3.fromRGB(255, 150, 190)}):Play()
            if onDisable then onDisable() end
        end
    end)
end

local function makeSubToggle(parentTab, name, flag, color)
    rowOrders[parentTab] = (rowOrders[parentTab] or 0) + 1
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -14, 0, 36); Row.BackgroundColor3 = Color3.fromRGB(30, 15, 25)
    Row.BackgroundTransparency = 0.2
    Row.BorderSizePixel = 0; Row.LayoutOrder = rowOrders[parentTab]; 
    Row.ZIndex = 3; Row.Parent = parentTab
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 7)

    local Indent = Instance.new("Frame")
    Indent.Size = UDim2.new(0, 2, 0, 18); Indent.Position = UDim2.new(0, 12, 0.5, -9)
    Indent.BackgroundColor3 = color; Indent.BorderSizePixel = 0; 
    Indent.ZIndex = 4; Indent.Parent = Row
    Instance.new("UICorner", Indent).CornerRadius = UDim.new(1, 0)

    local NL = Instance.new("TextLabel")
    NL.Text = "  └  " .. name; NL.Size = UDim2.new(1, -80, 1, 0); NL.Position = UDim2.new(0, 18, 0, 0)
    NL.BackgroundTransparency = 1; NL.TextColor3 = Color3.fromRGB(255, 180, 210)
    NL.Font = Enum.Font.BuilderSans; NL.TextSize = 12; NL.TextXAlignment = Enum.TextXAlignment.Left; 
    NL.ZIndex = 4; NL.Parent = Row

    local isOn = flags[flag]
    local Btn  = Instance.new("TextButton")
    Btn.Text = isOn and "ON" or "OFF"
    Btn.Size = UDim2.new(0, 40, 0, 22); Btn.Position = UDim2.new(1, -46, 0.5, -11)
    Btn.BackgroundColor3 = isOn and color or Color3.fromRGB(45, 25, 35)
    Btn.TextColor3 = isOn and Color3.fromRGB(255,255,255) or Color3.fromRGB(255, 150, 190)
    Btn.Font = Enum.Font.BuilderSansBold; Btn.TextSize = 9; Btn.BorderSizePixel = 0; 
    Btn.ZIndex = 4; Btn.Parent = Row
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)

    Btn.MouseButton1Click:Connect(function()
        isOn = not isOn; flags[flag] = isOn
        if isOn then
            Btn.Text = "ON"; TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3=color, TextColor3=Color3.fromRGB(255,255,255)}):Play()
        else
            Btn.Text = "OFF"; TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3=Color3.fromRGB(45, 25, 35), TextColor3=Color3.fromRGB(255, 150, 190)}):Play()
        end
    end)
end

makeToggleRow(MovementTab, "Fly", "W/A/S/D + Space / Shift", Color3.fromRGB(255, 140, 200), function() flags.fly = true; enableFly() end, function() flags.fly = false; disableFly() end)
makeToggleRow(MovementTab, "Noclip", "Phase through all geometry", Color3.fromRGB(255, 140, 200), function() flags.noclip = true end, function() flags.noclip = false; local c = getChar(); if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end end)
makeToggleRow(MovementTab, "Speed Boost", "x2.5 walk speed multiplier", Color3.fromRGB(255, 140, 200), function() flags.speed = true end, function() flags.speed = false; local h=getHum(); if h then h.WalkSpeed=defaultWalkSpeed end end)
makeToggleRow(MovementTab, "Infinite Jump", "Jump infinitely in the air", Color3.fromRGB(255, 140, 200), function() flags.infJump = true end, function() flags.infJump = false end)

makeToggleRow(VisualTab, "ESP Master Toggle", "Boxes • Names • HP • Tracers", Color3.fromRGB(255, 105, 180), function() flags.esp = true end, function() flags.esp = false end)
makeSubToggle(VisualTab, "Show Names",      "espNames",     Color3.fromRGB(255, 105, 180))
makeSubToggle(VisualTab, "Show Boxes",      "espBoxes",     Color3.fromRGB(255, 105, 180))
makeSubToggle(VisualTab, "Show Health Bar", "espHealth",    Color3.fromRGB(255, 105, 180))
makeSubToggle(VisualTab, "Show Tracers",    "espTracers",   Color3.fromRGB(255, 105, 180))
makeSubToggle(VisualTab, "Show Distance",   "espDistance",  Color3.fromRGB(255, 105, 180))
makeSubToggle(VisualTab, "Wall Check",      "espWallCheck", Color3.fromRGB(255, 105, 180))

makeToggleRow(CombatTab, "Aimbot", "Always-on FOV lock • LOS check", Color3.fromRGB(255, 20, 147), function() flags.aimbot = true; enableAimbot() end, function() flags.aimbot = false; disableAimbot() end)
makeSubToggle(CombatTab, "Aim at Head (off = Torso)", "aimbotHead",   Color3.fromRGB(255, 20, 147))
makeSubToggle(CombatTab, "Smooth Aim",               "aimbotSmooth", Color3.fromRGB(255, 20, 147))
makeSubToggle(CombatTab, "Team Check (skip allies)", "teamCheck",    Color3.fromRGB(255, 20, 147))
makeToggleRow(CombatTab, "Triggerbot", "Auto-fire on target", Color3.fromRGB(255, 20, 147), function() flags.triggerbot = true; enableTriggerbot() end, function() flags.triggerbot = false; disableTriggerbot() end)
makeToggleRow(CombatTab, "Hitbox Expander", "Grow enemy HRP", Color3.fromRGB(255, 20, 147), function() flags.hitbox = true; enableHitbox() end, function() flags.hitbox = false; disableHitbox() end)
makeToggleRow(CombatTab, "Shoot Through Walls", "Bypass geometry collision", Color3.fromRGB(255, 20, 147), function() flags.shootWalls = true; enableShootWall() end, function() flags.shootWalls = false; disableShootWall() end)
makeToggleRow(CombatTab, "Kill Aura", "Instant kill in 15-stud radius", Color3.fromRGB(255, 20, 147), function() flags.killAura = true; enableKillAura() end, function() flags.killAura = false; disableKillAura() end)

makeToggleRow(UtilityTab, "God Mode", "Restore health every frame", Color3.fromRGB(219, 112, 147), function() flags.godMode = true end, function() flags.godMode = false end)
makeToggleRow(UtilityTab, "Anti-AFK", "Prevent auto-kick (2 min ping)", Color3.fromRGB(219, 112, 147), function() flags.antiAfk = true; enableAntiAfk() end, function() disableAntiAfk() end)
makeToggleRow(UtilityTab, "Auto Farm", "Proximity farm loop", Color3.fromRGB(219, 112, 147), nil, nil)
makeToggleRow(UtilityTab, "Chest Collector", "Auto-open nearby chests", Color3.fromRGB(219, 112, 147), nil, nil)

MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 600, 0, 360),
    Position = UDim2.new(0.5, -300, 0.5, -180)
}):Play()