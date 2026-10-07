

  -- Game Name Roblox : Alkedion PVP

-- ATX PVP — deobfuscated, keyless
-- Source: pastebin.com/raw/aPSQuXXz (XOR string obfuscation + ATX key gate removed)

print("[ATX PVP] Loading")

local function safeGet(name, fallback)
    local ok, v = pcall(function()
        if getgenv then return getgenv()[name] end
    end)
    if ok and v ~= nil then return v end
    local ok2, v2 = pcall(function() return _G[name] end)
    if ok2 and v2 ~= nil then return v2 end
    return fallback
end

local mouse1clickFn      = safeGet("mouse1click", nil)
local identifyexecutorFn = safeGet("identifyexecutor", nil)
local hookfunctionFn     = safeGet("hookfunction", nil)
local newcclosureFn      = safeGet("newcclosure", function(f) return f end)
local setclipboardFn     = safeGet("setclipboard", nil)
local getgcFn            = safeGet("getgc", nil) or (debug and debug.getgc)
local getconstantsFn     = safeGet("getconstants", nil) or (debug and debug.getconstants)
local setconstantFn      = safeGet("setconstant", nil) or (debug and debug.setconstant)
local iscclosureFn       = safeGet("iscclosure", function() return false end)

local SESSION = { Marker = {} }
getgenv().__ATXPVP_Session = SESSION.Marker
local function alive() return getgenv().__ATXPVP_Session == SESSION.Marker end

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TeleportService   = game:GetService("TeleportService")
local VirtualUser       = game:GetService("VirtualUser")
local LocalPlayer       = Players.LocalPlayer
local Camera            = workspace.CurrentCamera

local executorName = "Unknown"
if identifyexecutorFn then pcall(function() executorName = identifyexecutorFn() end) end
print("[ATX PVP] Executor: " .. tostring(executorName))




local Remotes = {}
do
    local function sg(root, ...)
        local cur = root
        for i = 1, select("#", ...) do
            local seg = select(i, ...)
            if not cur then return nil end
            cur = cur:FindFirstChild(seg)
        end
        return cur
    end
    Remotes.Shoot       = sg(ReplicatedStorage, "Blaster", "Remotes", "Shoot")
    Remotes.Reload      = sg(ReplicatedStorage, "Blaster", "Remotes", "Reload")
    Remotes.KillFeed    = sg(ReplicatedStorage, "Remotes", "Events", "KillFeedRemote")
    Remotes.MatchUISync = sg(ReplicatedStorage, "Remotes", "PVP_MatchUISync")
    Remotes.GetPing     = ReplicatedStorage:FindFirstChild("GetPing")
end




local Config = {

    Aimbot              = false,
    AimbotFOV           = 400,
    AimbotTargetPart    = "Auto",
    AimbotPriority      = "Crosshair",
    AimbotAutoShoot     = false,
    AimbotAutoShootRange= 25,


    Triggerbot          = false,
    TriggerbotKey       = Enum.KeyCode.Q,
    TriggerbotDelay     = 0.05,


    NoRecoil            = false,
    NoSpread            = false,
    RapidFire           = false,
    InfiniteAmmo        = false,
    AutoReload          = false,


    HitboxExpander      = false,
    HitboxSize          = 8,


    PlayerESP           = true,
    ESPName             = true,
    ESPDistance         = true,
    ESPHealth           = true,
    ESPChams            = true,
    ESPBox              = false,
    ESPShowTeammates    = false,
    ESPMaxDist          = 3000,


    Fly                 = false,
    FlySpeed            = 60,
    Noclip              = false,
    SpeedToggle         = false,
    SpeedValue          = 40,
    JumpPower           = 60,
    AutoBhop            = false,


    AntiAFK             = true,
    CameraFOV           = 90,
    BypassEnabled       = true,
}




local State = {
    MyUserId = LocalPlayer.UserId,
    MyTeam = nil,
    BlueTeam = {},
    RedTeam = {},
    Target = nil,
    LockedTarget = nil,
}




local function getChar(plr)
    plr = plr or LocalPlayer
    return plr.Character
end
local function getHRP(plr)
    local c = getChar(plr)
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHead(plr)
    local c = getChar(plr)
    return c and c:FindFirstChild("Head")
