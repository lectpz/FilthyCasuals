function Currency.lootCoins(worldobjects,playerNum,player)
    local containers = getPlayerLoot(playerNum).inventoryPane.inventoryPage.backpacks
    local coinsList = ArrayList.new();
    for k,v in pairs(containers) do
        local container = v.inventory 
        if container then
            for k,v in pairs(Currency.Coins) do
                local coins = container:getItemsFromFullType(k)
                if coins:size() > 0 then 
                    coinsList:addAll(coins)
                end
            end
        end
    end
    if coinsList:size() > 0 then 
        local playerInv = getPlayerInventory(playerNum).inventory
        for i=0, coinsList:size() - 1 do
            local coin = coinsList:get(i)
            ISTimedActionQueue.add(ISInventoryTransferAction:new(player, coin, coin:getContainer(), playerInv))
        end        
    end
end

function Currency.LootCoinsObjectContextMenu(playerNum, context, items)
    local player = getSpecificPlayer(playerNum);
    if(player:getVehicle() ~= nil) then return end
    items = ISInventoryPane.getActualItems(items)
    if not items then return end
    if #items< 1 then return end  
    if items[1]:isInPlayerInventory() then return end
    local coin = Currency.Coins[items[1]:getFullType()]
    if not coin then return end
    context:addOption(UIText.LootAllCoins, worldobjects, Currency.lootCoins,playerNum, player);
end

function Currency.coinsToAccount(worldobjects,items,coinQuantity)
    for k,v in pairs(items) do
        v:getContainer():Remove(v)
    end
    sendClientCommand("BS", "Deposit", {coinQuantity.coin,coinQuantity.specialCoin})
end

function Currency.CoinsToAccountObjectContextMenu(playerNum, context, items)
    items = ISInventoryPane.getActualItems(items)
    if not items then return end
    local playerInv = getPlayerInventory(playerNum).backpacks[1].inventory
    local wallet = nil
    local player = getSpecificPlayer(playerNum)
    local username = player:getUsername()
    for k,v in pairs(Currency.Wallets) do
        local items = playerInv:getItemsFromFullType(k)
        for i=0, items:size() - 1 do
            local w = items:get(i)
            if w:getModData().belongsTo == username and w:getModData().linkedTo then
                wallet = w
                break;
            end
        end
    end
    if not wallet then return end
    local coinQuantity = {}
    coinQuantity.coin = 0
    coinQuantity.specialCoin = 0
    for k, v in pairs(items) do
        if not v:isInPlayerInventory() then return end
        local coin = Currency.Coins[v:getFullType()]
        if not coin then return end
        if not coin.specialCoin then
            coinQuantity.coin = coinQuantity.coin + coin.value
        else
            coinQuantity.specialCoin = coinQuantity.specialCoin + 1
        end
    end
    local account =  Balance.getUserAccount(username)
    if account and (coinQuantity.coin > 0 or coinQuantity.specialCoin > 0 ) then
        context:addOption(UIText.CoinsToAccount, worldobjects, Currency.coinsToAccount,items,coinQuantity);
    end
end

function Currency.linkWallet(worldobjects,wallet,player)
    local username = player:getUsername()
    local linkedTo = username..getTimestampMs()
    wallet:getModData().belongsTo = username
    wallet:getModData().linkedTo = linkedTo
    sendClientCommand("BS", "CreateAccount", {linkedTo})
end

function Currency.LinkWalletObjectContextMenu(playerNum, context, items)
    items = ISInventoryPane.getActualItems(items)
    if not items or #items > 1 then return end
    local item = items[1]
    if not item then return end
    local itemType = item:getFullType()
    if not Currency.Wallets[itemType] then return end
    if not item:isInPlayerInventory() then return end
    if item:getModData().linkedTo then return end
    local player = getSpecificPlayer(playerNum)
    context:addOption(UIText.Link, worldobjects, Currency.linkWallet,item,player);
end

function Currency.unlinkWallet(worldobjects,wallet)
    wallet:getModData().belongsTo = nil
    wallet:getModData().linkedTo = nil 
end

function Currency.UnlinkWalletObjectContextMenu(playerNum, context, items)
    items = ISInventoryPane.getActualItems(items)
    if not items or #items > 1 then return end
    local item = items[1]
    if not item then return end
    local itemType = item:getFullType()
    if not Currency.Wallets[itemType] then return end
    if not item:isInPlayerInventory() then return end
    local player = getSpecificPlayer(playerNum)
    local username = player:getUsername()
    if not (item:getModData().belongsTo == username) then return end
    context:addOption(UIText.Transfer, worldobjects, Currency.transfer,item,player);
    context:addOption(UIText.Unlink, worldobjects, Currency.unlinkWallet,item);
end

function Currency.transfer(worldobjects,wallet,player)
    TransferUI:show(player)
end

Events.OnPreFillInventoryObjectContextMenu.Add(Currency.LootCoinsObjectContextMenu);
Events.OnPreFillInventoryObjectContextMenu.Add(Currency.LinkWalletObjectContextMenu);
Events.OnPreFillInventoryObjectContextMenu.Add(Currency.UnlinkWalletObjectContextMenu);
Events.OnPreFillInventoryObjectContextMenu.Add(Currency.CoinsToAccountObjectContextMenu);