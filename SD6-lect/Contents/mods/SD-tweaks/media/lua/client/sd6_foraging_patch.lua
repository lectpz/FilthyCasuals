local function iterList(_list)
	local list = _list;
	local size = list:size() - 1;
	local i = -1;
	return function()
		i = i + 1;
		if i <= size and not list:isEmpty() then
			return list:get(i), i;
		end;
	end;
end

function SD6_doGenericItemSpawn(_character, _inventory, _itemDef, _items)
	tier = checkZone()
	for item in iterList(_items) do
		if item:IsDrainable() then
			item:setUsedDelta(ZombRandFloat(0.0, 0.2*tier)); -- Randomize the item uses remaining
		end;
		local conditionMax = item:getConditionMax();
		if conditionMax > 0 then
			item:setCondition(ZombRand(conditionMax) + 1); -- Randomize the weapon condition
		end;
	end;
	return _items; --custom spawn scripts must return an arraylist of items (or nil)
end

local nukeForageCharges = { "PropaneTank", "PetrolCan", "BlowTorch" }
local forageZones = { "Forest", "DeepForest", "Vegitation", "FarmLand", "Farm", "TrailerPark", "TownZone", "Nav" }
local function nerfForagingDrainables()
	for i=1,#nukeForageCharges do
		local item = nukeForageCharges[i]
		forageDefs[item].spawnFuncs = { SD6_doGenericItemSpawn }
		for j=1, #forageZones do
			forageDefs[item].zones[forageZones[j]] = 2
		end
	end
end
Events.OnGameStart.Add(nerfForagingDrainables)

local foragingEggs = { "Egg", "WildEggs" }
local eggForageZones = { "Forest", "DeepForest", "Vegitation", "FarmLand", "Farm"}
local function nerfForagingEggs()
	for i=1,#foragingEggs do
		local item = foragingEggs[i]
		forageDefs[item].maxCount = 2
		for j=1, #eggForageZones do
			forageDefs[item].zones[eggForageZones[j]] = 3
		end
	end
end
Events.OnGameStart.Add(nerfForagingEggs)