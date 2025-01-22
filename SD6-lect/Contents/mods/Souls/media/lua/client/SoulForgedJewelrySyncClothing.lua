local EventHandlers = require('SoulForgedJewelryEventHandlers')

Events.EveryOneMinute.Add(function()
    EventHandlers.OnClothingUpdated(getPlayer())
end)