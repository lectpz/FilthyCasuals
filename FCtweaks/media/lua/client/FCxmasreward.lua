----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

--function InitSafeHouseCheckFC()
--	player = getPlayer()
--	if player ~= nil then
--
--		local ModDataFC = ModData.getOrCreate("FCsafehousecheck")
--
--		safehouse = SafeHouse.hasSafehouse(player)
--		--checksafehousefc = player:getModData().firsttimesafehouse
--		local checksafehouseFC = ModDataFC[getCurrentUserSteamID()] or false
--		
--		if checksafehouseFC ~= nil then
--		
--			Events.EveryOneMinute.Remove(InitSafeHouseCheckFC)
--			
--			return
--			
--		else
--			
--			if safehouse then
--				player:getInventory():AddItem("FC.Teleporter")
--				--player:getInventory():AddItem("Base.PZwaystone")
--				ModDataFC[getCurrentUserSteamID()] = true
--				player:Say("Something just dropped into my inventory.")
--				Events.EveryOneMinute.Remove(InitSafeHouseCheckFC)
--				player:Say("Safehouse hook removed")
--			else
--				return
--			end
--		
--		end
--		
--	end
--	
--end

--Events.EveryOneMinute.Add(InitSafeHouseCheckFC)

function XMAS2023reward()
	player = getPlayer()
	if player ~= nil then
		local ModDataFC = ModData.getOrCreate("XMAS2023reward")
		-- Try to get the value, and if it's nil, set it to false
		local checksafehouseFC = ModDataFC[getCurrentUserSteamID()] or false
		if checksafehouseFC then
			--player:Say("I already claimed my gift this year...")
			Events.OnPlayerMove.Remove(XMAS2023reward)
			return
		else
			player:getInventory():AddItem("Base.EventCacheXMAS2023")
			player:getInventory():AddItem("FC.Teleporter")
			ModDataFC[getCurrentUserSteamID()] = true
			player:Say("A merry present just dropped into my inventory!")
			Events.OnPlayerMove.Remove(XMAS2023reward)
			--player:Say("XMAS2023reward hook removed.")
		end
	end
end

Events.OnPlayerMove.Add(XMAS2023reward)