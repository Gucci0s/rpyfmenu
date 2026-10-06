--[[
    RPYF TROLL SCRIPT - COMPLETE FIXED VERSION
    Features: Fling, Aimbot with FOV, Fly, Car Throwing, Backshots
    
    WARNING: This script is for educational purposes only.
    Using exploits in Roblox violates Terms of Service and can result in account bans.
    Use at your own risk.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configuration
local Config = {
    FlingPower = 500,
    AimbotEnabled = false,
    AimbotFOV = 200,
    AimbotTarget = "Head", -- Head, Body, Legs+Body, Body+Head, All
    FlyEnabled = false,
    FlySpeed = 100,
    ThrowPower = 300,
    FlingAllRadius = 50,
    BackshotsEnabled = false,
    BackshotsSpeed = 0.3,
    BackshotsDistance = 3,
}

-- Keybind Configuration (customizable)
local Keybinds = {
    Aimbot = Enum.KeyCode.G,
    Fly = Enum.KeyCode.H,
    FlingNearest = Enum.KeyCode.F,
    FlingAll = Enum.KeyCode.R,
    ThrowCar = Enum.KeyCode.T,
    Backshots = Enum.KeyCode.B,
}

local KeybindNames = {
    [Enum.KeyCode.G] = "G",
    [Enum.KeyCode.H] = "H",
    [Enum.KeyCode.F] = "F",
    [Enum.KeyCode.R] = "R",
    [Enum.KeyCode.T] = "T",
    [Enum.KeyCode.B] = "B",
    [Enum.KeyCode.Q] = "Q",
    [Enum.KeyCode.E] = "E",
    [Enum.KeyCode.Z] = "Z",
    [Enum.KeyCode.X] = "X",
    [Enum.KeyCode.C] = "C",
    [Enum.KeyCode.V] = "V",
    [Enum.KeyCode.Y] = "Y",
    [Enum.KeyCode.U] = "U",
    [Enum.KeyCode.I] = "I",
    [Enum.KeyCode.O] = "O",
    [Enum.KeyCode.P] = "P",
    [Enum.KeyCode.K] = "K",
    [Enum.KeyCode.L] = "L",
    [Enum.KeyCode.N] = "N",
    [Enum.KeyCode.M] = "M",
}

-- GUI Setup with modern design
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RpyfTrollGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui

-- Main Frame with gradient
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 520)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Shadow effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.7
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

-- Gradient background
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
}
Gradient.Rotation = 45
Gradient.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(75, 0, 130))
}
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "😈 Rpyf Troll"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -45, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tabs Container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 0, 40)
TabContainer.Position = UDim2.new(0, 10, 0, 60)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

-- Content Frame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -20, 1, -120)
ContentFrame.Position = UDim2.new(0, 10, 0, 110)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 4
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = ContentFrame

-- Keybind Change Popup
local KeybindPopup = Instance.new("Frame")
KeybindPopup.Size = UDim2.new(0, 300, 0, 150)
KeybindPopup.Position = UDim2.new(0.5, -150, 0.5, -75)
KeybindPopup.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
KeybindPopup.BorderSizePixel = 0
KeybindPopup.Visible = false
KeybindPopup.ZIndex = 100
KeybindPopup.Parent = ScreenGui

local PopupCorner = Instance.new("UICorner")
PopupCorner.CornerRadius = UDim.new(0, 12)
PopupCorner.Parent = KeybindPopup

local PopupTitle = Instance.new("TextLabel")
PopupTitle.Size = UDim2.new(1, -20, 0, 40)
PopupTitle.Position = UDim2.new(0, 10, 0, 10)
PopupTitle.BackgroundTransparency = 1
PopupTitle.Text = "Press any key..."
PopupTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PopupTitle.TextSize = 16
PopupTitle.Font = Enum.Font.GothamBold
PopupTitle.Parent = KeybindPopup

local PopupSubtitle = Instance.new("TextLabel")
PopupSubtitle.Size = UDim2.new(1, -20, 0, 60)
PopupSubtitle.Position = UDim2.new(0, 10, 0, 50)
PopupSubtitle.BackgroundTransparency = 1
PopupSubtitle.Text = "Press ESC to cancel"
PopupSubtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
PopupSubtitle.TextSize = 12
PopupSubtitle.Font = Enum.Font.Gotham
PopupSubtitle.TextWrapped = true
PopupSubtitle.Parent = KeybindPopup

