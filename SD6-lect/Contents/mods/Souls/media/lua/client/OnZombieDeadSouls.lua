----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

function OnZombieDeadSouls(zombie)
	player = zombie:getAttackedBy()
	if player:isSeatedInVehicle() then 
		return 
	end
	--player:Say("OZD TEST")
	local tierzone, zonename, playerx, playery, control, toxic = checkZone()
--	local tierzone = 4
	
	local pMD = player:getModData()
	local eventenabled = SandboxVars.SDevents.enabled	
	local controlMod = 0
	local toxicMod = 0
	if control then controlMod = 25 end
	if toxic  then toxicMod = 25 end
	local luck = pMD.luckValue or 0
	
	local table1 = { "SoulForge.SoulShardT1" }
	local n1 = #table1 --number of tier 1 items in loot pool
	local t1 = ZombRand(n1)+1	-- random number generator, integers from 1 to n [eg n = 11, therefore rolls integers from 1 to 11]

	local table2 = { "SoulForge.SoulShardT2" }
	local n2 = #table2 --number of tier 2 items in loot pool
	local t2 = ZombRand(n2)+1	-- random number generator, integers from 1 to n [eg n = 12, therefore rolls integers from 1 to 12]

	local table3 = { "SoulForge.SoulShardT3" }
	local n3 = #table3 --number of tier 3 items in loot pool
	local t3 = ZombRand(n3)+1	-- random number generator, integers from 1 to n [eg n = 23, therefore rolls integers from 1 to 23]
	
	local table4 = { "SoulForge.SoulShardT4" }
	local n4 = #table4 --number of tier 4 items in loot pool
	local t4 = ZombRand(n4)+1	-- random number generator, integers from 1 to n [eg n = 23, therefore rolls integers from 1 to 23]
	
	local table5 = { "SoulForge.SoulShardT5" }
	local n5 = #table5 --number of tier 4 items in loot pool
	local t5 = ZombRand(n5)+1	-- random number generator, integers from 1 to n [eg n = 23, therefore rolls integers from 1 to 23]
	
	local faction = pMD.faction

	local multiCOG = 1
	local multiRanger = 1
	local multiVW = 1
	local nofaction = 0.2
	if faction == "COG" then
		multiCOG = 2
		nofaction = 1
	elseif faction == "Ranger" then
		multiRanger = 2
		nofaction = 1
	elseif faction == "Voidwalker" then
		multiVW = 2
		nofaction = 1
	end
	
	local function getTotalTableWeight(_table)
		local count = 0
		for i=1,#_table do
			count = count + _table[i]
		end
		return count
	end
	
	local function getWeightedItem(tableno, tableweight, rollvalue)
		local countnext = 0
		for i=1,#tableweight do
			countnext = countnext + tableweight[i]
			if rollvalue <= countnext then
				return tableno[i]
			end
		end
	end

	local dd_T5 = { "SoulForge.MinDmgTicket", "SoulForge.MaxDmgTicket", "SoulForge.CritChanceTicket", "SoulForge.CritMultiTicket", "SoulForge.EnduranceModTicket", "Base.bagCapacityTicket", "Base.bagWeightTicket" }
	local dd_T5weight = {  10*multiRanger,
                    10*multiVW, 
                    10*multiRanger, 
                    10*multiVW*multiCOG, 
                    6*nofaction, 
                    10*multiRanger*multiCOG, 
                    10*multiVW*multiCOG }

	
	local dd_T4 = { "SoulForge.MinDmgTicket", "SoulForge.MaxDmgTicket", "SoulForge.CritChanceTicket", "SoulForge.CritMultiTicket", "SoulForge.EnduranceModTicket", "Base.bagCapacityTicket", "Base.bagWeightTicket" }
	local dd_T4weight = {  7*multiRanger,
                    7*multiVW, 
                    10*multiRanger, 
                    10*multiVW*multiCOG, 
                    4*nofaction, 
                    7*multiRanger*multiCOG, 
                    7*multiVW*multiCOG }
	
	local dd_T3 = { "SoulForge.MinDmgTicket", "SoulForge.MaxDmgTicket", "SoulForge.CritChanceTicket", "SoulForge.CritMultiTicket", "SoulForge.EnduranceModTicket", "Base.bagCapacityTicket", "Base.bagWeightTicket" }
	local dd_T3weight = {  3*multiRanger,
                    3*multiVW, 
                    10*multiRanger, 
                    10*multiVW*multiCOG, 
                    2*nofaction, 
                    4*multiRanger*multiCOG, 
                    4*multiVW*multiCOG }
	
	local t1roll = ZombRand(90 - 0.2*(luck + toxicMod + controlMod))--ZombRand(SandboxVars.OZD.roll1) -- rolls an integer between 0-roll1
	--player:Say(tostring(SandboxVars.OZD.roll1))
	local t2roll = ZombRand(210 - 0.4*(luck + toxicMod + controlMod)) -- rolls an integer between 0-roll2 
	--player:Say(tostring(SandboxVars.OZD.roll2))
	local t3roll = ZombRand(450 - 0.6*(luck + toxicMod + controlMod)) -- rolls an integer between 0-roll3 
	--player:Say(tostring(SandboxVars.OZD.roll3))
	local t4roll = ZombRand(600 - 0.8*(luck + toxicMod + controlMod))
	--player:Say(tostring(SandboxVars.OZD.roll4))
	local t5roll = ZombRand(750 - 1.0*(luck + toxicMod + controlMod))
	
