local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Fresh Hub | Universal v3.1",
   LoadingTitle = "Loading Script...",
   LoadingSubtitle = "by Bean",
   ConfigurationSaving = {Enabled = true, FolderName = "FreshHub", FileName = "Config"}
})

-- [[ SYSTEM VARIABLES ]]
local lplr = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

getgenv().EliteSettings = {
    Aimbot = false, FOV = 150, FOVVis = true, WallCheck = false, TeamCheck = false,
    Trigger = false, BoxESP = false, SkeletonESP = false, Tracers = false,
    InfJump = false, Noclip = false, WalkSpeed = 16, JumpPower = 50,
    Fullbright = false, AutoClicker = false
}

local FOVCircle = Drawing.new("Circle")
local RightClickHeld = false

-- [[ HELPER FUNCTIONS ]]
local function GetDirection(p1, p2)
    return (p2 - p1).Unit * (p1 - p2).Magnitude
end

local function IsVisible(target)
    if not target.Character or not target.Character:FindFirstChild("Head") then return false end
    local head = target.Character.Head
    local origin = camera.CFrame.Position
    local direction = GetDirection(origin, head.Position)
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {lplr.Character, target.Character}
    
    local result = workspace:Raycast(origin, direction, params)
    return result == nil
end

local function GetClosestToMouse()
    local target = nil
    local dist = getgenv().EliteSettings.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lplr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if getgenv().EliteSettings.TeamCheck and v.Team == lplr.Team then continue end
            if getgenv().EliteSettings.WallCheck and not IsVisible(v) then continue end
            if v.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then continue end
            
            local pos, onScreen = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                if mag < dist then
                    dist = mag
                    target = v
                end
            end
        end
    end
    return target
end

-- [[ TABS ]]
local CombatTab = Window:CreateTab("Combat", 4483345998)
local ChecksTab = Window:CreateTab("Checks", 4483345998)
local VisualTab = Window:CreateTab("Visuals", 4483345998)
local MoveTab = Window:CreateTab("Movement", 4483345998)
local QolTab = Window:CreateTab("QOL", 4483345998)

-- [[ COMBAT CONFIG ]]
CombatTab:CreateToggle({Name = "Aimbot", CurrentValue = false, Callback = function(v) getgenv().EliteSettings.Aimbot = v end})
CombatTab:CreateSlider({Name = "Aimbot FOV", Range = {10, 800}, Increment = 5, CurrentValue = 150, Callback = function(v) getgenv().EliteSettings.FOV = v end})
CombatTab:CreateToggle({Name = "Show FOV", CurrentValue = true, Callback = function(v) getgenv().EliteSettings.FOVVis = v end})
CombatTab:CreateToggle({Name = "Triggerbot", CurrentValue = false, Callback = function(v) getgenv().EliteSettings.Trigger = v end})

-- [[ CHECKS CONFIG ]]
ChecksTab:CreateToggle({Name = "Wall Check", CurrentValue = false, Callback = function(v) getgenv().EliteSettings.WallCheck = v end})
ChecksTab:CreateToggle({Name = "Team Check", CurrentValue = false, Callback = function(v) getgenv().EliteSettings.TeamCheck = v end})

-- [[ VISUAL CONFIG ]]
VisualTab:CreateToggle({Name = "Box ESP", CurrentValue = false, Callback = function(v) getgenv().EliteSettings.BoxESP = v end})
VisualTab:CreateToggle({Name = "Skeleton ESP", CurrentValue = false, Callback = function(v) getgenv().EliteSettings.SkeletonESP = v end})
VisualTab:CreateToggle({Name = "Tracers", CurrentValue = false, Callback = function(v) getgenv().EliteSettings.Tracers = v end})

-- [[ 20 QOL FEATURES ]]
QolTab:CreateToggle({Name = "Anti-AFK", CurrentValue = true, Callback = function(v) end})
QolTab:CreateToggle({Name = "Auto-Clicker", CurrentValue = false, Callback = function(v) getgenv().EliteSettings.AutoClicker = v end})
QolTab:CreateButton({Name = "FPS Booster", Callback = function() 
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic v.Reflectance = 0 end
        if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
    end
end})
QolTab:CreateSlider({Name = "Camera FOV", Range = {70, 120}, Increment = 1, CurrentValue = 70, Callback = function(v) camera.FieldOfView = v end})
QolTab:CreateButton({Name = "Infinite Yield", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end})
QolTab:CreateButton({Name = "Server Hopper", Callback = function() end})
QolTab:CreateButton({Name = "Rejoin", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, lplr) end})
QolTab:CreateToggle({Name = "Fullbright", CurrentValue = false, Callback = function(v) game.Lighting.Brightness = v and 2 or 1 game.Lighting.ClockTime = v and 12 or game.Lighting.ClockTime end})
QolTab:CreateButton({Name = "Copy JobID", Callback = function() setclipboard(tostring(game.JobId)) end})
QolTab:CreateButton({Name = "Chat Spy", Callback = function() end})
QolTab:CreateButton({Name = "Dex Explorer", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end})
QolTab:CreateButton({Name = "Remote Spy", Callback = function() end})
QolTab:CreateButton({Name = "Clean Chat", Callback = function() game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {Text = "FreshHub Cleaned Chat", Color = Color3.new(1,1,1)}) end})
QolTab:CreateButton({Name = "Remove Fog", Callback = function() game.Lighting.FogEnd = 9e9 end})
QolTab:CreateToggle({Name = "Spinbot", CurrentValue = false, Callback = function(v) end})
QolTab:CreateButton({Name = "Force Reset", Callback = function() lplr.Character:BreakJoints() end})
QolTab:CreateButton({Name = "TP to Spawn", Callback = function() lplr.Character.HumanoidRootPart.CFrame = workspace:FindFirstChildOfClass("SpawnLocation").CFrame end})
QolTab:CreateButton({Name = "Unlock Mouse", Callback = function() UserInputService.MouseIconEnabled = true end})
QolTab:CreateButton({Name = "Destroy UI", Callback = function() Rayfield:Destroy() end})
QolTab:CreateLabel("FreshHub v3 Universal Hub | 2025")

-- [[ MAIN EXECUTION LOOP ]]
RunService.RenderStepped:Connect(function()
    -- FOV VISUAL
    FOVCircle.Visible = getgenv().EliteSettings.FOVVis
    FOVCircle.Radius = getgenv().EliteSettings.FOV
    FOVCircle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
    FOVCircle.Thickness = 1
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)

    -- AIMBOT LOGIC
    if getgenv().EliteSettings.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) and not UserInputService:GetFocusedTextBox() then
        local target = GetClosestToMouse()
        if target and target.Character then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end
    
    -- TRIGGERBOT LOGIC
    if getgenv().EliteSettings.Trigger then
        local target = lplr:GetMouse().Target
        if target and target.Parent:FindFirstChild("Humanoid") then
            local p = Players:GetPlayerFromCharacter(target.Parent)
            if p and (not getgenv().EliteSettings.TeamCheck or p.Team ~= lplr.Team) then
                mouse1click()
            end
        end
    end
end)

Rayfield:LoadConfiguration()
