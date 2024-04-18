--Item definition for selling stuff, if the item is not here the default price will be Shop.defaultPrice 
-- and broken price will be Shop.defaultPriceBroken

-- If a item has a sell price equal to 0 it won't show up in the ShopUI window
Shop.defaultPrice = 2 -- Default sell price for items 
Shop.defaultPriceBroken = 1 -- Default sell price for broken items
Shop.SellisBlacklist = false -- Use Shop.Sell as blacklist
Shop.SellisWhitelist = true -- Use Shop.Sell as whitelist
-- If Shop.SellisBlacklist and Shop.SellisWhitelist set to false every item is sellable
Shop.Sell = {
	--["Base.KeyRing"] = {blacklisted = true}, --Blacklisted item overrides Shop.SellisWhitelist setting for this item will be price = Shop.defaultPrice
	--["Base.BaseballBat"] = { price = 45, priceBroken = 2, }, -- Overides Shop.defaultPrice and Shop.defaultPriceBroken
	--["Base.Crowbar"] = { price = 0, priceBroken = 2, }, -- Only show up in the sell tab when is broken because price = 0
	--["Base.Machete"] = { price = 5, priceBroken = 0, }, -- Only show up in the sell tab when is not broken because priceBroken = 0
	--["Base.BlowTorch"] = { price = 50 }, -- Overides Shop.defaultPrice
	--["Base.CreditCard"] = { price = 100 , specialCoin = true }, -- Item price = 100 using the special coin/money
	["Base.CreditCard"] = { price = 5 },
}