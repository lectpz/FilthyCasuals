require "SDZoneCheck"

function onTestTier1CheckSD(sourceItem, result)

	local player = getPlayer()
	local playerInv = player:getInventory()
	local tierzone = checkZone()
	
	if tierzone == 1 then
		return true
	else
		return false
	end
	
end

function onTestTier2CheckSD(sourceItem, result)

	local player = getPlayer()
	local playerInv = player:getInventory()
	local tierzone = checkZone()
	
	if tierzone == 2 then
		return true
	else
		return false
	end
	
end

function onTestTier3CheckSD(sourceItem, result)

	local player = getPlayer()
	local playerInv = player:getInventory()
	local tierzone = checkZone()
	
	if tierzone == 3 then
		return true
	else
		return false
	end
	
end