local distributionTable = VehicleDistributions[1]

VehicleDistributions.V100GloveBox = {
    rolls = 3,
    items ={
        "Pistol", 3,
        "9mmClip", 2,
        "Bullets9mm", 1,
	"556Clip", 1,
        "556Box", 1,
	"HuntingKnife", 2,
        "FirstAidKit", 5,
    }
}

VehicleDistributions.V100MilitaryStuff = {
    rolls = 2,
    items ={
        "Bag_ALICEpack_Army", 2,
        "Vest_BulletArmy", 2,
        "Hat_Army", 3,
        "Hat_GasMask", 2,
		"HolsterSimple", 3,
        "Trousers_CamoGreen", 3,
        "Shirt_CamoGreen", 3,
        "Jacket_ArmyCamoGreen", 1,
        "Hat_BonnieHat_CamoGreen", 1,
        "Hat_PeakedCapArmy", 0.5,
        "Hat_BeretArmy", 0.5,
        "Jacket_CoatArmy", 0.5,
        "Shoes_ArmyBoots", 1,
        "Shirt_CamoGreen", 1,
        "Radio.WalkieTalkie5", 2,
        "HuntingKnife", 3,
        "FirstAidKit", 3,
		"EmptyPetrolCan", 4,
		"PetrolCan", 2,
	
    }
}

VehicleDistributions.V100 = {

	GloveBox = VehicleDistributions.V100GloveBox;
	TruckBed = VehicleDistributions.V100MilitaryStuff;
	V100Toolbox = VehicleDistributions.V100MilitaryStuff;
}

distributionTable["67commando"] = { Normal = VehicleDistributions.V100; }
distributionTable["67commandoPolice"] = { Normal = VehicleDistributions.V100; }
distributionTable["67commandoT50"] = { Normal = VehicleDistributions.V100; }
distributionTable["67commandoBurnt"] = { Normal = VehicleDistributions.V100; }

