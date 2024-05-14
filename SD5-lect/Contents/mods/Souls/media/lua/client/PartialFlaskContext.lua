----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

local function PartialFlaskContext(player, context, items)
    local playerObj = getSpecificPlayer(player)
    local playerInv = playerObj:getInventory()
    items = ISInventoryPane.getActualItems(items)

    for _, item in ipairs(items) do
        if item:getFullType() == 'SoulForge.StoredSouls' then
            local soulsStored = math.ceil(item:getUsedDelta() * 1000 )
            local soulsCapacity = 1000 - soulsStored
            local weapon = playerObj:getPrimaryHandItem()

            -- Weapon Validation
            if not weapon or not weapon:IsWeapon() or weapon:isRanged() then
                return -- Not a valid weapon or is ranged, exit early
            end

            local weaponModData = weapon:getModData()
            local soulsFreed = weaponModData.KillCount or 0

            if soulsStored < 1000 and soulsFreed > 0 then -- Flask not full, weapon has souls
                local function transferSouls(item, player, fullFill)
                    local transferAmount = fullFill and soulsCapacity or math.min(soulsFreed, soulsCapacity)
                    weaponModData.KillCount = soulsFreed - math.floor(transferAmount)
                    item:setUsedDelta((soulsStored + math.floor(transferAmount)) / 1000)
                end

                local optionText = soulsFreed >= soulsCapacity and "Fill Soul Flask"
                context:addOption(optionText, item, transferSouls, player, soulsFreed >= soulsCapacity) 
			end
			
			if soulsFreed and soulsStored > 999 then -- Flask is full
				return
			elseif soulsFreed and soulsStored > 0	 then -- Flask has souls

				local function infuseWeapon(item, player)
					weaponModData.KillCount = soulsFreed + soulsStored
					item:getContainer():Remove(item)
					playerObj:getInventory():AddItem("SoulForge.EmptySoulFlaskWhite")
				end
				context:addOption("Infuse Souls Into Weapon", item, infuseWeapon, player)

			end

            break  
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(PartialFlaskContext)
