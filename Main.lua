-- ========================================================
-- GROW A GARDEN AUTO FARM + KEY SYSTEM (OWNER ONLY)
-- ========================================================

local player = game:GetService("Players").LocalPlayer
local httpService = game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

-- ===== CẤU HÌNH =====
local KEY = "ABC123XYZ789"  -- 👈 THAY KEY CỦA BẠN VÀO ĐÂY
local PASSWORD = "abc123xyz" -- 👈 THAY MẬT KHẨU CỦA BẠN VÀO ĐÂY

local verified = false

-- ===== TẠO GUI XÁC THỰC =====
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KeySystem"
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = player.PlayerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 320)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -160)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    title.BackgroundTransparency = 0
    title.Text = "🔐 XÁC THỰC KEY"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame

    -- Key
    local keyLabel = Instance.new("TextLabel")
    keyLabel.Size = UDim2.new(1, 0, 0, 25)
    keyLabel.Position = UDim2.new(0, 0, 0.2, 0)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Text = "📌 NHẬP KEY:"
    keyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    keyLabel.TextSize = 14
    keyLabel.Font = Enum.Font.Gotham
    keyLabel.Parent = mainFrame

    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(0.8, 0, 0, 35)
    keyBox.Position = UDim2.new(0.1, 0, 0.3, 0)
    keyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyBox.TextSize = 16
    keyBox.Font = Enum.Font.Gotham
    keyBox.PlaceholderText = "Nhập key..."
    keyBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    keyBox.ClearTextOnFocus = false
    keyBox.Parent = mainFrame

    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 8)
    corner2.Parent = keyBox

    -- Password
    local passLabel = Instance.new("TextLabel")
    passLabel.Size = UDim2.new(1, 0, 0, 25)
    passLabel.Position = UDim2.new(0, 0, 0.5, 0)
    passLabel.BackgroundTransparency = 1
    passLabel.Text = "🔒 NHẬP MẬT KHẨU:"
    passLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    passLabel.TextSize = 14
    passLabel.Font = Enum.Font.Gotham
    passLabel.Parent = mainFrame

    local passBox = Instance.new("TextBox")
    passBox.Size = UDim2.new(0.8, 0, 0, 35)
    passBox.Position = UDim2.new(0.1, 0, 0.6, 0)
    passBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    passBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    passBox.TextSize = 16
    passBox.Font = Enum.Font.Gotham
    passBox.PlaceholderText = "Nhập mật khẩu..."
    passBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    passBox.ClearTextOnFocus = false
    passBox.Parent = mainFrame

    local corner3 = Instance.new("UICorner")
    corner3.CornerRadius = UDim.new(0, 8)
    corner3.Parent = passBox

    -- Verify Button
    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(0.4, 0, 0, 40)
    verifyBtn.Position = UDim2.new(0.3, 0, 0.8, 0)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    verifyBtn.Text = "✅ XÁC THỰC"
    verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    verifyBtn.TextSize = 16
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.Parent = mainFrame

    local corner4 = Instance.new("UICorner")
    corner4.CornerRadius = UDim.new(0, 8)
    corner4.Parent = verifyBtn

    -- Status
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0, 30)
    statusLabel.Position = UDim2.new(0, 0, 0.9, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "⏳ Vui lòng nhập key và mật khẩu"
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    statusLabel.TextSize = 13
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = mainFrame

    -- ===== XỬ LÝ XÁC THỰC =====
    verifyBtn.MouseButton1Click:Connect(function()
        local key = keyBox.Text
        local password = passBox.Text
        
        if key == "" or password == "" then
            statusLabel.Text = "❌ Vui lòng nhập đầy đủ!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        -- Kiểm tra key (cứng)
        if key == KEY and password == PASSWORD then
            statusLabel.Text = "✅ XÁC THỰC THÀNH CÔNG!"
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            verified = true
            
            task.wait(1)
            screenGui:Destroy()
            startFarm()
        else
            statusLabel.Text = "❌ Sai key hoặc mật khẩu!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
end

-- ===== SCRIPT FARM =====
local function startFarm()
    print("🌱 GROW A GARDEN AUTO FARM")
    print("✅ Đã xác thực thành công!")

    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    local settings = {
        AutoPlant = true,
        AutoHarvest = true,
        AutoSell = true,
        AutoWater = true,
        WaitTime = 1.5
    }

    local function findPlots()
        local t = {}
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name:find("Plot") then
                table.insert(t, v)
            end
        end
        return t
    end

    local function findSeeds()
        local t = {}
        for _, v in pairs(player.Backpack:GetChildren()) do
            if v:IsA("Tool") and v.Name:find("Seed") then
                table.insert(t, v)
            end
        end
        return t
    end

    local function getAvailableSlot(plot)
        for i = 1, 4 do
            local slot = plot:FindFirstChild("Slot"..i)
            if slot and not slot:FindFirstChild("Plant") then
                return slot
            end
        end
        return nil
    end

    local function getHarvestableSlots(plot)
        local t = {}
        for i = 1, 4 do
            local slot = plot:FindFirstChild("Slot"..i)
            if slot then
                local plant = slot:FindFirstChild("Plant")
                if plant and plant:FindFirstChild("Harvestable") and plant.Harvestable.Value == true then
                    table.insert(t, slot)
                end
            end
        end
        return t
    end

    local function autoPlant()
        if not settings.AutoPlant then return end
        local plots = findPlots()
        local seeds = findSeeds()
        if #seeds == 0 then return end
        for _, plot in pairs(plots) do
            local slot = getAvailableSlot(plot)
            if slot and #seeds > 0 then
                if plot.PrimaryPart then
                    root.CFrame = plot.PrimaryPart.CFrame + Vector3.new(0, 0, 3)
                    task.wait(0.3)
                end
                seeds[1].Parent = slot
                task.wait(settings.WaitTime)
                table.remove(seeds, 1)
            end
        end
    end

    local function autoHarvest()
        if not settings.AutoHarvest then return end
        local plots = findPlots()
        for _, plot in pairs(plots) do
            local slots = getHarvestableSlots(plot)
            for _, slot in pairs(slots) do
                local plant = slot:FindFirstChild("Plant")
                if plant then
                    if plot.PrimaryPart then
                        root.CFrame = plot.PrimaryPart.CFrame + Vector3.new(0, 0, 3)
                        task.wait(0.3)
                    end
                    local ev = replicatedStorage:FindFirstChild("HarvestPlant")
                    if ev then
                        ev:FireServer(plant)
                        task.wait(settings.WaitTime)
                    end
                end
            end
        end
    end

    local function autoSell()
        if not settings.AutoSell then return end
        local ev = replicatedStorage:FindFirstChild("SellAll")
        if ev then
            ev:FireServer()
        end
    end

    local function autoWater()
        if not settings.AutoWater then return end
        local plots = findPlots()
        for _, plot in pairs(plots) do
            for i = 1, 4 do
                local slot = plot:FindFirstChild("Slot"..i)
                if slot then
                    local plant = slot:FindFirstChild("Plant")
                    if plant and plant:FindFirstChild("WaterLevel") then
                        if plant.WaterLevel.Value < 50 then
                            local ev = replicatedStorage:FindFirstChild("WaterPlant")
                            if ev then
                                ev:FireServer(plant)
                                task.wait(0.5)
                            end
                        end
                    end
                end
            end
        end
    end

    coroutine.wrap(function()
        while true do
            autoHarvest()
            autoPlant()
            autoWater()
            autoSell()
            task.wait(2)
        end
    end)()
end

-- ===== CHẠY SCRIPT =====
print("🔐 KEY SYSTEM - OWNER ONLY")
print("📌 Vui lòng nhập key để xác thực")
createGUI()
