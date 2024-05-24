local function removePlatings(upgradeList)
    local newUpgradeList = {}
    for _, upgrade in ipairs(upgradeList) do
        if not string.match(upgrade, "%a+Plating%a*") then -- Use a stricter pattern
            table.insert(newUpgradeList, upgrade) 
        end
    end
    return newUpgradeList
end

local function hfo_removeplating()
	for weapon, upgrades in pairs(WeaponUpgrades) do
		WeaponUpgrades[weapon] = removePlatings(upgrades)
	end
end

Events.OnPostDistributionMerge.Add(hfo_removeplating)