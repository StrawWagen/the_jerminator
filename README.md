# Jerma985 Nextbot
The famous streamer? Jerma985? In YOUR garry's mod game?
With 800+ voicelines?
Count me in!

Keep reading if you want to make your own jerma985 clone!

## Creating Your Own Clone

### Sound Categories

The `doSounds()` function scans these folder names to build the sound tables. Organize your character's sounds into these categories in `sound/your_character_name/`:

- **`anger`** - Played when the bot is angered by something or someone. Lines reacting to something bad happening.
- **`death`** - Played when the bot dies.
- **`dodge`** - Played when the bot jumps.
- **`effort`** - Played when the bot punches with fists.
- **`getweapon`** - Played when the bot picks up a weapon.
- **`shootliked`** - Played when the bot shoots a weapon it likes.
- **`idle`** - Played when the bot is wandering around with no enemy.
- **`searching`** - Played randomly when the bot recently had an enemy.
- **`killed`** - Played when the bot kills an enemy.
- **`killed1shot`** - Played when the bot kills an enemy in one hit!
- **`new`** - Unused (reserved for future use).
- **`onfire`** - Played when the bot is on fire! OH GOD IT BURNS!
- **`pain`** - Played when the bot takes damage.
- **`painsevere`** - Played when the bot takes a large amount of damage!
- **`spawned`** - Played when it spawns. These should be the character's strongest, most iconic lines.

Make sure all soundfiles use `.mp3` with constant bitrate.  
`.mp3` has good compression.  
And constant bitrate is required for the SoundDuration function to work correctly with mp3 files.  

### Setup Guide

#### 1. Create Your Entity File

Copy `terminator_nextbot_jerminator_realistic/shared.lua` to `lua/entities/terminator_nextbot_yourcharacter/shared.lua`. You're copying this one because it has all the sound loading logic, material swapping, and MyClassTask callbacks already implemented.

**Change the model:**
```lua
local YOUR_MODEL = "models/player/your_character.mdl"
ENT.Models = { YOUR_MODEL }
```

**Change the sound location:**
```lua
local soundLocation = "your_character_name/"
```
This must match your sound folder name because `doSounds()` uses it to build the file paths.

#### 2. Setup Dynamic Content Loading

Sounds can take up alot of space. This system lets server admins choose whether to force-download everything on join (static) or only download when the bot spawns (dynamic).
If you don't setup this system, your work is much less appealing to server hosts.

**Create autorun file `lua/autorun/yourcharacter_nextbot_autorun.lua`:**

This handles the cvar, and AddWorkshops the items if dynamic content is off 

```lua
local doingDynamicContent = CreateConVar( "yourcharacter_dynamic_content", 0, 
    { FCVAR_ARCHIVE, FCVAR_REPLICATED }, 
    "Dynamically request content when bot spawns?" )

if not SERVER then return end

-- If dynamic content is disabled, mount the workshop items normally
if not doingDynamicContent:GetBool() then
    resource.AddWorkshop( "YOUR_BOT_WORKSHOP_ID" ) -- the workshop id of the bot(sounds?) after you upload it
    resource.AddWorkshop( "YOUR_MODEL_WORKSHOP_ID" )
end
```

**In your entity's shared.lua (CLIENT section):**

Replace the existing `AdditionalClientInitialize` function:

```lua
if CLIENT then
    language.Add( "terminator_nextbot_yourcharacter", ENT.PrintName )

    local contentVar = GetConVar( "yourcharacter_dynamic_content" )
    local gotModelContent
    local gotSoundContent
    local attempts = 0

    function ENT:AdditionalClientInitialize()
        -- AdditionalClientInitialize is called when a specific entity first appears on a client.
        
        if not contentVar:GetBool() then return end -- only do this logic if the dynamic content system is turned on

        if attempts >= 2 then return end  -- dont do this forever

        if not gotModelContent then
            attempts = attempts + 1
            steamworks.DownloadUGC( "YOUR_MODEL_WORKSHOP_ID", function( path )
                if not path then return end
                gotModelContent = game.MountGMA( path )

            end )
        end
        
        if not gotSoundContent then
            attempts = attempts + 1
            steamworks.DownloadUGC( "YOUR_BOT_WORKSHOP_ID", function( path )
                if not path then return end
                gotSoundContent = game.MountGMA( path )

            end )
        end
    end
    return
end
```

#### 3. Optional Customization

**Material swaps for facial expressions:**

These get swapped based on the bot's state in `BehaveUpdatePriority`. The base code already handles this.

```lua
ENT.Jerm_IdleFace = ""  -- Empty string uses model's default material
ENT.Jerm_AngryFace = "your_character/angry_face"
ENT.Jerm_PainFace = "your_character/pain_face"
```

**Sound settings:**
```lua
ENT.term_SoundPitchShift = 0     -- Shifts pitch of all sounds (positive = higher, negative = lower)
ENT.term_SoundLevelShift = 20    -- Shifts volume in decibels
```

The rest of the sound logic and MyClassTask callbacks are already handled by the code you copied.

## Advanced: Family-Friendly Filter

The base code includes a family-friendly system that filters out sounds with swear words in the filename. This only works if you name your sound files descriptively.

**How it works:**

The `doSounds()` function checks every sound file's name against a list of bad words. If a match is found and the ConVar is enabled, that sound gets skipped.

```lua
local familyFriendlyVar = CreateConVar( "yourcharacter_familyfriendly", "0", 
    FCVAR_ARCHIVE, "Blocks sounds with swears", 0, 1 )

local badWords = { "fuck", "shit", "ass", "bitch", "butt", "sex", "dick" }
```

**This means you need to name files based on what they say:**
- `anger/what_the_fuck.mp3` - Gets filtered when family-friendly is on
- `anger/oh_no.mp3` - Always plays
- `killed/eat_shit.mp3` - Gets filtered
- `killed/gotcha.mp3` - Always plays

The system converts filenames to lowercase and checks if any bad word appears in the name. If your character doesn't swear, or you don't care about filtering, you can remove this logic from your copy of the code.

## Advanced: Group Coordination Behavior

The Jerminator has special group behavior where multiple bots will hold back and coordinate a strike together. This is handled by `EnemyIsLethalInMelee()` and `PrepareStrike()`.

**What it does:**

When jermas spawn in groups, they don't all attack at once. Instead they wait, build up "vibe", and then all rush in together when conditions are met. This makes groups more interesting but also more complex.

**If you don't want this behavior:**

Delete the entire `PrepareStrike()` function and the `EnemyIsLethalInMelee()` override from your copied code. The base Terminator Nextbot will handle enemy engagement with simpler logic - bots just attack when they see enemies.

This will make your bot simpler and more predictable. Groups will act independently instead of coordinating.

## Credits

Original Jerminator addon by StrawWagen
- Based on the Terminator Nextbot framework
- Sounds: Various Jerma985 streams and clips

When creating your clone, credit:
- Original character/content creators
- Model creators
- Sound sources
