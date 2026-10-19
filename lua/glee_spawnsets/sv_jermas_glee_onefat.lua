
local jermaSpawnSet = {
    name = "jermas_glee_onefat", -- unique name
    prettyName = "The Fat Jerma",
    description = "He's here, he's big, and he's HUNGRY!",
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
    easy = true,
    spawns = {
        {
            name = "jerma_98NINE",
            prettyName = "The Fat Jerma",
            class = "terminator_nextbot_jerminatorwide",
            spawnType = "hunter",
            difficultyCost = 1,
            countClass = "terminator_nextbot_jerminator*",
            maxCount = { 1 },
            postSpawnedFuncs = nil,
            isBoss = true,
        },
    }
}

table.insert( GLEE_SPAWNSETS, jermaSpawnSet )
