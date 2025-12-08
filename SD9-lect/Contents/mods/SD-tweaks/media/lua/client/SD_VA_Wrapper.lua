local original_HS_GM_ToxicBuildupUpdate = HS_GM_ToxicBuildupUpdate
function HS_GM_ToxicBuildupUpdate(player)
    if not player then return end

    local HeiMD = player:getModData().HeiVenenosusAer
    if not HeiMD then return end

    original_HS_GM_ToxicBuildupUpdate(player)
end