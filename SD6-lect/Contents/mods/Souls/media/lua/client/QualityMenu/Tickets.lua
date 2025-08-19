local Config         = require("QualityMenu/Config")
local Utils          = require("QualityMenu/Utils")

local Tickets        = {}

local TICKET_PATTERN = "^SoulForge%.mdz?(%a+)_EnhancerT(%d+)$"

function Tickets.parseTicketName(fullType)
    if type(fullType) ~= "string" then
        print(string.format("[Tickets] parseTicketName: invalid type (%s)", tostring(fullType)))
        return nil
    end
    local stat, tierNum = string.match(fullType, TICKET_PATTERN)
    if not stat or not tierNum then
        print(string.format("[Tickets] parseTicketName: no match for '%s'", fullType))
        return nil
    end
    print(string.format("[Tickets] parseTicketName: stat=%s tierNum=%s", stat, tierNum))
    return stat, tierNum
end

local function addTicket(ticketsByStat, stat, item, tierNum)
    local tierName  = "T" .. tostring(tierNum)
    local tierBonus = Config.tiers[tierName]
    if not tierBonus then
        print(string.format("[Tickets] addTicket: unknown tier '%s' for stat '%s'", tostring(tierName), tostring(stat)))
        return
    end
    ticketsByStat[stat] = ticketsByStat[stat] or {}
    table.insert(ticketsByStat[stat], {
        item  = item,
        tier  = tierName,
        bonus = tierBonus,
    })
    print(string.format("[Tickets] addTicket: +%s (%s=%.4f) queued", tostring(stat), tierName, tierBonus))
end

-- Scan the player's inventory for enhancer tickets. Returns table: stat -> {tickets...}
function Tickets.scanInventory(player)
    if not player or not player.getInventory then
        print("[Tickets] scanInventory: invalid player object")
        return {}
    end

    print("[Tickets] Scanning inventory for quality tickets...")
    local inv   = player:getInventory()
    local items = inv and inv:getItems()
    if not items then
        print("[Tickets] scanInventory: no items found")
        return {}
    end

    local ticketsByStat = {}
    local count = items:size()
    print(string.format("[Tickets] scanInventory: %d items", count))

    for i = 0, count - 1 do
        local item     = items:get(i)
        local fullType = item and item:getFullType()
        print(string.format("[Tickets] Inspect #%d: %s", i, tostring(fullType)))
        if fullType then
            local stat, tierNum = Tickets.parseTicketName(fullType)
            if stat and tierNum then
                addTicket(ticketsByStat, stat, item, tierNum)
            end
        end
    end

    for stat, list in pairs(ticketsByStat) do
        print(string.format("[Tickets] Found %d ticket(s) for stat '%s'", #list, stat))
    end

    return ticketsByStat
end

function Tickets.applyTicket(weapon, statKey, ticket)
    if not weapon or not statKey or not ticket then
        print(string.format("[Tickets] applyTicket: invalid args weapon=%s statKey=%s ticket=%s",
            tostring(weapon), tostring(statKey), tostring(ticket)))
        return
    end

    local md = weapon:getModData()
    if not (md and md.mdzPrefix) then
        print(string.format("[Tickets] applyTicket: weapon missing mdzPrefix; abort (%s)", tostring(weapon:getName())))
        return
    end

    local tierBonus = ticket.bonus or 0
    print(string.format("[Tickets] Applying ticket: stat=%s | tier=%s | bonus=%.4f on %s (mdzPrefix=%s)",
        tostring(statKey), tostring(ticket.tier), tierBonus, tostring(weapon:getName()), tostring(md.mdzPrefix)))

    Utils.applyStatBonus(weapon, statKey, tierBonus)

    md.Augments = (md.Augments or 0) + 1
    print(string.format("[Tickets] applyTicket: Augments=%d", md.Augments or 0))
end

return Tickets
