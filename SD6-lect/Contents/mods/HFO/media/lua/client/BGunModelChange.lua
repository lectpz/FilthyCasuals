-- crabby gun things: part 2

require "TimedActions/ISUpgradeWeapon";
require "TimedActions/ISRemoveWeaponUpgrade";
require "TimedActions/ISEquipWeaponAction";
require "TimedActions/ISUnequipAction";
require "TimedActions/ISInsertMagazine";
require "TimedActions/ISEjectMagazine";
require "TimedActions/ISRackFirearm";
require "TimedActions/ISUnloadBulletsFromFirearm";
require "TimedActions/ISReloadWeaponAction";
require "TimedActions/ISAttachItemHotbar";
require "TimedActions/ISDetachItemHotbar";

BWTweaks = BWTweaks or {};

BWTweaks["needsAttackEvent"] = BWTweaks["needsAttackEvent"] or false;
BWTweaks["modelChanges"] = BWTweaks["modelChanges"] or {};

-- adds a model to the possible changes dependent on parts installed and/or mag being present, as well as round chambered. you can mix and mash however you want.
-- note 1: needs full item ids because of compatibility with non base namespaced mods
-- note 2: multiple different parts per gun possible - just add another call of this method
-- note 3: latest change always wins. if no change applies the model is reverted to the default one.
-- example 1: change model of "Base.HuntingRifle" to "HuntingRifleFGS" when attachment "Base.FiberglassStock" is present, regardless of magazine
-- BWTweaks:changeModelBy("Base.HuntingRifle", "HuntingRifleFGS", {
--     attachment = "Base.FiberglassStock",
-- });
-- example 2: change model of "Base.HuntingRifle" to "HuntingRifleFGS_NoMag" when attachment "Base.FiberglassStock" is present and magazine is not inserted
-- BWTweaks:changeModelBy("Base.HuntingRifle", "HuntingRifleFGS_NoMag", {
--     attachment = "Base.FiberglassStock",
--     magazine = false,
-- });
-- example 3: change model of "Base.HuntingRifle" to "HuntingRifleFGS_Mag" when attachment "Base.FiberglassStock" is present and magazine is inserted
-- BWTweaks:changeModelBy("Base.HuntingRifle", "HuntingRifleFGS_Mag", {
--     attachment = "Base.FiberglassStock",
--     magazine = true,
-- });
-- example 4: change model of "Base.HuntingRifle" to "HuntingRifle_NoMag" when no magazine is present. normally a weapon model has a mag attached so only the "no mag" variant needs to be explicitly defined
-- BWTweaks:changeModelBy("Base.HuntingRifle", "HuntingRifle_NoMag", {
--     magazine = false,
-- });
-- example 5: change model of "Base.HuntingRifle" to "HuntingRifleFGS_NoMag" when no round is chambered and attachment "Base.FiberglassStock" is present
-- BWTweaks:changeModelBy("Base.HuntingRifle", "HuntingRifleFGS_NoMag", {
--     attachment = "Base.FiberglassStock",
--     chambered = false,
-- });

function BWTweaks:changeModelBy(fullType, modelOnFitsCriteria, criteria)
    BWTweaks["modelChanges"][fullType] = BWTweaks["modelChanges"][fullType] or {};

    table.insert(BWTweaks["modelChanges"][fullType], {
        model = modelOnFitsCriteria,
        criteria = criteria,
    });

    if type(criteria["attachment"]) ~= "table"
    then
        criteria["attachment"] = {
            criteria["attachment"],
        };
    end

    if criteria["chambered"] ~= nil
    then
        BWTweaks["needsAttackEvent"] = true;
    end
end

-- wrapper method: change model when attachment is installed
-- example:
-- BWTweaks:changeModelByAttachment("Base.HuntingRifle", "Base.FiberglassStock", "HuntingRifleFGS");

function BWTweaks:changeModelByAttachment(fullType, attachmentType, model)
    BWTweaks:changeModelBy(fullType, model, {
        attachment = attachmentType,
    });
end

-- wrapper method: change model depending on magazine presence
-- example 1: set model when no mag is in the gun
-- BWTweaks:changeModelByMagPresent("Base.HuntingRifle", false, "HuntingRifle_NoMag");
-- example 2: set model when a mag is present. normally this would revert to the default model
-- BWTweaks:changeModelByMagPresent("Base.HuntingRifle", true, "HuntingRifle");

function BWTweaks:changeModelByMagPresent(fullType, isPresent, model)
    BWTweaks:changeModelBy(fullType, model, {
        magazine = isPresent,
    });
end

-- wrapper method: change model depending on round chambered
-- example 1: set model to fiberglass (gray) when the rifle has no round loaded
-- BWTweaks:changeModelByRoundChambered("Base.HuntingRifle", false, "HuntingRifleFGS");
function BWTweaks:changeModelByRoundChambered(fullType, isChambered, model)
    BWTweaks:changeModelBy(fullType, model, {
        chambered = isChambered,
    });
end

