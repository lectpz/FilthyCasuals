if isClient() then return end

require "BioGas/SBioGasSystem"

local function LoadBioGas(isoObject)
	SBioGasSystem.instance:loadIsoObject(isoObject)
end

MapObjects.OnLoadWithSprite("biogas_tileset_01_0", LoadBioGas, 5)