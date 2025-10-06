----------------
--somewhatfrog--
----------------

local function changeWeaponSkin(item, playerIndex)
    local player = getSpecificPlayer(playerIndex)
    local inventory = player:getInventory()
    local primaryHandItem = player:getPrimaryHandItem()

    if not inventory:contains("Base.WeaponSkinChanger") then return end
    if not primaryHandItem then return end
    if not primaryHandItem:IsWeapon() then return end
    if primaryHandItem:isRanged() then return end
    if not item:isInPlayerInventory() then return end

    local weaponSprite = item:getWeaponSprite()
    primaryHandItem:setWeaponSprite(weaponSprite)
    inventory:RemoveOneOf("Base.WeaponSkinChanger")
    inventory:Remove(item)
end

local function addOptionWeaponSkinChanger(playerIndex, table, items)
    local player = getSpecificPlayer(playerIndex)
    local inventory = player:getInventory()
    local primaryHandItem = player:getPrimaryHandItem()

    if not inventory:contains("Base.WeaponSkinChanger") then return end
    if not primaryHandItem then return end
    if not primaryHandItem:IsWeapon() then return end
    if primaryHandItem:isRanged() then return end

    for i = 1, #items do
        local item = items[i]
        if not instanceof(item, "InventoryItem") then item = item.items[1] end

        if not item:isInPlayerInventory() then return end
        if not item:IsWeapon() then return end
        if item:isRanged() then return end
        if item == primaryHandItem then return end
        if not OnTest_dontDestroySouls(item) then return end

        local sourceName = item:getDisplayName()
        local destinationName = primaryHandItem:getDisplayName()
        local sourceCategory = tostring(item:getCategories()):gsub("Improvised, ", "")
        local destinationCategory = tostring(primaryHandItem:getCategories()):gsub("Improvised, ", "")

        local addOption = table:addOption("Change " .. destinationName .. " skin to " .. sourceName .. " (will be consumed). Re-equip the weapon after skin change", item, changeWeaponSkin, playerIndex)
        if sourceCategory ~= destinationCategory then
            addOption.notAvailable = true
            local addToolTip = ISInventoryPaneContextMenu.addToolTip()
            addToolTip.description = "Skin change requires a weapon of the same category"
            addOption.toolTip = addToolTip
        end
    end
end
Events.OnFillInventoryObjectContextMenu.Add(addOptionWeaponSkinChanger)
