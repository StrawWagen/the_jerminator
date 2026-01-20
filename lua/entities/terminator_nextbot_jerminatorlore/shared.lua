AddCSLuaFile()

ENT.Base = "terminator_nextbot_jerminator_realistic"
DEFINE_BASECLASS( ENT.Base )
ENT.PrintName = "Lore Accurate Jerma"
ENT.Spawnable = false
list.Set( "NPC", "terminator_nextbot_jerminatorlore", {
    Name = "Lore Accurate Jerma",
    Class = "terminator_nextbot_jerminatorlore",
    Category = "Terminator Nextbot",
} )

if CLIENT then
    language.Add( "terminator_nextbot_jerminatorlore", ENT.PrintName )
    return
end

function ENT:EnemyIsLethalInMelee()
    local enemy = self:GetEnemy()
    return IsValid( enemy ) and self.IsSeeEnemy
end

ENT.IsFodder = false
ENT.CoroutineThresh = terminator_Extras.baseCoroutineThresh / 10

ENT.term_SoundLevelShift = 15

ENT.WalkSpeed = 90
ENT.MoveSpeed = 250
ENT.RunSpeed = 420
ENT.TERM_WEAPON_PROFICIENCY = WEAPON_PROFICIENCY_AVERAGE
ENT.AccelerationSpeed = 2000
ENT.JumpHeight = 70 * 2
ENT.FistDamageMul = 0.75
ENT.ThrowingForceMul = 1.0
ENT.SpawnHealth = 1500
ENT.MyPhysicsMass = 1000
ENT.CanUseStuff = nil

ENT.FootstepClomping = true
ENT.duelEnemyTimeoutMul = 10

-- Lore Accurate Jerma's containment breach settings
ENT.BreachRange = 600
ENT.BreachConeAngle = 70
ENT.Burst1Damage = 20
ENT.Burst2Damage = 35
ENT.Burst3Damage = 50

ENT.MySpecialActions = {
    ["ContainmentBreach"] = {
        inBind = IN_GRENADE1,
        drawHint = true,
        name = "Containment Breach",
        desc = "The Jerma has breached containment",
        ratelimit = 8,
        
        svAction = function( driveController, driver, bot )
            -- Store attack data
            bot.BreachActive = true
            bot.BreachStartTime = CurTime()
            
            -- Store the direction we're facing at the start and lock it
            bot.BreachLockedAngles = bot:GetAngles()
            bot.BreachLockedForward = bot:GetForward()
            
            -- Store original speeds and stop movement completely
            bot.StoredWalkSpeed = bot.WalkSpeed
            bot.StoredMoveSpeed = bot.MoveSpeed
            bot.StoredRunSpeed = bot.RunSpeed
            
            bot.WalkSpeed = 0
            bot.MoveSpeed = 0
            bot.RunSpeed = 0
            
            -- Stop current velocity
            bot.loco:SetVelocity( Vector( 0, 0, 0 ) )
            
            -- Pick a random taunt animation - dance or muscle
            local tauntAnim = math.random( 1, 2 ) == 1 and ACT_GMOD_TAUNT_DANCE or ACT_GMOD_TAUNT_MUSCLE
            bot:DoGesture( tauntAnim, 0.8, true )
            
            -- BURST 1 - Moderate damage
            timer.Simple( 0.5, function()
                if not IsValid( bot ) then return end
                bot.loco:SetVelocity( Vector( 0, 0, 0 ) )
                bot:SetAngles( bot.BreachLockedAngles )
                bot:PerformBurst( 1 )
            end )
            
            -- BURST 2 - Heavy damage
            timer.Simple( 1.5, function()
                if not IsValid( bot ) then return end
                bot.loco:SetVelocity( Vector( 0, 0, 0 ) )
                bot:SetAngles( bot.BreachLockedAngles )
                bot:PerformBurst( 2 )
            end )
            
            -- BURST 3 - Heaviest damage
            timer.Simple( 2.5, function()
                if not IsValid( bot ) then return end
                bot.loco:SetVelocity( Vector( 0, 0, 0 ) )
                bot:SetAngles( bot.BreachLockedAngles )
                bot:PerformBurst( 3 )
                
                -- Restore movement
                bot.WalkSpeed = bot.StoredWalkSpeed
                bot.MoveSpeed = bot.StoredMoveSpeed
                bot.RunSpeed = bot.StoredRunSpeed
                bot.BreachActive = false
                bot.BreachLockedAngles = nil
                bot.BreachLockedForward = nil
            end )
        end,
    },
}

