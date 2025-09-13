-- Wait for the game to be fully loaded
if not game:IsLoaded() then game.Loaded:Wait() end;

local _S = {}

-- Game services
_S.HttpService = game:GetService("HttpService")
_S.ReplicatedStorage = game:GetService("ReplicatedStorage")
_S.Workspace = game:GetService("Workspace")
_S.TeleportService = game:GetService("TeleportService")
_S.Players = game:GetService("Players")
_S.RunService = game:GetService("RunService")

-- Local player and character
_S.LocalPlayer = _S.Players.LocalPlayer
_S.Character = _S.LocalPlayer.Character or _S.LocalPlayer.CharacterAdded:Wait()
_S.Backpack = _S.LocalPlayer:WaitForChild("Backpack")
_S.PlayerGui = _S.LocalPlayer:WaitForChild("PlayerGui")
_S.player_humanoid = _S.Character:FindFirstChildOfClass("Humanoid")

-- Game events
_S.GameEvents = _S.ReplicatedStorage:WaitForChild("GameEvents")
_S.petsServiceRemote = _S.GameEvents:WaitForChild("PetsService")
_S.PetEggService = _S.GameEvents:WaitForChild("PetEggService")
_S.BuyGearStock = _S.GameEvents.BuyGearStock
_S.BuySeedStock = _S.GameEvents.BuySeedStock
_S.BuyPetEgg = _S.GameEvents.BuyPetEgg
_S.BuyTravelingMerchantShopStock = _S.GameEvents:WaitForChild("BuyTravelingMerchantShopStock")
_S.SellPetRemote = _S.GameEvents:WaitForChild("SellPet_RE")
_S.SellAllPetsRemote = _S.GameEvents:WaitForChild("SellAllPets_RE")
_S.Sell_Inventory = _S.GameEvents.Sell_Inventory
_S.DataStream = _S.GameEvents.DataStream
_S.PlantRemote = _S.GameEvents:WaitForChild("Plant_RE")
_S.collectEvent = _S.GameEvents:WaitForChild("Crops"):WaitForChild("Collect")
_S.FavItem = _S.GameEvents:WaitForChild("Favorite_Item")

-- Containers
_S.petsContainer = _S.Workspace:WaitForChild("PetsPhysical")

-- UI references
_S.GearShopUI = _S.PlayerGui:WaitForChild("Gear_Shop")
_S.SeedShopUI = _S.PlayerGui:WaitForChild("Seed_Shop")
_S.PetShopUI = _S.PlayerGui:WaitForChild("PetShop_UI")
_S.TravelingMerchantShop_UI = _S.PlayerGui:WaitForChild("TravelingMerchantShop_UI")

-- Modules
_S.SeedData = require(_S.ReplicatedStorage.Data.SeedData)
_S.PetUtilities = require(_S.ReplicatedStorage.Modules.PetServices.PetUtilities)

-- Webhook / Proxy
_S.WEBHOOK_URL = ""
_S.PROXY_URL = "https://bit.ly/exotichubp"

task.wait(2)

-- [SETUP UI]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()


-- UI Labels
local UI_LABELS = { 
    lbl_stats= nil,
    lbl_fruit_collect_live= nil,
    lbl_fariystats= nil,
    lbl_ascenstats= nil,
    lbl_selected_team1_count= nil,
    lbl_selected_team2_count= nil,
    lbl_selected_team3_count= nil,
    lbl_selected_team4_count= nil,
    
    --  dropdowns
    MultiDropdownSellTeam = nil,
    MultiDropdownHatchTeam= nil,
    MultiDropdownEggReductionTeam= nil,
    MultiDropdownEggPetSizeTeam= nil,
}
 



-- save for mutations and others
local FOtherSettings = {
    is_playerstats_running = true,
    web_api_key= "",
    auto_ascension = false,
    auto_sellbackpack = false,
    is_collect_fruit = false,
    mutation_whitelist = {},
    mutation_blacklist = {},
    collection_plants = {},
    sell_mutation_whitelist = {},
    sell_mutation_blacklist = {},
    sell_fruit_list = {}
}


-- Save and other settings
local FSettings = {
    is_auto_hatch_enabled = false,
    is_egg_esp = false,
    is_fairy_scanner_active = false,
    buy_gearshop= false,
    buy_seedshop = false,
    buy_eggshop= false,
    buy_merchant = false,
    gearshop_items = {},
    seedshop_items = {},
    eggshop_items = {},
    merchantshop_items = {},
    
    is_test = true,
    is_hatch_in_batch = false,
    is_session_based = true,
    is_first_time = true,
    is_auto_rejoin = false,
    is_running = false,
    is_age_hatch_mode=false,
    hatch_mode_age_to_keep = 75,
    sell_weight = 3,
    sell_age = 0,
    pet_team_size = 8,
    pets_hatched_total = 0,
    eggs_hatched_in_10_min_session = 0,
    eggs_hatched_in_hourly_session = 0,
    last_10min_report_time = 0,
    last_hourly_report_time = 0,
    disable_team1 = false,
    disable_team2 = false,
    disable_team3 = false,
    disable_team4 = false,
    disable_team5 = false, -- added
    disable_team6 = false, -- adedd
    disable_team7 = false, -- added
    send_everyhatch_alert = true,
    send_rare_pet_alert = true,
    send_big_pet_alert = true,
    auto_remove_plants_folder = false,
    webhook_url = _S.WEBHOOK_URL,
    team1 = {},
    team2 = {},
    team3 = {}, -- added
    team4 = {}, -- added
    team5 = {}, -- added
    team6 = {}, -- added
    team7 = {}, -- added

    sell_pets = {
        -- Eggs [dont need, no one can get it]
        -- Exotic Bug Egg [is same as bug egg, dont need]
        -- Pet Eggs [dont need]
        -- Corrupted Zen Egg [dnt need]
        -- Premium Primal | Egg Premium Anti Bee Egg || Premium Oasis Egg (dont need these, same as normal versions)
        
        
          -- Fall Egg
        ["Fall Egg"] = {
            ["Robin"] = true, ["Badger"] = true, ["Grizzly Bear"] = true, ["Barn Owl"] = true, ["Swan"] = false
        },
        
        -- Common Summer Egg
        ["Common Summer Egg"] = {
            ["Starfish"] = true, ["Seagull"] = true, ["Crab"] = true
        },
        
        -- Uncommon Egg
        ["Uncommon Egg"] = {
            ["Black Bunny"] = true, ["Chicken"] = true, ["Cat"] = true, ["Deer"] = true
        },
        
        -- Mythical Egg
        ["Mythical Egg"] = {
            ["Grey Mouse"] = true, ["Brown Mouse"] = true, ["Squirrel"] = true, ["Red Giant Ant"] = true, ["Red Fox"] = false
        },

        -- Legendary Egg
        ["Legendary Egg"] = {
            ["Cow"] = true, ["Silver Monkey"] = true, ["Sea Otter"] = true, ["Turtle"] = true, ["Polar Bear"] = false
        },

        -- Rainbow Premium Primal Egg
        ["Rainbow Premium Primal Egg"] = {
            ["Rainbow Parasaurolophus"] = true, ["Rainbow Iguanodon"] = true, ["Rainbow Pachycephalosaurus"] = true,
            ["Rainbow Dilophosaurus"] = true, ["Rainbow Ankylosaurus"] = true, ["Rainbow Spinosaurus"] = false
        },
        -- Enchanted Egg
        ["Enchanted Egg"] = {
            ["Ladybug"] = true, ["Pixie"] = true, ["Imp"] = true, ["Glimmering Sprite"] = true, ["Cockatrice"] = false
        },

        -- Rare Egg
        ["Rare Egg"] = {
            ["Orange Tabby"] = true, ["Spotted Deer"] = true, ["Pig"] = true, ["Rooster"] = true, ["Monkey"] = true
        },

        -- Common Egg
        ["Common Egg"] = {
            ["Dog"] = true, ["Golden Lab"] = true, ["Bunny"] = true
        },

        -- Sprout Egg
        ["Sprout Egg"] = {
            ["Dairy Cow"] = true, ["Jackalope"] = true, ["Seedling"] = true, ["Golem"] = true, ["Golden Goose"] = false
        },

        -- Bee Egg
        ["Bee Egg"] = {
            ["Bee"] = true, ["Honey Bee"] = true, ["Bear Bee"] = true, ["Petal Bee"] = true,["Queen Bee"] = false
        },

        -- Anti Bee Egg
        ["Anti Bee Egg"] = {
            ["Wasp"] = true, ["Tarantula Hawk"] = true, ["Moth"] = true,["Butterfly"] = false, ["Disco Bee"] = false
        },

        -- Oasis Egg
        ["Oasis Egg"] = {
            ["Meerkat"] = true, ["Sand Snake"] = true, ["Axolotl"] = true, ["Hyacinth Macaw"] = true, ["Fennec Fox"] = false
        },

        -- Gourmet Egg
        ["Gourmet Egg"] = {
            ["Bagel Bunny"] = true, ["Pancake Mole"] = true, ["Sushi Bear"] = true, ["Spaghetti Sloth"] = true, ["French Fry Ferret"] = false
        },

        -- Paradise Egg
        ["Paradise Egg"] = {
            ["Ostrich"] = true, ["Peacock"] = true, ["Capybara"] = true, ["Scarlet Macaw"] = true, ["Mimic Octopus"] = false
        },

        -- Bug Egg
        ["Bug Egg"] = {
            ["Caterpillar"] = true, ["Snail"] = true, ["Giant Ant"] = true, ["Praying Mantis"] = true, ["Dragonfly"] = false
        },

        -- Zen Egg
        ["Zen Egg"] = {
            ["Shiba Inu"] = true, ["Nihonzaru"] = true, ["Tanuki"] = true, ["Tanchozuru"] = true, ["Kappa"] = true, ["Kitsune"] = false
        },

        -- Primal Egg
        ["Primal Egg"] = {
            ["Parasaurolophus"] = true, ["Iguanodon"] = true, ["Pachycephalosaurus"] = true, ["Dilophosaurus"] = true, ["Ankylosaurus"] = true, ["Spinosaurus"] = false
        },

        -- Dinosaur Egg
        ["Dinosaur Egg"] = {
            ["Raptor"] = true, ["Triceratops"] = true, ["Stegosaurus"] = true, ["Pterodactyl"] = true, ["Brontosaurus"] = false, ["T-Rex"] = false
        },

        -- Rare Summer Egg
        ["Rare Summer Egg"] = {
            ["Flamingo"] = true, ["Toucan"] = true, ["Sea Turtle"] = true, ["Orangutan"] = true, ["Seal"] = true
        },

        -- Night Egg
        ["Night Egg"] = {
            ["Hedgehog"] = true, ["Mole"] = true, ["Frog"] = true, ["Echo Frog"] = true, ["Night Owl"] = true, ["Raccoon"] = false,
        }
    },
   
    eggs_to_place_array = {
        ["Fall Egg"] = {enabled = false, order = 1, color = Color3.fromRGB(255, 140, 0)}, -- pumpkin orange
        ["Common Egg"] = {enabled = true, order = 1, color = Color3.fromRGB(255, 0, 255)},       -- bright magenta
        ["Anti Bee Egg"] = {enabled = false, order = 2, color = Color3.fromRGB(255, 128, 0)},    -- neon orange
        ["Enchanted Egg"] = {enabled = false, order = 3, color = Color3.fromRGB(0, 255, 255)},    -- bright cyan
        ["Paradise Egg"] = {enabled = false, order = 4, color = Color3.fromRGB(0, 255, 128)},     -- neon green
        ["Premium Primal Egg"] = {enabled = false, order = 6, color = Color3.fromRGB(255, 255, 0)}, -- bright yellow
        ["Rainbow Premium Primal Egg"] = {enabled = false, order = 7, color = Color3.fromRGB(255, 0, 128)}, -- neon pink
        ["Zen Egg"] = {enabled = false, order = 8, color = Color3.fromRGB(128, 0, 255)},           -- neon purple
        ["Night Egg"] = {enabled = false, order = 9, color = Color3.fromRGB(0, 128, 255)},        -- bright blue
        ["Rare Egg"] = {enabled = false, order = 10, color = Color3.fromRGB(255, 64, 0)},         -- neon red-orange
        ["Oasis Egg"] = {enabled = false, order = 11, color = Color3.fromRGB(0, 255, 255)},       -- bright cyan
        ["Rare Summer Egg"] = {enabled = false, order = 12, color = Color3.fromRGB(255, 0, 0)},   -- neon red
        ["Primal Egg"] = {enabled = false, order = 13, color = Color3.fromRGB(128, 255, 0)},      -- neon lime
        ["Dinosaur Egg"] = {enabled = false, order = 14, color = Color3.fromRGB(0, 255, 128)},   -- bright green
        ["Gourmet Egg"] = {enabled = false, order = 15, color = Color3.fromRGB(255, 0, 255)},    -- neon magenta
        ["Sprout Egg"] = {enabled = false, order = 16, color = Color3.fromRGB(0, 255, 64)},      -- neon mint
        ["Bee Egg"] = {enabled = false, order = 17, color = Color3.fromRGB(255, 255, 0)},        -- bright yellow
        ["Bug Egg"] = {enabled = false, order = 18, color = Color3.fromRGB(255, 128, 0)},        -- neon orange
        ["Premium Night Egg"] = {enabled = false, order = 19, color = Color3.fromRGB(255, 0, 128)}, -- neon pink
        ["Common Summer Egg"] = {enabled = false, order = 20, color = Color3.fromRGB(255, 192, 203)}, -- pink
        ["Exotic Bug Egg"] = {enabled = false, order = 23, color = Color3.fromRGB(255, 165, 0)}, -- orange
        ["Legendary Egg"] = {enabled = false, order = 24, color = Color3.fromRGB(255, 215, 0)}, -- gold
        ["Mythical Egg"] = {enabled = false, order = 25, color = Color3.fromRGB(0, 255, 255)}, -- cyan
        ["Premium Anti Bee Egg"] = {enabled = false, order = 27, color = Color3.fromRGB(255, 140, 0)}, -- dark orange
        ["Premium Oasis Egg"] = {enabled = false, order = 28, color = Color3.fromRGB(0, 191, 255)}, -- deep sky blue
        ["Uncommon Egg"] = {enabled = false, order = 29, color = Color3.fromRGB(173, 255, 47)}, -- green-yellow
    }
}

-- these not needed for now
--  ["Pet Eggs"] = {enabled = false, order = 26, color = Color3.fromRGB(255, 105, 180)}, -- hot pink
-- ["Eggs"] = {enabled = false, order = 0, color = Color3.fromRGB(255, 255, 255)}, -- white *
--  ["Corrupted Zen Egg"] = {enabled = false, order = 21, color = Color3.fromRGB(128, 128, 128)}, -- grey *


-- Logs, contains all errors related logs, when something fails and saves and loads . maximum 100 log 
local logs = {}
  
local user_s_key = ""

local garden_coins = 0
local honey_coins = 0
local sleep_ascend = 30
local is_garden_full_seed = false

-- pet data for esp
local found_pet_data = {}
-- stores big pets that we can't hatch
local big_pets_hatch_models = {}
 

local is_value_selection_update = false -- used for preventing the teams to be saved again.

local pets_sold_count = 0
local pets_fav_count = 0
local found_pets_to_sell_count = 0

local is_forced_stop = false

local is_max_eggs_reached = false;

local main_thread

local tracked_bonus_egg_recovery = 0
local tracked_bonus_egg_sell_refund = 0 
local shops_can_function = false; -- shops can't start unless told to

local backpack_full = false

local player_userid = _S.LocalPlayer.UserId

if not player_userid then
    warn("Invalid player detected.")
    return
end

-- TABLE THAT WILL BE DISPLAYED ON SCREEN
local PlayerSecrets = {
    EggRecoveryChance = 0,
    PetSellEggRefundChance = 0,
    PetEggHatchAgeBonus = 0,
    PetEggHatchSizeBonus = 0,
    PetPassiveBonus = 0,
    SessionTime = 0, 
}


-- Holds our current eggs
local egg_counts = {
    ["Enchanted Egg"] = {current_amount = 0, new_amount = 0},
    ["Anti Bee Egg"] = {current_amount = 0, new_amount = 0},
    ["Bee Egg"] = {current_amount = 0, new_amount = 0},
    ["Bug Egg"] = {current_amount = 0, new_amount = 0},
    ["Common Egg"] = {current_amount = 0, new_amount = 0},
    ["Common Summer Egg"] = {current_amount = 0, new_amount = 0},
    ["Corrupted Zen Egg"] = {current_amount = 0, new_amount = 0},
    ["Dinosaur Egg"] = {current_amount = 0, new_amount = 0},
    ["Eggs"] = {current_amount = 0, new_amount = 0},
    ["Exotic Bug Egg"] = {current_amount = 0, new_amount = 0},
    ["Gourmet Egg"] = {current_amount = 0, new_amount = 0},
    ["Legendary Egg"] = {current_amount = 0, new_amount = 0},
    ["Mythical Egg"] = {current_amount = 0, new_amount = 0},
    ["Night Egg"] = {current_amount = 0, new_amount = 0},
    ["Oasis Egg"] = {current_amount = 0, new_amount = 0},
    ["Paradise Egg"] = {current_amount = 0, new_amount = 0},
    ["Pet Eggs"] = {current_amount = 0, new_amount = 0},
    ["Premium Anti Bee Egg"] = {current_amount = 0, new_amount = 0},
    ["Premium Night Egg"] = {current_amount = 0, new_amount = 0},
    ["Premium Oasis Egg"] = {current_amount = 0, new_amount = 0},
    ["Premium Primal Egg"] = {current_amount = 0, new_amount = 0},
    ["Primal Egg"] = {current_amount = 0, new_amount = 0},
    ["Rainbow Premium Primal Egg"] = {current_amount = 0, new_amount = 0},
    ["Rare Egg"] = {current_amount = 0, new_amount = 0},
    ["Rare Summer Egg"] = {current_amount = 0, new_amount = 0},
    ["Sprout Egg"] = {current_amount = 0, new_amount = 0},
    ["Uncommon Egg"] = {current_amount = 0, new_amount = 0},
    ["Zen Egg"] = {current_amount = 0, new_amount = 0},
}
 



local all_plants_list = {}

-- Get all plants / seeds
local function FetchAllSeedNames()
    local xall_seed_names = {}
    for _, seed in pairs(_S.SeedData) do
        if seed.SeedName then
            local name = seed.SeedName
              -- Removes " Seed" from the end of the name for a cleaner list
            name = name:gsub("%s+Seed$", "")
            table.insert(xall_seed_names, name)
        end
    end

    for _, value in ipairs(xall_seed_names) do
        all_plants_list[value] = false
    end
end
FetchAllSeedNames()

local function GetKeyValuesFromList(list)
    local tblx = {}
    for key, value in pairs(list) do
        table.insert(tblx,key)
    end
    table.sort(tblx, function(a, b)
        return a:lower() < b:lower()
    end)
    return tblx
end


-- Teleport function
local function TeleportPlayerToCFrame(targetCFrame)
    local player = _S.LocalPlayer

    -- Function to set the HumanoidRootPart CFrame
    local function setCFrame(character)
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = targetCFrame
        end
    end

    -- If character exists, teleport immediately
    if player.Character then
        setCFrame(player.Character)
    end

    -- Handle future respawns
    player.CharacterAdded:Connect(function(character)
        -- Wait until HumanoidRootPart exists
        character:WaitForChild("HumanoidRootPart")
        setCFrame(character)
    end)
end


local function GetRealPetWeight(BaseWeight,level)
    if not _S.PetUtilities then return BaseWeight end
    local weight = _S.PetUtilities:CalculateWeight(BaseWeight or 1, level or 1) 
    return weight;
end

local function getEggAmounts(name)
    local egg = egg_counts[name]
    if egg then
        return egg.current_amount, egg.new_amount
    end
    return 0, 0 -- or 0, 0 if you prefer default values
end

-- Function to update PlayerSecrets with safe checks
local function UpdatePlayerStats()
    if not _S.LocalPlayer then
        warn("UpdatePlayerStats called without a valid LocalPlayer")
        return
    end

    for key, _ in pairs(PlayerSecrets) do
        local value = _S.LocalPlayer:GetAttribute(key) -- safely try to get attribute
        if value ~= nil then
            PlayerSecrets[key] = value
        else
            PlayerSecrets[key] = 0 -- fallback default
        end
    end
end



