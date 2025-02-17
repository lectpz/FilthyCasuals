Events.OnGameStart.Add(function()
    local function applyDoParam(itemList, displayCategory)
        for _, itemName in ipairs(itemList) do
            local item = ScriptManager.instance:getItem("Base." .. itemName)
            if item then
                item:DoParam("DisplayCategory = " .. displayCategory)
            else
                --print("Item not found: " .. itemName)
            end
        end
    end

    if getActivatedMods():contains("BetterSortCC") then
        --print("Better Sorting Loaded")
        
        local categories = {
            Ammo = {"223Box", "308Box", "556Box", "Bullets38Box", "Bullets44Box", "Bullets45Box", "Bullets9mmBox", "ShotgunShellsBox", 
                    "AmmoCanUnopened", "223Bullets", "308Bullets", "556Bullets", "Bullets38", "Bullets44", "Bullets45", "Bullets9mm", "ShotgunShells"},
            Container = {"AmmoCan", "RifleCase1", "RifleCase2", "RifleCase3", "ShotgunCase1", "ShotgunCase2", "PistolCase1", 
                         "PistolCase2", "PistolCase3", "RevolverCase1", "RevolverCase2", "RevolverCase3"},
            Tool = {"FirearmLubricant", "FirearmCleaningKit", "FirearmRepairKit"},
            WepAmmoMag = {"223Clip", "308Clip", "556Clip", "44Clip", "45Clip", "9mmClip", "M14Clip"},
            WepPart = {"AmmoStrap_Bullets", "AmmoStrap_Shells", "AmmoStraps", "ChokeTubeFull", "ChokeTubeImproved", "FiberglassStock", 
                       "GunLight", "Laser", "IronSight", "RecoilPad", "RedDot", "Sling", "x2Scope", "x4Scope", "x8Scope"},
            WepFire = {"AssaultRifle", "AssaultRifle2", "DoubleBarrelShotgun", "DoubleBarrelShotgunSawnoff", "HuntingRifle", "Pistol", 
                       "Pistol2", "Pistol3", "Revolver", "Revolver_Long", "Revolver_Short", "Shotgun", "ShotgunSawnoff", "VarmintRifle"},
            WepMelee = {"AssaultRifle_Melee", "AssaultRifle2_Melee", "DoubleBarrelShotgun_Melee", "DoubleBarrelShotgunSawnoff_Melee", 
                        "HuntingRifle_Melee", "Pistol_Melee", "Pistol2_Melee", "Pistol3_Melee", "Revolver_Melee", "Revolver_Long_Melee", 
                        "Revolver_Short_Melee", "Shotgun_Melee", "ShotgunSawnoff_Melee", "VarmintRifle_Melee"}
        }

        local modItems = {
            HayesFirearmsExtension = {
                Ammo = {"3006Box", "3006Bullets", "380Box", "545Box", "57Box", "762Box", "762x51Box", "762x54rBox", "792Box", "792x33Box", 
                        "50BMGBox", "9x39Box", "CrossbowBoltBox", "380Bullets", "545Bullets", "57Bullets", "762Bullets", "762x51Bullets", 
                        "762x54rBullets", "792Bullets", "792x33Bullets", "50BMGBullets", "9x39Bullets", "CrossbowBolt"},
                Tool = {"FirearmCache"},
                WepAmmoMag = {"3006BlocClip", "3006Clip", "380Clip", "545Clip", "57Clip", "P90Clip", "762Clip", "762x51Clip", "9mmBoxClip", "9mmClip8", 
                              "9mmClip32", "45Clip13", "45Clip20", "223Clip10", "762x54rClip", "762x54rStripperClip", "792Clip", "792Drum", "792x33Clip", 
                              "50BMGClip", "TheNailGunClip", "Mag9ExtSm", "Mag9ExtLg", "Mag9Drum", "Mag57ExtSm", "Mag57ExtLg", "Mag57Drum", "MagLugerExtSm", 
                              "MagLugerExtLg", "MagLugerDrum", "Mag380ExtSm", "Mag380ExtLg", "Mag380Drum", "Mag44ExtSm", "Mag44ExtLg", "Mag45ExtSm", 
                              "Mag45ExtLg", "Mag45Drum", "MagMosinNagantExtSm", "MagPM63RAKExtLg", "Mag223ExtLg", "MagM1GarandExtSm", "Mag3006ExtLg", 
                              "Mag308ExtSm", "MagSVDExtSm", "Mag50BMGExtSm", "Mag762x51ExtSm", "Mag762x51ExtLg", "MagMP28ExtLg", "Mag9x39ExtSm", "Mag9x39ExtLg"},
                WepPart = {"SkeletonizedStock", "SuppressorPistol", "SuppressorSniper", "SuppressorSniperWinter", "SuppressorSniperDesert", 
                           "SuppressorSniperWoodland", "SuppressorRifle", "Compensator", "MuzzleBrake", "CompensatorHandgun", "MuzzleBrakeHandgun", "PEMScope", 
                           "PSO1Scope", "UniversalOpticalSight", "TacticalGrip", "HoloSight", "ReflexSight", "ProOpticScope", "IronSightsFG42", "ScopeFG42", 
                           "CarryHandle", "VertGrip", "AngleGrip", "LaserRed", "LaserGreen", "LaserNoLight", "WeaponLight", "WeaponLightMedium", "ButtStockWrap", 
                           "ShellHolder", "TanPlating", "BluePlating", "RedPlating", "Colt1911PatriotPlating", "GoldGunPlating", "DesertEagleGoldPlating", 
                           "GoldShotgunPlating", "RainbowPlating", "RainbowAnodizedPlating", "DZPlating", "RemingtonRiflesDarkCherryStock", "WinterCamoPlating", 
                           "MatteBlackPlating", "WoodStyledPlating", "PinkPlating", "CrabShellPlating", "YellowPlating", "GreenPlating", "RedWhitePlating", 
                           "GreenGoldPlating", "SteelDamascusPlating", "SalvagedRagePlating", "ZoidbergSpecialPlating", "ShenronPlating", "NerfPlating", 
                           "BespokeEngravedPlating", "SurvivalistPlating", "MysteryMachinePlating", "SalvagedBlackPlating", "PearlPlating", "AztecPlating", 
                           "PlankPlating", "BlackIcePlating", "BlackDeathPlating", "OrnateIvoryPlating", "GildedAgePlating", "TBDPlating", "CannabisPlating"},
                WepFire = {"Glock", "FiveSeven", "Luger", "WaltherPPK", "Makarov", "Derringer", "ColtCavalryRevolver", "CrossbowCompound", "PLR16", 
                           "MosinNagantObrez", "OA93", "TheNailGun", "AK74U", "AK74U_Folded", "FranchiLF57", "FranchiLF57_Folded", "MiniUzi", "MiniUzi_Folded", "P90", 
                           "MP28", "AK103", "AK74", "PM63RAK", "PM63RAK_Grip", "PM63RAK_Extended", "PM63RAK_GripExtended", "HenryRepeatingBigBoy", "GrozaOTs14", 
                           "M1918BAR", "M1918BAR_Bipod", "M1Garand", "SIG550", "StG44", "MosinNagant", "L2A1", "L2A1_Bipod", "EM2", "L85A1", "ASVal", "ASVal_Folded", 
                           "M4A1", "FG42", "FG42_Bipod", "MG42", "MG42_Bipod", "BarrettM82A1", "BarrettM82A1_Bipod", "SVDDragunov", "Galil", "Galil_Bipod",
                           "VSSVintorez", "Remington1100", "TrenchGun", "BeckerRevolver"},
                WepMelee = {"Glock_Melee", "FiveSeven_Melee", "Luger_Melee", "WaltherPPK_Melee", "Makarov_Melee", "Derringer_Melee", "ColtCavalryRevolver_Melee", 
                            "CrossbowCompound_Melee", "PLR16_Melee", "MosinNagantObrez_Melee", "OA93_Melee", "TheNailGun_Melee", "AK74U_Melee", "AK74U_Folded_Melee", 
                            "FranchiLF57_Melee", "FranchiLF57_Folded_Melee", "MiniUzi_Melee", "MiniUzi_Folded_Melee", "P90_Melee", "MP28_Melee", "AK103_Melee", 
                            "AK74_Melee", "PM63RAK_Melee", "PM63RAK_Extended_Melee", "HenryRepeatingBigBoy_Melee", "GrozaOTs14_Melee", "M1918BAR_Melee", 
                            "M1Garand_Melee", "SIG550_Melee", "StG44_Melee", "MosinNagant_Melee", "L2A1_Melee", "EM2_Melee", "L85A1_Melee", "ASVal_Melee", 
                            "M4A1_Melee", "FG42_Melee", "MG42_Melee", "BarrettM82A1_Melee", "SVDDragunov_Melee", "Galil_Melee", "VSSVintorez_Melee", 
                            "Remington1100_Melee", "TrenchGun_Melee", "BeckerRevolver_Melee"}
            }
        }

        -- Add mod items if the mod is activated
        for modName, modCategories in pairs(modItems) do
            if getActivatedMods():contains(modName) then
                --print("Adding items from mod: " .. modName)
                for category, items in pairs(modCategories) do
                    for _, item in ipairs(items) do
                        table.insert(categories[category], item)
                    end
                end
            end
        end

        -- Apply DoParam to each category
        for category, items in pairs(categories) do
            applyDoParam(items, category)
        end
    end
end);