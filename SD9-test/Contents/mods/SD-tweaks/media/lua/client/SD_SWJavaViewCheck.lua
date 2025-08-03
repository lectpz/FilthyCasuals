----------------
--somewhatfrog--
----------------

local sdLogger = false

--EveryHours should be more than enough to eventually catch it, spottedList can get pretty big
local function javaViewCheck()
    local character = getSpecificPlayer(0)
    if character then
        local spottedList = character:getSpottedList()
        if spottedList then
            for i = 0, spottedList:size() - 1 do
                local spottedZombie = spottedList:get(i)
                --visible zombies behind the character further than 8 tiles (keen hearing is 5-6 tiles)
                if instanceof(spottedZombie, "IsoZombie") and spottedZombie:isBehind(character) and spottedZombie:DistToSquared(character) > 64 then
                    --sdLogger
                    if sdLogger then
                        local args = {}
                        local zonetier, zonename, x, y = checkZone()
                        args.player_name = getOnlineUsername()
                        args.player_x = math.floor(x)
                        args.player_y = math.floor(y)
                        sendClientCommand(character, 'sdLogger', 'SWJavaViewMod', args)
                    end

                    --if isDebugEnabled() then
                    --    print("SW | 360 detected")
                    --end

                    break
                end
            end
        end
    end
end


local function OnGameStart()
    if SandboxVars.SD_SWDetect.SD_SWJavaViewCheck then
        Events.EveryHours.Add(javaViewCheck)

        local activatedMods = getActivatedMods()
        if activatedMods:contains("SD6_tweaks") or activatedMods:contains("SD6_tweakstest") then
            sdLogger = true
        end
    end
end

Events.OnGameStart.Add(OnGameStart)
