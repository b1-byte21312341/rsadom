if game.CoreGui:FindFirstChild("PSX_LoadingScreen") then
    game.CoreGui.PSX_LoadingScreen:Destroy()
end

local TweenService = game:GetService("TweenService")

local loadingScreen = Instance.new("ScreenGui")
loadingScreen.Parent = game.CoreGui
loadingScreen.Name = "PSX_LoadingScreen"
loadingScreen.IgnoreGuiInset = true

local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.Position = UDim2.new(0, 0, 0, 0)
background.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
background.Parent = loadingScreen

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 120, 0, 120)
logo.Position = UDim2.new(0.5, -60, 0.2, 0)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://87916870577105"
logo.Parent = background

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0, 0, 0.5, 0)
title.Text = "FOR ADOPT ME"
title.TextSize = 24
title.Font = Enum.Font.GothamMedium
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(200, 200, 200)
title.TextScaled = true
title.Parent = background

local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(0, 500, 0, 100)
watermark.Position = UDim2.new(0.75, 0, 0.25, 0)
watermark.TextSize = 45
watermark.Font = Enum.Font.GothamBold
watermark.BackgroundTransparency = 1
watermark.TextTransparency = 0.5
watermark.Parent = background
watermark.TextScaled = true
watermark.TextStrokeTransparency = 0
watermark.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
watermark.TextXAlignment = Enum.TextXAlignment.Left
watermark.RichText = true
watermark.Text = [[
    <font color="rgb(255,0,0)">SUB</font>  
    <font color="rgb(255,255,255)">TO</font>  
    <font color="rgb(255,165,0)">GamesssHubss</font>  
    <font color="rgb(255,0,0)">ON YT</font>  
]]

local progressBarBackground = Instance.new("Frame")
progressBarBackground.Size = UDim2.new(0, 500, 0, 30)
progressBarBackground.Position = UDim2.new(0.5, -250, 0.73, 0)
progressBarBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
progressBarBackground.Parent = background

local progressBarCorner = Instance.new("UICorner")
progressBarCorner.CornerRadius = UDim.new(1, 0)
progressBarCorner.Parent = progressBarBackground

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(255, 223, 0)
progressBar.Parent = progressBarBackground

local progressBarInnerCorner = Instance.new("UICorner")
progressBarInnerCorner.CornerRadius = UDim.new(1, 0)
progressBarInnerCorner.Parent = progressBar

local percentageLabel = Instance.new("TextLabel")
percentageLabel.Size = UDim2.new(1, 0, 0, 50)
percentageLabel.Position = UDim2.new(0, 0, 0.78, 10)
percentageLabel.Text = "0%"
percentageLabel.TextSize = 40
percentageLabel.Font = Enum.Font.GothamBold
percentageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
percentageLabel.BackgroundTransparency = 1
percentageLabel.Parent = background

for i = 1, 100 do
    TweenService:Create(progressBar, TweenInfo.new(0.1), {
        Size = UDim2.new(i / 100, 0, 1, 0)
    }):Play()
    
    percentageLabel.Text = i .. "%"
    wait(0.05)
end

TweenService:Create(background, TweenInfo.new(1), {
    BackgroundTransparency = 1
}):Play()

TweenService:Create(watermark, TweenInfo.new(1), {
    TextTransparency = 1
}):Play()

TweenService:Create(logo, TweenInfo.new(1), {
    ImageTransparency = 1
}):Play()

TweenService:Create(title, TweenInfo.new(1), {
    TextTransparency = 1
}):Play()

TweenService:Create(progressBarBackground, TweenInfo.new(1), {
    BackgroundTransparency = 1
}):Play()

TweenService:Create(progressBar, TweenInfo.new(1), {
    BackgroundTransparency = 1
}):Play()

TweenService:Create(percentageLabel, TweenInfo.new(1), {
    TextTransparency = 1
}):Play()

wait(1)
loadingScreen:Destroy()

local LocalPlayer = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")

local mainGUI = Instance.new("ScreenGui")
mainGUI.Parent = LocalPlayer:WaitForChild("PlayerGui")
mainGUI.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 250)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = mainGUI

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = mainFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Thickness = 3
frameStroke.Parent = mainFrame

