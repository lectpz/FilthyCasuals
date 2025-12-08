require "SDZoneCheck"

local SDDebug = {}
SDDebug.VehiclePanel = ISPanel:derive("SDDebug.VehiclePanel")

local function splitString(var)
	local ztable = {}
	local pattern = "[^ %;,]+"

	for match in var:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

--normal distribution number generator, rounding down to nearest 0.1
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

local function teleTo(playerObj)
	playerObj:setX(playerObj:getX()+ 100)
	playerObj:setY(playerObj:getY() + 0)
	playerObj:setZ(0)
	playerObj:setLx(playerObj:getX() + 100)
	playerObj:setLy(playerObj:getY() + 0)
	playerObj:setLz(0)
end

local vehiclelist = {}
local vehicleLocation = {}
local vehicleNames = {}

local ownedvehiclelist = {}
local ownedvehicleLocation = {}
local ownedvehicleNames = {}

local listSpawnVehicles = {}
local listRareVehicles = {}
local listSpawnWrecks = {}

local spawnFacing = { 
	IsoDirections.N,
	IsoDirections.NE,
	IsoDirections.E,
	IsoDirections.SE,
	IsoDirections.S,
	IsoDirections.SW,
	IsoDirections.W,
	IsoDirections.NW,
}

local blacklistVehicles = {
	"Base.TrailerM967tanker",
	"Base.TrailerAMCWaverunnerWithBody",
	"Base.TrailerAMCWaverunner",
	"Base.TrailerAMC",
	"Base.ECTO1",
	"Base.AMC_Waverunner_Ground",
	"Base.AMC_Waverunner",
	"Base.78amgeneralM50A3",
	"Base.78amgeneralM49A2C",
	"Base.69miniMrB",
	"Base.49powerWagonPA",
	"Base.28ss100",
	"Base.28ss100hermes",
	"Base.80kz1000",
	"Base.81deloreanDMC12",
	"Base.84gageV300apc",
	"Base.84gageV300fsv",
	"Base.97bushmaster",
	"Base.97bushAmbulance",
	"Base.67commando",
	"Base.67commandoT50",
	"Base.67commandoPolice",
	"Base.87fordF700bank",
	"Base.90niva",
	"Base.90zanella50cc",
	"Base.AMC_bmw_classic",
	"Base.AMC_bmw_custom",
	"Base.AMC_harley",
	"Base.AMC_quad",
	"Base.vino125",
	"Base.vino125b",
	"Base.vino125pizza",
}

local vanillaVehicles = {
	"Base.CarLights",
	"Base.CarLightsPolice",
	"Base.CarLuxury",
	"Base.CarNormal",
	"Base.CarStationWagon",
	"Base.CarStationWagon2",
	"Base.CarTaxi",
	"Base.CarTaxi2",
	"Base.ModernCar",
	"Base.ModernCar02",
	"Base.OffRoad",
	"Base.PickUpTruck",
	"Base.PickUpTruckLights",
	"Base.PickUpTruckMccoy",
	"Base.PickUpVanLights",
	"Base.PickUpVanLightsFire",
	"Base.PickUpVanLightsPolice",
	"Base.PickUpVanMccoy",
	"Base.SmallCar",
	"Base.SmallCar02",
	"Base.SportsCar",
	"Base.StepVan",
	"Base.StepVan_Heralds",
	"Base.StepVan_Scarlet",
	"Base.StepVanMail",
	"Base.SUV",
	"Base.Trailer",
	"Base.TrailerAdvert",
	"Base.TrailerCover",
	"Base.Van",
	"Base.Van_KnoxDisti",
	"Base.Van_LectroMax",
	"Base.Van_MassGenFac",
	"Base.Van_Transit",
	"Base.VanAmbulance",
	"Base.VanRadio",
	"Base.VanRadio_3N",
	"Base.VanSeats",
	"Base.VanSpecial",
	"Base.VanSpiffo",
	"Base.ModernCar_ez",
	"Base.ModernCar_Martin",
	"Base.PickUpTruckLightsFire",
	"Base.PickUpVan",
	"Base.SportsCar_ez",
}

