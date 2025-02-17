require "BGunTweaker";

-- Code allows for model swapping based on a bunch of parameters, all made possible by bikinihorst, thank you as always for the fantastic code

Events.OnGameStart.Add(function()

    ---------------------------------
    --- MAGAZINE ONLY MODEL SWAPS ---
    ---------------------------------

    local magChange = {
        { fullType = "Base.Pistol", modelWithMag = "Handgun03", modelWithoutMag = "Handgun03NoMag" },
        { fullType = "Base.Pistol2", modelWithMag = "Handgun02", modelWithoutMag = "Handgun02NoMag" },
        { fullType = "Base.Pistol3", modelWithMag = "Handgun", modelWithoutMag = "HandgunNoMag" },
        { fullType = "Base.VarmintRifle", modelWithMag = "VarmintRifleExtMag", modelWithoutMag = "VarmintRifle" },
        { fullType = "Base.VarmintRifle_Melee", modelWithMag = "VarmintRifleExtMag", modelWithoutMag = "VarmintRifle" },
        { fullType = "Base.HuntingRifle", modelWithMag = "HuntingRifle", modelWithoutMag = "HuntingRifleNoMag" },
        { fullType = "Base.HuntingRifle_Melee", modelWithMag = "HuntingRifle", modelWithoutMag = "HuntingRifleNoMag" },
        { fullType = "Base.AssaultRifle", modelWithMag = "AssaultRifle", modelWithoutMag = "AssaultRifleNoMag" },
        { fullType = "Base.AssaultRifle_Melee", modelWithMag = "AssaultRifle", modelWithoutMag = "AssaultRifleNoMag" },
        { fullType = "Base.AssaultRifle2", modelWithMag = "AssaultRifle02", modelWithoutMag = "AssaultRifle02NoMag" },
        { fullType = "Base.AssaultRifle2_Melee", modelWithMag = "AssaultRifle02", modelWithoutMag = "AssaultRifle02NoMag" },
    }
    
    for _, change in ipairs(magChange) do
        BWTweaks:changeModelByMagPresent(change.fullType, true, change.modelWithMag)
        BWTweaks:changeModelByMagPresent(change.fullType, false, change.modelWithoutMag)
    end

    -----------------------------------------
    --- ATTACHMENT + MAGAZINE MODEL SWAPS ---
    -----------------------------------------

    local platingWeapon = {
        --Beretta M9 DZ
        { fullType = "Base.Pistol", attachment = "Base.DZPlating", modelWithMag = "Handgun03DZ", modelWithoutMag = "Handgun03DZNoMag" },
        --Beretta M9 Pink
        { fullType = "Base.Pistol", attachment = "Base.PinkPlating", modelWithMag = "Handgun03Pink", modelWithoutMag = "Handgun03PinkNoMag" },
        --Beretta M9 Pearl
        { fullType = "Base.Pistol", attachment = "Base.PearlPlating", modelWithMag = "Handgun03Pearl", modelWithoutMag = "Handgun03PearlNoMag" },
        --Colt 1911 Patriot
        { fullType = "Base.Pistol2", attachment = "Base.Colt1911PatriotPlating", modelWithMag = "Handgun02Patriot", modelWithoutMag = "Handgun02PatriotNoMag" },
        --Colt 1911 Patriot
        { fullType = "Base.Pistol2", attachment = "Base.AztecPlating", modelWithMag = "Handgun02Aztec", modelWithoutMag = "Handgun02AztecNoMag" },
        --Desert Eagle Gold
         { fullType = "Base.Pistol3", attachment = "Base.DesertEagleGoldPlating", modelWithMag = "HandgunGold", modelWithoutMag = "HandgunGoldNoMag" },
        --Desert Eagle Salvaged Black
        { fullType = "Base.Pistol3", attachment = "Base.SalvagedBlackPlating", modelWithMag = "HandgunSalvagedBlack", modelWithoutMag = "HandgunSalvagedBlackNoMag" },
        --Desert Eagle Mystery Machine
        { fullType = "Base.Pistol3", attachment = "Base.MysteryMachinePlating", modelWithMag = "HandgunMysteryMachine", modelWithoutMag = "HandgunMysteryMachineNoMag" },
         --Remington Model 700  Fiberglassstock
        { fullType = "Base.VarmintRifle", attachment = "Base.FiberglassStock", modelWithMag = "VarmintRifleExtMagFGS", modelWithoutMag = "VarmintRifleFGSNoMag" },
        { fullType = "Base.VarmintRifle_Melee", attachment = "Base.FiberglassStock", modelWithMag = "VarmintRifleExtMagFGS", modelWithoutMag = "VarmintRifleFGSNoMag" },
        --Remington Model 788 DZ
        { fullType = "Base.HuntingRifle", attachment = "Base.DZPlating", modelWithMag = "HuntingRifleDZ", modelWithoutMag = "HuntingRifleDZNoMag" },
        { fullType = "Base.HuntingRifle_Melee", attachment = "Base.DZPlating", modelWithMag = "HuntingRifleDZ", modelWithoutMag = "HuntingRifleDZNoMag" }, 
        --Remington Model 788 Dark Cherry
        { fullType = "Base.HuntingRifle", attachment = "Base.RemingtonRiflesDarkCherryStock", modelWithMag = "HuntingRifleDarkCherry", modelWithoutMag = "HuntingRifleDarkCherryNoMag" },
        { fullType = "Base.HuntingRifle_Melee", attachment = "Base.RemingtonRiflesDarkCherryStock", modelWithMag = "HuntingRifleDarkCherry", modelWithoutMag = "HuntingRifleDarkCherryNoMag" },        
        --Remington Model 788 Fiberglassstock
        { fullType = "Base.HuntingRifle", attachment = "Base.FiberglassStock", modelWithMag = "HuntingRifleFGS", modelWithoutMag = "HuntingRifleFGSNoMag" },
        { fullType = "Base.HuntingRifle_Melee", attachment = "Base.FiberglassStock", modelWithMag = "HuntingRifleFGS", modelWithoutMag = "HuntingRifleFGSNoMag" },
        --Springfield Armory M14 FiberGlass
        { fullType = "Base.AssaultRifle2", attachment = "Base.FiberglassStock", modelWithMag = "AssaultRifle02FGS", modelWithoutMag = "AssaultRifle02FGSNoMag" },
        { fullType = "Base.AssaultRifle2_Melee", attachment = "Base.FiberglassStock", modelWithMag = "AssaultRifle02FGS", modelWithoutMag = "AssaultRifle02FGSNoMag" },
    }

    for _, change in ipairs(platingWeapon) do
        BWTweaks:changeModelByAttachmentAndMagPresent(change.fullType, change.attachment, true, change.modelWithMag)
        BWTweaks:changeModelByAttachmentAndMagPresent(change.fullType, change.attachment, false, change.modelWithoutMag)
    end



    -----------------------------------
    --- ATTACHMENT ONLY MODEL SWAPS ---
    -----------------------------------
    ---Beretta M9 DZ Melee
    BWTweaks:changeModelByAttachment("Base.Pistol_Melee", "Base.DZPlating", "Handgun03MeleeDZ");

    ---Beretta M9 Pink Melee
    BWTweaks:changeModelByAttachment("Base.Pistol_Melee", "Base.PinkPlating", "Handgun03MeleePink");

    ---Beretta M9 pearl Melee
    BWTweaks:changeModelByAttachment("Base.Pistol_Melee", "Base.PearlPlating", "Handgun03MeleePearl");

    --Colt 1911 Patriot Melee
    BWTweaks:changeModelByAttachment("Base.Pistol2_Melee", "Base.Colt1911PatriotPlating", "Handgun02MeleePatriot");

    --Colt 1911 Aztec Melee
    BWTweaks:changeModelByAttachment("Base.Pistol2_Melee", "Base.AztecPlating", "Handgun02MeleeAztec");

    --Desert Eagle Gold Melee
    BWTweaks:changeModelByAttachment("Base.Pistol3_Melee", "Base.DesertEagleGoldPlating", "HandgunMeleeGold");

    --Desert Eagle Salvaged Black Melee
    BWTweaks:changeModelByAttachment("Base.Pistol3_Melee", "Base.SalvagedBlackPlating", "HandgunMeleeSalvagedBlack");

    --Desert Eagle Mystery Machine Melee
    BWTweaks:changeModelByAttachment("Base.Pistol3_Melee", "Base.MysteryMachinePlating", "HandgunMeleeMysteryMachine");

    --Smith and Wesson Pink
    BWTweaks:changeModelByAttachment("Base.Revolver", "Base.PinkPlating", "RevolverPink");
    BWTweaks:changeModelByAttachment("Base.Revolver_Melee", "Base.PinkPlating", "RevolverMeleePink");

    --Magnum Anaconda Gold
    BWTweaks:changeModelByAttachment("Base.Revolver_Long", "Base.GoldGunPlating", "Revolver_LongGold");
    BWTweaks:changeModelByAttachment("Base.Revolver_Long_Melee", "Base.GoldGunPlating", "Revolver_LongMeleeGold");

    --Magnum Anaconda Nerf
    BWTweaks:changeModelByAttachment("Base.Revolver_Long", "Base.NerfPlating", "Revolver_LongNerf");
    BWTweaks:changeModelByAttachment("Base.Revolver_Long_Melee", "Base.NerfPlating", "Revolver_LongMeleeNerf");

    --Remington Model 700 DZ
    BWTweaks:changeModelByAttachment("Base.VarmintRifle", "Base.DZPlating", "VarmintRifleDZ");
    BWTweaks:changeModelByAttachment("Base.VarmintRifle_Melee", "Base.DZPlating", "VarmintRifleDZ");

    --Remington Model 700 Dark Cherry
    BWTweaks:changeModelByAttachment("Base.VarmintRifle", "Base.RemingtonRiflesDarkCherryStock", "VarmintRifleDarkCherry");
    BWTweaks:changeModelByAttachment("Base.VarmintRifle_Melee", "Base.RemingtonRiflesDarkCherryStock", "VarmintRifleDarkCherry");

    --Remington Model 700 Fiberglass
    BWTweaks:changeModelByAttachment("Base.VarmintRifle", "Base.FiberglassStock", "VarmintRifleFGS");
    BWTweaks:changeModelByAttachment("Base.VarmintRifle_Melee", "Base.FiberglassStock", "VarmintRifleFGS");

    --Remington Model 870 Shotgun Fiberglass
    BWTweaks:changeModelByAttachment("Base.Shotgun", "Base.FiberglassStock", "ShotgunFGS");
    BWTweaks:changeModelByAttachment("Base.Shotgun_Melee", "Base.FiberglassStock", "ShotgunFGS");

    --Remington Model 870 Shotgun Choke
    BWTweaks:changeModelByAttachment("Base.Shotgun", "Base.ChokeTubeFull", "ShotgunChoke");
    BWTweaks:changeModelByAttachment("Base.Shotgun_Melee", "Base.ChokeTubeFull", "ShotgunChoke");
    BWTweaks:changeModelByAttachment("Base.Shotgun", "Base.ChokeTubeImproved", "ShotgunChoke");
    BWTweaks:changeModelByAttachment("Base.Shotgun_Melee", "Base.ChokeTubeImproved", "ShotgunChoke");

    --Remington Model 870 Shotgun Fiberglass and Choke
    BWTweaks:changeModelByAttachment("Base.Shotgun", {"Base.FiberglassStock","Base.ChokeTubeFull",}, "ShotgunChokeFGS");
    BWTweaks:changeModelByAttachment("Base.Shotgun_Melee", {"Base.FiberglassStock","Base.ChokeTubeFull",}, "ShotgunChokeFGS");
    BWTweaks:changeModelByAttachment("Base.Shotgun", {"Base.FiberglassStock","Base.ChokeTubeImproved",}, "ShotgunChokeFGS");
    BWTweaks:changeModelByAttachment("Base.Shotgun_Melee", {"Base.FiberglassStock","Base.ChokeTubeImproved",}, "ShotgunChokeFGS");

    --Remington Model 870 Sawnoff Choke
    BWTweaks:changeModelByAttachment("Base.ShotgunSawnoff", "Base.ChokeTubeFull", "ShotgunSawnoffChoke");
    BWTweaks:changeModelByAttachment("Base.ShotgunSawnoff_Melee", "Base.ChokeTubeFull", "ShotgunSawnoffChoke");
    BWTweaks:changeModelByAttachment("Base.ShotgunSawnoff", "Base.ChokeTubeImproved", "ShotgunSawnoffChoke");
    BWTweaks:changeModelByAttachment("Base.ShotgunSawnoff_Melee", "Base.ChokeTubeImproved", "ShotgunSawnoffChoke");

    --Remington Model 870 ALL TBD
    BWTweaks:changeModelByAttachment("Base.Shotgun", "Base.TBDPlating", "ShotgunTBD");
    BWTweaks:changeModelByAttachment("Base.Shotgun_Melee", "Base.TBDPlating", "ShotgunTBD");
    BWTweaks:changeModelByAttachment("Base.ShotgunSawnoff", "Base.TBDPlating", "ShotgunSawnOffTBD");
    BWTweaks:changeModelByAttachment("Base.ShotgunSawnoff_Melee", "Base.TBDPlating", "ShotgunSawnOffTBD");

    BWTweaks:changeModelByAttachment("Base.Shotgun", {"Base.TBDPlating", "Base.ChokeTubeFull"}, "ShotgunChokeTBD");
    BWTweaks:changeModelByAttachment("Base.Shotgun_Melee", {"Base.TBDPlating", "Base.ChokeTubeFull"}, "ShotgunChokeTBD");
    BWTweaks:changeModelByAttachment("Base.Shotgun", {"Base.TBDPlating", "Base.ChokeTubeImproved"}, "ShotgunChokeTBD");
    BWTweaks:changeModelByAttachment("Base.Shotgun_Melee", {"Base.TBDPlating", "Base.ChokeTubeImproved"}, "ShotgunChokeTBD");

    BWTweaks:changeModelByAttachment("Base.ShotgunSawnoff", {"Base.TBDPlating", "Base.ChokeTubeFull"}, "ShotgunSawnoffChokeTBD");
    BWTweaks:changeModelByAttachment("Base.ShotgunSawnoff_Melee", {"Base.TBDPlating", "Base.ChokeTubeFull"}, "ShotgunSawnoffChokeTBD");
    BWTweaks:changeModelByAttachment("Base.ShotgunSawnoff", {"Base.TBDPlating", "Base.ChokeTubeImproved"}, "ShotgunSawnoffChokeTBD");
    BWTweaks:changeModelByAttachment("Base.ShotgunSawnoff_Melee", {"Base.TBDPlating", "Base.ChokeTubeImproved"}, "ShotgunSawnoffChokeTBD");

    --Remington SPR 220 Shotgun
    BWTweaks:changeModelByAttachment("Base.DoubleBarrelShotgun", "Base.BespokeEngravedPlating", "DoubleBarrelShotgunBespoke");
    BWTweaks:changeModelByAttachment("Base.DoubleBarrelShotgun_Melee", "Base.BespokeEngravedPlating", "DoubleBarrelShotgunBespoke");
    BWTweaks:changeModelByAttachment("Base.DoubleBarrelShotgun_OPEN,", "Base.BespokeEngravedPlating", "DoubleBarrelShotgunBespoke_OPEN");

    --Remington SPR 220 Sawnoff Shotgun
    BWTweaks:changeModelByAttachment("Base.DoubleBarrelShotgunSawnoff", "Base.BespokeEngravedPlating", "DoubleBarrelShotgunSawnoffBespoke");
    BWTweaks:changeModelByAttachment("Base.DoubleBarrelShotgunSawnoff_Melee", "Base.BespokeEngravedPlating", "DoubleBarrelShotgunSawnoffBespoke");
    BWTweaks:changeModelByAttachment("Base.DoubleBarrelShotgunSawnoff_OPEN,", "Base.BespokeEngravedPlating", "DoubleBarrelShotgunSawnoffBespoke_OPEN");
 
    ----------------------------------------------------------------
    --- FIBERGLASS + PLATING ATTACHMENTS  + MAGAZINE MODEL SWAPS ---
    ----------------------------------------------------------------
    local dualAttach = {
       --Remington Model 788 DZ WITH fiberglass
        { fullType = "Base.HuntingRifle", attachments = {"Base.DZPlating", "Base.FiberglassStock"}, modelWithMag = "HuntingRifleDZ", modelWithoutMag = "HuntingRifleDZNoMag" },
        { fullType = "Base.HuntingRifle_Melee", attachments = {"Base.DZPlating", "Base.FiberglassStock"}, modelWithMag = "HuntingRifleDZ", modelWithoutMag = "HuntingRifleDZNoMag" }, 
        --Remington Model 788 Dark Cherry WITH fiberglass
        { fullType = "Base.HuntingRifle", attachments = {"Base.RemingtonRiflesDarkCherryStock", "Base.FiberglassStock"}, modelWithMag = "HuntingRifleDarkCherry", modelWithoutMag = "HuntingRifleDarkCherryNoMag" },
        { fullType = "Base.HuntingRifle_Melee", attachments = {"Base.RemingtonRiflesDarkCherryStock", "Base.FiberglassStock"}, modelWithMag = "HuntingRifleDarkCherry", modelWithoutMag = "HuntingRifleDarkCherryNoMag" },        
    }

    for _, change in ipairs(dualAttach) do
        BWTweaks:changeModelByAttachmentAndMagPresent(change.fullType, change.attachments, true, change.modelWithMag)
        BWTweaks:changeModelByAttachmentAndMagPresent(change.fullType, change.attachments, false, change.modelWithoutMag)
    end

    -----------------------------------------------
    --- PLATING + MORE ATTACHMENTS WITHOUT MAGS ---
    -----------------------------------------------

    local multiAttach = {
        --Remington Model 700 DZ WITH fiberglass
        { fullType = "Base.VarmintRifle", attachments = {"Base.FiberglassStock", "Base.DZPlating"}, model = "VarmintRifleDZ" },
        { fullType = "Base.VarmintRifle_Melee", attachments = {"Base.FiberglassStock", "Base.DZPlating"}, model = "VarmintRifleDZ" },
        --Remington Model 700 Dark Cherry WITH fiberglass
        { fullType = "Base.VarmintRifle", attachments = {"Base.FiberglassStock", "Base.RemingtonRiflesDarkCherryStock"}, model = "VarmintRifleDarkCherry" },
        { fullType = "Base.VarmintRifle_Melee", attachments = {"Base.FiberglassStock", "Base.RemingtonRiflesDarkCherryStock"}, model = "VarmintRifleDarkCherry" },
       --Remington Model 870 Shotgun TBD WITH Fiberglass
        { fullType = "Base.Shotgun", attachments = {"Base.FiberglassStock", "Base.TBDPlating"}, model = "ShotgunTBD" },
        { fullType = "Base.Shotgun_Melee", attachments = {"Base.FiberglassStock", "Base.TBDPlating"}, model = "ShotgunTBD" },
        --Remington Model 870 Shotgun TBD WITH Fiberglass and Choke
        { fullType = "Base.Shotgun", attachments = {"Base.FiberglassStock", "Base.ChokeTubeFull", "Base.TBDPlating"}, model = "ShotgunChokeTBD" },
        { fullType = "Base.Shotgun_Melee", attachments = {"Base.FiberglassStock", "Base.ChokeTubeFull", "Base.TBDPlating"}, model = "ShotgunChokeTBD" },
        { fullType = "Base.Shotgun", attachments = {"Base.FiberglassStock", "Base.ChokeTubeImproved", "Base.TBDPlating"}, model = "ShotgunChokeTBD" },
        { fullType = "Base.Shotgun_Melee", attachments = {"Base.FiberglassStock", "Base.ChokeTubeImproved", "Base.TBDPlating"}, model = "ShotgunChokeTBD" },
    }

    for _, change in ipairs(multiAttach) do
        BWTweaks:changeModelByAttachment(change.fullType, change.attachments, change.model)
    end

    -----------------------------
    --- TACTICAL LASER TOGGLE ---
    -----------------------------

    --Colt M16
    BWTweaks:addToggleOption("Base.AssaultRifle", "Base.LaserNoLight", "Base.LaserGreen", "IGUI_HFA_LaserGreen");
    BWTweaks:addToggleOption("Base.AssaultRifle", "Base.LaserNoLight", "Base.LaserRed", "IGUI_HFA_LaserRed");
    BWTweaks:addToggleOption("Base.AssaultRifle_Melee", "Base.LaserNoLight", "Base.LaserGreen", "IGUI_HFA_LaserGreen");
    BWTweaks:addToggleOption("Base.AssaultRifle_Melee", "Base.LaserNoLight", "Base.LaserRed", "IGUI_HFA_LaserRed");

end);

