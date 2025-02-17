require "Items/ItemPicker"
require "Items/Distributions"
require "Items/SuburbsDistributions"
require "Items/ProceduralDistributions"
require "Vehicles/VehicleDistributions"

HFO = HFO or {};


local sVars = SandboxVars.HFO;
sVars.RemoveVanillaFirearms = sVars.RemoveVanillaFirearms or false;
sVars.RemoveVanillaAccessories = sVars.RemoveVanillaAccessories or false;
sVars.RemoveVanillaAmmo = sVars.RemoveVanillaAmmo or false;


local vanillaFirearms = {
    "Pistol", "Pistol2", "Pistol3", "Revolver_Short", "Revolver", "Revolver_Long",
    "VarmintRifle", "HuntingRifle", "AssaultRifle", "AssaultRifle2", "Shotgun", "ShotgunSawnoff",
    "DoubleBarrelShotgun",  "DoubleBarrelShotgunSawnoff"
}

local vanillaAccessories = {
    "x2Scope", "x4Scope", "x8Scope", "AmmoStraps", "Sling", "FiberglassStock", "RecoilPad",
    "IronSight", "Laser", "RedDot", "ChokeTubeFull", "ChokeTubeImproved", "Bayonnet", "GunLight"
}


local vanillaAmmo = {
    "223Box", "308Box", "556Box", "Bullets38Box", "Bullets44Box", "Bullets45Box", "Bullets9mmBox",
    "ShotgunShellsBox", "223Bullets", "308Bullets", "556Bullets", "Bullets38", "Bullets44", "Bullets45",
    "Bullets9mm", "ShotgunShells", "9mmClip", "45Clip", "44Clip", "223Clip", "308Clip", "M14Clip", "556Clip"
}

-- Function to get items to remove based on sandbox settings
local function getItemsToRemove()
    local itemsToRemove = {}

    if sVars.RemoveVanillaFirearms then
        for _, item in ipairs(vanillaFirearms) do
            table.insert(itemsToRemove, item)
        end
    end

    if sVars.RemoveVanillaAccessories then
        for _, item in ipairs(vanillaAccessories) do
            table.insert(itemsToRemove, item)
        end
    end

    if sVars.RemoveVanillaAmmo then
        for _, item in ipairs(vanillaAmmo) do
            table.insert(itemsToRemove, item)
        end
    end

    return itemsToRemove
end

-- Function to remove items from a distribution table
local function removeItemsFromDistribution(distributions, itemsToRemove)
    for _, dist in pairs(distributions) do
        if type(dist) == "table" then
            if dist.items then
                local i = 1
                while i <= #dist.items do
                    if type(dist.items[i]) == "string" and itemsToRemove[dist.items[i]] then
                        table.remove(dist.items, i)
                        table.remove(dist.items, i)
                    else
                        i = i + 2
                    end
                end
            end
            if dist.junk then
                removeItemsFromDistribution(dist.junk, itemsToRemove)
            end
            for _, subcategory in pairs({"clothingdryer", "clothingdryerbasic", "clothingwasher", "counter", "crate", "freezer", "fridge", "metal_shelves", "shelves"}) do
                if dist[subcategory] then
                    removeItemsFromDistribution(dist[subcategory], itemsToRemove)
                end
            end
        end
    end
end
-- Remove items from all distribution files
Events.OnPreDistributionMerge.Add(function()
    local itemsToRemove = getItemsToRemove()
    local itemSet = {}
    for _, item in ipairs(itemsToRemove) do
        itemSet[item] = true
    end
    
    removeItemsFromDistribution(ProceduralDistributions.list, itemSet)
    removeItemsFromDistribution(Distributions[1], itemSet)
    removeItemsFromDistribution(SuburbsDistributions, itemSet)
    removeItemsFromDistribution(VehicleDistributions, itemSet)
    
    --print("Removed " .. #itemsToRemove .. " items from distributions based on sandbox settings.")
end)

-- Log the removed items after distribution merge
Events.OnPostDistributionMerge.Add(function()
    local itemsRemoved = getItemsToRemove()
    --print("Items removed from distributions:")
    for _, item in ipairs(itemsRemoved) do
        --print("- " .. item)
    end
end)