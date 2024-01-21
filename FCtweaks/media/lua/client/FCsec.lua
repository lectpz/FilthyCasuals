local FCtH = {"dirty", "mxl", "lect!!", "Nul Arc", "BakedBean", "lect"}

local FCcO = {
	invisible = function(player) player:setInvisible(false) end,
	godMode = function(player) player:setGodMod(false) end,
	ghostMode = function(player) player:setGhostMode(false) end,
	noclip = function(player) player:setNoClip(false) end,
	timedActionInstantCheat = function(player) player:setTimedActionInstantCheat(false) end,
	unlimitedCarry = function(player) player:setUnlimitedCarry(false) end,
	unlimitedEndurance = function(player) player:setUnlimitedEndurance(false) end,
	canSeeAll = function(player) player:setCanSeeAll(false) end,
	networkTeleport = function(player) player:setNetworkTeleportEnabled(false) end,
	hearAll = function(player) player:setCanHearAll(false) end,
	zombiesDontAttack = function(player) player:setZombiesDontAttack(false) end,
	ShowMPInfos = function(player) player:setShowMPInfos(false) end,
	buildCheat = function(player) player:setBuildCheat(false) end,
	farmCheat = function(player) player:setFarmingCheat(false) end,
	healthCheat = function(player) player:setHealthCheat(false) end,
	mechanicCheat = function(player) player:setMechanicsCheat(false) end,
	moveableCheat = function(player) player:setMovablesCheat(false) end
}

local FCpC = {
    invisible = function(player) return player:isInvisible() end,
    godMode = function(player) return player:isGodMod() end,
    ghostMode = function(player) return player:isGhostMode() end,
    noclip = function(player) return player:isNoClip() end,
    timedActionInstantCheat = function(player) return player:isTimedActionInstantCheat() end,
    unlimitedCarry = function(player) return player:isUnlimitedCarry() end,
    unlimitedEndurance = function(player) return player:isUnlimitedEndurance() end,
    canSeeAll = function(player) return player:isCanSeeAll() end,
    networkTeleport = function(player) return player:isNetworkTeleportEnabled() end,
    hearAll = function(player) return player:isCanHearAll() end,
    zombiesDontAttack = function(player) return player:isZombiesDontAttack() end,
    ShowMPInfos = function(player) return player:isShowMPInfos() end,
    buildCheat = function(player) return player:isBuildCheat() end,
    farmCheat = function(player) return player:isFarmingCheat() end,
    healthCheat = function(player) return player:isHealthCheat() end,
    mechanicCheat = function(player) return player:isMechanicsCheat() end,
    moveableCheat = function(player) return player:isMovablesCheat() end
}

local function FClog(player, FCloggerName, FClogText, logAction, logDescriptor)
	sendClientCommand(player, 'ISLogSystem', 'writeLog', {loggerName = FCloggerName, logText = FClogText .. " " .. tostring(getOnlineUsername()) .. " " .. logAction .. " " .. logDescriptor})
end

--FCchk["hTime"] = function(player, reason)
local function hTime(player, reason)
    FClog(player, "FCban", "[Ban]", "Banned: ", reason)
    banSteamID(getCurrentUserSteamID(), reason, true)
end

local function tablecontains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local function FCchecklog()
	local player = getPlayer()
		
	local ModDataFCc = ModData.getOrCreate("cCounter")
	local cCounter = ModDataFCc[getCurrentUserSteamID()] or 0
	
	if cCounter == 0 then 
		ModDataFCc[getCurrentUserSteamID()] = 0
		cCounter = ModDataFCc[getCurrentUserSteamID()]
	end
	
	for key, value in pairs(FCpC) do
		if value(player) and not tablecontains(FCtH, getOnlineUsername()) then
			local tCO = FCcO[key]
			if tCO then
				tCO(player)
				FClog(player, "FC", "[Player Log]", " used", key)
				cCounter = cCounter + 1
				ModDataFCc[getCurrentUserSteamID()] = cCounter
				FClog(player, "FC", "[Player Log]", " # of times: ", cCounter)
			end
		end
	end
	
    local orz = tostring("[ " .. getOnlineUsername() .. " ] " .. cCounter .. " times.")
    if not tablecontains(FCtH, getOnlineUsername()) then
        if cCounter > 3 then 
            hTime(player, orz)
        end
	--else
		--FClog(player, "FC", "[hTime]", " # of times: ", cCounter)
    end
end

function FCinit(player)
	local player = player
	local success, errorOrResult = pcall(function()
		local ModDataFCtimestamp = ModData.getOrCreate("TimeStamp") or false
		if not ModDataFCtimestamp then
			ModDataFCtimestamp = ModData.getOrCreate("TimeStamp")
			ModDataFCtimestamp[getCurrentUserSteamID()] = os.time()
		end

		if tablecontains(FCtH, getOnlineUsername()) then
			FClog(player, "FC", "[Login Check]", " logged on : ", getAccessLevel())
		else 
			FClog(player, "FC", "[Login Check]", " logged on : ", getAccessLevel())
		end
	end)

	if not success then
		Events.OnPlayerUpdate.Remove(FCinit)
		FClog(player, "FC", "[Login Check]", "===== START ERROR STACK", " =====")
		FClog(player, "FC", "[Login Check]", " HAD AN ERROR ON INIT. Error: ", tostring(errorOrResult))
		FClog(player, "FC", "[Login Check]", "====== END ERROR STACK", " ======")
	else
		Events.OnPlayerUpdate.Remove(FCinit)
		--FCchecklog()
		if not tablecontains(FCtH, getOnlineUsername()) then
			--return
			Events.EveryOneMinute.Add(FCchecklog)
		else
			--Events.EveryOneMinute.Add(FCchecklog)
		end
	end
end

Events.OnPlayerUpdate.Add(FCinit)