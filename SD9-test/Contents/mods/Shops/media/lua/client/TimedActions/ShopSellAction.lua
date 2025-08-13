require "TimedActions/ISBaseTimedAction"
local Nfunction = require "Nfunction"
ShopSellAction = ISBaseTimedAction:derive("ShopSellAction")

function ShopSellAction:isValid()
    return true
end

function ShopSellAction:waitToStart()
    return self.character:shouldBeTurning()
end

function ShopSellAction:update()
    if not self.shopUI:getIsVisible() then 
        self:forceStop()
    end
end

function ShopSellAction:start()
end

function ShopSellAction:stop()
    ISBaseTimedAction.stop(self)
end

function ShopSellAction:perform()
    local cartItems = self.shopUI.cartItems.items
    local playerInv = self.character:getInventory()
    local inventoryItems = {}
    local inventory = self.character:getInventory():getItems()
    for i = 0, inventory:size() -1 do
        local item = inventory:get(i)
        if not (item:isEquipped() or item:isFavorite()) then
            inventoryItems[item:getID()] = item
        end
    end
    local total = 0
    local totalSpecial = 0
    for k,v in pairs(cartItems) do
        local item = v.item
        local invItem = inventoryItems[item.id]
        if invItem then
            item.price = Nfunction.drainablePrice(invItem,item.priceFull)
            if item.specialCoin then
                totalSpecial = totalSpecial + item.price
            else
                total = total + item.price
            end
            if SandboxVars.Shops.SellLog then Nfunction.buildLogShop(invItem:getFullType()) end
            invItem:getContainer():Remove(invItem)
        end
    end
    local shopSquare = self.shop:getSquare()
    local coords = {
        x = shopSquare:getX(),
        y = shopSquare:getY(),
        z = shopSquare:getZ(),
    }
    if SandboxVars.Shops.SellLog then Nfunction.logShop(coords,"Sell") end
    local playerInv = self.character:getInventory()
    if total > 0 then
        playerInv:AddItems(Currency.BaseCoin,total);
    end
    if totalSpecial > 0 then
        playerInv:AddItems(Currency.SpecialCoin,totalSpecial);
    end
    if total > 0 or totalSpecial > 0 then self.character:playSound("CashRegister") end
    self.shopUI.cartItems:clear()
    ISBaseTimedAction.perform(self)
end

function ShopSellAction:new(character,shopUI)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.shopUI = shopUI
    o.shop = shopUI.shop
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = 100
    return o
end 