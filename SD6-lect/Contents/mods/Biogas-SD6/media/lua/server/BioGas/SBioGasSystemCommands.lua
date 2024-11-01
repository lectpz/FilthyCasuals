if isClient() then
    return
end
require "BioGas/SBioGasSystem"

local Commands = {}

--local function print(message) SBioGasSystem.instance:print(message) end

local function getLuaBioGas(args)
    return SBioGasSystem.instance:getLuaObjectAt(args.x, args.y, args.z)
end

local function getIsoBioGas(luaObject)
    return luaObject:getIsoObject()
end

function Commands.plungeBiowaste(player,args)

    local hbg = getLuaBioGas(args[1])
    local isohbg = getIsoBioGas(hbg)
    
    if args[2] > 0 then
        hbg.biowaste = args[2] 
    end
        
    hbg:saveData(true)
end

function Commands.siphonMethane(player, args)
    local hbg = getLuaBioGas(args[1])
    local isohbg = getIsoBioGas(hbg)

    if isohbg then
        hbg.methane = hbg.methane - args[2]
        if hbg.methane < 0 then
            hbg.methane = 0
        end
        
        hbg:saveData(true)
    end
end


function Commands.drainFertilizer(player, args)
    local hbg = getLuaBioGas(args[1])
    local isohbg = getIsoBioGas(hbg)

    if isohbg then
        hbg.fertilizer = hbg.fertilizer - args[2]
        if hbg.fertilizer < 0 then
            hbg.fertilizer = 0
        end
        
        hbg:saveData(true)
    end
end

SBioGasSystemCommands = Commands
