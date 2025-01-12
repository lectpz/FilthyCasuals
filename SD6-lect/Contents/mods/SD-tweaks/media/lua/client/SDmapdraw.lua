require "ISUI/Maps/ISWorldMapSymbols"
require "ISUI/Maps/ISWorldMap"
require "ISUI/ISPanelJoypad"
require "ISUI/Maps/ISMap"

local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "[^ %;,]+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

-- Define colors with alpha channel
local alpha = 0.75
local symbolCoordinates = {}

function drawHatchedRectangleForZone(self, zoneName, spacingFactor, hatchSpacing, api)
	local zoneCoordinates = Zone.list[zoneName]

	if zoneCoordinates then
		local startX, startY = zoneCoordinates[1], zoneCoordinates[2]
		local endX, endY = zoneCoordinates[3], zoneCoordinates[4]

		local tier = SandboxVars.SDZones[zoneName]
		
		local mapAPI = self.mapAPI

		if tier ~= 1 then drawHatchedRectangle(self, startX, startY, endX, endY, spacingFactor, hatchSpacing, tier, mapAPI) end
	end
end

function drawHatchedRectangle(self, x1, y1, x2, y2, spacingFactor, hatchSpacing, tier, mapAPI)
	local sides = {{x1, y1, x2, y1}, {x2, y1, x2, y2}, {x2, y2, x1, y2}, {x1, y2, x1, y1}}

	for i=1,#sides do
		side = sides[i]
		drawMapLine(self, side[1], side[2], side[3], side[4], tier, mapAPI)
	end
end

function drawMapLine(self, x1, y1, x2, y2, tier, mapAPI)
	local distance = math.sqrt((x2 - x1)^2 + (y2 - y1)^2)

	local numSymbols = math.ceil(distance / 50)  -- Adjust the divisor as needed

	local spacingX = (x2 - x1) / numSymbols
	local spacingY = (y2 - y1) / numSymbols

	for i = 0, numSymbols do
		local symbolX = spacingX == 0 and x1 or x1 + i * spacingX
		local symbolY = spacingY == 0 and y1 or y1 + i * spacingY
		addMapSymbol(symbolX, symbolY, tier, mapAPI)
	end

end

function addMapSymbol(worldX, worldY, tier, mapAPI)
	--table.insert(symbolCoordinates, {mapAPI:worldToUIX(worldX, worldY), mapAPI:worldToUIY(worldX, worldY)})
	local texture = "Asterisk";
	
	local textureSymbol = mapAPI:getSymbolsAPI():addTexture(texture, worldX, worldY)
	if tier == 5 then
		textureSymbol:setRGBA(1, 0, 0, alpha) -- Red (Tier 5)
	elseif tier == 4 then
		textureSymbol:setRGBA(0.6, 0.125, 1, alpha) -- Purple (Tier 4)
	elseif tier == 3 then
		textureSymbol:setRGBA(1, 0.5, 0, alpha) -- Bright Orange (Tier 3)
	elseif tier == 2 then
		textureSymbol:setRGBA(1, 1, 0, alpha) -- Yellow (Tier 2)
	elseif tier == 1 then
		textureSymbol:setRGBA(0, 1, 0, alpha) -- Green (Tier 1)
	end
	textureSymbol:setAnchor(0.5, 0.5)
	textureSymbol:setScale(ISMap.SCALE*2.5)-- 3 seems to be a good multiplier. a range between 3-6 is ok, depending on how crisp you want the boundary to look. setting it lower may lead to gaps and might be harder to see.
end

local zoneX1, zoneY1, zoneX2, zoneY2, zoneTier, zoneName, zoneNested = nil, nil, nil, nil, nil, nil, nil
local modalMapAPI = nil

local function isTopLeft(x, y)
	if not x or not y then
		return "(Top Left Corner)"
	else
		return "("..x..","..y..")"
	end
end

local function isBottomRight(x, y)
	if not x or not y then
		return "(Bottom Right Corner)"
	else
		return "("..x..","..y..")"
	end
end

local function isZoneTier(tier)
	if not tier then
		return "[Tier #]"
	else
		return "["..tier.."]"
	end
end

local function isZoneName(name)
	if not name then
		return "(Zone Name)"
	else
		return "("..name..")"
	end
end
	
