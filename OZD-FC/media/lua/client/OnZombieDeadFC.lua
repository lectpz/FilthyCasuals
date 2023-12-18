----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

require "ZoneCheckFC"
require "MF_ISMoodle"

FCzombieKC = 0

MF.createMoodle("pepe");
MF.createMoodle("pepeclown");

-- function to split the sandbox string into a table. my brute force way to bypass the limitations of sandbox var string delimiter. parses the input string and pulls out the everything between spaces.
local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "%S+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

function CheckZombieKillCountFC()
	if getPlayer() ~= nil then
		FCzombieKC = getPlayer():getZombieKills()
		if FCzombieKC >= 2000 then
			if MF.getMoodle("pepeclown"):getValue() ~= 0.1 then
				FilthyCasual = 1
				MF.getMoodle("pepeclown"):setValue(0.1) 
				MF.getMoodle("pepe"):setValue(0.5)
			else
				FilthyCasual = 1
				return
			end
		elseif FCzombieKC >= 1000 then
			if MF.getMoodle("pepe"):getValue() ~= 0.4 then
				FilthyCasual = false
				MF.getMoodle("pepe"):setValue(0.4)
				MF.getMoodle("pepeclown"):setValue(0.5)
			else
				FilthyCasual = 0
				return
			end
		else
			FilthyCasual = 0
			MF.getMoodle("pepe"):setValue(0.5)
			MF.getMoodle("pepeclown"):setValue(0.5)
		end
	else
		FilthyCasual = 0
		MF.getMoodle("pepe"):setValue(0.5)
		MF.getMoodle("pepeclown"):setValue(0.5)
	end
end

function OnZombieDeadItemDrop(zombie)
	--getPlayer():Say("OZD TEST")
	
--	define table 1 for common loot. examples are from Riku's melee weapon mod which are used exclusively on PARP, Sunday Drivers, and Filthy Casuals servers.
--	local table1 = {RMWeapons.club1 RMWeapons.club2 RMWeapons.beardedaxe RMWeapons.MightCleaver RMWeapons.tanto RMWeapons.Thawk RMWeapons.bonkhammer RMWeapons.ScrapMace1 RMWeapons.spikedleg RMWeapons.TrenchShovel}
	local table1 = splitString(SandboxVars.OZD.table1)
	--getPlayer():Say(SandboxVars.OZD.table1)
	local n1 = #table1 --number of tier 1 items in loot pool
	local t1 = ZombRand(n1)+1	-- random number generator, integers from 1 to n [eg n = 11, therefore rolls integers from 1 to 11]

--	define table 2 for uncommon loot. examples are from Riku's melee weapon mod which are used exclusively on PARP, Sunday Drivers, and Filthy Casuals servers.	
--	local table2 = {RMWeapons.spear1 RMWeapons.BrushAxe RMWeapons.LastHope RMWeapons.CrimsonLance RMWeapons.Golok RMWeapons.HeavyCleaver RMWeapons.Dadao RMWeapons.dragonpiercer RMWeapons.thunderbreaker}
	local table2 = splitString(SandboxVars.OZD.table2)
	--getPlayer():Say(SandboxVars.OZD.table2)
	local n2 = #table2 --number of tier 2 items in loot pool
	local t2 = ZombRand(n2)+1	-- random number generator, integers from 1 to n [eg n = 12, therefore rolls integers from 1 to 12]

--	define table 3 for rare loot. examples are from Riku's melee weapon mod which are used exclusively on PARP, Sunday Drivers, and Filthy Casuals servers.	
--	local table3 = {RMWeapons.MedSword RMWeapons.MorningStar RMWeapons.MxScythe RMWeapons.hellokittyaxe RMWeapons.glaive RMWeapons.waraxe RMWeapons.steinsword RMWeapons.mace1 RMWeapons.warhammer40k RMWeapons.bassax RMWeapons.gnbat RMWeapons.spikedsword RMWeapons.crabspear RMWeapons.firelink RMWeapons.themauler RMWeapons.bladebat RMWeapons.NulBlade RMWeapons.Falx RMWeapons.Crimson1Sword RMWeapons.sword40k RMWeapons.dagger1 RMWeapons.kindness RMWeapons.spinecrusher RMWeapons.sawbat1  RMWeapons.warhammer RMWeapons.SpikedClub1}
	local table3 = splitString(SandboxVars.OZD.table3)
	--getPlayer():Say(SandboxVars.OZD.table3)
	local n3 = #table3 --number of tier 3 items in loot pool
	local t3 = ZombRand(n3)+1	-- random number generator, integers from 1 to n [eg n = 23, therefore rolls integers from 1 to 23]
	
