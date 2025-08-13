local function qualityWeapon(player, context, items)
    local playerObj = getSpecificPlayer(0)
    local playerInv = playerObj:getInventory()
	local _items = ISInventoryPane.getActualItems(items)
	
	for i=1, #_items do
		local item = _items[i]
		if not item:isInPlayerInventory() or item:isEquipped() or item:isFavorite() or item:getContainer():getType() ~= "none" then return end -- item must be in inventory
		if not item:IsWeapon() then return end
		
		if item:getModule() == "RMWeapons" then
			local iMD = item:getModData()
			local mdzPrefix = iMD.mdzPrefix
			if not mdzPrefix then
				if item:getHaveBeenRepaired() == 1 then
					context:addOption("Add Weapon Quality to " .. item:getDisplayName(), item, MDZ_OnCreate_MeleeWeaponVariance, true)
				end
			end
		end
	end
end
Events.OnPreFillInventoryObjectContextMenu.Add(qualityWeapon)