----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

require "ZoneCheckFC"

-- function to split the sandbox string into a table. my brute force way to bypass the limitations of sandbox var string delimiter. parses the input string and pulls out the everything between spaces.
local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "%S+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

function RikuWeaponCacheFC(items, result, player)

	local tierzone = checkZone()

--	define table 1 for common loot. examples are from Riku's melee weapon mod which are used exclusively on PARP, Sunday Drivers, and Filthy Casuals servers.
--	local table1 = {RMWeapons.club1 RMWeapons.club2 RMWeapons.beardedaxe RMWeapons.MightCleaver RMWeapons.tanto RMWeapons.Thawk RMWeapons.bonkhammer RMWeapons.ScrapMace1 RMWeapons.spikedleg RMWeapons.TrenchShovel}
	local table1 = splitString(SandboxVars.RWC.table1)
	local n1 = #table1 --number of tier 1 items in loot pool
	local t1 = ZombRand(n1)+1	-- random number generator, integers from 1 to n [eg n = 11, therefore rolls integers from 1 to 11]

--	define table 2 for uncommon loot. examples are from Riku's melee weapon mod which are used exclusively on PARP, Sunday Drivers, and Filthy Casuals servers.	
--	local table2 = {RMWeapons.spear1 RMWeapons.BrushAxe RMWeapons.LastHope RMWeapons.CrimsonLance RMWeapons.Golok RMWeapons.HeavyCleaver RMWeapons.Dadao RMWeapons.dragonpiercer RMWeapons.thunderbreaker}
	local table2 = splitString(SandboxVars.RWC.table2)
	local n2 = #table2 --number of tier 2 items in loot pool
	local t2 = ZombRand(n2)+1	-- random number generator, integers from 1 to n [eg n = 12, therefore rolls integers from 1 to 12]

--	define table 3 for rare loot. examples are from Riku's melee weapon mod which are used exclusively on PARP, Sunday Drivers, and Filthy Casuals servers.	
--	local table3 = {RMWeapons.MedSword RMWeapons.MorningStar RMWeapons.MxScythe RMWeapons.hellokittyaxe RMWeapons.glaive RMWeapons.waraxe RMWeapons.steinsword RMWeapons.mace1 RMWeapons.warhammer40k RMWeapons.bassax RMWeapons.gnbat RMWeapons.spikedsword RMWeapons.crabspear RMWeapons.firelink RMWeapons.themauler RMWeapons.bladebat RMWeapons.NulBlade RMWeapons.Falx RMWeapons.Crimson1Sword RMWeapons.sword40k RMWeapons.dagger1 RMWeapons.kindness RMWeapons.spinecrusher RMWeapons.sawbat1  RMWeapons.warhammer RMWeapons.SpikedClub1}
	local table3 = splitString(SandboxVars.RWC.table3)
	local n3 = #table3 --number of tier 3 items in loot pool
	local t3 = ZombRand(n3)+1	-- random number generator, integers from 1 to n [eg n = 23, therefore rolls integers from 1 to 23]
	
--	define table 4 for event rarity loot. examples are from Riku's melee weapon mod which are used exclusively on PARP, Sunday Drivers, and Filthy Casuals servers.	
--	local table4 = {RMWeapons.MedSword RMWeapons.MorningStar RMWeapons.MxScythe RMWeapons.hellokittyaxe RMWeapons.glaive RMWeapons.waraxe RMWeapons.steinsword RMWeapons.mace1 RMWeapons.warhammer40k RMWeapons.bassax RMWeapons.gnbat RMWeapons.spikedsword RMWeapons.crabspear RMWeapons.firelink RMWeapons.themauler RMWeapons.bladebat RMWeapons.NulBlade RMWeapons.Falx RMWeapons.Crimson1Sword RMWeapons.sword40k RMWeapons.dagger1 RMWeapons.kindness RMWeapons.spinecrusher RMWeapons.sawbat1  RMWeapons.warhammer RMWeapons.SpikedClub1}
	local table4 = splitString(SandboxVars.RWC.table4)
	local n4 = #table4 --number of tier 4 items in loot pool
	local t4 = ZombRand(n4)+1	-- random number generator, integers from 1 to n [eg n = 23, therefore rolls integers from 1 to 23]
	
-- tiered rolling, checks zone and adds item
	if tierzone == 4 then
		getPlayer():getInventory():AddItem(table4[t4])
	elseif tierzone == 3 then
		getPlayer():getInventory():AddItem(table3[t3])
		getPlayer():getInventory():AddItem(EmptyWeaponCacheT3);
	elseif tierzone == 2 then
		getPlayer():getInventory():AddItem(table2[t2])
		getPlayer():getInventory():AddItem(EmptyWeaponCacheT2);
	elseif tierzone == 1 then
		getPlayer():getInventory():AddItem(table1[t1])
		getPlayer():getInventory():AddItem(EmptyWeaponCacheT1);
	end
	
