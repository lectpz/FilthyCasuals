local SD9_SteamIDmark
local SD9_timestampMark
local sendGlobalRewards
local sendFactionRewards
local SD9_GlobalRewardKillCount = ModData.getOrCreate("SD9_GlobalRewardKillCount")

local args = {}

local function addToArgs(item, amount, itemname)
	local item = itemname or item
	amount = amount or 1
    local newItemKey = "item" .. (#args + 1) 
    args[newItemKey] = args[newItemKey] or {}  
    table.insert(args[newItemKey], amount .. "x " .. item) 
end

local function addItemsToPlayer(loot, amount)
	getSpecificPlayer(0):getInventory():AddItems(loot, amount)
	addToArgs(loot, amount)
end

local function addItemToPlayer(loot)
	getSpecificPlayer(0):getInventory():AddItem(loot)
	addToArgs(loot)
end

Events.OnGameStart.Add(function()
							local transmit_steamID = ModData.getOrCreate("transmit_steamID")	
							transmit_steamID[getCurrentUserSteamID()] = true
							ModData.transmit("transmit_steamID")
						end)

local function SDGlobalReward(module, command, sendGlobalRewards)
	if module == "SDGlobalReward" and command == "receiveReward" and sendGlobalRewards and type(sendGlobalRewards)=="table" then
		local player = getSpecificPlayer(0)
		local faction = player:getModData().faction
		
		local zonetier, zonename, x, y = checkZone()
		args = {
		  player_name = getOnlineUsername(),
		  cachetype = "Global Reward",
		  player_x = math.floor(x),
		  player_y = math.floor(y),
		  zonename = zonename,
		  zonetier = zonetier,
		}

		if faction == "COG" or faction == "Ranger" or faction == "VoidWalker" then
			for k,v in pairs(sendGlobalRewards) do
				if v then addItemToPlayer("Base."..k) end
			end

			sendClientCommand(player, 'sdLogger', 'OpenCache', args);
		end
	end
	
	if module == "SDGlobalReward" and command == "tallyPlayerKills" and args then
		SD9_GlobalRewardKillCount = args.totalPlayerKills
	end
end

local factionToken = {}
factionToken["Ranger"] 		= "Base.rangerToken"
factionToken["VoidWalker"] 	= "Base.vwToken"
factionToken["COG"] 		= "Base.cogToken"

local function SDFactionReward(module, command, sendFactionRewards)
	if module == "SDFactionReward" and command == "receiveReward" and sendFactionRewards and type(sendFactionRewards)=="table" then
		local player = getSpecificPlayer(0)
		local faction = player:getModData().faction
		
		local zonetier, zonename, x, y = checkZone()
		args = {
		  player_name = getOnlineUsername(),
		  cachetype = "Faction Reward",
		  player_x = math.floor(x),
		  player_y = math.floor(y),
		  zonename = zonename,
		  zonetier = zonetier,
		}
		
		if faction == "COG" or faction == "Ranger" or faction == "VoidWalker" then
			for i=1,6 do 
				if sendFactionRewards[faction.."_T"..i] then
					addItemToPlayer("Base.FactionRewardT"..i)
					addItemToPlayer(factionToken[faction])
					sendClientCommand(player, 'sdLogger', 'OpenCache', args);
				end
			end
		end
		
	end
end

if not isServer() then Events.OnServerCommand.Add(SDGlobalReward) end
if not isServer() then Events.OnServerCommand.Add(SDFactionReward) end

local function requestReward(player)
	if isInSafeHouse or isInCC then
		local sdargs = {}
		sdargs.steamID = getCurrentUserSteamID()
		sendClientCommand(getSpecificPlayer(0), 'SDGlobalReward', 'playerRequest', sdargs)
		Events.OnPlayerMove.Remove(requestReward)
	end
end
Events.OnPlayerMove.Add(requestReward)