local rarelistVehicles = {
	"Base.49powerWagonPD",
	"Base.63beetleBuggy",
	"Base.63beetleHP",
	"Base.63Type2VanApocalypse",
	"Base.67gt500e",
	"Base.70dodgePD",
	"Base.81deloreanDMC12BTTF",
	"Base.82firebirdKITT",
	"Base.82jeepJ10pd",
	"Base.87buickRegalTurboTfbi",
	"Base.87chevySuburbanOP",
	"Base.87fordB700military",
	"Base.87fordB700prison",
	"Base.87fordF700box",
	"Base.87fordF700swat",
	"Base.89fordBroncoPD",
	"Base.89trooperRS",
	"Base.90fordF350SWAT",
	"Base.92nissanGTRlhd",
	"Base.ATAJeepArcher",
	"Base.ATAJeepClassic",
	"Base.ATAJeepRubicon",
	"Base.70barracudaAAR",
	"Base.82firebirdKARR",
	"Base.82jeepJ10t",
	"Base.89dodgeCaravanNomad",
	"Base.93chevySuburbanfbi",
	"Base.TrailerKI5utilityLarge",
	"Base.TrailerM101A3cargo",
	"Base.TrailerM127stake",
	"Base.TrailerM128van",
	"Base.TrailerM129van",
	"Base.TrailerM747lowbed",
}

local blacklist = {}
local vanillalist = {}
local rarelist = {}

for i = 1, #vanillaVehicles do
	vanillalist[vanillaVehicles[i]] = true
	--print("Blacklisted car: " .. blacklistVehicles[i])
end

for i = 1, #blacklistVehicles do
	blacklist[blacklistVehicles[i]] = true
	print("Blacklisted car: " .. blacklistVehicles[i])
end

for i = 1, #rarelistVehicles do
	rarelist[rarelistVehicles[i]] = true
	print("Rarelisted car: " .. rarelistVehicles[i])
end

local function getVehicleList()
	local vehicles = getScriptManager():getAllVehicleScripts()
	for i=0, vehicles:size()-1 do
		local vehicle = vehicles:get(i)
		local vehicleFullName = vehicle:getFullName()
		local name = string.lower(vehicle:getName())
		if not blacklist[vehicleFullName] and not vanillalist[vehicleFullName] then
			if string.contains(name, "burnt") or string.contains(name, "smashed") or string.contains(name, "wreck") then
				table.insert(listSpawnWrecks, vehicleFullName)
			elseif rarelist[vehicleFullName] then
				table.insert(listRareVehicles, vehicleFullName)
				print("Rare car added to list: ", vehicleFullName)
			else
				table.insert(listSpawnVehicles, vehicleFullName)
				print("Modded car added to list: ", vehicleFullName)
			end
		else
			if blacklist[vehicleFullName] then print("Skipping blacklisted vehicle: " .. vehicleFullName) end
			if vanillalist[vehicleFullName] then print("Skipping vanilla vehicle: " .. vehicleFullName) end
		end
	end
end

