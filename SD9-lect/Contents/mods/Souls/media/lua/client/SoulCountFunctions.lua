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

function OnTest_dontDestroySoulForgedGuns(item)
	
	local weaponModData = item:getModData()
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
		local soulWrought = weaponModData.SoulWrought or false
		local augments = weaponModData.Augments or 0
		
		if weapon:isFavorite() then return false end
		
		if soulForged and (soulsFreed and soulsFreed < 1) and soulWrought and augments and augments == 4 then
			return true
		end
	end
	return false
end

function OnTest_checkMainHand4x(item)
	if not canReturnSoulForge then return false end
	local player = getSpecificPlayer(0)

	if not item:isInPlayerInventory() then return false end
	
	if player:getPrimaryHandItem() ~= nil then
		local weapon = player:getPrimaryHandItem()
		local weaponModData = weapon:getModData()
		local soulsFreed = weaponModData.KillCount or nil
		local soulForged = weaponModData.SoulForged or false
		local augments = weaponModData.Augments or 0
		local soulWrought = weaponModData.SoulWrought or false
		
		if weapon:isFavorite() then return false end
		
		if soulForged and (soulsFreed and soulsFreed < 1) and augments and augments == 4 and not soulWrought then
			return true
		end
	end
	return false
end

function OnTest_checkMainHand3x(item)
	if not canReturnSoulForge then return false end
	local player = getSpecificPlayer(0)

	if not item:isInPlayerInventory() then return false end
	
	if player:getPrimaryHandItem() ~= nil then
		local weapon = player:getPrimaryHandItem()
		local weaponModData = weapon:getModData()
		local soulsFreed = weaponModData.KillCount or nil
		local soulForged = weaponModData.SoulForged or false
		local augments = weaponModData.Augments or 0
		
		if weapon:isFavorite() then return false end
		
		if soulForged and (soulsFreed and soulsFreed < 1) and augments and augments == 3 then
			return true
		end
	end
	return false
end

function OnTest_checkMainHand2x(item)
	if not canReturnSoulForge then return false end
	local player = getSpecificPlayer(0)

	if not item:isInPlayerInventory() then return false end
	
	if player:getPrimaryHandItem() ~= nil then
		local weapon = player:getPrimaryHandItem()
		local weaponModData = weapon:getModData()
		local soulsFreed = weaponModData.KillCount or nil
		local soulForged = weaponModData.SoulForged or false
		local augments = weaponModData.Augments or 0
		
		if weapon:isFavorite() then return false end
		
		if soulForged and (soulsFreed and soulsFreed < 1) and augments and augments == 2 then
			return true
		end
	end
	return false
end

function OnTest_checkMainHand1x(item)
	if not canReturnSoulForge then return false end
	local player = getSpecificPlayer(0)

	if not item:isInPlayerInventory() then return false end
	
	if player:getPrimaryHandItem() ~= nil then
		local weapon = player:getPrimaryHandItem()
		local weaponModData = weapon:getModData()
		local soulsFreed = weaponModData.KillCount or nil
		local soulForged = weaponModData.SoulForged or false
		local augments = weaponModData.Augments or 0
		
		if weapon:isFavorite() then return false end
		
		if soulForged and (soulsFreed and soulsFreed < 1) and augments and augments == 1 then
			return true
		end
	end
	return false
end

