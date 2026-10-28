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
fpsLabel.Size = UDim2.new(0, 100, 0, 3
