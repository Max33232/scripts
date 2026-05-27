-- TELEKINESIS С FLUENT МЕНЮ (БЕЗ ПАРОЛЯ) - АВТОР: TEST

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- УДАЛЯЕМ СТАРЫЙ ИНСТРУМЕНТ
if localPlayer.Backpack:FindFirstChild("telekinesis pm") then
    localPlayer.Backpack["telekinesis pm"]:Destroy()
end

-- СОЗДАНИЕ ИНСТРУМЕНТА
local tool = Instance.new("Tool")
tool.Name = "telekinesis pm"
tool.RequiresHandle = false

local selectedPart = nil
local following = false
local bv = nil
local selectionBox = Instance.new("SelectionBox")
selectionBox.LineThickness = 0.1
selectionBox.Color3 = Color3.fromRGB(255, 255, 0)

-- ФУНКЦИЯ ПОИСКА БЛОКА
local function getTarget()
    local char = localPlayer.Character
    if not char then return nil end
    local mousePos = UserInputService:GetMouseLocation()
    local ray = camera:ScreenPointToRay(mousePos.X, mousePos.Y)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {char}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(ray.Origin, ray.Direction * 100, params)
    if result and result.Instance and result.Instance:IsA("BasePart") and not result.Instance.Anchored and not result.Instance:IsDescendantOf(char) then
        return result.Instance
    end
    return nil
end

-- ПОДНЯТЬ БЛОК
local function pickUp(part)
    selectedPart = part
    following = true
    selectionBox.Adornee = selectedPart
    selectedPart.CanCollide = false
    
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Parent = selectedPart
    
    RunService.RenderStepped:Connect(function()
        if not following or not selectedPart or not selectedPart.Parent then
            if bv then bv:Destroy() end
            if selectedPart then selectedPart.CanCollide = true end
            following = false
            selectionBox.Adornee = nil
            return
        end
        local mousePos = UserInputService:GetMouseLocation()
        local ray = camera:ScreenPointToRay(mousePos.X, mousePos.Y)
        local targetPos = ray.Origin + ray.Direction * 10
        bv.Velocity = (targetPos - selectedPart.Position) * 12
    end)
end

-- БРОСИТЬ
local function throwPart()
    if selectedPart then
        if bv then bv:Destroy() end
        selectedPart.CanCollide = true
        selectedPart.Velocity = camera.CFrame.LookVector * 150
        selectedPart = nil
        following = false
        selectionBox.Adornee = nil
    end
end

-- АКТИВАЦИЯ ИНСТРУМЕНТА
tool.Activated:Connect(function()
    if following then
        throwPart()
    else
        local target = getTarget()
        if target then
            pickUp(target)
        end
    end
end)

tool.Unequipped:Connect(function()
    if following then
        if bv then bv:Destroy() end
        if selectedPart then selectedPart.CanCollide = true end
        following = false
        selectionBox.Adornee = nil
        selectedPart = nil
    end
end)

tool.Parent = localPlayer.Backpack

-- СОЗДАНИЕ FLUENT МЕНЮ
local Window = Fluent:CreateWindow({
    Title = "Telekinesis Control",
    SubTitle = "by TEST",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightAlt
})

local Tabs = {
    Main = Window:AddTab({ Title = "Управление", Icon = "hand" }),
    Settings = Window:AddTab({ Title = "Настройки", Icon = "settings" })
}

local followSpeed = 12
local throwForce = 150

Tabs.Main:AddToggle("Toggle", {
    Title = "Вкл/Выкл Телекинез",
    Description = "Включает или отключает инструмент",
    Default = true,
    Callback = function(Value)
        if Value then
            tool.Parent = localPlayer.Backpack
        else
            if following then throwPart() end
            tool.Parent = nil
        end
    end
})

Tabs.Main:AddSlider("Speed", {
    Title = "Скорость следования",
    Description = "Скорость движения блока",
    Default = 12,
    Min = 5,
    Max = 30,
    Rounding = 1,
    Callback = function(Value)
        followSpeed = Value
    end
})

Tabs.Main:AddSlider("Throw", {
    Title = "Сила броска",
    Description = "Скорость броска блока",
    Default = 150,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        throwForce = Value
    end
})

Tabs.Main:AddButton({
    Title = "Обновить инструмент",
    Description = "Пересоздать инструмент в инвентаре",
    Callback = function()
        if tool then tool:Destroy() end
        local newTool = Instance.new("Tool")
        newTool.Name = "telekinesis pm"
        newTool.RequiresHandle = false
        newTool.Parent = localPlayer.Backpack
        tool = newTool
        Fluent:Notify({Title = "Инструмент", Content = "Пересоздан", Duration = 2})
    end
})

Tabs.Settings:AddKeybind("MenuKey", {
    Title = "Клавиша меню",
    Description = "Открыть/закрыть меню",
    Default = Enum.KeyCode.RightAlt,
    Callback = function()
        Window:Toggle()
    end
})

Tabs.Settings:AddButton({
    Title = "Уничтожить меню",
    Description = "Закрыть меню и удалить GUI",
    Callback = function()
        Window:Destroy()
    end
})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetFolder("Telekinesis")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

SaveManager:LoadAutoloadConfig()
Window:SelectTab(1)

Fluent:Notify({
    Title = "Telekinesis",
    Content = "Инструмент в инвентаре! Нажми ЛКМ на блок",
    Duration = 4
})