end


function RikuWeaponCacheUpgradeFC(items, result, player)

	local tierzone = checkZone()
	
--	define table 1 for common loot. examples are from Riku's melee weapon mod which are used exclusively on PARP, Sunday Drivers, and Filthy Casuals servers.
--	local table1 = {RMWeapons.club1 RMWeapons.club2 RMWeapons.beardedaxe RMWeapons.MightCleaver RMWeapons.tanto RMWeapons.Thawk RMWeapons.bonkhammer RMWeapons.ScrapMace1 RMWeapons.spikedleg RMWeapons.TrenchShovel}
	local table1 = splitString(SandboxVars.RWC.table1)
	local n1 = #table1 --number of tier 1 items in loot pool
	local t1 = ZombRand(n1)+1	-- random number generator, integers from 1 to n [eg n = 11, therefore rolls integers from 1 to 11]

--	define table 2 for uncommon loot. examples are from Riku's melee weapon mod which are used exclusively on PARP, Sunday Drivers, and Filthy Casuals servers.	
--	local table2 = {RMWeapons.spear1 RMWeapons.BrushAxe RMWeapons.LastHope RMWeapons.CrimsonLance RMWeapons.Golok RMWeapons.HeavyCleaver RMWeapons.Dadao RMWeapons.dragonpiercer RMWeapons.thunderbreaker}
	local table2 = splitString(SandboxVars.RWC.table2)
	local n2 = #table2 --number of tier 2 items in loot pool
	local t2 = ZombRand(n2)+1	-- random number generator, integers from 1 to n [eg n = 12, therefore rolls integers from 1 to 12]

--	define table 3 for rare loot. examples are from Riku's melee weapon mod which are used exclusively on PARP, Sunday Drivers, and Filthy Casuals servers.	
--	local table3 = {RMWeapons.MedSword RMWeapons.MorningStar RMWeapons.MxScythe RMWeapons.hellokittyaxe RMWeapons.glaive RMWeapons.waraxe RMWeapons.steinsword RMWeapons.mace1 RMWeapons.warhammer40k RMWeapons.bassax RMWeapons.gnbat RMWeapons.spikedsword RMWeapons.crabspear RMWeapons.firelink RMWeapons.themauler RMWeapons.bladebat RMWeapons.NulBlade RMWeapons.Falx RMWeapons.Crimson1Sword RMWeapons.sword40k RMWeapons.dagger1 RMWeapons.kindness RMWeapons.spinecrusher RMWeapons.sawbat1  RMWeapons.warhammer RMWeapons.SpikedClub1}
	local table3 = splitString(SandboxVars.RWC.table3)
	local n3 = #table3 --number of tier 3 items in loot pool
	local t3 = ZombRand(n3)+1	-- random number generator, integers from 1 to n [eg n = 23, therefore rolls integers from 1 to 23]
	
--	define table 4 for event rarity loot. examples are from Riku's melee weapon mod which are used exclusively on PARP, Sunday Drivers, and Filthy Casuals servers.	
--	local table4 = {RMWeapons.MedSword RMWeapons.MorningStar RMWeapons.MxScythe RMWeapons.hellokittyaxe RMWeapons.glaive RMWeapons.waraxe RMWeapons.steinsword RMWeapons.mace1 RMWeapons.warhammer40k RMWeapons.bassax RMWeapons.gnbat RMWeapons.spikedsword RMWeapons.crabspear RMWeapons.firelink RMWeapons.themauler RMWeapons.bladebat RMWeapons.NulBlade RMWeapons.Falx RMWeapons.Crimson1Sword RMWeapons.sword40k RMWeapons.dagger1 RMWeapons.kindness RMWeapons.spinecrusher RMWeapons.sawbat1  RMWeapons.warhammer RMWeapons.SpikedClub1}
	local table4 = splitString(SandboxVars.RWC.table4)
	local n4 = #table4 --number of tier 4 items in loot pool
	local t4 = ZombRand(n4)+1	-- random number generator, integers from 1 to n [eg n = 23, therefore rolls integers from 1 to 23]
	
-- tiered rolling, checks zone and adds item
	
	if tierzone == 3 then
		getPlayer():getInventory():AddItem(table4[t4])
	elseif tierzone == 2 then
		getPlayer():getInventory():AddItem(table3[t3])
	elseif tierzone == 1 then
		getPlayer():getInventory():AddItem(table2[t2])
	end

	getPlayer():Say("Riku Weapon Cache Upgraded To: Tier " .. tostring(tierzone + 1) .. "!")
	
end