local recipesToPatch = {}

recipesToPatch["Open Welcome Package"] = true

function SD6_WelcomePackage(items, result, player)
    player:getInventory():AddItem("RMWeapons.club2");
    player:getInventory():AddItem("Base.Bag_Schoolbag");
    player:getInventory():AddItems("Base.BusTicket", 10);
    player:getInventory():AddItems("Base.ScrapMetal", 5);
    player:getInventory():AddItem("Base.WaterBottleFull");
    player:getInventory():AddItem("Base.Cereal");
    player:getInventory():AddItem("Base.Pen");
    player:getInventory():AddItem("Base.Wrench");
    player:getInventory():AddItem("Base.Padlock");
    player:getInventory():AddItems("Base.EngineParts", 5);
    player:getInventory():AddItem("SD.TeleporterConsumable");
    player:getInventory():AddItem("SD.Lunchbox_SundayDriver");
end

local function patch_recipes()
	local patched = 0
	local start = Calendar.getInstance():getTimeInMillis()
	local recipes = getScriptManager():getAllRecipes()
	for i = 1, recipes:size() do
		local recipe = recipes:get(i - 1)
		local name = recipe:getOriginalname()
		if recipesToPatch[name] then
			recipe:setLuaCreate("SD6_WelcomePackage")
			patched = patched + 1
			print ("Patched \""..name.."\"..")
		end
	end
	local stop = Calendar.getInstance():getTimeInMillis()

	print("Patched "..patched.." recipes in "..(stop - start).."ms!")
end

Events.OnGameStart.Add(patch_recipes)