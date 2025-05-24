
AddCSLuaFile()

ENT.Base = "terminator_nextbot_jerminator_realistic"
DEFINE_BASECLASS( ENT.Base )
ENT.PrintName = "Jerma"
ENT.Spawnable = false
list.Set( "NPC", "terminator_nextbot_jerminator", {
    Name = "Jerma",
    Class = "terminator_nextbot_jerminator",
    Category = "Jerma985 Nextbot",
} )

if CLIENT then
    language.Add( "terminator_nextbot_jerminator", ENT.PrintName )
    return

end

function ENT:EnemyIsLethalInMelee()
    local enemy = self:GetEnemy()
    return IsValid( enemy ) and self.IsSeeEnemy

end

ENT.IsFodder = true
ENT.CoroutineThresh = 0.002

ENT.term_SoundLevelShift = 10

ENT.WalkSpeed = 75
ENT.MoveSpeed = 200
ENT.RunSpeed = 360
ENT.TERM_WEAPON_PROFICIENCY = WEAPON_PROFICIENCY_POOR
ENT.AccelerationSpeed = 1500
ENT.JumpHeight = 70 * 1.5
ENT.FistDamageMul = 1
ENT.ThrowingForceMul = 1
ENT.SpawnHealth = 200
ENT.MyPhysicsMass = 150

ENT.FootstepClomping = false
ENT.duelEnemyTimeoutMul = 5
