local flasktable = {
	"SoulForge.SoulFlaskWaterWhite",
	"SoulForge.SoulFlaskWaterYellow",
	"SoulForge.SoulFlaskWaterRed",
	"SoulForge.SoulFlaskWaterPurple",
	"SoulForge.SoulFlaskWaterPink",
	"SoulForge.SoulFlaskWaterGreen",
	"SoulForge.SoulFlaskWaterCyan",
	"SoulForge.SoulFlaskWaterBlue",
	"SoulForge.SoulFlaskWaterBlack"
}

local indexedFlasks = {}

for _, flaskName in ipairs(flasktable) do
    local item = ScriptManager.instance:getItem(flaskName)
    indexedFlasks[flaskName] = item
end

if getActivatedMods():contains("BetterSortCC") then
    for flask,_ in pairs(indexedFlasks) do
        local item = indexedFlasks[flask]
		if item then
			item:DoParam("DisplayCategory = Container")
			item:DoParam("DisplayCategory = FoodB")
		end
	end
end

if getActivatedMods():contains("Authentic Z - Current") or getActivatedMods():contains("AuthenticZLite") or getActivatedMods():contains("AuthenticZBackpacks+") or getActivatedMods():contains("nattachments") then
    for flask,_ in pairs(indexedFlasks) do
        local item = indexedFlasks[flask]
		if item then
			item:DoParam("AttachmentType = Canteen")
		end
	end
end