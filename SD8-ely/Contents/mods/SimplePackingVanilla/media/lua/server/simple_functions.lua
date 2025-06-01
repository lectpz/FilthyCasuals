-- ==========================
-- == Default Item Tables ==
-- ==========================

local defaultItemAmounts = {}
local defaultFoodItems = {}

-- ==========================
-- == Utility Functions ==
-- ==========================

function AMSI(item, count, player)
    for x = 0, count do
        player:getInventory():AddItem(item)
    end
end

function Recipe.OnTest.IsFavorite(items, result)
    return not items:isFavorite()
end

-- ==========================
-- == Save/Load Functions ==
-- ==========================

function Recipe.OnCreate.SaveUses(items, result, player)
    local remainingUses = {}
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if item and instanceof(item, "DrainableComboItem") then
            table.insert(remainingUses, item:getDelta())
        end
    end
    result:getModData().EasyPackingRemainingUses = remainingUses
end

function Recipe.OnCreate.LoadUses(items, result, player)
    if instanceof(result, "DrainableComboItem") then
        local savedUses = items:get(0):getModData().EasyPackingRemainingUses
        if savedUses then
            local inventory = player:getInventory()
            local itemToAdd = result:getFullType()
            for _, savedUse in pairs(savedUses) do
                local newItem = inventory:AddItem(itemToAdd)
                newItem:setDelta(savedUse)
            end
        else
            local inventory = player:getInventory()
            local itemToAdd = result:getFullType()
            local amount = defaultItemAmounts[items:get(0):getFullType()]
            for i = 1, amount do
                inventory:AddItem(itemToAdd)
            end
        end
    end
end

function Recipe.OnCreate.SaveFood(items, result, player)
    local foodList = {}
    for i = 0, items:size() - 1 do
        local food = items:get(i)
        if food and instanceof(food, "Food") then
            table.insert(foodList, {
                type     = food:getFullType(),
                calories = food:getCalories(),
                hunger   = food:getHungChange(),
                thirst   = food:getThirstChange(),
                stress   = food:getStressChange(),
                boredom  = food:getBoredomChange(),
                poison   = food:getPoisonPower(),
                age      = food:getAge(),
                rotten   = food:isRotten(),
                cooked   = food:isCooked(),
                burnt    = food:isBurnt(),
                name     = food:getName(),
            })
        end
    end
    result:getModData().EasyPackingFoodPack = foodList
end

function Recipe.OnCreate.LoadFood(items, result, player)
    if instanceof(result, "Food") then
        local foodList = items:get(0):getModData().EasyPackingFoodPack
        if foodList then
            local inventory = player:getInventory()
            local itemToAdd = result:getFullType()
            for _, savedFood in pairs(foodList) do
                local newItem = inventory:AddItem(itemToAdd)
                newItem:setCalories(savedFood.calories)
                newItem:setHungChange(savedFood.hunger)
                newItem:setThirstChange(savedFood.thirst)
                newItem:setStressChange(savedFood.stress)
                newItem:setBoredomChange(savedFood.boredom)
                newItem:setPoisonPower(savedFood.poison)
                newItem:setAge(savedFood.age)
                newItem:setRotten(savedFood.rotten)
                newItem:setCooked(savedFood.cooked)
                newItem:setBurnt(savedFood.burnt)
                newItem:setName(savedFood.name)
            end
        else
            local inventory = player:getInventory()
            local itemToAdd = result:getFullType()
            local amount = defaultFoodItems[items:get(0):getFullType()]
            for i = 1, amount do
                inventory:AddItem(itemToAdd)
            end
        end
    end
end

-- ==========================
-- == Rope and Container Load ==
-- ==========================

function Recipe.OnCreate.LoadUsesOneRope(items, result, player)
    Recipe.OnCreate.LoadUses(items, result, player)
    Recipe.OnCreate.Unpack1Rope(items, result, player)
end

function Recipe.OnCreate.LoadUsesTwoRope(items, result, player)
    Recipe.OnCreate.LoadUses(items, result, player)
    Recipe.OnCreate.Unpack2Rope(items, result, player)
end

