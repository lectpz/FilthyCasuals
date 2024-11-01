local function wrap(class,method,before,after)
    local original = class[method]
    class[method] = function(...)
        if before then before(...) end
        local result = original(...)
        if after then after(...) end
        --if after then result = after(result,...) end
        return result
    end
end

local function patch(class,method,patchFn)
    class[method] = patchFn(class[method])
end

require "TimedActions/ISInventoryTransferAction"
wrap(ISInventoryTransferAction,"transferItem",nil,CBioGasSystem.postInventoryTransferAction)

require "Moveables/ISMoveablesAction"
wrap(ISMoveablesAction,"perform",CBioGasSystem.onMoveablesAction,nil)