local function isZoneNested(nested)
	if not nested then
		return "Unnested"
	else
		return "Nested"
	end
end

function ISWorldMap:modalTier(button)
	if button.internal ~= "OK" then return end
	zoneTier = tonumber(button.parent.entry:getText())
end

function ISWorldMap:modalName(button)
	if button.internal ~= "OK" then return end
	zoneName = button.parent.entry:getText()
end

function ISWorldMap:modalNested(button)
	if button.internal == "YES" then
		zoneNested = "Nested"
	else
		zoneNested = nil
	end
end

function ISWorldMap:modalCenter(button)
	if button.internal ~= "OK" then return end
	local text = splitString(button.parent.entry:getText())
	local x, y = tonumber(text[1]), tonumber(text[2])
	modalMapAPI:centerOn(x, y)
	modalMapAPI = nil
end

local ModDataMapDrawTierZones = ModData.getOrCreate("MapDrawTierZones")

local ISWorldMap_onRightMouseUp = ISWorldMap.onRightMouseUp
function ISWorldMap:onRightMouseUp(x, y)
	local playerNum = 0
	local playerObj = getSpecificPlayer(0)
	local context = ISContextMenu.get(playerNum, x + self:getAbsoluteX(), y + self:getAbsoluteY())
	
	ISWorldMap_onRightMouseUp(self, x, y)
	
	local mapAPI = self.mapAPI
	
	context:addOptionOnTop("Center on Coordinate X,Y", self, 
	function()
		local modal = ISTextBox:new(0, 0, 280, 180, "Center Map on X,Y", "11072, 8851", nil, self.modalCenter, nil, 1,1,self)
		modal:initialise()
		modal:addToUIManager()
		modalMapAPI = self.mapAPI
	end)
	
	if isAdmin() or isDebugEnabled() then
		newmapzone 	= context:addOptionOnTop("Draw new map zone:", self, nil)
		submenu 	= ISContextMenu:getNew(context)
		context:addSubMenu(newmapzone, submenu)
		
		submenu:addOption("Define Zone Corner: " .. isTopLeft(zoneX1, zoneY1), self,
			function()
				zoneX1 = math.floor(self.mapAPI:uiToWorldX(x, y))
				zoneY1 = math.floor(self.mapAPI:uiToWorldY(x, y))
			end)
			
		submenu:addOption("Define Zone Corner: " .. isBottomRight(zoneX2, zoneY2), self,
			function()
				zoneX2 = math.floor(self.mapAPI:uiToWorldX(x, y))
				zoneY2 = math.floor(self.mapAPI:uiToWorldY(x, y))
			end)
		
		submenu:addOption("Define Zone Tier: " .. isZoneTier(zoneTier), self,
			function()
				local modal = ISTextBox:new(0, 0, 280, 180, "Define Zone Tier", "2", nil, self.modalTier, nil, 1,1,self)
				modal:initialise()
				modal:addToUIManager()
			end)
			
		submenu:addOption("Define Zone Name: " .. isZoneName(zoneName), self,
			function()
				local modal = ISTextBox:new(0, 0, 280, 180, "Define Zone Name", "Zone #" .. ZombRand(1,10000), nil, self.modalName, nil, 1,1,self)
				modal:initialise()
				modal:addToUIManager()
			end)
		
		submenu:addOption("Is Zone Nested - " .. isZoneNested(zoneNested), self,
			function()
				local player = 0
				local width = 350;
				local x = getPlayerScreenLeft(player) + (getPlayerScreenWidth(player) - width) / 2
				local height = 120;
				local y = getPlayerScreenTop(player) + (getPlayerScreenHeight(player) - height) / 2
				local modal1 = ISModalDialog:new(x,y, width, height, "Nest this zone?", true, self, self.modalNested, player);
				modal1:initialise()
				modal1:addToUIManager()
			end)	
		
		if zoneX1 and zoneY1 and zoneX2 and zoneY2 and zoneTier then
			context:addOptionOnTop("Draw Zone: [T"..zoneTier.."] ("..zoneX1..","..zoneY1..","..zoneX2..","..zoneY2..") on map", self,
				function()
					drawHatchedRectangle(self, zoneX1, zoneY1, zoneX2, zoneY2, 1.0, 750, zoneTier, mapAPI)
				end)
		end
		
		if zoneX1 and zoneY1 and zoneX2 and zoneY2 and zoneTier and zoneName and zoneNested then
			context:addOption("Add " .. isZoneNested(zoneNested) .. "Zone: [T"..zoneTier.."] "..zoneName.." ("..zoneX1..","..zoneY1..","..zoneX2..","..zoneY2..") to zones table", self,
				function()
					local zonesGMD = ModData.getOrCreate("MoreDifficultZones")
					zonesGMD[zoneName] = { zoneX1, zoneY1, zoneX2, zoneY2, zoneTier, zoneNested }
					ModData.transmit("MoreDifficultZones")
					zoneX1, zoneY1, zoneX2, zoneY2, zoneTier, zoneName, zoneNested = nil, nil, nil, nil, nil, nil, nil
				end)
		end		
		
	end
