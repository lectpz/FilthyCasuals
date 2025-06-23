Config = require("QualityMenu/Config")
Utils = require("QualityMenu/Utils")
Tickets = {}

function Tickets.parseTicketName(fullItemString)
    local stat, tierNum = string.match(fullItemString, "^SoulForge%.(.-)_EnhancerT(%d+)$")
    if not stat or not tierNum then return nil end
    return stat, tierNum
end

function Tickets.scanInventory(player)
    print("[Tickets] Scanning inventory for quality tickets...")
    local inv = player:getInventory()
    local items = inv:getItems()
    local tickets = {}

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        local itemName = item:getFullType()

        local stat, tier = Tickets.parseTicketName(itemName)
        if stat and tier then
            local tierName = "T" .. tier
            local tierBonus = Config.tiers[tierName]
            if tierBonus then
                tickets[stat] = tickets[stat] or {}
                table.insert(
                    tickets[stat],
                    {
                        item = item,
                        tier = tierName,
                        bonus = tierBonus
                    }
                )
            end
        end
    end

    return tickets
end

function Tickets.applyTicket(weapon, statKey, ticket)
    print(string.format("[Tickets] Applying ticket: %s | Tier %s | Bonus %.3f", statKey, ticket.tier, ticket.bonus))
    local tierBonus = ticket.bonus
    Utils.applyStatBonus(weapon, statKey, tierBonus)

    -- Optionally increment augment count
    local modData = weapon:getModData()
    modData.Augments = (modData.Augments or 0) + 1
end

return Tickets
