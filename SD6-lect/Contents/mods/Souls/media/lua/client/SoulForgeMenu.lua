SoulForgeMenu = {}

local QualityTickets = require("SoulForgeQualityTickets")
local TooltipUtils = require("SoulForgedTooltipUtils")
local WeaponUtils = require("SoulForgedWeaponUtils")
local Config = require("SoulForgedConfig")

function SoulForgeMenu.addMenu(player, context, items)
    local weapon = SoulForgeMenu.getForgeableWeapon(items)

    if not weapon then return end

    local qualityTickets = QualityTickets.scanInventory(getSpecificPlayer(player))

    if not qualityTickets then return end

    SoulForgeMenu.buildQualityTicketMenu(player, context, weapon, qualityTickets)
    -- Future features would need SoulForgeMenu.build(feature)Menu
end

function SoulForgeMenu.getForgeableWeapon(items)
    for _, entry in ipairs(items) do
        if instanceof(entry, "InventoryItem") and entry:IsWeapon() then
            return entry
        end
    end
    return nil
end

function SoulForgeMenu.buildQualityTicketMenu(player, context, weapon, qualityTickets)
    -- Don't build menu if no tickets exist
    if not qualityTickets or not next(qualityTickets) then return end

    -- Create parent menu option
    local option = context:addOption("SoulForge: Apply Quality Modifier")
    local submenu = ISContextMenu:getNew(context)
    context:addSubMenu(option, submenu)

    -- Loop through each stat group
    for stat, ticketList in pairs(qualityTickets) do
        for _, ticket in ipairs(ticketList) do
            -- Build the display label using your TooltipUtils
            local displayName = TooltipUtils.buildTicketOptionLabel(stat, ticket.bonus, ticket.tier)

            -- Add option to submenu
            submenu:addOption(
                displayName,
                SoulForgeMenu.applyQualityTicket, -- callback function when clicked
                player,
                stat,
                weapon,
                ticket
            )
        end
    end
end

function SoulForgeMenu.applyQualityTicket(player, weapon, stat, ticket)
    -- Apply the ticket via QualityTickets system
    QualityTickets.applyTicket(weapon, stat, ticket)

    -- Optional feedback (HaloText popup)
    HaloTextHelper.addText(weapon:getContainer():getParent(), "Quality Augment Applied!", true)
end
