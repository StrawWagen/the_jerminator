
AddCSLuaFile()

ENT.Base = "terminator_nextbot_jerminator_realistic"
DEFINE_BASECLASS( ENT.Base )
ENT.PrintName = "Jerma987"
ENT.Spawnable = false
list.Set( "NPC", "terminator_nextbot_jerminatorhuge", {
    Name = "Jerma987",
    Class = "terminator_nextbot_jerminatorhuge",
    Category = "Jerma985 Nextbot",
} )

if CLIENT then
    language.Add( "terminator_nextbot_jerminatorhuge", ENT.PrintName )
    return

end

function ENT:EnemyIsLethalInMelee()
    local enemy = self:GetEnemy()
    return IsValid( enemy ) and self.IsSeeEnemy

end

ENT.SpawnHealth = 5000
ENT.ExtraSpawnHealthPerPlayer = 500
ENT.MyPhysicsMass = 15000
ENT.HealthRegen = 4
ENT.HealthRegenInterval = 0.5

ENT.TERM_MODELSCALE = 1.75
local standxy = 8
local crouchxy = 7
ENT.CollisionBounds = { Vector( -standxy, -standxy, 0 ), Vector( standxy, standxy, 45 ) } -- this is then scaled by modelscale
ENT.CrouchCollisionBounds = { Vector( -crouchxy, -crouchxy, 0 ), Vector( crouchxy, crouchxy, 30 ) } -- this is then scaled by modelscale

ENT.DefaultStepHeight = 18
ENT.StandingStepHeight = ENT.DefaultStepHeight * 2.25 -- used in crouch toggle in motionoverrides
ENT.CrouchingStepHeight = ENT.DefaultStepHeight * 1
ENT.StepHeight = ENT.StandingStepHeight
ENT.PathGoalToleranceFinal = 100
ENT.AimSpeed = 480
ENT.CrouchSpeed = 200
ENT.WalkSpeed = 200
ENT.MoveSpeed = 300
ENT.RunSpeed = 800 -- bit FASTER
ENT.TERM_WEAPON_PROFICIENCY = WEAPON_PROFICIENCY_AVERAGE
ENT.AccelerationSpeed = 1150 -- slow accel
ENT.DuelEnemyDist = 750

ENT.JumpHeight = 70 * 8
ENT.ThrowingForceMul = 10
ENT.FistDamageMul = 6

ENT.CanHolsterWeapons = false -- holstering breaks on big modelscales :(

function ENT:AdditionalInitialize()
    BaseClass.AdditionalInitialize( self )
    self.term_SoundPitchShift = -10
    self.term_SoundLevelShift = 20
    self.CanUseLadders = false -- too big
    self.term_DoesntFlank = true

    self:EnableCustomCollisions()

end

function ENT:EnemyIsLethalInMelee()
    local enemy = self:GetEnemy()
    if not IsValid( enemy ) then return end

    local strongerThanMe = enemy:Health() >= ( self:Health() + self:GetMaxHealth() )
    return strongerThanMe

end

function ENT:inSeriousDanger()
    return

end

function ENT:PostHitObject( _, damageToDeal )
    if damageToDeal < 200 then return end
    local lvl = 80 + damageToDeal * 0.1
    local pitch = math.Clamp( 120 + -( damageToDeal * 0.35 ), 85, 120 )
    self:EmitSound( "npc/antlion_guard/shove1.wav", lvl, pitch, 1, CHAN_STATIC )
    util.ScreenShake( self:GetPos(), damageToDeal * 0.005, 2, 3, damageToDeal * 5 )

end
