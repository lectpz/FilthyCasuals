local EventHandlers = require('SoulForgedJewelryEventHandlers')
local ItemGenerator = require('SoulForgedJewelryItemGeneration')
local validZones = {1, 2, 3, 4, 5}

local function isValidZone(zone)
    for _, validZone in ipairs(validZones) do
        if zone == validZone then
            return true
        end
    end
    return false
end

Events.OnZombieDead.Add(function(zombie)
    local tierZone = checkZone()

    if ZombRand(tierZone*125) == 0 and isValidZone(tierZone) then
        local items = ItemGenerator.getTierSoulShard()
        local result = nil
        EventHandlers.SoulForgedJewelryOnCreate(items, result, zombie)
    end
end)