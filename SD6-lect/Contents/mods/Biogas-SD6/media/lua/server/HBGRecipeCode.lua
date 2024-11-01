function Recipe.OnTest.RefillFromIndustrialPropaneTank(item)
    if item:getType() == "PropaneTank" then
        if item:getUsedDelta() == 1 then return false; end
    elseif item:getType() == "IndustrialPropaneTank" then
        if item:getUsedDelta() == 0 then return false; end
    end
    return true;
end

function Recipe.OnCreate.RefillFromIndustrialPropaneTank(items, result, player)
    local previousBT = nil;
    local propaneTank = nil;
    for i=0, items:size()-1 do
       if items:get(i):getType() == "PropaneTank" then
           previousBT = items:get(i);
       elseif items:get(i):getType() == "IndustrialPropaneTank" then
           propaneTank = items:get(i);
       end
    end
    result:setUsedDelta(previousBT:getUsedDelta() + result:getUseDelta() * 1);

    while result:getUsedDelta() < 1 and propaneTank:getUsedDelta() > 0 do
        result:setUsedDelta(result:getUsedDelta() + result:getUseDelta() * 1);
        propaneTank:Use();
    end

    if result:getUsedDelta() > 1 then
        result:setUsedDelta(1);
    end
end

function Recipe.OnTest.StorePropaneinIndustrial(item)
    if item:getType() == "IndustrialPropaneTank" then
        if item:getUsedDelta() == 1 then return false; end
    elseif item:getType() == "PropaneTank" then
        if item:getUsedDelta() == 0 then return false; end
    end
    return true;
end

function Recipe.OnCreate.StorePropaneinIndustrial(items, result, player)
    local previousBT = nil;
    local propaneTank = nil;
    for i=0, items:size()-1 do
        if items:get(i):getType() == "IndustrialPropaneTank" then
            previousBT = items:get(i);
		elseif items:get(i):getType() == "PropaneTank" then
			propaneTank = items:get(i);
		end
    end
    result:setUsedDelta(previousBT:getUsedDelta() + result:getUseDelta() * 1);

    while result:getUsedDelta() < 1 and propaneTank:getUsedDelta() > 0 do
        result:setUsedDelta(result:getUsedDelta() + result:getUseDelta() * 1);
        propaneTank:Use();
    end

    if result:getUsedDelta() > 1 then
        result:setUsedDelta(1);
    end
end

function Recipe.OnCreate.WaterBottle(items, result, player)
    player:getInventory():AddItem("Base.WaterBottleEmpty")
end