local EventHandlers = require('SoulForgedJeweleryEventHandlers')

Events.EveryOneMinute.Add(function()
    EventHandlers.OnClothingUpdated(getPlayer())
end)