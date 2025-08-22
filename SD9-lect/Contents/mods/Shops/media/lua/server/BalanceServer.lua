if not isServer() then return end

local BServer = {}

local logfile = "timestamp_economy.log"
local msg = ""

function BServer.OnInitGlobalModData()
    ModData.getOrCreate("CoinBalance")
end
Events.OnInitGlobalModData.Add(BServer.OnInitGlobalModData)

function BServer.writeLog(msg)
    if Valhalla and Valhalla.Commands then
        local args = {file = logfile, line = msg}
        Valhalla.Commands.writeToLog(nil, args)
        return
    end
    print(msg)
end

function BServer.CreateAccount(player,args)
    local username = player:getUsername()
    local account = ModData.get("CoinBalance")[username]

    if account then
        account.linkedTo = args[1]

        msg= "Link: %s linked new wallet: %s"
        msg = string.format(msg,username,args[1])
        BServer.writeLog(msg)

    else
        ModData.get("CoinBalance")[username] = {coin = 0, specialCoin = 0, linkedTo = args[1]}

        msg= "NewAccount: %s, Coin: 0 SpecialCoin: 0"
        msg = string.format(msg,username,args[1])
        BServer.writeLog(msg)

    end
    ModData.transmit("CoinBalance")
end

function BServer.Deposit(player,args)
    local username = player:getUsername()
    local account = ModData.get("CoinBalance")[username]
    if not account then return end
    account.coin = account.coin+args[1]
    account.specialCoin = account.specialCoin + args[2]

    msg = "Deposit: %s oldBalance: Coin: %s SpecialCoin %s newBalance: Coin: %s SpecialCoin %s"
    msg = string.format(msg,username,account.coin-args[1],account.specialCoin-args[2],account.coin,account.specialCoin)
    BServer.writeLog(msg)

    ModData.transmit("CoinBalance")
end

function BServer.Transfer(player,args)
    local username = player:getUsername()
    local account = ModData.get("CoinBalance")[username]
    local recipientAccount = ModData.get("CoinBalance")[args[3]]
    if not account or not recipientAccount then return end
    account.coin = account.coin-args[1]
    account.specialCoin = account.specialCoin-args[2]
    recipientAccount.coin = recipientAccount.coin+args[1]
    recipientAccount.specialCoin = recipientAccount.specialCoin+args[2]

    msg = "Transfer: Sender %s oldBalance: Coin: %s SpecialCoin %s newBalance: Coin: %s SpecialCoin %s Recipient: %s oldBalance: Coin: %s SpecialCoin %s newBalance: Coin: %s SpecialCoin %s"
    msg = string.format(msg,username,account.coin+args[1],account.specialCoin+args[2],account.coin,account.specialCoin,
    args[3],recipientAccount.coin-args[1],recipientAccount.specialCoin-args[2],recipientAccount.coin,recipientAccount.specialCoin)
    BServer.writeLog(msg)

    ModData.transmit("CoinBalance")
    local noti = { 
        sender = username,
        coin = args[1],
        specialCoin = args[2],
    }

    local players = getOnlinePlayers()
    local playersSize = players:size()
    if not playersSize then return end
    for i = 0, playersSize - 1, 1 do
        local player = players:get(i)
        if player:getUsername() == args[3] then
            sendServerCommand(player,"BS", "TransferReceived", noti)
            break;
        end
    end
end

function BServer.Withdraw(player,args)
    local username = player:getUsername()
    local account = ModData.get("CoinBalance")[username]
    if not account then return end
    if account.coin >= args[1] then
        account.coin = account.coin-args[1]
    end
    if account.specialCoin >= args[2] then
        account.specialCoin = account.specialCoin-args[2]
    end

    msg = "Withdraw: %s oldBalance: Coin: %s SpecialCoin %s newBalance: Coin: %s SpecialCoin %s"
    msg = string.format(msg,username,account.coin+args[1],account.specialCoin+args[2],account.coin,account.specialCoin)
    BServer.writeLog(msg)

    ModData.transmit("CoinBalance")
end

local function BS_OnClientCommand(module, command, player, args)
    if module == "BS" and BServer[command] then
        BServer[command](player, args)
    end
end

Events.OnClientCommand.Add(BS_OnClientCommand)