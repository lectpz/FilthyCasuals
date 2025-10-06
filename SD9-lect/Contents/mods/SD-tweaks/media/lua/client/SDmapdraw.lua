require "ISUI/Maps/ISWorldMapSymbols"
require "ISUI/Maps/ISWorldMap"
require "ISUI/ISPanelJoypad"
require "ISUI/Maps/ISMap"

local green = " <RGB:" .. getCore():getGoodHighlitedColor():getR() .. "," .. getCore():getGoodHighlitedColor():getG() .. "," .. getCore():getGoodHighlitedColor():getB() .. "> "
local red = " <RGB:" .. getCore():getBadHighlitedColor():getR() .. "," .. getCore():getBadHighlitedColor():getG() .. "," .. getCore():getBadHighlitedColor():getB() .. "> "

local yellow = " <RGB:1,0,0> "
local orange = " <RGB:1,0.5,0> "
local gold = " <RGB:0.83,0.68,0.21> "
local blue = " <RGB:0.2,0.5,1> "
local purple = " <RGB:0.62,0.12,0.94> "

local white = " <RGB:1,1,1> "

local factions = {"COG", "Ranger", "VoidWalker"}
local SDFactions = {}
for i=1,#factions do
	SDFactions[factions[i]]=true
end

local weeklyGlobalRewards = {}
local weeklyFactionRewards = {}

local function parseKills()
	local zones = ModData.getOrCreate("zonesData")
	
	local faction = { "COG", "Ranger", "VoidWalker" }
	local function checkControl(city, faction)
		if not zones[city] or not zones[city][faction] or not Zone.list[city] then return false end
		return zones[city][faction] / 1000 >= Zone.list[city][5]
	end	
	
	--print("[sdLogger] SD9 Reward System Parse Begin")
	--reset global rewards
	weeklyGlobalRewards.perfectlyBalanced = false
	weeklyGlobalRewards.FilthyCasuals = false
	weeklyGlobalRewards.SweatyTryhards = false
	weeklyGlobalRewards.concertedEfforts = false
	weeklyGlobalRewards.unquenchableThirst = false

	--reset faction rewards
	for i=1,6 do
		weeklyFactionRewards["COG_T"..i] = false
		weeklyFactionRewards["Ranger_T"..i] = false
		weeklyFactionRewards["VoidWalker_T"..i] = false
	end

	--aggregate rewards, set flag to true
	--print("=============================")
	--print("GLOBAL KILLS")
	--[[for k,v in pairs(zones) do
		local kills = 0
		if string.match(k,"_global") then
			kills = kills + v
			if kills >= 50000 then
				weeklyGlobalRewards.FilthyCasuals = true
			else
				weeklyGlobalRewards.FilthyCasuals = false
			end
		end
		----print(kills)
	end]]
	for i=1, #factions do
		local kills = 0
		for k,v in pairs(zones) do
			if string.match(k,factions[i].."_global") then
				kills = kills + v
			end
		end
		if kills >= 50000 then
			weeklyGlobalRewards.FilthyCasuals = true
		else
			weeklyGlobalRewards.FilthyCasuals = false
			break
		end
	end
	
	--print(weeklyGlobalRewards.FilthyCasuals)
	--print("=============================")

	--print("=============================")
	--print("GLOBAL 250k KILLS")
	--[[local globalKills = 0
	for k,v in pairs(zones) do
		if string.match(k,"_global") then
			globalKills = globalKills + zones[k]
		end
		if globalKills >= 250000 then
			weeklyGlobalRewards.unquenchableThirst = true
		else
			weeklyGlobalRewards.unquenchableThirst = false
			break
		end
	end]]
	local globalKills = 0
	for i=1, #factions do
		for k,v in pairs(zones) do
			if string.match(k,factions[i].."_global") then
				globalKills = globalKills + v
			end
		end
		if globalKills >= 250000 then
			weeklyGlobalRewards.unquenchableThirst = true
		end
	end
	--print(weeklyGlobalRewards.unquenchableThirst)
	--print("=============================")

	--print("=============================")
	--print("SWEATY TRYHARD AND CONCERTED EFFORTS T6 KILLS")

	local t6kills = {}
	t6kills["COG"] = 0
	t6kills["Ranger"] = 0
	t6kills["VoidWalker"] = 0
	for k,v in pairs(zones) do
		if not string.match(k,"_global") and k ~= "Unnamed Zone" then
			if Zone.list[k] and Zone.list[k][5] == 6 then
				----print("zone:",k)
				for m,n in pairs(v) do
					if t6kills[m] and n then
						----print("	faction:",m)
						----print("	kills:",n)
						t6kills[m]=t6kills[m]+n
					end
				end
				--for k,v in pairs(t6kills) do --print(k,v) end
			end
		end
	end
	if t6kills["COG"] > 20000 and t6kills["Ranger"] > 20000 and t6kills["VoidWalker"] > 20000 then
		weeklyGlobalRewards.concertedEfforts = true
	end
	if t6kills["COG"] + t6kills["Ranger"] + t6kills["VoidWalker"] > 80000 then
		weeklyGlobalRewards.SweatyTryhards = true
	end

	--print(weeklyGlobalRewards.SweatyTryhards)
	--print(weeklyGlobalRewards.concertedEfforts)
	--print("=============================")


	--print("=============================")
	--print("LOCAL KILLS")
	for k,v in pairs(zones) do
		if not string.match(k,"_global") and k ~= "Unnamed Zone" then
			----print(k,v)
			if Zone.list[k] then
				local tier = Zone.list[k][5]
				----print(k, tier)

				for m,n in pairs(v) do
					----print(" ",m,n)
					if tier and SDFactions[m] and n and n >= tier*1000 then
						----print(m, n, tier*1000)
						----print(m)
						weeklyFactionRewards[m.."_T"..tier]=true
						--print(k.."["..tier.."]"..":"..m)
					end
				end
			end
		end
	end
	--print("=============================")


	--print("=============================")
	--print("calculate zone notoriety balance")

	for k,v in pairs(zones) do
		if not string.match(k,"_global") and k ~= "Unnamed Zone" and k ~= "CC" then
		--print(k,Zone.list[k][5])
			if checkControl(k,faction[1]) and checkControl(k,faction[2]) and checkControl(k,faction[3]) then
				weeklyGlobalRewards.perfectlyBalanced = true
			else
				weeklyGlobalRewards.perfectlyBalanced = false
				break
			end
		end
	end
	--print(weeklyGlobalRewards.perfectlyBalanced)
	--print("=============================")

	--print("[sdLogger] SD9 Reward System Parse End")
