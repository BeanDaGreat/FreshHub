-- CustomTopUI.lua
-- Place in a LocalScript under StarterPlayerScripts or StarterGui for local-only UI
-- No external libraries required

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ===== Config =====
local UI_NAME = "FreshHubUI"
local THEME = {
    Dark = {
        Background = Color3.fromRGB(18, 18, 20),
        Panel = Color3.fromRGB(28, 28, 30),
        Accent = Color3.fromRGB(88, 101, 242),
        Text = Color3.fromRGB(230, 230, 230),
        Muted = Color3.fromRGB(160, 160, 170)
    },
    Light = {
        Background = Color3.fromRGB(245, 246, 250),
        Panel = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(88, 101, 242),
        Text = Color3.fromRGB(20, 20, 20),
        Muted = Color3.fromRGB(110, 110, 120)
    }
}
local CURRENT_THEME = THEME.Dark

-- ===== Helpers =====
local function new(class, props)
    local obj = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            obj[k] = v
        end
    end
    return obj
end

local function tween(obj, props, time, style, dir)
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    local info = TweenInfo.new(time or 0.18, style, dir)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

-- ===== Build UI =====
-- Remove old if present
local existing = playerGui:FindFirstChild(UI_NAME)
if existing then existing:Destroy() end

local screenGui = new("ScreenGui", {Name = UI_NAME, ResetOnSpawn = false, Parent = playerGui})
screenGui.DisplayOrder = 1000

-- Main window
local window = new("Frame", {
    Name = "Window",
    Parent = screenGui,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0.03, 0),
    Size = UDim2.new(0.6, 0, 0.7, 0),
    BackgroundColor3 = CURRENT_THEME.Panel,
    BorderSizePixel = 0,
    ClipsDescendants = true
})
local uiCorner = new("UICorner", {Parent = window, CornerRadius = UDim.new(0, 10)})
local uiStroke = new("UIStroke", {Parent = window, Color = Color3.fromRGB(0,0,0), Transparency = 0.85, Thickness = 1})

-- Top bar
local topBar = new("Frame", {
    Name = "TopBar",
    Parent = window,
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = CURRENT_THEME.Panel,
    BorderSizePixel = 0
})
new("UICorner", {Parent = topBar, CornerRadius = UDim.new(0, 10)})

local title = new("TextLabel", {
    Parent = topBar,
    Text = "Fresh Hub v0.1",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = CURRENT_THEME.Text,
    BackgroundTransparency = 1,
    Position = UDim2.new(0.02, 0, 0, 0),
    Size = UDim2.new(0.3, 0, 1, 0),
    TextXAlignment = Enum.TextXAlignment.Left
})

-- Tab container (horizontal)
local tabContainer = new("Frame", {
    Parent = topBar,
    Name = "TabContainer",
    Size = UDim2.new(0.6, 0, 1, 0),
    Position = UDim2.new(0.35, 0, 0, 0),
    BackgroundTransparency = 1
})
local tabLayout = new("UIListLayout", {Parent = tabContainer, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), HorizontalAlignment = Enum.HorizontalAlignment.Left, SortOrder = Enum.SortOrder.LayoutOrder})
tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() end)

-- Active indicator
local activeIndicator = new("Frame", {
    Parent = topBar,
    Name = "ActiveIndicator",
    Size = UDim2.new(0, 80, 0, 3),
    Position = UDim2.new(0.35, 0, 1, -3),
    BackgroundColor3 = CURRENT_THEME.Accent,
    BorderSizePixel = 0
})
new("UICorner", {Parent = activeIndicator, CornerRadius = UDim.new(0, 3)})

-- Content area
local content = new("Frame", {
    Parent = window,
    Name = "Content",
    Position = UDim2.new(0, 0, 0, 48),
    Size = UDim2.new(1, 0, 1, -48),
    BackgroundColor3 = CURRENT_THEME.Background,
    BorderSizePixel = 0
})
new("UICorner", {Parent = content, CornerRadius = UDim.new(0, 8)})

-- Left padding and layout
local contentPadding = new("UIPadding", {Parent = content, PaddingTop = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)})

