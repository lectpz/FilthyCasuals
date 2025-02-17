require 'Items/ProceduralDistributions'

for _,magazine in pairs(UdderlyAmmoCrafting.Magazines) do
	table.insert(ProceduralDistributions.list["BookstoreBooks"].items, magazine);
	table.insert(ProceduralDistributions.list["BookstoreBooks"].items, .05);
	table.insert(ProceduralDistributions.list["LibraryBooks"].items, magazine);
	table.insert(ProceduralDistributions.list["LibraryBooks"].items, .05);
	table.insert(ProceduralDistributions.list["MagazineRackMixed"].items, magazine);
	table.insert(ProceduralDistributions.list["MagazineRackMixed"].items, .05);
	-- table.insert(ProceduralDistributions.list["ShelfGeneric"].items, magazine);
	-- table.insert(ProceduralDistributions.list["ShelfGeneric"].items, .0125);
	-- table.insert(ProceduralDistributions.list["GunStoreShelf"].items, magazine);
	-- table.insert(ProceduralDistributions.list["GunStoreShelf"].items, .25);
end

local ammoCans =
{
	"Base.AmmoCan9",
	"Base.AmmoCan45",
	"Base.AmmoCan38",
	"Base.AmmoCan44",
	"Base.AmmoCan223",
	"Base.AmmoCan308",
	"Base.AmmoCan12",
	"Base.AmmoCan556",
	"Base.AmmoCan762",
}

local ammoCansSmall =
{
	"Base.AmmoCanSmall9",
	"Base.AmmoCanSmall45",
	"Base.AmmoCanSmall38",
	"Base.AmmoCanSmall44",
	"Base.AmmoCanSmall223",
	"Base.AmmoCanSmall308",
	"Base.AmmoCanSmall12",
	"Base.AmmoCanSmall556",
	"Base.AmmoCanSmall762",
}

local ammoSpawns =
{
	"PoliceStorageAmmunition",
	"GunStoreAmmunition",
	"ArmyStorageAmmunition",
	--"GunStoreCounter", --This is substituting for DisplayCase since it makes more sense for cans.
	--"GunStoreDisplayCase" --This only makes sense for non-ammo-can ammo.
	--"GunStoreShelf", --Redundant, things have this + ammo usually.
	--"PoliceStorageGuns", --Use ammo one instead.. will include both normally on a container.
	--"ArmyStorageGuns", --Use ammo one instead.. will include both normally on a container.
}

-- for _,can in pairs(ammoCans) do
-- 	for _,spawn in pairs(ammoSpawns) do
-- 		table.insert(ProceduralDistributions.list[spawn].items, can)
-- 		table.insert(ProceduralDistributions.list[spawn].items, .0000000025 / #ammoCans)
-- 	end
-- end


-- for _,can in pairs(ammoCansSmall) do
-- 	for _,spawn in pairs(ammoSpawns) do
-- 		table.insert(ProceduralDistributions.list[spawn].items, can)
-- 		table.insert(ProceduralDistributions.list[spawn].items, .000000075 / #ammoCansSmall)
-- 	end
-- end