end

local function parseRewards()
	for k,v in pairs(weeklyGlobalRewards) do
		if v then
			print("inv:AddItem(Base.WeeklyGlobalReward_"..k..")")
		end
	end

	for i=1,3 do
		for k,v in pairs(weeklyFactionRewards) do
			if v and string.match(k,faction[i]) then
				print("inv:AddItem(Base.WeeklyFactionReward_"..k..")")
			end
		end
	end
end

local function splitString(sandboxvar)
	local ztable = {}
	local pattern = "[^ %;,]+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local gRewardTypes = {
	"perfectlyBalanced",
	"FilthyCasuals",
	"unquenchableThirst",
	"SweatyTryhards",
	"concertedEfforts",
	}

local mdFaction
local o_ISWorldMap_new = ISWorldMap.new
function ISWorldMap:new(x, y, width, height)
	local o = o_ISWorldMap_new(self, x, y, width, height)
	
	mdFaction = getSpecificPlayer(0):getModData().faction
	parseKills()
	
	self.factionRewards = nil
	self.globalRewards = nil
	
	if SandboxVars and SandboxVars.SDGlobalRewards then
		local globalLine = {"<RGB:1,1,0>Global Rewards:"}
		
		for i=1,#gRewardTypes do
			local split = splitString(SandboxVars.SDGlobalRewards[gRewardTypes[i]])
			local sandboxString = "  "
			for j=1,#split do
				local displayName = ScriptManager.instance:getItem(split[j]):getDisplayName()
				local color = red
				if weeklyGlobalRewards[gRewardTypes[i]] then color = green end
				sandboxString = color .. sandboxString .. displayName .." <LINE> "
			end
			table.insert(globalLine, gold .. "Objective: " .. gRewardTypes[i] .. " <LINE> " ..  sandboxString)
		end
		
		self.globalRewards = table.concat(globalLine, " <LINE> <LINE> ")
		
		local factionLine = {"<RGB:1,1,0>Faction Rewards:"}
		for i=1,6 do
			local split = splitString(SandboxVars.SDGlobalRewards["T"..i])
			local sandboxString = "  "
			for j=1,#split do
				local displayName = ScriptManager.instance:getItem(split[j]):getDisplayName()
				local color = red
				if weeklyFactionRewards[mdFaction.."_T"..i] then color = green end
				sandboxString = color .. sandboxString .. displayName .." <LINE> "
			end
			table.insert(factionLine, gold .. "Objective: T" .. i .. " <LINE> " ..  sandboxString)
		end
		
		self.factionRewards = table.concat(factionLine, " <LINE> <LINE> ")
		
	else
		self.factionRewards = "<RGB:1,0,0>Error: Faction Rewards not found."
		self.globalRewards = "<RGB:1,0,0>Error: Global Rewards not found."
	end
	
	return o
