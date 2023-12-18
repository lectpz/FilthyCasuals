require "recipecode"

function Recipe.OnGiveXP.Mechanics5(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Mechanics, 5);
end

function Recipe.OnGiveXP.Mechanics10(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Mechanics, 10);
end

function Recipe.OnGiveXP.Mechanics15(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Mechanics, 15);
end

function Recipe.OnGiveXP.Mechanics20(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Mechanics, 20);
end

function Recipe.OnGiveXP.Mechanics25(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Mechanics, 25);
end

Give5MECHXP = Recipe.OnGiveXP.Mechanics5
Give10MECHXP = Recipe.OnGiveXP.Mechanics10
Give15MECHXP = Recipe.OnGiveXP.Mechanics15
Give20MECHXP = Recipe.OnGiveXP.Mechanics20
Give25MECHXP = Recipe.OnGiveXP.Mechanics25

function Recipe.OnGiveXP.Electricity5(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Electricity, 5);
end

function Recipe.OnGiveXP.Electricity10(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Electricity, 10);
end

function Recipe.OnGiveXP.Electricity15(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Electricity, 15);
end

function Recipe.OnGiveXP.Electricity20(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Electricity, 20);
end

function Recipe.OnGiveXP.Electricity25(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Electricity, 25);
end

Give5ELECXP = Recipe.OnGiveXP.Electricity5
Give10ELECXP = Recipe.OnGiveXP.Electricity10
Give15ELECXP = Recipe.OnGiveXP.Electricity15
Give20ELECXP = Recipe.OnGiveXP.Electricity20
Give25ELECXP = Recipe.OnGiveXP.Electricity25

function Recipe.OnGiveXP.MechanicsMetalwork5(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Mechanics, 5);
	player:getXp():AddXP(Perks.MetalWelding, 5);
end

function Recipe.OnGiveXP.MechanicsMetalWork10(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Mechanics, 10);
    player:getXp():AddXP(Perks.MetalWelding, 10);
end

function Recipe.OnGiveXP.MechanicsMetalwork15(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Mechanics, 15);
    player:getXp():AddXP(Perks.MetalWelding, 15);
end

function Recipe.OnGiveXP.MechanicsMetalwork20(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Mechanics, 20);
    player:getXp():AddXP(Perks.MetalWelding, 20);
end

function Recipe.OnGiveXP.MechanicsMetalwork25(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Mechanics, 25);
    player:getXp():AddXP(Perks.MetalWelding, 25);
end

Give5MECHMWXP = Recipe.OnGiveXP.MechanicsMetalwork5
Give10MECHMWXP = Recipe.OnGiveXP.MechanicsMetalWork10
Give15MECHMWXP = Recipe.OnGiveXP.MechanicsMetalwork15
Give20MECHMWXP = Recipe.OnGiveXP.MechanicsMetalwork20
Give25MECHMWXP = Recipe.OnGiveXP.MechanicsMetalwork25

function Recipe.OnGiveXP.WoodWork10(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Woodwork, 10);
end

function Recipe.OnGiveXP.WoodWork15(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Woodwork, 15);
end

function Recipe.OnGiveXP.WoodWork20(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Woodwork, 20);
end

function Recipe.OnGiveXP.WoodWork25(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Woodwork, 25);
end

Give10WoodworkXP = Recipe.OnGiveXP.WoodWork10
Give15WoodworkXP = Recipe.OnGiveXP.WoodWork15
Give20WoodworkXP = Recipe.OnGiveXP.WoodWork20
Give25WoodworkXP = Recipe.OnGiveXP.WoodWork25

function Recipe.OnGiveXP.ElectricityMetalwork5(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Electricity, 5);
	player:getXp():AddXP(Perks.MetalWelding, 5);
end

function Recipe.OnGiveXP.ElectricityMetalWork10(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Electricity, 10);
    player:getXp():AddXP(Perks.MetalWelding, 10);
end

function Recipe.OnGiveXP.ElectricityMetalwork15(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Electricity, 15);
    player:getXp():AddXP(Perks.MetalWelding, 15);
end

function Recipe.OnGiveXP.ElectricityMetalwork20(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Electricity, 20);
    player:getXp():AddXP(Perks.MetalWelding, 20);
end

function Recipe.OnGiveXP.ElectricityMetalwork25(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Electricity, 25);
    player:getXp():AddXP(Perks.MetalWelding, 25);
end

Give5ELECMWXP = Recipe.OnGiveXP.ElectricityMetalwork5
Give10ELECMWXP = Recipe.OnGiveXP.ElectricityMetalwork10
Give15ELECMWXP = Recipe.OnGiveXP.ElectricityMetalwork15
Give20ELECMWXP = Recipe.OnGiveXP.ElectricityMetalwork20
Give25ELECMWXP = Recipe.OnGiveXP.ElectricityMetalwork25