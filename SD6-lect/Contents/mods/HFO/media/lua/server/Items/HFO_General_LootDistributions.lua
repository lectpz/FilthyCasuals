require "Items/ItemPicker"
require "Items/Distributions"
require "Items/SuburbsDistributions"
require "Items/ProceduralDistributions"
require "Vehicles/VehicleDistributions"

HFO = HFO or {};

function HFO:addDistributions(itemsAndChances, locations)
	for item, chance in pairs(itemsAndChances)
	do
		for i, location in ipairs(locations)
		do
			if ProceduralDistributions.list[location] and ProceduralDistributions.list[location].items
			then
				table.insert(ProceduralDistributions.list[location].items, item);
				table.insert(ProceduralDistributions.list[location].items, chance);
			end
		end
	end
end

local function updateDistributionsHFO()
    local sVars = SandboxVars.HFO;
    sVars.Loot = sVars.Loot or 1;
    sVars.RemoveVanillaFirearms = sVars.RemoveVanillaFirearms or false;
    sVars.RemoveVanillaAccessories = sVars.RemoveVanillaAccessories or false;
    sVars.RemoveVanillaAmmo = sVars.RemoveVanillaAmmo or false;
    
    sVars.AddFirearms = sVars.AddFirearms or false;
    sVars.AddAccessories = sVars.AddAccessories or false;
    sVars.Cleaning = sVars.Cleaning or true;
    sVars.RepairKits = sVars.RepairKits or true;
    sVars.FirearmSkins = sVars.FirearmSkins or false;

    sVars.Firearms = sVars.Firearms or 2;
    sVars.FirearmsHandgunsRates = sVars.FirearmsHandgunsRates or 50;
    sVars.FirearmsRiflesRates = sVars.FirearmsRiflesRates or 50;
    sVars.FirearmsShotgunsRates = sVars.FirearmsShotgunsRates or 50;

    sVars.Ammo = sVars.Ammo or 2;
    sVars.AmmoHandgunsRates = sVars.AmmoHandgunsRates or 50;
    sVars.AmmoRiflesRates = sVars.AmmoRiflesRates or 50
    sVars.AmmoShotgunsRates = sVars.AmmoShotgunsRates or 50;

    sVars.Accessories = sVars.Accessories or 2;
    sVars.AccessoriesScopesRates = sVars.AccessoriesScopesRates or 30;
    sVars.AccessoriesOtherRates = sVars.AccessoriesOtherRates or 40;

    sVars.CleanRepairSpawns = sVars.CleanRepairSpawns or 3;
    sVars.FirearmSkinSpawns = sVars.FirearmSkinSpawns or 3;

    local firearmsHandgunsRates = sVars.Firearms * sVars.Loot * (sVars.FirearmsHandgunsRates / 50);
    local firearmsRiflesRates = sVars.Firearms * sVars.Loot * (sVars.FirearmsRiflesRates / 50);
    local firearmsShotgunsRates =  sVars.Firearms * sVars.Loot * (sVars.FirearmsShotgunsRates / 50);

    local ammoHandgunsRates = sVars.Ammo * sVars.Loot * (sVars.AmmoHandgunsRates / 50);
    local ammoRifleRates = sVars.Ammo * sVars.Loot * (sVars.AmmoRiflesRates / 50);
    local ammoShotgunRates = sVars.Ammo * sVars.Loot * (sVars.AmmoShotgunsRates / 50);

    local accessoriesScopesRates = sVars.Accessories * sVars.Loot * (sVars.AccessoriesScopesRates / 50);
    local accessoriesOtherRates = sVars.Accessories * sVars.Loot * (sVars.AccessoriesOtherRates / 50);

    local ammoCansRates = sVars.Ammo * sVars.Loot * (sVars.AmmoHandgunsRates / 500);
    local cleanRepairRarity = sVars.CleanRepairSpawns * sVars.Loot * 0.5;
    local cleanRepairHighRarity = sVars.CleanRepairSpawns * sVars.Loot * 0.1;
    local firearmSkinsRarity = sVars.FirearmSkinSpawns * sVars.Loot * 0.01;

    local zeroOut = 0

    if sVars.RemoveVanillaFirearms then
        HFO:addDistributions({
            ["Base.Pistol"] = firearmsHandgunsRates,
            ["Base.Pistol2"] = firearmsHandgunsRates,
            ["Base.Pistol3"] = firearmsHandgunsRates,
            ["Base.Revolver_Short"] = firearmsHandgunsRates,
            ["Base.Revolver"] = firearmsHandgunsRates,
            ["Base.Revolver_Long"] = firearmsHandgunsRates,
            ["Base.VarmintRifle"] = firearmsRiflesRates,
            ["Base.HuntingRifle"] = firearmsRiflesRates,
            ["Base.AssaultRifle"] = firearmsRiflesRates,
            ["Base.AssaultRifle2"] = firearmsRiflesRates,
            ["Base.Shotgun"] = firearmsShotgunsRates,
            ["Base.DoubleBarrelShotgun"] = firearmsShotgunsRates,
        }, {
            "ArmyStorageAmmunition",
            "ArmyStorageGuns",
            "DrugLabGuns",
            "FirearmWeapons",
            "GunStoreAmmunition",
            "GunStoreCounter",
            "GunStoreDisplayCase",
            "GunStoreShelf",
            "PawnShopGunsSpecial",
            "PoliceStorageAmmunition",
            "PoliceStorageGuns",
        });
    else
        HFO:addDistributions({
            ["Base.Pistol"] = zeroOut,
            ["Base.Pistol2"] = zeroOut,
            ["Base.Pistol3"] = zeroOut,
            ["Base.Revolver_Short"] = zeroOut,
            ["Base.Revolver"] = zeroOut,
            ["Base.Revolver_Long"] = zeroOut,
            ["Base.VarmintRifle"] = zeroOut,
            ["Base.HuntingRifle"] = zeroOut,
            ["Base.AssaultRifle"] = zeroOut,
            ["Base.AssaultRifle2"] = zeroOut,
            ["Base.Shotgun"] = zeroOut,
            ["Base.DoubleBarrelShotgun"] = zeroOut,
        }, {
        });
    end

    if sVars.RemoveVanillaAccessories then     
        HFO:addDistributions({
            ["Base.ChokeTubeFull"] = accessoriesOtherRates,
            ["Base.ChokeTubeImproved"] = accessoriesOtherRates,
            ["Base.IronSight"] = accessoriesOtherRates,
            ["Base.x2Scope"] = accessoriesScopesRates,
            ["Base.x4Scope"] = accessoriesScopesRates,
            ["Base.x8Scope"] = accessoriesScopesRates,
            ["Base.RedDot"] = accessoriesScopesRates,
            ["Base.FiberglassStock"] = accessoriesOtherRates,
            ["Base.RecoilPad"] = accessoriesOtherRates,
            ["Base.Laser"] = accessoriesScopesRates,
            ["Base.Bayonnet"] = accessoriesOtherRates,
            ["Base.GunLight"] = accessoriesOtherRates,
            ["Base.BayonetImprovised"] = accessoriesOtherRates,
        }, {
            "FirearmWeapons",
            "GarageFirearms",
            "GunStoreCounter",
            "GunStoreDisplayCase",
            "PoliceStorageGuns",
            "PoliceEvidence",
            "ArmyStorageGuns",
            "PawnShopGuns", 
        });

    else
        HFO:addDistributions({
            ["Base.ChokeTubeFull"] = zeroOut,
            ["Base.ChokeTubeImproved"] = zeroOut,
            ["Base.IronSight"] = zeroOut,
            ["Base.x2Scope"] = zeroOut,
            ["Base.x4Scope"] = zeroOut,
            ["Base.x8Scope"] = zeroOut,
            ["Base.RedDot"] = zeroOut,
            ["Base.FiberglassStock"] = zeroOut,
            ["Base.RecoilPad"] = zeroOut,
            ["Base.Laser"] = zeroOut,
            ["Base.Bayonnet"] = zeroOut,
            ["Base.GunLight"] = zeroOut,
            ["Base.BayonetImprovised"] = zeroOut,
        }, {
        });
    end

    if sVars.RemoveVanillaAmmo then   
        HFO:addDistributions({
            ["Base.223Box"] = ammoRifleRates,
            ["Base.308Box"] = ammoRifleRates,
            ["Base.556Box"] = ammoRifleRates,
            ["Base.Bullets38Box"] = ammoHandgunsRates,
            ["Base.Bullets44Box"] = ammoHandgunsRates,
            ["Base.Bullets45Box"] = ammoHandgunsRates,
            ["Base.Bullets9mmBox"] = ammoHandgunsRates,
            ["Base.ShotgunShellsBox"] = ammoShotgunRates,
            ["Base.9mmClip"] = ammoRifleRates,
            ["Base.45Clip"] = ammoRifleRates,
            ["Base.44Clip"] = ammoHandgunsRates,
            ["Base.223Clip"] = ammoHandgunsRates,
            ["Base.308Clip"] = ammoHandgunsRates,
            ["Base.M14Clip"] = ammoHandgunsRates,
            ["Base.556Clip"] = ammoShotgunRates,
        }, {
            "ArmyStorageAmmunition",
            "ArmyStorageGuns",
            "DrugLabGuns",
            "FirearmWeapons",
            "GunStoreAmmunition",
            "GunStoreCounter",
            "GunStoreDisplayCase",
            "GunStoreShelf",
            "PawnShopGunsSpecial",
            "PoliceStorageAmmunition",
            "PoliceStorageGuns",
        });

    else
        HFO:addDistributions({
            ["Base.223Box"] = zeroOut,
            ["Base.308Box"] = zeroOut,
            ["Base.556Box"] = zeroOut,
            ["Base.Bullets38Box"] = zeroOut,
            ["Base.Bullets44Box"] = zeroOut,
            ["Base.Bullets45Box"] = zeroOut,
            ["Base.Bullets9mmBox"] = zeroOut,
            ["Base.ShotgunShellsBox"] = zeroOut,
            ["Base.9mmClip"] = zeroOut,
            ["Base.45Clip"] = zeroOut,
            ["Base.44Clip"] = zeroOut,
            ["Base.223Clip"] = zeroOut,
            ["Base.308Clip"] = zeroOut,
            ["Base.M14Clip"] = zeroOut,
            ["Base.556Clip"] = zeroOut,
        }, {
        });
    end
    if sVars.AddFirearms then
        HFO:addDistributions({
            -- Other Guns
            ["Base.Pistol"] = firearmsHandgunsRates,
            ["Base.Pistol2"] = firearmsHandgunsRates,
            ["Base.Pistol3"] = firearmsHandgunsRates,
            ["Base.Revolver_Short"] = firearmsHandgunsRates,
            ["Base.Revolver"] = firearmsHandgunsRates,
            ["Base.Revolver_Long"] = firearmsHandgunsRates,
            ["Base.VarmintRifle"] = firearmsRiflesRates,
            ["Base.HuntingRifle"] = firearmsRiflesRates,
            ["Base.AssaultRifle"] = firearmsRiflesRates,
            ["Base.AssaultRifle2"] = firearmsRiflesRates,
            ["Base.Shotgun"] = firearmsShotgunsRates,
            ["Base.DoubleBarrelShotgun"] = firearmsShotgunsRates,
        }, {
            "ClosetShelfGeneric",
            "GigamartTools",
            "LivingRoomSideTable",
            "PoliceEvidence",
            "CampingLockers",
            "CrateRandomJunk",
        });

    else
        HFO:addDistributions({
            -- Other Guns
            ["Base.Pistol"] = zeroOut,
            ["Base.Pistol2"] = zeroOut,
            ["Base.Pistol3"] = zeroOut,
            ["Base.Revolver_Short"] = zeroOut,
            ["Base.Revolver"] = zeroOut,
            ["Base.Revolver_Long"] = zeroOut,
            ["Base.VarmintRifle"] = zeroOut,
            ["Base.HuntingRifle"] = zeroOut,
            ["Base.AssaultRifle"] = zeroOut,
            ["Base.AssaultRifle2"] = zeroOut,
            ["Base.Shotgun"] = zeroOut,
            ["Base.DoubleBarrelShotgun"] = zeroOut,
        }, {
        });
    end

    if sVars.AddAccessories then
        HFO:addDistributions({
            -- Other Accessories
            ["Base.ChokeTubeFull"] = accessoriesOtherRates,
            ["Base.ChokeTubeImproved"] = accessoriesOtherRates,
            ["Base.IronSight"] = accessoriesOtherRates,
            ["Base.x2Scope"] = accessoriesScopesRates,
            ["Base.x4Scope"] = accessoriesScopesRates,
            ["Base.x8Scope"] = accessoriesScopesRates,
            ["Base.RedDot"] = accessoriesScopesRates,
            ["Base.FiberglassStock"] = accessoriesOtherRates,
            ["Base.RecoilPad"] = accessoriesOtherRates,
        }, {
            "ClosetShelfGeneric",
            "GigamartTools",
            "LivingRoomSideTable",
            "PoliceEvidence",
            "CampingLockers",
            "CrateRandomJunk", 
        });

    else
        HFO:addDistributions({
            -- Other Guns
            ["Base.ChokeTubeFull"] = zeroOut,
            ["Base.ChokeTubeImproved"] = zeroOut,
            ["Base.IronSight"] = zeroOut,
            ["Base.x2Scope"] = zeroOut,
            ["Base.x4Scope"] = zeroOut,
            ["Base.x8Scope"] = zeroOut,
            ["Base.RedDot"] = zeroOut,
            ["Base.FiberglassStock"] = zeroOut,
            ["Base.RecoilPad"] = zeroOut,
        }, {
        });
    end

    if sVars.AddAccessories then
        HFO:addDistributions({
            -- Other Accessories
            ["Base.BayonetImprovised"] = accessoriesOtherRates,
            ["Base.Bayonnet"] = accessoriesOtherRates,
            ["Base.GunLight"] = accessoriesOtherRates,
            ["Base.Laser"] = accessoriesOtherRates,
        }, {
            "ClosetShelfGeneric",
            "GigamartTools",
            "LivingRoomSideTable",
            "PoliceEvidence",
            "CampingLockers",
            "CrateRandomJunk", 
        });

    else
        HFO:addDistributions({
            -- Other Accessories
            ["Base.BayonetImprovised"] = zeroOut,
            ["Base.Bayonnet"] = zeroOut,
            ["Base.GunLight"] = zeroOut,
            ["Base.Laser"] = zeroOut,
        }, {
        });
    end

    HFO:addDistributions({
        -- AmmoCan Spawns
        ["Base.AmmoCanUnopened"] = ammoCansRates,
    }, {
        "GunStoreAmmunition",
        "GunStoreShelf",
        "PoliceStorageGuns",
        "ArmyStorageAmmunition",
        "GarageFirearms",
        "Hunter",
        "PawnShopGunsSpecial",
        "SurvivalGear",
        "Trapper",
    });

    if sVars.Cleaning then
    HFO:addDistributions({
        -- Cleaning and Repair Supplies
        ["Base.FirearmCleaningKit"] = cleanRepairRarity,
        ["Base.FirearmLubricant"] = cleanRepairRarity,
    }, {
        "GunStoreCounter", 
        "GunStoreDisplayCase",
        "GunStoreShelf",
        "PoliceStorageGuns",
        "ArmyStorageGuns",
        "ArmySurplusTools",
        "PlankStashMisc",
        "PoliceEvidence",
        "GarageFirearms",
        "Hunter",
        "PawnShopGunsSpecial",
        "SurvivalGear",
        "Trapper",
    });
    else
        HFO:addDistributions({
            ["Base.FirearmCleaningKit"] = zeroOut,
            ["Base.FirearmLubricant"] = zeroOut,
        }, {
        });
    end

    if sVars.RepairKits then
    HFO:addDistributions({
        -- Cleaning and Repair Supplies
        ["Base.FirearmRepairKit"] = cleanRepairHighRarity,
    }, {
        "GunStoreCounter", 
        "GunStoreDisplayCase",
        "GunStoreShelf",
        "PoliceStorageGuns",
        "ArmyStorageGuns",
        "ArmySurplusTools",
        "PlankStashMisc",
        "PoliceEvidence",
        "GarageFirearms",
        "Hunter",
        "PawnShopGunsSpecial",
        "SurvivalGear",
        "Trapper",
    });

    else
        HFO:addDistributions({
            ["Base.FirearmRepairKit"] = zeroOut,
        }, {
        });
    end
end

Events.OnPreDistributionMerge.Add(updateDistributionsHFO);