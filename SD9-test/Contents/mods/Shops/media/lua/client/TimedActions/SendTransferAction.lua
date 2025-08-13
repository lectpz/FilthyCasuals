require "TimedActions/ISBaseTimedAction"

SendTransferAction = ISBaseTimedAction:derive("SendTransferAction")

function SendTransferAction:isValid()
    local username = self.character:getUsername()
    local coin,specialCoin = Balance.getUserBalance(username)
    local transfer = self.transfer
    local recipientAccount = Balance.getUserAccount(transfer.recipient)
    if not recipientAccount then return false end
    return coin >= transfer.coin and specialCoin >= transfer.specialCoin
end

function SendTransferAction:waitToStart()
    return self.character:shouldBeTurning()
end

function SendTransferAction:update()
    if not self.transferUI:getIsVisible() then 
        self:forceStop()
    end
end

function SendTransferAction:start()
end

function SendTransferAction:stop()
    ISBaseTimedAction.stop(self)
end

function SendTransferAction:perform()
    local transfer = self.transfer
    sendClientCommand("BS", "Transfer", {transfer.coin,transfer.specialCoin,transfer.recipient})
    local transferUI = self.transferUI
    transferUI:clearAfterTransfer()
    ISBaseTimedAction.perform(self)
end

function SendTransferAction:new(character,transferUI,transfer)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.transferUI = transferUI
    o.transfer = transfer
    o.stopOnWalk = false
    o.stopOnRun = true
    o.maxTime = 100
    return o
end 