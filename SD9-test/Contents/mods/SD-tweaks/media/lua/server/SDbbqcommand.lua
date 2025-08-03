if isClient() then return end

local getBarbecue = function(x, y, z)
	local gs = getCell():getGridSquare(x, y, z)
	if not gs then return nil end
	for i=0,gs:getObjects():size()-1 do
		local o = gs:getObjects():get(i)
		if o and instanceof(o, 'IsoBarbecue') then
			return o
		end
	end
	return nil
end

--normal distribution number generator, rounding down to nearest 0.1
local function gaussianRandom()
    -- Generate two random integers between 0 and 999
    local u1 = ZombRand(1000) / 1000
    local u2 = ZombRand(1000) / 1000
    local z0 = math.sqrt(-2.0 * math.log(u1)) * math.cos(2 * math.pi * u2)
    return z0
end


local function scaledNormal()
    local z = gaussianRandom() 

    z = math.max(-2.5, math.min(2.5, z)) 

    -- Scale and shift to the 0-1 range
    local scaledValue = (z + 2.5) / 5
    scaledValue = scaledValue^1.33 --shift normal distribution to the left. set to 1.0 for a traditional normal distribution.
    scaledValue = math.floor(scaledValue * 10 + 0.5) / 10
    return scaledValue
end

local function SDbbq(module, command, player, args)
	if module == "SDbbq" then
		local bbq = getBarbecue(args.x, args.y, args.z)
		if command == "removePropaneTank" then
			if bbq and bbq:hasPropaneTank() then
				local tank = bbq:removePropaneTank()
				bbq:sendObjectChange('state')
				newtank = InventoryItemFactory.CreateItem("Base.PropaneTank")
				newtank:setUsedDelta(scaledNormal())
				player:getSquare():AddWorldInventoryItem(newtank, 0.5, 0.5, 0)
			end
		elseif command == "insertPropaneTank" then
			if bbq then
				local tank = bbq:removePropaneTank()
				if tank then
					newtank = InventoryItemFactory.CreateItem("Base.PropaneTank")
					newtank:setUsedDelta(0)
					player:getSquare():AddWorldInventoryItem(newtank, 0.5, 0.5, 0)
				end
				tank = InventoryItemFactory.CreateItem("Base.PropaneTank")
				tank:setUsedDelta(args.delta)
				bbq:setPropaneTank(tank)
				bbq:sendObjectChange('state')
			end
		end
	end
end

Events.OnClientCommand.Add(SDbbq)
