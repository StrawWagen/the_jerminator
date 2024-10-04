-- SOUNDS CREDIT TO https://drive.google.com/drive/folders/1CM61yeIq3NpyZKQYCljL9Oa4I2SnpKVi

AddCSLuaFile()

ENT.Base = "terminator_nextbot"
DEFINE_BASECLASS( ENT.Base )
ENT.PrintName = "Jerma985"
ENT.Spawnable = false
list.Set( "NPC", "terminator_nextbot_jerminator", {
    Name = "Jerma985",
    Class = "terminator_nextbot_jerminator",
    Category = "Terminator Nextbot",
} )

if CLIENT then
    language.Add( "terminator_nextbot_jerminator", ENT.PrintName )
    return

end

local JERMINATOR_MODEL = "models/player/giwake/jermaregular.mdl"
ENT.ARNOLD_MODEL = JERMINATOR_MODEL

ENT.Models = { JERMINATOR_MODEL }

ENT.TERM_FISTS = "weapon_jerminator_fists"

ENT.term_SoundPitchShift = 0
ENT.term_SoundLevelShift = 20
ENT.CanSpeak = true
ENT.NextTermSpeak = 0

ENT.FistDamageMul = 1.5
ENT.SpawnHealth = 2000

ENT.MetallicMoveSounds = false
ENT.DoMetallicDamage = false

function ENT:AdditionalInitialize()
    self.isTerminatorHunterChummy = "jerminator"
    self.alwaysManiac = math.random( 0, 100 ) < 20

end

ENT.NextRegenHeal = 0
function ENT:AdditionalThink()
    if self.NextRegenHeal > CurTime() then return end
    self.NextRegenHeal = CurTime() + 0.25
    local oldHealth = self:Health()
    if oldHealth <= 0 then return end

    local newHealth = math.Clamp( oldHealth + 2, 0, self:GetMaxHealth() )
    self:SetHealth( newHealth )

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

            --local trimmed = string.Replace( truePath, ".mp3", "" )
            --if string.find( trimmed, ".", nil, true ) then print( truePath ) end

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

function ENT:DoCustomTasks( defaultTasks )
    self.TaskList = {
        ["jerminator_handler"] = {
            OnCreated = function( self, data )
                self:Term_SpeakSoundNow( randomJermSoundPath( "spawned" ) )

            end,
            EnemyLost = function( self, data )
                self:jerm_SpeakARandomSound( "searching" )
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
                self:jerm_SpeakARandomSound( "anger" )
                self.jerm_nextRareAngry = CurTime() + math.random( 10, 20 )

            end,
            OnInstantKillEnemy = function( self, data )
                local path = randomJermSoundPath( "killed1shot" )
                self:Term_SpeakSoundNow( path )
                self:jerm_SpeakARandomSound( "killed" )

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

                self:Term_SpeakSoundNow( path, pitchShift )

            end,
            OnKilled = function( self, damage )
                local lvl = 90 + self.term_SoundLevelShift
                local pit = math.Rand( 95, 97 ) + self.term_SoundPitchShift
                local pos = self:GetShootPos()
                self:Term_SpeakSoundNow( "painsevere" )
                timer.Simple( 1.5, function()
                    sound.Play( randomJermSoundPath( "death" ), pos, lvl, pit, 1 )

                end )
            end,
            BehaveUpdatePriority = function( self, data )
                local enemy = self:GetEnemy()
                local path = self:GetPath()
                local offset = 5
                local headingToEnem = IsValid( enemy ) and path and path:GetEnd() and path:GetEnd():DistToSqr( enemy:GetPos() ) < 500^2 and path:GetLength() < 1000
                if headingToEnem then
                    offset = -5

                elseif self:IsReallyAngry() then
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
            end
        },
    }
    table.Merge( self.TaskList, defaultTasks )
    self:StartTask( "jerminator_handler" )
end