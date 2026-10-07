if getgenv().executed then return end 
getgenv().executed = true

if not LPH_OBFUSCATED then
    LPH_JIT = function(...) return ... end
    LPH_JIT_MAX = function(...) return ... end
    LPH_NO_VIRTUALIZE = function(...) return ... end
    LPH_ENCSTR = function(...) return ... end
    LPH_OBFUSCATED = false
end

local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local CollectionService = cloneref(game:GetService("CollectionService"))
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local HttpService = cloneref(game:GetService("HttpService"))
local EncodingService = cloneref(game:GetService("EncodingService"))
local TweenService = cloneref(game:GetService("TweenService"))

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

if game.PlaceId ~= 87571927272049 then 
    LocalPlayer:Kick("Please execute inside of a game.")
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

repeat
    task.wait()
until not PlayerGui:FindFirstChild("TeleportScreen")

local Trove = {}
Trove.__index = Trove

do 
    local FN_MARKER = newproxy()
    local THREAD_MARKER = newproxy()
    local GENERIC_OBJECT_CLEANUP_METHODS = table.freeze({ "Destroy", "Disconnect", "destroy", "disconnect" })

    local function getObjectCleanupFunction(object, cleanupMethod)
        local t = typeof(object)

        if t == "function" then
            return FN_MARKER
        elseif t == "thread" then
            return THREAD_MARKER
        end

        if cleanupMethod then
            return cleanupMethod
        end

        if t == "Instance" then
            return "Destroy"
        elseif t == "RBXScriptConnection" then
            return "Disconnect"
        elseif t == "table" then
            for _, genericCleanupMethod in GENERIC_OBJECT_CLEANUP_METHODS do
                if typeof(object[genericCleanupMethod]) == "function" then
                    return genericCleanupMethod
                end
            end
        end

        error(`failed to get cleanup function for object {t}: {object}`, 3)
    end

    local function assertPromiseLike(object)
        if
            typeof(object) ~= "table"
            or typeof(object.getStatus) ~= "function"
            or typeof(object.finally) ~= "function"
            or typeof(object.cancel) ~= "function"
        then
            error("did not receive a promise as an argument", 3)
        end
    end

    local function assertSignalLike(object)
        if
            typeof(object) ~= "RBXScriptSignal"
            and (typeof(object) ~= "table" or typeof(object.Connect) ~= "function" or typeof(object.Once) ~= "function")
        then
            error("did not receive a signal as an argument", 3)
        end
    end

    function Trove.new()
        local self = setmetatable({}, Trove)
        self._objects = {}
        self._cleaning = false
        return self
    end

    function Trove.Add(self, object, cleanupMethod)
        if self._cleaning then
            error("cannot call trove:Add() while cleaning", 2)
        end

        local cleanup = getObjectCleanupFunction(object, cleanupMethod)
        table.insert(self._objects, { object, cleanup })

        return object
    end

    function Trove.Clone(self, instance)
        if self._cleaning then
            error("cannot call trove:Clone() while cleaning", 2)
        end

        return self:Add(instance:Clone())
    end

    function Trove.Construct(self, class, ...)
        if self._cleaning then
            error("Cannot call trove:Construct() while cleaning", 2)
        end

        local object = nil
        local t = type(class)
        if t == "table" then
            object = class.new(...)
        elseif t == "function" then
            object = class(...)
        end

        return self:Add(object)
    end

    function Trove.Connect(self, signal, fn)
        if self._cleaning then
            error("Cannot call trove:Connect() while cleaning", 2)
        end
        assertSignalLike(signal)

        return self:Add(signal:Connect(fn))
    end

    function Trove.Once(self, signal, fn)
        if self._cleaning then
            error("Cannot call trove:Connect() while cleaning", 2)
        end
        assertSignalLike(signal)

        local conn
        conn = signal:Once(function(...)
            fn(...)
            self:Pop(conn)
        end)

        return self:Add(conn)
    end

    function Trove.BindToRenderStep(self, name, priority, fn)
        if self._cleaning then
            error("cannot call trove:BindToRenderStep() while cleaning", 2)
        end

        RunService:BindToRenderStep(name, priority, fn)

        self:Add(function()
            RunService:UnbindFromRenderStep(name)
        end)
    end

    function Trove.AddPromise(self, promise)
        if self._cleaning then
            error("cannot call trove:AddPromise() while cleaning", 2)
        end
        assertPromiseLike(promise)

        if promise:getStatus() == "Started" then
            promise:finally(function()
                if self._cleaning then
                    return
                end
                self:_findAndRemoveFromObjects(promise, false)
            end)

            self:Add(promise, "cancel")
        end

        return promise
    end

    function Trove.Remove(self, object)
        if self._cleaning then
            error("cannot call trove:Remove() while cleaning", 2)
        end

        return self:_findAndRemoveFromObjects(object, true)
    end

    function Trove.Pop(self, object)
        if self._cleaning then
            error("cannot call trove:Pop() while cleaning", 2)
        end

        return self:_findAndRemoveFromObjects(object, false)
    end

    function Trove.Extend(self)
        if self._cleaning then
            error("cannot call trove:Extend() while cleaning", 2)
        end

        return self:Construct(Trove)
    end

    function Trove.Clean(self)
        if self._cleaning then
            return
        end

        self._cleaning = true

        for _, obj in self._objects do
            self:_cleanupObject(obj[1], obj[2])
        end

        table.clear(self._objects)
        self._cleaning = false
    end

    function Trove.WrapClean(self)
        return function()
            self:Clean()
        end
    end

    function Trove._findAndRemoveFromObjects(self, object, cleanup)
        local objects = self._objects

        for i, obj in objects do
            if obj[1] == object then
                local n = #objects
                objects[i] = objects[n]
                objects[n] = nil

                if cleanup then
                    self:_cleanupObject(obj[1], obj[2])
                end

                return true
            end
        end

        return false
    end

    function Trove._cleanupObject(self, object, cleanupMethod)
        if cleanupMethod == FN_MARKER then
            task.spawn(object)
        elseif cleanupMethod == THREAD_MARKER then
            pcall(task.cancel, object)
        else
            object[cleanupMethod](object)
        end
    end

    function Trove.AttachToInstance(self, instance)
        if self._cleaning then
            error("cannot call trove:AttachToInstance() while cleaning", 2)
        elseif not instance:IsDescendantOf(game) then
            error("instance is not a descendant of the game hierarchy", 2)
        end

        return self:Connect(instance.Destroying, function()
            self:Destroy()
        end)
    end

    function Trove.Destroy(self)
        self:Clean()
    end
end

local Data = loadstring(game:HttpGet("https://raw.githubusercontent.com/de4323/Scripts/refs/heads/main/BikiniBottom/Data.lua"))()

local MapGenerationConfig = Data.MapGenerationConfig
local CraftingData = Data.CraftingData
local ItemData = Data.ItemData
local ResidentData = Data.ResidentData
local EntityData = Data.EntityData

local BackupData = LPH_JIT_MAX(function()
    local backupData = {}
    local backupFolder = ReplicatedStorage:FindFirstChild("__GAMEBEAST_BACKUP")
    for _, config in backupFolder:GetChildren() do
        if not config:IsA("Configuration") then continue end
        local compressed = config:GetAttribute("Data")
        if compressed then
            local decompressed= EncodingService:DecompressBuffer(
                buffer.fromstring(compressed), 
                Enum.CompressionAlgorithm.Zstd
            )
            local jsonString = buffer.tostring(decompressed)
            local parsedData = HttpService:JSONDecode(jsonString)
            backupData[config.Name] = parsedData
        end
    end
    return backupData
end)()

local MainTrove = Trove.new()

local Remotes = ReplicatedStorage.src.Packages._Index["raild3x_netwire@0.3.4"].netwire.Remotes
local NetworkEvent = Remotes.TableReplicator.RE.NetworkEvent
local AttemptDrag = Remotes.ItemDragService.RF.AttemptDrag
local StopDrag = Remotes.ItemDragService.RF.StopDrag

local TeleportLocations = {
    MaterialProcessor = workspace.Map.Chunks.BikiniBottom.ConchStreet.LIGHT_SOURCE.MaterialProcessor._HITBOX,
    MaterialProcessorCraft = workspace.Map.Chunks.BikiniBottom.ConchStreet.CRAFTING_BENCH.MaterialProcessor._HITBOX,
}

local Settings = {
    AutoFarmEnabled = false,
    AutoFarmClosestEnabled = false,
    SelectedEntities = {},
    YOffset = 50,
    XOffset = 10,
    
    SelectedBring = {},
    SelectedResidents = {},
    AutoEatEnabled = false,
    AutoCraftEnabled = false,
    SelectedCraftItems = {},
    InstantOpenChests = false,

    WalkSpeed = {
        Enabled = false,
        Speed = 50,
    },
    Fly = {
        Enabled = false,
        Speed = 50,
    },
}

local ItemsToolkit = {} 

