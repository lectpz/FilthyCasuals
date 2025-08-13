Config = require("QualityMenu/Config")
Utils = require("QualityMenu/Utils")
Tickets = {}

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
    local inv = player:getInventory()
    local items = inv:getItems()
    local tickets = {}

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        local itemName = item:getFullType()
        print("[Tickets][scanInventory] Checking item:", itemName)

        local stat, tier = Tickets.parseTicketName(itemName)
        if stat and tier then
            local tierName = "T" .. tier
            local tierBonus = Config.tiers[tierName]
            print(string.format("[Tickets][scanInventory] Valid ticket found: stat=%s tier=%s bonus=%.4f", stat, tierName,
                tierBonus or -1))
            if tierBonus then
                tickets[stat] = tickets[stat] or {}
                table.insert(tickets[stat], { item = item, tier = tierName, bonus = tierBonus })
            end
        end
    end

    print("[Tickets][scanInventory] Total ticket stats found:", Utils.tableCount(tickets))
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
