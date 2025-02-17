require "BGunTweaker";

-- Code allows for model swapping based on a bunch of parameters, all made possible by bikinihorst, thank you as always for the fantastic code

Events.OnGameStart.Add(function()

    ---------------------------------
    --- MAGAZINE MODEL ONLY SWAPS ---
    ---------------------------------

    local magChange = {
        { fullType = "Base.Glock", modelWithMag = "Glock", modelWithoutMag = "GlockNoMag" },
        { fullType = "Base.FiveSeven", modelWithMag = "FiveSeven", modelWithoutMag = "FiveSevenNoMag" },
        { fullType = "Base.Luger", modelWithMag = "Luger", modelWithoutMag = "LugerNoMag" },
        { fullType = "Base.WaltherPPK", modelWithMag = "WaltherPPK", modelWithoutMag = "WaltherPPKNoMag" },
        { fullType = "Base.Makarov", modelWithMag = "Makarov", modelWithoutMag = "MakarovNoMag" },
        { fullType = "Base.PLR16", modelWithMag = "PLR16", modelWithoutMag = "PLR16NoMag" },
        { fullType = "Base.OA93", modelWithMag = "OA93", modelWithoutMag = "OA93NoMag" },
        { fullType = "Base.TheNailGun", modelWithMag = "TheNailGun", modelWithoutMag = "TheNailGunNoMag" },
        { fullType = "Base.TheNailGun_Melee", modelWithMag = "TheNailGunMelee", modelWithoutMag = "TheNailGunNoMagMelee" },
        { fullType = "Base.AK74U", modelWithMag = "AK74U", modelWithoutMag = "AK74UNoMag" },
        { fullType = "Base.AK74U_Melee", modelWithMag = "AK74U", modelWithoutMag = "AK74UNoMag" },
        { fullType = "Base.AK74U_Folded", modelWithMag = "AK74U_Folded", modelWithoutMag = "AK74UNoMag_Folded" },
        { fullType = "Base.AK74U_Folded_Melee", modelWithMag = "AK74U_Folded", modelWithoutMag = "AK74UNoMag_Folded" },
        { fullType = "Base.FranchiLF57", modelWithMag = "FranchiLF57", modelWithoutMag = "FranchiLF57NoMag" },
        { fullType = "Base.FranchiLF57_Melee", modelWithMag = "FranchiLF57", modelWithoutMag = "FranchiLF57NoMag" },
        { fullType = "Base.FranchiLF57_Folded", modelWithMag = "FranchiLF57_Folded", modelWithoutMag = "FranchiLF57NoMag_Folded" },
        { fullType = "Base.FranchiLF57_Folded_Melee", modelWithMag = "FranchiLF57_Folded", modelWithoutMag = "FranchiLF57NoMag_Folded" },
        { fullType = "Base.MiniUzi", modelWithMag = "MiniUzi", modelWithoutMag = "MiniUziNoMag" },
        { fullType = "Base.MiniUzi_Melee", modelWithMag = "MiniUzi", modelWithoutMag = "MiniUziNoMag" },
        { fullType = "Base.MiniUzi_Folded", modelWithMag = "MiniUzi_Folded", modelWithoutMag = "MiniUziNoMag_Folded" },
        { fullType = "Base.MiniUzi_Folded_Melee", modelWithMag = "MiniUzi_Folded", modelWithoutMag = "MiniUziNoMag_Folded" },
        { fullType = "Base.P90", modelWithMag = "P90", modelWithoutMag = "P90NoMag" },
        { fullType = "Base.P90_Melee", modelWithMag = "P90", modelWithoutMag = "P90NoMag" },
        { fullType = "Base.MP28", modelWithMag = "MP28", modelWithoutMag = "MP28NoMag" },
        { fullType = "Base.MP28_Melee", modelWithMag = "MP28", modelWithoutMag = "MP28NoMag" },
        { fullType = "Base.AK103", modelWithMag = "AK103", modelWithoutMag = "AK103NoMag" },
        { fullType = "Base.AK103_Melee", modelWithMag = "AK103", modelWithoutMag = "AK103NoMag" },
        { fullType = "Base.AK74", modelWithMag = "AK74", modelWithoutMag = "AK74NoMag" },
        { fullType = "Base.AK74_Melee", modelWithMag = "AK74", modelWithoutMag = "AK74NoMag" },
        { fullType = "Base.GrozaOTs14", modelWithMag = "GrozaOTs14", modelWithoutMag = "GrozaOTs14NoMag" },
        { fullType = "Base.GrozaOTs14_Melee", modelWithMag = "GrozaOTs14", modelWithoutMag = "GrozaOTs14NoMag" },
        { fullType = "Base.M1918BAR", modelWithMag = "M1918BAR", modelWithoutMag = "M1918BARNoMag" },
        { fullType = "Base.M1918BAR_Bipod", modelWithMag = "M1918BARBipod", modelWithoutMag = "M1918BARBipodNoMag" },
        { fullType = "Base.M1918BAR_Melee", modelWithMag = "M1918BAR", modelWithoutMag = "M1918BARNoMag" },
        { fullType = "Base.SIG550", modelWithMag = "SIG550", modelWithoutMag = "SIG550NoMag" },
        { fullType = "Base.SIG550_Melee", modelWithMag = "SIG550", modelWithoutMag = "SIG550NoMag" },
        { fullType = "Base.StG44", modelWithMag = "StG44", modelWithoutMag = "StG44NoMag" },
        { fullType = "Base.StG44_Melee", modelWithMag = "StG44", modelWithoutMag = "StG44NoMag" },
        { fullType = "Base.SVDDragunov", modelWithMag = "SVDDragunov", modelWithoutMag = "SVDDragunovNoMag" },
        { fullType = "Base.SVDDragunov_Melee", modelWithMag = "SVDDragunov", modelWithoutMag = "SVDDragunovNoMag" },
        { fullType = "Base.BarrettM82A1", modelWithMag = "BarrettM82A1", modelWithoutMag = "BarrettM82A1NoMag" },
        { fullType = "Base.BarrettM82A1_Bipod", modelWithMag = "BarrettM82A1Bipod", modelWithoutMag = "BarrettM82A1BipodNoMag" },
        { fullType = "Base.BarrettM82A1_Melee", modelWithMag = "BarrettM82A1", modelWithoutMag = "BarrettM82A1NoMag" },
        { fullType = "Base.L2A1", modelWithMag = "L2A1", modelWithoutMag = "L2A1NoMag" },
        { fullType = "Base.L2A1_Bipod", modelWithMag = "L2A1Bipod", modelWithoutMag = "L2A1BipodNoMag" },
        { fullType = "Base.L2A1_Melee", modelWithMag = "L2A1", modelWithoutMag = "L2A1NoMag" },
        { fullType = "Base.EM2", modelWithMag = "EM2", modelWithoutMag = "EM2NoMag" },
        { fullType = "Base.EM2_Melee", modelWithMag = "EM2", modelWithoutMag = "EM2NoMag" },
        { fullType = "Base.L85A1", modelWithMag = "L85A1", modelWithoutMag = "L85A1NoMag" },
        { fullType = "Base.L85A1_Melee", modelWithMag = "L85A1", modelWithoutMag = "L85A1NoMag" },
        { fullType = "Base.ASVal", modelWithMag = "ASVal", modelWithoutMag = "ASValNoMag" },
        { fullType = "Base.ASVal_Melee", modelWithMag = "ASVal", modelWithoutMag = "ASValNoMag" },
        { fullType = "Base.ASVal_Folded", modelWithMag = "ASVal_Folded", modelWithoutMag = "ASValNoMag_Folded" },
        { fullType = "Base.ASVal_Folded_Melee", modelWithMag = "ASVal_Folded", modelWithoutMag = "ASValNoMag_Folded" },
        { fullType = "Base.Galil", modelWithMag = "Galil", modelWithoutMag = "GalilNoMag" },
        { fullType = "Base.Galil_Bipod", modelWithMag = "GalilBipod", modelWithoutMag = "GalilBipodNoMag" },
        { fullType = "Base.Galil_Melee", modelWithMag = "Galil", modelWithoutMag = "GalilNoMag" },
        { fullType = "Base.VSSVintorez", modelWithMag = "VSSVintorez", modelWithoutMag = "VSSVintorezNoMag" },
        { fullType = "Base.VSSVintorez_Melee", modelWithMag = "VSSVintorez", modelWithoutMag = "VSSVintorezNoMag" },
        { fullType = "Base.FG42", modelWithMag = "FG42", modelWithoutMag = "FG42NoMag" },
        { fullType = "Base.FG42_Bipod", modelWithMag = "FG42Bipod", modelWithoutMag = "FG42BipodNoMag" },
        { fullType = "Base.FG42_Melee", modelWithMag = "FG42", modelWithoutMag = "FG42NoMag" },
        { fullType = "Base.MG42", modelWithMag = "MG42", modelWithoutMag = "MG42NoMag" },
        { fullType = "Base.MG42_Bipod", modelWithMag = "MG42Bipod", modelWithoutMag = "MG42BipodNoMag" },
        { fullType = "Base.MG42_Melee", modelWithMag = "MG42", modelWithoutMag = "MG42NoMag" },
        { fullType = "Base.M4A1", modelWithMag = "M4A1", modelWithoutMag = "M4A1NoMag" },
        { fullType = "Base.M4A1_Melee", modelWithMag = "M4A1", modelWithoutMag = "M4A1NoMag" },
    }
    
    for _, change in ipairs(magChange) do
        BWTweaks:changeModelByMagPresent(change.fullType, true, change.modelWithMag)
        BWTweaks:changeModelByMagPresent(change.fullType, false, change.modelWithoutMag)
    end

    -------------------------------
    --- EXTENDED MAGAZINE SWAPS ---
    -------------------------------

    local extendedMagChange = {
        { fullType = "Base.M1918BAR", attachment = "Base.Mag3006ExtLg", model = "M1918BARNoMag" },
        { fullType = "Base.M1918BAR_Bipod", attachment = "Base.Mag3006ExtLg", model = "M1918BARBipodNoMag" },
        { fullType = "Base.M1918BAR_Melee", attachment = "Base.Mag3006ExtLg", model = "M1918BARNoMag" },
        { fullType = "Base.SVDDragunov", attachment = "Base.MagSVDExtSm", model = "SVDDragunovNoMag" },
        { fullType = "Base.SVDDragunov_Melee", attachment = "Base.MagSVDExtSm", model = "SVDDragunovNoMag" },
        { fullType = "Base.VSSVintorez", attachment = "Base.Mag9x39ExtSm", model = "VSSVintorezNoMag" },
        { fullType = "Base.VSSVintorez_Melee", attachment = "Base.Mag9x39ExtSm", model = "VSSVintorezNoMag" },
        { fullType = "Base.VSSVintorez", attachment = "Base.Mag9x39ExtLg", model = "VSSVintorezNoMag" },
        { fullType = "Base.VSSVintorez_Melee", attachment = "Base.Mag9x39ExtLg", model = "VSSVintorezNoMag" },
        { fullType = "Base.ASVal", attachment = "Base.Mag9x39ExtLg", model = "ASValNoMag" },
        { fullType = "Base.ASVal_Melee", attachment = "Base.Mag9x39ExtLg", model = "ASValNoMag" },
        { fullType = "Base.ASVal_Folded", attachment = "Base.Mag9x39ExtLg", model = "ASValFoldedNoMag" },
        { fullType = "Base.ASVal_Folded_Melee", attachment = "Base.Mag9x39ExtLg", model = "ASValFoldedNoMag" },
        { fullType = "Base.EM2", attachment = "Base.Mag762x51ExtLg", model = "EM2NoMag" },
        { fullType = "Base.EM2_Melee", attachment = "Base.Mag762x51ExtLg", model = "EM2NoMag" },
        { fullType = "Base.Galil", attachment = "Base.Mag762x51ExtSm", model = "GalilNoMag" },
        { fullType = "Base.Galil_Melee", attachment = "Base.Mag762x51ExtSm", model = "GalilNoMag" },
        { fullType = "Base.Galil_Bipod", attachment = "Base.Mag762x51ExtSm", model = "GalilBipodNoMag" },
    }
    
    for _, change in ipairs(extendedMagChange) do
        BWTweaks:changeModelByAttachment(change.fullType, change.attachment, change.model)
    end

    -----------------------------------------
    --- ATTACHMENT + MAGAZINE MODEL SWAPS ---
    -----------------------------------------

    local platingWeapon = {
        ----Crab Shell Luger
        { fullType = "Base.Luger", attachment = "Base.CrabShellPlating", modelWithMag = "LugerCrabShell", modelWithoutMag = "LugerCrabShellNoMag" },
        ----CrabShell STG
        { fullType = "Base.StG44", attachment = "Base.CrabShellPlating", modelWithMag = "StG44CrabShell", modelWithoutMag = "StG44CrabShellNoMag" },
        { fullType = "Base.StG44_Melee", attachment = "Base.CrabShellPlating", modelWithMag = "StG44CrabShell", modelWithoutMag = "StG44CrabShellNoMag" },
        ----Winter Camo AK74U
        { fullType = "Base.AK74U", attachment = "Base.WinterCamoPlating", modelWithMag = "AK74UWinter", modelWithoutMag = "AK74UWinterNoMag" },
        { fullType = "Base.AK74U_Melee", attachment = "Base.WinterCamoPlating", modelWithMag = "AK74UWinter", modelWithoutMag = "AK74UWinterNoMag" },
        { fullType = "Base.AK74U_Folded", attachment = "Base.WinterCamoPlating", modelWithMag = "AK74UWinter_Folded", modelWithoutMag = "AK74UWinterNoMag_Folded" },
        { fullType = "Base.AK74U_Folded_Melee", attachment = "Base.WinterCamoPlating", modelWithMag = "AK74UWinter_Folded", modelWithoutMag = "AK74UWinterNoMag_Folded" },
        ----Gold AK74U
        { fullType = "Base.AK74U", attachment = "Base.GoldGunPlating", modelWithMag = "AK74UGold", modelWithoutMag = "AK74UGoldNoMag" },
        { fullType = "Base.AK74U_Melee", attachment = "Base.GoldGunPlating", modelWithMag = "AK74UGold", modelWithoutMag = "AK74UGoldNoMag" },
        { fullType = "Base.AK74U_Folded", attachment = "Base.GoldGunPlating", modelWithMag = "AK74UGold_Folded", modelWithoutMag = "AK74UGoldNoMag_Folded" },
        { fullType = "Base.AK74U_Folded_Melee", attachment = "Base.GoldGunPlating", modelWithMag = "AK74UGold_Folded", modelWithoutMag = "AK74UGoldNoMag_Folded" },
        ----Rainbow AK74U
        { fullType = "Base.AK74U", attachment = "Base.RainbowPlating", modelWithMag = "AK74URainbow", modelWithoutMag = "AK74URainbowNoMag" },
        { fullType = "Base.AK74U_Melee", attachment = "Base.RainbowPlating", modelWithMag = "AK74URainbow", modelWithoutMag = "AK74URainbowNoMag" },
        { fullType = "Base.AK74U_Folded", attachment = "Base.RainbowPlating", modelWithMag = "AK74URainbow_Folded", modelWithoutMag = "AK74URainbowNoMag_Folded" },
        { fullType = "Base.AK74U_Folded_Melee", attachment = "Base.RainbowPlating", modelWithMag = "AK74URainbow_Folded", modelWithoutMag = "AK74URainbowNoMag_Folded" },
        ----Blue and Yellow DZ styled FranchiLF57
        { fullType = "Base.FranchiLF57", attachment = "Base.DZPlating", modelWithMag = "FranchiLF57DZ", modelWithoutMag = "FranchiLF57DZNoMag" },
        { fullType = "Base.FranchiLF57_Melee", attachment = "Base.DZPlating", modelWithMag = "FranchiLF57DZ", modelWithoutMag = "FranchiLF57DZNoMag" },
        { fullType = "Base.FranchiLF57_Folded", attachment = "Base.DZPlating", modelWithMag = "FranchiLF57DZ_Folded", modelWithoutMag = "FranchiLF57DZNoMag_Folded" },
        { fullType = "Base.FranchiLF57_Folded_Melee", attachment = "Base.DZPlating", modelWithMag = "FranchiLF57DZ_Folded", modelWithoutMag = "FranchiLF57DZNoMag_Folded" },
        ----Skeletonized Stock AK103
        { fullType = "Base.AK103", attachment = "Base.SkeletonizedStock", modelWithMag = "AK103Skele", modelWithoutMag = "AK103SkeleNoMag" },
        { fullType = "Base.AK103_Melee", attachment = "Base.SkeletonizedStock", modelWithMag = "AK103Skele", modelWithoutMag = "AK103SkeleNoMag" },
        ----Rainbow Anondized AK103
        { fullType = "Base.AK103", attachment = "Base.RainbowPlating", modelWithMag = "AK103Rainbow", modelWithoutMag = "AK103RainbowNoMag" },
        { fullType = "Base.AK103_Melee", attachment = "Base.RainbowPlating", modelWithMag = "AK103Rainbow", modelWithoutMag = "AK103RainbowNoMag" },
        ----Gold Plating AK103
        { fullType = "Base.AK103", attachment = "Base.GoldGunPlating", modelWithMag = "AK103Gold", modelWithoutMag = "AK103GoldNoMag" },
        { fullType = "Base.AK103_Melee", attachment = "Base.GoldGunPlating", modelWithMag = "AK103Gold", modelWithoutMag = "AK103GoldNoMag" },
        ----Winter Camo AK103
        { fullType = "Base.AK103", attachment = "Base.WinterCamoPlating", modelWithMag = "AK103Winter", modelWithoutMag = "AK103WinterNoMag" },
        { fullType = "Base.AK103_Melee", attachment = "Base.WinterCamoPlating", modelWithMag = "AK103Winter", modelWithoutMag = "AK103WinterNoMag" },
        ----Matte Black and Gold/Platinum Trim AK103
        { fullType = "Base.AK103", attachment = "Base.MatteBlackPlating", modelWithMag = "AK103MatteBlack", modelWithoutMag = "AK103MatteBlackNoMag" },
        { fullType = "Base.AK103_Melee", attachment = "Base.MatteBlackPlating", modelWithMag = "AK103MatteBlack", modelWithoutMag = "AK103MatteBlackNoMag" },
        ----Winter Camo AK74
        { fullType = "Base.AK74", attachment = "Base.WinterCamoPlating", modelWithMag = "AK74Winter", modelWithoutMag = "AK74WinterNoMag" },
        { fullType = "Base.AK74_Melee", attachment = "Base.WinterCamoPlating", modelWithMag = "AK74Winter", modelWithoutMag = "AK74WinterNoMag" },
        ----Gold AK74
        { fullType = "Base.AK74", attachment = "Base.GoldGunPlating", modelWithMag = "AK74Gold", modelWithoutMag = "AK74GoldNoMag" },
        { fullType = "Base.AK74_Melee", attachment = "Base.GoldGunPlating", modelWithMag = "AK74Gold", modelWithoutMag = "AK74GoldNoMag" },
        ----Rainbow AK74
        { fullType = "Base.AK74", attachment = "Base.RainbowPlating", modelWithMag = "AK74Rainbow", modelWithoutMag = "AK74RainbowNoMag" },
        { fullType = "Base.AK74_Melee", attachment = "Base.RainbowPlating", modelWithMag = "AK74Rainbow", modelWithoutMag = "AK74RainbowNoMag" },
        ----Pink Plating and P90
        { fullType = "Base.P90", attachment = "Base.PinkPlating", modelWithMag = "P90Pink", modelWithoutMag = "P90PinkNoMag" },
        { fullType = "Base.P90_Melee", attachment = "Base.PinkPlating", modelWithMag = "P90Pink", modelWithoutMag = "P90PinkNoMag" },
        ----Black Ice Plating and P90
        { fullType = "Base.P90", attachment = "Base.BlackIcePlating", modelWithMag = "P90BlackIce", modelWithoutMag = "P90BlackIceNoMag" },
        { fullType = "Base.P90_Melee", attachment = "Base.BlackIcePlating", modelWithMag = "P90BlackIce", modelWithoutMag = "P90BlackIceNoMag" },
        ----Plank Plating and P90
        { fullType = "Base.P90", attachment = "Base.PlankPlating", modelWithMag = "P90Plank", modelWithoutMag = "P90PlankNoMag" },
        { fullType = "Base.P90_Melee", attachment = "Base.PlankPlating", modelWithMag = "P90Plank", modelWithoutMag = "P90PlankNoMag" },
        ----Green/Gold and M1918
        { fullType = "Base.M1918BAR", attachment = "Base.GreenGoldPlating", modelWithMag = "M1918BARGreenGold", modelWithoutMag = "M1918BARGreenGoldNoMag" },
        { fullType = "Base.M1918BAR_Bipod", attachment = "Base.GreenGoldPlating", modelWithMag = "M1918BARGreenGoldBipod", modelWithoutMag = "M1918BARGreenGoldBipodNoMag" },
        { fullType = "Base.M1918BAR_Melee", attachment = "Base.GreenGoldPlating", modelWithMag = "M1918BARGreenGold", modelWithoutMag = "M1918BARGreenGoldNoMag" },
        ----White SIG550
        { fullType = "Base.SIG550", attachment = "Base.WinterCamoPlating", modelWithMag = "SIG550White", modelWithoutMag = "SIG550WhiteNoMag" },
        { fullType = "Base.SIG550_Melee", attachment = "Base.WinterCamoPlating", modelWithMag = "SIG550White", modelWithoutMag = "SIG550WhiteNoMag" },
        ----Pink SIG550
        { fullType = "Base.SIG550", attachment = "Base.PinkPlating", modelWithMag = "SIG550Pink", modelWithoutMag = "SIG550PinkNoMag" },
        { fullType = "Base.SIG550_Melee", attachment = "Base.PinkPlating", modelWithMag = "SIG550Pink", modelWithoutMag = "SIG550PinkNoMag" }, 
        ----Green SIG550
        { fullType = "Base.SIG550", attachment = "Base.GreenGoldPlating", modelWithMag = "SIG550Green", modelWithoutMag = "SIG550GreenNoMag" },
        { fullType = "Base.SIG550_Melee", attachment = "Base.GreenGoldPlating", modelWithMag = "SIG550Green", modelWithoutMag = "SIG550GreenNoMag" }, 
        ----Shenron SIG550
        { fullType = "Base.SIG550", attachment = "Base.ShenronPlating", modelWithMag = "SIG550Shenron", modelWithoutMag = "SIG550ShenronNoMag" },
        { fullType = "Base.SIG550_Melee", attachment = "Base.ShenronPlating", modelWithMag = "SIG550Shenron", modelWithoutMag = "SIG550ShenronNoMag" }, 
        ---Steel Damascus Barrett
        { fullType = "Base.BarrettM82A1", attachment = "Base.SteelDamascusPlating", modelWithMag = "BarrettM82A1SteelDamascus", modelWithoutMag = "BarrettM82A1SteelDamascusNoMag" },
        { fullType = "Base.BarrettM82A1_Bipod", attachment = "Base.SteelDamascusPlating", modelWithMag = "BarrettM82A1SteelDamascusBipod", modelWithoutMag = "BarrettM82A1SteelDamascusBipodNoMag" },
        { fullType = "Base.BarrettM82A1_Melee", attachment = "Base.SteelDamascusPlating", modelWithMag = "BarrettM82A1SteelDamascus", modelWithoutMag = "BarrettM82A1SteelDamascusNoMag" },
        ---Salvaged Rage Barrett 
        { fullType = "Base.BarrettM82A1", attachment = "Base.SalvagedRagePlating", modelWithMag = "BarrettM82A1SalvagedRage", modelWithoutMag = "BarrettM82A1SalvagedRageNoMag" },
        { fullType = "Base.BarrettM82A1_Bipod", attachment = "Base.SalvagedRagePlating", modelWithMag = "BarrettM82A1SalvagedRageBipod", modelWithoutMag = "BarrettM82A1SalvagedRageBipodNoMag" },
        { fullType = "Base.BarrettM82A1_Melee", attachment = "Base.SalvagedRagePlating", modelWithMag = "BarrettM82A1SalvagedRage", modelWithoutMag = "BarrettM82A1SalvagedRageNoMag" },
        ---Zoidberg Special Barrett
        { fullType = "Base.BarrettM82A1", attachment = "Base.ZoidbergSpecialPlating", modelWithMag = "BarrettM82A1ZoidbergSpecial", modelWithoutMag = "BarrettM82A1ZoidbergSpecialNoMag" },
        { fullType = "Base.BarrettM82A1_Bipod", attachment = "Base.ZoidbergSpecialPlating", modelWithMag = "BarrettM82A1ZoidbergSpecialBipod", modelWithoutMag = "BarrettM82A1ZoidbergSpecialBipodNoMag" },
        { fullType = "Base.BarrettM82A1_Melee", attachment = "Base.ZoidbergSpecialPlating", modelWithMag = "BarrettM82A1ZoidbergSpecial", modelWithoutMag = "BarrettM82A1ZoidbergSpecialNoMag" },
        ----Survivalist SVD Dragunov
        { fullType = "Base.SVDDragunov", attachment = "Base.SurvivalistPlating", modelWithMag = "SVDDragunovSurvivalist", modelWithoutMag = "SVDDragunovSurvivalistNoMag" },
        { fullType = "Base.SVDDragunov_Melee", attachment = "Base.SurvivalistPlating", modelWithMag = "SVDDragunovSurvivalist", modelWithoutMag = "SVDDragunovSurvivalistNoMag" }, 
        ----Snowstorm SVD Dragunov
        { fullType = "Base.SVDDragunov", attachment = "Base.WinterCamoPlating", modelWithMag = "SVDDragunovSnowstorm", modelWithoutMag = "SVDDragunovSnowstormNoMag" },
        { fullType = "Base.SVDDragunov_Melee", attachment = "Base.WinterCamoPlating", modelWithMag = "SVDDragunovSnowstorm", modelWithoutMag = "SVDDragunovSnowstormNoMag" }, 
        ----Gold Mini Uzi
        { fullType = "Base.MiniUzi", attachment = "Base.GoldGunPlating", modelWithMag = "MiniUziGold", modelWithoutMag = "MiniUziGoldNoMag" },
        { fullType = "Base.MiniUzi_Melee", attachment = "Base.GoldGunPlating", modelWithMag = "MiniUziGold", modelWithoutMag = "MiniUziGoldNoMag" },
        { fullType = "Base.MiniUzi_Folded", attachment = "Base.GoldGunPlating", modelWithMag = "MiniUziGold_Folded", modelWithoutMag = "MiniUziGoldNoMag_Folded" },
        { fullType = "Base.MiniUzi_Folded_Melee", attachment = "Base.GoldGunPlating", modelWithMag = "MiniUziGold_Folded", modelWithoutMag = "MiniUziGoldNoMag_Folded" },
         ----Rainbow Mini Uzi
         { fullType = "Base.MiniUzi", attachment = "Base.RainbowPlating", modelWithMag = "MiniUziRainbow", modelWithoutMag = "MiniUziRainbowNoMag" },
         { fullType = "Base.MiniUzi_Melee", attachment = "Base.RainbowPlating", modelWithMag = "MiniUziRainbow", modelWithoutMag = "MiniUziRainbowNoMag" },
         { fullType = "Base.MiniUzi_Folded", attachment = "Base.RainbowPlating", modelWithMag = "MiniUziRainbow_Folded", modelWithoutMag = "MiniUziRainbowNoMag_Folded" },
         { fullType = "Base.MiniUzi_Folded_Melee", attachment = "Base.RainbowPlating", modelWithMag = "MiniUziRainbow_Folded", modelWithoutMag = "MiniUziRainbowNoMag_Folded" },       
        ---M4A1 Tan
        { fullType = "Base.M4A1", attachment = "Base.TanPlating", modelWithMag = "M4A1Tan", modelWithoutMag = "M4A1TanNoMag" },
        { fullType = "Base.M4A1_Melee", attachment = "Base.TanPlating", modelWithMag = "M4A1Tan", modelWithoutMag = "M4A1TanNoMag" },
        ---M4A1 White
        { fullType = "Base.M4A1", attachment = "Base.WinterCamoPlating", modelWithMag = "M4A1White", modelWithoutMag = "M4A1WhiteNoMag" },
        { fullType = "Base.M4A1_Melee", attachment = "Base.WinterCamoPlating", modelWithMag = "M4A1White", modelWithoutMag = "M4A1WhiteNoMag" },
        ---M4A1 Blue      
        { fullType = "Base.M4A1", attachment = "Base.BluePlating", modelWithMag = "M4A1Blue", modelWithoutMag = "M4A1BlueNoMag" },
        { fullType = "Base.M4A1_Melee", attachment = "Base.BluePlating", modelWithMag = "M4A1Blue", modelWithoutMag = "M4A1BlueNoMag" },
        ---M4A1 Red
        { fullType = "Base.M4A1", attachment = "Base.RedPlating", modelWithMag = "M4A1Red", modelWithoutMag = "M4A1RedNoMag" },
        { fullType = "Base.M4A1_Melee", attachment = "Base.RedPlating", modelWithMag = "M4A1Red", modelWithoutMag = "M4A1RedNoMag" },
        ---M4A1 Pink
        { fullType = "Base.M4A1", attachment = "Base.PinkPlating", modelWithMag = "M4A1Pink", modelWithoutMag = "M4A1PinkNoMag" },
        { fullType = "Base.M4A1_Melee", attachment = "Base.PinkPlating", modelWithMag = "M4A1Pink", modelWithoutMag = "M4A1PinkNoMag" },
        ---M4A1 Cannabis
        { fullType = "Base.M4A1", attachment = "Base.CannabisPlating", modelWithMag = "M4A1Cannabis", modelWithoutMag = "M4A1CannabisNoMag" },
        { fullType = "Base.M4A1_Melee", attachment = "Base.CannabisPlating", modelWithMag = "M4A1Cannabis", modelWithoutMag = "M4A1CannabisNoMag" },
    }

    for _, change in ipairs(platingWeapon) do
        BWTweaks:changeModelByAttachmentAndMagPresent(change.fullType, change.attachment, true, change.modelWithMag)
        BWTweaks:changeModelByAttachmentAndMagPresent(change.fullType, change.attachment, false, change.modelWithoutMag)
    end

    -------------------------
    --- DUAL ATTACHMENTS  ---
    -------------------------

    local dualAttach = {
        { fullType = "Base.AK103", attachments = {"Base.SkeletonizedStock", "Base.RainbowPlating"}, modelWithMag = "AK103RainbowSkele", modelWithoutMag = "AK103RainbowSkeleNoMag" },
        { fullType = "Base.AK103_Melee", attachments = {"Base.SkeletonizedStock", "Base.RainbowPlating"}, modelWithMag = "AK103RainbowSkele", modelWithoutMag = "AK103RainbowSkeleNoMag" },
        { fullType = "Base.AK103", attachments = {"Base.SkeletonizedStock", "Base.GoldGunPlating"}, modelWithMag = "AK103GoldSkele", modelWithoutMag = "AK103GoldSkeleNoMag" },
        { fullType = "Base.AK103_Melee", attachments = {"Base.SkeletonizedStock", "Base.GoldGunPlating"}, modelWithMag = "AK103GoldSkele", modelWithoutMag = "AK103GoldSkeleNoMag" },
        { fullType = "Base.AK103", attachments = {"Base.SkeletonizedStock", "Base.WinterCamoPlating"}, modelWithMag = "AK103WinterSkele", modelWithoutMag = "AK103WinterSkeleNoMag" },
        { fullType = "Base.AK103_Melee", attachments = {"Base.SkeletonizedStock", "Base.WinterCamoPlating"}, modelWithMag = "AK103WinterSkele", modelWithoutMag = "AK103WinterSkeleNoMag" },
        { fullType = "Base.AK103", attachments = {"Base.SkeletonizedStock", "Base.MatteBlackPlating"}, modelWithMag = "AK103MatteBlackSkele", modelWithoutMag = "AK103MatteBlackSkeleNoMag" },
        { fullType = "Base.AK103_Melee", attachments = {"Base.SkeletonizedStock", "Base.MatteBlackPlating"}, modelWithMag = "AK103MatteBlackSkele", modelWithoutMag = "AK103MatteBlackSkeleNoMag" },
    }

    for _, change in ipairs(dualAttach) do
        BWTweaks:changeModelByAttachmentAndMagPresent(change.fullType, change.attachments, true, change.modelWithMag)
        BWTweaks:changeModelByAttachmentAndMagPresent(change.fullType, change.attachments, false, change.modelWithoutMag)
    end

    -----------------------------------------------
    --- PLATING ATTACHMENT + EXTENDED MAGAZINE SWAPS ---
    -----------------------------------------------
    
    local extendedMagDualAttach = {
        { fullType = "Base.M1918BAR", attachments = {"Base.Mag3006ExtLg", "Base.GreenGoldPlating"}, model = "M1918BARGreenGoldNoMag" },
        { fullType = "Base.M1918BAR_Bipod", attachments = {"Base.Mag3006ExtLg", "Base.GreenGoldPlating"}, model = "M1918BARGreenGoldBipodNoMag" },
        { fullType = "Base.M1918BAR_Melee", attachments = {"Base.Mag3006ExtLg", "Base.GreenGoldPlating"}, model = "M1918BARGreenGoldNoMag" },
        { fullType = "Base.SVDDragunov", attachments = {"Base.MagSVDExtSm", "Base.WinterCamoPlating"}, model = "SVDDragunovSnowstormNoMag" },
        { fullType = "Base.SVDDragunov_Melee", attachments = {"Base.MagSVDExtSm", "Base.WinterCamoPlating"}, model = "SVDDragunovSnowstormNoMag" },
        { fullType = "Base.SVDDragunov", attachments = {"Base.MagSVDExtSm", "Base.SurvivalistPlating"}, model = "SVDDragunovSurvivalistNoMag" },
        { fullType = "Base.SVDDragunov_Melee", attachments = {"Base.MagSVDExtSm", "Base.SurvivalistPlating"}, model = "SVDDragunovSurvivalistNoMag" },
    }

    for _, change in ipairs(extendedMagDualAttach) do
        BWTweaks:changeModelByAttachment(change.fullType, change.attachments, change.model)
    end
    
    -----------------------------------
    --- CHAMBERED ROUND MODEL SWAPS ---
    -----------------------------------

    -- Compound Crossbow
    local chamberedChange = {
        { fullType = "Base.CrossbowCompound", loaded  = "CrossbowCompoundLoaded", empty = "CrossbowCompound" },
        { fullType = "Base.CrossbowCompound_Melee", loaded  = "CrossbowCompoundLoaded", empty = "CrossbowCompound" },
    }
    
    for _, change in ipairs(chamberedChange) do
        BWTweaks:changeModelByRoundChambered(change.fullType, true, change.loaded )
        BWTweaks:changeModelByRoundChambered(change.fullType, false, change.empty)
    end

    -- Compound Crossbow Attachment Version
    local chamberedAttachmentChange = {
        { fullType = "Base.CrossbowCompound", attachment = "Base.RedWhitePlating", loaded  = "CrossbowCompoundLoadedRedWhite", empty = "CrossbowCompoundRedWhite" },
        { fullType = "Base.CrossbowCompound_Melee", attachment = "Base.RedWhitePlating", loaded  = "CrossbowCompoundLoadedRedWhite", empty = "CrossbowCompoundRedWhite" },
    }
    

    for _, changeMore in ipairs (chamberedAttachmentChange) do
        BWTweaks:changeModelByAttachmentAndRoundChambered(changeMore.fullType, changeMore.attachment, true, changeMore.loaded )
        BWTweaks:changeModelByAttachmentAndRoundChambered(changeMore.fullType, changeMore.attachment, false, changeMore.empty)
    end

    -----------------------------------
    --- ATTACHMENT ONLY MODEL SWAPS ---
    -----------------------------------
    --Luger Melee CrabShell
    BWTweaks:changeModelByAttachment("Base.Luger_Melee", "Base.CrabShellPlating", "LugerCrabShellMelee");
    
    --Derringer UWU
    BWTweaks:changeModelByAttachment("Base.Derringer", "Base.PinkPlating", "DerringerUWU");
    BWTweaks:changeModelByAttachment("Base.Derringer_OPEN", "Base.PinkPlating", "DerringerUWU_OPEN");
    BWTweaks:changeModelByAttachment("Base.Derringer_Melee", "Base.PinkPlating", "DerringerUWU_Melee");

    ---Henry Repeating Big Boy Fancy
    BWTweaks:changeModelByAttachment("Base.HenryRepeatingBigBoy", "Base.GoldGunPlating", "HenryRepeatingBigBoyDeluxe");
    BWTweaks:changeModelByAttachment("Base.HenryRepeatingBigBoy_Melee", "Base.GoldGunPlating", "HenryRepeatingBigBoyDeluxe");
    
    BWTweaks:changeModelByAttachment("Base.HenryRepeatingBigBoy", "Base.PinkPlating", "HenryRepeatingBigBoyPink");
    BWTweaks:changeModelByAttachment("Base.HenryRepeatingBigBoy_Melee", "Base.PinkPlating", "HenryRepeatingBigBoyPink");

    --Remington1100 Wood Styling
    BWTweaks:changeModelByAttachment("Base.Remington1100", "Base.WoodStyledPlating", "Remington1100Wood");
    BWTweaks:changeModelByAttachment("Base.Remington1100_Melee", "Base.WoodStyledPlating", "Remington1100Wood");
 
    --Remington1100 Gold 
    BWTweaks:changeModelByAttachment("Base.Remington1100", "Base.GoldShotgunPlating", "Remington1100Gold");
    BWTweaks:changeModelByAttachment("Base.Remington1100_Melee", "Base.GoldShotgunPlating", "Remington1100Gold");
 
    --Remington1100 Rainbow
    BWTweaks:changeModelByAttachment("Base.Remington1100", "Base.RainbowAnodizedPlating", "Remington1100Rainbow");
    BWTweaks:changeModelByAttachment("Base.Remington1100_Melee", "Base.RainbowAnodizedPlating", "Remington1100Rainbow");

    --Remington1100 Red White
    BWTweaks:changeModelByAttachment("Base.Remington1100", "Base.RedWhitePlating", "Remington1100RedWhite");
    BWTweaks:changeModelByAttachment("Base.Remington1100_Melee", "Base.RedWhitePlating", "Remington1100RedWhite");

    --Trench Gun Pink
    BWTweaks:changeModelByAttachment("Base.TrenchGun", "Base.PinkPlating", "TrenchGunPink");
    BWTweaks:changeModelByAttachment("Base.TrenchGun_Melee", "Base.PinkPlating", "TrenchGunPink");

    --Trench Gun Yellow
    BWTweaks:changeModelByAttachment("Base.TrenchGun", "Base.YellowPlating", "TrenchGunYellow");
    BWTweaks:changeModelByAttachment("Base.TrenchGun_Melee", "Base.YellowPlating", "TrenchGunYellow");

    --PM63Rack Green Animal Print
    BWTweaks:changeModelByAttachment("Base.PM63RAK", "Base.GreenPlating", "PM63RAKGreenAnimal");
    BWTweaks:changeModelByAttachment("Base.PM63RAK_Melee", "Base.GreenPlating", "PM63RAKGreenAnimal");
    BWTweaks:changeModelByAttachment("Base.PM63RAK_Grip", "Base.GreenPlating", "PM63RAKGrGreenAnimal");
    BWTweaks:changeModelByAttachment("Base.PM63RAK_Extended", "Base.GreenPlating", "PM63RAKExtGreenAnimal");
    BWTweaks:changeModelByAttachment("Base.PM63RAK_Extended_Melee", "Base.GreenPlating", "PM63RAKExtGreenAnimal");
    BWTweaks:changeModelByAttachment("Base.PM63RAK_GripExtended", "Base.GreenPlating", "PM63RAKExtGrGreenAnimal");

    -- Colt Cavalry Revolver Gilded Age
    BWTweaks:changeModelByAttachment("Base.ColtCavalryRevolver", "Base.GildedAgePlating", "ColtCavalryRevolverGold");
    BWTweaks:changeModelByAttachment("Base.ColtCavalryRevolver_Melee", "Base.GildedAgePlating", "ColtCavalryRevolverMeleeGold");
    -- Colt Cavalry Revolver BlackDeath
    BWTweaks:changeModelByAttachment("Base.ColtCavalryRevolver", "Base.BlackDeathPlating", "ColtCavalryRevolverBlackDeath");
    BWTweaks:changeModelByAttachment("Base.ColtCavalryRevolver_Melee", "Base.BlackDeathPlating", "ColtCavalryRevolverMeleeBlackDeath");
    -- Colt Cavalry Revolver Ornate Ivory
    BWTweaks:changeModelByAttachment("Base.ColtCavalryRevolver", "Base.OrnateIvoryPlating", "ColtCavalryRevolverOrnateIvory");
    BWTweaks:changeModelByAttachment("Base.ColtCavalryRevolver_Melee", "Base.OrnateIvoryPlating", "ColtCavalryRevolverMeleeOrnateIvory");

    ------------------------------------
    --- SNIPER SUPPRESSOR MODEL SWAP ---
    ------------------------------------

    local suppressorsSniper = {
        "Base.SuppressorSniper",
        "Base.SuppressorSniperWinter",
        "Base.SuppressorSniperDesert",
        "Base.SuppressorSniperWoodland",
    }

    local typesBarrett = {
        "Base.BarrettM82A1",
        "Base.BarrettM82A1_Melee",
    }

    local platingBarrett = {
        "Base.SteelDamascusPlating",
        "Base.SalvagedRagePlating",
        "Base.ZoidbergSpecialPlating"
    }
    
    for _, sup in ipairs(suppressorsSniper) do
        for _, typ in ipairs(typesBarrett) do
            BWTweaks:changeModelByAttachmentAndMagPresent(typ, sup, true, "BarrettM82A1Suppressor")
            BWTweaks:changeModelByAttachmentAndMagPresent(typ, sup, false, "BarrettM82A1NoMagSuppressor")
        end
    end

    for _, sup in ipairs(suppressorsSniper) do
        BWTweaks:changeModelByAttachmentAndMagPresent("Base.BarrettM82A1_Bipod", sup, true, "BarrettM82A1BipodSuppressor")
        BWTweaks:changeModelByAttachmentAndMagPresent("Base.BarrettM82A1_Bipod", sup, false, "BarrettM82A1BipodNoMagSuppressor")
    end

    for _, sup in ipairs(suppressorsSniper) do
        for _, typ in ipairs(typesBarrett) do
            for _, attach in ipairs(platingBarrett) do
                BWTweaks:changeModelByAttachmentAndMagPresent(typ, {attach, sup}, true, "BarrettM82A1" .. attach:gsub("Base.", ""):gsub("Plating", "") .. "Suppressor")
                BWTweaks:changeModelByAttachmentAndMagPresent(typ, {attach, sup}, false, "BarrettM82A1" .. attach:gsub("Base.", ""):gsub("Plating", "") .. "NoMagSuppressor")
            end
        end
    end

    for _, sup in ipairs(suppressorsSniper) do
        for _, attach in ipairs(platingBarrett) do
            BWTweaks:changeModelByAttachmentAndMagPresent("Base.BarrettM82A1_Bipod", {attach, sup}, true, "BarrettM82A1" .. attach:gsub("Base.", ""):gsub("Plating", "") .. "BipodSuppressor")
            BWTweaks:changeModelByAttachmentAndMagPresent("Base.BarrettM82A1_Bipod", {attach, sup}, false, "BarrettM82A1" .. attach:gsub("Base.", ""):gsub("Plating", "") .. "BipodNoMagSuppressor")
        end
    end

    ----------------------------
    --- TACTICAL LASER TOGGLE ---
    -----------------------------

    local weapons = {
        "Base.PLR16",
        "Base.PLR16_Melee",
        "Base.MosinNagantObrez",
        "Base.MosinNagantObrez_Melee",
        "Base.AK74U",
        "Base.AK74U_Folded",
        "Base.AK74U_Melee",
        "Base.AK74U_Folded_Melee",
        "Base.MP28",
        "Base.MP28_Melee",
        "Base.AK103",
        "Base.AK103_Melee",
        "Base.AK74",
        "Base.AK74_Melee",
        "Base.GrozaOTs14",
        "Base.GrozaOTs14_Melee",
        "Base.StG44",
        "Base.StG44_Melee",
        "Base.MosinNagant",
        "Base.MosinNagant_Melee",
        "Base.L2A1",
        "Base.L2A1_Bipod",
        "Base.L2A1_Melee",
        "Base.EM2",
        "Base.EM2_Melee",
        "Base.L85A1",
        "Base.L85A1_Melee",
        "Base.ASVal",
        "Base.ASVal_Melee",
        "Base.ASVal_Folded",
        "Base.ASVal_Folded_Melee",
        "Base.SIG550",
        "Base.SIG550_Melee",
        "Base.HenryRepeatingBigBoy",
        "Base.HenryRepeatingBigBoy_Melee",
        "Base.SVDDragunov",
        "Base.SVDDragunov_Melee",
        "Base.Galil",
        "Base.Galil_Bipod",
        "Base.Galil_Melee",
        "Base.VSSVintorez",
        "Base.VSSVintorez_Melee",
        "Base.M4A1",
        "Base.M4A1_Melee",
        "Base.CrossbowCompound",
        "Base.CrossbowCompound_Melee",
    }

    local laserColors = {
        { attachment = "Base.LaserGreen", translate = "IGUI_HFA_LaserGreen" },
        { attachment = "Base.LaserRed", translate = "IGUI_HFA_LaserRed" },
    }
    
    for _, weaponType in ipairs(weapons) do
        for _, colorData in ipairs(laserColors) do
            BWTweaks:addToggleOption(weaponType, "Base.LaserNoLight", colorData.attachment, colorData.translate)
        end
    end

end);