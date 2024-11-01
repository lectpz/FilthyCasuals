require 'ISUI/Maps/ISMapDefinitions'

local MINZ = 0

local function overlayPNG(mapUI, x, y, scale, layerName, tex, alpha)
	local texture = getTexture(tex)
	if not texture then return end
	local mapAPI = mapUI.javaObject:getAPIv1()
	local styleAPI = mapAPI:getStyleAPI()
	local layer = styleAPI:newTextureLayer(layerName)
	layer:setMinZoom(MINZ)
	layer:addFill(MINZ, 255, 255, 255, (alpha or 1.0) * 255)
	layer:addTexture(MINZ, tex)
	layer:setBoundsInSquares(x, y, x + texture:getWidth() * scale, y + texture:getHeight() * scale)
end

local FlyerX1 = 10
local FlyerY1 = 10

local FlyerX2 = 1034
local FlyerY2 = 1290;

LootMaps.Init.manual_ethanol = function(mapUI)
	local mapAPI = mapUI.javaObject:getAPIv1()
	MapUtils.initDirectoryMapData(mapUI, 'media/maps/Muldraugh, KY')
	mapAPI:setBoundsInSquares(FlyerX1, FlyerY1, FlyerY2, FlyerX2)
	overlayPNG(mapUI, FlyerX1, FlyerY1, 1.0, "lootMapPNG", "media/ui/LootableMaps/manual_ethanol.png", 1.0)
end