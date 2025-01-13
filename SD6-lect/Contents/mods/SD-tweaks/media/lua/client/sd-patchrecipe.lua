local recipesToPatch = {}

recipesToPatch["Create Propane tank"] = true
recipesToPatch["Sell Valuables"] = true
recipesToPatch["Make Box of Nails"] = true

function patchEmptyPropaneTank(items, result, player)
    local newtank = InventoryItemFactory.CreateItem("Base.PropaneTank")
    newtank:setUsedDelta(0)
    local playerInv = player:getInventory()
    playerInv:AddItem(newtank)
end

function OnTest_sellValuables(item)
	local iMD = item:getModData()
	if iMD.SoulBuff == true then 
		return false
	else
		return true
	end
end

function SD6_sellValuables(items, result, player)
    local playerInv = player:getInventory()
    playerInv:AddItems("Base.ScrapMetalBits", 3)
	--playerInv:AddItem("Base.ScrapMetalBits")
end

function SD6_makeNails(items, result, player)
    local playerInv = player:getInventory()
	playerInv:AddItem("Base.NailsBox")
end

local function patch_recipes()
    local patched = 0
    local start = Calendar.getInstance():getTimeInMillis()
    local recipes = getScriptManager():getAllRecipes()
    for i = 1, recipes:size() do
        local recipe = recipes:get(i - 1)
        local name = recipe:getOriginalname()
        if recipesToPatch[name] then
            if name == "Create Propane tank" then
                recipe:setRemoveResultItem(true)
                recipe:setLuaCreate("patchEmptyPropaneTank")
                patched = patched + 1
                print ("Patched \""..name.."\"..")
            elseif name == "Sell Valuables" then
                recipe:setRemoveResultItem(true)
				recipe:setCanBeDoneFromFloor(true)
				recipe:setLuaTest("OnTest_sellValuables")
				recipe:setLuaCreate("SD6_sellValuables")
                patched = patched + 1
                print ("Patched \""..name.."\"..")
			elseif name == "Make Box of Nails" then
                --recipe:setRemoveResultItem(true)
				recipe:setLuaCreate("SD6_makeNails")
                patched = patched + 1
                print ("Patched \""..name.."\"..")
            end
        end
    end
    local stop = Calendar.getInstance():getTimeInMillis()

    print("Patched "..patched.." recipes in "..(stop - start).."ms!")
end

Events.OnGameStart.Add(patch_recipes)