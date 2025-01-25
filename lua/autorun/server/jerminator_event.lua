
AddCSLuaFile( "autorun/client/jerminator_event.lua" )

local defaultEventChance = 0.8
local eventChanceVar = CreateConVar( "jerminator_event_chance", -1, FCVAR_ARCHIVE, "% Chance for a jerma985 event to start every minute. -1 for default, " .. defaultEventChance, -1, 100 )
local eventChance

local function doEventChance()
    eventChance = eventChanceVar:GetFloat()
    if eventChance <= -1 then
        eventChance = defaultEventChance

    end
end

doEventChance()
cvars.AddChangeCallback( "jerminator_event_chance", function() doEventChance() end, "localvar" )

JERMINATOR_TBL = JERMINATOR_TBL or {}


local function getFirstPly()
    return Entity( 1 )

end
local function aPlyIsLoaded()
    local firstPly = getFirstPly()
    if not IsValid( firstPly ) then return end
    if not firstPly:IsPlayer() then return end
    if not firstPly.GetShootPos then return end

    return true

end
local function getDedication( varName )
    if not aPlyIsLoaded() then return 0 end
    return getFirstPly():GetInfoNum( varName, 0 )

end


local timerName = "terminator_eventroll"
timer.Create( timerName, 60, 0, function()
    local haveNav = navmesh.GetNavAreaCount() > 0
    local pickedEvent
    local typeResults = {}

    for _, event in ipairs( JERMINATOR_TBL.events ) do
        if event.navmeshEvent and not haveNav then continue end
        local eventsType = event.eventType
        if JERMINATOR_TBL.activeEvents[eventsType] then continue end

        local result = typeResults[eventsType] -- so like an entire type can be enabled/blocked in one place
        if result == nil then -- no result yet
            result = JERMINATOR_TBL.groupCheckFuncs[eventsType]()
            typeResults[eventsType] = result

        end
        if result == false then -- this type's function returned false
            continue

        end

        if event.getIsReadyFunc and not event.getIsReadyFunc() then continue end
        if event.dedicationInfoNum then
            local dedication = getDedication( event.dedicationInfoNum )
            if dedication < event.minDedication then continue end
            if dedication > event.maxDedication then continue end

            if not pickedEvent then
                pickedEvent = event

            elseif math.Rand( 0, 100 ) < event.overrideChance then
                pickedEvent = event

            end
        end
    end

    if not pickedEvent then return end

    JERMINATOR_TBL.startEvent( pickedEvent )

end )


JERMINATOR_TBL.activeEvents = JERMINATOR_TBL.activeEvents or {}

JERMINATOR_TBL.groupCheckFuncs = {
    ["jerma985"] = function()
        local rand = math.Rand( 0, 100 )
        print( rand, eventChance )
        return rand < eventChance

    end,
}

local thinkInt = 0.1

