local function postSpawnedAlwaysOvercharge( spawnDat, spawned )
    glee_Overcharge( spawned )

    local lightning = ents.Create( "glee_lightning" )
    lightning:SetOwner( spawned )
    lightning:SetPos( spawned:GetPos() )
    lightning:SetPowa( 12 )
    lightning:Spawn()
end

local jermaBossSet = {
    name = "jermas_glee_onebigguy_overcharged", -- unique name
    prettyName = "The Thunderstruck Gargantuan Jerma",
    description = "Survive against a overcharged tall jerma...",
    difficultyPerMin = "default", -- difficulty per minute
    waveInterval = "default", -- time between spawn waves
    diffBumpWhenWaveKilled = "default", -- when there's <= 1 hunter left, the difficulty is permanently bumped by this amount
    startingBudget = "default", -- so budget isnt 0
    spawnCountPerDifficulty = "default", -- max of ten at 10 minutes
    startingSpawnCount = 1,
    maxSpawnCount = 1,
    maxSpawnDist = { 2500, 4500 },
    roundEndSound = "default",
    roundStartSound = "default",
    roundEarlyStartSound = "default",
    chanceToBeVotable = 1,
    spawns = {
        {
            name = "jerma_98SEVEN",
            prettyName = "The Overcharged Jerma987",
            class = "terminator_nextbot_jerminatorhuge",
            spawnType = "hunter",
            difficultyCost = 1,
            countClass = "terminator_nextbot_jerminator*",
            maxCount = { 1 },
            postSpawnedFuncs = { postSpawnedAlwaysOvercharge }, -- raaugh im so blue!
        },
    }
}

table.insert( GLEE_SPAWNSETS, jermaBossSet )