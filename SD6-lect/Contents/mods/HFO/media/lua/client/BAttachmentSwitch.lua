-- gun things 3: the crrangedabbening

BWTweaks = BWTweaks or {};

BWTweaks["attachmentSwitches"] = BWTweaks["attachmentSwitches"] or {};

-- allows you to define attachment item swaps easily. the script detects which one is installed and swaps with the other, so the order for attachment 1/2 does not matter
-- note 1: multiple attachment swaps per weapon are possible and all that apply are shown in the context menu
-- note 2: the attachments do not have to occupy the same slot
-- note 3: the contextTitle parameter should ideally be a translation key but can also be a hard coded string value
-- example 1: toggle between 2 different scopes on the hunting rifle (with and without translation key)
-- BWTweaks:addToggleOption("Base.HuntingRifle", "Base.x2Scope", "Base.x4Scope", "IGUI_Gun_ToggleScope2_4");
-- BWTweaks:addToggleOption("Base.HuntingRifle", "Base.x2Scope", "Base.x4Scope", "Toggle scope (2x / 4x)");

function BWTweaks:addToggleOption(fullType, attachment1, attachment2, contextTitle)
    BWTweaks["attachmentSwitches"][fullType] = BWTweaks["attachmentSwitches"][fullType] or {};

    table.insert(BWTweaks["attachmentSwitches"][fullType], {
        attachment1 = attachment1,
        attachment2 = attachment2,
        text = getText(contextTitle),
    });
end

-- replaces an installed attachment with another one, created on the fly, silently

function BWTweaks:replaceAttachment(weapon, oldId, newId)
    local oldItem = BWTweaks:partIsInstalled(weapon, oldId);

    if oldItem
    then
        local newItem = InventoryItemFactory.CreateItem(newId);

        weapon:detachWeaponPart(oldItem);
        weapon:attachWeaponPart(newItem);

        getPlayer():resetEquippedHandsModels();

        if BWTweaks["checkForModelChange"]
        then
            BWTweaks:checkForModelChange(firstItem);
        end
    end
end

-- check if any of the given parts in the list is installed and return the first hit

function BWTweaks:isAnyPartInstalled(weapon, partList)
    local parts = weapon:getAllWeaponParts();

    for i = 0, parts:size() - 1
    do
        local part = parts:get(i);

        for i, partType in ipairs(partList)
        do
            if part:getFullType() == partType
            then
                return part;
            end
        end
    end

    return false;
end

-- events

Events.OnFillInventoryObjectContextMenu.Add(function(player, context, clickedItems)
    local firstItem = clickedItems[1];

    if clickedItems[1]["items"]
    then
        firstItem = clickedItems[1]["items"][1];
    end

    local firstItemType = firstItem:getFullType();

    for fullType, configs in pairs(BWTweaks["attachmentSwitches"])
    do
        --print("checking if item is type " .. tostring(fullType));

        if firstItemType == fullType
        then
            --print(" -> item has correct type");

            for i, config in ipairs(configs)
            do
                local installed = BWTweaks:isAnyPartInstalled(firstItem, {
                    config["attachment1"], config["attachment2"]
                });

                --print(" - checking if " .. tostring(config["attachment1"]) .. " or " .. tostring(config["attachment2"]) .. " are installed");

                if installed
                then
                    --print(" -> found part: " .. tostring(installed:getFullType()));

                    context:addOption(config["text"], firstItem, function(firstItem)
                        local installedIsType1 = installed:getFullType() == config["attachment1"];

                        BWTweaks:replaceAttachment(firstItem, installedIsType1
                            and config["attachment1"]
                            or config["attachment2"],
                        installedIsType1
                            and config["attachment2"]
                            or config["attachment1"]
                        );
                    end);
                end
            end
        end
    end
end);