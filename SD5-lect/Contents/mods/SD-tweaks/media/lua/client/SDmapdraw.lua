require "ISUI/Maps/ISWorldMapSymbols"
require "ISUI/Maps/ISWorldMap"
require "ISUI/ISPanelJoypad"
require "ISUI/Maps/ISMap"
require "SDZoneCheck"

-- Define colors with alpha channel
local alpha = 0.05

-- assign colors to tiers. Last in first out, otherwise you will skip nested tiers.
function getColorForTier(tier)
	if tier == 4 then
		return {0.8, 0.8, 0, alpha}
	elseif tier == 3 then
		return {1, 0.5, 0, alpha}
	elseif tier == 2 then
		return {1, 0, 0, alpha}
	end
end
--no color for tier 1 zones because anything not defined is tier 1

--initialize symbol coordinates table. not used at the moment because of too much overhead. similar issue to BTSE copy tool, doing this one line at a time is horrible.
local symbolcoordinates = {}

-- Function to draw a hatched rectangle for a specific zone
function drawHatchedRectangleForZone(self, zoneName, spacingFactor, hatchSpacing, api)
	local zoneCoordinates = Zone.list[zoneName]

	if zoneCoordinates then
		for i = 1, #zoneCoordinates do
			local startX, startY = zoneCoordinates[1], zoneCoordinates[2]
			local endX, endY = zoneCoordinates[3], zoneCoordinates[4]

			-- Determine color based on tier
			local tier = SandboxVars.SDZones[zoneName]
--			local color = getColorForTier(tier)
			--print(zoneName, tier, color)
			
			local mapAPI = self.mapAPI

			-- Draw a hatched rectangle
			if tier ~= 1 then drawHatchedRectangle(self, startX, startY, endX, endY, spacingFactor, hatchSpacing, tier, mapAPI) end
		end
	end
end

--another draw function for nested zones. split into two functions for clarity, not necessary to combine imo. eventually can combine the zone and nested zone and just force the nested zone to be on the bottom of the array and do a recursive check, first->last then last->first to check for nested zones. more overhead with long arrays though, hence why i split them.
function drawHatchedRectangleForNestedZone(self, zoneName, spacingFactor, hatchSpacing, api)
	local zoneCoordinates = NestedZone.list[zoneName]

	if zoneCoordinates then
		for i = 1, #zoneCoordinates do
			local startX, startY = zoneCoordinates[1], zoneCoordinates[2]
			local endX, endY = zoneCoordinates[3], zoneCoordinates[4]

			-- Determine color based on tier
			local tier = SandboxVars.SDZones[zoneName]
			--local color = getColorForTier(tier)
			
			local mapAPI = self.mapAPI

			-- Draw a hatched rectangle
			if tier ~= 1 then drawHatchedRectangle(self, startX, startY, endX, endY, spacingFactor, hatchSpacing, tier, mapAPI) end
		end
	end
end

-- Function to draw a hatched rectangle
function drawHatchedRectangle(self, x1, y1, x2, y2, spacingFactor, hatchSpacing, tier, mapAPI)
	-- Draw the main rectangle
	local sides = {{x1, y1, x2, y1}, {x2, y1, x2, y2}, {x2, y2, x1, y2}, {x1, y2, x1, y1}}

	for _, side in ipairs(sides) do
		drawMapLine(self, side[1], side[2], side[3], side[4], tier, mapAPI)
	end

	-- Hatch the rectangle with diagonal splines. didn't spend much time checking if this actually works because filling in the polygons would increase the number of symbols by an order of magnitude.
	--local diagonalSpacing = hatchSpacing
	--local diagonalAngle = math.atan2(y2 - y1, x2 - x1)
	--local diagonalLength = math.sqrt((x2 - x1)^2 + (y2 - y1)^2)

	--for i = 0, diagonalLength, diagonalSpacing do
	--	local startX = x1 + i * math.cos(diagonalAngle)
	--	local startY = y1 + i * math.sin(diagonalAngle)

	--	local endX = startX + spacingFactor * diagonalSpacing * math.cos(diagonalAngle + spacingFactor * math.pi / 4)
	--	local endY = startY + spacingFactor * diagonalSpacing * math.sin(diagonalAngle + spacingFactor * math.pi / 4)

	--	drawMapLine(self, startX, startY, endX, endY, color, mapAPI)
	--end
end

-- Function to draw a line between two points
function drawMapLine(self, x1, y1, x2, y2, tier, mapAPI)
	-- Calculate the number of symbols to draw between the points
	local distance = math.sqrt((x2 - x1)^2 + (y2 - y1)^2)

	-- Adjust the number of symbols based on the distance
	local numSymbols = math.ceil(distance / 35)  -- Adjust the divisor as needed

	-- Calculate the spacing between symbols
	local spacingX = (x2 - x1) / numSymbols
	local spacingY = (y2 - y1) / numSymbols

	for i = 0, numSymbols do
		local symbolX = spacingX == 0 and x1 or x1 + i * spacingX
		local symbolY = spacingY == 0 and y1 or y1 + i * spacingY
		-- Save coordinates to symbol coordinate table. Abandon for now, creates a table of tens of thousands of entries. not practical.
		--addCoordinate(symbolX, symbolY)
		-- Draw a symbol at each calculated position
		addMapSymbol(symbolX, symbolY, tier, mapAPI)
	end

