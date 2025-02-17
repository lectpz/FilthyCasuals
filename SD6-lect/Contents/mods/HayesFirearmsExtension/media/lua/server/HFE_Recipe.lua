require "recipecode"

HFE = HFE or {};

---------------------------
-- WEAPON CACHE MECHANIC --
---------------------------

--plan to build in sandbox variables to influence roll chanches and available items

    HFE.cacheOptions = {
        Ammo = {"CrossbowBoltBox", "3006Box", "380Box", "57Box", "545Box", "50BMGBox", "762x54rBox", "762Box", "762x51Box", "792x33Box", "Bullets9mmBox", "9x39Box", "Bullets45Box", "Bullets44Box", "Bullets38Box", "223Box", "308Box", "556Box", "ShotgunShellsBox", "AmmoCanUnopened"},
        AmmoMags = {"3006BlocClip", "3006Clip", "45Clip13", "45Clip20", "9mmClip8", "223Clip10", "380Clip", "57Clip", "P90Clip", "9mmBoxClip", "9mmClip32", "50BMGClip", "762x54rClip", "762x51Clip", "762x54rStripperClip", "792x33Clip", "762Clip", "545Clip", "9mmClip", "9x39Clip", "45Clip", "44Clip", "223Clip", "308Clip", "M14Clip", "556Clip", "TheNailGunClip"},
        Attachments = {"ShellHolder", "Compensator", "MuzzleBrake", "HoloSight", "ReflexSight", "ProOpticScope", "CarryHandle", "VertGrip", "AngleGrip", "LaserNoLight", "WeaponLight", "WeaponLightMedium", "SuppressorRifle", "ButtStockWrap", "CompensatorHandgun", "MuzzleBrakeHandgun", "TacticalGrip", "SkeletonizedStock", "SuppressorPistol", "SuppressorSniper", "PEMScope", "PSO1Scope", "UniversalOpticalSight", "ChokeTubeFull", "ChokeTubeImproved", "Bayonnet", "BayonetImprovised", "GunLight", "Laser", "IronSight", "x2Scope", "x4Scope", "x8Scope", "RedDot", "FiberglassStock", "RecoilPad"},
        Skins = {"TanPlating", "BluePlating", "RedPlating", "GoldGunPlating", "RainbowPlating", "DZPlating", "RemingtonRiflesDarkCherryStock", "PinkPlating", "WoodStyledPlating", "WinterCamoPlating", "GreenGoldPlating", "RedWhitePlating", "AztecPlating"},
        Firearms = {"OA93", "L2A1", "EM2", "M4A1", "CrossbowCompound", "Pistol", "Pistol2", "Pistol3", "Revolver_Short", "Revolver_Long", "Revolver", "VarmintRifle", "HuntingRifle", "AssaultRifle", "AssaultRifle2", "Shotgun", "DoubleBarrelShotgun"},
        ExtensionFirearms = {"TheNailGun", "ASVal", "Glock", "WaltherPPK", "Makarov", "Derringer", "Remington1100", "GrozaOTs14", "M1Garand", "SIG550", "PM63RAK", "FranchiLF57", "HenryRepeatingBigBoy", "AK74", "TrenchGun"},
        RareExtensionFirearms= {"BeckerRevolver", "L85A1", "Galil", "VSSVintorez", "FiveSeven", "Luger", "PLR16", "MosinNagantObrez", "SVDDragunov", "BarrettM82A1", "MosinNagant", "StG44", "AK74U", "AK103", "P90", "M1918BAR"},
        RepairItems = {"FirearmLubricant", "FirearmCleaningKit", "FirearmRepairKit"}
    }

    function Recipe.OnCreate.OpenFirearmCache(items, result, player)
        local inventory = player:getInventory();
        local spawns = {
        }
    
        function addRandomItem(oType, count)
            for i = 1, count or 1
            do
                table.insert(spawns, HFE.cacheOptions[oType][ZombRand(#HFE.cacheOptions[oType] + 1)]);
            end
        end
    
        local r = ZombRand(1, 100);
    
        if r <= 25
        then
            addRandomItem("Ammo", 2);
            addRandomItem("Ammo", 2);
            addRandomItem("Ammo", 2);
            addRandomItem("AmmoMags");
        elseif r <= 45
        then
            addRandomItem("RepairItems");
            addRandomItem("Attachments");
        elseif r <= 60
        then
            addRandomItem("Skins");
            addRandomItem("Attachments");
        elseif r <= 75
        then
            addRandomItem("Skins");
            local tier1 = ZombRand(1, 10)
            if tier1 <= 5 then
                addRandomItem("Firearms");
            elseif tier1 <= 8 then
                addRandomItem("ExtensionFirearms");
            else
                addRandomItem("RareExtensionFirearms");
            end
        elseif r <= 90
        then
            local tier2 = ZombRand(1, 10)
            if tier2 <= 3 then
                addRandomItem("Firearms");
            elseif tier2 <= 8 then
                addRandomItem("ExtensionFirearms");
            else
                addRandomItem("RareExtensionFirearms");
            end
            addRandomItem("AmmoMags");
        else
            addRandomItem("Attachments");
            addRandomItem("Skins");
            local tier3 = ZombRand(1, 10)
            if tier3 <= 2 then
                addRandomItem("Firearms");
            elseif tier3 <= 5 then
                addRandomItem("ExtensionFirearms");
            else
                addRandomItem("RareExtensionFirearms");
            end
        end
        
        for i, itemId in ipairs(spawns)
        do
            inventory:AddItem("Base." .. itemId);
        end
    end
    
---------------------------
-- STRIPPER CLIP  54r FUNCTIONS--
---------------------------

function Recipe.OnCreate.FullyLoaded(item, result, player)
    result:setCurrentAmmoCount(result:getMaxAmmo());
end

function FullMag_Test(item)
	if item:getCurrentAmmoCount() == item:getMaxAmmo() then
		return true
	else	
        return false
	end
end

function Recipe.OnCreate.UndoStripper(item, result, player)
    player:getInventory():AddItems("Base.762x54rBullets", 1);
end

--------------------------------------------------------------------
-- SNIPER SUPPRESSOR WRAPS KEEP CONDITION FOR BREAKAGE CODE --
--------------------------------------------------------------------
function Recipe.OnCreate.SuppressorWrap(items, result, player)
    local suppressorItem = nil

    -- Find the Suppressor item in the list of items
    for i = 0, items:size() - 1 do
        if items:get(i):getType() == "Suppressor" then
            suppressorItem = items:get(i)
            break
        end
    end

    -- If a suppressor was found, set the result's condition
    if suppressorItem then
        result:setCondition(suppressorItem:getCondition())
    end
end