local args = {}

local function addToArgs(item, amount, itemname)
	local item = itemname or item
	amount = amount or 1
    local newItemKey = "item" .. (#args + 1) 
    args[newItemKey] = args[newItemKey] or {}  
    table.insert(args[newItemKey], amount .. "x " .. item) 
end

local function addItemsToPlayer(loot, amount)
	getSpecificPlayer(0):getInventory():AddItems(loot, amount)
	addToArgs(loot, amount)
end

local function addItemToPlayer(loot)
	getSpecificPlayer(0):getInventory():AddItem(loot)
	addToArgs(loot)
end

function checkSoulCount(item)
	local player = getSpecificPlayer(0)
	if player:getPrimaryHandItem() ~= nil then
		local weapon = player:getPrimaryHandItem()
		local weaponModData = weapon:getModData()
		local soulsFreed = weaponModData.KillCount or nil
		
		if soulsFreed and (soulsFreed >= 1000) then
			return true
		else
			return false
		end
	end
end

local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "[^ %;,]+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

function OnTest_hasSoulCount(item)

	local player = getSpecificPlayer(0)
	
	if not item:isInPlayerInventory() then return false end
	
	if player:getPrimaryHandItem() ~= nil then
		local weapon = player:getPrimaryHandItem()
		local weaponModData = weapon:getModData() or nil
		local soulsFreed = weaponModData.KillCount or nil
		
		if math.floor(item:getUsedDelta()*1000+0.5) < 1 then return false end
		
		if soulsFreed then
			--hasSoulCount_counter = item:getUsedDelta() -- if there are souls in the weapon, set soulcount counter variable to pass down to onCreate
			return true
		else
			return false
		end
	else
		return false
	end
	
end

function OnCreate_addFullSoulCount(items, result, player)
	local weapon = player:getPrimaryHandItem()
	local weaponModData = weapon:getModData()
	local soulsFreed = weaponModData.KillCount or nil
	weaponModData.KillCount = soulsFreed + 1000 -- add souls from destroyed soul counter
	soulsFreed = weaponModData.KillCount
	--result:setUsedDelta(0)
end
function OnCreate_addGiantFullSoulCount(items, result, player)
	local weapon = player:getPrimaryHandItem()
	local weaponModData = weapon:getModData()
	local soulsFreed = weaponModData.KillCount or nil
	weaponModData.KillCount = soulsFreed + 10000 -- add souls from destroyed soul counter
	soulsFreed = weaponModData.KillCount
	--result:setUsedDelta(0)
end

function OnCreate_transferSoulCount(items, result, player)
	local weapon = player:getPrimaryHandItem()
	local weaponModData = weapon:getModData()
	--weaponModData.KillCount = weaponModData.KillCount + 1000
	--result:setUsedDelta(0)
	local flask = nil
    for i=0, items:size()-1 do
       if items:get(i):getFullType() == "SoulForge.StoredSoulsSD_new" then
           flask = items:get(i)
		   break
       end
    end
	local flaskCharges = 10000
	result:setUsedDelta((math.floor(flask:getUsedDelta()*flaskCharges+0.5)-1)/flaskCharges)
	weaponModData.KillCount = weaponModData.KillCount + 1
	
	while math.floor(result:getUsedDelta()*flaskCharges+0.5) > 0 do
		result:setUsedDelta((math.floor(result:getUsedDelta()*flaskCharges+0.5)-1)/flaskCharges)
		weaponModData.KillCount = weaponModData.KillCount + 1
	end
end

function OnCreate_convertSoulFlask(items, result, player)
	local flask = nil
    for i=0, items:size()-1 do
       if items:get(i):getFullType() == "SoulForge.StoredSouls" then
           flask = items:get(i)
		   break
       end
    end
	local oldflaskCharges = 1000
	
	local newFlask = InventoryItemFactory.CreateItem("SoulForge.StoredSoulsSD_new")
	local newflaskCharges = 10000
	
	result:setUsedDelta((math.floor(flask:getUsedDelta()*oldflaskCharges+0.5))/newflaskCharges)
end

function OnCreate_convertSoulFlask_new(items, result, player)
	result:setUsedDelta(0.1)
end

function OnTest_checkEmptyFlask(item)
	local player = getSpecificPlayer(0)
	
	if not item:isInPlayerInventory() then return false end
	
	if player:getPrimaryHandItem() ~= nil then
		local weapon = player:getPrimaryHandItem()
		local weaponModData = weapon:getModData()
		local soulsFreed = weaponModData.KillCount or nil

		if soulsFreed and soulsFreed > 0 then	
			return true
		else
			return false
		end
	end
end

function OnCreate_fillEmptySoulFlask(items, result, player)

	local weapon = player:getPrimaryHandItem()
	local weaponModData = weapon:getModData()
	local soulsFreed = weaponModData.KillCount or nil
	local filledFlask = InventoryItemFactory.CreateItem("SoulForge.StoredSoulsSD_new")
	
	local flaskCharges = 10000
	
	if soulsFreed < flaskCharges then
		--return
		local addSouls = math.floor(soulsFreed+0.5)
		filledFlask:setUsedDelta(addSouls/flaskCharges)
		player:getInventory():AddItem(filledFlask)
		weaponModData.KillCount = soulsFreed - addSouls -- deduct souls from soul counter
	elseif soulsFreed >= flaskCharges then
		filledFlask:setUsedDelta(1)
		player:getInventory():AddItem(filledFlask)
		weaponModData.KillCount = soulsFreed - flaskCharges -- deduct souls from soul counter
	end
	
end

function OnTest_dontDestroySouls(item)

	if not item:isInPlayerInventory() then return false end
	
	local weaponModData = item:getModData()
	local player = getSpecificPlayer(0)
	local soulsFreed = weaponModData.KillCount or nil
	local soulForged = weaponModData.SoulForged or false
	
	if item:isFavorite() or (soulsFreed and soulsFreed > 0) or soulForged then
		return false
	else
		return true
	end
	
end

function OnTest_isInPlayerInventory(item)

	local player = getSpecificPlayer(0)
	
	if item:isInPlayerInventory() then
		return true 
	else
		return false 
	end
	
end

function OnCreate_RerollT3(items, result, player)
	local t3weaps = splitString(SandboxVars.OZD.table3)
	local rn = ZombRand(#t3weaps)+1
	local weapon = t3weaps[rn]
	
	local zonetier, zonename, x, y = checkZone()
	
	args = {
	  player_name = getOnlineUsername(),
	  reroll = "RerollT3",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}

	addItemToPlayer(weapon)
	
	sendClientCommand(player, 'sdLogger', 'RerollWeapon', args);
end

function OnCreate_RerollT4(items, result, player)
	local t4weaps = splitString(SandboxVars.OZD.table4)
	local rn = ZombRand(#t4weaps)+1
	local weapon = t4weaps[rn]
	
	local zonetier, zonename, x, y = checkZone()
	
	args = {
	  player_name = getOnlineUsername(),
	  reroll = "RerollT4",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}

	addItemToPlayer(weapon)
	
	sendClientCommand(player, 'sdLogger', 'RerollWeapon', args);
end

function OnCreate_RerollT5(items, result, player)
	local t5weaps = splitString(SandboxVars.OZD.table5)
	local rn = ZombRand(#t5weaps)+1
	local weapon = t5weaps[rn]
	
	local zonetier, zonename, x, y = checkZone()
	
	args = {
	  player_name = getOnlineUsername(),
	  reroll = "RerollT5",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}

	addItemToPlayer(weapon)
	
	sendClientCommand(player, 'sdLogger', 'RerollWeapon', args);
end

function OnTest_checkSoulFlask(item)
	local player = getSpecificPlayer(0)
	
	if not item:isInPlayerInventory() then return false end
	
	if item:getFullType() == "SoulForge.StoredSoulsSD_new" then
        if item:getUsedDelta() == 1 then return false; end
    end
	
	if player:getPrimaryHandItem() ~= nil then
		local weapon = player:getPrimaryHandItem()
		local weaponModData = weapon:getModData()
		local soulsFreed = weaponModData.KillCount or nil

		if soulsFreed and soulsFreed > 0 then	
			return true
		else
			return false
		end
	else
		return false
	end
end

function OnCreate_fillSoulFlask(items, result, player)

	local weapon = player:getPrimaryHandItem()
	local weaponModData = weapon:getModData()
	local soulsFreed = weaponModData.KillCount or nil

    local previousFlask = nil;
    for i=0, items:size()-1 do
       if items:get(i):getFullType() == "SoulForge.StoredSoulsSD_new" then
           previousFlask = items:get(i);
		   break
       end
    end
	
	local flaskCharges = 10000
	local previousFlaskCharge = previousFlask:getUsedDelta()
	local flaskChargeRemaining = flaskCharges - math.floor(previousFlaskCharge*flaskCharges+0.5) -- get flask charge remaining integer value

	if soulsFreed < flaskChargeRemaining then -- if # of souls cannot fill flask
		local addSouls = math.floor(soulsFreed+0.5)/flaskCharges -- addSouls is in units of 0.001
		result:setUsedDelta(previousFlaskCharge+addSouls);
		weaponModData.KillCount = 0
	elseif soulsFreed == flaskChargeRemaining then -- if # of souls is equal to flask delta
		weaponModData.KillCount = 0
		result:setUsedDelta(1);
	elseif soulsFreed > flaskChargeRemaining then -- if flask cannot hold all the souls
		weaponModData.KillCount = math.floor(weaponModData.KillCount - flaskChargeRemaining + 0.5)
		result:setUsedDelta(1);
	end

	
end

function OnTest_checkEmptySoulFlask(item)
	local player = getSpecificPlayer(0)
	
	if not item:isInPlayerInventory() then return false end
	
	if item:getFullType() == "SoulForge.StoredSoulsSD_new" then
        if item:getUsedDelta() == 0 then return true; end
    elseif item:getFullType() == "Base.LeatherStrips" then 
		return true 
	end
	
	return false
end

function OnCreate_EmptySoulFlask(items, result, player)
	local soulFlask = InventoryItemFactory.CreateItem("SoulForge.StoredSoulsSD_new")
	soulFlask:setUsedDelta(0)
	playerObj:getInventory():AddItem(soulFlask)
end

local canReturnSoulForge = true
local waitTimer = 0

local function waitToUnforge()
	waitTimer = waitTimer + 1
	if waitTimer > 1000 then
		waitTimer = 0
		canReturnSoulForge = true
		Events.OnPlayerUpdate.Remove(waitToUnforge)
	end
end

function OnTest_checkMainHand(item)
	if not canReturnSoulForge then return false end
	local player = getSpecificPlayer(0)

	if not item:isInPlayerInventory() then return false end
	
	if player:getPrimaryHandItem() ~= nil then
		local weapon = player:getPrimaryHandItem()
		local weaponModData = weapon:getModData()
		local soulsFreed = weaponModData.KillCount or nil
		local soulForged = weaponModData.SoulForged or false
		
		if weapon:isFavorite() then return false end
		
		if soulForged and (soulsFreed and soulsFreed < 1) then
			return true
		end
	end
	return false
end

function OnCreate_unforgeMainHand(items, result, player)
	if not canReturnSoulForge then return end
	canReturnSoulForge = false
	local playerInv = player:getInventory()
	local weapon = player:getPrimaryHandItem()
	local weaponModData = weapon:getModData()
	local soulForged = weaponModData.SoulForged or false
	local soulWrought = weaponModData.SoulWrought or false
	local augments = weaponModData.Augments
	local returnSoulForge = false
	local returnAugments = false
	local returnSoulWrought = false
	
	if soulForged then 
		returnSoulForge = true
		if not weaponModData.Tier then
			local o_scriptItem = ScriptManager.instance:getItem(weapon:getFullType())
			if not weaponModData.Tier then
				local maxDmg = o_scriptItem:getMaxDamage()
				if maxDmg >= 5.25 then
					weaponModData.Tier = 5
				elseif maxDmg >= 4.375 then
					weaponModData.Tier = 4
				elseif maxDmg >= 3.5 then
					weaponModData.Tier = 3
				elseif maxDmg >= 2.625 then
					weaponModData.Tier = 2
				else
					weaponModData.Tier = 1
				end
			end
		end
	end
	
	if augments then returnAugments = true end
	
	if soulWrought then returnSoulWrought = true end
	
	if returnAugments then
		
		local wTier = weaponModData.Tier
		
		for i=1,augments do
			local returnBrokenWeapon = InventoryItemFactory.CreateItem(weapon:getFullType())
			returnBrokenWeapon:setCondition(0)
			returnBrokenWeapon:setHaveBeenRepaired(25)
			playerInv:AddItem(returnBrokenWeapon)
		end
		local p1_desc = weaponModData.p1_desc or nil
		local p2_desc = weaponModData.p2_desc or nil
		local s1_desc = weaponModData.s1_desc or nil
		local s2_desc = weaponModData.s2_desc or nil
		
		if p1_desc then 
			if wTier >= 1 then playerInv:AddItem("SoulForge.SoulCrystalT1") end
			if wTier >= 2 then playerInv:AddItem("SoulForge.SoulCrystalT2") end
			if wTier >= 3 then playerInv:AddItem("SoulForge.SoulCrystalT3") end
			--playerInv:AddItem("SoulForge.SoulCrystalT4")
		end
		if p2_desc then 
			if wTier >= 1 then playerInv:AddItem("SoulForge.SoulCrystalT1") end
			if wTier >= 2 then playerInv:AddItem("SoulForge.SoulCrystalT2") end
			if wTier >= 3 then playerInv:AddItem("SoulForge.SoulCrystalT3") end
			if wTier >= 4 then playerInv:AddItem("SoulForge.SoulCrystalT4") end
		end
		if s1_desc then 
			if wTier >= 1 then playerInv:AddItem("SoulForge.SoulCrystalT1") end
			if wTier >= 2 then playerInv:AddItem("SoulForge.SoulCrystalT2") end
			if wTier >= 3 then playerInv:AddItem("SoulForge.SoulCrystalT3") end
			--playerInv:AddItem("SoulForge.SoulCrystalT4")
		end
		if s2_desc then 
			if wTier >= 1 then playerInv:AddItem("SoulForge.SoulCrystalT1") end
			if wTier >= 2 then playerInv:AddItem("SoulForge.SoulCrystalT2") end
			if wTier >= 3 then playerInv:AddItem("SoulForge.SoulCrystalT3") end
			if wTier >= 4 then playerInv:AddItem("SoulForge.SoulCrystalT4") end
		end
	end
		
	if returnSoulForge then
		local wTier = weaponModData.Tier
	
		local o_weaponRepair = weapon:getHaveBeenRepaired()
		playerInv:Remove(weapon)
		player:setPrimaryHandItem(nil)
		
		local returnBrokenWeapon = InventoryItemFactory.CreateItem(weapon:getFullType())
		returnBrokenWeapon:setCondition(0)
		returnBrokenWeapon:setHaveBeenRepaired(o_weaponRepair)
		
		playerInv:AddItem(returnBrokenWeapon)
		if wTier >= 1 then playerInv:AddItem("SoulForge.SoulCrystalT1") end
		if wTier >= 2 then playerInv:AddItem("SoulForge.SoulCrystalT2") end
		if wTier >= 3 then playerInv:AddItem("SoulForge.SoulCrystalT3") end
		if wTier >= 4 then playerInv:AddItem("SoulForge.SoulCrystalT4") end
		
		if returnSoulWrought then
			local returnBrokenWeapon_sw = InventoryItemFactory.CreateItem(weapon:getFullType())
			returnBrokenWeapon_sw:setCondition(0)
			returnBrokenWeapon_sw:setHaveBeenRepaired(o_weaponRepair)
			playerInv:AddItem(returnBrokenWeapon_sw)
			if wTier >= 1 then playerInv:AddItem("SoulForge.SoulCrystalT1") end
			if wTier >= 2 then playerInv:AddItem("SoulForge.SoulCrystalT2") end
			if wTier >= 3 then playerInv:AddItem("SoulForge.SoulCrystalT3") end
			if wTier >= 4 then playerInv:AddItem("SoulForge.SoulCrystalT4") end
			playerInv:AddItem("SoulForge.SoulCrystalT5")
		end
	end
	Events.OnPlayerUpdate.Add(waitToUnforge)
end

--------------------------------------------------------------------------------------------------------
--reroll augments


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

SoulForgeReroll = {}

SoulForgeReroll.MinDmgTicket = function(items, result, player)
	local augments = { "SoulForge.MinDmgTicket", "SoulForge.MaxDmgTicket", "SoulForge.CritChanceTicket", "SoulForge.CritMultiTicket", "SoulForge.EnduranceModTicket", "Base.bagCapacityTicket", "Base.bagWeightTicket", }
	local augmentsweight = { 2, 8, 9, 10, 2, 6, 4, }

	for i=1, #augments do
		if augments[i] == "SoulForge.MinDmgTicket" then
			table.remove(augments, i)
			table.remove(augmentsweight, i)
			break
		end
	end

	player:getInventory():AddItem(getWeightedItem(augments, augmentsweight, ZombRand(1,getTotalTableWeight(augmentsweight))))
end

SoulForgeReroll.MaxDmgTicket = function(items, result, player)
	local augments = { "SoulForge.MinDmgTicket", "SoulForge.MaxDmgTicket", "SoulForge.CritChanceTicket", "SoulForge.CritMultiTicket", "SoulForge.EnduranceModTicket", "Base.bagCapacityTicket", "Base.bagWeightTicket", }
	local augmentsweight = { 2, 8, 9, 10, 2, 6, 4, }
	
	for i=1, #augments do
		if augments[i] == "SoulForge.MaxDmgTicket" then
			table.remove(augments, i)
			table.remove(augmentsweight, i)
			break
		end
	end

	player:getInventory():AddItem(getWeightedItem(augments, augmentsweight, ZombRand(1,getTotalTableWeight(augmentsweight))))
end

SoulForgeReroll.CritChanceTicket = function(items, result, player)
	local augments = { "SoulForge.MinDmgTicket", "SoulForge.MaxDmgTicket", "SoulForge.CritChanceTicket", "SoulForge.CritMultiTicket", "SoulForge.EnduranceModTicket", "Base.bagCapacityTicket", "Base.bagWeightTicket", }
	local augmentsweight = { 2, 8, 9, 10, 2, 6, 4, }
	
	for i=1, #augments do
		if augments[i] == "SoulForge.CritChanceTicket" then
			table.remove(augments, i)
			table.remove(augmentsweight, i)
			break
		end
	end

	player:getInventory():AddItem(getWeightedItem(augments, augmentsweight, ZombRand(1,getTotalTableWeight(augmentsweight))))
end

SoulForgeReroll.CritMultiTicket = function(items, result, player)
	local augments = { "SoulForge.MinDmgTicket", "SoulForge.MaxDmgTicket", "SoulForge.CritChanceTicket", "SoulForge.CritMultiTicket", "SoulForge.EnduranceModTicket", "Base.bagCapacityTicket", "Base.bagWeightTicket", }
	local augmentsweight = { 2, 8, 9, 10, 2, 6, 4, }
	
	for i=1, #augments do
		if augments[i] == "SoulForge.CritMultiTicket" then
			table.remove(augments, i)
			table.remove(augmentsweight, i)
			break
		end
	end

	player:getInventory():AddItem(getWeightedItem(augments, augmentsweight, ZombRand(1,getTotalTableWeight(augmentsweight))))
end

SoulForgeReroll.EnduranceModTicket = function(items, result, player)
	local augments = { "SoulForge.MinDmgTicket", "SoulForge.MaxDmgTicket", "SoulForge.CritChanceTicket", "SoulForge.CritMultiTicket", "SoulForge.EnduranceModTicket", "Base.bagCapacityTicket", "Base.bagWeightTicket", }
	local augmentsweight = { 2, 8, 9, 10, 2, 6, 4, }
	
	for i=1, #augments do
		if augments[i] == "SoulForge.EnduranceModTicket" then
			table.remove(augments, i)
			table.remove(augmentsweight, i)
			break
		end
	end

	player:getInventory():AddItem(getWeightedItem(augments, augmentsweight, ZombRand(1,getTotalTableWeight(augmentsweight))))
end

SoulForgeReroll.bagCapacityTicket = function(items, result, player)
	local augments = { "SoulForge.MinDmgTicket", "SoulForge.MaxDmgTicket", "SoulForge.CritChanceTicket", "SoulForge.CritMultiTicket", "SoulForge.EnduranceModTicket", "Base.bagCapacityTicket", "Base.bagWeightTicket", }
	local augmentsweight = { 2, 8, 9, 10, 2, 6, 4, }
	
	for i=1, #augments do
		if augments[i] == "SoulForge.bagCapacityTicket" then
			table.remove(augments, i)
			table.remove(augmentsweight, i)
			break
		end
	end

	player:getInventory():AddItem(getWeightedItem(augments, augmentsweight, ZombRand(1,getTotalTableWeight(augmentsweight))))
end

SoulForgeReroll.bagWeightTicket = function(items, result, player)
	local augments = { "SoulForge.MinDmgTicket", "SoulForge.MaxDmgTicket", "SoulForge.CritChanceTicket", "SoulForge.CritMultiTicket", "SoulForge.EnduranceModTicket", "Base.bagCapacityTicket", "Base.bagWeightTicket", }
	local augmentsweight = { 2, 8, 9, 10, 2, 6, 4, }
	
	for i=1, #augments do
		if augments[i] == "SoulForge.bagWeightTicket" then
			table.remove(augments, i)
			table.remove(augmentsweight, i)
			break
		end
	end

	player:getInventory():AddItem(getWeightedItem(augments, augmentsweight, ZombRand(1,getTotalTableWeight(augmentsweight))))
end