local function getVehicleToSpawn()
	local vehRoll = ZombRand(100)+1
	
	if vehRoll >= SandboxVars.SDVehicleReroll.rareKI5 then
		return listRareVehicles[ZombRand(#listRareVehicles)+1]
	elseif vehRoll >= SandboxVars.SDVehicleReroll.KI5 then
		return listSpawnVehicles[ZombRand(#listSpawnVehicles)+1]
	elseif vehRoll >= SandboxVars.SDVehicleReroll.Vanilla then
		return vanillaVehicles[ZombRand(#vanillaVehicles)+1]
	else
		return listSpawnWrecks[ZombRand(#listSpawnWrecks)+1]
	end
end

local vehArgs = {}
local vehParts = {
	"Engine",
	"Battery",
	"BrakeFrontLeft",
	"BrakeFrontRight",
	"BrakeRearLeft",
	"BrakeRearRight",
	"DoorFrontLeft",
	"DoorFrontRight",
	"EngineDoor",
	"Muffler",
	"SuspensionFrontLeft",
	"SuspensionFrontRight",
	"SuspensionRearLeft",
	"SuspensionRearRight",
	"TireFrontLeft",
	"TireFrontRight",
	"TireRearLeft",
	"TireRearRight",
	"Windshield",
	"WindshieldRear",
	"WindowFrontLeft",
	"WindowFrontRight",
	"WindowRearLeft",
	"WindowRearRight",
}

local function doVehCond()
	setVehicleCondition(player, vehiclelist, vehicleLocation)
end
	
local function spawnVehicles(player, vehiclelist, vehicleLocation)
	for vehicleID, vehicleSQ in pairs(vehicleLocation) do
		local vehicleToSpawn = getVehicleToSpawn()
		local vehicleX = vehicleSQ:getX()
		local vehicleY = vehicleSQ:getY()
		local spawnDir = spawnFacing[ZombRand(#spawnFacing)+1]
		
		vehArgs = {
			vehicleToSpawn = vehicleToSpawn,
			spawnDir = spawnDir,
			vehicleX = vehicleX,
			vehicleY = vehicleY,
			}
			
		sendClientCommand(player, "SDDebug", "spawnVehicles", vehArgs)
		--addVehicleDebug(vehicleToSpawn, spawnDir, nil, getCell():getGridSquare(vehicleX, vehicleY, 0))

		--print("Respawned Vehicle Name: " .. vehicleToSpawn .. " at X:", vehicleX, ", Y:", vehicleY)
	end
	player:Say("Respawned " .. #vehiclelist .. " vehicles into visible chunks.")

	--Events.EveryOneMinute.Add(doVehCond)
end

local function OGSpawnVehicle(player)
	local zonetier, zonename, px, py = checkZone()
	
	for i=1, #vehicleSpawnXY ,4 do
		local vehicleToSpawn = getVehicleToSpawn()
		local x = vehicleSpawnXY[i+1]
		local y = vehicleSpawnXY[i+2]
		local zone = vehicleSpawnXY[i]
		local facing = vehicleSpawnXY[i+3]
		local spawnDir = spawnFacing[ZombRand(#spawnFacing)+1]
		
		if 		facing == "E" then 
			spawnDir = spawnFacing[3]
		elseif 	facing == "N" then
			spawnDir = spawnFacing[1]
		elseif 	facing == "S" then
			spawnDir = spawnFacing[5]
		elseif 	facing == "W" then
			spawnDir = spawnFacing[7]
		end

		vehArgs = {
			vehicleToSpawn = vehicleToSpawn,
			spawnDir = spawnDir,
			vehicleX = x,
			vehicleY = y,
			}
		
		if zonename == zone and ( ((px-x)*(px-x) + (py-y)*(py-y))^0.5 <= 100 ) then 
			sendClientCommand(player, "SDDebug", "spawnVehicles", vehArgs) 
			player:Say("Respawned vehicles within 100 square radius in zone: " .. zone)
		end

	end
end
	
local function setVehicleCondition(player, vehiclelist, vehicleLocation)
	--Events.EveryOneMinute.Remove(doVehCond)
	if not vehiclelist or not #vehiclelist then player:Say("Vehicle list not populated") return end
	if not vehicleLocation or not #vehicleLocation then player:Say("Vehicle list not populated") return end
	for vehicleID, vehicleSQ in pairs(vehicleLocation) do
		local partCounter = 0
		local vehicle = getVehicleById(vehicleID)
		local vehicleX = vehicleSQ:getX()
		local vehicleY = vehicleSQ:getY()
		local zonetier = checkZoneAtXY(vehicleX, vehicleY)
		local setTimes = 7 - zonetier
		
		for key, vehPart in pairs(vehParts) do
			local part = vehicle:getPartById(vehPart)
			local scriptVeh = vehicle:getScript()
			
			local args = {
					vehicleID = vehicleID,
					vehPart = vehPart
					}

			if part and vehPart == "Engine" then
				scriptVeh = vehicle:getScript()
				args = {
					vehicleID = vehicleID,
					vehPart = vehPart,
					engineLoudness = scriptVeh:getEngineLoudness() or 100;
					enginePower = scriptVeh:getEngineForce()
					}

				sendClientCommand(player, "SDDebug", "setEngineFeature", args)
				--print("Set " .. vehPart .. " to: " .. newCond .. " condition for vehicleID: " .. vehicleID)

			elseif part and vehPart == "Battery" then
				sendClientCommand(player, "SDDebug", "setBattery", args)
				--print("Set " .. vehPart .. " to: " .. newCond .. " condition for vehicleID: " .. vehicleID)

			elseif part and (setTimes - partCounter) > 0 then
				if ZombRand(3) == 0 then
					partCounter = partCounter + 1
					
					sendClientCommand(player, "SDDebug", "setVehicleCondition", args)
					--print("Set " .. vehPart .. " to: " .. 0 .. " condition for vehicleID: " .. vehicleID)
					sendClientCommand(player, "SDDebug", "removeVehiclePart", args)
					--print("Removed " .. vehPart .. " from vehicleID: " .. vehicleID)

				end
			elseif not part then
				partCounter = partCounter + 1
				--print("No part " .. vehPart .. " found for vehicleID: " .. vehicleID)
			end

		end
	end
	player:Say("Set vehicle part conditions by tierzone.")
end

local function removeVehicles(player, vehiclelist, ownedvehiclelist)
	if not vehiclelist then return end
	if #vehiclelist < 1 then return end
	for i = 1, #vehiclelist do
		sendClientCommand(player, "vehicle", "remove", { vehicle = vehiclelist[i] })
	end
	if #vehiclelist >= 1 then player:Say("Removed " .. #vehiclelist .. " vehicles from visible chunks.") end
	if not ownedvehiclelist then return end
	if #ownedvehiclelist >= 1 then player:Say("Skipped " .. #ownedvehiclelist .. " vehicles from visible chunks.") end
end

BTSE = BTSE or {};
BTSE.VehicleProtection = BTSE.VehicleProtection or {};
local function vehicleIsOwned(vehicle)
	local owner = nil
	
	if vehicle then owner = BTSE.VehicleProtection:getOwner(vehicle) end
	
	if owner then return owner end
	
	return false
end

local function checkVehicles(player)
	local vehicles = getCell():getVehicles()
  
	vehiclelist = {}
	vehicleLocation = {}
	vehicleNames = {}

	ownedvehiclelist = {}
	ownedvehicleLocation = {}
	ownedvehicleNames = {}


	for i = 1, vehicles:size() do
		local vehicle_local = vehicles:get(i - 1)
		local vehicleID = vehicle_local:getId()
		local vehicleSQ = vehicle_local:getSquare()
		local vehicleX = vehicleSQ:getX()
		local vehicleY = vehicleSQ:getY()
		local vehicleName = vehicle_local:getScriptName()
		local vehicleOwner = vehicleIsOwned(vehicle_local) or false
		
		if not vehicleOwner then
			vehiclelist[i] = vehicleID
			vehicleLocation[vehicleID] = vehicleSQ
			vehicleNames[vehicleID] = vehicleName
			--print(" VehicleID : ", vehicleID, ", Vehicle Name: " .. vehicleName .. ", X:", vehicleX, ", Y:", vehicleY)
		else
			ownedvehiclelist[i] = vehicleID
			ownedvehicleLocation[vehicleID] = vehicleSQ
			ownedvehicleNames[vehicleID] = vehicleName
			print("Skipping owned vehicle. Vehicle owner: " .. vehicleOwner .. "VehicleID:", vehicleID, ", Vehicle Name: " .. vehicleName .. ", X:", vehicleX, ", Y:", vehicleY)
		end
		
		
		--single player only
		--vehicle:removeFromWorld()
		--print("Removed from world! -----  ", i, ": ID", vehicleID, ", Vehicle Name: " .. vehicleName .. ", X:", vehicleX, ", Y:", vehicleY)
	end
	removeVehicles(player, vehiclelist, ownedvehiclelist)
	spawnVehicles(player, vehiclelist, vehicleLocation)
end

local function checkOwnedVehicles(player)
	local vehicles = getCell():getVehicles()
  
	vehiclelist = {}
	vehicleLocation = {}
	vehicleNames = {}

	ownedvehiclelist = {}
	ownedvehicleLocation = {}
	ownedvehicleNames = {}

	for i = 1, vehicles:size() do
		local vehicle_local = vehicles:get(i - 1)
		local vehicleID = vehicle_local:getId()
		local vehicleSQ = vehicle_local:getSquare()
		local vehicleX = vehicleSQ:getX()
		local vehicleY = vehicleSQ:getY()
		local vehicleName = vehicle_local:getScriptName()
		local vehicleOwner = vehicleIsOwned(vehicle_local) or false
		
		if not vehicleOwner then
			vehiclelist[i] = vehicleID
			vehicleLocation[vehicleID] = vehicleSQ
			vehicleNames[vehicleID] = vehicleName
			--print(" VehicleID : ", vehicleID, ", Vehicle Name: " .. vehicleName .. ", X:", vehicleX, ", Y:", vehicleY)
		else
			ownedvehiclelist[i] = vehicleID
			ownedvehicleLocation[vehicleID] = vehicleSQ
			ownedvehicleNames[vehicleID] = vehicleName
			print("Skipping owned vehicle. Vehicle owner: " .. vehicleOwner .. "VehicleID:", vehicleID, ", Vehicle Name: " .. vehicleName .. ", X:", vehicleX, ", Y:", vehicleY)
		end
		
		
		--single player only
		--vehicle:removeFromWorld()
		--print("Removed from world! -----  ", i, ": ID", vehicleID, ", Vehicle Name: " .. vehicleName .. ", X:", vehicleX, ", Y:", vehicleY)
	end
	player:Say("Total unowned vehicles found in visible chunks: " .. #vehiclelist)
	player:Say("Total owned vehicles found in visible chunks: " .. #ownedvehiclelist)
end

--************************************************************************--
--** ISPanel:initialise
--**
--************************************************************************--

function SDDebug.VehiclePanel:initialise()
	ISPanel.initialise(self);
end

function SDDebug.VehiclePanel:noBackground()
	self.background = false;
end

function SDDebug.VehiclePanel:close()
	self:setVisible(false);
    self:removeFromUIManager()
end


function SDDebug.VehiclePanel:clearVehicles()
	checkVehicles(self.character)
end

function SDDebug.VehiclePanel:OGSpawnVehicle()
	OGSpawnVehicle(self.character)
end

function SDDebug.VehiclePanel:getVehicles()
	checkOwnedVehicles(self.character)
end

function SDDebug.VehiclePanel:setVehicleCondition()
	if not vehiclelist and not #vehiclelist then return end
	if not vehicleLocation and not #vehicleLocation then return end
	setVehicleCondition(self.character, vehiclelist, vehicleLocation)
end

function SDDebug.VehiclePanel:teleTo()
	teleTo(self.character)
end

function SDDebug.VehiclePanel:createChildren()
	
    ISPanel.createChildren(self)

    local emptyhight = self.height/80
    local lblheighth = self.height/12
    self.lbl = ISLabel:new(3*emptyhight, emptyhight, lblheighth, "Sunday Drivers Vehicle Panel", 1, 1, 1, 1.0, UIFont.Large, true);
    self.lbl:initialise();
    self.lbl:instantiate();
    self:addChild(self.lbl);


    local buttonheight = self.height/6
    local buttonwidth = self.width - 6*emptyhight

    self.buttonclose = ISButton:new(3*emptyhight, self.height -emptyhight -buttonheight ,buttonwidth,buttonheight , "Close", self, self.close);
    self.buttonclose.anchorTop = false
    self.buttonclose.anchorBottom = false
    self.buttonclose:initialise();
    self.buttonclose:instantiate();
    self.buttonclose.borderColor = {r=1, g=1, b=1, a=0.5};
    self:addChild(self.buttonclose);


    local buttonnewy = 2*emptyhight + lblheighth


    self.button_clearVehicles = ISButton:new(3*emptyhight,  buttonnewy ,buttonwidth,buttonheight , "Clear Vehicles", self, self.clearVehicles);
    self.button_clearVehicles.anchorTop = false
    self.button_clearVehicles.anchorBottom = false
    self.button_clearVehicles:initialise();
    self.button_clearVehicles:instantiate();
    self.button_clearVehicles.borderColor = {r=1, g=1, b=1, a=0.5};
    -- self.buttonnew:setEnabled(false)
    self:addChild(self.button_clearVehicles);

	--[[buttonnewy = buttonnewy + buttonheight + emptyhight
    self.button_respawnVehicles = ISButton:new(3*emptyhight, buttonnewy  ,buttonwidth,buttonheight , "Respawn Vehicles in Original Coordinates", self, self.OGSpawnVehicle);
    self.button_respawnVehicles.anchorTop = false
    self.button_respawnVehicles.anchorBottom = false
    self.button_respawnVehicles:initialise();
    self.button_respawnVehicles:instantiate();
    self.button_respawnVehicles.borderColor = {r=1, g=1, b=1, a=0.5};
    -- self.buttondelete:setEnabled(false)
    self:addChild(self.button_respawnVehicles);]]

    buttonnewy = buttonnewy + buttonheight + emptyhight
    self.button_getVehicles = ISButton:new(3*emptyhight, buttonnewy  ,buttonwidth,buttonheight , "Get Vehicles", self, self.getVehicles);
    self.button_getVehicles.anchorTop = false
    self.button_getVehicles.anchorBottom = false
    self.button_getVehicles:initialise();
    self.button_getVehicles:instantiate();
    self.button_getVehicles.borderColor = {r=1, g=1, b=1, a=0.5};
    -- self.buttondelete:setEnabled(false)
    self:addChild(self.button_getVehicles);
	
	
	buttonnewy = buttonnewy + buttonheight + emptyhight
    self.button_setVehicleCondition = ISButton:new(3*emptyhight, buttonnewy  ,buttonwidth,buttonheight , "Set Vehicle Parts Condition", self, self.setVehicleCondition);
    self.button_setVehicleCondition.anchorTop = false
    self.button_setVehicleCondition.anchorBottom = false
    self.button_setVehicleCondition:initialise();
    self.button_setVehicleCondition:instantiate();
    self.button_setVehicleCondition.borderColor = {r=1, g=1, b=1, a=0.5};
    -- self.buttondelete:setEnabled(false)
    self:addChild(self.button_setVehicleCondition);
	
	buttonnewy = buttonnewy + buttonheight + emptyhight
    self.button_teleport = ISButton:new(3*emptyhight, buttonnewy  ,buttonwidth,buttonheight , "Teleport 100 Units East", self, self.teleTo);
    self.button_teleport.anchorTop = false
    self.button_teleport.anchorBottom = false
    self.button_teleport:initialise();
    self.button_teleport:instantiate();
    self.button_teleport.borderColor = {r=1, g=1, b=1, a=0.5};
    -- self.buttondelete:setEnabled(false)
    self:addChild(self.button_teleport);
end


--************************************************************************--
--** ISPanel:render
--**
--************************************************************************--

function SDDebug.VehiclePanel:prerender()

	if self.background then
		self:drawRectStatic(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
		self:drawRectBorderStatic(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
	end

end

function SDDebug.VehiclePanel:onMouseUp(x, y)
    if not self.moveWithMouse then return; end
    if not self:getIsVisible() then
        return;
    end

    self.moving = false;
    if ISMouseDrag.tabPanel then
        ISMouseDrag.tabPanel:onMouseUp(x,y);
    end

    ISMouseDrag.dragView = nil;
end

function SDDebug.VehiclePanel:onMouseUpOutside(x, y)
    if not self.moveWithMouse then return; end
    if not self:getIsVisible() then
        return;
    end

    self.moving = false;
    ISMouseDrag.dragView = nil;
end

function SDDebug.VehiclePanel:onMouseDown(x, y)
    if not self.moveWithMouse then return true; end
    if not self:getIsVisible() then
        return;
    end
    if not self:isMouseOver() then
        return -- this happens with setCapture(true)
    end
    
    self.downX = x;
    self.downY = y;
    self.moving = true;
    self:bringToTop();
end

function SDDebug.VehiclePanel:onMouseMoveOutside(dx, dy)
    if not self.moveWithMouse then return; end
    self.mouseOver = false;

    if self.moving then
        if self.parent then
            self.parent:setX(self.parent.x + dx);
            self.parent:setY(self.parent.y + dy);
        else
            self:setX(self.x + dx);
            self:setY(self.y + dy);
            self:bringToTop();
        end
    end
end

function SDDebug.VehiclePanel:onMouseMove(dx, dy)
    if not self.moveWithMouse then return; end
    self.mouseOver = true;

    if self.moving then
        if self.parent then
            self.parent:setX(self.parent.x + dx);
            self.parent:setY(self.parent.y + dy);
        else
            self:setX(self.x + dx);
            self:setY(self.y + dy);
            self:bringToTop();
        end
        --ISMouseDrag.dragView = self;
    end
end

--************************************************************************--
--** ISPanel:new
--**
--************************************************************************--
function SDDebug.VehiclePanel:new(x, y, width, height, character)
	local o = {}
	--o.data = {}
	local o = ISPanel:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
	o.x = x;
	o.y = y;
	o.background = true;
	o.backgroundColor = {r=0, g=0, b=0, a=0.5};
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.width = width;
	o.height = height;
	o.anchorLeft = false;
	o.anchorRight = false;
	o.anchorTop = false;
	o.anchorBottom = false;
    o.moveWithMouse = true;
    o.character = character;
   return o
end

local function SDDebug_vehicleMenu(object,playerObj,sq)
    local vehMenu = SDDebug.VehiclePanel:new(getMouseX(), getMouseY(), 250, 250, playerObj);
    vehMenu:initialise();
    vehMenu:addToUIManager();
end

local function SDDebug_contextmenu(player, context, worldobjects, test)
    local playerObj = getSpecificPlayer(player)
	if isAdmin() or isDebugEnabled() then
		for i,v in pairs(worldobjects) do
			local isosprite = v:getSprite()
			if isosprite then
				local sq = v:getSquare()
				local submenu = context:addOption("SD Debug Vehicle Panel", v, SDDebug_vehicleMenu,playerObj,sq)
				return
			end
		end
	end
end

--Events.OnPreFillWorldObjectContextMenu.Add(SDDebug_contextmenu)
local function initSDD()
	if isAdmin() or isDebugEnabled() then
		getVehicleList()
		Events.OnPreFillWorldObjectContextMenu.Add(SDDebug_contextmenu)
	end
end

Events.OnGameStart.Add(initSDD)