if VehicleZoneDistribution then

-- Normal spawns --

VehicleZoneDistribution.trailerpark.vehicles["Base.67commando"] = {index = -1, spawnChance = 1};
VehicleZoneDistribution.trailerpark.vehicles["Base.67commandoT50"] = {index = -1, spawnChance = 2};
VehicleZoneDistribution.trailerpark.vehicles["Base.67commandoBurnt"] = {index = -1, spawnChance = 3};

VehicleZoneDistribution.junkyard.vehicles["Base.67commando"] = {index = -1, spawnChance = 1};
VehicleZoneDistribution.junkyard.vehicles["Base.67commandoT50"] = {index = -1, spawnChance = 1};
VehicleZoneDistribution.junkyard.vehicles["Base.67commandoBurnt"] = {index = -1, spawnChance = 4};

--VehicleZoneDistribution.trafficjams.vehicles["Base.67commando"] = {index = -1, spawnChance = 2};
--VehicleZoneDistribution.trafficjams.vehicles["Base.67commandoT50"] = {index = -1, spawnChance = 1};
VehicleZoneDistribution.trafficjams.vehicles["Base.67commandoBurnt"] = {index = -1, spawnChance = 1};

-- Police spawn --

VehicleZoneDistribution.police.vehicles["Base.67commando"] = {index = -1, spawnChance = 1};
VehicleZoneDistribution.police.vehicles["Base.67commandoT50"] = {index = -1, spawnChance = 1};
VehicleZoneDistribution.police.vehicles["Base.67commandoPolice"] = {index = -1, spawnChance = 15};

-- Ranger spawn --
VehicleZoneDistribution.ranger.vehicles["Base.67commando"] = {index = -1, spawnChance = 12};
VehicleZoneDistribution.ranger.vehicles["Base.67commandoT50"] = {index = -1, spawnChance = 1};
-- Military spawn --

VehicleZoneDistribution.farm = VehicleZoneDistribution.farm or {}
VehicleZoneDistribution.farm.vehicles = VehicleZoneDistribution.farm.vehicles or {}
VehicleZoneDistribution.farm.vehicles["Base.67commando"] = {index = -1, spawnChance = 20};
VehicleZoneDistribution.farm.vehicles["Base.67commandoT50"] = {index = -1, spawnChance = 20};

VehicleZoneDistribution.military = VehicleZoneDistribution.military or {}
VehicleZoneDistribution.military.vehicles = VehicleZoneDistribution.military.vehicles or {}
VehicleZoneDistribution.military.vehicles["Base.67commando"] = {index = -1, spawnChance = 20};
VehicleZoneDistribution.military.vehicles["Base.67commandoT50"] = {index = -1, spawnChance = 20};

end