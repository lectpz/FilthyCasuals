local util = {}

util.patchClassMetaMethod = function(class, methodName, createPatch)
    local metatable = __classmetatables[class]
    if not metatable then
        error("Unable to find metatable for class "..tostring(class))
    end
    local metatable__index = metatable.__index
    if not metatable__index then
        error("Unable to find __index in metatable for class "..tostring(class))
    end
    local originalMethod = metatable__index[methodName]
    metatable__index[methodName] = createPatch(originalMethod)
end

util.getGasCan = function(character)
    local equipped
    
    if character:getPrimaryHandItem() then
        equipped = character:getPrimaryHandItem()
        if equipped:hasTag("EmptyPetrol") then
            return equipped
        end
    elseif character:getSecondaryHandItem() then
        equipped = character:getSecondaryHandItem()
        if equipped:hasTag("Petrol") and equipped:getUsedDelta() < 1 then
            return equipped
        end
    end

    local items = character:getInventory():getItems()

    for v=0, items:size()-1 do
        local item = items:get(v)
        if item then
            if item:hasTag("Petrol") then
                if item:getUsedDelta() < 1 and item:getUsedDelta() > -1 then
                    if item then return item end
                end
            elseif item:hasTag("EmptyPetrol") then
                if item then return item end
            end
        end
    end
        
    return nil
end

util.findOnSquare = function(square,sprite)
    local special = square:getSpecialObjects()
    for i = 1, special:size() do
        if special:get(i-1):getTextureName() == sprite then
            return special:get(i-1)
        end
    end
end

DistilleryUtilities = util