task.spawn(function()
    while true do
        for hue = 0, 1, 0.01 do
            frameStroke.Color = Color3.fromHSV(hue, 1, 1)
            task.wait(0.05)
        end
    end
end)

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerText = Instance.new("TextLabel")
headerText.Text = "Pet Spawner"
headerText.Size = UDim2.new(1, 0, 1, 0)
headerText.BackgroundTransparency = 1
headerText.TextColor3 = Color3.fromRGB(255, 255, 255)
headerText.Font = Enum.Font.GothamBold
headerText.TextSize = 16
headerText.Parent = header

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0.85, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.Parent = mainFrame

local petNameInput = Instance.new("TextBox")
petNameInput.Size = UDim2.new(0.8, 0, 0, 40)
petNameInput.Position = UDim2.new(0.1, 0, 0.25, 0)
petNameInput.PlaceholderText = "Enter Pet Name"
petNameInput.Text = ""
petNameInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
petNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
petNameInput.Font = Enum.Font.Gotham
petNameInput.TextSize = 14
petNameInput.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = petNameInput

local selectedType = "FR"

local function CreateTypeButton(buttonText, positionX, color)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.25, 0, 0, 30)
    button.Position = UDim2.new(positionX, 0, 0.45, 0)
    button.Text = buttonText
    button.BackgroundColor3 = color
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Parent = mainFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        selectedType = buttonText
        statusLabel.Text = "Selected: " .. buttonText
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    end)
    
    return button
end

CreateTypeButton("MFR", 0.1, Color3.fromRGB(255, 100, 100))
CreateTypeButton("NFR", 0.4, Color3.fromRGB(100, 255, 100))
CreateTypeButton("FR", 0.7, Color3.fromRGB(100, 100, 255))

local spawnButton = Instance.new("TextButton")
spawnButton.Size = UDim2.new(0.8, 0, 0, 40)
spawnButton.Position = UDim2.new(0.1, 0, 0.65, 0)
spawnButton.Text = "Spawn Pet"
spawnButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
spawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnButton.Font = Enum.Font.GothamBold
spawnButton.TextSize = 14
spawnButton.Parent = mainFrame

local spawnButtonCorner = Instance.new("UICorner")
spawnButtonCorner.CornerRadius = UDim.new(0, 8)
spawnButtonCorner.Parent = spawnButton

