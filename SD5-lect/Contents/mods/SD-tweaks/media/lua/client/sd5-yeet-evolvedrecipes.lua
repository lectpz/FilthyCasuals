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

local recipesToyeet = {}

recipesToyeet["Blend Puree"] = true

function yeetthepuree()
	return false
end

local function yeet_recipes()
	local yeeted = 0
	local start = Calendar.getInstance():getTimeInMillis()
	local recipes = getScriptManager():getAllRecipes()
	for i = 1, recipes:size() do
		local recipe = recipes:get(i - 1)
		local name = recipe:getOriginalname()
		if recipesToyeet[name] then
			recipe:setIsHidden(true)
			recipe:setCanPerform("yeetthepuree")
			yeeted = yeeted + 1
			print ("yeeted \""..name.."\"..")
		end
	end
	local stop = Calendar.getInstance():getTimeInMillis()

	print("Yeeted "..yeeted.." recipes in "..(stop - start).."ms!")
end

Events.OnGameStart.Add(yeet_recipes)