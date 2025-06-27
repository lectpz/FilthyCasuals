local Menu = {}

local Tickets = require("QualityMenu/Tickets")
local Tooltip = require("QualityMenu/Tooltip")
local Utils = require("QualityMenu/Utils")
local Config = require("QualityMenu/Config")

function Menu.applyQualityTicket(weapon, statKey, ticket)
    if not statKey or not ticket then
        print("[Menu] Error: Missing statKey or ticket", statKey, ticket)
        return
    end

    print("[Menu] Applying ticket:", statKey, ticket.tier, ticket.bonus)
    Tickets.applyTicket(weapon, statKey, ticket)
    HaloTextHelper.addTextAbovePlayer(getPlayer(),
        "Applied " .. Tooltip.getDisplayName(statKey) .. " +" .. (ticket.bonus * 100) .. "%", 0, 1, 0)
end

function Menu.buildQualityTicketMenu(player, context, weapon, tickets)
    print("[Menu] Building quality ticket submenu")
    local modData = weapon:getModData()

    local parentOption = context:addOption("Quality Enhancer Tickets", weapon)
    local submenu = ISContextMenu:getNew(context)
    context:addSubMenu(parentOption, submenu)

    -- Show current bonuses
    submenu:addOption("Current Enhancer Multipliers:", weapon, nil).notAvailable = true
    for statKey, _ in pairs(Config.statMap) do
        local label = Tooltip.getDisplayName(statKey)
        local bonus = Utils.formatEnhancerBonus(modData, statKey)
        submenu:addOption("  " .. label .. ": " .. bonus, weapon, nil).notAvailable = true
    end

    local weaponType = weapon:isRanged() and "Ranged" or "Melee"
    local validStats = Config.soulStats[weaponType]

    -- Only show applicable ticket types
    for statKey, ticketList in pairs(tickets) do
        if Utils.contains(validStats, statKey) then
            table.sort(ticketList, function(a, b) return a.bonus > b.bonus end)

            local statSubmenu = ISContextMenu:getNew(context)
            submenu:addSubMenu(submenu:addOption(Tooltip.getDisplayName(statKey) .. " Tickets"), statSubmenu)

            statSubmenu:addOption("Apply All Tickets", nil, function()
                for _, ticket in ipairs(ticketList) do
                    Menu.applyQualityTicket(weapon, statKey, ticket)
                    getSpecificPlayer(player):getInventory():Remove(ticket.item)
                end
            end)

            for _, ticket in ipairs(ticketList) do
                local label = string.format("%s | %s | +%.2f%%", Tooltip.getDisplayName(statKey), ticket.tier,
                    ticket.bonus * 100)
                local opt = statSubmenu:addOption(label, weapon, Menu.applyQualityTicket, weapon, statKey, ticket)
                Tooltip.attachSimpleTooltip(opt, Tooltip.getDisplayName(statKey),
                    "Enhances this stat by +" .. (ticket.bonus * 100) .. "%")
            end
        end
    end
end

function Menu.addMenu(player, context, items)
    print("[QualityMenu] addMenu called")
    local weapon = Utils.getForgeableWeapon(items)
    if not weapon then return end

    print("[QualityMenu] Found weapon:", weapon:getName())
    print("[QualityMenu] Current modData:")
    for k, v in pairs(weapon:getModData()) do print("  ", k, v) end

    local tickets = Tickets.scanInventory(getSpecificPlayer(player))
    if not tickets then
        print("[QualityMenu] No quality tickets found")
        return
    end

    Menu.buildQualityTicketMenu(player, context, weapon, tickets)
end

Events.OnFillInventoryObjectContextMenu.Add(Menu.addMenu)

return Menu
