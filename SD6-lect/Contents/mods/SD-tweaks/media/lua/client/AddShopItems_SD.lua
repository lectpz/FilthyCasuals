local function addshopitems()
	--Shop.Items["SoulForge.EmptySoulFlaskWhite"] = {tab = "Tab.Event", price = 1, specialCoin = true}
	Shop.Items["Base.EngraveKit"] = {tab = "Tab.Event", price = 1, specialCoin = true}
	Shop.Items["Base.VehicleSkinChanger"] = {tab = "Tab.Event", price = 1, specialCoin = true}
	Shop.Items["Base.BusPass"] = {tab = "Tab.Event", price = 1, specialCoin = true}

--	Shop.Items["SoulForge.EmptySoulFlaskYellow"] = {tab = "Tab.Event", price = 1, specialCoin = true}
--	Shop.Items["SoulForge.EmptySoulFlaskRed"] = {tab = "Tab.Event", price = 1, specialCoin = true}
--	Shop.Items["SoulForge.EmptySoulFlaskPurple"] = {tab = "Tab.Event", price = 1, specialCoin = true}
--	Shop.Items["SoulForge.EmptySoulFlaskPink"] = {tab = "Tab.Event", price = 1, specialCoin = true}
--	Shop.Items["SoulForge.EmptySoulFlaskGreen"] = {tab = "Tab.Event", price = 1, specialCoin = true}
--	Shop.Items["SoulForge.EmptySoulFlaskCyan"] = {tab = "Tab.Event", price = 1, specialCoin = true}
--	Shop.Items["SoulForge.EmptySoulFlaskBlue"] = {tab = "Tab.Event", price = 1, specialCoin = true}
	--print("Added shop items for Flasks")
	
	Shop.Items["Base.Sandbag"] = {tab = "Tab.Misc", price = 5, Coin = true}
	Shop.Items["Base.SmashedBottle"] = {tab = "Tab.Misc", price = 3, Coin = true}
	Shop.Items["Base.TileCacheRegular"] = {tab = "Tab.Event", price = 25, Coin = true}
	Shop.Items["Base.TileCachePremium"] = {tab = "Tab.Event", price = 350, Coin = true}
	--print("Added items SD5")
end

Events.OnGameStart.Add(addshopitems)