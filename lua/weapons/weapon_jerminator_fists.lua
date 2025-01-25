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

end

function SWEP:HoldTypeThink()
    local owner = self:GetOwner()
    if not IsValid( owner ) then return end
    if not owner.GetEnemy then return end
    local enemy = owner:GetEnemy()
    local holdType = "normal"
    local doFistsTime = self.doFistsTime

    local path = owner:GetPath()

    if doFistsTime > CurTime() then
        holdType = "fist"

    elseif owner:IsReallyAngry() then
        holdType = "fist"

    elseif IsValid( enemy ) and enemy.isTerminatorHunterKiller then
        holdType = "fist"
        doFistsTime = math.max( doFistsTime, CurTime() + 10 )

    elseif IsValid( enemy ) and owner.DistToEnemy and owner.DistToEnemy < self.Range * 4 then
        holdType = "fist"

    elseif owner:getLostHealth() > 0.01 then
        holdType = "fist"
        doFistsTime = math.max( doFistsTime, CurTime() + 10 )

    elseif IsValid( enemy ) and path and path:GetEnd() and path:GetEnd():DistToSqr( enemy:GetPos() ) < 1000^2 and path:GetLength() < 1000 then
        holdType = "fist"
        doFistsTime = math.max( doFistsTime, CurTime() + 3 )

    end

    self.doFistsTime = doFistsTime
    local oldHoldType = self.oldHoldType

    if not oldHoldType or oldHoldType ~= holdType then
        self:SetHoldType( holdType )
        self.oldHoldType = holdType

    end
end