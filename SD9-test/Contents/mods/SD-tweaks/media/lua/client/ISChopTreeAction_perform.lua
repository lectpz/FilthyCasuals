local o_perform = ISChopTreeAction.perform
function ISChopTreeAction:perform()
    o_perform(self)
	Events.OnPlayerUpdate.Add(gatherLogsSD)
end

local timer = 0
function gatherLogsSD(player)
	if timer > 48 then
		timer = timer + 1
		return
	end
	
	Events.OnPlayerUpdate.Remove(gatherLogsSD)
	timer = 0
	local logCount = 0
	local sq = player:getSquare()
	local sqx, sqy, sqz = sq:getX()-2, sq:getY()+2, 0
	
	for i=sqx, sqx+4 do
		for j=sqy-4, sqy do
			local aroundSquare = getSquare(i, j, 0)
			local sqObjects = aroundSquare:getWorldObjects()
			local sqObjectsSize = sqObjects:size()
			if sqObjectsSize>0 then
				for k=sqObjectsSize-1, 0, -1 do
					local wo = sqObjects:get(k)
					if wo then
						local item = wo:getItem()
						if item:getFullType() == "Base.Log" then
							local worldItem = item:getWorldItem()
							logCount = logCount + 1
							worldItem:getSquare():transmitRemoveItemFromSquare(worldItem);
							worldItem:removeFromWorld()
							worldItem:removeFromSquare()
							worldItem:setSquare(nil)
							getPlayerLoot(0):refreshBackpacks()
							if logCount == 4 then break end
						end
					end
				end
				if logCount > 1 then
					player:getSquare():AddWorldInventoryItem("LogStacksSD"..logCount, ZombRandFloat(0,0.9), ZombRandFloat(0,0.9), 0, 1)
					getPlayerLoot(0):refreshBackpacks()
					logCount = 0
				end
			end
		end
	end
end

local o_start = ISChopTreeAction.start
function ISChopTreeAction:start()
	local handItem = self.character:getPrimaryHandItem()
	local wMD = handItem:getModData()
	local isOwnSafeHouse = SafeHouse.hasSafehouse(self.character)
	local tierzone, zone, x, y = checkZone()

    if isOwnSafeHouse then
        local shx1 = isOwnSafeHouse:getX()-15
        local shy1 = isOwnSafeHouse:getY()-15
        local shx2 = isOwnSafeHouse:getW() + shx1 + 30
        local shy2 = isOwnSafeHouse:getH() + shy1 + 30

        if x >= shx1 and y >= shy1 and x <= shx2 and y <= shy2 then
            isInSafeHouse = true
        else
            isInSafeHouse = false
        end
    end
	if isInSafehouse then 
		handItem:setTreeDamage(wMD.TreeDamage)
	else
		if tierzone > 4 then handItem:setTreeDamage(wMD.TreeDamage / tierzone) else handItem:setTreeDamage(wMD.TreeDamage) end
	end
	o_start(self)
end