-- Tab management
local tabs = {}
local activeTab = nil

local function createTab(name)
    local btn = new("TextButton", {
        Parent = tabContainer,
        Text = name,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = CURRENT_THEME.Muted,
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Size = UDim2.new(0, 90, 1, 0)
    })
    btn.MouseEnter:Connect(function()
        tween(btn, {TextColor3 = CURRENT_THEME.Text}, 0.12)
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= name then
            tween(btn, {TextColor3 = CURRENT_THEME.Muted}, 0.12)
        end
    end)

    local page = new("Frame", {
        Parent = content,
        Name = name .. "_Page",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false
    })

    tabs[name] = {Button = btn, Page = page}

    btn.MouseButton1Click:Connect(function()
        -- switch
        if activeTab == name then return end
        if activeTab and tabs[activeTab] then
            tween(tabs[activeTab].Button, {TextColor3 = CURRENT_THEME.Muted}, 0.12)
            tabs[activeTab].Page.Visible = false
        end
        activeTab = name
        tabs[name].Page.Visible = true
        tween(btn, {TextColor3 = CURRENT_THEME.Text}, 0.12)
        -- move active indicator
        local absPos = btn.AbsolutePosition.X - topBar.AbsolutePosition.X
        tween(activeIndicator, {Position = UDim2.new(0, absPos, 1, -3), Size = UDim2.new(0, btn.AbsoluteSize.X, 0, 3)}, 0.18)
    end)

    return page
end

-- Create example tabs
local visualsPage = createTab("Visuals")
local settingsPage = createTab("Settings")
local aboutPage = createTab("About")

-- Activate first tab
tabs["Visuals"].Button.TextColor3 = CURRENT_THEME.Text
tabs["Visuals"].Page.Visible = true
activeTab = "Visuals"
-- position indicator under first tab after layout
RunService.Heartbeat:Wait()
local firstBtn = tabs["Visuals"].Button
activeIndicator.Position = UDim2.new(0, firstBtn.AbsolutePosition.X - topBar.AbsolutePosition.X, 1, -3)
activeIndicator.Size = UDim2.new(0, firstBtn.AbsoluteSize.X, 0, 3)

-- ===== UI Components =====
-- Simple slider factory
local function createSlider(parent, labelText, min, max, default, step, callback)
    local container = new("Frame", {Parent = parent, Size = UDim2.new(1, 0, 0, 56), BackgroundTransparency = 1})
    local lbl = new("TextLabel", {
        Parent = container,
        Text = labelText,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = CURRENT_THEME.Text,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 2),
        Size = UDim2.new(0.6, 0, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local valLbl = new("TextLabel", {
        Parent = container,
        Text = tostring(default),
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = CURRENT_THEME.Muted,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -80, 0, 2),
        Size = UDim2.new(0, 80, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Right
    })

    local bar = new("Frame", {
        Parent = container,
        BackgroundColor3 = Color3.fromRGB(200,200,200),
        BackgroundTransparency = 0.85,
        Position = UDim2.new(0, 0, 0, 28),
        Size = UDim2.new(1, 0, 0, 10),
        BorderSizePixel = 0
    })
    new("UICorner", {Parent = bar, CornerRadius = UDim.new(0, 6)})
    local fill = new("Frame", {
        Parent = bar,
        BackgroundColor3 = CURRENT_THEME.Accent,
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BorderSizePixel = 0
    })
    new("UICorner", {Parent = fill, CornerRadius = UDim.new(0, 6)})

    -- draggable knob
    local knob = new("ImageButton", {
        Parent = bar,
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926305904", -- circle image
        ImageColor3 = CURRENT_THEME.Accent,
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, -9),
        AutoButtonColor = false
    })
    knob.ImageTransparency = 0
    knob.MouseEnter:Connect(function() tween(knob, {Size = UDim2.new(0, 22, 0, 22)}, 0.12) end)
    knob.MouseLeave:Connect(function() tween(knob, {Size = UDim2.new(0, 18, 0, 18)}, 0.12) end)

    local dragging = false
    local function setValueFromX(x)
        local barPos = bar.AbsolutePosition.X
        local barSize = bar.AbsoluteSize.X
        local rel = math.clamp((x - barPos) / barSize, 0, 1)
        local raw = min + rel * (max - min)
        if step and step > 0 then
            raw = math.floor(raw / step + 0.5) * step
        end
        local relScale = (raw - min) / (max - min)
        fill.Size = UDim2.new(relScale, 0, 1, 0)
        knob.Position = UDim2.new(relScale, 0, 0.5, -9)
        valLbl.Text = tostring(raw)
        if callback then
            callback(raw)
        end
    end

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    knob.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = game.Players.LocalPlayer:GetMouse()
            setValueFromX(mouse.X)
        end
    end)

    -- click on bar to set
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            setValueFromX(input.Position.X)
        end
    end)

    return container
