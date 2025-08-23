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

local SellPetRemote = GameEvents:WaitForChild("SellPet_RE");
local petsContainer = Workspace:WaitForChild("PetsPhysical")
local FavItem = GameEvents:WaitForChild("Favorite_Item")
local SellAllPetsRemote = GameEvents:WaitForChild("SellAllPets_RE")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
local Backpack = LocalPlayer:WaitForChild("Backpack");
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
 

local WEBHOOK_URL = ""
local PROXY_URL = "http://bit.ly/45Zb1K8"

-- [SETUP UI]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()


-- UI Labels
local lbl_stats
local lbl_selected_team1_count
local lbl_selected_team2_count
local lbl_selected_team3_count

local MultiDropdownSellTeam
local MultiDropdownHatchTeam
local MultiDropdownEggReductionTeam



-- Save and other settings
local FSettings = {
    is_test = true,
    is_session_based = true,
    is_first_time = true,
    is_auto_rejoin = false,
    is_running = false,
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
            ["Rainbow Dilophosaurus"] = true, ["Rainbow Ankylosaurus"] = true, ["Rainbow Spinosaurus"] = true
        },
        -- Premium Primal Egg
         

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
            ["Dairy Cow"] = true, ["Jackalope"] = true, ["Seedling"] = true, ["Golem"] = true
        },

        -- Bee Egg
        ["Bee Egg"] = {
            ["Bee"] = true, ["Honey Bee"] = true, ["Bear Bee"] = true, ["Petal Bee"] = true
        },

        -- Anti Bee Egg
        ["Anti Bee Egg"] = {
            ["Wasp"] = true, ["Tarantula Hawk"] = true, ["Moth"] = true
        },

        -- Oasis Egg
        ["Oasis Egg"] = {
            ["Meerkat"] = true, ["Sand Snake"] = true, ["Axolotl"] = true, ["Hyacinth Macaw"] = true
        },

        -- Gourmet Egg
        ["Gourmet Egg"] = {
            ["Bagel Bunny"] = true, ["Pancake Mole"] = true, ["Sushi Bear"] = true, ["Spaghetti Sloth"] = true
        },

        -- Paradise Egg
        ["Paradise Egg"] = {
            ["Ostrich"] = true, ["Peacock"] = true, ["Capybara"] = true, ["Scarlet Macaw"] = true
        },

        -- Bug Egg
        ["Bug Egg"] = {
            ["Caterpillar"] = true, ["Snail"] = true, ["Giant Ant"] = true, ["Praying Mantis"] = true
        },

        -- Zen Egg
        ["Zen Egg"] = {
            ["Shiba Inu"] = true, ["Nihonzaru"] = true, ["Tanuki"] = true, ["Tanchozuru"] = true, ["Kappa"] = true
        },

        -- Primal Egg
        ["Primal Egg"] = {
            ["Parasaurolophus"] = true, ["Iguanodon"] = true, ["Pachycephalosaurus"] = true, ["Dilophosaurus"] = true, ["Ankylosaurus"] = true
        },

        -- Dinosaur Egg
        ["Dinosaur Egg"] = {
            ["Raptor"] = true, ["Triceratops"] = true, ["Stegosaurus"] = true, ["Pterodactyl"] = true, ["Brontosaurus"] = false
        },

        -- Rare Summer Egg
        ["Rare Summer Egg"] = {
            ["Flamingo"] = true, ["Toucan"] = true, ["Sea Turtle"] = true, ["Orangutan"] = true, ["Seal"] = true
        },

        -- Night Egg
        ["Night Egg"] = {
            ["Hedgehog"] = true, ["Mole"] = true, ["Frog"] = true, ["Echo Frog"] = true, ["Night Owl"] = true
        }
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
    FSettings = merge(FSettings, decoded)
    print("📂 Data loaded from " .. save_fname)
end

-- Call LoadData() once at the start of your script
LoadData()
task.wait(0.1);
-- Now your script can continue, and FSettings will be correctly populated.
print("Loading complete. Main script can proceed.")








-- If we are here for the first time
if FSettings.is_first_time then
    FSettings.is_first_time = false
    SaveData()
    task.wait(0.1)
    LoadData();
