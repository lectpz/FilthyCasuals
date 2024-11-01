function Recipe.OnTest.isSlurryCooked(sourceItem, result)
    if sourceItem:getFullType() == "Biofuel.CornSlurry" then
        return sourceItem:isCooked()
    end
    return true
end

function Recipe.OnTest.PotFull(sourceItem, result)
    if sourceItem:getFullType() == "Biofuel.UnfilteredMoonshinePot" then
        return sourceItem:getUsedDelta() == 1
    end
    return true
end

function Recipe.OnCreate.ConvertToPot(items, result, player)
    player:getInventory():AddItem("Base.Pot")
end

function Recipe.OnCreate.FillKeg(items, result, player)
	for i=0, items:size()-1 do
		local item = items:get(i)
        if item:getType() == "EmptyKeg" then
            result:setUsedDelta(result:getUseDelta() * 4);
            player:getInventory():AddItem("Base.Pot")
        elseif item:getType() == "KegofMoonshine" then
			result:setUsedDelta(item:getUsedDelta() + (item:getUseDelta() * 4));
            player:getInventory():AddItem("Base.Pot")
		end
	end
end

function Recipe.OnTest.KegAmount(sourceItem, result)
    if sourceItem:getFullType() == "Biofuel.KegofBeer" then
        return sourceItem:getUsedDelta() > 0
    end
    return true
end

function Recipe.OnCreate.FillCup(items, result, player)
    local inv = player:getInventory()
	for i=0, items:size()-1 do
		local item = items:get(i)
        if item:getType() == "KegofBeer" then
            if round(item:getUsedDelta(),2) <= .08 then
                inv:AddItem("Biofuel.EmptyKeg")
                inv:AddItem("Base.BeerBottle")
            else
                local keg = inv:AddItem("Biofuel.KegofBeer")
                keg:setUsedDelta(item:getUsedDelta() - item:getUseDelta());
                inv:AddItem("Base.BeerBottle")
            end
		end
	end
end

function Recipe.OnTest.FullKeg(sourceItem, result)
    if sourceItem:getFullType() == "Biofuel.KegofMoonshine" then
        return sourceItem:getUsedDelta() == 1
    end
    return true
end

function Recipe.OnCreate.ReturnEmptyKeg(items, result, player)
    player:getInventory():AddItem("Biofuel.EmptyKeg")
end

function Recipe.OnCreate.setAge(items, result, player)
    result:setAge(0);
end

function Recipe.OnTest.FullIBC(sourceItem, result)
    if sourceItem:getFullType() == "Biofuel.IBCGas" then
        return sourceItem:getUsedDelta() ~= 1
    end
    return true
end

function Recipe.OnTest.FullCan(sourceItem, result)
    if sourceItem:getFullType() == "Biofuel.NatoJerryCan" or sourceItem:getFullType() == "Base.PetrolCan" then
        return sourceItem:getUsedDelta() ~= 1
    end
    return true
end

function Recipe.OnCreate.PourPetrolintoIBC(items, result, player)
    
    local inv = player:getInventory();
    local ibc = nil;
    local gascan = nil;
    local ibcEmpty = nil;

    for i=0, items:size()-1 do
        if items:get(i):getType() == "IBCGas" then
            ibc = items:get(i);
        elseif items:get(i):getType() == "IBCEmpty" then
            ibcEmpty = true;
            ibc = InventoryItemFactory.CreateItem("Biofuel.IBCGas");
            ibc:setUsedDelta(0)
        elseif items:get(i):getType() == "PetrolCan" or items:get(i):getType() == "NatoJerryCan" then
            gascan = items:get(i);
        end
    end

    local gascanDelta = gascan:getUseDelta()
    local gascanMaxCapacity = 1/gascanDelta
    local gascanCurrentLevel = gascan:getDelta() * gascanMaxCapacity

    local ibcDelta = ibc:getUseDelta()
    local ibcMaxCapacity = 1/ibcDelta
    local ibcCurrentLevel = ibcMaxCapacity * ibc:getDelta()
    local ibcSpace = ibcMaxCapacity - ibcCurrentLevel

    if ibcEmpty then
        result:setUsedDelta(gascanCurrentLevel * ibcDelta)

        if gascan:getType() == "NatoJerryCan" then
            inv:AddItem(InventoryItemFactory.CreateItem("Biofuel.EmptyNatoJerryCan"))
        elseif gascan:getType() == "PetrolCan" then
            inv:AddItem(InventoryItemFactory.CreateItem("Base.EmptyPetrolCan"))
        end
    elseif ibcSpace > gascanCurrentLevel then
        result:setUsedDelta((ibcCurrentLevel + gascanCurrentLevel) * ibcDelta)

        if gascan:getType() == "NatoJerryCan" then
            inv:AddItem(InventoryItemFactory.CreateItem("Biofuel.EmptyNatoJerryCan"))
        elseif gascan:getType() == "PetrolCan" then
            inv:AddItem(InventoryItemFactory.CreateItem("Base.EmptyPetrolCan"))
        end
    else
        result:setUsedDelta(1)
        gascan:setUsedDelta((gascanCurrentLevel - ibcSpace) * gascanDelta)
        inv:AddItem(gascan)
    end

end

function Recipe.OnCreate.FillCansFromIBC(items, result, player)

    local inv = player:getInventory();
    local ibc = nil;
    local gascan = nil;
    local canEmpty = nil;

    for i=0, items:size()-1 do
        if items:get(i):getType() == "IBCGas" then
            ibc = items:get(i);
        elseif items:get(i):getType() == "NatoJerryCan" or items:get(i):getType() == "PetrolCan" then
            gascan = items:get(i);
        elseif items:get(i):getType() == "EmptyNatoJerryCan" then
            gascan = InventoryItemFactory.CreateItem("Biofuel.NatoJerryCan");
            gascan:setUsedDelta(0)
        elseif items:get(i):getType() == "EmptyPetrolCan" then
            gascan = InventoryItemFactory.CreateItem("Base.PetrolCan");
            gascan:setUsedDelta(0)
        end
    end
    local ibcDelta = ibc:getUseDelta()
    local ibcMaxCapacity = 1/ibcDelta
    local ibcCurrentLevel = ibcMaxCapacity * ibc:getDelta()
    local ibcSpace = ibcMaxCapacity - ibcCurrentLevel

    local gascanDelta = gascan:getUseDelta()
    local gascanMaxCapacity = 1/gascanDelta
    local gascanCurrentLevel = gascanMaxCapacity * gascan:getDelta()
    local gascanSpace = gascanMaxCapacity - gascanCurrentLevel

    if ibcCurrentLevel > gascanSpace then
        gascan:setUsedDelta(1)
        ibc:setUsedDelta((ibcCurrentLevel - gascanSpace) * ibcDelta)
        
        inv:AddItem(ibc)
        inv:AddItem(gascan)
    else
        gascan:setUsedDelta((ibcCurrentLevel + gascanCurrentLevel) * gascanDelta)
        inv:AddItem(InventoryItemFactory.CreateItem("Biofuel.IBCEmpty"))
        inv:AddItem(gascan)
    end
end