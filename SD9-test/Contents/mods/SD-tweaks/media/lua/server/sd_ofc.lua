if isClient() then return end

local proceduralContainer = {}

local function initProceduralContainer()
	proceduralContainer["ArmyStorageAmmunition"]="Army"
	proceduralContainer["ArmyStorageGuns"]="Army"
	proceduralContainer["ArmySurplusMisc"]="Army"
	proceduralContainer["LockerArmyBedroom"]="Army"
	proceduralContainer["BarCounterWeapon"]="Weapon"
	proceduralContainer["DrugLabGuns"]="Weapon"
	proceduralContainer["FirearmWeapons"]="Weapon"
	proceduralContainer["GunStoreAmmunition"]="Weapon"
	proceduralContainer["GunStoreCounter"]="Weapon"
	proceduralContainer["GunStoreDisplayCase"]="Weapon"
	proceduralContainer["GunStoreMagazineRack"]="Weapon"
	proceduralContainer["GunStoreShelf"]="Weapon"
	proceduralContainer["Hunter"]="Weapon"
	proceduralContainer["HuntingLockers"]="Weapon"
	proceduralContainer["MeleeWeapons"]="Weapon"
	proceduralContainer["PawnShopCases"]="Weapon"
	proceduralContainer["PawnShopGuns"]="Weapon"
	proceduralContainer["PawnShopGunsSpecial"]="Weapon"
	proceduralContainer["PawnShopKnives"]="Weapon"
	proceduralContainer["PlankStashGun"]="Weapon"
	proceduralContainer["SurvivalGear"]="Weapon"
	proceduralContainer["PoliceDesk"]="Police"
	proceduralContainer["PoliceEvidence"]="Police"
	proceduralContainer["PoliceLockers"]="Police"
	proceduralContainer["PoliceStorageAmmunition"]="Police"
	proceduralContainer["PoliceStorageGuns"]="Police"
	proceduralContainer["PoliceStorageOutfit"]="Police"
	proceduralContainer["PrisonGuardLockers"]="Police"
	proceduralContainer["SecurityLockers"]="Police"
end
initProceduralContainer()

local function splitString(_string)
	local ztable = {}
	local pattern = "[^ %;,]+"

	for match in _string:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local lootTable = {}
local lootCategories = { "Weapon", "Gun", "Police", "Army",}-- "Medical", "Tool", "Mechanic", "Metalwork" }
for i=1, #lootCategories do
	lootTable[lootCategories[i]] = {}
end

local function initWeapons()
	for i=1,4 do
		lootTable[lootCategories[i]]["T1"] = splitString(SandboxVars.RWC.table1)
		lootTable[lootCategories[i]]["T2"] = splitString(SandboxVars.RWC.table2)
		lootTable[lootCategories[i]]["T3"] = splitString(SandboxVars.RWC.table3)
		lootTable[lootCategories[i]]["T4"] = splitString(SandboxVars.RWC.table4)
		lootTable[lootCategories[i]]["T5"] = splitString(SandboxVars.RWC.table5)
		--print("LootTable: ", lootCategories[i])
	end
end
--Events.OnInitGlobalModData.Add(initWeapons)
--Events.EveryTenMinutes.Add(initWeapons)

local function delimit(_string)
	local ztable = {}
	local pattern = "[^ {},=]+"
	local _string = tostring(_string)

	for match in _string:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local ofc_bID = {}
local bID_flag = false

local function getPlayerBIDS()
	ofc_bID = {}
	local online_players = getOnlinePlayers();


	if online_players
	then
		for i = 0, online_players:size() - 1
		do
			local player = online_players:get(i);
			
			
			if player and not player:isAccessLevel("admin")
			then
				local playerBldg = player:getCurrentBuilding()
				if playerBldg then ofc_bID[playerBldg:getID()] = true end
			end
		end
	end
end

local clearCounter = 0
local function clearFlag()
	clearCounter = clearCounter + 1
	if clearCounter > 1 then
		clearCounter = 0
		bID_flag = false
	end
end
--Events.EveryOneMinute.Add(clearFlag)

SD_bSpawned = {}
local function SD_bSpawnedClear()
	SD_bSpawned = {}
end
--Events.EveryDays.Add(SD_bSpawnedClear)

