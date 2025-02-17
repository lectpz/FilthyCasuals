require "BGunTweaker";
-- BGunTweaker written by Bikinihorst the brains behind so many operations! It is with permission this code is found here. Thank you.
if getActivatedMods():contains("ChiikuArmsSD") then
    Events.OnGameBoot.Add(function()

        BWTweaks:addToMountOn("Base.Compensator", {
            "Base.SCARH",
            "ChiikuA.UMP"
        });

        BWTweaks:addToMountOn("Base.MuzzleBrake", {
            "Base.SCARH",
            "ChiikuA.UMP"
        });

        BWTweaks:addToMountOn("Base.SuppressorRifle", {
            "Base.SCARH",
            "ChiikuA.FNFAL",
            "ChiikuA.UMP"
        });

        BWTweaks:addToMountOn("Base.SuppressorPistol", {
            "ChiikuA.UMP"
        });

        BWTweaks:addToMountOn("Base.HoloSight", {
            "Base.SCARH",
            "Base.SCARH2", 
            "Base.SCARH3",
            "Base.SCARH4",
            "Base.SCARH5", 
            "Base.SCARH6",
            "Base.SCARH7",
            "Base.SCARH8", 
            "ChiikuA.MAS36",
            "ChiikuA.FNFAL",
            "ChiikuA.UMP",
            "ChiikuA.AKMCAMO"
        });

        BWTweaks:addToMountOn("Base.ReflexSight", {
            "Base.SCARH",
            "Base.SCARH2", 
            "Base.SCARH3",
            "Base.SCARH4",
            "Base.SCARH5", 
            "Base.SCARH6",
            "Base.SCARH7",
            "Base.SCARH8", 
            "ChiikuA.MAS36",
            "ChiikuA.FNFAL",
            "ChiikuA.UMP",
            "ChiikuA.AKMCAMO"
        });

        BWTweaks:addToMountOn("Base.ProOpticScope", {
            "Base.SCARH",
            "Base.SCARH2", 
            "Base.SCARH3",
            "Base.SCARH4",
            "Base.SCARH5", 
            "Base.SCARH6",
            "Base.SCARH7",
            "Base.SCARH8", 
            "ChiikuA.MAS36",
            "ChiikuA.FNFAL",
            "ChiikuA.AKMCAMO"
        });

        BWTweaks:addToMountOn("Base.VertGrip", {
            "ChiikuA.MAS36",
            "ChiikuA.FNFAL",
            "ChiikuA.AKMCAMO"
        });

        BWTweaks:addToMountOn("Base.AngleGrip", {

            "ChiikuA.FNFAL",
            "ChiikuA.AKMCAMO"
        });

        BWTweaks:addToMountOn("Base.LaserRed", {
            "Base.SCARH",
            "Base.SCARH2", 
            "Base.SCARH3",
            "Base.SCARH4",
            "Base.SCARH5", 
            "Base.SCARH6",
            "Base.SCARH7",
            "Base.SCARH8", 
            "ChiikuA.FNFAL",
            "ChiikuA.KrissVector", 
            "ChiikuA.AKMCAMO"
        });

        BWTweaks:addToMountOn("Base.LaserGreen", {
            "Base.SCARH",
            "Base.SCARH2", 
            "Base.SCARH3",
            "Base.SCARH4",
            "Base.SCARH5", 
            "Base.SCARH6",
            "Base.SCARH7",
            "Base.SCARH8", 
            "ChiikuA.FNFAL",
            "ChiikuA.KrissVector", 
            "ChiikuA.AKMCAMO"
        });

        BWTweaks:addToMountOn("Base.LaserNoLight", {
            "Base.SCARH",
            "Base.SCARH2", 
            "Base.SCARH3",
            "Base.SCARH4",
            "Base.SCARH5", 
            "Base.SCARH6",
            "Base.SCARH7",
            "Base.SCARH8", 
            "ChiikuA.FNFAL",
            "ChiikuA.KrissVector", 
            "ChiikuA.AKMCAMO"
        });
        
        BWTweaks:addToMountOn("Base.WeaponLight", {
            "Base.SCARH",
            "Base.SCARH2", 
            "Base.SCARH3",
            "Base.SCARH4",
            "Base.SCARH5", 
            "Base.SCARH6",
            "Base.SCARH7",
            "Base.SCARH8", 
            "ChiikuA.FNFAL",
            "ChiikuA.UMP",
            "ChiikuA.KrissVector", 
            "ChiikuA.AKMCAMO"
        });

        BWTweaks:addToMountOn("Base.WeaponLightMedium", {
            "Base.SCARH",
            "Base.SCARH2", 
            "Base.SCARH3",
            "Base.SCARH4",
            "Base.SCARH5", 
            "Base.SCARH6",
            "Base.SCARH7",
            "Base.SCARH8", 
            "ChiikuA.FNFAL",
            "ChiikuA.UMP",
            "ChiikuA.KrissVector", 
            "ChiikuA.AKMCAMO"
        });

    end);
else
    return
end