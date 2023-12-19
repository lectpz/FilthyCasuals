require "ZoneCheckFC"

function onTestTier1CheckFC(sourceItem, result)

	local player = getPlayer()
	local playerInv = player:getInventory()
	local tierzone = checkZone()
	
	if tierzone ~=1 then
		player:Say("If I want a Tier 2 box I need to do this in a Tier 1 zone.")
		return false
	else
		return true
	end
	
end

function onTestTier2CheckFC(sourceItem, result)

	local player = getPlayer()
	local playerInv = player:getInventory()
	local tierzone = checkZone()
	
	if tierzone ~=2 then
		player:Say("If I want a Tier 3 box I need to do this in a Tier 2 zone.")
		return false
	else
		return true
	end
	
end

function onTestTier3CheckFC(sourceItem, result)

	local player = getPlayer()
	local playerInv = player:getInventory()
	local tierzone = checkZone()
	
	if tierzone ~=3 then
		player:Say("If I want a Tier 4 box I need to do this in a Tier 3 zone.")
		return false
	else
		return true
	end
	
end