function ENT:CreateBurstSpotlight( brightness, fov, distance, duration )
    local spotlight = ents.Create( "env_projectedtexture" )
    if not IsValid( spotlight ) then return end
    
    local eyePos = self:EyePos()
    local forward = self.BreachLockedForward or self:GetForward()
    local ang = forward:Angle()
    
    spotlight:SetPos( eyePos + forward * 10 )
    spotlight:SetAngles( ang )
    spotlight:SetKeyValue( "enableshadows", "1" )
    spotlight:SetKeyValue( "farz", tostring( distance ) )
    spotlight:SetKeyValue( "nearz", "4" )
    spotlight:SetKeyValue( "lightfov", tostring( fov ) )
    spotlight:SetKeyValue( "lightcolor", "255 255 255 " .. tostring( brightness ) )
    spotlight:SetKeyValue( "brightnessscale", "8" )
    spotlight:SetKeyValue( "texturename", "effects/flashlight/soft" )
    spotlight:SetParent( self )
    spotlight:Spawn()
    spotlight:Fire( "TurnOn" )
    
    -- Store for cleanup
    self.ActiveSpotlights = self.ActiveSpotlights or {}
    table.insert( self.ActiveSpotlights, spotlight )
    
    -- Fade out effect
    local steps = 10
    local stepTime = duration / steps
    local originalBrightness = brightness
    
    for i = 1, steps do
        timer.Simple( stepTime * i, function()
            if IsValid( spotlight ) then
                local newBrightness = originalBrightness * ( 1 - ( i / steps ) )
                spotlight:SetKeyValue( "lightcolor", "255 255 255 " .. tostring( newBrightness ) )
            end
        end )
    end
    
    timer.Simple( duration, function()
        if IsValid( spotlight ) then 
            spotlight:Remove() 
        end
    end )
    
    return spotlight
end

function ENT:PerformBurst( burstNum )
    local eyePos = self:EyePos()
    local selfPos = self:GetPos()
    local forward = self.BreachLockedForward or self:GetForward()
    local damage
    local spotlightBrightness, spotlightFOV, spotlightDistance, spotlightDuration
    
    if burstNum == 1 then
        damage = self.Burst1Damage
        spotlightBrightness = 4000
        spotlightFOV = self.BreachConeAngle
        spotlightDistance = self.BreachRange
        spotlightDuration = 0.6
        self:EmitSound( "weapons/stunstick/stunstick_impact2.wav", 95, 100 )
    elseif burstNum == 2 then
        damage = self.Burst2Damage
        spotlightBrightness = 6000
        spotlightFOV = self.BreachConeAngle + 10
        spotlightDistance = self.BreachRange + 100
        spotlightDuration = 0.7
        self:EmitSound( "weapons/stunstick/stunstick_impact1.wav", 100, 90 )
    else -- Burst 3
        damage = self.Burst3Damage
        spotlightBrightness = 10000
        spotlightFOV = self.BreachConeAngle + 20
        spotlightDistance = self.BreachRange + 200
        spotlightDuration = 0.9
        self:EmitSound( "ambient/explosions/explode_4.wav", 105, 100 )
    end
    
    -- Create the main spotlight burst
    self:CreateBurstSpotlight( spotlightBrightness, spotlightFOV, spotlightDistance, spotlightDuration )
    
    -- Screen shake for nearby players
    util.ScreenShake( selfPos, 5 * burstNum, 5, 0.5, 500 )
    
    -- Find and damage entities in cone
    local nearbyEnts = ents.FindInSphere( eyePos, self.BreachRange )
    
    for _, ent in ipairs( nearbyEnts ) do
        if ent == self then continue end
        if not ( ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot() ) then continue end
        if self:Disposition( ent ) == D_LI then continue end
        
        local entPos = ent:WorldSpaceCenter()
        local toEnt = ( entPos - eyePos ):GetNormalized()
        local dot = forward:Dot( toEnt )
        local angleToEnt = math.deg( math.acos( math.Clamp( dot, -1, 1 ) ) )
        
        if angleToEnt <= self.BreachConeAngle / 2 then
            local tr = util.TraceLine( {
                start = eyePos,
                endpos = entPos,
                filter = self,
                mask = MASK_SHOT
            } )
            
            if tr.Entity == ent or tr.Fraction > 0.9 then
                local dmg = DamageInfo()
                dmg:SetDamage( damage )
                dmg:SetDamageType( DMG_DISSOLVE )
                dmg:SetAttacker( self )
                dmg:SetInflictor( self )
                dmg:SetDamagePosition( entPos )
                dmg:SetDamageForce( toEnt * damage * 50 )
                ent:TakeDamageInfo( dmg )
            end
        end
    end
end

ENT.MyClassTask = {
    OnCreated = function( self, data )
    end,
    
    BehaveUpdatePriority = function( self, data )
        if self.BreachActive then return end
        
        local enemy = self:GetEnemy()
        if not IsValid( enemy ) then return end
        if not self.IsSeeEnemy then return end
        
        local dist = self.DistToEnemy or self:GetPos():Distance( enemy:GetPos() )
        
        if dist < self.BreachRange and dist > 150 then
            if self:CanTakeAction( "ContainmentBreach" ) then
                self:TakeAction( "ContainmentBreach" )
                return
            end
        end
    end,
    
    BehaveUpdateMotion = function( self, data )
        -- Force stop movement and looking during breach
        if self.BreachActive then
            self.loco:SetVelocity( Vector( 0, 0, 0 ) )
            
            -- Lock angles to prevent looking around
            if self.BreachLockedAngles then
                self:SetAngles( self.BreachLockedAngles )
                self.loco:FaceTowards( self:GetPos() + self.BreachLockedForward * 100 )
            end
        end
    end,
    
    Think = function( self, data )
        -- Force angles during breach in Think as well for extra certainty
        if self.BreachActive and self.BreachLockedAngles then
            self:SetAngles( self.BreachLockedAngles )
        end
    end,
    
    OnRemoved = function( self, data )
        -- Cleanup any active spotlights
        if self.ActiveSpotlights then
            for _, spotlight in ipairs( self.ActiveSpotlights ) do
                if IsValid( spotlight ) then
                    spotlight:Remove()
                end
            end
        end
    end,

}
