--[[
    Script Chống Lag Cực Hạn (100,000 Studs Anti-Lag & Physics Optimizer)
]]--

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- Xóa UI cũ nếu có
if CoreGui:FindFirstChild("AdvancedPerformanceHub") then
    CoreGui.AdvancedPerformanceHub:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedPerformanceHub"
screenGui.Parent = CoreGui

-- ==========================================
-- PHẦN 1: TỐI ƯU HÓA PHẠM VI 100,000 STUDS
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
        
        -- Quét khoảng cách lớn chống văng lag
        RunService.Heartbeat:Connect(function()
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local charPos = LocalPlayer.Character.HumanoidRootPart.Position
                    for _, part in ipairs(Workspace:GetDescendants()) do
                        if part:IsA("BasePart") and not part.Anchored then
                            local dist = (part.Position - charPos).Magnitude
                            if dist > 300 and dist <= 100000 then
                                part.AssemblyLinearVelocity = Vector3.new(0,0,0)
                                part.AssemblyAngularVelocity = Vector3.new(0,0,0)
                                part.CanCollide = false
                                part.Transparency = 0.5
                            end
                        end
                    end
                end
            end)
        end)
        
        if settings():FindFirstChild("Network") then
            settings().Network.IncomingReplicationLag = 0
        end
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
        fpsLabel.TextColor3 = Color3.fromRGB(math.random(100,255), 255, math.random(100,255))
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
mainFrame.Size = UDim2.new(0, 300, 0, 200)
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
titleLabel.Size = UDim2.new(1, 0, 0,
