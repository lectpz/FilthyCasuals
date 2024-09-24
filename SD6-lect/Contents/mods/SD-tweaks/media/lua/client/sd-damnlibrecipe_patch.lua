local recipesToPatch = {}

recipesToPatch["Dismantle Vehicle Hood"] = true --3 sheetmetal
recipesToPatch["Dismantle Vehicle Trunk Lid"] = true --2 sheetmetal
recipesToPatch["Dismantle Vehicle Door"] = true --2 sheetmetal
recipesToPatch["Dismantle Vehicle Muffler"] = true --1 sheetmetal

function patchEmptyPropaneTank(items, result, player)
	local newtank = InventoryItemFactory.CreateItem("Base.PropaneTank")
	newtank:setUsedDelta(0)
	local playerInv = player:getInventory()
	playerInv:AddItem(newtank)
end

local function patch_recipes()
	local patched = 0
	local start = Calendar.getInstance():getTimeInMillis()
	local recipes = getScriptManager():getAllRecipes()
	for i = 1, recipes:size() do
		local recipe = recipes:get(i - 1)
		local name = recipe:getOriginalname()
		if recipesToPatch[name] then
			local quant
			if name == "Dismantle Vehicle Hood" then
				recipe:DoResult("Base.SmallSheetMetal=3")
			elseif name == "Dismantle Vehicle Muffler" then
				recipe:DoResult("Base.MetalPipe")
			else
				recipe:DoResult("Base.SmallSheetMetal=2")
			end
			patched = patched + 1
			print ("Patched \""..name.."\"..")
		end
	end
	local stop = Calendar.getInstance():getTimeInMillis()

	print("Patched "..patched.." KI5 recipes in "..(stop - start).."ms!")
end

Events.OnGameStart.Add(patch_recipes)