-- function to split the sandbox string into a table. my brute force way to bypass the limitations of sandbox var string delimiter. parses the input string and pulls out the everything between spaces.
local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "%S+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local s1 = splitString("Base.AlienCap Base.AlienBackPack Base.AstroHelmet Base.AstroSpiffo_WorldItem Base.Hat_Beany Base.Bender_WorldItem Base.SpiffoBig Base.Hat_Claire_Rat Trelai.Hat_Crown1 Base.Bandshirt Base.DisrespectMullet Base.Glasses_Eyepatch_Left Trelai.Hat_Crown2 Base.Hat_FurryEars Base.FutureJacket Base.Hat_GasMask Base.ScifiHelmet01 Base.Gloves_WhiteTINT Base.Hat_HockeyMask Base.Hat_Jay Base.MedievalHelmet Base.Glasses_Normal Base.Hat_Raccoon Base.RoboCopHelmet Base.SheriffEliHat Base.SpaceHelmet Base.Dress_StarTrekDress1 Base.Shirt_StarTrekShirt1 Base.StormTrooperHelmet Base.Hat_WinterHat Base.Bag_DivisionBackpackMedium")
local s1n = #s1
local s1price = splitString("15 15 50 50 15 50 50 50 35 25 50 15 35 15 50 25 50 15 15 15 50 15 25 50 15 50 25 25 50 75 50")

for i=1,s1n do
	Shop.Items[s1[i]] = { tab = Tab.Cosmetics, price = s1price[i] }
end
