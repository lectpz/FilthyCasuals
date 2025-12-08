function onTestTier1CheckSD(recipe, playerObj)

	local canPerform = OnCanPerform_checkNumberOfPlayers(recipe, playerObj)
	
	if not canPerform then return false end

	local player = getPlayer()
	local playerInv = player:getInventory()
	local tierzone = checkZone()
	
	if tierzone == 1 then
		return true
	else
		return false
	end
	
end

function onTestTier2CheckSD(recipe, playerObj)

	local canPerform = OnCanPerform_checkNumberOfPlayers(recipe, playerObj)
	
	if not canPerform then return false end

	local player = getPlayer()
	local playerInv = player:getInventory()
	local tierzone = checkZone()
	
	if tierzone == 2 then
		return true
	else
		return false
	end
	
end

function onTestTier3CheckSD(recipe, playerObj)

	local canPerform = OnCanPerform_checkNumberOfPlayers(recipe, playerObj)
	
	if not canPerform then return false end

	local player = getPlayer()
	local playerInv = player:getInventory()
	local tierzone = checkZone()
	
	if tierzone == 3 then
		return true
	else
		return false
	end
	
end

function onTestTier4CheckSD(recipe, playerObj)

	local canPerform = OnCanPerform_checkNumberOfPlayers(recipe, playerObj)
	
	if not canPerform then return false end

	local player = getPlayer()
	local playerInv = player:getInventory()
	local tierzone = checkZone()
	
	if tierzone == 4 then
		return true
	else
		return false
	end
	
end

function onTestTier5CheckSD(recipe, playerObj)

	local canPerform = OnCanPerform_checkNumberOfPlayers(recipe, playerObj)
	
	if not canPerform then return false end

	local player = getPlayer()
	local playerInv = player:getInventory()
	local tierzone = checkZone()
	
	if tierzone >= 5 then
		return true
	else
		return false
	end
	
end