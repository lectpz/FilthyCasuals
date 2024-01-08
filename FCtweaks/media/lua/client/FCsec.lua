local FCadminlist = ModData.getOrCreate("FCadmins")
FCadminlist["admins"] = {"dirty", "mxl", "lect!!", "Nul Arc", "BakedBean"}

local FCadmins = FCadminlist["admins"]

local function tablecontains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local function FClog(player, FCloggerName, FClogText, logAction, logDescriptor)
	sendClientCommand(player, 'ISLogSystem', 'writeLog', {loggerName = FCloggerName, logText = FClogText .. " " .. tostring(getOnlineUsername()) .. " " .. logAction .. " " .. logDescriptor})
end

function FCinit(player)
	local FCaccess
	local success, errorOrResult = pcall(function()

		local ModDataFCaccess = ModData.getOrCreate("LoginAccessCheck")
		local ModDataFCtimestamp = ModData.getOrCreate("TimeStamp") or false
		if not ModDataFCtimestamp then
			ModDataFCtimestamp[getCurrentUserSteamID()] = os.time()
		end
		
		if tablecontains(FCadmins, getOnlineUsername()) then
			ModDataFCaccess[getCurrentUserSteamID()] = "Filthy Casual"
			FCaccess = ModDataFCaccess[getCurrentUserSteamID()]
			FClog(player, "FC", "[Login Check]", " logged on with privilege: ", tostring(getAccessLevel()))
		elseif getAccessLevel() ~= "player" then
			ModDataFCaccess[getCurrentUserSteamID()] = false
			FCaccess = ModDataFCaccess[getCurrentUserSteamID()]
			FClog(player, "FC", "[Login Check]", " logged on with unauthorized privilege: ", tostring(getAccessLevel()))
		else 
			ModDataFCaccess[getCurrentUserSteamID()] = false
			FCaccess = ModDataFCaccess[getCurrentUserSteamID()]
			FClog(player, "FC", "[Login Check]", " logged on as a ", tostring(getAccessLevel()))
		end
	end)

	if not success then
		Events.OnPlayerUpdate.Remove(FCinit)
		FClog(player, "FC", "[Login Check]", "------------------ START ERROR STACK", " -----------------------")
		FClog(player, "FC", "[Login Check]", " HAD AN ERROR ON INIT. NO PRIVILEGES WERE LOGGED. Error: ", tostring(errorOrResult))
		FClog(player, "FC", "[Login Check]", "------------------- END ERROR STACK", " ------------------------")
	else
		Events.OnPlayerUpdate.Remove(FCinit)
		if not FCaccess then
			FClog(player, "FC", "[Login Check]", " --", "checking for privileged actions.")
			Events.EveryOneMinute.Add(function()
				local successChecklog, errorOrResultChecklog = pcall(FCchecklog, player, ModDataFCtimestamp)
				if not successChecklog then
					FClog(player, "FC", "[Error in FCchecklog]", "----------------- START ERROR STACK", " ----------------------")
					FClog(player, "FC", "[Error in FCchecklog]", " HAD AN ERROR ON FCchecklog. Error: ", tostring(errorOrResultChecklog))
					FClog(player, "FC", "[Error in FCchecklog]", "------------------ END ERROR STACK", " -----------------------")
				end
			end)
		end
	end
	

end

local function FCchecklog(player)

	local playerBeginTrackTime = ModDataFCtimestamp[getCurrentUserSteamID()]
	local currentTime = os.time()
	local hoursPlayed = math.floor((currentTime - playerBeginTrackTime) / 60 / 60)
		
	local cheatsOff = {
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

	local playerCheats = {
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

	local ModDataFCcheater = ModData.getOrCreate("cheatCounterFC")
	local cheatCounter = ModDataFCcheater[getCurrentUserSteamID()] or false
	
	if not cheatCounter then 
		ModDataFCcheater[getCurrentUserSteamID()] = 0
	end

	for key, value in pairs(playerCheats) do
		if value then
			local turnCheatOff = cheatsOff[key]
			if turnCheatOff then
				turnCheatOff()
				FClog(player, "FC", "[Player Action Log]", key, " detected and turned off.")
				cheatCounter = cheatCounter + 1
				ModDataFCcheater[getCurrentUserSteamID()] = cheatCounter
				FClog(player, "FC", "[Player Action Log]", "caught cheating # of times: ", cheatCounter)
			end
		end
	end
	
	local cheatReason = tostring("[ " .. player .. " ] " .. getOnlineUsername() .. " detected cheating " .. cheatCounter .. " times using: " .. table.concat(infraction, ", ") .. ". Total hours played: " .. hoursPlayed)
	local banhammer = function()
		FClog(player, "FCban", "[Ban]", "Banned: ", cheatReason)
		return banSteamID(getCurrentUserSteamID(), cheatReason, true)
	end
	if cheatCounter > 2 and hoursPlayed < 12 then 
		banhammer()
	elseif cheatCounter > 4 and hoursPlayed < 24 then
		banhammer()
	elseif cheatCounter > 5 and hoursPlayed < 48 then
		banhammer()
	elseif cheatCounter >= 6 then
		banhammer()
	end
end

Events.OnPlayerUpdate.Add(FCinit)