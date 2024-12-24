local ghs = " <RGB:" .. getCore():getGoodHighlitedColor():getR() .. "," .. getCore():getGoodHighlitedColor():getG() .. "," .. getCore():getGoodHighlitedColor():getB() .. "> "

local fridgetiles = {
	"Vaulttec_5_43",
	"Vaulttec_6_5",
	"melos_tiles_appliances_01_109",
	"melos_tiles_appliances_01_77",
	"melos_tiles_appliances_01_73",
	"melos_tiles_appliances_01_97",
	"melos_tiles_appliances_01_65",
	"melos_tiles_appliances_01_101",
	"melos_tiles_appliances_01_105",
	"melos_tiles_appliances_01_69",
	"blackwood7_48",
}

local fridgetilenames = {
	"Pink Fridge",
	"Retro Fridge",
	"Grass Green Fridge",
	"Grey Fridge",
	"Marine Fridge",
	"Maritim Fridge",
	"Olive Fridge",
	"Orange Fridge",
	"Purple Fridge",
	"Yellow Fridge",
	"Royale with Cheese Fridge",
}

local fridgetiledescriptions = {
	"26 fridge / 6 freezer (organized)",
	"26 fridge / 6 freezer (organized)",
	"52 fridge / 26 freezer (organized)",
	"52 fridge / 26 freezer (organized)",
	"52 fridge / 26 freezer (organized)",
	"52 fridge / 26 freezer (organized)",
	"52 fridge / 26 freezer (organized)",
	"52 fridge / 26 freezer (organized)",
	"52 fridge / 26 freezer (organized)",
	"52 fridge / 26 freezer (organized)",
	"65 fridge / 65 freezer (organized)",
}

local containertilenames = {
	"Silver Metal Crate",
	"Big Sam Statue",
	"Glass Gun Locker",
	"High Gun Locker",
	"Metal Gun Locker",
	"Xenomorph Egg Storage",
	"Black Trash Can",
	"White Trash Can",
	"Blue Garbage Bin",
	"Yellow Garbage Bin",
	"Clothing Wall Shelves",
	"Clothing Wall Shelves",
	"Brown Wall Bookshelves",
	"Brown Wall Bookshelves",
	"Oakwood Wall Bookshelves",
	"Oakwood Wall Bookshelves",
	"Wine Shelf (east)",
	"Wine Shelf (south)",
	"Clothes Stand",
	"Clothes Stand",
	"Grey Combi Locker",
	"Maritim Combi Locker",
	"Military Gun Shelves (1/2)",
	"Military Gun Shelves (2/2)",
	"Military Metal Shelves (1/2)",
	"Military Metal Shelves (2/2)",
	"Olive Green Combi Locker",
	"Red Combi Locker",
	"Green Glass Display Counter (east)",
	"Green Glass Display Counter (south)",
	"Glass Display Case",
}

local containertiles = {
	"furniture_storage_ddd_01_8",
	"DylanRandomAssetPack5_37",
	"Vaulttec_3_34",
	"Vaulttec_5_16",
	"Vaulttec_3_48",
	"blackwood7_57",
	"melos_tiles_random_props_02_64",
	"melos_tiles_random_props_02_56",
	"LC_Trash_Containers_57",
	"LC_Trash_Containers_61",
	"furniture_storage_ddd_01_55",
	"furniture_storage_ddd_01_54",
	"furniture_storage_ddd_01_32",
	"furniture_storage_ddd_01_33",
	"furniture_storage_ddd_01_34",
	"furniture_storage_ddd_01_35",
	"furniture_02_Simon_MD_48",
	"furniture_02_Simon_MD_49",
	"location_shop_generic_01_Simon_MD_44",
	"location_shop_generic_01_Simon_MD_12",
	"melos_tiles_furniture_storage_03_13",
	"melos_tiles_furniture_storage_03_11",
	"Chinatown_EX_military_1_24",
	"Chinatown_EX_military_1_25",
	"Guizi_tiles_01_6",
	"Guizi_tiles_01_7",
	"melos_tiles_furniture_storage_03_0",
	"melos_tiles_furniture_storage_03_4",
	"Chinatown_EX_military_1_8",
	"Chinatown_EX_military_1_9",
	"furniture_02_Simon_MD_46",
}

