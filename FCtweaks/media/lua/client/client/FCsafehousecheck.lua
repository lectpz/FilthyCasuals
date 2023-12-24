----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

function InitSafeHouseCheckFC()
	player = getPlayer()
	if player ~= nil then
	
		safehouse = SafeHouse.hasSafehouse(player)
		--checksafehousefc = player:getModData().firsttimesafehouse
		checksafehouseFC = ModDataFC[currentUserSteamID]
		
		if checksafehousefc ~= nil then
		
			Events.EveryOneMinute.Remove(InitSafeHouseCheckFC)
			
			return
			
		else
		
			local ModDataFC = ModData.getOrCreate("FCsafehousecheck")
			local currentUserSteamID = getCurrentUserSteamID()
			
			if safehouse then
				player:getInventory():AddItem("FC.Teleporter")
				--player:getInventory():AddItem("Base.PZwaystone")
				ModDataFC[currentUserSteamID] = true
				print(currentUserSteamID .. "( " .. player .. ") claimed their first Safehouse.")
				player:Say("Something just dropped into my inventory.")
				Events.EveryOneMinute.Remove(InitSafeHouseCheckFC)
			else
				return
			end
		
		end
		
	end
	
end

--Events.EveryOneMinute.Add(InitSafeHouseCheckFC)