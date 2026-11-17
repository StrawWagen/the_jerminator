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
    importedMiserySpawns = {
        {
            name = "jermas_glee",
            overrides = {
                jerma_98SEVEN_rareearly = NULL,
                jerma_98SEVEN_common = { isBoss = true },
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
