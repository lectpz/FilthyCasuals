--[[
Logic for weight
5 pack = 5 * weight *                   0.7
10 pack = 10 * weight *                 0.5
5 pack with sheetrope = 5 * weight *    0.3
10 pack with sheetrope = 10 * weight *  0.25
5 pack with rope = 5 * weight * 0.2
10 pack with rope = 10 * weight * 0.15
also for Electronics Scrap, Rag, Denim, Leather:
10 pack = 10 * weight * 0.7
50 pack = 50 * weight * 0.6
100 pack = 100 * weight * 0.5
]]
local listToAdjust = {}
local function WeightAdjustment(itemName, baseItemName, amount, multiplier)
    local item = ScriptManager.instance:getItem(itemName)
    local baseItem = ScriptManager.instance:getItem(baseItemName)
    if item and baseItem then
        local baseItemWeight = baseItem:getActualWeight()
        local calculated = baseItemWeight * amount * multiplier
        item:DoParam("Weight = "..calculated)
    end

end
local function AdjustWeight(itemName, baseItemName, amount, multiplier)
    if not listToAdjust[itemName] then
        listToAdjust[itemName] = {};
    end
    if not listToAdjust[itemName][baseItemName] then
        listToAdjust[itemName][baseItemName] = {}
    end
    listToAdjust[itemName][baseItemName][amount] = multiplier;
end
local function Perform()
    for itemName,v in pairs(listToAdjust) do
        for baseItemName,y in pairs(v) do
            for amount,multiplier in pairs(y) do
                if pcall(WeightAdjustment(itemName,baseItemName,amount,multiplier)) then
                    print("Could not patch Item's ",itemName," Weight calculated from base item ",baseItemName," of amount",amount," multiplied by ", multiplier)
                end
            end
        end
    end
end

