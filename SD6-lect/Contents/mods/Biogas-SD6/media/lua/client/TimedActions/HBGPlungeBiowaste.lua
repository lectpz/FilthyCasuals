require "TimedActions/ISBaseTimedAction"

HBGPlungeBiowaste = ISBaseTimedAction:derive("HBGPlungeBiowaste");

function HBGPlungeBiowaste:isValid()
    return self.homebiogas:getObjectIndex() ~= -1 and not self.homebiogas:getSquare():isInARoom()
end

function HBGPlungeBiowaste:start()
    self:setActionAnim("Loot")
	self.character:SetVariable("LootPosition", "Mid")
    self.character:reportEvent("EventLootItem")
end

function HBGPlungeBiowaste:waitToStart()
    self.character:faceThisObject(self.homebiogas)
    return self.character:shouldBeTurning()
end

function HBGPlungeBiowaste:update()
    self.character:faceThisObject(self.homebiogas)
end

function HBGPlungeBiowaste:stop()
    self.character:stopOrTriggerSound(self.sound)

    ISBaseTimedAction.stop(self);
end

function HBGPlungeBiowaste:perform()

    local maxWaste = SandboxVars.BioGas.MaxBiowaste
    local currentWaste = BioGasUtilities.findOnSquare(self.homebiogas:getSquare(),"biogas_tileset_01_0"):getModData().biowaste

    if self.homebiogas:getContainer():getAllCategory("Food"):size() > 0 then
        if not (currentWaste == maxWaste) then
            local biowastecontainer = self.homebiogas:getContainer()
            local foodList = biowastecontainer:getAllCategory("Food")
            
            if foodList:size() > 0 then
                for v=1,foodList:size() do
                    local item = foodList:get(v-1)
                    if currentWaste < maxWaste then
                        currentWaste = currentWaste + (item:getCalories() * SandboxVars.BioGas.CalorieMultiplier)
                        if item:getReplaceOnUse() then self.character:getInventory():AddItem(item:getReplaceOnUse()) end

                        if isClient() then
                            biowastecontainer:removeItemOnServer(item)
                        end

                        biowastecontainer:DoRemoveItem(item)
                    end
                end

                if currentWaste > maxWaste then
                    currentWaste = maxWaste
                end

                CBioGasSystem.instance:sendCommand(self.character,"plungeBiowaste", { { x = self.homebiogas:getX(), y = self.homebiogas:getY(), z = self.homebiogas:getZ() }, currentWaste})

                --biowastecontainer:requestSync()

                biowastecontainer:setDrawDirty(true)

                --ISInventoryPage.renderDirty = true
            end
        end
    else
        self.character:Say(getText("IGUI_BioGas_ContainerEmpty"))
    end

    ISBaseTimedAction.perform(self);
end

function HBGPlungeBiowaste:new(character, homebiogas)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.homebiogas = homebiogas
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.stopOnAim = false
    o.maxTime = (90 - (character:getPerkLevel(Perks.Farming) - 3) * 10) * 2 * getGameTime():getMinutesPerDay() / 10 --2 hours at level 3, ~half at level 10 --- temp /10
    if o.character:isTimedActionInstant() then
        o.maxTime = 1
    end
    return o;
end
