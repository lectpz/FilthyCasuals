local Commands = {}
Commands.sdLogger = {}


function Commands.sdLogger.SWJavaSpearMod(player, args)
    print("[sdLogger] [SWDetect] Player [" .. args.player_name .. "] uses java spear lock removal mod at (" .. args.player_x .. "," .. args.player_y .. ")")
end

function Commands.sdLogger.SWJavaSpeedMod(player, args)
    print("[sdLogger] [SWDetect] Player [" .. args.player_name .. "] likely uses java/anim speed mod at (" .. args.player_x .. "," .. args.player_y .. ")")
end

function Commands.sdLogger.SWSpeedMacro(player, args)
    print("[sdLogger] [SWDetect] Player [" .. args.player_name .. "] probably uses macro for animation cancel at (" .. args.player_x .. "," .. args.player_y .. ")")
end

function Commands.sdLogger.SWJavaViewMod(player, args)
    print("[sdLogger] [SWDetect] Player [" .. args.player_name .. "] uses java 360 vision mod at (" .. args.player_x .. "," .. args.player_y .. ")")
end


local function onClientCommand(module, command, player, args)
    if Commands[module] and Commands[module][command] then
        Commands[module][command](player, args)
    end
end

if isServer() then
    Events.OnClientCommand.Add(onClientCommand)
end
