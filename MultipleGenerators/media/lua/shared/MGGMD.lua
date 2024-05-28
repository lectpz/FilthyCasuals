MGModData = {}

function InitMGModData(isNewGame)

    local modData = ModData.getOrCreate("MultipleGenerators")

    if isClient() then
        ModData.request("MultipleGenerators")
    end

    if not modData.WorkingGenerators then modData.WorkingGenerators = {} end

    MGModData = modData
end

function LoadMGModData(key, modData)
    if isClient() then
        if key and key == "MultipleGenerators" and modData then
            MGModData = modData
        end
    end
end

function TransmitMGModData()
    ModData.transmit("MultipleGenerators")
end

function GetMGModData()
    return MGModData
end

Events.OnInitGlobalModData.Add(InitMGModData)
Events.OnReceiveGlobalModData.Add(LoadMGModData)