local PopupCancel = Instance.new("TextButton")
PopupCancel.Size = UDim2.new(0, 100, 0, 35)
PopupCancel.Position = UDim2.new(0.5, -50, 1, -45)
PopupCancel.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
PopupCancel.BorderSizePixel = 0
PopupCancel.Text = "Cancel"
PopupCancel.TextColor3 = Color3.fromRGB(255, 255, 255)
PopupCancel.TextSize = 14
PopupCancel.Font = Enum.Font.GothamBold
PopupCancel.Parent = KeybindPopup

local CancelCorner = Instance.new("UICorner")
CancelCorner.CornerRadius = UDim.new(0, 8)
CancelCorner.Parent = PopupCancel

-- Helper Functions
local function createTab(text, icon, layoutOrder)
    local Tab = Instance.new("TextButton")
    Tab.Size = UDim2.new(0.32, -5, 1, 0)
    Tab.Position = UDim2.new((layoutOrder - 1) * 0.33, 0, 0, 0)
    Tab.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    Tab.BorderSizePixel = 0
    Tab.Text = icon .. " " .. text
    Tab.TextColor3 = Color3.fromRGB(200, 200, 200)
    Tab.TextSize = 14
    Tab.Font = Enum.Font.GothamSemibold
    Tab.Parent = TabContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = Tab
    
    return Tab
end

local currentKeybindChanging = nil

local function openKeybindChanger(keybindName, currentKey, callback)
    currentKeybindChanging = keybindName
    KeybindPopup.Visible = true
    PopupTitle.Text = "Change " .. keybindName .. " Keybind"
    PopupSubtitle.Text = "Current: " .. (KeybindNames[currentKey] or "Unknown") .. "\nPress any key to change or ESC to cancel"
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        
        if input.KeyCode == Enum.KeyCode.Escape then
            KeybindPopup.Visible = false
            currentKeybindChanging = nil
            connection:Disconnect()
            return
        end
        
        -- Update keybind
        callback(input.KeyCode)
        KeybindPopup.Visible = false
        currentKeybindChanging = nil
        connection:Disconnect()
    end)
end

PopupCancel.MouseButton1Click:Connect(function()
    KeybindPopup.Visible = false
    currentKeybindChanging = nil
end)

local function createButton(text, icon, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 45)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = ContentFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(0, 40, 1, 0)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = icon
    IconLabel.TextSize = 20
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
    IconLabel.Parent = Button
    
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -50, 1, 0)
    TextLabel.Position = UDim2.new(0, 45, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = text
    TextLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    TextLabel.TextSize = 14
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = Button
    
    local StatusIndicator = Instance.new("Frame")
    StatusIndicator.Size = UDim2.new(0, 10, 0, 10)
    StatusIndicator.Position = UDim2.new(1, -20, 0.5, -5)
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    StatusIndicator.BorderSizePixel = 0
    StatusIndicator.Parent = Button
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = StatusIndicator
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 75)}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 65)}):Play()
    end)
    
    Button.MouseButton1Click:Connect(callback)
    
    return Button, StatusIndicator, TextLabel
end

