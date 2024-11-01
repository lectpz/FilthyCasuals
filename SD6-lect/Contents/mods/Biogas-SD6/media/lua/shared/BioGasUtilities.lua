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

util.getPropaneTankNotFull = function(character)
	local equipped = character:getPrimaryHandItem()

    if equipped and equipped:getType() == "PropaneTank" and equipped:getUsedDelta() < 1 then
        return equipped
    elseif equipped and equipped:getType() == "IndustrialPropaneTank" and equipped:getUsedDelta() < 1 then
        return equipped
    end

    local items = character:getInventory():getAllCategory("Item")

    for v=0, items:size()-1 do
        local item = items:get(v)
        local type = item:getType()
        if type == "PropaneTank" or type == "IndustrialPropaneTank" then
            if item:getUsedDelta() < 1 and item:getUsedDelta() > -1 then
                if item then return item end
            end
        end
    end
        
    return nil
end

util.getBucketNotFull = function(character)
    local equipped = character:getPrimaryHandItem()

    if equipped and equipped:getType() == "BucketEmpty" then
        return equipped
    elseif equipped and equipped:getType() == "BucketFertilizerFull" and equipped:getUsedDelta() < 1 then
        return equipped
    end

    local items = character:getInventory():getAllCategory("Item")

    for v=0, items:size()-1 do
        local item = items:get(v)
        local type = item:getType()
        if type == "BucketFertilizerFull" then
            if item:getUsedDelta() < 1 and item:getUsedDelta() > -1 then
                if item then return item end
            end
        elseif type == "BucketEmpty" then
            if item then return item end
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

BioGasUtilities = util