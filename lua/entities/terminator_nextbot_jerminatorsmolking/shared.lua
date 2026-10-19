
AddCSLuaFile()

ENT.Base = "terminator_nextbot_jerminatorsmol"
DEFINE_BASECLASS( ENT.Base )
ENT.PrintName = "The Goblin King Jerma"
ENT.Spawnable = false
terminator_Extras.RegisterNPC( "terminator_nextbot_jerminatorsmolking", ENT, { Spawnable = false } )

if CLIENT then return end

ENT.IsFodder = false
ENT.SpawnHealth = 10000
ENT.ExtraSpawnHealthPerPlayer = 2500

ENT.FistDamageMul = 1

local crownScale = 1
local crownMaterial = "models/debug/debugwhite" -- matte, reads as spray paint
local crownColor = Color( 255, 190, 60 ) -- gold
local crownLocalPos = Vector( 14.72, 5.31, 0 )
local crownLocalAng = Angle( 90, 19.06, 0 )

-- junk he found and painted. pos/ang fall back to the above, which were tuned on the metal pot
local crowns = {
    { model = "models/props_c17/metalPot001a.mdl" },
    { model = "models/props_interiors/pot01a.mdl", pos = Vector( 12.25, 5.31, 0 ) },
    { model = "models/props_junk/metalbucket01a.mdl", pos = Vector( 17, 5.31, 0 ) },
    { model = "models/props_junk/MetalBucket02a.mdl", pos = Vector( 17, 5.31, 0 ) },
    { model = "models/props_junk/sawblade001a.mdl", pos = Vector( 6.5, 5.31, 0 ) },
}

local function CreateKingCrown( bot )
    local crown = ents.Create( "prop_dynamic" )
    if not IsValid( crown ) then return end

    local picked = crowns[math.random( #crowns )]

    crown:SetModel( picked.model )
    crown:SetPos( bot:GetPos() + Vector( 0, 0, 80 ) )
    crown:Spawn()
    crown:SetModelScale( crownScale )
    crown:SetMaterial( crownMaterial )
    crown:SetColor( crownColor )

    local headBone = bot:LookupBone( "ValveBiped.Bip01_Head1" )
    if headBone then
        crown:FollowBone( bot, headBone )

    else
        crown:SetParent( bot )

    end
    crown:SetLocalPos( picked.pos or crownLocalPos )
    crown:SetLocalAngles( picked.ang or crownLocalAng )

    bot:DeleteOnRemove( crown )
    bot.KingCrown = crown

end

local function DropKingCrown( bot )
    if not IsValid( bot.KingCrown ) then return end

    local crownPos = bot.KingCrown:GetPos()
    local crownAng = bot.KingCrown:GetAngles()
    local crownModel = bot.KingCrown:GetModel()

    SafeRemoveEntity( bot.KingCrown )
    bot.KingCrown = nil

    local droppedCrown = ents.Create( "prop_physics" )
    if not IsValid( droppedCrown ) then return end

    droppedCrown:SetModel( crownModel )
    droppedCrown:SetPos( crownPos )
    droppedCrown:SetAngles( crownAng )
    droppedCrown:Spawn()
    droppedCrown:SetModelScale( crownScale )
    droppedCrown:SetMaterial( crownMaterial )
    droppedCrown:SetColor( crownColor )

    local phys = droppedCrown:GetPhysicsObject()
    if IsValid( phys ) then
        phys:SetVelocity( Vector( math.Rand( -50, 50 ), math.Rand( -50, 50 ), 100 ) )
        phys:AddAngleVelocity( VectorRand() * 200 )

    end

    SafeRemoveEntityDelayed( droppedCrown, 30 )

end

ENT.MyClassTask = {
    OnCreated = function( self, _data )
        timer.Simple( 0.1, function()
            if not IsValid( self ) then return end
            CreateKingCrown( self )

        end )
    end,

    OnKilled = function( self, _data, _attacker, _inflictor, _ragdoll )
        DropKingCrown( self )

    end,
}
