
AddCSLuaFile()

ENT.Base = "terminator_nextbot_jerminator"
DEFINE_BASECLASS( ENT.Base )
ENT.PrintName = "Jerma (Scared)"
ENT.Spawnable = false
list.Set( "NPC", "terminator_nextbot_jerminator_scared", {
    Name = "Jerma (Scared)",
    Class = "terminator_nextbot_jerminator_scared",
    Category = "Jerma985 Nextbot",
} )

if CLIENT then
    language.Add( "terminator_nextbot_jerminator_scared", ENT.PrintName )
    return

end

function ENT:EnemyIsLethalInMelee()
    local enemy = self:GetEnemy()
    return IsValid( enemy ) and self.IsSeeEnemy

end