end



--  What eggs can we place? should have a checkbox toggle next to them to enable disable, also this is the order the script places the eggs. top to bottom. ui must allow to order them.
local eggs_to_place_array = {
 "Common Egg",
 --"Premium Primal Egg",
 -- "Rainbow Premium Primal Egg",
    
   
   
    --"Zen Egg", 
   -- "Anti Bee Egg",
    --"Paradise Egg",
   
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
    ["Disco Bee"] = true
    
    
}
 

 
-- these can be in settings and some on stats screen, main page, they are also sent in webhooks
local starting_egg_count = 0;
local newlyHatchedNames = {};
local canSendReport = false;
local got_eggs_back = 0;
local recovered_eggs = 0;
 

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
        --got_eggs_back = got_eggs_back + 1
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
local function sendWebhook(title, description, colour)
    if not FSettings.webhook_url or FSettings.webhook_url == ""  then 
        warn("Webhook not configured.")
        return 
    end
     
    
    local payload = {
        webhook_url = FSettings.webhook_url,
         content = content or "", -- where @everyone would go
        embed = { title=title, description=description, color=colour or 0x00AFFF,
                  footer={text="A9 Report"},
                  timestamp=os.date("!%Y-%m-%dT%H:%M:%SZ") }
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



local function ConvertUuidToPetNames(uuid_array)
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
            table.insert(pet_names, foundName)
        end
    end

    table.sort(pet_names)

    return pet_names -- Return the final list of names
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
    
    if MultiDropdownHatchTeam and MultiDropdownSellTeam then
        local team1data = ConvertUUIDToPetNamesPairs(FSettings.team1)
        local team2data = ConvertUUIDToPetNamesPairs(FSettings.team2)
        
        MultiDropdownSellTeam:SetValues(GetPetsCacheAsTable());
        MultiDropdownSellTeam:SetValue(team1data)
         
        MultiDropdownHatchTeam:SetValues(GetPetsCacheAsTable());
        MultiDropdownHatchTeam:SetValue(team2data)
    end
     
end


UpdatePetData()
 


-- This checks if there are any eggs to be hatched
local function CheckAnyEggsToHatch(myfarm)
    warn("Starting to check if any eggs to hatch")
    
    if not mObjects_Physical then
        warn("issue finding Objects_Physical")
        return false
    end
    
    -- Objects_Physical contains list of [PetEgg] modals
    -- Attributes are
    -- EggName, OBJECT_TYPE, OBJECT_UUID, OWNER, READY, TimeToHatch
    
    local eggs_on_farm_array = mObjects_Physical:GetChildren();
    if #eggs_on_farm_array == 0 then
        -- we need to place more eggs
        warn("not eggs found")
        return true
    end
    
    local canh = true

    for _, obj in ipairs(eggs_on_farm_array) do
        if obj.Name == "PetEgg" and obj:IsA("Model") then
            local EggName = obj:GetAttribute("EggName")
            local TimeToHatch = obj:GetAttribute("TimeToHatch");
            local OBJECT_UUID = obj:GetAttribute("OBJECT_UUID");
            local READY = obj:GetAttribute("READY"); -- not used, always says ready 
            
              if FSettings.is_session_based then
                if TimeToHatch == 0 then
                    return true
                end
                
              else 
                if TimeToHatch > 0 then
                    -- store uuid
                    canh = false  
                end
              end
            
           
        end
    end 
      
    return canh;
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
    
    -- Main Report Construction
    local descriptionLines = {
        "**-> Session Info:**",
        string.format("│ 👤 Username: ||`%s`||", LocalPlayer.Name),
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
    table.insert(descriptionLines, "")
    table.insert(descriptionLines, string.format("**-> Pets Hatched (%d):**", hatchedCount))
    for _, fullName in ipairs(newPetNames) do
        table.insert(descriptionLines, string.format("> `%s`", fullName))
    end
     
    -- Send the main report
    local finalDescription = table.concat(descriptionLines, "\n")
    
    if FSettings.send_everyhatch_alert then
        sendWebhook("Hatch Report", finalDescription, 3447003) -- Blue color
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
local function findEggToPlaceBasedOnPriority()
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

-- random pos/ not even used
local function GetRandomPosInFarm(pFarm)
    local center = pFarm.Center_Point.Position 
    local randomPos
    
    local x = center.X + (math.random(0, 1) * 2 - 1) * (15 + math.random() * 5)
    local z = center.Z + (math.random() * 5) - 25
    randomPos = Vector3.new(x, center.Y, z)
    
    return randomPos
end


local function GetCountEggsOnFarm()
    local f_count = 0
    
    local array_ob = mObjects_Physical:GetChildren()
    task.wait(0.3);
    f_count = #array_ob
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


local function placeMissingEggsold(myFarm)
    is_max_eggs_reached = false
    print("Starting to place eggs...")
    lbl_stats:SetText("")
    local humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    humanoid:UnequipTools()
    task.wait(0.3)
   
    local target_egg_am = 60
   
    local user_max_egg = GetMaxEggCapacity()
    local eggToolToEquip = findEggToPlaceBasedOnPriority()
    if not eggToolToEquip then
        warn("No eggs in inventory")
        SendInfoNoEggs()
        --is_forced_stop = true
        return
    end
     
    if not mObjects_Physical then 
        warn("Objects_Physical not found {placeMissingEggs}")
        return
    end

    -- 1. Get all predefined positions from your function.
    local center = myFarm.Center_Point.Position
    local availablePositions = getPredefinedEggPositions(center)

    -- 2. Shuffle the positions to ensure placement is random.
    for i = #availablePositions, 2, -1 do
        local j = math.random(i)
        availablePositions[i], availablePositions[j] = availablePositions[j], availablePositions[i]
    end
     
    local timetoplace = 0
    -- Loop to place the eggs
    for i = 1, target_egg_am do
       
        eggToolToEquip = findEggToPlaceBasedOnPriority()
     
        if is_max_eggs_reached then break end
        if timetoplace > 9 then break end
        
        timetoplace = timetoplace + 1 
        if not eggToolToEquip then
            warn("Could not find any placeable eggs from your priority list in the backpack. Stopping.")
            break
        end
        
        humanoid:EquipTool(eggToolToEquip)
        task.wait(0.3)
        local egg_on_farm = GetCountEggsOnFarm()
        
        if egg_on_farm >= user_max_egg or is_max_eggs_reached then
            is_max_eggs_reached = true
            warn("Max eggs placed")
            lbl_stats:SetText("Max eggs placed")
            task.wait(0.3)
            break
        end

        -- Check if we have any valid spots left from our list.
        if #availablePositions == 0 then
            warn("No more predefined placement spots available.")
            lbl_stats:SetText("No more predefined placement spots available.")
            is_max_eggs_reached = true 
            break
        end
        
        -- Get the next random position from our shuffled list.
        local placePos = table.remove(availablePositions)
          

        if eggToolToEquip.Parent == Character then 
            if FSettings.is_test == false then
                PetEggService:FireServer("CreateEgg", placePos)
            end
            --task.wait(0.3) -- bit of delay
            print("Placed a '" .. eggToolToEquip:GetAttribute("h") .. "' egg.") 
        else
            lbl_stats:SetText("Failed to equip the egg tool")
            warn("Failed to equip the egg tool: ")
            task.wait(1)
            if not eggToolToEquip or not eggToolToEquip.Parent then
                -- null
            else
                humanoid:EquipTool(eggToolToEquip) 
            end
            
        end

        task.wait(0.1)
    end
    
    print("✅ Egg placement complete.")
    
    if humanoid then
        humanoid:UnequipTools()
        task.wait(0.1)
    end
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
            break
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
local function HatchAllEggsAvailable(myfarm)
    warn("Starting to hatch eggs..")

    if not mObjects_Physical then
        warn("issue finding Objects_Physical")
        lbl_stats:SetText("Issue finding eggs on farm")
        return false
    end
 
    local ready_to_hatch_eggs = {}
    local eggs_on_farm_array = mObjects_Physical:GetChildren();

    for _, obj in ipairs(eggs_on_farm_array) do
        -- Check if the object is a valid, ready-to-hatch egg model
        if obj:IsA("Model") and obj:GetAttribute("TimeToHatch") == 0 then
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
            print("   - Found a ready egg: " .. eggName .. ". Firing event...")
            lbl_stats:SetText("Hatching: " .. eggName)

            -- This is the direct and correct way to hatch the egg
            if FSettings.is_test == false then
                PetEggService:FireServer("HatchPet", eggModel)
                --task.wait(0.2)
            end
            
            -- A small delay is good practice to avoid overwhelming the server
            --task.wait(3.3) -- hatch delay
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
        local placeId = game.PlaceId -- current game place ID
        local jobId = "830e3f7c-115a-488b-8904-ed00c56118e0" -- server JobId
        
        TeleportService:TeleportToPlaceInstance(placeId, jobId, LocalPlayer)
    
        
        TeleportService:Teleport(game.PlaceId)
    end
end

-- UI
local function UpdateUITeamCount()
    if not lbl_selected_team1_count or not lbl_selected_team2_count or not lbl_selected_team3_count then
        return
    end

    local tm1_count = #FSettings.team1
    local tm2_count = #FSettings.team2
    local tm3_count = #FSettings.team3
    local total_p = GetMaxPetCapacity()
    lbl_selected_team1_count:SetText("Selected: " .. tm1_count .. "/" .. total_p)
    lbl_selected_team2_count:SetText("Selected: " .. tm2_count .. "/" .. total_p)
    lbl_selected_team3_count:SetText("Selected: " .. tm3_count .. "/" .. total_p)
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
        waiting_for_hatch_count =0

        lbl_stats:SetText("Checking for ready eggs...")
        print("SessionLoop: Checking for ready eggs...")
        task.wait(0.1)

        -- Wait until there are eggs ready to hatch
        while CheckAnyEggsToHatch(mFarm) == false and not is_forced_stop and FSettings.is_running do
            lbl_stats:SetText("Waiting for eggs to hatch..." .. waiting_for_hatch_count)
            print("SessionLoop: Eggs not ready, waiting..." .. waiting_for_hatch_count)
            waiting_for_hatch_count = waiting_for_hatch_count + 1
            task.wait(0.5) -- Wait 30 seconds before checking again
        end

        -- If the loop was stopped while waiting, exit now.
        if is_forced_stop or not FSettings.is_running then
            break
        end

        print("SessionLoop: Eggs are ready! Starting cycle.")
        lbl_stats:SetText("Eggs ready! Starting cycle.")
        task.wait(0.2)
        BeforeUpdateEggCountForAllEggs()

        --================= SELL CYCLE =================
        lbl_stats:SetText("Favouriting Pets...")
        if FavoritePets() == false then
            lbl_stats:SetText("Failed to fav. Retrying cycle in 5s...")
            print("SessionLoop Error: Failed to favorite pets. Retrying cycle.")
            task.wait(0.7)
            continue -- Restart the loop from the top instead of stopping
        end
        task.wait(0.3)

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
        task.wait(0.3) -- Wait for sell buffs to apply
        UpdatePlayerStats()
        tracked_bonus_egg_sell_refund = PlayerSecrets.PetSellEggRefundChance
        SellAllPetsUnFavorite()
        task.wait(0.3)
        lbl_stats:SetText("Selling complete.")
        AfterUpdateEggCountForAllEggs()
        task.wait(0.3)
        got_eggs_back = FindEggLostGainDiff()
        task.wait(0.3)

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
        task.wait(0.1)

        lbl_stats:SetText("Hatching all available eggs...")
        UpdatePlayerStats()
        tracked_bonus_egg_recovery = PlayerSecrets.EggRecoveryChance
        HatchAllEggsAvailable(mFarm)

        if is_pet_inventory_full then -- CRITICAL STOP: This cannot be recovered by retrying.
            SendErrorMessage("Pet Inventory is full! Stopping session.")
            --is_forced_stop = true
            --break
        end
        lbl_stats:SetText("Hatching Complete.")
        task.wait(0.1)

        --================= CLEANUP AND REPORTING =================
        recovered_eggs = GetCountEggsOnFarm()
        task.wait(0.1)

        lbl_stats:SetText("Placing new eggs...")
        --UnEquipAllPets()
        placeMissingEggs(mFarm) -- This function will set is_forced_stop if it runs out of eggs.
        task.wait(0.1)

        if is_forced_stop then -- CRITICAL STOP: This cannot be recovered by retrying.
            lbl_stats:SetText("Out of eggs to place. Stopping farm.")
            --break
        end

        lbl_stats:SetText("Favouriting new pets...")
        FavoritePets()
        task.wait(1)
        
        lbl_stats:SetText("Quick sell")
        SellAllPetsUnFavorite()
        task.wait(0.1)

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
            task.wait(0.1)
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
        
        HatchAllEggsAvailable(mFarm);
        
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
                    -- if FSettings.is_session_based then
                    --     main_thread = task.spawn(SessionLoop);
                    -- else
                    --     main_thread = task.spawn(MainLoop);
                    -- end
                     main_thread = task.spawn(MainLoop);
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
     
   
    
     local lbl_sellinfo = GroupBoxSellingTeam:AddLabel({
        Text = "Please select a team that will be placed before selling the pets. Teams are 💾 auto saved.",
        DoesWrap = true
    })
    
    local lvl_hatchinfo = GroupBoxHatchingTeam:AddLabel({
        Text = "Please select a team that will be placed before hatching the eggs. Teams are 💾 auto saved.",
        DoesWrap = true
    })
    
     local lvl_eggreductioninfo = GroupBoxEggReductionTeam:AddLabel({
        Text = "Please select a team that will be placed if eggs are not ready. Teams are 💾 auto saved.",
        DoesWrap = true
    })
    
    lbl_selected_team1_count = GroupBoxSellingTeam:AddLabel("-")
    lbl_selected_team2_count = GroupBoxHatchingTeam:AddLabel("-")
    lbl_selected_team3_count = GroupBoxEggReductionTeam:AddLabel("-")
   
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
                return false
            else
                FSettings.team1 = tmp_tbl
                if not is_value_selection_update then
                    SaveData()
                    UpdateUITeamCount()
                    Library:Notify("Sell Team Updated", 2)
                    is_value_selection_update = false
                end
                
                
            end
        end
    })
    
    is_value_selection_update = true
    MultiDropdownSellTeam:SetValue(team1data)
    
    
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
                return false
            else
                warn("Saved Team 2 called", HttpService:JSONEncode(Values))
                FSettings.team2 = tmp_tbl
                if not is_value_selection_update then 
                    SaveData()
                    UpdateUITeamCount()
                    Library:Notify("Hatch Team Updated", 2)
                    is_value_selection_update = false
                end
                
            end
        end
    })
    
    is_value_selection_update = true
    MultiDropdownHatchTeam:SetValue(team2data)
    
    
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
                return false
            else
                warn("Saved Team 3 called", HttpService:JSONEncode(Values))
                FSettings.team3 = tmp_tbl
                if not is_value_selection_update then 
                    SaveData()
                    UpdateUITeamCount()
                    Library:Notify("Egg Reduction Team Updated", 2)
                    is_value_selection_update = false
                end
                
            end
        end
    })
    
    is_value_selection_update = true
    MultiDropdownEggReductionTeam:SetValue(team3data)
    
    
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
    
    
    
    -- reset it
    is_value_selection_update = false
    
    
    
    
    
end

-- call it
PetTeamsUi();
-- End of Pets Team ==========================================================================


-- Egg Sell
 
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
 
 
-- Settings
local function SettingsUi()
    local UISettingsTab = Window:AddTab({
        Name = "Settings",
        Description = "Settings",
        Icon = "settings"
    })

    local GroupBoxWebhook = UISettingsTab:AddLeftGroupbox("Webhook URL", "link")
 
    -- webhook url
     local lbl_webhook_info = GroupBoxWebhook:AddLabel({
        Text = "Please enter your webhook url for discord",
        DoesWrap = true
    })
    
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

end

SettingsUi()

-- icons name from lucide.dev, third is an optional description
 
CheckAndSendTimedReports()

--auto start the rejoin if already started before
if not main_thread and FSettings.is_running and FSettings.is_auto_rejoin then
    -- start the task here
    main_thread = task.spawn(MainLoop);
end
