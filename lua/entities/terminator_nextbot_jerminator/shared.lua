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

function ENT:OnKilledGenericEnemyLine( enemyLost )
end

ENT.term_SoundPitchShift = 0
ENT.term_SoundLevelShift = 15
ENT.CanSpeak = true
ENT.NextTermSpeak = 0

ENT.SpawnHealth = 2000

ENT.MetallicMoveSounds = false
ENT.DoMetallicDamage = false

function ENT:AdditionalInitialize()
    self.isTerminatorHunterChummy = "jerminator"
    self.alwaysManiac = math.random( 0, 100 ) < 20

end

local jermSounds = {}

local _, dirs = file.Find( "sound/the_jerminator/*", "GAME" )
for _, dir in ipairs( dirs or {} ) do
    local searchPath = "sound/the_jerminator/" .. dir .. "/*"
    local found = file.Find( searchPath, "GAME" )
    jermSounds[dir] = {}
    for _, path in ipairs( found ) do
        local truePath = "the_jerminator/" .. dir .. "/" .. path
        table.insert( jermSounds[dir], truePath )

    end
end

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
                self:jerm_SpeakARandomSound( "spawned" )
            end,
            EnemyLost = function( self, data )
                self:jerm_SpeakARandomSound( "searching" )
            end,
            EnemyFound = function( self, data )
                self:jerm_SpeakARandomSound( "idle" )
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
                    local increment = 5
                    if self:IsReallyAngry() then
                        increment = 30

                    elseif self:IsAngry() then
                        increment = 15

                    end
                    if math.random( 1, increment ) < tolerance then return end

                    data.punchToleranceTime = math.max( toleranceTime + increment / 2, CurTime() + increment )

                    self:Term_SpeakSoundNow( randomJermSoundPath( "effort" ) )

                else
                    local chance = 15
                    if self:GetWeapon().terminator_ReallyLikesThisOne then
                        chance = 75

                    end
                    if math.random( 1, 100 ) > chance then
                        if ( self.NextTermSpeak + 1 ) < CurTime() then
                            self:jerm_SpeakARandomSound( "idle" )

                        end
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
                self:jerm_SpeakARandomSound( "anger" )

            end,
            OnReallyAnger = function( self, data )
                self:jerm_SpeakARandomSound( "anger" )

            end,
            OnInstantKillEnemy = function( self, data )
                local path = randomJermSoundPath( "killed1shot" )
                self:Term_SpeakSoundNow( path )

            end,
            OnKillEnemy = function( self, data )
                local path = randomJermSoundPath( "killed" )
                self:Term_SpeakSoundNow( path )

            end,
            OnJump = function( self, data, height )
                local toleranceTime = data.jumpToleranceTime or 0
                local tolerance = toleranceTime - CurTime()
                local dealt = height
                if dealt < 75 and math.random( 1, dealt ) < tolerance then return end

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

                end

                self:Term_SpeakSoundNow( path, pitchShift )

            end,
            OnKilled = function( self, damage )
                local lvl = 90 + self.term_SoundLevelShift
                local pit = 90 + self.term_SoundPitchShift
                local pos = self:GetShootPos()
                self:Term_SpeakSoundNow( "common/null.wav" )
                timer.Simple( 0.75, function()
                    sound.Play( randomJermSoundPath( "death" ), pos, lvl, pit, 1 )

                end )
            end,
            BehaveUpdate = function( self, data )
                local offset = 5
                if self:IsReallyAngry() then
                    offset = 0

                elseif self.IsSeeEnemy and not self:primaryPathIsValid() then
                    offset = 0

                elseif self:IsAngry() then
                    offset = 2

                end
                local nextLine = self.NextTermSpeak + offset
                local speaking = nextLine > CurTime()

                if speaking then return end
                local enemy = self:GetEnemy()
                if not IsValid( enemy ) then
                    self:jerm_SpeakARandomSound( "idle" )

                else
                    self:jerm_SpeakARandomSound( "searching" )

                end
            end
        },
    }
    table.Merge( self.TaskList, defaultTasks )
    self:StartTask( "jerminator_handler" )
end