ItemsToolkit.GetAllItems = LPH_JIT(function()
    local items = {} 
    for _, data in ItemData do 
        for _, item in data do 
            items[item.ReferenceName] = item
        end
    end
    return items 
end)

ItemsToolkit.GetItemData = LPH_JIT(function(refName)
    for _, data in ItemData do 
        for _, item in data do 
            if item.ReferenceName == refName then 
                return item
            end
        end
    end
end)

local Utils = {}

Utils.TweenPivot = LPH_JIT_MAX(function(model, targetCFrame, duration, easingStyle, easingDirection)
    easingStyle = easingStyle or Enum.EasingStyle.Linear 
    easingDirection = easingDirection or Enum.EasingDirection.Out
    duration = duration or 0.5
    local startCFrame = model:GetPivot() 
    local startTime = os.clock() 
    local connection;
    connection = RunService.Heartbeat:Connect(function()
        local elapsed = os.clock() - startTime 
        local alpha = elapsed / duration 
        alpha = TweenService:GetValue(alpha, easingStyle, easingDirection)
        if alpha >= 1 then
            model:PivotTo(targetCFrame)
            connection:Disconnect() 
        else 
            model:PivotTo(startCFrame:Lerp(targetCFrame, alpha))
        end
    end) 
    return {
        Cancel = function()
            connection:Disconnect()
        end,
    }
end)

Utils.GetLightSourceLevel = LPH_JIT_MAX(function()
    local levelText = workspace.Map.Chunks.BikiniBottom.ConchStreet.LIGHT_SOURCE.Core.LightSourceBillboard.LightSourceDisplay.Level.Text
    local level = tonumber(levelText:match("%d+"))
    return level or 0
end)

Utils.IsInBounds = LPH_JIT(function(position)
    local chunkSize = MapGenerationConfig.ChunkSize + (MapGenerationConfig.ChunkSpacing or 0)
    local boundaryCenter = Vector3.new(-chunkSize / 2, 0, -chunkSize / 2)
    local distanceFromCenter = (Vector2.new(position.X, position.Z) - Vector2.new(boundaryCenter.X, boundaryCenter.Z)).Magnitude
    
    local level = Utils.GetLightSourceLevel()
    local maxLevel = level == 0 and 1 or level
    local maxRadius = (MapGenerationConfig.Levels[maxLevel] * MapGenerationConfig.ChunkSize + (MapGenerationConfig.Levels[maxLevel] - 1) * MapGenerationConfig.ChunkSpacing) / 2
    
    return distanceFromCenter <= maxRadius
end)

Utils.GetCharacter = LPH_JIT_MAX(function()
    return LocalPlayer.Character
end)

Utils.GetRootPart = LPH_JIT_MAX(function()
    local character = Utils.GetCharacter()
    return character and character:FindFirstChild("HumanoidRootPart")
end)

Utils.GetItemsByName = LPH_JIT(function(itemName)
    local items = {}
    for _, item in CollectionService:GetTagged("Interactable") do
        local refName = item:GetAttribute("ReferenceName")
        if refName == itemName then
            table.insert(items, item)
        end
    end
    return items
end)

Utils.GetEntitiesByName = LPH_JIT(function(entityName)
    local entities = {}
    for _, entity in CollectionService:GetTagged("Entity") do
        if Utils.IsInBounds(entity:GetPivot().Position) then
            local refName = entity:GetAttribute("ReferenceName")
            if refName == entityName and entity:GetAttribute("IsAlive") then
                table.insert(entities, entity)
            end
        end
    end
    return entities
end)

Utils.EntityExistsInMap = LPH_JIT_MAX(function(entityName)
    return #Utils.GetEntitiesByName(entityName) > 0
end)

Utils.GetClosestEntity = LPH_JIT(function(position, filterFunc)
    local closestEntity = nil
    local lowestMagnitude = math.huge

    for _, entity in CollectionService:GetTagged("Entity") do 
        if not Utils.IsInBounds(entity:GetPivot().Position) then continue end
        if not entity:GetAttribute("IsAlive") then continue end

        local refName = entity:GetAttribute("ReferenceName")
        
        local entityData = BackupData.Entities[refName]
        if not entityData then continue end

        if Utils.IsEntityImmune(refName) then continue end

        if filterFunc and not filterFunc(entity) then continue end

        local magnitude = (position - entity:GetPivot().Position).Magnitude 
        if magnitude < lowestMagnitude then 
            closestEntity = entity 
            lowestMagnitude = magnitude
        end
    end

    return closestEntity
end)

Utils.IsEntityImmune = LPH_JIT_MAX(function(refName)
    local entityData = EntityData[refName]
    if entityData and entityData.Metadata and entityData.Metadata.ImmuneToDamage ~= nil then
        return entityData.Metadata.ImmuneToDamage
    end
    return false
end)

local ItemModule = {}

ItemModule.BringItem = LPH_NO_VIRTUALIZE(function(self, item, position)
    AttemptDrag:InvokeServer(item)
    if item.PrimaryPart then 
    item.PrimaryPart.Anchored = true 
    end
    item:PivotTo(CFrame.new(position))
    StopDrag:InvokeServer()

    local alignPosition = item:FindFirstChild("AlignPosition", true)
    local alignOrientation = item:FindFirstChild("AlignOrientation", true)
    if alignPosition then alignPosition:Destroy() end
    if alignOrientation then alignOrientation:Destroy() end
    if item.PrimaryPart then 
    item.PrimaryPart.Anchored = false
    end
end)

ItemModule.BringItems = LPH_JIT(function(self, itemNames, amount)
    local rootPart = Utils.GetRootPart()
    if not rootPart then return end

    local totalHeight = 0
    local forwardOffset = 5

    for itemName, enabled in pairs(itemNames) do
        if not enabled then continue end
        local items = Utils.GetItemsByName(itemName)

        for i = 1, amount or #items do
            local item = items[i]
            if not item then break end

            task.spawn(function()
                local height = item:GetExtentsSize().Y
                local position = (rootPart.Position + rootPart.CFrame.LookVector * forwardOffset) + Vector3.new(0, height/2 + totalHeight, 0)
                totalHeight += height
                self:BringItem(item, position)
            end)
        end
    end
end)

ItemModule.TeleportToProcessor = LPH_JIT(function(self, items, processorType, dontStack)
    processorType = processorType or "MaterialProcessor"
    
    if not TeleportLocations[processorType] then return end

    local targetPosition = TeleportLocations[processorType].Position
    local totalHeight = 0
    local stackOffset = 5

    for _, item in ipairs(items) do
        task.spawn(function()
            local height = item:GetExtentsSize().Y
            local position = targetPosition + Vector3.new(0, height/2 + totalHeight + stackOffset, 0)
            if not dontStack then 
            totalHeight += height
            end
            self:BringItem(item, position)
        end)
    end
end)

ItemModule.TeleportItemsByName = LPH_JIT(function(self, itemNames, processorType)
    local allItems = {}
    for _, itemName in ipairs(itemNames) do
        local items = Utils.GetItemsByName(itemName)
        for _, item in ipairs(items) do
            table.insert(allItems, item)
        end
    end
    self:TeleportToProcessor(allItems, processorType)
end)

local TeleportModule = {}

TeleportModule.TeleportPlayer = LPH_NO_VIRTUALIZE(function(self, location)
    local character = Utils.GetCharacter()
    local rootPart = Utils.GetRootPart()
    if not character or not rootPart then return end

    if TeleportLocations[location] then
        local targetPart = TeleportLocations[location]
        character:PivotTo(targetPart.CFrame + Vector3.new(0, 5, 0))
    end
end)

local FarmBase = {}
FarmBase.__index = FarmBase

function FarmBase.new(name)
    local self = setmetatable({}, FarmBase)
    self.name = name or "Farm"
    self._currentEntity = nil
    self._originalPosition = nil
    self._enabled = false
    self._teleportConnection = nil
    return self
end

FarmBase.IsEnabled = LPH_JIT_MAX(function(self)
    return self._enabled
end)

FarmBase.SetEnabled = LPH_JIT(function(self, enabled)
    self._enabled = enabled
    if not enabled then
        self:ResetPosition()
    end
end)

FarmBase.ResetPosition = LPH_NO_VIRTUALIZE(function(self)
    if self._originalPosition then
        local character = Utils.GetCharacter()
        if character then
            character:PivotTo(self._originalPosition)
        end
        self._originalPosition = nil
    end
end)

function FarmBase:GetTargetEntity(position)
    return nil
end

FarmBase.ShouldContinueFarming = LPH_JIT_MAX(function(self)
    return self._enabled
end)

FarmBase.GetMelee = LPH_NO_VIRTUALIZE(function(self)
    for _, melee in CollectionService:GetTagged("MeleeGear") do
        local ownerId = melee:GetAttribute("OwnerId")
        if ownerId ~= LocalPlayer.UserId then continue end 

        return ReplicatedStorage.GearIntermediaries[tostring(ownerId)][melee:GetAttribute("ReferenceName")]
    end
end)

