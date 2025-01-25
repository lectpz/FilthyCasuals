----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------
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

function OnZombieDeadSouls(zombie)
	player = zombie:getAttackedBy()
	if player:isSeatedInVehicle() then 
		return 
	end
	--player:Say("OZD TEST")
	local tierzone, zonename, playerx, playery, control, toxic = checkZone()
--	local tierzone = 4
	
	local pMD = player:getModData()
	--local eventenabled = SandboxVars.SDevents.enabled	
	local controlMod = 0
	local toxicMod = 0
	if control then controlMod = 35 end
	if toxic  then toxicMod = 35 end
	local luck = pMD.luckValue or 0
	--if eventenabled then controlMod = 0 end
	
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
	local nofaction = 1/3
	if faction == "COG" then
		multiCOG = 2
		nofaction = 1
	elseif faction == "Ranger" then
		multiRanger = 2
		nofaction = 1
	elseif faction == "VoidWalker" then
		multiVW = 2
		nofaction = 1
	end
	
	local dd_T5 = { "SoulForge.MinDmgTicket", "SoulForge.MaxDmgTicket", "SoulForge.CritChanceTicket", "SoulForge.CritMultiTicket", "SoulForge.EnduranceModTicket", "Base.bagCapacityTicket", "Base.bagWeightTicket", "Base.rangerToken", "Base.cogToken", "Base.vwToken", }
	local dd_T5weight = {  
					10*multiRanger,
                    10*multiVW, 
                    10*multiRanger, 
                    10*multiVW*multiCOG, 
                    math.floor(6*nofaction), 
                    10*multiRanger*multiCOG, 
                    10*multiVW*multiCOG,
					3*multiRanger*multiRanger 	*	((controlMod)/35+1),
					3*multiCOG*multiCOG 		*	((controlMod)/35+1),
					3*multiVW*multiVW		*	((controlMod)/35+1),
					}

	
	local dd_T4 = { "SoulForge.MaxDmgTicket", "SoulForge.CritChanceTicket", "SoulForge.CritMultiTicket", "Base.bagCapacityTicket", "Base.bagWeightTicket", "Base.rangerToken", "Base.cogToken", "Base.vwToken", }
	local dd_T4weight = {
					7*multiVW, 
                    10*multiRanger, 
                    10*multiVW*multiCOG, 
                    7*multiRanger*multiCOG, 
                    7*multiVW*multiCOG,
					2*multiRanger*multiRanger 	*	((controlMod)/35+1),
					2*multiCOG*multiCOG 		*	((controlMod)/35+1),
					2*multiVW*multiVW		*	((controlMod)/35+1),
					}
	
	local dd_T3 = { "SoulForge.CritChanceTicket", "SoulForge.CritMultiTicket", "Base.bagCapacityTicket", "Base.bagWeightTicket", "Base.rangerToken", "Base.cogToken", "Base.vwToken", }
	local dd_T3weight = {  
                    10*multiRanger, 
                    10*multiVW*multiCOG, 
                    4*multiRanger*multiCOG, 
                    4*multiVW*multiCOG,
					1*multiRanger*multiRanger 	*	((controlMod)/35+1),
					1*multiCOG*multiCOG 		*	((controlMod)/35+1),
					1*multiVW*multiVW		*	((controlMod)/35+1),
					}
	
	local t1roll = ZombRand(math.max(75 - 0.2*(luck + toxicMod + controlMod),50))--ZombRand(SandboxVars.OZD.roll1) -- rolls an integer between 0-roll1
	--player:Say(tostring(SandboxVars.OZD.roll1))
	local t2roll = ZombRand(math.max(150 - 0.4*(luck + toxicMod + controlMod),75)) -- rolls an integer between 0-roll2 
	--player:Say(tostring(SandboxVars.OZD.roll2))
	local t3roll = ZombRand(math.max(225 - 0.6*(luck + toxicMod + controlMod),100)) -- rolls an integer between 0-roll3 
	--player:Say(tostring(SandboxVars.OZD.roll3))
	local t4roll = ZombRand(math.max(300 - 0.8*(luck + toxicMod + controlMod),125))
	--player:Say(tostring(SandboxVars.OZD.roll4))
	local t5roll = ZombRand(math.max(375 - 1.0*(luck + toxicMod + controlMod),150))
	

	local VAitems_t5 = { "HS_VenenosusAer.VA_Charcoal_Tablets", "HS_VenenosusAer.VA_Filter_LowGrade", "HS_VenenosusAer.VA_Filter_MediumGrade", "HS_VenenosusAer.VA_Filter_HighGrade" }
	local VAweight_t5 = { 4, 10, 5, 1 }
	
	local VAitems_t4 = { "HS_VenenosusAer.VA_Charcoal_Tablets", "HS_VenenosusAer.VA_Filter_LowGrade", "HS_VenenosusAer.VA_Filter_MediumGrade" }
	local VAweight_t4 = { 2, 5, 1 }
	
	local VAitems_t3 = { "HS_VenenosusAer.VA_Charcoal_Tablets", "HS_VenenosusAer.VA_Filter_LowGrade" }
	local VAweight_t3 = { 2, 8 }
	
