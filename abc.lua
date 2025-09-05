-- Wait for the game to be fully loaded
if not game:IsLoaded() then game.Loaded:Wait() end;
task.wait(1)

-- Get necessary game services and the local player
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents");
-- Define the paths to the remote event and pet container
local petsServiceRemote = GameEvents:WaitForChild("PetsService")
local PetEggService = GameEvents:WaitForChild("PetEggService")
local BuyGearStock = GameEvents.BuyGearStock -- RemoteEvent GearS
local BuySeedStock = GameEvents.BuySeedStock -- RemoteEvent SeedS
local BuyPetEgg = GameEvents.BuyPetEgg -- RemoteEvent PetShop
local BuyTravelingMerchantShopStock = GameEvents:WaitForChild("BuyTravelingMerchantShopStock") -- RemoteEvent PetShop

local SellPetRemote = GameEvents:WaitForChild("SellPet_RE");
local petsContainer = Workspace:WaitForChild("PetsPhysical")
local FavItem = GameEvents:WaitForChild("Favorite_Item")
local SellAllPetsRemote = GameEvents:WaitForChild("SellAllPets_RE")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
local Backpack = LocalPlayer:WaitForChild("Backpack");
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
 
local DataStream = GameEvents.DataStream -- RemoteEvent


local GearShopUI = PlayerGui:WaitForChild("Gear_Shop")
local SeedShopUI = PlayerGui:WaitForChild("Seed_Shop")
local PetShopUI = PlayerGui:WaitForChild("PetShop_UI")
local TravelingMerchantShop_UI = PlayerGui:WaitForChild("TravelingMerchantShop_UI")
 

local WEBHOOK_URL = ""
local PROXY_URL = "http://bit.ly/45Zb1K8"

-- [SETUP UI]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()


-- UI Labels
local lbl_stats
local lbl_fariystats
local lbl_selected_team1_count
local lbl_selected_team2_count
local lbl_selected_team3_count
local lbl_selected_team4_count

local MultiDropdownSellTeam
local MultiDropdownHatchTeam
local MultiDropdownEggReductionTeam
local MultiDropdownEggPetSizeTeam


-- Save and other settings
local FSettings = {
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
    webhook_url = WEBHOOK_URL,
    team1 = {},
    team2 = {},
    team3 = {}, -- added
    team4 = {}, -- added
    team5 = {}, -- added
    team6 = {}, -- added
    team7 = {}, -- added

    sell_pets = {
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
    }
}



-- Logs, contains all errors related logs, when something fails and saves and loads . maximum 100 log 
local logs = {}

local eggs_to_hatch_array = {
    ["Common Egg"] = true,
    ["Zen Egg"] = true,
    ["Primal Egg"] = true,
    ["Rare Summer Egg"] = true,
    ["Dinosaur Egg"] = true,
    ["Bug Egg"] = true,
    ["Paradise Egg"] = true,
    ["Gourmet Egg"] = true,
    ["Premium Night Egg"] = true,
}

-- pet data for esp
local found_pet_data = {}
-- stores big pets that we can't hatch
local big_pets_hatch_models = {}

local hatching_egg_name

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




local function getEggAmounts(name)
    local egg = egg_counts[name]
    if egg then
        return egg.current_amount, egg.new_amount
    end
    return 0, 0 -- or 0, 0 if you prefer default values
end

-- Function to update PlayerSecrets with safe checks
local function UpdatePlayerStats()
    if not LocalPlayer then
        warn("UpdatePlayerStats called without a valid LocalPlayer")
        return
    end

    for key, _ in pairs(PlayerSecrets) do
        local value = LocalPlayer:GetAttribute(key) -- safely try to get attribute
        if value ~= nil then
            PlayerSecrets[key] = value
        else
            PlayerSecrets[key] = 0 -- fallback default
        end
    end
end



-- Teleport buttons ingame
local function ShopTeleportButtons()
    local teleportFrame = LocalPlayer.PlayerGui.Teleport_UI.Frame
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
    ShopPurchaseLoop(SeedShopUI, "buy_seedshop", "seedshop_items", BuySeedStock, "SeedShopLoopRunning")
end)

-- GearShop
task.spawn(function()
    ShopPurchaseLoop(GearShopUI, "buy_gearshop", "gearshop_items", BuyGearStock, "GearShopLoopRunning")
end)

-- EggShop
task.spawn(function()
    ShopPurchaseLoop(PetShopUI, "buy_eggshop", "eggshop_items", BuyPetEgg, "EggShopLoopRunning")
end)


-- TravelingMerchant
task.spawn(function()
    ShopPurchaseLoop(TravelingMerchantShop_UI, "buy_merchant", "merchantshop_items", BuyTravelingMerchantShopStock, "MerchantShopLoopRunning")
end)


--======= END Shops



-- Saving loading
-- Saving and loading
local save_fname = "a_acssave_v15.json"


-- local function SaveData()
--  -- Encode table into JSON
--     --FSettings.team1 = {}
    
--     local json = HttpService:JSONEncode(FSettings) 
--     writefile(save_fname, json)
--     print(json)
--     print("✅ Data saved to " .. save_fname) 
-- end