FarmBase.FarmLoop = LPH_JIT(function(self)
    while true do 
        task.wait()

        local rootPart = Utils.GetRootPart()
        if not rootPart then continue end

        if not self:ShouldContinueFarming() then 
            if rootPart then rootPart.Anchored = false end
            self:ResetPosition()
            continue 
        end

        if not self._originalPosition then
            self._originalPosition = Utils.GetCharacter():GetPivot()
        end

        local entity = self._currentEntity
        if not entity or not entity.Parent or not entity:GetAttribute("IsAlive") then 
            entity = self:GetTargetEntity(rootPart.Position)
            self._currentEntity = entity
        end

        if not entity then 
            task.wait(1)
            continue 
        end

        local shouldContinue = true
        local lastAttackTime = 0
        local attackDelay = 0.1

        self._teleportConnection = RunService.Heartbeat:Connect(LPH_JIT_MAX(function()
            if not shouldContinue then 
                self._teleportConnection:Disconnect()
                return 
            end
            
            if not self:ShouldContinueFarming() then
                shouldContinue = false
                return
            end
            
            if not entity or not entity.Parent or not entity:GetAttribute("IsAlive") then
                shouldContinue = false
                return
            end

            local character = Utils.GetCharacter()
            local root = Utils.GetRootPart()
            if not character or not root then return end

            local success, pivot = pcall(function() return entity:GetPivot() end)
            if not success then
                shouldContinue = false
                return
            end

            character:PivotTo(pivot * CFrame.Angles(-math.pi / 2, 0, 0) + (Vector3.new(Settings.XOffset, entity:GetExtentsSize().Y + Settings.YOffset, 0)))

            local lookDir = (pivot.Position - root.Position).Unit
            
            local currentTime = os.clock()
            if currentTime - lastAttackTime >= attackDelay then
                lastAttackTime = currentTime
                local melee = self:GetMelee()
                melee.MeleeGear_RemoteComponent.RF.TryDamageEntity:InvokeServer(entity, lookDir)
            end
        end))
        
        while shouldContinue and self:ShouldContinueFarming() do
            if not entity or not entity.Parent or not entity:GetAttribute("IsAlive") then
                break
            end
            task.wait()
        end
        
        shouldContinue = false

        if self._teleportConnection then
            self._teleportConnection:Disconnect()
            self._teleportConnection = nil
        end

        if entity and not entity:GetAttribute("IsAlive") then 
            self._currentEntity = nil
        end
    end
end)

function FarmBase:Init()
    MainTrove:Add(task.spawn(function()
        self:FarmLoop()
    end))
end

local AutoFarmModule = FarmBase.new("AutoFarm")

AutoFarmModule.GetTargetEntity = LPH_JIT(function(self, position)
    if Settings.AutoFarmClosestEnabled then
        return Utils.GetClosestEntity(position)
    else
        return Utils.GetClosestEntity(position, function(entity)
            local refName = entity:GetAttribute("ReferenceName")
            return refName and Settings.SelectedEntities[refName]
        end)
    end
end)

AutoFarmModule.ShouldContinueFarming = LPH_JIT_MAX(function(self)
    return Settings.AutoFarmEnabled or Settings.AutoFarmClosestEnabled
end)

local AutoEatModule = {
    _trove = Trove.new(),
    _isEating = false,
}
MainTrove:Add(AutoEatModule._trove)

AutoEatModule.GetConsumables = LPH_JIT(function(self)
    local consumables = {}
    for _, item in CollectionService:GetTagged("Consumable") do
        if item:GetAttribute("IsRotten") then continue end
        table.insert(consumables, item)
    end
    return consumables
end)

AutoEatModule.FindClosestConsumable = LPH_JIT(function(self)
    local rootPart = Utils.GetRootPart()
    if not rootPart then return nil end
    
    local consumables = self:GetConsumables()
    local closestConsumable = nil
    local closestDistance = math.huge
    
    for _, consumable in ipairs(consumables) do
        local distance = (consumable:GetPivot().Position - rootPart.Position).Magnitude
        if distance < closestDistance then
            closestDistance = distance
            closestConsumable = consumable
        end
    end
    
    return closestConsumable
end)

AutoEatModule.ConsumeItem = LPH_NO_VIRTUALIZE(function(self, consumable)
    local remote = consumable.Consumable_RemoteComponent.RF.Consume
    remote:InvokeServer()
end)

AutoEatModule.TryEat = LPH_NO_VIRTUALIZE(function(self)
    if self._isEating then return end
    
    local hungerBar = PlayerGui.PlayerAttributesUI.PlayerAttributes.Bars.Hunger
    if not hungerBar.Visible then return end

    local consumable = self:FindClosestConsumable()
    if consumable then
        self._isEating = true
        task.delay(0.5, function()
            self._isEating = false
        end)
        self:ConsumeItem(consumable)
    end
end)

function AutoEatModule:Init()   
    local hungerBar = PlayerGui.PlayerAttributesUI.PlayerAttributes.Bars.Hunger

    self._trove:Connect(hungerBar:GetPropertyChangedSignal("Visible"), function()
        if Settings.AutoEatEnabled then 
            self:TryEat()
        end
    end)   

    self._trove:Connect(hungerBar:GetPropertyChangedSignal("Size"), function()
        if Settings.AutoEatEnabled and hungerBar.Size.Y.Scale > 0.04 then
            self:TryEat()
        end
    end)
end

local AutoCraftModule = {
    _trove = Trove.new(),
    _craftingInProgress = false,
    _farmModule = FarmBase.new("AutoCraft"),
}
MainTrove:Add(AutoCraftModule._trove)

function AutoCraftModule:UpdateStatus(text)
end

AutoCraftModule.GetRecipeMaterials = LPH_JIT_MAX(function(self, itemName)
    local recipe = CraftingData[itemName]
    return recipe and recipe.Materials
end)

AutoCraftModule.GetByproductValue = LPH_JIT_MAX(function(self, itemName, materialName)
    local itemData = ItemsToolkit.GetItemData(itemName)
    if itemData and itemData.Byproducts and itemData.Byproducts[materialName] then
        return itemData.Byproducts[materialName]
    end
    return 0
end)

AutoCraftModule.GetByproductItems = LPH_JIT(function(self, materialName)
    local byproductItems = {}
    
    for _, item in CollectionService:GetTagged("Interactable") do
        local refName = item:GetAttribute("ReferenceName")
        if refName then
            local byproductValue = self:GetByproductValue(refName, materialName)
            if byproductValue > 0 then
                table.insert(byproductItems, {
                    item = item,
                    value = byproductValue
                })
            end
        end
    end
    
    return byproductItems
end)

AutoCraftModule.GetAvailableMaterialCount = LPH_JIT(function(self, materialName)
    local directMaterials = Utils.GetItemsByName(materialName)
    local totalCount = #directMaterials
    
    local byproductItems = self:GetByproductItems(materialName)
    for _, byproductData in ipairs(byproductItems) do
        totalCount = totalCount + byproductData.value
    end
    
    return totalCount
end)

AutoCraftModule.GetEntityDrops = LPH_JIT(function(self, materialName, checkByproducts)
    local droppingEntities = {}
    
    for entityName, entityData in pairs(BackupData.Entities) do
        if Utils.IsEntityImmune(entityName) then continue end
   
        if entityData and entityData.LootPool then
            for lootName, loot in pairs(entityData.LootPool) do                
                local matches = false
                
                if not checkByproducts then
                    matches = (lootName == materialName)
                else
                    matches = (self:GetByproductValue(lootName, materialName) > 0)
                end
                
                if matches then
                    table.insert(droppingEntities, entityName)
                    break
                end
            end
        end
    end
    
    return droppingEntities
end)

AutoCraftModule.FindAvailableEntity = LPH_JIT(function(self, materialName)
    local directDroppers = self:GetEntityDrops(materialName, false)
    for _, entityName in ipairs(directDroppers) do
        if Utils.EntityExistsInMap(entityName) then
            return entityName, false
        end
    end
    
    local byproductDroppers = self:GetEntityDrops(materialName, true)
    for _, entityName in ipairs(byproductDroppers) do
        if Utils.EntityExistsInMap(entityName) then
            return entityName, true
        end
    end
    
    return nil, false
end)

AutoCraftModule._farmModule.GetTargetEntity = LPH_JIT(function(self, position)
    if not self._targetEntityName then return nil end
    
    return Utils.GetClosestEntity(position, function(entity)
        local refName = entity:GetAttribute("ReferenceName")
        return refName == self._targetEntityName
    end)
end)

AutoCraftModule._farmModule.ShouldContinueFarming = LPH_JIT_MAX(function(self)
    return self._enabled
end)

function AutoCraftModule._farmModule:StartFarming(entityName)
    self._targetEntityName = entityName
    self:SetEnabled(true)
end