end
local function getHum(plr)
    local c = getChar(plr)
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function isAlive(plr)
    local h = getHum(plr)
    return h and h.Health > 0
end

local function notify(text, kind)
    pcall(function()
        WindUI:Notify({ Title = "ATX PVP", Content = tostring(text), Duration = 2.5,
            Icon = kind == "error" and "alert-circle" or "info" })
    end)
    print("[ATX PVP] " .. tostring(text))
end


local function fireWeapon()
    local char = LocalPlayer.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        local ok = pcall(function() tool:Activate() end)
        if ok then return true end
    end
    if mouse1clickFn then
        pcall(mouse1clickFn)
        return true
    end
    return false
end




local Bypass = { Enabled = true, Status = "Init" }
getgenv().__ATXPVP_Bypass = Bypass

do
    local function L1_Integrity()
        task.spawn(function()
            while alive() do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if root and root:GetAttribute("KillPartIgnore") ~= true then
                            root:SetAttribute("KillPartIgnore", true)
                        end
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then hum.BreakJointsOnDeath = false end
                    end
                end)
                task.wait(1)
            end
        end)
    end

    local function L2_AttributeSync()
        task.spawn(function()
            while alive() do
                task.wait(2)
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        for _, part in ipairs(char:GetChildren()) do
                            if part:IsA("BasePart") and part:GetAttribute("KillPartIgnore") ~= true then
                                part:SetAttribute("KillPartIgnore", true)
                            end
                        end
                    end
                end)
            end
        end)
    end

    local function L3_Evidence()
        task.spawn(function()
            while alive() do
                task.wait(2)
                pcall(function()
                    local env = getgenv()
                    for _, key in ipairs({ "__AntiCheatState", "__State", "__IntegrityState", "__ACState" }) do
                        local tbl = env[key]
                        if type(tbl) == "table" then
                            for k in pairs(tbl) do
                                if type(tbl[k]) == "number" then tbl[k] = 0 end
                            end
                        end
                    end
                end)
            end
        end)
    end

    local function L4_WipeUGI()
        if not (getconstantsFn and setconstantFn and debug and debug.info) then return end
        task.spawn(function()
            pcall(function()
                if type(getgcFn) ~= "function" then return end
                local ok, objs = pcall(getgcFn, true)
                if not ok or type(objs) ~= "table" then return end
                for i = 1, math.min(#objs, 3000) do
                    local obj = objs[i]
                    if typeof(obj) == "function" and not iscclosureFn(obj) then
                        local ok2, src = pcall(debug.info, obj, "s")
                        if ok2 and type(src) == "string" and src:find("UGI", 1, true) then
                            local okC, consts = pcall(getconstantsFn, obj)
                            if okC and type(consts) == "table" then
                                for idx, c in next, consts do
                                    if type(c) == "string" and c == "Humanoid" then
                                        pcall(setconstantFn, obj, idx, "")
                                    end
                                end
                            end
                        end
                    end
                    if i % 500 == 0 then
                        task.wait(0)
                        if not alive() then return end
                    end
                end
            end)
        end)
    end

    task.spawn(function()
        if not Config.BypassEnabled then Bypass.Status = "Disabled" return end
        Bypass.Status = "L1"; pcall(L1_Integrity); task.wait(0)
        Bypass.Status = "L2"; pcall(L2_AttributeSync); task.wait(0)
        Bypass.Status = "L3"; pcall(L3_Evidence); task.wait(0)
        Bypass.Status = "L4"; pcall(L4_WipeUGI)
        Bypass.Status = "4/4 Active"
        print("[ATX PVP] Bypass active")
    end)
end




if Remotes.MatchUISync then
    Remotes.MatchUISync.OnClientEvent:Connect(function(data)
        if type(data) ~= "table" then return end
        State.BlueTeam = {}
        State.RedTeam = {}
        if type(data.blue) == "table" then
            for _, m in ipairs(data.blue) do
                if m.userId then State.BlueTeam[m.userId] = true end
            end
        end
        if type(data.red) == "table" then
            for _, m in ipairs(data.red) do
                if m.userId then State.RedTeam[m.userId] = true end
            end
        end
        if State.BlueTeam[State.MyUserId] then State.MyTeam = "blue"
        elseif State.RedTeam[State.MyUserId] then State.MyTeam = "red"
        else State.MyTeam = nil end
    end)
end

local function isEnemy(plr)
    if plr == LocalPlayer then return false end
    if not State.MyTeam then return true end
    local enemyTeam = State.MyTeam == "blue" and State.RedTeam or State.BlueTeam
    return enemyTeam[plr.UserId] == true
end




local BONE_PRIORITY = { "Head", "UpperTorso", "Torso", "LowerTorso", "HumanoidRootPart" }

local function getTargetPart(plr)
    local char = getChar(plr)
    if not char then return nil end
    if Config.AimbotTargetPart == "Auto" then
        for _, boneName in ipairs(BONE_PRIORITY) do
            local part = char:FindFirstChild(boneName)
            if part and part:IsA("BasePart") then return part end
        end
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("BasePart") then return d end
        end
        return nil
    elseif Config.AimbotTargetPart == "Nearest" then
        local origin = Camera.CFrame.Position
        local closest, bd = nil, math.huge
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("BasePart") then
                local dist = (d.Position - origin).Magnitude
                if dist < bd then closest, bd = d, dist end
            end
        end
        return closest
    else
        return char:FindFirstChild(Config.AimbotTargetPart) or getHRP(plr) or getHead(plr)
    end
end

local function getPredictedPos(part)
    if not part then return Vector3.new() end
    local vel = part.AssemblyLinearVelocity or Vector3.new()
    local myPos = Camera.CFrame.Position
    local BULLET_SPEED = 500
    local t = 0
    local targetPos = part.Position
    for _ = 1, 4 do
        targetPos = part.Position + vel * t
        local dist = (targetPos - myPos).Magnitude
        t = dist / BULLET_SPEED
    end
    return targetPos
end

local function getBestTarget()
    local best, bestScore = nil, math.huge
    local cx, cy = Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2
    local priority = Config.AimbotPriority

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isAlive(plr) and isEnemy(plr) then
            local part = getTargetPart(plr)
            if part then
                local predicted = getPredictedPos(part)
                local sp, onScreen = Camera:WorldToViewportPoint(predicted)
                if onScreen and sp.Z > 0 then
                    local d = math.sqrt((sp.X - cx) ^ 2 + (sp.Y - cy) ^ 2)
                    if d <= Config.AimbotFOV then
                        local score = d
                        if priority == "Health" then
                            local hum = getHum(plr)
                            score = hum and hum.Health or 100
                        elseif priority == "Nearest" then
                            local hrp = getHRP(plr)
                            score = hrp and (hrp.Position - Camera.CFrame.Position).Magnitude or 9999
                        end
                        if score < bestScore then
                            best, bestScore = plr, score
                        end
                    end
                end
            end
        end
    end
    return best
end




local aimConn
local function updateAimbot()
    if aimConn then aimConn:Disconnect() aimConn = nil end
    if not Config.Aimbot then
        State.Target = nil
        State.LockedTarget = nil
        return
    end
    aimConn = RunService.RenderStepped:Connect(function()
        local target = nil
        if State.LockedTarget then
            local lt = State.LockedTarget
            if lt.Parent and isAlive(lt) and isEnemy(lt) and getTargetPart(lt) then
                target = lt
            else
                State.LockedTarget = nil
            end
        end
        if not target then
            target = getBestTarget()
            if target then State.LockedTarget = target end
        end
        if not target then
            State.Target = nil
            return
        end
        State.Target = target
        local part = getTargetPart(target)
        if part then
            local aimPos = getPredictedPos(part)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPos)
        end
    end)
