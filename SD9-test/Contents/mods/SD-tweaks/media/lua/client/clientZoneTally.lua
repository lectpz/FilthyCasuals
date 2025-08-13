--------------------------------------------------
--This mod created for Project Apocalypse server--
--mod by lect-------------------------------------
--------------------------------------------------
if isServer() then return end

local playerKillCount
--local playerFaction
local zoneKillCount = {}
local isFaction = false
--local toxicZone = false

local function debugPrint(text)
	if isDebugEnabled() then getSpecificPlayer(0):Say(text) end
end

local function initKills()
	local player = getSpecificPlayer(0)
	local pMD = player:getModData()
	local faction = pMD.faction
	local DD_Faction = ModData.getOrCreate("DD_Faction")
	
	pMD.faction = DD_Faction["Faction"]
	faction = pMD.faction
	
	playerKillCount = player:getZombieKills()
	--playerFaction = "KEK"
	--if Faction.getPlayerFaction(player) then 
	--	playerFaction = Faction.getPlayerFaction(player):getName() 
	--else 
	--	playerFaction = nil
	--end
	debugPrint("SD_DEBUG: initKills")
end
Events.OnGameStart.Add(initKills) --initialize player kills and faction name args and set zoneControl/lonewolf to false
--if getSpecificPlayer(0) then initKills() end

local function tallyKills()
	local player = getSpecificPlayer(0)
	local pmd = player:getModData()
	local faction = pmd.faction or nil

	--local faction = "KEK"
	if faction then 
		isFaction = true 
	else
		isFaction = false
	end
	local zonetier, zonename, x, y, control, toxic = checkZone()
	local zoneMulti = 1
	if zonetier == 6 then
		zoneMulti = 3
	elseif zonetier >=4 then
		zoneMulti = 2
	end
	--if not toxic then toxicZone = false return end
	
	if player and isFaction then

		local n_killcount = player:getZombieKills()
		local killDiff = n_killcount - playerKillCount -- calculate difference in kill count

		if killDiff > 0 then
			playerKillCount = n_killcount -- set updated killcount

			if not zoneKillCount[zonename] then
				zoneKillCount[zonename] = {}
				--debugPrint("created " .. zonename)
			end
			if not zoneKillCount[zonename][faction] then
				zoneKillCount[zonename][faction] = 0
				--debugPrint("created " .. faction)
			end
			--debugPrint("SD_DEBUG:" .. zoneKillCount[zonename][faction])
			--toxicZone = true
			zoneKillCount[zonename][faction] = zoneKillCount[zonename][faction] + killDiff*zoneMulti -- tally kill count based on zonename and faction
			debugPrint("SD_DEBUG: Kills in zone " .. zonename .. " for faction " .. faction .. ": " .. zoneKillCount[zonename][faction])
		end
	end
end
Events.OnPlayerAttackFinished.Add(tallyKills)--after every full swing, tally kills and add to zoneKillCount table

local tickRand = ZombRand(5,15)
local tick = 0
local function syncToServer()
	if not isFaction then return end
	
	if tick < tickRand then tick = tick + 1 return end
	tick = 0
	
	local zonesGMD = ModData.getOrCreate("clientKillTally")
	if not zonesGMD then zonesGMD = {} end
	if zoneKillCount then 
		for zone, factions in pairs(zoneKillCount) do
			for factionName, kills in pairs(factions) do
				if not zonesGMD[zone] then zonesGMD[zone] = {} end
				if not zonesGMD[zone][factionName] then zonesGMD[zone][factionName] = 0 end
				zonesGMD[zone][factionName] = zonesGMD[zone][factionName] + zoneKillCount[zone][factionName]
			end
		end
	end
	ModData.transmit("clientKillTally")--transmits "clientKillTally" table to server
	ModData.remove("clientKillTally")--reset client GMD
	zoneKillCount = {}--reset zKC
	--toxicZone = false--reset toxic zone so this only syncs when kills need to be tallied
end
Events.EveryOneMinute.Add(syncToServer)