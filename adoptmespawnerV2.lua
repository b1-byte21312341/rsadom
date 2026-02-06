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

-- Background with animated gradient
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.Position = UDim2.new(0, 0, 0, 0)
background.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
background.Parent = loadingScreen

-- Animated gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 15, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 30))
})
gradient.Rotation = 0
gradient.Parent = background

-- Gradient animation
task.spawn(function()
    while loadingScreen.Parent do
        for i = 0, 360, 3 do
            gradient.Rotation = i
            task.wait(0.03)
        end
    end
end)

-- Starry sky
local starsContainer = Instance.new("Frame")
starsContainer.Size = UDim2.new(1, 0, 1, 0)
starsContainer.BackgroundTransparency = 1
starsContainer.Parent = background

-- Create stars
for i = 1, 80 do
    local star = Instance.new("Frame")
    star.Size = UDim2.new(0, math.random(1, 3), 0, math.random(1, 3))
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.fromRGB(
        math.random(200, 255),
        math.random(200, 255),
        math.random(200, 255)
    )
    star.BackgroundTransparency = math.random(50, 80) / 100
    star.BorderSizePixel = 0
    star.ZIndex = 1
    star.Parent = starsContainer
    
    -- Star twinkling animation
    task.spawn(function()
        while loadingScreen.Parent do
            local targetTrans = math.random(50, 90) / 100
            TweenService:Create(star, TweenInfo.new(math.random(0.5, 1.5)), {
                BackgroundTransparency = targetTrans
            }):Play()
            task.wait(math.random(0.5, 1.5))
        end
    end)
end

-- Central container
local container = Instance.new("Frame")
container.Size = UDim2.new(0.7, 0, 0.8, 0)
container.Position = UDim2.new(0.15, 0, 0.1, 0)
container.BackgroundTransparency = 1
container.Parent = background

-- Logo with holographic effect
local logoContainer = Instance.new("Frame")
logoContainer.Size = UDim2.new(0, 250, 0, 250)
logoContainer.Position = UDim2.new(0.5, -125, 0.1, 0)
logoContainer.BackgroundTransparency = 1
logoContainer.Parent = container

-- Holographic rings (fewer for faster performance)
for i = 1, 2 do
    local ring = Instance.new("ImageLabel")
    ring.Size = UDim2.new(1, i * 30, 1, i * 30)
    ring.Position = UDim2.new(0, -i * 15, 0, -i * 15)
    ring.BackgroundTransparency = 1
    ring.Image = "rbxassetid://3570695787"
    ring.ImageColor3 = Color3.fromHSV(i/3, 0.7, 1)
    ring.ImageTransparency = 0.8
    ring.ZIndex = 0
    ring.Parent = logoContainer
    
    -- Ring rotation
    task.spawn(function()
        local speed = 0.8 + (i * 0.3)
        local direction = i % 2 == 0 and 1 or -1
        while loadingScreen.Parent do
            ring.Rotation = (ring.Rotation + (speed * direction)) % 360
            task.wait()
        end
    end)
end

-- Main logo
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(1, 0, 1, 0)
logo.Position = UDim2.new(0, 0, 0, 0)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://87916870577105"
logo.ImageColor3 = Color3.fromRGB(255, 255, 255)
logo.ZIndex = 2
logo.Parent = logoContainer

-- Logo pulse animation
task.spawn(function()
    while loadingScreen.Parent do
        TweenService:Create(logo, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(1.05, 0, 1.05, 0),
            Position = UDim2.new(-0.025, 0, -0.025, 0)
        }):Play()
        task.wait(1.2)
        TweenService:Create(logo, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
        task.wait(1.2)
    end
end)

-- Main title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 70)
title.Position = UDim2.new(0, 0, 0.45, 0)
title.Text = "PSX LOADER"
title.TextSize = 42
title.Font = Enum.Font.GothamBlack
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextStrokeTransparency = 0.3
title.TextStrokeColor3 = Color3.fromRGB(0, 80, 160)
title.TextStrokeThickness = 2
title.ZIndex = 3
title.Parent = container

