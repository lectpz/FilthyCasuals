local SoulForgeMenu = require("SoulForgeMenu")
local Config = require("SoulForgedConfig")
local TooltipUtils = require("SoulForgedTooltipUtils")

local function SoulPowerTestMenu(player, context, items)
    local weapon = SoulForgeMenu.getForgeableWeapon(items)
    if not weapon then return end

    local option = context:addOption("Soul Power [Test Version]")
    local submenu = ISContextMenu:getNew(context)
    context:addSubMenu(option, submenu)

    local modData = weapon:getModData()

    -- Prefix/Suffix section (fully driven by Config.prefixSuffixMap)
    for label, key in pairs(Config.prefixSuffixMap) do
        local value = modData[key]
        if key == "Augments" then
            value = value or 0
        else
            value = value or "None"
        end
        submenu:addOption(label .. ": " .. tostring(value))
    end

    -- Stat section (fully driven by Config.statMap)
    for displayStat, modDataKey in pairs(Config.statMap) do
        local val = modData[modDataKey]
        if val then
            local label = TooltipUtils.getDisplayName(displayStat)
            -- Only show non-zero bonuses
            local bonusPercent = (val - 1.0) * 100
            submenu:addOption(label .. ": +" .. string.format("%.2f", bonusPercent) .. "%")
        end
    end

    -- Keep your existing Quality Ticket submenu functional for now
    local qualityTickets = require("SoulForgeQualityTickets").scanInventory(getSpecificPlayer(player))
    if not qualityTickets or not next(qualityTickets) then return end

    SoulForgeMenu.buildQualityTicketMenu(player, submenu, weapon, qualityTickets)
end

Events.OnFillInventoryObjectContextMenu.Add(SoulPowerTestMenu)
