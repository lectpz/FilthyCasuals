require "Map/CGlobalObjectSystem"

CBioGasSystem = CGlobalObjectSystem:derive("CBioGasSystem")

function CBioGasSystem:new()
	local o = CGlobalObjectSystem.new(self, "HomeBioGas")
	return o
end

function CBioGasSystem:isValidIsoObject(isoObject)
	return instanceof(isoObject, "IsoThumpable") and isoObject:getTextureName() == "biogas_tileset_01_0"
end

function CBioGasSystem:newLuaObject(globalObject)
	return CBioGas:new(self, globalObject)
end

function CBioGasSystem.postInventoryTransferAction(o,item)
    local src, dest, character = o.srcContainer:getParent(), o.destContainer:getParent(), o.character
    local put = dest and dest:getTextureName() == "biogas_tileset_01_0"
    if not put then return end

    if not (item:getCategory() == "Food") then
        character:Say(getText("IGUI_BioGas_NotFood", item:getDisplayName()))
        return
    end
end

function CBioGasSystem.onMoveablesAction(o)

    if o.mode == "pickup" and o.origSpriteName == "biogas_tileset_01_0" then
        local isoObjectSpecial = BioGasUtilities.findOnSquare(o.square,o.origSpriteName)

        if isoObjectSpecial then
            isoObjectSpecial:getModData().methane = nil
            isoObjectSpecial:getModData().biowaste = nil
            isoObjectSpecial:getModData().fertilizer = nil
        end
    end
end

CGlobalObjectSystem.RegisterSystemClass(CBioGasSystem)