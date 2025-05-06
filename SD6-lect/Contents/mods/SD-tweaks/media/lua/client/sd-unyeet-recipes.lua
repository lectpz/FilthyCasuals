--[[
	Version 1.2

	1.0: YeetRecipes.lua Written By UdderlyEvelyn 9/9/22
	1.1: Updated To Remove Recipes From Books/Magazines 9/24/22
	1.2: Removed removal from books/magazines, affecting CanPerform instead now. ??/??/22
	1.3: Removed the Name<->Display name stuff, was leftovers. Completed switching over to original name (oops). 3/12/23

	Feel free to use this, retain credit to me please. :)

	If you only need to replace *one* recipe with a given
	name, it is more efficient to use overrides/etc.! If
	you're already using this, though, might as well
	use it for all recipes to be removed.
]]
local modName = "UdderlyAmmoCrafting"

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

function yeppers()
	return true
end

function OnTest_FirearmCleaning_SD(item)
	if item:IsWeapon() and item:isRanged() then
		if item:getHaveBeenRepaired() == 1 then return false end
	end
	return true
end

local function unyeet_recipes()
	local unyeeted = 0
	local start = Calendar.getInstance():getTimeInMillis()
	local recipes = getScriptManager():getAllRecipes()
	for i = 0, recipes:size()-1 do
		local recipe = recipes:get(i)
		local name = recipe:getOriginalname()
		if recipesToUnyeet[name] then
			if name == "Make Wonton Wrappers Dough" then
				recipe:findSource("Base.Flour"):setCount(3)
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
			end
			recipe:setIsHidden(false)
			recipe:setCanPerform("yeppers")
			unyeeted = unyeeted + 1
			print ("Unyeeted \""..name.."\"..")
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

	print("Unyeeted "..unyeeted.." recipes in "..(stop - start).."ms!")
end

--Events.OnInitGlobalModData.Add(unyeet_recipes)