end

local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "[^ %;,]+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

-- Define colors with alpha channel
local alpha = 0.6
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
	if tier == 6 then
		textureSymbol:setRGBA(0, 1, 1, alpha) -- Cyan (Tier 6)
	elseif tier == 5 then
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

local cc_coords = {
	11200, 8806, 11280, 8883,--east shops
	11108, 8778, 11152, 8816,--north shops
	11165, 8775, 11233, 8796,--north shops 2
	11120, 8885, 11139, 8933,--south shops 1
	11139, 8885, 11280, 8991,--south shops 2
	11247, 8771, 11327, 8994,--east shops 2
}

local function checkCCshopCoords(x, y, coords)
	for i=1, #coords, 4 do
		local xa, ya, xb, yb = coords[i], coords[i+1], coords[i+2], coords[i+3]
		if x >= xa and y >= ya and x <= xb and y <= yb then return true end
	end
	return false
end

local ISWorldMap_onRightMouseUp = ISWorldMap.onRightMouseUp
function ISWorldMap:onRightMouseUp(x, y)
	local playerNum = 0
	local playerObj = getSpecificPlayer(0)
	local context = ISContextMenu.get(playerNum, x + self:getAbsoluteX(), y + self:getAbsoluteY())
	
	ISWorldMap_onRightMouseUp(self, x, y)
	
	local mapAPI = self.mapAPI

	--[[context:addOptionOnTop("Center on Coordinate X,Y", self, 
	function()
		local modal = ISTextBox:new(0, 0, 280, 180, "Center Map on X,Y", "11072, 8851", nil, self.modalCenter, nil, 1,1,self)
		modal:initialise()
		modal:addToUIManager()
		modalMapAPI = self.mapAPI
	end)]]
	
	--[[context:addOptionOnTop("Remove old map zone asterisks", self, 
	function()
		local symbolsAPI = self.mapAPI:getSymbolsAPI()
		local symCount = symbolsAPI:getSymbolCount()
		if symCount and symCount ~= 0 then
			for i=symCount, 0, -1 do
				local symIndex = symbolsAPI:getSymbolByIndex(i)
				if symIndex then
					local symID = symIndex:getSymbolID()
					if symID and symID == "Asterisk" then
						symbolsAPI:removeSymbolByIndex(i)
					end
				end
			end
		end
	end)]]

    local worldX = math.floor(self.mapAPI:uiToWorldX(x, y))
    local worldY = math.floor(self.mapAPI:uiToWorldY(x, y))	
	
	if checkCCshopCoords(worldX, worldY, cc_coords) then
	
		local tier, zone = checkZone()
		if zone == "CC" then
			context:addOptionOnTop("Teleport to this shop location: " .. worldX .. "," .. worldY .. ",0", self, 
			function()
				playerObj:setX(worldX)
				playerObj:setY(worldY)
				playerObj:setZ(0)
				playerObj:setLx(worldX)
				playerObj:setLy(worldY)
				playerObj:setLz(0)
			end)
		end
	
	end
	
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
					
					--for i=1,#ZoneNames do
						--drawHatchedRectangleForZone(self, ZoneNames[i], 1.0, 750, self.mapAPI)
					--end

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
	mdFaction=nil
end

