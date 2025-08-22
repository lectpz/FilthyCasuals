require "recipecode"

function Recipe.OnTest.checkFullUseDelta(item)
    if item:getUsedDelta() < 1 then
		return false
	else
		return true
	end
end

function SD_DeconstructGun_OnCreate(items, result, player)
	player:getInventory():AddItem("Base.ScrapMetal")
	player:getInventory():AddItem("Base.ScrapMetal")
	if ZombRand(5) == 0 then
		player:getInventory():AddItem("Base.LeadPipe") 
	elseif ZombRand(2) == 0 then
		player:getInventory():AddItem("Base.ScrapMetal")
	end
end