end

-- Populate Visuals page with sliders
local visualsLayout = new("UIListLayout", {Parent = visualsPage, Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder})
visualsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
visualsLayout.VerticalAlignment = Enum.VerticalAlignment.Top
visualsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() end)

local slider1 = createSlider(visualsPage, "Crosshair Size", 4, 64, 24, 1, function(v)
    -- callback example
    -- print("Crosshair size:", v)
end)
local slider2 = createSlider(visualsPage, "FOV Radius", 40, 300, 120, 1, function(v) end)
local slider3 = createSlider(visualsPage, "Sensitivity", 0.5, 2.0, 1.0, 0.01, function(v) end)

-- Settings page content
local settingsLayout = new("UIListLayout", {Parent = settingsPage, Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder})
local themeToggle = new("TextButton", {
    Parent = settingsPage,
    Text = "Toggle Theme",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = CURRENT_THEME.Text,
    BackgroundColor3 = CURRENT_THEME.Panel,
    Size = UDim2.new(0, 160, 0, 36),
    AutoButtonColor = false
})
new("UICorner", {Parent = themeToggle, CornerRadius = UDim.new(0, 8)})
themeToggle.MouseButton1Click:Connect(function()
    if CURRENT_THEME == THEME.Dark then
        CURRENT_THEME = THEME.Light
    else
        CURRENT_THEME = THEME.Dark
    end
    -- apply theme colors (simple)
    window.BackgroundColor3 = CURRENT_THEME.Panel
    topBar.BackgroundColor3 = CURRENT_THEME.Panel
    content.BackgroundColor3 = CURRENT_THEME.Background
    title.TextColor3 = CURRENT_THEME.Text
    for _, t in pairs(tabs) do
        t.Button.TextColor3 = CURRENT_THEME.Muted
        for _, obj in pairs(t.Page:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                obj.TextColor3 = CURRENT_THEME.Text
            end
        end
    end
    activeIndicator.BackgroundColor3 = CURRENT_THEME.Accent
end)

-- About page
local aboutLabel = new("TextLabel", {
    Parent = aboutPage,
    Text = "Built with clean native Roblox UI components.\nExtend by adding new tabs and components.",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = CURRENT_THEME.Muted,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 80),
    TextWrapped = true
})

-- ===== Draggable window =====
local draggingWindow = false
local dragStart = Vector2.new()
local startPos = UDim2.new()
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingWindow = true
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        startPos = window.Position
    end
end)
topBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingWindow = false
    end
end)
RunService.RenderStepped:Connect(function()
    if draggingWindow then
        local mouse = game.Players.LocalPlayer:GetMouse()
        local delta = Vector2.new(mouse.X, mouse.Y) - dragStart
        window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ===== Final polish =====
-- Make UI scale nicely on different resolutions
screenGui.ResetOnSpawn = false
window.Size = UDim2.new(0.6, 0, 0.7, 0)
window.AnchorPoint = Vector2.new(0.5, 0)
window.Position = UDim2.new(0.5, 0, 0.03, 0)

-- Optional: expose API for other scripts
local API = {}
API.CreateTab = createTab
API.CreateSlider = createSlider
API.Root = screenGui

-- Example usage from other scripts:
-- local ui = require(pathToThisScript)
-- ui.CreateTab("Extras")

-- End of script