local function createButtonWithKeybind(text, icon, keybindName, callback)
    local Button, StatusIndicator, TextLabel = createButton(text, icon, callback)
    
    -- Add keybind button
    local KeybindButton = Instance.new("TextButton")
    KeybindButton.Size = UDim2.new(0, 60, 0, 25)
    KeybindButton.Position = UDim2.new(1, -90, 0.5, -12.5)
    KeybindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    KeybindButton.BorderSizePixel = 0
    KeybindButton.Text = KeybindNames[Keybinds[keybindName]] or "?"
    KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeybindButton.TextSize = 12
    KeybindButton.Font = Enum.Font.GothamBold
    KeybindButton.ZIndex = 2
    KeybindButton.Parent = Button
    
    local KeybindCorner = Instance.new("UICorner")
    KeybindCorner.CornerRadius = UDim.new(0, 6)
    KeybindCorner.Parent = KeybindButton
    
    KeybindButton.MouseButton1Click:Connect(function()
        openKeybindChanger(keybindName, Keybinds[keybindName], function(newKey)
            Keybinds[keybindName] = newKey
            KeybindButton.Text = KeybindNames[newKey] or "?"
            print("✅ " .. keybindName .. " keybind changed to: " .. (KeybindNames[newKey] or "Unknown"))
        end)
    end)
    
    KeybindButton.MouseEnter:Connect(function()
        TweenService:Create(KeybindButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 100)}):Play()
    end)
    
    KeybindButton.MouseLeave:Connect(function()
        TweenService:Create(KeybindButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
    end)
    
    return Button, StatusIndicator, KeybindButton
end

local function createToggle(text, icon, callback)
    local Button, StatusIndicator = createButton(text, icon, function() end)
    local isActive = false
    
    Button.MouseButton1Click:Connect(function()
        isActive = not isActive
        if isActive then
            TweenService:Create(StatusIndicator, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 255, 127)}):Play()
            TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 65, 55)}):Play()
        else
            TweenService:Create(StatusIndicator, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
            TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45, 45, 65)}):Play()
        end
        callback(isActive)
    end)
    
    return Button, StatusIndicator
end

local function createToggleWithKeybind(text, icon, keybindName, callback)
    local Button, StatusIndicator, TextLabel = createButton(text, icon, function() end)
    local isActive = false
    
    -- Add keybind button
    local KeybindButton = Instance.new("TextButton")
    KeybindButton.Size = UDim2.new(0, 60, 0, 25)
    KeybindButton.Position = UDim2.new(1, -90, 0.5, -12.5)
    KeybindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    KeybindButton.BorderSizePixel = 0
    KeybindButton.Text = KeybindNames[Keybinds[keybindName]] or "?"
    KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeybindButton.TextSize = 12
    KeybindButton.Font = Enum.Font.GothamBold
    KeybindButton.ZIndex = 2
    KeybindButton.Parent = Button
    
    local KeybindCorner = Instance.new("UICorner")
    KeybindCorner.CornerRadius = UDim.new(0, 6)
    KeybindCorner.Parent = KeybindButton
    
    KeybindButton.MouseButton1Click:Connect(function()
        openKeybindChanger(keybindName, Keybinds[keybindName], function(newKey)
            Keybinds[keybindName] = newKey
            KeybindButton.Text = KeybindNames[newKey] or "?"
            print("✅ " .. keybindName .. " keybind changed to: " .. (KeybindNames[newKey] or "Unknown"))
        end)
    end)
    
    KeybindButton.MouseEnter:Connect(function()
        TweenService:Create(KeybindButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 100)}):Play()
    end)
    
    KeybindButton.MouseLeave:Connect(function()
        TweenService:Create(KeybindButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
    end)
    
    Button.MouseButton1Click:Connect(function()
        isActive = not isActive
        if isActive then
            TweenService:Create(StatusIndicator, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 255, 127)}):Play()
            TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 65, 55)}):Play()
        else
            TweenService:Create(StatusIndicator, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
            TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45, 45, 65)}):Play()
        end
        callback(isActive)
    end)
    
    return Button, StatusIndicator, KeybindButton
end

local function createSlider(text, min, max, default, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 60)
    Container.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    Container.BorderSizePixel = 0
    Container.Parent = ContentFrame
    
    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 8)
    ContainerCorner.Parent = Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 25)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container
    
    local SliderBack = Instance.new("Frame")
    SliderBack.Size = UDim2.new(1, -20, 0, 6)
    SliderBack.Position = UDim2.new(0, 10, 1, -15)
    SliderBack.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    SliderBack.BorderSizePixel = 0
    SliderBack.Parent = Container
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(1, 0)
    SliderCorner.Parent = SliderBack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBack
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(1, 0, 1, 0)
    SliderButton.BackgroundTransparency = 1
    SliderButton.Text = ""
    SliderButton.Parent = SliderBack
    
    local dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mousePos = UserInputService:GetMouseLocation()
            local relativePos = mousePos.X - SliderBack.AbsolutePosition.X
            local percentage = math.clamp(relativePos / SliderBack.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * percentage)
            
            SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            Label.Text = text .. ": " .. value
            callback(value)
        end
    end)
    
    return Container
end

