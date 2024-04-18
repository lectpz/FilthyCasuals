require "Items/ItemPicker"
require "Items/SuburbsDistributions"
require "Items/ProceduralDistributions"
require "Vehicles/VehicleDistributions"

local function preDistributionMerge()
---------------------------------------------------------------------------------

	local weaponCacheData = {
		CampingStoreGear = 0.0001,
		FireStorageTools = 0.001,
		GigamartTools = 0.0001,
		PawnShopGunsSpecial = 0.002,
		MeleeWeapons = 0.004,
		JanitorTools = 0.0001,
		BurglarTools = 0.0001,
		PoliceStorageGuns = 0.002,
		WardrobeWoman = 0.00001,
		PawnShopKnives = 0.001,
		GardenStoreTools = 0.00001,
		BarCounterWeapon = 0.00001,
		BedroomDresser = 0.000001,
		ToolStoreTools = 0.0001,
		GunStoreAmmunition = 0.001,
		WardrobeMan = 0.0001,
		GunStoreDisplayCase = 0.001,
		PoliceStorageAmmunition = 0.0001,
		ArmyStorageGuns = 0.001,
		GunStoreShelf = 0.001
	}

	for distribution, chance in pairs(weaponCacheData) do
		table.insert(ProceduralDistributions.list[distribution].items, "WeaponCache")
		table.insert(ProceduralDistributions.list[distribution].items, chance)
	end

-------------------------------------------------------------------------------------
end
Events.OnPreDistributionMerge.Add(preDistributionMerge)

local function OnPostDistributionMerge()

	local function CopyLoot(old_name, new_name, mult)
		local function isTableEmpty(t)
			return t == nil or next(t) == nil
		end

		local function patch(t)
			for i = #t, 1, -1 do
				if t[i] == old_name then
					local num = (t[i + 1] or 0.01) * mult
					if old_name == new_name then
						t[i + 1] = num  -- overwrite
					elseif new_name == 0 then
						table.remove(t, i)
						table.remove(t, i)
					else
						table.insert(t, i, new_name)
						table.insert(t, i + 1, num)
					end
				end
			end
		end

		local function processTableRecursive(t)
			for k, v in pairs(t) do
				if type(v) == "table" then
					if k == "items" or k == "junk" then
						patch(v)
					end
					processTableRecursive(v)
				end
			end
		end

		mult = mult or 1

		for _, topLevelTable in pairs(SuburbsDistributions) do
			processTableRecursive(topLevelTable)  -- Process the top-level table
		end

		for proc, p in pairs(ProceduralDistributions.list) do
			processTableRecursive(p)
		end

		for vehicle, p in pairs(VehicleDistributions) do
			processTableRecursive(p)
		end
	end


	local yeetitem = {"RMWeapons.NulBlade", "RMWeapons.bassax", "RMWeapons.crabspear", "RMWeapons.themauler", "RMWeapons.warhammer40k", "RMWeapons.MizutsuneSword", "RMWeapons.Nikabo", "RMWeapons.firelink", "RMWeapons.mace1", "RMWeapons.Falx", "RMWeapons.kindness", "RMWeapons.Crimson1Sword", "RMWeapons.MorningStar", "RMWeapons.BrushAxe", "RMWeapons.sword40k", "RMWeapons.LastHope", "RMWeapons.sawbat1", "RMWeapons.spikedleg", "RMWeapons.TrenchShovel", "RMWeapons.CrimsonLance", "RMWeapons.warhammer", "RMWeapons.MightCleaver", "RMWeapons.Thawk", "RMWeapons.bonkhammer", "RMWeapons.club1", "RMWeapons.PiroCraftKnife", "RMWeapons.steinbeer"}
	local yeetno = #yeetitem

	for i=1,yeetno do
		CopyLoot(yeetitem[i], 0)
	end

end

Events.OnPostDistributionMerge.Add(OnPostDistributionMerge)