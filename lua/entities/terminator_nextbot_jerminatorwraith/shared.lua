
AddCSLuaFile()

ENT.Base = "terminator_nextbot_jerminator_realistic"
DEFINE_BASECLASS( ENT.Base )
ENT.PrintName = "Jerma986"
ENT.Spawnable = false
list.Set( "NPC", "terminator_nextbot_jerminatorwraith", {
    Name = "Jerma986",
    Class = "terminator_nextbot_jerminatorwraith",
    Category = "Terminator Nextbot",
} )

if CLIENT then
    language.Add( "terminator_nextbot_jerminatorwraith", ENT.PrintName )
    return

end

ENT.SpawnHealth = 350
ENT.HealthRegen = 10
ENT.HealthRegenInterval = 0.5

ENT.IsWraith = true -- enable wraith cloaking logic
ENT.NotSolidWhenCloaked = true -- if we're a wraith, we become non-solid when cloaked

function ENT:PlayHideFX()
    self:EmitSound( "ambient/levels/citadel/pod_open1.wav", 74, math.random( 115, 125 ) )
    self.FootstepClomping = false

end

function ENT:PlayUnhideFX()
    self:EmitSound( "ambient/levels/citadel/pod_close1.wav", 74, math.random( 115, 125 ) )
    self.FootstepClomping = true

end

ENT.wraithTerm_CloakDecidingTask = function( self, data ) -- ran in BehaveUpdatePriority
    local speedSqr = self:GetCurrentSpeedSqr()
    local enem = self:GetEnemy()
    local doHide = IsValid( enem ) or speedSqr > 50^2
    local enemDist = self.DistToEnemy
    if doHide and speedSqr < 25^2 then
        doHide = false

    elseif doHide and IsValid( enem ) and enemDist < 250 then
        doHide = false
        self:Anger( 5 )

    end

    self:DoHiding( doHide )

    if not self:IsSolid() and math.Rand( 0, 100 ) < 0.5 then
        self:CloakedMatFlicker()

    end
end