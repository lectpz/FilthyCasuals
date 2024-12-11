require "recipecode"

function Recipe.OnTest.checkFullUseDelta(item)
    if item:getUsedDelta() < 1 then
		return false
	else
		return true
	end
end

function DeconstructGun_OnCreate(items, result, player)
    --player:getInventory():AddItem("Base.LeadPipe")
	player:getInventory():AddItem("Base.ScrapMetal")
	player:getInventory():AddItem("Base.ScrapMetal")
	player:getInventory():AddItem("Base.ScrapMetal")
end