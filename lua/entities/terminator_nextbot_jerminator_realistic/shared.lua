-- SOUNDS CREDIT TO https://drive.google.com/drive/folders/1CM61yeIq3NpyZKQYCljL9Oa4I2SnpKVi
-- NEWER SOUNDS CREDIT TO RANDOM CLIP DUMPS
-- credit to jerma :)

AddCSLuaFile()

ENT.Base = "terminator_nextbot"
DEFINE_BASECLASS( ENT.Base )
ENT.PrintName = "Jerma985"
ENT.Spawnable = false
list.Set( "NPC", "terminator_nextbot_jerminator_realistic", {
    Name = "Jerma985",
    Class = "terminator_nextbot_jerminator_realistic",
    Category = "Terminator Nextbot",
} )

ENT.MySpecialActions = { -- binds 
    ["jerminator_speak"] = {
        inBind = IN_RELOAD,
        drawHint = true,
        name = "Speak",
        desc = "Speak a line",
        ratelimit = 1, -- seconds between uses
        svAction = function( _drive, _driver, bot )
            bot:RunTask( "SpeakALine" )

        end,
    }
}

if CLIENT then
    language.Add( "terminator_nextbot_jerminator_realistic", ENT.PrintName )

    local contentVar = GetConVar( "jerminator_dynamic_content" )
    local gotBOTContent
    local gotPMContent
    local attempts = 0

    function ENT:AdditionalClientInitialize() -- people who join in with this already spawned are screwed lol
        if not contentVar:GetBool() then return end

        if attempts >= 2 then return end -- just in case

        if not gotBOTContent then
            attempts = attempts + 1
            steamworks.DownloadUGC( "3330585475", function( path )
                if not path then return end
                gotBOTContent = game.MountGMA( path )

            end )
        end
        if not gotPMContent then
            attempts = attempts + 1
            steamworks.DownloadUGC( "2691974423", function( path )
                if not path then return end
                gotPMContent = game.MountGMA( path )

            end )
        end
    end
    return

end

local JERMINATOR_MODEL = "models/player/giwake/jermaregular.mdl"
ENT.Models = { JERMINATOR_MODEL }

ENT.TERM_FISTS = "weapon_jerminator_fists"

ENT.term_SoundPitchShift = 0
ENT.term_SoundLevelShift = 20
ENT.CanSpeak = true
ENT.NextTermSpeak = 0

ENT.FistDamageMul = 1.5
ENT.SpawnHealth = 1500
ENT.HealthRegen = 2
ENT.HealthRegenInterval = 0.5

ENT.MetallicMoveSounds = false
ENT.DoMetallicDamage = false
ENT.CanSwim = true
ENT.BreathesAir = true

ENT.Jerm_IdleFace = "" -- model's default mat
ENT.Jerm_AngryFace = "jerma985/jermasusimproved"
ENT.Jerm_PainFace = "jerma985/jermasour"

function ENT:AdditionalInitialize()
    self.isTerminatorHunterChummy = "jerminator"
    self.potentialManiac = math.random( 0, 100 ) < 30
    self.alwaysManiac = function( self2 )
        local allies = self2:GetNearbyAllies()
        local oneHasEnemy = false
        for _, ally in ipairs( allies ) do
            if not IsValid( ally ) then continue end
            local enem = ally:GetEnemy()
            if IsValid( enem ) then
                oneHasEnemy = true

            end
        end
        if oneHasEnemy then
            return false

        else
            return self2.potentialManiac

        end
    end

    self.jerminator_MatState = ""

    if self.Jerm_IdleFace ~= "" then
        self:SetMaterial( self.Jerm_IdleFace )

    end
end

local familyFriendlyVar = CreateConVar( "jerminator_familyfriendly", "0", FCVAR_ARCHIVE, "Blocks most jerma sounds that contain swears, etc.", 0, 1 )
local badWords = {
    "fuck",
    "shit",
    "ass",
    "bitch",
    "butt",
    "sex",
    "dick",

}
local jermSounds
local soundLocation = "the_jerminator/"