local containertiledescriptions = {
	"116 Capacity (organized)",
	"130 capacity (organized)",
	"130 Capacity (organized)",
	"130 Capacity (organized)",
	"130 Capacity (organized)",
	"130 Capacity (organized)",
	"13 Capacity (organized)",
	"13 Capacity (organized)",
	"19 Capacity (organized)",
	"19 Capacity (organized)",
	"39 Capacity (organized)",
	"39 Capacity (organized)",
	"52 Capacity (organized)",
	"52 Capacity (organized)",
	"52 Capacity (organized)",
	"52 Capacity (organized)",
	"52 Capacity (organized)",
	"52 Capacity (organized)",
	"65 Capacity (organized)",
	"65 Capacity (organized)",
	"65 capacity (organized)",
	"65 capacity (organized)",
	"65 Capacity (organized)",
	"65 Capacity (organized)",
	"65 Capacity (organized)",
	"65 Capacity (organized)",
	"65 capacity (organized)",
	"65 capacity (organized)",
	"71 Capacity (organized)",
	"71 Capacity (organized)",
	"78 Capacity (organized)",
}

local lighttiles = {
	"DAMIAO_01_1",
	"DAMIAO_01_0",
	"Industry_1_60",
	"Industry_2_26",
	"Industry_2_25",
	"melos_tiles_random_props_02_2",
	"melos_tiles_random_props_02_14",
	"Chinatown_EX_home_2_21",
	"Chinatown_EX_home_2_20",
	"LC_Chinatown_8",
	"Industry_3_10",
	"Chinatown_EX_1_92",
}

local lighttilenames = {
	"Triple Chinese Lantern",
	"Single Chinese Lantern",
	"Industrial Lamp",
	"Outdoor Industrial Lamp",
	"Outdoor Industrial Lamp",
	"Floor Lamp",
	"Floor Lamp",
	"Home Light",
	"Home Light",
	"Oriental Lamp",
	"Military Lights",
	"Bill-proof Campfire",
}

local oventiles = {
	"melos_tiles_appliances_01_28",
	"melos_tiles_appliances_01_24",
	"melos_tiles_appliances_01_16",
	"melos_tiles_appliances_01_20",
	"melos_tiles_appliances_01_12",
	"melos_tiles_appliances_01_0",
	"melos_tiles_appliances_01_4",
	"melos_tiles_appliances_01_8",
}

local oventilenames = {
	"Maritim Oven",
	"Brown Oven",
	"Snow Oven",
	"Dark Green Oven",
	"Yellow Oven",
	"Eggshell Oven",
	"Sky Blue Oven",
	"Wildberry Oven",
}

local seatingtiles = {
	"Chinatown_2_10",
	"k8_puk_01_0",
	"LC_Club_0",
	"pert_bar_01_75",
	"melos_tiles_furniture_seating_03_54",
	"melos_tiles_furniture_seating_03_55",
}

local seatingtilenames = {
	"Chinese Chair",
	"Puk Seat",
	"Club Chair",
	"Tall Ball Chair",
	"Funky Couch (1/2)",
	"Funky Couch (2/2)",
}

local tabletiles = {
	"furniture_more_ddd_01_8",
	"furniture_more_ddd_01_16",
	"furniture_more_ddd_01_24",
	"furniture_more_ddd_01_40",
	"melos_tiles_furniture_tables_01_16",
	"melos_tiles_furniture_tables_01_17",
	"melos_tiles_furniture_tables_01_18",
	"melos_tiles_furniture_tables_01_19",
	"melos_tiles_furniture_tables_01_20",
	"furniture_02_Simon_MD_52",
	"furniture_Simon_MD_5",
	"furniture_02_Simon_MD_40",
	"furniture_02_Simon_MD_41",
	"furniture_02_Simon_MD_44",
	"furniture_02_Simon_MD_45",
}

local tabletilenames = {
	"Fancy Dark Table",
	"Fancy Dark Table",
	"Fancy Dark Table",
	"Fancy Dark Table",
	"Diner Metal Round Table",
	"Diner Blue Round Table",
	"Diner Grey Round Table",
	"Diner Green Round Table",
	"Diner Yellow Round Table",
	"Bar Wall Bar",
	"Glass Display Gundisplay",
	"Long Low Table Dark Glass (1/2)",
	"Long Low Table Dark Glass (2/2)",
	"Long Low Table Red Glass (1/2)",
	"Long Low Table Red Glass (2/2)",
}