end




local autoShootConn
local lastAutoShoot = 0
local function updateAutoShoot()
    if autoShootConn then autoShootConn:Disconnect() autoShootConn = nil end
    if not Config.AimbotAutoShoot then return end
    autoShootConn = RunService.RenderStepped:Connect(function()
        if not State.Target then return end
        local part = getTargetPart(State.Target)
        if not part then return end
        local predicted = getPredictedPos(part)
        local sp = Camera:WorldToViewportPoint(predicted)
        local vp = Camera.ViewportSize
        local dx = sp.X - vp.X / 2
        local dy = sp.Y - vp.Y / 2
        local dist = math.sqrt(dx * dx + dy * dy)
        if dist > Config.AimbotAutoShootRange then return end
        local now = tick()
        if now - lastAutoShoot < 0.05 then return end
        lastAutoShoot = now
        fireWeapon()
    end)
end




local triggerConn
local lastTriggerFire = 0
local function updateTriggerbot()
    if triggerConn then triggerConn:Disconnect() triggerConn = nil end
    if not Config.Triggerbot then return end
    triggerConn = RunService.RenderStepped:Connect(function()
        if not UserInputService:IsKeyDown(Config.TriggerbotKey) then return end
        local now = tick()
        if now - lastTriggerFire < Config.TriggerbotDelay then return end
        local mouse = UserInputService:GetMouseLocation()
        local ray = Camera:ViewportPointToRay(mouse.X, mouse.Y)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { LocalPlayer.Character }
        local result = workspace:Raycast(ray.Origin, ray.Direction * 2000, params)
        if result and result.Instance then
            local model = result.Instance:FindFirstAncestorOfClass("Model")
            if model then
                local plr = Players:GetPlayerFromCharacter(model)
                if plr and plr ~= LocalPlayer and isEnemy(plr) and isAlive(plr) then
                    lastTriggerFire = now
                    fireWeapon()
                end
            end
        end
    end)