-- Title color animation
task.spawn(function()
    while loadingScreen.Parent do
        for hue = 0, 1, 0.01 do
            title.TextColor3 = Color3.fromHSV(hue, 0.7, 1)
            task.wait(0.05)
        end
    end
end)

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 35)
subtitle.Position = UDim2.new(0, 0, 0.6, 0)
subtitle.Text = "Loading Script..."
subtitle.TextSize = 20
subtitle.Font = Enum.Font.GothamMedium
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = Color3.fromRGB(180, 200, 255)
subtitle.TextTransparency = 0.1
subtitle.ZIndex = 3
subtitle.Parent = container

-- Progress bar container
local progressContainer = Instance.new("Frame")
progressContainer.Size = UDim2.new(1, 0, 0, 100)
progressContainer.Position = UDim2.new(0, 0, 0.75, 0)
progressContainer.BackgroundTransparency = 1
progressContainer.Parent = container

-- Progress bar background
local progressBarBackground = Instance.new("Frame")
progressBarBackground.Size = UDim2.new(1, 0, 0, 16)
progressBarBackground.Position = UDim2.new(0, 0, 0.5, -8)
progressBarBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
progressBarBackground.BorderSizePixel = 0
progressBarBackground.ZIndex = 3
progressBarBackground.Parent = progressContainer

local progressBarCorner = Instance.new("UICorner")
progressBarCorner.CornerRadius = UDim.new(1, 0)
progressBarCorner.Parent = progressBarBackground

-- Progress bar
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
progressBar.BorderSizePixel = 0
progressBar.ZIndex = 4
progressBar.Parent = progressBarBackground

local progressBarInnerCorner = Instance.new("UICorner")
progressBarInnerCorner.CornerRadius = UDim.new(1, 0)
progressBarInnerCorner.Parent = progressBar

-- Progress bar gradient
local progressGradient = Instance.new("UIGradient")
progressGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 180))
})
progressGradient.Rotation = 45
progressGradient.Parent = progressBar

-- Progress bar gradient animation
task.spawn(function()
    while loadingScreen.Parent do
        for i = 0, 360, 6 do
            progressGradient.Rotation = i
            task.wait(0.05)
        end
    end
end)

-- Progress bar glow
local progressGlow = Instance.new("ImageLabel")
progressGlow.Size = UDim2.new(1, 30, 2.5, 0)
progressGlow.Position = UDim2.new(0, -15, -0.75, 0)
progressGlow.BackgroundTransparency = 1
progressGlow.Image = "rbxassetid://4996891970"
progressGlow.ImageColor3 = Color3.fromRGB(0, 100, 255)
progressGlow.ImageTransparency = 0.8
progressGlow.ScaleType = Enum.ScaleType.Slice
progressGlow.SliceCenter = Rect.new(49, 49, 450, 450)
progressGlow.ZIndex = 2
progressGlow.Parent = progressBar

-- Percentage label
local percentageLabel = Instance.new("TextLabel")
percentageLabel.Size = UDim2.new(1, 0, 0, 40)
percentageLabel.Position = UDim2.new(0, 0, 0.1, 0)
percentageLabel.Text = "0%"
percentageLabel.TextSize = 28
percentageLabel.Font = Enum.Font.GothamBlack
percentageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
percentageLabel.BackgroundTransparency = 1
percentageLabel.TextStrokeTransparency = 0.2
percentageLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
percentageLabel.ZIndex = 3
percentageLabel.Parent = progressContainer

-- Status text
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0.9, 0)
statusLabel.Text = "Initializing..."
statusLabel.TextSize = 16
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
statusLabel.BackgroundTransparency = 1
statusLabel.TextTransparency = 0.1
statusLabel.ZIndex = 3
statusLabel.Parent = progressContainer

