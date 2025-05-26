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
	--if isDebugEnabled() then getSpecificPlayer(0):Say(loot) end
	local newItem = InventoryItemFactory.CreateItem(loot)
	MDZ_OnCreate_MeleeWeaponVariance(newItem, true)
	getSpecificPlayer(0):getInventory():AddItem(newItem)
	addToArgs(loot)
end

local function addEmptyBoxToPlayer(loot)
	getSpecificPlayer(0):getInventory():AddItem(loot)
	addToArgs(loot)
end

local function addSoulForgedWeaponToPlayer(loot)
	local weaponFT = loot
	local scriptItem = ScriptManager.instance:getItem(weaponFT)
	local weapon = InventoryItemFactory.CreateItem(weaponFT)
	MDZ_OnCreate_MeleeWeaponVariance(weapon, true)
	local weaponModData = weapon:getModData()
	local playerObj = getSpecificPlayer(0)
	
	weaponModData.KillCount = 0
	weaponModData.SoulForged = true
	weaponModData.PlayerKills = playerObj:getZombieKills()
	weaponModData.ConditionLowerChance = 1.1
	weaponModData.MaxCondition = 1.1
	--[[weaponModData.CriticalChance	= weapon:getCriticalChance()
	weaponModData.CritDmgMultiplier	= weapon:getCritDmgMultiplier()
	weaponModData.MinDamage			= weapon:getMinDamage()
	weaponModData.MaxDamage			= weapon:getMaxDamage()
	weaponModData.MaxHitCount		= weapon:getMaxHitCount()]]
	
	local mdzPrefix = ""
	if weaponModData.mdzPrefix then mdzPrefix = weaponModData.mdzPrefix .. " " end
	
	weaponModData.Name = "Soul Forged " .. mdzPrefix .. scriptItem:getDisplayName()
	
	weapon:setName(weaponModData.Name)
	weapon:setConditionLowerChance(scriptItem:getConditionLowerChance() * weaponModData.ConditionLowerChance)
	weapon:setConditionMax(scriptItem:getConditionMax() * weaponModData.MaxCondition)

	playerObj:getInventory():AddItem(weapon)
	addToArgs(loot, 1, "SoulForged")
end

function RikuWeaponCacheSD(items, result, player)

	local zonetier, zonename, x, y, control, toxic = checkZone()

	local table1 = splitString(SandboxVars.RWC.table1)
	local n1 = #table1
	local t1 = ZombRand(n1)+1
	
	local table2 = splitString(SandboxVars.RWC.table2)
	local n2 = #table2 
	local t2 = ZombRand(n2)+1
	
	local table3 = splitString(SandboxVars.RWC.table3)
	local n3 = #table3 
	local t3 = ZombRand(n3)+1
	
	local rmwtable4 = splitString(SandboxVars.RWC.table4)
	local rmwn4 = #rmwtable4 
	local rmwt4 = ZombRand(rmwn4)+1	
	
	local rmwtable5 = splitString(SandboxVars.RWC.table5)
	local rmwn5 = #rmwtable5 
	local rmwt5 = ZombRand(rmwn5)+1	
	
	local ozdtable4 = splitString(SandboxVars.OZD.table4)
	local ozdn4 = #ozdtable4
	local ozdt4 = ZombRand(ozdn4)+1
	
	local ozdtable5 = splitString(SandboxVars.OZD.table5)
	local ozdn5 = #ozdtable4
	local ozdt5 = ZombRand(ozdn5)+1
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "Weapon Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	local pMD = player:getModData()
	local luckValue = pMD.luckValue or 0
	local permaLuck = pMD.PermaSoulForgeLuckBonus 
	if permaLuck then luckValue = luckValue + permaLuck end
	
	local function isToxicControl()
		if toxic then return true end
		if control then return true end
		return false
	end
	
