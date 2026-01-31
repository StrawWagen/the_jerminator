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

-- never get close to enemy
function ENT:EnemyIsLethalInMelee()
    local enemy = self:GetEnemy()
    return IsValid( enemy ) and self.IsSeeEnemy
end

ENT.CoroutineThresh = terminator_Extras.baseCoroutineThresh / 5

ENT.term_SoundLevelShift = 10

ENT.WalkSpeed = 75
ENT.MoveSpeed = 200
ENT.RunSpeed = 360
ENT.TERM_WEAPON_PROFICIENCY = WEAPON_PROFICIENCY_POOR
ENT.AccelerationSpeed = 1500
ENT.JumpHeight = 70 * 6
ENT.Term_Leaps = true
ENT.FistDamageMul = 0.25
ENT.ThrowingForceMul = 0.5
ENT.SpawnHealth = 250
ENT.MyPhysicsMass = 150

ENT.FootstepClomping = false
ENT.duelEnemyTimeoutMul = 5

-- Wizard specific settings
ENT.LightningRange = 1200
ENT.LightningDamage = 35
ENT.LightningBoltCount = 5
ENT.FireballRange = 2500
ENT.FireballDamage = 50
ENT.FireballSpeed = 2000
ENT.CanFindWeaponsOnTheGround = false

-- Pre-defined colors table for rainbow lightning (created once)
local LIGHTNING_COLORS = {
    Angle( 255, 50, 50 ),      -- Red
    Angle( 50, 255, 50 ),      -- Green
    Angle( 50, 50, 255 ),      -- Blue
    Angle( 255, 255, 50 ),     -- Yellow
    Angle( 255, 50, 255 ),     -- Magenta
    Angle( 50, 255, 255 ),     -- Cyan
    Angle( 255, 150, 50 ),     -- Orange
    Angle( 180, 50, 255 ),     -- Purple
    Angle( 255, 100, 200 ),    -- Pink
    Angle( 100, 255, 150 ),    -- Mint
}

