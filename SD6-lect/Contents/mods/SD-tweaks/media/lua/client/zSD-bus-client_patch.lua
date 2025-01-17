local tp_loc = {
	["cc"] = { 11072, 8851, 0 },
	["cc_shops"] = { 11250, 8903, 0 },
--[[	["rs"] = { 5964, 5276, 0 },
	["wp"] = { 12074, 7235, 0},
	["ivy"] = { 8778, 9760, 1},
	["rw"] = { 8256, 11886, 0},
	["lv"] = { 13240, 3508, 0},
	["lv_central"] = { 13386, 2373, 0 },
	["rc"] = { 5210, 10645, 0},
	["ec"] = { 10457, 17218, 0},
	["bbl"] = { 7015, 7574, 0},
	["lc"] = { 15444, 6521, 0},
	["DD_entrance"] = { 9737, 6275, 0 },
	["DD_outpost1"] = { 8816, 4531, 0 },
	["DD_outpost2"] = { 2918, 2483, 0 },]]
}

local stopName = {
	["cc"] = "Muldraugh Community Center",
	["cc_shops"] = "Community Center Shops (East)",
--[[	["rs"] = "Riverside",
	["wp"] = "West Point Outpost",
	["ivy"] = "Ivy Lake",
	["rw"] = "Rosewood",
	["lv"] = "Louisville",
	["lv_central"] = "Louisville Central",
	["rc"] = "Raven Creek",
	["ec"] = "Eerie County",
	["bbl"] = "Big Bear Lake",
	["lc"] = "Lake Cumberland",
	["DD_entrance"] = "Dirkerdam FOB",
	["DD_outpost1"] = "Dirkerdam South City Outpost",
	["DD_outpost2"] = "Dirkerdam North-West Outpost",]]
}

local function playSoundWhenMoveFrom(playerObj,x,y)

    local context = {}
    context.remaining = 10

    local tick_loop = function(ticks)
        if (ticks % 100 == 0) -- quite different depending on the client (FPS), average 30
        then
            context.remaining = context.remaining - 1;
            print(context.remaining);

            local current_x = math.floor(playerObj:getX());
            local current_y = math.floor(playerObj:getY());

            local far_away = math.abs(current_x - x) > 100 or
                             math.abs(current_y - y) > 100;

            if far_away
            then
                getSoundManager():PlayWorldSound("bus-leaving", false, getPlayer():getCurrentSquare(), 0.2, 10, 0.05, false) ;
            end

            if context.remaining == 0 or far_away
            then
                Events.OnTick.Remove(context.tick_loop);
            end
        end
    end
    context.tick_loop = tick_loop;
    Events.OnTick.Add(tick_loop);
end

local function makeNotAvailable(option)
    option.notAvailable = true
    local tooltip = ISWorldObjectContextMenu.addToolTip();
    tooltip.description = tooltip.description .. "Location not available yet"
    option.toolTip = tooltip
end

local function isBusStop(busstop, x, y)
	return x >= tp_loc[busstop][1]-2 and y >= tp_loc[busstop][2]-2 and x <= tp_loc[busstop][1]+2 and y <= tp_loc[busstop][2]+2
end

local function getLocation(x,y)
  for busstop,_ in pairs(tp_loc) do
    if isBusStop(busstop, x, y) then
      return busstop
    end
  end
  return nil
end

PublicTransportationContextMenuObjectName = PublicTransportationContextMenuObjectName or {}

PublicTransportationContextMenuObjectName.onTakingTheBus = function(item, destination)
    local playerObj = getSpecificPlayer(0);

    local x = math.floor(playerObj:getX());
    local y = math.floor(playerObj:getY());
    local z = math.floor(playerObj:getZ());

    local location = getLocation(x,y)
    if location ~= nil
    then
        local args = {
            x = x,
            y = y,
            z = z,
            destination = destination
        };
        --sendClientCommand(playerObj, 'SDBus', 'BusTicketUsed', args);
		playerObj:setX(tp_loc[destination][1])
		playerObj:setY(tp_loc[destination][2])
		playerObj:setZ(tp_loc[destination][3])
		playerObj:setLx(tp_loc[destination][1])
		playerObj:setLy(tp_loc[destination][2])
		playerObj:setLz(tp_loc[destination][3])
        if item:getType() == "BusTicket" then
			item:getContainer():Remove(item);
		end
        playSoundWhenMoveFrom(playerObj,x,y);
    else
        playerObj:Say("Not a valid bus stop.");
    end
end

-- Thanks bikinihorst!
local function HasZombiesNearby(player,x,y)
--[[    local zombies = player:getCell():getZombieList()
    local zCount = zombies:size()

    local result = 0

    if zCount > 0
    then
        local zombie = nil;
        local pSquare = player:getSquare()

        for i = zCount - 1, 0, -1
        do
            zombie = zombies:get(i)

            if pSquare:DistToProper(zombie:getSquare()) <= 20
            then
                result = result + 1
            end
        end
    end

    return result]]
	return player:getStats():getNumVisibleZombies()

end

SD6_PublicTransportationContextMenuObjectName = {}
SD6_PublicTransportationContextMenuObjectName.doMenu = function(player, context, items)

    local playerObj = getSpecificPlayer(player);
    for i,v in ipairs(items) do
        local item = v;
        if not instanceof(v, "InventoryItem") then
            item = v.items[1];
        end
        if item:getType() then
            if item:getType() == "BusTicket" or item:getType() == "BusPass" then

                local option_bus = context:addOption("Take the Bus", item, nil, player);
                local x = math.floor(playerObj:getX())
                local y = math.floor(playerObj:getY())

                local total_zombies = HasZombiesNearby(playerObj,x,y)

                if total_zombies > 0 then
                    option_bus.notAvailable = true
                    local tooltip = ISWorldObjectContextMenu.addToolTip();
                    tooltip.description = tooltip.description .. "There are " .. total_zombies .. " zombie(s) nearby, the bus won't stop here."
                    option_bus.toolTip = tooltip
                else
                    local location = getLocation(x,y)
                    if location == nil
                    then
                        option_bus.notAvailable = true
                        local tooltip = ISWorldObjectContextMenu.addToolTip();
                        tooltip.description = tooltip.description .. "You need to be inside a bus stop to use this."
                        option_bus.toolTip = tooltip
                    else
						local sub_menu = ISContextMenu:getNew(context)
						context:addSubMenu(option_bus, sub_menu);
                        for busstop,_ in pairs(tp_loc) do
							if stopName[busstop] then
								local option = sub_menu:addOption(stopName[busstop], item, PublicTransportationContextMenuObjectName.onTakingTheBus, busstop)
								if location == busstop then
									option.notAvailable = true
								end
							end
						end
                    end
                    break;
                end
            end
        end
    end
end

local function overwriteSDBus()
	Events.OnPreFillInventoryObjectContextMenu.Remove(PublicTransportationContextMenuObjectName.doMenu);
	Events.OnPreFillInventoryObjectContextMenu.Add(SD6_PublicTransportationContextMenuObjectName.doMenu);
end
Events.OnGameStart.Add(overwriteSDBus)