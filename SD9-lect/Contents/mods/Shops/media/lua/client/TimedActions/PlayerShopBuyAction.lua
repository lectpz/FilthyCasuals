require "TimedActions/ISBaseTimedAction"
local Nfunction = require "Nfunction"
PlayerShopBuyAction = ISBaseTimedAction:derive("PlayerShopBuyAction")

function PlayerShopBuyAction:isValid()
    local username = self.character:getUsername()
    local coin,specialCoin = Balance.getUserBalance(username)
    local ticket = self.ticket
    return coin >= ticket.coin and specialCoin >= ticket.specialCoin
end

function PlayerShopBuyAction:waitToStart()
    return self.character:shouldBeTurning()
end

function PlayerShopBuyAction:update()
    if not self.shopUI:getIsVisible() then 
        self:forceStop()
    end
end

function PlayerShopBuyAction:start()
end

function PlayerShopBuyAction:stop()
    ISBaseTimedAction.stop(self)
end

function PlayerShopBuyAction:perform()
    local cartItems = self.shopUI.cartItems.items
    local playerInv = self.character:getInventory()
    local total = 0
    local totalSpecial = 0
    for k,v in pairs(cartItems) do
        local item = v.item
        local invItem = item.invItem
        shopContainer = self.shop:getContainer()
        if shopContainer:contains(invItem) then
            shopContainer:Remove(invItem)
            shopContainer:removeItemOnServer(invItem)
            playerInv:addItem(invItem)
            if SandboxVars.Shops.PurchaseLog then Nfunction.buildLogShop(invItem:getFullType()) end
            if item.specialCoin then
                totalSpecial = totalSpecial + item.price
            else
                total = total + item.price
            end
            local modData = invItem:getModData()
            modData.specialCoin = nil
            modData.price = nil
        end
    end
    local shopSquare = self.shop:getSquare()
    local coords = {
        x = shopSquare:getX(),
        y = shopSquare:getY(),
        z = shopSquare:getZ(),
    }
    if SandboxVars.Shops.PurchaseLog then Nfunction.logShop(coords,"Purchase") end
    self.character:playSound("CashRegister")
    local income = self.shop:getModData().income
    local data = {
        b = self.character:getUsername(),
        t = {tl = total, tls = totalSpecial}
    }
    if total > 0 or totalSpecial > 0 then
        sendClientCommand("BS", "Withdraw", {total,totalSpecial})
        table.insert(income,data)
    end
    self.shop:transmitModData()
    self.shopUI:activateFirstTab()
    ISBaseTimedAction.perform(self)
end

function PlayerShopBuyAction:new(character,shopUI,ticket)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.shopUI = shopUI
    o.ticket = ticket
    o.shop = shopUI.shop
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = 100
    return o
end 