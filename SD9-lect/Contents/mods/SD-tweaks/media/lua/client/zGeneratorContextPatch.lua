local function nShop_genpatch(player, context, items)
	local playerObj = getSpecificPlayer(player)
	items = ISInventoryPane.getActualItems(items)
	for _, item in ipairs(items) do
		if item:getFullType() == 'Base.Generator' then
			--function printTable(tbl)
			--	for k, v in pairs(tbl) do
			--		print(k, v)
			--	end
			--end

			--printTable(context:getMenuOptionNames())
			--local container = item:getContainer()
			--local parent = container:getParent()
			--if parent and parent:getModData().owner then
			--	if playerObj:getUsername() == parent:getModData().owner then
			--		return
			--	elseif isAdmin() then
			--		return
			--	else
					context:removeOptionByName(getText("ContextMenu_GeneratorTake"))
			--	end
			--end
		end
	end
end
Events.OnFillInventoryObjectContextMenu.Add(nShop_genpatch)