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

		if soulsFreed > 0 then	
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
	
	local player = getSpecificPlayer(0)
	local weapon = player:getPrimaryHandItem()
	local soulsFreed = item:getModData().KillCount or nil
	
	if item:isFavorite() or (soulsFreed and soulsFreed > 0) then
		return false
	else
		return true
	end
	
<<<<<<< HEAD
end

function OnTest_isInPlayerInventory(item)

	local player = getSpecificPlayer(0)
	
	if item:isInPlayerInventory() then
		return true 
	else
		return false 
	end
	
=======
>>>>>>> 08a3ee505703ffe5f8115b56e066db775091aef4
end