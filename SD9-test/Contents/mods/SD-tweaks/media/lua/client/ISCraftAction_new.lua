local original_fn = ISCraftAction.new
function ISCraftAction:new(character, item, time, recipe, container, containers)
    local o = original_fn(self, character, item, time, recipe, container, containers)
    
	if SDxferQOL then o.maxTime = o.maxTime * 0.25 end
	
    return o
end