--add for every packed item: Name, BaseName,Amount,Multiplier. Scroll up for for multiplier
-- Generated AdjustWeight calls
AdjustWeight("SP.5pkAppleBagSeed", "PZGFarm.AppleBagSeed", 5, 0.7)
AdjustWeight("SP.10pkAppleBagSeed", "PZGFarm.AppleBagSeed", 10, 0.5)
AdjustWeight("SP.50pkAppleBagSeed", "PZGFarm.AppleBagSeed", 50, 0.5)
AdjustWeight("SP.100pkAppleBagSeed", "PZGFarm.AppleBagSeed", 100, 0.5)
AdjustWeight("SP.5pkAvocadoBagSeed", "PZGFarm.AvocadoBagSeed", 5, 0.7)
AdjustWeight("SP.10pkAvocadoBagSeed", "PZGFarm.AvocadoBagSeed", 10, 0.5)
AdjustWeight("SP.50pkAvocadoBagSeed", "PZGFarm.AvocadoBagSeed", 50, 0.5)
AdjustWeight("SP.100pkAvocadoBagSeed", "PZGFarm.AvocadoBagSeed", 100, 0.5)
AdjustWeight("SP.5pkBananaBagSeed", "PZGFarm.BananaBagSeed", 5, 0.7)
AdjustWeight("SP.10pkBananaBagSeed", "PZGFarm.BananaBagSeed", 10, 0.5)
AdjustWeight("SP.50pkBananaBagSeed", "PZGFarm.BananaBagSeed", 50, 0.5)
AdjustWeight("SP.100pkBananaBagSeed", "PZGFarm.BananaBagSeed", 100, 0.5)
AdjustWeight("SP.5pkBellpepperBagSeed", "PZGFarm.BellpepperBagSeed", 5, 0.7)
AdjustWeight("SP.10pkBellpepperBagSeed", "PZGFarm.BellpepperBagSeed", 10, 0.5)
AdjustWeight("SP.50pkBellpepperBagSeed", "PZGFarm.BellpepperBagSeed", 50, 0.5)
AdjustWeight("SP.100pkBellpepperBagSeed", "PZGFarm.BellpepperBagSeed", 100, 0.5)
AdjustWeight("SP.5pkBlackbeansBagSeed", "PZGFarm.BlackbeansBagSeed", 5, 0.7)
AdjustWeight("SP.10pkBlackbeansBagSeed", "PZGFarm.BlackbeansBagSeed", 10, 0.5)
AdjustWeight("SP.50pkBlackbeansBagSeed", "PZGFarm.BlackbeansBagSeed", 50, 0.5)
AdjustWeight("SP.100pkBlackbeansBagSeed", "PZGFarm.BlackbeansBagSeed", 100, 0.5)
AdjustWeight("SP.5pkBlackberryBagSeed", "PZGFarm.BlackberryBagSeed", 5, 0.7)
AdjustWeight("SP.10pkBlackberryBagSeed", "PZGFarm.BlackberryBagSeed", 10, 0.5)
AdjustWeight("SP.50pkBlackberryBagSeed", "PZGFarm.BlackberryBagSeed", 50, 0.5)
AdjustWeight("SP.100pkBlackberryBagSeed", "PZGFarm.BlackberryBagSeed", 100, 0.5)
AdjustWeight("SP.5pkBlueberryBagSeed", "PZGFarm.BlueberryBagSeed", 5, 0.7)
AdjustWeight("SP.10pkBlueberryBagSeed", "PZGFarm.BlueberryBagSeed", 10, 0.5)
AdjustWeight("SP.50pkBlueberryBagSeed", "PZGFarm.BlueberryBagSeed", 50, 0.5)
AdjustWeight("SP.100pkBlueberryBagSeed", "PZGFarm.BlueberryBagSeed", 100, 0.5)
AdjustWeight("SP.5pkCherryBagSeed", "PZGFarm.CherryBagSeed", 5, 0.7)
AdjustWeight("SP.10pkCherryBagSeed", "PZGFarm.CherryBagSeed", 10, 0.5)
AdjustWeight("SP.50pkCherryBagSeed", "PZGFarm.CherryBagSeed", 50, 0.5)
AdjustWeight("SP.100pkCherryBagSeed", "PZGFarm.CherryBagSeed", 100, 0.5)
AdjustWeight("SP.5pkCoconutBagSeed", "PZGFarm.CoconutBagSeed", 5, 0.7)
AdjustWeight("SP.10pkCoconutBagSeed", "PZGFarm.CoconutBagSeed", 10, 0.5)
AdjustWeight("SP.50pkCoconutBagSeed", "PZGFarm.CoconutBagSeed", 50, 0.5)
AdjustWeight("SP.100pkCoconutBagSeed", "PZGFarm.CoconutBagSeed", 100, 0.5)
AdjustWeight("SP.5pkCornBagSeed", "PZGFarm.CornBagSeed", 5, 0.7)
AdjustWeight("SP.10pkCornBagSeed", "PZGFarm.CornBagSeed", 10, 0.5)
AdjustWeight("SP.50pkCornBagSeed", "PZGFarm.CornBagSeed", 50, 0.5)
AdjustWeight("SP.100pkCornBagSeed", "PZGFarm.CornBagSeed", 100, 0.5)
AdjustWeight("SP.5pkCucumberBagSeed", "PZGFarm.CucumberBagSeed", 5, 0.7)
AdjustWeight("SP.10pkCucumberBagSeed", "PZGFarm.CucumberBagSeed", 10, 0.5)
AdjustWeight("SP.50pkCucumberBagSeed", "PZGFarm.CucumberBagSeed", 50, 0.5)
AdjustWeight("SP.100pkCucumberBagSeed", "PZGFarm.CucumberBagSeed", 100, 0.5)
AdjustWeight("SP.5pkDaikonBagSeed", "PZGFarm.DaikonBagSeed", 5, 0.7)
AdjustWeight("SP.10pkDaikonBagSeed", "PZGFarm.DaikonBagSeed", 10, 0.5)
AdjustWeight("SP.50pkDaikonBagSeed", "PZGFarm.DaikonBagSeed", 50, 0.5)
AdjustWeight("SP.100pkDaikonBagSeed", "PZGFarm.DaikonBagSeed", 100, 0.5)
AdjustWeight("SP.5pkEdamameBagSeed", "PZGFarm.EdamameBagSeed", 5, 0.7)
AdjustWeight("SP.10pkEdamameBagSeed", "PZGFarm.EdamameBagSeed", 10, 0.5)
AdjustWeight("SP.50pkEdamameBagSeed", "PZGFarm.EdamameBagSeed", 50, 0.5)
AdjustWeight("SP.100pkEdamameBagSeed", "PZGFarm.EdamameBagSeed", 100, 0.5)
AdjustWeight("SP.5pkEggplantBagSeed", "PZGFarm.EggplantBagSeed", 5, 0.7)
AdjustWeight("SP.10pkEggplantBagSeed", "PZGFarm.EggplantBagSeed", 10, 0.5)
AdjustWeight("SP.50pkEggplantBagSeed", "PZGFarm.EggplantBagSeed", 50, 0.5)
AdjustWeight("SP.100pkEggplantBagSeed", "PZGFarm.EggplantBagSeed", 100, 0.5)
AdjustWeight("SP.5pkGrapefruitBagSeed", "PZGFarm.GrapefruitBagSeed", 5, 0.7)
AdjustWeight("SP.10pkGrapefruitBagSeed", "PZGFarm.GrapefruitBagSeed", 10, 0.5)
AdjustWeight("SP.50pkGrapefruitBagSeed", "PZGFarm.GrapefruitBagSeed", 50, 0.5)
AdjustWeight("SP.100pkGrapefruitBagSeed", "PZGFarm.GrapefruitBagSeed", 100, 0.5)
AdjustWeight("SP.5pkGrapeBagSeed", "PZGFarm.GrapeBagSeed", 5, 0.7)
AdjustWeight("SP.10pkGrapeBagSeed", "PZGFarm.GrapeBagSeed", 10, 0.5)
AdjustWeight("SP.50pkGrapeBagSeed", "PZGFarm.GrapeBagSeed", 50, 0.5)
AdjustWeight("SP.100pkGrapeBagSeed", "PZGFarm.GrapeBagSeed", 100, 0.5)
AdjustWeight("SP.5pkPepperHabaneroBagSeed", "PZGFarm.PepperHabaneroBagSeed", 5, 0.7)
AdjustWeight("SP.10pkPepperHabaneroBagSeed", "PZGFarm.PepperHabaneroBagSeed", 10, 0.5)
AdjustWeight("SP.50pkPepperHabaneroBagSeed", "PZGFarm.PepperHabaneroBagSeed", 50, 0.5)
AdjustWeight("SP.100pkPepperHabaneroBagSeed", "PZGFarm.PepperHabaneroBagSeed", 100, 0.5)
AdjustWeight("SP.5pkPepperJalapenoBagSeed", "PZGFarm.PepperJalapenoBagSeed", 5, 0.7)
AdjustWeight("SP.10pkPepperJalapenoBagSeed", "PZGFarm.PepperJalapenoBagSeed", 10, 0.5)
AdjustWeight("SP.50pkPepperJalapenoBagSeed", "PZGFarm.PepperJalapenoBagSeed", 50, 0.5)
AdjustWeight("SP.100pkPepperJalapenoBagSeed", "PZGFarm.PepperJalapenoBagSeed", 100, 0.5)
AdjustWeight("SP.5pkLeekBagSeed", "PZGFarm.LeekBagSeed", 5, 0.7)
AdjustWeight("SP.10pkLeekBagSeed", "PZGFarm.LeekBagSeed", 10, 0.5)
AdjustWeight("SP.50pkLeekBagSeed", "PZGFarm.LeekBagSeed", 50, 0.5)
AdjustWeight("SP.100pkLeekBagSeed", "PZGFarm.LeekBagSeed", 100, 0.5)
AdjustWeight("SP.5pkLemonBagSeed", "PZGFarm.LemonBagSeed", 5, 0.7)
AdjustWeight("SP.10pkLemonBagSeed", "PZGFarm.LemonBagSeed", 10, 0.5)
AdjustWeight("SP.50pkLemonBagSeed", "PZGFarm.LemonBagSeed", 50, 0.5)
AdjustWeight("SP.100pkLemonBagSeed", "PZGFarm.LemonBagSeed", 100, 0.5)
AdjustWeight("SP.5pkLettuceBagSeed", "PZGFarm.LettuceBagSeed", 5, 0.7)
AdjustWeight("SP.10pkLettuceBagSeed", "PZGFarm.LettuceBagSeed", 10, 0.5)
AdjustWeight("SP.50pkLettuceBagSeed", "PZGFarm.LettuceBagSeed", 50, 0.5)
AdjustWeight("SP.100pkLettuceBagSeed", "PZGFarm.LettuceBagSeed", 100, 0.5)
AdjustWeight("SP.5pkLimeBagSeed", "PZGFarm.LimeBagSeed", 5, 0.7)
AdjustWeight("SP.10pkLimeBagSeed", "PZGFarm.LimeBagSeed", 10, 0.5)
AdjustWeight("SP.50pkLimeBagSeed", "PZGFarm.LimeBagSeed", 50, 0.5)
AdjustWeight("SP.100pkLimeBagSeed", "PZGFarm.LimeBagSeed", 100, 0.5)
AdjustWeight("SP.5pkMangoBagSeed", "PZGFarm.MangoBagSeed", 5, 0.7)
AdjustWeight("SP.10pkMangoBagSeed", "PZGFarm.MangoBagSeed", 10, 0.5)
AdjustWeight("SP.50pkMangoBagSeed", "PZGFarm.MangoBagSeed", 50, 0.5)
AdjustWeight("SP.100pkMangoBagSeed", "PZGFarm.MangoBagSeed", 100, 0.5)
AdjustWeight("SP.5pkOnionBagSeed", "PZGFarm.OnionBagSeed", 5, 0.7)
AdjustWeight("SP.10pkOnionBagSeed", "PZGFarm.OnionBagSeed", 10, 0.5)
AdjustWeight("SP.50pkOnionBagSeed", "PZGFarm.OnionBagSeed", 50, 0.5)
AdjustWeight("SP.100pkOnionBagSeed", "PZGFarm.OnionBagSeed", 100, 0.5)
AdjustWeight("SP.5pkOrangeBagSeed", "PZGFarm.OrangeBagSeed", 5, 0.7)
AdjustWeight("SP.10pkOrangeBagSeed", "PZGFarm.OrangeBagSeed", 10, 0.5)
AdjustWeight("SP.50pkOrangeBagSeed", "PZGFarm.OrangeBagSeed", 50, 0.5)
AdjustWeight("SP.100pkOrangeBagSeed", "PZGFarm.OrangeBagSeed", 100, 0.5)
AdjustWeight("SP.5pkPeachBagSeed", "PZGFarm.PeachBagSeed", 5, 0.7)
AdjustWeight("SP.10pkPeachBagSeed", "PZGFarm.PeachBagSeed", 10, 0.5)
AdjustWeight("SP.50pkPeachBagSeed", "PZGFarm.PeachBagSeed", 50, 0.5)
AdjustWeight("SP.100pkPeachBagSeed", "PZGFarm.PeachBagSeed", 100, 0.5)
AdjustWeight("SP.5pkPearBagSeed", "PZGFarm.PearBagSeed", 5, 0.7)
AdjustWeight("SP.10pkPearBagSeed", "PZGFarm.PearBagSeed", 10, 0.5)
AdjustWeight("SP.50pkPearBagSeed", "PZGFarm.PearBagSeed", 50, 0.5)
AdjustWeight("SP.100pkPearBagSeed", "PZGFarm.PearBagSeed", 100, 0.5)
AdjustWeight("SP.5pkPinePineappleBagSeed", "PZGFarm.PinePineappleBagSeed", 5, 0.7)
AdjustWeight("SP.10pkPinePineappleBagSeed", "PZGFarm.PinePineappleBagSeed", 10, 0.5)
AdjustWeight("SP.50pkPinePineappleBagSeed", "PZGFarm.PinePineappleBagSeed", 50, 0.5)
AdjustWeight("SP.100pkPinePineappleBagSeed", "PZGFarm.PinePineappleBagSeed", 100, 0.5)
AdjustWeight("SP.5pkPumpkinBagSeed", "PZGFarm.PumpkinBagSeed", 5, 0.7)
AdjustWeight("SP.10pkPumpkinBagSeed", "PZGFarm.PumpkinBagSeed", 10, 0.5)
AdjustWeight("SP.50pkPumpkinBagSeed", "PZGFarm.PumpkinBagSeed", 50, 0.5)
AdjustWeight("SP.100pkPumpkinBagSeed", "PZGFarm.PumpkinBagSeed", 100, 0.5)
AdjustWeight("SP.5pkSugarcaneBagSeed", "PZGFarm.SugarcaneBagSeed", 5, 0.7)
AdjustWeight("SP.10pkSugarcaneBagSeed", "PZGFarm.SugarcaneBagSeed", 10, 0.5)
AdjustWeight("SP.50pkSugarcaneBagSeed", "PZGFarm.SugarcaneBagSeed", 50, 0.5)
AdjustWeight("SP.100pkSugarcaneBagSeed", "PZGFarm.SugarcaneBagSeed", 100, 0.5)
AdjustWeight("SP.5pkWatermelonBagSeed", "PZGFarm.WatermelonBagSeed", 5, 0.7)
AdjustWeight("SP.10pkWatermelonBagSeed", "PZGFarm.WatermelonBagSeed", 10, 0.5)
AdjustWeight("SP.50pkWatermelonBagSeed", "PZGFarm.WatermelonBagSeed", 50, 0.5)
AdjustWeight("SP.100pkWatermelonBagSeed", "PZGFarm.WatermelonBagSeed", 100, 0.5)
AdjustWeight("SP.5pkWheatBagSeed", "PZGFarm.WheatBagSeed", 5, 0.7)
AdjustWeight("SP.10pkWheatBagSeed", "PZGFarm.WheatBagSeed", 10, 0.5)
AdjustWeight("SP.50pkWheatBagSeed", "PZGFarm.WheatBagSeed", 50, 0.5)
AdjustWeight("SP.100pkWheatBagSeed", "PZGFarm.WheatBagSeed", 100, 0.5)
AdjustWeight("SP.5pkZucchiniBagSeed", "PZGFarm.ZucchiniBagSeed", 5, 0.7)
AdjustWeight("SP.10pkZucchiniBagSeed", "PZGFarm.ZucchiniBagSeed", 10, 0.5)
AdjustWeight("SP.50pkZucchiniBagSeed", "PZGFarm.ZucchiniBagSeed", 50, 0.5)
AdjustWeight("SP.100pkZucchiniBagSeed", "PZGFarm.ZucchiniBagSeed", 100, 0.5)

Events.OnGameTimeLoaded.Add(Perform)