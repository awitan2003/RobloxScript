local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local registerImpact = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlayerCharacter").Update:WaitForChild("RegisterImpact")
local tbl = {}

local function fn(arg)
	tbl[#tbl + 1] = arg
	return arg
end

local v = nil
local v2 = nil
local v3 = nil
local tbl2 = { parried = 0, blocked = 0, missed = 0 }

local function fn2(arg)
	local v4 = v2 and v2[arg]
	return v4 and v4.Value
end

local function fn3(arg, arg2)
	local v4 = v3 and v3[arg]
	if v4 and v4.Value ~= nil then
		return v4.Value
	end
	return arg2
end

local CharacterController = nil

pcall(function()
	CharacterController = require(ReplicatedStorage.Controllers.CharacterController)
end)

local function fn4()
	if not CharacterController then
		return nil
	end
	local ok, result = pcall(CharacterController.GetLocalCharacterHandler, CharacterController)
	if ok and type(result) == "table" and result.ActionManager then
		return result
	end
	return nil
end

local function fn5(arg)
	return arg and arg.IsParrying == true
end

local flag = false

local function fn6(arg)
	local v4 = fn4()
	if not v4 then
		return
	end

	if fn5(v4) then
		return
	end
	local actionManager = v4.ActionManager
	local isParrying = v4.IsParrying
	v4.IsParrying = true
	flag = true

	task.spawn(function()
		local n = os.clock() + 0.6

		while true do
			RunService.Heartbeat:Wait()
			if not (not (actionManager and actionManager.UnresolvedImpacts and actionManager.UnresolvedImpacts[arg] ~= nil) or os.clock() > n) then
				continue
			end
			break
		end

		local v5 = fn4()

		if v5 == v4 and v5.IsParrying == true then
			v5.IsParrying = isParrying
		end

		flag = false
	end)
end

fn(registerImpact.OnClientEvent:Connect(function(arg, arg2)
	if not fn2("AP_Enabled") then
		return
	end

	if type(arg) ~= "number" and type(arg) ~= "string" then
		return
	end

	if type(arg2) == "table" and arg2.sourceModule == nil then
		return
	end
	local n = math.random() * 100
	if fn3("AP_Chance", 100) < n then
		tbl2.missed = tbl2.missed + 1
		return
	end
	tbl2.parried = tbl2.parried + 1
	fn6(arg)

	if fn2("AP_Notify") and v then
		v:Notify("Parried impact #" .. tostring(arg), 1)
	end
end))

local function fn7(arg)
	local v4 = fn4()
	if not v4 then
		return
	end
	local actionManager = v4.ActionManager
	local isDodging = v4.IsDodging
	v4.IsDodging = true

	task.spawn(function()
		local n = os.clock() + 0.6

		while true do
			RunService.Heartbeat:Wait()
			if not (not (actionManager and actionManager.UnresolvedImpacts and actionManager.UnresolvedImpacts[arg] ~= nil) or os.clock() > n) then
				continue
			end
			break
		end

		local v5 = fn4()

		if v5 == v4 and v5.IsDodging == true then
			v5.IsDodging = isDodging
		end
	end)
end

fn(registerImpact.OnClientEvent:Connect(function(arg)
	if not fn2("GM_Enabled") then
		return
	end

	if type(arg) ~= "number" and type(arg) ~= "string" then
		return
	end
	fn7(arg)
end))

local tbl3 = {
	Katana = {
		"DefaultKatana",
		"BloodlusterKatana",
		"DeepBlueKatana",
		"DarkMatterKatana",
		"ChristmasKatana",
		"FlamingKatana",
		"ChampionKatana",
	},
	Daggers = {
		"DefaultDaggers",
		"CrimsonFangsDaggers",
		"BronzeViperDaggers",
		"DarkMatterDaggers",
		"ChristmasDaggers",
		"GoldenDaggers",
	},
	Naginata = {
		"DefaultNaginata",
		"SerpentSlayerNaginata",
		"DeepBlueNaginata",
		"DarkMatterNaginata",
		"ChristmasNaginata",
	},
	Gauntlets = { "DefaultGauntlets", "GoldenGauntlets", "BloodlusterGauntlets" },
	Kusarigama = { "DefaultKusarigama", "MagmaKusarigama", "BronzeViperKusarigama", "CelestialKusarigama" },
	Warhammer = {
		"DefaultWarhammer",
		"IcebornWarhammer",
		"DarkMatterWarhammer",
		"ViperWarhammer",
		"SoulEaterWarhammer",
	},
	CurvedBlades = { "DefaultCurvedBlades", "ScorchflowerCurvedBlades" },
	BoStaff = { "DefaultBoStaff" },
}

local tbl4 = {}
local tbl5 = {}

for k, v4 in pairs(tbl3) do
	table.sort(v4)
	tbl5[#tbl5 + 1] = k

	for _, v5 in ipairs(v4) do
		tbl4[v5] = k
	end
end

table.sort(tbl5)
local requestSetCurrentWeapon = ReplicatedStorage.Remotes:WaitForChild("WeaponInventory"):WaitForChild("Request_SetCurrentWeapon")
local skinApplied = "DefaultKatana"

local function fn8(arg, arg2)
	return arg:gsub(arg2, "")
end

local function fn9(arg, currentCosmetic)
	local cosmetics = arg.WeaponInfo and arg.WeaponInfo.Cosmetics and arg.WeaponInfo.Cosmetics[currentCosmetic]
	if not cosmetics then
		return false
	end
	local module = require(cosmetics)
	if type(module) ~= "table" or not module.WeaponModel then
		return false
	end
	local clone = module.WeaponModel:Clone()

	for _, descendant in ipairs(clone:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.CanCollide = false
			descendant.CanQuery = false
			descendant.CanTouch = false
			descendant.Massless = true
		end
	end

	local parent = arg.WeaponModel and arg.WeaponModel.Parent or arg.WeaponInstance

	if arg.WeaponModel then
		pcall(function()
			arg.WeaponModel:Destroy()
		end)
	end

	local blade = clone:FindFirstChild("Blade")
	local trail = blade and blade:FindFirstChild("Trail") or nil
	local ultimateTrail = blade and blade:FindFirstChild("UltimateTrail") or nil

	if trail then
		pcall(function()
			trail:SetAttribute("WidthScale", trail.WidthScale)
			trail:SetAttribute("MaxLength", trail.MaxLength)
			trail.Enabled = false
		end)
	end

	if ultimateTrail then
		pcall(function()
			ultimateTrail:SetAttribute("WidthScale", ultimateTrail.WidthScale)
			ultimateTrail:SetAttribute("MaxLength", ultimateTrail.MaxLength)
			ultimateTrail.Enabled = false
		end)
	end

	clone.Parent = parent
	arg.WeaponModel = clone
	arg.Blade = blade
	arg.Trail = trail
	arg.UltimateTrail = ultimateTrail
	arg.CurrentCosmetic = currentCosmetic
	arg.CosmeticInfo = module
	return true
end

local function fn10()
	local v4 = fn4()
	local equippedWeaponHandler = v4 and v4:GetEquippedWeaponHandler()
	if not equippedWeaponHandler then
		return false
	end
	local v5 = tbl4[skinApplied]
	if not v5 then
		return false
	end
	local v6 = fn8(skinApplied, v5)
	if equippedWeaponHandler.CurrentCosmetic == v6 then
		return true
	end
	local flag2 = false
	local flag3 = false

	local thread = coroutine.create(function()
		flag3 = pcall(fn9, equippedWeaponHandler, v6)
		flag2 = true
	end)

	pcall(setthreadcontext, thread, 8)
	pcall(coroutine.resume, thread)
	local n = os.clock() + 2

	while not flag2 and os.clock() < n do
		task.wait()
	end

	return flag3
end

fn(RunService.Heartbeat:Connect(function()
	if not fn2("CS_Apply") then
		return
	end
	local v4 = fn4()
	if not v4 then
		return
	end
	local v5 = tbl4[skinApplied]
	if not v5 or v4.EquippedWeapon ~= v5 then
		return
	end
	local equippedWeaponHandler = v4:GetEquippedWeaponHandler()

	if equippedWeaponHandler then
		local v6 = fn8(skinApplied, v5)

		if equippedWeaponHandler.CurrentCosmetic ~= v6 then
			pcall(function()
				fn9(equippedWeaponHandler, v6)
			end)
		end
	end
end))

local v4, v5

v, v2, v3, v4, v5 = loadstring(game:HttpGet("https://raw.githubusercontent.com/gilgameshfate59/ohbfoosk8tid/main/CitraUI.lua"))().Shim:Init({
	Name = "Citra",
	SubName = "Dueling Grounds",
	Logo = "102010944233602",
	Accent = Color3.fromRGB(255, 138, 32),
	ShowTabIcons = false,
	ConfigFolder = "DuelingGroundsCitra/configs",
	ThemeFolder = "DuelingGroundsCitra",
})

local v6 = v:CreateWindow({
	Title = "Citra Hub | Dueling Grounds",
	Center = true,
	AutoShow = true,
	TabPaddingX = 8,
	MenuFadeTime = 0.2,
})

v.ToggleKeybind = Enum.KeyCode.RightShift
local Combat = v6:AddTab("Combat")
local v7 = Combat:AddLeftGroupbox("Auto Parry")
local v8 = Combat:AddLeftGroupbox("God Mode")
local Session = Combat:AddRightGroupbox("Session")

v8:AddToggle("GM_Enabled", {
	Text = "Enable God Mode",
	Default = false,
	Tooltip = "Every incoming impact resolves as a Dodge on your client, and the server accepts the result -- you take no damage. Same client-side resolution flaw as Auto Parry, with the dodge flag instead.",
}):AddKeyPicker("GM_Key", { Default = "H", SyncToggleState = true, Mode = "Toggle", Text = "God Mode" })

v7:AddToggle("AP_Enabled", {
	Text = "Enable Auto Parry",
	Default = false,
	Tooltip = "Resolves every incoming impact as a parry. The game decides hit outcomes on your client, so this uses its own resolver rather than faking packets.",
}):AddKeyPicker("AP_Key", { Default = "G", SyncToggleState = true, Mode = "Toggle", Text = "Auto Parry" })

v7:AddSlider("AP_Chance", {
	Text = "Parry Chance",
	Default = 100,
	Min = 1,
	Max = 100,
	Rounding = 0,
	Suffix = "%",
	Tooltip = "Percentage of incoming impacts the auto parry actually parries. Below 100 it rolls each hit, so a 50% chance parries half of them -- keeps it looking human.",
})

v7:AddToggle("AP_Notify", { Text = "Parry Notifications", Default = false })
local v9 = Session:AddLabel("Parried: 0")

Session:AddButton({
	Text = "Reset Counter",
	Func = function()
		local v10 = tbl2
		local v11 = tbl2
		tbl2.parried = 0
		v10.blocked = 0
		v11.missed = 0
	end,
})

task.spawn(function()
	while not (v and v.Unloaded) do
		pcall(function()
			v9:SetText("Parried: " .. tbl2.parried)
		end)

		task.wait(0.35)
	end
end)

local Cosmetics = v6:AddTab("Cosmetics")
local v10 = Cosmetics:AddLeftGroupbox("Skin Changer")
local Weapon = Cosmetics:AddRightGroupbox("Weapon")
local v11 = Cosmetics:AddLeftGroupbox("Weapon Skins")

v10:AddToggle("CS_Apply", {
	Text = "Apply Skin",
	Default = true,
	Tooltip = "Client-side only: swaps the equipped weapon's model to the chosen skin and re-applies it whenever the weapon remounts. The server never sees it, so locked/premium skins work too.",
})

v10:AddButton({
	Text = "Apply Now",
	Func = function()
		local v12 = tbl4[skinApplied]
		local v13 = fn4()

		if v13 and v13.EquippedWeapon == v12 then
			fn10()

			if v then
				v:Notify("Skin applied: " .. skinApplied, 2)
			end
		elseif v then
			v:Notify("Equip " .. tostring(v12) .. " first.", 2)
		end
	end,
})

Weapon:AddDropdown("CS_Weapon", {
	Values = tbl5,
	Default = 1,
	Multi = false,
	Text = "Equip Weapon",
	Tooltip = "Sends the game's own Request_SetCurrentWeapon. Server-validated -- only weapons you own will actually equip; the skin applies the moment it mounts.",
	Callback = function(requestedWeapon)
		if type(requestedWeapon) ~= "string" then
			return
		end

		pcall(function()
			requestSetCurrentWeapon:FireServer(requestedWeapon)
		end)

		if v then
			v:Notify("Requested weapon: " .. requestedWeapon, 2)
		end
	end,
})

for k, v12 in pairs(tbl3) do
	v11:AddDropdown(("CS_Skin_%s"):format(k), {
		Values = v12,
		Default = 1,
		Multi = false,
		Text = k,
		Tooltip = "Preview any " .. k .. " skin client-side. Applies when " .. k .. " is equipped.",
		Callback = function(arg)
			if type(arg) ~= "string" then
				return
			end
			skinApplied = arg

			if v then
				v:Notify(k .. " skin: " .. arg, 1.5)
			end
		end,
	})
end

local Settings = v6:AddTab("Settings")
v4:SetLibrary(v)

pcall(function()
	v4:ApplyToTab(Settings)
end)

v5:SetLibrary(v)

pcall(function()
	v5:IgnoreThemeSettings()
end)

pcall(function()
	v5:SetFolder("DuelingGroundsCitra")
end)

pcall(function()
	v5:BuildConfigSection(Settings)
end)

Settings:AddLeftGroupbox("Hub"):AddButton({
	Text = "Unload",
	DoubleClick = true,
	Tooltip = "Double-click to unload.",
	Func = function()
		task.spawn(function()
			for _, v12 in ipairs(tbl) do
				if typeof(v12) == "RBXScriptConnection" then
					pcall(function()
						v12:Disconnect()
					end)
				end
			end

			local v12 = fn4()

			if v12 and flag then
				v12.IsParrying = nil
			end

			pcall(function()
				v:Unload()
			end)
		end)
	end,
})

pcall(function()
	v6:Init()
end)

pcall(function()
	v5:LoadAutoloadConfig()
end)

v:Notify("Citra | Dueling Grounds -- Auto Parry ready.", 4)
