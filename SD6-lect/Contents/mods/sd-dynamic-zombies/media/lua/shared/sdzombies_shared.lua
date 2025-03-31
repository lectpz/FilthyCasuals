--
SDRandomZombies = {}
local Lib = SDRandomZombies

local SPEED_SPRINTER = 1
local SPEED_FAST_SHAMBLER = 2
local SPEED_SHAMBLER = 3

local COGNITION_SMART = 1
local COGNITION_DEFAULT = 3
local COGNITION_RANDOM = 4

local HEARING_PINPOINT = 1
local HEARING_NORMAL = 2

function Lib.findField(o, fname)
    for i = 0, getNumClassFields(o) - 1 do
        local f = getClassField(o, i)
        if tostring(f) == fname then
            return f
        end
    end
end

function Lib.findFields(o)
	local cogField, speedField, hearField
    for i = 0, getNumClassFields(o) - 1 do
        local f = getClassField(o, i)
		local fString = tostring(f)
        if fString == "public int zombie.characters.IsoZombie.cognition" then
            cogField = f
		elseif fString == "public int zombie.characters.IsoZombie.speedType" then
            speedField = f
		elseif fString == "public int zombie.characters.IsoZombie.hearing" then
            hearField = f
        end
		if cogField and speedField and hearField then break end
    end
	return cogField, speedField, hearField
end

-- NOTE: we implement our own since
-- % operator doesn't work with big numbers, confirm with 2^37%100 and 2^38%100
local function modulo(a, b)
    return a - math.floor(a / b) * b
end

local function shiftRight(a, shift)
    return math.floor(a / (2^shift))
end

local p = 16 -- we want 2^p bits
local maxValue = 2 ^ p -- OnlineID defined as a short as of 41.71
local two_32 = 2 ^ 32
local function hash(x)
    x = modulo(x * 2654435769, two_32)
    return shiftRight(x, 32 - p)
end

local function zombieID(zombie)
    local id = zombie:getOnlineID()
    if id < 0 then
        id = modulo(zombie:hashCode(), maxValue)
    end

    return hash(id)
end

local function hashToSlice(h)
    return math.floor((h / maxValue) * 10000)
end

-- -----------------------------------------------------------------------------
-- Globals and state

local function shouldBeStanding(z)
    -- leg break, head bash, vehicle hit: isKnockedDown
    -- randomized vehicle stories: wasFakeDead / crawlerType = 1
    -- fakeDead: wasFakeDead
    -- Kate and Baldspot: crawlerType = 1
    -- createhorde2command: isKnockedDown / crawlerType = 1
    --
    -- Note that isKnockedDown and crawlerType are not transferred on the network
    -- so not reliable when generated by server for client-owned state like knockedDown

    return not z:isKnockedDown() and z:getCrawlerType() == 0 and not z:wasFakeDead()
end

local sandboxOpts = getSandboxOptions()
local function updateSpeedAndHearing(zombie, targetSpeed, actualSpeed, targetHearing, actualHearing)

    if actualSpeed ~= targetSpeed or actualHearing ~= targetHearing then

        sandboxOpts:set("ZombieLore.Speed", targetSpeed)
        sandboxOpts:set("ZombieLore.Hearing", targetHearing)
        zombie:makeInactive(true)
        zombie:makeInactive(false)
        sandboxOpts:set("ZombieLore.Speed", SPEED_FAST_SHAMBLER)
        sandboxOpts:set("ZombieLore.Hearing", HEARING_NORMAL)

    end

end

local function updateCognition(zombie, targetCognition, actualCognition)
	
	if actualCognition ~= targetCognition then

		sandboxOpts:set("ZombieLore.Cognition", targetCognition)
		zombie:DoZombieStats()
		sandboxOpts:set("ZombieLore.Cognition", COGNITION_DEFAULT)

	end

end

