VirtualGenerator = {}

function VirtualGenerator.Add (x, y, z, fuel)
    local globalModData = GetMGModData()

    if x and y and z then 

        local entry = {}
        entry.x = x
        entry.y = y
        entry.z = z
        entry.state = false
        entry.totalPower = 0
        entry.realTotalPower = 0
        entry.totalFuelConsumption = 0
        entry.realTotalFuelConsumption = 0
        entry.fuel = fuel
        entry.poweredItems = {}
        entry.groupPoweredItems = {}

        table.insert(globalModData.WorkingGenerators, entry)

        if isClient() then
            sendClientCommand(getPlayer(), 'mg_commands', 'add_virtual_generator', entry)
        end
    end
end

function VirtualGenerator.Remove (x, y, z)
    local globalModData = GetMGModData()

    if x and y and z then 
        for k, v in pairs(globalModData.WorkingGenerators) do
            if v then
                if v.x == x and v.y == y and v.z == z then
                    table.remove(globalModData.WorkingGenerators, k)
                    if isClient() then
                        sendClientCommand(getPlayer(), 'mg_commands', 'remove_virtual_generator', {x=x, y=y, z=z})
                    end
                    break
                end
            end
        end
    end
end

function VirtualGenerator.Toggle (x, y, z, st, fuel)
    local globalModData = GetMGModData()

    local entry = {}
    for k, v in pairs(globalModData.WorkingGenerators) do
        if v then
            if v.x == x and v.y == y and v.z == z then
                entry = v
                entry.state = st
                entry.fuel = fuel
                table.remove(globalModData.WorkingGenerators, k)
                table.insert(globalModData.WorkingGenerators, entry)
                if isClient() then
                    sendClientCommand(getPlayer(), 'mg_commands', 'update_virtual_generator', entry)
                end
                break
            end
        end
    end
end

function VirtualGenerator.Get (x, y, z)
    local globalModData = GetMGModData()

    for k, v in pairs(globalModData.WorkingGenerators) do
        if v then
            if v.x == x and v.y == y and v.z == z then
                return v
            end
        end
    end
    return false
end

function VirtualGenerator.GetAll ()
    local globalModData = GetMGModData()
    return globalModData.WorkingGenerators
end