local function doSounds()
    jermSounds = {}
    local count = 0

    local _, dirs = file.Find( "sound/" .. soundLocation .. "*", "GAME" )
    for _, dir in ipairs( dirs or {} ) do
        local searchPath = "sound/" .. soundLocation .. dir .. "/*"
        local found = file.Find( searchPath, "GAME" )
        jermSounds[dir] = {}
        for _, path in ipairs( found ) do
            if familyFriendlyVar:GetBool() then
                local bad
                local pathLower = string.lower( path )
                for _, badWord in ipairs( badWords ) do
                    if string.find( pathLower, badWord ) then bad = true break end

                end
                if bad then continue end

            end

            local truePath = soundLocation .. dir .. "/" .. path

            table.insert( jermSounds[dir], truePath )
            count = count + 1

        end
    end

    print( "loaded " .. count .. " jerma soundbytes" )

end

doSounds()
cvars.AddChangeCallback( "jerminator_familyfriendly", doSounds, "jerminator_resetsounds" )

function ENT:jerm_SpeakARandomSound( directory )
    local inDir = jermSounds[directory]
    local randSnd = inDir[ math.random( 1, #inDir ) ]

    self:Term_SpeakSound( randSnd )

end

local function randomJermSoundPath( directory )
    local inDir = jermSounds[directory]
    return inDir[ math.random( 1, #inDir ) ]

end

local CurTime = CurTime
local upReallyHigh = Vector( 0, 0, 2000 )
local strikeInterval = 120

function ENT:PrepareStrike( enemy, allies )
    local cur = CurTime()

    local strikeGroup = table.Copy( allies )
    table.insert( strikeGroup, self )

    local graceEnd = cur + 15
    local strikeEnd = cur + 90 + #strikeGroup

    for _, striker in ipairs( strikeGroup ) do
        if not IsValid( striker ) then continue end
        if striker.jerminator_NextCoordinatedStrike and striker.jerminator_NextCoordinatedStrike > cur then continue end
        striker.jerminator_NextCoordinatedStrike = strikeEnd
        striker.jerminator_CoordinatedStrikeWaiting = true
        striker:BlockWeaponFiringUntil( cur + 0.5 )
        striker:Anger( math.random( 1, 5 ) )

    end
    self:ReallyAnger( 5 )

    local vibe = 0
    local killerVibe = 12
    local strikeTarget = enemy
    local startingKiller = enemy.isTerminatorHunterKiller or 0

    local timerName = "jerminator_coordinatestrike_" .. self:GetCreationID()
    timer.Create( timerName, 0.2, 0, function()
        if not IsValid( self ) then timer.Remove( timerName ) return end
        local validTarg = IsValid( enemy )
        if strikeEnd < CurTime() then -- waited too long, JUST KILL THEM!
            timer.Remove( timerName )
            for _, striker in ipairs( strikeGroup ) do
                if not IsValid( striker ) then continue end
                striker.jerminator_NextCoordinatedStrike = CurTime() + strikeInterval + #strikeGroup
                striker.jerminator_CoordinatedStrikeWaiting = nil
                striker:ReallyAnger( 60 )

            end
            return

        end
        if validTarg and graceEnd > CurTime() then -- wait for grace to end
            for _, striker in ipairs( strikeGroup ) do
                if not IsValid( striker ) then continue end

                local currEnemy = striker:GetEnemy()
                if striker.IsSeeEnemy and currEnemy == strikeTarget then
                    striker:BlockWeaponFiringUntil( cur + 0.5 )

                end
            end
            return

        end

        local STRIKE = false
        local validCount = 0
        local validSee = 0
        local validHasEnemy = 0
        local oneThinksBoxed
        local vibeAdded = 1
        local behindEnemy = 0
        local lostHealth = 0
        local nearestDist = math.huge

        if validTarg then
            local start = strikeTarget:GetShootPos()
            local trStruc = {
                start = start,
                endpos = start + upReallyHigh,
                mask = MASK_SOLID_BRUSHONLY,

            }

            local skyResult = util.TraceLine( trStruc )
            local underSky = skyResult.HitSky or not skyResult.Hit
            if not underSky then -- strike if enemy goes in a building
                STRIKE = true
                vibeAdded = vibeAdded + 1

            end
        end

        if validTarg then
            for _, striker in ipairs( strikeGroup ) do -- figure out if we should strike
                if not IsValid( striker ) then continue end
                validCount = validCount + 1

                local currEnemy = striker:GetEnemy()

                if striker.IsSeeEnemy and currEnemy == strikeTarget then -- strike if enemy is boxed in, or if most of the group can see the enemy
                    striker:BlockWeaponFiringUntil( cur + 0.5 )

                    validSee = validSee + 1
                    validHasEnemy = validHasEnemy + 1
                    oneThinksBoxed = oneThinksBoxed or striker:EnemyIsBoxedIn()

                    lostHealth = lostHealth + striker:getLostHealth()

                    nearestDist = math.min( nearestDist, striker.DistToEnemy )

                    local enemBearingToMe = self:enemyBearingToMeAbs()
                    if enemBearingToMe > 90 then
                        behindEnemy = behindEnemy + 1

                    end

                elseif IsValid( currEnemy ) and currEnemy == enemy then
                    validHasEnemy = validHasEnemy + 1
                    striker:BlockWeaponFiringUntil( cur + 0.5 )

                end
            end
        end

        if not validTarg or ( strikeTarget.Alive and not strikeTarget:Alive() ) or ( validHasEnemy <= 0 and vibe <= 0 ) then -- fail condition
            timer.Remove( timerName )
            for _, striker in ipairs( strikeGroup ) do
                if not IsValid( striker ) then continue end
                striker.jerminator_NextCoordinatedStrike = math.max( striker.jerminator_NextCoordinatedStrike, CurTime() + strikeInterval + #strikeGroup )
                striker.jerminator_CoordinatedStrikeWaiting = nil

            end
            return

        end

        if oneThinksBoxed or lostHealth > 100 then
            vibeAdded = vibeAdded + 1
            STRIKE = true

        elseif not STRIKE then
            local ratioNeeded = 0.75
            STRIKE = validSee >= validCount * ratioNeeded

        end

        if validTarg and strikeTarget.isTerminatorHunterKiller and enemy.isTerminatorHunterKiller > startingKiller then
            STRIKE = true
            vibeAdded = vibeAdded * 10

        end

        if nearestDist < 200 and not STRIKE then
            STRIKE = true

        elseif nearestDist < 400 then
            vibeAdded = vibeAdded + 1

        end

        if behindEnemy >= 1 then
            vibeAdded = vibeAdded * 2

        end

        if STRIKE then -- dont just strike instantly
            vibe = vibe + 1
            if vibe >= killerVibe then
                timer.Remove( timerName )
                for index, striker in ipairs( strikeGroup ) do
                    if not IsValid( striker ) then continue end
                    if not striker.jerminator_NextCoordinatedStrike then continue end
                    striker.jerminator_NextCoordinatedStrike = math.max( striker.jerminator_NextCoordinatedStrike, CurTime() + strikeInterval + #strikeGroup )
                    striker.jerminator_CoordinatedStrikeWaiting = nil
                    striker:ReallyAnger( 60 )
                    timer.Simple( 0 + index * 0.1, function()
                        if not IsValid( striker ) then return end
                        striker:KillAllTasksWith( "movement" )
                        striker:StartTask2( "movement_followenemy", nil, "killer vibes!" )
                        striker.forcedShouldWalk = 0

                    end )
                end
                return
            else
                for _, striker in ipairs( strikeGroup ) do
                    if not IsValid( striker ) then continue end
                    if striker.IsSeeEnemy then continue end
                    striker:Anger( math.random( 1, 5 ) )

                end
            end
        elseif vibe > 0 then
            vibe = math.max( vibe - 0.08, 0 )

        end
    end )
end

-- groups of jermas have special logic that keeps them from attacking outright
function ENT:EnemyIsLethalInMelee()
    local enemy = self:GetEnemy()
    if not IsValid( enemy ) then return false end

    local cur = CurTime()
    local allies = self:GetNearbyAllies()

    local nextStrike = self.jerminator_NextCoordinatedStrike or 0

    if nextStrike > cur then -- doing strike
        if self.jerminator_CoordinatedStrikeWaiting then
            return self.IsSeeEnemy

        else
            if enemy:IsPlayer() and enemy:Health() <= 0 then
                self.jerminator_DoneWithStrikes = true

            end
            return false

        end
    end

    if self.jerminator_DoneWithStrikes then
        return BaseClass.EnemyIsLethalInMelee( self )

    end

    local inAGroup = #allies >= 1
    local prepareStrike = inAGroup and nextStrike < cur
    local enemyIsWeak = enemy.Health and enemy:Health() <= enemy:GetMaxHealth() * 0.75

    if prepareStrike and inAGroup and enemy:IsPlayer() then
        local meetConditions = enemyIsWeak
        meetConditions = meetConditions or self.IsSeeEnemy and self:Health() <= self:GetMaxHealth() * 0.9
        meetConditions = meetConditions or self:EnemyIsBoxedIn()

        prepareStrike = meetConditions

    else
        prepareStrike = false

    end

    if prepareStrike then -- group of jermas, we hold back THEN STRIKE ALL AT ONCE!
        self:PrepareStrike( enemy, allies )

        return self.IsSeeEnemy

    elseif inAGroup then
        if enemyIsWeak then
            return BaseClass.EnemyIsLethalInMelee( self )

        elseif self:getLostHealth() <= 0 and not self:IsAngry() then
            return BaseClass.EnemyIsLethalInMelee( self )

        else
            return self.IsSeeEnemy

        end
    else
        return BaseClass.EnemyIsLethalInMelee( self )

    end
end

ENT.MyClassTask = {
    StartsOnInitialize = true,
    OnCreated = function( self, data )
        self:Term_SpeakSoundNow( randomJermSoundPath( "spawned" ) )

    end,
    EnemyLost = function( self, data )
        self:jerm_SpeakARandomSound( "searching" )
    end,
    SpeakALine = function ( self, data )
        local path = "idle"
        if self:IsReallyAngry() then
            path = "anger"

        end
        self:Term_SpeakSoundNow( randomJermSoundPath( path ) )

    end,
    EnemyFound = function( self, data, enemy, sinceLastFound )
        if sinceLastFound < 10 then return end
        local path = "idle"
        if self:IsReallyAngry() then
            path = "anger"

        end
        self:jerm_SpeakARandomSound( path )
    end,
    StartStaring = function( self, data )
        local nextLine = data.nextStareLine or 0
        if nextLine > CurTime() then return end
        data.nextStareLine = CurTime() + 5
        self:jerm_SpeakARandomSound( "searching" )
    end,
    OnAttack = function( self, data )
        if self:IsFists() then
            local toleranceTime = data.punchToleranceTime or 0
            local tolerance = toleranceTime - CurTime()
            local increment = 10
            if self:IsReallyAngry() then -- he doesn't do funny stuff when he's mad :(
                increment = 40

            elseif self:IsAngry() then
                increment = 20

            end
            if math.random( 1, increment ) < tolerance then return end

            data.punchToleranceTime = math.max( toleranceTime + increment / 2, CurTime() + increment )

            self:Term_SpeakSoundNow( randomJermSoundPath( "effort" ) )

        else
            local chance = 5
            if self:GetWeapon().terminator_ReallyLikesThisOne then
                chance = 50

            end
            if math.random( 1, 100 ) > chance then
                return

            end

            local path = randomJermSoundPath( "shootliked" )
            self:Term_SpeakSoundNow( path )

        end
    end,
    GetWeapon = function( self, data )
        if self.NextTermSpeak > CurTime() then return end
        local path = randomJermSoundPath( "getweapon" )
        self:Term_SpeakSoundNow( path )

    end,
    OnAnger = function( self, data )
        self.jerm_nextRareAngry = CurTime() + math.random( 10, 20 )
        self:jerm_SpeakARandomSound( "anger" )

    end,
    OnReallyAnger = function( self, data )
        self.jerm_nextRareAngry = CurTime() + math.random( 10, 20 )
        timer.Simple( 0.1, function()
            if not IsValid( self ) then return end
            self:Term_SpeakSoundNow( randomJermSoundPath( "anger" ) )
            self:jerm_SpeakARandomSound( "anger" )

        end )
    end,
    OnInstantKillEnemy = function( self, data )
        local path = randomJermSoundPath( "killed1shot" )
        self:Term_SpeakSoundNow( path )
        self:jerm_SpeakARandomSound( "killed" ) -- say this after

    end,
    OnKillEnemy = function( self, data )
        local path = randomJermSoundPath( "killed" )
        self:Term_SpeakSoundNow( path )

    end,
    OnJump = function( self, data, height )
        local toleranceTime = data.jumpToleranceTime or 0
        local tolerance = toleranceTime - CurTime()
        local dealt = height
        if dealt < 125 and math.random( 1, dealt ) < tolerance then return end

        data.jumpToleranceTime = math.max( toleranceTime + dealt / 2, CurTime() + dealt )
        self:Term_SpeakSoundNow( randomJermSoundPath( "dodge" ) )

    end,
    OnDamaged = function( self, data, damage )
        local onFire = damage:IsDamageType( DMG_BURN ) and self:IsOnFire()

        local toleranceTime = data.painToleranceTime or 0
        local tolerance = toleranceTime - CurTime()
        local dealt = damage:GetDamage()
        if not onFire and dealt < 75 and math.random( 1, dealt ) < tolerance then return end

        data.painToleranceTime = math.max( toleranceTime + dealt / 2, CurTime() + dealt )

        local sourTime
        local path = randomJermSoundPath( "pain" )
        local pitchShift = 0

        if onFire then
            local nextScream = data.nextFireSpeak or 0
            if nextScream > CurTime() then return end
            path = randomJermSoundPath( "onfire" )
            pitchShift = math.random( 0, 20 )
            data.nextFireSpeak = CurTime() + math.Rand( 0.5, 1.5 )

        elseif ( dealt > 25 and self:Health() <= self:GetMaxHealth() * 0.15 ) or ( dealt > 50 and self:getLostHealth() > 75 ) then
            path = randomJermSoundPath( "painsevere" )
            timer.Simple( 0.1, function()
                if not IsValid( self ) then return end
                if self:Health() <= 0 then return end
                self:jerm_SpeakARandomSound( "pain" )

            end )
        end

        sourTime = math.Clamp( dealt / 50, 0.25, 1.5 )

        self:Term_SpeakSoundNow( path, pitchShift )

        if sourTime then
            local oldSour = self.jerminator_SourFace or 0
            self.jerminator_SourFace = math.max( CurTime() + sourTime, oldSour + ( sourTime * 0.5 ) )

        end
    end,
    OnKilled = function( self, data, attacker, inflictor, ragdoll )
        local lvl = 95 + self.term_SoundLevelShift
        local pit = math.Rand( 95, 97 ) + self.term_SoundPitchShift
        local pos = self:GetShootPos()
        self:Term_SpeakSoundNow( "common/null.wav", 10 )
        local path1 = randomJermSoundPath( "death" )
        timer.Simple( 0.75, function()
            if IsValid( ragdoll ) then
                if ragdoll:GetModel() == JERMINATOR_MODEL then
                    ragdoll:SetMaterial( "jerma985/jermasour" )

                end
                ragdoll:EmitSound( path1, lvl, pit, 1, CHAN_VOICE )

            else
                sound.Play( path1, pos, lvl, pit, 1 )

            end
        end )
        if SoundDuration( path1 ) <= 1 then
            local path2 = randomJermSoundPath( "death" )
            timer.Simple( 3, function()
                if path1 == path2 then return end
                if IsValid( ragdoll ) then
                    ragdoll:EmitSound( path2, lvl, pit, 1, CHAN_VOICE )

                else
                    sound.Play( path2, pos, lvl, pit, 1 )

                end
            end )
        end
    end,
    BehaveUpdatePriority = function( self, data )
        local myTbl = data.myTbl
        local reallyAngry = myTbl.IsReallyAngry( self )
        local sourFace = myTbl.jerminator_SourFace or 0
        if sourFace > CurTime() then
            data.jerminator_MatState = myTbl.Jerm_PainFace

        elseif reallyAngry then
            data.jerminator_MatState = myTbl.Jerm_AngryFace

        else
            data.jerminator_MatState = myTbl.Jerm_IdleFace

        end

        if data.jerminator_MatState and self:GetMaterial() ~= data.jerminator_MatState and self:IsSolid() then
            self:SetMaterial( data.jerminator_MatState )

        end

        local enemy = self:GetEnemy()
        local path = self:GetPath()
        local offset = 5
        local headingToEnem = IsValid( enemy ) and path and path:GetEnd() and path:GetEnd():DistToSqr( enemy:GetPos() ) < 500^2 and path:GetLength() < 1000
        if headingToEnem then
            offset = -5

        elseif reallyAngry then
            offset = 0

        elseif self.IsSeeEnemy and not self:primaryPathIsValid() then
            offset = 1

        elseif self:IsAngry() then
            offset = 2

        end
        local nextLine = self.NextTermSpeak + offset
        local speaking = nextLine > CurTime()

        if speaking then return end
        if not IsValid( enemy ) then
            self:jerm_SpeakARandomSound( "idle" )

        else
            local rareAngry = self.jerm_nextRareAngry or 0
            if self:IsAngry() and headingToEnem and rareAngry < CurTime() then
                self.jerm_nextRareAngry = CurTime() + math.random( 5, 15 )
                self:jerm_SpeakARandomSound( "anger" )

            else
                self:jerm_SpeakARandomSound( "searching" )

            end
        end
    end,
}