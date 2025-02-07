----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

local function PartialFlaskContext(player, context, items)
    local playerObj = getSpecificPlayer(player)
    local playerInv = playerObj:getInventory()
    items = ISInventoryPane.getActualItems(items)

    --for _, item in ipairs(items) do
	for i=1, #items do
		item = items[i]
		--[[if item:getFullType() == 'SoulForge.EmptySoulFlaskWhite' and item:isInPlayerInventory() then
			item:getContainer():Remove(item)
			local soulFlask = InventoryItemFactory.CreateItem("SoulForge.StoredSouls")
			soulFlask:setUsedDelta(0)
			playerObj:getInventory():AddItem(soulFlask)
		end]]
        if item:getFullType() == 'SoulForge.StoredSoulsSD_new' and item:isInPlayerInventory() then
			local flaskCharges = 10000
            local soulsStored = math.floor((item:getUsedDelta()*flaskCharges)+0.5)
            local soulsCapacity = flaskCharges - soulsStored
            --local weapon = playerObj:getPrimaryHandItem()

			playerItems = playerInv:getItems()
			for j=0,playerItems:size()-1 do
				local invItem = playerItems:get(j)
				isBrokenWeapon = invItem:isBroken() and invItem:IsWeapon()
				if isBrokenWeapon then 
					--print("invItem:" .. invItem:getName() .. " is broken")
					local weaponModData = invItem:getModData()
					local soulsFreed = weaponModData.KillCount
					if soulsStored < flaskCharges and soulsFreed and soulsFreed > 0 then -- Flask not full, weapon has souls and weapon is broken
						local function transferSouls(item, player, fullFill)
							local transferAmount = fullFill and soulsCapacity or math.min(soulsFreed, soulsCapacity)
							weaponModData.KillCount = soulsFreed - math.floor(transferAmount+0.5)
							item:setUsedDelta((soulsStored + math.floor(transferAmount+0.5)) / flaskCharges)
						end

						--local optionText = soulsFreed >= soulsCapacity and "Fill Soul Flask"
						context:addOption("Fill Soul Flask Using Broken Weapon", item, transferSouls, player, soulsFreed >= soulsCapacity) 
						break
					end
				end
			end
			--[[
			-- Weapon Validation
            if not weapon or not weapon:IsWeapon() or weapon:isRanged() then
			    return -- Not a valid weapon or is ranged. Check for broken weapons, then exit early
            end

            local weaponModData = weapon:getModData()
            local soulsFreed = weaponModData.KillCount or 0]]

            --[[if soulsStored < 1000 and soulsFreed >= 0 then -- Flask not full, weapon has souls
                local function transferSouls(item, player, fullFill)
                    local transferAmount = fullFill and soulsCapacity or math.min(soulsFreed, soulsCapacity)
                    weaponModData.KillCount = soulsFreed - math.floor(transferAmount)
                    item:setUsedDelta((soulsStored + math.floor(transferAmount)) / 1000)
                end

                --local optionText = soulsFreed >= soulsCapacity and "Fill Soul Flask"
                context:addOption("Fill Soul Flask", item, transferSouls, player, soulsFreed >= soulsCapacity) 
			end]]
			
			--[[if soulsFreed and soulsStored > 999 then -- Flask is full
				return
			elseif soulsFreed and soulsStored >= 0	 then -- Flask has souls

				local function infuseWeapon(item, player)
					weaponModData.KillCount = soulsFreed + soulsStored
					--item:getContainer():Remove(item)
					--playerObj:getInventory():AddItem("SoulForge.EmptySoulFlaskWhite")
					item:getContainer():Remove(item)
					local soulFlask = InventoryItemFactory.CreateItem("SoulForge.StoredSouls")
					soulFlask:setUsedDelta(0)
					playerObj:getInventory():AddItem(soulFlask)
				end
				context:addOption("Infuse Souls Into Weapon", item, infuseWeapon, player)
			end]]

            break  
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(PartialFlaskContext)