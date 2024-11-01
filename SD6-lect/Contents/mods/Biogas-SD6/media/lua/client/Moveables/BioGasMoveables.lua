require "Moveables/ISMoveableDefinitions"

Events.OnGameBoot.Add(function()
    local defs = ISMoveableDefinitions:getInstance()
    defs.addScrapDefinition( "HomeBioGas",  {"Base.Screwdriver"}, {}, Perks.Electricity,  2000, "Dismantle", true, 10)
    defs.addScrapItem( "HomeBioGas", "Radio.ElectricWire", 3, 80, true )
    defs.addScrapItem( "HomeBioGas", "Base.ElectronicsScrap", 6, 80, true )
    defs.addScrapItem( "HomeBioGas", "Base.MetalBar", 4, 60, true )
    defs.addScrapItem( "HomeBioGas", "Base.SmallSheetMetal", 5, 60, true )
end)