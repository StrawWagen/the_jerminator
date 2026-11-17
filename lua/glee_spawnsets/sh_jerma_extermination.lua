local jermaSpawnSet = {
    name = "jerma_extermination",
    prettyName = "EXJERMINATION",
    description = "You know what!? ITS OVER!",
    difficultyPerMin = "jermas_glee", 
    waveInterval = "jermas_glee",
    diffBumpWhenWaveKilled = "jermas_glee", 
    startingBudget = "jermas_glee", 
    spawnCountPerDifficulty = "jermas_glee", 
    startingSpawnCount = "jermas_glee",
    maxSpawnCount = "jermas_glee",
    maxSpawnDist = "jermas_glee",
    roundEndSound = "the_jerminator/killed1shot/And just like that he was never heard from again.mp3",
    roundStartSound = "the_jerminator/anger/How many shots does it take until you get to the center of a god damm soldier that_s what I want to know.mp3",
    chanceToBeVotable = 2,
    spawns = {
        {
            hardRandomChance = { 10, 20 },
            name = "jerma_98SEVEN_boss",
            prettyName = "The Jerma987",
            class = "terminator_nextbot_jerminatorhuge",
            spawnType = "hunter",
            difficultyCost = { 175, 250 },
            maxCount = { 1 },
            difficultyNeeded = { 175, 250 },
            postSpawnedFuncs = nil,
            isBoss = true,
        },
    },
     -- the jermas from jermas glee
        importedMiserySpawns = {
            {
                name = "jermas_glee",
                overrides = {
                    jerma_scared = NULL,
                    jerma_normal = NULL,
                    jerma_985_rareearly = NULL,
                    jerma_985_common = NULL,
                    jerma_98SIX_rareearly = NULL,
                    jerma_98SIX_common = NULL,
                    jerma_98NINETYONE_rareearly = NULL,
                    jerma_98NINETYONE_common = NULL,
                    jerma_98EIGHT_rareearly = NULL,
                    jerma_98EIGHT_common = NULL,
                    jerma_98NINE_rareearly = NULL,
                    jerma_98NINE_common = NULL,
                    jerma_99ZERO_rareearly = NULL,
                    jerma_99ZERO_common = NULL,

                    },
                },
            },
}

function jermaSpawnSet:Activate()
    local setHelpers = GAMEMODE.setHelpers
    setHelpers.makeHardcore( self )

    if CLIENT then return end

    setHelpers.setBaseRole( self, "swatGrunt" )

    setHelpers.addRoleVariant( self, "medic" )
    setHelpers.addRoleVariant( self, "tank" )
    setHelpers.addRoleVariant( self, "sniper" )

end


table.insert( GLEE_SPAWNSETS, jermaSpawnSet )
