set_thread_identity(5)

local petSettings = {Fly = false, Ride = false, Neon = false, Mega = false}
local petNameGlobal = 'Owl'
local SHOULD_FAVORITE_PET = false
local isTrusted = false

local petCount = 1

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local load = require(ReplicatedStorage:WaitForChild("Fsys")).load
local InventoryDB = load("InventoryDB")
local UIManager = load("UIManager")

local function GetPetByName(name)
    for _, v in pairs(InventoryDB.pets) do
        if v.name:lower() == name:lower() then
            return v.id
        end
    end
    return nil
end

local function tradeEnded()
    UIManager.apps.HintApp:hint({
        ["text"] = "The trade was successful!",
        ["length"] = 4
    })
end

local function validatePetName(name)
    if name == "" or #name < 2 then return false end
    return GetPetByName(name)
end

local router = load('RouterClient')

local TradeAPITradeReactedTo = router.get("TradeAPI/TradeReactedTo")

local favoriter = require(game.ReplicatedStorage.ClientModules.Core.UIManager.Apps.BackpackApp.ItemSets.BackpackFavoriteTracker)

local DataAPIDataPartiallyChanged = router.get("DataAPI/DataPartiallyChanged")

local HttpService = game:GetService("HttpService")

local function generate_custom_id()
    local guid = HttpService:GenerateGUID(false)
    local hex32 = guid:gsub("-", ""):lower()
    return "2_" .. hex32
end

local function spawnPet(name, prop, favorite)
    local id = generate_custom_id()
    local pet = {
        unique = id,
        category = "pets",
        id = name,
        properties = prop,
        kind = name,
        newness_order = 1
    }
    firesignal(DataAPIDataPartiallyChanged.OnClientEvent, 
        game.Players.LocalPlayer.Name,
        {
            "inventory",
            "pets",
            id
        },
        pet,
        workspace:GetServerTimeNow()
    )
    if favorite then
        favoriter.set_favorite(pet, true)
    end
end

local function deletePet(uid)
    firesignal(DataAPIDataPartiallyChanged.OnClientEvent, 
        game.Players.LocalPlayer.Name,
        {
            "inventory",
            "pets",
            uid
        },
        nil,
        workspace:GetServerTimeNow()
    )
    firesignal(DataAPIDataPartiallyChanged.OnClientEvent, 
        game.Players.LocalPlayer.Name,
        {
            "inventory",
            "pets",
            uid
        },
        nil,
        workspace:GetServerTimeNow()
    )
end

local function SpawnPetFunction(settings)
    local fly, ride, neonLevel
    if not settings then
        fly = petSettings.Fly
        ride = petSettings.Ride
        neonLevel = (petSettings.Mega and 2) or (petSettings.Neon and 1) or 0
    else
        fly = settings.Fly
        ride = settings.Ride
        neonLevel = (settings.Mega and 2) or (settings.Neon and 1) or 0
    end

    local petProperties = {
        pet_trick_level = 0,
        rideable = ride,
        flyable = fly,
        friendship_level = 0,
        age = 1,
        ailments_completed = 0,
        rp_name = ""
    }

    if neonLevel == 1 then
        petProperties.neon = true
    elseif neonLevel == 2 then
        petProperties.mega_neon = true
    end

    spawnPet(petNameGlobal, petProperties, SHOULD_FAVORITE_PET)
end

local PRESET_PETS = {
    {name = "Mini Pig"},
    {name = "Peppermint Penguin"},
    {name = "Hot Doggo"},
    {name = "Pelican"},
    {name = "African Wild Dog"},
    {name = "Albino Monkey"},
    {name = "Flamingo"},
    {name = "Cow"},
    {name = "Dalmatian"},
    {name = "Orchid Butterfly"},
    {name = "Blazing Lion"},
    {name = "Hedgehog"},
    {name = "Turtle"},
    {name = "Monkey King"},
    {name = "Arctic Reindeer"},
    {name = "Balloon Unicorn"},
    {name = "Diamond Butterfly"},
    {name = "Evil Unicorn"},
    {name = "Crow"},
    {name = "Parrot"},
    {name = "Owl"},
    {name = "Frost Dragon"},
    {name = "Giraffe"},
    {name = "Shadow Dragon"},
    {name = "Bat Dragon"},
    {name = "Jellyfish"},
    {name = "Christmas Pudding Pup"},
    {name = "Lion Cub"},
    {name = "Vanilla Penguin"},
    {name = "Strawberry Penguin"},
    {name = "Strawberry Shortcake Bat Dragon"},
    {name = "Chocolate Chip Bat Dragon"},
    {name = "Dango Penguins"},
    {name = "Giant Panda"},
    {name = "Elephant"},
    {name = "Nessie"},
    {name = "Sugar Glider"},
    {name = "Candyfloss Chick"},
    {name = "Caterpillar"},
    {name = "Cryptid"},
    {name = "Dalmatian"},
    {name = "Lion"},
    {name = "Crocodile"}
}

local function spawnRandomPetByID(PET_ID)
    local is_neon = (math.random() > 0.6 and true)
    local is_mega_neon = (not is_neon) and (math.random() > 0.6 and true)

    spawnPet(PET_ID, {
                age = math.random(1,6),
                rideable = math.random() > 0.3 and true,
                flyable = math.random() > 0.3 and true,
                friendship_level = 0,
                xp = math.random(0,500),
                pet_trick_level = 0,
                mega_neon = is_mega_neon,
                neon = is_neon
            }, true)
end


