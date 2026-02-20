AddCSLuaFile()

ENT.Base = "terminator_nextbot_jerminator_realistic"
DEFINE_BASECLASS( ENT.Base )
ENT.Author = "Boomeritaintaters"
ENT.PrintName = "Jerma990"
ENT.Spawnable = false
list.Set( "NPC", "terminator_nextbot_jerminatorstronk", {
    Name = "Jerma990",
    Class = "terminator_nextbot_jerminatorstronk",
    Category = "Terminator Nextbot",
} )

if CLIENT then
    language.Add( "terminator_nextbot_jerminatorstronk", ENT.PrintName )
    return

end

function ENT:EnemyIsLethalInMelee()
    return false -- no fear

end

function ENT:inSeriousDanger()
    return false -- no fear

end

local goCrazyThresh = 0.5 -- keep our cool

function ENT:canDoRun()
    if self:Health() >= self:GetMaxHealth() * goCrazyThresh then
        return false

    end

    return BaseClass.canDoRun( self )

end

function ENT:IsAngry()
    if self:Health() >= self:GetMaxHealth() * goCrazyThresh then
        return false

    end

    return BaseClass.IsAngry( self )

end

function ENT:IsReallyAngry()
    if self:Health() >= self:GetMaxHealth() * goCrazyThresh then
        return false

    end

    return BaseClass.IsReallyAngry( self )

end

ENT.Jerm_IdleFace = "jerma985/jermaswole"
ENT.Jerm_AngryFace = "jerma985/jermaswole_mad"


ENT.PathGoalToleranceFinal = 100
ENT.SpawnHealth = 2500
ENT.AimSpeed = 480
ENT.CrouchSpeed = 200
ENT.WalkSpeed = 200
ENT.MoveSpeed = 320
ENT.RunSpeed = 550 -- bit SLOWER
ENT.TERM_WEAPON_PROFICIENCY = WEAPON_PROFICIENCY_POOR
ENT.AccelerationSpeed = 1650 -- fast accel
ENT.DuelEnemyDist = 850

ENT.ThrowingForceMul = 1000 -- why not
ENT.FistDamageMul = 8

ENT.WeaponBones = {
    ["ValveBiped.Bip01_R_Hand"] = true,
    ["ValveBiped.Bip01_L_Hand"] = true,
    ["ValveBiped.Anim_Attachment_RH"] = true,
    ["ValveBiped.Anim_Attachment_LH"] = true,
}

local armScale = Vector( 1, 1.7, 1.7 )
local weaponScale = Vector( 1.0, 1.0, 1.0 )

-- Copied from the WIDE jerm
function ENT:AdditionalInitialize()
    BaseClass.AdditionalInitialize( self )

    for i = 10, self:GetBoneCount() - 8 do
        if not self.WeaponBones[self:GetBoneName( i )] then
            self:ManipulateBoneScale( i, armScale )

        else
            self:ManipulateBoneScale( i, weaponScale )

        end
    end
end

function ENT:EnemyIsLethalInMelee()
    local enemy = self:GetEnemy()
    if not IsValid( enemy ) then return end

end

function ENT:GetWeightOfWeapon( wep )
    local weight = BaseClass.GetWeightOfWeapon( self, wep )
    local class = wep:GetClass()
    if string.find( class, "crowbar" ) then return weight * 10 end -- mmm im so STRONG i can throw this so FAR
    return weight

end