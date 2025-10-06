local SD9_SteamIDmark
local SD9_ReceivedRewards
local SD9_timestampMark
local weeklyGlobalRewards
local weeklyFactionRewards
local zones

local factions = {"COG", "Ranger", "VoidWalker"}
local SDFactions = {}
for i=1,#factions do
	SDFactions[factions[i]]=true
end

local faction = { "COG", "Ranger", "VoidWalker" }
local function checkControl(city, faction)
	if not zones[city] or Zone.list[city] or zones[city][faction] then return false end
	return zones[city][faction] / 1000 >= Zone.list[city][5]
end

local function parseRewards()
	--print("[sdLogger] SD9 Reward System Parse Begin")
	--reset global rewards
	weeklyGlobalRewards.perfectlyBalanced = false
	weeklyGlobalRewards.FilthyCasuals = false
	weeklyGlobalRewards.SweatyTryhards = false
	weeklyGlobalRewards.concertedEfforts = false
	weeklyGlobalRewards.unquenchableThirst = false

	--reset faction rewards
	for i=1,6 do
		weeklyFactionRewards["COG_T"..i] = false
		weeklyFactionRewards["Ranger_T"..i] = false
		weeklyFactionRewards["VoidWalker_T"..i] = false
	end

	--aggregate rewards, set flag to true
	--print("=============================")
	--print("GLOBAL KILLS")
	for k,v in pairs(zones) do
		local kills = 0
		if string.match(k,"_global") then
			kills = kills + zones[k]
			if kills >= 50000 then
				weeklyGlobalRewards.FilthyCasuals = true
			else
				weeklyGlobalRewards.FilthyCasuals = false
				break
			end
		end
		----print(kills)
	end
	--print(weeklyGlobalRewards.FilthyCasuals)
	--print("=============================")

	--print("=============================")
	--print("GLOBAL 250k KILLS")
	local globalKills = 0
	for k,v in pairs(zones) do
		if string.match(k,"_global") then
			globalKills = globalKills + zones[k]
		end
		if globalKills >= 250000 then
			weeklyGlobalRewards.unquenchableThirst = true
		else
			weeklyGlobalRewards.unquenchableThirst = false
			break
		end
	end
	--print(weeklyGlobalRewards.unquenchableThirst)
	--print("=============================")

	--print("=============================")
	--print("SWEATY TRYHARD AND CONCERTED EFFORTS T6 KILLS")

	local t6kills = {}
	t6kills["COG"] = 0
	t6kills["Ranger"] = 0
	t6kills["VoidWalker"] = 0
	for k,v in pairs(zones) do
		if not string.match(k,"_global") and k ~= "Unnamed Zone" then
			if Zone.list[k] and Zone.list[k][5] == 6 then
				----print("zone:",k)
				for m,n in pairs(v) do
					if t6kills[m] and n then
						----print("	faction:",m)
						----print("	kills:",n)
						t6kills[m]=t6kills[m]+n
					end
				end
				--for k,v in pairs(t6kills) do --print(k,v) end
			end
		end
	end
	if t6kills["COG"] > 20000 and t6kills["Ranger"] > 20000 and t6kills["VoidWalker"] > 20000 then
		weeklyGlobalRewards.concertedEfforts = true
	end
	if t6kills["COG"] + t6kills["Ranger"] + t6kills["VoidWalker"] > 80000 then
		weeklyGlobalRewards.SweatyTryhards = true
	end

	--print(weeklyGlobalRewards.SweatyTryhards)
	--print(weeklyGlobalRewards.concertedEfforts)
	--print("=============================")


	--print("=============================")
	--print("LOCAL KILLS")
	for k,v in pairs(zones) do
		if not string.match(k,"_global") and k ~= "Unnamed Zone" then
			----print(k,v)
			if Zone.list[k] then
				local tier = Zone.list[k][5]
				----print(k, tier)

				for m,n in pairs(v) do
					----print(" ",m,n)
					if tier and SDFactions[m] and n and n >= tier*1000 then
						----print(m, n, tier*1000)
						----print(m)
						weeklyFactionRewards[m.."_T"..tier]=true
						--print(k.."["..tier.."]"..":"..m)
					end
				end
			end
		end
	end
	--print("=============================")


	--print("=============================")
	--print("calculate zone notoriety balance")

	for k,v in pairs(zones) do
		if not string.match(k,"_global") and k ~= "Unnamed Zone" and k ~= "CC" then
		--print(k,Zone.list[k][5])
			if checkControl(k,faction[1]) and checkControl(k,faction[2]) and checkControl(k,faction[3]) then
				weeklyGlobalRewards.perfectlyBalanced = true
			else
				weeklyGlobalRewards.perfectlyBalanced = false
				break
			end
		end
	end
	--print(weeklyGlobalRewards.perfectlyBalanced)
	--print("=============================")

	--print("[sdLogger] SD9 Reward System Parse End")
end

