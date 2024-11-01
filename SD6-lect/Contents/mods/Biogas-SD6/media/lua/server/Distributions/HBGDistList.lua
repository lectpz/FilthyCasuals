--fixme SandboxVars are default value at this stage, MP are loaded already OnPreDistributionMerge, SP are not

require 'Items/Distributions'
require 'Items/ProceduralDistributions'


local function registerAsLoot(item, chance, allocation)
  table.insert(ProceduralDistributions.list[allocation].items, item);
  table.insert(ProceduralDistributions.list[allocation].items, chance);
end

local iReg = "";

-- IBC
iReg = "Biofuel.IBCEmpty";
registerAsLoot(iReg, 1.00, "ArmyHangarTools");
registerAsLoot(iReg, 2.00, "ArmySurplusTools");
registerAsLoot(iReg, 4.00, "CrateFarming");
registerAsLoot(iReg, 2.00, "CrateTools");
registerAsLoot(iReg, 2.00, "CrateRandomJunk");
registerAsLoot(iReg, 2.00, "GardenStoreTools");
registerAsLoot(iReg, 1.50, "ToolStoreFarming");
registerAsLoot(iReg, 1.00, "ToolStoreMisc");
registerAsLoot(iReg, 5.00, "Homesteading");
registerAsLoot(iReg, 0.50, "MechanicSpecial");

iReg = "Biofuel.BioGasManual";
registerAsLoot(iReg, 1.00, "ArmyHangarTools");
registerAsLoot(iReg, 2.00, "ArmySurplusTools");
registerAsLoot(iReg, 4.50, "CrateFarming");
registerAsLoot(iReg, 1.00, "CrateRandomJunk");
registerAsLoot(iReg, 1.50, "GardenStoreTools");
registerAsLoot(iReg, 1.50, "ToolStoreFarming");
registerAsLoot(iReg, 1.00, "ToolStoreMisc");
registerAsLoot(iReg, 5.00, "Homesteading");
registerAsLoot(iReg, 0.50, "MechanicSpecial");
registerAsLoot(iReg, 1.00, "ShelfGeneric");
registerAsLoot(iReg, 4.00, "MagazineRackMixed");


iReg = "Biofuel.BacteriaStarter";
registerAsLoot(iReg, 4.00, "GigamartBakingMisc");
registerAsLoot(iReg, 2.00, "GigamartDryGoods");
registerAsLoot(iReg, 1.00, "GardenStoreMisc");
registerAsLoot(iReg, 2.00, "CrateCanning");
registerAsLoot(iReg, 3.00, "Homesteading");

--[[if SandboxVars.BioGas.spawnIndustrialTanks then
  iReg = "Biofuel.IndustrialPropaneTank";
  registerAsLoot(iReg, 2.0, "CrateMetalwork");
  registerAsLoot(iReg, 4.0, "CratePropane");
  registerAsLoot(iReg, 1.50, "MetalShopTools");
  registerAsLoot(iReg, .5, "ToolStoreMetalwork");
end]]