RunConsoleCommand( "jerminator_dynamic_content", 1 )

local jermaSpawnSet = {
    name = "jermas_glee_wraith", -- unique name
    prettyName = "Wraith Jermas",
    description = "Lots of cloaking Jerma986",
    difficultyPerMin = "default", -- difficulty per minute
    waveInterval = "default", -- time between spawn waves
    diffBumpWhenWaveKilled = "default", -- when there's <= 1 hunter left, the difficulty is permanently bumped by this amount
    startingBudget = "default", -- so budget isnt 0
    spawnCountPerDifficulty = "default", -- max of ten at 10 minutes
    startingSpawnCount = "default",
    maxSpawnCount = "default",
    spawns = {
        {
            name = "jerma_98SIX",
            prettyName = "A Jerma986",
            class = "terminator_nextbot_jerminatorwraith",
            spawnType = "hunter",
            difficultyCost = { 5, 10 },
            countClass = "terminator_nextbot_jerminatorwraith",
            minCount = { 2 },
            maxCount = { 10 },
            postSpawnedFuncs = nil,
        },
    }
}

table.insert( GLEE_SPAWNSETS, jermaSpawnSet )