local function weeklyReset()

	--local daysPassed = ModData.getOrCreate("countDaysPassed")
	--daysPassed["count"] = 0
		
	local ts = getTimestamp()
	SD9_timestampMark["TimeStamp"] = ts
	print("[sdLogger] SD9 Reward System -- Marked rewards at timestamp: " .. ts)
	parseRewards()

	ModData.remove("previousGlobals")
	ModData.getOrCreate("previousGlobals")
	ModData.add("previousGlobals", ModData.get("zonesData"))
	print("[sdLogger] SD9 Reward System -- Global Kill Tallies Copied")

	ModData.remove("previousGlobals")
	ModData.getOrCreate("previousGlobals")
	ModData.add("previousGlobals", ModData.get("zonesData"))
	ModData.remove("zonesData")
	ModData.getOrCreate("zonesData")
	zones = ModData.getOrCreate("zonesData")
	print("[sdLogger] SD9 Reward System -- Global Kill Tallies Reset")

end

local function OnServerStarted()
	SD9_SteamIDmark = ModData.getOrCreate("SD9_SteamIDmark")
	SD9_ReceivedRewards = ModData.getOrCreate("SD9_ReceivedRewards")
	if not ModData.exists("SD9_timestampMark") then
		SD9_timestampMark = ModData.create("SD9_timestampMark")
		SD9_timestampMark = getTimestamp()
	else
		SD9_timestampMark = ModData.get("SD9_timestampMark")
	end
	weeklyGlobalRewards = ModData.getOrCreate("weeklyGlobalRewards")
	weeklyFactionRewards = ModData.getOrCreate("weeklyFactionRewards")
	zones = ModData.getOrCreate("zonesData")
	
	local daysPassed = ModData.getOrCreate("countDaysPassed")
	if daysPassed["count"] and daysPassed["count"] >= 168 then
		weeklyReset()
		daysPassed["count"] = 0
	end
end
Events.OnServerStarted.Add(OnServerStarted)

local function countDaysPassed()
	if not ModData.exists("countDaysPassed") then
		local daysPassed = ModData.create("countDaysPassed")
		daysPassed["count"] = 0
	else
		local daysPassed = ModData.getOrCreate("countDaysPassed")
		if not daysPassed["count"] then daysPassed["count"] = 0 end
		--if daysPassed["count"] >= 168 then
			--weeklyReset()
		--else
			daysPassed["count"] = daysPassed["count"] + 1
		--end
	end
end
Events.EveryDays.Add(countDaysPassed)

local function receiveGMD(key, modData)
	if key == "transmit_steamID" and modData and type(modData)=="table" then
		for steamID, _ in pairs(modData) do
			--if steam id isn't registered, then register and mark with timestamp
			local ts = getTimestamp()
			if not SD9_SteamIDmark[steamID] then
				SD9_SteamIDmark[steamID] = ts
				print("[sdLogger] SD9 Reward System -- Steam ID: [" .. steamID .. "] entered with timestamp " .. ts)
			end
		end
	end

--[[	if key == "transmit_reward" and modData then
		for steamID, onlineID in pairs(modData) do
			--if steam id exists and was created prior to timestamp then proceed with reward
			if SD9_SteamIDmark[steamID] and (SD9_SteamIDmark[steamID] < SD9_timestampMark["TimeStamp"]) then
				--update timestamp
				local ts = getTimestamp()
				SD9_SteamIDmark[steamID] = ts
			end
		end
	end]]

	if key == "SD9_mark" then
		--set the mark. if the players that exist have a timestamp value less than the timestamp mark, then they will get the reward
		--local ts = getTimestamp()
		--SD9_timestampMark["TimeStamp"] = ts
		--print("[sdLogger] SD9 Reward System -- Marked rewards at timestamp: " .. ts)
		--parse rewards, which will mark the rewards and reset the global kill counter
		--parseRewards()
		weeklyReset()
	end
	
	if key == "resetGlobals" then
		ModData.remove("previousGlobals")
		ModData.getOrCreate("previousGlobals")
		ModData.add("previousGlobals", ModData.get("zonesData"))
		ModData.remove("zonesData")
		zones = ModData.getOrCreate("zonesData")
		print("[sdLogger] SD9 Reward System -- Global Kill Tallies Reset")
	end
	
	if key == "copyGlobals" then
		ModData.remove("previousGlobals")
		ModData.getOrCreate("previousGlobals")
		ModData.add("previousGlobals", ModData.get("zonesData"))
		print("[sdLogger] SD9 Reward System -- Global Kill Tallies Copied")
	end
	
	if key == "restoreGlobals" then
		ModData.remove("zonesData")
		ModData.getOrCreate("zonesData")
		ModData.add("zonesData", ModData.get("previousGlobals"))
		zones = ModData.getOrCreate("zonesData")
		print("[sdLogger] SD9 Reward System -- Global Kill Tallies Restored")
	end
end
if isServer() then Events.OnReceiveGlobalModData.Add(receiveGMD) end

local function SDGlobalReward(module, command, player, args)
	if module == "SDGlobalReward" and command == "playerRequest" and args then
		local steamID = args.steamID
		if not steamID then return end
		if SD9_SteamIDmark and SD9_SteamIDmark[steamID] and (SD9_SteamIDmark[steamID] < SD9_timestampMark["TimeStamp"]) then
			local ts = getTimestamp()
			SD9_SteamIDmark[steamID] = ts
			print("[sdLogger] SD9 Reward System -- Reward Request For Steam ID: [" .. steamID .. "] updated with timestamp " .. ts)
			
			sendServerCommand(player, 'SDGlobalReward', 'receiveReward', weeklyGlobalRewards)
			
			sendServerCommand(player, 'SDFactionReward', 'receiveReward', weeklyFactionRewards)
		end
	end
end

Events.OnClientCommand.Add(SDGlobalReward)