
local jermaSpawnSet = {
    name = "jermas_glee_oneguy", -- unique name
    prettyName = "One Gleeful Jerma",
    description = "One of each Jerma. Never more.",
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
    chanceToBeVotable = 5,
    spawns = {
        {
            hardRandomChance = nil,
            name = "jerma_985_common",
            prettyName = "The Jerma985",
            class = "terminator_nextbot_jerminator_realistic",
            spawnType = "hunter",
            difficultyCost = { 50, 100 },
            countClass = "terminator_nextbot_jerminator*",
            maxCount = 1,
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 10, 20 },
            name = "jerma_98SIX_common",
            prettyName = "The Jerma986",
            class = "terminator_nextbot_jerminatorwraith",
            spawnType = "hunter",
            difficultyCost = { 50, 100 },
            countClass = "terminator_nextbot_jerminator*",
            maxCount = 1,
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 10, 20 },
            name = "jerma_98SEVEN_common",
            prettyName = "The Jerma987",
            class = "terminator_nextbot_jerminatorhuge",
            spawnType = "hunter",
            difficultyCost = { 50, 150 },
            countClass = "terminator_nextbot_jerminator*",
            maxCount = 1,
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 10, 20 },
            name = "jerma_98EIGHT_common",
            prettyName = "The Jerma988",
            class = "terminator_nextbot_jerminatorsmol",
            spawnType = "hunter",
            difficultyCost = { 10, 20 },
            countClass = "terminator_nextbot_jerminator*",
            maxCount = 1,
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 10, 20 },
            name = "jerma_98NINE_common",
            prettyName = "The Jerma989",
            class = "terminator_nextbot_jerminatorwide",
            spawnType = "hunter",
            difficultyCost = { 45, 120 },
            countClass = "terminator_nextbot_jerminator*",
            maxCount = 1,
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 10, 20 },
            name = "jerma_98NINETYONE_common",
            prettyName = "The Jerma991",
            class = "terminator_nextbot_jerminatorwizard",
            spawnType = "hunter",
            difficultyCost = { 45, 120 },
            countClass = "terminator_nextbot_jerminator*",
            maxCount = 1,
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 10, 20 },
            name = "jerma_99ZERO_common",
            prettyName = "The Jerma990",
            class = "terminator_nextbot_jerminatorstronk",
            spawnType = "hunter",
            difficultyCost = { 50, 145 },
            countClass = "terminator_nextbot_jerminator*",
            maxCount = 1,
            postSpawnedFuncs = nil,
        },
    }
}

table.insert( GLEE_SPAWNSETS, jermaSpawnSet )
