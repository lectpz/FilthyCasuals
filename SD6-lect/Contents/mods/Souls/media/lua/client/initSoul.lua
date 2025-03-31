----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
----------------------------------------------

local function KillCount(player)
	return player:getZombieKills()
end

local function initSoul(character, inventoryItem)
	if character ~= getSpecificPlayer(0) then return end
	if inventoryItem == nil then
	--do nothing
	elseif inventoryItem:IsWeapon() and not inventoryItem:isRanged() then
		local modData = inventoryItem:getModData()
		if modData.KillCount == nil then
			modData.KillCount = 0
		end
		modData.PlayerKills = KillCount(character)
		
		if not modData.Tier then
			local o_scriptItem = ScriptManager.instance:getItem(inventoryItem:getFullType())
			if not modData.Tier then
				local maxDmg = o_scriptItem:getMaxDamage()
				if maxDmg >= 5.25 then
					modData.Tier = 5
				elseif maxDmg >= 4.375 then
					modData.Tier = 4
				elseif maxDmg >= 3.5 then
					modData.Tier = 3
				elseif maxDmg >= 2.625 then
					modData.Tier = 2
				else
					modData.Tier = 1
				end
			end
		end
	elseif inventoryItem:IsWeapon() and inventoryItem:isRanged() then
		local modData = inventoryItem:getModData()
		if modData.KillCount == nil then
			modData.KillCount = 0
		end
		modData.PlayerKills = KillCount(character)
		
		if not modData.Tier then
			local itemPrefix = modData.mdzPrefix
			local o_scriptItem = ScriptManager.instance:getItem(inventoryItem:getFullType())
		
			if not itemPrefix then return end
			if itemPrefix == "Exemplary" then
				modData.Tier = 5
			elseif itemPrefix == "Exceptional" then
				modData.Tier = 4
			elseif itemPrefix == "Superior" then
				modData.Tier = 3
			elseif itemPrefix == "Refined" then
				modData.Tier = 2
			else
				modData.Tier = 1				
			end
		end
	end
end

Events.OnEquipPrimary.Add(initSoul)