function Recipe.OnCreate.LoadUsesOneSheetRope(items, result, player)
    Recipe.OnCreate.LoadUses(items, result, player)
    Recipe.OnCreate.Unpack1SheetRope(items, result, player)
end

function Recipe.OnCreate.LoadUsesTwoSheetRope(items, result, player)
    Recipe.OnCreate.LoadUses(items, result, player)
    Recipe.OnCreate.Unpack2SheetRope(items, result, player)
end

function Recipe.OnCreate.LoadUsesOneWoodenContainer(items, result, player)
    Recipe.OnCreate.LoadUses(items, result, player)
    Recipe.OnCreate.Unpack1WoodenContainer(items, result, player)
end

function Recipe.OnCreate.LoadUsesTwoWoodenContainer(items, result, player)
    Recipe.OnCreate.LoadUses(items, result, player)
    Recipe.OnCreate.Unpack2WoodenContainer(items, result, player)
end

-- ==========================
-- == Splitting/Merging ==
-- ==========================

function Recipe.OnCreate.MergeUses(items, result, player)
    local toMerge = {}
    for i = 0, items:size() - 1 do
        local savedUses = items:get(i):getModData().EasyPackingRemainingUses
        if savedUses then
            for _, v in pairs(savedUses) do
                table.insert(toMerge, v)
            end
        else
            for j = 0, defaultItemAmounts[items:get(0):getFullType()] do
                table.insert(toMerge, 1)
            end
        end
    end
    result:getModData().EasyPackingRemainingUses = toMerge
end

function Recipe.OnCreate.SplitUsesInTwo(items, result, player)
    local savedUses = items:get(0):getModData().EasyPackingRemainingUses
    local inventory = player:getInventory()
    local itemToAdd = result:getFullType()
    local unpackedModData = { {}, {} }

    if savedUses then
        for i = 1, #savedUses/2 do table.insert(unpackedModData[1], savedUses[i]) end
        for i = #savedUses/2 + 1, #savedUses do table.insert(unpackedModData[2], savedUses[i]) end
    else
        local amount = defaultItemAmounts[items:get(0):getFullType()]
        for i = 1, amount/2 do table.insert(unpackedModData[1], 1) end
        for i = amount/2 + 1, amount do table.insert(unpackedModData[2], 1) end
    end

    for _, v in pairs(unpackedModData) do
        local newItem = inventory:AddItem(itemToAdd)
        newItem:getModData().EasyPackingRemainingUses = v
    end
end

-- ==========================
-- == Init Tracking Tables ==
-- ==========================

local function saveItemAmounts()
    local scriptManager = ScriptManager.instance
    local recipes = scriptManager:getAllRecipes()
    for i = 0, recipes:size() - 1 do
        local recipe = recipes:get(i)
        if recipe and recipe:getLuaCreate() == "Recipe.OnCreate.SaveUses" then
            local source = recipe:getSource()
            if source and source:size() > 0 then
                local recipeSource = source:get(0)
                local itemName = recipeSource:getOnlyItem()
                local item = scriptManager:FindItem(itemName)
                if item and item:getTypeString() == "Drainable" then
                    local amount = recipeSource:getCount()
                    defaultItemAmounts[recipe:getResult():getFullType()] = amount
                    print(recipe:getResult():getFullType(), amount)
                end
            end
        end
    end
end

local function saveNutritionAmounts()
    local scriptManager = ScriptManager.instance
    local recipes = scriptManager:getAllRecipes()
    for i = 0, recipes:size() - 1 do
        local recipe = recipes:get(i)
        if recipe and recipe:getLuaCreate() == "Recipe.OnCreate.SaveFood" then
            local source = recipe:getSource()
            if source and source:size() > 0 then
                local recipeSource = source:get(0)
                local itemName = recipeSource:getOnlyItem()
                local item = scriptManager:FindItem(itemName)
                if item and item:getTypeString() == "Food" then
                    local amount = recipeSource:getCount()
                    defaultFoodItems[recipe:getResult():getFullType()] = amount
                    print(recipe:getResult():getFullType(), amount)
                end
            end
        end
    end
end

Events.OnInitGlobalModData.Add(saveItemAmounts)
Events.OnInitGlobalModData.Add(saveNutritionAmounts)