local function createDropdown(text, options, default, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 45)
    Container.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    Container.BorderSizePixel = 0
    Container.Parent = ContentFrame
    
    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 8)
    ContainerCorner.Parent = Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, -10, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container
    
    local DropButton = Instance.new("TextButton")
    DropButton.Size = UDim2.new(0.5, -10, 0, 30)
    DropButton.Position = UDim2.new(0.5, 0, 0.5, -15)
    DropButton.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    DropButton.BorderSizePixel = 0
    DropButton.Text = default .. " ▼"
    DropButton.TextColor3 = Color3.fromRGB(220, 220, 220)
    DropButton.TextSize = 12
    DropButton.Font = Enum.Font.Gotham
    DropButton.Parent = Container
    
    local DropCorner = Instance.new("UICorner")
    DropCorner.CornerRadius = UDim.new(0, 6)
    DropCorner.Parent = DropButton
    
    local DropList = Instance.new("Frame")
    DropList.Size = UDim2.new(0.5, -10, 0, #options * 30)
    DropList.Position = UDim2.new(0.5, 0, 1, 5)
    DropList.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    DropList.BorderSizePixel = 0
    DropList.Visible = false
    DropList.ZIndex = 10
    DropList.Parent = Container
    
    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 6)
    ListCorner.Parent = DropList
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = DropList
    
    DropButton.MouseButton1Click:Connect(function()
        DropList.Visible = not DropList.Visible
        Container.Size = UDim2.new(1, 0, 0, DropList.Visible and (45 + #options * 30 + 5) or 45)
    end)
    
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 30)
        OptionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = option
        OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        OptionButton.TextSize = 11
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.Parent = DropList
        
        OptionButton.MouseButton1Click:Connect(function()
            DropButton.Text = option .. " ▼"
            DropList.Visible = false
            Container.Size = UDim2.new(1, 0, 0, 45)
            callback(option)
        end)
    end
    
    return Container
end

-- FOV Circle for Aimbot (Single RGB circle)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 100
FOVCircle.Radius = Config.AimbotFOV
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Visible = false
FOVCircle.Filled = false
FOVCircle.Transparency = 1

-- RGB Animation values
local rgbHue = 0

-- Game Functions
local function getCharacter()
    return LocalPlayer.Character
end

local function getHumanoidRootPart()
    local char = getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getTargetPart(player)
    if not player.Character then return nil end
    
    if Config.AimbotTarget == "Head" then
        return player.Character:FindFirstChild("Head")
    elseif Config.AimbotTarget == "Body" then
        return player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
    elseif Config.AimbotTarget == "Legs+Body" then
        return player.Character:FindFirstChild("HumanoidRootPart")
    elseif Config.AimbotTarget == "Body+Head" then
        local head = player.Character:FindFirstChild("Head")
        local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
        return head or torso
    elseif Config.AimbotTarget == "All" then
        return player.Character:FindFirstChild("HumanoidRootPart")
    end
end

local function isInFOV(targetPos)
    local viewportSize = Camera.ViewportSize
    local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    
    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
    if not onScreen then return false end
    
    local screenPosition = Vector2.new(screenPos.X, screenPos.Y)
    local distance = (screenPosition - screenCenter).Magnitude
    
    return distance <= Config.AimbotFOV
end

local function getNearestPlayerInFOV()
    local nearestPlayer = nil
    local shortestDistance = math.huge
    local viewportSize = Camera.ViewportSize
    local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetPart = getTargetPart(player)
            if targetPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen and isInFOV(targetPart.Position) then
                    local screenPosition = Vector2.new(screenPos.X, screenPos.Y)
                    local distance = (screenPosition - screenCenter).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        nearestPlayer = player
                    end
                end
            end
        end
    end
    
    return nearestPlayer
end

local function getNearestPlayer()
    local nearestPlayer = nil
    local shortestDistance = math.huge
    local myRootPart = getHumanoidRootPart()
    
    if not myRootPart then return nil end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local theirRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if theirRootPart then
                local distance = (myRootPart.Position - theirRootPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestPlayer = player
                end
            end
        end
    end
    
    return nearestPlayer
end

local function getNearestCar()
    local nearestCar = nil
    local shortestDistance = math.huge
    local myRootPart = getHumanoidRootPart()
    
    if not myRootPart then return nil end
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("VehicleSeat") or (obj:IsA("Model") and obj:FindFirstChild("VehicleSeat")) then
            local model = obj:IsA("Model") and obj or obj.Parent
            local primaryPart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            
            if primaryPart then
                local distance = (myRootPart.Position - primaryPart.Position).Magnitude
                if distance < shortestDistance and distance < 100 then
                    shortestDistance = distance
                    nearestCar = model
                end
            end
        end
    end
    
    return nearestCar
end

local function getAllNearbyPlayers(radius)
    local nearbyPlayers = {}
    local myRootPart = getHumanoidRootPart()
    
    if not myRootPart then return nearbyPlayers end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local theirRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if theirRootPart then
                local distance = (myRootPart.Position - theirRootPart.Position).Magnitude
                if distance <= radius then
                    table.insert(nearbyPlayers, player)
                end
            end
        end
    end
    
    return nearbyPlayers
end

-- Feature Functions
local function flingPlayer(targetPlayer)
    local char = getCharacter()
    local myRootPart = getHumanoidRootPart()
    
    if not char or not myRootPart then return end
    if not targetPlayer or not targetPlayer.Character then return end
    
    local targetRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRootPart then return end
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, Config.FlingPower, 0)
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Parent = myRootPart
    
    myRootPart.CFrame = targetRootPart.CFrame
    
    wait(0.1)
    
    bodyVelocity:Destroy()
    myRootPart.CFrame = myRootPart.CFrame + Vector3.new(0, 5, 0)
end

local function flingNearestPlayer()
    local target = getNearestPlayer()
    if target then
        flingPlayer(target)
        print("🎯 Flinging: " .. target.Name)
    else
        print("❌ No nearby players found")
    end
end

local function flingAllNearby()
    local nearbyPlayers = getAllNearbyPlayers(Config.FlingAllRadius)
    
    if #nearbyPlayers == 0 then
        print("❌ No nearby players found")
        return
    end
    
    print("💥 Flinging " .. #nearbyPlayers .. " nearby players")
    
    for _, player in pairs(nearbyPlayers) do
        spawn(function()
            flingPlayer(player)
        end)
        wait(0.5)
    end
end

-- Aimbot (FIXED - Single RGB circle, only locks players in front)
local aimbotConnection = nil
local fovUpdateConnection = nil

local function startAimbot()
    Config.AimbotEnabled = true
    
    -- Separate connection for FOV circle updates with RGB animation
    fovUpdateConnection = RunService.RenderStepped:Connect(function()
        local viewportSize = Camera.ViewportSize
        local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
        
        -- Update circle position and radius
        FOVCircle.Position = screenCenter
        FOVCircle.Radius = Config.AimbotFOV
        FOVCircle.Visible = true
        
        -- RGB color animation
        rgbHue = rgbHue + 0.01
        if rgbHue >= 1 then
            rgbHue = 0
        end
        FOVCircle.Color = Color3.fromHSV(rgbHue, 1, 1)
    end)
    
    -- Main aimbot logic
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not Config.AimbotEnabled then return end
        
        -- Only target players within the FOV circle and in front
        local target = getNearestPlayerInFOV()
        if not target or not target.Character then return end
        
        local targetPart = getTargetPart(target)
        if not targetPart then return end
        
        -- Verify target is in front of camera (not behind)
        local cameraLookVector = Camera.CFrame.LookVector
        local targetDirection = (targetPart.Position - Camera.CFrame.Position).Unit
        local dotProduct = cameraLookVector:Dot(targetDirection)
        
        -- Only lock if target is in front (dot product > 0)
        if dotProduct <= 0 then return end
        
        -- Double check if target is still in FOV
        if not isInFOV(targetPart.Position) then return end
        
        -- Smoothly aim at target
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
    end)
    
    print("🎯 Aimbot enabled (RGB circle, only targets players in FOV)")
end

local function stopAimbot()
    Config.AimbotEnabled = false
    FOVCircle.Visible = false
    
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
    
    if fovUpdateConnection then
        fovUpdateConnection:Disconnect()
        fovUpdateConnection = nil
    end
    
    print("❌ Aimbot disabled")
end

-- Fly
local flyConnection = nil
local flyBodyVelocity = nil
local flyBodyGyro = nil

local function startFly()
    local char = getCharacter()
    local myRootPart = getHumanoidRootPart()
    
    if not char or not myRootPart then return end
    
    Config.FlyEnabled = true
    
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyVelocity.Parent = myRootPart
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyGyro.P = 9000
    flyBodyGyro.Parent = myRootPart
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not Config.FlyEnabled then return end
        
        local myRootPart = getHumanoidRootPart()
        if not myRootPart then return end
        
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        flyBodyVelocity.Velocity = moveDirection * Config.FlySpeed
        flyBodyGyro.CFrame = Camera.CFrame
    end)
    
    print("✈️ Fly enabled")
