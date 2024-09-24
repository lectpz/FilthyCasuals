----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
----------------------------------------------

local function KillCount(player)
	return player:getZombieKills()
end

local function initSoul(character, inventoryItem)
	if inventoryItem == nil then
	--do nothing
	elseif inventoryItem:IsWeapon() and not inventoryItem:isRanged() then
		local modData = inventoryItem:getModData()
		if modData.KillCount == nil then
			modData.KillCount = 0
		end
		modData.PlayerKills = KillCount(character)
	end
end

Events.OnEquipPrimary.Add(initSoul)