function AutoCraftModule._farmModule:StopFarming()
    self._targetEntityName = nil
    self:SetEnabled(false)
end

function AutoCraftModule:FarmUntilEnough(entityName, targetAmount, materialName)
    self._farmModule:StartFarming(entityName)
    
    self:UpdateStatus(
        "Status: Farming\n" ..
        "Entity: " .. entityName .. "\n" ..
        "Material: " .. materialName .. "\n" ..
        "Target: " .. targetAmount
    )
    
    while Settings.AutoCraftEnabled do
        task.wait(0.5)
        
        local currentAmount = self:GetAvailableMaterialCount(materialName)
        
        self:UpdateStatus(
            "Status: Farming\n" ..
            "Entity: " .. entityName .. "\n" ..
            "Material: " .. materialName .. "\n" ..
            "Progress: " .. currentAmount .. "/" .. targetAmount
        )
        
        if currentAmount >= targetAmount then
            break
        end
        
        if not Utils.EntityExistsInMap(entityName) then
            break
        end
    end
    
    self._farmModule:StopFarming()
    
    task.wait(0.3)

    local character = Utils.GetCharacter()
    local rootPart = Utils.GetRootPart()
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        humanoid.PlatformStand = true
    end
    
    if rootPart then
        rootPart.Velocity = Vector3.zero
        rootPart.RotVelocity = Vector3.zero
        rootPart.Anchored = true
    end
    
    task.wait(0.1)
    
    local targetPart = TeleportLocations.MaterialProcessor
    local forwardOffset = targetPart.CFrame.LookVector * 10
    character:PivotTo(targetPart.CFrame * CFrame.new(forwardOffset) + Vector3.new(0, 5, 0))
    
    task.wait(0.2)
    
    if rootPart then
        rootPart.Anchored = false
    end
    
    if humanoid then
        humanoid.PlatformStand = false
    end
end

AutoCraftModule.BringMaterialsToProcessor = LPH_JIT(function(self, materialName, amount)
    local processorPosition = TeleportLocations.MaterialProcessorCraft.Position
    local brought = 0
    local materialValue = 0
    
    self:UpdateStatus(
        "Status: Collecting Materials\n" ..
        "Material: " .. materialName .. "\n" ..
        "Amount: " .. amount
    )
    
    local directMaterials = Utils.GetItemsByName(materialName)
    for _, item in ipairs(directMaterials) do
        if materialValue >= amount then break end
        
        task.spawn(function()
            local height = item:GetExtentsSize().Y
            local stackHeight = brought * height
            local position = processorPosition + Vector3.new(0, height/2 + stackHeight + 5, 0)
            ItemModule:BringItem(item, position)
        end)
        
        brought = brought + 1
        materialValue = materialValue + 1
    end
    
    if materialValue < amount then
        local byproductItems = self:GetByproductItems(materialName)
        for _, byproductData in ipairs(byproductItems) do
            if materialValue >= amount then break end
            
            task.spawn(function()
                local height = byproductData.item:GetExtentsSize().Y
                local stackHeight = brought * height
                local position = processorPosition + Vector3.new(0, height/2 + stackHeight + 5, 0)
                ItemModule:BringItem(byproductData.item, position)
            end)
            
            brought = brought + 1
            materialValue = materialValue + byproductData.value
        end
    end
    
    return materialValue
end)

AutoCraftModule.GetMaterials = LPH_JIT_MAX(function(self)
    local materials = {}
    for _, material in ipairs(PlayerGui.CraftingMenu.Main.GenericBackground.Glow.Background.LeftPanel.Resources:GetChildren()) do 
        if not material:IsA("Frame") then continue end
        materials[material.Name] = tonumber(material.Amount.Text)
    end
    return materials
end)

AutoCraftModule.GetStock = LPH_JIT_MAX(function(self)
    local stock = {}
    for _, tier in ipairs(PlayerGui.CraftingMenu.Main.GenericBackground.Glow.Background.LeftPanel.Items:GetChildren()) do 
        if not tier:IsA("Frame") then continue end
        for _, item in ipairs(tier.Items:GetChildren()) do 
		    if not item:IsA("ImageButton") then continue end
            stock[item.Name] = tonumber(item.Content.Stock.StockLabel.Text:match("%d+"))
        end
    end
    return stock
end)

AutoCraftModule.GetTier = LPH_JIT_MAX(function(self)
    local highestTier = 0
    for _, tierFrame in ipairs(PlayerGui.CraftingMenu.Main.GenericBackground.Glow.Background.LeftPanel.Items:GetChildren()) do 
        if not tierFrame:IsA("Frame") then continue end    
        local tierNum = tonumber(tierFrame.Name:match("%d+"))
        if not tierNum then continue end   
        for _, item in ipairs(tierFrame.Items:GetChildren()) do 
            if not item:IsA("ImageButton") then continue end       
            local hiddenFrame = item:FindFirstChild("Hidden")
            if hiddenFrame and hiddenFrame.Visible then
                continue
            end        
            local content = item:FindFirstChild("Content")
            if content and content:IsA("CanvasGroup") then
                if content.GroupTransparency == 0 then
                    highestTier = math.max(highestTier, tierNum)
                    break
                end
            end 
        end
    end
    return highestTier
end)

AutoCraftModule.GetCraftingBenchData = LPH_JIT_MAX(function(self)
    return {
        materials = self:GetMaterials(),
        stock = self:GetStock(),
        tier = self:GetTier(),
    }
end)

AutoCraftModule.CanCraftItem = LPH_JIT(function(self, itemName)
    local data = self:GetCraftingBenchData()
    if not data then return false, "No crafting bench data" end

    local recipe = CraftingData[itemName]
    if not recipe then return false, "No recipe found" end

    if data.tier < recipe.Tier then
        return false, "Locked (Requires Tier " .. data.tier .. " bench)"
    end
    
    local stockAmount = data.stock[itemName]
    if stockAmount == nil then
        return true, "∞"
    elseif stockAmount <= 0 then
        return false, "Out of stock"
    end
    
    return true, stockAmount
end)

AutoCraftModule.HasEnoughMaterialsAtBench = LPH_JIT(function(self, itemName)
    local data = self:GetCraftingBenchData()
    if not data then return false end
    
    local recipe = self:GetRecipeMaterials(itemName)
    if not recipe then return false end
    
    for materialName, requiredAmount in pairs(recipe) do
        local availableAmount = data.materials[materialName] or 0
        if availableAmount < requiredAmount then
            return false, materialName, availableAmount, requiredAmount
        end
    end
    
    return true
end)

AutoCraftModule.CraftItem = LPH_NO_VIRTUALIZE(function(self, itemName)  
    self:UpdateStatus(
        "Status: Crafting\n" ..
        "Item: " .. itemName
    )

    for i = 1, 100 do 
        NetworkEvent:FireServer(
            i,
            "Craft",
            itemName
        )
    end
    
    return true    
end)

AutoCraftModule.CollectExistingItems = LPH_JIT(function(self, materialName)
    local jamItems = Utils.GetItemsByName(materialName)
    if #jamItems > 0 then
        ItemModule:TeleportToProcessor(jamItems, "MaterialProcessor")
        return true
    end
    
    local byproductItems = self:GetByproductItems(materialName)
    if #byproductItems > 0 then
        local items = {}
        for _, data in ipairs(byproductItems) do
            table.insert(items, data.item)
        end
        ItemModule:TeleportToProcessor(items, "MaterialProcessor")
        return true
    end
    
    return false
end)

