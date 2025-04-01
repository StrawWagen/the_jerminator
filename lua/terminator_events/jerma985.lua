
local newEvent = {
    defaultPercentChancePerMin = 0.1,

    doesDedicationProgression = true,
    navmeshEvent = true,
    variants = {
        {
            variantName = "chanceScaredJermaMeeting",
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
            variantName = "chanceJermaMeeting",
            getIsReadyFunc = nil,
            minDedication = 1,
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
            minDedication = 3,
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
                    timeout = true,
                    repeats = 1,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "largeScoutedJermaGroupMeet",
            getIsReadyFunc = nil,
            minDedication = 4,
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
                    timeout = true,
                    repeats = 5,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "vastScoutedJermaGroupMeet",
            getIsReadyFunc = nil,
            minDedication = 6,
            maxDedication = 24,
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
                    timeout = true,
                    repeats = 10,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "chanceJerma98EIGHT", -- rare early small guy
            getIsReadyFunc = nil,
            minDedication = 2,
            maxDedication = 24,
            overrideChance = 4,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminatorsmol",
                    spawnAlgo = "steppedRandomRadius",
                    timeout = true,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "chanceJerma98EIGHTGroup", -- rare early small group
            getIsReadyFunc = nil,
            minDedication = 4,
            maxDedication = 24,
            overrideChance = 2,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminatorsmol",
                    spawnAlgo = "steppedRandomRadius",
                    scout = true,
                    timeout = true,

                },
                {
                    class = "terminator_nextbot_jerminatorsmol",
                    spawnAlgo = "teammateSpawn",
                    timeout = true,
                    repeats = 4,

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
                    timeout = true,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "chanceJerma98SIXMeeting", -- rare early invis one
            getIsReadyFunc = nil,
            minDedication = 6,
            maxDedication = 40,
            overrideChance = 2,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminatorwraith",
                    spawnAlgo = "steppedRandomRadius",
                    deleteAfterMeet = true,
                    timeout = true,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "chanceJerma98SEVENMeeting", -- rare early big guy
            getIsReadyFunc = nil,
            minDedication = 7,
            maxDedication = 40,
            overrideChance = 2,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminatorhuge",
                    spawnAlgo = "steppedRandomRadius",
                    timeout = true,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "jerma985Meeting",
            getIsReadyFunc = nil,
            minDedication = 10,
            overrideChance = 40,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminator_realistic",
                    spawnAlgo = "steppedRandomRadius",
                    timeout = true,

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
                    timeout = true,
                    repeats = 1,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "mediumScoutedJerma985GroupMeet",
            getIsReadyFunc = nil,
            minDedication = 20,
            maxDedication = 60,
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
                    timeout = true,
                    repeats = 4,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "largeScoutedJerma985GroupMeet",
            getIsReadyFunc = nil,
            minDedication = 30,
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
                    timeout = true,
                    repeats = 8,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "jerma98SIXMeeting",
            getIsReadyFunc = nil,
            minDedication = 35,
            overrideChance = 15,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminatorwraith",
                    spawnAlgo = "steppedRandomRadius",
                    timeout = true,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "jerma98SEVENMeeting",
            getIsReadyFunc = nil,
            minDedication = 40,
            overrideChance = 15,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminatorhuge",
                    spawnAlgo = "steppedRandomRadius",
                    timeout = true,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "largeScoutedJerma98SIXGroupMeeting",
            getIsReadyFunc = nil,
            minDedication = 40,
            overrideChance = 5,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminatorwraith",
                    spawnAlgo = "steppedRandomRadius",
                    scout = true,
                    timeout = true,

                },
                {
                    class = "terminator_nextbot_jerminatorwraith",
                    spawnAlgo = "teammateSpawn",
                    timeout = true,
                    repeats = 8,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "massiveScoutedJermaGroupMeet",
            getIsReadyFunc = nil,
            minDedication = 40,
            overrideChance = 5,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminator_realistic",
                    spawnAlgo = "steppedRandomRadius",
                    scout = true,
                    timeout = true,

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "teammateSpawn",
                    timeout = true,
                    repeats = 20,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
        {
            variantName = "largeScoutedJerma98SEVENGroupMeeting",
            getIsReadyFunc = nil,
            minDedication = 45,
            overrideChance = 5,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminatorhuge",
                    spawnAlgo = "steppedRandomRadius",
                    scout = true,
                    timeout = true,

                },
                {
                    class = "terminator_nextbot_jerminatorhuge",
                    spawnAlgo = "teammateSpawn",
                    timeout = true,
                    repeats = 8,

                },
            },
            thinkInterval = nil,
            concludeOnMeet = true,
        },
    }
}

terminator_Extras.RegisterEvent( newEvent, "jerma985" )

