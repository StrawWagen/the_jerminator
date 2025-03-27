
local newEvent = {
    percentChancePerMinCvarName = "jerminator_event_chance",
    defaultPercentChancePerMin = 1,

    dedicationInfoNum = "cl_jerminator_familiarity",
    navmeshEvent = true,
    variants = {
        {
            eventName = "chanceJermaMeeting",
            getIsReadyFunc = nil,
            minDedication = 0,
            maxDedication = 4,
            overrideChance = 25, -- chance to override other events
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminator_scared",
                    spawnAlgo = "steppedRandomRadius",
                    deleteAfterMeet = true,

                }
            },
            thinkInterval = thinkInt,
            concludeOnMeet = true,
        },
        {
            eventName = "chanceAngryJermaMeeting",
            getIsReadyFunc = nil,
            dedicationInfoNum = "cl_jerminator_familiarity",
            minDedication = 2,
            maxDedication = 6,
            overrideChance = 25,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "steppedRandomRadius",
                    deleteAfterMeet = true,

                },
            },
            thinkInterval = thinkInt,
            concludeOnMeet = true,
        },
        {
            eventName = "smallScoutedJermaGroupMeet",
            getIsReadyFunc = nil,
            dedicationInfoNum = "cl_jerminator_familiarity",
            minDedication = 4,
            maxDedication = 8,
            overrideChance = 25,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "steppedRandomRadius",
                    scout = true, -- halts the spawning until this guy sees an enemy

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "steppedRandomRadiusNearby",

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "steppedRandomRadiusNearby",

                },
            },
            thinkInterval = thinkInt,
            concludeOnMeet = true,
        },
        {
            eventName = "largeScoutedJermaGroupMeet",
            getIsReadyFunc = nil,
            dedicationInfoNum = "cl_jerminator_familiarity",
            minDedication = 6,
            maxDedication = 16,
            overrideChance = 25,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "steppedRandomRadius",
                    scout = true,

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "teammateSpawn",

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "teammateSpawn",

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "teammateSpawn",

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "teammateSpawn",

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "teammateSpawn",

                },
            },
            thinkInterval = thinkInt,
            concludeOnMeet = true,
        },
        {
            eventName = "vastScoutedJermaGroupMeet",
            getIsReadyFunc = nil,
            dedicationInfoNum = "cl_jerminator_familiarity",
            minDedication = 12,
            maxDedication = 24,
            overrideChance = 5,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "steppedRandomRadius",
                    scout = true,

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "teammateSpawn",

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "teammateSpawn",

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "teammateSpawn",

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "teammateSpawn",

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "teammateSpawn",

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "teammateSpawn",

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "teammateSpawn",

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "teammateSpawn",

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "teammateSpawn",

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "teammateSpawn",

                },
                {
                    class = "terminator_nextbot_jerminator",
                    spawnAlgo = "teammateSpawn",

                },
            },
            thinkInterval = thinkInt,
            concludeOnMeet = true,
        },
        {
            eventName = "chanceJerma985Meeting", -- rare early ominous one
            getIsReadyFunc = nil,
            dedicationInfoNum = "cl_jerminator_familiarity",
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
            thinkInterval = thinkInt,
            concludeOnMeet = true,
        },
        {
            eventName = "chanceJerma98SIXMeeting", -- rare early invis one
            getIsReadyFunc = nil,
            dedicationInfoNum = "cl_jerminator_familiarity",
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
            thinkInterval = thinkInt,
            concludeOnMeet = true,
        },
        {
            eventName = "jerma985Meeting",
            getIsReadyFunc = nil,
            dedicationInfoNum = "cl_jerminator_familiarity",
            minDedication = 10,
            maxDedication = 40,
            overrideChance = 40,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminator_realistic",
                    spawnAlgo = "steppedRandomRadius",

                },
            },
            thinkInterval = thinkInt,
            concludeOnMeet = true,
        },
        {
            eventName = "smallScoutedJerma985GroupMeet",
            getIsReadyFunc = nil,
            dedicationInfoNum = "cl_jerminator_familiarity",
            minDedication = 14,
            maxDedication = 44,
            overrideChance = 25,
            unspawnedStuff = {
                {
                    class = "terminator_nextbot_jerminator_realistic",
                    spawnAlgo = "steppedRandomRadius",
                    scout = true,

                },
                {
                    class = "terminator_nextbot_jerminator_realistic",
                    spawnAlgo = "teammateSpawn",

                },
                {
                    class = "terminator_nextbot_jerminator_realistic",
                    spawnAlgo = "teammateSpawn",

                },
            },
            thinkInterval = thinkInt,
            concludeOnMeet = true,
        },
    }
}

terminator_Extras.AddEvent( newEvent, "jerma985" )