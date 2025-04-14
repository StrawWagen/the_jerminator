AddCSLuaFile()
ENT.Base = "terminator_nextbot_jerminator_realistic"
DEFINE_BASECLASS(ENT.Base)
ENT.PrintName = "Jerma989"
ENT.Spawnable = false
list.Set("NPC", "terminator_nextbot_jerminatorwide", {
    Name = "Jerma989",
    Class = "terminator_nextbot_jerminatorwide",
    Category = "Terminator Nextbot",
})

if CLIENT then
    language.Add("terminator_nextbot_jerminatorwide", ENT.PrintName)
    return
end

function ENT:EnemyIsLethalInMelee()
    local enemy = self:GetEnemy()
    return IsValid( enemy ) and self.IsSeeEnemy

end

ENT.SpawnHealth = 9000
ENT.ExtraSpawnHealthPerPlayer = 500
ENT.MyPhysicsMass = 55959596959865987986969 -- caseoh
ENT.HealthRegen = 4
ENT.HealthRegenInterval = 0.5
ENT.TERM_MODELSCALE = 1.11

ENT.DefaultStepHeight = 54
ENT.StandingStepHeight = ENT.DefaultStepHeight * 2.25
ENT.CrouchingStepHeight = ENT.DefaultStepHeight * 1
ENT.StepHeight = ENT.StandingStepHeight
ENT.PathGoalToleranceFinal = 100
ENT.AimSpeed = 250
ENT.CrouchSpeed = 200
ENT.WalkSpeed = 200
ENT.MoveSpeed = 190
ENT.RunSpeed = 130
ENT.HasGreasyHands = true
ENT.TERM_WEAPON_PROFICIENCY = WEAPON_PROFICIENCY_POOR
ENT.AccelerationSpeed = 100
ENT.DuelEnemyDist = 750

ENT.JumpHeight = 70
ENT.ThrowingForceMul = 0
ENT.FistDamageMul = 6

ENT.CanHolsterWeapons = finalSeen

ENT.WeaponBones = {
    "ValveBiped.Bip01_R_Hand",
    "ValveBiped.Bip01_L_Hand",
    "ValveBiped.Anim_Attachment_RH",
    "ValveBiped.Anim_Attachment_LH"
}

ENT.IsFatSkinned = 0.75
ENT.FatHitGroup = HITGROUP_GENERIC

function ENT:AdditionalInitialize()
    BaseClass.AdditionalInitialize( self )
    self.term_SoundPitchShift = -32
    self.term_SoundLevelShift = 29
    self.CanUseLadders = true
    
    self.WeaponBoneIDs = {}
    for _, boneName in ipairs(self.WeaponBones) do
        local boneID = self:LookupBone(boneName)
        if boneID then
            self.WeaponBoneIDs[boneID] = true
        end
    end
    
    local wideScale = Vector(1, 1.0, 1.79)
    local weaponScale = Vector(1.0, 1.0, 1.0) -- just to make weapons don't look fat, too my knowledge weapons do NOT eat food.
    
    for i = 10, self:GetBoneCount() - 1 do
        if not self.WeaponBoneIDs or not self.WeaponBoneIDs[i] then
            self:ManipulateBoneScale(i, wideScale)
        else
            self:ManipulateBoneScale(i, weaponScale)
        end
    end
end

function ENT:TraceAttack(dmginfo, dir, trace)
    self.FatHitGroup = trace.HitGroup
    return BaseClass.TraceAttack(self, dmginfo, dir, trace)
end

function ENT:PostHitObject(_, damageToDeal)
    if damageToDeal < 100 then return end
    local lvl = 70
    local pitch = math.Clamp(21 + -(damageToDeal * 0.35), 85, 120)
    self:EmitSound("npc/antlion_guard/antlion_guard_shellcrack2.wav", lvl, pitch, 0.6, CHAN_STATIC)
    util.ScreenShake(self:GetPos(), damageToDeal * 0.005, 2, 3, damageToDeal * 5)
end

function ENT:OnTakeDamage(dmg)
    local damage = dmg:GetDamage()
    
    if dmg:IsBulletDamage() or dmg:IsDamageType(DMG_CLUB) or dmg:IsDamageType(DMG_SLASH) then
        if self.FatHitGroup == HITGROUP_HEAD then -- something could go here 
        else
            damage = damage * (4 - self.IsFatSkinned)
            local pitch = math.random(70, 100)
            self:EmitSound("npc/antlion_grub/squashed.wav", 150, pitch, 0.9, CHAN_BODY)
        end
    end

    if damage > 15 then
        dmg:SetDamage(damage)
        return BaseClass.OnTakeDamage(self, dmg)
    end
    
    return false
end