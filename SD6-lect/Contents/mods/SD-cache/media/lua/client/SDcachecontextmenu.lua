----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

local function SDcontext(player, context, items) -- # When an inventory item context menu is opened
	local playerObj = getSpecificPlayer(player);
	items = ISInventoryPane.getActualItems(items); -- Get table of inventory items (will not be module.item, just item)
	for _, item in ipairs(items) do -- Check every item in inventory array
		local iFT = item:getFullType()
		if iFT == 'Base.WeaponCache' or iFT == 'Base.MedicalCache' or iFT == 'Base.MechanicCache' or iFT == 'Base.MetalworkCache' or iFT == 'Base.AmmoCache' or iFT == 'Base.ArmorCachePatriot' or iFT == 'Base.ArmorCacheDefender' or iFT == 'Base.ArmorCacheVanguard' or iFT == 'Base.SpiffoCache' or iFT == 'Base.JewelryCache' or iFT == 'Base.SoulForgeCache' then
			--print(item:getFullType())
			context:removeOptionByName(getText("ContextMenu_Grab"))
			context:removeOptionByName(getText("ContextMenu_Grab_one"))
			context:removeOptionByName(getText("ContextMenu_Grab_half"))
			context:removeOptionByName(getText("ContextMenu_Grab_all"))
			context:removeOptionByName(getText("ContextMenu_PutInContainer"))
			context:removeOptionByName(getText("ContextMenu_Equip_Primary"))--'Equip Primary')
			context:removeOptionByName(getText("ContextMenu_Equip_Secondary"))
			context:removeOptionByName(getText("ContextMenu_Drop"))
			context:removeOptionByName(getText("ContextMenu_PlaceItemOnGround"))
			--ISInventoryPane:hideButtons()

			--print(context:getMenuOptionNames())
			
			--function printTable(tbl)
			--	for k, v in pairs(tbl) do
			--		print(k, v)
			--	end
			--end

			--printTable(context:getMenuOptionNames())
		end

	end
end
Events.OnFillInventoryObjectContextMenu.Add(SDcontext) -- everytime you rightclick an object in your inventory it will trigger this check to add a teleport option