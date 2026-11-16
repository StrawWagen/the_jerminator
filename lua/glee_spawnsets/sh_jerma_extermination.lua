if game.IsDedicated() then
    RunConsoleCommand( "jerminator_dynamic_content", 1 )

end

local jermaSpawnSet = {
    name = "jerma_extermination", -- unique name
    prettyName = "EXJERMINATION",
    description = "You know what!? ITS OVER!",
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
            difficultyCost = { 1, 5 },
            countClass = "terminator_nextbot_jerminator*", -- class COUNTED
            minCount = 1,
            maxCount = { 3 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = nil,
            name = "jerma_normal",
            prettyName = "A Jerma",
            class = "terminator_nextbot_jerminator",
            spawnType = "hunter",
            difficultyCost = { 3, 6 },
            countClass = "terminator_nextbot_jerminator*",
            maxCount = { 10 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 0.2, 1 },
            name = "jerma_985_rareearly",
            prettyName = "A Jerma985",
            class = "terminator_nextbot_jerminator_realistic",
            spawnType = "hunter",
            difficultyCost = { 35, 65 },
            maxCount = { 1 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = nil,
            name = "jerma_985_common",
            prettyName = "A Jerma985",
            class = "terminator_nextbot_jerminator_realistic",
            spawnType = "hunter",
            difficultyCost = { 90, 115 },
            maxCount = { 3 },
            difficultyNeeded = { 100, 120 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 0.2, 1 },
            name = "jerma_98SIX_rareearly",
            prettyName = "A Jerma986",
            class = "terminator_nextbot_jerminatorwraith",
            spawnType = "hunter",
            difficultyCost = { 35, 65 },
            maxCount = { 1 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 10, 20 },
            name = "jerma_98SIX_common",
            prettyName = "A Jerma986",
            class = "terminator_nextbot_jerminatorwraith",
            spawnType = "hunter",
            difficultyCost = { 75, 100 },
            maxCount = { 5 },
            difficultyNeeded = { 75, 100 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 0.2, 1 },
            name = "jerma_98NINETYONE_rareearly",
            prettyName = "A Jerma991",
            class = "terminator_nextbot_jerminatorwizard",
            spawnType = "hunter",
            difficultyCost = { 35, 65 },
            maxCount = { 1 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 10, 20 },
            name = "jerma_98NINETYONE_common",
            prettyName = "A Jerma991",
            class = "terminator_nextbot_jerminatorwizard",
            spawnType = "hunter",
            difficultyCost = { 50, 80 },
            maxCount = { 4 },
            difficultyNeeded = { 50, 75 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 10, 20 },
            name = "jerma_98SEVEN_common",
            prettyName = "A Jerma987",
            class = "terminator_nextbot_jerminatorhuge",
            spawnType = "hunter",
            difficultyCost = { 175, 250 },
            maxCount = { 1 },
            difficultyNeeded = { 175, 250 },
            postSpawnedFuncs = nil,
            isBoss = true,
        },
        {
            hardRandomChance = { 0.2, 1 },
            name = "jerma_98EIGHT_rareearly",
            prettyName = "A Jerma988",
            class = "terminator_nextbot_jerminatorsmol",
            spawnType = "hunter",
            difficultyCost = { 35, 65 },
            maxCount = { 1 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 10, 20 },
            name = "jerma_98EIGHT_common",
            prettyName = "A Jerma988",
            class = "terminator_nextbot_jerminatorsmol",
            spawnType = "hunter",
            difficultyCost = { 10, 30 },
            maxCount = { 15 },
            difficultyNeeded = { 25, 40 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 0.2, 1 },
            name = "jerma_98NINE_rareearly",
            prettyName = "A Jerma989",
            class = "terminator_nextbot_jerminatorwide",
            spawnType = "hunter",
            difficultyCost = { 35, 65 },
            maxCount = { 1 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 11, 23 },
            name = "jerma_98NINE_common",
            prettyName = "A Jerma989",
            class = "terminator_nextbot_jerminatorwide",
            spawnType = "hunter",
            difficultyCost = { 35, 65 },
            maxCount = { 6 },
            difficultyNeeded = { 50, 70 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 0.2, 1 },
            name = "jerma_99ZERO_rareearly",
            prettyName = "A Jerma990",
            class = "terminator_nextbot_jerminatorstronk",
            spawnType = "hunter",
            difficultyCost = { 35, 65 },
            maxCount = { 1 },
            postSpawnedFuncs = nil,
        },
        {
            hardRandomChance = { 10, 20 },
            name = "jerma_99ZERO_common",
            prettyName = "A Jerma990",
            class = "terminator_nextbot_jerminatorstronk",
            spawnType = "hunter",
            difficultyCost = { 65, 185 },
            maxCount = { 2 },
            difficultyNeeded = { 135, 165 },
            postSpawnedFuncs = nil,
        },
    }
}

    table.Merge( set, setSv )

end

function set:Activate()
    local setHelpers = GAMEMODE.setHelpers
    setHelpers.makeHardcore( self )

    if CLIENT then return end

    setHelpers.setBaseRole( self, "swatGrunt" )

    setHelpers.addRoleVariant( self, "medic" )
    setHelpers.addRoleVariant( self, "tank" )
    setHelpers.addRoleVariant( self, "sniper" )

end


table.insert( GLEE_SPAWNSETS, jermaSpawnSet )