function OnTest_checkMainHand0x(item)
	if not canReturnSoulForge then return false end
	local player = getSpecificPlayer(0)

	if not item:isInPlayerInventory() then return false end
	
	if player:getPrimaryHandItem() ~= nil then
		local weapon = player:getPrimaryHandItem()
		local weaponModData = weapon:getModData()
		local soulsFreed = weaponModData.KillCount or nil
		local soulForged = weaponModData.SoulForged or false
		local augments = weaponModData.Augments or 0
		
		if weapon:isFavorite() then return false end
		
		if soulForged and (soulsFreed and soulsFreed < 1) and augments and augments == 0 then
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
			local rMD = returnBrokenWeapon:getModData()
			if returnBrokenWeapon:isRanged() then
				rMD.mdzMaxDmg = 1
				rMD.mdzMinDmg = 1
				rMD.mdzAimingTime = 1
				rMD.mdzReloadTime = 1
				rMD.mdzRecoilDelay = 1
				rMD.mdzCriticalChance = 1
				rMD.mdzCritDmgMultiplier = 1
				rMD.mdzPrefix = "Broken"
			else
				rMD.mdzMaxDmg = 1
				rMD.mdzMinDmg = 1
				rMD.mdzCriticalChance = 1
				rMD.mdzCritDmgMultiplier = 1
				rMD.mdzPrefix = "Broken"
			end
			returnBrokenWeapon:setCondition(0)
			returnBrokenWeapon:setHaveBeenRepaired(100)
			playerInv:AddItem(returnBrokenWeapon)
		end
		local prefix1 = weaponModData.prefix1 or nil
		local prefix2 = weaponModData.prefix2 or nil
		local suffix1 = weaponModData.suffix1 or nil
		local suffix2 = weaponModData.suffix2 or nil
		
		if prefix1 then 
			if wTier >= 1 then playerInv:AddItem("SoulForge.SoulCrystalT1") end
			if wTier >= 2 then playerInv:AddItem("SoulForge.SoulCrystalT2") end
			if wTier >= 3 then playerInv:AddItem("SoulForge.SoulCrystalT3") end
			--playerInv:AddItem("SoulForge.SoulCrystalT4")
		end
		if prefix2 then 
			if wTier >= 1 then playerInv:AddItem("SoulForge.SoulCrystalT1") end
			if wTier >= 2 then playerInv:AddItem("SoulForge.SoulCrystalT2") end
			if wTier >= 3 then playerInv:AddItem("SoulForge.SoulCrystalT3") end
			if wTier >= 4 then playerInv:AddItem("SoulForge.SoulCrystalT4") end
		end
		if suffix1 then 
			if wTier >= 1 then playerInv:AddItem("SoulForge.SoulCrystalT1") end
			if wTier >= 2 then playerInv:AddItem("SoulForge.SoulCrystalT2") end
			if wTier >= 3 then playerInv:AddItem("SoulForge.SoulCrystalT3") end
			--playerInv:AddItem("SoulForge.SoulCrystalT4")
		end
		if suffix2 then 
			if wTier >= 1 then playerInv:AddItem("SoulForge.SoulCrystalT1") end
			if wTier >= 2 then playerInv:AddItem("SoulForge.SoulCrystalT2") end
			if wTier >= 3 then playerInv:AddItem("SoulForge.SoulCrystalT3") end
			if wTier >= 4 then playerInv:AddItem("SoulForge.SoulCrystalT4") end
			if suffix2 == "COG" then
				playerInv:AddItems("Base.cogToken", wTier*2)
				playerInv:AddItems("Base.rangerToken", math.floor(wTier/2))
				playerInv:AddItems("Base.vwToken", math.floor(wTier/2))
			elseif suffix2 == "Ranger" then
				playerInv:AddItems("Base.cogToken", math.floor(wTier/2))
				playerInv:AddItems("Base.rangerToken", wTier*2)
				playerInv:AddItems("Base.vwToken", math.floor(wTier/2))
			elseif suffix2 == "Voidwalker" then
				playerInv:AddItems("Base.cogToken", math.floor(wTier/2))
				playerInv:AddItems("Base.rangerToken", math.floor(wTier/2))
				playerInv:AddItems("Base.vwToken", wTier*2)
			end
		end
	end
		
	if returnSoulForge then
		local wTier = weaponModData.Tier
	
		local o_weaponRepair = weapon:getHaveBeenRepaired()
		playerInv:Remove(weapon)
		player:setPrimaryHandItem(nil)
		player:setSecondaryHandItem(nil)
		
		local returnBrokenWeapon = InventoryItemFactory.CreateItem(weapon:getFullType())
		--returnBrokenWeapon:copyModData(weaponModData)
		local rMD = returnBrokenWeapon:getModData()
		
		if returnBrokenWeapon:isRanged() then
			rMD.mdzAimingTime = weaponModData.mdzAimingTime or 1
			rMD.mdzReloadTime = weaponModData.mdzReloadTime or 1
			rMD.mdzRecoilDelay = weaponModData.mdzRecoilDelay or 1
			rMD.mdzMaxDmg = weaponModData.mdzMaxDmg or 1
			rMD.mdzMinDmg = weaponModData.mdzMinDmg or 1
			rMD.mdzCriticalChance = weaponModData.mdzCriticalChance or 1
			rMD.mdzCritDmgMultiplier = weaponModData.mdzCritDmgMultiplier or 1
			rMD.mdzPrefix = weaponModData.mdzPrefix or nil
		else
			rMD.mdzMaxDmg = weaponModData.mdzMaxDmg or 1
			rMD.mdzMinDmg = weaponModData.mdzMinDmg or 1
			rMD.mdzCriticalChance = weaponModData.mdzCriticalChance or 1
			rMD.mdzCritDmgMultiplier = weaponModData.mdzCritDmgMultiplier or 1
			rMD.mdzPrefix = weaponModData.mdzPrefix or nil
		end
	
		returnBrokenWeapon:setName(returnBrokenWeapon:getScriptItem():getDisplayName())
		returnBrokenWeapon:setCondition(1)
		returnBrokenWeapon:setHaveBeenRepaired(o_weaponRepair)
		
		playerInv:AddItem(returnBrokenWeapon)
		if wTier >= 1 then playerInv:AddItem("SoulForge.SoulCrystalT1") end
		if wTier >= 2 then playerInv:AddItem("SoulForge.SoulCrystalT2") end
		if wTier >= 3 then playerInv:AddItem("SoulForge.SoulCrystalT3") end
		if wTier >= 4 then playerInv:AddItem("SoulForge.SoulCrystalT4") end
		
		if returnSoulWrought then
			local returnBrokenWeapon_sw = InventoryItemFactory.CreateItem(weapon:getFullType())
			local rMD = returnBrokenWeapon_sw:getModData()
			if returnBrokenWeapon:isRanged() then
				rMD.mdzMaxDmg = 1
				rMD.mdzMinDmg = 1
				rMD.mdzAimingTime = 1
				rMD.mdzReloadTime = 1
				rMD.mdzRecoilDelay = 1
				rMD.mdzCriticalChance = 1
				rMD.mdzCritDmgMultiplier = 1
				rMD.mdzPrefix = "Broken"
			else
				rMD.mdzMaxDmg = 1
				rMD.mdzMinDmg = 1
				rMD.mdzCriticalChance = 1
				rMD.mdzCritDmgMultiplier = 1
				rMD.mdzPrefix = "Broken"
			end
			
			returnBrokenWeapon_sw:setCondition(0)
			returnBrokenWeapon_sw:setHaveBeenRepaired(100)
			playerInv:AddItem(returnBrokenWeapon_sw)
			if wTier >= 1 then playerInv:AddItem("SoulForge.SoulCrystalT1") end
			if wTier >= 2 then playerInv:AddItem("SoulForge.SoulCrystalT2") end
			if wTier >= 3 then playerInv:AddItem("SoulForge.SoulCrystalT3") end
			if wTier >= 4 then playerInv:AddItem("SoulForge.SoulCrystalT4") end
			playerInv:AddItem("SoulForge.SoulCrystalT5")
		end
	end
	Events.OnPlayerUpdate.Add(waitToUnforge)
	player:setPrimaryHandItem(nil)
	player:setSecondaryHandItem(nil)
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

