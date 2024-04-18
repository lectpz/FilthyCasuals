local max_zombies = 6;
local mod_name = 'PZH';
local mod_prefix= mod_name .. "_";
local zombies_conf = {};
local zombies_conf_lore_properties = {'Strength','Toughness','Cognition','Memory','Sight','Hearing'};
local zombies_conf_properties = {'Name','Active','Weight','Speed','SpeedNight','Hp','SprinterProps','Strength','Toughness','Cognition','Memory','Sight','Hearing'};
local speed_names = {'slow1','slow2','walk1','walk2','walk3','walk4','sprint1','sprint2','sprint3','crawler'};
local total_weight = 0;
local mod_initialized = false


local A1, A2 = 727595, 798405  -- 5^17=D20*A1+A2
local D20, D40 = 1048576, 1099511627776  -- 2^20, 2^40
local X1, X2 = 0, 1

function findField(o, fname)
  for i = 0, getNumClassFields(o) - 1 do
    local f = getClassField(o, i)
    if tostring(f) == fname then
		return f
    end
  end
end

local wallkTypeField = findField(IsoZombie.new(nil), "private java.lang.String zombie.characters.IsoZombie.walkType");

function rand()
    local U = X2*A2
    local V = (X1*A2 + X2*A1) % D20
    V = (V*D20 + U) % D40
    X1 = math.floor(V/D20)
    X2 = V - X1*D20
    return V/D40
end
function randMinMax(min,max)
	return math.floor(modulo(rand()*max,max-min)+min);
end

function modulo(a, b)
  return a - math.floor(a/b)*b
end

function randomizeZombieType()	
	local r = randMinMax(1,total_weight);
	local total = 0;
	for zombieId=1, max_zombies do
		local zombie_conf = zombies_conf[zombieId];
		if zombie_conf['Active'] == true then
			local weight = zombie_conf['Weight'];
			total = total + weight;
			if r <= total then
				return zombieId;
			end
		end
	end
	return -1;
end

function setZombieAttributesCustomizableZombies(zombie)
	if mod_initialized == false then
		initMod();
		mod_initialized = true;
	end

	local zModData = zombie:getModData();

	if zModData == nil or zModData.PZH_TYPE == nil then
		local zombieType = randomizeZombieType();
		--print("PZH_zombieType Roll: " .. zombieType);
		if zombieType ~= -1 then
			zModData.PZH_TYPE = zombieType;
		end
	end	

	local zombie_conf = nil;
	if zModData.PZH_TYPE ~= nil and zModData.PZH_TYPE ~= -1 then
		zombie_conf = zombies_conf[zModData.PZH_TYPE];
	end

	local walkType = getClassFieldVal(zombie, wallkTypeField)

	local expectedWalkType =  nill;
	if zombie_conf then
		expectedWalkType = getWalkType(zombie_conf);
	end

	if zModData.PZH_TYPE~=-1 and expectedWalkType and expectedWalkType~=walkType then	

		if zombie:isCrawling() == false and (walkType == nil or string.sub(walkType,1,string.len(mod_prefix))~=mod_prefix) then			
			for key,property in ipairs(zombies_conf_lore_properties) do
				getSandboxOptions():set("ZombieLore." .. property ,zombie_conf[property]);
			end		
			
			if zombie_conf['SprinterProps'] == true then
				getSandboxOptions():set("ZombieLore.Speed", 1);
			elseif speed_names[zombie_conf['Speed']]~='crawler' and speed_names[zombie_conf['SpeedNight']]~='crawler' then
				getSandboxOptions():set("ZombieLore.Speed", 2);
			end			

			zombie:makeInactive(true);
			zombie:makeInactive(false);							
			
			zombie:setHealth(zombie:getHealth() * zombie_conf['Hp']);
		end

		if speed_names[getWalkTypeTime(zombie_conf)] == 'crawler' then
			if zombie:isCrawling() == false then
				zombie:setCanWalk(false);
				zombie:toggleCrawling();
			end
		else
			if zombie:isCrawling() == true and zombie:isProne() == false and zombie:isFallOnFront() == false and zombie:isKnowckedDown() == false then
				zombie:setCanWalk(true);
				zombie:toggleCrawling();
			end
			zombie:setWalkType(expectedWalkType);
		end		
	end
	
end



function getWalkType(zombie_conf)
	local zombieType = zombie_conf['Speed'];
	if zombie_conf['SpeedNight'] ~= 1 then
		zombieType = getWalkTypeTime(zombie_conf);
	end

	local speedName = speed_names[zombieType]
	local toReturn = mod_prefix .. speedName;
	if speedName == 'walk1' then
		toReturn = toReturn .. randMinMax(1,3);
	end
	return toReturn;
end

function getWalkTypeTime(zombie_conf)
	local gTime = getGameTime();
	local hour = gTime:getTimeOfDay();
	local startNigth = getSandboxOptions():getOptionByName('PZHMod.o_Night_Start'):getValue();
	local endNigth = getSandboxOptions():getOptionByName('PZHMod.o_Night_End'):getValue();
	if(hour >= startNigth or hour<=endNigth) then
		return zombie_conf['SpeedNight']-1;
	else
		return zombie_conf['Speed'];
	end
end

function getOptionName(zombieId, property)
	return 'PZHMod.o_Zombie_' .. zombieId .. '_' .. property;
end

function getOption(zombieId, property)
	return  getSandboxOptions():getOptionByName(getOptionName(zombieId,property)):getValue() or 1;
end

function initMod()
	for zombieId= 1,max_zombies do
		local zombie_conf = {};
		for key,property in ipairs(zombies_conf_properties) do
			zombie_conf[property] = getOption(zombieId,property);
		end
		if zombie_conf['Active'] == true then
			total_weight = total_weight + zombie_conf['Weight'];
		end
        table.insert(zombies_conf,zombie_conf);
	end
	--print("PZH_Total Weight: " .. total_weight);
end

Events.OnZombieUpdate.Add(setZombieAttributesCustomizableZombies);