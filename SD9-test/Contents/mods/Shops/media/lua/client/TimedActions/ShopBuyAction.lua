require "TimedActions/ISBaseTimedAction"

ShopBuyAction = ISBaseTimedAction:derive("ShopBuyAction")
local Nfunction = require "Nfunction"

function ShopBuyAction:isValid()
    local username = self.character:getUsername()
    local coin,specialCoin = Balance.getUserBalance(username)
    local ticket = self.ticket
    return coin >= ticket.coin and specialCoin >= ticket.specialCoin
end

function ShopBuyAction:waitToStart()
    return self.character:shouldBeTurning()
end

function ShopBuyAction:update()
    if not self.shopUI:getIsVisible() then 
        self:forceStop()
    end
end

function ShopBuyAction:start()
end

function ShopBuyAction:stop()
    ISBaseTimedAction.stop(self)
end

function ShopBuyAction:perform()
    local cartItems = self.shopUI.cartItems.items
    local playerInv = self.character:getInventory()
    for k,v in pairs(cartItems) do
        local item = v.item
        local packItems = item.items
        if packItems then
            local drop = item.drop
            local square = self.character:getSquare()
            for k,v in pairs(packItems) do
                if drop then
                    if v.quantity then
                        for i = 1,v.quantity,1 do
                            square:AddWorldInventoryItem(v.item, 0.0, 0.0, 0.0)
                            Nfunction.buildLogShop(v.item)
                        end
                    else
                        square:AddWorldInventoryItem(v.item, 0.0, 0.0, 0.0)
                        Nfunction.buildLogShop(v.item)
                    end
                else
                    if v.quantity then 
                        playerInv:AddItems(v.item,v.quantity);
                        Nfunction.buildLogShop(v.item,v.quantity)
                    else
                        playerInv:AddItem(v.item);
                        Nfunction.buildLogShop(v.item)
                    end
                end
            end
        else
            if item.quantity then
                playerInv:AddItems(item.type,item.quantity);
                Nfunction.buildLogShop(item.type,item.quantity)
            else
                playerInv:AddItem(item.type);
                Nfunction.buildLogShop(item.type)
            end
        end 
    end
    local shopSquare = self.shop:getSquare()
    local coords = {
        x = shopSquare:getX(),
        y = shopSquare:getY(),
        z = shopSquare:getZ(),
    }
    Nfunction.logShop(coords)
    local ticket = self.ticket
    self.character:playSound("CashRegister")
    sendClientCommand("BS", "Withdraw", {ticket.coin,ticket.specialCoin})
    self.shopUI.cartItems:clear()
    ISBaseTimedAction.perform(self)
end

function ShopBuyAction:new(character,shopUI,ticket)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.shopUI = shopUI
    o.shop = shopUI.shop
    o.ticket = ticket
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = 100
    return o
end 