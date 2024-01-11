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
    if not SandboxVars.SDRandomZombies then
        error("no SDRandomZombies key in config")
    end

    if not (type(SandboxVars.SDRandomZombies.Louisville) == "number" and
        type(SandboxVars.SDRandomZombies.Default) == "number" and
        type(SandboxVars.SDRandomZombies.Muldraugh) == "number" and
        type(SandboxVars.SDRandomZombies.WestPoint) == "number" and
        type(SandboxVars.SDRandomZombies.Riverside) == "number" and
        type(SandboxVars.SDRandomZombies.Rosewood) == "number" and
        type(SandboxVars.SDRandomZombies.Petroville) == "number" and
        type(SandboxVars.SDRandomZombies.LakeIvy) == "number" and
        type(SandboxVars.SDRandomZombies.RavenCreek) == "number" and
        type(SandboxVars.SDRandomZombies.EerieCountry) == "number" and
        type(SandboxVars.SDRandomZombies.BigBearLake) == "number" and
        type(SandboxVars.SDRandomZombies.Chestown) == "number" and
        type(SandboxVars.SDRandomZombies.FortRedstone) == "number" and
        type(SandboxVars.SDRandomZombies.ResearchFacility) == "number" and
        type(SandboxVars.SDRandomZombies.Dirkerdam) == "number" and
        type(SandboxVars.SDRandomZombies.LC) == "number" and
        type(SandboxVars.SDRandomZombies.LCBunker) == "number" and
        type(SandboxVars.SDRandomZombies.LCDowntown) == "number" and
        type(SandboxVars.SDRandomZombies.PinpointDefault) == "number" and
        type(SandboxVars.SDRandomZombies.PinpointLouisville) == "number" and
        type(SandboxVars.SDRandomZombies.PinpointFortRedstone) == "number" and
        type(SandboxVars.SDRandomZombies.PinpointResearchFacility) == "number" and
        type(SandboxVars.SDRandomZombies.PinpointDirkerdam) == "number" and
        type(SandboxVars.SDRandomZombies.PinpointMuldraugh) == "number" and
        type(SandboxVars.SDRandomZombies.PinpointWestPoint) == "number" and
        type(SandboxVars.SDRandomZombies.PinpointRiverside) == "number" and
        type(SandboxVars.SDRandomZombies.PinpointRosewood) == "number" and
        type(SandboxVars.SDRandomZombies.PinpointMarchRidge) == "number" and
        type(SandboxVars.SDRandomZombies.PinpointPetroville) == "number" and
        type(SandboxVars.SDRandomZombies.PinpointLakeIvy) == "number" and
        type(SandboxVars.SDRandomZombies.PinpointRavenCreek) == "number" and
        type(SandboxVars.SDRandomZombies.PinpointEerieCountry) == "number" and
        type(SandboxVars.SDRandomZombies.PinpointBigBearLake) == "number" and
        type(SandboxVars.SDRandomZombies.PinpointChestown) == "number" and
        type(SandboxVars.SDRandomZombies.PinpointLC) == "number" and
        type(SandboxVars.SDRandomZombies.PinpointLCBunker) == "number" and
        type(SandboxVars.SDRandomZombies.PinpointLCDowntown) == "number" and
        type(SandboxVars.SDRandomZombies.PinpointCC) == "number") then
        error("config value is not a number")
    end

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

local function updateSpeedAndHearing(zombie, targetSpeed, actualSpeed, targetHearing, actualHearing)
    local didChange = false

    if actualSpeed ~= targetSpeed or actualHearing ~= targetHearing then
        getSandboxOptions():set("ZombieLore.Speed", targetSpeed)
        getSandboxOptions():set("ZombieLore.Hearing", targetHearing)
        zombie:makeInactive(true)
        zombie:makeInactive(false)
        getSandboxOptions():set("ZombieLore.Speed", SPEED_FAST_SHAMBLER)
        getSandboxOptions():set("ZombieLore.Hearing", HEARING_NORMAL)
        didChange = true
    end

    return didChange
