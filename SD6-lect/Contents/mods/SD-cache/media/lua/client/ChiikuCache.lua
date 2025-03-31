----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

local function gaussianRandom()
	-- Generate two random integers between 0 and 999
	local u1 = ZombRand(1000) / 1000
	local u2 = ZombRand(1000) / 1000
	local z0 = math.sqrt(-2.0 * math.log(u1)) * math.cos(2 * math.pi * u2)--Box-Mueller Transform
	return z0
end


local function scaledNormal()
	local z = gaussianRandom() 

	z = math.max(-2.5, math.min(2.5, z)) 

	-- Scale and shift to the 0-1 range
	local scaledValue = (z + 2.5) / 5
	scaledValue = scaledValue^1.75 --shift normal distribution to the left. set to 1.0 for a traditional normal distribution.
	scaledValue = math.floor(scaledValue * 10 + 0.5) / 10
	return scaledValue
end

local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "[^ %;,]+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local args = {}

local isMultiplayer = true
if getWorld():getGameMode() ~= "Multiplayer" then isMultiplayer = false end

local function addToArgs(item, amount, itemname)
	local item = itemname or item
	amount = amount or 1
    local newItemKey = "item" .. (#args + 1) 
    args[newItemKey] = args[newItemKey] or {}  
    table.insert(args[newItemKey], amount .. "x " .. item) 
end

local function addWeaponToPlayer(loot)
	local newItem = InventoryItemFactory.CreateItem(loot)
	if isMultiplayer then MDZ_OnCreate_RangedWeaponVariance(newItem, true) end
	getSpecificPlayer(0):getInventory():AddItem(newItem)
	addToArgs(loot)
end

local function addItemToPlayer(loot)
	getSpecificPlayer(0):getInventory():AddItem(loot)
	addToArgs(loot)
end

local function addItemsToPlayer(loot, amount)
	getSpecificPlayer(0):getInventory():AddItems(loot, amount)
	addToArgs(loot, amount)
end

local function randomrollSD(zoneroll, loot, itemname)
	if ZombRand(zoneroll) == 0 then
		getSpecificPlayer(0):getInventory():AddItem(loot)
		local itemname = itemname or loot
		addToArgs(loot, 1, itemname)
	end
end

local chiikuArms = {
	"ChiikuArms.HKUSP",
	"ChiikuArms.FNFAL",
	"ChiikuArms.UMP",
	"ChiikuArms.SCARH",
	"ChiikuArms.SCARH2",
	"ChiikuArms.marlin1894",
	"ChiikuArms.marlin366Custom",
	"ChiikuArms.billythekid",
}

local chiikuMags = {
	"ChiikuArms.USPMag",
	"ChiikuArms.FNFALMag",
	"ChiikuArms.UMPMag",
	"ChiikuArms.ScarHMag",
}

function ChiikuWeaponCacheSD(items, result, player)
	
	local zonetier, zonename, x, y = checkZone()
	local gunpowder = InventoryItemFactory.CreateItem("Base.GunPowder")
	
	local ammo = splitString("Base.Bullets45Box Base.ShotgunShellsBox Base.308Box Base.556Box Base.Bullets9mmBox Base.762x54rBox Base.762Box Base.50BMGBox Base.57Box Base.545Box Base.380Box Base.223Box")
	
	local zoneroll = 10-zonetier

	args = {
	  player_name = getOnlineUsername(),
	  cachetype = "Chiiku Cache",
	  player_x = math.floor(x),
	  player_y = math.floor(y),
	  zonename = zonename,
	  zonetier = zonetier,
	}
	
	if zonetier == 5 then
		gunpowder:setUsedDelta(math.min(1, scaledNormal()))
		randomrollSD(1, gunpowder, "Base.GunPowder")
		randomrollSD(zoneroll, gunpowder, "Base.GunPowder")
		addWeaponToPlayer(chiikuArms[ZombRand(#chiikuArms)+1])
		addItemToPlayer(chiikuMags[ZombRand(#chiikuMags)+1])
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
	elseif zonetier == 4 then
		gunpowder:setUsedDelta(math.min(0.9, scaledNormal()))
		randomrollSD(1, gunpowder, "Base.GunPowder")
		randomrollSD(zoneroll, gunpowder, "Base.GunPowder")
		addWeaponToPlayer(chiikuArms[ZombRand(#chiikuArms)+1])
		addItemToPlayer(chiikuMags[ZombRand(#chiikuMags)+1])
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
	elseif zonetier == 3 then
		gunpowder:setUsedDelta(math.min(0.8, scaledNormal()))
		randomrollSD(1, gunpowder, "Base.GunPowder")
		randomrollSD(zoneroll, gunpowder, "Base.GunPowder")
		addWeaponToPlayer(chiikuArms[ZombRand(#chiikuArms)+1])
		addItemToPlayer(chiikuMags[ZombRand(#chiikuMags)+1])
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
	elseif zonetier == 2 then
		gunpowder:setUsedDelta(math.min(0.7, scaledNormal()))
		randomrollSD(zoneroll, gunpowder, "Base.GunPowder")
		randomrollSD(1, gunpowder, "Base.GunPowder")
		addWeaponToPlayer(chiikuArms[ZombRand(#chiikuArms)+1])
		addItemToPlayer(chiikuMags[ZombRand(#chiikuMags)+1])
		addItemToPlayer(ammo[ZombRand(#ammo)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
	elseif zonetier == 1 then
		gunpowder:setUsedDelta(math.min(0.6, scaledNormal()))
		randomrollSD(zoneroll, gunpowder, "Base.GunPowder")
		randomrollSD(1, gunpowder, "Base.GunPowder")
		addWeaponToPlayer(chiikuArms[ZombRand(#chiikuArms)+1])
		addItemToPlayer(chiikuMags[ZombRand(#chiikuMags)+1])
		randomrollSD(zoneroll, ammo[ZombRand(#ammo)+1])
	end
	sendClientCommand(player, 'sdLogger', 'OpenCache', args);
end