--	define table 4 for event rarity loot. examples are from Riku's melee weapon mod which are used exclusively on PARP, Sunday Drivers, and Filthy Casuals servers.	
--	local table4 = {RMWeapons.MedSword RMWeapons.MorningStar RMWeapons.MxScythe RMWeapons.hellokittyaxe RMWeapons.glaive RMWeapons.waraxe RMWeapons.steinsword RMWeapons.mace1 RMWeapons.warhammer40k RMWeapons.bassax RMWeapons.gnbat RMWeapons.spikedsword RMWeapons.crabspear RMWeapons.firelink RMWeapons.themauler RMWeapons.bladebat RMWeapons.NulBlade RMWeapons.Falx RMWeapons.Crimson1Sword RMWeapons.sword40k RMWeapons.dagger1 RMWeapons.kindness RMWeapons.spinecrusher RMWeapons.sawbat1  RMWeapons.warhammer RMWeapons.SpikedClub1}
	local table4 = splitString(SandboxVars.OZD.table4)
	--getPlayer():Say(SandboxVars.OZD.table4)
	local n4 = #table4 --number of tier 4 items in loot pool
	local t4 = ZombRand(n4)+1	-- random number generator, integers from 1 to n [eg n = 23, therefore rolls integers from 1 to 23]
	
-- calculate roll for tiers /// ZombRand(n) where n is the number of zombies to kill before that tier may drop

	local t1roll = ZombRand(SandboxVars.OZD.roll1)--ZombRand(SandboxVars.OZD.roll1) -- rolls an integer between 0-roll1
	--getPlayer():Say(tostring(SandboxVars.OZD.roll1))
	local t2roll = ZombRand(SandboxVars.OZD.roll2) -- rolls an integer between 0-roll2 
	--getPlayer():Say(tostring(SandboxVars.OZD.roll2))
	local t3roll = ZombRand(SandboxVars.OZD.roll3) -- rolls an integer between 0-roll3 
	--getPlayer():Say(tostring(SandboxVars.OZD.roll3))
	local t4roll = ZombRand(SandboxVars.OZD.roll4)
	--getPlayer():Say(tostring(SandboxVars.OZD.roll4))
	
-- function to add item
	local function itemdrop(item)
		--zombie:getSquare():AddWorldInventoryItem(item, 0, 0, 0) --use this if you want it items to drop onto the ground
		zombie:getInventory():AddItem(item) --use this if you want the items to spawn into a zombie body
	end	
	
-- tiered rolling, checks for rare then uncommon then common
	local tierzone = checkZone()
--	local tierzone = 4
	
	if tierzone == 4 then
		--getPlayer():Say("Tier 4! 1 / " .. tostring(t4roll))
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
		--getPlayer():Say("Tier 3! 1 / " .. tostring(t3roll))
		if t3roll == 0 then
			itemdrop(table3[t3])
		elseif t2roll == 0 then
			itemdrop(table2[t2])
		elseif t1roll == 0 then
			itemdrop(table1[t1])
		end
	elseif tierzone == 2 then
		--getPlayer():Say("Tier 2! 1 / " .. tostring(t2roll))
		if t2roll == 0 then
			itemdrop(table2[t2])
		elseif t1roll == 0 then
			itemdrop(table1[t1])
		end
	elseif tierzone == 1 then
		--getPlayer():Say("Tier 1! 1 / " .. tostring(t1roll))
		if t1roll == 0 then
			itemdrop(table1[t1])
		end
	end
	CheckZombieKillCountFC()
end

Events.OnZombieDead.Add(OnZombieDeadItemDrop)
Events.OnGameStart.Add(CheckZombieKillCountFC)

--getPlayer():getZombieKills() --= zombie killed by player
-- on game start -- check zombie kills
-- on zombie kill - check: 