-- wrapper method: change model depending on magazine and attachment presence
-- example 1: set model when fiberglass stock is installed and no mag is in the gun
-- BWTweaks:changeModelByAttachmentAndMagPresent("Base.HuntingRifle", "Base.FiberglassStock", false, "HuntingRifleFGS_NoMag");
-- example 2: set model when fiberglass stock is installed and a mag is present
-- BWTweaks:changeModelByAttachmentAndMagPresent("Base.HuntingRifle", "Base.FiberglassStock", false, "HuntingRifleFGS");

function BWTweaks:changeModelByAttachmentAndMagPresent(fullType, attachmentType, isPresent, model)
    BWTweaks:changeModelBy(fullType, model, {
        attachment = attachmentType,
        magazine = isPresent,
    });
end

-- wrapper method: change model depending on chambered round and attachment presence
-- example 1: set model when fiberglass stock is installed and nothing is in the chamber
-- BWTweaks:changeModelByAttachmentAndRoundChambered("Base.HuntingRifle", "Base.FiberglassStock", false, "HuntingRifleFGS_NoMag");

function BWTweaks:changeModelByAttachmentAndRoundChambered(fullType, attachmentType, isChambered, model)
    BWTweaks:changeModelBy(fullType, model, {
        attachment = attachmentType,
        chambered = isChambered,
    });
end

-- check if part is installed by full type

function BWTweaks:partIsInstalled(weapon, partType)
    local parts = weapon:getAllWeaponParts();

    for i = 0, parts:size() - 1
    do
        local part = parts:get(i);

        if part:getFullType() == partType
        then
            return part;
        end
    end

    return false;
end

-- change the model if needed. last condition that fits criteria wins.

function BWTweaks:checkForModelChange(weapon)
    if weapon and instanceof(weapon, "HandWeapon")
    then
        local fullType = weapon:getFullType();

        if BWTweaks["modelChanges"][fullType]
        then
            local newModel = nil;

            --print("processing model change conditions for weapon [" .. tostring(fullType) .. "]:");

            for i, config in ipairs(BWTweaks["modelChanges"][fullType])
            do
                --print(" - config #" .. tostring(i));

                local fitsConfig = true;

                if config["criteria"]["attachment"] ~= nil
                then
                    for i, attachment in ipairs(config["criteria"]["attachment"])
                    do
                        --print("    - config depends on attachment being present: " .. tostring(attachment));

                        if not BWTweaks:partIsInstalled(weapon, attachment)
                        then
                            fitsConfig = false;
                        end
                    end
                end

                if config["criteria"]["magazine"] ~= nil
                then
                    local containsMag = weapon:isContainsClip();

                    --print("    - config depends on magazine being present: " .. tostring(config["criteria"]["magazine"]) .. " vs. " .. tostring(containsMag));

                    if not containsMag == config["criteria"]["magazine"]
                    then
                        --print("    -> magazine requirement not fulfilled");

                        fitsConfig = false;
                    end
                end

                if config["criteria"]["chambered"] ~= nil
                then
                    local isChambered = weapon:haveChamber()
                        and weapon:isRoundChambered()
                        or weapon:getCurrentAmmoCount() > 0;

                    --print("    - config depends on round chambered: " .. tostring(config["criteria"]["chambered"]) .. " vs. " .. tostring(isChambered));

                    if not isChambered == config["criteria"]["chambered"]
                    then
                        --print("    -> chambered requirement not fulfilled");

                        fitsConfig = false;
                    end
                end

                if fitsConfig
                then
                    --print(" -> all requirements fulfilled. changing model to [" .. tostring(config["model"]) .. "]");

                    newModel = config["model"];
                end
            end

            if not newModel
            then
                newModel = weapon:getOriginalWeaponSprite();
            end

            weapon:setWeaponSprite(newModel);
            getPlayer():resetEquippedHandsModels();
        end
    end
end

-- hooks and events to change models

for i, actionCls in ipairs({
    "ISUpgradeWeapon", "ISRemoveWeaponUpgrade",
    "ISEquipWeaponAction", "ISUnequipAction",
    "ISInsertMagazine", "ISEjectMagazine",
    "ISRackFirearm", "ISUnloadBulletsFromFirearm", "ISReloadWeaponAction",
    "ISAttachItemHotbar", "ISDetachItemHotbar",
})
do
    if _G[actionCls]
    then
        local vanillaActionFn = _G[actionCls]["perform"];

        _G[actionCls]["perform"] = function(self)
            ----print("ACTION: " .. tostring(actionCls));

            vanillaActionFn(self);

            local item = self["item"] or self["weapon"] or self["gun"];

            if item
            then
                BWTweaks:checkForModelChange(item);
            end
        end
    end
end

Events.OnGameStart.Add(function()
    getPlayer():getInventory():containsEvalRecurse(function(item)
        BWTweaks:checkForModelChange(item);
    end);
end);

Events.OnPlayerAttackFinished.Add(function()
    if BWTweaks["needsAttackEvent"]
    then
        local player = getPlayer();

        for i, item in ipairs({
            player:getPrimaryHandItem(), player:getSecondaryHandItem(),
        })
        do
            if item and item:getAmmoType()
            then
                BWTweaks:checkForModelChange(item);
            end
        end
    end
end);