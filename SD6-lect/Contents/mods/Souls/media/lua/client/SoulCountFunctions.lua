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



function OnTest_hasSoulCount(item)

	local player = getSpecificPlayer(0)
	
	if not item:isInPlayerInventory() then return false end
	
	if player:getPrimaryHandItem() ~= nil then
		local weapon = player:getPrimaryHandItem()
		local weaponModData = weapon:getModData() or nil
		local soulsFreed = weaponModData.KillCount or nil
		
		if item:getUsedDelta() < 1 then return false end
		
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
end

--[[

local partiallyFilledFlask= nil


function OnTest_checkFilledFlask(item)
	local player = getSpecificPlayer(0)
	if player:getPrimaryHandItem() ~= nil then
		local weapon = player:getPrimaryHandItem()
		local weaponModData = weapon:getModData()
		local soulsFreed = weaponModData.KillCount or nil
		
		if soulsFreed then
			if item:getUsedDelta() == 1 then 
				return false
			else 
				partiallyFilledFlask = item -- pass flask item down after on test
				return true
			end
		else
			return false
		end
	end
end
]]--

--[[
function OnCreate_fillSoulFlask(items, result, player)

	local fillSoulFlaskItem = partiallyFilledFlask

	local weapon = player:getPrimaryHandItem()
	local weaponModData = weapon:getModData()
	local soulsFreed = weaponModData.KillCount or nil
	
	fillSoulFlaskItem:setUsedDelta(fillSoulFlaskItem:getUsedDelta() - 1/1000) -- add souls to flask
	weaponModData.KillCount = soulsFreed + 1 -- deduct souls from soul counter
	soulsFreed = weaponModData.KillCount -- set soulsFreed
	
    while fillSoulFlaskItem:getUsedDelta() < 1 and soulsFreed > 0 do
		fillSoulFlaskItem:setUsedDelta(fillSoulFlaskItem:getUsedDelta() - 1/1000) -- add souls to flask
		weaponModData.KillCount = soulsFreed + 1 -- deduct souls from soul counter
		soulsFreed = weaponModData.KillCount -- set soulsFreed
    end

    if fillSoulFlaskItem:getUsedDelta() >= 1 then
        fillSoulFlaskItem:setUsedDelta(1);
    end
end
]]--



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
	local filledFlask = InventoryItemFactory.CreateItem("SoulForge.StoredSouls")
		
	if soulsFreed < 1000 then
		--return
		local addSouls = math.floor(soulsFreed)
		filledFlask:setUsedDelta(addSouls/1000)
		player:getInventory():AddItem(filledFlask)
		weaponModData.KillCount = soulsFreed - addSouls -- deduct souls from soul counter
	elseif soulsFreed >= 1000 then
		filledFlask:setUsedDelta(1)
		player:getInventory():AddItem(filledFlask)
		weaponModData.KillCount = soulsFreed - 1000 -- deduct souls from soul counter
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
	local t3weaps = { "RMWeapons.MorningStar", "RMWeapons.LastHope", "RMWeapons.MadamScythe", "RMWeapons.KineticHammer", "RMWeapons.Shaxe", "RMWeapons.TreeHugger", "RMWeapons.bladebat", "RMWeapons.sawbat1", "RMWeapons.gnbat", "RMWeapons.RebarClub", "RMWeapons.CatnipCrusher", "RMWeapons.MandateofHeaven", "RMWeapons.steinsword", "RMWeapons.CrimsonLance", "RMWeapons.MoonlightGS", "RMWeapons.waraxe", "RMWeapons.BigBertha" }
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
	local t4weaps = { "RMWeapons.ArcSpear", "RMWeapons.SealingStaff2", "RMWeapons.LanceofLonginus", "RMWeapons.JadeSword", "RMWeapons.bassax", "RMWeapons.EyeStaff", "RMWeapons.themauler", "RMWeapons.Nikabo", "RMWeapons.FallenCross", "RMWeapons.warhammer40k", "RMWeapons.DreamAxe", "RMWeapons.RoyalGreatsword", "RMWeapons.crabspear", "RMWeapons.MizutsuneGlaive", "RMWeapons.SwordofSolitude", "RMWeapons.firelink" }
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
	local t5weaps = { "RMWeapons.MedSword", "RMWeapons.PochitaSword", "RMWeapons.NulBlade", "RMWeapons.CavAxe", "RMWeapons.MizutsuneSword", "RMWeapons.ApostateAxe", "RMWeapons.RefudClaws", "RMWeapons.mace1", "RMWeapons.RockstarGuitar", "RMWeapons.VampClaymore" }
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