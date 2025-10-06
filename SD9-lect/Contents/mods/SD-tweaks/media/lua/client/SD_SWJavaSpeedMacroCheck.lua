----------------
--somewhatfrog--
----------------

local sdLogger = true
local spearFix = true
local swingTime = 0.0
local secondSwingTime = 0.0
local cancels = 0
local cancelTime = 0.0
local speedModSwing = 0
local timer = 10000 --10sec

local function javaSpeedMacroCheck(character, handWeapon)
    local swingAnim = handWeapon:getSwingAnim()
    if handWeapon:isRanged() or swingAnim == "Shove" or character:isAimAtFloor() or character:getStats():getNumChasingZombies() < 1 then return end

    --approximate the amout of swings/minute
    secondSwingTime = swingTime
    swingTime = Calendar.getInstance():getTimeInMillis()
    local interval = swingTime - secondSwingTime
    local swingsPerMinute = 0
    if interval > 0 then
        swingsPerMinute = (60000 / interval)
    end

    --anything above 113 is likely a mod and should be investigated
    if swingsPerMinute > 113 then
        speedModSwing = speedModSwing + 1
        --prevents log spam and excludes theoretical false positives, enough to eventually catch it
        if speedModSwing > 100 then
            --sdLogger (yes please)
            if sdLogger then
                local args = {}
                local zonetier, zonename, x, y = checkZone()
                args.player_name = getOnlineUsername()
                args.player_x = math.floor(x)
                args.player_y = math.floor(y)
                sendClientCommand(character, 'sdLogger', 'SWJavaSpeedMod', args)
            end

            speedModSwing = 0

            --if isDebugEnabled() then
            --    print("SW | speed mod detected")
            --end
        end
    end

    local macroThreshold = 95
    local cancelThreshold = 15
    --local macroThreshold = 83
    --local cancelThreshold = 13
    --if spearFix then
    --    if character:HasTrait("Melee-matician") or character:HasTrait("Paniqeur") then
    --        macroThreshold = 95
    --        cancelThreshold = 15
    --    end
    --end
    --anything above above macroThreshold is a guaranteed cancel with nearly perfect timing, speed cap with any weapon is ~100
    if swingsPerMinute > macroThreshold then
        cancels = cancels + 1
        if not spearFix and swingAnim == "Spear" then
            cancels = 0
        end
        if cancels == 1 then
            cancelTime = swingTime
        end
    end
    --this will only apply to filthy macro/mod abusers and god tier gamers (jokes aside real god tier gamers shoud be proud of achieving this level of precision)
    --landing over 15 cancels in a row within 10 seconds is very unlikely to happen during normal gameplay without macro or java/anim mod and/or forgetting to remove the finger from the button
    --in any case their right hand should be pretty tired from such activity kek
    if (cancelTime + timer) > swingTime then
        if cancels > cancelThreshold then
            local bodyParts = character:getBodyDamage():getBodyParts()
            for i = 0, bodyParts:size() - 1 do
                local bodyPart = bodyParts:get(i)
                if bodyPart:getType() == BodyPartType.Hand_R then
                    --Exercise Fatigue slightly reduces damage and attack speed (no attack speed debuff under 70)
                    bodyPart:setStiffness(69) --69 lasts for about 4 ingame hours
                end
            end

            cancels = 0

            --sdLogger (i don't know why would you want to log this)
            if sdLogger then
                local args = {}
                local zonetier, zonename, x, y = checkZone()
                args.player_name = getOnlineUsername()
                args.player_x = math.floor(x)
                args.player_y = math.floor(y)
                sendClientCommand(character, 'sdLogger', 'SWSpeedMacro', args)
            end
        end
    else
        cancels = 0
    end

    --if isDebugEnabled() then
    --    print("SW | swingsPerMinute: " .. swingsPerMinute)
    --    print("SW | cancels: " .. cancels)
    --end
end


local function OnGameStart()
    if SandboxVars.SD_SWDetect.SD_SWJavaSpeedMacroCheck then
        Events.OnWeaponSwingHitPoint.Add(javaSpeedMacroCheck)

		sdLogger = true

		spearFix = true

    end
end

Events.OnGameStart.Add(OnGameStart)
