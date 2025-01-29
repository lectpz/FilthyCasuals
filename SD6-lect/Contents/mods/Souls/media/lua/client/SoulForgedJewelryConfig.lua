local Config = {}

Config.soulForgeBuffWeights = {
    ["luck"] = 5,
    ["SoulSmith"] = 5,
    ["SoulThirst"] = 5,
    ["SoulStrength"] = 1,
    ["SoulDexterity"] = 1,
    ["MaxCondition"] = 10,
    ["ConditionLowerChance"] = 10,
    ["CritRate"] = 10,
    ["CritMulti"] = 20,
    ["MaxDmg"] = 15,
}

Config.tierBuffs = {
    T1 = {"CritMulti", "SoulDexterity"},
    T2 = {"CritMulti", "SoulDexterity", "SoulThirst", "SoulSmith"},
    T3 = {"CritMulti", "SoulDexterity", "SoulThirst", "SoulSmith", "luck", "MaxCondition"},
    T4 = {"CritMulti", "SoulDexterity", "SoulThirst", "SoulSmith", "luck", "MaxCondition", "ConditionLowerChance", "CritRate"},
    T5 = {"CritMulti", "SoulDexterity", "SoulThirst", "SoulSmith", "luck", "MaxCondition", "ConditionLowerChance", "CritRate", "SoulStrength", "MaxDmg"}
}

Config.buffDisplayNames = {
    luck = "Luck",
    SoulSmith = "Soul Smith",
    SoulThirst = "Soul Thirst",
    SoulStrength = "Strength",
    SoulDexterity = "Dexterity",
    MaxCondition = "Durability",
    ConditionLowerChance = "Resilience",
    CritRate = "Critical Chance",
    CritMulti = "Critical Multiplier",
    MaxDmg = "Maximum Damage"
}

Config.validZones = {1, 2, 3, 4, 5}

Config.AccessorySlots = {
    "Right_MiddleFinger",
    "Left_MiddleFinger", 
    "Right_RingFinger",
    "Left_RingFinger",
    "BellyButton",
    "Neck",
    "Necklace",
    "Necklace_Long",
    "Nose",
    "Ears",
    "EarTop",
    "RightWrist",
    "LeftWrist"
}

return Config