end




local combatConn
local function updateCombat()
    if combatConn then combatConn:Disconnect() combatConn = nil end
    if not (Config.NoRecoil or Config.NoSpread or Config.RapidFire or Config.InfiniteAmmo or Config.AutoReload) then return end
    combatConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then return end
        if Config.NoRecoil then
            pcall(function()
                for _, key in ipairs({ "Recoil", "RecoilX", "RecoilY", "ViewPunch", "CameraRecoil" }) do
                    if tool:GetAttribute(key) ~= nil then tool:SetAttribute(key, 0) end
                end
            end)
        end
        if Config.NoSpread then
            pcall(function()
                for _, key in ipairs({ "Spread", "BulletSpread", "Inaccuracy" }) do
                    if tool:GetAttribute(key) ~= nil then tool:SetAttribute(key, 0) end
                end
            end)
        end
        if Config.InfiniteAmmo then
            pcall(function()
                for _, key in ipairs({ "Ammo", "Clip", "Magazine" }) do
                    if tool:GetAttribute(key) ~= nil then tool:SetAttribute(key, 999) end
                end
            end)
        end
        if Config.AutoReload then
            pcall(function()
                local ammo = tool:GetAttribute("Ammo") or tool:GetAttribute("Clip") or 1
                if ammo <= 0 and Remotes.Reload then
                    Remotes.Reload:FireServer(tool)
                end
            end)
        end
    end)
end




local hitboxConn
local function updateHitbox()
    if hitboxConn then hitboxConn:Disconnect() hitboxConn = nil end
    if not Config.HitboxExpander then return end
    hitboxConn = RunService.Heartbeat:Connect(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and isEnemy(plr) then
                local char = getChar(plr)
                if char then
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                            pcall(function() p.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize) end)
                        end
                    end
                end
            end
        end
    end)
end




local ESPFolder = {}
local espGui
local function ensureESPGui()
    if espGui then return espGui end
    espGui = Instance.new("ScreenGui")
    espGui.Name = "ATX_PVP_ESP"
    espGui.ResetOnSpawn = false
    espGui.DisplayOrder = 9000
    espGui.IgnoreGuiInset = true
    pcall(function()
        if gethui then espGui.Parent = gethui()
        else espGui.Parent = game:GetService("CoreGui") end
    end)
    return espGui
end

local function teamColorFor(plr)
    if not State.MyTeam then return Color3.fromRGB(255, 80, 80) end
    local enemyTeam = State.MyTeam == "blue" and State.RedTeam or State.BlueTeam
    if enemyTeam[plr.UserId] then return Color3.fromRGB(255, 80, 80) end
    return Color3.fromRGB(80, 200, 255)
end