local function SpawnRandomCollection(totalPets)
    for i = 1, totalPets do
        local randomPreset = PRESET_PETS[math.random(1, #PRESET_PETS)]
        local realId = GetPetByName(randomPreset.name)
        if realId then
            spawnRandomPetByID(realId)
            task.wait()
        end
    end
end


local function PresetStart(num)
    task.spawn(SpawnRandomCollection,num)
end

local clientdata =load('ClientData')

local DataChanged = router.get('DataAPI/DataChanged')

local function getPetDataById(id)
    return clientdata.get('inventory')['pets'][id]
end

local TradeAPITradeRequestReceived = router.get("TradeAPI/TradeRequestReceived")

local PLAYER_LIST = debug.getupvalues(require(game:GetService("ReplicatedStorage").ClientServices.FriendsClient).promise_get_is_friends_with)[2]

IS_IN_SIMULATION = false

Old_TradeAPITradeRequestReceived = getconnections(TradeAPITradeRequestReceived.OnClientEvent)[1]

OLD_Old_TradeAPITradeRequestReceived = Old_TradeAPITradeRequestReceived.Function

TradeAPITradeRequestReceived_Function = function(...)
    OLD_Old_TradeAPITradeRequestReceived(...)
end

TradeAPITradeRequestReceived.OnClientEvent:Connect(function(...)
    if IS_IN_SIMULATION then
        repeat
            task.wait(0.25)
        until not IS_IN_SIMULATION 
    end
    return TradeAPITradeRequestReceived_Function(...)
end)

Old_DataChanged = getconnections(DataChanged.OnClientEvent)[1]

OLD_Old_DataChanged = Old_DataChanged.Function

DataChanged_Function = function(...)
    local args = {...}
    
    OLD_Old_DataChanged(unpack(args))
end

DataChanged.OnClientEvent:Connect(function(...)
    local args = {...}
    if type(args[3]) == "table" and args[2] == "trade" then
        local trade = args[3]
        if trade.recipient == game.Players.LocalPlayer.Name then
            me = 'recipient_offer'
        elseif trade.sender == game.Players.LocalPlayer.Name then
            me = 'sender_offer'
        end
        if tostring(trade.recipient) == game.Players.LocalPlayer.Name then
            me = 'recipient_offer'
            notme = 'sender_offer'
        end
        if tostring(trade.sender) == game.Players.LocalPlayer.Name then
            me = 'sender_offer'
            notme = 'recipient_offer'
        end
        me = trade[me]
        notme = trade[notme]
        LATEST_PERSON_TRADED = notme.player_name
    end
    return DataChanged_Function(unpack(args))
end)

Old_DataChanged:Disconnect()
Old_TradeAPITradeRequestReceived:Disconnect()

local function setSpectatorAmount(amount)
    if (not TRADE_TABLE) or (not TRADE_TABLE[3]) then
        return false
    end

    TRADE_TABLE[4] = Workspace:GetServerTimeNow()  
    TRADE_TABLE[3].subscriber_count = amount

    DataChanged_Function(unpack(TRADE_TABLE))
    return true
end

local function reactToTrade()
    if not (TRADE_TABLE and TRADE_TABLE[3]) then return end

    firesignal(TradeAPITradeReactedTo.OnClientEvent, 
        TRADE_TABLE[3].trade_id,
        math.random(1,7)
    )
end

task.spawn(function()
    while true do
        if TRADE_TABLE and TRADE_TABLE[3] then
            local targetViewers = math.random(7, 13)
            local totalDuration = math.random(5, 9)
            local stepDelay = totalDuration / targetViewers 

            for i = 1, targetViewers do
                if not (TRADE_TABLE and TRADE_TABLE[3]) then
                    break
                end

                setSpectatorAmount(i)

                if i == 1 then
                    task.spawn(function()
                        task.wait(math.random(20, 30) / 10)
                        while TRADE_TABLE and TRADE_TABLE[3] do
                            reactToTrade()
                            task.wait(math.random(5, 20) / 10)
                        end
                    end)
                end
                task.wait(stepDelay)
            end
            while TRADE_TABLE and TRADE_TABLE[3] do
                task.wait(0.5)
            end
        end
        task.wait(0.5)
    end
end)

local function justAcceptTrade(currentTrade)
    task.delay(1, function()
        currentTrade[3].current_stage = 'confirmation'
        currentTrade[4] = Workspace:GetServerTimeNow()
        TRADE_TABLE = currentTrade
        DataChanged_Function(unpack(currentTrade))
    end)
end

local function acceptTradeFromMySide()
    local currentTrade = TRADE_TABLE
    if (not currentTrade) and (not currentTrade[3]) then
        return
    end

    currentTrade[3].recipient_offer.negotiated = true

    if currentTrade[3].sender_offer.negotiated == true then
        justAcceptTrade(currentTrade)
    end 
    TRADE_TABLE = currentTrade
end

local function acceptTradeFromHisSide()
    local currentTrade = TRADE_TABLE
    if (not currentTrade) and (not currentTrade[3]) then
        return
    end

    currentTrade[3].sender_offer.negotiated = true

    currentTrade[4] = Workspace:GetServerTimeNow()
    
    if currentTrade[3].recipient_offer.negotiated == true then
        justAcceptTrade(currentTrade)
    end
    TRADE_TABLE = currentTrade
    DataChanged_Function(unpack(currentTrade))
end

local function destroyTradeWithCooldown(currentTrade)
    local inventoryChanges = {
        to_delete = currentTrade[3].recipient_offer['items'],
        to_add = currentTrade[3].sender_offer['items'],
    }

    for i,v in pairs(inventoryChanges.to_delete) do
        deletePet(v.unique)
    end

    for i,v in pairs(inventoryChanges.to_add) do
        firesignal(DataAPIDataPartiallyChanged.OnClientEvent, 
            game.Players.LocalPlayer.Name,
            {
                "inventory",
                "pets",
                v.unique
            },
            v,
            workspace:GetServerTimeNow()
        )
    end
    
    task.delay(1, function()
        currentTrade[3].current_stage = 'confirmation'
        currentTrade[3].processing = true
        TRADE_TABLE = currentTrade
        DataChanged_Function(unpack(currentTrade))
        task.wait(1)
        currentTrade[3] = nil
        IS_IN_SIMULATION = false
        currentTrade[4] = Workspace:GetServerTimeNow()
        TRADE_TABLE = currentTrade
        DataChanged_Function(unpack(currentTrade))
        tradeEnded()
    end)
end

local function confirmTradeFromMySide()
    local currentTrade = TRADE_TABLE
    if (not currentTrade) and (not currentTrade[3]) then
        return
    end

    currentTrade[3].recipient_offer.confirmed = true
    --currentTrade[3].offer_version = game:GetService('HttpService'):GenerateGUID(true)
    currentTrade[4] = Workspace:GetServerTimeNow()

    if currentTrade[3].sender_offer.confirmed == true then
        destroyTradeWithCooldown(currentTrade)
    end
    TRADE_TABLE = currentTrade
    DataChanged_Function(unpack(currentTrade))
end

local function confirmTradeFromHisSide()
    local currentTrade = TRADE_TABLE
    if (not currentTrade) and (not currentTrade[3]) then
        return
    end

    currentTrade[3].sender_offer.confirmed = true
    --currentTrade[3].offer_version = game:GetService('HttpService'):GenerateGUID(true)
    currentTrade[4] = Workspace:GetServerTimeNow()

    if currentTrade[3].recipient_offer.confirmed == true then
        destroyTradeWithCooldown(currentTrade)
    end
    TRADE_TABLE = currentTrade
    DataChanged_Function(unpack(currentTrade))
end

local function endTrade()
    local currentTrade = TRADE_TABLE
    if (not currentTrade) and (not currentTrade[3]) then
        return
    end

    currentTrade[3] = nil
    IS_IN_SIMULATION = false
    currentTrade[4] = Workspace:GetServerTimeNow()
    TRADE_TABLE = currentTrade
    DataChanged_Function(unpack(currentTrade))
end

local function addItemByIdFromMySide(id)
    local currentTrade = TRADE_TABLE
    if (not currentTrade) and (not currentTrade[3]) then
        return
    end

    local petData = getPetDataById(id)
    if not petData then
        return
    end

    local pet_table = {
        unique = id,
        category = 'pets',
        id = petData.id,
        properties = {
            age = 1,
            rideable = petData.properties.rideable or nil,
            flyable = petData.properties.flyable or nil,
            neon = (petData.properties.neon and true) or nil,
            mega_neon = (petData.properties.mega_neon and true) or nil,
            friendship_level = 0,
            xp = 0,
            pet_trick_level = 0,
        },
        kind = petData.kind,
        newness_order = 0,
    }
    
    table.insert(currentTrade[3].recipient_offer['items'], pet_table)
    currentTrade[4] = Workspace:GetServerTimeNow()
    currentTrade[3].offer_version = game:GetService('HttpService'):GenerateGUID(true)
    TRADE_TABLE = currentTrade
    task.wait(0.1)
    --DataChanged_Function(unpack(currentTrade))
end

local function createPetDataBySettings()
    local petName = petNameGlobal
    local fly = petSettings.Fly
    local ride = petSettings.Ride

    local pet_table = {
        unique = generate_custom_id(),
        category = 'pets',
        id = petName,
        properties = {
            age = 1,
            rideable = ride or nil,
            flyable = fly or nil,
            neon = (petSettings.Neon and true) or nil,
            mega_neon = (petSettings.Mega and true) or nil,
            friendship_level = 0,
            xp = 0,
            pet_trick_level = 0,
        },
        kind = petName,
        newness_order = 0,
    }
    return pet_table
end

local TO_REMEMBER = {};

local function addItemByIdFromHisSide()
    local currentTrade = TRADE_TABLE
    if (not currentTrade) and (not currentTrade[3]) then
        return
    end

    local petData = createPetDataBySettings()
    if not petData then
        return
    end

    table.insert(currentTrade[3].sender_offer['items'], petData)
    TO_REMEMBER = currentTrade[3].sender_offer['items']
    currentTrade[4] = Workspace:GetServerTimeNow()
    currentTrade[3].offer_version = game:GetService('HttpService'):GenerateGUID(true)
    TRADE_TABLE = currentTrade
    DataChanged_Function(unpack(currentTrade))
end

local function removeLastItemFromHisSide()
    local lenght = #TO_REMEMBER
    table.remove(TRADE_TABLE[3].sender_offer['items'], lenght)
    TRADE_TABLE[3].offer_version = game:GetService('HttpService'):GenerateGUID(true)
    TRADE_TABLE[4] = Workspace:GetServerTimeNow()
    DataChanged_Function(unpack(TRADE_TABLE))
end

local function removeItemByIdFromMySide(id)
    local currentTrade = TRADE_TABLE
    if (not currentTrade) and (not currentTrade[3]) then
        return
    end

    local petData = getPetDataById(id)

    if not petData then
        return
    end

    local removingId = 1;
    for num , data in pairs(currentTrade[3].recipient_offer['items']) do
        if data.unique == id then
            removingId = num
        end
    end

    table.remove(currentTrade[3].recipient_offer['items'], removingId)
    currentTrade[4] = Workspace:GetServerTimeNow()
    TRADE_TABLE = currentTrade
    task.wait(0.1)
    DataChanged_Function(unpack(currentTrade))
end

local oldGet = router.get

local function createRemoteFunctionMock(callback)
    return {
        InvokeServer = function(_, ...)
            return callback(...)
        end
    }
end

local function createRemoteEventMock(callback)
    return {
        FireServer = function(_, ...)
            return callback(...)
        end
    }
end

local AcceptNegotiation = createRemoteEventMock(function()
    if not IS_IN_SIMULATION then
        return oldGet("TradeAPI/AcceptNegotiation"):FireServer()
    end
    acceptTradeFromMySide()
end)
local ConfirmTrade = createRemoteEventMock(function()
    if not IS_IN_SIMULATION then
        return oldGet("TradeAPI/ConfirmTrade"):FireServer()
    end
    confirmTradeFromMySide()
end)
local AddItemToOffer = createRemoteEventMock(function(id)
    if not IS_IN_SIMULATION then
        return oldGet("TradeAPI/AddItemToOffer"):FireServer(id)
    end
    addItemByIdFromMySide(id)
end)
local RemoveItemFromOffer = createRemoteEventMock(function(id)
    if not IS_IN_SIMULATION then
        return oldGet("TradeAPI/RemoveItemFromOffer"):FireServer(id)
    end
    removeItemByIdFromMySide(id)
end)
local TradeAPIDeclineTrade = createRemoteEventMock(function(id)
    if not IS_IN_SIMULATION then
        return oldGet("TradeAPI/DeclineTrade"):FireServer(id)
    end
    endTrade()
end)

router.get = function(name)
    if name == "TradeAPI/AcceptNegotiation" then
        return AcceptNegotiation
    end
    if name == "TradeAPI/ConfirmTrade" then
        return ConfirmTrade
    end
    if name == 'TradeAPI/AddItemToOffer' then
        return AddItemToOffer
    end
    if name == "TradeAPI/RemoveItemFromOffer" then
        return RemoveItemFromOffer
    end
    if name == "TradeAPI/DeclineTrade" then
        return TradeAPIDeclineTrade
    end
    return oldGet(name)
end

local function startTrade(playerName)
    local SENDER_NAME = playerName

    tradeId = game:GetService('HttpService'):GenerateGUID(true)

    TRADE_TABLE = {
        game.Players.LocalPlayer.Name,
        "trade",
        {
            recipient = game.Players.LocalPlayer,
            sender = game.Players[SENDER_NAME],
            recipient_offer = {
                items = {},
                player_name = game.Players.LocalPlayer.Name,
                negotiated = false,
                confirmed = false
            },
            recipient_has_trade_license = true,
            sender_has_trade_license = true,
            busy_indicators = {},
            current_stage = "negotiation",
            sender_offer = {
                items = {},
                player_name = SENDER_NAME,
                negotiated = false,
                confirmed = false
            },
            offer_version = game:GetService('HttpService'):GenerateGUID(true),
            trade_id = tradeId,
            subscriber_count = 0,
            processing = false
        },
        Workspace:GetServerTimeNow()
    }
    
    DataChanged_Function(unpack(TRADE_TABLE))
    return true
end


local Players = game:GetService("Players")

--set_thread_identity(2)

local GroupRankHelper = load("GroupRankHelper")

local function createFakePlayer(name)
    return {
        Name = name,
        UserId = 1,
        DisplayName = name,
        Parent = Players,
        IsA = function(_, type) return type == "Player" end
    }
end


local function recieveTradeRequest(playerName, verifiedFriendStatus)
    if IS_IN_SIMULATION then
        return
    end

    IS_IN_SIMULATION = true

    if verifiedFriendStatus then
        PLAYER_LIST.server[game.Players[playerName].UserId] = game.Players[playerName]
        PLAYER_LIST.all[game.Players[playerName].UserId] = game.Players[playerName]
    else
        PLAYER_LIST.server[game.Players[playerName].UserId] = nil
        PLAYER_LIST.all[game.Players[playerName].UserId] = nil
    end

    local fakePlayer = createFakePlayer(playerName)
    
    local DialogApp = UIManager.apps.DialogApp
    
    local dialogData = {
        ["text"] = string.format("%s sent you a trade request", fakePlayer.Name),
        ["left"] = "Decline",
        ["right"] = "Accept",
        ["center"] = nil,
        ["handle"] = "trade_request",
        ["dialog_type"] = verifiedFriendStatus and "HeaderDialog" or nil
    }

    if verifiedFriendStatus then
        local title = verifiedFriendStatus:sub(1, 1):upper() .. verifiedFriendStatus:sub(2)
        dialogData.header = "Verified " .. title
        
        --set_thread_identity(2)
        local icon = GroupRankHelper.get_icon_from_tag(verifiedFriendStatus)
        --set_thread_identity(8)
        dialogData.header_icon = icon
    end

    --set_thread_identity(2)
    local selection = DialogApp:dialog(dialogData)
    --set_thread_identity(8)

    if selection == "Accept" then
        local res,result = pcall(startTrade,playerName)
        if not res or not result then
            IS_IN_SIMULATION = false
        end
    elseif selection == "Decline" then
        IS_IN_SIMULATION = false
    end
end


-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- 1. GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdoptMeTradeGui_Dynamic_Keybinds_v2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Colors
local COLORS = {
    Background = Color3.fromRGB(25, 25, 30),
    StrokePurple = Color3.fromRGB(120, 50, 255),
    TextWhite = Color3.fromRGB(255, 255, 255),
    BtnGray = Color3.fromRGB(45, 45, 50),
    BtnActivePurple = Color3.fromRGB(80, 40, 180),
    
    -- STATUS TEXT COLORS
    ColorNeon = "rgb(100,255,100)",
    ColorMega = "rgb(180,100,255)",
    ColorFly = "rgb(100,200,255)",
    ColorRide = "rgb(255,100,150)",
    
    -- TOGGLE COLORS
    ActiveGreen = Color3.fromRGB(100, 255, 100), 
    InactiveRed = Color3.fromRGB(255, 80, 80),
    
    -- ACTION COLORS
    BlueAction = Color3.fromRGB(60, 110, 220),   -- Start Trade
    YellowAction = Color3.fromRGB(255, 200, 50), -- Accept Trade
    GreenAction = Color3.fromRGB(80, 200, 80),   -- Confirm Trade/Spawn
    RedAction = Color3.fromRGB(200, 60, 60),     -- Cancel/Remove
    PurpleAction = Color3.fromRGB(255, 0, 255),

    CloseRed = Color3.fromRGB(255, 70, 70),
    DisabledGray = Color3.fromRGB(80, 80, 80)
}

local FONT = Enum.Font.FredokaOne

--------------------------------------------------------------------------------
-- UTILS
--------------------------------------------------------------------------------
local function addCorner(parent, radius)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, radius)
    uiCorner.Parent = parent
    return uiCorner
end

local function addStroke(parent, color, thickness)
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = color
    uiStroke.Thickness = thickness
    uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    uiStroke.Parent = parent
    return uiStroke
end

local function createXButton(parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 25, 0, 25)
    btn.Position = UDim2.new(1, -30, 0, 8)
    btn.BackgroundColor3 = COLORS.CloseRed
    btn.Text = "X"
    btn.TextColor3 = COLORS.TextWhite
    btn.Font = FONT
    btn.TextSize = 14
    btn.Parent = parent
    addCorner(btn, 6)
    return btn
end

--------------------------------------------------------------------------------
-- GLOBAL CLICK BLOCKER & DRAG
--------------------------------------------------------------------------------
local clickBlocker = false 

-- Wrapper for clicks
local function ConnectClick(btn, callback)
    btn.MouseButton1Click:Connect(function()
        if clickBlocker then return end
        callback()
    end)
end

--------------------------------------------------------------------------------
-- KEYBIND SYSTEM
--------------------------------------------------------------------------------
local Keybinds = {} 
local isBinding = false 

-- Function to register a button so it appears in Keybinds tab
local function RegisterKeybindAction(actionName, buttonRef, callback)
    local entry = {
        Name = actionName,
        Key = nil, 
        Callback = callback,
        BtnRef = buttonRef,
        OriginalText = buttonRef.Text
    }
    table.insert(Keybinds, entry)
    
    ConnectClick(buttonRef, callback)
end

-- Global Key Listener
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end 
    if isBinding then return end 

    if input.UserInputType == Enum.UserInputType.Keyboard then
        for _, bind in ipairs(Keybinds) do
            if bind.Key == input.KeyCode then
                task.spawn(function()
                    local oldColor = bind.BtnRef.BackgroundColor3
                    bind.BtnRef.BackgroundColor3 = Color3.new(1,1,1)
                    task.wait(0.1)
                    bind.BtnRef.BackgroundColor3 = oldColor
                end)
                bind.Callback()
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- MAIN FRAME
--------------------------------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainTradeFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 520) 
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -260)
MainFrame.BackgroundColor3 = COLORS.Background
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 1
MainFrame.Parent = ScreenGui