local MapMarkerSystem = require("MapMarkerSystem/Shared");
--100% credit to the renderAreaMarker system goes to Elyon.
--below is a compatibility function to utilize Elyon's system. we don't use Elyon's input system, so a local function is used.
--we migrate the zones params over to the marker table and draw the lines per Elyon's function.
---@param self ISWorldMap|ISMiniMapInner
---@param marker table
local function elyon_renderAreaMarker(self, marker)
    if not self.javaObject then return; end
    local api = self.javaObject:getAPI();
    if not api then return; end

    local nwX, nwY = marker.coordinates.nw.x, marker.coordinates.nw.y;
    local seX, seY = marker.coordinates.se.x, marker.coordinates.se.y;

    local neX, neY = seX, nwY;
    local swX, swY = nwX, seY;

    local uiNWX, uiNWY = api:worldToUIX(nwX, nwY), api:worldToUIY(nwX, nwY);
    local uiNEX, uiNEY = api:worldToUIX(neX, neY), api:worldToUIY(neX, neY);
    local uiSWX, uiSWY = api:worldToUIX(swX, swY), api:worldToUIY(swX, swY);
    local uiSEX, uiSEY = api:worldToUIX(seX, seY), api:worldToUIY(seX, seY);

    local absX, absY = self:getAbsoluteX(), self:getAbsoluteY();
    uiNWX, uiNWY = uiNWX + absX, uiNWY + absY;
    uiNEX, uiNEY = uiNEX + absX, uiNEY + absY;
    uiSWX, uiSWY = uiSWX + absX, uiSWY + absY;
    uiSEX, uiSEY = uiSEX + absX, uiSEY + absY;

    local function drawLine(x1, y1, x2, y2, r, g, b, a)
        local thickness = 5;
        local dx, dy = x2 - x1, y2 - y1;
        local angle = math.atan2(dy, dx);

        local offsetX = math.sin(angle) * thickness / 2;
        local offsetY = math.cos(angle) * thickness / 2;

        local x1Top, y1Top = x1 + offsetX, y1 - offsetY;
        local x1Bottom, y1Bottom = x1 - offsetX, y1 + offsetY;
        local x2Top, y2Top = x2 + offsetX, y2 - offsetY;
        local x2Bottom, y2Bottom = x2 - offsetX, y2 + offsetY;

        self.javaObject:DrawTexture(nil, x1Top, y1Top, x2Top, y2Top, x2Bottom, y2Bottom, x1Bottom, y1Bottom, r, g, b, a);
    end

    self:setStencilRect(0, 0, self.width, self.height);
    if marker.name and marker.isNameEnabled then
        local markerNameScale = marker.scaleName or 1;
        local markerFont = UIFont[marker.nameFont or MapMarkerSystem.FontList[1]];
        local markernameColor = marker.colorName or { r = 0.0, g = 0.0, b = 0.0, a = 1.0 };
        local textHeight = getTextManager():MeasureStringY(markerFont, marker.name);
        self:drawTextZoomed(marker.name, uiNWX + 10, uiNWY - textHeight, markerNameScale, markernameColor.r,
            markernameColor.g, markernameColor.b, markernameColor.a, markerFont);
    end

    drawLine(uiNWX, uiNWY, uiNEX, uiNEY, marker.color.r, marker.color.g, marker.color.b, alpha);
    drawLine(uiNEX, uiNEY, uiSEX, uiSEY, marker.color.r, marker.color.g, marker.color.b, alpha);
    drawLine(uiSEX, uiSEY, uiSWX, uiSWY, marker.color.r, marker.color.g, marker.color.b, alpha);
    drawLine(uiSWX, uiSWY, uiNWX, uiNWY, marker.color.r, marker.color.g, marker.color.b, alpha);
    self:clearStencilRect();
end

local function drawRewardText(self, rewardTitle, gx, gy, test)
	if not test then
		return self.drawText(rewardTitle .. "(INCOMPLETE)", gx, gy, 0.1, 0.1, 0.1, 1, UIFont.Medium)
	else
		return self.drawText(rewardTitle .. "(COMPLETE)", gx, gy, 0.1, 0.1, 0, 1, UIFont.Medium)
	end
end

local function textColor(test)
	if not test then
		return 0.65, 0, 0
	else
		return 0, 0.35, 0
	end
end