local planttiles1 = {
	"pert_vegetation_indoor_01_0",
	"pert_vegetation_indoor_01_1",
	"pert_vegetation_indoor_01_2",
	"pert_vegetation_indoor_01_3",
	"vegetation_indoor_Simon_MD_43",
	"vegetation_indoor_Simon_MD_44",
	"vegetation_indoor_Simon_MD_45",
	"vegetation_indoor_Simon_MD_46",
	"vegetation_indoor_Simon_MD_47",
	"vegetation_indoor_Simon_MD_48",
	"vegetation_indoor_Simon_MD_49",
	"vegetation_indoor_Simon_MD_50",
	"vegetation_indoor_Simon_MD_51",
	"vegetation_indoor_Simon_MD_52",
	"vegetation_indoor_Simon_MD_53",
	"vegetation_indoor_Simon_MD_54",
	"melos_tiles_gardencenter_plants_02_24",
	"melos_tiles_gardencenter_plants_02_25",
	"melos_tiles_gardencenter_plants_02_0",
	"melos_tiles_gardencenter_plants_02_1",
	"melos_tiles_gardencenter_plants_02_2",
	"melos_tiles_gardencenter_plants_02_3",
	"melos_tiles_gardencenter_plants_02_4",
}

local planttilenames1 = {
	"Indoor Plant Dead",
	"Indoor Plant Dead",
	"Indoor Plant Dead",
	"Indoor Plant Dead",
	"Potted Flowers",
	"Potted Flowers",
	"Potted Flowers",
	"Potted Flowers",
	"Potted Flowers",
	"Potted Flowers",
	"Potted Flowers",
	"Potted Flowers",
	"Potted Flowers",
	"Potted Flowers",
	"Potted Flowers",
	"Potted Flowers",
	"Potted Plant",
	"Potted Plant",
	"Potted Plant",
	"Potted Plant",
	"Potted Plant",
	"Potted Plant",
	"Potted Plant",
}

local planttiles2 = {
	"vegetation_indoor_Simon_MD_0",
	"melos_tiles_gardencenter_plants_02_5",
	"melos_tiles_gardencenter_plants_02_6",
	"melos_tiles_gardencenter_plants_02_7",
	"melos_tiles_gardencenter_plants_02_8",
	"melos_tiles_gardencenter_plants_02_9",
	"melos_tiles_gardencenter_plants_02_10",
	"melos_tiles_gardencenter_plants_02_11",
	"melos_tiles_gardencenter_plants_02_12",
	"melos_tiles_gardencenter_plants_02_13",
	"melos_tiles_gardencenter_plants_02_14",
	"melos_tiles_gardencenter_plants_02_15",
	"DylansRandomFurniture04_20",
	"DylansRandomFurniture04_21",
	"melos_tiles_gardencenter_01_31",
	"melos_tiles_gardencenter_01_43",
	"melos_tiles_gardencenter_plants_01_0",
	"melos_tiles_gardencenter_plants_01_1",
	"melos_tiles_gardencenter_plants_01_2",
	"melos_tiles_gardencenter_plants_01_3",
	"melos_tiles_gardencenter_plants_01_4",
	"melos_tiles_gardencenter_plants_01_5",
	"melos_tiles_gardencenter_plants_01_6",
	"melos_tiles_gardencenter_plants_01_7",
	"melos_tiles_gardencenter_plants_01_8",
	"melos_tiles_gardencenter_plants_01_9",
	"melos_tiles_gardencenter_plants_01_10",
	"melos_tiles_gardencenter_plants_01_11",
	"melos_tiles_gardencenter_plants_01_16",
	"melos_tiles_gardencenter_plants_01_17",
	"melos_tiles_gardencenter_plants_01_18",
}

local planttilenames2 = {
	"Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Plant Container",
	"Plant Container",
	"Melos Hanging Plant Pot Group Melos Hanging Plant Pot 1",
	"Melos Hanging Plant Pot Group Melos Hanging Plant Pot 2",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
	"Melos Large Plant",
}

