local Config         = require("QualityMenu/Config")
local Utils          = require("QualityMenu/Utils")

local Tickets        = {}

local TICKET_PATTERN = "^SoulForge%.mdz?(%a+)_EnhancerT(%d+)$"

function Tickets.parseTicketName(fullType)
    if type(fullType) ~= "string" then
        return nil
    end
    local stat, tierNum = string.match(fullType, TICKET_PATTERN)
    if not stat or not tierNum then
        return nil
    end
    return stat, tierNum
end

local function addTicket(ticketsByStat, stat, item, tierNum)
    local tierName  = "T" .. tostring(tierNum)
    local tierBonus = Config.tiers[tierName]
    if not tierBonus then
        return
    end
    ticketsByStat[stat] = ticketsByStat[stat] or {}
    table.insert(ticketsByStat[stat], {
        item  = item,
        tier  = tierName,
        bonus = tierBonus,
    })
end

-- Scan the player's inventory for enhancer tickets. Returns table: stat -> {tickets...}
function Tickets.scanInventory(player)
    if not player or not player.getInventory then
        return {}
    end

    local inv   = player:getInventory()
    local items = inv and inv:getItems()
    if not items then
        return {}
    end

    local ticketsByStat = {}
    local count = items:size()

    for i = 0, count - 1 do
        local item     = items:get(i)
        local fullType = item and item:getFullType()
        if fullType then
            local stat, tierNum = Tickets.parseTicketName(fullType)
            if stat and tierNum then
                addTicket(ticketsByStat, stat, item, tierNum)
            end
        end
    end

    return ticketsByStat
end

function Tickets.applyTicket(weapon, statKey, ticket)
    if not weapon or not statKey or not ticket then
        return false
    end

    local md = weapon:getModData()
    if not (md and md.mdzPrefix) then
        return false
    end

    local tierBonus = ticket.bonus or 0

    local applyStatBonus = Utils.applyStatBonus(weapon, statKey, tierBonus)
	
	if not applyStatBonus then return false end

    --md.Augments = (md.Augments or 0) + 1
	
	return true
end

return Tickets