local count = 0
local original_render = ISWorldMap.render
function ISWorldMap:render()
    original_render(self)
	
	if not mdFaction then
		mdFaction = getSpecificPlayer(0):getModData().faction
		parseKills()
	end
	
	for i=1,#ZoneNames do
		local marker = {}
		marker.coordinates = {}
		marker.coordinates.nw = {}
		marker.coordinates.se = {}
		marker.color = {}
		
		marker.name = ZoneNames[i]
		marker.isNameEnabled = false
		
		local zoneCoordinates = Zone.list[marker.name]

		marker.maxZoomLevel = 100
		marker.coordinates.nw.x, marker.coordinates.nw.y = zoneCoordinates[1], zoneCoordinates[2]
		marker.coordinates.se.x, marker.coordinates.se.y = zoneCoordinates[3], zoneCoordinates[4]
		if zoneCoordinates[5] == 6 then
			marker.color.r, marker.color.g, marker.color.b = 0, 1, 1
		elseif zoneCoordinates[5] == 5 then
			marker.color.r, marker.color.g, marker.color.b = 1, 0, 0
		elseif zoneCoordinates[5] == 4 then
			marker.color.r, marker.color.g, marker.color.b = 0.6, 0.125, 1
		elseif zoneCoordinates[5] == 3 then
			marker.color.r, marker.color.g, marker.color.b = 1, 0.5, 0
		elseif zoneCoordinates[5] == 2 then
			marker.color.r, marker.color.g, marker.color.b = 1, 1, 0
		elseif zoneCoordinates[5] == 1 then
			marker.color.r, marker.color.g, marker.color.b = 0, 1, 0
		end
		
		elyon_renderAreaMarker(self, marker)
	end
	
    if self.zone then
        local x, y, zoneinfo, zoneXY, zoneTally, zonename, globalTally = self.zone[1], self.zone[2], self.zone[3], self.zone[4], self.zone[5], self.zone[6], self.zone[8]
		
		--[[if not self.tooltip.hoverSection then
			self:drawText(zoneTally, x, y-95, 0.1, 0.1, 0.1, 1, UIFont.Large)
			self:drawText(zoneinfo, x, y-65, 0.1, 0.1, 0.1, 1, UIFont.Large)
			self:drawText(zoneXY, x, y-35, 0.1, 0.1, 0.1, 1, UIFont.Large)
		end]]
		local gx, gy = 10, 40
		self:drawText("Global Kills:", gx, gy, 0.1, 0.1, 0.1, 1, UIFont.Large)
		for i=1,#globalTally do
			gy = gy + 25
			self:drawText(globalTally[i], gx+10, gy, 0.1, 0.1, 0.1, 1, UIFont.Medium)
		end
		
		local _r, _g, _b = 0.1, 0.1, 0.1
		if mdFaction then
			gy = gy + 25
			self:drawText("Global Objectives:", gx, gy, 0.1, 0.1, 0.1, 1, UIFont.Large)

			_r, _g, _b = textColor(weeklyGlobalRewards.perfectlyBalanced)
			gy = gy + 25
			self:drawText("All 3 Factions have achieved zone notoriety in the same zones.", gx+10, gy, _r, _g, _b, 1, UIFont.Medium)

			_r, _g, _b = textColor(weeklyGlobalRewards.FilthyCasuals)
			gy = gy + 25
			self:drawText("All 3 Factions each have over 50,000 global kills.", gx+10, gy, _r, _g, _b, 1, UIFont.Medium)

			_r, _g, _b = textColor(weeklyGlobalRewards.unquenchableThirst)
			gy = gy + 25
			self:drawText("Combined global kills over 250,000.", gx+10, gy, _r, _g, _b, 1, UIFont.Medium)	

			_r, _g, _b = textColor(weeklyGlobalRewards.concertedEfforts)
			gy = gy + 25
			self:drawText("All 3 Factions each have achieved over 20,000 Tier 6 zone kills.", gx+10, gy, _r, _g, _b, 1, UIFont.Medium)	

			_r, _g, _b = textColor(weeklyGlobalRewards.SweatyTryhards)
			gy = gy + 25
			self:drawText("Combined total of 80,000 Tier 6 zone kills.", gx+10, gy, _r, _g, _b, 1, UIFont.Medium)		
			
			gy = gy + 25
			self:drawText(mdFaction .. " Faction Zone Objectives:", gx, gy, 0.1, 0.1, 0.1, 1, UIFont.Large)
			
			for i=1,6 do
				gy = gy + 25
				_r, _g, _b = textColor(weeklyFactionRewards[mdFaction.."_T"..i])
				self:drawText("Kill " .. i*1000 .. " zombies in a Tier " .. i .. " zone.", gx+10, gy, _r, _g, _b, 1, UIFont.Medium)
			end
		end

		--self:drawText(" <RGB:0.83,0.68,0.21> " .. "Global Kills: " .. globalTally, x, y, 0.1, 0.1, 0.1, 1, UIFont.Large)
		--[[self.tooltip.description = 	zoneTally .. "\n" ..
									zoneinfo ..  "\n" ..
									zoneXY]]
    end
	
	--[[if ModDataMapDrawTierZones[getCurrentUserSteamID()] then
		local symbolsAPI = self.mapAPI:getSymbolsAPI()
		local symCount = symbolsAPI:getSymbolCount()
		if symCount and symCount ~= 0 then
			for i=symCount, 0, -1 do
				local symIndex = symbolsAPI:getSymbolByIndex(i)
				if symIndex then
					local symID = symIndex:getSymbolID()
					if symID and symID == "Asterisk" then
						symbolsAPI:removeSymbolByIndex(i)
					end
				end
			end
		end
		
		--for i=1,#ZoneNames do
			--drawHatchedRectangleForZone(self, ZoneNames[i], 1.0, 750, self.mapAPI)
		--end
		--deprecated, we use elyon's marker system now

		ModDataMapDrawTierZones[getCurrentUserSteamID()] = false
	end]]
	local section = self.tooltip.hoverSection

	if section == 'kills' then
		self.tooltip.name = "Global Kill Statistics"
		self.tooltip.description = "<RGB:1,1,1>This shows the kill counts for each faction this week."

	elseif section == 'global_obj' and self.globalRewards then
		self.tooltip.name = "Weekly Global Objectives Rewards"
		self.tooltip.description = self.globalRewards


	elseif section == 'faction_obj' and self.factionRewards then
		self.tooltip.name = "Weekly Faction Objective Rewards"
		self.tooltip.description = self.factionRewards

	elseif section == 'map' then
		local x, y, zoneinfo, zoneXY, zoneTally, zonename, globalTally = self.zone[1], self.zone[2], self.zone[3], self.zone[4], self.zone[5], self.zone[6], self.zone[8]
		self.tooltip.name = zoneinfo
		local mapLine = {""}
		if zoneTally and #zoneTally > 0 and zonename ~= "Unnamed Zone" and zonename ~= "Default" then self.tooltip.description = green .. zoneTally.." <LINE> " else self.tooltip.description = "" end
		--if zoneinfo then table.insert(mapLine, gold .. zoneinfo ..  " <LINE> ") end
		if zoneXY then table.insert(mapLine, white .. zoneXY ..  " <LINE> ") end
		
		self.tooltip.description = self.tooltip.description .. table.concat(mapLine, " <LINE> ")
		
	end
