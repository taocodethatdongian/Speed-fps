--[[
    Script Chống Lag Cực Hạn - Bản Vá Lỗi PlayerGui (100k Studs)
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Xóa UI cũ nếu có tránh bị trùng
if PlayerGui:FindFirstChild("AdvancedPerformanceHub") then
    PlayerGui.AdvancedPerformanceHub:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedPerformanceHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- ==========================================
-- PHẦN 1: TỐI ƯU HÓA KHÔNG GIAN (CHỐNG TREO MÁY)
-- ==========================================
task.spawn(function()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 2
        
        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveTransparency = 1
        end
        
        -- Quét định kỳ mỗi 1 giây để không giật lag máy
        task.spawn(function()
            while true do
                pcall(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local charPos = LocalPlayer.Character.HumanoidRootPart.Position
                        for _, part in ipairs(Workspace:GetDescendants()) do
                            if part:IsA("BasePart") and not part.Anchored then
                                local dist = (part.Position - charPos).Magnitude
                                if dist > 200 and dist <= 100000 then
                                    part.AssemblyLinearVelocity = Vector3.new(0,0,0)
                                    part.CanCollide = false
                                    part.Transparency = 0.6
                                end
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end)
end)

-- ==========================================
-- PHẦN 2: DÒNG FPS GÓC TRÊN TRÁI
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
        frameCount = 0
        lastUpdate = 0
    end
end)

-- ==========================================
-- PHẦN 3: NÚT TIA CHỚP GÓC TRÊN PHẢI
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
-- PHẦN 4: BẢNG GIAO DIỆN & CHỮ KÝ BÍ MẬT
-- ==========================================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 180)
mainFrame.Position = UDim2.new(1, -320, 0, 70)
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
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleLabel.TextColor3 = Color3.fromRGB(255, 220, 0)
titleLabel.Text = "⚡ 100k Studs Anti-Lag Protection"
titleLabel.TextSize = 12
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = mainFrame
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8)

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 45)
padding.PaddingLeft = UDim.new(0, 12)
padding.PaddingRight = UDim.new(0, 12)
padding.Parent = mainFrame

local function createInfoLine(text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = text
    lbl.LayoutOrder = order
    lbl.Parent = mainFrame
    return lbl
end

local pingLbl = createInfoLine("📶 Ping: Đang tải...", 1)
local fpsDetailLbl = createInfoLine("💻 Trạng thái: Hoạt động ổn định", 2)

local secretSign = Instance.new("TextLabel")
secretSign.Size = UDim2.new(1, 0, 0, 15)
secretSign.BackgroundTransparency = 1
secretSign.TextColor3 = Color3.fromRGB(90, 90, 90)
secretSign.TextSize = 9
secretSign.Font = Enum.Font.Gotham
secretSign.TextXAlignment = Enum.TextXAlignment.Right
secretSign.Text = "made by Gemini "
secretSign.LayoutOrder = 4
secretSign.Parent = mainFrame

local isOpen = false
lightningBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    mainFrame.Visible = isOpen
end)

RunService.RenderStepped:Connect(function()
    if mainFrame.Visible then
        pcall(function()
            local pingValue = 0
            if Stats.Network.ServerStatsItem["Data Ping"]:GetValue() then
                pingValue = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end
            pingLbl.Text = "📶 Ping: " .. pingValue .. " ms"
        end)
    end
end)