local function needToEatItAll(character, percent)
	if percent < 1 then character:Say("I need to eat the whole thing to receive the buff.") end
end

local buffTimer = {}

local function checkTimestamp(buff)
	local timestamp = getTimestamp()
	if buffTimer[buff] and (timestamp-buffTimer[buff] < 10) then
		buffTimer[buff] = timestamp
		return false
	end
	buffTimer[buff] = timestamp
	return true
end

function SoulThirstFlask_40(food, character, percent)
	needToEatItAll(character, percent)
	if percent == 1 then
		local pMD = character:getModData()
		
		if pMD.SoulThirstTimer and pMD.SoulThirstTimer > 0 then
			Events.EveryTenMinutes.Remove(decaySoulThirst) --remove previous hook
		end
		
		pMD.SoulThirstValue = 40
		pMD.SoulThirstTimer = 54 --24 hours * 60 min / 10min/tick = 24*6 = 144. So each in-game IRL hour has 72 10-minute ticks. Each 30 minutes IRL has 36 10-minute ticks
		
		Events.EveryTenMinutes.Add(decaySoulThirst)
		HaloTextHelper.addTextWithArrow(character, "Soul Thirst Buff Active. ", true, HaloTextHelper.getColorGreen());
		buffTimer["SoulThirst"] = getTimestamp()
	end
end

function LuckFlask_300(food, character, percent)
	needToEatItAll(character, percent)
	if percent == 1 then
		local pMD = character:getModData()
		
		if pMD.luckTimer and pMD.luckTimer > 0 then
			Events.EveryTenMinutes.Remove(decayLuck)
		end
		
		pMD.luckValue = 300
		pMD.luckTimer = 54 --24 hours * 60 min / 10min/tick = 24*6 = 144. So each in-game IRL hour has 72 10-minute ticks. Each 30 minutes IRL has 36 10-minute ticks
		
		Events.EveryTenMinutes.Add(decayLuck)
		HaloTextHelper.addTextWithArrow(character, "Luck Buff Active. ", true, HaloTextHelper.getColorGreen());
		buffTimer["Luck"] = getTimestamp()
	end
end

