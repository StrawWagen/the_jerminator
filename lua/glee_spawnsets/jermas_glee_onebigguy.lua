
local jermaSpawnSet = {
    name = "jermas_glee_onebigguy", -- unique name
    prettyName = "The One and Only Jerma987",
    description = "Just one Jerma987. That's it.",
    difficultyPerMin = "default", -- difficulty per minute
    waveInterval = "default", -- time between spawn waves
    diffBumpWhenWaveKilled = "default", -- when there's <= 1 hunter left, the difficulty is permanently bumped by this amount
    startingBudget = "default", -- so budget isnt 0
    spawnCountPerDifficulty = "default", -- max of ten at 10 minutes
    startingSpawnCount = 1,
    maxSpawnCount = 1,
    maxSpawnDist = { 4500, 6500 },
    roundEndSound = "default",
    roundStartSound = "default",
    chanceToBeVotable = 2.5,
    spawns = {
        {
            name = "jerma_98SEVEN",
            prettyName = "The Jerma987",
            class = "terminator_nextbot_jerminatorhuge",
            spawnType = "hunter",
            difficultyCost = 1,
            countClass = "terminator_nextbot_jerminator*",
            postSpawnedFuncs = nil,
        },
    }
}

table.insert( GLEE_SPAWNSETS, jermaSpawnSet )