addCorner(MainFrame, 20)
addStroke(MainFrame, COLORS.StrokePurple, 3)

local MainCloseBtn = createXButton(MainFrame)
ConnectClick(MainCloseBtn, function() MainFrame.Visible = false end)

--------------------------------------------------------------------------------
-- POPUP FRAME
--------------------------------------------------------------------------------
local PopupFrame = Instance.new("Frame")
PopupFrame.Name = "ListPopup"
PopupFrame.Size = UDim2.new(0, 300, 0, 350)
PopupFrame.Position = UDim2.new(0.5, 210, 0.5, -175)
PopupFrame.BackgroundColor3 = COLORS.Background
PopupFrame.Visible = false
PopupFrame.ZIndex = 20
PopupFrame.Parent = ScreenGui
addCorner(PopupFrame, 16)
addStroke(PopupFrame, COLORS.StrokePurple, 3)

--------------------------------------------------------------------------------
-- DRAG LOGIC
--------------------------------------------------------------------------------
local dragTarget = nil 
local dragInput, dragStart, startPos
local isDraggingActive = false 

local function isMouseOverObj(obj, inputPos)
    if not obj.Visible then return false end
    local absPos = obj.AbsolutePosition
    local absSize = obj.AbsoluteSize
    if inputPos.X >= absPos.X and inputPos.X <= (absPos.X + absSize.X) and
       inputPos.Y >= absPos.Y and inputPos.Y <= (absPos.Y + absSize.Y) then
        return true
    end
    return false
