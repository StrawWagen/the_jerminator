
local newEvent = {
    defaultPercentChancePerMin = 0.01,

    doesDedicationProgression = true,
    navmeshEvent = true,
    variants = {
        {
            variantName = "chanceJermaMeeting",
            getIsReadyFunc = nil,
            minDedication = 0,
            maxDedication = 4,
            overrideChance = 25, -- chance to override other events, this goes from top to bottom
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminator_scared",
                    spawnAlgo = "steppedRandomRadius",
                    deleteAfterMeet = true,
                    timeout = true, -- if bot has no enemy for this long, despawns em, true means it sets to the default, 30 min

                }
            },
            thinkInterval = nil, -- makes it default to terminator_Extras.activeEventThinkInterval
            concludeOnMeet = true,
        },
        {
            variantName = "chanceAngryJermaMeeting",
            getIsReadyFunc = nil,
            minDedication = 2,
            maxDedication = 6,
            overrideChance = 25,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "steppedRandomRadius",
                    deleteAfterMeet = true,
                    timeout = true,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "smallScoutedJermaGroupMeet",
            getIsReadyFunc = nil,
            minDedication = 4,
            maxDedication = 8,
            overrideChance = 25,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "steppedRandomRadius",
                    scout = true, -- halts the spawning until this guy sees an enemy
                    timeout = true,

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "steppedRandomRadiusNearby",
                    repeats = 1,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "largeScoutedJermaGroupMeet",
            getIsReadyFunc = nil,
            minDedication = 6,
            maxDedication = 16,
            overrideChance = 25,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "steppedRandomRadius",
                    scout = true,
                    timeout = true,

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "teammateSpawn",
                    repeats = 4,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "vastScoutedJermaGroupMeet",
            getIsReadyFunc = nil,
            minDedication = 12,
            maxDedication = 24,
            overrideChance = 5,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "steppedRandomRadius",
                    scout = true,
                    timeout = true,

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "teammateSpawn",
                    repeats = 10,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "chanceJerma985Meeting", -- rare early ominous one
            getIsReadyFunc = nil,
            minDedication = 4,
            maxDedication = 24,
            overrideChance = 5,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminator_realistic",
                    spawnAlgo = "steppedRandomRadius",
                    deleteAfterMeet = true,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "chanceJerma98SIXMeeting", -- rare early invis one
            getIsReadyFunc = nil,
            minDedication = 8,
            maxDedication = 28,
            overrideChance = 2,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminatorwraith",
                    spawnAlgo = "steppedRandomRadius",
                    deleteAfterMeet = true,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "jerma985Meeting",
            getIsReadyFunc = nil,
            minDedication = 10,
            maxDedication = 40,
            overrideChance = 40,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminator_realistic",
                    spawnAlgo = "steppedRandomRadius",

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "smallScoutedJerma985GroupMeet",
            getIsReadyFunc = nil,
            minDedication = 14,
            maxDedication = 44,
            overrideChance = 25,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminator_realistic",
                    spawnAlgo = "steppedRandomRadius",
                    scout = true,
                    timeout = true,

                },
                {
                    class = "terminator_nextbot_jerminator_realistic",
                    spawnAlgo = "teammateSpawn",
                    repeats = 1,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
    }
}

terminator_Extras.RegisterEvent( newEvent, "jerma985" )

