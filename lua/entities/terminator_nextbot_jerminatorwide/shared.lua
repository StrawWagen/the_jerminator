AddCSLuaFile()
ENT.Base = "terminator_nextbot_jerminator_realistic"
DEFINE_BASECLASS( ENT.Base )
ENT.PrintName = "Jerma989"
ENT.Author = "Broadcloth0 + StrawWagen"
ENT.Spawnable = false
list.Set( "NPC", "terminator_nextbot_jerminatorwide", {
    Name = "Jerma989",
    Class = "terminator_nextbot_jerminatorwide",
    Category = "Terminator Nextbot",
} )

if CLIENT then
    language.Add( "terminator_nextbot_jerminatorwide", ENT.PrintName )
    return

end

function ENT:EnemyIsLethalInMelee()
    return false -- no fear

end

ENT.SpawnHealth = 4100 -- maybe his skin shouldn't absorb that much bullets
ENT.ExtraSpawnHealthPerPlayer = 500
ENT.MyPhysicsMass = 50000 -- caseoh
ENT.HealthRegen = 4
ENT.HealthRegenInterval = 0.5
ENT.TERM_MODELSCALE = 1.11

ENT.DefaultStepHeight = 18
ENT.StandingStepHeight = ENT.DefaultStepHeight * 4
ENT.CrouchingStepHeight = ENT.DefaultStepHeight * 1
ENT.StepHeight = ENT.StandingStepHeight
ENT.PathGoalToleranceFinal = 100
ENT.AimSpeed = 250
ENT.CrouchSpeed = 200
ENT.WalkSpeed = 130
ENT.MoveSpeed = 190
ENT.RunSpeed = 200
ENT.TERM_WEAPON_PROFICIENCY = WEAPON_PROFICIENCY_POOR
ENT.AccelerationSpeed = 100
ENT.DuelEnemyDist = 500

ENT.JumpHeight = 70
ENT.ThrowingForceMul = 0.5
ENT.FistDamageMul = 8

ENT.WeaponBones = {
    ["ValveBiped.Bip01_R_Hand"] = true,
    ["ValveBiped.Bip01_L_Hand"] = true,
    ["ValveBiped.Anim_Attachment_RH"] = true,
    ["ValveBiped.Anim_Attachment_LH"] = true,
}

ENT.IsFatSkinned = 0.75

local wideScale = Vector(1, 1.0, 1.68)
local weaponScale = Vector(1.0, 1.0, 1.0) -- just to make weapons don't look fat, too my knowledge weapons do NOT eat food.

function ENT:AdditionalInitialize()
    BaseClass.AdditionalInitialize( self )
    self.term_SoundPitchShift = -32
    self.term_SoundLevelShift = 20
    self.CanUseLadders = true

    for i = 10, self:GetBoneCount() - 1 do
        if not self.WeaponBones[self:GetBoneName( i )] then
            self:ManipulateBoneScale( i, wideScale )

        else
            self:ManipulateBoneScale( i, weaponScale )

        end
    end
end

function ENT:PostHitObject( _, damageToDeal )
    if damageToDeal < 100 then return end

    local lvl = 70
    local pitch = math.Clamp( 21 + -( damageToDeal * 0.35 ), 85, 120 )
    self:EmitSound( "npc/antlion_guard/antlion_guard_shellcrack2.wav", lvl, pitch, 0.6, CHAN_STATIC )
    util.ScreenShake( self:GetPos(), damageToDeal * 0.005, 2, 3, damageToDeal * 5 )

end

function ENT:OnTakeDamage(dmg)
    local damage = dmg:GetDamage()

    if dmg:IsBulletDamage() or dmg:IsDamageType( DMG_CLUB ) or dmg:IsDamageType( DMG_SLASH ) then
        damage = damage * ( 4 - self.IsFatSkinned )
        local pitch = math.random(110, 150)
        self:EmitSound( "npc/antlion_grub/squashed.wav", 150, pitch, 0.9, CHAN_BODY )

    end

    if damage > 15 then
        dmg:SetDamage( damage )
        return BaseClass.OnTakeDamage( self, dmg )

    end

    return false

end
