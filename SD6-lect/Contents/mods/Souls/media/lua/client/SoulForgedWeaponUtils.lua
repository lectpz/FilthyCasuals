WeaponUtils = {}

function WeaponUtils.isAugmented(modData)
    return (modData.Augments or 0) > 0
end

function WeaponUtils.addAugment(modData)
    modData.Augments = (modData.Augments or 0) + 1
end

function WeaponUtils.getAugmentCount(modData)
    return (modData.Augments or 0)
end

-- TODO: Create weapon name generation