function AutoCraftModule:HandleMapExpansion()
    self:UpdateStatus(
        "Status: Map Expansion\n" ..
        "Checking for JellyfishJam..."
    )
    
    if self:CollectExistingItems("JellyfishJam") then
        self:UpdateStatus(
            "Status: Map Expansion\n" ..
            "Found JellyfishJam\n" ..
            "Action: Collected"
        )
        task.wait(1)
        return true
    end
    
    local expandEntity, _ = self:FindAvailableEntity("JellyfishJam")
   
    if not expandEntity then
        self:UpdateStatus(
            "Status: Waiting\n" ..
            "Reason: No entities for expansion"
        )
        return false
    end
    
    self:UpdateStatus(
        "Status: Map Expansion\n" ..
        "Farming: " .. expandEntity .. "\n" ..
        "For: JellyfishJam"
    )
    
    self._farmModule:StartFarming(expandEntity)
    
    local farmStartTime = os.clock()
    local maxFarmTime = 30
    
    while Settings.AutoCraftEnabled and (os.clock() - farmStartTime) < maxFarmTime do
        task.wait(0.5)
        
        if self:CollectExistingItems("JellyfishJam") then
            self._farmModule:StopFarming()
            
            task.wait(0.3)

            local character = Utils.GetCharacter()
            local rootPart = Utils.GetRootPart()
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            
            if humanoid then
                humanoid.PlatformStand = true
            end
            
            if rootPart then
                rootPart.Velocity = Vector3.zero
                rootPart.RotVelocity = Vector3.zero
                rootPart.Anchored = true
            end
            
            task.wait(0.1)
            
            local targetPart = TeleportLocations.MaterialProcessor
            local forwardOffset = targetPart.CFrame.LookVector * 10
            character:PivotTo(targetPart.CFrame * CFrame.new(forwardOffset) + Vector3.new(0, 5, 0))
            
            task.wait(0.2)
            
            if rootPart then
                rootPart.Anchored = false
            end
            
            if humanoid then
                humanoid.PlatformStand = false
            end
            
            task.wait(1)
            return true
        end
        
        if not Utils.EntityExistsInMap(expandEntity) then
            break
        end
    end
    
    self._farmModule:StopFarming()
    
    task.wait(0.3)

    local character = Utils.GetCharacter()
    local rootPart = Utils.GetRootPart()
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        humanoid.PlatformStand = true
    end
    
    if rootPart then
        rootPart.Velocity = Vector3.zero
        rootPart.RotVelocity = Vector3.zero
        rootPart.Anchored = true
    end
    
    task.wait(0.1)
    
    local targetPart = TeleportLocations.MaterialProcessor
    local forwardOffset = targetPart.CFrame.LookVector * 10
    character:PivotTo(targetPart.CFrame * CFrame.new(forwardOffset) + Vector3.new(0, 5, 0))
    
    task.wait(0.2)
    
    if rootPart then
        rootPart.Anchored = false
    end
    
    if humanoid then
        humanoid.PlatformStand = false
    end
    
    return false
end

function AutoCraftModule:GatherMissingMaterial(materialName, amountNeeded)
    local entityName, isByproduct = self:FindAvailableEntity(materialName)
    if entityName then
        local dropType = isByproduct and " (byproduct)" or " (direct)"
        self:UpdateStatus(
            "Status: Farming\n" ..
            "Entity: " .. entityName .. "\n" ..
            "Material: " .. materialName .. dropType .. "\n" ..
            "Amount Needed: " .. amountNeeded
        )
        
        self:FarmUntilEnough(entityName, amountNeeded, materialName)
        return true
    else
        self:UpdateStatus(
            "Status: Map Expansion Needed\n" ..
            "Material: " .. materialName .. "\n" ..
            "Reason: No entities available"
        )
        
        return self:HandleMapExpansion()
    end
end

function AutoCraftModule:ProcessCraftingQueue()
    if self._craftingInProgress then return end
    
    self._craftingInProgress = true
    
    for itemName, enabled in pairs(Settings.SelectedCraftItems) do
        if not enabled or not Settings.AutoCraftEnabled then continue end
        
        local canCraft, stockInfo = self:CanCraftItem(itemName)
        if not canCraft then
            self:UpdateStatus(
                "Status: Skipping\n" ..
                "Item: " .. itemName .. "\n" ..
                "Reason: " .. stockInfo
            )
            continue
        end
        
        local materials = self:GetRecipeMaterials(itemName)
        if not materials then 
            self:UpdateStatus(
                "Status: Error\n" ..
                "Item: " .. itemName .. "\n" ..
                "Reason: No recipe found"
            )
            continue 
        end
        
        if self:HasEnoughMaterialsAtBench(itemName) then
            self:UpdateStatus(
                "Status: Ready to Craft\n" ..
                "Item: " .. itemName .. "\n" ..
                "Materials: At bench"
            )
            
            TeleportModule:TeleportPlayer("MaterialProcessor")
            task.wait(0.3)
            self:CraftItem(itemName)
            task.wait(0.3)
            continue
        end
        
        local benchData = self:GetCraftingBenchData()
        local missingMaterials = {}
        
        for materialName, requiredAmount in pairs(materials) do
            local atBench = (benchData.materials[materialName] or 0)
            local inWorld = self:GetAvailableMaterialCount(materialName)
            local totalAvailable = atBench + inWorld
            if totalAvailable < requiredAmount then
                missingMaterials[materialName] = requiredAmount - totalAvailable
            end
        end
        
        if not next(missingMaterials) then
            self:UpdateStatus(
                "Status: Collecting Materials\n" ..
                "Item: " .. itemName .. "\n" ..
                "Action: Bringing to processor"
            )
            
            TeleportModule:TeleportPlayer("MaterialProcessor")
            task.wait(0.3)
            
            for materialName, requiredAmount in pairs(materials) do
                self:BringMaterialsToProcessor(materialName, requiredAmount)
            end
            
            task.wait(0.5)
            self:CraftItem(itemName)
            task.wait(0.3)
        else
            for materialName, amountNeeded in pairs(missingMaterials) do
                if not Settings.AutoCraftEnabled then break end
                
                self:GatherMissingMaterial(materialName, amountNeeded)
            end
        end
    end
    
    self._craftingInProgress = false
    self:UpdateStatus("Status: Idle\nWaiting for tasks...")
end

function AutoCraftModule:Init()
    self._farmModule:Init()
    
    self._trove:Add(task.spawn(function()
        while true do
            task.wait(0.1)
            if Settings.AutoCraftEnabled then
                self:ProcessCraftingQueue()
            else
                self:UpdateStatus("Status: Disabled")
            end
        end
    end))
end

local ChestModule = {
    _trove = Trove.new(),
    _connections = {},
}
MainTrove:Add(ChestModule._trove)

ChestModule.SetInstantOpen = LPH_NO_VIRTUALIZE(function(self, enabled)
    if enabled then
        for _, chest in ipairs(CollectionService:GetTagged("Chest")) do 
            self:SetChestInstant(chest, true)
        end
    else
        for _, chest in ipairs(CollectionService:GetTagged("Chest")) do 
            self:SetChestInstant(chest, false)
        end
    end
end)

ChestModule.SetChestInstant = LPH_NO_VIRTUALIZE(function(self, chest, enabled)
    local prompt = chest:FindFirstChild("ProximityPrompt", true)
    if not prompt then return end
    
    if enabled then
        if not prompt:GetAttribute("OriginalHoldDuration") then
            prompt:SetAttribute("OriginalHoldDuration", prompt.HoldDuration)
        end
        
        prompt.HoldDuration = 0
        
        if self._connections[chest] then
            self._connections[chest]:Disconnect()
        end
        
        self._connections[chest] = prompt:GetPropertyChangedSignal("HoldDuration"):Connect(function()
            if Settings.InstantOpenChests and prompt.HoldDuration ~= 0 then 
                prompt.HoldDuration = 0
            end
        end)
    else
        local originalDuration = prompt:GetAttribute("OriginalHoldDuration")
        if originalDuration then
            prompt.HoldDuration = originalDuration
            prompt:SetAttribute("OriginalHoldDuration", nil)
        end
        
        if self._connections[chest] then
            self._connections[chest]:Disconnect()
            self._connections[chest] = nil
        end
    end
end)

ChestModule.OpenAllChests = LPH_NO_VIRTUALIZE(function(self)
    for _, chest in ipairs(CollectionService:GetTagged("Chest")) do 
        local prompt = chest:FindFirstChild("ProximityPrompt", true) 
        if not prompt then continue end 

        local pivot = chest:GetPivot()

        local inBounds = Utils.IsInBounds(pivot.Position)
        if not inBounds then continue end 

        local rootPart = Utils.GetRootPart()
        if not rootPart then continue end 

        rootPart.CFrame = pivot + (Vector3.yAxis * (chest:GetExtentsSize().Y))

        task.wait(0.5)

        fireproximityprompt(prompt)

        task.wait(0.5)
    end
end)

function ChestModule:Init()
    for _, chest in ipairs(CollectionService:GetTagged("Chest")) do 
        if Settings.InstantOpenChests then
            self:SetChestInstant(chest, true)
        end
    end
    
    self._trove:Add(CollectionService:GetInstanceAddedSignal("Chest"):Connect(function(chest)
        if Settings.InstantOpenChests then
            self:SetChestInstant(chest, true)
        end
    end))
    
    self._trove:Add(CollectionService:GetInstanceRemovedSignal("Chest"):Connect(function(chest)
        if self._connections[chest] then
            self._connections[chest]:Disconnect()
            self._connections[chest] = nil
        end
    end))
end

local ResidentModule = {}

ResidentModule.GetAllResidents = LPH_JIT(function(self)
    local residents = {}
    for _, resident in ipairs(CollectionService:GetTagged("Resident")) do
        if resident:IsDescendantOf(workspace) then
            table.insert(residents, resident)
        end
    end
    return residents
end)

ResidentModule.GetResidentsByName = LPH_JIT(function(self, residentName)
    local residents = {}
    for _, resident in ipairs(CollectionService:GetTagged("Resident")) do
        if resident:IsDescendantOf(workspace) then
            local refName = resident:GetAttribute("ReferenceName")
            if refName == residentName then
                table.insert(residents, resident)
            end
        end
    end
    return residents
end)

