if not isClient() then return end

local PSClient = {}

function PSClient.ToggleBusy(args)
    PlayerShop.status[args[1]] = args[2]
end

function PSClient.SyncStatusData(args)
    PlayerShop.status = args[1]
end

local function PS_OnServerCommand(module, command, args)
    if module== "PS" and PSClient[command] then
        PSClient[command](args)
    end
end

local function SyncPlayerShopStatusData()
	sendClientCommand("PS", "SyncStatusData", {})
    Events.OnTick.Remove(SyncPlayerShopStatusData)
end

Events.OnTick.Add(SyncPlayerShopStatusData)
Events.OnServerCommand.Add(PS_OnServerCommand)