local walldecorationtiles = {
	"Vaulttec_4_14",
	"Vaulttec_4_22",
	"blends_street_01_101",
	"DylanPitstopExpItems_62",
	"melos_tiles_wall_deco_05_24",
	"melos_tiles_wall_deco_05_25",
	"melos_tiles_wall_deco_05_22",
	"melos_tiles_wall_deco_05_23",
	"melos_tiles_wall_deco_05_16",
	"melos_tiles_wall_deco_05_17",
	"melos_tiles_wall_deco_05_18",
	"melos_tiles_wall_deco_05_19",
	"melos_tiles_wall_deco_05_20",
	"melos_tiles_wall_deco_05_21",
	"Vault_8_45",
	"Vault_8_46",
}

local walldecorationtilenames = {
	"Vault Tec Sign",
	"Vault Tec Sign",
	"Daphne Pinup",
	"Velma Pinup",
	"Simõn E",
	"Simõn S",
	"Muffins E",
	"Muffins S",
	"Mr.Pickles E",
	"Mr.Pickles S",
	"Bandit E",
	"Bandit S",
	"Johnny E",
	"Johnny S",
	"Akashi Painting",
	"Akashi Painting",
}

local decorationtiles = {
	"DylanRandomAssetPack8_41",
	"DylanPitstopExpItems_59",
	"DylanPitstopExpItems_60",
	"DylansRandomFurniture02_12",
	"d_location_arcadian_01_20",
	"d_location_arcadian_01_21",
	"d_location_arcadian_01_12",
	"d_location_arcadian_01_13",
	"d_location_arcadian_01_22",
	"d_location_arcadian_01_23",
	"d_location_arcadian_01_14",
	"d_location_arcadian_01_15",
	"pert_bathroom_01_14",
	"pert_bathroom_01_4",
	"pert_bathroom_01_21",
	"pert_bathroom_01_20",
	"melos_tiles_overgrown_objects_01_22",
	"melos_tiles_overgrown_objects_01_23",
	"DAMIAO_02_12",
	"DAMIAO_02_13",
	"DAMIAO_02_14",
	"DAMIAO_02_15",
	"DAMIAO_02_16",
	"DAMIAO_02_17",
	"DAMIAO_02_18",
	"DAMIAO_02_19",
	"DylanRandomAssetPack8_40",
	"DylanRandomAssetPack3_42",
	"DylanRandomAssetPack3_39",
}

local decorationtilenames = {
	"Pink Swing",
	"Velma Figure",
	"Scooby Doo Figure",
	"Punching Bag",
	"Arcadian Machine 1 (1/2)",
	"Arcadian Machine 1 (2/2)",
	"Arcadian Machine 2 (1/2)",
	"Arcadian Machine 2 (2/2)",
	"Arcadian Machine 3 (1/2)",
	"Arcadian Machine 3 (2/2)",
	"Arcadian Machine 4 (1/2)",
	"Arcadian Machine 4 (2/2)",
	"Green Sink",
	"Green Standing Sink",
	"Green Toilet",
	"Green Toilet",
	"Garden Well",
	"Garden Well",
	"Cloth Model",
	"Cloth Model",
	"Cloth Model",
	"Cloth Model",
	"Cloth Model",
	"Cloth Model",
	"Cloth Model",
	"Cloth Model",
	"Daphne Mannequin",
	"Hanging Man",
	"Hanging Man 2",
}

local args = {}