JERMINATOR_TBL.events = {
    {
        eventName = "chanceJermaMeeting",
        eventType = "jerma985",
        navmeshEvent = true,
        getIsReadyFunc = nil,
        dedicationInfoNum = "cl_jerminator_familiarity",
        minDedication = 0,
        maxDedication = 4,
        overrideChance = 25, -- chance to override other events
        unspawnedStuff = {
            {
                class = "terminator_nextbot_jerminator_scared",
                spawnAlgo = "steppedRandomRadius",
                deleteAfterMeet = true,

            }
        },
        thinkInterval = thinkInt,
        concludeOnMeet = true,
    },
    {
        eventName = "chanceAngryJermaMeeting",
        eventType = "jerma985",
        navmeshEvent = true,
        getIsReadyFunc = nil,
        dedicationInfoNum = "cl_jerminator_familiarity",
        minDedication = 2,
        maxDedication = 6,
        overrideChance = 25,
        unspawnedStuff = {
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "steppedRandomRadius",
                deleteAfterMeet = true,

            },
        },
        thinkInterval = thinkInt,
        concludeOnMeet = true,
    },
    {
        eventName = "smallScoutedJermaGroupMeet",
        eventType = "jerma985",
        navmeshEvent = true,
        getIsReadyFunc = nil,
        dedicationInfoNum = "cl_jerminator_familiarity",
        minDedication = 4,
        maxDedication = 8,
        overrideChance = 25,
        unspawnedStuff = {
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "steppedRandomRadius",
                scout = true, -- halts the spawning until this guy sees an enemy

            },
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "steppedRandomRadiusNearby",

            },
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "steppedRandomRadiusNearby",

            },
        },
        thinkInterval = thinkInt,
        concludeOnMeet = true,
    },
    {
        eventName = "largeScoutedJermaGroupMeet",
        eventType = "jerma985",
        navmeshEvent = true,
        getIsReadyFunc = nil,
        dedicationInfoNum = "cl_jerminator_familiarity",
        minDedication = 6,
        maxDedication = 16,
        overrideChance = 25,
        unspawnedStuff = {
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "steppedRandomRadius",
                scout = true,

            },
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "teammateSpawn",

            },
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "teammateSpawn",

            },
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "teammateSpawn",

            },
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "teammateSpawn",

            },
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "teammateSpawn",

            },
        },
        thinkInterval = thinkInt,
        concludeOnMeet = true,
    },
    {
        eventName = "vastScoutedJermaGroupMeet",
        eventType = "jerma985",
        navmeshEvent = true,
        getIsReadyFunc = nil,
        dedicationInfoNum = "cl_jerminator_familiarity",
        minDedication = 12,
        maxDedication = 24,
        overrideChance = 5,
        unspawnedStuff = {
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "steppedRandomRadius",
                scout = true,

            },
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "teammateSpawn",

            },
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "teammateSpawn",

            },
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "teammateSpawn",

            },
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "teammateSpawn",

            },
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "teammateSpawn",

            },
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "teammateSpawn",

            },
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "teammateSpawn",

            },
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "teammateSpawn",

            },
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "teammateSpawn",

            },
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "teammateSpawn",

            },
            {
                class = "terminator_nextbot_jerminator",
                spawnAlgo = "teammateSpawn",

            },
        },
        thinkInterval = thinkInt,
        concludeOnMeet = true,
    },
    {
        eventName = "chanceJerma985Meeting", -- rare early ominous one
        eventType = "jerma985",
        navmeshEvent = true,
        getIsReadyFunc = nil,
        dedicationInfoNum = "cl_jerminator_familiarity",
        minDedication = 4,
        maxDedication = 24,
        overrideChance = 5,
        unspawnedStuff = {
            {
                class = "terminator_nextbot_jerminator_realistic",
                spawnAlgo = "steppedRandomRadius",
                deleteAfterMeet = true,

            },
        },
        thinkInterval = thinkInt,
        concludeOnMeet = true,
    },
    {
        eventName = "chanceJerma98SIXMeeting", -- rare early invis one
        eventType = "jerma985",
        navmeshEvent = true,
        getIsReadyFunc = nil,
        dedicationInfoNum = "cl_jerminator_familiarity",
        minDedication = 8,
        maxDedication = 28,
        overrideChance = 2,
        unspawnedStuff = {
            {
                class = "terminator_nextbot_jerminatorwraith",
                spawnAlgo = "steppedRandomRadius",
                deleteAfterMeet = true,

            },
        },
        thinkInterval = thinkInt,
        concludeOnMeet = true,
    },
    {
        eventName = "jerma985Meeting",
        eventType = "jerma985",
        navmeshEvent = true,
        getIsReadyFunc = nil,
        dedicationInfoNum = "cl_jerminator_familiarity",
        minDedication = 10,
        maxDedication = 40,
        overrideChance = 40,
        unspawnedStuff = {
            {
                class = "terminator_nextbot_jerminator_realistic",
                spawnAlgo = "steppedRandomRadius",

            },
        },
        thinkInterval = thinkInt,
        concludeOnMeet = true,
    },
    {
        eventName = "smallScoutedJerma985GroupMeet",
        eventType = "jerma985",
        navmeshEvent = true,
        getIsReadyFunc = nil,
        dedicationInfoNum = "cl_jerminator_familiarity",
        minDedication = 14,
        maxDedication = 44,
        overrideChance = 25,
        unspawnedStuff = {
            {
                class = "terminator_nextbot_jerminator_realistic",
                spawnAlgo = "steppedRandomRadius",
                scout = true,

            },
            {
                class = "terminator_nextbot_jerminator_realistic",
                spawnAlgo = "teammateSpawn",

            },
            {
                class = "terminator_nextbot_jerminator_realistic",
                spawnAlgo = "teammateSpawn",

            },
        },
        thinkInterval = thinkInt,
        concludeOnMeet = true,
    },
}