function LuckFlask_200(food, character, percent)
	needToEatItAll(character, percent)
	if percent == 1 then
		local pMD = character:getModData()
		
		if pMD.luckTimer and pMD.luckTimer > 0 then
			Events.EveryTenMinutes.Remove(decayLuck)
		end
		
		pMD.luckValue = 200
		pMD.luckTimer = 54 --24 hours * 60 min / 10min/tick = 24*6 = 144. So each in-game IRL hour has 72 10-minute ticks. Each 30 minutes IRL has 36 10-minute ticks
		
		Events.EveryTenMinutes.Add(decayLuck)
		HaloTextHelper.addTextWithArrow(character, "Luck Buff Active. ", true, HaloTextHelper.getColorGreen());
		buffTimer["Luck"] = getTimestamp()
	end
end


function LuckFlask_100(food, character, percent)
	needToEatItAll(character, percent)
	if percent == 1 then
		local pMD = character:getModData()
		
		if pMD.luckTimer and pMD.luckTimer > 0 then
			Events.EveryTenMinutes.Remove(decayLuck)
		end
		
		pMD.luckValue = 100
		pMD.luckTimer = 54 --24 hours * 60 min / 10min/tick = 24*6 = 144. So each in-game IRL hour has 72 10-minute ticks. Each 30 minutes IRL has 36 10-minute ticks
		
		Events.EveryTenMinutes.Add(decayLuck)
		HaloTextHelper.addTextWithArrow(character, "Luck Buff Active. ", true, HaloTextHelper.getColorGreen());
		buffTimer["Luck"] = getTimestamp()
	end
end

function SoulSmithFlask_2pct(food, character, percent)
	needToEatItAll(character, percent)
	if percent == 1 then
		local pMD = character:getModData()
		
		if pMD.SoulSmithTimer and pMD.SoulSmithTimer > 0 then
			Events.EveryTenMinutes.Remove(decaySoulSmith) --remove previous hook
			--Events.OnWeaponHitXp.Remove(SoulSmithOnWeaponHitXP)
		end
		
		pMD.SoulSmithValue = 2
		pMD.SoulSmithTimer = 54 --24 hours * 60 min / 10min/tick = 24*6 = 144. So each in-game IRL hour has 72 10-minute ticks. Each 30 minutes IRL has 36 10-minute ticks
		
		Events.EveryTenMinutes.Add(decaySoulSmith)
		--Events.OnWeaponHitXp.Add(SoulSmithOnWeaponHitXP)
		HaloTextHelper.addTextWithArrow(character, "Soul Smith Food Buff Active. ", true, HaloTextHelper.getColorGreen());
		buffTimer["SoulSmith"] = getTimestamp()
	end
end

function OnCreate_SoulShard(items, result, player)
	local item = items:get(0)
	local iMD = item:getModData()
	
	--[[local qualityTier = 1
	local itemPrefix = iMD.mdzPrefix
	if itemPrefix == "Exemplary" then
		qualityTier = 5
	elseif itemPrefix == "Exceptional" then
		qualityTier = 4
	elseif itemPrefix == "Superior" then
		qualityTier = 3
	elseif itemPrefix == "Refined" then
		qualityTier = 2
	end]]
	
	local qualityStats = {
	  mdzMaxDmg = iMD.mdzMaxDmg,
	  mdzMinDmg = iMD.mdzMinDmg,
	  mdzCriticalChance = iMD.mdzCriticalChance,
	  mdzCritDmgMultiplier = iMD.mdzCritDmgMultiplier
	}

	local maxValue = iMD.mdzMaxDmg
	local maxValueName = "mdzMaxDmg"

	for key, value in pairs(qualityStats) do
		if value > maxValue then
			maxValue = value
			maxValueName = key
		end
	end

	--print("The maximum value is:", maxValue)
	--print("The name of the maximum value is:", maxValueName)
	
	local inv = player:getInventory()
	local resultItem = result:getFullType()
	
	if resultItem == "SoulForge.SoulShardT5" then
		--local tier = math.min(qualityTier, 5)
		inv:AddItem("SoulForge."..maxValueName.."_EnhancerT5")--..tier)
	elseif resultItem == "SoulForge.SoulShardT4" then
		--local tier = math.min(qualityTier, 4)
		inv:AddItem("SoulForge."..maxValueName.."_EnhancerT4")--..tier)
	elseif resultItem == "SoulForge.SoulShardT3" then
		--local tier = math.min(qualityTier, 3)
		inv:AddItem("SoulForge."..maxValueName.."_EnhancerT3")--..tier)
	elseif resultItem == "SoulForge.SoulShardT2" then
		--local tier = math.min(qualityTier, 2)
		inv:AddItem("SoulForge."..maxValueName.."_EnhancerT2")--..tier)
	else
		--local tier = math.min(qualityTier, 1)
		inv:AddItem("SoulForge."..maxValueName.."_EnhancerT1")--..tier)
	end
end