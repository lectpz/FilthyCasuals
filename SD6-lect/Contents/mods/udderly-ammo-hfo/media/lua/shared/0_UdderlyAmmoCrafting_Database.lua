print("[UdderlyAmmoCrafting] Initializing Database..")

UdderlyAmmoCrafting={}

UdderlyAmmoCrafting.Magazines=
{
	"Magazine_UdderlyAmmoCrafting_1_Ammo",
	"Magazine_UdderlyAmmoCrafting_2_Magazine",
	"Magazine_UdderlyAmmoCrafting_3_Gunpowder",
}

UdderlyAmmoCrafting.safetyCount = 0

UdderlyAmmoCrafting.RecipeAssignments=
{
	--Vol.1
	{
		"Craft9Round",
		"Craft38Round",
		"Craft45Round",
		"Craft556Round",
		"Craft223Round",
		"Craft545Round",
		"Craft792Round",
		"Craft44Round",
		"Craft12Shell",
		"Craft308Round",
		"Craft762Round",
		"Craft50BMGRound",
		"Craft792x33Round",
		"Craft762x54rRound",
		"Craft380Round",
		"Craft57Round",
		"Craft3006Round",
                "Craft9x39Round",
                "Craft762x51Round",
	},
	--Vol.2
	{
		"Craft22Mag10",
		"Craft9Mag13",
		"Craft9Mag15",
		"Craft9Mag17",
		"Craft9Mag20",
		"Craft9Mag30",
		"Craft45Mag7",
		"Craft44Mag8",
		"Craft308Mag20",
		"Craft308Mag3",
		"Craft556Mag30",
		"Craft762Mag30",
	},
	--Vol.3
	{
		"CraftGunpowder",
		"CraftCharcoal",
		"Scrap9Round",
		"Scrap38Round",
		"Scrap45Round",
		"Scrap556Round",
		"Scrap223Round",
		"Scrap545Round",
		"Scrap792Round",
		"Scrap44Round",
		"Scrap12Shell",
		"Scrap308Round",
		"Scrap762Round",
		"Scrap50BMGRound",
		"Scrap792x33Round",
		"Scrap762x54rRound",
		"Scrap380Round",
		"Scrap57Round",
		"Scrap3006Round",
                "Scrap9x39Round",
                "Scrap762x51Round",
	},
}

--Recipe Functions

	--OnCreate

function UdderlyAmmoCrafting.IgnoreCount(items, result, player)
	result:setCount(1)

	-- Report to server every 100 ammo crafted
	UdderlyAmmoCrafting.safetyCount = UdderlyAmmoCrafting.safetyCount + 1
	if math.fmod(UdderlyAmmoCrafting.safetyCount,100) == 0 then
		sendClientCommand(player, 'SundayDriversSecurity', 'UdderlyAmmoCraftingCreated100', {});
	end
end

function UdderlyAmmoCrafting.OnCreateGiveScrap(items, result, player)
	player:getInventory():AddItem("Base.ScrapMetal")
end

function UdderlyAmmoCrafting.OnCreateGiveScrapBits50PercentChance1(items, result, player)
	if ZombRand(2) == 1 then
		player:getInventory():AddItem("Base.ScrapMetalBits")
	end
end

function UdderlyAmmoCrafting.OnCreateGiveScrapBits1(items, result, player)
	player:getInventory():AddItem("Base.ScrapMetalBits")
end

function UdderlyAmmoCrafting.OnCreateGiveScrapBits2(items, result, player)
	player:getInventory():AddItems("Base.ScrapMetalBits", 2)
end

function UdderlyAmmoCrafting.OnCreateGiveScrapBits3(items, result, player)
	player:getInventory():AddItems("Base.ScrapMetalBits", 3)
end

function UdderlyAmmoCrafting.OnCreateGiveScrapBits4(items, result, player)
	player:getInventory():AddItems("Base.ScrapMetalBits", 4)
end

function UdderlyAmmoCrafting.OnCreateGiveScrapBits5(items, result, player)
	player:getInventory():AddItems("Base.ScrapMetalBits", 5)
end

function UdderlyAmmoCrafting.OnCreateGiveScrapBits6(items, result, player)
	player:getInventory():AddItems("Base.ScrapMetalBits", 6)
end

function UdderlyAmmoCrafting.OnCreateGiveScrapBits7(items, result, player)
	player:getInventory():AddItems("Base.ScrapMetalBits", 7)
end

function UdderlyAmmoCrafting.OnCreateGiveScrapBits8(items, result, player)
	player:getInventory():AddItems("Base.ScrapMetalBits", 8)
end

function UdderlyAmmoCrafting.OnCreateGiveScrapBits9(items, result, player)
	player:getInventory():AddItems("Base.ScrapMetalBits", 9)
end

function UdderlyAmmoCrafting.OnCreateGiveScrapBits10(items, result, player)
	player:getInventory():AddItems("Base.ScrapMetalBits", 10)
end

---@param player IsoGameCharacter
function UdderlyAmmoCrafting.ConsolidateGunpowder(amount,result,player)
	amount = amount * .001
	local otherGunpowders = player:getInventory():getItemsFromType("Base.GunPowder")
	for i=0, otherGunpowders:size()-1 do
		---@type DrainableComboItem
		local otherGunpowder = otherGunpowders:get(i)
		if otherGunpowder:getUsedDelta() < 1 then
			local gunpowderAmount = otherGunpowder:getUsedDelta() + amount
			if gunpowderAmount > 1 then
				amount = gunpowderAmount-1
				gunpowderAmount = 1
			else
				amount = 0
			end
			otherGunpowder:setUsedDelta(gunpowderAmount)
			if amount == 0 then
				return
			end
		end
	end
	if amount>0 then
		local remainderPowder = player:getInventory():AddItem("Base.GunPowder")
		remainderPowder:setUsedDelta(amount)
	end
end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder50PercentChance1(items, result, player)
	if ZombRand(2)==1 then
		UdderlyAmmoCrafting.ConsolidateGunpowder(1,result,player)
	end

end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder1(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(1,result,player)
end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder2(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(2,result,player)
end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder3(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(3,result,player)
end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder4(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(4,result,player)
end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder5(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(5,result,player)
end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder6(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(6,result,player)
end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder7(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(7,result,player)
end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder8(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(8,result,player)
end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder9(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(9,result,player)
end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder10(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(10,result,player)
end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder11(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(11,result,player)
end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder12(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(12,result,player)
end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder13(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(13,result,player)
end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder14(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(14,result,player)
end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder15(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(15,result,player)
end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder16(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(16,result,player)
end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder17(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(17,result,player)
end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder18(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(18,result,player)
end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder19(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(19,result,player)
end

function UdderlyAmmoCrafting.OnCreateGiveGunpowder20(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(20,result,player)
end
function UdderlyAmmoCrafting.OnCreateGiveGunpowder21(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(21,result,player)
end
function UdderlyAmmoCrafting.OnCreateGiveGunpowder22(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(22,result,player)
end
function UdderlyAmmoCrafting.OnCreateGiveGunpowder23(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(23,result,player)
end
function UdderlyAmmoCrafting.OnCreateGiveGunpowder24(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(24,result,player)
end
function UdderlyAmmoCrafting.OnCreateGiveGunpowder25(items, result, player)
	UdderlyAmmoCrafting.ConsolidateGunpowder(25,result,player)
end
	--OnGiveXP

function UdderlyAmmoCrafting.ReloadingXP2(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Reloading, 2);
end