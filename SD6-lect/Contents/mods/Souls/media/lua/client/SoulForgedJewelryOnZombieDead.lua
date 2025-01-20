local EventHandlers = require('SoulForgedJeweleryEventHandlers')
local ItemGenerator = require('SoulForgedJeweleryItemGeneration')
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

    print("Rolling zombie kill")

    if ZombRand(299) == 0 and isValidZone(tierZone) then
        local items = ItemGenerator.getTierSoulShard()
        local result = nil
        EventHandlers.SoulForgedJewelryOnCreate(items, result, zombie)
    end
end)