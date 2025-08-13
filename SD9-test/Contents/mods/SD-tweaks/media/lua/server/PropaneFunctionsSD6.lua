require "recipecode"

function Recipe.OnTest.RefillBlowTorchBioIndustrial(item)
    if item:getType() == "BlowTorch" then
        if item:getUsedDelta() == 1 then return false; end
    elseif item:getType() == "IndustrialPropaneTank" then
        if item:getUsedDelta() == 0 then return false; end
    end
    return true;
end

-- Fill entirely the blowtorch with the remaining propane
function Recipe.OnCreate.RefillBlowTorchBioIndustrial(items, result, player)
    local previousBT = nil;
    local propaneTank = nil;
    for i=0, items:size()-1 do
       if items:get(i):getType() == "BlowTorch" then
           previousBT = items:get(i);
       elseif items:get(i):getType() == "IndustrialPropaneTank" then
           propaneTank = items:get(i);
       end
    end
    result:setUsedDelta(previousBT:getUsedDelta() + result:getUseDelta() * 32);
	if previousBT:getUsedDelta() > 0 then propaneTank:Use() end

    while result:getUsedDelta() < 1 and propaneTank:getUsedDelta() > 0 do
        result:setUsedDelta(result:getUsedDelta() + result:getUseDelta() * 32);
        propaneTank:Use();
    end

    if result:getUsedDelta() > 1 then
        result:setUsedDelta(1);
    end
end



function Recipe.OnTest.checkFullPropaneTank(item)
    if item:getType() == "PropaneTank" then
        if item:getUsedDelta() <= 0.99 then return false; end
    end
    return true;
end

function Recipe.OnTest.checkEmptyPropaneTank(item)
    if item:getType() == "PropaneTank" then
        if item:getUsedDelta() > 0 then return false; end
    end
    return true;
end

function Recipe.OnTest.checkEmptyPropaneTorch(item)
    if item:getType() == "BlowTorch" then
        if item:getUsedDelta() > 0 then return false; end
    end
    return true;
end

function Recipe.OnTest.checkEmptyIndustrialPropaneTank(item)
    if item:getType() == "IndustrialPropaneTank" then
        if item:getUsedDelta() > 0 then return false; end
    end
    return true;
end

function Recipe.OnCreate.RefillBlowTorch(items, result, player)
    local previousBT = nil;
    local propaneTank = nil;
    for i=0, items:size()-1 do
       if items:get(i):getType() == "BlowTorch" then
           previousBT = items:get(i);
       elseif items:get(i):getType() == "PropaneTank" then
           propaneTank = items:get(i);
       end
    end
    result:setUsedDelta(previousBT:getUsedDelta() + result:getUseDelta() * 32);
	propaneTank:Use()

    while result:getUsedDelta() < 1 and propaneTank:getUsedDelta() > 0 do
        result:setUsedDelta(result:getUsedDelta() + result:getUseDelta() * 32);
        propaneTank:Use();
    end

    if result:getUsedDelta() > 1 then
        result:setUsedDelta(1);
    end
end