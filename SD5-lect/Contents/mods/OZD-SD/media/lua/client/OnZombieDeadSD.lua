----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

require "SDZoneCheck"

-- function to split the sandbox string into a table. my brute force way to bypass the limitations of sandbox var string delimiter. parses the input string and pulls out the everything between spaces.
local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "[^ %;,]+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end


local function OnZombieDeadItemDrop(zombie)
	player = getSpecificPlayer(0)
	--player:Say("OZD TEST")
	
--	define table 1 for common loot. examples are from Riku's melee weapon mod which are used exclusively on PARP, Sunday Drivers, and Filthy Casuals servers.
--	local table1 = {RMWeapons.club1 RMWeapons.club2 RMWeapons.beardedaxe RMWeapons.MightCleaver RMWeapons.tanto RMWeapons.Thawk RMWeapons.bonkhammer RMWeapons.ScrapMace1 RMWeapons.spikedleg RMWeapons.TrenchShovel}
	local table1 = splitString(SandboxVars.OZD.table1)
	--player:Say(SandboxVars.OZD.table1)
	local n1 = #table1 --number of tier 1 items in loot pool
	local t1 = ZombRand(n1)+1	-- random number generator, integers from 1 to n [eg n = 11, therefore rolls integers from 1 to 11]

--	define table 2 for uncommon loot. examples are from Riku's melee weapon mod which are used exclusively on PARP, Sunday Drivers, and Filthy Casuals servers.	
--	local table2 = {RMWeapons.spear1 RMWeapons.BrushAxe RMWeapons.LastHope RMWeapons.CrimsonLance RMWeapons.Golok RMWeapons.HeavyCleaver RMWeapons.Dadao RMWeapons.dragonpiercer RMWeapons.thunderbreaker}
	local table2 = splitString(SandboxVars.OZD.table2)
	--player:Say(SandboxVars.OZD.table2)
	local n2 = #table2 --number of tier 2 items in loot pool
	local t2 = ZombRand(n2)+1	-- random number generator, integers from 1 to n [eg n = 12, therefore rolls integers from 1 to 12]

--	define table 3 for rare loot. examples are from Riku's melee weapon mod which are used exclusively on PARP, Sunday Drivers, and Filthy Casuals servers.	
--	local table3 = {RMWeapons.MedSword RMWeapons.MorningStar RMWeapons.MxScythe RMWeapons.hellokittyaxe RMWeapons.glaive RMWeapons.waraxe RMWeapons.steinsword RMWeapons.mace1 RMWeapons.warhammer40k RMWeapons.bassax RMWeapons.gnbat RMWeapons.spikedsword RMWeapons.crabspear RMWeapons.firelink RMWeapons.themauler RMWeapons.bladebat RMWeapons.NulBlade RMWeapons.Falx RMWeapons.Crimson1Sword RMWeapons.sword40k RMWeapons.dagger1 RMWeapons.kindness RMWeapons.spinecrusher RMWeapons.sawbat1  RMWeapons.warhammer RMWeapons.SpikedClub1}
	local table3 = splitString(SandboxVars.OZD.table3)
	--player:Say(SandboxVars.OZD.table3)
	local n3 = #table3 --number of tier 3 items in loot pool
	local t3 = ZombRand(n3)+1	-- random number generator, integers from 1 to n [eg n = 23, therefore rolls integers from 1 to 23]
	
--	define table 4 for event rarity loot. examples are from Riku's melee weapon mod which are used exclusively on PARP, Sunday Drivers, and Filthy Casuals servers.	
--	local table4 = {RMWeapons.MedSword RMWeapons.MorningStar RMWeapons.MxScythe RMWeapons.hellokittyaxe RMWeapons.glaive RMWeapons.waraxe RMWeapons.steinsword RMWeapons.mace1 RMWeapons.warhammer40k RMWeapons.bassax RMWeapons.gnbat RMWeapons.spikedsword RMWeapons.crabspear RMWeapons.firelink RMWeapons.themauler RMWeapons.bladebat RMWeapons.NulBlade RMWeapons.Falx RMWeapons.Crimson1Sword RMWeapons.sword40k RMWeapons.dagger1 RMWeapons.kindness RMWeapons.spinecrusher RMWeapons.sawbat1  RMWeapons.warhammer RMWeapons.SpikedClub1}
	local table4 = splitString(SandboxVars.OZD.table4)
	--player:Say(SandboxVars.OZD.table4)
	local n4 = #table4 --number of tier 4 items in loot pool
	local t4 = ZombRand(n4)+1	-- random number generator, integers from 1 to n [eg n = 23, therefore rolls integers from 1 to 23]
	
