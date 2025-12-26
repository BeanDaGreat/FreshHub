local _ = ((table and 10108772)) -- 10108772 or 15920280
local Loaded_Var3 = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local Enum_KeyCode = Enum.KeyCode
local Window_2 = Loaded_Var3:Window({
    DragStyle = 1,
    Subtitle = "Universal script by Bean",
    Title = "Fresh Hub",
    Keybind = Enum_KeyCode.RightControl,
    AcrylicBlur = true,
    ShowUserInfo = true,
    Size = UDim2.fromOffset(868, 650),
})

-- Variables globales pour les paramÃ¨tres
local aimbotEnabled = false
local smoothing = 80
local mode = "Off"
local triggerDelay = 200
local hitchance = 99
local showFOV = false
local fovRadius = 150
local selection = "Closest"
local trackingPos = "Center"
local shake = false
local shakeIntensity = 0

local var7 = Drawing.new("Circle")
var7.Thickness = 1
var7.Color = Color3.fromRGB(255, 255, 255)
var7.Filled = false
var7.Transparency = 1
var7.NumSides = 64
var7.Visible = false

Window_2:GlobalSetting({
    Callback = function(p1_0, p2_0)
        Window_2:SetAcrylicBlurState(p1_0)
    end,
    Name = "UI Blur",
    Default = Window_2:GetAcrylicBlurState(),
})
Window_2:GlobalSetting({
    Callback = function(p1_0, p2_0)
        Window_2:SetNotificationsState(p1_0)
    end,
    Name = "Notifications",
    Default = Window_2:GetNotificationsState(),
})
Window_2:GlobalSetting({
    Callback = function(p1_0, p2_0, p3_0)
        Window_2:SetUserInfoState(p1_0)
    end,
    Name = "Show User Info",
    Default = Window_2:GetUserInfoState(),
})

local TabGroup_2 = Window_2:TabGroup()
local Tab_2 = TabGroup_2:Tab({
    Name = "Main",
    Image = "rbxassetid://18821914323",
})
local Tab_4 = TabGroup_2:Tab({
    Name = "Settings",
    Image = "rbxassetid://10734950309",
})

local Section_2 = Tab_2:Section({
    Side = "Left",
})
local Section_4 = Tab_2:Section({
    Side = "Right",
})
local Section_6 = Tab_4:Section({
    Side = "Left",
})

local _ = Section_2:Toggle({
    Callback = function(p1_0, p2_0, p3_0, p4_0, p5_0, p6_0)
        aimbotEnabled = p1_0
        local Not_P1_0 = not p1_0;
        local var37 = (Not_P1_0 and 14211352);
        local var38 = (Not_P1_0 and 15851911);
    end,
    Name = "Enable aimbot",
    Default = false,
})

Section_2:Slider({
    Minimum = 0,
    Name = "Smoothing ",
    Maximum = 100,
    Precision = 0,
    Callback = function(p1_0, p2_0)
        smoothing = math.floor(p1_0)
    end,
    Default = 80,
})

local _ = Section_2:Dropdown({
    Callback = function(p1_0, p2_0)
        mode = p1_0
        local p1_0_is_string = (p1_0 == "Off");
        local var40 = (p1_0_is_string and 11139029);
        local var41 = (p1_0_is_string and 10782360);
    end,
    Default = 1,
    Name = "mode",
    Options = {
        "Off",
        "Hold",
        "Click",
    },
})

Section_2:Slider({
    Minimum = 100,
    Name = "Trigger Delay (ms)",
    Maximum = 500,
    Precision = 0,
    Callback = function(p1_0)
        triggerDelay = p1_0
    end,
    Default = 200,
})

Section_2:Slider({
    Minimum = 99,
    Name = "Hitchance (paid)",
    Maximum = 100,
    Precision = 0,
    Callback = function(p1_0, p2_0, p3_0, p4_0, p5_0)
        hitchance = math.floor(p1_0)
    end,
    Default = 99,
})

Section_4:Toggle({
    Callback = function(p1_0, p2_0, p3_0, p4_0, p5_0)
        showFOV = p1_0
    end,
    Name = "Show FOV",
    Default = false,
})

Section_4:Slider({
    Minimum = 10,
    Name = "FOV Radius",
    Maximum = 800,
    Precision = 0,
    Callback = function(p1_0, p2_0, p3_0, p4_0, p5_0)
        fovRadius = p1_0
    end,
    Default = 150,
})

Section_4:Dropdown({
    Callback = function(p1_0)
        selection = p1_0
    end,
    Default = 1,
    Name = "Selection",
    Options = {
        "Closest",
        "Random",
    },
})

Section_4:Dropdown({
    Callback = function(p1_0)
        trackingPos = p1_0
    end,
    Default = 2,
    Name = "tracking pos",
    Options = {
        "i forgor ðŸ’€",
        "Center",
        "Inner random",
        "Prediction",
    },
})

Section_4:Toggle({
    Callback = function(p1_0)
        shake = p1_0
    end,
    Name = "Shake",
    Default = false,
})

Section_4:Slider({
    Minimum = 0,
    Name = "Shake Intensity",
    Maximum = 100,
    Precision = 0,
    Callback = function(p1_0, p2_0, p3_0, p4_0, p5_0)
        shakeIntensity = math.floor(p1_0) / 100
    end,
    Default = 0,
})

Section_6:Keybind({
    onBinded = function(p1_0, p2_0, p3_0, p4_0, p5_0)
        Window_2.Settings.Keybind = p1_0
    end,
    Name = "Menu Section_6.Keybind (im lazy)",
    Default = Enum_KeyCode.RightControl,
})

local Connection
Connection = game:GetService("RunService").RenderStepped:Connect(function(DeltaTime, p2_0, p3_0)
    var7.Visible = showFOV
    var7.Radius = math.floor(fovRadius)
    local Vector2_New = Vector2.new
    var7.Position = Vector2_New(Mouse.X, Mouse.Y + 36)
    
    local var48 = (not aimbotEnabled and 10025236)
    Vector2_New(Mouse.X, Mouse.Y)
    
    for i, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            if v.BrickColor == BrickColor.new("Really red") then
                local _ = 16069874
            end
        end
    end
end)

Tab_2:Select()
