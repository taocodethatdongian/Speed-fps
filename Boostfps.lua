--[[
    ============================================================
    ANTI-LAG & PERFORMANCE HUB (FINAL PRODUCTION VERSION)
    - Tác giả: Học viên & Góp ý chuyên sâu từ Giảng viên
    - Tính năng: Giám sát FPS, Ping, RAM & Tối ưu đồ họa an toàn
    ============================================================
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then 
    warn("[AntiLagHub]: Không tìm thấy LocalPlayer trong môi trường hiện tại!")
    return 
end

local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
if not PlayerGui then 
    warn("[AntiLagHub]: Không tìm thấy PlayerGui trong thời gian cho phép!")
    return 
end

-- ==========================================
-- BƯỚC 1: HỦY BỎ TÁC VỤ & DỌN DẸP KẾT NỐI CŨ
-- ==========================================
if _G.StopPerformanceLoop then
    pcall(_G.StopPerformanceLoop)
end

if _G.PerformanceConnections then
    for _, conn in ipairs(_G.PerformanceConnections) do
        if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        end
    end
end
_G.PerformanceConnections = {}

if PlayerGui:FindFirstChild("AdvancedPerformanceHub") then
    PlayerGui.AdvancedPerformanceHub:Destroy()
end

-- ==========================================
-- BƯỚC 2: TỐI ƯU HÓA ĐỒ HỌA AN TOÀN (KHÔNG PHÁ VỠ VẬT LÝ GAME)
-- ==========================================
pcall(function()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 2
    
    if Terrain then
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveTransparency = 1
        Terrain.WaterReflectance = 0
    end
end)

-- Khởi tạo ScreenGui gốc
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedPerformanceHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui

-- ==========================================
-- PHẦN 3: HIỂN THỊ FPS GÓC TRÊN TRÁI
-- ==========================================
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0, 120, 0, 30)
fpsLabel.Position = UDim2.new(0, 15, 0, 15)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
fpsLabel.TextSize = 16
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Text = "FPS: --"
fpsLabel.ZIndex = 10
fpsLabel.Parent = screenGui

local lastUpdate = 0
local frameCount = 0
local fpsConn = RunService.RenderStepped:Connect(function(dt)
    frameCount = frameCount + 1
    lastUpdate = lastUpdate + dt
    if lastUpdate >= 0.5 then
        local fps = math.floor(frameCount / lastUpdate)
        fpsLabel.Text = "FPS: " .. fps
        frameCount = 0
        lastUpdate = 0
    end
end)
table.insert(_G.PerformanceConnections, fpsConn)

-- ==========================================
-- PHẦN 4: NÚT TIA CHỚP GÓC TRÊN PHẢI
-- ==========================================
local lightningBtn = Instance.new("TextButton")
lightningBtn.Size = UDim2.new(0, 45, 0, 45)
lightningBtn.Position = UDim2.new(1, -60, 0, 15)
lightningBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
lightningBtn.TextColor3 = Color3.fromRGB(255, 220, 0)
lightningBtn.Text = "⚡"
lightningBtn.TextSize = 24
lightningBtn.Font = Enum.Font.GothamBold
lightningBtn.ZIndex = 10
lightningBtn.Parent = screenGui

local cornerBtn = Instance.new("UICorner")
cornerBtn.CornerRadius = UDim.new(0, 10)
cornerBtn.Parent = lightningBtn

local strokeBtn = Instance.new("UIStroke")
strokeBtn.Color = Color3.fromRGB(255, 220, 0)
strokeBtn.Thickness = 2
strokeBtn.Parent = lightningBtn

-- ==========================================
-- PHẦN 5: BẢNG GIAO DIỆN CHÍNH (CHUẨN BỐ CỤC)
-- ==========================================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 310, 0, 175)
mainFrame.Position = UDim2.new(1, -330, 0, 70)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Visible = false
mainFrame.ZIndex = 5
mainFrame.Parent = screenGui

local cornerFrame = Instance.new("UICorner")
cornerFrame.CornerRadius = UDim.new(0, 12)
cornerFrame.Parent = mainFrame

local strokeFrame = Instance.new("UIStroke")
strokeFrame.Color = Color3.fromRGB(255, 220, 0)
strokeFrame.Thickness = 1.5
strokeFrame.Parent = mainFrame

