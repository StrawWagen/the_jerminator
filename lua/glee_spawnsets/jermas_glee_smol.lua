
if game.IsDedicated() then
    RunConsoleCommand( "jerminator_dynamic_content", 1 )

end

local jermaSpawnSet = {
    name = "jermas_glee_smol", -- unique name
    prettyName = "Vertically Challenged Jermas",
    description = "Jerma, but his height is accurate to real life.",
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
    chanceToBeVotable = 10,
    spawns = {
        {
            name = "jerma_98EIGHT",
            prettyName = "A Jerma988",
            class = "terminator_nextbot_jerminatorsmol",
            spawnType = "hunter",
            difficultyCost = { 5, 10 },
            countClass = "terminator_nextbot_jerminatorsmol",
            minCount = { 2 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = nil,
            name = "jerma_985_common",
            prettyName = "The Jerma985", -- the leader
            class = "terminator_nextbot_jerminator_realistic",
            spawnType = "hunter",
            difficultyCost = { 50, 100 },
            countClass = "terminator_nextbot_jerminator*",
            maxCount = { 1 },
            postSpawnedFuncs = nil,
        },
    }
}

table.insert( GLEE_SPAWNSETS, jermaSpawnSet )
