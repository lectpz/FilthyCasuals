local recipesToPatch = {}

recipesToPatch["Create Propane tank"] = true

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
			recipe:setRemoveResultItem(true)
			recipe:setLuaCreate("patchEmptyPropaneTank")
			patched = patched + 1
			print ("Patched \""..name.."\"..")
		end
	end
	local stop = Calendar.getInstance():getTimeInMillis()

	print("Patched "..patched.." recipes in "..(stop - start).."ms!")
end

Events.OnGameStart.Add(patch_recipes)