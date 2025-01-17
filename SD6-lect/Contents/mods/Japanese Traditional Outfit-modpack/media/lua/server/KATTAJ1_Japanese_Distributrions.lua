----------------------------------------------------------------------------
----------------------------- KATTAJ1 - TTAJ1bl4 ---------------------------
----------------------------------------------------------------------------

require "Items/ProceduralDistributions"


function KATTAJ1_Japanese_insertItemSetsIntoDistributions(itemSets, suffixes, spawnChances, distributionNames)
    local currentIndex = 1 

    for _, distributionName in ipairs(distributionNames) do
        local distribution = ProceduralDistributions.list[distributionName]

        for i, itemSet in ipairs(itemSets) do
            local baseItem = itemSet.baseItem
            local continuation = itemSet.continuation or ""

            for _, suffix in ipairs(suffixes) do
                local fullItem = "Base." .. baseItem .. suffix .. continuation

                local currentSpawnChance = spawnChances[currentIndex]
                currentIndex = (currentIndex % #spawnChances) + 1

                table.insert(distribution.items, fullItem)
                table.insert(distribution.items, currentSpawnChance)
            end
        end
    end
end


-- Sandbox affected
local commonSuffixes = {""} 

-- Sandbox Spawn Chances
    local spawnChancesClothingStores = {SandboxVars.KATTAJ1_Japanese.clothingStoresSpawnChances}
    local spawnChancesGunStores = {SandboxVars.KATTAJ1_Japanese.gunStoresSpawnChances}
    local spawnChanceLibraries = {SandboxVars.KATTAJ1_Japanese.librariesSpawnChances}

    local spawnChancesClothingStoresDyed = {SandboxVars.KATTAJ1_Japanese.clothingStoresSpawnChancesDyed}
    local spawnChancesGunStoresDyed = {SandboxVars.KATTAJ1_Japanese.gunStoresSpawnChancesDyed}
    local spawnChanceLibrariesDyed = {SandboxVars.KATTAJ1_Japanese.librariesSpawnChancesDyed}
 
-- Пулы мест, где могу звспавнится предметы 
local clothingStoresDistributions = {"ClothingStorageLegwear", "ClothingStoresJeans", "ClothingStoresDress","ClothingStoresJackets","ClothingStoresJacketsFormal","ClothingStoresJumpers","ClothingStoresOvershirts","ClothingStoresPants","ClothingStoresPantsFormal","ClothingStoresShirts","ClothingStoresShirtsFormal","ClothingStoresSport","ClothingStoresSummer","ClothingStorageAllJackets","ClothingStorageAllShirts"}
local gunStoresDistributions = {"GunStoreAmmunition", "GunStoreCounter","GunStoreShelf"} 
local librariesDistributions = {"LibraryCounter","BookstoreMisc","BookstoreStationery"} 

--[[
Japanese_Jacket_Overshirt-Black
Japanese_Jacket_Undershirt-Beige
Japanese_Belt-White
Japanese_Pants_Hakama-Brown
Japanese_Socks-Black
Japanese_Shoes_Sandals-Straw

local gunStoresDistributions = {"GunStoreAmmunition", "GunStoreCounter", "GunStoreDisplayCase","GunStoreMagazineRack","GunStoreShelf"} 
local librariesDistributions = {"LibraryBooks", "LibraryCounter","BookstoreMisc","BookstoreStationery","BookstoreBooks"} 
]]

--////////////////////////////////////////////////////// SETS ////////////////////////////////////////////////////// --
local itemSets = { 
    { baseItem = "Japanese_Jacket_Overshirt-Black" },    
    { baseItem = "Japanese_Jacket_Undershirt-Beige" }, 
    { baseItem = "Japanese_Belt-White" }, 
    { baseItem = "Japanese_Pants_Hakama-Brown" }, 
    { baseItem = "Japanese_Socks-Black" }, 
    { baseItem = "Japanese_Shoes_Sandals-Straw" }
} 

local itemSets1 = { 
    { baseItem = "Japanese_Jacket_Overshirt-Dyed" },      
    { baseItem = "Japanese_Jacket_Undershirt-Dyed" },   
    { baseItem = "Japanese_Belt-Dyed" }, 
    { baseItem = "Japanese_Pants_Hakama-Dyed" }, 
    { baseItem = "Japanese_Socks-Dyed" },  
    { baseItem = "Japanese_Shoes_Sandals-Dyed" }
}   

local function OnPreDistributionMerge()

    local spawnChancesClothingStores = {SandboxVars.KATTAJ1_Japanese.clothingStoresSpawnChances}
    local spawnChancesGunStores = {SandboxVars.KATTAJ1_Japanese.gunStoresSpawnChances}
    local spawnChanceLibraries = {SandboxVars.KATTAJ1_Japanese.librariesSpawnChances}

    local spawnChancesClothingStoresDyed = {SandboxVars.KATTAJ1_Japanese.clothingStoresSpawnChancesDyed}
    local spawnChancesGunStoresDyed = {SandboxVars.KATTAJ1_Japanese.gunStoresSpawnChancesDyed}
    local spawnChanceLibrariesDyed = {SandboxVars.KATTAJ1_Japanese.librariesSpawnChancesDyed}

	KATTAJ1_Japanese_insertItemSetsIntoDistributions(itemSets, commonSuffixes, spawnChancesClothingStores, clothingStoresDistributions)
	--KATTAJ1_Japanese_insertItemSetsIntoDistributions(itemSets, commonSuffixes, spawnChancesGunStores, gunStoresDistributions)
	--KATTAJ1_Japanese_insertItemSetsIntoDistributions(itemSets, commonSuffixes, spawnChanceLibraries, librariesDistributions)

	KATTAJ1_Japanese_insertItemSetsIntoDistributions(itemSets1, commonSuffixes, spawnChancesClothingStoresDyed, clothingStoresDistributions)
	--KATTAJ1_Japanese_insertItemSetsIntoDistributions(itemSets1, commonSuffixes, spawnChancesGunStoresDyed, gunStoresDistributions)
	--KATTAJ1_Japanese_insertItemSetsIntoDistributions(itemSets1, commonSuffixes, spawnChanceLibrariesDyed, librariesDistributions)

end

Events.OnPreDistributionMerge.Add(OnPreDistributionMerge)