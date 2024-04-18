--Default Tabs
Tab["All"] = "All"
Tab["Utility"]="Utility"
Tab["Cosmetics"]="Cosmetics"
Tab["CosmeticsEvent"]="Event Cosmetics"
Tab["Weapons"]="Weapons"
Tab["WeaponsEvent"]="Event Weapons"
Tab["Sell"] = "Sell"
Tab["Favorite"] = "Favorite"

--Custom Tabs definition
Tab["Meds"] = "Meds"

Shop.Tabs = {} --Clear all Tabs in case you dont want the default ones included in main mod nshops
Shop.Items= {} --Clear all Shop Items in case you dont want the default ones included in main mod nshops

--Add tabs to the shop (Tabs in the Shop UI will show up in this order)
Shop.Tabs[Tab.Favorite] = getText("IGUI_Tab_Favorite") --Tab Display name, use IG_UI_EN.txt or you can hardcode it here
Shop.Tabs[Tab.Sell] = getText("IGUI_Tab_Sell") -- Sell tab(if you don't want to use the Sell feature then remove it)
Shop.Tabs[Tab.All] = getText("IGUI_Tab_All")
Shop.Tabs[Tab.Weapons] = getText("IGUI_Tab_Weapons")
Shop.Tabs[Tab.WeaponsEvent] = getText("IGUI_Tab_WeaponsEvent")
Shop.Tabs[Tab.Cosmetics] = getText("IGUI_Tab_Cosmetics")
Shop.Tabs[Tab.CosmeticsEvent] = getText("IGUI_Tab_CosmeticsEvent")
Shop.Tabs[Tab.Utility] = getText("IGUI_Tab_Utility")
--Shop.Tabs[Tab.Meds] = getText("IGUI_Tab_Meds") 