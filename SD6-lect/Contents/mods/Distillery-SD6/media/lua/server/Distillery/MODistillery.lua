if isClient() then return end

require "Distillery/SDistillerySystem"

local function LoadDistillery(isoObject)
	print("loading the Distillery object")
	SDistillerySystem.instance:loadIsoObject(isoObject)
end

MapObjects.OnLoadWithSprite("distillery_tileset_01_0", LoadDistillery, 5)