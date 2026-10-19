
local jermaSpawnSet = {
    name = "jermas_glee_goblinking", -- unique name
    prettyName = "The Goblin Jerma King",
    description = "All hail the Goblin Jerma King.",
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
    chanceToBeVotable = 1,
    spawns = {
        {
            name = "jerma_98EIGHT_king",
            prettyName = "The Goblin Jerma King",
            class = "terminator_nextbot_jerminatorsmolking",
            spawnType = "hunter",
            difficultyCost = 1,
            countClass = "terminator_nextbot_jerminatorsmolking",
            maxCount = { 1 },
            postSpawnedFuncs = nil,
            isBoss = true,
        },
    }
}

table.insert( GLEE_SPAWNSETS, jermaSpawnSet )
