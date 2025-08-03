if not isClient() then return end

local BClient = {}

function BClient.OnReceiveGlobalModData(key, modData)
    if not modData then return end
    ModData.remove(key)
    ModData.add(key, modData)
end
Events.OnReceiveGlobalModData.Add(BClient.OnReceiveGlobalModData)

function BClient.OnConnected()
	ModData.request("CoinBalance")
end

function BClient.TransferReceived(noti)
    local player = getPlayer()
    local sender = noti.sender
    local coin = Currency.format(noti.coin)
    local specialCoin = Currency.format(noti.specialCoin)
    local msg = getText("IGUI_Balance_TransferReceivedSpecial",sender,coin,specialCoin)
    if not Currency.UseSpecialCoin then
        msg = getText("IGUI_Balance_TransferReceived",sender,coin)
    end
    player:playSound("Notification")
    player:setHaloNote(msg, 255,255,255,400);
end

local function BS_OnServerCommand(module, command, args)
    if module== "BS" and BClient[command] then
        BClient[command](args)
    end
end

Events.OnServerCommand.Add(BS_OnServerCommand)
Events.OnConnected.Add(BClient.OnConnected)