local function makeESP(plr)
    local char = getChar(plr)
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    if not hrp then return nil end
    local color = teamColorFor(plr)

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = head or hrp
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 220, 0, 70)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.MaxDistance = Config.ESPMaxDist
    billboard.Parent = espGui

    local nameLbl = Instance.new("TextLabel")
    nameLbl.BackgroundTransparency = 1
    nameLbl.Size = UDim2.new(1, 0, 0, 14)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 12
    nameLbl.TextStrokeTransparency = 0.3
    nameLbl.TextColor3 = color
    nameLbl.Text = plr.Name
    nameLbl.Parent = billboard

    local distLbl = Instance.new("TextLabel")
    distLbl.BackgroundTransparency = 1
    distLbl.Size = UDim2.new(1, 0, 0, 12)
    distLbl.Position = UDim2.new(0, 0, 0, 14)
    distLbl.Font = Enum.Font.Gotham
    distLbl.TextSize = 10
    distLbl.TextStrokeTransparency = 0.3
    distLbl.TextColor3 = Color3.new(1, 1, 1)
    distLbl.Text = "0m"
    distLbl.Parent = billboard

    local healthLbl = Instance.new("TextLabel")
    healthLbl.BackgroundTransparency = 1
    healthLbl.Size = UDim2.new(1, 0, 0, 12)
    healthLbl.Position = UDim2.new(0, 0, 0, 26)
    healthLbl.Font = Enum.Font.Gotham
    healthLbl.TextSize = 10
    healthLbl.TextStrokeTransparency = 0.3
    healthLbl.TextColor3 = Color3.fromRGB(255, 120, 120)
    healthLbl.Text = "100"
    healthLbl.Parent = billboard

    local hl = Instance.new("Highlight")
    hl.Adornee = char
    hl.FillColor = color
    hl.FillTransparency = 0.65
    hl.OutlineColor = color
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = char

    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = hrp
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Size = Vector3.new(4, 6, 4)
    box.Transparency = 0.5
    box.Color3 = color
    box.Visible = false
    box.Parent = hrp

    return {
        plr = plr, char = char,
        billboard = billboard, nameLbl = nameLbl,
        distLbl = distLbl, healthLbl = healthLbl,
        highlight = hl, box = box,
    }
end

local function destroyESP(e)
    if not e then return end
    if e.billboard then pcall(function() e.billboard:Destroy() end) end
    if e.highlight then pcall(function() e.highlight:Destroy() end) end
    if e.box then pcall(function() e.box:Destroy() end) end
end

local function clearAllESP()
    for _, e in pairs(ESPFolder) do destroyESP(e) end
    ESPFolder = {}
end

local function refreshESP()
    if not Config.PlayerESP then
        if next(ESPFolder) then clearAllESP() end
        return
    end
    ensureESPGui()
    local hrp = getHRP()
    local myPos = hrp and hrp.Position or Vector3.new()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local isTeammate = State.MyTeam and not isEnemy(plr)
            if isTeammate and not Config.ESPShowTeammates then
                local e = ESPFolder[plr]
                if e then destroyESP(e) ESPFolder[plr] = nil end
            else
                local char = getChar(plr)
                local hum = getHum(plr)
                if char and hum and hum.Health > 0 then
                    local e = ESPFolder[plr]
                    if not e or e.char ~= char or not e.billboard.Parent then
                        if e then destroyESP(e) end
                        e = makeESP(plr)
                        ESPFolder[plr] = e
                    end
                    if e then
                        local hrp2 = char:FindFirstChild("HumanoidRootPart")
                        if hrp2 then
                            local dist = (hrp2.Position - myPos).Magnitude
                            e.nameLbl.Visible = Config.ESPName
                            e.distLbl.Visible = Config.ESPDistance
                            e.healthLbl.Visible = Config.ESPHealth
                            e.distLbl.Text = string.format("%dm", math.floor(dist))
                            e.healthLbl.Text = string.format("HP: %d", math.floor(hum.Health))
                            e.healthLbl.TextColor3 = hum.Health > 50 and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
                            e.billboard.MaxDistance = Config.ESPMaxDist
                            e.highlight.Enabled = Config.ESPChams
                            e.highlight.FillColor = teamColorFor(plr)
                            e.highlight.OutlineColor = teamColorFor(plr)
                            if e.box then
                                e.box.Visible = Config.ESPBox
                                e.box.Color3 = teamColorFor(plr)
                            end
                        end
                    end
                else
                    local e = ESPFolder[plr]
                    if e then destroyESP(e) ESPFolder[plr] = nil end
                end
            end
        end
    end

    for plr, e in pairs(ESPFolder) do
        if not plr.Parent or not e.char or not e.char.Parent then
            destroyESP(e) ESPFolder[plr] = nil
        end
    end
