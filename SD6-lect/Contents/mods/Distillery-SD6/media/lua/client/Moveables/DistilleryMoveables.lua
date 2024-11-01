require "Moveables/ISMoveableDefinitions"

Events.OnGameBoot.Add(function()
    local defs = ISMoveableDefinitions:getInstance()
    defs.addScrapDefinition( "Distillery",  {"Base.Screwdriver"}, {}, Perks.Electricity,  2000, "Dismantle", true, 10)
    defs.addScrapItem( "Distillery", "Radio.ElectricWire", 3, 80, true )
    defs.addScrapItem( "Distillery", "Base.ElectronicsScrap", 6, 80, true )
    defs.addScrapItem( "Distillery", "Base.MetalBar", 4, 60, true )
    defs.addScrapItem( "Distillery", "Base.SmallSheetMetal", 5, 60, true )
end)