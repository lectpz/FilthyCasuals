--
local Lib = SDRandomZombies

local SDZ_UPDATE_FREQUENTY = 1000
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

function Lib.makeDistribution()
    local distribution = {}
    distribution.Crawler = 0
    distribution.Shambler = 0
    distribution.FastShambler = 50
    -- distribution.Shambler + math.floor(100 * SandboxVars.SDRandomZombies.FastShambler)
    distribution.Sprinter = 50
    -- distribution.FastShambler + math.floor(100 * SandboxVars.SDRandomZombies.Sprinter)

    distribution.Fragile = 0
    distribution.NormalTough = 100
    distribution.Tough = 0
    distribution.Smart = 0

    return distribution
end

-- NOTE: we implement our own since
-- % operator doesn't work with big numbers, confirm with 2^37%100 and 2^38%100
local function modulo(a, b)
    return a - math.floor(a / b) * b
end

local function shiftRight(a, b)
    while a > 0 and b > 0 do
        a = math.floor(a / 2)
        b = b - 1
    end
    return a
end

local p = 16 -- we want 2^p bits
local maxValue = 2 ^ p -- OnlineID defined as a short as of 41.71
local two_32 = 2 ^ 32
local function hash(x)
    -- (x*2654435769 % 2^32) >> (32 - p)
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
-- Perf and diagnostics

function Lib.time(tag, fn)
    local timestamp = getTimestampMs()

    fn()

    DebugLog.log(string.format("SDRandomZombies.%s: %dms", tag, getTimestampMs() - timestamp))
end

local callCounts = {};
local startMs = getTimestampMs();

function Lib.z(id)
    if id == -1 then
        DebugContextMenu.selectedZombie = nil
    elseif id then
        local zs = getCell():getZombieList()
        for i = 0, zs:size() - 1 do
            local z = zs:get(i)
            if zombieID(z) == id then
                DebugContextMenu.selectedZombie = z
            end
        end
    end

    local z = DebugContextMenu.selectedZombie
    if not z then
        return
    end

    z:dressInNamedOutfit("TutorialDad")
    z:resetModelNextFrame()

    DebugContextMenu.OnSelectedZombieWalk(getPlayer():getSquare())

    local distribution = Lib.makeDistribution()
    local cognition = Lib.findField(IsoZombie.new(nil), "public int zombie.characters.IsoZombie.cognition")
    local speedType = Lib.findField(IsoZombie.new(nil), "public int zombie.characters.IsoZombie.speedType")

    local zid = zombieID(z)
    local slice = hashToSlice(zid)
    local slicename
    if slice < distribution.Crawler then
        slicename = "Crawler"
    elseif slice < distribution.Shambler then
        slicename = "Shambler"
    elseif slice < distribution.FastShambler then
        slicename = "FastShambler"
    else
        slicename = "Sprinter"
    end

    local hh = hash(zid)
    local slice2 = hashToSlice(hh)
    local slice2name
    if slice2 < distribution.Smart then
        slice2name = "Smart"
    else
        slice2name = "Normal"
    end

    local hhh = hash(hh)
    local slice3 = hashToSlice(hhh)
    local slice3name
    if slice3 < distribution.Fragile then
        slice3name = "Fragile"
    elseif slice3 < distribution.NormalTough then
        slice3name = "NormalTough"
    else
        slice3name = "Tough"
    end

    local l = DebugLog.log
    local f = string.format
    l(f('zombieID: %s', tostring(zombieID(z))))
    l(f('hashCode: %s', tostring(z:hashCode())))
    l(f('onlineID: %s', tostring(z:getOnlineID())))
    l(f('isRemoteZombie: %s', tostring(z:isRemoteZombie())))
    l(f('slice: %s (%d)', slicename, slice))
    l(f('slice2: %s (%d)', slice2name, slice2))
    l(f('slice3: %s (%d)', slice3name, slice3))
    l(f('health: %.2f', z:getHealth()))
    l(f('cognition: %d', getClassFieldVal(z, cognition)))
    l(f('speedType: %d', getClassFieldVal(z, speedType)))
    l(f('isKnockedDown: %s', tostring(z:isKnockedDown())))
    l(f('wasFakeDead: %s', tostring(z:wasFakeDead())))
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
    local didChange = false

    if actualSpeed ~= targetSpeed or actualHearing ~= targetHearing then
		--local sandboxOpts = getSandboxOptions()
        sandboxOpts:set("ZombieLore.Speed", targetSpeed)
        sandboxOpts:set("ZombieLore.Hearing", targetHearing)
        zombie:makeInactive(true)
        zombie:makeInactive(false)
        sandboxOpts:set("ZombieLore.Speed", SPEED_FAST_SHAMBLER)
        sandboxOpts:set("ZombieLore.Hearing", HEARING_NORMAL)
        didChange = true
    end

    return didChange
