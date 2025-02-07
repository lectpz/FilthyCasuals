if not isServer() then return end

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
	local players_online = {};

	if online_players
	then
		for i = 0, online_players:size() - 1
		do
			local player = online_players:get(i);

			if player
			then
				local playerName = player:getUsername()
				table.insert(players_online, playerName);
				local sq = player:getCurrentSquare()
				local bldg
				local bID
				if sq then bldg = sq:getBuilding() end
				if bldg then bID = bldg:getID() end
				if bID then ofc_bID[bID] = true end
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
Events.EveryOneMinute.Add(clearFlag)

local function onFillContainer(_roomName, _containerType, container)
	if instanceof(container:getParent(), "BaseVehicle") then return end
	
	local sq = container:getSourceGrid()
	if not sq then return end
	
	local SafeHouseSQ = SafeHouse.getSafeHouse(sq)
	--SafeHouseSQ = true
	if SafeHouseSQ then return end
	
	local sq_room = sq:getRoom()
	if not sq_room then return end
	
	if sd_bID[sq:getBuilding():getID()] then return end
	
	if not bID_flag then
		getPlayerBIDS()
		bID_flag = true
	end
	if ofc_bID[sq:getBuilding():getID()] then return end
	
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
			local containerClass = proceduralContainer[hashString[i]]
			if lootTable[containerClass] then
				--if not sd_bID[sq:getBuilding():getID()] then
					--print(containerClass)
					--local _tier = "T"..tier
					--local loot = lootTable[containerClass][_tier]
					--if loot then
						--local _additem = loot[ZombRand(#loot)+1]
						--container:AddItem(_additem)
						VirtualZombieManager.instance:addZombiesToMap(math.ceil(tier/3), sq_roomDef, false)
						break
					--end
				--end
			end
		end
	end
end
Events.OnFillContainer.Add(onFillContainer)