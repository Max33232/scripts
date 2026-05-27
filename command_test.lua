--[[
    Build A Boat For Treasure - AUTO FARM SCRIPT (БЕЗ ЗАДЕРЖКИ ПОСЛЕ СМЕРТИ)
    Функции: Auto Farm, Auto Click, Fly, Invisible
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("FarmGui") then
    playerGui.FarmGui:Destroy()
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FarmGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.18, 0, 0.38, 0)
frame.Position = UDim2.new(0.85, 0, 0.78, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundTransparency = 1
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.ZIndex = 2
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)

-- Background Image
local bgImage = Instance.new("ImageLabel")
bgImage.Name = "BackgroundImage"
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Position = UDim2.new(0, 0, 0, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = "rbxassetid://9764700798"
bgImage.ScaleType = Enum.ScaleType.Fit
bgImage.ZIndex = 1
bgImage.Parent = frame
Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 15)

-- Shadow
local shadow = Instance.new("ImageLabel")
shadow.BackgroundTransparency = 1
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.Position = UDim2.new(0.5, 0, 0.5, 10)
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Image = "rbxassetid://5028857084"
shadow.ImageTransparency = 0.4
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(24, 24, 276, 276)
shadow.ZIndex = 0
shadow.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Text = "Build A Boat AUTO FARM"
title.Size = UDim2.new(1, 0, 0.14, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextStrokeTransparency = 0.6
title.ZIndex = 4
title.Parent = frame

-- Underline
local underline = Instance.new("Frame")
underline.Size = UDim2.new(0.9, 0, 0.01, 0)
underline.Position = UDim2.new(0.5, 0, 0.17, 0)
underline.AnchorPoint = Vector2.new(0.5, 0)
underline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
underline.BorderSizePixel = 0
underline.ZIndex = 4
underline.Parent = frame

-- Button Creator
local function makeButton(text, order, color)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(0.95, 0, 0.13, 0)
    holder.Position = UDim2.new(0.5, 0, 0.22 + (order * 0.16), 0)
    holder.AnchorPoint = Vector2.new(0.5, 0)
    holder.BackgroundTransparency = 1
    holder.ZIndex = 3
    holder.Parent = frame

    local glow = Instance.new("UIStroke")
    glow.Color = color
    glow.Thickness = 2
    glow.Transparency = 0.4
    glow.Parent = holder

    TweenService:Create(
        glow,
        TweenInfo.new(1.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Transparency = 0.1}
    ):Play()

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = text
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.BackgroundColor3 = color
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.ZIndex = 4
    button.Parent = holder
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)

    if color == Color3.fromRGB(255,221,0) then
        button.TextColor3 = Color3.fromRGB(0,0,0)
    end

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
            Size = UDim2.new(1.05,0,1.05,0),
            BackgroundColor3 = color:Lerp(Color3.fromRGB(0,0,0), 0.15)
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
            Size = UDim2.new(1,0,1,0),
            BackgroundColor3 = color
        }):Play()
    end)

    return button
end

-- Buttons
local farmBtn = makeButton("🚀 AUTO FARM", 0, Color3.fromRGB(0,0,0))
local autoClickBtn = makeButton("🖱️ AUTO CLICK", 1, Color3.fromRGB(50,50,50))
local flyBtn = makeButton("🕊️ FLY", 2, Color3.fromRGB(255,221,0))
local invisBtn = makeButton("👻 INVISIBLE", 3, Color3.fromRGB(138,43,226))

--------------------------------------------------
-- ПОЗИЦИИ ДЛЯ ФАРМА
--------------------------------------------------
local positions = {
    Vector3.new(-40, 35, 1371),   -- Stage 1
    Vector3.new(-61, 33, 2140),   -- Stage 2
    Vector3.new(-76, 41, 2909),   -- Stage 3
    Vector3.new(-87, 42, 3678),   -- Stage 4
    Vector3.new(-41, 48, 4450),   -- Stage 5
    Vector3.new(-88, 54, 5220),   -- Stage 6
    Vector3.new(-63, 49, 5990),   -- Stage 7
    Vector3.new(-83, 63, 6759),   -- Stage 8
    Vector3.new(-64, 51, 7530),   -- Stage 9
    Vector3.new(-99, 49, 8298),   -- Stage 10
    Vector3.new(-120, 179, 9132), -- Stage 11
    Vector3.new(-56, -359, 9496)  -- Stage 12 (portal)
}

