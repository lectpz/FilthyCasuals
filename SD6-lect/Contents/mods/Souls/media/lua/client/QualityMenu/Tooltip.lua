Tooltip = {}

Tooltip.AugmentColors = {
    [0] = "<RGB:1,1,1>",
    [1] = "<RGB:0.2,0.5,1>",
    [2] = "<RGB:1,1,0>",
    [3] = "<RGB:0.62,0.12,0.94>",
    [4] = "<RGB:0.83,0.68,0.21>"
}

Tooltip.DisplayNames = {
    MaxDmg = "Max Dmg",
    MinDmg = "Min Dmg",
    CriticalChance = "Crit Chance",
    CritDmgMultiplier = "Crit Dmg Multi",
    AimingPerkCritModifier = "Aiming Crit Mod",
    AimingPerkHitChanceModifier = "Aiming Hit Mod",
    AimingTime = "Aiming Time",
    AimingPerkRangeModifier = "Aiming Range Mod",
    MaxHitCount = "Max Hit Count",
    ProjectileCount = "Projectile Count",
    PiercingBullets = "Piercing"
}

function Tooltip.attachSimpleTooltip(option, label, description, color)
    if not option then return end

    local tooltip = ISToolTip:new()
    tooltip:initialise()
    tooltip:setVisible(false)

    tooltip.description = (color or "") .. "**" .. label .. "**" .. " <LINE> " .. description

    option.toolTip = tooltip
end

function Tooltip.getAugmentColor(augmentNo)
    local color = Tooltip.AugmentColors[augmentNo] or Tooltip.AugmentColors[0]
    return color
end

function Tooltip.getDisplayName(statKey)
    return Tooltip.DisplayNames[statKey] or statKey
end

return Tooltip
