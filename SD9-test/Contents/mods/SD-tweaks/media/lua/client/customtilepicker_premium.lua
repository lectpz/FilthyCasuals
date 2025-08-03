local ghs = " <RGB:" .. getCore():getGoodHighlitedColor():getR() .. "," .. getCore():getGoodHighlitedColor():getG() .. "," .. getCore():getGoodHighlitedColor():getB() .. "> "

local fridgetiles = {
	"Vaulttec_1_11",
	"Vaulttec_1_10",
	"Chinatown_EX_kitchen_1_53",
	"Chinatown_EX_generic_1_72",
	"Vaulttec_5_48",
	"Industry_1_26",
	"Chinatown_EX_generic_1_32",
	"Chinatown_EX_generic_1_18",
	"Chinatown_EX_generic_1_19",
	"Vaulttec_5_29",
	"Vaulttec_5_30",
	"Vaulttec_5_31",
}

local fridgetilenames = {
	"Vault-tec Fridge",
	"Vault-tec Fridge",
	"Ice Freezer",
	"White Freezer",
	"Jack Daniel Fridge",
	"Modern Fridge",
	"Coke Fridge",
	"Green Cooled Shelves (1/2)",
	"Green Cooled Shelves (2/2)",
	"Vault-tec Large Fridge (1/3)",
	"Vault-tec Large Fridge (2/3)",
	"Vault-tec Large Fridge (3/3)",
}

local fridgetiledescriptions = {
	"52 fridge / 52 freezer (organized)",
	"52 fridge / 52 freezer (organized)",
	"65 fridge / 65 freezer (organized)",
	"65 fridge / 65 freezer (organized)",
	"78 fridge / 65 freezer (organized)",
	"78 Fridge/ 65 Freezer (organized)",
	"104 fridge / 6 freezer (organized)",
	"130 Cold/65 Freeze per tile (organized)",
	"130 Cold/65 Freeze per tile (organized)",
	"104 Cold/39 Freeze per tile (organized)",
	"104 Cold/39 Freeze per tile (organized)",
	"104 Cold/39 Freeze per tile (organized)",
}

local containertilenames = {
	"Space Crate",
}

local containertiles = {
	"Industry_1_62",
}

local containertiledescriptions = {
	"130 capacity (organized)",
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
		playerInv:RemoveOneOf("Base.TileCachePremium")
	end
end

local function tilePicker(item, player, tileSpriteTable, tileNameTable, tileDescription, subMenu)
	for i = 1, #tileSpriteTable do
		local tileSpriteID = tileSpriteTable[i]
		local tileNameID = tileNameTable[i]
		local tileDescriptionID = tileDescription[i] or ""
		option_forTile = subMenu:addOption(tileNameID, item, addSprite, player, tileSpriteID, tileNameID)
		tooltip = ISWorldObjectContextMenu.addToolTip();

		tooltip.description = tooltip.description .. " <IMAGE:" .. tileSpriteID .. "> "
		tooltip.description = tooltip.description .. " <LINE> " .. ghs .. tileDescriptionID
		option_forTile.toolTip = tooltip
	end
end

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
	for _, item in ipairs(items) do -- Check every item in inventory array
		if not item:isInPlayerInventory() then return end
		if item:getFullType() == "Base.TileCachePremium" then

			tileContext = context:addOption("Premium Tile Picker", item, nil, player)
			
			submenu = ISContextMenu:getNew(context)
			context:addSubMenu(tileContext, submenu)

			tileSubMenu(tileContext, context, "Premium Containers", item, player, containertiles, containertilenames, containertiledescriptions)
			--tileSubMenu(tileContext, context, "Decorations", item, player, decorationtiles, decorationtilenames)
			--tileSubMenu(tileContext, context, "Decorations (Signs/Wall)", item, player, walldecorationtiles, walldecorationtilenames)
			tileSubMenu(tileContext, context, "Premium Refrigerators", item, player, fridgetiles, fridgetilenames, fridgetiledescriptions)
			--tileSubMenu(tileContext, context, "Lights", item, player, lighttiles, lighttilenames)
			--tileSubMenu(tileContext, context, "Ovens", item, player, oventiles, oventilenames)
			--tileSubMenu(tileContext, context, "Plants (1/2)", item, player, planttiles1, planttilenames1)
			--tileSubMenu(tileContext, context, "Plants (2/2)", item, player, planttiles2, planttilenames2)
			--tileSubMenu(tileContext, context, "Seating", item, player, seatingtiles, seatingtilenames)
			--tileSubMenu(tileContext, context, "Tables", item, player, tabletiles, tabletilenames)
			break
		end
	end
end

Events.OnFillInventoryObjectContextMenu.Add(tileBoxContext) -- everytime you rightclick an object in your inventory it will trigger this check to add a teleport option