local function updateZombie(zombie, speedType, cognition, hearing)
    -- IsoZombie::Hit(Vehicle...) suggests that stagger, knockdown and crawling
    -- states are managed by client

    -- IsoZombie::hitConsequences(Vehicle...) suggests that knockdown
    -- states is managed by client && !remote

    -- see also:
    -- IsoZombie::resetForReuse/0
    -- IsoZombie::shouldBecomeCrawler/0
    -- VirtualZombieManager::createRealZombieAlways/3

    local modData = zombie:getModData()
	local speedTypeVal = getClassFieldVal(zombie, speedType)
    local cognitionVal = getClassFieldVal(zombie, cognition)
    local hearingVal = getClassFieldVal(zombie, hearing)
    local crawlingVal = zombie:isCrawling()
    local square = zombie:getCurrentSquare()
    local squareXVal = square and square:getX() or 0
    local squareYVal = square and square:getY() or 0
	
	local zombieAttackedBy = zombie:getAttackedBy()

    -- NOTE(belette) we have to include X and Y in the check to catch zombies that have been recycled
    -- from _intended_ default state (i.e. RZ happened to assign it to default bucket) to _unintended_
    -- default state (i.e. RZ would not assign it to the default bucket, even though it's the same zombie)
    -- see IsoZombie::resetForReuse and VirtualZombieManager::createRealZombieAlways for more info
						   
--lect
	local tier, zone, x, y, control, toxic, sprinterValue, pinpointValue, cognitionValue, healthValue = checkZoneAtXY(squareXVal, squareYVal)
	if zone == "Unnamed Zone" then zone = "Default" end
	distributionZone, distributionLocal, distributionHearing, distributionCognition = zone, 100 * sprinterValue, 100 * pinpointValue, 100 * cognitionValue

    local shouldSkip = speedTypeVal == modData.SDspeed and cognitionVal == modData.SDcog and hearingVal ==
                           modData.SDhearing and crawlingVal == modData.SDcrawl and math.abs(squareXVal - modData.SDx) <=
                           50 and math.abs(squareYVal - modData.SDy) <= 50 and zombie:getHealth() == healthValue
	
	local zombieSprinterZoneValue = modData.SDSprinterZoneValue or nil
	local zombieSprinterZone = modData.SDSprinterZone or nil
	local zombieCognitionValue = modData.SDCognitionValue or nil
--lect
    -- NOTE(belette) we check for square to avoid crash in Java engine postupdate calls later
    if shouldSkip or (not square) then
		if zombieSprinterZoneValue and zombieSprinterZone then
			if zombieSprinterZoneValue == sprinterValue then
				return true
			end
		end
    end
	
    local zid = zombieID(zombie)
    local slice = hashToSlice(zid)

    if slice < 0 then
        slice = 0
    end

    if distributionLocal <= 100 then distributionLocal = 0 end

    local targetSpeed = (slice < distributionLocal) and SPEED_SPRINTER or SPEED_FAST_SHAMBLER
    local targetHearing = (slice < distributionHearing) and HEARING_PINPOINT or HEARING_NORMAL
	local targetCognition = (slice < distributionCognition) and COGNITION_SMART or COGNITION_DEFAULT

    updateSpeedAndHearing(zombie, targetSpeed, speedTypeVal, targetHearing, hearingVal)
	updateCognition(zombie, targetCognition, cognitionVal)
	
	if not zombieAttackedBy then
		zombie:setHealth(healthValue)
	end

    if zombie:isCrawling() and shouldBeStanding(zombie) then
        zombie:toggleCrawling()
        zombie:setCanWalk(true);
    end
	
	modData.SDspeed = getClassFieldVal(zombie, speedType)
    modData.SDcog = getClassFieldVal(zombie, cognition)
    modData.SDhearing = getClassFieldVal(zombie, hearing)
    modData.SDcrawl = zombie:isCrawling()
    modData.SDx = squareXVal
    modData.SDy = squareYVal
	modData.SDSprinterZone = distributionZone
	modData.SDSprinterZoneValue = sprinterValue
	modData.SDCognitionValue = cognitionValue
	modData.SDhealthValue = zombie:getHealth()

end

local tick = 0
local tickMax = 1
local function updateAllZombies()
	tick = tick + 1
	if tick > tickMax then
		local startTime = getTimestampMs()
		sandboxOpts = getSandboxOptions()
		local zs = getCell():getZombieList()
		local sz = zs:size()
		local bob = IsoZombie.new(nil)	
		local cognition, speedType, hearing = Lib.findFields(bob)
		local client = isClient()
		for i = 0, sz - 1 do
			local z = zs:get(i)
			if not (client and z:isRemoteZombie()) then
				updateZombie(z, speedType, cognition, hearing)
			end
		end
		local timeElapsed = getTimestampMs() - startTime
		print("[sdLogger] It took " .. timeElapsed .. "ms to complete zombie update for " .. sz .. " zombies!")
		tick = 0
		if timeElapsed > 1500 then 
			tickMax = 6
		elseif timeElapsed > 1250 then 
			tickMax = 5
		elseif timeElapsed > 1000 then 
			tickMax = 4
		elseif timeElapsed > 750 then 
			tickMax = 3
		elseif timeElapsed > 400 then 
			tickMax = 2
		else
			tickMax = 1
		end
		--sendServerCommand("SDRandomZombies", "updateAllZombies", nil)
	end
end
Events.EveryOneMinute.Add(updateAllZombies)
--if isServer() then Events.EveryOneMinute.Add(updateAllZombies) end


local Commands = {}
Commands.SDRandomZombies = {}

function Commands.SDRandomZombies.updateAllZombies()
	updateAllZombies()
end

local function onServerCommand(module, command, args)
    if Commands[module] and Commands[module][command] then
        Commands[module][command]()
    end
end
--if isClient() then Events.OnServerCommand.Add(onServerCommand) end