----------------
--somewhatfrog--
----------------

local sdLogger = false
local hits = 0
local overheads = 0

local function javaSpearCheck(character, handWeapon)
    local swingAnim = handWeapon:getSwingAnim()
    if handWeapon:isRanged() or swingAnim == "Shove" or character:isAimAtFloor() then return end

    --narrow down to actual spear attacks on zombies
    local attackType = character:getAttackType()
    if swingAnim == "Spear" and attackType ~= "miss" then
        hits = hits + 1
        --spearlock counter
        if attackType == "overhead" then
            overheads = overheads + 1
        end

        --java mod works by increasing the minimum distance to another zombie to 100 tiles
        --ain't no way there is so many so so lonely zombies for a false positive
        --1000 hits requirement might be overkill
        if hits > 1000 and overheads == 0 then
            --sdLogger (you probably want to log this data)
            if sdLogger then
                local args = {}
                local zonetier, zonename, x, y = checkZone()
                args.player_name = getOnlineUsername()
                args.player_x = math.floor(x)
                args.player_y = math.floor(y)
                sendClientCommand(character, 'sdLogger', 'SWJavaSpearMod', args)
            end

            hits = 0
            overheads = 0
        end

        --if isDebugEnabled() then
        --    print("SW | hits: " .. hits)
        --    print("SW | overheads: " .. overheads)
        --end
    end
end

Events.OnWeaponSwingHitPoint.Add(javaSpearCheck)


local function OnGameStart()
    local activatedMods = getActivatedMods()
    if activatedMods:contains("SD6_tweaks") or activatedMods:contains("SD6_tweakstest") then
        sdLogger = true
    end
end

Events.OnGameStart.Add(OnGameStart)