end

RunService.RenderStepped:Connect(function()
    pcall(refreshESP)
end)




local fovCircle
local function updateFOVCircle()
    if fovCircle then pcall(function() fovCircle:Remove() end) fovCircle = nil end
    if not Config.Aimbot then return end
    if not Drawing then return end
    fovCircle = Drawing.new("Circle")
    fovCircle.Thickness = 1
    fovCircle.NumSides = 80
    fovCircle.Radius = Config.AimbotFOV
    fovCircle.Color = Color3.fromRGB(120, 200, 255)
    fovCircle.Transparency = 0.6
    fovCircle.Filled = false
    fovCircle.Visible = true
    fovCircle.ZIndex = 2
    RunService.RenderStepped:Connect(function()
        if not fovCircle then return end
        local vp = Camera.ViewportSize
        fovCircle.Position = Vector2.new(vp.X / 2, vp.Y / 2)
        fovCircle.Radius = Config.AimbotFOV
        fovCircle.Visible = Config.Aimbot
    end)
end




local flyConn
local function updateFly()
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if not Config.Fly then return end
    flyConn = RunService.RenderStepped:Connect(function()
        local hrp = getHRP()
        if not hrp or not Camera then return end
        local move = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
        if move.Magnitude > 0 then move = move.Unit end
        hrp.AssemblyLinearVelocity = move * Config.FlySpeed
    end)
end

local noclipConn
local function updateNoclip()
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if not Config.Noclip then return end
    noclipConn = RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
        end
    end)
end

local speedConn, savedWalkSpeed = nil, nil
local function updateSpeed()
    if speedConn then speedConn:Disconnect() speedConn = nil end
    if not Config.SpeedToggle then
        local h = getHum()
        if h and savedWalkSpeed then h.WalkSpeed = savedWalkSpeed end
        savedWalkSpeed = nil
        return
    end
    local h = getHum()
    if h and not savedWalkSpeed then savedWalkSpeed = h.WalkSpeed end
    speedConn = RunService.Heartbeat:Connect(function()
        local hum = getHum()
        if not hum or hum.Health <= 0 then return end
        if hum.WalkSpeed ~= Config.SpeedValue then
            pcall(function() hum.WalkSpeed = Config.SpeedValue end)
        end
    end)
end

local jumpConn
local function updateJump()
    if jumpConn then jumpConn:Disconnect() jumpConn = nil end
    jumpConn = RunService.Heartbeat:Connect(function()
        local hum = getHum()
        if hum then
            pcall(function()
                hum.UseJumpPower = true
                hum.JumpPower = Config.JumpPower
            end)
        end
    end)
end

local bhopConn
local function updateBhop()
    if bhopConn then bhopConn:Disconnect() bhopConn = nil end
    if not Config.AutoBhop then return end
    bhopConn = RunService.Heartbeat:Connect(function()
        local hum = getHum()
        if hum and hum.FloorMaterial ~= Enum.Material.Air then
            pcall(function() hum.Jump = true end)
        end
    end)
end




local afkConn
local function updateAntiAFK()
    if afkConn then afkConn:Disconnect() afkConn = nil end
    if not Config.AntiAFK then return end
    afkConn = LocalPlayer.Idled:Connect(function()
        local h = getHum()
        if not h or h.Health <= 0 then return end
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)
end

local fovChangeConn
local function updateCameraFOV()
    if fovChangeConn then fovChangeConn:Disconnect() fovChangeConn = nil end
    fovChangeConn = RunService.RenderStepped:Connect(function()
        if Camera.FieldOfView ~= Config.CameraFOV then
            Camera.FieldOfView = Config.CameraFOV
        end
    end)
end

local function rejoin()
    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
end
local function resetChar()
    local h = getHum()
    if h then h.Health = 0 end
end




local Window = WindUI:CreateWindow({
    Title = "Alkedion PVP - ATX",
    Icon = "crosshair",
    Author = "AntraxdevZ",
    Folder = "AlkedionATX",
    Size = UDim2.fromOffset(620, 500),
    Theme = "Dark",
    Resizable = true,
    ToggleKey = Enum.KeyCode.RightShift,
})

