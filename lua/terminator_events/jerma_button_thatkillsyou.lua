
local newEvent = {
    defaultPercentChancePerMin = 0.005,

    navmeshEvent = true,
    variants = {
        {
            variantName = "theButtonThatKillsYou",
            getIsReadyFunc = nil,
            unspawnedStuff = {
                {
                    class = "the_button_that_kills_you",
                    spawnAlgo = "steppedRandomRadius",
                    timeout = nil,  -- no timeout since this will dissapear even if someone finds it rn

                }
            },
            thinkInterval = nil, -- makes it default to terminator_Extras.activeEventThinkInterval
            concludeOnMeet = true,
        },
    },
}

terminator_Extras.RegisterEvent( newEvent, "jerma985_buttonthatkillsyou" )