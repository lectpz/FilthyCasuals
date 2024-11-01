-- based on ISMapDefinitions.lua

SD6_NPCS = {}

ISMap.SCALE = 1.0

function SD6_NPCS.initDirectoryMapData(mapUI, directory)
	local mapAPI = mapUI.javaObject:getAPIv1()
	local file = directory..'/worldmap-forest.xml'
	if fileExists(file) then
		mapAPI:addData(file)
	end
	file = directory..'/worldmap.xml'
	if fileExists(file) then
		mapAPI:addData(file)
	end

	-- This call indicates the end of XML data files for the directory.
	-- If map features exist for a particular cell in this directory,
	-- then no data added afterwards will be used for that same cell.
	mapAPI:endDirectoryData()

	mapAPI:addImages(directory)
end

local function SD6_NPCS_overlayPNG(mapUI, x, y, scale, layerName, tex, alpha, sd6_mapAPI)
	local texture = getTexture(tex)
	if not texture then return end
	local mapAPI = sd6_mapAPI or mapUI.javaObject:getAPIv1()
	
	local r,g,b = 255/255, 255/255, 255/255
	mapAPI:setBackgroundRGBA(r, g, b, 0)
	
	local styleAPI = mapAPI:getStyleAPI()
	local layer = styleAPI:newTextureLayer(layerName)
	layer:setMinZoom(0)
	layer:addFill(0, 255, 255, 255, (alpha or 1.0) * 255*1.0)
	layer:addTexture(0, tex)
	layer:setBoundsInSquares(x, y, x + texture:getWidth() * scale, y + texture:getHeight() * scale)
end

SD6_NPCS_LootMaps = LootMaps or {}
SD6_NPCS_LootMaps.Init = LootMaps.Init or {}

local sd6_mapAPI
local sd6_mapUI
local sd6_NPC = ""

SD6_NPCS_LootMaps.Init.SundayDriversNPC_CY = function(mapUI)
	local mapAPI = mapUI.javaObject:getAPIv1()

	SD6_NPCS.initDirectoryMapData(mapUI, 'media/maps/Muldraugh, KY')
	mapAPI:setBoundsInSquares(0, 0, 1600, 1000)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_BackGround.png", 1.0)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_CY.png", 1.0)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_TextBox.png", 1.0)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_Text0.png", 1.0)
	--SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_Text1.png", 1.0)
	--self.mapAPI:getSymbolsAPI():
	sd6_mapAPI = mapAPI
	sd6_mapUI = mapUI
	sd6_NPC = "SundayDriversNPC_CY"
end

--[[ISMap.o_onMouseDown = ISMap.onMouseDown
function ISMap:onMouseDown(x, y)
	local npc = "SD6_NPCS.SundayDriversNPC_CY"
	local npcName = "test"
	local mapUI = sd6_mapUI
	
	local player = 0
	local context = ISContextMenu.get(player, x + self:getAbsoluteX(), y + self:getAbsoluteY())
	
	map = InventoryItemFactory.CreateItem(npc)
	
	--context:addOption(npcName, map, SD6_NPCS_LootMaps.openNPC, player, npc);--map is Type
	if not (sd6_NPC == "SundayDriversNPC_CY") then 
		SD6_NPCS_LootMaps.openNPC(map, player, npc) 
	else 
		--SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_TextBox.png", 1.0)
		--SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_Text2.png", 1.0)
	end
	self:o_onMouseDown(x,y)

	if not (sd6_NPC == "SundayDriversNPC_CY") then self.wrap:close() end
end]]

SD6_NPCS_LootMaps.openNPC = function(map, player, npc)
	local playerObj = getSpecificPlayer(player)
	
	local dx = 0.15
	local dy = 0.05
	
    local titleBarHgt = ISCollapsableWindow.TitleBarHeight()
    --local x = getPlayerScreenLeft(player) + 0
	local x = getPlayerScreenWidth(player) * dx
    --local y = getPlayerScreenTop(player) + 0
	local y = getPlayerScreenHeight(player) * dy
    local width = getPlayerScreenWidth(player) * (1-dx*2)
    local height = getPlayerScreenHeight(player) * (1-dy*2) - titleBarHgt

    local mapUI = ISMap:new(x, y, width, height, map, player);
    mapUI:initialise();
	
    local wrap = mapUI:wrapInCollapsableWindow(map:getName(), false, ISMapWrapper);
    wrap:setInfo(getText("IGUI_Map_Info"));
    wrap:setWantKeyEvents(true);
    mapUI.wrap = wrap;
    wrap.mapUI = mapUI;
--    mapUI.render = ISMap.noRender;
--    mapUI.prerender = ISMap.noRender;
    map:doBuildingStash();
    wrap:setVisible(true);
    wrap:addToUIManager();
end

local function SD6_NPC_CY_onClick(v, player)
	local npc = "SD6_NPCS.SundayDriversNPC_CY"
	--local player = 0
	
	map = InventoryItemFactory.CreateItem(npc)
	
	SD6_NPCS_LootMaps.openNPC(map, player, npc) 
end

local function SD6_NPC_CY(player, context, worldobjects, test)
	--for _,v in ipairs(worldobjects) do
	for i=1,#worldobjects do
		v = worldobjects[i]
		if v:getSprite() then
			local spriteName = v:getSprite():getName()
			if not spriteName then
				spriteName = v:getSpriteName()
			end
			if spriteName == 'LC_SD_Lect_01_42' or spriteName == 'LC_SD_Lect_01_43' then
				local submenu = context:addOption("Try To Wake Her Up...", v, SD6_NPC_CY_onClick, player)
				--local submenu = context:insertOptionAfter(getText("ContextMenu_SitGround"), "Take me to the event!!!", SDevent_teleport,v,playerObj,sq)
				return
			end
		end
	end
end

Events.OnPreFillWorldObjectContextMenu.Add(SD6_NPC_CY);