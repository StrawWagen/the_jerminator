
local genericJermCounter = "terminator_nextbot_jerminator*"

local spawnSet = {
    name = "jermas_glee_thehorde", -- unique name
    prettyName = "Jerma Overpopulation Crisis",
    description = "We need to do something about all these jermas!",
    difficultyPerMin = "default", -- difficulty per minute
    waveInterval = "default*0.25", -- time between spawn waves
    diffBumpWhenWaveKilled = "default", -- when there's <= 1 hunter left, the difficulty is permanently bumped by this amount
    startingBudget = 20, -- so budget isnt 0
    spawnCountPerDifficulty = { 1 }, -- go up fast pls
    startingSpawnCount = 15,
    maxSpawnCount = 30,
    roundEndSound = "the_jerminator/killed1shot/i_remain_long.mp3",
    roundEndSoundDSP = 133,
    roundStartSound = "the_jerminator/anger/random_sound2.mp3",
    roundStartSoundDSP = 133,
    chanceToBeVotable = 5,
    spawns = {
        {
            name = "jerma_scared_early",
            prettyName = "A Scared Jerma",
            class = "terminator_nextbot_jerminator_scared",
            spawnType = "hunter",
            difficultyCost = 0.1,
            difficultyStopAfter = { 30, 40 },
            countClass = genericJermCounter,
            minCount = { 4 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 5, 25 },
            name = "jerma_normal_RARE",
            prettyName = "A Jerma",
            class = "terminator_nextbot_jerminator",
            spawnType = "hunter",
            difficultyCost = { 2, 4 },
            difficultyStopAfter = { 30, 40 },
            countClass = genericJermCounter,
            postSpawnedFuncs = nil,
        },
        {
            name = "jerma_normal",
            prettyName = "A Jerma",
            class = "terminator_nextbot_jerminator",
            spawnType = "hunter",
            difficultyCost = 0.1,
            difficultyNeeded = { 25, 35 },
            countClass = genericJermCounter,
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 1, 3 },
            name = "jerma_smol_RARE", -- spawns early with a max count
            prettyName = "A Goblin Jerma",
            class = "terminator_nextbot_jerminatorsmol",
            spawnType = "hunter",
            difficultyCost = { 1, 4 },
            difficultyNeeded = { 50, 100 },
            countClass = "terminator_nextbot_jerminatorsmol",
            maxCount = { 4 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 2.5, 5 },
            name = "jerma_harder_RARE",
            prettyName = "A Jerma985",
            class = "terminator_nextbot_jerminator_realistic",
            spawnType = "hunter",
            difficultyCost = { 25, 50 },
            difficultyNeeded = { 25, 100 },
            countClass = "terminator_nextbot_jerminator_realistic",
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 0, 2 },
            name = "jerma_wraith_RARE",
            prettyName = "A jerma986",
            class = "terminator_nextbot_jerminatorwraith",
            spawnType = "hunter",
            difficultyCost = { 10, 20 },
            difficultyNeeded = { 10, 75 },
            countClass = "terminator_nextbot_jerminatorwraith",
            maxCount = { 2, 4 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 0, 2 },
            name = "jerma_big",
            prettyName = "A Jerma987",
            class = "terminator_nextbot_jerminatorhuge",
            spawnType = "hunter",
            difficultyCost = { 100, 150 },
            difficultyNeeded = { 100, 200 },
            countClass = "terminator_nextbot_jerminatorhuge",
            maxCount = { 1 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 0, 2 },
            name = "jerma_fat",
            prettyName = "A Fat Jerma",
            class = "terminator_nextbot_jerminatorwide",
            spawnType = "hunter",
            difficultyCost = { 150, 200 },
            difficultyNeeded = { 100, 200 },
            countClass = "terminator_nextbot_jerminatorwide",
            maxCount = { 1 },
            postSpawnedFuncs = nil,
        },
    }
}

table.insert( GLEE_SPAWNSETS, spawnSet )