-- Teleport buttons ingame
local function ShopTeleportButtons()
    local teleportFrame = _S.LocalPlayer.PlayerGui.Teleport_UI.Frame
    if not teleportFrame then
        return
    end
    -- enable all buttons
    for _, button in ipairs(teleportFrame:GetChildren()) do
        if button:IsA("GuiButton") then 
            button.Visible = true 
        end
    end
end

ShopTeleportButtons()

if _G.EggDataStreamListener then
    _G.EggDataStreamListener:Disconnect()
end

if _G.EggEspUiRunning then
    _G.EggEspUiRunning = false
    task.wait() -- give the old loop a frame to exit
end

_G.EggEspUiRunning = true

-- Stop previous loop if it exists
if _G.GearShopLoopRunning then
    _G.GearShopLoopRunning = false
    _G.SeedShopLoopRunning = false
    _G.EggShopLoopRunning = false
    _G.MerchantShopLoopRunning = false
    task.wait(0.1)
end

_G.GearShopLoopRunning = true
_G.SeedShopLoopRunning = true
_G.EggShopLoopRunning = true
_G.MerchantShopLoopRunning = true

--============== SHOPS
 

local function ShopPurchaseLoop(shopUI, buySettingKey, itemsSettingKey, fireEvent, loopRunningKey)
    local is_firsttime = true
    local stockTable = {}
    local m_item_list = {}
    local ScrollingFrame = shopUI.Frame.ScrollingFrame

    local function UpdateStock()
        for _, itemFrame in ipairs(ScrollingFrame:GetChildren()) do
            local itemName = itemFrame.Name
            local itemStock = itemFrame:FindFirstChild("Frame") and itemFrame.Frame:FindFirstChild("Value")

            if not itemStock or not itemStock:IsA("NumberValue") then
                continue
            end

            local stock = tonumber(itemStock.Value) or 0
            stockTable[itemName] = { stock = stock }

            if is_firsttime then
                m_item_list[itemName] = true
                FSettings[itemsSettingKey] = m_item_list
            end
        end
        -- must run after the loop
        if is_firsttime then 
            FSettings[itemsSettingKey] = m_item_list
        end
        
        is_firsttime = false
    end

    while _G[loopRunningKey] do
        if FSettings[buySettingKey] == false then
            task.wait(1)
            continue
        end
        
       

        --print("Running " .. buySettingKey .. " buy")
        UpdateStock() -- can update to fill in the settings
        
        if shops_can_function == false then
            continue
        end

        for itemName, val in pairs(stockTable) do
            local stock = val.stock
            if stock <= 0 or FSettings[itemsSettingKey][itemName] == false then
                continue
            end
            for i = 1, stock do
                if buySettingKey == "buy_seedshop" then
                    fireEvent:FireServer("Tier 1",itemName)
                else
                    fireEvent:FireServer(itemName)
                end
                
            end
        end

        task.wait(10)
    end
end

-- Seed Shop
task.spawn(function()
    ShopPurchaseLoop(_S.SeedShopUI, "buy_seedshop", "seedshop_items", _S.BuySeedStock, "SeedShopLoopRunning")
end)

-- GearShop
task.spawn(function()
    ShopPurchaseLoop(_S.GearShopUI, "buy_gearshop", "gearshop_items", _S.BuyGearStock, "GearShopLoopRunning")
end)

-- EggShop
task.spawn(function()
    ShopPurchaseLoop(_S.PetShopUI, "buy_eggshop", "eggshop_items", _S.BuyPetEgg, "EggShopLoopRunning")
end)


-- TravelingMerchant
task.spawn(function()
    ShopPurchaseLoop(_S.TravelingMerchantShop_UI, "buy_merchant", "merchantshop_items", _S.BuyTravelingMerchantShopStock, "MerchantShopLoopRunning")
end)


--======= END Shops

local list_mutations = {}

local function GetKeyMutListUsingDir(ls)
    local _data = {}
    for key, value in pairs(ls) do
        table.insert(_data,key)
    end
    
    return _data
end

--=== Build mutations list safely
local function GetAllMutations() 
    local MutationHandler = require(game.ReplicatedStorage.Modules.MutationHandler)
    
    -- Get all mutations from the handler
    local allMutations = MutationHandler.GetMutations()

    -- Initialise whitelist and blacklist separately
    FOtherSettings.mutation_whitelist = {}
    FOtherSettings.mutation_blacklist = {}

    for mutationName, _ in pairs(allMutations) do
      
        FOtherSettings.mutation_whitelist[mutationName] = false
        FOtherSettings.mutation_blacklist[mutationName] = false
        list_mutations[mutationName] = false
    end
end

-- Apply them
GetAllMutations()
task.wait(0.3)


-- Saving and loading
local save_fname = "a_acssave_v15.json"
local save_fname_other = "a_acssave_v15_other.json"

-- Saving and loading
local function SaveData()
    local success, json = pcall(function()
        return _S.HttpService:JSONEncode(FSettings)
    end)

    if success then
        writefile(save_fname, json)
        print("✅ Data saved to " .. save_fname)
    else
        warn("❌ Error: Failed to encode settings to JSON. Data not saved.")
    end
end

local function SaveDataOther()
    local success, json = pcall(function()
        return _S.HttpService:JSONEncode(FOtherSettings)
    end)

    if success then
        writefile(save_fname_other, json)
        print("✅ Data saved to " .. save_fname_other)
    else
        warn("❌ Error: Failed to encode other settings to JSON. Data not saved.")
    end
end


local function LoadDataOther()
    print("loading saved data")
    if not isfile(save_fname_other) then
        print("⚠️ No save file found, using defaults")
        return
    end

    local json = readfile(save_fname_other)
    if not json or json == "" then
        print("⚠️ Save file is empty, using defaults")
        return
    end

    local success, decoded = pcall(_S.HttpService.JSONDecode, _S.HttpService, json)
    if not success then
        print("❌ Error decoding JSON from save file. It might be corrupted. Using defaults.")
        return
    end

    -- The deep merge logic is now inside this function
    local function merge(target, source)
        for key, sourceValue in pairs(source) do
            local targetValue = target[key]
            if type(sourceValue) == "table" and type(targetValue) == "table" then
                merge(targetValue, sourceValue) -- Recurse for nested tables
            else
                target[key] = sourceValue -- Overwrite non-table values
            end
        end
        return target
    end

    -- Merge the loaded data into the default settings
    merge(FOtherSettings, decoded)
    print("📂 Data loaded from " .. save_fname_other)
end

local function LoadData()
    print("loading saved data")
    if not isfile(save_fname) then
        print("⚠️ No save file found, using defaults")
        return
    end

    local json = readfile(save_fname)
    if not json or json == "" then
        print("⚠️ Save file is empty, using defaults")
        return
    end

    local success, decoded = pcall(_S.HttpService.JSONDecode, _S.HttpService, json)
    if not success then
        print("❌ Error decoding JSON from save file. It might be corrupted. Using defaults.")
        return
    end

    -- The deep merge logic is now inside this function
    local function merge(target, source)
        for key, sourceValue in pairs(source) do
            local targetValue = target[key]
            if type(sourceValue) == "table" and type(targetValue) == "table" then
                merge(targetValue, sourceValue) -- Recurse for nested tables
            else
                target[key] = sourceValue -- Overwrite non-table values
            end
        end
        return target
    end

    -- Merge the loaded data into the default settings
    merge(FSettings, decoded)
    print("📂 Data loaded from " .. save_fname)
end

-- Call LoadData() once at the start of your script
LoadData()
LoadDataOther();
task.wait(0.1);
-- Now your script can continue, and FSettings will be correctly populated.
print("Loading complete. Main script can proceed.")
shops_can_function = true -- shops can now function



-- If we are here for the first time
if FSettings.is_first_time then
    FSettings.is_first_time = false
    SaveData()
    SaveDataOther()
    task.wait(0.1)
    LoadData();
    LoadDataOther();
end




--  these are pets. its only used to detect if we found and rare pet.
local rare_pets = {
    ["Swan"] = true,
    ["T-Rex"] = true,
    ["Brontosaurus"] = true,
    ["Spinosaurus"] = true,
    ["Kitsune"] = true,
    ["Mimic Octopus"] = true,
    ["Red Fox"] = true,
    ["French Fry Ferret"] = true,
    ["Fennec Fox"] = true,
    ["Dragonfly"] = true,
    ["Raccoon"] = true,
    ["Queen Bee"] = true,
    ["Golden Goose"] = true,
    ["Butterfly"] = true,
    ["Disco Bee"] = true,
    ["Cockatrice"] = true,
    ["Ankylosaurus"] = true,
}


-- Build reverse lookup (pet → egg) after loading
local pet_to_egg = {}
for egg, pets in pairs(FSettings.sell_pets) do
    for pet, _ in pairs(pets) do
        pet_to_egg[pet] = egg
    end
end

-- Fast lookup when we pass in the pet name
local function getEggNameByPetName(petName)
    return pet_to_egg[petName] or "Unknown Egg"
end

 
-- these can be in settings and some on stats screen, main page, they are also sent in webhooks
local newlyHatchedNames = {};
local canSendReport = false;
local got_eggs_back = 0;
local recovered_eggs = 0;
local passive_pet_bonus = 0
local pet_size_bonus = 0

local is_loadout_ready = false; -- not used, but keep
local is_pet_inventory_full = false
local is_plants_folder_removed = false


local was_backpack_updated = false;

-- Find your farm, do not change this, its tested and reliable
local function findMyFarm()
    for _,farm in ipairs(_S.Workspace:WaitForChild("Farm"):GetChildren()) do
        local owner = farm:FindFirstChild("Important")
                      and farm.Important:FindFirstChild("Data")
                      and farm.Important.Data:FindFirstChild("Owner")
        if owner and owner:IsA("StringValue") and owner.Value == _S.LocalPlayer.Name then
            return farm
        end
    end
    warn("Farm not found for " .. _S.LocalPlayer.Name)
    return nil
end

local mFarm = findMyFarm();
if not mFarm then
    warn("Farm not found")
    return
end
--workspace.Farm.Farm.Important.Objects_Physical
local important = mFarm:FindFirstChild("Important")
local mObjects_Physical = important and important:FindFirstChild("Objects_Physical")
 


local Plants_Physical = mFarm:FindFirstChild("Important"):WaitForChild("Plants_Physical")
if not Plants_Physical then return warn("Could not start script: Plants_Physical folder not found.") end

task.wait(0.3)
if not mObjects_Physical then
    warn("Not found mObjects_Physical")
    return
end



local UPDATE_LABELS_FUNC = {
    -- updates the main hatching stats
    UpdateSetLblStats = function (_txt)
        if UI_LABELS.lbl_stats then
            UI_LABELS.lbl_stats:SetText(_txt)
        end
    end
}
 

local function unequipTools()
    local humanoid = _S.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    humanoid:UnequipTools()
    task.wait(0.2)
end


-- Pet info
local function GetPetDataByUUID(uuid)
    local _petData = _S.PetUtilities:GetPetByUUID(_S.LocalPlayer, uuid)
    if not _petData then
        print("pet not found")
        return nil
    end
    
    local UUID = _petData.UUID
    local PetData = _petData.PetData 
    
    local HatchedFrom = PetData.HatchedFrom -- "Fake Egg"
    local IsFavorite = PetData.IsFavorite
    local Boosts = PetData.Boosts
    local Name = PetData.Name
    local LevelProgress = PetData.LevelProgress
    local EggName = PetData.EggName
    local Level = PetData.Level
    local Hunger = PetData.Hunger
    local BaseWeight = PetData.BaseWeight
    
    local PetType = _petData.PetType
    local PetAbility = _petData.PetAbility

    return _petData;
end 


-- ================ EGG SYSTEM

_G.EggDataStreamListener = _S.DataStream.OnClientEvent:Connect(function(action, profileName, data)
    if action ~= "UpdateData" or not profileName then return end
     
    local eggsData = {}

    for _, entry in ipairs(data) do
        local key = entry[1]
        local value = entry[2] 

        -- Extract UUID
        local uuid = key:match("SavedObjects/({.-})")
        if uuid then
            -- Initialise if first time
            eggsData[uuid] = eggsData[uuid] or {} 
            
            if key:find("/Data/Type") and value ~= nil then
                eggsData[uuid].Type = value
            elseif key:find("/Data/BaseWeight") and value ~= nil then
                eggsData[uuid].BaseWeight = value
            elseif key:find("/Data/CanHatch") and value ~= nil then
                eggsData[uuid].CanHatch = value
            end

        end
    end

    -- Print collected eggs
    for uuid, info in pairs(eggsData) do
        if not info.CanHatch then
            --warn("egg not ready " .. uuid)
            continue
        end
        -- add to found pets
        local p_w = GetRealPetWeight(info.BaseWeight);
        found_pet_data[uuid] = {petname= info.Type, weight = p_w }
        -- print(string.format(
        --     "UUID: %s | Type: %s | BaseWeight: %.2f | CanHatch: %s",
        --     uuid,
        --     tostring(info.Type or "N/A"),
        --     tonumber(info.BaseWeight) or 0,
        --     tostring(info.CanHatch)
        -- ))
    end
end)







local function GetAllReadyEggsModels()
    local ready_to_hatch_eggs = {}
    local eggs_on_farm_array = mObjects_Physical:GetChildren();

    for _, obj in ipairs(eggs_on_farm_array) do
        -- Check if the object is a valid, ready-to-hatch egg model
        if obj:IsA("Model") and obj:GetAttribute("TimeToHatch") == 0 and obj.Name == "PetEgg" then
            --obj:GetAttribute("EggName")
            table.insert(ready_to_hatch_eggs, obj)
        end
    end
    
    return ready_to_hatch_eggs;
end

local function GetEggUuids()
    local array_egg_models = GetAllReadyEggsModels()
    if not array_egg_models then
        return nil
    end
    
    local e_uuids = {}
    
    for _, obj in ipairs(array_egg_models) do
        -- Check if the object is a valid, ready-to-hatch egg model
        if obj:IsA("Model") and obj:GetAttribute("TimeToHatch") == 0 and obj.Name == "PetEgg" then
            -- obj:GetAttribute("EggName")
            local uuid = obj:GetAttribute("OBJECT_UUID")
            table.insert(e_uuids, uuid)
        end
    end
    
    if #e_uuids == 0 then
        return nil
    end
    
    return e_uuids
end






local function addOrUpdateEggUI(eggModel)
    if not eggModel or not eggModel:IsA("Model") then return end
    
    local uuid = eggModel:GetAttribute("OBJECT_UUID")
    if not uuid then return end
    local petinfo = found_pet_data[uuid]
     if not petinfo or not uuid then
        --warn("dont have pet ui info for this.")
        return
     end

    local maxDistance = 99

    -- Find existing BillboardGui
    local billboard = eggModel:FindFirstChild("EggBillboardGui")
    
    if FSettings.is_egg_esp == false then
        if billboard then
            billboard:Destroy()
            billboard = nil
            return
        end
        return
    end
    
    -- if billboard then
    --     billboard:Destroy();
    --     billboard = nil
    -- end
   
    if not billboard then
        -- Create new BillboardGui
        billboard = Instance.new("BillboardGui")
        billboard.Name = "EggBillboardGui"
        billboard.Adornee = eggModel:FindFirstChild("HitBox") or eggModel.PrimaryPart
        billboard.Size = UDim2.new(0, 150, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = maxDistance -- <-- added max view distance
        billboard.Parent = eggModel

        -- Create TextLabel
        local label = Instance.new("TextLabel")
        label.Name = "EggLabel"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.RichText = true
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.SourceSansBold
        label.TextScaled = false
        label.TextSize = 19 
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)  -- black outline
       
        label.Parent = billboard 
    else
        -- Update max distance if needed
        billboard.MaxDistance = maxDistance
    end

    -- Update the label text
    local label = billboard:FindFirstChild("EggLabel")
    if label then
        local eggName = ""
        local weight = "" 
        if petinfo then
            eggName = petinfo.petname
            weight = petinfo.weight
        end
        label.RichText = true
        label.Text = string.format(
            " <font color='#FFFF64'>%s</font> <font color='#FF00FF'>•</font> <font color='#00FFFF'>%.2fKG</font>",
            eggName, weight
        )
    end
end

local function updateEggEspUi() 

    while _G.EggEspUiRunning do
        task.wait(1);
        local readyEggs = GetAllReadyEggsModels()
        for _, egg in ipairs(readyEggs) do
            addOrUpdateEggUI(egg)
        end
    end

   
end

