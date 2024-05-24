local Commands = {};
Commands.sdLogger = {};

---------------------------------------------------------------------------------------------------
-------------------- Server commands

function Commands.sdLogger.LogEventDeath(player, args)
    print("[sdLogger] Player [" .. args.player_name .. "] died (Event Zone) at (" .. args.player_x .. "," .. args.player_y .. ") in " .. args.zonename .." [T" .. args.zonetier .. "]")
end

function Commands.sdLogger.LogHCDeath(player, args)
    print("[sdLogger] Player [" .. args.player_name .. "] died (HC) at (" .. args.player_x .. "," .. args.player_y .. ") in " .. args.zonename .." [T" .. args.zonetier .. "]")
end

function Commands.sdLogger.LogSSFDeath(player, args)
    print("[sdLogger] Player [" .. args.player_name .. "] died (SSF) at (" .. args.player_x .. "," .. args.player_y .. ") in " .. args.zonename .." [T" .. args.zonetier .. "]")
end

function Commands.sdLogger.LogHCSSFDeath(player, args)
    print("[sdLogger] Player [" .. args.player_name .. "] died (HCSSF) at (" .. args.player_x .. "," .. args.player_y .. ") in " .. args.zonename .." [T" .. args.zonetier .. "]")
end

function Commands.sdLogger.LogNormalDeath(player, args)
    print("[sdLogger] Player [" .. args.player_name .. "] died at (" .. args.player_x .. "," .. args.player_y .. ") in " .. args.zonename .." [T" .. args.zonetier .. "]")
end

function Commands.sdLogger.OpenCache(player, args)
    print("[sdLogger] Player [" .. args.player_name .. "] opened a [" .. string.upper(args.cachetype) .. "] at (" .. args.player_x .. "," .. args.player_y .. ") in " .. args.zonename .. " [T" .. args.zonetier .. "]")
    for key, value in pairs(args) do
        if string.match(key, "^item%d+$") then
            for _, item in ipairs(value) do 
                print("[sdLogger] [" .. string.upper(args.cachetype) .. "] Player [" .. args.player_name .. "] received: " .. item)
            end
        end
    end
end

function Commands.sdLogger.Login(player, args)
	print("[sdLogger] Player [" .. args.player_name .. "] logged in at (" .. args.player_x .. "," .. args.player_y .. ") in " .. args.zonename .." [T" .. args.zonetier .. "] with " .. args.z_vis .. " visible zombies, " .. args.z_chase .. " chasing zombies, " .. args.z_close .. " very close zombies after " .. args.counter .. " seconds.")
end

function Commands.sdLogger.CheckIn(player, args)
	print("[sdLogger] Player [" .. args.player_name .. "] checked in at (" .. args.player_x .. "," .. args.player_y .. ") in " .. args.zonename .." [T" .. args.zonetier .. "] with " .. args.z_vis .. " visible zombies, " .. args.z_chase .. " chasing zombies, " .. args.z_close .. " very close zombies.")
end

function Commands.sdLogger.fence(player, args)
	print("[sdLogger] Player [" .. args.player_name .. "] triggered fence check at (" .. args.player_x .. "," .. args.player_y .. ") in " .. args.zonename .." [T" .. args.zonetier .. "] Rules Broken #:" .. args.ruleBrokenCount)
end

function Commands.sdLogger.EventEntered(player, args)
	print("[sdLogger] Player [" .. args.player_name .. "] is participating in an event at (" .. args.player_x .. "," .. args.player_y .. ") in " .. args.zonename .." [T" .. args.zonetier .. "]")
end

function Commands.sdLogger.EventExited(player, args)
	print("[sdLogger] Player [" .. args.player_name .. "] has left the event boundaries at (" .. args.player_x .. "," .. args.player_y .. ") in " .. args.zonename .." [T" .. args.zonetier .. "]")
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local function onClientCommand(module, command, player, args)
    if Commands[module] and Commands[module][command] then
        Commands[module][command](player, args)
    end
end

if isServer() then
    Events.OnClientCommand.Add(onClientCommand);
end