end

local function stopFly()
    Config.FlyEnabled = false
    
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
    
    if flyBodyGyro then
        flyBodyGyro:Destroy()
        flyBodyGyro = nil
    end
    
    print("❌ Fly disabled")
end

-- Car Throwing
local function throwCar()
    local nearestCar = getNearestCar()
    local myRootPart = getHumanoidRootPart()
    
    if not nearestCar then
        print("❌ No nearby car found")
        return
    end
    
    if not myRootPart then return end
    
    print("🚗 Throwing car: " .. nearestCar.Name)
    
    for _, part in pairs(nearestCar:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = false
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Camera.CFrame.LookVector * Config.ThrowPower + Vector3.new(0, 50, 0)
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Parent = part
            
            game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
        end
    end
end

-- Backshots Feature (Realistic back and forth motion)
local backshotsConnection = nil
local backshotsTarget = nil
local backshotsCurrentDistance = 0
local backshotsMovingForward = true

local function startBackshots()
    Config.BackshotsEnabled = true
    backshotsTarget = getNearestPlayer()
    backshotsCurrentDistance = Config.BackshotsDistance
    backshotsMovingForward = true
    
    if not backshotsTarget then
        print("❌ No player found for backshots")
        Config.BackshotsEnabled = false
        return
    end
    
    print("😈 Backshots activated on: " .. backshotsTarget.Name)
    
    backshotsConnection = RunService.RenderStepped:Connect(function()
        if not Config.BackshotsEnabled then return end
        
        local myRootPart = getHumanoidRootPart()
        if not myRootPart then return end
        
        if not backshotsTarget or not backshotsTarget.Character then
            Config.BackshotsEnabled = false
            return
        end
        
        local targetRootPart = backshotsTarget.Character:FindFirstChild("HumanoidRootPart")
        if not targetRootPart then return end
        
        -- Animate back and forth movement
        if backshotsMovingForward then
            backshotsCurrentDistance = backshotsCurrentDistance - (Config.BackshotsSpeed * 0.1)
            if backshotsCurrentDistance <= 0.5 then
                backshotsMovingForward = false
            end
        else
            backshotsCurrentDistance = backshotsCurrentDistance + (Config.BackshotsSpeed * 0.1)
            if backshotsCurrentDistance >= Config.BackshotsDistance then
                backshotsMovingForward = true
            end
        end
        
        -- Position behind the target with animated distance
        local behindPosition = targetRootPart.CFrame * CFrame.new(0, 0, backshotsCurrentDistance)
        
        -- Keep character facing the target's back
        local lookAtTarget = CFrame.new(behindPosition.Position, targetRootPart.Position)
        
        myRootPart.CFrame = lookAtTarget
        
        -- Lock camera to view from behind and slightly above
        local cameraOffset = targetRootPart.CFrame * CFrame.new(0, 3, Config.BackshotsDistance + 2)
        Camera.CFrame = CFrame.new(cameraOffset.Position, targetRootPart.Position)
    end)
end

local function stopBackshots()
    Config.BackshotsEnabled = false
    backshotsTarget = nil
    backshotsCurrentDistance = 0
    backshotsMovingForward = true
    
    if backshotsConnection then
        backshotsConnection:Disconnect()
        backshotsConnection = nil
    end
    
    print("❌ Backshots disabled")
end

-- Create Tabs
local combatTab = createTab("Combat", "⚔️", 1)
local movementTab = createTab("Movement", "🏃", 2)
local trollTab = createTab("Troll", "😈", 3)

local currentTab = "Combat"

local function showTab(tabName)
    for _, child in pairs(ContentFrame:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
    
    currentTab = tabName
    
    if tabName == "Combat" then
        combatTab.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        combatTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        movementTab.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        movementTab.TextColor3 = Color3.fromRGB(200, 200, 200)
        trollTab.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        trollTab.TextColor3 = Color3.fromRGB(200, 200, 200)
        
        createToggleWithKeybind("Aimbot", "🎯", "Aimbot", function(enabled)
            if enabled then
                startAimbot()
            else
                stopAimbot()
            end
        end)
        
        createDropdown("Aimbot Target", {"Head", "Body", "Legs+Body", "Body+Head", "All"}, "Head", function(value)
            Config.AimbotTarget = value
            print("🎯 Aimbot target: " .. value)
        end)
        
        createSlider("Aimbot FOV", 50, 500, Config.AimbotFOV, function(value)
            Config.AimbotFOV = value
        end)
        
    elseif tabName == "Movement" then
        combatTab.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        combatTab.TextColor3 = Color3.fromRGB(200, 200, 200)
        movementTab.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        movementTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        trollTab.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        trollTab.TextColor3 = Color3.fromRGB(200, 200, 200)
        
        createToggleWithKeybind("Fly Mode", "✈️", "Fly", function(enabled)
            if enabled then
                startFly()
            else
                stopFly()
            end
        end)
        
        createSlider("Fly Speed", 50, 300, Config.FlySpeed, function(value)
            Config.FlySpeed = value
        end)
        
    elseif tabName == "Troll" then
        combatTab.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        combatTab.TextColor3 = Color3.fromRGB(200, 200, 200)
        movementTab.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        movementTab.TextColor3 = Color3.fromRGB(200, 200, 200)
        trollTab.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        trollTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        createToggleWithKeybind("Backshots Mode", "😈", "Backshots", function(enabled)
            if enabled then
                startBackshots()
            else
                stopBackshots()
            end
        end)
        
        createSlider("Backshots Distance", 2, 8, Config.BackshotsDistance, function(value)
            Config.BackshotsDistance = value
        end)
        
        createSlider("Backshots Speed", 0.5, 5, Config.BackshotsSpeed, function(value)
            Config.BackshotsSpeed = value
        end)
        
        createButtonWithKeybind("Fling Nearest", "💥", "FlingNearest", flingNearestPlayer)
        
        createButtonWithKeybind("Fling All Nearby", "💫", "FlingAll", flingAllNearby)
        
        createButtonWithKeybind("Throw Car", "🚗", "ThrowCar", throwCar)
        
        createSlider("Fling Power", 100, 1000, Config.FlingPower, function(value)
            Config.FlingPower = value
        end)
    end
end

combatTab.MouseButton1Click:Connect(function() showTab("Combat") end)
movementTab.MouseButton1Click:Connect(function() showTab("Movement") end)
trollTab.MouseButton1Click:Connect(function() showTab("Troll") end)

-- Show Combat tab by default
showTab("Combat")

-- Keyboard Shortcuts (using customizable keybinds)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or currentKeybindChanging then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    
    -- Check each keybind dynamically
    for action, keyCode in pairs(Keybinds) do
        if input.KeyCode == keyCode then
            if action == "FlingNearest" then
                flingNearestPlayer()
            elseif action == "Aimbot" then
                if Config.AimbotEnabled then
                    stopAimbot()
                else
                    startAimbot()
                end
            elseif action == "Fly" then
                if Config.FlyEnabled then
                    stopFly()
                else
                    startFly()
                end
            elseif action == "ThrowCar" then
                throwCar()
            elseif action == "FlingAll" then
                flingAllNearby()
            elseif action == "Backshots" then
                if Config.BackshotsEnabled then
                    stopBackshots()
                else
                    startBackshots()
                end
            end
            break
        end
    end
end)

-- Cleanup
LocalPlayer.CharacterAdded:Connect(function()
    stopFly()
    stopAimbot()
    stopBackshots()
end)

print("✅ Rpyf Troll Script loaded! (COMPLETE FIXED VERSION)")
print("📋 Hotkeys (customizable):")
print("F - Fling Nearest | G - Aimbot | H - Fly")
print("T - Throw Car | R - Fling All | B - Backshots")
print("💡 Click the keybind buttons in GUI to customize!")
print("😈 Made by Rpyf")