local function ScanPetEggInsideData()
    local uuidArray = GetEggUuids()
    if not uuidArray or #uuidArray == 0 then
        print("No ready-to-hatch eggs found.")
        return {}
    end

    -- turn into a dictionary for fast lookup
    local uuidsToFind = {}
    for _, u in ipairs(uuidArray) do
        uuidsToFind[u] = true
    end
     
 
    local gc = getgc(true)
    print("Scanning " .. #gc .. " GC objects...")

    for i = #gc, math.floor(#gc * 0.3), -1 do
        if not next(uuidsToFind) then break end
        local obj = gc[i]
        if typeof(obj) == "table" then
            for uuid in pairs(uuidsToFind) do
                for key, value in pairs(obj) do
                    if typeof(key) == "string" and key:find(uuid, 1, true) then
                        if typeof(value) == "table" and value.Data and value.Data.Type and value.Data.BaseWeight then
                            local p_w = GetRealPetWeight(value.Data.BaseWeight)
                            found_pet_data[uuid] = {petname= value.Data.Type, weight = p_w }
                            uuidsToFind[uuid] = nil
                            --print("Found data for UUID:", uuid, "Type:", value.Data.Type, "Weight:", value.Data.BaseWeight)
                            break
                        end
                    end
                end
            end
        end
    end 
end
 
-- run the scan
ScanPetEggInsideData() 
--print("GC scan complete. Found:", _S.HttpService:JSONEncode(found_pet_data))
task.spawn(updateEggEspUi)


--======= EGG SYSTEM













---------------------------------------------------
-----------======== Players status
---------------------------------------------------

 
 
local statsGui
local statLabels 
-- Internal loop to handle UI visibility and updates
if not _G.task_player_stats then
    _G.task_player_stats = task.spawn(function() 
        while true do
            task.wait(0.5) -- check interval
              
            -- Show UI if flag is true and UI doesn't exist
            if FOtherSettings.is_playerstats_running then
                 
                if not statsGui or not statsGui.Parent then
                    statLabels = {}
    
                    statsGui = Instance.new("ScreenGui")
                    statsGui.Name = "SecretStatsGui"
                    statsGui.ResetOnSpawn = false
    
                    local mainFrame = Instance.new("Frame", statsGui)
                    mainFrame.Name = "MainFrame"
                    mainFrame.AnchorPoint = Vector2.new(0, 0.5)
                    mainFrame.Position = UDim2.new(0, 15, 0.3, 0)
                    mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
                    mainFrame.BackgroundTransparency = 1
                    mainFrame.BorderSizePixel = 0
                    mainFrame.AutomaticSize = Enum.AutomaticSize.Y
    
                    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
                    local padding = Instance.new("UIPadding", mainFrame)
                    padding.PaddingLeft = UDim.new(0, 10)
                    padding.PaddingRight = UDim.new(0, 10)
                    padding.PaddingTop = UDim.new(0, 10)
                    padding.PaddingBottom = UDim.new(0, 10)
    
                    local listLayout = Instance.new("UIListLayout", mainFrame)
                    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    listLayout.Padding = UDim.new(0, 4)
    
                    -- Create labels
                    for key, val in pairs(PlayerSecrets) do
                        local textLabel = Instance.new("TextLabel", mainFrame)
                        textLabel.Name = key
                        textLabel.Text = key .. ": 0"
                        textLabel.Font = Enum.Font.SourceSans
                        textLabel.TextSize = 17
                        textLabel.TextColor3 = Color3.new(1, 1, 1)
                        textLabel.TextXAlignment = Enum.TextXAlignment.Left
                        textLabel.BackgroundTransparency = 1
                        textLabel.Size = UDim2.new(1, 0, 0, 18)
                        textLabel.RichText = true
    
                        local textOutline = Instance.new("UIStroke", textLabel)
                        textOutline.Color = Color3.new(0, 0, 0)
                        textOutline.Thickness = 1
    
                        statLabels[key] = textLabel
                    end
    
                    statsGui.Parent = _S.PlayerGui
                end
    
                -- Update all labels
                if statLabels then
                    for key, label in pairs(statLabels) do
                        local value = _S.LocalPlayer:GetAttribute(key) or 0
                        local formattedValue = typeof(value) == "number" and string.format("%.2f", value) or tostring(value)
                        if formattedValue == "0.00" then
                            label.Text = key .. ": " .. formattedValue 
                        else
                            label.Text = key .. ": <b><font color='#FF7800'>" .. formattedValue .. "</font></b>"
                        end
                         
                    end
                end
    
            -- Hide UI if flag is false
            else
                if statsGui and statsGui.Parent then
                    statsGui:Destroy()
                    statsGui = nil
                    statLabels = nil
                    print("💫 destoryed")
                end
            end
        end
    end)
else
    warn("Already set player stats")
end


--------------------------------------------------- END Player stats



















--============ LIMIED Fairy EVENT

local function scanFairies()
    
    local scan_amount = 0
    local fairy_found_count = 0
    local total_spams = 0
    
    local function spProxi(prompt)
        fireproximityprompt(prompt)
    end
    
    while true  do
        task.wait(3) 
        if FSettings.is_fairy_scanner_active == false then
            continue
        end
        scan_amount = scan_amount + 1
        if not UI_LABELS.lbl_fariystats then
            print("null UI lbl_stats")
            continue
        end
        
        --print("🔍 Fairy scanning " .. scan_amount)
        UI_LABELS.lbl_fariystats:SetText("🔍 Fairy scanning " .. scan_amount)
 
        for i = 1, 15 do
            local slot = workspace:FindFirstChild(tostring(i))
            if slot and slot:FindFirstChild("ProximityPrompt") then
                local prompt = slot.ProximityPrompt
                fairy_found_count = fairy_found_count + 1
                print("✨ Fairy found in slot " .. i .. " (Total found: " .. fairy_found_count .. ")")
                task.wait(1)

                -- spam until gone
                local fspam = 0
                while prompt and prompt.Parent do
                    fspam = fspam + 1
                    total_spams = total_spams + 1

                    fireproximityprompt(prompt)
                    -- fire 5 times
                    -- for j = 1, 2 do
                    --     task.spawn(function()
                    --         spProxi(prompt)
                    --     end)
                    -- end

                    if fspam % 20 == 0 then
                        local infox ="⚡ Spamming fairy (" .. fspam .. " times for this fairy, " .. total_spams .. " total)"
                        UI_LABELS.lbl_fariystats:SetText(infox)
                    end
                    
                    task.wait(0.5)
                end
                scan_amount = 0
                --print("❌ Fairy disappeared after")
                UI_LABELS.lbl_fariystats:SetText("❌ Fairy disappeared after")
            end
        end
    end 
end

-- Start scanning
task.spawn(scanFairies)
-- END farity



local function extractFirstNumber(str)
    local num = str:match("%d+")
    return tonumber(num) or 0
end

-- this returns how many eggs user has unlocked and can play
local function GetMaxEggCapacity()
    -- Safely find the UI element by checking each part of the path
    local amountLabel = _S.Players.LocalPlayer.PlayerGui.Shop_UI.Frame.ScrollingFrame.PetProducts.List.EggSlot.Amount
    local max_eggs = 3 -- user starts with 3

    if amountLabel then
        local fullText = amountLabel.Text -- Example: "3/5 Extra"

        -- The pattern "^(%d+)" captures the number at the very beginning of the string.
        local currentAmountString = string.match(fullText, "^(%d+)")

        if currentAmountString then
            local nn =  tonumber(currentAmountString) -- Returns 3
            max_eggs = max_eggs + nn
        else
            warn("Could not find the current egg amount in text: " .. fullText)
        end

        
    else
        warn("Could not find the egg amount UI label.") 
    end
    
    return max_eggs + 5
end



local function GetMaxPetCapacity()
    -- Get the UI element that displays the pet count
    local titleLabel = _S.Players.LocalPlayer.PlayerGui.ActivePetUI.Frame.Main.Holder.Header.Title
    if not titleLabel then
        return 8
    end
    -- Get the text from the label (example "Active Pets: 0/8")
    local fullText = titleLabel.Text 
    local maxPetsString = string.match(fullText, "/(%d+)")
    -- If a match was found, convert the captured string to a number and return it
    if maxPetsString then
        return tonumber(maxPetsString)
    end
    -- If no match was found, print a warning and return nil
    warn("Could not find the maximum pet count in the text: " .. fullText)
    return 8 -- default
end
 

-- do not change, very stable
local function extractPetDetails(petString)
    -- Try to match name, weight, and age 
    local name, weight, age = string.match(petString, "^(.-)%s+%[(%d+%.?%d*)%s*KG%]%s+%[Age%s*(%d+)%]$")
    if name then
        return name, tonumber(weight), tonumber(age)
    end

    -- Try to match name and weight only
    name, weight = string.match(petString, "^(.-)%s+%[(%d+%.?%d*)%s*KG%]$")
    if name then
        return name, tonumber(weight), 1 -- default age to 1
    end

    -- Invalid format
    return nil
end


-- needs a boolean so we can toggle this on or off
-- Deletes Plants_Physical
local function DeleteAllPlantsFolder()

    if not FSettings.auto_remove_plants_folder then
        print("❌ Plant deletion is disabled.")
       return
    end
    
    --  This function deletes this folder> workspace.Farm.Farm.Important.Plants_Physical
    print("Searching for Plants_Physical to remove...")
    
    -- Safely check for Farm
    local farmFolder = _S.Workspace:FindFirstChild("Farm")
    if not farmFolder then
        warn("Farm folder not found in workspace.")
        return
    end 
    
    for _,farm in ipairs(farmFolder:GetChildren()) do
        -- find Plants_Physical
        if farm then
            local important = farm:FindFirstChild("Important")
            if important and important:IsA("Folder") then
                local plants = important:FindFirstChild("Plants_Physical")
                if plants then
                    local ok, err = pcall(function()
                        plants:Destroy()
                    end)
                    if ok then
                        print("✅ Plants_Physical removed from " .. farm.Name)
                    else
                        warn("❌ Failed to destroy Plants_Physical in " .. farm.Name .. ": " .. tostring(err))
                    end
                else
                    -- Optional: print("No Plants_Physical in " .. farm.Name)
                end
            end
        end
       
    end

    print("Plants_Physical cleanup complete.") 
end


-- These are used to check what new pets we hatched. do not touch. it works
-- Store PET_UUID for fast lookup
local trackedPets = {}

-- Populate trackedPets initially with pets
for _, item in ipairs(_S.Backpack:GetChildren()) do
    if item:IsA("Tool") and item:GetAttribute("ItemType") == "Pet" then
        local petUUID = item:GetAttribute("PET_UUID")
        if petUUID then
            trackedPets[petUUID] = true
        end
    end
end

-- do not touch, leave as is
local function watchBackPack()
    local function onChildAdded(item)
        if item:IsA("Tool") and item:GetAttribute("ItemType") == "Pet" then
            was_backpack_updated = true;
            local petUUID = item:GetAttribute("PET_UUID")
            local petName, petWeight, petAge = extractPetDetails(item.Name)
            local isFav = item:GetAttribute("d")

            if petUUID and not trackedPets[petUUID] then
                if not isFav and petName and petAge == 1 then
                    trackedPets[petUUID] = true
                    table.insert(newlyHatchedNames,item.Name);
                    --print("✅ New hatch!:", item.Name, "UUID:", petUUID)
                end
            end
        end
    end

    _S.Backpack.ChildAdded:Connect(onChildAdded)
end
 

-- watch backpack
watchBackPack()


-- Detect these, we detect these and use them
local ev_backpack_full = "max backpack space"
local ev_loaded_pets = "loaded pets"
local ev_max_eggs_reached = "max pet eggs"
local ev_lucky_sell = "from selling your pet" --  when seal gives egg back
local ev_hatch_lucky = "egg has been recovered" -- when koi repaints
local ev_pet_inventoryfull ="you have reached the limit of pets"
local ev_max_garden_seeds = "Your garden is full"
 

-- All words must exist, the order doesn't matter
local function strongContains(message, keywordText)
    if not message or not keywordText then
        print("message or keywordText are nil")
        return false
    end
    local msg = string.lower(message)
    for word in string.gmatch(keywordText, "%S+") do
        if not string.find(msg, word, 1, true) then
            return false
        end
    end
    return true
end


local function GetServerVersion()
    -- Use pcall to prevent errors if the UI element doesn't exist or hasn't loaded yet
    local success, versionLabel = pcall(function()
        return _S.LocalPlayer.PlayerGui.Version_UI.Version
    end)

    if success and versionLabel then
        -- The UI element was found, so we return its Text property
        return versionLabel.Text
    else
        -- The UI element was not found, so we return a default string
        warn("Could not find the server version UI element.")
        return "Unknown"
    end
end

local function HandleNotificationX(arg)
    -- This listens to any Notifications
    
    if strongContains(arg, ev_max_garden_seeds) then
        -- -- max seeds limit
        warn("Notification"..tostring(arg));
        is_garden_full_seed = true; 
    end
    
    if strongContains(arg, ev_max_eggs_reached) then
        -- max eggs on farm
        warn("Notification"..tostring(arg));
        is_max_eggs_reached = true; 
    end

    if strongContains(arg,ev_lucky_sell) then 
        -- egg back, seal egg back
        warn("Notification"..tostring(arg));
        got_eggs_back = got_eggs_back + 1
    end

     if strongContains(arg,ev_hatch_lucky) then 
        -- egg recovered , koi repaint
        warn("Notification"..tostring(arg));
        recovered_eggs = recovered_eggs + 1
    end

    if strongContains(arg, ev_backpack_full) then
        --  backpack is full
        backpack_full = true
        warn("Notification"..tostring(arg));
    end

    -- Loaded pets
    if strongContains(arg, ev_loaded_pets) then 
        -- Handle loaded pets here
        -- load out pets load complete
        warn("Notification"..tostring(arg));
        is_loadout_ready = true
    end
    
     -- pet inventory full
    if strongContains(arg, ev_pet_inventoryfull) then 
        -- if pet inventory is full
        warn("Notification"..tostring(arg));
        is_pet_inventory_full = true
    end
    
    
    
end

local function watchNotificationEvents()
    print("started watch: Notification");
    -- Hook Notification remote
    local rs = game:GetService("ReplicatedStorage")
    local notificationRemote = rs:WaitForChild("GameEvents"):WaitForChild("Notification")
    
    notificationRemote.OnClientEvent:Connect(function(...)
        for _, arg in ipairs({...}) do
            if type(arg) == "string" then 
               HandleNotificationX(arg);
            end
        end
    end)
end

watchNotificationEvents();
 


-- Utility: send embed -  dont touch this code
local function sendWebhook(title, description, colour,db_data)
    if not FSettings.webhook_url or FSettings.webhook_url == ""  then 
        warn("Webhook not configured.")
        return 
    end
    
    local db_datax = {}
    
    if db_data then
        db_datax = db_data
    end
    
    local payload = {
        webhook_url = FSettings.webhook_url,
        content = content or "", -- where @everyone would go
        embed = { title=title, description=description, color=colour or 0x00AFFF,
                  footer={text="ExoticHub Report"},
                  timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ") },
        db = db_datax,
    }
     
    
    pcall(function()
        local body = _S.HttpService:JSONEncode(payload)
        local req  = (syn and syn.request) or request
        if req then
            req({Url=_S.PROXY_URL,Method="POST",
                 Headers={["Content-Type"]="application/json"},
                 Body=body})
        else
            _S.HttpService:PostAsync(_S.PROXY_URL, body)
        end
    end)
end










local petCache = {}


local function extractUUIDFromString(nameString) 
    local uuid = string.match(nameString, "{(.-)}");
    return "{" .. uuid .. "}"
end


local function GetPetsCacheAsTable()
    local mpets = {}
    for uuid,petname in pairs(petCache) do
        table.insert(mpets,petname)
    end
    table.sort(mpets)
    return mpets
end

 

local function ConvertUUIDToPetNamesPairs(uuid_array)
    local pet_names = {}

    if not uuid_array then
        return pet_names
    end

    -- Loop through each UUID you want to convert
    for _, uuid in ipairs(uuid_array) do
        -- Find the full pet name associated with that UUID in the cache
        local foundName = petCache[uuid]

        if foundName then
            -- If the pet still exists, add its name to our list 
            pet_names[foundName] = true;
        end
    end
     

    return pet_names -- Return the final list of names
end



-- This single function reloads all pet data and updates the UI dropdowns.
local function UpdatePetData()
    print("🔄 Refreshing pet data...")
    is_value_selection_update = true
     -- Get all active pets 
    local contiems = _S.petsContainer:GetChildren()
    for _, pet in ipairs(contiems) do
        if pet and pet:GetAttribute("OWNER") == _S.LocalPlayer.Name then
            local uuidx = pet:GetAttribute("UUID")
            if uuidx then
                local pet_data = GetPetDataByUUID(uuidx)
                if pet_data then 
                    local _lvl = pet_data.PetData.Level 
                    local basekg = pet_data.PetData.BaseWeight
                    local _currentkg = GetRealPetWeight(basekg,_lvl)
                    local DisplayWeight = tonumber(string.format("%.2f", _currentkg))
                    local pname = pet_data.PetType
                    local _petname = pname .. "[" .. DisplayWeight .. " KG] [Age " .. _lvl .. "]"
                    petCache[uuidx] = _petname .. " " .. uuidx
                else
                    petCache[uuidx] = "Active PET " ..uuidx
                end
                
            end
        end
    end
    
    -- Scan the backpack and populate the new cache.
    local b_ar = _S.Backpack:GetChildren()
    for _, item in ipairs(b_ar) do
        if item:IsA("Tool") and item:GetAttribute("ItemType") == "Pet" then
            local uuid = item:GetAttribute("PET_UUID")
            if uuid then
                petCache[uuid] = "" .. item.Name .. " " .. uuid
            end
        end
    end

    if UI_LABELS.MultiDropdownHatchTeam and UI_LABELS.MultiDropdownSellTeam and UI_LABELS.MultiDropdownEggReductionTeam and UI_LABELS.MultiDropdownEggPetSizeTeam then
        local team1data = ConvertUUIDToPetNamesPairs(FSettings.team1)
        local team2data = ConvertUUIDToPetNamesPairs(FSettings.team2)
        local team3data = ConvertUUIDToPetNamesPairs(FSettings.team3)
        local team4data = ConvertUUIDToPetNamesPairs(FSettings.team4)
        
        is_value_selection_update = true
        UI_LABELS.MultiDropdownSellTeam:SetValues(GetPetsCacheAsTable());
        UI_LABELS.MultiDropdownSellTeam:SetValue(team1data)
         
        is_value_selection_update = true
        UI_LABELS.MultiDropdownHatchTeam:SetValues(GetPetsCacheAsTable());
        UI_LABELS.MultiDropdownHatchTeam:SetValue(team2data)
        
        is_value_selection_update = true
        UI_LABELS.MultiDropdownEggReductionTeam:SetValues(GetPetsCacheAsTable());
        UI_LABELS.MultiDropdownEggReductionTeam:SetValue(team3data)
        
        is_value_selection_update = true
        UI_LABELS.MultiDropdownEggPetSizeTeam:SetValues(GetPetsCacheAsTable());
        UI_LABELS.MultiDropdownEggPetSizeTeam:SetValue(team4data)
    end
     
end


UpdatePetData()
 


-- Get egg count, count passed in egg name
local function GetEggCount(eggName)
    if not eggName then return 0 end
    local egg_ar = _S.Backpack:GetChildren();
    for _, item in ipairs(egg_ar) do
        if item:IsA("Tool") and item:GetAttribute("h") == eggName then
            local uses = item:GetAttribute("e") or 0
            return uses
        end
    end
    
    -- check if the user is holding the egg
    
    -- check if the user is holding the egg
    for _, item in ipairs(_S.Character:GetChildren()) do
        if item:IsA("Tool") and item:GetAttribute("h") == eggName then
            local uses = item:GetAttribute("e") or 0
            return uses
        end
    end
    
    return 0
end



-- This will be called before to fill up egg counts
local function BeforeUpdateEggCountForAllEggs()
    for eggName, data in pairs(egg_counts) do
        local current_countx = GetEggCount(eggName)
        data.current_amount = current_countx
    end
end

-- this called last to detect how many eggs we lost of gain
local function AfterUpdateEggCountForAllEggs()
    for eggName, data in pairs(egg_counts) do
        local current_countx = GetEggCount(eggName)
        data.new_amount = current_countx
    end
end

-- call it right away
BeforeUpdateEggCountForAllEggs()


-- This checks if there are any eggs to be hatched
-- This checks if there are any eggs to be hatched (Corrected Logic)
local function CheckAnyEggsToHatch()
    warn("Starting to check if any eggs to hatch")

    if not mObjects_Physical then
        warn("issue finding Objects_Physical")
        UPDATE_LABELS_FUNC.UpdateSetLblStats("CheckAnyEggsToHatch: not found Objects_Physical")
        task.wait(1)
        return false
    end

    local eggs_on_farm_array = mObjects_Physical:GetChildren()
    if #eggs_on_farm_array == 0 then
        warn("No eggs found on farm")
        UPDATE_LABELS_FUNC.UpdateSetLblStats("CheckAnyEggsToHatch: No eggs found on farm")
        task.wait(1)
        return true -- Returning true signals that we need to place more eggs
    end

    if FSettings.is_hatch_in_batch == true then 
        for _, obj in ipairs(eggs_on_farm_array) do
            if obj.Name == "PetEgg" and obj:IsA("Model") then
                if obj:GetAttribute("TimeToHatch") > 0 then
                    return false -- Found an egg on cooldown. Stop and report we can't hatch.
                end
            end
        end
        -- If the loop completes, it means no eggs were on cooldown.
        return true -- All eggs are ready, we can hatch the batch.

    else 
        for _, obj in ipairs(eggs_on_farm_array) do
            if obj.Name == "PetEgg" and obj:IsA("Model") then
                if obj:GetAttribute("TimeToHatch") == 0 then
                    return true -- Found a ready egg. Stop and report we can hatch.
                end
            end
        end
        -- If the loop completes, it means no ready eggs were found.
        return false -- No eggs are ready to hatch individually.
    end
end

-- sends webhook report
local function HatchReport()
    local newPetNames = newlyHatchedNames
    if #newPetNames == 0 then return end

    local _hatchbuff = string.format("%.2f", tracked_bonus_egg_recovery or 0)
    local _sellbuff = string.format("%.2f", tracked_bonus_egg_sell_refund or 0)
    local _petsizebuff_display = string.format("%.2f", pet_size_bonus or 0)
    local serverv = GetServerVersion()
    local hatch_player_uname = _S.LocalPlayer.Name
    local hatchedCount = #newPetNames
    
    -- Add the list of all hatched pets
    -- db pet list
    local hatchPetls = {} -- this used for storing data in db
     
    -- New grouping table (separate from hatchPetls)
    local groupedEggs = {}
     
    local eggsUsed = 0 -- how many eggs we used?
    local eggsSaved = 0 -- how many eggs we saved
    for _, fullName in ipairs(newPetNames) do
        -- table.insert(descriptionLines, string.format("> `%s`", fullName))
        
        local petName, petWeight, petAge = extractPetDetails(fullName)
        local peteggname = getEggNameByPetName(petName)
        local current_eggs , remain_eggs = getEggAmounts(peteggname)
        
        local pet_item = {
            egg_name = peteggname, 
            petname = petName,
            petage= petAge,
            weight = petWeight,
            old_egg_count = current_eggs,
            new_egg_count = remain_eggs, 
        }
        
        table.insert(hatchPetls,pet_item);
        
        
         -- build new grouped table
        if not groupedEggs[peteggname] then
            groupedEggs[peteggname] = {
                start = current_eggs,
                finish = remain_eggs,
                pets = {}
            }
        end
        
        table.insert(groupedEggs[peteggname].pets, fullName)
        -- group ends 
    end
    
    -- After building groupedEggs
    for _, info in pairs(groupedEggs) do
        eggsUsed = eggsUsed + (info.start - info.finish)
    end 
    -- Eggs saved is total hatched minus eggs used
     eggsSaved = hatchedCount - eggsUsed
     
    -- Main Report Construction  
    local descriptionLines = {}
    
    table.insert(descriptionLines, "**-> Session Info:**")
    table.insert(descriptionLines, string.format("│ 👤 Username: ||`%s`||", hatch_player_uname))
    table.insert(descriptionLines, string.format("│ 🖥️ Server Version: `%s`", serverv))
    table.insert(descriptionLines, "") -- Blank line for spacing
    
    table.insert(descriptionLines, "**-> Stats:**")
   
    if pet_size_bonus <= 0 then
        table.insert(descriptionLines, string.format("│ ✨ **Buffs** Sell: `%s%%` Hatch: `%s%%`", _sellbuff, _hatchbuff))
    else
        table.insert(descriptionLines, string.format("│ ✨ **Buffs** Sell: `%s%%` Hatch: `%s%%` PetSize: `%s%%`", _sellbuff, _hatchbuff,_petsizebuff_display))
    end
    table.insert(descriptionLines, string.format("│ ❤️ Fav: `%d` 🎉 Hatched: `%d`", pets_fav_count or 0, hatchedCount or 0))
    table.insert(descriptionLines, string.format("│ 🥚 Eggs Used: `%d`", eggsUsed or 0))
    table.insert(descriptionLines, string.format("│ 💾 Eggs Saved: `%d`", eggsSaved or 0)) 
  
    -- Conditionally add the "Lucky Events" section if they occurred
    if true then
        table.insert(descriptionLines, "")
        table.insert(descriptionLines, "**-> Lucky Events! 🍀**")
        table.insert(descriptionLines, string.format("│ 🥚 Lucky Pet: `+%d Eggs`", got_eggs_back))
        table.insert(descriptionLines, string.format("│ 🔄 Lucky Hatch: `+%d Eggs`", recovered_eggs))
    end

    
    
    table.insert(descriptionLines, "")
    table.insert(descriptionLines, string.format("**-> Pets Hatched (%d):**", hatchedCount))
    
    -- ✅ Now make UI for groups only (not every pet individually)
    for eggName, info in pairs(groupedEggs) do
        -- first line for the egg
        table.insert(descriptionLines,
            string.format("🐣**%s (St %d, End %d)**", eggName, info.start, info.finish)
        )
    
        -- sub-lines for each pet hatched from this egg
        for _, petFullName in ipairs(info.pets) do
            table.insert(descriptionLines, string.format("> `%s`", petFullName))
        end
        table.insert(descriptionLines, "")
    end
        
     
    -- Send the main report
    local finalDescription = table.concat(descriptionLines, "\n")

    --make data for storage
    local db_data = {
        pets_hatched = hatchPetls,
        serverversion = serverv,
        username = hatch_player_uname,
        userid = player_userid,
        cp_api = FOtherSettings.web_api_key,
        buff_seal = _sellbuff,
        buff_koi = _hatchbuff,
        buff_bron = pet_size_bonus,
        PetPassiveBonus = passive_pet_bonus,
        bonus_egg_back = got_eggs_back, -- seals
        bonus_recovery = recovered_eggs, -- koi
    }
    
    
    if FSettings.send_everyhatch_alert then
        sendWebhook("Hatch Report", finalDescription, 3447003, db_data) -- Blue color
    end
   

    
    -- Separate Alerts for Special Pets
    local rareLines, bigLines = {}, {}
    for _, fullName in ipairs(newPetNames) do
        local petName, petWeight = extractPetDetails(fullName)
        if petName and petWeight then
            if rare_pets[petName] then
                table.insert(rareLines, string.format("`%s` — `%.2f kg`", petName, petWeight))
            elseif petWeight >= tonumber(FSettings.sell_weight) then
                table.insert(bigLines, string.format("`%s` — `%.2f kg`", petName, petWeight))
            end
        end
    end

    -- Send Rare Pet Alert if any were found
    if #rareLines > 0 then
        local rareMsg = {
            "**-> Hatched By:**",
            string.format("│ Username: ||`%s`||", _S.LocalPlayer.Name),
            "",
            string.format("**-> Rare Pets (%d):**", #rareLines),
            table.concat(rareLines, "\n")
        }
        if FSettings.send_rare_pet_alert then
            sendWebhook("🎯 Rare Pet Alert", table.concat(rareMsg, "\n"), 16766720) -- Gold
        end
    end
    
    -- Send Big Pet Alert if any were found
    if #bigLines > 0 then
        local bigMsg = {
            "**-> Hatched By:**",
            string.format("│ Username: ||`%s`||", _S.LocalPlayer.Name),
            "",
            string.format("**-> Big Pets (%d):**", #bigLines),
            table.concat(bigLines, "\n")
        }
        if FSettings.send_big_pet_alert then
            sendWebhook("💪 Big Pet Alert", table.concat(bigMsg, "\n"), 15105570) -- Red
        end
    end

    task.wait(0.3)
end

 

local function SendInfoNoEggs()
    local bigMsg = {
        "❌ **Out of Eggs!** ❌",
        "",
        string.format("│ Username: ||`%s`||", _S.LocalPlayer.Name),
        "",
        "❌ **You have no eggs left.**",
        "",
        "────────────────────────────"
    }
    sendWebhook("❌ No Eggs Alert", table.concat(bigMsg, "\n"), 15105570) -- Red colour
end

local function SendInfoFailedTeamPlace()
    local bigMsg = {
        "❌ **Failed to place a team!** ❌",
        "",
        string.format("│ Username: ||`%s`||", _S.LocalPlayer.Name),
        "",
        "❌ **Team failed to be place.**",
        "",
        "────────────────────────────"
    }
    sendWebhook("❌ Team Placement Alert", table.concat(bigMsg, "\n"), 15105570) -- Red colour
end

local function SendErrorMessage(errorMsg)
    errorMsg = errorMsg or "Some Error"

    local bigMsg = {
        "❌ Error ❌",
        "",
        string.format("│ Username: ||`%s`||", _S.LocalPlayer.Name),
        "",
        "❌ " .. errorMsg,
        "",
        "────────────────────────────"
    }

    if sendWebhook then
        sendWebhook("❌ " .. errorMsg, table.concat(bigMsg, "\n"), 15105570) -- Red colour
    else
        warn("webhook not found..")
    end
end



-- These two functions are the same, they just format the webhook
local function send_10min_report()
    local descriptionLines = {
        "**📊 10-Minute Stats Update**", "",
        string.format("│ 🐣 Hatched in this 10-min block: `%d`", FSettings.eggs_hatched_in_10_min_session),
        string.format("│ 🕒 Hatched in this hourly block: `%d`", FSettings.eggs_hatched_in_hourly_session),
        string.format("│ 📈 Total Hatched (All Time): `%d`", FSettings.pets_hatched_total), "",
        string.format("│ 👤 Username: ||`%s`||", _S.LocalPlayer.Name),
    }
    sendWebhook("Timed Report (10 Min)", table.concat(descriptionLines, "\n"), 16776960) -- Yellow Color
end

local function send_hourly_report()
    local descriptionLines = {
        "**⏰ Hourly Stats Summary**", "",
        string.format("│ 🐣 Hatched this hour: `%d`", FSettings.eggs_hatched_in_hourly_session),
        string.format("│ 📈 Total Hatched (All Time): `%d`", FSettings.pets_hatched_total), "",
        string.format("│ 👤 Username: ||`%s`||", _S.LocalPlayer.Name),
    }
    sendWebhook("Timed Report (Hourly)", table.concat(descriptionLines, "\n"), 5763719) -- Dark Green Color
end



-- This function runs ONCE on script load to check if reports are due
local function CheckAndSendTimedReports()
    print("📈 Checking if timed reports are due...")
    local current_time = os.time()
    local did_update = false

    -- Initialize timestamps on the very first run
    if FSettings.last_10min_report_time == 0 then FSettings.last_10min_report_time = current_time end
    if FSettings.last_hourly_report_time == 0 then FSettings.last_hourly_report_time = current_time end

    -- Check if 10 minutes have passed since the last saved time
    if (current_time - FSettings.last_10min_report_time) >= 600 then
        print("10-minute report is due. Sending...")
        send_10min_report()
        FSettings.eggs_hatched_in_10_min_session = 0
        FSettings.last_10min_report_time = current_time
        did_update = true
    end

    -- Check if 1 hour has passed since the last saved time
    if (current_time - FSettings.last_hourly_report_time) >= 3600 then
        print("Hourly report is due. Sending...")
        send_hourly_report()
        FSettings.eggs_hatched_in_hourly_session = 0
        FSettings.last_hourly_report_time = current_time
        did_update = true
    end

    -- If we sent a report, save the new timestamps and reset counters
    if did_update then
        SaveData()
    end
end


local function findEggTool(eggName)
    if not eggName then return nil end
    -- 1. Check if the character is already holding the correct tool.
    local humanoid = _S.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        -- A character can only hold one tool at a time.
        local equippedTool = _S.Character:FindFirstChildOfClass("Tool")
        
        -- Check if a tool is equipped AND if it's the right egg.
        if equippedTool and equippedTool:GetAttribute("h") == eggName then
            return equippedTool -- Found it! No need to search further.
        end
    end

    -- 2. If not equipped, search the player's backpack.
    for _, tool in ipairs(_S.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool:GetAttribute("h") == eggName then
            return tool -- Found it in the backpack.
        end
    end
    
    -- 3. If we've checked everywhere and found nothing, return nil.
    return nil
end




local function FindEggLostGainDiff()
    local total_diff = 0

    for eggName, data in pairs(egg_counts) do
        local diff = data.new_amount - data.current_amount
        if diff > 0 then
            total_diff = total_diff + diff
        end 
    end

    return total_diff
end
 
 

local function findEggToPlaceBasedOnPriority()
    -- Collect enabled eggs with their order
    local enabledEggs = {}
    for eggName, data in pairs(FSettings.eggs_to_place_array) do
        if data.enabled then
            table.insert(enabledEggs, {name = eggName, order = data.order})
        end
    end

    -- Sort by order
    table.sort(enabledEggs, function(a, b)
        return a.order > b.order
    end)

    -- Loop through sorted enabled eggs
    for _, egg in ipairs(enabledEggs) do
        local foundTool = findEggTool(egg.name)
        if foundTool then
            return foundTool
        else
            warn(egg.name .. " not found, moving to next")
        end
    end

    -- No eggs found
    return nil
end


local function GetCountEggsOnFarm()
    local f_count = 0
    -- crates are also placed in this location, filter eggs only
    local array_ob = mObjects_Physical:GetChildren()
    for _, value in ipairs(array_ob) do
        if value and value:IsA("Model") and value.Name == "PetEgg" then
            f_count = f_count + 1
        end
    end
    task.wait(0.3); 
    return f_count
end

-- seed placements
local function getGridSeedPositions(center)
    local positions = {}
    
    -- ## Tweak these values to change the shape ##
    local OUTER_WIDTH = 70   -- The total width of the placement area.
    local OUTER_DEPTH = 50   -- The total depth of the placement area.
    local INNER_WIDTH = 14   -- The width of the empty "walk area" in the middle.
    local INNER_DEPTH = 60   -- The depth of the empty "walk area" in the middle.
    local SPACING = 1.5      -- The distance between each spot, smaller for denser packing.
    
       -- ## Tweak these values to change the shape ##
    -- local OUTER_WIDTH = 70  -- The total width of the placement area.
    -- local OUTER_DEPTH = 50  -- The total depth of the placement area.
    -- local INNER_WIDTH = 14  -- The width of the empty "walk area" in the middle.
    -- local INNER_DEPTH = 60  -- The depth of the empty "walk area" in the middle.
    -- local SPACING = 5       -- The distance between each spot.

    -- Calculate boundaries from the center point
    local halfOuterW = OUTER_WIDTH / 2
    local halfOuterD = OUTER_DEPTH / 2
    local halfInnerW = INNER_WIDTH / 2
    local halfInnerD = INNER_DEPTH / 2

    -- Generate points in a grid pattern
    for x = center.X - halfOuterW, center.X + halfOuterW, SPACING do
        for z = center.Z - halfOuterD, center.Z + halfOuterD, SPACING do
            
            -- This condition ensures we only add points OUTSIDE the inner walk area
            if math.abs(x - center.X) > halfInnerW or math.abs(z - center.Z) > halfInnerD then
                table.insert(positions, Vector3.new(x, center.Y, z))
            end
            
        end
    end

    return positions
end


 

-- This function generates the list of possible egg locations.
local function getPredefinedEggPositions(center)
    local positions = {}
    
    -- ## Tweak these values to change the shape ##
    local OUTER_WIDTH = 70  -- The total width of the placement area.
    local OUTER_DEPTH = 50  -- The total depth of the placement area.
    local INNER_WIDTH = 14  -- The width of the empty "walk area" in the middle.
    local INNER_DEPTH = 60  -- The depth of the empty "walk area" in the middle.
    local SPACING = 5       -- The distance between each spot.

    -- Calculate boundaries from the center point
    local halfOuterW = OUTER_WIDTH / 2
    local halfOuterD = OUTER_DEPTH / 2
    local halfInnerW = INNER_WIDTH / 2
    local halfInnerD = INNER_DEPTH / 2

    -- Generate points in a grid pattern
    for x = center.X - halfOuterW, center.X + halfOuterW, SPACING do
        for z = center.Z - halfOuterD, center.Z + halfOuterD, SPACING do
            
            -- This condition ensures we only add points OUTSIDE the inner walk area
            if math.abs(x - center.X) > halfInnerW or math.abs(z - center.Z) > halfInnerD then
                table.insert(positions, Vector3.new(x, center.Y, z))
            end
            
        end
    end

    return positions
end

 











--============================= Ascension
--------------------------------------------------------------

local function UpdateAscenStats(_txt)
    if not UI_LABELS.lbl_ascenstats then return end
    UI_LABELS.lbl_ascenstats:SetText(_txt)
end

local function FetchGardenCoins()
    local success, value = pcall(function()
        return _S.PlayerGui.GardenCoinCurrency_UI.Frame.TextLabel1.val.Value
    end)

    garden_coins = tonumber(success and value) or 0
end



local function FetchHoneyCoins()
    local success, value = pcall(function()
        return _S.PlayerGui.Honey_UI.Frame.TextLabel1.val.Value
    end)

    honey_coins = tonumber(success and value) or 0
end



if not _G.CoinFetchTask then
    _G.CoinFetchTask = task.spawn(function()
        while true do
            task.wait(30)
            local success, err = pcall(function()
                FetchHoneyCoins()
                FetchGardenCoins()
            end)
            if not success then
                warn("⚠️ Coin fetch failed: ", err)
            end
        end
    end)
end



local function CollectFruitUsingNameAndMut(plantName, requiredMutations)
    local fruitsToCollect = {}

    for _, plantModel in ipairs(Plants_Physical:GetChildren()) do
        if plantModel:IsA("Model") and (not plantName or plantModel.Name == plantName) then
            local is_fav = plantModel:GetAttribute("Favorited")
            if is_fav then
                continue
            end
            local fruitsFolder = plantModel:FindFirstChild("Fruits")
            if fruitsFolder then
                for _, fruit in ipairs(fruitsFolder:GetChildren()) do
                    local is_fav1 = fruit:GetAttribute("Favorited")
                    if is_fav1 then
                        continue
                    end
                    local hasAllMutations = true
                    for mutName in pairs(requiredMutations) do
                        if not fruit:GetAttribute(mutName) then
                            hasAllMutations = false
                            break
                        end
                    end

                    if hasAllMutations then
                        table.insert(fruitsToCollect, fruit)
                        break
                    end

                end
            else
                -- this plant is fruit itself
                local hasAllMutations = true
                for mutName in pairs(requiredMutations) do
                    if not plantModel:GetAttribute(mutName) then
                        hasAllMutations = false
                        break
                    end
                end

                if hasAllMutations then
                    table.insert(fruitsToCollect, plantModel)
                end
            end
        end
    end

    if #fruitsToCollect > 0 then
        _S.collectEvent:FireServer(fruitsToCollect)
        --print("🍉 Collected", #fruitsToCollect, "fruit(s)")
        sleep_ascend = 2 -- lower time for faster submit
        return true
    end
    sleep_ascend = 30
    --warn("Unable to collect this fruit. it does not match any mutations")
    return false
end


-- Returns true if any plant with the given name exists
local function HasPlantByName(plantName)
    for _, plantModel in ipairs(Plants_Physical:GetChildren()) do
        if plantModel:IsA("Model") and plantModel.Name == plantName then
            local is_fav = plantModel:GetAttribute("Favorited")
            if is_fav then
                --warn("This fruit is fav");
                continue
            end
            return true
        end
    end
    return false
end

-- Function to plant a seed safely
local function PlantSeed(position, seedName)
    local success, err = pcall(function() 
        _S.PlantRemote:FireServer(position,seedName)
    end)
end


local function CharEquipTool(tool)
    if tool and tool:IsA("Tool") then
        tool.Parent = _S.Character  -- equip the tool
        --print("✅ Equipped tool:", tool.Name)
        return true
    else
       -- warn("⚠️ Not a valid tool instance")
        return false
    end
end
 

local function FindFruitInBackpack(fruitname, mutations)
    local function hasAllMutations(item)
        for mutationName in pairs(mutations) do
            if not item:GetAttribute(mutationName) then
                return false -- missing one mutation → fail
            end
        end
        return true -- all mutations present
    end

    -- Check Backpack
    for _, item in ipairs(_S.Backpack:GetChildren()) do
        if item:IsA("Tool") and item:GetAttribute("b") == "j" then
            local fname = item:GetAttribute("f")
            if fname == fruitname and hasAllMutations(item) then
                return item
            end
        end
    end

    -- Check Character (holding)
    for _, item in ipairs(_S.Character:GetChildren()) do
        if item:IsA("Tool") and item:GetAttribute("b") == "j" then
            local fname = item:GetAttribute("f")
            if fname == fruitname and hasAllMutations(item) then
                return item
            end
        end
    end

    return nil -- no matching fruit found
end

local function FindFruitSeedInBackpack(fruitname)
    for _, item in ipairs(_S.Backpack:GetChildren()) do 
        if item:IsA("Tool") and item:GetAttribute("b") == "n" then
            local is_fav = item:GetAttribute("d")
            local f_uuid = item:GetAttribute("c")
            local fname = item:GetAttribute("f") -- fruit name
            local Variant = item:GetAttribute("Variant");
            local Seed = item:GetAttribute("Seed") -- seed name
            local Quantity = item:GetAttribute("Quantity")
            
            if fname == fruitname or Seed == fruitname then
                return item;
            end
        end
    end
    
    -- player maybe holding this tool check it
    -- Then check Character (player might be holding it)
    for _, item in ipairs(_S.Character:GetChildren()) do
        if item:IsA("Tool") and item:GetAttribute("b") == "n" then
            local fname = item:GetAttribute("f")
            local Seed = item:GetAttribute("Seed")
            
            if fname == fruitname or Seed == fruitname then
                return item
            end
        end
    end
    
    return nil
end


local function PlantRequiredFruitsForAscension(fruit_name) 
    local seed_tool = FindFruitSeedInBackpack(fruit_name)
    if seed_tool then
        --print("WE found a seed we can use to plant this: ")
        -- equip it
        CharEquipTool(seed_tool)

        local center = mFarm.Center_Point.Position
        local availablePositions = getGridSeedPositions(center)

        for i = #availablePositions, 2, -1 do
            local j = math.random(i)
            availablePositions[i], availablePositions[j] = availablePositions[j], availablePositions[i]
        end
        
        is_garden_full_seed = false

        -- Loop to place the eggs
        local target_egg_am = 40
        for i = 1, target_egg_am do
            -- cant place anymore seeds
            if is_garden_full_seed then 
                task.sleep(10)
                break
            end
            
            if #availablePositions == 0 then
                --warn("No more predefined placement spots available.") 
                break
            end

            -- Get the position for this specific egg.
            local placePos = table.remove(availablePositions)

            -- try to place the seed.
            --print("Placed seed: ");
            PlantSeed(placePos,fruit_name)

            task.wait(0.5);
            -- recheck if we now have this
            if HasPlantByName(fruit_name) then
                --print("Fruit Planted successully!")
                if not _S.player_humanoid then return end
                _S.player_humanoid:UnequipTools()
                task.wait(0.2)
                break
            else
                --print("Failed to place trying again.")
            end

        end

    else
       -- warn("No seed found for " .. fruit_name )
    end
     
end


function IsAscensionCountDownOver()
    local RebirthConfirmation = _S.PlayerGui.RebirthConfirmation
    local success3, a_text = pcall(function()
        return RebirthConfirmation.Frame.Frame.AscensionTimer.ContentText
    end)
     -- Check if ascension is ready
    if success3 and a_text and a_text == "Next Ascension in 4:30" then
        return true
    end
    
    if not a_text then
        return false
    end

     -- CONCATENATE ALL DIGITS: "4:26" -> "426"
    local digitsConcat = a_text:gsub("%D", "")          -- remove every non-digit
    local numeric = tonumber(digitsConcat) or 0       -- default to 0 if empty

    -- your original rule: if less than 4 (e.g. "3" or "0") -> allow ascend
    if numeric < 4 then
        --print("is less than 4")
        --return true
    end

     local successv, is_vis = pcall(function()
        return RebirthConfirmation.Frame.Frame.AscensionTimer.Visible
    end)

    -- if UI hidden -> allow ascend
    if successv and not is_vis then
        --print("ui is hidden")
        return true
    end

    return false
end

local function AutoAscension()
    local fruit_name
    local mutations_fs = {}
    local can_ascend = false
    local RebirthConfirmation = _S.PlayerGui.RebirthConfirmation

    -- what mutation the fruit needs.
    --  this can be array , e.g WindStruct,Sun
    local success1, value1 = pcall(function()
        return RebirthConfirmation.Frame.Display.RebirthDetails.RequiredItemTemplate.ItemMutations.ContentText
    end)
    
    -- Fruit name 
    local success2, value2 = pcall(function()
        return RebirthConfirmation.Frame.Display.RebirthDetails.RequiredItemTemplate.ItemName.ContentText
    end)
    
    if success2 and value2 then
        fruit_name = value2
    end
    
     -- Normalize mutations into dictionary for fast lookup
    if success1 and value1 and value1 ~= "" then
        for mut in string.gmatch(value1, "([^,]+)") do
            mutations_fs[mut:match("^%s*(.-)%s*$")] = true -- trim spaces
        end
    end
    
    -- Check if ascension is ready
    can_ascend = IsAscensionCountDownOver()
    task.wait(0.1)
    
    --fruit_name = "Carrot" -- testing
     -- check if we have this fruit in the backpack or are we holding it
    local requried_tool = FindFruitInBackpack(fruit_name, mutations_fs)
    
    if can_ascend and requried_tool then 
        if requried_tool then
            -- we have this fruit in the backpack.
            -- claim rewards
            CharEquipTool(requried_tool)
            game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyRebirth"):FireServer()
            print("Ascension Completed")
            UpdateAscenStats("✅ Ascension Completed")
            task.wait(5)
        end
    else
        if HasPlantByName(fruit_name) then
            --print("We have this plant: " .. fruit_name)
            -- collect fruit matching what is required, ignores fav fruit.
            if not requried_tool then
                CollectFruitUsingNameAndMut(fruit_name, mutations_fs);
            end
            
        else
            --warn("Dont have this plant, place one.")
            PlantRequiredFruitsForAscension(fruit_name)
        end
        UpdateAscenStats("❌ Not ready for Ascension")
        task.wait(3)
    end


    -- print("AscensionTimer: ", value3)
    -- print("Fruit name: ", fruit_name)
    -- print("Mutations: ", _S.HttpService:JSONEncode(mutations_fs))
    -- print("Can Ascend: " , can_ascend)

end
 
--  task that runs Ascension
if not _G.AutoAscensionTask then
    _G.AutoAscensionTask = task.spawn(function()
        while true do
            task.wait(0.5)
            if not FOtherSettings.auto_ascension then
                continue
            end 
            UpdateAscenStats("⚙️ Auto Ascension is running ")
            task.wait(sleep_ascend)
            local success, err = pcall(AutoAscension)
            if not success then
                warn("⚠️ AutoAscension failed: ", err)
            end
        end
    end)
end





--============================= END Ascension
--------------------------------------------------------------


























local function placeMissingEggs(myFarm)
    --print("Starting to place eggs...")
    UPDATE_LABELS_FUNC.UpdateSetLblStats("Starting to place eggs")
    local humanoid = _S.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    humanoid:UnequipTools()
    task.wait(0.1)

    local target_egg_am = 60
    local user_max_egg = GetMaxEggCapacity()

    if not mObjects_Physical then
        warn("Objects_Physical not found {placeMissingEggs}")
        return
    end

    local center = myFarm.Center_Point.Position
    local availablePositions = getPredefinedEggPositions(center)

    for i = #availablePositions, 2, -1 do
        local j = math.random(i)
        availablePositions[i], availablePositions[j] = availablePositions[j], availablePositions[i]
    end

    -- Loop to place the eggs
    for i = 1, target_egg_am do
        if is_max_eggs_reached then break end

        -- FIX #1: Find a fresh, valid tool on EVERY loop iteration.
        local eggToolToEquip = findEggToPlaceBasedOnPriority()

        -- This check now correctly handles running out of eggs mid-placement.
        if not eggToolToEquip then
            --warn("Could not find any more placeable eggs. Stopping.")
            break
        end

        local egg_on_farm = GetCountEggsOnFarm()
        if egg_on_farm >= user_max_egg or is_max_eggs_reached then
            is_max_eggs_reached = true
            --warn("Max eggs placed")
            UPDATE_LABELS_FUNC.UpdateSetLblStats("Max eggs placed")
            break
        end

        if #availablePositions == 0 then
            --warn("No more predefined placement spots available.")
            UPDATE_LABELS_FUNC.UpdateSetLblStats("No more spots available.")
            is_max_eggs_reached = true
            break
        end

        -- Get the position for this specific egg.
        local placePos = table.remove(availablePositions)

        -- FIX #2: Equip the tool and then immediately check if it was successful.
        if not eggToolToEquip.Parent then
            continue
        end
        humanoid:EquipTool(eggToolToEquip)
        task.wait(0.1) -- Brief wait to ensure the parent property updates.

        if eggToolToEquip.Parent == _S.Character then
            -- Success!
            if FSettings.is_test == false then
                _S.PetEggService:FireServer("CreateEgg", placePos)
            end
            print("Placed a '" .. eggToolToEquip:GetAttribute("h") .. "' egg.")
        else
            -- Failure.
            UPDATE_LABELS_FUNC.UpdateSetLblStats("Failed to equip the egg tool")
            --warn("Failed to equip the egg tool: " )
            task.wait(0.3)
            -- The loop will automatically try again with a fresh tool.
        end
    end

    --print("✅ Egg placement complete.")
    if humanoid then
        humanoid:UnequipTools()
        task.wait(0.1)
    end
end



 -- Favorite pets
local function FavoritePets()
    print("Starting Favourite Process...")
    UPDATE_LABELS_FUNC.UpdateSetLblStats("Starting Favourite Process...")
    
    
    -- Helper function to check if a pet should be sold
    local function isPetMarkedForSale(petNameToFind)
        for eggName, petList in pairs(FSettings.sell_pets) do
            if petList[petNameToFind] ~= nil then
                return petList[petNameToFind] -- Returns true or false
            end
        end
        return false -- Pet not found in the sell list
    end
    
    local petsToFav = {}
    local pets_inbg = _S.Backpack:GetChildren()
    for _, tool in ipairs(pets_inbg) do
        if tool:IsA("Tool") and tool:GetAttribute("ItemType") == "Pet" and tool:GetAttribute("d") == false then 
            local petName, petWeight, petAge = extractPetDetails(tool.Name)
            -- Use our new helper function to check the setting
            print("pet for sale: " .. petName)
            local petToSell = isPetMarkedForSale(petName)
            local requires_fav = false
            -- if pet not in the list then fav it
            if petToSell == false then
                if petName then
                    requires_fav = true 
                end
            end
            
            local sell_w = tonumber(FSettings.sell_weight)
            -- if sell_w == 3 then
            --     sell_w = 2.86
            -- end
            
            -- if petName == "Rainbow Dilophosaurus" or petName  == "Rainbow Spinosaurus" then
            --     sell_w = 2.54
            -- else
            --     sell_w = 7
            -- end
            
            
            -- if pet is in the light but weight is bigger than sell weight then fav it also
            if petToSell and petWeight >= sell_w then
                requires_fav = true 
            end
            
            -- sell mode for Ostrich
            if FSettings.is_age_hatch_mode == true then
                -- we keep anything below
                local keepAge = tonumber(FSettings.hatch_mode_age_to_keep) or 1
                if petAge <= keepAge then
                    requires_fav = false
                end
            end

            if requires_fav then
                table.insert(petsToFav, tool)
            end
        end
    end

    if #petsToFav == 0 then
        print("No pets needed favouriting.")
        UPDATE_LABELS_FUNC.UpdateSetLblStats("No pets needed favouriting.")
        return true
    end

    print("Found " .. #petsToFav .. " pet(s) to favourite.")

    -- Fire requests
    for _, pet in ipairs(petsToFav) do
        print("Favouriting: " .. pet.Name)
        UPDATE_LABELS_FUNC.UpdateSetLblStats("Favouriting: " .. pet.Name)
        if FSettings.is_test == false then
            _S.FavItem:FireServer(pet)
        end
       
    end

    -- Give server a moment to update attributes
    task.wait(1)

    -- Verification loop
    local failed = {}
    for _, pet in ipairs(petsToFav) do
        if pet:GetAttribute("d") == true then
            print("✅ Verified: " .. pet.Name .. " is favourited.")
            pets_fav_count = pets_fav_count + 1
        else
            -- if any failed we must stop and restart process
            print("❌ Failed: " .. pet.Name .. " not favourited.")
            if FSettings.is_test == false then
                table.insert(failed, pet)
            end
            
        end
    end

    if #failed > 0 then
        -- if any failed we must stop and restart process
        warn("⚠️ " .. #failed .. " pets failed to favourite.")
        return false
    else
        print("🎉 All pets successfully favourited!")
        UPDATE_LABELS_FUNC.UpdateSetLblStats("All pets successfully favourited!")
        return true
    end
end


 -- New sell all unfav pets
local function SellAllPetsUnFavorite()
    --print("Sell All UnFav Process...")
    UPDATE_LABELS_FUNC.UpdateSetLblStats("Sell All UnFav Process...")
    if FSettings.is_test == false then
        _S.SellAllPetsRemote:FireServer();
    end
    
    task.wait(1)
end

  

-- Helper function to check if a pet with a given UUID is still visible
local function IsPetStillActiveInContainer(uuid)
    local contiems = _S.petsContainer:GetChildren()
    for _, pet in ipairs(contiems) do
        if pet:GetAttribute("UUID") == uuid and pet:GetAttribute("OWNER") == _S.LocalPlayer.Name then
            return true -- Yes, it's still here
        end
    end
    return false -- No, it's gone
end

-- The main function
local function UnEquipAllPets()
    --print("Scanning for active pets...")
    local petsToConfirm = {} -- A list to track the UUIDs we are unequipping
    local petsarray = _S.petsContainer:GetChildren()
    -- STEP 1: Fire all unequip requests in a rapid burst
    for _, petmoverpart in ipairs(petsarray) do
        if petmoverpart:IsA("Part") and petmoverpart:GetAttribute("OWNER") == _S.LocalPlayer.Name then
            local xuuid = petmoverpart:GetAttribute("UUID")
            if xuuid then
                -- Add the UUID to our tracking list
                table.insert(petsToConfirm, xuuid) 
                -- Fire the event for this pet
                _S.petsServiceRemote:FireServer("UnequipPet", xuuid)
                task.wait(0.3)
            end
        end
    end

    -- If there's nothing to unequip, we're done
    if #petsToConfirm == 0 then
        --print("No pets belonging to you were found.")
        return true
    end

    --print("Sent " .. #petsToConfirm .. " unequip requests. Now waiting for confirmation...")

    -- STEP 2: Wait for all pets in our list to be removed
    local timeout = 15 -- Max wait time in seconds
    local timeWaited = 0

    while #petsToConfirm > 0 and timeWaited < timeout do
        -- Check our list backwards (it's safer when removing items)
        for i = #petsToConfirm, 1, -1 do
            local uuidToCheck = petsToConfirm[i]
            if not IsPetStillActiveInContainer(uuidToCheck) then
                -- The pet is gone! Remove it from our list.
                table.remove(petsToConfirm, i)
            end
        end

        if #petsToConfirm > 0 then
            -- If pets are still remaining, wait a moment before checking again
            task.wait(0.2)
            timeWaited = timeWaited + 0.2
        end
    end

    -- STEP 3: Report the final result
    if #petsToConfirm == 0 then
        --print("✅ Success! All pets were confirmed as removed.")
        return true
    else
        -- failed to remove all pets. redo the process
        --warn("⚠️ Timeout! Could not confirm removal for " .. #petsToConfirm .. " pets.")
        for _, remainingUUID in ipairs(petsToConfirm) do
            print(" - Still waiting on UUID: " .. remainingUUID)
        end
    end
    
    return false
end



-- Function to equip specific pets by name from backpack
local function EquipPets(array_uuids) 
    if not array_uuids or #array_uuids == 0 then 
        warn("You must pass in pet names to equip")
        return false;
    end
 
    local center = mFarm.Center_Point.Position 
    local placementCF = CFrame.new(center)
    local petsToConfirm = {}
    
    for _, uuid in ipairs(array_uuids) do
        _S.petsServiceRemote:FireServer("EquipPet", uuid, placementCF); 
        table.insert(petsToConfirm, uuid)
        task.wait(0.3)
    end
    
    -- wait until pets are eqipped
    local timeout = 15 -- Max wait time in seconds
    local timeWaited = 0

    while #petsToConfirm > 0 and timeWaited < timeout do
        -- Check our list backwards (it's safer when removing items)
        for i = #petsToConfirm, 1, -1 do
            local uuidToCheck = petsToConfirm[i]
            if IsPetStillActiveInContainer(uuidToCheck) == true then
                -- yes pet is active
                table.remove(petsToConfirm, i)
            end
        end

        if #petsToConfirm > 0 then
            -- if not all pets are on the map then wait
            task.wait(0.1)
            timeWaited = timeWaited + 0.1
        end
    end

    -- STEP 3: Report the final result
    if #petsToConfirm == 0 then
        print("✅ Success! All pets were confirmed as equipped.")
        return true
    else
        -- failed to equip all pets, must restart flow and log a warning with time and
        warn("⚠️ Timeout! Could not confirm equip for " .. #petsToConfirm .. " pets.")
        for _, remainingUUID in ipairs(petsToConfirm) do
            print(" - Still waiting on UUID: " .. remainingUUID)
        end
    end
  
    return false
end






 


-- hatchs all eggs
local function HatchAllEggsAvailable(hatch_all)
    warn("Starting to hatch eggs..")

    if not mObjects_Physical then
        warn("issue finding Objects_Physical")
        UPDATE_LABELS_FUNC.UpdateSetLblStats("Issue finding eggs on farm")
        return false
    end
    local is_hatch_all = true
    local ready_to_hatch_eggs = {}
    local eggs_on_farm_array = mObjects_Physical:GetChildren();
    
    if not hatch_all then
        is_hatch_all = false
    else
        is_hatch_all = hatch_all
    end

    for _, obj in ipairs(eggs_on_farm_array) do
        -- Check if the object is a valid, ready-to-hatch egg model
        if obj:IsA("Model") and obj:GetAttribute("TimeToHatch") == 0 and obj.Name == "PetEgg" then
           
            table.insert(ready_to_hatch_eggs, obj)
        end
    end
 
    local count_ready_eggs = #ready_to_hatch_eggs
    print("Ready to hatch eggs:", count_ready_eggs)
     
    -- New, more reliable hatching logic
    if count_ready_eggs > 0 then
        for _, eggModel in ipairs(ready_to_hatch_eggs) do
            local eggName = eggModel:GetAttribute("EggName") or "Unknown Egg"
            local uuid = eggModel:GetAttribute("OBJECT_UUID")
            print("   - Found a ready egg: " .. eggName .. ". Firing event...")
            UPDATE_LABELS_FUNC.UpdateSetLblStats("Hatching: " .. eggName)
            
            local can_hatch_this = true
            -- prevent egg hatching if this is a big or huge pet according to weight set
            local pet_data = found_pet_data[uuid]
            if pet_data and is_hatch_all == false then
                local _weight = pet_data.weight
                local _petname = pet_data.petname
                if _weight >= FSettings.sell_weight then
                    -- we can't hatch this egg.
                    can_hatch_this = false
                    UPDATE_LABELS_FUNC.UpdateSetLblStats("Cant hatch egg, weight is high," .. _petname)
                    -- add to the array
                    table.insert(big_pets_hatch_models,eggModel)
                    --task.wait(4)
                end
            end

            -- This is the direct and correct way to hatch the egg
            if FSettings.is_test == false then
                if can_hatch_this then
                    _S.PetEggService:FireServer("HatchPet", eggModel)
                end
                task.wait(0.1)
            end 
        end

       -- task.wait(0.3) -- await
        if FSettings.is_test == true then
            table.insert(newlyHatchedNames, "Shiba Inu [1.56 KG] [Age 1]")
        end
        -- Sends to webhook
        canSendReport = true

        print("Hatching process complete. Sent requests for " .. count_ready_eggs .. " egg(s).")
    end
    --  hatch function ends
end




 


local function fairySubmit()
    _S.GameEvents:WaitForChild("FairyService"):WaitForChild("SubmitFairyFountainAllPlants"):FireServer() 
end


local function OnBatchCollected()
    -- any event based stuff here
    --
    if FSettings.is_fairy_scanner_active then
        fairySubmit()
    end
end


local function MakeFruitsFav(list)
    for _, item in ipairs(list) do
        _S.FavItem:FireServer(item)
    end
end


local function GetAllFruitsToSell()
    print("get fruits")
    local fav_list = {}
    local sell_candidates  = {} 
    
    -- Find all fruits to fruit
    for _, item in ipairs(_S.Backpack:GetChildren()) do
        if item:IsA("Tool") and item:GetAttribute("b") == "j" and item:GetAttribute("d") == false then
            local fname = item:GetAttribute("f");
            local fruit_uuid = item:GetAttribute("c");
            if next(FOtherSettings.sell_fruit_list) then
                -- if list is not empty then add these fruits to the list as they will be sold.
                if FOtherSettings.sell_fruit_list[fname] then
                    table.insert(sell_candidates,item)
                else
                    table.insert(fav_list,item)
                end
            else
                table.insert(sell_candidates,item)
            end
        end 
    end
    
    -- this loop checks mutation fiilters
    for _, item in ipairs(sell_candidates) do
        if item:IsA("Tool") and item:GetAttribute("b") == "j" and item:GetAttribute("d") == false then
            -- found a fruit, thats not fav
            local fname = item:GetAttribute("f");
            local fruit_uuid = item:GetAttribute("c");
            -- don't sell this these frutis.
            local prevent_sell = false

            for _name, _val in pairs(FOtherSettings.sell_mutation_whitelist) do
                if item:GetAttribute(_name) and _val then
                    -- Sell anything match here
                    prevent_sell = false 
                    break
                end
            end
            for _name, _val in pairs(FOtherSettings.sell_mutation_blacklist) do
                --- prevent sell of these
                if item:GetAttribute(_name) and _val then
                    -- Fav everything match here, this is prevent
                    prevent_sell = true
                    break
                end
            end
            
            
            if prevent_sell then
                -- add or prevent
                table.insert(fav_list,item)
            end
            
            --table.insert(fruit_ls,item)
            --print("Fruit Name: ", fname)
        end
    end
    
    task.wait(0.4)
    print("Make fav")
    MakeFruitsFav(fav_list) -- fav fruits
    task.wait(1.2)
    print("Selling all fruits...")
    
    -- teleport
    local hrp = _S.Character:WaitForChild("HumanoidRootPart")
    -- Save the current CFrame
    local originalCFrame = hrp.CFrame
    local targetCFrame = CFrame.new( 87.0313492, 2.99999976, 0.724588692)
    TeleportPlayerToCFrame(targetCFrame)
    task.wait(0.2)
    _S.Sell_Inventory:FireServer()
    -- use sell list here
    task.wait(1)
    MakeFruitsFav(fav_list) -- call again to unfav fruits after selling
    task.wait(0.5)
    -- tp back
    TeleportPlayerToCFrame(originalCFrame)
    print("Unfav")
    backpack_full = false
end
 



local function mutCheck(fruit)
    -- Check blacklist first (always overrides)
    for name, selected in pairs(FOtherSettings.mutation_blacklist) do
        if selected and fruit:GetAttribute(name) then
            return false
        end
    end

    -- Check whitelist
    local whitelistExists = false
    for name, selected in pairs(FOtherSettings.mutation_whitelist) do
        if selected then
            whitelistExists = true
            if fruit:GetAttribute(name) then
                return true
            end
        end
    end

    -- If whitelist exists but no match → block
    if whitelistExists then
        return false
    end

    -- No whitelist or blacklist matched → allow
    return true
end

local function LabelUpdateCollectFruitStats(_txt)
    if not UI_LABELS.lbl_fruit_collect_live then 
        print(_txt)
        return 
    end
    UI_LABELS.lbl_fruit_collect_live:SetText(_txt)
end

local BATCH_SIZE = 3 
local waiter_count = 0

local function IsAnyPlantsSelected()
    for _name, _val in pairs(FOtherSettings.collection_plants) do
        if _val then
            return true 
        end
    end
    return false
end

-- (The rest of your backend logic remains unchanged)
local function collectFilteredFruits()
    local allFruitsToCollect = {}
    local info1 = ""
    
    for _, plantModel in ipairs(Plants_Physical:GetChildren()) do
        local is_valid_plant = false
        local any_selected = IsAnyPlantsSelected()
        if any_selected then
            -- check what plant
            --warn("Check plant: " , plantModel.Name)
            is_valid_plant = FOtherSettings.collection_plants[plantModel.Name]
        else
            -- no plant is selected. so pick any
            is_valid_plant = true
        end

        if plantModel:IsA("Model") and is_valid_plant then
            local fruitsFolder = plantModel:FindFirstChild("Fruits")

            if fruitsFolder then
                for _, fruit in ipairs(fruitsFolder:GetChildren()) do
                    local shouldCollect = mutCheck(fruit) 

                    -- Weight checks per fruit TODO

                    if shouldCollect then
                        table.insert(allFruitsToCollect, fruit)
                    else
                        --print("cant collect this fruit: ")
                    end
                end
            end
        end
    end

    if #allFruitsToCollect == 0 then
        waiter_count = waiter_count + 1
        info1 = "Status: No matching fruits found. Waiting..." .. waiter_count
        LabelUpdateCollectFruitStats(info1)
        return
    end

    info1 = string.format("Processing %d fruits...", #allFruitsToCollect)
    LabelUpdateCollectFruitStats(info1)
    task.wait(1)
    
    waiter_count = 0
    
    for i = 1, #allFruitsToCollect, BATCH_SIZE do
        if not FOtherSettings.is_collect_fruit then break end
        local batch = {}
        for j = i, math.min(i + BATCH_SIZE - 1, #allFruitsToCollect) do
            table.insert(batch, allFruitsToCollect[j])
        end
        if #batch > 0 then
            if backpack_full then
                break
            end 
            info1 = string.format("Collecting batch %d/%d...", (i-1)/BATCH_SIZE + 1, math.ceil(#allFruitsToCollect/BATCH_SIZE))
            LabelUpdateCollectFruitStats(info1)
            _S.collectEvent:FireServer(batch)
            task.wait(0.2)
            OnBatchCollected()
        end
    end
    info1 = "Status: Collection cycle complete. Waiting..."
    LabelUpdateCollectFruitStats(info1)
end

 
-- The main loop, controlled by FOtherSettings.is_collect_fruit
local function collectionLoop()
    while true do
        task.wait(1) -- Check every second
        -- MODIFIED: Checks the value in your FOtherSettings table
        --print("backpack: " , backpack_full)
        --print("auto_sellbackpack: " , FOtherSettings.auto_sellbackpack)
        if backpack_full and FOtherSettings.auto_sellbackpack then
            task.wait()
            GetAllFruitsToSell() 
            task.wait(1)
        end
        
        if FOtherSettings.is_collect_fruit and not backpack_full then
            collectFilteredFruits()
            task.wait(3) -- Wait after a full cycle
        end
    end
end

-- Start the loop
spawn(collectionLoop)


-- rejoins the server to restart all over again.
local function rejoinS()
    if is_forced_stop == true then 
        warn("Forced to stop running...");
        return
    end
    warn("Rejoin...");
    if FSettings.is_test == false then  
        _S.TeleportService:Teleport(game.PlaceId)
    end
end

-- UI
local function UpdateUITeamCount()
    if not UI_LABELS.lbl_selected_team1_count or not UI_LABELS.lbl_selected_team2_count or not UI_LABELS.lbl_selected_team3_count or not UI_LABELS.lbl_selected_team4_count then
        return
    end

    local tm1_count = #FSettings.team1
    local tm2_count = #FSettings.team2
    local tm3_count = #FSettings.team3
    local tm4_count = #FSettings.team4
    local total_p = GetMaxPetCapacity()
    UI_LABELS.lbl_selected_team1_count:SetText("Selected: " .. tm1_count .. "/" .. total_p)
    UI_LABELS.lbl_selected_team2_count:SetText("Selected: " .. tm2_count .. "/" .. total_p)
    UI_LABELS.lbl_selected_team3_count:SetText("Selected: " .. tm3_count .. "/" .. total_p)
    UI_LABELS.lbl_selected_team4_count:SetText("Selected: " .. tm4_count .. "/" .. total_p)
end


-- needs boolean
print("Delete all farms plants");
DeleteAllPlantsFolder()
task.wait(0.2);





local waiting_for_hatch_count = 0

local function SessionLoop()
    -- This loop runs continuously in the same server session without rejoining.
    while not is_forced_stop and FSettings.is_running do

        -- Reset flags and counters for the new cycle
        newlyHatchedNames = {}
        pets_fav_count = 0
        got_eggs_back = 0
        recovered_eggs = 0
        is_pet_inventory_full = false
        canSendReport = false
        is_max_eggs_reached = false
         
        waiting_for_hatch_count = 0
        big_pets_hatch_models = {} 
        pet_size_bonus = 0
        passive_pet_bonus = 0
        tracked_bonus_egg_recovery = 0
        tracked_bonus_egg_sell_refund = 0
        
        UpdatePlayerStats() -- reset any buffs

        UPDATE_LABELS_FUNC.UpdateSetLblStats("Checking for ready eggs...")
        print("SessionLoop: Checking for ready eggs...")
        task.wait(0.4)
        
        
        --========== Egg Timer Reduction Team
        
        local is_ready_hatch = CheckAnyEggsToHatch()
        task.wait(0.5);
        local eggs_onfarm = GetCountEggsOnFarm()
        task.wait(0.5);
        UPDATE_LABELS_FUNC.UpdateSetLblStats("Check Egg Reduction Team for placement..." .. tostring(is_ready_hatch))
        
        if FSettings.disable_team3 == false then
            -- Place team only if eggs need reduction
            if is_ready_hatch == false then
                -- place team
                 UPDATE_LABELS_FUNC.UpdateSetLblStats("Placing egg reduction team..")
                if UnEquipAllPets() == false then
                    UPDATE_LABELS_FUNC.UpdateSetLblStats("[reduction team] Failed to unequip. Retrying cycle in 5s...")
                    print("reduction team Error: Failed to unequip pets. Retrying cycle.")
                    task.wait(5)
                    continue -- Restart the loop
                end
                UPDATE_LABELS_FUNC.UpdateSetLblStats("[T]Placing egg reduction team...")
                task.wait(0.3)
                if not EquipPets(FSettings.team3) then
                    UPDATE_LABELS_FUNC.UpdateSetLblStats("Team 3 failed. Retrying cycle in 5s...")
                    print("SessionLoop Error: Failed to place egg reduction team. Retrying cycle.")
                    task.wait(5)
                    continue -- Restart the loop
                end
            end
        end
        
        task.wait(3.5)

        -- Wait until there are eggs ready to hatch
        while CheckAnyEggsToHatch() == false and not is_forced_stop and FSettings.is_running do
            UPDATE_LABELS_FUNC.UpdateSetLblStats("Waiting for eggs to hatch..." .. waiting_for_hatch_count)
            print("SessionLoop: Eggs not ready, waiting..." .. tostring(is_ready_hatch))
            waiting_for_hatch_count = waiting_for_hatch_count + 1
            task.wait(5) -- Wait 2 seconds before checking again
        end

        -- If the loop was stopped while waiting, exit now.
        if is_forced_stop or not FSettings.is_running then
            break
        end

        print("SessionLoop: Eggs are ready! Starting cycle.")
        UPDATE_LABELS_FUNC.UpdateSetLblStats("Eggs ready! Starting cycle.")
        task.wait(0.5)
        BeforeUpdateEggCountForAllEggs()
 
        --================= HATCH CYCLE =================
        -- Place Hatching Team (Team 2)
        if FSettings.disable_team2 == false then
            if UnEquipAllPets() == false then
                UPDATE_LABELS_FUNC.UpdateSetLblStats("Failed to unequip. Retrying cycle in 5s...")
                print("SessionLoop Error: Failed to unequip pets. Retrying cycle.")
                task.wait(5)
                continue -- Restart the loop
            end
            task.wait(0.2)
            UPDATE_LABELS_FUNC.UpdateSetLblStats("Placing hatching team...")
            if not EquipPets(FSettings.team2) then
                UPDATE_LABELS_FUNC.UpdateSetLblStats("Team 2 failed. Retrying cycle in 5s...")
                print("SessionLoop Error: Failed to place hatching team. Retrying cycle.")
                task.wait(5)
                continue -- Restart the loop
            end
        end

        UPDATE_LABELS_FUNC.UpdateSetLblStats("Waiting for hatch buffs...")
        task.wait(3.5)

        UPDATE_LABELS_FUNC.UpdateSetLblStats("Hatching all available eggs...")
        UpdatePlayerStats() 
        tracked_bonus_egg_recovery = PlayerSecrets.EggRecoveryChance
        HatchAllEggsAvailable(false) -- HATCH EGGS, provide false, we can't hatch big pets here

        if is_pet_inventory_full then -- CRITICAL STOP: This cannot be recovered by retrying.
            SendErrorMessage("Pet Inventory is full! Stopping session.")
            --is_forced_stop = true
            --break
        end
        UPDATE_LABELS_FUNC.UpdateSetLblStats("Hatching Complete.")
        task.wait(2)
        
        
        
        -- ============ BIG PET HATCH
        -- These pets can be hatched using pets that can increase size.
        if #big_pets_hatch_models > 0 then
            -- We have big pets to hatch
            
            -- place big pets hatching team here...
            -- Team 4 is big size pet team
            if FSettings.disable_team4 == false then 
                if UnEquipAllPets() == false then
                    UPDATE_LABELS_FUNC.UpdateSetLblStats("Failed to unequip. Retrying cycle in 5s...")
                    print("SessionLoop Error: Failed to unequip pets. Retrying cycle.")
                    task.wait(5)
                    continue -- Restart the loop
                end
                task.wait(0.2)
                UPDATE_LABELS_FUNC.UpdateSetLblStats("Placing pet size team...")
                if not EquipPets(FSettings.team4) then
                    UPDATE_LABELS_FUNC.UpdateSetLblStats("Team 4 failed. Retrying cycle in 5s...")
                    print("SessionLoop Error: Failed to place hatching team. Retrying cycle.")
                    task.wait(5)
                    continue -- Restart the loop
                end 
            end
            
          
            UPDATE_LABELS_FUNC.UpdateSetLblStats("Hatching big pets.");
            task.wait(3.9) -- wait for buffs
            UpdatePlayerStats() --  update the player stats so we know if buffs were applied etc
            pet_size_bonus = PlayerSecrets.PetEggHatchSizeBonus
            
            HatchAllEggsAvailable(true) -- set to true to hatch all eggs including big
            UPDATE_LABELS_FUNC.UpdateSetLblStats("Hatching Big Pets Complete.")
            task.wait(2) -- wait a bit after hatching
           
        end
        
        
 
         --================= SELL CYCLE =================
        UPDATE_LABELS_FUNC.UpdateSetLblStats("Favouriting Pets...")
        if FavoritePets() == false then
            UPDATE_LABELS_FUNC.UpdateSetLblStats("Failed to fav. Retrying cycle in 5s...")
            print("SessionLoop Error: Failed to favorite pets. Retrying cycle.")
            task.wait(0.7)
            continue -- Restart the loop from the top instead of stopping
        end
        task.wait(2)

        -- Place Selling Team (Team 1)
        if FSettings.disable_team1 == false then
            if UnEquipAllPets() == false then
                UPDATE_LABELS_FUNC.UpdateSetLblStats("Failed to unequip. Retrying cycle in 5s...")
                print("SessionLoop Error: Failed to unequip pets. Retrying cycle.")
                task.wait(5)
                continue -- Restart the loop
            end
            UPDATE_LABELS_FUNC.UpdateSetLblStats("Placing selling team...")
            if not EquipPets(FSettings.team1) then
                UPDATE_LABELS_FUNC.UpdateSetLblStats("Team 1 failed. Retrying cycle in 5s...")
                print("SessionLoop Error: Failed to place selling team. Retrying cycle.")
                task.wait(5)
                continue -- Restart the loop
            end
        end

        UPDATE_LABELS_FUNC.UpdateSetLblStats("Selling pets...")
        task.wait(6) -- Wait for sell buffs to apply
        UpdatePlayerStats()
        tracked_bonus_egg_sell_refund = PlayerSecrets.PetSellEggRefundChance
        SellAllPetsUnFavorite()
        task.wait(1)
        UPDATE_LABELS_FUNC.UpdateSetLblStats("Selling complete.")
        UpdatePetData()
        
        --================= CLEANUP AND REPORTING ================= 
        task.wait(0.4)

        UPDATE_LABELS_FUNC.UpdateSetLblStats("Placing new eggs...")
        --UnEquipAllPets()
        placeMissingEggs(mFarm) -- This function will set is_forced_stop if it runs out of eggs.
        task.wait(0.5)

        if is_forced_stop then -- CRITICAL STOP: This cannot be recovered by retrying.
            UPDATE_LABELS_FUNC.UpdateSetLblStats("Out of eggs to place. Stopping farm.")
            --break
        end  
        
        passive_pet_bonus = PlayerSecrets.PetPassiveBonus
        
        -- unequip player so it is not holding any tools.
        unequipTools() -- remove anything from players hand
        task.wait(0.1)
       
        AfterUpdateEggCountForAllEggs()
  
        -- Update and save tracking data
        local hatched_this_cycle = #newlyHatchedNames
        if hatched_this_cycle > 0 then
            FSettings.pets_hatched_total = FSettings.pets_hatched_total + hatched_this_cycle
            FSettings.eggs_hatched_in_10_min_session = FSettings.eggs_hatched_in_10_min_session + hatched_this_cycle
            FSettings.eggs_hatched_in_hourly_session = FSettings.eggs_hatched_in_hourly_session + hatched_this_cycle
            SaveData()
        end

        if canSendReport then
            UPDATE_LABELS_FUNC.UpdateSetLblStats("Sending report...")
            HatchReport()
            task.wait(0.3)
        end

        UPDATE_LABELS_FUNC.UpdateSetLblStats("Cycle finished. Waiting for next batch.")
        print("SessionLoop: Cycle finished. Looping again.")
        task.wait(0.3) -- A brief pause before checking for ready eggs again

    end -- End of main while loop

    -- Cleanup code for when the loop is stopped
    UPDATE_LABELS_FUNC.UpdateSetLblStats("Session-based farm stopped.")
    FSettings.is_running = false
    SaveData()
    if main_thread then
        task.cancel(main_thread)
        main_thread = nil
    end
    print("SessionLoop: Farm has been stopped.")
end





 

local function MainLoop()
    -- main part, it works like this, we currently on setup a selling team and a hatching team
    -- check eggs to hatch, if none, rejoins
    -- join and load team 1
    -- sell after team 1 and all pets loaded. else rejoin [team 1 must be ready else dont sell , important]
    -- join team 2 or rejoin if fails to place all pets.
    -- hatch eggs [team 2 must be ready to hatch]
    
    while not is_forced_stop and FSettings.is_running and FSettings.is_auto_rejoin do
 
        UPDATE_LABELS_FUNC.UpdateSetLblStats("Starting egg count")
        -- if no eggs to hatch then must rejoin. unless stopped in settings
        --  check if there are any eggs to even hatch?
        if CheckAnyEggsToHatch() == false then
            -- no eggs to hatch, rejoin
            UPDATE_LABELS_FUNC.UpdateSetLblStats("No eggs to hatch.. rejoin")
            print("No eggs to hatch.. rejoin?")
            task.wait(2); -- wait in case user want to cancel
            rejoinS();
            break
        end
        
        task.wait(0.3)


        local serverv = GetServerVersion();
        if extractFirstNumber(serverv) > 1760 then
            --UPDATE_LABELS_FUNC.UpdateSetLblStats("Wrong server version.. rejoin") 
            --task.wait(2); -- wait in case user want to cancel
            --rejoinS();
            --break
        end



        

        --================= SELL 
        -- Fav any pets 
        UPDATE_LABELS_FUNC.UpdateSetLblStats("Favorite Pets")
        local is_fav_done = FavoritePets()
        if is_fav_done == false then
            UPDATE_LABELS_FUNC.UpdateSetLblStats("Failed to fav, rejoin.")
            task.wait(1);
            rejoinS();
            break
        end
        
        task.wait(1)
        
        -- Team 1 placement
        if FSettings.disable_team1 == false then 
            -- remove any pets equipped
            if UnEquipAllPets() == false then  rejoinS(); break end
            UPDATE_LABELS_FUNC.UpdateSetLblStats("UnEquip All Pets")
            task.wait(1);
            
            
            UPDATE_LABELS_FUNC.UpdateSetLblStats("Starting to place team 1")
            -- add team 1
            if EquipPets(FSettings.team1) then
                print("team 1 loaded")
                UPDATE_LABELS_FUNC.UpdateSetLblStats("team 1 loaded")
            else
                -- something went wrong. restart the process
                UPDATE_LABELS_FUNC.UpdateSetLblStats("team 1 failed to load")
                rejoinS();
                break
            end
        end
    
        
        
        -- start sell process, we can't sell unless team 1 is loaded
        UPDATE_LABELS_FUNC.UpdateSetLblStats("Start selling pets")
        task.wait(2) -- wait for buff to activate
        -- Track Bonus at this point
        UpdatePlayerStats()
        -- track what it was at this point
        tracked_bonus_egg_sell_refund = PlayerSecrets.PetSellEggRefundChance
        SellAllPetsUnFavorite()
        task.wait(0.3)
        UPDATE_LABELS_FUNC.UpdateSetLblStats("Selling complete.")
        AfterUpdateEggCountForAllEggs() -- update counts
        task.wait(1)
        got_eggs_back = FindEggLostGainDiff() -- This will let us track how many eggs we gain
        task.wait(1) -- await
        
        -- ========= END SELL
        
        
        
        
        -- Team 2 placement
        if FSettings.disable_team2 == false then
            -- add team 2
            UPDATE_LABELS_FUNC.UpdateSetLblStats("UnEquip All Pets.")
            if UnEquipAllPets() == false then rejoinS(); break end
            task.wait(0.2)
            UPDATE_LABELS_FUNC.UpdateSetLblStats("Starting to place team 2")
            if EquipPets(FSettings.team2) then
                UPDATE_LABELS_FUNC.UpdateSetLblStats("team 2 loaded")
                print("team 2 loaded")
            else
                -- something went wrong. restart the process
                UPDATE_LABELS_FUNC.UpdateSetLblStats("team 2 failed to load")
                rejoinS();
                return
            end
        end
    
        
        UPDATE_LABELS_FUNC.UpdateSetLblStats("Waiting...")
        task.wait(3.8); -- await .. wait for niho (incase its added), this pet can take time - leave this as is
 
        -- Hatch all eggs, we can't hatch unless team 2 is loaded 
        UPDATE_LABELS_FUNC.UpdateSetLblStats("Hatch All Eggs Available...")
        
      -- Track Bonus at this point
        UpdatePlayerStats()
        -- track what it was at this point
        tracked_bonus_egg_recovery = PlayerSecrets.EggRecoveryChance
        
        HatchAllEggsAvailable();
        
        if is_pet_inventory_full then
            SendErrorMessage("Pet Inventory is full!")
            task.wait(1)
        end
        UPDATE_LABELS_FUNC.UpdateSetLblStats("Hatch Complete...")
       
        task.wait(1);
        local recovered_eggs = GetCountEggsOnFarm()
        task.wait(0.3); -- await
        -- now place eggs
        UPDATE_LABELS_FUNC.UpdateSetLblStats("Placing new eggs.")
        UnEquipAllPets()
        placeMissingEggs(mFarm);
        task.wait(0.2)
       
        UPDATE_LABELS_FUNC.UpdateSetLblStats("Done Placing new eggs.")
        task.wait(0.3); -- await
        
        
        UPDATE_LABELS_FUNC.UpdateSetLblStats("Fav Pets")
        FavoritePets();
        task.wait(0.2)
        
        
        
        
        
        
        
        
        
        --- TRACKING CODE ---
        local hatched_this_cycle = #newlyHatchedNames
        if hatched_this_cycle > 0 then
            FSettings.pets_hatched_total = FSettings.pets_hatched_total + hatched_this_cycle
            FSettings.eggs_hatched_in_10_min_session = FSettings.eggs_hatched_in_10_min_session + hatched_this_cycle
            FSettings.eggs_hatched_in_hourly_session = FSettings.eggs_hatched_in_hourly_session + hatched_this_cycle
            SaveData()
        end
        --- END OF YOUR CODE ---
        
        
        if canSendReport == true then
            UPDATE_LABELS_FUNC.UpdateSetLblStats("Sending report")
            HatchReport();
            task.wait(2.5); -- await
        end
        UPDATE_LABELS_FUNC.UpdateSetLblStats("Rejoin...")
        rejoinS(); -- rejoin server
        break
        
    end -- loop ends
    
    if is_forced_stop then
        rejoinS();
    end
end
 

 


--  Make ui
--  Create dropdowns

local Window = Library:CreateWindow({
    Title = "Exotic Hub",
    Footer = "v1.1",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true
})
-- Now, add this line to make the background block clicks
if Library.ScreenGui.Main.Active then
    Library.ScreenGui.Main.Active = true
end



-- HomeDashboardUi =======================================
local function HomeDashboardUi()
    local sv = GetServerVersion()
    local MainTab = Window:AddTab({
        Name = "Home",
        Description = "Game Server Version: " .. sv,
        Icon = "house"
    })
    
    -- Add a groupbox to the left side
    local GroupAutoFarm = MainTab:AddLeftGroupbox("Auto Hatch", "calendar-sync")
    -- Text for stats
    UI_LABELS.lbl_stats = GroupAutoFarm:AddLabel({
        Text = "Stopped",
        DoesWrap = true
    })
    
    GroupAutoFarm:AddDivider()
    
    GroupAutoFarm:AddLabel({
        Text = "❗ [Warning] Be sure to 💖 favourite all important pets before running this.",
        DoesWrap = true
    })
    
    local StartAutoFarmButton = GroupAutoFarm:AddButton({
        Text = "Start Auto Hatching",
        Func = function()
            if not main_thread then
                FSettings.is_running = true
                FSettings.is_auto_rejoin = true
                is_forced_stop = false
                SaveData()
                -- start the task here
                if not main_thread then
                    if FSettings.is_session_based then
                        main_thread = task.spawn(SessionLoop);
                    else
                        main_thread = task.spawn(MainLoop);
                    end
                    -- main_thread = task.spawn(MainLoop);
                else
                    Library:Notify("Farm is already running", 3)
                end
            else
                Library:Notify("Farm already running..", 3)
            end
        end, 
    })
    
    
     local StopAutoFarmButton = GroupAutoFarm:AddButton({
        Text = "Stop Farming",
        Func = function() 
            FSettings.is_running = false
            FSettings.is_auto_rejoin = false
            is_forced_stop = true -- Set the flag to true
            SaveData()
            if main_thread then
                task.cancel(main_thread) -- Stop the running thread
                main_thread = nil
                UPDATE_LABELS_FUNC.UpdateSetLblStats("Stopped By User")
            end
        end,
    })


    -- Always capture the reference returned by AddToggle
    local MyToggle = GroupAutoFarm:AddToggle("MyToggle", {
        Text = "Test Mode",
        Default = FSettings.is_test,
        Tooltip = "Enable or disable testing",
        Callback = function(Value)
            FSettings.is_test = Value
            print("Toggle changed to:", Value)
            SaveData()
        end
    })


      local btnRejoin = GroupAutoFarm:AddButton({
        Text = "Rejoin Server",
        Func = function()
            rejoinS()
        end,
    })


end
HomeDashboardUi();

-- END of HomeDashboardUi
 

-- ===========================================================================================
-- Pet Teams Tab
local function PetTeamsUi()
    local TeamsTab = Window:AddTab({
        Name = "Pet Teams",
        Description = "Pet Teams",
        Icon = "cat"
    })
     
    local GroupBoxSellingTeam = TeamsTab:AddLeftGroupbox("Selling Team", "badge-dollar-sign")
    local GroupBoxHatchingTeam = TeamsTab:AddRightGroupbox("Hatching Team", "egg")
    local GroupBoxEggReductionTeam = TeamsTab:AddLeftGroupbox("Egg Reduction Team", "timer-reset")
    local GroupBoxEggPetSizeTeam = TeamsTab:AddRightGroupbox("Egg PetSize Team", "turtle")
     
   
    
    local lbl_sellinfo = GroupBoxSellingTeam:AddLabel({
        Text = "Please select a team that will be placed before selling the pets. 💾 auto saved.",
        DoesWrap = true
    })
    
    local lvl_hatchinfo = GroupBoxHatchingTeam:AddLabel({
        Text = "Please select a team that will be placed before hatching the eggs. 💾 auto saved.",
        DoesWrap = true
    })
    
    local lvl_eggreductioninfo = GroupBoxEggReductionTeam:AddLabel({
        Text = "Please select a team that will be placed if eggs are not ready. 💾 auto saved.",
        DoesWrap = true
    })
    
    local lvl_eggbigsizeinfo = GroupBoxEggPetSizeTeam:AddLabel({
        Text = "Please select a team that will be placed for big pet hatch.💾 auto saved.",
        DoesWrap = true
    })
    
    UI_LABELS.lbl_selected_team1_count = GroupBoxSellingTeam:AddLabel("-")
    UI_LABELS.lbl_selected_team2_count = GroupBoxHatchingTeam:AddLabel("-")
    UI_LABELS.lbl_selected_team3_count = GroupBoxEggReductionTeam:AddLabel("-")
    UI_LABELS.lbl_selected_team4_count = GroupBoxEggPetSizeTeam:AddLabel("-")
   
    UpdateUITeamCount()
    
    -- Team 1 , selling team 
    local team1data = ConvertUUIDToPetNamesPairs(FSettings.team1)
    
    --- print("pets: ", _S.HttpService:JSONEncode(petCache));
    print("team1: ", _S.HttpService:JSONEncode(team1data));
    UI_LABELS.MultiDropdownSellTeam = GroupBoxSellingTeam:AddDropdown("dropdownSellTeam", {
        Values = GetPetsCacheAsTable(),
        Default = {}, -- Default selected values for multi-select
        Multi = true,
        Searchable = true,
        MaxVisibleDropdownItems = 10,
        Text = "💰 Sell Team Selection",
        Callback = function(Values)
            local tmp_tbl = {}
            for Value, Selected in pairs(Values) do
                if Selected then
                    local _uuid = extractUUIDFromString(Value) 
                    if _uuid then
                        table.insert(tmp_tbl,_uuid)
                    end 
                end
            -- loop ends
            end

            local count_vals = #tmp_tbl
            if count_vals > GetMaxPetCapacity() then
                Library:Notify("Team size maxed", 2) 
            else 
                if is_value_selection_update == false then
                    FSettings.team1 = tmp_tbl
                    SaveData()
                    UpdateUITeamCount()
                    Library:Notify("Sell Team Updated", 2) 
                end
                
                
            end
            
            is_value_selection_update = false -- reset
        end
    })
     
    
    
    GroupBoxSellingTeam:AddDivider()
    
    local ButtonPalceTeam1 = GroupBoxSellingTeam:AddButton({
        Text = "✅ Equip",
        Func = function() 
            if #FSettings.team1 == 0 then
                Library:Notify("Team is empty", 2)
            else
                EquipPets(FSettings.team1)
            end
            
        end 
    })
    
    -- Unequip
    ButtonPalceTeam1:AddButton({
        Text = "❌ Unequip All",
        Func = function()
            UnEquipAllPets()
            UpdatePetData()
        end
    })
    
    
    local ToggleTeam1Disable = GroupBoxSellingTeam:AddToggle("ToggleTeam1Disable", {
        Text = "Disable Team 1?",
        Default = FSettings.disable_team1,
        Tooltip = "Disabled teams won't be used.",
        Callback = function(Value)
            if Value then
                FSettings.disable_team1 = Value
                SaveData()
                Library:Notify("Team1 disabled", 2)
            else
                FSettings.disable_team1 = Value
                SaveData()
                Library:Notify("Team1 Enabled", 2)
            end
            
        end
    })

    --============================  TEAM 1 END


    -- Team 2, hatching team
    local team2data = ConvertUUIDToPetNamesPairs(FSettings.team2)
    print("team2: ", _S.HttpService:JSONEncode(team2data));
    UI_LABELS.MultiDropdownHatchTeam = GroupBoxHatchingTeam:AddDropdown("dropdownHatchTeam", {
        Values = GetPetsCacheAsTable(),
        Default = {}, -- Default selected values for multi-select
        Multi = true,
        Searchable = true,
        MaxVisibleDropdownItems = 10,
        Text = "🐣 Hatch Team Selection",
        Callback = function(Values)
            local tmp_tbl = {} 
            for Value, Selected in pairs(Values) do
                if Selected then
                    local _uuid = extractUUIDFromString(Value)
                    if _uuid then
                        table.insert(tmp_tbl,_uuid)
                    end 
                end
            -- loop ends
            end
            
            local count_vals = #tmp_tbl
            if count_vals > GetMaxPetCapacity() then
                Library:Notify("Team size maxed", 2) 
            else
                warn("Saved Team 2 called", _S.HttpService:JSONEncode(Values))
                
                if is_value_selection_update == false then 
                    FSettings.team2 = tmp_tbl
                    SaveData()
                    UpdateUITeamCount()
                    Library:Notify("Hatch Team Updated", 2)
                   
                end
                
            end
            
            is_value_selection_update = false
        end
    })
     
    GroupBoxHatchingTeam:AddDivider() 
    
    local ButtonHatchTeam1 = GroupBoxHatchingTeam:AddButton({
        Text = "✅ Equip",
        Func = function() 
            if #FSettings.team2 == 0 then
                Library:Notify("Team is empty", 2)
            else
                EquipPets(FSettings.team2)
            end
            
        end 
    })
    
    -- Unequip
    ButtonHatchTeam1:AddButton({
        Text = "❌ Unequip All",
        Func = function()
            UnEquipAllPets()
            print("--- reload teams")
            UpdatePetData()
        end
    })
    
    local ToggleTeam2Disable = GroupBoxHatchingTeam:AddToggle("ToggleTeam2Disable", {
        Text = "Disable Team 2?",
        Default = FSettings.disable_team2,
        Tooltip = "Disabled teams won't be used.",
        Callback = function(Value)
            if Value then
                FSettings.disable_team2 = Value
                SaveData()
                Library:Notify("Team2 disabled", 2)
            else
                FSettings.disable_team2 = Value
                SaveData()
                Library:Notify("Team2 Enabled", 2)
            end
            
        end
    })
    
    
    
    
    -- =================== TEAM 3 - Egg Time Reduction Team
    
    
      -- Team 3, egg time reduction team
    local team3data = ConvertUUIDToPetNamesPairs(FSettings.team3)
    print("team3: ", _S.HttpService:JSONEncode(team3data));
    UI_LABELS.MultiDropdownEggReductionTeam = GroupBoxEggReductionTeam:AddDropdown("dropdownEggReductionTeam", {
        Values = GetPetsCacheAsTable(),
        Default = {}, -- Default selected values for multi-select
        Multi = true,
        Searchable = true,
        MaxVisibleDropdownItems = 10,
        Text = "🐣⏳ Egg Reduction Team",
        Callback = function(Values)
            local tmp_tbl = {} 
            for Value, Selected in pairs(Values) do
                if Selected then
                    local _uuid = extractUUIDFromString(Value)
                    if _uuid then
                        table.insert(tmp_tbl,_uuid)
                    end 
                end
            -- loop ends
            end
            
            local count_vals = #tmp_tbl
            if count_vals > GetMaxPetCapacity() then
                Library:Notify("Team size maxed", 2)
            else
                --warn("Saved Team 3 called", _S.HttpService:JSONEncode(Values))
                
                if is_value_selection_update == false then
                    FSettings.team3 = tmp_tbl
                    SaveData()
                    UpdateUITeamCount()
                    Library:Notify("Egg Reduction Team Updated", 2)
                   
                end
                
            end
            
            is_value_selection_update = false
        end
    })
     
    GroupBoxEggReductionTeam:AddDivider() 
    
    local ButtonEqiupTeam3 = GroupBoxEggReductionTeam:AddButton({
        Text = "✅ Equip",
        Func = function() 
            if #FSettings.team3 == 0 then
                Library:Notify("Team is empty", 2)
            else
                EquipPets(FSettings.team3)
            end
            
        end 
    })
    
    -- Unequip
    ButtonEqiupTeam3:AddButton({
        Text = "❌ Unequip All",
        Func = function()
            UnEquipAllPets()
            print("--- reload teams")
            UpdatePetData()
        end
    })
    
    local ToggleTeam3Disable = GroupBoxEggReductionTeam:AddToggle("ToggleTeam3Disable", {
        Text = "Disable Team 3?",
        Default = FSettings.disable_team3,
        Tooltip = "Disabled teams won't be used.",
        Callback = function(Value)
            if Value then
                FSettings.disable_team3 = Value
                SaveData()
                Library:Notify("Team3 disabled", 2)
            else
                FSettings.disable_team3 = Value
                SaveData()
                Library:Notify("Team3 Enabled", 2)
            end
            
        end
    })
    
    
     
    
    
    -- Team 4 , pet size team 
    local team4data = ConvertUUIDToPetNamesPairs(FSettings.team4)
    
    --- print("pets: ", _S.HttpService:JSONEncode(petCache));
    -- print("team4: ", _S.HttpService:JSONEncode(team4data));
    UI_LABELS.MultiDropdownEggPetSizeTeam = GroupBoxEggPetSizeTeam:AddDropdown("dropdownSellTeam", {
        Values = GetPetsCacheAsTable(),
        Default = {}, -- Default selected values for multi-select
        Multi = true,
        Searchable = true,
        MaxVisibleDropdownItems = 10,
        Text = "🐲 PetSize Team Selection",
        Callback = function(Values)
            local tmp_tbl = {}
            for Value, Selected in pairs(Values) do
                if Selected then
                    local _uuid = extractUUIDFromString(Value) 
                    if _uuid then
                        table.insert(tmp_tbl,_uuid)
                    end 
                end
            -- loop ends
            end

            local count_vals = #tmp_tbl
            if count_vals > GetMaxPetCapacity() then
                Library:Notify("Team size maxed", 2)
                
            else
                
                if is_value_selection_update == false then
                    FSettings.team4 = tmp_tbl
                    SaveData()
                    UpdateUITeamCount()
                    Library:Notify("PetSize Team Updated", 2)
                    
                end
                
                
            end
            is_value_selection_update = false
        end
    })
     
    
    GroupBoxEggPetSizeTeam:AddDivider()
    
    local ButtonPalceTeam1 = GroupBoxEggPetSizeTeam:AddButton({
        Text = "✅ Equip",
        Func = function() 
            if #FSettings.team4 == 0 then
                Library:Notify("Team is empty", 2)
            else
                EquipPets(FSettings.team4)
            end
            
        end 
    })
    
    -- Unequip
    ButtonPalceTeam1:AddButton({
        Text = "❌ Unequip All",
        Func = function()
            UnEquipAllPets()
            UpdatePetData()
        end
    })
    
    
    local ToggleTeam4Disable = GroupBoxEggPetSizeTeam:AddToggle("ToggleTeam4Disable", {
        Text = "Disable Team 1?",
        Default = FSettings.disable_team4,
        Tooltip = "Disabled teams won't be used.",
        Callback = function(Value)
            FSettings.disable_team4 = Value
            if Value then
                SaveData()
                Library:Notify("Team4 disabled", 2)
            else
                SaveData()
                Library:Notify("Team4 Enabled", 2)
            end
            
        end
    })

    --============================  TEAM 4 END
    
    
    
     -- reset it and update and visuals
    UpdatePetData()
    UpdateUITeamCount()
    task.wait(0.1)
    is_value_selection_update = false
    
end

-- call it
PetTeamsUi();

-- End of Pets Team ==========================================================================



-- Egg Priority
local function MEggUi()
    -- Create the new "Eggs" Tab
    local max_order = 100
    local UIEggTab = Window:AddTab({
        Name = "Eggs Priority",
        Description = "Manage Egg hatching priority",
        Icon = "egg"
    })

    -- Create a groupbox to hold the egg settings
    local GroupBoxEggs = UIEggTab:AddLeftGroupbox("Egg Priority & Settings", "list-ordered")

    -- Add an informational label
    GroupBoxEggs:AddLabel({
        Text = "Enable or disable eggs and set their hatching priority. higher numbers are higher priority.",
        DoesWrap = true
    })
    GroupBoxEggs:AddDivider()

    -- 1. Create a temporary table to sort the eggs by their order for display
    local sortedEggs = {}
    -- Reference the array from FSettings now
    for name, data in pairs(FSettings.eggs_to_place_array) do
        table.insert(sortedEggs, {name = name, order = data.order})
    end

    table.sort(sortedEggs, function(a, b)
        return a.order > b.order
    end)
    
    -- 2. Loop through the sorted table to create the UI elements in order
    for _, eggInfo in ipairs(sortedEggs) do
        local eggName = eggInfo.name
        -- Get the initial data from the FSettings table
        local eggData = FSettings.eggs_to_place_array[eggName]

        -- Create a Toggle for enabling/disabling the egg and store it in a variable
        local eggToggle = GroupBoxEggs:AddToggle(eggName .. "_toggle", {
            Text = eggName,
            Default = eggData.enabled,
            Tooltip = "Enable/Disable hatching for " .. eggName,
            Callback = function(Value)
                -- Update the value directly in the FSettings table
                FSettings.eggs_to_place_array[eggName].enabled = Value
                SaveData() -- Save the settings
                Library:Notify(eggName .. (Value and " Enabled" or " Disabled"), 1)
            end
        })
        
        --[[
            NEW CHANGE: Check for and apply the custom color
        ]]
        if eggData.color then
            eggToggle.TextLabel.TextColor3 = eggData.color
        end

        -- Create a Slider to set the priority order
        GroupBoxEggs:AddSlider(eggName .. "_slider", {
            Text = "Priority Order [Higher = First]",
            Default = eggData.order,
            Min = 1,
            Max = max_order, -- Max priority is the total number of eggs
            Rounding = 0, -- Use whole numbers for priority
            Callback = function(Value)
                -- Update the value directly in the FSettings table
                FSettings.eggs_to_place_array[eggName].order = Value
                SaveData() -- Save the settings
                --Library:Notify(eggName .. " priority set to " .. Value, 1)
            end
        })

        GroupBoxEggs:AddDivider()
    end
end

-- Call the new function to create the UI
MEggUi()
 





 
-- ===========================================================================================
-- Sell Settings UI (Reads directly from organized FSettings)
local function SellSettingsUi()
    local SellTab = Window:AddTab({
        Name = "Sell Settings",
        Description = "Configure pet selling",
        Icon = "coins"
    })

    local GroupBoxSell = SellTab:AddLeftGroupbox("Pet Sell List", "gavel")
    local GroupBoxSellWeight = SellTab:AddRightGroupbox("Pet Sell Weight", "weight")
    
    local weightValues = {
        "1", "2", "3", "4", "5", "6", "7", "8",
    }
    local DropdownSellWeight = GroupBoxSellWeight:AddDropdown("MyDropdown", {
        Values = weightValues,
        Default = FSettings.sell_weight, -- Index of the default option
        Multi = false, -- Whether to allow multiple selections
        Text = "Sells Or favourite Pets Above KG",
        Tooltip = "Select Kg, anything above will be kept",
        Callback = function(Value)
            print("Dropdown new value:", Value)
            FSettings.sell_weight = tonumber(Value) or 3
            SaveData()
            Library:Notify("Pet Weight Updated ", 2)
        end
    })
    
    
      -- Hatch mode sell
    -- local toggleHatchAgeModeReport = GroupBoxSellWeight:AddToggle("toggleHatchAgeModeReport", {
    --     Text = "Ostrich Mode",
    --     Default = FSettings.is_age_hatch_mode,
    --     Tooltip = "Sells everything under age of " .. FSettings.hatch_mode_age_to_keep,
    --     Callback = function(Value)
    --         FSettings.is_age_hatch_mode = Value
    --         print("Toggle changed to:", Value)
    --         SaveData()
    --         Library:Notify("Updated Hatch Mode", 3)
    --     end
    -- })
        
    
    GroupBoxSell:AddLabel({
        Text = "Enable (check) a pet to automatically sell it. Uncheck it to keep.",
        DoesWrap = true
    })

    -- To keep the UI order consistent, we'll get the egg names and sort them
    local sortedEggNames = {}
    for eggName, _ in pairs(FSettings.sell_pets) do
        table.insert(sortedEggNames, eggName)
    end
    table.sort(sortedEggNames)
    
    -- Loop through the sorted egg groups directly from FSettings
    for _, eggName in ipairs(sortedEggNames) do
        local petList = FSettings.sell_pets[eggName]

        -- Add the label to act as a header for the group
        GroupBoxSell:AddLabel({ Text = "--- 🥚 " .. eggName .. " ---", DoesWrap = false })
        
        -- To sort the pets within the group
        local sortedPetNames = {}
        for petName, _ in pairs(petList) do
            table.insert(sortedPetNames, petName)
        end
        table.sort(sortedPetNames)

        -- Now, loop through the sorted pets for this group and add their toggles
        for _, petName in ipairs(sortedPetNames) do
            GroupBoxSell:AddToggle(petName, {
                Text = petName,
                Default = petList[petName], -- Get current setting
                Callback = function(Value)
                    -- Update the setting in the correct group
                    FSettings.sell_pets[eggName][petName] = Value
                    -- And save the changes
                    SaveData()
                    Library:Notify("Updated " .. petName, 3)
                end
            })
        end
    end
end 
-- ===========================================================================================
-- End of Sell Settings UI
-- ===========================================================================================
 SellSettingsUi();



 


-- Events UI Function
local function MEventsUi()
    -- 1. Create the new "Events" Tab
    local UIEventsTab = Window:AddTab({
        Name = "Events",
        Description = "Manage and view game events",
        Icon = "calendar-heart" -- An icon that fits the theme
    })

    -- 2. Create groupboxes for organization
    local GroupBoxEventControls = UIEventsTab:AddLeftGroupbox("Event Controls", "toggle-left")
    
    UI_LABELS.lbl_fariystats = GroupBoxEventControls:AddLabel({
        Text = "Waiting for stats...", -- Initial placeholder text
        DoesWrap = true
    })
    
    GroupBoxEventControls:AddDivider()
    
    -- 3. Add your "Fairy Spam" toggle to the new groupbox
    GroupBoxEventControls:AddToggle("toggleFairy", {
        Text = "Fairy Spam",
        Default = FSettings.is_fairy_scanner_active,
        Tooltip = "Scans for and collects from Fairies",
        Callback = function(Value)
            FSettings.is_fairy_scanner_active = Value
            SaveData()
            Library:Notify("Fairy Scanner " .. (Value and "Enabled" or "Disabled"), 1)
        end
    })
    -- You can add other event-related toggles here in the future
    
    
    
    local GroupBoxAutoAscension = UIEventsTab:AddRightGroupbox("AutoAscension", "calendar-sync")
    GroupBoxAutoAscension:AddLabel({
        Text = "Auto Ascension: Plants, collects fruits, and claims Ascension for you.", 
        DoesWrap = true
    })
    
    UI_LABELS.lbl_ascenstats = GroupBoxAutoAscension:AddLabel({
        Text = "Current status", 
        DoesWrap = true
    })
    
    if FOtherSettings.auto_ascension then
        UpdateAscenStats("🟢 Ascension is active")
    else
        UpdateAscenStats("❌ Ascension not active")
    end
     
    GroupBoxAutoAscension:AddToggle("toogleAutoA", {
        Text = "Auto Ascension",
        Default = FOtherSettings.auto_ascension,
        Tooltip = "Scans for and collects from Fairies",
        Callback = function(Value)
            FOtherSettings.auto_ascension = Value
            SaveDataOther()
            Library:Notify("Auto Ascension " .. (Value and "Enabled" or "Disabled"), 1)
        end
    })
 
end

-- Call the function to build the UI
MEventsUi()



-- Create the UI for Mutation Settings
local function MMutationUi()
    -- Create the new "Mutations" Tab
    local UIMutationTab = Window:AddTab({
        Name = "Fruit Collection",
        Description = "Collect fruits with mutation lists",
        Icon = "list-checks" -- Using a lucide icon
    })

    ---------------------------------------------------
    -- ## Automation & Stats Groupboxes
    ---------------------------------------------------

    -- Automation Groupbox (Left)
    local AutomationGroup = UIMutationTab:AddLeftGroupbox("Automation", "bot")
    
    AutomationGroup:AddLabel({
        Text = "If backpack is full collection is automatically paused.",
        DoesWrap = true
    })
    
     
 
    local SeedDropdown = AutomationGroup:AddDropdown("SeedSelector", {
        Values = {},
        Default = {},
        Multi = true,
        Searchable = true,
        MaxVisibleDropdownItems = 10,
        Changed = function(newSelection)
            FOtherSettings.collection_plants = {}
            for key, value in pairs(newSelection) do
                FOtherSettings.collection_plants[key] = value
            end
              
            SaveDataOther()
        end
    })
    
    SeedDropdown:SetValues(GetKeyValuesFromList(all_plants_list))
    SeedDropdown:SetValue(FOtherSettings.collection_plants)
        
    AutomationGroup:AddToggle("collect_fruits_toggle", {
        Text = "Collect Fruits",
        Default = FOtherSettings.is_collect_fruit,
        Tooltip = "Automatically collect fruits when available.",
        Callback = function(Value)
            FOtherSettings.is_collect_fruit = Value
            --backpack_full=false
            SaveDataOther()
            local status = Value and " Started " or " Stopped"
            Library:Notify( status, 2.5)
            
            
        end
    })

    -- Stats Groupbox (Right)
    local StatsGroup = UIMutationTab:AddRightGroupbox("Live Stats", "line-chart")
    UI_LABELS.lbl_fruit_collect_live = StatsGroup:AddLabel({
        Text = "Status: Idle...",
        DoesWrap = true -- Allows the text to span multiple lines if needed
    })

    ---------------------------------------------------
    -- ## Whitelist Groupbox
    ---------------------------------------------------
    
    local WhitelistGroup = UIMutationTab:AddLeftGroupbox("Whitelist Settings", "check-square")
    WhitelistGroup:AddLabel({
        Text = "Fruits matching the selected mutations are collected, otherwise all fruits are collected.",
        DoesWrap = true
    })
    WhitelistGroup:AddDivider()

    -- 1. Get the mutations into a temporary table to be sorted
    local sortedWhitelist = {}
    for name, isEnabled in pairs(FOtherSettings.mutation_whitelist) do
        table.insert(sortedWhitelist, {name = name, enabled = isEnabled})
    end

    -- 2. Sort the table: enabled (true) mutations first, then alphabetically
    table.sort(sortedWhitelist, function(a, b)
        if a.enabled ~= b.enabled then
            return a.enabled -- This returns true if a.enabled is true and b.enabled is false
        end
        return a.name < b.name -- If both are the same, sort by name
    end)

    -- 3. Loop through the sorted mutations to create the toggles
    for _, mutationInfo in ipairs(sortedWhitelist) do
        WhitelistGroup:AddToggle(mutationInfo.name .. "_whitelist_toggle", {
            Text = mutationInfo.name,
            Default = mutationInfo.enabled,
            Tooltip = "Toggle whitelist status for " .. mutationInfo.name,
            Callback = function(Value)
                -- Update the value directly in the settings table
                FOtherSettings.mutation_whitelist[mutationInfo.name] = Value
                 SaveDataOther()
                
                -- Provide user feedback
                local status = Value and " added to" or " removed from"
                Library:Notify(mutationInfo.name .. status .. " whitelist", 1.5)
            end
        })
    end

    ---------------------------------------------------
    -- ## Blacklist Groupbox
    ---------------------------------------------------

    local BlacklistGroup = UIMutationTab:AddRightGroupbox("Blacklist Settings", "x-square")
    BlacklistGroup:AddLabel({
        Text = "Fruits carrying selected mutations will not be gathered.",
        DoesWrap = true
    })
    BlacklistGroup:AddDivider()

    -- 1. Get the mutations into a temporary table
    local sortedBlacklist = {}
    for name, isEnabled in pairs(FOtherSettings.mutation_blacklist) do
        table.insert(sortedBlacklist, {name = name, enabled = isEnabled})
    end

    -- 2. Sort the table: enabled (true) mutations first, then alphabetically
    table.sort(sortedBlacklist, function(a, b)
        if a.enabled ~= b.enabled then
            return a.enabled
        end
        return a.name < b.name
    end)

    -- 3. Loop through and create the toggles
    for _, mutationInfo in ipairs(sortedBlacklist) do
        BlacklistGroup:AddToggle(mutationInfo.name .. "_blacklist_toggle", {
            Text = mutationInfo.name,
            Default = mutationInfo.enabled,
            Tooltip = "Toggle blacklist status for " .. mutationInfo.name,
            Risky = true, -- Makes the text red, good for blacklists
            Callback = function(Value)
                -- Update the value directly in the settings table
                FOtherSettings.mutation_blacklist[mutationInfo.name] = Value
                SaveDataOther()

                -- Provide user feedback
                local status = Value and " added to" or " removed from"
                Library:Notify(mutationInfo.name .. status .. " blacklist", 1.5)
            end
        })
    end
end

-- Call the function to build the UI
MMutationUi()











-- Selling UI


-- Create the UI for Selling backpack etc
local function MSellUI()
    -- Create the new "Mutations" Tab
    local UISellTab = Window:AddTab({
        Name = "Selling",
        Description = "Sell fruits and more",
        Icon = "store" -- Using a lucide icon
    })

    ---------------------------------------------------
    -- ## GRoupboxes
    ---------------------------------------------------

    local AutomationGroup = UISellTab:AddLeftGroupbox("Backpack", "briefcase-business")

    AutomationGroup:AddLabel({
        Text = "Select how you want to sell from your backpack",
        DoesWrap = true
    })

    AutomationGroup:AddToggle("sell_backpack_toggle", {
        Text = "Auto Sell Backpack",
        Default = FOtherSettings.auto_sellbackpack,
        Tooltip = "Automatically sells backpack when full",
        Callback = function(Value)
            FOtherSettings.auto_sellbackpack = Value
            --backpack_full = false
            SaveDataOther()
            local status = Value and " Started " or " Stopped"
            Library:Notify(status, 2.5)
        end
    })



    local sellFruitList = AutomationGroup:AddDropdown("sellFruitList", {
        Values = {},
        Default = {},
        Multi = true,
        Searchable = true,
        MaxVisibleDropdownItems = 10,
        Text = "🍌 Sell Fruti",
        Tooltip = "Select fruit to sell. if nothing is selected it will sell all.",
        Changed = function(newSelection)
            FOtherSettings.sell_fruit_list = {}
            for key, value in pairs(newSelection) do
                FOtherSettings.sell_fruit_list[key] = value
            end

            SaveDataOther()
        end
    })

    local sellWhiteListMut = AutomationGroup:AddDropdown("sellWhiteListMut", {
        Values = {},
        Default = {},
        Multi = true,
        Searchable = true,
        MaxVisibleDropdownItems = 10,
        Text = "✅ Sell Selected Mutations",
        Tooltip = "Sells any mutations selected. if nothing is selected it will sell all.",
        Changed = function(newSelection)
            FOtherSettings.sell_mutation_whitelist = {}
            for key, value in pairs(newSelection) do
                FOtherSettings.sell_mutation_whitelist[key] = value
            end

            SaveDataOther()
        end
    })

    local sellBlackListMut = AutomationGroup:AddDropdown("sellBlackListMut", {
        Values = {},
        Default = {},
        Multi = true,
        Searchable = true,
        MaxVisibleDropdownItems = 10,
        Text = "❌ Don't Sell Selected Mutations",
        Tooltip = "Won't sell any selected mutations. if nothing is selected it will sell all.",
        Changed = function(newSelection)
            FOtherSettings.sell_mutation_blacklist = {}
            for key, value in pairs(newSelection) do
                FOtherSettings.sell_mutation_blacklist[key] = value
            end
              
            SaveDataOther()
        end
    })
    
    sellFruitList:SetValues(GetKeyMutListUsingDir(all_plants_list))
    sellFruitList:SetValue(FOtherSettings.sell_fruit_list);
    
    sellWhiteListMut:SetValues(GetKeyMutListUsingDir(list_mutations))
    sellWhiteListMut:SetValue(FOtherSettings.sell_mutation_whitelist)
    
    sellBlackListMut:SetValues(GetKeyMutListUsingDir(list_mutations))
    sellBlackListMut:SetValue(FOtherSettings.sell_mutation_blacklist)
         
end

-- Call the function to build the UI
MSellUI()


























--=========== Shops

-- Shops
function MShopUi()
    local UIShopTab = Window:AddTab({
        Name = "Shops",
        Description = "Shops",
        Icon = "store"
    })

    local GroupBoxWebhook = UIShopTab:AddLeftGroupbox("Shops", "link")
    local GroupBoxOtherSettings = UIShopTab:AddRightGroupbox("Shop Settings", "settings-2")
 
    -- info
     local lblinfo = GroupBoxWebhook:AddLabel({
        Text = "Buy shops? by default all shops will be purchased when active",
        DoesWrap = true
    })
    
    
    --======== Shops buttons 
    local btnShopGear = GroupBoxWebhook:AddToggle("btnShopGear", {
        Text = "Buy Gear Shop",
        Default = FSettings.buy_gearshop,
        Tooltip = "Enable Gear Shop",
        Callback = function(Value)
            FSettings.buy_gearshop = Value 
            SaveData()
            Library:Notify("Updated", 1)
        end
    })
    
    local btnShopSeed = GroupBoxWebhook:AddToggle("btnShopSeed", {
        Text = "Buy Seed Shop",
        Default = FSettings.buy_seedshop,
        Tooltip = "Enable Seed Shop",
        Callback = function(Value)
            FSettings.buy_seedshop = Value 
            SaveData()
            Library:Notify("Updated", 1)
        end
    })
    
    local btnShopEgg = GroupBoxWebhook:AddToggle("btnShopEgg", {
        Text = "Buy Egg Shop",
        Default = FSettings.buy_eggshop,
        Tooltip = "Enable Egg Shop",
        Callback = function(Value)
            FSettings.buy_eggshop = Value 
            SaveData()
            Library:Notify("Updated", 1)
        end
    })
    
    local btnMerShop = GroupBoxWebhook:AddToggle("btnMerShop", {
        Text = "Buy Merchant Shop",
        Default = FSettings.buy_merchant,
        Tooltip = "Buy All Merchant Shops",
        Callback = function(Value)
            FSettings.buy_merchant = Value 
            SaveData()
            Library:Notify("Updated", 1)
        end
    })


end

MShopUi();





-- Settings
function SettingsUi()
    local UISettingsTab = Window:AddTab({
        Name = "Settings",
        Description = "Settings",
        Icon = "settings"
    })

    local GroupBoxWebhook = UISettingsTab:AddLeftGroupbox("Webhook URL", "link")
    local GroupBoxOtherSettings = UISettingsTab:AddRightGroupbox("Other Settings", "settings-2")
    
    local GroupBoxApiSettings = UISettingsTab:AddRightGroupbox("Web API", "webhook")
    
    GroupBoxApiSettings:AddLabel({
        Text = "🌐 Log in to the website to get your API key. 🔑 Enter it here to sync your data 📊.",
        DoesWrap = true
    })
    
    GroupBoxApiSettings:AddInput("inputApiWeb", {
    Text = "Web API KEY",
    Default = FOtherSettings.web_api_key,
    Numeric = false,
    ClearTextOnFocus= false,
    Finished = false, -- Only calls callback when you press enter
    Placeholder = "API Key",
        Callback = function(Value)
            FOtherSettings.web_api_key = Value
            SaveDataOther()
            Library:Notify("Web API Key Updated", 3)
        end
    })
    
 
    -- webhook url
     local lbl_webhook_info = GroupBoxWebhook:AddLabel({
        Text = "Please enter your webhook url for discord",
        DoesWrap = true
    })
    
    
    --======== Other Settings
      -- Toggle Send Detailed Report Every Hatch
    local togHatchReport = GroupBoxOtherSettings:AddToggle("toggleBatchHatch", {
        Text = "Batch Hatching",
        Default = FSettings.is_hatch_in_batch,
        Tooltip = "Hatch when all eggs are ready.",
        Callback = function(Value)
            FSettings.is_hatch_in_batch = Value
            print("Toggle changed to:", Value)
            SaveData()
            Library:Notify("Updated", 3)
        end
    })
    
   
     -- Egg Esp
    local toggleEggView = GroupBoxOtherSettings:AddToggle("toggleEggView", {
        Text = "Egg Esp",
        Default = FSettings.is_egg_esp,
        Tooltip = "Show/Hide Egg Info",
        Callback = function(Value)
            FSettings.is_egg_esp = Value
            SaveData()
            Library:Notify("Updated", 3)
        end
    })
    
    
      -- PlayerStats
    GroupBoxOtherSettings:AddToggle("togglePlayerStats", {
        Text = "Player Stats",
        Default = FOtherSettings.is_playerstats_running,
        Tooltip = "Show/Hide Player Stats Ui",
        Callback = function(Value)
            FOtherSettings.is_playerstats_running = Value
            SaveDataOther()
            Library:Notify("Updated", 3)
        end
    })
    
    
    --======== WEbhook
    
    local InputWebhook = GroupBoxWebhook:AddInput("inputWebhook", {
    Text = "Webhook Url",
    Default = FSettings.webhook_url,
    Numeric = false,
    ClearTextOnFocus= false,
    Finished = false, -- Only calls callback when you press enter
    Placeholder = "Must start with https://",
        Callback = function(Value)
            FSettings.webhook_url = Value
            print("Input updated:", Value)
            SaveData()
            Library:Notify("Webhook saved", 3)
        end
    })
 
      -- Toggle Send Detailed Report Every Hatch
    local togHatchReport = GroupBoxWebhook:AddToggle("toggleDetailedHatchReport", {
        Text = "Detailed Hatch Report",
        Default = FSettings.send_everyhatch_alert,
        Tooltip = "Every hatch sends a report",
        Callback = function(Value)
            FSettings.send_everyhatch_alert = Value
            print("Toggle changed to:", Value)
            SaveData()
            Library:Notify("Updated Hatch Report", 3)
        end
    })
    
    -- Rare Hatch
    local togRareHatchReport = GroupBoxWebhook:AddToggle("toggleRareHatchReport", {
        Text = "Rare Hatch Report",
        Default = FSettings.send_rare_pet_alert,
        Tooltip = "When a rare pet is hatched",
        Callback = function(Value)
            FSettings.send_rare_pet_alert = Value
            print("Toggle changed to:", Value)
            SaveData()
            Library:Notify("Updated Rare Hatch Report", 3)
        end
    })
    
    -- Big Pet Hatch
    local togBigPetReport = GroupBoxWebhook:AddToggle("toggleBigPetHatchReport", {
        Text = "Big Pet Hatch Report",
        Default = FSettings.send_big_pet_alert,
        Tooltip = "When a big pet is hatched",
        Callback = function(Value)
            FSettings.send_big_pet_alert = Value
            print("Toggle changed to:", Value)
            SaveData()
            Library:Notify("Updated Big Pet Report", 3)
        end
    })
 
    -- Test webhook
   local ButtonTestWebHook = GroupBoxWebhook:AddButton({
        Text = "Send Test WebHook",
        Func = function() 
            SendErrorMessage("Test WebHook!")
            Library:Notify("Sent Test Webhook", 3)
        end 
    })
    
    -- reload pet teams
   local ButtonReloadPetTeam = GroupBoxWebhook:AddButton({
        Text = "Reload Pet Team",
        Func = function() 
             UpdatePetData()
            Library:Notify("Reloaded Pets", 1)
        end 
    })

end

SettingsUi()



 
-- icons name from lucide.dev, third is an optional description
 
--CheckAndSendTimedReports()

--auto start the rejoin if already started before #no auto start atm
if not main_thread and FSettings.is_running and FSettings.is_auto_rejoin then
    -- start the task here
    if FSettings.is_session_based then
        Library:Notify("Auto resume hatching in 10s", 7)
        local countx = 10;
        while countx > 0 do
            countx = countx - 1
            task.wait(1)
            
            if countx <= 1 then
                if main_thread then
                    break
                end
                main_thread = task.spawn(SessionLoop);
            end
        end
        
    end
    --main_thread = task.spawn(MainLoop);
end