--------------------------------------------------
-- AUTO FARM (БЕЗ ЗАДЕРЖКИ ПОСЛЕ СМЕРТИ)
--------------------------------------------------
local teleporting = false
local noclipConn, antiFallBV
local farmCoroutine = nil
local waitingForRespawn = false

local function enableNoclip()
    noclipConn = RunService.Stepped:Connect(function()
        local char = player.Character
        if char then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end
        end
    end)
end

local function disableNoclip()
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
end

local function preventFalling(hrp)
    if antiFallBV then antiFallBV:Destroy() end
    antiFallBV = Instance.new("BodyVelocity")
    antiFallBV.MaxForce = Vector3.new(0, math.huge, 0)
    antiFallBV.Velocity = Vector3.new(0, 0, 0)
    antiFallBV.Parent = hrp
end

local function allowFalling()
    if antiFallBV then
        antiFallBV:Destroy()
        antiFallBV = nil
    end
end

-- Auto Click
local autoClickEnabled = false
local clickConnection = nil

local function startAutoClick()
    if clickConnection then return end
    autoClickEnabled = true
    clickConnection = RunService.Heartbeat:Connect(function()
        if autoClickEnabled then
            local args = { [1] = { [1] = "Click", [2] = {} } }
            pcall(function()
                ReplicatedStorage:WaitForChild("Build"):FireServer(unpack(args))
            end)
        end
    end)
end

local function stopAutoClick()
    autoClickEnabled = false
    if clickConnection then
        clickConnection:Disconnect()
        clickConnection = nil
    end
end

-- Ожидание респавна персонажа (без задержки)
local function waitForRespawn()
    waitingForRespawn = true
    
    -- Если персонаж мертв или его нет
    if not player.Character or not player.Character.Parent then
        -- Ждем пока персонаж появится (минимальная задержка для загрузки)
        local char = player.CharacterAdded:Wait()
        -- Минимальная задержка для загрузки
        task.wait(0.05)
        -- Получаем HumanoidRootPart
        local hrp = char:WaitForChild("HumanoidRootPart")
        -- Телепортируем на первый чекпоинт
        hrp.CFrame = CFrame.new(positions[1])
        task.wait(0.05)
    end
    
    waitingForRespawn = false
end

-- Farm функция
local function runFarm()
    while teleporting do
        -- Проверяем жив ли персонаж
        local char = player.Character
        local isAlive = false
        
        if char and char.Parent then
            local humanoid = char:FindFirstChildWhichIsA("Humanoid")
            if humanoid and humanoid.Health > 0 then
                isAlive = true
            end
        end
        
        -- Если персонаж мертв, респавним мгновенно
        if not isAlive then
            if not waitingForRespawn then
                waitForRespawn()
            end
            -- Получаем свежего персонажа
            char = player.Character
            if not char or not char.Parent then
                task.wait(0.05)
                char = player.Character
            end
        end
        
        -- Если персонаж есть и жив, продолжаем фарм
        if char and char.Parent then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                enableNoclip()
                preventFalling(hrp)
                
                for _, pos in ipairs(positions) do
                    if not teleporting then break end
                    
                    -- Проверка на смерть во время фарма
                    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
                    if humanoid and humanoid.Health <= 0 then
                        break
                    end
                    
                    pcall(function()
                        TweenService:Create(hrp, TweenInfo.new(2, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)}):Play()
                    end)
                    task.wait(2)
                end
                
                allowFalling()
                disableNoclip()
            end
        end
        
        task.wait(15)
    end
