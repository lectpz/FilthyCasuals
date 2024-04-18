-- function to split the sandbox string into a table. my brute force way to bypass the limitations of sandbox var string delimiter. parses the input string and pulls out the everything between spaces.
local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "%S+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local s1 = splitString("Base.AirMags Base.Bag_DivisionBackpackLarge")
local s1n = #s1
local s1price = splitString("3 15")

for i=1,s1n do
	Shop.Items[s1[i]] = { tab = Tab.CosmeticsEvent, price = s1price[i], specialCoin = true }
end
