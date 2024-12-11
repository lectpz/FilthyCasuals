local o_onBackpackRightMouseDown = ISInventoryPage.onBackpackRightMouseDown
local proxinv = getActivatedMods():contains("ProximityInventory") or nil

function ISInventoryPage:onBackpackRightMouseDown(x, y)
	o_onBackpackRightMouseDown(self, x, y)
	local page = self.parent
	local container = self.inventory
	--local item = container:getContainingItem()
	local context = ISContextMenu.get(page.player, getMouseX(), getMouseY())
	--[[if item then
		context = ISInventoryPaneContextMenu.createMenu(page.player, page.onCharacter, {item}, getMouseX(), getMouseY())
		if context and context.numOptions > 1 and JoypadState.players[page.player+1] then
			context.origin = page
			context.mouseOver = 1
			setJoypadFocus(page.player, context)
		end
		return
	end]]

	local playerObj = getSpecificPlayer(page.player)
	
	local function addDeleteContext()
		if not instanceof(container:getParent(), "BaseVehicle") 
		and not (container:getType() == "inventorymale" or container:getType() == "inventoryfemale" or container:getType() == "local" or container:getType() == "floor") then
		--and not container:getParent():getModData().owner then
			local containerModData = container:getParent():getModData().owner or nil
			if not containerModData then 
				context:addOption("Delete all items", container, 
				function(container, playerObj)
					local sq = container:getSourceGrid()
					if container:getSourceGrid() then
						local object = container:getParent()
						local playerObj = getSpecificPlayer(0)
						local args = { x = object:getX(), y = object:getY(), z = object:getZ(), index = object:getObjectIndex() }
						sendClientCommand(playerObj, 'object', 'emptyTrash', args)
					end
				end, 
				playerObj)
			end
		end
	end

	addDeleteContext()

	if isAdmin() or ISLootZed.cheat then
		o_onBackpackRightMouseDown(self, x, y)
		addDeleteContext()
	end
			
	if proxinv then 
		if container:getType() == "local" then
			local context = ISContextMenu.get(page.player, getMouseX(), getMouseY())
			ProxInv.populateContextMenuOptions(context, self)
		end
	end	
	
end