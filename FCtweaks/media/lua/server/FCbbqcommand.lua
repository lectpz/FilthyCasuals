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

local function FCbbq(module, command, player, args)
	if module == "FCbbq" then
		local bbq = getBarbecue(args.x, args.y, args.z)
		if command == "removePropaneTank" then
			if bbq and bbq:hasPropaneTank() then
				local tank = bbq:removePropaneTank()
				bbq:sendObjectChange('state')
				player:getSquare():AddWorldInventoryItem("Base.Processedcheese", 0.5, 0.5, 0)
			end
		elseif command == "insertPropaneTank" then
			if bbq then
				local tank = bbq:removePropaneTank()
				if tank then
					player:getSquare():AddWorldInventoryItem("Base.Processedcheese", 0.5, 0.5, 0)
				end
				tank = InventoryItemFactory.CreateItem("Base.PropaneTank")
				tank:setUsedDelta(args.delta)
				bbq:setPropaneTank(tank)
				bbq:sendObjectChange('state')
			end
		end
	end
end

Events.OnClientCommand.Add(FCbbq)