AddCSLuaFile()

ENT.Base = "terminator_nextbot_jerminator_realistic"
DEFINE_BASECLASS( ENT.Base )
ENT.PrintName = "Jerma991"
ENT.Spawnable = false
list.Set( "NPC", "terminator_nextbot_jerminatorwizard", {
    Name = "Jerma991",
    Class = "terminator_nextbot_jerminatorwizard",
    Category = "Terminator Nextbot",
} )

if CLIENT then
    language.Add( "terminator_nextbot_jerminatorwizard", ENT.PrintName )
    return
end

function ENT:EnemyIsLethalInMelee()
    local enemy = self:GetEnemy()
    return IsValid( enemy ) and self.IsSeeEnemy
end

ENT.IsFodder = true
ENT.CoroutineThresh = terminator_Extras.baseCoroutineThresh / 10

ENT.term_SoundLevelShift = 10

ENT.WalkSpeed = 75
ENT.MoveSpeed = 200
ENT.RunSpeed = 360
ENT.TERM_WEAPON_PROFICIENCY = WEAPON_PROFICIENCY_POOR
ENT.AccelerationSpeed = 1500
ENT.JumpHeight = 70 * 1.5
ENT.FistDamageMul = 0.25
ENT.ThrowingForceMul = 0.5
ENT.SpawnHealth = 250
ENT.MyPhysicsMass = 150

ENT.FootstepClomping = false
ENT.duelEnemyTimeoutMul = 5

-- Wizard specific settings
ENT.LightningRange = 1200 -- Same as fireball now
ENT.LightningDamage = 35
ENT.LightningBoltCount = 5
ENT.FireballRange = 1200
ENT.FireballDamage = 50
ENT.FireballSpeed = 1500

