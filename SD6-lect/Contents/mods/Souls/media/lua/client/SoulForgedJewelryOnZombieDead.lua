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
    local pMD = getSpecificPlayer(0):getModData()
    local maxLuck = tierZone == 1 and 75 or 150
    local luck = math.min(math.max((pMD.luckValue or 0) + (pMD.PermaSoulForgeLuckBonus or 0), 0), maxLuck)

    if ZombRand(math.max(tierZone*150 - luck,1)) == 0 and isValidZone(tierZone) then
        local items = ItemGenerator.getTierSoulShard()
        local result = nil
        EventHandlers.SoulForgedJewelryOnCreate(items, result, zombie)
    end
end)
