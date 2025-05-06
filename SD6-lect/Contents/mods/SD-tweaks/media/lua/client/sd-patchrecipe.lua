local recipesToUnyeet = {}

recipesToUnyeet["Fry Nachos"] = true
recipesToUnyeet["Make Burrito"] = true
recipesToUnyeet["Create Burrito"] = true
recipesToUnyeet["Burrito"] = true
recipesToUnyeet["Make Bucket of Fried Bird"] = true
recipesToUnyeet["Make Pasta Dough"] = true
recipesToUnyeet["Make 2 Bowls of Stew"] = true
recipesToUnyeet["Make Wooden Skewers"] = true
recipesToUnyeet["Make Seitan"] = true
recipesToUnyeet["Make Pie Dough"] = true
recipesToUnyeet["Take Tortilla from Bag"] = true
recipesToUnyeet["Press Dough into Tortilla Shape"] = true
recipesToUnyeet["Make Wonton Wrappers Dough"] = true
recipesToUnyeet["Cast Small Metal Sheet"] = true
recipesToUnyeet["Cast Metal Bar"] = true
recipesToUnyeet["Cast Metal Pipe"] = true

function yeppers()
	return true
end

function OnTest_FirearmCleaning_SD(item)
	if item:IsWeapon() and item:isRanged() then
		if item:getHaveBeenRepaired() == 1 then return false end
	end
	return true
end

local recipesToPatch = {}

recipesToPatch["Create Propane tank"] = true
recipesToPatch["Sell Valuables"] = true
recipesToPatch["Make Box of Nails"] = true
recipesToPatch["Make Small Metal Sheet Mold"] = true
recipesToPatch["Make Metal Bar Mold"] = true
recipesToPatch["Make Metal Pipe Mold"] = true
recipesToPatch["Make 97 Bushmaster Seat"] = true
recipesToPatch["Make Bucket Of Concrete"] = true
recipesToPatch["Redeem CDC Red Package"] = true
recipesToPatch["Unpack Bundle of Crossbow Bolts"] = true

function patchConcreteBucket(items, result, player)
    local playerInv = player:getInventory()
    playerInv:AddItem("Base.BucketConcreteFull")
end

function patchEmptyPropaneTank(items, result, player)
    local newtank = InventoryItemFactory.CreateItem("Base.PropaneTank")
    newtank:setUsedDelta(0)
    local playerInv = player:getInventory()
    playerInv:AddItem(newtank)
end

function OnTest_sellValuables(item)
	local iMD = item:getModData()
	if iMD.SoulBuff then 
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

function SD6_addSmallMetalSheet(items, result, player)
    local playerInv = player:getInventory()
	playerInv:AddItem("Base.SmallSheetMetal")
end

function SD6_addMetalPipe(items, result, player)
    local playerInv = player:getInventory()
	playerInv:AddItem("Base.MetalPipe")
end

function SD6_addMetalBar(items, result, player)
    local playerInv = player:getInventory()
	playerInv:AddItem("Base.MetalBar")
end

function SD6_addSmallMetalSheets(items, result, player)
    local playerInv = player:getInventory()
	playerInv:AddItems("Base.SmallSheetMetal",4)
end

function SD6_addMetalPipes(items, result, player)
    local playerInv = player:getInventory()
	playerInv:AddItems("Base.MetalPipe",3)
end

function SD6_addMetalBars(items, result, player)
    local playerInv = player:getInventory()
	playerInv:AddItems("Base.MetalBar",3)
end

function getYeetedToHell()
	return false
end

function PokemonFullAlbumRedemption(items, result, player)
    local args = {}
    sendClientCommand(player, 'Adjustments', "RedeemFullAlbum", args);
    print(player:getUsername() .. " redeemed a full pkmn album");
	local playerInv = player:getInventory()
	playerInv:AddItem("Base.EventWeaponCacheT5")
	playerInv:AddItem("SoulForgeJewelery.EventJewelryCacheT5")
end