end

local function isOverTextBox(inputPos)
    local objects = LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(inputPos.X, inputPos.Y)
    for _, obj in pairs(objects) do
        if obj:IsA("TextBox") then return true end
    end
    return false
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UserInputService:GetMouseLocation()
        if isOverTextBox(mousePos) then return end
        
        if isMouseOverObj(PopupFrame, mousePos) then dragTarget = PopupFrame
        elseif isMouseOverObj(MainFrame, mousePos) then dragTarget = MainFrame
        else return end
        
        if dragTarget then
            isDraggingActive = false
            dragStart = input.Position
            startPos = dragTarget.Position
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragTarget = nil
                    connection:Disconnect()
                    if isDraggingActive then
                        clickBlocker = true
                        task.delay(0.1, function() clickBlocker = false end)
                    end
                end
            end)
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    if input == dragInput and dragTarget then
        local delta = input.Position - dragStart
        if (delta.X^2 + delta.Y^2) > 10 then 
            isDraggingActive = true
            clickBlocker = true 
        end
        dragTarget.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

--------------------------------------------------------------------------------
-- PAGE CONTAINERS
--------------------------------------------------------------------------------
local PetsPage = Instance.new("Frame")
PetsPage.Name = "PetsPage"
PetsPage.Size = UDim2.new(1, 0, 1, -50)
PetsPage.Position = UDim2.new(0, 0, 0, 50)
PetsPage.BackgroundTransparency = 1
PetsPage.Visible = false
PetsPage.Parent = MainFrame

local ControlPage = Instance.new("Frame")
ControlPage.Name = "ControlPage"
ControlPage.Size = UDim2.new(1, 0, 1, -50)
ControlPage.Position = UDim2.new(0, 0, 0, 50)
ControlPage.BackgroundTransparency = 1
ControlPage.Visible = true
ControlPage.Parent = MainFrame

local KeybindPage = Instance.new("Frame")
KeybindPage.Name = "KeybindPage"
KeybindPage.Size = UDim2.new(1, 0, 1, -50)
KeybindPage.Position = UDim2.new(0, 0, 0, 50)
KeybindPage.BackgroundTransparency = 1
KeybindPage.Visible = false
KeybindPage.Parent = MainFrame

--------------------------------------------------------------------------------
-- TABS LOGIC
--------------------------------------------------------------------------------
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -70, 0, 40)
TabContainer.Position = UDim2.new(0, 15, 0, 15)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local tabButtons = {}

