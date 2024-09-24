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

local function unyeet_recipes()
	local unyeeted = 0
	local start = Calendar.getInstance():getTimeInMillis()
	local recipes = getScriptManager():getAllRecipes()
	for i = 1, recipes:size() do
		local recipe = recipes:get(i - 1)
		local name = recipe:getOriginalname()
		if recipesToUnyeet[name] then
			recipe:setIsHidden(false)
			recipe:setCanPerform("yeppers")
			unyeeted = unyeeted + 1
			print ("Unyeeted \""..name.."\"..")
		end
	end
	local stop = Calendar.getInstance():getTimeInMillis()

	print("Unyeeted "..unyeeted.." recipes in "..(stop - start).."ms!")
end

Events.OnGameStart.Add(unyeet_recipes)