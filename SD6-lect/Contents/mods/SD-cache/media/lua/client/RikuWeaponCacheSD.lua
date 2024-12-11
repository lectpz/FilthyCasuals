----------------------------------------------
--This mod created for Sunday Drivers server--
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

local args = {}

local function addToArgs(item, amount, soulforged)
	amount = amount or 1
    local newItemKey = "item" .. (#args + 1) 
    args[newItemKey] = args[newItemKey] or {} 
	local sf_txt = ""
	if soulforged == "SoulForged" then sf_txt = "SoulForged " end
    table.insert(args[newItemKey], amount .. "x " .. sf_txt .. item) 
end

local function addItemToPlayer(loot)
	getSpecificPlayer(0):getInventory():AddItem(loot)
	addToArgs(loot)
end

local function randomrollSD(zoneroll, loot)
	if ZombRand(zoneroll) == 0 then
		getSpecificPlayer(0):getInventory():AddItem(loot)
		addToArgs(loot)
	end
end

local function addSoulForgedWeaponToPlayer(loot)
	local weaponFT = loot
	local scriptItem = ScriptManager.instance:getItem(weaponFT)
	local weapon = InventoryItemFactory.CreateItem(weaponFT)
	local weaponModData = weapon:getModData()
	local playerObj = getSpecificPlayer(0)
	
	weaponModData.KillCount = 0
	weaponModData.SoulForged = true
	weaponModData.PlayerKills = playerObj:getZombieKills()
	weaponModData.ConditionLowerChance = 1.1
	weaponModData.MaxCondition = 1.1
	weaponModData.CriticalChance	= weapon:getCriticalChance()
	weaponModData.CritDmgMultiplier	= weapon:getCritDmgMultiplier()
	weaponModData.MinDamage			= weapon:getMinDamage()
	weaponModData.MaxDamage			= weapon:getMaxDamage()
	weaponModData.MaxHitCount		= weapon:getMaxHitCount()
	weaponModData.Name = "Soul Forged " .. scriptItem:getDisplayName()
	
	weapon:setName(weaponModData.Name)
	weapon:setConditionLowerChance(scriptItem:getConditionLowerChance() * weaponModData.ConditionLowerChance)
	weapon:setConditionMax(scriptItem:getConditionMax() * weaponModData.MaxCondition)

	playerObj:getInventory():AddItem(weapon)
	addToArgs(loot, 1, "SoulForged")
end

function RikuWeaponCacheSD(items, result, player)

	local zonetier, zonename, x, y, control, toxic = checkZone()

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
	
	local table5 = splitString(SandboxVars.RWC.table5)
	local n5 = #table5 --number of tier 4 items in loot pool
	local t5 = ZombRand(n5)+1	-- random number generator, integers from 1 to n [eg n = 23, therefore rolls integers from 1 to 23]
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "Weapon Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	local function isToxicControl()
		if toxic then return true end
		if control then return true end
		return false
	end
	
-- tiered rolling, checks zone and adds item
	if zonetier == 5 and isToxicControl() and ZombRand(3) == 0 then
		if ZombRand(10) == 0 then
			addSoulForgedWeaponToPlayer(table5[t5])
		else
			addItemToPlayer(table5[t5])
		end
		sendClientCommand(player, 'sdLogger', 'OpenCache', args);
		return
	end
	--elseif zonetier == 4 then
	if zonetier >= 4 then
		if isToxicControl() and ZombRand(10) == 0 then
			addSoulForgedWeaponToPlayer(table4[t4])
		else
			addItemToPlayer(table4[t4])
		end
		addItemToPlayer("EmptyWeaponCacheT4");
	elseif zonetier == 3 then
		if isToxicControl() and ZombRand(10) == 0 then
			addSoulForgedWeaponToPlayer(table3[t3])
		else
			addItemToPlayer(table3[t3])
		end
		addItemToPlayer("EmptyWeaponCacheT3");
	elseif zonetier == 2 then
		if isToxicControl() and ZombRand(10) == 0 then
			addSoulForgedWeaponToPlayer(table2[t2])
		else
			addItemToPlayer(table2[t2])
		end
		addItemToPlayer("EmptyWeaponCacheT2");
	elseif zonetier == 1 then
		if isToxicControl() and ZombRand(10) == 0 then
			addSoulForgedWeaponToPlayer(table1[t1])
		else
			addItemToPlayer(table1[t1])
		end
		addItemToPlayer("EmptyWeaponCacheT1");
	end
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end


function RikuWeaponCacheUpgradeSD(items, result, player)

	local zonetier, zonename, x, y, control, toxic = checkZone()
	
	local function isToxicControl()
		if toxic then return true end
		if control then return true end
		return false
	end
	
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
	
	local table5 = splitString(SandboxVars.RWC.table5)
	local n5 = #table5 --number of tier 4 items in loot pool
	local t5 = ZombRand(n5)+1	-- random number generator, integers from 1 to n [eg n = 23, therefore rolls integers from 1 to 23]
	
-- tiered rolling, checks zone and adds item
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "Upgraded Weapon Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	if zonetier == 5 then
		if isToxicControl() and ZombRand(10) == 0 then
			addSoulForgedWeaponToPlayer(table5[t5])
		else
			addItemToPlayer(table5[t5])
		end
		getSpecificPlayer(0):Say("Riku Weapon Cache Upgraded To: Tier " .. tostring(zonetier + 1) .. "!")
	elseif zonetier == 3 then
		if isToxicControl() and ZombRand(10) == 0 then
			addSoulForgedWeaponToPlayer(table4[t4])
		else
			addItemToPlayer(table4[t4])
		end
		getSpecificPlayer(0):Say("Riku Weapon Cache Upgraded To: Tier " .. tostring(zonetier + 1) .. "!")
	elseif zonetier == 2 then
		if isToxicControl() and ZombRand(10) == 0 then
			addSoulForgedWeaponToPlayer(table3[t3])
		else
			addItemToPlayer(table3[t3])
		end
		getSpecificPlayer(0):Say("Riku Weapon Cache Upgraded To: Tier " .. tostring(zonetier + 1) .. "!")
	elseif zonetier == 1 then
		if isToxicControl() and ZombRand(10) == 0 then
			addSoulForgedWeaponToPlayer(table2[t2])
		else
			addItemToPlayer(table2[t2])
		end
		getSpecificPlayer(0):Say("Riku Weapon Cache Upgraded To: Tier " .. tostring(zonetier + 1) .. "!")
	end
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end

function RikuRewardsT5(items, result, player)
	local table5 = splitString(SandboxVars.RWC.table5)
	local n5 = #table5 --number of tier 4 items in loot pool
	local t5 = ZombRand(n5)+1	-- random number generator, integers from 1 to n [eg n = 23, therefore rolls integers from 1 to 23]
	
	local zonetier, zonename, x, y = checkZone()
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "T5 Event Weapon Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	addItemToPlayer(table5[t5])
	
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end

function RikuRewardsT4(items, result, player)
	local table4 = splitString(SandboxVars.RWC.table4)
	local n4 = #table4 --number of tier 4 items in loot pool
	local t4 = ZombRand(n4)+1	-- random number generator, integers from 1 to n [eg n = 23, therefore rolls integers from 1 to 23]
	
	local zonetier, zonename, x, y = checkZone()
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "T4 Event Weapon Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	addItemToPlayer(table4[t4])
	
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end

function RikuRewardsT3(items, result, player)
	local table3 = splitString(SandboxVars.RWC.table3)
	local n3 = #table3 --number of tier 3 items in loot pool
	local t3 = ZombRand(n3)+1	-- random number generator, integers from 1 to n [eg n = 23, therefore rolls integers from 1 to 23]
	
	local zonetier, zonename, x, y = checkZone()
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "T3 Event Weapon Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	addItemToPlayer(table3[t3])
	
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end