-- Tiêu đề đặt độc lập (tránh lỗi UIListLayout)
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleLabel.TextColor3 = Color3.fromRGB(255, 220, 0)
titleLabel.Text = "⚡ Anti-Lag & Performance Hub"
titleLabel.TextSize = 13
titleLabel.Font = Enum.Font.GothamBold
titleLabel.ZIndex = 6
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

-- Vùng chứa danh sách thông tin dùng UIListLayout an toàn
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -28, 1, -45)
contentContainer.Position = UDim2.new(0, 14, 0, 42)
contentContainer.BackgroundTransparency = 1
contentContainer.ZIndex = 6
contentContainer.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = contentContainer

-- Dòng Ping
local pingLbl = Instance.new("TextLabel")
pingLbl.Size = UDim2.new(1, 0, 0, 20)
pingLbl.BackgroundTransparency = 1
pingLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
pingLbl.TextSize = 12
pingLbl.Font = Enum.Font.Gotham
pingLbl.TextXAlignment = Enum.TextXAlignment.Left
pingLbl.Text = "📶 Ping: Đang cập nhật..."
pingLbl.LayoutOrder = 1
pingLbl.ZIndex = 6
pingLbl.Parent = contentContainer

-- Dòng RAM
local memoryLbl = Instance.new("TextLabel")
memoryLbl.Size = UDim2.new(1, 0, 0, 20)
memoryLbl.BackgroundTransparency = 1
memoryLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
memoryLbl.TextSize = 12
memoryLbl.Font = Enum.Font.Gotham
memoryLbl.TextXAlignment = Enum.TextXAlignment.Left
memoryLbl.Text = "💾 RAM: Đang cập nhật..."
memoryLbl.LayoutOrder = 2
memoryLbl.ZIndex = 6
memoryLbl.Parent = contentContainer

-- Dòng Trạng thái
local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, 0, 0, 20)
statusLbl.BackgroundTransparency = 1
statusLbl.TextColor3 = Color3.fromRGB(0, 255, 128)
statusLbl.TextSize = 12
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.Text = "💻 Tối ưu hóa: Hoạt động hoàn hảo"
statusLbl.LayoutOrder = 3
statusLbl.ZIndex = 6
statusLbl.Parent = contentContainer

-- Chữ ký
local secretSign = Instance.new("TextLabel")
secretSign.Size = UDim2.new(1, 0, 0, 18)
secretSign.BackgroundTransparency = 1
secretSign.TextColor3 = Color3.fromRGB(120, 120, 120)
secretSign.TextSize = 10
secretSign.Font = Enum.Font.GothamItalic
secretSign.TextXAlignment = Enum.TextXAlignment.Right
secretSign.Text = "Optimized & Refined"
secretSign.LayoutOrder = 4
secretSign.ZIndex = 6
secretSign.Parent = contentContainer

-- Sự kiện Bật/Tắt Menu
local clickConn = lightningBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)
table.insert(_G.PerformanceConnections, clickConn)

-- ==========================================
-- PHẦN 6: VÒNG LẶP NỀN (CÓ CƠ CHẾ HỦY AN TOÀN & KIỂM TRA KIỂU DỮ LIỆU)
-- ==========================================
local isLoopActive = true
_G.StopPerformanceLoop = function()
    isLoopActive = false
end

task.spawn(function()
    while isLoopActive and screenGui and screenGui.Parent do
        pcall(function()
            if mainFrame.Visible then
                -- Đọc Ping an toàn
                local successPing, pingResult = pcall(function()
                    return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                end)
                if successPing and pingResult and typeof(pingResult) == "number" then
                    pingLbl.Text = "📶 Ping: " .. math.floor(pingResult) .. " ms"
                else
                    pingLbl.Text = "📶 Ping: Không khả dụng"
                end

                -- Đọc RAM an toàn
                local successMem, memResult = pcall(function()
                    return Stats:GetTotalMemoryUsageMb()
                end)
                if successMem and memResult and typeof(memResult) == "number" then
                    memoryLbl.Text = "💾 RAM: " .. math.floor(memResult) .. " MB"
                else
                    memoryLbl.Text = "💾 RAM: Không khả dụng"
                end
            end
        end)
        task.wait(1)
    end
end)