end

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
                           20 and math.abs(squareYVal - modData.SDy) <= 20

    -- NOTE(belette) we check for square to avoid crash in Java engine postupdate calls later
    if shouldSkip or (not square) then
        return true
    end

    local zid = zombieID(zombie)
    local slice = hashToSlice(zid)

    if slice < 0 then
        slice = 0
    end

    if squareXVal >= 11700 and squareYVal >= 900 and squareXVal < 15000 and squareYVal < 6600 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.Louisville
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointLouisville
    elseif squareXVal >= 11100 and squareYVal >= 8700 and squareXVal < 11400 and squareYVal < 9300 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.CC
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointCC
    elseif squareXVal >= 9900 and squareYVal >= 8400 and squareXVal < 12300 and squareYVal < 11400 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.Muldraugh
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointMuldraugh
    elseif squareXVal >= 9900 and squareYVal >= 6300 and squareXVal < 12900 and squareYVal < 7800 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.WestPoint
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointWestPoint
    elseif squareXVal >= 5400 and squareYVal >= 5100 and squareXVal < 7800 and squareYVal < 6300 then -- Riverside
        distributionLocal = 100 * SandboxVars.SDRandomZombies.Riverside
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointRiverside
    elseif squareXVal >= 7500 and squareYVal >= 10800 and squareXVal < 9300 and squareYVal < 12600 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.Rosewood
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointRosewood
    elseif squareXVal >= 9600 and squareYVal >= 12300 and squareXVal < 10500 and squareYVal < 13500 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.MarchRidge
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointMarchRidge
    elseif squareXVal >= 10500 and squareYVal >= 11400 and squareXVal < 11400 and squareYVal < 13500 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.Petroville
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointPetroville
    elseif squareXVal >= 8700 and squareYVal >= 9300 and squareXVal < 9600 and squareYVal < 10800 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.LakeIvy
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointLakeIvy
    elseif squareXVal >= 5400 and squareYVal >= 11700 and squareXVal < 6000 and squareYVal < 12300 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.FortRedstone
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointFortRedstone
    elseif squareXVal >= 5400 and squareYVal >= 12300 and squareXVal < 6000 and squareYVal < 12900 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.ResearchFacility
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointResearchFacility
    elseif squareXVal >= 3000 and squareYVal >= 11100 and squareXVal < 6000 and squareYVal < 13500 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.RavenCreek
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointRavenCreek
    elseif squareXVal >= 7200 and squareYVal >= 13500 and squareXVal < 12300 and squareYVal < 18300 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.EerieCountry
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointEerieCountry
    elseif squareXVal >= 4800 and squareYVal >= 6900 and squareXVal < 6900 and squareYVal < 8400 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.BigBearLake
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointBigBearLake
    elseif squareXVal >= 4500 and squareYVal >= 6600 and squareXVal < 4800 and squareYVal < 6900 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.Chestown
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointChestown
    elseif squareXVal >= 17700 and squareYVal >= 6300 and squareXVal < 18300 and squareYVal < 6900 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.LCBunker
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointLCBunker
    -- elseif squareXVal >= 15900 and squareYVal >= 6300 and squareXVal < 16200 and squareYVal < 6600 then -- DX bunker: hardcoded
    --     distributionLocal = 100 * SandboxVars.SDRandomZombies.LCBunker
    --     distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointLCBunker
    elseif squareXVal >= 17100 and squareYVal >= 6300 and squareXVal < 17700 and squareYVal < 6900 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.LCDowntown
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointLCDowntown
    elseif squareXVal >= 15000 and squareYVal >= 6300 and squareXVal < 18300 and squareYVal < 8100 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.LC
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointLC
    elseif squareXVal >= 1500 and squareYVal >= 1800 and squareXVal < 3000 and squareYVal < 3300 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.Dirkerdam
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointDirkerdam
    elseif squareXVal >= 3000 and squareYVal >= 1800 and squareXVal < 7500 and squareYVal < 6900 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.Dirkerdam
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointDirkerdam
    elseif squareXVal >= 7500 and squareYVal >= 1800 and squareXVal < 9300 and squareYVal < 6900 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.Dirkerdam
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointDirkerdam
    elseif squareXVal >= 9300 and squareYVal >= 2400 and squareXVal < 10500 and squareYVal < 6300 then
        distributionLocal = 100 * SandboxVars.SDRandomZombies.Dirkerdam
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointDirkerdam
    else
        distributionLocal = 100 * SandboxVars.SDRandomZombies.Default
        distributionHearing = 100 * SandboxVars.SDRandomZombies.PinpointDefault
    end

    if distributionLocal <= 100 then distributionLocal = 0 end

    local targetSpeed = (slice < distributionLocal) and SPEED_SPRINTER or SPEED_FAST_SHAMBLER
    local targetHearing = (slice < distributionHearing) and HEARING_PINPOINT or HEARING_NORMAL

    -- local function updateSpeedAndHearing(zombie, targetSpeed, actualSpeed, targetHearing, actualHearing)
    updateSpeedAndHearing(zombie, targetSpeed, speedTypeVal, targetHearing, hearingVal)

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

    -- return shouldSkip
    return false
end

local tickFrequency = 10
local lastTicks = {16, 16, 16, 16, 16}
local lastTicksIdx = 1
local last = getTimestampMs()
local tickCount = 0
local function updateAllZombies()
    tickCount = tickCount + 1
    if tickCount % tickFrequency ~= 1 then
        return
    end
    tickCount = 1

    local now = getTimestampMs()
    local diff = now - last
    last = now

    local tickMs = diff / tickFrequency
    lastTicks[lastTicksIdx] = tickMs
    lastTicksIdx = (lastTicksIdx % 5) + 1
    local totalTicks = 0
    local sumTicks = 0
    for _, v in ipairs(lastTicks) do
        sumTicks = sumTicks + v
        totalTicks = totalTicks + 1
    end

    local avgTickMs = sumTicks / totalTicks
    -- NOTE: needs to be at least 2 for modulo check to pass
    tickFrequency = math.max(2, math.ceil(SDZ_UPDATE_FREQUENTY / avgTickMs))

    local zs = getCell():getZombieList()
    local sz = zs:size()

    -- Lib.time("update_" .. sz, function ()
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
    -- end)
end

function Lib.enable()
    local prevTickMs = lastTicks[((lastTicksIdx + 3) % 5) + 1]
    last = getTimestampMs() - prevTickMs * tickCount
    Events.OnTick.Add(updateAllZombies)
end

function Lib.disable()
    Events.OnTick.Remove(updateAllZombies)
end

Lib.enable()