local TabCombat   = Window:Tab({ Title = "Combat",    Icon = "crosshair" })
local TabVisual   = Window:Tab({ Title = "Visuals",   Icon = "eye" })
local TabMovement = Window:Tab({ Title = "Movement",  Icon = "feather" })
local TabMisc     = Window:Tab({ Title = "Misc",      Icon = "settings" })


TabCombat:Section({ Title = "Aimbot / Cam Lock" })
TabCombat:Paragraph({ Title = "How it works",
    Desc = "One toggle enables everything: Always On, Instant Lock, Sticky Target, Prediction, Team Check, FOV Circle. Just pick Target Part and Priority." })
TabCombat:Toggle({
    Title = "Enable Aimbot",
    Value = false,
    Callback = function(v)
        Config.Aimbot = v
        updateAimbot()
        updateFOVCircle()
    end,
})
TabCombat:Dropdown({
    Title = "Target Part",
    Values = { "Auto", "Head", "HumanoidRootPart", "Nearest" },
    Value = "Auto",
    Callback = function(v) Config.AimbotTargetPart = v end,
})
TabCombat:Dropdown({
    Title = "Priority",
    Values = { "Crosshair", "Nearest", "Health" },
    Value = "Crosshair",
    Callback = function(v) Config.AimbotPriority = v end,
})
TabCombat:Slider({
    Title = "Aimbot FOV (px)",
    Value = { Min = 20, Max = 800, Default = 400 },
    Step = 5,
    Callback = function(v) Config.AimbotFOV = v; updateFOVCircle() end,
})

TabCombat:Section({ Title = "Auto Shoot" })
TabCombat:Toggle({
    Title = "Auto Shoot when Aimed",
    Value = false,
    Callback = function(v) Config.AimbotAutoShoot = v; updateAutoShoot() end,
})
TabCombat:Slider({
    Title = "Auto-Shoot Range (px)",
    Value = { Min = 5, Max = 100, Default = 25 },
    Step = 1,
    Callback = function(v) Config.AimbotAutoShootRange = v end,
})

TabCombat:Section({ Title = "Trigger Bot" })
TabCombat:Toggle({
    Title = "Enable Triggerbot",
    Value = false,
    Callback = function(v) Config.Triggerbot = v; updateTriggerbot() end,
})
TabCombat:Keybind({
    Title = "Triggerbot Key",
    Value = Enum.KeyCode.Q,
    Callback = function(v) Config.TriggerbotKey = v end,
})
TabCombat:Slider({
    Title = "Trigger Delay (s)",
    Value = { Min = 0.02, Max = 0.5, Default = 0.05 },
    Step = 0.01,
    Callback = function(v) Config.TriggerbotDelay = v end,
})

TabCombat:Section({ Title = "Weapon Mods" })
TabCombat:Toggle({ Title = "No Recoil", Value = false,
    Callback = function(v) Config.NoRecoil = v; updateCombat() end })
TabCombat:Toggle({ Title = "No Spread", Value = false,
    Callback = function(v) Config.NoSpread = v; updateCombat() end })
TabCombat:Toggle({ Title = "Rapid Fire", Value = false,
    Callback = function(v) Config.RapidFire = v; updateCombat() end })
TabCombat:Toggle({ Title = "Infinite Ammo", Value = false,
    Callback = function(v) Config.InfiniteAmmo = v; updateCombat() end })
TabCombat:Toggle({ Title = "Auto Reload", Value = false,
    Callback = function(v) Config.AutoReload = v; updateCombat() end })

TabCombat:Section({ Title = "Hitbox" })
TabCombat:Toggle({
    Title = "Hitbox Expander",
    Value = false,
    Callback = function(v) Config.HitboxExpander = v; updateHitbox() end,
})
TabCombat:Slider({
    Title = "Hitbox Size",
    Value = { Min = 2, Max = 25, Default = 8 },
    Step = 0.5,
    Callback = function(v) Config.HitboxSize = v end,
})


TabVisual:Section({ Title = "ESP / Wallhack" })
TabVisual:Toggle({ Title = "Player ESP", Value = true,
    Callback = function(v) Config.PlayerESP = v; if not v then clearAllESP() end end })
TabVisual:Toggle({ Title = "Show Name", Value = true,
    Callback = function(v) Config.ESPName = v end })
TabVisual:Toggle({ Title = "Show Distance", Value = true,
    Callback = function(v) Config.ESPDistance = v end })