end
---------------------------------------------------------

local original_close = ISWorldMap.close
function ISWorldMap:close()
	original_close(self)
	ModDataMapDrawTierZones[getCurrentUserSteamID()] = "CLEARED"
end

local original_render = ISWorldMap.render
function ISWorldMap:render()
    original_render(self)
    if self.zone then
        local x, y, zoneinfo, zoneXY, zoneTally = self.zone[1], self.zone[2], self.zone[3], self.zone[4], self.zone[5]
		
		self:drawText(zoneTally, x, y-95, 0.1, 0.1, 0.1, 1, UIFont.Title)
        self:drawText(zoneinfo, x, y-65, 0.1, 0.1, 0.1, 1, UIFont.Title)
		self:drawText(zoneXY, x, y-35, 0.1, 0.1, 0.1, 1, UIFont.Title)
    end
	if ModDataMapDrawTierZones[getCurrentUserSteamID()] then
		local symbolsAPI = self.mapAPI:getSymbolsAPI()
		for i=symbolsAPI:getSymbolCount()-1, 0, -1 do
			local symbol = symbolsAPI:getSymbolByIndex(i)
			if symbol:getSymbolID() == "Asterisk" or symbol:getSymbolID() == "square" then
				symbolsAPI:removeSymbolByIndex(i)
			end
		end
		
		for i=1,#ZoneNames do
			drawHatchedRectangleForZone(self, ZoneNames[i], 1.0, 750, self.mapAPI)
		end

		ModDataMapDrawTierZones[getCurrentUserSteamID()] = false
	end
end


local original_onMouseMove = ISWorldMap.onMouseMove
function ISWorldMap:onMouseMove(dx, dy)
    original_onMouseMove(self, dx, dy)

    local mouseX = self:getMouseX()
    local mouseY = self:getMouseY()

    local worldX = math.floor(self.mapAPI:uiToWorldX(mouseX, mouseY))
    local worldY = math.floor(self.mapAPI:uiToWorldY(mouseX, mouseY))

    local tier, zonename, x, y, control, toxic = checkZoneAtXY(worldX, worldY)
	
	if zonename == "Unnamed Zone" then zonename = "Default" end
	local sprinter = SandboxVars.SDRandomZombies[zonename] 
	local pinpoint = SandboxVars.SDRandomZombies["Pinpoint"..zonename]
	
	local controlText = ""
	local toxicText = ""

	local controlledZone = ModData.getOrCreate("FactionControlledZones")
	if controlledZone[zonename] then
		controlText = controlledZone[zonename]
	else
		controlText = "n/a"
	end
	
	if toxic then
		toxicText = "Toxic Zone "
	end
	
	local zonesData = ModData.getOrCreate("zonesData")
	local zonesTally = ""
	if zonesData[zonename] then
		for k,v in pairs(zonesData[zonename]) do
			zonesTally = zonesTally .. k .. ":" .. v .. " "
		end
	end
	
	local zoneinfo = toxicText .. "[T"..tier.."] " .. zonename .. " - Sprinter="..sprinter.. "% Pinpoint="..pinpoint.."%"
	local zoneXY = "("..worldX..","..worldY..") Controlled by:" .. controlText
	
	self.zone = { mouseX, mouseY, zoneinfo, zoneXY , zonesTally}
end

local function zonesData()
	ModData.request("zonesData")
end
if not isServer() then Events.EveryTenMinutes.Add(zonesData) end