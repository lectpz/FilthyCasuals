--fixme SandboxVars are default value at this stage, MP are loaded already OnPreDistributionMerge, SP are not

require 'Items/Distributions'
require 'Items/ProceduralDistributions'


local function registerAsLoot(item, chance, allocation)
  table.insert(ProceduralDistributions.list[allocation].items, item);
  table.insert(ProceduralDistributions.list[allocation].items, chance);
end

local iReg = "";

-- IBC
iReg = "Biofuel.EmptyNatoJerryCan";
registerAsLoot(iReg, 5.00, "CampingStoreGear");
registerAsLoot(iReg, 5.00, "ArmySurplusMisc");
registerAsLoot(iReg, 2.00, "CrateMechanics");
registerAsLoot(iReg, 1.00, "CrateRandomJunk");
registerAsLoot(iReg, 4.00, "ToolStoreFarming");
registerAsLoot(iReg, 10.00, "Homesteading");
registerAsLoot(iReg, 1.00, "GigamartFarming");
registerAsLoot(iReg, 3.00, "ArmyHangarTools");
registerAsLoot(iReg, 3.00, "MechanicSpecial");

iReg = "Biofuel.EmptyKeg";
registerAsLoot(iReg, 2.00, "BarCounterMisc");
registerAsLoot(iReg, 2.00, "StoreShelfBeer");
registerAsLoot(iReg, 2.00, "GigamartPots");
registerAsLoot(iReg, 0.50, "CrateCanning");
registerAsLoot(iReg, 10.00, "Homesteading");

iReg = "Biofuel.DistilleryManual";
registerAsLoot(iReg, 5.00, "BarCounterMisc");
registerAsLoot(iReg, 3.00, "StoreShelfBeer");
registerAsLoot(iReg, 3.00, "GigamartPots");
registerAsLoot(iReg, 2.00, "CrateCanning");
registerAsLoot(iReg, 10.00, "Homesteading");
registerAsLoot(iReg, 4.00, "MagazineRackMixed");

iReg = "Biofuel.KegofMoonshine";
registerAsLoot(iReg, 1.00, "Homesteading");

iReg = "Biofuel.JarofMoonshine";
registerAsLoot(iReg, 5.00, "Homesteading");
registerAsLoot(iReg, 0.50, "BarCounterLiquor");

iReg = "Biofuel.JarSieve";
registerAsLoot(iReg, 0.15, "Homesteading");
registerAsLoot(iReg, 0.05, "CrateRandomJunk");

iReg = "Biofuel.KegofBeer";
registerAsLoot(iReg, 8.00, "BarCounterLiquor");