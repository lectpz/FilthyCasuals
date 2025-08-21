local Tooltip = {}

local AUGMENT_COLORS = {
    [0] = "<RGB:1,1,1>",
    [1] = "<RGB:0.2,0.5,1>",
    [2] = "<RGB:1,1,0>",
    [3] = "<RGB:0.62,0.12,0.94>",
    [4] = "<RGB:0.83,0.68,0.21>",
}

local DISPLAY_NAMES = {
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
    PiercingBullets = "Piercing",
}

local function buildTooltip(description)
    local tt = ISToolTip:new()
    tt:initialise()
    tt:setVisible(false)
    tt.description = description
    return tt
end

local function formatHeader(label, colorTag)
    local color = colorTag or ""
    return string.format("%s**%s**", color, tostring(label or ""))
end

function Tooltip.getAugmentColor(augmentNo)
    local color = AUGMENT_COLORS[augmentNo] or AUGMENT_COLORS[0]
    --print(string.format("[Tooltip] getAugmentColor(%s) -> %s", tostring(augmentNo), tostring(color)))
    return color
end

function Tooltip.getDisplayName(statKey)
    local name = DISPLAY_NAMES[statKey] or statKey
    --print(string.format("[Tooltip] getDisplayName(%s) -> %s", tostring(statKey), tostring(name)))
    return name
end

function Tooltip.attachSimpleTooltip(option, label, description, colorOrOpts)
    if not option then
        --print("[Tooltip] attachSimpleTooltip: nil option; abort")
        return
    end

    local color = nil
    if type(colorOrOpts) == "string" then
        color = colorOrOpts
    elseif type(colorOrOpts) == "table" then
        if colorOrOpts.augment ~= nil then
            color = Tooltip.getAugmentColor(colorOrOpts.augment)
        else
            color = colorOrOpts.color
        end
    end

    local header = formatHeader(label, color)
    local body   = tostring(description or "")
    local desc   = string.format("%s <LINE> %s", header, body)

    --print(string.format("[Tooltip] attachSimpleTooltip: label='%s' color='%s' len=%d",
        --tostring(label), tostring(color), #desc))

    option.toolTip = buildTooltip(desc)
end

function Tooltip.attachTooltip(option, tooltip)
    if not option or not tooltip then
        --print(string.format("[Tooltip] attachTooltip: invalid args option=%s tooltip=%s",
            --tostring(option), tostring(tooltip)))
        return
    end
    option.toolTip = tooltip
    --print("[Tooltip] attachTooltip: tooltip attached")
end

return Tooltip
