Config = require("SoulForgedConfig")
QualityTickets = {}

function QualityTickets.parseTicketName(fullItemString)
    local stat, tierNum = string.match(fullItemString, "^SoulForge%.(.-)_EnhancerT(%d+)$")
    if not stat or not tierNum then return nil end
    return stat, tierNum
end

function QualityTickets.scanInventory(player)
    local inv = player:getInventory()
    local items = inv:getItems()
    local tickets = {}

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        local itemName = item:getFullType()

        local stat, tier = QualityTickets.parseTicketName(itemName)
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

return QualityTickets
