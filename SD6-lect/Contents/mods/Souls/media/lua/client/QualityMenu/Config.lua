local Config = {}

Config.soulStats = {
    Melee = {
        "MaxDmg",
        "MinDmg",
        "CriticalChance",
        "CritDmgMultiplier"
    },
    Ranged = {
        "AimingPerkCritModifier",
        "AimingPerkHitChanceModifier",
        "AimingTime",
        "AimingPerkRangeModifier",
        "MaxHitCount",
        "MaxDmg",
        "MinDmg",
        "CriticalChance",
        "CritDmgMultiplier"
    },
}

Config.statMap = {
    MaxDmg = "soulForgeMaxDmgMulti",
    MinDmg = "soulForgeMinDmgMulti",
    CriticalChance = "soulForgeCritRate",
    CritDmgMultiplier = "soulForgeCritMulti",
    ConditionMax = "MaxCondition",
    ConditionLowerChance = "ConditionLowerChance",
    EnduranceMod = "EnduranceMod",
    MaxHitCount = "MaxHitCount",

    -- Ranged-only stats
    AimingPerkCritModifier = "soulForgeAimingPerkCritModifier",
    AimingPerkHitChanceModifier = "soulForgeAimingPerkHitChanceModifier",
    AimingTime = "soulForgeAimingTime",
    AimingPerkRangeModifier = "soulForgeAimingPerkRangeModifier",
    ProjectileCount = "ProjectileCount",
    PiercingBullets = "PiercingBullets"
}

Config.tiers = {
    T1 = 0.001,
    T2 = 0.002,
    T3 = 0.004,
    T4 = 0.008,
    T5 = 0.016
}

return Config
