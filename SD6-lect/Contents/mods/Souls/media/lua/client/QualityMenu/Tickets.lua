local Tickets = {}

local Config = require("QualityMenu/Config")
local Utils = require("QualityMenu/Utils")

function Tickets.parseTicketName(fullItemString)
    print("[Tickets][parseTicketName] Called with:", fullItemString)
    local stat, tierNum = string.match(fullItemString, "^SoulForge%.mdz(%a+)_EnhancerT(%d+)$")
    if not stat or not tierNum then
        print("[Tickets][parseTicketName] No match")
        return nil
    end
    print("[Tickets][parseTicketName] Parsed stat:", stat, "tierNum:", tierNum)
    return stat, tierNum
end

function Tickets.scanInventory(player)
    print("[Tickets][scanInventory] Scanning inventory for quality tickets...")
    if not player then
        print("[Tickets][scanInventory] ERROR: player is nil"); return {}
    end

    local inv = player.getInventory and player:getInventory() or nil
    if not inv then
        print("[Tickets][scanInventory] ERROR: inventory is nil"); return {}
    end

    local ok, items = pcall(function() return inv:getItems() end)
    if not ok or not items then
        print("[Tickets][scanInventory] ERROR: getItems() failed"); return {}
    end

    local tickets, size = {}, items:size()
    for i = 0, size - 1 do
        local it = items:get(i)
        local ft = it and it:getFullType() or ""
        print("[Tickets][scanInventory] Checking item:", ft)
        local stat, tier = Tickets.parseTicketName(ft)
        if stat and tier then
            local tierName, tierBonus = "T" .. tier, Config.tiers["T" .. tier]
            print(string.format("[Tickets][scanInventory] Valid ticket: %s %s bonus=%.4f", stat, tierName,
                tierBonus or -1))
            if tierBonus then
                tickets[stat] = tickets[stat] or {}
                table.insert(tickets[stat], { item = it, tier = tierName, bonus = tierBonus })
            end
        end
    end

    local buckets = 0; for _ in pairs(tickets) do buckets = buckets + 1 end
    print("[Tickets][scanInventory] Total ticket stats found:", buckets)
    return tickets
end

function Tickets.applyTicket(weapon, statKey, ticket)
    print(string.format("[Tickets][applyTicket] Applying ticket: %s | Tier %s | Bonus %.3f", statKey, ticket.tier,
        ticket.bonus))
    Utils.applyStatBonus(weapon, statKey, ticket.bonus)
    local modData = weapon:getModData()
    modData.Augments = (modData.Augments or 0) + 1
    print("[Tickets][applyTicket] New Augments count:", modData.Augments)
end

return Tickets