end

local original_onMouseMove = ISWorldMap.onMouseMove
function ISWorldMap:onMouseMove(dx, dy)
    original_onMouseMove(self, dx, dy)
	
    local mouseX = self:getMouseX()
    local mouseY = self:getMouseY()
	
	self:updateTooltip(mouseX, mouseY)

    local worldX = math.floor(self.mapAPI:uiToWorldX(mouseX, mouseY))
    local worldY = math.floor(self.mapAPI:uiToWorldY(mouseX, mouseY))
	
	--local zoneXY = "("..worldX..","..worldY..")"
	local zoneXY = "(X:"..worldX..", Y:"..worldY..")"

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
	--local zonesTally = ""
	local zonesTally = {}
	local globalTally = {}
	
	local faction = getSpecificPlayer(0):getModData().faction
	
	if zonename ~= "Unnamed Zone" and zonesData[zonename] then
		if faction ~= "" and SDFactions[faction] then
			local zoneKills = zonesData[zonename][faction] or 0
			if zoneKills > tier*1000 then
				zoneXY = zoneXY .. green .. " <LINE>  " .. faction .. "s have killed " .. zoneKills .. " out of required " .. tier*1000 .. " zombies in this zone. Faction bonus is active."
			else
				zoneXY = zoneXY .. red .. " <LINE>  " .. faction .. "s need " .. tier*1000 .. " kills to activate zone bonus."
			end
		else
			zoneXY = zoneXY .. orange .. " <LINE>  Join a faction at CC to unlock zone bonuses!"
		end
		
		--[[zonesTally = zonename .. " Faction Kills:"
		for i=1,#factions do
			local zoneKills = zonesData[zonename][factions[i] ] or 0
			zonesTally = zonesTally .. " " .. factions[i] .. "-" .. zoneKills
		end]]
		local zonesTallyLine = { gold .. zonename .. " kills:" }

		for i=1,#factions do
			local zoneKills = zonesData[zonename][ factions[i] ] or 0
			table.insert(zonesTallyLine, green .. factions[i] .. " - " .. zoneKills)
		end
		
		zonesTally = table.concat(zonesTallyLine, " <LINE> ")
		
	end
	
	if zonesData["COG_global"] then
		table.insert(globalTally, "COG: " .. zonesData["COG_global"])
	end
	
	if zonesData["Ranger_global"] then
		table.insert(globalTally, "Ranger: " .. zonesData["Ranger_global"])
	end
	
	if zonesData["VoidWalker_global"] then
		table.insert(globalTally, "VoidWalker: " .. zonesData["VoidWalker_global"])
	end
	
	if zonesData["Sunday Drivers_global"] then
		table.insert(globalTally, "Sunday Drivers: " .. zonesData["Sunday Drivers_global"])
	end
	
	local zoneinfo = toxicText .. "[T"..tier.."] " .. zonename .. " - Sprinter="..sprinter.. "% Pinpoint="..pinpoint.. "% Cognition="..cognition.."%" .. " ZombieHealth=" .. math.floor(zhealth/2.1*100+0.5) .. "%"
	--local zoneXY = "("..worldX..","..worldY..")"-- Faction needs " .. tier*1000 .. " kills to activate zone bonus."
	
	self.zone = { mouseX, mouseY, zoneinfo, zoneXY , zonesTally, zonename, zonetier, globalTally}
