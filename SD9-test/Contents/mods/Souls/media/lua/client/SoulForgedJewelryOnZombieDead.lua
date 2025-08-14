local EventHandlers = require('SoulForgedJewelryEventHandlers')
local ItemGenerator = require('SoulForgedJewelryItemGeneration')

Events.OnZombieDead.Add(function(zombie)
    local tierZone = checkZone()
    local pMD = getSpecificPlayer(0):getModData()
    local maxLuck = tierZone == 1 and 75 or 150
    local luck = math.min(math.max((pMD.luckValue or 0) + (pMD.PermaSoulForgeLuckBonus or 0), 0), maxLuck)

    if ZombRand(math.max(SandboxVars.SoulForge["JewelryDropRateT"..tierZone] - luck,1)) == 0 and tierZone >= 3 then
		--print("tier="..tierZone.." modified tierzone="..math.floor(tierZone-1.5))
		local _tier = tierZone - 2
		local forcedTier = nil
		if tierZone == 6 then _tier = 6 forcedTier = 6 end
        local items = ItemGenerator.getTierSoulShardExplicit(_tier)
        local result = nil
        EventHandlers.SoulForgedJewelryOnCreate(items, result, zombie, forcedTier)
    end
end)
