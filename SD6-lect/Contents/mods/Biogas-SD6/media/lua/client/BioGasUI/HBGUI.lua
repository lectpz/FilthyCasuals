BioGasMenu = BioGasMenu or {}
BioGasMenu._index = BioGasMenu

local rGood, gGood, bGood = 0,1,0
local rBad, gBad, bBad = 0,1,0
local richGood, richBad, richNeutral = " <RGB:0,1,0> ", " <RGB:1,0,0> ", " <RGB:1,1,1> "

if getCore().getGoodHighlitedColor then
	local good = getCore():getGoodHighlitedColor()
	local bad = getCore():getBadHighlitedColor()
	rGood, gGood, bGood, rBad, gBad, bBad = good:getR(), good:getG(), good:getB(), bad:getR(), bad:getG(), bad:getB()
	richGood, richBad = string.format(" <RGB:%.2f,%.2f,%.2f> ",rGood, gGood, bGood), string.format(" <RGB:%.2f,%.2f,%.2f> ",rBad, gBad, bBad)
end

local function plungeBiowaste (worlobjects,player,homebiogas)
	local character = getSpecificPlayer(player)
		if luautils.walkAdj(character, homebiogas:getSquare(), true) then
			ISTimedActionQueue.add(HBGPlungeBiowaste:new(character, homebiogas))
		end
end

local function siphonMethane (worlobjects,player,homebiogas,tank)
	local character = getSpecificPlayer(player)
	if luautils.walkAdj(character, homebiogas:getSquare(), true) then
		ISTimedActionQueue.add(ISWalkToTimedAction:new(character,homebiogas:getSquare():getS()))
		ISTimedActionQueue.add(HBGSiphonMethane:new(character, homebiogas, tank))
	end
end

local function drainFertilizer (worlobjects,player,homebiogas,bucket)
	local character = getSpecificPlayer(player)
		if luautils.walkAdj(character, homebiogas:getSquare(), true) then
			ISTimedActionQueue.add(ISUnequipAction:new(character, bucket, 10));
			ISTimedActionQueue.add(HBGDrainFertilizer:new(character, homebiogas, bucket))
		end
end

BioGasMenu.createMenuEntries = function(player, context, worldobjects, test)
	if test and ISWorldObjectContextMenu.Test then return true end

	local homebiogas

	for _,obj in ipairs(worldobjects) do
		local spritename = obj:getSprite() and obj:getSprite():getName()
		if spritename == "biogas_tileset_01_0" then
			homebiogas = obj
		end
	end

	if homebiogas then
		local square = homebiogas:getSquare()
		if test then return ISWorldObjectContextMenu.setTest() end
		local BioGasMenu = context:addOption(getText("ContextMenu_BioGas_BioGasUnit"), worldobjects);
		local BioGasSubMenu = ISContextMenu:getNew(context);
		context:addSubMenu(BioGasMenu, BioGasSubMenu);

		if test then return ISWorldObjectContextMenu.setTest() end
		BioGasSubMenu:addOption(getText("ContextMenu_BioGas_GasUnitStatus"), worldobjects, BioGasStatusWindow.OnOpenPanel, square, player)

		local biowaste = homebiogas:getModData()["biowaste"]

		if biowaste < SandboxVars.BioGas.MaxBiowaste and CBioGasSystem:getIsoObjectOnSquare(square):getContainer():getItems():size() > 0 then
			if test then return ISWorldObjectContextMenu.setTest() end
			BioGasSubMenu:addOption(getText("ContextMenu_BioGas_PlungeFunnel"), worldobjects, plungeBiowaste, player, homebiogas)
		end

		local methane = homebiogas:getModData()["methane"]
		local tank = BioGasUtilities.getPropaneTankNotFull(getSpecificPlayer(player))

		if methane > 0 and tank ~= nil then
			if test then return ISWorldObjectContextMenu.setTest() end
			BioGasSubMenu:addOption(getText("ContextMenu_BioGas_SiphonPropane"), worldobjects, siphonMethane, player, homebiogas, tank)
		end

		local fertilizer = homebiogas:getModData()["fertilizer"]
		local bucket = BioGasUtilities.getBucketNotFull(getSpecificPlayer(player))

		if fertilizer > 0 and bucket ~= nil then
			if test then return ISWorldObjectContextMenu.setTest() end
			BioGasSubMenu:addOption(getText("ContextMenu_BioGas_PickupFertilizer"), worldobjects, drainFertilizer, player, homebiogas, bucket)
		end
	end

end

function BioGasMenu.getRGB()
	return rGood, gGood, bGood, rBad, gBad, bBad
end

function BioGasMenu.getRGBRich()
	return richGood, richBad, richNeutral
end

BioGasFixedGetText = function(getTextString)
	local text = getText(getTextString)
	text = string.gsub(text, '\\n', '\n')
	return text
end

Events.OnFillWorldObjectContextMenu.Add(BioGasMenu.createMenuEntries)