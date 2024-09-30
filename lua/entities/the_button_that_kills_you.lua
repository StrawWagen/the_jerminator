
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName = "The Button that kills you."
ENT.Spawnable = true
ENT.Category = "Jerma985"
ENT.Editable = true

if CLIENT then
    local className = "the_button_that_kills_you"
    language.Add( className, ENT.PrintName )
    killicon.Add( className, "vgui/hud/killicon/" .. className .. ".png", color_white )

end

function ENT:SetupDataTables()

    self:NetworkVar( "Bool", 0, "Pressed" )

    if ( SERVER ) then
        self:SetPressed( false )
    end

end

function ENT:Initialize()

    self:SetModel( "models/maxofs2d/button_05.mdl" )

    if ( SERVER ) then
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetUseType( ONOFF_USE )

    else
        self.PosePosition = 0

    end

end

function ENT:GetOverlayText()
    return "(The button that kills you.)"

end

function ENT:Use( activator, caller, type, value )

    if activator.PressingTheButtonThatKillsYou then return end
    if ( IsValid( self.LastUser ) ) then return end -- Someone is already using this button

    --
    -- Switch off
    --
    if ( self:GetPressed() ) then
        self:Toggle( false, activator )
        return
    end

    --
    -- Switch on
    --

    if not self:GetPressed() then
        self:KillYou( activator )

    end

    self:Toggle( true, activator )
    self:NextThink( CurTime() )
    self.LastUser = activator
end

function ENT:Think()

    -- Add a world tip if the player is looking at it
    self.BaseClass.Think( self )

    -- Update the animation
    if ( CLIENT ) then

        self:UpdateLever()

    end

    --
    -- If the player looks away while holding down use it will stay on
    -- Lets fix that..
    --
    if ( SERVER && self:GetPressed() ) then

        if ( !IsValid( self.LastUser ) || !self.LastUser:KeyDown( IN_USE ) ) then

            self:Toggle( false, self.LastUser )
            self.LastUser = nil

        end

        self:NextThink( CurTime() )

    end

end

--
-- Makes the button trigger the keys
--
function ENT:Toggle( bEnable )
    if ( bEnable ) then
        self:SetPressed( true )

    else
        self:SetPressed( false )

    end
end

--
-- Update the lever animation
--
function ENT:UpdateLever()

    local TargetPos = 0.0
    if ( self:GetPressed() ) then
        self.PosePosition = 1
        TargetPos = 1.0

    end

    self.PosePosition = math.Approach( self.PosePosition, TargetPos, FrameTime() )

    self:SetPoseParameter( "switch", self.PosePosition )
    self:InvalidateBoneCache()

end

if !SERVER then return end

ENT.Chunks = {
    "physics/body/body_medium_break2.wav",
    "physics/body/body_medium_break3.wav",
    "physics/body/body_medium_break4.wav",
}
ENT.Whaps = {
    "physics/body/body_medium_impact_hard1.wav",
    "physics/body/body_medium_impact_hard2.wav",
    "physics/body/body_medium_impact_hard3.wav",
}
function ENT:KillYou( toKill )
    self:EmitSound( "plats/elevator_stop1.wav", 90, 120 )
    toKill.PressingTheButtonThatKillsYou = true
    timer.Simple( 0.5, function()
        if !IsValid( toKill ) then return end
        toKill.PressingTheButtonThatKillsYou = nil
        util.ScreenShake( toKill:GetPos(), 16, 20, 0.4, 3000 )
        util.ScreenShake( toKill:GetPos(), 1, 20, 2, 8000 )

        local killer = self or toKill

        local dmgInfo = DamageInfo()
        dmgInfo:SetDamage( math.huge )
        dmgInfo:SetDamageForce( Vector( 0,0,-1000000000 ) )
        dmgInfo:SetAttacker( killer )
        dmgInfo:SetInflictor( killer )
        toKill:TakeDamageInfo( dmgInfo )

        if !IsValid( self ) then return end
        for _ = 1, 3 do
            toKill:EmitSound( table.Random( self.Chunks ), 100, math.random( 115, 120 ), 1, CHAN_STATIC )
            toKill:EmitSound( table.Random( self.Whaps ), 75, math.random( 115, 120 ), 1, CHAN_STATIC )

        end
    end )
end