local function switchTab(tabName)
    for name, btn in pairs(tabButtons) do
        local isActive = (name == tabName)
        btn.BackgroundColor3 = isActive and COLORS.BtnActivePurple or COLORS.BtnGray
        btn.TextTransparency = isActive and 0 or 0.5
    end
    PetsPage.Visible = (tabName == "Pets")
    ControlPage.Visible = (tabName == "Control")
    KeybindPage.Visible = (tabName == "Keybinds")
end

local function createTab(text, name, size, pos)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = size
    TabBtn.Position = pos
    TabBtn.Font = FONT
    TabBtn.Text = text
    TabBtn.TextSize = 15
    TabBtn.TextColor3 = COLORS.TextWhite
    TabBtn.Parent = TabContainer
    addCorner(TabBtn, 10)
    
    ConnectClick(TabBtn, function() switchTab(name) end)
    tabButtons[name] = TabBtn
end

createTab("Control", "Control", UDim2.new(0.32, 0, 1, 0), UDim2.new(0, 0, 0, 0))
createTab("Pets", "Pets", UDim2.new(0.32, 0, 1, 0), UDim2.new(0.34, 0, 0, 0))
createTab("Binds", "Keybinds", UDim2.new(0.32, 0, 1, 0), UDim2.new(0.68, 0, 0, 0))

switchTab("Control")

--------------------------------------------------------------------------------
-- POPUP CONTENT
--------------------------------------------------------------------------------
local PopHeader = Instance.new("Frame")
PopHeader.Size = UDim2.new(1, 0, 0, 40)
PopHeader.BackgroundColor3 = Color3.fromRGB(40, 35, 60)
PopHeader.Parent = PopupFrame
addCorner(PopHeader, 16)

local PopTitle = Instance.new("TextLabel")
PopTitle.Text = "Items"
PopTitle.Size = UDim2.new(1, -40, 1, 0)
PopTitle.Position = UDim2.new(0, 15, 0, 0)
PopTitle.BackgroundTransparency = 1
PopTitle.Font = FONT
PopTitle.TextColor3 = COLORS.TextWhite
PopTitle.TextSize = 18
PopTitle.TextXAlignment = Enum.TextXAlignment.Left
PopTitle.Parent = PopHeader

local PopCloseBtn = createXButton(PopupFrame)
PopCloseBtn.ZIndex = 22
ConnectClick(PopCloseBtn, function() PopupFrame.Visible = false end)

local ScrollList = Instance.new("ScrollingFrame")
ScrollList.Size = UDim2.new(1, -20, 1, -60)
ScrollList.Position = UDim2.new(0, 10, 0, 50)
ScrollList.BackgroundTransparency = 1
ScrollList.ScrollBarThickness = 4
ScrollList.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollList.CanvasSize = UDim2.new(0,0,0,0)
ScrollList.Parent = PopupFrame
local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 8)
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = ScrollList

local function PopulateList(title, items, targetTextBox)
    PopTitle.Text = title
    PopupFrame.Visible = true
    PopupFrame.Parent = ScreenGui 
    for _, c in pairs(ScrollList:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, name in ipairs(items) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -10, 0, 40)
        b.BackgroundColor3 = Color3.fromRGB(45, 40, 60)
        b.Text = name
        b.TextColor3 = COLORS.TextWhite
        b.Font = FONT
        b.TextSize = 14
        b.Parent = ScrollList
        addCorner(b, 8)
        ConnectClick(b, function() 
            if targetTextBox then targetTextBox.Text = name end
            PopupFrame.Visible = false
        end)
    end
end

local function createPill(text, parent, bgColor, textColor)
    local Pill = Instance.new("TextButton")
    Pill.Text = text
    Pill.BackgroundColor3 = bgColor or Color3.fromRGB(60, 50, 80)
    Pill.TextColor3 = textColor or Color3.fromRGB(220, 200, 255)
    Pill.Font = FONT
    Pill.TextSize = 12
    Pill.Parent = parent
    addCorner(Pill, 10)
    return Pill
end

--------------------------------------------------------------------------------
-- [TAB 1] PETS PAGE CONTENT
--------------------------------------------------------------------------------
local ItemLabel = Instance.new("TextLabel")
ItemLabel.Text = "Item Name To Add"
ItemLabel.Font = FONT
ItemLabel.TextSize = 14
ItemLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ItemLabel.BackgroundTransparency = 1
ItemLabel.Size = UDim2.new(0, 150, 0, 20)
ItemLabel.Position = UDim2.new(0, 20, 0, 20)
ItemLabel.TextXAlignment = Enum.TextXAlignment.Left
ItemLabel.Parent = PetsPage

-- PET LIST BUTTON
local PetListBtn = createPill("Pet list", PetsPage)
PetListBtn.Size = UDim2.new(0, 60, 0, 20)
PetListBtn.Position = UDim2.new(1, -80, 0, 20)

local InputBoxFrame = Instance.new("Frame")
InputBoxFrame.Size = UDim2.new(1, -40, 0, 45)
InputBoxFrame.Position = UDim2.new(0, 20, 0, 45)
InputBoxFrame.BackgroundColor3 = COLORS.BtnGray
InputBoxFrame.Parent = PetsPage
addCorner(InputBoxFrame, 12)
addStroke(InputBoxFrame, Color3.fromRGB(100, 100, 100), 2)

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(1, 0, 1, 0)
InputBox.BackgroundTransparency = 1
InputBox.Text = petNameGlobal
InputBox.TextColor3 = COLORS.TextWhite
InputBox.Font = FONT
InputBox.TextSize = 18
InputBox.Parent = InputBoxFrame

local AttrContainer = Instance.new("Frame")
AttrContainer.Size = UDim2.new(1, -40, 0, 50)
AttrContainer.Position = UDim2.new(0, 20, 0, 105)
AttrContainer.BackgroundTransparency = 1
AttrContainer.Parent = PetsPage

local function updateBtnColor(btn, isActive)
    local stroke = btn:FindFirstChild("UIStroke")
    if isActive then
        stroke.Color = COLORS.ActiveGreen
        btn.TextColor3 = COLORS.ActiveGreen
    else
        stroke.Color = COLORS.InactiveRed
        btn.TextColor3 = COLORS.InactiveRed
    end
end

local function createAttrBtn(text, xPos, settingKey)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 65, 0, 45)
    Btn.Position = UDim2.new(0, xPos, 0, 0)
    Btn.Text = text
    Btn.Font = FONT
    Btn.TextSize = 20
    Btn.BackgroundColor3 = COLORS.BtnGray
    Btn.Parent = AttrContainer
    addCorner(Btn, 12)
    local stroke = addStroke(Btn, COLORS.InactiveRed, 3)
    updateBtnColor(Btn, petSettings[settingKey])
    return Btn
end

BtnF = createAttrBtn("F", 0, "Fly")
BtnR = createAttrBtn("R", 80, "Ride")
BtnN = createAttrBtn("N", 160, "Neon")
BtnM = createAttrBtn("M", 240, "Mega")

local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(1, -40, 0, 40)
StatusFrame.Position = UDim2.new(0, 20, 0, 170)
StatusFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
StatusFrame.Parent = PetsPage
addCorner(StatusFrame, 10)
addStroke(StatusFrame, Color3.fromRGB(60, 60, 70), 1)
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, 0, 1, 0)
StatusText.BackgroundTransparency = 1
StatusText.RichText = true
StatusText.Text = ""
StatusText.TextColor3 = COLORS.TextWhite
StatusText.Font = FONT
StatusText.TextSize = 16
StatusText.Parent = StatusFrame


