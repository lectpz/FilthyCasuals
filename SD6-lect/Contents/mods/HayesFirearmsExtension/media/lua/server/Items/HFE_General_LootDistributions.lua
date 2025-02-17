require "Items/ItemPicker"
require "Items/SuburbsDistributions"
require "Items/ProceduralDistributions"
require "Vehicles/VehicleDistributions"

HFE = HFE or {};

function HFE:addDistributions(itemsAndChances, locations)
	for item, chance in pairs(itemsAndChances)
	do
		for i, location in ipairs(locations)
		do
			if ProceduralDistributions.list[location] and ProceduralDistributions.list[location].items
			then
                --print("Adding item: " .. item .. " with chance: " .. chance .. " to location: " .. location)
				table.insert(ProceduralDistributions.list[location].items, item);
				table.insert(ProceduralDistributions.list[location].items, chance);
			end
		end
	end
end

local function updateDistributions()
    --print("Updating firearm distributions...")
    local sVars = SandboxVars.HFE;
    sVars.Loot = sVars.Loot or 1;
    sVars.AddFirearms = sVars.AddFirearms or true;
    sVars.AddAmmo = sVars.AddAmmo or true;
    sVars.AddAccessories = sVars.AddAccessories or true;
    sVars.AddFirearmCache = sVars.AddFirearmCache or true;
    sVars.FirearmSkins = sVars.FirearmSkins or true;
    sVars.ExclusiveFirearmSkins = sVars.ExclusiveFirearmSkins or false;
    sVars.ColtCavalry = sVars.ColtCavalry or false;
    sVars.FGMG42 = sVars.FGMG42 or false;

    sVars.Firearms = sVars.Firearms or 2;
    sVars.FirearmsHandguns = sVars.FirearmsHandguns or true;
    sVars.FirearmsSMGs = sVars.FirearmsSMGs or true;
    sVars.FirearmsRifles = sVars.FirearmsRifles or true;
    sVars.FirearmsSnipers = sVars.FirearmsSnipers or true;
    sVars.FirearmsShotguns = sVars.FirearmsShotguns or true;
    sVars.FirearmsOther = sVars.FirearmsOther or true;
    sVars.FirearmsHandgunsRates = sVars.FirearmsHandgunsRates or 50;
    sVars.FirearmsSMGsRates = sVars.FirearmsSMGsRates or 50;
    sVars.FirearmsRiflesRates = sVars.FirearmsRiflesRates or 50;
    sVars.FirearmsSnipersRates = sVars.FirearmsSnipersRates or 50;
    sVars.FirearmsShotgunsRates = sVars.FirearmsShotgunsRates or 50;
    sVars.FirearmsOtherRates = sVars.FirearmsOtherRates or 50;

    sVars.Ammo = sVars.Ammo or 2;
    sVars.AmmoHandguns = sVars.AmmoHandguns or true;
    sVars.AmmoRifles = sVars.AmmoRifles or true;
    sVars.AmmoShotguns = sVars.AmmoShotguns or true;
    sVars.AmmoOther = sVars.AmmoOther or true;
    sVars.AmmoHandgunsRates = sVars.AmmoHandgunsRates or 50;
    sVars.AmmoRiflesRates = sVars.AmmoRiflesRates or 50
    sVars.AmmoShotgunsRates = sVars.AmmoShotgunsRates or 50;
    sVars.AmmoOtherRates = sVars.AmmoOtherRates or 50;

    sVars.Extended = sVars.Extended or 2;
    sVars.ExtendedRates = sVars.ExtendedRates or 20;
    sVars.ExtendedSmall = sVars.ExtendedSmall or false;
    sVars.ExtendedLarge = sVars.ExtendedLarge or false;
    sVars.ExtendedDrum = sVars.ExtendedDrum  or false;

    sVars.Accessories = sVars.Accessories or 2;
    sVars.AccessoriesSuppressors = sVars.AccessoriesSuppressors or true;
    sVars.AccessoriesScopes = sVars.AccessoriesSuppressors or true;
    sVars.AccessoriesOther = sVars.AccessoriesOther or true;
    sVars.AccessoriesSuppressorsRates = sVars.AccessoriesSuppressorsRates or 20;
    sVars.AccessoriesScopesRates = sVars.AccessoriesScopesRates or 30;
    sVars.AccessoriesOtherRates = sVars.AccessoriesOtherRates or 40;

    sVars.FirearmCache = sVars.FirearmCache or 3;
    sVars.FirearmSkinSpawns = sVars.FirearmSkinSpawns or 3;

    local firearmsHandgunsRates = sVars.Firearms * sVars.Loot * (sVars.FirearmsHandgunsRates / 50);
    local firearmsSMGsRates = sVars.Firearms * sVars.Loot * (sVars.FirearmsSMGsRates / 50);
    local firearmsRiflesRates = sVars.Firearms * sVars.Loot * (sVars.FirearmsRiflesRates / 50);
    local firearmsSnipersRates = sVars.Firearms * sVars.Loot * (sVars.FirearmsSnipersRates / 50);
    local firearmsShotgunsRates =  sVars.Firearms * sVars.Loot * (sVars.FirearmsShotgunsRates / 50);
    local firearmsOtherRates =  sVars.Firearms * sVars.Loot * (sVars.FirearmsOtherRates / 50);

    local ammoHandgunsRates = sVars.Ammo * sVars.Loot * (sVars.AmmoHandgunsRates / 50);
    local ammoRifleRates = sVars.Ammo * sVars.Loot * (sVars.AmmoRiflesRates / 50);
    local ammoShotgunRates = sVars.Ammo * sVars.Loot * (sVars.AmmoShotgunsRates / 50);
    local ammoOtherRates = sVars.Ammo * sVars.Loot * (sVars.AmmoOtherRates / 50);
    local ammoExtendedMags = sVars.Extended * sVars.Loot * (sVars.ExtendedRates / 500);
    local ammoExtendedRareMags = sVars.Extended * sVars.Loot * (sVars.ExtendedRates / 2000);
    local ammoExtendedDrumMags = sVars.Extended * sVars.Loot * (sVars.ExtendedRates / 5000);

    local accessoriesSuppressorsRates = sVars.Accessories * sVars.Loot * (sVars.AccessoriesSuppressorsRates / 50);
    local accessoriesScopesRates = sVars.Accessories * sVars.Loot * (sVars.AccessoriesScopesRates / 50);
    local accessoriesOtherRates = sVars.Accessories * sVars.Loot * (sVars.AccessoriesOtherRates / 50);

    local firearmsCacheRarity = sVars.FirearmCache * sVars.Loot * 0.1;
    local firearmSkinsRarity = sVars.FirearmSkinSpawns * sVars.Loot * 0.1;

    local zeroOut = 0

    --[[if sVars.ExtendedSmall then
        --print("Adding extended small magazines...")
        HFE:addDistributions({
            ["Base.Mag9ExtSm"] = ammoExtendedMags,
            ["Base.MagLugerExtSm"] = ammoExtendedMags,
            ["Base.Mag380ExtSm"] = ammoExtendedMags,
            ["Base.Mag44ExtSm"] = ammoExtendedMags,
            ["Base.Mag45ExtSm"] = ammoExtendedMags,
            ["Base.MagMosinNagantExtSm"] = ammoExtendedMags,
            ["Base.MagM1GarandExtSm"] = ammoExtendedMags,
            ["Base.Mag308ExtSm"] = ammoExtendedMags,
            ["Base.MagSVDExtSm"] = ammoExtendedMags,
            ["Base.Mag50BMGExtSm"] = ammoExtendedMags,
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
        --print("Adding fallback extended small magazines...")
        HFE:addDistributions({
            ["Base.Mag9ExtSm"] = zeroOut,
            ["Base.MagLugerExtSm"] = zeroOut,
            ["Base.Mag380ExtSm"] = zeroOut,
            ["Base.Mag44ExtSm"] = zeroOut,
            ["Base.Mag45ExtSm"] = zeroOut,
            ["Base.MagMosinNagantExtSm"] = zeroOut,
            ["Base.MagM1GarandExtSm"] = zeroOut,
            ["Base.Mag308ExtSm"] = zeroOut,
            ["Base.MagSVDExtSm"] = zeroOut,
            ["Base.Mag50BMGExtSm"] = zeroOut,
        }, {
        });
    end]]
        
    --[[if sVars.ExtendedLarge then
        --print("Adding extended large magazines...")
        HFE:addDistributions({
            ["Base.Mag9ExtLg"] = ammoExtendedRareMags,
            ["Base.Mag57ExtLg"] = ammoExtendedRareMags,
            ["Base.MagLugerExtLg"] = ammoExtendedRareMags,
            ["Base.Mag380ExtLg"] = ammoExtendedRareMags,
            ["Base.Mag45ExtLg"] = ammoExtendedRareMags,
            ["Base.Mag44ExtLg"] = ammoExtendedRareMags,
            ["Base.MagPM63RAKExtLg"] = ammoExtendedRareMags,
            ["Base.Mag223ExtLg"] = ammoExtendedRareMags,
            ["Base.Mag3006ExtLg"] = ammoExtendedRareMags,
            ["Base.MagMP28ExtLg"] = ammoExtendedRareMags,
            ["Base.Mag9x39ExtLg"] = ammoExtendedRareMags,
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
        --print("Adding fallback extended large magazines...")
        HFE:addDistributions({
            ["Base.Mag9ExtLg"] = zeroOut,
            ["Base.Mag57ExtLg"] = zeroOut,
            ["Base.MagLugerExtLg"] = zeroOut,
            ["Base.Mag380ExtLg"] = zeroOut,
            ["Base.Mag45ExtLg"] = zeroOut,
            ["Base.Mag44ExtLg"] = zeroOut,
            ["Base.MagPM63RAKExtLg"] = zeroOut,
            ["Base.Mag223ExtLg"] = zeroOut,
            ["Base.Mag3006ExtLg"] = zeroOut,
            ["Base.MagMP28ExtLg"] = zeroOut,
            ["Base.Mag9x39ExtLg"] = zeroOut,
        }, {
        });
    end]]

   --[[if sVars.ExtendedDrum then
       -- print("Adding extended drum magazines...")
        HFE:addDistributions({
            ["Base.Mag9Drum"] = ammoExtendedDrumMags,
            ["Base.Mag57Drum"] = ammoExtendedDrumMags,
            ["Base.MagLugerDrum"] = ammoExtendedDrumMags,
            ["Base.Mag380Drum"] = ammoExtendedDrumMags,
            ["Base.Mag45Drum"] = ammoExtendedDrumMags,
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
        --print("Adding fallback extended drum magazines...")
        HFE:addDistributions({
            ["Base.Mag9Drum"] = zeroOut,
            ["Base.Mag57Drum"] = zeroOut,
            ["Base.MagLugerDrum"] = zeroOut,
            ["Base.Mag380Drum"] = zeroOut,
            ["Base.Mag45Drum"] = zeroOut,
        }, {
        });
    end]]

    if sVars.AddAmmo then
        if sVars.AmmoHandguns then
            HFE:addDistributions({
                ["Base.380Box"] = ammoHandgunsRates,
                ["Base.380Clip"] = ammoHandgunsRates,
                ["Base.57Box"] = ammoHandgunsRates,
                ["Base.57Clip"] = ammoHandgunsRates,
                ["Base.9mmBoxClip"] = ammoHandgunsRates,
                ["Base.45Clip13"] = ammoHandgunsRates,
                ["Base.9mmClip8"] = ammoHandgunsRates,
                ["Base.9mmClip32"] = ammoHandgunsRates,
                ["Base.223Clip10"] = ammoHandgunsRates,
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
            HFE:addDistributions({
                ["Base.380Box"] = zeroOut,
                ["Base.380Clip"] = zeroOut,
                ["Base.57Box"] = zeroOut,
                ["Base.57Clip"] = zeroOut,
                ["Base.9mmBoxClip"] = zeroOut,
                ["Base.45Clip13"] = zeroOut,
                ["Base.9mmClip8"] = zeroOut,
                ["Base.9mmClip32"] = zeroOut,
                ["Base.223Clip10"] = zeroOut,
            }, {
            });
        end
        if sVars.AmmoRifles then
            HFE:addDistributions({
                ["Base.3006Box"] = ammoRifleRates,
                ["Base.3006BlocClip"] = ammoRifleRates,
                ["Base.3006Clip"] = ammoRifleRates,
                ["Base.P90Clip"] = ammoRifleRates,
                ["Base.545Box"] = ammoRifleRates,
                ["Base.545Clip"] = ammoRifleRates,
                ["Base.762Box"] = ammoRifleRates,
                ["Base.762Clip"] = ammoRifleRates,
                ["Base.762x54rBox"] = ammoRifleRates,
                ["Base.762x54rClip"] = ammoRifleRates,
                ["Base.762x54rStripperClip"] = ammoRifleRates,
                ["Base.792x33Box"] = ammoRifleRates,
                ["Base.792x33Clip"] = ammoRifleRates,
                ["Base.50BMGBox"] = ammoRifleRates,
                ["Base.50BMGClip"] = ammoRifleRates,
                --["Base.Mag762x51ExtSm"] = ammoRifleRates,
                --["Base.Mag762x51ExtLg"] = ammoRifleRates,
                ["Base.9x39Clip"] = ammoRifleRates,
                --["Base.Mag9x39ExtSm"] = ammoRifleRates,
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
            HFE:addDistributions({
                ["Base.3006Box"] = zeroOut,
                ["Base.3006BlocClip"] = zeroOut,
                ["Base.3006Clip"] = zeroOut,
                ["Base.P90Clip"] = zeroOut,
                ["Base.545Box"] = zeroOut,
                ["Base.545Clip"] = zeroOut,
                ["Base.762Box"] = zeroOut,
                ["Base.762Clip"] = zeroOut,
                ["Base.762x54rBox"] = zeroOut,
                ["Base.762x54rClip"] = zeroOut,
                ["Base.762x54rStripperClip"] = zeroOut,
                ["Base.792x33Box"] = zeroOut,
                ["Base.792x33Clip"] = zeroOut,
                ["Base.50BMGBox"] = zeroOut,
                ["Base.50BMGClip"] = zeroOut,
                --["Base.Mag762x51ExtSm"] = zeroOut,
                --["Base.Mag762x51ExtLg"] = zeroOut,
                ["Base.9x39Clip"] = zeroOut,
                --["Base.Mag9x39ExtSm"] = zeroOut,
            }, {
            });
        end
        --[[if sVars.AmmoRifles and sVars.FGMG42 then
            HFE:addDistributions({
                ["Base.792Box"] = ammoRifleRates,
                ["Base.792Drum"] = ammoRifleRates,
                ["Base.792Clip"] = ammoRifleRates,
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
            HFE:addDistributions({
                ["Base.792Box"] = zeroOut,
                ["Base.792Drum"] = zeroOut,
                ["Base.792Clip"] = zeroOut,
            }, {
            });
        end]]
        if sVars.AmmoOther then
            HFE:addDistributions({
                ["Base.CrossbowBoltBox"] = ammoOtherRates,
                ["Base.CrossbowBolt"] = ammoOtherRates,
                ["Base.TheNailGunClip"] = ammoOtherRates,
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
            HFE:addDistributions({
                ["Base.CrossbowBoltBox"] = zeroOut,
                ["Base.CrossbowBolt"] = zeroOut,
                ["Base.TheNailGunClip"] = zeroOut,
            }, {
            });
        end
    else
        HFE:addDistributions({
            ["Base.380Box"] = zeroOut,
            ["Base.380Clip"] = zeroOut,
            ["Base.57Box"] = zeroOut,
            ["Base.57Clip"] = zeroOut,
            ["Base.9mmBoxClip"] = zeroOut,
            ["Base.45Clip13"] = zeroOut,
            ["Base.9mmClip8"] = zeroOut,
            ["Base.223Clip10"] = zeroOut,
            ["Base.3006Box"] = zeroOut,
            ["Base.3006BlocClip"] = zeroOut,
            ["Base.3006Clip"] = zeroOut,
            ["Base.P90Clip"] = zeroOut,
            ["Base.545Box"] = zeroOut,
            ["Base.545Clip"] = zeroOut,
            ["Base.762Box"] = zeroOut,
            ["Base.762Clip"] = zeroOut,
            ["Base.762x54rBox"] = zeroOut,
            ["Base.762x54rClip"] = zeroOut,
            ["Base.762x54rStripperClip"] = zeroOut,
            ["Base.792x33Box"] = zeroOut,
            ["Base.792x33Clip"] = zeroOut,
            ["Base.50BMGBox"] = zeroOut,
            ["Base.50BMGClip"] = zeroOut,
            --["Base.Mag762x51ExtSm"] = zeroOut,
            --["Base.Mag762x51ExtLg"] = zeroOut,
            ["Base.9x39Clip"] = zeroOut,
            --["Base.Mag9x39ExtSm"] = zeroOut,
            --["Base.792Box"] = zeroOut,
            --["Base.792Drum"] = zeroOut,
            ["Base.792Clip"] = zeroOut,
            ["Base.CrossbowBoltBox"] = zeroOut,
            ["Base.CrossbowBolt"] = zeroOut,
            ["Base.TheNailGunClip"] = zeroOut,
        }, {
        });
    end

    if sVars.AddFirearms then
        if sVars.FirearmsHandguns then
            HFE:addDistributions({
                ["Base.Glock"] = firearmsHandgunsRates,
                ["Base.FiveSeven"] = firearmsHandgunsRates,
                ["Base.Luger"] = firearmsHandgunsRates,
                ["Base.WaltherPPK"] = firearmsHandgunsRates,
                ["Base.Makarov"] = firearmsHandgunsRates,
                ["Base.Derringer"] = firearmsHandgunsRates,
                ["Base.PLR16"] = firearmsHandgunsRates,
                ["Base.MosinNagantObrez"] = firearmsHandgunsRates,
            }, {
                "FirearmWeapons",
                "GarageFirearms",
                "GunStoreDisplayCase",
                "PoliceStorageGuns",
                "PoliceEvidence",
                "ArmyStorageGuns",
                "PawnShopGuns",
                "PawnShopGunsSpecial",
            });
        else
            HFE:addDistributions({
                ["Base.Glock"] = zeroOut,
                ["Base.FiveSeven"] = zeroOut,
                ["Base.Luger"] = zeroOut,
                ["Base.WaltherPPK"] = zeroOut,
                ["Base.Makarov"] = zeroOut,
                ["Base.Derringer"] = zeroOut,
                ["Base.PLR16"] = zeroOut,
                ["Base.MosinNagantObrez"] = zeroOut,
            }, {
            });
        end

        if sVars.FirearmsHandguns and sVars.ColtCavalry then
            HFE:addDistributions({
                ["Base.ColtCavalryRevolver"] = firearmsHandgunsRates,
            }, {
                "FirearmWeapons",
                "GarageFirearms",
                "GunStoreDisplayCase",
                "PoliceStorageGuns",
                "PoliceEvidence",
                "ArmyStorageGuns",
                "PawnShopGuns",
                "PawnShopGunsSpecial",
            });
        else
            HFE:addDistributions({
                ["Base.Glock"] = zeroOut,
            }, {
            });
        end

        if sVars.FirearmsSMGs then
            HFE:addDistributions({
                ["Base.AK74U"] = firearmsSMGsRates,
                ["Base.FranchiLF57"] = firearmsSMGsRates,
                ["Base.MiniUzi"] = firearmsSMGsRates,
                ["Base.P90"] = firearmsSMGsRates,
                ["Base.PM63RAK"] = firearmsSMGsRates,
                ["Base.MP28"] = firearmsSMGsRates,
            }, {
                "FirearmWeapons",
                "GarageFirearms",
                "GunStoreDisplayCase",
                "PoliceStorageGuns",
                "PoliceEvidence",
                "ArmyStorageGuns",
                "PawnShopGuns",
                "PawnShopGunsSpecial",
            });
        else
            HFE:addDistributions({
                ["Base.AK74U"] = zeroOut,
                ["Base.FranchiLF57"] = zeroOut,
                ["Base.MiniUzi"] = zeroOut,
                ["Base.P90"] = zeroOut,
                ["Base.PM63RAK"] = zeroOut,
                ["Base.MP28"] = zeroOut,
            }, {
            });
        end

        if sVars.FirearmsRifles then
            HFE:addDistributions({
                ["Base.AK103"] = firearmsRiflesRates,
                ["Base.AK74"] = firearmsRiflesRates,
                ["Base.HenryRepeatingBigBoy"] = firearmsRiflesRates,
                ["Base.GrozaOTs14"] = firearmsRiflesRates,
                ["Base.M1918BAR"] = firearmsRiflesRates,
                ["Base.M1Garand"] = firearmsRiflesRates,
                ["Base.SIG550"] = firearmsRiflesRates,
                ["Base.StG44"] = firearmsRiflesRates,
                ["Base.M4A1"] = firearmsRiflesRates,
                ["Base.L2A1"] = firearmsRiflesRates,
                ["Base.EM2"] = firearmsRiflesRates,
                ["Base.L85A1"] = firearmsRiflesRates,
                ["Base.ASVal"] = firearmsRiflesRates,
            }, {
                "FirearmWeapons",
                "GarageFirearms",
                "GunStoreDisplayCase",
                "PoliceStorageGuns",
                "PoliceEvidence",
                "ArmyStorageGuns",
                "PawnShopGuns",
                "PawnShopGunsSpecial",
            });
        else
            HFE:addDistributions({
                ["Base.AK103"] = zeroOut,
                ["Base.AK74"] = zeroOut,
                ["Base.HenryRepeatingBigBoy"] = zeroOut,
                ["Base.GrozaOTs14"] = zeroOut,
                ["Base.M1918BAR"] = zeroOut,
                ["Base.M1Garand"] = zeroOut,
                ["Base.SIG550"] = zeroOut,
                ["Base.StG44"] = zeroOut,
                ["Base.M4A1"] = zeroOut,
                ["Base.L2A1"] = zeroOut,
                ["Base.EM2"] = zeroOut,
                ["Base.L85A1"] = zeroOut,
                ["Base.ASVal"] = zeroOut,
            }, {
            });
        end

        if sVars.FirearmsRifles and sVars.FGMG42 then
            HFE:addDistributions({
                ["Base.FG42"] = firearmsRiflesRates,
                ["Base.MG42"] = firearmsRiflesRates,
            }, {
                "FirearmWeapons",
                "GarageFirearms",
                "GunStoreDisplayCase",
                "PoliceStorageGuns",
                "PoliceEvidence",
                "ArmyStorageGuns",
                "PawnShopGuns",
                "PawnShopGunsSpecial",
            });
        else
            HFE:addDistributions({
                ["Base.FG42"] = zeroOut,
                ["Base.MG42"] = zeroOut,
            }, {
            });
        end

        if sVars.FirearmsSnipers then
            HFE:addDistributions({
                ["Base.MosinNagant"] = firearmsSnipersRates,
                ["Base.BarrettM82A1"] = firearmsSnipersRates,
                ["Base.SVDDragunov"] = firearmsSnipersRates,
                ["Base.Galil"] = firearmsSnipersRates,
                ["Base.VSSVintorez"] = firearmsSnipersRates,
            }, {
                "DrugLabGuns",
                "GunStoreDisplayCase",
                "PoliceEvidence",
                "ArmyStorageGuns",
                "PawnShopGunsSpecial",
            });
        else
            HFE:addDistributions({
                ["Base.MosinNagant"] = zeroOut,
                ["Base.BarrettM82A1"] = zeroOut,
                ["Base.SVDDragunov"] = zeroOut,
                ["Base.Galil"] = zeroOut,
                ["Base.VSSVintorez"] = zeroOut,
            }, {
            });
        end

        if sVars.FirearmsShotguns then
            HFE:addDistributions({
                ["Base.Remington1100"] = firearmsShotgunsRates,
                ["Base.TrenchGun"] = firearmsShotgunsRates,
                ["Base.BeckerRevolver"] = firearmsShotgunsRates,
            }, {
                "FirearmWeapons",
                "GarageFirearms",
                "GunStoreDisplayCase",
                "PoliceStorageGuns",
                "PoliceEvidence",
                "ArmyStorageGuns",
                "PawnShopGuns",
                "PawnShopGunsSpecial",
            });
        else
            HFE:addDistributions({
                ["Base.Remington1100"] = zeroOut,
                ["Base.TrenchGun"] = zeroOut,
                ["Base.BeckerRevolver"] = zeroOut,
            }, {
            });
        end

        if sVars.FirearmsOther then
            HFE:addDistributions({
                ["Base.CrossbowCompound"] = firearmsOtherRates,
                ["Base.TheNailGun"] = firearmsOtherRates,
            }, {
                "FirearmWeapons",
                "GarageFirearms",
                "GunStoreDisplayCase",
                "PoliceStorageGuns",
                "PoliceEvidence",
                "ArmyStorageGuns",
                "PawnShopGuns",
                "PawnShopGunsSpecial",
            });
        else
            HFE:addDistributions({
                ["Base.CrossbowCompound"] = zeroOut,
                ["Base.TheNailGun"] = zeroOut,
            }, {
            });
        end

        if sVars.FirearmsOther and sVars.TShirtLauncher then
            HFE:addDistributions({
                ["Base.TShirtLauncher"] = firearmsOtherRates,
            }, {
                "FirearmWeapons",
                "GarageFirearms",
                "GunStoreDisplayCase",
                "PoliceStorageGuns",
                "PoliceEvidence",
                "ArmyStorageGuns",
                "PawnShopGuns",
                "PawnShopGunsSpecial",
            });
        else
            HFE:addDistributions({
                ["Base.TShirtLauncher"] = zeroOut,
            }, {
            });
        end
    else
        HFE:addDistributions({
            ["Base.Glock"] = zeroOut,
            ["Base.FiveSeven"] = zeroOut,
            ["Base.Luger"] = zeroOut,
            ["Base.WaltherPPK"] = zeroOut,
            ["Base.Makarov"] = zeroOut,
            ["Base.Derringer"] = zeroOut,
            ["Base.PLR16"] = zeroOut,
            ["Base.MosinNagantObrez"] = zeroOut,
            ["Base.AK74U"] = zeroOut,
            ["Base.FranchiLF57"] = zeroOut,
            ["Base.MiniUzi"] = zeroOut,
            ["Base.P90"] = zeroOut,
            ["Base.PM63RAK"] = zeroOut,
            ["Base.MP28"] = zeroOut,
            ["Base.AK103"] = zeroOut,
            ["Base.AK74"] = zeroOut,
            ["Base.HenryRepeatingBigBoy"] = zeroOut,
            ["Base.GrozaOTs14"] = zeroOut,
            ["Base.M1918BAR"] = zeroOut,
            ["Base.M1Garand"] = zeroOut,
            ["Base.SIG550"] = zeroOut,
            ["Base.StG44"] = zeroOut,
            ["Base.L2A1"] = zeroOut,
            ["Base.EM2"] = zeroOut,
            ["Base.L85A1"] = zeroOut,
            ["Base.ASVal"] = zeroOut,
            ["Base.MosinNagant"] = zeroOut,
            ["Base.BarrettM82A1"] = zeroOut,
            ["Base.SVDDragunov"] = zeroOut,
            ["Base.Galil"] = zeroOut,
            ["Base.VSSVintorez"] = zeroOut,
            ["Base.Remington1100"] = zeroOut,
            ["Base.TrenchGun"] = zeroOut,
            ["Base.BeckerRevolver"] = zeroOut,
            ["Base.CrossbowCompound"] = zeroOut,
            ["Base.TheNailGun"] = zeroOut,
            ["Base.TShirtLauncher"] = zeroOut,
        }, {
        });
    end

    if sVars.AddAccessories then
        if sVars.AccessoriesSuppressors then
            HFE:addDistributions({
                ["Base.SuppressorPistol"] = accessoriesSuppressorsRates,
                ["Base.SuppressorRifle"] = accessoriesSuppressorsRates,
                ["Base.SuppressorSniper"] = accessoriesSuppressorsRates,
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
            HFE:addDistributions({
                ["Base.SuppressorPistol"] = zeroOut,
                ["Base.SuppressorRifle"] = zeroOut,
                ["Base.SuppressorSniper"] = zeroOut,
            }, {
            });
        end

        if sVars.AccessoriesScopes then
            HFE:addDistributions({
                ["Base.PEMScope"] = accessoriesScopesRates,
                ["Base.PSO1Scope"] = accessoriesScopesRates,
                ["Base.UniversalOpticalSight"] = accessoriesScopesRates,
                ["Base.ProOpticScope"] = accessoriesScopesRates,
                ["Base.ReflexSight"] = accessoriesScopesRates,
                ["Base.HoloSight"] = accessoriesScopesRates,
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
            HFE:addDistributions({
                ["Base.PEMScope"] = zeroOut,
                ["Base.PSO1Scope"] = zeroOut,
                ["Base.UniversalOpticalSight"] = zeroOut,
                ["Base.ProOpticScope"] = zeroOut,
                ["Base.ReflexSight"] = zeroOut,
                ["Base.HoloSight"] = zeroOut,
            }, {
            });
        end

        if sVars.AccessoriesScopes and sVars.FGMG42 then
            HFE:addDistributions({
                ["Base.ScopeFG42"] = accessoriesScopesRates,
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
            HFE:addDistributions({
                ["Base.ScopeFG42"] = zeroOut,
            }, {
            });
        end

        if sVars.AccessoriesOther then
            HFE:addDistributions({
                ["Base.SkeletonizedStock"] = accessoriesOtherRates,
                ["Base.Compensator"] = accessoriesOtherRates,
                ["Base.MuzzleBrake"] = accessoriesOtherRates,
                ["Base.CompensatorHandgun"] = accessoriesOtherRates,
                ["Base.MuzzleBrakeHandgun"] = accessoriesOtherRates,
                ["Base.ButtStockWrap"] = accessoriesOtherRates,
                ["Base.ShellHolder"] = accessoriesOtherRates,
                ["Base.CarryHandle"] = accessoriesOtherRates,
                ["Base.VertGrip"] = accessoriesOtherRates,
                ["Base.AngleGrip"] = accessoriesOtherRates,
                ["Base.TacticalGrip"] = accessoriesOtherRates,
                ["Base.LaserNoLight"] = accessoriesOtherRates,
                ["Base.WeaponLight"] = accessoriesOtherRates,
                ["Base.WeaponLightMedium"] = accessoriesOtherRates,                
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
            HFE:addDistributions({
                ["Base.SkeletonizedStock"] = zeroOut,
                ["Base.Compensator"] = zeroOut,
                ["Base.MuzzleBrake"] = zeroOut,
                ["Base.CompensatorHandgun"] = zeroOut,
                ["Base.MuzzleBrakeHandgun"] = zeroOut,
                ["Base.ButtStockWrap"] = zeroOut,
                ["Base.ShellHolder"] = zeroOut,
                ["Base.CarryHandle"] = zeroOut,
                ["Base.VertGrip"] = zeroOut,
                ["Base.AngleGrip"] = zeroOut,
                ["Base.TacticalGrip"] = zeroOut,
                ["Base.LaserNoLight"] = zeroOut,
                ["Base.WeaponLight"] = zeroOut,
                ["Base.WeaponLightMedium"] = zeroOut,    
            }, {
            });
        end
        if sVars.AccessoriesOther and sVars.FGMG42 then
            HFE:addDistributions({
                ["Base.IronSightsFG42"] = accessoriesOtherRates,
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
            HFE:addDistributions({
                ["Base.IronSightsFG42"] = zeroOut,
            }, {
            });
        end
    else
        HFE:addDistributions({
            ["Base.SuppressorPistol"] = zeroOut,
            ["Base.SuppressorRifle"] = zeroOut,
            ["Base.SuppressorSniper"] = zeroOut,
            ["Base.PEMScope"] = zeroOut,
            ["Base.PSO1Scope"] = zeroOut,
            ["Base.UniversalOpticalSight"] = zeroOut,
            ["Base.ProOpticScope"] = zeroOut,
            ["Base.ReflexSight"] = zeroOut,
            ["Base.HoloSight"] = zeroOut,
            ["Base.ScopeFG42"] = zeroOut,
            ["Base.SkeletonizedStock"] = zeroOut,
            ["Base.Compensator"] = zeroOut,
            ["Base.MuzzleBrake"] = zeroOut,
            ["Base.CompensatorHandgun"] = zeroOut,
            ["Base.MuzzleBrakeHandgun"] = zeroOut,
            ["Base.ButtStockWrap"] = zeroOut,
            ["Base.ShellHolder"] = zeroOut,
            ["Base.CarryHandle"] = zeroOut,
            ["Base.VertGrip"] = zeroOut,
            ["Base.AngleGrip"] = zeroOut,
            ["Base.TacticalGrip"] = zeroOut,
            ["Base.LaserNoLight"] = zeroOut,
            ["Base.WeaponLight"] = zeroOut,
            ["Base.WeaponLightMedium"] = zeroOut,    
        }, {
        });
    end

    if sVars.AddFirearmCache then
        HFE:addDistributions({
            ["Base.FirearmCache"] = firearmsCacheRarity,
        }, {
            "ArmyHangarTools",
            "ArmyStorageGuns",
            "GarageFirearms",
            "GunStoreDisplayCase",
            "GunStoreShelf",
            "PawnShopGunsSpecial", 
            "PawnShopCases",
            "PlankStashMisc",
            "PoliceEvidence",
        });
    else
        HFE:addDistributions({
            ["Base.FirearmCache"] = zeroOut,
        }, {
        });
    end

    if sVars.FirearmSkins then
        HFE:addDistributions({
            ["Base.TanPlating"] = firearmSkinsRarity,
            ["Base.BluePlating"] = firearmSkinsRarity,
            ["Base.RedPlating"] = firearmSkinsRarity,
            ["Base.GoldGunPlating"] = firearmSkinsRarity,
            ["Base.RainbowPlating"] = firearmSkinsRarity,
            ["Base.DZPlating"] = firearmSkinsRarity,
            ["Base.RemingtonRiflesDarkCherryStock"] = firearmSkinsRarity,
            ["Base.WinterCamoPlating"] = firearmSkinsRarity,
            ["Base.WoodStyledPlating"] = firearmSkinsRarity,
            ["Base.PinkPlating"] = firearmSkinsRarity,
            ["Base.RedWhitePlating"] = firearmSkinsRarity,
            ["Base.GreenGoldPlating"] = firearmSkinsRarity,
            ["Base.AztecPlating"] = firearmSkinsRarity,
            ["Base.YellowPlating"] = firearmSkinsRarity,
        }, {
            "PawnShopGunsSpecial", 
            "PawnShopCases",
            "ArmyHangarTools",
            "GunStoreDisplayCase",
            "GarageFirearms",
            "PlankStashMisc",
        });
    else
        HFE:addDistributions({
            ["Base.TanPlating"] = zeroOut,
            ["Base.BluePlating"] = zeroOut,
            ["Base.RedPlating"] = zeroOut,
            ["Base.GoldGunPlating"] = zeroOut,
            ["Base.RainbowPlating"] = zeroOut,
            ["Base.DZPlating"] = zeroOut,
            ["Base.RemingtonRiflesDarkCherryStock"] = zeroOut,
            ["Base.WinterCamoPlating"] = zeroOut,
            ["Base.WoodStyledPlating"] = zeroOut,
            ["Base.PinkPlating"] = zeroOut,
            ["Base.RedWhitePlating"] = zeroOut,
            ["Base.GreenGoldPlating"] = zeroOut,
            ["Base.AztecPlating"] = zeroOut,
            ["Base.YellowPlating"] = zeroOut,
        }, {
        });
    end

    if sVars.ExclusiveFirearmSkins then
        HFE:addDistributions({
            ["Base.DesertEagleGoldPlating"] = firearmSkinsRarity,
            ["Base.GoldShotgunPlating"] = firearmSkinsRarity,
            ["Base.RainbowAnodizedPlating"] = firearmSkinsRarity,
            ["Base.GreenPlating"] = firearmSkinsRarity,
            ["Base.SteelDamascusPlating"] = firearmSkinsRarity,
            ["Base.SalvagedRagePlating"] = firearmSkinsRarity,
            ["Base.ZoidbergSpecialPlating"] = firearmSkinsRarity,
            ["Base.NerfPlating"] = firearmSkinsRarity,
            ["Base.BespokeEngravedPlating"] = firearmSkinsRarity,
            ["Base.SurvivalistPlating"] = firearmSkinsRarity,
            ["Base.MysteryMachinePlating"] = firearmSkinsRarity,
            ["Base.SalvagedBlackPlating"] = firearmSkinsRarity,
            ["Base.PlankPlating"] = firearmSkinsRarity,
            ["Base.BlackIcePlating"] = firearmSkinsRarity,
            ["Base.BlackDeathPlating"] = firearmSkinsRarity,
            ["Base.OrnateIvoryPlating"] = firearmSkinsRarity,
            ["Base.GildedAgePlating"] = firearmSkinsRarity,
            ["Base.TBDPlating"] = firearmSkinsRarity,
            ["Base.CannabisPlating"] = firearmSkinsRarity,
        }, {
            "PawnShopGunsSpecial", 
            "PawnShopCases",
            "ArmyHangarTools",
            "GunStoreDisplayCase",
            "GarageFirearms",
            "PlankStashMisc",
        });
    else
        HFE:addDistributions({
            ["Base.DesertEagleGoldPlating"] = zeroOut,
            ["Base.GoldShotgunPlating"] = zeroOut,
            ["Base.RainbowAnodizedPlating"] = zeroOut,
            ["Base.GreenPlating"] = zeroOut,
            ["Base.SteelDamascusPlating"] = zeroOut,
            ["Base.SalvagedRagePlating"] = zeroOut,
            ["Base.ZoidbergSpecialPlating"] = zeroOut,
            ["Base.NerfPlating"] = zeroOut,
            ["Base.BespokeEngravedPlating"] = zeroOut,
            ["Base.SurvivalistPlating"] = zeroOut,
            ["Base.MysteryMachinePlating"] = zeroOut,
            ["Base.SalvagedBlackPlating"] = zeroOut,
            ["Base.PlankPlating"] = zeroOut,
            ["Base.BlackIcePlating"] = zeroOut,
            ["Base.BlackDeathPlating"] = zeroOut,
            ["Base.OrnateIvoryPlating"] = zeroOut,
            ["Base.GildedAgePlating"] = zeroOut,
            ["Base.TBDPlating"] = zeroOut,
            ["Base.CannabisPlating"] = zeroOut,
        }, {
        });
    end

    if sVars.CrossbowAmmoMag then
        HFE:addDistributions({
            -- Magazines
            ["Base.CompoundCrossbowMagazine"] = RecipeLowRarity,
        }, {
            "BookstoreBooks", 
            "BookstoreMisc",
            "CrateMagazines",
            "CrateBooks",
            "LibraryBooks",
            "MagazineRackMixed",
            "PostOfficeMagazines",
        });
    else
        HFE:addDistributions({
            -- Magazines
            ["Base.CompoundCrossbowMagazine"] = RecipeLowRarity,
        }, {
        });
    end
    --print("Distributions update complete.")
end

Events.OnPreDistributionMerge.Add(updateDistributions);