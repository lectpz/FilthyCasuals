local DAMN = DAMN or {};
DAMN.Spawns = DAMN.Spawns or {};

if isClient() then return end

function DAMN.Spawns:checkIfAllowed(squareConfig)
    DAMN:log("DAMN.Spawns:checkIfAllowed(...)");

    if squareConfig["sandboxVar"] and not SandboxVars["DAMN"][squareConfig["sandboxVar"]]
    then
        if DAMN["spawnerDebug"]
        then
            DAMN:log(" -> spawning this vehicle is disabled in sandbox options: " .. tostring(squareConfig["sandboxVar"]));
        end

        return false;
    end

    if #squareConfig["modBlacklist"] > 0 or #squareConfig["modWhitelist"] > 0
    then
        local modList = getActivatedMods();

        if #squareConfig["modBlacklist"]
        then
            if DAMN["spawnerDebug"]
            then
                DAMN:log(" - checking mod blacklist");
            end

            local failed = {};

            --for i, modId in ipairs(squareConfig["modBlacklist"])
			for i=1,#squareConfig["modBlacklist"]--lect
            do
				modId = squareConfig["modBlacklist"][i]--lect
                if DAMN["spawnerDebug"]
                then
                    DAMN:log("    - looking for [" .. tostring(modId) .."]");
                end

                if modList:contains(modId)
                then
                    table.insert(failed, modId);
                end
            end

            if #failed > 0
            then
                if DAMN["spawnerDebug"]
                then
                    DAMN:log(" -> mod blacklist checks failed:");
                    DAMN:printList(failed, "    - mod [%s] prevents this spawn");
                end

                return false;
            elseif DAMN["spawnerDebug"]
            then
                DAMN:log(" -> mod blacklist checks passed");
            end
        end

        if #squareConfig["modWhitelist"] > 0
        then
            if DAMN["spawnerDebug"]
            then
                DAMN:log(" - checking mod whitelist");
            end

            local failed = {};

            --for i, modId in ipairs(squareConfig["modWhitelist"])
			for i=1, #squareConfig["modWhitelist"]--lect
            do
				modId = squareConfig["modWhitelist"][i]--lect
                if DAMN["spawnerDebug"]
                then
                    DAMN:log("    - looking for [" .. tostring(modId) .."]");
                end

                if not modList:contains(modId)
                then
                    table.insert(failed, modId);
                end
            end

            if #failed > 0
            then
                if DAMN["spawnerDebug"]
                then
                    DAMN:log(" -> mod whitelist checks failed:");
                    DAMN:printList(failed, "    - mod [%s] not found");
                end

                return false;
            elseif DAMN["spawnerDebug"]
            then
                DAMN:log(" -> mod whitelist checks passed");
            end
        end
    end

    if #squareConfig["mapBlacklist"] > 0 or #squareConfig["mapWhitelist"] > 0
    then
        local maps = string.split(getServerOptions():getOptionByName("Map"):getValue(), ";") or {};

        if DAMN["spawnerDebug"]
        then
            DAMN:log(" - loaded maps:");
        end

        if #squareConfig["mapBlacklist"] > 0
        then
            if DAMN["spawnerDebug"]
            then
                DAMN:log(" - checking map blacklist");
            end

            local failed = {};

            --for i, map in ipairs(maps)
			for i=1,#maps--lect
            do
			map = maps[i]--lect
                if DAMN["spawnerDebug"]
                then
                    DAMN:log("    - checking if loaded map [" .. tostring(map) .."] is blacklisted");
                end

                if DAMN:itemIsInArray(squareConfig["mapBlacklist"], map)
                then
                    table.insert(failed, map);
                end
            end

            if #failed > 0
            then
                if DAMN["spawnerDebug"]
                then
                    DAMN:log(" -> map blacklist checks failed:");
                    DAMN:printList(failed, "    - map [%s] prevents this spawn");
                end

                return false;
            elseif DAMN["spawnerDebug"]
            then
                DAMN:log(" -> map blacklist checks passed");
            end
        end

        if #squareConfig["mapWhitelist"] > 0
        then
            if DAMN["spawnerDebug"]
            then
                DAMN:log(" - checking map whitelist");
            end

            local failed = {};

            --for i, map in ipairs(squareConfig["mapWhitelist"])
			for i=1,#squareConfig["mapWhitelist"]--lect
            do
			map = squareConfig["mapWhitelist"][i]--lect
                if DAMN["spawnerDebug"]
                then
                    DAMN:log("    - checking if map [" .. tostring(map) .."] is loaded");
                end

                if not DAMN:itemIsInArray(maps, map)
                then
                    table.insert(failed, map);
                end
            end

            if #failed > 0
            then
                if DAMN["spawnerDebug"]
                then
                    DAMN:log(" -> map whitelist checks failed:");
                    DAMN:printList(failed, "    - required map [%s] not found");
                end

                return false;
            elseif DAMN["spawnerDebug"]
            then
                DAMN:log(" -> map whitelist checks passed");
            end
        end
    end

    if DAMN["spawnerDebug"]
    then
        DAMN:log(" -> vehicle [" .. tostring(squareConfig["script"]) .. "] is allowed to spawn!");
    end

    return true;
end