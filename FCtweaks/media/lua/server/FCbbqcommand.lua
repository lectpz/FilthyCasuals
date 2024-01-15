if isClient() then return end

local Commands = {};
local moduleName = "FCbbq";

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

local bbq = getBarbecue(args.x, args.y, args.z)

function Commands.removePropaneTank(module, command, player, args)
	if bbq and bbq:hasPropaneTank() then
		local tank = bbq:removePropaneTank()
		bbq:sendObjectChange('state')
		player:getSquare():AddWorldInventoryItem("Base.Processedcheese", 0.5, 0.5, 0)
	end
end

function Commands.insertPropaneTank(module, command, player, args)
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

local OnClientCommand = function(player, module, command, args)
    if module == moduleName and Commands[command] then
        args = args or {}
        Commands[command](args);
    end
end

Events.OnClientCommand.Add(OnClientCommand)