--[[
Open sourced cus it's basic asf
Be a good boy/girl and give credits :)
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("NINJA LEGENDS - NOXIOUS", "DarkTheme")

-- Tabs
local AutofarmTab = Window:NewTab("Autofarm")
local ClientTab = Window:NewTab("Local Player")
local PetsTab = Window:NewTab("Pets")
local ShopTab = Window:NewTab("Shop")

-- Sections
local AutofarmSection = AutofarmTab:NewSection("Autofarms")
local AutofarmConfigSection = AutofarmTab:NewSection("Config")

local HumanoidSection = ClientTab:NewSection("Humanoid")
local BypassSection = ClientTab:NewSection("Bypass")

local AutoHatchSection = PetsTab:NewSection("Auto Hatch")
local PetMiscSection = PetsTab:NewSection("Misc")

local AutoPurchaseSection = ShopTab:NewSection("Auto Purchase")
local PurchaseConfigSection = ShopTab:NewSection("Config")

-- Env
local Plr = game:GetService("Players").LocalPlayer
local NinjaEvent = Plr:FindFirstChild("ninjaEvent")

-- Globals
getgenv().AutoSwing = false
getgenv().AutoSell = false
getgenv().FarmHoops = false
getgenv().SwingDelay = "0.5"
getgenv().HoopDelay = "0.5"
getgenv().InfiniteJump = false
getgenv().AutoHatch = false
getgenv().CrystalToHatch = "Blue Crystal"
getgenv().AutoEvolve = false
getgenv().AutoSellPets = false
getgenv().PetToSell = nil
getgenv().AutoPurchaseSwords = false
getgenv().AutoPurchaseBelts = false
getgenv().AutoUpgradeSkills = false
getgenv().AutoPurchaseShurikens = false
getgenv().IslandToPurchaseFrom = "Ground"

-- Script
AutofarmSection:NewToggle("Auto Swing", "Automatically gains Ninjitsu.", function(state)
    if state then
        getgenv().AutoSwing = true

        while getgenv().AutoSwing do
            -- Equip Weapon
            pcall(function()
                local Weapon
                for i, Tool in pairs(Plr.Backpack:GetChildren()) do
                    if Tool:FindFirstChild("ninjitsuGain") then
                        Weapon = Tool
                    end
                end

                Plr.Character:FindFirstChildOfClass("Humanoid"):EquipTool(Weapon)
            end)

            NinjaEvent:FireServer("swingKatana")
            wait(tonumber(getgenv().SwingDelay))
        end
    else
        getgenv().AutoSwing = false
    end
end)

AutofarmSection:NewToggle("Auto Sell", "Automatically sells your Ninjitsu for coins.", function(state)
    if state then
        getgenv().AutoSell = true

        local CurrentNinjitsu = Plr.leaderstats.Ninjitsu
        local GroundBelts = game:GetService("ReplicatedStorage").Belts.Ground
        local CurrentBelt = Plr.equippedBelt.Value

        CurrentNinjitsu:GetPropertyChangedSignal("Value"):Connect(function()
            if CurrentNinjitsu.Value >= GroundBelts[CurrentBelt.Name].capacity.Value then
                local sellPart = game:GetService("Workspace").sellAreaCircles.sellAreaCircle.circleInner
                firetouchinterest(sellPart, Plr.Character.Head, 1)
                wait(0.5)
                firetouchinterest(sellPart, Plr.Character.Head, 0)
            end
        end)
    else
        getgenv().AutoSell = false
    end
end)

AutofarmSection:NewToggle("Farm Hoops", "Automatically collects hoops for coins.", function(state)
    if state then
        getgenv().FarmHoops = true

        while getgenv().FarmHoops do
            pcall(function()
                for i, hoop in pairs(game:GetService("Workspace").Hoops:GetChildren()) do
                    if getgenv().FarmHoops then
                        local args = {
                            [1] = "useHoop",
                            [2] = hoop
                        }

                        game:GetService("ReplicatedStorage").rEvents.hoopEvent:FireServer(unpack(args))

                        wait(tonumber(getgenv().HoopDelay))
                    end
                end
            end)
        end
    else
        getgenv().FarmHoops = false
    end
end)

AutofarmConfigSection:NewSlider("Swing Delay", "Milliseconds between swings.", 9, 0, function(s)
    getgenv().SwingDelay = "0." .. s
end)

AutofarmConfigSection:NewSlider("Hoop Delay", "Milliseconds between collecting hoops.", 9, 0, function(s)
    getgenv().HoopDelay = "0." .. s
end)


HumanoidSection:NewSlider("Walk Speed", "Changes the Walk Speed of your humanoid.", 500, 16, function(s)
    Plr.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = s
end)

HumanoidSection:NewSlider("Jump Power", "Changes the Jump Power of your humanoid.", 1000, 50, function(s)
    Plr.Character:FindFirstChildOfClass("Humanoid").JumpPower = s
end)

BypassSection:NewToggle("Infinite Jump", "Bypasses the Double Jump limit.", function(state)
    if state then
        getgenv().InfiniteJump = true

        function Action(Object, Function) if Object ~= nil then Function(Object); end end

        Plr.Character.multiJumpClientScript.Disabled = true
            
        game:GetService("UserInputService").InputBegan:connect(function(UserInput)
            if getgenv().InfiniteJump then
                if UserInput.UserInputType == Enum.UserInputType.Keyboard and UserInput.KeyCode == Enum.KeyCode.Space then
                    Action(Plr.Character.Humanoid, function(self)
                        if self:GetState() == Enum.HumanoidStateType.Jumping or self:GetState() == Enum.HumanoidStateType.Freefall then
                            Action(self.Parent.HumanoidRootPart, function(self)
                                self.Velocity = Vector3.new(0, 150, 0);
                            end)
                        end
                    end)
                end
            end
        end)
    else
        getgenv().InfiniteJump = false
        Plr.Character.multiJumpClientScript.Disabled = false
    end
end)

AutoHatchSection:NewToggle("Auto Hatch", "Auto Hatches Pets.", function(state)
    if state then
        getgenv().AutoHatch = true

        while getgenv().AutoHatch do
            pcall(function()
                local args = {
                    [1] = "openCrystal",
                    [2] = getgenv().CrystalToHatch
                }

                game:GetService("ReplicatedStorage").rEvents.openCrystalRemote:InvokeServer(unpack(args))
            end)
        end
    else
        getgenv().AutoHatch = false
    end
end)

AutoHatchSection:NewDropdown("Crystal", "Crystal to hatch pets from.", {"Blue Crystal", "Purple Crystal", "Enchanted Crystal", "Astral Crystal", "Golden Crystal", "Inferno Crystal", "Galaxy Crystal", "Frozen Crystal", "Eternal Crystal", "Storm Crystal", "Thunder Crystal", "Secret Blades Crystal", "Infinity Void Crystal"}, function(currentOption)
    getgenv().CrystalToHatch = currentOption
end)

PetMiscSection:NewToggle("Auto Evolve", "Automatically evolves your pets.", function(state)
    if state then
        getgenv().AutoEvolve = true

        while getgenv().AutoEvolve do
            pcall(function()
                for i, type in pairs(Plr.petsFolder:GetChildren()) do
                    for i2, pet in pairs(type:GetChildren()) do
                        game:GetService("ReplicatedStorage").rEvents.petNextEvolutionEvent:FireServer("evolvePet", pet, game:GetService("ReplicatedStorage").evolutionOrders.evolved)
                    end
                end
            end)

            wait(2)
        end
    else
        getgenv().AutoEvolve = false
    end
end)

PetMiscSection:NewToggle("Auto Sell Pets", "Automatically Sells the rarity of your choice.", function(state)
    if state then
        getgenv().AutoSellPets = true

        while getgenv().AutoSellPets do
            for i, pet in pairs(Plr.petsFolder[getgenv().PetToSell]:GetChildren()) do
                game:GetService("ReplicatedStorage").rEvents.sellPetEvent:FireServer("sellPet", pet)
            end

            wait(5)
        end
    else
        getgenv().AutoSellPets = false
    end
end)

PetMiscSection:NewDropdown("Pet To Sell", "Rarity of pets to automatically sell.", {"Basic", "Advanced", "Rare", "Epic", "Unique", "Omega", "Elite", "Infinity", "Awakened", "Master Legend", "BEAST", "Skystorm", "Soul Master", "Rising Hero", "Q-STRIKE", "Skyblade"}, function(currentOption)
    getgenv().PetToSell = currentOption
end)

AutoPurchaseSection:NewToggle("Auto Purchase Swords", "Automatically purchases the next sword.", function(state)
    if state then
        getgenv().AutoPurchaseSwords = true

        while getgenv().AutoPurchaseSwords do
            pcall(function()
                NinjaEvent:FireServer("buyAllSwords", getgenv().IslandToPurchaseFrom)
            end)

            wait(5)
        end
    else
        getgenv().AutoPurchaseSwords = false
    end
end)

AutoPurchaseSection:NewToggle("Auto Purchase Belts", "Automatically purchases the next belt.", function(state)
    if state then
        getgenv().AutoPurchaseBelts = true

        while getgenv().AutoPurchaseBelts do
            pcall(function()
                NinjaEvent:FireServer("buyAllBelts", getgenv().IslandToPurchaseFrom)
            end)

            wait(5)
        end
    else
        getgenv().AutoPurchaseBelts = false
    end
end)

AutoPurchaseSection:NewToggle("Auto Upgrade Skills", "Automatically upgrades to the next skill.", function(state)
    if state then
        getgenv().AutoUpgradeSkills = true

        while getgenv().AutoUpgradeSkills do
            pcall(function()
                NinjaEvent:FireServer("buyAllSkills", getgenv().IslandToPurchaseFrom)
            end)

            wait(5)
        end
    else
        getgenv().AutoUpgradeSkills = false
    end
end)

AutoPurchaseSection:NewToggle("Auto Purchase Shurikens", "Automatically purchases the next shuriken.", function(state)
    if state then
        getgenv().AutoPurchaseShurikens = true

        while getgenv().AutoPurchaseShurikens do
            pcall(function()
                NinjaEvent:FireServer("buyAllShurikens", getgenv().IslandToPurchaseFrom)
            end)

            wait(5)
        end
    else
        getgenv().AutoPurchaseShurikens = false
    end
end)

PurchaseConfigSection:NewDropdown("Island", "The island you want to set 'Auto Purchase' to.", {"Ground", "Astral Island", "Space Island", "Tundra Island", "Eternal Island", "Sandstorm", "Thunderstorm Island", "Ancient Inferno Island", "Midnight Shadow Island", "Mythical Souls Island", "Winter Wonder Island", "Golden Master Island", "Dragon Legend Island", "Cybernetic Legends Island", "Skystorm Ultraus Island", "Chaos Legends Island", "Soul Fusion Island", "Inner Peace Island", "Blazing Vortex Island"}, function(currentOption)
    getgenv().IslandToPurchaseFrom = currentOption
end)