-- Version info
local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(0, 180, 0, 25)
versionLabel.Position = UDim2.new(1, -190, 1, -30)
versionLabel.Text = "v2.1 | Fast Load"
versionLabel.TextSize = 13
versionLabel.Font = Enum.Font.GothamMedium
versionLabel.BackgroundTransparency = 1
versionLabel.TextColor3 = Color3.fromRGB(150, 180, 220)
versionLabel.TextTransparency = 0.3
versionLabel.TextXAlignment = Enum.TextXAlignment.Right
versionLabel.Parent = container

-- Loading dots animation
local loadingDots = Instance.new("TextLabel")
loadingDots.Size = UDim2.new(0, 50, 0, 30)
loadingDots.Position = UDim2.new(0.5, -25, 0.68, 0)
loadingDots.Text = "..."
loadingDots.TextSize = 24
loadingDots.Font = Enum.Font.GothamBold
loadingDots.TextColor3 = Color3.fromRGB(0, 200, 255)
loadingDots.BackgroundTransparency = 1
loadingDots.ZIndex = 3
loadingDots.Parent = container

task.spawn(function()
    local dots = {".", "..", "...", "...."}
    local index = 1
    while loadingScreen.Parent do
        loadingDots.Text = dots[index]
        index = index % #dots + 1
        task.wait(0.5)
    end
end)

-- Function to update progress
local function UpdateProgress(percent, status)
    TweenService:Create(progressBar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(percent / 100, 0, 1, 0)
    }):Play()
    
    percentageLabel.Text = string.format("%d%%", math.floor(percent))
    if status then
        statusLabel.Text = status
    end
end

-- Function to load main script via loadstring
local function LoadMainScriptViaHttp()
    -- REPLACE THIS WITH YOUR ACTUAL GITHUB URL
    local mainScriptURL = "https://raw.githubusercontent.com/b1-byte21312341/hhh/refs/heads/main/1.lua"
    
    local success, errorMessage = pcall(function()
        -- Load the main script from GitHub
        loadstring(game:HttpGet(mainScriptURL))()
    end)
    
    if not success then
        warn("Error loading main script:", errorMessage)
        
        -- Show error message
        local errorMsg = Instance.new("TextLabel")
        errorMsg.Size = UDim2.new(0.6, 0, 0, 80)
        errorMsg.Position = UDim2.new(0.2, 0, 0.5, -40)
        errorMsg.Text = "❌ LOAD ERROR:\n" .. errorMessage:sub(1, 100) .. "..."
        errorMsg.TextSize = 14
        errorMsg.Font = Enum.Font.Gotham
        errorMsg.TextColor3 = Color3.fromRGB(255, 50, 50)
        errorMsg.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
        errorMsg.TextWrapped = true
        errorMsg.Parent = background
        errorMsg.ZIndex = 100
    end
end

