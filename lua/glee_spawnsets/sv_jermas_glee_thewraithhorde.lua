
local jermaSpawnSet = {
    name = "jermas_glee_thewraithhorde", -- unique name
    prettyName = "Jerma Wraithmageddon",
    description = "They're invisible, and amassing in spectactular numbers!",
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
    chanceToBeVotable = 1,
    spawns = {
        {
            name = "jerma_98SIX",
            prettyName = "A Jerma986",
            class = "terminator_nextbot_jerminatorwraith",
            spawnType = "hunter",
            difficultyCost = 0.1,
            countClass = "terminator_nextbot_jerminatorwraith",
            postSpawnedFuncs = nil,
        },
    }
}

table.insert( GLEE_SPAWNSETS, jermaSpawnSet )