-- CHECKBOX FAVORITE
local FavContainer = Instance.new("TextButton")
FavContainer.Size = UDim2.new(0, 150, 0, 25)
FavContainer.Position = UDim2.new(0, 20, 0, 220)
FavContainer.BackgroundTransparency = 1
FavContainer.Text = ""
FavContainer.Parent = PetsPage

local FavCheckBoxBg = Instance.new("Frame")
FavCheckBoxBg.Size = UDim2.new(0, 20, 0, 20)
FavCheckBoxBg.Position = UDim2.new(0, 0, 0.5, -10)
FavCheckBoxBg.BackgroundColor3 = COLORS.BtnGray
FavCheckBoxBg.Parent = FavContainer
addCorner(FavCheckBoxBg, 6)
local FavCheckBoxStroke = addStroke(FavCheckBoxBg, COLORS.DisabledGray, 2)

local FavCheckMark = Instance.new("Frame")
FavCheckMark.Size = UDim2.new(0, 10, 0, 10)
FavCheckMark.Position = UDim2.new(0.5, -5, 0.5, -5)
FavCheckMark.BackgroundColor3 = COLORS.ActiveGreen
FavCheckMark.Visible = SHOULD_FAVORITE_PET
FavCheckMark.Parent = FavCheckBoxBg
addCorner(FavCheckMark, 3)

local FavLabel = Instance.new("TextLabel")
FavLabel.Text = "Favorite on Spawn"
FavLabel.Size = UDim2.new(0, 120, 1, 0)
FavLabel.Position = UDim2.new(0, 30, 0, 0)
FavLabel.BackgroundTransparency = 1
FavLabel.Font = FONT
FavLabel.TextSize = 14
FavLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
FavLabel.TextXAlignment = Enum.TextXAlignment.Left
FavLabel.Parent = FavContainer

ConnectClick(FavContainer, function()
    SHOULD_FAVORITE_PET = not SHOULD_FAVORITE_PET
    FavCheckMark.Visible = SHOULD_FAVORITE_PET
    if SHOULD_FAVORITE_PET then
        FavCheckBoxStroke.Color = COLORS.ActiveGreen
        FavLabel.TextColor3 = COLORS.TextWhite
    else
        FavCheckBoxStroke.Color = COLORS.DisabledGray
        FavLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
end)

local AddBtn = Instance.new("TextButton")
AddBtn.Size = UDim2.new(1, -40, 0, 45)
AddBtn.Position = UDim2.new(0, 20, 0, 260)
AddBtn.BackgroundColor3 = COLORS.BlueAction
AddBtn.Text = "Add Item To Their Trade"
AddBtn.TextColor3 = COLORS.TextWhite
AddBtn.Font = FONT
AddBtn.TextSize = 18
AddBtn.Parent = PetsPage
addCorner(AddBtn, 22)

local CrossLine = Instance.new("Frame")
CrossLine.Size = UDim2.new(0.6, 0, 0, 4)
CrossLine.Position = UDim2.new(0.2, 0, 0.5, -2)
CrossLine.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
CrossLine.BorderSizePixel = 0
CrossLine.Visible = false
CrossLine.Rotation = -5
CrossLine.Parent = AddBtn

local RemoveBtn = Instance.new("TextButton")
RemoveBtn.Size = UDim2.new(1, -40, 0, 45)
RemoveBtn.Position = UDim2.new(0, 20, 0, 320)
RemoveBtn.BackgroundColor3 = COLORS.RedAction
RemoveBtn.Text = "Remove Their Latest Item"
RemoveBtn.TextColor3 = COLORS.TextWhite
RemoveBtn.Font = FONT
RemoveBtn.TextSize = 18
RemoveBtn.Parent = PetsPage
addCorner(RemoveBtn, 22)

local SpawnBtn = Instance.new("TextButton")
SpawnBtn.Size = UDim2.new(1, -40, 0, 45)
SpawnBtn.Position = UDim2.new(0, 20, 0, 380)
SpawnBtn.BackgroundColor3 = COLORS.GreenAction
SpawnBtn.Text = "Spawn Pet In Inventory"
SpawnBtn.TextColor3 = COLORS.TextWhite
SpawnBtn.Font = FONT
SpawnBtn.TextSize = 18
SpawnBtn.Parent = PetsPage
addCorner(SpawnBtn, 22)

local function updatePetUI()
    local currentInput = InputBox.Text
    local validName = validatePetName(currentInput)
    local parts = {}
    if petSettings.Mega then table.insert(parts, string.format('<font color="%s">Mega Neon</font>', COLORS.ColorMega))
    elseif petSettings.Neon then table.insert(parts, string.format('<font color="%s">Neon</font>', COLORS.ColorNeon)) end
    if petSettings.Fly then table.insert(parts, string.format('<font color="%s">Fly</font>', COLORS.ColorFly)) end
    if petSettings.Ride then table.insert(parts, string.format('<font color="%s">Ride</font>', COLORS.ColorRide)) end
    if validName then table.insert(parts, validName) else table.insert(parts, currentInput) end
    StatusText.Text = table.concat(parts, " ")
    if validName then
        petNameGlobal = validName
        AddBtn.BackgroundColor3 = COLORS.BlueAction; AddBtn.Active = true; CrossLine.Visible = false
        SpawnBtn.BackgroundColor3 = COLORS.GreenAction; SpawnBtn.Active = true
    else
        AddBtn.BackgroundColor3 = COLORS.DisabledGray; AddBtn.Active = false; CrossLine.Visible = true
        SpawnBtn.BackgroundColor3 = COLORS.DisabledGray; SpawnBtn.Active = false
    end
end

-- Register Pet Toggles
ConnectClick(BtnF, function() petSettings.Fly = not petSettings.Fly; updateBtnColor(BtnF, petSettings.Fly); updatePetUI() end)
ConnectClick(BtnR, function() petSettings.Ride = not petSettings.Ride; updateBtnColor(BtnR, petSettings.Ride); updatePetUI() end)
ConnectClick(BtnN, function() petSettings.Neon = not petSettings.Neon; if petSettings.Neon then petSettings.Mega = false end; updateBtnColor(BtnN, petSettings.Neon); updateBtnColor(BtnM, petSettings.Mega); updatePetUI() end)
ConnectClick(BtnM, function() petSettings.Mega = not petSettings.Mega; if petSettings.Mega then petSettings.Neon = false end; updateBtnColor(BtnM, petSettings.Mega); updateBtnColor(BtnN, petSettings.Neon); updatePetUI() end)
InputBox:GetPropertyChangedSignal("Text"):Connect(updatePetUI)
updatePetUI()

local petData = {"Bat Dragon", "Shadow Dragon", "Evil Unicorn", "Crow", "Giraffe", "Parrot", "Frost Dragon", "Owl", "Turtle", "Kangaroo"}

-- Register List Button
RegisterKeybindAction("Available Pets", PetListBtn, function() PopulateList("Available Pets", petData, InputBox) end)

--------------------------------------------------------------------------------
-- [TAB 2] CONTROL PAGE CONTENT
--------------------------------------------------------------------------------
local ControlLabel = Instance.new("TextLabel")
ControlLabel.Text = "Target Username"
ControlLabel.Font = FONT
ControlLabel.TextSize = 14
ControlLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ControlLabel.BackgroundTransparency = 1
ControlLabel.Size = UDim2.new(0, 150, 0, 20)
ControlLabel.Position = UDim2.new(0, 20, 0, 20)
ControlLabel.TextXAlignment = Enum.TextXAlignment.Left
ControlLabel.Parent = ControlPage