end

local function zonesData()
	ModData.request("zonesData")
end
--if not isServer() then Events.EveryTenMinutes.Add(zonesData) end

require "ISUI/ISPanel"
SDGlobalTooltip = ISToolTip:derive("SDGlobalTooltip")

local ISWorldMap_createChildren = ISWorldMap.createChildren;

function ISWorldMap:createChildren()
    ISWorldMap_createChildren(self)

    self.tooltip = SDGlobalTooltip:new()
    self.tooltip:initialise()
    self.tooltip:setVisible(false) -- Start with the tooltip hidden
    self:addChild(self.tooltip)
end

function ISWorldMap:updateTooltip(x, y)
    
    self.tooltip.hoverSection = nil

    local text_x_min = 10
    local text_x_max = 450

    local y_kills_start = 40
    local y_kills_end = y_kills_start
    if self.zone and self.zone[8] then -- self.zone[8] is globalTally
        y_kills_end = y_kills_end + (25 * #self.zone[8]) + 25
    end

    -- Global Objectives
    local y_global_obj_start = y_kills_end + 25 -- Accounts for the section header
    local y_global_obj_end = y_global_obj_start + (25 * 5) -- 5 objective lines

    -- Faction Objectives
    local y_faction_obj_start = y_global_obj_end + 25 -- Accounts for the section header
    local y_faction_obj_end = y_faction_obj_start + (25 * 6) -- 6 objective lines

    if self.zone then
		if  x >= text_x_min and x <= text_x_max and y >= y_global_obj_start and y <= y_global_obj_end then
            self.tooltip.hoverSection = 'global_obj'
		elseif  x >= text_x_min and x <= text_x_max and y >= y_kills_start and y <= y_kills_end then
			self.tooltip.hoverSection = 'kills'
		elseif x >= text_x_min and x <= text_x_max*0.55 and y >= y_faction_obj_start and y <= y_faction_obj_end then
			self.tooltip.hoverSection = 'faction_obj'
		else
			self.tooltip.hoverSection = 'map'
        end
    end

    if self.tooltip.hoverSection then
        self.tooltip:setVisible(true)
        self.tooltip:setX(x + 45)
        self.tooltip:setY(y + 20)
    else
        self.tooltip:setVisible(false)
    end
end

function SDGlobalTooltip:new()
    local o = ISToolTip.new(self)
    setmetatable(o, self)
    self.__index = self
    o:noBackground()
    o.name = "Objective Rewards"
    o.description = ""
    o.borderColor = {r = 0.4, g = 0.4, b = 0.4, a = 1}
    o.backgroundColor = {r = 0, g = 0, b = 0, a = 0.5}
    o.width = 0
    o.height = 0
    o.coordX = 0
    o.coordY = 0
    o.anchorLeft = false
    o.anchorRight = false
    o.anchorTop = false
    o.anchorBottom = false
    o.owner = nil
    o.followMouse = false
    return o
end