end

local function updateCognition(zombie, targetCognition, actualCognition)
	local didChange = false
	
	if actualCognition ~= targetCognition then
		--print(targetCognition)
		didChange = true
		sandboxOpts:set("ZombieLore.Cognition", targetCognition)
		zombie:DoZombieStats()
		sandboxOpts:set("ZombieLore.Cognition", COGNITION_DEFAULT)
		--print("changed cognition")
	end
	return didChange
end

local function SDDistribution(zone, sprinterValue, pinpointValue, cognitionValue)
	d_Local = 100 * sprinterValue--* SandboxVars.SDRandomZombies[zone]
	d_Hearing = 100 * pinpointValue--* SandboxVars.SDRandomZombies["Pinpoint" .. zone]
	d_Zone = zone
	d_Cog = 100 * cognitionValue
	return d_Local, d_Hearing, d_Zone, d_Cog
end
--lect

local function updateZombie(zombie, distribution, speedType, cognition, hearing)
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

    -- NOTE(belette) we have to include X and Y in the check to catch zombies that have been recycled
    -- from _intended_ default state (i.e. RZ happened to assign it to default bucket) to _unintended_
    -- default state (i.e. RZ would not assign it to the default bucket, even though it's the same zombie)
    -- see IsoZombie::resetForReuse and VirtualZombieManager::createRealZombieAlways for more info
    local shouldSkip = speedTypeVal == modData.SDspeed and cognitionVal == modData.SDcog and hearingVal ==
                           modData.SDhearing and crawlingVal == modData.SDcrawl and math.abs(squareXVal - modData.SDx) <=
                           35 and math.abs(squareYVal - modData.SDy) <= 35
						   
--lect
	local tier, zone, x, y, control, toxic, sprinterValue, pinpointValue, cognitionValue = checkZoneAtXY(squareXVal, squareYVal)
	if zone == "Unnamed Zone" then zone = "Default" end
	distributionZone, distributionLocal, distributionHearing, distributionCognition = zone, 100 * sprinterValue, 100 * pinpointValue, 100 * cognitionValue
	
	local zombieSprinterZoneValue = modData.SDSprinterZoneValue or nil --call the modData for sprinterzone % associated with the zombie, or nil if it doesn't exist. if it does exist, its because it was written at the end of updateZombie
	local zombieSprinterZone = modData.SDSprinterZone or nil --call the modData for sprinterzone name associated with the zombie, or nil if it doesn't exist. if it does exist, its because it was written at the end of updateZombie
	local zombieCognitionValue = modData.SDCognitionValue or nil --call the modData for sprinterzone name associated with the zombie, or nil if it doesn't exist. if it does exist, its because it was written at the end of updateZombie
--lect
    -- NOTE(belette) we check for square to avoid crash in Java engine postupdate calls later
    if shouldSkip or (not square) then
		if zombieSprinterZoneValue and zombieSprinterZone then--and zombieCognitionValue then
			if zombieSprinterZoneValue == sprinterValue then--and zombieCognitionValue == cognitionValue then--lect
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
	--lect
	local targetCognition = (slice < distributionCognition) and COGNITION_SMART or COGNITION_DEFAULT
	--lect

    -- local function updateSpeedAndHearing(zombie, targetSpeed, actualSpeed, targetHearing, actualHearing)
    updateSpeedAndHearing(zombie, targetSpeed, speedTypeVal, targetHearing, hearingVal)
	updateCognition(zombie, targetCognition, cognitionVal)
	
	if not zombie:getAttackedBy() then
		zombie:setHealth(2.1)
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
	modData.SDSprinterZone = distributionZone--log the sprinterzone name
	modData.SDSprinterZoneValue = sprinterValue--sandbox zone sprinter %
	modData.SDCognitionValue = cognitionValue--sandbox zone sprinter %

    return false
end

local function updateAllZombies()
	sandboxOpts = getSandboxOptions()
	local zs = getCell():getZombieList()
	local sz = zs:size()
	local distribution = Lib.makeDistribution()
	local bob = IsoZombie.new(nil)
	local cognition = Lib.findField(bob, "public int zombie.characters.IsoZombie.cognition")
	local speedType = Lib.findField(bob, "public int zombie.characters.IsoZombie.speedType")
	local hearing = Lib.findField(bob, "public int zombie.characters.IsoZombie.hearing")
	local client = isClient()
	for i = 0, sz - 1 do
		local z = zs:get(i)
		if not (client and z:isRemoteZombie()) then
			updateZombie(z, distribution, speedType, cognition, hearing)
		end
	end
end

Events.EveryOneMinute.Add(updateAllZombies)