-- function to add item
	local function itemdrop(item)
		zombie:getInventory():AddItem(item) --use this if you want the items to spawn into a zombie body
	end	
	
	--check if player is in event zone, if event enabled and inside the zone then use event rolls, otherwise use the 
	if tierzone == 5 then
		if t5roll == 0 and toxic then
			itemdrop(table5[t5])
			itemdrop(getWeightedItem(dd_T5, dd_T5weight, ZombRand(1,getTotalTableWeight(dd_T5weight))))
		elseif t4roll == 0 and toxic then
			itemdrop(table4[t4])
			itemdrop(getWeightedItem(dd_T4, dd_T4weight, ZombRand(1,getTotalTableWeight(dd_T4weight))))
		elseif t3roll == 0 then
			itemdrop(table3[t3])
			if toxic then itemdrop(getWeightedItem(dd_T3, dd_T3weight, ZombRand(1,getTotalTableWeight(dd_T3weight)))) end
		elseif t2roll == 0 then
			itemdrop(table2[t2])
		elseif t1roll == 0 then
			itemdrop(table1[t1])
		end

	elseif tierzone == 4 then
		if t4roll == 0 and toxic then
			itemdrop(table4[t4])
			itemdrop(getWeightedItem(dd_T4, dd_T4weight, ZombRand(1,getTotalTableWeight(dd_T4weight))))
		elseif t3roll == 0 then
			itemdrop(table3[t3])
			if toxic then itemdrop(getWeightedItem(dd_T3, dd_T3weight, ZombRand(1,getTotalTableWeight(dd_T3weight)))) end
		elseif t2roll == 0 then
			itemdrop(table2[t2])
		elseif t1roll == 0 then
			itemdrop(table1[t1])
		end
		
	elseif tierzone == 3 then
		if t3roll == 0 then
			itemdrop(table3[t3])
			if toxic then itemdrop(getWeightedItem(dd_T3, dd_T3weight, ZombRand(1,getTotalTableWeight(dd_T3weight)))) end
		elseif t2roll == 0 then
			itemdrop(table2[t2])
		elseif t1roll == 0 then
			itemdrop(table1[t1])
		end
		
	elseif tierzone == 2 then
		if t2roll == 0 then
			itemdrop(table2[t2])
		elseif t1roll == 0 then
			itemdrop(table1[t1])
		end

	elseif tierzone == 1 then
		if t1roll == 0 then
			itemdrop(table1[t1])
		end
	end
end

Events.OnZombieDead.Add(OnZombieDeadSouls)