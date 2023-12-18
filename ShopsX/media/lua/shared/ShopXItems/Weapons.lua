-- function to split the sandbox string into a table. my brute force way to bypass the limitations of sandbox var string delimiter. parses the input string and pulls out the everything between spaces.
local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "%S+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local s1 = splitString("Base.AK47_Hardened Base.AK47_Golden Base.CAR15_FOREST Base.CAR15_DESERT Base.DoubleBarrelShotgun_METAL Base.FAL_DESERT Base.FAL_RHODESIAN Base.FAL_URBAN Base.Revolver_Long_GOLDEN Base.AssaultRifle2_DESERT Base.AssaultRifle2_FOREST Base.AssaultRifle Base.AssaultRifle_DESERT Base.AssaultRifle_FOREST Base.SniperRifle_DRAGONLORE Base.MAC10Unfolded_GOLDEN Base.MP5_FOREST Base.MP5_NAVY")
local s1n = #s1
local s1price = splitString("500 500 500 500 500 700 700 700 250 300 300 400 500 500 250 400 350 350")

for i=1,s1n do
	Shop.Items[s1[i]] = { tab = Tab.Weapons, price = s1price[i] }
end
