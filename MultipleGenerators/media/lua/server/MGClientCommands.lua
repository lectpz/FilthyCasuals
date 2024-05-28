MGServer = {}
MGServer.mg_commands = {}

-- virtual genny sync

MGServer.mg_commands.add_virtual_generator = function(player, args)
    local globalModData = GetMGModData()
    table.insert(globalModData.WorkingGenerators, args)
end

MGServer.mg_commands.remove_virtual_generator = function(player, args)
    local globalModData = GetMGModData()
    for k, v in pairs(globalModData.WorkingGenerators) do
        if v then
            if v.x == args.x and v.y == args.y and v.z == args.z then
                table.remove(globalModData.WorkingGenerators, k)
                break
            end
        end
    end
end

MGServer.mg_commands.update_virtual_generator = function(player, args)
    local globalModData = GetMGModData()
    for k, v in pairs(globalModData.WorkingGenerators) do
        if v then
            if v.x == args.x and v.y == args.y and v.z == args.z then
                table.remove(globalModData.WorkingGenerators, k)
                table.insert(globalModData.WorkingGenerators, args)
                break
            end
        end
    end
end

MGServer.mg_commands.update_generators = function(player, args)
    MGUpdateGenerators(false)
end

-- main

local onClientCommand = function(module, command, player, args)
    if MGServer[module] and MGServer[module][command] then
        -- print ("received1 " .. module .. " " .. command)
        local argStr = ''
        for k, v in pairs(args) do
            argStr = argStr .. ' ' .. k .. '=' .. tostring(v)
        end
        -- print ("received " .. module .. " " .. command .. " " .. tostring(player) .. argStr)
        MGServer[module][command](player, args);
    end
end

Events.OnClientCommand.Add(onClientCommand);