task.spawn(function()
    local success, errorMessage = pcall(function()
        local Fsys = require(game.ReplicatedStorage:WaitForChild("Fsys"))
        local loadModule = Fsys.load
        
        local ClientData = loadModule("ClientData")
        local KindDB = loadModule("KindDB")
        local RouterClient = loadModule("RouterClient")
        local DownloadClient = loadModule("DownloadClient")
        local AnimationManager = loadModule("AnimationManager")
        local PetRigs = loadModule("new:PetRigs")
        local InventoryDB = loadModule("InventoryDB")
        
        local petCache = {}
        local petInstances = {}
        local currentPet = nil
        local ridingPet = nil
        local ridingAnimation = nil
        
        local function UpdateClientData(key, updateFunction)
            local currentData = ClientData.get(key)
            local newData = table.clone(currentData)
            ClientData.predict(key, updateFunction(newData))
        end
        
        local function GenerateUniqueId()
            return HttpService:GenerateGUID(false)
        end
        
        local function LoadPetModel(petId)
            if petCache[petId] then
                return petCache[petId]
            end
            
            local model = DownloadClient.promise_download_copy("Pets", petId):expect()
            petCache[petId] = model
            return model
        end
        
        local function CreatePetInInventory(petId, properties)
            local uniqueId = GenerateUniqueId()
            local petData = nil
            
            UpdateClientData("inventory", function(inventoryData)
                local petsCopy = table.clone(inventoryData.pets)
                petData = {
                    unique = uniqueId,
                    category = "pets",
                    id = petId,
                    kind = KindDB[petId].kind,
                    newness_order = 0,
                    properties = properties
                }
                petsCopy[uniqueId] = petData
                inventoryData.pets = petsCopy
                return inventoryData
            end)
            
            petInstances[uniqueId] = {
                data = petData,
                model = nil
            }
            
            return petData
        end
        
        local function ApplyNeonEffects(petModel, petKindData)
            local petModelChild = petModel:FindFirstChild("PetModel")
            if petModelChild then
                for partName, neonData in pairs(petKindData.neon_parts) do
                    local part = PetRigs.get(petModelChild).get_geo_part(petModelChild, partName)
                    if part then
                        part.Material = neonData.Material
                        part.Color = neonData.Color
                    end
                end
            end
        end
        
        local function AddPetToCharacterList(petInfo)
            UpdateClientData("pet_char_wrappers", function(charList)
                petInfo.unique = #charList + 1
                petInfo.index = #charList + 1
                charList[#charList + 1] = petInfo
                return charList
            end)
        end
        
        local function AddPetStateManager(stateManager)
            UpdateClientData("pet_state_managers", function(stateManagers)
                stateManagers[#stateManagers + 1] = stateManager
                return stateManagers
            end)
        end
        
        local function FindInTable(tableToSearch, predicate)
            for index, value in pairs(tableToSearch) do
                if predicate(value, index) then
                    return index
                end
            end
            return nil
        end
        
        local function RemovePetFromCharacterList(petUniqueId)
            UpdateClientData("pet_char_wrappers", function(charList)
                local indexToRemove = FindInTable(charList, function(wrapper)
                    return wrapper.pet_unique == petUniqueId
                end)
                
                if not indexToRemove then
                    return charList
                end
                
                table.remove(charList, indexToRemove)
                
                for i, wrapper in ipairs(charList) do
                    wrapper.unique = i
                    wrapper.index = i
                end
                
                return charList
            end)
        end
        
        local function ClearPetStates(petUniqueId)
            local petInstance = petInstances[petUniqueId]
            if petInstance and petInstance.model then
                UpdateClientData("pet_state_managers", function(stateManagers)
                    local index = FindInTable(stateManagers, function(manager)
                        return manager.char == petInstance.model
                    end)
                    
                    if not index then
                        return stateManagers
                    end
                    
                    local newManagers = table.clone(stateManagers)
                    newManagers[index] = table.clone(newManagers[index])
                    newManagers[index].states = {}
                    return newManagers
                end)
            end
        end
        
        local function SetPetState(petUniqueId, stateId)
            local petInstance = petInstances[petUniqueId]
            if petInstance and petInstance.model then
                UpdateClientData("pet_state_managers", function(stateManagers)
                    local index = FindInTable(stateManagers, function(manager)
                        return manager.char == petInstance.model
                    end)
                    
                    if not index then
                        return stateManagers
                    end
                    
                    local newManagers = table.clone(stateManagers)
                    newManagers[index] = table.clone(newManagers[index])
                    newManagers[index].states = {{id = stateId}}
                    return newManagers
                end)
            end
        end
        
        local function AttachPetForRiding(petModel)
            local character = LocalPlayer.Character
            if not character or not character.PrimaryPart then
                return false
            end
            
            local ridePosition = petModel:FindFirstChild("RidePosition", true)
            if not ridePosition then
                return false
            end
            
            local attachment = Instance.new("Attachment")
            attachment.Parent = ridePosition
            attachment.Position = Vector3.new(0, 1.2, 0)
            attachment.Name = "SourceAttachment"
            
            local constraint = Instance.new("RigidConstraint")
            constraint.Attachment0 = attachment
            constraint.Attachment1 = character.PrimaryPart.RootAttachment
            constraint.Parent = character
            
            return true
        end
        
        local function ClearPlayerStates()
            UpdateClientData("state_manager", function(stateManager)
                local newManager = table.clone(stateManager)
                newManager.states = {}
                newManager.is_sitting = false
                return newManager
            end)
        end
        
        local function SetPlayerState(stateId)
            UpdateClientData("state_manager", function(stateManager)
                local newManager = table.clone(stateManager)
                newManager.states = {{id = stateId}}
                newManager.is_sitting = true
                return newManager
            end)
        end
        
        local function RemovePetStateManager(petUniqueId)
            local petInstance = petInstances[petUniqueId]
            if petInstance and petInstance.model then
                UpdateClientData("pet_state_managers", function(stateManagers)
                    local index = FindInTable(stateManagers, function(manager)
                        return manager.char == petInstance.model
                    end)
                    
                    if not index then
                        return stateManagers
                    end
                    
                    table.remove(stateManagers, index)
                    return stateManagers
                end)
            end
        end
        
        local function DetachPet(petUniqueId)
            local petInstance = petInstances[petUniqueId]
            if petInstance and petInstance.model then
                if ridingAnimation then
                    ridingAnimation:Stop()
                    ridingAnimation:Destroy()
                    ridingAnimation = nil
                end
                
                local attachment = petInstance.model:FindFirstChild("SourceAttachment", true)
                if attachment then
                    attachment:Destroy()
                end
                
                local character = LocalPlayer.Character
                if character then
                    for _, descendant in pairs(character:GetDescendants()) do
                        if descendant:IsA("BasePart") and descendant:GetAttribute("HaveMass") then
                            descendant.Massless = false
                        end
                    end
                end
                
                ClearPetStates(petUniqueId)
                ClearPlayerStates()
                petInstance.model:ScaleTo(1)
                ridingPet = nil
            end
        end
        
        local function AttachToPet(petUniqueId, playerState, petState)
            local petInstance = petInstances[petUniqueId]
            if petInstance and petInstance.model then
                local character = LocalPlayer.Character
                if character and character.PrimaryPart then
                    ridingPet = petUniqueId
                    SetPetState(petUniqueId, petState)
                    SetPlayerState(playerState)
                    petInstance.model:ScaleTo(2)
                    AttachPetForRiding(petInstance.model)
                    
                    ridingAnimation = character.Humanoid.Animator:LoadAnimation(
                        AnimationManager.get_track("PlayerRidingPet")
                    )
                    
                    character.Humanoid.Sit = true
                    
                    for _, descendant in pairs(character:GetDescendants()) do
                        if descendant:IsA("BasePart") and descendant.Massless == false then
                            descendant.Massless = true
                            descendant:SetAttribute("HaveMass", true)
                        end
                    end
                    
                    ridingAnimation:Play()
                end
            end
        end
        
        local function FlyPet(petUniqueId)
            AttachToPet(petUniqueId, "PlayerFlyingPet", "PetBeingFlown")
        end
        
        local function RidePet(petUniqueId)
            AttachToPet(petUniqueId, "PlayerRidingPet", "PetBeingRidden")
        end
        
        local function DeletePet(petData)
            local petInstance = petInstances[petData.unique]
            if petInstance and petInstance.model then
                DetachPet(petData.unique)
                RemovePetFromCharacterList(petData.unique)
                RemovePetStateManager(petData.unique)
                
                if petInstance.model then
                    petInstance.model:Destroy()
                end
                
                petInstance.model = nil
                currentPet = nil
            end
        end
        
        local function SpawnPetVisual(petData)
            if currentPet then
                DeletePet(currentPet)
            end
            
            local model = LoadPetModel(petData.kind):Clone()
            model.Parent = workspace
            petInstances[petData.unique].model = model
            
            if petData.properties.neon or petData.properties.mega_neon then
                ApplyNeonEffects(model, KindDB[petData.kind])
            end
            
            currentPet = petData
            
            AddPetToCharacterList({
                char = model,
                mega_neon = petData.properties.mega_neon,
                neon = petData.properties.neon,
                player = LocalPlayer,
                entity_controller = LocalPlayer,
                controller = LocalPlayer,
                rp_name = petData.properties.rp_name or "",
                pet_trick_level = petData.properties.pet_trick_level,
                pet_unique = petData.unique,
                pet_id = petData.id,
                location = {
                    full_destination_id = "housing",
                    destination_id = "housing",
                    house_owner = LocalPlayer
                },
                pet_progression = {
                    friendship_level = petData.properties.friendship_level,
                    age = petData.properties.age,
                    percentage = 0
                },
                are_colors_sealed = false,
                is_pet = true
            })
            
            AddPetStateManager({
                char = model,
                player = LocalPlayer,
                store_key = "pet_state_managers",
                is_sitting = false,
                chars_connected_to_me = {},
                states = {}
            })
        end
        
        local originalGet = RouterClient.get
        
        local function CreateMockRemoteFunction(callback)
            return {
                InvokeServer = function(_, ...)
                    return callback(...)
                end
            }
        end
        
        local function CreateMockRemoteEvent(callback)
            return {
                FireServer = function(_, ...)
                    return callback(...)
                end
            }
        end
        
        local equipMock = CreateMockRemoteFunction(function(petUniqueId, _)
            local petInstance = petInstances[petUniqueId]
            if petInstance then
                SpawnPetVisual(petInstance.data)
                return true, {action = "equip", is_server = true}
            end
        end)
        
        local unequipMock = CreateMockRemoteFunction(function(petUniqueId)
            local petInstance = petInstances[petUniqueId]
            if petInstance then
                DeletePet(petInstance.data)
                return true, {action = "unequip", is_server = true}
            end
        end)
        
        local ridePetMock = CreateMockRemoteFunction(function(data)
            RidePet(data.pet_unique)
        end)
        
        local flyPetMock = CreateMockRemoteFunction(function(data)
            FlyPet(data.pet_unique)
        end)
        
        local exitSeatMock = CreateMockRemoteFunction(function()
            DetachPet(ridingPet)
        end)
        
        local exitSeatEvent = CreateMockRemoteEvent(function()
            DetachPet(ridingPet)
        end)
        
        function RouterClient.get(apiName)
            if apiName == "ToolAPI/Equip" then
                return equipMock
            elseif apiName == "ToolAPI/Unequip" then
                return unequipMock
            elseif apiName == "AdoptAPI/RidePet" then
                return ridePetMock
            elseif apiName == "AdoptAPI/FlyPet" then
                return flyPetMock
            elseif apiName == "AdoptAPI/ExitSeatStatesYield" then
                return exitSeatMock
            elseif apiName == "AdoptAPI/ExitSeatStates" then
                return exitSeatEvent
            else
                return originalGet(apiName)
            end
        end
        
        local petWrappers = ClientData.get("pet_char_wrappers")
        for _, wrapper in pairs(petWrappers) do
            pcall(function()
                RouterClient.get("ToolAPI/Unequip"):InvokeServer(wrapper.pet_unique)
            end)
        end
        
        local function GetPetByName(petName)
            for _, petData in pairs(InventoryDB.pets) do
                if type(petData.name) == "string" and petData.name:lower() == petName:lower() then
                    return petData.id
                end
            end
            return false
        end
        
        spawnButton.MouseButton1Click:Connect(function()
            local petName = petNameInput.Text
            if petName and petName ~= "" then
                task.spawn(function()
                    statusLabel.Text = "⌛ Searching pet..."
                    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    
                    local petId = GetPetByName(petName)
                    if petId then
                        local properties = {
                            pet_trick_level = 0,
                            rideable = true,
                            flyable = true,
                            friendship_level = 0,
                            age = 1,
                            ailments_completed = 0,
                            rp_name = ""
                        }
                        
                        if selectedType == "MFR" then
                            properties.mega_neon = true
                        elseif selectedType == "NFR" then
                            properties.neon = true
                        end
                        
                        local success, result = pcall(function()
                            return CreatePetInInventory(petId, properties)
                        end)
                        
                        if success and result then
                            statusLabel.Text = "✅ Pet Spawned: " .. petName .. " (" .. selectedType .. ")"
                            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                            
                            pcall(function()
                                game.StarterGui:SetCore("SendNotification", {
                                    Title = "Pet Spawned!",
                                    Text = petName .. " (" .. selectedType .. ") has been spawned!",
                                    Duration = 3
                                })
                            end)
                        else
                            statusLabel.Text = "❌ Failed to spawn pet."
                            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                            
                            pcall(function()
                                game.StarterGui:SetCore("SendNotification", {
                                    Title = "Error",
                                    Text = "Spawn failed.",
                                    Duration = 3
                                })
                            end)
                        end
                    else
                        statusLabel.Text = "❌ Pet Not Found: " .. petName
                        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                        
                        pcall(function()
                            game.StarterGui:SetCore("SendNotification", {
                                Title = "Error",
                                Text = "Pet Not Found: " .. petName,
                                Duration = 3
                            })
                        end)
                    end
                end)
            else
                statusLabel.Text = "❌ Please enter a pet name."
                statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            end
        end)
    end)
    
    if not success then
        statusLabel.Text = "⚠️ Backend failed: " .. tostring(errorMessage)
        statusLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
    end
end)
