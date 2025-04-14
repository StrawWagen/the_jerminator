
if game.IsDedicated() then
    RunConsoleCommand( "jerminator_dynamic_content", 1 )

end

local jermaSpawnSet = {
    name = "jermas_glee_fat", -- unique name
    prettyName = "The Fat Jermas", -- fat albert
    description = "Jerma, but his width is accurate to real life.",
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
    chanceToBeVotable = 11,
    spawns = {
        {
            name = "jerma_98NINE",
            prettyName = "A Jerma989",
            class = "terminator_nextbot_jerminatorwide",
            spawnType = "hunter",
            difficultyCost = { 5, 10 },
            countClass = "terminator_nextbot_jerminatorwide",
            minCount = { 2 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = nil,
            name = "jerma_98EIGHT_common",
            prettyName = "The Jerma98EIGHT",
            class = "terminator_nextbot_jerminatorsmol",
            spawnType = "hunter",
            difficultyCost = { 50, 100 },
            countClass = "terminator_nextbot_jerminatorsmol",
            maxCount = { 1 },
            postSpawnedFuncs = nil,
        },
    }
}

table.insert( GLEE_SPAWNSETS, jermaSpawnSet )