-- tiered rolling, checks zone and adds item
	if (zonetier == 5 and isToxicControl() and ZombRand(3) == 0) or (zonetier == 5 and isToxicControl() and ZombRand(luckValue)+1 > 250) then
		if ZombRand(10) == 0 then
			if ZombRand(5) == 0 then
				addSoulForgedWeaponToPlayer(ozdtable5[ozdt5])
				if ZombRand(luckValue)+1 > 250 then addItemToPlayer(ozdtable5[ozdt5]) end
			else
				addSoulForgedWeaponToPlayer(rmwtable5[rmwt5])
				if ZombRand(luckValue)+1 > 250 then addItemToPlayer(rmwtable5[rmwt5]) end
			end
		else
			if ZombRand(5) == 0 then
				addItemToPlayer(ozdtable5[ozdt5])
				if ZombRand(luckValue)+1 > 250 then addItemToPlayer(ozdtable5[ozdt5]) end
			else
				addItemToPlayer(rmwtable5[rmwt5])
				if ZombRand(luckValue)+1 > 250 then addItemToPlayer(rmwtable5[rmwt5]) end
			end
		end
		sendClientCommand(player, 'sdLogger', 'OpenCache', args);
		return
	end
	--elseif zonetier == 4 then
	if zonetier >= 4 then
		if (isToxicControl() and ZombRand(10) == 0) or (isToxicControl() and ZombRand(luckValue)+1 > 200) then
			if ZombRand(5) == 0 then
				addSoulForgedWeaponToPlayer(ozdtable4[ozdt4])
				if ZombRand(luckValue)+1 > 200 then addItemToPlayer(ozdtable4[ozdt4]) end
			else
				addSoulForgedWeaponToPlayer(rmwtable4[rmwt4])
				if ZombRand(luckValue)+1 > 200 then addItemToPlayer(rmwtable4[rmwt4]) end
			end
		else
			if ZombRand(5) == 0 then
				addItemToPlayer(ozdtable4[ozdt4])
				if ZombRand(luckValue)+1 > 250 then addItemToPlayer(ozdtable4[ozdt4]) end
			else
				addItemToPlayer(rmwtable4[rmwt4])
				if ZombRand(luckValue)+1 > 250 then addItemToPlayer(rmwtable4[rmwt4]) end
			end
		end
		addEmptyBoxToPlayer("EmptyWeaponCacheT4");
	elseif zonetier == 3 then
		if (isToxicControl() and ZombRand(10) == 0) or (isToxicControl() and ZombRand(luckValue)+1 > 200) then
			addSoulForgedWeaponToPlayer(table3[t3])
			if ZombRand(luckValue)+1 > 150 then addItemToPlayer(table3[t3]) end
		else
			addItemToPlayer(table3[t3])
			if ZombRand(luckValue)+1 > 150 then addItemToPlayer(table3[t3]) end
		end
		addEmptyBoxToPlayer("EmptyWeaponCacheT3");
	elseif zonetier == 2 then
		if (isToxicControl() and ZombRand(10) == 0) or (isToxicControl() and ZombRand(luckValue)+1 > 200) then
			addSoulForgedWeaponToPlayer(table2[t2])
			if ZombRand(luckValue)+1 > 100 then addItemToPlayer(table2[t2]) end
		else
			addItemToPlayer(table2[t2])
			if ZombRand(luckValue)+1 > 100 then addItemToPlayer(table2[t2]) end
		end
		addEmptyBoxToPlayer("EmptyWeaponCacheT2");
	elseif zonetier == 1 then
		if (isToxicControl() and ZombRand(10) == 0) or (isToxicControl() and ZombRand(luckValue)+1 > 200)then
			addSoulForgedWeaponToPlayer(table1[t1])
			if ZombRand(luckValue)+1 > 50 then addItemToPlayer(table1[t1]) end
		else
			addItemToPlayer(table1[t1])
			if ZombRand(luckValue)+1 > 50 then addItemToPlayer(table1[t1]) end
		end
		addEmptyBoxToPlayer("EmptyWeaponCacheT1");
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

	local table1 = splitString(SandboxVars.RWC.table1)
	local n1 = #table1 
	local t1 = ZombRand(n1)+1

	local table2 = splitString(SandboxVars.RWC.table2)
	local n2 = #table2 
	local t2 = ZombRand(n2)+1

	local table3 = splitString(SandboxVars.RWC.table3)
	local n3 = #table3
	local t3 = ZombRand(n3)+1
	
	local table4 = splitString(SandboxVars.RWC.table4)
	local n4 = #table4 
	local t4 = ZombRand(n4)+1
	
	local table5 = splitString(SandboxVars.RWC.table5)
	local n5 = #table5 
	local t5 = ZombRand(n5)+1	
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "Upgraded Weapon Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	local pMD = player:getModData()
	local luckValue = pMD.luckValue or 0
	local permaLuck = pMD.PermaSoulForgeLuckBonus 
	if permaLuck then luckValue = luckValue + permaLuck end
	
	if zonetier == 5 then
		if (isToxicControl() and ZombRand(10) == 0) or (isToxicControl() and ZombRand(luckValue)+1 > 200) then
			addSoulForgedWeaponToPlayer(table5[t5])
			if ZombRand(luckValue)+1 > 200 then addItemToPlayer(table5[t5]) end
		else
			addItemToPlayer(table5[t5])
			if ZombRand(luckValue)+1 > 200 then addItemToPlayer(table5[t5]) end
		end
		getSpecificPlayer(0):Say("Riku Weapon Cache Upgraded To: Tier " .. tostring(zonetier) .. "!")
	elseif zonetier == 3 then
		if (isToxicControl() and ZombRand(10) == 0) or (isToxicControl() and ZombRand(luckValue)+1 > 150)  then
			addSoulForgedWeaponToPlayer(table4[t4])
			if ZombRand(luckValue)+1 > 150 then addItemToPlayer(table4[t4]) end
		else
			addItemToPlayer(table4[t4])
			if ZombRand(luckValue)+1 > 150 then addItemToPlayer(table4[t4]) end
		end
		getSpecificPlayer(0):Say("Riku Weapon Cache Upgraded To: Tier " .. tostring(zonetier + 1) .. "!")
	elseif zonetier == 2 then
		if (isToxicControl() and ZombRand(10) == 0) or (isToxicControl() and ZombRand(luckValue)+1 > 100)  then
			addSoulForgedWeaponToPlayer(table3[t3])
			if ZombRand(luckValue)+1 > 100 then addItemToPlayer(table3[t3]) end
		else
			addItemToPlayer(table3[t3])
			if ZombRand(luckValue)+1 > 100 then addItemToPlayer(table3[t3]) end
		end
		getSpecificPlayer(0):Say("Riku Weapon Cache Upgraded To: Tier " .. tostring(zonetier + 1) .. "!")
	elseif zonetier == 1 then
		if (isToxicControl() and ZombRand(10) == 0) or (isToxicControl() and ZombRand(luckValue)+1 > 50)  then
			addSoulForgedWeaponToPlayer(table2[t2])
			if ZombRand(luckValue)+1 > 50 then addItemToPlayer(table2[t2]) end
		else
			addItemToPlayer(table2[t2])
			if ZombRand(luckValue)+1 > 50 then addItemToPlayer(table2[t2]) end
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