-- function to add item
	local function itemdrop(item)
		zombie:getInventory():AddItem(item) --use this if you want the items to spawn into a zombie body
	end	
	
	local function isToxicControl()
		if toxic then return true end
		if control then return true end
		return false
	end
	
	--check if player is in event zone, if event enabled and inside the zone then use event rolls, otherwise use the 
	if tierzone == 5 then
		if t5roll == 0 and (isToxicControl() or ZombRand(tierzone) > 2) then
			itemdrop(table5[t5])
			if toxic then itemdrop(getWeightedItem(dd_T5, dd_T5weight, ZombRand(1,getTotalTableWeight(dd_T5weight)))) end
			if (control or ZombRand(tierzone) > 2) and ZombRand(7-tierzone) == 0 then itemdrop(getWeightedItem(dd_T5, dd_T5weight, ZombRand(1,getTotalTableWeight(dd_T5weight)))) end
			if (isToxicControl() or ZombRand(tierzone) > 2) then itemdrop(getWeightedItem(VAitems_t5, VAweight_t5, ZombRand(1,getTotalTableWeight(VAweight_t5)))) end
		elseif t4roll == 0 and isToxicControl() then
			itemdrop(table4[t4])
			if toxic 	and ZombRand(7-tierzone) == 0 then itemdrop(getWeightedItem(dd_T4, dd_T4weight, ZombRand(1,getTotalTableWeight(dd_T4weight)))) end
			if (control or ZombRand(tierzone) > 2) and ZombRand(7-tierzone) == 0 then itemdrop(getWeightedItem(dd_T4, dd_T4weight, ZombRand(1,getTotalTableWeight(dd_T4weight)))) end
			if (isToxicControl() or ZombRand(tierzone) > 2)  and ZombRand(7-tierzone) == 0 then itemdrop(getWeightedItem(VAitems_t4, VAweight_t4, ZombRand(1,getTotalTableWeight(VAweight_t4)))) end
		elseif t3roll == 0 then
			itemdrop(table3[t3])
			if toxic 	and ZombRand(7-tierzone) == 0 then itemdrop(getWeightedItem(dd_T3, dd_T3weight, ZombRand(1,getTotalTableWeight(dd_T3weight)))) end
			if (control or ZombRand(tierzone) > 2) and ZombRand(7-tierzone) == 0 then itemdrop(getWeightedItem(dd_T3, dd_T3weight, ZombRand(1,getTotalTableWeight(dd_T3weight)))) end
			if (isToxicControl() or ZombRand(tierzone) > 2)  and ZombRand(7-tierzone) == 0 then itemdrop(getWeightedItem(VAitems_t3, VAweight_t3, ZombRand(1,getTotalTableWeight(VAweight_t3)))) end
		elseif t2roll == 0 then
			itemdrop(table2[t2])
		elseif t1roll == 0 then
			itemdrop(table1[t1])
		end

	elseif tierzone == 4 then
		if t4roll == 0 and isToxicControl() then
			itemdrop(table4[t4])
			if toxic then itemdrop(getWeightedItem(dd_T4, dd_T4weight, ZombRand(1,getTotalTableWeight(dd_T4weight)))) end
			if (control or ZombRand(tierzone) > 2) and ZombRand(7-tierzone) == 0 then itemdrop(getWeightedItem(dd_T4, dd_T4weight, ZombRand(1,getTotalTableWeight(dd_T4weight)))) end
			if (isToxicControl() or ZombRand(tierzone) > 2) then itemdrop(getWeightedItem(VAitems_t4, VAweight_t4, ZombRand(1,getTotalTableWeight(VAweight_t4)))) end
		elseif t3roll == 0 then
			itemdrop(table3[t3])
			if toxic 	and ZombRand(7-tierzone) == 0 then itemdrop(getWeightedItem(dd_T3, dd_T3weight, ZombRand(1,getTotalTableWeight(dd_T3weight)))) end
			if (control or ZombRand(tierzone) > 2) and ZombRand(7-tierzone) == 0 then itemdrop(getWeightedItem(dd_T3, dd_T3weight, ZombRand(1,getTotalTableWeight(dd_T3weight)))) end
			if (isToxicControl() or ZombRand(tierzone) > 2) and ZombRand(7-tierzone) == 0 then itemdrop(getWeightedItem(VAitems_t3, VAweight_t3, ZombRand(1,getTotalTableWeight(VAweight_t3)))) end
		elseif t2roll == 0 then
			itemdrop(table2[t2])
		elseif t1roll == 0 then
			itemdrop(table1[t1])
		end
		
	elseif tierzone == 3 then
		if t3roll == 0 then
			itemdrop(table3[t3])
			if toxic then itemdrop(getWeightedItem(dd_T3, dd_T3weight, ZombRand(1,getTotalTableWeight(dd_T3weight)))) end
			if control and ZombRand(7-tierzone) == 0 then itemdrop(getWeightedItem(dd_T3, dd_T3weight, ZombRand(1,getTotalTableWeight(dd_T3weight)))) end
			if isToxicControl() then itemdrop(getWeightedItem(VAitems_t3, VAweight_t3, ZombRand(1,getTotalTableWeight(VAweight_t3)))) end
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