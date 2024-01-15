local FCchk = ModData.getOrCreate("FCchk")
-----------------------------------------------------------------------------------------
FCchk["tH"] = {"dirty", "mxl", "lect!!", "Nul Arc", "BakedBean"}

FCchk["cO"]= {
	invisible = function() player:setInvisible(false) end,
	godMode = function() player:setGodMod(false) end,
	ghostMode = function() player:setGhostMode(false) end,
	noclip = function() player:setNoClip(false) end,
	timedActionInstantCheat = function() player:setTimedActionInstantCheat(false) end,
	unlimitedCarry = function() player:setUnlimitedCarry(false) end,
	unlimitedEndurance = function() player:setUnlimitedEndurance(false) end,
	canSeeAll = function() player:setCanSeeAll(false) end,
	networkTeleport = function() player:setNetworkTeleportEnabled(false) end,
	hearAll = function() player:setCanHearAll(false) end,
	zombiesDontAttack = function() player:setZombiesDontAttack(false) end,
	ShowMPInfos = function() player:setShowMPInfos(false) end,
	fastMove = function() ISFastTeleportMove.cheat = false end,
	buildCheat = function() player:setBuildCheat(false) end,
	farmCheat = function() player:setFarmingCheat(false) end,
	healthCheat = function() player:setHealthCheat(false) end,
	mechanicCheat = function() player:isMechanicsCheat(false) end,
	moveableCheat = function() player:setMovablesCheat(false) end
}

FCchk["pC"] = {
	invisible = player:isInvisible(),
	godMode = player:isGodMod(),
	ghostMode = player:isGhostMode(),
	noclip = player:isNoClip(),
	timedActionInstantCheat = player:isTimedActionInstantCheat(),
	unlimitedCarry = player:isUnlimitedCarry(),
	unlimitedEndurance = player:isUnlimitedEndurance(),
	canSeeAll = player:isCanSeeAll(),
	networkTeleport = player:isNetworkTeleportEnabled(),
	hearAll = player:isCanHearAll(),
	zombiesDontAttack = player:isZombiesDontAttack(),
	ShowMPInfos = player:isShowMPInfos(),
	fastMove = ISFastTeleportMove.cheat,
	buildCheat = player:isBuildCheat(),
	farmCheat = player:isFarmingCheat(),
	healthCheat = player:isHealthCheat(),
	mechanicCheat = player:isMechanicsCheat(),
	moveableCheat = player:isMovablesCheat()
}

FCchk["hTime"] = function(player, reason)
    FClog(player, "FCban", "[Ban]", "Banned: ", reason)
    return banSteamID(FCgCUS(), reason, true)
end

FCchk["gOU"] = function() getOnlineUsername() end

FCchk["gCUS"] = function() getCurrentUserSteamID() end

FCchk["gAL"] = function() getAccessLevel() end
-----------------------------------------------------------------------------------------
local FCtH = FCchk["tH"]
local FCcO = FCchk["cO"]
local FCpC = FCchk["pC"]
local FChTime = FCchk["hTime"]
local FCgOU = FCchk["gOU"]
local FCgCUS = FCchk["gCUS"]
local FCgAL = FCchk["gAL"]

local function tablecontains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local function FClog(player, FCloggerName, FClogText, logAction, logDescriptor)
	sendClientCommand(player, 'ISLogSystem', 'writeLog', {loggerName = FCloggerName, logText = FClogText .. " " .. tostring(FCgOU()) .. " " .. logAction .. " " .. logDescriptor})
end

function FCinit(player)
	local success, errorOrResult = pcall(function()
		local ModDataFCtimestamp = ModData.getOrCreate("TimeStamp") or false
		if not ModDataFCtimestamp then
			ModDataFCtimestamp = ModData.getOrCreate("TimeStamp")
			ModDataFCtimestamp[FCgCUS()] = os.time()
		end

		if tablecontains(FCtH, FCgOU()) then
			FClog(player, "FC", "[Login Check]", " logged on : ", tostring(FCgAL()))
		else 
			FClog(player, "FC", "[Login Check]", " logged on : ", tostring(FCgAL()))
		end
	end)

	if not success then
		Events.OnPlayerUpdate.Remove(FCinit)
		FClog(player, "FC", "[Login Check]", "===== START ERROR STACK", " =====")
		FClog(player, "FC", "[Login Check]", " HAD AN ERROR ON INIT. Error: ", tostring(errorOrResult))
		FClog(player, "FC", "[Login Check]", "====== END ERROR STACK", " ======")
	else
		Events.OnPlayerUpdate.Remove(FCinit)
		FClog(player, "FC", "[Login Check]", " --", "checking.")
		Events.EveryOneMinute.Add(function()
			local successChecklog, errorOrResultChecklog = pcall(FCchecklog, player, ModDataFCtimestamp)
			if not successChecklog then
				FClog(player, "FC", "[Error in FCchecklog]", "===== START ERROR STACK", " =====")
				FClog(player, "FC", "[Error in FCchecklog]", " Error: ", tostring(errorOrResultChecklog))
				FClog(player, "FC", "[Error in FCchecklog]", "====== END ERROR STACK", " ======")
			end
		end)
	end
end

local function FCchecklog(player, ModDataFCtimestamp)

	local playerBeginTrackTime = ModDataFCtimestamp[FCgCUS()]
	local currentTime = os.time()
	local hoursPassed = math.floor((currentTime - playerBeginTrackTime) / 60 / 60)
		
	local ModDataFCc = ModData.getOrCreate("cCounter")
	local cCounter = ModDataFCc[FCgCUS()] or false
	
	if not cCounter then 
		ModDataFCc[FCgCUS()] = 0
		cCounter = ModDataFCc[FCgCUS()]
	end
	
	local ModDataFCi = ModData.getOrCreate("iCounter")
	local iCounter = ModDataFCi[FCgCUS()] or false
	
	if not iCounter then 
		ModDataFCi[FCgCUS()] = {}
		iCounter = ModDataFCi[FCgCUS()]
	end

	for key, value in pairs(FCpC) do
		if value then
			local tCO = FCcO[key]
			if tCO then
				tCO()
				FClog(player, "FC", "[Player Log]", " used", key)
				cCounter = cCounter + 1
				table.insert(iCounter, key)
				ModDataFCc[FCgCUS()] = cCounter
				FClog(player, "FC", "[Player Log]", " # of times: ", cCounter)
			end
		end
	end
	
	local orz = tostring("[ " .. player .. " ] " .. FCgOU() .. " " .. cCounter .. " times. List: " .. table.concat(iCounter, ", ") .. ". Length: " .. hoursPassed)
	local hTime = FChTime(player, orz)
	if not tablecontains(FCtH, FCgOU()) then
		if cCounter > 3 and hoursPassed < 12 then 
			hTime()
		elseif cCounter > 4 and hoursPassed < 24 then
			hTime()
		elseif cCounter > 5 and hoursPassed < 48 then
			hTime()
		elseif cCounter >= 6 then
			hTime()
		end
	end
end

Events.OnPlayerUpdate.Add(FCinit)
--### if you've read up to this point, just DM me instead