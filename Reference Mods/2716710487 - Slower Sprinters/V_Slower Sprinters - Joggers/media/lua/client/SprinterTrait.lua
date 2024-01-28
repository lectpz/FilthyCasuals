require('NPCs/MainCreationMethods');

local function initSprinterTrait()
    local Sprinter = TraitFactory.addTrait(
        "Sprinter",
        getText("UI_trait_Sprinter"),
        8,
        getText("UI_trait_SprinterDesc"),
        false,
        false
    );
    Sprinter:addXPBoost(Perks.Sprinting, 4);
	
    TraitFactory.setMutualExclusive("Sprinter", "Jogger");
    TraitFactory.setMutualExclusive("Sprinter", "Unfit");
    TraitFactory.setMutualExclusive("Sprinter", "Nutritionist2");
end

Events.OnGameBoot.Add(initSprinterTrait);
