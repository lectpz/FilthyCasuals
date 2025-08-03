local originalGrowPotato = farming_vegetableconf.growPotato
farming_vegetableconf.growPotato = function(planting, nextGrowing, updateNbOfGrow)
  local nbOfGrow = planting.nbOfGrow
  local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl)
  local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl)

  if (nbOfGrow == 6) then
	if(water >= 0 and diseaseLvl >= 0) then
		planting.nextGrowing = calcNextGrowing(nextGrowing, 48*5);
		planting:setObjectName(farming_vegetableconf.getObjectName(planting))
		planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		planting.hasVegetable = true;
		planting.hasSeed = true;
	else
		badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
	end
  else
    return originalGrowPotato(planting, nextGrowing, updateNbOfGrow)
  end

  return planting
end

local originalGrowCabbage = farming_vegetableconf.growCabbage
farming_vegetableconf.growCabbage = function(planting, nextGrowing, updateNbOfGrow)
  local nbOfGrow = planting.nbOfGrow
  local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl)
  local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl)

  if (nbOfGrow == 6) then
	if(water >= 0 and diseaseLvl >= 0) then
		planting.nextGrowing = calcNextGrowing(nextGrowing, 48*5);
		planting:setObjectName(farming_vegetableconf.getObjectName(planting))
		planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		planting.hasVegetable = true;
		planting.hasSeed = true;
	else
		badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
	end
  else
    return originalGrowPotato(planting, nextGrowing, updateNbOfGrow)
  end

  return planting
end
