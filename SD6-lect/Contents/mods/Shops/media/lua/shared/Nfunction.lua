local Nfunction = {}

 function Nfunction.trimString(str,limit)
    local len = string.len(str)
    if len > limit then
        str = string.sub(str,1,limit-3) .. "..."
    end
    return str
end

function Nfunction.drainablePrice(item,price)
    if instanceof(item, "DrainableComboItem") then
        price = math.floor(price*item:getUsedDelta())
        if price<=0 then
            price = 1
        end  
    end
    return price
end

local shopItems = {}
function Nfunction.logShop(coords,action)
    local username = getPlayer():getUsername()
    if not action then
        action = "Purchase"
    end
    local log = username .." ".. coords.x ..",".. coords.y ..",".. coords.z .." "..action.." ["
    local first = true
    for k,v in pairs(shopItems) do
        if first then
            first = false
            log = log .. k.."="..v
        else
            log = log.."," .. k.."="..v
        end
    end
    log = log.."]"
    shopItems = {}
    sendClientCommand("LS", "TransactionShopLog", {log})
end

function Nfunction.buildLogShop(type,quantity)
    if not shopItems[type] then
        local count = 1
        if quantity then count = quantity end
        shopItems[type] = count
    else
        shopItems[type] = shopItems[type] + 1
    end
end

return Nfunction