function RerollT5(items, result, player)
	local table5 = splitString(SandboxVars.RWC.table5)

	local zonetier, zonename, x, y = checkZone()
	
	for i=0, items:size()-1 do
		local item = items:get(i)
		local indexNo = i+1
		for j=1, #table5 do
			if table5[j] == item:getFullType() then table.remove(table5[j], j) end
		end
	end
	
	local n5 = #table5 --number of tier 4 items in loot pool
	local t5 = ZombRand(n5)+1	-- random number generator, integers from 1 to n [eg n = 23, therefore rolls integers from 1 to 23]
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "T5 Reroll",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	addItemToPlayer(table5[t5])
	
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end

function RerollT4(items, result, player)
	local table4 = splitString(SandboxVars.RWC.table4)
	
	local zonetier, zonename, x, y = checkZone()
	
	for i=0, items:size()-1 do
		local item = items:get(i)
		local indexNo = i+1
		for j=1, #table4 do
			if table4[j] == item:getFullType() then table.remove(table4[j], j) end
		end
	end
	
	local n4 = #table4 --number of tier 4 items in loot pool
	local t4 = ZombRand(n4)+1	-- random number generator, integers from 1 to n [eg n = 23, therefore rolls integers from 1 to 23]
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "T4 Reroll",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	addItemToPlayer(table4[t4])
	
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end

function RerollT3(items, result, player)
	local table3 = splitString(SandboxVars.RWC.table3)
	
	local zonetier, zonename, x, y = checkZone()
	
	for i=0, items:size()-1 do
		local item = items:get(i)
		local indexNo = i+1
		for j=1, #table3 do
			if table3[j] == item:getFullType() then table.remove(table3[j], j) end
		end
	end
	
	local n3 = #table3 --number of tier 3 items in loot pool
	local t3 = ZombRand(n3)+1	-- random number generator, integers from 1 to n [eg n = 23, therefore rolls integers from 1 to 23]
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "T3 Reroll",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	addItemToPlayer(table3[t3])
	
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end

function UpgradeT5(items, result, player)
	local table5 = splitString(SandboxVars.RWC.table5)

	local zonetier, zonename, x, y = checkZone()
	
	local rmwCategory = {}
	
	local item = items:get(0)
	local scriptItem = item:getScriptItem()
	if scriptItem:getTypeString() == "Weapon" and scriptItem:getModuleName() == "RMWeapons" then
		itemCategories = scriptItem:getCategories()
		if itemCategories then
			for j=0, itemCategories:size()-1 do
				local weaponType = itemCategories:get(i)
				for k=1, #table5 do
					if ScriptManager.instance:getItem(table5[k]):getCategories():get(0) == weaponType then
						table.insert(rmwCategory, table5[k])
					end
				end
			end
		end
	end
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "T5 Reroll Type " .. ScriptManager.instance:getItem(rmwCategory[1]):getCategories():get(0),
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	addItemToPlayer(rmwCategory[ZombRand(#rmwCategory+1)])
	
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end

function UpgradeT4(items, result, player)
	local table4 = splitString(SandboxVars.RWC.table4)

	local zonetier, zonename, x, y = checkZone()
	
	local rmwCategory = {}
	
	local item = items:get(0)
	local scriptItem = item:getScriptItem()
	if scriptItem:getTypeString() == "Weapon" and scriptItem:getModuleName() == "RMWeapons" then
		itemCategories = scriptItem:getCategories()
		if itemCategories then
			for j=0, itemCategories:size()-1 do
				local weaponType = itemCategories:get(i)
				for k=1, #table4 do
					if ScriptManager.instance:getItem(table4[k]):getCategories():get(0) == weaponType then
						table.insert(rmwCategory, table4[k])
					end
				end
			end
		end
	end
	
	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "T4 Reroll Type " .. ScriptManager.instance:getItem(rmwCategory[1]):getCategories():get(0),
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	addItemToPlayer(rmwCategory[ZombRand(#rmwCategory+1)])
	
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end