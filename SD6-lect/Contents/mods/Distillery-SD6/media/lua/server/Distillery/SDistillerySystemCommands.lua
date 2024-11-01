if isClient() then
    return
end
require "Distillery/SDistillerySystem"

local Commands = {}

--local function print(message) SDistillerySystem.instance:print(message) end

local function getLuaDistillery(args)
    return SDistillerySystem.instance:getLuaObjectAt(args.x, args.y, args.z)
end

local function getIsoDistillery(luaObject)
    return luaObject:getIsoObject()
end

local function checkPower(isodis, dis)
    
    local worldPower = getWorld():isHydroPowerOn()
    local square = isodis:getSquare()

    if worldPower and not square:isOutside() then
        dis.hasPower = true
    elseif square:haveElectricity() then
        dis.hasPower = true
    else
        dis.hasPower = false
    end

    return dis.hasPower
end

function Commands.activateDistillery(player,args)
    local dis = getLuaDistillery(args[1])

    if checkPower(getIsoDistillery(dis), dis) then
        dis.active = args[2]
    end
    
    dis:saveData(true)
end

function Commands.addInput(player,args)

    local dis = getLuaDistillery(args[1])
    
    local input = args[2]
    if input:getType() == "MoonshineMash" then
        dis.mode = "moonshine"
        dis.input = 8
    end

    dis:saveData(true)
end

function Commands.redistillEthanol(player,args)
    local dis = getLuaDistillery(args[1])

    local newData = args[2]

    dis.mode = newData["mode"]
    dis.tank = newData["tank"]
    dis.input = newData["input"]
    if checkPower(getIsoDistillery(dis), dis) then
        dis.active = newData["active"]
    end
    
    dis:saveData(true)
end

function Commands.drainMoonshine(player,args)
    local dis = getLuaDistillery(args[1])

    if getIsoDistillery(dis) then
        dis.tank = 0
        dis.mode = "None"
        dis.input = 0
        dis.active = false

        dis:saveData(true)
    end
end

function Commands.drainGas(player,args)
    local dis = getLuaDistillery(args[1])
    local isodis = getIsoDistillery(dis)

    if isodis then
        dis.tank = dis.tank - args[2]
        
        if dis.tank <= 0 then
            dis.tank = 0
            dis.mode = "None"
            dis.input = 0
            dis.active = false
        end
        
        dis:saveData(true)
    end
end

SDistillerySystemCommands = Commands