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

		local tier = zoneCoordinates[5] --SandboxVars.SDZones[zoneName]
		
		local mapAPI = self.mapAPI

		if tier then drawHatchedRectangle(self, startX, startY, endX, endY, spacingFactor, hatchSpacing, tier, mapAPI) end
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
		local newmapzone 	= context:addOptionOnTop("Draw new map zone:", self, nil)
		local submenu 	= ISContextMenu:getNew(context)
		context:addSubMenu(newmapzone, submenu)
		
		submenu:addOption("Define Zone Corner: " .. isTopLeft(zoneX1, zoneY1), self,
			function()
				zoneX1 = math.floor(self.mapAPI:uiToWorldX(x, y))
				zoneY1 = math.floor(self.mapAPI:uiToWorldY(x, y))
				addMapSymbol(zoneX1, zoneY1, 0, mapAPI)
				if zoneX2 then addMapSymbol(zoneX2, zoneY1, 0, mapAPI) end
				if zoneY2 then addMapSymbol(zoneX1, zoneY2, 0, mapAPI) end
			end)
			
		submenu:addOption("Define Zone Corner: " .. isBottomRight(zoneX2, zoneY2), self,
			function()
				zoneX2 = math.floor(self.mapAPI:uiToWorldX(x, y))
				zoneY2 = math.floor(self.mapAPI:uiToWorldY(x, y))
				addMapSymbol(zoneX2, zoneY2, 0, mapAPI)
				if zoneX1 then addMapSymbol(zoneX1, zoneY2, 0, mapAPI) end
				if zoneY1 then addMapSymbol(zoneX2, zoneY1, 0, mapAPI) end
			end)
		
		if zoneX1 and zoneY1 and zoneX2 and zoneY2 then
			submenu:addOption("Define Zone Parameters", self, 
				function()
					local MapPanel = SDmap.CreateNewZone:new(getMouseX(), getMouseY(), 250, 325, zoneX1, zoneY1, zoneX2, zoneY2, self.mapAPI);
					MapPanel:initialise();
					MapPanel:addToUIManager();
					zoneX1, zoneY1, zoneX2, zoneY2 = nil, nil, nil, nil
				end)
		end

		if self.zone and self.zone[6] ~= "Default" then

			local _zoneinfo = self.zone[3]
			local _zonename = self.zone[6]
			local _zone = Zone.list[_zonename]
			local zx1, zy1, zx2, zy2, ztier = _zone[1], _zone[2], _zone[3], _zone[4], _zone[5]
			local zinfo = "[T" .. ztier .. "] " .. _zonename
			
			local d_zone 	= context:addOptionOnTop("Delete zone: " .. zinfo, self, nil)
			submenu1 		= ISContextMenu:getNew(context)
			context:addSubMenu(d_zone, submenu1)
			
			local _confirm 	= submenu1:addOption("CONFIRM DELETION OF: " .. zinfo, self, nil)
			submenu2 		= ISContextMenu:getNew(submenu1)
			submenu1:addSubMenu(_confirm, submenu2)
			
			submenu2:addOptionOnTop("DELETE: " .. zinfo, self,
				function()
					local zonesGMD = ModData.getOrCreate("MoreDifficultZones")
					zonesGMD[_zonename] = "DELETE"
					Zone.list[_zonename] = nil
					NestedZone.list[_zonename] = nil
					ZoneNames = getZoneNames(Zone.list)
					NestedZoneNames = getZoneNames(NestedZone.list)
					zoneX1, zoneY1, zoneX2, zoneY2, zoneTier, zoneName, zoneNested = nil, nil, nil, nil, nil, nil, nil
					
					local symbolsAPI = self.mapAPI:getSymbolsAPI()
					for i=symbolsAPI:getSymbolCount()-1, 0, -1 do
						local symbol = symbolsAPI:getSymbolByIndex(i)
						if symbol:getSymbolID() == "Asterisk" then
							symbolsAPI:removeSymbolByIndex(i)
						end
					end
					
					for i=1,#ZoneNames do
						drawHatchedRectangleForZone(self, ZoneNames[i], 1.0, 750, self.mapAPI)
					end

					ModDataMapDrawTierZones[getCurrentUserSteamID()] = false
					ModData.transmit("MoreDifficultZones")
				end)
			
			local e_zone 	= context:addOptionOnTop("Edit " .. self.zone[3], self, 
									function()
										local MapPanel = SDmap.MapPanel:new(getMouseX(), getMouseY(), 250, 325, self.zone, self.mapAPI);
										MapPanel:initialise();
										MapPanel:addToUIManager();
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
		
		self:drawText(zoneTally, x, y-95, 0.1, 0.1, 0.1, 1, UIFont.Large)
        self:drawText(zoneinfo, x, y-65, 0.1, 0.1, 0.1, 1, UIFont.Large)
		self:drawText(zoneXY, x, y-35, 0.1, 0.1, 0.1, 1, UIFont.Large)
		--[[self.tooltip.description = 	zoneTally .. "\n" ..
									zoneinfo ..  "\n" ..
									zoneXY]]
    end
	if ModDataMapDrawTierZones[getCurrentUserSteamID()] then
		local symbolsAPI = self.mapAPI:getSymbolsAPI()
		for i=symbolsAPI:getSymbolCount()-1, 0, -1 do
			local symbol = symbolsAPI:getSymbolByIndex(i)
			if symbol:getSymbolID() == "Asterisk" then
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

    local tier, zonename, x, y, control, toxic, sprinter, pinpoint, cognition, zhealth = checkZoneAtXY(worldX, worldY)
	
	if zonename == "Unnamed Zone" then zonename = "Default" end
	sprinter = sprinter or 0 
	pinpoint = pinpoint or 0
	cognition = cognition or 0
	
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
	
	local zhealth = zhealth or 2.1
	local zoneinfo = toxicText .. "[T"..tier.."] " .. zonename .. " - Sprinter="..sprinter.. "% Pinpoint="..pinpoint.. "% Cognition="..cognition.."%" .. " ZombieHealth=" .. math.floor(zhealth/1.7*100+0.5) .. "%"
	local zoneXY = "("..worldX..","..worldY..") Controlled by:" .. controlText
	
	self.zone = { mouseX, mouseY, zoneinfo, zoneXY , zonesTally, zonename, zonetier}
end

local function zonesData()
	ModData.request("zonesData")
end
if not isServer() then Events.EveryTenMinutes.Add(zonesData) end