-- Generate a random vibrant color for lightning
local function RandomLightningColor()
    local colors = {
        Angle( 255, math.random( 0, 100 ), math.random( 0, 100 ) ),   -- Red
        Angle( math.random( 0, 100 ), 255, math.random( 0, 100 ) ),   -- Green
        Angle( math.random( 0, 100 ), math.random( 0, 100 ), 255 ),   -- Blue
        Angle( 255, 255, math.random( 0, 100 ) ),                      -- Yellow
        Angle( 255, math.random( 0, 100 ), 255 ),                      -- Magenta
        Angle( math.random( 0, 100 ), 255, 255 ),                      -- Cyan
        Angle( 255, 150, math.random( 0, 50 ) ),                       -- Orange
        Angle( 180, math.random( 0, 100 ), 255 ),                      -- Purple
        Angle( 255, 100, 200 ),                                         -- Pink
        Angle( 100, 255, 150 ),                                         -- Mint
    }
    return colors[ math.random( 1, #colors ) ]
end

ENT.MySpecialActions = {
    ["LightningStrike"] = {
        inBind = IN_GRENADE1,
        drawHint = true,
        name = "Rainbow Lightning",
        desc = "Strikes enemy with chaotic rainbow lightning",
        ratelimit = 2,
        
        svAction = function( driveController, driver, bot )
            local enemy = bot:GetEnemy()
            local targetPos
            
            if IsValid( enemy ) then
                targetPos = enemy:WorldSpaceCenter()
            else
                local tr = util.TraceLine( {
                    start = bot:EyePos(),
                    endpos = bot:EyePos() + bot:GetAimVector() * bot.LightningRange,
                    filter = bot,
                    mask = MASK_SHOT
                } )
                targetPos = tr.HitPos
            end
            
            local startPos = bot:GetAttachment( bot:LookupAttachment( "anim_attachment_RH" ) )
            startPos = startPos and startPos.Pos or bot:EyePos() + bot:GetForward() * 20 + bot:GetRight() * 15
            
            -- Create multiple rainbow lightning bolts
            for i = 1, bot.LightningBoltCount do
                timer.Simple( ( i - 1 ) * 0.05, function()
                    if not IsValid( bot ) then return end
                    
                    -- Random offset for each bolt
                    local offset = VectorRand() * 30
                    local boltTarget = targetPos + offset
                    
                    -- Create lightning effect with random color
                    local fx = EffectData()
                    fx:SetOrigin( startPos )
                    fx:SetStart( boltTarget )
                    fx:SetNormal( ( boltTarget - startPos ):GetNormalized() )
                    fx:SetScale( 1.5 )
                    fx:SetMagnitude( 10 )
                    fx:SetRadius( 30 )
                    fx:SetAngles( RandomLightningColor() )
                    fx:SetDamageType( 3 )
                    fx:SetEntity( bot )
                    fx:SetFlags( 0 )
                    util.Effect( "eff_term_goodarc", fx )
                    
                    -- Play sound for first bolt only
                    if i == 1 then
                        bot:EmitSound( "ambient/energy/zap" .. math.random( 1, 9 ) .. ".wav", 90, math.random( 90, 110 ) )
                    end
                end )
            end
            
            -- Deal damage to entities near the target (delayed to match visual)
            timer.Simple( 0.1, function()
                if not IsValid( bot ) then return end
                
                local damageEnts = ents.FindInSphere( targetPos, 60 )
                for _, ent in ipairs( damageEnts ) do
                    if ent ~= bot and ( ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot() ) then
                        local dmg = DamageInfo()
                        dmg:SetDamage( bot.LightningDamage )
                        dmg:SetDamageType( DMG_DISSOLVE )
                        dmg:SetAttacker( bot )
                        dmg:SetInflictor( bot )
                        dmg:SetDamagePosition( targetPos )
                        ent:TakeDamageInfo( dmg )
                    end
                end
            end )
            
            bot:DoGesture( ACT_GMOD_GESTURE_RANGE_FRENZY, 1.5 )
        end,
    },
    
    ["Fireball"] = {
        inBind = IN_GRENADE2,
        drawHint = true,
        name = "Fireball",
        desc = "Launches a fireball at enemy",
        ratelimit = 3,
        
        svAction = function( driveController, driver, bot )
            local startPos = bot:GetAttachment( bot:LookupAttachment( "anim_attachment_RH" ) )
            startPos = startPos and startPos.Pos or bot:EyePos() + bot:GetForward() * 20 + bot:GetRight() * 15
            
            local aimDir
            local enemy = bot:GetEnemy()
            
            if IsValid( enemy ) then
                aimDir = ( enemy:WorldSpaceCenter() - startPos ):GetNormalized()
            else
                aimDir = bot:GetAimVector()
            end
            
            local fireball = ents.Create( "prop_physics" )
            if not IsValid( fireball ) then return end
            
            fireball:SetModel( "models/props_junk/popcan01a.mdl" )
            fireball:SetPos( startPos )
            fireball:SetAngles( aimDir:Angle() )
            fireball:Spawn()
            fireball:SetNoDraw( true )
            fireball:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
            
            local phys = fireball:GetPhysicsObject()
            if IsValid( phys ) then
                phys:SetMass( 1 )
                phys:SetVelocity( aimDir * bot.FireballSpeed )
                phys:EnableGravity( false )
            end
            
            local fireEffect = ents.Create( "env_fire_trail" )
            if IsValid( fireEffect ) then
                fireEffect:SetPos( startPos )
                fireEffect:SetParent( fireball )
                fireEffect:Spawn()
            end
            
            local light = ents.Create( "light_dynamic" )
            if IsValid( light ) then
                light:SetKeyValue( "brightness", "6" )
                light:SetKeyValue( "distance", "300" )
                light:SetKeyValue( "_light", "255 100 0 255" )
                light:SetPos( startPos )
                light:SetParent( fireball )
                light:Spawn()
                light:Fire( "TurnOn" )
            end
            
            bot:EmitSound( "ambient/fire/gascan_ignite1.wav", 80 )
            
            local damage = bot.FireballDamage
            local owner = bot
            
            fireball:CallOnRemove( "CleanupEffects", function()
                if IsValid( fireEffect ) then fireEffect:Remove() end
                if IsValid( light ) then light:Remove() end
            end )
            
            timer.Simple( 0.1, function()
                if not IsValid( fireball ) then return end
                
                fireball.PhysicsCollide = function( self, data, phys )
                    local hitPos = data.HitPos
                    
                    local effectData = EffectData()
                    effectData:SetOrigin( hitPos )
                    effectData:SetScale( 1 )
                    util.Effect( "Explosion", effectData )
                    
                    local damageEnts = ents.FindInSphere( hitPos, 100 )
                    for _, ent in ipairs( damageEnts ) do
                        if ent ~= owner and ( ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot() ) then
                            local dmg = DamageInfo()
                            dmg:SetDamage( damage )
                            dmg:SetDamageType( DMG_BURN + DMG_BLAST )
                            dmg:SetAttacker( owner )
                            dmg:SetInflictor( owner )
                            dmg:SetDamagePosition( hitPos )
                            ent:TakeDamageInfo( dmg )
                            ent:Ignite( 5 )
                        end
                    end
                    
                    local fire = ents.Create( "env_fire" )
                    if IsValid( fire ) then
                        fire:SetPos( hitPos )
                        fire:SetKeyValue( "health", "30" )
                        fire:SetKeyValue( "firesize", "64" )
                        fire:SetKeyValue( "fireattack", "4" )
                        fire:SetKeyValue( "damagescale", "1" )
                        fire:SetKeyValue( "spawnflags", "281" )
                        fire:Spawn()
                        fire:Activate()
                        fire:Fire( "StartFire", "", 0 )
                        
                        timer.Simple( 4, function()
                            if IsValid( fire ) then fire:Remove() end
                        end )
                    end
                    
                    fireball:Remove()
                end
                
                fireball:AddCallback( "PhysicsCollide", fireball.PhysicsCollide )
            end )
            
            timer.Simple( 5, function()
                if IsValid( fireball ) then fireball:Remove() end
            end )
            
            bot:DoGesture( ACT_GMOD_GESTURE_RANGE_ZOMBIE, 1.2 )
        end,
    },
}

ENT.MyClassTask = {
    OnCreated = function( self, data )
        data.lastAttackTime = 0
        
        -- Create purple wizard cone hat
        timer.Simple( 0.1, function()
            if not IsValid( self ) then return end
            
            local cone = ents.Create( "prop_dynamic" )
            if IsValid( cone ) then
                cone:SetModel( "models/props_junk/trafficcone001a.mdl" )
                cone:SetPos( self:GetPos() + Vector( 0, 0, 80 ) )
                cone:Spawn()
                cone:SetColor( Color( 150, 0, 255 ) )
                cone:SetMaterial( "models/debug/debugwhite" )
                cone:SetModelScale( 0.69 )
                
                local headBone = self:LookupBone( "ValveBiped.Bip01_Head1" )
                if headBone then
                    cone:FollowBone( self, headBone )
                    cone:SetLocalPos( Vector( 14.72, 5.31, 0 ) )
                    cone:SetLocalAngles( Angle( 90, 19.06, 0 ) )
                else
                    cone:SetParent( self )
                    cone:SetLocalPos( Vector( 14.72, 5.31, 0 ) )
                    cone:SetLocalAngles( Angle( 90, 19.06, 0 ) )
                end
                
                self.WizardCone = cone
            end
        end )
    end,
    
    BehaveUpdatePriority = function( self, data )
        local enemy = self:GetEnemy()
        if not IsValid( enemy ) then return end
        if not self.IsSeeEnemy then return end
        
        local dist = self.DistToEnemy or self:GetPos():Distance( enemy:GetPos() )
        
        -- Lightning now has same range as fireball, prioritize it at closer range
        if dist < self.LightningRange and dist > 200 then
            if self:CanTakeAction( "LightningStrike" ) then
                self:TakeAction( "LightningStrike" )
                return
            end
        end
        
        if dist < self.FireballRange and dist > 300 then
            if self:CanTakeAction( "Fireball" ) then
                self:TakeAction( "Fireball" )
                return
            end
        end
    end,
    
    EnemyFound = function( self, data, newEnemy, secondsSinceLastEnemy )
        self:EmitSound( "vo/npc/male01/answer16.wav" )
    end,
    
    OnRemoved = function( self, data )
        if IsValid( self.WizardCone ) then
            self.WizardCone:Remove()
        end
    end,
    
    OnKilled = function( self, data, attacker, inflictor, ragdoll )
        if IsValid( self.WizardCone ) then
            self.WizardCone:Remove()
        end
    end,
}