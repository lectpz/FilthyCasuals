local HFO = HFO or {}

local firearmsStats = {}
local meleeFirearmStats = {}

local sVars = SandboxVars.HFO
sVars.DamageStats = sVars.DamageStats or 10
sVars.MeleeDamageStats = sVars.MeleeDamageStats or 0
sVars.RangeStats = sVars.RangeStats or 10
sVars.AngleStats = sVars.AngleStats or 10
sVars.ConditionStats = sVars.ConditionStats or 10
sVars.SoundStats = sVars.SoundStats or 10

local function initializeFirearmStats()
    local gunWeaponNames = {
        "Pistol", "Pistol2", "Pistol3", "Revolver_Short", "Revolver", "Revolver_Long",
        "VarmintRifle", "HuntingRifle", "AssaultRifle", "AssaultRifle2", "Shotgun", "ShotgunSawnoff"
    }

    local function addGunItems(modName, weapons)
        if getActivatedMods():contains(modName) then
            for _, weapon in ipairs(weapons) do
                table.insert(gunWeaponNames, weapon)
            end
        end
    end

    addGunItems("HayesFirearmsExtension", {"Glock", "FiveSeven", "Luger", "WaltherPPK", "Makarov", "Derringer", "PLR16", "MosinNagantObrez", "AK74U", 
        "AK74U_Folded", "FranchiLF57", "FranchiLF57_Folded", "MiniUzi", "MiniUzi_Folded", "P90", "PM63RAK", "PM63RAK_Grip",
        "PM63RAK_Extended", "PM63RAK_GripExtended", "AK103", "AK74", "HenryRepeatingBigBoy", "GrozaOTs14", "M1918BAR", "M1918BAR_Bipod", 
        "FG42", "FG42_Bipod", "M4A1", "ColtCavalryRevolver", "CrossbowCompound", "MG42", "MG42_Bipod",  
        "TheNailGun", "OA93", "L2A1", "L2A1_Bipod", "EM2", "L85A1", "ASVal", "ASVal_Folded", "Galil", "Galil_Bipod", "VSSVintorez", "BeckerRevolver",
        "M1Garand", "SIG550", "StG44", "MosinNagant", "BarrettM82A1", "BarrettM82A1_Bipod", "SVDDragunov", "Remington1100", "TrenchGun"
    })

    for _, weaponName in ipairs(gunWeaponNames) do
        local weapon = ScriptManager.instance:getItem(weaponName)
        if weapon ~= nil and weapon:getTypeString() == "Weapon" and weapon:isRanged() then
            firearmsStats[weaponName] = {
                minDamage = weapon:getMinDamage(),
                maxDamage = weapon:getMaxDamage(),
                maxRange = weapon:getMaxRange(),
                minAngle = weapon:getMinAngle(),
                conditionMax = weapon:getConditionMax(),
                conditionLower = weapon:getConditionLowerChance(),
                soundRadius = weapon:getSoundRadius(),
                soundVolume = weapon:getSoundVolume(),
            }
        end
    end
end

-- Function to initialize melee stats
local function initializeMeleeStats()
    local meleeExceptions = {
        ["BarrettM82A1_Bipod_Melee"] = true,
        ["M1918BAR_Bipod_Melee"] = true,
        ["PM63RAK_GripExtended_Melee"] = true,
        ["PM63RAK_Grip_Melee"] = true
    }

    for weaponName, stats in pairs(firearmsStats) do
        local meleeWeaponName = weaponName .. "_Melee"
        if not meleeExceptions[meleeWeaponName] then
            local weapon = ScriptManager.instance:getItem(meleeWeaponName)
            if weapon ~= nil and weapon:getTypeString() == "Weapon" then
                meleeFirearmStats[meleeWeaponName] = {
                    meleeMinDamage = weapon:getMinDamage(),
                    meleeMaxDamage = weapon:getMaxDamage(),
                    meleeConditionMax = weapon:getConditionMax(),
                    meleeConditionLower = weapon:getConditionLowerChance(),
                }
            end
        end
    end
end

-- Function to apply stats to firearms
local function applyStatsToFirearms(weaponName, firearmStats, sVars)
    local weapon = ScriptManager.instance:getItem(weaponName)
    if weapon then
        weapon:DoParam("MaxDamage = " .. math.max(0.4, math.floor(firearmStats.maxDamage * sVars.DamageStats) / 10))
        weapon:DoParam("MinDamage = " .. math.max(0.1, math.floor(firearmStats.minDamage * sVars.DamageStats) / 10))
        weapon:DoParam("MaxRange = " .. math.max(1, math.floor(firearmStats.maxRange * sVars.RangeStats / 10)))
        weapon:DoParam("MinAngle = " .. math.min(1.100, math.max(0.610, math.floor(firearmStats.minAngle * sVars.AngleStats * 100) / 1000)))
        weapon:DoParam("ConditionMax = " .. math.max(5, math.floor(firearmStats.conditionMax * sVars.ConditionStats / 10)))
        weapon:DoParam("ConditionLowerChanceOneIn = " .. math.max(15, math.floor(firearmStats.conditionLower * sVars.ConditionStats / 10)))
        weapon:DoParam("SoundRadius = " .. math.max(5, math.floor(firearmStats.soundRadius * sVars.SoundStats / 10)))
        weapon:DoParam("SoundVolume = " .. math.max(5, math.floor(firearmStats.soundVolume * sVars.SoundStats / 10)))
    end
end

-- Function to apply stats to melee firearms
local function applyStatsToMeleeFirearms(weaponName, meleeFirearmStats, sVars)
    local weapon = ScriptManager.instance:getItem(weaponName)
    if weapon then
        weapon:DoParam("MaxDamage = " .. math.max(0.2, meleeFirearmStats.meleeMaxDamage + (sVars.MeleeDamageStats * 0.1)))
        weapon:DoParam("MinDamage = " .. math.max(0.1, meleeFirearmStats.meleeMinDamage + (sVars.MeleeDamageStats * 0.1)))
        weapon:DoParam("ConditionMax = " .. math.max(5, math.floor(meleeFirearmStats.meleeConditionMax * sVars.ConditionStats / 10)))
    end
end

-- Event handler for game start
Events.OnGameStart.Add(function()
    --print("Starting firearm initialization...")
    initializeFirearmStats()
    initializeMeleeStats()

    for weaponName, stats in pairs(firearmsStats) do
        applyStatsToFirearms(weaponName, stats, sVars)
    end

    for weaponName, stats in pairs(meleeFirearmStats) do
        applyStatsToMeleeFirearms(weaponName, stats, sVars)
    end

    --print("Firearm initialization complete.")
end)