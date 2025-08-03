Currency = Currency or {}

Currency.Wallets = Currency.Wallets or {}
Currency.Wallets["Base.Wallet"] = true
Currency.Wallets["Base.Wallet2"] = true
Currency.Wallets["Base.Wallet3"] = true
Currency.Wallets["Base.Wallet4"] = true

Currency.BaseCoin = "Base.CopperCoin"
Currency.SpecialCoin = "Base.EventCoin"
Currency.UseSpecialCoin = true

Currency.Coins = Currency.Coins or {}
Currency.Coins[Currency.SpecialCoin] = {value = 0, specialCoin = true}
Currency.Coins[Currency.BaseCoin] = {value = 1}
Currency.Coins["Base.SilverCoin"] = {value = 250}
Currency.Coins["Base.GoldCoin"] = {value = 500}

Currency.CoinsTexture = {
	Coin = {
		texture = getTexture("media/textures/Item_CopperCoin.png"),
		scale = 15
	},
	SpecialCoin = {
		texture = getTexture("media/textures/Item_EventCoin.png"),
		scale = 15
	},
}

Currency.WalletTexture = {
	Account = {
		texture = getTexture("media/textures/Wallet_Account.png"),
		scale = 15
	},
}

function Currency.format(quantity)
	_, found= string.find(quantity, '%.')
	if found then
		quantity = string.format("%.2f",quantity)
	end
	while true do  
        quantity, k = string.gsub(quantity, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then break end
    end
    return quantity
end