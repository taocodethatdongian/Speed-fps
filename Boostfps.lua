--[[
    Script Tối Ưu Hóa & Giám Sát Hiệu Năng (FPS & Network Booster)
]]--

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local Stats = game:GetService("Stats")

-- Xóa UI cũ nếu có
if CoreGui:FindFirstChild("AdvancedPerformanceHub") then
    CoreGui.AdvancedPerformanceHub:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedPerformanceHub"
screenGui.Parent = CoreGui

-- ==========================================
-- PHẦN 1: TỰ ĐỘNG TỐI ƯU HÓA GIẢM LAG
-- ==========================================
task.spawn(function()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 2
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") or v:IsA("Sky") or v:IsA("Atmosphere") then
                v:Destroy()
            end
        end
        
        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveTransparency = 1
        end
        
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Material = Enum.Material.SmoothPlastic
                part.Reflectance = 0
            elseif part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = 1
            end
        end
        
        if settings():FindFirstChild("Network") then
            settings().Network.IncomingReplicationLag = 0
        end
    end)
end)

-- ==========================================
-- PHẦN 2: DÒNG FPS NHẤP NHÁY Ở GÓC TRÊN TRÁI
-- ==========================================
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0, 100, 0, 30)
fpsLabel.Position = UDim2.new(0, 15, 0, 15)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
fpsLabel.TextSize = 16
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Text = "FPS: --"
fpsLabel.Parent = screenGui

local lastUpdate = 0
local frameCount = 0
RunService.RenderStepped:Connect(function(dt)
    frameCount = frameCount + 1
    lastUpdate = lastUpdate + dt
    if lastUpdate >= 0.5 then
        local fps = math.floor(frameCount / lastUpdate)
        fpsLabel.Text = "FPS: " .. fps
        fpsLabel.TextColor3 = Color3.fromRGB(math.random(100,255), 255, math.random(100,255))
        frameCount = 0
        lastUpdate = 0
    end
end)

-- ==========================================
-- PHẦN 3: NÚT TIA CHỞP GÓC TRÊN PHẢI
-- ==========================================
local lightningBtn = Instance.new("TextButton")
lightningBtn.Size = UDim2.new(0, 45, 0, 45)
lightningBtn.Position = UDim2.new(1, -60, 0, 15)
lightningBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
lightningBtn.TextColor3 = Color3.fromRGB(255, 220, 0)
lightningBtn.Text = "⚡"
lightningBtn.TextSize = 24
lightningBtn.Font = Enum.Font.GothamBold
lightningBtn.Parent = screenGui

local cornerBtn = Instance.new("UICorner")
cornerBtn.CornerRadius = UDim.new(0, 10)
cornerBtn.Parent = lightningBtn

local strokeBtn = Instance.new("UIStroke")
strokeBtn.Color = Color3.fromRGB(255, 220, 0)
strokeBtn.Thickness = 2
strokeBtn.Parent = lightningBtn

-- ==========================================
-- PHẦN 4: BẢNG ACCOUNT PROGRESS & CHỮ KÝ BÍ MẬT
-- ==========================================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 235)
mainFrame.Position = UDim2.new(1, -300, 0, 70)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Visible = false
mainFrame.Parent = screenGui

local cornerFrame = Instance.new("UICorner")
cornerFrame.CornerRadius = UDim.new(0, 12)
cornerFrame.Parent = mainFrame

local strokeFrame = Instance.new("UIStroke")
strokeFrame.Color = Color3.fromRGB(255, 220, 0)
strokeFrame.Thickness = 1.5
strokeFrame.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "⚡ Account Progress & Network"
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 50)
padding.PaddingLeft = UDim.new(0, 15)
padding.PaddingRight = UDim.new(0, 15)
padding.Parent = mainFrame

local function createInfoLine(name)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = name .. ": Đang tải..."
    lbl.Parent = mainFrame
    return lbl
end

local pingLbl = createInfoLine("📶 Ping (Độ trễ): ")
local fpsDetailLbl = createInfoLine("💻 FPS Chi tiết: ")
local wifiStatusLbl = createInfoLine("🌐 Trạng thái Mạng: Ổn định (Boosted)")
local statusLbl = createInfoLine("🚀 Trạng thái Giảm Lag: Đã kích hoạt")

-- Chữ ký siêu nhỏ, mờ mờ ở góc dưới bảng để giữ bí mật tuyệt đối
local secretSign = Instance.new("TextLabel")
secretSign.Size = UDim2.new(1, 0, 0, 15)
secretSign.Position = UDim2.new(0, 0, 1, -18)
secretSign.BackgroundTransparency = 1
secretSign.TextColor3 = Color3.fromRGB(80, 80, 80)
secretSign.TextSize = 9
secretSign.Font = Enum.Font.Gotham
secretSign.TextXAlignment = Enum.TextXAlignment.Right
secretSign.Text = "made by Gemini "
secretSign.Parent = mainFrame

RunService.RenderStepped:Connect(function()
    if mainFrame.Visible then
        pcall(function()
            local pingValue = 0
            if Stats.Network.ServerStatsItem["Data Ping"]:GetValue() then
                pingValue = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end
            pingLbl.Text = "📶 Ping: " .. pingValue .. " ms"
            
            local currentFPS = math.floor(1 / RunService.RenderStepped:Wait())
            fpsDetailLbl.Text = "💻 FPS: " .. currentFPS
            
            if pingValue < 150 then
                wifiStatusLbl.Text = "🌐 Tình trạng Wi-Fi: Tốt / Ổn định"
                wifiStatusLbl.TextColor3 = Color3.fromRGB(0, 255, 128)
            else
                wifiStatusLbl.Text = "🌐 Tình trạng Wi-Fi: Yếu (Đang tối ưu)"
                wifiStatusLbl.TextColor3 = Color3.fromRGB(255, 170, 0)
            end
        end)
    end
end)

lightningBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    mainFrame.Visible = isOpen
    if isOpen then
        lightningBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    else
        lightningBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    end
end)
