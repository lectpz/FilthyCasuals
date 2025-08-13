--Wallets are the item/items that you want to use to "save" your money
Currency.Wallets = {} --Clears default Wallet items from the main mod nshops
-- Currency.Wallets["Base.CreditCard"] = true
Currency.Wallets["Base.Wallet"] = true
Currency.Wallets["Base.Wallet2"] = true
Currency.Wallets["Base.Wallet3"] = true
Currency.Wallets["Base.Wallet4"] = true

--Items that are going to be use as a coin/money
Currency.BaseCoin = "Base.ScrapMetal"
Currency.SpecialCoin = "Base.SCoin"

Currency.UseSpecialCoin = true -- In case you want to use a special type of currency (event type stuff) set this to true

--Coins/Money definition
--Sets the real value for item used as currency
Currency.Coins[Currency.SpecialCoin] = {value = 0, specialCoin = true}
Currency.Coins[Currency.BaseCoin] = {value = 1}

--Coins/Money texture display in Transfer/Shop UI
Currency.CoinsTexture = {
	Coin = {
		texture = getTexture("media/textures/ScrapMetal.png"),
		scale = 15
	},
	SpecialCoin = {
		texture = getTexture("media/textures/Item_SCoin.png"),
		scale = 15
	},
}