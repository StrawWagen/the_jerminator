
local newEvent = {
    defaultPercentChancePerMin = 0.05,

    navmeshEvent = true,
    variants = {
        {
            variantName = "theButtonThatKillsYou",
            getIsReadyFunc = nil,
            unspawnedStuff = {
                {
                    class = "the_button_that_kills_you",
                    spawnAlgo = "steppedRandomRadius",
                    timeout = nil, -- defaults to 30 min

                }
            },
            thinkInterval = nil, -- makes it default to terminator_Extras.activeEventThinkInterval
            concludeOnMeet = true,
        },
    },
}

terminator_Extras.RegisterEvent( newEvent, "jerma985_buttonthatkillsyou" )