-- calculate roll for tiers /// ZombRand(n) where n is the number of zombies to kill before that tier may drop
    
	local modData = zombie:getModData()
	
	if modData.SDspeed == 1 then
		zombieSprinterValue = modData.SDSprinterZoneValue or 0
		--player:Say("killed a sprinter")
		--player:Say("sprinter zone value: " .. zombieSprinterValue)
	else
		zombieSprinterValue = 0
	end
	--adjust zombrand by subtracting sprinter zone values.

	local t1roll = ZombRand(SandboxVars.OZD.roll1)--ZombRand(SandboxVars.OZD.roll1) -- rolls an integer between 0-roll1
	--player:Say(tostring(SandboxVars.OZD.roll1))
	local t2roll = ZombRand(math.max(SandboxVars.OZD.roll2 - math.floor(zombieSprinterValue*0.5), 1)) -- rolls an integer between 0-roll2 
	--player:Say(tostring(SandboxVars.OZD.roll2))
	local t3roll = ZombRand(math.max(SandboxVars.OZD.roll3 - math.floor(zombieSprinterValue*1.25), 1)) -- rolls an integer between 0-roll3 
	--player:Say(tostring(SandboxVars.OZD.roll3))
	local t4roll = ZombRand(math.max(SandboxVars.OZD.roll4 - math.floor(zombieSprinterValue*2), 1))
	--player:Say(tostring(SandboxVars.OZD.roll4))
	
-- function to add item
	local function itemdrop(item)
		--zombie:getSquare():AddWorldInventoryItem(item, 0, 0, 0) --use this if you want it items to drop onto the ground
		zombie:getInventory():AddItem(item) --use this if you want the items to spawn into a zombie body
	end	
	
-- tiered rolling, checks for rare then uncommon then common
	local tierzone = checkZone()
--	local tierzone = 4
	
	local eventenabled = SandboxVars.SDevents.enabled	
	
	--check if player is in event zone, if event enabled and inside the zone then use event rolls, otherwise use the 
	if eventenabled then
		local x = player:getX()
		local y = player:getY()
		local x1 = SandboxVars.SDevents.Xcoord1
		local y1 = SandboxVars.SDevents.Ycoord1
		local x2 = SandboxVars.SDevents.Xcoord2
		local y2 = SandboxVars.SDevents.Ycoord2
		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
			t1roll = ZombRand(SandboxVars.SDevents.roll1)
			t2roll = ZombRand(math.max(SandboxVars.SDevents.roll2 - math.floor(zombieSprinterValue*0.5), 1))
			t3roll = ZombRand(math.max(SandboxVars.SDevents.roll3 - math.floor(zombieSprinterValue*1.25), 1))
			t4roll = ZombRand(math.max(SandboxVars.SDevents.roll4 - math.floor(zombieSprinterValue*2), 1))
		end
	end
	
	if tierzone == 4 then
		--player:Say("Tier 4! 1 / " .. tostring(t4roll))
		player:getXp():AddXP(Perks.Strength, tierzone*5);
		player:getXp():AddXP(Perks.Fitness, tierzone*5);
		if t4roll == 0 then
			itemdrop(table4[t4])
		elseif t3roll == 0 then
			itemdrop(table3[t3])
		elseif t2roll == 0 then
			itemdrop(table2[t2])
		elseif t1roll == 0 then
			itemdrop(table1[t1])
		end
	elseif tierzone == 3 then
		--player:Say("Tier 3! 1 / " .. tostring(t3roll))
		player:getXp():AddXP(Perks.Strength, tierzone*5);
		player:getXp():AddXP(Perks.Fitness, tierzone*5);
		if t3roll == 0 then
			itemdrop(table3[t3])
		elseif t2roll == 0 then
			itemdrop(table2[t2])
		elseif t1roll == 0 then
			itemdrop(table1[t1])
		end
	elseif tierzone == 2 then
		--player:Say("Tier 2! 1 / " .. tostring(t2roll))
		player:getXp():AddXP(Perks.Strength, tierzone*5);
		player:getXp():AddXP(Perks.Fitness, tierzone*5);
		if t2roll == 0 then
			itemdrop(table2[t2])
		elseif t1roll == 0 then
			itemdrop(table1[t1])
		end
	elseif tierzone == 1 then
		--player:Say("Tier 1! 1 / " .. tostring(t1roll))
		player:getXp():AddXP(Perks.Strength, tierzone*5);
		player:getXp():AddXP(Perks.Fitness, tierzone*5);
		if t1roll == 0 then
			itemdrop(table1[t1])
		end
	end
end

Events.OnZombieDead.Add(OnZombieDeadItemDrop)

--player:getZombieKills() --= zombie killed by player
-- on game start -- check zombie kills
-- on zombie kill - check: 