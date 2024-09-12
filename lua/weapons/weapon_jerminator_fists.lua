AddCSLuaFile()

SWEP.Base = "weapon_terminatorfists_term"
DEFINE_BASECLASS( SWEP.Base )

SWEP.PrintName = "Jerminator Fists"
SWEP.Spawnable = false
SWEP.Author = "StrawWagen"
SWEP.Purpose = "Innate weapon that the jerminator uses"

local className = "weapon_jerminator_fists"
if CLIENT then
    language.Add( className, SWEP.PrintName )
    killicon.Add( className, "vgui/hud/killicon/" .. className .. ".png", color_white )

else
    local doFastDl = CreateConVar( "jerminator_fastdlkillicon", 1, { FCVAR_ARCHIVE }, "Toggle the killicon fastdl." )
    if doFastDl:GetBool() then
        resource.AddFile( "materials/vgui/hud/killicon/" .. className .. ".png" )

    end
end