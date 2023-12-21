----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

local function FCteleport(player, args) -- teleporter function that executes when context menu passes checks
	if item ~= nil then
		getSoundManager():PlayWorldSound("s_teleport", false, player:getCurrentSquare(), 30, 3, 10, false) ; -- define teleport sound
		local soundRadius = 3
		local volume = 6
		addSound(player, player:getX(), player:getY(), player:getZ(), soundRadius, volume) -- play sound
		item:getContainer():DoRemoveItem(item) -- remove item from whichever container it was called from
		player:setX(sh_x) -- teleport to safehouse coordinates that are defined the moment you press teleport from context menu. uses x, y, z definitions.
		player:setY(sh_y)
		player:setY(sh_z)
		player:setLx(sh_x)
		player:setLy(sh_y)
		player:setLy(sh_z)
	else
		player:Say("The teleporter disappeared.")
	end
end

--context menu option add for teleporter
local function FCteleportercontext(player, context, items) -- # When an inventory item context menu is opened
	items = ISInventoryPane.getActualItems(items); -- Get table of inventory items (will not be module.item, just item)
	for _, item in ipairs(items) do -- Check every item in inventory array
		if item:getFullType() == 'FC.Teleporter' then -- getFullType will display Module.Item, check for FC.Teleporter. this also checks if item is in character inventory
			context:addOption("Set Return Coordinates for Safehouse Teleport", item, FCteleporterContextMenuObjectName.doFCsafehousecoord, player) -- add context menu option to write safehouse coordinates to player getmoddata
			context:addOption("Teleport back to Safehouse", item, FCteleporterContextMenuObjectName.doFCteleport, player) -- add context menu option to Teleport
			break -- break the loop when found
		end
	end
end

local FCteleporterContextMenuObjectName = {};

--context menu option for teleport
FCteleporterContextMenuObjectName.doFCteleport = function(item, player)
	local safehouse = SafeHouse.hasSafehouse(player);--define safehouse
	
	if player:getStats():getNumVisibleZombies() > 0 or player:getStats():getNumChasingZombies() > 0 or player:getStats():getNumVeryCloseZombies() > 0 then -- check if zombies are close by
		player:Say("It doesn't feel safe to do that.")
	elseif not safehouse then -- check if there is a valid safehouse
		player:Say("It would be nice if I had a Safehouse though.") 
	else -- if safehouse exists then get safehouse coordinates and locally define the item as an arg value, and execute timed action FCteleport() for player, using args
	
		local x1 = safehouse:getX()
		local y1 = safehouse:getY()
		local x2 = safehouse:getW() + x1
		local y2 = safehouse:getH() + y1
		local z1 = 0
		
		local sh_x = player:getModData().SafeHouseX
		local sh_y = player:getModData().SafeHouseY
		local sh_z = player:getModData().SafeHouseZ
		
		if sh_x ~= nil and sh_y ~= nil and sh_z ~= nil then
		--check if saved safehouse coordinates are within existing safehouse coordinates
			if sh_x >= x1 and sh_y >= y1 and sh_x <= x2 and sh_y <= y2--if saved moddata SH is within current SH boundaries then define x, y, z coordinate for teleport
			local args = {
				local sh_x = player:getModData().SafeHouseX
				local sh_y = player:getModData().SafeHouseY
				local sh_z = player:getModData().SafeHouseZ
				local item = item
				}
			else--if saved moddata SH is not within current SH boundaries then write overwrite existing moddata and definte x, y, z coordinate for teleport
				player:getModData().SafeHouseX = safehouse:getX() --write moddata to player to save safehouse X coordinate
				player:getModData().SafeHouseY = safehouse:getY() --write moddata to player to save safehouse Y coordinate
				player:getModData().SafeHouseZ = 0 --write moddata to player to save safehouse Z coordinate
				local args = {
					local sh_x = player:getModData().SafeHouseX
					local sh_y = player:getModData().SafeHouseY
					local sh_z = player:getModData().SafeHouseZ
					local item = item
					}
				player:Say("Old coordinates no longer within Safehouse. Reset coordinates set to: x=" .. tostring(safehouse:getX()) ..", y=" .. tostring(safehouse:getY()) ..", z=" .. tostring(0))
			end
		else--if no moddata just teleport to the corner of SH bounds
			local args = {
				local sh_x = safehouse:getX()
				local sh_y = safehouse:getY()
				local sh_z = 0
				local item = item
				player:Say("Teleporting to coordinates : x=" .. tostring(sh_x) ..", y=" .. tostring(sh_y) ..", z=" .. tostring(sh_z) .. ". I should set my coordinates next time.")
				}
		end
		ISTimedActionQueue.add(doFCteleport:new(player, FCteleport(), args));--timed action for function
	end
end

--context menu option to add safehouse coordinate
FCteleporterContextMenuObjectName.doFCsafehousecoord = function(item, player)
	local safehouse = SafeHouse.hasSafehouse(player);--define safehouse
	
	if safehouse then -- check if there is a valid safehouse
		
		local x = player:getX()
		local y = player:getY()
		local z = player:getZ()
		
		local x1 = safehouse:getX()
		local y1 = safehouse:getY()
		local x2 = safehouse:getW() + x1
		local y2 = safehouse:getH() + y1
	
		if x >= x1 and y >= y1 and x <= x2 and y <= y2
			player:getModData().SafeHouseX = x --write moddata to player to save safehouse X coordinate
			player:getModData().SafeHouseY = y --write moddata to player to save safehouse Y coordinate
			player:getModData().SafeHouseZ = z --write moddata to player to save safehouse Z coordinate
			player:Say("Safehouse teleport coordinates set to: x=" .. tostring(x) ..", y=" .. tostring(y) ..", z=" .. tostring(z))
			if z > 3 then player:Say("Might be a good idea to set it " .. tostring(z-3) .. " floors lower...") end
		else
			player:Say("I need to be inside my Safehouse boundaries to do this.")
		end
	else
		player:Say("It would be nice if I had a Safehouse though.") 
	end
end

Events.OnFillInventoryObjectContextMenu.Add(FCteleportercontext) -- everytime you rightclick an object in your inventory it will trigger this check to add a teleport option