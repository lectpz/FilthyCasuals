----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

local green = " <RGB:" .. getCore():getGoodHighlitedColor():getR() .. "," .. getCore():getGoodHighlitedColor():getG() .. "," .. getCore():getGoodHighlitedColor():getB() .. "> "
local red = " <RGB:" .. getCore():getBadHighlitedColor():getR() .. "," .. getCore():getBadHighlitedColor():getG() .. "," .. getCore():getBadHighlitedColor():getB() .. "> "

local yellow = " <RGB:1,0,0> "
local orange = " <RGB:1,0.5,0> "
local gold = " <RGB:0.83,0.68,0.21> "
local blue = " <RGB:0.2,0.5,1> "
local purple = " <RGB:0.62,0.12,0.94> "

local white = " <RGB:1,1,1> "

-- function to split the sandbox string into a table. my brute force way to bypass the limitations of sandbox var string delimiter. parses the input string and pulls out the everything between spaces.
local function splitString(sandboxvar)
	local ztable = {}
	local pattern = "[^ %;,]+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local args = {}

local function addToArgs(item, amount, soulforged)
	amount = amount or 1
    local newItemKey = "item" .. (#args + 1) 
    args[newItemKey] = args[newItemKey] or {} 
	local sf_txt = ""
	if soulforged == "SoulForged" then sf_txt = "SoulForged " end
    table.insert(args[newItemKey], amount .. "x " .. sf_txt .. item) 
end

local function addItemToPlayer(loot)
	getSpecificPlayer(0):getInventory():AddItem(loot)
	addToArgs(loot)
end

local function addEmptyBoxToPlayer(loot)
	getSpecificPlayer(0):getInventory():AddItem(loot)
	addToArgs(loot)
end

local function addSoulForgedWeaponToPlayer(loot, tierzone)
	local weaponFT = loot
	local scriptItem = ScriptManager.instance:getItem(weaponFT)
	local weapon = InventoryItemFactory.CreateItem(weaponFT)
	MDZ_OnCreate_MeleeWeaponVariance(weapon, true)
	local weaponModData = weapon:getModData()
	local playerObj = getSpecificPlayer(0)
	
	weaponModData.KillCount = 0
	weaponModData.SoulForged = true
	weaponModData.PlayerKills = playerObj:getZombieKills()
	weaponModData.ConditionLowerChance = 1.1
	weaponModData.MaxCondition = 1.1
	
	if tierzone == 6 then
		
		weaponModData.MaxHitCount = weaponModData.MaxHitCount + 1
		weaponModData.Augments = 1
		
		local rng = ZombRand(3)
		
		if rng == 0 then
			
			weaponModData.soulForgeMinDmgMulti = 1.15
			weaponModData.soulForgeCritRate = 1.2
			weaponModData.ConditionLowerChance = weaponModData.ConditionLowerChance * 1.2
			weaponModData.MaxCondition = weaponModData.MaxCondition * 1.2
							
			weaponModData.s2_desc = gold .. "Suffix Modifer: COG" ..
									green .. " <LINE> Max Hit Count +" .. 1 ..
									green .. " <LINE> " .. string.format("%.0f", (1.2*100-100))  .. "% More Weapon Condition Lower Chance <LINE> " ..
									green .. " <LINE> " .. string.format("%.0f", (1.2*100-100))  .. "% More Maximum Weapon Condition <LINE> " ..
									green .. " <LINE> " .. string.format("%.0f", (weaponModData.soulForgeCritRate*100-100))  .. "% More Critical Chance <LINE> " .. 
									green .. " <LINE> " .. string.format("%.0f", (weaponModData.soulForgeMinDmgMulti*100-100))  .. "% More Minimum Damage <LINE> "
			
			weaponModData.suffix2 = "COG"
			
			weapon:setCriticalChance(weaponModData.CriticalChance * weaponModData.soulForgeCritRate)
			weapon:setMinDamage(weaponModData.MinDamage * weaponModData.soulForgeMinDmgMulti)
			
		elseif rng == 1 then
		
			weaponModData.soulForgeMaxDmgMulti = 1.15
			weaponModData.soulForgeCritRate = 1.2
			weaponModData.ConditionLowerChance = weaponModData.ConditionLowerChance * 1.2
			weaponModData.MaxCondition = weaponModData.MaxCondition * 1.2
		
			weaponModData.s2_desc = gold .. "Suffix Modifer: Voidwalker" ..
									green .. " <LINE> Max Hit Count +" .. 1 ..
									green .. " <LINE> " .. string.format("%.0f", (1.2*100-100))  .. "% More Weapon Condition Lower Chance <LINE> " ..
									green .. " <LINE> " .. string.format("%.0f", (1.2*100-100))  .. "% More Maximum Weapon Condition <LINE> " ..
									green .. " <LINE> " .. string.format("%.0f", (weaponModData.soulForgeCritRate*100-100))  .. "% More Critical Chance <LINE> " .. 
									green .. " <LINE> " .. string.format("%.0f", (weaponModData.soulForgeMaxDmgMulti*100-100))  .. "% More Maximum Damage <LINE> "
			
			weaponModData.suffix2 = "Voidwalker"
			
			weapon:setCriticalChance(weaponModData.CriticalChance * weaponModData.soulForgeCritRate)
			weapon:setMinDamage(weaponModData.MaxDamage * weaponModData.soulForgeMaxDmgMulti)
			
		elseif rng == 2 then
		
			weaponModData.soulForgeCritRate = 1.2
			weaponModData.soulForgeCritMulti = 1.2
			weaponModData.ConditionLowerChance = weaponModData.ConditionLowerChance * 1.2
			weaponModData.MaxCondition = weaponModData.MaxCondition * 1.2
			
			weaponModData.s2_desc = gold .. "Suffix Modifer: Ranger" ..
									green .. " <LINE> Max Hit Count +" .. 1 ..
									green .. " <LINE> " .. string.format("%.0f", (1.2*100-100))  .. "% More Weapon Condition Lower Chance <LINE> " ..
									green .. " <LINE> " .. string.format("%.0f", (1.2*100-100))  .. "% More Maximum Weapon Condition <LINE> " ..
									green .. " <LINE> " .. string.format("%.0f", (weaponModData.soulForgeCritRate*100-100))  .. "% More Critical Chance <LINE> " .. 
									green .. " <LINE> " .. string.format("%.0f", (weaponModData.soulForgeCritMulti*100-100))  .. "% More Critical Damage Multiplier <LINE> "
			
			weaponModData.suffix2 = "Ranger"
			
			weapon:setCriticalChance(weaponModData.CriticalChance * weaponModData.soulForgeCritRate)
			weapon:setCritDmgMultiplier(weaponModData.CritDmgMultiplier * weaponModData.soulForgeCritMulti)
			
		end
		weapon:setMaxHitCount(weaponModData.MaxHitCount)
	end
	
	local mdzPrefix = ""
	if weaponModData.mdzPrefix then mdzPrefix = weaponModData.mdzPrefix .. " " end
	
	local suffix = ""
	if weaponModData.suffix2 then suffix = " of the " .. weaponModData.suffix2 end
	
	weaponModData.Name = "Soul Forged " .. scriptItem:getDisplayName() .. suffix
	
	weapon:setName(mdzPrefix .. weaponModData.Name)
	weapon:setConditionLowerChance(scriptItem:getConditionLowerChance() * weaponModData.ConditionLowerChance)
	weapon:setConditionMax(scriptItem:getConditionMax() * weaponModData.MaxCondition)

	playerObj:getInventory():AddItem(weapon)
	addToArgs(loot, 1, "SoulForged")
end

function globalRewardCache(items, result, player, rewardType)
	local zonetier, zonename, x, y, control, toxic = checkZone()

	local reward = splitString(SandboxVars.SDGlobalRewards[rewardType])

	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "GLobal Reward Cache - " .. rewardType,
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	for i=1,#reward do
		addItemToPlayer(reward[i])
	end
end

function factionRewardCache(items, result, player, rewardType)
	local zonetier, zonename, x, y, control, toxic = checkZone()

	local reward = splitString(SandboxVars.SDGlobalRewards[rewardType])

	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "Faction Reward Cache - " .. rewardType,
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	for i=1,#reward do
		addItemToPlayer(reward[i])
	end
end

local gRewardTypes = {
	"perfectlyBalanced",
	"FilthyCasuals",
	"SweatyTryhards",
	"concertedEfforts",
	"unquenchableThirst",
	}

GlobalReward = {}
for i=1,#gRewardTypes do
	GlobalReward[gRewardTypes[i]] = function(items, result, player)
		globalRewardCache(items, result, player, gRewardTypes[i])
	end
end


FactionReward = {}
for i=1,6 do
	FactionReward["T"..i] = function(items, result, player)
		factionRewardCache(items, result, player, "T"..i)
	end
end

FactionForgedWeapon = {}
for i=1,5 do
	FactionForgedWeapon["T"..i] = function(items, result, player)
		local zonetier, zonename, x, y, control, toxic = checkZone()
		
		local rmw = {}
		for j=1,5 do
			rmw["table"..j] = splitString(SandboxVars.RWC["table"..j])
		end
				
		args = {
		  player_name = getOnlineUsername(),
		  cachetype = "T"..i.." Faction-Forged Weapon Cache",
		  player_x = math.floor(x),
		  player_y = math.floor(y),
		  zonename = zonename,
		  zonetier = zonetier,
		}
		
		--addItemToPlayer(table5[t5])
		addSoulForgedWeaponToPlayer(rmw["table"..i][ZombRand(#rmw["table"..i])+1], 6)
		
		sendClientCommand(player, 'sdLogger', 'OpenCache', args);
		player:getEmitter():playSoundImpl("s_zeldaitem", nil)
	end
end