ResidentModule.BringResident = LPH_NO_VIRTUALIZE(function(self, resident, position)    
    if resident.PrimaryPart then 
        resident.PrimaryPart.Anchored = true 
    end

    AttemptDrag:InvokeServer(resident)
    Utils.TweenPivot(resident, CFrame.new(position), 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    task.wait(1)
    StopDrag:InvokeServer()

    local alignPosition = resident:FindFirstChild("AlignPosition", true)
    local alignOrientation = resident:FindFirstChild("AlignOrientation", true)
    if alignPosition then alignPosition:Destroy() end
    if alignOrientation then alignOrientation:Destroy() end
    
    if resident.PrimaryPart then 
        resident.PrimaryPart.Anchored = false
    end
end)

ResidentModule.BringResidents = LPH_JIT(function(self, residentNames, amount)
    local rootPart = Utils.GetRootPart()
    if not rootPart then return end

    local forwardOffset = 5
    local horizontalSpacing = 6
    local currentIndex = 0

    for residentName, enabled in pairs(residentNames) do
        if not enabled then continue end
        local residents = self:GetResidentsByName(residentName)

        for i = 1, amount or #residents do
            task.spawn(function()
                local resident = residents[i]
                if not resident then return end

                local capturedIndex = currentIndex
                local height = resident:GetExtentsSize().Y
                local position = rootPart.Position 
                    + rootPart.CFrame.LookVector * forwardOffset
                    + rootPart.CFrame.RightVector * (capturedIndex * horizontalSpacing)
                    + Vector3.new(0, height/2, 0)
                
                self:BringResident(resident, position)
                
                currentIndex = currentIndex + 1
            end)
        end
    end
end)

ResidentModule.TeleportToProcessor = LPH_JIT(function(self, residents)
    if not TeleportLocations.MaterialProcessor then return end

    local targetPosition = TeleportLocations.MaterialProcessor.Position
    local horizontalSpacing = 6
    local stackOffset = 5

    for index, resident in ipairs(residents) do
        task.spawn(function()
            local height = resident:GetExtentsSize().Y
            local position = targetPosition 
                + Vector3.new(index * horizontalSpacing, height/2 + stackOffset, 0)
            
            self:BringResident(resident, position)
        end)
    end
end)

ResidentModule.TeleportResidentsByName = LPH_JIT(function(self, residentNames)
    local allResidents = {}
    for residentName, enabled in pairs(residentNames) do
        if not enabled then continue end
        local residents = self:GetResidentsByName(residentName)
        for _, resident in ipairs(residents) do
            table.insert(allResidents, resident)
        end
    end
    self:TeleportToProcessor(allResidents)
end)

local MovementModule = {}

function MovementModule:Init()
    local character = Utils.GetCharacter()
    local rootPart = Utils.GetRootPart()
    
    MainTrove:Add(RunService.Heartbeat:Connect(LPH_JIT_MAX(function()
        local Character = Utils.GetCharacter()
        if not Character then return end
        
        local HumanoidRootPart = Utils.GetRootPart()
        if not HumanoidRootPart then return end
        
        if Settings.Fly.Enabled then
            local LookVector = workspace.CurrentCamera.CFrame.LookVector
            local Direction = Vector3.new()
            
            local Directions = {
                [Enum.KeyCode.W] = LookVector,
                [Enum.KeyCode.A] = Vector3.new(LookVector.Z, 0, -LookVector.X),
                [Enum.KeyCode.S] = -LookVector,
                [Enum.KeyCode.D] = Vector3.new(-LookVector.Z, 0, LookVector.X),
                [Enum.KeyCode.LeftControl] = Vector3.new(0, -1, 0),
                [Enum.KeyCode.LeftShift] = Vector3.new(0, -1, 0),
                [Enum.KeyCode.Space] = Vector3.new(0, 1, 0)
            }
            
            for Key, Dir in pairs(Directions) do
                if game:GetService("UserInputService"):IsKeyDown(Key) then
                    Direction = Direction + Dir
                end
            end
              
            if Direction.Magnitude > 0 then
                HumanoidRootPart.Velocity = Direction.Unit * Settings.Fly.Speed
                HumanoidRootPart.Anchored = false
            else
                HumanoidRootPart.Velocity = Vector3.new()
                HumanoidRootPart.Anchored = true
            end
        elseif HumanoidRootPart.Anchored then
            HumanoidRootPart.Anchored = false
        end
        
        if not Settings.Fly.Enabled and Settings.WalkSpeed.Enabled then
            local LookVector = workspace.CurrentCamera.CFrame.LookVector
            local Direction = Vector3.new()
        
            local Directions = {
                [Enum.KeyCode.W] = Vector3.new(LookVector.X, 0, LookVector.Z),
                [Enum.KeyCode.A] = Vector3.new(LookVector.Z, 0, -LookVector.X),
                [Enum.KeyCode.S] = -Vector3.new(LookVector.X, 0, LookVector.Z),
                [Enum.KeyCode.D] = Vector3.new(-LookVector.Z, 0, LookVector.X)
            }
        
            for Key, Dir in pairs(Directions) do
                if game:GetService("UserInputService"):IsKeyDown(Key) then
                    Direction = Direction + Dir
                end
            end
        
            if Direction.Magnitude > 0 then
                HumanoidRootPart.Velocity = Direction.Unit * Settings.WalkSpeed.Speed + Vector3.new(0, HumanoidRootPart.Velocity.Y, 0)
            end 
        end
    end)))

    MainTrove:Add(function()
        local HumanoidRootPart = Utils.GetRootPart()
        if not HumanoidRootPart then return end

        HumanoidRootPart.Anchored = false
    end)
end

local KillAuraModule = {
    _trove = Trove.new(),
    _enabled = false,
}
MainTrove:Add(KillAuraModule._trove)

KillAuraModule.GetMelee = LPH_NO_VIRTUALIZE(function(self)
    for _, melee in ipairs(CollectionService:GetTagged("MeleeGear")) do
        local ownerId = melee:GetAttribute("OwnerId")
        if ownerId ~= LocalPlayer.UserId then continue end 

        return ReplicatedStorage.GearIntermediaries[tostring(ownerId)][melee:GetAttribute("ReferenceName")]
    end
end)

KillAuraModule.GetEntitiesInRange = LPH_JIT(function(self, character, range)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart then
        return {}
    end
    
    local overlapParams = OverlapParams.new()
    overlapParams.FilterType = Enum.RaycastFilterType.Exclude
    overlapParams.CollisionGroup = "Default"
    overlapParams:AddToFilter(character)
    
    local parts = workspace:GetPartBoundsInRadius(rootPart.Position, range, overlapParams)
    
    local entities = {}
    local seenEntities = {}
    
    for _, part in ipairs(parts) do
        local current = part.Parent
        local entity = nil
        
        for i = 1, 3 do
            if not current then break end
            
            if CollectionService:HasTag(current, "Entity") then
                entity = current
                break
            end
            
            current = current.Parent
        end
        
        if entity and not seenEntities[entity] then
            seenEntities[entity] = true
            
            if not Utils.IsInBounds(entity:GetPivot().Position) then continue end
            if not entity:GetAttribute("IsAlive") then continue end

            local refName = entity:GetAttribute("ReferenceName")
            local entityData = EntityData[refName]       
            if not entityData then continue end

            if Utils.IsEntityImmune(refName) then continue end

            table.insert(entities, entity)
        end
    end
    
    return entities
end)

KillAuraModule.KillAuraLoop = LPH_JIT(function(self)
    local lastAttackTime = 0
    local attackDelay = 0
    
    while true do 
        task.wait()

        if not self._enabled then 
            task.wait(0.5)
            continue 
        end

        local character = Utils.GetCharacter()
        local rootPart = Utils.GetRootPart()
        if not (character and rootPart) then continue end

        local melee = self:GetMelee()
        if not melee then continue end

        local range = melee:GetAttribute("MeleeRange") or 12
        local entities = self:GetEntitiesInRange(character, range)

        if #entities == 0 then continue end

        local currentTime = os.clock()
        if currentTime - lastAttackTime < attackDelay then continue end
        
        lastAttackTime = currentTime

        for _, entity in ipairs(entities) do
            if not entity or not entity.Parent or not entity:GetAttribute("IsAlive") then continue end
            
            local success, pivot = pcall(function() return entity:GetPivot() end)
            if not success then continue end

            local lookDir = (pivot.Position - rootPart.Position).Unit
            
            melee.MeleeGear_RemoteComponent.RF.TryDamageEntity:InvokeServer(entity, lookDir)
        end
    end
end)

function KillAuraModule:Init()
    self._trove:Add(task.spawn(function()
        self:KillAuraLoop()
    end))
end

local HiveModule = {
    _enabled = false,
    _currentEntity = nil,
    _originalPosition = nil,
    _teleportConnection = nil,
    _targetEntityNames = {},
}

HiveModule.GetCurrentLevel = LPH_JIT_MAX(function(self)
    return Utils.GetLightSourceLevel()
end)

HiveModule.GetMaxLevel = LPH_JIT_MAX(function(self)
    return #MapGenerationConfig.Levels
end)

HiveModule._targetLevel = HiveModule.GetMaxLevel(HiveModule)

HiveModule.GetMelee = LPH_NO_VIRTUALIZE(function(self)
    for _, melee in ipairs(CollectionService:GetTagged("MeleeGear")) do
        local ownerId = melee:GetAttribute("OwnerId")
        if ownerId ~= LocalPlayer.UserId then continue end 

        return ReplicatedStorage.GearIntermediaries[tostring(ownerId)][melee:GetAttribute("ReferenceName")]
    end
end)

HiveModule.ResetPosition = LPH_NO_VIRTUALIZE(function(self)
    if self._originalPosition then
        local character = Utils.GetCharacter()
        if character then
            character:PivotTo(self._originalPosition)
        end
        self._originalPosition = nil
    end
end)

HiveModule.GetByproductValue = LPH_JIT_MAX(function(self, itemName, materialName)
    local itemData = ItemsToolkit.GetItemData(itemName)
    if itemData and itemData.Byproducts and itemData.Byproducts[materialName] then
        return itemData.Byproducts[materialName]
    end
    return 0
end)

HiveModule.ParseAmount = LPH_JIT_MAX(function(self, amount)
    local amountType = typeof(amount)
    
    if amountType == "number" then
        return amount
    elseif amountType == "string" then
        local min, max = amount:match("(%d+)%-(%d+)")
        if min and max then
            return (tonumber(min) + tonumber(max)) / 2
        end

        local num = tonumber(amount)
        if num then
            return num
        end
    end
    
    return 0
end)

HiveModule.CalculateEntityYield = LPH_JIT(function(self, entityName)
    local entityData = BackupData.Entities[entityName]
    if not entityData or not entityData.LootPool then
        return 0
    end
    
    local totalYield = 0
    
    for lootName, lootData in pairs(entityData.LootPool) do
        local amount = self:ParseAmount(lootData.Amount)
        local chance = lootData.Chance or 1
        
        if lootName == "JellyfishJam" then
            totalYield = totalYield + (amount * chance)
        else
            local byproductValue = self:GetByproductValue(lootName, "JellyfishJam")
            if byproductValue > 0 then
                totalYield = totalYield + (amount * chance * byproductValue)
            end
        end
    end
    
    return totalYield
end)

HiveModule.FindTargetEntities = LPH_JIT(function(self)
    local entityYields = {}
    
    for entityName, entityData in pairs(BackupData.Entities) do
        if Utils.IsEntityImmune(entityName) then continue end
        
        local yield = self:CalculateEntityYield(entityName)
        if yield > 0 then
            table.insert(entityYields, {
                name = entityName,
                yield = yield
            })
        end
    end
    
    table.sort(entityYields, function(a, b)
        return a.yield > b.yield
    end)
    
    local sortedNames = {}
    for _, data in ipairs(entityYields) do
        table.insert(sortedNames, data.name)
    end
    
    return sortedNames, entityYields
end)

HiveModule.GetClosestTargetEntity = LPH_JIT(function(self, position)
    local targetEntityNames, entityYields = self:FindTargetEntities()
    
    local yieldMap = {}
    for _, data in ipairs(entityYields) do
        yieldMap[data.name] = data.yield
    end
    
    local bestEntity = nil
    local highestYield = -1
    local closestDistance = math.huge
    
    for _, entity in ipairs(CollectionService:GetTagged("Entity")) do 
        if not Utils.IsInBounds(entity:GetPivot().Position) then continue end
        if not entity:GetAttribute("IsAlive") then continue end

        local refName = entity:GetAttribute("ReferenceName")
        
        if not table.find(targetEntityNames, refName) then continue end
        
        local entityData = BackupData.Entities[refName]
        if not entityData then continue end

        if Utils.IsEntityImmune(refName) then continue end

        local distance = (position - entity:GetPivot().Position).Magnitude
        local yield = yieldMap[refName] or 0
        
        if yield > highestYield or (yield == highestYield and distance < closestDistance) then
            bestEntity = entity
            highestYield = yield
            closestDistance = distance
        end
    end

    return bestEntity
end)

HiveModule.CollectAndBringJam = LPH_JIT(function(self)
    local jamItems = Utils.GetItemsByName("JellyfishJam")
    
    for _, item in ipairs(CollectionService:GetTagged("Interactable")) do
        local refName = item:GetAttribute("ReferenceName")
        if refName and self:GetByproductValue(refName, "JellyfishJam") > 0 then
            table.insert(jamItems, item)
        end
    end
    
    if #jamItems > 0 then
        ItemModule:TeleportToProcessor(jamItems, "MaterialProcessor", true)
        return true
    end
    return false
end)

HiveModule.FarmLoop = LPH_JIT(function(self)
    while true do 
        task.wait()

        local rootPart = Utils.GetRootPart()
        if not rootPart then continue end

        local currentLevel = self:GetCurrentLevel()
        if currentLevel >= self:GetMaxLevel() then
            continue
        end

        if not self._enabled then 
            self:ResetPosition()
            continue 
        end

        if not self._originalPosition then
            self._originalPosition = Utils.GetCharacter():GetPivot()
        end

        local entity = self:GetClosestTargetEntity(rootPart.Position)
        self._currentEntity = entity

        if not entity then 
            task.wait(2)
            continue 
        end

        local shouldContinue = true
        local lastAttackTime = 0
        local attackDelay = 0.1

        self._teleportConnection = RunService.Heartbeat:Connect(LPH_JIT_MAX(function()
            if not shouldContinue then 
                self._teleportConnection:Disconnect()
                return 
            end
            
            if not self._enabled then
                shouldContinue = false
                return
            end
            
            if not entity or not entity.Parent or not entity:GetAttribute("IsAlive") then
                shouldContinue = false
                return
            end

            local character = Utils.GetCharacter()
            local root = Utils.GetRootPart()
            if not character or not root then return end

            local success, pivot = pcall(function() return entity:GetPivot() end)
            if not success then
                shouldContinue = false
                return
            end

            character:PivotTo(pivot * CFrame.Angles(-math.pi / 2, 0, 0) + (Vector3.new(Settings.XOffset, entity:GetExtentsSize().Y + Settings.YOffset, 0)))

            local lookDir = (pivot.Position - root.Position).Unit
            
            local currentTime = os.clock()
            if currentTime - lastAttackTime >= attackDelay then
                lastAttackTime = currentTime
                local melee = self:GetMelee()
                if melee then
                    melee.MeleeGear_RemoteComponent.RF.TryDamageEntity:InvokeServer(entity, lookDir)
                end
            end
        end))
        
        while shouldContinue and self._enabled do
            if not entity or not entity.Parent or not entity:GetAttribute("IsAlive") then
                break
            end
            task.wait()
        end
        
        shouldContinue = false

        if self._teleportConnection then
            self._teleportConnection:Disconnect()
            self._teleportConnection = nil
        end

        if entity and not entity:GetAttribute("IsAlive") then 
            TeleportModule:TeleportPlayer("MaterialProcessor")
            self:CollectAndBringJam()
            
            self._currentEntity = nil
            
            task.wait(0.5)
        end
    end
end)

function HiveModule:Init()
    MainTrove:Add(task.spawn(function()
        self:FarmLoop()
    end))
end

do 
    AutoFarmModule:Init()
    AutoEatModule:Init()
    AutoCraftModule:Init()
    MovementModule:Init()
    ChestModule:Init() 
    KillAuraModule:Init()
    HiveModule:Init()
end 

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Pradaxca 🌸 | ShenXiue",
   LoadingTitle = "ShenXiue Subsystem",
   LoadingSubtitle = "Developer: Prada",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "PradaxcaConfigs",
      FileName = "BikiniBottomFarm"
   },
   Discord = { Enabled = false },
   KeySystem = false,
})

