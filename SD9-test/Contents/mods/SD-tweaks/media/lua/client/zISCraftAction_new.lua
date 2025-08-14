local original_new = ISCraftAction.new
function ISCraftAction:new(character, item, time, recipe, container, containers)
    local o = original_new(self, character, item, time, recipe, container, containers)
		
	--print("old o.maxTime",o.maxTime)
	if SDxferQOL then o.maxTime = o.maxTime * 0.25 end
	--print("new o.maxTime",o.maxTime)
	
    return o
end