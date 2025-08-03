--Default Tabs
Tab["All"] = "All"
Tab["Event"] = "Event"
Tab["KP"] = "KP"
Tab["PawLow"] = "PawLow"
Tab["Misc"] = "Misc"
Tab["Vehicles"] = "Vehicles"
Tab["GearSets"] = "GearSets"
Tab["Sell"] = "Sell"
Tab["Favorite"] = "Favorite"

--Custom Tabs definition
Tab["Meds"] = "Meds"

Shop.Tabs = {} --Clear all Tabs in case you dont want the default ones included in main mod nshops
Shop.Items= {} --Clear all Shop Items in case you dont want the default ones included in main mod nshops

--Add tabs to the shop (Tabs in the Shop UI will show up in this order)
Shop.Tabs[Tab.Misc] = getText("IGUI_Tab_Misc")
Shop.Tabs[Tab.KP] = getText("IGUI_Tab_KP")
Shop.Tabs[Tab.PawLow] = getText("IGUI_Tab_PawLow")
Shop.Tabs[Tab.Vehicles] = getText("IGUI_Tab_Vehicles")
Shop.Tabs[Tab.GearSets] = getText("IGUI_Tab_GearSets")
Shop.Tabs[Tab.Event] = getText("IGUI_Tab_Event")
Shop.Tabs[Tab.Sell] = getText("IGUI_Tab_Sell") -- Sell tab(if you don't want to use the Sell feature then remove it)
Shop.Tabs[Tab.Favorite] = getText("IGUI_Tab_Favorite") --Tab Display name, use IG_UI_EN.txt or you can hardcode it here
Shop.Tabs[Tab.All] = getText("IGUI_Tab_All")
-- Shop.Tabs[Tab.Meds] = getText("IGUI_Tab_Meds")
