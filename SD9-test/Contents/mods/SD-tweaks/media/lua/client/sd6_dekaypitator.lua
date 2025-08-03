local function convertDeKaypitator(item, playerObj)
	local playerInv = playerObj:getInventory()
	local itemContainer = item:getContainer()
	
	if itemContainer ~= playerInv then
		playerObj:Say("This needs to be in my primary inventory.")
	else
		itemContainer:Remove(item)
		playerInv:AddItem("RMWeapons.DeKaypitatorCustom")
		playerObj:Say("I better not shave with this.")
	end
end

local function Kays_custom_weapon(player, context, items)
	if getOnlineUsername() == "Beast" then
		local playerObj = getSpecificPlayer(player)
		items = ISInventoryPane.getActualItems(items)
	
		for i=1, #items do
			item = items[i]
			if item:getType() == "DeKaypitator" then
				context:addOption("Convert into Custom DeKaypitator", item, convertDeKaypitator, playerObj)
				break
			end
		end
	end
end

Events.OnPreFillInventoryObjectContextMenu.Add(Kays_custom_weapon)