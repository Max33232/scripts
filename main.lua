-- COMMAND TEST ADMIN SCRIPT (АВТОР: TEST)

-- ОСНОВНОЕ МЕНЮ
local gui = Instance.new("ScreenGui")
gui.Name = "CommandTest"
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 500, 0, 400)
frame.Position = UDim2.new(0.5, -250, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Command Test by TEST"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Parent = scroll
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 5)

-- ФУНКЦИЯ СОЗДАНИЯ КНОПКИ
local function addButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = scroll
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ФУНКЦИЯ СОЗДАНИЯ ТЕКСТОВОГО ПОЛЯ
local function addTextBox(placeholder, callback)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, 35)
    box.PlaceholderText = placeholder
    box.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.Parent = scroll
    box.FocusLost:Connect(callback)
    return box
end

-- ==================== КОМАНДЫ ====================

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- ТЕЛЕКИНЕЗ
addButton("TELEKINESIS (ИНСТРУМЕНТ)", Color3.fromRGB(100, 100, 200), function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Max33232/scripts/main/main.lua"))()
end)

-- ФЛИНГ ИГРОКА
local targetBox = addTextBox("Имя игрока для флинга", function()
    local target = Players:FindFirstChild(targetBox.Text)
    if target and target.Character then
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(math.random(-1000, 1000), 500, math.random(-1000, 1000))
            bv.Parent = hrp
            task.wait(1)
            bv:Destroy()
        end
    end
end)
targetBox.PlaceholderText = "Введи имя игрока"

-- ТЕЛЕПОРТ К ИГРОКУ
local tpBox = addTextBox("Имя игрока для телепорта", function()
    local target = Players:FindFirstChild(tpBox.Text)
    if target and target.Character then
        local char = localPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local thrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp and thrp then
                hrp.CFrame = thrp.CFrame + Vector3.new(3, 0, 3)
            end
        end
    end
end)
tpBox.PlaceholderText = "Введи имя игрока"

-- ЗАМОРОЗКА
local freezeBox = addTextBox("Имя игрока для заморозки", function()
    local target = Players:FindFirstChild(freezeBox.Text)
    if target and target.Character then
        local hum = target.Character:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = 0
            hum.JumpPower = 0
        end
    end
end)
freezeBox.PlaceholderText = "Введи имя игрока"

-- РАЗМОРОЗКА
addButton("РАЗМОРОЗИТЬ ВСЕХ", Color3.fromRGB(100, 150, 100), function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local hum = player.Character:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = 16
                hum.JumpPower = 50
            end
        end
    end
end)

-- ИЗМЕНЕНИЕ СКОРОСТИ
local speedBox = addTextBox("Скорость (16-300)", function()
    local speed = tonumber(speedBox.Text)
    if speed then
        speed = math.clamp(speed, 16, 300)
        local char = localPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = speed
            end
        end
    end
end)
speedBox.PlaceholderText = "Введи скорость (16-300)"

-- ИЗМЕНЕНИЕ ПРЫЖКА
local jumpBox = addTextBox("Прыжок (50-500)", function()
    local jump = tonumber(jumpBox.Text)
    if jump then
        jump = math.clamp(jump, 50, 500)
        local char = localPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.JumpPower = jump
            end
        end
    end
end)
jumpBox.PlaceholderText = "Введи силу прыжка (50-500)"

-- НОКЛИП
local noclipEnabled = false
addButton("НОКЛИП (ВКЛ/ВЫКЛ)", Color3.fromRGB(150, 100, 100), function()
    noclipEnabled = not noclipEnabled
    game:GetService("RunService").Stepped:Connect(function()
        if noclipEnabled then
            local char = localPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end)

-- ПОЛЁТ
local flying = false
local bv = nil
addButton("ПОЛЁТ (ВКЛ/ВЫКЛ)", Color3.fromRGB(100, 150, 200), function()
    flying = not flying
    local char = localPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if flying then
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Parent = hrp
        game:GetService("RunService").RenderStepped:Connect(function()
            if not flying or not bv then return end
            local uis = game:GetService("UserInputService")
            local dir = Vector3.new(0, 0, 0)
            local cam = workspace.CurrentCamera
            if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if uis:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
            bv.Velocity = dir * 60
        end)
    else
        if bv then bv:Destroy() end
    end
end)

-- КНОПКА ЗАКРЫТИЯ МЕНЮ
addButton("ЗАКРЫТЬ МЕНЮ", Color3.fromRGB(200, 50, 50), function()
    gui:Destroy()
end)

-- ПЕРЕТАСКИВАНИЕ GUI
local dragging = false
local dragStart, framePos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        framePos = frame.Position
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- СООБЩЕНИЕ
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Command Test",
    Text = "Меню загружено! Нажми X чтобы закрыть",
    Duration = 4
})