end

-- make a spline using symbols. there are no good annotations to use and i don't want to make a custom one, just blank it and it fills it in with a square..
function addMapSymbol(worldX, worldY, tier, mapAPI)
	local texture = "Asterisk";
	
	local textureSymbol = mapAPI:getSymbolsAPI():addTexture(texture, worldX, worldY)
	--local MapSymbol = "---------------------------------------------------------------------------"
	--local textureSymbol = mapAPI:getSymbolsAPI():addUntranslatedText(MapSymbol, UIFont.Handwritten, worldX, worldY)
	if tier == 4 then
		textureSymbol:setRGBA(1, 0, 0, alpha) -- Red (Tier 4)
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

--draw map on render, add a mod data parameter and set to true if map is drawn. that way it's not drawing the boundaries every tick (can take half a sec or so with ~50,000 points, computational overhead seems high so lets avoid).
local ISWorldMap_render = ISWorldMap.render
function ISWorldMap:render()
	ISWorldMap_render(self)
	local ModDataMapDrawTierZones = ModData.getOrCreate("MapDrawTierZones")

	local drawonce = ModDataMapDrawTierZones[getCurrentUserSteamID()] or false

	if not drawonce then
		for _, zoneName in ipairs(ZoneNames) do
			--zoneName = "Southwood"
			--print("drew rectangle for zone:", zoneName)
			drawHatchedRectangleForZone(self, zoneName, 1.0, 750, mapAPI)--750 is hatch spacing, does nothing at the moment. passing down the mapAPI isn't necessary and is back when i was trying to use mousemove to pass down the api to my functions. not necessary, but doesn't do anything atm either.
		end

		for _, nestedZoneName in ipairs(NestedZoneNames) do
			--print("drew rectangle for nestedzone:", nestedZoneName)
			drawHatchedRectangleForNestedZone(self, nestedZoneName, 1.0, 750, mapAPI)--750 is hatch spacing, does nothing, does nothing at the moment
		end
		ModDataMapDrawTierZones[getCurrentUserSteamID()] = true
		--print("map tier boundaries drawn, setting true")
		return
	end
end

---------------------------------------------------------
-- Function to add a coordinate pair to the table. KILLS PERFORMANCE. just clear the map of symbols instead (rip to all player annotations though)
function addCoordinate(x, y)
	local coordinate = {x = x, y = y}
	table.insert(symbolcoordinates, coordinate)
end

-- Function to erase symbols at the specified coordinates. function not used at the moment until i figure out a better way to delete just the boundary zone markings without destroying cpu.
function eraseSymbolsAtCoordinates(symbolcoordinates, mapAPI)
	local symbolsAPI = mapAPI:getSymbolsAPI()

	for _, coord in ipairs(symbolcoordinates) do
		print("X: ", coord.x, "   Y: ", coord.y)
		local index = symbolsAPI:hitTest(coord.x, coord.y)
		if index ~= -1 then
			symbolsAPI:removeSymbolByIndex(index)
		end
	end
end
---------------------------------------------------------
-- Right click context menu on worldmap, adding context options to erase all markings or redraw the zone bounds
local ISWorldMap_onRightMouseUp = ISWorldMap.onRightMouseUp
function ISWorldMap:onRightMouseUp(x, y)
	local playerNum = 0
	local playerObj = getSpecificPlayer(0)
	local context = ISContextMenu.get(playerNum, x + self:getAbsoluteX(), y + self:getAbsoluteY())
	
	--call original function. seems to need local params above in order to be recalled. not sure why, could just be my own error while testing. but need the params anyway to define the context so :shrug:
	ISWorldMap_onRightMouseUp(self, x, y)
	
	local ModDataMapDrawTierZones = ModData.getOrCreate("MapDrawTierZones")
	
	local mapAPI = self.mapAPI
	-- remove markings. just clear out the whole map, the overhead to doing it one-by-one is not feasible.
	-- set flag true so that render tick doesn't redraw the boundaries
	local option = context:addOption("Clear All Map Markings", self,
	function()
		ModDataMapDrawTierZones[getCurrentUserSteamID()] = true
		--eraseSymbolsAtCoordinates(symbolcoordinates, mapAPI)--don't use, will take a really long time. similiar to BTSE copy tool, doing it one element at a time is slow. potentially a hundred thousand points to delete, would take 15 minutes if BTSE copy tool is any indication of performance. plus i don't do it as intelligently as BTSE tool so it locks the game while it's doing it...
		mapAPI:getSymbolsAPI():clear()
	end)
	-- set flag false, map will redraw on render tick
	local option = context:addOption("Redraw Tier Zone Boundary Lines", self,
	function()
		ModDataMapDrawTierZones[getCurrentUserSteamID()] = false
	end)
end
---------------------------------------------------------