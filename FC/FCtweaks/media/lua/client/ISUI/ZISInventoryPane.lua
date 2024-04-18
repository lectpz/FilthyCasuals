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

function ISInventoryPane:doButtons(y)

    self.contextButton1:setVisible(false);
    self.contextButton2:setVisible(false);
    self.contextButton3:setVisible(false);

	if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 or
			getPlayerContextMenu(self.player):isAnyVisible() or
			getSpecificPlayer(self.player):isAsleep() then
		return
	end

	if ISMouseDrag.dragging and #ISMouseDrag.dragging > 0 then
		return
	end

    local count = 1;
    local item = self.items[y]
    if not instanceof(item, "InventoryItem") then
        count = item.count-1;
        item = item.items[1]
    end
    local isNoDropMoveable = instanceof(item, "Moveable") and not item:CanBeDroppedOnFloor()
	
--	if item:getFullType() == 'Base.WeaponCache' or item:getFullType() == 'Base.FarmerCache' or item:getFullType() == 'Base.MechanicCache' or item:getFullType() == 'Base.MetalworkCache' or item:getFullType() == 'Base.AmmoCache' then
--		print(item:getFullType() .. " buttoncheck true")
--		isCache = true
--	else
--		--print(item:getFullType() .. " buttoncheck false")
--		isCache = false
--	end

    local mode1,mode2,mode3 = nil,nil,nil
    local label1,label2,label3 = nil,nil,nil

    if self.inventory:isInCharacterInventory(getSpecificPlayer(self.player)) and self.inventory ~= getSpecificPlayer(self.player):getInventory() then
       -- unpack, drop
        mode1,label1 = "unpack", getText("IGUI_invpanel_unpack")
        if isNoDropMoveable then
            -- No 'Drop' option
        elseif count == 1 then
            mode2,label2 = "drop", getText("ContextMenu_Drop")
        else
            mode2,label2 = "drop", getText("IGUI_invpanel_drop_all")
            mode3,label3 = "drop1", getText("IGUI_invpanel_drop_one")
        end
        if not instanceof(self.items[y], "InventoryItem") then
            local fav = true;
            local firstFav = true;
            for i,v in ipairs(self.items[y].items) do
                if i == 1 then firstFav = v:isFavorite() end;
                if not v:isFavorite() then
                    fav = false;
                end
            end
            if fav then
                mode2 = nil
                mode3 = nil
            elseif count > 1 and firstFav then
                mode3 = nil
            end
        else
            if self.items[y]:isFavorite() then
                mode2 = nil
                mode3 = nil
            end
        end
    elseif self.inventory == getSpecificPlayer(self.player):getInventory() then
        if isNoDropMoveable then
            -- No 'Drop' option
        elseif count == 1 then
            mode1,label1 = "drop", getText("ContextMenu_Drop")
        else
            mode1,label1 = "drop", getText("IGUI_invpanel_drop_all")
            mode2,label2 = "drop1", getText("IGUI_invpanel_drop_one")
        end
        if not instanceof(self.items[y], "InventoryItem") then
            local fav = true;
            local firstFav = true;
            for i,v in ipairs(self.items[y].items) do
                if i == 1 then firstFav = v:isFavorite() end;
                if not v:isFavorite() then
                    fav = false;
                end
            end
            if fav then
                mode1 = nil
                mode2 = nil
            elseif count > 1 and firstFav then
                mode2 = nil
            end
        else
            if self.items[y]:isFavorite() then
                mode1 = nil
                mode2 = nil
            end
        end

        if instanceof(item, "Moveable") then
            if mode1 and mode2 then
                mode3,label3 = "place", getText("IGUI_Place")
            elseif mode1 then
                mode2,label2 = "place", getText("IGUI_Place")
            else
                mode1,label1 = "place", getText("IGUI_Place")
            end
        end
    else
		if item:getFullType() == 'Base.WeaponCache' or item:getFullType() == 'Base.FarmerCache' or item:getFullType() == 'Base.MechanicCache' or item:getFullType() == 'Base.MetalworkCache' or item:getFullType() == 'Base.AmmoCache' then
			return
		else
			if count == 1 then
				mode1,label1 = "grab",getText("ContextMenu_Grab")
			else
				mode1,label1 = "grab",getText("ContextMenu_Grab_all")
				mode2,label2 = "grab1",getText("ContextMenu_Grab_one")
			end
		end
    end

    local ypos = ((y-1)*self.itemHgt) + self.headerHgt;
    ypos = ypos + self:getYScroll();

	if getCore():getGameMode() ~= "Tutorial" then
		if mode1 then
			self.contextButton1:setTitle(label1)
			self.contextButton1.mode = mode1
			self.contextButton1:setWidthToTitle()
			self.contextButton1:setX(self.column3)
			self.contextButton1:setY(ypos)
			self.contextButton1:setVisible(true)
		end
		if mode2 then
			self.contextButton2:setTitle(label2)
			self.contextButton2.mode = mode2
			self.contextButton2:setWidthToTitle()
			self.contextButton2:setX(self.contextButton1:getRight() + 1)
			self.contextButton2:setY(ypos)
			self.contextButton2:setVisible(true)
		end
		if mode3 then
			self.contextButton3:setTitle(label3)
			self.contextButton3.mode = mode3
			self.contextButton3:setWidthToTitle()
			self.contextButton3:setX(self.contextButton2:getRight() + 1)
			self.contextButton3:setY(ypos)
			self.contextButton3:setVisible(true)
		end
	end

    self.buttonOption = y;
end