-- BUTTONS ALIGNED RIGHT
local ServerListBtn = createPill("List", ControlPage, COLORS.BtnActivePurple, COLORS.TextWhite)
ServerListBtn.Size = UDim2.new(0, 40, 0, 20) 
ServerListBtn.Position = UDim2.new(1, -60, 0, 20) 

local RandomBtn = createPill("Random", ControlPage, COLORS.TextWhite, COLORS.Background)
RandomBtn.Size = UDim2.new(0, 80, 0, 20) 
RandomBtn.Position = UDim2.new(1, -145, 0, 20) 

local LatestBtn = createPill("Latest", ControlPage, COLORS.PurpleAction, COLORS.TextWhite)
LatestBtn.Size = UDim2.new(0, 80, 0, 20) 
LatestBtn.Position = UDim2.new(1, -229, 0, 20) 

-- Input for Player
local PlayerInputFrame = Instance.new("Frame")
PlayerInputFrame.Size = UDim2.new(1, -40, 0, 45)
PlayerInputFrame.Position = UDim2.new(0, 20, 0, 45)
PlayerInputFrame.BackgroundColor3 = COLORS.BtnGray
PlayerInputFrame.Parent = ControlPage
addCorner(PlayerInputFrame, 12)
addStroke(PlayerInputFrame, Color3.fromRGB(100, 100, 100), 2)

local PlayerInput = Instance.new("TextBox")
PlayerInput.Size = UDim2.new(1, 0, 1, 0)
PlayerInput.BackgroundTransparency = 1
PlayerInput.Text = "KREEKRFATF123123"
PlayerInput.PlaceholderText = "Enter Username..."
PlayerInput.TextColor3 = COLORS.TextWhite
PlayerInput.Font = FONT
PlayerInput.TextSize = 18
PlayerInput.Parent = PlayerInputFrame

-- TRUSTED CHECKBOX
local TrustedContainer = Instance.new("TextButton")
TrustedContainer.Size = UDim2.new(0, 150, 0, 25)
TrustedContainer.Position = UDim2.new(0, 20, 0, 100)
TrustedContainer.BackgroundTransparency = 1
TrustedContainer.Text = ""
TrustedContainer.Parent = ControlPage

local CheckBoxBg = Instance.new("Frame")
CheckBoxBg.Size = UDim2.new(0, 20, 0, 20)
CheckBoxBg.Position = UDim2.new(0, 0, 0.5, -10)
CheckBoxBg.BackgroundColor3 = COLORS.BtnGray
CheckBoxBg.Parent = TrustedContainer
addCorner(CheckBoxBg, 6)
local CheckBoxStroke = addStroke(CheckBoxBg, COLORS.DisabledGray, 2)

local CheckMark = Instance.new("Frame")
CheckMark.Size = UDim2.new(0, 10, 0, 10)
CheckMark.Position = UDim2.new(0.5, -5, 0.5, -5)
CheckMark.BackgroundColor3 = COLORS.ActiveGreen
CheckMark.Visible = false 
CheckMark.Parent = CheckBoxBg
addCorner(CheckMark, 3)

local CheckLabel = Instance.new("TextLabel")
CheckLabel.Text = "Make player trusted"
CheckLabel.Size = UDim2.new(0, 120, 1, 0)
CheckLabel.Position = UDim2.new(0, 30, 0, 0)
CheckLabel.BackgroundTransparency = 1
CheckLabel.Font = FONT
CheckLabel.TextSize = 14
CheckLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
CheckLabel.TextXAlignment = Enum.TextXAlignment.Left
CheckLabel.Parent = TrustedContainer

-- Register toggle
RegisterKeybindAction("Toggle Trusted", TrustedContainer, function()
    isTrusted = not isTrusted
    CheckMark.Visible = isTrusted
    if isTrusted then
        CheckBoxStroke.Color = COLORS.ActiveGreen
        CheckLabel.TextColor3 = COLORS.TextWhite
    else
        CheckBoxStroke.Color = COLORS.DisabledGray
        CheckLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
end)