local function RandomLightningColor()
    return LIGHTNING_COLORS[ math.random( 1, #LIGHTNING_COLORS ) ]
end

local function GetCastingStartPos( bot )
    local attachment = bot:GetAttachment( bot:LookupAttachment( "anim_attachment_RH" ) )
    if attachment then return attachment.Pos end

    return bot:WorldSpaceCenter() + bot:GetForward() * 20
end

ENT.MySpecialActions = {
    ["LightningStrike"] = {
        inBind = IN_RELOAD,
        drawHint = true,
        name = "Lightning",
        desc = "Rainbow lightning!",
        ratelimit = 2,
        
        svAction = function( driveController, driver, bot )
            local enemy = bot:GetEnemy()
            local targetPos
            
            bot:DoWizardSounds()
            
            bot:DoGesture( ACT_GMOD_GESTURE_RANGE_FRENZY, 1.5 )

            timer.Simple( 0.5, function()
                if not IsValid( bot ) then return end
            
                local startPos = GetCastingStartPos( bot )
            
                if not IsValid( driver ) and IsValid( enemy ) then
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
                
                local tr = util.TraceLine( {
                    start = startPos,
                    endpos = targetPos,
                    filter = bot,
                    mask = MASK_SHOT
                } )
                local hitPos = tr.HitPos
                
                -- Create multiple rainbow lightning bolts
                for i = 1, bot.LightningBoltCount do
                    timer.Simple( ( i - 1 ) * 0.05, function()
                        if not IsValid( bot ) then return end
                        
                        local offset = VectorRand() * 30
                        local boltTarget = hitPos + offset
                        
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
                        
                        if i ~= 1 then return end
                        
                        bot:EmitSound( "ambient/energy/zap" .. math.random( 1, 9 ) .. ".wav", 90, math.random( 90, 110 ) )
                    end )
                end
                
                -- Deal damage to entities near the target
                timer.Simple( 0.1, function()
                    if not IsValid( bot ) then return end
                    
                    local dmg = DamageInfo()
                    dmg:SetDamage( bot.LightningDamage )
                    dmg:SetDamageType( DMG_DISSOLVE + DMG_SHOCK )
                    dmg:SetAttacker( bot )
                    dmg:SetInflictor( bot )
                    dmg:SetDamagePosition( hitPos )
                    
                    util.BlastDamageInfo( dmg, hitPos, 60 )
                end )
            end )
        end,
    },
    
    ["Fireball"] = {
        inBind = IN_ATTACK2,
        drawHint = true,
        name = "Fireball",
        desc = "Launches a fireball at enemy",
        ratelimit = 3,
        
        svAction = function( driveController, driver, bot )
            
            local aimDir
            local enemy = bot:GetEnemy()
            
            bot:DoWizardSounds()
            
            bot:DoGesture( ACT_GMOD_GESTURE_ITEM_THROW, 1.2 )

            timer.Simple( 0.5, function()
                if not IsValid( bot ) then return end
                local startPos = GetCastingStartPos( bot )
            
                if not IsValid( driver ) and IsValid( enemy ) then
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
                    phys:SetMass( 100 )
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
                fireball:EmitSound( "ambient/fire/ignite.wav", 80 )
                
                local damage = bot.FireballDamage
                local owner = bot
                
                fireball:CallOnRemove( "CleanupEffects", function()
                    SafeRemoveEntity( fireEffect )
                    SafeRemoveEntity( light )
                end )
                
                timer.Simple( 0.1, function()
                    if not IsValid( fireball ) then return end
                    
                    fireball.PhysicsCollide = function( self, data, phys )
                        local hitPos = data.HitPos
                        
                        local effectData = EffectData()
                        effectData:SetOrigin( hitPos )
                        effectData:SetScale( 1 )
                        util.Effect( "Explosion", effectData )
                        
                        local attacker = IsValid( owner ) and owner or self

                        -- Use BlastDamageInfo for proper explosion damage
                        local dmg = DamageInfo()
                        dmg:SetDamage( damage )
                        dmg:SetDamageType( DMG_BURN + DMG_BLAST )
                        dmg:SetAttacker( attacker )
                        dmg:SetInflictor( fireball )
                        dmg:SetDamagePosition( hitPos )
                        
                        util.BlastDamageInfo( dmg, hitPos, 100 )
                        
                        local fire = ents.Create( "env_fire" )
                        if not IsValid( fire ) then
                            SafeRemoveEntity( fireball )
                            return
                        end
                        
                        fire:SetPos( hitPos )
                        fire:SetKeyValue( "health", "30" )
                        fire:SetKeyValue( "firesize", "64" )
                        fire:SetKeyValue( "fireattack", "4" )
                        fire:SetKeyValue( "damagescale", "1" )
                        fire:SetKeyValue( "spawnflags", "281" )
                        fire:Spawn()
                        fire:Activate()
                        fire:Fire( "StartFire", "", 0 )

                        timer.Simple( 0.1, function()
                            if not IsValid( fire ) then return end
                            fire:DropToFloor()
                        end )
                        
                        SafeRemoveEntityDelayed( fire, 4 )
                        
                        SafeRemoveEntity( fireball )
                    end
                    
                    fireball:AddCallback( "PhysicsCollide", fireball.PhysicsCollide )
                end )
                
                SafeRemoveEntityDelayed( fireball, 5 )
            end )
        end,
    },
}

function ENT:DoWizardSounds()
    local duration = self:Term_SpeakSoundNow( self:jerm_RandomSoundPath( "shootwizard" ) ) -- speak one line NOW
    timer.Simple( duration, function()
        if not IsValid( self ) then return end
        self:Term_SpeakSound( self:jerm_RandomSoundPath( "shootwizard" ) ) -- and put another wizard line in the queue

    end )
end

local function CreateWizardCone( bot )
    local cone = ents.Create( "prop_dynamic" )
    if not IsValid( cone ) then return end
    
    cone:SetModel( "models/props_junk/trafficcone001a.mdl" )
    cone:SetPos( bot:GetPos() + Vector( 0, 0, 80 ) )
    cone:Spawn()
    cone:SetColor( Color( 150, 0, 255 ) )
    cone:SetMaterial( "models/debug/debugwhite" )
    cone:SetModelScale( 0.69 )
    
    local headBone = bot:LookupBone( "ValveBiped.Bip01_Head1" )
    if headBone then
        cone:FollowBone( bot, headBone )
        cone:SetLocalPos( Vector( 14.72, 5.31, 0 ) )
        cone:SetLocalAngles( Angle( 90, 19.06, 0 ) )
    else
        cone:SetParent( bot )
        cone:SetLocalPos( Vector( 14.72, 5.31, 0 ) )
        cone:SetLocalAngles( Angle( 90, 19.06, 0 ) )
    end
    
    bot:DeleteOnRemove( cone )
    bot.WizardCone = cone
end

local function DropWizardCone( bot )
    if not IsValid( bot.WizardCone ) then return end
    
    local conePos = bot.WizardCone:GetPos()
    local coneAng = bot.WizardCone:GetAngles()
    
    SafeRemoveEntity( bot.WizardCone )
    bot.WizardCone = nil
    
    local droppedCone = ents.Create( "prop_physics" )
    if not IsValid( droppedCone ) then return end
    
    droppedCone:SetModel( "models/props_junk/trafficcone001a.mdl" )
    droppedCone:SetPos( conePos )
    droppedCone:SetAngles( coneAng )
    droppedCone:Spawn()
    droppedCone:SetColor( Color( 150, 0, 255 ) )
    droppedCone:SetMaterial( "models/debug/debugwhite" )
    droppedCone:SetModelScale( 0.69 )
    
    local phys = droppedCone:GetPhysicsObject()
    if IsValid( phys ) then
        phys:SetVelocity( Vector( math.Rand( -50, 50 ), math.Rand( -50, 50 ), 100 ) )
        phys:AddAngleVelocity( VectorRand() * 200 )
    end
    
    SafeRemoveEntityDelayed( droppedCone, 30 )

end

ENT.MyClassTask = {
    OnCreated = function( self, data )
        data.lastAttackTime = 0
        
        timer.Simple( 0.1, function()
            if not IsValid( self ) then return end
            
            CreateWizardCone( self )
        end )
    end,
    
    BehaveUpdatePriority = function( self, data )
        local enemy = self:GetEnemy()
        if not IsValid( enemy ) then return end
        if not self.NothingOrBreakableBetweenEnemy then return end
        if not self:IsReallyAngry() then return end
        
        local dist = self.DistToEnemy or self:GetPos():Distance( enemy:GetPos() )
        
        if dist < self.LightningRange and dist > 100 then
            if not self:CanTakeAction( "LightningStrike" ) then return end
            
            self:TakeAction( "LightningStrike" )
            return
        end
        
        if dist < self.FireballRange and dist > 300 then
            if not self:CanTakeAction( "Fireball" ) then return end
            
            self:TakeAction( "Fireball" )
            return
        end
    end,
    
    OnKilled = function( self, data, attacker, inflictor, ragdoll )
        DropWizardCone( self )
    end,
}