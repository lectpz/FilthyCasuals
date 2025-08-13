local minutes = 10
local shopLockTime = minutes * 60 * 1000

local function seekShopTiles(worldobject,spritePrefix)
    local wo = worldobject
    local found = false
    if not wo then return wo,found end
    local sprite = wo:getSprite()
    local spriteName = sprite:getName()
    if spriteName then
        if(string.find(spriteName,spritePrefix)) then 
            found = true
        end
    end
    return wo, found
end

function PlayerShop.playerShopUI(worldobjects,playerNum,clickedSquare,shop)
    local player = getSpecificPlayer(playerNum)
    clickedSquare = luautils.getCorrectSquareForWall(player, clickedSquare);
    local adjacent = AdjacentFreeTileFinder.Find(clickedSquare, player);
    if adjacent then
        local action = ISWalkToTimedAction:new(player, adjacent)
        if PlayerShopUI.instance then
            PlayerShopUI.instance:close()
        end
        action:setOnComplete(function() 
            if PlayerShop.isBusy(shop) then return end
            PlayerShopUI:show(player,shop) 
        end)
        ISTimedActionQueue.add(action)
    end
end

function PlayerShop.addPlayerShop(worldobjects, playerNum,sprites)
    local player = getSpecificPlayer(playerNum)
    getCell():setDrag(ShopSpriteCursor:new(player,sprites),playerNum)
end

function PlayerShop.LockUnlockPlayerShop(worldobjects, shop, lock)
    shop:setLockedByPadlock(lock);
end

function PlayerShop.ViewIncome(worldobjects,shop)
    IncomeUI:show(player,shop)
end

function PlayerShop.PickupShop(worldobjects,player,shop)
    local items = shop:getContainer():getItems()
    if items and items:size() > 0 then
        player:setHaloNote(UIText.RemoveItemsPlayerShop, 255,255,255,400);
        return
    end
    local income = shop:getModData().income
    if #income and #income > 0 then
        player:setHaloNote(UIText.RemoveIncomePlayerShop, 255,255,255,400);
        return
    end
    shop:getSquare():transmitRemoveItemFromSquare(shop)
    local item = "Base.PlayerShop"
    if shop:getContainer():getType() == "freezer" then
        item = "Base.PlayerShopFreezer"
    end
    player:getInventory():AddItem(item)
    PlayerShop.toggleBusy(shop,player:getUsername(),false)
end

function PlayerShop.getShopID(shop)
    return shop:getX() .."-".. shop:getY()
end

function PlayerShop.isBlockByUser(shop,username)
    local id = PlayerShop.getShopID(shop)
    local shopStatus = PlayerShop.status[id]
    if not shopStatus then return false end
    return shopStatus.buyer == username
end

function PlayerShop.isBusy(shop)
    local id = PlayerShop.getShopID(shop)
    local shopStatus = PlayerShop.status[id]
    if shopStatus then
        if not shopStatus.time then shopStatus.time = getTimestampMs() + shopLockTime end
        if getTimestampMs() > shopStatus.time then
            return false
        else
            return shopStatus.busy
        end
    else
        return false
    end
end

function PlayerShop.toggleBusy(shop,username,busy)
	local shopId = PlayerShop.getShopID(shop)
    local data = {
        busy = busy,
        buyer = username,
        time = getTimestampMs() + shopLockTime
    }
    sendClientCommand("PS", "ToggleBusy", {shopId,data})
end

function PlayerShop.ChangeSprite(worldobjects, playerNum, sprites,shop)
    local sprite = shop:getSprite():getName()
    local spriteNum = string.gsub(sprite,PlayerShop.spritePrefix,"")
    local coords = {x=shop:getX(),y=shop:getY(),z=shop:getZ()}
    local sprite = nil
    if (spriteNum % 2 == 0) then
        sprite= sprites[1]
    else
        sprite= sprites[2]
    end
    if sprite then
        if isClient() then
            sendClientCommand("PS",'ChangeSprite', {sprite,coords})
        end
    end
end

function PlayerShop.PlayerShopContextMenu(playerNum, context, worldobjects)
    local player = getSpecificPlayer(playerNum)
    local wo, found = seekShopTiles(worldobjects[1],PlayerShop.spritePrefix)
    local owner = ""
    if found then
        owner = wo:getModData().owner
        local optionView = getText("IGUI_ViewPlayerShop",owner)
        local viewPS = context:addOption(optionView, worldobjects, PlayerShop.playerShopUI, playerNum,clickedSquare,wo);
        local isBusy = PlayerShop.isBusy(wo) 
        if isBusy then viewPS.notAvailable = isBusy end
        if player:getUsername() == owner then
            local shop = context:addOption(UIText.ManagePlayerShop,worldobjects,nil);
            local subShop = context:getNew(context);
            context:addSubMenu(shop, subShop);
            if not(wo:getContainer():getType()== "freezer") then
                if wo:isLockedByPadlock() then
                    local unlockOption = subShop:addOption(UIText.UnlockContainerPlayerShop, worldobjects, PlayerShop.LockUnlockPlayerShop, wo,false);
                    if isBusy then unlockOption.notAvailable = isBusy end
                else
                    local lockOption = subShop:addOption(UIText.LockContainerPlayerShop, worldobjects, PlayerShop.LockUnlockPlayerShop, wo,true);
                    if isBusy then lockOption.notAvailable = isBusy end
                end
                local sign = subShop:addOption(UIText.ChangeSign, worldobjects,nil);
                local subSign = context:getNew(context);
                context:addSubMenu(sign, subSign);
                for k,v in pairs(PlayerShop.sprites) do
                    if not (k =="Freezer") then
                        subSign:addOption(k, worldobjects, PlayerShop.ChangeSprite, playerNum,v,wo);
                    end
                end
            end
            subShop:addOption(UIText.ViewIncomePlayerShop, worldobjects, PlayerShop.ViewIncome, wo);
            subShop:addOption(UIText.PickupPlayerShop, worldobjects, PlayerShop.PickupShop,player, wo);
        end
    end
    local playerShop = player:getInventory():containsTag("PlayerShop")
    if playerShop then
        context:addOption(UIText.AddPlayerShop, worldobjects, PlayerShop.addPlayerShop, playerNum,PlayerShop.sprites.NoSign);
    end
    playerShop = player:getInventory():containsTag("PlayerShopFreezer")
    if playerShop then
        context:addOption(UIText.AddPlayerShopFreezer, worldobjects, PlayerShop.addPlayerShop, playerNum,PlayerShop.sprites.Freezer);
    end
end

function PlayerShop.PlayerShopSetPrice(worldobjects,playerNum,items,container)
    local player = getSpecificPlayer(playerNum)
    SetPriceUI:show(player,items,container)
end

function PlayerShop.ItemsSellPrice(playerNum, context, items)
    items = ISInventoryPane.getActualItems(items)
    if not items then return end
    if #items< 1 then return end 
    local container =  items[1]:getContainer()
    local player = getPlayer(playerNum)
    if container and container:isInCharacterInventory(player) then
        if player:getInventory():containsTag("Write") then
            context:addOption(UIText.SetPricePlayerShop, worldobjects, PlayerShop.PlayerShopSetPrice, playerNum,items,container);
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(PlayerShop.ItemsSellPrice);
Events.OnPreFillWorldObjectContextMenu.Add(PlayerShop.PlayerShopContextMenu)