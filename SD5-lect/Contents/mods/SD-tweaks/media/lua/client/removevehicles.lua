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
	"Base.49powerWagonPA",
	"Base.69miniMrB",
	"Base.78amgeneralM49A2C",
	"Base.78amgeneralM50A3",
	"Base.AMC_Waverunner",
	"Base.AMC_Waverunner_Ground",
	"Base.ECTO1",
	"Base.TrailerAMC",
	"Base.TrailerAMCWaverunner",
	"Base.TrailerAMCWaverunnerWithBody",
	"Base.TrailerM967tanker",
}

local blacklist = {}

for i = 1, #blacklistVehicles do
	blacklist[blacklistVehicles[i]] = true
	print("Blacklisted car: " .. blacklistVehicles[i])
end

local function getVehicleList()
	local vehicles = getScriptManager():getAllVehicleScripts()
	for i=1, vehicles:size() do
		local vehicle = vehicles:get(i-1)
		local vehicleFullName = vehicle:getFullName()
		local name = string.lower(vehicle:getName())
		if not blacklist[vehicleFullName] then
			if string.contains(name, "burnt") or string.contains(name, "smashed") or string.contains(name, "wreck") then
				table.insert(listSpawnWrecks, vehicleFullName)
			else
				table.insert(listSpawnVehicles, vehicleFullName)
			end
		else
			print("Skipping blacklisted vehicle: " .. vehicleFullName)
		end
	end
end

local function getVehicleToSpawn()
	if ZombRand(100) <= 60 then
		return listSpawnWrecks[ZombRand(#listSpawnWrecks)+1]
	else
		return listSpawnVehicles[ZombRand(#listSpawnVehicles)+1]
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

		print("Respawned Vehicle Name: " .. vehicleToSpawn .. " at X:", vehicleX, ", Y:", vehicleY)
	end
	player:Say("Respawned " .. #vehiclelist .. " vehicles into visible chunks.")

	--Events.EveryOneMinute.Add(doVehCond)
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
					--sendClientCommand(player, "SDDebug", "removeVehiclePart", args)
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

local function vehicleIsOwned(vehicle)
	if not (Valhalla and Valhalla.VehicleClaims) then
		return false --Don't try to run this if Aegis isn't here.
	end
	
	local modData = nil
	local part = Valhalla:getMulePart(vehicle)

	if part then
		modData = part:getModData()
	else
		modData = vehicle:getModData()
	end

	if modData then
		local owner = modData["owner"]
		if owner and owner ~= "" then
			return modData["owner"]
		end
	end
	
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
			print(" VehicleID : ", vehicleID, ", Vehicle Name: " .. vehicleName .. ", X:", vehicleX, ", Y:", vehicleY)
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
			print(" VehicleID : ", vehicleID, ", Vehicle Name: " .. vehicleName .. ", X:", vehicleX, ", Y:", vehicleY)
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