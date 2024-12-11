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

local CY_counter = 0
local JC_counter = 0
local VW_Argus_counter = 0
local Cog_Lt_BA_counter = 0
local Ranger_JG_counter = 0

local function resetCounters()
	CY_counter = 0
	JC_counter = 0
	VW_Argus_counter = 0
	Cog_Lt_BA_counter = 0
	Ranger_JG_counter = 0
end

SD6_NPCS_LootMaps.Init.SundayDriversNPC_CY = function(mapUI)
	local mapAPI = mapUI.javaObject:getAPIv1()

	SD6_NPCS.initDirectoryMapData(mapUI, 'media/maps/Muldraugh, KY')
	mapAPI:setBoundsInSquares(0, 0, 1600, 1000)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_BackGround.png", 1.0)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_CY.png", 1.0)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_TextBox.png", 1.0)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_CYText0.png", 1.0)
	--SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_Text1.png", 1.0)
	sd6_mapAPI = mapAPI
	sd6_mapUI = mapUI
	sd6_NPC = "SundayDriversNPC_CY"
	resetCounters()
end

SD6_NPCS_LootMaps.Init.SundayDriversNPC_JC = function(mapUI)
	local mapAPI = mapUI.javaObject:getAPIv1()

	SD6_NPCS.initDirectoryMapData(mapUI, 'media/maps/Muldraugh, KY')
	mapAPI:setBoundsInSquares(0, 0, 1600, 1000)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_BackGround.png", 1.0)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_JC.png", 1.0)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_TextBox.png", 1.0)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_JCText0.png", 1.0)
	--SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_Text1.png", 1.0)
	sd6_mapAPI = mapAPI
	sd6_mapUI = mapUI
	sd6_NPC = "SundayDriversNPC_JC"
	resetCounters()
end

SD6_NPCS_LootMaps.Init.SundayDriversNPC_VW_Argus = function(mapUI)
	local mapAPI = mapUI.javaObject:getAPIv1()

	SD6_NPCS.initDirectoryMapData(mapUI, 'media/maps/Muldraugh, KY')
	mapAPI:setBoundsInSquares(0, 0, 1600, 1000)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_BackGround_DD.png", 1.0)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_VW_Argus.png", 1.0)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_TextBox.png", 1.0)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_VW_ArgusText0.png", 1.0)
	getSpecificPlayer(0):getEmitter():playSoundImpl("VW_Argus_intro", nil)
	--SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_Text1.png", 1.0)
	sd6_mapAPI = mapAPI
	sd6_mapUI = mapUI
	sd6_NPC = "SundayDriversNPC_VW_Argus"
	resetCounters()
end

SD6_NPCS_LootMaps.Init.SundayDriversNPC_Cog_Lt_BA = function(mapUI)
	local mapAPI = mapUI.javaObject:getAPIv1()

	SD6_NPCS.initDirectoryMapData(mapUI, 'media/maps/Muldraugh, KY')
	mapAPI:setBoundsInSquares(0, 0, 1600, 1000)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_BackGround_DD.png", 1.0)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_Cog_Lt_BA.png", 1.0)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_TextBox.png", 1.0)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_Cog_Lt_BAText0.png", 1.0)
	getSpecificPlayer(0):getEmitter():playSoundImpl("Cog_Lt_BA_intro", nil)
	--SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_Text1.png", 1.0)
	sd6_mapAPI = mapAPI
	sd6_mapUI = mapUI
	sd6_NPC = "SundayDriversNPC_Cog_Lt_BA"
	resetCounters()
end

