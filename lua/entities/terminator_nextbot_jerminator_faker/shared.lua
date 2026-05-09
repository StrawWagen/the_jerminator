AddCSLuaFile()

ENT.Base = "terminator_nextbot_jerminator_realistic"
DEFINE_BASECLASS( ENT.Base )
ENT.PrintName = "Jerma992"
ENT.Spawnable = false
list.Set( "NPC", "terminator_nextbot_jerminator_faker", {
    Name = "Jerma992",
    Class = "terminator_nextbot_jerminator_faker",
    Category = "Terminator Nextbot",
} )

if CLIENT then
    language.Add( "terminator_nextbot_jerminator_faker", ENT.PrintName )

    local entMeta = FindMetaTable( "Entity" )

    hook.Add( "Think", "jerma992_memory_rendering", function()
        for _, ent in ipairs( ents.GetAll() ) do
            if not ent:GetNWBool( "jerma992_isMemory", false ) then continue end
            if ent._memoryDrawInjected then continue end
            if not ent:GetModel() or ent:GetModel() == "" then continue end
            ent._memoryDrawInjected = true
            ent.Draw = function( self )
                render.SetBlend( 0.31 )
                entMeta.DrawModel( self )
                render.SetBlend( 1 )
            end
        end
    end )

    return
end

local MIMIC_MAT   = "jerma985/jermamimictrue"
local FALSE_MAT   = "jerma985/jermamimicfalse"
local MIMIC_SCALE = 1.5

local FALSE_THRESHOLD = 1 / 3
local TRUE_THRESHOLD  = 1 / 4

local CRACK_SOUNDS = {
    "physics/body/body_medium_break1.wav",
    "physics/body/body_medium_break2.wav",
    "physics/body/body_medium_break4.wav",
    "physics/flesh/flesh_bloody_impact3.wav",
    "physics/flesh/flesh_bloody_impact4.wav",
    "physics/flesh/flesh_bloody_impact5.wav",
    "physics/flesh/flesh_impact_bullet4.wav",
    "physics/flesh/flesh_impact_bullet5.wav",
}

local TRANSFORM_SOUNDS = {
    "npc/zombie/zombie_pain1.wav",
    "npc/zombie/zombie_pain2.wav",
    "npc/zombie/zombie_pain3.wav",
}

local ORIG_IDLE  = ""
local ORIG_ANGRY = "jerma985/jermasusimproved"
local ORIG_PAIN  = "jerma985/jermasour"

local function emitBloodAt( pos, normal )
    local ed = EffectData()
    ed:SetOrigin( pos )
    ed:SetNormal( normal or Vector( 0, 0, 1 ) )
    ed:SetScale( 5 )
    ed:SetMagnitude( 5 )
    ed:SetRadius( 14 )
    util.Effect( "BloodImpact", ed, true, true )
end

local function emitGroundBlood( pos )
    local ed = EffectData()
    ed:SetOrigin( pos - Vector( 0, 0, 10 ) )
    ed:SetNormal( Vector( 0, 0, 1 ) )
    ed:SetScale( 10 )
    ed:SetMagnitude( 10 )
    ed:SetRadius( 25 )
    util.Effect( "BloodImpact", ed, true, true )
end

local function splatterBloodOnSelf( ent, intensity )
    if not IsValid( ent ) then return end
    intensity = intensity or 1

    local boneCount = ent:GetBoneCount()
    if not boneCount or boneCount <= 0 then return end

    local hits = math.floor( 4 * intensity )
    for i = 1, hits do
        local bone = math.random( 0, boneCount - 1 )
        local bonePos = ent:GetBonePosition( bone )
        if bonePos then
            emitBloodAt( bonePos, VectorRand() )
        end
    end

    emitGroundBlood( ent:GetPos() )
end

local function applyBoneCounterscale( ent, modelScale )
    if not IsValid( ent ) then return end
    local inv = 1 / modelScale
    local boneCount = ent:GetBoneCount()
    if not boneCount or boneCount <= 0 then return end
    for i = 0, boneCount - 1 do
        ent:ManipulateBoneScale( i, Vector( inv, inv, inv ) )
    end
end