local colors = {
    Color3.fromRGB(255, 105, 180),
    Color3.fromRGB(20, 20, 20),
}

local MainTab = Window:CreateTab("Main", 10012586884)
local ItemsTab = Window:CreateTab("Items & Residents", 10012497693)
local CraftTab = Window:CreateTab("Crafting & Misc", 10012495808)

local EntitySection = MainTab:CreateSection("Entity Farming")

MainTab:CreateToggle({
   Name = "Auto Kill Closest",
   CurrentValue = false,
   Callback = function(Value)
       Settings.AutoFarmClosestEnabled = Value
       if Value then Settings.AutoFarmEnabled = false end
   end,
})

MainTab:CreateToggle({
   Name = "Kill Aura",
   CurrentValue = false,
   Callback = function(Value)
       KillAuraModule._enabled = Value
   end,
})

local GetEntities = LPH_JIT_MAX(function()
    local entities = {}
    for entityName in pairs(BackupData.Entities) do table.insert(entities, entityName) end
    table.sort(entities)
    return entities
end)

MainTab:CreateDropdown({
   Name = "Select Entities to Farm",
   Options = GetEntities(),
   CurrentOption = {},
   MultipleOptions = true,
   Callback = function(Options)
       Settings.SelectedEntities = {}
       for _, entityName in ipairs(Options) do
           Settings.SelectedEntities[entityName] = true
       end
   end,
})

