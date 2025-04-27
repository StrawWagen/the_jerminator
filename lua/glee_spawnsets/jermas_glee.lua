
if game.IsDedicated() then
    RunConsoleCommand( "jerminator_dynamic_content", 1 )

end

local jermaSpawnSet = {
    name = "jermas_glee", -- unique name
    prettyName = "Jerma's Glee",
    description = "Meet Jerma!",
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
    spawns = {
        {
            hardRandomChance = nil,
            name = "jerma_scared", -- unique name
            prettyName = "A Jerma",
            class = "terminator_nextbot_jerminator_scared", -- class spawned
            spawnType = "hunter",
            difficultyCost = { 5 },
            countClass = "terminator_nextbot_jerminator*", -- class COUNTED
            minCount = 1,
            maxCount = { 2 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = nil,
            name = "jerma_normal",
            prettyName = "A Jerma",
            class = "terminator_nextbot_jerminator",
            spawnType = "hunter",
            difficultyCost = { 10, 20 },
            countClass = "terminator_nextbot_jerminator*",
            maxCount = { 5 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 2, 6 }, -- !!! chance this is even checked
            name = "jerma_985_rareearly",
            prettyName = "A Jerma985",
            class = "terminator_nextbot_jerminator_realistic",
            spawnType = "hunter",
            difficultyCost = { 15, 35 },
            countClass = "terminator_nextbot_jerminator*",
            maxCount = { 8 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = nil,
            name = "jerma_985_common",
            prettyName = "A Jerma985",
            class = "terminator_nextbot_jerminator_realistic",
            spawnType = "hunter",
            difficultyCost = { 50, 100 },
            countClass = "terminator_nextbot_jerminator*",
            maxCount = { 8 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 1, 4 },
            name = "jerma_98SIX_rareearly",
            prettyName = "A Jerma986",
            class = "terminator_nextbot_jerminatorwraith",
            spawnType = "hunter",
            difficultyCost = { 25, 50 },
            countClass = "terminator_nextbot_jerminatorwraith",
            maxCount = { 1 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 10, 20 },
            name = "jerma_98SIX_common",
            prettyName = "A Jerma986",
            class = "terminator_nextbot_jerminatorwraith",
            spawnType = "hunter",
            difficultyCost = { 50, 100 },
            countClass = "terminator_nextbot_jerminator*",
            maxCount = { 4 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 1, 4 },
            name = "jerma_98SEVEN_rareearly",
            prettyName = "A Jerma987",
            class = "terminator_nextbot_jerminatorhuge",
            spawnType = "hunter",
            difficultyCost = { 25, 50 },
            countClass = "terminator_nextbot_jerminatorhuge",
            maxCount = { 1 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 10, 20 },
            name = "jerma_98SEVEN_common",
            prettyName = "A Jerma987",
            class = "terminator_nextbot_jerminatorhuge",
            spawnType = "hunter",
            difficultyCost = { 50, 150 },
            countClass = "terminator_nextbot_jerminator*",
            maxCount = { 10 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 1, 4 },
            name = "jerma_98EIGHT_rareearly",
            prettyName = "A Jerma988",
            class = "terminator_nextbot_jerminatorsmol",
            spawnType = "hunter",
            difficultyCost = { 25, 50 },
            countClass = "terminator_nextbot_jerminatorsmol",
            maxCount = { 1 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 10, 20 },
            name = "jerma_98EIGHT_common",
            prettyName = "A Jerma988",
            class = "terminator_nextbot_jerminatorsmol",
            spawnType = "hunter",
            difficultyCost = { 10, 20 },
            countClass = "terminator_nextbot_jerminator*",
            maxCount = { 15 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 11, 23 },
            name = "jerma_98NINE_common",
            prettyName = "A Jerma989",
            class = "terminator_nextbot_jerminatorwide",
            spawnType = "hunter",
            difficultyCost = { 75, 175 },
            countClass = "terminator_nextbot_jerminatorwide",
            maxCount = { 10 },
            postSpawnedFuncs = nil,
        },
    }
}

table.insert( GLEE_SPAWNSETS, jermaSpawnSet )
