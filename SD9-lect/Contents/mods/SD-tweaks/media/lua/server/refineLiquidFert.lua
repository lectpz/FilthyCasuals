function Recipe.OnCreate.RefineLiquidFertilizer(items, result, player)
	local inv = player:getInventory()
	
	inv:AddItem("Sulphur")
	inv:AddItem("Saltpeter")
end