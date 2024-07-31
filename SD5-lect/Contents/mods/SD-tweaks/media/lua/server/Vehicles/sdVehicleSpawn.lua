local Commands = {};
Commands.SDDebug = {};

local function gaussianRandom()
    -- Generate two random integers between 0 and 999
    local u1 = ZombRand(1000) / 1000
    local u2 = ZombRand(1000) / 1000
    local z0 = math.sqrt(-2.0 * math.log(u1)) * math.cos(2 * math.pi * u2)
    return z0
end


local function scaledNormal()
    local z = gaussianRandom() 

    z = math.max(-2.5, math.min(2.5, z)) 

    -- Scale and shift to the 0-1 range
    local scaledValue = (z + 2.5) / 5
    scaledValue = scaledValue^1.33 --shift normal distribution to the left. set to 1.0 for a traditional normal distribution.
    scaledValue = math.floor(scaledValue * 100)
    return scaledValue
end

---------------------------------------------------------------------------------------------------
-------------------- Server commands

function Commands.SDDebug.spawnVehicles(player, vehArgs)
	addVehicleDebug(vehArgs.vehicleToSpawn, vehArgs.spawnDir, nil, getCell():getOrCreateGridSquare(vehArgs.vehicleX, vehArgs.vehicleY, 0))
end

function Commands.SDDebug.setEngineFeature(player, args)
	local vehicle = getVehicleById(args.vehicleID)
	local part = vehicle:getPartById(args.vehPart)
	
	part:setCondition(math.ceil(scaledNormal()))
	
	vehicle:setEngineFeature(math.ceil(scaledNormal()), args.engineLoudness, args.enginePower);
	
	vehicle:updatePartStats()
	vehicle:updateBulletStats()
	vehicle:transmitPartCondition(part)
	vehicle:transmitPartItem(part)
	vehicle:transmitPartModData(part)
end

function Commands.SDDebug.setBattery(player, args)
	local vehicle = getVehicleById(args.vehicleID)
	local part = vehicle:getPartById(args.vehPart)

	part:setCondition(math.ceil(scaledNormal()))
	
	vehicle:updatePartStats()
	vehicle:updateBulletStats()
	vehicle:transmitPartCondition(part)
	vehicle:transmitPartItem(part)
	vehicle:transmitPartModData(part)
end

function Commands.SDDebug.setVehicleCondition(player, args)
	local vehicle = getVehicleById(args.vehicleID)
	local part = vehicle:getPartById(args.vehPart)
	
	part:setCondition(0)
	
	vehicle:updatePartStats()
	vehicle:updateBulletStats()
	vehicle:transmitPartCondition(part)
	vehicle:transmitPartItem(part)
	vehicle:transmitPartModData(part)
end

function Commands.SDDebug.removeVehiclePart(player, args)
	local vehicle = getVehicleById(args.vehicleID)
	local part = vehicle:getPartById(args.vehPart)
	
	local tbl = part:getTable("uninstall")
	if tbl and tbl.complete then
		VehicleUtils.callLua(tbl.complete, vehicle, part)
	end
	vehicle:transmitPartItem(part)
	player:sendObjectChange('mechanicActionDone', { success = true, vehicleId = vehicle:getId(), partId = part:getId(), itemId = -1, installing = false })
end
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local function onClientCommand(module, command, player, args)
    if Commands[module] and Commands[module][command] then
        Commands[module][command](player, args)
    end
end

if isServer() then
    Events.OnClientCommand.Add(onClientCommand);
end