local function spawnBldgZombies(bDef, bldgID, tier)
	if bDef and not SD_bSpawned[bldgID] then
		--bDef:setAllExplored(false)
		--bDef:setHasBeenVisited(false)
		SD_bSpawned[bldgID] = true
		
		local ztier = 45 --6x6
		if tier == 6 then
			ztier = 25 --3x3
		elseif tier == 5 then
			ztier = 30 --3x3
		elseif tier == 4 then
			ztier = 35 --4x4
		elseif tier == 3 then
			ztier = 40 --5x5
		end
		
		local bRooms = bDef:getRooms()
		for i=0, bRooms:size()-1 do
			local rDef = bRooms:get(i)
			--rDef:setExplored(false)
			local spawnDensity = math.ceil(rDef:getArea()/ztier)
			VirtualZombieManager.instance:addZombiesToMap(spawnDensity, rDef, false)
		end
	end
end

local function onFillContainer(_roomName, _containerType, container)
	if instanceof(container:getParent(), "BaseVehicle") then return end
	
	local sq = container:getSourceGrid()
	if not sq then return end
	
	local SafeHouseSQ = SafeHouse.getSafeHouse(sq)
	--SafeHouseSQ = true
	if SafeHouseSQ then return end
	
	local sq_room = sq:getRoom()
	if not sq_room then return end
	
	local building = sq:getBuilding()
	local bldgID = building:getID()
	
	if sd_bID[bldgID] then return end
	
	if not bID_flag then
		getPlayerBIDS()
		bID_flag = true
	end
	if ofc_bID[bldgID] then return end
	
	local sq_roomDef = sq_room:getRoomDef()
	if not sq_roomDef then return end
	
	if not sq_roomDef:isExplored() then return end
	
	local sq_procedural = sq_roomDef:getProceduralSpawnedContainer()
	if not sq_procedural then return end
	
	local x = sq:getX()
	local y = sq:getY()

	local tier, zone, x, y, control, toxic = checkZoneAtXY(x,y)
	if tier == 1 then return end
	
	local hashMap = sq_procedural
	local hashString = delimit(hashMap)
	--print(hashMap)
	
	for i=1,#hashString,2 do
		--print(hashString[i] .. "=" .. hashString[i+1])
		if hashString[i+1] == "1" then
			local numToSpawn = math.ceil(tier/3)
			local containerClass = proceduralContainer[hashString[i]]
			if lootTable[containerClass] then
				local bDef = building:getDef()
				--[[if bDef and not SD_bSpawned[bldgID] then
					SD_bSpawned[bldgID] = true
					--local bH, bW = bDef:getH(), bDef:getW()
					--local bArea = bDef:getH() * bDef:getW()
					--local x1,y1,x2,y2 = bDef:getX(), bDef:getY(), bDef:getX2(), bDef:getY2()
					--local spawnDensity = math.ceil(bArea/9) --one zombie per 3x3 squares
					--VirtualZombieManager.instance:createHordeFromTo(x1,y1,x2,y2,spawnDensity)
					
					--local x1, y1, x2, y2 = bDef:getX(), bDef:getY(), bDef:getX2(), bDef:getY2()
					--print(x1)
					--print(y1)
					--print(x2)
					--print(y2)

					--local squareSize = 1

					--for x=x1, x2, squareSize do
						--for y=y1, y2, squareSize do
							--VirtualZombieManager.instance:createHordeFromTo(x,y,x,y,2)
						--end
					--end
					local bRooms = bDef:getRooms()
					for i=0, bRooms:size()-1 do
						local rDef = bRooms:get(i)
						local spawnDensity = math.ceil(rDef:getArea()/6)
						VirtualZombieManager.instance:addZombiesToMap(spawnDensity, rDef, false)
					end
					--for i=0, getPlayer():getSquare():getBuilding():getDef():getRooms():size()-1 do print(getPlayer():getSquare():getBuilding():getDef():getRooms():get(i):getProceduralSpawnedContainer()) end
				end]]
				spawnBldgZombies(bDef, bldgID, tier)
					
				--if not sd_bID[sq:getBuilding():getID()] then
					--print(containerClass)
					--local _tier = "T"..tier
					--local loot = lootTable[containerClass][_tier]
					--if loot then
						--local _additem = loot[ZombRand(#loot)+1]
						--container:AddItem(_additem)
				if tier > 3 then
					VirtualZombieManager.instance:addZombiesToMap(numToSpawn, sq_roomDef, false)
				end
				break
						
					--end
				--end
			end
		end
	end
end
--Events.OnFillContainer.Add(onFillContainer)

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local Commands = {};
Commands.sd_ofc = {};

function Commands.sd_ofc.reset(player, args)
	SD_bSpawned = {}
	clearCounter = 0
	bID_flag = false
end

local function onClientCommand(module, command, player, args)
    if Commands[module] and Commands[module][command] then
        Commands[module][command](player, args)
    end
end

if isServer() then
    --Events.OnClientCommand.Add(onClientCommand);
end