require "Shop"

PlayerShop = PlayerShop or {}
PlayerShop.Tabs = PlayerShop.Tabs or {}
PlayerShop.Tabs[Tab.All] = getText("IGUI_Tab_All")
PlayerShop.status= {}
PlayerShop.spritePrefix = "playershop_"

PlayerShop.sprites = {
	NoSign = {
		"playershop_0",
		"playershop_1",
	},
	FirstAid = {
		"playershop_2",
		"playershop_3",
	},
	Food = {
		"playershop_4",
		"playershop_5",
	},
	Clothes = {
		"playershop_18",
		"playershop_19",
	},
	Melee = {
		"playershop_6",
		"playershop_7",
	},
	Guns = {
		"playershop_8",
		"playershop_9",
	},
	Ammo = {
		"playershop_16",
		"playershop_17",
	},
	Furniture = {
		"playershop_10",
		"playershop_11",
	},
	Materials = {
		"playershop_12",
		"playershop_13",
	},
	Misc = {
		"playershop_14",
		"playershop_15",
	},
	Freezer = {
		"playershop_20",
		"playershop_21",
	},
}