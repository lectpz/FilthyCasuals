local function overwriteSaveUses()

	Recipe.OnCreate.SaveUses = function(items, result, player)
		print(string.format("[SaveUses] start - items count=%d, result=%s", items:size(), result:getFullType()))
		local remainingUses = {};
		local firstItem = items:get(0)
		local firstItemFT = firstItem:getFullType()

		for i = 0, items:size() - 1 do
			---@type Item
			local item = items:get(i)
			if item and item:getFullType() == firstItemFT then
				print(string.format("[SaveUses] processing item %d: %s", i, item:getFullType()))
				-- Try to get delta regardless of item type
				local delta = nil
				if item.getDelta then
					delta = item:getDelta()
					print(string.format("[SaveUses] item %d delta=%s", i, tostring(delta)))
				else
					print(string.format("[SaveUses] item %d has no getDelta method", i))
				end

				-- Only save valid delta values
				if delta ~= nil and type(delta) == "number" then
					table.insert(remainingUses, delta)
					print(string.format("[SaveUses] saved delta %.3f for item %d", delta, i))
				else
					-- Use default value for items without delta or corrupted/missing delta
					table.insert(remainingUses, 1.0)
					print(string.format("[SaveUses] using default 1.0 for item %d (delta was %s)", i, tostring(delta)))
				end
			else
				print(string.format("[SaveUses] item %d is nil", i))
			end
		end

		-- Only save if we have valid data
		if #remainingUses > 0 then
			result:getModData().PackRatRemainingUses = remainingUses
			print(string.format("[SaveUses] saved %d uses to modData", #remainingUses))
		else
			print("[SaveUses] no valid uses to save")
		end
		print("[SaveUses] done")
	end

end

Events.OnGameStart.Add(overwriteSaveUses)