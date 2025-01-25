if not isServer() then return end

local LServer = {}

local logfile = "shops_transactions.log"
local msg = ""

function LServer.TransactionShopLog(player,args)
    msg = args[1]
    if Valhalla and Valhalla.Commands then
        local args = {file = logfile, line = msg}
        Valhalla.Commands.writeToLog(nil, args)
        return
    end
    print(msg)
end

local function LS_OnClientCommand(module, command, player, args)
    if module == "LS" and LServer[command] then
        LServer[command](player, args)
    end
end

Events.OnClientCommand.Add(LS_OnClientCommand)