TabVisual:Toggle({ Title = "Show Health", Value = true,
    Callback = function(v) Config.ESPHealth = v end })
TabVisual:Toggle({ Title = "Chams (through walls)", Value = true,
    Callback = function(v) Config.ESPChams = v end })
TabVisual:Toggle({ Title = "Box", Value = false,
    Callback = function(v) Config.ESPBox = v end })
TabVisual:Toggle({ Title = "Show Teammates", Value = false,
    Callback = function(v) Config.ESPShowTeammates = v end })
TabVisual:Slider({ Title = "ESP Max Distance",
    Value = { Min = 100, Max = 5000, Default = 3000 },
    Step = 100,
    Callback = function(v) Config.ESPMaxDist = v end })


TabMovement:Toggle({ Title = "Fly", Value = false,
    Callback = function(v) Config.Fly = v; updateFly() end })
TabMovement:Slider({ Title = "Fly Speed",
    Value = { Min = 10, Max = 400, Default = 60 },
    Step = 5,
    Callback = function(v) Config.FlySpeed = v end })
TabMovement:Toggle({ Title = "Noclip", Value = false,
    Callback = function(v) Config.Noclip = v; updateNoclip() end })
TabMovement:Toggle({ Title = "Speed Mod", Value = false,
    Callback = function(v) Config.SpeedToggle = v; updateSpeed() end })
TabMovement:Slider({ Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 40 },
    Step = 1,
    Callback = function(v)
        Config.SpeedValue = v
        if Config.SpeedToggle then
            local h = getHum()
            if h then pcall(function() h.WalkSpeed = v end) end
        end
    end })
TabMovement:Slider({ Title = "Jump Power",
    Value = { Min = 50, Max = 300, Default = 60 },
    Step = 5,
    Callback = function(v) Config.JumpPower = v; updateJump() end })
TabMovement:Toggle({ Title = "Auto Bhop", Value = false,
    Callback = function(v) Config.AutoBhop = v; updateBhop() end })


TabMisc:Section({ Title = "Bypass" })
local bypassPara = TabMisc:Paragraph({ Title = "Status", Desc = "Initializing..." })
TabMisc:Toggle({ Title = "Bypass Enabled", Value = true, Callback = function(v)
    Config.BypassEnabled = v
    if getgenv().__ATXPVP_Bypass then
        getgenv().__ATXPVP_Bypass.Status = v and "4/4 Active" or "Disabled"
    end
end })

TabMisc:Section({ Title = "General" })
TabMisc:Toggle({ Title = "Anti AFK", Value = true,
    Callback = function(v) Config.AntiAFK = v; updateAntiAFK() end })
TabMisc:Slider({ Title = "Camera FOV",
    Value = { Min = 60, Max = 140, Default = 90 },
    Step = 1,
    Callback = function(v) Config.CameraFOV = v; updateCameraFOV() end })

TabMisc:Section({ Title = "Server" })
TabMisc:Button({ Title = "Rejoin", Icon = "refresh-cw",
    Callback = function() rejoin() end })
TabMisc:Button({ Title = "Reset Character", Icon = "user-x",
    Callback = function() resetChar() end })
TabMisc:Button({ Title = "Unload Script", Icon = "x",
    Callback = function()
        getgenv().__ATXPVP_Session = nil
        clearAllESP()
        if fovCircle then pcall(function() fovCircle:Remove() end) end
        if espGui then pcall(function() espGui:Destroy() end) end
        pcall(function() WindUI:Destroy() end)
        print("[ATX PVP] Unloaded")
    end })




task.spawn(function()
    while alive() do
        task.wait(1)
        pcall(function()
            if bypassPara and bypassPara:SetDesc then
                local b = getgenv().__ATXPVP_Bypass
                bypassPara:SetDesc("Bypass: " .. (b and b.Status or "?"))
            end
        end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    pcall(function()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp:SetAttribute("KillPartIgnore", true) end
    end)
    if Config.SpeedToggle then updateSpeed() end
    if Config.Fly then updateFly() end
    if Config.Noclip then updateNoclip() end
end)

updateAntiAFK()
updateCameraFOV()
updateJump()

print("[ATX PVP] Loaded · Executor: " .. tostring(executorName))
notify("ATX PVP loaded")