MainTab:CreateToggle({
   Name = "Auto Kill Selected",
   CurrentValue = false,
   Callback = function(Value)
       Settings.AutoFarmEnabled = Value
       if Value then Settings.AutoFarmClosestEnabled = false end
   end,
})

MainTab:CreateSlider({
   Name = "Y Offset",
   Range = {0, 100},
   Increment = 1,
   CurrentValue = Settings.YOffset,
   Callback = function(Value) Settings.YOffset = Value end,
})

MainTab:CreateSlider({
   Name = "X Offset",
   Range = {0, 10},
   Increment = 1,
   CurrentValue = Settings.XOffset,
   Callback = function(Value) Settings.XOffset = Value end,
})

local HiveSection = MainTab:CreateSection("Hive")

local HiveLabel = MainTab:CreateLabel("Current Level: 0")

MainTab:CreateToggle({
   Name = "Auto Hive Farm",
   CurrentValue = false,
   Callback = function(Value)
       HiveModule._enabled = Value
   end,
})

do
    local levelLabel = workspace.Map.Chunks.BikiniBottom.ConchStreet.LIGHT_SOURCE.Core.LightSourceBillboard.LightSourceDisplay.Level
    local function updateDisplay()
        if HiveLabel then
            local currentLevel = HiveModule:GetCurrentLevel()
            local maxLevel = HiveModule:GetMaxLevel()
            if HiveModule._enabled then
                HiveLabel:Set("Current Level: " .. currentLevel .. " / " .. maxLevel .. " (Farming)")
            else
                HiveLabel:Set("Current Level: " .. currentLevel .. " / " .. maxLevel)
            end
        end
    end
    updateDisplay()
    MainTrove:Connect(levelLabel:GetPropertyChangedSignal("Text"), function() updateDisplay() end)
end

local GetItems = LPH_JIT_MAX(function()
    local items = {}
    for _, itemData in ipairs(ItemsToolkit.GetAllItems()) do table.insert(items, itemData.ReferenceName) end
    table.sort(items)
    return items
end)

ItemsTab:CreateSection("Item Management")

ItemsTab:CreateDropdown({
   Name = "Select Items to Bring",
   Options = GetItems(),
   CurrentOption = {},
   MultipleOptions = true,
   Callback = function(Options)
       Settings.SelectedBring = {}
       for _, v in ipairs(Options) do Settings.SelectedBring[v] = true end
   end,
})

ItemsTab:CreateButton({
   Name = "Bring All Selected Items",
   Callback = function() ItemModule:BringItems(Settings.SelectedBring) end,
})

ItemsTab:CreateButton({
   Name = "TP Items to Processor",
   Callback = function()
       local selectedItems = {}
       for k, _ in pairs(Settings.SelectedBring) do table.insert(selectedItems, k) end
       if #selectedItems > 0 then ItemModule:TeleportItemsByName(selectedItems, "MaterialProcessor") end
   end,
})

local GetResidents = LPH_JIT_MAX(function()
    local residents = {}
    for _, residentData in pairs(ResidentData) do table.insert(residents, residentData.ReferenceName) end
    table.sort(residents)
    return residents
end)

ItemsTab:CreateSection("Resident Management")

ItemsTab:CreateDropdown({
   Name = "Select Residents",
   Options = GetResidents(),
   CurrentOption = {},
   MultipleOptions = true,
   Callback = function(Options)
       Settings.SelectedResidents = {}
       for _, v in ipairs(Options) do Settings.SelectedResidents[v] = true end
   end,
})

ItemsTab:CreateButton({
   Name = "Bring All Selected Residents",
   Callback = function() ResidentModule:BringResidents(Settings.SelectedResidents) end,
})

ItemsTab:CreateButton({
   Name = "TP Residents to Processor",
   Callback = function()
       local selectedResidents = {}
       for k, _ in pairs(Settings.SelectedResidents) do table.insert(selectedResidents, k) end
       if #selectedResidents > 0 then ResidentModule:TeleportResidentsByName(selectedResidents) end
   end,
})

ItemsTab:CreateLabel("Note: To bring Sandy you need to kill hibernation Sandy first.")

CraftTab:CreateSection("Auto Crafting")

local CraftLabel = CraftTab:CreateLabel("Status: Idle")

function AutoCraftModule:UpdateStatus(text)
    if CraftLabel then CraftLabel:Set(text) end 
end

CraftTab:CreateToggle({
   Name = "Auto Craft Enabled",
   CurrentValue = false,
   Callback = function(Value) Settings.AutoCraftEnabled = Value end,
})

local GetCraftableItems = LPH_JIT_MAX(function()
    local items = {}
    for itemName in pairs(CraftingData) do table.insert(items, itemName) end
    table.sort(items)
    return items
end)

CraftTab:CreateDropdown({
   Name = "Select Items to Craft",
   Options = GetCraftableItems(),
   CurrentOption = {},
   MultipleOptions = true,
   Callback = function(Options)
       Settings.SelectedCraftItems = {}
       for _, v in ipairs(Options) do Settings.SelectedCraftItems[v] = true end
   end,
})

CraftTab:CreateSection("Movement & Utilities")

CraftTab:CreateToggle({
   Name = "Fly Enabled",
   CurrentValue = false,
   Callback = function(Value) Settings.Fly.Enabled = Value end,
})

CraftTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 200},
   Increment = 1,
   CurrentValue = Settings.Fly.Speed,
   Callback = function(Value) Settings.Fly.Speed = Value end,
})

CraftTab:CreateToggle({
   Name = "Walk Speed Enabled",
   CurrentValue = false,
   Callback = function(Value) Settings.WalkSpeed.Enabled = Value end,
})

CraftTab:CreateSlider({
   Name = "Walk Speed Value",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = Settings.WalkSpeed.Speed,
   Callback = function(Value) Settings.WalkSpeed.Speed = Value end,
})

CraftTab:CreateToggle({
   Name = "Auto Eat",
   CurrentValue = false,
   Callback = function(Value)
       Settings.AutoEatEnabled = Value
       if Value and PlayerGui.PlayerAttributesUI.PlayerAttributes.Bars.Hunger.Visible then
           AutoEatModule:TryEat()
       end
   end,
})

CraftTab:CreateToggle({
   Name = "Instant Open Chests",
   CurrentValue = false,
   Callback = function(Value)
       Settings.InstantOpenChests = Value
       ChestModule:SetInstantOpen(Value)
   end,
})

CraftTab:CreateButton({
   Name = "TP to Material Processor",
   Callback = function() TeleportModule:TeleportPlayer("MaterialProcessor") end,
})

CraftTab:CreateSection("System")

CraftTab:CreateButton({
   Name = "Unload Script",
   Callback = function()
       MainTrove:Clean()
       Rayfield:Destroy()
       getgenv().executed = false
       if CoreGui:FindFirstChild("PradaxcaToggle") then
           CoreGui.PradaxcaToggle:Destroy()
       end
   end,
})

local UserInputService = cloneref(game:GetService("UserInputService"))
local CoreGui = cloneref(game:GetService("CoreGui"))

if CoreGui:FindFirstChild("PradaxcaToggle") then
    CoreGui.PradaxcaToggle:Destroy()
end

local PradaxcaUI = Instance.new("ScreenGui")
PradaxcaUI.Name = "PradaxcaToggle"
PradaxcaUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
PradaxcaUI.Parent = CoreGui

local FloatingButton = Instance.new("ImageButton")
FloatingButton.Name = "LogoButton"
FloatingButton.Size = UDim2.new(0, 45, 0, 45)
FloatingButton.Position = UDim2.new(0.02, 0, 0.1, 0)
FloatingButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180) 
FloatingButton.BorderSizePixel = 0
FloatingButton.ClipsDescendants = true
FloatingButton.Parent = PradaxcaUI

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = FloatingButton

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 192, 203)
UIStroke.Thickness = 2
UIStroke.Parent = FloatingButton

local LogoImage = Instance.new("ImageLabel")
LogoImage.Size = UDim2.new(1, 0, 1, 0)
LogoImage.BackgroundTransparency = 1
LogoImage.Image = "rbxassetid://114704837418228" 
LogoImage.Parent = FloatingButton

FloatingButton.MouseButton1Click:Connect(function()
    local VirtualInputManager = game:GetService("VirtualInputManager")
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.K, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.K, false, game)
end)

local dragging, dragInput, dragStart, startPos

FloatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatingButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

FloatingButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        TweenService:Create(FloatingButton, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        }):Play()
    end
end)

Rayfield:LoadConfiguration()