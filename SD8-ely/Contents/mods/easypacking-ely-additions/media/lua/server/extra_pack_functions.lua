local defaultItemAmounts = {}

function Recipe.OnCreate.SaveUses(items, result, player)
    local remainingUses = {};
    for i = 0, items:size() - 1 do
        ---@type Item
        local item = items:get(i)
        if item and instanceof(item, "DrainableComboItem") then
            table.insert(remainingUses, item:getDelta())
        end
    end
    result:getModData().EasyPackingRemainingUses = remainingUses
end

---@param items Item
---@param result InventoryItem
---@param player IsoGameCharacter
function Recipe.OnCreate.LoadUses(items, result, player)
    if instanceof(result, "DrainableComboItem") then
        local savedUses = items:get(0):getModData().EasyPackingRemainingUses
        if savedUses then
            local inventory = player:getInventory()
            local itemToAdd = result:getFullType()
            for k,savedUse in pairs(savedUses) do
                ---@type DrainableComboItem
                local newItem = inventory:AddItem(itemToAdd)
                newItem:setDelta(savedUse)
            end
        else
            local inventory = player:getInventory()
            --result is an inventory item, full type is the ID
            local itemToAdd = result:getFullType()
            --items is a non inventory item, so full name is the ID
            local amount = defaultItemAmounts[items:get(0):getFullType()]
            for i=1,amount do
                inventory:AddItem(itemToAdd)
            end
            --check static table of items to give
        end
    end
end

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

function Recipe.OnCreate.MergeUses(items, result, player)
    local toMerge = {}
    for i=0,items:size()-1 do
        local savedUses = items:get(i):getModData().EasyPackingRemainingUses
        if savedUses then
            for _,v in pairs(savedUses) do
                table.insert(toMerge,v)
            end
        else
            for j=0,defaultItemAmounts[items:get(0):getFullType()] do
                table.insert(toMerge,1)
            end
            --check static table of items to give
        end
    end
    result:getModData().EasyPackingRemainingUses = toMerge
end

function Recipe.OnCreate.SplitUsesInTwo(items, result, player)
    local savedUses = items:get(0):getModData().EasyPackingRemainingUses
    if savedUses then
        local itemsAmount = #savedUses
        local unpackedModData = { {}, {}}
        for i = 1, itemsAmount/2 do
            table.insert(unpackedModData[1],savedUses[i])
        end
        for i = itemsAmount/2+1, itemsAmount do
            table.insert(unpackedModData[2],savedUses[i])
        end
        local inventory = player:getInventory()
        local itemToAdd = result:getFullType()
        for k,v in pairs(unpackedModData) do
            local newItem = inventory:AddItem(itemToAdd)
            newItem:getModData().EasyPackingRemainingUses = v
        end
    else
        --check static table of items to give
        local itemToAdd = result:getFullType()
        local itemsAmount = defaultItemAmounts[items:get(0):getFullType()]
        local unpackedModData = { {}, {}}
        for i = 1, itemsAmount/2 do
            table.insert(unpackedModData[1],1)
        end
        for i = itemsAmount/2+1, itemsAmount do
            table.insert(unpackedModData[2],1)
        end
        local inventory = player:getInventory()
        for k,v in pairs(unpackedModData) do
            local newItem = inventory:AddItem(itemToAdd)
            newItem:getModData().EasyPackingRemainingUses = v
        end
    end
end

local function saveItemAmounts()
    local scriptManager = ScriptManager.instance
    local recipes = scriptManager:getAllRecipes()
    for i=0, recipes:size() - 1 do
        ---@type Recipe
        local recipe = recipes:get(i)
        --Check if the recipe has to save the uses
        local recipeFunc = recipe:getLuaCreate()
        if recipeFunc == "Recipe.OnCreate.SaveUses" then
            --We assume the drainable is the first item in the recipe source
            local recipeSource = recipe:getSource():get(0)
            local itemName = recipeSource:getOnlyItem()
            --Check if the item is a drainable. For non-inventory items, the type is the actual class
            if scriptManager:FindItem(itemName):getTypeString() == "Drainable" then
                local amount = recipeSource:getCount()
                --for inventory items, the type is its internal name
                local recipeResult = recipe:getResult():getFullType()
                defaultItemAmounts[recipeResult] = amount
                print(recipeResult,amount)
                --we can now exit the inner loop early
            end
        end
    end
end

Events.OnInitGlobalModData.Add(saveItemAmounts)