end

-- Farm Toggle
farmBtn.MouseButton1Click:Connect(function()
    teleporting = not teleporting
    farmBtn.Text = teleporting and "⏹️ STOP FARM" or "🚀 AUTO FARM"
    farmBtn.BackgroundColor3 = teleporting and Color3.fromRGB(200,50,50) or Color3.fromRGB(0,0,0)

    if teleporting then
        if farmCoroutine then task.cancel(farmCoroutine) end
        farmCoroutine = task.spawn(runFarm)
    else
        if farmCoroutine then task.cancel(farmCoroutine) end
        allowFalling()
        disableNoclip()
        waitingForRespawn = false
    end
end)

-- Auto Click Toggle
autoClickBtn.MouseButton1Click:Connect(function()
    if autoClickEnabled then
        stopAutoClick()
        autoClickBtn.Text = "🖱️ AUTO CLICK"
        autoClickBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    else
        startAutoClick()
        autoClickBtn.Text = "✅ AUTO CLICK ON"
        autoClickBtn.BackgroundColor3 = Color3.fromRGB(0,150,0)
    end
end)

--------------------------------------------------
-- FLY
--------------------------------------------------
local flying = false
local flyBodyVelocity = nil
local flyBodyGyro = nil
local flyConnection = nil

local function startFly(speed)
    if flying then stopFly() end
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    flying = true
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = rootPart
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyGyro.Parent = rootPart
    
    local moveDirection = Vector3.new(0, 0, 0)
    
    local function updateFly()
        if not flying or not rootPart or not rootPart.Parent then
            stopFly()
            return
        end
        
        local camera = workspace.CurrentCamera
        moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, speed, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection - Vector3.new(0, speed, 0)
        end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * speed
        end
        
        flyBodyVelocity.Velocity = moveDirection
        flyBodyGyro.CFrame = camera.CFrame
        if humanoid then humanoid.PlatformStand = true end
    end
    
    flyConnection = RunService.RenderStepped:Connect(updateFly)
end

local function stopFly()
    flying = false
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildWhichIsA("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end
end

flyBtn.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
        flyBtn.Text = "🕊️ FLY"
        flyBtn.BackgroundColor3 = Color3.fromRGB(255,221,0)
    else
        startFly(50)
        flyBtn.Text = "❌ UNFLY"
        flyBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    end
end)

--------------------------------------------------
-- INVISIBLE
--------------------------------------------------
local invisible = false
local invisConnection = nil

local function setInvisible(state)
    local char = player.Character
    if not char then return end
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
            p.Transparency = state and 1 or 0
        end
    end
end

local function startInvisible()
    if invisConnection then return end
    invisConnection = RunService.Heartbeat:Connect(function()
        if invisible then
            setInvisible(true)
        end
    end)
end

local function stopInvisible()
    if invisConnection then
        invisConnection:Disconnect()
        invisConnection = nil
    end
    setInvisible(false)
end

invisBtn.MouseButton1Click:Connect(function()
    invisible = not invisible
    if invisible then
        startInvisible()
        invisBtn.Text = "👻 VISIBLE"
        invisBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    else
        stopInvisible()
        invisBtn.Text = "👻 INVISIBLE"
        invisBtn.BackgroundColor3 = Color3.fromRGB(138,43,226)
    end
end)

-- Cleanup on character death
player.CharacterAdded:Connect(function()
    if flying then
        stopFly()
        flyBtn.Text = "🕊️ FLY"
        flyBtn.BackgroundColor3 = Color3.fromRGB(255,221,0)
        flying = false
    end
    if invisible then
        invisible = false
        stopInvisible()
        invisBtn.Text = "👻 INVISIBLE"
        invisBtn.BackgroundColor3 = Color3.fromRGB(138,43,226)
    end
end)

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Build A Boat Auto Farm",
    Text = "Script loaded! После смерти фарм продолжается мгновенно",
    Duration = 4
})
