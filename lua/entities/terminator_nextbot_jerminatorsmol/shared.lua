
AddCSLuaFile()

ENT.Base = "terminator_nextbot_jerminator_realistic"
DEFINE_BASECLASS( ENT.Base )
ENT.PrintName = "Jerma988"
ENT.Spawnable = false
list.Set( "NPC", "terminator_nextbot_jerminatorsmol", {
    Name = "Jerma988",
    Class = "terminator_nextbot_jerminatorsmol",
    Category = "Terminator Nextbot",
} )

if CLIENT then
    language.Add( "terminator_nextbot_jerminatorsmol", ENT.PrintName )
    return

end

function ENT:EnemyIsLethalInMelee()
    local enemy = self:GetEnemy()
    if not IsValid( enemy ) then return false end

    if not self.IsSeeEnemy then return false end
    if not self.NothingOrBreakableBetweenEnemy then return false end

    local bearing = self:enemyBearingToMeAbs()
    if bearing > 115 then return false end

    local allies = self:GetNearbyAllies()
    local strengthInNumbers = #allies >= 6
    if strengthInNumbers then return BaseClass.EnemyIsLethalInMelee( self ) end

    if bearing < 45 then return true end

end

ENT.TERM_MODELSCALE = function() return math.Rand( 0.6, 0.8 ) end

ENT.IsFodder = true
ENT.CoroutineThresh = 0.0005

ENT.term_SoundPitchShift = 30
ENT.term_SoundLevelShift = 10

ENT.AimSpeed = 480
ENT.WalkSpeed = 175
ENT.MoveSpeed = 300
ENT.RunSpeed = 500
ENT.TERM_WEAPON_PROFICIENCY = WEAPON_PROFICIENCY_AVERAGE
ENT.AccelerationSpeed = 1500
ENT.JumpHeight = 70 * 2
ENT.FistDamageMul = 0.4
ENT.ThrowingForceMul = 1
ENT.SpawnHealth = 150
ENT.MyPhysicsMass = 150
ENT.HealthRegen = 10
ENT.HealthRegenInterval = 2

ENT.FootstepClomping = false


function ENT:AdditionalInitialize( myTbl )
    BaseClass.AdditionalInitialize( self, myTbl )

end