function JERMINATOR_TBL.startEvent( event )
    local oldCount = table.Count( JERMINATOR_TBL.activeEvents )
    local copy = table.Copy( event )

    copy.spawnedStuff = {}
    copy.spawnedNpcs = {}
    copy.participatingPlayers = {}

    JERMINATOR_TBL.activeEvents[event.eventType] = copy

    if oldCount > 0 then return end
    hook.Add( "Think", "terminator_eventsmanage", function()
        local returned = JERMINATOR_TBL.eventsManage()
        if returned == false then
            hook.Remove( "Think", "terminator_eventsmanage" )

        end
    end )
end

hook.Add( "PreCleanupMap", "terminator_resetevents", function()
    JERMINATOR_TBL.activeEvents = {}
end )

local function isOrphan( startArea, allAreas )
    local orphanCount = math.min( #allAreas, 150 )
    local open = { startArea }
    local openedIndex = {}
    local closedIndex = {}
    while #open > 0 and table.Count( closedIndex ) < orphanCount do
        local area = table.remove( open, 1 )
        for _, neighbor in ipairs( area:GetAdjacentAreas() ) do
            if openedIndex[neighbor] then continue end
            if closedIndex[neighbor] then continue end
            table.insert( open, neighbor )
            openedIndex[neighbor] = true

        end

        closedIndex[area] = true

    end
    if #open <= 0 then
        return true

    end
    return false

end

local spawnDist = 3000
local minSpawnDist = 1500

local function steppedRandomRadius( currToSpawn, plyCount, allAreas, maxRad )
    local maxCount = math.Clamp( 25 + -plyCount, 5, 25 )
    local currSpawnDist = spawnDist^2
    local currMaxSpawnDist
    if maxRad == math.huge then
        currMaxSpawnDist = maxRad

    else
        currMaxSpawnDist = ( maxRad + 4000 ) ^2

    end

    local spawnPos

    for _ = 1, maxCount do
        local randomArea = allAreas[math.random( 1, #allAreas )]
        if randomArea:IsUnderwater() and not currToSpawn.canSpawnUnderwater then maxCount = maxCount + 1 continue end

        local areasCenter = randomArea:GetCenter()
        local bad
        for _, ply in player.Iterator() do
            local distSqr = ply:GetShootPos():DistToSqr( areasCenter )
            if distSqr < currSpawnDist or distSqr > currMaxSpawnDist then
                bad = true
                break

            end
        end
        if bad then continue end
        if terminator_Extras.areaIsInterruptingSomeone( randomArea, areasCenter ) then continue end

        if isOrphan( randomArea, allAreas ) then continue end

        spawnPos = areasCenter

    end
    if not spawnPos then -- failed to find spot, let them spawn closer
        local newDist = spawnDist - ( maxCount * 25 )
        spawnDist = math.Clamp( newDist, minSpawnDist, maxRad )

    else
        local newDist = spawnDist + maxCount
        spawnDist = math.Clamp( newDist, minSpawnDist, maxRad )
        return spawnPos

    end
end

local function eventManage( event )
    local wait
    if event.scoutWaiting then
        local scout = event.scout
        wait = IsValid( scout ) and not scout.termEvent_HasMet

    end

    if #event.unspawnedStuff >= 1 and not wait then
        local plyCount = player.GetCount()
        local allAreas = navmesh.GetAllNavAreas()

        local spawnPos
        local currToSpawn = event.unspawnedStuff[1]
        local algo = currToSpawn.spawnAlgo
        if algo == "steppedRandomRadius" then
            spawnPos = steppedRandomRadius( currToSpawn, plyCount, allAreas, math.huge )

        elseif algo == "steppedRandomRadiusNearby" then
            spawnPos = steppedRandomRadius( currToSpawn, plyCount, allAreas, 4000 )

        elseif algo == "teammateSpawn" then
            local teammate = event.spawnedNpcs[math.random( 1, #event.spawnedNpcs )]
            if IsValid( teammate ) and teammate.GetShootPos then
                local stepHeight = teammate.loco:GetStepHeight()
                local teammateAreas = navmesh.Find( teammate:GetPos(), math.random( 2000, 5000 ), stepHeight, stepHeight )
                spawnPos = steppedRandomRadius( currToSpawn, plyCount, teammateAreas, 4000 )

            else
                spawnPos = steppedRandomRadius( currToSpawn, plyCount, allAreas, 4000 )

            end
        end
        if spawnPos then
            local toSpawn = table.remove( event.unspawnedStuff, 1 )

            local spawned = ents.Create( toSpawn.class )
            if not IsValid( spawned ) then return end -- :(
            spawned:SetPos( spawnPos )
            spawned:Spawn()

            table.insert( event.spawnedStuff, spawned )

            if spawned.GetShootPos then
                table.insert( event.spawnedNpcs, spawned )

                spawned.termEvent_DeleteAfterMeet = toSpawn.deleteAfterMeet
                if toSpawn.scout then
                    event.scout = spawned
                    event.scoutWaiting = true
                    spawned.termEvent_Scout = toSpawn.scout

                end

            end
        else
            return "wait"

        end
    else
        for ind, curr in ipairs( event.spawnedStuff ) do
            if not IsValid( curr ) then table.remove( event.spawnedStuff, ind ) break end
            local enemy = curr.IsSeeEnemy and curr:GetEnemy() or nil
            if enemy and enemy:IsPlayer() then
                event.participatingPlayers[enemy] = true
                curr.termEvent_HasMet = true
                curr.termEvent_MetRememberance = 200
                if event.concludeOnMeet then
                    event.concluded = true

                end
            elseif curr.termEvent_HasMet then
                if curr.termEvent_DeleteAfterMeet and curr.termEvent_MetRememberance <= 0 then
                    SafeRemoveEntity( curr )

                else
                    curr.termEvent_MetRememberance = curr.termEvent_MetRememberance + -1

                end
            end
        end

        -- all done!
        if #event.spawnedStuff <= 0 then return "done" end

    end
end

function onConcluded( event )
    local participatorCount = table.Count( event.participatingPlayers )
    if event.dedicationInfoNum and participatorCount > 0 then
        local bestDedication = 0
        for ply, _ in pairs( event.participatingPlayers ) do
            local theirDedication = ply:GetInfoNum( event.dedicationInfoNum, 0 )
            if theirDedication > bestDedication then
                bestDedication = theirDedication

            end
        end
        for ply, _ in pairs( event.participatingPlayers ) do
            ply:ConCommand( event.dedicationInfoNum .. " " .. bestDedication + 1 )

        end
    end
end

function JERMINATOR_TBL.eventsManage()
    local cur = CurTime()
    local managedCount = 0
    for eventType, event in pairs( JERMINATOR_TBL.activeEvents ) do
        managedCount = managedCount + 1
        local nextThink = event.nextThink or 0
        if nextThink > cur then continue end

        local returned = eventManage( event )
        if returned == "done" then
            if event.concluded then
                onConcluded( event )

            end
            JERMINATOR_TBL.activeEvents[eventType] = nil

        elseif returned == "wait" then
            event.nextThink = cur + ( event.thinkInterval * math.Rand( 10, 20 ) )

        end
    end
    if managedCount <= 0 then
        return false

    end
end