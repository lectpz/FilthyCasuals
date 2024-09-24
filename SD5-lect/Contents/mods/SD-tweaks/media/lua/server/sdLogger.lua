local Commands = {};
Commands.sdLogger = {};

---------------------------------------------------------------------------------------------------
-------------------- Server commands

function Commands.sdLogger.LogEventDeath(player, args)
    print("[sdLogger] Player [" .. args.player_name .. "] died (Event Zone) at (" .. args.player_x .. "," .. args.player_y .. ") in " .. args.zonename .." [T" .. args.zonetier .. "] with " .. args.z_vis .. " visible zombies, " .. args.z_chase .. " chasing zombies, " .. args.z_close .. " very close zombies. Hours Survived = " .. args.player_hrs .. ", Zombies Killed = " .. args.player_kc)
end

function Commands.sdLogger.LogHCDeath(player, args)
    print("[sdLogger] Player [" .. args.player_name .. "] died (HC) at (" .. args.player_x .. "," .. args.player_y .. ") in " .. args.zonename .." [T" .. args.zonetier .. "] with " .. args.z_vis .. " visible zombies, " .. args.z_chase .. " chasing zombies, " .. args.z_close .. " very close zombies. Hours Survived = " .. args.player_hrs .. ", Zombies Killed = " .. args.player_kc)
end

function Commands.sdLogger.LogSSFDeath(player, args)
    print("[sdLogger] Player [" .. args.player_name .. "] died (SSF) at (" .. args.player_x .. "," .. args.player_y .. ") in " .. args.zonename .." [T" .. args.zonetier .. "] with " .. args.z_vis .. " visible zombies, " .. args.z_chase .. " chasing zombies, " .. args.z_close .. " very close zombies. Hours Survived = " .. args.player_hrs .. ", Zombies Killed = " .. args.player_kc)
end

function Commands.sdLogger.LogHCSSFDeath(player, args)
    print("[sdLogger] Player [" .. args.player_name .. "] died (HCSSF) at (" .. args.player_x .. "," .. args.player_y .. ") in " .. args.zonename .." [T" .. args.zonetier .. "] with " .. args.z_vis .. " visible zombies, " .. args.z_chase .. " chasing zombies, " .. args.z_close .. " very close zombies. Hours Survived = " .. args.player_hrs .. ", Zombies Killed = " .. args.player_kc)
end

function Commands.sdLogger.LogNormalDeath(player, args)
    print("[sdLogger] Player [" .. args.player_name .. "] died at (" .. args.player_x .. "," .. args.player_y .. ") in " .. args.zonename .." [T" .. args.zonetier .. "] with " .. args.z_vis .. " visible zombies, " .. args.z_chase .. " chasing zombies, " .. args.z_close .. " very close zombies. Hours Survived = " .. args.player_hrs .. ", Zombies Killed = " .. args.player_kc)
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

function Commands.sdLogger.ItemTransfer(player, args)
    print("[sdLogger] Player [" .. args.player_name .. "] moved items at (" .. args.player_x .. "," .. args.player_y .. "," .. args.player_z .. ") in " .. args.zonename .. " [T" .. args.zonetier .. "]: " .. args.itemString[1])
end

function Commands.sdLogger.ItemPlaced(player, args)
    print("[sdLogger] Player [" .. args.player_name .. "] placed item [" ..args.item .. " (ID=" .. (args.itemID) .. ")] at (" .. args.placedX .. "," .. args.placedY .. "," .. args.placedZ .. ")")
end

function Commands.sdLogger.RerollWeapon(player, args)
    print("[sdLogger] Player [" .. args.player_name .. "] " .. (args.reroll) .. " at (" .. args.player_x .. "," .. args.player_y .. ") in " .. args.zonename .. " [T" .. args.zonetier .. "]")
	for key, value in pairs(args) do
        if string.match(key, "^item%d+$") then
            for _, item in ipairs(value) do 
                print("[sdLogger] [" .. string.upper(args.reroll) .. "] Player [" .. args.player_name .. "] received: " .. item)
            end
        end
    end
end

function Commands.sdLogger.onItemFall(player, args)
    print("[sdLogger] Player [" .. args.player_name .. "] was forced to drop [" ..args.item .. " (ID=" .. (args.itemID) .. ")] at (" .. args.player_x .. "," .. args.player_y .. "," .. args.player_z .. ") in " .. args.zonename .. " [T" .. args.zonetier .. "]")
end

function Commands.sdLogger.ClaimReward(player, args)
    print("[sdLogger] Player [" .. args.player_name .. "] claimed an event reward: [" .. string.upper(args.eventreward) .. "] at (" .. args.player_x .. "," .. args.player_y .. ") in " .. args.zonename .. " [T" .. args.zonetier .. "]")
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

function Commands.sdLogger.isXferHeavyItem(player, args)
	print("[sdLogger] Player [" .. args.player_name .. "] tried to force drop heavy items while transferring items at (" .. args.player_x .. "," .. args.player_y .. ") in " .. args.zonename .." [T" .. args.zonetier .. "]")
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