require "ISUI/ISInventoryPane"
require "ISUI/ISPanel"
require "ISUI/ISButton"
require "ISUI/ISMouseDrag"
require "TimedActions/ISTimedActionQueue"
require "TimedActions/ISEatFoodAction"

function ISInventoryPane:transferItemsByWeight(items, container)
	local playerObj = getSpecificPlayer(self.player)
	if true then
		self:sortItemsByTypeAndWeight(items)
	else
		self:sortItemsByType(items)
		self:sortItemsByWeight(items)
	end
	for _,item in ipairs(items) do
		if not container:isItemAllowed(item) then
			-- 
		elseif container:getType() == "floor" then
			ISInventoryPaneContextMenu.dropItem(item, self.player)
		else
			--ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, item, item:getContainer(), container))
			if item and item:getFullType() ~= "Base.WeaponCache" and  item:getFullType() ~= "Base.MechanicCache" and item:getFullType() ~= "Base.MetalworkCache" and item:getFullType() ~= "Base.FarmerCache" and item:getFullType() ~= "Base.AmmoCache" then --fc
			--if item and item:getFullType() ~= "Base.WeaponCache1" and  item:getFullType() ~= "Base.MechanicCache1" and item:getFullType() ~= "Base.MetalworkCache1" and item:getFullType() ~= "Base.FarmerCache1" then --fc
				ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, item, item:getContainer(), container))
			else
				playerObj:Say("I should just open this here.")
				return
			end
		end
	end
end

function ISInventoryPane:onMouseDoubleClick(x, y)
	if self.items and self.mouseOverOption and self.previousMouseUp == self.mouseOverOption then
		if getCore():getGameMode() == "Tutorial" then
			if TutorialData.chosenTutorial.doubleClickInventory(self, x, y, self.mouseOverOption) then
				return
			end
		end
		local playerObj = getSpecificPlayer(self.player)
		local playerInv = getPlayerInventory(self.player).inventory;
		local lootInv = getPlayerLoot(self.player).inventory;
		local item = self.items[self.mouseOverOption];
		local doWalk = true
		local shiftHeld = isShiftKeyDown()
		if item and not instanceof(item, "InventoryItem") then 
			-- expand or collapse...
			if x < self.column2 then
				self.collapsed[item.name] = not self.collapsed[item.name];
				self:refreshContainer();
				return;
			end
			if item.items then
				for k, v in ipairs(item.items) do
					if k ~= 1 and v:getContainer() ~= playerInv then
						if isForceDropHeavyItem(v) then
							ISInventoryPaneContextMenu.equipHeavyItem(playerObj, v)
							break
						end
						if doWalk then
							if not luautils.walkToContainer(v:getContainer(), self.player) then
								break
							end
							doWalk = false
						end
						if v and v:getFullType() ~= "Base.WeaponCache" and  v:getFullType() ~= "Base.MechanicCache" and v:getFullType() ~= "Base.MetalworkCache" and v:getFullType() ~= "Base.FarmerCache" and v:getFullType() ~= "Base.AmmoCache" then --fc
							ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, v, v:getContainer(), playerInv))
						else
							playerObj:Say("I should just open this here.")
							return
						end
						if instanceof(v, "Clothing") and shiftHeld then
							ISTimedActionQueue.add(ISWearClothing:new(playerObj, v, 50))
						end
					elseif k ~= 1 and v:getContainer() == playerInv then
						local tItem = v;
						self:doContextualDblClick(tItem);
						break
					end
				end
			end
		elseif item and item:getContainer() ~= playerInv then
			if isForceDropHeavyItem(item) then
				ISInventoryPaneContextMenu.equipHeavyItem(playerObj, item)
			elseif luautils.walkToContainer(item:getContainer(), self.player) then
				if item and item:getFullType() ~= "Base.WeaponCache" and  item:getFullType() ~= "Base.MechanicCache" and item:getFullType() ~= "Base.MetalworkCache" and item:getFullType() ~= "Base.FarmerCache" and item:getFullType() ~= "Base.AmmoCache" then --fc
					ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, item, item:getContainer(), playerInv))
				else
					playerObj:Say("I should just open this here.")
					return
				end
			end
		elseif item and item:getContainer() == playerInv then -- double click do some basic action, equip weapon/wear clothing...
			self:doContextualDblClick(item);
		end
		self.previousMouseUp = nil;
	end
end

function ISInventoryPane.getActualItems(items)
	local ret = {}
	local contains = {}
	for _,item in ipairs(items) do
		if instanceof(item, "InventoryItem") then
			if item and item:getFullType() ~= "Base.WeaponCache" and  item:getFullType() ~= "Base.MechanicCache" and item:getFullType() ~= "Base.MetalworkCache" and item:getFullType() ~= "Base.FarmerCache" and item:getFullType() ~= "Base.AmmoCache" then --fc
				if not contains[item] then
					-- The top-level group and its children might both be selected.
					table.insert(ret, item)
					contains[item] = true
				end
			--else
				--getPlayer():Say("I should just open this here.")
				--return "Base.Dice"
			end
		else
			-- The first item is a dummy duplicate, skip it.
			for i=2,#item.items do
				local item2 = item.items[i]
				if item2 and item2:getFullType() ~= "Base.WeaponCache" and  item2:getFullType() ~= "Base.MechanicCache" and item2:getFullType() ~= "Base.MetalworkCache" and item2:getFullType() ~= "Base.FarmerCache" and item2:getFullType() ~= "Base.AmmoCache" then --fc	
					if not contains[item2] then
						table.insert(ret, item2)
						contains[item2] = true
					end
				--else
					--getPlayer():Say("I should just open this here.")
					--table.insert(ret, item2)
					--contains[item2] = true
				end
			end
		end
	end
	return ret
end

function ISInventoryPane:sortItemsByTypeAndWeight(items)
	local indexMap = {}
	local containers = {}
	local allIndexMap = {}
	for index,item in ipairs(items) do
		local container = item:getContainer()
		if container and not containers[container] then
			containers[container] = true
			local containerItems = container:getItems()
			for i=1,containerItems:size() do
				indexMap[containerItems:get(i-1)] = i
			end
		end
		allIndexMap[item] = index
	end

	local itemsByName = {}
	for _,item in ipairs(items) do
		local key = item:getDisplayName()
		itemsByName[key] = itemsByName[key] or {}
		table.insert(itemsByName[key], item)
	end

	local sorted = {}
	for _,itemList in pairs(itemsByName) do
		timSort(itemList, function(a,b)
			if a:getContainer() and (a:getContainer() == b:getContainer()) then
				return indexMap[a] < indexMap[b]
			end
			return allIndexMap[a] < allIndexMap[b]
		end)
		table.insert(sorted, itemList)
	end
	timSort(sorted, function(a,b)
		local wa = a[1]:getUnequippedWeight()
		local wb = b[1]:getUnequippedWeight()
		if wa < wb then
			return true
		end
		if wa == wb then
			return allIndexMap[a[1]] < allIndexMap[b[1]]
		end
		return false
	end)
	if items and items:getFullType() ~= "Base.WeaponCache" and  items:getFullType() ~= "Base.MechanicCache" and items:getFullType() ~= "Base.MetalworkCache" and items:getFullType() ~= "Base.FarmerCache" and items:getFullType() ~= "Base.AmmoCache" then --fc
		table.wipe(items)
		local count = 1
		for _,itemList in ipairs(sorted) do
			for _,item in ipairs(itemList) do
				items[count] = item
				count = count + 1
			end
		end
	else
		return item
	end
end