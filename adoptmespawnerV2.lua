-- Remove old GUI if it exists
if game.CoreGui:FindFirstChild("PSX_LoadingScreen") then
    game.CoreGui.PSX_LoadingScreen:Destroy()
end

-- Services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Create loading screen
local loadingScreen = Instance.new("ScreenGui")
loadingScreen.Parent = game.CoreGui
loadingScreen.Name = "PSX_LoadingScreen"
loadingScreen.IgnoreGuiInset = true
loadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Background
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.Position = UDim2.new(0, 0, 0, 0)
background.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
background.Parent = loadingScreen

-- Container
local container = Instance.new("Frame")
container.Size = UDim2.new(0.6, 0, 0.7, 0)
container.Position = UDim2.new(0.2, 0, 0.15, 0)
container.BackgroundTransparency = 1
container.Parent = background

-- Logo
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 150, 0, 150)
logo.Position = UDim2.new(0.5, -75, 0.1, 0)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://87916870577105"
logo.Parent = container

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.Position = UDim2.new(0, 0, 0.4, 0)
title.Text = "LOADING"
title.TextSize = 36
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = container

-- Progress container
local progressContainer = Instance.new("Frame")
progressContainer.Size = UDim2.new(1, 0, 0, 100)
progressContainer.Position = UDim2.new(0, 0, 0.7, 0)
progressContainer.BackgroundTransparency = 1
progressContainer.Parent = container

-- Progress bar background
local progressBarBackground = Instance.new("Frame")
progressBarBackground.Size = UDim2.new(1, 0, 0, 20)
progressBarBackground.Position = UDim2.new(0, 0, 0.5, -10)
progressBarBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
progressBarBackground.BorderSizePixel = 0
progressBarBackground.Parent = progressContainer

local progressBarCorner = Instance.new("UICorner")
progressBarCorner.CornerRadius = UDim.new(1, 0)
progressBarCorner.Parent = progressBarBackground

-- Progress bar
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBarBackground

local progressBarInnerCorner = Instance.new("UICorner")
progressBarInnerCorner.CornerRadius = UDim.new(1, 0)
progressBarInnerCorner.Parent = progressBar

-- Percentage
local percentageLabel = Instance.new("TextLabel")
percentageLabel.Size = UDim2.new(1, 0, 0, 40)
percentageLabel.Position = UDim2.new(0, 0, 0.1, 0)
percentageLabel.Text = "0%"
percentageLabel.TextSize = 24
percentageLabel.Font = Enum.Font.GothamBold
percentageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
percentageLabel.BackgroundTransparency = 1
percentageLabel.Parent = progressContainer

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0.9, 0)
statusLabel.Text = "Starting..."
statusLabel.TextSize = 16
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
statusLabel.BackgroundTransparency = 1
statusLabel.Parent = progressContainer

-- Update progress function
local function UpdateProgress(percent, status)
    TweenService:Create(progressBar, TweenInfo.new(0.2), {
        Size = UDim2.new(percent / 100, 0, 1, 0)
    }):Play()
    
    percentageLabel.Text = math.floor(percent) .. "%"
    if status then
        statusLabel.Text = status
    end
end

-- Main loading function
local function StartLoading()
    local stages = {
        {time = 0.5, percent = 5, status = "Initializing..."},
        {time = 0.5, percent = 10, status = "Loading core..."},
        {time = 0.5, percent = 15, status = "Setting up..."},
        {time = 1, percent = 20, status = "Checking game..."},
        {time = 0.5, percent = 25, status = "Connecting..."},
        {time = 0.5, percent = 30, status = "Security check..."},
        {time = 1, percent = 35, status = "Loading modules..."},
        {time = 0.5, percent = 40, status = "Preparing UI..."},
        {time = 0.5, percent = 45, status = "Loading assets..."},
        {time = 1, percent = 50, status = "Halfway done..."},
        {time = 0.5, percent = 55, status = "Optimizing..."},
        {time = 0.5, percent = 60, status = "Configuring..."},
        {time = 1, percent = 65, status = "Loading features..."},
        {time = 0.5, percent = 70, status = "Final checks..."},
        {time = 0.5, percent = 75, status = "Preparing to load..."},
        {time = 1, percent = 80, status = "Almost done..."},
        {time = 0.5, percent = 85, status = "Finalizing..."},
        {time = 0.5, percent = 90, status = "Getting ready..."},
        {time = 1, percent = 95, status = "Ready to launch..."},
        {time = 0.5, percent = 100, status = "Complete!"}
    }
    
    local totalTime = 0
    for _, stage in ipairs(stages) do
        totalTime = totalTime + stage.time
    end
    
    local startTime = tick()
    local currentPercent = 0
    
    for _, stage in ipairs(stages) do
        UpdateProgress(stage.percent, stage.status)
        currentPercent = stage.percent
        task.wait(stage.time)
    end
    
    -- Fade out
    task.wait(0.5)
    
    TweenService:Create(background, TweenInfo.new(0.5), {
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(title, TweenInfo.new(0.5), {
        TextTransparency = 1
    }):Play()
    
    TweenService:Create(logo, TweenInfo.new(0.5), {
        ImageTransparency = 1
    }):Play()
    
    TweenService:Create(percentageLabel, TweenInfo.new(0.5), {
        TextTransparency = 1
    }):Play()
    
    TweenService:Create(statusLabel, TweenInfo.new(0.5), {
        TextTransparency = 1
    }):Play()
    
    TweenService:Create(progressBarBackground, TweenInfo.new(0.5), {
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(progressBar, TweenInfo.new(0.5), {
        BackgroundTransparency = 1
    }):Play()
    
    task.wait(0.5)
    
    -- LOAD MAIN SCRIPT HERE
    local success, errorMessage = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/b1-byte21312341/hhh/refs/heads/main/1.lua"))()
    end)
    
    if not success then
        warn("Loadstring error:", errorMessage)
    end
    
    -- Destroy loading screen
    loadingScreen:Destroy()
end

-- Start loading immediately
StartLoading()