local function addToArgs(item, amount, itemname)
	local item = itemname or item
	amount = amount or 1
    local newItemKey = "item" .. (#args + 1) 
    args[newItemKey] = args[newItemKey] or {}  
    table.insert(args[newItemKey], amount .. "x " .. item) 
end

local function addSprite(item, player, tileSprite, tileName)
	itemname = tileName
	loot = tileSprite
	playerObj = getSpecificPlayer(player)
	playerInv = playerObj:getInventory()
	
	playerInv:AddItem("Moveables.Moveable"):ReadFromWorldSprite(loot)
	addToArgs(loot, 1, itemname)
	
	if item:isInPlayerInventory() then
		playerInv:RemoveOneOf("Base.TileCacheRegular")
	end
end

local function tilePicker(item, player, tileSpriteTable, tileNameTable, tileDescription, subMenu)
	for i = 1, #tileSpriteTable do
		local tileSpriteID = tileSpriteTable[i]
		local tileNameID = tileNameTable[i]
		local tileDescriptionID
		if not tileDescription then tileDescriptionID = "" else tileDescriptionID = tileDescription[i] end
		option_forTile = subMenu:addOption(tileNameID, item, addSprite, player, tileSpriteID, tileNameID)
		tooltip = ISWorldObjectContextMenu.addToolTip();

		tooltip.description = tooltip.description .. " <IMAGE:" .. tileSpriteID .. "> "
		tooltip.description = tooltip.description .. " <LINE> " .. ghs .. tileDescriptionID
		option_forTile.toolTip = tooltip
	end
end

local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "[^;]+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local function splitTable(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "[^:]+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local sandboxTiles = {}
local sandboxTileNames = {}
local sandboxTileDescriptions = {}

local function tileSubMenu(tileContext, context, submenuname, item, player, tileSpriteTable, tileNameTable, tileDescription)
	--submenu = ISContextMenu:getNew(context)
	--context:addSubMenu(tileContext, submenu)
			
	option_SubMenu = submenu:addOption(submenuname, item, nil, player)
	SubMenu = ISContextMenu:getNew(submenu);
	SubMenu:addSubMenu(option_SubMenu, SubMenu)
	
	tilePicker(item, player, tileSpriteTable, tileNameTable, tileDescription, SubMenu)
end


local function tileBoxContext(player, context, items) -- # When an inventory item context menu is opened
	playerObj = getSpecificPlayer(player)
	playerInv = playerObj:getInventory()
	items = ISInventoryPane.getActualItems(items); -- Get table of inventory items (will not be module.item, just item)
	local sandboxTiles = {}
	local sandboxTileNames = {}
	local sandboxTileDescriptions = {}
	for _, item in ipairs(items) do -- Check every item in inventory array
		if not item:isInPlayerInventory() then return end
		if item:getFullType() == "Base.TileCacheRegular" then
			
			local stringVal = splitString(SandboxVars.TilePicker.RegularCache)
			for i=1, #stringVal do
				--print(stringVal[i])
				local stringTable = splitTable(stringVal[i])
				for k=1,#stringTable do
					if k==1 then table.insert(sandboxTiles, stringTable[k]) end
					if k==2 then table.insert(sandboxTileNames, stringTable[k]) end
				end
				if #stringTable == 3 then 
					table.insert(sandboxTileDescriptions, stringTable[3])
				else
					table.insert(sandboxTileDescriptions, "")
				end
			end

			tileContext = context:addOption("Tile Picker", item, nil, player)
			
			submenu = ISContextMenu:getNew(context)
			context:addSubMenu(tileContext, submenu)

			tileSubMenu(tileContext, context, "Containers", item, player, containertiles, containertilenames, containertiledescriptions)
			tileSubMenu(tileContext, context, "Decorations", item, player, decorationtiles, decorationtilenames)
			tileSubMenu(tileContext, context, "Decorations (Signs/Wall)", item, player, walldecorationtiles, walldecorationtilenames)
			tileSubMenu(tileContext, context, "Refrigerators", item, player, fridgetiles, fridgetilenames, fridgetiledescriptions)
			tileSubMenu(tileContext, context, "Lights", item, player, lighttiles, lighttilenames)
			tileSubMenu(tileContext, context, "Ovens", item, player, oventiles, oventilenames)
			tileSubMenu(tileContext, context, "Plants (1/2)", item, player, planttiles1, planttilenames1)
			tileSubMenu(tileContext, context, "Plants (2/2)", item, player, planttiles2, planttilenames2)
			tileSubMenu(tileContext, context, "Seating", item, player, seatingtiles, seatingtilenames)
			tileSubMenu(tileContext, context, "Tables", item, player, tabletiles, tabletilenames)
			
			if #sandboxTiles == #sandboxTileNames then
				if #sandboxTileDescriptions == 0 then sandboxTileDescriptions = "" end
				tileSubMenu(tileContext, context, "Custom Tiles", item, player, sandboxTiles, sandboxTileNames, sandboxTileDescriptions)
			end
			
			break
		end
	end
end

Events.OnFillInventoryObjectContextMenu.Add(tileBoxContext) -- everytime you rightclick an object in your inventory it will trigger this check to add a teleport option