local function patch_recipes()
    local patched = 0
    local start = Calendar.getInstance():getTimeInMillis()
    local recipes = getScriptManager():getAllRecipes()
    for i = 0, recipes:size()-1 do
        local recipe = recipes:get(i)
        local name = recipe:getOriginalname()
        if recipesToPatch[name] then
            if name == "Create Propane tank" then
                recipe:setRemoveResultItem(true)
                recipe:setLuaCreate("patchEmptyPropaneTank")
                patched = patched + 1
                print ("Patched \""..name.."\"..")
			elseif name == "Redeem CDC Red Package" then
				recipe:setIsHidden(true)
				recipe:setCanPerform("getYeetedToHell")
                patched = patched + 1
                print ("Patched \""..name.."\"..")
			elseif name == "Make Bucket Of Concrete" then
                recipe:setRemoveResultItem(true)
                recipe:setLuaCreate("patchConcreteBucket")
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
			elseif name == "Make Small Metal Sheet Mold" then
				recipe:findSource("Base.SmallSheetMetal"):setKeep(true)
				--recipe:setLuaCreate("SD6_addSmallMetalSheet")
                patched = patched + 1
                print ("Patched \""..name.."\"..")
			elseif name == "Make Metal Bar Mold" then
				recipe:findSource("Base.MetalBar"):setKeep(true)
				--recipe:setLuaCreate("SD6_addMetalBar")
                patched = patched + 1
                print ("Patched \""..name.."\"..")
			elseif name == "Make Metal Pipe Mold" then
				recipe:findSource("Base.MetalPipe"):setKeep(true)
				--recipe:setLuaCreate("SD6_addMetalPipe")
                patched = patched + 1
                print ("Patched \""..name.."\"..")
			elseif name == "Make 97 Bushmaster Seat" then
				if recipe:getResult():getType() == "97BushmasterGunnerSeat" then 
					recipe:setIsHidden(true)
					recipe:setCanPerform("getYeetedToHell")
					patched = patched + 1
					print ("Patched \""..name.."\"..")
				end
			elseif name == "Unpack Bundle of Crossbow Bolts" then
				recipe:getResult():setCount(30)
				patched = patched + 1
				print ("Patched \""..name.."\"..")
            end
        end
		
		if recipesToUnyeet[name] then
			if name == "Make Wonton Wrappers Dough" then
				recipe:findSource("Base.Flour"):setCount(3)
				patched = patched + 1
				print ("Patched \""..name.."\"..")
			end
			if name == "Make Pasta Dough" then 
				--print("Recipe Name: " .. name)
				local eggs = 3
				recipe:findSource("Base.Flour"):setCount(5)
				recipe:findSource("Base.WildEggs"):setCount(eggs)
				recipe:findSource("Base.Egg"):setCount(eggs)
				recipe:findSource("SapphCooking.BowlwithBeatenEggs"):setCount(eggs)
				recipe:findSource("SapphCooking.BrownEgg"):setCount(eggs)
				--[[local sourceIngredients = recipe:getSource()
				for i=0, sourceIngredients:size()-1 do
					print(sourceIngredients:get(i):getItems())
				end]]
				patched = patched + 1
				print ("Patched \""..name.."\"..")
			end
			
			if name == "Cast Small Metal Sheet" then
				recipe:findSource("Base.ScrapMetal"):setCount(60)
				recipe:getResult():setCount(8)
				--recipe:setLuaCreate("SD6_addSmallMetalSheets")
				patched = patched + 1
				print ("Patched \""..name.."\"..")
			end
			
			if name == "Cast Metal Pipe" then
				recipe:findSource("Base.ScrapMetal"):setCount(40)
				recipe:getResult():setCount(6)
				--recipe:setLuaCreate("SD6_addMetalPipes")
				patched = patched + 1
				print ("Patched \""..name.."\"..")
			end
			
			if name == "Cast Metal Bar" then
				recipe:findSource("Base.ScrapMetal"):setCount(30)
				recipe:getResult():setCount(6)
				--recipe:setLuaCreate("SD6_addMetalBars")
				patched = patched + 1
				print ("Patched \""..name.."\"..")
			end
			
			recipe:setIsHidden(false)
			recipe:setCanPerform("yeppers")
			patched = patched + 1
			print ("Patched \""..name.."\"..")
		end
		
		if recipe:getLuaCreate() == "Recipe.OnCreate.FirearmCleaning" then
			--print(recipe:getLuaCreate())
			--recipe:setLuaCreate("Recipe.OnCreate.FirearmCleaning")
			--recipe:setLuaTest("OnTest_FirearmCleaning_SD")
			recipe:setRemoveResultItem(true)
			--print("==========GETSOURCE==============")
			local rSource = recipe:getSource()
			--for i=0, rSource:size()-1 do
				print(rSource:get(0):setKeep(true))
			--end
			--print("==========GETSOURCE==============")
		end
		
    end
    local stop = Calendar.getInstance():getTimeInMillis()

    print("Patched "..patched.." recipes in "..(stop - start).."ms!")
end

Events.OnInitGlobalModData.Add(patch_recipes)