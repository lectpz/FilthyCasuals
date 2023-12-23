----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

function InitSafeHouseCheckFC()
	player = getPlayer()
	if player ~= nil then
	
		safehouse = SafeHouse.hasSafehouse(player)
		
		checksafehousefc = player:getModData().firsttimesafehouse
		
		if checksafehousefc ~= nil then
		
			Events.EveryOneMinute.Remove(InitSafeHouseCheckFC)
			
			return
			
		else
			
			if safehouse then
				player:getInventory():AddItem("FC.Teleporter")
				player:getInventory():AddItem("Base.PZwaystone")
				player:getModData().firsttimesafehouse = 1
				player:Say("Something heavy just dropped into my inventory.")
				Events.EveryOneMinute.Remove(InitSafeHouseCheckFC)
			else
				return
			end
		
		end
		
	end
	
end

Events.EveryOneMinute.Add(InitSafeHouseCheckFC)