----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------
local args = {}

local function FCteleport(player, args) -- teleporter function that executes when context menu passes checks
	local player = getPlayer()
	local safehouse = SafeHouse.hasSafehouse(player);--define safehouse

	local x1 = safehouse:getX()
	local y1 = safehouse:getY()
	local x2 = safehouse:getW() + x1
	local y2 = safehouse:getH() + y1
	
	getSoundManager():PlayWorldSound("s_teleport", false, player:getCurrentSquare(), 30, 3, 10, false) ; -- define teleport sound
	local soundRadius = 3
	local volume = 6
	addSound(player, player:getX(), player:getY(), player:getZ(), soundRadius, volume) -- play sound
	
	if player:getModData().SafeHouseX ~= nil and player:getModData().SafeHouseY ~= nil then
	--check if saved safehouse coordinates are within existing safehouse coordinates
		if player:getModData().SafeHouseX >= x1 and player:getModData().SafeHouseY >= y1 and player:getModData().SafeHouseX <= x2 and player:getModData().SafeHouseY <= y2 then--if saved moddata SH is within current SH boundaries then define x, y, z coordinate for teleport
			player:setX(player:getModData().SafeHouseX) -- teleport to safehouse coordinates that are defined the moment you press teleport from context menu. uses x, y, z definitions.
			player:setY(player:getModData().SafeHouseY)
			player:setLx(player:getModData().SafeHouseX)
			player:setLy(player:getModData().SafeHouseY)
		else--if saved moddata SH is not within current SH boundaries then write overwrite existing moddata and definte x, y, z coordinate for teleport
			player:getModData().SafeHouseX = safehouse:getX() --write moddata to player to save safehouse X coordinate
			player:getModData().SafeHouseY = safehouse:getY() --write moddata to player to save safehouse Y coordinate
			
			player:setX(player:getModData().SafeHouseX) -- teleport to new default safehouse coordinates that are defined the moment you press teleport from context menu. uses x, y, z definitions.
			player:setY(player:getModData().SafeHouseY)
			player:setLx(player:getModData().SafeHouseX)
			player:setLy(player:getModData().SafeHouseY)

			player:Say("Old coordinates no longer within Safehouse. Reset coordinates set to: x=" .. tostring(player:getModData().SafeHouseX) ..", y=" .. tostring(player:getModData().SafeHouseY))
		end
	else--if no moddata just teleport to the corner of SH bounds
		player:setX(x1) -- teleport to safehouse coordinates that are defined the moment you press teleport from context menu. uses x, y, z definitions.
		player:setY(y1)
		player:setLx(x1)
		player:setLy(y1)
		player:Say("Teleporting to default Safehouse coordinates : x=" .. tostring(x1) ..", y=" .. tostring(y1) ..". I should set my coordinates next time.")
	end
	
	player:getInventory():RemoveOneOf("Teleporter") -- randomly remove one of this item from your inventory (or equipped bag)
end

local FCteleporterContextMenuObjectName = {};

--context menu option for teleport
FCteleporterContextMenuObjectName.doFCteleport = function(item, player)
	local player = getPlayer()
	local safehouse = SafeHouse.hasSafehouse(player);--define safehouse
	
	if player:getStats():getNumVisibleZombies() > 0 or player:getStats():getNumChasingZombies() > 0 or player:getStats():getNumVeryCloseZombies() > 0 then -- check if zombies are close by
		player:Say("It doesn't feel safe to do that here.")
	elseif not safehouse then -- check if there is a valid safehouse
		player:Say("It would be nice if I had a Safehouse though.") 
	else -- if safehouse exists then get safehouse coordinates and locally define the item as an arg value, and execute timed action FCteleport() for player, using args
		ISTimedActionQueue.add(doFCteleport:new(player, FCteleport(), args));--timed action for function
	end

end

--context menu option to add safehouse coordinate
FCteleporterContextMenuObjectName.doFCsafehousecoord = function(item, player)
	local player = getPlayer()
	local safehouse = SafeHouse.hasSafehouse(player);--define safehouse
	local item = item
	
	if safehouse then -- check if there is a valid safehouse
		
		local x = player:getX()
		local y = player:getY()
		local z = player:getZ()
		
		local x1 = safehouse:getX()
		local y1 = safehouse:getY()
		local x2 = safehouse:getW() + x1
		local y2 = safehouse:getH() + y1
	
		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
			if z == 0 then
				player:getModData().SafeHouseX = x --write moddata to player to save safehouse X coordinate
				player:getModData().SafeHouseY = y --write moddata to player to save safehouse Y coordinate
				--player:getModData().SafeHouseZ = z --write moddata to player to save safehouse Z coordinate
				player:Say("Safehouse teleport coordinates set to: x=" .. tostring(math.floor(x)) ..", y=" .. tostring(math.floor(y)))
			else
				player:Say("I need to be on the ground floor to do this.")
			end
		else
			player:Say("I need to be inside my Safehouse boundaries to do this.")
		end
	else
		player:Say("It would be nice if I had a Safehouse though.") 
	end
end

--context menu option add for teleporter. 
local function FCteleportercontext(player, context, items) -- # When an inventory item context menu is opened
	local playerObj = getSpecificPlayer(player);
	items = ISInventoryPane.getActualItems(items); -- Get table of inventory items (will not be module.item, just item)
	for _, item in ipairs(items) do -- Check every item in inventory array
		if item:getFullType() == 'FC.Teleporter' and item:isInPlayerInventory() then--and (item:getContainer() == playerObj:getInventory()) then
			context:addOption("Set Return Coordinates for Safehouse Teleport", item, FCteleporterContextMenuObjectName.doFCsafehousecoord, player) -- add context menu option to write safehouse coordinates to player getmoddata
			context:addOption("Teleport back to Safehouse", item, FCteleporterContextMenuObjectName.doFCteleport, player) -- add context menu option to Teleport
			break -- break the loop when found
		end
	end
end
Events.OnFillInventoryObjectContextMenu.Add(FCteleportercontext) -- everytime you rightclick an object in your inventory it will trigger this check to add a teleport option