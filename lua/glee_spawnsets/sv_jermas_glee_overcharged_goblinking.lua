local function postSpawnedAlwaysOvercharge( _spawnDat, spawned )
    glee_Overcharge( spawned )

    local lightning = ents.Create( "glee_lightning" )
    lightning:SetOwner( spawned )
    lightning:SetPos( spawned:GetPos() )
    lightning:SetPowa( 12 )
    lightning:Spawn()
end

local followerHealth = 1 -- 1% of a goblin's 50, rounded up so they aren't born dead

local function postSpawnedFollower( _spawnDat, spawned )
    spawned.SpawnHealth = followerHealth
    spawned:SetMaxHealth( followerHealth )
    spawned:SetHealth( followerHealth )
end

local jermaSpawnSet = {
    name = "jermas_glee_overcharged_goblinking", -- unique name
    prettyName = "The Overcharged Goblin Jerma King",
    description = "All hail the king. ALL HAIL THE KING. ALL HAIL THE KING.",
    difficultyPerMin = "default", -- difficulty per minute
    waveInterval = "default", -- time between spawn waves
    diffBumpWhenWaveKilled = "default", -- when there's <= 1 hunter left, the difficulty is permanently bumped by this amount
    startingBudget = "default", -- so budget isnt 0
    spawnCountPerDifficulty = "default", -- max of ten at 10 minutes
    startingSpawnCount = "default",
    maxSpawnCount = "default",
    maxSpawnDist = "default",
    roundEndSound = "default",
    roundStartSound = "default",
    chanceToBeVotable = 0.25,
    spawns = {
        {
            name = "jerma_98EIGHT_king",
            prettyName = "The Overcharged Goblin Jerma King",
            class = "terminator_nextbot_jerminatorsmolking",
            spawnType = "hunter",
            difficultyCost = 1,
            countClass = "terminator_nextbot_jerminatorsmolking",
            minCount = { 1 },
            maxCount = { 1 },
            postSpawnedFuncs = { postSpawnedAlwaysOvercharge },
            isBoss = true,
        },
        {
            name = "jerma_98EIGHT_follower",
            prettyName = "A Goblin Jerma Follower",
            class = "terminator_nextbot_jerminatorsmol",
            spawnType = "hunter",
            difficultyCost = { 25, 50 }, -- very few of these guys
            countClass = "terminator_nextbot_jerminatorsmol",
            postSpawnedFuncs = { postSpawnedFollower },
        },
    }
}

table.insert( GLEE_SPAWNSETS, jermaSpawnSet )