local function getJermaClasses( self )
    local classes = {}
    local myClass = self:GetClass()
    local npcList = list.Get( "NPC" )
    local prefix  = "terminator_nextbot_jerm"
    for class, _ in pairs( npcList ) do
        if string.sub( class, 1, #prefix ) == prefix and class ~= myClass then
            table.insert( classes, class )
        end
    end
    return classes
end

local function spawnMemory( bot )
    local classes = getJermaClasses( bot )
    if #classes == 0 then return end

    local chosenClass = classes[ math.random( #classes ) ]
    local spawnPos    = bot:GetPos() + bot:GetForward() * 60 + Vector( 0, 0, 5 )

    local memory = ents.Create( chosenClass )
    if not IsValid( memory ) then return end

    memory:SetNWBool( "jerma992_isMemory", true )
    memory:SetPos( spawnPos )
    memory:SetAngles( bot:GetAngles() )
    memory:Spawn()
    memory:Activate()

    timer.Simple( 0.15, function()
        if not IsValid( memory ) then return end
        local quarterHP = math.max( 1, math.floor( memory:GetMaxHealth() * 0.25 ) )
        memory:SetMaxHealth( quarterHP )
        memory:SetHealth( quarterHP )
    end )
end

local function applyFalseSkin( self )
    self.Jerm_IdleFace  = FALSE_MAT
    self.Jerm_AngryFace = FALSE_MAT
    self.Jerm_PainFace  = FALSE_MAT
    self:SetMaterial( FALSE_MAT )

    self:EmitSound( "physics/flesh/flesh_bloody_impact3.wav", 65, 110, 0.5 )
    util.ScreenShake( self:GetPos(), 2, 1.5, 0.2, 350 )

    self:SetColor( Color( 210, 160, 160, 255 ) )
    timer.Simple( 0.35, function()
        if not IsValid( self ) then return end
        self:SetColor( Color( 255, 255, 255, 255 ) )
    end )
end

local function removeFalseSkin( self )
    self.Jerm_IdleFace  = ORIG_IDLE
    self.Jerm_AngryFace = ORIG_ANGRY
    self.Jerm_PainFace  = ORIG_PAIN
    self:SetMaterial( ORIG_IDLE )
end

local function doTransformSequence( self )
    if not IsValid( self ) then return end

    local steps = {
        { t = 0.0, fn = function()
            if not IsValid( self ) then return end
            self:EmitSound( CRACK_SOUNDS[ math.random( #CRACK_SOUNDS ) ], 85, math.random( 90, 110 ), 1 )
            splatterBloodOnSelf( self, 0.75 )
            util.ScreenShake( self:GetPos(), 5, 4, 0.3, 500 )
        end },

        { t = 0.3, fn = function()
            if not IsValid( self ) then return end
            self:EmitSound( CRACK_SOUNDS[ math.random( #CRACK_SOUNDS ) ], 88, math.random( 75, 95 ), 1 )
            self:EmitSound( TRANSFORM_SOUNDS[ math.random( #TRANSFORM_SOUNDS ) ], 88, math.random( 80, 95 ), 1, CHAN_VOICE )
            splatterBloodOnSelf( self, 1 )
            util.ScreenShake( self:GetPos(), 8, 6, 0.35, 700 )
        end },

        { t = 0.65, fn = function()
            if not IsValid( self ) then return end
            self:EmitSound( CRACK_SOUNDS[ math.random( #CRACK_SOUNDS ) ], 90, math.random( 65, 85 ), 1 )
            splatterBloodOnSelf( self, 1.25 )
            util.ScreenShake( self:GetPos(), 11, 8, 0.45, 900 )
        end },

        { t = 0.95, fn = function()
            if not IsValid( self ) then return end
            self:EmitSound( CRACK_SOUNDS[ math.random( #CRACK_SOUNDS ) ], 92, math.random( 55, 75 ), 1 )
            splatterBloodOnSelf( self, 1.5 )
        end },

        { t = 1.2, fn = function()
            if not IsValid( self ) then return end

            self:SetModelScale( MIMIC_SCALE, 0.55 )

            timer.Simple( 0.05, function()
                if not IsValid( self ) then return end
                applyBoneCounterscale( self, MIMIC_SCALE )
            end )

            self.Jerm_IdleFace  = MIMIC_MAT
            self.Jerm_AngryFace = MIMIC_MAT
            self.Jerm_PainFace  = MIMIC_MAT
            self:SetMaterial( MIMIC_MAT )

            local newMax = self:GetMaxHealth() * 2
            self:SetMaxHealth( newMax )
            self:SetHealth( newMax )
            self.HealthRegen         = self.HealthRegen * 2
            self.HealthRegenInterval = self.HealthRegenInterval * 0.5

            self:ReallyAnger( 60 )

            self:EmitSound( TRANSFORM_SOUNDS[ math.random( #TRANSFORM_SOUNDS ) ], 100, math.random( 40, 55 ), 1, CHAN_VOICE )
            self:EmitSound( CRACK_SOUNDS[ math.random( #CRACK_SOUNDS ) ], 100, 45, 1 )

            util.ScreenShake( self:GetPos(), 22, 18, 0.9, 1600 )

            for i = 1, 16 do
                timer.Simple( i * 0.055, function()
                    if not IsValid( self ) then return end
                    splatterBloodOnSelf( self, 1.5 )
                end )
            end
        end },
    }

    for _, step in ipairs( steps ) do
        timer.Simple( step.t, step.fn )
    end
end

ENT.MySpecialActions = {
    ["jerminator_speak"] = {
        inBind    = IN_RELOAD,
        drawHint  = function( bot ) return bot.mimicTriggered == true end,
        name      = "Memory",
        desc      = "Summon a faded memory of another Jerma",
        ratelimit = 20,
        svAction  = function( _drive, _driver, bot )
            spawnMemory( bot )
        end,
    },
}

ENT.MyClassTask = {

    OnCreated = function( self, data )
        self.mimicTriggered  = false
        data.falseSkinActive = false
    end,

    OnDamaged = function( self, data, dmg )
        if self.mimicTriggered then return end

        local maxHP       = self:GetMaxHealth()
        local hp          = self:Health()
        local falseThresh = maxHP * FALSE_THRESHOLD
        local trueThresh  = maxHP * TRUE_THRESHOLD

        if hp <= trueThresh then
            self.mimicTriggered  = true
            data.falseSkinActive = false
            doTransformSequence( self )
            return
        end

        if hp <= falseThresh and not data.falseSkinActive then
            data.falseSkinActive = true
            applyFalseSkin( self )
            return
        end

        if hp > falseThresh and data.falseSkinActive then
            data.falseSkinActive = false
            removeFalseSkin( self )
        end
    end,

    BehaveUpdatePriority = function( self, data )
        if not self.mimicTriggered then return end
        if not self:CanTakeAction( "jerminator_speak" ) then return end

        local enemy = self:GetEnemy()
        if not IsValid( enemy ) then return end

        self:TakeAction( "jerminator_speak" )
    end,

}
