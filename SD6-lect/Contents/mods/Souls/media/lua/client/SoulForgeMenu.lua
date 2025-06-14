SoulForgeMenu = {}

local QualityTickets = require("SoulForgeQualityTickets")
local TooltipUtils = require("SoulForgedTooltipUtils")
local WeaponUtils = require("SoulForgedWeaponUtils")
local Config = require("SoulForgedConfig")

function SoulForgeMenu.addMenu(player, context, items)
    local weapon = SoulForgeMenu.getSelectedWeapon(items)

    if not weapon then return end

    local qualityTickets = QualityTickets.scanInventory(getSpecificPlayer(player))

    if not qualityTickets then return end
    
    SoulForgeMenu.buildQualityTicketMenu(player, context, weapon, qualityTickets)
    -- Future features would need SoulForgeMenu.build(feature)Menu
end

function SoulForgeMenu.getSelectedWeapon(items)
    for _, entry in ipairs(items) do
        if instanceof(entry, "InventoryItem") and entry:IsWeapon() then
            return entry
        end
    end
end

function SoulForgeMenu.buildQualityTicketMenu(player, context, weapon, qualityTickets)
    local 