-- local function LoadData()
--     print("loading saved data");
--     if isfile(save_fname) then
--         local json = readfile(save_fname)
--         if not json then return end
--         local decoded = HttpService:JSONDecode(json)
--         print(json) 
--         -- merge loaded values into defaults
--         for k,v in pairs(decoded) do
--             if FSettings[k] ~= nil then  -- only overwrite known keys
--                 FSettings[k] = v
--             end
--         end
--         print("📂 Data loaded from " .. save_fname)
--     else
--         print("⚠️ No save file found, using defaults")
--     end
-- end
 
-- -- load if we have any data
-- LoadData();
-- task.wait(0.1);
 

-- Saving and loading
local function SaveData()
    local success, json = pcall(function()
        return HttpService:JSONEncode(FSettings)
    end)

    if success then
        writefile(save_fname, json)
        print("✅ Data saved to " .. save_fname)
    else
        warn("❌ Error: Failed to encode settings to JSON. Data not saved.")
    end
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

    local success, decoded = pcall(HttpService.JSONDecode, HttpService, json)
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
task.wait(0.1);
-- Now your script can continue, and FSettings will be correctly populated.
print("Loading complete. Main script can proceed.")
shops_can_function = true -- shops can now function


 


-- If we are here for the first time
if FSettings.is_first_time then
    FSettings.is_first_time = false
    SaveData()
    task.wait(0.1)
    LoadData();
end



--  What eggs can we place? should have a checkbox toggle next to them to enable disable, also this is the order the script places the eggs. top to bottom. ui must allow to order them.
local eggs_to_place_arrayx = {
  --"Anti Bee Egg",
   "Common Egg",
  "Enchanted Egg",
    "Paradise Egg",
 --"Common Egg",
 --"Premium Primal Egg",
 -- "Rainbow Premium Primal Egg",
    
   
   
    "Zen Egg", 
  
  
   
  --  "Night Egg",
 

  --  "Rare Egg",
-- "Oasis Egg",

    --"Rare Summer Egg",


     --"Primal Egg",
     --"Dinosaur Egg",

   --"Gourmet Egg",
    --"Sprout Egg",
     --"Bee Egg",
    --"Bug Egg",
    --"Premium Night Egg",
   

}
 