SD6_NPCS_LootMaps.Init.SundayDriversNPC_Ranger_JG = function(mapUI)
	local mapAPI = mapUI.javaObject:getAPIv1()

	SD6_NPCS.initDirectoryMapData(mapUI, 'media/maps/Muldraugh, KY')
	mapAPI:setBoundsInSquares(0, 0, 1600, 1000)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_BackGround_DD.png", 1.0)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_Ranger_JG.png", 1.0)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_TextBox.png", 1.0)
	SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_Ranger_JGText0.png", 1.0)
	getSpecificPlayer(0):getEmitter():playSoundImpl("Ranger_JG_intro", nil)
	--SD6_NPCS_overlayPNG(mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_Text1.png", 1.0)
	sd6_mapAPI = mapAPI
	sd6_mapUI = mapUI
	sd6_NPC = "SundayDriversNPC_Ranger_JG"
	resetCounters()
end

local CYmax = 12
local JCmax = 1
local VW_Argusmax = 2
local Cog_Lt_BAmax = 4
local Ranger_JGmax = 2

ISMap.o_onMouseDown = ISMap.onMouseDown
function ISMap:onMouseDown(x, y)
	if self.character:getInventory():contains(self.mapObj, true) then 
		self:o_onMouseDown(x, y)
		return
	end
	
	if CY_counter == CYmax then
		--getSoundManager():stop()
		self.character:getEmitter():stopAll()
		self.wrap:close()
		resetCounters()
		return
	elseif sd6_NPC == "SundayDriversNPC_CY" then 
		CY_counter = CY_counter + 1
		SD6_NPCS_overlayPNG(sd6_mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_TextBox.png", 1.0)
		SD6_NPCS_overlayPNG(sd6_mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_CYText" .. CY_counter ..".png", 1.0)
		--getSoundManager():stop()
		--getSoundManager():PlayWorldSoundImpl("CY"..CY_counter, false, self.character:getX(), self.character:getY(), self.character:getZ(), 0.2, 10, 0.05, false) ;
		self.character:getEmitter():stopAll()
		self.character:getEmitter():playSoundImpl("CY"..CY_counter, nil)
	end
	
	if JC_counter == JCmax then
		self.character:getEmitter():stopAll()
		self.wrap:close()
		resetCounters()
		return
	elseif sd6_NPC == "SundayDriversNPC_JC" then 
		JC_counter = JC_counter + 1
		self.wrap:close()
		--SD6_NPCS_overlayPNG(sd6_mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_TextBox.png", 1.0)
		--SD6_NPCS_overlayPNG(sd6_mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_CYText" .. CY_counter ..".png", 1.0)
		self.character:getEmitter():stopAll()
		self.character:getEmitter():playSoundImpl("JC"..JC_counter, nil)
	end
	
	if Cog_Lt_BA_counter >= Cog_Lt_BAmax then
		return
	elseif sd6_NPC == "SundayDriversNPC_Cog_Lt_BA" then 
		Cog_Lt_BA_counter = Cog_Lt_BA_counter + 1
		SD6_NPCS_overlayPNG(sd6_mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_TextBox.png", 1.0)
		SD6_NPCS_overlayPNG(sd6_mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_Cog_Lt_BAText" .. Cog_Lt_BA_counter ..".png", 1.0)
		--self.character:getEmitter():stopAll()
		--elf.character:getEmitter():playSoundImpl("JC"..JC_counter, nil)
	end
	
	if Ranger_JG_counter == Ranger_JGmax then
		return
	elseif sd6_NPC == "SundayDriversNPC_Ranger_JG" then 
		Ranger_JG_counter = Ranger_JG_counter + 1
		SD6_NPCS_overlayPNG(sd6_mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_TextBox.png", 1.0)
		SD6_NPCS_overlayPNG(sd6_mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_Ranger_JGText" .. Ranger_JG_counter ..".png", 1.0)
		--self.character:getEmitter():stopAll()
		--elf.character:getEmitter():playSoundImpl("JC"..JC_counter, nil)
	end
	
	if VW_Argus_counter == VW_Argusmax then
		return
	elseif sd6_NPC == "SundayDriversNPC_VW_Argus" then 
		VW_Argus_counter = VW_Argus_counter + 1
		SD6_NPCS_overlayPNG(sd6_mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_TextBox.png", 1.0)
		SD6_NPCS_overlayPNG(sd6_mapUI, 0, 0, 1, "SD6_NPCS_PNG", "media/ui/LootableMaps/SundayDriversNPC_VW_ArgusText" .. VW_Argus_counter ..".png", 1.0)
		--self.character:getEmitter():stopAll()
		--elf.character:getEmitter():playSoundImpl("JC"..JC_counter, nil)
	end

	--if not (sd6_NPC == "SundayDriversNPC_CY") then self.wrap:close() end
end

ISMap.o_onRightMouseDown = ISMap.onRightMouseDown
function ISMap:onRightMouseDown(x, y)
	if self.character:getInventory():contains(self.mapObj, true) then 
		self:o_onRightMouseDown(x, y)
		return
	end
		
	local context = ISContextMenu.get(0, x + self:getAbsoluteX(), y + self:getAbsoluteY())
	
	if sd6_NPC == "SundayDriversNPC_Cog_Lt_BA" and Cog_Lt_BA_counter == Cog_Lt_BAmax then
		local option = context:addOption("I'm another Cog in the wheel! (Join the Cogs)", self,
		function()
			getSpecificPlayer(0):getModData().faction = "COG"
			resetCounters()
			self.wrap:close()
			self.character:getEmitter():stopAll()
			self.character:getEmitter():playSoundImpl("Cog_Lt_BA_accept", nil)
			
			MF.getMoodle("COG"):setValue(1.0)
			MF.getMoodle("Ranger"):setValue(0.5)
			MF.getMoodle("VW"):setValue(0.5)
		end)
		
		local option = context:addOption("No thanks.", self,
		function()
			--getSpecificPlayer(0):getModData().faction = "COG"
			resetCounters()
			self.wrap:close()
			self.character:getEmitter():stopAll()
			self.character:getEmitter():playSoundImpl("Cog_Lt_BA_reject", nil)
		end)
		
	elseif sd6_NPC == "SundayDriversNPC_Ranger_JG" and Ranger_JG_counter == Ranger_JGmax then
		local option = context:addOption("This seems right. (I want to become a Ranger)", self,
		function()
			getSpecificPlayer(0):getModData().faction = "Ranger"
			resetCounters()
			self.wrap:close()
			self.character:getEmitter():stopAll()
			self.character:getEmitter():playSoundImpl("Ranger_JG_accept", nil)
			
			MF.getMoodle("COG"):setValue(0.5)
			MF.getMoodle("Ranger"):setValue(1.0)
			MF.getMoodle("VW"):setValue(0.5)
		end)
		
		local option = context:addOption("I'll pass.", self,
		function()
			--getSpecificPlayer(0):getModData().faction = "COG"
			Ranger_JG_counter = 0
			self.wrap:close()
			self.character:getEmitter():stopAll()
			self.character:getEmitter():playSoundImpl("Ranger_JG_reject", nil)
		end)
		
	elseif sd6_NPC == "SundayDriversNPC_VW_Argus" and VW_Argus_counter == VW_Argusmax then
		local option = context:addOption("I cannot resist the call of the Void. (Join the Void Walkers)", self,
		function()
			getSpecificPlayer(0):getModData().faction = "VoidWalker"
			resetCounters()
			self.wrap:close()
			self.character:getEmitter():stopAll()
			self.character:getEmitter():playSoundImpl("VW_Argus_accept", nil)
			
			MF.getMoodle("COG"):setValue(0.5)
			MF.getMoodle("Ranger"):setValue(0.5)
			MF.getMoodle("VW"):setValue(1.0)
		end)
		
		local option = context:addOption("Uhhh... (slowly backs away)", self,
		function()
			--getSpecificPlayer(0):getModData().faction = "COG"
			resetCounters()
			self.wrap:close()
			self.character:getEmitter():stopAll()
			self.character:getEmitter():playSoundImpl("VW_Argus_reject", nil)
		end)
		
	end
end

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

local function SD6_NPC_JC_onClick(v, player)
	local npc = "SD6_NPCS.SundayDriversNPC_JC"
	--local player = 0
	
	map = InventoryItemFactory.CreateItem(npc)
	
	SD6_NPCS_LootMaps.openNPC(map, player, npc) 
end

local function SD6_NPC_VW_Argus_onClick(v, player)
	local npc = "SD6_NPCS.SundayDriversNPC_VW_Argus"
	--local player = 0
	
	map = InventoryItemFactory.CreateItem(npc)
	
	SD6_NPCS_LootMaps.openNPC(map, player, npc) 
end

local function SD6_NPC_Ranger_JG_onClick(v, player)
	local npc = "SD6_NPCS.SundayDriversNPC_Ranger_JG"
	--local player = 0
	
	map = InventoryItemFactory.CreateItem(npc)
	
	SD6_NPCS_LootMaps.openNPC(map, player, npc) 
end

local function SD6_NPC_Cog_Lt_BA_onClick(v, player)
	local npc = "SD6_NPCS.SundayDriversNPC_Cog_Lt_BA"
	--local player = 0
	
	map = InventoryItemFactory.CreateItem(npc)
	
	SD6_NPCS_LootMaps.openNPC(map, player, npc) 
end

local function SD6_NPC_CY(player, context, worldobjects, test)
	for i=1,#worldobjects do
		v = worldobjects[i]
		if v:getSprite() then
			local spriteName = v:getSprite():getName()
			if not spriteName then
				spriteName = v:getSpriteName()
			end
			
			local faction = getSpecificPlayer(0):getModData().faction
			
			if spriteName == 'LC_SD_Lect_01_42' or spriteName == 'LC_SD_Lect_01_43' then
				local submenu = context:addOption("Try To Wake Her Up...", v, SD6_NPC_CY_onClick, player)
				return
			elseif spriteName == 'LC_SD_Lect_01_18' or spriteName == 'LC_SD_Lect_01_19' then
				local submenu = context:addOption("Approach warily...", v, SD6_NPC_JC_onClick, player)
				return
			elseif spriteName == 'd_SD_NPC_01_2' or spriteName == 'd_SD_NPC_01_7' then
				--if faction == "VoidWalker" or faction == "Ranger" then return end
				local submenu = context:addOption("Inquire about the Cogs", v, SD6_NPC_Cog_Lt_BA_onClick, player)
				return
			elseif spriteName == 'd_SD_NPC_01_3' or spriteName == 'd_SD_NPC_01_4' then
				local submenu = context:addOption("Inquire about the Rangers", v, SD6_NPC_Ranger_JG_onClick, player)
				return
			elseif spriteName == 'd_SD_NPC_01_5' or spriteName == 'd_SD_NPC_01_6' then
				local submenu = context:addOption("Inquire about the Void Walkers", v, SD6_NPC_VW_Argus_onClick, player)
				return
			end
		end
	end
end

Events.OnPreFillWorldObjectContextMenu.Add(SD6_NPC_CY);