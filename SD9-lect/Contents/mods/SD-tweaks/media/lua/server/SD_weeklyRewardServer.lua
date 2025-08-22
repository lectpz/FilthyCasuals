local SD9_SteamIDmark
local SD9_ReceivedRewards
local SD9_timestampMark
local weeklyGlobalRewards
local weeklyFactionRewards
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
end
Events.OnServerStarted.Add(OnServerStarted)

local faction = { "COG", "Ranger", "VoidWalker" }
local function checkControl(city, faction)
	return zones[city][faction] / 1000 >= Zone.list[city][5]
end

local function parseRewards()
	print("[sdLogger] SD9 Reward System Parse Begin")
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
	print("=============================")
	print("GLOBAL KILLS")
	for k,v in pairs(zones) do
		local kills = 0
		if string.match(k,"_global") then
			kills = kills + zones[k]
			if kills >= 50000 then weeklyGlobalRewards.FilthyCasuals = true else weeklyGlobalRewards.FilthyCasuals = false end
		end
		--print(kills)
	end
	print(weeklyGlobalRewards.FilthyCasuals)
	print("=============================")

	print("=============================")
	print("GLOBAL 250k KILLS")
	local globalKills = 0
	for k,v in pairs(zones) do
		if string.match(k,"_global") then
			globalKills = globalKills + zones[k]
		end
		if globalKills >= 250000 then weeklyGlobalRewards.unquenchableThirst = true else weeklyGlobalRewards.unquenchableThirst = false end
	end
	print(weeklyGlobalRewards.unquenchableThirst)
	print("=============================")

	print("=============================")
	print("SWEATY TRYHARD AND CONCERTED EFFORTS T6 KILLS")
	local function checkSweat()
		local t6kills = {}
		t6kills["COG"] = 0
		t6kills["Ranger"] = 0
		t6kills["VoidWalker"] = 0
		for k,v in pairs(zones) do
			if not string.match(k,"_global") then
				if Zone.list[k][5] == 6 then
					--print(k)
					for m,n in pairs(v) do
						--print(" ",m,n)
						t6kills[m]=t6kills[m]+n
					end
					--for k,v in pairs(t6kills) do print(k,v) end
				end
			end
		end
		if t6kills["COG"] > 20000 and t6kills["Ranger"] > 20000 and t6kills["VoidWalker"] > 20000 then
			weeklyGlobalRewards.concertedEfforts = true
		end
		if t6kills["COG"] + t6kills["Ranger"] + t6kills["VoidWalker"] > 80000 then
			weeklyGlobalRewards.SweatyTryhards = true
		end
	end
	checkSweat()
	print(weeklyGlobalRewards.SweatyTryhards)
	print(weeklyGlobalRewards.concertedEfforts)
	print("=============================")


	print("=============================")
	print("LOCAL KILLS")
	for k,v in pairs(zones) do
		if not string.match(k,"_global") then
			local tier = Zone.list[k][5]
			--print(k, tier)
			
			for m,n in pairs(v) do
				--print(" ",m,n)
				if n > tier*1000 then
				--print(m, n, tier*1000)
				weeklyFactionRewards[m.."_T"..tier]=true
				--print(weeklyGlobalRewards[m.."_T"..tier])
				end
			end
		end
	end
	print("=============================")


	print("=============================")
	print("calculate zone notoriety balance")

	for k,v in pairs(zones) do
		if not string.match(k,"_global") then
		--print(k,Zone.list[k][5])
			if checkControl(k,faction[1]) and checkControl(k,faction[2]) and checkControl(k,faction[3]) then
				weeklyGlobalRewards.perfectlyBalanced = true
			else
				weeklyGlobalRewards.perfectlyBalanced = false
				break
			end
		end
	end
	print(weeklyGlobalRewards.perfectlyBalanced)
	print("=============================")

	--need to figure out how to pull all this stuff out as args
	--[[for k,v in pairs(weeklyGlobalRewards) do
		if v then
			print("inv:AddItem(Base.WeeklyGlobalReward_"..k..")")
		end
	end

	for i=1,3 do
		for k,v in pairs(weeklyFactionRewards) do
			if v and string.match(k,faction[i]) then
				print("inv:AddItem(Base.WeeklyFactionReward_"..k..")")
			end
		end
	end]]
	print("[sdLogger] SD9 Reward System Parse End")
end

local function receiveGMD(key, modData)
	if key == "transmit_steamID"	and modData and type(modData)=="table" then
		for steamID, _ in pairs(modData) do
			--if steam id isn't registered, then register and mark with timestamp
			local ts = getTimestamp()
			if not SD9_SteamIDmark[steamID] then SD9_SteamIDmark[steamID] = ts end
			print("[sdLogger] SD9 Reward System -- Steam ID: " .. steamID .. " entered with timestamp " .. ts)
		end
	end
	
	if key == "request_reward"	and modData and type(modData)=="table" then
		for steamID, OnlineID in pairs(modData) do
			--if steam id exists and was created prior to timestamp then proceed with reward
			if SD9_SteamIDmark[steamID] and (SD9_SteamIDmark[steamID] < SD9_timestampMark) then
					--update timestamp
					local ts = getTimestamp()
					SD9_SteamIDmark[steamID] = ts
					--local OnlineID = getPlayer():getOnlineID()
					--send command to client to spawn the rewards
					--args should be the available rewards. args will be a table with 2 nested tables
					local args = { weeklyGlobalRewards, weeklyFactionRewards }
					local clientModule = "SD9_Rewards"
					local clientCommand = "distribute"
					sendServerCommand(getPlayerByOnlineID(OnlineID), clientModule, clientCommand, args)
					print("[sdLogger] SD9 Reward System -- Reward Distributed to Steam ID: " .. steamID .. " -- Marked with new timestamp " .. ts)
			end
		end
	end
	
	if key == "SD9_mark" then
		--set the mark. if the players that exist have a timestamp value less than the timestamp mark, then they will get the reward
		local ts = getTimestamp()
		SD9_timestampMark = ts
		print("[sdLogger] SD9 Reward System -- Marked rewards at timestamp: " .. ts)
		--parse rewards, which will mark the rewards and reset the global kill counter
		parseRewards()
	end
end
if isServer() then Events.OnReceiveGlobalModData.Add(receiveGMD) end