-- Main loading sequence (30 seconds)
task.spawn(function()
    local startTime = tick()
    local totalDuration = 30 -- 30 seconds
    
    -- Loading stages for 30 seconds
    local loadingStages = {
        -- Stage 1: Quick initialization (0-20%)
        {percent = 0, status = "🚀 Starting loader..."},
        {percent = 5, status = "🔧 Loading core..."},
        {percent = 10, status = "⚙️ Setting up..."},
        {percent = 15, status = "📁 Loading modules..."},
        {percent = 20, status = "🔍 Scanning game..."},
        
        -- Stage 2: Preparation (20-50%)
        {percent = 25, status = "🌐 Connecting..."},
        {percent = 30, status = "🔐 Security check..."},
        {percent = 35, status = "💾 Memory allocated..."},
        {percent = 40, status = "⚡ Optimizing..."},
        {percent = 45, status = "🔄 Syncing data..."},
        
        -- Stage 3: Loading (50-80%)
        {percent = 50, status = "📦 Loading assets..."},
        {percent = 55, status = "🎮 Interface ready..."},
        {percent = 60, status = "✨ Effects loaded..."},
        {percent = 65, status = "🔧 Utilities ready..."},
        {percent = 70, status = "⚙️ Configuring..."},
        
        -- Stage 4: Final preparation (80-95%)
        {percent = 75, status = "🚀 Preparing launch..."},
        {percent = 80, status = "🔗 Connecting to GitHub..."},
        {percent = 85, status = "📥 Downloading script..."},
        {percent = 90, status = "✅ Verifying..."},
        {percent = 95, status = "⚡ Finalizing..."},
        
        -- Stage 5: Completion (95-100%)
        {percent = 98, status = "🚀 Ready to launch..."},
        {percent = 99, status = "🔥 Almost there..."},
        {percent = 100, status = "✅ LOADED!"}
    }
    
    local currentStage = 1
    local lastPercent = 0
    
    while tick() - startTime < totalDuration do
        local elapsed = tick() - startTime
        local progressPercent = math.min(99, (elapsed / totalDuration) * 100)
        
        -- Find current stage
        for i = #loadingStages, 1, -1 do
            if progressPercent >= loadingStages[i].percent then
                if currentStage ~= i then
                    currentStage = i
                    UpdateProgress(loadingStages[i].percent, loadingStages[i].status)
                end
                break
            end
        end
        
        -- Smooth percentage display
        if currentStage < #loadingStages then
            local nextStage = loadingStages[currentStage + 1]
            local stageStart = loadingStages[currentStage].percent
            local stageEnd = nextStage.percent
            local stageProgress = (progressPercent - stageStart) / (stageEnd - stageStart)
            
            local displayPercent = stageStart + (stageEnd - stageStart) * stageProgress
            percentageLabel.Text = string.format("%d%%", math.floor(displayPercent))
        end
        
        -- Faster updates for 30-second loading
        task.wait(0.05)
    end
    
    -- Final 100%
    UpdateProgress(100, "✅ LOADED!")
    
    -- Short pause
    task.wait(0.8)
    
    -- Fast fade out animation
    local fadeTime = 0.8
    
    -- Hide everything
    TweenService:Create(title, TweenInfo.new(fadeTime), {
        TextTransparency = 1,
        TextStrokeTransparency = 1
    }):Play()
    
    TweenService:Create(subtitle, TweenInfo.new(fadeTime), {
        TextTransparency = 1
    }):Play()
    
    TweenService:Create(loadingDots, TweenInfo.new(fadeTime), {
        TextTransparency = 1
    }):Play()
    
    TweenService:Create(logo, TweenInfo.new(fadeTime), {
        ImageTransparency = 1
    }):Play()
    
    TweenService:Create(percentageLabel, TweenInfo.new(fadeTime), {
        TextTransparency = 1,
        TextStrokeTransparency = 1
    }):Play()
    
    TweenService:Create(statusLabel, TweenInfo.new(fadeTime), {
        TextTransparency = 1
    }):Play()
    
    TweenService:Create(progressBarBackground, TweenInfo.new(fadeTime), {
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(versionLabel, TweenInfo.new(fadeTime), {
        TextTransparency = 1
    }):Play()
    
    -- Move up animation
    TweenService:Create(container, TweenInfo.new(fadeTime, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(0.15, 0, -1, 0)
    }):Play()
    
    task.wait(fadeTime)
    
    -- LOAD MAIN SCRIPT VIA LOADSTRING - AT THE VERY END
    LoadMainScriptViaHttp()
    
    -- Remove loading screen quickly
    task.wait(0.3)
    loadingScreen:Destroy()
end)

-- Tips that show during loading
local tips = {
    "⚡ Fast 30-second loading",
    "🔒 Secure connection",
    "✨ Premium features",
    "🚀 Quick launch",
    "🎮 Optimized for games"
}

-- Show random tips
task.spawn(function()
    while loadingScreen.Parent do
        task.wait(5) -- Change tip every 5 seconds
        local randomTip = tips[math.random(#tips)]
        if not statusLabel.Text:find("✅") then
            statusLabel.Text = randomTip
        end
    end
end)