-- ACTION BUTTONS
local function createActionButton(text, color, yPos, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -40, 0, 45) 
    btn.Position = UDim2.new(0, 20, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = COLORS.TextWhite

    btn.Font = FONT
    btn.TextSize = 18 
    btn.Parent = parent
    addCorner(btn, 22) 
    return btn
end

local startY = 135
local StartTradeBtn = createActionButton("Start Trade", COLORS.BlueAction, startY, ControlPage)
local AcceptTradeBtn = createActionButton("Accept Trade", COLORS.YellowAction, startY + 55, ControlPage)
local ConfirmTradeBtn = createActionButton("Confirm Trade", COLORS.GreenAction, startY + 110, ControlPage)
local CancelTradeBtn = createActionButton("Cancel Trade", COLORS.RedAction, startY + 165, ControlPage)

--------------------------------------------------------------------------------
-- PLAYER LOGIC & FINAL BINDING
--------------------------------------------------------------------------------
local activePlayers = {}

local function updatePlayerTable()
    table.clear(activePlayers)
    for _, plr in ipairs(Players:GetPlayers()) do
        table.insert(activePlayers, plr.Name)
    end
end

Players.PlayerAdded:Connect(function(plr) table.insert(activePlayers, plr.Name) end)
Players.PlayerRemoving:Connect(function(plr)
    for i, name in ipairs(activePlayers) do
        if name == plr.Name then table.remove(activePlayers, i); break end
    end
end)
updatePlayerTable()

-- REGISTER ALL ACTIONS TO KEYBIND SYSTEM
RegisterKeybindAction("Select Random", RandomBtn, function()
    local candidates = {}
    for _, name in ipairs(activePlayers) do
        if name ~= LocalPlayer.Name then table.insert(candidates, name) end
    end
    if #candidates > 0 then
        PlayerInput.Text = candidates[math.random(1, #candidates)]
    else
        PlayerInput.Text = "No other players :("
    end
end)

RegisterKeybindAction("Select Latest", LatestBtn, function()
    PlayerInput.Text = LATEST_PERSON_TRADED
end)

RegisterKeybindAction("Player List", ServerListBtn, function()
    PopulateList("Server Players", activePlayers, PlayerInput)
end)

-- The Main Actions
RegisterKeybindAction("Start Trade", StartTradeBtn, function() recieveTradeRequest(PlayerInput.Text, isTrusted and 'friend') end)
RegisterKeybindAction("Accept Trade", AcceptTradeBtn, function() acceptTradeFromHisSide() end)
RegisterKeybindAction("Confirm Trade", ConfirmTradeBtn, function() confirmTradeFromHisSide() end)
RegisterKeybindAction("Cancel Trade", CancelTradeBtn, function() endTrade() end)

-- UPDATED BIND REGISTRATION FOR PET PAGE
RegisterKeybindAction("Add Item", AddBtn, function() addItemByIdFromHisSide() end)
RegisterKeybindAction("Remove Item", RemoveBtn, function() removeLastItemFromHisSide() end)
RegisterKeybindAction("Spawn Pet", SpawnBtn, function() SpawnPetFunction() end)

--------------------------------------------------------------------------------
-- [TAB 3] KEYBIND PAGE GENERATION
--------------------------------------------------------------------------------

-- SCROLLING LIST FOR BINDS
local BindScroll = Instance.new("ScrollingFrame")
BindScroll.Size = UDim2.new(1, 0, 1, 0)
BindScroll.BackgroundTransparency = 1
BindScroll.ScrollBarThickness = 2
BindScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
BindScroll.CanvasSize = UDim2.new(0,0,0,0)
BindScroll.Parent = KeybindPage
addCorner(BindScroll, 0)

local BindListLayout = Instance.new("UIListLayout")
BindListLayout.Padding = UDim.new(0, 6)
BindListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
BindListLayout.SortOrder = Enum.SortOrder.LayoutOrder
BindListLayout.Parent = BindScroll

local BindPadding = Instance.new("UIPadding")
BindPadding.PaddingTop = UDim.new(0, 15)
BindPadding.Parent = BindScroll

-- Function to render the keybind rows
local function CreateBindRow(bindEntry)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(0.9, 0, 0, 45)
    Row.BackgroundColor3 = COLORS.BtnGray
    Row.Parent = BindScroll
    addCorner(Row, 10)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = bindEntry.Name
    Label.TextColor3 = COLORS.TextWhite
    Label.Font = FONT
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row
    
    local BindBtn = Instance.new("TextButton")
    BindBtn.Size = UDim2.new(0.3, 0, 0, 30)
    BindBtn.Position = UDim2.new(0.65, 0, 0.5, -15)
    BindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    BindBtn.Text = "None"
    BindBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    BindBtn.Font = FONT
    BindBtn.TextSize = 14
    BindBtn.Parent = Row
    addCorner(BindBtn, 8)
    addStroke(BindBtn, COLORS.StrokePurple, 1)
    
    -- BINDING LOGIC
    BindBtn.MouseButton1Click:Connect(function()
        if isBinding then return end -- Prevent multiple binds at once
        isBinding = true
        BindBtn.Text = "..."
        BindBtn.TextColor3 = COLORS.YellowAction
        
        local inputConnection
        inputConnection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local key = input.KeyCode
                
                -- 1. Update Data
                bindEntry.Key = key
                
                -- 2. Update GUI Button Text (The one in Control/Pets tab)
                -- E.g. "Start Trade (E)"
                local keyName = key.Name
                bindEntry.BtnRef.Text = bindEntry.OriginalText .. " (" .. keyName .. ")"
                
                -- 3. Update Bind Button Text
                BindBtn.Text = keyName
                BindBtn.TextColor3 = COLORS.ActiveGreen
                
                -- Cleanup
                isBinding = false
                inputConnection:Disconnect()
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                -- Cancel if clicked elsewhere (optional, simplest is just wait for key)
                -- For now we just wait for a key.
            end
        end)
    end)
end

-- Generate rows
for _, bind in ipairs(Keybinds) do
    CreateBindRow(bind)
end

local function CreateNormalPetCounter(parentFrame)
    -- 1. Container for the whole section (transparent frame to hold elements together)
    local SectionContainer = Instance.new("Frame")
    -- Position it below the existing Cancel Trade button. 
    -- Previous buttons ended around Y offset 300. Let's place this at 320.
    SectionContainer.Position = UDim2.new(0, 20, 0, 330) 
    SectionContainer.Size = UDim2.new(1, -40, 0, 120) 
    SectionContainer.BackgroundTransparency = 1
    SectionContainer.Name = "NormalPetCounterSection"
    SectionContainer.Parent = parentFrame

    -- 3. Container for the +/- buttons and display box
    local ControlsRow = Instance.new("Frame")
    ControlsRow.Size = UDim2.new(1, 0, 0, 40)
    ControlsRow.Position = UDim2.new(0, 0, 0, 25)
    ControlsRow.BackgroundTransparency = 1
    ControlsRow.Parent = SectionContainer

    -- Layout for horizontal alignment
    local listLayoutH = Instance.new("UIListLayout")
    listLayoutH.FillDirection = Enum.FillDirection.Horizontal
    listLayoutH.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayoutH.VerticalAlignment = Enum.VerticalAlignment.Center
    listLayoutH.Padding = UDim.new(0, 4)
    listLayoutH.Parent = ControlsRow

    -- Define Generate Button early so update function can use it
    local GenerateButton = Instance.new("TextButton")

    -- Function to update display and ensure count is valid
    local function UpdateDisplay()
        petCount = math.max(1, petCount) -- Ensure minimum is always 1
        GenerateButton.Text = "Generate [" .. petCount .. "] Pets"
    end

    -- Helper function to create standard-looking increment buttons
    local function createNormalBtn(text, change, layoutOrder)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 48, 1, 0) -- Slightly narrower to fit 6 buttons + display
        btn.BackgroundColor3 = COLORS.BtnGray -- Use standard gray button color
        btn.Text = text
        btn.TextColor3 = COLORS.TextWhite
        btn.Font = FONT
        btn.TextSize = 15
        btn.LayoutOrder = layoutOrder
        btn.Parent = ControlsRow
        addCorner(btn, 8)

        btn.MouseButton1Click:Connect(function()
            petCount = petCount + change
            UpdateDisplay()
        end)
        return btn
    end

    -- Create Buttons in a standard "- on left, + on right" layout
    createNormalBtn("-100", -100, 1)
    createNormalBtn("-10", -10, 2)
    createNormalBtn("-1", -1, 3)

    createNormalBtn("+1", 1, 5)
    createNormalBtn("+10", 10, 6)
    createNormalBtn("+100", 100, 7)


    -- 4. The Final Generate Action Button
    GenerateButton.Size = UDim2.new(1, 0, 0, 40)
    -- Position below the controls row
    GenerateButton.Position = UDim2.new(0, 0, 0, 75) 
    GenerateButton.BackgroundColor3 = COLORS.PurpleAction -- Use standard action color
    GenerateButton.TextColor3 = COLORS.TextWhite
    GenerateButton.Font = FONT
    GenerateButton.TextSize = 18
    GenerateButton.Parent = SectionContainer
    addCorner(GenerateButton, 12)

    GenerateButton.MouseButton1Click:Connect(function()
        -- Execute the generation function using the global petCount
        PresetStart(petCount)
    end)

    -- Initialize display state
    UpdateDisplay()

    return SectionContainer
end

-- Create the new normal looking counter on the ControlPage
CreateNormalPetCounter(ControlPage)


--------------------------------------------------------------------------------
-- MOBILE LOCK (BLOCK KEYBIND PAGE ON PHONES)
--------------------------------------------------------------------------------
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

if isMobile then
    local BlockFrame = Instance.new("Frame")
    BlockFrame.Size = UDim2.new(1, 0, 1, 0)
    BlockFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    BlockFrame.BackgroundTransparency = 0.1
    BlockFrame.ZIndex = 50
    BlockFrame.Parent = KeybindPage
    addCorner(BlockFrame, 20)
    
    local XMark = Instance.new("TextLabel")
    XMark.Text = "X"
    XMark.Size = UDim2.new(1, 0, 1, 0)
    XMark.BackgroundTransparency = 1
    XMark.TextColor3 = COLORS.InactiveRed
    XMark.Font = FONT
    XMark.TextSize = 100
    XMark.Parent = BlockFrame
    
    local WarnText = Instance.new("TextLabel")
    WarnText.Text = "PC ONLY"
    WarnText.Size = UDim2.new(1, 0, 0, 50)
    WarnText.Position = UDim2.new(0, 0, 0.6, 0)
    WarnText.BackgroundTransparency = 1
    WarnText.TextColor3 = COLORS.TextWhite
    WarnText.Font = FONT
    WarnText.TextSize = 24
    WarnText.Parent = BlockFrame
end