--  these are pets. its only used to detect if we found and rare pet.
local rare_pets = {
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
local starting_egg_count = 0;
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
    for _,farm in ipairs(Workspace:WaitForChild("Farm"):GetChildren()) do
        local owner = farm:FindFirstChild("Important")
                      and farm.Important:FindFirstChild("Data")
                      and farm.Important.Data:FindFirstChild("Owner")
        if owner and owner:IsA("StringValue") and owner.Value == LocalPlayer.Name then
            return farm
        end
    end
    warn("Farm not found for "..LocalPlayer.Name)
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
task.wait(0.3)
if not mObjects_Physical then
    warn("Not found mObjects_Physical")
    return
end




-- ================ EGG SYSTEM

_G.EggDataStreamListener = DataStream.OnClientEvent:Connect(function(action, profileName, data)
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
        found_pet_data[uuid] = {petname= info.Type, weight =info.BaseWeight }
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
        warn("dont have pet ui info for this.")
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

    for i = #gc, math.floor(#gc * 0.5), -1 do
        if not next(uuidsToFind) then break end
        local obj = gc[i]
        if typeof(obj) == "table" then
            for uuid in pairs(uuidsToFind) do
                for key, value in pairs(obj) do
                    if typeof(key) == "string" and key:find(uuid, 1, true) then
                        if typeof(value) == "table" and value.Data and value.Data.Type and value.Data.BaseWeight then
                            found_pet_data[uuid] = {petname= value.Data.Type, weight = value.Data.BaseWeight }
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
--print("GC scan complete. Found:", HttpService:JSONEncode(found_pet_data))
task.spawn(updateEggEspUi)


--======= EGG SYSTEM




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
        if not lbl_fariystats then
            print("null lbl_stats")
            continue
        end
        
        print("🔍 Fairy scanning " .. scan_amount)
        lbl_fariystats:SetText("🔍 Fairy scanning " .. scan_amount)
 
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

                    --fireproximityprompt(prompt)
                    -- fire 5 times
                    for j = 1, 2 do
                        task.spawn(function()
                            spProxi(prompt)
                        end)
                    end

                    if fspam % 20 == 0 then
                        print("⚡ Spamming fairy (" .. fspam .. " times for this fairy, " .. total_spams .. " total)")
                        lbl_fariystats:SetText("⚡ Spamming fairy")
                    end
                    
                    task.wait(0.5)
                end
                scan_amount = 0
                print("❌ Fairy disappeared after")
                lbl_fariystats:SetText("❌ Fairy disappeared after")
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
    local amountLabel = Players.LocalPlayer.PlayerGui.Shop_UI.Frame.ScrollingFrame.PetProducts.List.EggSlot.Amount
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
    
    return max_eggs
end



local function GetMaxPetCapacity()
    -- Get the UI element that displays the pet count
    local titleLabel = Players.LocalPlayer.PlayerGui.ActivePetUI.Frame.Main.Holder.Header.Title
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
    local farmFolder = Workspace:FindFirstChild("Farm")
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

-- Populate trackedPets initially with existing tools
for _, item in ipairs(Backpack:GetChildren()) do
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
                    print("✅ New hatch!:", item.Name, "UUID:", petUUID)
                end
            end
        end
    end

    Backpack.ChildAdded:Connect(onChildAdded)
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
        return LocalPlayer.PlayerGui.Version_UI.Version
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
                  footer={text="A9 Report"},
                  timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ") },
        db = db_datax,
    }
     
    
    pcall(function()
        local body = HttpService:JSONEncode(payload)
        local req  = (syn and syn.request) or request
        if req then
            req({Url=PROXY_URL,Method="POST",
                 Headers={["Content-Type"]="application/json"},
                 Body=body})
        else
            HttpService:PostAsync(PROXY_URL, body)
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
    local contiems = petsContainer:GetChildren()
    for _, pet in ipairs(contiems) do
        if pet and pet:GetAttribute("OWNER") == LocalPlayer.Name then
            local uuidx = pet:GetAttribute("UUID")
            if uuidx then
                petCache[uuidx] = "Active PET " ..uuidx
            end
        end
    end
    
    -- Scan the backpack and populate the new cache.
    local b_ar = Backpack:GetChildren()
    for _, item in ipairs(b_ar) do
        if item:IsA("Tool") and item:GetAttribute("ItemType") == "Pet" then
            local uuid = item:GetAttribute("PET_UUID")
            if uuid then
                petCache[uuid] = "" .. item.Name .. " " .. uuid
            end
        end
    end

    if MultiDropdownHatchTeam and MultiDropdownSellTeam and MultiDropdownEggReductionTeam and MultiDropdownEggPetSizeTeam then
        local team1data = ConvertUUIDToPetNamesPairs(FSettings.team1)
        local team2data = ConvertUUIDToPetNamesPairs(FSettings.team2)
        local team3data = ConvertUUIDToPetNamesPairs(FSettings.team3)
        local team4data = ConvertUUIDToPetNamesPairs(FSettings.team4)
        
        is_value_selection_update = true
        MultiDropdownSellTeam:SetValues(GetPetsCacheAsTable());
        MultiDropdownSellTeam:SetValue(team1data)
         
        is_value_selection_update = true
        MultiDropdownHatchTeam:SetValues(GetPetsCacheAsTable());
        MultiDropdownHatchTeam:SetValue(team2data)
        
        is_value_selection_update = true
        MultiDropdownEggReductionTeam:SetValues(GetPetsCacheAsTable());
        MultiDropdownEggReductionTeam:SetValue(team3data)
        
        is_value_selection_update = true
        MultiDropdownEggPetSizeTeam:SetValues(GetPetsCacheAsTable());
        MultiDropdownEggPetSizeTeam:SetValue(team4data)
    end
     
end


UpdatePetData()
 


-- This checks if there are any eggs to be hatched
-- This checks if there are any eggs to be hatched (Corrected Logic)
local function CheckAnyEggsToHatch(myfarm)
    warn("Starting to check if any eggs to hatch")

    if not mObjects_Physical then
        warn("issue finding Objects_Physical")
        lbl_stats:SetText("CheckAnyEggsToHatch: not found Objects_Physical")
        task.wait(1)
        return false
    end

    local eggs_on_farm_array = mObjects_Physical:GetChildren()
    if #eggs_on_farm_array == 0 then
        warn("No eggs found on farm")
        lbl_stats:SetText("CheckAnyEggsToHatch: No eggs found on farm")
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
    
    -- Gather all the stats first
    local hatchedCount = #newPetNames
    local remainingEggs = GetEggCount(hatching_egg_name)
    local eggsUsed = starting_egg_count - remainingEggs
    local eggsSaved = hatchedCount - eggsUsed
     
     
    local _hatchbuff = string.format("%.2f", tracked_bonus_egg_recovery or 0)
    local _sellbuff = string.format("%.2f", tracked_bonus_egg_sell_refund or 0)
    
    local serverv = GetServerVersion()
    
    local hatch_player_uname = LocalPlayer.Name
    
    -- Main Report Construction
    local descriptionLines = {
        "**-> Session Info:**",
        string.format("│ 👤 Username: ||`%s`||", hatch_player_uname),
        string.format("│ 🥚 Hatching Egg: `%s (%s)`", hatching_egg_name, serverv),
        "", -- Blank line for spacing
        "**-> Stats:**",
        string.format("│ ✨ **Buffs** Sell: `%s%%` Hatch: `%s%%`", _sellbuff, _hatchbuff),
        string.format("│ ❤️ Favourited: `%d` 🎉 Hatched: `%d`", pets_fav_count or 0, hatchedCount or 0),
        string.format("│ 🥚 Eggs Used: `%d`", eggsUsed or 0),
        string.format("│ 💾 Eggs Saved: `%d`", eggsSaved or 0),
        string.format("│ 🎯 Starting Eggs: `%d`", starting_egg_count or 0),
        string.format("│ ⏳ Eggs Remaining: `%d`", remainingEggs or 0)
    }


    -- Conditionally add the "Lucky Events" section if they occurred
    if true then
        table.insert(descriptionLines, "")
        table.insert(descriptionLines, "**-> Lucky Events! 🍀**")
         
        table.insert(descriptionLines, string.format("│ 🥚 Lucky Pet: `+%d Eggs`", got_eggs_back))
        table.insert(descriptionLines, string.format("│ 🔄 Lucky Hatch: `+%d Eggs`", recovered_eggs))
        
    end

    -- Add the list of all hatched pets
    -- db pet list
    local hatchPetls = {} -- this used for storing data in db
    
    table.insert(descriptionLines, "")
    table.insert(descriptionLines, string.format("**-> Pets Hatched (%d):**", hatchedCount))
    for _, fullName in ipairs(newPetNames) do
        table.insert(descriptionLines, string.format("> `%s`", fullName))
        
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
    end
     
    -- Send the main report
    local finalDescription = table.concat(descriptionLines, "\n")

    --make data for storage
    local db_data = {
        pets_hatched = hatchPetls,
        serverversion = serverv,
        username = hatch_player_uname, 
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
            string.format("│ Username: ||`%s`||", LocalPlayer.Name),
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
            string.format("│ Username: ||`%s`||", LocalPlayer.Name),
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
        string.format("│ Username: ||`%s`||", LocalPlayer.Name),
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
        string.format("│ Username: ||`%s`||", LocalPlayer.Name),
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
        string.format("│ Username: ||`%s`||", LocalPlayer.Name),
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
        string.format("│ 👤 Username: ||`%s`||", LocalPlayer.Name),
    }
    sendWebhook("Timed Report (10 Min)", table.concat(descriptionLines, "\n"), 16776960) -- Yellow Color
end

local function send_hourly_report()
    local descriptionLines = {
        "**⏰ Hourly Stats Summary**", "",
        string.format("│ 🐣 Hatched this hour: `%d`", FSettings.eggs_hatched_in_hourly_session),
        string.format("│ 📈 Total Hatched (All Time): `%d`", FSettings.pets_hatched_total), "",
        string.format("│ 👤 Username: ||`%s`||", LocalPlayer.Name),
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
    -- 1. Check if the character is already holding the correct tool.
    local humanoid = Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        -- A character can only hold one tool at a time.
        local equippedTool = Character:FindFirstChildOfClass("Tool")
        
        -- Check if a tool is equipped AND if it's the right egg.
        if equippedTool and equippedTool:GetAttribute("h") == eggName then
            return equippedTool -- Found it! No need to search further.
        end
    end

    -- 2. If not equipped, search the player's backpack.
    for _, tool in ipairs(Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool:GetAttribute("h") == eggName then
            return tool -- Found it in the backpack.
        end
    end
    
    -- 3. If we've checked everywhere and found nothing, return nil.
    return nil
end

-- Get egg count, coutns passed in egg name
function GetEggCount(eggName)
    local egg_ar = Backpack:GetChildren();
    for _, item in ipairs(egg_ar) do
        if item:IsA("Tool") and item:GetAttribute("h") == eggName then
            local uses = item:GetAttribute("e") or 0
            return uses
        end
    end
    
    -- check if the user is holding the egg
    return 0
end

-- This will be called before to fill up egg counts
function BeforeUpdateEggCountForAllEggs()
    for eggName, data in pairs(egg_counts) do
        local current_countx = GetEggCount(eggName)
        data.current_amount = current_countx
    end
end

-- this called last to detect how many eggs we lost of gain
function AfterUpdateEggCountForAllEggs()
    for eggName, data in pairs(egg_counts) do
        local current_countx = GetEggCount(eggName)
        data.new_amount = current_countx
    end
end

-- call it right away
BeforeUpdateEggCountForAllEggs()

function FindEggLostGainDiff()
    local total_diff = 0

    for eggName, data in pairs(egg_counts) do
        local diff = data.new_amount - data.current_amount
        if diff > 0 then
            total_diff = total_diff + diff
        end 
    end

    return total_diff
end
 
-- finds egg to place, if no egg it will scan full list of egg array or stop if no eggs
local function findEggToPlaceBasedOnPriority_old()
    for _, eggName in ipairs(eggs_to_place_array) do
        local foundTool = findEggTool(eggName)
        if foundTool then 
            return foundTool 
        else
            warn(eggName.." not found, moving to next")
        end
    end
    
    return nil
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

 

local function placeMissingEggs(myFarm)
    print("Starting to place eggs...")
    lbl_stats:SetText("Starting to place eggs")
    local humanoid = Character:FindFirstChildOfClass("Humanoid")
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
            warn("Could not find any more placeable eggs. Stopping.")
            break
        end

        local egg_on_farm = GetCountEggsOnFarm()
        if egg_on_farm >= user_max_egg or is_max_eggs_reached then
            is_max_eggs_reached = true
            warn("Max eggs placed")
            lbl_stats:SetText("Max eggs placed")
            break
        end

        if #availablePositions == 0 then
            warn("No more predefined placement spots available.")
            lbl_stats:SetText("No more spots available.")
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

        if eggToolToEquip.Parent == Character then
            -- Success!
            if FSettings.is_test == false then
                PetEggService:FireServer("CreateEgg", placePos)
            end
            print("Placed a '" .. eggToolToEquip:GetAttribute("h") .. "' egg.")
        else
            -- Failure.
            lbl_stats:SetText("Failed to equip the egg tool")
            warn("Failed to equip the egg tool: " )
            task.wait(0.3)
            -- The loop will automatically try again with a fresh tool.
        end
    end

    print("✅ Egg placement complete.")
    if humanoid then
        humanoid:UnequipTools()
        task.wait(0.1)
    end
end



 -- Favorite pets
local function FavoritePets()
    print("Starting Favourite Process...")
    lbl_stats:SetText("Starting Favourite Process...")
    
    
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
    local pets_inbg = Backpack:GetChildren()
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
        lbl_stats:SetText("No pets needed favouriting.")
        return true
    end

    print("Found " .. #petsToFav .. " pet(s) to favourite.")

    -- Fire requests
    for _, pet in ipairs(petsToFav) do
        print("Favouriting: " .. pet.Name)
        lbl_stats:SetText("Favouriting: " .. pet.Name)
        if FSettings.is_test == false then
            FavItem:FireServer(pet)
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
        lbl_stats:SetText("All pets successfully favourited!")
        return true
    end
end


 -- New sell all unfav pets
local function SellAllPetsUnFavorite()
    print("Sell All UnFav Process...")
    lbl_stats:SetText("Sell All UnFav Process...")
    if FSettings.is_test == false then
        SellAllPetsRemote:FireServer();
    end
    
    task.wait(1)
end

  

-- Helper function to check if a pet with a given UUID is still visible
local function IsPetStillActiveInContainer(uuid)
    local contiems = petsContainer:GetChildren()
    for _, pet in ipairs(contiems) do
        if pet:GetAttribute("UUID") == uuid and pet:GetAttribute("OWNER") == LocalPlayer.Name then
            return true -- Yes, it's still here
        end
    end
    return false -- No, it's gone
end

-- The main function
local function UnEquipAllPets()
    print("Scanning for active pets...")
    local petsToConfirm = {} -- A list to track the UUIDs we are unequipping
    local petsarray = petsContainer:GetChildren()
    -- STEP 1: Fire all unequip requests in a rapid burst
    for _, petmoverpart in ipairs(petsarray) do
        if petmoverpart:IsA("Part") and petmoverpart:GetAttribute("OWNER") == LocalPlayer.Name then
            local xuuid = petmoverpart:GetAttribute("UUID")
            if xuuid then
                -- Add the UUID to our tracking list
                table.insert(petsToConfirm, xuuid) 
                -- Fire the event for this pet
                petsServiceRemote:FireServer("UnequipPet", xuuid)
                task.wait(0.3)
            end
        end
    end

    -- If there's nothing to unequip, we're done
    if #petsToConfirm == 0 then
        print("No pets belonging to you were found.")
        return true
    end

    print("Sent " .. #petsToConfirm .. " unequip requests. Now waiting for confirmation...")

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
        print("✅ Success! All pets were confirmed as removed.")
        return true
    else
        -- failed to remove all pets. redo the process
        warn("⚠️ Timeout! Could not confirm removal for " .. #petsToConfirm .. " pets.")
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
        petsServiceRemote:FireServer("EquipPet", uuid, placementCF); 
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
        lbl_stats:SetText("Issue finding eggs on farm")
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
            if not hatching_egg_name then
                hatching_egg_name = obj:GetAttribute("EggName")
            end
            table.insert(ready_to_hatch_eggs, obj)
        end
    end

    if hatching_egg_name then
        starting_egg_count = GetEggCount(hatching_egg_name)
    end

    local count_ready_eggs = #ready_to_hatch_eggs
    print("Ready to hatch eggs:", count_ready_eggs)
     
    -- New, more reliable hatching logic
    if count_ready_eggs > 0 then
        for _, eggModel in ipairs(ready_to_hatch_eggs) do
            local eggName = eggModel:GetAttribute("EggName") or "Unknown Egg"
            local uuid = eggModel:GetAttribute("OBJECT_UUID")
            print("   - Found a ready egg: " .. eggName .. ". Firing event...")
            lbl_stats:SetText("Hatching: " .. eggName)
            
            local can_hatch_this = true
            -- prevent egg hatching if this is a big or huge pet according to weight set
            local pet_data = found_pet_data[uuid]
            if pet_data and is_hatch_all == false then
                local _weight = pet_data.weight
                local _petname = pet_data.petname
                if _weight >= FSettings.sell_weight then
                    -- we can't hatch this egg.
                    can_hatch_this = false
                    lbl_stats:SetText("Cant hatch egg, weight is high," .. _petname)
                    -- add to the array
                    table.insert(big_pets_hatch_models,eggModel)
                    --task.wait(4)
                end
            end

            -- This is the direct and correct way to hatch the egg
            if FSettings.is_test == false then
                if can_hatch_this then
                    PetEggService:FireServer("HatchPet", eggModel)
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



-- rejoins the server to restart all over again.
local function rejoinS()
    if is_forced_stop == true then 
        warn("Forced to stop running...");
        return
    end
    warn("Rejoin...");
    if FSettings.is_test == false then  
        TeleportService:Teleport(game.PlaceId)
    end
end

-- UI
local function UpdateUITeamCount()
    if not lbl_selected_team1_count or not lbl_selected_team2_count or not lbl_selected_team3_count or not lbl_selected_team4_count then
        return
    end

    local tm1_count = #FSettings.team1
    local tm2_count = #FSettings.team2
    local tm3_count = #FSettings.team3
    local tm4_count = #FSettings.team4
    local total_p = GetMaxPetCapacity()
    lbl_selected_team1_count:SetText("Selected: " .. tm1_count .. "/" .. total_p)
    lbl_selected_team2_count:SetText("Selected: " .. tm2_count .. "/" .. total_p)
    lbl_selected_team3_count:SetText("Selected: " .. tm3_count .. "/" .. total_p)
    lbl_selected_team4_count:SetText("Selected: " .. tm4_count .. "/" .. total_p)
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
        hatching_egg_name = nil
        starting_egg_count = 0
        waiting_for_hatch_count = 0
        big_pets_hatch_models = {}

        lbl_stats:SetText("Checking for ready eggs...")
        print("SessionLoop: Checking for ready eggs...")
        task.wait(0.4)
        
        
        --========== Egg Timer Reduction Team
        
        local is_ready_hatch = CheckAnyEggsToHatch(mFarm)
        task.wait(0.5);
        local eggs_onfarm = GetCountEggsOnFarm()
        task.wait(0.5);
        lbl_stats:SetText("Check Egg Reduction Team for placement..." .. tostring(is_ready_hatch))
        
        if FSettings.disable_team3 == false then
            -- Place team only if eggs need reduction
            if is_ready_hatch == false then
                -- place team
                 lbl_stats:SetText("Placing egg reduction team..")
                if UnEquipAllPets() == false then
                    lbl_stats:SetText("[reduction team] Failed to unequip. Retrying cycle in 5s...")
                    print("reduction team Error: Failed to unequip pets. Retrying cycle.")
                    task.wait(5)
                    continue -- Restart the loop
                end
                lbl_stats:SetText("[T]Placing egg reduction team...")
                task.wait(0.3)
                if not EquipPets(FSettings.team3) then
                    lbl_stats:SetText("Team 3 failed. Retrying cycle in 5s...")
                    print("SessionLoop Error: Failed to place egg reduction team. Retrying cycle.")
                    task.wait(5)
                    continue -- Restart the loop
                end
            end
        end
        
        task.wait(3.5)

        -- Wait until there are eggs ready to hatch
        while CheckAnyEggsToHatch(mFarm) == false and not is_forced_stop and FSettings.is_running do
            lbl_stats:SetText("Waiting for eggs to hatch..." .. waiting_for_hatch_count)
            print("SessionLoop: Eggs not ready, waiting..." .. tostring(is_ready_hatch))
            waiting_for_hatch_count = waiting_for_hatch_count + 1
            task.wait(5) -- Wait 2 seconds before checking again
        end

        -- If the loop was stopped while waiting, exit now.
        if is_forced_stop or not FSettings.is_running then
            break
        end

        print("SessionLoop: Eggs are ready! Starting cycle.")
        lbl_stats:SetText("Eggs ready! Starting cycle.")
        task.wait(0.5)
        BeforeUpdateEggCountForAllEggs()
 
        --================= HATCH CYCLE =================
        -- Place Hatching Team (Team 2)
        if FSettings.disable_team2 == false then
            if UnEquipAllPets() == false then
                lbl_stats:SetText("Failed to unequip. Retrying cycle in 5s...")
                print("SessionLoop Error: Failed to unequip pets. Retrying cycle.")
                task.wait(5)
                continue -- Restart the loop
            end
            task.wait(0.2)
            lbl_stats:SetText("Placing hatching team...")
            if not EquipPets(FSettings.team2) then
                lbl_stats:SetText("Team 2 failed. Retrying cycle in 5s...")
                print("SessionLoop Error: Failed to place hatching team. Retrying cycle.")
                task.wait(5)
                continue -- Restart the loop
            end
        end

        lbl_stats:SetText("Waiting for hatch buffs...")
        task.wait(3.5)

        lbl_stats:SetText("Hatching all available eggs...")
        UpdatePlayerStats() 
        tracked_bonus_egg_recovery = PlayerSecrets.EggRecoveryChance
        HatchAllEggsAvailable(false) -- HATCH EGGS, provide false, we can't hatch big pets here

        if is_pet_inventory_full then -- CRITICAL STOP: This cannot be recovered by retrying.
            SendErrorMessage("Pet Inventory is full! Stopping session.")
            --is_forced_stop = true
            --break
        end
        lbl_stats:SetText("Hatching Complete.")
        task.wait(2)
        
        
        
        -- ============ BIG PET HATCH
        -- These pets can be hatched using pets that can increase size.
        if #big_pets_hatch_models > 0 then
            -- We have big pets to hatch
            
            -- place big pets hatching team here...
            -- Team 4 is big size pet team
            if FSettings.disable_team4 == false then 
                if UnEquipAllPets() == false then
                    lbl_stats:SetText("Failed to unequip. Retrying cycle in 5s...")
                    print("SessionLoop Error: Failed to unequip pets. Retrying cycle.")
                    task.wait(5)
                    continue -- Restart the loop
                end
                task.wait(0.2)
                lbl_stats:SetText("Placing pet size team...")
                if not EquipPets(FSettings.team4) then
                    lbl_stats:SetText("Team 4 failed. Retrying cycle in 5s...")
                    print("SessionLoop Error: Failed to place hatching team. Retrying cycle.")
                    task.wait(5)
                    continue -- Restart the loop
                end 
            end
            
          
            lbl_stats:SetText("Hatching big pets.");
            task.wait(3.9) -- wait for buffs
            UpdatePlayerStats() --  update the player stats so we know if buffs were applied etc
            pet_size_bonus = PlayerSecrets.PetEggHatchSizeBonus
            
            HatchAllEggsAvailable(true) -- set to true to hatch all eggs including big
            lbl_stats:SetText("Hatching Big Pets Complete.")
            task.wait(2) -- wait a bit after hatching
           
        end
        
        
 
         --================= SELL CYCLE =================
        lbl_stats:SetText("Favouriting Pets...")
        if FavoritePets() == false then
            lbl_stats:SetText("Failed to fav. Retrying cycle in 5s...")
            print("SessionLoop Error: Failed to favorite pets. Retrying cycle.")
            task.wait(0.7)
            continue -- Restart the loop from the top instead of stopping
        end
        task.wait(2)

        -- Place Selling Team (Team 1)
        if FSettings.disable_team1 == false then
            if UnEquipAllPets() == false then
                lbl_stats:SetText("Failed to unequip. Retrying cycle in 5s...")
                print("SessionLoop Error: Failed to unequip pets. Retrying cycle.")
                task.wait(5)
                continue -- Restart the loop
            end
            lbl_stats:SetText("Placing selling team...")
            if not EquipPets(FSettings.team1) then
                lbl_stats:SetText("Team 1 failed. Retrying cycle in 5s...")
                print("SessionLoop Error: Failed to place selling team. Retrying cycle.")
                task.wait(5)
                continue -- Restart the loop
            end
        end

        lbl_stats:SetText("Selling pets...")
        task.wait(6) -- Wait for sell buffs to apply
        UpdatePlayerStats()
        tracked_bonus_egg_sell_refund = PlayerSecrets.PetSellEggRefundChance
        SellAllPetsUnFavorite()
        task.wait(1)
        lbl_stats:SetText("Selling complete.")
        UpdatePetData()
        
        --================= CLEANUP AND REPORTING ================= 
        task.wait(0.4)

        lbl_stats:SetText("Placing new eggs...")
        --UnEquipAllPets()
        placeMissingEggs(mFarm) -- This function will set is_forced_stop if it runs out of eggs.
        task.wait(0.5)

        if is_forced_stop then -- CRITICAL STOP: This cannot be recovered by retrying.
            lbl_stats:SetText("Out of eggs to place. Stopping farm.")
            --break
        end  
        
        passive_pet_bonus = PlayerSecrets.PetPassiveBonus
       
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
            lbl_stats:SetText("Sending report...")
            HatchReport()
            task.wait(0.3)
        end

        lbl_stats:SetText("Cycle finished. Waiting for next batch.")
        print("SessionLoop: Cycle finished. Looping again.")
        task.wait(0.3) -- A brief pause before checking for ready eggs again

    end -- End of main while loop

    -- Cleanup code for when the loop is stopped
    lbl_stats:SetText("Session-based farm stopped.")
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

    
        print("Starting egg count: "..starting_egg_count)
        lbl_stats:SetText("Starting egg count")
        -- if no eggs to hatch then must rejoin. unless stopped in settings
        --  check if there are any eggs to even hatch?
        if CheckAnyEggsToHatch(mFarm) == false then
            -- no eggs to hatch, rejoin
            lbl_stats:SetText("No eggs to hatch.. rejoin")
            print("No eggs to hatch.. rejoin?")
            task.wait(2); -- wait in case user want to cancel
            rejoinS();
            break
        end
        
        task.wait(0.3)


        local serverv = GetServerVersion();
        if extractFirstNumber(serverv) > 1760 then
            --lbl_stats:SetText("Wrong server version.. rejoin") 
            --task.wait(2); -- wait in case user want to cancel
            --rejoinS();
            --break
        end



        

        --================= SELL 
        -- Fav any pets 
        lbl_stats:SetText("Favorite Pets")
        local is_fav_done = FavoritePets()
        if is_fav_done == false then
            lbl_stats:SetText("Failed to fav, rejoin.")
            task.wait(1);
            rejoinS();
            break
        end
        
        task.wait(1)
        
        -- Team 1 placement
        if FSettings.disable_team1 == false then 
            -- remove any pets equipped
            if UnEquipAllPets() == false then  rejoinS(); break end
            lbl_stats:SetText("UnEquip All Pets")
            task.wait(1);
            
            
            lbl_stats:SetText("Starting to place team 1")
            -- add team 1
            if EquipPets(FSettings.team1) then
                print("team 1 loaded")
                lbl_stats:SetText("team 1 loaded")
            else
                -- something went wrong. restart the process
                lbl_stats:SetText("team 1 failed to load")
                rejoinS();
                break
            end
        end
    
        
        
        -- start sell process, we can't sell unless team 1 is loaded
        lbl_stats:SetText("Start selling pets")
        task.wait(2) -- wait for buff to activate
        -- Track Bonus at this point
        UpdatePlayerStats()
        -- track what it was at this point
        tracked_bonus_egg_sell_refund = PlayerSecrets.PetSellEggRefundChance
        SellAllPetsUnFavorite()
        task.wait(0.3)
        lbl_stats:SetText("Selling complete.")
        AfterUpdateEggCountForAllEggs() -- update counts
        task.wait(1)
        got_eggs_back = FindEggLostGainDiff() -- This will let us track how many eggs we gain
        task.wait(1) -- await
        
        -- ========= END SELL
        
        
        
        
        -- Team 2 placement
        if FSettings.disable_team2 == false then
            -- add team 2
            lbl_stats:SetText("UnEquip All Pets.")
            if UnEquipAllPets() == false then rejoinS(); break end
            task.wait(0.2)
            lbl_stats:SetText("Starting to place team 2")
            if EquipPets(FSettings.team2) then
                lbl_stats:SetText("team 2 loaded")
                print("team 2 loaded")
            else
                -- something went wrong. restart the process
                lbl_stats:SetText("team 2 failed to load")
                rejoinS();
                return
            end
        end
    
        
        lbl_stats:SetText("Waiting...")
        task.wait(3.8); -- await .. wait for niho (incase its added), this pet can take time - leave this as is
 
        -- Hatch all eggs, we can't hatch unless team 2 is loaded 
        lbl_stats:SetText("Hatch All Eggs Available...")
        
      -- Track Bonus at this point
        UpdatePlayerStats()
        -- track what it was at this point
        tracked_bonus_egg_recovery = PlayerSecrets.EggRecoveryChance
        
        HatchAllEggsAvailable();
        
        if is_pet_inventory_full then
            SendErrorMessage("Pet Inventory is full!")
            task.wait(1)
        end
        lbl_stats:SetText("Hatch Complete...")
       
        task.wait(1);
        local recovered_eggs = GetCountEggsOnFarm()
        task.wait(0.3); -- await
        -- now place eggs
        lbl_stats:SetText("Placing new eggs.")
        UnEquipAllPets()
        placeMissingEggs(mFarm);
        task.wait(0.2)
       
        lbl_stats:SetText("Done Placing new eggs.")
        task.wait(0.3); -- await
        
        
        lbl_stats:SetText("Fav Pets")
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
            lbl_stats:SetText("Sending report")
            HatchReport();
            task.wait(2.5); -- await
        end
        lbl_stats:SetText("Rejoin...")
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
    Title = "A9 Hub",
    Footer = "v0.0.1",
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
    local MainTab = Window:AddTab({
        Name = "Home",
        Description = "Home",
        Icon = "house"
    })
    
    -- Add a groupbox to the left side
    local GroupAutoFarm = MainTab:AddLeftGroupbox("Auto Hatch", "calendar-sync")
    
    -- Text for stats
        lbl_stats = GroupAutoFarm:AddLabel({
        Text = "Stopped",
        DoesWrap = true
    })
    
    local StartAutoFarmButton = GroupAutoFarm:AddButton({
        Text = "Start Auto-Join Farm",
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
                lbl_stats:SetText("Stopped By User")
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
    
    lbl_selected_team1_count = GroupBoxSellingTeam:AddLabel("-")
    lbl_selected_team2_count = GroupBoxHatchingTeam:AddLabel("-")
    lbl_selected_team3_count = GroupBoxEggReductionTeam:AddLabel("-")
    lbl_selected_team4_count = GroupBoxEggPetSizeTeam:AddLabel("-")
   
    UpdateUITeamCount()
    
    -- Team 1 , selling team 
    local team1data = ConvertUUIDToPetNamesPairs(FSettings.team1)
    
    --- print("pets: ", HttpService:JSONEncode(petCache));
    print("team1: ", HttpService:JSONEncode(team1data));
    MultiDropdownSellTeam = GroupBoxSellingTeam:AddDropdown("dropdownSellTeam", {
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
    print("team2: ", HttpService:JSONEncode(team2data));
    MultiDropdownHatchTeam = GroupBoxHatchingTeam:AddDropdown("dropdownHatchTeam", {
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
                warn("Saved Team 2 called", HttpService:JSONEncode(Values))
                
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
    print("team3: ", HttpService:JSONEncode(team3data));
    MultiDropdownEggReductionTeam = GroupBoxEggReductionTeam:AddDropdown("dropdownEggReductionTeam", {
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
                --warn("Saved Team 3 called", HttpService:JSONEncode(Values))
                
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
    
    --- print("pets: ", HttpService:JSONEncode(petCache));
    -- print("team4: ", HttpService:JSONEncode(team4data));
    MultiDropdownEggPetSizeTeam = GroupBoxEggPetSizeTeam:AddDropdown("dropdownSellTeam", {
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
    local toggleHatchAgeModeReport = GroupBoxSellWeight:AddToggle("toggleHatchAgeModeReport", {
        Text = "Ostrich Mode",
        Default = FSettings.is_age_hatch_mode,
        Tooltip = "Sells everything under age of " .. FSettings.hatch_mode_age_to_keep,
        Callback = function(Value)
            FSettings.is_age_hatch_mode = Value
            print("Toggle changed to:", Value)
            SaveData()
            Library:Notify("Updated Hatch Mode", 3)
        end
    })
        
    
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







--[[
  At the top of your script (or somewhere accessible), declare a variable
  to hold the stats label object. This allows you to update it later.
]]



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
    
     lbl_fariystats = GroupBoxEventControls:AddLabel({
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
 
end

-- Call the function to build the UI
MEventsUi()


-- Settings
local function SettingsUi()
    local UISettingsTab = Window:AddTab({
        Name = "Settings",
        Description = "Settings",
        Icon = "settings"
    })

    local GroupBoxWebhook = UISettingsTab:AddLeftGroupbox("Webhook URL", "link")
    local GroupBoxOtherSettings = UISettingsTab:AddRightGroupbox("Other Settings", "settings-2")
 
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



--=========== Shops

-- Shops
local function MShopUi()
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




 
-- icons name from lucide.dev, third is an optional description
 
--CheckAndSendTimedReports()

--auto start the rejoin if already started before #no auto start atm
if not main_thread and FSettings.is_running and FSettings.is_auto_rejoin then
    -- start the task here
    if FSettings.is_session_based then
        
    end
    --main_thread = task.spawn(MainLoop);
end
